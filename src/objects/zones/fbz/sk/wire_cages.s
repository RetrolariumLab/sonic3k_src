; Owner: objects/zones/fbz/sk
; Responsibility: Moving and stationary wire-cage variants, player capture, constrained motion and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZWireCage:
                move.b  subtype(a0),d0
                bpl.s   SKFBZCage_InitHorizontalSpan
                andi.w  #$7F,d0
                lsl.w   #3,d0
                move.w  d0,subtype(a0)
                move.l  #SKFBZCage_UpdateVerticalRiders,(a0)
                bra.w   SKFBZCage_UpdateVerticalRiders
; ---------------------------------------------------------------------------

SKFBZCage_InitHorizontalSpan:
                andi.w  #$7F,d0
                lsl.w   #3,d0
                move.w  d0,subtype(a0)
                move.l  #SKFBZCage_UpdateHorizontalRiders,(a0)

SKFBZCage_UpdateHorizontalRiders:
                move.w  subtype(a0),d4
                move.w  d4,d5
                add.w   d5,d5
                lea     (Player_1).w,a1
                lea     (_unkF7B0+0).w,a2
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerOnFbzHorizontalWireCage
                lea     (Player_2).w,a1
                lea     (_unkF7B0+1).w,a2
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   UpdatePlayerOnFbzHorizontalWireCage
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnFbzHorizontalWireCage:
                btst    d6,status(a0)
                bne.w   SKFBZCage_CheckHorizontalRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d4,d0
                cmp.w   d5,d0
                bhs.w   SKFBZCage_HorizontalCaptureReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$50,d0
                cmpi.w  #$18,d0
                bhs.s   SKFBZCage_TickHorizontalCooldown
                move.b  #$28,2(a2)

SKFBZCage_TickHorizontalCooldown:
                tst.b   2(a2)
                beq.s   SKFBZCage_TryHorizontalCapture
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

SKFBZCage_TryHorizontalCapture:
                move.w  y_pos(a0),d0
                addi.w  #$3C,d0
                move.w  y_pos(a1),d2
                move.b  y_radius(a1),d1
                ext.w   d1
                add.w   d2,d1
                addq.w  #4,d1
                sub.w   d1,d0
                bhi.s   SKFBZCage_HorizontalCaptureReturn
                cmpi.w  #-$10,d0
                blo.s   SKFBZCage_HorizontalCaptureReturn
                cmpi.b  #6,routine(a1)
                bhs.s   SKFBZCage_HorizontalCaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKFBZCage_HorizontalCaptureReturn
                add.w   d0,d2
                addq.w  #3,d2
                move.w  d2,y_pos(a1)
                jsr     (RideObject_SetRide).l
                move.b  #$80,flip_type(a1)
                move.w  #1,anim(a1)
                move.b  #0,(a2)
                move.b  #0,2(a2)
                tst.w   ground_vel(a1)
                bne.s   SKFBZCage_HorizontalCaptureReturn
                move.w  #1,ground_vel(a1)

SKFBZCage_HorizontalCaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKFBZCage_CheckHorizontalRider:
                btst    #1,status(a1)
                bne.s   SKFBZCage_TryDampDepartureYSpeed
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d4,d0
                cmp.w   d5,d0
                blo.s   SKFBZCage_ProjectHorizontalRideY

SKFBZCage_ReleaseHorizontalRider:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                bset    #1,status(a1)
                move.b  #0,flip_type(a1)
                rts
; ---------------------------------------------------------------------------

SKFBZCage_TryDampDepartureYSpeed:
                move.b  (a2),d0
                addi.b  #$20,d0
                cmpi.b  #$40,d0
                bhs.s   SKFBZCage_ClearDepartureYSpeed
                asr     y_vel(a1)
                bra.s   SKFBZCage_ReleaseHorizontalRider
; ---------------------------------------------------------------------------

SKFBZCage_ClearDepartureYSpeed:
                move.w  #0,y_vel(a1)
                bra.s   SKFBZCage_ReleaseHorizontalRider
; ---------------------------------------------------------------------------

SKFBZCage_ProjectHorizontalRideY:
                btst    #Status_OnObj,status(a1)
                beq.s   SKFBZCage_HorizontalCaptureReturn
                move.b  (a2),d0
                jsr     (GetSineCosine).l
                muls.w  #$2800,d1
                swap    d1
                move.w  y_pos(a0),d2
                add.w   d1,d2
                moveq   #0,d1
                move.b  y_radius(a1),d1
                subi.w  #$13,d1
                sub.w   d1,d2
                move.w  d2,y_pos(a1)
                move.b  (a2),d0
                move.b  d0,flip_angle(a1)
                addq.b  #4,(a2)
                tst.w   ground_vel(a1)
                bne.s   SKFBZCage_HorizontalProjectionReturn
                move.w  #1,ground_vel(a1)

SKFBZCage_HorizontalProjectionReturn:
                rts
; End of function UpdatePlayerOnFbzHorizontalWireCage

; ---------------------------------------------------------------------------

SKFBZCage_UpdateVerticalRiders:
                move.w  subtype(a0),d4
                move.w  d4,d5
                add.w   d5,d5
                lea     (Player_1).w,a1
                lea     (_unkF7B0+0).w,a2
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerOnFbzVerticalWireCage
                lea     (Player_2).w,a1
                lea     (_unkF7B0+1).w,a2
; Bug: if player 1 was riding the object, then d6 may have become dirty from
; a call to Perform_Player_DPLC, causing player 2 to behave erratically
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   UpdatePlayerOnFbzVerticalWireCage
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnFbzVerticalWireCage:
                btst    d6,status(a0)
                bne.w   SKFBZCage_CheckVerticalRideSpan
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$80,d0
                cmpi.w  #$100,d0
                bhs.w   SKFBZCage_VerticalCaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d4,d1
                cmp.w   d5,d1
                bhs.w   SKFBZCage_VerticalCaptureReturn
                cmpi.b  #6,routine(a1)
                bhs.w   SKFBZCage_VerticalCaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.w   SKFBZCage_VerticalCaptureReturn
                tst.b   object_control(a1)
                bmi.s   SKFBZCage_VerticalCaptureReturn
                cmpi.w  #$20,d0
                blo.s   SKFBZCage_AttachAtVerticalEdge
                cmpi.w  #$E0,d0
                blo.s   SKFBZCage_VerticalCaptureReturn

SKFBZCage_AttachAtVerticalEdge:
                bsr.w   AttachPlayerToScriptedRideObject
                move.b  #-$40,angle(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                move.b  #0,(a2)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcc.s   SKFBZCage_SetVerticalRideDirection
                move.b  #$80,(a2)

SKFBZCage_SetVerticalRideDirection:
                move.w  y_vel(a1),ground_vel(a1)
                neg.w   ground_vel(a1)
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                bcc.s   SKFBZCage_BeginVerticalControl
                move.b  #$40,angle(a1)
                neg.w   ground_vel(a1)

SKFBZCage_BeginVerticalControl:
                bset    #6,object_control(a1)
                bset    #1,object_control(a1)
                move.w  #1,anim(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,2(a2)
                bra.s   SKFBZCage_CheckVerticalRideSpan
; ---------------------------------------------------------------------------

SKFBZCage_VerticalCaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKFBZCage_CheckVerticalRideSpan:
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d4,d1
                cmp.w   d5,d1
                blo.s   SKFBZCage_SetVerticalRideFlip
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #1,flip_angle(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                bset    #Status_InAir,status(a1)
                rts
; ---------------------------------------------------------------------------

SKFBZCage_SetVerticalRideFlip:
                btst    #Status_OnObj,status(a1)
                beq.s   SKFBZCage_VerticalCaptureReturn
                bclr    #1,render_flags(a1)
                tst.w   y_vel(a1)
                bmi.s   SKFBZCage_ProjectVerticalRideX
                bset    #1,render_flags(a1)

SKFBZCage_ProjectVerticalRideX:
                move.b  (a2),d0
                jsr     (GetSineCosine).l
                muls.w  #$6800,d1
                swap    d1
                move.w  x_pos(a0),d2
                add.w   d1,d2
                moveq   #0,d1
                move.b  y_radius(a1),d1
                subi.w  #$13,d1
                sub.w   d1,d2
                move.w  d2,x_pos(a1)
                moveq   #0,d2
                move.b  (a2),d2
                addq.b  #4,(a2)
                divu.w  #$B,d2
                move.b  SKFBZCage_VerticalRideFrames(pc,d2.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; End of function UpdatePlayerOnFbzVerticalWireCage

; ---------------------------------------------------------------------------
SKFBZCage_VerticalRideFrames:
                dc.b    $6D, $6D, $6E, $6E, $6F, $6F, $70, $70, $71, $71, $72, $72, $73, $73, $74, $74, $75, $75, $76, $76
                dc.b    $77, $77, $6C, $6C, $6D, $6D
                even
; ---------------------------------------------------------------------------

Obj_FBZWireCageStationary:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #8,d0
                move.w  d0,$40(a0)
                lsl.w   #2,d0
                move.w  d0,$42(a0)
                move.l  #SKFBZCage_UpdateStationaryRiders,(a0)

SKFBZCage_UpdateStationaryRiders:
                lea     (Player_1).w,a1
                lea     $30(a0),a2
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerInFbzStationaryWireCage
                lea     (Player_2).w,a1
                lea     $38(a0),a2
; Bug: if player 1 was riding the object, then d6 may have become dirty from
; a call to Perform_Player_DPLC, causing player 2 to behave erratically
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   UpdatePlayerInFbzStationaryWireCage
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInFbzStationaryWireCage:
                btst    d6,status(a0)
                bne.w   SKFBZCage_CalcAbsRideSpeed
                btst    #Status_InAir,status(a1)
                bne.w   SKFBZCage_StationaryCaptureReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                tst.w   x_vel(a1)
                bmi.s   SKFBZCage_CheckRightEntry
                cmpi.w  #-$B0,d0
                bgt.w   SKFBZCage_StationaryCaptureReturn
                cmpi.w  #-$C0,d0
                blt.s   SKFBZCage_StationaryCaptureReturn
                moveq   #0,d2
                bra.s   SKFBZCage_CheckEntryYAndSpeed
; ---------------------------------------------------------------------------

SKFBZCage_CheckRightEntry:
                cmpi.w  #$B0,d0
                blt.s   SKFBZCage_StationaryCaptureReturn
                cmpi.w  #$C0,d0
                bgt.s   SKFBZCage_StationaryCaptureReturn
                moveq   #1,d2

SKFBZCage_CheckEntryYAndSpeed:
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$10,d1
                cmpi.w  #$20,d1
                bhs.s   SKFBZCage_StationaryCaptureReturn
                move.w  ground_vel(a1),d0
                bpl.s   SKFBZCage_CheckSpeedAndSide
                neg.w   d0

SKFBZCage_CheckSpeedAndSide:
                cmpi.w  #$400,d0
                blo.s   SKFBZCage_StationaryCaptureReturn
                tst.b   object_control(a1)
                bne.s   SKFBZCage_StationaryCaptureReturn
                moveq   #0,d3
                tst.b   subtype(a0)
                beq.s   SKFBZCage_AttachStationaryRider
                btst    #0,status(a0)
                bne.s   SKFBZCage_RequireRightEntry
                tst.w   d2
                bne.s   SKFBZCage_StationaryCaptureReturn
                bra.s   SKFBZCage_AttachStationaryRider
; ---------------------------------------------------------------------------

SKFBZCage_RequireRightEntry:
                tst.w   d2
                beq.s   SKFBZCage_StationaryCaptureReturn

SKFBZCage_AttachStationaryRider:
                move.l  #0,(a2)
                move.b  d2,4(a2)
                move.w  d3,6(a2)
                bset    #Status_InAir,status(a1)
                jsr     (RideObject_SetRide).l
                move.b  #$42,object_control(a1)
                bra.s   SKFBZCage_CalcAbsRideSpeed
; ---------------------------------------------------------------------------

SKFBZCage_StationaryCaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKFBZCage_CalcAbsRideSpeed:
                move.w  ground_vel(a1),d0
                bpl.s   SKFBZCage_CheckRideAndPickPath
                neg.w   d0

SKFBZCage_CheckRideAndPickPath:
                cmpi.w  #$400,d0
                blo.s   SKFBZCage_ReleaseStationaryAirborne
                btst    #Status_InAir,status(a1)
                bne.s   SKFBZCage_ReleaseStationaryAirborne
                tst.l   (a2)
                bne.w   SKFBZCage_StepHelixProgress
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$C0,d0
                bmi.s   SKFBZCage_ReleaseAtStationaryEnd
                cmpi.w  #$180,d0
                blo.s   SKFBZCage_TryEnterHelixLeft

SKFBZCage_ReleaseAtStationaryEnd:
                bclr    #Status_Roll,status(a1)
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                move.w  #1,anim(a1)
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                rts
; ---------------------------------------------------------------------------

SKFBZCage_ReleaseStationaryAirborne:
                asr     x_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_Roll,status(a1)
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                move.w  #1,anim(a1)
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #-$40,flip_angle(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                rts
; ---------------------------------------------------------------------------

SKFBZCage_TryEnterHelixLeft:
                btst    #Status_OnObj,status(a1)
                beq.w   SKFBZCage_StationaryCaptureReturn
                tst.b   subtype(a0)
                beq.s   SKFBZCage_SetFlatRidePose
                tst.b   4(a2)
                bne.s   SKFBZCage_TryEnterHelixRight
                cmpi.w  #$C0,d0
                blo.s   SKFBZCage_SetFlatRidePose
                tst.w   ground_vel(a1)
                bmi.s   SKFBZCage_SetFlatRidePose
                subi.w  #$C0,d0
                move.w  d0,(a2)
                move.w  #0,2(a2)
                bset    #0,render_flags(a1)
                bset    #1,render_flags(a1)
                bra.w   SKFBZCage_StepHelixProgress
; ---------------------------------------------------------------------------

SKFBZCage_TryEnterHelixRight:
                cmpi.w  #$C0,d0
                bhs.s   SKFBZCage_SetFlatRidePose
                tst.w   ground_vel(a1)
                bpl.s   SKFBZCage_SetFlatRidePose
                subi.w  #$C0,d0
                add.w   $42(a0),d0
                move.w  d0,(a2)
                move.w  #0,2(a2)
                move.w  $40(a0),d0
                neg.w   d0
                move.w  d0,6(a2)
                bclr    #0,render_flags(a1)
                bclr    #1,render_flags(a1)
                bra.s   SKFBZCage_StepHelixProgress
; ---------------------------------------------------------------------------

SKFBZCage_SetFlatRidePose:
                lsr.w   #5,d0
                andi.w  #$F,d0
                move.b  SKFBZCage_FlatRideHeights(pc,d0.w),d1
                move.b  SKFBZCage_FlatRideFrames(pc,d0.w),mapping_frame(a1)
                ext.w   d1
                move.w  y_pos(a0),d2
                add.w   6(a2),d2
                add.w   d1,d2
                moveq   #0,d1
                move.b  y_radius(a1),d1
                subi.w  #$13,d1
                sub.w   d1,d2
                move.w  d2,y_pos(a1)
                moveq   #0,d0
                move.b  d0,anim(a1)
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------
SKFBZCage_FlatRideHeights:
                dc.b    4,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   4
SKFBZCage_FlatRideFrames:
                dc.b    $49, $54, $53, $52, $53, $52, $53, $52, $53, $52, $54, $49
                even
; ---------------------------------------------------------------------------

SKFBZCage_StepHelixProgress:
                move.w  ground_vel(a1),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,(a2)
                bpl.s   SKFBZCage_CheckHelixEnd
                move.l  #0,(a2)
                move.b  #0,4(a2)
                move.w  $40(a0),d0
                neg.w   d0
                move.w  d0,6(a2)
                bset    #0,render_flags(a1)
                bclr    #1,render_flags(a1)
                bra.w   SKFBZCage_CalcAbsRideSpeed
; ---------------------------------------------------------------------------

SKFBZCage_CheckHelixEnd:
                move.w  (a2),d0
                cmp.w   $42(a0),d0
                blo.s   SKFBZCage_ProjectHelixAndSetSpeed
                move.l  #0,(a2)
                move.b  #1,4(a2)
                move.w  $40(a0),6(a2)
                bclr    #0,render_flags(a1)
                bclr    #1,render_flags(a1)
                bra.w   SKFBZCage_CalcAbsRideSpeed
; ---------------------------------------------------------------------------

SKFBZCage_ProjectHelixAndSetSpeed:
                move.w  x_pos(a1),d2
                move.w  (a2),d0
                lsr.w   #1,d0
                jsr     (GetSineCosine).l
                muls.w  #$6800,d0
                swap    d0
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                sub.w   d2,d0
                asl.w   #8,d0
                move.w  d0,x_vel(a1)
                move.w  y_pos(a1),d2
                move.w  (a2),d0
                lsr.w   #2,d0
                add.w   6(a2),d0
                add.w   y_pos(a0),d0
                move.w  d0,y_pos(a1)
                sub.w   d2,d0
                asl.w   #8,d0
                move.w  d0,y_vel(a1)
                moveq   #0,d0
                move.w  (a2),d0
                lsr.w   #1,d0
                andi.w  #$FF,d0
                tst.w   ground_vel(a1)
                bpl.s   SKFBZCage_ApplyHelixPose
                neg.b   d0

SKFBZCage_ApplyHelixPose:
                divu.w  #$B,d0
                move.b  SKFBZCage_HelixFrames(pc,d0.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  d0,anim(a1)
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; End of function UpdatePlayerInFbzStationaryWireCage

; ---------------------------------------------------------------------------
SKFBZCage_HelixFrames:
                dc.b    $70, $70, $71, $71, $72, $72, $73, $73, $74, $74, $75, $75, $76, $76, $77, $77, $6C, $6C, $6D, $6D
                dc.b    $6E, $6E, $6F, $6F, $70, $70, $71, $71, $72, $72, $73, $73, $74, $74, $75, $75
                even
