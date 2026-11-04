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
                beq.s   SKCGZTriangle_InstallCollisionUpdate
                move.b  #$80,height_pixels(a0)

SKCGZTriangle_InstallCollisionUpdate:
                move.l  #SKCGZTriangle_CollideAndCheckP1Side,(a0)

SKCGZTriangle_CollideAndCheckP1Side:
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
                bne.s   SKCGZTriangle_RestoreSizeAndCollideP2
                btst    #Status_InAir,status(a1)
                beq.s   SKCGZTriangle_RestoreSizeAndCollideP2
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   SKCGZTriangle_FilterP1SideByFacing
                eori.b  #1,d1

SKCGZTriangle_FilterP1SideByFacing:
                andi.b  #1,d1
                bne.s   SKCGZTriangle_RestoreSizeAndCollideP2
                bsr.s   SKCompTriangle_LaunchPlayer

SKCGZTriangle_RestoreSizeAndCollideP2:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                jsr     (SolidObjectFull2_1P).l
                cmpi.b  #1,d4
                bne.s   SKCGZTriangle_CollisionReturn
                btst    #Status_InAir,status(a1)
                beq.s   SKCGZTriangle_CollisionReturn
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   SKCGZTriangle_FilterP2SideByFacing
                eori.b  #1,d1

SKCGZTriangle_FilterP2SideByFacing:
                andi.b  #1,d1
                bne.s   SKCGZTriangle_CollisionReturn
                bsr.s   SKCompTriangle_LaunchPlayer

SKCGZTriangle_CollisionReturn:
                rts

; =============== S U B R O U T I N E =======================================

; Apply a sideways and downward launch with brief input lock. Subtype controls the flips and collision-layer transfer
SKCompTriangle_LaunchPlayer:
                cmpi.b  #4,routine(a1)
                blo.s   SKCGZTriangle_LaunchEligiblePlayer
                rts
; ---------------------------------------------------------------------------

SKCGZTriangle_LaunchEligiblePlayer:
                move.w  #-$800,x_vel(a1)
                move.w  #$400,y_vel(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,status(a0)
                bne.s   SKCGZTriangle_LockXAndPreserveRoll
                bclr    #Status_Facing,status(a1)
                neg.w   x_vel(a1)

SKCGZTriangle_LockXAndPreserveRoll:
                move.w  #15,move_lock(a1)
                move.w  x_vel(a1),ground_vel(a1)
                btst    #Status_Roll,status(a1)
                bne.s   SKCGZTriangle_ApplyHorizontalOnly
                move.b  #0,anim(a1)

SKCGZTriangle_ApplyHorizontalOnly:
                move.b  subtype(a0),d0
                bpl.s   SKCGZTriangle_SetOptionalFlip
                move.w  #0,y_vel(a1)

SKCGZTriangle_SetOptionalFlip:
                btst    #0,d0
                beq.s   SKCGZTriangle_SelectPlaneFromSubtype4
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #1,flips_remaining(a1)
                move.b  #8,flip_speed(a1)
                btst    #1,d0
                bne.s   SKCGZTriangle_OrientFlipAndGroundSpeed
                move.b  #3,flips_remaining(a1)

SKCGZTriangle_OrientFlipAndGroundSpeed:
                btst    #Status_Facing,status(a1)
                beq.s   SKCGZTriangle_SelectPlaneFromSubtype4
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

SKCGZTriangle_SelectPlaneFromSubtype4:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   SKCGZTriangle_SelectPlaneFromSubtype8
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

SKCGZTriangle_SelectPlaneFromSubtype8:
                cmpi.b  #8,d0
                bne.s   SKCGZTriangle_ClearPushBitsAndPlayLaunch
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

SKCGZTriangle_ClearPushBitsAndPlayLaunch:
                bclr    #5,status(a0)
                bclr    #6,status(a0)
                bclr    #Status_Push,status(a1)
                bclr    #Status_RollJump,status(a1)
                moveq   #signextendB(sfx_SmallBumpers),d0
                jmp     (Play_SFX).l
; End of function SKCompTriangle_LaunchPlayer
