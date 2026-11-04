; Owner: objects/bosses/hcz/end_boss/sk
; Responsibility: Hydrocity end-boss battle control, defeat sequence, chassis states and coordinated child actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZEndBoss:
                lea     HCZMiniSK_EndBossDefaultCameraBounds(pc),a1
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   HCZBossSK_BeginArenaCameraAndArt
                lea     HCZMiniSK_EndBossKnucklesCameraBounds(pc),a1

HCZBossSK_BeginArenaCameraAndArt:
                jsr     (Check_CameraInRange).l
                move.b  #mus_EndBoss,boss_saved_mus(a0)
                jsr     (Boss_BeginCameraTransition).l
                move.l  #HCZBossSK_TickCameraMusicTransition,(a0)
                move.l  #HCZBossSK_InstallBattleDispatcher,$34(a0)
                moveq   #PLCID_6C,d0
                jsr     (Load_PLC).l
                move.w  #0,(Normal_palette+$1E).w
                lea     Pal_HCZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

HCZBossSK_TickCameraMusicTransition:
                jmp     (SKEndCamera_TickAndSaveMusic).l
; ---------------------------------------------------------------------------

HCZBossSK_InstallBattleDispatcher:
                move.l  #HCZBossSK_BattleDispatchHitAndDraw,(a0)

HCZBossSK_SharedReturn:
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BattleDispatchHitAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZEndBossSK_Root_SevenStateOffsets(pc,d0.w),d1
                jsr     HCZEndBossSK_Root_SevenStateOffsets(pc,d1.w)
                bsr.w   HCZBoss_HandleHitFlashOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
HCZEndBossSK_Root_SevenStateOffsets:
                dc.w    HCZBossSK_InitBodyAndSpawnShip-HCZEndBossSK_Root_SevenStateOffsets
                dc.w    HCZEndBossSK_Root_MoveStraightThenWait-HCZEndBossSK_Root_SevenStateOffsets
                dc.w    HCZEndBossSK_Root_BobMoveThenWait-HCZEndBossSK_Root_SevenStateOffsets
                dc.w    HCZEndBossSK_Root_MoveStraightThenWait-HCZEndBossSK_Root_SevenStateOffsets
                dc.w    HCZEndBossSK_Root_MoveStraightThenWait-HCZEndBossSK_Root_SevenStateOffsets
                dc.w    HCZEndBossSK_Root_BobMoveThenWait-HCZEndBossSK_Root_SevenStateOffsets
                dc.w    HCZBossSK_BobMoveAndTickTurn-HCZEndBossSK_Root_SevenStateOffsets
; ---------------------------------------------------------------------------

HCZBossSK_InitBodyAndSpawnShip:
                lea     ObjDat_HCZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$EF,$2E(a0)
                move.l  #HCZBossSK_SaveBaselineAndBeginBob,$34(a0)
                lea     (HCZEndBossSK_Root_OneNormalShipTwoRecord).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   HCZBossSK_SpawnBodyAttachments
                move.b  #5,subtype(a1)

HCZBossSK_SpawnBodyAttachments:
                lea     HCZBossSK_BodyAttachmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZEndBossSK_Root_MoveStraightThenWait:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZBossSK_SaveBaselineAndBeginBob:
                move.b  #4,routine(a0)
                move.w  y_pos(a0),$3A(a0)
                move.w  #-$100,$44(a0)
                move.w  #$9F,$30(a0)
                move.w  #$3F,$2E(a0)
                move.l  #HCZBossSK_StartFanAndCheckKnuckles,$34(a0)
                lea     (PLC_Explosion).l,a1
                jsr     (Load_PLC_Raw).l
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

HCZEndBossSK_Root_BobMoveThenWait:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZBossSK_StartFanAndCheckKnuckles:
                bset    #3,$38(a0)
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   HCZBossSK_BeginLongFanWait
                move.b  #6,routine(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$9F,$2E(a0)
                move.l  #HCZEndBossSK_Root_StartTimedFanAscent,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BeginLongFanWait:
                move.b  #$A,routine(a0)
                move.w  #$1FF,$2E(a0)
                move.l  #HCZBossSK_BeginBombSweep,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZEndBossSK_Root_StartTimedFanAscent:
                move.w  #-$100,y_vel(a0)
                move.w  #$4F,$2E(a0)
                move.l  #HCZBossSK_RestoreBaselineAndBob,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_RestoreBaselineAndBob:
                move.b  #$A,routine(a0)
                move.w  #$FF,$2E(a0)
                move.w  $3A(a0),y_pos(a0)
                move.l  #HCZBossSK_BeginBombSweep,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_BeginBombSweep:
                move.b  #$C,routine(a0)
                bclr    #3,$38(a0)
                move.w  $44(a0),x_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #HCZBossSK_RequestBombOrEndBurst,$34(a0)
                move.b  #8,$39(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

HCZBossSK_BobMoveAndTickTurn:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                subq.w  #1,$30(a0)
                bpl.s   HCZBossSK_TurnCounterReturn
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  #$13F,$30(a0)

HCZBossSK_TurnCounterReturn:
                rts
; ---------------------------------------------------------------------------

HCZBossSK_RequestBombOrEndBurst:
                move.w  #$5F,$2E(a0)
                subq.b  #1,$39(a0)
                bmi.s   HCZBossSK_SaveDriftAndRestartFan
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_SaveDriftAndRestartFan:
                move.w  x_vel(a0),$44(a0)
                clr.w   x_vel(a0)
                bra.w   HCZBossSK_StartFanAndCheckKnuckles
; ---------------------------------------------------------------------------

HCZBossSK_BeginDefeatBreakaway:
                move.l  #HCZBossSK_DefeatMoveWaitAndFlicker,(a0)
                bset    #4,$38(a0)
                move.l  #HCZBossSK_OpenCameraAndPrepareFinish,$34(a0)
                moveq   #$C,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

HCZBossSK_DefeatMoveWaitAndFlicker:
                jsr     (MoveSprite).l
                jsr     (Obj_Wait).l
                btst    #0,(V_int_run_count+3).w
                beq.w   HCZBossSK_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZBossSK_OpenCameraAndPrepareFinish:
                move.l  #HCZBossSK_WaitFinishAndRestorePlayers,(a0)
                bclr    #7,render_flags(a0)
                st      (ActCompletionHandshake).w
                clr.b   (Boss_flag).w
                move.w  (SceneMinimumXOrEmeraldSelectionTail).w,d0
                addi.w  #$180,d0
                move.w  d0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jsr     (CreateChild6_Simple).l
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   HCZEndBossSK_Root_AttemptKnucklesCapsule
                jsr     (AllocateObject).l
                bne.s   HCZBossSK_DefaultCapsuleSpawnReturn
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$4250,x_pos(a1)
                move.w  #$7E0,y_pos(a1)

HCZBossSK_DefaultCapsuleSpawnReturn:
                rts
; ---------------------------------------------------------------------------

HCZEndBossSK_Root_AttemptKnucklesCapsule:
                jsr     (AllocateObject).l
                bne.s   HCZBossSK_KnucklesCapsuleSpawnReturn
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$4760,x_pos(a1)
                move.w  #$360,y_pos(a1)

HCZBossSK_KnucklesCapsuleSpawnReturn:
                rts
; ---------------------------------------------------------------------------

HCZBossSK_WaitFinishAndRestorePlayers:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (ActCompletionHandshake).w
                bne.w   HCZBossSK_SharedReturn
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                st      (Ctrl_1_locked).w
                st      (Ctrl_2_locked).w
                move.b  #$80,(Player_1+object_control).w
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                jsr     (Restore_LevelMusic).l
                jsr     (AllocateObject).l
                bne.s   HCZBossSK_ClearCameraMinYAndDelete
                move.l  #HCZBossSK_ExitQueueArtAndRumble,(a1)

HCZBossSK_ClearCameraMinYAndDelete:
                move.w  #0,(Camera_min_Y_pos).w
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

HCZBossSK_FanDispatchFollowAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZEndBossSK_Fan_FiveStateOffsets(pc,d0.w),d1
                jsr     HCZEndBossSK_Fan_FiveStateOffsets(pc,d1.w)
                jsr     (Refresh_ChildPosition).l
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------
HCZEndBossSK_Fan_FiveStateOffsets:
                dc.w    HCZBossSK_InitFan-HCZEndBossSK_Fan_FiveStateOffsets
                dc.w    HCZEndBossSK_Fan_WaitForRootFanFlag-HCZEndBossSK_Fan_FiveStateOffsets
                dc.w    HCZBossSK_FanAccelerateWithSound-HCZEndBossSK_Fan_FiveStateOffsets
                dc.w    HCZEndBossSK_Fan_AnimateAndPollRootFlag-HCZEndBossSK_Fan_FiveStateOffsets
                dc.w    HCZEndBossSK_Fan_RunDeceleratingRaw-HCZEndBossSK_Fan_FiveStateOffsets
; ---------------------------------------------------------------------------

HCZBossSK_InitFan:
                lea     HCZEndBossSK_Fan_PartialAttributeRecord(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

HCZEndBossSK_Fan_WaitForRootFanFlag:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   HCZBossSK_FanBeginAcceleration
                rts
; ---------------------------------------------------------------------------

HCZBossSK_FanBeginAcceleration:
                move.b  #4,routine(a0)
                move.b  #$A6,collision_flags(a0)
                move.l  #HCZEndBossSK_Fan_AcceleratingRawStream,$30(a0)
                move.l  #HCZBossSK_FanBeginActiveAndSpawnColumn,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_FanAccelerateWithSound:
                moveq   #signextendB(sfx_FanBig),d0
                jsr     (Play_SFX_Continuous).l
                jmp     (Animate_RawGetFaster).l
; ---------------------------------------------------------------------------

HCZBossSK_FanBeginActiveAndSpawnColumn:
                move.b  #6,routine(a0)
                move.l  #HCZEndBossSK_Fan_UniformActiveRawStream,$30(a0)
                lea     HCZEndBossSK_Fan_OneNormalColumnRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZEndBossSK_Fan_AnimateAndPollRootFlag:
                jsr     (Animate_Raw).l
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   HCZEndBossSK_Fan_StartDecelerationStream
                moveq   #signextendB(sfx_FanBig),d0
                jmp     (Play_SFX_Continuous).l
; ---------------------------------------------------------------------------

HCZEndBossSK_Fan_StartDecelerationStream:
                move.b  #8,routine(a0)
                move.l  #HCZEndBossSK_Fan_DeceleratingRawStream,$30(a0)
                move.l  #HCZBossSK_FanIdleAndDisableTouch,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZEndBossSK_Fan_RunDeceleratingRaw:
                jmp     (Animate_RawGetSlower).l
; ---------------------------------------------------------------------------

HCZBossSK_FanIdleAndDisableTouch:
                move.b  #2,routine(a0)
                clr.b   collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_ColumnDispatchSolidAndDraw:
                move.w  x_pos(a0),-(sp)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZEndBossSK_Column_SixStateOffsets(pc,d0.w),d1
                jsr     HCZEndBossSK_Column_SixStateOffsets(pc,d1.w)
                move.w  #$1F,d1
                move.w  #$C,d2
                move.w  #$C,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectTop).l
                bsr.w   StartHCZBossColumnDescentAfterRootDeath
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
HCZEndBossSK_Column_SixStateOffsets:
                dc.w    HCZBossSK_InitColumnAtWater-HCZEndBossSK_Column_SixStateOffsets
                dc.w    HCZEndBossSK_Column_AnimateInitialBuild-HCZEndBossSK_Column_SixStateOffsets
                dc.w    HCZBossSK_ColumnMoveAnimateAndSetHeight-HCZEndBossSK_Column_SixStateOffsets
                dc.w    HCZBossSK_ColumnHoldUntilFanStops-HCZEndBossSK_Column_SixStateOffsets
                dc.w    HCZBossSK_ColumnMoveAnimateAndSetHeight-HCZEndBossSK_Column_SixStateOffsets
                dc.w    HCZBossSK_ColumnFinalSolidAndDraw-HCZEndBossSK_Column_SixStateOffsets
; ---------------------------------------------------------------------------

HCZBossSK_InitColumnAtWater:
                lea     HCZBossSK_ColumnAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.w  (Water_level).w,d0
                subq.w  #8,d0
                move.w  d0,y_pos(a0)
                move.w  d0,$3A(a0)
                move.l  #HCZBossSK_ColumnBuildAnim,$30(a0)
                move.l  #HCZBossSK_ColumnRiseAndSpawnVortex,$34(a0)
                lea     HCZEndBossSK_Surface_TwoNormalEdgeRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     HCZBossSK_ColumnBubbleChildren(pc),a2
                jsr     (CreateChild6_Simple).l
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                rts
; ---------------------------------------------------------------------------

HCZEndBossSK_Column_AnimateInitialBuild:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

HCZBossSK_ColumnRiseAndSpawnVortex:
                move.b  #4,routine(a0)
                move.l  #HCZBossSK_ColumnTravelAnim,$30(a0)
                move.w  #-$100,y_vel(a0)
                move.l  #HCZBossSK_ColumnHoldHeight,$34(a0)
                lea     HCZBossSK_ColumnVortexChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZBossSK_ColumnMoveAnimateAndSetHeight:
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                bra.w   HCZBossColumn_UpdateHeight
; ---------------------------------------------------------------------------

HCZBossSK_ColumnHoldHeight:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_ColumnHoldUntilFanStops:
                jsr     (Animate_Raw).l
                movea.w $44(a0),a1
                btst    #3,$38(a1)
                beq.s   HCZBossSK_ColumnDetachAndDrift
                rts
; ---------------------------------------------------------------------------

; Drift downward and use the parent's horizontal direction
HCZBossSK_ColumnDetachAndDrift:
                move.b  #8,routine(a0)
                bset    #3,$38(a0)
                move.w  #$80,y_vel(a0)
                move.l  #HCZBossSK_ColumnBeginFinalSolidWait,$34(a0)
                move.w  #$80,x_vel(a0)
                tst.w   x_vel(a1)
                bpl.s   HCZBossSK_ColumnDriftInitReturn
                neg.w   x_vel(a0)

HCZBossSK_ColumnDriftInitReturn:
                rts
; ---------------------------------------------------------------------------
; unused
                bra.w   HCZBossColumn_UpdateHeight
; ---------------------------------------------------------------------------

HCZBossSK_ColumnBeginFinalSolidWait:
                move.l  #HCZBossSK_ColumnFinalSolidAndDraw,(a0)
                move.w  #$F,$2E(a0)
                clr.w   x_vel(a0)
                move.l  #HCZBossSK_ColumnReleaseRidersAndDelete,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZBossSK_ColumnFinalSolidAndDraw:
                move.w  #$1F,d1
                move.w  #$C,d2
                move.w  #$C,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HCZBossSK_ColumnReleaseRidersAndDelete:
                jsr     (Displace_PlayerOffObject).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

HCZBossSK_ColumnDescendOnBossDeath:
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                bsr.w   HCZBossColumn_UpdateHeight
                jmp     (Draw_Sprite).l
