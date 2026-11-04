; Owner: objects/bosses/hcz/end_boss/s3
; Responsibility: Hydrocity end-boss battle control, defeat sequence, chassis states and coordinated child actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZEndBoss:
                move.w  #$4050,(Camera_max_X_pos).w
                lea     HCZBossS3_InitialCameraRanges(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #HCZBossS3_TickCameraMusicTransition,(a0)
                move.b  #1,(Boss_flag).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #2*60,$2E(a0)
                move.b  #mus_EndBoss,$26(a0)
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  #$738,(Camera_target_max_Y_pos).w
                move.w  #$4000,$1C(a0)
                move.l  #HCZBossS3_InstallBattleDispatcher,$34(a0)
                rts
; ---------------------------------------------------------------------------
HCZBossS3_InitialCameraRanges:
                dc.w    $400,  $880, $3E80, $4090
; ---------------------------------------------------------------------------

HCZBossS3_TickCameraMusicTransition:
                jmp     (S3EndCamera_TickMusicDelay).l
; ---------------------------------------------------------------------------

HCZBossS3_InstallBattleDispatcher:
                move.l  #HCZBossS3_BattleDispatchHitAndDraw,(a0)

HCZBossS3_SharedReturn:
                rts
; ---------------------------------------------------------------------------

HCZBossS3_BattleDispatchHitAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZEndBossS3_Root_SevenStateOffsets(pc,d0.w),d1
                jsr     HCZEndBossS3_Root_SevenStateOffsets(pc,d1.w)
                bsr.w   HCZBoss_HandleHitFlashOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
HCZEndBossS3_Root_SevenStateOffsets:
                dc.w    HCZBossS3_InitBodyAndSpawnShip-HCZEndBossS3_Root_SevenStateOffsets
                dc.w    HCZEndBossS3_Root_MoveStraightThenWait-HCZEndBossS3_Root_SevenStateOffsets
                dc.w    HCZEndBossS3_Root_BobMoveThenWait-HCZEndBossS3_Root_SevenStateOffsets
                dc.w    HCZEndBossS3_Root_MoveStraightThenWait-HCZEndBossS3_Root_SevenStateOffsets
                dc.w    HCZEndBossS3_Root_MoveStraightThenWait-HCZEndBossS3_Root_SevenStateOffsets
                dc.w    HCZEndBossS3_Root_BobMoveThenWait-HCZEndBossS3_Root_SevenStateOffsets
                dc.w    HCZBossS3_BobMoveAndTickTurn-HCZEndBossS3_Root_SevenStateOffsets
; ---------------------------------------------------------------------------

HCZBossS3_InitBodyAndSpawnShip:
                lea     ObjDat_HCZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$EF,$2E(a0)
                move.l  #HCZBossS3_SaveBaselineAndBeginBob,$34(a0)
                moveq   #PLCID_6C,d0
                jsr     (Load_PLC).l
                move.w  #0,(Normal_palette+$1E).w
                lea     Pal_HCZEndBoss(pc),a1
                jsr     (PalLoad_Line1).l
                lea     (HCZEndBossS3_Root_OneNormalShipTwoRecord).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   HCZBossS3_SpawnBodyAttachments
                move.b  #5,subtype(a1)

HCZBossS3_SpawnBodyAttachments:
                lea     HCZBossS3_BodyAttachmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZEndBossS3_Root_MoveStraightThenWait:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZBossS3_SaveBaselineAndBeginBob:
                move.b  #4,routine(a0)
                move.w  y_pos(a0),$3A(a0)
                move.w  #-$100,$44(a0)
                move.w  #$9F,$30(a0)
                move.w  #$3F,$2E(a0)
                move.l  #HCZBossS3_StartFanAndCheckDiveFlag,$34(a0)
                lea     (PLC_Explosion).l,a1
                jsr     (Load_PLC_Raw).l
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

HCZEndBossS3_Root_BobMoveThenWait:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZBossS3_StartFanAndCheckDiveFlag:
                bset    #3,$38(a0)
                tst.b   (BossSceneResetBaseAndRetainedGate+1).w
                bne.s   HCZBossS3_BeginLongFanWait
                move.b  #6,routine(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$9F,$2E(a0)
                move.l  #HCZEndBossS3_Root_StartTimedFanAscent,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_BeginLongFanWait:
                move.b  #$A,routine(a0)
                move.w  #$1FF,$2E(a0)
                move.l  #HCZBossS3_BeginBombSweep,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZEndBossS3_Root_StartTimedFanAscent:
                move.w  #-$100,y_vel(a0)
                move.w  #$4F,$2E(a0)
                move.l  #HCZBossS3_RestoreBaselineAndBob,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_RestoreBaselineAndBob:
                move.b  #$A,routine(a0)
                move.w  #$FF,$2E(a0)
                move.w  $3A(a0),y_pos(a0)
                move.l  #HCZBossS3_BeginBombSweep,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_BeginBombSweep:
                move.b  #$C,routine(a0)
                bclr    #3,$38(a0)
                move.w  $44(a0),x_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #HCZBossS3_RequestBombOrEndBurst,$34(a0)
                move.b  #8,$39(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

HCZBossS3_BobMoveAndTickTurn:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                subq.w  #1,$30(a0)
                bpl.s   HCZBossS3_TurnCounterReturn
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  #$13F,$30(a0)

HCZBossS3_TurnCounterReturn:
                rts
; ---------------------------------------------------------------------------

HCZBossS3_RequestBombOrEndBurst:
                move.w  #$5F,$2E(a0)
                subq.b  #1,$39(a0)
                bmi.s   HCZBossS3_SaveDriftAndRestartFan
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_SaveDriftAndRestartFan:
                move.w  x_vel(a0),$44(a0)
                clr.w   x_vel(a0)
                bra.w   HCZBossS3_StartFanAndCheckDiveFlag
; ---------------------------------------------------------------------------

HCZBossS3_BeginDefeatBreakaway:
                move.l  #HCZBossS3_DefeatMoveWaitAndFlicker,(a0)
                bset    #4,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #HCZBossS3_OpenCameraAndPrepareFinish,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                moveq   #$C,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

HCZBossS3_DefeatMoveWaitAndFlicker:
                jsr     (MoveSprite).l
                jsr     (Obj_Wait).l
                btst    #0,(V_int_run_count+3).w
                beq.w   HCZBossS3_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZBossS3_OpenCameraAndPrepareFinish:
                move.l  #HCZBossS3_WaitFinishAndRestorePlayers,(a0)
                bclr    #7,render_flags(a0)
                st      (ActCompletionHandshake).w
                clr.b   (Boss_flag).w
                jsr     (Restore_LevelMusic).l
                move.w  #$4230,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

HCZBossS3_WaitFinishAndRestorePlayers:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (ActCompletionHandshake).w
                bne.w   HCZBossS3_SharedReturn
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                st      (Ctrl_1_locked).w
                st      (Ctrl_2_locked).w
                move.b  #$80,(Player_1+object_control).w
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                lea     HCZBossS3_ExitCoordinatorChild(pc),a2
                jsr     (CreateChild6_Simple).l
                move.w  #0,(Camera_min_Y_pos).w
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

HCZBossS3_FanDispatchFollowAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZEndBossS3_Fan_FiveStateOffsets(pc,d0.w),d1
                jsr     HCZEndBossS3_Fan_FiveStateOffsets(pc,d1.w)
                jsr     (Refresh_ChildPosition).l
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------
HCZEndBossS3_Fan_FiveStateOffsets:
                dc.w    HCZBossS3_InitFan-HCZEndBossS3_Fan_FiveStateOffsets
                dc.w    HCZEndBossS3_Fan_WaitForRootFanFlag-HCZEndBossS3_Fan_FiveStateOffsets
                dc.w    HCZBossS3_FanAccelerateWithSound-HCZEndBossS3_Fan_FiveStateOffsets
                dc.w    HCZEndBossS3_Fan_AnimateAndPollRootFlag-HCZEndBossS3_Fan_FiveStateOffsets
                dc.w    HCZEndBossS3_Fan_RunDeceleratingRaw-HCZEndBossS3_Fan_FiveStateOffsets
; ---------------------------------------------------------------------------

HCZBossS3_InitFan:
                lea     HCZEndBossS3_Fan_PartialAttributeRecord(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

HCZEndBossS3_Fan_WaitForRootFanFlag:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   HCZBossS3_FanBeginAcceleration
                rts
; ---------------------------------------------------------------------------

HCZBossS3_FanBeginAcceleration:
                move.b  #4,routine(a0)
                move.b  #$A6,collision_flags(a0)
                move.l  #HCZEndBossS3_Fan_AcceleratingRawStream,$30(a0)
                move.l  #HCZBossS3_FanBeginActiveAndSpawnColumn,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_FanAccelerateWithSound:
                moveq   #signextendB(sfx_FanBig),d0
                jsr     (Play_SFX_Continuous).l
                jmp     (Animate_RawGetFaster).l
; ---------------------------------------------------------------------------

HCZBossS3_FanBeginActiveAndSpawnColumn:
                move.b  #6,routine(a0)
                move.l  #HCZEndBossS3_Fan_UniformActiveRawStream,$30(a0)
                lea     HCZEndBossS3_Fan_OneNormalColumnRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZEndBossS3_Fan_AnimateAndPollRootFlag:
                jsr     (Animate_Raw).l
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   HCZEndBossS3_Fan_StartDecelerationStream
                moveq   #signextendB(sfx_FanBig),d0
                jmp     (Play_SFX_Continuous).l
; ---------------------------------------------------------------------------

HCZEndBossS3_Fan_StartDecelerationStream:
                move.b  #8,routine(a0)
                move.l  #HCZEndBossS3_Fan_DeceleratingRawStream,$30(a0)
                move.l  #HCZBossS3_FanIdleAndDisableTouch,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZEndBossS3_Fan_RunDeceleratingRaw:
                jmp     (Animate_RawGetSlower).l
; ---------------------------------------------------------------------------

HCZBossS3_FanIdleAndDisableTouch:
                move.b  #2,routine(a0)
                clr.b   collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_ColumnDispatchSolidAndDraw:
                move.w  x_pos(a0),-(sp)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZEndBossS3_Column_SixStateOffsets(pc,d0.w),d1
                jsr     HCZEndBossS3_Column_SixStateOffsets(pc,d1.w)
                move.w  #$1F,d1
                move.w  #$C,d2
                move.w  #$C,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectTop).l
                bsr.w   StartHCZBossColumnDescentAfterRootDeath
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
HCZEndBossS3_Column_SixStateOffsets:
                dc.w    HCZBossS3_InitColumnAtWater-HCZEndBossS3_Column_SixStateOffsets
                dc.w    HCZEndBossS3_Column_AnimateInitialBuild-HCZEndBossS3_Column_SixStateOffsets
                dc.w    HCZBossS3_ColumnMoveAnimateAndSetHeight-HCZEndBossS3_Column_SixStateOffsets
                dc.w    HCZBossS3_ColumnHoldUntilFanStops-HCZEndBossS3_Column_SixStateOffsets
                dc.w    HCZBossS3_ColumnMoveAnimateAndSetHeight-HCZEndBossS3_Column_SixStateOffsets
                dc.w    HCZBossS3_ColumnFinalSolidAndDraw-HCZEndBossS3_Column_SixStateOffsets
; ---------------------------------------------------------------------------

HCZBossS3_InitColumnAtWater:
                lea     HCZBossS3_ColumnAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.w  (Water_level).w,d0
                subq.w  #8,d0
                move.w  d0,y_pos(a0)
                move.w  d0,$3A(a0)
                move.l  #HCZBossS3_ColumnBuildAnim,$30(a0)
                move.l  #HCZBossS3_ColumnRiseAndSpawnVortex,$34(a0)
                lea     HCZEndBossS3_Surface_TwoNormalEdgeRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     HCZBossS3_ColumnBubbleChildren(pc),a2
                jsr     (CreateChild6_Simple).l
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                rts
; ---------------------------------------------------------------------------

HCZEndBossS3_Column_AnimateInitialBuild:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

HCZBossS3_ColumnRiseAndSpawnVortex:
                move.b  #4,routine(a0)
                move.l  #HCZBossS3_ColumnTravelAnim,$30(a0)
                move.w  #-$100,y_vel(a0)
                move.l  #HCZBossS3_ColumnHoldHeight,$34(a0)
                lea     HCZBossS3_ColumnVortexChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZBossS3_ColumnMoveAnimateAndSetHeight:
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                bra.w   HCZBossColumn_UpdateHeight
; ---------------------------------------------------------------------------

HCZBossS3_ColumnHoldHeight:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_ColumnHoldUntilFanStops:
                jsr     (Animate_Raw).l
                movea.w $44(a0),a1
                btst    #3,$38(a1)
                beq.s   HCZBossS3_ColumnDetachAndDrift
                rts
; ---------------------------------------------------------------------------

; Drift downward and use the parent's horizontal direction
HCZBossS3_ColumnDetachAndDrift:
                move.b  #8,routine(a0)
                bset    #3,$38(a0)
                move.w  #$80,y_vel(a0)
                move.l  #HCZBossS3_ColumnBeginFinalSolidWait,$34(a0)
                move.w  #$80,x_vel(a0)
                tst.w   x_vel(a1)
                bpl.s   HCZBossS3_ColumnDriftInitReturn
                neg.w   x_vel(a0)

HCZBossS3_ColumnDriftInitReturn:
                rts
; ---------------------------------------------------------------------------
; unused
                bra.w   HCZBossColumn_UpdateHeight
; ---------------------------------------------------------------------------

HCZBossS3_ColumnBeginFinalSolidWait:
                move.l  #HCZBossS3_ColumnFinalSolidAndDraw,(a0)
                move.w  #$F,$2E(a0)
                clr.w   x_vel(a0)
                move.l  #HCZBossS3_ColumnReleaseRidersAndDelete,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossS3_ColumnFinalSolidAndDraw:
                move.w  #$1F,d1
                move.w  #$C,d2
                move.w  #$C,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZBossS3_ColumnReleaseRidersAndDelete:
                jsr     (Displace_PlayerOffObject).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

HCZBossS3_ColumnDescendOnBossDeath:
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                bsr.w   HCZBossColumn_UpdateHeight
                jmp     (Draw_Sprite).l
