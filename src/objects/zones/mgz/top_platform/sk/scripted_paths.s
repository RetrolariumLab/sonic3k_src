; Owner: objects/zones/mgz/top_platform/sk
; Responsibility: Marble Garden spinning top scripted loop entry, constrained path traversal and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

TryEnterTopPlatformScriptedSinePath:
                tst.w   (Debug_placement_mode).w
                bne.s   locret_356C8
                tst.b   $34(a0)
                beq.s   locret_356C8
                lea     (word_35784).l,a1
                tst.b   (Current_act).w
                beq.s   loc_35684
                lea     (word_357F6).l,a1

loc_35684:
                move.w  (a1)+,d6
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3

loc_3568E:
                move.w  (a1),d0
                sub.w   d2,d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   loc_356C0
                move.w  2(a1),d1
                sub.w   d3,d1
                addi.w  #$10,d1
                cmpi.w  #$20,d1
                bhs.s   loc_356C0
                move.w  ground_vel(a0),d0
                move.b  4(a1),d2
                andi.b  #$7F,d2
                beq.s   loc_356BC
                neg.w   d0

loc_356BC:
                tst.w   d0
                bpl.s   loc_356CA

loc_356C0:
                adda.w  #$10,a1
                dbf     d6,loc_3568E

locret_356C8:
                rts
; ---------------------------------------------------------------------------

loc_356CA:
                move.b  #1,$35(a0)
                move.w  4(a1),$3E(a0)
                addq.w  #6,a1
                move.w  (a1)+,d4
                move.w  d4,$30(a0)
                move.w  (a1)+,d5
                move.w  d5,d0
                move.b  $3F(a0),d1
                andi.b  #$7F,d1
                beq.s   loc_356EE
                sub.w   (a1),d0

loc_356EE:
                move.w  d0,$32(a0)
                move.l  a1,$36(a0)
                move.w  ground_vel(a0),d2
                bpl.s   loc_356FE
                neg.w   d2

loc_356FE:
                tst.w   d2
                bne.s   loc_35706
                move.w  #$800,d2

loc_35706:
                moveq   #0,d0
                move.w  d2,d3
                move.w  d4,d0
                sub.w   x_pos(a0),d0
                bge.s   loc_35716
                neg.w   d0
                neg.w   d2

loc_35716:
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a0),d1
                bge.s   loc_35724
                neg.w   d1
                neg.w   d3

loc_35724:
                cmp.w   d0,d1
                blo.s   loc_35756
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a0),d1
                swap    d1
                divs.w  d3,d1
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a0),d0
                beq.s   loc_35742
                swap    d0
                divs.w  d1,d0

loc_35742:
                move.w  d0,x_vel(a0)
                move.w  d3,y_vel(a0)
                tst.w   d1
                bpl.s   loc_35750
                neg.w   d1

loc_35750:
                move.w  d1,$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_35756:
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a0),d0
                swap    d0
                divs.w  d2,d0
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a0),d1
                beq.s   loc_35770
                swap    d1
                divs.w  d0,d1

loc_35770:
                move.w  d1,y_vel(a0)
                move.w  d2,x_vel(a0)
                tst.w   d0
                bpl.s   loc_3577E
                neg.w   d0

loc_3577E:
                move.w  d0,$3A(a0)
                rts
; End of function TryEnterTopPlatformScriptedSinePath

; ---------------------------------------------------------------------------
word_35784:     dc.w    7-1
                dc.w    $1BA0,   $C6,     0, $1C40,   $E6,  $280, $1CE0,  $385
                dc.w    $1BA0,  $3C4, $8001, $1C40,  $3A6,  $2C0, $1BA0,   $C6
                dc.w    $1CE0,  $385,  $101, $1C40,  $366,  $280, $1BA0,   $C6
                dc.w    $2720,  $846,     0, $27C0,  $866,  $200, $2860,  $A86
                dc.w    $2860,  $846,  $180, $27C0,  $866,  $200, $2720,  $A86
                dc.w    $2720,  $A86,   $81, $27C0,  $A66,  $200, $2860,  $846
                dc.w    $2860,  $A86,  $101, $27C0,  $A66,  $200, $2720,  $846
word_357F6:     dc.w    7-1
                dc.w    $1760,  $546, $8180, $16C0,  $566,  $140, $1760,  $6C5
                dc.w    $1760,  $6C5, $8181, $16C0,  $6A6,  $140, $1760,  $546
                dc.w    $1620,  $6C4,   $81, $16C0,  $6C6,  $180, $1760,  $546
                dc.w    $2AA0,  $444, $8000, $2B40,  $466,  $2C0, $2AA0,  $744
                dc.w    $2BE0,  $446, $8180, $2B40,  $466,  $2C0, $2BE0,  $746
                dc.w    $2AA0,  $744, $8001, $2B40,  $726,  $2C0, $2AA0,  $444
                dc.w    $2BE0,  $746, $8181, $2B40,  $726,  $2C0, $2BE0,  $446

; =============== S U B R O U T I N E =======================================

UpdateTopPlatformScriptedSinePath:
                cmpi.b  #2,$35(a0)
                beq.s   loc_358E0
                subq.b  #1,$3A(a0)
                bpl.s   loc_358A8
                cmpi.b  #3,$35(a0)
                beq.s   loc_358CE
                move.w  #0,$3C(a0)
                move.b  #2,$35(a0)
                movea.l $36(a0),a1
                move.w  (a1)+,d0
                move.w  d0,$2E(a0)
                move.b  $3F(a0),d1
                andi.b  #$7F,d1
                beq.s   loc_358A2
                move.w  d0,$3C(a0)

loc_358A2:
                move.l  a1,$36(a0)
                bra.s   loc_358E0
; ---------------------------------------------------------------------------

loc_358A8:
                move.l  x_pos(a0),d2
                move.l  y_pos(a0),d3
                move.w  x_vel(a0),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d2
                move.w  y_vel(a0),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d2,x_pos(a0)
                move.l  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_358CE:
                tst.b   $3E(a0)
                bpl.s   loc_358D8
                neg.w   ground_vel(a0)

loc_358D8:
                move.b  #0,$35(a0)
                rts
; ---------------------------------------------------------------------------

loc_358E0:
                move.w  $3C(a0),d0
                add.w   d0,d0
                tst.b   $3F(a0)
                bpl.s   loc_358EE
                neg.w   d0

loc_358EE:
                jsr     (GetSineCosine).l
                muls.w  #$5800,d0
                swap    d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                move.w  $32(a0),d0
                add.w   $3C(a0),d0
                move.w  d0,y_pos(a0)
                moveq   #2,d1
                move.w  ground_vel(a0),d0
                bpl.s   loc_35918
                neg.w   d0

loc_35918:
                cmpi.w  #$C00,d0
                bne.s   loc_35920
                moveq   #3,d1

loc_35920:
                move.b  $3F(a0),d0
                andi.b  #$7F,d0
                beq.s   loc_35932
                sub.w   d1,$3C(a0)
                bgt.s   locret_35962
                bra.s   loc_35940
; ---------------------------------------------------------------------------

loc_35932:
                add.w   d1,$3C(a0)
                move.w  $2E(a0),d0
                cmp.w   $3C(a0),d0
                bhi.s   locret_35962

loc_35940:
                move.b  #3,$35(a0)
                movea.l $36(a0),a2
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  ground_vel(a0),d2
                bpl.s   loc_35956
                neg.w   d2

loc_35956:
                tst.w   d2
                bne.s   loc_3595E
                move.w  #$800,d2

loc_3595E:
                bra.w   loc_35706
; ---------------------------------------------------------------------------

locret_35962:
                rts
; End of function UpdateTopPlatformScriptedSinePath

; ---------------------------------------------------------------------------
Map_MGZTopPlatform:
                include "src/objects/shared/zones/mgz/mappings/top_platform.s"
