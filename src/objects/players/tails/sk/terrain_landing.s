; Owner: objects/players/tails/sk
; Responsibility: Tails terrain collision, floor attachment and landing state restoration
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_DoLevelCollision:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   SKTailsTerrain_DispatchTerrainResponseByVelocityAngleQuadrant
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

SKTailsTerrain_DispatchTerrainResponseByVelocityAngleQuadrant:
                move.b  lrb_solid_bit(a0),d5
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                subi.b  #$20,d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   SKTailsTerrain_ResolveLeftWallInLeftwardVelocityQuadrant
                cmpi.b  #$80,d0
                beq.w   SKTailsTerrain_ResolveLeftWallInUpwardVelocityQuadrant
                cmpi.b  #$C0,d0
                beq.w   SKTailsTerrain_ResolveRightWallInRightwardVelocityQuadrant
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKTailsTerrain_ResolveRightWallBeforeDefaultFloorProbe
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKTailsTerrain_ResolveRightWallBeforeDefaultFloorProbe:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKTailsTerrain_GateFloorPenetrationByTwoSignedByteDepthComparisons
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKTailsTerrain_GateFloorPenetrationByTwoSignedByteDepthComparisons:
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   SKTailsTerrain_ReturnAfterDefaultFloorGateOrSlopeLanding
                move.b  y_vel(a0),d2
                addq.b  #8,d2
                neg.b   d2
                cmp.b   d2,d1
                bge.s   SKTailsTerrain_AttachFloorAndSelectFlatModerateOrSteepVelocityConversion
                cmp.b   d2,d0
                blt.s   SKTailsTerrain_ReturnAfterDefaultFloorGateOrSlopeLanding

SKTailsTerrain_AttachFloorAndSelectFlatModerateOrSteepVelocityConversion:
                move.b  d3,angle(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsTerrain_ApplyGravityOrientedDefaultFloorOffsetAndClassifySlope
                neg.w   d1

SKTailsTerrain_ApplyGravityOrientedDefaultFloorOffsetAndClassifySlope:
                add.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   SKTailsTerrain_ClearHorizontalSpeedAndCapPositiveSteepLandingVelocity
                move.b  d3,d0
                addi.b  #$10,d0
                andi.b  #$20,d0
                beq.s   SKTailsTerrain_ZeroVerticalSpeedAndSetFlatGroundSpeedBeforeLandingReset
                asr     y_vel(a0)
                bra.s   SKTailsTerrain_ResetLandingThenDeriveSignedSlopeGroundSpeedFromVertical
; ---------------------------------------------------------------------------

SKTailsTerrain_ZeroVerticalSpeedAndSetFlatGroundSpeedBeforeLandingReset:
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash
                rts
; ---------------------------------------------------------------------------

SKTailsTerrain_ClearHorizontalSpeedAndCapPositiveSteepLandingVelocity:
                move.w  #0,x_vel(a0)
                cmpi.w  #$FC0,y_vel(a0)
                ble.s   SKTailsTerrain_ResetLandingThenDeriveSignedSlopeGroundSpeedFromVertical
                move.w  #$FC0,y_vel(a0)

SKTailsTerrain_ResetLandingThenDeriveSignedSlopeGroundSpeedFromVertical:
                bsr.w   Tails_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   SKTailsTerrain_ReturnAfterDefaultFloorGateOrSlopeLanding
                neg.w   ground_vel(a0)

SKTailsTerrain_ReturnAfterDefaultFloorGateOrSlopeLanding:
                rts
; ---------------------------------------------------------------------------

SKTailsTerrain_ResolveLeftWallInLeftwardVelocityQuadrant:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKTailsTerrain_ChooseShallowCeilingCorrectionOrOppositeWallFallbackOnLeftwardPath
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

SKTailsTerrain_ChooseShallowCeilingCorrectionOrOppositeWallFallbackOnLeftwardPath:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   SKTailsTerrain_PermitLeftwardFloorProbeInWindOrWithNonnegativeVerticalSpeed
                neg.w   d1
                cmpi.w  #$14,d1
                bhs.s   SKTailsTerrain_ProbeRightWallAfterDeepLeftwardCeilingPenetration
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsTerrain_ApplyGravityOrientedShallowLeftwardCeilingOffset
                neg.w   d1

SKTailsTerrain_ApplyGravityOrientedShallowLeftwardCeilingOffset:
                add.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   SKTailsTerrain_ReturnAfterLeftwardShallowCeilingCorrection
                move.w  #0,y_vel(a0)

SKTailsTerrain_ReturnAfterLeftwardShallowCeilingCorrection:
                rts
; ---------------------------------------------------------------------------

SKTailsTerrain_ProbeRightWallAfterDeepLeftwardCeilingPenetration:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKTailsTerrain_ReturnAfterLeftwardDeepCeilingOppositeWallProbe
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKTailsTerrain_ReturnAfterLeftwardDeepCeilingOppositeWallProbe:
                rts
; ---------------------------------------------------------------------------

SKTailsTerrain_PermitLeftwardFloorProbeInWindOrWithNonnegativeVerticalSpeed:
                tst.b   (WindTunnel_flag_P2).w
                bne.s   SKTailsTerrain_ProbeAndAttachFloorFromLeftwardQuadrant
                tst.w   y_vel(a0)
                bmi.s   SKTailsTerrain_ReturnAfterLeftwardFloorGateOrAttachment

SKTailsTerrain_ProbeAndAttachFloorFromLeftwardQuadrant:
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   SKTailsTerrain_ReturnAfterLeftwardFloorGateOrAttachment
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsTerrain_ApplyGravityOrientedLeftwardFloorLandingOffset
                neg.w   d1

SKTailsTerrain_ApplyGravityOrientedLeftwardFloorLandingOffset:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash

SKTailsTerrain_ReturnAfterLeftwardFloorGateOrAttachment:
                rts
; ---------------------------------------------------------------------------

SKTailsTerrain_ResolveLeftWallInUpwardVelocityQuadrant:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKTailsTerrain_ResolveRightWallInUpwardVelocityQuadrant
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKTailsTerrain_ResolveRightWallInUpwardVelocityQuadrant:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKTailsTerrain_CorrectUpwardCeilingAndGateCeilingSlopeAttachment
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKTailsTerrain_CorrectUpwardCeilingAndGateCeilingSlopeAttachment:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   SKTailsTerrain_ReturnAfterUpwardCeilingProbeOrSlopeAttachment
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsTerrain_ApplyGravityOrientedUpwardCeilingOffsetAndSlopeGate
                neg.w   d1

SKTailsTerrain_ApplyGravityOrientedUpwardCeilingOffsetAndSlopeGate:
                sub.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   SKTailsTerrain_AttachCeilingSlopeAndDeriveGroundSpeedAfterLandingReset
                move.w  #0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsTerrain_AttachCeilingSlopeAndDeriveGroundSpeedAfterLandingReset:
                move.b  d3,angle(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   SKTailsTerrain_ReturnAfterUpwardCeilingProbeOrSlopeAttachment
                neg.w   ground_vel(a0)

SKTailsTerrain_ReturnAfterUpwardCeilingProbeOrSlopeAttachment:
                rts
; ---------------------------------------------------------------------------

SKTailsTerrain_ResolveRightWallInRightwardVelocityQuadrant:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKTailsTerrain_CorrectRightwardCeilingWithoutLeftwardDepthThreshold
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

SKTailsTerrain_CorrectRightwardCeilingWithoutLeftwardDepthThreshold:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   SKTailsTerrain_PermitRightwardFloorProbeInWindOrWithNonnegativeVerticalSpeed
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsTerrain_ApplyGravityOrientedRightwardCeilingOffset
                neg.w   d1

SKTailsTerrain_ApplyGravityOrientedRightwardCeilingOffset:
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   SKTailsTerrain_ReturnAfterRightwardCeilingCorrection
                move.w  #0,y_vel(a0)

SKTailsTerrain_ReturnAfterRightwardCeilingCorrection:
                rts
; ---------------------------------------------------------------------------

SKTailsTerrain_PermitRightwardFloorProbeInWindOrWithNonnegativeVerticalSpeed:
                tst.b   (WindTunnel_flag_P2).w
                bne.s   SKTailsTerrain_ProbeAndAttachFloorFromRightwardQuadrant
                tst.w   y_vel(a0)
                bmi.s   SKTailsTerrain_ReturnAfterRightwardFloorGateOrAttachment

SKTailsTerrain_ProbeAndAttachFloorFromRightwardQuadrant:
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   SKTailsTerrain_ReturnAfterRightwardFloorGateOrAttachment
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsTerrain_ApplyGravityOrientedRightwardFloorLandingOffset
                neg.w   d1

SKTailsTerrain_ApplyGravityOrientedRightwardFloorLandingOffset:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash

SKTailsTerrain_ReturnAfterRightwardFloorGateOrAttachment:
                rts
; End of function Tails_DoLevelCollision

; =============== S U B R O U T I N E =======================================

Tails_TouchFloor_Check_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   SKTailsTerrain_ClearAirJumpFlipAndFlightStateAtLandingJoin
                move.b  #0,anim(a0)
; End of function Tails_TouchFloor_Check_Spindash

; =============== S U B R O U T I N E =======================================

Tails_TouchFloor:
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                btst    #Status_Roll,status(a0)
                beq.s   SKTailsTerrain_ClearAirJumpFlipAndFlightStateAtLandingJoin
                bclr    #Status_Roll,status(a0)
                move.b  #0,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsTerrain_StackUnrollRadiusDeltaAndOrientByAngleHalfRange
                neg.w   d0

SKTailsTerrain_StackUnrollRadiusDeltaAndOrientByAngleHalfRange:
                move.w  d0,-(sp)
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bpl.s   SKTailsTerrain_PopOrientedUnrollDeltaAndAddToIntegerY
                neg.w   (sp)

SKTailsTerrain_PopOrientedUnrollDeltaAndAddToIntegerY:
                move.w  (sp)+,d0
                add.w   d0,y_pos(a0)

SKTailsTerrain_ClearAirJumpFlipAndFlightStateAtLandingJoin:
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
