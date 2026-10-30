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

loc_39E66:
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                dbf     d1,loc_39E66
                rts
; End of function PlainDeformation

; =============== S U B R O U T I N E =======================================

MakeFGDeformArray:
                move.w  d1,d0
                lsr.w   #1,d0
                bcc.s   loc_39E80

loc_39E7A:
                move.w  (a6)+,d5
                add.w   d6,d5
                move.w  d5,(a1)+

loc_39E80:
                move.w  (a6)+,d5
                add.w   d6,d5
                move.w  d5,(a1)+
                dbf     d0,loc_39E7A
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
                bpl.s   loc_39EA6
                andi.w  #$7FFF,d2

loc_39EA6:
                sub.w   d2,d0
                bmi.s   loc_39EB8
                addq.w  #2,a5
                tst.b   d4
                beq.s   ApplyDeformation2
                subq.w  #2,a5
                add.w   d2,d2
                adda.w  d2,a5
                bra.s   ApplyDeformation2
; ---------------------------------------------------------------------------

loc_39EB8:
                tst.b   d4
                beq.s   loc_39EC2
                add.w   d0,d2
                add.w   d2,d2
                adda.w  d2,a5

loc_39EC2:
                neg.w   d0
                move.w  d1,d2
                sub.w   d0,d2
                bcc.s   loc_39ECE
                move.w  d1,d0
                addq.w  #1,d0

loc_39ECE:
                neg.w   d3
                swap    d3

loc_39ED2:
                subq.w  #1,d0

loc_39ED4:
                tst.b   d4
                beq.s   loc_39EEE
                lsr.w   #1,d0
                bcc.s   loc_39EE2

loc_39EDC:
                move.w  (a5)+,d3
                neg.w   d3
                move.l  d3,(a1)+

loc_39EE2:
                move.w  (a5)+,d3
                neg.w   d3
                move.l  d3,(a1)+
                dbf     d0,loc_39EDC
                bra.s   loc_39EFE
; ---------------------------------------------------------------------------

loc_39EEE:
                move.w  (a5)+,d3
                neg.w   d3
                lsr.w   #1,d0
                bcc.s   loc_39EF8

loc_39EF6:
                move.l  d3,(a1)+

loc_39EF8:
                move.l  d3,(a1)+
                dbf     d0,loc_39EF6

loc_39EFE:
                tst.w   d2
                bmi.s   locret_39F16
                move.w  (a4)+,d0
                smi     d4
                bpl.s   loc_39F0C
                andi.w  #$7FFF,d0

loc_39F0C:
                move.w  d2,d3
                sub.w   d0,d2
                bpl.s   loc_39ED2
                move.w  d3,d0
                bra.s   loc_39ED4
; ---------------------------------------------------------------------------

locret_39F16:
                rts
; End of function ApplyDeformation

; =============== S U B R O U T I N E =======================================

ApplyFGandBGDeformation:
                swap    d7
                swap    d3

loc_39F1C:
                move.w  (a4)+,d3
                smi     d7
                bpl.s   loc_39F26
                andi.w  #$7FFF,d3

loc_39F26:
                sub.w   d3,d0
                bmi.s   loc_39F38
                addq.w  #2,a5
                tst.b   d7
                beq.s   loc_39F1C
                subq.w  #2,a5
                add.w   d3,d3
                adda.w  d3,a5
                bra.s   loc_39F1C
; ---------------------------------------------------------------------------

loc_39F38:
                tst.b   d7
                beq.s   loc_39F42
                add.w   d0,d3
                add.w   d3,d3
                adda.w  d3,a5

loc_39F42:
                swap    d3
                neg.w   d0
                move.w  d1,d4
                sub.w   d0,d4
                bcc.s   loc_39F50
                move.w  d1,d0
                addq.w  #1,d0

loc_39F50:
                subq.w  #1,d0

loc_39F52:
                tst.b   d7
                beq.s   loc_39F78
                lsr.w   #1,d0
                bcc.s   loc_39F66

loc_39F5A:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a5)+,d6
                neg.w   d6
                add.w   (a6)+,d6
                move.l  d6,(a1)+

loc_39F66:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a5)+,d6
                neg.w   d6
                add.w   (a6)+,d6
                move.l  d6,(a1)+
                dbf     d0,loc_39F5A
                bra.s   loc_39F98
; ---------------------------------------------------------------------------

loc_39F78:
                move.w  (a5)+,d5
                neg.w   d5
                lsr.w   #1,d0
                bcc.s   loc_39F8A

loc_39F80:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a6)+,d6
                add.w   d5,d6
                move.l  d6,(a1)+

loc_39F8A:
                move.w  (a2)+,d6
                swap    d6
                move.w  (a6)+,d6
                add.w   d5,d6
                move.l  d6,(a1)+
                dbf     d0,loc_39F80

loc_39F98:
                tst.w   d4
                bmi.s   loc_39FB0
                move.w  (a4)+,d0
                smi     d7
                bpl.s   loc_39FA6
                andi.w  #$7FFF,d0

loc_39FA6:
                move.w  d4,d5
                sub.w   d0,d4
                bpl.s   loc_39F50
                move.w  d5,d0
                bra.s   loc_39F52
; ---------------------------------------------------------------------------

loc_39FB0:
                swap    d7
                rts

; =============== S U B R O U T I N E =======================================

Apply_FGVScroll:
                lea     (Vscroll_buffer).w,a1
                move.w  (Camera_Y_pos_BG_copy).w,d1
                move.w  (Camera_X_pos_copy).w,d0
                move.w  d0,d2
                andi.w  #$F,d2
                beq.s   loc_39FCC
                addi.w  #$10,d0

loc_39FCC:
                lsr.w   #4,d0

loc_39FCE:
                addq.w  #2,a5
                move.w  (a4)+,d2
                lsr.w   #4,d2
                sub.w   d2,d0
                bpl.s   loc_39FCE
                neg.w   d0
                moveq   #$13,d2
                sub.w   d0,d2
                bcc.s   loc_39FE2
                moveq   #$14,d0

loc_39FE2:
                subq.w  #1,d0

loc_39FE4:
                move.w  (a5)+,d3

loc_39FE6:
                move.w  d3,(a1)+
                move.w  d1,(a1)+
                dbf     d0,loc_39FE6
                tst.w   d2
                bmi.s   locret_3A000
                move.w  (a4)+,d0
                lsr.w   #4,d0
                move.w  d2,d3
                sub.w   d0,d2
                bpl.s   loc_39FE2
                move.w  d3,d0
                bra.s   loc_39FE4
; ---------------------------------------------------------------------------

locret_3A000:
                rts
; End of function Apply_FGVScroll
