; Owner: game/level/zones/hpz/sk
; Responsibility: Hidden Palace screen and background initialization, event state and progression control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

HPZ_ScreenInit:
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_5A13E
                move.w  #$AA0,(Camera_max_X_pos).w
                bra.s   loc_5A14C
; ---------------------------------------------------------------------------

loc_5A13E:
                cmpi.w  #$480,(Player_1+y_pos).w
                bhs.s   loc_5A14C
                move.w  #$AA0,(Camera_min_X_pos).w

loc_5A14C:
                jsr     (Reset_TileOffsetPositionActual).l
                jmp     (Refresh_PlaneFull).l
; ---------------------------------------------------------------------------

HPZ_ScreenEvent:
                tst.w   (Events_bg+$00).w
                bne.s   loc_5A176
                tst.w   (Palette_fade_timer).w
                bne.s   loc_5A176
                jsr     (AllocateObject).l
                bne.s   loc_5A172
                move.l  #Obj_HPZPaletteControl,(a1)

loc_5A172:
                st      (Events_bg+$00).w

loc_5A176:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                tst.w   (Events_fg_4).w
                beq.s   loc_5A19E
                clr.w   (Events_fg_4).w
                movea.w $1C(a3),a1
                move.b  #$61,$30(a1)
                move.b  #$61,$31(a1)
                jmp     (Refresh_PlaneScreenDirect).l
; ---------------------------------------------------------------------------

loc_5A19E:
                jmp     (DrawTilesAsYouMove).l
; ---------------------------------------------------------------------------

HPZ_BackgroundInit:
                move.w  $14(a3),$18(a3)
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_5A1C2
                movea.w 4(a3),a1
                move.b  #$8E,3(a1)
                move.b  #$8F,4(a1)

loc_5A1C2:
                cmpi.w  #$EC0,(Player_1+x_pos).w
                bhs.s   loc_5A1D0
                jsr     BuildHpzLeftRegionParallax(pc)
                bra.s   loc_5A1DA
; ---------------------------------------------------------------------------

loc_5A1D0:
                move.w  #8,(Events_routine_bg).w
                jsr     BuildHpzRightRegionParallax(pc)

loc_5A1DA:
                jsr     (Reset_TileOffsetPositionEff).l
                lea     (HScroll_table).w,a1
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)+
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)
                lea     HPZ_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                jsr     (Refresh_PlaneTileDeform).l
                lea     HPZ_BGDeformArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                jmp     (ApplyDeformation).l
; ---------------------------------------------------------------------------

HPZ_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     HPZ_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

HPZ_BackgroundEvent_Index:
                bra.w   loc_5A224
; ---------------------------------------------------------------------------
                bra.w   loc_5A288
; ---------------------------------------------------------------------------
                bra.w   loc_5A2A6
; ---------------------------------------------------------------------------
                bra.w   loc_5A30A
; ---------------------------------------------------------------------------

loc_5A224:
                cmpi.w  #$EC0,(Player_1+x_pos).w
                blo.s   loc_5A25E
                jsr     BuildHpzRightRegionParallax(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                lea     (HScroll_table).w,a1
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)+
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_5A28C
; ---------------------------------------------------------------------------

loc_5A25E:
                jsr     BuildHpzLeftRegionParallax(pc)

loc_5A262:
                lea     HPZ_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #2,d5
                jsr     (Draw_BG).l
                lea     HPZ_BGDeformArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                jsr     (ApplyDeformation).l
                jmp     (ShakeScreen_Setup).l
; ---------------------------------------------------------------------------

loc_5A288:
                jsr     BuildHpzRightRegionParallax(pc)

loc_5A28C:
                lea     HPZ_BGDrawArray(pc),a4
                lea     (HScroll_table-$04).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d1
                jsr     (Draw_PlaneVertBottomUpComplex).l
                bpl.s   loc_5A2E4
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_5A2E4
; ---------------------------------------------------------------------------

loc_5A2A6:
                cmpi.w  #$EC0,(Player_1+x_pos).w
                bhs.s   loc_5A2E0
                jsr     BuildHpzLeftRegionParallax(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                lea     (HScroll_table).w,a1
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)+
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_5A30E
; ---------------------------------------------------------------------------

loc_5A2E0:
                jsr     BuildHpzRightRegionParallax(pc)

loc_5A2E4:
                lea     HPZ_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #2,d5
                jsr     (Draw_BG).l
                lea     HPZ_BGDeformArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                jsr     (ApplyDeformation).l
                jmp     (ShakeScreen_Setup).l
; ---------------------------------------------------------------------------

loc_5A30A:
                jsr     BuildHpzLeftRegionParallax(pc)

loc_5A30E:
                lea     HPZ_BGDrawArray(pc),a4
                lea     (HScroll_table-$04).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d1
                jsr     (Draw_PlaneVertBottomUpComplex).l
                bpl.w   loc_5A262
                clr.w   (Events_routine_bg).w
                bra.w   loc_5A262

; =============== S U B R O U T I N E =======================================

BuildHpzLeftRegionParallax:
                move.w  #$348,d2
                moveq   #0,d3
                bra.s   loc_5A33C
; End of function BuildHpzLeftRegionParallax

; =============== S U B R O U T I N E =======================================

BuildHpzRightRegionParallax:
                move.w  #$E00,d2
                move.w  #$700,d3

loc_5A33C:
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Screen_shake_offset).w,d4
                sub.w   d4,d0
                add.w   d3,d0
                swap    d0
                clr.w   d0
                asr.l   #4,d0
                move.l  d0,d1
                add.l   d0,d0
                add.l   d1,d0
                swap    d0
                add.w   d4,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                sub.w   d2,d0
                swap    d0
                clr.w   d0
                move.l  d0,d2
                asr.l   #4,d0
                move.l  d0,d1
                add.l   d0,d0
                add.l   d1,d0
                swap    d0
                move.w  d0,(HScroll_table).w
                move.w  d0,(HScroll_table+$008).w
                lea     (HScroll_table+$01C).w,a1
                move.l  d2,d0
                asr.l   #2,d2
                sub.l   d2,d0
                asr.l   #2,d2
                moveq   #9-1,d1

loc_5A388:
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                sub.l   d2,d0
                dbf     d1,loc_5A388
                move.w  (HScroll_table+$01A).w,(HScroll_table+$004).w
                rts
; End of function BuildHpzRightRegionParallax

; ---------------------------------------------------------------------------
HPZ_BGDrawArray:
                dc.w    $200, $7FFF
HPZ_BGDeformArray:
                dc.w    $198,     8,     4,     4,     8,     8,   $10,     8,   $30, $7FFF
