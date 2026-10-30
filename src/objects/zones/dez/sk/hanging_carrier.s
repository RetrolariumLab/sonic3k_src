; Owner: objects/zones/dez/sk
; Responsibility: Hanging carrier movement, player attachment and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZHangCarrier:
                move.l  #Map_DEZHangCarrier,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZMisc+$10,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.b  #$14,y_radius(a0)
                move.w  #$80,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                move.w  d0,$34(a0)
                move.l  #loc_46FC2,(a0)

loc_46FC2:
                tst.b   $30(a0)
                beq.s   loc_46FCE
                move.l  #loc_46FF2,(a0)

loc_46FCE:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d0
                bsr.w   sub_4703E
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2_logical).w,d0
                bsr.w   sub_4703E
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_46FF2:
                jsr     (MoveSprite2).l
                subi.w  #8,y_vel(a0)
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   loc_4702A
                sub.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)
                move.w  #$200,x_vel(a0)
                btst    #0,status(a0)
                beq.s   loc_47024
                neg.w   x_vel(a0)

loc_47024:
                move.l  #loc_4702C,(a0)

loc_4702A:
                bra.s   loc_46FCE
; ---------------------------------------------------------------------------

loc_4702C:
                tst.w   $34(a0)
                beq.s   loc_46FCE
                subq.w  #1,$34(a0)
                jsr     (MoveSprite2).l
                bra.s   loc_46FCE

; =============== S U B R O U T I N E =======================================

sub_4703E:
                tst.b   (a2)
                beq.w   loc_470F8
                tst.b   render_flags(a1)
                bpl.s   loc_470C4
                cmpi.b  #4,routine(a1)
                bhs.s   loc_470C4
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_470D2
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #18,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   loc_47074
                move.b  #60,2(a2)

loc_47074:
                btst    #button_left+8,d0
                beq.s   loc_47080
                move.w  #-$200,x_vel(a1)

loc_47080:
                btst    #button_right+8,d0
                beq.s   loc_4708C
                move.w  #$200,x_vel(a1)

loc_4708C:
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

loc_470C4:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #60,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_470D2:
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$28,y_pos(a1)
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   locret_470F6
                moveq   #signextendB(sfx_Rising),d0
                jsr     (Play_SFX).l

locret_470F6:
                rts
; ---------------------------------------------------------------------------

loc_470F8:
                tst.b   2(a2)
                beq.s   loc_47104
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_47104:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   locret_4717C
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$28,d1
                cmpi.w  #$18,d1
                bhs.w   locret_4717C
                tst.b   object_control(a1)
                bmi.s   locret_4717C
                cmpi.b  #4,routine(a1)
                bhs.s   locret_4717C
                tst.w   (Debug_placement_mode).w
                bne.s   locret_4717C
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$28,y_pos(a1)
                move.b  #$14,anim(a1)
                bclr    #Status_InAir,status(a1)
                move.b  #1,object_control(a1)
                move.b  #1,(a2)
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

locret_4717C:
                rts
; End of function sub_4703E

; ---------------------------------------------------------------------------
Map_DEZHangCarrier:
                include "src/objects/shared/zones/dez/map_hang_carrier.s"
