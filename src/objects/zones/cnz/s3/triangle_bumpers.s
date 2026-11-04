; Owner: objects/zones/cnz/s3
; Responsibility: Carnival Night triangle bumper player contact and bounce response
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_CNZTriangleBumpers:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$34(a0)
                add.w   d0,d0
                move.w  d0,$32(a0)
                move.l  #S3CNZTriBump_TryBouncePlayersAndCull,(a0)

S3CNZTriBump_TryBouncePlayersAndCull:
                lea     (Player_1).w,a1
                bsr.s   BouncePlayerFromCnzTriangleRegion
                lea     (Player_2).w,a1
                bsr.s   BouncePlayerFromCnzTriangleRegion
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

BouncePlayerFromCnzTriangleRegion:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   $34(a0),d0
                cmp.w   $32(a0),d0
                bhs.s   S3CNZTriBump_BounceTestReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$14,d1
                cmpi.w  #$28,d1
                bhs.s   S3CNZTriBump_BounceTestReturn
                cmpi.b  #4,routine(a1)
                blo.s   S3CNZTriBump_SetDiagonalBounce

S3CNZTriBump_BounceTestReturn:
                rts
; ---------------------------------------------------------------------------

S3CNZTriBump_SetDiagonalBounce:
                move.w  #-$800,x_vel(a1)
                move.w  #-$800,y_vel(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,status(a0)
                bne.s   S3CNZTriBump_TryFlipVerticalBounce
                bclr    #Status_Facing,status(a1)
                neg.w   x_vel(a1)

S3CNZTriBump_TryFlipVerticalBounce:
                btst    #1,status(a0)
                beq.s   S3CNZTriBump_LockAndSetGroundSpeed
                neg.w   y_vel(a1)

S3CNZTriBump_LockAndSetGroundSpeed:
                move.w  #15,move_lock(a1)
                move.w  x_vel(a1),ground_vel(a1)
                btst    #Status_Roll,status(a1)
                bne.s   S3CNZTriBump_TryStartTumble
                move.b  #0,anim(a1)

S3CNZTriBump_TryStartTumble:
                tst.b   flip_angle(a1)
                bne.s   S3CNZTriBump_FinishAirborneBounce
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #3,flips_remaining(a1)
                move.b  #8,flip_speed(a1)
                btst    #Status_Facing,status(a1)
                beq.s   S3CNZTriBump_FinishAirborneBounce
                neg.b   flip_angle(a1)

S3CNZTriBump_FinishAirborneBounce:
                clr.b   jumping(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                moveq   #signextendB(sfx_SmallBumpers),d0
                jmp     (Play_SFX).l
; End of function BouncePlayerFromCnzTriangleRegion
