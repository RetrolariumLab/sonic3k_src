; Owner: objects/bosses/icz/sk
; Responsibility: IceCap end-boss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZEndBoss:
                lea     ICZMiniSK_EndBossCameraTriggerBounds(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #ICZBossSK_TickArenaTransition,(a0)
                move.l  #ICZBossSK_InstallBattleDispatcher,$34(a0)
                lea     ICZMiniSK_EndBossCameraTargetBounds(pc),a1
                move.b  #mus_EndBoss,boss_saved_mus(a0)
                jsr     (Boss_BeginCameraTransition).l
                moveq   #PLCID_70,d0
                jsr     (Load_PLC).l
                lea     Pal_ICZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

ICZBossSK_TickArenaTransition:
                jmp     (SKEndCamera_TickAndSaveMusic).l
; ---------------------------------------------------------------------------

ICZBossSK_InstallBattleDispatcher:
                move.l  #ICZBossSK_BattleDispatchHitAndDraw,(a0)

ICZBossSK_SharedReturn:
                rts
; ---------------------------------------------------------------------------

ICZBossSK_BattleDispatchHitAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZEndBossSK_Root_FourStateOffsets(pc,d0.w),d1
                jsr     ICZEndBossSK_Root_FourStateOffsets(pc,d1.w)
                bsr.w   ICZBoss_HandleHitPhaseOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
ICZEndBossSK_Root_FourStateOffsets:
                dc.w    ICZBossSK_InitBodyAndTryShip-ICZEndBossSK_Root_FourStateOffsets
                dc.w    ICZEndBossSK_Root_MoveEntranceThenWait-ICZEndBossSK_Root_FourStateOffsets
                dc.w    ICZBossSK_BobAndTickTurn-ICZEndBossSK_Root_FourStateOffsets
                dc.w    ICZBossSK_DescendDuringPhaseChange-ICZEndBossSK_Root_FourStateOffsets
; ---------------------------------------------------------------------------

ICZBossSK_InitBodyAndTryShip:
                lea     ICZEndBossSK_Root_FullBodyAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$CF,$2E(a0)
                move.l  #ICZBossSK_InitBobAndTurnCounter,$34(a0)
                lea     (ICZBossSK_ShipChild).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   ICZBossSK_SpawnBodyAttachments
                move.b  #9,subtype(a1)

ICZBossSK_SpawnBodyAttachments:
                lea     ICZBossSK_BodyAttachmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

ICZEndBossSK_Root_MoveEntranceThenWait:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZBossSK_InitBobAndTurnCounter:
                move.w  #$7FFF,$44(a0)
                bsr.w   InitializeICZEndBossVerticalBob
                move.b  #4,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #ICZBossSK_RequestExtensionAndWait,$34(a0)
                move.w  #$BF,$46(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossSK_BobAndTickTurn:
                jsr     (Swing_UpAndDown).l
                subq.w  #1,$44(a0)
                bpl.s   ICZBossSK_MoveAndTickExtension
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  #$17F,$44(a0)

ICZBossSK_MoveAndTickExtension:
                jsr     (MoveSprite2).l
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   ICZBossSK_TickExtensionWait
                subq.w  #1,$46(a0)
                bpl.s   ICZBossSK_TickExtensionWait
                move.w  #$7F,$46(a0)
                bchg    #2,$38(a0)

ICZBossSK_TickExtensionWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZBossSK_RequestExtensionAndWait:
                bset    #2,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #ICZBossSK_BeginLeftDriftAndAttackWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossSK_BeginLeftDriftAndAttackWait:
                move.w  #$3F,$2E(a0)
                move.w  #-$80,x_vel(a0)
                move.w  #$17F,$44(a0)
                move.l  #ICZBossSK_RequestFrostAndSpawnClouds,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossSK_RequestFrostAndSpawnClouds:
                move.l  #ICZBossSK_ClearFrostAndRestartWait,$34(a0)
                moveq   #signextendB(sfx_FrostPuff),d0
                jsr     (Play_SFX).l
                bsr.w   SelectICZEndBossFrostAttackMode
                cmpi.w  #2,$26(a0)
                bne.w   ICZBossSK_SharedReturn
                lea     ICZBossSK_Mode2CloudChildren(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

ICZBossSK_ClearFrostAndRestartWait:
                bclr    #1,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #ICZBossSK_RequestFrostAndSpawnClouds,$34(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossSK_DescendDuringPhaseChange:
                subq.w  #1,$3C(a0)
                bmi.s   ICZBossSK_ResumeBobbing
                addi.l  #$8000,y_pos(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZBossSK_ResumeBobbing:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossSK_ReleasePartsAndSpawnDebris:
                move.l  #Obj_Wait,(a0)
                bset    #4,$38(a0)
                move.l  #ICZBossSK_SignalCapsuleAndReleaseCamera,$34(a0)
                lea     ICZBossSK_DefeatFragmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

ICZBossSK_SignalCapsuleAndReleaseCamera:
                move.l  #ICZBossSK_RestorePlayersAndExitBounds,(a0)
                st      (ActCompletionHandshake).w
                clr.b   (Boss_flag).w
                jsr     (AllocateObject).l
                bne.s   ICZBossSK_SetDefeatCameraTarget
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$4560,x_pos(a1)
                move.w  #$6A3,y_pos(a1)

ICZBossSK_SetDefeatCameraTarget:
                move.w  (SceneMinimumXOrEmeraldSelectionTail).w,d0
                addi.w  #$130,d0
                move.w  d0,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   ICZBossSK_DefeatCameraSpawnReturn
                move.l  #Obj_IncLevEndXGradual,(a1)

ICZBossSK_DefeatCameraSpawnReturn:
                rts
; ---------------------------------------------------------------------------

ICZBossSK_RestorePlayersAndExitBounds:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (ActCompletionHandshake).w
                bne.w   ICZBossSK_SharedReturn
                clr.b   (ActCompletionHandshake).w
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                jsr     (Restore_LevelMusic).l
                move.w  (Camera_stored_max_Y_pos).w,(Camera_target_max_Y_pos).w
                move.w  #$47C0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

ICZBossSK_UpperFollowDispatchAndDraw:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZEndBossSK_Upper_ThreeStateOffsets(pc,d0.w),d1
                jsr     ICZEndBossSK_Upper_ThreeStateOffsets(pc,d1.w)
                moveq   #$C,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
ICZEndBossSK_Upper_ThreeStateOffsets:
                dc.w    ICZBossSK_InitUpperAttachment-ICZEndBossSK_Upper_ThreeStateOffsets
                dc.w    ICZEndBossSK_Upper_WaitForPhaseTwoByte-ICZEndBossSK_Upper_ThreeStateOffsets
                dc.w    ICZBossSK_UpperTickEmissionWait-ICZEndBossSK_Upper_ThreeStateOffsets
; ---------------------------------------------------------------------------

ICZBossSK_InitUpperAttachment:
                lea     ICZBossSK_UpperAttributes(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

ICZEndBossSK_Upper_WaitForPhaseTwoByte:
                movea.w parent3(a0),a1
                tst.b   $3B(a1)
                bne.s   ICZBossSK_UpperBeginEmissionDelay
                rts
; ---------------------------------------------------------------------------

ICZBossSK_UpperBeginEmissionDelay:
                move.b  #4,routine(a0)
                move.b  #4,mapping_frame(a0)
                move.w  #$E,$2E(a0)
                move.l  #ICZBossSK_UpperSpawnModeSixClouds,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossSK_UpperTickEmissionWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZBossSK_UpperSpawnModeSixClouds:
                move.w  #$17,$2E(a0)
                move.w  #6,$26(a0)
                lea     ICZBossSK_Mode6CloudChildren(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

ICZBossSK_CoverFollowAndCheckBreakaway:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZBossSK_CoverStateOffsets(pc,d0.w),d1
                jsr     ICZBossSK_CoverStateOffsets(pc,d1.w)
                jsr     (Refresh_ChildPosition).l
                moveq   #0,d0
                movea.w parent3(a0),a1
                tst.b   $3B(a1)
                bne.s   ICZBossSK_CoverBeginPhaseTwoFlicker
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

ICZBossSK_CoverBeginPhaseTwoFlicker:
                jmp     (SKChild_StartFlickerAndDraw).l
; ---------------------------------------------------------------------------
ICZBossSK_CoverStateOffsets:
                dc.w    ICZBossSK_InitCover-ICZBossSK_CoverStateOffsets
                dc.w    ICZBossSK_CoverCheckExtension-ICZBossSK_CoverStateOffsets
                dc.w    ICZBossSK_CoverStepOffsetAndWait-ICZBossSK_CoverStateOffsets
; ---------------------------------------------------------------------------

ICZBossSK_InitCover:
                lea     ICZBossSK_CoverAttributes(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

ICZBossSK_CoverCheckExtension:
                movea.w parent3(a0),a4
                move.b  $3A(a0),d0
                move.b  $38(a4),d1
                move.b  d1,$3A(a0)
                eor.b   d1,d0
                andi.b  #4,d0
                beq.s   ICZBossSK_CoverExtensionCheckReturn
                moveq   #1,d0
                btst    #2,d1
                bne.s   ICZBossSK_CoverBeginOffsetMovement
                neg.b   d0

ICZBossSK_CoverBeginOffsetMovement:
                move.b  d0,$40(a0)
                move.b  #4,routine(a0)
                move.w  #$24,$2E(a0)
                move.l  #ICZBossSK_RearmAttachmentEdgeWait,$34(a0)

ICZBossSK_CoverExtensionCheckReturn:
                rts
; ---------------------------------------------------------------------------

ICZBossSK_CoverStepOffsetAndWait:
                move.b  $40(a0),d0
                add.b   d0,$43(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZBossSK_RearmAttachmentEdgeWait:
                move.b  #2,routine(a0)
                movea.w parent3(a0),a1
                move.b  $38(a1),$3A(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossSK_PlatformFollowSolidAndDraw:
                move.w  x_pos(a0),-(sp)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZBossSK_PlatformStateOffsets(pc,d0.w),d1
                jsr     ICZBossSK_PlatformStateOffsets(pc,d1.w)
                jsr     (Refresh_ChildPosition).l
                moveq   #$23,d1
                moveq   #4,d2
                moveq   #$A,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                moveq   #0,d0
                movea.w parent3(a0),a1
                tst.b   $3B(a1)
                bne.s   ICZBossSK_PlatformReleaseRiders
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

ICZBossSK_PlatformReleaseRiders:
                jsr     (Displace_PlayerOffObject).l
                jmp     (SKChild_StartFlickerAndDraw).l
; ---------------------------------------------------------------------------
ICZBossSK_PlatformStateOffsets:
                dc.w    ICZBossSK_InitPlatformAndTouchProxy-ICZBossSK_PlatformStateOffsets
                dc.w    ICZBossSK_PlatformCheckFrostAndEdge-ICZBossSK_PlatformStateOffsets
                dc.w    ICZBossSK_PlatformCheckFrostWhileMoving-ICZBossSK_PlatformStateOffsets
; ---------------------------------------------------------------------------

ICZBossSK_InitPlatformAndTouchProxy:
                lea     ICZBossSK_PlatformAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                movea.w parent3(a0),a1
                lea     ICZBossSK_PlatformTouchProxyChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

ICZBossSK_PlatformCheckFrostAndEdge:
                movea.w parent3(a0),a4
                btst    #1,$38(a4)
                beq.s   ICZBossSK_PlatformCheckEdgeAndChooseStep
                bsr.w   ICZBossSK_PlatformSpawnNonModeTwoClouds

; An edge on root bit 2 selects the signed movement direction
ICZBossSK_PlatformCheckEdgeAndChooseStep:
                move.b  $3A(a0),d0
                move.b  $38(a4),d1
                move.b  d1,$3A(a0)
                eor.b   d1,d0
                andi.b  #4,d0
                beq.s   ICZBossSK_PlatformUpdateReturn
                moveq   #1,d0
                btst    #2,d1
                bne.s   ICZBossSK_PlatformBeginOffsetMovement
                neg.b   d0

ICZBossSK_PlatformBeginOffsetMovement:
                move.b  d0,$40(a0)
                move.b  #4,routine(a0)
                move.w  #$42,$2E(a0)
                move.l  #ICZBossSK_RearmAttachmentEdgeWait,$34(a0)

ICZBossSK_PlatformUpdateReturn:
                rts
; ---------------------------------------------------------------------------

ICZBossSK_PlatformCheckFrostWhileMoving:
                movea.w parent3(a0),a4
                btst    #1,$38(a4)
                beq.s   ICZBossSK_PlatformStepOffsetAndWait
                bsr.w   ICZBossSK_PlatformSpawnNonModeTwoClouds

ICZBossSK_PlatformStepOffsetAndWait:
                move.b  $40(a0),d0
                add.b   d0,$43(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------
; unused
                move.b  #2,routine(a0)
                move.b  $38(a4),$3A(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossSK_PlatformSpawnNonModeTwoClouds:
                move.w  $26(a4),d0
                cmpi.w  #2,d0
                beq.w   ICZBossSK_SharedReturn
                move.w  d0,$26(a0)
                lea     ICZBossSK_PlatformCloudChildren(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

ICZBossSK_InitCloudAndDelay:
                lea     ICZEndBossSK_Cloud_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_Wait,(a0)
                move.l  #ICZBossSK_CloudChooseFollowMode,$34(a0)
                bra.w   ICZBossSK_CloudLoadModeResources
; ---------------------------------------------------------------------------

ICZBossSK_CloudChooseFollowMode:
                movea.w parent3(a0),a1
                move.l  #ICZBossSK_CloudFollowAndCheckCapture,(a0)
                cmpi.w  #6,$26(a1)
                bne.s   ICZBossSK_CloudSetDeleteCallback
                move.l  #ICZBossSK_CloudAdjustedFollowCapture,(a0)

ICZBossSK_CloudSetDeleteCallback:
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

; Enable freezing while the animation cursor is between 4 and 8, inclusive
ICZBossSK_CloudFollowAndCheckCapture:
                jsr     (Refresh_ChildPosition).l
                jsr     (Animate_RawMultiDelay).l
                cmpi.b  #4,anim_frame(a0)
                blo.s   ICZBossSK_CloudFollowDraw
                cmpi.b  #8,anim_frame(a0)
                bhi.s   ICZBossSK_CloudFollowDraw
                lea     ICZBossSK_CloudFollowCaptureBounds(pc),a1
                jsr     (CapturePlayersInsideIczFreezerZone).l

ICZBossSK_CloudFollowDraw:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
ICZBossSK_CloudFollowCaptureBounds:
                dc.w    -$18,   $30,  -$18,   $30
; ---------------------------------------------------------------------------

ICZBossSK_CloudAdjustedFollowCapture:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Animate_RawMultiDelay).l
                cmpi.b  #4,anim_frame(a0)
                blo.s   ICZBossSK_CloudAdjustedFollowDraw
                cmpi.b  #8,anim_frame(a0)
                bhi.s   ICZBossSK_CloudAdjustedFollowDraw
                lea     ICZBossSK_CloudAdjustedCaptureBounds(pc),a1
                jsr     (CapturePlayersInsideIczFreezerZone).l

ICZBossSK_CloudAdjustedFollowDraw:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
ICZBossSK_CloudAdjustedCaptureBounds:
                dc.w    -$10,   $20,  -$10,   $20
; ---------------------------------------------------------------------------

ICZBossSK_InitInvisibleTouchProxy:
                move.l  #ICZBossSK_TouchProxyFollowAndSubmit,(a0)
                move.b  #$9B,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossSK_TouchProxyFollowAndSubmit:
                jsr     (Refresh_ChildPosition).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   ICZBossSK_TouchProxyDeleteWithParent
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

ICZBossSK_TouchProxyDeleteWithParent:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

ICZBossSK_InitDefeatFragment:
                lea     ICZBossSK_FragmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                jsr     (Refresh_ChildPositionAdjusted).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$16,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$34,d0
                jmp     (Set_IndexedVelocity).l

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
                bne.s   ICZBossSK_ForceDamagedFrostMode
                move.b  $3A(a0),d0
                andi.w  #$F,d0
                lea     ICZBossSK_FrostModeCycle(pc),a1
                move.b  (a1,d0.w),$27(a0)
                addq.b  #1,d0
                move.b  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossSK_ForceDamagedFrostMode:
                move.w  #2,$26(a0)
                rts
; End of function SelectICZEndBossFrostAttackMode

; ---------------------------------------------------------------------------

ICZBossSK_CloudLoadModeResources:
                movea.w parent3(a0),a1
                move.w  $26(a1),d0
                moveq   #0,d1
                move.b  subtype(a0),d1
                lea     ICZBossSK_CloudSpawnOffsetBanks(pc),a2
                move.w  (a2,d0.w),d2
                adda.w  d2,a2
                move.w  (a2,d1.w),child_dx(a0)          ; and child_dy
                lea     ICZBossSK_CloudRenderFlagBanks(pc),a2
                move.w  (a2,d0.w),d2
                adda.w  d2,a2
                move.b  (a2,d1.w),d2
                or.b    d2,render_flags(a0)
                lea     ICZBossSK_CloudDelayBankOffsets(pc),a2
                move.w  (a2,d0.w),d2
                adda.w  d2,a2
                move.w  (a2,d1.w),$2E(a0)
                cmpi.b  #6,d0
                beq.s   ICZBossSK_CloudSelectModeSixAnim
                add.w   d1,d1
                move.l  ICZBossSK_CloudAnimationPointers(pc,d1.w),$30(a0)
                rts
; ---------------------------------------------------------------------------

ICZBossSK_CloudSelectModeSixAnim:
                move.l  #ICZBossSK_CloudMode6Anim,$30(a0)
                rts
; ---------------------------------------------------------------------------
ICZBossSK_CloudDelayBankOffsets:
                dc.w    ICZBossSK_CloudDelayStart17-ICZBossSK_CloudDelayBankOffsets
                dc.w    ICZBossSK_CloudDelayStart14-ICZBossSK_CloudDelayBankOffsets
                dc.w    ICZBossSK_CloudDelayStart17-ICZBossSK_CloudDelayBankOffsets
                dc.w    ICZBossSK_CloudDelayStart8-ICZBossSK_CloudDelayBankOffsets
ICZBossSK_CloudDelayStart17:
                dc.w    $11
ICZBossSK_CloudDelayStart14:
                dc.w    $E
                dc.w    $B
ICZBossSK_CloudDelayStart8:
                dc.w    8
                dc.w    5
                dc.w    2
                dc.w    $FFFF
ICZBossSK_CloudAnimationPointers:
                dc.l    ICZBossSK_CloudFrames11To15Anim
                dc.l    ICZBossSK_CloudFrames11To15Anim
                dc.l    ICZBossSK_CloudFrames11To15Anim
                dc.l    ICZBossSK_CloudFrames11To15Anim
                dc.l    ICZBossSK_CloudFrames5To10Anim
                dc.l    ICZBossSK_CloudFrames5To10Anim
                dc.l    ICZBossSK_CloudFrames5To10Anim
ICZBossSK_CloudSpawnOffsetBanks:
                dc.w    ICZBossSK_CloudMode0SpawnOffsets-ICZBossSK_CloudSpawnOffsetBanks
                dc.w    ICZBossSK_CloudMode2SpawnOffsets-ICZBossSK_CloudSpawnOffsetBanks
                dc.w    ICZBossSK_CloudMode4SpawnOffsets-ICZBossSK_CloudSpawnOffsetBanks
                dc.w    ICZBossSK_CloudMode6SpawnOffsets-ICZBossSK_CloudSpawnOffsetBanks
ICZBossSK_CloudMode0SpawnOffsets:
                dc.b    -$50, $14
                dc.b    -$40, $14
                dc.b    -$48,   4
                dc.b    -$40,   4
                dc.b    -$34,  $C
                dc.b    -$24,   8
                dc.b    -$1C,   4
ICZBossSK_CloudMode2SpawnOffsets:
                dc.b    8, $40
                dc.b    0, $3C
                dc.b    -$10, $40
                dc.b    -8, $3C
                dc.b    -4, $34
                dc.b    -4, $28
ICZBossSK_CloudMode4SpawnOffsets:
                dc.b    $50, $14
                dc.b    $40, $14
                dc.b    $48,   4
                dc.b    $40,   4
                dc.b    $34,  $C
                dc.b    $24,   8
                dc.b    $1C,   4
ICZBossSK_CloudMode6SpawnOffsets:
                dc.b    $18,  -4
                dc.b    $14,   0
                dc.b    $10,  -8
                dc.b    8,  -4
                even
ICZBossSK_CloudRenderFlagBanks:
                dc.w    ICZBossSK_CloudMode0RenderFlags-ICZBossSK_CloudRenderFlagBanks
                dc.w    ICZBossSK_CloudMode2RenderFlags-ICZBossSK_CloudRenderFlagBanks
                dc.w    ICZBossSK_CloudMode4RenderFlags-ICZBossSK_CloudRenderFlagBanks
                dc.w    ICZBossSK_CloudMode6RenderFlags-ICZBossSK_CloudRenderFlagBanks
ICZBossSK_CloudMode0RenderFlags:
                dc.b    2,   0
                dc.b    2,   0
                dc.b    0,   0
; The all-zero records also finish the preceding mode-zero table
ICZBossSK_CloudMode6RenderFlags:
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
ICZBossSK_CloudMode2RenderFlags:
                dc.b    1,   0
                dc.b    1,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
ICZBossSK_CloudMode4RenderFlags:
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
                bne.s   ICZBossSK_HitUpdateReturn
                move.b  collision_property(a0),d0
                beq.s   ICZBossSK_BeginDefeatAndSignalSnow
                tst.b   $20(a0)
                bne.s   ICZBossSK_HitChooseFlashRow
                cmpi.b  #2,d0
                bne.s   ICZBossSK_BeginHitFlash
                st      $3B(a0)
                move.b  #6,routine(a0)
                move.w  #$7F,$3C(a0)

ICZBossSK_BeginHitFlash:
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

ICZBossSK_HitChooseFlashRow:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   ICZBossSK_HitCopyColorsAndTick
                addi.w  #2*2,d0

; Restore collision after expiry only if the mapping frame is zero
ICZBossSK_HitCopyColorsAndTick:
                bsr.w   CopyICZEndBossTwoColorPalette
                subq.b  #1,$20(a0)
                bne.s   ICZBossSK_HitUpdateReturn
                bclr    #6,status(a0)
                cmpi.b  #0,mapping_frame(a0)
                bne.s   ICZBossSK_HitUpdateReturn
                move.b  $25(a0),collision_flags(a0)

ICZBossSK_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

ICZBossSK_BeginDefeatAndSignalSnow:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #ICZBossSK_ReleasePartsAndSpawnDebris,$34(a0)
                movea.w (SceneActorOrWorldOffset).w,a1
                cmpi.l  #SKICZSnowPile_UpdateCameraSnowEmitter,(a1)
                bne.s   ICZBossSK_StopTimerAndAwardScore
                bset    #5,$38(a1)

ICZBossSK_StopTimerAndAwardScore:
                jmp     (BossDefeated_StopTimer).l
; End of function ICZBoss_HandleHitPhaseOrDefeat

; =============== S U B R O U T I N E =======================================

CopyICZEndBossTwoColorPalette:
                lea     ICZBossSK_HitPaletteDestinations(pc),a1
                lea     ICZBossSK_HitPaletteColorRows(pc,d0.w),a2
                jmp     (CopyWordData_2).l
; End of function CopyICZEndBossTwoColorPalette

; ---------------------------------------------------------------------------
ICZBossSK_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$14, Normal_palette_line_2+$1C
ICZBossSK_HitPaletteColorRows:
                dc.w    $20,  $644
                dc.w    $EEE,  $AAA
ICZEndBossSK_Root_FullBodyAttributes:
                dc.l    Map_ICZEndBoss
                dc.w    make_art_tile(ArtTile_ICZEndBoss,1,1)
                dc.w    $280
                dc.b    $24, $24,   0,  $F
ICZBossSK_UpperAttributes:
                dc.w    $200
                dc.b    $14,   8,   3,   0
ICZBossSK_CoverAttributes:
                dc.w    $280
                dc.b    8,  $C,   1,   0
ICZBossSK_PlatformAttributes:
                dc.w    $280
                dc.b    $18, $2C,   2,   0
ICZEndBossSK_Cloud_FullAttributes:
                dc.l    Map_ICZEndBoss
                dc.w    make_art_tile(ArtTile_ICZEndBoss,1,1)
                dc.w    $80
                dc.b    $10, $10,   5,   0
ICZBossSK_FragmentAttributes:
                dc.w    $180
                dc.b    $14, $10,   0,   0
ICZBossSK_ShipChild:
                dc.w    1-1
                dc.l    Obj_RobotnikShip4
                dc.b    0,   0
ICZBossSK_BodyAttachmentChildren:
                dc.w    3-1
                dc.l    ICZBossSK_UpperFollowDispatchAndDraw
                dc.b    $18,   7
                dc.l    ICZBossSK_CoverFollowAndCheckBreakaway
                dc.b    0,  $B
                dc.l    ICZBossSK_PlatformFollowSolidAndDraw
                dc.b    0, $2D
ICZBossSK_Mode2CloudChildren:
                dc.w    6-1
                dc.l    ICZBossSK_InitCloudAndDelay
ICZBossSK_PlatformCloudChildren:
                dc.w    7-1
                dc.l    ICZBossSK_InitCloudAndDelay
ICZBossSK_Mode6CloudChildren:
                dc.w    4-1
                dc.l    ICZBossSK_InitCloudAndDelay
ICZBossSK_PlatformTouchProxyChild:
                dc.w    1-1
                dc.l    ICZBossSK_InitInvisibleTouchProxy
                dc.b    0,   8
ICZBossSK_DefeatFragmentChildren:
                dc.w    3-1
                dc.l    ICZBossSK_InitDefeatFragment
                dc.b    -$14,   4
                dc.l    ICZBossSK_InitDefeatFragment
                dc.b    $C,   4
                dc.l    ICZBossSK_InitDefeatFragment
                dc.b    0, $1C
ICZBossSK_CloudFrames5To10Anim:
                dc.b    5,   1
                dc.b    5,   1
                dc.b    6,   1
                dc.b    7,   2
                dc.b    8,   3
                dc.b    9,   4
                dc.b    $A,   5
                dc.b    $F4
ICZBossSK_CloudFrames11To15Anim:
                dc.b    $B,   2
                dc.b    $B,   2
                dc.b    $C,   3
                dc.b    $D,   4
                dc.b    $E,   5
                dc.b    $F,   6
                dc.b    $F4
ICZBossSK_CloudMode6Anim:
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
ICZBossSK_FrostModeCycle:
                dc.b    0,   2
                dc.b    4,   2
                dc.b    0,   2
                dc.b    4,   2
                dc.b    0,   2
                dc.b    0,   2
                dc.b    4,   2
                dc.b    2,   4
                even
