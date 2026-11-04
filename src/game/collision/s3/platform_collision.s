; Owner: game/collision/s3
; Responsibility: Sloped and top-only solid platforms, ride attachment and player release checks
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SolidObjSloped2:
                btst    #Status_OnObj,status(a1)
                beq.s   S3Collision_ReturnFromStandingSlopeCarry
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                lsr.w   #1,d0
                btst    #0,render_flags(a0)
                beq.s   S3Collision_SnapStandingRiderToIndexedSlopeAndCarryX
                not.w   d0
                add.w   d1,d0

S3Collision_SnapStandingRiderToIndexedSlopeAndCarryX:
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

S3Collision_ReturnFromStandingSlopeCarry:
                rts
; End of function SolidObjSloped2

; =============== S U B R O U T I N E =======================================

SolidObjSloped4:
                btst    #Status_OnObj,status(a1)
                beq.s   S3Collision_ReturnFromStandingSlopeCarry
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                btst    #0,render_flags(a0)
                beq.s   S3Collision_AlignFullResolutionSlopeSampleToEvenByte
                not.w   d0
                add.w   d1,d0

S3Collision_AlignFullResolutionSlopeSampleToEvenByte:
                andi.w  #$FFFE,d0
                bra.s   S3Collision_SnapStandingRiderToIndexedSlopeAndCarryX
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
                beq.w   S3Collision_TestNewFlatTopLandingHorizontalSpan
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   S3Collision_ReleaseFlatTopRiderOutsideSpanOrInAir
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3Collision_ReleaseFlatTopRiderOutsideSpanOrInAir
                cmp.w   d2,d0
                blo.s   S3Collision_CarryExistingFlatTopRider

S3Collision_ReleaseFlatTopRiderOutsideSpanOrInAir:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3Collision_CarryExistingFlatTopRider:
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
                bne.s   S3Collision_ReleaseIndexedSlopeRiderOutsideSpanOrInAir
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3Collision_ReleaseIndexedSlopeRiderOutsideSpanOrInAir
                cmp.w   d2,d0
                blo.s   S3Collision_CarryExistingIndexedSlopeRider

S3Collision_ReleaseIndexedSlopeRiderOutsideSpanOrInAir:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3Collision_CarryExistingIndexedSlopeRider:
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
                bne.s   S3Collision_ValidateExistingSlopedTopRiderSpan
                btst    #Status_OnObj,status(a1)
                bne.s   S3Collision_ReturnNoNewPlatformContact
                bra.w   S3Collision_TestNewFlatTopLandingHorizontalSpan
; ---------------------------------------------------------------------------

S3Collision_ValidateExistingSlopedTopRiderSpan:
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   S3Collision_ReleaseSlopedTopRiderFlags
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3Collision_ReleaseSlopedTopRiderFlags
                cmp.w   d2,d0
                blo.s   S3Collision_CarryExistingSlopedTopRiderWithoutSlopeLookup

S3Collision_ReleaseSlopedTopRiderFlags:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)

S3Collision_ReturnNoNewPlatformContact:
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3Collision_CarryExistingSlopedTopRiderWithoutSlopeLookup:
                move.w  d4,d2
                bsr.w   MvSonicOnPtfm
                moveq   #0,d4
                rts
; End of function SolidObjectTopSloped_1P

; =============== S U B R O U T I N E =======================================

TryLandPlayerOnPlatformSpan:
                tst.w   y_vel(a1)
                bmi.w   S3Collision_ReturnFromPlatformLandingOrRejectedContact
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   S3Collision_ReturnFromPlatformLandingOrRejectedContact
                cmp.w   d2,d0
                bhs.w   S3Collision_ReturnFromPlatformLandingOrRejectedContact
                bra.s   S3Collision_ComputePlatformTopForLanding
; ---------------------------------------------------------------------------

S3Collision_TestNewFlatTopLandingHorizontalSpan:
                tst.w   y_vel(a1)
                bmi.w   S3Collision_ReturnFromPlatformLandingOrRejectedContact
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.w   S3Collision_ReturnFromPlatformLandingOrRejectedContact
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.w   S3Collision_ReturnFromPlatformLandingOrRejectedContact

S3Collision_ComputePlatformTopForLanding:
                move.w  y_pos(a0),d0
                sub.w   d3,d0

S3Collision_TestPlatformLandingWindowAndSnapRider:
                move.w  y_pos(a1),d2
                move.b  y_radius(a1),d1
                ext.w   d1
                add.w   d2,d1
                addq.w  #4,d1
                sub.w   d1,d0
                bhi.w   S3Collision_ReturnFromPlatformLandingOrRejectedContact
                cmpi.w  #-$10,d0
                blo.w   S3Collision_ReturnFromPlatformLandingOrRejectedContact
                tst.b   object_control(a1)
                bmi.w   S3Collision_ReturnFromPlatformLandingOrRejectedContact
                cmpi.b  #6,routine(a1)
                bhs.w   S3Collision_ReturnFromPlatformLandingOrRejectedContact
                add.w   d0,d2
                addq.w  #3,d2
                move.w  d2,y_pos(a1)
; End of function TryLandPlayerOnPlatformSpan

; =============== S U B R O U T I N E =======================================

RideObject_SetRide:
                btst    #Status_OnObj,status(a1)
                beq.s   S3Collision_BindRiderHandleAndStandingFlags
                movea.w interact(a1),a3
                bclr    d6,status(a3)

S3Collision_BindRiderHandleAndStandingFlags:
                move.w  a0,interact(a1)
                move.b  #0,angle(a1)
                move.w  #0,y_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bset    #Status_OnObj,status(a1)
                bset    d6,status(a0)
                bclr    #Status_InAir,status(a1)
                beq.s   S3Collision_ReturnFromPlatformLandingOrRejectedContact
                move.l  a0,-(sp)
                movea.l a1,a0
                jsr     (Player_TouchFloor).l
                movea.l (sp)+,a0

S3Collision_ReturnFromPlatformLandingOrRejectedContact:
                rts
; End of function RideObject_SetRide

; ---------------------------------------------------------------------------

SolidObjCheckSloped2:
                tst.w   y_vel(a1)
                bmi.w   S3Collision_ReturnFromPlatformLandingOrRejectedContact
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3Collision_ReturnFromPlatformLandingOrRejectedContact
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.s   S3Collision_ReturnFromPlatformLandingOrRejectedContact
                btst    #0,render_flags(a0)
                beq.s   S3Collision_SampleHalfResolutionSlopeForNewLanding
                not.w   d0
                add.w   d1,d0

S3Collision_SampleHalfResolutionSlopeForNewLanding:
                lsr.w   #1,d0
                move.b  (a2,d0.w),d3
                ext.w   d3
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                bra.w   S3Collision_TestPlatformLandingWindowAndSnapRider

; =============== S U B R O U T I N E =======================================

CheckPlayerReleaseFromObj:
                lea     (Player_1).w,a1
                btst    #p1_standing_bit,status(a0)
                beq.s   S3Collision_CheckSecondaryRiderForTerrainRelease
                jsr     (SonicOnObjHitFloor).l
                tst.w   d1
                beq.s   S3Collision_ReleasePrimaryRiderForNonpositiveTerrainGap
                bpl.s   S3Collision_CheckSecondaryRiderForTerrainRelease

S3Collision_ReleasePrimaryRiderForNonpositiveTerrainGap:
                lea     (Player_1).w,a1
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    #p1_standing_bit,status(a0)

S3Collision_CheckSecondaryRiderForTerrainRelease:
                lea     (Player_2).w,a1
                btst    #p2_standing_bit,status(a0)
                beq.s   S3Collision_ReturnAfterBothRiderReleaseChecks
                jsr     (SonicOnObjHitFloor).l
                tst.w   d1
                beq.s   S3Collision_ReleaseSecondaryRiderForNonpositiveTerrainGap
                bpl.s   S3Collision_ReturnAfterBothRiderReleaseChecks

S3Collision_ReleaseSecondaryRiderForNonpositiveTerrainGap:
                lea     (Player_2).w,a1
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    #p2_standing_bit,status(a0)

S3Collision_ReturnAfterBothRiderReleaseChecks:
                moveq   #0,d4
                rts
; End of function CheckPlayerReleaseFromObj
