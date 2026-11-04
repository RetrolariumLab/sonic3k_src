; Owner: rendering/palettes/s3; responsibility: zone cycles
; Source provenance and ranges: config/reconstruction/source_layout.json
AnPal_Load:
                bsr.w   SuperSonic_PalCycle
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
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_LRZ1-OffsAnPal
                dc.w    AnPal_LRZ2-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
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
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
                dc.w    AnPal_None-OffsAnPal
; ---------------------------------------------------------------------------

AnPal_None:
                rts
; ---------------------------------------------------------------------------

AnPal_AIZ1:
                move.b  (AIZ1_palette_cycle_flag).w,d0
                bne.s   S3PalAIZ1_TickAltCycle
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   S3PalAIZ1_Return
                move.w  #7,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                andi.w  #$18,d0
                lea     (AnPal_PalAIZ1_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$16).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$1A).w
                tst.b   (Palette_cycle_counters+$00).w
                bne.s   S3PalAIZ1_Return
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$30,(Palette_cycle_counters+$02).w
                blo.s   S3PalAIZ1_WriteSecondaryTriplet
                move.w  #0,(Palette_cycle_counters+$02).w

S3PalAIZ1_WriteSecondaryTriplet:
                lea     (AnPal_PalAIZ1_2).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$18).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$1C).w

S3PalAIZ1_Return:
                rts
; ---------------------------------------------------------------------------

S3PalAIZ1_TickAltCycle:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   S3PalAIZ1_AltReturn
                move.w  #9,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$50,(Palette_cycle_counter0).w
                blo.s   S3PalAIZ1_WriteAltMainColors
                move.w  #0,(Palette_cycle_counter0).w

S3PalAIZ1_WriteAltMainColors:
                lea     (AnPal_PalAIZ1_3).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$04).w
                move.l  4(a0,d0.w),(Normal_palette_line_4+$08).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$3C,(Palette_cycle_counters+$02).w
                blo.s   S3PalAIZ1_WriteAltTriplet
                move.w  #0,(Palette_cycle_counters+$02).w

S3PalAIZ1_WriteAltTriplet:
                lea     (AnPal_PalAIZ1_4).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$1A).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$1E).w

S3PalAIZ1_AltReturn:
                rts
; ---------------------------------------------------------------------------

AnPal_AIZ2:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   S3PalAIZ2_TickSingleColor
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
                blo.s   S3PalAIZ2_PickTripletSource
                move.w  #0,(Palette_cycle_counters+$02).w

S3PalAIZ2_PickTripletSource:
                lea     (AnPal_PalAIZ2_2).l,a0
                cmpi.w  #$3800,(Camera_X_pos).w
                blo.s   S3PalAIZ2_WriteScatteredTriplet
                lea     (AnPal_PalAIZ2_3).l,a0

S3PalAIZ2_WriteScatteredTriplet:
                move.w  (a0,d0.w),(Normal_palette_line_3+$08).w
                move.w  2(a0,d0.w),(Normal_palette_line_3+$10).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$16).w
                move.w  #$A0E,(Normal_palette_line_3+$1C).w
                cmpi.w  #$1C0,(Camera_X_pos).w
                bhs.s   S3PalAIZ2_TickSingleColor
                move.w  4(a0,d0.w),(Normal_palette_line_3+$1C).w

S3PalAIZ2_TickSingleColor:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   S3PalAIZ2_Return
                move.w  #1,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #2,(Palette_cycle_counters+$04).w
                cmpi.w  #$34,(Palette_cycle_counters+$04).w
                blo.s   S3PalAIZ2_PickSingleColorSource
                move.w  #0,(Palette_cycle_counters+$04).w

S3PalAIZ2_PickSingleColorSource:
                lea     (AnPal_PalAIZ2_4).l,a0
                cmpi.w  #$3800,(Camera_X_pos).w
                blo.s   S3PalAIZ2_WriteSingleColor
                lea     (AnPal_PalAIZ2_5).l,a0

S3PalAIZ2_WriteSingleColor:
                move.w  (a0,d0.w),(Normal_palette_line_4+$02).w

S3PalAIZ2_Return:
                rts

; =============== S U B R O U T I N E =======================================

AnPal_HCZ1:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   S3PalHCZ1_Return
                move.w  #7,(Palette_cycle_counter1).w
                tst.b   (Palette_cycle_counters+$00).w
                beq.s   S3PalHCZ1_StepCycleOffset
                move.w  #0,(Palette_cycle_counter1).w

S3PalHCZ1_StepCycleOffset:
                lea     (AnPal_PalHCZ1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$20,(Palette_cycle_counter0).w
                blo.s   S3PalHCZ1_MirrorColorsToWater
                move.w  #0,(Palette_cycle_counter0).w

S3PalHCZ1_MirrorColorsToWater:
                move.l  (a0,d0.w),(Normal_palette_line_3+$06).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$0A).w
                move.l  (a0,d0.w),(Water_palette_line_3+$06).w
                move.l  4(a0,d0.w),(Water_palette_line_3+$0A).w

S3PalHCZ1_Return:
                rts
; End of function AnPal_HCZ1

; ---------------------------------------------------------------------------

AnPal_HCZ2:
                rts
; ---------------------------------------------------------------------------

AnPal_CNZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   S3PalCNZ_StepSecondTriplet
                move.w  #3,(Palette_cycle_counter1).w
                lea     (AnPal_PalCNZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #6,(Palette_cycle_counter0).w
                cmpi.w  #$60,(Palette_cycle_counter0).w
                blo.s   S3PalCNZ_WriteFirstTriplets
                move.w  #0,(Palette_cycle_counter0).w

S3PalCNZ_WriteFirstTriplets:
                move.l  (a0,d0.w),(Normal_palette_line_4+$12).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$16).w
                lea     (AnPal_PalCNZ_2).l,a0
                move.l  (a0,d0.w),(Water_palette_line_4+$12).w
                move.w  4(a0,d0.w),(Water_palette_line_4+$16).w

; Advance this group on every call, independently of the first group's timer
S3PalCNZ_StepSecondTriplet:
                lea     (AnPal_PalCNZ_3).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$B4,(Palette_cycle_counters+$02).w
                blo.s   S3PalCNZ_WriteSecondTriplets
                move.w  #0,(Palette_cycle_counters+$02).w

S3PalCNZ_WriteSecondTriplets:
                move.l  (a0,d0.w),(Normal_palette_line_3+$12).w
                move.w  4(a0,d0.w),(Normal_palette_line_3+$16).w
                lea     (AnPal_PalCNZ_4).l,a0
                move.l  (a0,d0.w),(Water_palette_line_3+$12).w
                move.w  4(a0,d0.w),(Water_palette_line_3+$16).w
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   S3PalCNZ_Return
                move.w  #2,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalCNZ_5).l,a0
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #4,(Palette_cycle_counters+$04).w
                cmpi.w  #$40,(Palette_cycle_counters+$04).w
                blo.s   S3PalCNZ_WriteThirdPairs
                move.w  #0,(Palette_cycle_counters+$04).w

S3PalCNZ_WriteThirdPairs:
                move.l  (a0,d0.w),(Normal_palette_line_3+$E).w
                lea     (AnPal_PalCNZ_5).l,a0
                move.l  (a0,d0.w),(Water_palette_line_3+$E).w

S3PalCNZ_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_FBZ:
                rts
; ---------------------------------------------------------------------------

AnPal_ICZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   S3PalICZ_TickSecondPair
                move.w  #5,(Palette_cycle_counter1).w
                lea     (AnPal_PalICZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #4,(Palette_cycle_counter0).w
                cmpi.w  #$40,(Palette_cycle_counter0).w
                blo.s   S3Palette_IczWriteFirstTwoColorPair
                move.w  #0,(Palette_cycle_counter0).w

S3Palette_IczWriteFirstTwoColorPair:
                move.l  (a0,d0.w),(Normal_palette_line_3+$1C).w

S3PalICZ_TickSecondPair:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   S3PalICZ_TickLastPairs
                move.w  #9,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalICZ_2).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #4,(Palette_cycle_counters+$02).w
                cmpi.w  #$48,(Palette_cycle_counters+$02).w
                blo.s   S3PalICZ_TryWriteSecondPair
                move.w  #0,(Palette_cycle_counters+$02).w

S3PalICZ_TryWriteSecondPair:
                tst.w   (Events_bg+$16).w
                beq.s   S3PalICZ_TickLastPairs
                move.l  (a0,d0.w),(Normal_palette_line_4+$1C).w

S3PalICZ_TickLastPairs:
                subq.w  #1,(Palette_cycle_counters+$0A).w
                bpl.s   S3PalICZ_Return
                move.w  #7,(Palette_cycle_counters+$0A).w
                lea     (AnPal_PalICZ_3).l,a0
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #4,(Palette_cycle_counters+$04).w
                cmpi.w  #$18,(Palette_cycle_counters+$04).w
                blo.s   S3PalICZ_TryWriteThirdPair
                move.w  #0,(Palette_cycle_counters+$04).w

; The background event flag gates the third pair. Continue to the fourth pair either way
S3PalICZ_TryWriteThirdPair:
                tst.w   (Events_bg+$16).w
                beq.s   S3PalICZ_StepFourthPair
                move.l  (a0,d0.w),(Normal_palette_line_4+$18).w

S3PalICZ_StepFourthPair:
                lea     (AnPal_PalICZ_4).l,a0
                move.w  (Palette_cycle_counters+$06).w,d0
                addq.w  #4,(Palette_cycle_counters+$06).w
                cmpi.w  #$40,(Palette_cycle_counters+$06).w
                blo.s   S3Palette_IczWriteFourthTwoColorPair
                move.w  #0,(Palette_cycle_counters+$06).w

S3Palette_IczWriteFourthTwoColorPair:
                move.l  (a0,d0.w),(Normal_palette_line_3+$18).w

S3PalICZ_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_LBZ1:
                lea     (AnPal_PalLBZ1).l,a0
                bra.s   S3PalLBZ_TickTriplet
; ---------------------------------------------------------------------------

AnPal_LBZ2:
                lea     (AnPal_PalLBZ2).l,a0

S3PalLBZ_TickTriplet:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   S3PalLBZ_Return
                move.w  #3,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #6,(Palette_cycle_counter0).w
                cmpi.w  #$12,(Palette_cycle_counter0).w
                blo.s   S3PalLBZ_WriteTriplet
                move.w  #0,(Palette_cycle_counter0).w

S3PalLBZ_WriteTriplet:
                move.l  (a0,d0.w),(Normal_palette_line_3+$10).w
                move.w  4(a0,d0.w),(Normal_palette_line_3+$14).w

S3PalLBZ_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_LRZ1:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   S3PalLRZ1_Return
                move.w  #$F,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$80,(Palette_cycle_counter0).w
                blo.s   S3PalLRZ1_WriteMainColors
                move.w  #0,(Palette_cycle_counter0).w

S3PalLRZ1_WriteMainColors:
                lea     (AnPal_PalLRZ1_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$02).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$06).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #4,(Palette_cycle_counters+$02).w
                cmpi.w  #$1C,(Palette_cycle_counters+$02).w
                blo.s   S3PalLRZ1_WriteSecondPair
                move.w  #0,(Palette_cycle_counters+$02).w

S3PalLRZ1_WriteSecondPair:
                lea     (AnPal_PalLRZ1_2).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$02).w

S3PalLRZ1_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_LRZ2:
                rts
; ---------------------------------------------------------------------------

AnPal_BPZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   S3PalBPZ_TickSecondTriplet
                move.w  #7,(Palette_cycle_counter1).w
                lea     (AnPal_PalBPZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #6,(Palette_cycle_counter0).w
                cmpi.w  #$12,(Palette_cycle_counter0).w
                blo.s   S3PalBPZ_WriteFirstTriplet
                move.w  #0,(Palette_cycle_counter0).w

S3PalBPZ_WriteFirstTriplet:
                move.l  (a0,d0.w),(Normal_palette_line_3+$1A).w
                move.w  4(a0,d0.w),(Normal_palette_line_3+$1E).w

S3PalBPZ_TickSecondTriplet:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   S3PalBPZ_Return
                move.w  #$11,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalBPZ_2).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$7E,(Palette_cycle_counters+$02).w
                blo.s   S3Palette_BpzWriteSecondTriplet
                move.w  #0,(Palette_cycle_counters+$02).w

S3Palette_BpzWriteSecondTriplet:
                move.l  (a0,d0.w),(Normal_palette_line_4+$04).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$08).w

S3PalBPZ_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_CGZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   S3PalCGZ_Return
                move.w  #9,(Palette_cycle_counter1).w
                lea     (AnPal_PalCGZ).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$50,(Palette_cycle_counter0).w
                blo.s   S3PalCGZ_WriteCycleColors
                move.w  #0,(Palette_cycle_counter0).w

S3PalCGZ_WriteCycleColors:
                move.l  (a0,d0.w),(Normal_palette_line_3+$04).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$08).w

S3PalCGZ_Return:
                rts
; ---------------------------------------------------------------------------

AnPal_EMZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   S3PalEMZ_TickSecondPair
                move.w  #7,(Palette_cycle_counter1).w
                lea     (AnPal_PalEMZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #2,(Palette_cycle_counter0).w
                cmpi.w  #$3C,(Palette_cycle_counter0).w
                blo.s   S3PalEMZ_WriteFirstColor
                move.w  #0,(Palette_cycle_counter0).w

S3PalEMZ_WriteFirstColor:
                move.w  4(a0,d0.w),(Normal_palette_line_3+$1C).w

S3PalEMZ_TickSecondPair:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   S3PalEMZ_Return
                move.w  #$1F,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalEMZ_2).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #4,(Palette_cycle_counters+$02).w
                cmpi.w  #$34,(Palette_cycle_counters+$02).w
                blo.s   S3Palette_EmzWriteSecondTwoColorPair
                move.w  #0,(Palette_cycle_counters+$02).w

S3Palette_EmzWriteSecondTwoColorPair:
                move.l  (a0,d0.w),(Normal_palette_line_4+$12).w

S3PalEMZ_Return:
                rts
; ---------------------------------------------------------------------------
