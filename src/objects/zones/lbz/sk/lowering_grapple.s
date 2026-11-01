; Owner: objects/zones/lbz/sk
; Responsibility: Launch Base lowering grapple movement and player attachment or release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZLoweringGrapple:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  #$80,height_pixels(a0)
                move.w  y_pos(a0),$3C(a0)
                move.l  #Map_LBZLoweringGrapple,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a0)
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                lsl.w   #3,d0
                move.w  d0,$2E(a0)
                move.w  #2,$3A(a0)
                move.b  subtype(a0),d0
                bpl.s   loc_29080
                move.w  $2E(a0),d0
                move.w  d0,$38(a0)
                move.b  #1,$36(a0)
                add.w   d0,y_pos(a0)
                lsr.w   #4,d0
                addq.w  #1,d0
                move.b  d0,mapping_frame(a0)

loc_29080:
                move.l  #loc_29086,(a0)

loc_29086:
                tst.b   $36(a0)
                beq.s   loc_29094
                tst.w   $30(a0)
                bne.s   loc_290AA
                bra.s   loc_2909A
; ---------------------------------------------------------------------------

loc_29094:
                tst.w   $30(a0)
                beq.s   loc_290AA

loc_2909A:
                move.w  $38(a0),d2
                cmp.w   $2E(a0),d2
                beq.s   loc_290CE
                add.w   $3A(a0),d2
                bra.s   loc_290B4
; ---------------------------------------------------------------------------

loc_290AA:
                move.w  $38(a0),d2
                beq.s   loc_290CE
                sub.w   $3A(a0),d2

loc_290B4:
                move.w  d2,$38(a0)
                move.w  $3C(a0),d0
                add.w   d2,d0
                move.w  d0,y_pos(a0)
                move.w  d2,d0
                beq.s   loc_290CA
                lsr.w   #4,d0
                addq.w  #1,d0

loc_290CA:
                move.b  d0,mapping_frame(a0)

loc_290CE:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d0
                bsr.w   UpdatePlayerOnLbzLoweringGrapple
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2_logical).w,d0
                bsr.w   UpdatePlayerOnLbzLoweringGrapple
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnLbzLoweringGrapple:
                tst.b   (a2)
                beq.w   loc_29194
                tst.b   render_flags(a1)
                bpl.s   loc_29178
                cmpi.b  #4,routine(a1)
                bhs.s   loc_29178
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_29186
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$12,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   loc_29128
                move.b  #$3C,2(a2)

loc_29128:
                btst    #button_left+8,d0
                beq.s   loc_29134
                move.w  #-$200,x_vel(a1)

loc_29134:
                btst    #button_right+8,d0
                beq.s   loc_29140
                move.w  #$200,x_vel(a1)

loc_29140:
                move.w  #-$380,y_vel(a1)
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

loc_29178:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_29186:
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$94,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

loc_29194:
                tst.b   2(a2)
                beq.s   loc_291A2
                subq.b  #1,2(a2)
                bne.w   locret_29214

loc_291A2:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   locret_29214
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$88,d1
                cmpi.w  #$18,d1
                bhs.w   locret_29214
                tst.b   object_control(a1)
                bmi.s   locret_29214
                cmpi.b  #4,routine(a1)
                bhs.s   locret_29214
                tst.w   (Debug_placement_mode).w
                bne.s   locret_29214
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$94,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #1,object_control(a1)
                move.b  #1,(a2)
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

locret_29214:
                rts
; End of function UpdatePlayerOnLbzLoweringGrapple
