; Owner: objects/bosses/fbz/end_boss/sk
; Responsibility: Flying Battery end-boss controller, player attacks, attached actors and defeat sequence
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZEndBoss:
                move.l  #Obj_Wait,(a0)
                move.b  #1,(Boss_flag).w
                move.w  #(2*60)-1,$2E(a0)
                move.l  #FBZBossSK_InstallBattleDispatcher,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                jsr     (AllocateObject).l
                bne.s   FBZBossSK_LoadBossArtAfterSong
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

FBZBossSK_LoadBossArtAfterSong:
                moveq   #PLCID_6F,d0
                jsr     (Load_PLC).l
                lea     Pal_FBZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

FBZBossSK_InstallBattleDispatcher:
                move.l  #FBZBossSK_BattleDispatchHitAndDraw,(a0)

FBZBossSK_SharedGateReturn:
                rts
; ---------------------------------------------------------------------------

FBZBossSK_BattleDispatchHitAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZEndBoss_Index(pc,d0.w),d1
                jsr     FBZEndBoss_Index(pc,d1.w)
                bsr.w   HandleFBZEndBossFourColorHitOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
FBZEndBoss_Index:
                dc.w    FBZBossSK_InitBodyAndTryShip-FBZEndBoss_Index
                dc.w    FBZBossSK_FallToLandingThreshold-FBZEndBoss_Index
                dc.w    FBZBossSK_TickIntroOrbit-FBZEndBoss_Index
                dc.w    FBZBossSK_CenterAndCheckOrbitRequest-FBZEndBoss_Index
                dc.w    FBZBossSK_KnucklesRequestNextOrbit-FBZEndBoss_Index
; ---------------------------------------------------------------------------

FBZBossSK_InitBodyAndTryShip:
                lea     ObjDat_FBZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                move.b  #$80,$3C(a0)
                move.w  (Camera_X_pos_copy).w,d0
                addi.w  #$A0,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$60,d0
                move.w  d0,y_pos(a0)
                lea     (Child1_MakeFBZRoboShip).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   FBZBossSK_SpawnSupportsAndRequester
                move.b  #$B,subtype(a1)
                move.w  a1,$3E(a0)

FBZBossSK_SpawnSupportsAndRequester:
                lea     FBZBossSK_SupportAndFlameChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

FBZBossSK_FallToLandingThreshold:
                jsr     (MoveSprite).l
                move.w  #$690,d0
                subi.w  #$48,d0
                cmp.w   y_pos(a0),d0
                bls.s   FBZBossSK_LandAndBeginIntroOrbit
                rts
; ---------------------------------------------------------------------------

FBZBossSK_LandAndBeginIntroOrbit:
                move.w  d0,y_pos(a0)
                move.b  #4,routine(a0)
                bset    #7,$38(a0)
                move.w  #$5F,$2E(a0)
                move.l  #FBZBossSK_BeginSupportPulseCycle,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_TickIntroOrbit:
                bsr.w   FBZBoss_TryHalfTurnSound
                addq.b  #4,$3C(a0)
                lea     (FBZEndBoss_CircleLookup1).l,a2
                jsr     (MoveSprite_AngleYLookup).l
                bsr.w   SetFBZEndBossBodyDepthFromPhase
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZBossSK_BeginSupportPulseCycle:
                move.b  #6,routine(a0)
                bset    #3,$38(a0)
                move.w  #$3F,$2E(a0)
                move.b  #9,$39(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_CenterAndCheckOrbitRequest:
                bsr.w   CenterFBZEndBossXBetweenSupports
                jsr     (Find_SonicTails).l
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   FBZBossSK_CheckGroundedPlayerRequest
                bset    #1,$38(a0)
                bra.w   FBZBossSK_TickPulseAndChooseSide
; ---------------------------------------------------------------------------

; For the non-Knuckles path, require a grounded player within $18 pixels
FBZBossSK_CheckGroundedPlayerRequest:
                btst    #1,$38(a0)
                bne.s   FBZBossSK_OrbitRequestReturn
                btst    #0,$38(a0)
                bne.s   FBZBossSK_TickPulseAndChooseSide
                cmpi.w  #$18,d2
                bhs.s   FBZBossSK_TickPulseAndChooseSide
                btst    #Status_InAir,status(a1)
                bne.s   FBZBossSK_TickPulseAndChooseSide
                ori.b   #3,$38(a0)

FBZBossSK_TickPulseAndChooseSide:
                subq.w  #1,$2E(a0)
                bpl.s   FBZBossSK_OrbitRequestReturn
                move.w  #$1F,$2E(a0)
                bclr    #0,$38(a0)
                subq.b  #1,$39(a0)
                bmi.s   FBZBossSK_BeginOrbitAndSignalHinges
                bset    #3,$38(a0)
                bclr    #0,render_flags(a0)
                tst.w   d0
                bne.s   FBZBossSK_OrbitRequestReturn
                bset    #0,render_flags(a0)

FBZBossSK_OrbitRequestReturn:
                rts
; ---------------------------------------------------------------------------

FBZBossSK_BeginOrbitAndSignalHinges:
                move.b  #8,routine(a0)
                bset    #2,$38(a0)
                move.l  #FBZBossSK_EndOrbitAndResetPulses,$34(a0)
                moveq   #2,d0
                move.w  #$1FF,d1
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   FBZBossSK_StoreCharacterOrbitSpeed
                moveq   #2,d0
                move.w  #$FF,d1

FBZBossSK_StoreCharacterOrbitSpeed:
                move.b  d0,$40(a0)
                move.w  d1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_KnucklesRequestNextOrbit:
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   FBZBossSK_AdvanceOrbitAndDepth
                bset    #1,$38(a0)

FBZBossSK_AdvanceOrbitAndDepth:
                bsr.w   FBZBoss_TryHalfTurnSound
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                lea     (FBZEndBoss_CircleLookup1).l,a2
                jsr     (MoveSprite_AngleYLookup).l
                bsr.w   SetFBZEndBossBodyDepthFromPhase
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZBossSK_EndOrbitAndResetPulses:
                bclr    #2,$38(a0)
                bra.w   FBZBossSK_BeginSupportPulseCycle
; ---------------------------------------------------------------------------

; Continue drawing the orbit until the phase is exactly zero
FBZBossSK_DefeatAlignOrbitToZero:
                tst.b   $3C(a0)
                beq.s   FBZBossSK_BeginVisibleDefeatDelay
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                lea     (FBZEndBoss_CircleLookup1).l,a2
                jsr     (MoveSprite_AngleYLookup).l
                bsr.w   SetFBZEndBossBodyDepthFromPhase
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZBossSK_BeginVisibleDefeatDelay:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.w  #$200,priority(a0)
                move.w  #$3F,$2E(a0)
                move.l  #FBZBossSK_SignalReleaseAndBreakUp,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_SignalReleaseAndBreakUp:
                move.l  #Obj_Wait,(a0)
                bset    #4,$38(a0)
                move.l  #FBZBossSK_BeginPostBreakupWait,$34(a0)
                lea     FBZBossSK_BodyFragmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

FBZBossSK_BeginPostBreakupWait:
                move.l  #Obj_Wait,(a0)
                bclr    #7,render_flags(a0)
                move.w  #$7F,$2E(a0)
                move.l  #FBZBossSK_BeginCapsuleAndCameraRelease,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_BeginCapsuleAndCameraRelease:
                move.l  #FBZBossSK_LockExitCameraAndRestore,(a0)
                st      (ActCompletionHandshake).w
                clr.b   (Boss_flag).w
                jsr     (AllocateObject).l
                bne.s   FBZBossSK_SetFirstExitCameraTarget
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$307C,x_pos(a1)
                move.w  #$660,y_pos(a1)

FBZBossSK_SetFirstExitCameraTarget:
                move.w  #$2FDC,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

FBZBossSK_LockExitCameraAndRestore:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (ActCompletionHandshake).w
                bne.w   FBZBossSK_SharedGateReturn
                move.l  #FBZBossSK_ForceRightOrCheckExitY,(a0)
                jsr     (Restore_PlayerControl).l
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                clr.w   $2E(a0)
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                jsr     (Restore_LevelMusic).l
                jsr     (AllocateObject).l
                bne.s   FBZBossSK_SetDoorHallBoundsAndArt
                move.l  #SKInput_LockP2IfActive,(a1)

FBZBossSK_SetDoorHallBoundsAndArt:
                move.w  #$1000,(Camera_target_max_Y_pos).w
                move.w  #$3738,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jsr     (CreateChild6_Simple).l
                lea     PLCKosM_FBZEndBoss_Exit(pc),a6
                move.w  (a6)+,d6

FBZBossSK_QueueDoorHallModules:
                movea.l (a6)+,a1
                move.w  (a6)+,d2
                jsr     (Queue_Kos_Module).l
                dbf     d6,FBZBossSK_QueueDoorHallModules
                rts
; ---------------------------------------------------------------------------
PLCKosM_FBZEndBoss_Exit:    plrlistheader
                plreq   ArtTile_FBZExitDoor, ArtKosM_FBZExitDoor
                plreq   ArtTile_FBZExitHall, ArtKosM_FBZExitHall
PLCKosM_FBZEndBoss_Exit_End:
; ---------------------------------------------------------------------------

FBZBossSK_ForceRightOrCheckExitY:
                cmpi.w  #$720,(Camera_Y_pos).w
                bhs.s   FBZBossSK_StartSandopolisAndDelete
                jmp     (SKInput_BuildAutoRightAndJump).l
; ---------------------------------------------------------------------------

FBZBossSK_StartSandopolisAndDelete:
                move.w  #$800,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

FBZBossSK_SupportDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZEndBossSK_Support_StateOffsets(pc,d0.w),d1
                jsr     FBZEndBossSK_Support_StateOffsets(pc,d1.w)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
FBZEndBossSK_Support_StateOffsets:
                dc.w    FBZBossSK_InitSupportAndHinge-FBZEndBossSK_Support_StateOffsets
                dc.w    FBZBossSK_SupportFollowFallingRoot-FBZEndBossSK_Support_StateOffsets
                dc.w    FBZBossSK_SupportWaitForPulse-FBZEndBossSK_Support_StateOffsets
                dc.w    FBZBossSK_SupportTickStartDelay-FBZEndBossSK_Support_StateOffsets
                dc.w    FBZBossSK_SupportMoveAndWait-FBZEndBossSK_Support_StateOffsets
; ---------------------------------------------------------------------------

FBZBossSK_InitSupportAndHinge:
                lea     FBZBossSK_SupportAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                lea     FBZBossSK_SupportHingeChild(pc),a2
                jsr     (CreateChild1_Normal).l
                movea.w parent3(a0),a1
                tst.b   subtype(a0)
                bne.s   FBZBossSK_SupportBindRoot
                move.w  a0,$44(a1)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_SupportBindRoot:
                move.w  a0,parent3(a1)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_SupportFollowFallingRoot:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.s   FBZBossSK_SupportBeginPulseWait
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

FBZBossSK_SupportBeginPulseWait:
                move.b  #4,routine(a0)

FBZBossSK_SupportWaitForPulse:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   FBZBossSK_SupportBreakUpAndDelete
                btst    #3,$38(a1)
                bne.s   FBZBossSK_SupportChooseStep
                rts
; ---------------------------------------------------------------------------

FBZBossSK_SupportChooseStep:
                move.b  #6,routine(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                btst    #0,render_flags(a1)
                beq.s   FBZBossSK_SupportLoadSpeedAndDelay
                addq.w  #8,d0

FBZBossSK_SupportLoadSpeedAndDelay:
                lea     FBZBossSK_SupportSpeedDelayRecords(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,$2E(a0)
                move.l  #FBZBossSK_SupportBeginMovement,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_SupportBreakUpAndDelete:
                lea     FBZBossSK_SupportFragmentChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------
FBZBossSK_SupportSpeedDelayRecords:
                dc.w    $100,     7
                dc.w    $100,     0
                dc.w    -$100,     0
                dc.w    -$100,     7
; ---------------------------------------------------------------------------

FBZBossSK_SupportTickStartDelay:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZBossSK_SupportBeginMovement:
                move.b  #8,routine(a0)
                move.w  #7,$2E(a0)
                move.l  #FBZBossSK_SupportClearPulseAndRearm,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_SupportMoveAndWait:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZBossSK_SupportClearPulseAndRearm:
                move.b  #4,routine(a0)
                movea.w parent3(a0),a1
                bclr    #3,$38(a1)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_InitHingeAndChooseSide:
                lea     FBZBossSK_ConnectorAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #FBZBossSK_HingeApplyOrbitHeight,(a0)
                movea.w parent3(a0),a1
                tst.b   subtype(a1)
                beq.s   FBZBossSK_HingeBindRootAndSpawnLinks
                bset    #0,render_flags(a0)

FBZBossSK_HingeBindRootAndSpawnLinks:
                move.w  parent3(a1),$44(a0)
                lea     FBZBossSK_HingeConnectorChildren(pc),a2
                jsr     (CreateChild3_NormalRepeated).l

FBZBossSK_HingeApplyOrbitHeight:
                movea.w $44(a0),a1
                move.b  $3C(a1),$3C(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                lea     (FBZEndBoss_CircleLookup2).l,a2
                jsr     (MoveSprite_AngleYLookup).l
                bsr.w   SetFBZEndBossHingeDepthFromPhase
                moveq   #0,d0
                jmp     (Child_Draw_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------

FBZBossSK_ConnectorDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZEndBossSK_Connector_TwoStateOffsets(pc,d0.w),d1
                jsr     FBZEndBossSK_Connector_TwoStateOffsets(pc,d1.w)
                moveq   #8,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
FBZEndBossSK_Connector_TwoStateOffsets:
                dc.w    FBZBossSK_InitConnectorSideOffset-FBZEndBossSK_Connector_TwoStateOffsets
                dc.w    FBZBossSK_ConnectorSyncAndInterpolate-FBZEndBossSK_Connector_TwoStateOffsets
; ---------------------------------------------------------------------------

FBZBossSK_InitConnectorSideOffset:
                lea     FBZBossSK_ConnectorAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                movea.w parent3(a0),a1
                moveq   #-$1C,d0
                btst    #0,render_flags(a1)
                beq.s   FBZBossSK_ConnectorBindEndpoints
                bset    #0,render_flags(a0)
                neg.w   d0

FBZBossSK_ConnectorBindEndpoints:
                movea.w parent3(a1),a1
                move.w  parent3(a1),$44(a0)
                move.b  d0,child_dx(a0)
                move.b  #2,child_dy(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_ConnectorSyncAndInterpolate:
                jsr     (Child_GetPriority).l
                bra.w   FBZBossSK_ConnectorInterpolateXY
; ---------------------------------------------------------------------------

FBZBossSK_InitFlameRequester:
                lea     FBZBossSK_FlameRequesterAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l

FBZBossSK_FlameRequesterRearm:
                move.l  #FBZBossSK_FlameRequesterCheckRequest,(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_FlameRequesterCheckRequest:
                jsr     (Child_GetPriority).l
                btst    #7,status(a1)
                bne.s   FBZBossSK_FlameRequesterFollowShip
                btst    #1,$38(a1)
                beq.s   FBZBossSK_FlameRequesterFollowAndDraw
                move.l  #FBZBossSK_FlameRequesterWaitAndSync,(a0)
                move.w  #$5F,$2E(a0)
                move.l  #FBZBossSK_FlameRequesterRearm,$34(a0)
                lea     FBZBossSK_FlamePartChildren(pc),a2
                jsr     (CreateChild6_Simple).l

FBZBossSK_FlameRequesterFollowAndDraw:
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZBossSK_FlameRequesterFollowShip:
                move.l  #FBZBossSK_FlameRequesterWaitRelease,(a0)
                move.w  $3E(a1),$46(a0)
                subq.b  #4,child_dy(a0)
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZBossSK_FlameRequesterWaitAndSync:
                jsr     (Child_GetPriority).l
                jmp     (Refresh_ChildPosWait).l
; ---------------------------------------------------------------------------

FBZBossSK_FlameRequesterWaitRelease:
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

FBZBossSK_InitFlamePartAndDelay:
                bsr.w   InitializeFBZEndBossFlameColumnPart
                move.l  #Obj_Wait,(a0)
                move.l  #FBZBossSK_FlamePartBeginAnimation,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_FlamePartBeginAnimation:
                move.l  #FBZBossSK_FlamePartFollowAnimateTouch,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_FlamePartFollowAnimateTouch:
                moveq   #signextendB(sfx_FlamethrowerQuiet),d0
                jsr     (Play_SFX_Continuous).l
                jsr     (Child_GetPriority).l
                jsr     (Refresh_ChildPosition).l
                jsr     (Animate_RawMultiDelay).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

FBZBossSK_InitBodyFragment:
                lea     FBZBossSK_FragmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                jsr     (Refresh_ChildPositionAdjusted).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #8,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$34,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

FBZBossSK_InitSupportFragment:
                lea     FBZBossSK_FragmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                jsr     (Refresh_ChildPositionAdjusted).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$C,d0
                move.b  d0,mapping_frame(a0)
                moveq   #8,d0
                jmp     (Set_IndexedVelocity).l
