; Owner: objects/bosses/fbz/miniboss/s3
; Responsibility: Flying Battery miniboss motion, collision, hit response and child positioning helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SolidifyFBZMinibossBodyAndReleasedCapsule:
                moveq   #$23,d1
                moveq   #$20,d2
                moveq   #$1C,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function SolidifyFBZMinibossBodyAndReleasedCapsule

; =============== S U B R O U T I N E =======================================

SolidifyFBZMinibossTopButton:
                moveq   #$13,d1
                moveq   #$10,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function SolidifyFBZMinibossTopButton

; ---------------------------------------------------------------------------

loc_4D1D8:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_4D1F2(pc,d0.w),$2E(a0)
                add.w   d0,d0
                lea     word_4D1F8(pc,d0.w),a1
                move.w  (a1)+,d1
                move.w  (a1)+,(a0,d1.w)
                rts
; ---------------------------------------------------------------------------
word_4D1F2:
                dc.w    $20
                dc.w    $20
                dc.w    $40
word_4D1F8:
                dc.w    x_vel,  -$40
                dc.w    x_vel,   $40
                dc.w    y_vel,   $40

; =============== S U B R O U T I N E =======================================

SetFBZMinibossLinkDeploymentVelocity:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_4D218-2(pc,d0.w),d0
                move.w  d0,x_vel(a0)
                move.w  d0,y_vel(a0)
                rts
; End of function SetFBZMinibossLinkDeploymentVelocity

; ---------------------------------------------------------------------------
word_4D218:
                dc.w    -$C0
                dc.w    -$180
                dc.w    -$240
                dc.w    -$300
                dc.w    -$3C0
                dc.w    -$530

; =============== S U B R O U T I N E =======================================

OscillateFBZMinibossArmAngle:
                move.b  $3C(a0),d0
                moveq   #0,d1
                btst    #0,render_flags(a0)
                beq.s   loc_4D234
                addq.w  #2,d1

loc_4D234:
                move.b  $40(a0),d2
                bmi.s   loc_4D246
                move.b  byte_4D25E(pc,d1.w),d3
                cmp.b   d3,d0
                bhs.s   loc_4D250
                bra.w   loc_4D252
; ---------------------------------------------------------------------------

loc_4D246:
                addq.w  #1,d1
                move.b  byte_4D25E(pc,d1.w),d3
                cmp.b   d3,d0
                bhi.s   loc_4D252

loc_4D250:
                neg.b   d2

loc_4D252:
                move.b  d2,$40(a0)
                add.b   d2,d0
                move.b  d0,$3C(a0)
                rts
; End of function OscillateFBZMinibossArmAngle

; ---------------------------------------------------------------------------
byte_4D25E:
                dc.b    $B0
                dc.b    $80
                dc.b    $80
                dc.b    $50
                even

; =============== S U B R O U T I N E =======================================

ExtendFBZMinibossArmToSideAngle:
                btst    #0,render_flags(a0)
                bne.s   loc_4D27C
                addq.b  #2,$3C(a0)
                moveq   #-$40,d0
                cmp.b   $3C(a0),d0
                bhi.s   loc_4D288

loc_4D276:
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D27C:
                subq.b  #2,$3C(a0)
                moveq   #$40,d0
                cmp.b   $3C(a0),d0
                bhs.s   loc_4D276

loc_4D288:
                moveq   #0,d0
                rts
; End of function ExtendFBZMinibossArmToSideAngle

; =============== S U B R O U T I N E =======================================

FoldFBZMinibossLinksForBodyStrike:
                move.b  $3C(a0),d0
                moveq   #0,d1
                move.b  subtype(a0),d1
                movea.w parent3(a0),a1
                move.b  $40(a1),d2
                move.b  d2,$40(a0)
                lsr.w   #1,d1
                btst    #0,render_flags(a0)
                bne.s   loc_4D2BA
                move.b  byte_4D2F0-1(pc,d1.w),d3
                sub.b   d2,d0
                cmp.b   d3,d0
                bls.s   loc_4D2C4
                bra.w   loc_4D2EA
; ---------------------------------------------------------------------------

loc_4D2BA:
                move.b  byte_4D2F5-1(pc,d1.w),d3
                add.b   d2,d0
                cmp.b   d3,d0
                blo.s   loc_4D2EA

loc_4D2C4:
                move.b  d3,d0
                move.b  d4,routine(a0)
                addq.b  #2,$40(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   loc_4D2EA
                movea.w $44(a0),a1
                movea.w parent3(a1),a1
                bset    #2,$38(a1)
                bset    #6,$3A(a1)

loc_4D2EA:
                move.b  d0,$3C(a0)
                rts
; End of function FoldFBZMinibossLinksForBodyStrike

; ---------------------------------------------------------------------------
byte_4D2F0:
                dc.b    $A0, $88, $60, $48, $38
byte_4D2F5:
                dc.b    $60, $78, $90, $B8, $CC
                even

; =============== S U B R O U T I N E =======================================

ReturnFBZMinibossArmToRestAngle:
                btst    #0,render_flags(a0)
                bne.s   loc_4D314
                addq.b  #2,$3C(a0)
                moveq   #-$60,d0
                cmp.b   $3C(a0),d0
                bhi.s   loc_4D320

loc_4D30E:
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D314:
                subq.b  #2,$3C(a0)
                moveq   #$60,d0
                cmp.b   $3C(a0),d0
                bhs.s   loc_4D30E

loc_4D320:
                moveq   #0,d0
                rts
; End of function ReturnFBZMinibossArmToRestAngle

; =============== S U B R O U T I N E =======================================

RaiseFBZMinibossArmToVerticalAngle:
                btst    #0,render_flags(a0)
                bne.s   loc_4D33E
                subq.b  #2,$3C(a0)
                moveq   #-$80,d0
                cmp.b   $3C(a0),d0
                blo.s   loc_4D34A

loc_4D338:
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D33E:
                addq.b  #2,$3C(a0)
                moveq   #-$80,d0
                cmp.b   $3C(a0),d0
                blo.s   loc_4D338

loc_4D34A:
                moveq   #0,d0
                rts
; End of function RaiseFBZMinibossArmToVerticalAngle

; ---------------------------------------------------------------------------

loc_4D34E:
                move.w  $30(a0),d0
                sub.w   x_pos(a0),d0
                lsl.w   #3,d0
                move.w  d0,x_vel(a0)
                move.w  $32(a0),d0
                sub.w   y_pos(a0),d0
                lsl.w   #3,d0
                move.w  d0,y_vel(a0)
                rts

; =============== S U B R O U T I N E =======================================

InterpolateFBZMinibossPunchLinkBetweenEndpoints:
                movea.w $32(a0),a1
                movea.w $30(a0),a2
                moveq   #0,d2
                move.b  subtype(a0),d2
                lsr.w   #1,d2
                moveq   #0,d0
                move.w  x_pos(a1),d0
                move.w  x_pos(a2),d3
                sub.w   d3,d0
                smi     d1
                bpl.s   loc_4D38E
                neg.w   d0

loc_4D38E:
                divu.w  #5,d0
                mulu.w  d2,d0
                tst.b   d1
                beq.s   loc_4D39A
                neg.w   d0

loc_4D39A:
                add.w   d0,d3
                move.w  d3,x_pos(a0)
                moveq   #0,d0
                move.w  y_pos(a1),d0
                move.w  y_pos(a2),d3
                sub.w   d3,d0
                smi     d1
                bpl.s   loc_4D3B2
                neg.w   d0

loc_4D3B2:
                divu.w  #5,d0
                mulu.w  d2,d0
                tst.b   d1
                beq.s   loc_4D3BE
                neg.w   d0

loc_4D3BE:
                add.w   d0,d3
                move.w  d3,y_pos(a0)
                rts
; End of function InterpolateFBZMinibossPunchLinkBetweenEndpoints

; =============== S U B R O U T I N E =======================================

ProcessFBZMinibossArmSelfHitAndDefeat:
                btst    #6,$3A(a0)
                beq.s   locret_4D40C
                tst.b   $20(a0)
                bne.s   loc_4D3E8
                subq.b  #1,collision_property(a0)
                beq.s   loc_4D40E
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_4D3E8:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_4D3F4
                addq.w  #2*4,d0

loc_4D3F4:
                lea     word_4D430(pc),a1
                lea     word_4D438(pc,d0.w),a2
                jsr     CopyWordData_4(pc)
                subq.b  #1,$20(a0)
                bne.s   locret_4D40C
                bclr    #6,$3A(a0)

locret_4D40C:
                rts
; ---------------------------------------------------------------------------

loc_4D40E:
                move.l  #Wait_Draw,(a0)
                bset    #7,status(a0)
                move.l  #loc_4CA30,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     BossDefeated_StopTimer(pc)
; End of function ProcessFBZMinibossArmSelfHitAndDefeat

; ---------------------------------------------------------------------------
word_4D430:
                dc.w    Normal_palette_line_2+$04, Normal_palette_line_2+$08, Normal_palette_line_2+$16, Normal_palette_line_2+$1E
word_4D438:
                dc.w    $222,  $644,   $20,   $20
                dc.w    $AAA,  $AAA,  $EEE,  $EEE

; =============== S U B R O U T I N E =======================================

EnterFBZMinibossArmParentDefeatWait:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_4D456
                rts
; ---------------------------------------------------------------------------

loc_4D456:
                move.l  #loc_4CE1A,(a0)
                bset    #7,status(a0)
                clr.b   collision_flags(a0)
                rts
; End of function EnterFBZMinibossArmParentDefeatWait
