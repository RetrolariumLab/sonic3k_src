; Owner: objects/zones/ssz/sk
; Responsibility: Elevator bar motion, player attachment and release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SSZElevatorBar:
                move.l  #SKSSZElevatorBar_MoveBarAndGetP1Offset,(a0)
                move.b  #4,render_flags(a0)
                move.b  #4,height_pixels(a0)
                move.b  #$30,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$74,2,0),art_tile(a0)
                move.l  #Map_SSZElevatorBar,mappings(a0)
                move.w  y_pos(a0),y_vel(a0)

SKSSZElevatorBar_MoveBarAndGetP1Offset:
                move.l  #$18000,d0
                move.l  #$480,d1
                jsr     Gradual_SwingOffset(pc)
                add.w   $1A(a0),d0
                move.w  d0,y_pos(a0)
                lea     (Player_1).w,a1
                lea     $38(a0),a2
                move.w  (Ctrl_1_logical).w,d0
                moveq   #$14,d1
                cmpi.w  #2,(Player_mode).w
                bne.s   SKSSZElevatorBar_UpdateBothRiders
                moveq   #$11,d1

SKSSZElevatorBar_UpdateBothRiders:
                bsr.s   UpdatePlayerHangingFromSszElevatorBar
                lea     (Player_2).w,a1
                lea     $39(a0),a2
                move.w  (Ctrl_2_logical).w,d0
                moveq   #$11,d1
                bsr.s   UpdatePlayerHangingFromSszElevatorBar
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerHangingFromSszElevatorBar:
                tst.b   (a2)
                bne.w   SKSSZElevatorBar_CarryOrReleaseHurtRider
                tst.b   2(a2)
                beq.s   SKSSZElevatorBar_TryCaptureRider
                subq.b  #1,2(a2)
                bne.w   SKSSZElevatorBar_RiderUpdateReturn
                move.w  #$180,priority(a0)

SKSSZElevatorBar_TryCaptureRider:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$28,d0
                cmpi.w  #$50,d0
                bhs.w   SKSSZElevatorBar_RiderUpdateReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                cmpi.w  #$18,d0
                bhs.w   SKSSZElevatorBar_RiderUpdateReturn
                tst.b   object_control(a1)
                bne.w   SKSSZElevatorBar_RiderUpdateReturn
                cmpi.b  #4,routine(a1)
                bhs.w   SKSSZElevatorBar_RiderUpdateReturn
                tst.w   (Debug_placement_mode).w
                bne.w   SKSSZElevatorBar_RiderUpdateReturn
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l
                st      (a2)
                move.w  y_pos(a0),y_pos(a1)
                add.w   d1,y_pos(a1)
                clr.w   x_vel(a1)
                clr.w   ground_vel(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #3,object_control(a1)
                andi.b  #$FC,render_flags(a1)
                clr.b   anim(a1)
                move.w  #$E5,d0
                btst    #Status_Facing,status(a1)
                beq.s   SKSSZElevatorBar_ApplyHangingFrame
                addq.w  #4,d0

SKSSZElevatorBar_ApplyHangingFrame:
                move.b  d0,mapping_frame(a1)
                jsr     (Perform_Player_DPLC).l
                bra.w   SKSSZElevatorBar_RiderUpdateReturn
; ---------------------------------------------------------------------------

SKSSZElevatorBar_CarryOrReleaseHurtRider:
                move.w  y_pos(a0),y_pos(a1)
                add.w   d1,y_pos(a1)
                cmpi.b  #4,routine(a1)
                blo.s   SKSSZElevatorBar_TryJumpAndSetPriority
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #60,2(a2)
                bra.s   SKSSZElevatorBar_RiderUpdateReturn
; ---------------------------------------------------------------------------

SKSSZElevatorBar_TryJumpAndSetPriority:
                move.w  d0,d1
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d1
                beq.s   SKSSZElevatorBar_RiderUpdateReturn
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #30,2(a2)
                move.w  #$80,priority(a0)
                move.w  #-$200,d1
                move.w  #-$400,d2
                btst    #button_left+8,d0
                bne.s   SKSSZElevatorBar_AddBarSpeedToJump
                move.w  #$180,priority(a0)
                neg.w   d1
                btst    #button_right+8,d0
                bne.s   SKSSZElevatorBar_AddBarSpeedToJump
                moveq   #0,d1
                btst    #button_down+8,d0
                beq.s   SKSSZElevatorBar_AddBarSpeedToJump
                moveq   #0,d2

SKSSZElevatorBar_AddBarSpeedToJump:
                move.w  d1,x_vel(a1)
                move.l  $2E(a0),d0
                asr.l   #8,d0
                add.w   d2,d0
                move.w  d0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l

SKSSZElevatorBar_RiderUpdateReturn:
                rts
; End of function UpdatePlayerHangingFromSszElevatorBar
