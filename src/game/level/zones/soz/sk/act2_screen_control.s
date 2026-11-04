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
                blo.s   SKSOZ2FG_RefreshInitialForeground
                jsr     SOZ2_RestoreForegroundFromTemplate(pc)

SKSOZ2FG_RefreshInitialForeground:
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
                bra.w   SKSOZ2FG_RestoreWrapAndBeginRedraw
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2FG_RedrawForegroundBottomUp
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2FG_TryRestoreTemplate
; ---------------------------------------------------------------------------

SKSOZ2FG_RestoreWrapAndBeginRedraw:
                move.w  #$7FF,(Screen_Y_wrap_value).w
                move.w  #$7F0,(Camera_Y_pos_mask).w
                move.w  #$3C,(Layout_row_index_mask).w
                jsr     (Reset_TileOffsetPositionActual).l
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_fg).w

SKSOZ2FG_RedrawForegroundBottomUp:
                move.w  (Camera_X_pos_copy).w,d1
                move.w  (Camera_Y_pos_copy).w,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.s   SKSOZ2FG_TryRestoreTemplate
                addq.w  #4,(Events_routine_fg).w

SKSOZ2FG_TryRestoreTemplate:
                tst.w   (Events_fg_4).w
                beq.s   SKSOZ2FG_DrawForeground
                clr.w   (Events_fg_4).w
                bsr.s   SOZ2_RestoreForegroundFromTemplate

SKSOZ2FG_DrawForeground:
                jmp     (DrawTilesAsYouMove).l

; =============== S U B R O U T I N E =======================================

; Copy forty chunk indices from the template columns into two foreground regions
SOZ2_RestoreForegroundFromTemplate:
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

SKSOZ2FG_BeginTemplateRow:
                moveq   #8,d2

SKSOZ2FG_CopyTemplateRowBytes:
                move.b  (a5)+,(a1)+
                dbf     d2,SKSOZ2FG_CopyTemplateRowBytes
                adda.w  d0,a1
                adda.w  d0,a5
                dbf     d1,SKSOZ2FG_BeginTemplateRow
                rts
; End of function SOZ2_RestoreForegroundFromTemplate
