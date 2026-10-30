; Owner: rendering/palettes/s3; responsibility: fades and loading
; Source provenance and ranges: config/reconstruction/source_layout.json
Pal_FadeFromBlack:
                move.w  #$40-1,(Palette_fade_info).w
                jsr     Pal_FillBlack(pc)
                move.w  #$15,d4

loc_3284:
                move.b  #VInt_ID_12,(V_int_routine).w
                bsr.w   Wait_VSync
                bsr.s   Pal_FromBlack
                bsr.w   Process_Nem_Queue_Init
                dbf     d4,loc_3284
                rts
; End of function Pal_FadeFromBlack

; =============== S U B R O U T I N E =======================================

Pal_FromBlack:
                moveq   #0,d0
                lea     (Normal_palette).w,a0
                lea     (Target_palette).w,a1
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                adda.w  d0,a1
                move.b  (Palette_fade_count).w,d0

loc_32B0:
                bsr.s   Pal_AddColor
                dbf     d0,loc_32B0
                tst.b   (Water_flag).w
                beq.s   locret_32D8
                moveq   #0,d0
                lea     (Water_palette).w,a0
                lea     (Target_water_palette).w,a1
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                adda.w  d0,a1
                move.b  (Palette_fade_count).w,d0

loc_32D2:
                bsr.s   Pal_AddColor
                dbf     d0,loc_32D2

locret_32D8:
                rts
; End of function Pal_FromBlack

; =============== S U B R O U T I N E =======================================

Pal_AddColor:
                move.w  (a1)+,d2
                move.w  (a0),d3
                cmp.w   d2,d3
                beq.s   loc_3302
                move.w  d3,d1
                addi.w  #$200,d1
                cmp.w   d2,d1
                bhi.s   loc_32F0
                move.w  d1,(a0)+
                rts
; ---------------------------------------------------------------------------

loc_32F0:
                move.w  d3,d1
                addi.w  #$20,d1
                cmp.w   d2,d1
                bhi.s   loc_32FE
                move.w  d1,(a0)+
                rts
; ---------------------------------------------------------------------------

loc_32FE:
                addq.w  #2,(a0)+
                rts
; ---------------------------------------------------------------------------

loc_3302:
                addq.w  #2,a0
                rts
; End of function Pal_AddColor

; =============== S U B R O U T I N E =======================================

Pal_FillBlack:
                moveq   #0,d0
                lea     (Normal_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                moveq   #0,d1
                move.b  (Palette_fade_count).w,d0

loc_3318:
                move.w  d1,(a0)+
                tst.b   (Water_flag).w
                beq.s   loc_3324
                move.w  d1,(Water_palette-Normal_palette)-2(a0)

loc_3324:
                dbf     d0,loc_3318
                rts
; End of function Pal_FillBlack

; =============== S U B R O U T I N E =======================================

Animate_Palette:
                tst.w   (Palette_fade_timer).w
                beq.s   loc_3338
                subq.w  #1,(Palette_fade_timer).w
                bra.w   Pal_FromBlack
; ---------------------------------------------------------------------------

loc_3338:
                jmp     (AnPal_Load).l
; End of function Animate_Palette

; =============== S U B R O U T I N E =======================================

Pal_FadeToBlack:
                move.w  #$40-1,(Palette_fade_info).w
                move.w  #$15,d4

loc_3348:
                move.b  #VInt_ID_12,(V_int_routine).w
                bsr.w   Wait_VSync
                bsr.s   Pal_ToBlack
                bsr.w   Process_Nem_Queue_Init
                dbf     d4,loc_3348
                rts
; End of function Pal_FadeToBlack

; =============== S U B R O U T I N E =======================================

Pal_ToBlack:
                moveq   #0,d0
                lea     (Normal_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                move.b  (Palette_fade_count).w,d0

loc_336E:
                bsr.s   Pal_DecColor
                dbf     d0,loc_336E
                moveq   #0,d0
                lea     (Water_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                move.b  (Palette_fade_count).w,d0

loc_3384:
                bsr.s   Pal_DecColor
                dbf     d0,loc_3384
                rts
; End of function Pal_ToBlack

; =============== S U B R O U T I N E =======================================

Pal_DecColor:
                move.w  (a0),d2
                beq.s   loc_33B8
                move.w  d2,d1
                andi.w  #$E,d1
                beq.s   loc_339C
                subq.w  #2,(a0)+
                rts
; ---------------------------------------------------------------------------

loc_339C:
                move.w  d2,d1
                andi.w  #$E0,d1
                beq.s   loc_33AA
                subi.w  #$20,(a0)+
                rts
; ---------------------------------------------------------------------------

loc_33AA:
                move.w  d2,d1
                andi.w  #$E00,d1
                beq.s   loc_33B8
                subi.w  #$200,(a0)+
                rts
; ---------------------------------------------------------------------------

loc_33B8:
                addq.w  #2,a0
                rts
; End of function Pal_DecColor

; =============== S U B R O U T I N E =======================================

Pal_FadeFromWhite:
                move.w  #$40-1,(Palette_fade_info).w
                moveq   #0,d0
                lea     (Normal_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                move.w  #$EEE,d1
                move.b  (Palette_fade_count).w,d0

loc_33D6:
                move.w  d1,(a0)+
                dbf     d0,loc_33D6
                move.w  #$15,d4

loc_33E0:
                move.b  #VInt_ID_12,(V_int_routine).w
                bsr.w   Wait_VSync
                bsr.s   Pal_FromWhite
                bsr.w   Process_Nem_Queue_Init
                dbf     d4,loc_33E0
                rts
; End of function Pal_FadeFromWhite

; =============== S U B R O U T I N E =======================================

Pal_FromWhite:
                moveq   #0,d0
                lea     (Normal_palette).w,a0
                lea     (Target_palette).w,a1
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                adda.w  d0,a1
                move.b  (Palette_fade_count).w,d0

loc_340C:
                bsr.s   Pal_DecColor2
                dbf     d0,loc_340C
                tst.b   (Water_flag).w
                beq.s   locret_3434
                moveq   #0,d0
                lea     (Water_palette).w,a0
                lea     (Target_water_palette).w,a1
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                adda.w  d0,a1
                move.b  (Palette_fade_count).w,d0

loc_342E:
                bsr.s   Pal_DecColor2
                dbf     d0,loc_342E

locret_3434:
                rts
; End of function Pal_FromWhite

; =============== S U B R O U T I N E =======================================

Pal_DecColor2:
                move.w  (a1)+,d2
                move.w  (a0),d3
                cmp.w   d2,d3
                beq.s   loc_3462
                move.w  d3,d1
                subi.w  #$200,d1
                bcs.s   loc_344E
                cmp.w   d2,d1
                bcs.s   loc_344E
                move.w  d1,(a0)+
                rts
; ---------------------------------------------------------------------------

loc_344E:
                move.w  d3,d1
                subi.w  #$20,d1
                bcs.s   loc_345E
                cmp.w   d2,d1
                bcs.s   loc_345E
                move.w  d1,(a0)+
                rts
; ---------------------------------------------------------------------------

loc_345E:
                subq.w  #2,(a0)+
                rts
; ---------------------------------------------------------------------------

loc_3462:
                addq.w  #2,a0
                rts
; End of function Pal_DecColor2

; =============== S U B R O U T I N E =======================================

Pal_FadeToWhite:
                move.w  #$40-1,(Palette_fade_info).w
                move.w  #$15,d4

loc_3470:
                move.b  #VInt_ID_12,(V_int_routine).w
                bsr.w   Wait_VSync
                bsr.s   Pal_ToWhite
                bsr.w   Process_Nem_Queue_Init
                dbf     d4,loc_3470
                rts
; End of function Pal_FadeToWhite

; =============== S U B R O U T I N E =======================================

Pal_ToWhite:
                moveq   #0,d0
                lea     (Normal_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                move.b  (Palette_fade_count).w,d0

loc_3496:
                bsr.s   Pal_AddColor2
                dbf     d0,loc_3496
                moveq   #0,d0
                lea     (Water_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                move.b  (Palette_fade_count).w,d0

loc_34AC:
                bsr.s   Pal_AddColor2
                dbf     d0,loc_34AC
                rts
; End of function Pal_ToWhite

; =============== S U B R O U T I N E =======================================

Pal_AddColor2:
                move.w  (a0),d2
                cmpi.w  #$EEE,d2
                beq.s   loc_34F0
                move.w  d2,d1
                andi.w  #$E,d1
                cmpi.w  #$E,d1
                beq.s   loc_34CC
                addq.w  #2,(a0)+
                rts
; ---------------------------------------------------------------------------

loc_34CC:
                move.w  d2,d1
                andi.w  #$E0,d1
                cmpi.w  #$E0,d1
                beq.s   loc_34DE
                addi.w  #$20,(a0)+
                rts
; ---------------------------------------------------------------------------

loc_34DE:
                move.w  d2,d1
                andi.w  #$E00,d1
                cmpi.w  #$E00,d1
                beq.s   loc_34F0
                addi.w  #$200,(a0)+
                rts
; ---------------------------------------------------------------------------

loc_34F0:
                addq.w  #2,a0
                rts
; End of function Pal_AddColor2

; =============== S U B R O U T I N E =======================================

LoadPalette:
                lea     (PalPoint).l,a1
                lsl.w   #3,d0
                adda.w  d0,a1
                movea.l (a1)+,a2
                movea.w (a1)+,a3
                adda.w  #Target_palette-Normal_palette,a3
                move.w  (a1)+,d7

                .loop:
                move.l  (a2)+,(a3)+
                dbf     d7,.loop
                rts
; End of function LoadPalette

; =============== S U B R O U T I N E =======================================

LoadPalette_Immediate:
                lea     (PalPoint).l,a1
                lsl.w   #3,d0
                adda.w  d0,a1
                movea.l (a1)+,a2
                movea.w (a1)+,a3
                move.w  (a1)+,d7

                .loop:
                move.l  (a2)+,(a3)+
                dbf     d7,.loop
                rts
; End of function LoadPalette_Immediate

; =============== S U B R O U T I N E =======================================

LoadPalette2:
                lea     (PalPoint).l,a1
                lsl.w   #3,d0
                adda.w  d0,a1
                movea.l (a1)+,a2
                movea.w (a1)+,a3
                suba.w  #Normal_palette-Water_palette,a3
                move.w  (a1)+,d7

                .loop:
                move.l  (a2)+,(a3)+
                dbf     d7,.loop
                rts
; End of function LoadPalette2

; =============== S U B R O U T I N E =======================================

LoadPalette2_Immediate:
                lea     (PalPoint).l,a1
                lsl.w   #3,d0
                adda.w  d0,a1
                movea.l (a1)+,a2
                movea.w (a1)+,a3
                suba.w  #Normal_palette-Target_water_palette,a3
                move.w  (a1)+,d7

                .loop:
                move.l  (a2)+,(a3)+
                dbf     d7,.loop
                rts
; End of function LoadPalette2_Immediate
