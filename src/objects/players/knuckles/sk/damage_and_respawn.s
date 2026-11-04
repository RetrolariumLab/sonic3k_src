; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles hurt, death, recovery, restart and collision response states
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Knux_DoLevelCollision_CheckRet:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   SKKnucklesGlideContact_DispatchByStoredVelocityQuadrantAndProbeFirstLeftWall
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

SKKnucklesGlideContact_DispatchByStoredVelocityQuadrantAndProbeFirstLeftWall:
                move.b  lrb_solid_bit(a0),d5
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                subi.b  #$20,d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   SKKnucklesGlideContact_ProbeLeftWallForLeftwardVelocitySector
                cmpi.b  #$80,d0
                beq.w   SKKnucklesGlideContact_ProbeLeftWallForUpwardVelocitySector
                cmpi.b  #$C0,d0
                beq.w   SKKnucklesGlideContact_ProbeRightWallForRightwardVelocitySector
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKKnucklesGlideContact_ProbeRightWallBeforeDefaultFloorQuery
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

SKKnucklesGlideContact_ProbeRightWallBeforeDefaultFloorQuery:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKKnucklesGlideContact_QueryDefaultGravityRelativeFloorAndGateNegativeDistance
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

SKKnucklesGlideContact_QueryDefaultGravityRelativeFloorAndGateNegativeDistance:
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   SKKnucklesGlideContact_ReturnAfterDefaultFloorMissOrAppliedContact
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnucklesGlideContact_ApplyDefaultFloorContactAndClearGlobalAirFlag
                neg.w   d1

SKKnucklesGlideContact_ApplyDefaultFloorContactAndClearGlobalAirFlag:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                bclr    #Status_InAir,(Gliding_collision_flags).w

SKKnucklesGlideContact_ReturnAfterDefaultFloorMissOrAppliedContact:
                rts
; ---------------------------------------------------------------------------

SKKnucklesGlideContact_ProbeLeftWallForLeftwardVelocitySector:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKKnucklesGlideContact_ChooseShallowLeftSectorCeilingOrOppositeWallProbe
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

SKKnucklesGlideContact_ChooseShallowLeftSectorCeilingOrOppositeWallProbe:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   SKKnucklesGlideContact_GateLeftSectorFloorFallbackByNonnegativeYVelocity
                neg.w   d1
                cmpi.w  #$14,d1
                bhs.s   SKKnucklesGlideContact_ProbeOppositeRightWallForDeepLeftSectorCeiling
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnucklesGlideContact_CorrectShallowLeftSectorCeilingAndStopUpwardSpeed
                neg.w   d1

SKKnucklesGlideContact_CorrectShallowLeftSectorCeilingAndStopUpwardSpeed:
                add.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   SKKnucklesGlideContact_ReturnAfterShallowLeftSectorCeilingResponse
                move.w  #0,y_vel(a0)

SKKnucklesGlideContact_ReturnAfterShallowLeftSectorCeilingResponse:
                rts
; ---------------------------------------------------------------------------

SKKnucklesGlideContact_ProbeOppositeRightWallForDeepLeftSectorCeiling:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKKnucklesGlideContact_ReturnAfterDeepCeilingOppositeWallProbe
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

SKKnucklesGlideContact_ReturnAfterDeepCeilingOppositeWallProbe:
                rts
; ---------------------------------------------------------------------------

SKKnucklesGlideContact_GateLeftSectorFloorFallbackByNonnegativeYVelocity:
                tst.w   y_vel(a0)
                bmi.s   SKKnucklesGlideContact_ReturnAfterLeftSectorFloorGateOrAppliedContact
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   SKKnucklesGlideContact_ReturnAfterLeftSectorFloorGateOrAppliedContact
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnucklesGlideContact_ApplyLeftSectorFloorContactAndClearGlobalAir
                neg.w   d1

SKKnucklesGlideContact_ApplyLeftSectorFloorContactAndClearGlobalAir:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                bclr    #Status_InAir,(Gliding_collision_flags).w

SKKnucklesGlideContact_ReturnAfterLeftSectorFloorGateOrAppliedContact:
                rts
; ---------------------------------------------------------------------------

SKKnucklesGlideContact_ProbeLeftWallForUpwardVelocitySector:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKKnucklesGlideContact_ProbeRightWallBeforeUpwardSectorCeilingQuery
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

SKKnucklesGlideContact_ProbeRightWallBeforeUpwardSectorCeilingQuery:
                jsr     (CheckRightWallDist).l
                tst.w   d1
                bpl.s   SKKnucklesGlideContact_QueryUpwardSectorCeilingAndAdjustDistanceForGravity
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

SKKnucklesGlideContact_QueryUpwardSectorCeilingAndAdjustDistanceForGravity:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   SKKnucklesGlideContact_ReturnAfterUpwardSectorCeilingMissOrCorrection
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnucklesGlideContact_ApplyUpwardSectorCeilingAndClearYVelocity
                neg.w   d1

SKKnucklesGlideContact_ApplyUpwardSectorCeilingAndClearYVelocity:
                sub.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)

SKKnucklesGlideContact_ReturnAfterUpwardSectorCeilingMissOrCorrection:
                rts
; ---------------------------------------------------------------------------

SKKnucklesGlideContact_ProbeRightWallForRightwardVelocitySector:
                jsr     (CheckRightWallDist).l
                tst.w   d1
                bpl.s   SKKnucklesGlideContact_QueryRightSectorCeilingOrUseFloorFallback
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

SKKnucklesGlideContact_QueryRightSectorCeilingOrUseFloorFallback:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   SKKnucklesGlideContact_GateRightSectorFloorFallbackByNonnegativeYVelocity
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnucklesGlideContact_CorrectRightSectorCeilingAndClampOnlyNegativeYSpeed
                neg.w   d1

SKKnucklesGlideContact_CorrectRightSectorCeilingAndClampOnlyNegativeYSpeed:
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   SKKnucklesGlideContact_ReturnAfterRightSectorCeilingResponse
                move.w  #0,y_vel(a0)

SKKnucklesGlideContact_ReturnAfterRightSectorCeilingResponse:
                rts
; ---------------------------------------------------------------------------

SKKnucklesGlideContact_GateRightSectorFloorFallbackByNonnegativeYVelocity:
                tst.w   y_vel(a0)
                bmi.s   SKKnucklesGlideContact_ReturnAfterRightSectorFloorGateOrContact
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   SKKnucklesGlideContact_ReturnAfterRightSectorFloorGateOrContact
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnucklesGlideContact_ApplyRightSectorFloorContactAndClearGlobalAir
                neg.w   d1

SKKnucklesGlideContact_ApplyRightSectorFloorContactAndClearGlobalAir:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                bclr    #Status_InAir,(Gliding_collision_flags).w

SKKnucklesGlideContact_ReturnAfterRightSectorFloorGateOrContact:
                rts
; End of function Knux_DoLevelCollision_CheckRet

; ---------------------------------------------------------------------------
; unused/dead code

Knux_TouchFloor_Check_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   SKKnucklesLanding_ClearActorAirPushRollJumpAndGlideState
                move.b  #0,anim(a0)
; End of function Knux_TouchFloor_Check_Spindash

; =============== S U B R O U T I N E =======================================

Knux_TouchFloor:
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                btst    #Status_Roll,status(a0)
                beq.s   SKKnucklesLanding_ClearActorAirPushRollJumpAndGlideState
                bclr    #Status_Roll,status(a0)
                move.b  #0,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnucklesLanding_AdjustUnrollYOffsetByGravityAndAngleHemisphere
                neg.w   d0

SKKnucklesLanding_AdjustUnrollYOffsetByGravityAndAngleHemisphere:
                move.w  d0,-(sp)
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bpl.s   SKKnucklesLanding_ApplySavedUnrollYOffsetBeforeCommonLandingReset
                neg.w   (sp)

SKKnucklesLanding_ApplySavedUnrollYOffsetBeforeCommonLandingReset:
                move.w  (sp)+,d0
                add.w   d0,y_pos(a0)

SKKnucklesLanding_ClearActorAirPushRollJumpAndGlideState:
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
                cmpi.b  #$20,anim(a0)
                blo.s   SKKnucklesLanding_ReturnAfterLandingResetAndOptionalSpecialAnimationClear
                move.b  #0,anim(a0)

SKKnucklesLanding_ReturnAfterLandingResetAndOptionalSpecialAnimationClear:
                rts
; End of function Knux_TouchFloor

; ---------------------------------------------------------------------------

SKKnucklesRecovery_EnterDebugBeforeHurtMotionOrContinueHurtState:
                tst.w   (Debug_mode_flag).w
                beq.s   SKKnucklesRecovery_MoveHurtWithOldVelocityThenApplyStoredGravity
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKKnucklesRecovery_MoveHurtWithOldVelocityThenApplyStoredGravity
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKKnucklesRecovery_MoveHurtWithOldVelocityThenApplyStoredGravity:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   SKKnucklesRecovery_WrapHurtIntegerYAtSharedMinusHundredCameraMinimum
                subi.w  #$20,y_vel(a0)

SKKnucklesRecovery_WrapHurtIntegerYAtSharedMinusHundredCameraMinimum:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   SKKnucklesRecovery_ResolveHurtLandingThenBoundsHistoryAnimationAndDraw
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

SKKnucklesRecovery_ResolveHurtLandingThenBoundsHistoryAnimationAndDraw:
                bsr.w   ResolveKnucklesHurtLandingOrDeathPlane
                bsr.w   Player_LevelBound
                bsr.w   Sonic_RecordPos
                bsr.w   AnimateKnucklesApplyGravityFlipAndQueuePatterns
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

ResolveKnucklesHurtLandingOrDeathPlane:
                tst.b   (Disable_death_plane).w
                bne.s   SKKnucklesRecovery_ProbeHurtTerrainAndRecoverControlWhenActorAirBitClears
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKKnucklesRecovery_TestReverseGravityHurtDeathPlaneIncludingEquality
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   SKKnucklesRecovery_TailKillAfterEnabledHurtDeathPlaneCrossing
                bra.s   SKKnucklesRecovery_ProbeHurtTerrainAndRecoverControlWhenActorAirBitClears
; ---------------------------------------------------------------------------

SKKnucklesRecovery_TestReverseGravityHurtDeathPlaneIncludingEquality:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   y_pos(a0),d0
                blt.s   SKKnucklesRecovery_ProbeHurtTerrainAndRecoverControlWhenActorAirBitClears
                bra.w   SKKnucklesRecovery_TailKillAfterEnabledHurtDeathPlaneCrossing
; ---------------------------------------------------------------------------

SKKnucklesRecovery_ProbeHurtTerrainAndRecoverControlWhenActorAirBitClears:
                movem.l a4-a6,-(sp)
                bsr.w   SonicKnux_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   SKKnucklesRecovery_ReturnAfterHurtTerrainHoldOrRecoveredState
                moveq   #0,d0
                move.w  d0,y_vel(a0)
                move.w  d0,x_vel(a0)
                move.w  d0,ground_vel(a0)
                move.b  d0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #$100,priority(a0)
                move.b  #2,routine(a0)
                move.b  #2*60,invulnerability_timer(a0)
                move.b  #0,spin_dash_flag(a0)

SKKnucklesRecovery_ReturnAfterHurtTerrainHoldOrRecoveredState:
                rts
; ---------------------------------------------------------------------------

SKKnucklesRecovery_TailKillAfterEnabledHurtDeathPlaneCrossing:
                jmp     (Kill_Character).l
; End of function ResolveKnucklesHurtLandingOrDeathPlane

; ---------------------------------------------------------------------------

SKKnucklesRecovery_EnterDebugBeforeDeathFinisherOrContinueDeathState:
                tst.w   (Debug_mode_flag).w
                beq.s   SKKnucklesRecovery_FinishDeathBeforeGravityMotionHistoryAndDraw
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKKnucklesRecovery_FinishDeathBeforeGravityMotionHistoryAndDraw
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKKnucklesRecovery_FinishDeathBeforeGravityMotionHistoryAndDraw:
                bsr.w   PlayerSKFinishDeathWithFollowerResetRestartOrCompetitionRespawn
                jsr     (MoveSprite_TestGravity).l
                bsr.w   Sonic_RecordPos
                bsr.w   AnimateKnucklesApplyGravityFlipAndQueuePatterns
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKKnucklesRecovery_CountNonzeroRestartDelayAndRequestLevelRestartAtZero:
                tst.w   $3E(a0)
                beq.s   SKKnucklesRecovery_ReturnWhileRestartDelayHoldsOrRestartRequested
                subq.w  #1,$3E(a0)
                bne.s   SKKnucklesRecovery_ReturnWhileRestartDelayHoldsOrRestartRequested
                move.w  #1,(Restart_level_flag).w

SKKnucklesRecovery_ReturnWhileRestartDelayHoldsOrRestartRequested:
                rts
; ---------------------------------------------------------------------------

SKKnucklesRecovery_ResumeControlOnlyWhenBothPrimaryScrollAmountsAreZero:
                tst.w   (H_scroll_amount).w
                bne.s   SKKnucklesRecovery_AnimateAndDrawDuringScrollWaitOrAfterRelease
                tst.w   (V_scroll_amount).w
                bne.s   SKKnucklesRecovery_AnimateAndDrawDuringScrollWaitOrAfterRelease
                move.b  #2,routine(a0)

SKKnucklesRecovery_AnimateAndDrawDuringScrollWaitOrAfterRelease:
                bsr.w   AnimateKnucklesApplyGravityFlipAndQueuePatterns
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKKnucklesRecovery_EnterDebugBeforeDrowningMotionOrContinueDrowning:
                tst.w   (Debug_mode_flag).w
                beq.s   SKKnucklesRecovery_AdvanceDrowningWithOldVelocityAndTenHexGravity
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKKnucklesRecovery_AdvanceDrowningWithOldVelocityAndTenHexGravity
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKKnucklesRecovery_AdvanceDrowningWithOldVelocityAndTenHexGravity:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   AnimateKnucklesApplyGravityFlipAndQueuePatterns
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

AnimateKnucklesApplyGravityFlipAndQueuePatterns:
                bsr.s   Animate_Knuckles
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnucklesRecovery_TailNormalPatternLoaderAfterAnimationAndGravityMirror
                eori.b  #2,render_flags(a0)

SKKnucklesRecovery_TailNormalPatternLoaderAfterAnimationAndGravityMirror:
                bra.w   Knuckles_Load_PLC
; End of function AnimateKnucklesApplyGravityFlipAndQueuePatterns
