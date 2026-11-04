; Owner: rendering/s3
; Responsibility: Foreground and background deformation array construction, application and vertical-scroll output
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

S3Deform_FillPlainScroll:
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                dbf     d1,S3Deform_FillPlainScroll
                rts
; End of function PlainDeformation

; =============== S U B R O U T I N E =======================================

MakeFGDeformArray:
                move.w  d1,d0
                lsr.w   #1,d0
                bcc.s   S3Deform_WriteFgWordSecond

S3Deform_WriteFgWordFirst:
                move.w  (a6)+,d5
                add.w   d6,d5
                move.w  d5,(a1)+

S3Deform_WriteFgWordSecond:
                move.w  (a6)+,d5
                add.w   d6,d5
                move.w  d5,(a1)+
                dbf     d0,S3Deform_WriteFgWordFirst
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
                bpl.s   S3Deform_SkipBgSpansToY
                andi.w  #$7FFF,d2

S3Deform_SkipBgSpansToY:
                sub.w   d2,d0
                bmi.s   S3Deform_SeekDynamicBgSpan
                addq.w  #2,a5
                tst.b   d4
                beq.s   ApplyDeformation2
                subq.w  #2,a5
                add.w   d2,d2
                adda.w  d2,a5
                bra.s   ApplyDeformation2
; ---------------------------------------------------------------------------

S3Deform_SeekDynamicBgSpan:
                tst.b   d4
                beq.s   S3Deform_CapFirstBgSpan
                add.w   d0,d2
                add.w   d2,d2
                adda.w  d2,a5

S3Deform_CapFirstBgSpan:
                neg.w   d0
                move.w  d1,d2
                sub.w   d0,d2
                bcc.s   S3Deform_PackFgBaseForBgSpan
                move.w  d1,d0
                addq.w  #1,d0

S3Deform_PackFgBaseForBgSpan:
                neg.w   d3
                swap    d3

S3Deform_InitBgSpanLoopCount:
                subq.w  #1,d0

S3Deform_PickBgSpanWriter:
                tst.b   d4
                beq.s   S3Deform_ReadRepeatedBgScroll
                lsr.w   #1,d0
                bcc.s   S3Deform_WriteDynamicBgSecond

S3Deform_WriteDynamicBgFirst:
                move.w  (a5)+,d3
                neg.w   d3
                move.l  d3,(a1)+

S3Deform_WriteDynamicBgSecond:
                move.w  (a5)+,d3
                neg.w   d3
                move.l  d3,(a1)+
                dbf     d0,S3Deform_WriteDynamicBgFirst
                bra.s   S3Deform_TryReadNextBgSpan
; ---------------------------------------------------------------------------

S3Deform_ReadRepeatedBgScroll:
                move.w  (a5)+,d3
                neg.w   d3
                lsr.w   #1,d0
                bcc.s   S3Deform_WriteRepeatedBgSecond

S3Deform_WriteRepeatedBgFirst:
                move.l  d3,(a1)+

S3Deform_WriteRepeatedBgSecond:
                move.l  d3,(a1)+
                dbf     d0,S3Deform_WriteRepeatedBgFirst

S3Deform_TryReadNextBgSpan:
                tst.w   d2
                bmi.s   S3Deform_BgSpanReturn
                move.w  (a4)+,d0
                smi     d4
                bpl.s   S3Deform_CapNextBgSpan
                andi.w  #$7FFF,d0

S3Deform_CapNextBgSpan:
                move.w  d2,d3
                sub.w   d0,d2
                bpl.s   S3Deform_InitBgSpanLoopCount
                move.w  d3,d0
                bra.s   S3Deform_PickBgSpanWriter
; ---------------------------------------------------------------------------

S3Deform_BgSpanReturn:
                rts
; End of function ApplyDeformation

; =============== S U B R O U T I N E =======================================

ApplyFGandBGDeformation:
                swap    d7
                swap    d3

; The sign bit selects a dynamic span. Clear it to obtain the row count
S3Deform_DecodeCombinedBgSpan:
                move.w  (a4)+,d3
                smi     d7
                bpl.s   S3Deform_SkipCombinedSpansToY
                andi.w  #$7FFF,d3

S3Deform_SkipCombinedSpansToY:
                sub.w   d3,d0
                bmi.s   S3Deform_SeekDynamicCombinedSpan
                addq.w  #2,a5
                tst.b   d7
                beq.s   S3Deform_DecodeCombinedBgSpan
                subq.w  #2,a5
                add.w   d3,d3
                adda.w  d3,a5
                bra.s   S3Deform_DecodeCombinedBgSpan
; ---------------------------------------------------------------------------

S3Deform_SeekDynamicCombinedSpan:
                tst.b   d7
                beq.s   S3Deform_CapFirstCombinedSpan
                add.w   d0,d3
                add.w   d3,d3
                adda.w  d3,a5

; Restore the saved low word of d3 before calculating the remaining rows
S3Deform_CapFirstCombinedSpan:
                swap    d3
                neg.w   d0
                move.w  d1,d4
                sub.w   d0,d4
                bcc.s   S3Deform_InitCombinedLoopCount
                move.w  d1,d0
                addq.w  #1,d0

S3Deform_InitCombinedLoopCount:
                subq.w  #1,d0

S3Deform_PickCombinedSpanWriter:
                tst.b   d7
                beq.s   S3Deform_ReadCombinedBgBase
                lsr.w   #1,d0
                bcc.s   S3Deform_WriteDynamicCombinedSecond

S3Deform_WriteDynamicCombinedFirst:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a5)+,d6
                neg.w   d6
                add.w   (a6)+,d6
                move.l  d6,(a1)+

S3Deform_WriteDynamicCombinedSecond:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a5)+,d6
                neg.w   d6
                add.w   (a6)+,d6
                move.l  d6,(a1)+
                dbf     d0,S3Deform_WriteDynamicCombinedFirst
                bra.s   S3Deform_TryReadNextCombinedSpan
; ---------------------------------------------------------------------------

S3Deform_ReadCombinedBgBase:
                move.w  (a5)+,d5
                neg.w   d5
                lsr.w   #1,d0
                bcc.s   S3Deform_WriteConstantCombinedSecond

S3Deform_WriteConstantCombinedFirst:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a6)+,d6
                add.w   d5,d6
                move.l  d6,(a1)+

S3Deform_WriteConstantCombinedSecond:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a6)+,d6
                add.w   d5,d6
                move.l  d6,(a1)+
                dbf     d0,S3Deform_WriteConstantCombinedFirst

S3Deform_TryReadNextCombinedSpan:
                tst.w   d4
                bmi.s   S3Deform_RestorePlaneAndReturn
                move.w  (a4)+,d0
                smi     d7
                bpl.s   S3Deform_CapNextCombinedSpan
                andi.w  #$7FFF,d0

S3Deform_CapNextCombinedSpan:
                move.w  d4,d5
                sub.w   d0,d4
                bpl.s   S3Deform_InitCombinedLoopCount
                move.w  d5,d0
                bra.s   S3Deform_PickCombinedSpanWriter
; ---------------------------------------------------------------------------

S3Deform_RestorePlaneAndReturn:
                swap    d7
                rts

; =============== S U B R O U T I N E =======================================

Apply_FGVScroll:
                lea     (Vscroll_buffer).w,a1
                move.w  (Camera_Y_pos_BG_copy).w,d1
                move.w  (Camera_X_pos_copy).w,d0
                move.w  d0,d2
                andi.w  #$F,d2
                beq.s   S3Deform_CameraXToBlockColumn
                addi.w  #$10,d0

S3Deform_CameraXToBlockColumn:
                lsr.w   #4,d0

S3Deform_FindVScrollSpan:
                addq.w  #2,a5
                move.w  (a4)+,d2
                lsr.w   #4,d2
                sub.w   d2,d0
                bpl.s   S3Deform_FindVScrollSpan
                neg.w   d0
                moveq   #$13,d2
                sub.w   d0,d2
                bcc.s   S3Deform_InitVScrollLoopCount
                moveq   #$14,d0

S3Deform_InitVScrollLoopCount:
                subq.w  #1,d0

S3Deform_ReadFgVScroll:
                move.w  (a5)+,d3

S3Deform_WriteVScrollPair:
                move.w  d3,(a1)+
                move.w  d1,(a1)+
                dbf     d0,S3Deform_WriteVScrollPair
                tst.w   d2
                bmi.s   S3Deform_VScrollReturn
                move.w  (a4)+,d0
                lsr.w   #4,d0
                move.w  d2,d3
                sub.w   d0,d2
                bpl.s   S3Deform_InitVScrollLoopCount
                move.w  d3,d0
                bra.s   S3Deform_ReadFgVScroll
; ---------------------------------------------------------------------------

S3Deform_VScrollReturn:
                rts
; End of function Apply_FGVScroll
