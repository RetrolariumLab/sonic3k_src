; Owner: rendering/palettes/sk; responsibility: zone cycles
; Source provenance and ranges: config/reconstruction/source_layout.json
AnPal_Load:
                bsr.w   SuperHyper_PalCycle
                moveq   #0,d2
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #6,d0
                move.w  OffsAnPal(pc,d0.w),d0
                jmp     OffsAnPal(pc,d0.w)
; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------
OffsAnPal:
                dc.w    AnPal_AIZ1-OffsAnPal
                dc.w    AnPal_AIZ2-OffsAnPal
                dc.w    AnPal_HCZ1-OffsAnPal
                dc.w    AnPal_HCZ2-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_CNZ-OffsAnPal
                dc.w    AnPal_CNZ-OffsAnPal
                dc.w    AnPal_FBZ-OffsAnPal
                dc.w    AnPal_FBZ-OffsAnPal
                dc.w    AnPal_ICZ-OffsAnPal
                dc.w    AnPal_ICZ-OffsAnPal
                dc.w    AnPal_LBZ1-OffsAnPal
                dc.w    AnPal_LBZ2-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_SOZ1-OffsAnPal
                dc.w    AnPal_SOZ2-OffsAnPal
                dc.w    AnPal_LRZ1-OffsAnPal
                dc.w    AnPal_LRZ2-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_DEZ1-OffsAnPal
                dc.w    AnPal_DEZ2-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_BPZ-OffsAnPal
                dc.w    AnPal_BPZ-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_CGZ-OffsAnPal
                dc.w    AnPal_CGZ-OffsAnPal
                dc.w    AnPal_EMZ-OffsAnPal
                dc.w    AnPal_EMZ-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_Pachinko-OffsAnPal
                dc.w    AnPal_Pachinko-OffsAnPal
                dc.w    AnPal_Slots-OffsAnPal
                dc.w    AnPal_Slots-OffsAnPal
                dc.w    AnPal_LRZ3-OffsAnPal
                dc.w    AnPal_HPZ-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_HPZ-OffsAnPal
; ---------------------------------------------------------------------------

AnPal_None:
                rts
; ---------------------------------------------------------------------------

AnPal_AIZ1:
                move.b  (AIZ1_palette_cycle_flag).w,d0
                bne.s   SKPalAIZ1_TickAltCycle
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalAIZ1_Return
                move.w  #7,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                andi.w  #$18,d0
                lea     (AnPal_PalAIZ1_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$16).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$1A).w
                tst.b   (Palette_cycle_counters+$00).w
                bne.s   SKPalAIZ1_Return
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$30,(Palette_cycle_counters+$02).w
                blo.s   SKPalAIZ1_WriteSecondaryTriplet
                move.w  #0,(Palette_cycle_counters+$02).w

SKPalAIZ1_WriteSecondaryTriplet:
                lea     (AnPal_PalAIZ1_2).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$18).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$1C).w

SKPalAIZ1_Return:
                rts
; ---------------------------------------------------------------------------

SKPalAIZ1_TickAltCycle:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalAIZ1_AltReturn
                move.w  #9,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$50,(Palette_cycle_counter0).w
                blo.s   SKPalAIZ1_WriteAltMainColors
                move.w  #0,(Palette_cycle_counter0).w

SKPalAIZ1_WriteAltMainColors:
                lea     (AnPal_PalAIZ1_3).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$04).w
                move.l  4(a0,d0.w),(Normal_palette_line_4+$08).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$3C,(Palette_cycle_counters+$02).w
                blo.s   SKPalAIZ1_WriteAltTriplet
                move.w  #0,(Palette_cycle_counters+$02).w

SKPalAIZ1_WriteAltTriplet:
                lea     (AnPal_PalAIZ1_4).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$1A).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$1E).w

SKPalAIZ1_AltReturn:
                rts
; ---------------------------------------------------------------------------

AnPal_AIZ2:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalAIZ2_TickSingleColor
                move.w  #5,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                andi.w  #$18,d0
                lea     (AnPal_PalAIZ2_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$18).w
                move.l  4(a0,d0.w),(Normal_palette_line_4+$1C).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$30,(Palette_cycle_counters+$02).w
                blo.s   SKPalAIZ2_PickTripletSource
                move.w  #0,(Palette_cycle_counters+$02).w

SKPalAIZ2_PickTripletSource:
                lea     (AnPal_PalAIZ2_2).l,a0
                cmpi.w  #$3800,(Camera_X_pos).w
                blo.s   SKPalAIZ2_WriteScatteredTriplet
                lea     (AnPal_PalAIZ2_3).l,a0

SKPalAIZ2_WriteScatteredTriplet:
                move.w  (a0,d0.w),(Normal_palette_line_3+$08).w
                move.w  2(a0,d0.w),(Normal_palette_line_3+$10).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$16).w
                move.w  #$A0E,(Normal_palette_line_3+$1C).w
                cmpi.w  #$1C0,(Camera_X_pos).w
                bhs.s   SKPalAIZ2_TickSingleColor
                move.w  4(a0,d0.w),(Normal_palette_line_3+$1C).w

SKPalAIZ2_TickSingleColor:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   SKPalAIZ2_Return
                move.w  #1,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #2,(Palette_cycle_counters+$04).w
                cmpi.w  #$34,(Palette_cycle_counters+$04).w
                blo.s   SKPalAIZ2_PickSingleColorSource
                move.w  #0,(Palette_cycle_counters+$04).w

SKPalAIZ2_PickSingleColorSource:
                lea     (AnPal_PalAIZ2_4).l,a0
                cmpi.w  #$3800,(Camera_X_pos).w
                blo.s   SKPalAIZ2_WriteSingleColor
                lea     (AnPal_PalAIZ2_5).l,a0

SKPalAIZ2_WriteSingleColor:
                move.w  (a0,d0.w),(Normal_palette_line_4+$02).w

SKPalAIZ2_Return:
                rts

; =============== S U B R O U T I N E =======================================

AnPal_HCZ1:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalHCZ1_Return
                move.w  #7,(Palette_cycle_counter1).w
                tst.b   (Palette_cycle_counters+$00).w
                beq.s   SKPalHCZ1_StepCycleOffset
                move.w  #0,(Palette_cycle_counter1).w

SKPalHCZ1_StepCycleOffset:
                lea     (AnPal_PalHCZ1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$20,(Palette_cycle_counter0).w
                blo.s   SKPalHCZ1_MirrorColorsToWater
                move.w  #0,(Palette_cycle_counter0).w

SKPalHCZ1_MirrorColorsToWater:
                move.l  (a0,d0.w),(Normal_palette_line_3+$06).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$0A).w
                move.l  (a0,d0.w),(Water_palette_line_3+$06).w
                move.l  4(a0,d0.w),(Water_palette_line_3+$0A).w

SKPalHCZ1_Return:
                rts
; End of function AnPal_HCZ1

; ---------------------------------------------------------------------------

AnPal_HCZ2:
                rts
; ---------------------------------------------------------------------------

AnPal_CNZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalCNZ_StepSecondTriplet
                move.w  #3,(Palette_cycle_counter1).w
                lea     (AnPal_PalCNZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #6,(Palette_cycle_counter0).w
                cmpi.w  #$60,(Palette_cycle_counter0).w
                blo.s   SKPalCNZ_WriteFirstTriplets
                move.w  #0,(Palette_cycle_counter0).w

SKPalCNZ_WriteFirstTriplets:
                move.l  (a0,d0.w),(Normal_palette_line_4+$12).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$16).w
                lea     (AnPal_PalCNZ_2).l,a0
                move.l  (a0,d0.w),(Water_palette_line_4+$12).w
                move.w  4(a0,d0.w),(Water_palette_line_4+$16).w

; Advance this group on every call, independently of the first group's timer
SKPalCNZ_StepSecondTriplet:
                lea     (AnPal_PalCNZ_3).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$B4,(Palette_cycle_counters+$02).w
                blo.s   SKPalCNZ_WriteSecondTriplets
                move.w  #0,(Palette_cycle_counters+$02).w

SKPalCNZ_WriteSecondTriplets:
                move.l  (a0,d0.w),(Normal_palette_line_3+$12).w
                move.w  4(a0,d0.w),(Normal_palette_line_3+$16).w
                lea     (AnPal_PalCNZ_4).l,a0
                move.l  (a0,d0.w),(Water_palette_line_3+$12).w
                move.w  4(a0,d0.w),(Water_palette_line_3+$16).w
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   SKPalCNZ_Return
                move.w  #2,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalCNZ_5).l,a0
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #4,(Palette_cycle_counters+$04).w
                cmpi.w  #$40,(Palette_cycle_counters+$04).w
                blo.s   SKPalCNZ_WriteThirdPairs
                move.w  #0,(Palette_cycle_counters+$04).w

SKPalCNZ_WriteThirdPairs:
                move.l  (a0,d0.w),(Normal_palette_line_3+$E).w
                lea     (AnPal_PalCNZ_5).l,a0
                move.l  (a0,d0.w),(Water_palette_line_3+$E).w

SKPalCNZ_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_FBZ:
                tst.b   (Level_frame_counter+1).w
                bne.s   SKPalFBZ_Return
                bchg    #0,(ZoneMagnetOrLeafSelectionFlag).w

SKPalFBZ_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_ICZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalICZ_TickSecondPair
                move.w  #5,(Palette_cycle_counter1).w
                lea     (AnPal_PalICZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #4,(Palette_cycle_counter0).w
                cmpi.w  #$40,(Palette_cycle_counter0).w
                blo.s   SKPalette_IczWriteFirstTwoColorPair
                move.w  #0,(Palette_cycle_counter0).w

SKPalette_IczWriteFirstTwoColorPair:
                move.l  (a0,d0.w),(Normal_palette_line_3+$1C).w

SKPalICZ_TickSecondPair:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   SKPalICZ_TickLastPairs
                move.w  #9,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalICZ_2).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #4,(Palette_cycle_counters+$02).w
                cmpi.w  #$48,(Palette_cycle_counters+$02).w
                blo.s   SKPalICZ_TryWriteSecondPair
                move.w  #0,(Palette_cycle_counters+$02).w

SKPalICZ_TryWriteSecondPair:
                tst.w   (Events_bg+$16).w
                beq.s   SKPalICZ_TickLastPairs
                move.l  (a0,d0.w),(Normal_palette_line_4+$1C).w

SKPalICZ_TickLastPairs:
                subq.w  #1,(Palette_cycle_counters+$0A).w
                bpl.s   SKPalICZ_Return
                move.w  #7,(Palette_cycle_counters+$0A).w
                lea     (AnPal_PalICZ_3).l,a0
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #4,(Palette_cycle_counters+$04).w
                cmpi.w  #$18,(Palette_cycle_counters+$04).w
                blo.s   SKPalICZ_TryWriteThirdPair
                move.w  #0,(Palette_cycle_counters+$04).w

; The background event flag gates the third pair. Continue to the fourth pair either way
SKPalICZ_TryWriteThirdPair:
                tst.w   (Events_bg+$16).w
                beq.s   SKPalICZ_StepFourthPair
                move.l  (a0,d0.w),(Normal_palette_line_4+$18).w

SKPalICZ_StepFourthPair:
                lea     (AnPal_PalICZ_4).l,a0
                move.w  (Palette_cycle_counters+$06).w,d0
                addq.w  #4,(Palette_cycle_counters+$06).w
                cmpi.w  #$40,(Palette_cycle_counters+$06).w
                blo.s   SKPalette_IczWriteFourthTwoColorPair
                move.w  #0,(Palette_cycle_counters+$06).w

SKPalette_IczWriteFourthTwoColorPair:
                move.l  (a0,d0.w),(Normal_palette_line_3+$18).w

SKPalICZ_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_LBZ1:
                lea     (AnPal_PalLBZ1).l,a0
                bra.s   SKPalLBZ_TickTriplet
; ---------------------------------------------------------------------------

AnPal_LBZ2:
                lea     (AnPal_PalLBZ2).l,a0

SKPalLBZ_TickTriplet:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalLBZ_Return
                move.w  #3,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #6,(Palette_cycle_counter0).w
                cmpi.w  #$12,(Palette_cycle_counter0).w
                blo.s   SKPalLBZ_WriteTriplet
                move.w  #0,(Palette_cycle_counter0).w

SKPalLBZ_WriteTriplet:
                move.l  (a0,d0.w),(Normal_palette_line_3+$10).w
                move.w  4(a0,d0.w),(Normal_palette_line_3+$14).w

SKPalLBZ_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_SOZ1:
                subq.w  #1,(Palette_cycle_counters+$0A).w
                bpl.s   SKPalSOZ1_Return
                move.w  #5,(Palette_cycle_counters+$0A).w
                lea     (AnPal_PalSOZ1).l,a0
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #8,(Palette_cycle_counters+$04).w
                cmpi.w  #$20,(Palette_cycle_counters+$04).w
                blo.s   SKPalSOZ1_WriteCycleColors
                move.w  #0,(Palette_cycle_counters+$04).w

SKPalSOZ1_WriteCycleColors:
                move.l  (a0,d0.w),(Normal_palette_line_3+$18).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$1C).w

SKPalSOZ1_Return:
                rts
; ---------------------------------------------------------------------------
; unused
                move.w  #900-1,(Palette_cycle_counter1).w
                move.b  #0,(SOZ_darkness_level).w
                move.w  (Palette_cycle_counters+$06).w,d0
                neg.b   d0
                move.b  d0,(Palette_cycle_counters+$00).w
                move.w  #0,(Palette_cycle_counters+$08).w

AnPal_SOZ2:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalSOZ2_TickLightTransition
                move.w  #900-1,(Palette_cycle_counter1).w
                cmpi.b  #5,(SOZ_darkness_level).w
                bhs.s   SKPalSOZ2_TickLightTransition
                addq.b  #1,(SOZ_darkness_level).w
                btst    #0,(SOZ_darkness_level).w
                bne.s   SKPalSOZ2_TickLightTransition
                move.b  #2,(Palette_cycle_counters+$00).w
                move.w  #0,(Palette_cycle_counters+$08).w

SKPalSOZ2_TickLightTransition:
                tst.b   (Palette_cycle_counters+$00).w
                beq.s   SKPalSOZ2_TickColorCycle
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   SKPalSOZ2_TickColorCycle
                move.w  #3,(Palette_cycle_counters+$08).w
                tst.b   (Palette_cycle_counters+$00).w
                bmi.s   SKPalSOZ2_StepNegativeRequest
                subq.b  #1,(Palette_cycle_counters+$00).w
                addi.w  #$34,(Palette_cycle_counters+$02).w
                addq.w  #1,(Palette_cycle_counters+$06).w
                bra.s   SKPalSOZ2_SelectLightPalette
; ---------------------------------------------------------------------------

SKPalSOZ2_StepNegativeRequest:
                addq.b  #1,(Palette_cycle_counters+$00).w
                subi.w  #$34,(Palette_cycle_counters+$02).w
                subq.w  #1,(Palette_cycle_counters+$06).w

SKPalSOZ2_SelectLightPalette:
                move.w  (Palette_cycle_counters+$02).w,d0
                lea     (AnPal_PalSOZ2_Light).l,a0
                lea     (a0,d0.w),a0
                lea     (Normal_palette_line_3+$2).w,a1
                moveq   #$B-1,d0

SKPalSOZ2_CopyLightLine3:
                move.w  (a0)+,(a1)+
                dbf     d0,SKPalSOZ2_CopyLightLine3
                lea     (Normal_palette_line_4+$2).w,a1
                moveq   #$F-1,d0

SKPalSOZ2_CopyLightLine4:
                move.w  (a0)+,(a1)+
                dbf     d0,SKPalSOZ2_CopyLightLine4
                move.w  (Palette_cycle_counters+$04).w,d0
                subq.w  #1,(Palette_cycle_counters+$0A).w
                bpl.s   SKPalSOZ2_WriteCycleAtLightLevel
                bra.s   SKPalSOZ2_StepCycleOffset
; ---------------------------------------------------------------------------

SKPalSOZ2_TickColorCycle:
                subq.w  #1,(Palette_cycle_counters+$0A).w
                bpl.s   SKPalSOZ2_Return

SKPalSOZ2_StepCycleOffset:
                move.w  #5,(Palette_cycle_counters+$0A).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #8,(Palette_cycle_counters+$04).w
                cmpi.w  #$20,(Palette_cycle_counters+$04).w
                blo.s   SKPalSOZ2_WriteCycleAtLightLevel
                move.w  #0,(Palette_cycle_counters+$04).w

SKPalSOZ2_WriteCycleAtLightLevel:
                lea     (AnPal_PalSOZ1).l,a0
                move.w  (Palette_cycle_counters+$06).w,d1
                lsl.w   #5,d1
                lea     (a0,d1.w),a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$18).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$1C).w

SKPalSOZ2_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_LRZ1:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalLRZ1_TickSingleColor
                move.w  #$F,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$80,(Palette_cycle_counter0).w
                blo.s   SKPalLRZ1_WriteMainColors
                move.w  #0,(Palette_cycle_counter0).w

SKPalLRZ1_WriteMainColors:
                lea     (AnPal_PalLRZ12_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$02).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$06).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #4,(Palette_cycle_counters+$02).w
                cmpi.w  #$1C,(Palette_cycle_counters+$02).w
                blo.s   SKPalLRZ1_WriteSecondPair
                move.w  #0,(Palette_cycle_counters+$02).w

SKPalLRZ1_WriteSecondPair:
                lea     (AnPal_PalLRZ12_2).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$02).w

SKPalLRZ1_TickSingleColor:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   SKPalLRZ1_Return
                move.w  #7,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #2,(Palette_cycle_counters+$04).w
                cmpi.w  #$22,(Palette_cycle_counters+$04).w
                blo.s   SKPalLRZ1_WriteSingleColor
                move.w  #0,(Palette_cycle_counters+$04).w

SKPalLRZ1_WriteSingleColor:
                lea     (AnPal_PalLRZ1_3).l,a0
                move.w  (a0,d0.w),(Normal_palette_line_3+$16).w

SKPalLRZ1_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_LRZ2:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalLRZ2_TickThirdGroup
                move.w  #$F,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$80,(Palette_cycle_counter0).w
                blo.s   SKPalLRZ2_WriteMainColors
                move.w  #0,(Palette_cycle_counter0).w

SKPalLRZ2_WriteMainColors:
                lea     (AnPal_PalLRZ12_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$2).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$6).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #4,(Palette_cycle_counters+$02).w
                cmpi.w  #$1C,(Palette_cycle_counters+$02).w
                blo.s   SKPalLRZ2_WriteSecondPair
                move.w  #0,(Palette_cycle_counters+$02).w

SKPalLRZ2_WriteSecondPair:
                lea     (AnPal_PalLRZ12_2).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$2).w

SKPalLRZ2_TickThirdGroup:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   SKPalLRZ2_Return
                move.w  #$F,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #8,(Palette_cycle_counters+$04).w
                cmpi.w  #$100,(Palette_cycle_counters+$04).w
                blo.s   SKPalLRZ2_MirrorThirdPair
                move.w  #0,(Palette_cycle_counters+$04).w

SKPalLRZ2_MirrorThirdPair:
                lea     (AnPal_PalLRZ2_3).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$16).w
; Bug: This mistakenly use the same colors as the first and second indices, rather than the third and fourth
; This was fixed in Sonic Origins
                move.l  (a0,d0.w),(Normal_palette_line_4+$1A).w

SKPalLRZ2_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_DEZ1:
                subq.w  #1,(Palette_cycle_counters+$0A).w
                bpl.s   AnPal_DEZ2
                move.w  #$F,(Palette_cycle_counters+$0A).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #8,(Palette_cycle_counters+$04).w
                cmpi.w  #$30,(Palette_cycle_counters+$04).w
                blo.s   SKPalDEZ1_WriteActColors
                move.w  #0,(Palette_cycle_counters+$04).w

SKPalDEZ1_WriteActColors:
                lea     (AnPal_PalDEZ1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$18).w
                move.l  4(a0,d0.w),(Normal_palette_line_4+$1C).w

AnPal_DEZ2:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalette_DezTickSharedFiveColorGroup
                move.w  #4,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #4,(Palette_cycle_counter0).w
                cmpi.w  #$30,(Palette_cycle_counter0).w
                blo.s   SKPalDEZ_WriteSharedPair
                move.w  #0,(Palette_cycle_counter0).w

SKPalDEZ_WriteSharedPair:
                lea     (AnPal_PalDEZ12_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$1A).w

SKPalette_DezTickSharedFiveColorGroup:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   SKPalDEZ_Return
                move.w  #$13,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addi.w  #$A,(Palette_cycle_counters+$02).w
                cmpi.w  #$28,(Palette_cycle_counters+$02).w
                blo.s   SKPalDEZ_WriteSharedFiveColors
                move.w  #0,(Palette_cycle_counters+$02).w

SKPalDEZ_WriteSharedFiveColors:
                lea     (AnPal_PalDEZ12_2).l,a0
                lea     (a0,d0.w),a0
                lea     (Normal_palette_line_3+$10).w,a1
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.w  (a0)+,(a1)+

SKPalDEZ_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_BPZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalBPZ_TickSecondTriplet
                move.w  #7,(Palette_cycle_counter1).w
                lea     (AnPal_PalBPZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #6,(Palette_cycle_counter0).w
                cmpi.w  #$12,(Palette_cycle_counter0).w
                blo.s   SKPalBPZ_WriteFirstTriplet
                move.w  #0,(Palette_cycle_counter0).w

SKPalBPZ_WriteFirstTriplet:
                move.l  (a0,d0.w),(Normal_palette_line_3+$1A).w
                move.w  4(a0,d0.w),(Normal_palette_line_3+$1E).w

SKPalBPZ_TickSecondTriplet:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   SKPalBPZ_Return
                move.w  #$11,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalBPZ_2).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$7E,(Palette_cycle_counters+$02).w
                blo.s   SKPalette_BpzWriteSecondTriplet
                move.w  #0,(Palette_cycle_counters+$02).w

SKPalette_BpzWriteSecondTriplet:
                move.l  (a0,d0.w),(Normal_palette_line_4+$04).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$08).w

SKPalBPZ_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_CGZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalCGZ_Return
                move.w  #9,(Palette_cycle_counter1).w
                lea     (AnPal_PalCGZ).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$50,(Palette_cycle_counter0).w
                blo.s   SKPalCGZ_WriteCycleColors
                move.w  #0,(Palette_cycle_counter0).w

SKPalCGZ_WriteCycleColors:
                move.l  (a0,d0.w),(Normal_palette_line_3+$04).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$08).w

SKPalCGZ_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_EMZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalEMZ_TickSecondPair
                move.w  #7,(Palette_cycle_counter1).w
                lea     (AnPal_PalEMZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #2,(Palette_cycle_counter0).w
                cmpi.w  #$3C,(Palette_cycle_counter0).w
                blo.s   SKPalEMZ_WriteFirstColor
                move.w  #0,(Palette_cycle_counter0).w

SKPalEMZ_WriteFirstColor:
                move.w  4(a0,d0.w),(Normal_palette_line_3+$1C).w

SKPalEMZ_TickSecondPair:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   SKPalEMZ_Return
                move.w  #$1F,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalEMZ_2).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #4,(Palette_cycle_counters+$02).w
                cmpi.w  #$34,(Palette_cycle_counters+$02).w
                blo.s   SKPalette_EmzWriteSecondTwoColorPair
                move.w  #0,(Palette_cycle_counters+$02).w

SKPalette_EmzWriteSecondTwoColorPair:
                move.l  (a0,d0.w),(Normal_palette_line_4+$12).w

SKPalEMZ_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_Pachinko:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalPachinko_TickSecondGroup
                move.w  #0,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addi.w  #$E,(Palette_cycle_counter0).w
                cmpi.w  #$FC,(Palette_cycle_counter0).w
                blo.s   SKPalPachinko_CopyRamColors
                move.w  #0,(Palette_cycle_counter0).w

SKPalPachinko_CopyRamColors:
                lea     (Chunk_table+$7800).l,a0
                lea     (Normal_palette_line_4+$10).w,a1
                lea     (a0,d0.w),a0
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.w  (a0)+,(a1)+

SKPalPachinko_TickSecondGroup:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   SKPalPachinko_Return
                move.w  #3,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addi.w  #$A,(Palette_cycle_counters+$02).w
                cmpi.w  #$3E8,(Palette_cycle_counters+$02).w
                blo.s   SKPalPachinko_WriteReversedSlices
                move.w  #0,(Palette_cycle_counters+$02).w

; Copy the three five-color source groups in reverse group order
SKPalPachinko_WriteReversedSlices:
                lea     (Chunk_table+$78FC).l,a0
                lea     (Normal_palette_line_3+$2).w,a1
                lea     (a0,d0.w),a0
                move.l  $50(a0),(a1)+
                move.l  $54(a0),(a1)+
                move.w  $58(a0),(a1)+
                move.l  $28(a0),(a1)+
                move.l  $2C(a0),(a1)+
                move.w  $30(a0),(a1)+
                move.l  (a0),(a1)+
                move.l  4(a0),(a1)+
                move.w  8(a0),(a1)+

SKPalPachinko_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_Slots:
                tst.b   (Palette_cycle_counters+$00).w
                bmi.s   SKPalSlots_IdleReturn
                bne.s   SKPalSlots_TickActiveCycle
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalSlots_IdleReturn
                move.w  #3,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$40,(Palette_cycle_counter0).w
                blo.s   SKPalSlots_WriteIdleColors
                move.w  #0,(Palette_cycle_counter0).w

SKPalSlots_WriteIdleColors:
                lea     (AnPal_PalSlots_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$14).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$18).w
                move.w  #$E02,(Normal_palette_line_3+$1C).w
                move.w  #$E02,(Normal_palette_line_4+$1C).w

SKPalSlots_IdleReturn:
                rts
; ---------------------------------------------------------------------------

SKPalSlots_TickActiveCycle:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   SKPalSlots_ActiveReturn
                move.w  #0,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #8,(Palette_cycle_counters+$02).w
                cmpi.w  #$78,(Palette_cycle_counters+$02).w
                blo.s   SKPalSlots_WriteActiveColors
                move.w  #0,(Palette_cycle_counters+$02).w

SKPalSlots_WriteActiveColors:
                lea     (AnPal_PalSlots_2).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$14).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$18).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #2,(Palette_cycle_counters+$04).w
                cmpi.w  #$C,(Palette_cycle_counters+$04).w
                blo.s   SKPalSlots_MirrorActiveColor
                move.w  #0,(Palette_cycle_counters+$04).w

SKPalSlots_MirrorActiveColor:
                lea     (AnPal_PalSlots_3).l,a0
                move.w  (a0,d0.w),(Normal_palette_line_3+$1C).w
                move.w  (a0,d0.w),(Normal_palette_line_4+$1C).w

SKPalSlots_ActiveReturn:
                rts
; ---------------------------------------------------------------------------

AnPal_LRZ3:
                tst.b   (Palette_cycle_counters+$00).w
                bmi.s   SKPalLRZ3_Return
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalLRZ3_TrySecondPair
                move.w  #$F,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$80,(Palette_cycle_counter0).w
                blo.s   SKPalette_LrzThreeWriteMainFourColors
                move.w  #0,(Palette_cycle_counter0).w

SKPalette_LrzThreeWriteMainFourColors:
                lea     (AnPal_PalLRZ12_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$2).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$6).w

SKPalLRZ3_TrySecondPair:
                tst.b   (Palette_cycle_counters+$00).w
                beq.s   SKPalLRZ3_Return
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   SKPalLRZ3_Return
                move.w  #7,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #4,(Palette_cycle_counters+$04).w
                cmpi.w  #$3C,(Palette_cycle_counters+$04).w
                blo.s   SKPalLRZ3_WriteSecondPair
                move.w  #0,(Palette_cycle_counters+$04).w

SKPalLRZ3_WriteSecondPair:
                lea     (AnPal_PalLRZ3).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$18).w

SKPalLRZ3_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_HPZ:
                tst.b   (Palette_cycle_counters+$00).w
                bne.s   SKPalHPZ_Return
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   SKPalHPZ_Return
                move.w  #7,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #4,(Palette_cycle_counter0).w
                cmpi.w  #$28,(Palette_cycle_counter0).w
                blo.s   SKPalHPZ_WriteCyclePair
                move.w  #0,(Palette_cycle_counter0).w

SKPalHPZ_WriteCyclePair:
                lea     (AnPal_PalHPZ).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$2).w

SKPalHPZ_Return:
                rts
; ---------------------------------------------------------------------------
