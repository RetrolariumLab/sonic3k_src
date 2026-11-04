; Owner: game/collision/s3
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
                bpl.w   S3Collision_ReturnFromFullSolidOrInvisibleSecondaryGate
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectFull

; =============== S U B R O U T I N E =======================================

SolidObjectFull_1P:
                btst    d6,status(a0)
                beq.w   S3Collision_RequireVisibleObjectForFirstFullSolidVariant
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   S3Collision_ReleaseFullRectangleRiderOutsideSpanOrInAir
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3Collision_ReleaseFullRectangleRiderOutsideSpanOrInAir
                cmp.w   d2,d0
                blo.s   S3Collision_CarryExistingFullRectangleRider

S3Collision_ReleaseFullRectangleRiderOutsideSpanOrInAir:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3Collision_CarryExistingFullRectangleRider:
                move.w  d4,d2
                bsr.w   MvSonicOnPtfm
                moveq   #0,d4

S3Collision_ReturnFromFullSolidOrInvisibleSecondaryGate:
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
                bne.s   S3Collision_ReleaseFullSolidSecondVariantRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3Collision_ReleaseFullSolidSecondVariantRider
                cmp.w   d2,d0
                blo.s   S3Collision_CarryFullSolidSecondVariantRider

S3Collision_ReleaseFullSolidSecondVariantRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3Collision_CarryFullSolidSecondVariantRider:
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
                beq.w   S3Collision_TestUnboundHeightProfileHorizontalSpan
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   S3Collision_ReleaseHeightProfileRiderOutsideSpanOrInAir
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3Collision_ReleaseHeightProfileRiderOutsideSpanOrInAir
                cmp.w   d2,d0
                blo.s   S3Collision_CarryHeightProfileRiderAndMarkStandingResult

S3Collision_ReleaseHeightProfileRiderOutsideSpanOrInAir:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3Collision_CarryHeightProfileRiderAndMarkStandingResult:
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
                beq.w   S3Collision_TestUnboundDualHeightProfileSpan
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   S3Collision_ReleaseDualHeightProfileRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3Collision_ReleaseDualHeightProfileRider
                cmp.w   d2,d0
                blo.s   S3Collision_CarryDualHeightProfileRider

S3Collision_ReleaseDualHeightProfileRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3Collision_CarryDualHeightProfileRider:
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
                beq.w   S3Collision_TestUnboundHeightProfileHorizontalSpan
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   S3Collision_ReleaseHeightProfileRiderWithoutSettingAir
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3Collision_ReleaseHeightProfileRiderWithoutSettingAir
                cmp.w   d2,d0
                blo.s   S3Collision_CarryKeepAirHeightProfileAndMarkResult

S3Collision_ReleaseHeightProfileRiderWithoutSettingAir:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3Collision_CarryKeepAirHeightProfileAndMarkResult:
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
                beq.w   S3Collision_TestUnboundOffsetRectangleOverlap
                btst    #Status_InAir,status(a1)
                bne.s   S3Collision_ReleaseOffsetRectangleRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3Collision_ReleaseOffsetRectangleRider
                add.w   d1,d1
                cmp.w   d1,d0
                blo.s   S3Collision_SnapOffsetRectangleRiderAndCarryX

S3Collision_ReleaseOffsetRectangleRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3Collision_SnapOffsetRectangleRiderAndCarryX:
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

S3Collision_TestUnboundOffsetRectangleOverlap:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                move.w  d1,d4
                add.w   d4,d4
                cmp.w   d4,d0
                bhi.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                move.w  y_pos(a0),d5
                add.w   d3,d5
                move.b  y_radius(a1),d3
                ext.w   d3
                add.w   d3,d2
                move.w  y_pos(a1),d3
                sub.w   d5,d3
                addq.w  #4,d3
                add.w   d2,d3
                bmi.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                move.w  d2,d4
                add.w   d4,d4
                cmp.w   d4,d3
                bhs.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                bra.w   S3Collision_ChooseHorizontalAndVerticalResolutionDepths
; ---------------------------------------------------------------------------

S3Collision_TestUnboundHeightProfileHorizontalSpan:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                move.w  d0,d5
                btst    #0,render_flags(a0)
                beq.s   S3Collision_BuildOverlapFromRelativeHeightProfileDelta
                not.w   d5
                add.w   d3,d5

S3Collision_BuildOverlapFromRelativeHeightProfileDelta:
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
                bmi.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                move.w  d2,d4
                add.w   d4,d4
                cmp.w   d4,d3
                bhs.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                bra.w   S3Collision_ChooseHorizontalAndVerticalResolutionDepths
; ---------------------------------------------------------------------------

S3Collision_TestUnboundDualHeightProfileSpan:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                move.w  d0,d5
                btst    #0,render_flags(a0)
                beq.s   S3Collision_BuildOverlapFromTwoAdjacentHeightBytes
                not.w   d5
                add.w   d3,d5

S3Collision_BuildOverlapFromTwoAdjacentHeightBytes:
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
                bmi.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                add.w   d5,d2
                move.w  d2,d4
                add.w   d5,d4
                cmp.w   d4,d3
                bhs.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                bra.w   S3Collision_ChooseHorizontalAndVerticalResolutionDepths
; ---------------------------------------------------------------------------

S3Collision_RequireVisibleObjectForFirstFullSolidVariant:
                tst.b   render_flags(a0)
                bpl.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap

SolidObject_cont:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                move.w  d1,d3
                add.w   d3,d3
                cmp.w   d3,d0
                bhi.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
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
                bmi.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                andi.w  #$FFF,d3
                add.w   d2,d4
                cmp.w   d4,d3
                bhs.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap

S3Collision_ChooseHorizontalAndVerticalResolutionDepths:
                tst.b   object_control(a1)
                bmi.w   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
                cmpi.b  #6,routine(a1)
                bhs.w   S3Collision_ReturnNoSolidResolutionResult
                tst.w   (Debug_placement_mode).w
                bne.w   S3Collision_ReturnNoSolidResolutionResult
                move.w  d0,d5
                cmp.w   d0,d1
                bhs.s   S3Collision_ChooseVerticalCorrectionAndMagnitude
                add.w   d1,d1
                sub.w   d1,d0
                move.w  d0,d5
                neg.w   d5

S3Collision_ChooseVerticalCorrectionAndMagnitude:
                move.w  d3,d1
                cmp.w   d3,d2
                bhs.s   S3Collision_ChooseResolutionAxisByPenetrationMagnitude
                subq.w  #4,d3
                sub.w   d4,d3
                move.w  d3,d1
                neg.w   d1

S3Collision_ChooseResolutionAxisByPenetrationMagnitude:
                cmp.w   d1,d5
                bhi.w   S3Collision_SelectUndersideOrShallowTopResolution

S3Collision_ResolveSideContactVelocityDirection:
                cmpi.w  #4,d1
                bls.w   S3Collision_SelectUndersideOrShallowTopResolution
                tst.w   d0
                beq.s   S3Collision_CorrectHorizontalOverlapAndSetSideResult
                bmi.s   S3Collision_CheckNegativeSideContactVelocity
                tst.w   x_vel(a1)
                bmi.s   S3Collision_CorrectHorizontalOverlapAndSetSideResult
                bra.s   S3Collision_StopHorizontalMotionForBlockingSide
; ---------------------------------------------------------------------------

S3Collision_CheckNegativeSideContactVelocity:
                tst.w   x_vel(a1)
                bpl.s   S3Collision_CorrectHorizontalOverlapAndSetSideResult

S3Collision_StopHorizontalMotionForBlockingSide:
                move.w  #0,ground_vel(a1)
                move.w  #0,x_vel(a1)
                tst.b   status_tertiary(a1)
                bpl.s   S3Collision_CorrectHorizontalOverlapAndSetSideResult
                bset    #6,status_tertiary(a1)

S3Collision_CorrectHorizontalOverlapAndSetSideResult:
                sub.w   d0,x_pos(a1)
                btst    #Status_InAir,status(a1)
                bne.s   S3Collision_ClearAirbornePushAndMarkSideContact
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

S3Collision_ClearAirbornePushAndMarkSideContact:
                bsr.s   ClearPlayerPushingSolid
                move.w  d6,d4
                addi.b  #$D,d4
                bset    d4,d6
                moveq   #1,d4
                rts
; ---------------------------------------------------------------------------

S3Collision_CleanUpPriorPushWhenNoSolidOverlap:
                move.l  d6,d4
                addq.b  #pushing_bit_delta,d4
                btst    d4,status(a0)
                beq.s   S3Collision_ReturnNoSolidResolutionResult
                cmpi.b  #2,anim(a1)
                beq.s   ClearPlayerPushingSolid
                move.w  #1,anim(a1)
; End of function SolidObjectFull_Offset_1P

; =============== S U B R O U T I N E =======================================

ClearPlayerPushingSolid:
                move.l  d6,d4
                addq.b  #pushing_bit_delta,d4
                bclr    d4,status(a0)
                bclr    #Status_Push,status(a1)

S3Collision_ReturnNoSolidResolutionResult:
                moveq   #0,d4
                rts
; End of function ClearPlayerPushingSolid

; ---------------------------------------------------------------------------

S3Collision_SelectUndersideOrShallowTopResolution:
                tst.w   d3
                bmi.s   S3Collision_ResolveUndersideByAirAndVerticalVelocity
                cmpi.w  #$10,d3
                blo.s   S3Collision_ResolveShallowTopOverlapAndAttachDescendingRider
                bra.s   S3Collision_CleanUpPriorPushWhenNoSolidOverlap
; ---------------------------------------------------------------------------

S3Collision_ResolveUndersideByAirAndVerticalVelocity:
                btst    #Status_InAir,status(a1)
                bne.s   S3Collision_ZeroGroundSpeedBeforeAirborneUndersideCorrection
                tst.w   y_vel(a1)
                beq.s   S3Collision_MeasureHorizontalDepthForGroundedCrush
                bpl.s   S3Collision_MarkSpecialUndersideResponseWhenTertiaryNegative
                tst.w   d3
                bpl.s   S3Collision_MarkSpecialUndersideResponseWhenTertiaryNegative
                bra.s   S3Collision_CorrectUndersideYAndStopVerticalVelocity
; ---------------------------------------------------------------------------

S3Collision_ZeroGroundSpeedBeforeAirborneUndersideCorrection:
                move.w  #0,ground_vel(a1)

S3Collision_CorrectUndersideYAndStopVerticalVelocity:
                sub.w   d3,y_pos(a1)
                move.w  #0,y_vel(a1)

S3Collision_MarkSpecialUndersideResponseWhenTertiaryNegative:
                tst.b   status_tertiary(a1)
                bpl.s   S3Collision_ReturnUndersideContactResult
                bset    #5,status_tertiary(a1)

S3Collision_ReturnUndersideContactResult:
                move.w  d6,d4
                addi.b  #$F,d4
                bset    d4,d6
                moveq   #-2,d4
                rts
; ---------------------------------------------------------------------------

S3Collision_MeasureHorizontalDepthForGroundedCrush:
                btst    #Status_InAir,status(a1)
                bne.s   S3Collision_MarkSpecialUndersideResponseWhenTertiaryNegative
                move.w  d0,d4
                bpl.s   S3Collision_ChooseShallowSideOrInvokeCrushDeath
                neg.w   d4

S3Collision_ChooseShallowSideOrInvokeCrushDeath:
                cmpi.w  #$10,d4
                blo.w   S3Collision_ResolveSideContactVelocityDirection
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

S3Collision_ResolveShallowTopOverlapAndAttachDescendingRider:
                subq.w  #4,d3
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  d1,d2
                add.w   d2,d2
                add.w   x_pos(a1),d1
                sub.w   x_pos(a0),d1
                bmi.s   S3Collision_ReturnRejectedOrAscendingTopContact
                cmp.w   d2,d1
                bhs.s   S3Collision_ReturnRejectedOrAscendingTopContact
                sub.w   d3,y_pos(a1)
                subq.w  #1,y_pos(a1)
                tst.w   y_vel(a1)
                bmi.s   S3Collision_ReturnRejectedOrAscendingTopContact
                bsr.w   RideObject_SetRide
                move.w  d6,d4
                addi.b  #$11,d4
                bset    d4,d6
                moveq   #-1,d4
                rts
; ---------------------------------------------------------------------------

S3Collision_ReturnRejectedOrAscendingTopContact:
                moveq   #0,d4
                rts

; =============== S U B R O U T I N E =======================================

MvSonicOnPtfm:
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                bra.s   S3Collision_CarryRiderAtPreparedPlatformTop
; ---------------------------------------------------------------------------
; unused leftover from Sonic 1/2
                move.w  y_pos(a0),d0
                subi.w  #9,d0

S3Collision_CarryRiderAtPreparedPlatformTop:
                tst.b   object_control(a1)
                bmi.s   S3Collision_ReturnMovingPlatformCarryOrRefusal
                cmpi.b  #6,routine(a1)
                bhs.s   S3Collision_ReturnMovingPlatformCarryOrRefusal
                tst.w   (Debug_placement_mode).w
                bne.s   S3Collision_ReturnMovingPlatformCarryOrRefusal
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                sub.w   x_pos(a0),d2
                sub.w   d2,x_pos(a1)

S3Collision_ReturnMovingPlatformCarryOrRefusal:
                rts
; End of function MvSonicOnPtfm
