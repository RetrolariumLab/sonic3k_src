; Owner: objects/zones/cnz/s3
; Responsibility: Carnival Night barber-pole sprite motion, player rotation and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZBarberPoleSprite:
                tst.b   subtype(a0)
                beq.s   loc_325AA
                move.l  #loc_327E2,(a0)
                bra.w   loc_327E2
; ---------------------------------------------------------------------------

loc_325AA:
                move.l  #loc_325B0,(a0)

loc_325B0:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   sub_325CC
                addq.w  #6,a2
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   sub_325CC
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_325CC:
                btst    d6,status(a0)
                bne.w   loc_326F0
                btst    #Status_OnObj,status(a1)
                bne.w   loc_32664
                moveq   #0,d0
                move.b  x_radius(a1),d0
                neg.w   d0
                add.w   x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$A0,d0
                bhs.s   locret_32662
                subi.w  #$61,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                sub.w   y_pos(a0),d1
                sub.w   d0,d1
                cmpi.w  #$10,d1
                bhs.s   locret_32662
                tst.b   object_control(a1)
                bne.s   locret_32662
                tst.w   (Debug_placement_mode).w
                bne.s   locret_32662
                btst    #Status_InAir,status(a1)
                beq.s   loc_3262C
                tst.w   y_vel(a1)
                bmi.s   locret_32662

loc_3262C:
                move.l  x_pos(a1),(a2)
                move.w  (a2),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                move.w  d0,(a2)
                move.w  #0,4(a2)
                subi.w  #$18,d0
                cmpi.w  #$70,d0
                bhs.s   loc_32652
                move.w  #1,4(a2)

loc_32652:
                bsr.w   sub_32A12
                move.b  #$20,angle(a1)
                move.b  #2,flip_type(a1)

locret_32662:
                rts
; ---------------------------------------------------------------------------

loc_32664:
                moveq   #0,d0
                move.b  x_radius(a1),d0
                neg.w   d0
                add.w   x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$30,d0
                cmpi.w  #$80,d0
                bhs.s   locret_326EE
                subi.w  #$51,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                sub.w   y_pos(a0),d1
                sub.w   d0,d1
                cmpi.w  #$10,d1
                bhs.s   locret_326EE
                tst.b   object_control(a1)
                bne.s   locret_326EE
                btst    #Status_InAir,status(a1)
                beq.s   loc_326AC
                tst.w   y_vel(a1)
                bmi.s   locret_326EE

loc_326AC:
                movea.w interact(a1),a3
                cmpi.l  #loc_325B0,(a3)
                bne.s   locret_326EE
                move.l  x_pos(a1),(a2)
                move.w  (a2),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                move.w  d0,(a2)
                move.w  #0,4(a2)
                subi.w  #$20,d0
                cmpi.w  #$60,d0
                bhs.s   loc_326DE
                move.w  #1,4(a2)

loc_326DE:
                bsr.w   sub_32A12
                move.b  #$20,angle(a1)
                move.b  #2,flip_type(a1)

locret_326EE:
                rts
; ---------------------------------------------------------------------------

loc_326F0:
                tst.w   4(a2)
                bne.s   loc_3270C
                move.w  ground_vel(a1),d0
                bpl.s   loc_326FE
                neg.w   d0

loc_326FE:
                cmpi.w  #$118,d0
                bhs.s   loc_3270C
                bset    #Status_InAir,status(a1)
                bra.s   loc_32734
; ---------------------------------------------------------------------------

loc_3270C:
                btst    #Status_InAir,status(a1)
                bne.s   loc_32734
                move.w  x_vel(a1),d0
                ext.l   d0
                lsl.l   #6,d0
                move.l  d0,d1
                add.l   d0,d0
                add.l   d1,d0
                add.l   d0,(a2)
                moveq   #0,d0
                move.b  x_radius(a1),d0
                neg.w   d0
                add.w   (a2),d0
                cmpi.w  #$A0,d0
                blo.s   loc_32752

loc_32734:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                andi.w  #drawing_mask,art_tile(a1)
                rts
; ---------------------------------------------------------------------------

loc_32752:
                btst    #Status_OnObj,status(a1)
                beq.w   locret_327E0
                move.w  d0,d2
                subi.b  #$10,d0
                bcc.s   loc_3276C
                move.w  #0,4(a2)
                moveq   #0,d0

loc_3276C:
                cmpi.b  #$80,d0
                blo.s   loc_3277C
                move.w  #0,4(a2)
                move.w  #$80,d0

loc_3277C:
                andi.w  #drawing_mask,art_tile(a1)
                cmpi.b  #$34,d0
                bhs.s   loc_3278E
                ori.w   #high_priority,art_tile(a1)

loc_3278E:
                tst.w   4(a2)
                beq.s   loc_32796
                moveq   #0,d0

loc_32796:
                add.w   d0,d0
                move.b  d0,flip_angle(a1)
                jsr     (GetSineCosine).l
                move.w  d1,d4
                asr.w   #4,d1
                move.w  d1,d3
                add.w   d2,d1
                add.w   x_pos(a0),d1
                subi.w  #$50,d1
                moveq   #0,d0
                move.b  x_radius(a1),d0
                muls.w  d4,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                move.w  d2,d0
                subi.w  #$51,d0
                move.w  y_pos(a0),d2
                sub.w   d3,d2
                add.w   d0,d2
                moveq   #0,d1
                move.b  y_radius(a1),d1
                muls.w  d4,d1
                asr.w   #8,d1
                sub.w   d1,d2
                move.w  d2,y_pos(a1)

locret_327E0:
                rts
; End of function sub_325CC

; ---------------------------------------------------------------------------

loc_327E2:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   sub_327FE
                addq.w  #6,a2
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   sub_327FE
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_327FE:
                btst    d6,status(a0)
                bne.w   loc_3291E
                btst    #Status_OnObj,status(a1)
                bne.w   loc_32894
                moveq   #0,d0
                move.b  x_radius(a1),d0
                add.w   x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$60,d0
                cmpi.w  #$A0,d0
                bhs.s   locret_32892
                subi.w  #$3E,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d0,d1
                cmpi.w  #$10,d1
                bhs.s   locret_32892
                tst.b   object_control(a1)
                bne.s   locret_32892
                tst.w   (Debug_placement_mode).w
                bne.s   locret_32892
                btst    #Status_InAir,status(a1)
                beq.s   loc_3285C
                tst.w   y_vel(a1)
                bmi.s   locret_32892

loc_3285C:
                move.l  x_pos(a1),(a2)
                move.w  (a2),d0
                sub.w   x_pos(a0),d0
                addi.w  #$60,d0
                move.w  d0,(a2)
                move.w  #0,4(a2)
                subi.w  #$18,d0
                cmpi.w  #$70,d0
                bhs.s   loc_32882
                move.w  #1,4(a2)

loc_32882:
                bsr.w   sub_32A12
                move.b  #$E0,angle(a1)
                move.b  #3,flip_type(a1)

locret_32892:
                rts
; ---------------------------------------------------------------------------

loc_32894:
                moveq   #0,d0
                move.b  x_radius(a1),d0
                add.w   x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$50,d0
                cmpi.w  #$80,d0
                bhs.s   locret_3291C
                subi.w  #$2E,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d0,d1
                cmpi.w  #$10,d1
                bhs.s   locret_3291C
                tst.b   object_control(a1)
                bne.s   locret_3291C
                btst    #Status_InAir,status(a1)
                beq.s   loc_328DA
                tst.w   y_vel(a1)
                bmi.s   locret_3291C

loc_328DA:
                movea.w interact(a1),a3
                cmpi.l  #loc_327E2,(a3)
                bne.s   locret_3291C
                move.l  x_pos(a1),(a2)
                move.w  (a2),d0
                sub.w   x_pos(a0),d0
                addi.w  #$60,d0
                move.w  d0,(a2)
                move.w  #0,4(a2)
                subi.w  #$20,d0
                cmpi.w  #$60,d0
                bhs.s   loc_3290C
                move.w  #1,4(a2)

loc_3290C:
                bsr.w   sub_32A12
                move.b  #$E0,angle(a1)
                move.b  #3,flip_type(a1)

locret_3291C:
                rts
; ---------------------------------------------------------------------------

loc_3291E:
                tst.w   4(a2)
                bne.s   loc_3293A
                move.w  ground_vel(a1),d0
                bpl.s   loc_3292C
                neg.w   d0

loc_3292C:
                cmpi.w  #$118,d0
                bhs.s   loc_3293A
                bset    #Status_InAir,status(a1)
                bra.s   loc_32960
; ---------------------------------------------------------------------------

loc_3293A:
                btst    #Status_InAir,status(a1)
                bne.s   loc_32960
                move.w  x_vel(a1),d0
                ext.l   d0
                lsl.l   #6,d0
                move.l  d0,d1
                add.l   d0,d0
                add.l   d1,d0
                add.l   d0,(a2)
                moveq   #0,d0
                move.b  x_radius(a1),d0
                add.w   (a2),d0
                cmpi.w  #$A0,d0
                blo.s   loc_3297E

loc_32960:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                andi.w  #drawing_mask,art_tile(a1)
                rts
; ---------------------------------------------------------------------------

loc_3297E:
                btst    #Status_OnObj,status(a1)
                beq.w   locret_32A10
                move.w  d0,d2
                subi.b  #$10,d0
                bcc.s   loc_32998
                move.w  #0,4(a2)
                moveq   #0,d0

loc_32998:
                cmpi.b  #$80,d0
                blo.s   loc_329A8
                move.w  #0,4(a2)
                move.w  #$80,d0

loc_329A8:
                andi.w  #drawing_mask,art_tile(a1)
                cmpi.b  #$4C,d0
                blo.s   loc_329BA
                ori.w   #high_priority,art_tile(a1)

loc_329BA:
                tst.w   4(a2)
                beq.s   loc_329C2
                moveq   #0,d0

loc_329C2:
                neg.b   d0
                add.w   d0,d0
                move.b  d0,flip_angle(a1)
                jsr     (GetSineCosine).l
                move.w  d1,d4
                asr.w   #4,d1
                move.w  d1,d3
                neg.w   d1
                add.w   d2,d1
                add.w   x_pos(a0),d1
                subi.w  #$50,d1
                moveq   #0,d0
                move.b  x_radius(a1),d0
                muls.w  d4,d0
                asr.w   #8,d0
                sub.w   d0,d1
                move.w  d1,x_pos(a1)
                move.w  d2,d0
                subi.w  #$4E,d0
                move.w  y_pos(a0),d2
                sub.w   d3,d2
                sub.w   d0,d2
                moveq   #0,d1
                move.b  y_radius(a1),d1
                muls.w  d4,d1
                asr.w   #8,d1
                sub.w   d1,d2
                move.w  d2,y_pos(a1)

locret_32A10:
                rts
; End of function sub_327FE

; =============== S U B R O U T I N E =======================================

sub_32A12:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_32A22
                movea.w interact(a1),a3
                bclr    d6,status(a3)

loc_32A22:
                move.w  a0,interact(a1)
                btst    #Status_InAir,status(a1)
                beq.s   loc_32A5E
                move.w  #0,y_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                move.l  a0,-(sp)
                movea.l a1,a0
                move.w  a0,d1
                subi.w  #Player_1,d1
                bne.s   loc_32A56
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_32A56
                jsr     (Player_TouchFloor).l
                bra.s   loc_32A5C
; ---------------------------------------------------------------------------

loc_32A56:
                jsr     (Tails_TouchFloor).l

loc_32A5C:
                movea.l (sp)+,a0

loc_32A5E:
                bset    #Status_OnObj,status(a1)
                bclr    #Status_InAir,status(a1)
                bset    d6,status(a0)
                rts
; End of function sub_32A12
