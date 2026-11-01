; Owner: objects/zones/cnz/sk
; Responsibility: Carnival Night cylinder player capture, axial transport, release and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
word_320E2:
                dc.w    $4E0
                dc.w    $6F0
                dc.w    $870
                dc.w    $9C0
                dc.w    $AE0
                dc.w    $C00
                dc.w    $CF0
                dc.w    $DE0
; ---------------------------------------------------------------------------

Obj_CNZCylinder:
                cmpi.w  #$17E0,x_pos(a0)
                bne.s   loc_32108
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_32108
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_32108:
                move.b  subtype(a0),d0
                move.b  d0,d1
                lsr.b   #3,d1
                andi.w  #$E,d1
                move.w  word_320E2(pc,d1.w),d1
                move.w  d1,$3E(a0)
                add.w   d0,d0
                andi.w  #$1E,d0
                move.w  d0,$3A(a0)
                move.l  #Map_CNZCylinder,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$3D,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  x_pos(a0),$2E(a0)
                move.w  y_pos(a0),$30(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.b  #$F,d0
                subi.b  #$A,d0
                andi.b  #3,d0
                move.b  d0,$44(a0)
                andi.w  #$F0,d1
                lsl.w   #2,d1
                btst    #0,status(a0)
                beq.s   loc_3217E
                neg.w   d1

loc_3217E:
                move.w  d1,$46(a0)
                move.l  #loc_32188,(a0)

loc_32188:
                bsr.s   UpdateCnzCylinderMotion
                lea     $32(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.w   UpdatePlayerOnCnzCylinder
                addq.w  #4,a2
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.w   UpdatePlayerOnCnzCylinder
                move.w  #$2B,d1
                move.w  #$20,d2
                move.w  #$21,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_321D8
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

loc_321D8:
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l

; =============== S U B R O U T I N E =======================================

UpdateCnzCylinderMotion:
                move.w  $3A(a0),d0
                move.w  off_321EE(pc,d0.w),d0
                jmp     off_321EE(pc,d0.w)
; End of function UpdateCnzCylinderMotion

; ---------------------------------------------------------------------------
off_321EE:
                dc.w    loc_32208-off_321EE
                dc.w    loc_322F0-off_321EE
                dc.w    loc_3230E-off_321EE
                dc.w    loc_3232C-off_321EE
                dc.w    loc_32350-off_321EE
                dc.w    loc_3236E-off_321EE
                dc.w    loc_3238C-off_321EE
                dc.w    loc_323AA-off_321EE
                dc.w    loc_323CE-off_321EE
                dc.w    loc_323EC-off_321EE
                dc.w    loc_323EC-off_321EE
                dc.w    loc_323EC-off_321EE
                dc.w    loc_323EC-off_321EE
; ---------------------------------------------------------------------------

loc_32208:
                move.w  $3C(a0),d1
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                cmp.w   d1,d0
                beq.s   loc_32254
                move.w  d0,$3C(a0)
                sub.w   d1,d0
                bcs.s   loc_32254
                move.w  y_vel(a0),d0
                bpl.s   loc_32228
                neg.w   d0

loc_32228:
                cmpi.w  #$200,d0
                bhs.s   loc_32254
                move.w  y_pos(a0),d0
                sub.w   $30(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$80,d0
                bhs.s   loc_32254
                addi.w  #$400,y_vel(a0)
                move.w  $3E(a0),d0
                cmp.w   y_vel(a0),d0
                bgt.s   loc_32254
                move.w  d0,y_vel(a0)

loc_32254:
                jsr     (MoveSprite2).l
                moveq   #0,d5
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_32268
                move.b  (Ctrl_1_held_logical).w,d5

loc_32268:
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_32274
                or.b    (Ctrl_2_held_logical).w,d5

loc_32274:
                move.w  y_pos(a0),d0
                sub.w   $30(a0),d0
                beq.s   loc_322DA
                bcc.s   loc_322AC
                move.w  $3E(a0),d0
                cmp.w   y_vel(a0),d0
                ble.s   locret_322EE
                addi.w  #$20,y_vel(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_322A4
                btst    #button_down,d5
                beq.s   loc_322AA
                addi.w  #$20,y_vel(a0)
                bra.s   loc_322AA
; ---------------------------------------------------------------------------

loc_322A4:
                addi.w  #$10,y_vel(a0)

loc_322AA:
                bra.s   locret_322EE
; ---------------------------------------------------------------------------

loc_322AC:
                move.w  $3E(a0),d0
                neg.w   d0
                cmp.w   y_vel(a0),d0
                bge.s   locret_322EE
                subi.w  #$20,y_vel(a0)
                tst.w   y_vel(a0)
                bpl.s   loc_322D2
                btst    #button_up,d5
                beq.s   loc_322D8
                subi.w  #$20,y_vel(a0)
                bra.s   loc_322D8
; ---------------------------------------------------------------------------

loc_322D2:
                subi.w  #$10,y_vel(a0)

loc_322D8:
                bra.s   locret_322EE
; ---------------------------------------------------------------------------

loc_322DA:
                move.w  y_vel(a0),d0
                bpl.s   loc_322E2
                neg.w   d0

loc_322E2:
                cmpi.w  #$80,d0
                bhs.s   locret_322EE
                move.w  #0,y_vel(a0)

locret_322EE:
                rts
; ---------------------------------------------------------------------------

loc_322F0:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #3,d0
                add.w   $2E(a0),d0
                move.w  d0,x_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_3230E:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                add.w   $2E(a0),d0
                move.w  d0,x_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_3232C:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                move.w  d0,d1
                asr.w   #1,d0
                add.w   d1,d0
                add.w   $2E(a0),d0
                move.w  d0,x_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_32350:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #1,d0
                add.w   $2E(a0),d0
                move.w  d0,x_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_3236E:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #3,d0
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_3238C:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_323AA:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                move.w  d0,d1
                asr.w   #1,d0
                add.w   d1,d0
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_323CE:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #1,d0
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_323EC:
                move.w  $46(a0),d0
                bpl.s   loc_3242E
                add.w   d0,angle(a0)
                move.b  angle(a0),d0
                cmpi.b  #$80,d0
                bhs.s   loc_32416
                andi.b  #$7F,d0
                addi.b  #$80,d0
                move.b  d0,angle(a0)
                subq.b  #1,$44(a0)
                andi.b  #3,$44(a0)

loc_32416:
                move.w  #$20,d2
                move.b  angle(a0),d0
                cmpi.b  #$80,d0
                bhs.s   loc_32456
                move.b  #$80,d0
                move.b  d0,angle(a0)
                bra.s   loc_32456
; ---------------------------------------------------------------------------

loc_3242E:
                add.w   d0,angle(a0)
                move.b  angle(a0),d0
                cmpi.b  #$80,d0
                bhs.s   loc_32452
                andi.b  #$7F,d0
                addi.b  #$80,d0
                move.b  d0,angle(a0)
                addq.b  #1,$44(a0)
                andi.b  #3,$44(a0)

loc_32452:
                move.w  #$20,d2

loc_32456:
                jsr     (GetSineCosine).l
                asr.w   #3,d1
                move.b  $44(a0),d3
                andi.b  #3,d3
                bne.s   loc_3247C
                add.w   $2E(a0),d1
                move.w  d1,x_pos(a0)
                neg.w   d2
                add.w   $30(a0),d2
                move.w  d2,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_3247C:
                subq.b  #1,d3
                bne.s   loc_32492
                add.w   $30(a0),d1
                move.w  d1,y_pos(a0)
                add.w   $2E(a0),d2
                move.w  d2,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_32492:
                subq.b  #1,d3
                bne.s   loc_324AA
                neg.w   d1
                add.w   $2E(a0),d1
                move.w  d1,x_pos(a0)
                add.w   $30(a0),d2
                move.w  d2,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_324AA:
                neg.w   d1
                add.w   $30(a0),d1
                move.w  d1,y_pos(a0)
                neg.w   d2
                add.w   $2E(a0),d2
                move.w  d2,x_pos(a0)
                rts

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnCnzCylinder:
                move.b  (a2),d0
                bne.s   loc_32538
                btst    d6,status(a0)
                beq.s   locret_32536
                move.b  #0,1(a2)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bpl.s   loc_324E2
                neg.w   d0
                move.b  #$80,1(a2)

loc_324E2:
                move.b  d0,2(a2)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #3,object_control(a1)
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                bclr    #Status_Roll,status(a1)
                bclr    #Status_InAir,status(a1)
                bclr    #Status_Push,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,jumping(a1)
                move.b  #0,anim(a1)
                move.b  #1,(a2)
                bra.w   loc_3260A
; ---------------------------------------------------------------------------

locret_32536:
                rts
; ---------------------------------------------------------------------------

loc_32538:
                tst.b   render_flags(a1)
                bpl.w   loc_325F2
                cmpi.b  #4,routine(a1)
                bhs.w   loc_325F2
                btst    d6,status(a0)
                beq.w   loc_32604
                moveq   #0,d0
                move.b  1(a2),d0
                jsr     (GetSineCosine).l
                addi.w  #$100,d0
                asr.w   #2,d0
                move.b  d0,3(a2)
                moveq   #0,d2
                move.w  2(a2),d2
                muls.w  d2,d1
                swap    d1
                add.w   x_pos(a0),d1
                move.w  d1,x_pos(a1)
                addq.b  #2,1(a2)
                move.w  #$100,priority(a1)
                move.b  $35(a0),d0
                cmp.b   3(a2),d0
                bls.s   loc_32594
                move.w  #$80,priority(a1)

loc_32594:
                move.w  #0,ground_vel(a1)
                move.w  y_vel(a0),d0
                bpl.s   loc_325A2
                neg.w   d0

loc_325A2:
                btst    #Status_InAir,status(a1)
                bne.s   loc_325B6
                cmpi.w  #$480,d0
                blo.s   loc_325B6
                move.w  #$800,ground_vel(a1)

loc_325B6:
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.s   loc_3260A
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.w  y_vel(a0),y_vel(a1)
                addi.w  #-$680,y_vel(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,ground_vel(a1)

loc_325F2:
                bset    #Status_InAir,status(a1)
                move.w  #$100,priority(a1)
                move.b  #0,object_control(a1)

loc_32604:
                move.b  #0,(a2)
                rts
; ---------------------------------------------------------------------------

loc_3260A:
                moveq   #0,d0
                move.b  1(a2),d0

loc_32610:                                              ; Used by LBZ cup elevator
                addi.b  #$B,d0
                divu.w  #$16,d0
                move.b  PlayerTwistFrames(pc,d0.w),mapping_frame(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  PlayerTwistFlip(pc,d0.w),d0
                or.b    d0,render_flags(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; End of function UpdatePlayerOnCnzCylinder

; ---------------------------------------------------------------------------
PlayerTwistFrames:
                dc.b    $55, $59, $5A, $5B, $5A, $59, $55, $56, $57, $58, $57, $56
PlayerTwistFlip:
                dc.b    0,   1,   1,   0,   0,   0,   1,   1,   1,   0,   0,   0
                even
