; Owner: game/collision/sk
; Responsibility: Sloped and top-only solid platforms, ride attachment and player release checks
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SolidObjSloped:
                btst    #Status_OnObj,status(a1)
                beq.s   SKCollision_ReturnSlopedMoverOrMissingOnObjectFlag
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                btst    #0,render_flags(a0)
                beq.s   SKCollision_RouteFullResolutionSlopedRiderToHeightSample
                not.w   d0
                add.w   d1,d0
                add.w   d1,d0

SKCollision_RouteFullResolutionSlopedRiderToHeightSample:
                bra.s   SKCollision_SnapSlopedRiderAndCarryHorizontalDelta
; End of function SolidObjSloped

; =============== S U B R O U T I N E =======================================

SolidObjSloped2:
                btst    #Status_OnObj,status(a1)
                beq.s   SKCollision_ReturnSlopedMoverOrMissingOnObjectFlag
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                lsr.w   #1,d0
                btst    #0,render_flags(a0)
                beq.s   SKCollision_SnapSlopedRiderAndCarryHorizontalDelta
                not.w   d0
                add.w   d1,d0

SKCollision_SnapSlopedRiderAndCarryHorizontalDelta:
                move.b  (a2,d0.w),d1
                ext.w   d1
                move.w  y_pos(a0),d0
                sub.w   d1,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                sub.w   x_pos(a0),d2
                sub.w   d2,x_pos(a1)

SKCollision_ReturnSlopedMoverOrMissingOnObjectFlag:
                rts
; End of function SolidObjSloped2

; =============== S U B R O U T I N E =======================================

SolidObjSloped4:
                btst    #Status_OnObj,status(a1)
                beq.s   SKCollision_ReturnSlopedMoverOrMissingOnObjectFlag
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                btst    #0,render_flags(a0)
                beq.s   SKCollision_AlignDualProfileRiderIndexToEvenByte
                not.w   d0
                add.w   d1,d0

SKCollision_AlignDualProfileRiderIndexToEvenByte:
                andi.w  #$FFFE,d0
                bra.s   SKCollision_SnapSlopedRiderAndCarryHorizontalDelta
; End of function SolidObjSloped4

; =============== S U B R O U T I N E =======================================

SolidObjectTop:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   SolidObjectTop_1P
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectTop

; =============== S U B R O U T I N E =======================================

SolidObjectTop_1P:
                btst    d6,status(a0)
                beq.w   SKCollision_TestNewFlatTopLandingVelocityAndHorizontalSpan
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_DetachFlatTopRiderAndMarkAirborne
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollision_DetachFlatTopRiderAndMarkAirborne
                cmp.w   d2,d0
                blo.s   SKCollision_CarryExistingFlatTopRider

SKCollision_DetachFlatTopRiderAndMarkAirborne:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_CarryExistingFlatTopRider:
                move.w  d4,d2
                bsr.w   MvSonicOnPtfm
                moveq   #0,d4
                rts
; End of function SolidObjectTop_1P

; =============== S U B R O U T I N E =======================================

SolidObjectTopSloped2:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   SolidObjectTopSloped2_1P
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectTopSloped2

; =============== S U B R O U T I N E =======================================

SolidObjectTopSloped2_1P:
                btst    d6,status(a0)
                beq.w   SolidObjCheckSloped2
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_DetachHalfResolutionSlopeRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollision_DetachHalfResolutionSlopeRider
                cmp.w   d2,d0
                blo.s   SKCollision_MoveExistingHalfResolutionSlopeRider

SKCollision_DetachHalfResolutionSlopeRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_MoveExistingHalfResolutionSlopeRider:
                move.w  d4,d2
                bsr.w   SolidObjSloped2
                moveq   #0,d4
                rts
; End of function SolidObjectTopSloped2_1P

; =============== S U B R O U T I N E =======================================

SolidObjectTopSloped:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   SolidObjectTopSloped_1P
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function SolidObjectTopSloped

; =============== S U B R O U T I N E =======================================

SolidObjectTopSloped_1P:
                btst    d6,status(a0)
                beq.w   SolidObjCheckSloped
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_DetachFullResolutionSlopeRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollision_DetachFullResolutionSlopeRider
                cmp.w   d2,d0
                blo.s   SKCollision_MoveExistingFullResolutionSlopeRider

SKCollision_DetachFullResolutionSlopeRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_MoveExistingFullResolutionSlopeRider:
                move.w  d4,d2
                bsr.w   SolidObjSloped
                moveq   #0,d4
                rts
; End of function SolidObjectTopSloped_1P

; ---------------------------------------------------------------------------
; unused
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.s   CollidePlayerWithUnclaimedFlatPlatform
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6

; =============== S U B R O U T I N E =======================================

CollidePlayerWithUnclaimedFlatPlatform:
                btst    d6,status(a0)
                bne.s   SKCollision_ValidateExistingRiderInUnclaimedFlatVariant
                btst    #Status_OnObj,status(a1)
                bne.s   SKCollision_ReturnUnclaimedFlatVariantWithoutReportedCollision
                bra.w   SKCollision_TestNewFlatTopLandingVelocityAndHorizontalSpan
; ---------------------------------------------------------------------------

SKCollision_ValidateExistingRiderInUnclaimedFlatVariant:
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKCollision_DetachUnclaimedFlatVariantRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollision_DetachUnclaimedFlatVariantRider
                cmp.w   d2,d0
                blo.s   SKCollision_CarryUnclaimedFlatVariantExistingRider

SKCollision_DetachUnclaimedFlatVariantRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)

SKCollision_ReturnUnclaimedFlatVariantWithoutReportedCollision:
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKCollision_CarryUnclaimedFlatVariantExistingRider:
                move.w  d4,d2
                bsr.w   MvSonicOnPtfm
                moveq   #0,d4
                rts
; End of function CollidePlayerWithUnclaimedFlatPlatform

; =============== S U B R O U T I N E =======================================

TryLandPlayerOnPlatformSpan:
                tst.w   y_vel(a1)
                bmi.w   SKCollision_ReturnPlatformLandingOrRejectedProbe
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   SKCollision_ReturnPlatformLandingOrRejectedProbe
                cmp.w   d2,d0
                bhs.w   SKCollision_ReturnPlatformLandingOrRejectedProbe
                bra.s   SKCollision_SelectNormalOrReverseGravityFlatTopSurface
; ---------------------------------------------------------------------------

SKCollision_TestNewFlatTopLandingVelocityAndHorizontalSpan:
                tst.w   y_vel(a1)
                bmi.w   SKCollision_ReturnPlatformLandingOrRejectedProbe
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   SKCollision_ReturnPlatformLandingOrRejectedProbe
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.w   SKCollision_ReturnPlatformLandingOrRejectedProbe

SKCollision_SelectNormalOrReverseGravityFlatTopSurface:
                tst.b   (Reverse_gravity_flag).w
                bne.w   SKCollision_LandOnReverseGravityFlatSurface
                move.w  y_pos(a0),d0
                sub.w   d3,d0

SKCollision_LandAtCallerComputedTopWithinUnsignedPenetrationWindow:
                move.w  y_pos(a1),d2
                move.b  y_radius(a1),d1
                ext.w   d1
                add.w   d2,d1
                addq.w  #4,d1
                sub.w   d1,d0
                bhi.w   SKCollision_ReturnPlatformLandingOrRejectedProbe
                cmpi.w  #-$10,d0
                blo.w   SKCollision_ReturnPlatformLandingOrRejectedProbe
                tst.b   object_control(a1)
                bmi.w   SKCollision_ReturnPlatformLandingOrRejectedProbe
                cmpi.b  #6,routine(a1)
                bhs.w   SKCollision_ReturnPlatformLandingOrRejectedProbe
                add.w   d0,d2
                addq.w  #3,d2
                move.w  d2,y_pos(a1)
; End of function TryLandPlayerOnPlatformSpan

; =============== S U B R O U T I N E =======================================

RideObject_SetRide:
                btst    #Status_OnObj,status(a1)
                beq.s   SKCollision_InstallRidePointerAndConditionalCharacterLandingCleanup
                movea.w interact(a1),a3
                bclr    d6,status(a3)

SKCollision_InstallRidePointerAndConditionalCharacterLandingCleanup:
                move.w  a0,interact(a1)
                move.b  #0,angle(a1)
                move.w  #0,y_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bset    #Status_OnObj,status(a1)
                bset    d6,status(a0)
                bclr    #Status_InAir,status(a1)
                beq.s   SKCollision_ReturnPlatformLandingOrRejectedProbe
                move.l  a0,-(sp)
                movea.l a1,a0
                jsr     (Player_TouchFloor).l
                movea.l (sp)+,a0

SKCollision_ReturnPlatformLandingOrRejectedProbe:
                rts
; End of function RideObject_SetRide

; ---------------------------------------------------------------------------

SKCollision_LandOnReverseGravityFlatSurface:
                move.w  y_pos(a0),d0
                add.w   d3,d0
                move.w  y_pos(a1),d2
                move.b  y_radius(a1),d1
                ext.w   d1
                neg.w   d1
                add.w   d2,d1
                subq.w  #4,d1
                sub.w   d0,d1
                bhi.s   SKCollision_ReturnPlatformLandingOrRejectedProbe
                cmpi.w  #-$10,d1
                blo.s   SKCollision_ReturnPlatformLandingOrRejectedProbe
                tst.b   object_control(a1)
                bmi.s   SKCollision_ReturnPlatformLandingOrRejectedProbe
                cmpi.b  #6,routine(a1)
                bhs.s   SKCollision_ReturnPlatformLandingOrRejectedProbe
                sub.w   d1,d2
                subq.w  #4,d2
                move.w  d2,y_pos(a1)
                bra.s   RideObject_SetRide
; ---------------------------------------------------------------------------

SolidObjCheckSloped2:
                tst.w   y_vel(a1)
                bmi.w   SKCollision_ReturnPlatformLandingOrRejectedProbe
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollision_ReturnPlatformLandingOrRejectedProbe
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.s   SKCollision_ReturnPlatformLandingOrRejectedProbe
                btst    #0,render_flags(a0)
                beq.s   SKCollision_SampleHalfResolutionNewSlopeSurface
                not.w   d0
                add.w   d1,d0

SKCollision_SampleHalfResolutionNewSlopeSurface:
                lsr.w   #1,d0
                move.b  (a2,d0.w),d3
                ext.w   d3
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                bra.w   SKCollision_LandAtCallerComputedTopWithinUnsignedPenetrationWindow
; ---------------------------------------------------------------------------

SolidObjCheckSloped:
                tst.w   y_vel(a1)
                bmi.w   SKCollision_ReturnPlatformLandingOrRejectedProbe
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   SKCollision_ReturnPlatformLandingOrRejectedProbe
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.w   SKCollision_ReturnPlatformLandingOrRejectedProbe
                btst    #0,render_flags(a0)
                beq.s   SKCollision_SampleFullResolutionNewSlopeSurface
                not.w   d0
                add.w   d1,d0

SKCollision_SampleFullResolutionNewSlopeSurface:
                move.b  (a2,d0.w),d3
                ext.w   d3
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                bra.w   SKCollision_LandAtCallerComputedTopWithinUnsignedPenetrationWindow

; =============== S U B R O U T I N E =======================================

CheckPlayerReleaseFromObj:
                lea     (Player_1).w,a1
                btst    #p1_standing_bit,status(a0)
                beq.s   SKCollision_TestPlayerTwoRiderAgainstTerrainForRelease
                jsr     (SonicOnObjHitFloor).l
                tst.w   d1
                beq.s   SKCollision_ReleasePlayerOneRiderWhenTerrainDistanceNonpositive
                bpl.s   SKCollision_TestPlayerTwoRiderAgainstTerrainForRelease

SKCollision_ReleasePlayerOneRiderWhenTerrainDistanceNonpositive:
                lea     (Player_1).w,a1
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    #p1_standing_bit,status(a0)

SKCollision_TestPlayerTwoRiderAgainstTerrainForRelease:
                lea     (Player_2).w,a1
                btst    #p2_standing_bit,status(a0)
                beq.s   SKCollision_ReturnRiderReleaseCheckWithZeroD4
                jsr     (SonicOnObjHitFloor).l
                tst.w   d1
                beq.s   SKCollision_ReleasePlayerTwoRiderWhenTerrainDistanceNonpositive
                bpl.s   SKCollision_ReturnRiderReleaseCheckWithZeroD4

SKCollision_ReleasePlayerTwoRiderWhenTerrainDistanceNonpositive:
                lea     (Player_2).w,a1
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    #p2_standing_bit,status(a0)

SKCollision_ReturnRiderReleaseCheckWithZeroD4:
                moveq   #0,d4
                rts
; End of function CheckPlayerReleaseFromObj
