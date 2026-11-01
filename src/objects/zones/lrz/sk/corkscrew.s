; Owner: objects/zones/lrz/sk
; Responsibility: Corkscrew player capture, constrained traversal and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZCorkscrew:
                move.b  #$D0,width_pixels(a0)
                move.l  #loc_4225A,(a0)

loc_4225A:
                bsr.s   UpdatePlayersOnLrzCorkscrew
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayersOnLrzCorkscrew:
                lea     (Player_1).w,a1
                lea     $30(a0),a2
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerOnLrzCorkscrew
                lea     (Player_2).w,a1
                lea     $34(a0),a2
; Bug: if player 1 was riding the object, then d6 may have become dirty from
; a call to Perform_Player_DPLC, causing player 2 to behave erratically
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function UpdatePlayersOnLrzCorkscrew

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnLrzCorkscrew:
                btst    d6,status(a0)
                bne.w   loc_42362
                move.w  x_pos(a1),d0
                addi.w  #$10,d0
                sub.w   x_pos(a0),d0
                bcs.w   locret_42360
                cmpi.w  #$20,d0
                bge.w   locret_42360
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bgt.w   locret_42360
                tst.b   object_control(a1)
                bne.w   locret_42360
                btst    #Status_InAir,status(a1)
                bne.w   locret_42360
                tst.w   ground_vel(a1)
                bmi.w   locret_42360
                cmpi.w  #$600,ground_vel(a1)
                bge.w   loc_422D6
                move.w  #$600,ground_vel(a1)

loc_422D6:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_422E6
                movea.w interact(a1),a3
                bclr    d6,status(a3)

loc_422E6:
                move.w  a0,interact(a1)
                bset    d6,status(a0)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                andi.b  #$89,status(a1)
                bset    #Status_OnObj,status(a1)
                move.b  #0,jumping(a1)
                move.w  #0,(Chain_bonus_counter).w
                move.b  #0,angle(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,flip_type(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #0,scroll_delay_counter(a1)
                move.b  #0,double_jump_flag(a1)
                move.l  #0,(a2)
                bclr    #Status_Facing,status(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  #$43,object_control(a1)
                move.b  #0,anim(a1)

locret_42360:
                rts
; ---------------------------------------------------------------------------

loc_42362:
                tst.w   (Debug_placement_mode).w
                beq.s   loc_423D0

loc_42368:
                andi.b  #$81,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                move.w  #1,anim(a1)                     ; and prev_anim
                move.b  #0,object_control(a1)
                neg.w   ground_vel(a1)
                move.w  ground_vel(a1),x_vel(a1)
                move.w  #0,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_42396:
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)
                andi.b  #$81,status(a1)
                bset    #Status_Facing,status(a1)
                bclr    d6,status(a0)
                move.w  #1,anim(a1)                     ; and prev_anim
                move.b  #0,object_control(a1)
                neg.w   ground_vel(a1)
                move.w  ground_vel(a1),x_vel(a1)
                move.w  #0,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_423D0:
                move.w  ground_vel(a1),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,(a2)
                bmi.s   loc_42368
                cmpi.w  #$700,(a2)
                bhs.s   loc_42396
                cmpi.w  #$1000,ground_vel(a1)
                bge.s   loc_423F0
                addi.w  #$10,ground_vel(a1)

loc_423F0:
                bclr    #7,art_tile(a1)
                move.w  (a2),d0
                lsr.w   #1,d0
                addi.b  #$40,d0
                bmi.s   loc_42406
                bset    #7,art_tile(a1)

loc_42406:
                move.w  x_pos(a1),d2
                move.w  (a2),d0
                lsr.w   #1,d0
                jsr     (GetSineCosine).l
                muls.w  #$4800,d0
                swap    d0
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                sub.w   d2,d0
                asl.w   #8,d0
                move.w  d0,x_vel(a1)
                lea     byte_4248A(pc),a3
                cmpi.w  #$600,(a2)
                blo.s   loc_42438
                lea     byte_4250A(pc),a3

loc_42438:
                move.w  y_pos(a1),d2
                move.w  (a2),d0
                lsr.w   #2,d0
                move.w  d0,d1
                andi.w  #$7F,d1
                andi.w  #$FF80,d0
                add.b   (a3,d1.w),d0
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
                move.b  RawAni_4247E(pc,d0.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; End of function UpdatePlayerOnLrzCorkscrew

; ---------------------------------------------------------------------------
RawAni_4247E:
                dc.b    $EF, $FA, $F9, $F8, $F7, $F6, $F5, $F4, $F3, $F2, $F1, $F0
byte_4248A:
                dc.b    0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  $A,  $C,  $D,  $F, $10, $12, $13, $13, $14, $14
                dc.b    $16, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $18, $18, $18, $18, $19, $1B, $1C, $1E
                dc.b    $1F, $21, $22, $24, $25, $27, $28, $2A, $2B, $2D, $2E, $30, $31, $33, $34, $36, $37, $39, $3A, $3C
                dc.b    $3D, $3F, $40, $42, $43, $45, $46, $48, $49, $4B, $4C, $4E, $4F, $51, $52, $54, $55, $57, $58, $5A
                dc.b    $5B, $5D, $5E, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $61, $62, $63
                dc.b    $64, $65, $66, $67, $68, $69, $6A, $6B, $6C, $6D, $6E, $6F, $70, $71, $72, $73, $74, $75, $76, $77
                dc.b    $78, $79, $7A, $7B, $7C, $7D, $7E, $7F
byte_4250A:
                dc.b    0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  $A,  $C,  $D,  $F, $10, $12, $13, $13, $14, $14
                dc.b    $16, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $18, $18, $18, $18, $19, $19, $19, $1A
                dc.b    $1A, $1A, $1B, $1B, $1B, $1C, $1C, $1C, $1D, $1D, $1D, $1D, $1E, $1E, $1E, $1F, $1F, $1F, $20, $20
                dc.b    $20, $21, $21, $21
                even
