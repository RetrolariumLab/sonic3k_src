; Owner: objects/bosses/hcz/end_boss/s3
; Responsibility: Hydrocity end-boss player response, child motion, collision, callback and debris creation helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_496F4:
                move.w  $44(a0),d0
                beq.s   locret_4972A
                movea.w d0,a1
                btst    #2,$38(a0)
                bne.s   loc_49726
                move.w  y_pos(a0),d0
                subi.w  #$60,d0
                cmp.w   y_pos(a1),d0
                bcc.s   locret_4972A
                bset    #2,$38(a0)
                move.b  #$81,object_control(a1)
                move.b  #$1A,anim(a1)
                rts
; ---------------------------------------------------------------------------

loc_49726:
                subq.w  #8,y_pos(a1)

locret_4972A:
                rts
; End of function sub_496F4

; =============== S U B R O U T I N E =======================================

sub_4972C:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_4973A(pc,d0.w),priority(a0)
                rts
; End of function sub_4972C

; ---------------------------------------------------------------------------
word_4973A:
                dc.w    $280
                dc.w    $200
                dc.w    $180
; ---------------------------------------------------------------------------

loc_49740:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_4974E(pc,d0.w),$40(a0)
                rts
; ---------------------------------------------------------------------------
word_4974E:
                dc.w    $101
                dc.w    $100

; =============== S U B R O U T I N E =======================================

sub_49752:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  $39(a1),d0
                cmp.b   $39(a0),d0
                beq.s   locret_49782
                move.b  d0,$39(a0)
                move.b  byte_49784+1(pc,d0.w),d1
                ext.w   d1
                move.w  (Water_level).w,d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                lsl.w   #2,d0
                move.l  off_49790(pc,d0.w),$30(a0)
                clr.b   anim_frame_timer(a0)

locret_49782:
                rts
; End of function sub_49752

; ---------------------------------------------------------------------------
byte_49784:
                dc.b    -8
                dc.b    -8
                dc.b    -$10
                dc.b    -$18
                dc.b    -$20
                dc.b    -$28
                dc.b    -$28
                dc.b    0
                dc.b    0
                dc.b    4
                dc.b    -$64
                dc.b    $61
                even
off_49790:
                dc.l    byte_49C61
                dc.l    byte_49C66
                dc.l    byte_49C6B
                dc.l    byte_49C70
                dc.l    byte_49C75
                dc.l    byte_49C75

; =============== S U B R O U T I N E =======================================

sub_497A8:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$2E(a0)
                move.w  word_497CA(pc,d0.w),d1
                move.w  (Water_level).w,d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                add.w   d0,d0
                move.l  off_497D4(pc,d0.w),$30(a0)
                rts
; End of function sub_497A8

; ---------------------------------------------------------------------------
word_497CA:
                dc.w    -8
                dc.w    -$18
                dc.w    -$28
                dc.w    -$38
                dc.w    -$48
off_497D4:
                dc.l    byte_49C87
                dc.l    byte_49CBE
                dc.l    byte_49CED
                dc.l    byte_49D14
                dc.l    byte_49D33

; =============== S U B R O U T I N E =======================================

sub_497E8:
                move.w  x_pos(a0),d0
                move.w  (Water_level).w,d1
                addq.w  #8,d1
                move.l  #$20000,d2
                lea     (Player_1).w,a1
                bsr.w   sub_49804
                lea     (Player_2).w,a1
; End of function sub_497E8

; =============== S U B R O U T I N E =======================================

sub_49804:
                tst.b   object_control(a1)
                bne.s   locret_4981C
                cmp.w   y_pos(a1),d1
                bhs.s   locret_4981C
                cmp.w   x_pos(a1),d0
                bhs.s   loc_49818
                neg.l   d2

loc_49818:
                add.l   d2,x_pos(a1)

locret_4981C:
                rts
; End of function sub_49804

; =============== S U B R O U T I N E =======================================

sub_4981E:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  $39(a1),d0
                lsl.w   #2,d0
                lea     word_498FE(pc),a1
                lea     (a1,d0.w),a1
                moveq   #$42,d4
                lea     (Player_1).w,a2
                bsr.w   sub_49842
                moveq   #$43,d4
                lea     (Player_2).w,a2
; End of function sub_4981E

; =============== S U B R O U T I N E =======================================

sub_49842:
                movea.w parent3(a0),a3
                btst    #7,status(a3)
                bne.w   sub_4993E
                cmpi.b  #6,routine(a2)
                bhs.w   loc_498EE
                tst.b   invulnerability_timer(a2)
                bne.w   loc_498EE
                tst.b   object_control(a2)
                beq.s   loc_4986E
                tst.b   (a0,d4.w)
                bne.s   loc_498A8

loc_4986E:
                move.w  y_pos(a0),d0
                move.w  y_pos(a2),d2
                add.w   (a1),d0
                cmp.w   d0,d2
                blo.w   locret_4993C
                add.w   2(a1),d0
                cmp.w   d0,d2
                bhs.w   locret_4993C
                move.w  x_pos(a0),d0
                move.w  x_pos(a2),d2
                sub.w   d2,d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   locret_4993C
                tst.b   object_control(a2)
                bne.s   loc_498A8
                bsr.w   sub_49916

loc_498A8:
                move.w  y_pos(a0),d0
                move.w  y_pos(a2),d2
                add.w   (a1)+,d0
                cmp.w   d0,d2
                blo.w   sub_4993E
                move.w  x_pos(a2),d0
                move.w  x_vel(a2),d1
                move.w  #$80,d2
                sub.w   x_pos(a0),d0
                cmpi.w  #-$12,d0
                ble.s   sub_4993E
                cmpi.w  #$12,d0
                bge.s   sub_4993E
                tst.w   d0
                bmi.s   loc_498DA
                neg.w   d2

loc_498DA:
                add.w   d2,d1
                move.w  d1,x_vel(a2)
                ext.l   d1
                lsl.l   #8,d1
                add.l   d1,x_pos(a2)
                subq.w  #2,y_pos(a2)
                rts
; ---------------------------------------------------------------------------

loc_498EE:
                jsr     (Displace_PlayerOffObject).l
                clr.b   (a0,d4.w)
                clr.b   object_control(a2)
                rts
; End of function sub_49842

; ---------------------------------------------------------------------------
word_498FE:
                dc.w    -$18,   $48
                dc.w    -$20,   $58
                dc.w    -$28,   $68
                dc.w    -$30,   $78
                dc.w    -$38,   $88
                dc.w    -$48,   $88

; =============== S U B R O U T I N E =======================================

sub_49916:
                st      (a0,d4.w)
                bset    #Status_InAir,status(a2)
                move.b  #1,object_control(a2)
                move.b  #$18,anim(a2)
                clr.b   spin_dash_flag(a2)
                clr.w   x_vel(a2)
                clr.w   y_vel(a2)
                clr.w   ground_vel(a2)

locret_4993C:
                rts
; End of function sub_49916

; =============== S U B R O U T I N E =======================================

sub_4993E:
                clr.b   (a0,d4.w)
                bset    #Status_InAir,status(a2)
                clr.b   object_control(a2)
; Bug: this causes Super Sonic to partially detransform if sucked up
; As a result, Sonic & Knuckles removes this
                move.b  #0,routine(a2)
                move.b  #2,anim(a2)
                move.w  #-$200,y_vel(a2)
                rts
; End of function sub_4993E

; ---------------------------------------------------------------------------

loc_49960:
                tst.b   $42(a0)
                beq.s   loc_49970
                clr.b   $42(a0)
                lea     (Player_1).w,a2
                bsr.s   sub_4993E

loc_49970:
                tst.b   $43(a0)
                beq.s   locret_49980
                clr.b   $43(a0)
                lea     (Player_2).w,a2
                bsr.s   sub_4993E

locret_49980:
                rts

; =============== S U B R O U T I N E =======================================

sub_49982:
                cmpi.b  #$30,anim_frame(a0)
                bhs.s   locret_499D2
                lea     word_499D4(pc),a1
                lea     (Player_1).w,a2
                bsr.w   sub_4999E
                lea     word_499D4(pc),a1
                lea     (Player_2).w,a2
; End of function sub_49982

; =============== S U B R O U T I N E =======================================

sub_4999E:
                tst.b   object_control(a2)
                bne.s   locret_499D2
                move.w  x_pos(a0),d0
                move.w  x_pos(a2),d1
                add.w   (a1)+,d0
                cmp.w   d0,d1
                blo.s   locret_499D2
                add.w   (a1)+,d0
                cmp.w   d0,d1
                bhs.s   locret_499D2
                move.w  y_pos(a0),d0
                move.w  y_pos(a2),d1
                add.w   (a1)+,d0
                cmp.w   d0,d1
                blo.s   locret_499D2
                add.w   (a1)+,d0
                cmp.w   d0,d1
                bhs.s   locret_499D2
                move.w  #-$800,y_vel(a2)

locret_499D2:
                rts
; End of function sub_4999E

; ---------------------------------------------------------------------------
word_499D4:
                dc.w    -$C,   $18
                dc.w    -$38,   $40

; =============== S U B R O U T I N E =======================================

sub_499DC:
                movea.w parent3(a0),a1
                move.w  x_pos(a0),d0
                move.w  x_vel(a0),d1
                move.w  #$80,d2
                sub.w   x_pos(a1),d0
                tst.w   d0
                bmi.s   loc_499F6
                neg.w   d2

loc_499F6:
                add.w   d2,d1
                move.w  d1,x_vel(a0)
                ext.l   d1
                lsl.l   #8,d1
                add.l   d1,x_pos(a0)
                rts
; End of function sub_499DC

; =============== S U B R O U T I N E =======================================

sub_49A06:
                tst.l   (a0)
                beq.s   locret_49A5C
                tst.b   collision_flags(a0)
                bne.s   locret_49A5C
                tst.b   collision_property(a0)
                beq.s   loc_49A5E
                tst.b   $20(a0)
                bne.s   loc_49A2A
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_49A2A:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_49A3C
                addq.w  #2*3,d0

loc_49A3C:
                lea     word_49A72(pc),a1
                lea     word_49A78(pc,d0.w),a2
                jsr     (CopyWordData_3).l
                subq.b  #1,$20(a0)
                bne.s   locret_49A5C
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_49A5C:
                rts
; ---------------------------------------------------------------------------

loc_49A5E:
                move.l  #Wait_Draw,(a0)
                move.l  #loc_48EF6,$34(a0)
                jmp     (BossDefeated_StopTimer).l
; End of function sub_49A06

; ---------------------------------------------------------------------------
word_49A72:
                dc.w    Normal_palette_line_2+$14, Normal_palette_line_2+$16, Normal_palette_line_2+$1C
word_49A78:
                dc.w    6,   $20,  $624
                dc.w    $EEE,  $EEE,  $EEE

; =============== S U B R O U T I N E =======================================

sub_49A84:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.s   locret_49AB0
                bset    #7,status(a0)
                move.l  #loc_491D2,(a0)
                move.w  #$100,y_vel(a0)
                move.l  #Go_Delete_Sprite_2,$34(a0)
                jsr     (Displace_PlayerOffObject).l

locret_49AB0:
                rts
; End of function sub_49A84

; =============== S U B R O U T I N E =======================================

sub_49AB2:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   locret_49ACA
                bset    #7,status(a0)
                move.b  #4,routine(a0)

locret_49ACA:
                rts
; End of function sub_49AB2

; =============== S U B R O U T I N E =======================================

sub_49ACC:
                move.w  $3A(a0),d0
                sub.w   y_pos(a0),d0
                bcs.s   loc_49AEE
                andi.w  #$F0,d0
                lsr.w   #4,d0
                move.b  d0,$39(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_49AEC
                cmpi.b  #5,d0
                bhs.s   loc_49AEE

locret_49AEC:
                rts
; ---------------------------------------------------------------------------

loc_49AEE:
                movea.l $34(a0),a2
                jmp     (a2)
; End of function sub_49ACC

; ---------------------------------------------------------------------------

sub_49AF4:
                lea     (byte_2EC7A).l,a3
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$80,d3
                moveq   #8-1,d1

loc_49B08:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_49B60
                move.l  #loc_2E9AA,(a1)
                move.l  #Map_HCZWaterWallDebris,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZCutsceneGeyser+$58,2,0),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  #$280,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.w  (a3)+,x_vel(a1)
                move.w  (a3)+,y_vel(a1)
                move.b  d1,mapping_frame(a1)
                dbf     d1,loc_49B08

locret_49B60:
                rts
