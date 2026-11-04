; Owner: objects/bosses/dez/miniboss/sk
; Responsibility: Death Egg miniboss controller, flight, attack and coordinated child state progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZMiniboss:
                lea     DEZMiniboss_CameraTriggerAndArenaBounds(pc),a1
                jsr     (Check_CameraInRange).l
                move.b  #mus_Miniboss,boss_saved_mus(a0)
                jsr     (Boss_BeginCameraTransition).l
                move.l  #DEZMiniboss_RunInitialCameraTransition,(a0)
                move.l  #DEZMini_FinishCameraAndWidenBounds,$34(a0)
                lea     ObjDat_DEZMiniboss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                clr.b   routine(a0)
                clr.b   collision_property(a0)
                clr.b   $42(a0)
                move.w  #$4000,$3A(a0)
                move.w  #$8000,$3C(a0)
                lea     DEZMinibossEye_NormalChildRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     DEZMini_OrbitHazardChild(pc),a2
                jsr     CreateChild6_Simple(pc)
                moveq   #PLCID_7B,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_DEZMinibossMisc).l,a1
                move.w  #tiles_to_bytes(ArtTile_DEZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     Pal_DEZMiniboss1(pc),a1
                jmp     PalLoad_Line1(pc)
; ---------------------------------------------------------------------------

DEZMiniboss_RunInitialCameraTransition:
                jmp     SKEndCamera_TickAndSaveMusic(pc)
; ---------------------------------------------------------------------------

DEZMini_FinishCameraAndWidenBounds:
                move.l  #DEZMini_AdvanceInitialHazardY,(a0)
                addi.w  #$E0,(SceneMaximumYOrEmeraldSelectionTail).w
                addi.w  #$40,(SceneMinimumXOrEmeraldSelectionTail).w
                addi.w  #$100,(SceneMaximumXOrEmeraldSelectionTail).w

DEZMinibossAndScene_SharedReturn:
                rts
; ---------------------------------------------------------------------------

DEZMini_AdvanceInitialHazardY:
                addq.b  #4,$3C(a0)
                bpl.s   DEZMini_InstallFormOneDispatcher
                rts
; ---------------------------------------------------------------------------

DEZMini_InstallFormOneDispatcher:
                move.l  #DEZMini_FormOneDispatchSoundAndHit,(a0)

DEZMinibossFirstForm_ResetCycleDelay:
                move.b  #0,routine(a0)
                clr.w   $3C(a0)
                move.w  #$7F,$2E(a0)
                move.l  #DEZMini_BeginHazardYBounces,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_FormOneDispatchSoundAndHit:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DEZMinibossFirstForm_CycleStateOffsets(pc,d0.w),d1
                jsr     DEZMinibossFirstForm_CycleStateOffsets(pc,d1.w)
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$1F,d0
                bne.s   DEZMini_FormOneCheckHitsAfterCycle
                moveq   #signextendB(sfx_GravityTunnel),d0
                jsr     (Play_SFX).l

DEZMini_FormOneCheckHitsAfterCycle:
                bra.w   DEZMini_FormOneCheckHitCount
; ---------------------------------------------------------------------------
DEZMinibossFirstForm_CycleStateOffsets:
                dc.w    DEZMini_FormOneTickCycleWait-DEZMinibossFirstForm_CycleStateOffsets
                dc.w    DEZMini_UpdateHazardYBounce-DEZMinibossFirstForm_CycleStateOffsets
                dc.w    DEZMini_FormOneTickCycleWait-DEZMinibossFirstForm_CycleStateOffsets
                dc.w    DEZMini_IncreaseRadialAmplitude-DEZMinibossFirstForm_CycleStateOffsets
                dc.w    DEZMini_FormOneTickCycleWait-DEZMinibossFirstForm_CycleStateOffsets
                dc.w    DEZMini_DecreaseRadialAmplitude-DEZMinibossFirstForm_CycleStateOffsets
                dc.w    DEZMini_FormOneTickCycleWait-DEZMinibossFirstForm_CycleStateOffsets
                dc.w    DEZMini_LowerHazardYOffset-DEZMinibossFirstForm_CycleStateOffsets
; ---------------------------------------------------------------------------

DEZMini_FormOneTickCycleWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

DEZMini_BeginHazardYBounces:
                move.b  #2,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #DEZMini_PauseBeforeRadialExpansion,$34(a0)
                move.b  #2,$39(a0)
                clr.w   $40(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_UpdateHazardYBounce:
                move.w  $40(a0),d0
                move.w  $3C(a0),d1
                addi.w  #$20,d0
                add.w   d0,d1
                cmpi.w  #$7000,d1
                blo.s   DEZMini_StoreHazardYOffsetAndStep
                move.w  #$7000,d1
                lsr.w   #1,d0
                neg.w   d0
                subq.b  #1,$39(a0)
                bpl.s   DEZMini_StoreHazardYOffsetAndStep
                bsr.w   DEZMini_PauseBeforeRadialExpansion

DEZMini_StoreHazardYOffsetAndStep:
                move.w  d0,$40(a0)
                move.w  d1,$3C(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_PauseBeforeRadialExpansion:
                move.b  #4,routine(a0)
                move.w  #$9F,$2E(a0)
                move.l  #DEZMini_BeginRadialExpansion,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_BeginRadialExpansion:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_IncreaseRadialAmplitude:
                move.b  $3A(a0),d0
                addq.b  #2,d0
                bmi.s   DEZMini_HoldExpandedAmplitude
                move.b  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_HoldExpandedAmplitude:
                move.b  #8,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #DEZMini_BeginRadialContraction,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_BeginRadialContraction:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_DecreaseRadialAmplitude:
                move.b  $3A(a0),d0
                subq.b  #4,d0
                cmpi.b  #$40,d0
                bls.s   DEZMini_ClampAmplitudeAndWait
                move.b  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_ClampAmplitudeAndWait:
                move.b  #$40,$3A(a0)
                move.b  #$C,routine(a0)
                move.w  #$9F,$2E(a0)
                move.l  #DEZMini_BeginHazardYReturn,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_BeginHazardYReturn:
                move.b  #$E,routine(a0)
                move.w  #$1B,$2E(a0)
                move.l  #DEZMinibossFirstForm_ResetCycleDelay,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_LowerHazardYOffset:
                subq.b  #4,$3C(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

DEZMinibossTransform_DispatchState:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DEZMinibossTransform_StateOffsets(pc,d0.w),d1
                jmp     DEZMinibossTransform_StateOffsets(pc,d1.w)
; ---------------------------------------------------------------------------
DEZMinibossTransform_StateOffsets:
                dc.w    DEZMini_TransformTryDebris-DEZMinibossTransform_StateOffsets
                dc.w    DEZMinibossTransform_WaitAndDraw-DEZMinibossTransform_StateOffsets
                dc.w    DEZMini_TransformMoveWaitAndDraw-DEZMinibossTransform_StateOffsets
                dc.w    DEZMinibossTransform_WaitAndDraw-DEZMinibossTransform_StateOffsets
; ---------------------------------------------------------------------------

DEZMini_TransformTryDebris:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #7,d0
                bne.s   DEZMini_TransformTickDebrisWait
                lea     DEZMini_RandomDebrisChild(pc),a2
                jsr     CreateChild6_Simple(pc)

DEZMini_TransformTickDebrisWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

DEZMini_SignalForegroundAndSpawnShells:
                move.b  #2,routine(a0)
                move.w  #$5F,$2E(a0)
                move.l  #DEZMini_BeginTransformDiagonalMove,$34(a0)
                st      (Events_fg_4).w
                lea     DEZMini_DelayedSideDebrisChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_BeginTransformDiagonalMove:
                move.b  #4,routine(a0)
                bset    #5,$38(a0)
                move.w  #-$80,x_vel(a0)
                move.w  #$40,y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #DEZMini_SpawnLinkedPlatforms,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_TransformMoveWaitAndDraw:
                jsr     (MoveSprite2).l

DEZMinibossTransform_WaitAndDraw:
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_SpawnLinkedPlatforms:
                move.b  #6,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #DEZMini_InitFormTwoHoverAndMask,$34(a0)
                move.w  #0,$3A(a0)
                move.w  #$200,$3C(a0)
                move.w  #$100,$26(a0)
                lea     DEZMini_OrbitPlatformChildren(pc),a2
                jmp     CreateChild8_TreeListRepeated(pc)
; ---------------------------------------------------------------------------

DEZMini_InitFormTwoHoverAndMask:
                move.l  #DEZMini_FormTwoSoundAndDispatch,(a0)
                clr.b   routine(a0)
                bclr    #6,status(a0)
                clr.b   collision_property(a0)
                clr.b   $42(a0)
                move.w  y_pos(a0),$30(a0)
                bclr    #5,$38(a0)
                jsr     (AllocateObject).l
                bne.s   ResetDEZMinibossVerticalSwing
                move.w  a0,parent3(a1)
                move.l  #Obj_SpriteMask,(a1)
                move.w  #$3740,x_pos(a1)
                move.w  #$360,y_pos(a1)
                move.b  #$89,subtype(a1)

; =============== S U B R O U T I N E =======================================

ResetDEZMinibossVerticalSwing:
                move.w  #$80,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; End of function ResetDEZMinibossVerticalSwing

; ---------------------------------------------------------------------------

DEZMini_FormTwoSoundAndDispatch:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$3F,d0
                bne.s   DEZMini_FormTwoCheckHitAndDispatch
                moveq   #signextendB(sfx_WaveHover),d0
                jsr     (Play_SFX).l

DEZMini_FormTwoCheckHitAndDispatch:
                bsr.w   DEZMiniForm2_ReactToHitOrDefeat
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DEZMinibossSecondForm_StateOffsets(pc,d0.w),d1
                jmp     DEZMinibossSecondForm_StateOffsets(pc,d1.w)
; ---------------------------------------------------------------------------
DEZMinibossSecondForm_StateOffsets:
                dc.w    DEZMini_HoverAndRetargetPlatforms-DEZMinibossSecondForm_StateOffsets
                dc.w    DEZMini_RunPalettePursueAndRetarget-DEZMinibossSecondForm_StateOffsets
                dc.w    DEZMini_HoverUntilPlatformsAlign-DEZMinibossSecondForm_StateOffsets
                dc.w    DEZMinibossSecondForm_AscendOrReactToHit-DEZMinibossSecondForm_StateOffsets
                dc.w    DEZMini_WaitForCatchRelease-DEZMinibossSecondForm_StateOffsets
                dc.w    DEZMini_DescendToSavedHoverY-DEZMinibossSecondForm_StateOffsets
; ---------------------------------------------------------------------------

DEZMini_HoverAndRetargetPlatforms:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                bsr.w   DEZMini_ReversePastArenaXBounds
                bsr.w   DEZMini_RetargetPlatformSpin
                btst    #1,$38(a0)
                beq.s   DEZMinibossSecondForm_DrawIdleHover
                bsr.w   DEZMini_BeginPlatformExpansion

DEZMinibossSecondForm_DrawIdleHover:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

DEZMini_BeginPlatformExpansion:
                move.b  #2,routine(a0)
                bset    #7,$38(a0)
                rts
; End of function DEZMini_BeginPlatformExpansion

; ---------------------------------------------------------------------------

DEZMini_RunPalettePursueAndRetarget:
                jsr     Run_PalRotationScript(pc)
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                bsr.w   DEZMini_SetPursuitVelWithinBounds
                bsr.w   DEZMini_RetargetPlatformSpin
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_BeginPlatformAlignment:
                move.b  #4,routine(a0)
                clr.w   x_vel(a0)
                bclr    #1,$38(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_HoverUntilPlatformsAlign:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                btst    #1,$38(a0)
                bne.s   DEZMini_RestartPlatformExpansion
                btst    #3,$38(a0)
                beq.s   DEZMini_LaunchJumpAndSignalPlatforms
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_RestartPlatformExpansion:
                bsr.s   DEZMini_BeginPlatformExpansion
                bclr    #3,$38(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_LaunchJumpAndSignalPlatforms:
                move.b  #6,routine(a0)
                clr.w   x_vel(a0)
                move.w  #-$400,y_vel(a0)
                bset    #2,$38(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZMinibossSecondForm_AscendOrReactToHit:
                btst    #1,$38(a0)
                bne.s   DEZMini_BeginPlatformCatchWait
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                bmi.s   DEZMinibossSecondForm_DrawAfterAscent

DEZMini_BeginPlatformCatchWait:
                move.b  #8,routine(a0)

DEZMinibossSecondForm_DrawAfterAscent:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_WaitForCatchRelease:
                btst    #2,$38(a0)
                bne.s   DEZMinibossSecondForm_DrawCatchWait
                move.b  #$A,routine(a0)
                move.w  #$100,y_vel(a0)
                clr.w   $3A(a0)
                btst    #1,$38(a0)
                bne.s   DEZMini_RequestFastPlatformExpansion
                bset    #6,$38(a0)
                move.w  #$100,$26(a0)
                move.w  #$100,$3C(a0)

DEZMinibossSecondForm_DrawCatchWait:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_RequestFastPlatformExpansion:
                bset    #7,$38(a0)
                move.w  #$800,$26(a0)
                move.w  #$800,$3C(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_DescendToSavedHoverY:
                jsr     (MoveSprite2).l
                move.w  $30(a0),d0
                cmp.w   y_pos(a0),d0
                bhi.s   DEZMinibossSecondForm_DrawReturnDescent
                move.w  d0,y_pos(a0)
                move.b  #0,routine(a0)
                bclr    #6,$38(a0)
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                move.w  #-$80,d1
                tst.w   d0
                beq.s   DEZMini_ResumePursuitAndHover
                neg.w   d1

DEZMini_ResumePursuitAndHover:
                move.w  d1,x_vel(a0)
                bsr.w   ResetDEZMinibossVerticalSwing

DEZMinibossSecondForm_DrawReturnDescent:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_TryPostBossPlayerScene:
                jsr     (AllocateObject).l
                bne.s   DEZMini_SignalMaskAndStartEndSign
                move.l  #DEZMini_WaitForEndFlagSet,(a1)

DEZMini_SignalMaskAndStartEndSign:
                bset    #5,$38(a0)
                lea     DEZMini_DefeatFragmentChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Obj_EndSignControl(pc)
; ---------------------------------------------------------------------------

DEZMini_WaitForEndFlagSet:
                tst.b   (ActCompletionHandshake).w
                beq.w   DEZMinibossAndScene_SharedReturn
                move.l  #DEZMini_WaitForEndFlagClear,(a0)

DEZMini_WaitForEndFlagClear:
                tst.b   (ActCompletionHandshake).w
                bne.w   DEZMinibossAndScene_SharedReturn
                move.l  #DEZMini_WalkPlayerTowardCenter,(a0)
                st      (Ctrl_1_locked).w
                jsr     (AllocateObject).l
                bne.s   DEZMini_ChoosePlayerApproachSide
                move.l  #SKInput_LockP2IfActive,(a1)

DEZMini_ChoosePlayerApproachSide:
                cmpi.w  #$140,(Player_1+x_pos).w
                blo.s   DEZMini_WalkPlayerTowardCenter
                bset    #3,$38(a0)

DEZMini_WalkPlayerTowardCenter:
                lea     (Player_1).w,a1
                move.w  #$140,d0
                tst.w   x_vel(a0)
                btst    #3,$38(a0)
                bne.s   DEZMini_CheckLeftwardArrival
                cmp.w   x_pos(a1),d0
                bls.s   DEZMini_CenterPlayerAndTryExplosions
                moveq   #0,d1
                btst    #Status_Push,status(a1)
                beq.s   DEZMini_SetRightAndJumpInput
                ori.w   #(button_A_mask<<8)|button_A_mask,d1

DEZMini_SetRightAndJumpInput:
                ori.w   #(button_right_mask<<8)|button_right_mask,d1
                move.w  d1,(Ctrl_1_logical).w
                rts
; ---------------------------------------------------------------------------

DEZMini_CheckLeftwardArrival:
                cmp.w   x_pos(a1),d0
                bhs.s   DEZMini_CenterPlayerAndTryExplosions
                moveq   #0,d1
                btst    #Status_Push,status(a1)
                beq.s   DEZMini_SetLeftAndJumpInput
                ori.w   #(button_A_mask<<8)|button_A_mask,d1

DEZMini_SetLeftAndJumpInput:
                ori.w   #(button_left_mask<<8)|button_left_mask,d1
                move.w  d1,(Ctrl_1_logical).w
                rts
; ---------------------------------------------------------------------------

DEZMini_CenterPlayerAndTryExplosions:
                move.w  d0,x_pos(a1)
                move.l  #DEZMini_WaitThenOpenCameraY,(a0)
                jsr     Stop_Object(pc)
                clr.w   (Ctrl_1_logical).w
                move.w  #$1F,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   DEZMini_TrySecondExplosionController
                move.l  #Obj_CreateBossExplosion,(a1)
                move.w  #$100,x_pos(a1)
                move.w  #$760,y_pos(a1)
                move.b  #$14,subtype(a1)

DEZMini_TrySecondExplosionController:
                jsr     (AllocateObject).l
                bne.s   DEZMini_ExplosionSpawnReturn
                move.l  #Obj_CreateBossExplosion,(a1)
                move.w  #$180,x_pos(a1)
                move.w  #$760,y_pos(a1)
                move.b  #$14,subtype(a1)

DEZMini_ExplosionSpawnReturn:
                rts
; ---------------------------------------------------------------------------

DEZMini_WaitThenOpenCameraY:
                subq.w  #1,$2E(a0)
                bpl.s   DEZMini_CameraOpeningDelayReturn
                move.l  #DEZMini_WaitGroundedAtSceneHeight,(a0)
                st      (Events_fg_4).w
                move.w  #0,(Camera_stored_min_Y_pos).w
                jsr     (AllocateObject).l
                bne.s   DEZMini_TryCameraMaxYExpansion
                move.l  #Obj_DecLevStartYGradual,(a1)

DEZMini_TryCameraMaxYExpansion:
                move.w  #$2000,(Camera_stored_max_Y_pos).w
                jsr     (AllocateObject).l
                bne.s   DEZMini_PlayCameraOpeningRumble
                move.l  #Obj_IncLevEndYGradual,(a1)

DEZMini_PlayCameraOpeningRumble:
                moveq   #signextendB(sfx_BigRumble),d0
                jsr     (Play_SFX).l

DEZMini_CameraOpeningDelayReturn:
                rts
; ---------------------------------------------------------------------------

DEZMini_WaitGroundedAtSceneHeight:
                lea     (Player_1).w,a1
                cmpi.w  #$360,y_pos(a1)
                blo.s   DEZMini_GroundingGateReturn
                btst    #1,status(a1)
                bne.s   DEZMini_GroundingGateReturn
                move.l  #DEZMini_AcceleratePlayerSpin,(a0)
                move.b  #$83,object_control(a1)
                move.b  #0,anim(a1)
                jsr     (Stop_Object).l
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_Facing,status(a1)
                bclr    #0,render_flags(a1)

DEZMini_GroundingGateReturn:
                rts
; ---------------------------------------------------------------------------

DEZMini_AcceleratePlayerSpin:
                addq.w  #8,$1C(a0)
                cmpi.w  #$300,$1C(a0)
                bne.s   DEZMini_AdvancePlayerSpin
                move.l  #DEZMini_WaitAndPreparePlayerLaunch,(a0)
                move.w  #$24,$2E(a0)
                bclr    #7,(Player_1+art_tile).w

DEZMini_AdvancePlayerSpin:
                bra.w   DEZPostBoss_AdvancePlayerSpin
; ---------------------------------------------------------------------------

DEZMini_WaitAndPreparePlayerLaunch:
                subq.w  #1,$2E(a0)
                bpl.s   DEZMini_LiftPlayerAndSpin
                move.l  #DEZMini_SpinInFlightToApex,(a0)
                move.w  #-$1000,y_vel(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                moveq   #signextendB(sfx_SuperTransform),d0
                jsr     (Play_SFX).l

DEZMini_LiftPlayerAndSpin:
                subi.w  #$10,(Player_1+y_pos).w
                bra.w   DEZPostBoss_AdvancePlayerSpin
; ---------------------------------------------------------------------------

DEZMini_SpinInFlightToApex:
                bsr.w   DEZPostBoss_AdvancePlayerSpin
                tst.w   y_vel(a0)
                bmi.s   DEZMini_MovePlayerFlightAndLand
                move.l  #DEZMini_MovePlayerFlightAndLand,(a0)
                jsr     (Ending_SetP1PoseAndLoadArt).l
                lea     (Player_1).w,a1
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                move.w  #5<<8,anim(a1)                  ; and prev_anim

DEZMini_MovePlayerFlightAndLand:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   DEZMini_SyncPlayerToSceneProxy
                move.w  #$3AC,d0
                cmpi.w  #2,(Player_mode).w
                bne.s   DEZMini_ClampLandingAndTryTitleCard
                move.w  #$3B0,d0

DEZMini_ClampLandingAndTryTitleCard:
                cmp.w   y_pos(a0),d0
                bhi.s   DEZMini_SyncPlayerToSceneProxy
                move.w  d0,y_pos(a0)
                move.l  #DEZMini_WaitBeforeControlRestore,(a0)
                move.w  #(2*60)-1,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   DEZMini_SyncPlayerToSceneProxy
                move.l  #Obj_TitleCard,(a1)
                st      $3E(a1)

DEZMini_SyncPlayerToSceneProxy:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                rts
; ---------------------------------------------------------------------------

DEZMini_WaitBeforeControlRestore:
                subq.w  #1,$2E(a0)
                bpl.w   DEZMinibossAndScene_SharedReturn
                lea     (Pal_DEZMiniboss2).l,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

DEZMini_RestorePaletteAndControls:
                move.l  (a1)+,(a2)+
                dbf     d6,DEZMini_RestorePaletteAndControls
                clr.b   (Player_1+object_control).w
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_InitPlatformSeparation:
                lea     DEZMini_OrbitPlatformAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                addi.w  #$C,y_pos(a0)
                move.b  #0,child_dx(a0)
                move.b  #$C,child_dy(a0)
                move.w  #-$200,d0
                moveq   #-$40,d1
                tst.b   subtype(a0)
                beq.s   DEZMini_SetPlatformSeparationMotion
                neg.w   d0
                moveq   #$40,d1

DEZMini_SetPlatformSeparationMotion:
                move.w  d0,x_vel(a0)
                move.b  d1,$3C(a0)
                move.w  #$1F,$2E(a0)
                move.l  #DEZMini_InstallPlatformSideHandler,$34(a0)
                move.l  #DEZMini_MoveDuringSeparationWait,(a0)
                lea     DEZMini_PlatformContactChild(pc),a2
                jsr     CreateChild1_Normal(pc)

DEZMini_MoveDuringSeparationWait:
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                bra.w   DEZMini_ResolvePlatformTopSolid
; ---------------------------------------------------------------------------

DEZMini_InstallPlatformSideHandler:
                move.l  #DEZMini_CheckExpansionAndAlignment,(a0)
                tst.b   subtype(a0)
                beq.s   DEZMini_PlatformLinkInitReturn
                move.l  #DEZMini_LinkedPlatformCheckCatch,(a0)
                movea.w parent3(a0),a1
                move.w  a0,$44(a1)
                move.w  $44(a0),parent3(a0)

DEZMini_PlatformLinkInitReturn:
                rts
; ---------------------------------------------------------------------------

DEZMini_LinkedPlatformCheckCatch:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.s   DEZMinibossPlatform_BeginRadialExpansion
                bclr    #3,$38(a0)
                bne.w   DEZMini_StopAndWaitForBossJump
                bra.w   DEZMini_SyncPlatformOrbitPhase
; ---------------------------------------------------------------------------

DEZMini_CheckExpansionAndAlignment:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.s   DEZMinibossPlatform_BeginRadialExpansion
                btst    #3,$38(a1)
                bne.s   DEZMini_BeginAlignmentSearch

DEZMini_AdvanceOrbitAndProject:
                bsr.w   DEZMiniPlatform_AccelAndStepAngle
                bra.w   DEZMini_SyncPlatformOrbitPhase
; ---------------------------------------------------------------------------

DEZMinibossPlatform_BeginRadialExpansion:
                move.l  #DEZMini_GrowPlatformOrbitRadius,(a0)
                move.w  #$4000,$3A(a0)
                bra.s   DEZMini_AdvanceOrbitAndProject
; ---------------------------------------------------------------------------

DEZMini_BeginAlignmentSearch:
                move.l  #DEZMini_SeekPhaseWindow,(a0)
                bra.s   DEZMini_AdvanceOrbitAndProject
; ---------------------------------------------------------------------------

DEZMini_SeekPhaseWindow:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.s   DEZMinibossPlatform_BeginRadialExpansion
                bsr.w   DEZMiniPlatform_AccelAndStepAngle
                movea.w parent3(a0),a1
                move.b  $3C(a0),d0
                tst.w   $3C(a1)
                bmi.s   DEZMini_CheckNegativeStepWindow
                subi.b  #$40,d0
                cmpi.b  #$10,d0
                bls.s   DEZMini_BeginAlignmentBraking
                bra.w   DEZMini_ProjectAlignmentPhase
; ---------------------------------------------------------------------------

DEZMini_CheckNegativeStepWindow:
                subi.b  #$30,d0
                cmpi.b  #$10,d0
                bhi.s   DEZMini_ProjectAlignmentPhase

DEZMini_BeginAlignmentBraking:
                move.l  #DEZMini_BrakeTowardQuarterTurn,(a0)

DEZMini_ProjectAlignmentPhase:
                bra.w   DEZMini_SyncPlatformOrbitPhase
; ---------------------------------------------------------------------------

DEZMini_BrakeTowardQuarterTurn:
                movea.w parent3(a0),a1
                move.w  $3C(a0),d0
                btst    #7,$38(a1)
                bne.s   DEZMinibossPlatform_BeginRadialExpansion
                move.w  $3A(a1),d1
                move.w  $3C(a1),d2
                bmi.s   DEZMini_BrakeNegativeAlignmentStep
                subi.w  #$100,d1
                add.w   d1,d0
                tst.w   d1
                bpl.s   DEZMini_StoreAlignmentStep
                cmpi.w  #$4000,d0
                blo.s   DEZMini_ClampPhaseAndSignalLink
                bra.w   DEZMini_StoreAlignmentStep
; ---------------------------------------------------------------------------

DEZMini_BrakeNegativeAlignmentStep:
                addi.w  #$100,d1
                add.w   d1,d0
                tst.w   d1
                bmi.s   DEZMini_StoreAlignmentStep
                cmpi.w  #$4000,d0
                bhi.s   DEZMini_ClampPhaseAndSignalLink

DEZMini_StoreAlignmentStep:
                move.w  d0,$3C(a0)
                move.w  d1,$3A(a1)
                bra.w   DEZMini_SyncPlatformOrbitPhase
; ---------------------------------------------------------------------------

; Set phase $4000 and notify the linked platform that alignment is complete
DEZMini_ClampPhaseAndSignalLink:
                move.w  #$4000,d0
                move.w  d0,$3C(a0)
                move.w  d1,$3A(a1)
                bclr    #3,$38(a1)
                movea.w $44(a0),a2
                bset    #3,$38(a2)

DEZMini_StopAndWaitForBossJump:
                move.l  #DEZMini_CheckJumpBeforeCatchWait,(a0)
                clr.w   x_vel(a0)
                bra.w   DEZMini_SyncPlatformOrbitPhase
; ---------------------------------------------------------------------------

DEZMini_CheckJumpBeforeCatchWait:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   DEZMini_DrawWhileAwaitingJump
                move.l  #DEZMini_TickBeforeCatchLaunch,(a0)
                move.w  #7,$2E(a0)

DEZMini_DrawWhileAwaitingJump:
                bra.w   DEZMini_ResolvePlatformTopSolid
; ---------------------------------------------------------------------------

DEZMini_TickBeforeCatchLaunch:
                subq.w  #1,$2E(a0)
                bpl.s   DEZMinibossPlatform_DrawDuringCatchDelay
                move.l  #DEZMini_RiseToBossCatchHeight,(a0)
                move.w  #-$400,y_vel(a0)

DEZMinibossPlatform_DrawDuringCatchDelay:
                bra.w   DEZMini_ResolvePlatformTopSolid
; ---------------------------------------------------------------------------

DEZMini_RiseToBossCatchHeight:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                addi.w  #$C,d0
                tst.w   y_vel(a0)
                bpl.s   DEZMini_ClampCatchAndClearJump
                cmp.w   y_pos(a0),d0
                blo.s   DEZMini_DrawAfterCatchMove

DEZMini_ClampCatchAndClearJump:
                move.w  d0,y_pos(a0)
                move.l  #DEZMini_WaitBossReturnOrExpansion,(a0)
                bclr    #2,$38(a1)

DEZMini_DrawAfterCatchMove:
                bra.w   DEZMini_ResolvePlatformTopSolid
; ---------------------------------------------------------------------------

DEZMini_WaitBossReturnOrExpansion:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.w   DEZMinibossPlatform_BeginRadialExpansion
                btst    #6,$38(a1)
                beq.s   DEZMini_ProjectPlatformDuringHold
                bsr.w   DEZMiniPlatform_RestoreIdleBySide

DEZMini_ProjectPlatformDuringHold:
                bra.w   DEZMini_SyncPlatformOrbitPhase
