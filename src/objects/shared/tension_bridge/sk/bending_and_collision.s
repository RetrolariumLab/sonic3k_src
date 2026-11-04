; Owner: objects/shared/tension_bridge/sk
; Responsibility: Tension bridge segment bending, player collision, movement helpers and private bend data
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

CollapseTensionBridgeSpriteBank:
                lea     (byte_38A78).l,a4
                lea     sub2_x_pos(a3),a2
                move.w  mainspr_childsprites(a3),d6
                subq.w  #1,d6
                bclr    #6,render_flags(a3)
                movea.l a3,a1
                bra.s   loc_38A00
; ---------------------------------------------------------------------------

loc_389F8:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_38A64

loc_38A00:
                move.l  d4,(a1)
                move.l  mappings(a3),mappings(a1)
                move.b  render_flags(a3),render_flags(a1)
                move.w  art_tile(a3),art_tile(a1)
                move.w  priority(a3),priority(a1)
                move.b  width_pixels(a3),width_pixels(a1)
                move.b  height_pixels(a3),height_pixels(a1)
                move.w  priority(a3),priority(a1)
                move.w  (a2)+,x_pos(a1)
                move.w  (a2)+,y_pos(a1)
                move.w  (a2)+,d0
                move.b  d0,mapping_frame(a1)
                move.b  (a4)+,$34(a1)
                movea.l a1,a5
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_38A64
                move.l  #loc_1E6EC,(a1)
                move.w  x_pos(a5),x_pos(a1)
                move.w  y_pos(a5),y_pos(a1)
                move.b  -1(a4),$24(a1)
                dbf     d6,loc_389F8

loc_38A64:
                move.w  #0,sub2_x_pos(a3)
                move.w  #0,sub2_y_pos(a3)
                moveq   #signextendB(sfx_BridgeCollapse),d0
                jmp     (Play_SFX).l
; End of function CollapseTensionBridgeSpriteBank

; ---------------------------------------------------------------------------
byte_38A78:
                dc.b    8, $10,  $C,  $E,   6,  $A,   4,   2
                dc.b    8, $10,  $C,  $E,   6,  $A,   4,   2

; =============== S U B R O U T I N E =======================================

CollidePlayersWithTensionBridge:
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                moveq   #$3B,d5
                movem.l d1-d4,-(sp)
                bsr.s   CollidePlayerWithTensionBridge
                movem.l (sp)+,d1-d4
                lea     (Player_1).w,a1
                subq.b  #p2_standing_bit-p1_standing_bit,d6
                moveq   #$3F,d5
; End of function CollidePlayersWithTensionBridge

; =============== S U B R O U T I N E =======================================

CollidePlayerWithTensionBridge:
                btst    d6,status(a0)
                beq.s   loc_38B06
                btst    #Status_InAir,status(a1)
                bne.s   loc_38AC2
                moveq   #0,d0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_38AC2
                cmp.w   d2,d0
                blo.s   loc_38AD0

loc_38AC2:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_38AD0:
                lsr.w   #4,d0
                move.b  d0,(a0,d5.w)
                movea.l $30(a0),a2
                cmpi.w  #8,d0
                blo.s   loc_38AE8
                movea.l $34(a0),a2
                subi.w  #8,d0

loc_38AE8:
                add.w   d0,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                move.w  sub2_y_pos(a2,d0.w),d0
                subq.w  #8,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_38B06:
                move.w  d1,-(sp)
                jsr     (TryLandPlayerOnPlatformSpan).l
                move.w  (sp)+,d1
                btst    d6,status(a0)
                beq.s   locret_38B28
                moveq   #0,d0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                lsr.w   #4,d0
                move.b  d0,(a0,d5.w)

locret_38B28:
                rts
; End of function CollidePlayerWithTensionBridge

; =============== S U B R O U T I N E =======================================

CollidePlayersWithSlopedTensionBridge:
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                moveq   #$3B,d5
                movem.l d1-d4,-(sp)
                bsr.s   CollidePlayerWithSlopedTensionBridge
                movem.l (sp)+,d1-d4
                lea     (Player_1).w,a1
                subq.b  #p2_standing_bit-p1_standing_bit,d6
                moveq   #$3F,d5
; End of function CollidePlayersWithSlopedTensionBridge

; =============== S U B R O U T I N E =======================================

CollidePlayerWithSlopedTensionBridge:
                btst    d6,status(a0)
                beq.s   loc_38BA4
                btst    #Status_InAir,status(a1)
                bne.s   loc_38B64
                moveq   #0,d0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_38B64
                cmp.w   d2,d0
                blo.s   loc_38B72

loc_38B64:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_38B72:
                lsr.w   #4,d0
                movea.l $30(a0),a2
                cmpi.w  #8,d0
                blo.s   loc_38B86
                movea.l $34(a0),a2
                subi.w  #8,d0

loc_38B86:
                add.w   d0,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                move.w  sub2_y_pos(a2,d0.w),d0
                subq.w  #8,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_38BA4:
                bsr.s   TryLandPlayerOnSlopedTensionBridge
                rts
; End of function CollidePlayerWithSlopedTensionBridge

; =============== S U B R O U T I N E =======================================

TryLandPlayerOnSlopedTensionBridge:
                tst.w   y_vel(a1)
                bmi.s   locret_38BD6
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   locret_38BD6
                cmp.w   d2,d0
                bhs.s   locret_38BD6
                lsr.w   #4,d0
                move.w  d0,d3
                add.w   d0,d0
                add.w   d0,d3
                neg.w   d3
                addq.w  #8,d3
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                jmp     (SKCollision_LandAtCallerComputedTopWithinUnsignedPenetrationWindow).l
; ---------------------------------------------------------------------------

locret_38BD6:
                rts
; End of function TryLandPlayerOnSlopedTensionBridge

; =============== S U B R O U T I N E =======================================

CacheTensionBridgeRiderSegments:
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                moveq   #$3B,d5
                bsr.s   CacheTensionBridgeRiderSegment
                lea     (Player_1).w,a1
                subq.b  #p2_standing_bit-p1_standing_bit,d6
                moveq   #$3F,d5
; End of function CacheTensionBridgeRiderSegments

; =============== S U B R O U T I N E =======================================

CacheTensionBridgeRiderSegment:
                btst    d6,status(a0)
                beq.s   locret_38C10
                btst    #Status_InAir,status(a1)
                bne.s   locret_38C10
                moveq   #0,d0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   locret_38C10
                cmp.w   d2,d0
                bhs.s   locret_38C10
                lsr.w   #4,d0
                move.b  d0,(a0,d5.w)

locret_38C10:
                rts
; End of function CacheTensionBridgeRiderSegment

; =============== S U B R O U T I N E =======================================

AnimateTensionBridgeSegmentsUnderMovingRiders:
                movea.l $30(a0),a1
                lea     sub2_mapframe(a1),a1
                movea.l $34(a0),a2
                lea     sub2_mapframe(a2),a2
                moveq   #-2,d3
                moveq   #-2,d4
                move.b  status(a0),d0
                andi.w  #p1_standing,d0
                beq.s   loc_38C3E
                tst.w   (Player_1+x_vel).w
                beq.s   loc_38C3E
                move.b  $3F(a0),d0
                bsr.w   StartTensionBridgeSegmentAnimation

loc_38C3E:
                move.b  status(a0),d0
                andi.w  #p2_standing,d0
                beq.s   loc_38C56
                tst.w   (Player_2+x_vel).w
                beq.s   loc_38C56
                move.b  $3B(a0),d0
                bsr.w   StartTensionBridgeSegmentAnimation

loc_38C56:
                movea.l $30(a0),a1
                lea     $4D(a1),a2
                lea     sub2_mapframe(a1),a1
                moveq   #0,d1
                move.b  subtype(a0),d1
                subq.b  #1,d1

loc_38C6A:
                tst.b   (a1)
                beq.s   loc_38C7A
                addq.b  #1,(a1)
                cmpi.b  #$C,(a1)
                blo.s   loc_38C7A
                move.b  #0,(a1)

loc_38C7A:
                addq.w  #next_subspr,a1
                cmpa.w  a2,a1
                bne.s   loc_38C88
                movea.l $34(a0),a1
                lea     sub2_mapframe(a1),a1

loc_38C88:
                dbf     d1,loc_38C6A
                rts
; End of function AnimateTensionBridgeSegmentsUnderMovingRiders

; =============== S U B R O U T I N E =======================================

StartTensionBridgeSegmentAnimation:
                cmpi.b  #8,d0
                bhs.s   loc_38CAA
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                add.w   d0,d0
                tst.b   (a1,d0.w)
                bne.s   locret_38CA8
                move.b  #1,(a1,d0.w)

locret_38CA8:
                rts
; ---------------------------------------------------------------------------

loc_38CAA:
                subq.w  #8,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                add.w   d0,d0
                tst.b   (a2,d0.w)
                bne.s   locret_38CC0
                move.b  #1,(a2,d0.w)

locret_38CC0:
                rts
; End of function StartTensionBridgeSegmentAnimation

; =============== S U B R O U T I N E =======================================

BendTensionBridgeSegments:
                move.b  $3E(a0),d0
                jsr     (GetSineCosine).l
                move.w  d0,d4
                lea     (BridgeBendData).l,a4
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #4,d0
                moveq   #0,d3
                move.b  $3F(a0),d3
                move.w  d3,d2
                add.w   d0,d3
                moveq   #0,d5
                lea     (byte_38E2A-$80).l,a5
                move.b  (a5,d3.w),d5
                andi.w  #$F,d3
                lsl.w   #4,d3
                lea     (a4,d3.w),a3
                movea.l $30(a0),a1
                lea     next_object(a1),a2
                lea     sub2_y_pos(a1),a1

loc_38D08:
                moveq   #0,d0
                move.b  (a3)+,d0
                addq.w  #1,d0
                mulu.w  d5,d0
                mulu.w  d4,d0
                swap    d0
                add.w   $3C(a0),d0
                move.w  d0,(a1)
                addq.w  #next_subspr,a1
                cmpa.w  a2,a1
                bne.s   loc_38D28
                movea.l $34(a0),a1
                lea     sub2_y_pos(a1),a1

loc_38D28:
                dbf     d2,loc_38D08
                moveq   #0,d0
                move.b  subtype(a0),d0
                moveq   #0,d3
                move.b  $3F(a0),d3
                addq.b  #1,d3
                sub.b   d0,d3
                neg.b   d3
                bmi.s   locret_38D72
                move.w  d3,d2
                lsl.w   #4,d3
                lea     (a4,d3.w),a3
                adda.w  d2,a3
                subq.w  #1,d2
                bcs.s   locret_38D72

loc_38D4E:
                moveq   #0,d0
                move.b  -(a3),d0
                addq.w  #1,d0
                mulu.w  d5,d0
                mulu.w  d4,d0
                swap    d0
                add.w   $3C(a0),d0
                move.w  d0,(a1)
                addq.w  #next_subspr,a1
                cmpa.w  a2,a1
                bne.s   loc_38D6E
                movea.l $34(a0),a1
                lea     sub2_y_pos(a1),a1

loc_38D6E:
                dbf     d2,loc_38D4E

locret_38D72:
                rts
; End of function BendTensionBridgeSegments

; =============== S U B R O U T I N E =======================================

BendSlopedTensionBridgeSegments:
                move.b  $3E(a0),d0
                jsr     (GetSineCosine).l
                move.w  d0,d4
                lea     (BridgeBendData).l,a4
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #4,d0
                moveq   #0,d3
                move.b  $3F(a0),d3
                move.w  d3,d2
                add.w   d0,d3
                moveq   #0,d5
                lea     (byte_38E2A-$80).l,a5
                move.b  (a5,d3.w),d5
                andi.w  #$F,d3
                lsl.w   #4,d3
                lea     (a4,d3.w),a3
                move.w  $3C(a0),d6
                movea.l $30(a0),a1
                lea     next_object(a1),a2
                lea     sub2_y_pos(a1),a1

loc_38DBE:
                moveq   #0,d0
                move.b  (a3)+,d0
                addq.w  #1,d0
                mulu.w  d5,d0
                mulu.w  d4,d0
                swap    d0
                add.w   d6,d0
                addq.w  #3,d6
                move.w  d0,(a1)
                addq.w  #next_subspr,a1
                cmpa.w  a2,a1
                bne.s   loc_38DDE
                movea.l $34(a0),a1
                lea     sub2_y_pos(a1),a1

loc_38DDE:
                dbf     d2,loc_38DBE
                moveq   #0,d0
                move.b  subtype(a0),d0
                moveq   #0,d3
                move.b  $3F(a0),d3
                addq.b  #1,d3
                sub.b   d0,d3
                neg.b   d3
                bmi.s   locret_38E28
                move.w  d3,d2
                lsl.w   #4,d3
                lea     (a4,d3.w),a3
                adda.w  d2,a3
                subq.w  #1,d2
                bcs.s   locret_38E28

loc_38E04:
                moveq   #0,d0
                move.b  -(a3),d0
                addq.w  #1,d0
                mulu.w  d5,d0
                mulu.w  d4,d0
                swap    d0
                add.w   d6,d0
                addq.w  #3,d6
                move.w  d0,(a1)
                addq.w  #6,a1
                cmpa.w  a2,a1
                bne.s   loc_38E24
                movea.l $34(a0),a1
                lea     sub2_y_pos(a1),a1

loc_38E24:
                dbf     d2,loc_38E04

locret_38E28:
                rts
; End of function BendSlopedTensionBridgeSegments

; ---------------------------------------------------------------------------
byte_38E2A:
                dc.b    2,   4,   6,   8,   8,   6,   4,   2,   0,   0,   0,   0,   0,   0,   0,   0
                dc.b    2,   4,   6,   8,  $A,   8,   6,   4,   2,   0,   0,   0,   0,   0,   0,   0
                dc.b    2,   4,   6,   8,  $A,  $A,   8,   6,   4,   2,   0,   0,   0,   0,   0,   0
                dc.b    2,   4,   6,   8,  $A,  $C,  $A,   8,   6,   4,   2,   0,   0,   0,   0,   0
                dc.b    2,   4,   6,   8,  $A,  $C,  $C,  $A,   8,   6,   4,   2,   0,   0,   0,   0
                dc.b    2,   4,   6,   8,  $A,  $C,  $E,  $C,  $A,   8,   6,   4,   2,   0,   0,   0
                dc.b    2,   4,   6,   8,  $A,  $C,  $E,  $E,  $C,  $A,   8,   6,   4,   2,   0,   0
                dc.b    2,   4,   6,   8,  $A,  $C,  $E, $10,  $E,  $C,  $A,   8,   6,   4,   2,   0
                dc.b    2,   4,   6,   8,  $A,  $C,  $E, $10, $10,  $E,  $C,  $A,   8,   6,   4,   2
BridgeBendData:
                dc.b    $FF,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
                dc.b    $B5, $FF,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
                dc.b    $7E, $DB, $FF,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
                dc.b    $61, $B5, $EC, $FF,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
                dc.b    $4A, $93, $CD, $F3, $FF,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
                dc.b    $3E, $7E, $B0, $DB, $F6, $FF,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
                dc.b    $38, $6D, $9D, $C5, $E4, $F8, $FF,   0,   0,   0,   0,   0,   0,   0,   0,   0
                dc.b    $31, $61, $8E, $B5, $D4, $EC, $FB, $FF,   0,   0,   0,   0,   0,   0,   0,   0
                dc.b    $2B, $56, $7E, $A2, $C1, $DB, $EE, $FB, $FF,   0,   0,   0,   0,   0,   0,   0
                dc.b    $25, $4A, $73, $93, $B0, $CD, $E1, $F3, $FC, $FF,   0,   0,   0,   0,   0,   0
                dc.b    $1F, $44, $67, $88, $A7, $BD, $D4, $E7, $F4, $FD, $FF,   0,   0,   0,   0,   0
                dc.b    $1F, $3E, $5C, $7E, $98, $B0, $C9, $DB, $EA, $F6, $FD, $FF,   0,   0,   0,   0
                dc.b    $19, $38, $56, $73, $8E, $A7, $BD, $D1, $E1, $EE, $F8, $FE, $FF,   0,   0,   0
                dc.b    $19, $38, $50, $6D, $83, $9D, $B0, $C5, $D8, $E4, $F1, $F8, $FE, $FF,   0,   0
                dc.b    $19, $31, $4A, $67, $7E, $93, $A7, $BD, $CD, $DB, $E7, $F3, $F9, $FE, $FF,   0
                dc.b    $19, $31, $4A, $61, $78, $8E, $A2, $B5, $C5, $D4, $E1, $EC, $F4, $FB, $FE, $FF
