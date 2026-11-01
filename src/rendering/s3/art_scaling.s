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
word_22C50:
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
                blo.s   loc_22CA0
                move.b  #$1C,d1                         ; Maximum 28 different "scales"

loc_22CA0:
                move.b  d1,mapping_frame(a0)            ; Scale level correlates with mapping frame
                add.w   d1,d1
                move.w  word_22C50(pc,d1.w),d1
                move.w  (_unkF740).w,d2
                add.w   d1,d2
                cmpi.w  #$80,d2
                bhi.s   loc_22CD8
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

loc_22CD8:
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
                beq.w   loc_22FC0                       ; If modified scale factor smaller than 8, branch
                cmpi.w  #1,d4
                bne.s   loc_22D30                       ; If modified scale factor is not between 8-$10, branch
                tst.w   d5
                beq.w   loc_22F44                       ; If modified scale factor is 8, branch
                cmpi.w  #$2000,d5
                beq.w   loc_22EBE                       ; If modified scale factor is 9, branch

loc_22D30:
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
                lea     loc_22DA2(pc),a6

loc_22D50:
                move.w  #$20-1,d7

loc_22D54:
                swap    d7
                swap    d3
                move.w  #0,d2
                move.w  #0,d3
                movea.l a2,a4
                move.w  a5,d6
                bmi.s   loc_22D76

loc_22D66:
                swap    d6
                jsr     (a6)
                swap    d6
                dbf     d6,loc_22D66
                cmpi.w  #$40,d2
                bhs.s   loc_22D7E

loc_22D76:
                swap    d6
                jsr     ScaleArt_WriteMaskedTailPixels(pc)
                swap    d6

loc_22D7E:
                swap    d3
                add.w   d5,d3
                bcc.s   loc_22D88
                adda.w  #$40,a1

loc_22D88:
                move.w  d4,d0
                lsl.w   #6,d0
                adda.w  d0,a1
                cmpa.l  a0,a1
                bhs.s   locret_22DA0
                addq.w  #4,a2
                swap    d7
                dbf     d7,loc_22D54
                lea     $380(a2),a2
                bra.s   loc_22D50
; ---------------------------------------------------------------------------

locret_22DA0:
                rts
; ---------------------------------------------------------------------------

loc_22DA2:
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
                blo.s   loc_22E1A
                move.b  #0,d0

loc_22E1A:
                move.b  (a1,d2.w),d1
                add.w   d5,d3
                addx.w  d4,d2
                cmpi.w  #$40,d2
                blo.s   loc_22E2C
                move.b  #0,d1

loc_22E2C:
                and.b   d6,d0
                and.b   d7,d1
                or.b    d1,d0
                move.b  d0,(a4)+
                endm
                lea     $7C(a4),a4
                rts
; End of function ScaleArt_WriteMaskedTailPixels

; ---------------------------------------------------------------------------

loc_22EBE:
                moveq   #0,d3
                lsl.w   #6,d4
                lea     loc_22F0C(pc),a6
                move.w  #2-1,d7

loc_22ECA:
                swap    d7
                move.w  #$20-1,d6

loc_22ED0:
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
                bcc.s   loc_22EF2
                lea     $40(a1),a1

loc_22EF2:
                adda.w  d4,a1
                cmpa.l  a0,a1
                bhs.s   locret_22F0A
                addq.w  #4,a2
                swap    d6
                dbf     d6,loc_22ED0
                lea     $380(a2),a2
                swap    d7
                dbf     d7,loc_22ECA

locret_22F0A:
                rts
; ---------------------------------------------------------------------------

loc_22F0C:
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

loc_22F44:
                moveq   #0,d3
                lsl.w   #6,d4
                lea     loc_22F8A(pc),a6
                move.w  #2-1,d7

loc_22F50:
                swap    d7
                move.w  #$20-1,d6

loc_22F56:
                swap    d6
                movea.l a1,a3
                movea.l a2,a4
                rept    8
                jsr     (a6)
                endm
                add.w   d5,d3
                bcc.s   loc_22F74
                lea     $40(a1),a1

loc_22F74:
                adda.w  d4,a1
                addq.w  #4,a2
                swap    d6
                dbf     d6,loc_22F56
                lea     $380(a2),a2
                swap    d7
                dbf     d7,loc_22F50
                rts
; ---------------------------------------------------------------------------

loc_22F8A:
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

loc_22FC0:
                cmpi.w  #$E000,d5
                bne.w   loc_23042
                lea     loc_23016(pc),a6
                moveq   #0,d3
                lsl.w   #6,d4
                move.w  #3-1,d7

loc_22FD4:
                swap    d7
                move.w  #$20-1,d6

loc_22FDA:
                swap    d6
                movea.l a1,a3
                movea.l a2,a4
                rept    9
                jsr     (a6)
                endm
                move.b  (a3),(a4)
                add.w   d5,d3
                bcc.s   loc_22FFC
                lea     $40(a1),a1

loc_22FFC:
                adda.w  d4,a1
                cmpa.l  a0,a1
                bhs.s   locret_23014
                addq.w  #4,a2
                swap    d6
                dbf     d6,loc_22FDA
                lea     $580(a2),a2
                swap    d7
                dbf     d7,loc_22FD4

locret_23014:
                rts
; ---------------------------------------------------------------------------

loc_23016:
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

loc_23042:
                cmpi.w  #$C000,d5
                bne.w   loc_230CC
                moveq   #0,d3
                lsl.w   #6,d4
                lea     loc_230AA(pc),a6
                move.w  #4-1,d7

loc_23056:
                swap    d7
                move.w  #$20-1,d6

loc_2305C:
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
                bcc.s   loc_23090
                lea     $40(a1),a1

loc_23090:
                adda.w  d4,a1
                cmpa.l  a0,a1
                bhs.s   locret_230A8
                addq.w  #4,a2
                swap    d6
                dbf     d6,loc_2305C
                lea     $580(a2),a2
                swap    d7
                dbf     d7,loc_23056

locret_230A8:
                rts
; ---------------------------------------------------------------------------

loc_230AA:
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

loc_230CC:
                cmpi.w  #$A000,d5
                bne.w   loc_23166
                moveq   #0,d3
                lsl.w   #6,d4
                lea     loc_23150(pc),a5
                lea     loc_23138(pc),a6
                move.w  #4-1,d7

loc_230E4:
                swap    d7
                move.w  #$20-1,d6

loc_230EA:
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
                bcc.s   loc_2311E
                lea     $40(a1),a1

loc_2311E:
                adda.w  d4,a1
                cmpa.l  a0,a1
                bhs.s   locret_23136
                addq.w  #4,a2
                swap    d6
                dbf     d6,loc_230EA
                lea     $780(a2),a2
                swap    d7
                dbf     d7,loc_230E4

locret_23136:
                rts
; ---------------------------------------------------------------------------

loc_23138:
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

loc_23150:
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

loc_23166:
                moveq   #0,d3
                lsl.w   #6,d4
                moveq   #4-1,d7

loc_2316C:
                move.w  #$20-1,d6

loc_23170:
                movea.l a1,a3
                movea.l a2,a4
                rept    16
                move.l  (a3)+,(a4)
                lea     $80(a4),a4
                endm
                add.w   d5,d3
                bcc.s   loc_231DC
                lea     $40(a1),a1

loc_231DC:
                adda.w  d4,a1
                addq.w  #4,a2
                dbf     d6,loc_23170
                lea     $780(a2),a2
                dbf     d7,loc_2316C
                rts
; ---------------------------------------------------------------------------
Map_ScaledArt:
                include "src/objects/shared/level_misc/mappings/scaled_art.s"
