; Owner: rendering/sk
; Responsibility: Deformed tile drawing, range selection and directional plane operations
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Get_DeformDrawPosVert:
                move.w  (a4)+,d2
                move.w  (a6),d0
                bsr.s   FindVerticalDeformationBand
                addi.w  #$E0,d0
; End of function Get_DeformDrawPosVert

; =============== S U B R O U T I N E =======================================

FindVerticalDeformationBand:
                cmp.w   d2,d0
                bmi.s   SKTileDraw_ReturnBandHScroll
                add.w   (a4)+,d2
                addq.w  #4,a5
                bra.s   FindVerticalDeformationBand
; ---------------------------------------------------------------------------

; Return the selected scroll word in the upper half of d1
SKTileDraw_ReturnBandHScroll:
                move.w  (a5),d1
                swap    d1
                rts
; End of function FindVerticalDeformationBand

; ---------------------------------------------------------------------------

DrawTilesVDeform:
                movem.l d5/a4-a5,-(sp)
                lea     (Camera_X_pos_copy).w,a6
                jsr     Get_XDeformRange(pc)
                lea     (Camera_X_pos_rounded).w,a5
                jsr     Draw_TileColumn2(pc)
                movem.l (sp)+,d5/a4/a6
                move.w  (Camera_X_pos_rounded).w,d6
                bra.s   SKTileDraw_SeedRowBandX

; ---------------------------------------------------------------------------

DrawTilesVDeform2:
                movem.l d5/a4-a5,-(sp)
                lea     (Camera_X_pos_BG_copy).w,a6
                jsr     Get_XDeformRange(pc)
                lea     (Camera_X_pos_BG_rounded).w,a5
                jsr     Draw_TileColumn2(pc)
                movem.l (sp)+,d5/a4/a6
                move.w  (Camera_X_pos_BG_rounded).w,d6

SKTileDraw_SeedRowBandX:
                move.w  d6,d1

SKTileDraw_SkipOffscreenRowBands:
                sub.w   (a4)+,d6
                bcs.s   SKTileDraw_CalcFirstVisibleRowWidth
                move.w  (a6)+,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(a6)+
                subq.w  #1,d5
                bra.s   SKTileDraw_SkipOffscreenRowBands
; ---------------------------------------------------------------------------

SKTileDraw_CalcFirstVisibleRowWidth:
                neg.w   d6
                lsr.w   #4,d6
                moveq   #$15,d4
                sub.w   d6,d4
                bcc.s   SKTileDraw_DrawVisibleBandRow
                moveq   #0,d4
                moveq   #$15,d6

SKTileDraw_DrawVisibleBandRow:
                movem.w d1/d4-d6,-(sp)
                movem.l a4/a6,-(sp)
                lea     2(a6),a5
                jsr     Draw_TileRow(pc)
                movem.l (sp)+,a4/a6
                movem.w (sp)+,d1/d4-d6
                addq.w  #4,a6
                tst.w   d4
                beq.s   SKTileDraw_SyncHiddenBandY
                lsl.w   #4,d6
                add.w   d6,d1
                subq.w  #1,d5
                move.w  (a4)+,d6
                lsr.w   #4,d6
                move.w  d4,d0
                sub.w   d6,d4
                bcc.s   SKTileDraw_DrawVisibleBandRow
                move.w  d0,d6
                moveq   #0,d4
                bra.s   SKTileDraw_DrawVisibleBandRow
; ---------------------------------------------------------------------------

SKTileDraw_SyncHiddenBandY:
                subq.w  #1,d5
                beq.s   SKTileDraw_DeformedRowsReturn
                move.w  (a6)+,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(a6)+
                bra.s   SKTileDraw_SyncHiddenBandY
; ---------------------------------------------------------------------------

SKTileDraw_DeformedRowsReturn:
                rts

; =============== S U B R O U T I N E =======================================

Get_XDeformRange:
                move.w  (a4)+,d2
                move.w  (a6),d0
                bsr.s   FindHorizontalDeformationBand
                addi.w  #$140,d0
; End of function Get_XDeformRange

; =============== S U B R O U T I N E =======================================

FindHorizontalDeformationBand:
                cmp.w   d2,d0
                blo.s   SKTileDraw_ReturnBandVScroll
                add.w   (a4)+,d2
                addq.w  #4,a5
                bra.s   FindHorizontalDeformationBand
; ---------------------------------------------------------------------------

; Return the selected scroll word in the upper half of d1
SKTileDraw_ReturnBandVScroll:
                move.w  (a5),d1
                swap    d1
                rts
; End of function FindHorizontalDeformationBand

; =============== S U B R O U T I N E =======================================

Draw_PlaneVertBottomUp:
                movem.w d1-d2,-(sp)
                bsr.s   Draw_PlaneVertSingleBottomUp
                movem.w (sp)+,d1-d2
                bpl.s   Draw_PlaneVertSingleBottomUp
                rts
; End of function Draw_PlaneVertBottomUp

; =============== S U B R O U T I N E =======================================

Draw_PlaneVertSingleBottomUp:
                and.w   (Camera_Y_pos_mask).w,d2
                move.w  d2,d3
                addi.w  #$F0,d3
                and.w   (Camera_Y_pos_mask).w,d3
                move.w  (Draw_delayed_position).w,d0
                cmp.w   d2,d0
                blo.s   SKTileDraw_AdvanceBottomUp
                cmp.w   d3,d0
                bhi.s   SKTileDraw_AdvanceBottomUp
                moveq   #$20,d6
                jsr     Setup_TileRowDraw(pc)

; Return the row counter's condition codes for the caller's continuation check
SKTileDraw_AdvanceBottomUp:
                subi.w  #$10,(Draw_delayed_position).w
                subq.w  #1,(Draw_delayed_rowcount).w
                rts
; End of function Draw_PlaneVertSingleBottomUp

; =============== S U B R O U T I N E =======================================

Draw_PlaneVertTopDown:
                and.w   (Camera_Y_pos_mask).w,d2
                move.w  d2,d3
                addi.w  #$F0,d3
                and.w   (Camera_Y_pos_mask).w,d3
                move.w  (Draw_delayed_position).w,d0
                cmp.w   d2,d0
                blo.s   SKTileDraw_AdvanceTopDown
                cmp.w   d3,d0
                bhi.s   SKTileDraw_AdvanceTopDown
                moveq   #$20,d6
                jsr     Setup_TileRowDraw(pc)

SKTileDraw_AdvanceTopDown:
                addi.w  #$10,(Draw_delayed_position).w
                subq.w  #1,(Draw_delayed_rowcount).w
                rts
; End of function Draw_PlaneVertTopDown

; =============== S U B R O U T I N E =======================================

Draw_PlaneHorzRightToLeft:
                movem.w d1-d2,-(sp)
                bsr.s   DrawPlaneRightToLeftStep
                movem.w (sp)+,d1-d2
                bpl.s   DrawPlaneRightToLeftStep
                rts
; End of function Draw_PlaneHorzRightToLeft

; =============== S U B R O U T I N E =======================================

DrawPlaneRightToLeftStep:
                andi.w  #$FFF0,d2
                move.w  d2,d3
                addi.w  #$1F0,d3
                andi.w  #$FFF0,d3
                move.w  (Draw_delayed_position).w,d0
                cmp.w   d2,d0
                blo.s   SKTileDraw_AdvanceRightToLeft
                cmp.w   d3,d0
                bhi.s   SKTileDraw_AdvanceRightToLeft
                moveq   #$10,d6
                jsr     Setup_TileColumnDraw(pc)

SKTileDraw_AdvanceRightToLeft:
                subi.w  #$10,(Draw_delayed_position).w
                subq.w  #1,(Draw_delayed_rowcount).w
                rts
; End of function DrawPlaneRightToLeftStep

; =============== S U B R O U T I N E =======================================

Draw_PlaneHorzLeftToRight:
                movem.w d1-d2,-(sp)
                bsr.s   DrawPlaneLeftToRightStep
                movem.w (sp)+,d1-d2
                bpl.s   DrawPlaneLeftToRightStep
                rts
; End of function Draw_PlaneHorzLeftToRight

; =============== S U B R O U T I N E =======================================

DrawPlaneLeftToRightStep:
                andi.w  #$FFF0,d2
                move.w  d2,d3
                addi.w  #$1F0,d3
                andi.w  #$FFF0,d3
                move.w  (Draw_delayed_position).w,d0
                cmp.w   d2,d0
                blo.s   SKTileDraw_AdvanceLeftToRight
                cmp.w   d3,d0
                bhi.s   SKTileDraw_AdvanceLeftToRight
                moveq   #$10,d6
                jsr     Setup_TileColumnDraw(pc)

SKTileDraw_AdvanceLeftToRight:
                addi.w  #$10,(Draw_delayed_position).w
                subq.w  #1,(Draw_delayed_rowcount).w
                rts
; End of function DrawPlaneLeftToRightStep

; =============== S U B R O U T I N E =======================================

Draw_PlaneVertBottomUpComplex:
                movem.l d1/a4-a5,-(sp)
                bsr.s   DrawDeformedPlaneBottomUpStep
                movem.l (sp)+,d1/a4-a5
                bpl.s   DrawDeformedPlaneBottomUpStep
                rts
; End of function Draw_PlaneVertBottomUpComplex

; =============== S U B R O U T I N E =======================================

DrawDeformedPlaneBottomUpStep:
                and.w   (Camera_Y_pos_mask).w,d1
                move.w  d1,d2
                addi.w  #$F0,d2
                and.w   (Camera_Y_pos_mask).w,d2
                move.w  (Draw_delayed_position).w,d0
                cmp.w   d1,d0
                blo.s   SKTileDraw_AdvanceDeformedBottomUp
                cmp.w   d2,d0
                bhi.s   SKTileDraw_AdvanceDeformedBottomUp

SKTileDraw_FindRedrawScroll:
                addq.w  #4,a5
                cmp.w   (a4)+,d0
                bpl.s   SKTileDraw_FindRedrawScroll
                move.w  (a5),d1
                moveq   #$20,d6
                jsr     Setup_TileRowDraw(pc)

; Return the row counter's condition codes for the caller's continuation check
SKTileDraw_AdvanceDeformedBottomUp:
                subi.w  #$10,(Draw_delayed_position).w
                subq.w  #1,(Draw_delayed_rowcount).w
                rts
; End of function DrawDeformedPlaneBottomUpStep
