; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace encounter aftermath, ship theft sequence and scripted player guidance through the scene
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

HPZKnux_WaitForGuideRumbleSignal:
                tst.b   (TailsChaseOrHPZAftermathLatch).w
                bne.s   HPZKnux_StartRumbleAndExpandCamera
                rts
; ---------------------------------------------------------------------------

HPZKnux_FinishLandingAndWaitForGuide:
                move.b  #$42,routine(a0)
                rts
; ---------------------------------------------------------------------------

HPZKnux_TickRumbleDelay:
                subq.w  #1,$2E(a0)
                bmi.s   HPZKnux_TryRumblePlatformAndSetEvent
                rts
; ---------------------------------------------------------------------------

HPZKnux_StartRumbleAndExpandCamera:
                move.b  #$44,routine(a0)
                move.w  #$10,$2E(a0)
                clr.b   (Scroll_lock).w
                move.w  #$5C0,d0
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  d0,(Camera_stored_max_Y_pos).w
                moveq   #signextendB(sfx_BigRumble),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   HPZKnux_TryTwoRumbleExplosions
                move.l  #Obj_IncLevEndYGradual,(a1)

; The call returns to the same spawn entry, so execution falls through into the second attempt
HPZKnux_TryTwoRumbleExplosions:
                bsr.w   HPZKnux_TryFixedRumbleExplosion

HPZKnux_TryFixedRumbleExplosion:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   HPZKnux_RumbleExplosionReturn
                move.b  #$14,subtype(a1)
                move.w  #$1880,x_pos(a1)
                move.w  #$3D0,y_pos(a1)

HPZKnux_RumbleExplosionReturn:
                rts
; ---------------------------------------------------------------------------

HPZKnux_FallAndCheckRumbleFloor:
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   HPZKnux_LandAndInstallPause
                rts
; ---------------------------------------------------------------------------

HPZKnux_TryRumblePlatformAndSetEvent:
                move.b  #$46,routine(a0)
                move.b  #2,mapping_frame(a0)
                st      (Events_fg_4).w
                move.w  #$14,(Screen_shake_flag).w
                lea     SKHpzEscape_PlatformSpawnList(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

HPZKnux_AnimateRumbleLanding:
                jmp     (Animate_Raw2MultiDelay).l
; ---------------------------------------------------------------------------

HPZKnux_LandAndInstallPause:
                add.w   d1,y_pos(a0)
                move.b  #$48,routine(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.l  #HPZKnux_BeginPauseAndTryDizzyChild,$34(a0)
                lea     SKSceneAnim_HPZGrabFloorRecovery(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_AnimateExtendedPause:
                jmp     (Animate_Raw2MultiDelay).l
; ---------------------------------------------------------------------------

HPZKnux_BeginPauseAndTryDizzyChild:
                move.b  #$4A,routine(a0)
                move.l  #HPZKnux_RestoreNormalMapAndPausePose,$34(a0)
                lea     SKSceneAnim_HPZSecondRecoveryGrab(pc),a1
                jsr     (Set_Raw_Animation).l
                lea     SKHpzKnuckles_DizzyStarsSpawnList(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

HPZKnux_TickPoseResetDelay:
                subq.w  #1,$2E(a0)
                bmi.s   HPZKnux_BeginNormalLeftRun
                rts
; ---------------------------------------------------------------------------

HPZKnux_RestoreNormalMapAndPausePose:
                move.b  #$4C,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$56,mapping_frame(a0)
                move.w  #7,$2E(a0)
                rts
; ---------------------------------------------------------------------------

HPZKnux_AccelerateLeftToWorldX:
                jsr     (Animate_RawCheckResult).l
                subi.w  #$C,x_vel(a0)
                jsr     (MoveSprite2).l
                cmpi.w  #$1810,x_pos(a0)
                bls.s   HPZKnux_BeginGrabAndSetRetreat
                rts
; ---------------------------------------------------------------------------

HPZKnux_BeginNormalLeftRun:
                move.b  #$4E,routine(a0)
                bset    #0,render_flags(a0)
                clr.w   x_vel(a0)
                lea     SKKnucklesCutscene_SharedTravelBodyLoop(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_AnimateGrabUntilRetreat:
                jmp     (Animate_Raw2MultiDelay).l
; ---------------------------------------------------------------------------

HPZKnux_BeginGrabAndSetRetreat:
                move.b  #$50,routine(a0)
                bclr    #0,render_flags(a0)
                move.w  #2,$44(a0)
                move.l  #Map_HPZKnucklesGrab,mappings(a0)
                move.b  #$E,mapping_frame(a0)
                move.l  #HPZKnux_BeginNormalMapRetreatPose,$34(a0)
                lea     SKSceneAnim_HPZGrabFrames14To18(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_AnimateRetreatAndSignalPlatform:
                jsr     (Animate_Raw2MultiDelay).l
                beq.s   HPZKnux_RetreatPoseReturn
                cmpi.b  #6,anim_frame(a0)
                bne.w   HPZKnux_RetreatPoseReturn
                st      (ZoneEventLatchOrBossReleaseSignal).w
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l

HPZKnux_RetreatPoseReturn:
                rts
; ---------------------------------------------------------------------------

HPZKnux_BeginNormalMapRetreatPose:
                move.b  #$52,routine(a0)
                bset    #0,render_flags(a0)
                move.l  #HPZKnux_BeginLeftRunAfterRetreatPose,$34(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$56,mapping_frame(a0)
                lea     SKSceneAnim_HPZPostGrabCollapse(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_RetreatRunToCameraLeft:
                jsr     (Animate_RawCheckResult).l
                subi.w  #$C,x_vel(a0)
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                subi.w  #$40,d0
                cmp.w   x_pos(a0),d0
                bhs.s   HPZKnux_RelocateAndTryCameraExpansion
                rts
; ---------------------------------------------------------------------------

HPZKnux_BeginLeftRunAfterRetreatPose:
                move.b  #$54,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #7,mapping_frame(a0)
                clr.w   x_vel(a0)
                lea     SKKnucklesCutscene_SharedTravelBodyLoop(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_AnimateTiredAndCheckDeparture:
                jsr     (Animate_RawMultiDelay).l
                btst    #6,(SceneSyncFlagsOrMHZState).w
                bne.w   HPZKnux_LaunchFinalJumpOnSignal
                rts
; ---------------------------------------------------------------------------

HPZKnux_RelocateAndTryCameraExpansion:
                move.b  #$56,routine(a0)
                move.w  #4,$44(a0)
                move.l  #Map_SSZKnucklesTired,mappings(a0)
                clr.b   mapping_frame(a0)
                bclr    #0,render_flags(a0)
                move.w  #$161C,x_pos(a0)
                move.w  #$62C,y_pos(a0)
                move.w  #$1520,(Camera_stored_min_X_pos).w
                jsr     (AllocateObject).l
                bne.s   HPZKnux_InstallTiredWait
                move.l  #Obj_DecLevStartXGradual,(a1)

HPZKnux_InstallTiredWait:
                lea     SKSszHpzKnuckles_TiredBodyTimedLoop(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_UpdateFinalJumpToWorldX:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                cmpi.w  #$15C0,x_pos(a0)
                bls.s   HPZKnux_ClampFinalJumpAndSetTiredMap
                rts
; ---------------------------------------------------------------------------

HPZKnux_LaunchFinalJumpOnSignal:
                move.b  #$58,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$9A,mapping_frame(a0)
                move.w  #-$1E0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                lea     SKSceneAnim_KnuxJumpAndFastTravel(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_AnimateTiredAndWaitForBeam:
                btst    #7,(SceneSyncFlagsOrMHZState).w
                bne.s   HPZKnux_SetTerminalNormalMapAnim
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

HPZKnux_ClampFinalJumpAndSetTiredMap:
                move.b  #$5A,routine(a0)
                move.w  #$15C0,x_pos(a0)
                move.w  #$600,y_pos(a0)
                move.w  #4,$44(a0)
                move.l  #Map_SSZKnucklesTired,mappings(a0)
                clr.b   mapping_frame(a0)
                bclr    #0,render_flags(a0)
                lea     SKSszHpzKnuckles_TiredBodyTimedLoop(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_AnimateTerminalWait:
                jmp     (Animate_RawCheckResult).l
; ---------------------------------------------------------------------------

HPZKnux_SetTerminalNormalMapAnim:
                move.b  #$5C,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$9A,mapping_frame(a0)
                lea     SKSceneAnim_KnuxJumpAndFastTravel(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_InitDustAndCheckDashGate:
                lea     SKHpzKnuckles_FollowingDustAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.w   CutsceneKnux_Delete
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                bclr    #0,render_flags(a0)
                btst    #0,render_flags(a1)
                beq.s   HPZKnux_AnimateDustAndQueueArt
                bset    #0,render_flags(a0)

HPZKnux_AnimateDustAndQueueArt:
                lea     SKHpzKnuckles_FollowingDustFrameLoop(pc),a1
                jsr     (Animate_RawNoSST).l
                bsr.w   HPZKnucklesDustQueueDPLCWhenFrameChanges
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZKnux_GuideWaitForTriggerAndLock:
                lea     (Player_1).w,a1
                cmpi.w  #$14D0,x_pos(a1)
                blo.s   HPZKnux_GuideTriggerReturn
                move.l  #HPZKnux_GuideRunP1ToStagingX,(a0)
                jsr     (Stop_Object).l
                st      (Ctrl_1_locked).w
                clr.w   (Ctrl_1_logical).w
                jsr     (AllocateObject).l
                bne.s   HPZKnux_GuideSetCameraBottom
                move.l  #SKInput_LockP2IfActive,(a1)

HPZKnux_GuideSetCameraBottom:
                move.w  #$300,(Camera_target_max_Y_pos).w

HPZKnux_GuideTriggerReturn:
                rts
; ---------------------------------------------------------------------------

HPZKnux_GuideRunP1ToStagingX:
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.w   SKAIZScene_SharedSceneReturn
                move.w  #(button_right_mask<<8)|button_right_mask,(Ctrl_1_logical).w
                cmpi.w  #$15A8,x_pos(a1)
                blo.w   SKAIZScene_SharedSceneReturn
                move.l  #HPZKnux_GuideScrollAndSignalShip,(a0)
                st      (Scroll_lock).w
                jsr     (AllocateObject).l
                bne.s   HPZKnux_GuideUnlockAndForcePose
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

HPZKnux_GuideUnlockAndForcePose:
                lea     (Player_1).w,a1
                clr.b   (Ctrl_1_locked).w
                move.b  #$83,object_control(a1)
                move.b  #$C4,mapping_frame(a1)
                cmpi.b  #1,character_id(a1)
                bne.s   HPZKnux_GuideStopP1AndLoadArt
                move.b  #$B0,mapping_frame(a1)

HPZKnux_GuideStopP1AndLoadArt:
                move.b  #7,anim(a1)
                clr.w   (Ctrl_1_logical).w
                jsr     (Stop_Object).l
                jmp     (Player_Load_PLC).l
; ---------------------------------------------------------------------------

HPZKnux_GuideScrollAndSignalShip:
                move.w  (Camera_X_pos).w,d0
                addq.w  #2,d0
                move.w  d0,(Camera_X_pos).w
                cmpi.w  #$1580,d0
                blo.s   SKHPZGuide_ReturnAfterStagingCameraStep
                move.l  #HPZKnux_GuideWaitForApproach,(a0)
                bset    #0,(SceneSyncFlagsOrMHZState).w

SKHPZGuide_ReturnAfterStagingCameraStep:
                rts
; ---------------------------------------------------------------------------

HPZKnux_GuideWaitForApproach:
                btst    #1,(SceneSyncFlagsOrMHZState).w
                beq.s   HPZKnux_GuideApproachReturn
                move.l  #HPZKnux_GuideCapP1RunSpeed,(a0)
                lea     (Player_1).w,a1
                move.b  #0,object_control(a1)
                st      (Ctrl_1_locked).w
                move.w  #(button_right_mask<<8)|button_right_mask,(Ctrl_1_logical).w

HPZKnux_GuideApproachReturn:
                rts
; ---------------------------------------------------------------------------

HPZKnux_GuideCapP1RunSpeed:
                lea     (Player_1).w,a1
                move.w  x_vel(a1),d0
                cmpi.w  #$300,d0
                bls.s   HPZKnux_GuideRunCameraAndSetBounds
                move.w  #$300,d0

HPZKnux_GuideRunCameraAndSetBounds:
                move.w  d0,x_vel(a1)
                move.w  d0,ground_vel(a1)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,(Camera_X_pos).w
                move.w  #$17D0,d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   HPZKnux_GuideCameraRunReturn
                move.l  #HPZKnux_GuideWaitForLandingAndLock,(a0)
                move.w  d0,(Camera_X_pos).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                move.w  (Camera_max_Y_pos).w,(Camera_min_Y_pos).w
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w

HPZKnux_GuideCameraRunReturn:
                rts
; ---------------------------------------------------------------------------

HPZKnux_GuideWaitForLandingAndLock:
                btst    #5,(SceneSyncFlagsOrMHZState).w
                beq.s   HPZKnux_GuideLandingWaitReturn
                move.l  #HPZKnux_GuideWaitForGroundedP1,(a0)
                st      (Ctrl_1_locked).w
                jsr     (AllocateObject).l
                bne.s   HPZKnux_GuideLandingWaitReturn
                move.l  #SKInput_LockP2IfActive,(a1)

HPZKnux_GuideLandingWaitReturn:
                rts
; ---------------------------------------------------------------------------

HPZKnux_GuideWaitForGroundedP1:
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   SKHPZGuide_ReturnAfterGroundedGate
                move.l  #HPZKnux_GuideChooseInputTowardTarget,(a0)

SKHPZGuide_ReturnAfterGroundedGate:
                rts
; ---------------------------------------------------------------------------

HPZKnux_GuideChooseInputTowardTarget:
                lea     (Player_1).w,a1
                move.w  #(button_right_mask<<8)|button_right_mask,d0
                move.w  x_pos(a1),d1
                subi.w  #$1892,d1
                bcs.s   HPZKnux_GuideApplyInputAndMeasureGap
                move.w  #(button_left_mask<<8)|button_left_mask,d0

HPZKnux_GuideApplyInputAndMeasureGap:
                move.w  d0,(Ctrl_1_logical).w
                tst.w   d1
                bpl.s   HPZKnux_GuideStopP1AndSignalRumble
                neg.w   d1

HPZKnux_GuideStopP1AndSignalRumble:
                cmpi.w  #4,d1
                bhi.w   SKAIZScene_SharedSceneReturn
                move.l  #HPZKnux_GuideWaitThenFaceP1Left,(a0)
                move.w  #$3F,$2E(a0)
                st      (TailsChaseOrHPZAftermathLatch).w
                clr.w   (Ctrl_1_logical).w
                jsr     (Stop_Object).l
                jmp     (Player_Load_PLC).l
; ---------------------------------------------------------------------------

HPZKnux_GuideWaitThenFaceP1Left:
                subq.w  #1,$2E(a0)
                bpl.s   SKHPZGuide_ReturnAfterFacingDelayGate
                move.l  #HPZKnux_GuideUnlockP1AfterLanding,(a0)
                lea     (Player_1).w,a1
                bset    #0,render_flags(a1)
                bset    #Status_Facing,status(a1)

SKHPZGuide_ReturnAfterFacingDelayGate:
                rts
; ---------------------------------------------------------------------------

HPZKnux_GuideUnlockP1AfterLanding:
                lea     (Player_1).w,a1
                cmpi.w  #$580,y_pos(a1)
                blo.s   HPZKnux_GuideUnlockReturn
                btst    #Status_InAir,status(a1)
                bne.s   HPZKnux_GuideUnlockReturn
                move.l  #HPZKnux_GuideUnlockP2AtXThreshold,(a0)
                clr.b   (Ctrl_1_locked).w
                move.w  #$5C0,(Camera_min_Y_pos).w

HPZKnux_GuideUnlockReturn:
                rts
; ---------------------------------------------------------------------------

HPZKnux_GuideUnlockP2AtXThreshold:
                lea     (Player_1).w,a1
                cmpi.w  #$1660,x_pos(a1)
                bhs.w   SKAIZScene_SharedSceneReturn
                move.l  #SKHPZGuide_PersistentTerminalNoop,(a0)
                clr.b   (Ctrl_2_locked).w
                rts
; ---------------------------------------------------------------------------

SKHPZGuide_PersistentTerminalNoop:
                rts
