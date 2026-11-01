; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace crane or linked child movement, indexed geometry, animation and synchronized state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_65360:
                bset    #3,$38(a0)
                move.b  #$40,$3C(a0)
                move.b  #1,$40(a0)
                bra.w   loc_65382
; ---------------------------------------------------------------------------

loc_65376:
                move.b  #-$40,$3C(a0)
                move.b  #-1,$40(a0)

loc_65382:
                lea     word_66536(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_653F2,(a0)
                move.b  $3C(a0),$26(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d1
                btst    #3,$38(a0)
                beq.s   loc_653AE
                addi.w  #$A,d1

loc_653AE:
                move.b  byte_653DE(pc,d1.w),$31(a0)
                cmpi.b  #$12,d0
                bne.s   loc_653C0
                bset    #2,$38(a0)

loc_653C0:
                move.w  d0,d1
                addi.b  #$10,d1
                add.b   d1,d1
                move.b  d1,$30(a0)
                lsl.w   #2,d0
                subi.w  #$48,d0
                neg.w   d0
                move.w  d0,$2E(a0)
                move.w  d0,$32(a0)
                rts
; ---------------------------------------------------------------------------
byte_653DE:
                dc.b    -$30
                dc.b    -$2C
                dc.b    -$28
                dc.b    -$20
                dc.b    -$18
                dc.b    -$C
                dc.b    -8
                dc.b    -4
                dc.b    0
                dc.b    $40
                dc.b    $30
                dc.b    $28
                dc.b    $20
                dc.b    $18
                dc.b    $10
                dc.b    8
                dc.b    -$10
                dc.b    -$18
                dc.b    -$20
                dc.b    -$40
                even
; ---------------------------------------------------------------------------

loc_653F2:
                subi.w  #1,$2E(a0)
                bmi.s   loc_65404
                bsr.w   HPZCraneAdvanceAngularOscillationAndReverseStep
                jmp     (MoveSprite_Circular).l
; ---------------------------------------------------------------------------

loc_65404:
                move.l  #loc_6540A,(a0)

loc_6540A:
                move.w  $3A(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$800,d0
                blo.s   loc_65432
                btst    #2,$38(a0)
                beq.s   loc_65426
                cmpi.w  #$C00,d0
                blo.s   loc_65432

loc_65426:
                move.l  #loc_65452,(a0)
                move.w  $32(a0),$2E(a0)

loc_65432:
                move.w  d0,$3A(a0)
                bsr.w   HPZCraneAdvanceAngularOscillationAndReverseStep
                jsr     (MoveSprite_Circular).l
                btst    #2,$38(a0)
                beq.s   loc_6544C
                bsr.w   HPZCraneSelectEightDirectionFrameFromPhase

loc_6544C:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_65452:
                bsr.w   HPZCraneAdvanceAngularOscillationAndReverseStep
                movea.w $44(a0),a1
                btst    #7,$38(a1)
                beq.s   loc_6546E
                subq.w  #1,$2E(a0)
                bpl.s   loc_6546E
                move.l  #loc_6549A,(a0)

loc_6546E:
                btst    #2,$38(a0)
                bne.s   loc_65484
                moveq   #5,d2
                jsr     (MoveSprite_CircularSimple).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_65484:
                bsr.w   HPZCraneSelectEightDirectionFrameFromPhase
                lea     (AngleLookup_1).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6549A:
                move.b  $3C(a0),d0
                moveq   #4,d1
                move.b  $31(a0),d2
                sub.b   d0,d2
                beq.s   loc_654C2
                sgt     d3
                bpl.s   loc_654AE
                neg.b   d2

loc_654AE:
                cmpi.b  #4,d2
                blo.s   loc_654C2
                tst.b   d3
                bne.s   loc_654BA
                neg.b   d1

loc_654BA:
                add.b   d1,d0
                move.b  d0,$3C(a0)
                bra.s   loc_6546E
; ---------------------------------------------------------------------------

loc_654C2:
                move.l  #loc_654E2,(a0)
                tst.b   subtype(a0)
                bne.s   loc_654E0
                movea.w $44(a0),a1
                moveq   #2,d0
                tst.b   subtype(a1)
                beq.s   loc_654DC
                moveq   #3,d0

loc_654DC:
                bset    d0,(_unkFAB8).w

loc_654E0:
                bra.s   loc_6546E
; ---------------------------------------------------------------------------

loc_654E2:
                btst    #4,(_unkFAB8).w
                beq.s   loc_654F6
                move.l  #loc_654FA,(a0)
                move.w  #60-1,$2E(a0)

loc_654F6:
                bra.w   loc_6546E
; ---------------------------------------------------------------------------

loc_654FA:
                btst    #2,$38(a0)
                bne.s   loc_6550E
                moveq   #5,d2
                jsr     (MoveSprite_CircularSimple).l
                bra.w   loc_65538
; ---------------------------------------------------------------------------

loc_6550E:
                moveq   #0,d0
                movea.w $44(a0),a1
                tst.b   subtype(a1)
                beq.s   loc_6551C
                addq.w  #2,d0

loc_6551C:
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_65526
                addq.w  #1,d0

loc_65526:
                move.b  RawAni_65550(pc,d0.w),mapping_frame(a0)
                lea     (AngleLookup_1).l,a2
                jsr     (MoveSprite_AtAngleLookup).l

loc_65538:
                subq.w  #1,$2E(a0)
                bpl.s   loc_6554A
                move.l  #loc_65554,(a0)
                move.w  $32(a0),$2E(a0)

loc_6554A:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
RawAni_65550:
                dc.b    $15, $1C, $19, $1B
                even
; ---------------------------------------------------------------------------

loc_65554:
                subq.w  #1,$2E(a0)
                bpl.s   loc_65560
                move.l  #loc_65564,(a0)

loc_65560:
                bra.w   loc_6546E
; ---------------------------------------------------------------------------

loc_65564:
                move.b  $3C(a0),d0
                moveq   #2,d1
                move.b  $26(a0),d2
                sub.b   d0,d2
                beq.s   loc_6558C
                sgt     d3
                bpl.s   loc_65578
                neg.b   d2

loc_65578:
                subq.b  #1,d2
                beq.s   loc_6558C
                tst.b   d3
                bne.s   loc_65582
                neg.b   d1

loc_65582:
                add.b   d1,d0
                move.b  d0,$3C(a0)
                bra.w   loc_6546E
; ---------------------------------------------------------------------------

loc_6558C:
                move.l  #loc_655AA,(a0)
                clr.b   $39(a0)
                moveq   #1,d0
                btst    #3,$38(a0)
                bne.s   loc_655A2
                neg.w   d0

loc_655A2:
                move.b  d0,$40(a0)
                bra.w   loc_6546E
; ---------------------------------------------------------------------------

loc_655AA:
                bsr.w   HPZCraneAdvanceAngularOscillationAndReverseStep
                bra.w   loc_6546E
; End of function loc_65360
