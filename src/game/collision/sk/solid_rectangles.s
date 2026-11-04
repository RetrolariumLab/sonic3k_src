; Owner: game/collision/sk
; Responsibility: Rectangular solid-platform collision variants, offsets and player attachment motion
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SolidObjectFull:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   SolidObjectFull_1P
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                tst.b   render_flags(a1)
                bpl.w   SKCollision_ReturnFullSolidCarryOrInvisiblePlayerTwoSkip
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectFull

; =============== S U B R O U T I N E =======================================

SolidObjectFull_1P:
                btst    d6,status(a0)
                beq.w   SKCollision_RequireRootNegativeRenderFlagForNewFullSolidContact
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_DetachFullSolidRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollision_DetachFullSolidRider
                cmp.w   d2,d0
                blo.s   SKCollision_CarryExistingFullSolidRider

SKCollision_DetachFullSolidRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_CarryExistingFullSolidRider:
                move.w  d4,d2
                bsr.w   MvSonicOnPtfm
                moveq   #0,d4

SKCollision_ReturnFullSolidCarryOrInvisiblePlayerTwoSkip:
                rts
; End of function SolidObjectFull_1P

; =============== S U B R O U T I N E =======================================

SolidObjectFull2:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   SolidObjectFull2_1P
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectFull2

; =============== S U B R O U T I N E =======================================

SolidObjectFull2_1P:
                btst    d6,status(a0)
                beq.w   SolidObject_cont
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_DetachFullSolidWithoutVisibilityGateRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollision_DetachFullSolidWithoutVisibilityGateRider
                cmp.w   d2,d0
                blo.s   SKCollision_CarryFullSolidWithoutVisibilityGateRider

SKCollision_DetachFullSolidWithoutVisibilityGateRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_CarryFullSolidWithoutVisibilityGateRider:
                move.w  d4,d2
                bsr.w   MvSonicOnPtfm
                moveq   #0,d4
                rts
; End of function SolidObjectFull2_1P

; =============== S U B R O U T I N E =======================================

CollidePlayersWithHeightProfileSolid:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   CollidePlayerWithHeightProfileSolid
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function CollidePlayersWithHeightProfileSolid

; =============== S U B R O U T I N E =======================================

CollidePlayerWithHeightProfileSolid:
                btst    d6,status(a0)
                beq.w   SKCollision_BuildHalfResolutionHeightProfileNewContact
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_DetachHalfResolutionHeightProfileRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollision_DetachHalfResolutionHeightProfileRider
                cmp.w   d2,d0
                blo.s   SKCollision_CarryHeightProfileRiderAndAccumulateTopContactBit

SKCollision_DetachHalfResolutionHeightProfileRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_CarryHeightProfileRiderAndAccumulateTopContactBit:
                move.w  d4,d2
                bsr.w   SolidObjSloped2
                move.w  d6,d4
                addi.b  #$11,d4
                bset    d4,d6
                moveq   #0,d4
                rts
; End of function CollidePlayerWithHeightProfileSolid

; ---------------------------------------------------------------------------
; unused leftover from Sonic 2
; DoubleSlopedSolid:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   CollidePlayerWithDualHeightProfileSolid
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6

; =============== S U B R O U T I N E =======================================

CollidePlayerWithDualHeightProfileSolid:
                btst    d6,status(a0)
                beq.w   SKCollision_BuildDualHeightProfileNewContact
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_DetachDualHeightProfileRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollision_DetachDualHeightProfileRider
                cmp.w   d2,d0
                blo.s   SKCollision_CarryDualHeightProfileRider

SKCollision_DetachDualHeightProfileRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_CarryDualHeightProfileRider:
                move.w  d4,d2
                bsr.w   SolidObjSloped4
                moveq   #0,d4
                rts
; End of function CollidePlayerWithDualHeightProfileSolid

; =============== S U B R O U T I N E =======================================

CollidePlayersWithHeightProfileKeepAirState:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   CollidePlayerWithHeightProfileKeepAirState
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function CollidePlayersWithHeightProfileKeepAirState

; =============== S U B R O U T I N E =======================================

CollidePlayerWithHeightProfileKeepAirState:
                btst    d6,status(a0)
                beq.w   SKCollision_BuildHalfResolutionHeightProfileNewContact
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_DetachHeightProfileRiderKeepingAirState
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollision_DetachHeightProfileRiderKeepingAirState
                cmp.w   d2,d0
                blo.s   SKCollision_CarryKeepAirStateProfileRiderAndSetTopResult

SKCollision_DetachHeightProfileRiderKeepingAirState:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_CarryKeepAirStateProfileRiderAndSetTopResult:
                move.w  d4,d2
                bsr.w   SolidObjSloped2
                move.w  d6,d4
                addi.b  #$11,d4
                bset    d4,d6
                moveq   #0,d4
                rts
; End of function CollidePlayerWithHeightProfileKeepAirState

; =============== S U B R O U T I N E =======================================

SolidObjectFull_Offset:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   SolidObjectFull_Offset_1P
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectFull_Offset

; =============== S U B R O U T I N E =======================================

SolidObjectFull_Offset_1P:
                btst    d6,status(a0)
                beq.w   SKCollision_BuildOffsetSolidNewContactOverlap
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_DetachOffsetFullSolidRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollision_DetachOffsetFullSolidRider
                add.w   d1,d1
                cmp.w   d1,d0
                blo.s   SKCollision_SnapOffsetSolidRiderAndApplyHorizontalCarry

SKCollision_DetachOffsetFullSolidRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_SnapOffsetSolidRiderAndApplyHorizontalCarry:
                move.w  y_pos(a0),d0
                sub.w   d2,d0
                add.w   d3,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                sub.w   x_pos(a0),d4
                sub.w   d4,x_pos(a1)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_BuildOffsetSolidNewContactOverlap:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                move.w  d1,d4
                add.w   d4,d4
                cmp.w   d4,d0
                bhi.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                move.w  y_pos(a0),d5
                add.w   d3,d5
                move.b  y_radius(a1),d3
                ext.w   d3
                add.w   d3,d2
                move.w  y_pos(a1),d3
                sub.w   d5,d3
                addq.w  #4,d3
                add.w   d2,d3
                bmi.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                move.w  d2,d4
                add.w   d4,d4
                cmp.w   d4,d3
                bhs.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                bra.w   SKCollision_GateSolidResponseAndChooseNearestHorizontalBoundary
; ---------------------------------------------------------------------------

SKCollision_BuildHalfResolutionHeightProfileNewContact:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                move.w  d0,d5
                btst    #0,render_flags(a0)
                beq.s   SKCollision_ComputeRelativeHeightProfileOverlapFromByteDifference
                not.w   d5
                add.w   d3,d5

SKCollision_ComputeRelativeHeightProfileOverlapFromByteDifference:
                lsr.w   #1,d5
                move.b  (a2,d5.w),d3
                sub.b   (a2),d3
                ext.w   d3
                move.w  y_pos(a0),d5
                sub.w   d3,d5
                move.b  y_radius(a1),d3
                ext.w   d3
                add.w   d3,d2
                move.w  y_pos(a1),d3
                sub.w   d5,d3
                addq.w  #4,d3
                add.w   d2,d3
                bmi.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                move.w  d2,d4
                add.w   d4,d4
                cmp.w   d4,d3
                bhs.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                bra.w   SKCollision_GateSolidResponseAndChooseNearestHorizontalBoundary
; ---------------------------------------------------------------------------

SKCollision_BuildDualHeightProfileNewContact:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                move.w  d0,d5
                btst    #0,render_flags(a0)
                beq.s   SKCollision_ReadDualProfileTopAndExtentAndTestVerticalOverlap
                not.w   d5
                add.w   d3,d5

SKCollision_ReadDualProfileTopAndExtentAndTestVerticalOverlap:
                andi.w  #$FFFE,d5
                move.b  (a2,d5.w),d3
                move.b  1(a2,d5.w),d2
                ext.w   d2
                ext.w   d3
                move.w  y_pos(a0),d5
                sub.w   d3,d5
                move.w  y_pos(a1),d3
                sub.w   d5,d3
                move.b  y_radius(a1),d5
                ext.w   d5
                add.w   d5,d3
                addq.w  #4,d3
                bmi.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                add.w   d5,d2
                move.w  d2,d4
                add.w   d5,d4
                cmp.w   d4,d3
                bhs.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                bra.w   SKCollision_GateSolidResponseAndChooseNearestHorizontalBoundary
; ---------------------------------------------------------------------------

SKCollision_RequireRootNegativeRenderFlagForNewFullSolidContact:
                tst.b   render_flags(a0)
                bpl.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation

SolidObject_cont:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKCollision_ComputeNormalGravitySolidVerticalOverlapWithTwelveBitWrap
                move.b  default_y_radius(a1),d4
                ext.w   d4
                add.w   d2,d4
                move.b  y_radius(a1),d3
                ext.w   d3
                add.w   d3,d2
                move.w  y_pos(a1),d3
                sub.w   y_pos(a0),d3
                neg.w   d3
                addq.w  #4,d3
                add.w   d2,d3
                andi.w  #$FFF,d3
                add.w   d2,d4
                cmp.w   d4,d3
                bhs.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                bra.s   SKCollision_GateSolidResponseAndChooseNearestHorizontalBoundary
; ---------------------------------------------------------------------------

SKCollision_ComputeNormalGravitySolidVerticalOverlapWithTwelveBitWrap:
                move.b  default_y_radius(a1),d4
                ext.w   d4
                add.w   d2,d4
                move.b  y_radius(a1),d3
                ext.w   d3
                add.w   d3,d2
                move.w  y_pos(a1),d3
                sub.w   y_pos(a0),d3
                addq.w  #4,d3
                add.w   d2,d3
                andi.w  #$FFF,d3
                add.w   d2,d4
                cmp.w   d4,d3
                bhs.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation

SKCollision_GateSolidResponseAndChooseNearestHorizontalBoundary:
                tst.b   object_control(a1)
                bmi.w   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
                cmpi.b  #6,routine(a1)
                bhs.w   SKCollision_ReturnSolidNoReportedCollision
                tst.w   (Debug_placement_mode).w
                bne.w   SKCollision_ReturnSolidNoReportedCollision
                move.w  d0,d5
                cmp.w   d0,d1
                bhs.s   SKCollision_ChooseNearestVerticalBoundaryForSolidResponse
                add.w   d1,d1
                sub.w   d1,d0
                move.w  d0,d5
                neg.w   d5

SKCollision_ChooseNearestVerticalBoundaryForSolidResponse:
                move.w  d3,d1
                cmp.w   d3,d2
                bhs.s   SKCollision_SelectVerticalResponseForShallowerOrFourPixelContact
                subq.w  #4,d3
                sub.w   d4,d3
                move.w  d3,d1
                neg.w   d1

SKCollision_SelectVerticalResponseForShallowerOrFourPixelContact:
                cmp.w   d1,d5
                bhi.w   SKCollision_ClassifyVerticalSolidContactBySignedCorrectionAndSixteenPixels
                cmpi.w  #4,d1
                bls.w   SKCollision_ClassifyVerticalSolidContactBySignedCorrectionAndSixteenPixels

SKCollision_ChooseSideCollisionVelocityStopByCorrectionSign:
                tst.w   d0
                beq.s   SKCollision_ApplySidePositionCorrectionAndGroundedPushContact
                bmi.s   SKCollision_TestNegativeSideCorrectionAgainstHorizontalVelocity
                tst.w   x_vel(a1)
                bmi.s   SKCollision_ApplySidePositionCorrectionAndGroundedPushContact
                bra.s   SKCollision_StopHorizontalMotionAndFlagTertiarySideImpact
; ---------------------------------------------------------------------------

SKCollision_TestNegativeSideCorrectionAgainstHorizontalVelocity:
                tst.w   x_vel(a1)
                bpl.s   SKCollision_ApplySidePositionCorrectionAndGroundedPushContact

SKCollision_StopHorizontalMotionAndFlagTertiarySideImpact:
                move.w  #0,ground_vel(a1)
                move.w  #0,x_vel(a1)
                tst.b   status_tertiary(a1)
                bpl.s   SKCollision_ApplySidePositionCorrectionAndGroundedPushContact
                bset    #6,status_tertiary(a1)

SKCollision_ApplySidePositionCorrectionAndGroundedPushContact:
                sub.w   d0,x_pos(a1)
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_ClearAirbornePushAndReportSideCollision
                move.l  d6,d4
                addq.b  #pushing_bit_delta,d4
                bset    d4,status(a0)
                bset    #Status_Push,status(a1)
                move.w  d6,d4
                addi.b  #$D,d4
                bset    d4,d6
                moveq   #1,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_ClearAirbornePushAndReportSideCollision:
                bsr.s   ClearPlayerPushingSolid
                move.w  d6,d4
                addi.b  #$D,d4
                bset    d4,d6
                moveq   #1,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_ClearStalePushAndSelectWalkingWordAnimation:
                move.l  d6,d4
                addq.b  #pushing_bit_delta,d4
                btst    d4,status(a0)
                beq.s   SKCollision_ReturnSolidNoReportedCollision
                cmpi.b  #2,anim(a1)
                beq.s   ClearPlayerPushingSolid
                cmpi.b  #9,anim(a1)
                beq.s   ClearPlayerPushingSolid
                move.w  #1,anim(a1)
; End of function SolidObjectFull_Offset_1P

; =============== S U B R O U T I N E =======================================

ClearPlayerPushingSolid:
                move.l  d6,d4
                addq.b  #pushing_bit_delta,d4
                bclr    d4,status(a0)
                bclr    #Status_Push,status(a1)

SKCollision_ReturnSolidNoReportedCollision:
                moveq   #0,d4
                rts
; End of function ClearPlayerPushingSolid

; ---------------------------------------------------------------------------

SKCollision_ClassifyVerticalSolidContactBySignedCorrectionAndSixteenPixels:
                tst.w   d3
                bmi.s   SKCollision_ResolveUndersideByAirborneAndVerticalVelocity
                cmpi.w  #$10,d3
                blo.s   SKCollision_ValidateTopContactUsingVisualWidthBeforeSnap
                bra.s   SKCollision_ClearStalePushAndSelectWalkingWordAnimation
; ---------------------------------------------------------------------------

SKCollision_ResolveUndersideByAirborneAndVerticalVelocity:
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_ZeroAirborneGroundSpeedBeforeUndersideCorrection
                tst.w   y_vel(a1)
                beq.s   SKCollision_TestZeroVerticalSpeedGroundedCrushLateralDepth
                bpl.s   SKCollision_FlagTertiaryUndersideImpact
                tst.w   d3
                bpl.s   SKCollision_FlagTertiaryUndersideImpact
                bra.s   SKCollision_ReflectUndersideCorrectionForReverseGravity
; ---------------------------------------------------------------------------

SKCollision_ZeroAirborneGroundSpeedBeforeUndersideCorrection:
                move.w  #0,ground_vel(a1)

SKCollision_ReflectUndersideCorrectionForReverseGravity:
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKCollision_ApplyUndersideYCorrectionAndStopVerticalSpeed
                neg.w   d3

SKCollision_ApplyUndersideYCorrectionAndStopVerticalSpeed:
                sub.w   d3,y_pos(a1)
                move.w  #0,y_vel(a1)

SKCollision_FlagTertiaryUndersideImpact:
                tst.b   status_tertiary(a1)
                bpl.s   SKCollision_AccumulateUndersideContactAndReturnMinusTwo
                bset    #5,status_tertiary(a1)

SKCollision_AccumulateUndersideContactAndReturnMinusTwo:
                move.w  d6,d4
                addi.b  #$F,d4
                bset    d4,d6
                moveq   #-2,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_TestZeroVerticalSpeedGroundedCrushLateralDepth:
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_FlagTertiaryUndersideImpact
                move.w  d0,d4
                bpl.s   SKCollision_KillCrushedPlayerUnlessNearHorizontalEdge
                neg.w   d4

SKCollision_KillCrushedPlayerUnlessNearHorizontalEdge:
                cmpi.w  #$10,d4
                blo.w   SKCollision_ChooseSideCollisionVelocityStopByCorrectionSign
                move.l  a0,-(sp)
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l (sp)+,a0
                move.w  d6,d4
                addi.b  #$F,d4
                bset    d4,d6
                moveq   #-2,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_ValidateTopContactUsingVisualWidthBeforeSnap:
                subq.w  #4,d3
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  d1,d2
                add.w   d2,d2
                add.w   x_pos(a1),d1
                sub.w   x_pos(a0),d1
                bmi.s   SKCollision_ReturnRejectedTopContactWithZeroD4
                cmp.w   d2,d1
                bhs.s   SKCollision_ReturnRejectedTopContactWithZeroD4
                subq.w  #1,y_pos(a1)
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKCollision_SnapTopContactAndAttachOnlyForNonnegativeVerticalVelocity
                neg.w   d3
                addq.w  #2,y_pos(a1)

SKCollision_SnapTopContactAndAttachOnlyForNonnegativeVerticalVelocity:
                sub.w   d3,y_pos(a1)
                tst.w   y_vel(a1)
                bmi.s   SKCollision_ReturnRejectedTopContactWithZeroD4
                bsr.w   RideObject_SetRide
                move.w  d6,d4
                addi.b  #$11,d4
                bset    d4,d6
                moveq   #-1,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_ReturnRejectedTopContactWithZeroD4:
                moveq   #0,d4
                rts

; =============== S U B R O U T I N E =======================================

MvSonicOnPtfm:
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKCollision_ComputeReverseGravityFlatRiderSurface
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                bra.s   SKCollision_MoveFlatRiderAboveSurfaceWithControlAndDebugGates
; ---------------------------------------------------------------------------

SKCollision_ComputeReverseGravityFlatRiderSurface:
                move.w  y_pos(a0),d0
                add.w   d3,d0
                bra.s   SKCollision_MoveFlatRiderBelowSurfaceForReverseGravity
; ---------------------------------------------------------------------------
; This is hilarious. The unused S1 code was upgraded with an S3K feature
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKCollision_ComputeRetainedFixedNinePixelNormalRiderSurface
                move.w  y_pos(a0),d0
                addi.w  #9,d0
                bra.s   SKCollision_MoveFlatRiderBelowSurfaceForReverseGravity
; ---------------------------------------------------------------------------

SKCollision_ComputeRetainedFixedNinePixelNormalRiderSurface:
                move.w  y_pos(a0),d0
                subi.w  #9,d0

SKCollision_MoveFlatRiderAboveSurfaceWithControlAndDebugGates:
                tst.b   object_control(a1)
                bmi.s   SKCollision_ReturnNormalGravityFlatRiderMover
                cmpi.b  #6,routine(a1)
                bhs.s   SKCollision_ReturnNormalGravityFlatRiderMover
                tst.w   (Debug_placement_mode).w
                bne.s   SKCollision_ReturnNormalGravityFlatRiderMover
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                sub.w   x_pos(a0),d2
                sub.w   d2,x_pos(a1)

SKCollision_ReturnNormalGravityFlatRiderMover:
                rts
; ---------------------------------------------------------------------------

SKCollision_MoveFlatRiderBelowSurfaceForReverseGravity:
                tst.b   object_control(a1)
                bmi.s   SKCollision_ReturnReverseGravityFlatRiderMover
                cmpi.b  #6,routine(a1)
                bhs.s   SKCollision_ReturnReverseGravityFlatRiderMover
                tst.w   (Debug_placement_mode).w
                bne.s   SKCollision_ReturnReverseGravityFlatRiderMover
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   d1,d0
                move.w  d0,y_pos(a1)
                sub.w   x_pos(a0),d2
                sub.w   d2,x_pos(a1)

SKCollision_ReturnReverseGravityFlatRiderMover:
                rts
; End of function MvSonicOnPtfm
