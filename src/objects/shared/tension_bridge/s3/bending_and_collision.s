; Owner: objects/shared/tension_bridge/s3
; Responsibility: Tension bridge segment bending, player collision, movement helpers and private bend data
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

CollapseTensionBridgeSpriteBank:
                lea     (S3TensionBridge_CollapsePieceDelayBytes).l,a4
                lea     sub2_x_pos(a3),a2
                move.w  mainspr_childsprites(a3),d6
                subq.w  #1,d6
                bclr    #6,render_flags(a3)
                movea.l a3,a1
                bra.s   S3TensionBridge_InitPieceAndTryExplosion
; ---------------------------------------------------------------------------

S3TensionBridge_TryNextCollapsePiece:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3TensionBridge_FinishPartialCollapse

S3TensionBridge_InitPieceAndTryExplosion:
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
                bne.s   S3TensionBridge_FinishPartialCollapse
                move.l  #S3Explosion_InitHighPriorityDelayed,(a1)
                move.w  x_pos(a5),x_pos(a1)
                move.w  y_pos(a5),y_pos(a1)
                move.b  -1(a4),$24(a1)
                dbf     d6,S3TensionBridge_TryNextCollapsePiece

; Clear the two reused sub-sprite coordinate words before requesting the collapse sound
S3TensionBridge_FinishPartialCollapse:
                move.w  #0,sub2_x_pos(a3)
                move.w  #0,sub2_y_pos(a3)
                moveq   #signextendB(sfx_BridgeCollapse),d0
                jmp     (Play_SFX).l
; End of function CollapseTensionBridgeSpriteBank

; ---------------------------------------------------------------------------
S3TensionBridge_CollapsePieceDelayBytes:
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
                beq.s   S3TensionBridge_TryFlatLandingAndCache
                btst    #Status_InAir,status(a1)
                bne.s   S3TensionBridge_ReleaseFlatRider
                moveq   #0,d0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3TensionBridge_ReleaseFlatRider
                cmp.w   d2,d0
                blo.s   S3TensionBridge_CacheFlatBinAndPickBank

S3TensionBridge_ReleaseFlatRider:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

; Index 16-pixel segments. The second sprite bank starts at segment 8
S3TensionBridge_CacheFlatBinAndPickBank:
                lsr.w   #4,d0
                move.b  d0,(a0,d5.w)
                movea.l $30(a0),a2
                cmpi.w  #8,d0
                blo.s   S3TensionBridge_SnapFlatRiderToSegment
                movea.l $34(a0),a2
                subi.w  #8,d0

S3TensionBridge_SnapFlatRiderToSegment:
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

S3TensionBridge_TryFlatLandingAndCache:
                move.w  d1,-(sp)
                jsr     (TryLandPlayerOnPlatformSpan).l
                move.w  (sp)+,d1
                btst    d6,status(a0)
                beq.s   S3TensionBridge_FlatLandingReturn
                moveq   #0,d0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                lsr.w   #4,d0
                move.b  d0,(a0,d5.w)

S3TensionBridge_FlatLandingReturn:
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
                beq.s   S3TensionBridge_TryNewSlopedLanding
                btst    #Status_InAir,status(a1)
                bne.s   S3TensionBridge_ReleaseSlopedRider
                moveq   #0,d0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3TensionBridge_ReleaseSlopedRider
                cmp.w   d2,d0
                blo.s   S3TensionBridge_PickSlopedRiderBank

S3TensionBridge_ReleaseSlopedRider:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

; Select the bank from the current rider bin and leave the cached bend index untouched
S3TensionBridge_PickSlopedRiderBank:
                lsr.w   #4,d0
                movea.l $30(a0),a2
                cmpi.w  #8,d0
                blo.s   S3TensionBridge_SnapSlopedRiderToSegment
                movea.l $34(a0),a2
                subi.w  #8,d0

S3TensionBridge_SnapSlopedRiderToSegment:
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

S3TensionBridge_TryNewSlopedLanding:
                bsr.s   TryLandPlayerOnSlopedTensionBridge
                rts
; End of function CollidePlayerWithSlopedTensionBridge

; =============== S U B R O U T I N E =======================================

TryLandPlayerOnSlopedTensionBridge:
                tst.w   y_vel(a1)
                bmi.s   S3TensionBridge_RejectSlopedLanding
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3TensionBridge_RejectSlopedLanding
                cmp.w   d2,d0
                bhs.s   S3TensionBridge_RejectSlopedLanding
                lsr.w   #4,d0
                move.w  d0,d3
                add.w   d0,d0
                add.w   d0,d3
                neg.w   d3
                addq.w  #8,d3
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                jmp     (S3Platform_CheckTopAndSnapRider).l
; ---------------------------------------------------------------------------

; Return with the original predicate flags from the rejected landing test
S3TensionBridge_RejectSlopedLanding:
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
                beq.s   S3TensionBridge_RiderCacheProbeReturn
                btst    #Status_InAir,status(a1)
                bne.s   S3TensionBridge_RiderCacheProbeReturn
                moveq   #0,d0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   S3TensionBridge_RiderCacheProbeReturn
                cmp.w   d2,d0
                bhs.s   S3TensionBridge_RiderCacheProbeReturn
                lsr.w   #4,d0
                move.b  d0,(a0,d5.w)

; Leave the old cached index when the rider fails this probe
S3TensionBridge_RiderCacheProbeReturn:
                rts
; End of function CacheTensionBridgeRiderSegment

; =============== S U B R O U T I N E =======================================

TensionBridge_AnimateRiddenBoards:
                movea.l $30(a0),a1
                lea     sub2_mapframe(a1),a1
                movea.l $34(a0),a2
                lea     sub2_mapframe(a2),a2
                moveq   #-2,d3
                moveq   #-2,d4
                move.b  status(a0),d0
                andi.w  #p1_standing,d0
                beq.s   S3TensionBridge_TryAnimateP2Segment
                tst.w   (Player_1+x_vel).w
                beq.s   S3TensionBridge_TryAnimateP2Segment
                move.b  $3F(a0),d0
                bsr.w   StartTensionBridgeSegmentAnimation

S3TensionBridge_TryAnimateP2Segment:
                move.b  status(a0),d0
                andi.w  #p2_standing,d0
                beq.s   S3TensionBridge_InitSegmentFrameLoop
                tst.w   (Player_2+x_vel).w
                beq.s   S3TensionBridge_InitSegmentFrameLoop
                move.b  $3B(a0),d0
                bsr.w   StartTensionBridgeSegmentAnimation

S3TensionBridge_InitSegmentFrameLoop:
                movea.l $30(a0),a1
                lea     $4D(a1),a2
                lea     sub2_mapframe(a1),a1
                moveq   #0,d1
                move.b  subtype(a0),d1
                subq.b  #1,d1

S3TensionBridge_TickActiveFrameTo12:
                tst.b   (a1)
                beq.s   S3TensionBridge_NextFrameSlotOrBank
                addq.b  #1,(a1)
                cmpi.b  #$C,(a1)
                blo.s   S3TensionBridge_NextFrameSlotOrBank
                move.b  #0,(a1)

; Switch to the second sprite bank after the eighth first-bank slot
S3TensionBridge_NextFrameSlotOrBank:
                addq.w  #next_subspr,a1
                cmpa.w  a2,a1
                bne.s   S3TensionBridge_RepeatSegmentFrameTick
                movea.l $34(a0),a1
                lea     sub2_mapframe(a1),a1

; The original loop count comes from the subtype byte
S3TensionBridge_RepeatSegmentFrameTick:
                dbf     d1,S3TensionBridge_TickActiveFrameTo12
                rts
; End of function TensionBridge_AnimateRiddenBoards

; =============== S U B R O U T I N E =======================================

StartTensionBridgeSegmentAnimation:
                cmpi.b  #8,d0
                bhs.s   S3TensionBridge_TryStartSecondBankAnim
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                add.w   d0,d0
                tst.b   (a1,d0.w)
                bne.s   S3TensionBridge_FirstBankAnimReturn
                move.b  #1,(a1,d0.w)

S3TensionBridge_FirstBankAnimReturn:
                rts
; ---------------------------------------------------------------------------

S3TensionBridge_TryStartSecondBankAnim:
                subq.w  #8,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                add.w   d0,d0
                tst.b   (a2,d0.w)
                bne.s   S3TensionBridge_SecondBankAnimReturn
                move.b  #1,(a2,d0.w)

S3TensionBridge_SecondBankAnimReturn:
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
                lea     (S3TensionBridge_BendAmplitudeRows-$80).l,a5
                move.b  (a5,d3.w),d5
                andi.w  #$F,d3
                lsl.w   #4,d3
                lea     (a4,d3.w),a3
                movea.l $30(a0),a1
                lea     next_object(a1),a2
                lea     sub2_y_pos(a1),a1

S3TensionBridge_WriteFlatForwardSample:
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
                bne.s   S3TensionBridge_FinishFlatForwardPass
                movea.l $34(a0),a1
                lea     sub2_y_pos(a1),a1

S3TensionBridge_FinishFlatForwardPass:
                dbf     d2,S3TensionBridge_WriteFlatForwardSample
                moveq   #0,d0
                move.b  subtype(a0),d0
                moveq   #0,d3
                move.b  $3F(a0),d3
                addq.b  #1,d3
                sub.b   d0,d3
                neg.b   d3
                bmi.s   S3TensionBridge_FlatBendReturn
                move.w  d3,d2
                lsl.w   #4,d3
                lea     (a4,d3.w),a3
                adda.w  d2,a3
                subq.w  #1,d2
                bcs.s   S3TensionBridge_FlatBendReturn

S3TensionBridge_WriteFlatReverseSample:
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
                bne.s   S3TensionBridge_RepeatFlatReversePass
                movea.l $34(a0),a1
                lea     sub2_y_pos(a1),a1

; Return with the loop's existing condition codes
S3TensionBridge_RepeatFlatReversePass:
                dbf     d2,S3TensionBridge_WriteFlatReverseSample

S3TensionBridge_FlatBendReturn:
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
                lea     (S3TensionBridge_BendAmplitudeRows-$80).l,a5
                move.b  (a5,d3.w),d5
                andi.w  #$F,d3
                lsl.w   #4,d3
                lea     (a4,d3.w),a3
                move.w  $3C(a0),d6
                movea.l $30(a0),a1
                lea     next_object(a1),a2
                lea     sub2_y_pos(a1),a1

S3TensionBridge_WriteSlopeForwardSample:
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
                bne.s   S3TensionBridge_FinishSlopeForwardPass
                movea.l $34(a0),a1
                lea     sub2_y_pos(a1),a1

S3TensionBridge_FinishSlopeForwardPass:
                dbf     d2,S3TensionBridge_WriteSlopeForwardSample
                moveq   #0,d0
                move.b  subtype(a0),d0
                moveq   #0,d3
                move.b  $3F(a0),d3
                addq.b  #1,d3
                sub.b   d0,d3
                neg.b   d3
                bmi.s   S3TensionBridge_SlopeBendReturn
                move.w  d3,d2
                lsl.w   #4,d3
                lea     (a4,d3.w),a3
                adda.w  d2,a3
                subq.w  #1,d2
                bcs.s   S3TensionBridge_SlopeBendReturn

S3TensionBridge_WriteSlopeReverseSample:
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
                bne.s   S3TensionBridge_RepeatSlopeReversePass
                movea.l $34(a0),a1
                lea     sub2_y_pos(a1),a1

; Carry the running word baseline from one segment to the next
S3TensionBridge_RepeatSlopeReversePass:
                dbf     d2,S3TensionBridge_WriteSlopeReverseSample

S3TensionBridge_SlopeBendReturn:
                rts
; End of function BendSlopedTensionBridgeSegments

; ---------------------------------------------------------------------------
; The rows cover bridge lengths from eight through sixteen segments
S3TensionBridge_BendAmplitudeRows:
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
