; Owner: objects/zones/hcz/s3
; Responsibility: Hydrocity conveyor belt player transport and coordinated conveyor spike motion
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
word_2FD7E:
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
                beq.s   loc_2FDE0
                move.w  respawn_addr(a0),d0
                beq.s   loc_2FDDA
                movea.w d0,a2
                bclr    #7,(a2)

loc_2FDDA:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2FDE0:
                move.b  #1,(a1,d0.w)
                andi.w  #$F,d0
                lsl.w   #2,d0
                lea     word_2FD7E(pc,d0.w),a1
                move.w  (a1)+,d0
                move.w  d0,$3C(a0)
                btst    #0,status(a0)
                bne.s   loc_2FE00
                subq.w  #8,d0

loc_2FE00:
                move.w  d0,$40(a0)
                move.w  (a1)+,d0
                move.w  d0,$3E(a0)
                btst    #0,status(a0)
                beq.s   loc_2FE14
                addq.w  #8,d0

loc_2FE14:
                move.w  d0,$42(a0)
                move.l  #loc_2FE1E,(a0)

loc_2FE1E:
                lea     $32(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d1
                moveq   #0,d2
                bsr.s   UpdatePlayerOnHczConveyorBelt
                addq.w  #1,a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d1
                moveq   #1,d2
                bsr.s   UpdatePlayerOnHczConveyorBelt
                move.w  (Camera_X_pos_coarse_back).w,d1
                move.w  $3C(a0),d0
                andi.w  #$FF80,d0
                subi.w  #$280,d0
                cmp.w   d0,d1
                blo.s   loc_2FE5E
                move.w  $3E(a0),d0
                andi.w  #$FF80,d0
                cmp.w   d0,d1
                bhi.s   loc_2FE5E
                rts
; ---------------------------------------------------------------------------

loc_2FE5E:
                lea     (Conveyor_belt_load_array).w,a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  #0,(a1,d0.w)
                move.w  respawn_addr(a0),d0
                beq.s   loc_2FE7A
                movea.w d0,a2
                bclr    #7,(a2)

loc_2FE7A:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnHczConveyorBelt:
                tst.b   (a2)
                beq.w   loc_2FF7C
                tst.w   (Debug_placement_mode).w
                bne.w   loc_2FF2E
                cmpi.b  #4,routine(a1)
                bhs.w   loc_2FF2E
                btst    #button_left+8,d1
                beq.s   loc_2FEBA
                subq.w  #1,x_pos(a1)
                subq.b  #1,6(a2)
                bpl.s   loc_2FEBA
                move.b  #7,6(a2)
                addi.b  #$10,8(a2)
                andi.b  #$10,8(a2)

loc_2FEBA:
                btst    #button_right+8,d1
                beq.s   loc_2FEDC
                addq.w  #1,x_pos(a1)
                subq.b  #1,6(a2)
                bpl.s   loc_2FEDC
                move.b  #7,6(a2)
                addi.b  #$10,8(a2)
                andi.b  #$10,8(a2)

loc_2FEDC:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d1
                bne.w   loc_2FF1A
                moveq   #2,d0
                btst    #0,status(a0)
                beq.s   loc_2FEF0
                neg.w   d0

loc_2FEF0:
                add.w   d0,x_pos(a1)
                move.w  x_pos(a1),d0
                cmp.w   $40(a0),d0
                blo.s   loc_2FF2E
                cmp.w   $42(a0),d0
                bhs.s   loc_2FF2E
                bsr.w   PositionPlayerAroundHczConveyor
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------

loc_2FF1A:
                move.w  #-$500,y_vel(a1)
                btst    #Status_Underwater,status(a1)
                beq.s   loc_2FF2E
                move.w  #-$200,y_vel(a1)

loc_2FF2E:
                clr.b   (a2)
                move.b  #60,2(a2)
                btst    #Status_Underwater,status(a1)
                beq.s   loc_2FF44
                move.b  #90,2(a2)

loc_2FF44:
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

loc_2FF7C:
                tst.b   2(a2)
                beq.s   loc_2FF88
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_2FF88:
                move.w  x_pos(a1),d0
                cmp.w   $40(a0),d0
                blo.w   locret_3002E
                cmp.w   $42(a0),d0
                bhs.w   locret_3002E
                cmpi.w  #1,ground_vel(a1)
                beq.w   loc_30030
                move.w  y_pos(a0),d0
                addi.w  #$14,d0
                cmp.w   y_pos(a1),d0
                bhs.s   locret_3002E
                addi.w  #$10,d0
                cmp.w   y_pos(a1),d0
                blo.s   locret_3002E
                tst.w   (Debug_placement_mode).w
                bne.s   locret_3002E
                cmpi.b  #4,routine(a1)
                bhs.s   locret_3002E
                tst.b   object_control(a1)
                bne.s   locret_3002E
                tst.w   y_vel(a1)
                bmi.s   locret_3002E
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

locret_3002E:
                rts
; ---------------------------------------------------------------------------

loc_30030:
                move.w  y_pos(a0),d0
                subi.w  #$14,d0
                cmp.w   y_pos(a1),d0
                bhs.s   locret_3002E
                addi.w  #$10,d0
                cmp.w   y_pos(a1),d0
                blo.s   locret_3002E
                tst.w   (Debug_placement_mode).w
                bne.s   locret_3002E
                cmpi.b  #4,routine(a1)
                bhs.s   locret_3002E
                tst.b   object_control(a1)
                bne.s   locret_3002E
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
; End of function UpdatePlayerOnHczConveyorBelt

; =============== S U B R O U T I N E =======================================

PositionPlayerAroundHczConveyor:
                tst.w   ground_vel(a1)
                bne.s   loc_300DA
                move.b  4(a2),d0
                beq.s   loc_300D8
                bpl.s   loc_300CC
                addi.b  #6,d0
                bcc.s   loc_300CA
                moveq   #0,d0

loc_300CA:
                bra.s   loc_300D4
; ---------------------------------------------------------------------------

loc_300CC:
                subi.b  #6,d0
                bcc.s   loc_300D4
                moveq   #0,d0

loc_300D4:
                move.b  d0,4(a2)

loc_300D8:
                bra.s   loc_30104
; ---------------------------------------------------------------------------

loc_300DA:
                clr.w   ground_vel(a1)
                move.b  4(a2),d0
                subi.b  #$80,d0
                beq.s   loc_30104
                bpl.s   loc_300F4
                addi.b  #6,d0
                bcc.s   loc_300F2
                moveq   #0,d0

loc_300F2:
                bra.s   loc_300FC
; ---------------------------------------------------------------------------

loc_300F4:
                subi.b  #6,d0
                bcc.s   loc_300FC
                moveq   #0,d0

loc_300FC:
                addi.b  #$80,d0
                move.b  d0,4(a2)

loc_30104:
                moveq   #0,d0
                move.b  4(a2),d0
                lsr.b   #4,d0
                add.b   8(a2),d0
                move.b  byte_3012C(pc,d0.w),d1
                move.b  d1,mapping_frame(a1)
                andi.w  #$F,d0
                move.b  byte_3014C(pc,d0.w),d1
                ext.w   d1
                add.w   y_pos(a0),d1
                move.w  d1,y_pos(a1)
                rts
; End of function PositionPlayerAroundHczConveyor

; ---------------------------------------------------------------------------
byte_3012C:
                dc.b    $94, $63, $64, $64, $65, $65, $65, $66, $66, $66, $66, $67, $67, $67, $68, $68, $95, $63, $64, $64
                dc.b    $65, $65, $65, $66, $66, $66, $66, $67, $67, $67, $68, $68
byte_3014C:
                dc.b    $14, $14,  $B,  $B, -$F, -$F, -$F,-$14,-$14,-$14,-$14, -$C, -$C, -$C,  -2,  -2
; ---------------------------------------------------------------------------

Obj_HCZConveryorSpike:
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lsl.w   #2,d0
                lea     word_2FD7E(pc),a1
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
                beq.s   loc_301C8
                addi.w  #$18,y_pos(a0)
                move.l  #loc_3022C,(a0)
                bra.w   loc_3022C
; ---------------------------------------------------------------------------

loc_301C8:
                subi.w  #$18,y_pos(a0)
                move.w  #$40,angle(a0)
                move.l  #loc_301DA,(a0)

loc_301DA:
                addq.w  #2,x_pos(a0)
                move.w  x_pos(a0),d0
                cmp.w   $3E(a0),d0
                bne.s   loc_301F4
                move.l  #loc_301F8,(a0)
                move.w  x_pos(a0),$30(a0)

loc_301F4:
                bra.w   loc_30280
; ---------------------------------------------------------------------------

loc_301F8:
                subq.w  #2,angle(a0)
                andi.w  #$7E,angle(a0)
                move.w  angle(a0),d0
                bne.s   loc_3020E
                move.l  #loc_3022C,(a0)

loc_3020E:
                lea     word_302BE(pc),a1
                move.w  (a1,d0.w),d1
                move.w  $20(a1,d0.w),d2
                add.w   $30(a0),d1
                add.w   $32(a0),d2
                move.w  d1,x_pos(a0)
                move.w  d2,y_pos(a0)
                bra.s   loc_30280
; ---------------------------------------------------------------------------

loc_3022C:
                subq.w  #2,x_pos(a0)
                move.w  x_pos(a0),d0
                cmp.w   $3C(a0),d0
                bne.s   loc_30246
                move.l  #loc_30248,(a0)
                move.w  x_pos(a0),$30(a0)

loc_30246:
                bra.s   loc_30280
; ---------------------------------------------------------------------------

loc_30248:
                subq.w  #2,angle(a0)
                andi.w  #$7E,angle(a0)
                move.w  angle(a0),d0
                cmpi.w  #$40,angle(a0)
                bne.s   loc_30264
                move.l  #loc_301DA,(a0)

loc_30264:
                lea     word_302BE(pc),a1
                move.w  (a1,d0.w),d1
                move.w  2*$10(a1,d0.w),d2
                add.w   $30(a0),d1
                add.w   $32(a0),d2
                move.w  d1,x_pos(a0)
                move.w  d2,y_pos(a0)

loc_30280:
                move.w  (Camera_X_pos_coarse_back).w,d1
                move.w  $3C(a0),d0
                andi.w  #$FF80,d0
                subi.w  #$280,d0
                cmp.w   d0,d1
                blo.s   loc_302AC
                move.w  $3E(a0),d0
                andi.w  #$FF80,d0
                cmp.w   d0,d1
                bhi.s   loc_302AC
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_302AC:
                move.w  respawn_addr(a0),d0
                beq.s   loc_302B8
                movea.w d0,a2
                bclr    #7,(a2)

loc_302B8:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
word_302BE:
                dc.w    0,     2,     4,     6,     9,    $B,    $D,    $F,   $10,   $12,   $13,   $15,   $16,   $16,   $17,   $17
                dc.w    $18,   $17,   $17,   $16,   $16,   $15,   $13,   $12,   $10,    $F,    $D,    $B,     9,     6,     4,     2
                dc.w    0,    -3,    -5,    -7,   -$A,   -$C,   -$E,  -$10,  -$11,  -$13,  -$14,  -$16,  -$17,  -$17,  -$18,  -$18
                dc.w    -$18,  -$18,  -$18,  -$17,  -$17,  -$16,  -$14,  -$13,  -$11,  -$10,   -$E,   -$C,   -$A,    -7,    -5,    -3
                dc.w    0,     2,     4,     6,     9,    $B,    $D,    $F,   $10,   $12,   $13,   $15,   $16,   $16,   $17,   $17
