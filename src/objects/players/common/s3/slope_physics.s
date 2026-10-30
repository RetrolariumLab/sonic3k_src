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
                bhs.s   locret_12D00
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$20,d0
                asr.l   #8,d0
                tst.w   ground_vel(a0)
                beq.s   loc_12D02
                bmi.s   loc_12CFC
                tst.w   d0
                beq.s   locret_12CFA
                add.w   d0,ground_vel(a0)

locret_12CFA:
                rts
; ---------------------------------------------------------------------------

loc_12CFC:
                add.w   d0,ground_vel(a0)

locret_12D00:
                rts
; ---------------------------------------------------------------------------

loc_12D02:
                move.w  d0,d1
                bpl.s   loc_12D08
                neg.w   d1

loc_12D08:
                cmpi.w  #$D,d1
                blo.s   locret_12D00
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
                bhs.s   locret_12D4E
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$50,d0
                asr.l   #8,d0
                tst.w   ground_vel(a0)
                bmi.s   loc_12D44
                tst.w   d0
                bpl.s   loc_12D3E
                asr.l   #2,d0

loc_12D3E:
                add.w   d0,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_12D44:
                tst.w   d0
                bmi.s   loc_12D4A
                asr.l   #2,d0

loc_12D4A:
                add.w   d0,ground_vel(a0)

locret_12D4E:
                rts
; End of function Player_RollRepel

; ---------------------------------------------------------------------------
; Subroutine to push Sonic down a slope
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_SlopeRepel:
                nop
                tst.b   stick_to_convex(a0)
                bne.s   locret_12D94
                tst.w   move_lock(a0)
                bne.s   loc_12DAC
                move.b  angle(a0),d0
                addi.b  #$18,d0
                cmpi.b  #$30,d0
                blo.s   locret_12D94
                move.w  ground_vel(a0),d0
                bpl.s   loc_12D74
                neg.w   d0

loc_12D74:
                cmpi.w  #$280,d0
                bhs.s   locret_12D94
                move.w  #30,move_lock(a0)
                move.b  angle(a0),d0
                addi.b  #$30,d0
                cmpi.b  #$60,d0
                blo.s   loc_12D96
                bset    #Status_InAir,status(a0)

locret_12D94:
                rts
; ---------------------------------------------------------------------------

loc_12D96:
                cmpi.b  #$30,d0
                blo.s   loc_12DA4
                addi.w  #$80,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_12DA4:
                subi.w  #$80,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_12DAC:
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
                bpl.s   loc_12DC2                       ; if higher than 0, branch

                addq.b  #2,d0                           ; increase angle
                bcc.s   loc_12DC0
                moveq   #0,d0

loc_12DC0:
                bra.s   Player_JumpAngleSet
; ---------------------------------------------------------------------------

loc_12DC2:
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
                beq.s   locret_12E10
                tst.w   ground_vel(a0)
                bmi.s   Player_JumpLeftFlip

Player_JumpRightFlip:
                move.b  flip_speed(a0),d1
                add.b   d1,d0
                bcc.s   loc_12DEE
                subq.b  #1,flips_remaining(a0)
                bcc.s   loc_12DEE
                move.b  #0,flips_remaining(a0)
                moveq   #0,d0

loc_12DEE:
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

locret_12E10:
                rts
; End of function Player_JumpAngle
