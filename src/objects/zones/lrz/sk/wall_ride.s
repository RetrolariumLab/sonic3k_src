; Owner: objects/zones/lrz/sk
; Responsibility: Wall-riding player contact, movement, character pose and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZWallRide:
                move.b  #$D0,width_pixels(a0)
                move.l  #loc_42556,(a0)

loc_42556:
                bsr.s   sub_4255E
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_4255E:
                lea     (Player_1).w,a1
                lea     $30(a0),a2
                moveq   #p1_standing_bit,d6
                bsr.s   sub_42574
                lea     (Player_2).w,a1
                lea     $34(a0),a2
; Bug: if player 1 was riding the object, then d6 may have become dirty from
; a call to Perform_Player_DPLC, causing player 2 to behave erratically
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function sub_4255E

; =============== S U B R O U T I N E =======================================

sub_42574:
                btst    d6,status(a0)
                bne.w   loc_426B0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   locret_425E8
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   locret_425E8
                btst    #0,status(a0)
                bne.s   loc_425EA
                tst.b   object_control(a1)
                bne.s   locret_425E8
                btst    #Status_InAir,status(a1)
                bne.s   locret_425E8
                tst.w   ground_vel(a1)
                bmi.w   locret_425E8
                cmpi.w  #$400,ground_vel(a1)
                bge.w   loc_425CE
                move.w  #$400,ground_vel(a1)

loc_425CE:
                bsr.s   sub_42636
                move.l  #0,(a2)
                bclr    #Status_Facing,status(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  #$43,object_control(a1)

locret_425E8:
                rts
; ---------------------------------------------------------------------------

loc_425EA:
                tst.b   object_control(a1)
                bne.s   locret_425E8
                btst    #Status_InAir,status(a1)
                bne.s   locret_425E8
                tst.w   ground_vel(a1)
                bpl.w   locret_425E8
                cmpi.w  #-$400,ground_vel(a1)
                ble.w   loc_42610
                move.w  #-$400,ground_vel(a1)

loc_42610:
                bsr.s   sub_42636
                move.l  #0,(a2)
                neg.w   ground_vel(a1)
                bset    #Status_Facing,status(a1)
                andi.b  #$FC,render_flags(a1)
                ori.b   #1,render_flags(a1)
                move.b  #$43,object_control(a1)
                rts
; End of function sub_42574

; =============== S U B R O U T I N E =======================================

sub_42636:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_42646
                movea.w interact(a1),a3
                bclr    d6,status(a3)

loc_42646:
                move.w  a0,interact(a1)
                bset    d6,status(a0)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                andi.b  #$89,status(a1)
                bset    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)
                move.w  #0,(Chain_bonus_counter).w
                move.b  #0,angle(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,flip_type(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #0,scroll_delay_counter(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,anim(a1)
                rts
; End of function sub_42636

; ---------------------------------------------------------------------------

loc_426B0:
                tst.w   (Debug_placement_mode).w
                beq.s   loc_426F8

loc_426B6:
                andi.b  #$80,status(a1)
                bset    #Status_InAir,status(a1)
                btst    #Status_Facing,status(a0)
                bne.s   loc_426DA
                bclr    #Status_InAir,status(a1)
                bset    #Status_Facing,status(a1)
                neg.w   ground_vel(a1)

loc_426DA:
                bclr    d6,status(a0)
                move.w  #1,anim(a1)                     ; and prev_anim
                move.b  #0,object_control(a1)
                move.w  ground_vel(a1),x_vel(a1)
                move.w  #0,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_426F8:
                move.w  ground_vel(a1),d0
                ext.l   d0
                lsl.l   #7,d0
                add.l   d0,(a2)
                bmi.s   loc_426B6
                cmpi.w  #$100,(a2)
                bhs.s   loc_426B6
                cmpi.w  #$1000,ground_vel(a1)
                bge.s   loc_42718
                addi.w  #$10,ground_vel(a1)

loc_42718:
                move.w  x_pos(a1),d2
                move.w  (a2),d0
                lsr.w   #1,d0
                jsr     (GetSineCosine).l
                muls.w  #$A00,d0
                asl.l   #4,d0
                swap    d0
                move.w  #$165,d2
                btst    #0,status(a0)
                beq.s   loc_42740
                move.w  #$142,d2
                neg.w   d0

loc_42740:
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                sub.w   d2,d0
                asl.w   #8,d0
                move.w  d0,x_vel(a1)
                neg.w   d1
                addi.w  #$100,d1
                lsr.w   #1,d1
                mulu.w  d2,d1
                lsr.l   #8,d1
                move.w  d1,d0
                move.w  y_pos(a1),d2
                add.w   y_pos(a0),d0
                move.w  d0,y_pos(a1)
                sub.w   d2,d0
                asl.w   #8,d0
                move.w  d0,y_vel(a1)
                moveq   #0,d0
                move.w  (a2),d0
                lsr.w   #1,d0
                andi.w  #$FF,d0
                divu.w  #$16,d0
                move.b  RawAni_42792(pc,d0.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; ---------------------------------------------------------------------------
RawAni_42792:
                dc.b    $EF, $DF, $E0, $E1, $E2, $E3, $F5, $F4, $F3, $F2, $F1, $F0
                even
