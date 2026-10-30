; Owner: rendering/sk
; Responsibility: Deformed tile drawing, range selection and directional plane operations
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Get_DeformDrawPosVert:
                move.w  (a4)+,d2
                move.w  (a6),d0
                bsr.s   sub_4EE8E
                addi.w  #$E0,d0
; End of function Get_DeformDrawPosVert

; =============== S U B R O U T I N E =======================================

sub_4EE8E:
                cmp.w   d2,d0
                bmi.s   loc_4EE98
                add.w   (a4)+,d2
                addq.w  #4,a5
                bra.s   sub_4EE8E
; ---------------------------------------------------------------------------

loc_4EE98:
                move.w  (a5),d1
                swap    d1
                rts
; End of function sub_4EE8E

; ---------------------------------------------------------------------------

DrawTilesVDeform:
                movem.l d5/a4-a5,-(sp)
                lea     (Camera_X_pos_copy).w,a6
                jsr     Get_XDeformRange(pc)
                lea     (Camera_X_pos_rounded).w,a5
                jsr     Draw_TileColumn2(pc)
                movem.l (sp)+,d5/a4/a6
                move.w  (Camera_X_pos_rounded).w,d6
                bra.s   loc_4EED8

; ---------------------------------------------------------------------------

DrawTilesVDeform2:
                movem.l d5/a4-a5,-(sp)
                lea     (Camera_X_pos_BG_copy).w,a6
                jsr     Get_XDeformRange(pc)
                lea     (Camera_X_pos_BG_rounded).w,a5
                jsr     Draw_TileColumn2(pc)
                movem.l (sp)+,d5/a4/a6
                move.w  (Camera_X_pos_BG_rounded).w,d6

loc_4EED8:
                move.w  d6,d1

loc_4EEDA:
                sub.w   (a4)+,d6
                bcs.s   loc_4EEEA
                move.w  (a6)+,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(a6)+
                subq.w  #1,d5
                bra.s   loc_4EEDA
; ---------------------------------------------------------------------------

loc_4EEEA:
                neg.w   d6
                lsr.w   #4,d6
                moveq   #$15,d4
                sub.w   d6,d4
                bcc.s   loc_4EEF8
                moveq   #0,d4
                moveq   #$15,d6

loc_4EEF8:
                movem.w d1/d4-d6,-(sp)
                movem.l a4/a6,-(sp)
                lea     2(a6),a5
                jsr     Draw_TileRow(pc)
                movem.l (sp)+,a4/a6
                movem.w (sp)+,d1/d4-d6
                addq.w  #4,a6
                tst.w   d4
                beq.s   loc_4EF2C
                lsl.w   #4,d6
                add.w   d6,d1
                subq.w  #1,d5
                move.w  (a4)+,d6
                lsr.w   #4,d6
                move.w  d4,d0
                sub.w   d6,d4
                bcc.s   loc_4EEF8
                move.w  d0,d6
                moveq   #0,d4
                bra.s   loc_4EEF8
; ---------------------------------------------------------------------------

loc_4EF2C:
                subq.w  #1,d5
                beq.s   locret_4EF3A
                move.w  (a6)+,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(a6)+
                bra.s   loc_4EF2C
; ---------------------------------------------------------------------------

locret_4EF3A:
                rts

; =============== S U B R O U T I N E =======================================

Get_XDeformRange:
                move.w  (a4)+,d2
                move.w  (a6),d0
                bsr.s   sub_4EF46
                addi.w  #$140,d0
; End of function Get_XDeformRange

; =============== S U B R O U T I N E =======================================

sub_4EF46:
                cmp.w   d2,d0
                blo.s   loc_4EF50
                add.w   (a4)+,d2
                addq.w  #4,a5
                bra.s   sub_4EF46
; ---------------------------------------------------------------------------

loc_4EF50:
                move.w  (a5),d1
                swap    d1
                rts
; End of function sub_4EF46

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
                blo.s   loc_4EF84
                cmp.w   d3,d0
                bhi.s   loc_4EF84
                moveq   #$20,d6
                jsr     Setup_TileRowDraw(pc)

loc_4EF84:
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
                blo.s   loc_4EFB0
                cmp.w   d3,d0
                bhi.s   loc_4EFB0
                moveq   #$20,d6
                jsr     Setup_TileRowDraw(pc)

loc_4EFB0:
                addi.w  #$10,(Draw_delayed_position).w
                subq.w  #1,(Draw_delayed_rowcount).w
                rts
; End of function Draw_PlaneVertTopDown

; =============== S U B R O U T I N E =======================================

Draw_PlaneHorzRightToLeft:
                movem.w d1-d2,-(sp)
                bsr.s   sub_4EFCA
                movem.w (sp)+,d1-d2
                bpl.s   sub_4EFCA
                rts
; End of function Draw_PlaneHorzRightToLeft

; =============== S U B R O U T I N E =======================================

sub_4EFCA:
                andi.w  #$FFF0,d2
                move.w  d2,d3
                addi.w  #$1F0,d3
                andi.w  #$FFF0,d3
                move.w  (Draw_delayed_position).w,d0
                cmp.w   d2,d0
                blo.s   loc_4EFEA
                cmp.w   d3,d0
                bhi.s   loc_4EFEA
                moveq   #$10,d6
                jsr     Setup_TileColumnDraw(pc)

loc_4EFEA:
                subi.w  #$10,(Draw_delayed_position).w
                subq.w  #1,(Draw_delayed_rowcount).w
                rts
; End of function sub_4EFCA

; =============== S U B R O U T I N E =======================================

Draw_PlaneHorzLeftToRight:
                movem.w d1-d2,-(sp)
                bsr.s   sub_4F004
                movem.w (sp)+,d1-d2
                bpl.s   sub_4F004
                rts
; End of function Draw_PlaneHorzLeftToRight

; =============== S U B R O U T I N E =======================================

sub_4F004:
                andi.w  #$FFF0,d2
                move.w  d2,d3
                addi.w  #$1F0,d3
                andi.w  #$FFF0,d3
                move.w  (Draw_delayed_position).w,d0
                cmp.w   d2,d0
                blo.s   loc_4F024
                cmp.w   d3,d0
                bhi.s   loc_4F024
                moveq   #$10,d6
                jsr     Setup_TileColumnDraw(pc)

loc_4F024:
                addi.w  #$10,(Draw_delayed_position).w
                subq.w  #1,(Draw_delayed_rowcount).w
                rts
; End of function sub_4F004

; =============== S U B R O U T I N E =======================================

Draw_PlaneVertBottomUpComplex:
                movem.l d1/a4-a5,-(sp)
                bsr.s   sub_4F03E
                movem.l (sp)+,d1/a4-a5
                bpl.s   sub_4F03E
                rts
; End of function Draw_PlaneVertBottomUpComplex

; =============== S U B R O U T I N E =======================================

sub_4F03E:
                and.w   (Camera_Y_pos_mask).w,d1
                move.w  d1,d2
                addi.w  #$F0,d2
                and.w   (Camera_Y_pos_mask).w,d2
                move.w  (Draw_delayed_position).w,d0
                cmp.w   d1,d0
                blo.s   loc_4F066
                cmp.w   d2,d0
                bhi.s   loc_4F066

loc_4F058:
                addq.w  #4,a5
                cmp.w   (a4)+,d0
                bpl.s   loc_4F058
                move.w  (a5),d1
                moveq   #$20,d6
                jsr     Setup_TileRowDraw(pc)

loc_4F066:
                subi.w  #$10,(Draw_delayed_position).w
                subq.w  #1,(Draw_delayed_rowcount).w
                rts
; End of function sub_4F03E
