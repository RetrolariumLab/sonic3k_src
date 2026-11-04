; Owner: objects/players/tails/s3
; Responsibility: Tails spindash charge, slope resistance, rolling repulsion, slope detachment and airborne angle control
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   S3TailsSpin_ReleaseOrKeepCharging
                cmpi.b  #8,anim(a0)
                bne.s   S3TailsSpin_EntryReturn
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3TailsSpin_EntryReturn
                move.b  #9,anim(a0)
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addq.l  #4,sp
                move.b  #1,spin_dash_flag(a0)
                move.w  #0,spin_dash_counter(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   S3TailsSpin_CheckEntryBoundsAndTerrain
                move.b  #2,anim(a6)

S3TailsSpin_CheckEntryBoundsAndTerrain:
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Player_AnglePos
                tst.b   (Background_collision_flag).w
                beq.s   S3TailsSpin_EntryReturn
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                movem.l (sp)+,a4-a6
                tst.w   d1
                bpl.s   S3TailsSpin_EntryReturn
                sub.w   d1,x_pos(a0)

S3TailsSpin_EntryReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsSpin_ReleaseOrKeepCharging:
                move.b  (Ctrl_2_held_logical).w,d0
                btst    #button_down,d0
                bne.w   S3TailsSpin_DecayHeldCharge
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #1,y_pos(a0)
                move.b  #0,spin_dash_flag(a0)
                moveq   #0,d0
                move.b  spin_dash_counter(a0),d0
                add.w   d0,d0
                move.w  S3TailsSpin_NormalSpeedByChargeHi(pc,d0.w),ground_vel(a0)
                move.w  ground_vel(a0),d0
                subi.w  #$800,d0
                add.w   d0,d0
                andi.w  #$1F00,d0
                neg.w   d0
                addi.w  #$2000,d0
                lea     (H_scroll_frame_offset).w,a1
                cmpa.w  #Player_1,a0
                beq.s   S3TailsSpin_StoreLagAndApplyFacing
                lea     (H_scroll_frame_offset_P2).w,a1

S3TailsSpin_StoreLagAndApplyFacing:
                move.w  d0,(a1)
                btst    #Status_Facing,status(a0)
                beq.s   S3TailsSpin_BeginRollAndStopDust
                neg.w   ground_vel(a0)

S3TailsSpin_BeginRollAndStopDust:
                bset    #Status_Roll,status(a0)
                move.b  #0,anim(a6)
                move.w  #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   S3TailsSpin_SkipGroundAndEaseCamera
; ---------------------------------------------------------------------------
S3TailsSpin_NormalSpeedByChargeHi:
                dc.w    $800
                dc.w    $880
                dc.w    $900
                dc.w    $980
                dc.w    $A00
                dc.w    $A80
                dc.w    $B00
                dc.w    $B80
                dc.w    $C00
; ---------------------------------------------------------------------------

S3TailsSpin_DecayHeldCharge:
                tst.w   spin_dash_counter(a0)
                beq.s   S3TailsSpin_ChargeOnNewPress
                move.w  spin_dash_counter(a0),d0
                lsr.w   #5,d0
                sub.w   d0,spin_dash_counter(a0)
                bcc.s   S3TailsSpin_ChargeOnNewPress
                move.w  #0,spin_dash_counter(a0)

S3TailsSpin_ChargeOnNewPress:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3TailsSpin_SkipGroundAndEaseCamera
                move.w  #9<<8,anim(a0)                  ; and prev_anim
                move.w  #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX).l
                addi.w  #$200,spin_dash_counter(a0)
                cmpi.w  #$800,spin_dash_counter(a0)
                blo.s   S3TailsSpin_SkipGroundAndEaseCamera
                move.w  #$800,spin_dash_counter(a0)

; Discard the ground movement return address and ease the camera distance toward $60
S3TailsSpin_SkipGroundAndEaseCamera:
                addq.l  #4,sp
                cmpi.w  #$60,(a5)
                beq.s   S3TailsSpin_CheckActiveBoundsAndTerrain
                bcc.s   S3TailsSpin_ReduceCameraDistanceBy2
                addq.w  #4,(a5)

S3TailsSpin_ReduceCameraDistanceBy2:
                subq.w  #2,(a5)

S3TailsSpin_CheckActiveBoundsAndTerrain:
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Player_AnglePos
                tst.b   (Background_collision_flag).w
                beq.s   S3TailsSpin_ActiveReturn
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                movem.l (sp)+,a4-a6
                tst.w   d1
                bpl.s   S3TailsSpin_ActiveReturn
                sub.w   d1,x_pos(a0)

S3TailsSpin_ActiveReturn:
                rts
; End of function Tails_Spindash

; =============== S U B R O U T I N E =======================================

Tails_SlopeResist:
                move.b  angle(a0),d0
                addi.b  #$60,d0
                cmpi.b  #-$40,d0
                bcc.s   S3TailsSlope_ResistReturn
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$20,d0
                asr.l   #8,d0
                tst.w   ground_vel(a0)
                beq.s   S3TailsSlope_ResistReturn
                bmi.s   S3TailsSlope_ResistNegativeSpeed
                tst.w   d0
                beq.s   S3TailsSlope_ResistPositiveReturn
                add.w   d0,ground_vel(a0)

S3TailsSlope_ResistPositiveReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsSlope_ResistNegativeSpeed:
                add.w   d0,ground_vel(a0)

S3TailsSlope_ResistReturn:
                rts
; End of function Tails_SlopeResist

; =============== S U B R O U T I N E =======================================

Tails_RollRepel:
                move.b  angle(a0),d0
                addi.b  #$60,d0
                cmpi.b  #-$40,d0
                bcc.s   S3TailsSlope_RollRepelReturn
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$50,d0
                asr.l   #8,d0
                tst.w   ground_vel(a0)
                bmi.s   S3TailsSlope_ScaleRollForceAgainstNeg
                tst.w   d0
                bpl.s   S3TailsSlope_ApplyRollForceToPosSpeed
                asr.l   #2,d0

S3TailsSlope_ApplyRollForceToPosSpeed:
                add.w   d0,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsSlope_ScaleRollForceAgainstNeg:
                tst.w   d0
                bmi.s   S3TailsSlope_ApplyRollForceToNegSpeed
                asr.l   #2,d0

S3TailsSlope_ApplyRollForceToNegSpeed:
                add.w   d0,ground_vel(a0)

S3TailsSlope_RollRepelReturn:
                rts
; End of function Tails_RollRepel

; =============== S U B R O U T I N E =======================================

Tails_SlopeRepel:
                nop
                tst.b   stick_to_convex(a0)
                bne.s   S3TailsSlope_RepelReturn
                tst.w   move_lock(a0)
                bne.s   S3TailsSlope_TickMoveLock
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   S3TailsSlope_RepelReturn
                move.w  ground_vel(a0),d0
                bpl.s   S3TailsSlope_DetachSlowPlayer
                neg.w   d0

; Below $280 on a steep slope, clear ground speed and lock movement for 30 frames
S3TailsSlope_DetachSlowPlayer:
                cmpi.w  #$280,d0
                bcc.s   S3TailsSlope_RepelReturn
                clr.w   ground_vel(a0)
                bset    #Status_InAir,status(a0)
                move.w  #30,move_lock(a0)

S3TailsSlope_RepelReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsSlope_TickMoveLock:
                subq.w  #1,move_lock(a0)
                rts
; End of function Tails_SlopeRepel

; =============== S U B R O U T I N E =======================================

Tails_JumpAngle:
                move.b  angle(a0),d0
                beq.s   S3TailsSlope_CheckFlipAndDirection
                bpl.s   S3TailsSlope_ReducePositiveAirAngle
                addq.b  #2,d0
                bcc.s   S3TailsSlope_JoinNegativeAngleRecovery
                moveq   #0,d0

S3TailsSlope_JoinNegativeAngleRecovery:
                bra.s   S3TailsSlope_StoreAirAngle
; ---------------------------------------------------------------------------

S3TailsSlope_ReducePositiveAirAngle:
                subq.b  #2,d0
                bcc.s   S3TailsSlope_StoreAirAngle
                moveq   #0,d0

S3TailsSlope_StoreAirAngle:
                move.b  d0,angle(a0)

S3TailsSlope_CheckFlipAndDirection:
                move.b  flip_angle(a0),d0
                beq.s   S3TailsSlope_JumpFlipReturn
                tst.w   ground_vel(a0)
                bmi.s   S3TailsSlope_CheckAndAdvanceLeftFlip

S3TailsSlope_AdvanceRightFlip:
                move.b  flip_speed(a0),d1
                add.b   d1,d0
                bcc.s   S3TailsSlope_JoinRightFlipStore
                subq.b  #1,flips_remaining(a0)
                bcc.s   S3TailsSlope_JoinRightFlipStore
                move.b  #0,flips_remaining(a0)
                moveq   #0,d0

S3TailsSlope_JoinRightFlipStore:
                bra.s   S3TailsSlope_StoreFlipAngle
; ---------------------------------------------------------------------------

S3TailsSlope_CheckAndAdvanceLeftFlip:
                tst.b   flip_type(a0)
                bmi.s   S3TailsSlope_AdvanceRightFlip
                move.b  flip_speed(a0),d1
                sub.b   d1,d0
                bcc.s   S3TailsSlope_StoreFlipAngle
                subq.b  #1,flips_remaining(a0)
                bcc.s   S3TailsSlope_StoreFlipAngle
                move.b  #0,flips_remaining(a0)
                moveq   #0,d0

S3TailsSlope_StoreFlipAngle:
                move.b  d0,flip_angle(a0)

S3TailsSlope_JumpFlipReturn:
                rts
; End of function Tails_JumpAngle
