; Owner: objects/zones/fbz/sk
; Responsibility: Spinning pole player capture, rotational motion and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZSpinningPole:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$36(a0)
                move.l  #loc_3BF68,(a0)

loc_3BF68:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d1
                bsr.s   sub_3BFA0
                addq.w  #1,a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d1
                bsr.s   sub_3BFA0
                tst.b   $30(a0)
                beq.s   loc_3BF9A
                move.b  #1,(Scroll_force_positions).w
                move.w  x_pos(a0),(Scroll_forced_X_pos).w
                move.w  (Player_1+y_pos).w,(Scroll_forced_Y_pos).w

loc_3BF9A:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_3BFA0:
                tst.b   (a2)
                beq.w   loc_3C0D0
                tst.w   (Debug_placement_mode).w
                bne.w   loc_3C096
                cmpi.b  #4,routine(a1)
                bhs.w   loc_3C096
                tst.b   object_control(a1)
                bmi.w   loc_3C096
                btst    #button_up+8,d1
                beq.s   loc_3BFD8
                move.w  y_pos(a0),d0
                sub.w   $36(a0),d0
                cmp.w   y_pos(a1),d0
                bge.s   loc_3BFD8
                subq.w  #1,y_pos(a1)

loc_3BFD8:
                btst    #button_down+8,d1
                beq.s   loc_3BFEC
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                ble.s   loc_3BFEC
                addq.w  #1,y_pos(a1)

loc_3BFEC:
                move.w  d1,d0
                andi.w  #$70,d0
                bne.w   loc_3C068
                addi.b  #8,4(a2)
                bsr.s   sub_3C010

loc_3BFFE:
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; End of function sub_3BFA0

; =============== S U B R O U T I N E =======================================

sub_3C010:
                andi.w  #drawing_mask,art_tile(a1)
                moveq   #0,d0
                move.b  4(a2),d0
                bmi.s   loc_3C024
                ori.w   #high_priority,art_tile(a1)

loc_3C024:
                lsr.b   #4,d0
                move.b  RawAni_3C048(pc,d0.w),d1
                move.b  d1,mapping_frame(a1)
                move.b  byte_3C058(pc,d0.w),d1
                ext.w   d1
                btst    #0,render_flags(a1)
                beq.s   loc_3C03E
                neg.w   d1

loc_3C03E:
                add.w   x_pos(a0),d1
                move.w  d1,x_pos(a1)
                rts
; End of function sub_3C010

; ---------------------------------------------------------------------------
RawAni_3C048:
                dc.b    $5C, $5C, $5D, $5D, $5D, $5E, $5E, $5E, $5F, $5F, $60, $60, $60, $61, $61, $61
byte_3C058:
                dc.b    $18, $18,   4,   4,   4, -$A, -$A, -$A,-$18,-$18,-$18,-$18,-$18,  $A,  $A,  $A
                even
; ---------------------------------------------------------------------------

loc_3C068:
                move.w  #$1000,x_vel(a1)
                btst    #button_left+8,d1
                beq.s   loc_3C078
                neg.w   x_vel(a1)

loc_3C078:
                move.w  #-$100,y_vel(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)

loc_3C096:
                clr.b   (a2)
                move.b  #$1E,2(a2)
                andi.b  #$FC,object_control(a1)
                andi.w  #drawing_mask,art_tile(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,spin_dash_flag(a1)
                move.b  #0,double_jump_flag(a1)
                rts
; ---------------------------------------------------------------------------

loc_3C0D0:
                tst.b   2(a2)
                beq.s   loc_3C0DC
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_3C0DC:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$C,d0
                cmpi.w  #$18,d0
                bhs.w   locret_3C19A
                move.w  $36(a0),d1
                move.w  y_pos(a0),d0
                sub.w   y_pos(a1),d0
                addi.w  #$10,d0
                cmp.w   $36(a0),d0
                bhs.w   locret_3C19A
                tst.w   (Debug_placement_mode).w
                bne.w   locret_3C19A
                cmpi.b  #4,routine(a1)
                bhs.w   locret_3C19A
                tst.b   object_control(a1)
                bne.w   locret_3C19A
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  y_radius(a1),d0
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                bclr    #Status_Roll,status(a1)
                beq.s   loc_3C156
                sub.b   default_y_radius(a1),d0
                ext.w   d0
                add.w   d0,y_pos(a1)

loc_3C156:
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   loc_3C16A
                move.w  d0,y_pos(a1)

loc_3C16A:
                bset    #Status_InAir,status(a1)
                bclr    #Status_Facing,status(a1)
                move.b  #0,anim(a1)
                move.b  #3,object_control(a1)
                andi.b  #$FD,render_flags(a1)
                move.b  #-$20,4(a2)
                move.b  #1,(a2)
                bsr.w   sub_3C010
                bra.w   loc_3BFFE
; ---------------------------------------------------------------------------

locret_3C19A:
                rts
; ---------------------------------------------------------------------------
Map_FBZSpinningPole:                                    ; unused
                include "src/objects/shared/zones/fbz/map_spinning_pole_unused.s"
