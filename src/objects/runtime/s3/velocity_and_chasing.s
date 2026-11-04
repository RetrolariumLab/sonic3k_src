; Owner: objects/runtime/s3
; Responsibility: Indexed velocity, eight-way player targeting, tracking and object chase helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Set_IndexedVelocity:
                moveq   #0,d1
                move.b  subtype(a0),d1
                add.w   d1,d1
                add.w   d1,d0
                lea     Obj_VelocityIndex(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                btst    #0,render_flags(a0)
                beq.s   .noflip
                neg.w   x_vel(a0)

                .noflip:
                rts
; End of function Set_IndexedVelocity

; ---------------------------------------------------------------------------
Obj_VelocityIndex:
                dc.w    -$100, -$100
                dc.w    $100, -$100
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    -$300, -$200
                dc.w    $300, -$200
                dc.w    -$200, -$200
                dc.w    0, -$200
                dc.w    -$400, -$300
                dc.w    $400, -$300
                dc.w    $300, -$300
                dc.w    -$400, -$300
                dc.w    $400, -$300
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    0, -$100
                dc.w    -$40, -$700
                dc.w    -$80, -$700
                dc.w    -$180, -$700
                dc.w    -$100, -$700
                dc.w    -$200, -$700
                dc.w    -$280, -$700
                dc.w    -$300, -$700

; =============== S U B R O U T I N E =======================================

Find_SonicTails8Way:
                bsr.w   Find_SonicTails                 ; This routine seems bugged slightly. Shouldn't the first two cmpi instructions look at d3 and not d2?
                cmp.w   d2,d3
                beq.s   S3RuntimeVelocity_ClassifyEqualWordDistancesByTargetSideFlags
                bhi.s   S3RuntimeVelocity_ComputeYDominantDistanceRatioAndChooseUpperSector
                swap    d3                              ; If Y distance is closer to object
                clr.w   d3
                divu.w  d2,d3
                tst.w   d0
                beq.s   S3RuntimeVelocity_ClassifyXDominantLeftTargetUsingRawXThreshold
                cmpi.w  #$8000,d2                       ; If Y was closer and Sonic is to right of object
                blo.s   S3RuntimeVelocity_ReturnEightWaySelectorTwo
                tst.w   d0
                beq.s   S3RuntimeVelocity_ReturnEightWaySelectorOne
                bra.w   S3RuntimeVelocity_ReturnEightWaySelectorThree
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ClassifyXDominantLeftTargetUsingRawXThreshold:
                cmpi.w  #$8000,d2                       ; If Y was closer and Sonic is to left of object
                blo.s   S3RuntimeVelocity_ReturnEightWaySelectorSix
                tst.w   d1
                bne.s   S3RuntimeVelocity_ReturnEightWaySelectorFive
                bra.w   S3RuntimeVelocity_ReturnEightWaySelectorSeven
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ComputeYDominantDistanceRatioAndChooseUpperSector:
                swap    d2                              ; If X distance is closer to object
                clr.w   d2
                divu.w  d3,d2
                tst.w   d1
                bne.s   S3RuntimeVelocity_ChooseLowerSectorFromYDominantRatio
                cmpi.w  #$8000,d2
                blo.s   S3RuntimeVelocity_ReturnEightWaySelectorZero
                tst.w   d0
                bne.s   S3RuntimeVelocity_ReturnEightWaySelectorOne
                bra.w   S3RuntimeVelocity_ReturnEightWaySelectorSeven
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ChooseLowerSectorFromYDominantRatio:
                cmpi.w  #$8000,d2
                blo.s   S3RuntimeVelocity_ReturnEightWaySelectorFour
                tst.w   d0
                bne.s   S3RuntimeVelocity_ReturnEightWaySelectorThree
                bra.w   S3RuntimeVelocity_ReturnEightWaySelectorFive
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ClassifyEqualWordDistancesByTargetSideFlags:
                tst.w   d0                              ; If X and Y distance are identical
                beq.s   S3RuntimeVelocity_ChooseLeftEqualDistanceSectorIncludingCoincidentTarget
                tst.w   d1
                beq.s   S3RuntimeVelocity_ReturnEightWaySelectorOne
                bra.w   S3RuntimeVelocity_ReturnEightWaySelectorThree
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ChooseLeftEqualDistanceSectorIncludingCoincidentTarget:
                tst.w   d1
                bne.s   S3RuntimeVelocity_ReturnEightWaySelectorFive
                bra.w   S3RuntimeVelocity_ReturnEightWaySelectorSeven
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ReturnEightWaySelectorZero:
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ReturnEightWaySelectorOne:
                moveq   #1,d4
                rts
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ReturnEightWaySelectorTwo:
                moveq   #2,d4
                rts
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ReturnEightWaySelectorThree:
                moveq   #3,d4
                rts
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ReturnEightWaySelectorFour:
                moveq   #4,d4
                rts
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ReturnEightWaySelectorFive:
                moveq   #5,d4
                rts
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ReturnEightWaySelectorSix:
                moveq   #6,d4
                rts
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ReturnEightWaySelectorSeven:
                moveq   #7,d4
                rts
; End of function Find_SonicTails8Way

; =============== S U B R O U T I N E =======================================

Set_VelocityXTrackSonic:
                lea     (Player_1).w,a1
                bsr.w   Find_OtherObject
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   S3RuntimeVelocity_CommitCallerSignedHorizontalSpeedWithPlayerSideFlip
                neg.w   d4
                bset    #0,render_flags(a0)

S3RuntimeVelocity_CommitCallerSignedHorizontalSpeedWithPlayerSideFlip:
                move.w  d4,x_vel(a0)
                rts
; End of function Set_VelocityXTrackSonic

; =============== S U B R O U T I N E =======================================

Chase_Object:
                move.w  d0,d2                           ; d0 = Maximum speed
                neg.w   d2
                move.w  d1,d3                           ; d1 = acceleration
                move.w  x_pos(a0),d4
                cmp.w   x_pos(a1),d4
                seq     d5
                beq.s   S3RuntimeVelocity_CompareYAfterHorizontalChaseAndPreserveXEqualityByte
                bcs.s   S3RuntimeVelocity_AcceptOrRejectBothAxisChaseHorizontalCandidate
                neg.w   d1

S3RuntimeVelocity_AcceptOrRejectBothAxisChaseHorizontalCandidate:
                move.w  x_vel(a0),d4
                add.w   d1,d4
                cmp.w   d2,d4
                blt.s   S3RuntimeVelocity_CompareYAfterHorizontalChaseAndPreserveXEqualityByte
                cmp.w   d0,d4
                bgt.s   S3RuntimeVelocity_CompareYAfterHorizontalChaseAndPreserveXEqualityByte
                move.w  d4,x_vel(a0)

S3RuntimeVelocity_CompareYAfterHorizontalChaseAndPreserveXEqualityByte:
                move.w  y_pos(a0),d4
                cmp.w   y_pos(a1),d4
                beq.s   S3RuntimeVelocity_ClearBothChaseVelocitiesOnlyWhenBothIntegerAxesMatch
                bcs.s   S3RuntimeVelocity_AcceptOrRejectBothAxisChaseVerticalCandidate
                neg.w   d3

S3RuntimeVelocity_AcceptOrRejectBothAxisChaseVerticalCandidate:
                move.w  y_vel(a0),d4
                add.w   d3,d4
                cmp.w   d2,d4
                blt.s   S3RuntimeVelocity_ReturnBothAxisChaseWithoutUniformCompletionFlags
                cmp.w   d0,d4
                bgt.s   S3RuntimeVelocity_ReturnBothAxisChaseWithoutUniformCompletionFlags
                move.w  d4,y_vel(a0)

S3RuntimeVelocity_ReturnBothAxisChaseWithoutUniformCompletionFlags:
                rts
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ClearBothChaseVelocitiesOnlyWhenBothIntegerAxesMatch:
                tst.b   d5
                beq.s   S3RuntimeVelocity_ReturnBothAxisChaseWithoutUniformCompletionFlags
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
; End of function Chase_Object

; =============== S U B R O U T I N E =======================================

Chase_ObjectXOnly:
                move.w  d0,d2
                neg.w   d2
                move.w  x_pos(a1),d3
                move.b  child_dx(a0),d4
                ext.w   d4
                add.w   d4,d3
                cmp.w   x_pos(a0),d3
                bhs.s   S3RuntimeVelocity_AcceptOrRejectXOnlyOffsetChaseCandidate
                neg.w   d1

S3RuntimeVelocity_AcceptOrRejectXOnlyOffsetChaseCandidate:
                move.w  x_vel(a0),d3
                add.w   d1,d3
                cmp.w   d2,d3
                blt.s   S3RuntimeVelocity_ReturnXOnlyChaseWithNativeCandidateOrStoreFlags
                cmp.w   d0,d3
                bgt.s   S3RuntimeVelocity_ReturnXOnlyChaseWithNativeCandidateOrStoreFlags
                move.w  d3,x_vel(a0)

S3RuntimeVelocity_ReturnXOnlyChaseWithNativeCandidateOrStoreFlags:
                rts
; End of function Chase_ObjectXOnly

; =============== S U B R O U T I N E =======================================

Chase_ObjectYOnly:
                move.w  d0,d2
                neg.w   d2
                move.w  y_pos(a1),d3
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d3
                cmp.w   y_pos(a0),d3
                bhs.s   S3RuntimeVelocity_AcceptOrRejectYOnlyOffsetChaseCandidate
                neg.w   d1

S3RuntimeVelocity_AcceptOrRejectYOnlyOffsetChaseCandidate:
                move.w  y_vel(a0),d3
                add.w   d1,d3
                cmp.w   d2,d3
                blt.s   S3RuntimeVelocity_ReturnYOnlyChaseWithNativeCandidateOrStoreFlags
                cmp.w   d0,d3
                bgt.s   S3RuntimeVelocity_ReturnYOnlyChaseWithNativeCandidateOrStoreFlags
                move.w  d3,y_vel(a0)

S3RuntimeVelocity_ReturnYOnlyChaseWithNativeCandidateOrStoreFlags:
                rts
; End of function Chase_ObjectYOnly

; ---------------------------------------------------------------------------
                move.w  d0,d2                           ; Unused, seems to be a combination of the above two routines, but additionally using offsets
                neg.w   d2
                move.w  d1,d3
                move.w  x_pos(a1),d6
                move.b  child_dx(a0),d4
                ext.w   d4
                add.w   d4,d6
                cmp.w   x_pos(a0),d6
                seq     d5
                beq.s   S3RuntimeVelocity_CompareOffsetTargetYAndCarrySavedXEqualityByte
                bcc.s   S3RuntimeVelocity_AcceptOrRejectOffsetBothAxisChaseXCandidate
                neg.w   d1

S3RuntimeVelocity_AcceptOrRejectOffsetBothAxisChaseXCandidate:
                move.w  x_vel(a0),d4
                add.w   d1,d4
                cmp.w   d2,d4
                blt.s   S3RuntimeVelocity_CompareOffsetTargetYAndCarrySavedXEqualityByte
                cmp.w   d0,d4
                bgt.s   S3RuntimeVelocity_CompareOffsetTargetYAndCarrySavedXEqualityByte
                move.w  d4,x_vel(a0)

S3RuntimeVelocity_CompareOffsetTargetYAndCarrySavedXEqualityByte:
                move.w  y_pos(a1),d6
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d6
                cmp.w   y_pos(a0),d6
                beq.s   S3RuntimeVelocity_ClearOffsetChaseVelocitiesOnlyWhenBothWordTargetsMatch
                bcc.s   S3RuntimeVelocity_AcceptOrRejectOffsetBothAxisChaseYCandidate
                neg.w   d3

S3RuntimeVelocity_AcceptOrRejectOffsetBothAxisChaseYCandidate:
                move.w  y_vel(a0),d4
                add.w   d3,d4
                cmp.w   d2,d4
                blt.s   S3RuntimeVelocity_ReturnOffsetBothAxisChaseWithNativeFlags
                cmp.w   d0,d4
                bgt.s   S3RuntimeVelocity_ReturnOffsetBothAxisChaseWithNativeFlags
                move.w  d4,y_vel(a0)

S3RuntimeVelocity_ReturnOffsetBothAxisChaseWithNativeFlags:
                rts
; ---------------------------------------------------------------------------

S3RuntimeVelocity_ClearOffsetChaseVelocitiesOnlyWhenBothWordTargetsMatch:
                tst.b   d5
                beq.s   S3RuntimeVelocity_ReturnOffsetBothAxisChaseWithNativeFlags
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
