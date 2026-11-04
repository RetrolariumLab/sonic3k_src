; Owner: objects/zones/soz/sk
; Responsibility: Quicksand player detection, sinking, movement control and related sand states
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SOZQuicksand:
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #$3F,d0
                lsl.w   #3,d0
                move.w  d0,$30(a0)
                add.w   d0,d0
                move.w  d0,$32(a0)
                move.b  subtype(a0),d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                bne.s   SKSOZSand_CheckSpinningSubtype
                move.l  #SKSOZSand_UpdateHorizontalFlow,(a0)
                bra.w   SKSOZSand_UpdateHorizontalFlow
; ---------------------------------------------------------------------------

SKSOZSand_CheckSpinningSubtype:
                cmpi.b  #$80,d0
                bne.s   SKSOZSand_CheckJumpableSubtype
                move.l  #SKSOZSand_UpdateSpinningFlow,(a0)
                bra.w   SKSOZSand_UpdateSpinningFlow
; ---------------------------------------------------------------------------

SKSOZSand_CheckJumpableSubtype:
                cmpi.b  #-$40,d0
                bne.s   SKSOZSand_InitVerticalFlow
                move.l  #SKSOZSand_UpdateJumpableSurface,(a0)
                bra.w   SKSOZSand_UpdateJumpableSurface
; ---------------------------------------------------------------------------

SKSOZSand_InitVerticalFlow:
                move.l  #SKSOZSand_UpdateVerticalFlow,(a0)

SKSOZSand_UpdateVerticalFlow:
                move.w  $30(a0),d2
                move.w  $32(a0),d3
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.s   UpdatePlayerInSozVerticalSandFlow
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.s   UpdatePlayerInSozVerticalSandFlow
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInSozVerticalSandFlow:
                btst    d6,status(a0)
                bne.s   SKSOZSand_CheckVerticalRiderBounds
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   SKSOZSand_VerticalCaptureReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.s   SKSOZSand_VerticalCaptureReturn
                btst    #Status_InAir,status(a1)
                beq.s   SKSOZSand_VerticalCaptureReturn
                btst    #Status_OnObj,status(a1)
                bne.s   SKSOZSand_VerticalCaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   SKSOZSand_VerticalCaptureReturn
                tst.b   object_control(a1)
                bne.s   SKSOZSand_VerticalCaptureReturn
                bset    #Status_OnObj,status(a1)
                bset    d6,status(a0)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                asr     y_vel(a1)
                asr     x_vel(a1)

SKSOZSand_VerticalCaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKSOZSand_CheckVerticalRiderBounds:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   SKSOZSand_DetachVerticalRider
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.s   SKSOZSand_DetachVerticalRider
                btst    #Status_InAir,status(a1)
                bne.s   SKSOZSand_TryVerticalJump

SKSOZSand_DetachVerticalRider:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                rts
; ---------------------------------------------------------------------------

SKSOZSand_TryVerticalJump:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.s   SKSOZSand_DampVerticalAscent
                move.w  #-$800,y_vel(a1)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l

SKSOZSand_DampVerticalAscent:
                tst.w   y_vel(a1)
                bpl.s   SKSOZSand_SetVerticalFlowSpeed
                asr     x_vel(a1)
                addi.w  #$68,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

SKSOZSand_SetVerticalFlowSpeed:
                asr     x_vel(a1)
                move.w  #$A8,y_vel(a1)
                btst    #1,status(a0)
                beq.s   SKSOZSand_VerticalSpeedReturn
                move.w  #-$198,y_vel(a1)

SKSOZSand_VerticalSpeedReturn:
                rts
; End of function UpdatePlayerInSozVerticalSandFlow

; ---------------------------------------------------------------------------

SKSOZSand_UpdateHorizontalFlow:
                move.w  $30(a0),d2
                move.w  $32(a0),d3
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.s   UpdatePlayerOnSozHorizontalSandFlow
                addq.w  #1,a2
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.s   UpdatePlayerOnSozHorizontalSandFlow
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnSozHorizontalSandFlow:
                tst.b   (a2)
                beq.s   SKSOZSand_TryCaptureHorizontalRider
                subq.b  #1,(a2)
                rts
; ---------------------------------------------------------------------------

SKSOZSand_TryCaptureHorizontalRider:
                btst    d6,status(a0)
                bne.w   SKSOZSand_CheckHorizontalRiderBounds
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.s   SKSOZSand_HorizontalCaptureReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   SKSOZSand_HorizontalCaptureReturn
                btst    #Status_InAir,status(a1)
                beq.s   SKSOZSand_HorizontalCaptureReturn
                btst    #Status_OnObj,status(a1)
                bne.s   SKSOZSand_HorizontalCaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   SKSOZSand_HorizontalCaptureReturn
                tst.b   object_control(a1)
                bne.s   SKSOZSand_HorizontalCaptureReturn
                tst.w   y_vel(a1)
                bmi.s   SKSOZSand_HorizontalCaptureReturn
                bset    #Status_OnObj,status(a1)
                bset    d6,status(a0)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                asr     y_vel(a1)
                asr     x_vel(a1)

SKSOZSand_HorizontalCaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKSOZSand_CheckHorizontalRiderBounds:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.s   SKSOZSand_DetachHorizontalRider
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   SKSOZSand_DetachHorizontalRider
                btst    #Status_InAir,status(a1)
                bne.s   SKSOZSand_TryDropFromHorizontalFlow

SKSOZSand_DetachHorizontalRider:
                move.w  #0,y_vel(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                rts
; ---------------------------------------------------------------------------

; An action-button drop gives downward velocity and sets the rider's re-entry cooldown
SKSOZSand_TryDropFromHorizontalFlow:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.s   SKSOZSand_CalcHorizontalDrift
                move.w  #$400,y_vel(a1)
                move.b  #$1E,(a2)
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SKSOZSand_CalcHorizontalDrift:
                move.w  #0,y_vel(a1)
                asr     x_vel(a1)
                move.l  #$B000,d0
                btst    #0,status(a0)
                beq.s   SKSOZSand_ApplyHorizontalDrift
                neg.l   d0

SKSOZSand_ApplyHorizontalDrift:
                add.l   d0,x_pos(a1)
                rts
; End of function UpdatePlayerOnSozHorizontalSandFlow

; ---------------------------------------------------------------------------

SKSOZSand_UpdateSpinningFlow:
                move.w  $30(a0),d2
                move.w  $32(a0),d3
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   SKSOZSand_TryCaptureSpinningRider
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   SKSOZSand_TryCaptureSpinningRider
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKSOZSand_TryCaptureSpinningRider:
                btst    d6,status(a0)
                bne.w   SKSOZSand_CheckSpinningRiderBounds
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$40,d0
                bhs.w   SKSOZSand_SpinningCaptureReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.w   SKSOZSand_SpinningCaptureReturn
                btst    #Status_OnObj,status(a1)
                bne.w   SKSOZSand_SpinningCaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   SKSOZSand_SpinningCaptureReturn
                tst.b   object_control(a1)
                bne.s   SKSOZSand_SpinningCaptureReturn
                btst    #1,status(a0)
                bne.s   SKSOZSand_InitSpinningRider
                btst    #Status_InAir,status(a1)
                beq.s   SKSOZSand_SpinningCaptureReturn

SKSOZSand_InitSpinningRider:
                bset    #Status_InAir,status(a1)
                bset    #Status_OnObj,status(a1)
                bset    d6,status(a0)
                bclr    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                moveq   #1,d6
                move.w  #1,ground_vel(a1)
                tst.b   flip_angle(a1)
                bne.s   SKSOZSand_SpinningCaptureReturn
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #$7F,flips_remaining(a1)
                move.b  #8,flip_speed(a1)

SKSOZSand_SpinningCaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKSOZSand_CheckSpinningRiderBounds:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$40,d0
                bhs.s   SKSOZSand_DetachSpinningRider
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.s   SKSOZSand_DetachSpinningRider
                tst.b   object_control(a1)
                bne.s   SKSOZSand_DetachSpinningRider
                cmpi.b  #4,routine(a1)
                bhs.s   SKSOZSand_DetachSpinningRider
                btst    #Status_InAir,status(a1)
                bne.s   SKSOZSand_MaintainSpinAndSlowAscent

SKSOZSand_DetachSpinningRider:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                rts
; ---------------------------------------------------------------------------

SKSOZSand_MaintainSpinAndSlowAscent:
                move.b  #$7F,flips_remaining(a1)
                tst.w   y_vel(a1)
                bpl.s   SKSOZSand_SetSpinningFlowSpeed
                addi.w  #$68,y_vel(a1)
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   SKSOZSand_SpinningAscentReturn
                asr     x_vel(a1)

SKSOZSand_SpinningAscentReturn:
                rts
; ---------------------------------------------------------------------------

SKSOZSand_SetSpinningFlowSpeed:
                move.w  #$A8,y_vel(a1)
                btst    #1,status(a0)
                beq.s   SKSOZSand_TickSpinningDrag
                move.w  #-$330,y_vel(a1)

; Horizontal velocity is halved every eight level frames
SKSOZSand_TickSpinningDrag:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   SKSOZSand_SpinningSpeedReturn
                asr     x_vel(a1)

SKSOZSand_SpinningSpeedReturn:
                rts
; ---------------------------------------------------------------------------

SKSOZSand_UpdateJumpableSurface:
                move.w  $30(a0),d2
                move.w  $32(a0),d3
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.s   UpdatePlayerOnJumpableSozSandSurface
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.s   UpdatePlayerOnJumpableSozSandSurface
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnJumpableSozSandSurface:
                btst    d6,status(a0)
                bne.w   SKSOZSand_CheckSurfaceRiderBounds
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.w   SKSOZSand_SurfaceCaptureReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$33,d0
                cmpi.w  #$40,d0
                bhs.w   SKSOZSand_SurfaceCaptureReturn
                btst    #Status_InAir,status(a1)
                beq.s   SKSOZSand_SurfaceCaptureReturn
                btst    #Status_OnObj,status(a1)
                bne.s   SKSOZSand_SurfaceCaptureReturn
                cmpi.b  #6,routine(a1)
                bhs.s   SKSOZSand_SurfaceCaptureReturn
                tst.b   object_control(a1)
                bne.s   SKSOZSand_SurfaceCaptureReturn
                tst.w   y_vel(a1)
                bmi.s   SKSOZSand_SlowFreeAscent
                bset    #Status_OnObj,status(a1)
                bset    d6,status(a0)
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                bclr    #Status_Roll,status(a1)
                bclr    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,anim(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                asr     x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                asr     y_vel(a1)
                cmpi.b  #2,routine(a1)
                beq.s   SKSOZSand_SurfaceCaptureReturn
                move.b  #2,routine(a1)
                move.b  #2*60,invulnerability_timer(a1)
                move.b  #0,spin_dash_flag(a1)

SKSOZSand_SurfaceCaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKSOZSand_SlowFreeAscent:
                addi.w  #$68,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

SKSOZSand_CheckSurfaceRiderBounds:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.s   SKSOZSand_DetachSurfaceRider
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$33,d0
                cmpi.w  #$40,d0
                bhs.s   SKSOZSand_DetachSurfaceRider
                tst.b   object_control(a1)
                bne.s   SKSOZSand_DetachSurfaceRider
                btst    #Status_InAir,status(a1)
                bne.s   SKSOZSand_TryJumpFromSurface

SKSOZSand_DetachSurfaceRider:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                rts
; ---------------------------------------------------------------------------

SKSOZSand_TryJumpFromSurface:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.s   SKSOZSand_DampSurfaceAscent
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.w  #-$680,y_vel(a1)
                cmpi.b  #2,character_id(a1)
                bne.s   SKSOZSand_ApplySurfaceJumpRoll
                move.w  #-$600,y_vel(a1)

SKSOZSand_ApplySurfaceJumpRoll:
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #1,jumping(a1)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SKSOZSand_DampSurfaceAscent:
                tst.w   y_vel(a1)
                bpl.s   SKSOZSand_SetSurfaceFlowAndDrag
                asr     x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                addi.w  #$68,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

SKSOZSand_SetSurfaceFlowAndDrag:
                asr     x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                move.w  #$A8,y_vel(a1)
                btst    #1,status(a0)
                beq.s   SKSOZSand_SurfaceSpeedReturn
                move.w  #-$198,y_vel(a1)

SKSOZSand_SurfaceSpeedReturn:
                rts
; End of function UpdatePlayerOnJumpableSozSandSurface
