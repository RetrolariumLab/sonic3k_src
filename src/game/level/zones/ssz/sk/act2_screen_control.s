; Owner: game/level/zones/ssz/sk
; Responsibility: Sky Sanctuary act-two screen initialization, event dispatch and progression control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SSZ2_ScreenInit:
                st      (Palette_cycle_counters+$00).w
                jsr     (AllocateObject).l
                bne.s   loc_58A92
                move.l  #Obj_57C1E,(a1)
                move.w  #$A0,x_pos(a1)
                move.b  #$44,$2D(a1)
                moveq   #0,d1
                move.w  d1,(Camera_X_pos_copy).w
                move.w  d1,(Camera_X_pos).w
                move.w  #$649,d1
                move.w  d1,(Camera_Y_pos_copy).w
                move.w  d1,(Camera_Y_pos).w
                st      (Scroll_lock).w
                jsr     (CreateNewSprite4).l
                bne.s   loc_58A92
                move.l  #loc_59078,(a1)
                move.w  #1,$30(a1)

loc_58A92:
                jsr     (Reset_TileOffsetPositionActual).l
                moveq   #0,d1
                jmp     (Refresh_PlaneFull).l
; ---------------------------------------------------------------------------

SSZ2_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                move.w  (Events_routine_fg).w,d0
                jmp     SSZ2_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SSZ2_ScreenEvent_Index:
                bra.w   loc_58ACC
; ---------------------------------------------------------------------------
                bra.w   loc_58AE0
; ---------------------------------------------------------------------------
                bra.w   loc_58B20
; ---------------------------------------------------------------------------
                bra.w   loc_58B7C
; ---------------------------------------------------------------------------
                bra.w   loc_58B9E
; ---------------------------------------------------------------------------
                bra.w   loc_58C42
; ---------------------------------------------------------------------------
                bra.w   loc_58C68
; ---------------------------------------------------------------------------

loc_58ACC:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                bne.w   loc_58C68
                addq.w  #4,(Special_V_int_routine).w
                addq.w  #4,(Events_routine_fg).w

loc_58AE0:
                tst.w   (Events_fg_4).w
                beq.w   loc_58C68
                clr.w   (Events_fg_4).w
                movea.w $24(a3),a1
                movea.w $28(a3),a5
                moveq   #4-1,d0

loc_58AF6:
                move.b  #$17,(a1)+
                move.b  #$18,(a1)+
                move.b  #$19,(a5)+
                move.b  #$19,(a5)+
                dbf     d0,loc_58AF6
                move.b  #$17,(a1)
                move.b  #$19,(a5)
                st      (Ending_running_flag).w
                addq.w  #4,(Events_routine_fg).w
                jmp     (Refresh_PlaneFullDirect).l
; ---------------------------------------------------------------------------

loc_58B20:
                tst.w   (Events_fg_4).w
                beq.w   loc_58C68
                bmi.w   loc_58C68
                clr.w   (Events_fg_4).w
                move    #$2700,sr
                lea     (VDP_data_port).l,a6
                move.l  #vdpComm(tiles_to_bytes($7F0),VRAM,WRITE),(VDP_control_port).l
                move.l  #$66666666,d0
                moveq   #bytesToLcnt(tiles_to_bytes($10)),d1

loc_58B4C:
                move.l  d0,(a6)
                dbf     d1,loc_58B4C
                move    #$2300,sr
                jsr     (AllocateObject).l
                bne.s   loc_58B64
                move.l  #loc_591D6,(a1)

loc_58B64:
                move.w  #$1F0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                clr.b   (Palette_cycle_counters+$00).w
                addq.w  #4,(Events_routine_fg).w
                bra.w   locret_58C7E
; ---------------------------------------------------------------------------

loc_58B7C:
                move.w  #$200,d1
                move.w  #$100,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.w   locret_58C7E
                clr.w   (Camera_Y_pos_copy).w
                clr.l   (Camera_Y_pos).w
                clr.w   (Camera_X_pos).w
                addq.w  #4,(Events_routine_fg).w

loc_58B9E:
                movem.l d7-a0/a2-a3,-(sp)
                jsr     (SKCredits_DispatchScrollState).l
                movem.l (sp)+,d7-a0/a2-a3
                cmpi.b  #7,(Super_emerald_count).w
                bhs.s   loc_58BBC
                cmpi.b  #7,(Chaos_emerald_count).w
                blo.s   loc_58C1A

loc_58BBC:
                jsr     CycleSsz2EmeraldEndingAccentPalette(pc)
                tst.w   (_unkFAAE).w
                beq.w   locret_58C7E
                move.w  #$14C0,d0
                tst.w   (SK_alone_flag).w
                bne.s   loc_58BD6
                move.w  #$1660,d0

loc_58BD6:
                cmp.w   (Camera_Y_pos).w,d0
                bne.w   locret_58C7E
                tst.w   (Events_routine_bg).w
                bne.w   locret_58C7E
                clr.b   (_unkFAB9).w
                move.w  (Camera_Y_pos_BG_copy).w,d0
                addi.w  #$100,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                clr.w   (Camera_Y_pos_BG_copy+2).w
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Camera_Y_pos_BG_rounded).w
                lea     (Pal_Ending2).l,a1
                lea     (Normal_palette_line_2).w,a5
                moveq   #bytesToLcnt($60),d0

loc_58C0E:
                move.l  (a1)+,(a5)+
                dbf     d0,loc_58C0E
                addq.w  #4,(Events_routine_bg).w
                bra.s   locret_58C7E
; ---------------------------------------------------------------------------

loc_58C1A:
                tst.w   (Events_fg_4).w
                beq.s   locret_58C7E
                lea     (Pal_Ending1).l,a1
                lea     (Normal_palette_line_2).w,a5
                moveq   #bytesToLcnt($60),d0

loc_58C2C:
                move.l  (a1)+,(a5)+
                dbf     d0,loc_58C2C
                move.w  #$7F0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_fg).w

loc_58C42:
                moveq   #0,d1
                move.w  #$700,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.s   locret_58C7E
                move.w  #$720,d0
                move.w  d0,(Camera_Y_pos_copy).w
                move.w  d0,(Camera_Y_pos).w
                clr.w   (Camera_Y_pos+2).w
                move.w  d0,(Camera_Y_pos_rounded).w
                addq.w  #4,(Events_routine_fg).w

loc_58C68:
                jsr     CycleSsz2EndingWaterPalette(pc)
                lea     (Camera_Y_pos_copy).w,a6
                lea     (Camera_Y_pos_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jmp     (Draw_TileRow).l
; ---------------------------------------------------------------------------

locret_58C7E:
                rts
; ---------------------------------------------------------------------------
word_58C80:
                dc.w    $380
                dc.w    $10
                dc.w    $10
                dc.w    $18
                dc.w    $10
                dc.w    8
                dc.w    $10
                dc.w    $10
                dc.w    8
                dc.w    $38
                dc.w    $10
                dc.w    $10
                dc.w    $28
                dc.w    8
                dc.w    $20
                dc.w    8
                dc.w    8
                dc.w    8
                dc.w    8
                dc.w    8
                dc.w    $18
                dc.w    $20
                dc.w    $30
                dc.w    8
                dc.w    8
                dc.w    $10
                dc.w    8
                dc.w    $28
                dc.w    $10
                dc.w    $10
                dc.w    $18
                dc.w    $10
                dc.w    8
                dc.w    $10
                dc.w    $10
                dc.w    8
                dc.w    $7FFF
