; Owner: audio/s3
; Responsibility: Fade transition actors, invincibility-aware level music restoration and zone playlist
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Song_Fade_ToLevelMusic:
                move.w  #2*60,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.l  #S3LevelMusic_WaitToRestore,(a0)

S3LevelMusic_WaitToRestore:
                subq.w  #1,$2E(a0)
                bpl.w   S3RuntimeChildren_ReturnAfterAttributeSetupOrSharedEarlyExit
                bsr.w   Restore_LevelMusic
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_Song_Fade_Transition:
                move.w  #2*60,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.l  #S3LevelMusic_WaitToPlaySubtype,(a0)

S3LevelMusic_WaitToPlaySubtype:
                subq.w  #1,$2E(a0)
                bpl.w   S3RuntimeChildren_ReturnAfterAttributeSetupOrSharedEarlyExit
                move.b  subtype(a0),d0
; Play the subtype track without changing Current_music
                jsr     (Play_Music).l
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

Restore_LevelMusic:
                moveq   #0,d0
                lea     (Apparent_zone_and_act).w,a1
                move.b  (a1)+,d0
                add.b   d0,d0
                add.b   (a1),d0
                move.b  PlayLevelMusic_Playlist(pc,d0.w),d0
; Keep the level track in Current_music even when invincibility music plays
                move.w  d0,(Current_music).w
                btst    #Status_Invincible,(Player_1+status_secondary).w
                beq.s   S3LevelMusic_PlaySelected
                moveq   #signextendB(mus_Invincibility),d0  ; If invincible, play invincibility

S3LevelMusic_PlaySelected:
                jmp     (Play_Music).l
; End of function Restore_LevelMusic

; ---------------------------------------------------------------------------
PlayLevelMusic_Playlist:
                dc.b    mus_AIZ1, mus_AIZ2
                dc.b    mus_HCZ1, mus_HCZ2
                dc.b    mus_MGZ1, mus_MGZ2
                dc.b    mus_CNZ1, mus_CNZ2
                dc.b    mus_FBZ1, mus_FBZ2
                dc.b    mus_ICZ1, mus_ICZ2
                dc.b    mus_LBZ1, mus_LBZ2
