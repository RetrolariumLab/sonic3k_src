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
                beq.s   SKSonicLand_DispatchVelocitySector
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

SKSonicLand_DispatchVelocitySector:
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
                beq.w   SKSonicLand_CheckRightSectorWall
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKSonicLand_CheckDefaultRightWall
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

SKSonicLand_CheckDefaultRightWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKSonicLand_TestDefaultFloorDepth
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

; Add eight to the high Y speed byte and negate it before the signed penetration and sensor comparisons
SKSonicLand_TestDefaultFloorDepth:
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   SKSonicLand_DefaultFloorReturn
                move.b  y_vel(a0),d2
                addq.b  #8,d2
                neg.b   d2
                cmp.b   d2,d1
                bge.s   SKSonicLand_StoreDefaultFloorAngle
                cmp.b   d2,d0
                blt.s   SKSonicLand_DefaultFloorReturn

SKSonicLand_StoreDefaultFloorAngle:
                move.b  d3,angle(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicLand_CorrectDefaultFloorAndSlope
                neg.w   d1

SKSonicLand_CorrectDefaultFloorAndSlope:
                add.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   SKSonicLand_ClampSteepLandingSpeed
                move.b  d3,d0
                addi.b  #$10,d0
                andi.b  #$20,d0
                beq.s   SKSonicLand_LandOnFlatFloor
                asr     y_vel(a0)
                bra.s   SKSonicLand_FinishSlopeLanding
; ---------------------------------------------------------------------------

SKSonicLand_LandOnFlatFloor:
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash
                rts
; ---------------------------------------------------------------------------

SKSonicLand_ClampSteepLandingSpeed:
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall
                cmpi.w  #$FC0,y_vel(a0)
                ble.s   SKSonicLand_FinishSlopeLanding
                move.w  #$FC0,y_vel(a0)

; Read Y velocity after landing cleanup, which can trigger a bubble rebound
SKSonicLand_FinishSlopeLanding:
                bsr.w   Player_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   SKSonicLand_DefaultFloorReturn
                neg.w   ground_vel(a0)

SKSonicLand_DefaultFloorReturn:
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
                bpl.s   SKSonicLand_CheckLeftFloorEligibility  ; branch if distance is positive (not inside ceiling)
                neg.w   d1
                cmpi.w  #$14,d1
                bhs.s   SKSonicLand_CheckRightWallAtDeepCeiling
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicLand_CorrectLeftCeilingY
                neg.w   d1

SKSonicLand_CorrectLeftCeilingY:
                add.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   SKSonicLand_LeftCeilingReturn
                move.w  #0,y_vel(a0)                    ; stop Sonic in y since he hit a ceiling

SKSonicLand_LeftCeilingReturn:
                rts
; ---------------------------------------------------------------------------

; Ceiling penetration of at least $14 pixels routes the left sector to the opposite wall probe
SKSonicLand_CheckRightWallAtDeepCeiling:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKSonicLand_DeepCeilingWallReturn
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKSonicLand_DeepCeilingWallReturn:
                rts
; ---------------------------------------------------------------------------

SKSonicLand_CheckLeftFloorEligibility:
                tst.b   (WindTunnel_flag).w
                bne.s   SKSonicLand_ProbeLeftFloor
                tst.w   y_vel(a0)
                bmi.s   SKSonicLand_LeftFloorReturn

SKSonicLand_ProbeLeftFloor:
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   SKSonicLand_LeftFloorReturn
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicLand_LandOnLeftSectorFloor
                neg.w   d1

SKSonicLand_LandOnLeftSectorFloor:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash

SKSonicLand_LeftFloorReturn:
                rts
; ---------------------------------------------------------------------------

Player_HitCeilingAndWalls:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKSonicLand_CheckCeilingSectorRightWall
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

SKSonicLand_CheckCeilingSectorRightWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKSonicLand_ProbeCeilingAndResolve
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

SKSonicLand_ProbeCeilingAndResolve:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   SKSonicLand_CeilingSectorReturn
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicLand_CorrectCeilingAndCheckSlope
                neg.w   d1

SKSonicLand_CorrectCeilingAndCheckSlope:
                sub.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   SKSonicLand_AttachToSteepCeiling
                move.w  #0,y_vel(a0)                    ; stop Sonic in y since he hit a ceiling
                rts
; ---------------------------------------------------------------------------

SKSonicLand_AttachToSteepCeiling:
                move.b  d3,angle(a0)
                bsr.w   Player_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   SKSonicLand_CeilingSectorReturn
                neg.w   ground_vel(a0)

SKSonicLand_CeilingSectorReturn:
                rts
; ---------------------------------------------------------------------------

SKSonicLand_CheckRightSectorWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKSonicLand_ResolveRightSectorCeiling
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

SKSonicLand_ResolveRightSectorCeiling:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   SKSonicLand_CheckRightFloorEligibility
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicLand_CorrectRightCeilingY
                neg.w   d1

SKSonicLand_CorrectRightCeilingY:
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   SKSonicLand_RightCeilingReturn
                move.w  #0,y_vel(a0)

SKSonicLand_RightCeilingReturn:
                rts
; ---------------------------------------------------------------------------

SKSonicLand_CheckRightFloorEligibility:
                tst.b   (WindTunnel_flag).w
                bne.s   SKSonicLand_ProbeRightFloor
                tst.w   y_vel(a0)
                bmi.s   SKSonicLand_RightFloorReturn

SKSonicLand_ProbeRightFloor:
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   SKSonicLand_RightFloorReturn
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicLand_LandOnRightSectorFloor
                neg.w   d1

SKSonicLand_LandOnRightSectorFloor:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash

SKSonicLand_RightFloorReturn:
                rts

; =============== S U B R O U T I N E =======================================

Player_TouchFloor_Check_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   SKSonicLand_ResetLandingAndCheckBubble
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
                beq.s   SKSonicLand_ResetLandingAndCheckBubble
                bclr    #Status_Roll,status(a0)
                move.b  #0,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicLand_AdjustUnrollOffsetForSurface
                neg.w   d0

SKSonicLand_AdjustUnrollOffsetForSurface:
                move.w  d0,-(sp)
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bpl.s   SKSonicLand_ApplyUnrollYOffset
                neg.w   (sp)

SKSonicLand_ApplyUnrollYOffset:
                move.w  (sp)+,d0
                add.w   d0,y_pos(a0)

SKSonicLand_ResetLandingAndCheckBubble:
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
                beq.s   SKSonicLand_LandingResetReturn
                tst.b   character_id(a0)
                bne.s   SKSonicLand_ClearDoubleJumpFlag
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   SKSonicLand_ClearDoubleJumpFlag
                btst    #Status_BublShield,status_secondary(a0)
                beq.s   SKSonicLand_ClearDoubleJumpFlag
                bsr.s   BubbleShield_Bounce

SKSonicLand_ClearDoubleJumpFlag:
                move.b  #0,double_jump_flag(a0)

SKSonicLand_LandingResetReturn:
                rts
; End of function Player_TouchFloor

; =============== S U B R O U T I N E =======================================

BubbleShield_Bounce:
                movem.l d1-d2,-(sp)
                move.w  #$780,d2
                btst    #Status_Underwater,status(a0)
                beq.s   SKSonicLand_ApplyBubbleNormalImpulse
                move.w  #$400,d2

SKSonicLand_ApplyBubbleNormalImpulse:
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
                beq.s   SKSonicLand_ApplyBubbleRadiusOffset
                neg.w   d0

SKSonicLand_ApplyBubbleRadiusOffset:
                sub.w   d0,y_pos(a0)
                move.b  #2,(Shield+anim).w
                move.w  #sfx_BubbleAttack,d0
                jmp     (Play_SFX).l
; End of function BubbleShield_Bounce
