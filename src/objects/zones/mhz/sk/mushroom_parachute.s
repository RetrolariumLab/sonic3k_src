; Owner: objects/zones/mhz/sk
; Responsibility: Mushroom parachute movement, player contact and descent control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZMushroomParachute:
                move.l  #Map_MHZMushroomParachute,mappings(a0)
                move.w  #make_art_tile(ArtTile_MHZMisc+$86,2,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #$20,x_radius(a0)
                move.b  #$18,y_radius(a0)
                move.w  #$200,ground_vel(a0)
                move.b  #0,angle(a0)
                tst.b   subtype(a0)
                beq.s   SKMHZParachute_StartCaptureWait
                move.b  #$80,angle(a0)

SKMHZParachute_StartCaptureWait:
                move.l  #SKMHZParachute_UpdateRidersAndTryStart,(a0)

SKMHZParachute_UpdateRidersAndTryStart:
                bsr.w   UpdatePlayersOnMhzMushroomParachute
                tst.b   $30(a0)
                beq.s   SKMHZParachute_DrawIdleParachute
                move.l  #SKMHZParachute_UpdateControlledFlight,(a0)
                move.w  #$300,y_vel(a0)

SKMHZParachute_DrawIdleParachute:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKMHZParachute_UpdateControlledFlight:
                bsr.w   MHZParachute_SteerAndAdjustDescent
                jsr     (MoveSprite2).l
                bsr.w   ResolveMhzMushroomParachuteSideWalls
                bsr.s   UpdatePlayersOnMhzMushroomParachute
                move.w  x_vel(a0),$34(a0)
                move.w  y_vel(a0),$36(a0)
                tst.w   $30(a0)
                bne.s   SKMHZParachute_TryReleaseHiddenP1
                move.l  #SKMHZParachute_UpdateUnoccupiedFlight,(a0)

SKMHZParachute_TryReleaseHiddenP1:
                tst.b   render_flags(a0)
                bmi.s   SKMHZParachute_DrawControlledFlight
                move.w  #$7F00,x_pos(a0)
                tst.b   $30(a0)
                beq.s   SKMHZParachute_TryReleaseHiddenP2
                clr.w   (Player_1+interact).w
                clr.b   (Player_1+object_control).w

SKMHZParachute_TryReleaseHiddenP2:
                tst.b   $31(a0)
                beq.s   SKMHZParachute_DrawControlledFlight
                clr.w   (Player_2+interact).w
                clr.b   (Player_2+object_control).w

SKMHZParachute_DrawControlledFlight:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

; Continue steering and moving without wall probes or rider capture
SKMHZParachute_UpdateUnoccupiedFlight:
                bsr.w   MHZParachute_SteerAndAdjustDescent
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bmi.s   SKMHZParachute_DrawUnoccupiedFlight
                move.w  #$7F00,x_pos(a0)
                tst.b   $30(a0)
                beq.s   SKMHZParachute_TryClearUnoccupiedP2
                clr.w   (Player_1+interact).w
                clr.b   (Player_1+object_control).w

SKMHZParachute_TryClearUnoccupiedP2:
                tst.b   $31(a0)
                beq.s   SKMHZParachute_DrawUnoccupiedFlight
                clr.w   (Player_2+interact).w
                clr.b   (Player_2+object_control).w

SKMHZParachute_DrawUnoccupiedFlight:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdatePlayersOnMhzMushroomParachute:
                lea     $31(a0),a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d0
                bsr.s   UpdatePlayerOnMhzMushroomParachute
                lea     (Player_1).w,a1
                subq.w  #1,a2
                move.w  (Ctrl_1_logical).w,d0
; End of function UpdatePlayersOnMhzMushroomParachute

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnMhzMushroomParachute:
                tst.b   (a2)
                beq.w   SKMHZParachute_TickCaptureCooldown
                tst.b   render_flags(a1)
                bpl.w   SKMHZParachute_NudgeRiderUpAndDetach
                cmpi.b  #4,routine(a1)
                bhs.w   SKMHZParachute_DetachWithoutJump
                tst.w   (Debug_placement_mode).w
                bne.w   SKMHZParachute_DetachWithoutJump
                move.w  $34(a0),d1
                cmp.w   x_vel(a1),d1
                bne.s   SKMHZParachute_NudgeRiderUpAndDetach
                move.w  $36(a0),d1
                cmp.w   y_vel(a1),d1
                bne.s   SKMHZParachute_NudgeRiderUpAndDetach
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKMHZParachute_CarryRiderAndCheckTerrain
                clr.w   interact(a1)
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$12,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   SKMHZParachute_TrySetJumpLeft
                move.b  #$3C,2(a2)

SKMHZParachute_TrySetJumpLeft:
                btst    #button_left+8,d0
                beq.s   SKMHZParachute_TrySetJumpRight
                move.w  #-$200,x_vel(a1)

SKMHZParachute_TrySetJumpRight:
                btst    #button_right+8,d0
                beq.s   SKMHZParachute_SetJumpReleasePose
                move.w  #$200,x_vel(a1)

SKMHZParachute_SetJumpReleasePose:
                move.w  #-$380,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZParachute_NudgeRiderUpAndDetach:
                move.w  #-$100,y_vel(a1)

SKMHZParachute_DetachWithoutJump:
                clr.w   interact(a1)
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                rts
; ---------------------------------------------------------------------------

SKMHZParachute_CarryRiderAndCheckTerrain:
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$25,y_pos(a1)
                move.w  x_vel(a0),x_vel(a1)
                move.w  y_vel(a0),y_vel(a1)
                movem.l d0-a6,-(sp)
                movea.l a1,a0
                jsr     (SonicKnux_DoLevelCollision).l
                movem.l (sp)+,d0-a6

SKMHZParachute_SetFacingFromHeading:
                bclr    #Status_Facing,status(a1)
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bpl.s   SKMHZParachute_ApplyHeadingPose
                bset    #Status_Facing,status(a1)

SKMHZParachute_ApplyHeadingPose:
                move.b  status(a1),d0
                andi.b  #1,d0
                andi.b  #$FC,render_flags(a1)
                or.b    d0,render_flags(a1)
                moveq   #0,d0
                move.b  angle(a0),d0
                lsr.w   #4,d0
                move.b  SKMHZParachute_RiderHeadingFrames(pc,d0.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------
SKMHZParachute_RiderHeadingFrames:
                dc.b    $E4, $E5, $E6, $E6, $E7, $E6, $E6, $E5, $E4, $E5, $E6, $E6, $E7, $E6, $E6, $E5
                even
; ---------------------------------------------------------------------------

SKMHZParachute_TickCaptureCooldown:
                tst.b   2(a2)
                beq.s   SKMHZParachute_TryCaptureRider
                subq.b  #1,2(a2)
                bne.w   SKMHZParachute_CaptureReturn

SKMHZParachute_TryCaptureRider:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   SKMHZParachute_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$25,d1
                cmpi.w  #$18,d1
                bhs.w   SKMHZParachute_CaptureReturn
                tst.b   object_control(a1)
                bne.s   SKMHZParachute_CaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   SKMHZParachute_CaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKMHZParachute_CaptureReturn
                tst.w   y_vel(a1)
                beq.s   SKMHZParachute_CaptureReturn
                bmi.s   SKMHZParachute_CaptureReturn
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$25,y_pos(a1)
                move.b  #0,anim(a1)
                move.b  #0,spin_dash_flag(a1)
                move.b  #3,object_control(a1)
                andi.b  #$FD,render_flags(a1)
                move.b  #1,(a2)
                move.w  a0,interact(a1)
                move.w  #$80,priority(a0)
                move.w  x_vel(a0),x_vel(a1)
                move.w  y_vel(a0),y_vel(a1)
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l
                bra.w   SKMHZParachute_SetFacingFromHeading
; ---------------------------------------------------------------------------

SKMHZParachute_CaptureReturn:
                rts
; End of function UpdatePlayerOnMhzMushroomParachute

; =============== S U B R O U T I N E =======================================

ResolveMhzMushroomParachuteSideWalls:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$D,lrb_solid_bit(a0)
                beq.s   SKMHZParachute_ResolveLeftWall
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

SKMHZParachute_ResolveLeftWall:
                moveq   #$D,d5
                jsr     (ProbeLeftWallAtBodyExtents).l
                tst.w   d1
                bpl.s   SKMHZParachute_ResolveRightWall
                sub.w   d1,x_pos(a0)

SKMHZParachute_ResolveRightWall:
                jsr     (ProbeRightWallAtBodyExtents).l
                tst.w   d1
                bpl.s   SKMHZParachute_WallProbeReturn
                add.w   d1,x_pos(a0)

SKMHZParachute_WallProbeReturn:
                rts
; End of function ResolveMhzMushroomParachuteSideWalls

; =============== S U B R O U T I N E =======================================

; Follow Player 1 steering or settle toward cardinal travel. Regulate vertical speed around $80
MHZParachute_SteerAndAdjustDescent:
                move.b  angle(a0),d0
                tst.b   $30(a0)
                beq.s   SKMHZParachute_StepPassiveHeading
                btst    #button_left,(Ctrl_1_held_logical).w
                beq.s   SKMHZParachute_TrySteerRight
                cmpi.b  #$80,d0
                beq.s   SKMHZParachute_TrySteerRight
                tst.b   d0
                bpl.s   SKMHZParachute_StepLeftSteer
                neg.b   d0

SKMHZParachute_StepLeftSteer:
                addq.b  #2,d0
                bra.s   SKMHZParachute_ApplyHeadingAndDescent
; ---------------------------------------------------------------------------

SKMHZParachute_TrySteerRight:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   SKMHZParachute_StepPassiveHeading
                tst.b   d0
                beq.s   SKMHZParachute_StepPassiveHeading
                bmi.s   SKMHZParachute_StepRightSteer
                neg.b   d0

SKMHZParachute_StepRightSteer:
                addq.b  #2,d0
                bra.s   SKMHZParachute_ApplyHeadingAndDescent
; ---------------------------------------------------------------------------

SKMHZParachute_StepPassiveHeading:
                move.b  d0,d1
                andi.b  #$7F,d1
                beq.s   SKMHZParachute_ApplyHeadingAndDescent
                addq.b  #2,d0

SKMHZParachute_ApplyHeadingAndDescent:
                move.b  d0,angle(a0)
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                cmpi.w  #$80,y_vel(a0)
                blt.s   SKMHZParachute_IncreaseDescentSpeed
                subi.w  #$20,y_vel(a0)
                bra.s   SKMHZParachute_SteeringReturn
; ---------------------------------------------------------------------------

SKMHZParachute_IncreaseDescentSpeed:
                addi.w  #$20,y_vel(a0)

SKMHZParachute_SteeringReturn:
                rts
; End of function MHZParachute_SteerAndAdjustDescent

; ---------------------------------------------------------------------------
Map_MHZMushroomParachute:
                include "src/objects/shared/zones/mhz/mappings/mushroom_parachute.s"
