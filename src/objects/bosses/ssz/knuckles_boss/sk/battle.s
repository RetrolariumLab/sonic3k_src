; Owner: objects/bosses/ssz/knuckles_boss/sk
; Responsibility: Knuckles Sky Sanctuary Mecha Sonic battle controller, super phase, attacks and coordinated progression
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SSZ2_Boss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SSZ2_Boss_Index(pc,d0.w),d1
                jsr     SSZ2_Boss_Index(pc,d1.w)
                lea     SSZMecha_FreezeCameraAndRestorePal(pc),a4
                bsr.w   SSZMecha_HandleHitFlashOrDefeat
                bsr.w   SSZMecha_TrySetCollisionFromFrame
                lea     DPLCPtr_MechaSonic(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
SSZ2_Boss_Index:
                dc.w    SSZKnucklesMecha_UpdateTransformation-SSZ2_Boss_Index
                dc.w    SSZKnucklesMecha_UpdateTransformation-SSZ2_Boss_Index
                dc.w    SSZKnucklesMecha_RiseToSavedHeight-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_AnimateTransformation-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_RunPaletteAndWaitAttack-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_AccelerateDashToSpeed-SSZ2_Boss_Index
                dc.w    SSZKnucklesMecha_CruiseTowardDashTarget-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_BrakeAndCheckCrossing-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_RunPaletteAndWaitDash-SSZ2_Boss_Index
                dc.w    SSZKnucklesMecha_RotateAnimateAndWait-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_MoveDiveAndProbeFloor-SSZ2_Boss_Index
                dc.w    SSZKnucklesMecha_RotateAnimateAndWait-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_RiseToSavedDiveHeight-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_AnimateReturnAndPalette-SSZ2_Boss_Index
                dc.w    SSZKnucklesMecha_AccelerateDiagonalDive-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_MoveDiveAndProbeFloor-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_BrakeDiveAndProbeFloor-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_BrakeDiveHorizontally-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_AnimateJumpPrepAndPalette-SSZ2_Boss_Index
                dc.w    SSZKnucklesMecha_UpdateHighReturnJump-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_EnterHoverWithGravity-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_HoverFaceAndWait-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_HoverFaceAndWait-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_FallToFloorWithGravity-SSZ2_Boss_Index
                dc.w    SSZKnucklesMecha_AnimateNormalLanding-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_UpdateFloorRoll-SSZ2_Boss_Index
                dc.w    SSZKnucklesMecha_RollUntilTargetCrossing-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_UpdateSmallJump-SSZ2_Boss_Index
                dc.w    SSZKnucklesMecha_AnimateSmallJumpLanding-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_UpdateTransformReturnJump-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_HoverTrackUntilBurst-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_AnimateHoverFacingTurn-SSZ2_Boss_Index
                dc.w    SSZKnucklesMecha_RunPaletteOnlyShift-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_FallToReturnPaletteGate-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_RunPaletteAndUpdateDamage-SSZ2_Boss_Index
                dc.w    SSZKnuxMecha_AnimateAndEmitRadialBurst-SSZ2_Boss_Index
; ---------------------------------------------------------------------------

SSZKnucklesMecha_UpdateTransformation:
                moveq   #signextendB(sfx_MechaTransform),d0
                jsr     (Play_SFX_Continuous).l
                jsr     (Run_PalRotationScript).l
                bchg    #6,(SceneSyncFlagsOrMHZState).w
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SSZKnucklesMecha_BeginRisePreparation:
                move.b  #2,routine(a0)
                bset    #6,$38(a0)
                move.l  #SSZKnucklesMecha_LaunchRise,$34(a0)
                lea     SSZMecha_PrepareRiseAnim(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZKnucklesMecha_LaunchRise:
                move.b  #4,routine(a0)
                clr.w   x_vel(a0)
                move.w  #-$480,y_vel(a0)
                bclr    #6,(SceneSyncFlagsOrMHZState).w
                rts
; ---------------------------------------------------------------------------

SSZKnucklesMecha_RiseToSavedHeight:
                jsr     (Run_PalRotationScript).l
                jsr     (MoveSprite_LightGravity).l
                move.w  (SceneMinimumYOrEmeraldSelectionBytes).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   SSZKnuxMecha_ClampRiseAndTransform
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_ClampRiseAndTransform:
                move.w  d0,y_pos(a0)
                move.b  #6,routine(a0)
                move.l  #SSZKnuxMecha_BeginSuperPaletteDelay,$34(a0)
                lea     SSZMecha_RiseThenTransformAnim(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_AnimateTransformation:
                jsr     (Run_PalRotationScript).l
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_BeginSuperPaletteDelay:
                move.b  #8,routine(a0)
                clr.b   $39(a0)
                bclr    #1,$38(a0)
                lea     MechaSonic_EnterSuperPaletteScript(pc),a1
                bsr.w   InstallSingleGlobalPaletteRotationScript
                move.w  #$3F,$2E(a0)
                move.l  #SSZKnuxMecha_ChooseAttackByHealth,$34(a0)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($80),d6

SSZKnuxMecha_SavePaletteAndTryFlash:
                move.l  (a1)+,(a2)+
                dbf     d6,SSZKnuxMecha_SavePaletteAndTryFlash
                jsr     (AllocateObject).l
                bne.s   SSZKnucklesMecha_PlaySuperTransformSound
                move.l  #SSZMecha_InitTransformFlash,(a1)

SSZKnucklesMecha_PlaySuperTransformSound:
                moveq   #signextendB(sfx_SuperTransform),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_RunPaletteAndWaitAttack:
                jsr     (Run_PalRotationScript).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_ChooseAttackByHealth:
                cmpi.b  #2,collision_property(a0)
                bls.s   SSZKnucklesMecha_ChooseLowHitpointHover

SSZKnuxMecha_ChooseOppositeDashEdge:
                move.w  x_pos(a0),d0
                move.w  (SceneTimerOrSharedMotionRecordBase).w,d1
                bclr    #0,render_flags(a0)
                cmp.w   (EndingOutcomeOrBossSceneSignals).w,d0
                bhs.s   SSZKnucklesMecha_StoreDashTarget
                move.w  (DdzFlightControllerOrLowerMotionPlanX).w,d1
                bset    #0,render_flags(a0)

SSZKnucklesMecha_StoreDashTarget:
                move.w  d1,$3C(a0)

SSZKnucklesMecha_BeginAcceleratingDash:
                move.b  #$A,routine(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$80,d0
                btst    #0,render_flags(a0)
                bne.s   SSZKnuxMecha_BeginDashAnimAndEffect
                neg.w   d0

SSZKnuxMecha_BeginDashAnimAndEffect:
                move.w  d0,$40(a0)
                lea     SSZMecha_AccelerateAttackAnim(pc),a1
                jsr     (Set_Raw_Animation).l
                bset    #6,$38(a0)
                lea     SSZMechaActiveEffect_NormalChildRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SSZKnucklesMecha_ChooseLowHitpointHover:
                move.b  #$3C,routine(a0)
                move.b  #8,mapping_frame(a0)
                move.w  #$80,$2E(a0)
                move.b  #5,$39(a0)
                bra.w   SSZKnuxMecha_InitHoverLaserTiming
; ---------------------------------------------------------------------------

SSZKnuxMecha_AccelerateDashToSpeed:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                move.w  x_vel(a0),d0
                add.w   $40(a0),d0
                move.w  d0,x_vel(a0)
                cmpi.w  #-$800,d0
                ble.s   SSZKnucklesMecha_SelectDashCruiseState
                cmpi.w  #$800,d0
                bge.s   SSZKnucklesMecha_SelectDashCruiseState
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

SSZKnucklesMecha_SelectDashCruiseState:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

SSZKnucklesMecha_CruiseTowardDashTarget:
                jsr     (Run_PalRotationScript).l
                jsr     (MoveSprite2).l
                tst.w   x_vel(a0)
                bmi.s   SSZKnuxMecha_CheckLeftDashTarget
                move.w  $3C(a0),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$38,d0
                blo.s   SSZKnucklesMecha_BeginDashBraking
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_CheckLeftDashTarget:
                move.w  x_pos(a0),d0
                sub.w   $3C(a0),d0
                cmpi.w  #$38,d0
                blo.s   SSZKnucklesMecha_BeginDashBraking
                rts
; ---------------------------------------------------------------------------

SSZKnucklesMecha_BeginDashBraking:
                move.b  #$E,routine(a0)
                neg.w   $40(a0)
                lea     SSZMecha_DashBrakeCrossStreamAnim(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_BrakeAndCheckCrossing:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelayFlipX).l
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                move.w  $3C(a0),d0
                tst.w   x_vel(a0)
                bmi.s   SSZKnuxMecha_CheckLeftBrakeTarget
                cmp.w   x_pos(a0),d0
                bls.s   SSZKnuxMecha_FinishDashAndSetWait
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_CheckLeftBrakeTarget:
                cmp.w   x_pos(a0),d0
                bhs.s   SSZKnuxMecha_FinishDashAndSetWait
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_FinishDashAndSetWait:
                move.b  #$10,routine(a0)
                bclr    #6,$38(a0)
                btst    #1,$38(a0)
                bne.s   SSZKnuxMecha_WaitBeforeRegionAttack
                move.w  #7,$2E(a0)
                move.b  $39(a0),d0
                addq.b  #1,d0
                move.b  d0,$39(a0)
                cmpi.b  #2,d0
                bhs.s   SSZKnuxMecha_ClassifyPlayerForDash

SSZKnuxMecha_RepeatOppositeDash:
                move.l  #SSZKnuxMecha_ChooseOppositeDashEdge,$34(a0)
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_WaitBeforeRegionAttack:
                move.w  #$1F,$2E(a0)
                move.l  #SSZKnuxMecha_ChooseRegionDiveOrAttack,$34(a0)
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_ClassifyPlayerForDash:
                bsr.w   SSZMecha_ClassifyPlayerXRegion
                move.b  d2,child_dy(a0)
                move.w  x_pos(a0),d0
                cmp.w   (EndingOutcomeOrBossSceneSignals).w,d0
                blo.s   SSZKnuxMecha_ChooseRegionDashTarget
                not.b   d3

SSZKnuxMecha_ChooseRegionDashTarget:
                tst.b   d3
                bne.s   SSZKnuxMecha_RepeatOppositeDash
                bset    #1,$38(a0)
                move.l  #SSZKnucklesMecha_BeginAcceleratingDash,$34(a0)
                move.b  SSZKnuxMecha_AttackIndicesByRegion-1(pc,d2.w),child_dx(a0)
                add.w   d2,d2
                movea.w SSZKnuxMecha_TargetPointersByRegion-2(pc,d2.w),a1
                move.w  (a1),$3C(a0)
                rts
; ---------------------------------------------------------------------------
SSZKnuxMecha_AttackIndicesByRegion:
                dc.b    4,   5,   6,   1,   2,   3
                even
SSZKnuxMecha_TargetPointersByRegion:
                dc.w    DDZScrollAccelOrSceneMotion, SceneMotionAngleOrDDZAccelLo, DdzFlightControllerOrLowerMotionPlanX
                dc.w    SceneTimerOrSharedMotionRecordBase, SceneCreditIndexOrBossMotionPlanAngle, SceneCreditStateOrBossMotionPlanX
; ---------------------------------------------------------------------------

SSZKnuxMecha_RunPaletteAndWaitDash:
                jsr     (Run_PalRotationScript).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_ChooseRegionDiveOrAttack:
                bsr.w   SSZMecha_TestPlayerAttackRegion
                beq.s   SSZKnucklesMecha_ChooseRandomDiveOrHover
                move.b  #$12,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #SSZKnuxMecha_BeginTargetedDive,$34(a0)
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                lea     (Player_1).w,a1
                moveq   #0,d0
                move.w  x_pos(a1),d0
                moveq   #0,d1
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$B0,d1
                moveq   #3,d5
                jsr     (SetVelocityTowardPointByDominantAxis).l
                lea     SSZMecha_TargetedDiveAnim(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZKnucklesMecha_ChooseRandomDiveOrHover:
                jsr     (Random_Number).l
                andi.b  #3,d0
                bne.s   SSZKnuxMecha_BeginHoverEntryAnim
                move.b  #$1C,routine(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  x_pos(a0),d0
                move.w  #-$80,d1
                cmp.w   (EndingOutcomeOrBossSceneSignals).w,d0
                bhs.s   SSZKnuxMecha_BeginAcceleratingDiveFx
                neg.w   d1

SSZKnuxMecha_BeginAcceleratingDiveFx:
                move.w  d1,$40(a0)
                moveq   #signextendB(sfx_MissileShoot),d0
                jsr     (Play_SFX).l
                lea     SSZMecha_AccelerateAttackAnim(pc),a1
                jsr     (Set_Raw_Animation).l
                bset    #6,$38(a0)
                lea     SSZMechaActiveEffect_NormalChildRecord(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

SSZKnuxMecha_BeginHoverEntryAnim:
                move.b  #$28,routine(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                lea     SSZKnucklesMecha_HoverEntryRawAnimation(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZKnucklesMecha_RotateAnimateAndWait:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_BeginTargetedDive:
                move.b  #$14,routine(a0)
                move.b  #$13,y_radius(a0)
                move.l  #SSZKnuxMecha_BeginDiveImpactPause,$34(a0)
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_MoveDiveAndProbeFloor:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_BeginDiveImpactPause:
                move.b  #$16,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #SSZKnuxMecha_BeginVerticalDiveReturn,$34(a0)
                moveq   #signextendB(sfx_Crash),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_BeginVerticalDiveReturn:
                move.b  #$18,routine(a0)
                clr.w   x_vel(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_RiseToSavedDiveHeight:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite2).l
                move.w  (SceneMinimumYOrEmeraldSelectionBytes).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   SSZKnuxMecha_ChooseFacingReturnAnim
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_ChooseFacingReturnAnim:
                move.b  #$1A,routine(a0)
                move.l  #SSZKnuxMecha_ResetDashAndChooseEdge,$34(a0)
                move.w  x_pos(a0),d0
                bclr    #0,render_flags(a0)
                cmp.w   (EndingOutcomeOrBossSceneSignals).w,d0
                bhs.s   SSZKnucklesMecha_InstallReturnAnimation
                bset    #0,render_flags(a0)

SSZKnucklesMecha_InstallReturnAnimation:
                lea     SSZMecha_DiveReturnAnim(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_AnimateReturnAndPalette:
                jsr     (Run_PalRotationScript).l
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_ResetDashAndChooseEdge:
                clr.b   $39(a0)
                bclr    #1,$38(a0)
                bra.w   SSZKnuxMecha_ChooseOppositeDashEdge
; ---------------------------------------------------------------------------

SSZKnucklesMecha_AccelerateDiagonalDive:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                move.w  y_vel(a0),d0
                addi.w  #$80,d0
                move.w  d0,y_vel(a0)
                cmpi.w  #$800,d0
                blo.s   SSZKnuxMecha_MoveAcceleratingDive
                move.b  #$1E,routine(a0)
                move.b  #$57,y_radius(a0)
                move.l  #SSZKnuxMecha_BeginDiveYBraking,$34(a0)

SSZKnuxMecha_MoveAcceleratingDive:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_BeginDiveYBraking:
                move.b  #$20,routine(a0)
                move.b  #$1F,y_radius(a0)
                move.l  #SSZKnuxMecha_BeginDiveXBraking,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_BrakeDiveAndProbeFloor:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                move.w  y_vel(a0),d0
                addi.w  #-$80,d0
                move.w  d0,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_BeginDiveXBraking:
                move.b  #$22,routine(a0)
                move.w  $40(a0),d0
                neg.w   d0
                asr.w   #1,d0
                move.w  d0,$40(a0)
                clr.w   y_vel(a0)
                move.l  #SSZKnuxMecha_BeginDiveReturnJumpPrep,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                lea     SSZMecha_DiagonalDiveBrakeAnim(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_BrakeDiveHorizontally:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_BeginDiveReturnJumpPrep:
                move.b  #$24,routine(a0)
                bclr    #6,$38(a0)
                move.l  #SSZKnucklesMecha_LaunchHighReturnJump,$34(a0)
                lea     SSZMecha_DiagonalReturnJumpPrepAnim(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_AnimateJumpPrepAndPalette:
                jsr     (Run_PalRotationScript).l
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SSZKnucklesMecha_LaunchHighReturnJump:
                move.b  #$26,routine(a0)
                clr.w   x_vel(a0)
                move.w  #-$600,y_vel(a0)
                lea     SSZMecha_HighReturnJumpFlipAnim(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZKnucklesMecha_UpdateHighReturnJump:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelayFlipX).l
                jsr     (MoveSprite_LightGravity).l
                move.w  (SceneMinimumYOrEmeraldSelectionBytes).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   SSZKnuxMecha_ClampReturnJumpAndReset
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_ClampReturnJumpAndReset:
                move.w  d0,y_pos(a0)
                bra.w   SSZKnuxMecha_ResetDashAndChooseEdge
; ---------------------------------------------------------------------------

SSZKnuxMecha_EnterHoverWithGravity:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelayFlipX).l
                moveq   #$10,d1
                jsr     (MoveSprite_CustomGravity).l
                cmpi.w  #$100,y_vel(a0)
                bhs.s   SSZKnucklesMecha_SelectHoverLaserState
                rts
; ---------------------------------------------------------------------------

SSZKnucklesMecha_SelectHoverLaserState:
                move.b  #$2A,routine(a0)

SSZKnuxMecha_InitHoverLaserTiming:
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                move.b  #3,$39(a0)
                move.w  #$1F,$2E(a0)
                move.l  #SSZKnuxMecha_TryLaserAndCountVolleys,$34(a0)
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_HoverFaceAndWait:
                jsr     (Run_PalRotationScript).l
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Find_SonicTails).l
                jsr     (Change_FlipX).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_TryLaserAndCountVolleys:
                move.w  #$2F,$2E(a0)
                lea     SSZMechaLaser_NormalChildRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                subq.b  #1,$39(a0)
                bpl.w   SSZMechaBattleAndChildren_SharedReturn
                move.b  #8,subtype(a1)
                move.b  #$2C,routine(a0)
                move.l  #SSZKnuxMecha_BeginPaletteRevertAndFall,$34(a0)
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_BeginPaletteRevertAndFall:
                move.b  #$2E,routine(a0)
                move.b  #$1F,y_radius(a0)
                move.l  #SSZKnuxMecha_BeginNormalLandingAnim,$34(a0)
                bclr    #7,$38(a0)
                lea     (MechaSonic_ReturnToMainPaletteScript).l,a1
                bsr.w   InstallSingleGlobalPaletteRotationScript
                lea     SSZMecha_PaletteReturnFallAnim(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_FallToFloorWithGravity:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_BeginNormalLandingAnim:
                move.b  #$30,routine(a0)
                move.l  #SSZKnuxMecha_BeginFloorRoll,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                lea     SSZMecha_NormalLandingAnim(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZKnucklesMecha_AnimateNormalLanding:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_BeginFloorRoll:
                move.b  #$32,routine(a0)
                clr.b   y_vel(a0)
                move.b  #$13,y_radius(a0)
                move.l  #SSZKnuxMecha_AimRollAtArenaTarget,$34(a0)
                move.l  #SSZMecha_RollingEntryAnim,$30(a0)
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_UpdateFloorRoll:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite_LightGravity).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_AimRollAtArenaTarget:
                move.b  #$34,routine(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                bset    #0,render_flags(a0)
                move.w  #$400,d0
                move.w  x_pos(a0),d1
                cmp.w   (SceneMaximumXOrEmeraldSelectionTail).w,d1
                blo.s   SSZKnucklesMecha_StoreRollingVelocity
                bclr    #0,render_flags(a0)
                neg.w   d0

SSZKnucklesMecha_StoreRollingVelocity:
                move.w  d0,x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SSZKnucklesMecha_RollUntilTargetCrossing:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite2).l
                move.w  (SceneMaximumXOrEmeraldSelectionTail).w,d0
                tst.w   x_vel(a0)
                bmi.s   SSZKnucklesMecha_TestLeftwardRollTarget
                cmp.w   x_pos(a0),d0
                bls.s   SSZKnuxMecha_ClampRollAndJump
                rts
; ---------------------------------------------------------------------------

SSZKnucklesMecha_TestLeftwardRollTarget:
                cmp.w   x_pos(a0),d0
                bhs.s   SSZKnuxMecha_ClampRollAndJump
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_ClampRollAndJump:
                move.w  d0,x_pos(a0)
                move.b  #$36,routine(a0)
                move.b  #$1F,y_radius(a0)
                clr.w   x_vel(a0)
                move.w  #-$200,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

; Advance to landing when the signed floor distance is nonnegative
SSZKnuxMecha_UpdateSmallJump:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SSZKnuxMecha_ApplyFloorDistanceAndLand
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_ApplyFloorDistanceAndLand:
                add.w   d1,y_pos(a0)
                move.b  #$38,routine(a0)
                move.l  #SSZKnuxMecha_BeginTransformReturnJump,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                lea     SSZMecha_SmallJumpLandingAnim(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZKnucklesMecha_AnimateSmallJumpLanding:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_BeginTransformReturnJump:
                move.b  #$3A,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.b  #$4B,y_radius(a0)
                move.l  #SSZKnuxMecha_LandAndRestartTransform,$34(a0)
                bclr    #0,render_flags(a0)
                bne.s   SSZKnuxMecha_ChooseFlippedReturnAnim
                move.l  #SSZMecha_TransformReturnHoldFrame8,$30(a0)
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_ChooseFlippedReturnAnim:
                move.b  #$C,mapping_frame(a0)
                move.l  #SSZMecha_AltTransformReturnJumpAnim,$30(a0)
                rts
; ---------------------------------------------------------------------------

SSZKnuxMecha_UpdateTransformReturnJump:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.w   SSZMechaBattleAndChildren_SharedReturn
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_LandAndRestartTransform:
                move.b  #0,routine(a0)
                move.l  #SSZKnucklesMecha_BeginRisePreparation,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                lea     SSZMecha_RestartTransformLandingAnim(pc),a1
                jsr     Set_Raw_Animation(pc)
                bra.w   SSZMecha_BeginTransformPaletteAndSparks
; ---------------------------------------------------------------------------

SSZKnuxMecha_HoverTrackUntilBurst:
                jsr     (Run_PalRotationScript).l
                subq.w  #1,$2E(a0)
                bmi.s   SSZKnuxMecha_BeginRadialBurstAnim
                jsr     (Swing_UpAndDown_Count).l
                bne.s   SSZKnucklesMecha_BeginHoverPaletteShift
                jsr     (MoveSprite2).l
                jsr     (Find_SonicTails).l
                move.w  #-$100,d1
                btst    #0,render_flags(a0)
                beq.s   SSZKnuxMecha_ChooseFacingHoverDrift
                subq.w  #2,d0
                neg.w   d1

SSZKnuxMecha_ChooseFacingHoverDrift:
                tst.w   d0
                bne.s   SSZKnucklesMecha_BeginHoverFacingTurn
                move.w  d1,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

SSZKnucklesMecha_BeginHoverFacingTurn:
                move.b  #$3E,routine(a0)
                move.l  #SSZKnuxMecha_ResumeHoverAfterTurn,$34(a0)
                lea     SSZMecha_HoverTurnAnim(pc),a1
                jmp     Set_Raw_Animation(pc)
; ---------------------------------------------------------------------------

SSZKnucklesMecha_BeginHoverPaletteShift:
                move.b  #$40,routine(a0)
                bclr    #7,$38(a0)
                move.w  #$100,d0
                btst    #0,render_flags(a0)
                bne.s   SSZKnuxMecha_InstallHoverPaletteShift
                neg.w   d0

SSZKnuxMecha_InstallHoverPaletteShift:
                move.w  d0,x_vel(a0)
                move.l  #SSZKnuxMecha_FallAfterPaletteShift,(Palette_rotation_custom).w
                lea     (SSZMecha_HoverShiftPaletteScript).l,a1
                bra.w   InstallSingleGlobalPaletteRotationScript
; ---------------------------------------------------------------------------

SSZKnuxMecha_BeginRadialBurstAnim:
                move.b  #$46,routine(a0)
                move.l  #SSZKnuxMecha_ResumeHoverAfterBurst,$34(a0)
                lea     SSZMecha_RadialBurstAnim(pc),a1
                jmp     Set_Raw_Animation(pc)
; ---------------------------------------------------------------------------

SSZKnuxMecha_AnimateHoverFacingTurn:
                jsr     (Run_PalRotationScript).l
                jsr     Animate_RawMultiDelayFlipX(pc)
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_ResumeHoverAfterTurn:
                move.b  #$3C,routine(a0)
                rts
; ---------------------------------------------------------------------------

SSZKnucklesMecha_RunPaletteOnlyShift:
                jmp     (Run_PalRotationScript).l
; ---------------------------------------------------------------------------

SSZKnuxMecha_FallAfterPaletteShift:
                move.b  #$42,routine(a0)
                rts
