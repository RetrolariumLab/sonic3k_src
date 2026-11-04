; Owner: objects/zones/mhz/sk
; Responsibility: Pulley lift coordination, player attachment, constrained travel and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZPulleyLift:
                move.l  #Map_MHZPulleyLift,mappings(a0)
                move.w  #make_art_tile(ArtTile_MHZMisc+$DD,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$80,height_pixels(a0)
                bset    #6,render_flags(a0)
                move.w  y_pos(a0),$3C(a0)
                moveq   #3,d1
                move.w  d1,mainspr_childsprites(a0)
                subq.b  #1,d1
                lea     sub2_x_pos(a0),a2
                lea     SKMHZPulley_CompositeStartOffsets(pc),a3

SKMHZPulley_InitCompositeSprites:
                move.w  (a3)+,d0
                add.w   x_pos(a0),d0
                move.w  d0,(a2)+
                move.w  (a3)+,d0
                add.w   y_pos(a0),d0
                move.w  d0,(a2)+
                move.w  (a3)+,(a2)+
                dbf     d1,SKMHZPulley_InitCompositeSprites
                move.b  #4,mapping_frame(a0)
                bra.s   SKMHZPulley_TrySpawnHandles
; ---------------------------------------------------------------------------
SKMHZPulley_CompositeStartOffsets:
                dc.w    0,   $40,     0
                dc.w    -$10,   $78,     5
                dc.w    $10,   $78,     6
; ---------------------------------------------------------------------------

SKMHZPulley_TrySpawnHandles:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKMHZPulley_BeginPulleyControl
                move.l  #SKMHZPulleyGrip_FollowRootAndReadRiders,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_pos(a0),$2E(a1)
                subi.w  #$32,x_pos(a1)
                addi.w  #$3A,y_pos(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.w  priority(a0),priority(a1)
                move.b  #$C,width_pixels(a1)
                move.b  #$30,height_pixels(a1)
                move.w  a0,parent3(a1)
                move.b  #2,mapping_frame(a1)
                move.w  #$34,$36(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKMHZPulley_BeginPulleyControl
                move.l  #SKMHZPulleyGrip_FollowRootAndReadRiders,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_pos(a0),$2E(a1)
                addi.w  #$32,x_pos(a1)
                addi.w  #$3A,y_pos(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                bset    #0,render_flags(a1)
                move.w  priority(a0),priority(a1)
                move.b  #$C,width_pixels(a1)
                move.b  #$30,height_pixels(a1)
                move.b  #2,mapping_frame(a1)
                move.w  #$36,$36(a1)
                move.w  a0,parent3(a1)

SKMHZPulley_BeginPulleyControl:
                move.l  #SKMHZPulley_AverageLengthsAndPickFrame,(a0)

SKMHZPulley_AverageLengthsAndPickFrame:
                lea     sub2_x_pos(a0),a2
                move.w  $34(a0),d0
                add.w   $36(a0),d0
                lsr.w   #1,d0
                move.w  d0,d2
                neg.w   d0
                addi.w  #$40,d0
                move.b  #0,sub2_mapframe-sub2_x_pos(a2)
                cmpi.w  #$20,d0
                bhi.s   SKMHZPulley_CheckLengthChange
                move.b  #1,sub2_mapframe-sub2_x_pos(a2)

SKMHZPulley_CheckLengthChange:
                move.w  d0,d1
                move.w  d2,d3
                sub.w   $38(a0),d2
                beq.s   SKMHZPulley_PlaceCompositeAndDraw
                bcc.s   SKMHZPulley_CheckExtendingHandles
                cmpi.w  #-4,d2
                beq.s   SKMHZPulley_CheckFourUnitRetraction
                add.w   y_pos(a0),d0
                andi.w  #$E,d0
                cmpi.w  #2,d0
                bne.s   SKMHZPulley_PlaceCompositeAndDraw

SKMHZPulley_RaiseRootTwoPixels:
                subq.w  #2,y_pos(a0)
                bra.s   SKMHZPulley_PlaceCompositeAndDraw
; ---------------------------------------------------------------------------

SKMHZPulley_CheckFourUnitRetraction:
                add.w   y_pos(a0),d0
                andi.w  #$E,d0
                cmpi.w  #2,d0
                beq.s   SKMHZPulley_RaiseRootTwoPixels
                cmpi.w  #4,d0
                bne.s   SKMHZPulley_PlaceCompositeAndDraw
                subq.w  #4,y_pos(a0)
                bra.s   SKMHZPulley_PlaceCompositeAndDraw
; ---------------------------------------------------------------------------

SKMHZPulley_CheckExtendingHandles:
                cmpi.w  #4,d2
                beq.s   SKMHZPulley_CheckFourUnitExtension
                add.w   y_pos(a0),d0

SKMHZPulley_CheckUseAlignment:
                move.w  d0,d2
                andi.w  #$E,d0
                bne.s   SKMHZPulley_PlaceCompositeAndDraw

SKMHZPulley_TryConsumeUse:
                cmp.w   $3C(a0),d2
                beq.s   SKMHZPulley_PlaceCompositeAndDraw
                move.w  d2,$3C(a0)
                tst.b   subtype(a0)
                beq.s   SKMHZPulley_PlaceCompositeAndDraw
                subq.b  #1,subtype(a0)
                bra.s   SKMHZPulley_PlaceCompositeAndDraw
; ---------------------------------------------------------------------------

SKMHZPulley_CheckFourUnitExtension:
                add.w   y_pos(a0),d0
                addq.w  #2,d0
                move.w  d0,d2
                andi.w  #$E,d0
                beq.s   SKMHZPulley_TryConsumeUse
                move.w  d2,d0
                subq.w  #2,d0
                bra.s   SKMHZPulley_CheckUseAlignment
; ---------------------------------------------------------------------------

SKMHZPulley_PlaceCompositeAndDraw:
                move.w  d3,$38(a0)
                add.w   y_pos(a0),d1
                move.w  d1,d0
                move.w  d0,sub2_y_pos-sub2_x_pos(a2)
                addi.w  #$38,d0
                move.w  d0,sub3_y_pos-sub2_x_pos(a2)
                move.w  d0,sub4_y_pos-sub2_x_pos(a2)
                andi.w  #$F,d1
                move.b  SKMHZPulley_SideSpreadByPhase(pc,d1.w),d1
                addi.w  #$10,d1
                move.w  d1,d0
                neg.w   d0
                add.w   x_pos(a0),d0
                move.w  d0,sub3_x_pos-sub2_x_pos(a2)
                add.w   x_pos(a0),d1
                move.w  d1,sub4_x_pos-sub2_x_pos(a2)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
SKMHZPulley_SideSpreadByPhase:
                dc.b    0
                dc.b    8
                dc.b    8
                dc.b    8
                dc.b    8
                dc.b    8
                dc.b    7
                dc.b    6
                dc.b    5
                dc.b    4
                dc.b    3
                dc.b    2
                dc.b    1
                dc.b    0
                dc.b    0
                dc.b    0
                even
; ---------------------------------------------------------------------------

SKMHZPulleyGrip_FollowRootAndReadRiders:
                move.b  #0,$3A(a0)
                movea.w parent3(a0),a3
                move.w  $34(a0),d0
                subq.w  #6,d0
                add.w   y_pos(a3),d0
                move.w  d0,y_pos(a0)
                bsr.s   UpdatePlayersOnMhzPulleyHandle
                moveq   #$18,d1
                tst.b   $3A(a0)
                beq.s   SKMHZPulleyGrip_TryRetractHandle
                tst.b   subtype(a3)
                beq.s   SKMHZPulleyGrip_PublishLengthAndFrame
                cmpi.w  #$40,$34(a0)
                beq.s   SKMHZPulleyGrip_PublishLengthAndFrame
                addq.w  #4,$34(a0)
                moveq   #$1C,d1
                bra.s   SKMHZPulleyGrip_PublishLengthAndFrame
; ---------------------------------------------------------------------------

SKMHZPulleyGrip_TryRetractHandle:
                tst.w   $34(a0)
                beq.s   SKMHZPulleyGrip_PublishLengthAndFrame
                subq.w  #4,$34(a0)
                moveq   #$14,d1

SKMHZPulleyGrip_PublishLengthAndFrame:
                move.w  $36(a0),d0
                move.w  $34(a0),(a3,d0.w)
                move.b  #3,mapping_frame(a0)
                cmp.w   $34(a0),d1
                bhi.s   SKMHZPulleyGrip_DrawFromRootX
                move.b  #2,mapping_frame(a0)
                addi.w  #$10,d1
                cmp.w   $34(a0),d1
                bhi.s   SKMHZPulleyGrip_DrawFromRootX
                move.b  #7,mapping_frame(a0)

SKMHZPulleyGrip_DrawFromRootX:
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l

; =============== S U B R O U T I N E =======================================

UpdatePlayersOnMhzPulleyHandle:
                movea.w parent3(a0),a3
                lea     $31(a0),a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d0
                bsr.s   UpdatePlayerOnMhzPulleyHandle
                lea     (Player_1).w,a1
                subq.w  #1,a2
                move.w  (Ctrl_1_logical).w,d0
; End of function UpdatePlayersOnMhzPulleyHandle

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnMhzPulleyHandle:
                tst.b   (a2)
                beq.w   SKMHZPulleyGrip_TickCaptureCooldown
                tst.b   render_flags(a1)
                bpl.s   SKMHZPulleyGrip_DetachWithoutJump
                cmpi.b  #4,routine(a1)
                bhs.s   SKMHZPulleyGrip_DetachWithoutJump
                tst.w   (Debug_placement_mode).w
                bne.s   SKMHZPulleyGrip_DetachWithoutJump
                move.w  d0,d1
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d1
                beq.w   SKMHZPulleyGrip_CheckCheatAndTryFaceLeft
                clr.b   $2E(a1)
                clr.b   (a2)
                move.b  #$12,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   SKMHZPulleyGrip_TrySetJumpLeft
                move.b  #$3C,2(a2)

SKMHZPulleyGrip_TrySetJumpLeft:
                btst    #button_left+8,d0
                beq.s   SKMHZPulleyGrip_TrySetJumpRight
                move.w  #-$200,x_vel(a1)

SKMHZPulleyGrip_TrySetJumpRight:
                btst    #button_right+8,d0
                beq.s   SKMHZPulleyGrip_SetJumpReleasePose
                move.w  #$200,x_vel(a1)

SKMHZPulleyGrip_SetJumpReleasePose:
                move.w  #-$380,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZPulleyGrip_DetachWithoutJump:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                rts
; End of function UpdatePlayerOnMhzPulleyHandle

; =============== S U B R O U T I N E =======================================

RecognizeMhzPulleyCheatSequence:
                cmpa.w  #Player_1,a1
                bne.s   SKMHZPulleyCheat_SequenceReturn
                tst.b   d0
                beq.s   SKMHZPulleyCheat_SequenceReturn
                moveq   #0,d1
                move.b  $40(a0),d1
                cmp.b   SKMHZPulleyCheat_DirectionSequence(pc,d1.w),d0
                bne.s   SKMHZPulleyCheat_ResetSequenceCursor
                addq.b  #1,$40(a0)
                move.b  SKMHZPulleyCheat_DirectionSequence+1(pc,d1.w),d1
                bne.s   SKMHZPulleyCheat_SequenceReturn

                moveq   #0,d1                           ; what the fuck
                subi.w  #-Level_select_flag,d1
                movea.w d1,a4

                tst.w   SK_alone_flag-Level_select_flag(a4)
                bne.s   SKMHZPulleyCheat_SetFlagsAndPlaySound
                tst.w   (a4)
                beq.s   SKMHZPulleyCheat_ResetSequenceCursor
                addq.w  #Debug_cheat_flag-Level_select_flag,a4

SKMHZPulleyCheat_SetFlagsAndPlaySound:
                moveq   #1,d1
                move.b  d1,(a4)
                move.b  d1,1(a4)
                move.w  d0,d1
                moveq   #signextendB(sfx_RingRight),d0
                jsr     (Play_SFX).l
                move.w  d1,d0

SKMHZPulleyCheat_ResetSequenceCursor:
                move.b  #0,$40(a0)

SKMHZPulleyCheat_SequenceReturn:
                rts
; End of function RecognizeMhzPulleyCheatSequence

; ---------------------------------------------------------------------------
SKMHZPulleyCheat_DirectionSequence:
                dc.b    button_left_mask
                dc.b    button_left_mask
                dc.b    button_left_mask
                dc.b    button_right_mask
                dc.b    button_right_mask
                dc.b    button_right_mask
                dc.b    button_up_mask
                dc.b    button_up_mask
                dc.b    button_up_mask
                even
; ---------------------------------------------------------------------------

SKMHZPulleyGrip_CheckCheatAndTryFaceLeft:
                bsr.s   RecognizeMhzPulleyCheatSequence
                btst    #button_left+8,d0
                beq.s   SKMHZPulleyGrip_TryFaceRight
                bset    #Status_Facing,status(a1)

SKMHZPulleyGrip_TryFaceRight:
                btst    #button_right+8,d0
                beq.s   SKMHZPulleyGrip_SyncFacingAndReadDown
                bclr    #Status_Facing,status(a1)

SKMHZPulleyGrip_SyncFacingAndReadDown:
                move.b  status(a1),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a1)
                or.b    d1,render_flags(a1)
                move.b  #$90,d1
                btst    #9,d0
                beq.s   SKMHZPulleyGrip_TryPlayPullSound
                move.b  #1,$3A(a0)
                move.b  #$91,d1

SKMHZPulleyGrip_TryPlayPullSound:
                btst    #1,d0
                beq.s   SKMHZPulleyGrip_PlaceRiderAtGrip
                tst.b   subtype(a3)
                beq.s   SKMHZPulleyGrip_PlaceRiderAtGrip
                moveq   #signextendB(sfx_PulleyMove),d0
                jsr     (Play_SFX).l

SKMHZPulleyGrip_PlaceRiderAtGrip:
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$42,y_pos(a1)

SKMHZPulleyGrip_PickExtendedRiderPose:
                move.w  $34(a0),d0
                beq.s   SKMHZPulleyGrip_UploadRiderPose
                move.b  #$91,d1
                cmpi.w  #$20,d0
                blo.s   SKMHZPulleyGrip_UploadRiderPose
                move.b  #$92,d1

SKMHZPulleyGrip_UploadRiderPose:
                move.b  d1,mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------

SKMHZPulleyGrip_TickCaptureCooldown:
                tst.b   2(a2)
                beq.s   SKMHZPulleyGrip_TryCaptureRider
                subq.b  #1,2(a2)
                bne.w   SKMHZPulleyGrip_CaptureReturn

SKMHZPulleyGrip_TryCaptureRider:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   SKMHZPulleyGrip_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$30,d1
                cmpi.w  #$18,d1
                bhs.w   SKMHZPulleyGrip_CaptureReturn
                tst.b   object_control(a1)
                bne.s   SKMHZPulleyGrip_CaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   SKMHZPulleyGrip_CaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKMHZPulleyGrip_CaptureReturn
                tst.w   y_vel(a1)
                beq.s   SKMHZPulleyGrip_CaptureReturn
                bmi.s   SKMHZPulleyGrip_CaptureReturn
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$42,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #0,spin_dash_flag(a1)
                move.b  #3,object_control(a1)
                andi.b  #$FD,render_flags(a1)
                move.b  #1,(a2)
                move.b  #$90,d1
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l
                bra.w   SKMHZPulleyGrip_PickExtendedRiderPose
; ---------------------------------------------------------------------------

SKMHZPulleyGrip_CaptureReturn:
                rts
; ---------------------------------------------------------------------------
Map_MHZPulleyLift:
                include "src/objects/shared/zones/mhz/mappings/pulley_lift.s"
