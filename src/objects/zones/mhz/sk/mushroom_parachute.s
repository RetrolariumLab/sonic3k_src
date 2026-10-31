; Owner: objects/zones/mhz/sk
; Responsibility: Mushroom parachute movement, player contact and descent control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZMushroomParachute:
                move.l  #Map_MHZMushroomParachute,mappings(a0)
                move.w  #make_art_tile(ArtTile_MHZMisc+$86,2,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #$20,x_radius(a0)
                move.b  #$18,y_radius(a0)
                move.w  #$200,ground_vel(a0)
                move.b  #0,angle(a0)
                tst.b   subtype(a0)
                beq.s   loc_3F4FA
                move.b  #$80,angle(a0)

loc_3F4FA:
                move.l  #loc_3F500,(a0)

loc_3F500:
                bsr.w   sub_3F5AA
                tst.b   $30(a0)
                beq.s   loc_3F516
                move.l  #loc_3F51C,(a0)
                move.w  #$300,y_vel(a0)

loc_3F516:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_3F51C:
                bsr.w   sub_3F7E2
                jsr     (MoveSprite2).l
                bsr.w   sub_3F7AE
                bsr.s   sub_3F5AA
                move.w  x_vel(a0),$34(a0)
                move.w  y_vel(a0),$36(a0)
                tst.w   $30(a0)
                bne.s   loc_3F544
                move.l  #loc_3F572,(a0)

loc_3F544:
                tst.b   render_flags(a0)
                bmi.s   loc_3F56C
                move.w  #$7F00,x_pos(a0)
                tst.b   $30(a0)
                beq.s   loc_3F55E
                clr.w   (Player_1+interact).w
                clr.b   (Player_1+object_control).w

loc_3F55E:
                tst.b   $31(a0)
                beq.s   loc_3F56C
                clr.w   (Player_2+interact).w
                clr.b   (Player_2+object_control).w

loc_3F56C:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_3F572:
                bsr.w   sub_3F7E2
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bmi.s   loc_3F5A4
                move.w  #$7F00,x_pos(a0)
                tst.b   $30(a0)
                beq.s   loc_3F596
                clr.w   (Player_1+interact).w
                clr.b   (Player_1+object_control).w

loc_3F596:
                tst.b   $31(a0)
                beq.s   loc_3F5A4
                clr.w   (Player_2+interact).w
                clr.b   (Player_2+object_control).w

loc_3F5A4:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_3F5AA:
                lea     $31(a0),a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d0
                bsr.s   sub_3F5C2
                lea     (Player_1).w,a1
                subq.w  #1,a2
                move.w  (Ctrl_1_logical).w,d0
; End of function sub_3F5AA

; =============== S U B R O U T I N E =======================================

sub_3F5C2:
                tst.b   (a2)
                beq.w   loc_3F6FE
                tst.b   render_flags(a1)
                bpl.w   loc_3F660
                cmpi.b  #4,routine(a1)
                bhs.w   loc_3F666
                tst.w   (Debug_placement_mode).w
                bne.w   loc_3F666
                move.w  $34(a0),d1
                cmp.w   x_vel(a1),d1
                bne.s   loc_3F660
                move.w  $36(a0),d1
                cmp.w   y_vel(a1),d1
                bne.s   loc_3F660
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_3F678
                clr.w   interact(a1)
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$12,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   loc_3F61C
                move.b  #$3C,2(a2)

loc_3F61C:
                btst    #button_left+8,d0
                beq.s   loc_3F628
                move.w  #-$200,x_vel(a1)

loc_3F628:
                btst    #button_right+8,d0
                beq.s   loc_3F634
                move.w  #$200,x_vel(a1)

loc_3F634:
                move.w  #-$380,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                rts
; ---------------------------------------------------------------------------

loc_3F660:
                move.w  #-$100,y_vel(a1)

loc_3F666:
                clr.w   interact(a1)
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_3F678:
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$25,y_pos(a1)
                move.w  x_vel(a0),x_vel(a1)
                move.w  y_vel(a0),y_vel(a1)
                movem.l d0-a6,-(sp)
                movea.l a1,a0
                jsr     (SonicKnux_DoLevelCollision).l
                movem.l (sp)+,d0-a6

loc_3F6A6:
                bclr    #Status_Facing,status(a1)
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bpl.s   loc_3F6BC
                bset    #Status_Facing,status(a1)

loc_3F6BC:
                move.b  status(a1),d0
                andi.b  #1,d0
                andi.b  #$FC,render_flags(a1)
                or.b    d0,render_flags(a1)
                moveq   #0,d0
                move.b  angle(a0),d0
                lsr.w   #4,d0
                move.b  RawAni_3F6EE(pc,d0.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------
RawAni_3F6EE:
                dc.b    $E4, $E5, $E6, $E6, $E7, $E6, $E6, $E5, $E4, $E5, $E6, $E6, $E7, $E6, $E6, $E5
                even
; ---------------------------------------------------------------------------

loc_3F6FE:
                tst.b   2(a2)
                beq.s   loc_3F70C
                subq.b  #1,2(a2)
                bne.w   locret_3F7AC

loc_3F70C:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   locret_3F7AC
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$25,d1
                cmpi.w  #$18,d1
                bhs.w   locret_3F7AC
                tst.b   object_control(a1)
                bne.s   locret_3F7AC
                cmpi.b  #4,routine(a1)
                bhs.s   locret_3F7AC
                tst.w   (Debug_placement_mode).w
                bne.s   locret_3F7AC
                tst.w   y_vel(a1)
                beq.s   locret_3F7AC
                bmi.s   locret_3F7AC
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$25,y_pos(a1)
                move.b  #0,anim(a1)
                move.b  #0,spin_dash_flag(a1)
                move.b  #3,object_control(a1)
                andi.b  #$FD,render_flags(a1)
                move.b  #1,(a2)
                move.w  a0,interact(a1)
                move.w  #$80,priority(a0)
                move.w  x_vel(a0),x_vel(a1)
                move.w  y_vel(a0),y_vel(a1)
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l
                bra.w   loc_3F6A6
; ---------------------------------------------------------------------------

locret_3F7AC:
                rts
; End of function sub_3F5C2

; =============== S U B R O U T I N E =======================================

sub_3F7AE:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$D,lrb_solid_bit(a0)
                beq.s   loc_3F7C2
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_3F7C2:
                moveq   #$D,d5
                jsr     (sub_FD32).l
                tst.w   d1
                bpl.s   loc_3F7D2
                sub.w   d1,x_pos(a0)

loc_3F7D2:
                jsr     (sub_FA1A).l
                tst.w   d1
                bpl.s   locret_3F7E0
                add.w   d1,x_pos(a0)

locret_3F7E0:
                rts
; End of function sub_3F7AE

; =============== S U B R O U T I N E =======================================

sub_3F7E2:
                move.b  angle(a0),d0
                tst.b   $30(a0)
                beq.s   loc_3F818
                btst    #button_left,(Ctrl_1_held_logical).w
                beq.s   loc_3F804
                cmpi.b  #$80,d0
                beq.s   loc_3F804
                tst.b   d0
                bpl.s   loc_3F800
                neg.b   d0

loc_3F800:
                addq.b  #2,d0
                bra.s   loc_3F822
; ---------------------------------------------------------------------------

loc_3F804:
                btst    #button_right,(Ctrl_1_held_logical).w
                beq.s   loc_3F818
                tst.b   d0
                beq.s   loc_3F818
                bmi.s   loc_3F814
                neg.b   d0

loc_3F814:
                addq.b  #2,d0
                bra.s   loc_3F822
; ---------------------------------------------------------------------------

loc_3F818:
                move.b  d0,d1
                andi.b  #$7F,d1
                beq.s   loc_3F822
                addq.b  #2,d0

loc_3F822:
                move.b  d0,angle(a0)
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                cmpi.w  #$80,y_vel(a0)
                blt.s   loc_3F84A
                subi.w  #$20,y_vel(a0)
                bra.s   locret_3F850
; ---------------------------------------------------------------------------

loc_3F84A:
                addi.w  #$20,y_vel(a0)

locret_3F850:
                rts
; End of function sub_3F7E2

; ---------------------------------------------------------------------------
Map_MHZMushroomParachute:
                include "src/objects/shared/zones/mhz/mappings/mushroom_parachute.s"
