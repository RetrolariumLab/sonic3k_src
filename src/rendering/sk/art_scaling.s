; Owner: rendering/sk
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
                move.w  #bytesToXcnt(H_scroll_buffer-Kos_decomp_buffer,$100),d1

                .loop:
                rept    10
                movem.l a0-a5,-(a6)
                endm
                movem.l a0-a3,-(a6)
                dbf     d1,.loop
                rts
; End of function Init_ArtScaling

; ---------------------------------------------------------------------------
word_2464A:
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

sub_2468A:
                moveq   #0,d1
                move.b  $40(a0),d1
                cmpi.b  #$1C,d1
                blo.s   loc_2469A
                move.b  #$1C,d1                         ; Maximum 28 different "scales"

loc_2469A:
                move.b  d1,mapping_frame(a0)            ; Scale level correlates with mapping frame
                add.w   d1,d1
                move.w  word_2464A(pc,d1.w),d1
                move.w  (_unkF740).w,d2
                add.w   d1,d2
                cmpi.w  #$80,d2
                bhi.s   loc_246D2
                sub.w   d1,d2
                movem.l d1/d5-a0/a2/a4,-(sp)
                lea     (Kos_decomp_buffer).w,a2
                add.w   d2,d0
                move.w  d0,art_tile(a0)
                lsl.w   #5,d2
                adda.w  d2,a2
                bsr.s   sub_246DA
                movem.l (sp)+,d1/d5-a0/a2/a4
                add.w   d1,(_unkF740).w
                rts
; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------

loc_246D2:
                bclr    #7,render_flags(a0)
                rts
; End of function sub_2468A

; =============== S U B R O U T I N E =======================================

sub_246DA:
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
                beq.w   loc_249BA                       ; If modified scale factor smaller than 8, branch
                cmpi.w  #1,d4
                bne.s   loc_2472A                       ; If modified scale factor is not between 8-$10, branch
                tst.w   d5
                beq.w   loc_2493E                       ; If modified scale factor is 8, branch
                cmpi.w  #$2000,d5
                beq.w   loc_248B8                       ; If modified scale factor is 9, branch

loc_2472A:
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
                lea     loc_2479C(pc),a6

loc_2474A:
                move.w  #$20-1,d7

loc_2474E:
                swap    d7
                swap    d3
                move.w  #0,d2
                move.w  #0,d3
                movea.l a2,a4
                move.w  a5,d6
                bmi.s   loc_24770

loc_24760:
                swap    d6
                jsr     (a6)
                swap    d6
                dbf     d6,loc_24760
                cmpi.w  #$40,d2
                bhs.s   loc_24778

loc_24770:
                swap    d6
                jsr     sub_24802(pc)
                swap    d6

loc_24778:
                swap    d3
                add.w   d5,d3
                bcc.s   loc_24782
                adda.w  #$40,a1

loc_24782:
                move.w  d4,d0
                lsl.w   #6,d0
                adda.w  d0,a1
                cmpa.l  a0,a1
                bhs.s   locret_2479A
                addq.w  #4,a2
                swap    d7
                dbf     d7,loc_2474E
                lea     $380(a2),a2
                bra.s   loc_2474A
; ---------------------------------------------------------------------------

locret_2479A:
                rts
; ---------------------------------------------------------------------------

loc_2479C:
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

sub_24802:
                rept    4
                move.b  (a1,d2.w),d0
                add.w   d5,d3
                addx.w  d4,d2
                cmpi.w  #$40,d2
                blo.s   loc_24814
                move.b  #0,d0

loc_24814:
                move.b  (a1,d2.w),d1
                add.w   d5,d3
                addx.w  d4,d2
                cmpi.w  #$40,d2
                blo.s   loc_24826
                move.b  #0,d1

loc_24826:
                and.b   d6,d0
                and.b   d7,d1
                or.b    d1,d0
                move.b  d0,(a4)+
                endm
                lea     $7C(a4),a4
                rts
; End of function sub_24802

; ---------------------------------------------------------------------------

loc_248B8:
                moveq   #0,d3
                lsl.w   #6,d4
                lea     loc_24906(pc),a6
                move.w  #2-1,d7

loc_248C4:
                swap    d7
                move.w  #$20-1,d6

loc_248CA:
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
                bcc.s   loc_248EC
                lea     $40(a1),a1

loc_248EC:
                adda.w  d4,a1
                cmpa.l  a0,a1
                bhs.s   locret_24904
                addq.w  #4,a2
                swap    d6
                dbf     d6,loc_248CA
                lea     $380(a2),a2
                swap    d7
                dbf     d7,loc_248C4

locret_24904:
                rts
; ---------------------------------------------------------------------------

loc_24906:
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

loc_2493E:
                moveq   #0,d3
                lsl.w   #6,d4
                lea     loc_24984(pc),a6
                move.w  #2-1,d7

loc_2494A:
                swap    d7
                move.w  #$20-1,d6

loc_24950:
                swap    d6
                movea.l a1,a3
                movea.l a2,a4
                rept    8
                jsr     (a6)
                endm
                add.w   d5,d3
                bcc.s   loc_2496E
                lea     $40(a1),a1

loc_2496E:
                adda.w  d4,a1
                addq.w  #4,a2
                swap    d6
                dbf     d6,loc_24950
                lea     $380(a2),a2
                swap    d7
                dbf     d7,loc_2494A
                rts
; ---------------------------------------------------------------------------

loc_24984:
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

loc_249BA:
                cmpi.w  #$E000,d5
                bne.w   loc_24A3C
                lea     loc_24A10(pc),a6
                moveq   #0,d3
                lsl.w   #6,d4
                move.w  #3-1,d7

loc_249CE:
                swap    d7
                move.w  #$20-1,d6

loc_249D4:
                swap    d6
                movea.l a1,a3
                movea.l a2,a4
                rept    9
                jsr     (a6)
                endm
                move.b  (a3),(a4)
                add.w   d5,d3
                bcc.s   loc_249F6
                lea     $40(a1),a1

loc_249F6:
                adda.w  d4,a1
                cmpa.l  a0,a1
                bhs.s   locret_24A0E
                addq.w  #4,a2
                swap    d6
                dbf     d6,loc_249D4
                lea     $580(a2),a2
                swap    d7
                dbf     d7,loc_249CE

locret_24A0E:
                rts
; ---------------------------------------------------------------------------

loc_24A10:
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

loc_24A3C:
                cmpi.w  #$C000,d5
                bne.w   loc_24AC6
                moveq   #0,d3
                lsl.w   #6,d4
                lea     loc_24AA4(pc),a6
                move.w  #4-1,d7

loc_24A50:
                swap    d7
                move.w  #$20-1,d6

loc_24A56:
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
                bcc.s   loc_24A8A
                lea     $40(a1),a1

loc_24A8A:
                adda.w  d4,a1
                cmpa.l  a0,a1
                bhs.s   locret_24AA2
                addq.w  #4,a2
                swap    d6
                dbf     d6,loc_24A56
                lea     $580(a2),a2
                swap    d7
                dbf     d7,loc_24A50

locret_24AA2:
                rts
; ---------------------------------------------------------------------------

loc_24AA4:
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

loc_24AC6:
                cmpi.w  #$A000,d5
                bne.w   loc_24B60
                moveq   #0,d3
                lsl.w   #6,d4
                lea     loc_24B4A(pc),a5
                lea     loc_24B32(pc),a6
                move.w  #4-1,d7

loc_24ADE:
                swap    d7
                move.w  #$20-1,d6

loc_24AE4:
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
                bcc.s   loc_24B18
                lea     $40(a1),a1

loc_24B18:
                adda.w  d4,a1
                cmpa.l  a0,a1
                bhs.s   locret_24B30
                addq.w  #4,a2
                swap    d6
                dbf     d6,loc_24AE4
                lea     $780(a2),a2
                swap    d7
                dbf     d7,loc_24ADE

locret_24B30:
                rts
; ---------------------------------------------------------------------------

loc_24B32:
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

loc_24B4A:
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

loc_24B60:
                moveq   #0,d3
                lsl.w   #6,d4
                moveq   #4-1,d7

loc_24B66:
                move.w  #$20-1,d6

loc_24B6A:
                movea.l a1,a3
                movea.l a2,a4
                rept    16
                move.l  (a3)+,(a4)
                lea     $80(a4),a4
                endm
                add.w   d5,d3
                bcc.s   loc_24BD6
                lea     $40(a1),a1

loc_24BD6:
                adda.w  d4,a1
                addq.w  #4,a2
                dbf     d6,loc_24B6A
                lea     $780(a2),a2
                dbf     d7,loc_24B66
                rts
; ---------------------------------------------------------------------------
Map_ScaledArt:
                include "src/objects/shared/level_misc/mappings/scaled_art.s"
