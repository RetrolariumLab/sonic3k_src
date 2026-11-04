; Owner: objects/players/tails/s3
; Responsibility: Tails terrain collision, floor attachment and landing state restoration
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_DoLevelCollision:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   S3TailsLand_DispatchVelocitySector
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

S3TailsLand_DispatchVelocitySector:
                move.b  lrb_solid_bit(a0),d5
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                subi.b  #$20,d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   S3TailsLand_CheckLeftSectorWall
                cmpi.b  #$80,d0
                beq.w   S3TailsLand_CheckCeilingSectorLeftWall
                cmpi.b  #$C0,d0
                beq.w   S3TailsLand_CheckRightSectorWall
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   S3TailsLand_CheckDefaultRightWall
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

S3TailsLand_CheckDefaultRightWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   S3TailsLand_TestDefaultFloorDepth
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

; Add eight to the high Y speed byte and negate it before the signed penetration and sensor comparisons
S3TailsLand_TestDefaultFloorDepth:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   S3TailsLand_DefaultFloorReturn
                move.b  y_vel(a0),d2
                addq.b  #8,d2
                neg.b   d2
                cmp.b   d2,d1
                bge.s   S3TailsLand_StoreDefaultFloorAngle
                cmp.b   d2,d0
                blt.s   S3TailsLand_DefaultFloorReturn

S3TailsLand_StoreDefaultFloorAngle:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   S3TailsLand_ClampSteepLandingSpeed
                move.b  d3,d0
                addi.b  #$10,d0
                andi.b  #$20,d0
                beq.s   S3TailsLand_LandOnFlatFloor
                asr     y_vel(a0)
                bra.s   S3TailsLand_FinishSlopeLanding
; ---------------------------------------------------------------------------

S3TailsLand_LandOnFlatFloor:
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash
                rts
; ---------------------------------------------------------------------------

S3TailsLand_ClampSteepLandingSpeed:
                move.w  #0,x_vel(a0)
                cmpi.w  #$FC0,y_vel(a0)
                ble.s   S3TailsLand_FinishSlopeLanding
                move.w  #$FC0,y_vel(a0)

S3TailsLand_FinishSlopeLanding:
                bsr.w   Tails_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   S3TailsLand_DefaultFloorReturn
                neg.w   ground_vel(a0)

S3TailsLand_DefaultFloorReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsLand_CheckLeftSectorWall:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   S3TailsLand_CheckLeftSectorCeiling
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

S3TailsLand_CheckLeftSectorCeiling:
                bsr.w   Sonic_CheckCeiling
                tst.w   d1
                bpl.s   S3TailsLand_CheckLeftFloorEligibility
                neg.w   d1
                cmpi.w  #$14,d1
                bhs.s   S3TailsLand_CheckRightWallAtDeepCeiling
                add.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   S3TailsLand_LeftCeilingReturn
                move.w  #0,y_vel(a0)

S3TailsLand_LeftCeilingReturn:
                rts
; ---------------------------------------------------------------------------

; Ceiling penetration of at least $14 pixels routes the left sector to the opposite wall probe
S3TailsLand_CheckRightWallAtDeepCeiling:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   S3TailsLand_DeepCeilingWallReturn
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

S3TailsLand_DeepCeilingWallReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsLand_CheckLeftFloorEligibility:
                tst.b   (WindTunnel_flag_P2).w
                bne.s   S3TailsLand_ProbeLeftFloor
                tst.w   y_vel(a0)
                bmi.s   S3TailsLand_LeftFloorReturn

S3TailsLand_ProbeLeftFloor:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   S3TailsLand_LeftFloorReturn
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash

S3TailsLand_LeftFloorReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsLand_CheckCeilingSectorLeftWall:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   S3TailsLand_CheckCeilingSectorRightWall
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

S3TailsLand_CheckCeilingSectorRightWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   S3TailsLand_ProbeCeilingAndResolve
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

S3TailsLand_ProbeCeilingAndResolve:
                bsr.w   Sonic_CheckCeiling
                tst.w   d1
                bpl.s   S3TailsLand_CeilingSectorReturn
                sub.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   S3TailsLand_AttachToSteepCeiling
                move.w  #0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsLand_AttachToSteepCeiling:
                move.b  d3,angle(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   S3TailsLand_CeilingSectorReturn
                neg.w   ground_vel(a0)

S3TailsLand_CeilingSectorReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsLand_CheckRightSectorWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   S3TailsLand_ResolveRightSectorCeiling
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

S3TailsLand_ResolveRightSectorCeiling:
                bsr.w   Sonic_CheckCeiling
                tst.w   d1
                bpl.s   S3TailsLand_CheckRightFloorEligibility
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   S3TailsLand_RightCeilingReturn
                move.w  #0,y_vel(a0)

S3TailsLand_RightCeilingReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsLand_CheckRightFloorEligibility:
                tst.b   (WindTunnel_flag_P2).w
                bne.s   S3TailsLand_ProbeRightFloor
                tst.w   y_vel(a0)
                bmi.s   S3TailsLand_RightFloorReturn

S3TailsLand_ProbeRightFloor:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   S3TailsLand_RightFloorReturn
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash

S3TailsLand_RightFloorReturn:
                rts
; End of function Tails_DoLevelCollision

; =============== S U B R O U T I N E =======================================

Tails_TouchFloor_Check_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   S3TailsLand_ResetLandingAndFlight
                move.b  #0,anim(a0)
; End of function Tails_TouchFloor_Check_Spindash

; =============== S U B R O U T I N E =======================================

Tails_TouchFloor:
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                btst    #Status_Roll,status(a0)
                beq.s   S3TailsLand_ResetLandingAndFlight
                bclr    #Status_Roll,status(a0)
                move.b  #0,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                add.w   d0,y_pos(a0)

S3TailsLand_ResetLandingAndFlight:
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
