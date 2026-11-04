; Owner: rendering/s3
; Responsibility: Art-scaling buffer initialization, scale selection, packed pixel sampling and scaled sprite mappings
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Init_ArtScaling:
                moveq   #0,d1
                move.w  d1,(_unkF740).w
                movea.w d1,a0
                movea.w d1,a1
                movea.w d1,a2
                movea.w d1,a3
                movea.w d1,a4
                movea.w d1,a5
                lea     (H_scroll_buffer).w,a6
                move.w  #bytesToXcnt($1000,$100),d1

                .loop:
                rept    10
                movem.l a0-a5,-(a6)
                endm
                movem.l a0-a3,-(a6)
                dbf     d1,.loop
                rts
; End of function Init_ArtScaling

; ---------------------------------------------------------------------------
S3Scale_TileCountsByScale:
                dc.w    $100
                dc.w    $FC
                dc.w    $90
                dc.w    $90
                dc.w    $40
                dc.w    $40
                dc.w    $40
                dc.w    $3C
                dc.w    $3C
                dc.w    $3C
                dc.w    $3C
                dc.w    $3C
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $C
                dc.w    $C
                dc.w    $C
                dc.w    $C

; =============== S U B R O U T I N E =======================================

TryBuildObjectScaledArt:
                moveq   #0,d1
                move.b  $40(a0),d1
                cmpi.b  #$1C,d1
                blo.s   S3Scale_SetFrameAndTryReserveTiles
                move.b  #$1C,d1                         ; Maximum 28 different "scales"

S3Scale_SetFrameAndTryReserveTiles:
                move.b  d1,mapping_frame(a0)            ; Scale level correlates with mapping frame
                add.w   d1,d1
                move.w  S3Scale_TileCountsByScale(pc,d1.w),d1
                move.w  (_unkF740).w,d2
                add.w   d1,d2
                cmpi.w  #$80,d2
                bhi.s   S3Scale_HideOnReservationFailure
                sub.w   d1,d2
                movem.l d1/d5-a0/a2/a4,-(sp)
                lea     (Kos_decomp_buffer).w,a2
                add.w   d2,d0
                move.w  d0,art_tile(a0)
                lsl.w   #5,d2
                adda.w  d2,a2
                bsr.s   ScaleArt_ResampleObjectFrame
                movem.l (sp)+,d1/d5-a0/a2/a4
                add.w   d1,(_unkF740).w
                rts
; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------

S3Scale_HideOnReservationFailure:
                bclr    #7,render_flags(a0)
                rts
; End of function TryBuildObjectScaledArt

; =============== S U B R O U T I N E =======================================

ScaleArt_ResampleObjectFrame:
                moveq   #0,d0
                move.b  $40(a0),d0                      ; Scale factor
                moveq   #0,d1
                move.b  anim(a0),d1
                movea.l $42(a0),a1                      ; Scaled art address
                ror.w   #4,d1
                adda.l  d1,a1
                movea.l a1,a0
                adda.w  #$1000,a0
                addi.w  #4,d0
                move.w  d0,d4
                lsr.w   #3,d4
                move.w  d0,d5
                ror.w   #3,d5
                andi.w  #$E000,d5
                move.w  #$F0,d6
                swap    d6
                move.w  #$F,d7
                swap    d7
                tst.w   d4
                beq.w   S3Scale_TryFactor7Sampler       ; If modified scale factor smaller than 8, branch
                cmpi.w  #1,d4
                bne.s   S3Scale_InitGenericSampler      ; If modified scale factor is not between 8-$10, branch
                tst.w   d5
                beq.w   S3Scale_InitFactor8Sampler      ; If modified scale factor is 8, branch
                cmpi.w  #$2000,d5
                beq.w   S3Scale_InitFactor9Sampler      ; If modified scale factor is 9, branch

S3Scale_InitGenericSampler:
                move.w  d4,d2                           ; All other instances. Scale factor/8 to d2
                swap    d2
                move.w  d5,d2
                lsr.l   #8,d2                           ; Combine with other scale factor to create final result: Scale factor << 5
                move.l  #$400000,d0
                divu.w  d2,d0
                lsr.w   #8,d0
                lsr.w   #3,d0
                subq.w  #1,d0                           ; Divide 400000 by modified scale factor << 5, subtract 1
                movea.w d0,a5                           ; Note the result in a5
                moveq   #0,d2
                moveq   #0,d3
                lea     S3Scale_PackGenericSamples(pc),a6

S3Scale_BeginGenericGroup:
                move.w  #$20-1,d7

S3Scale_InitGenericRow:
                swap    d7
                swap    d3
                move.w  #0,d2
                move.w  #0,d3
                movea.l a2,a4
                move.w  a5,d6
                bmi.s   S3Scale_WriteMaskedGenericTail

S3Scale_WriteGenericRowGroups:
                swap    d6
                jsr     (a6)
                swap    d6
                dbf     d6,S3Scale_WriteGenericRowGroups
                cmpi.w  #$40,d2
                bhs.s   S3Scale_AdvanceGenericYPhase

S3Scale_WriteMaskedGenericTail:
                swap    d6
                jsr     ScaleArt_WriteMaskedTailPixels(pc)
                swap    d6

; Carry from the vertical fraction adds one source row before the whole-row step
S3Scale_AdvanceGenericYPhase:
                swap    d3
                add.w   d5,d3
                bcc.s   S3Scale_AdvanceGenericRows
                adda.w  #$40,a1

S3Scale_AdvanceGenericRows:
                move.w  d4,d0
                lsl.w   #6,d0
                adda.w  d0,a1
                cmpa.l  a0,a1
                bhs.s   S3Scale_GenericSamplerReturn
                addq.w  #4,a2
                swap    d7
                dbf     d7,S3Scale_InitGenericRow
                lea     $380(a2),a2
                bra.s   S3Scale_BeginGenericGroup
; ---------------------------------------------------------------------------

S3Scale_GenericSamplerReturn:
                rts
; ---------------------------------------------------------------------------

S3Scale_PackGenericSamples:
                rept    4
                move.b  (a1,d2.w),d0
                add.w   d5,d3
                addx.w  d4,d2
                move.b  (a1,d2.w),d1
                add.w   d5,d3
                addx.w  d4,d2
                and.b   d6,d0
                and.b   d7,d1
                or.b    d1,d0
                move.b  d0,(a4)+
                endm
                lea     $7C(a4),a4
                rts

; =============== S U B R O U T I N E =======================================

ScaleArt_WriteMaskedTailPixels:
                rept    4
                move.b  (a1,d2.w),d0
                add.w   d5,d3
                addx.w  d4,d2
                cmpi.w  #$40,d2
                blo.s   ScaleArtTail_ReadSecondSourceByte
                move.b  #0,d0

ScaleArtTail_ReadSecondSourceByte:
                move.b  (a1,d2.w),d1
                add.w   d5,d3
                addx.w  d4,d2
                cmpi.w  #$40,d2
                blo.s   S3Scale_StoreTailPackedByte
                move.b  #0,d1

S3Scale_StoreTailPackedByte:
                and.b   d6,d0
                and.b   d7,d1
                or.b    d1,d0
                move.b  d0,(a4)+
                endm
                lea     $7C(a4),a4
                rts
; End of function ScaleArt_WriteMaskedTailPixels

; ---------------------------------------------------------------------------

S3Scale_InitFactor9Sampler:
                moveq   #0,d3
                lsl.w   #6,d4
                lea     S3Scale_PackFactor9Samples(pc),a6
                move.w  #2-1,d7

S3Scale_BeginFactor9Group:
                swap    d7
                move.w  #$20-1,d6

S3Scale_WriteFactor9Row:
                swap    d6
                movea.l a1,a3
                movea.l a2,a4
                rept    7
                jsr     (a6)
                endm
                move.b  (a3)+,d0
                and.b   d6,d0
                move.b  d0,(a4)+
                add.w   d5,d3
                bcc.s   S3Scale_AdvanceFactor9Rows
                lea     $40(a1),a1

S3Scale_AdvanceFactor9Rows:
                adda.w  d4,a1
                cmpa.l  a0,a1
                bhs.s   S3ArtScaling_ReturnFromFactorNineSampler
                addq.w  #4,a2
                swap    d6
                dbf     d6,S3Scale_WriteFactor9Row
                lea     $380(a2),a2
                swap    d7
                dbf     d7,S3Scale_BeginFactor9Group

S3ArtScaling_ReturnFromFactorNineSampler:
                rts
; ---------------------------------------------------------------------------

; Read eight source bytes into four output bytes, then skip the ninth source byte
S3Scale_PackFactor9Samples:
                rept    3
                move.b  (a3)+,d0
                move.b  (a3)+,d1
                and.b   d6,d0
                and.b   d7,d1
                or.b    d1,d0
                move.b  d0,(a4)+
                endm
                move.b  (a3)+,d0
                move.b  (a3)+,d1
                addq.w  #1,a3
                and.b   d6,d0
                and.b   d7,d1
                or.b    d1,d0
                move.b  d0,(a4)+
                lea     $7C(a4),a4
                rts
; ---------------------------------------------------------------------------

S3Scale_InitFactor8Sampler:
                moveq   #0,d3
                lsl.w   #6,d4
                lea     S3Scale_PackFactor8Samples(pc),a6
                move.w  #2-1,d7

S3Scale_BeginFactor8Group:
                swap    d7
                move.w  #$20-1,d6

S3Scale_WriteFactor8Row:
                swap    d6
                movea.l a1,a3
                movea.l a2,a4
                rept    8
                jsr     (a6)
                endm
                add.w   d5,d3
                bcc.s   S3Scale_AdvanceFactor8Rows
                lea     $40(a1),a1

S3Scale_AdvanceFactor8Rows:
                adda.w  d4,a1
                addq.w  #4,a2
                swap    d6
                dbf     d6,S3Scale_WriteFactor8Row
                lea     $380(a2),a2
                swap    d7
                dbf     d7,S3Scale_BeginFactor8Group
                rts
; ---------------------------------------------------------------------------

S3Scale_PackFactor8Samples:
                rept    4
                move.b  (a3)+,d0
                move.b  (a3)+,d1
                and.b   d6,d0
                and.b   d7,d1
                or.b    d1,d0
                move.b  d0,(a4)+
                endm
                lea     $7C(a4),a4
                rts
; ---------------------------------------------------------------------------

S3Scale_TryFactor7Sampler:
                cmpi.w  #$E000,d5
                bne.w   S3Scale_TryFactor6Sampler
                lea     S3Scale_PackFactor7Samples(pc),a6
                moveq   #0,d3
                lsl.w   #6,d4
                move.w  #3-1,d7

S3Scale_BeginFactor7Group:
                swap    d7
                move.w  #$20-1,d6

S3Scale_WriteFactor7Row:
                swap    d6
                movea.l a1,a3
                movea.l a2,a4
                rept    9
                jsr     (a6)
                endm
                move.b  (a3),(a4)
                add.w   d5,d3
                bcc.s   S3Scale_AdvanceFactor7Rows
                lea     $40(a1),a1

S3Scale_AdvanceFactor7Rows:
                adda.w  d4,a1
                cmpa.l  a0,a1
                bhs.s   S3Scale_Factor7Return
                addq.w  #4,a2
                swap    d6
                dbf     d6,S3Scale_WriteFactor7Row
                lea     $580(a2),a2
                swap    d7
                dbf     d7,S3Scale_BeginFactor7Group

S3Scale_Factor7Return:
                rts
; ---------------------------------------------------------------------------

S3Scale_PackFactor7Samples:
                move.b  (a3)+,(a4)+
                rept    3
                move.b  (a3)+,d0
                move.b  (a3)+,d1
                and.b   d6,d0
                and.b   d7,d1
                or.b    d1,d0
                move.b  d0,(a4)+
                endm
                lea     $7C(a4),a4
                rts
; ---------------------------------------------------------------------------

S3Scale_TryFactor6Sampler:
                cmpi.w  #$C000,d5
                bne.w   S3Scale_TryFactor5Sampler
                moveq   #0,d3
                lsl.w   #6,d4
                lea     S3Scale_PackFactor6Samples(pc),a6
                move.w  #4-1,d7

S3Scale_BeginFactor6Group:
                swap    d7
                move.w  #$20-1,d6

S3Scale_WriteFactor6Row:
                swap    d6
                movea.l a1,a3
                movea.l a2,a4
                rept    10
                jsr     (a6)
                endm
                move.b  (a3)+,(a4)+
                move.b  (a3)+,d0
                move.b  (a3)+,d1
                and.b   d6,d0
                and.b   d7,d1
                or.b    d1,d0
                move.b  d0,(a4)+
                move.b  (a3),d0
                move.b  d0,(a4)
                add.w   d5,d3
                bcc.s   S3Scale_AdvanceFactor6Rows
                lea     $40(a1),a1

S3Scale_AdvanceFactor6Rows:
                adda.w  d4,a1
                cmpa.l  a0,a1
                bhs.s   S3ArtScaling_ReturnFromFactorSixSampler
                addq.w  #4,a2
                swap    d6
                dbf     d6,S3Scale_WriteFactor6Row
                lea     $580(a2),a2
                swap    d7
                dbf     d7,S3Scale_BeginFactor6Group

S3ArtScaling_ReturnFromFactorSixSampler:
                rts
; ---------------------------------------------------------------------------

S3Scale_PackFactor6Samples:
                rept    2
                move.b  (a3)+,(a4)+
                move.b  (a3)+,d0
                move.b  (a3)+,d1
                and.b   d6,d0
                and.b   d7,d1
                or.b    d1,d0
                move.b  d0,(a4)+
                endm
                lea     $7C(a4),a4
                rts
; ---------------------------------------------------------------------------

S3Scale_TryFactor5Sampler:
                cmpi.w  #$A000,d5
                bne.w   S3Scale_InitFactor4Copy
                moveq   #0,d3
                lsl.w   #6,d4
                lea     S3Scale_PackFactor5FromWord(pc),a5
                lea     S3Scale_PackFactor5FromBytes(pc),a6
                move.w  #4-1,d7

S3Scale_BeginFactor5Group:
                swap    d7
                move.w  #$20-1,d6

S3Scale_WriteFactor5Row:
                swap    d6
                movea.l a1,a3
                movea.l a2,a4
                rept    6
                jsr     (a5)
                jsr     (a6)
                endm
                move.w  (a3)+,(a4)+
                move.b  (a3)+,d0
                move.b  (a3)+,d1
                and.b   d6,d0
                and.b   d7,d1
                or.b    d1,d0
                move.b  d0,(a4)+
                add.w   d5,d3
                bcc.s   S3Scale_AdvanceFactor5Rows
                lea     $40(a1),a1

S3Scale_AdvanceFactor5Rows:
                adda.w  d4,a1
                cmpa.l  a0,a1
                bhs.s   S3ArtScaling_ReturnFromFactorFiveSampler
                addq.w  #4,a2
                swap    d6
                dbf     d6,S3Scale_WriteFactor5Row
                lea     $780(a2),a2
                swap    d7
                dbf     d7,S3Scale_BeginFactor5Group

S3ArtScaling_ReturnFromFactorFiveSampler:
                rts
; ---------------------------------------------------------------------------

S3Scale_PackFactor5FromBytes:
                move.b  (a3)+,(a4)+
                move.b  (a3)+,(a4)+
                move.b  (a3)+,d0
                move.b  (a3)+,d1
                and.b   d6,d0
                and.b   d7,d1
                or.b    d1,d0
                move.b  d0,(a4)+
                move.b  (a3)+,(a4)+
                lea     $7C(a4),a4
                rts
; ---------------------------------------------------------------------------

S3Scale_PackFactor5FromWord:
                move.w  (a3)+,(a4)+
                move.b  (a3)+,d0
                move.b  (a3)+,d1
                and.b   d6,d0
                and.b   d7,d1
                or.b    d1,d0
                move.b  d0,(a4)+
                move.b  (a3)+,(a4)+
                lea     $7C(a4),a4
                rts
; ---------------------------------------------------------------------------

S3Scale_InitFactor4Copy:
                moveq   #0,d3
                lsl.w   #6,d4
                moveq   #4-1,d7

S3Scale_BeginFactor4Group:
                move.w  #$20-1,d6

S3Scale_CopyFactor4Row:
                movea.l a1,a3
                movea.l a2,a4
                rept    16
                move.l  (a3)+,(a4)
                lea     $80(a4),a4
                endm
                add.w   d5,d3
                bcc.s   S3Scale_AdvanceFactor4Rows
                lea     $40(a1),a1

S3Scale_AdvanceFactor4Rows:
                adda.w  d4,a1
                addq.w  #4,a2
                dbf     d6,S3Scale_CopyFactor4Row
                lea     $780(a2),a2
                dbf     d7,S3Scale_BeginFactor4Group
                rts
; ---------------------------------------------------------------------------
Map_ScaledArt:
                include "src/objects/shared/level_misc/mappings/scaled_art.s"
