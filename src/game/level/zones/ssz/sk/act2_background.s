; Owner: game/level/zones/ssz/sk
; Responsibility: Sky Sanctuary act-two background initialization, event state, deformation and private records
; Source provenance and ranges: config/reconstruction/source_layout.json
SSZ2_DeformArray:
                dc.w    $800
                dc.w    $24
                dc.w    4
                dc.w    $14
                dc.w    4
                dc.w    $1C
                dc.w    4
                dc.w    $20
                dc.w    $8080
                dc.w    $7FFF
SSZ2_BGDeformArray:
                dc.w    $120
                dc.w    8
                dc.w    8
                dc.w    4
                dc.w    4
                dc.w    8
                dc.w    8
                dc.w    $18
                dc.w    $10
                dc.w    $10
                dc.w    $7FFF
; ---------------------------------------------------------------------------

SSZ2_BackgroundInit:
                clr.l   (_unkEE9C).w
                jsr     sub_58D3E(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                moveq   #0,d1
                jsr     (Refresh_PlaneFull).l
                jmp     sub_58FBC(pc)
; ---------------------------------------------------------------------------

SSZ2_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     SSZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SSZ2_BackgroundEvent_Index:
                bra.w   loc_58D1E
; ---------------------------------------------------------------------------
                lea     (Level_layout_main).w,a3

loc_58D1E:
                jsr     sub_58D3E(pc)
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     (Draw_TileRow).l
                jsr     sub_58FBC(pc)
                jmp     (ShakeScreen_Setup).l

; =============== S U B R O U T I N E =======================================

sub_58D3E:
                tst.w   (Events_routine_bg).w
                beq.s   loc_58D6E

loc_58D44:
                lea     (HScroll_table).w,a1
                move.l  (a1),d0
                addi.l  #$8000,(a1)+
                lea     $16(a1),a1
                move.w  #$5E,-(a1)
                clr.w   d0
                move.l  d0,d1
                asr.l   #3,d1
                moveq   #8-1,d2

loc_58D60:
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                sub.l   d1,d0
                dbf     d2,loc_58D60
                rts
; ---------------------------------------------------------------------------

loc_58D6E:
                cmpi.w  #$18,(Events_routine_fg).w
                bhs.w   loc_58F52
                cmpi.w  #$C,(Events_routine_fg).w
                bhs.w   locret_58F50
                lea     (HScroll_table).w,a1
                move.l  (a1),d2
                addi.l  #$1000,(a1)+
                clr.w   (a1)+
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #5,d0
                move.l  d0,d1
                asr.l   #1,d0
                add.l   d2,d0
                swap    d0
                move.w  d0,(a1)
                move.w  d0,4(a1)
                move.w  d0,8(a1)
                move.w  d0,$10(a1)
                move.w  d0,$36(a1)
                move.w  d0,$3A(a1)
                move.w  d0,$3E(a1)
                move.w  d0,$46(a1)
                swap    d0
                add.l   d2,d1
                add.l   d1,d0
                swap    d0
                move.w  d0,6(a1)
                move.w  d0,$A(a1)
                move.w  d0,$E(a1)
                move.w  d0,$14(a1)
                move.w  d0,$3C(a1)
                move.w  d0,$40(a1)
                move.w  d0,$44(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,2(a1)
                move.w  d0,$C(a1)
                move.w  d0,$16(a1)
                move.w  d0,$34(a1)
                move.w  d0,$38(a1)
                move.w  d0,$42(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,$12(a1)
                swap    d0
                lea     $18(a1),a1
                moveq   #9-1,d2

loc_58E14:
                swap    d0
                move.w  d0,(a1)+
                swap    d0
                add.l   d1,d0
                dbf     d2,loc_58E14
                cmpi.w  #4,(Events_routine_fg).w
                bhi.s   loc_58E3A
                lea     (HScroll_table+$02A).w,a1
                move.w  (Camera_X_pos_copy).w,d0
                moveq   #9-1,d1

loc_58E32:
                move.w  d0,(a1)+
                dbf     d1,loc_58E32
                bra.s   loc_58E6E
; ---------------------------------------------------------------------------

loc_58E3A:
                lea     (HScroll_table+$004).w,a1
                move.w  $2A(a1),$2C(a1)
                move.w  $28(a1),d0
                move.w  d0,$2A(a1)
                move.w  d0,$2E(a1)
                move.w  $26(a1),$28(a1)
                move.w  $24(a1),$26(a1)
                move.w  $22(a1),$30(a1)
                move.w  $1E(a1),$32(a1)
                move.w  $1A(a1),$34(a1)

loc_58E6E:
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$320,d0
                sub.w   (_unkEE9C).w,d0
                move.w  (Special_V_int_routine).w,d1
                subq.w  #4,d1
                beq.s   loc_58E88
                subq.w  #4,d1
                beq.s   loc_58E88
                addq.w  #8,d0

loc_58E88:
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  #$5E,(Camera_X_pos_BG_copy).w
                lea     (HScroll_table+$0D0).w,a5
                lea     (a5),a6
                move.w  (Events_bg+$00).w,d0
                smi     d6
                bpl.s   loc_58EA2
                neg.w   d0

loc_58EA2:
                swap    d0
                clr.w   d0
                asr.l   #7,d0
                move.w  d0,d1
                swap    d0
                moveq   #0,d2
                moveq   #0,d3
                moveq   #$40-1,d4
                tst.b   d6
                bne.s   loc_58EC8

loc_58EB6:
                add.w   d1,d3
                addx.w  d0,d2
                move.w  d2,-(a5)
                move.w  d2,d5
                neg.w   d5
                move.w  d5,(a6)+
                dbf     d4,loc_58EB6
                bra.s   loc_58ED8
; ---------------------------------------------------------------------------

loc_58EC8:
                add.w   d1,d3
                addx.w  d0,d2
                move.w  d2,(a6)+
                move.w  d2,d5
                neg.w   d5
                move.w  d5,-(a5)
                dbf     d4,loc_58EC8

loc_58ED8:
                lea     (HScroll_table+$160).w,a5
                lea     (a5),a6
                move.w  (Events_bg+$00).w,d0
                smi     d6
                bpl.s   loc_58EE8
                neg.w   d0

loc_58EE8:
                swap    d0
                clr.w   d0
                asr.l   #3,d0
                move.w  d0,d1
                swap    d0
                moveq   #0,d2
                moveq   #0,d3
                moveq   #8-1,d4
                tst.b   d6
                bne.s   loc_58F0E

loc_58EFC:
                add.w   d1,d3
                addx.w  d0,d2
                move.w  d2,-(a5)
                move.w  d2,d5
                neg.w   d5
                move.w  d5,(a6)+
                dbf     d4,loc_58EFC
                bra.s   loc_58F1E
; ---------------------------------------------------------------------------

loc_58F0E:
                add.w   d1,d3
                addx.w  d0,d2
                move.w  d2,(a6)+
                move.w  d2,d5
                neg.w   d5
                move.w  d5,-(a5)
                dbf     d4,loc_58F0E

loc_58F1E:
                lea     (HScroll_table+$170).w,a1
                lea     (HScroll_table+$140).w,a5
                move.w  (Camera_X_pos_BG_copy).w,d0
                move.w  d0,d1
                andi.w  #$F,d1
                beq.s   loc_58F36
                addi.w  #$10,d0

loc_58F36:
                lsr.w   #3,d0
                andi.w  #$FFFE,d0
                adda.w  d0,a5
                move.w  (Camera_Y_pos_BG_copy).w,d0
                addq.w  #8,d0
                moveq   #$14-1,d1

loc_58F46:
                move.w  (a5)+,d2
                add.w   d0,d2
                move.w  d2,(a1)+
                dbf     d1,loc_58F46

locret_58F50:
                rts
; ---------------------------------------------------------------------------

loc_58F52:
                lea     (HScroll_table).w,a1
                move.l  (a1),d0
                subi.l  #$10000,(a1)+
                lea     $110(a1),a1
                clr.w   d0
                move.l  d0,d1
                asr.l   #5,d1
                moveq   #$20-1,d2

loc_58F6A:
                swap    d0
                move.w  d0,-(a1)
                move.w  d0,-(a1)
                move.w  d0,-(a1)
                move.w  d0,-(a1)
                swap    d0
                sub.l   d1,d0
                dbf     d2,loc_58F6A
                move.w  (a1),d0
                neg.w   d0
                move.w  d0,-4(a1)
                move.w  d0,-$C(a1)
                move.w  8(a1),d0
                neg.w   d0
                move.w  d0,-8(a1)
                move.w  $10(a1),d0
                neg.w   d0
                move.w  d0,-2(a1)
                move.w  $18(a1),d0
                neg.w   d0
                move.w  d0,-$E(a1)
                move.w  $20(a1),d0
                neg.w   d0
                move.w  d0,-$A(a1)
                move.w  $28(a1),d0
                neg.w   d0
                move.w  d0,-6(a1)
                rts
; End of function sub_58D3E

; =============== S U B R O U T I N E =======================================

sub_58FBC:
                tst.w   (Events_routine_bg).w
                beq.s   loc_58FD0
                lea     SSZ2_BGDeformArray(pc),a4
                lea     (HScroll_table+$004).w,a5
                jmp     (ApplyDeformation).l
; ---------------------------------------------------------------------------

loc_58FD0:
                cmpi.w  #$18,(Events_routine_fg).w
                bhs.w   loc_5906A
                cmpi.w  #$C,(Events_routine_fg).w
                bhs.w   loc_59064
                lea     word_58C80(pc),a4
                lea     (HScroll_table+$004).w,a5
                jsr     (ApplyFGDeformation).l
                lea     (H_scroll_buffer+2).w,a1
                lea     (HScroll_table+$050).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d0
                subi.w  #$100,d0
                bmi.s   loc_59018
                subi.w  #$80,d0
                bpl.s   loc_5904A
                move.w  d0,d1
                neg.w   d0
                addi.w  #$80,d1
                add.w   d1,d1
                adda.w  d1,a5
                bra.s   loc_59036
; ---------------------------------------------------------------------------

loc_59018:
                neg.w   d0
                cmpi.w  #$E0,d0
                bhs.s   loc_5904A
                move.w  d0,d1
                addi.w  #-$E0,d0
                neg.w   d0
                cmpi.w  #$80,d0
                blo.s   loc_59032
                move.w  #$80,d0

loc_59032:
                lsl.w   #2,d1
                adda.w  d1,a1

loc_59036:
                subq.w  #1,d0
                move.w  (Camera_X_pos_BG_copy).w,d1
                neg.w   d1

loc_5903E:
                move.w  (a5)+,d2
                add.w   d1,d2
                move.w  d2,(a1)
                addq.w  #4,a1
                dbf     d0,loc_5903E

loc_5904A:
                lea     (Vscroll_buffer).w,a1
                lea     (HScroll_table+$170).w,a5
                move.w  (Camera_Y_pos_copy).w,d0
                swap    d0
                moveq   #$14-1,d1

loc_5905A:
                move.w  (a5)+,d0
                move.l  d0,(a1)+
                dbf     d1,loc_5905A
                rts
; ---------------------------------------------------------------------------

loc_59064:
                jmp     (PlainDeformation).l
; ---------------------------------------------------------------------------

loc_5906A:
                lea     SSZ2_DeformArray(pc),a4
                lea     (HScroll_table+$004).w,a5
                jmp     (ApplyFGDeformation).l
; End of function sub_58FBC

; ---------------------------------------------------------------------------

loc_59078:
                moveq   #0,d0
                move.b  routine(a0),d0
                jmp     loc_59082(pc,d0.w)
; ---------------------------------------------------------------------------

loc_59082:
                bra.w   loc_5908E
; ---------------------------------------------------------------------------
                bra.w   loc_590E4
; ---------------------------------------------------------------------------
                bra.w   loc_59194
; ---------------------------------------------------------------------------

loc_5908E:
                tst.w   (Special_V_int_routine).w
                beq.w   locret_591D4
                addi.l  #$11B,(_unkEE9C).w
                move.l  #$2000,d0
                move.l  #$4A,d1
                jsr     (Gradual_SwingOffset).l
                cmp.w   (Events_bg+$00).w,d0
                beq.w   locret_591D4
                move.w  d0,(Events_bg+$00).w
                bne.w   locret_591D4
                tst.w   (Events_fg_4).w
                bpl.w   locret_591D4
                tst.b   $38(a0)
                bne.s   loc_590D6
                st      $38(a0)
                bra.w   locret_591D4
; ---------------------------------------------------------------------------

loc_590D6:
                clr.w   (Events_fg_4).w
                move.w  #$C,(Special_V_int_routine).w
                addq.b  #4,routine(a0)

loc_590E4:
                cmpi.b  #7,(Super_emerald_count).w
                bhs.s   loc_590F4
                cmpi.b  #7,(Chaos_emerald_count).w
                blo.s   loc_59146

loc_590F4:
                cmpi.w  #$8000,$3C(a0)
                bhs.s   loc_59102
                addi.w  #$20,$3C(a0)

loc_59102:
                move.l  $3A(a0),d0
                sub.l   d0,(_unkEE9C).w
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$318,d0
                sub.w   (_unkEE9C).w,d0
                cmpi.w  #$D0,d0
                beq.s   loc_59124
                bcs.s   loc_59132
                subq.w  #1,(Camera_Y_pos).w
                bra.s   loc_59132
; ---------------------------------------------------------------------------

loc_59124:
                tst.b   $39(a0)
                bne.s   loc_59132
                st      $39(a0)
                st      (_unkFAA9).w

loc_59132:
                cmpi.w  #$2A0,(Camera_Y_pos).w
                bne.w   locret_591D4
                st      (Events_fg_4+1).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_59146:
                cmpi.w  #$8000,$3C(a0)
                bhs.s   loc_59154
                addi.w  #$20,$3C(a0)

loc_59154:
                move.l  $3A(a0),d0
                add.l   d0,(_unkEE9C).w
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$318,d0
                sub.w   (_unkEE9C).w,d0
                cmpi.w  #$D0,d0
                beq.s   loc_59176
                bcc.s   loc_59184
                addq.w  #1,(Camera_Y_pos).w
                bra.s   loc_59184
; ---------------------------------------------------------------------------

loc_59176:
                tst.b   $39(a0)
                bne.s   loc_59184
                st      $39(a0)
                st      (_unkFAA9).w

loc_59184:
                cmpi.w  #$600,(Camera_Y_pos).w
                bne.s   locret_591D4
                st      (Events_fg_4+1).w
                addq.b  #4,routine(a0)

loc_59194:
                cmpi.w  #$18,(Events_routine_fg).w
                blo.s   locret_591D4
                move.l  $3A(a0),d0
                add.l   d0,(Camera_Y_pos).w
                move.w  (Camera_Y_pos).w,d0
                cmpi.w  #$7D0,d0
                blo.s   locret_591D4
                subi.l  #$98,$3A(a0)
                bpl.s   locret_591D4
                cmpi.w  #$804,(Camera_Y_pos).w
                bne.s   locret_591D4
                jsr     (AllocateObject).l
                bne.s   loc_591CE
                move.l  #Obj_5EF68,(a1)

loc_591CE:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

locret_591D4:
                rts
; ---------------------------------------------------------------------------

loc_591D6:
                move.l  #loc_59208,(a0)
                move.b  #$40,render_flags(a0)
                move.b  #$40,height_pixels(a0)
                move.w  #$380,priority(a0)
                move.l  #Map_KnuxEndingIslandMask,mappings(a0)
                move.w  #$122,x_pos(a0)
                move.w  #$F0,y_pos(a0)
                move.w  #8,mainspr_childsprites(a0)

loc_59208:
                tst.w   (Events_routine_bg).w
                beq.s   loc_59232
                cmpi.w  #$80,(Camera_Y_pos_BG_copy).w
                bne.s   loc_59218
                bra.s   loc_59220
; ---------------------------------------------------------------------------

loc_59218:
                subi.l  #$6000,(Camera_Y_pos_BG_copy).w

loc_59220:
                move.w  (Camera_Y_pos_BG_copy).w,d0
                subi.w  #$1D0,d0
                neg.w   d0
                addi.w  #$F0,d0
                move.w  d0,y_pos(a0)

loc_59232:
                lea     sub2_x_pos(a0),a1
                move.w  y_pos(a0),d0
                subi.w  #$40,d0
                moveq   #1,d2

loc_59240:
                move.w  #$A2,d1
                moveq   #4-1,d3

loc_59246:
                move.w  d1,(a1)+
                move.w  d0,(a1)+
                addq.w  #2,a1
                addi.w  #$40,d1
                dbf     d3,loc_59246
                addi.w  #$40,d0
                dbf     d2,loc_59240
                cmpi.w  #$18,(Events_routine_fg).w
                bne.s   loc_5926A
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_5926A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_KnuxEndingIslandMask:
                include "src/ui/shared/ending/mappings/knuckles_island_mask.s"

; =============== S U B R O U T I N E =======================================

sub_5928C:
                tst.b   (Palette_cycle_counters+$00).w
                bne.s   locret_592BC
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_592BC
                move.w  #7,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #6,d0
                cmpi.w  #$30,d0
                blo.s   loc_592AC
                moveq   #0,d0

loc_592AC:
                move.w  d0,(Palette_cycle_counter0).w
                move.l  Pal_EndingWater(pc,d0.w),(Normal_palette_line_4+$1A).w
                move.w  Pal_EndingWater+$4(pc,d0.w),(Normal_palette_line_4+$1E).w

locret_592BC:
                rts
; End of function sub_5928C

; ---------------------------------------------------------------------------
Pal_EndingWater:
                binclude "data/General/Ending/Palettes/Water Cycle.bin"
                even

; =============== S U B R O U T I N E =======================================

sub_592EE:
                tst.b   (Palette_cycle_counters+$00).w
                bne.s   locret_59318
                subq.w  #1,(Palette_cycle_counter1).w
                bpl.s   locret_59318
                move.w  #3,(Palette_cycle_counter1).w
                move.w  (Palette_cycle_counter0).w,d0
                addq.w  #4,d0
                cmpi.w  #$38,d0
                blo.s   loc_5930E
                moveq   #0,d0

loc_5930E:
                move.w  d0,(Palette_cycle_counter0).w
                move.l  word_5931A(pc,d0.w),(Normal_palette_line_4+$16).w

locret_59318:
                rts
; End of function sub_592EE

; ---------------------------------------------------------------------------
word_5931A:
                dc.w    $C40,  $400
                dc.w    $E68,  $600
                dc.w    $E80,  $800
                dc.w    $E80,  $800
                dc.w    $EE0,  $A00
                dc.w    $EE0,  $A00
                dc.w    $EE0,  $C00
                dc.w    $C40,  $C00
                dc.w    $E68,  $C00
                dc.w    $E80,  $400
                dc.w    $E80,  $600
                dc.w    $EE0,  $A00
                dc.w    $EA4,  $800
                dc.w    $EA4,  $400
