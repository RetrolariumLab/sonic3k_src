; Owner: objects/zones/hcz/s3
; Responsibility: Hydrocity twisting-loop geometry, player capture, scripted movement and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
S3TwistingLoop_ShortRouteStates:
                dc.b    2,   4,   4,   4,   4,   4,  $C,   0
                even
S3TwistingLoop_LongRouteStates:
                dc.b    2,   4,   6,   6,   6,   6,   8,   8,   8,   8,  $A,  $A,   0
                even
S3TwistingLoop_SingleExitRouteStates:
                dc.b    2,   4,   6,   6,   6,   6,   8,   8,   8,   8,  $A,   0
                even
S3TwistingLoop_ExtendedRouteStates:
                dc.b    2,   4,   6,   6,   6,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,  $E,   0
                even
; ---------------------------------------------------------------------------
S3TwistingLoop_RouteOriginRecords:
                dc.w    $840
                dc.w    $120
                dc.l    S3TwistingLoop_ShortRouteStates
                dc.w    $1540
                dc.w    $620
                dc.l    S3TwistingLoop_LongRouteStates
                dc.w    $1740
                dc.w    $3A0
                dc.l    S3TwistingLoop_LongRouteStates
                dc.w    $1CC0
                dc.w    $620
                dc.l    S3TwistingLoop_ShortRouteStates
                dc.w    $1FC0
                dc.w    $2A0
                dc.l    S3TwistingLoop_SingleExitRouteStates
                dc.w    $24C0
                dc.w    $220
                dc.l    S3TwistingLoop_ExtendedRouteStates
                dc.w    $26C0
                dc.w    $120
                dc.l    S3TwistingLoop_ShortRouteStates
                dc.w    $3040
                dc.w    $620
                dc.l    S3TwistingLoop_LongRouteStates
; ---------------------------------------------------------------------------

Obj_HCZTwistingLoop:
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                lsl.w   #3,d0
                lea     S3TwistingLoop_RouteOriginRecords(pc,d0.w),a1
                move.w  (a1)+,$30(a0)
                move.w  (a1)+,$32(a0)
                move.l  (a1)+,$40(a0)
                move.l  #S3TwistingLoop_UpdateRidersAndTryCull,(a0)

S3TwistingLoop_UpdateRidersAndTryCull:
                lea     (Player_1).w,a1
                lea     $34(a0),a4
                bsr.s   UpdatePlayerOnHczTwistingLoop
                lea     (Player_2).w,a1
                lea     $3A(a0),a4
                bsr.s   UpdatePlayerOnHczTwistingLoop
                move.b  $34(a0),d0
                add.b   $3A(a0),d0
                beq.s   S3TwistingLoop_CullInactiveLoop
                rts
; ---------------------------------------------------------------------------

S3TwistingLoop_CullInactiveLoop:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnHczTwistingLoop:
                moveq   #0,d0
                move.b  (a4),d0
                move.w  S3TwistingLoop_RiderStateOffsets(pc,d0.w),d0
                jsr     S3TwistingLoop_RiderStateOffsets(pc,d0.w)
                tst.b   (a4)
                beq.s   S3TwistingLoop_LoopUpdateReturn
                bsr.w   UpdateHczTwistingLoopPlayerVelocity
                moveq   #0,d0
                move.w  2(a4),d0
                divu.w  #$60,d0
                movea.l $40(a0),a2
                move.b  (a2,d0.w),(a4)
                bne.s   S3TwistingLoop_LoopUpdateReturn
                move.b  #0,object_control(a1)

S3TwistingLoop_LoopUpdateReturn:
                rts
; End of function UpdatePlayerOnHczTwistingLoop

; ---------------------------------------------------------------------------
S3TwistingLoop_RiderStateOffsets:
                dc.w    S3TwistingLoop_CheckCaptureDirection-S3TwistingLoop_RiderStateOffsets
                dc.w    S3TwistingLoop_CheckReverseEntryEscape-S3TwistingLoop_RiderStateOffsets
                dc.w    S3TwistingLoop_PlaceOnSecondCurve-S3TwistingLoop_RiderStateOffsets
                dc.w    S3TwistingLoop_PlaceOnMiddleRamp-S3TwistingLoop_RiderStateOffsets
                dc.w    S3TwistingLoop_PlaceOnShiftedCurve-S3TwistingLoop_RiderStateOffsets
                dc.w    S3TwistingLoop_PlaceOnLongExitRamp-S3TwistingLoop_RiderStateOffsets
                dc.w    S3TwistingLoop_PlaceOnShortExitRamp-S3TwistingLoop_RiderStateOffsets
                dc.w    S3TwistingLoop_PlaceOnExtendedExitRamp-S3TwistingLoop_RiderStateOffsets
; ---------------------------------------------------------------------------

S3TwistingLoop_CheckCaptureDirection:
                tst.w   (Debug_placement_mode).w
                bne.w   S3TwistingLoop_CaptureReturn
                tst.b   subtype(a0)
                bmi.w   S3TwistingLoop_TryReverseEntry
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #8,d0
                cmpi.w  #$10,d0
                bhs.s   S3TwistingLoop_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                cmpi.w  #$30,d1
                bhs.s   S3TwistingLoop_CaptureReturn
                tst.b   object_control(a1)
                bne.s   S3TwistingLoop_CaptureReturn
                btst    #0,status(a0)
                beq.s   S3TwistingLoop_CheckForwardEntrySpeed
                tst.w   ground_vel(a1)
                bpl.s   S3TwistingLoop_CaptureReturn
                tst.w   x_vel(a1)
                bpl.s   S3TwistingLoop_CaptureReturn
                neg.w   ground_vel(a1)
                bra.s   S3TwistingLoop_CaptureLoopRider
; ---------------------------------------------------------------------------

S3TwistingLoop_CheckForwardEntrySpeed:
                tst.w   ground_vel(a1)
                bmi.s   S3TwistingLoop_CaptureReturn

S3TwistingLoop_CaptureLoopRider:
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

S3TwistingLoop_CaptureReturn:
                rts
; ---------------------------------------------------------------------------

S3TwistingLoop_TryReverseEntry:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   S3TwistingLoop_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$10,d1
                cmpi.w  #$10,d1
                bhs.s   S3TwistingLoop_CaptureReturn
                tst.b   object_control(a1)
                bne.s   S3TwistingLoop_CaptureReturn
                tst.w   ground_vel(a1)
                bpl.s   S3TwistingLoop_CaptureReturn
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
                bmi.s   S3TwistingLoop_ScaleReverseGravity
                tst.w   d0
                bpl.s   S3TwistingLoop_TryAddForwardGravity
                asr.l   #2,d0

S3TwistingLoop_TryAddForwardGravity:
                cmpi.w  #$1800,ground_vel(a1)
                bge.s   S3TwistingLoop_VelocityUpdateReturn
                add.w   d0,ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

S3TwistingLoop_ScaleReverseGravity:
                tst.w   d0
                bmi.s   S3TwistingLoop_AddSignedGravity
                asr.l   #2,d0

S3TwistingLoop_AddSignedGravity:
                add.w   d0,ground_vel(a1)

S3TwistingLoop_VelocityUpdateReturn:
                rts
; End of function UpdateHczTwistingLoopPlayerVelocity

; ---------------------------------------------------------------------------

S3TwistingLoop_CheckReverseEntryEscape:
                move.w  2(a4),d0
                subi.w  #$16,d0
                bcc.s   S3TwistingLoop_PlaceOnEntryCurve
                tst.w   ground_vel(a1)
                bpl.s   S3TwistingLoop_ClampEntryCurveParam
                move.b  #0,(a4)
                move.b  #0,object_control(a1)
                move.b  #$70,angle(a1)
                bra.w   UpdateHczTwistingLoopPlayerVelocity
; ---------------------------------------------------------------------------

; Clamp the local parameter in d0 while leaving stored progress intact
S3TwistingLoop_ClampEntryCurveParam:
                moveq   #0,d0

S3TwistingLoop_PlaceOnEntryCurve:
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

S3TwistingLoop_PlaceOnSecondCurve:
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

S3TwistingLoop_PlaceOnMiddleRamp:
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

S3TwistingLoop_PlaceOnShiftedCurve:
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

S3TwistingLoop_PlaceOnLongExitRamp:
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

S3TwistingLoop_PlaceOnShortExitRamp:
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

S3TwistingLoop_PlaceOnExtendedExitRamp:
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

S3Snowboard_InitSonicAndTrySnow:
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.l  #Map_SonicSnowboard,mappings(a0)
                move.w  #$100,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.b  #6,mapping_frame(a0)
                move.w  #1,anim(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3Snowboard_StartFollowUntilGrounded
                move.l  #loc_38EDE,(a1)
                move.w  a0,$30(a1)

S3Snowboard_StartFollowUntilGrounded:
                move.l  #S3Snowboard_FollowUntilLanding,(a0)

S3Snowboard_FollowUntilLanding:
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                btst    #Status_InAir,status(a1)
                bne.s   S3Snowboard_AnimateAndDrawInitialFollow
                move.b  #1,anim(a0)
                move.l  #S3Snowboard_FollowAndPickSlopeAnim,(a0)

S3Snowboard_AnimateAndDrawInitialFollow:
                lea     (Ani_SonicSnowboard).l,a1
                jsr     (Animate_Sprite).l
                jsr     (QueueIczSnowboardingSonicFrameArt).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_SonicSnowboard:
                include "src/objects/shared/sonic/animations/snowboard.s"
; ---------------------------------------------------------------------------

S3Snowboard_FollowAndPickSlopeAnim:
                lea     (Player_1).w,a2
                move.w  x_pos(a2),x_pos(a0)
                move.w  y_pos(a2),y_pos(a0)
                moveq   #0,d0
                move.b  angle(a2),d0
                addq.b  #5,d0
                lsr.w   #4,d0
                move.b  S3Snowboard_GroundAnimByAngle(pc,d0.w),anim(a0)
                btst    #Status_InAir,status(a2)
                beq.s   S3Snowboard_TryQuietSkidSound
                move.b  #0,anim(a0)
                tst.w   x_vel(a2)
                beq.s   S3Snowboard_ClampUpwardSpeed
                cmpi.w  #$1000,x_vel(a2)
                blt.s   S3Snowboard_ClampUpwardSpeed
                move.w  #$1000,x_vel(a2)

S3Snowboard_ClampUpwardSpeed:
                cmpi.w  #-$200,y_vel(a2)
                bge.s   S3Snowboard_AnimateAndCheckSpeed
                move.w  #-$200,y_vel(a2)
                bra.s   S3Snowboard_AnimateAndCheckSpeed
; ---------------------------------------------------------------------------
S3Snowboard_GroundAnimByAngle:
                dc.b    4,   5,   2,   1,   1,   1,   1,   1,   0,   1,   2,   0,   1,   2,   0,   4
; ---------------------------------------------------------------------------

S3Snowboard_TryQuietSkidSound:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   S3Snowboard_TryPickSlopeScript
                moveq   #signextendB(sfx_SlideSkidQuiet),d0
                jsr     (Play_SFX).l

S3Snowboard_TryPickSlopeScript:
                cmpi.w  #$1310,x_pos(a2)
                blo.s   S3Snowboard_AnimateAndCheckSpeed
                moveq   #1,d0
                cmpi.w  #$1330,x_pos(a2)
                blo.s   S3Snowboard_StartNewSlopeScript
                cmpi.w  #$2210,x_pos(a2)
                blo.s   S3Snowboard_AnimateAndCheckSpeed
                cmpi.w  #$2230,x_pos(a2)
                bhs.s   S3Snowboard_AnimateAndCheckSpeed
                moveq   #2,d0

S3Snowboard_StartNewSlopeScript:
                cmp.b   $36(a0),d0
                beq.s   S3Snowboard_AnimateAndCheckSpeed
                move.b  d0,$36(a0)
                move.b  #3,object_control(a2)
                move.l  #S3Snowboard_ReadNextSlopeRecord,(a0)
                move.w  #0,$34(a0)

S3Snowboard_AnimateAndCheckSpeed:
                lea     (Ani_SonicSnowboard).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #8,mapping_frame(a0)
                bne.s   S3Snowboard_EnforceMinGroundSpeed
                cmpi.w  #$1000,ground_vel(a2)
                blt.s   S3Snowboard_EnforceMinGroundSpeed
                subi.w  #8,ground_vel(a2)
                bra.s   S3Snowboard_TryTriggerCrash
; ---------------------------------------------------------------------------

S3Snowboard_EnforceMinGroundSpeed:
                cmpi.w  #$1000,ground_vel(a2)
                bge.s   S3Snowboard_TryTriggerCrash
                move.w  #$1000,ground_vel(a2)

S3Snowboard_TryTriggerCrash:
                cmpi.w  #$3880,x_pos(a2)
                blo.s   S3Snowboard_CheckGroundedSlideFrame
                tst.w   x_vel(a2)
                bne.s   S3Snowboard_CheckGroundedSlideFrame
                move.l  #S3Snowboard_DeleteCrashedVisual,(a0)
                bset    #Status_InAir,status(a2)
                move.w  #-$200,x_vel(a2)
                move.w  #-$400,y_vel(a2)
                move.b  #$19,anim(a2)
                move.b  #0,object_control(a2)
                move.w  #$14,(Screen_shake_flag).w
                moveq   #signextendB(sfx_Crash),d0
                jsr     (Play_SFX).l
                move.w  #2,(Tails_CPU_routine).w

S3Snowboard_CheckGroundedSlideFrame:
                btst    #Status_InAir,status(a2)
                bne.s   S3Snowboard_QueueArtAndDraw
                move.b  mapping_frame(a0),d0
                cmp.b   $32(a0),d0
                beq.s   S3Snowboard_QueueArtAndDraw
                cmpi.b  #7,d0
                beq.s   S3Snowboard_PlayGroundSlideSound
                cmpi.b  #8,d0
                bne.s   S3Snowboard_QueueArtAndDraw

S3Snowboard_PlayGroundSlideSound:
                moveq   #signextendB(sfx_GroundSlide),d0
                jsr     (Play_SFX).l

S3Snowboard_QueueArtAndDraw:
                jsr     (QueueIczSnowboardingSonicFrameArt).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Snowboard_ReadNextSlopeRecord:
                lea     (Player_1).w,a2
                move.w  $34(a0),d0
                addq.w  #6,$34(a0)
                lea     (ICZSnowboard_Slope1).l,a1
                cmpi.b  #1,$36(a0)
                beq.s   S3Snowboard_ApplySlopeRecord
                lea     (ICZSnowboard_Slope2).l,a1

S3Snowboard_ApplySlopeRecord:
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
                bpl.s   S3Snowboard_TryScriptedSlideSound
                move.b  #$E,top_solid_bit(a2)
                move.b  #$F,lrb_solid_bit(a2)
                move.b  #2,object_control(a2)
                move.l  #S3Snowboard_FollowAndPickSlopeAnim,(a0)

S3Snowboard_TryScriptedSlideSound:
                move.b  mapping_frame(a0),d0
                cmp.b   $32(a0),d0
                beq.s   S3Snowboard_QueueScriptedArtAndDraw
                moveq   #signextendB(sfx_GroundSlide),d0
                jsr     (Play_SFX).l

S3Snowboard_QueueScriptedArtAndDraw:
                jsr     (QueueIczSnowboardingSonicFrameArt).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Snowboard_DeleteCrashedVisual:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

QueueIczSnowboardFrameArt:
                move.w  #tiles_to_bytes(ArtTile_S3Snowboard),d4
                move.l  #ArtUnc_Snowboard,d6
                lea     (DPLC_Snowboard).l,a2
                bra.s   S3Snowboard_CheckFrameAndReadDplc
; End of function QueueIczSnowboardFrameArt

; =============== S U B R O U T I N E =======================================

QueueIczSnowboardingSonicFrameArt:
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4
                move.l  #ArtUnc_SonicSnowboard,d6
                lea     (DPLC_SonicSnowboard).l,a2

S3Snowboard_CheckFrameAndReadDplc:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $32(a0),d0
                beq.s   S3Snowboard_DplcReturn
                move.b  d0,$32(a0)
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   S3Snowboard_DplcReturn

S3Snowboard_DecodeAndQueueDplc:
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
                dbf     d5,S3Snowboard_DecodeAndQueueDplc

S3Snowboard_DplcReturn:
                rts
; End of function QueueIczSnowboardingSonicFrameArt
