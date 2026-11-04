; Owner: objects/bosses/fbz/miniboss/sk
; Responsibility: Flying Battery miniboss battle state, attacks and coordinated child actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZMiniboss:
                lea     FBZMinibossSK_Root_CameraTriggerWords(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZMiniboss_Index(pc,d0.w),d1
                jsr     FBZMiniboss_Index(pc,d1.w)
                bsr.w   FBZMini_SolidBodyOrCapsule
                bsr.w   ProcessFBZMinibossArmSelfHitAndDefeat
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
FBZMiniboss_Index:
                dc.w    FBZMiniSK_InitMinibossAndChildren-FBZMiniboss_Index
                dc.w    FBZMiniSK_WaitForArenaCamera-FBZMiniboss_Index
                dc.w    FBZMiniSK_WaitForTopButton-FBZMiniboss_Index
                dc.w    FBZMiniSK_TickMusicDelay-FBZMiniboss_Index
                dc.w    FBZMiniSK_ConsumeWarningAndSpawn-FBZMiniboss_Index
FBZMinibossSK_Root_CameraTriggerWords:
                dc.w    $240,  $600, $2D20, $2F20
                dc.w    $540,  $540, $2E20, $2E20
; ---------------------------------------------------------------------------

FBZMiniSK_InitMinibossAndChildren:
                lea     ObjDat_FBZMiniboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #6,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  (Camera_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  #$540,(Camera_target_max_Y_pos).w
                move.w  #$2E20,$3A(a0)
                move.l  #FBZMiniSK_LockArenaHorizontalBounds,$34(a0)
                lea     (PLC_BossExplosion).l,a1
                jsr     (Load_PLC_Raw).l
                lea     (ArtKosM_FBZMiniboss).l,a1
                move.w  #tiles_to_bytes(ArtTile_FBZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     Pal_FBZMiniboss(pc),a1
                jsr     (PalLoad_Line1).l
                lea     FBZMiniSK_MainBodyChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

FBZMiniSK_WaitForArenaCamera:
                jmp     (SKEndCamera_TrackMinXAndCheckY).l
; ---------------------------------------------------------------------------

FBZMiniSK_LockArenaHorizontalBounds:
                move.b  #4,routine(a0)
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  $3A(a0),d0
                move.w  d0,(Camera_min_X_pos).w
                addi.w  #$80,d0
                move.w  d0,(Camera_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_WaitForTopButton:
                btst    #0,$38(a0)
                bne.s   FBZMiniSK_FadeMusicAndBeginDelay
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_FadeMusicAndBeginDelay:
                move.b  #6,routine(a0)
                move.l  #FBZMiniSK_StartMusicAndAttackPoll,$34(a0)
                move.w  #2*60,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l

FBZMiniSK_SharedGateReturn:
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_TickMusicDelay:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZMiniSK_StartMusicAndAttackPoll:
                move.b  #8,routine(a0)
                moveq   #signextendB(mus_Miniboss),d0
                jsr     (Play_Music).l
                move.b  #mus_Miniboss,(Current_music+1).w
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ConsumeWarningAndSpawn:
                bclr    #7,$38(a0)
                beq.s   FBZMiniSK_SharedGateReturn
                lea     FBZMiniSK_PaletteWarningChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

FBZMiniSK_DefeatSolidAndTickWait:
                subq.w  #1,$2E(a0)
                bmi.s   FBZMiniSK_DefeatTryMusicFade
                bsr.w   FBZMini_SolidBodyOrCapsule
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZMiniSK_DefeatTryMusicFade:
                bclr    #7,render_flags(a0)
                move.w  #(2*60)-1,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   FBZMiniSK_BeginDefeatRelease
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

FBZMiniSK_BeginDefeatRelease:
                jsr     (Obj_EndSignControl).l
                lea     FBZMiniSK_ReleasedBodyChild(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     (FBZEggPrisonSK_FiveNormalAnimalRecords).l,a2
                jsr     (CreateChild1_Normal).l
                lea     (SKCapsule_FiveReleasedFragmentChildList).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

FBZMiniSK_ButtonDispatchSolidAndCull:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZMiniSK_ButtonStateOffsets(pc,d0.w),d1
                jsr     FBZMiniSK_ButtonStateOffsets(pc,d1.w)
                bsr.w   SolidifyFBZMinibossTopButton
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
FBZMiniSK_ButtonStateOffsets:
                dc.w    FBZMiniSK_InitButtonAndRestHeight-FBZMiniSK_ButtonStateOffsets
                dc.w    FBZMiniSK_ButtonUpdateOrDefeat-FBZMiniSK_ButtonStateOffsets
; ---------------------------------------------------------------------------

FBZMiniSK_InitButtonAndRestHeight:
                lea     (ObjDat_FBZSpringPlunger).l,a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #$280,priority(a0)
                move.w  y_pos(a0),$3E(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ButtonUpdateOrDefeat:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   FBZMiniSK_ButtonBeginDefeatedPose
                move.w  $3E(a0),d0
                btst    #3,status(a0)
                bne.s   FBZMiniSK_ButtonSignalPressAndLower
                btst    #2,$38(a1)
                bne.s   FBZMiniSK_ButtonSignalPressAndLower
                bclr    #0,$38(a1)
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ButtonSignalPressAndLower:
                bset    #0,$38(a1)
                addq.w  #4,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ButtonBeginDefeatedPose:
                move.l  #FBZMiniSK_DefeatedButtonSolidAndCull,(a0)
                addq.w  #8,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_DefeatedButtonSolidAndCull:
                bsr.w   SolidifyFBZMinibossTopButton
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

FBZMiniSK_EyeDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZMiniSK_EyeStateOffsets(pc,d0.w),d1
                jsr     FBZMiniSK_EyeStateOffsets(pc,d1.w)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
FBZMiniSK_EyeStateOffsets:
                dc.w    FBZMiniSK_InitEye-FBZMiniSK_EyeStateOffsets
                dc.w    FBZMinibossSK_Eye_WaitForRootButtonPress-FBZMiniSK_EyeStateOffsets
                dc.w    FBZMiniSK_EyeTickActivationDelay-FBZMiniSK_EyeStateOffsets
                dc.w    FBZMiniSK_EyeTrackTargetDirection-FBZMiniSK_EyeStateOffsets
; ---------------------------------------------------------------------------

FBZMiniSK_InitEye:
                lea     FBZMiniSK_EyeAttributes(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

FBZMinibossSK_Eye_WaitForRootButtonPress:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   FBZMiniSK_EyeBeginActivationDelay
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_EyeBeginActivationDelay:
                move.b  #4,routine(a0)
                move.w  #$40,$2E(a0)
                move.l  #FBZMiniSK_EyeBeginTracking,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_EyeTickActivationDelay:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZMiniSK_EyeBeginTracking:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_EyeTrackTargetDirection:
                btst    #2,(V_int_run_count+3).w
                jsr     (Find_SonicTails8Way).l
                addi.w  #9,d4
                move.b  d4,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_InitPaletteWarning:
                lea     FBZMiniSK_WarningAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #FBZMiniSK_WarningTickPaletteAndDraw,(a0)
                move.w  #$EEE,(Normal_palette_line_2+$1E).w
                lea     (FBZMiniSK_WarningPaletteScript).l,a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #Go_Delete_Sprite,(Palette_rotation_custom).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZMiniSK_WarningTickPaletteAndDraw:
                jsr     (Run_PalRotationScript).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZMiniSK_TrimDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZMiniSK_TrimStateOffsets(pc,d0.w),d1
                jsr     FBZMiniSK_TrimStateOffsets(pc,d1.w)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
FBZMiniSK_TrimStateOffsets:
                dc.w    FBZMiniSK_InitTrimBySubtype-FBZMiniSK_TrimStateOffsets
                dc.w    FBZMiniSK_TrimWaitForButton-FBZMiniSK_TrimStateOffsets
                dc.w    FBZMiniSK_TrimMoveAndTickWait-FBZMiniSK_TrimStateOffsets
                dc.w    FBZMiniSK_TrimFinalIdle-FBZMiniSK_TrimStateOffsets
; ---------------------------------------------------------------------------

FBZMiniSK_InitTrimBySubtype:
                lea     FBZMiniSK_TrimAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                addq.b  #1,d0
                move.b  d0,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_TrimWaitForButton:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   FBZMiniSK_TrimBeginSeparation
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_TrimBeginSeparation:
                move.b  #4,routine(a0)
                move.l  #FBZMinibossSK_Trim_SelectFinalIdleState,$34(a0)
                bra.w   FBZMiniSK_TrimLoadDelayAndVelocity
; ---------------------------------------------------------------------------

FBZMiniSK_TrimMoveAndTickWait:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZMinibossSK_Trim_SelectFinalIdleState:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_TrimFinalIdle:
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZMiniSK_ArmStateOffsets(pc,d0.w),d1
                jsr     FBZMiniSK_ArmStateOffsets(pc,d1.w)
                bsr.w   EnterFBZMinibossArmParentDefeatWait
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
FBZMiniSK_ArmStateOffsets:
                dc.w    FBZMiniSK_InitArmAndDeployment-FBZMiniSK_ArmStateOffsets
                dc.w    FBZMiniSK_ArmWaitForButton-FBZMiniSK_ArmStateOffsets
                dc.w    FBZMiniSK_ArmTickPhaseWait-FBZMiniSK_ArmStateOffsets
                dc.w    FBZMiniSK_ArmMoveAndTickDeployment-FBZMiniSK_ArmStateOffsets
                dc.w    FBZMiniSK_ArmTickPhaseWait-FBZMiniSK_ArmStateOffsets
                dc.w    FBZMiniSK_ArmOscillateAndWait-FBZMiniSK_ArmStateOffsets
                dc.w    FBZMiniSK_ArmWaitForSideExtension-FBZMiniSK_ArmStateOffsets
                dc.w    FBZMiniSK_ArmTickPhaseWait-FBZMiniSK_ArmStateOffsets
                dc.w    FBZMiniSK_ArmRestartAfterReturn-FBZMiniSK_ArmStateOffsets
                dc.w    FBZMiniSK_ArmCheckPunchReady-FBZMiniSK_ArmStateOffsets
                dc.w    FBZMiniSK_ArmTickPhaseWait-FBZMiniSK_ArmStateOffsets
; ---------------------------------------------------------------------------

FBZMiniSK_InitArmAndDeployment:
                lea     FBZMiniSK_ArmRootAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.w  #-$140,d0
                subi.b  #$A,subtype(a0)
                beq.s   FBZMiniSK_ArmStoreDeploySpeed
                neg.w   d0
                bset    #0,render_flags(a0)
                move.w  #$3F,$2E(a0)

FBZMiniSK_ArmStoreDeploySpeed:
                move.w  d0,x_vel(a0)
                move.w  #-$D0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmWaitForButton:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   FBZMiniSK_ArmBeginDeployDelay
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmBeginDeployDelay:
                move.b  #4,routine(a0)
                move.l  #FBZMiniSK_ArmSpawnLinksAndMove,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmTickPhaseWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZMiniSK_ArmSpawnLinksAndMove:
                move.b  #6,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZMiniSK_ArmSignalLinkDeployment,$34(a0)
                lea     FBZMiniSK_LinkedArmChildren(pc),a2
                jmp     (CreateChild4_LinkListRepeated).l
; ---------------------------------------------------------------------------

FBZMiniSK_ArmMoveAndTickDeployment:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZMiniSK_ArmSignalLinkDeployment:
                move.b  #8,routine(a0)
                bset    #3,$38(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZMiniSK_ArmBeginRestOscillation,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmBeginRestOscillation:
                move.b  #$A,routine(a0)
                bset    #2,$38(a0)
                bclr    #3,$38(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                bclr    #1,$38(a0)
                bclr    #6,$38(a1)
                bclr    #6,$38(a0)
                move.w  #2*60,$2E(a0)
                move.l  #FBZMiniSK_ArmChooseSelfHitOrPunch,$34(a0)
                move.b  #-$60,$3C(a0)
                move.b  #2,$40(a0)
                btst    #0,render_flags(a0)
                beq.s   FBZMiniSK_ArmOscillationInitReturn
                move.b  #$60,$3C(a0)
                move.b  #-2,$40(a0)

FBZMiniSK_ArmOscillationInitReturn:
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmOscillateAndWait:
                bsr.w   OscillateFBZMinibossArmAngle
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZMiniSK_ArmChooseSelfHitOrPunch:
                move.w  #$F0,$2E(a0)
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                beq.s   FBZMiniSK_ArmCheckPunchPlayerSide
                btst    #1,$38(a1)
                bne.w   FBZMiniSK_SharedGateReturn
                move.b  #$C,routine(a0)
                bclr    #2,$38(a0)
                bset    #1,$38(a1)
                bset    #1,$38(a0)
                bset    #7,$38(a1)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmCheckPunchPlayerSide:
                btst    #6,$38(a1)
                bne.w   FBZMiniSK_SharedGateReturn
                lea     (Player_1).w,a2
                tst.b   $40(a2)
                bne.w   FBZMiniSK_SharedGateReturn
                move.w  x_pos(a2),d0
                cmp.w   x_pos(a1),d0
                bhs.s   FBZMiniSK_ArmCheckRightSidePunch
                btst    #0,render_flags(a0)
                beq.s   FBZMiniSK_ArmRequestPunchAndWarn
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmCheckRightSidePunch:
                btst    #0,render_flags(a0)
                beq.w   FBZMiniSK_SharedGateReturn

FBZMiniSK_ArmRequestPunchAndWarn:
                move.b  #$12,routine(a0)
                bclr    #2,$38(a0)
                bset    #6,$38(a1)
                bset    #6,$38(a0)
                bset    #7,$38(a1)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmWaitForSideExtension:
                btst    #3,$38(a0)
                bne.s   FBZMiniSK_ArmBeginFoldDelay
                bra.w   ExtendFBZMinibossArmToSideAngle
; ---------------------------------------------------------------------------

FBZMiniSK_ArmBeginFoldDelay:
                move.b  #$E,routine(a0)
                move.b  #2,$40(a0)
                move.w  #$60,$2E(a0)
                move.l  #FBZMiniSK_ArmClearFoldAndWaitReturn,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmClearFoldAndWaitReturn:
                move.b  #$10,routine(a0)
                bclr    #3,$38(a0)
                movea.w parent3(a0),a1
                bclr    #2,$38(a1)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmRestartAfterReturn:
                btst    #2,$38(a0)
                bne.w   FBZMiniSK_ArmBeginRestOscillation
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmCheckPunchReady:
                bclr    #3,$38(a0)
                bne.s   FBZMiniSK_ArmBeginPunchDelay
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmBeginPunchDelay:
                move.b  #$14,routine(a0)
                move.w  #$10,$2E(a0)
                move.l  #FBZMiniSK_ArmSignalPunchTravel,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmSignalPunchTravel:
                move.b  #$10,routine(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_DefeatedArmWaitAndDraw:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   FBZMiniSK_DefeatedArmBreakAway
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZMiniSK_DefeatedArmBreakAway:
                move.l  #Obj_FlickerMove,(a0)
                bset    #4,$38(a0)
                move.w  #$3F,$2E(a0)
                moveq   #0,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

FBZMiniSK_LinkDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZMiniSK_LinkStateOffsets(pc,d0.w),d1
                jsr     FBZMiniSK_LinkStateOffsets(pc,d1.w)
                bsr.w   EnterFBZMinibossArmParentDefeatWait
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
FBZMiniSK_LinkStateOffsets:
                dc.w    FBZMiniSK_InitLinkOrHand-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMiniSK_LinkFollowUntilDeployment-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMiniSK_LinkMoveAndTickDeployment-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMiniSK_LinkWaitForOscillation-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMiniSK_LinkTickOscillationStagger-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMiniSK_LinkOscillateAndCheckAttack-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMiniSK_LinkExtendAndSignalSide-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMiniSK_LinkWaitForPreviousSide-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMinibossSK_Link_WaitBeforeBodyFold-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMiniSK_LinkFoldForSelfHit-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMiniSK_LinkWaitForPreviousFold-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMiniSK_LinkReturnToRest-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMiniSK_LinkRaiseAndSignalVertical-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMiniSK_LinkWaitForPreviousPunch-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMiniSK_LinkInterpolatePunchAndWait-FBZMiniSK_LinkStateOffsets
                dc.w    FBZMiniSK_LinkTickWaitAndReverse-FBZMiniSK_LinkStateOffsets
; ---------------------------------------------------------------------------

FBZMiniSK_InitLinkOrHand:
                addq.b  #2,subtype(a0)
                cmpi.b  #$A,subtype(a0)
                beq.s   FBZMiniSK_InitHandAndSetEndpoints
                lea     FBZMiniSK_LinkAttributes(pc),a1
                move.w  #4,$3E(a0)
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

FBZMiniSK_InitHandAndSetEndpoints:
                lea     FBZMiniSK_HandAttributes(pc),a1
                move.w  #3,$3E(a0)
                jsr     (SetUp_ObjAttributes3).l
                move.b  #$86,collision_flags(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                movea.w parent3(a1),a1
                movea.w parent3(a1),a1
                movea.w parent3(a1),a1
                move.w  a1,$44(a0)
                move.w  a1,$30(a1)
                move.w  a0,$32(a1)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_LinkFollowUntilDeployment:
                jsr     (Refresh_ChildPosition).l
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   FBZMiniSK_LinkBeginDiagonalDeploy
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_LinkBeginDiagonalDeploy:
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                bsr.w   SetFBZMinibossLinkDeploymentVelocity
                move.w  #$F,$2E(a0)
                move.l  #FBZMiniSK_LinkStopAndSetDepth,$34(a0)
                movea.w parent3(a0),a1
                move.w  $30(a1),$30(a0)
                move.w  $32(a1),$32(a0)
                btst    #0,render_flags(a1)
                beq.s   FBZMiniSK_LinkDeployFlipReturn
                bset    #0,render_flags(a0)
                neg.w   x_vel(a0)

FBZMiniSK_LinkDeployFlipReturn:
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_LinkMoveAndTickDeployment:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZMiniSK_LinkStopAndSetDepth:
                move.b  #6,routine(a0)
                bclr    #3,$38(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$80,priority(a0)
                cmpi.b  #$A,subtype(a0)
                beq.s   FBZMiniSK_LinkDeployDepthReturn
                move.w  #$180,priority(a0)

FBZMiniSK_LinkDeployDepthReturn:
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_LinkWaitForOscillation:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   FBZMiniSK_LinkCopyOscillationAndDelay
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_LinkCopyOscillationAndDelay:
                move.b  #8,routine(a0)
                bset    #2,$38(a0)
                bclr    #3,$38(a0)
                bclr    #6,$38(a0)
                bclr    #1,$38(a0)
                move.b  $3C(a1),$3C(a0)
                move.b  $40(a1),$40(a0)
                move.b  subtype(a0),d0
                add.b   d0,d0
                move.b  d0,$3B(a0)
                move.b  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_LinkTickOscillationStagger:
                subq.b  #1,$3B(a0)
                bpl.s   FBZMiniSK_LinkPlaceDuringStagger
                move.b  #$A,routine(a0)

FBZMiniSK_LinkPlaceDuringStagger:
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

FBZMiniSK_LinkOscillateAndCheckAttack:
                bsr.w   OscillateFBZMinibossArmAngle
                move.w  $3E(a0),d2
                jsr     (MoveSprite_CircularSimple).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   FBZMiniSK_LinkAcceptSelfHitRequest
                btst    #6,$38(a1)
                bne.s   FBZMiniSK_LinkAcceptPunchRequest
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_LinkAcceptSelfHitRequest:
                move.b  #$C,routine(a0)
                bset    #1,$38(a0)
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

; Only the hand snapshots the player's position for the punch
FBZMiniSK_LinkAcceptPunchRequest:
                move.b  #$18,routine(a0)
                bset    #6,$38(a0)
                bclr    #2,$38(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   FBZMiniSK_LinkPunchSetupReturn
                lea     (Player_1).w,a1
                move.w  x_pos(a1),$30(a0)
                move.w  y_pos(a1),$32(a0)

FBZMiniSK_LinkPunchSetupReturn:
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_LinkExtendAndSignalSide:
                bsr.w   ExtendFBZMinibossArmToSideAngle
                beq.s   FBZMiniSK_LinkPlaceAfterSideExtension
                move.b  #$E,routine(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   FBZMiniSK_LinkPlaceAfterSideExtension
                movea.w $44(a0),a1
                bset    #3,$38(a1)

FBZMiniSK_LinkPlaceAfterSideExtension:
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

FBZMiniSK_LinkWaitForPreviousSide:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   FBZMiniSK_LinkBeginFoldDelay
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

FBZMiniSK_LinkBeginFoldDelay:
                move.b  #$10,routine(a0)
                bset    #3,$38(a0)
                move.w  #$F,$2E(a0)
                move.l  #FBZMinibossSK_Link_SelectBodyFoldState,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMinibossSK_Link_WaitBeforeBodyFold:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZMinibossSK_Link_SelectBodyFoldState:
                move.b  #$12,routine(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_LinkFoldForSelfHit:
                move.b  #$14,d4
                bsr.w   FoldFBZMinibossLinksForBodyStrike
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

FBZMiniSK_LinkWaitForPreviousFold:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   FBZMiniSK_LinkBeginRestReturn
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_LinkBeginRestReturn:
                move.b  #$16,routine(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_LinkReturnToRest:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.w   FBZMiniSK_LinkCopyOscillationAndDelay
                bsr.w   ReturnFBZMinibossArmToRestAngle
                beq.s   FBZMiniSK_LinkPlaceAfterRestReturn
                cmpi.b  #$A,subtype(a0)
                bne.s   FBZMiniSK_LinkPlaceAfterRestReturn
                movea.w $44(a0),a1
                bset    #2,$38(a1)

FBZMiniSK_LinkPlaceAfterRestReturn:
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

FBZMiniSK_LinkRaiseAndSignalVertical:
                bsr.w   RaiseFBZMinibossArmToVerticalAngle
                beq.s   FBZMiniSK_LinkPlaceAfterVerticalRaise
                move.b  #$1A,routine(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   FBZMiniSK_LinkPlaceAfterVerticalRaise
                movea.w $44(a0),a1
                bset    #3,$38(a1)

FBZMiniSK_LinkPlaceAfterVerticalRaise:
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

FBZMiniSK_LinkWaitForPreviousPunch:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   FBZMiniSK_LinkBeginPunchTravel
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

FBZMiniSK_LinkBeginPunchTravel:
                move.b  #$1C,routine(a0)
                bset    #3,$38(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZMiniSK_LinkBeginPunchTurnaround,$34(a0)
                cmpi.b  #$A,subtype(a0)
                bne.w   FBZMiniSK_SharedGateReturn
                bra.w   FBZMiniSK_HandAimAtSavedTarget
; ---------------------------------------------------------------------------

FBZMiniSK_LinkInterpolatePunchAndWait:
                cmpi.b  #$A,subtype(a0)
                beq.s   FBZMiniSK_HandMoveAndTickPunch
                bsr.w   FBZMiniPunch_InterpolateLink
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZMiniSK_HandMoveAndTickPunch:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZMiniSK_LinkBeginPunchTurnaround:
                move.b  #$1E,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZMiniSK_LinkReversePunchVelocity,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_LinkBeginRestAfterPunch:
                move.b  #$16,routine(a0)
                rts
; ---------------------------------------------------------------------------

; Fall through to the reversal even if the wait has yet to expire
FBZMiniSK_LinkTickWaitAndReverse:
                jsr     (Obj_Wait).l

FBZMiniSK_LinkReversePunchVelocity:
                move.b  #$1C,routine(a0)
                neg.w   x_vel(a0)
                neg.w   y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZMiniSK_LinkBeginRestAfterPunch,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_InitReleasedBody:
                lea     (ObjDat_FBZEggPrison).l,a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #FBZMiniSK_ReleasedBodySolidAndCull,(a0)
                move.b  #1,mapping_frame(a0)

FBZMiniSK_ReleasedBodySolidAndCull:
                bsr.w   FBZMini_SolidBodyOrCapsule
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   FBZMiniSK_DeleteReleasedBody
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZMiniSK_DeleteReleasedBody:
                jmp     (Delete_Current_Sprite).l
