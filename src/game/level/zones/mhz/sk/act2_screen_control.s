; Owner: game/level/zones/mhz/sk
; Responsibility: Mushroom Hill act-two screen initialization, event dispatch and progression control
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

MHZ2_ScreenInit:
                move.w  #4,(Events_routine_fg).w
                clr.w   (Events_bg+$16).w
                st      (_unkF7C1).w
                move.w  (Player_1+x_pos).w,d0
                lea     Pal_MHZ2Gold(pc),a1
                cmpi.w  #$2940,d0
                bhs.s   loc_54D72
                st      (Events_bg+$04).w
                lea     (Pal_MHZ2+$20).l,a1
                cmpi.w  #$9C0,d0
                bhs.s   loc_54D72
                cmpi.w  #$600,(Player_1+y_pos).w
                blo.s   loc_54D72
                clr.b   (Events_bg+$04).w
                clr.b   (_unkF7C1).w
                lea     (Pal_MHZ1+$20).l,a1

loc_54D72:
                lea     (Normal_palette_line_3).w,a5
                lea     (Target_palette_line_3).w,a6
                moveq   #bytesToLcnt($40),d0

loc_54D7C:
                move.l  (a1),(a5)+
                move.l  (a1)+,(a6)+
                dbf     d0,loc_54D7C
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

MHZ2_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_X_pos_copy).w
                move.w  (Events_routine_fg).w,d0
                jmp     MHZ2_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

MHZ2_ScreenEvent_Index:
                bra.w   loc_54DB0
; ---------------------------------------------------------------------------
                bra.w   loc_54DBE
; ---------------------------------------------------------------------------
                bra.w   loc_54E86
; ---------------------------------------------------------------------------
                bra.w   loc_54E9C
; ---------------------------------------------------------------------------
                bra.w   loc_54F64
; ---------------------------------------------------------------------------

loc_54DB0:
                tst.b   (End_of_level_flag).w
                beq.s   loc_54DBA
                addq.w  #4,(Events_routine_fg).w

loc_54DBA:
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

loc_54DBE:
                tst.w   (Events_fg_4).w
                beq.s   loc_54DDC
                clr.w   (Events_fg_4).w
                move.w  #$320,(Draw_delayed_position).w
                move.w  #$A,(Draw_delayed_rowcount).w
                addq.w  #8,(Events_routine_fg).w
                bra.w   loc_54E9C
; ---------------------------------------------------------------------------

loc_54DDC:
                cmpi.w  #$3C90,(Camera_X_pos).w
                blo.s   loc_54E00
                bne.w   loc_54E7E
                move.w  #$3C90,(Camera_min_X_pos).w
                cmpi.w  #$280,(Camera_Y_pos).w
                blo.w   loc_54E7E
                move.w  #$280,(Camera_min_Y_pos).w
                bra.s   loc_54E7E
; ---------------------------------------------------------------------------

loc_54E00:
                move.w  #$620,d0
                cmpi.w  #$380,(Camera_X_pos).w
                blo.s   loc_54E1A
                moveq   #0,d0
                cmpi.w  #$3600,(Camera_X_pos).w
                blo.s   loc_54E1A
                move.w  #$1A8,d0

loc_54E1A:
                cmp.w   (Camera_min_Y_pos).w,d0
                beq.s   loc_54E24
                move.w  d0,(Camera_min_Y_pos).w

loc_54E24:
                cmpi.w  #$3600,(Camera_X_pos).w
                bhs.s   loc_54E4C
                move.w  #$98,d0
                cmpi.w  #$5C0,(Player_1+y_pos).w
                bhs.s   loc_54E3C
                move.w  #$380,d0

loc_54E3C:
                cmp.w   (Camera_min_X_pos).w,d0
                beq.s   loc_54E4C
                tst.w   (Events_bg+$16).w
                bne.s   loc_54E4C
                move.w  d0,(Camera_min_X_pos).w

loc_54E4C:
                move.w  #$9A0,d0
                cmpi.w  #$3A97,(Player_1+x_pos).w
                blo.s   loc_54E70
                move.w  #$280,d0
                cmpi.w  #$3AC0,(Player_1+x_pos).w
                bhs.s   loc_54E70
                cmpi.w  #$300,(Player_1+y_pos).w
                blo.s   loc_54E70
                move.w  #$9A0,d0

loc_54E70:
                cmp.w   (Camera_max_Y_pos).w,d0
                beq.s   loc_54E7E
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w

loc_54E7E:
                bsr.w   SwitchMhz2RegionPalettes
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

loc_54E86:
                move.w  (Camera_X_pos_copy).w,(HScroll_table+$004).w
                lea     MHZ2_BGDrawArray1(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$15,d6
                moveq   #2,d5
                jmp     SKTileDraw_UpdateFgDeformed(pc)
; ---------------------------------------------------------------------------

loc_54E9C:
                move.w  #$4280,d1
                move.w  #$280,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.w   locret_54F62
                move.l  #$400000,(_unkEE98).w
                move.w  #$80,d0
                move.w  d0,(_unkEEA2).w
                move.w  d0,(_unkEE9C).w
                jsr     UpdateMhz2ShipScrollCarryAndPropellers(pc)
                lea     (HScroll_table).w,a1
                move.w  (a1)+,d0
                andi.w  #$FFF0,d0
                move.w  d0,(a1)+
                clr.l   (a1)+
                move.w  (a1)+,d0
                andi.w  #$FFF0,d0
                move.w  d0,(a1)+
                lea     (Normal_palette_line_2).w,a1
                lea     Pal_MHZ2Ship(pc),a5
                moveq   #bytesToLcnt($20),d0

loc_54EE4:
                move.l  (a5)+,(a1)+
                dbf     d0,loc_54EE4
                lea     (HScroll_table+$00C).w,a5
                clr.l   (a5)
                jsr     (AllocateObject).l
                bne.s   loc_54F2A
                move.l  #loc_5583E,(a1)
                move.w  #$4C0,$30(a1)
                move.w  #$4000,$3A(a1)
                jsr     (CreateNewSprite4).l
                bne.s   loc_54F2A
                move.l  #loc_55814,(a1)
                move.w  a1,(a5)+
                jsr     (CreateNewSprite4).l
                bne.s   loc_54F2A
                move.l  #loc_55814,(a1)
                move.w  a1,(a5)+

loc_54F2A:
                movem.l d7-a0/a2-a3,-(sp)
                lea     (ArtKosM_MHZShipPropeller).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZShipPropeller),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$4EF9,(H_int_jump).w
                move.l  #HInt7,(H_int_addr).w
                move.b  #$80,(H_int_counter).w
                move.w  #$8014,(VDP_control_port).l
                addq.w  #4,(Events_routine_fg).w

locret_54F62:
                rts
; ---------------------------------------------------------------------------

loc_54F64:
                jsr     UpdateMhz2ShipScrollCarryAndPropellers(pc)
                lea     MHZ2_BGDrawArray3(pc),a4
                lea     (HScroll_table).w,a6
                moveq   #2,d5
                move.w  (_unkEEA2).w,d6
                jsr     Draw_BGNoVert(pc)
                lea     MHZ2_BGDrawArray2(pc),a4
                lea     (HScroll_table+$004).w,a6
                moveq   #2,d5
                move.w  (Camera_Y_pos_rounded).w,d6
                jmp     Draw_BGNoVert(pc)

; =============== S U B R O U T I N E =======================================

UpdateMhz2ShipScrollCarryAndPropellers:
                move.w  (Camera_X_pos_copy).w,d0
                move.w  d0,(HScroll_table+$008).w
                addi.w  #$1E0,d0
                add.w   (_unkEE98).w,d0
                move.w  (HScroll_table).w,d2
                move.w  d0,(HScroll_table).w
                move.w  (_unkEE9C).w,d1
                lea     (Player_1).w,a1
                cmpi.b  #$81,object_control(a1)
                bne.s   loc_54FD4
                move.w  #$2DC,d3
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_54FC4
                move.w  #$2CD,d3

loc_54FC4:
                move.w  (Events_bg+$0C).w,d4
                sub.w   d1,d4
                add.w   d4,y_pos(a1)
                sub.w   d0,d2
                add.w   d2,x_pos(a1)

loc_54FD4:
                move.w  d1,(Events_bg+$0C).w
                neg.w   d1
                addi.w  #$158,d1
                lea     (HScroll_table+$00C).w,a1
                move.w  #$46B8,d2
                bsr.s   PositionMhz2ShipPropellerFromScroll
                move.w  #$45B8,d2
; End of function UpdateMhz2ShipScrollCarryAndPropellers

; =============== S U B R O U T I N E =======================================

PositionMhz2ShipPropellerFromScroll:
                move.w  (a1)+,d3
                beq.s   locret_55006
                movea.w d3,a5
                sub.w   d0,d2
                bcs.s   locret_55006
                addi.w  #$5C,d2
                andi.w  #$1FF,d2
                move.w  d2,$10(a5)
                move.w  d1,$14(a5)

locret_55006:
                rts
; End of function PositionMhz2ShipPropellerFromScroll

; =============== S U B R O U T I N E =======================================

SwitchMhz2RegionPalettes:
                lea     word_5513E(pc),a1
                move.w  (Player_1+x_pos).w,d0
                move.w  (Player_1+y_pos).w,d1
                moveq   #0,d2
                move.w  #5-1,d3

loc_5501A:
                lea     (a1),a5
                cmp.w   (a5)+,d0
                blo.s   loc_5502C
                cmp.w   (a5)+,d0
                bhi.s   loc_5502C
                cmp.w   (a5)+,d1
                blo.s   loc_5502C
                cmp.w   (a5)+,d1
                blo.s   loc_55038

loc_5502C:
                adda.w  #$A,a1
                addq.w  #4,d2
                dbf     d3,loc_5501A
                rts
; ---------------------------------------------------------------------------

loc_55038:
                jmp     loc_5503C(pc,d2.w)
; End of function SwitchMhz2RegionPalettes

; ---------------------------------------------------------------------------

loc_5503C:
                bra.w   loc_55050
; ---------------------------------------------------------------------------
                bra.w   loc_55062
; ---------------------------------------------------------------------------
                bra.w   loc_55074
; ---------------------------------------------------------------------------
                bra.w   loc_55074
; ---------------------------------------------------------------------------
                bra.w   loc_55086
; ---------------------------------------------------------------------------

loc_55050:
                tst.w   (Events_bg+$04).w
                bne.s   loc_5505C
                cmp.w   (a5),d1
                blo.s   loc_55098
                rts
; ---------------------------------------------------------------------------

loc_5505C:
                cmp.w   (a5),d1
                bhs.s   loc_550A8
                rts
; ---------------------------------------------------------------------------

loc_55062:
                tst.w   (Events_bg+$04).w
                bne.s   loc_5506E
                cmp.w   (a5),d0
                bhs.s   loc_55098
                rts
; ---------------------------------------------------------------------------

loc_5506E:
                cmp.w   (a5),d0
                blo.s   loc_550A8
                rts
; ---------------------------------------------------------------------------

loc_55074:
                tst.w   (Events_bg+$04).w
                bne.s   loc_55080
                cmp.w   (a5),d0
                blo.s   loc_55098
                rts
; ---------------------------------------------------------------------------

loc_55080:
                cmp.w   (a5),d0
                bhs.s   loc_550B8
                rts
; ---------------------------------------------------------------------------

loc_55086:
                tst.w   (Events_bg+$04).w
                bne.s   loc_55092
                cmp.w   (a5),d1
                blo.s   loc_55098
                rts
; ---------------------------------------------------------------------------

loc_55092:
                cmp.w   (a5),d1
                bhs.s   loc_550B8
                rts
; ---------------------------------------------------------------------------

loc_55098:
                st      (Events_bg+$04).w
                st      (_unkF7C1).w
                lea     (Pal_MHZ2+$20).l,a1
                bra.s   loc_550C4
; ---------------------------------------------------------------------------

loc_550A8:
                clr.w   (Events_bg+$04).w
                clr.b   (_unkF7C1).w
                lea     (Pal_MHZ1+$20).l,a1
                bra.s   loc_550C4
; ---------------------------------------------------------------------------

loc_550B8:
                clr.w   (Events_bg+$04).w
                st      (_unkF7C1).w
                lea     Pal_MHZ2Gold(pc),a1

loc_550C4:
                lea     (Normal_palette_line_3).w,a5
                moveq   #bytesToLcnt($40),d0

loc_550CA:
                move.l  (a1)+,(a5)+
                dbf     d0,loc_550CA
                rts
; ---------------------------------------------------------------------------
MHZ2_BGDrawArray1:
                dc.w    $2B0, $7FFF
MHZ2_BGDrawArray2:
                dc.w    $300, $7FFF
MHZ2_BGDrawArray3:
                dc.w    $100, $7FFF
Pal_MHZ2Ship:
                binclude "data/Levels/MHZ/Palettes/Act 2 Ship.bin"
                even
Pal_MHZ2Gold:
                binclude "data/Levels/MHZ/Palettes/Act 2 Gold.bin"
                even
word_5513E:
                dc.w    $420,  $4A0,  $640,  $6C0
                dc.w    $680,  $980,  $A00,  $7C0
                dc.w    $800,  $9C0, $2900, $2980
                dc.w    $280,  $300, $2940, $2B00
                dc.w    $2B80,  $540,  $580, $2B40
                dc.w    $2800, $2980,  $7C0,  $840
                dc.w    $800
