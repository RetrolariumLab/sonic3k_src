; Owner: rendering/palettes/s3
; Responsibility: Selected object palette fade-in and per-channel color increments
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FadeSelectedFromBlack:
                move.l  #loc_53C4E,(a0)
                move.b  #7,$39(a0)
                move.b  #3,$2F(a0)

loc_53C4E:
                subq.b  #1,$2E(a0)
                bmi.s   loc_53C56
                rts
; ---------------------------------------------------------------------------

loc_53C56:
                subq.b  #1,$39(a0)
                bmi.w   loc_531C2
                move.b  $2F(a0),$2E(a0)
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #$E,d4
                moveq   #-$20,d5
                moveq   #$20-1,d6

loc_53C72:
                bsr.w   IncColor_Obj
                dbf     d6,loc_53C72
                rts

; =============== S U B R O U T I N E =======================================

IncColor_Obj:
                move.b  (a1),d0
                and.b   d4,d0
                move.b  (a2)+,d1
                and.b   d4,d1
                cmp.b   d1,d0
                bhs.s   loc_53C8A
                addq.b  #2,d0

loc_53C8A:
                move.b  d0,(a1)+
                move.b  (a1),d0
                move.b  d0,d1
                and.b   d5,d0
                move.b  (a2)+,d2
                move.b  d2,d3
                and.b   d5,d2
                cmp.b   d2,d0
                bhs.s   loc_53CA0
                addi.b  #$20,d0

loc_53CA0:
                and.b   d4,d1
                and.b   d4,d3
                cmp.b   d3,d1
                bhs.s   loc_53CAA
                addq.b  #2,d1

loc_53CAA:
                or.b    d0,d1
                move.b  d1,(a1)+
                rts
; End of function IncColor_Obj
