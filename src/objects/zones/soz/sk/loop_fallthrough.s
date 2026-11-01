; Owner: objects/zones/soz/sk
; Responsibility: Loop fallthrough player detection and collision-path control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZLoopFallthrough:
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                lsl.w   #4,d0
                move.w  d0,$30(a0)
                move.l  #loc_4045E,(a0)

loc_4045E:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   CarryPlayerThroughSozLoopFallthrough
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   CarryPlayerThroughSozLoopFallthrough
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

CarryPlayerThroughSozLoopFallthrough:
                btst    d6,status(a0)
                bne.w   loc_40508
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   locret_40506
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   locret_40506
                btst    #Status_OnObj,status(a1)
                bne.s   locret_40506
                cmpi.b  #4,routine(a1)
                bhs.s   locret_40506
                tst.b   object_control(a1)
                bne.s   locret_40506
                cmpi.w  #$800,y_vel(a1)
                blt.s   locret_40506
                bset    #Status_OnObj,status(a1)
                bset    d6,status(a0)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                bset    #Status_InAir,status(a1)
                move.b  #$81,object_control(a1)
                move.w  #0,x_vel(a1)

locret_40506:
                rts
; ---------------------------------------------------------------------------

loc_40508:
                move.w  x_vel(a1),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a1)
                move.w  y_vel(a1),d0
                addi.w  #$38,y_vel(a1)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a1)
                move.w  y_pos(a1),d0
                sub.w   $30(a0),d0
                cmp.w   y_pos(a0),d0
                blt.s   locret_40506
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,object_control(a1)
                rts
; End of function CarryPlayerThroughSozLoopFallthrough
