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
                beq.s   S3SonicLand_DispatchVelocitySector
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

S3SonicLand_DispatchVelocitySector:
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
                beq.w   S3SonicLand_CheckRightSectorWall
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   S3SonicLand_CheckDefaultRightWall
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

S3SonicLand_CheckDefaultRightWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   S3SonicLand_TestDefaultFloorDepth
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

; Add eight to the high Y speed byte and negate it before the signed penetration and sensor comparisons
S3SonicLand_TestDefaultFloorDepth:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   S3SonicLand_DefaultFloorReturn
                move.b  y_vel(a0),d2
                addq.b  #8,d2
                neg.b   d2
                cmp.b   d2,d1
                bge.s   S3SonicLand_StoreDefaultFloorAngle
                cmp.b   d2,d0
                blt.s   S3SonicLand_DefaultFloorReturn

S3SonicLand_StoreDefaultFloorAngle:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   S3SonicLand_ClampSteepLandingSpeed
                move.b  d3,d0
                addi.b  #$10,d0
                andi.b  #$20,d0
                beq.s   S3SonicLand_LandOnFlatFloor
                asr     y_vel(a0)
                bra.s   S3SonicLand_FinishSlopeLanding
; ---------------------------------------------------------------------------

S3SonicLand_LandOnFlatFloor:
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash
                rts
; ---------------------------------------------------------------------------

S3SonicLand_ClampSteepLandingSpeed:
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall
                cmpi.w  #$FC0,y_vel(a0)
                ble.s   S3SonicLand_FinishSlopeLanding
                move.w  #$FC0,y_vel(a0)

; Read Y velocity after landing cleanup, which can trigger a bubble rebound
S3SonicLand_FinishSlopeLanding:
                bsr.w   Player_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   S3SonicLand_DefaultFloorReturn
                neg.w   ground_vel(a0)

S3SonicLand_DefaultFloorReturn:
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
                bpl.s   S3SonicLand_CheckLeftFloorEligibility  ; branch if distance is positive (not inside ceiling)
                neg.w   d1
                cmpi.w  #$14,d1
                bhs.s   S3SonicLand_CheckRightWallAtDeepCeiling
                add.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   S3SonicLand_LeftCeilingReturn
                move.w  #0,y_vel(a0)                    ; stop Sonic in y since he hit a ceiling

S3SonicLand_LeftCeilingReturn:
                rts
; ---------------------------------------------------------------------------

; Ceiling penetration of at least $14 pixels routes the left sector to the opposite wall probe
S3SonicLand_CheckRightWallAtDeepCeiling:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   S3SonicLand_DeepCeilingWallReturn
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

S3SonicLand_DeepCeilingWallReturn:
                rts
; ---------------------------------------------------------------------------

S3SonicLand_CheckLeftFloorEligibility:
                tst.b   (WindTunnel_flag).w
                bne.s   S3SonicLand_ProbeLeftFloor
                tst.w   y_vel(a0)
                bmi.s   S3SonicLand_LeftFloorReturn

S3SonicLand_ProbeLeftFloor:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   S3SonicLand_LeftFloorReturn
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash

S3SonicLand_LeftFloorReturn:
                rts
; ---------------------------------------------------------------------------

Player_HitCeilingAndWalls:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   S3SonicLand_CheckCeilingSectorRightWall
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

S3SonicLand_CheckCeilingSectorRightWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   S3SonicLand_ProbeCeilingAndResolve
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

S3SonicLand_ProbeCeilingAndResolve:
                bsr.w   Sonic_CheckCeiling
                tst.w   d1
                bpl.s   S3SonicLand_CeilingSectorReturn
                sub.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   S3SonicLand_AttachToSteepCeiling
                move.w  #0,y_vel(a0)                    ; stop Sonic in y since he hit a ceiling
                rts
; ---------------------------------------------------------------------------

S3SonicLand_AttachToSteepCeiling:
                move.b  d3,angle(a0)
                bsr.w   Player_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   S3SonicLand_CeilingSectorReturn
                neg.w   ground_vel(a0)

S3SonicLand_CeilingSectorReturn:
                rts
; ---------------------------------------------------------------------------

S3SonicLand_CheckRightSectorWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   S3SonicLand_ResolveRightSectorCeiling
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

S3SonicLand_ResolveRightSectorCeiling:
                bsr.w   Sonic_CheckCeiling
                tst.w   d1
                bpl.s   S3SonicLand_CheckRightFloorEligibility
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   S3SonicLand_RightCeilingReturn
                move.w  #0,y_vel(a0)

S3SonicLand_RightCeilingReturn:
                rts
; ---------------------------------------------------------------------------

S3SonicLand_CheckRightFloorEligibility:
                tst.b   (WindTunnel_flag).w
                bne.s   S3SonicLand_ProbeRightFloor
                tst.w   y_vel(a0)
                bmi.s   S3SonicLand_RightFloorReturn

S3SonicLand_ProbeRightFloor:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   S3SonicLand_RightFloorReturn
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash

S3SonicLand_RightFloorReturn:
                rts
; End of function Sonic_DoLevelCollision

; =============== S U B R O U T I N E =======================================

Player_TouchFloor_Check_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   S3SonicLand_ResetLandingAndCheckBubble
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
                beq.s   S3SonicLand_ResetLandingAndCheckBubble
                bclr    #Status_Roll,status(a0)
                move.b  #0,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                add.w   d0,y_pos(a0)

S3SonicLand_ResetLandingAndCheckBubble:
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
                beq.s   S3SonicLand_LandingResetReturn
                btst    #Status_BublShield,status_secondary(a0)
                beq.s   S3SonicLand_ClearDoubleJumpFlag
                bsr.s   BubbleShield_Bounce

S3SonicLand_ClearDoubleJumpFlag:
                move.b  #0,double_jump_flag(a0)

S3SonicLand_LandingResetReturn:
                rts
; End of function Player_TouchFloor

; =============== S U B R O U T I N E =======================================

BubbleShield_Bounce:
                movem.l d1-d2,-(sp)
                move.w  #$780,d2
                btst    #Status_Underwater,status(a0)
                beq.s   S3SonicLand_ApplyBubbleNormalImpulse
                move.w  #$400,d2

S3SonicLand_ApplyBubbleNormalImpulse:
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
