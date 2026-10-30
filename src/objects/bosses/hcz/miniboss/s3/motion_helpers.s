; Owner: objects/bosses/hcz/miniboss/s3
; Responsibility: Hydrocity miniboss motion, acceleration, child positioning, collision and animation helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_4875A:
                move.w  x_pos(a0),d0
                move.w  x_vel(a0),d1
                move.w  #$100,d2
                cmp.w   $3A(a0),d0
                scs     d3
                bcs.s   loc_48770
                neg.w   d2

loc_48770:
                add.w   d2,d1
                cmp.b   $3C(a0),d3
                beq.s   loc_4877E
                move.b  d3,$3C(a0)
                add.w   d2,d1

loc_4877E:
                move.w  d1,x_vel(a0)
                rts
; End of function sub_4875A

; =============== S U B R O U T I N E =======================================

sub_48784:
                add.w   d0,d0
                smi     d2
                bpl.s   loc_4878C
                neg.w   d0

loc_4878C:
                move.w  #$100,d3
                sub.w   d0,d3
                bpl.s   loc_48796
                moveq   #0,d3

loc_48796:
                lsl.w   #4,d3
                tst.b   d2
                beq.s   loc_4879E
                neg.w   d3

loc_4879E:
                move.w  d3,x_vel(a0)
                rts
; End of function sub_48784

; =============== S U B R O U T I N E =======================================

sub_487A4:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.w   locret_47DC8
                move.l  #loc_4847A,(a0)
                clr.b   collision_flags(a0)
                bclr    #3,$38(a0)
                beq.w   locret_47DC8
                bra.w   loc_487CA

loc_487CA:
                move.w  $42(a0),d0
                beq.s   loc_487D4
                bsr.w   sub_487DA

loc_487D4:
                move.w  $44(a0),d0
                beq.s   locret_487EC
; End of function sub_487A4

; =============== S U B R O U T I N E =======================================

sub_487DA:
                movea.w d0,a2
                bset    #Status_InAir,status(a2)
                clr.b   object_control(a2)
                move.w  #$100,priority(a2)

locret_487EC:
                rts
; End of function sub_487DA

; =============== S U B R O U T I N E =======================================

sub_487EE:
                movea.l a0,a1
                movea.l a0,a2
                movea.l a3,a0
                bsr.w   sub_48874
                movea.l a1,a0
                rts
; End of function sub_487EE

; =============== S U B R O U T I N E =======================================

sub_487FC:
                clr.l   $42(a0)
                move.w  y_pos(a0),d0
                subi.w  #$20,d0
                lea     (Player_1).w,a2
                cmp.w   y_pos(a2),d0
                bhi.s   loc_48824
                move.w  a2,$42(a0)
                bsr.w   sub_48874
                tst.b   object_control(a2)
                bne.s   loc_48824
                bsr.w   sub_48844

loc_48824:
                lea     (Player_2).w,a2
                cmp.w   y_pos(a2),d0
                bhi.s   locret_48866
                cmpi.b  #6,routine(a2)
                bhs.s   locret_48866
                move.w  a2,$44(a0)
                bsr.w   sub_48874
                tst.b   object_control(a2)
                bne.s   locret_48866
; End of function sub_487FC

; =============== S U B R O U T I N E =======================================

sub_48844:
                bset    #Status_InAir,status(a2)
                move.b  #1,object_control(a2)
                move.b  #$F,anim(a2)
                clr.b   spin_dash_flag(a2)
                clr.w   x_vel(a2)
                clr.w   y_vel(a2)
                clr.w   ground_vel(a2)

locret_48866:
                rts
; End of function sub_48844

; ---------------------------------------------------------------------------
; unused
                dc.w    Player_1
                dc.w    0
                dc.w    Player_2
                dc.w    0
                dc.w    Player_1
                dc.w    Player_2

; =============== S U B R O U T I N E =======================================

sub_48874:
                move.w  x_pos(a2),d0
                move.w  x_vel(a2),d1
                move.w  #$40,d2
                sub.w   x_pos(a0),d0
                scs     d3
                bcc.s   loc_4888A
                neg.w   d0

loc_4888A:
                cmpi.w  #3,d0
                bhi.s   loc_48898
                tst.w   d1
                bpl.s   loc_488A6
                bra.w   loc_488A4
; ---------------------------------------------------------------------------

loc_48898:
                cmpi.w  #$70,d0
                bls.s   loc_488A0
                moveq   #0,d1

loc_488A0:
                tst.b   d3
                bne.s   loc_488A6

loc_488A4:
                neg.w   d2

loc_488A6:
                add.w   d2,d1
                move.w  #$100,priority(a2)
                move.w  d1,x_vel(a2)
                bpl.s   loc_488BA
                move.w  #$300,priority(a2)

loc_488BA:
                ext.l   d1
                lsl.l   #8,d1
                add.l   d1,x_pos(a2)
                move.l  #$8000,d4
                move.w  y_pos(a2),d5
                sub.w   y_pos(a0),d5
                cmpi.w  #-$10,d5
                blt.s   loc_488DE
                cmpi.w  #$10,d5
                ble.s   locret_488E2
                neg.l   d4

loc_488DE:
                add.l   d4,y_pos(a2)

locret_488E2:
                rts
; End of function sub_48874

; =============== S U B R O U T I N E =======================================

sub_488E4:
                btst    #7,$38(a0)
                bne.w   locret_47DC8
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.w   locret_47DC8
; End of function sub_488E4

; =============== S U B R O U T I N E =======================================

sub_488FA:
                bset    #7,$38(a0)
                moveq   #signextendB(sfx_Splash),d0
                jsr     (Play_SFX).l
                clr.w   (Slotted_object_bits).w
                lea     ChildObjDat_48BC2(pc),a2
                jmp     (CreateChild1_Normal).l
; End of function sub_488FA

; =============== S U B R O U T I N E =======================================

sub_48916:
                move.b  $3A(a0),d0
                addq.b  #2,$3A(a0)
                andi.w  #$E,d0
                lea     byte_4894E(pc,d0.w),a1
                move.b  (a1)+,d0
                bne.s   loc_4892E
                move.w  #$100,d0

loc_4892E:
                move.w  #$400,d2
                cmpi.w  #$A0,d0
                blo.s   loc_4893A
                neg.w   d2

loc_4893A:
                move.w  d2,$40(a0)
                move.w  (Camera_X_pos).w,d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.b  (a1)+,$39(a0)
                rts
; End of function sub_48916

; ---------------------------------------------------------------------------
byte_4894E:
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

sub_4895E:
                move.b  $40(a0),d2
                add.b   d2,$3C(a0)
                bsr.w   sub_489A4
                add.b   d2,$3D(a0)
                bsr.w   sub_489D8
                moveq   #0,d0
                move.b  $3D(a0),d0
                lsr.w   #4,d0
                move.b  byte_48994(pc,d0.w),mapping_frame(a0)
                move.w  #$200,priority(a0)
                cmpi.b  #8,d0
                blo.s   locret_48992
                move.w  #$280,priority(a0)

locret_48992:
                rts
; End of function sub_4895E

; ---------------------------------------------------------------------------
byte_48994:
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

sub_489A4:
                moveq   #0,d0
                move.b  $3C(a0),d0
                bsr.w   sub_489BA
                move.w  x_pos(a2),d0
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                rts
; End of function sub_489A4

; =============== S U B R O U T I N E =======================================

sub_489BA:
                cmpi.b  #$80,d0
                blo.s   loc_489C6
                moveq   #-1,d1
                sub.b   d0,d1
                move.b  d1,d0

loc_489C6:
                lea     (HCZMiniboss_RocketTwistLookup).l,a1
                move.b  (a1,d0.w),d1
                ext.w   d1
                movea.w parent3(a0),a2
                rts
; End of function sub_489BA

; =============== S U B R O U T I N E =======================================

sub_489D8:
                moveq   #0,d0
                move.b  $3D(a0),d0
                bsr.s   sub_489BA
                move.w  y_pos(a2),d0
                add.w   d1,d0
                move.w  d0,y_pos(a0)
                rts
; End of function sub_489D8

; =============== S U B R O U T I N E =======================================

sub_489EC:
                movea.w parent3(a0),a2
                moveq   #0,d0
                move.b  $3D(a2),d0
                lsr.w   #3,d0
                andi.w  #$FFFE,d0
                move.w  word_48A3C(pc,d0.w),priority(a0)
                lea     byte_48A5C(pc,d0.w),a1
                move.b  (a1)+,d1
                ext.w   d1
                btst    #0,render_flags(a2)
                beq.s   loc_48A1A
                neg.w   d1
                bset    #0,render_flags(a0)

loc_48A1A:
                move.b  (a1)+,d2
                ext.w   d2
                move.w  x_pos(a2),d3
                add.w   d1,d3
                move.w  d3,x_pos(a0)
                move.w  y_pos(a2),d3
                add.w   d2,d3
                move.w  d3,y_pos(a0)
                lsr.w   #1,d0
                move.b  byte_48A7C(pc,d0.w),mapping_frame(a0)
                rts
; End of function sub_489EC

; ---------------------------------------------------------------------------
word_48A3C:
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
byte_48A5C:
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
byte_48A7C:
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

sub_48A8C:
                tst.b   collision_flags(a0)
                bne.s   locret_48AE8
                tst.b   collision_property(a0)
                beq.s   loc_48AEA
                tst.b   $20(a0)
                bne.s   loc_48AAC
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_48AAC:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_48AC0
                addi.w  #2*7,d0

loc_48AC0:
                lea     word_48B0A(pc),a1
                lea     word_48B18(pc,d0.w),a2
                jsr     (CopyWordData_7).l
                subq.b  #1,$20(a0)
                bne.s   locret_48AE8
                bclr    #6,status(a0)
                cmpi.b  #0,mapping_frame(a0)
                bne.s   locret_48AE8
                move.b  $25(a0),collision_flags(a0)

locret_48AE8:
                rts
; ---------------------------------------------------------------------------

loc_48AEA:
                move.l  #Wait_Draw,(a0)
                move.l  #loc_4807A,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     (BossDefeated_StopTimer).l
; End of function sub_48A8C

; ---------------------------------------------------------------------------
word_48B0A:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$0E, Normal_palette_line_2+$12, Normal_palette_line_2+$14
                dc.w    Normal_palette_line_2+$16, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_48B18:
                dc.w    4,     0,    $C,     8,   $20,  $826,  $624
                dc.w    $AAA,  $AAA,  $888,  $AAA,  $EEE,  $888,  $AAA
