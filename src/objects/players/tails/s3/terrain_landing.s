; Owner: objects/players/tails/s3
; Responsibility: Tails terrain collision, floor attachment and landing state restoration
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_DoLevelCollision:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   S3TailsTerrain_DispatchTerrainResponseByVelocityAngleQuadrant
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

S3TailsTerrain_DispatchTerrainResponseByVelocityAngleQuadrant:
                move.b  lrb_solid_bit(a0),d5
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                subi.b  #$20,d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   S3TailsTerrain_ResolveLeftWallInLeftwardVelocityQuadrant
                cmpi.b  #$80,d0
                beq.w   S3TailsTerrain_ResolveLeftWallInUpwardVelocityQuadrant
                cmpi.b  #$C0,d0
                beq.w   S3TailsTerrain_ResolveRightWallInRightwardVelocityQuadrant
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   S3TailsTerrain_ResolveRightWallBeforeDefaultFloorProbe
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

S3TailsTerrain_ResolveRightWallBeforeDefaultFloorProbe:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   S3TailsTerrain_GateFloorPenetrationByTwoSignedByteDepthComparisons
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

S3TailsTerrain_GateFloorPenetrationByTwoSignedByteDepthComparisons:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   S3TailsTerrain_ReturnAfterDefaultFloorGateOrSlopeLanding
                move.b  y_vel(a0),d2
                addq.b  #8,d2
                neg.b   d2
                cmp.b   d2,d1
                bge.s   S3TailsTerrain_AttachFloorAndSelectFlatModerateOrSteepVelocityConversion
                cmp.b   d2,d0
                blt.s   S3TailsTerrain_ReturnAfterDefaultFloorGateOrSlopeLanding

S3TailsTerrain_AttachFloorAndSelectFlatModerateOrSteepVelocityConversion:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   S3TailsTerrain_ClearHorizontalSpeedAndCapPositiveSteepLandingVelocity
                move.b  d3,d0
                addi.b  #$10,d0
                andi.b  #$20,d0
                beq.s   S3TailsTerrain_ZeroVerticalSpeedAndSetFlatGroundSpeedBeforeLandingReset
                asr     y_vel(a0)
                bra.s   S3TailsTerrain_ResetLandingThenDeriveSignedSlopeGroundSpeedFromVertical
; ---------------------------------------------------------------------------

S3TailsTerrain_ZeroVerticalSpeedAndSetFlatGroundSpeedBeforeLandingReset:
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash
                rts
; ---------------------------------------------------------------------------

S3TailsTerrain_ClearHorizontalSpeedAndCapPositiveSteepLandingVelocity:
                move.w  #0,x_vel(a0)
                cmpi.w  #$FC0,y_vel(a0)
                ble.s   S3TailsTerrain_ResetLandingThenDeriveSignedSlopeGroundSpeedFromVertical
                move.w  #$FC0,y_vel(a0)

S3TailsTerrain_ResetLandingThenDeriveSignedSlopeGroundSpeedFromVertical:
                bsr.w   Tails_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   S3TailsTerrain_ReturnAfterDefaultFloorGateOrSlopeLanding
                neg.w   ground_vel(a0)

S3TailsTerrain_ReturnAfterDefaultFloorGateOrSlopeLanding:
                rts
; ---------------------------------------------------------------------------

S3TailsTerrain_ResolveLeftWallInLeftwardVelocityQuadrant:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   S3TailsTerrain_ChooseShallowCeilingCorrectionOrOppositeWallFallbackOnLeftwardPath
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

S3TailsTerrain_ChooseShallowCeilingCorrectionOrOppositeWallFallbackOnLeftwardPath:
                bsr.w   Sonic_CheckCeiling
                tst.w   d1
                bpl.s   S3TailsTerrain_PermitLeftwardFloorProbeInWindOrWithNonnegativeVerticalSpeed
                neg.w   d1
                cmpi.w  #$14,d1
                bhs.s   S3TailsTerrain_ProbeRightWallAfterDeepLeftwardCeilingPenetration
                add.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   S3TailsTerrain_ReturnAfterLeftwardShallowCeilingCorrection
                move.w  #0,y_vel(a0)

S3TailsTerrain_ReturnAfterLeftwardShallowCeilingCorrection:
                rts
; ---------------------------------------------------------------------------

S3TailsTerrain_ProbeRightWallAfterDeepLeftwardCeilingPenetration:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   S3TailsTerrain_ReturnAfterLeftwardDeepCeilingOppositeWallProbe
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

S3TailsTerrain_ReturnAfterLeftwardDeepCeilingOppositeWallProbe:
                rts
; ---------------------------------------------------------------------------

S3TailsTerrain_PermitLeftwardFloorProbeInWindOrWithNonnegativeVerticalSpeed:
                tst.b   (WindTunnel_flag_P2).w
                bne.s   S3TailsTerrain_ProbeAndAttachFloorFromLeftwardQuadrant
                tst.w   y_vel(a0)
                bmi.s   S3TailsTerrain_ReturnAfterLeftwardFloorGateOrAttachment

S3TailsTerrain_ProbeAndAttachFloorFromLeftwardQuadrant:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   S3TailsTerrain_ReturnAfterLeftwardFloorGateOrAttachment
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash

S3TailsTerrain_ReturnAfterLeftwardFloorGateOrAttachment:
                rts
; ---------------------------------------------------------------------------

S3TailsTerrain_ResolveLeftWallInUpwardVelocityQuadrant:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   S3TailsTerrain_ResolveRightWallInUpwardVelocityQuadrant
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

S3TailsTerrain_ResolveRightWallInUpwardVelocityQuadrant:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   S3TailsTerrain_CorrectUpwardCeilingAndGateCeilingSlopeAttachment
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

S3TailsTerrain_CorrectUpwardCeilingAndGateCeilingSlopeAttachment:
                bsr.w   Sonic_CheckCeiling
                tst.w   d1
                bpl.s   S3TailsTerrain_ReturnAfterUpwardCeilingProbeOrSlopeAttachment
                sub.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   S3TailsTerrain_AttachCeilingSlopeAndDeriveGroundSpeedAfterLandingReset
                move.w  #0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsTerrain_AttachCeilingSlopeAndDeriveGroundSpeedAfterLandingReset:
                move.b  d3,angle(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   S3TailsTerrain_ReturnAfterUpwardCeilingProbeOrSlopeAttachment
                neg.w   ground_vel(a0)

S3TailsTerrain_ReturnAfterUpwardCeilingProbeOrSlopeAttachment:
                rts
; ---------------------------------------------------------------------------

S3TailsTerrain_ResolveRightWallInRightwardVelocityQuadrant:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   S3TailsTerrain_CorrectRightwardCeilingWithoutLeftwardDepthThreshold
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

S3TailsTerrain_CorrectRightwardCeilingWithoutLeftwardDepthThreshold:
                bsr.w   Sonic_CheckCeiling
                tst.w   d1
                bpl.s   S3TailsTerrain_PermitRightwardFloorProbeInWindOrWithNonnegativeVerticalSpeed
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   S3TailsTerrain_ReturnAfterRightwardCeilingCorrection
                move.w  #0,y_vel(a0)

S3TailsTerrain_ReturnAfterRightwardCeilingCorrection:
                rts
; ---------------------------------------------------------------------------

S3TailsTerrain_PermitRightwardFloorProbeInWindOrWithNonnegativeVerticalSpeed:
                tst.b   (WindTunnel_flag_P2).w
                bne.s   S3TailsTerrain_ProbeAndAttachFloorFromRightwardQuadrant
                tst.w   y_vel(a0)
                bmi.s   S3TailsTerrain_ReturnAfterRightwardFloorGateOrAttachment

S3TailsTerrain_ProbeAndAttachFloorFromRightwardQuadrant:
                bsr.w   Sonic_CheckFloor
                tst.w   d1
                bpl.s   S3TailsTerrain_ReturnAfterRightwardFloorGateOrAttachment
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                bsr.w   Tails_TouchFloor_Check_Spindash

S3TailsTerrain_ReturnAfterRightwardFloorGateOrAttachment:
                rts
; End of function Tails_DoLevelCollision

; =============== S U B R O U T I N E =======================================

Tails_TouchFloor_Check_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   S3TailsTerrain_ClearAirJumpFlipAndFlightStateAtLandingJoin
                move.b  #0,anim(a0)
; End of function Tails_TouchFloor_Check_Spindash

; =============== S U B R O U T I N E =======================================

Tails_TouchFloor:
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                btst    #Status_Roll,status(a0)
                beq.s   S3TailsTerrain_ClearAirJumpFlipAndFlightStateAtLandingJoin
                bclr    #Status_Roll,status(a0)
                move.b  #0,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                add.w   d0,y_pos(a0)

S3TailsTerrain_ClearAirJumpFlipAndFlightStateAtLandingJoin:
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
