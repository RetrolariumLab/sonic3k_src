; Owner: objects/bosses/ssz/end_boss/sk
; Responsibility: Sky Sanctuary Mecha Sonic battle controller, coordinated attacks, player response and defeat progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSZEndBoss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SSZEndBoss_Index(pc,d0.w),d1
                jsr     SSZEndBoss_Index(pc,d1.w)
                lea     SSZMecha_BeginScoredDefeatScene(pc),a4
                bsr.w   SSZMecha_HandleHitFlashOrDefeat
                bsr.w   SSZMecha_TrySetCollisionFromFrame
                lea     DPLCPtr_MechaSonic(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
SSZEndBoss_Index:
                dc.w    SSZMechaBattle_InitializeSlottedActor-SSZEndBoss_Index
                dc.w    SSZMecha_WaitCameraAndBeginJump-SSZEndBoss_Index
                dc.w    SSZMecha_RollLeftUntilOffscreen-SSZEndBoss_Index
                dc.w    SSZMechaBattle_WaitArrivalDelay-SSZEndBoss_Index
                dc.w    SSZMecha_RunRightUntilBoundary-SSZEndBoss_Index
                dc.w    SSZMechaBattle_AnimateDuringRunEndDelay-SSZEndBoss_Index
                dc.w    SSZMecha_AnimateFallAndProbeFloor-SSZEndBoss_Index
                dc.w    SSZMechaBattle_RunRawCallbackAnimation-SSZEndBoss_Index
                dc.w    SSZMecha_DecelerateRollToBoundary-SSZEndBoss_Index
                dc.w    SSZMechaBattle_RunRawCallbackAnimation-SSZEndBoss_Index
                dc.w    SSZMechaBattle_RunRawCallbackAnimation-SSZEndBoss_Index
                dc.w    SSZMechaBattle_JumpUntilApexThenDash-SSZEndBoss_Index
                dc.w    SSZMechaBattle_MoveApexDashToBoundary-SSZEndBoss_Index
                dc.w    SSZMechaBattle_JumpUntilFloorThenBounce-SSZEndBoss_Index
                dc.w    SSZMechaBattle_MoveHighBounceToBoundary-SSZEndBoss_Index
                dc.w    SSZMechaBattle_JumpUntilFloorRollSetup-SSZEndBoss_Index
                dc.w    SSZMecha_AnimateFloorRollDelay-SSZEndBoss_Index
                dc.w    SSZMecha_MoveAndAnimateReverse-SSZEndBoss_Index
                dc.w    SSZMechaBattle_MoveFastRollToBoundary-SSZEndBoss_Index
                dc.w    SSZMecha_AnimateFloorRollDelay-SSZEndBoss_Index
                dc.w    SSZMechaBattle_RiseUntilRecoveryApex-SSZEndBoss_Index
; ---------------------------------------------------------------------------

SSZMechaBattle_InitializeSlottedActor:
                lea     ObjSlot_MechaSonic(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.b  #8,collision_property(a0)
                move.l  (V_int_run_count).w,(RNG_seed).w
                tst.b   (Current_act).w
                beq.s   SSZMecha_InitActOneRollingArrival
                move.w  #$220,x_pos(a0)
                move.w  #$4A0,y_pos(a0)
                bra.w   SSZMecha_QueueArtAndPreparePalette
; ---------------------------------------------------------------------------

SSZMecha_InitActOneRollingArrival:
                move.b  #4,routine(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #-$800,x_vel(a0)
                bset    #2,$38(a0)
                lea     SSZMecha_RollTrailFirstPairChildren(pc),a2
                jsr     (CreateChild6_Simple).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$20,d0
                move.w  d0,(_unkFAB4).w
                addi.w  #$100,d0
                move.w  d0,(_unkFAB6).w
                addi.w  #$40,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$30,d0
                move.w  d0,(_unkFAB0).w
                addi.w  #$70,d0
                move.w  d0,y_pos(a0)

SSZMecha_QueueArtAndPreparePalette:
                lea     (ArtKosM_MechaSonicExtra).l,a1
                move.w  #tiles_to_bytes(ArtTile_MechaSonicExtra),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_BossExplosion).l,a1
                jsr     (Load_PLC_Raw).l
                lea     (Pal_SSZGHZMisc).l,a1
                jsr     (PalLoad_Line1).l
                tst.b   (Current_act).w
                bne.s   SSZMecha_TryCollisionProxy
                jsr     (AllocateObject).l
                bne.s   SSZMecha_TryCollisionProxy
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

SSZMecha_TryCollisionProxy:
                lea     SSZMechaCollisionProxy_SimpleChildRecord(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (AllocateObject).l
; ---------------------------------------------------------------------------

SSZMecha_WaitCameraAndBeginJump:
                btst    #4,(_unkFAB8).w
                beq.w   SSZMechaBattleAndChildren_SharedReturn
                move.b  #$14,routine(a0)
                move.b  #2,$3B(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$20,d0
                move.w  d0,(_unkFAB4).w
                addi.w  #$100,d0
                move.w  d0,(_unkFAB6).w
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$30,d0
                move.w  d0,(_unkFAB0).w
                bra.w   SSZMechaBattle_PrepareCyclicJumpScript
; ---------------------------------------------------------------------------

SSZMecha_RollLeftUntilOffscreen:
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                subi.w  #$20,d0
                cmp.w   x_pos(a0),d0
                blo.s   SSZMecha_ArrivalUpdateReturn
                move.b  #6,routine(a0)
                bclr    #2,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #SSZMechaBattle_BeginRightwardReturnRun,$34(a0)

SSZMecha_ArrivalUpdateReturn:
                rts
; ---------------------------------------------------------------------------

SSZMechaBattle_WaitArrivalDelay:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SSZMechaBattle_BeginRightwardReturnRun:
                move.b  #8,routine(a0)
                bset    #0,render_flags(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$40,d0
                move.w  d0,y_pos(a0)
                move.w  #$400,x_vel(a0)
                move.b  #3,mapping_frame(a0)
                move.l  #SSZMecha_RollingFramesRawAnimation,$30(a0)

SSZMechaBattleAndChildren_SharedReturn:
                rts
; ---------------------------------------------------------------------------

SSZMecha_RunRightUntilBoundary:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                cmp.w   (_unkFAB6).w,d0
                bhs.s   SSZMechaBattle_BeginRunEndDelay
                rts
; ---------------------------------------------------------------------------

SSZMechaBattle_BeginRunEndDelay:
                move.b  #$A,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #SSZMecha_StopAndBeginDropAnim,$34(a0)
                rts
; ---------------------------------------------------------------------------

SSZMechaBattle_AnimateDuringRunEndDelay:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SSZMecha_StopAndBeginDropAnim:
                move.b  #$C,routine(a0)
                move.b  #$1F,y_radius(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #SSZMecha_LandAndChooseRecovery,$34(a0)
                jsr     (Random_Number).l
                tst.w   d0
                bmi.s   SSZMecha_BeginTurnAfterDrop
                bclr    #4,(_unkFAB8).w
                bne.s   SSZMecha_BeginTurnAfterDrop
                move.l  #SSZMecha_LandHoldFrame8Anim,$30(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

SSZMecha_BeginTurnAfterDrop:
                move.l  #SSZMecha_LandHoldFrame12Anim,$30(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

SSZMecha_AnimateFallAndProbeFloor:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite_LightGravity).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

SSZMecha_LandAndChooseRecovery:
                move.b  #$E,routine(a0)
                clr.w   $16(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                btst    #3,$38(a0)
                bne.s   SSZMecha_TurnAndPrepareJump
                move.l  #SSZMecha_LandThenDashAnim,$30(a0)
                move.l  #SSZMechaBattle_PrepareDeceleratingRoll,$34(a0)
                rts
; ---------------------------------------------------------------------------

SSZMecha_TurnAndPrepareJump:
                bchg    #0,render_flags(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #SSZMecha_AltLandThenJumpPrepAnim,$30(a0)
                move.l  #SSZMechaBattle_PrepareCyclicJumpScript,$34(a0)
                rts
; ---------------------------------------------------------------------------

SSZMechaBattle_RunRawCallbackAnimation:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SSZMechaBattle_PrepareDeceleratingRoll:
                move.b  #$10,routine(a0)
                move.w  #$820,d0
                move.w  #-$20,d1
                btst    #0,render_flags(a0)
                beq.s   SSZMecha_StoreRollSpeedAndTryTrails
                neg.w   d0
                neg.w   d1

SSZMecha_StoreRollSpeedAndTryTrails:
                move.w  d0,x_vel(a0)
                move.w  d1,$40(a0)
                clr.w   y_vel(a0)
                bset    #2,$38(a0)
                lea     SSZMecha_RollTrailSecondPairChildren(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

SSZMechaBattle_PrepareCyclicJumpScript:
                move.b  #$14,routine(a0)
                move.l  #SSZMecha_JumpAttackPrepAnim,$30(a0)
                move.l  #SSZMechaBattle_LaunchCyclicJump,$34(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                bset    #0,render_flags(a0)
                cmp.w   x_pos(a0),d0
                bhs.s   SSZMecha_JumpFacingReturn
                bclr    #0,render_flags(a0)

SSZMecha_JumpFacingReturn:
                rts
; ---------------------------------------------------------------------------

SSZMecha_DecelerateRollToBoundary:
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                lea     SSZMecha_EndRollAndPrepareJump(pc),a1
                bra.w   SSZMecha_CheckFacingArenaBound
; ---------------------------------------------------------------------------

SSZMecha_EndRollAndPrepareJump:
                move.b  #$12,routine(a0)
                move.w  d0,x_pos(a0)
                clr.w   $12(a0)
                bclr    #2,$38(a0)
                move.l  #SSZMecha_DashStopThenJumpPrepAnim,$30(a0)
                move.l  #SSZMechaBattle_PrepareCyclicJumpScript,$34(a0)
                rts
; ---------------------------------------------------------------------------

SSZMechaBattle_LaunchCyclicJump:
                move.b  #$F,y_radius(a0)
                lea     SSZMecha_JumpingAttackFlightRawAnimation(pc),a1
                jsr     (Set_Raw_Animation).l
                move.w  #$200,d0
                btst    #0,render_flags(a0)
                bne.s   SSZMecha_ChooseJumpVariant
                neg.w   d0

SSZMecha_ChooseJumpVariant:
                move.w  d0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                move.b  $3B(a0),d0
                addq.b  #1,$3B(a0)
                andi.w  #7,d0
                moveq   #0,d1
                move.b  SSZMechaBattle_CyclicJumpVariantOrder(pc,d0.w),d1
                move.b  d1,$3A(a0)
                move.b  SSZMechaBattle_JumpVariantRoutineValues(pc,d1.w),routine(a0)
                rts
; ---------------------------------------------------------------------------
SSZMechaBattle_CyclicJumpVariantOrder:
                dc.b    0,   1,   2,   0,   1,   2,   0,   1
SSZMechaBattle_JumpVariantRoutineValues:
                dc.b    $16, $1A, $1E
                even
; ---------------------------------------------------------------------------

SSZMechaBattle_JumpUntilApexThenDash:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bpl.s   SSZMechaBattle_PrepareApexDashDirection
                rts
; ---------------------------------------------------------------------------

SSZMechaBattle_PrepareApexDashDirection:
                move.b  #$18,routine(a0)
                move.w  #$780,d0
                moveq   #-$20,d1
                btst    #0,render_flags(a0)
                bne.s   SSZMechaBattle_StoreApexDashVelocity
                neg.w   d0
                neg.w   d1

SSZMechaBattle_StoreApexDashVelocity:
                move.w  d0,x_vel(a0)
                move.w  d1,$40(a0)
                clr.w   y_vel(a0)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SSZMechaBattle_MoveApexDashToBoundary:
                jsr     (Animate_RawMultiDelay).l
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                lea     SSZMecha_ClampApexDashAndWait(pc),a1
                bra.w   SSZMecha_CheckFacingArenaBound
; ---------------------------------------------------------------------------

SSZMecha_ClampApexDashAndWait:
                move.w  d0,x_pos(a0)
                bra.w   SSZMechaBattle_BeginRunEndDelay
; ---------------------------------------------------------------------------

SSZMechaBattle_JumpUntilFloorThenBounce:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   SSZMecha_BounceFloorReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   SSZMechaBattle_BounceUpAfterFloorContact
                beq.s   SSZMechaBattle_BounceUpAfterFloorContact

SSZMecha_BounceFloorReturn:
                rts
; ---------------------------------------------------------------------------

SSZMechaBattle_BounceUpAfterFloorContact:
                add.w   d1,y_pos(a0)
                move.b  #$1C,routine(a0)
                move.w  #-$900,y_vel(a0)
                moveq   #signextendB(sfx_Thump),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SSZMechaBattle_MoveHighBounceToBoundary:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite).l
                lea     SSZMechaBattle_BeginRunEndDelay(pc),a1
                bra.w   SSZMecha_CheckFacingArenaBound
; ---------------------------------------------------------------------------

SSZMechaBattle_JumpUntilFloorRollSetup:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   SSZMecha_FloorRollContactReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   SSZMechaBattle_LandAndBeginRollDelay
                beq.s   SSZMechaBattle_LandAndBeginRollDelay

SSZMecha_FloorRollContactReturn:
                rts
; ---------------------------------------------------------------------------

SSZMechaBattle_LandAndBeginRollDelay:
                add.w   d1,y_pos(a0)
                move.b  #$20,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #SSZMechaBattle_PrepareBriefReverseMotion,$34(a0)
                bset    #2,$38(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                lea     SSZMecha_RollTrailSingleChild(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   SSZMecha_FloorRollContactReturn
                move.b  #8,subtype(a1)
                rts
; ---------------------------------------------------------------------------

SSZMecha_AnimateFloorRollDelay:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SSZMechaBattle_PrepareBriefReverseMotion:
                move.b  #$22,routine(a0)
                move.w  #$100,d0
                tst.w   x_vel(a0)
                bmi.s   SSZMecha_BeginBriefReverse
                neg.w   d0

SSZMecha_BeginBriefReverse:
                move.w  d0,x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #SSZMecha_BeginOppositeFastRoll,$34(a0)
                rts
; ---------------------------------------------------------------------------

SSZMecha_MoveAndAnimateReverse:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SSZMecha_BeginOppositeFastRoll:
                move.b  #$24,routine(a0)
                move.w  #$640,d0
                move.w  #-$20,d1
                tst.w   x_vel(a0)
                bmi.s   SSZMecha_StoreFastRollMotion
                neg.w   d0
                neg.w   d1

SSZMecha_StoreFastRollMotion:
                move.w  d0,x_vel(a0)
                move.w  d1,$40(a0)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SSZMechaBattle_MoveFastRollToBoundary:
                jsr     (Animate_RawMultiDelay).l
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                lea     SSZMechaBattle_BeginPostRollJumpDelay(pc),a1
                bra.w   SSZMecha_CheckFacingArenaBound
; ---------------------------------------------------------------------------

SSZMechaBattle_BeginPostRollJumpDelay:
                move.b  #$26,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #SSZMechaBattle_LaunchVerticalRecovery,$34(a0)
                rts
; ---------------------------------------------------------------------------

SSZMechaBattle_LaunchVerticalRecovery:
                move.b  #$28,routine(a0)
                bclr    #2,$38(a0)
                clr.w   x_vel(a0)
                move.w  #-$640,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SSZMechaBattle_RiseUntilRecoveryApex:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bpl.w   SSZMechaBattle_BeginRunEndDelay
                rts
; ---------------------------------------------------------------------------

SSZMecha_DefeatDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SSZMechaPostBattle_StateOffsets(pc,d0.w),d1
                jsr     SSZMechaPostBattle_StateOffsets(pc,d1.w)
                lea     DPLCPtr_MechaSonic(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
SSZMechaPostBattle_StateOffsets:
                dc.w    SSZMecha_TickInitialDefeatDelay-SSZMechaPostBattle_StateOffsets
                dc.w    SSZMecha_FallAndProbeDefeatLanding-SSZMechaPostBattle_StateOffsets
                dc.w    SSZMecha_AnimateActOnePaletteHold-SSZMechaPostBattle_StateOffsets
                dc.w    SSZMecha_UnusedFallUntilOffscreen-SSZMechaPostBattle_StateOffsets
                dc.w    SSZMecha_AnimateUntilSuperSetup-SSZMechaPostBattle_StateOffsets
                dc.w    SSZMecha_WaitReleaseAndStartAnim-SSZMechaPostBattle_StateOffsets
                dc.w    SSZMecha_AnimateRelease-SSZMechaPostBattle_StateOffsets
                dc.w    SSZMecha_WaitWithSpinChargeSound-SSZMechaPostBattle_StateOffsets
                dc.w    SSZMecha_DashToBrakeThreshold-SSZMechaPostBattle_StateOffsets
                dc.w    SSZMechaPostBattle_BrakeMoveAndAnimate-SSZMechaPostBattle_StateOffsets
                dc.w    SSZMechaPostBattle_JumpUntilArenaLanding-SSZMechaPostBattle_StateOffsets
                dc.w    SSZMecha_AnimateAndSignalEmerald-SSZMechaPostBattle_StateOffsets
                dc.w    SSZMecha_ForceApproachAndStartBattle-SSZMechaPostBattle_StateOffsets
; ---------------------------------------------------------------------------

SSZMecha_TickInitialDefeatDelay:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SSZMechaPostBattle_BeginDefeatFall:
                move.b  #2,routine(a0)
                move.b  #$E,mapping_frame(a0)
                move.b  #$1F,y_radius(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.l  #SSZMecha_LandAndChooseActOutcome,$34(a0)
                rts
; ---------------------------------------------------------------------------

SSZMecha_FallAndProbeDefeatLanding:
                jsr     (MoveSprite_LightGravity).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

SSZMecha_LandAndChooseActOutcome:
                move.b  #$23,y_radius(a0)
                lea     SSZMecha_PostBattleSettlingRawAnimation(pc),a1
                jsr     (Set_Raw_Animation).l
                lea     (MechaSonic_IdleFlashPaletteScript).l,a1
                bsr.w   InstallSingleGlobalPaletteRotationScript
                lea     SSZMechaSparks_SimpleChildRecord(pc),a2
                jsr     (CreateChild6_Simple).l
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                tst.b   (Current_act).w
                bne.s   SSZMecha_ChooseSuperRoundOrDefeat
                move.b  #4,routine(a0)
                st      (_unkFAA8).w
                bset    #5,$38(a0)
                bclr    #3,$38(a0)
                move.w  #(2*60)-1,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   SSZMecha_ResultsSpawnReturn
                move.l  #SSZPostBossResultsGate_Initialize,(a1)

SSZMecha_ResultsSpawnReturn:
                rts
; ---------------------------------------------------------------------------

SSZMecha_ChooseSuperRoundOrDefeat:
                btst    #7,$38(a0)
                bne.s   SSZMechaPostBattle_BeginFinalDefeatDelay
                bset    #5,$38(a0)
                move.b  #8,routine(a0)
                move.w  #$BF,$2E(a0)
                move.l  #SSZMecha_BeginSuperRoundSignal,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                st      (Ctrl_2_locked).w
                rts
; ---------------------------------------------------------------------------

SSZMechaPostBattle_BeginFinalDefeatDelay:
                move.l  #SSZMechaFinalDefeat_HoldAndDraw,(a0)
                clr.b   (Update_HUD_timer).w
                move.w  #$BF,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   SSZMecha_TryFinalExplosionEmitters
                move.l  #SKLevel_InitializeScreenShakeRumbleActor,(a1)

SSZMecha_TryFinalExplosionEmitters:
                lea     SSZMecha_FinalExplosionEmitterChild(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

SSZMecha_AnimateActOnePaletteHold:
                jsr     (Run_PalRotationScript).l
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------
; unused
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.w   SSZMechaBattleAndChildren_SharedReturn
                beq.w   SSZMechaBattleAndChildren_SharedReturn
                move.b  #6,routine(a0)
                bset    #7,art_tile(a0)
                lea     (Pal_SSZGHZMisc).l,a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

SSZMecha_UnusedFallUntilOffscreen:
                tst.b   render_flags(a0)
                bpl.s   SSZMecha_DeleteUnusedFallingActor
                jmp     (MoveSprite).l
; ---------------------------------------------------------------------------

SSZMecha_DeleteUnusedFallingActor:
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

SSZMecha_AnimateUntilSuperSetup:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SSZMecha_BeginSuperRoundSignal:
                move.b  #$A,routine(a0)
                move.b  #1,(Update_HUD_timer).w
                clr.b   status(a0)
                clr.b   $38(a0)
                ori.b   #$50,$38(a0)
                moveq   #signextendB(mus_DDZ),d0
                jsr     (Play_Music).l
                lea     SSZMechaSignalEffect_NormalChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     (ArtKosM_EndingMasterEmerald).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_MasterEmerald),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

SSZMecha_WaitReleaseAndStartAnim:
                btst    #6,$38(a0)
                bne.s   SSZMecha_ChildReleaseReturn
                move.b  #$C,routine(a0)
                lea     SSZMecha_RecoverThenActAnim(pc),a1
                jsr     (Set_Raw_Animation).l
                move.b  #$E,mapping_frame(a0)
                move.l  #SSZMecha_BeginSpinCharge,$34(a0)

SSZMecha_ChildReleaseReturn:
                rts
; ---------------------------------------------------------------------------

SSZMecha_AnimateRelease:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SSZMecha_BeginSpinCharge:
                move.b  #$E,routine(a0)
                move.w  #$3B,$2E(a0)
                bset    #2,$38(a0)
                lea     SSZMecha_RollTrailSecondPairChildren(pc),a2
                btst    #0,render_flags(a0)
                beq.s   SSZMecha_TrySpinChargeTrails
                lea     SSZMecha_RollTrailFirstPairChildren(pc),a2

SSZMecha_TrySpinChargeTrails:
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

SSZMecha_WaitWithSpinChargeSound:
                moveq   #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX_Continuous).l
                subq.w  #1,$2E(a0)
                bmi.s   SSZMecha_BeginDashAndOpenCamera
                rts
; ---------------------------------------------------------------------------

SSZMecha_BeginDashAndOpenCamera:
                move.b  #$10,routine(a0)
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                lea     (Player_1).w,a1
                jsr     (Stop_Object).l
                move.w  (Camera_max_X_pos).w,d0
                addi.w  #$140,d0
                move.w  d0,(Camera_max_X_pos).w
                addi.w  #$100,d0
                move.w  d0,(_unkFAB6).w
                move.w  #$600,x_vel(a0)
                clr.w   y_vel(a0)
                jsr     (AllocateObject).l
                bne.s   SSZMecha_TryCameraAdvanceActor
                move.l  #SSZKnuxMecha_InitEmeraldAndPalette,(a1)
                move.w  a1,$44(a0)

SSZMecha_TryCameraAdvanceActor:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SSZMecha_CameraAdvanceSpawnReturn
                move.l  #SSZMecha_InitCameraScrollLock,(a1)

SSZMecha_CameraAdvanceSpawnReturn:
                rts
; ---------------------------------------------------------------------------

SSZMecha_DashToBrakeThreshold:
                jsr     (MoveSprite2).l
                move.w  (_unkFAB6).w,d0
                subi.w  #$AA,d0
                cmp.w   x_pos(a0),d0
                bls.s   SSZMecha_BeginBrakingAnimation
                rts
; ---------------------------------------------------------------------------

SSZMecha_BeginBrakingAnimation:
                move.b  #$12,routine(a0)
                move.l  #SSZMecha_JumpTowardSuperArena,$34(a0)
                lea     SSZMecha_PreJumpCallbackRawAnimation(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZMechaPostBattle_BrakeMoveAndAnimate:
                addi.w  #-$30,x_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SSZMecha_JumpTowardSuperArena:
                move.b  #$14,routine(a0)
                bclr    #2,$38(a0)
                move.w  #-$400,y_vel(a0)
                move.b  #$4B,y_radius(a0)
                move.l  #SSZMecha_SetSuperArenaAndLanding,$34(a0)
                lea     SSZMecha_TransformReturnHoldFrame8(pc),a1
                btst    #0,render_flags(a0)
                beq.s   SSZMecha_InstallJumpAnimation
                lea     SSZMecha_PostBattleJumpFlipRawAnimation(pc),a1

SSZMecha_InstallJumpAnimation:
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZMechaPostBattle_JumpUntilArenaLanding:
                jsr     (Animate_RawMultiDelayFlipX).l
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.w   SSZMechaBattleAndChildren_SharedReturn
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

SSZMecha_SetSuperArenaAndLanding:
                move.w  (Camera_min_X_pos).w,d0
                addi.w  #$A0,d0
                move.w  d0,(Camera_min_X_pos).w
                addi.w  #$10,d0
                move.w  d0,(_unkFA82).w
                addi.w  #$50,d0
                move.w  d0,(_unkFA84).w
                addi.w  #$50,d0
                move.w  d0,(_unkFA86).w
                addi.w  #$40,d0
                move.w  d0,(_unkFA88).w
                addi.w  #$40,d0
                move.w  d0,(_unkFA8A).w
                addi.w  #$50,d0
                move.w  d0,(_unkFA8C).w
                addi.w  #$50,d0
                move.w  d0,(_unkFA8E).w
                move.b  #$16,routine(a0)
                move.l  #SSZMecha_PrepareForcedApproach,$34(a0)
                lea     SSZMecha_TransformLandingAnim(pc),a1
                jsr     (Set_Raw_Animation).l

SSZMecha_BeginTransformPaletteAndSparks:
                clr.b   $38(a0)
                bset    #7,$38(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                lea     (MechaSonic_TransformFlashPaletteScript).l,a1
                bsr.w   InstallSingleGlobalPaletteRotationScript
                lea     SSZMechaSparks_SimpleChildRecord(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   SSZMecha_TransformSparkSpawnReturn
                move.b  #8,subtype(a1)

SSZMecha_TransformSparkSpawnReturn:
                rts
; ---------------------------------------------------------------------------

; Toggle the emerald frame bit on every transformation update
SSZMecha_AnimateAndSignalEmerald:
                moveq   #signextendB(sfx_MechaTransform),d0
                jsr     (Play_SFX_Continuous).l
                jsr     (Run_PalRotationScript).l
                bchg    #6,(_unkFAB8).w
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SSZMecha_PrepareForcedApproach:
                move.b  #$18,routine(a0)
                lea     (Player_1).w,a1
                clr.b   status(a1)
                clr.b   spin_dash_flag(a1)
                move.w  #$782,spin_dash_counter(a1)
                rts
; ---------------------------------------------------------------------------

SSZMecha_ForceApproachAndStartBattle:
                jsr     (Run_PalRotationScript).l
                bchg    #6,(_unkFAB8).w
                move.w  #(button_right_mask<<8)|button_right_mask,(Ctrl_1_logical).w
                lea     (Player_1).w,a1
                move.w  x_pos(a1),d0
                move.w  (_unkFA8A).w,d1
                addi.w  #$10,d1
                cmp.w   d1,d0
                blo.w   SSZMechaBattleAndChildren_SharedReturn
                clr.b   (Scroll_lock).w
                clr.w   (H_scroll_frame_offset).w
                clr.w   (Ctrl_1_logical).w
                clr.b   (Ctrl_1_locked).w
                bsr.w   SSZScene_ClearP1Velocities
                move.l  #Obj_SSZ2_Boss,(a0)
                move.b  #8,collision_property(a0)
                move.b  #$23,collision_flags(a0)
                bra.w   SSZKnucklesMecha_BeginRisePreparation
; ---------------------------------------------------------------------------

SSZMechaFinalDefeat_HoldAndDraw:
                subq.w  #1,$2E(a0)
                bmi.s   SSZMecha_BeginFinalFadeAndDebris
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZMecha_BeginFinalFadeAndDebris:
                move.l  #Obj_Wait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #SSZMecha_BeginWhiteFadeAndSound,$34(a0)
                bclr    #7,render_flags(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                addi.w  #$20,y_pos(a0)
                lea     SSZMecha_DefeatFragmentChild(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

SSZMecha_BeginWhiteFadeAndSound:
                move.l  #SSZMecha_WaitWhiteFadeThenSave,(a0)
                bset    #5,$38(a0)
                clr.w   $3A(a0)
                move.b  #4,$39(a0)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($80),d6

SSZMecha_SavePaletteAndTryWhiteFade:
                move.l  (a1)+,(a2)+
                dbf     d6,SSZMecha_SavePaletteAndTryWhiteFade
                jsr     (AllocateObject).l
                bne.s   SSZMecha_WhiteFadeSpawnReturn
                move.w  a1,$44(a0)
                move.l  #SKPalEffect_InitWhiteAndLockRotation,(a1)
                move.w  #7,$3A(a1)

SSZMecha_WhiteFadeSpawnReturn:
                rts
; ---------------------------------------------------------------------------

SSZMecha_WaitWhiteFadeThenSave:
                bsr.w   TickSSZPostBossExplosionSoundBurst
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.w   SSZMechaBattleAndChildren_SharedReturn
                move.l  #SSZMecha_WaitAndTryKnucklesEnding,(a0)
                move.w  #(2*60)-1,$2E(a0)
                st      (_unkFAA2).w
                st      (Events_fg_4+1).w
                lea     (Player_1).w,a1
                move.b  #$83,object_control(a1)
                clr.b   mapping_frame(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                st      (SRAM_mask_interrupts_flag).w
                jmp     (SaveGame).l
; ---------------------------------------------------------------------------

SSZMecha_WaitAndTryKnucklesEnding:
                bsr.w   TickSSZPostBossExplosionSoundBurst
                subq.w  #1,$2E(a0)
                bpl.w   SSZMechaBattleAndChildren_SharedReturn
                move.w  #3,(Player_mode).w
                jsr     (AllocateObject).l
                bne.s   SSZMecha_TryPaletteRestore
                move.l  #EndPlane_DispatchKnuxPlaneAndDraw,(a1)

SSZMecha_TryPaletteRestore:
                jsr     (AllocateObject).l
                bne.s   SSZMecha_DeleteAfterEndingSetup
                move.l  #SKPalEffect_InitTargetPasses,(a1)

SSZMecha_DeleteAfterEndingSetup:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

TickSSZPostBossExplosionSoundBurst:
                subq.w  #1,$3A(a0)
                bpl.s   SSZMechaExplosionSoundBurst_Return
                move.w  #$1F,$3A(a0)
                subq.b  #1,$39(a0)
                bmi.s   SSZMechaExplosionSoundBurst_Return
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l

SSZMechaExplosionSoundBurst_Return:
                rts
; End of function TickSSZPostBossExplosionSoundBurst
