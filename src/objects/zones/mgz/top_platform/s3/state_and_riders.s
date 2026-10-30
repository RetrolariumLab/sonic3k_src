; Owner: objects/zones/mgz/top_platform/s3
; Responsibility: Marble Garden spinning top initialization, active state, rider attachment and input handling
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MGZTopPlatform:
                move.l  #Map_MGZTopPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_MGZMisc1,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #$1F,y_radius(a0)
                move.b  #$18,x_radius(a0)
                move.b  #$1F,default_y_radius(a0)
                move.b  #$18,default_x_radius(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                move.l  #loc_341EC,(a0)

loc_341EC:
                lea     (Player_1).w,a1
                lea     $40(a0),a4
                move.w  (Ctrl_1_logical).w,d5
                moveq   #p1_standing_bit,d6
                bsr.w   sub_34484
                lea     (Player_2).w,a1
                lea     $42(a0),a4
                move.w  (Ctrl_2_logical).w,d5
                moveq   #p2_standing_bit,d6
                bsr.w   sub_34484
                tst.b   subtype(a0)
                bne.w   loc_342FA
                btst    #1,status(a0)
                beq.w   loc_342A6
                cmpi.w  #$200,y_vel(a0)
                bge.s   loc_34230
                addi.w  #8,y_vel(a0)

loc_34230:
                jsr     (MoveSprite2).l
                subi.w  #$13,y_pos(a0)
                move.l  a1,-(sp)
                jsr     (sub_347FC).l
                movea.l (sp)+,a1
                addi.w  #$13,y_pos(a0)
                tst.b   $2D(a0)
                beq.s   loc_34268
                move.w  #0,y_vel(a0)
                move.w  #0,x_vel(a0)
                bclr    #1,status(a0)
                bra.w   loc_342FA
; ---------------------------------------------------------------------------

loc_34268:
                btst    #1,status(a0)
                bne.w   loc_342FA
                move.w  x_vel(a0),d0
                bpl.s   loc_3427A
                neg.w   d0

loc_3427A:
                cmpi.w  #$40,d0
                blo.s   loc_342FA
                move.w  #$800,d1
                cmpi.w  #$100,d0
                blo.s   loc_3428E
                move.w  #$C00,d1

loc_3428E:
                tst.w   x_vel(a0)
                bpl.s   loc_34296
                neg.w   d1

loc_34296:
                move.w  d1,x_vel(a0)
                move.w  d1,ground_vel(a0)
                move.b  #1,$34(a0)
                bra.s   loc_342FA
; ---------------------------------------------------------------------------

loc_342A6:
                tst.b   $35(a0)
                beq.s   loc_342B6
                bsr.w   sub_34DFA
                addq.w  #4,$24(a0)
                bra.s   loc_342FA
; ---------------------------------------------------------------------------

loc_342B6:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                bsr.s   sub_34354
                jsr     (MoveSprite2).l
                tst.b   $2D(a0)
                bne.s   loc_342E6
                bsr.w   sub_34406

loc_342E6:
                addq.w  #4,$24(a0)
                tst.w   ground_vel(a0)
                bne.s   loc_342F6
                move.b  #0,$34(a0)

loc_342F6:
                bsr.w   sub_34BF8

loc_342FA:
                lea     (Player_1).w,a1
                lea     $40(a0),a4
                moveq   #p1_standing_bit,d6
                bsr.w   sub_34794
                lea     (Player_2).w,a1
                lea     $42(a0),a4
                moveq   #p2_standing_bit,d6
                bsr.w   sub_34794
                move.w  $24(a0),d0
                asr.w   #3,d0
                andi.w  #1,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_3432A:
                jsr     (MoveSprite).l
                addq.w  #4,$24(a0)
                move.w  $24(a0),d0
                asr.w   #3,d0
                andi.w  #1,d0
                move.b  d0,mapping_frame(a0)
                tst.b   render_flags(a0)
                bmi.s   loc_3434E
                move.w  #$7F00,x_pos(a0)

loc_3434E:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_34354:
                move.b  #$40,d1
                tst.w   ground_vel(a0)
                beq.s   locret_343CE
                bmi.s   loc_34362
                neg.w   d1

loc_34362:
                move.b  angle(a0),d0
                add.b   d1,d0
                move.w  d0,-(sp)
                move.b  #$13,y_radius(a0)
                move.b  #$18,x_radius(a0)
                subi.w  #$C,y_pos(a0)
                jsr     (sub_10A10).l
                addi.w  #$C,y_pos(a0)
                move.w  (sp)+,d0
                tst.w   d1
                bpl.s   locret_343CE
                asl.w   #8,d1
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   loc_34400
                cmpi.b  #$40,d0
                beq.s   loc_343D6
                cmpi.b  #$80,d0
                beq.s   loc_343D0
                addi.b  #$30,d3
                cmpi.b  #$60,d3
                blo.s   locret_343CE
                add.w   d1,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #0,status(a0)
                bne.s   locret_343CE
                bset    #5,status(a0)

locret_343CE:
                rts
; ---------------------------------------------------------------------------

loc_343D0:
                sub.w   d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_343D6:
                addi.b  #$30,d3
                cmpi.b  #$60,d3
                blo.s   locret_343CE
                sub.w   d1,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                btst    #0,status(a0)
                beq.s   locret_343CE
                bset    #5,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_34400:
                add.w   d1,y_vel(a0)
                rts
; End of function sub_34354

; =============== S U B R O U T I N E =======================================

sub_34406:
                move.b  #$C,y_radius(a0)
                move.b  #$A,x_radius(a0)
                moveq   #3,d0
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                jsr     (Sonic_CheckFloor).l
                tst.b   d3
                bpl.s   loc_34432
                cmpi.b  #-$1E,d3
                bhs.s   loc_3443C
                move.b  #-$1E,d3
                bra.s   loc_3443C
; ---------------------------------------------------------------------------

loc_34432:
                cmpi.b  #$1E,d3
                bls.s   loc_3443C
                move.b  #$1E,d3

loc_3443C:
                move.b  d3,angle(a0)
                tst.w   d1
                beq.s   locret_34450
                bpl.s   loc_34452
                cmpi.w  #-$E,d1
                blt.s   locret_34450
                add.w   d1,y_pos(a0)

locret_34450:
                rts
; ---------------------------------------------------------------------------

loc_34452:
                move.b  x_vel(a0),d0
                bpl.s   loc_3445A
                neg.b   d0

loc_3445A:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   loc_34466
                move.b  #$E,d0

loc_34466:
                cmp.b   d0,d1
                bgt.s   loc_34470
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_34470:
                bset    #1,status(a0)
                bclr    #5,status(a0)
                move.b  #0,$34(a0)
                rts
; End of function sub_34406

; =============== S U B R O U T I N E =======================================

sub_34484:
                moveq   #0,d0
                move.b  (a4),d0
                move.w  off_34490(pc,d0.w),d0
                jmp     off_34490(pc,d0.w)
; End of function sub_34484

; ---------------------------------------------------------------------------
off_34490:
                dc.w    loc_3449C-off_34490
                dc.w    loc_344E4-off_34490
                dc.w    loc_34554-off_34490
                dc.w    loc_34498-off_34490
; ---------------------------------------------------------------------------

loc_34498:
                clr.w   (a4)
                rts
; ---------------------------------------------------------------------------

loc_3449C:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull_1P).l
                btst    d6,status(a0)
                bne.s   loc_344C2
                rts
; ---------------------------------------------------------------------------

loc_344C2:
                tst.b   status_tertiary(a1)
                bmi.s   locret_344E2
                addq.b  #2,(a4)
                move.b  #0,1(a4)
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcc.s   loc_344E0
                move.b  #1,1(a4)

loc_344E0:
                bra.s   loc_34502
; ---------------------------------------------------------------------------

locret_344E2:
                rts
; ---------------------------------------------------------------------------

loc_344E4:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull_1P).l

loc_34502:
                btst    d6,status(a0)
                bne.s   loc_3450A
                clr.b   (a4)

loc_3450A:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                tst.b   1(a4)
                beq.s   loc_3451C
                addi.w  #$F,d0

loc_3451C:
                cmpi.w  #$10,d0
                bhs.s   locret_34552
                move.w  x_pos(a0),x_pos(a1)
                move.b  default_y_radius(a1),d0
                addi.b  #$18,d0
                move.b  d0,y_radius(a1)
                bset    #0,object_control(a1)
                move.b  #$80,status_tertiary(a1)
                bclr    d6,status(a0)
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                addq.b  #2,(a4)

locret_34552:
                rts
; ---------------------------------------------------------------------------

loc_34554:
                cmpi.b  #4,routine(a1)
                bhs.w   sub_3472C
                tst.w   (Debug_placement_mode).w
                bne.s   loc_3459C
                move.w  d5,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_345BA
                move.w  #-$680,y_vel(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.w  #sfx_Jump,d0
                jsr     (Play_SFX).l

loc_3459C:
                bclr    #0,object_control(a1)
                move.b  #0,status_tertiary(a1)
                bset    #Status_InAir,status(a1)
                clr.b   (a4)
                cmpa.w  #Player_1,a1
                beq.w   sub_3472C

locret_345B8:
                rts
; ---------------------------------------------------------------------------

loc_345BA:
                move.w  d5,d0
                andi.w  #$C00,d0
                bne.s   loc_345DA
                tst.w   x_vel(a0)
                beq.s   loc_345DA
                bclr    #Status_Facing,status(a1)
                tst.w   x_vel(a0)
                bpl.s   loc_345DA
                bset    #Status_Facing,status(a1)

loc_345DA:
                move.b  default_y_radius(a1),d0
                addi.b  #$18,d0
                move.b  d0,y_radius(a1)
                cmpa.w  #Player_2,a1
                bne.s   loc_345EE
                rts
; ---------------------------------------------------------------------------

loc_345EE:
                move.l  a0,-(sp)
                movea.l a1,a0
                move.w  d5,d3
                cmpi.b  #$10,anim(a0)
                beq.s   loc_34602
                jsr     (sub_34A96).l

loc_34602:
                jsr     (Player_LevelBound).l
                jsr     (MoveSprite2).l
                movea.l (sp)+,a0
                cmpi.b  #$10,anim(a1)
                bne.s   loc_34638
                move.w  x_vel(a1),x_vel(a0)
                move.w  y_vel(a1),y_vel(a0)
                addi.w  #$38,y_vel(a1)
                bset    #1,status(a0)
                move.b  #0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_34638:
                bclr    #6,status_tertiary(a1)
                beq.s   loc_3464C
                move.w  #0,ground_vel(a0)
                move.w  #0,x_vel(a0)

loc_3464C:
                bclr    #5,status_tertiary(a1)
                beq.s   loc_3465A
                move.w  #0,y_vel(a0)

loc_3465A:
                move.w  x_vel(a0),x_vel(a1)
                move.w  y_vel(a0),y_vel(a1)
                move.w  top_solid_bit(a1),top_solid_bit(a0)
                tst.b   $34(a0)
                bne.w   locret_345B8
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                beq.w   loc_34702
                bcc.w   loc_346C2
                cmpi.w  #-$200,x_vel(a0)
                ble.s   loc_3469C
                add.w   d0,x_vel(a0)
                add.w   d0,x_vel(a0)
                add.w   d0,x_vel(a0)
                add.w   d0,x_vel(a0)

loc_3469C:
                add.w   d0,$24(a0)
                move.w  x_vel(a0),d0
                bpl.s   loc_346BA
                asr.w   #4,d0
                subi.w  #8,y_vel(a0)
                cmpi.w  #-$100,y_vel(a0)
                ble.s   loc_346BA
                add.w   d0,y_vel(a0)

loc_346BA:
                bset    #1,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_346C2:
                cmpi.w  #$200,x_vel(a0)
                bge.s   loc_346DA
                add.w   d0,x_vel(a0)
                add.w   d0,x_vel(a0)
                add.w   d0,x_vel(a0)
                add.w   d0,x_vel(a0)

loc_346DA:
                add.w   d0,$24(a0)
                move.w  x_vel(a0),d0
                bmi.s   loc_346FA
                neg.w   d0
                asr.w   #4,d0
                subi.w  #8,y_vel(a0)
                cmpi.w  #-$100,y_vel(a0)
                ble.s   loc_346FA
                add.w   d0,y_vel(a0)

loc_346FA:
                bset    #1,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_34702:
                moveq   #1,d0
                tst.w   x_vel(a0)
                beq.s   loc_34712
                bmi.s   loc_3470E
                neg.w   d0

loc_3470E:
                add.w   d0,x_vel(a0)

loc_34712:
                add.w   d0,$24(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_34720
                clr.w   y_vel(a0)

locret_34720:
                rts
; ---------------------------------------------------------------------------
; unused
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_3472C:
                move.l  #loc_3432A,(a0)
                lea     (Player_1).w,a2
                cmpi.b  #4,$40(a0)
                bne.s   loc_34750
                bclr    #0,object_control(a2)
                move.b  #0,status_tertiary(a2)
                bset    #Status_InAir,status(a2)

loc_34750:
                tst.b   $40(a0)
                beq.s   loc_3475C
                bclr    #Status_OnObj,status(a2)

loc_3475C:
                lea     (Player_2).w,a2
                cmpi.b  #4,$42(a0)
                bne.s   loc_3477A
                bclr    #0,object_control(a2)
                move.b  #0,status_tertiary(a2)
                bset    #Status_InAir,status(a2)

loc_3477A:
                tst.b   $42(a0)
                beq.s   loc_34786
                bclr    #Status_OnObj,status(a2)

loc_34786:
                move.b  #6,$40(a0)
                move.b  #6,$42(a0)
                rts
; End of function sub_3472C

; =============== S U B R O U T I N E =======================================

sub_34794:
                btst    #Status_OnObj,status(a1)
                bne.s   loc_347C4
                cmpi.b  #4,(a4)
                blo.s   locret_347C2
                move.w  y_pos(a0),d0
                subi.w  #$C,d0
                moveq   #0,d1
                move.b  default_y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.b  #0,$2D(a0)

locret_347C2:
                rts
; ---------------------------------------------------------------------------

loc_347C4:
                cmpi.b  #4,(a4)
                blo.s   locret_347FA
                movea.w interact(a1),a2
                cmpi.l  #loc_31D3E,(a2)
                bne.s   loc_347DA
                bsr.w   sub_3472C

loc_347DA:
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a1),d0
                moveq   #0,d1
                move.b  default_y_radius(a1),d1
                add.w   d1,d0
                addi.w  #$D,d0
                move.w  d0,y_pos(a0)
                move.b  #1,$2D(a0)

locret_347FA:
                rts
; End of function sub_34794
