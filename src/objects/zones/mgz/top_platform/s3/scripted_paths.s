; Owner: objects/zones/mgz/top_platform/s3
; Responsibility: Marble Garden spinning top scripted loop entry, constrained path traversal and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

TryEnterTopPlatformScriptedSinePath:
                tst.w   (Debug_placement_mode).w
                bne.s   locret_34C5A
                tst.b   $34(a0)
                beq.s   locret_34C5A
                lea     (word_34D16).l,a1
                tst.b   (Current_act).w
                beq.s   loc_34C16
                lea     (word_34D88).l,a1

loc_34C16:
                move.w  (a1)+,d6
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3

loc_34C20:
                move.w  (a1),d0
                sub.w   d2,d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   loc_34C52
                move.w  2(a1),d1
                sub.w   d3,d1
                addi.w  #$10,d1
                cmpi.w  #$20,d1
                bhs.s   loc_34C52
                move.w  ground_vel(a0),d0
                move.b  4(a1),d2
                andi.b  #$7F,d2
                beq.s   loc_34C4E
                neg.w   d0

loc_34C4E:
                tst.w   d0
                bpl.s   loc_34C5C

loc_34C52:
                adda.w  #$10,a1
                dbf     d6,loc_34C20

locret_34C5A:
                rts
; ---------------------------------------------------------------------------

loc_34C5C:
                move.b  #1,$35(a0)
                move.w  4(a1),$3E(a0)
                addq.w  #6,a1
                move.w  (a1)+,d4
                move.w  d4,$30(a0)
                move.w  (a1)+,d5
                move.w  d5,d0
                move.b  $3F(a0),d1
                andi.b  #$7F,d1
                beq.s   loc_34C80
                sub.w   (a1),d0

loc_34C80:
                move.w  d0,$32(a0)
                move.l  a1,$36(a0)
                move.w  ground_vel(a0),d2
                bpl.s   loc_34C90
                neg.w   d2

loc_34C90:
                tst.w   d2
                bne.s   loc_34C98
                move.w  #$800,d2

loc_34C98:
                moveq   #0,d0
                move.w  d2,d3
                move.w  d4,d0
                sub.w   x_pos(a0),d0
                bge.s   loc_34CA8
                neg.w   d0
                neg.w   d2

loc_34CA8:
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a0),d1
                bge.s   loc_34CB6
                neg.w   d1
                neg.w   d3

loc_34CB6:
                cmp.w   d0,d1
                blo.s   loc_34CE8
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a0),d1
                swap    d1
                divs.w  d3,d1
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a0),d0
                beq.s   loc_34CD4
                swap    d0
                divs.w  d1,d0

loc_34CD4:
                move.w  d0,x_vel(a0)
                move.w  d3,y_vel(a0)
                tst.w   d1
                bpl.s   loc_34CE2
                neg.w   d1

loc_34CE2:
                move.w  d1,$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_34CE8:
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a0),d0
                swap    d0
                divs.w  d2,d0
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a0),d1
                beq.s   loc_34D02
                swap    d1
                divs.w  d0,d1

loc_34D02:
                move.w  d1,y_vel(a0)
                move.w  d2,x_vel(a0)
                tst.w   d0
                bpl.s   loc_34D10
                neg.w   d0

loc_34D10:
                move.w  d0,$3A(a0)
                rts
; End of function TryEnterTopPlatformScriptedSinePath

; ---------------------------------------------------------------------------
word_34D16:     dc.w    7-1
                dc.w    $1BA0,   $C6,     0, $1C40,   $E6,  $280, $1CE0,  $385
                dc.w    $1BA0,  $3C4, $8001, $1C40,  $3A6,  $2C0, $1BA0,   $C6
                dc.w    $1CE0,  $385,  $101, $1C40,  $366,  $280, $1BA0,   $C6
                dc.w    $2720,  $846,     0, $27C0,  $866,  $200, $2860,  $A86
                dc.w    $2860,  $846,  $180, $27C0,  $866,  $200, $2720,  $A86
                dc.w    $2720,  $A86,   $81, $27C0,  $A66,  $200, $2860,  $846
                dc.w    $2860,  $A86,  $101, $27C0,  $A66,  $200, $2720,  $846
word_34D88:     dc.w    7-1
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
                beq.s   loc_34E72
                subq.b  #1,$3A(a0)
                bpl.s   loc_34E3A
                cmpi.b  #3,$35(a0)
                beq.s   loc_34E60
                move.w  #0,$3C(a0)
                move.b  #2,$35(a0)
                movea.l $36(a0),a1
                move.w  (a1)+,d0
                move.w  d0,$2E(a0)
                move.b  $3F(a0),d1
                andi.b  #$7F,d1
                beq.s   loc_34E34
                move.w  d0,$3C(a0)

loc_34E34:
                move.l  a1,$36(a0)
                bra.s   loc_34E72
; ---------------------------------------------------------------------------

loc_34E3A:
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

loc_34E60:
                tst.b   $3E(a0)
                bpl.s   loc_34E6A
                neg.w   ground_vel(a0)

loc_34E6A:
                move.b  #0,$35(a0)
                rts
; ---------------------------------------------------------------------------

loc_34E72:
                move.w  $3C(a0),d0
                add.w   d0,d0
                tst.b   $3F(a0)
                bpl.s   loc_34E80
                neg.w   d0

loc_34E80:
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
                bpl.s   loc_34EAA
                neg.w   d0

loc_34EAA:
                cmpi.w  #$C00,d0
                bne.s   loc_34EB2
                moveq   #3,d1

loc_34EB2:
                move.b  $3F(a0),d0
                andi.b  #$7F,d0
                beq.s   loc_34EC4
                sub.w   d1,$3C(a0)
                bgt.s   locret_34EF4
                bra.s   loc_34ED2
; ---------------------------------------------------------------------------

loc_34EC4:
                add.w   d1,$3C(a0)
                move.w  $2E(a0),d0
                cmp.w   $3C(a0),d0
                bhi.s   locret_34EF4

loc_34ED2:
                move.b  #3,$35(a0)
                movea.l $36(a0),a2
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  ground_vel(a0),d2
                bpl.s   loc_34EE8
                neg.w   d2

loc_34EE8:
                tst.w   d2
                bne.s   loc_34EF0
                move.w  #$800,d2

loc_34EF0:
                bra.w   loc_34C98
; ---------------------------------------------------------------------------

locret_34EF4:
                rts
; End of function UpdateTopPlatformScriptedSinePath

; ---------------------------------------------------------------------------
Map_MGZTopPlatform:
                include "src/objects/shared/zones/mgz/mappings/top_platform.s"
