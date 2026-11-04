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
                beq.s   SKSonicTerrain_DispatchTerrainResponseByVelocityAngleQuadrant
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

SKSonicTerrain_DispatchTerrainResponseByVelocityAngleQuadrant:
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
                beq.w   SKSonicTerrain_ResolveRightVelocitySectorWallBeforeCeiling
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKSonicTerrain_CheckRightWallAfterDefaultSectorLeftCorrection
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

SKSonicTerrain_CheckRightWallAfterDefaultSectorLeftCorrection:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKSonicTerrain_GateDefaultFloorPenetrationBySignedByteSpeedDepth
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

SKSonicTerrain_GateDefaultFloorPenetrationBySignedByteSpeedDepth:
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   SKSonicTerrain_ReturnAfterDefaultSectorFloorRejectOrLanding
                move.b  y_vel(a0),d2
                addq.b  #8,d2
                neg.b   d2
                cmp.b   d2,d1
                bge.s   SKSonicTerrain_StoreLandingAngleAndClassifyDefaultFloorSlope
                cmp.b   d2,d0
                blt.s   SKSonicTerrain_ReturnAfterDefaultSectorFloorRejectOrLanding

SKSonicTerrain_StoreLandingAngleAndClassifyDefaultFloorSlope:
                move.b  d3,angle(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicTerrain_ApplyGravitySignedDefaultFloorCorrectionAndClassifySlope
                neg.w   d1

SKSonicTerrain_ApplyGravitySignedDefaultFloorCorrectionAndClassifySlope:
                add.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   SKSonicTerrain_StopHorizontalSpeedAndCapPositiveSteepLandingYVelocity
                move.b  d3,d0
                addi.b  #$10,d0
                andi.b  #$20,d0
                beq.s   SKSonicTerrain_SetFlatLandingGroundSpeedBeforeTouchFloorCleanup
                asr     y_vel(a0)
                bra.s   SKSonicTerrain_RunLandingCleanupBeforeSamplingSignedSlopeGroundSpeed
; ---------------------------------------------------------------------------

SKSonicTerrain_SetFlatLandingGroundSpeedBeforeTouchFloorCleanup:
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash
                rts
; ---------------------------------------------------------------------------

SKSonicTerrain_StopHorizontalSpeedAndCapPositiveSteepLandingYVelocity:
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall
                cmpi.w  #$FC0,y_vel(a0)
                ble.s   SKSonicTerrain_RunLandingCleanupBeforeSamplingSignedSlopeGroundSpeed
                move.w  #$FC0,y_vel(a0)

SKSonicTerrain_RunLandingCleanupBeforeSamplingSignedSlopeGroundSpeed:
                bsr.w   Player_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   SKSonicTerrain_ReturnAfterDefaultSectorFloorRejectOrLanding
                neg.w   ground_vel(a0)

SKSonicTerrain_ReturnAfterDefaultSectorFloorRejectOrLanding:
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
                bpl.s   SKSonicTerrain_GateLeftSectorFloorProbeByWindOrNonnegativeYVelocity  ; branch if distance is positive (not inside ceiling)
                neg.w   d1
                cmpi.w  #$14,d1
                bhs.s   SKSonicTerrain_ProbeOppositeRightWallForDeepLeftSectorCeilingPenetration
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicTerrain_ApplyGravitySignedShallowLeftCeilingCorrection
                neg.w   d1

SKSonicTerrain_ApplyGravitySignedShallowLeftCeilingCorrection:
                add.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   SKSonicTerrain_ReturnAfterShallowLeftSectorCeilingCorrection
                move.w  #0,y_vel(a0)                    ; stop Sonic in y since he hit a ceiling

SKSonicTerrain_ReturnAfterShallowLeftSectorCeilingCorrection:
                rts
; ---------------------------------------------------------------------------

SKSonicTerrain_ProbeOppositeRightWallForDeepLeftSectorCeilingPenetration:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKSonicTerrain_ReturnAfterDeepLeftCeilingOppositeWallFallback
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKSonicTerrain_ReturnAfterDeepLeftCeilingOppositeWallFallback:
                rts
; ---------------------------------------------------------------------------

SKSonicTerrain_GateLeftSectorFloorProbeByWindOrNonnegativeYVelocity:
                tst.b   (WindTunnel_flag).w
                bne.s   SKSonicTerrain_ProbeAndAdmitLeftSectorGravityRelativeFloor
                tst.w   y_vel(a0)
                bmi.s   SKSonicTerrain_ReturnAfterLeftSectorFloorSkipRejectOrCleanup

SKSonicTerrain_ProbeAndAdmitLeftSectorGravityRelativeFloor:
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   SKSonicTerrain_ReturnAfterLeftSectorFloorSkipRejectOrCleanup
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicTerrain_ApplyGravitySignedLeftFloorLandingAndFlatSpeedTransfer
                neg.w   d1

SKSonicTerrain_ApplyGravitySignedLeftFloorLandingAndFlatSpeedTransfer:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash

SKSonicTerrain_ReturnAfterLeftSectorFloorSkipRejectOrCleanup:
                rts
; ---------------------------------------------------------------------------

Player_HitCeilingAndWalls:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKSonicTerrain_CheckRightWallAfterCeilingSectorLeftCorrection
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

SKSonicTerrain_CheckRightWallAfterCeilingSectorLeftCorrection:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKSonicTerrain_CorrectCeilingPenetrationAndChooseStopOrSlopeAttachment
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)                    ; stop Sonic since he hit a wall

SKSonicTerrain_CorrectCeilingPenetrationAndChooseStopOrSlopeAttachment:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   SKSonicTerrain_ReturnAfterCeilingSectorNoContactOrSlopeAttachment
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicTerrain_SubtractGravitySignedCeilingDistanceBeforeSlopeDecision
                neg.w   d1

SKSonicTerrain_SubtractGravitySignedCeilingDistanceBeforeSlopeDecision:
                sub.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   SKSonicTerrain_AttachToSteepCeilingUsingPostCleanupYGroundSpeed
                move.w  #0,y_vel(a0)                    ; stop Sonic in y since he hit a ceiling
                rts
; ---------------------------------------------------------------------------

SKSonicTerrain_AttachToSteepCeilingUsingPostCleanupYGroundSpeed:
                move.b  d3,angle(a0)
                bsr.w   Player_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   SKSonicTerrain_ReturnAfterCeilingSectorNoContactOrSlopeAttachment
                neg.w   ground_vel(a0)

SKSonicTerrain_ReturnAfterCeilingSectorNoContactOrSlopeAttachment:
                rts
; ---------------------------------------------------------------------------

SKSonicTerrain_ResolveRightVelocitySectorWallBeforeCeiling:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKSonicTerrain_CorrectRightSectorCeilingAndStopOnlyUpwardYVelocity
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

SKSonicTerrain_CorrectRightSectorCeilingAndStopOnlyUpwardYVelocity:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   SKSonicTerrain_GateRightSectorFloorProbeByWindOrNonnegativeYVelocity
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicTerrain_SubtractGravitySignedRightSectorCeilingDistance
                neg.w   d1

SKSonicTerrain_SubtractGravitySignedRightSectorCeilingDistance:
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   SKSonicTerrain_ReturnAfterRightSectorCeilingCorrection
                move.w  #0,y_vel(a0)

SKSonicTerrain_ReturnAfterRightSectorCeilingCorrection:
                rts
; ---------------------------------------------------------------------------

SKSonicTerrain_GateRightSectorFloorProbeByWindOrNonnegativeYVelocity:
                tst.b   (WindTunnel_flag).w
                bne.s   SKSonicTerrain_ProbeAndAdmitRightSectorGravityRelativeFloor
                tst.w   y_vel(a0)
                bmi.s   SKSonicTerrain_ReturnAfterRightSectorFloorSkipRejectOrCleanup

SKSonicTerrain_ProbeAndAdmitRightSectorGravityRelativeFloor:
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   SKSonicTerrain_ReturnAfterRightSectorFloorSkipRejectOrCleanup
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicTerrain_ApplyGravitySignedRightFloorLandingAndFlatSpeedTransfer
                neg.w   d1

SKSonicTerrain_ApplyGravitySignedRightFloorLandingAndFlatSpeedTransfer:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Player_TouchFloor_Check_Spindash

SKSonicTerrain_ReturnAfterRightSectorFloorSkipRejectOrCleanup:
                rts

; =============== S U B R O U T I N E =======================================

Player_TouchFloor_Check_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   SKSonicTerrain_ClearLandingMotionFlagsThenGateBubbleRebound
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
                beq.s   SKSonicTerrain_ClearLandingMotionFlagsThenGateBubbleRebound
                bclr    #Status_Roll,status(a0)
                move.b  #0,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicTerrain_SaveUnrollYOffsetAndInvertForOppositeSurfaceHalfPlane
                neg.w   d0

SKSonicTerrain_SaveUnrollYOffsetAndInvertForOppositeSurfaceHalfPlane:
                move.w  d0,-(sp)
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bpl.s   SKSonicTerrain_PopSurfaceAndGravityAdjustedUnrollOffsetIntoPlayerY
                neg.w   (sp)

SKSonicTerrain_PopSurfaceAndGravityAdjustedUnrollOffsetIntoPlayerY:
                move.w  (sp)+,d0
                add.w   d0,y_pos(a0)

SKSonicTerrain_ClearLandingMotionFlagsThenGateBubbleRebound:
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
                beq.s   SKSonicTerrain_ReturnAfterLandingResetAndOptionalImmediateRebound
                tst.b   character_id(a0)
                bne.s   SKSonicTerrain_ClearCompletedDoubleJumpActionAfterOptionalBubbleBounce
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   SKSonicTerrain_ClearCompletedDoubleJumpActionAfterOptionalBubbleBounce
                btst    #Status_BublShield,status_secondary(a0)
                beq.s   SKSonicTerrain_ClearCompletedDoubleJumpActionAfterOptionalBubbleBounce
                bsr.s   BubbleShield_Bounce

SKSonicTerrain_ClearCompletedDoubleJumpActionAfterOptionalBubbleBounce:
                move.b  #0,double_jump_flag(a0)

SKSonicTerrain_ReturnAfterLandingResetAndOptionalImmediateRebound:
                rts
; End of function Player_TouchFloor

; =============== S U B R O U T I N E =======================================

BubbleShield_Bounce:
                movem.l d1-d2,-(sp)
                move.w  #$780,d2
                btst    #Status_Underwater,status(a0)
                beq.s   SKSonicTerrain_AddAngleNormalBubbleImpulseAndRestoreRollingGeometry
                move.w  #$400,d2

SKSonicTerrain_AddAngleNormalBubbleImpulseAndRestoreRollingGeometry:
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
                beq.s   SKSonicTerrain_ApplyBubbleRadiusOffsetAfterReverseGravitySignChoice
                neg.w   d0

SKSonicTerrain_ApplyBubbleRadiusOffsetAfterReverseGravitySignChoice:
                sub.w   d0,y_pos(a0)
                move.b  #2,(Shield+anim).w
                move.w  #sfx_BubbleAttack,d0
                jmp     (Play_SFX).l
; End of function BubbleShield_Bounce
