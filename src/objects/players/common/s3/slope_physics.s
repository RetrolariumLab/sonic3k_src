; Owner: objects/players/common/s3
; Responsibility: Shared slope resistance, rolling repulsion, slope detachment and airborne angle normalization
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Subroutine to slow Sonic walking up a slope
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_SlopeResist:
                move.b  angle(a0),d0
                addi.b  #$60,d0
                cmpi.b  #-$40,d0
                bhs.s   S3PlayerSlope_ReturnAfterSlopeAngleOrRestingForceGate
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$20,d0
                asr.l   #8,d0
                tst.w   ground_vel(a0)
                beq.s   S3PlayerSlope_TakeSlopeForceMagnitudeForRestingActor
                bmi.s   S3PlayerSlope_ApplySlopeResistanceToNegativeGroundVelocity
                tst.w   d0
                beq.s   S3PlayerSlope_ReturnAfterPositiveSpeedSlopeResistance
                add.w   d0,ground_vel(a0)

S3PlayerSlope_ReturnAfterPositiveSpeedSlopeResistance:
                rts
; ---------------------------------------------------------------------------

S3PlayerSlope_ApplySlopeResistanceToNegativeGroundVelocity:
                add.w   d0,ground_vel(a0)

S3PlayerSlope_ReturnAfterSlopeAngleOrRestingForceGate:
                rts
; ---------------------------------------------------------------------------

S3PlayerSlope_TakeSlopeForceMagnitudeForRestingActor:
                move.w  d0,d1
                bpl.s   S3PlayerSlope_StartRestingSlopeMotionAtForceMagnitudeThirteen
                neg.w   d1

S3PlayerSlope_StartRestingSlopeMotionAtForceMagnitudeThirteen:
                cmpi.w  #$D,d1
                blo.s   S3PlayerSlope_ReturnAfterSlopeAngleOrRestingForceGate
                add.w   d0,ground_vel(a0)
                rts
; End of function Player_SlopeResist

; ---------------------------------------------------------------------------
; Subroutine to push Sonic down a slope while he's rolling
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_RollRepel:
                move.b  angle(a0),d0
                addi.b  #$60,d0
                cmpi.b  #-$40,d0
                bhs.s   S3PlayerSlope_ReturnAfterRollingSlopeGateOrForceAddition
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$50,d0
                asr.l   #8,d0
                tst.w   ground_vel(a0)
                bmi.s   S3PlayerSlope_ScaleOpposingRollingSlopeForceForNegativeGroundSpeed
                tst.w   d0
                bpl.s   S3PlayerSlope_ApplyRollingSlopeForceForNonnegativeGroundSpeed
                asr.l   #2,d0

S3PlayerSlope_ApplyRollingSlopeForceForNonnegativeGroundSpeed:
                add.w   d0,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3PlayerSlope_ScaleOpposingRollingSlopeForceForNegativeGroundSpeed:
                tst.w   d0
                bmi.s   S3PlayerSlope_AddSelectedRollingSlopeForceToGroundVelocity
                asr.l   #2,d0

S3PlayerSlope_AddSelectedRollingSlopeForceToGroundVelocity:
                add.w   d0,ground_vel(a0)

S3PlayerSlope_ReturnAfterRollingSlopeGateOrForceAddition:
                rts
; End of function Player_RollRepel

; ---------------------------------------------------------------------------
; Subroutine to push Sonic down a slope
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_SlopeRepel:
                nop
                tst.b   stick_to_convex(a0)
                bne.s   S3PlayerSlope_ReturnAfterSlopeRepulsionGateOrAirDetach
                tst.w   move_lock(a0)
                bne.s   S3PlayerSlope_CountDownExistingSlopeMovementLock
                move.b  angle(a0),d0
                addi.b  #$18,d0
                cmpi.b  #$30,d0
                blo.s   S3PlayerSlope_ReturnAfterSlopeRepulsionGateOrAirDetach
                move.w  ground_vel(a0),d0
                bpl.s   S3PlayerSlope_DetachOrNudgeSlowActorOnNonflatSlope
                neg.w   d0

S3PlayerSlope_DetachOrNudgeSlowActorOnNonflatSlope:
                cmpi.w  #$280,d0
                bhs.s   S3PlayerSlope_ReturnAfterSlopeRepulsionGateOrAirDetach
                move.w  #30,move_lock(a0)
                move.b  angle(a0),d0
                addi.b  #$30,d0
                cmpi.b  #$60,d0
                blo.s   S3PlayerSlope_ChooseSlowSlopeNudgeByWrappedAngleSector
                bset    #Status_InAir,status(a0)

S3PlayerSlope_ReturnAfterSlopeRepulsionGateOrAirDetach:
                rts
; ---------------------------------------------------------------------------

S3PlayerSlope_ChooseSlowSlopeNudgeByWrappedAngleSector:
                cmpi.b  #$30,d0
                blo.s   S3PlayerSlope_NudgeSlowSlopeGroundVelocityNegative
                addi.w  #$80,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3PlayerSlope_NudgeSlowSlopeGroundVelocityNegative:
                subi.w  #$80,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3PlayerSlope_CountDownExistingSlopeMovementLock:
                subq.w  #1,move_lock(a0)
                rts
; End of function Player_SlopeRepel

; ---------------------------------------------------------------------------
; Subroutine to return Sonic's angle to 0 as he jumps
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_JumpAngle:
                move.b  angle(a0),d0                    ; get Sonic's angle
                beq.s   Player_JumpFlip                 ; if already 0, branch
                bpl.s   S3PlayerSlope_ReducePositiveAirAngleByTwoWithBorrowClamp  ; if higher than 0, branch

                addq.b  #2,d0                           ; increase angle
                bcc.s   S3PlayerSlope_StoreNegativeAngleRecoveryAfterByteCarryClamp
                moveq   #0,d0

S3PlayerSlope_StoreNegativeAngleRecoveryAfterByteCarryClamp:
                bra.s   Player_JumpAngleSet
; ---------------------------------------------------------------------------

S3PlayerSlope_ReducePositiveAirAngleByTwoWithBorrowClamp:
                subq.b  #2,d0                           ; decrease angle
                bcc.s   Player_JumpAngleSet
                moveq   #0,d0

Player_JumpAngleSet:
                move.b  d0,angle(a0)
; End of function Player_JumpAngle
; continue straight to Player_JumpFlip

; ---------------------------------------------------------------------------
; Updates Sonic's secondary angle if he's tumbling
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_JumpFlip:
                move.b  flip_angle(a0),d0
                beq.s   S3PlayerSlope_ReturnAfterFlipAngleZeroOrStoredUpdate
                tst.w   ground_vel(a0)
                bmi.s   Player_JumpLeftFlip

Player_JumpRightFlip:
                move.b  flip_speed(a0),d1
                add.b   d1,d0
                bcc.s   S3PlayerSlope_StoreAddedFlipAngleAfterWrapBudgetHandling
                subq.b  #1,flips_remaining(a0)
                bcc.s   S3PlayerSlope_StoreAddedFlipAngleAfterWrapBudgetHandling
                move.b  #0,flips_remaining(a0)
                moveq   #0,d0

S3PlayerSlope_StoreAddedFlipAngleAfterWrapBudgetHandling:
                bra.s   Player_JumpFlipSet
; ---------------------------------------------------------------------------

Player_JumpLeftFlip:
                tst.b   flip_type(a0)
                bmi.s   Player_JumpRightFlip
                move.b  flip_speed(a0),d1
                sub.b   d1,d0
                bcc.s   Player_JumpFlipSet
                subq.b  #1,flips_remaining(a0)
                bcc.s   Player_JumpFlipSet
                move.b  #0,flips_remaining(a0)
                moveq   #0,d0

Player_JumpFlipSet:
                move.b  d0,flip_angle(a0)

S3PlayerSlope_ReturnAfterFlipAngleZeroOrStoredUpdate:
                rts
; End of function Player_JumpAngle
