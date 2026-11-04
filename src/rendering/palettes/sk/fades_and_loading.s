; Owner: rendering/palettes/sk; responsibility: fades and loading
; Source provenance and ranges: config/reconstruction/source_layout.json
Pal_FadeFromBlack:
                move.w  #$40-1,(Palette_fade_info).w
                jsr     Pal_FillBlack(pc)
                move.w  #$15,d4

SKPalette_RunBlackToTargetVblankStepLoop:
                move.b  #VInt_ID_12,(V_int_routine).w
                bsr.w   Wait_VSync
                bsr.s   Pal_FromBlack
                bsr.w   Process_Nem_Queue_Init
                dbf     d4,SKPalette_RunBlackToTargetVblankStepLoop
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

SKPal_FromBlackStepNormal:
                bsr.s   Pal_AddColor
                dbf     d0,SKPal_FromBlackStepNormal
                tst.b   (Water_flag).w
                beq.s   SKPal_FromBlackReturn
                moveq   #0,d0
                lea     (Water_palette).w,a0
                lea     (Target_water_palette).w,a1
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                adda.w  d0,a1
                move.b  (Palette_fade_count).w,d0

SKPal_FromBlackStepWater:
                bsr.s   Pal_AddColor
                dbf     d0,SKPal_FromBlackStepWater

SKPal_FromBlackReturn:
                rts
; End of function Pal_FromBlack

; =============== S U B R O U T I N E =======================================

Pal_AddColor:
                move.w  (a1)+,d2
                move.w  (a0),d3
                cmp.w   d2,d3
                beq.s   SKPal_FromBlackSkipColor
                move.w  d3,d1
                addi.w  #$200,d1
                cmp.w   d2,d1
                bhi.s   SKPal_FromBlackTryMid
                move.w  d1,(a0)+
                rts
; ---------------------------------------------------------------------------

SKPal_FromBlackTryMid:
                move.w  d3,d1
                addi.w  #$20,d1
                cmp.w   d2,d1
                bhi.s   SKPal_FromBlackStepLow
                move.w  d1,(a0)+
                rts
; ---------------------------------------------------------------------------

SKPal_FromBlackStepLow:
                addq.w  #2,(a0)+
                rts
; ---------------------------------------------------------------------------

SKPal_FromBlackSkipColor:
                addq.w  #2,a0
                rts
; End of function Pal_AddColor

; =============== S U B R O U T I N E =======================================

Pal_FillBlack:
                cmpi.w  #$D01,(Current_zone_and_act).w
                beq.w   Pal_FillWhite
                cmpi.w  #$1701,(Current_zone_and_act).w
                beq.w   Pal_FillWhite                   ; If one of either Sky Sanctuary Knuckles level or the Super Emerald special stage arena, branch
                moveq   #0,d0
                lea     (Normal_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                moveq   #0,d1
                move.b  (Palette_fade_count).w,d0

SKPal_FillBlackColor:
                move.w  d1,(a0)+
                tst.b   (Water_flag).w
                beq.s   SKPalette_AdvanceBlackFillEntryCounter
                move.w  d1,(Water_palette-Normal_palette)-2(a0)

SKPalette_AdvanceBlackFillEntryCounter:
                dbf     d0,SKPal_FillBlackColor
                rts
; End of function Pal_FillBlack

; =============== S U B R O U T I N E =======================================

Animate_Palette:
                tst.w   (Palette_fade_timer).w
                bmi.s   SKPal_NegativeTimerReturn
                beq.s   SKPal_RunPaletteCycles
                subq.w  #1,(Palette_fade_timer).w
                cmpi.w  #$D01,(Current_zone_and_act).w
                beq.w   Pal_FromWhite
                cmpi.w  #$1701,(Current_zone_and_act).w
                beq.w   Pal_FromWhite
                bra.w   Pal_FromBlack
; ---------------------------------------------------------------------------

SKPal_RunPaletteCycles:
                jmp     (AnPal_Load).l
; ---------------------------------------------------------------------------

SKPal_NegativeTimerReturn:
                rts
; End of function Animate_Palette

; =============== S U B R O U T I N E =======================================

Pal_FadeToBlack:
                move.w  #$40-1,(Palette_fade_info).w
                move.w  #$15,d4

SKPal_ToBlackVBlankLoop:
                move.b  #VInt_ID_12,(V_int_routine).w
                bsr.w   Wait_VSync
                bsr.s   Pal_ToBlack
                bsr.w   Process_Nem_Queue_Init
                dbf     d4,SKPal_ToBlackVBlankLoop
                rts
; End of function Pal_FadeToBlack

; =============== S U B R O U T I N E =======================================

Pal_ToBlack:
                moveq   #0,d0
                lea     (Normal_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                move.b  (Palette_fade_count).w,d0

SKPal_ToBlackStepNormal:
                bsr.s   Pal_DecColor
                dbf     d0,SKPal_ToBlackStepNormal
                moveq   #0,d0
                lea     (Water_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                move.b  (Palette_fade_count).w,d0

; Step the water palette even when the water flag is clear
SKPal_ToBlackStepWater:
                bsr.s   Pal_DecColor
                dbf     d0,SKPal_ToBlackStepWater
                rts
; End of function Pal_ToBlack

; =============== S U B R O U T I N E =======================================

Pal_DecColor:
                move.w  (a0),d2
                beq.s   SKPal_ToBlackSkipColor
                move.w  d2,d1
                andi.w  #$E,d1
                beq.s   SKPal_ToBlackTryMid
                subq.w  #2,(a0)+
                rts
; ---------------------------------------------------------------------------

SKPal_ToBlackTryMid:
                move.w  d2,d1
                andi.w  #$E0,d1
                beq.s   SKPal_ToBlackTryHigh
                subi.w  #$20,(a0)+
                rts
; ---------------------------------------------------------------------------

SKPal_ToBlackTryHigh:
                move.w  d2,d1
                andi.w  #$E00,d1
                beq.s   SKPal_ToBlackSkipColor
                subi.w  #$200,(a0)+
                rts
; ---------------------------------------------------------------------------

SKPal_ToBlackSkipColor:
                addq.w  #2,a0
                rts
; End of function Pal_DecColor

; =============== S U B R O U T I N E =======================================

Pal_FillWhite:
                moveq   #0,d0
                lea     (Normal_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                move.w  #$EEE,d1
                move.b  (Palette_fade_count).w,d0

SKPal_FillNormalWhite:
                move.w  d1,(a0)+
                dbf     d0,SKPal_FillNormalWhite
                clr.w   (Pal_fade_delay2).w
                rts
; End of function Pal_FillWhite

; =============== S U B R O U T I N E =======================================

Pal_FadeFromWhite:
                move.w  #$40-1,(Palette_fade_info).w
                bsr.s   Pal_FillWhite
                move.w  #$15,d4

SKPalette_RunWhiteToTargetVblankStepLoop:
                move.b  #VInt_ID_12,(V_int_routine).w
                bsr.w   Wait_VSync
                bsr.s   Pal_FromWhite
                bsr.w   Process_Nem_Queue_Init
                dbf     d4,SKPalette_RunWhiteToTargetVblankStepLoop
                rts
; End of function Pal_FadeFromWhite

; =============== S U B R O U T I N E =======================================

Pal_FromWhite:
                subq.w  #1,(Pal_fade_delay2).w
                bpl.s   SKPal_FromWhiteReturn
                move.w  #2,(Pal_fade_delay2).w
                moveq   #0,d0
                lea     (Normal_palette).w,a0
                lea     (Target_palette).w,a1
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                adda.w  d0,a1
                move.b  (Palette_fade_count).w,d0

SKPal_FromWhiteStepNormal:
                bsr.s   Pal_DecColor2
                dbf     d0,SKPal_FromWhiteStepNormal
                tst.b   (Water_flag).w
                beq.s   SKPal_FromWhiteReturn
                moveq   #0,d0
                lea     (Water_palette).w,a0
                lea     (Target_water_palette).w,a1
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                adda.w  d0,a1
                move.b  (Palette_fade_count).w,d0

SKPal_FromWhiteStepWater:
                bsr.s   Pal_DecColor2
                dbf     d0,SKPal_FromWhiteStepWater

SKPal_FromWhiteReturn:
                rts
; End of function Pal_FromWhite

; =============== S U B R O U T I N E =======================================

Pal_DecColor2:
                move.b  (a1)+,d2
                andi.b  #$E,d2
                move.b  (a0),d3
                andi.b  #$E,d3
                cmp.b   d2,d3
                bls.s   SKPal_FromWhiteStoreHigh
                subq.b  #2,d3

SKPal_FromWhiteStoreHigh:
                move.b  d3,(a0)+
                move.b  (a1)+,d1
                move.b  d1,d2
                andi.b  #$E0,d1
                move.b  (a0),d3
                move.b  d3,d5
                andi.b  #$E0,d3
                cmp.b   d1,d3
                bls.s   SKPal_FromWhiteTryLow
                subi.b  #$20,d3

SKPal_FromWhiteTryLow:
                andi.b  #$E,d2
                andi.b  #$E,d5
                cmp.b   d2,d5
                bls.s   SKPal_FromWhiteStoreLowByte
                subq.b  #2,d5

SKPal_FromWhiteStoreLowByte:
                or.b    d5,d3
                move.b  d3,(a0)+
                rts
; End of function Pal_DecColor2

; =============== S U B R O U T I N E =======================================

Pal_FadeToWhite:
                move.w  #$40-1,(Palette_fade_info).w
                move.w  #$15,d4

SKPal_ToWhiteVBlankLoop:
                move.b  #VInt_ID_12,(V_int_routine).w
                bsr.w   Wait_VSync
                bsr.s   Pal_ToWhite
                bsr.w   Process_Nem_Queue_Init
                dbf     d4,SKPal_ToWhiteVBlankLoop
                rts
; End of function Pal_FadeToWhite

; =============== S U B R O U T I N E =======================================

Pal_ToWhite:
                moveq   #0,d0
                lea     (Normal_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                move.b  (Palette_fade_count).w,d0

SKPal_ToWhiteStepNormal:
                bsr.s   Pal_AddColor2
                dbf     d0,SKPal_ToWhiteStepNormal
                moveq   #0,d0
                lea     (Water_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                move.b  (Palette_fade_count).w,d0

; Step the water palette even when the water flag is clear
SKPal_ToWhiteStepWater:
                bsr.s   Pal_AddColor2
                dbf     d0,SKPal_ToWhiteStepWater
                rts
; End of function Pal_ToWhite

; =============== S U B R O U T I N E =======================================

Pal_AddColor2:
                move.w  (a0),d2
                cmpi.w  #$EEE,d2
                beq.s   SKPal_ToWhiteSkipColor
                move.w  d2,d1
                andi.w  #$E,d1
                cmpi.w  #$E,d1
                beq.s   SKPal_ToWhiteTryMid
                addq.w  #2,(a0)+
                rts
; ---------------------------------------------------------------------------

SKPal_ToWhiteTryMid:
                move.w  d2,d1
                andi.w  #$E0,d1
                cmpi.w  #$E0,d1
                beq.s   SKPal_ToWhiteTryHigh
                addi.w  #$20,(a0)+
                rts
; ---------------------------------------------------------------------------

SKPal_ToWhiteTryHigh:
                move.w  d2,d1
                andi.w  #$E00,d1
                cmpi.w  #$E00,d1
                beq.s   SKPal_ToWhiteSkipColor
                addi.w  #$200,(a0)+
                rts
; ---------------------------------------------------------------------------

SKPal_ToWhiteSkipColor:
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
