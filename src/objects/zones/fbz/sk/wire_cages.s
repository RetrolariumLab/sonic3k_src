; Owner: objects/zones/fbz/sk
; Responsibility: Moving and stationary wire-cage variants, player capture, constrained motion and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZWireCage:
                move.b  subtype(a0),d0
                bpl.s   loc_39F48
                andi.w  #$7F,d0
                lsl.w   #3,d0
                move.w  d0,subtype(a0)
                move.l  #loc_3A0B0,(a0)
                bra.w   loc_3A0B0
; ---------------------------------------------------------------------------

loc_39F48:
                andi.w  #$7F,d0
                lsl.w   #3,d0
                move.w  d0,subtype(a0)
                move.l  #loc_39F58,(a0)

loc_39F58:
                move.w  subtype(a0),d4
                move.w  d4,d5
                add.w   d5,d5
                lea     (Player_1).w,a1
                lea     (_unkF7B0+0).w,a2
                moveq   #p1_standing_bit,d6
                bsr.s   sub_39F7E
                lea     (Player_2).w,a1
                lea     (_unkF7B0+1).w,a2
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   sub_39F7E
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_39F7E:
                btst    d6,status(a0)
                bne.w   loc_3A01A
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d4,d0
                cmp.w   d5,d0
                bhs.w   locret_3A018
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$50,d0
                cmpi.w  #$18,d0
                bhs.s   loc_39FAE
                move.b  #$28,2(a2)

loc_39FAE:
                tst.b   2(a2)
                beq.s   loc_39FBA
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_39FBA:
                move.w  y_pos(a0),d0
                addi.w  #$3C,d0
                move.w  y_pos(a1),d2
                move.b  y_radius(a1),d1
                ext.w   d1
                add.w   d2,d1
                addq.w  #4,d1
                sub.w   d1,d0
                bhi.s   locret_3A018
                cmpi.w  #-$10,d0
                blo.s   locret_3A018
                cmpi.b  #6,routine(a1)
                bhs.s   locret_3A018
                tst.w   (Debug_placement_mode).w
                bne.s   locret_3A018
                add.w   d0,d2
                addq.w  #3,d2
                move.w  d2,y_pos(a1)
                jsr     (RideObject_SetRide).l
                move.b  #$80,flip_type(a1)
                move.w  #1,anim(a1)
                move.b  #0,(a2)
                move.b  #0,2(a2)
                tst.w   ground_vel(a1)
                bne.s   locret_3A018
                move.w  #1,ground_vel(a1)

locret_3A018:
                rts
; ---------------------------------------------------------------------------

loc_3A01A:
                btst    #1,status(a1)
                bne.s   loc_3A054
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d4,d0
                cmp.w   d5,d0
                blo.s   loc_3A06E

loc_3A030:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                bset    #1,status(a1)
                move.b  #0,flip_type(a1)
                rts
; ---------------------------------------------------------------------------

loc_3A054:
                move.b  (a2),d0
                addi.b  #$20,d0
                cmpi.b  #$40,d0
                bhs.s   loc_3A066
                asr     y_vel(a1)
                bra.s   loc_3A030
; ---------------------------------------------------------------------------

loc_3A066:
                move.w  #0,y_vel(a1)
                bra.s   loc_3A030
; ---------------------------------------------------------------------------

loc_3A06E:
                btst    #Status_OnObj,status(a1)
                beq.s   locret_3A018
                move.b  (a2),d0
                jsr     (GetSineCosine).l
                muls.w  #$2800,d1
                swap    d1
                move.w  y_pos(a0),d2
                add.w   d1,d2
                moveq   #0,d1
                move.b  y_radius(a1),d1
                subi.w  #$13,d1
                sub.w   d1,d2
                move.w  d2,y_pos(a1)
                move.b  (a2),d0
                move.b  d0,flip_angle(a1)
                addq.b  #4,(a2)
                tst.w   ground_vel(a1)
                bne.s   locret_3A0AE
                move.w  #1,ground_vel(a1)

locret_3A0AE:
                rts
; End of function sub_39F7E

; ---------------------------------------------------------------------------

loc_3A0B0:
                move.w  subtype(a0),d4
                move.w  d4,d5
                add.w   d5,d5
                lea     (Player_1).w,a1
                lea     (_unkF7B0+0).w,a2
                moveq   #p1_standing_bit,d6
                bsr.s   sub_3A0D6
                lea     (Player_2).w,a1
                lea     (_unkF7B0+1).w,a2
; Bug: if player 1 was riding the object, then d6 may have become dirty from
; a call to Perform_Player_DPLC, causing player 2 to behave erratically
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   sub_3A0D6
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_3A0D6:
                btst    d6,status(a0)
                bne.w   loc_3A18E
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$80,d0
                cmpi.w  #$100,d0
                bhs.w   locret_3A18C
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d4,d1
                cmp.w   d5,d1
                bhs.w   locret_3A18C
                cmpi.b  #6,routine(a1)
                bhs.w   locret_3A18C
                tst.w   (Debug_placement_mode).w
                bne.w   locret_3A18C
                tst.b   object_control(a1)
                bmi.s   locret_3A18C
                cmpi.w  #$20,d0
                blo.s   loc_3A126
                cmpi.w  #$E0,d0
                blo.s   locret_3A18C

loc_3A126:
                bsr.w   sub_33C34
                move.b  #-$40,angle(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                move.b  #0,(a2)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcc.s   loc_3A14E
                move.b  #$80,(a2)

loc_3A14E:
                move.w  y_vel(a1),ground_vel(a1)
                neg.w   ground_vel(a1)
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                bcc.s   loc_3A16C
                move.b  #$40,angle(a1)
                neg.w   ground_vel(a1)

loc_3A16C:
                bset    #6,object_control(a1)
                bset    #1,object_control(a1)
                move.w  #1,anim(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,2(a2)
                bra.s   loc_3A18E
; ---------------------------------------------------------------------------

locret_3A18C:
                rts
; ---------------------------------------------------------------------------

loc_3A18E:
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d4,d1
                cmp.w   d5,d1
                blo.s   loc_3A1C6
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #1,flip_angle(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                bset    #Status_InAir,status(a1)
                rts
; ---------------------------------------------------------------------------

loc_3A1C6:
                btst    #Status_OnObj,status(a1)
                beq.s   locret_3A18C
                bclr    #1,render_flags(a1)
                tst.w   y_vel(a1)
                bmi.s   loc_3A1E0
                bset    #1,render_flags(a1)

loc_3A1E0:
                move.b  (a2),d0
                jsr     (GetSineCosine).l
                muls.w  #$6800,d1
                swap    d1
                move.w  x_pos(a0),d2
                add.w   d1,d2
                moveq   #0,d1
                move.b  y_radius(a1),d1
                subi.w  #$13,d1
                sub.w   d1,d2
                move.w  d2,x_pos(a1)
                moveq   #0,d2
                move.b  (a2),d2
                addq.b  #4,(a2)
                divu.w  #$B,d2
                move.b  RawAni_3A220(pc,d2.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; End of function sub_3A0D6

; ---------------------------------------------------------------------------
RawAni_3A220:
                dc.b    $6D, $6D, $6E, $6E, $6F, $6F, $70, $70, $71, $71, $72, $72, $73, $73, $74, $74, $75, $75, $76, $76
                dc.b    $77, $77, $6C, $6C, $6D, $6D
                even
; ---------------------------------------------------------------------------

Obj_FBZWireCageStationary:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #8,d0
                move.w  d0,$40(a0)
                lsl.w   #2,d0
                move.w  d0,$42(a0)
                move.l  #loc_3A252,(a0)

loc_3A252:
                lea     (Player_1).w,a1
                lea     $30(a0),a2
                moveq   #p1_standing_bit,d6
                bsr.s   sub_3A270
                lea     (Player_2).w,a1
                lea     $38(a0),a2
; Bug: if player 1 was riding the object, then d6 may have become dirty from
; a call to Perform_Player_DPLC, causing player 2 to behave erratically
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   sub_3A270
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_3A270:
                btst    d6,status(a0)
                bne.w   loc_3A314
                btst    #Status_InAir,status(a1)
                bne.w   locret_3A312
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                tst.w   x_vel(a1)
                bmi.s   loc_3A2A2
                cmpi.w  #-$B0,d0
                bgt.w   locret_3A312
                cmpi.w  #-$C0,d0
                blt.s   locret_3A312
                moveq   #0,d2
                bra.s   loc_3A2B0
; ---------------------------------------------------------------------------

loc_3A2A2:
                cmpi.w  #$B0,d0
                blt.s   locret_3A312
                cmpi.w  #$C0,d0
                bgt.s   locret_3A312
                moveq   #1,d2

loc_3A2B0:
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$10,d1
                cmpi.w  #$20,d1
                bhs.s   locret_3A312
                move.w  ground_vel(a1),d0
                bpl.s   loc_3A2CA
                neg.w   d0

loc_3A2CA:
                cmpi.w  #$400,d0
                blo.s   locret_3A312
                tst.b   object_control(a1)
                bne.s   locret_3A312
                moveq   #0,d3
                tst.b   subtype(a0)
                beq.s   loc_3A2F0
                btst    #0,status(a0)
                bne.s   loc_3A2EC
                tst.w   d2
                bne.s   locret_3A312
                bra.s   loc_3A2F0
; ---------------------------------------------------------------------------

loc_3A2EC:
                tst.w   d2
                beq.s   locret_3A312

loc_3A2F0:
                move.l  #0,(a2)
                move.b  d2,4(a2)
                move.w  d3,6(a2)
                bset    #Status_InAir,status(a1)
                jsr     (RideObject_SetRide).l
                move.b  #$42,object_control(a1)
                bra.s   loc_3A314
; ---------------------------------------------------------------------------

locret_3A312:
                rts
; ---------------------------------------------------------------------------

loc_3A314:
                move.w  ground_vel(a1),d0
                bpl.s   loc_3A31C
                neg.w   d0

loc_3A31C:
                cmpi.w  #$400,d0
                blo.s   loc_3A36E
                btst    #Status_InAir,status(a1)
                bne.s   loc_3A36E
                tst.l   (a2)
                bne.w   loc_3A480
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$C0,d0
                bmi.s   loc_3A344
                cmpi.w  #$180,d0
                blo.s   loc_3A3B4

loc_3A344:
                bclr    #Status_Roll,status(a1)
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                move.w  #1,anim(a1)
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_3A36E:
                asr     x_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_Roll,status(a1)
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                move.w  #1,anim(a1)
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #-$40,flip_angle(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                rts
; ---------------------------------------------------------------------------

loc_3A3B4:
                btst    #Status_OnObj,status(a1)
                beq.w   locret_3A312
                tst.b   subtype(a0)
                beq.s   loc_3A426
                tst.b   4(a2)
                bne.s   loc_3A3F2
                cmpi.w  #$C0,d0
                blo.s   loc_3A426
                tst.w   ground_vel(a1)
                bmi.s   loc_3A426
                subi.w  #$C0,d0
                move.w  d0,(a2)
                move.w  #0,2(a2)
                bset    #0,render_flags(a1)
                bset    #1,render_flags(a1)
                bra.w   loc_3A480
; ---------------------------------------------------------------------------

loc_3A3F2:
                cmpi.w  #$C0,d0
                bhs.s   loc_3A426
                tst.w   ground_vel(a1)
                bpl.s   loc_3A426
                subi.w  #$C0,d0
                add.w   $42(a0),d0
                move.w  d0,(a2)
                move.w  #0,2(a2)
                move.w  $40(a0),d0
                neg.w   d0
                move.w  d0,6(a2)
                bclr    #0,render_flags(a1)
                bclr    #1,render_flags(a1)
                bra.s   loc_3A480
; ---------------------------------------------------------------------------

loc_3A426:
                lsr.w   #5,d0
                andi.w  #$F,d0
                move.b  byte_3A468(pc,d0.w),d1
                move.b  RawAni_3A474(pc,d0.w),mapping_frame(a1)
                ext.w   d1
                move.w  y_pos(a0),d2
                add.w   6(a2),d2
                add.w   d1,d2
                moveq   #0,d1
                move.b  y_radius(a1),d1
                subi.w  #$13,d1
                sub.w   d1,d2
                move.w  d2,y_pos(a1)
                moveq   #0,d0
                move.b  d0,anim(a1)
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------
byte_3A468:
                dc.b    4,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   4
RawAni_3A474:
                dc.b    $49, $54, $53, $52, $53, $52, $53, $52, $53, $52, $54, $49
                even
; ---------------------------------------------------------------------------

loc_3A480:
                move.w  ground_vel(a1),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,(a2)
                bpl.s   loc_3A4B2
                move.l  #0,(a2)
                move.b  #0,4(a2)
                move.w  $40(a0),d0
                neg.w   d0
                move.w  d0,6(a2)
                bset    #0,render_flags(a1)
                bclr    #1,render_flags(a1)
                bra.w   loc_3A314
; ---------------------------------------------------------------------------

loc_3A4B2:
                move.w  (a2),d0
                cmp.w   $42(a0),d0
                blo.s   loc_3A4DC
                move.l  #0,(a2)
                move.b  #1,4(a2)
                move.w  $40(a0),6(a2)
                bclr    #0,render_flags(a1)
                bclr    #1,render_flags(a1)
                bra.w   loc_3A314
; ---------------------------------------------------------------------------

loc_3A4DC:
                move.w  x_pos(a1),d2
                move.w  (a2),d0
                lsr.w   #1,d0
                jsr     (GetSineCosine).l
                muls.w  #$6800,d0
                swap    d0
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                sub.w   d2,d0
                asl.w   #8,d0
                move.w  d0,x_vel(a1)
                move.w  y_pos(a1),d2
                move.w  (a2),d0
                lsr.w   #2,d0
                add.w   6(a2),d0
                add.w   y_pos(a0),d0
                move.w  d0,y_pos(a1)
                sub.w   d2,d0
                asl.w   #8,d0
                move.w  d0,y_vel(a1)
                moveq   #0,d0
                move.w  (a2),d0
                lsr.w   #1,d0
                andi.w  #$FF,d0
                tst.w   ground_vel(a1)
                bpl.s   loc_3A52E
                neg.b   d0

loc_3A52E:
                divu.w  #$B,d0
                move.b  RawAni_3A548(pc,d0.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  d0,anim(a1)
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; End of function sub_3A270

; ---------------------------------------------------------------------------
RawAni_3A548:
                dc.b    $70, $70, $71, $71, $72, $72, $73, $73, $74, $74, $75, $75, $76, $76, $77, $77, $6C, $6C, $6D, $6D
                dc.b    $6E, $6E, $6F, $6F, $70, $70, $71, $71, $72, $72, $73, $73, $74, $74, $75, $75
                even
