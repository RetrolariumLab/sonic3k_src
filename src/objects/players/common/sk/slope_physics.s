; Owner: objects/players/common/sk
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
                bhs.s   SKPlayerSlope_ResistReturn
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$20,d0
                asr.l   #8,d0
                tst.w   ground_vel(a0)
                beq.s   SKPlayerSlope_AbsRestingForce
                bmi.s   SKPlayerSlope_ResistNegativeSpeed
                tst.w   d0
                beq.s   SKPlayerSlope_ResistPositiveReturn
                add.w   d0,ground_vel(a0)

SKPlayerSlope_ResistPositiveReturn:
                rts
; ---------------------------------------------------------------------------

SKPlayerSlope_ResistNegativeSpeed:
                add.w   d0,ground_vel(a0)

SKPlayerSlope_ResistReturn:
                rts
; ---------------------------------------------------------------------------

SKPlayerSlope_AbsRestingForce:
                move.w  d0,d1
                bpl.s   SKPlayerSlope_ApplyRestingForceAt13
                neg.w   d1

; The threshold uses the force magnitude. The ground velocity receives the signed force
SKPlayerSlope_ApplyRestingForceAt13:
                cmpi.w  #$D,d1
                blo.s   SKPlayerSlope_ResistReturn
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
                bhs.s   SKPlayerSlope_RollRepelReturn
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$50,d0
                asr.l   #8,d0
                tst.w   ground_vel(a0)
                bmi.s   SKPlayerSlope_ScaleRollForceAgainstNeg
                tst.w   d0
                bpl.s   SKPlayerSlope_ApplyRollForceToPosSpeed
                asr.l   #2,d0

SKPlayerSlope_ApplyRollForceToPosSpeed:
                add.w   d0,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

; Quarter the opposing force before adding it to negative ground speed
SKPlayerSlope_ScaleRollForceAgainstNeg:
                tst.w   d0
                bmi.s   SKPlayerSlope_ApplyRollForceToNegSpeed
                asr.l   #2,d0

SKPlayerSlope_ApplyRollForceToNegSpeed:
                add.w   d0,ground_vel(a0)

SKPlayerSlope_RollRepelReturn:
                rts
; End of function Player_RollRepel

; ---------------------------------------------------------------------------
; Subroutine to push Sonic down a slope
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_SlopeRepel:
                nop
                tst.b   stick_to_convex(a0)
                bne.s   SKPlayerSlope_RepelReturn
                tst.w   move_lock(a0)
                bne.s   SKPlayerSlope_TickMoveLock
                move.b  angle(a0),d0
                addi.b  #$18,d0
                cmpi.b  #$30,d0
                blo.s   SKPlayerSlope_RepelReturn
                move.w  ground_vel(a0),d0
                bpl.s   SKPlayerSlope_RepelSlowPlayer
                neg.w   d0

; Speeds below $280 trigger a 30-frame movement lock and an angle-dependent nudge or detach
SKPlayerSlope_RepelSlowPlayer:
                cmpi.w  #$280,d0
                bhs.s   SKPlayerSlope_RepelReturn
                move.w  #30,move_lock(a0)
                move.b  angle(a0),d0
                addi.b  #$30,d0
                cmpi.b  #$60,d0
                blo.s   SKPlayerSlope_ChooseNudgeDirection
                bset    #Status_InAir,status(a0)

SKPlayerSlope_RepelReturn:
                rts
; ---------------------------------------------------------------------------

SKPlayerSlope_ChooseNudgeDirection:
                cmpi.b  #$30,d0
                blo.s   SKPlayerSlope_NudgeGroundSpeedNegative
                addi.w  #$80,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKPlayerSlope_NudgeGroundSpeedNegative:
                subi.w  #$80,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKPlayerSlope_TickMoveLock:
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
                bpl.s   SKPlayerSlope_ReducePositiveAirAngleBy2  ; if higher than 0, branch

                addq.b  #2,d0                           ; increase angle
                bcc.s   SKPlayerSlope_StoreRecoveredNegAngle
                moveq   #0,d0

SKPlayerSlope_StoreRecoveredNegAngle:
                bra.s   Player_JumpAngleSet
; ---------------------------------------------------------------------------

SKPlayerSlope_ReducePositiveAirAngleBy2:
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
                beq.s   SKPlayerSlope_JumpFlipReturn
                tst.w   ground_vel(a0)
                bmi.s   Player_JumpLeftFlip

Player_JumpRightFlip:
                move.b  flip_speed(a0),d1
                add.b   d1,d0
                bcc.s   SKPlayerSlope_StoreRightFlipAngle
                subq.b  #1,flips_remaining(a0)
                bcc.s   SKPlayerSlope_StoreRightFlipAngle
                move.b  #0,flips_remaining(a0)
                moveq   #0,d0

SKPlayerSlope_StoreRightFlipAngle:
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

SKPlayerSlope_JumpFlipReturn:
                rts
; End of function Player_JumpAngle
