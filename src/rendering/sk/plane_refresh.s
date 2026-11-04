; Owner: rendering/sk
; Responsibility: Full or partial plane refresh, direct scroll modes and drawing during camera motion
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Refresh_PlaneFull:
                moveq   #$10-1,d2

                .loop:
                movem.l d0-d2/a0,-(sp)
                moveq   #$20,d6
                jsr     Setup_TileRowDraw(pc)
                jsr     VInt_DrawLevel(pc)
                movem.l (sp)+,d0-d2/a0
                addi.w  #$10,d0
                dbf     d2,.loop
                rts
; End of function Refresh_PlaneFull

; =============== S U B R O U T I N E =======================================

Refresh_PlaneTileDeform:
                move.w  (a4)+,d2
                moveq   #$10-1,d3

SKTileDraw_FindFullRowBand:
                cmp.w   d2,d0
                bmi.s   SKTileDraw_UploadFullBandRow
                add.w   (a4)+,d2
                addq.w  #4,a5
                bra.s   SKTileDraw_FindFullRowBand
; ---------------------------------------------------------------------------

SKTileDraw_UploadFullBandRow:
                move.w  (a5),d1
                moveq   #$20,d6
                movem.l d0/d2-d3/a0/a4-a5,-(sp)
                jsr     Setup_TileRowDraw(pc)
                jsr     VInt_DrawLevel(pc)
                movem.l (sp)+,d0/d2-d3/a0/a4-a5
                addi.w  #$10,d0
                dbf     d3,SKTileDraw_FindFullRowBand
                rts
; End of function Refresh_PlaneTileDeform

; ---------------------------------------------------------------------------

Refresh_PlaneDirectVScroll:
                move.w  (a4)+,d2
                moveq   #$20-1,d3

SKTileDraw_FindFullColumnBand:
                cmp.w   d2,d0
                bmi.s   SKTileDraw_UploadFullBandColumn
                add.w   (a4)+,d2
                addq.w  #4,a5
                bra.s   SKTileDraw_FindFullColumnBand
; ---------------------------------------------------------------------------

SKTileDraw_UploadFullBandColumn:
                move.w  (a5),d1
                moveq   #$10,d6
                movem.l d0/d2-d3/a0/a4-a5,-(sp)
                jsr     Setup_TileColumnDraw(pc)
                jsr     VInt_DrawLevel(pc)
                movem.l (sp)+,d0/d2-d3/a0/a4-a5
                addi.w  #$10,d0
                dbf     d3,SKTileDraw_FindFullColumnBand
                rts
; ---------------------------------------------------------------------------

Refresh_PlaneFull_Competition:
                movem.l d0-d2/d6/a0,-(sp)
                jsr     Setup_TileRowDraw_Competition(pc)
                jsr     VInt_DrawLevel_Competition(pc)
                movem.l (sp)+,d0-d2/d6/a0
                addi.w  #$10,d0
                dbf     d2,Refresh_PlaneFull_Competition
                rts
; ---------------------------------------------------------------------------

Refresh_PlaneFullDirect:
                moveq   #$20,d6
                bra.s   Refresh_PlaneDirect2
; ---------------------------------------------------------------------------

Refresh_PlaneScreenDirect:
                moveq   #$15,d6

Refresh_PlaneDirect2:
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Camera_X_pos_copy).w,d1

Refresh_PlaneDirect:
                move    #$2700,sr
                moveq   #$F-1,d2

; Upload 15 rows using the block width already in d6
SKTileDraw_UploadDirectRows:
                movem.l d0-d2/d6/a0,-(sp)               ; Redraws the entire plane in one go during 68k execution
                jsr     Setup_TileRowDraw(pc)
                jsr     VInt_DrawLevel(pc)
                movem.l (sp)+,d0-d2/d6/a0
                addi.w  #$10,d0
                dbf     d2,SKTileDraw_UploadDirectRows
                move    #$2300,sr
                rts

; =============== S U B R O U T I N E =======================================

DrawTilesAsYouMove:
                lea     (Camera_X_pos_copy).w,a6
                lea     (Camera_X_pos_rounded).w,a5
                move.w  (Camera_Y_pos_copy).w,d1
                moveq   #$F,d6
                jsr     Draw_TileColumn(pc)
                lea     (Camera_Y_pos_copy).w,a6
                lea     (Camera_Y_pos_rounded).w,a5
                move.w  (Camera_X_pos_copy).w,d1
                moveq   #$15,d6
                jmp     Draw_TileRow(pc)
; End of function DrawTilesAsYouMove

; =============== S U B R O U T I N E =======================================

DrawBGAsYouMove:
                lea     (Camera_X_pos_BG_copy).w,a6
                lea     (Camera_X_pos_BG_rounded).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d1
                moveq   #$F,d6
                jsr     Draw_TileColumn(pc)
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                move.w  (Camera_X_pos_BG_copy).w,d1
                moveq   #$15,d6
                jmp     Draw_TileRow(pc)
; End of function DrawBGAsYouMove

; ---------------------------------------------------------------------------

SKTileDraw_UpdateFgDeformed:
                movem.l d5/a4-a5,-(sp)
                lea     (Camera_Y_pos_copy).w,a6
                jsr     Get_DeformDrawPosVert(pc)
                lea     (Camera_Y_pos_rounded).w,a5
                jsr     Draw_TileRow2(pc)
                movem.l (sp)+,d5/a4/a6
                move.w  (Camera_Y_pos_rounded).w,d6
                bra.s   Draw_BGNoVert

; =============== S U B R O U T I N E =======================================

Draw_BG:
                movem.l d5/a4-a5,-(sp)
                lea     (Camera_Y_pos_BG_copy).w,a6
                jsr     Get_DeformDrawPosVert(pc)
                lea     (Camera_Y_pos_BG_rounded).w,a5
                jsr     Draw_TileRow2(pc)
                movem.l (sp)+,d5/a4/a6
                move.w  (Camera_Y_pos_BG_rounded).w,d6
                tst.w   (Camera_Y_pos_BG_copy).w
                bpl.s   Draw_BGNoVert
                move.w  (Camera_Y_pos_BG_copy).w,d6
                andi.w  #$FFF0,d6

Draw_BGNoVert:
                move.w  d6,d1

SKTileDraw_SkipOffscreenColumnBands:
                sub.w   (a4)+,d6
                bmi.s   SKTileDraw_CalcFirstVisibleColumnHeight
                move.w  (a6)+,d0
                andi.w  #$FFF0,d0
                move.w  d0,(a6)+
                subq.w  #1,d5
                bra.s   SKTileDraw_SkipOffscreenColumnBands
; ---------------------------------------------------------------------------

SKTileDraw_CalcFirstVisibleColumnHeight:
                neg.w   d6
                lsr.w   #4,d6
                moveq   #$F,d4
                sub.w   d6,d4
                bcc.s   SKTileDraw_DrawVisibleBandColumn
                moveq   #0,d4
                moveq   #$F,d6

SKTileDraw_DrawVisibleBandColumn:
                movem.w d1/d4-d6,-(sp)
                movem.l a4/a6,-(sp)
                lea     2(a6),a5
                jsr     Draw_TileColumn(pc)
                movem.l (sp)+,a4/a6
                movem.w (sp)+,d1/d4-d6
                addq.w  #4,a6
                tst.w   d4
                beq.s   SKTileDraw_SyncHiddenBandX
                lsl.w   #4,d6
                add.w   d6,d1
                subq.w  #1,d5
                move.w  (a4)+,d6
                lsr.w   #4,d6
                move.w  d4,d0
                sub.w   d6,d4
                bpl.s   SKTileDraw_DrawVisibleBandColumn
                move.w  d0,d6
                moveq   #0,d4
                bra.s   SKTileDraw_DrawVisibleBandColumn
; ---------------------------------------------------------------------------

SKTileDraw_SyncHiddenBandX:
                subq.w  #1,d5
                beq.s   SKTileDraw_BandedColumnsReturn
                move.w  (a6)+,d0
                andi.w  #$FFF0,d0
                move.w  d0,(a6)+
                bra.s   SKTileDraw_SyncHiddenBandX
; ---------------------------------------------------------------------------

SKTileDraw_BandedColumnsReturn:
                rts
; End of function Draw_BG
