; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace crane or linked child movement, indexed geometry, animation and synchronized state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

HPZCrane_InitSecondTargetBank:
                bset    #3,$38(a0)
                move.b  #$40,$3C(a0)
                move.b  #1,$40(a0)
                bra.w   HPZCrane_InitSegmentAndSelectBank
; ---------------------------------------------------------------------------

HPZCrane_InitNegativePhase:
                move.b  #-$40,$3C(a0)
                move.b  #-1,$40(a0)

HPZCrane_InitSegmentAndSelectBank:
                lea     SKHpzCrane_ChainSegmentPartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #HPZCrane_OscillateHiddenWhileWaiting,(a0)
                move.b  $3C(a0),$26(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d1
                btst    #3,$38(a0)
                beq.s   HPZCrane_ReadTargetAndMarkTerminal
                addi.w  #$A,d1

HPZCrane_ReadTargetAndMarkTerminal:
                move.b  SKHPZAux_CraneSegmentTwoTargetPhaseBanks(pc,d1.w),$31(a0)
                cmpi.b  #$12,d0
                bne.s   HPZCrane_StoreWrappedPeriodAndDelay
                bset    #2,$38(a0)

HPZCrane_StoreWrappedPeriodAndDelay:
                move.w  d0,d1
                addi.b  #$10,d1
                add.b   d1,d1
                move.b  d1,$30(a0)
                lsl.w   #2,d0
                subi.w  #$48,d0
                neg.w   d0
                move.w  d0,$2E(a0)
                move.w  d0,$32(a0)
                rts
; ---------------------------------------------------------------------------
SKHPZAux_CraneSegmentTwoTargetPhaseBanks:
                dc.b    -$30
                dc.b    -$2C
                dc.b    -$28
                dc.b    -$20
                dc.b    -$18
                dc.b    -$C
                dc.b    -8
                dc.b    -4
                dc.b    0
                dc.b    $40
                dc.b    $30
                dc.b    $28
                dc.b    $20
                dc.b    $18
                dc.b    $10
                dc.b    8
                dc.b    -$10
                dc.b    -$18
                dc.b    -$20
                dc.b    -$40
                even
; ---------------------------------------------------------------------------

HPZCrane_OscillateHiddenWhileWaiting:
                subi.w  #1,$2E(a0)
                bmi.s   HPZCrane_BeginGrowthAndStep
                bsr.w   HPZCrane_TickOscillation
                jmp     (MoveSprite_Circular).l
; ---------------------------------------------------------------------------

HPZCrane_BeginGrowthAndStep:
                move.l  #HPZCrane_GrowRadiusToSubtypeLimit,(a0)

HPZCrane_GrowRadiusToSubtypeLimit:
                move.w  $3A(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$800,d0
                blo.s   HPZCrane_StoreRadiusAndOscillate
                btst    #2,$38(a0)
                beq.s   HPZCrane_StartDwellAndReloadStagger
                cmpi.w  #$C00,d0
                blo.s   HPZCrane_StoreRadiusAndOscillate

HPZCrane_StartDwellAndReloadStagger:
                move.l  #HPZCrane_OscillateUntilRelease,(a0)
                move.w  $32(a0),$2E(a0)

HPZCrane_StoreRadiusAndOscillate:
                move.w  d0,$3A(a0)
                bsr.w   HPZCrane_TickOscillation
                jsr     (MoveSprite_Circular).l
                btst    #2,$38(a0)
                beq.s   HPZCrane_DrawGrowingSegment
                bsr.w   HPZCrane_SelectEightWayFrame

HPZCrane_DrawGrowingSegment:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZCrane_OscillateUntilRelease:
                bsr.w   HPZCrane_TickOscillation
                movea.w $44(a0),a1
                btst    #7,$38(a1)
                beq.s   HPZCrane_SelectSegmentGeometry
                subq.w  #1,$2E(a0)
                bpl.s   HPZCrane_SelectSegmentGeometry
                move.l  #HPZCrane_AlignTowardTargetBy4,(a0)

HPZCrane_SelectSegmentGeometry:
                btst    #2,$38(a0)
                bne.s   HPZCrane_SelectTerminalFrameAndPos
                moveq   #5,d2
                jsr     (MoveSprite_CircularSimple).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZCrane_SelectTerminalFrameAndPos:
                bsr.w   HPZCrane_SelectEightWayFrame
                lea     (AngleLookup_1).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZCrane_AlignTowardTargetBy4:
                move.b  $3C(a0),d0
                moveq   #4,d1
                move.b  $31(a0),d2
                sub.b   d0,d2
                beq.s   HPZCrane_FinishAlignmentAndSignal
                sgt     d3
                bpl.s   HPZCrane_CheckToleranceAndStepSign
                neg.b   d2

HPZCrane_CheckToleranceAndStepSign:
                cmpi.b  #4,d2
                blo.s   HPZCrane_FinishAlignmentAndSignal
                tst.b   d3
                bne.s   HPZCrane_StepWrappedPhaseAndDraw
                neg.b   d1

HPZCrane_StepWrappedPhaseAndDraw:
                add.b   d1,d0
                move.b  d0,$3C(a0)
                bra.s   HPZCrane_SelectSegmentGeometry
; ---------------------------------------------------------------------------

HPZCrane_FinishAlignmentAndSignal:
                move.l  #HPZCrane_WaitForShipHoldSignal,(a0)
                tst.b   subtype(a0)
                bne.s   HPZCrane_DrawAfterAlignmentSignal
                movea.w $44(a0),a1
                moveq   #2,d0
                tst.b   subtype(a1)
                beq.s   HPZCrane_SetGroupReadyBit
                moveq   #3,d0

HPZCrane_SetGroupReadyBit:
                bset    d0,(_unkFAB8).w

HPZCrane_DrawAfterAlignmentSignal:
                bra.s   HPZCrane_SelectSegmentGeometry
; ---------------------------------------------------------------------------

HPZCrane_WaitForShipHoldSignal:
                btst    #4,(_unkFAB8).w
                beq.s   HPZCrane_DrawWhileAwaitingHold
                move.l  #HPZCrane_HoldPositionAndCheckFlicker,(a0)
                move.w  #60-1,$2E(a0)

HPZCrane_DrawWhileAwaitingHold:
                bra.w   HPZCrane_SelectSegmentGeometry
; ---------------------------------------------------------------------------

HPZCrane_HoldPositionAndCheckFlicker:
                btst    #2,$38(a0)
                bne.s   HPZCrane_SelectTerminalFlickerBank
                moveq   #5,d2
                jsr     (MoveSprite_CircularSimple).l
                bra.w   HPZCrane_TickHoldAndSetReturnDelay
; ---------------------------------------------------------------------------

HPZCrane_SelectTerminalFlickerBank:
                moveq   #0,d0
                movea.w $44(a0),a1
                tst.b   subtype(a1)
                beq.s   HPZCrane_AddVBlankParityToFrame
                addq.w  #2,d0

HPZCrane_AddVBlankParityToFrame:
                btst    #0,(V_int_run_count+3).w
                beq.s   HPZCrane_ApplyTerminalFlickerAndMove
                addq.w  #1,d0

HPZCrane_ApplyTerminalFlickerAndMove:
                move.b  HPZCrane_TerminalParityFrameTable(pc,d0.w),mapping_frame(a0)
                lea     (AngleLookup_1).l,a2
                jsr     (MoveSprite_AtAngleLookup).l

HPZCrane_TickHoldAndSetReturnDelay:
                subq.w  #1,$2E(a0)
                bpl.s   HPZCrane_DrawDuringHoldCountdown
                move.l  #HPZCrane_TickReturnStagger,(a0)
                move.w  $32(a0),$2E(a0)

HPZCrane_DrawDuringHoldCountdown:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
HPZCrane_TerminalParityFrameTable:
                dc.b    $15, $1C, $19, $1B
                even
; ---------------------------------------------------------------------------

HPZCrane_TickReturnStagger:
                subq.w  #1,$2E(a0)
                bpl.s   HPZCrane_DrawDuringReturnStagger
                move.l  #HPZCrane_AlignTowardInitialPhaseBy2,(a0)

HPZCrane_DrawDuringReturnStagger:
                bra.w   HPZCrane_SelectSegmentGeometry
; ---------------------------------------------------------------------------

HPZCrane_AlignTowardInitialPhaseBy2:
                move.b  $3C(a0),d0
                moveq   #2,d1
                move.b  $26(a0),d2
                sub.b   d0,d2
                beq.s   HPZCrane_BeginFinalOscillation
                sgt     d3
                bpl.s   HPZCrane_CheckReturnToleranceAndSign
                neg.b   d2

HPZCrane_CheckReturnToleranceAndSign:
                subq.b  #1,d2
                beq.s   HPZCrane_BeginFinalOscillation
                tst.b   d3
                bne.s   HPZCrane_ApplyReturnPhaseStep
                neg.b   d1

HPZCrane_ApplyReturnPhaseStep:
                add.b   d1,d0
                move.b  d0,$3C(a0)
                bra.w   HPZCrane_SelectSegmentGeometry
; ---------------------------------------------------------------------------

HPZCrane_BeginFinalOscillation:
                move.l  #HPZCrane_OscillateAndDrawAfterReturn,(a0)
                clr.b   $39(a0)
                moveq   #1,d0
                btst    #3,$38(a0)
                bne.s   HPZCrane_StoreFinalOscillationStep
                neg.w   d0

HPZCrane_StoreFinalOscillationStep:
                move.b  d0,$40(a0)
                bra.w   HPZCrane_SelectSegmentGeometry
; ---------------------------------------------------------------------------

HPZCrane_OscillateAndDrawAfterReturn:
                bsr.w   HPZCrane_TickOscillation
                bra.w   HPZCrane_SelectSegmentGeometry
; End of function HPZCrane_InitSecondTargetBank
