; Owner: objects/runtime/s3
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
                bra.w   S3RuntimeSpawning_EnterStreamingInitializationAndGateRespawnClear
; ---------------------------------------------------------------------------
                bra.w   S3RuntimeSpawning_PublishCameraBackBoundaryAndSelectVerticalWindowDecoder
; ---------------------------------------------------------------------------
                bra.w   S3RuntimeSpawning_PublishCameraBackBoundaryAndSelectVerticalWindowDecoder
; ---------------------------------------------------------------------------
                rts
; ---------------------------------------------------------------------------

S3RuntimeSpawning_EnterStreamingInitializationAndGateRespawnClear:
                addq.b  #4,(Object_load_routine).w
                tst.b   (Respawn_table_keep).w
                bne.s   S3RuntimeSpawning_SelectZoneActLayoutAndChoosePreloadOrStreaming
                lea     (Object_respawn_table).w,a0
                moveq   #0,d0
                move.w  #bytesToLcnt($300),d1

S3RuntimeSpawning_ClearMainRespawnTableByLongword:
                move.l  d0,(a0)+
                dbf     d1,S3RuntimeSpawning_ClearMainRespawnTableByLongword

S3RuntimeSpawning_SelectZoneActLayoutAndChoosePreloadOrStreaming:
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #5,d0
                lea     (SpriteLocPtrs).l,a0
                movea.l (a0,d0.w),a0
                cmpi.b  #$13,(Current_zone).w           ; Is this the Gumball Machine?
                bcc.s   S3RuntimeSpawning_EnterOnePassPreloadAndAllocateInitialCandidate  ; if so, branch
                tst.w   (Competition_mode).w            ; Is Competition Mode active?
                beq.s   S3RuntimeSpawning_InitializeLayoutCursorPairAndRespawnBase  ; if not, branch

S3RuntimeSpawning_EnterOnePassPreloadAndAllocateInitialCandidate:
                addq.b  #8,(Object_load_routine).w
                jsr     AllocateObject(pc)
                bne.s   S3RuntimeSpawning_FinishOnePassPreloadWithCoarseBackInitialization
                lea     (_unkF712).w,a3
                lea     (Sprite_Listing).l,a4
                move.w  #$800,d6

S3RuntimeSpawning_PreloadSixByteRecordsUntilUnsignedXThresholdOrNextSlotFailure:
                cmp.w   (a0),d6
                bls.s   S3RuntimeSpawning_FinishOnePassPreloadWithCoarseBackInitialization
                jsr     CreateObjectFromLayoutRecord(pc)
                beq.s   S3RuntimeSpawning_PreloadSixByteRecordsUntilUnsignedXThresholdOrNextSlotFailure

S3RuntimeSpawning_FinishOnePassPreloadWithCoarseBackInitialization:
                clr.w   (Camera_X_pos_coarse_back).w
                rts
; ---------------------------------------------------------------------------

S3RuntimeSpawning_InitializeLayoutCursorPairAndRespawnBase:
                move.l  a0,(Object_load_addr_front).w
                move.l  a0,(Object_load_addr_back).w
                lea     (Object_respawn_table).w,a3
                move.w  (Camera_X_pos).w,d6
                subi.w  #$80,d6
                bcc.s   S3RuntimeSpawning_AlignFrontSeekBoundaryToOneHundredTwentyEightPixels
                moveq   #0,d6

S3RuntimeSpawning_AlignFrontSeekBoundaryToOneHundredTwentyEightPixels:
                andi.w  #$FF80,d6
                movea.l (Object_load_addr_front).w,a0

S3RuntimeSpawning_SeekInitialFrontCursorWhileRecordXBelowBoundary:
                cmp.w   (a0),d6
                bls.s   S3RuntimeSpawning_CommitInitialFrontCursorAndPrepareBackSeek
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   S3RuntimeSpawning_SeekInitialFrontCursorWhileRecordXBelowBoundary
; ---------------------------------------------------------------------------

S3RuntimeSpawning_CommitInitialFrontCursorAndPrepareBackSeek:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                lea     (Object_respawn_table).w,a3
                movea.l (Object_load_addr_back).w,a0
                subi.w  #$80,d6
                bcs.s   S3RuntimeSpawning_CommitInitialBackCursorForceFirstXRefreshAndSeedCoarseY

S3RuntimeSpawning_SeekInitialBackCursorWhileRecordXBelowBoundary:
                cmp.w   (a0),d6
                bls.s   S3RuntimeSpawning_CommitInitialBackCursorForceFirstXRefreshAndSeedCoarseY
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   S3RuntimeSpawning_SeekInitialBackCursorWhileRecordXBelowBoundary
; ---------------------------------------------------------------------------

S3RuntimeSpawning_CommitInitialBackCursorForceFirstXRefreshAndSeedCoarseY:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w
                move.w  #-1,(Camera_X_pos_coarse).w
                move.w  (Camera_Y_pos).w,d0
                andi.w  #$FF80,d0
                move.w  d0,(Camera_Y_pos_coarse).w

S3RuntimeSpawning_PublishCameraBackBoundaryAndSelectVerticalWindowDecoder:
                move.w  (Camera_X_pos).w,d1
                subi.w  #$80,d1
                andi.w  #$FF80,d1
                move.w  d1,(Camera_X_pos_coarse_back).w
                lea     (Sprite_Listing).l,a4
                tst.w   (Camera_min_Y_pos).w
                bpl.s   S3RuntimeSpawning_BuildNonwrappingVerticalWindowAndClampNegativeLowerEdge
                lea     S3RuntimeSpawning_SkipLoadedRecordOrEnterWrappedUnionYFilter(pc),a6
                move.w  (Camera_Y_pos).w,d3
                andi.w  #$FF80,d3
                move.w  d3,d4
                addi.w  #$200,d4
                subi.w  #$80,d3
                bpl.s   S3RuntimeSpawning_DetectBottomOverflowOfWrappedVerticalWindow
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   S3RuntimeSpawning_ChooseHorizontalStreamDirectionFromSignedCoarseXChange
; ---------------------------------------------------------------------------

S3RuntimeSpawning_DetectBottomOverflowOfWrappedVerticalWindow:
                move.w  (Screen_Y_wrap_value).w,d0
                addq.w  #1,d0
                cmp.w   d0,d4
                bls.s   S3RuntimeSpawning_SelectLinearVerticalRecordDecoder
                and.w   (Screen_Y_wrap_value).w,d4
                bra.s   S3RuntimeSpawning_ChooseHorizontalStreamDirectionFromSignedCoarseXChange
; ---------------------------------------------------------------------------

S3RuntimeSpawning_BuildNonwrappingVerticalWindowAndClampNegativeLowerEdge:
                move.w  (Camera_Y_pos).w,d3
                andi.w  #$FF80,d3
                move.w  d3,d4
                addi.w  #$200,d4
                subi.w  #$80,d3
                bpl.s   S3RuntimeSpawning_SelectLinearVerticalRecordDecoder
                moveq   #0,d3

S3RuntimeSpawning_SelectLinearVerticalRecordDecoder:
                lea     S3RuntimeSpawning_SkipLoadedRecordOrEnterLinearYFilter(pc),a6

S3RuntimeSpawning_ChooseHorizontalStreamDirectionFromSignedCoarseXChange:
                move.w  #$FFF,d5
                move.w  (Camera_X_pos).w,d6
                andi.w  #$FF80,d6
                cmp.w   (Camera_X_pos_coarse).w,d6
                beq.w   S3RuntimeSpawning_ChooseNewVerticalRowFromSignedCoarseYChange
                bge.s   S3RuntimeSpawning_CommitRightCoarseXAndAllocateEnteringFrontCandidate
                move.w  d6,(Camera_X_pos_coarse).w
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                subi.w  #$80,d6
                bcs.s   S3RuntimeSpawning_CommitLeftBackCursorAndPrepareFrontRetraction
                jsr     AllocateObject(pc)
                bne.s   S3RuntimeSpawning_CommitLeftBackCursorAndPrepareFrontRetraction

S3RuntimeSpawning_LoadPreviousRecordsForLeftwardWindowExpansion:
                cmp.w   -6(a0),d6
                bge.s   S3RuntimeSpawning_CommitLeftBackCursorAndPrepareFrontRetraction
                subq.w  #6,a0
                subq.w  #1,a3
                jsr     (a6)
                bne.s   S3RuntimeSpawning_AdvanceLeftFailureCursorBeyondAlreadyConsumedRecord
                subq.w  #6,a0
                bra.s   S3RuntimeSpawning_LoadPreviousRecordsForLeftwardWindowExpansion
; ---------------------------------------------------------------------------

S3RuntimeSpawning_AdvanceLeftFailureCursorBeyondAlreadyConsumedRecord:
                addq.w  #6,a0
                addq.w  #1,a3

S3RuntimeSpawning_CommitLeftBackCursorAndPrepareFrontRetraction:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w
                movea.l (Object_load_addr_front).w,a0
                movea.w (Object_respawn_index_front).w,a3
                addi.w  #$300,d6

S3RuntimeSpawning_RetractFrontCursorWhilePreviousXAtOrBeyondRightBoundary:
                cmp.w   -6(a0),d6
                bgt.s   S3RuntimeSpawning_CommitRetractedFrontCursorAndContinueVerticalScan
                subq.w  #6,a0
                subq.w  #1,a3
                bra.s   S3RuntimeSpawning_RetractFrontCursorWhilePreviousXAtOrBeyondRightBoundary
; ---------------------------------------------------------------------------

S3RuntimeSpawning_CommitRetractedFrontCursorAndContinueVerticalScan:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                bra.s   S3RuntimeSpawning_ChooseNewVerticalRowFromSignedCoarseYChange
; ---------------------------------------------------------------------------

S3RuntimeSpawning_CommitRightCoarseXAndAllocateEnteringFrontCandidate:
                move.w  d6,(Camera_X_pos_coarse).w
                movea.l (Object_load_addr_front).w,a0
                movea.w (Object_respawn_index_front).w,a3
                addi.w  #$280,d6
                jsr     AllocateObject(pc)
                bne.s   S3RuntimeSpawning_CommitRightFrontCursorAndPrepareBackAdvance

S3RuntimeSpawning_LoadForwardRecordsBelowExclusiveRightBoundary:
                cmp.w   (a0),d6
                bls.s   S3RuntimeSpawning_CommitRightFrontCursorAndPrepareBackAdvance
                jsr     (a6)
                addq.w  #1,a3
                beq.s   S3RuntimeSpawning_LoadForwardRecordsBelowExclusiveRightBoundary

S3RuntimeSpawning_CommitRightFrontCursorAndPrepareBackAdvance:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                subi.w  #$300,d6
                bcs.s   S3RuntimeSpawning_CommitAdvancedBackCursor

S3RuntimeSpawning_AdvanceBackCursorPastRecordsBelowUnsignedLeftBoundary:
                cmp.w   (a0),d6
                bls.s   S3RuntimeSpawning_CommitAdvancedBackCursor
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   S3RuntimeSpawning_AdvanceBackCursorPastRecordsBelowUnsignedLeftBoundary
; ---------------------------------------------------------------------------

S3RuntimeSpawning_CommitAdvancedBackCursor:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w

S3RuntimeSpawning_ChooseNewVerticalRowFromSignedCoarseYChange:
                move.w  (Camera_Y_pos).w,d6
                andi.w  #$FF80,d6
                move.w  d6,d3
                cmp.w   (Camera_Y_pos_coarse).w,d6
                beq.w   S3RuntimeSpawning_CommitCoarseYAfterScanSkipOrAllocationFailure
                bge.s   S3RuntimeSpawning_ChooseLowerEnteringRowOrWrapSeamUpperRow
                tst.w   (Camera_min_Y_pos).w
                bpl.s   S3RuntimeSpawning_RejectNegativeUpperRowWhenVerticalWrappingDisabled
                tst.w   d6
                bne.s   S3RuntimeSpawning_SelectUpperEnteringRowWithConditionalWrapMask
                cmpi.w  #$80,(Camera_Y_pos_coarse).w
                bne.s   S3RuntimeSpawning_SelectLowerEnteringRowAndMaskAtOrBeyondWrapLimit

S3RuntimeSpawning_SelectUpperEnteringRowWithConditionalWrapMask:
                subi.w  #$80,d3
                bpl.s   S3RuntimeSpawning_AllocateVerticalRowCandidateAndBoundCurrentLayoutSpan
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   S3RuntimeSpawning_AllocateVerticalRowCandidateAndBoundCurrentLayoutSpan
; ---------------------------------------------------------------------------

S3RuntimeSpawning_RejectNegativeUpperRowWhenVerticalWrappingDisabled:
                subi.w  #$80,d3
                bmi.w   S3RuntimeSpawning_CommitCoarseYAfterScanSkipOrAllocationFailure
                bra.s   S3RuntimeSpawning_AllocateVerticalRowCandidateAndBoundCurrentLayoutSpan
; ---------------------------------------------------------------------------

S3RuntimeSpawning_ChooseLowerEnteringRowOrWrapSeamUpperRow:
                tst.w   (Camera_min_Y_pos).w
                bpl.s   S3RuntimeSpawning_SkipNonwrappingLowerRowOnlyWhenBeyondWrapLimit
                tst.w   (Camera_Y_pos_coarse).w
                bne.s   S3RuntimeSpawning_SelectLowerEnteringRowAndMaskAtOrBeyondWrapLimit
                cmpi.w  #$80,d6
                bne.s   S3RuntimeSpawning_SelectUpperEnteringRowWithConditionalWrapMask

S3RuntimeSpawning_SelectLowerEnteringRowAndMaskAtOrBeyondWrapLimit:
                addi.w  #$180,d3
                cmp.w   (Screen_Y_wrap_value).w,d3
                blo.s   S3RuntimeSpawning_AllocateVerticalRowCandidateAndBoundCurrentLayoutSpan
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   S3RuntimeSpawning_AllocateVerticalRowCandidateAndBoundCurrentLayoutSpan
; ---------------------------------------------------------------------------

S3RuntimeSpawning_SkipNonwrappingLowerRowOnlyWhenBeyondWrapLimit:
                addi.w  #$180,d3
                cmp.w   (Screen_Y_wrap_value).w,d3
                bhi.s   S3RuntimeSpawning_CommitCoarseYAfterScanSkipOrAllocationFailure

S3RuntimeSpawning_AllocateVerticalRowCandidateAndBoundCurrentLayoutSpan:
                jsr     AllocateObject(pc)
                bne.s   S3RuntimeSpawning_CommitCoarseYAfterScanSkipOrAllocationFailure
                move.w  d3,d4
                addi.w  #$80,d4
                move.w  #$FFF,d5
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                move.l  (Object_load_addr_front).w,d7
                sub.l   a0,d7
                beq.s   S3RuntimeSpawning_CommitCoarseYAfterScanSkipOrAllocationFailure
                addq.w  #2,a0

S3RuntimeSpawning_CreateUnloadedRecordsInsideInclusiveVerticalRow:
                tst.b   (a3)
                bmi.s   S3RuntimeSpawning_AdvanceSixByteVerticalSpanAndWordRemainingCount
                move.w  (a0),d1
                and.w   d5,d1
                cmp.w   d3,d1
                blo.s   S3RuntimeSpawning_AdvanceSixByteVerticalSpanAndWordRemainingCount
                cmp.w   d4,d1
                bhi.s   S3RuntimeSpawning_AdvanceSixByteVerticalSpanAndWordRemainingCount
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
                bne.s   S3RuntimeSpawning_CommitCoarseYAfterScanSkipOrAllocationFailure

S3RuntimeSpawning_AdvanceSixByteVerticalSpanAndWordRemainingCount:
                addq.w  #6,a0
                addq.w  #1,a3
                subq.w  #6,d7
                bne.s   S3RuntimeSpawning_CreateUnloadedRecordsInsideInclusiveVerticalRow

S3RuntimeSpawning_CommitCoarseYAfterScanSkipOrAllocationFailure:
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

S3RuntimeSpawning_SkipLoadedRecordOrEnterWrappedUnionYFilter:
                tst.b   (a3)
                bpl.s   S3RuntimeSpawning_ReadRecordXYAndApplyWrappedUnionWindow
                addq.w  #6,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

S3RuntimeSpawning_ReadRecordXYAndApplyWrappedUnionWindow:
                move.w  (a0)+,d7
                move.w  (a0)+,d1
                move.w  d1,d2
                bmi.s   S3RuntimeSpawning_MaskForcedWrappedRecordYBeforeCreation
                and.w   d5,d1
                cmp.w   d3,d1
                bhs.s   S3RuntimeSpawning_CommitWrappedRecordAndSearchFollowingCandidate
                cmp.w   d4,d1
                bls.s   S3RuntimeSpawning_CommitWrappedRecordAndSearchFollowingCandidate
                addq.w  #2,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

S3RuntimeSpawning_MaskForcedWrappedRecordYBeforeCreation:
                and.w   d5,d1

S3RuntimeSpawning_CommitWrappedRecordAndSearchFollowingCandidate:
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

S3RuntimeSpawning_SkipLoadedRecordOrEnterLinearYFilter:
                tst.b   (a3)
                bpl.s   S3RuntimeSpawning_ReadRecordXYAndApplyInclusiveLinearWindow
                addq.w  #6,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

S3RuntimeSpawning_ReadRecordXYAndApplyInclusiveLinearWindow:
                move.w  (a0)+,d7
                move.w  (a0)+,d1
                move.w  d1,d2
                bmi.s   S3RuntimeSpawning_MaskForcedLinearRecordYBeforeCreation
                and.w   d5,d1
                cmp.w   d3,d1
                blo.s   S3RuntimeSpawning_SkipRemainingRecordIdAndSubtypeWithSuccessFlags
                cmp.w   d4,d1
                bls.s   S3RuntimeSpawning_CommitLinearRecordAndFallIntoNextCandidateSearch

S3RuntimeSpawning_SkipRemainingRecordIdAndSubtypeWithSuccessFlags:
                addq.w  #2,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

S3RuntimeSpawning_MaskForcedLinearRecordYBeforeCreation:
                and.w   d5,d1

S3RuntimeSpawning_CommitLinearRecordAndFallIntoNextCandidateSearch:
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
                bmi.s   S3RuntimeSpawning_ReturnFromNextCandidateSearchWithNativeCounterAndCcr

S3RuntimeSpawning_ScanFollowingObjectSlotsUsingRemainingCounterAndCodeZero:
                lea     next_object(a1),a1
                tst.l   (a1)
                dbeq    d0,S3RuntimeSpawning_ScanFollowingObjectSlotsUsingRemainingCounterAndCodeZero

S3RuntimeSpawning_ReturnFromNextCandidateSearchWithNativeCounterAndCcr:
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

S3RuntimeSpawning_ClearRespawnBitForActiveActorWithNonzeroWordPointer:
                lea     next_object(a1),a1
                tst.l   (a1)
                beq.s   S3RuntimeSpawning_ContinueActorFlagResetThenReadActiveRingConsumptionCount
                move.w  respawn_addr(a1),d0
                beq.s   S3RuntimeSpawning_ContinueActorFlagResetThenReadActiveRingConsumptionCount
                movea.w d0,a2
                bclr    #7,(a2)

S3RuntimeSpawning_ContinueActorFlagResetThenReadActiveRingConsumptionCount:
                dbf     d1,S3RuntimeSpawning_ClearRespawnBitForActiveActorWithNonzeroWordPointer
                lea     (Ring_consumption_table).w,a2
                move.w  (a2)+,d1
                subq.w  #1,d1
                bcs.s   S3RuntimeSpawning_ReturnAfterRespawnFlagAndActiveRingFinalization

S3RuntimeSpawning_FinalizeNonzeroRingStatusPointersAndClearTheirQueueEntries:
                move.w  (a2)+,d0
                beq.s   S3RuntimeSpawning_FinalizeNonzeroRingStatusPointersAndClearTheirQueueEntries
                movea.w d0,a1
                move.w  #-1,(a1)
                clr.w   -2(a2)
                subq.w  #1,(Ring_consumption_table).w
                dbf     d1,S3RuntimeSpawning_FinalizeNonzeroRingStatusPointersAndClearTheirQueueEntries

S3RuntimeSpawning_ReturnAfterRespawnFlagAndActiveRingFinalization:
                rts
