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

loc_4F086:
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                dbf     d1,loc_4F086
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

loc_4F0A8:
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                dbf     d1,loc_4F0A8
                rts
; End of function PlainDeformation_Flipped

; =============== S U B R O U T I N E =======================================

MakeFGDeformArray:
                move.w  d1,d0
                lsr.w   #1,d0
                bcc.s   loc_4F0C2

loc_4F0BC:
                move.w  (a6)+,d5
                add.w   d6,d5
                move.w  d5,(a1)+

loc_4F0C2:
                move.w  (a6)+,d5
                add.w   d6,d5
                move.w  d5,(a1)+
                dbf     d0,loc_4F0BC
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
                bpl.s   loc_4F0E8
                andi.w  #$7FFF,d2

loc_4F0E8:
                sub.w   d2,d0
                bmi.s   loc_4F0FA
                addq.w  #2,a5
                tst.b   d4
                beq.s   ApplyDeformation2
                subq.w  #2,a5
                add.w   d2,d2
                adda.w  d2,a5
                bra.s   ApplyDeformation2
; ---------------------------------------------------------------------------

loc_4F0FA:
                tst.b   d4
                beq.s   loc_4F104
                add.w   d0,d2
                add.w   d2,d2
                adda.w  d2,a5

loc_4F104:
                neg.w   d0
                move.w  d1,d2
                sub.w   d0,d2
                bcc.s   loc_4F110
                move.w  d1,d0
                addq.w  #1,d0

loc_4F110:
                neg.w   d3
                swap    d3

loc_4F114:
                subq.w  #1,d0

loc_4F116:
                tst.b   d4
                beq.s   loc_4F130
                lsr.w   #1,d0
                bcc.s   loc_4F124

loc_4F11E:
                move.w  (a5)+,d3
                neg.w   d3
                move.l  d3,(a1)+

loc_4F124:
                move.w  (a5)+,d3
                neg.w   d3
                move.l  d3,(a1)+
                dbf     d0,loc_4F11E
                bra.s   loc_4F140
; ---------------------------------------------------------------------------

loc_4F130:
                move.w  (a5)+,d3
                neg.w   d3
                lsr.w   #1,d0
                bcc.s   loc_4F13A

loc_4F138:
                move.l  d3,(a1)+

loc_4F13A:
                move.l  d3,(a1)+
                dbf     d0,loc_4F138

loc_4F140:
                tst.w   d2
                bmi.s   locret_4F158
                move.w  (a4)+,d0
                smi     d4
                bpl.s   loc_4F14E
                andi.w  #$7FFF,d0

loc_4F14E:
                move.w  d2,d3
                sub.w   d0,d2
                bpl.s   loc_4F114
                move.w  d3,d0
                bra.s   loc_4F116
; ---------------------------------------------------------------------------

locret_4F158:
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
                bpl.s   loc_4F174
                andi.w  #$7FFF,d2

loc_4F174:
                sub.w   d2,d0
                bmi.s   loc_4F186
                addq.w  #2,a5
                tst.b   d4
                beq.s   ApplyFGDeformation2
                subq.w  #2,a5
                add.w   d2,d2
                adda.w  d2,a5
                bra.s   ApplyFGDeformation2
; ---------------------------------------------------------------------------

loc_4F186:
                tst.b   d4
                beq.s   loc_4F190
                add.w   d0,d2
                add.w   d2,d2
                adda.w  d2,a5

loc_4F190:
                neg.w   d0
                move.w  d1,d2
                sub.w   d0,d2
                bcc.s   loc_4F19C
                move.w  d1,d0
                addq.w  #1,d0

loc_4F19C:
                neg.w   d3

loc_4F19E:
                subq.w  #1,d0

loc_4F1A0:
                tst.b   d4
                beq.s   loc_4F1C2
                lsr.w   #1,d0
                bcc.s   loc_4F1B2

loc_4F1A8:
                swap    d3
                move.w  (a5)+,d3
                neg.w   d3
                swap    d3
                move.l  d3,(a1)+

loc_4F1B2:
                swap    d3
                move.w  (a5)+,d3
                neg.w   d3
                swap    d3
                move.l  d3,(a1)+
                dbf     d0,loc_4F1A8
                bra.s   loc_4F1D6
; ---------------------------------------------------------------------------

loc_4F1C2:
                swap    d3
                move.w  (a5)+,d3
                neg.w   d3
                swap    d3
                lsr.w   #1,d0
                bcc.s   loc_4F1D0

loc_4F1CE:
                move.l  d3,(a1)+

loc_4F1D0:
                move.l  d3,(a1)+
                dbf     d0,loc_4F1CE

loc_4F1D6:
                tst.w   d2
                bmi.s   locret_4F1EE
                move.w  (a4)+,d0
                smi     d4
                bpl.s   loc_4F1E4
                andi.w  #$7FFF,d0

loc_4F1E4:
                move.w  d2,d1
                sub.w   d0,d2
                bpl.s   loc_4F19E
                move.w  d1,d0
                bra.s   loc_4F1A0
; ---------------------------------------------------------------------------

locret_4F1EE:
                rts
; End of function ApplyFGDeformation

; ---------------------------------------------------------------------------

ApplyFGandBGDeformation:
                swap    d7
                swap    d3

loc_4F1F4:
                move.w  (a4)+,d3
                smi     d7
                bpl.s   loc_4F1FE
                andi.w  #$7FFF,d3

loc_4F1FE:
                sub.w   d3,d0
                bmi.s   loc_4F210
                addq.w  #2,a5
                tst.b   d7
                beq.s   loc_4F1F4
                subq.w  #2,a5
                add.w   d3,d3
                adda.w  d3,a5
                bra.s   loc_4F1F4
; ---------------------------------------------------------------------------

loc_4F210:
                tst.b   d7
                beq.s   loc_4F21A
                add.w   d0,d3
                add.w   d3,d3
                adda.w  d3,a5

loc_4F21A:
                swap    d3
                neg.w   d0
                move.w  d1,d4
                sub.w   d0,d4
                bcc.s   loc_4F228
                move.w  d1,d0
                addq.w  #1,d0

loc_4F228:
                subq.w  #1,d0

loc_4F22A:
                tst.b   d7
                beq.s   loc_4F250
                lsr.w   #1,d0
                bcc.s   loc_4F23E

loc_4F232:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a5)+,d6
                neg.w   d6
                add.w   (a6)+,d6
                move.l  d6,(a1)+

loc_4F23E:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a5)+,d6
                neg.w   d6
                add.w   (a6)+,d6
                move.l  d6,(a1)+
                dbf     d0,loc_4F232
                bra.s   loc_4F270
; ---------------------------------------------------------------------------

loc_4F250:
                move.w  (a5)+,d5
                neg.w   d5
                lsr.w   #1,d0
                bcc.s   loc_4F262

loc_4F258:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a6)+,d6
                add.w   d5,d6
                move.l  d6,(a1)+

loc_4F262:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a6)+,d6
                add.w   d5,d6
                move.l  d6,(a1)+
                dbf     d0,loc_4F258

loc_4F270:
                tst.w   d4
                bmi.s   loc_4F288
                move.w  (a4)+,d0
                smi     d7
                bpl.s   loc_4F27E
                andi.w  #$7FFF,d0

loc_4F27E:
                move.w  d4,d5
                sub.w   d0,d4
                bpl.s   loc_4F228
                move.w  d5,d0
                bra.s   loc_4F22A
; ---------------------------------------------------------------------------

loc_4F288:
                swap    d7
                rts

; =============== S U B R O U T I N E =======================================

Apply_FGVScroll:
                lea     (Vscroll_buffer).w,a1
                move.w  (Camera_Y_pos_BG_copy).w,d1
                move.w  (Camera_X_pos_copy).w,d0
                move.w  d0,d2
                andi.w  #$F,d2
                beq.s   loc_4F2A4
                addi.w  #$10,d0

loc_4F2A4:
                lsr.w   #4,d0

loc_4F2A6:
                addq.w  #2,a5
                move.w  (a4)+,d2
                lsr.w   #4,d2
                sub.w   d2,d0
                bpl.s   loc_4F2A6
                neg.w   d0
                moveq   #$13,d2
                sub.w   d0,d2
                bcc.s   loc_4F2BA
                moveq   #$14,d0

loc_4F2BA:
                subq.w  #1,d0

loc_4F2BC:
                move.w  (a5)+,d3

loc_4F2BE:
                move.w  d3,(a1)+
                move.w  d1,(a1)+
                dbf     d0,loc_4F2BE
                tst.w   d2
                bmi.s   locret_4F2D8
                move.w  (a4)+,d0
                lsr.w   #4,d0
                move.w  d2,d3
                sub.w   d0,d2
                bpl.s   loc_4F2BA
                move.w  d3,d0
                bra.s   loc_4F2BC
; ---------------------------------------------------------------------------

locret_4F2D8:
                rts
; End of function Apply_FGVScroll
