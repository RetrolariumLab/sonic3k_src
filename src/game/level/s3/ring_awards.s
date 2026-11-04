; Owner: game/level/s3
; Responsibility: Saturating ring awards, extra-life thresholds, HUD updates and award sound selection
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AddRings:
                lea     (Ring_count).w,a2
                lea     (Update_HUD_ring_count).w,a3
                lea     (Extra_life_flags).w,a4
                lea     (Total_ring_count).w,a5
                move.w  #999,d1
                add.w   d0,(a5)
                cmp.w   (a5),d1
                bhs.s   S3Level_CapLiveRingCount
                move.w  d1,(a5)

S3Level_CapLiveRingCount:
                add.w   d0,(a2)
                cmp.w   (a2),d1
                bhs.s   S3Level_FlagRingsAndCheckLives
                move.w  d1,(a2)

S3Level_FlagRingsAndCheckLives:
                ori.b   #1,(a3)
                cmpi.w  #100,(a2)
                blo.s   S3Level_PlayRingSoundWithoutExtraLife
                bset    #1,(a4)
                beq.s   S3Level_IncrementLivesAndMonitorCounter
                cmpi.w  #200,(a2)
                blo.s   S3Level_PlayRingSoundWithoutExtraLife
                bset    #2,(a4)
                beq.s   S3Level_IncrementLivesAndMonitorCounter

S3Level_PlayRingSoundWithoutExtraLife:
                moveq   #signextendB(sfx_RingRight),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

S3Level_IncrementLivesAndMonitorCounter:
                addq.w  #1,(Monitors_broken).w          ; Add an extra life
                addq.b  #1,(Life_count).w
                addq.b  #1,(Update_HUD_life_count).w
                moveq   #signextendB(mus_ExtraLife),d0
                jmp     (Play_Music).l
; End of function AddRings
