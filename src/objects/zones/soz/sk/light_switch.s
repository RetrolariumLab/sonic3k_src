; Owner: objects/zones/soz/sk
; Responsibility: Light-switch activation, player contact, timer state and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZLightSwitch:
                move.b  #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  y_pos(a0),$46(a0)
                move.l  #Map_SOZLightSwitch,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZ2Extra,0,0),art_tile(a0)
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                lsl.w   #3,d0
                move.w  d0,$2E(a0)
                move.w  #2,$38(a0)
                move.b  #6,mapping_frame(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                move.l  #SKSOZLightSwitch_ChooseGripDirection,(a0)

SKSOZLightSwitch_ChooseGripDirection:
                tst.b   $34(a0)
                beq.s   SKSOZLightSwitch_CheckNormalGripRiders
                tst.w   $30(a0)
                bne.s   SKSOZLightSwitch_RetractGrip
                bra.s   SKSOZLightSwitch_ExtendGrip
; ---------------------------------------------------------------------------

SKSOZLightSwitch_CheckNormalGripRiders:
                tst.w   $30(a0)
                beq.s   SKSOZLightSwitch_RetractGrip

; Restore the light when the new extension reaches the stop exactly
SKSOZLightSwitch_ExtendGrip:
                move.w  $36(a0),d2
                cmp.w   $2E(a0),d2
                beq.s   SKSOZLightSwitch_UpdateRidersAndDraw
                add.w   $38(a0),d2
                cmp.w   $2E(a0),d2
                bne.s   SKSOZLightSwitch_PlaceGrip
                move.w  #(15*60)-1,(Palette_cycle_counter1).w
                move.b  #0,(SOZ_darkness_level).w
                move.w  (Palette_cycle_counters+$06).w,d0
                neg.b   d0
                move.b  d0,(Palette_cycle_counters+$00).w
                move.w  #0,(Palette_cycle_counters+$08).w
                bra.s   SKSOZLightSwitch_PlaceGrip
; ---------------------------------------------------------------------------

SKSOZLightSwitch_RetractGrip:
                move.w  $36(a0),d2
                beq.s   SKSOZLightSwitch_UpdateRidersAndDraw
                sub.w   $38(a0),d2

SKSOZLightSwitch_PlaceGrip:
                move.w  d2,$36(a0)
                move.w  $46(a0),d0
                add.w   d2,d0
                move.w  d0,sub2_y_pos(a0)
                move.w  d2,d0
                beq.s   SKSOZLightSwitch_SetGripFrame
                lsr.w   #3,d0
                addq.w  #1,d0

SKSOZLightSwitch_SetGripFrame:
                move.b  d0,sub2_mapframe(a0)

SKSOZLightSwitch_UpdateRidersAndDraw:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d0
                bsr.w   UpdatePlayerHangingFromSozLightSwitch
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2_logical).w,d0
                bsr.w   UpdatePlayerHangingFromSozLightSwitch
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerHangingFromSozLightSwitch:
                tst.b   (a2)
                beq.w   SKSOZLightSwitch_TickRecaptureCooldown
                tst.b   render_flags(a1)
                bpl.s   SKSOZLightSwitch_DetachRider
                cmpi.b  #4,routine(a1)
                bhs.s   SKSOZLightSwitch_DetachRider
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKSOZLightSwitch_TryCheckRiderFloor
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #18,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   SKSOZLightSwitch_TrySetJumpLeft
                move.b  #60,2(a2)

SKSOZLightSwitch_TrySetJumpLeft:
                btst    #button_left+8,d0
                beq.s   SKSOZLightSwitch_TrySetJumpRight
                move.w  #-$200,x_vel(a1)

SKSOZLightSwitch_TrySetJumpRight:
                btst    #button_right+8,d0
                beq.s   SKSOZLightSwitch_ReleaseWithRollingJump
                move.w  #$200,x_vel(a1)

SKSOZLightSwitch_ReleaseWithRollingJump:
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

SKSOZLightSwitch_DetachRider:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                rts
; ---------------------------------------------------------------------------

; Probe the floor before keeping the rider attached only for negative subtypes
SKSOZLightSwitch_TryCheckRiderFloor:
                tst.b   subtype(a0)
                bpl.s   SKSOZLightSwitch_PlaceRiderBelowGrip
                movem.l a1-a2,-(sp)
                jsr     (SonicOnObjHitFloor).l
                movem.l (sp)+,a1-a2
                tst.w   d1
                beq.s   SKSOZLightSwitch_DetachRider
                bmi.s   SKSOZLightSwitch_DetachRider

SKSOZLightSwitch_PlaceRiderBelowGrip:
                move.w  sub2_y_pos(a0),y_pos(a1)
                addi.w  #$30,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

SKSOZLightSwitch_TickRecaptureCooldown:
                tst.b   2(a2)
                beq.s   SKSOZLightSwitch_TryCaptureRider
                subq.b  #1,2(a2)
                bne.w   SKSOZLightSwitch_CaptureReturn

SKSOZLightSwitch_TryCaptureRider:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   SKSOZLightSwitch_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   sub2_y_pos(a0),d1
                subi.w  #$30,d1
                cmpi.w  #$18,d1
                bhs.w   SKSOZLightSwitch_CaptureReturn
                tst.b   object_control(a1)
                bmi.s   SKSOZLightSwitch_CaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   SKSOZLightSwitch_CaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKSOZLightSwitch_CaptureReturn
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  sub2_y_pos(a0),y_pos(a1)
                addi.w  #$30,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #1,object_control(a1)
                move.b  #1,(a2)
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

SKSOZLightSwitch_CaptureReturn:
                rts
; End of function UpdatePlayerHangingFromSozLightSwitch

; ---------------------------------------------------------------------------
Map_SOZLightSwitch:
                include "src/objects/shared/zones/soz/mappings/light_switch.s"
