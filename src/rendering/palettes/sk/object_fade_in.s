; Owner: rendering/palettes/sk
; Responsibility: Selected object palette fade from black and per-channel increments
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_FadeSelectedFromBlack:
                move.l  #SKPalObj_TickFadeInDelay,(a0)
                move.b  #7,$39(a0)
                st      (Palette_rotation_disable).w

SKPalObj_TickFadeInDelay:
                subq.w  #1,$2E(a0)
                bpl.s   SKPalObj_FadeInReturn
                move.w  $3A(a0),$2E(a0)
                movea.w $30(a0),a1
                movea.w $32(a0),a2
                move.w  $3C(a0),d0
                moveq   #$E,d1
                moveq   #-$20,d2

SKPalObj_RunFadeInPass:
                bsr.w   IncColor_Obj
                dbf     d0,SKPalObj_RunFadeInPass
                subq.b  #1,$39(a0)
                bpl.s   SKPalObj_FadeInReturn
                clr.b   (Palette_rotation_disable).w
                jsr     (Go_Delete_Sprite).l

SKPalObj_FadeInReturn:
                rts

; =============== S U B R O U T I N E =======================================

IncColor_Obj:
                move.b  (a1),d3
                and.b   d1,d3
                move.b  (a2)+,d4
                and.b   d1,d4
                cmp.b   d4,d3
                bhs.s   SKPalObj_FadeInStoreHigh
                addq.b  #2,d3

SKPalObj_FadeInStoreHigh:
                move.b  d3,(a1)+
                move.b  (a1),d3
                move.b  d3,d4
                and.b   d2,d3
                move.b  (a2)+,d5
                move.b  d5,d6
                and.b   d2,d5
                cmp.b   d5,d3
                bhs.s   SKPalObj_FadeInTryLow
                addi.b  #$20,d3

SKPalObj_FadeInTryLow:
                and.b   d1,d4
                and.b   d1,d6
                cmp.b   d6,d4
                bhs.s   SKPalObj_FadeInStoreLowByte
                addq.b  #2,d4

SKPalObj_FadeInStoreLowByte:
                or.b    d3,d4
                move.b  d4,(a1)+
                rts
; End of function IncColor_Obj
