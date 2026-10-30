; Owner: objects/zones/mhz/sk
; Responsibility: Twisted vine player capture, path traversal, character pose and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZTwistedVine:
                move.b  #$D0,width_pixels(a0)
                btst    #0,status(a0)
                beq.s   loc_3DCB4
                move.l  #loc_3DE6A,(a0)
                bra.w   loc_3DE6A
; ---------------------------------------------------------------------------

loc_3DCB4:
                move.l  #loc_3DCBA,(a0)

loc_3DCBA:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   sub_3DCD0
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   sub_3DCD0
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_3DCD0:
                btst    d6,status(a0)
                bne.w   loc_3DD9E
                btst    #Status_InAir,status(a1)
                bne.w   locret_3DD9C
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                tst.w   x_vel(a1)
                beq.w   locret_3DD9C
                bmi.s   loc_3DD48
                cmpi.w  #-$30,d0
                bgt.w   locret_3DD9C
                cmpi.w  #-$40,d0
                blt.w   locret_3DD9C
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$30,d1
                cmpi.w  #$20,d1
                bhs.w   locret_3DD9C
                tst.b   object_control(a1)
                bne.s   locret_3DD9C
                bclr    #0,status(a1)
                jsr     (RideObject_SetRide).l
                move.b  #$80,flip_type(a1)
                move.w  #20,move_lock(a1)
                move.w  ground_vel(a1),d0
                cmpi.w  #$600,d0
                bhs.s   locret_3DD9C
                move.w  #$600,ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_3DD48:
                cmpi.w  #$30,d0
                blt.s   locret_3DD9C
                cmpi.w  #$40,d0
                bgt.s   locret_3DD9C
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$10,d1
                cmpi.w  #$20,d1
                bhs.s   locret_3DD9C
                tst.b   object_control(a1)
                bne.s   locret_3DD9C
                bset    #Status_Facing,status(a1)
                jsr     (RideObject_SetRide).l
                move.b  #$80,flip_angle(a1)
                move.b  #$80,flip_type(a1)
                move.w  ground_vel(a1),d0
                neg.w   d0
                cmpi.w  #$600,d0
                bhs.s   locret_3DD9C
                move.w  #-$600,ground_vel(a1)
                move.w  #20,move_lock(a1)

locret_3DD9C:
                rts
; ---------------------------------------------------------------------------

loc_3DD9E:
                move.w  ground_vel(a1),d0
                bpl.s   loc_3DDA6
                neg.w   d0

loc_3DDA6:
                cmpi.w  #$500,d0
                blo.s   loc_3DE12
                btst    #Status_InAir,status(a1)
                bne.s   loc_3DE18
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                bmi.s   loc_3DDF4
                cmpi.w  #$80,d0
                blo.s   loc_3DE36
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #$80,angle(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,flip_type(a1)
                neg.w   ground_vel(a1)
                neg.w   x_vel(a1)
                bset    #0,status(a1)
                rts
; ---------------------------------------------------------------------------

loc_3DDF4:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,angle(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,flip_type(a1)
                rts
; ---------------------------------------------------------------------------

loc_3DE12:
                move.b  #0,flip_angle(a1)

loc_3DE18:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                move.b  #0,flip_type(a1)
                rts
; ---------------------------------------------------------------------------

loc_3DE36:
                btst    #Status_OnObj,status(a1)
                beq.w   locret_3DD9C
                move.w  d0,d2
                addi.b  #$80,d0
                jsr     (GetSineCosine).l
                move.w  d1,d3
                asr.w   #4,d1
                add.w   y_pos(a0),d1
                moveq   #0,d0
                move.b  y_radius(a1),d0
                muls.w  d3,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,y_pos(a1)
                move.b  d2,flip_angle(a1)
                rts
; End of function sub_3DCD0

; ---------------------------------------------------------------------------

loc_3DE6A:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   sub_3DE80
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   sub_3DE80
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_3DE80:
                btst    d6,status(a0)
                bne.w   loc_3DF48
                btst    #Status_InAir,status(a1)
                bne.w   locret_3DEF2
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                tst.w   x_vel(a1)
                beq.w   locret_3DEF2
                bpl.s   loc_3DEF4
                cmpi.w  #$30,d0
                blt.s   locret_3DEF2
                cmpi.w  #$40,d0
                bgt.s   locret_3DEF2
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$30,d1
                cmpi.w  #$20,d1
                bhs.s   locret_3DEF2
                tst.b   object_control(a1)
                bne.s   locret_3DEF2
                bset    #Status_Facing,status(a1)
                jsr     (RideObject_SetRide).l
                move.b  #$84,flip_type(a1)
                move.w  #20,move_lock(a1)
                move.w  ground_vel(a1),d0
                neg.w   d0
                cmpi.w  #$600,d0
                bhs.s   locret_3DEF2
                move.w  #-$600,ground_vel(a1)

locret_3DEF2:
                rts
; ---------------------------------------------------------------------------

loc_3DEF4:
                cmpi.w  #-$30,d0
                bgt.s   locret_3DEF2
                cmpi.w  #-$40,d0
                blt.s   locret_3DEF2
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$10,d1
                cmpi.w  #$20,d1
                bhs.s   locret_3DEF2
                tst.b   object_control(a1)
                bne.s   locret_3DEF2
                bclr    #Status_Facing,status(a1)
                jsr     (RideObject_SetRide).l
                move.b  #$80,flip_angle(a1)
                move.b  #$84,flip_type(a1)
                move.w  ground_vel(a1),d0
                cmpi.w  #$600,d0
                bhs.s   locret_3DEF2
                move.w  #$600,ground_vel(a1)
                move.w  #20,move_lock(a1)
                rts
; ---------------------------------------------------------------------------

loc_3DF48:
                move.w  ground_vel(a1),d0
                bpl.s   loc_3DF50
                neg.w   d0

loc_3DF50:
                cmpi.w  #$500,d0
                blo.s   loc_3DFBE
                btst    #Status_InAir,status(a1)
                bne.s   loc_3DFC4
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                bmi.s   loc_3DF92
                cmpi.w  #$80,d0
                blo.w   loc_3DFE2
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,angle(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,flip_type(a1)
                rts
; ---------------------------------------------------------------------------

loc_3DF92:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #$80,angle(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,flip_type(a1)
                neg.w   ground_vel(a1)
                neg.w   x_vel(a1)
                bclr    #Status_Facing,status(a1)
                rts
; ---------------------------------------------------------------------------

loc_3DFBE:
                move.b  #0,flip_angle(a1)

loc_3DFC4:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                move.b  #0,flip_type(a1)
                rts
; ---------------------------------------------------------------------------

loc_3DFE2:
                btst    #Status_OnObj,status(a1)
                beq.w   locret_3DEF2
                move.w  d0,d2
                jsr     (GetSineCosine).l
                move.w  d1,d3
                asr.w   #4,d1
                add.w   y_pos(a0),d1
                moveq   #0,d0
                move.b  y_radius(a1),d0
                muls.w  d3,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,y_pos(a1)
                subi.b  #$80,d2
                neg.b   d2
                move.b  d2,flip_angle(a1)
                rts
; End of function sub_3DE80
