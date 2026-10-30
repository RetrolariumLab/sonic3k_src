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
                bne.s   loc_24A6
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_24A4
                move.w  #7,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                andi.w  #$18,d0
                lea     (AnPal_PalAIZ1_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$16).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$1A).w
                tst.b   (Palette_cycle_counters+$00).w
                bne.s   locret_24A4
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$30,(Palette_cycle_counters+$02).w
                blo.s   loc_2492
                move.w  #0,(Palette_cycle_counters+$02).w

loc_2492:
                lea     (AnPal_PalAIZ1_2).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$18).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$1C).w

locret_24A4:
                rts
; ---------------------------------------------------------------------------

loc_24A6:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_2502
                move.w  #9,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$50,(Palette_cycle_counter0).w
                blo.s   loc_24C8
                move.w  #0,(Palette_cycle_counter0).w

loc_24C8:
                lea     (AnPal_PalAIZ1_3).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$04).w
                move.l  4(a0,d0.w),(Normal_palette_line_4+$08).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$3C,(Palette_cycle_counters+$02).w
                blo.s   loc_24F0
                move.w  #0,(Palette_cycle_counters+$02).w

loc_24F0:
                lea     (AnPal_PalAIZ1_4).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$1A).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$1E).w

locret_2502:
                rts
; ---------------------------------------------------------------------------

AnPal_AIZ2:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_257E
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
                blo.s   loc_2544
                move.w  #0,(Palette_cycle_counters+$02).w

loc_2544:
                lea     (AnPal_PalAIZ2_2).l,a0
                cmpi.w  #$3800,(Camera_X_pos).w
                blo.s   loc_2558
                lea     (AnPal_PalAIZ2_3).l,a0

loc_2558:
                move.w  (a0,d0.w),(Normal_palette_line_3+$08).w
                move.w  2(a0,d0.w),(Normal_palette_line_3+$10).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$16).w
                move.w  #$A0E,(Normal_palette_line_3+$1C).w
                cmpi.w  #$1C0,(Camera_X_pos).w
                bhs.s   loc_257E
                move.w  4(a0,d0.w),(Normal_palette_line_3+$1C).w

loc_257E:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   locret_25BA
                move.w  #1,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #2,(Palette_cycle_counters+$04).w
                cmpi.w  #$34,(Palette_cycle_counters+$04).w
                blo.s   loc_25A0
                move.w  #0,(Palette_cycle_counters+$04).w

loc_25A0:
                lea     (AnPal_PalAIZ2_4).l,a0
                cmpi.w  #$3800,(Camera_X_pos).w
                blo.s   loc_25B4
                lea     (AnPal_PalAIZ2_5).l,a0

loc_25B4:
                move.w  (a0,d0.w),(Normal_palette_line_4+$02).w

locret_25BA:
                rts

; =============== S U B R O U T I N E =======================================

AnPal_HCZ1:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_2608
                move.w  #7,(Palette_cycle_counter1).w
                tst.b   (Palette_cycle_counters+$00).w
                beq.s   loc_25D4
                move.w  #0,(Palette_cycle_counter1).w

loc_25D4:
                lea     (AnPal_PalHCZ1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$20,(Palette_cycle_counter0).w
                blo.s   loc_25F0
                move.w  #0,(Palette_cycle_counter0).w

loc_25F0:
                move.l  (a0,d0.w),(Normal_palette_line_3+$06).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$0A).w
                move.l  (a0,d0.w),(Water_palette_line_3+$06).w
                move.l  4(a0,d0.w),(Water_palette_line_3+$0A).w

locret_2608:
                rts
; End of function AnPal_HCZ1

; ---------------------------------------------------------------------------

AnPal_HCZ2:
                rts
; ---------------------------------------------------------------------------

AnPal_CNZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_2652
                move.w  #3,(Palette_cycle_counter1).w
                lea     (AnPal_PalCNZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #6,(Palette_cycle_counter0).w
                cmpi.w  #$60,(Palette_cycle_counter0).w
                blo.s   loc_2634
                move.w  #0,(Palette_cycle_counter0).w

loc_2634:
                move.l  (a0,d0.w),(Normal_palette_line_4+$12).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$16).w
                lea     (AnPal_PalCNZ_2).l,a0
                move.l  (a0,d0.w),(Water_palette_line_4+$12).w
                move.w  4(a0,d0.w),(Water_palette_line_4+$16).w

loc_2652:
                lea     (AnPal_PalCNZ_3).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$B4,(Palette_cycle_counters+$02).w
                blo.s   loc_266E
                move.w  #0,(Palette_cycle_counters+$02).w

loc_266E:
                move.l  (a0,d0.w),(Normal_palette_line_3+$12).w
                move.w  4(a0,d0.w),(Normal_palette_line_3+$16).w
                lea     (AnPal_PalCNZ_4).l,a0
                move.l  (a0,d0.w),(Water_palette_line_3+$12).w
                move.w  4(a0,d0.w),(Water_palette_line_3+$16).w
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   locret_26C6
                move.w  #2,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalCNZ_5).l,a0
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #4,(Palette_cycle_counters+$04).w
                cmpi.w  #$40,(Palette_cycle_counters+$04).w
                blo.s   loc_26B4
                move.w  #0,(Palette_cycle_counters+$04).w

loc_26B4:
                move.l  (a0,d0.w),(Normal_palette_line_3+$E).w
                lea     (AnPal_PalCNZ_5).l,a0
                move.l  (a0,d0.w),(Water_palette_line_3+$E).w

locret_26C6:
                rts
; ---------------------------------------------------------------------------

AnPal_FBZ:
                rts
; ---------------------------------------------------------------------------

AnPal_ICZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_26F8
                move.w  #5,(Palette_cycle_counter1).w
                lea     (AnPal_PalICZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #4,(Palette_cycle_counter0).w
                cmpi.w  #$40,(Palette_cycle_counter0).w
                blo.s   loc_26F2
                move.w  #0,(Palette_cycle_counter0).w

loc_26F2:
                move.l  (a0,d0.w),(Normal_palette_line_3+$1C).w

loc_26F8:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   loc_272C
                move.w  #9,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalICZ_2).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #4,(Palette_cycle_counters+$02).w
                cmpi.w  #$48,(Palette_cycle_counters+$02).w
                blo.s   loc_2720
                move.w  #0,(Palette_cycle_counters+$02).w

loc_2720:
                tst.w   (Events_bg+$16).w
                beq.s   loc_272C
                move.l  (a0,d0.w),(Normal_palette_line_4+$1C).w

loc_272C:
                subq.w  #1,(Palette_cycle_counters+$0A).w
                bpl.s   locret_2782
                move.w  #7,(Palette_cycle_counters+$0A).w
                lea     (AnPal_PalICZ_3).l,a0
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #4,(Palette_cycle_counters+$04).w
                cmpi.w  #$18,(Palette_cycle_counters+$04).w
                blo.s   loc_2754
                move.w  #0,(Palette_cycle_counters+$04).w

loc_2754:
                tst.w   (Events_bg+$16).w
                beq.s   loc_2760
                move.l  (a0,d0.w),(Normal_palette_line_4+$18).w

loc_2760:
                lea     (AnPal_PalICZ_4).l,a0
                move.w  (Palette_cycle_counters+$06).w,d0
                addq.w  #4,(Palette_cycle_counters+$06).w
                cmpi.w  #$40,(Palette_cycle_counters+$06).w
                blo.s   loc_277C
                move.w  #0,(Palette_cycle_counters+$06).w

loc_277C:
                move.l  (a0,d0.w),(Normal_palette_line_3+$18).w

locret_2782:
                rts
; ---------------------------------------------------------------------------

AnPal_LBZ1:
                lea     (AnPal_PalLBZ1).l,a0
                bra.s   loc_2792
; ---------------------------------------------------------------------------

AnPal_LBZ2:
                lea     (AnPal_PalLBZ2).l,a0

loc_2792:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_27C0
                move.w  #3,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #6,(Palette_cycle_counter0).w
                cmpi.w  #$12,(Palette_cycle_counter0).w
                blo.s   loc_27B4
                move.w  #0,(Palette_cycle_counter0).w

loc_27B4:
                move.l  (a0,d0.w),(Normal_palette_line_3+$10).w
                move.w  4(a0,d0.w),(Normal_palette_line_3+$14).w

locret_27C0:
                rts
; ---------------------------------------------------------------------------

AnPal_LRZ1:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_2818
                move.w  #$F,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$80,(Palette_cycle_counter0).w
                blo.s   loc_27E4
                move.w  #0,(Palette_cycle_counter0).w

loc_27E4:
                lea     (AnPal_PalLRZ1_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$02).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$06).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #4,(Palette_cycle_counters+$02).w
                cmpi.w  #$1C,(Palette_cycle_counters+$02).w
                blo.s   loc_280C
                move.w  #0,(Palette_cycle_counters+$02).w

loc_280C:
                lea     (AnPal_PalLRZ1_2).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$02).w

locret_2818:
                rts
; ---------------------------------------------------------------------------

AnPal_LRZ2:
                rts
; ---------------------------------------------------------------------------

AnPal_BPZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_2850
                move.w  #7,(Palette_cycle_counter1).w
                lea     (AnPal_PalBPZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #6,(Palette_cycle_counter0).w
                cmpi.w  #$12,(Palette_cycle_counter0).w
                blo.s   loc_2844
                move.w  #0,(Palette_cycle_counter0).w

loc_2844:
                move.l  (a0,d0.w),(Normal_palette_line_3+$1A).w
                move.w  4(a0,d0.w),(Normal_palette_line_3+$1E).w

loc_2850:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   locret_2884
                move.w  #$11,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalBPZ_2).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$7E,(Palette_cycle_counters+$02).w
                blo.s   loc_2878
                move.w  #0,(Palette_cycle_counters+$02).w

loc_2878:
                move.l  (a0,d0.w),(Normal_palette_line_4+$04).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$08).w

locret_2884:
                rts
; ---------------------------------------------------------------------------

AnPal_CGZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_28BA
                move.w  #9,(Palette_cycle_counter1).w
                lea     (AnPal_PalCGZ).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$50,(Palette_cycle_counter0).w
                blo.s   loc_28AE
                move.w  #0,(Palette_cycle_counter0).w

loc_28AE:
                move.l  (a0,d0.w),(Normal_palette_line_3+$04).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$08).w

locret_28BA:
                rts
; ---------------------------------------------------------------------------

AnPal_EMZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_28EA
                move.w  #7,(Palette_cycle_counter1).w
                lea     (AnPal_PalEMZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #2,(Palette_cycle_counter0).w
                cmpi.w  #$3C,(Palette_cycle_counter0).w
                blo.s   loc_28E4
                move.w  #0,(Palette_cycle_counter0).w

loc_28E4:
                move.w  4(a0,d0.w),(Normal_palette_line_3+$1C).w

loc_28EA:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   locret_2918
                move.w  #$1F,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalEMZ_2).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #4,(Palette_cycle_counters+$02).w
                cmpi.w  #$34,(Palette_cycle_counters+$02).w
                blo.s   loc_2912
                move.w  #0,(Palette_cycle_counters+$02).w

loc_2912:
                move.l  (a0,d0.w),(Normal_palette_line_4+$12).w

locret_2918:
                rts
; ---------------------------------------------------------------------------
