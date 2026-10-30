; Owner: objects/zones/mgz/sk
; Responsibility: Marble Garden twisting loop player capture, scripted rotation and release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_MGZTwistingLoop:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #4,d0
                move.w  d0,$3C(a0)
                move.l  #loc_33C86,(a0)

loc_33C86:
                lea     (Player_1).w,a1
                lea     $30(a0),a2
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.s   sub_33CAC
                lea     (Player_2).w,a1
                lea     $36(a0),a2
; Bug: if player 1 was riding the object, then d6 may have become dirty from
; a call to Perform_Player_DPLC, causing player 2 to behave erratically
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.s   sub_33CAC
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_33CAC:
                btst    d6,status(a0)
                bne.w   loc_33D8A
                tst.b   4(a2)
                beq.s   loc_33CE6
                subq.b  #1,4(a2)
                bne.s   loc_33CC6
                bclr    #0,object_control(a1)

loc_33CC6:
                move.w  x_vel(a1),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a1)
                move.w  y_vel(a1),d0
                addi.w  #$38,y_vel(a1)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

loc_33CE6:
                moveq   #0,d1
                move.b  y_radius(a1),d1
                addi.w  #$24,d1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.w   locret_33D88
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                cmpi.w  #$20,d0
                bhs.s   locret_33D88
                tst.b   object_control(a1)
                bne.s   locret_33D88
                tst.w   (Debug_placement_mode).w
                bne.s   locret_33D88
                btst    #Status_InAir,status(a1)
                bne.s   locret_33D88
                move.b  angle(a1),d0
                andi.b  #$7F,d0
                cmpi.w  #$40,d0
                bne.s   locret_33D88
                move.l  y_pos(a1),(a2)
                move.w  (a2),d0
                sub.w   y_pos(a0),d0
                move.w  d0,(a2)
                bsr.w   sub_33C34
                move.b  #$C0,angle(a1)
                bclr    #0,render_flags(a1)
                move.b  #$80,5(a2)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.s   loc_33D70
                move.b  #$40,angle(a1)
                bset    #0,render_flags(a1)
                move.b  #0,5(a2)

loc_33D70:
                bset    #1,render_flags(a1)
                bset    #6,object_control(a1)
                bset    #1,object_control(a1)
                move.b  #0,anim(a1)

locret_33D88:
                rts
; ---------------------------------------------------------------------------

loc_33D8A:
                tst.w   (Debug_placement_mode).w
                bne.w   loc_33E7A
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.s   loc_33DDC
                move.b  #8,4(a2)
                bset    #0,object_control(a1)
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)
                move.w  #-$800,x_vel(a1)
                move.w  #-$200,y_vel(a1)
                bset    #Status_Facing,status(a1)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.w   loc_33E7A
                neg.w   x_vel(a1)
                bclr    #Status_Facing,status(a1)
                bra.w   loc_33E7A
; ---------------------------------------------------------------------------

loc_33DDC:
                move.w  ground_vel(a1),d0
                bpl.s   loc_33DF2
                neg.w   d0
                cmpi.w  #$400,d0
                bhs.s   loc_33DFE
                move.w  #-$400,ground_vel(a1)
                bra.s   loc_33DFE
; ---------------------------------------------------------------------------

loc_33DF2:
                cmpi.w  #$400,d0
                bhs.s   loc_33DFE
                move.w  #$400,ground_vel(a1)

loc_33DFE:
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                cmp.w   $3C(a0),d0
                blo.w   loc_33EBE
                move.w  ground_vel(a1),d0
                bpl.s   loc_33E2A
                neg.w   d0
                cmpi.w  #$C00,d0
                blo.s   loc_33E3C
                move.w  #-$C00,ground_vel(a1)
                move.w  #$C00,y_vel(a1)
                bra.s   loc_33E3C
; ---------------------------------------------------------------------------

loc_33E2A:
                cmpi.w  #$C00,d0
                blo.s   loc_33E3C
                move.w  #$C00,ground_vel(a1)
                move.w  #$C00,y_vel(a1)

loc_33E3C:
                move.w  y_vel(a1),d0
                ext.l   d0
                lsl.l   #6,d0
                move.l  d0,d1
                add.l   d0,d0
                add.l   d1,d0
                add.l   (a2),d0
                swap    d0
                moveq   #0,d2
                mulu.w  #$155,d0
                lsr.l   #8,d0
                move.w  d0,d2
                add.b   5(a2),d0
                jsr     (GetSineCosine).l
                move.w  d1,d3
                asr.w   #3,d1
                add.w   x_pos(a0),d1
                moveq   #0,d0
                move.b  y_radius(a1),d0
                muls.w  d3,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,x_pos(a1)

loc_33E7A:
                btst    #0,status(a0)
                beq.s   loc_33E88
                addi.b  #$80,angle(a1)

loc_33E88:
                bclr    #Status_Roll,status(a1)
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)
                move.w  #1,anim(a1)                     ; and prev_anim
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                bclr    #6,object_control(a1)
                bclr    #1,object_control(a1)
                andi.w  #drawing_mask,art_tile(a1)
                rts
; ---------------------------------------------------------------------------

loc_33EBE:
                move.w  ground_vel(a1),d0
                bpl.s   loc_33EDA
                neg.w   d0
                cmpi.w  #$C00,d0
                blo.s   loc_33EEC
                move.w  #-$C00,ground_vel(a1)
                move.w  #$C00,y_vel(a1)
                bra.s   loc_33EEC
; ---------------------------------------------------------------------------

loc_33EDA:
                cmpi.w  #$C00,d0
                blo.s   loc_33EEC
                move.w  #$C00,ground_vel(a1)
                move.w  #$C00,y_vel(a1)

loc_33EEC:
                move.w  y_vel(a1),d0
                ext.l   d0
                lsl.l   #6,d0
                move.l  d0,d1
                add.l   d0,d0
                add.l   d1,d0
                add.l   d0,(a2)
                moveq   #0,d0
                moveq   #0,d2
                move.w  (a2),d0
                mulu.w  #$155,d0
                lsr.l   #8,d0
                move.w  d0,d2
                add.b   5(a2),d0
                jsr     (GetSineCosine).l
                move.w  d1,d3
                asr.w   #3,d1
                add.w   x_pos(a0),d1
                moveq   #0,d0
                move.b  y_radius(a1),d0
                muls.w  d3,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                move.w  (a2),d0
                add.w   y_pos(a0),d0
                move.w  d0,y_pos(a1)
                moveq   #0,d0
                andi.w  #drawing_mask,art_tile(a1)
                cmpi.b  #$80,d2
                bhs.s   loc_33F4A
                ori.w   #high_priority,art_tile(a1)

loc_33F4A:
                subi.b  #$40,d2
                neg.b   d2
                andi.w  #$FF,d2
                divu.w  #$B,d2
                move.b  byte_33F6C(pc,d2.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; End of function sub_33CAC

; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------
byte_33F6C:
                dc.b    $76, $76, $77, $77, $6C, $6C, $6D, $6D, $6E, $6E, $6F, $6F, $70, $70, $71, $71, $72, $72, $73, $73
                dc.b    $74, $74, $75, $75
                even
