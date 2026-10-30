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
                bne.s   loc_221E
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_221C
                move.w  #7,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                andi.w  #$18,d0
                lea     (AnPal_PalAIZ1_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$16).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$1A).w
                tst.b   (Palette_cycle_counters+$00).w
                bne.s   locret_221C
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$30,(Palette_cycle_counters+$02).w
                blo.s   loc_220A
                move.w  #0,(Palette_cycle_counters+$02).w

loc_220A:
                lea     (AnPal_PalAIZ1_2).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$18).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$1C).w

locret_221C:
                rts
; ---------------------------------------------------------------------------

loc_221E:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_227A
                move.w  #9,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$50,(Palette_cycle_counter0).w
                blo.s   loc_2240
                move.w  #0,(Palette_cycle_counter0).w

loc_2240:
                lea     (AnPal_PalAIZ1_3).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$04).w
                move.l  4(a0,d0.w),(Normal_palette_line_4+$08).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$3C,(Palette_cycle_counters+$02).w
                blo.s   loc_2268
                move.w  #0,(Palette_cycle_counters+$02).w

loc_2268:
                lea     (AnPal_PalAIZ1_4).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$1A).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$1E).w

locret_227A:
                rts
; ---------------------------------------------------------------------------

AnPal_AIZ2:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_22F6
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
                blo.s   loc_22BC
                move.w  #0,(Palette_cycle_counters+$02).w

loc_22BC:
                lea     (AnPal_PalAIZ2_2).l,a0
                cmpi.w  #$3800,(Camera_X_pos).w
                blo.s   loc_22D0
                lea     (AnPal_PalAIZ2_3).l,a0

loc_22D0:
                move.w  (a0,d0.w),(Normal_palette_line_3+$08).w
                move.w  2(a0,d0.w),(Normal_palette_line_3+$10).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$16).w
                move.w  #$A0E,(Normal_palette_line_3+$1C).w
                cmpi.w  #$1C0,(Camera_X_pos).w
                bhs.s   loc_22F6
                move.w  4(a0,d0.w),(Normal_palette_line_3+$1C).w

loc_22F6:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   locret_2332
                move.w  #1,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #2,(Palette_cycle_counters+$04).w
                cmpi.w  #$34,(Palette_cycle_counters+$04).w
                blo.s   loc_2318
                move.w  #0,(Palette_cycle_counters+$04).w

loc_2318:
                lea     (AnPal_PalAIZ2_4).l,a0
                cmpi.w  #$3800,(Camera_X_pos).w
                blo.s   loc_232C
                lea     (AnPal_PalAIZ2_5).l,a0

loc_232C:
                move.w  (a0,d0.w),(Normal_palette_line_4+$02).w

locret_2332:
                rts

; =============== S U B R O U T I N E =======================================

AnPal_HCZ1:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_2380
                move.w  #7,(Palette_cycle_counter1).w
                tst.b   (Palette_cycle_counters+$00).w
                beq.s   loc_234C
                move.w  #0,(Palette_cycle_counter1).w

loc_234C:
                lea     (AnPal_PalHCZ1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$20,(Palette_cycle_counter0).w
                blo.s   loc_2368
                move.w  #0,(Palette_cycle_counter0).w

loc_2368:
                move.l  (a0,d0.w),(Normal_palette_line_3+$06).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$0A).w
                move.l  (a0,d0.w),(Water_palette_line_3+$06).w
                move.l  4(a0,d0.w),(Water_palette_line_3+$0A).w

locret_2380:
                rts
; End of function AnPal_HCZ1

; ---------------------------------------------------------------------------

AnPal_HCZ2:
                rts
; ---------------------------------------------------------------------------

AnPal_CNZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_23CA
                move.w  #3,(Palette_cycle_counter1).w
                lea     (AnPal_PalCNZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #6,(Palette_cycle_counter0).w
                cmpi.w  #$60,(Palette_cycle_counter0).w
                blo.s   loc_23AC
                move.w  #0,(Palette_cycle_counter0).w

loc_23AC:
                move.l  (a0,d0.w),(Normal_palette_line_4+$12).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$16).w
                lea     (AnPal_PalCNZ_2).l,a0
                move.l  (a0,d0.w),(Water_palette_line_4+$12).w
                move.w  4(a0,d0.w),(Water_palette_line_4+$16).w

loc_23CA:
                lea     (AnPal_PalCNZ_3).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$B4,(Palette_cycle_counters+$02).w
                blo.s   loc_23E6
                move.w  #0,(Palette_cycle_counters+$02).w

loc_23E6:
                move.l  (a0,d0.w),(Normal_palette_line_3+$12).w
                move.w  4(a0,d0.w),(Normal_palette_line_3+$16).w
                lea     (AnPal_PalCNZ_4).l,a0
                move.l  (a0,d0.w),(Water_palette_line_3+$12).w
                move.w  4(a0,d0.w),(Water_palette_line_3+$16).w
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   locret_243E
                move.w  #2,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalCNZ_5).l,a0
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #4,(Palette_cycle_counters+$04).w
                cmpi.w  #$40,(Palette_cycle_counters+$04).w
                blo.s   loc_242C
                move.w  #0,(Palette_cycle_counters+$04).w

loc_242C:
                move.l  (a0,d0.w),(Normal_palette_line_3+$E).w
                lea     (AnPal_PalCNZ_5).l,a0
                move.l  (a0,d0.w),(Water_palette_line_3+$E).w

locret_243E:
                rts
; ---------------------------------------------------------------------------

AnPal_FBZ:
                tst.b   (Level_frame_counter+1).w
                bne.s   locret_244C
                bchg    #0,(_unkF7C1).w

locret_244C:
                rts
; ---------------------------------------------------------------------------

AnPal_ICZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_247C
                move.w  #5,(Palette_cycle_counter1).w
                lea     (AnPal_PalICZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #4,(Palette_cycle_counter0).w
                cmpi.w  #$40,(Palette_cycle_counter0).w
                blo.s   loc_2476
                move.w  #0,(Palette_cycle_counter0).w

loc_2476:
                move.l  (a0,d0.w),(Normal_palette_line_3+$1C).w

loc_247C:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   loc_24B0
                move.w  #9,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalICZ_2).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #4,(Palette_cycle_counters+$02).w
                cmpi.w  #$48,(Palette_cycle_counters+$02).w
                blo.s   loc_24A4
                move.w  #0,(Palette_cycle_counters+$02).w

loc_24A4:
                tst.w   (Events_bg+$16).w
                beq.s   loc_24B0
                move.l  (a0,d0.w),(Normal_palette_line_4+$1C).w

loc_24B0:
                subq.w  #1,(Palette_cycle_counters+$0A).w
                bpl.s   locret_2506
                move.w  #7,(Palette_cycle_counters+$0A).w
                lea     (AnPal_PalICZ_3).l,a0
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #4,(Palette_cycle_counters+$04).w
                cmpi.w  #$18,(Palette_cycle_counters+$04).w
                blo.s   loc_24D8
                move.w  #0,(Palette_cycle_counters+$04).w

loc_24D8:
                tst.w   (Events_bg+$16).w
                beq.s   loc_24E4
                move.l  (a0,d0.w),(Normal_palette_line_4+$18).w

loc_24E4:
                lea     (AnPal_PalICZ_4).l,a0
                move.w  (Palette_cycle_counters+$06).w,d0
                addq.w  #4,(Palette_cycle_counters+$06).w
                cmpi.w  #$40,(Palette_cycle_counters+$06).w
                blo.s   loc_2500
                move.w  #0,(Palette_cycle_counters+$06).w

loc_2500:
                move.l  (a0,d0.w),(Normal_palette_line_3+$18).w

locret_2506:
                rts
; ---------------------------------------------------------------------------

AnPal_LBZ1:
                lea     (AnPal_PalLBZ1).l,a0
                bra.s   loc_2516
; ---------------------------------------------------------------------------

AnPal_LBZ2:
                lea     (AnPal_PalLBZ2).l,a0

loc_2516:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_2544
                move.w  #3,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #6,(Palette_cycle_counter0).w
                cmpi.w  #$12,(Palette_cycle_counter0).w
                blo.s   loc_2538
                move.w  #0,(Palette_cycle_counter0).w

loc_2538:
                move.l  (a0,d0.w),(Normal_palette_line_3+$10).w
                move.w  4(a0,d0.w),(Normal_palette_line_3+$14).w

locret_2544:
                rts
; ---------------------------------------------------------------------------

AnPal_SOZ1:
                subq.w  #1,(Palette_cycle_counters+$0A).w
                bpl.s   locret_257A
                move.w  #5,(Palette_cycle_counters+$0A).w
                lea     (AnPal_PalSOZ1).l,a0
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #8,(Palette_cycle_counters+$04).w
                cmpi.w  #$20,(Palette_cycle_counters+$04).w
                blo.s   loc_256E
                move.w  #0,(Palette_cycle_counters+$04).w

loc_256E:
                move.l  (a0,d0.w),(Normal_palette_line_3+$18).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$1C).w

locret_257A:
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
                bpl.s   loc_25C4
                move.w  #900-1,(Palette_cycle_counter1).w
                cmpi.b  #5,(SOZ_darkness_level).w
                bhs.s   loc_25C4
                addq.b  #1,(SOZ_darkness_level).w
                btst    #0,(SOZ_darkness_level).w
                bne.s   loc_25C4
                move.b  #2,(Palette_cycle_counters+$00).w
                move.w  #0,(Palette_cycle_counters+$08).w

loc_25C4:
                tst.b   (Palette_cycle_counters+$00).w
                beq.s   loc_262C
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   loc_262C
                move.w  #3,(Palette_cycle_counters+$08).w
                tst.b   (Palette_cycle_counters+$00).w
                bmi.s   loc_25EC
                subq.b  #1,(Palette_cycle_counters+$00).w
                addi.w  #$34,(Palette_cycle_counters+$02).w
                addq.w  #1,(Palette_cycle_counters+$06).w
                bra.s   loc_25FA
; ---------------------------------------------------------------------------

loc_25EC:
                addq.b  #1,(Palette_cycle_counters+$00).w
                subi.w  #$34,(Palette_cycle_counters+$02).w
                subq.w  #1,(Palette_cycle_counters+$06).w

loc_25FA:
                move.w  (Palette_cycle_counters+$02).w,d0
                lea     (AnPal_PalSOZ2_Light).l,a0
                lea     (a0,d0.w),a0
                lea     (Normal_palette_line_3+$2).w,a1
                moveq   #$B-1,d0

loc_260E:
                move.w  (a0)+,(a1)+
                dbf     d0,loc_260E
                lea     (Normal_palette_line_4+$2).w,a1
                moveq   #$F-1,d0

loc_261A:
                move.w  (a0)+,(a1)+
                dbf     d0,loc_261A
                move.w  (Palette_cycle_counters+$04).w,d0
                subq.w  #1,(Palette_cycle_counters+$0A).w
                bpl.s   loc_264E
                bra.s   loc_2632
; ---------------------------------------------------------------------------

loc_262C:
                subq.w  #1,(Palette_cycle_counters+$0A).w
                bpl.s   locret_266A

loc_2632:
                move.w  #5,(Palette_cycle_counters+$0A).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #8,(Palette_cycle_counters+$04).w
                cmpi.w  #$20,(Palette_cycle_counters+$04).w
                blo.s   loc_264E
                move.w  #0,(Palette_cycle_counters+$04).w

loc_264E:
                lea     (AnPal_PalSOZ1).l,a0
                move.w  (Palette_cycle_counters+$06).w,d1
                lsl.w   #5,d1
                lea     (a0,d1.w),a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$18).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$1C).w

locret_266A:
                rts
; ---------------------------------------------------------------------------

AnPal_LRZ1:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_26C2
                move.w  #$F,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$80,(Palette_cycle_counter0).w
                blo.s   loc_268E
                move.w  #0,(Palette_cycle_counter0).w

loc_268E:
                lea     (AnPal_PalLRZ12_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$02).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$06).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #4,(Palette_cycle_counters+$02).w
                cmpi.w  #$1C,(Palette_cycle_counters+$02).w
                blo.s   loc_26B6
                move.w  #0,(Palette_cycle_counters+$02).w

loc_26B6:
                lea     (AnPal_PalLRZ12_2).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$02).w

loc_26C2:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   locret_26F0
                move.w  #7,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #2,(Palette_cycle_counters+$04).w
                cmpi.w  #$22,(Palette_cycle_counters+$04).w
                blo.s   loc_26E4
                move.w  #0,(Palette_cycle_counters+$04).w

loc_26E4:
                lea     (AnPal_PalLRZ1_3).l,a0
                move.w  (a0,d0.w),(Normal_palette_line_3+$16).w

locret_26F0:
                rts
; ---------------------------------------------------------------------------

AnPal_LRZ2:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_2748
                move.w  #$F,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$80,(Palette_cycle_counter0).w
                blo.s   loc_2714
                move.w  #0,(Palette_cycle_counter0).w

loc_2714:
                lea     (AnPal_PalLRZ12_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$2).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$6).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #4,(Palette_cycle_counters+$02).w
                cmpi.w  #$1C,(Palette_cycle_counters+$02).w
                blo.s   loc_273C
                move.w  #0,(Palette_cycle_counters+$02).w

loc_273C:
                lea     (AnPal_PalLRZ12_2).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$2).w

loc_2748:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   locret_277C
                move.w  #$F,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #8,(Palette_cycle_counters+$04).w
                cmpi.w  #$100,(Palette_cycle_counters+$04).w
                blo.s   loc_276A
                move.w  #0,(Palette_cycle_counters+$04).w

loc_276A:
                lea     (AnPal_PalLRZ2_3).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$16).w
; Bug: This mistakenly use the same colors as the first and second indices, rather than the third and fourth
; This was fixed in Sonic Origins
                move.l  (a0,d0.w),(Normal_palette_line_4+$1A).w

locret_277C:
                rts
; ---------------------------------------------------------------------------

AnPal_DEZ1:
                subq.w  #1,(Palette_cycle_counters+$0A).w
                bpl.s   AnPal_DEZ2
                move.w  #$F,(Palette_cycle_counters+$0A).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #8,(Palette_cycle_counters+$04).w
                cmpi.w  #$30,(Palette_cycle_counters+$04).w
                blo.s   loc_27A0
                move.w  #0,(Palette_cycle_counters+$04).w

loc_27A0:
                lea     (AnPal_PalDEZ1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$18).w
                move.l  4(a0,d0.w),(Normal_palette_line_4+$1C).w

AnPal_DEZ2:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_27E0
                move.w  #4,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #4,(Palette_cycle_counter0).w
                cmpi.w  #$30,(Palette_cycle_counter0).w
                blo.s   loc_27D4
                move.w  #0,(Palette_cycle_counter0).w

loc_27D4:
                lea     (AnPal_PalDEZ12_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$1A).w

loc_27E0:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   locret_2818
                move.w  #$13,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addi.w  #$A,(Palette_cycle_counters+$02).w
                cmpi.w  #$28,(Palette_cycle_counters+$02).w
                blo.s   loc_2804
                move.w  #0,(Palette_cycle_counters+$02).w

loc_2804:
                lea     (AnPal_PalDEZ12_2).l,a0
                lea     (a0,d0.w),a0
                lea     (Normal_palette_line_3+$10).w,a1
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.w  (a0)+,(a1)+

locret_2818:
                rts
; ---------------------------------------------------------------------------

AnPal_BPZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_284E
                move.w  #7,(Palette_cycle_counter1).w
                lea     (AnPal_PalBPZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #6,(Palette_cycle_counter0).w
                cmpi.w  #$12,(Palette_cycle_counter0).w
                blo.s   loc_2842
                move.w  #0,(Palette_cycle_counter0).w

loc_2842:
                move.l  (a0,d0.w),(Normal_palette_line_3+$1A).w
                move.w  4(a0,d0.w),(Normal_palette_line_3+$1E).w

loc_284E:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   locret_2882
                move.w  #$11,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalBPZ_2).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #6,(Palette_cycle_counters+$02).w
                cmpi.w  #$7E,(Palette_cycle_counters+$02).w
                blo.s   loc_2876
                move.w  #0,(Palette_cycle_counters+$02).w

loc_2876:
                move.l  (a0,d0.w),(Normal_palette_line_4+$04).w
                move.w  4(a0,d0.w),(Normal_palette_line_4+$08).w

locret_2882:
                rts
; ---------------------------------------------------------------------------

AnPal_CGZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_28B8
                move.w  #9,(Palette_cycle_counter1).w
                lea     (AnPal_PalCGZ).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$50,(Palette_cycle_counter0).w
                blo.s   loc_28AC
                move.w  #0,(Palette_cycle_counter0).w

loc_28AC:
                move.l  (a0,d0.w),(Normal_palette_line_3+$04).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$08).w

locret_28B8:
                rts
; ---------------------------------------------------------------------------

AnPal_EMZ:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_28E8
                move.w  #7,(Palette_cycle_counter1).w
                lea     (AnPal_PalEMZ_1).l,a0
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #2,(Palette_cycle_counter0).w
                cmpi.w  #$3C,(Palette_cycle_counter0).w
                blo.s   loc_28E2
                move.w  #0,(Palette_cycle_counter0).w

loc_28E2:
                move.w  4(a0,d0.w),(Normal_palette_line_3+$1C).w

loc_28E8:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   locret_2916
                move.w  #$1F,(Palette_cycle_counters+$08).w
                lea     (AnPal_PalEMZ_2).l,a0
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #4,(Palette_cycle_counters+$02).w
                cmpi.w  #$34,(Palette_cycle_counters+$02).w
                blo.s   loc_2910
                move.w  #0,(Palette_cycle_counters+$02).w

loc_2910:
                move.l  (a0,d0.w),(Normal_palette_line_4+$12).w

locret_2916:
                rts
; ---------------------------------------------------------------------------

AnPal_Pachinko:
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_2952
                move.w  #0,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addi.w  #$E,(Palette_cycle_counter0).w
                cmpi.w  #$FC,(Palette_cycle_counter0).w
                blo.s   loc_293C
                move.w  #0,(Palette_cycle_counter0).w

loc_293C:
                lea     (Chunk_table+$7800).l,a0
                lea     (Normal_palette_line_4+$10).w,a1
                lea     (a0,d0.w),a0
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.w  (a0)+,(a1)+

loc_2952:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   locret_29A6
                move.w  #3,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addi.w  #$A,(Palette_cycle_counters+$02).w
                cmpi.w  #$3E8,(Palette_cycle_counters+$02).w
                blo.s   loc_2976
                move.w  #0,(Palette_cycle_counters+$02).w

loc_2976:
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

locret_29A6:
                rts
; ---------------------------------------------------------------------------

AnPal_Slots:
                tst.b   (Palette_cycle_counters+$00).w
                bmi.s   locret_29F0
                bne.s   loc_29F2
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_29F0
                move.w  #3,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$40,(Palette_cycle_counter0).w
                blo.s   loc_29D2
                move.w  #0,(Palette_cycle_counter0).w

loc_29D2:
                lea     (AnPal_PalSlots_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$14).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$18).w
                move.w  #$E02,(Normal_palette_line_3+$1C).w
                move.w  #$E02,(Normal_palette_line_4+$1C).w

locret_29F0:
                rts
; ---------------------------------------------------------------------------

loc_29F2:
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   locret_2A4E
                move.w  #0,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$02).w,d0
                addq.w  #8,(Palette_cycle_counters+$02).w
                cmpi.w  #$78,(Palette_cycle_counters+$02).w
                blo.s   loc_2A14
                move.w  #0,(Palette_cycle_counters+$02).w

loc_2A14:
                lea     (AnPal_PalSlots_2).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$14).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$18).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #2,(Palette_cycle_counters+$04).w
                cmpi.w  #$C,(Palette_cycle_counters+$04).w
                blo.s   loc_2A3C
                move.w  #0,(Palette_cycle_counters+$04).w

loc_2A3C:
                lea     (AnPal_PalSlots_3).l,a0
                move.w  (a0,d0.w),(Normal_palette_line_3+$1C).w
                move.w  (a0,d0.w),(Normal_palette_line_4+$1C).w

locret_2A4E:
                rts
; ---------------------------------------------------------------------------

AnPal_LRZ3:
                tst.b   (Palette_cycle_counters+$00).w
                bmi.s   locret_2ABE
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   loc_2A8A
                move.w  #$F,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #8,(Palette_cycle_counter0).w
                cmpi.w  #$80,(Palette_cycle_counter0).w
                blo.s   loc_2A78
                move.w  #0,(Palette_cycle_counter0).w

loc_2A78:
                lea     (AnPal_PalLRZ12_1).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_3+$2).w
                move.l  4(a0,d0.w),(Normal_palette_line_3+$6).w

loc_2A8A:
                tst.b   (Palette_cycle_counters+$00).w
                beq.s   locret_2ABE
                subq.w  #1,(Palette_cycle_counters+$08).w
                bpl.s   locret_2ABE
                move.w  #7,(Palette_cycle_counters+$08).w
                move.w  (Palette_cycle_counters+$04).w,d0
                addq.w  #4,(Palette_cycle_counters+$04).w
                cmpi.w  #$3C,(Palette_cycle_counters+$04).w
                blo.s   loc_2AB2
                move.w  #0,(Palette_cycle_counters+$04).w

loc_2AB2:
                lea     (AnPal_PalLRZ3).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$18).w

locret_2ABE:
                rts
; ---------------------------------------------------------------------------

AnPal_HPZ:
                tst.b   (Palette_cycle_counters+$00).w
                bne.s   locret_2AF4
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_2AF4
                move.w  #7,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #4,(Palette_cycle_counter0).w
                cmpi.w  #$28,(Palette_cycle_counter0).w
                blo.s   loc_2AE8
                move.w  #0,(Palette_cycle_counter0).w

loc_2AE8:
                lea     (AnPal_PalHPZ).l,a0
                move.l  (a0,d0.w),(Normal_palette_line_4+$2).w

locret_2AF4:
                rts
; ---------------------------------------------------------------------------
