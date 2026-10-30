; Owner: objects/players/sonic/s3
; Responsibility: Sonic or Knuckles terrain collision, landing attachment and bubble shield bounce response
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Subroutine for Sonic to interact with the floor and walls when he's in the air
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_DoLevelCollision:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_12E26
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_12E26:
                move.b  lrb_solid_bit(a0),d5
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                subi.b  #$20,d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   Player_HitLeftWall
                cmpi.b  #$80,d0
                beq.w   Player_HitCeilingAndWalls
                cmpi.b  #$C0,d0
                beq.w   loc_12FCC
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_12E6A
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

loc_12E6A:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_12E7C
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

loc_12E7C:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   locret_12EF2
                move.b  y_vel(a0),d2
                addq.b  #8,d2
                neg.b   d2
                cmp.b   d2,d1
                bge.s   loc_12E94
                cmp.b   d2,d0
                blt.s   locret_12EF2

loc_12E94:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   loc_12ECC
                move.b  d3,d0
                addi.b  #$10,d0
                andi.b  #$20,d0
                beq.s   loc_12EBA
                asr     y_vel(a0)
                bra.s   loc_12EE0
; ---------------------------------------------------------------------------

loc_12EBA:
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash
                rts
; ---------------------------------------------------------------------------

loc_12ECC:
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall
                cmpi.w  #$FC0,y_vel(a0)
                ble.s   loc_12EE0
                move.w  #$FC0,y_vel(a0)

loc_12EE0:
                bsr.w   Player_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   locret_12EF2
                neg.w   ground_vel(a0)

locret_12EF2:
                rts
; ---------------------------------------------------------------------------

Player_HitLeftWall:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   Player_HitCeiling               ; branch if distance is positive (not inside wall)
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall
                move.w  y_vel(a0),ground_vel(a0)

Player_HitCeiling:
                bsr.w   Sonic_CheckCeiling
                tst.w   d1
                bpl.s   loc_12F42                       ; branch if distance is positive (not inside ceiling)
                neg.w   d1
                cmpi.w  #$14,d1
                bhs.s   loc_12F2E
                add.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_12F2C
                move.w  #0,y_vel(a0)                    ; stop Sonic in y since he hit a ceiling

locret_12F2C:
                rts
; ---------------------------------------------------------------------------

loc_12F2E:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   locret_12F40
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

locret_12F40:
                rts
; ---------------------------------------------------------------------------

loc_12F42:
                tst.b   (WindTunnel_flag).w
                bne.s   loc_12F4E
                tst.w   y_vel(a0)
                bmi.s   locret_12F6E

loc_12F4E:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   locret_12F6E
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash

locret_12F6E:
                rts
; ---------------------------------------------------------------------------

Player_HitCeilingAndWalls:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_12F82
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

loc_12F82:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_12F94
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

loc_12F94:
                bsr.w   Sonic_CheckCeiling
                tst.w   d1
                bpl.s   locret_12FCA
                sub.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   loc_12FB4
                move.w  #0,y_vel(a0)                    ; stop Sonic in y since he hit a ceiling
                rts
; ---------------------------------------------------------------------------

loc_12FB4:
                move.b  d3,angle(a0)
                bsr.w   Player_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   locret_12FCA
                neg.w   ground_vel(a0)

locret_12FCA:
                rts
; ---------------------------------------------------------------------------

loc_12FCC:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_12FE4
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

loc_12FE4:
                bsr.w   Sonic_CheckCeiling
                tst.w   d1
                bpl.s   loc_12FFE
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_12FFC
                move.w  #0,y_vel(a0)

locret_12FFC:
                rts
; ---------------------------------------------------------------------------

loc_12FFE:
                tst.b   (WindTunnel_flag).w
                bne.s   loc_1300A
                tst.w   y_vel(a0)
                bmi.s   locret_1302A

loc_1300A:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   locret_1302A
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash

locret_1302A:
                rts
; End of function Sonic_DoLevelCollision

; =============== S U B R O U T I N E =======================================

Player_TouchFloor_Check_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_13070
                move.b  #0,anim(a0)
; End of function Player_TouchFloor_Check_Spindash

; =============== S U B R O U T I N E =======================================

Player_TouchFloor:
                cmpi.l  #Obj_Tails,(a0)
                beq.w   Tails_TouchFloor

                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                btst    #Status_Roll,status(a0)
                beq.s   loc_13070
                bclr    #Status_Roll,status(a0)
                move.b  #0,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                add.w   d0,y_pos(a0)

loc_13070:
                bclr    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                bclr    #Status_RollJump,status(a0)
                move.b  #0,jumping(a0)
                move.w  #0,(Chain_bonus_counter).w
                move.b  #0,flip_angle(a0)
                move.b  #0,flip_type(a0)
                move.b  #0,flips_remaining(a0)
                move.b  #0,scroll_delay_counter(a0)
                tst.b   double_jump_flag(a0)
                beq.s   locret_130BC
                btst    #Status_BublShield,status_secondary(a0)
                beq.s   loc_130B6
                bsr.s   BubbleShield_Bounce

loc_130B6:
                move.b  #0,double_jump_flag(a0)

locret_130BC:
                rts
; End of function Player_TouchFloor

; =============== S U B R O U T I N E =======================================

BubbleShield_Bounce:
                movem.l d1-d2,-(sp)
                move.w  #$780,d2
                btst    #Status_Underwater,status(a0)
                beq.s   loc_130D2
                move.w  #$400,d2

loc_130D2:
                moveq   #0,d0
                move.b  angle(a0),d0
                subi.b  #$40,d0
                jsr     (GetSineCosine).l
                muls.w  d2,d1
                asr.l   #8,d1
                add.w   d1,x_vel(a0)
                muls.w  d2,d0
                asr.l   #8,d0
                add.w   d0,y_vel(a0)
                movem.l (sp)+,d1-d2
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                move.b  #1,jumping(a0)
                clr.b   stick_to_convex(a0)
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                bset    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                sub.w   d0,y_pos(a0)
                move.b  #2,(Shield+anim).w
                move.w  #sfx_BubbleAttack,d0
                jmp     (Play_SFX).l
; End of function BubbleShield_Bounce
