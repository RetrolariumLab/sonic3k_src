; Owner: game/level/zones/soz/sk
; Responsibility: Sandopolis act-two screen initialization, event dispatch and progression control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SOZ2_ScreenInit:
                move.w  #$7FF,(Screen_Y_wrap_value).w
                move.w  #$7F0,(Camera_Y_pos_mask).w
                move.w  #$3C,(Layout_row_index_mask).w
                move.w  #8,(Events_routine_fg).w
                cmpi.w  #$4E80,(Player_1+x_pos).w
                blo.s   loc_561B0
                jsr     RestoreSoz2ForegroundSectionsFromTemplate(pc)

loc_561B0:
                jsr     (Reset_TileOffsetPositionActual).l
                jmp     (Refresh_PlaneFull).l
; ---------------------------------------------------------------------------

SOZ2_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                move.w  (Events_routine_fg).w,d0
                jmp     SOZ2_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SOZ2_ScreenEvent_Index:
                bra.w   loc_561D8
; ---------------------------------------------------------------------------
                bra.w   loc_56206
; ---------------------------------------------------------------------------
                bra.w   loc_5621A
; ---------------------------------------------------------------------------

loc_561D8:
                move.w  #$7FF,(Screen_Y_wrap_value).w
                move.w  #$7F0,(Camera_Y_pos_mask).w
                move.w  #$3C,(Layout_row_index_mask).w
                jsr     (Reset_TileOffsetPositionActual).l
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_fg).w

loc_56206:
                move.w  (Camera_X_pos_copy).w,d1
                move.w  (Camera_Y_pos_copy).w,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.s   loc_5621A
                addq.w  #4,(Events_routine_fg).w

loc_5621A:
                tst.w   (Events_fg_4).w
                beq.s   loc_56226
                clr.w   (Events_fg_4).w
                bsr.s   RestoreSoz2ForegroundSectionsFromTemplate

loc_56226:
                jmp     (DrawTilesAsYouMove).l

; =============== S U B R O U T I N E =======================================

RestoreSoz2ForegroundSectionsFromTemplate:
                movea.w $1C(a3),a1
                lea     $AB(a1),a5
                lea     $95(a1),a1
                move.b  (a5)+,(a1)+
                move.b  (a5)+,(a1)+
                move.b  (a5)+,(a1)+
                move.b  (a5)+,(a1)+
                movea.w $28(a3),a1
                lea     $AB(a1),a5
                lea     $8C(a1),a1
                move.w  -8(a3),d0
                subi.w  #9,d0
                moveq   #4-1,d1

loc_56256:
                moveq   #8,d2

loc_56258:
                move.b  (a5)+,(a1)+
                dbf     d2,loc_56258
                adda.w  d0,a1
                adda.w  d0,a5
                dbf     d1,loc_56256
                rts
; End of function RestoreSoz2ForegroundSectionsFromTemplate
