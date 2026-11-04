; Owner: objects/players/tails/sk
; Responsibility: Tails terrain collision, floor attachment and landing state restoration
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_DoLevelCollision:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   SKTailsLand_DispatchVelocitySector
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

SKTailsLand_DispatchVelocitySector:
                move.b  lrb_solid_bit(a0),d5
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                subi.b  #$20,d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   SKTailsLand_CheckLeftSectorWall
                cmpi.b  #$80,d0
                beq.w   SKTailsLand_CheckCeilingSectorLeftWall
                cmpi.b  #$C0,d0
                beq.w   SKTailsLand_CheckRightSectorWall
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKTailsLand_CheckDefaultRightWall
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKTailsLand_CheckDefaultRightWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKTailsLand_TestDefaultFloorDepth
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

; Add eight to the high Y speed byte and negate it before the signed penetration and sensor comparisons
SKTailsLand_TestDefaultFloorDepth:
                bsr.w   SKPlayer_ProbeGravityFloor
                tst.w   d1
                bpl.s   SKTailsLand_DefaultFloorReturn
                move.b  y_vel(a0),d2
                addq.b  #8,d2
                neg.b   d2
                cmp.b   d2,d1
                bge.s   SKTailsLand_StoreDefaultFloorAngle
                cmp.b   d2,d0
                blt.s   SKTailsLand_DefaultFloorReturn

SKTailsLand_StoreDefaultFloorAngle:
                move.b  d3,angle(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsLand_CorrectDefaultFloorAndSlope
                neg.w   d1

SKTailsLand_CorrectDefaultFloorAndSlope:
                add.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   SKTailsLand_ClampSteepLandingSpeed
                move.b  d3,d0
                addi.b  #$10,d0
                andi.b  #$20,d0
                beq.s   SKTailsLand_LandOnFlatFloor
                asr     y_vel(a0)
                bra.s   SKTailsLand_FinishSlopeLanding
; ---------------------------------------------------------------------------

SKTailsLand_LandOnFlatFloor:
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash
                rts
; ---------------------------------------------------------------------------

SKTailsLand_ClampSteepLandingSpeed:
                move.w  #0,x_vel(a0)
                cmpi.w  #$FC0,y_vel(a0)
                ble.s   SKTailsLand_FinishSlopeLanding
                move.w  #$FC0,y_vel(a0)

SKTailsLand_FinishSlopeLanding:
                bsr.w   Tails_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   SKTailsLand_DefaultFloorReturn
                neg.w   ground_vel(a0)

SKTailsLand_DefaultFloorReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsLand_CheckLeftSectorWall:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKTailsLand_CheckLeftSectorCeiling
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

SKTailsLand_CheckLeftSectorCeiling:
                bsr.w   SKPlayer_ProbeGravityCeiling
                tst.w   d1
                bpl.s   SKTailsLand_CheckLeftFloorEligibility
                neg.w   d1
                cmpi.w  #$14,d1
                bhs.s   SKTailsLand_CheckRightWallAtDeepCeiling
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsLand_CorrectLeftCeilingY
                neg.w   d1

SKTailsLand_CorrectLeftCeilingY:
                add.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   SKTailsLand_LeftCeilingReturn
                move.w  #0,y_vel(a0)

SKTailsLand_LeftCeilingReturn:
                rts
; ---------------------------------------------------------------------------

; Ceiling penetration of at least $14 pixels routes the left sector to the opposite wall probe
SKTailsLand_CheckRightWallAtDeepCeiling:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKTailsLand_DeepCeilingWallReturn
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKTailsLand_DeepCeilingWallReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsLand_CheckLeftFloorEligibility:
                tst.b   (WindTunnel_flag_P2).w
                bne.s   SKTailsLand_ProbeLeftFloor
                tst.w   y_vel(a0)
                bmi.s   SKTailsLand_LeftFloorReturn

SKTailsLand_ProbeLeftFloor:
                bsr.w   SKPlayer_ProbeGravityFloor
                tst.w   d1
                bpl.s   SKTailsLand_LeftFloorReturn
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsLand_LandOnLeftSectorFloor
                neg.w   d1

SKTailsLand_LandOnLeftSectorFloor:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash

SKTailsLand_LeftFloorReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsLand_CheckCeilingSectorLeftWall:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKTailsLand_CheckCeilingSectorRightWall
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKTailsLand_CheckCeilingSectorRightWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKTailsLand_ProbeCeilingAndResolve
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKTailsLand_ProbeCeilingAndResolve:
                bsr.w   SKPlayer_ProbeGravityCeiling
                tst.w   d1
                bpl.s   SKTailsLand_CeilingSectorReturn
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsLand_CorrectCeilingAndCheckSlope
                neg.w   d1

SKTailsLand_CorrectCeilingAndCheckSlope:
                sub.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   SKTailsLand_AttachToSteepCeiling
                move.w  #0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsLand_AttachToSteepCeiling:
                move.b  d3,angle(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   SKTailsLand_CeilingSectorReturn
                neg.w   ground_vel(a0)

SKTailsLand_CeilingSectorReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsLand_CheckRightSectorWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKTailsLand_ResolveRightSectorCeiling
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

SKTailsLand_ResolveRightSectorCeiling:
                bsr.w   SKPlayer_ProbeGravityCeiling
                tst.w   d1
                bpl.s   SKTailsLand_CheckRightFloorEligibility
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsLand_CorrectRightCeilingY
                neg.w   d1

SKTailsLand_CorrectRightCeilingY:
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   SKTailsLand_RightCeilingReturn
                move.w  #0,y_vel(a0)

SKTailsLand_RightCeilingReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsLand_CheckRightFloorEligibility:
                tst.b   (WindTunnel_flag_P2).w
                bne.s   SKTailsLand_ProbeRightFloor
                tst.w   y_vel(a0)
                bmi.s   SKTailsLand_RightFloorReturn

SKTailsLand_ProbeRightFloor:
                bsr.w   SKPlayer_ProbeGravityFloor
                tst.w   d1
                bpl.s   SKTailsLand_RightFloorReturn
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsLand_LandOnRightSectorFloor
                neg.w   d1

SKTailsLand_LandOnRightSectorFloor:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash

SKTailsLand_RightFloorReturn:
                rts
; End of function Tails_DoLevelCollision

; =============== S U B R O U T I N E =======================================

Tails_TouchFloor_Check_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   SKTailsLand_ResetLandingAndFlight
                move.b  #0,anim(a0)
; End of function Tails_TouchFloor_Check_Spindash

; =============== S U B R O U T I N E =======================================

Tails_TouchFloor:
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                btst    #Status_Roll,status(a0)
                beq.s   SKTailsLand_ResetLandingAndFlight
                bclr    #Status_Roll,status(a0)
                move.b  #0,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsLand_AdjustUnrollOffsetForSurface
                neg.w   d0

SKTailsLand_AdjustUnrollOffsetForSurface:
                move.w  d0,-(sp)
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bpl.s   SKTailsLand_ApplyUnrollYOffset
                neg.w   (sp)

SKTailsLand_ApplyUnrollYOffset:
                move.w  (sp)+,d0
                add.w   d0,y_pos(a0)

SKTailsLand_ResetLandingAndFlight:
                bclr    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                bclr    #Status_RollJump,status(a0)
                move.b  #0,jumping(a0)
                move.w  #0,(Chain_bonus_counter).w
                move.b  #0,flip_angle(a0)
                move.b  #0,flip_type(a0)
                move.b  #0,flips_remaining(a0)
                move.b  #0,scroll_delay_counter(a0)
                move.b  #0,double_jump_flag(a0)
                rts
; End of function Tails_TouchFloor
