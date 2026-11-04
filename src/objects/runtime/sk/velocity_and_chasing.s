; Owner: objects/runtime/sk
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
                dc.w    0, -$100
                dc.w    -$100, -$100
                dc.w    $100, -$100
                dc.w    -$200, -$100
                dc.w    $200, -$100
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    -$300, -$200
                dc.w    $300, -$200
                dc.w    -$300, -$300
                dc.w    $300, -$300
                dc.w    -$400, -$300
                dc.w    $400, -$300
                dc.w    -$200, -$300
                dc.w    $200, -$300

; =============== S U B R O U T I N E =======================================

Find_SonicTails8Way:
                bsr.w   Find_SonicTails                 ; This routine seems bugged slightly. Shouldn't the first two cmpi instructions look at d3 and not d2?
                cmp.w   d2,d3
                beq.s   SKRuntimeVelocity_ClassifyEqualWordDistancesByTargetSideFlags
                bhi.s   SKRuntimeVelocity_ComputeYDominantDistanceRatioAndChooseUpperSector
                swap    d3                              ; If Y distance is closer to object
                clr.w   d3
                divu.w  d2,d3
                tst.w   d0
                beq.s   SKRuntimeVelocity_ClassifyXDominantLeftTargetUsingRawXThreshold
                cmpi.w  #$8000,d2                       ; If Y was closer and Sonic is to right of object
                blo.s   SKRuntimeVelocity_ReturnEightWaySelectorTwo
                tst.w   d0
                beq.s   SKRuntimeVelocity_ReturnEightWaySelectorOne
                bra.w   SKRuntimeVelocity_ReturnEightWaySelectorThree
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ClassifyXDominantLeftTargetUsingRawXThreshold:
                cmpi.w  #$8000,d2                       ; If Y was closer and Sonic is to left of object
                blo.s   SKRuntimeVelocity_ReturnEightWaySelectorSix
                tst.w   d1
                bne.s   SKRuntimeVelocity_ReturnEightWaySelectorFive
                bra.w   SKRuntimeVelocity_ReturnEightWaySelectorSeven
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ComputeYDominantDistanceRatioAndChooseUpperSector:
                swap    d2                              ; If X distance is closer to object
                clr.w   d2
                divu.w  d3,d2
                tst.w   d1
                bne.s   SKRuntimeVelocity_ChooseLowerSectorFromYDominantRatio
                cmpi.w  #$8000,d2
                blo.s   SKRuntimeVelocity_ReturnEightWaySelectorZero
                tst.w   d0
                bne.s   SKRuntimeVelocity_ReturnEightWaySelectorOne
                bra.w   SKRuntimeVelocity_ReturnEightWaySelectorSeven
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ChooseLowerSectorFromYDominantRatio:
                cmpi.w  #$8000,d2
                blo.s   SKRuntimeVelocity_ReturnEightWaySelectorFour
                tst.w   d0
                bne.s   SKRuntimeVelocity_ReturnEightWaySelectorThree
                bra.w   SKRuntimeVelocity_ReturnEightWaySelectorFive
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ClassifyEqualWordDistancesByTargetSideFlags:
                tst.w   d0                              ; If X and Y distance are identical
                beq.s   SKRuntimeVelocity_ChooseLeftEqualDistanceSectorIncludingCoincidentTarget
                tst.w   d1
                beq.s   SKRuntimeVelocity_ReturnEightWaySelectorOne
                bra.w   SKRuntimeVelocity_ReturnEightWaySelectorThree
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ChooseLeftEqualDistanceSectorIncludingCoincidentTarget:
                tst.w   d1
                bne.s   SKRuntimeVelocity_ReturnEightWaySelectorFive
                bra.w   SKRuntimeVelocity_ReturnEightWaySelectorSeven
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ReturnEightWaySelectorZero:
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ReturnEightWaySelectorOne:
                moveq   #1,d4
                rts
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ReturnEightWaySelectorTwo:
                moveq   #2,d4
                rts
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ReturnEightWaySelectorThree:
                moveq   #3,d4
                rts
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ReturnEightWaySelectorFour:
                moveq   #4,d4
                rts
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ReturnEightWaySelectorFive:
                moveq   #5,d4
                rts
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ReturnEightWaySelectorSix:
                moveq   #6,d4
                rts
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ReturnEightWaySelectorSeven:
                moveq   #7,d4
                rts
; End of function Find_SonicTails8Way

; =============== S U B R O U T I N E =======================================

Set_VelocityXTrackSonic:
                lea     (Player_1).w,a1
                bsr.w   Find_OtherObject
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   SKRuntimeVelocity_CommitCallerSignedHorizontalSpeedWithPlayerSideFlip
                neg.w   d4
                bset    #0,render_flags(a0)

SKRuntimeVelocity_CommitCallerSignedHorizontalSpeedWithPlayerSideFlip:
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
                beq.s   SKRuntimeVelocity_CompareYAfterHorizontalChaseAndPreserveXEqualityByte
                bcs.s   SKRuntimeVelocity_AcceptOrRejectBothAxisChaseHorizontalCandidate
                neg.w   d1

SKRuntimeVelocity_AcceptOrRejectBothAxisChaseHorizontalCandidate:
                move.w  x_vel(a0),d4
                add.w   d1,d4
                cmp.w   d2,d4
                blt.s   SKRuntimeVelocity_CompareYAfterHorizontalChaseAndPreserveXEqualityByte
                cmp.w   d0,d4
                bgt.s   SKRuntimeVelocity_CompareYAfterHorizontalChaseAndPreserveXEqualityByte
                move.w  d4,x_vel(a0)

SKRuntimeVelocity_CompareYAfterHorizontalChaseAndPreserveXEqualityByte:
                move.w  y_pos(a0),d4
                cmp.w   y_pos(a1),d4
                beq.s   SKRuntimeVelocity_ClearBothChaseVelocitiesOnlyWhenBothIntegerAxesMatch
                bcs.s   SKRuntimeVelocity_AcceptOrRejectBothAxisChaseVerticalCandidate
                neg.w   d3

SKRuntimeVelocity_AcceptOrRejectBothAxisChaseVerticalCandidate:
                move.w  y_vel(a0),d4
                add.w   d3,d4
                cmp.w   d2,d4
                blt.s   SKRuntimeVelocity_ReturnBothAxisChaseWithoutUniformCompletionFlags
                cmp.w   d0,d4
                bgt.s   SKRuntimeVelocity_ReturnBothAxisChaseWithoutUniformCompletionFlags
                move.w  d4,y_vel(a0)

SKRuntimeVelocity_ReturnBothAxisChaseWithoutUniformCompletionFlags:
                rts
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ClearBothChaseVelocitiesOnlyWhenBothIntegerAxesMatch:
                tst.b   d5
                beq.s   SKRuntimeVelocity_ReturnBothAxisChaseWithoutUniformCompletionFlags
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
                bhs.s   SKRuntimeVelocity_AcceptOrRejectXOnlyOffsetChaseCandidate
                neg.w   d1

SKRuntimeVelocity_AcceptOrRejectXOnlyOffsetChaseCandidate:
                move.w  x_vel(a0),d3
                add.w   d1,d3
                cmp.w   d2,d3
                blt.s   SKRuntimeVelocity_ReturnXOnlyChaseWithNativeCandidateOrStoreFlags
                cmp.w   d0,d3
                bgt.s   SKRuntimeVelocity_ReturnXOnlyChaseWithNativeCandidateOrStoreFlags
                move.w  d3,x_vel(a0)

SKRuntimeVelocity_ReturnXOnlyChaseWithNativeCandidateOrStoreFlags:
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
                bhs.s   SKRuntimeVelocity_AcceptOrRejectYOnlyOffsetChaseCandidate
                neg.w   d1

SKRuntimeVelocity_AcceptOrRejectYOnlyOffsetChaseCandidate:
                move.w  y_vel(a0),d3
                add.w   d1,d3
                cmp.w   d2,d3
                blt.s   SKRuntimeVelocity_ReturnYOnlyChaseWithNativeCandidateOrStoreFlags
                cmp.w   d0,d3
                bgt.s   SKRuntimeVelocity_ReturnYOnlyChaseWithNativeCandidateOrStoreFlags
                move.w  d3,y_vel(a0)

SKRuntimeVelocity_ReturnYOnlyChaseWithNativeCandidateOrStoreFlags:
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
                beq.s   SKRuntimeVelocity_CompareOffsetTargetYAndCarrySavedXEqualityByte
                bcc.s   SKRuntimeVelocity_AcceptOrRejectOffsetBothAxisChaseXCandidate
                neg.w   d1

SKRuntimeVelocity_AcceptOrRejectOffsetBothAxisChaseXCandidate:
                move.w  x_vel(a0),d4
                add.w   d1,d4
                cmp.w   d2,d4
                blt.s   SKRuntimeVelocity_CompareOffsetTargetYAndCarrySavedXEqualityByte
                cmp.w   d0,d4
                bgt.s   SKRuntimeVelocity_CompareOffsetTargetYAndCarrySavedXEqualityByte
                move.w  d4,x_vel(a0)

SKRuntimeVelocity_CompareOffsetTargetYAndCarrySavedXEqualityByte:
                move.w  y_pos(a1),d6
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d6
                cmp.w   y_pos(a0),d6
                beq.s   SKRuntimeVelocity_ClearOffsetChaseVelocitiesOnlyWhenBothWordTargetsMatch
                bcc.s   SKRuntimeVelocity_AcceptOrRejectOffsetBothAxisChaseYCandidate
                neg.w   d3

SKRuntimeVelocity_AcceptOrRejectOffsetBothAxisChaseYCandidate:
                move.w  y_vel(a0),d4
                add.w   d3,d4
                cmp.w   d2,d4
                blt.s   SKRuntimeVelocity_ReturnOffsetBothAxisChaseWithNativeFlags
                cmp.w   d0,d4
                bgt.s   SKRuntimeVelocity_ReturnOffsetBothAxisChaseWithNativeFlags
                move.w  d4,y_vel(a0)

SKRuntimeVelocity_ReturnOffsetBothAxisChaseWithNativeFlags:
                rts
; ---------------------------------------------------------------------------

SKRuntimeVelocity_ClearOffsetChaseVelocitiesOnlyWhenBothWordTargetsMatch:
                tst.b   d5
                beq.s   SKRuntimeVelocity_ReturnOffsetBothAxisChaseWithNativeFlags
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
