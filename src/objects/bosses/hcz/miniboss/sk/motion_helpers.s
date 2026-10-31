; Owner: objects/bosses/hcz/miniboss/sk
; Responsibility: Hydrocity miniboss motion, acceleration, child positioning, collision and animation helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_6A916:
                move.w  x_pos(a0),d0
                move.w  x_vel(a0),d1
                move.w  #$100,d2
                cmp.w   $3A(a0),d0
                scs     d3
                bcs.s   loc_6A92C
                neg.w   d2

loc_6A92C:
                add.w   d2,d1
                cmp.b   $3C(a0),d3
                beq.s   loc_6A93A
                move.b  d3,$3C(a0)
                add.w   d2,d1

loc_6A93A:
                move.w  d1,x_vel(a0)
                rts
; End of function sub_6A916

; =============== S U B R O U T I N E =======================================

sub_6A940:
                add.w   d0,d0
                smi     d2
                bpl.s   loc_6A948
                neg.w   d0

loc_6A948:
                move.w  #$100,d3
                sub.w   d0,d3
                bpl.s   loc_6A952
                moveq   #0,d3

loc_6A952:
                lsl.w   #4,d3
                tst.b   d2
                beq.s   loc_6A95A
                neg.w   d3

loc_6A95A:
                move.w  d3,x_vel(a0)
                rts
; End of function sub_6A940

; =============== S U B R O U T I N E =======================================

sub_6A960:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.w   locret_69F78
                move.l  #loc_6A636,(a0)
                clr.b   collision_flags(a0)
                bclr    #3,$38(a0)
                beq.w   locret_69F78
                bra.w   loc_6A986

loc_6A986:
                move.w  $42(a0),d0
                beq.s   loc_6A990
                bsr.w   sub_6A996

loc_6A990:
                move.w  $44(a0),d0
                beq.s   locret_6A9A8
; End of function sub_6A960

; =============== S U B R O U T I N E =======================================

sub_6A996:
                movea.w d0,a2
                bset    #Status_InAir,status(a2)
                clr.b   object_control(a2)
                move.w  #$100,priority(a2)

locret_6A9A8:
                rts
; End of function sub_6A996

; =============== S U B R O U T I N E =======================================

sub_6A9AA:
                movea.l a0,a1
                movea.l a0,a2
                movea.l a3,a0
                bsr.w   sub_6AA30
                movea.l a1,a0
                rts
; End of function sub_6A9AA

; =============== S U B R O U T I N E =======================================

sub_6A9B8:
                clr.l   $42(a0)
                move.w  y_pos(a0),d0
                subi.w  #$20,d0
                lea     (Player_1).w,a2
                cmp.w   y_pos(a2),d0
                bhi.s   loc_6A9E0
                move.w  a2,$42(a0)
                bsr.w   sub_6AA30
                tst.b   object_control(a2)
                bne.s   loc_6A9E0
                bsr.w   sub_6AA00

loc_6A9E0:
                lea     (Player_2).w,a2
                cmp.w   y_pos(a2),d0
                bhi.s   locret_6AA22
                cmpi.b  #6,routine(a2)
                bhs.s   locret_6AA22
                move.w  a2,$44(a0)
                bsr.w   sub_6AA30
                tst.b   object_control(a2)
                bne.s   locret_6AA22
; End of function sub_6A9B8

; =============== S U B R O U T I N E =======================================

sub_6AA00:
                bset    #Status_InAir,status(a2)
                move.b  #1,object_control(a2)
                move.b  #$F,anim(a2)
                clr.b   spin_dash_flag(a2)
                clr.w   x_vel(a2)
                clr.w   y_vel(a2)
                clr.w   ground_vel(a2)

locret_6AA22:
                rts
; End of function sub_6AA00

; ---------------------------------------------------------------------------
; unused
                dc.w    Player_1
                dc.w    0
                dc.w    Player_2
                dc.w    0
                dc.w    Player_2
                dc.w    Player_2

; =============== S U B R O U T I N E =======================================

sub_6AA30:
                move.w  x_pos(a2),d0
                move.w  x_vel(a2),d1
                move.w  #$40,d2
                sub.w   x_pos(a0),d0
                scs     d3
                bcc.s   loc_6AA46
                neg.w   d0

loc_6AA46:
                cmpi.w  #3,d0
                bhi.s   loc_6AA54
                tst.w   d1
                bpl.s   loc_6AA62
                bra.w   loc_6AA60
; ---------------------------------------------------------------------------

loc_6AA54:
                cmpi.w  #$70,d0
                bls.s   loc_6AA5C
                moveq   #0,d1

loc_6AA5C:
                tst.b   d3
                bne.s   loc_6AA62

loc_6AA60:
                neg.w   d2

loc_6AA62:
                add.w   d2,d1
                move.w  #$100,priority(a2)
                move.w  d1,x_vel(a2)
                bpl.s   loc_6AA76
                move.w  #$300,priority(a2)

loc_6AA76:
                ext.l   d1
                lsl.l   #8,d1
                add.l   d1,x_pos(a2)
                move.l  #$8000,d4
                move.w  y_pos(a2),d5
                sub.w   y_pos(a0),d5
                cmpi.w  #-$10,d5
                blt.s   loc_6AA9A
                cmpi.w  #$10,d5
                ble.s   locret_6AA9E
                neg.l   d4

loc_6AA9A:
                add.l   d4,y_pos(a2)

locret_6AA9E:
                rts
; End of function sub_6AA30

; =============== S U B R O U T I N E =======================================

sub_6AAA0:
                btst    #7,$38(a0)
                bne.w   locret_69F78
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.w   locret_69F78
; End of function sub_6AAA0

; =============== S U B R O U T I N E =======================================

sub_6AAB6:
                bset    #7,$38(a0)
                moveq   #signextendB(sfx_Splash),d0
                jsr     (Play_SFX).l
                clr.w   (Slotted_object_bits).w
                lea     ChildObjDat_6AD7E(pc),a2
                jmp     (CreateChild1_Normal).l
; End of function sub_6AAB6

; =============== S U B R O U T I N E =======================================

sub_6AAD2:
                move.b  $3A(a0),d0
                addq.b  #2,$3A(a0)
                andi.w  #$E,d0
                lea     byte_6AB0A(pc,d0.w),a1
                move.b  (a1)+,d0
                bne.s   loc_6AAEA
                move.w  #$100,d0

loc_6AAEA:
                move.w  #$400,d2
                cmpi.w  #$A0,d0
                blo.s   loc_6AAF6
                neg.w   d2

loc_6AAF6:
                move.w  d2,$40(a0)
                move.w  (Camera_X_pos).w,d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.b  (a1)+,$39(a0)
                rts
; End of function sub_6AAD2

; ---------------------------------------------------------------------------
byte_6AB0A:
                dc.b    $40,   1
                dc.b    0,   1
                dc.b    $40,   0
                dc.b    $40,   1
                dc.b    0,   0
                dc.b    0,   1
                dc.b    $40,   0
                dc.b    0,   0
                even

; =============== S U B R O U T I N E =======================================

sub_6AB1A:
                move.b  $40(a0),d2
                add.b   d2,$3C(a0)
                bsr.w   sub_6AB60
                add.b   d2,$3D(a0)
                bsr.w   sub_6AB94
                moveq   #0,d0
                move.b  $3D(a0),d0
                lsr.w   #4,d0
                move.b  byte_6AB50(pc,d0.w),mapping_frame(a0)
                move.w  #$200,priority(a0)
                cmpi.b  #8,d0
                blo.s   locret_6AB4E
                move.w  #$280,priority(a0)

locret_6AB4E:
                rts
; End of function sub_6AB1A

; ---------------------------------------------------------------------------
byte_6AB50:
                dc.b    1
                dc.b    2
                dc.b    3
                dc.b    4
                dc.b    5
                dc.b    6
                dc.b    7
                dc.b    8
                dc.b    9
                dc.b    $A
                dc.b    $B
                dc.b    $1A
                dc.b    $1A
                dc.b    $1A
                dc.b    $C
                dc.b    $D
                even

; =============== S U B R O U T I N E =======================================

sub_6AB60:
                moveq   #0,d0
                move.b  $3C(a0),d0
                bsr.w   sub_6AB76
                move.w  x_pos(a2),d0
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                rts
; End of function sub_6AB60

; =============== S U B R O U T I N E =======================================

sub_6AB76:
                cmpi.b  #$80,d0
                blo.s   loc_6AB82
                moveq   #-1,d1
                sub.b   d0,d1
                move.b  d1,d0

loc_6AB82:
                lea     (HCZMiniboss_RocketTwistLookup).l,a1
                move.b  (a1,d0.w),d1
                ext.w   d1
                movea.w parent3(a0),a2
                rts
; End of function sub_6AB76

; =============== S U B R O U T I N E =======================================

sub_6AB94:
                moveq   #0,d0
                move.b  $3D(a0),d0
                bsr.s   sub_6AB76
                move.w  y_pos(a2),d0
                add.w   d1,d0
                move.w  d0,y_pos(a0)
                rts
; End of function sub_6AB94

; =============== S U B R O U T I N E =======================================

sub_6ABA8:
                movea.w parent3(a0),a2
                moveq   #0,d0
                move.b  $3D(a2),d0
                lsr.w   #3,d0
                andi.w  #$FFFE,d0
                move.w  word_6ABF8(pc,d0.w),priority(a0)
                lea     byte_6AC18(pc,d0.w),a1
                move.b  (a1)+,d1
                ext.w   d1
                btst    #0,render_flags(a2)
                beq.s   loc_6ABD6
                neg.w   d1
                bset    #0,render_flags(a0)

loc_6ABD6:
                move.b  (a1)+,d2
                ext.w   d2
                move.w  x_pos(a2),d3
                add.w   d1,d3
                move.w  d3,x_pos(a0)
                move.w  y_pos(a2),d3
                add.w   d2,d3
                move.w  d3,y_pos(a0)
                lsr.w   #1,d0
                move.b  byte_6AC38(pc,d0.w),mapping_frame(a0)
                rts
; End of function sub_6ABA8

; ---------------------------------------------------------------------------
word_6ABF8:
                dc.w    $280
                dc.w    $200
                dc.w    $200
                dc.w    $200
                dc.w    $200
                dc.w    $180
                dc.w    $180
                dc.w    $180
                dc.w    $180
                dc.w    $180
                dc.w    $180
                dc.w    $280
                dc.w    $280
                dc.w    $280
                dc.w    $280
                dc.w    $280
byte_6AC18:
                dc.b    3,   3
                dc.b    0,   0
                dc.b    6,   6
                dc.b    $C,  $C
                dc.b    $12, $12
                dc.b    $C,  $C
                dc.b    8,   8
                dc.b    0,   0
                dc.b    3,   3
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    -6,  -6
                dc.b    -$A, -$A
                dc.b    0,   0
                dc.b    0,   0
byte_6AC38:
                dc.b    $E,  $F
                dc.b    $10, $11
                dc.b    $12, $11
                dc.b    $10,  $F
                dc.b    $E, $1A
                dc.b    $1A, $1A
                dc.b    $E,  $E
                dc.b    $1A, $1A
                even

; =============== S U B R O U T I N E =======================================

sub_6AC48:
                tst.b   collision_flags(a0)
                bne.s   locret_6ACA4
                tst.b   collision_property(a0)
                beq.s   loc_6ACA6
                tst.b   $20(a0)
                bne.s   loc_6AC68
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_6AC68:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_6AC7C
                addi.w  #2*7,d0

loc_6AC7C:
                lea     word_6ACC6(pc),a1
                lea     word_6ACD4(pc,d0.w),a2
                jsr     (CopyWordData_7).l
                subq.b  #1,$20(a0)
                bne.s   locret_6ACA4
                bclr    #6,status(a0)
                cmpi.b  #0,mapping_frame(a0)
                bne.s   locret_6ACA4
                move.b  $25(a0),collision_flags(a0)

locret_6ACA4:
                rts
; ---------------------------------------------------------------------------

loc_6ACA6:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #loc_6A22A,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     (BossDefeated_StopTimer).l
; End of function sub_6AC48

; ---------------------------------------------------------------------------
word_6ACC6:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$0E, Normal_palette_line_2+$12, Normal_palette_line_2+$14
                dc.w    Normal_palette_line_2+$16, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_6ACD4:
                dc.w    4,     0,    $C,     8,   $20,  $826,  $624
                dc.w    $AAA,  $AAA,  $888,  $AAA,  $EEE,  $888,  $AAA
