; Owner: objects/zones/lbz/sk
; Responsibility: Unused Launch Base bar platform movement, player riding and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZUnusedBarPlatform:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_253BE
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  status(a0),status(a1)
                move.l  #Map_LBZUnusedBarPlatform,mappings(a1)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a1)
                move.b  #4,render_flags(a1)
                move.w  #$180,priority(a1)
                move.b  #$20,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  a0,$3E(a1)
                move.l  #loc_253C2,(a1)
                move.w  a1,$3E(a0)
                move.b  #1,$3D(a0)

loc_253BE:
                bra.w   Obj_LBZMovingPlatform
; ---------------------------------------------------------------------------

loc_253C2:
                move.w  x_pos(a0),d4
                movea.w $3E(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                sub.w   x_pos(a1),d4
                bsr.s   sub_253E2
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_253E2:
                lea     $33(a0),a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2).w,d0
                bsr.s   sub_253FA
                lea     (Player_1).w,a1
                subq.w  #1,a2
                move.w  (Ctrl_1).w,d0
; End of function sub_253E2

; =============== S U B R O U T I N E =======================================

sub_253FA:
                tst.b   (a2)
                beq.w   loc_25476
                tst.b   render_flags(a1)
                bpl.s   loc_25456
                cmpi.b  #4,routine(a1)
                bhs.s   loc_25456
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_25464
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$12,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   loc_25430
                move.b  #$3C,2(a2)

loc_25430:
                btst    #button_left+8,d0
                beq.s   loc_2543C
                move.w  #-$200,x_vel(a1)

loc_2543C:
                btst    #button_right+8,d0
                beq.s   loc_25448
                move.w  #$200,x_vel(a1)

loc_25448:
                move.w  #-$380,y_vel(a1)
                bset    #Status_InAir,status(a1)
                rts
; ---------------------------------------------------------------------------

loc_25456:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_25464:
                sub.w   d4,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$24,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

loc_25476:
                tst.b   2(a2)
                beq.s   loc_25484
                subq.b  #1,2(a2)
                bne.w   locret_254E8

loc_25484:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$1C,d0
                cmpi.w  #$38,d0
                bhs.w   locret_254E8
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$18,d1
                cmpi.w  #$18,d1
                bhs.w   locret_254E8
                tst.b   object_control(a1)
                bne.s   locret_254E8
                cmpi.b  #4,routine(a1)
                bhs.s   locret_254E8
                tst.w   (Debug_placement_mode).w
                bne.s   locret_254E8
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$24,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #1,object_control(a1)
                move.b  #1,(a2)

locret_254E8:
                rts
; End of function sub_253FA

; ---------------------------------------------------------------------------
Map_LBZUnusedBarPlatform:
                include "src/objects/shared/zones/lbz/mappings/unused_bar_platform.s"
