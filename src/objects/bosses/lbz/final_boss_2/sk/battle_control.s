; Owner: objects/bosses/lbz/final_boss_2/sk
; Responsibility: Launch Base final boss battle controller, player capture or release, defeat and scene transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZFinalBoss2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZFinalBoss2_Index(pc,d0.w),d1
                jsr     LBZFinalBoss2_Index(pc,d1.w)
                jsr     (HandleLBZFinalBoss2SixColorHitOrDefeat).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
LBZFinalBoss2_Index:
                dc.w    LBZBoss2SK_InitShipAndHealth-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_TickIntroOrResetWait-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_TickIntroOrResetWait-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_FallToCameraBottom-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_TickIntroOrResetWait-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_ApplyPassVariantAndMove-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_MoveBetweenInnerBounds-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_TickBeforeCaptureDrop-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_DropToCaptureDepth-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_AccelerateUpToBounceGate-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_AccelerateDownToBounceGate-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_TickClampedHeightHold-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_MoveBetweenOuterBounds-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_TickCaptureExitHold-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_RiseAboveCameraAndReset-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_TickPlayerHeldWait-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_MoveHeldAscentAboveCamera-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_TickThrowSetupHold-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_StepDownToThrowHeight-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_TickImpactSteps-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_TickBeforePlayerRelease-LBZFinalBoss2_Index
                dc.w    LBZBoss2SK_MoveRecoilAndTickReset-LBZFinalBoss2_Index
; ---------------------------------------------------------------------------

LBZBoss2SK_InitShipAndHealth:
                lea     ObjDat_LBZFinalBoss2(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                bset    #3,$38(a0)
                st      (Disable_death_plane).w
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$50,d0
                move.w  d0,y_pos(a0)
                move.w  #$59,$2E(a0)
                move.l  #LBZBoss2SK_BeginDropAndSpawnBody,$34(a0)
                lea     Pal_LBZFinalBoss2(pc),a1
                jsr     (PalLoad_Line1).l
                lea     (ArtKosM_LBZFinalBoss2).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZFinalBoss2),d2
                jsr     (Queue_Kos_Module).l
                lea     (Child1_MakeRoboHead4).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LBZBoss2SK_TickIntroOrResetWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginDropAndSpawnBody:
                move.b  #6,routine(a0)
                move.b  #8,mapping_frame(a0)
                lea     LBZBoss2SK_BodyPartChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LBZBoss2SK_FallToCameraBottom:
                jsr     (MoveSprite_LightGravity).l
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   y_pos(a0),d0
                blo.s   LBZBoss2SK_EnableContactAndSpawnProxy
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_EnableContactAndSpawnProxy:
                bset    #7,art_tile(a0)
                clr.w   y_vel(a0)
                move.b  #$F,$28(a0)
                bchg    #0,render_flags(a0)
                lea     LBZBoss2SK_TouchProxyChild(pc),a2
                jsr     (CreateChild1_Normal).l

LBZBoss2SK_BeginAttackHold:
                move.b  #8,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #LBZBoss2SK_ChooseAttackFamily,$34(a0)

LBZBoss2SK_SharedReturn:
                rts
; ---------------------------------------------------------------------------

; The old cycle counter's bit 2 selects the capture cycle after four passes
LBZBoss2SK_ChooseAttackFamily:
                bchg    #0,render_flags(a0)
                move.b  $39(a0),d0
                addq.b  #1,$39(a0)
                btst    #2,d0
                bne.s   LBZBoss2SK_BeginInnerPatrol
                move.b  #$A,routine(a0)
                bclr    #3,$38(a0)
                bclr    #2,$38(a0)
                move.w  #$AF,$2E(a0)
                move.l  #LBZBoss2SK_BeginAttackHold,$34(a0)
                bra.w   LBZBoss2SK_ChoosePassHeightAndSpeed
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginInnerPatrol:
                move.b  #$C,routine(a0)
                clr.b   $39(a0)
                clr.w   y_vel(a0)
                move.l  #LBZBoss2SK_BeginInnerPatrolHold,$34(a0)
                move.w  (Camera_Y_pos).w,y_pos(a0)
                bra.w   LBZBoss2SK_ChoosePatrolFacingSpeed
; ---------------------------------------------------------------------------

LBZBoss2SK_ApplyPassVariantAndMove:
                move.w  $3A(a0),d0
                move.w  LBZBoss2SK_PassHeightStateOffsets(pc,d0.w),d0
                jsr     LBZBoss2SK_PassHeightStateOffsets(pc,d0.w)
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------
LBZBoss2SK_PassHeightStateOffsets:
                dc.w    LBZBoss2SK_PassVariantReturn-LBZBoss2SK_PassHeightStateOffsets
                dc.w    LBZBoss2SK_PassDecreaseYSpeed-LBZBoss2SK_PassHeightStateOffsets
                dc.w    LBZBoss2SK_PassAddYAcceleration-LBZBoss2SK_PassHeightStateOffsets
                dc.w    LBZBoss2SK_PassVariantReturn-LBZBoss2SK_PassHeightStateOffsets
                dc.w    LBZBoss2SK_PassRaiseYFour-LBZBoss2SK_PassHeightStateOffsets
; ---------------------------------------------------------------------------

LBZBoss2SK_PassDecreaseYSpeed:
                subq.w  #4,y_vel(a0)

LBZBoss2SK_PassVariantReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_PassAddYAcceleration:
                move.w  y_vel(a0),d0
                add.w   $3C(a0),d0
                move.w  d0,y_vel(a0)
                bne.s   LBZBoss2SK_PassAccelerationReturn
                move.w  #2,$3C(a0)

LBZBoss2SK_PassAccelerationReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_PassRaiseYFour:
                subq.w  #4,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_MoveBetweenInnerBounds:
                moveq   #$50,d1
                move.w  #$F0,d2
                bsr.w   LBZBoss2_ReverseAtCameraBounds
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginInnerPatrolHold:
                move.b  #$E,routine(a0)
                clr.w   x_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #LBZBoss2SK_BeginCaptureDrop,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_TickBeforeCaptureDrop:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginCaptureDrop:
                move.b  #$10,routine(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_DropToCaptureDepth:
                jsr     (MoveSprite_LightGravity).l
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$C0,d0
                cmp.w   y_pos(a0),d0
                blo.s   LBZBoss2SK_ReverseCaptureAcceleration
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_ReverseCaptureAcceleration:
                move.b  #$12,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_AccelerateUpToBounceGate:
                addi.w  #-$80,y_vel(a0)
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                bpl.s   LBZBoss2SK_BounceUpGateReturn
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                bhs.s   LBZBoss2SK_BeginDownwardAcceleration

LBZBoss2SK_BounceUpGateReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginDownwardAcceleration:
                move.b  #$14,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_AccelerateDownToBounceGate:
                addi.w  #$40,y_vel(a0)
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                bmi.s   LBZBoss2SK_BounceDownGateReturn
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$D0,d0
                cmp.w   y_pos(a0),d0
                bls.s   LBZBoss2SK_ClampCaptureYAndHold

LBZBoss2SK_BounceDownGateReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_ClampCaptureYAndHold:
                move.b  #$16,routine(a0)
                move.w  d0,y_pos(a0)
                clr.w   y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #LBZBoss2SK_BeginLowerPatrol,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_TickClampedHeightHold:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginLowerPatrol:
                move.b  #$18,routine(a0)
                move.l  #LBZBoss2SK_BeginCaptureExitHold,$34(a0)
                bra.w   LBZBoss2SK_ChoosePatrolFacingSpeed
; ---------------------------------------------------------------------------

LBZBoss2SK_MoveBetweenOuterBounds:
                moveq   #$30,d1
                move.w  #$110,d2
                bsr.w   LBZBoss2_ReverseAtCameraBounds
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginCaptureExitHold:
                move.b  #$1A,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #LBZBoss2SK_BeginFastCaptureEscape,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_TickCaptureExitHold:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginFastCaptureEscape:
                move.b  #$1C,routine(a0)
                move.w  #-$400,y_vel(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_RiseAboveCameraAndReset:
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bhs.s   LBZBoss2SK_RestartAttackHold
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_RestartAttackHold:
                bra.w   LBZBoss2SK_BeginAttackHold
; ---------------------------------------------------------------------------

LBZBoss2SK_TickPlayerHeldWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginCapturedPlayerAscent:
                move.b  #$20,routine(a0)
                move.w  #-$400,y_vel(a0)
                bchg    #1,$39(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_MoveHeldAscentAboveCamera:
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bhs.s   LBZBoss2SK_BeginThrowSetupHold
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginThrowSetupHold:
                move.b  #$22,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #LBZBoss2SK_ResetArmAndChooseThrowSide,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_TickThrowSetupHold:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBoss2SK_ResetArmAndChooseThrowSide:
                move.b  #$24,routine(a0)
                movea.w $44(a0),a1
                clr.b   $3C(a1)
                move.w  (Camera_X_pos).w,d0
                move.w  d0,d1
                addi.w  #$A0,d0
                bclr    #0,render_flags(a0)
                move.w  #$E0,d2
                cmp.w   x_pos(a0),d0
                blo.s   LBZBoss2SK_StoreThrowSideX
                bset    #0,render_flags(a0)
                move.w  #$60,d2

LBZBoss2SK_StoreThrowSideX:
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_StepDownToThrowHeight:
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$88,d0
                cmp.w   y_pos(a0),d0
                bls.s   LBZBoss2SK_SignalImpactAndBeginSteps
                addq.w  #8,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_SignalImpactAndBeginSteps:
                move.b  #$26,routine(a0)
                bset    #1,$38(a0)
                move.w  #$14,(Screen_shake_flag).w
                move.w  #3,$2E(a0)
                moveq   #signextendB(sfx_BossHitFloor),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_TickImpactSteps:
                addq.w  #4,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   LBZBoss2SK_BeginPostImpactHold
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginPostImpactHold:
                move.b  #$28,routine(a0)
                move.w  #7,$2E(a0)
                move.l  #LBZBoss2SK_ReleasePlayerAndAimRecoil,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_TickBeforePlayerRelease:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBoss2SK_ReleasePlayerAndAimRecoil:
                move.b  #$2A,routine(a0)
                clr.b   $30(a0)
                subi.w  #$10,y_pos(a0)
                bclr    #1,$38(a0)
                move.w  #$400,d0
                btst    #0,render_flags(a0)
                beq.s   LBZBoss2SK_RecoilAndHurtPlayer
                neg.w   d0

LBZBoss2SK_RecoilAndHurtPlayer:
                move.w  d0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$3F,$2E(a0)
                btst    #Status_Invincible,(Player_1+status_secondary).w
                bne.s   LBZBoss2SK_SpringReleaseInvincibleP1
                movea.l a0,a2
                lea     (Player_1).w,a0
                jsr     (HurtCharacter).l
                movea.l a2,a0
                rts
; ---------------------------------------------------------------------------

; Launch the invincible player opposite the ship's recoil and restore control
LBZBoss2SK_SpringReleaseInvincibleP1:
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                neg.w   d0
                move.w  d0,x_vel(a1)
                move.w  #-$400,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #2,anim(a1)
                move.b  #2,routine(a1)
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

LBZBoss2SK_MoveRecoilAndTickReset:
                jsr     (MoveSprite).l
                subq.w  #1,$2E(a0)
                bmi.w   LBZBoss2SK_BeginAttackHold
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginDefeatRiseAndBreakup:
                move.l  #LBZBoss2SK_RiseToDefeatCameraGate,(a0)
                move.b  #5,mapping_frame(a0)
                bset    #4,$38(a0)
                lea     LBZBoss2SK_DefeatFragmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LBZBoss2SK_RiseToDefeatCameraGate:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                move.w  d0,y_pos(a0)
                move.w  (Camera_Y_pos).w,d1
                subi.w  #$40,d1
                cmp.w   d1,d0
                blo.s   LBZBoss2SK_SpawnCapsuleAndInstallWait
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2SK_SpawnCapsuleAndInstallWait:
                move.l  #LBZBoss2SK_WaitCapsuleAndFinishEvent,(a0)
                bclr    #7,render_flags(a0)
                bset    #5,$38(a0)
                bset    #0,render_flags(a0)
                move.w  (Camera_X_pos).w,d2
                addi.w  #$40,d2
                move.w  d2,x_pos(a0)
                jmp     (AIZBossSK_SignalAndSpawnCapsule).l
; ---------------------------------------------------------------------------

LBZBoss2SK_WaitCapsuleAndFinishEvent:
                tst.b   (_unkFAA8).w
                bne.w   LBZBoss2SK_SharedReturn
                tst.b   (_unkFAA2).w
                beq.w   LBZBoss2SK_SharedReturn
                move.l  #LBZBoss2SK_ChoosePlayerAlignmentInput,(a0)
                jsr     LBZFinalBoss_QueueShipAndExplosionArt(pc)
                bclr    #7,status(a0)
                jsr     (Restore_PlayerControl).l
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w

LBZBoss2SK_ChoosePlayerAlignmentInput:
                lea     (Player_1).w,a1
                move.w  #(button_right_mask<<8)|button_right_mask,d0
                move.w  (Camera_X_pos).w,d1
                addi.w  #$50,d1
                sub.w   x_pos(a1),d1
                bcc.s   LBZBoss2SK_ApplyInputAndStopAtTarget
                move.w  #(button_left_mask<<8)|button_left_mask,d0
                neg.w   d1

LBZBoss2SK_ApplyInputAndStopAtTarget:
                move.w  d0,(Ctrl_1_logical).w
                cmpi.w  #8,d1
                bhs.w   LBZBoss2SK_SharedReturn
                move.l  #LBZBoss2SK_DescendShipAndHoldUp,(a0)
                clr.w   (Ctrl_1_logical).w
                bset    #0,render_flags(a1)
                bset    #Status_Facing,status(a1)
                jsr     (Stop_Object).l
                moveq   #PLCID_71,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_EggRoboHead).l,a1
                move.w  #tiles_to_bytes(ArtTile_RobotnikShip),d2
                jsr     (Queue_Kos_Module).l
                bclr    #5,$38(a0)
                lea     (Child1_MakeRoboHead4).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LBZBoss2SK_DescendShipAndHoldUp:
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$40,d1
                cmp.w   d1,d0
                bhs.s   LBZBoss2SK_BeginBobbingFlightAndFlame
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginBobbingFlightAndFlame:
                move.l  #LBZBoss2SK_BobAndFacePlayerToShip,(a0)
                move.w  #$200,x_vel(a0)
                jsr     (Swing_Setup1).l
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2SK_BobAndFacePlayerToShip:
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                lea     (Player_1).w,a1
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                cmp.w   x_pos(a1),d0
                bhs.s   LBZBoss2SK_CheckFlightCameraGate
                bset    #0,render_flags(a1)
                bset    #Status_Facing,status(a1)

LBZBoss2SK_CheckFlightCameraGate:
                move.w  (Camera_X_pos).w,d1
                addi.w  #$A0,d1
                cmp.w   d1,d0
                bhs.s   LBZBoss2SK_BeginFlightHoldAndDropRelay
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginFlightHoldAndDropRelay:
                move.w  d0,x_pos(a0)
                move.l  #LBZBoss2SK_TickFlightHoldAndDraw,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #LBZBoss2SK_BeginFastHorizontalFlight,$34(a0)
                bclr    #3,$38(a0)
                lea     LBZBoss2SK_DroppedRelayChild(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2SK_TickFlightHoldAndDraw:
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginFastHorizontalFlight:
                move.l  #LBZBoss2SK_BobPastRightCameraGate,(a0)
                move.w  #$400,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_BobPastRightCameraGate:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                move.w  (Camera_X_pos).w,d1
                addi.w  #$1C0,d1
                cmp.w   d1,d0
                bhs.s   LBZBoss2SK_HideShipAndClearBossFlag
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2SK_HideShipAndClearBossFlag:
                move.l  #LBZBoss2SK_WaitForRelayThenMoveRight,(a0)
                bset    #6,status(a0)
                bset    #4,$38(a0)
                bset    #5,$38(a0)
                clr.b   (Boss_flag).w
                bclr    #7,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_WaitForRelayThenMoveRight:
                btst    #3,$38(a0)
                beq.s   LBZBoss2SK_RelayWaitReturn
                move.l  #LBZBoss2SK_CapturePlayerAtExitX,(a0)
                move.w  #(button_right_mask<<8)|button_right_mask,(Ctrl_1_logical).w

LBZBoss2SK_RelayWaitReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_CapturePlayerAtExitX:
                cmpi.w  #$4510,(Player_1+x_pos).w
                blo.s   LBZBoss2SK_ExitCaptureReturn
                move.l  #LBZBoss2SK_CarryPlayerWithGravity,(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.b  #$83,object_control(a1)
                move.b  #$8C,mapping_frame(a1)
                jsr     (Player_Load_PLC).l
                clr.b   anim_frame(a0)
                move.b  #$A,anim_frame_timer(a0)
                move.w  #$200,x_vel(a0)
                move.w  #-$400,y_vel(a0)

LBZBoss2SK_ExitCaptureReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_CarryPlayerWithGravity:
                jsr     (MoveSprite_LightGravity).l
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   LBZBoss2SK_StartZoneAtExitHeight
                move.b  #$A,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)
                moveq   #signextendB($8C),d0
                btst    #0,anim_frame(a0)
                bne.s   LBZBoss2SK_SetAlternateCarryFrame
                moveq   #signextendB($8D),d0

LBZBoss2SK_SetAlternateCarryFrame:
                move.b  d0,mapping_frame(a1)
                jsr     (Player_Load_PLC).l

LBZBoss2SK_StartZoneAtExitHeight:
                move.w  (_unkFAB0).w,d0
                addi.w  #$200,d0
                cmp.w   (Player_1+y_pos).w,d0
                bhi.w   LBZBoss2SK_SharedReturn
                move.w  #$700,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
