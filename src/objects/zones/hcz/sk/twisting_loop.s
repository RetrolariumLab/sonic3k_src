; Owner: objects/zones/hcz/sk
; Responsibility: Hydrocity twisting-loop geometry, player capture, scripted movement and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
byte_39006:
                dc.b    2,   4,   4,   4,   4,   4,  $C,   0
                even
byte_3900E:
                dc.b    2,   4,   6,   6,   6,   6,   8,   8,   8,   8,  $A,  $A,   0
                even
byte_3901C:
                dc.b    2,   4,   6,   6,   6,   6,   8,   8,   8,   8,  $A,   0
                even
byte_39028:
                dc.b    2,   4,   6,   6,   6,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,  $E,   0
                even
; ---------------------------------------------------------------------------
word_3903C:
                dc.w    $840
                dc.w    $120
                dc.l    byte_39006
                dc.w    $1540
                dc.w    $620
                dc.l    byte_3900E
                dc.w    $1740
                dc.w    $3A0
                dc.l    byte_3900E
                dc.w    $1CC0
                dc.w    $620
                dc.l    byte_39006
                dc.w    $1FC0
                dc.w    $2A0
                dc.l    byte_3901C
                dc.w    $24C0
                dc.w    $220
                dc.l    byte_39028
                dc.w    $26C0
                dc.w    $120
                dc.l    byte_39006
                dc.w    $3040
                dc.w    $620
                dc.l    byte_3900E
; ---------------------------------------------------------------------------

Obj_HCZTwistingLoop:
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                lsl.w   #3,d0
                lea     word_3903C(pc,d0.w),a1
                move.w  (a1)+,$30(a0)
                move.w  (a1)+,$32(a0)
                move.l  (a1)+,$40(a0)
                move.l  #loc_3909C,(a0)

loc_3909C:
                lea     (Player_1).w,a1
                lea     $34(a0),a4
                bsr.s   sub_390C2
                lea     (Player_2).w,a1
                lea     $3A(a0),a4
                bsr.s   sub_390C2
                move.b  $34(a0),d0
                add.b   $3A(a0),d0
                beq.s   loc_390BC
                rts
; ---------------------------------------------------------------------------

loc_390BC:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_390C2:
                moveq   #0,d0
                move.b  (a4),d0
                move.w  off_390F2(pc,d0.w),d0
                jsr     off_390F2(pc,d0.w)
                tst.b   (a4)
                beq.s   locret_390F0
                bsr.w   sub_39208
                moveq   #0,d0
                move.w  2(a4),d0
                divu.w  #$60,d0
                movea.l $40(a0),a2
                move.b  (a2,d0.w),(a4)
                bne.s   locret_390F0
                move.b  #0,object_control(a1)

locret_390F0:
                rts
; End of function sub_390C2

; ---------------------------------------------------------------------------
off_390F2:
                dc.w    loc_39102-off_390F2
                dc.w    loc_3925C-off_390F2
                dc.w    loc_392B6-off_390F2
                dc.w    loc_392EE-off_390F2
                dc.w    loc_3931E-off_390F2
                dc.w    loc_3935E-off_390F2
                dc.w    loc_3938E-off_390F2
                dc.w    loc_393BE-off_390F2
; ---------------------------------------------------------------------------

loc_39102:
                tst.w   (Debug_placement_mode).w
                bne.w   locret_39196
                tst.b   subtype(a0)
                bmi.w   loc_39198
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #8,d0
                cmpi.w  #$10,d0
                bhs.s   locret_39196
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                cmpi.w  #$30,d1
                bhs.s   locret_39196
                tst.b   object_control(a1)
                bne.s   locret_39196
                btst    #0,status(a0)
                beq.s   loc_39152
                tst.w   ground_vel(a1)
                bpl.s   locret_39196
                tst.w   x_vel(a1)
                bpl.s   locret_39196
                neg.w   ground_vel(a1)
                bra.s   loc_39158
; ---------------------------------------------------------------------------

loc_39152:
                tst.w   ground_vel(a1)
                bmi.s   locret_39196

loc_39158:
                addq.b  #2,(a4)
                move.b  #1,object_control(a1)
                move.b  #2,anim(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_Push,status(a1)
                move.b  #$28,angle(a1)
                move.w  y_pos(a1),d1
                sub.w   $32(a0),d1
                move.w  d1,2(a4)

locret_39196:
                rts
; ---------------------------------------------------------------------------

loc_39198:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   locret_39196
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$10,d1
                cmpi.w  #$10,d1
                bhs.s   locret_39196
                tst.b   object_control(a1)
                bne.s   locret_39196
                tst.w   ground_vel(a1)
                bpl.s   locret_39196
                addq.b  #2,(a4)
                move.b  #1,object_control(a1)
                move.b  #2,anim(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_Push,status(a1)
                move.b  #$28,angle(a1)
                move.w  y_pos(a1),d1
                sub.w   $32(a0),d1
                move.w  d1,2(a4)
                rts

; =============== S U B R O U T I N E =======================================

sub_39208:
                move.b  angle(a1),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a1),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a1)
                muls.w  ground_vel(a1),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a1)
                move.b  angle(a1),d0
                jsr     (GetSineCosine).l
                muls.w  #$50,d0
                asr.l   #8,d0
                tst.w   ground_vel(a1)
                bmi.s   loc_39250
                tst.w   d0
                bpl.s   loc_39242
                asr.l   #2,d0

loc_39242:
                cmpi.w  #$1800,ground_vel(a1)
                bge.s   locret_3925A
                add.w   d0,ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_39250:
                tst.w   d0
                bmi.s   loc_39256
                asr.l   #2,d0

loc_39256:
                add.w   d0,ground_vel(a1)

locret_3925A:
                rts
; End of function sub_39208

; ---------------------------------------------------------------------------

loc_3925C:
                move.w  2(a4),d0
                subi.w  #$16,d0
                bcc.s   loc_39282
                tst.w   ground_vel(a1)
                bpl.s   loc_39280
                move.b  #0,(a4)
                move.b  #0,object_control(a1)
                move.b  #$70,angle(a1)
                bra.w   sub_39208
; ---------------------------------------------------------------------------

loc_39280:
                moveq   #0,d0

loc_39282:
                mulu.w  #$DD,d0
                lsr.w   #8,d0
                jsr     (GetSineCosine).l
                muls.w  #-$2800,d0
                swap    d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a1)
                move.w  2(a4),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a1)
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,2(a4)
                rts
; ---------------------------------------------------------------------------

loc_392B6:
                move.w  2(a4),d0
                mulu.w  #$AA,d0
                asr.w   #8,d0
                jsr     (GetSineCosine).l
                muls.w  #-$2800,d0
                swap    d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a1)
                move.w  2(a4),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a1)
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,2(a4)
                rts
; ---------------------------------------------------------------------------

loc_392EE:
                move.w  2(a4),d0
                subi.w  #$C0,d0
                muls.w  #$AA,d0
                asr.l   #8,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a1)
                move.w  2(a4),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a1)
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,2(a4)
                rts
; ---------------------------------------------------------------------------

loc_3931E:
                move.w  2(a4),d0
                subi.w  #$180,d0
                mulu.w  #$AA,d0
                asr.w   #8,d0
                jsr     (GetSineCosine).l
                muls.w  #-$2800,d0
                swap    d0
                addi.w  #$100,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a1)
                move.w  2(a4),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a1)
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,2(a4)
                rts
; ---------------------------------------------------------------------------

loc_3935E:
                move.w  2(a4),d0
                subi.w  #$240,d0
                muls.w  #$AA,d0
                asr.l   #8,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a1)
                move.w  2(a4),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a1)
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,2(a4)
                rts
; ---------------------------------------------------------------------------

loc_3938E:
                move.w  2(a4),d0
                subi.w  #$240,d0
                muls.w  #$AA,d0
                asr.l   #8,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a1)
                move.w  2(a4),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a1)
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,2(a4)
                rts
; ---------------------------------------------------------------------------

loc_393BE:
                move.w  2(a4),d0
                subi.w  #$540,d0
                muls.w  #$AA,d0
                asr.l   #8,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a1)
                move.w  2(a4),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a1)
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,2(a4)
                rts
; ---------------------------------------------------------------------------

loc_393EE:
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.l  #Map_SonicSnowboard,mappings(a0)
                move.w  #$100,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.b  #6,mapping_frame(a0)
                move.w  #1,anim(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_39434
                move.l  #loc_398E0,(a1)
                move.w  a0,$30(a1)

loc_39434:
                move.l  #loc_3943A,(a0)

loc_3943A:
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                btst    #Status_InAir,status(a1)
                bne.s   loc_3945E
                move.b  #1,anim(a0)
                move.l  #loc_394A0,(a0)

loc_3945E:
                lea     (Ani_SonicSnowboard).l,a1
                jsr     (Animate_Sprite).l
                jsr     (sub_3968E).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_SonicSnowboard:
                include "src/objects/shared/sonic/animations/snowboard.s"
; ---------------------------------------------------------------------------

loc_394A0:
                lea     (Player_1).w,a2
                move.w  x_pos(a2),x_pos(a0)
                move.w  y_pos(a2),y_pos(a0)
                moveq   #0,d0
                move.b  angle(a2),d0
                addq.b  #5,d0
                lsr.w   #4,d0
                move.b  byte_394F2(pc,d0.w),anim(a0)
                btst    #Status_InAir,status(a2)
                beq.s   loc_39502
                move.b  #0,anim(a0)
                tst.w   x_vel(a2)
                beq.s   loc_394E2
                cmpi.w  #$1000,x_vel(a2)
                blt.s   loc_394E2
                move.w  #$1000,x_vel(a2)

loc_394E2:
                cmpi.w  #-$200,y_vel(a2)
                bge.s   loc_39554
                move.w  #-$200,y_vel(a2)
                bra.s   loc_39554
; ---------------------------------------------------------------------------
byte_394F2:
                dc.b    4,   5,   2,   1,   1,   1,   1,   1,   0,   1,   2,   0,   1,   2,   0,   4
; ---------------------------------------------------------------------------

loc_39502:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   loc_39514
                moveq   #signextendB(sfx_SlideSkidQuiet),d0
                jsr     (Play_SFX).l

loc_39514:
                cmpi.w  #$1310,x_pos(a2)
                blo.s   loc_39554
                moveq   #1,d0
                cmpi.w  #$1330,x_pos(a2)
                blo.s   loc_39538
                cmpi.w  #$2210,x_pos(a2)
                blo.s   loc_39554
                cmpi.w  #$2230,x_pos(a2)
                bhs.s   loc_39554
                moveq   #2,d0

loc_39538:
                cmp.b   $36(a0),d0
                beq.s   loc_39554
                move.b  d0,$36(a0)
                move.b  #3,object_control(a2)
                move.l  #loc_395FE,(a0)
                move.w  #0,$34(a0)

loc_39554:
                lea     (Ani_SonicSnowboard).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #8,mapping_frame(a0)
                bne.s   loc_39578
                cmpi.w  #$1000,ground_vel(a2)
                blt.s   loc_39578
                subi.w  #8,ground_vel(a2)
                bra.s   loc_39586
; ---------------------------------------------------------------------------

loc_39578:
                cmpi.w  #$1000,ground_vel(a2)
                bge.s   loc_39586
                move.w  #$1000,ground_vel(a2)

loc_39586:
                cmpi.w  #$3880,x_pos(a2)
                blo.s   loc_395CC
                tst.w   x_vel(a2)
                bne.s   loc_395CC
                move.l  #loc_39676,(a0)
                bset    #Status_InAir,status(a2)
                move.w  #-$200,x_vel(a2)
                move.w  #-$400,y_vel(a2)
                move.b  #$19,anim(a2)
                move.b  #0,object_control(a2)
                move.w  #$14,(Screen_shake_flag).w
                moveq   #signextendB(sfx_Crash),d0
                jsr     (Play_SFX).l
                move.w  #2,(Tails_CPU_routine).w

loc_395CC:
                btst    #Status_InAir,status(a2)
                bne.s   loc_395F2
                move.b  mapping_frame(a0),d0
                cmp.b   $32(a0),d0
                beq.s   loc_395F2
                cmpi.b  #7,d0
                beq.s   loc_395EA
                cmpi.b  #8,d0
                bne.s   loc_395F2

loc_395EA:
                moveq   #signextendB(sfx_GroundSlide),d0
                jsr     (Play_SFX).l

loc_395F2:
                jsr     (sub_3968E).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_395FE:
                lea     (Player_1).w,a2
                move.w  $34(a0),d0
                addq.w  #6,$34(a0)
                lea     (ICZSnowboard_Slope1).l,a1
                cmpi.b  #1,$36(a0)
                beq.s   loc_3961E
                lea     (ICZSnowboard_Slope2).l,a1

loc_3961E:
                lea     (a1,d0.w),a1
                move.w  (a1)+,d0
                move.w  d0,x_pos(a0)
                move.w  d0,x_pos(a2)
                move.w  (a1)+,d0
                move.w  d0,y_pos(a0)
                move.w  d0,y_pos(a2)
                move.w  (a1)+,d0
                move.b  d0,mapping_frame(a0)
                tst.w   (a1)
                bpl.s   loc_39658
                move.b  #$E,top_solid_bit(a2)
                move.b  #$F,lrb_solid_bit(a2)
                move.b  #2,object_control(a2)
                move.l  #loc_394A0,(a0)

loc_39658:
                move.b  mapping_frame(a0),d0
                cmp.b   $32(a0),d0
                beq.s   loc_3966A
                moveq   #signextendB(sfx_GroundSlide),d0
                jsr     (Play_SFX).l

loc_3966A:
                jsr     (sub_3968E).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_39676:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_3967C:
                move.w  #tiles_to_bytes(ArtTile_Snowboard),d4
                move.l  #ArtUnc_Snowboard,d6
                lea     (DPLC_Snowboard).l,a2
                bra.s   loc_3969E
; End of function sub_3967C

; =============== S U B R O U T I N E =======================================

sub_3968E:
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4
                move.l  #ArtUnc_SonicSnowboard,d6
                lea     (DPLC_SonicSnowboard).l,a2

loc_3969E:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $32(a0),d0
                beq.s   locret_396E2
                move.b  d0,$32(a0)
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_396E2

loc_396BA:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,loc_396BA

locret_396E2:
                rts
; End of function sub_3968E
