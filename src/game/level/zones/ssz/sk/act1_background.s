; Owner: game/level/zones/ssz/sk
; Responsibility: Sky Sanctuary act-one background initialization, events, deformation and private geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SSZ1_BackgroundInit:
                clr.w   (Events_bg+$10).w
                jsr     (AllocateObject).l
                bne.s   loc_57840
                move.l  #loc_57B6A,(a1)
                lea     word_5853E(pc),a5
                move.w  (a5)+,d1

loc_57812:
                jsr     (CreateNewSprite4).l
                bne.s   loc_57840
                move.l  #loc_57B8E,(a1)
                move.w  (a5)+,d2
                move.b  d2,render_flags(a1)
                move.b  #$80,height_pixels(a1)
                move.w  (a5)+,x_pos(a1)
                move.w  (a5)+,y_vel(a1)
                move.w  (a5)+,$2E(a1)
                move.l  (a5)+,$30(a1)
                dbf     d1,loc_57812

loc_57840:
                move.w  (Camera_Y_pos).w,d0
                and.w   (Screen_Y_wrap_value).w,d0
                cmpi.w  #$800,d0
                blo.s   loc_57854
                cmpi.w  #$F00,d0
                blo.s   loc_5786A

loc_57854:
                jsr     SetSsz1OrdinaryBackgroundAlignment(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                jsr     (Refresh_PlaneFull).l
                jmp     (PlainDeformation).l
; ---------------------------------------------------------------------------

loc_5786A:
                move.w  #8,(Events_routine_bg).w
                jsr     SSZ1_BuildMidAltitudeParallax(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                move.w  #$1C00,d1
                jsr     (Refresh_PlaneFull).l
                lea     SSZ1_BGDeformArray(pc),a4
                lea     (HScroll_table+$004).w,a5
                jmp     (ApplyDeformation).l
; ---------------------------------------------------------------------------

SSZ1_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     SSZ1_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SSZ1_BackgroundEvent_Index:
                bra.w   loc_578AA
; ---------------------------------------------------------------------------
                bra.w   loc_57942
; ---------------------------------------------------------------------------
                bra.w   loc_57960
; ---------------------------------------------------------------------------
                bra.w   loc_579D2
; ---------------------------------------------------------------------------

loc_578AA:
                move.w  (Camera_Y_pos).w,d0
                and.w   (Screen_Y_wrap_value).w,d0
                cmpi.w  #$800,d0
                blo.s   loc_578EC
                cmpi.w  #$F00,d0
                bhs.s   loc_578EC
                move.w  (Camera_X_pos_BG_copy).w,(Events_bg+$0C).w
                move.w  (Camera_Y_pos_BG_copy).w,(Events_bg+$0E).w
                jsr     SSZ1_BuildMidAltitudeParallax(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_57946
; ---------------------------------------------------------------------------

loc_578EC:
                jsr     SetSsz1OrdinaryBackgroundAlignment(pc)

loc_578F0:
                jsr     (DrawBGAsYouMove).l
                jsr     (PlainDeformation).l
                jsr     (ShakeScreen_Setup).l
                tst.w   (_unkEE98).w
                bne.s   loc_57916
                lea     word_577B2(pc),a4
                lea     (HScroll_table+$0BE).w,a5
                jmp     (Apply_FGVScroll).l
; ---------------------------------------------------------------------------

loc_57916:
                move.w  (_unkEEFA).w,d0
                beq.s   loc_57932
                clr.w   (_unkEEFA).w
                move.w  d0,(a0)+
                move.w  #7,(a0)+
                moveq   #$20-1,d0

loc_57928:
                move.w  #$6061,(a0)+
                dbf     d0,loc_57928
                clr.w   (a0)

loc_57932:
                move.w  (_unkEEEE).w,(V_scroll_value).w
                move.w  (Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
                addq.w  #4,sp
                rts
; ---------------------------------------------------------------------------

loc_57942:
                jsr     SSZ1_BuildMidAltitudeParallax(pc)

loc_57946:
                move.w  #$1C00,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.s   loc_5799A
                clr.w   (Events_bg+$0C).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_5799A
; ---------------------------------------------------------------------------

loc_57960:
                move.w  (Camera_Y_pos).w,d0
                and.w   (Screen_Y_wrap_value).w,d0
                cmpi.w  #$800,d0
                blo.s   loc_57974
                cmpi.w  #$F00,d0
                blo.s   loc_57996

loc_57974:
                jsr     SetSsz1OrdinaryBackgroundAlignment(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_579D6
; ---------------------------------------------------------------------------

loc_57996:
                jsr     SSZ1_BuildMidAltitudeParallax(pc)

loc_5799A:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                move.w  #$1C00,d1
                moveq   #$20,d6
                jsr     (Draw_TileRow).l
                move.w  (Events_bg+$0C).w,d0
                beq.s   loc_579C4
                move.w  d0,(Camera_X_pos_BG_copy).w
                move.w  (Events_bg+$0E).w,(Camera_Y_pos_BG_copy).w
                jmp     (PlainDeformation).l
; ---------------------------------------------------------------------------

loc_579C4:
                lea     SSZ1_BGDeformArray(pc),a4
                lea     (HScroll_table+$004).w,a5
                jmp     (ApplyDeformation).l
; ---------------------------------------------------------------------------

loc_579D2:
                jsr     SetSsz1OrdinaryBackgroundAlignment(pc)

loc_579D6:
                move.w  (Camera_X_pos_BG_copy).w,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     (Draw_PlaneVertSingleBottomUp).l
                bpl.w   loc_578F0
                clr.w   (Events_routine_bg).w
                bra.w   loc_578F0

; =============== S U B R O U T I N E =======================================

SetSsz1OrdinaryBackgroundAlignment:
                tst.w   (Events_bg+$10).w
                bne.s   loc_57A30
                cmpi.w  #$1800,(Camera_X_pos).w
                blo.s   loc_57A12
                st      (Events_bg+$10).w
                bsr.s   SetSsz1OrdinaryBackgroundAlignment
                move.w  (Camera_X_pos_BG_copy).w,d0
                andi.w  #$FFF0,d0
                move.w  d0,(Camera_X_pos_BG_rounded).w
                rts
; ---------------------------------------------------------------------------

loc_57A12:
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$160,d0
                add.w   (_unkEE9C).w,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                addi.w  #$28,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                rts
; ---------------------------------------------------------------------------

loc_57A30:
                cmpi.w  #$1800,(Camera_X_pos).w
                bhs.s   loc_57A4C
                clr.w   (Events_bg+$10).w
                bsr.s   SetSsz1OrdinaryBackgroundAlignment
                move.w  (Camera_X_pos_BG_copy).w,d0
                andi.w  #$FFF0,d0
                move.w  d0,(Camera_X_pos_BG_rounded).w
                rts
; ---------------------------------------------------------------------------

loc_57A4C:
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$180,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,(Camera_X_pos_BG_copy).w
                rts
; End of function SetSsz1OrdinaryBackgroundAlignment

; =============== S U B R O U T I N E =======================================

; Build thirty regional scroll words with a shared drift accumulator
SSZ1_BuildMidAltitudeParallax:
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (_unkEE9C).w,d1
                asr.w   #1,d1
                add.w   d1,d0
                and.w   (Screen_Y_wrap_value).w,d0
                subi.w  #$800,d0
                asr.w   #1,d0
                addi.w  #$A0,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                lea     (HScroll_table+$004).w,a1
                move.l  -4(a1),d2
                addi.l  #$500,-4(a1)
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #5,d0
                move.l  d0,d1
                asr.l   #1,d0
                add.l   d2,d0
                swap    d0
                move.w  d0,(a1)
                move.w  d0,6(a1)
                move.w  d0,$A(a1)
                move.w  d0,$14(a1)
                swap    d0
                add.l   d2,d1
                add.l   d1,d0
                swap    d0
                move.w  d0,8(a1)
                move.w  d0,$E(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,4(a1)
                move.w  d0,$C(a1)
                move.w  d0,$12(a1)
                move.w  d0,$16(a1)
                move.w  d0,$3A(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,2(a1)
                move.w  d0,$10(a1)
                move.w  d0,$18(a1)
                move.w  d0,$38(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,$1A(a1)
                move.w  d0,$36(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,$1C(a1)
                move.w  d0,$34(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,$1E(a1)
                move.w  d0,$32(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,$20(a1)
                move.w  d0,$30(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,$22(a1)
                move.w  d0,$2E(a1)
                swap    d0
                add.l   d1,d0
                add.l   d1,d0
                swap    d0
                move.w  d0,$24(a1)
                move.w  d0,$2C(a1)
                swap    d0
                move.l  d1,d2
                asr.l   #1,d2
                add.l   d1,d0
                add.l   d1,d0
                add.l   d2,d0
                swap    d0
                move.w  d0,$26(a1)
                move.w  d0,$2A(a1)
                swap    d0
                add.l   d1,d0
                add.l   d1,d0
                add.l   d2,d0
                swap    d0
                move.w  d0,$28(a1)
                rts
; End of function SSZ1_BuildMidAltitudeParallax

; ---------------------------------------------------------------------------

loc_57B6A:
                move.l  #loc_57B76,(a0)
                move.w  #$8000,$30(a0)

loc_57B76:
                move.l  #$8000,d0
                move.l  #$100,d1
                jsr     (Gradual_SwingOffset).l
                move.w  d0,(_unkEE9C).w
                rts
; ---------------------------------------------------------------------------

loc_57B8E:
                bset    #7,status(a0)
                move.w  y_vel(a0),d0
                sub.w   (_unkEE9C).w,d0
                move.w  d0,y_pos(a0)
                move.w  $2E(a0),d1
                movea.l $30(a0),a2
                move.w  x_pos(a0),d4
                jmp     (SolidObjectTopSloped2).l
; ---------------------------------------------------------------------------

loc_57BB2:
                move.l  #loc_57BF6,(a0)
                move.b  #$40,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$30,width_pixels(a0)
                move.w  #0,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$3C,3,1),art_tile(a0)
                move.l  #Map_SSZRoamingClouds,mappings(a0)
                move.w  $38(a0),y_vel(a0)
                jsr     (Random_Number).l
                andi.w  #$FFF,d0
                addi.w  #$C00,d0
                move.w  d0,$30(a0)

loc_57BF6:
                move.l  #$1C00,d0
                move.l  #$80,d1
                jsr     (Gradual_SwingOffset).l
                add.w   y_vel(a0),d0
                move.w  d0,$38(a0)
                move.l  $3E(a0),d0
                sub.l   d0,$3A(a0)
                jmp     (Draw_Sprite).l
