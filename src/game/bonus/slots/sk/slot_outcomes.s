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
                bra.w   loc_4C416
; ---------------------------------------------------------------------------
                bra.w   loc_4C462
; ---------------------------------------------------------------------------
                bra.w   loc_4C480
; ---------------------------------------------------------------------------
                bra.w   loc_4C540
; ---------------------------------------------------------------------------
                bra.w   loc_4C576
; ---------------------------------------------------------------------------
                bra.w   loc_4C6BC
; ---------------------------------------------------------------------------
                rts
; ---------------------------------------------------------------------------

loc_4C416:
                movea.l a4,a1
                moveq   #8,d0

loc_4C41A:
                clr.w   (a1)+
                dbf     d0,loc_4C41A
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

loc_4C462:
                bsr.w   SlotsAdvanceOneReelAndQueueChangedStripArt
                tst.b   1(a4)
                beq.s   loc_4C46E
                rts
; ---------------------------------------------------------------------------

loc_4C46E:
                move.b  #$18,(a4)
                clr.w   8(a4)
                clr.w   $C(a4)
                clr.w   $10(a4)
                rts
; ---------------------------------------------------------------------------

loc_4C480:
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
                lea     (byte_4C8B4).l,a2

loc_4C4DC:
                sub.b   (a2),d0
                bcs.s   loc_4C4E4
                addq.w  #3,a2
                bra.s   loc_4C4DC
; ---------------------------------------------------------------------------

loc_4C4E4:
                cmpi.b  #-1,(a2)
                beq.s   loc_4C4F8
                move.b  1(a2),4(a4)
                move.b  2(a2),5(a4)
                rts
; ---------------------------------------------------------------------------

loc_4C4F8:
                jsr     (Random_Number).l
                add.w   (V_int_run_count+2).w,d0
                ror.w   #4,d0
                move.w  d0,d1
                andi.w  #7,d1
                lea     (byte_4C8CC).l,a1
                move.b  (a1,d1.w),4(a4)
                lsr.w   #3,d0
                move.b  d0,d1
                andi.w  #7,d1
                lea     (byte_4C8D4).l,a1
                move.b  (a1,d1.w),d2
                lsl.b   #4,d2
                lsr.w   #3,d0
                andi.w  #7,d0
                lea     (byte_4C8DC).l,a1
                or.b    (a1,d0.w),d2
                move.b  d2,5(a4)
                rts
; ---------------------------------------------------------------------------

loc_4C540:
                bsr.w   SlotsAdvanceOneReelAndQueueChangedStripArt
                tst.b   1(a4)
                beq.s   loc_4C54C
                rts
; ---------------------------------------------------------------------------

loc_4C54C:
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

loc_4C576:
                bsr.w   SlotsAdvanceOneReelAndQueueChangedStripArt
                cmpi.b  #$C,9(a4)
                bne.s   loc_4C594
                cmpi.b  #$C,$D(a4)
                bne.s   loc_4C594
                cmpi.b  #$C,$11(a4)
                beq.w   loc_4C6BC

loc_4C594:
                moveq   #0,d0
                move.b  3(a4),d0
                lea     6(a4),a1
                adda.w  d0,a1
                lea     (byte_4C8CC).l,a3
                add.w   d0,d0
                adda.w  d0,a3
                moveq   #0,d0
                move.b  3(a1),d0
                jmp     loc_4C5B4(pc,d0.w)
; ---------------------------------------------------------------------------

loc_4C5B4:
                bra.w   loc_4C602
; ---------------------------------------------------------------------------
                bra.w   loc_4C63E
; ---------------------------------------------------------------------------
                bra.w   loc_4C6A8
; ---------------------------------------------------------------------------
                bra.w   locret_4C6BA

; =============== S U B R O U T I N E =======================================

SlotsGetSelectedPackedSymbolAndNormalizeSevenToFive:
                move.w  4(a4),d1
                move.b  3(a4),d0
                beq.s   loc_4C5D0
                lsr.w   d0,d1

loc_4C5D0:
                andi.w  #7,d1
                cmpi.b  #6,d1
                bgt.s   loc_4C5DC
                rts
; ---------------------------------------------------------------------------

loc_4C5DC:
                subq.b  #2,d1
                rts
; End of function SlotsGetSelectedPackedSymbolAndNormalizeSevenToFive

; =============== S U B R O U T I N E =======================================

SlotsReplaceSelectedOutcomeNibbleAndMaskSymbolBits:
                move.w  #$FFF0,d2
                andi.w  #$F,d1
                move.b  3(a4),d0
                beq.s   loc_4C5F2
                lsl.w   d0,d1
                rol.w   d0,d2

loc_4C5F2:
                and.w   d2,4(a4)
                or.w    d1,4(a4)
                andi.w  #$777,4(a4)
                rts
; End of function SlotsReplaceSelectedOutcomeNibbleAndMaskSymbolBits

; ---------------------------------------------------------------------------

loc_4C602:
                tst.b   3(a4)
                bne.s   loc_4C610
                tst.b   1(a4)
                bmi.s   loc_4C61A
                rts
; ---------------------------------------------------------------------------

loc_4C610:
                cmpi.b  #8,-1(a1)
                bge.s   loc_4C61A
                rts
; ---------------------------------------------------------------------------

loc_4C61A:
                bsr.s   SlotsGetSelectedPackedSymbolAndNormalizeSevenToFive
                move.w  (a1),d0
                subi.w  #$A0,d0
                lsr.w   #8,d0
                andi.w  #7,d0
                move.b  (a3,d0.w),d0
                cmp.b   d1,d0
                beq.s   loc_4C632
                rts
; ---------------------------------------------------------------------------

loc_4C632:
                addq.b  #4,3(a1)
                move.b  #$60,2(a1)
                rts
; ---------------------------------------------------------------------------

loc_4C63E:
                bsr.s   SlotsGetSelectedPackedSymbolAndNormalizeSevenToFive
                move.w  (a1),d0
                addi.w  #$F0,d0
                andi.w  #$700,d0
                lsr.w   #8,d0
                move.b  (a3,d0.w),d0
                cmp.b   d0,d1
                beq.s   loc_4C67C
                cmpi.b  #$20,2(a1)
                bls.s   loc_4C662
                subi.b  #$C,2(a1)

loc_4C662:
                cmpi.b  #$18,2(a1)
                bgt.s   loc_4C66C
                rts
; ---------------------------------------------------------------------------

loc_4C66C:
                cmpi.b  #$80,1(a1)
                bls.s   loc_4C676
                rts
; ---------------------------------------------------------------------------

loc_4C676:
                subq.b  #2,2(a1)
                rts
; ---------------------------------------------------------------------------

loc_4C67C:
                move.w  (a1),d0
                addi.w  #$80,d0
                move.w  d0,d1
                andi.w  #$700,d1
                subi.w  #$10,d1
                move.w  d1,(a1)
                lsr.w   #8,d0
                andi.w  #7,d0
                move.b  (a3,d0.w),d1
                bsr.w   SlotsReplaceSelectedOutcomeNibbleAndMaskSymbolBits
                move.b  #-8,2(a1)
                addq.b  #4,3(a1)
                rts
; ---------------------------------------------------------------------------

loc_4C6A8:
                tst.b   1(a1)
                beq.s   loc_4C6B0
                rts
; ---------------------------------------------------------------------------

loc_4C6B0:
                clr.b   2(a1)
                addq.b  #4,3(a1)
                rts
; ---------------------------------------------------------------------------

locret_4C6BA:
                rts
; ---------------------------------------------------------------------------

loc_4C6BC:
                clr.w   8(a4)
                clr.w   $C(a4)
                clr.w   $10(a4)
                clr.b   1(a4)
                bsr.w   SlotsEvaluateTripleWildcardOrSymbolSixPayout
                move.b  #$18,(a4)
                rts

; =============== S U B R O U T I N E =======================================

SlotsAdvanceOneReelAndQueueChangedStripArt:
                moveq   #0,d0
                move.b  3(a4),d0
                lea     6(a4),a1
                adda.w  d0,a1
                lea     (byte_4C8CC).l,a3
                adda.w  d0,a3
                adda.w  d0,a3
                jmp     loc_4C6F0(pc,d0.w)
; End of function SlotsAdvanceOneReelAndQueueChangedStripArt

; ---------------------------------------------------------------------------

loc_4C6F0:
                bra.w   loc_4C706
; ---------------------------------------------------------------------------
                bra.w   loc_4C712
; ---------------------------------------------------------------------------
                clr.b   3(a4)
                subq.b  #1,1(a4)
                move.w  #$4400,d2
                bra.s   loc_4C71A
; ---------------------------------------------------------------------------

loc_4C706:
                addq.b  #4,3(a4)
                move.w  #$4000,d2
                bra.w   loc_4C71A
; ---------------------------------------------------------------------------

loc_4C712:
                addq.b  #4,3(a4)
                move.w  #$4200,d2

loc_4C71A:
                move.w  (a1),d0
                move.b  2(a1),d1
                ext.w   d1
                sub.w   d1,(a1)
                move.w  (a1),d3
                andi.w  #$7F8,d0
                andi.w  #$7F8,d3
                cmp.w   d0,d3
                bne.s   loc_4C734
                rts
; ---------------------------------------------------------------------------

loc_4C734:
                bsr.w   SlotsResolveSymbolStripRowArtPointer
                lea     (Chunk_table+$7C00).l,a1
                move.w  #$20-1,d1

loc_4C742:
                move.l  $80(a2),$80(a1)
                move.l  $100(a2),$100(a1)
                move.l  $180(a2),$180(a1)
                move.l  (a2)+,(a1)+
                addq.b  #8,d3
                bne.s   loc_4C766
                addi.w  #$100,d3
                andi.w  #$700,d3
                bsr.w   SlotsResolveSymbolStripRowArtPointer

loc_4C766:
                dbf     d1,loc_4C742
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

SlotsEvaluateTripleWildcardOrSymbolSixPayout:
                move.b  5(a4),d2
                move.b  d2,d3
                andi.w  #$F0,d2
                lsr.w   #4,d2
                andi.w  #$F,d3
                moveq   #0,d0
                cmp.b   4(a4),d2
                bne.s   loc_4C7BC
                addq.w  #4,d0

loc_4C7BC:
                cmp.b   4(a4),d3
                bne.s   loc_4C7C4
                addq.w  #8,d0

loc_4C7C4:
                jmp     loc_4C7C8(pc,d0.w)
; End of function SlotsEvaluateTripleWildcardOrSymbolSixPayout

; ---------------------------------------------------------------------------

loc_4C7C8:
                bra.w   loc_4C838
; ---------------------------------------------------------------------------
                bra.w   loc_4C80E
; ---------------------------------------------------------------------------
                bra.w   loc_4C7E0
; ---------------------------------------------------------------------------
                move.w  d2,d0
                bsr.w   SlotsLookupSignedBasePayoutBySymbol
                move.w  d0,4(a4)
                rts
; ---------------------------------------------------------------------------

loc_4C7E0:
                cmpi.b  #0,d3
                bne.s   loc_4C7F6
                move.w  d2,d0
                bsr.w   SlotsLookupSignedBasePayoutBySymbol
                bsr.w   SlotsMultiplySignedPayoutBy4
                move.w  d0,4(a4)
                rts
; ---------------------------------------------------------------------------

loc_4C7F6:
                cmpi.b  #0,d2
                bne.w   loc_4C838
                move.w  d3,d0
                bsr.w   SlotsLookupSignedBasePayoutBySymbol
                bsr.w   SlotsMultiplySignedPayoutBy2
                move.w  d0,4(a4)
                rts
; ---------------------------------------------------------------------------

loc_4C80E:
                cmpi.b  #0,d2
                bne.s   loc_4C822
                move.w  d3,d0
                bsr.s   SlotsLookupSignedBasePayoutBySymbol
                bsr.w   SlotsMultiplySignedPayoutBy4
                move.w  d0,4(a4)
                rts
; ---------------------------------------------------------------------------

loc_4C822:
                cmpi.b  #0,d3
                bne.w   loc_4C838
                move.w  d2,d0
                bsr.s   SlotsLookupSignedBasePayoutBySymbol
                bsr.w   SlotsMultiplySignedPayoutBy2
                move.w  d0,4(a4)
                rts
; ---------------------------------------------------------------------------

loc_4C838:
                cmp.b   d2,d3
                bne.s   loc_4C86C
                cmpi.b  #0,4(a4)
                bne.s   loc_4C852
                move.w  d2,d0
                bsr.s   SlotsLookupSignedBasePayoutBySymbol
                bsr.w   SlotsMultiplySignedPayoutBy2
                move.w  d0,4(a4)
                rts
; ---------------------------------------------------------------------------

loc_4C852:
                cmpi.b  #0,d2
                bne.s   loc_4C86C
                move.b  4(a4),d0
                andi.w  #$F,d0
                bsr.s   SlotsLookupSignedBasePayoutBySymbol
                bsr.w   SlotsMultiplySignedPayoutBy4
                move.w  d0,4(a4)
                rts
; ---------------------------------------------------------------------------

loc_4C86C:
                moveq   #2,d1
                moveq   #0,d0
                cmpi.b  #6,4(a4)
                bne.s   loc_4C87A
                add.w   d1,d0

loc_4C87A:
                cmpi.b  #6,d2
                bne.s   loc_4C882
                add.w   d1,d0

loc_4C882:
                cmpi.b  #6,d3
                bne.s   loc_4C88A
                add.w   d1,d0

loc_4C88A:
                move.w  d0,4(a4)

; =============== S U B R O U T I N E =======================================

SlotsLookupSignedBasePayoutBySymbol:
                add.w   d0,d0
                lea     (word_4C8A4).l,a2
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
word_4C8A4:
                dc.w    100
                dc.w    30
                dc.w    20
                dc.w    25
                dc.w    -1
                dc.w    10
                dc.w    8
                dc.w    200
byte_4C8B4:
                dc.b    4,   0,   0
                dc.b    9,   1, $11
                dc.b    4,   3, $33
                dc.b    $12,   4, $44
                dc.b    9,   2, $22
                dc.b    $F,   5, $55
                dc.b    $F,   6, $66
                dc.b    $FF,  $F, $FF
byte_4C8CC:
                dc.b    0,   1,   2,   5,   4,   6,   5,   3
byte_4C8D4:
                dc.b    0,   1,   2,   5,   4,   6,   1,   3
byte_4C8DC:
                dc.b    0,   1,   2,   5,   4,   6,   3,   5

; =============== S U B R O U T I N E =======================================

BlueSphereResetSceneVideoQueuesAndRuntimeMemory:
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
; End of function BlueSphereResetSceneVideoQueuesAndRuntimeMemory
