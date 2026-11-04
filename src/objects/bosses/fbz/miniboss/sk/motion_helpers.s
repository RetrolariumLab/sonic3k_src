; Owner: objects/bosses/fbz/miniboss/sk
; Responsibility: Flying Battery miniboss motion, collision, hit response and child positioning helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

FBZMini_SolidBodyOrCapsule:
                moveq   #$23,d1
                moveq   #$20,d2
                moveq   #$1C,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function FBZMini_SolidBodyOrCapsule

; =============== S U B R O U T I N E =======================================

SolidifyFBZMinibossTopButton:
                moveq   #$1B,d1
                moveq   #8,d2
                moveq   #$D,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function SolidifyFBZMinibossTopButton

; ---------------------------------------------------------------------------

loc_6F7A6:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_6F7C0(pc,d0.w),$2E(a0)
                add.w   d0,d0
                lea     word_6F7C6(pc,d0.w),a1
                move.w  (a1)+,d1
                move.w  (a1)+,(a0,d1.w)
                rts
; ---------------------------------------------------------------------------
word_6F7C0:
                dc.w    $20
                dc.w    $20
                dc.w    $40
word_6F7C6:
                dc.w    x_vel,  -$40
                dc.w    x_vel,   $40
                dc.w    y_vel,   $40

; =============== S U B R O U T I N E =======================================

SetFBZMinibossLinkDeploymentVelocity:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_6F7E6-2(pc,d0.w),d0
                move.w  d0,x_vel(a0)
                move.w  d0,y_vel(a0)
                rts
; End of function SetFBZMinibossLinkDeploymentVelocity

; ---------------------------------------------------------------------------
word_6F7E6:
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
                beq.s   loc_6F802
                addq.w  #2,d1

loc_6F802:
                move.b  $40(a0),d2
                bmi.s   loc_6F814
                move.b  byte_6F82C(pc,d1.w),d3
                cmp.b   d3,d0
                bhs.s   loc_6F81E
                bra.w   loc_6F820
; ---------------------------------------------------------------------------

loc_6F814:
                addq.w  #1,d1
                move.b  byte_6F82C(pc,d1.w),d3
                cmp.b   d3,d0
                bhi.s   loc_6F820

loc_6F81E:
                neg.b   d2

loc_6F820:
                move.b  d2,$40(a0)
                add.b   d2,d0
                move.b  d0,$3C(a0)
                rts
; End of function OscillateFBZMinibossArmAngle

; ---------------------------------------------------------------------------
byte_6F82C:
                dc.b    $B0
                dc.b    $80
                dc.b    $80
                dc.b    $50
                even

; =============== S U B R O U T I N E =======================================

ExtendFBZMinibossArmToSideAngle:
                btst    #0,render_flags(a0)
                bne.s   loc_6F84A
                addq.b  #2,$3C(a0)
                moveq   #-$40,d0
                cmp.b   $3C(a0),d0
                bhi.s   loc_6F856

loc_6F844:
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

loc_6F84A:
                subq.b  #2,$3C(a0)
                moveq   #$40,d0
                cmp.b   $3C(a0),d0
                bhs.s   loc_6F844

loc_6F856:
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
                bne.s   loc_6F888
                move.b  byte_6F8BE-1(pc,d1.w),d3
                sub.b   d2,d0
                cmp.b   d3,d0
                bls.s   loc_6F892
                bra.w   loc_6F8B8
; ---------------------------------------------------------------------------

loc_6F888:
                move.b  byte_6F8C3-1(pc,d1.w),d3
                add.b   d2,d0
                cmp.b   d3,d0
                blo.s   loc_6F8B8

loc_6F892:
                move.b  d3,d0
                move.b  d4,routine(a0)
                addq.b  #2,$40(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   loc_6F8B8
                movea.w $44(a0),a1
                movea.w parent3(a1),a1
                bset    #2,$38(a1)
                bset    #6,$3A(a1)

loc_6F8B8:
                move.b  d0,$3C(a0)
                rts
; End of function FoldFBZMinibossLinksForBodyStrike

; ---------------------------------------------------------------------------
byte_6F8BE:
                dc.b    $A0, $88, $60, $48, $38
byte_6F8C3:
                dc.b    $60, $78, $90, $B8, $CC
                even

; =============== S U B R O U T I N E =======================================

ReturnFBZMinibossArmToRestAngle:
                btst    #0,render_flags(a0)
                bne.s   loc_6F8E2
                addq.b  #2,$3C(a0)
                moveq   #-$60,d0
                cmp.b   $3C(a0),d0
                bhi.s   loc_6F8EE

loc_6F8DC:
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

loc_6F8E2:
                subq.b  #2,$3C(a0)
                moveq   #$60,d0
                cmp.b   $3C(a0),d0
                bhs.s   loc_6F8DC

loc_6F8EE:
                moveq   #0,d0
                rts
; End of function ReturnFBZMinibossArmToRestAngle

; =============== S U B R O U T I N E =======================================

RaiseFBZMinibossArmToVerticalAngle:
                btst    #0,render_flags(a0)
                bne.s   loc_6F90C
                subq.b  #2,$3C(a0)
                moveq   #-$80,d0
                cmp.b   $3C(a0),d0
                blo.s   loc_6F918

loc_6F906:
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

loc_6F90C:
                addq.b  #2,$3C(a0)
                moveq   #-$80,d0
                cmp.b   $3C(a0),d0
                blo.s   loc_6F906

loc_6F918:
                moveq   #0,d0
                rts
; End of function RaiseFBZMinibossArmToVerticalAngle

; ---------------------------------------------------------------------------

loc_6F91C:
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

; Place the link on the quantized line from the shoulder to the fist
FBZMiniPunch_InterpolateLink:
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
                bpl.s   loc_6F95C
                neg.w   d0

loc_6F95C:
                divu.w  #5,d0
                mulu.w  d2,d0
                tst.b   d1
                beq.s   loc_6F968
                neg.w   d0

loc_6F968:
                add.w   d0,d3
                move.w  d3,x_pos(a0)
                moveq   #0,d0
                move.w  y_pos(a1),d0
                move.w  y_pos(a2),d3
                sub.w   d3,d0
                smi     d1
                bpl.s   loc_6F980
                neg.w   d0

loc_6F980:
                divu.w  #5,d0
                mulu.w  d2,d0
                tst.b   d1
                beq.s   loc_6F98C
                neg.w   d0

loc_6F98C:
                add.w   d0,d3
                move.w  d3,y_pos(a0)
                rts
; End of function FBZMiniPunch_InterpolateLink

; =============== S U B R O U T I N E =======================================

ProcessFBZMinibossArmSelfHitAndDefeat:
                btst    #6,$3A(a0)
                beq.s   locret_6F9DC
                tst.b   $20(a0)
                bne.s   loc_6F9B6
                subq.b  #1,collision_property(a0)
                beq.s   loc_6F9DE
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_6F9B6:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_6F9C2
                addq.w  #2*4,d0

loc_6F9C2:
                lea     word_6F9FC(pc),a1
                lea     word_6FA04(pc,d0.w),a2
                jsr     (CopyWordData_4).l
                subq.b  #1,$20(a0)
                bne.s   locret_6F9DC
                bclr    #6,$3A(a0)

locret_6F9DC:
                rts
; ---------------------------------------------------------------------------

loc_6F9DE:
                move.l  #loc_6EF88,(a0)
                bset    #7,status(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     (BossDefeated_StopTimer).l
; End of function ProcessFBZMinibossArmSelfHitAndDefeat

; ---------------------------------------------------------------------------
word_6F9FC:
                dc.w    Normal_palette_line_2+$04, Normal_palette_line_2+$08, Normal_palette_line_2+$16, Normal_palette_line_2+$1E
word_6FA04:
                dc.w    $222,  $644,  $222,   $44
                dc.w    $AAA,  $AAA,  $EEE,  $EEE

; =============== S U B R O U T I N E =======================================

EnterFBZMinibossArmParentDefeatWait:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_6FA22
                rts
; ---------------------------------------------------------------------------

loc_6FA22:
                move.l  #loc_6F3B2,(a0)
                bset    #7,status(a0)
                clr.b   collision_flags(a0)
                rts
; End of function EnterFBZMinibossArmParentDefeatWait
