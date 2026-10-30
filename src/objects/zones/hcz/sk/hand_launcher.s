; Owner: objects/zones/hcz/sk
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
                bne.s   loc_30B52
                move.l  #loc_30DEC,(a1)
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

loc_30B52:
                move.l  #loc_30B58,(a0)

loc_30B58:
                move.w  x_pos(a0),d1
                subi.w  #$20,d1
                move.w  (Player_1+x_pos).w,d0
                sub.w   d1,d0
                cmpi.w  #$40,d0
                blo.s   loc_30B78
                move.w  (Player_2+x_pos).w,d0
                sub.w   d1,d0
                cmpi.w  #$40,d0
                bhs.s   loc_30BD6

loc_30B78:
                tst.b   $34(a0)
                beq.s   loc_30BB0
                move.b  #7,mapping_frame(a0)
                move.w  #$80,priority(a0)
                tst.w   $36(a0)
                beq.s   loc_30B96
                subq.w  #1,$36(a0)
                bra.s   loc_30BD0
; ---------------------------------------------------------------------------

loc_30B96:
                tst.w   $30(a0)
                beq.s   loc_30BA2
                subq.w  #8,$30(a0)
                bra.s   loc_30BD0
; ---------------------------------------------------------------------------

loc_30BA2:
                move.l  #loc_30C06,(a0)
                move.w  #60-1,$36(a0)
                bra.s   loc_30BD0
; ---------------------------------------------------------------------------

loc_30BB0:
                move.w  #20-1,$36(a0)
                move.b  #6,mapping_frame(a0)
                move.w  #$200,priority(a0)
                cmpi.w  #$18,$30(a0)
                bls.s   loc_30BD0
                subq.w  #8,$30(a0)
                bra.s   loc_30BE2
; ---------------------------------------------------------------------------

loc_30BD0:
                bsr.w   sub_30CE0
                bra.s   loc_30BE2
; ---------------------------------------------------------------------------

loc_30BD6:
                cmpi.w  #$50,$30(a0)
                beq.s   loc_30BE2
                addq.w  #8,$30(a0)

loc_30BE2:
                move.w  $30(a0),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                move.w  #$20,d1
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_30C06:
                tst.w   $36(a0)
                beq.s   loc_30C16
                subq.w  #1,$36(a0)
                bsr.w   sub_30CE0
                bra.s   loc_30C50
; ---------------------------------------------------------------------------

loc_30C16:
                cmpi.w  #$50,$30(a0)
                bne.s   loc_30C34
                move.b  #0,$34(a0)
                move.l  #loc_30B58,(a0)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   loc_30C50
; ---------------------------------------------------------------------------

loc_30C34:
                cmpi.w  #$18,$30(a0)
                bne.s   loc_30C4C
                bsr.w   sub_30C7C
                move.b  #6,mapping_frame(a0)
                move.w  #$200,priority(a0)

loc_30C4C:
                addq.w  #8,$30(a0)

loc_30C50:
                move.w  $30(a0),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                cmpi.w  #$18,$30(a0)
                bhi.s   loc_30C76
                move.w  #$20,d1
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l

loc_30C76:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_30C7C:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.w   sub_30C8C
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
; End of function sub_30C7C

; =============== S U B R O U T I N E =======================================

sub_30C8C:
                bclr    d6,$35(a0)
                beq.s   loc_30CCC
                move.w  #$1000,ground_vel(a1)
                move.w  #$1000,x_vel(a1)
                move.w  #0,y_vel(a1)
                btst    #0,status(a0)
                beq.s   loc_30CB4
                neg.w   ground_vel(a1)
                neg.w   x_vel(a1)

loc_30CB4:
                move.b  #0,anim(a1)
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_30CCC:
                bclr    d6,status(a0)
                beq.s   locret_30CDE
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)

locret_30CDE:
                rts
; End of function sub_30C8C

; =============== S U B R O U T I N E =======================================

sub_30CE0:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.b  (Ctrl_1_pressed_logical).w,d0
                bsr.w   sub_30CF8
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.b  (Ctrl_2_pressed_logical).w,d0
; End of function sub_30CE0

; =============== S U B R O U T I N E =======================================

sub_30CF8:
                btst    d6,$35(a0)
                beq.s   loc_30D4E
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   locret_30D4C
                bclr    d6,$35(a0)
                bclr    d6,status(a0)
                move.w  #$800,ground_vel(a1)
                move.w  #$800,x_vel(a1)
                move.w  #-$400,y_vel(a1)
                btst    #0,status(a0)
                beq.s   loc_30D2E
                neg.w   ground_vel(a1)
                neg.w   x_vel(a1)

loc_30D2E:
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                tst.b   $35(a0)
                bne.s   locret_30D4C
                move.b  #0,$34(a0)

locret_30D4C:
                rts
; ---------------------------------------------------------------------------

loc_30D4E:
                btst    d6,status(a0)
                beq.w   locret_30DEA
                tst.b   $34(a0)
                bne.s   loc_30D6E
                move.w  x_pos(a1),d0
                addi.w  #8,d0
                sub.w   x_pos(a0),d0
                cmpi.w  #2*8,d0
                bhs.s   locret_30DEA

loc_30D6E:
                tst.b   object_control(a1)
                bne.s   locret_30DEA
                tst.w   (Debug_placement_mode).w
                bne.s   locret_30DEA
                bset    d6,$35(a0)
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                move.b  #0,anim(a1)
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)
                bclr    #Status_Roll,status(a1)
                cmpi.l  #Obj_Tails,(a1)
                bne.s   loc_30DAC
                move.b  #$F,y_radius(a1)

loc_30DAC:
                move.b  #1,object_control(a1)
                bclr    #Status_Push,status(a1)
                move.w  x_pos(a0),x_pos(a1)
                subq.w  #2,x_pos(a1)
                move.w  #$1000,ground_vel(a1)
                bclr    #Status_Facing,status(a1)
                btst    #0,status(a0)
                beq.s   loc_30DE4
                addq.w  #2*2,x_pos(a1)
                neg.w   ground_vel(a1)
                bset    #Status_Facing,status(a1)

loc_30DE4:
                move.b  #1,$34(a0)

locret_30DEA:
                rts
; End of function sub_30CF8

; ---------------------------------------------------------------------------

loc_30DEC:
                movea.w $3C(a0),a1
                move.w  y_pos(a1),y_pos(a0)
                cmpi.w  #$18,$30(a1)
                bls.s   loc_30E00
                rts
; ---------------------------------------------------------------------------

loc_30E00:
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #6,mapping_frame(a0)
                blo.s   loc_30E12
                move.b  #0,mapping_frame(a0)

loc_30E12:
                jmp     (Sprite_OnScreen_Test).l
; End of function loc_30DEC
