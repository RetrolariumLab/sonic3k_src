; Owner: objects/zones/cnz/s3
; Responsibility: Carnival Night giant wheel contact, rotation and player transport
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZGiantWheel:
                move.b  #$60,$32(a0)
                move.l  #loc_31B60,(a0)

loc_31B60:
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
                bhs.s   loc_31BAA
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d2,d1
                cmp.w   d3,d1
                bhs.s   loc_31BAA
                btst    #Status_InAir,status(a1)
                beq.s   loc_31BB6
                clr.b   (a2)
                rts
; ---------------------------------------------------------------------------

loc_31BAA:
                tst.b   (a2)
                beq.s   locret_31BB4
                clr.b   stick_to_convex(a1)
                clr.b   (a2)

locret_31BB4:
                rts
; ---------------------------------------------------------------------------

loc_31BB6:
                tst.b   (a2)
                bne.s   loc_31BDC
                move.b  #1,(a2)
                btst    #Status_Roll,status(a1)
                bne.s   loc_31BCA
                clr.b   anim(a1)

loc_31BCA:
                bclr    #Status_Push,status(a1)
                move.b  #1,prev_anim(a1)
                move.b  #1,stick_to_convex(a1)

loc_31BDC:
                move.w  ground_vel(a1),d0
                btst    #0,status(a0)
                beq.s   loc_31C04
                cmpi.w  #-$400,d0
                ble.s   loc_31BF6
                move.w  #-$400,ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_31BF6:
                cmpi.w  #-$F00,d0
                bge.s   locret_31C02
                move.w  #-$F00,ground_vel(a1)

locret_31C02:
                rts
; ---------------------------------------------------------------------------

loc_31C04:
                cmpi.w  #$400,d0
                bge.s   loc_31C12
                move.w  #$400,ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_31C12:
                cmpi.w  #$F00,d0
                ble.s   locret_31C1E
                move.w  #$F00,ground_vel(a1)

locret_31C1E:
                rts
; End of function ConstrainPlayerSpeedOnCnzGiantWheel
