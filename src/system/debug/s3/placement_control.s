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
                dc.w    S3DebugPlacement_Enter-DebugMode_Index
                dc.w    S3DebugPlacement_UpdateAndDraw-DebugMode_Index
; ---------------------------------------------------------------------------

S3DebugPlacement_Enter:
                addq.b  #2,(Debug_placement_routine).w
                move.l  mappings(a0),(Debug_saved_mappings).w
                move.w  art_tile(a0),(Debug_saved_art_tile).w
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,(Player_1+y_pos).w
                and.w   d0,(Camera_Y_pos).w
                clr.b   (Scroll_lock).w
                clr.w   (WindTunnel_flag).w
                bclr    #Status_Underwater,status(a0)
                beq.s   S3DebugPlacement_ClearPoseAndLoadActList
                movea.l a0,a1
                jsr     (Player_ResetAirTimer).l
                move.w  #$600,(Max_speed).w
                move.w  #$C,(Acceleration).w
                move.w  #$80,(Deceleration).w

S3DebugPlacement_ClearPoseAndLoadActList:
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
                bhi.s   S3DebugPlacement_LoadPreviewResetRepeat
                move.b  #0,(Debug_object).w

S3DebugPlacement_LoadPreviewResetRepeat:
                bsr.w   DebugMode_LoadSelectedObjectAppearance
                move.b  #$C,(Debug_camera_delay).w
                move.b  #1,(Debug_camera_speed).w

S3DebugPlacement_UpdateAndDraw:
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
                bne.s   S3DebugPlacement_ReadHeldDirections
                move.b  (Ctrl_1_held).w,d0
                andi.w  #button_up_mask|button_down_mask|button_left_mask|button_right_mask,d0
                bne.s   S3DebugPlacement_RepeatHeldMove
                move.b  #$C,(Debug_camera_delay).w
                move.b  #$F,(Debug_camera_speed).w
                bra.w   S3DebugPlacement_PrevObjectOnHeldAAndC
; ---------------------------------------------------------------------------

; Keep repeat speed at 255 when the byte wraps
S3DebugPlacement_RepeatHeldMove:
                subq.b  #1,(Debug_camera_delay).w
                bne.s   S3DebugPlacement_CalcStepAndMoveUp
                move.b  #1,(Debug_camera_delay).w
                addq.b  #1,(Debug_camera_speed).w
                bne.s   S3DebugPlacement_ReadHeldDirections
                move.b  #255,(Debug_camera_speed).w

S3DebugPlacement_ReadHeldDirections:
                move.b  (Ctrl_1_held).w,d4

S3DebugPlacement_CalcStepAndMoveUp:
                moveq   #0,d1
                move.b  (Debug_camera_speed).w,d1
                addq.w  #1,d1
                swap    d1
                asr.l   #4,d1
                move.l  y_pos(a0),d2
                move.l  x_pos(a0),d3
                btst    #button_up,d4
                beq.s   S3DebugPlacement_MoveDownClamped
                sub.l   d1,d2
                moveq   #0,d0
                move.w  (Camera_min_Y_pos).w,d0
                swap    d0
                cmp.l   d0,d2
                bge.s   S3DebugPlacement_MoveDownClamped
                move.l  d0,d2

; Clamp Y at the target camera limit plus $DF
S3DebugPlacement_MoveDownClamped:
                btst    #button_down,d4
                beq.s   S3DebugPlacement_MoveLeftClamped
                add.l   d1,d2
                moveq   #0,d0
                move.w  (Camera_target_max_Y_pos).w,d0
                addi.w  #$DF,d0
                swap    d0
                cmp.l   d0,d2
                blt.s   S3DebugPlacement_MoveLeftClamped
                move.l  d0,d2

; Clamp left movement to zero on unsigned borrow. Right movement has no upper clamp
S3DebugPlacement_MoveLeftClamped:
                btst    #button_left,d4
                beq.s   S3DebugPlacement_MoveRight
                sub.l   d1,d3
                bcc.s   S3DebugPlacement_MoveRight
                moveq   #0,d3

S3DebugPlacement_MoveRight:
                btst    #button_right,d4
                beq.s   S3DebugPlacement_StoreFixedPointPos
                add.l   d1,d3

S3DebugPlacement_StoreFixedPointPos:
                move.l  d2,y_pos(a0)
                move.l  d3,x_pos(a0)

; Press C while holding A to select the previous object
S3DebugPlacement_PrevObjectOnHeldAAndC:
                btst    #button_A,(Ctrl_1_held).w
                beq.s   S3DebugPlacement_TrySpawnOnC
                btst    #button_C,(Ctrl_1_pressed).w
                beq.s   S3DebugPlacement_NextObjectOnAPress
                subq.b  #1,(Debug_object).w
                bcc.s   S3DebugPlacement_ReloadPreview
                add.b   d6,(Debug_object).w
                bra.s   S3DebugPlacement_ReloadPreview
; ---------------------------------------------------------------------------

S3DebugPlacement_NextObjectOnAPress:
                btst    #button_A,(Ctrl_1_pressed).w
                beq.s   S3DebugPlacement_TrySpawnOnC
                addq.b  #1,(Debug_object).w
                cmp.b   (Debug_object).w,d6
                bhi.s   S3DebugPlacement_ReloadPreview
                move.b  #0,(Debug_object).w

S3DebugPlacement_ReloadPreview:
                bra.w   DebugMode_LoadSelectedObjectAppearance
; ---------------------------------------------------------------------------

S3DebugPlacement_TrySpawnOnC:
                btst    #button_C,(Ctrl_1_pressed).w
                beq.s   S3DebugPlacement_TryExit
                jsr     (AllocateObject).l
                bne.s   S3DebugPlacement_TryExit
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

S3DebugPlacement_TryExit:
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   S3DebugPlacement_ControlsReturn
                moveq   #0,d0
                move.w  d0,(Debug_placement_mode).w
                lea     (Player_1).w,a1
                move.l  (Debug_saved_mappings).w,mappings(a1)
                move.w  (Debug_saved_art_tile).w,art_tile(a1)
                bsr.s   DebugMode_ResetPlayerAfterPlacement
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)

S3DebugPlacement_ControlsReturn:
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
