; Owner: objects/zones/mhz/sk
; Responsibility: Vertical swing-bar contact, character rotation and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZSwingBarVertical:
                move.l  #Map_MHZSwingBarVertical,mappings(a0)
                move.w  #make_art_tile(ArtTile_MHZMisc+$AC,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #4,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                bset    #7,status(a0)
                move.l  #SKMHZVertBar_UpdateSolidAndRiders,(a0)

SKMHZVertBar_UpdateSolidAndRiders:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  #$21,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d1
                bsr.s   UpdatePlayerOnMhzVerticalSwingBar
                addq.w  #1,a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d1
                bsr.s   UpdatePlayerOnMhzVerticalSwingBar
                tst.b   $30(a0)
                beq.s   SKMHZVertBar_DrawVerticalBar
                move.b  #1,(Scroll_force_positions).w
                move.w  x_pos(a0),(Scroll_forced_X_pos).w
                move.w  (Player_1+y_pos).w,(Scroll_forced_Y_pos).w

SKMHZVertBar_DrawVerticalBar:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnMhzVerticalSwingBar:
                tst.b   (a2)
                beq.w   SKMHZVertBar_TickCaptureCooldown
                tst.w   (Debug_placement_mode).w
                bne.w   SKMHZVertBar_StartManualCooldown
                cmpi.b  #4,routine(a1)
                bhs.w   SKMHZVertBar_StartManualCooldown
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d1
                bne.w   SKMHZVertBar_SetManualJumpYSpeed
                cmpi.b  #-8,4(a2)
                beq.w   SKMHZVertBar_LaunchByFacing
                addi.b  #8,4(a2)
                bsr.s   PositionMhzVerticalBarPlayerPose

SKMHZVertBar_UploadRiderTiles:
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; End of function UpdatePlayerOnMhzVerticalSwingBar

; =============== S U B R O U T I N E =======================================

PositionMhzVerticalBarPlayerPose:
                moveq   #0,d0
                move.b  4(a2),d0
                lsr.b   #4,d0
                move.b  SKMHZVertBar_RiderPoseFrames(pc,d0.w),d1
                move.b  d1,mapping_frame(a1)
                move.b  SKMHZVertBar_RiderPoseXOffsets(pc,d0.w),d1
                ext.w   d1
                btst    #0,render_flags(a1)
                beq.s   SKMHZVertBar_ApplyRiderXOffset
                neg.w   d1

SKMHZVertBar_ApplyRiderXOffset:
                add.w   x_pos(a0),d1
                move.w  d1,x_pos(a1)
                rts
; End of function PositionMhzVerticalBarPlayerPose

; ---------------------------------------------------------------------------
SKMHZVertBar_RiderPoseFrames:
                dc.b    $5C, $5C, $5D, $5D, $5D, $5E, $5E, $5E, $5F, $5F, $60, $60, $60, $61, $61, $61
SKMHZVertBar_RiderPoseXOffsets:
                dc.b    $12, $12,   4,   4,   4, -$A, -$A, -$A,-$12,-$12,-$12,-$12,-$12,  $A,  $A,  $A
                even
; ---------------------------------------------------------------------------

SKMHZVertBar_SetManualJumpYSpeed:
                move.w  #-$500,y_vel(a1)
                btst    #Status_Underwater,status(a1)
                beq.s   SKMHZVertBar_StartManualCooldown
                move.w  #-$200,y_vel(a1)

SKMHZVertBar_StartManualCooldown:
                clr.b   (a2)
                move.b  #30,2(a2)
                btst    #Status_Underwater,status(a1)
                beq.s   SKMHZVertBar_SetReleasedRollPose
                move.b  #60,2(a2)

SKMHZVertBar_SetReleasedRollPose:
                andi.b  #$FC,object_control(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,flip_angle(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZVertBar_LaunchByFacing:
                move.w  #0,anim(a1)
                clr.b   (a2)
                move.b  #8,2(a2)
                andi.b  #$FC,object_control(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  #$1000,x_vel(a1)
                bclr    #Status_Facing,status(a1)
                btst    #0,render_flags(a1)
                beq.s   SKMHZVertBar_SetAutoLaunchPose
                bset    #Status_Facing,status(a1)
                neg.w   x_vel(a1)

SKMHZVertBar_SetAutoLaunchPose:
                move.w  #15,move_lock(a1)
                move.w  x_vel(a1),ground_vel(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #2,routine(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,flip_angle(a1)
                move.b  #$24,mapping_frame(a1)
                cmpi.b  #1,character_id(a1)
                bne.w   SKMHZVertBar_UploadRiderTiles
                move.b  #$E,mapping_frame(a1)
                bra.w   SKMHZVertBar_UploadRiderTiles
; ---------------------------------------------------------------------------

SKMHZVertBar_TickCaptureCooldown:
                tst.b   2(a2)
                beq.s   SKMHZVertBar_CheckLeftwardEntry
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

SKMHZVertBar_CheckLeftwardEntry:
                move.w  x_vel(a1),d0
                bpl.s   SKMHZVertBar_CheckRightwardEntry
                cmpi.w  #-$400,d0
                bgt.w   SKMHZVertBar_CaptureReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$28,d0
                cmpi.w  #$18,d0
                bhs.w   SKMHZVertBar_CaptureReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$40,d0
                bhs.w   SKMHZVertBar_CaptureReturn
                moveq   #-$12,d2
                bra.s   SKMHZVertBar_CheckRiderEligibility
; ---------------------------------------------------------------------------

SKMHZVertBar_CheckRightwardEntry:
                cmpi.w  #$400,d0
                blt.w   SKMHZVertBar_CaptureReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                subi.w  #$10,d0
                cmpi.w  #$18,d0
                bhs.w   SKMHZVertBar_CaptureReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$40,d0
                bhs.w   SKMHZVertBar_CaptureReturn
                moveq   #$12,d2

SKMHZVertBar_CheckRiderEligibility:
                tst.w   (Debug_placement_mode).w
                bne.w   SKMHZVertBar_CaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.w   SKMHZVertBar_CaptureReturn
                tst.b   object_control(a1)
                bne.w   SKMHZVertBar_CaptureReturn
                btst    #Status_InAir,status(a1)
                bne.w   SKMHZVertBar_CaptureReturn
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  y_radius(a1),d0
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                bclr    #Status_Roll,status(a1)
                beq.s   SKMHZVertBar_PlaceAndLatchRider
                sub.b   default_y_radius(a1),d0
                ext.w   d0
                add.w   d0,y_pos(a1)

SKMHZVertBar_PlaceAndLatchRider:
                move.w  x_pos(a0),d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.b  #0,anim(a1)
                move.b  #3,object_control(a1)
                move.b  #$62,mapping_frame(a1)
                move.b  #8,4(a2)
                move.b  #1,(a2)
                tst.w   d2
                bpl.s   SKMHZVertBar_UploadPoseAndPlayGrab
                bset    #0,render_flags(a1)

SKMHZVertBar_UploadPoseAndPlayGrab:
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

SKMHZVertBar_CaptureReturn:
                rts
; ---------------------------------------------------------------------------
Map_MHZSwingBarVertical:
                include "src/objects/shared/zones/mhz/mappings/swing_bar_vertical.s"
