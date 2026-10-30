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
                bhs.s   locret_11DDA
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$20,d0
                asr.l   #8,d0
                tst.w   ground_vel(a0)
                beq.s   loc_11DDC
                bmi.s   loc_11DD6
                tst.w   d0
                beq.s   locret_11DD4
                add.w   d0,ground_vel(a0)

locret_11DD4:
                rts
; ---------------------------------------------------------------------------

loc_11DD6:
                add.w   d0,ground_vel(a0)

locret_11DDA:
                rts
; ---------------------------------------------------------------------------

loc_11DDC:
                move.w  d0,d1
                bpl.s   loc_11DE2
                neg.w   d1

loc_11DE2:
                cmpi.w  #$D,d1
                blo.s   locret_11DDA
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
                bhs.s   locret_11E28
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$50,d0
                asr.l   #8,d0
                tst.w   ground_vel(a0)
                bmi.s   loc_11E1E
                tst.w   d0
                bpl.s   loc_11E18
                asr.l   #2,d0

loc_11E18:
                add.w   d0,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_11E1E:
                tst.w   d0
                bmi.s   loc_11E24
                asr.l   #2,d0

loc_11E24:
                add.w   d0,ground_vel(a0)

locret_11E28:
                rts
; End of function Player_RollRepel

; ---------------------------------------------------------------------------
; Subroutine to push Sonic down a slope
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_SlopeRepel:
                nop
                tst.b   stick_to_convex(a0)
                bne.s   locret_11E6E
                tst.w   move_lock(a0)
                bne.s   loc_11E86
                move.b  angle(a0),d0
                addi.b  #$18,d0
                cmpi.b  #$30,d0
                blo.s   locret_11E6E
                move.w  ground_vel(a0),d0
                bpl.s   loc_11E4E
                neg.w   d0

loc_11E4E:
                cmpi.w  #$280,d0
                bhs.s   locret_11E6E
                move.w  #30,move_lock(a0)
                move.b  angle(a0),d0
                addi.b  #$30,d0
                cmpi.b  #$60,d0
                blo.s   loc_11E70
                bset    #Status_InAir,status(a0)

locret_11E6E:
                rts
; ---------------------------------------------------------------------------

loc_11E70:
                cmpi.b  #$30,d0
                blo.s   loc_11E7E
                addi.w  #$80,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_11E7E:
                subi.w  #$80,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_11E86:
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
                bpl.s   loc_11E9C                       ; if higher than 0, branch

                addq.b  #2,d0                           ; increase angle
                bcc.s   loc_11E9A
                moveq   #0,d0

loc_11E9A:
                bra.s   Player_JumpAngleSet
; ---------------------------------------------------------------------------

loc_11E9C:
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
                beq.s   locret_11EEA
                tst.w   ground_vel(a0)
                bmi.s   Player_JumpLeftFlip

Player_JumpRightFlip:
                move.b  flip_speed(a0),d1
                add.b   d1,d0
                bcc.s   loc_11EC8
                subq.b  #1,flips_remaining(a0)
                bcc.s   loc_11EC8
                move.b  #0,flips_remaining(a0)
                moveq   #0,d0

loc_11EC8:
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

locret_11EEA:
                rts
; End of function Player_JumpAngle
