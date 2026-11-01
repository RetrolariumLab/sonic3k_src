; Owner: objects/players/sonic/sk
; Responsibility: Sonic or Knuckles terrain collision, landing attachment and bubble shield bounce response
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Subroutine for Sonic to interact with the floor and walls when he's in the air
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SonicKnux_DoLevelCollision:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_11F00
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_11F00:
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
                beq.w   loc_12102
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_11F44
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

loc_11F44:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_11F56
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

loc_11F56:
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   locret_11FD4
                move.b  y_vel(a0),d2
                addq.b  #8,d2
                neg.b   d2
                cmp.b   d2,d1
                bge.s   loc_11F6E
                cmp.b   d2,d0
                blt.s   locret_11FD4

loc_11F6E:
                move.b  d3,angle(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_11F7A
                neg.w   d1

loc_11F7A:
                add.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   loc_11FAE
                move.b  d3,d0
                addi.b  #$10,d0
                andi.b  #$20,d0
                beq.s   loc_11F9C
                asr     y_vel(a0)
                bra.s   loc_11FC2
; ---------------------------------------------------------------------------

loc_11F9C:
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash
                rts
; ---------------------------------------------------------------------------

loc_11FAE:
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall
                cmpi.w  #$FC0,y_vel(a0)
                ble.s   loc_11FC2
                move.w  #$FC0,y_vel(a0)

loc_11FC2:
                bsr.w   Player_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   locret_11FD4
                neg.w   ground_vel(a0)

locret_11FD4:
                rts
; End of function SonicKnux_DoLevelCollision

; =============== S U B R O U T I N E =======================================

CheckSKPlayerGravityRelativeFloorAndNormalizeAngle:
                tst.b   (Reverse_gravity_flag).w
                beq.w   Sonic_CheckFloor
                bsr.w   Sonic_CheckCeiling
                addi.b  #$40,d3
                neg.b   d3
                subi.b  #$40,d3
                rts
; End of function CheckSKPlayerGravityRelativeFloorAndNormalizeAngle

; =============== S U B R O U T I N E =======================================

CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle:
                tst.b   (Reverse_gravity_flag).w
                beq.w   Sonic_CheckCeiling
                bsr.w   Sonic_CheckFloor
                addi.b  #$40,d3
                neg.b   d3
                subi.b  #$40,d3
                rts
; End of function CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle

; =============== S U B R O U T I N E =======================================

ChooseChkFloorEdge:
                tst.b   (Reverse_gravity_flag).w
                beq.w   ChkFloorEdge_Part2
                bra.w   ChkFloorEdge_ReverseGravity
; End of function ChooseChkFloorEdge

; ---------------------------------------------------------------------------

Player_HitLeftWall:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   Player_HitCeiling               ; branch if distance is positive (not inside wall)
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall
                move.w  y_vel(a0),ground_vel(a0)

Player_HitCeiling:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   loc_12068                       ; branch if distance is positive (not inside ceiling)
                neg.w   d1
                cmpi.w  #$14,d1
                bhs.s   loc_12054
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_12042
                neg.w   d1

loc_12042:
                add.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_12052
                move.w  #0,y_vel(a0)                    ; stop Sonic in y since he hit a ceiling

locret_12052:
                rts
; ---------------------------------------------------------------------------

loc_12054:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   locret_12066
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

locret_12066:
                rts
; ---------------------------------------------------------------------------

loc_12068:
                tst.b   (WindTunnel_flag).w
                bne.s   loc_12074
                tst.w   y_vel(a0)
                bmi.s   locret_1209C

loc_12074:
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   locret_1209C
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_12084
                neg.w   d1

loc_12084:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash

locret_1209C:
                rts
; ---------------------------------------------------------------------------

Player_HitCeilingAndWalls:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_120B0
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

loc_120B0:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_120C2
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

loc_120C2:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   locret_12100
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_120D2
                neg.w   d1

loc_120D2:
                sub.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   loc_120EA
                move.w  #0,y_vel(a0)                    ; stop Sonic in y since he hit a ceiling
                rts
; ---------------------------------------------------------------------------

loc_120EA:
                move.b  d3,angle(a0)
                bsr.w   Player_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   locret_12100
                neg.w   ground_vel(a0)

locret_12100:
                rts
; ---------------------------------------------------------------------------

loc_12102:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_1211A
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

loc_1211A:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   loc_1213C
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_1212A
                neg.w   d1

loc_1212A:
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_1213A
                move.w  #0,y_vel(a0)

locret_1213A:
                rts
; ---------------------------------------------------------------------------

loc_1213C:
                tst.b   (WindTunnel_flag).w
                bne.s   loc_12148
                tst.w   y_vel(a0)
                bmi.s   locret_12170

loc_12148:
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   locret_12170
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_12158
                neg.w   d1

loc_12158:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash

locret_12170:
                rts

; =============== S U B R O U T I N E =======================================

Player_TouchFloor_Check_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_121D8
                move.b  #0,anim(a0)
; End of function Player_TouchFloor_Check_Spindash

; =============== S U B R O U T I N E =======================================

Player_TouchFloor:
                cmpi.b  #1,character_id(a0)
                beq.w   Tails_TouchFloor
                cmpi.b  #2,character_id(a0)
                beq.w   Knux_TouchFloor

                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                btst    #Status_Roll,status(a0)
                beq.s   loc_121D8
                bclr    #Status_Roll,status(a0)
                move.b  #0,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_121C4
                neg.w   d0

loc_121C4:
                move.w  d0,-(sp)
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bpl.s   loc_121D2
                neg.w   (sp)

loc_121D2:
                move.w  (sp)+,d0
                add.w   d0,y_pos(a0)

loc_121D8:
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
                beq.s   locret_12230
                tst.b   character_id(a0)
                bne.s   loc_1222A
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   loc_1222A
                btst    #Status_BublShield,status_secondary(a0)
                beq.s   loc_1222A
                bsr.s   BubbleShield_Bounce

loc_1222A:
                move.b  #0,double_jump_flag(a0)

locret_12230:
                rts
; End of function Player_TouchFloor

; =============== S U B R O U T I N E =======================================

BubbleShield_Bounce:
                movem.l d1-d2,-(sp)
                move.w  #$780,d2
                btst    #Status_Underwater,status(a0)
                beq.s   loc_12246
                move.w  #$400,d2

loc_12246:
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
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_122AA
                neg.w   d0

loc_122AA:
                sub.w   d0,y_pos(a0)
                move.b  #2,(Shield+anim).w
                move.w  #sfx_BubbleAttack,d0
                jmp     (Play_SFX).l
; End of function BubbleShield_Bounce
