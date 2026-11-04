; Owner: objects/runtime/s3
; Responsibility: Vertical and horizontal oscillation and counted swing motion helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Swing_UpAndDown:
                move.w  $40(a0),d0                      ; Acceleration
                move.w  y_vel(a0),d1                    ; Velocity
                move.w  $3E(a0),d2                      ; Maximum acceleration before "swinging"
                moveq   #0,d3
                btst    #0,$38(a0)
                bne.s   S3RuntimeSwing_ApplyDownwardSwingStepAndUndoUpperBoundaryCrossing
                neg.w   d0                              ; Apply upward acceleration
                add.w   d0,d1
                neg.w   d2
                cmp.w   d2,d1
                bgt.s   S3RuntimeSwing_CommitVerticalSwingVelocityWithSeparateEventRegister
                bset    #0,$38(a0)
                neg.w   d0
                neg.w   d2
                moveq   #1,d3

S3RuntimeSwing_ApplyDownwardSwingStepAndUndoUpperBoundaryCrossing:
                add.w   d0,d1                           ; Apply downward acceleration
                cmp.w   d2,d1
                blt.s   S3RuntimeSwing_CommitVerticalSwingVelocityWithSeparateEventRegister
                bclr    #0,$38(a0)
                neg.w   d0
                add.w   d0,d1
                moveq   #1,d3

S3RuntimeSwing_CommitVerticalSwingVelocityWithSeparateEventRegister:
                move.w  d1,y_vel(a0)
                rts
; End of function Swing_UpAndDown

; =============== S U B R O U T I N E =======================================

Swing_LeftAndRight:
                move.w  $3C(a0),d0
                move.w  x_vel(a0),d1
                move.w  $3A(a0),d2
                moveq   #0,d3
                btst    #3,$38(a0)
                bne.s   S3RuntimeSwing_ApplyPositiveHorizontalSwingStepAndUndoUpperCrossing
                neg.w   d0
                add.w   d0,d1
                neg.w   d2
                cmp.w   d2,d1
                bgt.s   S3RuntimeSwing_CommitHorizontalSwingVelocityWithSeparateEventRegister
                bset    #3,$38(a0)
                neg.w   d0
                neg.w   d2
                moveq   #1,d3

S3RuntimeSwing_ApplyPositiveHorizontalSwingStepAndUndoUpperCrossing:
                add.w   d0,d1
                cmp.w   d2,d1
                blt.s   S3RuntimeSwing_CommitHorizontalSwingVelocityWithSeparateEventRegister
                bclr    #3,$38(a0)
                neg.w   d0
                add.w   d0,d1
                moveq   #1,d3

S3RuntimeSwing_CommitHorizontalSwingVelocityWithSeparateEventRegister:
                move.w  d1,x_vel(a0)
                rts
; End of function Swing_LeftAndRight

; =============== S U B R O U T I N E =======================================

Swing_UpAndDown_Count:
                bsr.w   Swing_UpAndDown
                tst.w   d3
                beq.s   S3RuntimeSwing_ReturnCountedSwingNativeZeroOrCompletionCondition
                move.b  $39(a0),d2
                subq.b  #1,d2
                move.b  d2,$39(a0)
                bmi.s   S3RuntimeSwing_ReturnCountedSwingCompletionForNegativeCounterByte
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

S3RuntimeSwing_ReturnCountedSwingCompletionForNegativeCounterByte:
                moveq   #1,d0

S3RuntimeSwing_ReturnCountedSwingNativeZeroOrCompletionCondition:
                rts
; End of function Swing_UpAndDown_Count
