; Owner: objects/zones/aiz/s3
; Responsibility: Normal Angel Island ride-vine motion, player contact, handle state and positioning helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZRideVine:
                movea.l a0,a1
                move.l  #loc_20168,(a1)
                bsr.w   sub_20140
                move.b  #$21,mapping_frame(a1)
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                moveq   #0,d1
                move.b  subtype(a0),d1
                andi.w  #$7F,d1
                lsl.w   #4,d1
                add.w   d2,d1
                move.w  d1,$46(a0)
                moveq   #3,d1
                addq.w  #1,d1
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2013E
                move.w  a1,$3E(a0)
                move.l  #loc_203C0,(a1)
                move.w  a0,$3C(a1)
                bra.s   loc_20110
; ---------------------------------------------------------------------------

loc_200F8:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2013E
                move.l  #loc_20454,(a1)
                move.w  a2,$3C(a1)
                move.w  a1,$3E(a2)

loc_20110:
                movea.l a1,a2
                bsr.s   sub_20140
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                addi.w  #$10,d3
                addq.w  #1,$36(a0)
                move.w  $36(a0),$36(a1)
                dbf     d1,loc_200F8
                move.l  #Obj_AIZRideVineHandle,(a1)
                move.b  #$20,mapping_frame(a1)
                move.w  a1,$40(a0)

loc_2013E:
                bra.s   loc_20168

; =============== S U B R O U T I N E =======================================

sub_20140:
                move.b  #4,render_flags(a1)
                move.b  #8,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.l  #Map_AIZRideVine,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZSwingVine,0,0),art_tile(a1)
                rts
; End of function sub_20140

; ---------------------------------------------------------------------------

loc_20168:
                movea.w $40(a0),a1
                tst.w   $32(a1)
                beq.s   loc_20188
                move.l  #loc_2018C,(a0)
                movea.w $3E(a0),a1
                move.w  #1,$2E(a1)
                move.w  #0,$38(a1)

loc_20188:
                bra.w   loc_20378
; ---------------------------------------------------------------------------

loc_2018C:
                addi.l  #$80000,x_pos(a0)
                addi.l  #$20000,y_pos(a0)
                move.w  x_pos(a0),d0
                cmp.w   $46(a0),d0
                blo.w   loc_2022E
                tst.b   subtype(a0)
                bpl.s   loc_20202
                move.l  #loc_20232,(a0)
                move.w  #$800,x_vel(a0)
                move.w  #$200,y_vel(a0)
                move.l  #Map_AnimatedStillSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,3,0),art_tile(a0)
                move.b  #8,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #0,mapping_frame(a0)
                move.w  #1,anim(a0)
                movea.w $40(a0),a1
                lea     $32(a1),a2
                tst.b   (a2)
                beq.s   loc_201F6
                move.b  #$81,(a2)

loc_201F6:
                addq.w  #1,a2
                tst.b   (a2)
                beq.s   loc_20200
                move.b  #$81,(a2)

loc_20200:
                bra.s   loc_2022E
; ---------------------------------------------------------------------------

loc_20202:
                move.l  #loc_20254,(a0)
                movea.w $3E(a0),a1
                move.l  #loc_20428,(a1)
                move.w  #0,$3A(a1)
                movea.w $40(a0),a1
                move.w  #1,$30(a1)
                move.w  #0,angle(a0)
                move.w  #$400,$3A(a0)

loc_2022E:
                bra.w   loc_20378
; ---------------------------------------------------------------------------

loc_20232:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.s   loc_20244
                move.w  #$7FF0,x_pos(a0)

loc_20244:
                lea     (Ani_AnimatedStillSprites).l,a1
                jsr     (Animate_Sprite).l
                bra.w   loc_20378
; ---------------------------------------------------------------------------

loc_20254:
                movea.w $40(a0),a1
                move.w  $3A(a0),d0
                move.b  angle(a0),d1
                ext.w   d1
                bpl.s   loc_20266
                neg.w   d1

loc_20266:
                add.w   d1,d1
                sub.w   d1,d0
                sub.w   d0,angle(a0)
                tst.w   $32(a1)
                bne.s   loc_202A8
                move.b  angle(a0),d0
                addq.b  #8,d0
                cmpi.b  #$10,d0
                bhs.s   loc_202A8
                move.l  #loc_202AC,(a0)
                move.w  #0,$42(a0)
                move.w  #-$300,$44(a0)
                move.w  #$1000,$38(a0)
                move.w  #0,$2E(a0)
                movea.w $40(a0),a1
                move.w  #2,$30(a1)

loc_202A8:
                bra.w   loc_20378
; ---------------------------------------------------------------------------

loc_202AC:
                moveq   #0,d2
                move.b  $38(a0),d2
                move.w  $44(a0),d0
                move.w  #0,d1
                tst.w   $2E(a0)
                bne.s   loc_20304
                add.w   d2,d0
                move.w  d0,$44(a0)
                add.w   d0,$42(a0)
                cmp.b   $42(a0),d1
                bgt.s   loc_2032E
                asr.w   #4,d0
                sub.w   d0,$44(a0)
                move.w  #1,$2E(a0)
                cmpi.w  #$C00,$38(a0)
                beq.s   loc_202EC
                subi.w  #$40,$38(a0)
                bra.s   loc_2032E
; ---------------------------------------------------------------------------

loc_202EC:
                move.l  #loc_2034A,(a0)
                move.w  #0,$38(a0)
                movea.w $40(a0),a1
                move.w  #0,$30(a1)
                bra.s   loc_2032E
; ---------------------------------------------------------------------------

loc_20304:
                sub.w   d2,d0
                move.w  d0,$44(a0)
                add.w   d0,$42(a0)
                cmp.b   $42(a0),d1
                ble.s   loc_2032E
                asr.w   #4,d0
                sub.w   d0,$44(a0)
                move.w  #0,$2E(a0)
                cmpi.w  #$C00,$38(a0)
                beq.s   loc_202EC
                subi.w  #$40,$38(a0)

loc_2032E:
                move.w  $42(a0),d0
                move.w  d0,angle(a0)
                asr.w   #3,d0
                move.w  d0,$3A(a0)
                movea.w $3E(a0),a1
                move.w  $3A(a0),$3A(a1)
                bra.w   loc_20378
; ---------------------------------------------------------------------------

loc_2034A:
                move.b  $38(a0),d0
                addi.w  #$200,$38(a0)
                jsr     (GetSineCosine).l
                asl.w   #2,d0
                cmpi.w  #$400,d0
                bne.s   loc_20366
                move.w  #$3FF,d0

loc_20366:
                move.w  d0,angle(a0)
                move.w  d0,$3A(a0)
                movea.w $3E(a0),a1
                move.w  $3A(a0),$3A(a1)

loc_20378:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_20392
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_20392:
                move.w  $36(a0),d2
                subq.w  #1,d2
                bcs.s   loc_203AE
                movea.w $3E(a0),a2

loc_2039E:
                movea.l a2,a1
                movea.w $3E(a1),a2
                jsr     (Delete_Referenced_Sprite).l
                dbf     d2,loc_2039E

loc_203AE:
                move.w  respawn_addr(a0),d0
                beq.s   loc_203BA
                movea.w d0,a2
                bclr    #7,(a2)

loc_203BA:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_203C0:
                tst.w   $2E(a0)
                bne.s   loc_203E8
                move.b  $38(a0),d0
                addi.w  #$200,$38(a0)
                jsr     (GetSineCosine).l
                asl.w   #2,d0
                cmpi.w  #$400,d0
                bne.s   loc_203E2
                move.w  #$3FF,d0

loc_203E2:
                move.w  d0,$3A(a0)
                bra.s   loc_203FE
; ---------------------------------------------------------------------------

loc_203E8:
                move.b  $38(a0),d0
                addi.w  #$100,$38(a0)
                jsr     (GetSineCosine).l
                asl.w   #3,d0
                move.w  d0,$3A(a0)

loc_203FE:
                move.w  $3A(a0),d0
                move.w  d0,angle(a0)
                move.b  angle(a0),d0
                addq.b  #4,d0
                lsr.b   #3,d0
                move.b  d0,mapping_frame(a0)
                movea.w $3C(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_20428:
                movea.w $3C(a0),a1
                move.w  angle(a1),angle(a0)
                move.b  angle(a0),d0
                addq.b  #4,d0
                lsr.b   #3,d0
                move.b  d0,mapping_frame(a0)
                movea.w $3C(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_20454:
                movea.w $3C(a0),a1
                move.w  $3A(a1),$3A(a0)
                move.w  angle(a1),d0
                add.w   $3A(a0),d0
                move.w  d0,angle(a0)
                move.b  angle(a0),d0
                addq.b  #4,d0
                lsr.b   #3,d0
                move.b  d0,mapping_frame(a0)
                bsr.w   sub_20480
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_20480:
                movea.w $3C(a0),a1
                move.b  angle(a1),d0
                addq.b  #4,d0
                andi.b  #$F8,d0
                jsr     (GetSineCosine).l
                neg.w   d0
                addi.w  #8,d0
                addi.w  #8,d1
                asr.w   #4,d0
                asr.w   #4,d1
                add.w   x_pos(a1),d0
                move.w  d0,x_pos(a0)
                add.w   y_pos(a1),d1
                move.w  d1,y_pos(a0)
                rts
; End of function sub_20480

; ---------------------------------------------------------------------------

Obj_AIZRideVineHandle:
                move.w  x_pos(a0),d4
                move.w  y_pos(a0),d5
                bsr.w   sub_20480
                cmp.w   x_pos(a0),d4
                beq.s   loc_204CA
                move.w  d4,$42(a0)

loc_204CA:
                cmp.w   y_pos(a0),d5
                beq.s   loc_204D4
                move.w  d5,$44(a0)

loc_204D4:
                lea     $32(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d0
                bsr.s   sub_20502
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2_logical).w,d0
                bsr.s   sub_20502
                tst.w   $32(a0)
                beq.s   loc_204FA
                tst.w   $30(a0)
                bne.s   locret_20500

loc_204FA:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_20500:
                rts

; =============== S U B R O U T I N E =======================================

sub_20502:
                tst.b   (a2)
                beq.w   loc_206DE
                bmi.w   loc_205BC
                tst.b   render_flags(a1)
                bpl.w   loc_205CE
                cmpi.b  #4,routine(a1)
                bhs.w   loc_205CE
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_205DC
                clr.b   object_control(a1)
                clr.b   (a2)
                cmpi.w  #1,$30(a0)
                beq.s   loc_2059A
                move.w  x_pos(a0),d1
                sub.w   $42(a0),d1
                asl.w   #7,d1
                move.w  d1,x_vel(a1)
                move.w  y_pos(a0),d1
                sub.w   $44(a0),d1
                asl.w   #7,d1
                move.w  d1,y_vel(a1)
                move.b  #$3C,2(a2)
                btst    #button_left+8,d0
                beq.s   loc_20562
                move.w  #-$200,x_vel(a1)

loc_20562:
                btst    #button_right+8,d0
                beq.s   loc_2056E
                move.w  #$200,x_vel(a1)

loc_2056E:
                addi.w  #-$380,y_vel(a1)

loc_20574:
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                rts
; ---------------------------------------------------------------------------

loc_2059A:
                move.b  #$3C,2(a2)
                movea.w $3C(a0),a3
                move.b  angle(a3),d0
                jsr     (GetSineCosine).l
                asl.w   #3,d1
                move.w  d1,x_vel(a1)
                asl.w   #3,d0
                move.w  d0,y_vel(a1)
                bra.s   loc_20574
; ---------------------------------------------------------------------------

loc_205BC:
                move.w  #$300,x_vel(a1)
                move.w  #$200,y_vel(a1)
                bset    #Status_InAir,status(a1)

loc_205CE:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                rts
; End of function sub_20502

; ---------------------------------------------------------------------------

loc_205DC:
                tst.w   $30(a0)
                bne.s   loc_20634
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$14,y_pos(a1)
                movea.w $3C(a0),a3
                moveq   #0,d0
                move.b  angle(a3),d0
                btst    #Status_Facing,status(a1)
                beq.s   loc_20608
                neg.b   d0

loc_20608:
                addq.b  #8,d0
                lsr.w   #4,d0
                move.b  byte_20624(pc,d0.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------
byte_20624:
                dc.b    $91, $91, $90, $90, $90, $90, $90, $90, $92, $92, $92, $92, $92, $92, $91, $91
                even
; ---------------------------------------------------------------------------

loc_20634:
                movea.w $3C(a0),a3
                moveq   #0,d0
                move.b  angle(a3),d0
                btst    #Status_Facing,status(a1)
                beq.s   loc_20648
                neg.b   d0

loc_20648:
                addi.b  #$10,d0
                lsr.w   #5,d0
                add.w   d0,d0
                move.b  byte_206BE(pc,d0.w),mapping_frame(a1)
                move.b  #0,anim(a1)
                andi.w  #$FFFE,d0
                move.b  byte_206CE(pc,d0.w),d2
                move.b  byte_206CE+1(pc,d0.w),d3
                ext.w   d2
                ext.w   d3
                btst    #Status_Facing,status(a1)
                beq.s   loc_20676
                neg.w   d2

loc_20676:
                movea.w $3C(a0),a3
                move.b  angle(a3),d0
                addq.b  #4,d0
                andi.b  #$F8,d0
                jsr     (GetSineCosine).l
                neg.w   d0
                addi.w  #8,d0
                addi.w  #8,d1
                asr.w   #4,d0
                asr.w   #4,d1
                add.w   x_pos(a3),d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                add.w   y_pos(a3),d1
                add.w   d3,d1
                move.w  d1,y_pos(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------
byte_206BE:
                dc.b    $78
                dc.b    $78
                dc.b    $7F
                dc.b    $7F
                dc.b    $7E
                dc.b    $7E
                dc.b    $7D
                dc.b    $7D
                dc.b    $7C
                dc.b    $7C
                dc.b    $7B
                dc.b    $7B
                dc.b    $7A
                dc.b    $7A
                dc.b    $79
                dc.b    $79
byte_206CE:
                dc.b    0, $18
                dc.b    -$12, $13
                dc.b    -$18,   0
                dc.b    -$12,-$13
                dc.b    0,-$18
                dc.b    $12,-$13
                dc.b    $18,   0
                dc.b    $12, $13
                even
; ---------------------------------------------------------------------------

loc_206DE:
                tst.b   2(a2)
                beq.s   loc_206EC
                subq.b  #1,2(a2)
                bne.w   locret_20766

loc_206EC:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   locret_20766
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                cmpi.w  #$18,d1
                bhs.w   locret_20766
                tst.b   object_control(a1)
                bne.s   locret_20766
                cmpi.b  #4,routine(a1)
                bhs.s   locret_20766
                tst.w   (Debug_placement_mode).w
                bne.s   locret_20766
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$14,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #0,spin_dash_flag(a1)
                move.b  #3,object_control(a1)
                andi.b  #$FD,render_flags(a1)
                move.b  #1,(a2)
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

locret_20766:
                rts
