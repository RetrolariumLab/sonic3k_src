; Owner: objects/zones/hcz/sk
; Responsibility: Hydrocity twisting-loop geometry, player capture, scripted movement and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
SKTwistingLoop_ShortRouteStates:
                dc.b    2,   4,   4,   4,   4,   4,  $C,   0
                even
SKTwistingLoop_LongRouteStates:
                dc.b    2,   4,   6,   6,   6,   6,   8,   8,   8,   8,  $A,  $A,   0
                even
SKTwistingLoop_SingleExitRouteStates:
                dc.b    2,   4,   6,   6,   6,   6,   8,   8,   8,   8,  $A,   0
                even
SKTwistingLoop_ExtendedRouteStates:
                dc.b    2,   4,   6,   6,   6,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,  $E,   0
                even
; ---------------------------------------------------------------------------
SKTwistingLoop_RouteOriginRecords:
                dc.w    $840
                dc.w    $120
                dc.l    SKTwistingLoop_ShortRouteStates
                dc.w    $1540
                dc.w    $620
                dc.l    SKTwistingLoop_LongRouteStates
                dc.w    $1740
                dc.w    $3A0
                dc.l    SKTwistingLoop_LongRouteStates
                dc.w    $1CC0
                dc.w    $620
                dc.l    SKTwistingLoop_ShortRouteStates
                dc.w    $1FC0
                dc.w    $2A0
                dc.l    SKTwistingLoop_SingleExitRouteStates
                dc.w    $24C0
                dc.w    $220
                dc.l    SKTwistingLoop_ExtendedRouteStates
                dc.w    $26C0
                dc.w    $120
                dc.l    SKTwistingLoop_ShortRouteStates
                dc.w    $3040
                dc.w    $620
                dc.l    SKTwistingLoop_LongRouteStates
; ---------------------------------------------------------------------------

Obj_HCZTwistingLoop:
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                lsl.w   #3,d0
                lea     SKTwistingLoop_RouteOriginRecords(pc,d0.w),a1
                move.w  (a1)+,$30(a0)
                move.w  (a1)+,$32(a0)
                move.l  (a1)+,$40(a0)
                move.l  #SKTwistingLoop_UpdateRidersAndTryCull,(a0)

SKTwistingLoop_UpdateRidersAndTryCull:
                lea     (Player_1).w,a1
                lea     $34(a0),a4
                bsr.s   UpdatePlayerOnHczTwistingLoop
                lea     (Player_2).w,a1
                lea     $3A(a0),a4
                bsr.s   UpdatePlayerOnHczTwistingLoop
                move.b  $34(a0),d0
                add.b   $3A(a0),d0
                beq.s   SKTwistingLoop_CullInactiveLoop
                rts
; ---------------------------------------------------------------------------

SKTwistingLoop_CullInactiveLoop:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnHczTwistingLoop:
                moveq   #0,d0
                move.b  (a4),d0
                move.w  SKTwistingLoop_RiderStateOffsets(pc,d0.w),d0
                jsr     SKTwistingLoop_RiderStateOffsets(pc,d0.w)
                tst.b   (a4)
                beq.s   SKTwistingLoop_LoopUpdateReturn
                bsr.w   UpdateHczTwistingLoopPlayerVelocity
                moveq   #0,d0
                move.w  2(a4),d0
                divu.w  #$60,d0
                movea.l $40(a0),a2
                move.b  (a2,d0.w),(a4)
                bne.s   SKTwistingLoop_LoopUpdateReturn
                move.b  #0,object_control(a1)

SKTwistingLoop_LoopUpdateReturn:
                rts
; End of function UpdatePlayerOnHczTwistingLoop

; ---------------------------------------------------------------------------
SKTwistingLoop_RiderStateOffsets:
                dc.w    SKTwistingLoop_CheckCaptureDirection-SKTwistingLoop_RiderStateOffsets
                dc.w    SKTwistingLoop_CheckReverseEntryEscape-SKTwistingLoop_RiderStateOffsets
                dc.w    SKTwistingLoop_PlaceOnSecondCurve-SKTwistingLoop_RiderStateOffsets
                dc.w    SKTwistingLoop_PlaceOnMiddleRamp-SKTwistingLoop_RiderStateOffsets
                dc.w    SKTwistingLoop_PlaceOnShiftedCurve-SKTwistingLoop_RiderStateOffsets
                dc.w    SKTwistingLoop_PlaceOnLongExitRamp-SKTwistingLoop_RiderStateOffsets
                dc.w    SKTwistingLoop_PlaceOnShortExitRamp-SKTwistingLoop_RiderStateOffsets
                dc.w    SKTwistingLoop_PlaceOnExtendedExitRamp-SKTwistingLoop_RiderStateOffsets
; ---------------------------------------------------------------------------

SKTwistingLoop_CheckCaptureDirection:
                tst.w   (Debug_placement_mode).w
                bne.w   SKTwistingLoop_CaptureReturn
                tst.b   subtype(a0)
                bmi.w   SKTwistingLoop_TryReverseEntry
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #8,d0
                cmpi.w  #$10,d0
                bhs.s   SKTwistingLoop_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                cmpi.w  #$30,d1
                bhs.s   SKTwistingLoop_CaptureReturn
                tst.b   object_control(a1)
                bne.s   SKTwistingLoop_CaptureReturn
                btst    #0,status(a0)
                beq.s   SKTwistingLoop_CheckForwardEntrySpeed
                tst.w   ground_vel(a1)
                bpl.s   SKTwistingLoop_CaptureReturn
                tst.w   x_vel(a1)
                bpl.s   SKTwistingLoop_CaptureReturn
                neg.w   ground_vel(a1)
                bra.s   SKTwistingLoop_CaptureLoopRider
; ---------------------------------------------------------------------------

SKTwistingLoop_CheckForwardEntrySpeed:
                tst.w   ground_vel(a1)
                bmi.s   SKTwistingLoop_CaptureReturn

SKTwistingLoop_CaptureLoopRider:
                addq.b  #2,(a4)
                move.b  #1,object_control(a1)
                move.b  #2,anim(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_Push,status(a1)
                move.b  #$28,angle(a1)
                move.w  y_pos(a1),d1
                sub.w   $32(a0),d1
                move.w  d1,2(a4)

SKTwistingLoop_CaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKTwistingLoop_TryReverseEntry:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   SKTwistingLoop_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$10,d1
                cmpi.w  #$10,d1
                bhs.s   SKTwistingLoop_CaptureReturn
                tst.b   object_control(a1)
                bne.s   SKTwistingLoop_CaptureReturn
                tst.w   ground_vel(a1)
                bpl.s   SKTwistingLoop_CaptureReturn
                addq.b  #2,(a4)
                move.b  #1,object_control(a1)
                move.b  #2,anim(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_Push,status(a1)
                move.b  #$28,angle(a1)
                move.w  y_pos(a1),d1
                sub.w   $32(a0),d1
                move.w  d1,2(a4)
                rts

; =============== S U B R O U T I N E =======================================

UpdateHczTwistingLoopPlayerVelocity:
                move.b  angle(a1),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a1),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a1)
                muls.w  ground_vel(a1),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a1)
                move.b  angle(a1),d0
                jsr     (GetSineCosine).l
                muls.w  #$50,d0
                asr.l   #8,d0
                tst.w   ground_vel(a1)
                bmi.s   SKTwistingLoop_ScaleReverseGravity
                tst.w   d0
                bpl.s   SKTwistingLoop_TryAddForwardGravity
                asr.l   #2,d0

SKTwistingLoop_TryAddForwardGravity:
                cmpi.w  #$1800,ground_vel(a1)
                bge.s   SKTwistingLoop_VelocityUpdateReturn
                add.w   d0,ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

SKTwistingLoop_ScaleReverseGravity:
                tst.w   d0
                bmi.s   SKTwistingLoop_AddSignedGravity
                asr.l   #2,d0

SKTwistingLoop_AddSignedGravity:
                add.w   d0,ground_vel(a1)

SKTwistingLoop_VelocityUpdateReturn:
                rts
; End of function UpdateHczTwistingLoopPlayerVelocity

; ---------------------------------------------------------------------------

SKTwistingLoop_CheckReverseEntryEscape:
                move.w  2(a4),d0
                subi.w  #$16,d0
                bcc.s   SKTwistingLoop_PlaceOnEntryCurve
                tst.w   ground_vel(a1)
                bpl.s   SKTwistingLoop_ClampEntryCurveParam
                move.b  #0,(a4)
                move.b  #0,object_control(a1)
                move.b  #$70,angle(a1)
                bra.w   UpdateHczTwistingLoopPlayerVelocity
; ---------------------------------------------------------------------------

; Clamp the local parameter in d0 while leaving stored progress intact
SKTwistingLoop_ClampEntryCurveParam:
                moveq   #0,d0

SKTwistingLoop_PlaceOnEntryCurve:
                mulu.w  #$DD,d0
                lsr.w   #8,d0
                jsr     (GetSineCosine).l
                muls.w  #-$2800,d0
                swap    d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a1)
                move.w  2(a4),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a1)
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,2(a4)
                rts
; ---------------------------------------------------------------------------

SKTwistingLoop_PlaceOnSecondCurve:
                move.w  2(a4),d0
                mulu.w  #$AA,d0
                asr.w   #8,d0
                jsr     (GetSineCosine).l
                muls.w  #-$2800,d0
                swap    d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a1)
                move.w  2(a4),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a1)
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,2(a4)
                rts
; ---------------------------------------------------------------------------

SKTwistingLoop_PlaceOnMiddleRamp:
                move.w  2(a4),d0
                subi.w  #$C0,d0
                muls.w  #$AA,d0
                asr.l   #8,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a1)
                move.w  2(a4),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a1)
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,2(a4)
                rts
; ---------------------------------------------------------------------------

SKTwistingLoop_PlaceOnShiftedCurve:
                move.w  2(a4),d0
                subi.w  #$180,d0
                mulu.w  #$AA,d0
                asr.w   #8,d0
                jsr     (GetSineCosine).l
                muls.w  #-$2800,d0
                swap    d0
                addi.w  #$100,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a1)
                move.w  2(a4),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a1)
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,2(a4)
                rts
; ---------------------------------------------------------------------------

SKTwistingLoop_PlaceOnLongExitRamp:
                move.w  2(a4),d0
                subi.w  #$240,d0
                muls.w  #$AA,d0
                asr.l   #8,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a1)
                move.w  2(a4),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a1)
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,2(a4)
                rts
; ---------------------------------------------------------------------------

SKTwistingLoop_PlaceOnShortExitRamp:
                move.w  2(a4),d0
                subi.w  #$240,d0
                muls.w  #$AA,d0
                asr.l   #8,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a1)
                move.w  2(a4),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a1)
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,2(a4)
                rts
; ---------------------------------------------------------------------------

SKTwistingLoop_PlaceOnExtendedExitRamp:
                move.w  2(a4),d0
                subi.w  #$540,d0
                muls.w  #$AA,d0
                asr.l   #8,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a1)
                move.w  2(a4),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a1)
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,2(a4)
                rts
; ---------------------------------------------------------------------------

SKSnowboard_InitSonicAndTrySnow:
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.l  #Map_SonicSnowboard,mappings(a0)
                move.w  #$100,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.b  #6,mapping_frame(a0)
                move.w  #1,anim(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKSnowboard_StartFollowUntilGrounded
                move.l  #SKICZBoardIntro_BeginSnowEmitter,(a1)
                move.w  a0,$30(a1)

SKSnowboard_StartFollowUntilGrounded:
                move.l  #SKSnowboard_FollowUntilLanding,(a0)

SKSnowboard_FollowUntilLanding:
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                btst    #Status_InAir,status(a1)
                bne.s   SKSnowboard_AnimateAndDrawInitialFollow
                move.b  #1,anim(a0)
                move.l  #SKSnowboard_FollowAndPickSlopeAnim,(a0)

SKSnowboard_AnimateAndDrawInitialFollow:
                lea     (Ani_SonicSnowboard).l,a1
                jsr     (Animate_Sprite).l
                jsr     (QueueIczSnowboardingSonicFrameArt).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_SonicSnowboard:
                include "src/objects/shared/sonic/animations/snowboard.s"
; ---------------------------------------------------------------------------

SKSnowboard_FollowAndPickSlopeAnim:
                lea     (Player_1).w,a2
                move.w  x_pos(a2),x_pos(a0)
                move.w  y_pos(a2),y_pos(a0)
                moveq   #0,d0
                move.b  angle(a2),d0
                addq.b  #5,d0
                lsr.w   #4,d0
                move.b  SKSnowboard_GroundAnimByAngle(pc,d0.w),anim(a0)
                btst    #Status_InAir,status(a2)
                beq.s   SKSnowboard_TryQuietSkidSound
                move.b  #0,anim(a0)
                tst.w   x_vel(a2)
                beq.s   SKSnowboard_ClampUpwardSpeed
                cmpi.w  #$1000,x_vel(a2)
                blt.s   SKSnowboard_ClampUpwardSpeed
                move.w  #$1000,x_vel(a2)

SKSnowboard_ClampUpwardSpeed:
                cmpi.w  #-$200,y_vel(a2)
                bge.s   SKSnowboard_AnimateAndCheckSpeed
                move.w  #-$200,y_vel(a2)
                bra.s   SKSnowboard_AnimateAndCheckSpeed
; ---------------------------------------------------------------------------
SKSnowboard_GroundAnimByAngle:
                dc.b    4,   5,   2,   1,   1,   1,   1,   1,   0,   1,   2,   0,   1,   2,   0,   4
; ---------------------------------------------------------------------------

SKSnowboard_TryQuietSkidSound:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   SKSnowboard_TryPickSlopeScript
                moveq   #signextendB(sfx_SlideSkidQuiet),d0
                jsr     (Play_SFX).l

SKSnowboard_TryPickSlopeScript:
                cmpi.w  #$1310,x_pos(a2)
                blo.s   SKSnowboard_AnimateAndCheckSpeed
                moveq   #1,d0
                cmpi.w  #$1330,x_pos(a2)
                blo.s   SKSnowboard_StartNewSlopeScript
                cmpi.w  #$2210,x_pos(a2)
                blo.s   SKSnowboard_AnimateAndCheckSpeed
                cmpi.w  #$2230,x_pos(a2)
                bhs.s   SKSnowboard_AnimateAndCheckSpeed
                moveq   #2,d0

SKSnowboard_StartNewSlopeScript:
                cmp.b   $36(a0),d0
                beq.s   SKSnowboard_AnimateAndCheckSpeed
                move.b  d0,$36(a0)
                move.b  #3,object_control(a2)
                move.l  #SKSnowboard_ReadNextSlopeRecord,(a0)
                move.w  #0,$34(a0)

SKSnowboard_AnimateAndCheckSpeed:
                lea     (Ani_SonicSnowboard).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #8,mapping_frame(a0)
                bne.s   SKSnowboard_EnforceMinGroundSpeed
                cmpi.w  #$1000,ground_vel(a2)
                blt.s   SKSnowboard_EnforceMinGroundSpeed
                subi.w  #8,ground_vel(a2)
                bra.s   SKSnowboard_TryTriggerCrash
; ---------------------------------------------------------------------------

SKSnowboard_EnforceMinGroundSpeed:
                cmpi.w  #$1000,ground_vel(a2)
                bge.s   SKSnowboard_TryTriggerCrash
                move.w  #$1000,ground_vel(a2)

SKSnowboard_TryTriggerCrash:
                cmpi.w  #$3880,x_pos(a2)
                blo.s   SKSnowboard_CheckGroundedSlideFrame
                tst.w   x_vel(a2)
                bne.s   SKSnowboard_CheckGroundedSlideFrame
                move.l  #SKSnowboard_DeleteCrashedVisual,(a0)
                bset    #Status_InAir,status(a2)
                move.w  #-$200,x_vel(a2)
                move.w  #-$400,y_vel(a2)
                move.b  #$19,anim(a2)
                move.b  #0,object_control(a2)
                move.w  #$14,(Screen_shake_flag).w
                moveq   #signextendB(sfx_Crash),d0
                jsr     (Play_SFX).l
                move.w  #2,(Tails_CPU_routine).w

SKSnowboard_CheckGroundedSlideFrame:
                btst    #Status_InAir,status(a2)
                bne.s   SKSnowboard_QueueArtAndDraw
                move.b  mapping_frame(a0),d0
                cmp.b   $32(a0),d0
                beq.s   SKSnowboard_QueueArtAndDraw
                cmpi.b  #7,d0
                beq.s   SKSnowboard_PlayGroundSlideSound
                cmpi.b  #8,d0
                bne.s   SKSnowboard_QueueArtAndDraw

SKSnowboard_PlayGroundSlideSound:
                moveq   #signextendB(sfx_GroundSlide),d0
                jsr     (Play_SFX).l

SKSnowboard_QueueArtAndDraw:
                jsr     (QueueIczSnowboardingSonicFrameArt).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSnowboard_ReadNextSlopeRecord:
                lea     (Player_1).w,a2
                move.w  $34(a0),d0
                addq.w  #6,$34(a0)
                lea     (ICZSnowboard_Slope1).l,a1
                cmpi.b  #1,$36(a0)
                beq.s   SKSnowboard_ApplySlopeRecord
                lea     (ICZSnowboard_Slope2).l,a1

SKSnowboard_ApplySlopeRecord:
                lea     (a1,d0.w),a1
                move.w  (a1)+,d0
                move.w  d0,x_pos(a0)
                move.w  d0,x_pos(a2)
                move.w  (a1)+,d0
                move.w  d0,y_pos(a0)
                move.w  d0,y_pos(a2)
                move.w  (a1)+,d0
                move.b  d0,mapping_frame(a0)
                tst.w   (a1)
                bpl.s   SKSnowboard_TryScriptedSlideSound
                move.b  #$E,top_solid_bit(a2)
                move.b  #$F,lrb_solid_bit(a2)
                move.b  #2,object_control(a2)
                move.l  #SKSnowboard_FollowAndPickSlopeAnim,(a0)

SKSnowboard_TryScriptedSlideSound:
                move.b  mapping_frame(a0),d0
                cmp.b   $32(a0),d0
                beq.s   SKSnowboard_QueueScriptedArtAndDraw
                moveq   #signextendB(sfx_GroundSlide),d0
                jsr     (Play_SFX).l

SKSnowboard_QueueScriptedArtAndDraw:
                jsr     (QueueIczSnowboardingSonicFrameArt).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSnowboard_DeleteCrashedVisual:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

QueueIczSnowboardFrameArt:
                move.w  #tiles_to_bytes(ArtTile_Snowboard),d4
                move.l  #ArtUnc_Snowboard,d6
                lea     (DPLC_Snowboard).l,a2
                bra.s   SKSnowboard_CheckFrameAndReadDplc
; End of function QueueIczSnowboardFrameArt

; =============== S U B R O U T I N E =======================================

QueueIczSnowboardingSonicFrameArt:
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4
                move.l  #ArtUnc_SonicSnowboard,d6
                lea     (DPLC_SonicSnowboard).l,a2

SKSnowboard_CheckFrameAndReadDplc:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $32(a0),d0
                beq.s   SKSnowboard_DplcReturn
                move.b  d0,$32(a0)
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   SKSnowboard_DplcReturn

SKSnowboard_DecodeAndQueueDplc:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,SKSnowboard_DecodeAndQueueDplc

SKSnowboard_DplcReturn:
                rts
; End of function QueueIczSnowboardingSonicFrameArt
