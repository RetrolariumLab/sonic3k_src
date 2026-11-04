; Owner: objects/runtime/sk
; Responsibility: Placed-object streaming, free-slot allocation and level object and ring memory reset
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Load_Sprites:
                moveq   #0,d0
                move.b  (Object_load_routine).w,d0
                jmp     Load_Sprites_Index(pc,d0.w)
; End of function Load_Sprites

; ---------------------------------------------------------------------------

Load_Sprites_Index:
                bra.w   SKRuntimeSpawning_ChooseNativeObjectIndexByUnsignedZoneBands
; ---------------------------------------------------------------------------
                bra.w   SKRuntimeSpawning_PublishCameraBackBoundaryAndSelectVerticalWindowDecoder
; ---------------------------------------------------------------------------
                bra.w   SKRuntimeSpawning_PublishCameraBackBoundaryAndSelectVerticalWindowDecoder
; ---------------------------------------------------------------------------
                rts
; ---------------------------------------------------------------------------

SKRuntimeSpawning_ChooseNativeObjectIndexByUnsignedZoneBands:
                move.l  #Sprite_ListingK,d0
                move.b  (Current_zone).w,d1
                cmpi.b  #$16,d1
                bhs.s   SKRuntimeSpawning_EnterStreamingInitializationAndGateRespawnClear
                cmpi.b  #$E,d1
                bhs.s   SKRuntimeSpawning_SelectSonicThreeObjectIndexForEarlyOrCompetitionBonusBands
                cmpi.b  #7,d1
                bhs.s   SKRuntimeSpawning_EnterStreamingInitializationAndGateRespawnClear

SKRuntimeSpawning_SelectSonicThreeObjectIndexForEarlyOrCompetitionBonusBands:
                move.l  #Sprite_Listing3,d0

SKRuntimeSpawning_EnterStreamingInitializationAndGateRespawnClear:
                move.l  d0,(Object_index_addr).w
                addq.b  #4,(Object_load_routine).w
                tst.b   (Respawn_table_keep).w
                bne.s   SKRuntimeSpawning_SelectZoneActLayoutAndChoosePreloadOrStreaming
                lea     (Object_respawn_table).w,a0
                moveq   #0,d0
                move.w  #bytesToLcnt($300),d1

SKRuntimeSpawning_ClearMainRespawnTableByLongword:
                move.l  d0,(a0)+
                dbf     d1,SKRuntimeSpawning_ClearMainRespawnTableByLongword

SKRuntimeSpawning_SelectZoneActLayoutAndChoosePreloadOrStreaming:
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #5,d0
                lea     (SpriteLocPtrs).l,a0
                movea.l (a0,d0.w),a0
                cmpi.w  #$1701,(Current_zone_and_act).w
                beq.s   SKRuntimeSpawning_EnterOnePassPreloadAndAllocateInitialCandidate
                cmpi.b  #$16,(Current_zone).w
                bhs.s   SKRuntimeSpawning_InitializeLayoutCursorPairAndRespawnBase
                cmpi.b  #$14,(Current_zone).w
                beq.s   SKRuntimeSpawning_InitializeLayoutCursorPairAndRespawnBase
                cmpi.b  #$13,(Current_zone).w
                bhs.s   SKRuntimeSpawning_EnterOnePassPreloadAndAllocateInitialCandidate
                tst.w   (Competition_mode).w
                beq.s   SKRuntimeSpawning_InitializeLayoutCursorPairAndRespawnBase

SKRuntimeSpawning_EnterOnePassPreloadAndAllocateInitialCandidate:
                addq.b  #8,(Object_load_routine).w
                jsr     AllocateObject(pc)
                bne.s   SKRuntimeSpawning_FinishOnePassPreloadWithCoarseBackInitialization
                lea     (_unkF712).w,a3
                movea.l (Object_index_addr).w,a4
                move.w  #$800,d6
                cmpi.w  #$1701,(Current_zone_and_act).w
                bne.s   SKRuntimeSpawning_PreloadSixByteRecordsUntilUnsignedXThresholdOrNextSlotFailure
                move.w  #$1780,d6

SKRuntimeSpawning_PreloadSixByteRecordsUntilUnsignedXThresholdOrNextSlotFailure:
                cmp.w   (a0),d6
                bls.s   SKRuntimeSpawning_FinishOnePassPreloadWithCoarseBackInitialization
                jsr     CreateObjectFromLayoutRecord(pc)
                beq.s   SKRuntimeSpawning_PreloadSixByteRecordsUntilUnsignedXThresholdOrNextSlotFailure

SKRuntimeSpawning_FinishOnePassPreloadWithCoarseBackInitialization:
                clr.w   (Camera_X_pos_coarse_back).w
                cmpi.w  #$1701,(Current_zone_and_act).w
                bne.s   SKRuntimeSpawning_ReturnFromPreloadAfterOptionalHpzMiniCoarseBackFix
                move.w  (Camera_X_pos).w,d1
                subi.w  #$80,d1
                andi.w  #$FF80,d1
                move.w  d1,(Camera_X_pos_coarse_back).w

SKRuntimeSpawning_ReturnFromPreloadAfterOptionalHpzMiniCoarseBackFix:
                rts
; ---------------------------------------------------------------------------

SKRuntimeSpawning_InitializeLayoutCursorPairAndRespawnBase:
                move.l  a0,(Object_load_addr_front).w
                move.l  a0,(Object_load_addr_back).w
                lea     (Object_respawn_table).w,a3
                cmpi.b  #$14,(Current_zone).w
                bne.s   SKRuntimeSpawning_ComputeInitialFrontBoundaryWithUnsignedBorrowClamp
                lea     (Object_respawn_table_2).w,a3
                moveq   #bytesToLcnt($200),d6

SKRuntimeSpawning_ClearAlternatePachinkoRespawnTableByLongword:
                clr.l   (a3)+
                dbf     d6,SKRuntimeSpawning_ClearAlternatePachinkoRespawnTableByLongword
                lea     (Object_respawn_table_2).w,a3

SKRuntimeSpawning_ComputeInitialFrontBoundaryWithUnsignedBorrowClamp:
                move.w  (Camera_X_pos).w,d6
                subi.w  #$80,d6
                bcc.s   SKRuntimeSpawning_AlignFrontSeekBoundaryToOneHundredTwentyEightPixels
                moveq   #0,d6

SKRuntimeSpawning_AlignFrontSeekBoundaryToOneHundredTwentyEightPixels:
                andi.w  #$FF80,d6
                movea.l (Object_load_addr_front).w,a0

SKRuntimeSpawning_SeekInitialFrontCursorWhileRecordXBelowBoundary:
                cmp.w   (a0),d6
                bls.s   SKRuntimeSpawning_CommitInitialFrontCursorAndPrepareBackSeek
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   SKRuntimeSpawning_SeekInitialFrontCursorWhileRecordXBelowBoundary
; ---------------------------------------------------------------------------

SKRuntimeSpawning_CommitInitialFrontCursorAndPrepareBackSeek:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                lea     (Object_respawn_table).w,a3
                cmpi.b  #$14,(Current_zone).w
                bne.s   SKRuntimeSpawning_PrepareBackSeekFromSelectedRespawnBase
                lea     (Object_respawn_table_2).w,a3

SKRuntimeSpawning_PrepareBackSeekFromSelectedRespawnBase:
                movea.l (Object_load_addr_back).w,a0
                subi.w  #$80,d6
                bcs.s   SKRuntimeSpawning_CommitInitialBackCursorForceFirstXRefreshAndSeedCoarseY

SKRuntimeSpawning_SeekInitialBackCursorWhileRecordXBelowBoundary:
                cmp.w   (a0),d6
                bls.s   SKRuntimeSpawning_CommitInitialBackCursorForceFirstXRefreshAndSeedCoarseY
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   SKRuntimeSpawning_SeekInitialBackCursorWhileRecordXBelowBoundary
; ---------------------------------------------------------------------------

SKRuntimeSpawning_CommitInitialBackCursorForceFirstXRefreshAndSeedCoarseY:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w
                move.w  #-1,(Camera_X_pos_coarse).w
                move.w  (Camera_Y_pos).w,d0
                andi.w  #$FF80,d0
                move.w  d0,(Camera_Y_pos_coarse).w

SKRuntimeSpawning_PublishCameraBackBoundaryAndSelectVerticalWindowDecoder:
                move.w  (Camera_Y_pos).w,d1
                subi.w  #$80,d1
                andi.w  #$FF80,d1
                move.w  d1,(Camera_Y_pos_coarse_back).w
                move.w  (Camera_X_pos).w,d1
                subi.w  #$80,d1
                andi.w  #$FF80,d1
                move.w  d1,(Camera_X_pos_coarse_back).w
                movea.l (Object_index_addr).w,a4
                tst.w   (Camera_min_Y_pos).w
                bpl.s   SKRuntimeSpawning_BuildNonwrappingVerticalWindowAndClampNegativeLowerEdge
                lea     SKRuntimeSpawning_SkipLoadedRecordOrEnterWrappedUnionYFilter(pc),a6
                move.w  (Camera_Y_pos).w,d3
                andi.w  #$FF80,d3
                move.w  d3,d4
                addi.w  #$200,d4
                subi.w  #$80,d3
                bpl.s   SKRuntimeSpawning_DetectBottomOverflowOfWrappedVerticalWindow
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   SKRuntimeSpawning_ChooseHorizontalStreamDirectionFromSignedCoarseXChange
; ---------------------------------------------------------------------------

SKRuntimeSpawning_DetectBottomOverflowOfWrappedVerticalWindow:
                move.w  (Screen_Y_wrap_value).w,d0
                addq.w  #1,d0
                cmp.w   d0,d4
                bls.s   SKRuntimeSpawning_SelectLinearVerticalRecordDecoder
                and.w   (Screen_Y_wrap_value).w,d4
                bra.s   SKRuntimeSpawning_ChooseHorizontalStreamDirectionFromSignedCoarseXChange
; ---------------------------------------------------------------------------

SKRuntimeSpawning_BuildNonwrappingVerticalWindowAndClampNegativeLowerEdge:
                move.w  (Camera_Y_pos).w,d3
                andi.w  #$FF80,d3
                move.w  d3,d4
                addi.w  #$200,d4
                subi.w  #$80,d3
                bpl.s   SKRuntimeSpawning_SelectLinearVerticalRecordDecoder
                moveq   #0,d3

SKRuntimeSpawning_SelectLinearVerticalRecordDecoder:
                lea     SKRuntimeSpawning_SkipLoadedRecordOrEnterLinearYFilter(pc),a6

SKRuntimeSpawning_ChooseHorizontalStreamDirectionFromSignedCoarseXChange:
                move.w  #$FFF,d5
                move.w  (Camera_X_pos).w,d6
                andi.w  #$FF80,d6
                cmp.w   (Camera_X_pos_coarse).w,d6
                beq.w   SKRuntimeSpawning_ChooseNewVerticalRowFromSignedCoarseYChange
                bge.s   SKRuntimeSpawning_CommitRightCoarseXAndAllocateEnteringFrontCandidate
                move.w  d6,(Camera_X_pos_coarse).w
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                subi.w  #$80,d6
                bcs.s   SKRuntimeSpawning_CommitLeftBackCursorAndPrepareFrontRetraction
                jsr     AllocateObject(pc)
                bne.s   SKRuntimeSpawning_CommitLeftBackCursorAndPrepareFrontRetraction

SKRuntimeSpawning_LoadPreviousRecordsForLeftwardWindowExpansion:
                cmp.w   -6(a0),d6
                bge.s   SKRuntimeSpawning_CommitLeftBackCursorAndPrepareFrontRetraction
                subq.w  #6,a0
                subq.w  #1,a3
                jsr     (a6)
                bne.s   SKRuntimeSpawning_AdvanceLeftFailureCursorBeyondAlreadyConsumedRecord
                subq.w  #6,a0
                bra.s   SKRuntimeSpawning_LoadPreviousRecordsForLeftwardWindowExpansion
; ---------------------------------------------------------------------------

SKRuntimeSpawning_AdvanceLeftFailureCursorBeyondAlreadyConsumedRecord:
                addq.w  #6,a0
                addq.w  #1,a3

SKRuntimeSpawning_CommitLeftBackCursorAndPrepareFrontRetraction:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w
                movea.l (Object_load_addr_front).w,a0
                movea.w (Object_respawn_index_front).w,a3
                addi.w  #$300,d6

SKRuntimeSpawning_RetractFrontCursorWhilePreviousXAtOrBeyondRightBoundary:
                cmp.w   -6(a0),d6
                bgt.s   SKRuntimeSpawning_CommitRetractedFrontCursorAndContinueVerticalScan
                subq.w  #6,a0
                subq.w  #1,a3
                bra.s   SKRuntimeSpawning_RetractFrontCursorWhilePreviousXAtOrBeyondRightBoundary
; ---------------------------------------------------------------------------

SKRuntimeSpawning_CommitRetractedFrontCursorAndContinueVerticalScan:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                bra.s   SKRuntimeSpawning_ChooseNewVerticalRowFromSignedCoarseYChange
; ---------------------------------------------------------------------------

SKRuntimeSpawning_CommitRightCoarseXAndAllocateEnteringFrontCandidate:
                move.w  d6,(Camera_X_pos_coarse).w
                movea.l (Object_load_addr_front).w,a0
                movea.w (Object_respawn_index_front).w,a3
                addi.w  #$280,d6
                jsr     AllocateObject(pc)
                bne.s   SKRuntimeSpawning_CommitRightFrontCursorAndPrepareBackAdvance

SKRuntimeSpawning_LoadForwardRecordsBelowExclusiveRightBoundary:
                cmp.w   (a0),d6
                bls.s   SKRuntimeSpawning_CommitRightFrontCursorAndPrepareBackAdvance
                jsr     (a6)
                addq.w  #1,a3
                beq.s   SKRuntimeSpawning_LoadForwardRecordsBelowExclusiveRightBoundary

SKRuntimeSpawning_CommitRightFrontCursorAndPrepareBackAdvance:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                subi.w  #$300,d6
                bcs.s   SKRuntimeSpawning_CommitAdvancedBackCursor

SKRuntimeSpawning_AdvanceBackCursorPastRecordsBelowUnsignedLeftBoundary:
                cmp.w   (a0),d6
                bls.s   SKRuntimeSpawning_CommitAdvancedBackCursor
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   SKRuntimeSpawning_AdvanceBackCursorPastRecordsBelowUnsignedLeftBoundary
; ---------------------------------------------------------------------------

SKRuntimeSpawning_CommitAdvancedBackCursor:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w

SKRuntimeSpawning_ChooseNewVerticalRowFromSignedCoarseYChange:
                move.w  (Camera_Y_pos).w,d6
                andi.w  #$FF80,d6
                move.w  d6,d3
                cmp.w   (Camera_Y_pos_coarse).w,d6
                beq.w   SKRuntimeSpawning_CommitCoarseYAfterScanSkipOrAllocationFailure
                bge.s   SKRuntimeSpawning_ChooseLowerEnteringRowOrWrapSeamUpperRow
                tst.w   (Camera_min_Y_pos).w
                bpl.s   SKRuntimeSpawning_RejectNegativeUpperRowWhenVerticalWrappingDisabled
                tst.w   d6
                bne.s   SKRuntimeSpawning_SelectUpperEnteringRowWithConditionalWrapMask
                cmpi.w  #$80,(Camera_Y_pos_coarse).w
                bne.s   SKRuntimeSpawning_SelectLowerEnteringRowAndMaskAtOrBeyondWrapLimit

SKRuntimeSpawning_SelectUpperEnteringRowWithConditionalWrapMask:
                subi.w  #$80,d3
                bpl.s   SKRuntimeSpawning_AllocateVerticalRowCandidateAndBoundCurrentLayoutSpan
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   SKRuntimeSpawning_AllocateVerticalRowCandidateAndBoundCurrentLayoutSpan
; ---------------------------------------------------------------------------

SKRuntimeSpawning_RejectNegativeUpperRowWhenVerticalWrappingDisabled:
                subi.w  #$80,d3
                bmi.w   SKRuntimeSpawning_CommitCoarseYAfterScanSkipOrAllocationFailure
                bra.s   SKRuntimeSpawning_AllocateVerticalRowCandidateAndBoundCurrentLayoutSpan
; ---------------------------------------------------------------------------

SKRuntimeSpawning_ChooseLowerEnteringRowOrWrapSeamUpperRow:
                tst.w   (Camera_min_Y_pos).w
                bpl.s   SKRuntimeSpawning_SkipNonwrappingLowerRowOnlyWhenBeyondWrapLimit
                tst.w   (Camera_Y_pos_coarse).w
                bne.s   SKRuntimeSpawning_SelectLowerEnteringRowAndMaskAtOrBeyondWrapLimit
                cmpi.w  #$80,d6
                bne.s   SKRuntimeSpawning_SelectUpperEnteringRowWithConditionalWrapMask

SKRuntimeSpawning_SelectLowerEnteringRowAndMaskAtOrBeyondWrapLimit:
                addi.w  #$180,d3
                cmp.w   (Screen_Y_wrap_value).w,d3
                blo.s   SKRuntimeSpawning_AllocateVerticalRowCandidateAndBoundCurrentLayoutSpan
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   SKRuntimeSpawning_AllocateVerticalRowCandidateAndBoundCurrentLayoutSpan
; ---------------------------------------------------------------------------

SKRuntimeSpawning_SkipNonwrappingLowerRowOnlyWhenBeyondWrapLimit:
                addi.w  #$180,d3
                cmp.w   (Screen_Y_wrap_value).w,d3
                bhi.s   SKRuntimeSpawning_CommitCoarseYAfterScanSkipOrAllocationFailure

SKRuntimeSpawning_AllocateVerticalRowCandidateAndBoundCurrentLayoutSpan:
                jsr     AllocateObject(pc)
                bne.s   SKRuntimeSpawning_CommitCoarseYAfterScanSkipOrAllocationFailure
                move.w  d3,d4
                addi.w  #$80,d4
                move.w  #$FFF,d5
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                move.l  (Object_load_addr_front).w,d7
                sub.l   a0,d7
                beq.s   SKRuntimeSpawning_CommitCoarseYAfterScanSkipOrAllocationFailure
                addq.w  #2,a0

SKRuntimeSpawning_CreateUnloadedRecordsInsideInclusiveVerticalRow:
                tst.b   (a3)
                bmi.s   SKRuntimeSpawning_AdvanceSixByteVerticalSpanAndWordRemainingCount
                move.w  (a0),d1
                and.w   d5,d1
                cmp.w   d3,d1
                blo.s   SKRuntimeSpawning_AdvanceSixByteVerticalSpanAndWordRemainingCount
                cmp.w   d4,d1
                bhi.s   SKRuntimeSpawning_AdvanceSixByteVerticalSpanAndWordRemainingCount
                bset    #7,(a3)
                move.w  -2(a0),x_pos(a1)
                move.w  (a0),d1
                move.w  d1,d2
                and.w   d5,d1
                move.w  d1,y_pos(a1)
                rol.w   #3,d2
                andi.w  #3,d2
                move.b  d2,render_flags(a1)
                move.b  d2,status(a1)
                move.b  2(a0),d2
                add.w   d2,d2
                add.w   d2,d2
                move.l  (a4,d2.w),(a1)
                move.b  3(a0),subtype(a1)
                move.w  a3,respawn_addr(a1)
                jsr     CreateNewSprite4(pc)
                bne.s   SKRuntimeSpawning_CommitCoarseYAfterScanSkipOrAllocationFailure

SKRuntimeSpawning_AdvanceSixByteVerticalSpanAndWordRemainingCount:
                addq.w  #6,a0
                addq.w  #1,a3
                subq.w  #6,d7
                bne.s   SKRuntimeSpawning_CreateUnloadedRecordsInsideInclusiveVerticalRow

SKRuntimeSpawning_CommitCoarseYAfterScanSkipOrAllocationFailure:
                move.w  d6,(Camera_Y_pos_coarse).w
                rts
; ---------------------------------------------------------------------------
; unused
                bset    #7,(a3)
                beq.s   CreateObjectFromLayoutRecord
                addq.w  #6,a0
                moveq   #0,d1
                rts

; =============== S U B R O U T I N E =======================================

CreateObjectFromLayoutRecord:
                move.w  (a0)+,x_pos(a1)
                move.w  (a0)+,d1
                move.w  d1,d2
                andi.w  #$FFF,d1
                move.w  d1,y_pos(a1)
                rol.w   #3,d2
                andi.w  #3,d2
                move.b  d2,render_flags(a1)
                move.b  d2,status(a1)
                move.b  (a0)+,d2
                add.w   d2,d2
                add.w   d2,d2
                move.l  (a4,d2.w),(a1)
                move.b  (a0)+,subtype(a1)
                move.w  a3,respawn_addr(a1)
                bra.w   CreateNewSprite4
; ---------------------------------------------------------------------------

SKRuntimeSpawning_SkipLoadedRecordOrEnterWrappedUnionYFilter:
                tst.b   (a3)
                bpl.s   SKRuntimeSpawning_ReadRecordXYAndApplyWrappedUnionWindow
                addq.w  #6,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

SKRuntimeSpawning_ReadRecordXYAndApplyWrappedUnionWindow:
                move.w  (a0)+,d7
                move.w  (a0)+,d1
                move.w  d1,d2
                bmi.s   SKRuntimeSpawning_MaskForcedWrappedRecordYBeforeCreation
                and.w   d5,d1
                cmp.w   d3,d1
                bhs.s   SKRuntimeSpawning_CommitWrappedRecordAndSearchFollowingCandidate
                cmp.w   d4,d1
                bls.s   SKRuntimeSpawning_CommitWrappedRecordAndSearchFollowingCandidate
                addq.w  #2,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

SKRuntimeSpawning_MaskForcedWrappedRecordYBeforeCreation:
                and.w   d5,d1

SKRuntimeSpawning_CommitWrappedRecordAndSearchFollowingCandidate:
                bset    #7,(a3)
                move.w  d7,x_pos(a1)
                move.w  d1,y_pos(a1)
                rol.w   #3,d2
                andi.w  #3,d2
                move.b  d2,render_flags(a1)
                move.b  d2,status(a1)
                move.b  (a0)+,d2
                add.w   d2,d2
                add.w   d2,d2
                move.l  (a4,d2.w),(a1)
                move.b  (a0)+,subtype(a1)
                move.w  a3,respawn_addr(a1)
                bra.s   CreateNewSprite4
; ---------------------------------------------------------------------------

SKRuntimeSpawning_SkipLoadedRecordOrEnterLinearYFilter:
                tst.b   (a3)
                bpl.s   SKRuntimeSpawning_ReadRecordXYAndApplyInclusiveLinearWindow
                addq.w  #6,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

SKRuntimeSpawning_ReadRecordXYAndApplyInclusiveLinearWindow:
                move.w  (a0)+,d7
                move.w  (a0)+,d1
                move.w  d1,d2
                bmi.s   SKRuntimeSpawning_MaskForcedLinearRecordYBeforeCreation
                and.w   d5,d1
                cmp.w   d3,d1
                blo.s   SKRuntimeSpawning_SkipRemainingRecordIdAndSubtypeWithSuccessFlags
                cmp.w   d4,d1
                bls.s   SKRuntimeSpawning_CommitLinearRecordAndFallIntoNextCandidateSearch

SKRuntimeSpawning_SkipRemainingRecordIdAndSubtypeWithSuccessFlags:
                addq.w  #2,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

SKRuntimeSpawning_MaskForcedLinearRecordYBeforeCreation:
                and.w   d5,d1

SKRuntimeSpawning_CommitLinearRecordAndFallIntoNextCandidateSearch:
                bset    #7,(a3)
                move.w  d7,x_pos(a1)
                move.w  d1,y_pos(a1)
                rol.w   #3,d2
                andi.w  #3,d2
                move.b  d2,render_flags(a1)
                move.b  d2,status(a1)
                move.b  (a0)+,d2
                add.w   d2,d2
                add.w   d2,d2
                move.l  (a4,d2.w),(a1)
                move.b  (a0)+,subtype(a1)
                move.w  a3,respawn_addr(a1)

CreateNewSprite4:
                subq.w  #1,d0
                bmi.s   SKRuntimeSpawning_ReturnFromNextCandidateSearchWithNativeCounterAndCcr

SKRuntimeSpawning_ScanFollowingObjectSlotsUsingRemainingCounterAndCodeZero:
                lea     next_object(a1),a1
                tst.l   (a1)
                dbeq    d0,SKRuntimeSpawning_ScanFollowingObjectSlotsUsingRemainingCounterAndCodeZero

SKRuntimeSpawning_ReturnFromNextCandidateSearchWithNativeCounterAndCcr:
                rts
; End of function CreateObjectFromLayoutRecord

; =============== S U B R O U T I N E =======================================

; Create_New_Sprite:
AllocateObject:
                lea     (Dynamic_object_RAM).w,a1
                moveq   #((Dynamic_object_RAM_end-Dynamic_object_RAM)/object_size)-1,d0
                bra.s   AllocateObjectAfterCurrent.loop
; ---------------------------------------------------------------------------
; Create_New_Sprite3:
AllocateObjectAfterCurrent:
                movea.l a0,a1
                move.w  #Dynamic_object_RAM_end,d0
                sub.w   a0,d0
                lsr.w   #6,d0                           ; Divide by $40... even though SSTs are $4A bytes long in this game
                move.b  .lookup(pc,d0.w),d0             ; Use a look-up table to get the right loop counter
                bmi.s   .return

                .loop:
                lea     next_object(a1),a1
                tst.l   (a1)
                dbeq    d0,.loop

                .return:
                rts

                .lookup:
                .a:     set Dynamic_object_RAM
                .b:     set Dynamic_object_RAM_end
                .c:     set .b                          ; begin from bottom of array and decrease backwards
; There's a mistake here: this division should be rounded up,
; otherwise the first object slot might not get an entry
                rept    (.b-.a)/$40                     ; repeat for all slots, minus exception
                .c:     set .c-$40                      ; address for previous $40 (also skip last part)
                dc.b    (.b-.c-1)/object_size-1         ; write possible slots according to object_size division + hack + dbf hack
                endm
                even
; End of function AllocateObject

; ---------------------------------------------------------------------------

Clear_SpriteRingMem:
                lea     (Dynamic_object_RAM).w,a1
                moveq   #((Dynamic_object_RAM_end-Dynamic_object_RAM)/object_size)-1,d1

SKRuntimeSpawning_ClearRespawnBitForActiveActorWithNonzeroWordPointer:
                lea     next_object(a1),a1
                tst.l   (a1)
                beq.s   SKRuntimeSpawning_ContinueActorFlagResetThenReadActiveRingConsumptionCount
                move.w  respawn_addr(a1),d0
                beq.s   SKRuntimeSpawning_ContinueActorFlagResetThenReadActiveRingConsumptionCount
                movea.w d0,a2
                bclr    #7,(a2)

SKRuntimeSpawning_ContinueActorFlagResetThenReadActiveRingConsumptionCount:
                dbf     d1,SKRuntimeSpawning_ClearRespawnBitForActiveActorWithNonzeroWordPointer
                lea     (Ring_consumption_table).w,a2
                move.w  (a2)+,d1
                subq.w  #1,d1
                bcs.s   SKRuntimeSpawning_ReturnAfterRespawnFlagAndActiveRingFinalization

SKRuntimeSpawning_FinalizeNonzeroRingStatusPointersAndClearTheirQueueEntries:
                move.w  (a2)+,d0
                beq.s   SKRuntimeSpawning_FinalizeNonzeroRingStatusPointersAndClearTheirQueueEntries
                movea.w d0,a1
                move.w  #-1,(a1)
                clr.w   -2(a2)
                subq.w  #1,(Ring_consumption_table).w
                dbf     d1,SKRuntimeSpawning_FinalizeNonzeroRingStatusPointersAndClearTheirQueueEntries

SKRuntimeSpawning_ReturnAfterRespawnFlagAndActiveRingFinalization:
                rts
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================
; Changes the coarse back- and forward-camera edges to match new Camera_X value
; Also seeks to appropriate object locations in the level's object layout, so
; that Load_Sprites will correctly load the objects again

Seek_Object_Manager:
                move.w  (Camera_X_pos).w,d6
                addi.w  #$400,d6
                andi.w  #$FF80,d6
                cmp.w   (Camera_X_pos_coarse).w,d6
                beq.w   SKRuntimeSpawning_ReturnFromUnchangedOrCompletedCursorOnlyRebase
                bge.s   SKRuntimeSpawning_CommitRightRebaseCoarseXAndPrepareFrontAdvance
                move.w  d6,(Camera_X_pos_coarse).w
                movea.l (Object_load_addr_back).w,a1
                movea.w (Object_respawn_index_back).w,a3
                subi.w  #$80,d6
                bcs.s   SKRuntimeSpawning_CommitRebasedBackCursorAndPrepareFrontRetraction

SKRuntimeSpawning_SeekPreviousBackRecordsForRebasedCameraWithoutSpawning:
                cmp.w   -6(a1),d6
                bge.s   SKRuntimeSpawning_CommitRebasedBackCursorAndPrepareFrontRetraction
                subq.w  #6,a1
                subq.w  #1,a3
                bra.s   SKRuntimeSpawning_SeekPreviousBackRecordsForRebasedCameraWithoutSpawning
; ---------------------------------------------------------------------------

SKRuntimeSpawning_CommitRebasedBackCursorAndPrepareFrontRetraction:
                move.l  a1,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w
                movea.l (Object_load_addr_front).w,a1
                movea.w (Object_respawn_index_front).w,a3
                addi.w  #$300,d6

SKRuntimeSpawning_RetractRebasedFrontUntilPreviousXIsStrictlyBelowBoundary:
                cmp.w   -6(a1),d6
                bgt.s   SKRuntimeSpawning_CommitRebasedFrontPairAndReturn
                subq.w  #6,a1
                subq.w  #1,a3
                bra.s   SKRuntimeSpawning_RetractRebasedFrontUntilPreviousXIsStrictlyBelowBoundary
; ---------------------------------------------------------------------------

SKRuntimeSpawning_CommitRebasedFrontPairAndReturn:
                move.l  a1,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                bra.s   SKRuntimeSpawning_ReturnFromUnchangedOrCompletedCursorOnlyRebase
; ---------------------------------------------------------------------------

SKRuntimeSpawning_CommitRightRebaseCoarseXAndPrepareFrontAdvance:
                move.w  d6,(Camera_X_pos_coarse).w
                movea.l (Object_load_addr_front).w,a1
                movea.w (Object_respawn_index_front).w,a3
                addi.w  #$280,d6

SKRuntimeSpawning_AdvanceRebasedFrontWhileRecordXBelowUnsignedBoundary:
                cmp.w   (a1),d6
                bls.s   SKRuntimeSpawning_CommitRebasedFrontAndPrepareBackAdvance
                addq.w  #6,a1
                addq.w  #1,a3
                bra.s   SKRuntimeSpawning_AdvanceRebasedFrontWhileRecordXBelowUnsignedBoundary
; ---------------------------------------------------------------------------

SKRuntimeSpawning_CommitRebasedFrontAndPrepareBackAdvance:
                move.l  a1,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                movea.l (Object_load_addr_back).w,a1
                movea.w (Object_respawn_index_back).w,a3
                subi.w  #$300,d6
                bcs.s   SKRuntimeSpawning_CommitRebasedBackLayoutAndRespawnPointers

SKRuntimeSpawning_AdvanceRebasedBackWhileRecordXBelowUnsignedBoundary:
                cmp.w   (a1),d6
                bls.s   SKRuntimeSpawning_CommitRebasedBackLayoutAndRespawnPointers
                addq.w  #6,a1
                addq.w  #1,a3
                bra.s   SKRuntimeSpawning_AdvanceRebasedBackWhileRecordXBelowUnsignedBoundary
; ---------------------------------------------------------------------------

SKRuntimeSpawning_CommitRebasedBackLayoutAndRespawnPointers:
                move.l  a1,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w

SKRuntimeSpawning_ReturnFromUnchangedOrCompletedCursorOnlyRebase:
                rts
