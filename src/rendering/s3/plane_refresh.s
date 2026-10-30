; Owner: rendering/s3
; Responsibility: Full and partial plane refresh, direct scroll modes and drawing during camera motion
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

loc_39B82:
                cmp.w   d2,d0
                bmi.s   loc_39B8C
                add.w   (a4)+,d2
                addq.w  #4,a5
                bra.s   loc_39B82
; ---------------------------------------------------------------------------

loc_39B8C:
                move.w  (a5),d1
                moveq   #$20,d6
                movem.l d0/d2-d3/a0/a4-a5,-(sp)
                jsr     Setup_TileRowDraw(pc)
                jsr     VInt_DrawLevel(pc)
                movem.l (sp)+,d0/d2-d3/a0/a4-a5
                addi.w  #$10,d0
                dbf     d3,loc_39B82
                rts
; End of function Refresh_PlaneTileDeform

; ---------------------------------------------------------------------------

Refresh_PlaneDirectVScroll:
                move.w  (a4)+,d2
                moveq   #$20-1,d3

loc_39BAE:
                cmp.w   d2,d0
                bmi.s   loc_39BB8
                add.w   (a4)+,d2
                addq.w  #4,a5
                bra.s   loc_39BAE
; ---------------------------------------------------------------------------

loc_39BB8:
                move.w  (a5),d1
                moveq   #$10,d6
                movem.l d0/d2-d3/a0/a4-a5,-(sp)
                jsr     Setup_TileColumnDraw(pc)
                jsr     VInt_DrawLevel(pc)
                movem.l (sp)+,d0/d2-d3/a0/a4-a5
                addi.w  #$10,d0
                dbf     d3,loc_39BAE
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

Refresh_PlaneScreenDirect:
                move    #$2700,sr
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Camera_X_pos_copy).w,d1
                moveq   #$F-1,d2

loc_39BFE:
                movem.l d0-d2/a0,-(sp)                  ; Redraws the entire plane in one go during 68k execution
                moveq   #$15,d6
                jsr     Setup_TileRowDraw(pc)
                jsr     VInt_DrawLevel(pc)
                movem.l (sp)+,d0-d2/a0
                addi.w  #$10,d0
                dbf     d2,loc_39BFE
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
; unused
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

Draw_BGNoVert:
                move.w  d6,d1

loc_39CA2:
                sub.w   (a4)+,d6
                bmi.s   loc_39CB2
                move.w  (a6)+,d0
                andi.w  #$FFF0,d0
                move.w  d0,(a6)+
                subq.w  #1,d5
                bra.s   loc_39CA2
; ---------------------------------------------------------------------------

loc_39CB2:
                neg.w   d6
                lsr.w   #4,d6
                moveq   #$F,d4
                sub.w   d6,d4
                bcc.s   loc_39CC0
                moveq   #0,d4
                moveq   #$F,d6

loc_39CC0:
                movem.w d1/d4-d6,-(sp)
                movem.l a4/a6,-(sp)
                lea     2(a6),a5
                jsr     Draw_TileColumn(pc)
                movem.l (sp)+,a4/a6
                movem.w (sp)+,d1/d4-d6
                addq.w  #4,a6
                tst.w   d4
                beq.s   loc_39CF4
                lsl.w   #4,d6
                add.w   d6,d1
                subq.w  #1,d5
                move.w  (a4)+,d6
                lsr.w   #4,d6
                move.w  d4,d0
                sub.w   d6,d4
                bpl.s   loc_39CC0
                move.w  d0,d6
                moveq   #0,d4
                bra.s   loc_39CC0
; ---------------------------------------------------------------------------

loc_39CF4:
                subq.w  #1,d5
                beq.s   locret_39D02
                move.w  (a6)+,d0
                andi.w  #$FFF0,d0
                move.w  d0,(a6)+
                bra.s   loc_39CF4
; ---------------------------------------------------------------------------

locret_39D02:
                rts
; End of function Draw_BG
