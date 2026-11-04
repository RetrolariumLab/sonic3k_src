; Owner: rendering/s3
; Responsibility: Tile column and row drawing, chunk lookup and competition row setup
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Draw_TileColumn:
                move.w  (a6),d0
                andi.w  #$FFF0,d0
                move.w  (a5),d2
                move.w  d0,(a5)
                move.w  d2,d3
                sub.w   d0,d2
                beq.w   S3TileDraw_ColumnUpdateReturn
                tst.b   d2
                bpl.s   S3TileDraw_PickColumnUpdateCount
                neg.w   d2
                move.w  d3,d0
                addi.w  #$150,d0

S3TileDraw_PickColumnUpdateCount:
                andi.w  #$30,d2
                cmpi.w  #$10,d2
                sne     (Plane_double_update_flag).w
                movem.w d1/d6,-(sp)
                bsr.s   Setup_TileColumnDraw
                movem.w (sp)+,d1/d6
                tst.b   (Plane_double_update_flag).w
                beq.w   S3TileDraw_ColumnUpdateReturn
                addi.w  #$10,d0
                bra.s   Setup_TileColumnDraw
; End of function Draw_TileColumn

; =============== S U B R O U T I N E =======================================

Draw_TileColumn2:
                move.w  (a6),d0
                andi.w  #$FFF0,d0
                move.w  (a5),d2
                move.w  d0,(a5)
                move.w  d2,d3
                sub.w   d0,d2
                beq.w   S3TileDraw_ColumnUpdateReturn
                tst.b   d2
                bpl.s   S3TileDraw_PickDeformedColumnCount
                neg.w   d2
                move.w  d3,d0
                addi.w  #$150,d0
                swap    d1

S3TileDraw_PickDeformedColumnCount:
                andi.w  #$30,d2
                cmpi.w  #$10,d2
                sne     (Plane_double_update_flag).w
                movem.w d1/d6,-(sp)
                bsr.s   Setup_TileColumnDraw
                movem.w (sp)+,d1/d6
                tst.b   (Plane_double_update_flag).w
                beq.w   S3TileDraw_ColumnUpdateReturn
                addi.w  #$10,d0
; End of function Draw_TileColumn2

; =============== S U B R O U T I N E =======================================

Setup_TileColumnDraw:
                move.w  d1,d2
                andi.w  #$70,d2
                move.w  d1,d3
                lsl.w   #4,d3
                andi.w  #$F00,d3
                asr.w   #4,d1
                move.w  d1,d4
                asr.w   #1,d1
                and.w   (Layout_row_index_mask).w,d1
                andi.w  #$F,d4
                moveq   #$10,d5
                sub.w   d4,d5
                move.w  d5,d4
                sub.w   d6,d5
                bmi.s   S3TileDraw_SplitColumnAtWrap
                move.w  d0,d5
                asr.w   #2,d5
                andi.w  #$7C,d5
                add.w   d7,d5
                add.w   d3,d5
                move.w  d5,(a0)+
                move.w  d6,d5
                subq.w  #1,d6
                move.w  d6,(a0)+
                bset    #7,-2(a0)
                lea     (a0),a1
                add.w   d5,d5
                add.w   d5,d5
                adda.w  d5,a0
                jsr     Get_LevelChunkColumn(pc)
                bra.s   S3TileDraw_SavePlaneWord
; ---------------------------------------------------------------------------

S3TileDraw_SplitColumnAtWrap:
                neg.w   d5
                move.w  d5,-(sp)
                move.w  d0,d5
                asr.w   #2,d5
                andi.w  #$7C,d5
                add.w   d7,d5
                add.w   d3,d5
                move.w  d5,(a0)+
                move.w  d4,d6
                subq.w  #1,d6
                move.w  d6,(a0)+
                bset    #7,-2(a0)
                lea     (a0),a1
                add.w   d4,d4
                add.w   d4,d4
                adda.w  d4,a0
                jsr     Get_LevelChunkColumn(pc)
                bsr.s   S3TileDraw_SavePlaneWord
                move.w  (sp)+,d6
                move.w  d0,d5
                asr.w   #2,d5
                andi.w  #$7C,d5
                add.w   d7,d5
                move.w  d5,(a0)+
                move.w  d6,d5
                subq.w  #1,d6
                move.w  d6,(a0)+
                bset    #7,-2(a0)
                lea     (a0),a1
                add.w   d5,d5
                add.w   d5,d5
                adda.w  d5,a0

S3TileDraw_SavePlaneWord:
                swap    d7

S3TileDraw_PackColumnBlock:
                move.w  (a5,d2.w),d3
                move.w  d3,d4
                andi.w  #$3FF,d3
                lsl.w   #3,d3
                move.w  (a2,d3.w),d5
                swap    d5
                move.w  4(a2,d3.w),d5
                move.w  6(a2,d3.w),d7
                move.w  2(a2,d3.w),d3
                swap    d3
                move.w  d7,d3
                btst    #$B,d4
                beq.s   S3TileDraw_TryFlipColumnH
                eori.l  #$10001000,d5
                eori.l  #$10001000,d3
                swap    d5
                swap    d3

S3TileDraw_TryFlipColumnH:
                btst    #$A,d4
                beq.s   S3TileDraw_AppendColumnBlock
                eori.l  #$8000800,d5
                eori.l  #$8000800,d3
                exg     d3,d5

S3TileDraw_AppendColumnBlock:
                move.l  d5,(a1)+
                move.l  d3,(a0)+
                addi.w  #$10,d2
                andi.w  #$70,d2
                bne.s   S3TileDraw_NextColumnBlockOrEnd
                addq.w  #4,d1
                and.w   (Layout_row_index_mask).w,d1
                bsr.s   Get_LevelChunkColumn

S3TileDraw_NextColumnBlockOrEnd:
                dbf     d6,S3TileDraw_PackColumnBlock
                swap    d7
                clr.w   (a0)

S3TileDraw_ColumnUpdateReturn:
                rts
; End of function Setup_TileColumnDraw

; =============== S U B R O U T I N E =======================================

Get_LevelChunkColumn:
                movea.w (a3,d1.w),a4
                move.w  d0,d3
                asr.w   #7,d3
                adda.w  d3,a4
                moveq   #-1,d3
                clr.w   d3
                move.b  (a4),d3
                lsl.w   #7,d3
                move.w  d0,d4
                asr.w   #3,d4
                andi.w  #$E,d4
                add.w   d4,d3
                movea.l d3,a5
                rts
; End of function Get_LevelChunkColumn

; =============== S U B R O U T I N E =======================================

Draw_TileRow:
                move.w  (a6),d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  (a5),d2
                move.w  d0,(a5)
                move.w  d2,d3
                sub.w   d0,d2
                beq.w   S3TileDraw_RowUpdateReturn
                tst.b   d2
                bpl.s   S3TileDraw_PickRowUpdateCount
                neg.w   d2
                move.w  d3,d0
                addi.w  #$F0,d0
                and.w   (Camera_Y_pos_mask).w,d0

S3TileDraw_PickRowUpdateCount:
                andi.w  #$30,d2
                cmpi.w  #$10,d2
                sne.b   (Plane_double_update_flag).w
                movem.w d1/d6,-(sp)
                bsr.s   Setup_TileRowDraw
                movem.w (sp)+,d1/d6
                tst.b   (Plane_double_update_flag).w
                beq.w   S3TileDraw_RowUpdateReturn
                addi.w  #$10,d0
                and.w   (Camera_Y_pos_mask).w,d0
                bra.s   Setup_TileRowDraw
; End of function Draw_TileRow

; =============== S U B R O U T I N E =======================================

Draw_TileRow2:
                move.w  (a6),d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  (a5),d2
                move.w  d0,(a5)
                move.w  d2,d3
                sub.w   d0,d2
                beq.w   S3TileDraw_RowUpdateReturn
                tst.b   d2
                bpl.s   S3TileDraw_PickDeformedRowCount
                neg.w   d2
                move.w  d3,d0
                addi.w  #$F0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                swap    d1

S3TileDraw_PickDeformedRowCount:
                andi.w  #$30,d2
                cmpi.w  #$10,d2
                sne     (Plane_double_update_flag).w
                movem.w d1/d6,-(sp)
                bsr.s   Setup_TileRowDraw
                movem.w (sp)+,d1/d6
                tst.b   (Plane_double_update_flag).w
                beq.w   S3TileDraw_RowUpdateReturn
                addi.w  #$10,d0
                and.w   (Camera_Y_pos_mask).w,d0
; End of function Draw_TileRow2

; =============== S U B R O U T I N E =======================================

Setup_TileRowDraw:
                asr.w   #4,d1
                move.w  d1,d2
                move.w  d1,d4
                asr.w   #3,d1
                add.w   d2,d2
                move.w  d2,d3
                andi.w  #$E,d2
                add.w   d3,d3
                andi.w  #$7C,d3
                andi.w  #$1F,d4
                moveq   #$20,d5
                sub.w   d4,d5
                move.w  d5,d4
                sub.w   d6,d5
                bmi.s   S3TileDraw_SplitRowAtWrap
                move.w  d0,d5
                andi.w  #$F0,d5                         ; If the length of the write can fit without wrapping the nametable
                lsl.w   #4,d5
                add.w   d7,d5
                add.w   d3,d5
                move.w  d5,(a0)+
                move.w  d6,d5
                subq.w  #1,d6
                move.w  d6,(a0)+
                lea     (a0),a1
                add.w   d5,d5
                add.w   d5,d5
                adda.w  d5,a0
                jsr     Get_LevelAddrChunkRow(pc)
                bra.s   S3TileDraw_PackRowBlock
; ---------------------------------------------------------------------------

S3TileDraw_SplitRowAtWrap:
                neg.w   d5                              ; If the length of the write wraps over the length of the nametable
                move.w  d5,-(sp)
                move.w  d0,d5
                andi.w  #$F0,d5
                lsl.w   #4,d5
                add.w   d7,d5
                add.w   d3,d5
                move.w  d5,(a0)+
                move.w  d4,d6
                subq.w  #1,d6
                move.w  d6,(a0)+
                lea     (a0),a1
                add.w   d4,d4
                add.w   d4,d4
                adda.w  d4,a0
                bsr.s   Get_LevelAddrChunkRow
                bsr.s   S3TileDraw_PackRowBlock
                move.w  (sp)+,d6                        ; Must place one more write command to account for rollover
                move.w  d0,d5
                andi.w  #$F0,d5
                lsl.w   #4,d5
                add.w   d7,d5
                move.w  d5,(a0)+
                move.w  d6,d5
                subq.w  #1,d6
                move.w  d6,(a0)+
                lea     (a0),a1
                add.w   d5,d5
                add.w   d5,d5
                adda.w  d5,a0

S3TileDraw_PackRowBlock:
                move.w  (a5,d2.w),d3
                move.w  d3,d4
                andi.w  #$3FF,d3
                lsl.w   #3,d3
                move.l  (a2,d3.w),d5
                move.l  4(a2,d3.w),d3
                btst    #$B,d4
                beq.s   S3TileDraw_TryFlipRowH
                eori.l  #$10001000,d5
                eori.l  #$10001000,d3
                exg     d3,d5

S3TileDraw_TryFlipRowH:
                btst    #$A,d4
                beq.s   S3TileDraw_AppendRowBlock
                eori.l  #$8000800,d5
                eori.l  #$8000800,d3
                swap    d5
                swap    d3

S3TileDraw_AppendRowBlock:
                move.l  d5,(a1)+
                move.l  d3,(a0)+
                addq.w  #2,d2
                andi.w  #$E,d2
                bne.s   S3TileDraw_NextRowBlockOrEnd
                addq.w  #1,d1
                bsr.s   Get_ChunkRow

S3TileDraw_NextRowBlockOrEnd:
                dbf     d6,S3TileDraw_PackRowBlock
                clr.w   (a0)

S3TileDraw_RowUpdateReturn:
                rts
; End of function Setup_TileRowDraw

; =============== S U B R O U T I N E =======================================

Get_LevelAddrChunkRow:
                move.w  d0,d3
                asr.w   #5,d3
                and.w   (Layout_row_index_mask).w,d3
                movea.w (a3,d3.w),a4

Get_ChunkRow:
                moveq   #-1,d3
                clr.w   d3
                move.b  (a4,d1.w),d3
                lsl.w   #7,d3
                move.w  d0,d4
                andi.w  #$70,d4
                add.w   d4,d3
                movea.l d3,a5
                rts
; End of function Get_LevelAddrChunkRow

; =============== S U B R O U T I N E =======================================

Setup_TileRowDraw_Competition:
                asr.w   #3,d1
                move.w  d1,d2
                asr.w   #4,d1
                andi.w  #$E,d2
                cmpi.w  #$100,(_unkEEB0).w
                beq.s   S3TileDraw_PickCompRowPitch32
                moveq   #4,d3
                move.w  #$1F80,d4
                bra.s   S3TileDraw_BuildCompRowHeader
; ---------------------------------------------------------------------------

S3TileDraw_PickCompRowPitch32:
                moveq   #5,d3
                move.w  #$1F00,d4

S3TileDraw_BuildCompRowHeader:
                move.w  d0,d5
                lsl.w   d3,d5
                and.w   d4,d5
                add.w   d7,d5
                move.w  d5,(a0)+
                move.w  d6,d5
                subq.w  #1,d6
                move.w  d6,(a0)+
                lea     (a0),a1
                add.w   d5,d5
                add.w   d5,d5
                adda.w  d5,a0
                jsr     Get_LevelAddrChunkRow(pc)
                bra.w   S3TileDraw_PackRowBlock
; End of function Setup_TileRowDraw_Competition
