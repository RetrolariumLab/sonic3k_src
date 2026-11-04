; Owner: rendering/palettes/sk
; Responsibility: Selected object palette fade to black and per-channel decrements
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FadeSelectedToBlack:
                move.l  #SKPalObj_TickFadeOutDelay,(a0)
                move.b  #7,$39(a0)
                st      (Palette_rotation_disable).w

SKPalObj_TickFadeOutDelay:
                subq.w  #1,$2E(a0)
                bpl.s   SKPalObj_FadeOutReturn
                move.w  $3A(a0),$2E(a0)
                movea.w $30(a0),a1
                move.w  $3C(a0),d0
                moveq   #$E,d1
                moveq   #-$20,d2

SKPalObj_RunFadeOutPass:
                bsr.w   DecColor_Obj
                dbf     d0,SKPalObj_RunFadeOutPass
                subq.b  #1,$39(a0)
                bpl.s   SKPalObj_FadeOutReturn
                clr.b   (Palette_rotation_disable).w
                jsr     (Go_Delete_Sprite).l

SKPalObj_FadeOutReturn:
                rts

; =============== S U B R O U T I N E =======================================

DecColor_Obj:
                move.b  (a1),d3
                and.b   d1,d3
                beq.s   SKPalObj_FadeOutStoreHigh
                subq.b  #2,d3

SKPalObj_FadeOutStoreHigh:
                move.b  d3,(a1)+
                move.b  (a1),d3
                move.b  d3,d4
                and.b   d2,d3
                beq.s   SKPalObj_FadeOutTryLow
                subi.b  #$20,d3

SKPalObj_FadeOutTryLow:
                and.b   d1,d4
                beq.s   SKPalObj_FadeOutStoreLowByte
                subq.b  #2,d4

SKPalObj_FadeOutStoreLowByte:
                or.b    d3,d4
                move.b  d4,(a1)+
                rts
; End of function DecColor_Obj
