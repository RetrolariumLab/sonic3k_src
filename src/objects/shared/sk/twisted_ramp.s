; Owner: objects/shared/sk
; Responsibility: Twisted ramp placement and player path control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_TwistedRamp:
                lea     (Player_1).w,a1
                bsr.s   LaunchPlayerFromTwistedRamp
                lea     (Player_2).w,a1
                bsr.s   LaunchPlayerFromTwistedRamp
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_24D88
                rts
; ---------------------------------------------------------------------------

loc_24D88:
                move.w  respawn_addr(a0),d0
                beq.s   loc_24D94
                movea.w d0,a2
                bclr    #7,(a2)

loc_24D94:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromTwistedRamp:
                btst    #Status_InAir,status(a1)
                bne.w   locret_24E32
                move.w  x_pos(a1),d0
                addi.w  #$10,d0
                sub.w   x_pos(a0),d0
                bcs.w   locret_24E32
                cmpi.w  #$20,d0
                bge.w   locret_24E32
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                cmpi.w  #-$14,d0
                blt.s   locret_24E32
                cmpi.w  #$20,d0
                bgt.s   locret_24E32
                tst.b   object_control(a1)
                bne.s   locret_24E32
                btst    #0,status(a0)
                bne.s   loc_24DEE
                cmpi.w  #$400,x_vel(a1)
                blt.s   locret_24E32
                addi.w  #$400,x_vel(a1)
                bra.s   loc_24DFC
; ---------------------------------------------------------------------------

loc_24DEE:
                cmpi.w  #-$400,x_vel(a1)
                bgt.s   locret_24E32
                subi.w  #$400,x_vel(a1)

loc_24DFC:
                move.w  #-$700,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #2,routine(a1)
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                move.b  #5,flip_type(a1)

locret_24E32:
                rts
; End of function LaunchPlayerFromTwistedRamp
