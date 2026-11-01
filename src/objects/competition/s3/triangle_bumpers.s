; Owner: objects/competition/s3
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
                beq.s   loc_31F1C
                move.b  #$80,height_pixels(a0)

loc_31F1C:
                move.l  #loc_31F22,(a0)

loc_31F22:
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
                bne.s   loc_31F6C
                btst    #Status_InAir,status(a1)
                beq.s   loc_31F6C
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_31F64
                eori.b  #1,d1

loc_31F64:
                andi.b  #1,d1
                bne.s   loc_31F6C
                bsr.s   CompetitionS3LaunchFromTriangleWithSubtypeFlipAndPlane

loc_31F6C:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                jsr     (SolidObjectFull2_1P).l
                cmpi.b  #1,d4
                bne.s   locret_31FA4
                btst    #Status_InAir,status(a1)
                beq.s   locret_31FA4
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_31F9C
                eori.b  #1,d1

loc_31F9C:
                andi.b  #1,d1
                bne.s   locret_31FA4
                bsr.s   CompetitionS3LaunchFromTriangleWithSubtypeFlipAndPlane

locret_31FA4:
                rts

; =============== S U B R O U T I N E =======================================

CompetitionS3LaunchFromTriangleWithSubtypeFlipAndPlane:
                cmpi.b  #4,routine(a1)
                blo.s   loc_31FB0
                rts
; ---------------------------------------------------------------------------

loc_31FB0:
                move.w  #-$800,x_vel(a1)
                move.w  #$400,y_vel(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,status(a0)
                bne.s   loc_31FD4
                bclr    #Status_Facing,status(a1)
                neg.w   x_vel(a1)

loc_31FD4:
                move.w  #15,move_lock(a1)
                move.w  x_vel(a1),ground_vel(a1)
                btst    #Status_Roll,status(a1)
                bne.s   loc_31FEE
                move.b  #0,anim(a1)

loc_31FEE:
                move.b  subtype(a0),d0
                bpl.s   loc_31FFA
                move.w  #0,y_vel(a1)

loc_31FFA:
                btst    #0,d0
                beq.s   loc_3203A
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #1,flips_remaining(a1)
                move.b  #8,flip_speed(a1)
                btst    #1,d0
                bne.s   loc_3202A
                move.b  #3,flips_remaining(a1)

loc_3202A:
                btst    #Status_Facing,status(a1)
                beq.s   loc_3203A
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

loc_3203A:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   loc_32050
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

loc_32050:
                cmpi.b  #8,d0
                bne.s   loc_32062
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_32062:
                bclr    #5,status(a0)
                bclr    #6,status(a0)
                bclr    #Status_Push,status(a1)
                bclr    #Status_RollJump,status(a1)
                moveq   #signextendB(sfx_SmallBumpers),d0
                jmp     (Play_SFX).l
; End of function CompetitionS3LaunchFromTriangleWithSubtypeFlipAndPlane
