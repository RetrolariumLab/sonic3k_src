; Owner: rendering/palettes/s3
; Responsibility: Selected object palette fade-in and per-channel color increments
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FadeSelectedFromBlack:
                move.l  #S3PalObj_TickFadeInDelay,(a0)
                move.b  #7,$39(a0)
                move.b  #3,$2F(a0)

S3PalObj_TickFadeInDelay:
                subq.b  #1,$2E(a0)
                bmi.s   S3PalObj_TryNextFadeInPass
                rts
; ---------------------------------------------------------------------------

S3PalObj_TryNextFadeInPass:
                subq.b  #1,$39(a0)
                bmi.w   loc_531C2
                move.b  $2F(a0),$2E(a0)
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #$E,d4
                moveq   #-$20,d5
                moveq   #$20-1,d6

S3PalObj_FadeInLines2And3:
                bsr.w   IncColor_Obj
                dbf     d6,S3PalObj_FadeInLines2And3
                rts

; =============== S U B R O U T I N E =======================================

IncColor_Obj:
                move.b  (a1),d0
                and.b   d4,d0
                move.b  (a2)+,d1
                and.b   d4,d1
                cmp.b   d1,d0
                bhs.s   S3PalObj_FadeInStoreHigh
                addq.b  #2,d0

S3PalObj_FadeInStoreHigh:
                move.b  d0,(a1)+
                move.b  (a1),d0
                move.b  d0,d1
                and.b   d5,d0
                move.b  (a2)+,d2
                move.b  d2,d3
                and.b   d5,d2
                cmp.b   d2,d0
                bhs.s   S3PalObj_FadeInTryLow
                addi.b  #$20,d0

S3PalObj_FadeInTryLow:
                and.b   d4,d1
                and.b   d4,d3
                cmp.b   d3,d1
                bhs.s   S3PalObj_FadeInStoreLowByte
                addq.b  #2,d1

S3PalObj_FadeInStoreLowByte:
                or.b    d0,d1
                move.b  d1,(a1)+
                rts
; End of function IncColor_Obj
