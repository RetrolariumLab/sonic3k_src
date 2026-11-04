; Owner: objects/competition/sk
; Responsibility: Competition triangle bumper variants, collision and bounce response
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CGZTriangleBumpers:
                move.b  #8,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.b  subtype(a0),d0
                lsr.b   #4,d0
                andi.b  #7,d0
                move.b  d0,mapping_frame(a0)
                beq.s   loc_32C8C
                move.b  #$80,height_pixels(a0)

loc_32C8C:
                move.l  #loc_32C92,(a0)

loc_32C92:
                move.w  #$10,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                jsr     (SolidObjectFull2_1P).l
                cmpi.b  #1,d4
                bne.s   loc_32CDC
                btst    #Status_InAir,status(a1)
                beq.s   loc_32CDC
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_32CD4
                eori.b  #1,d1

loc_32CD4:
                andi.b  #1,d1
                bne.s   loc_32CDC
                bsr.s   SKCompTriangle_LaunchPlayer

loc_32CDC:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                jsr     (SolidObjectFull2_1P).l
                cmpi.b  #1,d4
                bne.s   locret_32D14
                btst    #Status_InAir,status(a1)
                beq.s   locret_32D14
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_32D0C
                eori.b  #1,d1

loc_32D0C:
                andi.b  #1,d1
                bne.s   locret_32D14
                bsr.s   SKCompTriangle_LaunchPlayer

locret_32D14:
                rts

; =============== S U B R O U T I N E =======================================

; Apply a sideways and downward launch with brief input lock. Subtype controls the flips and collision-layer transfer
SKCompTriangle_LaunchPlayer:
                cmpi.b  #4,routine(a1)
                blo.s   loc_32D20
                rts
; ---------------------------------------------------------------------------

loc_32D20:
                move.w  #-$800,x_vel(a1)
                move.w  #$400,y_vel(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,status(a0)
                bne.s   loc_32D44
                bclr    #Status_Facing,status(a1)
                neg.w   x_vel(a1)

loc_32D44:
                move.w  #15,move_lock(a1)
                move.w  x_vel(a1),ground_vel(a1)
                btst    #Status_Roll,status(a1)
                bne.s   loc_32D5E
                move.b  #0,anim(a1)

loc_32D5E:
                move.b  subtype(a0),d0
                bpl.s   loc_32D6A
                move.w  #0,y_vel(a1)

loc_32D6A:
                btst    #0,d0
                beq.s   loc_32DAA
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #1,flips_remaining(a1)
                move.b  #8,flip_speed(a1)
                btst    #1,d0
                bne.s   loc_32D9A
                move.b  #3,flips_remaining(a1)

loc_32D9A:
                btst    #Status_Facing,status(a1)
                beq.s   loc_32DAA
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

loc_32DAA:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   loc_32DC0
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

loc_32DC0:
                cmpi.b  #8,d0
                bne.s   loc_32DD2
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_32DD2:
                bclr    #5,status(a0)
                bclr    #6,status(a0)
                bclr    #Status_Push,status(a1)
                bclr    #Status_RollJump,status(a1)
                moveq   #signextendB(sfx_SmallBumpers),d0
                jmp     (Play_SFX).l
; End of function SKCompTriangle_LaunchPlayer
