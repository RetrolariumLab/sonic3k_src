; Owner: objects/shared/s3
; Responsibility: Twisted ramp placement and player path control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_TwistedRamp:
                lea     (Player_1).w,a1
                bsr.s   sub_23CA2
                lea     (Player_2).w,a1
                bsr.s   sub_23CA2
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_23C90
                rts
; ---------------------------------------------------------------------------

loc_23C90:
                move.w  respawn_addr(a0),d0
                beq.s   loc_23C9C
                movea.w d0,a2
                bclr    #7,(a2)

loc_23C9C:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_23CA2:
                btst    #Status_InAir,status(a1)
                bne.w   locret_23D28
                move.w  x_pos(a1),d0
                addi.w  #$10,d0
                sub.w   x_pos(a0),d0
                bcs.s   locret_23D28
                cmpi.w  #$20,d0
                bge.s   locret_23D28
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                cmpi.w  #-$14,d0
                blt.s   locret_23D28
                cmpi.w  #$20,d0
                bgt.s   locret_23D28
                cmpi.w  #$400,x_vel(a1)
                blt.s   locret_23D28
                tst.b   object_control(a1)
                bne.s   locret_23D28
                move.w  #-$700,y_vel(a1)
                addi.w  #$400,x_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #2,routine(a1)
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                btst    #Status_Facing,status(a1)
                beq.s   locret_23D28
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

locret_23D28:
                rts
; End of function sub_23CA2
