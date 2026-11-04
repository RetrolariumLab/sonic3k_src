; Owner: objects/zones/lbz/sk
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
                bpl.s   SKLBZLowerGrip_StartGrapple
                move.w  $2E(a0),d0
                move.w  d0,$38(a0)
                move.b  #1,$36(a0)
                add.w   d0,y_pos(a0)
                lsr.w   #4,d0
                addq.w  #1,d0
                move.b  d0,mapping_frame(a0)

SKLBZLowerGrip_StartGrapple:
                move.l  #SKLBZLowerGrip_PickTravelDirection,(a0)

SKLBZLowerGrip_PickTravelDirection:
                tst.b   $36(a0)
                beq.s   SKLBZLowerGrip_CheckNormalModeRiders
                tst.w   $30(a0)
                bne.s   SKLBZLowerGrip_TryRetract
                bra.s   SKLBZLowerGrip_TryExtend
; ---------------------------------------------------------------------------

SKLBZLowerGrip_CheckNormalModeRiders:
                tst.w   $30(a0)
                beq.s   SKLBZLowerGrip_TryRetract

SKLBZLowerGrip_TryExtend:
                move.w  $38(a0),d2
                cmp.w   $2E(a0),d2
                beq.s   SKLBZLowerGrip_UpdateRiders
                add.w   $3A(a0),d2
                bra.s   SKLBZLowerGrip_PlaceAndSelectFrame
; ---------------------------------------------------------------------------

SKLBZLowerGrip_TryRetract:
                move.w  $38(a0),d2
                beq.s   SKLBZLowerGrip_UpdateRiders
                sub.w   $3A(a0),d2

SKLBZLowerGrip_PlaceAndSelectFrame:
                move.w  d2,$38(a0)
                move.w  $3C(a0),d0
                add.w   d2,d0
                move.w  d0,y_pos(a0)
                move.w  d2,d0
                beq.s   SKLBZLowerGrip_SetExtensionFrame
                lsr.w   #4,d0
                addq.w  #1,d0

SKLBZLowerGrip_SetExtensionFrame:
                move.b  d0,mapping_frame(a0)

; Read logical input for both riders
SKLBZLowerGrip_UpdateRiders:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d0
                bsr.w   UpdatePlayerOnLbzLoweringGrapple
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2_logical).w,d0
                bsr.w   UpdatePlayerOnLbzLoweringGrapple
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnLbzLoweringGrapple:
                tst.b   (a2)
                beq.w   SKLBZLowerGrip_TickCaptureCooldown
                tst.b   render_flags(a1)
                bpl.s   SKLBZLowerGrip_DetachWithoutJump
                cmpi.b  #4,routine(a1)
                bhs.s   SKLBZLowerGrip_DetachWithoutJump
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKLBZLowerGrip_PlaceRiderAtGrip
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$12,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   SKLBZLowerGrip_TrySetJumpLeft
                move.b  #$3C,2(a2)

SKLBZLowerGrip_TrySetJumpLeft:
                btst    #button_left+8,d0
                beq.s   SKLBZLowerGrip_TrySetJumpRight
                move.w  #-$200,x_vel(a1)

SKLBZLowerGrip_TrySetJumpRight:
                btst    #button_right+8,d0
                beq.s   SKLBZLowerGrip_JumpFromGrip
                move.w  #$200,x_vel(a1)

; Release into the rolling jump pose and restore compact radii
SKLBZLowerGrip_JumpFromGrip:
                move.w  #-$380,y_vel(a1)
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

SKLBZLowerGrip_DetachWithoutJump:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                rts
; ---------------------------------------------------------------------------

SKLBZLowerGrip_PlaceRiderAtGrip:
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$94,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

SKLBZLowerGrip_TickCaptureCooldown:
                tst.b   2(a2)
                beq.s   SKLBZLowerGrip_TryCaptureAtGrip
                subq.b  #1,2(a2)
                bne.w   SKLBZLowerGrip_CaptureReturn

SKLBZLowerGrip_TryCaptureAtGrip:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   SKLBZLowerGrip_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$88,d1
                cmpi.w  #$18,d1
                bhs.w   SKLBZLowerGrip_CaptureReturn
                tst.b   object_control(a1)
                bmi.s   SKLBZLowerGrip_CaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   SKLBZLowerGrip_CaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKLBZLowerGrip_CaptureReturn
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

SKLBZLowerGrip_CaptureReturn:
                rts
; End of function UpdatePlayerOnLbzLoweringGrapple
