; Owner: objects/bosses/lbz/grabber_ship/s3
; Responsibility: Launch Base second final boss initialization, battle state, player interaction and defeat control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZFinalBoss2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZFinalBoss2_Index(pc,d0.w),d1
                jsr     LBZFinalBoss2_Index(pc,d1.w)
                jsr     (HandleLBZFinalBoss2SixColorHitOrDefeat).l
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
LBZFinalBoss2_Index:
                dc.w    LBZBoss2S3_InitShipAndHealth-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_RiseAboveCameraForIntro-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_TickIntroOrResetWait-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_FallToCameraBottom-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_TickIntroOrResetWait-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_ApplyPassVariantAndMove-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_MoveBetweenInnerBounds-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_TickBeforeCaptureDrop-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_DropToCaptureDepth-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_AccelerateUpToBounceGate-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_AccelerateDownToBounceGate-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_TickClampedHeightHold-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_MoveBetweenOuterBounds-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_TickCaptureExitHold-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_RiseAboveCameraAndReset-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_TickPlayerHeldWait-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_MoveHeldAscentAboveCamera-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_TickThrowSetupHold-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_StepDownToThrowHeight-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_TickImpactSteps-LBZFinalBoss2_Index
                dc.w    LBZFinalBoss2S3_Root_CountImpactPause-LBZFinalBoss2_Index
                dc.w    LBZBoss2S3_MoveRecoilAndTickReset-LBZFinalBoss2_Index
; ---------------------------------------------------------------------------

LBZBoss2S3_InitShipAndHealth:
                lea     ObjDat_LBZFinalBoss2(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #8,collision_property(a0)
                bset    #3,$38(a0)
                st      (Disable_death_plane).w
                lea     Pal_LBZFinalBoss2(pc),a1
                jsr     PalLoad_Line1(pc)
                lea     (ArtKosM_LBZFinalBoss2).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZFinalBoss2),d2
                jsr     (Queue_Kos_Module).l
                lea     (Child1_MakeRoboHead4).l,a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_RiseAboveCameraForIntro:
                subq.w  #1,y_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$40,d0
                cmp.w   y_pos(a0),d0
                bcc.s   LBZBoss2S3_BeginIntroWaitAndMusic
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginIntroWaitAndMusic:
                move.b  #4,routine(a0)
                move.w  #$9F,$2E(a0)
                move.l  #LBZBoss2S3_BeginDropAndSpawnBody,$34(a0)
                jsr     (AllocateObject).l
                bne.s   LBZBoss2S3_TryIntroPaletteActor
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_FinalBoss,subtype(a1)

LBZBoss2S3_TryIntroPaletteActor:
                jsr     (AllocateObject).l
                bne.s   LBZBoss2S3_IntroSpawnReturn
                move.l  #LBZBoss2S3_InitEndingPaletteActor,(a1)

LBZBoss2S3_IntroSpawnReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_TickIntroOrResetWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginDropAndSpawnBody:
                move.b  #6,routine(a0)
                move.b  #8,mapping_frame(a0)
                lea     LBZBoss2S3_BodyPartChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_FallToCameraBottom:
                jsr     MoveSprite_LightGravity(pc)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   y_pos(a0),d0
                blo.s   LBZBoss2S3_EnableContactAndSpawnProxy
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_EnableContactAndSpawnProxy:
                bset    #7,art_tile(a0)
                clr.w   y_vel(a0)
                move.b  #$F,collision_flags(a0)
                bchg    #0,render_flags(a0)
                lea     LBZBoss2S3_TouchProxyChild(pc),a2
                jsr     CreateChild1_Normal(pc)

LBZBoss2S3_BeginAttackHold:
                move.b  #8,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #LBZBoss2S3_ChooseAttackFamily,$34(a0)

LBZBoss2S3_SharedReturn:
                rts
; ---------------------------------------------------------------------------

; The old cycle counter's bit 1 switches from the pass to the bounce family
LBZBoss2S3_ChooseAttackFamily:
                bchg    #0,render_flags(a0)
                move.b  $39(a0),d0
                addq.b  #1,$39(a0)
                btst    #1,d0
                bne.s   LBZBoss2S3_BeginInnerPatrol
                move.b  #$A,routine(a0)
                bclr    #3,$38(a0)
                bclr    #2,$38(a0)
                move.w  #$AF,$2E(a0)
                move.l  #LBZBoss2S3_BeginAttackHold,$34(a0)
                bra.w   LBZBoss2S3_ChoosePassHeightAndSpeed
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginInnerPatrol:
                move.b  #$C,routine(a0)
                clr.b   $39(a0)
                clr.w   y_vel(a0)
                move.l  #LBZBoss2S3_BeginInnerPatrolHold,$34(a0)
                move.w  (Camera_Y_pos).w,y_pos(a0)
                bra.w   LBZBoss2S3_ChoosePatrolFacingSpeed
; ---------------------------------------------------------------------------

LBZBoss2S3_ApplyPassVariantAndMove:
                move.w  $3A(a0),d0
                move.w  LBZBoss2S3_PassHeightStateOffsets(pc,d0.w),d0
                jsr     LBZBoss2S3_PassHeightStateOffsets(pc,d0.w)
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------
LBZBoss2S3_PassHeightStateOffsets:
                dc.w    LBZBoss2S3_PassVariantReturn-LBZBoss2S3_PassHeightStateOffsets
                dc.w    LBZBoss2S3_PassDecreaseYSpeed-LBZBoss2S3_PassHeightStateOffsets
                dc.w    LBZBoss2S3_PassAddYAcceleration-LBZBoss2S3_PassHeightStateOffsets
                dc.w    LBZBoss2S3_PassVariantReturn-LBZBoss2S3_PassHeightStateOffsets
                dc.w    LBZBoss2S3_PassRaiseYFour-LBZBoss2S3_PassHeightStateOffsets
; ---------------------------------------------------------------------------

LBZBoss2S3_PassDecreaseYSpeed:
                subq.w  #4,y_vel(a0)

LBZBoss2S3_PassVariantReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_PassAddYAcceleration:
                move.w  y_vel(a0),d0
                add.w   $3C(a0),d0
                move.w  d0,y_vel(a0)
                bne.s   LBZBoss2S3_PassAccelerationReturn
                move.w  #2,$3C(a0)

LBZBoss2S3_PassAccelerationReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_PassRaiseYFour:
                subq.w  #4,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_MoveBetweenInnerBounds:
                moveq   #$50,d1
                move.w  #$F0,d2
                bsr.w   LBZBoss2_ReverseAtCameraBounds
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginInnerPatrolHold:
                move.b  #$E,routine(a0)
                clr.w   x_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #LBZBoss2S3_BeginCaptureDrop,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_TickBeforeCaptureDrop:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginCaptureDrop:
                move.b  #$10,routine(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_DropToCaptureDepth:
                jsr     MoveSprite_LightGravity(pc)
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$C0,d0
                cmp.w   y_pos(a0),d0
                blo.s   LBZBoss2S3_ReverseCaptureAcceleration
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_ReverseCaptureAcceleration:
                move.b  #$12,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_AccelerateUpToBounceGate:
                addi.w  #-$80,y_vel(a0)
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                bpl.s   LBZBoss2S3_BounceUpGateReturn
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                bhs.s   LBZBoss2S3_BeginDownwardAcceleration

LBZBoss2S3_BounceUpGateReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginDownwardAcceleration:
                move.b  #$14,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_AccelerateDownToBounceGate:
                addi.w  #$40,y_vel(a0)
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                bmi.s   LBZBoss2S3_BounceDownGateReturn
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$D0,d0
                cmp.w   y_pos(a0),d0
                bls.s   LBZBoss2S3_ClampCaptureYAndHold

LBZBoss2S3_BounceDownGateReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_ClampCaptureYAndHold:
                move.b  #$16,routine(a0)
                move.w  d0,y_pos(a0)
                clr.w   y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #LBZBoss2S3_BeginLowerPatrol,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_TickClampedHeightHold:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginLowerPatrol:
                move.b  #$18,routine(a0)
                move.l  #LBZFinalBoss2S3_Root_ArmSecondPassPause,$34(a0)
                bra.w   LBZBoss2S3_ChoosePatrolFacingSpeed
; ---------------------------------------------------------------------------

LBZBoss2S3_MoveBetweenOuterBounds:
                moveq   #$30,d1
                move.w  #$110,d2
                bsr.w   LBZBoss2_ReverseAtCameraBounds
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZFinalBoss2S3_Root_ArmSecondPassPause:
                move.b  #$1A,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #LBZBoss2S3_BeginFastCaptureEscape,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_TickCaptureExitHold:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginFastCaptureEscape:
                move.b  #$1C,routine(a0)
                move.w  #-$400,y_vel(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_RiseAboveCameraAndReset:
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bhs.s   LBZBoss2S3_RestartAttackHold
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_RestartAttackHold:
                bra.w   LBZBoss2S3_BeginAttackHold
; ---------------------------------------------------------------------------

LBZBoss2S3_TickPlayerHeldWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginCapturedPlayerAscent:
                move.b  #$20,routine(a0)
                move.w  #-$400,y_vel(a0)
                bchg    #1,$39(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_MoveHeldAscentAboveCamera:
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bhs.s   LBZBoss2S3_BeginThrowSetupHold
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginThrowSetupHold:
                move.b  #$22,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #LBZBoss2S3_ResetArmAndChooseThrowSide,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_TickThrowSetupHold:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_ResetArmAndChooseThrowSide:
                move.b  #$24,routine(a0)
                movea.w $44(a0),a1
                clr.b   $3C(a1)
                move.w  (Camera_X_pos).w,d0
                move.w  d0,d1
                addi.w  #$A0,d0
                bclr    #0,render_flags(a0)
                move.w  #$E0,d2
                cmp.w   x_pos(a0),d0
                blo.s   LBZFinalBoss2S3_Root_StoreSelectedSideX
                bset    #0,render_flags(a0)
                move.w  #$60,d2

LBZFinalBoss2S3_Root_StoreSelectedSideX:
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_StepDownToThrowHeight:
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$88,d0
                cmp.w   y_pos(a0),d0
                bls.s   LBZBoss2S3_SignalImpactAndBeginSteps
                addq.w  #8,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_SignalImpactAndBeginSteps:
                move.b  #$26,routine(a0)
                bset    #1,$38(a0)
                move.w  #$14,(Screen_shake_flag).w
                move.w  #3,$2E(a0)
                moveq   #signextendB(sfx_BossHitFloor),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_TickImpactSteps:
                addq.w  #4,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   LBZBoss2S3_BeginPostImpactHold
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginPostImpactHold:
                move.b  #$28,routine(a0)
                move.w  #7,$2E(a0)
                move.l  #LBZBoss2S3_ReleasePlayerAndAimRecoil,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZFinalBoss2S3_Root_CountImpactPause:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_ReleasePlayerAndAimRecoil:
                move.b  #$2A,routine(a0)
                clr.b   $30(a0)
                subi.w  #$10,y_pos(a0)
                bclr    #1,$38(a0)
                move.w  #$400,d0
                btst    #0,render_flags(a0)
                beq.s   LBZBoss2S3_RecoilAndHurtPlayer
                neg.w   d0

LBZBoss2S3_RecoilAndHurtPlayer:
                move.w  d0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$3F,$2E(a0)
                movea.l a0,a2
                lea     (Player_1).w,a0
                jsr     (HurtCharacter).l
                movea.l a2,a0
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_MoveRecoilAndTickReset:
                jsr     (MoveSprite).l
                subq.w  #1,$2E(a0)
                bmi.w   LBZBoss2S3_BeginAttackHold
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginDefeatSinkAndBreakup:
                move.l  #LBZBoss2S3_SinkThenLockPlayerForEnding,(a0)
                move.b  #5,mapping_frame(a0)
                bset    #4,$38(a0)
                lea     LBZBoss2S3_DefeatFragmentChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_SinkThenLockPlayerForEnding:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                move.w  d0,y_pos(a0)
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$140,d1
                cmp.w   d1,d0
                blo.s   LBZBoss2S3_DrawSinkingShip
                move.l  #LBZBoss2S3_EndingWaitGroundedAndCenter,(a0)
                bclr    #7,render_flags(a0)
                bset    #5,$38(a0)
                move.w  a0,(SceneControllerObjectAddress).w
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                move.b  #$80,(Player_1+object_control).w
                lea     (ArtKosM_LBZ2DeathEggSmall).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZ2DeathEggSmall),d2
                jsr     (Queue_Kos_Module).l

LBZBoss2S3_DrawSinkingShip:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2S3_EndingWaitGroundedAndCenter:
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   LBZBoss2S3_EndingCenteringReturn
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                sub.w   x_pos(a1),d0
                scs     d2
                bpl.s   LBZBoss2S3_EndingChooseCenterDirection
                neg.w   d0

LBZBoss2S3_EndingChooseCenterDirection:
                cmpi.w  #4,d0
                blo.s   LBZBoss2S3_EndingStopAndTryPoseActor
                moveq   #button_right,d1
                tst.b   d2
                beq.s   LBZBoss2S3_EndingApplyHeldDirection
                moveq   #button_left,d1

LBZBoss2S3_EndingApplyHeldDirection:
                bset    d1,(Ctrl_1_held_logical).w

LBZBoss2S3_EndingCenteringReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_EndingStopAndTryPoseActor:
                move.l  #LBZFinalBoss2S3_Ending_RootInertReturn,(a0)
                clr.b   (EndingOutcomeOrBossSceneSignals).w
                clr.w   ground_vel(a1)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                jsr     (AllocateObject).l
                bne.s   LBZBoss2S3_EndingSpawnBurstControllers
                move.l  #LBZBoss2S3_WaitAndTakeExternalAnim,(a1)
                lea     (Player_1).w,a2
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)

LBZBoss2S3_EndingSpawnBurstControllers:
                lea     LBZBoss2S3_EndingBurstChildren(pc),a2
                jmp     CreateChild6_Simple(pc)
; ---------------------------------------------------------------------------

LBZFinalBoss2S3_Ending_RootInertReturn:
                rts
