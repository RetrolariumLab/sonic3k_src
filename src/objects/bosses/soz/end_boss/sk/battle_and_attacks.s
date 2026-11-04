; Owner: objects/bosses/soz/end_boss/sk
; Responsibility: Sandopolis end-boss body, attached actors, attack state, player interaction and defeat progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZEndBoss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SOZEndBoss_Index(pc,d0.w),d1
                jsr     SOZEndBoss_Index(pc,d1.w)
                move.w  x_pos(a0),(Events_bg+$0C).w
                move.w  y_pos(a0),(Events_bg+$0E).w
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
SOZEndBoss_Index:
                dc.w    SOZBoss_InitShipAndBody-SOZEndBoss_Index
                dc.w    SOZBoss_WaitForPlayerXProximity-SOZEndBoss_Index
                dc.w    SOZBoss_TickIntroAndStartMusic-SOZEndBoss_Index
                dc.w    SOZBoss_MoveAndBobBeforePose-SOZEndBoss_Index
                dc.w    SOZBoss_MoveBobAndAdvancePose-SOZEndBoss_Index
                dc.w    SOZBoss_TickHoldAndTurnPose-SOZEndBoss_Index
                dc.w    SOZBoss_HoldExposedUntilRecovery-SOZEndBoss_Index
; ---------------------------------------------------------------------------

SOZBoss_InitShipAndBody:
                lea     ObjDat_SOZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                move.w  y_pos(a0),$3A(a0)
                move.w  #$C0,(SceneTimerOrSharedMotionRecordBase).w
                lea     (ArtKosM_SOZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_SOZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_6D,d0
                jsr     (Load_PLC).l
                lea     Pal_SOZEndBoss1(pc),a1
                jsr     (PalLoad_Line1).l
                lea     (Pal_SOZEndBoss2).l,a1
                lea     (Normal_palette_line_4).w,a2
                moveq   #bytesToLcnt($20),d6

SOZBoss_CopyPaletteAndSpawnBodyGroups:
                move.l  (a1)+,(a2)+
                dbf     d6,SOZBoss_CopyPaletteAndSpawnBodyGroups
                lea     SOZEndBoss_SixDistinctRootNormalChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     SOZEndBoss_ThreeFrontLinkedBodyActors(pc),a2
                jsr     (CreateChild8_TreeListRepeated).l
                lea     SOZEndBoss_ThreeRearLinkedBodyActors(pc),a2
                jmp     (CreateChild8_TreeListRepeated).l
; ---------------------------------------------------------------------------

SOZBoss_WaitForPlayerXProximity:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                cmpi.w  #$C0,d2
                bhs.s   SOZBoss_PlayerProximityReturn
                move.b  #4,routine(a0)
                move.w  #60-1,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l

SOZBoss_PlayerProximityReturn:
                rts
; ---------------------------------------------------------------------------

SOZBoss_TickIntroAndStartMusic:
                subq.w  #1,$2E(a0)
                bpl.w   SOZBoss_SharedActorReturn
                move.b  #6,routine(a0)
                moveq   #signextendB(mus_EndBoss),d0
                jsr     (Play_Music).l
                move.b  #mus_EndBoss,(Current_music+1).w

SOZBoss_ChooseMotionProfile:
                lea     SOZEndBoss_DefaultSixWordMotionProfile(pc),a1
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   SOZBoss_LoadMotionProfile
                lea     SOZEndBoss_KnucklesSixWordMotionProfile(pc),a1

; The fourth word seeds both the active timer and its saved value
SOZBoss_LoadMotionProfile:
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,$3E(a0)
                move.w  (a1)+,$40(a0)
                move.w  (a1),$30(a0)
                move.w  (a1)+,$2E(a0)
                move.w  (a1)+,$32(a0)
                move.w  (a1)+,$46(a0)
                rts
; ---------------------------------------------------------------------------
SOZEndBoss_DefaultSixWordMotionProfile:
                dc.w    -$40,  $100,  -$80,   $3F,   $7F,   $1F
SOZEndBoss_KnucklesSixWordMotionProfile:
                dc.w    -$80,  $200, -$100,   $1F,   $3F,   $1F
; ---------------------------------------------------------------------------

SOZBoss_MoveAndBobBeforePose:
                jsr     (MoveSprite2).l
                bsr.w   UpdateSOZEndBossSineBobFromAngleStep
                subq.w  #1,$2E(a0)
                bpl.s   SOZEndBoss_ReturnAfterInitialTravelTimer
                move.b  #8,routine(a0)
                move.w  $30(a0),$2E(a0)

SOZEndBoss_ReturnAfterInitialTravelTimer:
                rts
; ---------------------------------------------------------------------------

SOZBoss_MoveBobAndAdvancePose:
                bsr.w   TickSOZEndBossChargeAttackSpawnTimer
                jsr     (MoveSprite2).l
                bsr.w   UpdateSOZEndBossSineBobFromAngleStep
                move.w  $3C(a0),d0
                add.w   $40(a0),d0
                move.w  d0,$3C(a0)
                subq.w  #1,$2E(a0)
                bpl.s   SOZBoss_MovingPoseReturn
                move.b  #$A,routine(a0)
                move.w  $46(a0),$2E(a0)
                move.w  #$14,(Screen_shake_flag).w
                moveq   #signextendB(sfx_ThumpBoss),d0
                jsr     (Play_SFX).l

SOZBoss_MovingPoseReturn:
                rts
; ---------------------------------------------------------------------------

SOZBoss_TickHoldAndTurnPose:
                bsr.w   TickSOZEndBossChargeAttackSpawnTimer
                subq.w  #1,$2E(a0)
                bpl.s   SOZBoss_PoseHoldReturn
                move.b  #8,routine(a0)
                bsr.w   SOZBoss_TryReloadMotionAtBounds
                neg.b   $3E(a0)
                neg.w   $40(a0)
                move.w  $32(a0),$2E(a0)

SOZBoss_PoseHoldReturn:
                rts
; ---------------------------------------------------------------------------

SOZBoss_HoldExposedUntilRecovery:
                tst.w   (Events_bg+$0A).w
                beq.s   SOZBoss_RestoreRoutineAndNormalColors
                bra.w   SOZBoss_CheckExposedHitOrDefeat
; ---------------------------------------------------------------------------

SOZBoss_RestoreRoutineAndNormalColors:
                move.b  $42(a0),routine(a0)
                clr.b   collision_flags(a0)
                moveq   #0,d0
                bra.w   SOZBoss_CopyPalette3Of5
; ---------------------------------------------------------------------------

SOZBoss_BeginDefeatDropAndRelease:
                move.l  #SOZBoss_DropWithLightGravity,(a0)
                bset    #4,$38(a0)
                bset    #7,art_tile(a0)
                clr.w   x_vel(a0)
                rts
; ---------------------------------------------------------------------------

SOZBoss_DropWithLightGravity:
                jsr     (MoveSprite_LightGravity).l
                cmpi.w  #$200,y_vel(a0)
                blt.s   SOZBoss_DrawDefeatedDrop
                move.l  #SOZBoss_RiseAndTryCapsule,(a0)
                bclr    #7,status(a0)
                bset    #0,render_flags(a0)

SOZBoss_DrawDefeatedDrop:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SOZBoss_RiseAndTryCapsule:
                addi.w  #-$40,y_vel(a0)
                jsr     (MoveSprite2).l
                cmpi.w  #-$100,y_vel(a0)
                bgt.s   SOZBoss_DrawDefeatedRise
                move.l  #SOZBoss_SwingRiseAndEscape,(a0)
                jsr     (Swing_Setup1).l
                jsr     (AllocateObject).l
                bne.s   SOZBoss_ClearReleaseAndTryFlame
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$5360,x_pos(a1)
                move.w  #$720,y_pos(a1)

SOZBoss_ClearReleaseAndTryFlame:
                bclr    #4,$38(a0)
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     (CreateChild1_Normal).l

SOZBoss_DrawDefeatedRise:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SOZBoss_SwingRiseAndEscape:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                jsr     (Swing_UpAndDown).l
                subq.w  #1,y_pos(a0)
                move.w  x_vel(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$400,d0
                bls.s   SOZBoss_MoveAndCheckRightExit
                move.w  #$400,d0

SOZBoss_MoveAndCheckRightExit:
                move.w  d0,x_vel(a0)
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$1A0,d0
                cmp.w   x_pos(a0),d0
                blo.s   SOZBoss_HideShipAndWaitCapsule
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SOZBoss_HideShipAndWaitCapsule:
                move.l  #SOZBoss_WaitCapsuleAndRestoreControls,(a0)
                st      (ActCompletionHandshake).w
                ori.b   #$30,$38(a0)
                bclr    #7,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

SOZBoss_WaitCapsuleAndRestoreControls:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (ActCompletionHandshake).w
                bne.w   SOZBoss_SharedActorReturn
                move.l  #SOZBoss_HoldExitMaxYAndRoutePlayer,(a0)
                jsr     (Restore_PlayerControl).l
                jsr     (Restore_LevelMusic).l
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                clr.w   $2E(a0)
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                jsr     (AllocateObject).l
                bne.s   SOZEndBoss_AttemptPartnerInputLockHelper
                move.l  #SOZBoss_WaitFallAndTakeP2Control,(a1)

SOZEndBoss_AttemptPartnerInputLockHelper:
                jsr     (AllocateObject).l
                bne.s   SOZBoss_SetExitCameraBounds
                move.l  #SKInput_LockP2IfActive,(a1)

SOZBoss_SetExitCameraBounds:
                move.w  #-$100,(Camera_min_Y_pos).w
                move.w  #$800,(Camera_target_max_Y_pos).w
                move.w  #$5440,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   SOZBoss_ExitCameraSpawnReturn
                move.l  #Obj_IncLevEndXGradual,(a1)

SOZBoss_ExitCameraSpawnReturn:
                rts
; ---------------------------------------------------------------------------

SOZBoss_HoldExitMaxYAndRoutePlayer:
                cmpi.w  #$700,(Camera_target_max_Y_pos).w
                blo.s   SOZBoss_WalkPlayerToHandoff
                move.w  #$800,(Camera_max_Y_pos).w

SOZBoss_WalkPlayerToHandoff:
                lea     (Player_1).w,a1
                cmpi.w  #$5468,x_pos(a1)
                bhs.s   SOZBoss_CapturePlayerAndChooseExit
                jmp     (SKInput_BuildAutoRightAndJump).l
; ---------------------------------------------------------------------------

SOZBoss_CapturePlayerAndChooseExit:
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.w  x_vel(a1),x_vel(a0)
                clr.w   y_vel(a0)
                cmpi.b  #2,character_id(a1)
                beq.s   SOZBoss_BeginKnucklesHorizontalExit
                move.l  #SOZBoss_CarryPlayerToFallTrigger,(a0)
                move.b  #$81,object_control(a1)
                move.b  #$1A,anim(a1)
                rts
; ---------------------------------------------------------------------------

SOZBoss_BeginKnucklesHorizontalExit:
                move.l  #SOZEndBoss_MoveKnucklesRouteUntil5560,(a0)
                rts
; ---------------------------------------------------------------------------

SOZBoss_CarryPlayerToFallTrigger:
                jsr     (MoveSprite2).l
                lea     (Player_1).w,a1
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_pos(a0),d0
                move.w  #$54C0,d1
                cmp.w   d1,d0
                blo.s   SOZEndBoss_CopySelectedExitXToPlayerOnly
                move.l  #SOZBoss_ClampUnsignedFallSpeed,(a0)
                bset    #0,(SceneSyncFlagsOrMHZState).w
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  d1,d0
                st      (Fast_V_scroll_flag).w
                move.w  #$7F,$2E(a0)

SOZEndBoss_CopySelectedExitXToPlayerOnly:
                move.w  d0,x_pos(a1)
                rts
; ---------------------------------------------------------------------------

SOZBoss_ClampUnsignedFallSpeed:
                cmpi.w  #$1000,y_vel(a0)
                blo.s   SOZBoss_MoveFallAndSyncPlayer
                move.w  #$1000,y_vel(a0)

SOZBoss_MoveFallAndSyncPlayer:
                jsr     (MoveSprite).l
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subq.w  #1,$2E(a0)
                bmi.s   SOZEndBoss_StartNextLevelAfterTimedFall
                rts
; ---------------------------------------------------------------------------

SOZEndBoss_StartNextLevelAfterTimedFall:
                move.w  #$900,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SOZEndBoss_MoveKnucklesRouteUntil5560:
                jsr     (MoveSprite2).l
                lea     (Player_1).w,a1
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_pos(a0),d0
                move.w  d0,x_pos(a1)
                cmpi.w  #$5560,d0
                bhs.s   SOZBoss_StartLevelAtKnucklesExitX
                rts
; ---------------------------------------------------------------------------

SOZBoss_StartLevelAtKnucklesExitX:
                move.w  #$900,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SOZBoss_WaitFallAndTakeP2Control:
                btst    #0,(SceneSyncFlagsOrMHZState).w
                beq.w   SOZBoss_SharedActorReturn
                move.l  #SOZBoss_SyncPartnerAboveP1,(a0)
                lea     (Player_2).w,a1
                bclr    #7,art_tile(a1)
                move.b  #$81,object_control(a1)
                move.b  #$1A,anim(a1)
                clr.b   (Ctrl_2_locked).w

SOZBoss_SyncPartnerAboveP1:
                lea     (Player_1).w,a1
                lea     (Player_2).w,a2
                move.w  x_pos(a1),x_pos(a2)
                move.w  y_pos(a1),d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a2)
                rts
; ---------------------------------------------------------------------------

SOZEndBoss_SelectRearTreeSubtypeOffset:
                addq.b  #6,subtype(a0)

SOZBoss_BindLimbMappingsAndDispatch:
                move.l  #Map_SOZEndBoss,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZEndBoss,3,1),art_tile(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SOZEndBoss_SixLimbInitializerOffsets(pc,d0.w),d0
                jmp     SOZEndBoss_SixLimbInitializerOffsets(pc,d0.w)
; ---------------------------------------------------------------------------
SOZEndBoss_SixLimbInitializerOffsets:
                dc.w    SOZEndBoss_InitializeSolidFrontBase-SOZEndBoss_SixLimbInitializerOffsets
                dc.w    SOZEndBoss_InitializeSolidMiddleLimb-SOZEndBoss_SixLimbInitializerOffsets
                dc.w    SOZEndBoss_InitializeSolidFrontArm-SOZEndBoss_SixLimbInitializerOffsets
                dc.w    SOZEndBoss_InitializeHiddenRearBase-SOZEndBoss_SixLimbInitializerOffsets
                dc.w    SOZBoss_InitMirroredRearMiddle-SOZEndBoss_SixLimbInitializerOffsets
                dc.w    SOZEndBoss_InitializeRearArm-SOZEndBoss_SixLimbInitializerOffsets
; ---------------------------------------------------------------------------

SOZEndBoss_InitializeSolidFrontBase:
                lea     SOZEndBoss_FrontBasePartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SOZBoss_FrontBaseFollowAndSolid,(a0)
                move.b  #$28,child_dy(a0)

SOZBoss_SharedActorReturn:
                rts
; ---------------------------------------------------------------------------

SOZEndBoss_InitializeHiddenRearBase:
                lea     SOZEndBoss_RearBasePartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SOZBoss_RearBaseFollowUntilRelease,(a0)
                move.b  #$28,child_dy(a0)
                bclr    #7,art_tile(a0)
                rts
; ---------------------------------------------------------------------------

SOZBoss_FrontBaseFollowAndSolid:
                movea.w parent3(a0),a1
                move.b  $3C(a1),d0
                asr.b   #2,d0
                move.b  d0,child_dx(a0)
                move.w  x_pos(a0),-(sp)
                jsr     (Refresh_ChildPosition).l
                moveq   #$1F,d1
                moveq   #$14,d2
                moveq   #$14,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.w   SOZBoss_LimbReleaseRidersAndBreak
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SOZBoss_RearBaseFollowUntilRelease:
                jsr     (Refresh_ChildPosition).l
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                beq.w   SOZBoss_SharedActorReturn
                moveq   #0,d0
                jmp     (SKChild_StartFlickerAndDraw).l
; ---------------------------------------------------------------------------

SOZEndBoss_InitializeSolidMiddleLimb:
                lea     SOZEndBoss_FrontMiddlePartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SOZEndBoss_ReadRootPoseAndSaveOldMiddleX,(a0)
                rts
; ---------------------------------------------------------------------------

SOZBoss_InitMirroredRearMiddle:
                lea     SOZEndBoss_RearMiddlePartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SOZBoss_RearMiddleReadMirroredPose,(a0)
                bclr    #7,art_tile(a0)
                st      $3A(a0)
                rts
; ---------------------------------------------------------------------------

SOZEndBoss_ReadRootPoseAndSaveOldMiddleX:
                move.w  x_pos(a0),-(sp)
                movea.w $44(a0),a1
                move.b  $3C(a1),d0
                tst.b   $3A(a0)
                beq.s   SOZBoss_FrontMiddlePlaceAndSolid
                neg.b   d0

SOZBoss_FrontMiddlePlaceAndSolid:
                move.b  d0,$3C(a0)
                lea     (AngleLookup_3).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                moveq   #$1B,d1
                moveq   #$10,d2
                moveq   #$10,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   SOZBoss_LimbReleaseRidersAndBreak
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SOZBoss_RearMiddleReadMirroredPose:
                movea.w $44(a0),a1
                move.b  $3C(a1),d0
                tst.b   $3A(a0)
                beq.s   SOZBoss_RearMiddlePlaceAndDraw
                neg.b   d0

SOZBoss_RearMiddlePlaceAndDraw:
                move.b  d0,$3C(a0)
                lea     (AngleLookup_3).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                moveq   #0,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

SOZEndBoss_InitializeSolidFrontArm:
                lea     SOZEndBoss_FrontArmPartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SOZBoss_FrontArmPlaceSolidAndTouch,(a0)
                rts
; ---------------------------------------------------------------------------

SOZEndBoss_InitializeRearArm:
                lea     SOZEndBoss_RearArmPartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SOZBoss_RearArmPlaceAndDraw,(a0)
                bclr    #7,art_tile(a0)
                rts
; ---------------------------------------------------------------------------

SOZBoss_FrontArmPlaceSolidAndTouch:
                move.w  x_pos(a0),-(sp)
                movea.w $44(a0),a1
                move.b  $3C(a1),$3C(a0)
                lea     (AngleLookup_2).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                subi.w  #$1C,x_pos(a0)
                subq.w  #4,y_pos(a0)
                moveq   #$2B,d1
                moveq   #$14,d2
                moveq   #$C,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                bsr.w   SOZBossArm_CheckContactsWhileAlive
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   SOZBoss_LimbReleaseRidersAndBreak
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SOZBoss_LimbReleaseRidersAndBreak:
                jsr     (Displace_PlayerOffObject).l
                moveq   #0,d0
                jmp     (SKChild_StartFlickerAndDraw).l
; ---------------------------------------------------------------------------

SOZBoss_RearArmPlaceAndDraw:
                movea.w $44(a0),a1
                move.b  $3C(a1),d0
                neg.b   d0
                move.b  d0,$3C(a0)
                lea     (AngleLookup_2).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                subi.w  #$1C,x_pos(a0)
                subq.w  #4,y_pos(a0)
                moveq   #0,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

SOZBoss_InitUpperSolidBody:
                move.b  #$20,width_pixels(a0)
                move.b  #$50,height_pixels(a0)
                move.l  #SOZBoss_UpperBodySolidAndTouch,(a0)

SOZBoss_UpperBodySolidAndTouch:
                move.w  x_pos(a0),-(sp)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),d0
                subi.w  #$14,d0
                move.w  d0,y_pos(a0)
                moveq   #$2B,d1
                moveq   #$28,d2
                moveq   #$28,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull2).l
                bsr.w   SOZBossUpper_CheckBothContacts

SOZBoss_UpperBodyCheckParentDeath:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   SOZBoss_BodyReleaseRidersAndDelete
                rts
; ---------------------------------------------------------------------------

SOZBoss_BodyReleaseRidersAndDelete:
                jsr     (Displace_PlayerOffObject).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SOZBoss_UpperBodySuspendDuringEye:
                tst.w   (Events_bg+$0A).w
                bne.s   SOZBoss_UpperBodyCheckLifeAfterEye
                move.l  #SOZBoss_UpperBodySolidAndTouch,(a0)

SOZBoss_UpperBodyCheckLifeAfterEye:
                bra.s   SOZBoss_UpperBodyCheckParentDeath
; ---------------------------------------------------------------------------

SOZBoss_InitLowerSolidBody:
                move.b  #$30,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                move.l  #SOZBoss_LowerBodySolidAndTouch,(a0)

SOZBoss_LowerBodySolidAndTouch:
                tst.w   (Events_bg+$0A).w
                bne.s   SOZBoss_LowerBodySuspendAndRelease
                move.w  x_pos(a0),-(sp)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),d0
                addi.w  #$44,d0
                move.w  d0,y_pos(a0)
                moveq   #$3B,d1
                moveq   #$30,d2
                moveq   #$30,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull2).l
                bsr.w   SOZBossLower_CheckBothContacts
                bra.s   SOZBoss_UpperBodyCheckParentDeath
; ---------------------------------------------------------------------------

SOZBoss_LowerBodySuspendAndRelease:
                move.l  #SOZBoss_LowerBodyResumeAfterEye,(a0)
                jsr     (Displace_PlayerOffObject).l

SOZBoss_LowerBodyResumeAfterEye:
                tst.w   (Events_bg+$0A).w
                bne.w   SOZBoss_UpperBodyCheckParentDeath
                move.l  #SOZBoss_LowerBodySolidAndTouch,(a0)
                jsr     (Displace_PlayerOffObject).l
                bra.s   SOZBoss_LowerBodySolidAndTouch
; ---------------------------------------------------------------------------

SOZBoss_InitRightBarrier:
                move.b  #$20,width_pixels(a0)
                move.b  #$FF,height_pixels(a0)
                move.l  #SOZBoss_RightBarrierFollowAndSolid,(a0)

SOZBoss_RightBarrierFollowAndSolid:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                addi.w  #$20,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                moveq   #$2B,d1
                move.w  #$200,d2
                move.w  #$200,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull2).l
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   SOZBoss_RightBarrierReleaseAndDelete
                rts
; ---------------------------------------------------------------------------

SOZBoss_RightBarrierReleaseAndDelete:
                jsr     (Displace_PlayerOffObject).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SOZBoss_InitVisibleFollower:
                lea     SOZBoss_VisibleFollowerAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SOZBoss_VisiblePieceFollowAndDraw,(a0)
                rts
; ---------------------------------------------------------------------------

SOZBoss_VisiblePieceFollowAndDraw:
                jsr     (Refresh_ChildPosition).l
                moveq   #0,d0
                jmp     (Child_Draw_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------

; Save the last returned particle pointer without checking allocation success
SOZBoss_InitChargeGenerator:
                lea     SOZEndBoss_ChargeGeneratorFullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SOZBoss_WaitForLastChargeParticle,(a0)
                lea     SOZEndBoss_TwentyRepeatedChargeParticles(pc),a2
                jsr     (CreateChild6_Simple).l
                move.w  a1,$44(a0)

SOZBoss_WaitForLastChargeParticle:
                movea.w $44(a0),a1
                btst    #4,$38(a1)
                bne.s   SOZBoss_SpawnMaskAndShot

SOZBoss_ChargeGeneratorFollowDraw:
                jsr     (Refresh_ChildPosition).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   SOZBoss_DeleteChargeFamily
                tst.w   (Events_bg+$0A).w
                bne.s   SOZBoss_DeleteChargeFamily
                btst    #0,(V_int_run_count+3).w
                bne.w   SOZBoss_SharedActorReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SOZBoss_DeleteChargeFamily:
                bset    #7,status(a0)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SOZBoss_SpawnMaskAndShot:
                move.l  #SOZBoss_TickChargeFireWait,(a0)
                move.w  #8,$2E(a0)
                moveq   #signextendB(sfx_Laser),d0
                jsr     (Play_SFX).l
                lea     SOZBoss_MaskAndShotChildren(pc),a2
                jsr     (CreateChild1_Normal).l

SOZBoss_TickChargeFireWait:
                subq.w  #1,$2E(a0)
                bmi.s   SOZBoss_DeleteChargeFamily
                bra.s   SOZBoss_ChargeGeneratorFollowDraw
; ---------------------------------------------------------------------------

SOZBoss_InitChargeParticleAndDelay:
                lea     SOZBoss_ChargeParticleAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #SOZBoss_TickChargeParticleDelay,(a0)
                bsr.w   SOZBossCharge_InitParticle

SOZBoss_TickChargeParticleDelay:
                subq.w  #1,$2E(a0)
                bmi.s   SOZBoss_BeginParticleConvergence
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   SOZBoss_DeleteChargeFamily
                tst.w   (Events_bg+$0A).w
                bne.s   SOZBoss_DeleteChargeFamily
                rts
; ---------------------------------------------------------------------------

SOZBoss_BeginParticleConvergence:
                move.l  #SOZBoss_ParticleAnimateAndMoveX,(a0)
                move.l  #Go_Delete_Sprite_2,$34(a0)

SOZBoss_ParticleAnimateAndMoveX:
                lea     SOZBoss_ChargeParticleAnim(pc),a1
                jsr     (Animate_RawNoSST).l
                move.w  x_vel(a0),d0
                addi.w  #$10,d0
                move.w  d0,x_vel(a0)
                add.w   d0,$3A(a0)
                btst    #2,$38(a0)
                bne.s   SOZBoss_ParticleProjectAndCheckLife
                moveq   #$10,d0
                move.w  $3C(a0),d1
                bmi.s   SOZBoss_ParticleMoveYAndClamp
                neg.w   d0

; Clamp the offset to zero when its sign changes
SOZBoss_ParticleMoveYAndClamp:
                move.w  y_vel(a0),d2
                add.w   d0,d2
                move.w  d2,y_vel(a0)
                move.w  d1,d3
                add.w   d2,d1
                eor.w   d1,d3
                bpl.s   SOZEndBoss_StoreParticleYOffsetCandidate
                moveq   #0,d1
                bset    #2,$38(a0)

SOZEndBoss_StoreParticleYOffsetCandidate:
                move.w  d1,$3C(a0)

SOZBoss_ParticleProjectAndCheckLife:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                move.w  y_pos(a1),d1
                move.b  $3A(a0),d2
                ext.w   d2
                add.w   d2,d0
                move.w  d0,x_pos(a0)
                move.b  $3C(a0),d3
                ext.w   d3
                add.w   d3,d1
                move.w  d1,y_pos(a0)
                btst    #7,status(a1)
                bne.w   SOZBoss_DeleteChargeFamily
                tst.w   (Events_bg+$0A).w
                bne.w   SOZBoss_DeleteChargeFamily
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SOZBoss_InitShotAndAimAtPlayer:
                lea     SOZEndBoss_FiredShotPartial2Attributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #SOZBoss_MoveShotRelativeToParent,(a0)
                move.w  #7,$2E(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bpl.s   SOZBoss_ChooseShotDistanceVariant
                neg.w   d0

; Use the far shot at $80 pixels or more
SOZBoss_ChooseShotDistanceVariant:
                cmpi.w  #$80,d0
                bhs.s   SOZBoss_InitFarShot
                move.w  #-$400,x_vel(a0)
                move.w  #$400,y_vel(a0)
                bra.w   SOZBoss_ShotInitReturn
; ---------------------------------------------------------------------------

SOZBoss_InitFarShot:
                move.b  #$F,mapping_frame(a0)
                move.w  #(8<<8)|((-8)&$FF),child_dx(a0)  ; and child_dy
                move.w  #-$400,x_vel(a0)
                move.w  #$300,y_vel(a0)

SOZBoss_ShotInitReturn:
                rts
; ---------------------------------------------------------------------------

SOZBoss_MoveShotRelativeToParent:
                subq.w  #1,$2E(a0)
                bmi.s   SOZBoss_BeginIndependentShotFlight
                move.b  x_vel(a0),d0
                add.b   d0,child_dx(a0)
                move.b  y_vel(a0),d0
                add.b   d0,child_dy(a0)
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SOZBoss_BeginIndependentShotFlight:
                move.l  #SOZBoss_ShotMoveAndCull,(a0)

SOZBoss_ShotMoveAndCull:
                jsr     (MoveSprite2).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SOZBoss_InitShortSpriteMask:
                lea     SOZEndBoss_SpriteMaskFullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SOZBoss_SetMaskFollowAndDraw,(a0)
                move.w  #8,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

SOZBoss_SetMaskFollowAndDraw:
                st      (Spritemask_flag).w
                jsr     (Refresh_ChildPosition).l
                jmp     (Wait_Draw).l
; ---------------------------------------------------------------------------

SOZBoss_InitFixedBodyMask:
                lea     SOZBoss_FixedBodyAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SOZBoss_DrawFixedBodyUntilExit,(a0)
                move.w  #$5260,x_pos(a0)
                move.w  #$710,y_pos(a0)

SOZBoss_DrawFixedBodyUntilExit:
                movea.w parent3(a0),a1
                cmpi.w  #$5180,x_pos(a0)
                blo.s   SOZBoss_DeleteFixedBody
                btst    #7,status(a1)
                bne.s   SOZBoss_DeleteFixedBody
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SOZBoss_DeleteFixedBody:
                jmp     (Delete_Current_Sprite).l
