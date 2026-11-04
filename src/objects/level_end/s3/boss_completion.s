; Owner: objects/level_end/s3
; Responsibility: Emerald-dependent player completion state and boss defeat score or timer setup
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
GetS3LBZEndingCharacterVariant:
                move.w  (Player_mode).w,d0
                cmpi.w  #2,d0
                beq.s   S3LevelEnd_EndingVariantReturnTailsIndex
                cmpi.w  #7,(Chaos_emerald_count).w
                beq.s   S3LevelEnd_ReturnAllEmeraldEnding
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

S3LevelEnd_EndingVariantReturnTailsIndex:
                moveq   #1,d0
                rts
; ---------------------------------------------------------------------------

S3LevelEnd_ReturnAllEmeraldEnding:
                moveq   #2,d0
                rts

; =============== S U B R O U T I N E =======================================

BossDefeated_StopTimer:
                clr.b   (Update_HUD_timer).w
; End of function BossDefeated_StopTimer

; =============== S U B R O U T I N E =======================================

BossDefeated:
                move.w  #$3F,$2E(a0)
                moveq   #100,d0
                jsr     (HUD_AddToScore).l
                bclr    #7,render_flags(a0)
                rts
; End of function BossDefeated
