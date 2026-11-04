; Owner: objects/zones/mgz/top_platform/sk
; Responsibility: Marble Garden spinning top initialization, active state, rider attachment and input handling
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MGZTopPlatform:
                move.l  #Map_MGZTopPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_MGZMisc1,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #$1F,y_radius(a0)
                move.b  #$18,x_radius(a0)
                move.b  #$1F,default_y_radius(a0)
                move.b  #$18,default_x_radius(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                move.l  #SKMGZTopRoot_UpdateRidersAndMotion,(a0)

SKMGZTopRoot_UpdateRidersAndMotion:
                lea     (Player_1).w,a1
                lea     $40(a0),a4
                move.w  (Ctrl_1_logical).w,d5
                moveq   #p1_standing_bit,d6
                bsr.w   UpdateTopPlatformRiderState
                lea     (Player_2).w,a1
                lea     $42(a0),a4
                move.w  (Ctrl_2_logical).w,d5
                moveq   #p2_standing_bit,d6
                bsr.w   UpdateTopPlatformRiderState
                tst.b   subtype(a0)
                bne.w   SKMGZTopRoot_AlignRidersAndDraw
                btst    #1,status(a0)
                beq.w   SKMGZTopRoot_StepScriptedPath
                cmpi.w  #$200,y_vel(a0)
                bge.s   SKMGZTopRoot_MoveAndProbeAirborne
                addi.w  #8,y_vel(a0)

SKMGZTopRoot_MoveAndProbeAirborne:
                jsr     (MoveSprite2).l
                subi.w  #$13,y_pos(a0)
                move.l  a1,-(sp)
                jsr     (ResolveAirborneTopPlatformTerrain).l
                movea.l (sp)+,a1
                addi.w  #$13,y_pos(a0)
                tst.b   $2D(a0)
                beq.s   SKMGZTopRoot_TryBoostOnLanding
                move.w  #0,y_vel(a0)
                move.w  #0,x_vel(a0)
                bclr    #1,status(a0)
                bra.w   SKMGZTopRoot_AlignRidersAndDraw
; ---------------------------------------------------------------------------

SKMGZTopRoot_TryBoostOnLanding:
                btst    #1,status(a0)
                bne.w   SKMGZTopRoot_AlignRidersAndDraw
                move.w  x_vel(a0),d0
                bpl.s   SKMGZTopRoot_SelectLandingBoost
                neg.w   d0

SKMGZTopRoot_SelectLandingBoost:
                cmpi.w  #$40,d0
                blo.s   SKMGZTopRoot_AlignRidersAndDraw
                move.w  #$800,d1
                cmpi.w  #$100,d0
                blo.s   SKMGZTopRoot_SignLandingBoost
                move.w  #$C00,d1

SKMGZTopRoot_SignLandingBoost:
                tst.w   x_vel(a0)
                bpl.s   SKMGZTopRoot_SetLaunchSpeed
                neg.w   d1

SKMGZTopRoot_SetLaunchSpeed:
                move.w  d1,x_vel(a0)
                move.w  d1,ground_vel(a0)
                move.b  #1,$34(a0)
                bra.s   SKMGZTopRoot_AlignRidersAndDraw
; ---------------------------------------------------------------------------

SKMGZTopRoot_StepScriptedPath:
                tst.b   $35(a0)
                beq.s   SKMGZTopRoot_StepGroundMotion
                bsr.w   UpdateTopPlatformScriptedSinePath
                addq.w  #4,$24(a0)
                bra.s   SKMGZTopRoot_AlignRidersAndDraw
; ---------------------------------------------------------------------------

SKMGZTopRoot_StepGroundMotion:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                bsr.s   MGZTopPlatform_LimitVelByTerrain
                jsr     (MoveSprite2).l
                tst.b   $2D(a0)
                bne.s   SKMGZTopRoot_SpinAndCheckStopped
                bsr.w   FollowFloorUnderTopPlatform

SKMGZTopRoot_SpinAndCheckStopped:
                addq.w  #4,$24(a0)
                tst.w   ground_vel(a0)
                bne.s   SKMGZTopRoot_TryEnterScriptedPath
                move.b  #0,$34(a0)

SKMGZTopRoot_TryEnterScriptedPath:
                bsr.w   TryEnterTopPlatformScriptedSinePath

SKMGZTopRoot_AlignRidersAndDraw:
                lea     (Player_1).w,a1
                lea     $40(a0),a4
                moveq   #p1_standing_bit,d6
                bsr.w   AlignTopPlatformAndRiderAfterMovement
                lea     (Player_2).w,a1
                lea     $42(a0),a4
                moveq   #p2_standing_bit,d6
                bsr.w   AlignTopPlatformAndRiderAfterMovement
                move.w  $24(a0),d0
                asr.w   #3,d0
                andi.w  #1,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKMGZTopRoot_StepAbandonedTop:
                jsr     (MoveSprite).l
                addq.w  #4,$24(a0)
                move.w  $24(a0),d0
                asr.w   #3,d0
                andi.w  #1,d0
                move.b  d0,mapping_frame(a0)
                tst.b   render_flags(a0)
                bmi.s   SKMGZTopRoot_DrawAbandonedTop
                move.w  #$7F00,x_pos(a0)

SKMGZTopRoot_DrawAbandonedTop:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

MGZTopPlatform_LimitVelByTerrain:
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   SKMGZTopTerrain_PredictionReturn
                bmi.s   SKMGZTopTerrain_ProbePredictedSurface
                neg.w   d1

SKMGZTopTerrain_ProbePredictedSurface:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                move.b  #$13,y_radius(a0)
                move.b  #$18,x_radius(a0)
                subi.w  #$C,y_pos(a0)
                jsr     (ProbeNextSurfaceWithBodyRadius).l
                addi.w  #$C,y_pos(a0)
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   SKMGZTopTerrain_PredictionReturn
                asl.w   #8,d1
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   SKMGZTopTerrain_IncreasePredictedYSpeed
                cmpi.b  #$40,d0
                beq.s   SKMGZTopTerrain_StopAtPredictedWall
                cmpi.b  #$80,d0
                beq.s   SKMGZTopTerrain_ReducePredictedYSpeed
                addi.b  #$30,d3
                cmpi.b  #$60,d3
                blo.s   SKMGZTopTerrain_PredictionReturn
                add.w   d1,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #0,status(a0)
                bne.s   SKMGZTopTerrain_PredictionReturn
                bset    #5,status(a0)

SKMGZTopTerrain_PredictionReturn:
                rts
; ---------------------------------------------------------------------------

SKMGZTopTerrain_ReducePredictedYSpeed:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKMGZTopTerrain_StopAtPredictedWall:
                addi.b  #$30,d3
                cmpi.b  #$60,d3
                blo.s   SKMGZTopTerrain_PredictionReturn
                sub.w   d1,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #0,status(a0)
                beq.s   SKMGZTopTerrain_PredictionReturn
                bset    #5,status(a0)
                rts
; ---------------------------------------------------------------------------

SKMGZTopTerrain_IncreasePredictedYSpeed:
                add.w   d1,y_vel(a0)
                rts
; End of function MGZTopPlatform_LimitVelByTerrain

; =============== S U B R O U T I N E =======================================

FollowFloorUnderTopPlatform:
                move.b  #$C,y_radius(a0)
                move.b  #$A,x_radius(a0)
                moveq   #3,d0
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                jsr     (Sonic_CheckFloor).l
                tst.b   d3
                bpl.s   SKMGZTopTerrain_ClampPositiveFloorAngle
                cmpi.b  #-$1E,d3
                bhs.s   SKMGZTopTerrain_StoreAngleAndTestGap
                move.b  #-$1E,d3
                bra.s   SKMGZTopTerrain_StoreAngleAndTestGap
; ---------------------------------------------------------------------------

SKMGZTopTerrain_ClampPositiveFloorAngle:
                cmpi.b  #$1E,d3
                bls.s   SKMGZTopTerrain_StoreAngleAndTestGap
                move.b  #$1E,d3

SKMGZTopTerrain_StoreAngleAndTestGap:
                move.b  d3,angle(a0)
                tst.w   d1
                beq.s   SKMGZTopTerrain_FloorGapReturn
                bpl.s   SKMGZTopTerrain_CalcFloorReach
                cmpi.w  #-$E,d1
                blt.s   SKMGZTopTerrain_FloorGapReturn
                add.w   d1,y_pos(a0)

SKMGZTopTerrain_FloorGapReturn:
                rts
; ---------------------------------------------------------------------------

SKMGZTopTerrain_CalcFloorReach:
                move.b  x_vel(a0),d0
                bpl.s   SKMGZTopTerrain_ClampFloorReach
                neg.b   d0

SKMGZTopTerrain_ClampFloorReach:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   SKMGZTopTerrain_FollowFloorOrLeave
                move.b  #$E,d0

SKMGZTopTerrain_FollowFloorOrLeave:
                cmp.b   d0,d1
                bgt.s   SKMGZTopTerrain_LeaveFloor
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKMGZTopTerrain_LeaveFloor:
                bset    #1,status(a0)
                bclr    #5,status(a0)
                move.b  #0,$34(a0)
                rts
; End of function FollowFloorUnderTopPlatform

; =============== S U B R O U T I N E =======================================

UpdateTopPlatformRiderState:
                moveq   #0,d0
                move.b  (a4),d0
                move.w  SKMGZTopRider_StateTable(pc,d0.w),d0
                jmp     SKMGZTopRider_StateTable(pc,d0.w)
; End of function UpdateTopPlatformRiderState

; ---------------------------------------------------------------------------
SKMGZTopRider_StateTable:
                dc.w    SKMGZTopRider_CheckBoardingContact-SKMGZTopRider_StateTable
                dc.w    SKMGZTopRider_UpdateBoardingContact-SKMGZTopRider_StateTable
                dc.w    SKMGZTopRider_UpdateCaptured-SKMGZTopRider_StateTable
                dc.w    SKMGZTopRider_ResetStateAndSide-SKMGZTopRider_StateTable
; ---------------------------------------------------------------------------

SKMGZTopRider_ResetStateAndSide:
                clr.w   (a4)
                rts
; ---------------------------------------------------------------------------

SKMGZTopRider_CheckBoardingContact:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull_1P).l
                btst    d6,status(a0)
                bne.s   SKMGZTopRider_TryRecordBoardingSide
                rts
; ---------------------------------------------------------------------------

SKMGZTopRider_TryRecordBoardingSide:
                tst.b   status_tertiary(a1)
                bmi.s   SKMGZTopRider_BoardingReturn
                addq.b  #2,(a4)
                move.b  #0,1(a4)
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcc.s   SKMGZTopRider_TryCenterAfterBoarding
                move.b  #1,1(a4)

SKMGZTopRider_TryCenterAfterBoarding:
                bra.s   SKMGZTopRider_CheckStandingBeforeCenter
; ---------------------------------------------------------------------------

SKMGZTopRider_BoardingReturn:
                rts
; ---------------------------------------------------------------------------

SKMGZTopRider_UpdateBoardingContact:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull_1P).l

; Losing contact clears the rider state but still falls through to the center test
SKMGZTopRider_CheckStandingBeforeCenter:
                btst    d6,status(a0)
                bne.s   SKMGZTopRider_OffsetCenterByBoardingSide
                clr.b   (a4)

SKMGZTopRider_OffsetCenterByBoardingSide:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                tst.b   1(a4)
                beq.s   SKMGZTopRider_TryCaptureAtCenter
                addi.w  #$F,d0

SKMGZTopRider_TryCaptureAtCenter:
                cmpi.w  #$10,d0
                bhs.s   SKMGZTopRider_CenterTestReturn
                move.w  x_pos(a0),x_pos(a1)
                move.b  default_y_radius(a1),d0
                addi.b  #$18,d0
                move.b  d0,y_radius(a1)
                bset    #0,object_control(a1)
                move.b  #$80,status_tertiary(a1)
                bclr    d6,status(a0)
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                addq.b  #2,(a4)

SKMGZTopRider_CenterTestReturn:
                rts
; ---------------------------------------------------------------------------

; An offscreen rider or a player in the death routine or later takes the single-rider detach path
SKMGZTopRider_UpdateCaptured:
                tst.b   render_flags(a1)
                bpl.s   SKMGZTopRider_DetachAndCheckP1
                cmpi.b  #4,routine(a1)
                bhs.w   SKMGZTopRider_DetachAndCheckP1
                tst.w   (Debug_placement_mode).w
                bne.s   SKMGZTopRider_DetachAndCheckP1
                move.w  d5,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKMGZTopRider_AutoFaceWithTopMotion
                move.w  #-$680,y_vel(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.w  #sfx_Jump,d0
                jsr     (Play_SFX).l

SKMGZTopRider_DetachAndCheckP1:
                bclr    #0,object_control(a1)
                move.b  #0,status_tertiary(a1)
                bset    #Status_InAir,status(a1)
                clr.b   (a4)
                cmpa.w  #Player_1,a1
                beq.w   AbandonTopPlatformAndReleaseRiders

SKMGZTopRider_ActiveReturn:
                rts
; ---------------------------------------------------------------------------

SKMGZTopRider_AutoFaceWithTopMotion:
                move.w  d5,d0
                andi.w  #$C00,d0
                bne.s   SKMGZTopRider_SetRadiusAndCheckDriver
                tst.w   x_vel(a0)
                beq.s   SKMGZTopRider_SetRadiusAndCheckDriver
                bclr    #Status_Facing,status(a1)
                tst.w   x_vel(a0)
                bpl.s   SKMGZTopRider_SetRadiusAndCheckDriver
                bset    #Status_Facing,status(a1)

SKMGZTopRider_SetRadiusAndCheckDriver:
                move.b  default_y_radius(a1),d0
                addi.b  #$18,d0
                move.b  d0,y_radius(a1)
                cmpa.w  #Player_2,a1
                bne.s   SKMGZTopRider_TryApplyP1GroundInput
                rts
; ---------------------------------------------------------------------------

SKMGZTopRider_TryApplyP1GroundInput:
                move.l  a0,-(sp)
                movea.l a1,a0
                move.w  d5,d3
                cmpi.b  #$10,anim(a0)
                beq.s   SKMGZTopRider_MoveP1AndCheckAnimSpeed
                jsr     (ControlTopRiderGroundSpeed).l

; Animation $10 supplies the top's velocity from P1 and advances P1's vertical speed
SKMGZTopRider_MoveP1AndCheckAnimSpeed:
                jsr     (Player_LevelBound).l
                jsr     (MoveSprite2).l
                movea.l (sp)+,a0
                cmpi.b  #$10,anim(a1)
                bne.s   SKMGZTopRider_ApplyHorizontalStop
                move.w  x_vel(a1),x_vel(a0)
                move.w  y_vel(a1),y_vel(a0)
                addi.w  #$38,y_vel(a1)
                bset    #1,status(a0)
                move.b  #0,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKMGZTopRider_ApplyHorizontalStop:
                bclr    #6,status_tertiary(a1)
                beq.s   SKMGZTopRider_ApplyVerticalStop
                move.w  #0,ground_vel(a0)
                move.w  #0,x_vel(a0)

SKMGZTopRider_ApplyVerticalStop:
                bclr    #5,status_tertiary(a1)
                beq.s   SKMGZTopRider_SyncSpeedAndSteerByOffset
                move.w  #0,y_vel(a0)

SKMGZTopRider_SyncSpeedAndSteerByOffset:
                move.w  x_vel(a0),x_vel(a1)
                move.w  y_vel(a0),y_vel(a1)
                move.w  top_solid_bit(a1),top_solid_bit(a0)
                tst.b   $34(a0)
                bne.w   SKMGZTopRider_ActiveReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                beq.w   SKMGZTopRider_ApplyCenteredFriction
                bcc.w   SKMGZTopRider_TryDriveRight
                cmpi.w  #-$200,x_vel(a0)
                ble.s   SKMGZTopRider_SpinAndLiftFromLeft
                add.w   d0,x_vel(a0)
                add.w   d0,x_vel(a0)
                add.w   d0,x_vel(a0)
                add.w   d0,x_vel(a0)

SKMGZTopRider_SpinAndLiftFromLeft:
                add.w   d0,$24(a0)
                move.w  x_vel(a0),d0
                bpl.s   SKMGZTopRider_LeaveFloorFromLeft
                asr.w   #4,d0
                subi.w  #8,y_vel(a0)
                cmpi.w  #-$100,y_vel(a0)
                ble.s   SKMGZTopRider_LeaveFloorFromLeft
                add.w   d0,y_vel(a0)

SKMGZTopRider_LeaveFloorFromLeft:
                bset    #1,status(a0)
                rts
; ---------------------------------------------------------------------------

SKMGZTopRider_TryDriveRight:
                cmpi.w  #$200,x_vel(a0)
                bge.s   SKMGZTopRider_SpinAndLiftFromRight
                add.w   d0,x_vel(a0)
                add.w   d0,x_vel(a0)
                add.w   d0,x_vel(a0)
                add.w   d0,x_vel(a0)

SKMGZTopRider_SpinAndLiftFromRight:
                add.w   d0,$24(a0)
                move.w  x_vel(a0),d0
                bmi.s   SKMGZTopRider_LeaveFloorFromRight
                neg.w   d0
                asr.w   #4,d0
                subi.w  #8,y_vel(a0)
                cmpi.w  #-$100,y_vel(a0)
                ble.s   SKMGZTopRider_LeaveFloorFromRight
                add.w   d0,y_vel(a0)

SKMGZTopRider_LeaveFloorFromRight:
                bset    #1,status(a0)
                rts
; ---------------------------------------------------------------------------

SKMGZTopRider_ApplyCenteredFriction:
                moveq   #1,d0
                tst.w   x_vel(a0)
                beq.s   SKMGZTopRider_SpinAndStopCenteredRise
                bmi.s   SKMGZTopRider_StepCenteredXSpeed
                neg.w   d0

SKMGZTopRider_StepCenteredXSpeed:
                add.w   d0,x_vel(a0)

SKMGZTopRider_SpinAndStopCenteredRise:
                add.w   d0,$24(a0)
                tst.w   y_vel(a0)
                bpl.s   SKMGZTopRider_CenteredDriveReturn
                clr.w   y_vel(a0)

SKMGZTopRider_CenteredDriveReturn:
                rts
; ---------------------------------------------------------------------------
; unused
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts

; =============== S U B R O U T I N E =======================================

AbandonTopPlatformAndReleaseRiders:
                move.l  #SKMGZTopRoot_StepAbandonedTop,(a0)
                lea     (Player_1).w,a2
                cmpi.b  #4,$40(a0)
                bne.s   SKMGZTopRider_ClearP1Standing
                bclr    #0,object_control(a2)
                move.b  #0,status_tertiary(a2)
                bset    #Status_InAir,status(a2)

SKMGZTopRider_ClearP1Standing:
                tst.b   $40(a0)
                beq.s   SKMGZTopRider_ReleaseP2IfCaptured
                bclr    #Status_OnObj,status(a2)

SKMGZTopRider_ReleaseP2IfCaptured:
                lea     (Player_2).w,a2
                cmpi.b  #4,$42(a0)
                bne.s   SKMGZTopRider_ClearP2Standing
                bclr    #0,object_control(a2)
                move.b  #0,status_tertiary(a2)
                bset    #Status_InAir,status(a2)

SKMGZTopRider_ClearP2Standing:
                tst.b   $42(a0)
                beq.s   SKMGZTopRider_DeferBothRiderResets
                bclr    #Status_OnObj,status(a2)

SKMGZTopRider_DeferBothRiderResets:
                move.b  #6,$40(a0)
                move.b  #6,$42(a0)
                rts
; End of function AbandonTopPlatformAndReleaseRiders

; =============== S U B R O U T I N E =======================================

AlignTopPlatformAndRiderAfterMovement:
                btst    #Status_OnObj,status(a1)
                bne.s   SKMGZTopRider_CheckSupportForSinkingMud
                cmpi.b  #4,(a4)
                blo.s   SKMGZTopRider_FollowTopReturn
                move.w  y_pos(a0),d0
                subi.w  #$C,d0
                moveq   #0,d1
                move.b  default_y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.b  #0,$2D(a0)

SKMGZTopRider_FollowTopReturn:
                rts
; ---------------------------------------------------------------------------

SKMGZTopRider_CheckSupportForSinkingMud:
                cmpi.b  #4,(a4)
                blo.s   SKMGZTopRider_OtherSupportReturn
                movea.w interact(a1),a2
                cmpi.l  #SKSinkingMud_UpdateNormalP1Depth,(a2)
                bne.s   SKMGZTopRider_AlignTopUnderRider
                bsr.w   AbandonTopPlatformAndReleaseRiders

SKMGZTopRider_AlignTopUnderRider:
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a1),d0
                moveq   #0,d1
                move.b  default_y_radius(a1),d1
                add.w   d1,d0
                addi.w  #$D,d0
                move.w  d0,y_pos(a0)
                move.b  #1,$2D(a0)

SKMGZTopRider_OtherSupportReturn:
                rts
; End of function AlignTopPlatformAndRiderAfterMovement
