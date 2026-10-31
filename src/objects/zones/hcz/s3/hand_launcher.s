; Owner: objects/zones/hcz/s3
; Responsibility: Hydrocity hand launcher state, player capture, launch and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZHandLauncher:
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.l  #Map_HCZHandLauncher,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZMisc+$1A,1,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  #6,mapping_frame(a0)
                move.w  #$50,$30(a0)
                bset    #7,status(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_2F6D2
                move.l  #loc_2F96C,(a1)
                move.l  #Map_HCZHandLauncher,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZMisc+$1A,1,0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  #$20,width_pixels(a1)
; Bug: This is missing the height, and it overwrites what the previous line did
                move.b  #$30,width_pixels(a1)
                move.w  #$280,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  a0,$3C(a1)

loc_2F6D2:
                move.l  #loc_2F6D8,(a0)

loc_2F6D8:
                move.w  x_pos(a0),d1
                subi.w  #$20,d1
                move.w  (Player_1+x_pos).w,d0
                sub.w   d1,d0
                cmpi.w  #$40,d0
                blo.s   loc_2F6F8
                move.w  (Player_2+x_pos).w,d0
                sub.w   d1,d0
                cmpi.w  #$40,d0
                bhs.s   loc_2F756

loc_2F6F8:
                tst.b   $34(a0)
                beq.s   loc_2F730
                move.b  #7,mapping_frame(a0)
                move.w  #$80,priority(a0)
                tst.w   $36(a0)
                beq.s   loc_2F716
                subq.w  #1,$36(a0)
                bra.s   loc_2F750
; ---------------------------------------------------------------------------

loc_2F716:
                tst.w   $30(a0)
                beq.s   loc_2F722
                subq.w  #8,$30(a0)
                bra.s   loc_2F750
; ---------------------------------------------------------------------------

loc_2F722:
                move.l  #loc_2F786,(a0)
                move.w  #60-1,$36(a0)
                bra.s   loc_2F750
; ---------------------------------------------------------------------------

loc_2F730:
                move.w  #20-1,$36(a0)
                move.b  #6,mapping_frame(a0)
                move.w  #$200,priority(a0)
                cmpi.w  #$18,$30(a0)
                bls.s   loc_2F750
                subq.w  #8,$30(a0)
                bra.s   loc_2F762
; ---------------------------------------------------------------------------

loc_2F750:
                bsr.w   sub_2F860
                bra.s   loc_2F762
; ---------------------------------------------------------------------------

loc_2F756:
                cmpi.w  #$50,$30(a0)
                beq.s   loc_2F762
                addq.w  #8,$30(a0)

loc_2F762:
                move.w  $30(a0),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                move.w  #$20,d1
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2F786:
                tst.w   $36(a0)
                beq.s   loc_2F796
                subq.w  #1,$36(a0)
                bsr.w   sub_2F860
                bra.s   loc_2F7D0
; ---------------------------------------------------------------------------

loc_2F796:
                cmpi.w  #$50,$30(a0)
                bne.s   loc_2F7B4
                move.b  #0,$34(a0)
                move.l  #loc_2F6D8,(a0)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   loc_2F7D0
; ---------------------------------------------------------------------------

loc_2F7B4:
                cmpi.w  #$18,$30(a0)
                bne.s   loc_2F7CC
                bsr.w   sub_2F7FC
                move.b  #6,mapping_frame(a0)
                move.w  #$200,priority(a0)

loc_2F7CC:
                addq.w  #8,$30(a0)

loc_2F7D0:
                move.w  $30(a0),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                cmpi.w  #$18,$30(a0)
                bhi.s   loc_2F7F6
                move.w  #$20,d1
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l

loc_2F7F6:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_2F7FC:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.w   sub_2F80C
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
; End of function sub_2F7FC

; =============== S U B R O U T I N E =======================================

sub_2F80C:
                bclr    d6,$35(a0)
                beq.s   loc_2F84C
                move.w  #$1000,ground_vel(a1)
                move.w  #$1000,x_vel(a1)
                move.w  #0,y_vel(a1)
                btst    #0,status(a0)
                beq.s   loc_2F834
                neg.w   ground_vel(a1)
                neg.w   x_vel(a1)

loc_2F834:
                move.b  #0,anim(a1)
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_2F84C:
                bclr    d6,status(a0)
                beq.s   locret_2F85E
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)

locret_2F85E:
                rts
; End of function sub_2F80C

; =============== S U B R O U T I N E =======================================

sub_2F860:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.b  (Ctrl_1_pressed_logical).w,d0
                bsr.w   sub_2F878
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.b  (Ctrl_2_pressed_logical).w,d0
; End of function sub_2F860

; =============== S U B R O U T I N E =======================================

sub_2F878:
                btst    d6,$35(a0)
                beq.s   loc_2F8CE
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   locret_2F8CC
                bclr    d6,$35(a0)
                bclr    d6,status(a0)
                move.w  #$800,ground_vel(a1)
                move.w  #$800,x_vel(a1)
                move.w  #-$400,y_vel(a1)
                btst    #0,status(a0)
                beq.s   loc_2F8AE
                neg.w   ground_vel(a1)
                neg.w   x_vel(a1)

loc_2F8AE:
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                tst.b   $35(a0)
                bne.s   locret_2F8CC
                move.b  #0,$34(a0)

locret_2F8CC:
                rts
; ---------------------------------------------------------------------------

loc_2F8CE:
                btst    d6,status(a0)
                beq.w   locret_2F96A
                tst.b   $34(a0)
                bne.s   loc_2F8EE
                move.w  x_pos(a1),d0
                addi.w  #8,d0
                sub.w   x_pos(a0),d0
                cmpi.w  #2*8,d0
                bhs.s   locret_2F96A

loc_2F8EE:
                tst.b   object_control(a1)
                bne.s   locret_2F96A
                tst.w   (Debug_placement_mode).w
                bne.s   locret_2F96A
                bset    d6,$35(a0)
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                move.b  #0,anim(a1)
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)
                bclr    #Status_Roll,status(a1)
                cmpi.l  #Obj_Sonic,(a1)
                beq.s   loc_2F92C
                move.b  #$F,y_radius(a1)

loc_2F92C:
                move.b  #1,object_control(a1)
                bclr    #Status_Push,status(a1)
                move.w  x_pos(a0),x_pos(a1)
                subq.w  #2,x_pos(a1)
                move.w  #$1000,ground_vel(a1)
                bclr    #Status_Facing,status(a1)
                btst    #0,status(a0)
                beq.s   loc_2F964
                addq.w  #2*2,x_pos(a1)
                neg.w   ground_vel(a1)
                bset    #Status_Facing,status(a1)

loc_2F964:
                move.b  #1,$34(a0)

locret_2F96A:
                rts
; End of function sub_2F878

; ---------------------------------------------------------------------------

loc_2F96C:
                movea.w $3C(a0),a1
                move.w  y_pos(a1),y_pos(a0)
                cmpi.w  #$18,$30(a1)
                bls.s   loc_2F980
                rts
; ---------------------------------------------------------------------------

loc_2F980:
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #6,mapping_frame(a0)
                blo.s   loc_2F992
                move.b  #0,mapping_frame(a0)

loc_2F992:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_HCZHandLauncher:
                include "src/objects/shared/zones/hcz/mappings/hand_launcher.s"
; End of function loc_2F96C
