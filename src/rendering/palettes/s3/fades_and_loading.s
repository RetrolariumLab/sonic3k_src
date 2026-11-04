; Owner: rendering/palettes/s3; responsibility: fades and loading
; Source provenance and ranges: config/reconstruction/source_layout.json
Pal_FadeFromBlack:
                move.w  #$40-1,(Palette_fade_info).w
                jsr     Pal_FillBlack(pc)
                move.w  #$15,d4

S3Palette_RunBlackToTargetVblankStepLoop:
                move.b  #VInt_ID_12,(V_int_routine).w
                bsr.w   Wait_VSync
                bsr.s   Pal_FromBlack
                bsr.w   Process_Nem_Queue_Init
                dbf     d4,S3Palette_RunBlackToTargetVblankStepLoop
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

S3Pal_FromBlackStepNormal:
                bsr.s   Pal_AddColor
                dbf     d0,S3Pal_FromBlackStepNormal
                tst.b   (Water_flag).w
                beq.s   S3Pal_FromBlackReturn
                moveq   #0,d0
                lea     (Water_palette).w,a0
                lea     (Target_water_palette).w,a1
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                adda.w  d0,a1
                move.b  (Palette_fade_count).w,d0

S3Pal_FromBlackStepWater:
                bsr.s   Pal_AddColor
                dbf     d0,S3Pal_FromBlackStepWater

S3Pal_FromBlackReturn:
                rts
; End of function Pal_FromBlack

; =============== S U B R O U T I N E =======================================

Pal_AddColor:
                move.w  (a1)+,d2
                move.w  (a0),d3
                cmp.w   d2,d3
                beq.s   S3Pal_FromBlackSkipColor
                move.w  d3,d1
                addi.w  #$200,d1
                cmp.w   d2,d1
                bhi.s   S3Pal_FromBlackTryMid
                move.w  d1,(a0)+
                rts
; ---------------------------------------------------------------------------

S3Pal_FromBlackTryMid:
                move.w  d3,d1
                addi.w  #$20,d1
                cmp.w   d2,d1
                bhi.s   S3Pal_FromBlackStepLow
                move.w  d1,(a0)+
                rts
; ---------------------------------------------------------------------------

S3Pal_FromBlackStepLow:
                addq.w  #2,(a0)+
                rts
; ---------------------------------------------------------------------------

S3Pal_FromBlackSkipColor:
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

S3Pal_FillBlackColor:
                move.w  d1,(a0)+
                tst.b   (Water_flag).w
                beq.s   S3Palette_AdvanceBlackFillEntryCounter
                move.w  d1,(Water_palette-Normal_palette)-2(a0)

S3Palette_AdvanceBlackFillEntryCounter:
                dbf     d0,S3Pal_FillBlackColor
                rts
; End of function Pal_FillBlack

; =============== S U B R O U T I N E =======================================

Animate_Palette:
                tst.w   (Palette_fade_timer).w
                beq.s   S3Pal_RunPaletteCycles
                subq.w  #1,(Palette_fade_timer).w
                bra.w   Pal_FromBlack
; ---------------------------------------------------------------------------

S3Pal_RunPaletteCycles:
                jmp     (AnPal_Load).l
; End of function Animate_Palette

; =============== S U B R O U T I N E =======================================

Pal_FadeToBlack:
                move.w  #$40-1,(Palette_fade_info).w
                move.w  #$15,d4

S3Pal_ToBlackVBlankLoop:
                move.b  #VInt_ID_12,(V_int_routine).w
                bsr.w   Wait_VSync
                bsr.s   Pal_ToBlack
                bsr.w   Process_Nem_Queue_Init
                dbf     d4,S3Pal_ToBlackVBlankLoop
                rts
; End of function Pal_FadeToBlack

; =============== S U B R O U T I N E =======================================

Pal_ToBlack:
                moveq   #0,d0
                lea     (Normal_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                move.b  (Palette_fade_count).w,d0

S3Pal_ToBlackStepNormal:
                bsr.s   Pal_DecColor
                dbf     d0,S3Pal_ToBlackStepNormal
                moveq   #0,d0
                lea     (Water_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                move.b  (Palette_fade_count).w,d0

; Step the water palette even when the water flag is clear
S3Pal_ToBlackStepWater:
                bsr.s   Pal_DecColor
                dbf     d0,S3Pal_ToBlackStepWater
                rts
; End of function Pal_ToBlack

; =============== S U B R O U T I N E =======================================

Pal_DecColor:
                move.w  (a0),d2
                beq.s   S3Pal_ToBlackSkipColor
                move.w  d2,d1
                andi.w  #$E,d1
                beq.s   S3Pal_ToBlackTryMid
                subq.w  #2,(a0)+
                rts
; ---------------------------------------------------------------------------

S3Pal_ToBlackTryMid:
                move.w  d2,d1
                andi.w  #$E0,d1
                beq.s   S3Pal_ToBlackTryHigh
                subi.w  #$20,(a0)+
                rts
; ---------------------------------------------------------------------------

S3Pal_ToBlackTryHigh:
                move.w  d2,d1
                andi.w  #$E00,d1
                beq.s   S3Pal_ToBlackSkipColor
                subi.w  #$200,(a0)+
                rts
; ---------------------------------------------------------------------------

S3Pal_ToBlackSkipColor:
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

S3Pal_FillNormalWhite:
                move.w  d1,(a0)+
                dbf     d0,S3Pal_FillNormalWhite
                move.w  #$15,d4

S3Palette_RunWhiteToTargetVblankStepLoop:
                move.b  #VInt_ID_12,(V_int_routine).w
                bsr.w   Wait_VSync
                bsr.s   Pal_FromWhite
                bsr.w   Process_Nem_Queue_Init
                dbf     d4,S3Palette_RunWhiteToTargetVblankStepLoop
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

S3Pal_FromWhiteStepNormal:
                bsr.s   Pal_DecColor2
                dbf     d0,S3Pal_FromWhiteStepNormal
                tst.b   (Water_flag).w
                beq.s   S3Pal_FromWhiteReturn
                moveq   #0,d0
                lea     (Water_palette).w,a0
                lea     (Target_water_palette).w,a1
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                adda.w  d0,a1
                move.b  (Palette_fade_count).w,d0

S3Pal_FromWhiteStepWater:
                bsr.s   Pal_DecColor2
                dbf     d0,S3Pal_FromWhiteStepWater

S3Pal_FromWhiteReturn:
                rts
; End of function Pal_FromWhite

; =============== S U B R O U T I N E =======================================

Pal_DecColor2:
                move.w  (a1)+,d2
                move.w  (a0),d3
                cmp.w   d2,d3
                beq.s   S3Pal_FromWhiteSkipColor
                move.w  d3,d1
                subi.w  #$200,d1
                bcs.s   S3Pal_FromWhiteTryMid
                cmp.w   d2,d1
                bcs.s   S3Pal_FromWhiteTryMid
                move.w  d1,(a0)+
                rts
; ---------------------------------------------------------------------------

S3Pal_FromWhiteTryMid:
                move.w  d3,d1
                subi.w  #$20,d1
                bcs.s   S3Pal_FromWhiteStepLow
                cmp.w   d2,d1
                bcs.s   S3Pal_FromWhiteStepLow
                move.w  d1,(a0)+
                rts
; ---------------------------------------------------------------------------

S3Pal_FromWhiteStepLow:
                subq.w  #2,(a0)+
                rts
; ---------------------------------------------------------------------------

S3Pal_FromWhiteSkipColor:
                addq.w  #2,a0
                rts
; End of function Pal_DecColor2

; =============== S U B R O U T I N E =======================================

Pal_FadeToWhite:
                move.w  #$40-1,(Palette_fade_info).w
                move.w  #$15,d4

S3Pal_ToWhiteVBlankLoop:
                move.b  #VInt_ID_12,(V_int_routine).w
                bsr.w   Wait_VSync
                bsr.s   Pal_ToWhite
                bsr.w   Process_Nem_Queue_Init
                dbf     d4,S3Pal_ToWhiteVBlankLoop
                rts
; End of function Pal_FadeToWhite

; =============== S U B R O U T I N E =======================================

Pal_ToWhite:
                moveq   #0,d0
                lea     (Normal_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                move.b  (Palette_fade_count).w,d0

S3Pal_ToWhiteStepNormal:
                bsr.s   Pal_AddColor2
                dbf     d0,S3Pal_ToWhiteStepNormal
                moveq   #0,d0
                lea     (Water_palette).w,a0
                move.b  (Palette_fade_info).w,d0
                adda.w  d0,a0
                move.b  (Palette_fade_count).w,d0

; Step the water palette even when the water flag is clear
S3Pal_ToWhiteStepWater:
                bsr.s   Pal_AddColor2
                dbf     d0,S3Pal_ToWhiteStepWater
                rts
; End of function Pal_ToWhite

; =============== S U B R O U T I N E =======================================

Pal_AddColor2:
                move.w  (a0),d2
                cmpi.w  #$EEE,d2
                beq.s   S3Pal_ToWhiteSkipColor
                move.w  d2,d1
                andi.w  #$E,d1
                cmpi.w  #$E,d1
                beq.s   S3Pal_ToWhiteTryMid
                addq.w  #2,(a0)+
                rts
; ---------------------------------------------------------------------------

S3Pal_ToWhiteTryMid:
                move.w  d2,d1
                andi.w  #$E0,d1
                cmpi.w  #$E0,d1
                beq.s   S3Pal_ToWhiteTryHigh
                addi.w  #$20,(a0)+
                rts
; ---------------------------------------------------------------------------

S3Pal_ToWhiteTryHigh:
                move.w  d2,d1
                andi.w  #$E00,d1
                cmpi.w  #$E00,d1
                beq.s   S3Pal_ToWhiteSkipColor
                addi.w  #$200,(a0)+
                rts
; ---------------------------------------------------------------------------

S3Pal_ToWhiteSkipColor:
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
