; Owner: objects/zones/lbz/s3
; Responsibility: Unused Launch Base forced-fall player control trigger
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZUnusedForceFall:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$80,height_pixels(a0)
                move.b  #0,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$2E(a0)
                move.l  #loc_284B4,(a0)

loc_284B4:
                move.w  x_pos(a0),d1
                move.w  d1,d2
                subi.w  #$10,d1
                addi.w  #$10,d2
                move.w  y_pos(a0),d3
                move.w  d3,d4
                sub.w   $2E(a0),d3
                add.w   $2E(a0),d4
                lea     (Player_1).w,a1
                bsr.s   sub_284E2
                lea     (Player_2).w,a1
                bsr.s   sub_284E2
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_284E2:
                move.w  x_pos(a1),d0
                cmp.w   d1,d0
                blo.s   locret_28532
                cmp.w   d2,d0
                bhs.s   locret_28532
                move.w  y_pos(a1),d0
                cmp.w   d3,d0
                blo.s   locret_28532
                cmp.w   d4,d0
                bhs.s   locret_28532
                cmpi.b  #$1A,anim(a1)
                beq.s   locret_28532
                move.w  #0,x_vel(a1)
                move.w  #$400,y_vel(a1)
                move.w  #0,ground_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Roll,status(a1)
                move.b  #$1A,anim(a1)

locret_28532:
                rts
; End of function sub_284E2
