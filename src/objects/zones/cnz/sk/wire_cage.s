; Owner: objects/zones/cnz/sk
; Responsibility: Carnival Night wire-cage player capture, spin, motion and release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_CNZWireCage:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$38(a0)
                add.w   d0,d0
                move.w  d0,$3A(a0)
                moveq   #1,d1
                btst    #0,status(a0)
                bne.s   loc_33854
                neg.w   d1

loc_33854:
                move.w  d1,y_vel(a0)
                move.l  #loc_3385E,(a0)

loc_3385E:
                lea     (Player_1).w,a1
                lea     $30(a0),a2
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.s   sub_338C4
                lea     (Player_2).w,a1
                lea     $34(a0),a2
; Bug: if player 1 was riding the object, then d6 may have become dirty from
; a call to Perform_Player_DPLC, causing player 2 to behave erratically
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.s   sub_338C4
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$3F,d0
                bne.s   loc_338BE
                move.w  x_pos(a0),d0
                sub.w   (Camera_X_pos).w,d0
                addi.w  #$40,d0
                cmpi.w  #$1C0,d0
                bhs.s   loc_338BE
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   $38(a0),d0
                addi.w  #$40,d0
                move.w  $3A(a0),d1
                addi.w  #$80,d1
                cmp.w   d1,d0
                bhs.s   loc_338BE
                moveq   #signextendB(sfx_WaveHover),d0
                jsr     (Play_SFX).l

loc_338BE:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_338C4:
                btst    d6,status(a0)
                bne.w   loc_339A0
                tst.b   1(a2)
                beq.s   loc_338D8
                subq.b  #1,1(a2)
                rts
; ---------------------------------------------------------------------------

loc_338D8:
                moveq   #0,d1
                move.b  y_radius(a1),d1
                addi.w  #$44,d1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.w   locret_3399E
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   $38(a0),d0
                cmp.w   $3A(a0),d0
                bhs.w   locret_3399E
                tst.b   object_control(a1)
                bne.w   locret_3399E
                tst.w   (Debug_placement_mode).w
                bne.w   locret_3399E
                subi.w  #$10,d0
                bcc.s   loc_33922
                sub.w   d0,y_pos(a1)

loc_33922:
                btst    #Status_InAir,status(a1)
                beq.w   loc_33958
                tst.b   angle(a1)
                beq.s   loc_3394C
                bclr    #Status_InAir,status(a1)
                move.w  ground_vel(a1),d0
                bpl.s   loc_33940
                neg.w   d0

loc_33940:
                cmpi.w  #$400,d0
                bhs.s   loc_33958
                bset    #Status_InAir,status(a1)

loc_3394C:
                move.b  #1,1(a2)
                bset    #0,object_control(a1)

loc_33958:
                bsr.w   sub_33C34
                move.b  #$80,(a2)
                move.b  #-$40,angle(a1)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.s   loc_3397A
                move.b  #$40,angle(a1)
                move.b  #0,(a2)

loc_3397A:
                bclr    #Status_Facing,status(a1)
                bclr    #0,render_flags(a1)
                bclr    #1,render_flags(a1)
                bset    #6,object_control(a1)
                bset    #1,object_control(a1)
                move.b  #0,anim(a1)

locret_3399E:
                rts
; ---------------------------------------------------------------------------

loc_339A0:
                tst.b   1(a2)
                bne.w   loc_33ADE
                tst.w   (Debug_placement_mode).w
                bne.s   loc_33A0E
                move.w  ground_vel(a1),d0
                bpl.s   loc_339B6
                neg.w   d0

loc_339B6:
                cmpi.w  #$300,d0
                bhs.s   loc_339CC
                move.b  #1,1(a2)
                bset    #0,object_control(a1)
                bra.w   loc_33ADE
; ---------------------------------------------------------------------------

loc_339CC:
                btst    #Status_InAir,status(a1)
                beq.s   loc_339FC
                move.w  #-$800,x_vel(a1)
                move.w  #-$200,y_vel(a1)
                bset    #Status_Facing,status(a1)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.s   loc_33A0E
                neg.w   x_vel(a1)
                bclr    #Status_Facing,status(a1)
                bra.s   loc_33A0E
; ---------------------------------------------------------------------------

loc_339FC:
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   $38(a0),d0
                cmp.w   $3A(a0),d0
                blo.s   loc_33A50

loc_33A0E:
                move.b  #0,angle(a1)
                bclr    #Status_Roll,status(a1)
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)
                move.w  #1,anim(a1)                     ; and prev_anim
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                bclr    #6,object_control(a1)
                bclr    #1,object_control(a1)
                andi.w  #drawing_mask,art_tile(a1)
                move.b  #$10,1(a2)
                rts
; ---------------------------------------------------------------------------

loc_33A50:
                move.w  y_vel(a0),d1
                bpl.s   loc_33A5C
                cmpi.w  #$10,d0
                bls.s   loc_33A60

loc_33A5C:
                add.w   d1,y_pos(a1)

loc_33A60:
                subi.w  #$10,d0
                bcc.s   loc_33A6A
                sub.w   d0,y_pos(a1)

loc_33A6A:
                moveq   #0,d0
                move.b  (a2),d0
                addq.b  #4,(a2)
                jsr     (GetSineCosine).l
                move.w  d1,d3
                asr.w   #2,d1
                add.w   x_pos(a0),d1
                moveq   #0,d0
                move.b  y_radius(a1),d0
                muls.w  d3,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                moveq   #0,d0
                move.b  (a2),d0
                andi.w  #drawing_mask,art_tile(a1)
                cmpi.b  #$80,d0
                blo.s   loc_33AA4
                ori.w   #high_priority,art_tile(a1)

loc_33AA4:
                addi.b  #$40,d0
                neg.b   d0
                andi.w  #$FF,d0
                divu.w  #$B,d0
                move.b  RawAni_33AC6(pc,d0.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------
RawAni_33AC6:
                dc.b    $76, $76, $77, $77, $6C, $6C, $6D, $6D, $6E, $6E, $6F, $6F, $70, $70, $71, $71, $72, $72, $73, $73
                dc.b    $74, $74, $75, $75
                even
; ---------------------------------------------------------------------------

loc_33ADE:
                tst.w   (Debug_placement_mode).w
                bne.s   loc_33B62
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.s   loc_33B1E
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)
                move.w  #-$800,x_vel(a1)
                move.w  #-$200,y_vel(a1)
                bset    #Status_Facing,status(a1)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.s   loc_33B62
                neg.w   x_vel(a1)
                bclr    #Status_Facing,status(a1)
                bra.s   loc_33B62
; ---------------------------------------------------------------------------

loc_33B1E:
                btst    #Status_InAir,status(a1)
                bne.s   loc_33B62
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   $38(a0),d0
                cmp.w   $3A(a0),d0
                blo.s   loc_33BAA
                bne.s   loc_33B62
                move.b  (a2),d0
                andi.b  #$7F,d0
                bne.s   loc_33BBA
                move.w  #-$100,x_vel(a1)
                move.w  #0,y_vel(a1)
                tst.b   (a2)
                bmi.s   loc_33B56
                neg.w   x_vel(a1)

loc_33B56:
                move.w  x_vel(a1),ground_vel(a1)
                bset    #Status_InAir,status(a1)

loc_33B62:
                move.b  #0,angle(a1)
                bclr    #Status_Roll,status(a1)
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)
                move.w  #1,anim(a1)                     ; and prev_anim
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                bclr    #6,object_control(a1)
                bclr    #1,object_control(a1)
                bclr    #0,object_control(a1)
                andi.w  #drawing_mask,art_tile(a1)
                move.b  #$10,1(a2)
                rts
; ---------------------------------------------------------------------------

loc_33BAA:
                move.w  y_vel(a0),d1
                bpl.s   loc_33BB6
                cmpi.w  #$10,d0
                bls.s   loc_33BBA

loc_33BB6:
                add.w   d1,y_pos(a1)

loc_33BBA:
                moveq   #0,d0
                move.b  (a2),d0
                addq.b  #4,(a2)
                jsr     (GetSineCosine).l
                move.w  d1,d3
                asr.w   #2,d1
                add.w   x_pos(a0),d1
                moveq   #0,d0
                move.b  y_radius(a1),d0
                muls.w  d3,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                moveq   #0,d0
                move.b  (a2),d0
                andi.w  #drawing_mask,art_tile(a1)
                cmpi.b  #$80,d0
                blo.s   loc_33BF4
                ori.w   #high_priority,art_tile(a1)

loc_33BF4:
                addi.b  #$40,d0
                neg.b   d0
                andi.w  #$FF,d0
                divu.w  #$B,d0
                move.b  RawAni_33C1C(pc,d0.w),mapping_frame(a1)
                move.b  #0,anim(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; End of function sub_338C4

; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------
RawAni_33C1C:
                dc.b    $5E, $5E, $5E, $5F, $5F, $5F, $5F, $60, $60, $60, $60, $60, $61, $61, $61, $61, $5C, $5C, $5C, $5C
                dc.b    $5D, $5D, $5D, $5D
                even

; =============== S U B R O U T I N E =======================================

sub_33C34:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_33C44
                movea.w interact(a1),a3
                bclr    d6,status(a3)

loc_33C44:
                move.w  a0,interact(a1)
                btst    #Status_InAir,status(a1)
                beq.s   loc_33C62
                move.w  #0,x_vel(a1)
                move.l  a0,-(sp)
                movea.l a1,a0
                jsr     (Player_TouchFloor).l
                movea.l (sp)+,a0

loc_33C62:
                bset    #Status_OnObj,status(a1)
                bclr    #Status_InAir,status(a1)
                bset    d6,status(a0)
                rts
; End of function sub_33C34
