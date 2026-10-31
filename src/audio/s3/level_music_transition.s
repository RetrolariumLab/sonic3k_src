; Owner: audio/s3
; Responsibility: Fade transition actors, invincibility-aware level music restoration and zone playlist
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Song_Fade_ToLevelMusic:
                move.w  #2*60,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.l  #loc_54048,(a0)

loc_54048:
                subq.w  #1,$2E(a0)
                bpl.w   locret_529CE
                bsr.w   Restore_LevelMusic
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_Song_Fade_Transition:
                move.w  #2*60,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.l  #loc_5406E,(a0)

loc_5406E:
                subq.w  #1,$2E(a0)
                bpl.w   locret_529CE
                move.b  subtype(a0),d0
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
                move.w  d0,(Current_music).w
                btst    #Status_Invincible,(Player_1+status_secondary).w
                beq.s   loc_540A4
                moveq   #signextendB(mus_Invincibility),d0  ; If invincible, play invincibility

loc_540A4:
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
