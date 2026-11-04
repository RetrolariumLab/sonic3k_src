; Owner: objects/bosses/mhz/end_boss/sk
; Responsibility: Mushroom Hill end-boss controller, attached actors, attack and defeat states
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZEndBoss:
                lea     MHZEndBoss_CameraTriggerAndTargetBounds(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #MHZBoss_BattleDispatchHitAndDraw,(a0)
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                move.b  #1,(Boss_flag).w
                jsr     (SKEndCamera_SaveAndLoadBounds).l
                addi.w  #$C0,x_pos(a0)
                lea     ObjDat_MHZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                clr.b   routine(a0)
                clr.b   (_unkFAA9).w
                lea     (ArtKosM_MHZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_7B,d0
                jsr     (Load_PLC).l
                lea     Pal_MHZEndBoss(pc),a1
                jsr     (PalLoad_Line1).l
                lea     MHZEndBoss_RobotnikHeadNormalRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     MHZBoss_SpikeWeatherProxyChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     MHZBoss_PriorityOverlayChild(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     MHZBoss_LayeredOverlayChildren(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

MHZBoss_BattleDispatchHitAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MHZEndBoss_RootStateOffsets(pc,d0.w),d1
                jsr     MHZEndBoss_RootStateOffsets(pc,d1.w)
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)
                bsr.w   MHZBoss_HandlePairedHitsAndEscape
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
MHZEndBoss_RootStateOffsets:
                dc.w    MHZBoss_ResetHealthUntilWeatherSignal-MHZEndBoss_RootStateOffsets
                dc.w    MHZBoss_WaitWeatherAndArmRise-MHZEndBoss_RootStateOffsets
                dc.w    MHZEndBoss_WaitBeforeRootRise-MHZEndBoss_RootStateOffsets
                dc.w    MHZEndBoss_MoveAndWaitDuringRise-MHZEndBoss_RootStateOffsets
                dc.w    MHZBoss_SwingMoveAndWait-MHZEndBoss_RootStateOffsets
                dc.w    MHZBoss_SwingMoveAndWait-MHZEndBoss_RootStateOffsets
                dc.w    MHZBoss_SwingUntilCameraChaseGate-MHZEndBoss_RootStateOffsets
                dc.w    MHZBoss_SwingMoveAndWait-MHZEndBoss_RootStateOffsets
; ---------------------------------------------------------------------------

MHZBoss_ResetHealthUntilWeatherSignal:
                move.b  #$F,collision_flags(a0)
                move.b  #9,collision_property(a0)
                move.b  collision_flags(a0),$25(a0)
                clr.b   (_unkFA88).w

MHZBoss_WaitWeatherAndArmRise:
                btst    #2,$38(a0)
                beq.s   MHZBoss_WeatherWaitReturn
                move.b  #4,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MHZEndBoss_StartTimedUpwardRise,$34(a0)

MHZBoss_WeatherWaitReturn:
                rts
; ---------------------------------------------------------------------------

MHZEndBoss_WaitBeforeRootRise:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MHZEndBoss_StartTimedUpwardRise:
                move.b  #6,routine(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$23,$2E(a0)
                move.l  #MHZEndBoss_StartSwingDelayBeforeDash,$34(a0)
                moveq   #signextendB(sfx_Rising),d0
                jsr     (Play_SFX).l

MHZBoss_SharedReturn:
                rts
; ---------------------------------------------------------------------------

MHZEndBoss_MoveAndWaitDuringRise:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MHZEndBoss_StartSwingDelayBeforeDash:
                move.b  #8,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MHZBoss_BeginSpikedDash,$34(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

MHZBoss_SwingMoveAndWait:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MHZBoss_BeginSpikedDash:
                move.b  #$A,routine(a0)
                bset    #6,$38(a0)
                move.w  #$400,x_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MHZBoss_EnterChaseAndTryArtWatcher,$34(a0)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

MHZBoss_EnterChaseAndTryArtWatcher:
                move.b  #$C,routine(a0)
                bset    #7,$38(a0)
                move.w  #$4180,x_pos(a0)
                move.w  #$2E0,y_pos(a0)
                bset    #3,$38(a0)
                clr.w   x_vel(a0)
                jsr     (AllocateObject).l
                bne.s   MHZBoss_SetChaseCameraTarget
                move.l  #MHZBoss_WaitCameraAndLoadSpikeArt,(a1)

MHZBoss_SetChaseCameraTarget:
                move.w  #$45A0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

MHZBoss_SwingUntilCameraChaseGate:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   x_pos(a0),d0
                bhs.s   MHZBoss_BeginAlternatingChase
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

MHZBoss_BeginAlternatingChase:
                move.b  #$E,routine(a0)
                move.l  #MHZBoss_LoadCharacterChaseSpeed,$34(a0)
                clr.w   $2E(a0)
                bra.w   MHZBoss_SwingMoveAndWait
; ---------------------------------------------------------------------------

MHZBoss_LoadCharacterChaseSpeed:
                move.w  #$5F,$2E(a0)
                move.w  #$400,d0
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   MHZBoss_ToggleSpikesAndAdjustSpeed
                move.w  #$500,d0

MHZBoss_ToggleSpikesAndAdjustSpeed:
                move.w  #$100,d1
                bchg    #6,$38(a0)
                beq.s   MHZEndBoss_CommitAdjustedChaseXVelocity
                move.w  #-$100,d1

MHZEndBoss_CommitAdjustedChaseXVelocity:
                add.w   d1,d0
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

MHZBoss_EscapeToDefeatGate:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                cmpi.w  #$44D0,x_pos(a0)
                blo.s   MHZEndBoss_WrapCorrectAndDrawEscapeShip
                move.l  #Wait_FadeToLevelMusic,(a0)
                bset    #7,status(a0)
                move.w  #$14,(Screen_shake_flag).w
                move.l  #MHZBoss_BeginRiseAndBreakup,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                jsr     (BossDefeated_StopTimer).l

MHZEndBoss_WrapCorrectAndDrawEscapeShip:
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZBoss_BeginRiseAndBreakup:
                move.l  #MHZBoss_FallThenSpawnCapsule,(a0)
                move.w  #$100,priority(a0)
                bset    #7,art_tile(a0)
                clr.w   x_vel(a0)
                move.w  #-$200,y_vel(a0)
                bset    #4,$38(a0)
                lea     PLC_MHZEndBoss_Explosion(pc),a1
                jsr     (Load_PLC_Raw).l
                lea     MHZBoss_BreakupFragmentChildren(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

MHZBoss_FallThenSpawnCapsule:
                jsr     (MoveSprite).l
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   y_pos(a0),d0
                bhs.s   MHZEndBoss_DrawBreakupShipAfterDepthGate
                move.l  #MHZBoss_AdvanceCameraToExitLock,(a0)
                bset    #0,(_unkFA88).w
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                bset    #5,$38(a0)
                jsr     (PLCLoad_AnimalsAndExplosion).l
                jsr     (AllocateObject).l
                bne.s   MHZEndBoss_DrawBreakupShipAfterDepthGate
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$4640,x_pos(a1)
                move.w  #$320,y_pos(a1)

MHZEndBoss_DrawBreakupShipAfterDepthGate:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZBoss_AdvanceCameraToExitLock:
                move.w  (Camera_X_pos).w,d0
                addq.w  #4,d0
                move.w  #$45A0,d1
                cmp.w   d1,d0
                blo.s   MHZEndBoss_CommitPostDefeatCameraX
                move.l  #MHZBoss_WaitCapsuleAndResetShip,(a0)
                move.w  d1,d0
                move.w  d1,(Camera_min_X_pos).w
                move.w  d1,(Camera_max_X_pos).w
                clr.b   (Scroll_lock).w
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w
                clr.w   (Ctrl_1_logical).w

MHZEndBoss_CommitPostDefeatCameraX:
                move.w  d0,(Camera_X_pos).w
                rts
; ---------------------------------------------------------------------------

MHZBoss_WaitCapsuleAndResetShip:
                tst.b   (_unkFAA8).w
                bne.w   MHZBoss_SharedReturn
                move.l  #MHZEndBoss_WaitBeforeDepartureFlight,(a0)
                clr.b   (_unkFAA9).w
                move.w  (Camera_X_pos).w,d0
                subi.w  #$40,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$40,d0
                move.w  d0,y_pos(a0)
                jsr     (Restore_PlayerControl).l
                bset    #7,art_tile(a1)
                lea     (Player_2).w,a1
                bset    #7,art_tile(a1)
                jsr     (Restore_PlayerControl2).l
                jsr     (Restore_LevelMusic).l
                st      (Ctrl_1_locked).w
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                st      (Ctrl_2_locked).w
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_2_logical).w
                jsr     (FacePlayersTowardObject).l
                move.w  #$1BF,$2E(a0)
                move.w  #$55,(Events_fg_4).w
                move.w  #$5000,(Camera_stored_max_X_pos).w
                bclr    #5,$38(a0)
                lea     MHZEndBoss_RobotnikHeadNormalRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     (PLC_RobotnikShip).l,a1
                jsr     (Load_PLC_Raw).l
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

MHZEndBoss_WaitBeforeDepartureFlight:
                subq.w  #1,$2E(a0)
                bmi.s   MHZBoss_BeginShipDeparture
                rts
; ---------------------------------------------------------------------------

MHZBoss_BeginShipDeparture:
                move.l  #MHZBoss_PlaySirenAndSetDeparture,(a0)
                bclr    #7,status(a0)
                bclr    #4,$38(a0)
                bset    #0,render_flags(a0)
                move.w  #$400,x_vel(a0)
                clr.w   y_vel(a0)
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     (CreateChild1_Normal).l
                cmpi.b  #2,(Player_1+character_id).w
                bne.w   MHZBoss_SharedReturn
                jmp     (RobotnikSK_HeadLoadEggRoboAnimAndArt).l
; ---------------------------------------------------------------------------

MHZBoss_PlaySirenAndSetDeparture:
                moveq   #signextendB(sfx_RobotnikSiren),d0
                jsr     (Play_SFX_Continuous).l
                jsr     (FacePlayersTowardObject).l
                moveq   #0,d1
                move.w  (Camera_X_pos).w,d0
                addi.w  #$80,d0
                cmp.w   x_pos(a0),d0
                bhs.s   MHZBoss_MoveShipAndSetWalkStage
                moveq   #-$10,d1

MHZBoss_MoveShipAndSetWalkStage:
                jsr     (MoveSprite_CustomGravity).l
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$40,d0
                cmp.w   y_pos(a0),d0
                blo.s   MHZBoss_WrapAndDrawShip
                move.l  #MHZBoss_WalkPlayerToStopX,(a0)
                bset    #5,$38(a0)
                jsr     (AllocateObject).l
                bne.s   MHZBoss_WrapAndDrawShip
                move.l  #SKInput_LockP2IfActive,(a1)

MHZBoss_WrapAndDrawShip:
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZBoss_WalkPlayerToStopX:
                lea     (Player_1).w,a1
                cmpi.w  #$4778,x_pos(a1)
                bhs.s   MHZEndBoss_StopPlayerAtDepartureWalkGate
                jmp     (SKInput_BuildAutoRightAndJump).l
; ---------------------------------------------------------------------------

MHZEndBoss_StopPlayerAtDepartureWalkGate:
                move.l  #MHZBoss_WaitBackgroundThenJump,(a0)
                clr.w   (Ctrl_1_logical).w
                lea     (Player_1).w,a1
                jmp     (Stop_Object).l
; ---------------------------------------------------------------------------

MHZBoss_WaitBackgroundThenJump:
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_2).w
                tst.b   (_unkFAA9).w
                beq.w   MHZBoss_SharedReturn
                move.l  #MHZBoss_WaitJumpApexAndGrab,(a0)
                move.w  #(button_C_mask<<8)|button_C_mask,(Ctrl_1_logical).w
                lea     (Player_1).w,a1
                move.w  #$200,x_vel(a1)
                rts
; ---------------------------------------------------------------------------

MHZBoss_WaitJumpApexAndGrab:
                move.w  #button_C_mask<<8,(Ctrl_1_logical).w
                lea     (Player_1).w,a1
                tst.w   y_vel(a1)
                bmi.w   MHZBoss_SharedReturn
                move.l  #MHZBoss_TickGrabPoseDelay,(a0)
                jsr     (Stop_Object).l
                move.b  #$81,object_control(a1)
                move.b  #$11,anim(a1)
                bset    #0,render_flags(a1)
                bset    #Status_Facing,status(a1)
                move.w  #$5F,$2E(a0)
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   MHZBoss_TickGrabPoseDelay
                move.l  #MHZBoss_InitPartnerDeparturePose,(a1)

MHZBoss_TickGrabPoseDelay:
                subq.w  #1,$2E(a0)
                bmi.s   MHZBoss_StartMarbleGardenAndDelete
                rts
; ---------------------------------------------------------------------------

MHZBoss_StartMarbleGardenAndDelete:
                move.w  #$400,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

MHZBoss_InitPartnerDeparturePose:
                move.l  #MHZBoss_MovePartnerUpAndRight,(a0)
                lea     (Player_2).w,a1
                move.b  #$81,object_control(a1)
                move.b  #$20,anim(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                rts
; ---------------------------------------------------------------------------

MHZBoss_MovePartnerUpAndRight:
                lea     (Player_2).w,a1
                addq.w  #1,x_pos(a1)
                subq.w  #1,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

MHZBoss_InitPairedTouchProxy:
                lea     MHZBoss_TouchProxyAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MHZBoss_ProxyFollowAndSubmitTouch,(a0)
                movea.w parent3(a0),a1
                move.w  a0,$44(a1)
                move.b  collision_flags(a0),$25(a0)
                move.b  #-1,collision_property(a0)

MHZBoss_ProxyFollowAndSubmitTouch:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_AddToTouchList).l
; ---------------------------------------------------------------------------

MHZBoss_InitPriorityOverlay:
                lea     MHZEndBoss_VisualOverlayFullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MHZBoss_RaiseOverlayPriority,(a0)

MHZBoss_RaiseOverlayPriority:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   MHZBoss_SyncAndDrawPriorityOverlay
                move.l  #MHZBoss_SyncAndDrawPriorityOverlay,(a0)
                bset    #7,art_tile(a0)

MHZBoss_SyncAndDrawPriorityOverlay:
                bsr.w   MHZBossOverlay_SyncPosAndXFlip
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

MHZBoss_InitLayeredOverlay:
                lea     MHZEndBoss_VisualOverlayFullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MHZBoss_SyncAndDrawLayeredOverlay,(a0)
                bsr.w   SelectMHZEndBossOverlayLayerBySubtype

MHZBoss_SyncAndDrawLayeredOverlay:
                bsr.w   MHZBossOverlay_SyncPosAndXFlip
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

MHZBoss_InitWeatherMachine:
                lea     MHZEndBoss_WeatherMachineFullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MHZBoss_TickWeatherSound,(a0)
                move.b  #1,collision_property(a0)
                lea     MHZBoss_WeatherPairChildren(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     MHZBoss_DiagonalEffectChildren(pc),a2
                jsr     (CreateChild6_Simple).l

MHZBoss_TickWeatherSound:
                tst.b   collision_flags(a0)
                beq.s   MHZBoss_SignalWeatherDefeat
                subq.w  #1,$2E(a0)
                bpl.s   MHZEndBoss_DrawAndTouchWeatherMachine
                jsr     (Random_Number).l
                andi.w  #$F,d0
                addq.w  #8,d0
                move.w  d0,$2E(a0)
                moveq   #signextendB(sfx_WeatherMachine),d0
                jsr     (Play_SFX).l

MHZEndBoss_DrawAndTouchWeatherMachine:
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

MHZBoss_SignalWeatherDefeat:
                move.l  #Wait_Draw,(a0)
                move.w  #$3F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($20),d6

MHZBoss_SaveFirstPaletteLine:
                move.l  (a1)+,(a2)+
                dbf     d6,MHZBoss_SaveFirstPaletteLine
                lea     (Pal_MHZEndBoss).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

MHZBoss_CopyBossPaletteLine:
                move.l  (a1)+,(a2)+
                dbf     d6,MHZBoss_CopyBossPaletteLine
                lea     (Pal_MHZ1+$20).l,a1
                lea     (Target_palette_line_3).w,a2
                moveq   #bytesToLcnt($40),d6

MHZBoss_CopyZoneTargetPalette:
                move.l  (a1)+,(a2)+
                dbf     d6,MHZBoss_CopyZoneTargetPalette
                jsr     (AllocateObject).l
                bne.s   MHZBoss_TryBossMusicTransition
                move.l  #SKPalEffect_InitWhiteAndLockRotation,(a1)
                st      subtype(a1)
                move.w  #3,$3A(a1)

MHZBoss_TryBossMusicTransition:
                jsr     (AllocateObject).l
                bne.s   MHZBoss_TryWeatherExplosion
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

MHZBoss_TryWeatherExplosion:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                clr.b   (_unkF7C1).w
                rts
; ---------------------------------------------------------------------------

MHZBoss_InitWeatherPairEffect:
                lea     MHZBoss_WeatherPairAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MHZEndBoss_WeatherPrimaryFrameDelayLoop,$30(a0)
                tst.b   subtype(a0)
                beq.s   MHZBoss_InstallWeatherPairUpdate
                move.l  #MHZBoss_WeatherPairAnim,$30(a0)

MHZBoss_InstallWeatherPairUpdate:
                move.l  #MHZBoss_AnimateWeatherPairAndDraw,(a0)

MHZBoss_AnimateWeatherPairAndDraw:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZBoss_InitDiagonalWeatherEffect:
                lea     MHZBoss_DiagonalEffectAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MHZBoss_AnimateDiagonalEffect,(a0)
                move.l  #MHZBoss_DiagonalEffectAnim,$30(a0)
                bsr.w   OffsetMHZWeatherMachineEffectBySubtype

MHZBoss_AnimateDiagonalEffect:
                jsr     (Animate_Raw).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZBoss_InitShieldSpike:
                lea     MHZEndBoss_ShieldSpikeFullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MHZBoss_SpikeFollowAndCheckHit,(a0)
                bset    #4,shield_reaction(a0)

MHZBoss_SpikeFollowAndCheckHit:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   MHZBoss_SpikeDeleteWithParent
                move.b  #$8B,collision_flags(a0)
                btst    #6,status(a1)
                beq.s   MHZBoss_SpikeSelectDrawParity
                clr.b   collision_flags(a0)

; Opposite subtypes use opposite V-int parity
MHZBoss_SpikeSelectDrawParity:
                btst    #0,(V_int_run_count+3).w
                sne     d0
                tst.b   subtype(a0)
                beq.s   MHZBoss_SpikeDrawAndSubmitTouch
                not.b   d0

MHZBoss_SpikeDrawAndSubmitTouch:
                tst.b   d0
                bne.w   MHZBoss_SharedReturn
                btst    #6,$38(a1)
                beq.w   MHZBoss_SharedReturn
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZBoss_SpikeDeleteWithParent:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

MHZBoss_InitBreakupFragment:
                lea     MHZEndBoss_BreakupFragmentFullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     MHZBoss_FragmentPriorityFrames(pc,d0.w),a1
                move.w  (a1)+,priority(a0)
                move.b  (a1)+,mapping_frame(a0)
                moveq   #8,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
MHZBoss_FragmentPriorityFrames:
                dc.w    $200
                dc.b    $12
                even
                dc.w    $200
                dc.b    $13
                even
                dc.w    $300
                dc.b    $14
                even
                dc.w    $300
                dc.b    $15
                even
                dc.w    $200
                dc.b    $16
                even
                dc.w    $200
                dc.b    $17
                even
