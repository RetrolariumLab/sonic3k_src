; Owner: objects/bosses/icz/s3
; Responsibility: IceCap end-boss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZEndBoss:
                lea     ICZBossS3_ArenaActivationBounds(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #ICZBossS3_TickArenaTransition,(a0)
                move.b  #1,(Boss_flag).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #2*60,$2E(a0)
                move.b  #mus_EndBoss,$26(a0)
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  #$5F8,(Camera_target_max_Y_pos).w
                move.w  #$4390,$1C(a0)
                move.w  #$4390,(Camera_max_X_pos).w
                move.l  #ICZBossS3_InstallBattleDispatcher,$34(a0)
                moveq   #PLCID_70,d0
                jsr     (Load_PLC).l
                lea     Pal_ICZEndBoss(pc),a1
                jmp     PalLoad_Line1(pc)
; ---------------------------------------------------------------------------
ICZBossS3_ArenaActivationBounds:
                dc.w    0,  $6C0, $4340, $4390
; ---------------------------------------------------------------------------

ICZBossS3_TickArenaTransition:
                jmp     S3EndCamera_TickMusicDelay(pc)
; ---------------------------------------------------------------------------

ICZBossS3_InstallBattleDispatcher:
                move.l  #ICZBossS3_BattleDispatchHitAndDraw,(a0)

ICZBossS3_SharedReturn:
                rts
; ---------------------------------------------------------------------------

ICZBossS3_BattleDispatchHitAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZEndBossS3_Root_FourStateOffsets(pc,d0.w),d1
                jsr     ICZEndBossS3_Root_FourStateOffsets(pc,d1.w)
                bsr.w   ICZBoss_HandleHitPhaseOrDefeat
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
ICZEndBossS3_Root_FourStateOffsets:
                dc.w    ICZBossS3_InitBodyAndTryShip-ICZEndBossS3_Root_FourStateOffsets
                dc.w    ICZEndBossS3_Root_MoveEntranceThenWait-ICZEndBossS3_Root_FourStateOffsets
                dc.w    ICZBossS3_BobAndTickTurn-ICZEndBossS3_Root_FourStateOffsets
                dc.w    ICZBossS3_DescendDuringPhaseChange-ICZEndBossS3_Root_FourStateOffsets
; ---------------------------------------------------------------------------

ICZBossS3_InitBodyAndTryShip:
                lea     ICZEndBossS3_Root_FullBodyAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #8,collision_property(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$CF,$2E(a0)
                move.l  #ICZBossS3_InitBobAndTurnCounter,$34(a0)
                lea     (ICZBossS3_ShipChild).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   ICZBossS3_SpawnBodyAttachments
                move.b  #9,subtype(a1)

ICZBossS3_SpawnBodyAttachments:
                lea     ICZBossS3_BodyAttachmentChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

ICZEndBossS3_Root_MoveEntranceThenWait:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZBossS3_InitBobAndTurnCounter:
                move.w  #$7FFF,$44(a0)
                bsr.w   InitializeICZEndBossVerticalBob
                move.b  #4,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #ICZBossS3_RequestExtensionAndWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_BobAndTickTurn:
                jsr     Swing_UpAndDown(pc)
                subq.w  #1,$44(a0)
                bpl.s   ICZBossS3_MoveAndTickExtension
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  #$17F,$44(a0)

ICZBossS3_MoveAndTickExtension:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZBossS3_RequestExtensionAndWait:
                bset    #2,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #ICZBossS3_BeginLeftDriftAndAttackWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_BeginLeftDriftAndAttackWait:
                move.w  #$3F,$2E(a0)
                move.w  #-$80,x_vel(a0)
                move.w  #$17F,$44(a0)
                move.l  #ICZBossS3_RequestFrostAndSpawnClouds,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_RequestFrostAndSpawnClouds:
                move.l  #ICZBossS3_ClearFrostAndRestartWait,$34(a0)
                moveq   #signextendB(sfx_FrostPuff),d0
                jsr     (Play_SFX).l
                bsr.w   SelectICZEndBossFrostAttackMode
                cmpi.w  #2,$26(a0)
                bne.w   ICZBossS3_SharedReturn
                lea     ICZBossS3_Mode2CloudChildren(pc),a2
                jmp     CreateChild6_Simple(pc)
; ---------------------------------------------------------------------------

ICZBossS3_ClearFrostAndRestartWait:
                bclr    #1,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #ICZBossS3_RequestFrostAndSpawnClouds,$34(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_DescendDuringPhaseChange:
                subq.w  #1,$3C(a0)
                bmi.s   ICZBossS3_ResumeBobbing
                addi.l  #$8000,y_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZBossS3_ResumeBobbing:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_ReleasePartsAndSpawnDebris:
                move.l  #Obj_Wait,(a0)
                bclr    #7,render_flags(a0)
                bset    #4,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #ICZBossS3_SignalCapsuleAndReleaseCamera,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                lea     ICZBossS3_DefeatFragmentChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

ICZBossS3_SignalCapsuleAndReleaseCamera:
                move.l  #ICZBossS3_RestorePlayersAndExitBounds,(a0)
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                jsr     (Restore_LevelMusic).l
                move.w  #$4390+$130,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   ICZBossS3_DefeatCameraSpawnReturn
                move.l  #Obj_IncLevEndXGradual,(a1)

ICZBossS3_DefeatCameraSpawnReturn:
                rts
; ---------------------------------------------------------------------------

ICZBossS3_RestorePlayersAndExitBounds:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (_unkFAA8).w
                bne.w   ICZBossS3_SharedReturn
                clr.b   (_unkFAA8).w
                jsr     Restore_PlayerControl(pc)
                lea     (Player_2).w,a1
                jsr     Restore_PlayerControl2(pc)
                move.w  (Camera_stored_max_Y_pos).w,(Camera_target_max_Y_pos).w
                move.w  #$47C0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

ICZBossS3_UpperFollowDispatchAndDraw:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZEndBossS3_Upper_ThreeStateOffsets(pc,d0.w),d1
                jsr     ICZEndBossS3_Upper_ThreeStateOffsets(pc,d1.w)
                moveq   #$C,d0
                jmp     Child_Draw_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------
ICZEndBossS3_Upper_ThreeStateOffsets:
                dc.w    ICZBossS3_InitUpperAttachment-ICZEndBossS3_Upper_ThreeStateOffsets
                dc.w    ICZEndBossS3_Upper_WaitForPhaseTwoByte-ICZEndBossS3_Upper_ThreeStateOffsets
                dc.w    ICZBossS3_UpperTickEmissionWait-ICZEndBossS3_Upper_ThreeStateOffsets
; ---------------------------------------------------------------------------

ICZBossS3_InitUpperAttachment:
                lea     ICZBossS3_UpperAttributes(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

ICZEndBossS3_Upper_WaitForPhaseTwoByte:
                movea.w parent3(a0),a1
                tst.b   $3B(a1)
                bne.s   ICZBossS3_UpperBeginEmissionDelay
                rts
; ---------------------------------------------------------------------------

ICZBossS3_UpperBeginEmissionDelay:
                move.b  #4,routine(a0)
                move.b  #4,mapping_frame(a0)
                move.w  #$E,$2E(a0)
                move.l  #ICZBossS3_UpperSpawnModeSixClouds,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_UpperTickEmissionWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZBossS3_UpperSpawnModeSixClouds:
                move.w  #$17,$2E(a0)
                move.w  #6,$26(a0)
                lea     ICZBossS3_Mode6CloudChildren(pc),a2
                jmp     CreateChild6_Simple(pc)
; ---------------------------------------------------------------------------

ICZBossS3_CoverFollowAndCheckBreakaway:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZBossS3_CoverStateOffsets(pc,d0.w),d1
                jsr     ICZBossS3_CoverStateOffsets(pc,d1.w)
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                movea.w parent3(a0),a1
                tst.b   $3B(a1)
                bne.w   S3Child_StartFlickerAndDraw
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
ICZBossS3_CoverStateOffsets:
                dc.w    ICZBossS3_InitCover-ICZBossS3_CoverStateOffsets
                dc.w    ICZBossS3_CoverCheckExtension-ICZBossS3_CoverStateOffsets
                dc.w    ICZBossS3_CoverStepOffsetAndWait-ICZBossS3_CoverStateOffsets
                dc.w    ICZBossS3_CoverWaitForClose-ICZBossS3_CoverStateOffsets
                dc.w    ICZBossS3_CoverStepClosingAndWait-ICZBossS3_CoverStateOffsets
; ---------------------------------------------------------------------------

ICZBossS3_InitCover:
                lea     ICZBossS3_CoverAttributes(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

ICZBossS3_CoverCheckExtension:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   ICZBossS3_CoverBeginOffsetMovement
                rts
; ---------------------------------------------------------------------------

ICZBossS3_CoverBeginOffsetMovement:
                move.b  #4,routine(a0)
                move.w  #$24,$2E(a0)
                move.l  #ICZBossS3_CoverBeginOpenHold,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_CoverStepOffsetAndWait:
                addq.b  #1,$43(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZBossS3_CoverBeginOpenHold:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_CoverWaitForClose:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   ICZBossS3_CoverBeginClosing
                rts
; ---------------------------------------------------------------------------

ICZBossS3_CoverBeginClosing:
                move.b  #8,routine(a0)
                move.w  #$24,$2E(a0)
                move.l  #ICZBossS3_RearmAttachmentEdgeWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_CoverStepClosingAndWait:
                subq.b  #1,$43(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

ICZBossS3_RearmAttachmentEdgeWait:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_PlatformFollowSolidAndDraw:
                move.w  x_pos(a0),-(sp)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZBossS3_PlatformStateOffsets(pc,d0.w),d1
                jsr     ICZBossS3_PlatformStateOffsets(pc,d1.w)
                jsr     Refresh_ChildPosition(pc)
                moveq   #$23,d1
                moveq   #4,d2
                moveq   #$A,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                moveq   #0,d0
                movea.w parent3(a0),a1
                tst.b   $3B(a1)
                bne.s   ICZBossS3_PlatformReleaseRiders
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

ICZBossS3_PlatformReleaseRiders:
                jsr     Displace_PlayerOffObject(pc)
                jmp     S3Child_StartFlickerAndDraw(pc)
; ---------------------------------------------------------------------------
ICZBossS3_PlatformStateOffsets:
                dc.w    ICZBossS3_InitPlatformAndTouchProxy-ICZBossS3_PlatformStateOffsets
                dc.w    ICZBossS3_PlatformWaitForExtension-ICZBossS3_PlatformStateOffsets
                dc.w    ICZBossS3_CoverStepOffsetAndWait-ICZBossS3_PlatformStateOffsets
                dc.w    ICZBossS3_OpenPlatformTryFrostClouds-ICZBossS3_PlatformStateOffsets
                dc.w    ICZBossS3_CoverStepClosingAndWait-ICZBossS3_PlatformStateOffsets
; ---------------------------------------------------------------------------

ICZBossS3_InitPlatformAndTouchProxy:
                lea     ICZBossS3_PlatformAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                lea     ICZBossS3_PlatformTouchProxyChild(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

ICZBossS3_PlatformWaitForExtension:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   ICZBossS3_PlatformBeginOffsetMovement
                rts
; ---------------------------------------------------------------------------

ICZBossS3_PlatformBeginOffsetMovement:
                move.b  #4,routine(a0)
                move.w  #$42,$2E(a0)
                move.l  #ICZBossS3_CoverBeginOpenHold,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_OpenPlatformTryFrostClouds:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   ICZBossS3_PlatformBeginClosing
                btst    #1,$38(a1)
                beq.s   ICZBossS3_PlatformUpdateReturn
                move.w  $26(a1),d0
                cmpi.w  #2,d0
                beq.s   ICZBossS3_PlatformUpdateReturn
                move.w  d0,$26(a0)
                lea     ICZBossS3_PlatformCloudChildren(pc),a2
                jsr     CreateChild6_Simple(pc)

ICZBossS3_PlatformUpdateReturn:
                rts
; ---------------------------------------------------------------------------

ICZBossS3_PlatformBeginClosing:
                move.b  #8,routine(a0)
                move.w  #$42,$2E(a0)
                move.l  #ICZBossS3_RearmAttachmentEdgeWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_InitCloudAndDelay:
                lea     ICZEndBossS3_Cloud_FullAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #Obj_Wait,(a0)
                move.l  #ICZBossS3_CloudChooseFollowMode,$34(a0)
                bra.w   ICZBossS3_CloudLoadModeResources
; ---------------------------------------------------------------------------

ICZBossS3_CloudChooseFollowMode:
                movea.w parent3(a0),a1
                move.l  #ICZBossS3_CloudFollowAndCheckCapture,(a0)
                cmpi.w  #6,$26(a1)
                bne.s   ICZBossS3_CloudSetDeleteCallback
                move.l  #ICZBossS3_CloudAdjustedFollowCapture,(a0)

ICZBossS3_CloudSetDeleteCallback:
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

; Enable freezing while the animation cursor is between 4 and 8, inclusive
ICZBossS3_CloudFollowAndCheckCapture:
                jsr     Refresh_ChildPosition(pc)
                jsr     Animate_RawMultiDelay(pc)
                cmpi.b  #4,anim_frame(a0)
                blo.s   ICZBossS3_CloudFollowDraw
                cmpi.b  #8,anim_frame(a0)
                bhi.s   ICZBossS3_CloudFollowDraw
                lea     ICZBossS3_CloudFollowCaptureBounds(pc),a1
                jsr     (CapturePlayersInsideIczFreezerZone).l

ICZBossS3_CloudFollowDraw:
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
ICZBossS3_CloudFollowCaptureBounds:
                dc.w    -$18,   $30,  -$18,   $30
; ---------------------------------------------------------------------------

ICZBossS3_CloudAdjustedFollowCapture:
                jsr     Refresh_ChildPositionAdjusted(pc)
                jsr     Animate_RawMultiDelay(pc)
                cmpi.b  #4,anim_frame(a0)
                blo.s   ICZBossS3_CloudAdjustedFollowDraw
                cmpi.b  #8,anim_frame(a0)
                bhi.s   ICZBossS3_CloudAdjustedFollowDraw
                lea     ICZBossS3_CloudAdjustedCaptureBounds(pc),a1
                jsr     (CapturePlayersInsideIczFreezerZone).l

ICZBossS3_CloudAdjustedFollowDraw:
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
ICZBossS3_CloudAdjustedCaptureBounds:
                dc.w    -$10,   $20,  -$10,   $20
; ---------------------------------------------------------------------------

ICZBossS3_InitInvisibleTouchProxy:
                move.l  #ICZBossS3_TouchProxyFollowAndSubmit,(a0)
                move.b  #$9B,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_TouchProxyFollowAndSubmit:
                jsr     Refresh_ChildPosition(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   ICZBossS3_TouchProxyDeleteWithParent
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

ICZBossS3_TouchProxyDeleteWithParent:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

ICZBossS3_InitDefeatFragment:
                lea     ICZBossS3_FragmentAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$16,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$34,d0
                jmp     Set_IndexedVelocity(pc)

; =============== S U B R O U T I N E =======================================

InitializeICZEndBossVerticalBob:
                move.w  #$C0,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
; End of function InitializeICZEndBossVerticalBob

; =============== S U B R O U T I N E =======================================

SelectICZEndBossFrostAttackMode:
                bset    #1,$38(a0)
                tst.b   $3B(a0)
                bne.s   ICZBossS3_ForceDamagedFrostMode
                move.b  $3A(a0),d0
                andi.w  #$F,d0
                lea     ICZBossS3_FrostModeCycle(pc),a1
                move.b  (a1,d0.w),$27(a0)
                addq.b  #1,d0
                move.b  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_ForceDamagedFrostMode:
                move.w  #2,$26(a0)
                rts
; End of function SelectICZEndBossFrostAttackMode

; ---------------------------------------------------------------------------

ICZBossS3_CloudLoadModeResources:
                movea.w parent3(a0),a1
                move.w  $26(a1),d0
                moveq   #0,d1
                move.b  subtype(a0),d1
                lea     ICZBossS3_CloudSpawnOffsetBanks(pc),a2
                move.w  (a2,d0.w),d2
                adda.w  d2,a2
                move.w  (a2,d1.w),child_dx(a0)          ; and child_dy
                lea     ICZBossS3_CloudRenderFlagBanks(pc),a2
                move.w  (a2,d0.w),d2
                adda.w  d2,a2
                move.b  (a2,d1.w),d2
                or.b    d2,render_flags(a0)
                lea     ICZBossS3_CloudDelayBankOffsets(pc),a2
                move.w  (a2,d0.w),d2
                adda.w  d2,a2
                move.w  (a2,d1.w),$2E(a0)
                cmpi.b  #6,d0
                beq.s   ICZBossS3_CloudSelectModeSixAnim
                add.w   d1,d1
                move.l  ICZBossS3_CloudAnimationPointers(pc,d1.w),$30(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossS3_CloudSelectModeSixAnim:
                move.l  #ICZBossS3_CloudMode6Anim,$30(a0)
                rts
; ---------------------------------------------------------------------------
ICZBossS3_CloudDelayBankOffsets:
                dc.w    ICZBossS3_CloudDelayStart17-ICZBossS3_CloudDelayBankOffsets
                dc.w    ICZBossS3_CloudDelayStart14-ICZBossS3_CloudDelayBankOffsets
                dc.w    ICZBossS3_CloudDelayStart17-ICZBossS3_CloudDelayBankOffsets
                dc.w    ICZBossS3_CloudDelayStart8-ICZBossS3_CloudDelayBankOffsets
ICZBossS3_CloudDelayStart17:
                dc.w    $11
ICZBossS3_CloudDelayStart14:
                dc.w    $E
                dc.w    $B
ICZBossS3_CloudDelayStart8:
                dc.w    8
                dc.w    5
                dc.w    2
                dc.w    $FFFF
ICZBossS3_CloudAnimationPointers:
                dc.l    ICZBossS3_CloudFrames11To15Anim
                dc.l    ICZBossS3_CloudFrames11To15Anim
                dc.l    ICZBossS3_CloudFrames11To15Anim
                dc.l    ICZBossS3_CloudFrames11To15Anim
                dc.l    ICZBossS3_CloudFrames5To10Anim
                dc.l    ICZBossS3_CloudFrames5To10Anim
                dc.l    ICZBossS3_CloudFrames5To10Anim
ICZBossS3_CloudSpawnOffsetBanks:
                dc.w    ICZBossS3_CloudMode0SpawnOffsets-ICZBossS3_CloudSpawnOffsetBanks
                dc.w    ICZBossS3_CloudMode2SpawnOffsets-ICZBossS3_CloudSpawnOffsetBanks
                dc.w    ICZBossS3_CloudMode4SpawnOffsets-ICZBossS3_CloudSpawnOffsetBanks
                dc.w    ICZBossS3_CloudMode6SpawnOffsets-ICZBossS3_CloudSpawnOffsetBanks
ICZBossS3_CloudMode0SpawnOffsets:
                dc.b    -$50, $14
                dc.b    -$40, $14
                dc.b    -$48,   4
                dc.b    -$40,   4
                dc.b    -$34,  $C
                dc.b    -$24,   8
                dc.b    -$1C,   4
ICZBossS3_CloudMode2SpawnOffsets:
                dc.b    8, $40
                dc.b    0, $3C
                dc.b    -$10, $40
                dc.b    -8, $3C
                dc.b    -4, $34
                dc.b    -4, $28
ICZBossS3_CloudMode4SpawnOffsets:
                dc.b    $50, $14
                dc.b    $40, $14
                dc.b    $48,   4
                dc.b    $40,   4
                dc.b    $34,  $C
                dc.b    $24,   8
                dc.b    $1C,   4
ICZBossS3_CloudMode6SpawnOffsets:
                dc.b    $18,  -4
                dc.b    $14,   0
                dc.b    $10,  -8
                dc.b    8,  -4
                even
ICZBossS3_CloudRenderFlagBanks:
                dc.w    ICZBossS3_CloudMode0RenderFlags-ICZBossS3_CloudRenderFlagBanks
                dc.w    ICZBossS3_CloudMode2RenderFlags-ICZBossS3_CloudRenderFlagBanks
                dc.w    ICZBossS3_CloudMode4RenderFlags-ICZBossS3_CloudRenderFlagBanks
                dc.w    ICZBossS3_CloudMode6RenderFlags-ICZBossS3_CloudRenderFlagBanks
ICZBossS3_CloudMode0RenderFlags:
                dc.b    2,   0
                dc.b    2,   0
                dc.b    0,   0
; The all-zero records also finish the preceding mode-zero table
ICZBossS3_CloudMode6RenderFlags:
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
ICZBossS3_CloudMode2RenderFlags:
                dc.b    1,   0
                dc.b    1,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
ICZBossS3_CloudMode4RenderFlags:
                dc.b    3,   0
                dc.b    3,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    1,   0
                even

; =============== S U B R O U T I N E =======================================

; Enter the late phase on a new hit at two HP. Reenable collision only on the eligible body frame
ICZBoss_HandleHitPhaseOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   ICZBossS3_HitUpdateReturn
                move.b  collision_property(a0),d0
                beq.s   ICZBossS3_BeginDefeatAndSignalSnow
                tst.b   $20(a0)
                bne.s   ICZBossS3_HitChooseFlashRow
                cmpi.b  #2,d0
                bne.s   ICZBossS3_BeginHitFlash
                st      $3B(a0)
                move.b  #6,routine(a0)
                move.w  #$7F,$3C(a0)

ICZBossS3_BeginHitFlash:
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

ICZBossS3_HitChooseFlashRow:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   ICZBossS3_HitCopyColorsAndTick
                addi.w  #2*2,d0

; Restore collision after expiry only if the mapping frame is zero
ICZBossS3_HitCopyColorsAndTick:
                bsr.w   CopyICZEndBossTwoColorPalette
                subq.b  #1,$20(a0)
                bne.s   ICZBossS3_HitUpdateReturn
                bclr    #6,status(a0)
                cmpi.b  #0,mapping_frame(a0)
                bne.s   ICZBossS3_HitUpdateReturn
                move.b  $25(a0),collision_flags(a0)

ICZBossS3_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

ICZBossS3_BeginDefeatAndSignalSnow:
                move.l  #Wait_Draw,(a0)
                move.l  #ICZBossS3_ReleasePartsAndSpawnDebris,$34(a0)
                movea.w (_unkFAAE).w,a1
                cmpi.l  #S3ICZSnowPile_UpdateCameraSnowEmitter,(a1)
                bne.s   ICZBossS3_StopTimerAndAwardScore
                bset    #5,$38(a1)

ICZBossS3_StopTimerAndAwardScore:
                jmp     BossDefeated_StopTimer(pc)
; End of function ICZBoss_HandleHitPhaseOrDefeat

; =============== S U B R O U T I N E =======================================

CopyICZEndBossTwoColorPalette:
                lea     ICZBossS3_HitPaletteDestinations(pc),a1
                lea     ICZBossS3_HitPaletteColorRows(pc,d0.w),a2
                jmp     CopyWordData_2(pc)
; End of function CopyICZEndBossTwoColorPalette

; ---------------------------------------------------------------------------
ICZBossS3_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$14, Normal_palette_line_2+$1C
ICZBossS3_HitPaletteColorRows:
                dc.w    $20,  $644
                dc.w    $EEE,  $AAA
ICZEndBossS3_Root_FullBodyAttributes:
                dc.l    Map_ICZEndBoss
                dc.w    make_art_tile(ArtTile_ICZEndBoss,1,1)
                dc.w    $280
                dc.b    $24, $24,   0,  $F
ICZBossS3_UpperAttributes:
                dc.w    $200
                dc.b    $14,   8,   3,   0
ICZBossS3_CoverAttributes:
                dc.w    $280
                dc.b    8,  $C,   1,   0
ICZBossS3_PlatformAttributes:
                dc.w    $280
                dc.b    $18, $2C,   2,   0
ICZEndBossS3_Cloud_FullAttributes:
                dc.l    Map_ICZEndBoss
                dc.w    make_art_tile(ArtTile_ICZEndBoss,1,1)
                dc.w    $80
                dc.b    $10, $10,   5,   0
ICZBossS3_FragmentAttributes:
                dc.w    $180
                dc.b    $14, $10,   0,   0
ICZBossS3_ShipChild:
                dc.w    1-1
                dc.l    Obj_RobotnikShip4
                dc.b    0,   0
ICZBossS3_BodyAttachmentChildren:
                dc.w    3-1
                dc.l    ICZBossS3_UpperFollowDispatchAndDraw
                dc.b    $18,   7
                dc.l    ICZBossS3_CoverFollowAndCheckBreakaway
                dc.b    0,  $B
                dc.l    ICZBossS3_PlatformFollowSolidAndDraw
                dc.b    0, $2D
ICZBossS3_Mode2CloudChildren:
                dc.w    6-1
                dc.l    ICZBossS3_InitCloudAndDelay
ICZBossS3_PlatformCloudChildren:
                dc.w    7-1
                dc.l    ICZBossS3_InitCloudAndDelay
ICZBossS3_Mode6CloudChildren:
                dc.w    4-1
                dc.l    ICZBossS3_InitCloudAndDelay
ICZBossS3_PlatformTouchProxyChild:
                dc.w    1-1
                dc.l    ICZBossS3_InitInvisibleTouchProxy
                dc.b    0,   8
ICZBossS3_DefeatFragmentChildren:
                dc.w    3-1
                dc.l    ICZBossS3_InitDefeatFragment
                dc.b    -$14,   4
                dc.l    ICZBossS3_InitDefeatFragment
                dc.b    $C,   4
                dc.l    ICZBossS3_InitDefeatFragment
                dc.b    0, $1C
ICZBossS3_CloudFrames5To10Anim:
                dc.b    5,   1
                dc.b    5,   1
                dc.b    6,   1
                dc.b    7,   2
                dc.b    8,   3
                dc.b    9,   4
                dc.b    $A,   5
                dc.b    $F4
ICZBossS3_CloudFrames11To15Anim:
                dc.b    $B,   2
                dc.b    $B,   2
                dc.b    $C,   3
                dc.b    $D,   4
                dc.b    $E,   5
                dc.b    $F,   6
                dc.b    $F4
ICZBossS3_CloudMode6Anim:
                dc.b    $10,   1
                dc.b    $10,   1
                dc.b    $11,   1
                dc.b    $12,   2
                dc.b    $13,   2
                dc.b    $14,   2
                dc.b    $15,   2
                dc.b    $F4
                dc.b    5,   0,   1, $FC
                even
Pal_ICZEndBoss:
                binclude "data/Levels/ICZ/Palettes/End Boss.bin"
                even
ICZBossS3_FrostModeCycle:
                dc.b    0,   2
                dc.b    4,   2
                dc.b    0,   2
                dc.b    4,   2
                dc.b    0,   2
                dc.b    0,   2
                dc.b    4,   2
                dc.b    2,   4
                even
