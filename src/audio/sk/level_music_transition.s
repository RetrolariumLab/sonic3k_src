; Owner: audio/sk
; Responsibility: Fade transition actors and invincibility-aware level music restoration
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Song_Fade_ToLevelMusic:
                move.w  #2*60,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.l  #SKLevelMusic_WaitForFadeThenRestoreLevelAndDelete,(a0)

SKLevelMusic_WaitForFadeThenRestoreLevelAndDelete:
                subq.w  #1,$2E(a0)
                bpl.w   locret_8405E
                bsr.w   Restore_LevelMusic
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_Song_Fade_Transition:
                move.w  #90,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.l  #SKLevelMusic_WaitNinetyTimerThenLatchSubtypeMusicAndDelete,(a0)

SKLevelMusic_WaitNinetyTimerThenLatchSubtypeMusicAndDelete:
                subq.w  #1,$2E(a0)
                bpl.w   locret_8405E
                move.b  subtype(a0),d0
                move.b  d0,(Current_music+1).w
                jsr     (Play_Music).l
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

Restore_LevelMusic:
                moveq   #0,d0
                lea     (Apparent_zone_and_act).w,a1
                move.b  (a1)+,d0
                add.b   d0,d0
                add.b   (a1),d0
                lea     (LevelMusic_Playlist).l,a2
                move.b  (a2,d0.w),d0
                move.w  d0,(Current_music).w
                btst    #Status_Invincible,(Player_1+status_secondary).w
                beq.s   SKLevelMusic_TailPlayLevelOrInvincibilityOverride
                moveq   #signextendB(mus_Invincibility),d0  ; If invincible, play invincibility

SKLevelMusic_TailPlayLevelOrInvincibilityOverride:
                jmp     (Play_Music).l
; End of function Restore_LevelMusic
