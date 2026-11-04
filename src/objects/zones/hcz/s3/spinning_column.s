; Owner: objects/zones/hcz/s3
; Responsibility: Hydrocity spinning column player contact, rotating transport and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZSpinningColumn:
                move.l  #Map_HCZSpinningColumn,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZ2BlockPlat+$18,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  x_pos(a0),$2E(a0)
                move.w  y_pos(a0),$30(a0)
                move.b  subtype(a0),d0
                move.w  d0,d1
                add.w   d0,d0
                andi.w  #6,d0
                move.w  d0,$3A(a0)
                andi.w  #$F0,d1
                move.w  d1,$40(a0)
                move.w  #1,$42(a0)
                cmpi.w  #$E0,d1
                bne.s   S3SpinningColumn_StartActiveColumn
                neg.w   $42(a0)

S3SpinningColumn_StartActiveColumn:
                move.l  #S3SpinningColumn_UpdateColumnAndRiders,(a0)

S3SpinningColumn_UpdateColumnAndRiders:
                bsr.s   UpdateHczSpinningColumnMotion
                lea     $32(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.w   UpdatePlayerOnHczSpinningColumn
                addq.w  #4,a2
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.w   UpdatePlayerOnHczSpinningColumn
                move.w  #$1B,d1
                move.w  #$20,d2
                move.w  #$21,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3SpinningColumn_CullOrDrawAtAnchor
                move.b  #7,anim_frame_timer(a0)
                subq.b  #1,mapping_frame(a0)
                bcc.s   S3SpinningColumn_CullOrDrawAtAnchor
                move.b  #2,mapping_frame(a0)

S3SpinningColumn_CullOrDrawAtAnchor:
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l

; =============== S U B R O U T I N E =======================================

UpdateHczSpinningColumnMotion:
                move.w  $3A(a0),d0
                move.w  S3SpinningColumn_MotionOffsets(pc,d0.w),d0
                jmp     S3SpinningColumn_MotionOffsets(pc,d0.w)
; End of function UpdateHczSpinningColumnMotion

; ---------------------------------------------------------------------------
S3SpinningColumn_MotionOffsets:
                dc.w    S3SpinningColumn_StationaryReturn-S3SpinningColumn_MotionOffsets
                dc.w    S3SpinningColumn_StepHorizontalForward-S3SpinningColumn_MotionOffsets
                dc.w    S3SpinningColumn_ReadVerticalOscillation-S3SpinningColumn_MotionOffsets
; ---------------------------------------------------------------------------

S3SpinningColumn_StationaryReturn:
                rts
; ---------------------------------------------------------------------------

S3SpinningColumn_StepHorizontalForward:
                move.w  $42(a0),d1
                bmi.s   S3SpinningColumn_StepHorizontalBack
                move.w  $40(a0),d0
                add.w   d1,d0
                cmpi.w  #$E0,d0
                bne.s   S3SpinningColumn_JoinHorizontalStore
                neg.w   $42(a0)

S3SpinningColumn_JoinHorizontalStore:
                bra.s   S3SpinningColumn_StoreAndCenterXOffset
; ---------------------------------------------------------------------------

S3SpinningColumn_StepHorizontalBack:
                move.w  $40(a0),d0
                add.w   d1,d0
                bne.s   S3SpinningColumn_StoreAndCenterXOffset
                neg.w   $42(a0)

S3SpinningColumn_StoreAndCenterXOffset:
                move.w  d0,$40(a0)
                subi.w  #$70,d0
                btst    #0,status(a0)
                beq.s   S3SpinningColumn_ApplyXOffset
                neg.w   d0

S3SpinningColumn_ApplyXOffset:
                add.w   $2E(a0),d0
                move.w  d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3SpinningColumn_ReadVerticalOscillation:
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                btst    #0,status(a0)
                beq.s   S3SpinningColumn_ApplyYOffset
                neg.w   d0
                addi.w  #$80,d0

S3SpinningColumn_ApplyYOffset:
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                rts

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnHczSpinningColumn:
                move.b  (a2),d0
                bne.s   S3SpinningColumn_CheckAndPullInRider
                btst    d6,status(a0)
                beq.s   S3SpinningColumn_CaptureReturn
                move.b  #0,1(a2)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bpl.s   S3SpinningColumn_CaptureStandingRider
                neg.w   d0
                move.b  #$80,1(a2)

S3SpinningColumn_CaptureStandingRider:
                move.b  d0,2(a2)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #3,object_control(a1)
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                bclr    #Status_Roll,status(a1)
                bclr    #Status_InAir,status(a1)
                bclr    #Status_Push,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,jumping(a1)
                move.b  #0,anim(a1)
                move.b  #1,(a2)
                bra.w   loc_31764
; ---------------------------------------------------------------------------

S3SpinningColumn_CaptureReturn:
                rts
; ---------------------------------------------------------------------------

S3SpinningColumn_CheckAndPullInRider:
                tst.b   render_flags(a1)
                bpl.w   S3SpinningColumn_ReleaseRider
                cmpi.b  #4,routine(a1)
                bhs.w   S3SpinningColumn_ReleaseRider
                btst    d6,status(a0)
                beq.w   S3SpinningColumn_ClearRiderAttachment
                tst.b   2(a2)
                beq.s   S3SpinningColumn_PositionTwistingRider
                subq.b  #1,2(a2)

S3SpinningColumn_PositionTwistingRider:
                moveq   #0,d0
                move.b  1(a2),d0
                jsr     (GetSineCosine).l
                addi.w  #$100,d0
                asr.w   #2,d0
                move.b  d0,3(a2)
                moveq   #0,d2
                move.w  2(a2),d2
                muls.w  d2,d1
                swap    d1
                add.w   x_pos(a0),d1
                move.w  d1,x_pos(a1)
                addq.b  #2,1(a2)
                move.w  #0,ground_vel(a1)
                move.w  y_vel(a0),d0
                bpl.s   S3SpinningColumn_TryBoostRiderSpeed
                neg.w   d0

S3SpinningColumn_TryBoostRiderSpeed:
                btst    #Status_InAir,status(a1)
                bne.s   S3SpinningColumn_TryJumpRelease
                cmpi.w  #$480,d0
                blo.s   S3SpinningColumn_TryJumpRelease
                move.w  #$800,ground_vel(a1)

S3SpinningColumn_TryJumpRelease:
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.w   loc_31764
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.w  y_vel(a0),y_vel(a1)
                addi.w  #-$680,y_vel(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,ground_vel(a1)

S3SpinningColumn_ReleaseRider:
                bset    #Status_InAir,status(a1)
                move.w  #$100,priority(a1)
                move.b  #0,object_control(a1)

S3SpinningColumn_ClearRiderAttachment:
                move.b  #0,(a2)
                rts
; End of function UpdatePlayerOnHczSpinningColumn

; ---------------------------------------------------------------------------
Map_HCZSpinningColumn:
                include "src/objects/shared/zones/hcz/mappings/spinning_column.s"
