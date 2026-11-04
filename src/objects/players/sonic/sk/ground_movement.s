; Owner: objects/players/sonic/sk
; Responsibility: Sonic ground acceleration, balance, braking and horizontal movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Subroutine to make Sonic walk/run
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_Move:
                move.w  Max_speed-Max_speed(a4),d6      ; set Max_speed
                move.w  Acceleration-Max_speed(a4),d5   ; set Acceleration
                move.w  Deceleration-Max_speed(a4),d4   ; set Deceleration
                tst.b   status_secondary(a0)            ; is bit 7 set? (Infinite inertia)
                bmi.w   SKSonicGround_ProjectGroundSpeed  ; if so, branch
                tst.w   move_lock(a0)
                bne.w   SKSonicGround_ResetLookDelay
                btst    #button_left,(Ctrl_1_held_logical).w  ; is left being pressed?
                beq.s   Sonic_NotLeft                   ; if not, branch
                bsr.w   SonicSKApplyGroundLeftInput

Sonic_NotLeft:
                btst    #button_right,(Ctrl_1_held_logical).w  ; is right being pressed?
                beq.s   Sonic_NotRight                  ; if not, branch
                bsr.w   SonicSKApplyGroundRightInput

Sonic_NotRight:
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0                         ; is Sonic on a slope?
                bne.w   SKSonicGround_ResetLookDelay    ; if yes, branch
                tst.w   ground_vel(a0)                  ; is Sonic moving?
                bne.w   SKSonicGround_ResetLookDelay    ; if yes, branch
                bclr    #Status_Push,status(a0)
                move.b  #5,anim(a0)                     ; use standing animation
                btst    #Status_OnObj,status(a0)
                beq.w   Sonic_Balance
                movea.w interact(a0),a1                 ; load interacting object's RAM space
                tst.b   status(a1)                      ; is status bit 7 set? (unused?)
                bmi.w   SKSonicGround_CheckFirstLookInput  ; if so, branch

; Calculations to determine where on the object Sonic is, and make him balance accordingly
                moveq   #0,d1                           ; Clear d1
                move.b  width_pixels(a1),d1             ; Load interacting object's width into d1
                move.w  d1,d2                           ; Move to d2 for separate calculations
                add.w   d2,d2                           ; Double object width, converting it to X pos' units of measurement
                subq.w  #2,d2                           ; Subtract 2: This is the margin for 'on edge'
                add.w   x_pos(a0),d1                    ; Add Sonic's X position to object width
                sub.w   x_pos(a1),d1                    ; Subtract object's X position from width+Sonic's X pos, giving you Sonic's distance from left edge of object
                tst.b   (Super_Sonic_Knux_flag).w       ; is Sonic Super/Hyper?
                bne.w   SuperSonic_Balance              ; if so, branch
                cmpi.w  #2,d1                           ; is Sonic within two units of object's left edge?
                blt.s   Sonic_BalanceOnObjLeft          ; if so, branch
                cmp.w   d2,d1
                bge.s   Sonic_BalanceOnObjRight         ; if Sonic is within two units of object's right edge, branch (Realistically, it checks this, and BEYOND the right edge of the object)
                bra.w   SKSonicGround_CheckFirstLookInput  ; if Sonic is more than 2 units from both edges, branch
; ---------------------------------------------------------------------------

SuperSonic_Balance:
                cmpi.w  #2,d1                           ; is Sonic within two units of object's left edge?
                blt.w   SKSonicGround_FaceLeftForPoweredBalance  ; if so, branch
                cmp.w   d2,d1
                bge.w   SKSonicGround_FaceRightForPoweredBalance  ; if Sonic is within two units of object's right edge, branch (Realistically, it checks this, and BEYOND the right edge of the object)
                bra.w   SKSonicGround_CheckFirstLookInput  ; if Sonic is more than 2 units from both edges, branch
; ---------------------------------------------------------------------------
; balancing checks for when you're on the right edge of an object

Sonic_BalanceOnObjRight:
                btst    #Status_Facing,status(a0)       ; is Sonic facing right?
                bne.s   SKSonicGround_BalanceAtObjectRightEdge  ; if so, branch
                move.b  #6,anim(a0)                     ; Balance animation 1
                addq.w  #6,d2                           ; extend balance range
                cmp.w   d2,d1                           ; is Sonic within (two units before and) four units past the right edge?
                blt.w   SKSonicGround_ResetLookDelay    ; if so, branch
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   SKSonicGround_ResetLookDelay

SKSonicGround_BalanceAtObjectRightEdge:
; Somewhat dummied out/redundant code from Sonic 2
; Originally, Sonic displayed different animations for each direction faced
; But now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
                bclr    #Status_Facing,status(a0)
                move.b  #6,anim(a0)                     ; Balance animation 1
                addq.w  #6,d2                           ; extend balance range
                cmp.w   d2,d1                           ; is Sonic within (two units before and) four units past the right edge?
                blt.w   SKSonicGround_ResetLookDelay    ; if so, branch
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   SKSonicGround_ResetLookDelay
; ---------------------------------------------------------------------------

Sonic_BalanceOnObjLeft:
                btst    #Status_Facing,status(a0)       ; is Sonic facing right?
                beq.s   SKSonicGround_BalanceAtObjectLeftEdge
                move.b  #6,anim(a0)                     ; Balance animation 1
                cmpi.w  #-4,d1                          ; is Sonic within (two units before and) four units past the left edge?
                bge.w   SKSonicGround_ResetLookDelay    ; if so branch (instruction signed to match)
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   SKSonicGround_ResetLookDelay

SKSonicGround_BalanceAtObjectLeftEdge:
; Somewhat dummied out/redundant code from Sonic 2
; Originally, Sonic displayed different animations for each direction faced
; But now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
                bset    #Status_Facing,status(a0)       ; is Sonic facing right?
                move.b  #6,anim(a0)                     ; Balance animation 1
                cmpi.w  #-4,d1                          ; is Sonic within (two units before and) four units past the left edge?
                bge.w   SKSonicGround_ResetLookDelay    ; if so branch (instruction signed to match)
                move.b  #$C,anim(a0)                    ; if REALLY close to the edge, use different animation (Balance animation 2)
                bra.w   SKSonicGround_ResetLookDelay
; ---------------------------------------------------------------------------
; balancing checks for when you're on the edge of part of the level

Sonic_Balance:
                move.w  x_pos(a0),d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   SKSonicGround_CheckFirstLookInput
                tst.b   (Super_Sonic_Knux_flag).w       ; is Sonic Super/Hyper?
                bne.w   SKSonicGround_CheckPoweredRightEdge  ; if so, branch
                cmpi.b  #3,next_tilt(a0)
                bne.s   SKSonicGround_CheckLeftEdgeSensor
                btst    #Status_Facing,status(a0)
                bne.s   SKSonicGround_FaceRightAndReprobeLeft6
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                subq.w  #6,d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   SKSonicGround_ResetLookDelay
                move.b  #$C,anim(a0)
                bra.w   SKSonicGround_ResetLookDelay
; on right edge but facing left:

SKSonicGround_FaceRightAndReprobeLeft6:
; Somewhat dummied out/redundant code from Sonic 2
; Originally, Sonic displayed different animations for each direction faced
; But now, Sonic uses only the one set of animations no matter what, making the check pointless, and the code redundant
                bclr    #Status_Facing,status(a0)
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                subq.w  #6,d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   SKSonicGround_ResetLookDelay
                move.b  #$C,anim(a0)
                bra.w   SKSonicGround_ResetLookDelay
; ---------------------------------------------------------------------------

SKSonicGround_CheckLeftEdgeSensor:
                cmpi.b  #3,tilt(a0)
                bne.s   SKSonicGround_CheckFirstLookInput
                btst    #Status_Facing,status(a0)
                beq.s   SKSonicGround_FaceLeftAndReprobeRight6
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                addq.w  #6,d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   SKSonicGround_ResetLookDelay
                move.b  #$C,anim(a0)
                bra.w   SKSonicGround_ResetLookDelay
; ---------------------------------------------------------------------------

SKSonicGround_FaceLeftAndReprobeRight6:
                bset    #Status_Facing,status(a0)
                move.b  #6,anim(a0)
                move.w  x_pos(a0),d3
                addq.w  #6,d3
                bsr.w   ChooseChkFloorEdge
                cmpi.w  #$C,d1
                blt.w   SKSonicGround_ResetLookDelay
                move.b  #$C,anim(a0)
                bra.w   SKSonicGround_ResetLookDelay
; ---------------------------------------------------------------------------

SKSonicGround_CheckPoweredRightEdge:
                cmpi.b  #3,next_tilt(a0)
                bne.s   SKSonicGround_CheckPoweredLeftEdge

SKSonicGround_FaceRightForPoweredBalance:
                bclr    #Status_Facing,status(a0)
                bra.s   SKSonicGround_SetPoweredBalanceAnim
; ---------------------------------------------------------------------------

SKSonicGround_CheckPoweredLeftEdge:
                cmpi.b  #3,tilt(a0)
                bne.s   SKSonicGround_CheckFirstLookInput

SKSonicGround_FaceLeftForPoweredBalance:
                bset    #Status_Facing,status(a0)

SKSonicGround_SetPoweredBalanceAnim:
                move.b  #6,anim(a0)
                bra.s   SKSonicGround_ResetLookDelay
; ---------------------------------------------------------------------------

SKSonicGround_CheckFirstLookInput:
                btst    #button_down,(Ctrl_1_logical).w
                beq.s   SKSonicGround_CheckSecondLookInput
                move.b  #8,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #120,scroll_delay_counter(a0)
                blo.s   SKSonicGround_EaseLookCamera
                move.b  #120,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKSonicGround_RaiseCameraForReverseDuck
                cmpi.w  #8,(a5)
                beq.s   SKSonicGround_SelectPoweredFriction
                subq.w  #2,(a5)
                bra.s   SKSonicGround_SelectPoweredFriction
; ---------------------------------------------------------------------------

SKSonicGround_RaiseCameraForReverseDuck:
                cmpi.w  #$D8,(a5)
                beq.s   SKSonicGround_SelectPoweredFriction
                addq.w  #2,(a5)
                bra.s   SKSonicGround_SelectPoweredFriction
; ---------------------------------------------------------------------------

SKSonicGround_CheckSecondLookInput:
                btst    #button_up,(Ctrl_1_held_logical).w
                beq.s   SKSonicGround_ResetLookDelay
                move.b  #7,anim(a0)
                addq.b  #1,scroll_delay_counter(a0)
                cmpi.b  #120,scroll_delay_counter(a0)
                blo.s   SKSonicGround_EaseLookCamera
                move.b  #120,scroll_delay_counter(a0)
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKSonicGround_LowerCameraForReverseLook
                cmpi.w  #$C8,(a5)
                beq.s   SKSonicGround_SelectPoweredFriction
                addq.w  #2,(a5)
                bra.s   SKSonicGround_SelectPoweredFriction
; ---------------------------------------------------------------------------

SKSonicGround_LowerCameraForReverseLook:
                cmpi.w  #$18,(a5)
                beq.s   SKSonicGround_SelectPoweredFriction
                subq.w  #2,(a5)
                bra.s   SKSonicGround_SelectPoweredFriction
; ---------------------------------------------------------------------------

SKSonicGround_ResetLookDelay:
                move.b  #0,scroll_delay_counter(a0)

SKSonicGround_EaseLookCamera:
                cmpi.w  #$60,(a5)
                beq.s   SKSonicGround_SelectPoweredFriction
                bcc.s   SKSonicGround_ReduceCameraDistanceBy2
                addq.w  #4,(a5)

SKSonicGround_ReduceCameraDistanceBy2:
                subq.w  #2,(a5)

SKSonicGround_SelectPoweredFriction:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKSonicGround_ApplyNeutralFriction
                move.w  #$C,d5

SKSonicGround_ApplyNeutralFriction:
                move.b  (Ctrl_1_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   SKSonicGround_ProjectGroundSpeed
                move.w  ground_vel(a0),d0
                beq.s   SKSonicGround_ProjectGroundSpeed
                bmi.s   SKSonicGround_ApplyNegativeFriction
                sub.w   d5,d0
                bcc.s   SKSonicGround_StorePositiveFriction
                move.w  #0,d0

SKSonicGround_StorePositiveFriction:
                move.w  d0,ground_vel(a0)
                bra.s   SKSonicGround_ProjectGroundSpeed
; ---------------------------------------------------------------------------

SKSonicGround_ApplyNegativeFriction:
                add.w   d5,d0
                bcc.s   SKSonicGround_StoreNegativeFriction
                move.w  #0,d0

SKSonicGround_StoreNegativeFriction:
                move.w  d0,ground_vel(a0)

SKSonicGround_ProjectGroundSpeed:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)

SKSonicGround_CheckTravelProbe:
                btst    #6,object_control(a0)
                bne.w   SKSonicGround_TravelProbeReturn
                move.b  angle(a0),d0
                andi.b  #$3F,d0
                beq.s   SKSonicGround_PickTravelProbeOffset
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bmi.w   SKSonicGround_TravelProbeReturn

; Cardinal angles reach this step directly, including when the general angle test would skip the probe
SKSonicGround_PickTravelProbeOffset:
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   SKSonicGround_TravelProbeReturn
                bmi.s   SKSonicGround_ProbeTravelSide
                neg.w   d1

; Resolve negative clearance only. Convert the penetration to velocity units by shifting left eight
SKSonicGround_ProbeTravelSide:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                bsr.w   ProbeNextSurfaceWithFixedLookahead
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   SKSonicGround_TravelProbeReturn
                asl.w   #8,d1
                cmpi.b  #8,(Current_zone).w
                bne.s   SKSonicGround_RoundProbeAndResolve
                tst.b   d0
                bpl.s   SKSonicGround_RoundProbeAndResolve
                subq.b  #1,d0

SKSonicGround_RoundProbeAndResolve:
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   SKSonicGround_ApplyFloorCorrection
                cmpi.b  #$40,d0
                beq.s   SKSonicGround_ApplyLeftWallCorrection
                cmpi.b  #$80,d0
                beq.s   SKSonicGround_ApplyCeilingCorrection
                add.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                bne.s   SKSonicGround_HorizontalProbeReturn
                bset    #Status_Push,status(a0)

SKSonicGround_HorizontalProbeReturn:
                rts
; ---------------------------------------------------------------------------

SKSonicGround_ApplyCeilingCorrection:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicGround_ApplyLeftWallCorrection:
                sub.w   d1,x_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   SKSonicGround_HorizontalProbeReturn
                bset    #Status_Push,status(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicGround_ApplyFloorCorrection:
                add.w   d1,y_vel(a0)

SKSonicGround_TravelProbeReturn:
                rts
; End of function Sonic_Move

; =============== S U B R O U T I N E =======================================

SonicSKApplyGroundLeftInput:
                move.w  ground_vel(a0),d0
                beq.s   SKSonicGround_FaceLeftAndResetTurnState
                bpl.s   SKSonicGround_BrakeRightwardSpeed

SKSonicGround_FaceLeftAndResetTurnState:
                bset    #Status_Facing,status(a0)
                bne.s   SKSonicGround_AccelerateLeft
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

; Keep the previous speed when left input would increase existing overspeed
SKSonicGround_AccelerateLeft:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   SKSonicGround_StoreLeftSpeedAndAnimate
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   SKSonicGround_StoreLeftSpeedAndAnimate
                move.w  d1,d0

SKSonicGround_StoreLeftSpeedAndAnimate:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicGround_BrakeRightwardSpeed:
                sub.w   d4,d0
                bcc.s   SKSonicGround_StoreLeftBrakeAndCheckSkid
                move.w  #-$80,d0

; The skid threshold sees the speed high byte and the rounded angle in the low byte
SKSonicGround_StoreLeftBrakeAndCheckSkid:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   SKSonicGround_LeftBrakeReturn
                cmpi.w  #$400,d0
                blt.s   SKSonicGround_LeftBrakeReturn
                tst.b   flip_type(a0)
                bmi.s   SKSonicGround_LeftBrakeReturn
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bclr    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKSonicGround_LeftBrakeReturn
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

SKSonicGround_LeftBrakeReturn:
                rts
; End of function SonicSKApplyGroundLeftInput

; =============== S U B R O U T I N E =======================================

SonicSKApplyGroundRightInput:
                move.w  ground_vel(a0),d0
                bmi.s   SKSonicGround_BrakeLeftwardSpeed
                bclr    #Status_Facing,status(a0)
                beq.s   SKSonicGround_AccelerateRight
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)

; Keep the previous speed when right input would increase existing overspeed
SKSonicGround_AccelerateRight:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   SKSonicGround_StoreRightSpeedAndAnimate
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   SKSonicGround_StoreRightSpeedAndAnimate
                move.w  d6,d0

SKSonicGround_StoreRightSpeedAndAnimate:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicGround_BrakeLeftwardSpeed:
                add.w   d4,d0
                bcc.s   SKSonicGround_StoreRightBrakeAndTestSkid
                move.w  #$80,d0

; The skid threshold sees the speed high byte and the rounded angle in the low byte
SKSonicGround_StoreRightBrakeAndTestSkid:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   SKSonicGround_RightBrakeReturn
                cmpi.w  #-$400,d0
                bgt.s   SKSonicGround_RightBrakeReturn
                tst.b   flip_type(a0)
                bmi.s   SKSonicGround_RightBrakeReturn
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                move.b  #$D,anim(a0)
                bset    #Status_Facing,status(a0)
                cmpi.b  #12,air_left(a0)
                blo.s   SKSonicGround_RightBrakeReturn
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

SKSonicGround_RightBrakeReturn:
                rts
; End of function SonicSKApplyGroundRightInput
