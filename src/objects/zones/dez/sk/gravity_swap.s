; Owner: objects/zones/dez/sk
; Responsibility: Gravity swap trigger detection and player gravity transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZGravitySwap:
                move.w  #$20,$30(a0)
                move.w  x_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   loc_4920E
                move.b  #1,$32(a0)

loc_4920E:
                move.l  #loc_49214,(a0)

loc_49214:
                move.w  x_pos(a0),d1
                lea     $32(a0),a2
                lea     (Player_1).w,a1
                bsr.s   sub_49228
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_49228:
                tst.b   (a2)+
                bne.w   loc_49270
                cmp.w   x_pos(a1),d1
                bhi.s   locret_4926E
                move.b  #1,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $30(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.s   locret_4926E
                cmp.w   d3,d4
                bge.s   locret_4926E
                tst.w   (Debug_placement_mode).w
                bne.s   locret_4926E
                move.b  #0,(Reverse_gravity_flag).w
                btst    #0,render_flags(a0)
                bne.s   locret_4926E
                move.b  #1,(Reverse_gravity_flag).w

locret_4926E:
                rts
; ---------------------------------------------------------------------------

loc_49270:
                cmp.w   x_pos(a1),d1
                bls.s   locret_4926E
                move.b  #0,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $30(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.s   locret_4926E
                cmp.w   d3,d4
                bge.s   locret_4926E
                tst.w   (Debug_placement_mode).w
                bne.s   locret_4926E
                move.b  #0,(Reverse_gravity_flag).w
                btst    #0,render_flags(a0)
                beq.s   locret_4926E
                move.b  #1,(Reverse_gravity_flag).w
                rts
; End of function sub_49228
