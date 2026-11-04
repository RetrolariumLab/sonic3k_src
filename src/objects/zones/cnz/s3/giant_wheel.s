; Owner: objects/zones/cnz/s3
; Responsibility: Carnival Night giant wheel contact, rotation and player transport
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZGiantWheel:
                move.b  #$60,$32(a0)
                move.l  #S3CNZGiantWheel_UpdatePlayersAndCull,(a0)

S3CNZGiantWheel_UpdatePlayersAndCull:
                lea     $36(a0),a2
                lea     (Player_1).w,a1
                bsr.s   ConstrainPlayerSpeedOnCnzGiantWheel
                addq.w  #1,a2
                lea     (Player_2).w,a1
                bsr.s   ConstrainPlayerSpeedOnCnzGiantWheel
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

ConstrainPlayerSpeedOnCnzGiantWheel:
                moveq   #0,d2
                move.b  $32(a0),d2
                move.w  d2,d3
                add.w   d3,d3
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.s   S3CNZGiantWheel_TryClearConvexStick
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d2,d1
                cmp.w   d3,d1
                bhs.s   S3CNZGiantWheel_TryClearConvexStick
                btst    #Status_InAir,status(a1)
                beq.s   S3CNZGiantWheel_LatchGroundedEntry
                clr.b   (a2)
                rts
; ---------------------------------------------------------------------------

S3CNZGiantWheel_TryClearConvexStick:
                tst.b   (a2)
                beq.s   S3CNZGiantWheel_OutsideReturn
                clr.b   stick_to_convex(a1)
                clr.b   (a2)

S3CNZGiantWheel_OutsideReturn:
                rts
; ---------------------------------------------------------------------------

S3CNZGiantWheel_LatchGroundedEntry:
                tst.b   (a2)
                bne.s   S3CNZGiantWheel_ClampSpeedByDirection
                move.b  #1,(a2)
                btst    #Status_Roll,status(a1)
                bne.s   S3CNZGiantWheel_BeginConvexStick
                clr.b   anim(a1)

S3CNZGiantWheel_BeginConvexStick:
                bclr    #Status_Push,status(a1)
                move.b  #1,prev_anim(a1)
                move.b  #1,stick_to_convex(a1)

S3CNZGiantWheel_ClampSpeedByDirection:
                move.w  ground_vel(a1),d0
                btst    #0,status(a0)
                beq.s   S3CNZGiantWheel_SetPositiveSpeedFloor
                cmpi.w  #-$400,d0
                ble.s   S3CNZGiantWheel_CapNegativeSpeed
                move.w  #-$400,ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

S3CNZGiantWheel_CapNegativeSpeed:
                cmpi.w  #-$F00,d0
                bge.s   S3CNZGiantWheel_NegativeClampReturn
                move.w  #-$F00,ground_vel(a1)

S3CNZGiantWheel_NegativeClampReturn:
                rts
; ---------------------------------------------------------------------------

S3CNZGiantWheel_SetPositiveSpeedFloor:
                cmpi.w  #$400,d0
                bge.s   S3CNZGiantWheel_CapPositiveSpeed
                move.w  #$400,ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

S3CNZGiantWheel_CapPositiveSpeed:
                cmpi.w  #$F00,d0
                ble.s   S3CNZGiantWheel_PositiveClampReturn
                move.w  #$F00,ground_vel(a1)

S3CNZGiantWheel_PositiveClampReturn:
                rts
; End of function ConstrainPlayerSpeedOnCnzGiantWheel
