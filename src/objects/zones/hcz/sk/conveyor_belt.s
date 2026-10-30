; Owner: objects/zones/hcz/sk
; Responsibility: Hydrocity conveyor belt player transport and coordinated conveyor spike motion
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
word_31124:
                dc.w    $B28,  $CD8
                dc.w    $BA8,  $CD8
                dc.w    $BA8,  $CD8
                dc.w    $EA8, $1058
                dc.w    $11A8, $12D8
                dc.w    $1928, $19D8
                dc.w    $21A8, $2358
                dc.w    $21A8, $2358
                dc.w    $22A8, $2458
                dc.w    $23A8, $2558
                dc.w    $2528, $26D8
                dc.w    $26A8, $27D8
                dc.w    $26A8, $2958
                dc.w    $2728, $28D8
                dc.w    $3328, $3458
                dc.w    $3328, $33D8
; ---------------------------------------------------------------------------

Obj_HCZConveyorBelt:
                lea     (Conveyor_belt_load_array).w,a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                tst.b   (a1,d0.w)
                beq.s   loc_31186
                move.w  respawn_addr(a0),d0
                beq.s   loc_31180
                movea.w d0,a2
                bclr    #7,(a2)

loc_31180:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_31186:
                move.b  #1,(a1,d0.w)
                andi.w  #$F,d0
                lsl.w   #2,d0
                lea     word_31124(pc,d0.w),a1
                move.w  (a1)+,d0
                move.w  d0,$3C(a0)
                btst    #0,status(a0)
                bne.s   loc_311A6
                subq.w  #8,d0

loc_311A6:
                move.w  d0,$40(a0)
                move.w  (a1)+,d0
                move.w  d0,$3E(a0)
                btst    #0,status(a0)
                beq.s   loc_311BA
                addq.w  #8,d0

loc_311BA:
                move.w  d0,$42(a0)
                move.l  #loc_311C4,(a0)

loc_311C4:
                lea     $32(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d1
                moveq   #0,d2
                bsr.s   sub_31226
                addq.w  #1,a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d1
                moveq   #1,d2
                bsr.s   sub_31226
                move.w  (Camera_X_pos_coarse_back).w,d1
                move.w  $3C(a0),d0
                andi.w  #$FF80,d0
                subi.w  #$280,d0
                cmp.w   d0,d1
                blo.s   loc_31204
                move.w  $3E(a0),d0
                andi.w  #$FF80,d0
                cmp.w   d0,d1
                bhi.s   loc_31204
                rts
; ---------------------------------------------------------------------------

loc_31204:
                lea     (Conveyor_belt_load_array).w,a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  #0,(a1,d0.w)
                move.w  respawn_addr(a0),d0
                beq.s   loc_31220
                movea.w d0,a2
                bclr    #7,(a2)

loc_31220:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_31226:
                tst.b   (a2)
                beq.w   loc_31322
                tst.w   (Debug_placement_mode).w
                bne.w   loc_312D4
                cmpi.b  #4,routine(a1)
                bhs.w   loc_312D4
                btst    #button_left+8,d1
                beq.s   loc_31260
                subq.w  #1,x_pos(a1)
                subq.b  #1,6(a2)
                bpl.s   loc_31260
                move.b  #7,6(a2)
                addi.b  #$10,8(a2)
                andi.b  #$10,8(a2)

loc_31260:
                btst    #button_right+8,d1
                beq.s   loc_31282
                addq.w  #1,x_pos(a1)
                subq.b  #1,6(a2)
                bpl.s   loc_31282
                move.b  #7,6(a2)
                addi.b  #$10,8(a2)
                andi.b  #$10,8(a2)

loc_31282:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d1
                bne.w   loc_312C0
                moveq   #2,d0
                btst    #0,status(a0)
                beq.s   loc_31296
                neg.w   d0

loc_31296:
                add.w   d0,x_pos(a1)
                move.w  x_pos(a1),d0
                cmp.w   $40(a0),d0
                blo.s   loc_312D4
                cmp.w   $42(a0),d0
                bhs.s   loc_312D4
                bsr.w   sub_3145A
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------

loc_312C0:
                move.w  #-$500,y_vel(a1)
                btst    #Status_Underwater,status(a1)
                beq.s   loc_312D4
                move.w  #-$200,y_vel(a1)

loc_312D4:
                clr.b   (a2)
                move.b  #60,2(a2)
                btst    #Status_Underwater,status(a1)
                beq.s   loc_312EA
                move.b  #90,2(a2)

loc_312EA:
                andi.b  #$FC,object_control(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,flip_angle(a1)
                rts
; ---------------------------------------------------------------------------

loc_31322:
                tst.b   2(a2)
                beq.s   loc_3132E
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_3132E:
                move.w  x_pos(a1),d0
                cmp.w   $40(a0),d0
                blo.w   locret_313D4
                cmp.w   $42(a0),d0
                bhs.w   locret_313D4
                cmpi.w  #1,ground_vel(a1)
                beq.w   loc_313D6
                move.w  y_pos(a0),d0
                addi.w  #$14,d0
                cmp.w   y_pos(a1),d0
                bhs.s   locret_313D4
                addi.w  #$10,d0
                cmp.w   y_pos(a1),d0
                blo.s   locret_313D4
                tst.w   (Debug_placement_mode).w
                bne.s   locret_313D4
                cmpi.b  #4,routine(a1)
                bhs.s   locret_313D4
                tst.b   object_control(a1)
                bne.s   locret_313D4
                tst.w   y_vel(a1)
                bmi.s   locret_313D4
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                andi.b  #$FC,render_flags(a1)
                move.w  y_pos(a0),d0
                addi.w  #$14,d0
                move.w  d0,y_pos(a1)
                move.b  #0,anim(a1)
                move.b  #3,object_control(a1)
                move.b  #$63,mapping_frame(a1)
                move.b  #0,4(a2)
                move.b  #0,6(a2)
                move.b  #0,8(a2)
                move.b  #1,(a2)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2

locret_313D4:
                rts
; ---------------------------------------------------------------------------

loc_313D6:
                move.w  y_pos(a0),d0
                subi.w  #$14,d0
                cmp.w   y_pos(a1),d0
                bhs.s   locret_313D4
                addi.w  #$10,d0
                cmp.w   y_pos(a1),d0
                blo.s   locret_313D4
                tst.w   (Debug_placement_mode).w
                bne.s   locret_313D4
                cmpi.b  #4,routine(a1)
                bhs.s   locret_313D4
                tst.b   object_control(a1)
                bne.s   locret_313D4
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                andi.b  #$FC,render_flags(a1)
                move.w  y_pos(a0),d0
                subi.w  #$14,d0
                move.w  d0,y_pos(a1)
                move.b  #0,anim(a1)
                move.b  #3,object_control(a1)
                move.b  #$65,mapping_frame(a1)
                move.b  #$80,4(a2)
                move.b  #0,6(a2)
                move.b  #0,8(a2)
                move.b  #1,(a2)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; End of function sub_31226

; =============== S U B R O U T I N E =======================================

sub_3145A:
                tst.w   ground_vel(a1)
                bne.s   loc_31480
                move.b  4(a2),d0
                beq.s   loc_3147E
                bpl.s   loc_31472
                addi.b  #6,d0
                bcc.s   loc_31470
                moveq   #0,d0

loc_31470:
                bra.s   loc_3147A
; ---------------------------------------------------------------------------

loc_31472:
                subi.b  #6,d0
                bcc.s   loc_3147A
                moveq   #0,d0

loc_3147A:
                move.b  d0,4(a2)

loc_3147E:
                bra.s   loc_314AA
; ---------------------------------------------------------------------------

loc_31480:
                clr.w   ground_vel(a1)
                move.b  4(a2),d0
                subi.b  #$80,d0
                beq.s   loc_314AA
                bpl.s   loc_3149A
                addi.b  #6,d0
                bcc.s   loc_31498
                moveq   #0,d0

loc_31498:
                bra.s   loc_314A2
; ---------------------------------------------------------------------------

loc_3149A:
                subi.b  #6,d0
                bcc.s   loc_314A2
                moveq   #0,d0

loc_314A2:
                addi.b  #$80,d0
                move.b  d0,4(a2)

loc_314AA:
                moveq   #0,d0
                move.b  4(a2),d0
                lsr.b   #4,d0
                add.b   8(a2),d0
                move.b  byte_314D2(pc,d0.w),d1
                move.b  d1,mapping_frame(a1)
                andi.w  #$F,d0
                move.b  byte_314F2(pc,d0.w),d1
                ext.w   d1
                add.w   y_pos(a0),d1
                move.w  d1,y_pos(a1)
                rts
; End of function sub_3145A

; ---------------------------------------------------------------------------
byte_314D2:
                dc.b    $94, $63, $64, $64, $65, $65, $65, $66, $66, $66, $66, $67, $67, $67, $68, $68, $95, $63, $64, $64
                dc.b    $65, $65, $65, $66, $66, $66, $66, $67, $67, $67, $68, $68
byte_314F2:
                dc.b    $14, $14,  $B,  $B, -$F, -$F, -$F,-$14,-$14,-$14,-$14, -$C, -$C, -$C,  -2,  -2
; ---------------------------------------------------------------------------

Obj_HCZConveryorSpike:
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lsl.w   #2,d0
                lea     word_31124(pc),a1
                lea     (a1,d0.w),a1
                move.w  (a1)+,$3C(a0)
                move.w  (a1)+,$3E(a0)
                move.l  #Map_HCZConveyorSpike,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZSpikeBall,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #$8B,collision_flags(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                btst    #0,status(a0)
                beq.s   loc_3156E
                addi.w  #$18,y_pos(a0)
                move.l  #loc_315D2,(a0)
                bra.w   loc_315D2
; ---------------------------------------------------------------------------

loc_3156E:
                subi.w  #$18,y_pos(a0)
                move.w  #$40,angle(a0)
                move.l  #loc_31580,(a0)

loc_31580:
                addq.w  #2,x_pos(a0)
                move.w  x_pos(a0),d0
                cmp.w   $3E(a0),d0
                bne.s   loc_3159A
                move.l  #loc_3159E,(a0)
                move.w  x_pos(a0),$30(a0)

loc_3159A:
                bra.w   loc_31626
; ---------------------------------------------------------------------------

loc_3159E:
                subq.w  #2,angle(a0)
                andi.w  #$7E,angle(a0)
                move.w  angle(a0),d0
                bne.s   loc_315B4
                move.l  #loc_315D2,(a0)

loc_315B4:
                lea     word_31664(pc),a1
                move.w  (a1,d0.w),d1
                move.w  $20(a1,d0.w),d2
                add.w   $30(a0),d1
                add.w   $32(a0),d2
                move.w  d1,x_pos(a0)
                move.w  d2,y_pos(a0)
                bra.s   loc_31626
; ---------------------------------------------------------------------------

loc_315D2:
                subq.w  #2,x_pos(a0)
                move.w  x_pos(a0),d0
                cmp.w   $3C(a0),d0
                bne.s   loc_315EC
                move.l  #loc_315EE,(a0)
                move.w  x_pos(a0),$30(a0)

loc_315EC:
                bra.s   loc_31626
; ---------------------------------------------------------------------------

loc_315EE:
                subq.w  #2,angle(a0)
                andi.w  #$7E,angle(a0)
                move.w  angle(a0),d0
                cmpi.w  #$40,angle(a0)
                bne.s   loc_3160A
                move.l  #loc_31580,(a0)

loc_3160A:
                lea     word_31664(pc),a1
                move.w  (a1,d0.w),d1
                move.w  2*$10(a1,d0.w),d2
                add.w   $30(a0),d1
                add.w   $32(a0),d2
                move.w  d1,x_pos(a0)
                move.w  d2,y_pos(a0)

loc_31626:
                move.w  (Camera_X_pos_coarse_back).w,d1
                move.w  $3C(a0),d0
                andi.w  #$FF80,d0
                subi.w  #$280,d0
                cmp.w   d0,d1
                blo.s   loc_31652
                move.w  $3E(a0),d0
                andi.w  #$FF80,d0
                cmp.w   d0,d1
                bhi.s   loc_31652
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_31652:
                move.w  respawn_addr(a0),d0
                beq.s   loc_3165E
                movea.w d0,a2
                bclr    #7,(a2)

loc_3165E:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
word_31664:
                dc.w    0,     2,     4,     6,     9,    $B,    $D,    $F,   $10,   $12,   $13,   $15,   $16,   $16,   $17,   $17
                dc.w    $18,   $17,   $17,   $16,   $16,   $15,   $13,   $12,   $10,    $F,    $D,    $B,     9,     6,     4,     2
                dc.w    0,    -3,    -5,    -7,   -$A,   -$C,   -$E,  -$10,  -$11,  -$13,  -$14,  -$16,  -$17,  -$17,  -$18,  -$18
                dc.w    -$18,  -$18,  -$18,  -$17,  -$17,  -$16,  -$14,  -$13,  -$11,  -$10,   -$E,   -$C,   -$A,    -7,    -5,    -3
                dc.w    0,     2,     4,     6,     9,    $B,    $D,    $F,   $10,   $12,   $13,   $15,   $16,   $16,   $17,   $17
