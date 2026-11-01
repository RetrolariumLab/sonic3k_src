; Owner: objects/zones/cnz/sk
; Responsibility: Carnival Night barber-pole sprite motion, player rotation and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZBarberPoleSprite:
                tst.b   subtype(a0)
                beq.s   loc_33370
                move.l  #loc_335A8,(a0)
                bra.w   loc_335A8
; ---------------------------------------------------------------------------

loc_33370:
                move.l  #loc_33376,(a0)

loc_33376:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerOnCnzFallingBarberPole
                addq.w  #6,a2
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   UpdatePlayerOnCnzFallingBarberPole
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnCnzFallingBarberPole:
                btst    d6,status(a0)
                bne.w   loc_334B6
                btst    #Status_OnObj,status(a1)
                bne.w   loc_3342A
                moveq   #0,d0
                move.b  x_radius(a1),d0
                neg.w   d0
                add.w   x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$A0,d0
                bhs.s   locret_33428
                subi.w  #$61,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                sub.w   y_pos(a0),d1
                sub.w   d0,d1
                cmpi.w  #$10,d1
                bhs.s   locret_33428
                tst.b   object_control(a1)
                bne.s   locret_33428
                tst.w   (Debug_placement_mode).w
                bne.s   locret_33428
                btst    #Status_InAir,status(a1)
                beq.s   loc_333F2
                tst.w   y_vel(a1)
                bmi.s   locret_33428

loc_333F2:
                move.l  x_pos(a1),(a2)
                move.w  (a2),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                move.w  d0,(a2)
                move.w  #0,4(a2)
                subi.w  #$18,d0
                cmpi.w  #$70,d0
                bhs.s   loc_33418
                move.w  #1,4(a2)

loc_33418:
                bsr.w   AttachPlayerToCnzBarberPole
                move.b  #$20,angle(a1)
                move.b  #2,flip_type(a1)

locret_33428:
                rts
; ---------------------------------------------------------------------------

loc_3342A:
                moveq   #0,d0
                move.b  x_radius(a1),d0
                neg.w   d0
                add.w   x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$30,d0
                cmpi.w  #$80,d0
                bhs.s   locret_334B4
                subi.w  #$51,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                sub.w   y_pos(a0),d1
                sub.w   d0,d1
                cmpi.w  #$10,d1
                bhs.s   locret_334B4
                tst.b   object_control(a1)
                bne.s   locret_334B4
                btst    #Status_InAir,status(a1)
                beq.s   loc_33472
                tst.w   y_vel(a1)
                bmi.s   locret_334B4

loc_33472:
                movea.w interact(a1),a3
                cmpi.l  #loc_33376,(a3)
                bne.s   locret_334B4
                move.l  x_pos(a1),(a2)
                move.w  (a2),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                move.w  d0,(a2)
                move.w  #0,4(a2)
                subi.w  #$20,d0
                cmpi.w  #$60,d0
                bhs.s   loc_334A4
                move.w  #1,4(a2)

loc_334A4:
                bsr.w   AttachPlayerToCnzBarberPole
                move.b  #$20,angle(a1)
                move.b  #2,flip_type(a1)

locret_334B4:
                rts
; ---------------------------------------------------------------------------

loc_334B6:
                tst.w   4(a2)
                bne.s   loc_334D2
                move.w  ground_vel(a1),d0
                bpl.s   loc_334C4
                neg.w   d0

loc_334C4:
                cmpi.w  #$118,d0
                bhs.s   loc_334D2
                bset    #Status_InAir,status(a1)
                bra.s   loc_334FA
; ---------------------------------------------------------------------------

loc_334D2:
                btst    #Status_InAir,status(a1)
                bne.s   loc_334FA
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
                blo.s   loc_33518

loc_334FA:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                andi.w  #drawing_mask,art_tile(a1)
                rts
; ---------------------------------------------------------------------------

loc_33518:
                btst    #Status_OnObj,status(a1)
                beq.w   locret_335A6
                move.w  d0,d2
                subi.b  #$10,d0
                bcc.s   loc_33532
                move.w  #0,4(a2)
                moveq   #0,d0

loc_33532:
                cmpi.b  #$80,d0
                blo.s   loc_33542
                move.w  #0,4(a2)
                move.w  #$80,d0

loc_33542:
                andi.w  #drawing_mask,art_tile(a1)
                cmpi.b  #$34,d0
                bhs.s   loc_33554
                ori.w   #high_priority,art_tile(a1)

loc_33554:
                tst.w   4(a2)
                beq.s   loc_3355C
                moveq   #0,d0

loc_3355C:
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

locret_335A6:
                rts
; End of function UpdatePlayerOnCnzFallingBarberPole

; ---------------------------------------------------------------------------

loc_335A8:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerOnCnzRisingBarberPole
                addq.w  #6,a2
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   UpdatePlayerOnCnzRisingBarberPole
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnCnzRisingBarberPole:
                btst    d6,status(a0)
                bne.w   loc_336E4
                btst    #Status_OnObj,status(a1)
                bne.w   loc_3365A
                moveq   #0,d0
                move.b  x_radius(a1),d0
                add.w   x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$60,d0
                cmpi.w  #$A0,d0
                bhs.s   locret_33658
                subi.w  #$3E,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d0,d1
                cmpi.w  #$10,d1
                bhs.s   locret_33658
                tst.b   object_control(a1)
                bne.s   locret_33658
                tst.w   (Debug_placement_mode).w
                bne.s   locret_33658
                btst    #Status_InAir,status(a1)
                beq.s   loc_33622
                tst.w   y_vel(a1)
                bmi.s   locret_33658

loc_33622:
                move.l  x_pos(a1),(a2)
                move.w  (a2),d0
                sub.w   x_pos(a0),d0
                addi.w  #$60,d0
                move.w  d0,(a2)
                move.w  #0,4(a2)
                subi.w  #$18,d0
                cmpi.w  #$70,d0
                bhs.s   loc_33648
                move.w  #1,4(a2)

loc_33648:
                bsr.w   AttachPlayerToCnzBarberPole
                move.b  #$E0,angle(a1)
                move.b  #3,flip_type(a1)

locret_33658:
                rts
; ---------------------------------------------------------------------------

loc_3365A:
                moveq   #0,d0
                move.b  x_radius(a1),d0
                add.w   x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$50,d0
                cmpi.w  #$80,d0
                bhs.s   locret_336E2
                subi.w  #$2E,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d0,d1
                cmpi.w  #$10,d1
                bhs.s   locret_336E2
                tst.b   object_control(a1)
                bne.s   locret_336E2
                btst    #Status_InAir,status(a1)
                beq.s   loc_336A0
                tst.w   y_vel(a1)
                bmi.s   locret_336E2

loc_336A0:
                movea.w interact(a1),a3
                cmpi.l  #loc_335A8,(a3)
                bne.s   locret_336E2
                move.l  x_pos(a1),(a2)
                move.w  (a2),d0
                sub.w   x_pos(a0),d0
                addi.w  #$60,d0
                move.w  d0,(a2)
                move.w  #0,4(a2)
                subi.w  #$20,d0
                cmpi.w  #$60,d0
                bhs.s   loc_336D2
                move.w  #1,4(a2)

loc_336D2:
                bsr.w   AttachPlayerToCnzBarberPole
                move.b  #$E0,angle(a1)
                move.b  #3,flip_type(a1)

locret_336E2:
                rts
; ---------------------------------------------------------------------------

loc_336E4:
                tst.w   4(a2)
                bne.s   loc_33700
                move.w  ground_vel(a1),d0
                bpl.s   loc_336F2
                neg.w   d0

loc_336F2:
                cmpi.w  #$118,d0
                bhs.s   loc_33700
                bset    #Status_InAir,status(a1)
                bra.s   loc_33726
; ---------------------------------------------------------------------------

loc_33700:
                btst    #Status_InAir,status(a1)
                bne.s   loc_33726
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
                blo.s   loc_33744

loc_33726:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                andi.w  #drawing_mask,art_tile(a1)
                rts
; ---------------------------------------------------------------------------

loc_33744:
                btst    #Status_OnObj,status(a1)
                beq.w   locret_337D6
                move.w  d0,d2
                subi.b  #$10,d0
                bcc.s   loc_3375E
                move.w  #0,4(a2)
                moveq   #0,d0

loc_3375E:
                cmpi.b  #$80,d0
                blo.s   loc_3376E
                move.w  #0,4(a2)
                move.w  #$80,d0

loc_3376E:
                andi.w  #drawing_mask,art_tile(a1)
                cmpi.b  #$4C,d0
                blo.s   loc_33780
                ori.w   #high_priority,art_tile(a1)

loc_33780:
                tst.w   4(a2)
                beq.s   loc_33788
                moveq   #0,d0

loc_33788:
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

locret_337D6:
                rts
; End of function UpdatePlayerOnCnzRisingBarberPole

; =============== S U B R O U T I N E =======================================

AttachPlayerToCnzBarberPole:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_337E8
                movea.w interact(a1),a3
                bclr    d6,status(a3)

loc_337E8:
                move.w  a0,interact(a1)
                btst    #Status_InAir,status(a1)
                beq.s   loc_33824
                move.w  #0,y_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                move.l  a0,-(sp)
                movea.l a1,a0
                move.w  a0,d1
                subi.w  #Player_1,d1
                bne.s   loc_3381C
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_3381C
                jsr     (Player_TouchFloor).l
                bra.s   loc_33822
; ---------------------------------------------------------------------------

loc_3381C:
                jsr     (Tails_TouchFloor).l

loc_33822:
                movea.l (sp)+,a0

loc_33824:
                bset    #Status_OnObj,status(a1)
                bclr    #Status_InAir,status(a1)
                bset    d6,status(a0)
                rts
; End of function AttachPlayerToCnzBarberPole
