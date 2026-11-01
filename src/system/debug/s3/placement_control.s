; Owner: system/debug/s3
; Responsibility: Debug placement state, movement, object selection and player restoration callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

DebugMode:
                moveq   #0,d0
                move.b  (Debug_placement_routine).w,d0
                move.w  DebugMode_Index(pc,d0.w),d1
                jmp     DebugMode_Index(pc,d1.w)
; End of function DebugMode

; ---------------------------------------------------------------------------
DebugMode_Index:
                dc.w    loc_5B532-DebugMode_Index
                dc.w    loc_5B5BA-DebugMode_Index
; ---------------------------------------------------------------------------

loc_5B532:
                addq.b  #2,(Debug_placement_routine).w
                move.l  mappings(a0),(Debug_saved_mappings).w
                move.w  art_tile(a0),(Debug_saved_art_tile).w
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,(Player_1+y_pos).w
                and.w   d0,(Camera_Y_pos).w
                clr.b   (Scroll_lock).w
                clr.w   (WindTunnel_flag).w
                bclr    #Status_Underwater,status(a0)
                beq.s   loc_5B578
                movea.l a0,a1
                jsr     (Player_ResetAirTimer).l
                move.w  #$600,(Max_speed).w
                move.w  #$C,(Acceleration).w
                move.w  #$80,(Deceleration).w

loc_5B578:
                move.b  #0,mapping_frame(a0)
                move.b  #0,anim(a0)
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #6,d0
                andi.w  #$7E,d0
                lea     (DebugOffs).l,a2
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d6
                cmp.b   (Debug_object).w,d6
                bhi.s   loc_5B5AA
                move.b  #0,(Debug_object).w

loc_5B5AA:
                bsr.w   DebugMode_LoadSelectedObjectAppearance
                move.b  #$C,(Debug_camera_delay).w
                move.b  #1,(Debug_camera_speed).w

loc_5B5BA:
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #6,d0
                andi.w  #$7E,d0
                lea     (DebugOffs).l,a2
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d6
                bsr.w   DebugMode_HandlePlacementControls
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

DebugMode_HandlePlacementControls:
                moveq   #0,d4
                move.w  #1,d1
                move.b  (Ctrl_1_pressed).w,d4
                andi.w  #button_up_mask|button_down_mask|button_left_mask|button_right_mask,d4
                bne.s   loc_5B620
                move.b  (Ctrl_1_held).w,d0
                andi.w  #button_up_mask|button_down_mask|button_left_mask|button_right_mask,d0
                bne.s   loc_5B608
                move.b  #$C,(Debug_camera_delay).w
                move.b  #$F,(Debug_camera_speed).w
                bra.w   loc_5B684
; ---------------------------------------------------------------------------

loc_5B608:
                subq.b  #1,(Debug_camera_delay).w
                bne.s   loc_5B624
                move.b  #1,(Debug_camera_delay).w
                addq.b  #1,(Debug_camera_speed).w
                bne.s   loc_5B620
                move.b  #255,(Debug_camera_speed).w

loc_5B620:
                move.b  (Ctrl_1_held).w,d4

loc_5B624:
                moveq   #0,d1
                move.b  (Debug_camera_speed).w,d1
                addq.w  #1,d1
                swap    d1
                asr.l   #4,d1
                move.l  y_pos(a0),d2
                move.l  x_pos(a0),d3
                btst    #button_up,d4
                beq.s   loc_5B64E
                sub.l   d1,d2
                moveq   #0,d0
                move.w  (Camera_min_Y_pos).w,d0
                swap    d0
                cmp.l   d0,d2
                bge.s   loc_5B64E
                move.l  d0,d2

loc_5B64E:
                btst    #button_down,d4
                beq.s   loc_5B668
                add.l   d1,d2
                moveq   #0,d0
                move.w  (Camera_target_max_Y_pos).w,d0
                addi.w  #$DF,d0
                swap    d0
                cmp.l   d0,d2
                blt.s   loc_5B668
                move.l  d0,d2

loc_5B668:
                btst    #button_left,d4
                beq.s   loc_5B674
                sub.l   d1,d3
                bcc.s   loc_5B674
                moveq   #0,d3

loc_5B674:
                btst    #button_right,d4
                beq.s   loc_5B67C
                add.l   d1,d3

loc_5B67C:
                move.l  d2,y_pos(a0)
                move.l  d3,x_pos(a0)

loc_5B684:
                btst    #button_A,(Ctrl_1_held).w
                beq.s   loc_5B6BC
                btst    #button_C,(Ctrl_1_pressed).w
                beq.s   loc_5B6A0
                subq.b  #1,(Debug_object).w
                bcc.s   loc_5B6B8
                add.b   d6,(Debug_object).w
                bra.s   loc_5B6B8
; ---------------------------------------------------------------------------

loc_5B6A0:
                btst    #button_A,(Ctrl_1_pressed).w
                beq.s   loc_5B6BC
                addq.b  #1,(Debug_object).w
                cmp.b   (Debug_object).w,d6
                bhi.s   loc_5B6B8
                move.b  #0,(Debug_object).w

loc_5B6B8:
                bra.w   DebugMode_LoadSelectedObjectAppearance
; ---------------------------------------------------------------------------

loc_5B6BC:
                btst    #button_C,(Ctrl_1_pressed).w
                beq.s   loc_5B708
                jsr     (AllocateObject).l
                bne.s   loc_5B708
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  render_flags(a0),status(a1)
                andi.b  #$7F,status(a1)
                moveq   #0,d0
                move.b  (Debug_object).w,d0
                add.w   d0,d0
                move.w  d0,d1
                lsl.w   #2,d0
                add.w   d1,d0
                move.b  4(a2,d0.w),subtype(a1)
                move.l  (a2,d0.w),(a1)
                move.b  #0,(a1)
                rts
; ---------------------------------------------------------------------------

loc_5B708:
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   locret_5B734
                moveq   #0,d0
                move.w  d0,(Debug_placement_mode).w
                lea     (Player_1).w,a1
                move.l  (Debug_saved_mappings).w,mappings(a1)
                move.w  (Debug_saved_art_tile).w,art_tile(a1)
                bsr.s   DebugMode_ResetPlayerAfterPlacement
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)

locret_5B734:
                rts
; End of function DebugMode_HandlePlacementControls

; =============== S U B R O U T I N E =======================================

DebugMode_ResetPlayerAfterPlacement:
                move.b  d0,anim(a1)
                move.w  d0,x_pos+2(a1)
                move.w  d0,y_pos+2(a1)
                move.b  d0,object_control(a1)
                move.b  d0,spin_dash_flag(a1)
                move.w  d0,x_vel(a1)
                move.w  d0,y_vel(a1)
                move.w  d0,ground_vel(a1)
                move.b  #1<<Status_InAir,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function DebugMode_ResetPlayerAfterPlacement

; =============== S U B R O U T I N E =======================================

DebugMode_LoadSelectedObjectAppearance:
                moveq   #0,d0
                move.b  (Debug_object).w,d0
                add.w   d0,d0
                move.w  d0,d1
                lsl.w   #2,d0
                add.w   d1,d0
                move.l  4(a2,d0.w),mappings(a0)
                move.w  8(a2,d0.w),art_tile(a0)
                move.b  (a2,d0.w),mapping_frame(a0)
                rts
; End of function DebugMode_LoadSelectedObjectAppearance
