; Owner: objects/ending/sk
; Responsibility: Ending child movement, parent-relative positioning and indexed character attachment offsets
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

EndingBobYFromSavedBaseAndByteSinePhase:
                move.b  $3C(a0),d0
                addq.b  #4,d0
                move.b  d0,$3C(a0)
                jsr     (GetSineCosine).l
                asr.w   #6,d0
                move.w  $3A(a0),d1
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
; End of function EndingBobYFromSavedBaseAndByteSinePhase

; =============== S U B R O U T I N E =======================================

EndingInitializeGentleVerticalSwing:
                move.w  #$80,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; End of function EndingInitializeGentleVerticalSwing

; =============== S U B R O U T I N E =======================================

EndingTornadoPositionTwoSubSpritesAndCycleTheirFrames:
                lea     byte_6006E(pc),a1
                jsr     (SKMultiSprite_PositionChildren).l
                moveq   #0,d0
                move.b  $44(a0),d0
                addq.b  #1,d0
                cmpi.b  #6,d0
                blo.s   loc_60052
                moveq   #0,d0

loc_60052:
                move.b  d0,$44(a0)
                move.b  byte_60072(pc,d0.w),$1D(a0)
                moveq   #6,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_60068
                moveq   #7,d0

loc_60068:
                move.b  d0,$23(a0)
                rts
; End of function EndingTornadoPositionTwoSubSpritesAndCycleTheirFrames

; ---------------------------------------------------------------------------
byte_6006E:
                dc.b    $34,   4, $18, $18
byte_60072:
                dc.b    2,   3,   4,   5,   4,   3
                even
; ---------------------------------------------------------------------------
; unused
                move.l  d0,(_unkFA82).w
                add.l   d0,(_unkEE98).w
                move.l  d1,(_unkFA84).w
                add.l   d1,(_unkEE9C).w
                rts

; =============== S U B R O U T I N E =======================================

EndingAttachmentSelectOffsetsFromParentPose:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                subq.b  #1,d0
                add.w   d0,d0
                move.w  off_600B0(pc,d0.w),d1
                lea     off_600B0(pc,d1.w),a2
                tst.b   subtype(a0)
                beq.s   loc_600A8
                addq.w  #2,a2

loc_600A8:
                move.w  (a2)+,d0
                move.w  d0,child_dx(a0)                 ; and child_dy
                rts
; End of function EndingAttachmentSelectOffsetsFromParentPose

; ---------------------------------------------------------------------------
off_600B0:
                dc.w    byte_600B6-off_600B0
                dc.w    byte_600BA-off_600B0
                dc.w    byte_600BE-off_600B0
byte_600B6:
                dc.b    -4,   -8
                dc.b    $10, -$14
byte_600BA:
                dc.b    -4,   -7
                dc.b    $10,  -$C
byte_600BE:
                dc.b    -4,   -4
                dc.b    $10,  -$A
