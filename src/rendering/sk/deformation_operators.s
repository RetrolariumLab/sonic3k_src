; Owner: rendering/sk
; Responsibility: Normal or flipped deformation array construction, foreground or background application and vertical-scroll output
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

PlainDeformation:
                lea     (H_scroll_buffer).w,a1
                move.w  (Camera_X_pos_copy).w,d0
                neg.w   d0
                swap    d0
                move.w  (Camera_X_pos_BG_copy).w,d0
                neg.w   d0
                moveq   #bytesToXcnt(H_scroll_buffer_end-H_scroll_buffer,$10),d1

SKDeform_FillPlainScroll:
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                dbf     d1,SKDeform_FillPlainScroll
                rts
; End of function PlainDeformation

; =============== S U B R O U T I N E =======================================

PlainDeformation_Flipped:
                lea     (H_scroll_buffer).w,a1
                move.w  (Camera_X_pos_BG_copy).w,d0
                neg.w   d0
                swap    d0
                move.w  (Camera_X_pos_copy).w,d0
                neg.w   d0
                moveq   #bytesToXcnt(H_scroll_buffer_end-H_scroll_buffer,$10),d1

SKDeform_FillFlippedPlainScroll:
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                dbf     d1,SKDeform_FillFlippedPlainScroll
                rts
; End of function PlainDeformation_Flipped

; =============== S U B R O U T I N E =======================================

MakeFGDeformArray:
                move.w  d1,d0
                lsr.w   #1,d0
                bcc.s   SKDeform_WriteFgWordSecond

SKDeform_WriteFgWordFirst:
                move.w  (a6)+,d5
                add.w   d6,d5
                move.w  d5,(a1)+

SKDeform_WriteFgWordSecond:
                move.w  (a6)+,d5
                add.w   d6,d5
                move.w  d5,(a1)+
                dbf     d0,SKDeform_WriteFgWordFirst
                rts
; End of function MakeFGDeformArray

; =============== S U B R O U T I N E =======================================

ApplyDeformation:
                move.w  #$E0-1,d1

ApplyDeformation3:
                lea     (H_scroll_buffer).w,a1
                move.w  (Camera_Y_pos_BG_copy).w,d0
                move.w  (Camera_X_pos_copy).w,d3

ApplyDeformation2:
                move.w  (a4)+,d2
                smi     d4
                bpl.s   SKDeform_SkipBgSpansToY
                andi.w  #$7FFF,d2

SKDeform_SkipBgSpansToY:
                sub.w   d2,d0
                bmi.s   SKDeform_SeekDynamicBgSpan
                addq.w  #2,a5
                tst.b   d4
                beq.s   ApplyDeformation2
                subq.w  #2,a5
                add.w   d2,d2
                adda.w  d2,a5
                bra.s   ApplyDeformation2
; ---------------------------------------------------------------------------

SKDeform_SeekDynamicBgSpan:
                tst.b   d4
                beq.s   SKDeform_CapFirstBgSpan
                add.w   d0,d2
                add.w   d2,d2
                adda.w  d2,a5

SKDeform_CapFirstBgSpan:
                neg.w   d0
                move.w  d1,d2
                sub.w   d0,d2
                bcc.s   SKDeform_PackFgBaseForBgSpan
                move.w  d1,d0
                addq.w  #1,d0

SKDeform_PackFgBaseForBgSpan:
                neg.w   d3
                swap    d3

SKDeform_InitBgSpanLoopCount:
                subq.w  #1,d0

SKDeform_PickBgSpanWriter:
                tst.b   d4
                beq.s   SKDeform_ReadRepeatedBgScroll
                lsr.w   #1,d0
                bcc.s   SKDeform_WriteDynamicBgSecond

SKDeform_WriteDynamicBgFirst:
                move.w  (a5)+,d3
                neg.w   d3
                move.l  d3,(a1)+

SKDeform_WriteDynamicBgSecond:
                move.w  (a5)+,d3
                neg.w   d3
                move.l  d3,(a1)+
                dbf     d0,SKDeform_WriteDynamicBgFirst
                bra.s   SKDeform_TryReadNextBgSpan
; ---------------------------------------------------------------------------

SKDeform_ReadRepeatedBgScroll:
                move.w  (a5)+,d3
                neg.w   d3
                lsr.w   #1,d0
                bcc.s   SKDeform_WriteRepeatedBgSecond

SKDeform_WriteRepeatedBgFirst:
                move.l  d3,(a1)+

SKDeform_WriteRepeatedBgSecond:
                move.l  d3,(a1)+
                dbf     d0,SKDeform_WriteRepeatedBgFirst

SKDeform_TryReadNextBgSpan:
                tst.w   d2
                bmi.s   SKDeform_BgSpanReturn
                move.w  (a4)+,d0
                smi     d4
                bpl.s   SKDeform_CapNextBgSpan
                andi.w  #$7FFF,d0

SKDeform_CapNextBgSpan:
                move.w  d2,d3
                sub.w   d0,d2
                bpl.s   SKDeform_InitBgSpanLoopCount
                move.w  d3,d0
                bra.s   SKDeform_PickBgSpanWriter
; ---------------------------------------------------------------------------

SKDeform_BgSpanReturn:
                rts
; End of function ApplyDeformation

; =============== S U B R O U T I N E =======================================

ApplyFGDeformation:
                move.w  #$DF,d1
                lea     (H_scroll_buffer).w,a1
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Camera_X_pos_BG_copy).w,d3

ApplyFGDeformation2:
                move.w  (a4)+,d2
                smi     d4
                bpl.s   SKDeform_SkipFgSpansToY
                andi.w  #$7FFF,d2

SKDeform_SkipFgSpansToY:
                sub.w   d2,d0
                bmi.s   SKDeform_SeekDynamicFgSpan
                addq.w  #2,a5
                tst.b   d4
                beq.s   ApplyFGDeformation2
                subq.w  #2,a5
                add.w   d2,d2
                adda.w  d2,a5
                bra.s   ApplyFGDeformation2
; ---------------------------------------------------------------------------

SKDeform_SeekDynamicFgSpan:
                tst.b   d4
                beq.s   SKDeform_CapFirstFgSpan
                add.w   d0,d2
                add.w   d2,d2
                adda.w  d2,a5

SKDeform_CapFirstFgSpan:
                neg.w   d0
                move.w  d1,d2
                sub.w   d0,d2
                bcc.s   SKDeform_NegateBgBaseForFgSpan
                move.w  d1,d0
                addq.w  #1,d0

SKDeform_NegateBgBaseForFgSpan:
                neg.w   d3

SKDeform_InitFgSpanLoopCount:
                subq.w  #1,d0

SKDeform_PickFgSpanWriter:
                tst.b   d4
                beq.s   SKDeform_ReadRepeatedFgScroll
                lsr.w   #1,d0
                bcc.s   SKDeform_WriteDynamicFgSecond

SKDeform_WriteDynamicFgFirst:
                swap    d3
                move.w  (a5)+,d3
                neg.w   d3
                swap    d3
                move.l  d3,(a1)+

SKDeform_WriteDynamicFgSecond:
                swap    d3
                move.w  (a5)+,d3
                neg.w   d3
                swap    d3
                move.l  d3,(a1)+
                dbf     d0,SKDeform_WriteDynamicFgFirst
                bra.s   SKDeform_TryReadNextFgSpan
; ---------------------------------------------------------------------------

SKDeform_ReadRepeatedFgScroll:
                swap    d3
                move.w  (a5)+,d3
                neg.w   d3
                swap    d3
                lsr.w   #1,d0
                bcc.s   SKDeform_WriteRepeatedFgSecond

SKDeform_WriteRepeatedFgFirst:
                move.l  d3,(a1)+

SKDeform_WriteRepeatedFgSecond:
                move.l  d3,(a1)+
                dbf     d0,SKDeform_WriteRepeatedFgFirst

SKDeform_TryReadNextFgSpan:
                tst.w   d2
                bmi.s   SKDeform_FgSpanReturn
                move.w  (a4)+,d0
                smi     d4
                bpl.s   SKDeform_CapNextFgSpan
                andi.w  #$7FFF,d0

SKDeform_CapNextFgSpan:
                move.w  d2,d1
                sub.w   d0,d2
                bpl.s   SKDeform_InitFgSpanLoopCount
                move.w  d1,d0
                bra.s   SKDeform_PickFgSpanWriter
; ---------------------------------------------------------------------------

SKDeform_FgSpanReturn:
                rts
; End of function ApplyFGDeformation

; ---------------------------------------------------------------------------

ApplyFGandBGDeformation:
                swap    d7
                swap    d3

; The sign bit selects a dynamic span. Clear it to obtain the row count
SKDeform_DecodeCombinedBgSpan:
                move.w  (a4)+,d3
                smi     d7
                bpl.s   SKDeform_SkipCombinedSpansToY
                andi.w  #$7FFF,d3

SKDeform_SkipCombinedSpansToY:
                sub.w   d3,d0
                bmi.s   SKDeform_SeekDynamicCombinedSpan
                addq.w  #2,a5
                tst.b   d7
                beq.s   SKDeform_DecodeCombinedBgSpan
                subq.w  #2,a5
                add.w   d3,d3
                adda.w  d3,a5
                bra.s   SKDeform_DecodeCombinedBgSpan
; ---------------------------------------------------------------------------

SKDeform_SeekDynamicCombinedSpan:
                tst.b   d7
                beq.s   SKDeform_CapFirstCombinedSpan
                add.w   d0,d3
                add.w   d3,d3
                adda.w  d3,a5

; Restore the saved low word of d3 before calculating the remaining rows
SKDeform_CapFirstCombinedSpan:
                swap    d3
                neg.w   d0
                move.w  d1,d4
                sub.w   d0,d4
                bcc.s   SKDeform_InitCombinedLoopCount
                move.w  d1,d0
                addq.w  #1,d0

SKDeform_InitCombinedLoopCount:
                subq.w  #1,d0

SKDeform_PickCombinedSpanWriter:
                tst.b   d7
                beq.s   SKDeform_ReadCombinedBgBase
                lsr.w   #1,d0
                bcc.s   SKDeform_WriteDynamicCombinedSecond

SKDeform_WriteDynamicCombinedFirst:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a5)+,d6
                neg.w   d6
                add.w   (a6)+,d6
                move.l  d6,(a1)+

SKDeform_WriteDynamicCombinedSecond:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a5)+,d6
                neg.w   d6
                add.w   (a6)+,d6
                move.l  d6,(a1)+
                dbf     d0,SKDeform_WriteDynamicCombinedFirst
                bra.s   SKDeform_TryReadNextCombinedSpan
; ---------------------------------------------------------------------------

SKDeform_ReadCombinedBgBase:
                move.w  (a5)+,d5
                neg.w   d5
                lsr.w   #1,d0
                bcc.s   SKDeform_WriteConstantCombinedSecond

SKDeform_WriteConstantCombinedFirst:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a6)+,d6
                add.w   d5,d6
                move.l  d6,(a1)+

SKDeform_WriteConstantCombinedSecond:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a6)+,d6
                add.w   d5,d6
                move.l  d6,(a1)+
                dbf     d0,SKDeform_WriteConstantCombinedFirst

SKDeform_TryReadNextCombinedSpan:
                tst.w   d4
                bmi.s   SKDeform_RestorePlaneAndReturn
                move.w  (a4)+,d0
                smi     d7
                bpl.s   SKDeform_CapNextCombinedSpan
                andi.w  #$7FFF,d0

SKDeform_CapNextCombinedSpan:
                move.w  d4,d5
                sub.w   d0,d4
                bpl.s   SKDeform_InitCombinedLoopCount
                move.w  d5,d0
                bra.s   SKDeform_PickCombinedSpanWriter
; ---------------------------------------------------------------------------

SKDeform_RestorePlaneAndReturn:
                swap    d7
                rts

; =============== S U B R O U T I N E =======================================

Apply_FGVScroll:
                lea     (Vscroll_buffer).w,a1
                move.w  (Camera_Y_pos_BG_copy).w,d1
                move.w  (Camera_X_pos_copy).w,d0
                move.w  d0,d2
                andi.w  #$F,d2
                beq.s   SKDeform_CameraXToBlockColumn
                addi.w  #$10,d0

SKDeform_CameraXToBlockColumn:
                lsr.w   #4,d0

SKDeform_FindVScrollSpan:
                addq.w  #2,a5
                move.w  (a4)+,d2
                lsr.w   #4,d2
                sub.w   d2,d0
                bpl.s   SKDeform_FindVScrollSpan
                neg.w   d0
                moveq   #$13,d2
                sub.w   d0,d2
                bcc.s   SKDeform_InitVScrollLoopCount
                moveq   #$14,d0

SKDeform_InitVScrollLoopCount:
                subq.w  #1,d0

SKDeform_ReadFgVScroll:
                move.w  (a5)+,d3

SKDeform_WriteVScrollPair:
                move.w  d3,(a1)+
                move.w  d1,(a1)+
                dbf     d0,SKDeform_WriteVScrollPair
                tst.w   d2
                bmi.s   SKDeform_VScrollReturn
                move.w  (a4)+,d0
                lsr.w   #4,d0
                move.w  d2,d3
                sub.w   d0,d2
                bpl.s   SKDeform_InitVScrollLoopCount
                move.w  d3,d0
                bra.s   SKDeform_ReadFgVScroll
; ---------------------------------------------------------------------------

SKDeform_VScrollReturn:
                rts
; End of function Apply_FGVScroll
