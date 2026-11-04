; Owner: game/bonus/slots/sk
; Responsibility: Rotating slot option cycling, outcome state, player awards, effects and shared helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Slots_CycleOptions:
                lea     (SStage_scalar_result_0+2).w,a4
                moveq   #0,d0
                move.b  (a4),d0
                jmp     Slots_CycleOptions_Index(pc,d0.w)
; End of function Slots_CycleOptions

; ---------------------------------------------------------------------------

Slots_CycleOptions_Index:
                bra.w   SlotsOutcome_PrepareOptionScratchClear
; ---------------------------------------------------------------------------
                bra.w   SlotsOutcome_AdvanceStartupReels
; ---------------------------------------------------------------------------
                bra.w   SlotsOutcome_SeedSpinAndChooseOutcome
; ---------------------------------------------------------------------------
                bra.w   SlotsOutcome_SpinUntilTwoPasses
; ---------------------------------------------------------------------------
                bra.w   SlotsOutcome_AdvanceReelAndCheckAllStop
; ---------------------------------------------------------------------------
                bra.w   SlotsOutcome_StopAllAndEvaluatePayout
; ---------------------------------------------------------------------------
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_PrepareOptionScratchClear:
                movea.l a4,a1
                moveq   #8,d0

SlotsOutcome_ClearScratchAndSeedReels:
                clr.w   (a1)+
                dbf     d0,SlotsOutcome_ClearScratchAndSeedReels
                move.b  (V_int_run_count+3).w,d0
                move.b  d0,6(a4)
                ror.b   #3,d0
                move.b  d0,$A(a4)
                ror.b   #3,d0
                move.b  d0,$E(a4)
                move.b  #8,7(a4)
                move.b  #8,$B(a4)
                move.b  #8,$F(a4)
                move.b  #8,8(a4)
                move.b  #8,$C(a4)
                move.b  #8,$10(a4)
                move.b  #1,1(a4)
                addq.b  #4,(a4)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_AdvanceStartupReels:
                bsr.w   Slots_AdvanceReelAndQueueArt
                tst.b   1(a4)
                beq.s   SlotsOutcome_EnterIdleAndClearSpeeds
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_EnterIdleAndClearSpeeds:
                move.b  #$18,(a4)
                clr.w   8(a4)
                clr.w   $C(a4)
                clr.w   $10(a4)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_SeedSpinAndChooseOutcome:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #7,d0
                subq.b  #4,d0
                addi.b  #$30,d0
                move.b  d0,8(a4)
                move.b  (V_int_run_count+3).w,d0
                rol.b   #4,d0
                andi.b  #7,d0
                subq.b  #4,d0
                addi.b  #$30,d0
                move.b  d0,$C(a4)
                move.b  (V_int_run_count+2).w,d0
                andi.b  #7,d0
                subq.b  #4,d0
                addi.b  #$30,d0
                move.b  d0,$10(a4)
                move.b  #2,1(a4)
                clr.b   3(a4)
                clr.b   9(a4)
                clr.b   $D(a4)
                clr.b   $11(a4)
                addq.b  #4,(a4)
                move.b  (V_int_run_count+3).w,d0
                ror.b   #3,d0
                lea     (SlotsOutcome_WeightedSymbolTriplets).l,a2

SlotsOutcome_ScanWeightedBuckets:
                sub.b   (a2),d0
                bcs.s   SlotsOutcome_CopyWeightedSymbols
                addq.w  #3,a2
                bra.s   SlotsOutcome_ScanWeightedBuckets
; ---------------------------------------------------------------------------

; A weight byte of -1 selects the random symbol path
SlotsOutcome_CopyWeightedSymbols:
                cmpi.b  #-1,(a2)
                beq.s   SlotsOutcome_SelectRandomMappedSymbols
                move.b  1(a2),4(a4)
                move.b  2(a2),5(a4)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_SelectRandomMappedSymbols:
                jsr     (Random_Number).l
                add.w   (V_int_run_count+2).w,d0
                ror.w   #4,d0
                move.w  d0,d1
                andi.w  #7,d1
                lea     (SlotsOutcome_FirstReelSymbolStrip).l,a1
                move.b  (a1,d1.w),4(a4)
                lsr.w   #3,d0
                move.b  d0,d1
                andi.w  #7,d1
                lea     (SlotsOutcome_SecondReelSymbolStrip).l,a1
                move.b  (a1,d1.w),d2
                lsl.b   #4,d2
                lsr.w   #3,d0
                andi.w  #7,d0
                lea     (SlotsOutcome_ThirdReelSymbolStrip).l,a1
                or.b    (a1,d0.w),d2
                move.b  d2,5(a4)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_SpinUntilTwoPasses:
                bsr.w   Slots_AdvanceReelAndQueueArt
                tst.b   1(a4)
                beq.s   SlotsOutcome_SpeedUpAndBeginStopPhase
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_SpeedUpAndBeginStopPhase:
                addi.b  #$30,8(a4)
                addi.b  #$30,$C(a4)
                addi.b  #$30,$10(a4)
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                addi.b  #$C,d0
                move.b  d0,1(a4)
                clr.b   2(a4)
                addq.b  #4,(a4)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_AdvanceReelAndCheckAllStop:
                bsr.w   Slots_AdvanceReelAndQueueArt
                cmpi.b  #$C,9(a4)
                bne.s   SlotsOutcome_DispatchSelectedReelStop
                cmpi.b  #$C,$D(a4)
                bne.s   SlotsOutcome_DispatchSelectedReelStop
                cmpi.b  #$C,$11(a4)
                beq.w   SlotsOutcome_StopAllAndEvaluatePayout

SlotsOutcome_DispatchSelectedReelStop:
                moveq   #0,d0
                move.b  3(a4),d0
                lea     6(a4),a1
                adda.w  d0,a1
                lea     (SlotsOutcome_FirstReelSymbolStrip).l,a3
                add.w   d0,d0
                adda.w  d0,a3
                moveq   #0,d0
                move.b  3(a1),d0
                jmp     SlotsOutcome_ReelStopSubstateBranches(pc,d0.w)
; ---------------------------------------------------------------------------

SlotsOutcome_ReelStopSubstateBranches:
                bra.w   SlotsOutcome_WaitFirstReelForPassBorrow
; ---------------------------------------------------------------------------
                bra.w   SlotsOutcome_CheckStripSymbolAndBrake
; ---------------------------------------------------------------------------
                bra.w   SlotsOutcome_WaitForReelAlignment
; ---------------------------------------------------------------------------
                bra.w   SlotsOutcome_ReelStopReturn

; =============== S U B R O U T I N E =======================================

; Unpack the selected reel's outcome and map symbol 7 to 5
Slots_GetSelectedReelSymbol:
                move.w  4(a4),d1
                move.b  3(a4),d0
                beq.s   SlotsOutcome_ExtractTargetSymbol
                lsr.w   d0,d1

SlotsOutcome_ExtractTargetSymbol:
                andi.w  #7,d1
                cmpi.b  #6,d1
                bgt.s   SlotsOutcome_MapSymbol7To5
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_MapSymbol7To5:
                subq.b  #2,d1
                rts
; End of function Slots_GetSelectedReelSymbol

; =============== S U B R O U T I N E =======================================

; Replace the selected nibble and clear the unused high bit of each of the three symbols
Slots_SetSelectedReelSymbol:
                move.w  #$FFF0,d2
                andi.w  #$F,d1
                move.b  3(a4),d0
                beq.s   SlotsOutcome_ReplaceAndMaskOutcomeNibble
                lsl.w   d0,d1
                rol.w   d0,d2

SlotsOutcome_ReplaceAndMaskOutcomeNibble:
                and.w   d2,4(a4)
                or.w    d1,4(a4)
                andi.w  #$777,4(a4)
                rts
; End of function Slots_SetSelectedReelSymbol

; ---------------------------------------------------------------------------

SlotsOutcome_WaitFirstReelForPassBorrow:
                tst.b   3(a4)
                bne.s   SlotsOutcome_WaitForPreviousReelState
                tst.b   1(a4)
                bmi.s   SlotsOutcome_WaitForTargetStripSymbol
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_WaitForPreviousReelState:
                cmpi.b  #8,-1(a1)
                bge.s   SlotsOutcome_WaitForTargetStripSymbol
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_WaitForTargetStripSymbol:
                bsr.s   Slots_GetSelectedReelSymbol
                move.w  (a1),d0
                subi.w  #$A0,d0
                lsr.w   #8,d0
                andi.w  #7,d0
                move.b  (a3,d0.w),d0
                cmp.b   d1,d0
                beq.s   SlotsOutcome_StartReelBrakeAt96
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_StartReelBrakeAt96:
                addq.b  #4,3(a1)
                move.b  #$60,2(a1)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_CheckStripSymbolAndBrake:
                bsr.s   Slots_GetSelectedReelSymbol
                move.w  (a1),d0
                addi.w  #$F0,d0
                andi.w  #$700,d0
                lsr.w   #8,d0
                move.b  (a3,d0.w),d0
                cmp.b   d0,d1
                beq.s   SlotsOutcome_SnapReelAndSetOutcomeNibble
                cmpi.b  #$20,2(a1)
                bls.s   SlotsOutcome_CheckFineBrakeSpeed
                subi.b  #$C,2(a1)

SlotsOutcome_CheckFineBrakeSpeed:
                cmpi.b  #$18,2(a1)
                bgt.s   SlotsOutcome_CheckFineBrakePosition
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_CheckFineBrakePosition:
                cmpi.b  #$80,1(a1)
                bls.s   SlotsOutcome_ReduceReelSpeedBy2
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_ReduceReelSpeedBy2:
                subq.b  #2,2(a1)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_SnapReelAndSetOutcomeNibble:
                move.w  (a1),d0
                addi.w  #$80,d0
                move.w  d0,d1
                andi.w  #$700,d1
                subi.w  #$10,d1
                move.w  d1,(a1)
                lsr.w   #8,d0
                andi.w  #7,d0
                move.b  (a3,d0.w),d1
                bsr.w   Slots_SetSelectedReelSymbol
                move.b  #-8,2(a1)
                addq.b  #4,3(a1)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_WaitForReelAlignment:
                tst.b   1(a1)
                beq.s   SlotsOutcome_StopAlignedReel
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_StopAlignedReel:
                clr.b   2(a1)
                addq.b  #4,3(a1)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_ReelStopReturn:
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_StopAllAndEvaluatePayout:
                clr.w   8(a4)
                clr.w   $C(a4)
                clr.w   $10(a4)
                clr.b   1(a4)
                bsr.w   Slots_EvaluateReelPayout
                move.b  #$18,(a4)
                rts

; =============== S U B R O U T I N E =======================================

; Advance one of three reels in rotation. Rebuild its 512-byte strip only across an eight-unit scroll boundary
Slots_AdvanceReelAndQueueArt:
                moveq   #0,d0
                move.b  3(a4),d0
                lea     6(a4),a1
                adda.w  d0,a1
                lea     (SlotsOutcome_FirstReelSymbolStrip).l,a3
                adda.w  d0,a3
                adda.w  d0,a3
                jmp     SlotsOutcome_SelectReelAndCountPass(pc,d0.w)
; End of function Slots_AdvanceReelAndQueueArt

; ---------------------------------------------------------------------------

SlotsOutcome_SelectReelAndCountPass:
                bra.w   SlotsOutcome_SelectFirstReelStrip
; ---------------------------------------------------------------------------
                bra.w   SlotsOutcome_SelectSecondReelStrip
; ---------------------------------------------------------------------------
                clr.b   3(a4)
                subq.b  #1,1(a4)
                move.w  #$4400,d2
                bra.s   SlotsOutcome_StepReelAndCheckRowChange
; ---------------------------------------------------------------------------

SlotsOutcome_SelectFirstReelStrip:
                addq.b  #4,3(a4)
                move.w  #$4000,d2
                bra.w   SlotsOutcome_StepReelAndCheckRowChange
; ---------------------------------------------------------------------------

SlotsOutcome_SelectSecondReelStrip:
                addq.b  #4,3(a4)
                move.w  #$4200,d2

SlotsOutcome_StepReelAndCheckRowChange:
                move.w  (a1),d0
                move.b  2(a1),d1
                ext.w   d1
                sub.w   d1,(a1)
                move.w  (a1),d3
                andi.w  #$7F8,d0
                andi.w  #$7F8,d3
                cmp.w   d0,d3
                bne.s   SlotsOutcome_ResolveChangedStripRow
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_ResolveChangedStripRow:
                bsr.w   SlotsResolveSymbolStripRowArtPointer
                lea     (Chunk_table+$7C00).l,a1
                move.w  #$20-1,d1

SlotsOutcome_CopyStripBands:
                move.l  $80(a2),$80(a1)
                move.l  $100(a2),$100(a1)
                move.l  $180(a2),$180(a1)
                move.l  (a2)+,(a1)+
                addq.b  #8,d3
                bne.s   SlotsOutcome_QueueStripVRAMUpload
                addi.w  #$100,d3
                andi.w  #$700,d3
                bsr.w   SlotsResolveSymbolStripRowArtPointer

SlotsOutcome_QueueStripVRAMUpload:
                dbf     d1,SlotsOutcome_CopyStripBands
                move.l  #(Chunk_table+$7C00)&$FFFFFF,d1
                move.w  #$100,d3
                jsr     (Add_To_DMA_Queue).l
                rts

; =============== S U B R O U T I N E =======================================

SlotsResolveSymbolStripRowArtPointer:
                move.w  d3,d0
                lsr.w   #8,d0
                andi.w  #7,d0
                move.b  (a3,d0.w),d0
                andi.w  #7,d0
                ror.w   #7,d0
                lea     (ArtUnc_SlotOptions).l,a2
                adda.w  d0,a2
                move.w  d3,d0
                andi.w  #$F8,d0
                lsr.w   #1,d0
                adda.w  d0,a2
                rts
; End of function SlotsResolveSymbolStripRowArtPointer

; =============== S U B R O U T I N E =======================================

; Match triples, apply symbol 0 wildcard multipliers, or award the consolation count for unmatched symbol 6
Slots_EvaluateReelPayout:
                move.b  5(a4),d2
                move.b  d2,d3
                andi.w  #$F0,d2
                lsr.w   #4,d2
                andi.w  #$F,d3
                moveq   #0,d0
                cmp.b   4(a4),d2
                bne.s   SlotsOutcome_AddSecondMatchFlag
                addq.w  #4,d0

SlotsOutcome_AddSecondMatchFlag:
                cmp.b   4(a4),d3
                bne.s   SlotsOutcome_JumpToPayoutCase
                addq.w  #8,d0

SlotsOutcome_JumpToPayoutCase:
                jmp     SlotsOutcome_PayoutMatchBranches(pc,d0.w)
; End of function Slots_EvaluateReelPayout

; ---------------------------------------------------------------------------

SlotsOutcome_PayoutMatchBranches:
                bra.w   SlotsOutcome_CheckMiddleLastPair
; ---------------------------------------------------------------------------
                bra.w   SlotsOutcome_CheckFirstMiddleZeroPair
; ---------------------------------------------------------------------------
                bra.w   SlotsOutcome_CheckFirstLastZeroPair
; ---------------------------------------------------------------------------
                move.w  d2,d0
                bsr.w   SlotsLookupSignedBasePayoutBySymbol
                move.w  d0,4(a4)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_CheckFirstLastZeroPair:
                cmpi.b  #0,d3
                bne.s   SlotsOutcome_DoubleFirstLastIfMiddleZero
                move.w  d2,d0
                bsr.w   SlotsLookupSignedBasePayoutBySymbol
                bsr.w   SlotsMultiplySignedPayoutBy4
                move.w  d0,4(a4)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_DoubleFirstLastIfMiddleZero:
                cmpi.b  #0,d2
                bne.w   SlotsOutcome_CheckMiddleLastPair
                move.w  d3,d0
                bsr.w   SlotsLookupSignedBasePayoutBySymbol
                bsr.w   SlotsMultiplySignedPayoutBy2
                move.w  d0,4(a4)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_CheckFirstMiddleZeroPair:
                cmpi.b  #0,d2
                bne.s   SlotsOutcome_DoubleFirstMiddleIfLastZero
                move.w  d3,d0
                bsr.s   SlotsLookupSignedBasePayoutBySymbol
                bsr.w   SlotsMultiplySignedPayoutBy4
                move.w  d0,4(a4)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_DoubleFirstMiddleIfLastZero:
                cmpi.b  #0,d3
                bne.w   SlotsOutcome_CheckMiddleLastPair
                move.w  d2,d0
                bsr.s   SlotsLookupSignedBasePayoutBySymbol
                bsr.w   SlotsMultiplySignedPayoutBy2
                move.w  d0,4(a4)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_CheckMiddleLastPair:
                cmp.b   d2,d3
                bne.s   SlotsOutcome_BeginFallbackSymbol6Count
                cmpi.b  #0,4(a4)
                bne.s   SlotsOutcome_QuadrupleFirstWithTwoZeros
                move.w  d2,d0
                bsr.s   SlotsLookupSignedBasePayoutBySymbol
                bsr.w   SlotsMultiplySignedPayoutBy2
                move.w  d0,4(a4)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_QuadrupleFirstWithTwoZeros:
                cmpi.b  #0,d2
                bne.s   SlotsOutcome_BeginFallbackSymbol6Count
                move.b  4(a4),d0
                andi.w  #$F,d0
                bsr.s   SlotsLookupSignedBasePayoutBySymbol
                bsr.w   SlotsMultiplySignedPayoutBy4
                move.w  d0,4(a4)
                rts
; ---------------------------------------------------------------------------

SlotsOutcome_BeginFallbackSymbol6Count:
                moveq   #2,d1
                moveq   #0,d0
                cmpi.b  #6,4(a4)
                bne.s   SlotsOutcome_AddTwoForMiddleSymbol6
                add.w   d1,d0

SlotsOutcome_AddTwoForMiddleSymbol6:
                cmpi.b  #6,d2
                bne.s   SlotsOutcome_AddTwoForLastSymbol6
                add.w   d1,d0

SlotsOutcome_AddTwoForLastSymbol6:
                cmpi.b  #6,d3
                bne.s   SlotsOutcome_StoreFallbackAndLookupBase
                add.w   d1,d0

SlotsOutcome_StoreFallbackAndLookupBase:
                move.w  d0,4(a4)

; =============== S U B R O U T I N E =======================================

SlotsLookupSignedBasePayoutBySymbol:
                add.w   d0,d0
                lea     (SlotsOutcome_SignedBasePayouts).l,a2
                move.w  (a2,d0.w),d0
                rts
; End of function SlotsLookupSignedBasePayoutBySymbol

; =============== S U B R O U T I N E =======================================

SlotsMultiplySignedPayoutBy4:
                asl.w   #2,d0
                rts
; End of function SlotsMultiplySignedPayoutBy4

; =============== S U B R O U T I N E =======================================

SlotsMultiplySignedPayoutBy2:
                add.w   d0,d0
                rts
; End of function SlotsMultiplySignedPayoutBy2

; ---------------------------------------------------------------------------
SlotsOutcome_SignedBasePayouts:
                dc.w    100
                dc.w    30
                dc.w    20
                dc.w    25
                dc.w    -1
                dc.w    10
                dc.w    8
                dc.w    200
SlotsOutcome_WeightedSymbolTriplets:
                dc.b    4,   0,   0
                dc.b    9,   1, $11
                dc.b    4,   3, $33
                dc.b    $12,   4, $44
                dc.b    9,   2, $22
                dc.b    $F,   5, $55
                dc.b    $F,   6, $66
                dc.b    $FF,  $F, $FF
SlotsOutcome_FirstReelSymbolStrip:
                dc.b    0,   1,   2,   5,   4,   6,   5,   3
SlotsOutcome_SecondReelSymbolStrip:
                dc.b    0,   1,   2,   5,   4,   6,   1,   3
SlotsOutcome_ThirdReelSymbolStrip:
                dc.b    0,   1,   2,   5,   4,   6,   3,   5

; =============== S U B R O U T I N E =======================================

; Clear compression and display queues, reset VDP setup and clear transient memory for title or results
BlueSphere_ResetVideoAndSceneRAM:
                clr.w   (Kos_decomp_queue_count).w
                clearRAM Kos_decomp_stored_registers,(Kos_decomp_module_end-Kos_decomp_stored_registers)
                jsr     (Clear_Nem_Queue).l
                move    #$2700,sr
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8230,(a6)
                move.w  #$8407,(a6)
                move.w  #$9001,(a6)
                move.w  #$9200,(a6)
                move.w  #$8B03,(a6)
                move.w  #$8720,(a6)
                clr.b   (Water_full_screen_flag).w
                clr.b   (Water_flag).w
                move.w  #$8C81,(a6)
                jsr     (Clear_DisplayData).l
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Player_1,(Kos_decomp_buffer-Player_1)
                jsr     (Init_SpriteTable).l
                clearRAM Normal_palette,(Stack_contents-Normal_palette)
                clr.w   (Current_zone_and_act).w
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                rts
; End of function BlueSphere_ResetVideoAndSceneRAM
