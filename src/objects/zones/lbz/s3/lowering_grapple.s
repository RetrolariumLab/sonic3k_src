; Owner: objects/zones/lbz/s3
; Responsibility: Launch Base lowering grapple movement and player attachment or release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZLoweringGrapple:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  #$80,height_pixels(a0)
                move.w  y_pos(a0),$3C(a0)
                move.l  #Map_LBZLoweringGrapple,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a0)
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                lsl.w   #3,d0
                move.w  d0,$2E(a0)
                move.w  #2,$3A(a0)
                move.b  subtype(a0),d0
                bpl.s   S3LBZLowerGrip_StartGrapple
                move.w  $2E(a0),d0
                move.w  d0,$38(a0)
                move.b  #1,$36(a0)
                add.w   d0,y_pos(a0)
                lsr.w   #4,d0
                addq.w  #1,d0
                move.b  d0,mapping_frame(a0)

S3LBZLowerGrip_StartGrapple:
                move.l  #S3LBZLowerGrip_PickTravelDirection,(a0)

S3LBZLowerGrip_PickTravelDirection:
                tst.b   $36(a0)
                beq.s   S3LBZLowerGrip_CheckNormalModeRiders
                tst.w   $30(a0)
                bne.s   S3LBZLowerGrip_TryRetract
                bra.s   S3LBZLowerGrip_TryExtend
; ---------------------------------------------------------------------------

S3LBZLowerGrip_CheckNormalModeRiders:
                tst.w   $30(a0)
                beq.s   S3LBZLowerGrip_TryRetract

S3LBZLowerGrip_TryExtend:
                move.w  $38(a0),d2
                cmp.w   $2E(a0),d2
                beq.s   S3LBZLowerGrip_UpdateRiders
                add.w   $3A(a0),d2
                bra.s   S3LBZLowerGrip_PlaceAndSelectFrame
; ---------------------------------------------------------------------------

S3LBZLowerGrip_TryRetract:
                move.w  $38(a0),d2
                beq.s   S3LBZLowerGrip_UpdateRiders
                sub.w   $3A(a0),d2

S3LBZLowerGrip_PlaceAndSelectFrame:
                move.w  d2,$38(a0)
                move.w  $3C(a0),d0
                add.w   d2,d0
                move.w  d0,y_pos(a0)
                move.w  d2,d0
                beq.s   S3LBZLowerGrip_SetExtensionFrame
                lsr.w   #4,d0
                addq.w  #1,d0

S3LBZLowerGrip_SetExtensionFrame:
                move.b  d0,mapping_frame(a0)

; Read physical input for both riders
S3LBZLowerGrip_UpdateRiders:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bsr.w   UpdatePlayerOnLbzLoweringGrapple
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2).w,d0
                bsr.w   UpdatePlayerOnLbzLoweringGrapple
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnLbzLoweringGrapple:
                tst.b   (a2)
                beq.w   S3LBZLowerGrip_TickCaptureCooldown
                tst.b   render_flags(a1)
                bpl.s   S3LBZLowerGrip_DetachWithoutJump
                cmpi.b  #4,routine(a1)
                bhs.s   S3LBZLowerGrip_DetachWithoutJump
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3LBZLowerGrip_PlaceRiderAtGrip
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$12,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   S3LBZLowerGrip_TrySetJumpLeft
                move.b  #$3C,2(a2)

S3LBZLowerGrip_TrySetJumpLeft:
                btst    #button_left+8,d0
                beq.s   S3LBZLowerGrip_TrySetJumpRight
                move.w  #-$200,x_vel(a1)

S3LBZLowerGrip_TrySetJumpRight:
                btst    #button_right+8,d0
                beq.s   S3LBZLowerGrip_JumpFromGrip
                move.w  #$200,x_vel(a1)

S3LBZLowerGrip_JumpFromGrip:
                move.w  #-$380,y_vel(a1)
                bset    #Status_InAir,status(a1)
                rts
; ---------------------------------------------------------------------------

S3LBZLowerGrip_DetachWithoutJump:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                rts
; ---------------------------------------------------------------------------

S3LBZLowerGrip_PlaceRiderAtGrip:
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$94,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

S3LBZLowerGrip_TickCaptureCooldown:
                tst.b   2(a2)
                beq.s   S3LBZLowerGrip_TryCaptureAtGrip
                subq.b  #1,2(a2)
                bne.w   S3LBZLowerGrip_CaptureReturn

S3LBZLowerGrip_TryCaptureAtGrip:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   S3LBZLowerGrip_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$88,d1
                cmpi.w  #$18,d1
                bhs.w   S3LBZLowerGrip_CaptureReturn
                tst.b   object_control(a1)
                bmi.s   S3LBZLowerGrip_CaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   S3LBZLowerGrip_CaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   S3LBZLowerGrip_CaptureReturn
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$94,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #1,object_control(a1)
                move.b  #1,(a2)
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

S3LBZLowerGrip_CaptureReturn:
                rts
; End of function UpdatePlayerOnLbzLoweringGrapple

; ---------------------------------------------------------------------------
Map_LBZLoweringGrapple:
                include "src/objects/shared/zones/lbz/mappings/lowering_grapple.s"
