; Owner: game/modes/ending/sk
; Responsibility: Choose credit scroll speed and delay from product, region, character and emerald completion state
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Index the 36-record tables by product, region, character and emerald completion
SKCredits_SelectScrollSpeedAndDelay:
                moveq   #0,d1
                tst.w   (SK_alone_flag).w
                bne.s   SKCreditScroll_AddRegionGroupStride
                addi.w  #$24,d1

SKCreditScroll_AddRegionGroupStride:
                btst    #6,(Graphics_flags).w
                beq.s   SKCreditScroll_SelectCharacterGroup
                addi.w  #$12,d1

SKCreditScroll_SelectCharacterGroup:
                move.w  (Player_mode).w,d0
                subq.w  #2,d0
                bmi.s   SKCreditScroll_SelectSignedEndingOutcome
                beq.s   SKCreditScroll_AddCharacterGroupStride
                addi.w  #6,d1

SKCreditScroll_AddCharacterGroupStride:
                addi.w  #6,d1

SKCreditScroll_SelectSignedEndingOutcome:
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                bmi.s   SKCreditScroll_LoadSpeedAndDelay
                beq.s   SKCreditScroll_AddZeroOutcomeOffset
                addq.w  #2,d1

SKCreditScroll_AddZeroOutcomeOffset:
                addq.w  #2,d1

SKCreditScroll_LoadSpeedAndDelay:
                lea     CreditsText_ScrollSpeed(pc),a1
                moveq   #0,d0
                move.w  (a1,d1.w),d0
                lsl.l   #8,d0
                move.l  d0,(EndingCreditsFixedPointScrollIncrement).w
                lea     CreditsText_ScrollDelay(pc),a1
                move.w  (a1,d1.w),(CreditsDelayOrSegaCompletionLatch).w
                rts
; End of function SKCredits_SelectScrollSpeedAndDelay
