; Owner: objects/bosses/fbz/miniboss/s3
; Responsibility: Flying Battery miniboss battle state, attacks and coordinated child actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZMiniboss:
                lea     FBZMinibossS3_Root_CameraTriggerWords(pc),a1
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
                dc.w    FBZMiniS3_InitMinibossAndChildren-FBZMiniboss_Index
                dc.w    FBZMiniS3_WaitForArenaCamera-FBZMiniboss_Index
                dc.w    FBZMiniS3_WaitForTopButton-FBZMiniboss_Index
                dc.w    FBZMiniS3_TickMusicDelay-FBZMiniboss_Index
                dc.w    FBZMiniS3_ConsumeWarningAndSpawn-FBZMiniboss_Index
FBZMinibossS3_Root_CameraTriggerWords:
                dc.w    $440,  $600, $2D00, $2F00
; ---------------------------------------------------------------------------

FBZMiniS3_InitMinibossAndChildren:
                lea     ObjDat_FBZMiniboss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  (Camera_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  #$540,(Camera_target_max_Y_pos).w
                move.w  #$2E20,$3A(a0)
                move.l  #FBZMiniS3_LockArenaHorizontalBounds,$34(a0)
                moveq   #PLCID_5E,d0
                jsr     (Load_PLC).l
                lea     Pal_FBZMiniboss(pc),a1
                jsr     (PalLoad_Line1).l
                lea     FBZMiniS3_MainBodyChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_WaitForArenaCamera:
                jmp     (S3EndCamera_TrackMinXAndCheckY).l
; ---------------------------------------------------------------------------

FBZMiniS3_LockArenaHorizontalBounds:
                move.b  #4,routine(a0)
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  d0,(Camera_min_X_pos).w
                addi.w  #$40,d0
                move.w  d0,(Camera_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_WaitForTopButton:
                btst    #0,$38(a0)
                bne.s   FBZMiniS3_FadeMusicAndBeginDelay
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_FadeMusicAndBeginDelay:
                move.b  #6,routine(a0)
                move.l  #FBZMiniS3_StartMusicAndAttackPoll,$34(a0)
                move.w  #2*60,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l

FBZMiniS3_SharedGateReturn:
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_TickMusicDelay:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_StartMusicAndAttackPoll:
                move.b  #8,routine(a0)
                moveq   #signextendB(mus_Miniboss),d0
                jsr     (Play_Music).l
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ConsumeWarningAndSpawn:
                bclr    #7,$38(a0)
                beq.s   FBZMiniS3_SharedGateReturn
                lea     FBZMiniS3_PaletteWarningChild(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_BeginDefeatRelease:
                jsr     (Obj_EndSignControl).l
                lea     FBZMiniS3_ReleasedBodyChild(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     FBZMiniS3_FreedAnimalChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     (S3Capsule_FiveReleasedFragmentChildList).l,a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_ButtonDispatchSolidAndCull:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZMiniS3_ButtonStateOffsets(pc,d0.w),d1
                jsr     FBZMiniS3_ButtonStateOffsets(pc,d1.w)
                bsr.w   SolidifyFBZMinibossTopButton
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
FBZMiniS3_ButtonStateOffsets:
                dc.w    FBZMiniS3_InitButtonAndRestHeight-FBZMiniS3_ButtonStateOffsets
                dc.w    FBZMiniS3_ButtonUpdateOrDefeat-FBZMiniS3_ButtonStateOffsets
; ---------------------------------------------------------------------------

FBZMiniS3_InitButtonAndRestHeight:
                lea     FBZMiniS3_TopButtonAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.w  y_pos(a0),$3E(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ButtonUpdateOrDefeat:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   FBZMiniS3_ButtonBeginDefeatedPose
                move.w  $3E(a0),d0
                btst    #3,status(a0)
                bne.s   FBZMiniS3_ButtonSignalPressAndLower
                btst    #2,$38(a1)
                bne.s   FBZMiniS3_ButtonSignalPressAndLower
                bclr    #0,$38(a1)
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ButtonSignalPressAndLower:
                bset    #0,$38(a1)
                addq.w  #4,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ButtonBeginDefeatedPose:
                move.l  #FBZMiniS3_DefeatedButtonSolidAndCull,(a0)
                move.l  #Map_EggCapsule,mappings(a0)
                move.w  #make_art_tile(ArtTile_EggCapsule-$46,0,1),art_tile(a0)
                move.b  #5,mapping_frame(a0)
                addq.w  #8,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_DefeatedButtonSolidAndCull:
                bsr.w   SolidifyFBZMinibossTopButton
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

FBZMiniS3_EyeDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZMiniS3_EyeStateOffsets(pc,d0.w),d1
                jsr     FBZMiniS3_EyeStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------
FBZMiniS3_EyeStateOffsets:
                dc.w    FBZMiniS3_InitEye-FBZMiniS3_EyeStateOffsets
                dc.w    FBZMinibossS3_Eye_WaitForRootButtonPress-FBZMiniS3_EyeStateOffsets
                dc.w    FBZMiniS3_EyeTickActivationDelay-FBZMiniS3_EyeStateOffsets
                dc.w    FBZMiniS3_EyeTrackTargetDirection-FBZMiniS3_EyeStateOffsets
; ---------------------------------------------------------------------------

FBZMiniS3_InitEye:
                lea     FBZMiniS3_EyeAttributes(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

FBZMinibossS3_Eye_WaitForRootButtonPress:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   FBZMiniS3_EyeBeginActivationDelay
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_EyeBeginActivationDelay:
                move.b  #4,routine(a0)
                move.w  #$40,$2E(a0)
                move.l  #FBZMiniS3_EyeBeginTracking,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_EyeTickActivationDelay:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_EyeBeginTracking:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_EyeTrackTargetDirection:
                btst    #2,(V_int_run_count+3).w
                jsr     Find_SonicTails8Way(pc)
                addi.w  #9,d4
                move.b  d4,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_InitPaletteWarning:
                lea     FBZMiniS3_WarningAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #FBZMiniS3_WarningTickPaletteAndDraw,(a0)
                move.w  #$EEE,(Normal_palette_line_2+$1E).w
                lea     (FBZMiniS3_WarningPaletteScript).l,a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #Go_Delete_Sprite,(Palette_rotation_custom).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZMiniS3_WarningTickPaletteAndDraw:
                jsr     (Run_PalRotationScript).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZMiniS3_TrimDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZMiniS3_TrimStateOffsets(pc,d0.w),d1
                jsr     FBZMiniS3_TrimStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------
FBZMiniS3_TrimStateOffsets:
                dc.w    FBZMiniS3_InitTrimBySubtype-FBZMiniS3_TrimStateOffsets
                dc.w    FBZMiniS3_TrimWaitForButton-FBZMiniS3_TrimStateOffsets
                dc.w    FBZMiniS3_TrimMoveAndTickWait-FBZMiniS3_TrimStateOffsets
                dc.w    FBZMiniS3_TrimFinalIdle-FBZMiniS3_TrimStateOffsets
; ---------------------------------------------------------------------------

FBZMiniS3_InitTrimBySubtype:
                lea     FBZMiniS3_TrimAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                addq.b  #1,d0
                move.b  d0,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_TrimWaitForButton:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   FBZMiniS3_TrimBeginSeparation
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_TrimBeginSeparation:
                move.b  #4,routine(a0)
                move.l  #FBZMinibossS3_Trim_SelectFinalIdleState,$34(a0)
                bra.w   FBZMiniS3_TrimLoadDelayAndVelocity
; ---------------------------------------------------------------------------

FBZMiniS3_TrimMoveAndTickWait:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZMinibossS3_Trim_SelectFinalIdleState:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_TrimFinalIdle:
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ArmDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZMiniS3_ArmStateOffsets(pc,d0.w),d1
                jsr     FBZMiniS3_ArmStateOffsets(pc,d1.w)
                bsr.w   EnterFBZMinibossArmParentDefeatWait
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
FBZMiniS3_ArmStateOffsets:
                dc.w    FBZMiniS3_InitArmAndDeployment-FBZMiniS3_ArmStateOffsets
                dc.w    FBZMiniS3_ArmWaitForButton-FBZMiniS3_ArmStateOffsets
                dc.w    FBZMiniS3_ArmTickPhaseWait-FBZMiniS3_ArmStateOffsets
                dc.w    FBZMiniS3_ArmMoveAndTickDeployment-FBZMiniS3_ArmStateOffsets
                dc.w    FBZMiniS3_ArmTickPhaseWait-FBZMiniS3_ArmStateOffsets
                dc.w    FBZMiniS3_ArmOscillateAndWait-FBZMiniS3_ArmStateOffsets
                dc.w    FBZMiniS3_ArmWaitForSideExtension-FBZMiniS3_ArmStateOffsets
                dc.w    FBZMiniS3_ArmTickPhaseWait-FBZMiniS3_ArmStateOffsets
                dc.w    FBZMiniS3_ArmRestartAfterReturn-FBZMiniS3_ArmStateOffsets
                dc.w    FBZMiniS3_ArmCheckPunchReady-FBZMiniS3_ArmStateOffsets
                dc.w    FBZMiniS3_ArmTickPhaseWait-FBZMiniS3_ArmStateOffsets
; ---------------------------------------------------------------------------

FBZMiniS3_InitArmAndDeployment:
                lea     FBZMiniS3_ArmRootAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.w  #-$140,d0
                subi.b  #$A,subtype(a0)
                beq.s   FBZMiniS3_ArmStoreDeploySpeed
                neg.w   d0
                bset    #0,render_flags(a0)
                move.w  #$3F,$2E(a0)

FBZMiniS3_ArmStoreDeploySpeed:
                move.w  d0,x_vel(a0)
                move.w  #-$D0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ArmWaitForButton:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   FBZMiniS3_ArmBeginDeployDelay
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ArmBeginDeployDelay:
                move.b  #4,routine(a0)
                move.l  #FBZMiniS3_ArmSpawnLinksAndMove,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ArmTickPhaseWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_ArmSpawnLinksAndMove:
                move.b  #6,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZMiniS3_ArmSignalLinkDeployment,$34(a0)
                lea     FBZMiniS3_LinkedArmChildren(pc),a2
                jmp     (CreateChild4_LinkListRepeated).l
; ---------------------------------------------------------------------------

FBZMiniS3_ArmMoveAndTickDeployment:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_ArmSignalLinkDeployment:
                move.b  #8,routine(a0)
                bset    #3,$38(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZMiniS3_ArmBeginRestOscillation,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ArmBeginRestOscillation:
                move.b  #$A,routine(a0)
                bset    #2,$38(a0)
                bclr    #3,$38(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                bclr    #1,$38(a0)
                bclr    #6,$38(a1)
                bclr    #6,$38(a0)
                move.w  #2*60,$2E(a0)
                move.l  #FBZMiniS3_ArmChooseSelfHitOrPunch,$34(a0)
                move.b  #-$60,$3C(a0)
                move.b  #2,$40(a0)
                btst    #0,render_flags(a0)
                beq.s   FBZMiniS3_ArmOscillationInitReturn
                move.b  #$60,$3C(a0)
                move.b  #-2,$40(a0)

FBZMiniS3_ArmOscillationInitReturn:
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ArmOscillateAndWait:
                bsr.w   OscillateFBZMinibossArmAngle
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_ArmChooseSelfHitOrPunch:
                move.w  #$F0,$2E(a0)
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                beq.s   FBZMiniS3_ArmCheckPunchPlayerSide
                btst    #1,$38(a1)
                bne.w   FBZMiniS3_SharedGateReturn
                move.b  #$C,routine(a0)
                bclr    #2,$38(a0)
                bset    #1,$38(a1)
                bset    #1,$38(a0)
                bset    #7,$38(a1)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ArmCheckPunchPlayerSide:
                btst    #6,$38(a1)
                bne.w   FBZMiniS3_SharedGateReturn
                lea     (Player_1).w,a2
                tst.b   $40(a2)
                bne.w   FBZMiniS3_SharedGateReturn
                move.w  x_pos(a2),d0
                cmp.w   x_pos(a1),d0
                bhs.s   FBZMiniS3_ArmCheckRightSidePunch
                btst    #0,render_flags(a0)
                beq.s   FBZMiniS3_ArmRequestPunchAndWarn
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ArmCheckRightSidePunch:
                btst    #0,render_flags(a0)
                beq.w   FBZMiniS3_SharedGateReturn

FBZMiniS3_ArmRequestPunchAndWarn:
                move.b  #$12,routine(a0)
                bclr    #2,$38(a0)
                bset    #6,$38(a1)
                bset    #6,$38(a0)
                bset    #7,$38(a1)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ArmWaitForSideExtension:
                btst    #3,$38(a0)
                bne.s   FBZMiniS3_ArmBeginFoldDelay
                bra.w   ExtendFBZMinibossArmToSideAngle
; ---------------------------------------------------------------------------

FBZMiniS3_ArmBeginFoldDelay:
                move.b  #$E,routine(a0)
                move.b  #2,$40(a0)
                move.w  #$60,$2E(a0)
                move.l  #FBZMiniS3_ArmClearFoldAndWaitReturn,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ArmClearFoldAndWaitReturn:
                move.b  #$10,routine(a0)
                bclr    #3,$38(a0)
                movea.w parent3(a0),a1
                bclr    #2,$38(a1)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ArmRestartAfterReturn:
                btst    #2,$38(a0)
                bne.w   FBZMiniS3_ArmBeginRestOscillation
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ArmCheckPunchReady:
                bclr    #3,$38(a0)
                bne.s   FBZMiniS3_ArmBeginPunchDelay
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ArmBeginPunchDelay:
                move.b  #$14,routine(a0)
                move.w  #$10,$2E(a0)
                move.l  #FBZMiniS3_ArmSignalPunchTravel,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_ArmSignalPunchTravel:
                move.b  #$10,routine(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_DefeatedArmWaitAndDraw:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   FBZMiniS3_DefeatedArmBreakAway
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZMiniS3_DefeatedArmBreakAway:
                move.l  #Obj_FlickerMove,(a0)
                bset    #4,$38(a0)
                move.w  #$3F,$2E(a0)
                moveq   #0,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_LinkDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZMiniS3_LinkStateOffsets(pc,d0.w),d1
                jsr     FBZMiniS3_LinkStateOffsets(pc,d1.w)
                bsr.w   EnterFBZMinibossArmParentDefeatWait
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
FBZMiniS3_LinkStateOffsets:
                dc.w    FBZMiniS3_InitLinkOrHand-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMiniS3_LinkFollowUntilDeployment-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMiniS3_LinkMoveAndTickDeployment-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMiniS3_LinkWaitForOscillation-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMiniS3_LinkTickOscillationStagger-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMiniS3_LinkOscillateAndCheckAttack-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMiniS3_LinkExtendAndSignalSide-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMiniS3_LinkWaitForPreviousSide-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMinibossS3_Link_WaitBeforeBodyFold-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMiniS3_LinkFoldForSelfHit-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMiniS3_LinkWaitForPreviousFold-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMiniS3_LinkReturnToRest-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMiniS3_LinkRaiseAndSignalVertical-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMiniS3_LinkWaitForPreviousPunch-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMiniS3_LinkInterpolatePunchAndWait-FBZMiniS3_LinkStateOffsets
                dc.w    FBZMiniS3_LinkTickWaitAndReverse-FBZMiniS3_LinkStateOffsets
; ---------------------------------------------------------------------------

FBZMiniS3_InitLinkOrHand:
                addq.b  #2,subtype(a0)
                cmpi.b  #$A,subtype(a0)
                beq.s   FBZMiniS3_InitHandAndSetEndpoints
                lea     FBZMiniS3_LinkAttributes(pc),a1
                move.w  #4,$3E(a0)
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_InitHandAndSetEndpoints:
                lea     FBZMiniS3_HandAttributes(pc),a1
                move.w  #3,$3E(a0)
                jsr     SetUp_ObjAttributes3(pc)
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

FBZMiniS3_LinkFollowUntilDeployment:
                jsr     Refresh_ChildPosition(pc)
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   FBZMiniS3_LinkBeginDiagonalDeploy
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_LinkBeginDiagonalDeploy:
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                bsr.w   SetFBZMinibossLinkDeploymentVelocity
                move.w  #$F,$2E(a0)
                move.l  #FBZMiniS3_LinkStopAndSetDepth,$34(a0)
                movea.w parent3(a0),a1
                move.w  $30(a1),$30(a0)
                move.w  $32(a1),$32(a0)
                btst    #0,render_flags(a1)
                beq.s   FBZMiniS3_LinkDeployFlipReturn
                bset    #0,render_flags(a0)
                neg.w   x_vel(a0)

FBZMiniS3_LinkDeployFlipReturn:
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_LinkMoveAndTickDeployment:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_LinkStopAndSetDepth:
                move.b  #6,routine(a0)
                bclr    #3,$38(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$80,priority(a0)
                cmpi.b  #$A,subtype(a0)
                beq.s   FBZMiniS3_LinkDeployDepthReturn
                move.w  #$180,priority(a0)

FBZMiniS3_LinkDeployDepthReturn:
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_LinkWaitForOscillation:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   FBZMiniS3_LinkCopyOscillationAndDelay
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_LinkCopyOscillationAndDelay:
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

FBZMiniS3_LinkTickOscillationStagger:
                subq.b  #1,$3B(a0)
                bpl.s   FBZMiniS3_LinkPlaceDuringStagger
                move.b  #$A,routine(a0)

FBZMiniS3_LinkPlaceDuringStagger:
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_LinkOscillateAndCheckAttack:
                bsr.w   OscillateFBZMinibossArmAngle
                move.w  $3E(a0),d2
                jsr     MoveSprite_CircularSimple(pc)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   FBZMiniS3_LinkAcceptSelfHitRequest
                btst    #6,$38(a1)
                bne.s   FBZMiniS3_LinkAcceptPunchRequest
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_LinkAcceptSelfHitRequest:
                move.b  #$C,routine(a0)
                bset    #1,$38(a0)
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

; Only the hand snapshots the player's position for the punch
FBZMiniS3_LinkAcceptPunchRequest:
                move.b  #$18,routine(a0)
                bset    #6,$38(a0)
                bclr    #2,$38(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   FBZMiniS3_LinkPunchSetupReturn
                lea     (Player_1).w,a1
                move.w  x_pos(a1),$30(a0)
                move.w  y_pos(a1),$32(a0)

FBZMiniS3_LinkPunchSetupReturn:
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_LinkExtendAndSignalSide:
                bsr.w   ExtendFBZMinibossArmToSideAngle
                beq.s   FBZMiniS3_LinkPlaceAfterSideExtension
                move.b  #$E,routine(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   FBZMiniS3_LinkPlaceAfterSideExtension
                movea.w $44(a0),a1
                bset    #3,$38(a1)

FBZMiniS3_LinkPlaceAfterSideExtension:
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_LinkWaitForPreviousSide:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   FBZMiniS3_LinkBeginFoldDelay
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_LinkBeginFoldDelay:
                move.b  #$10,routine(a0)
                bset    #3,$38(a0)
                move.w  #$F,$2E(a0)
                move.l  #FBZMinibossS3_Link_SelectBodyFoldState,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMinibossS3_Link_WaitBeforeBodyFold:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZMinibossS3_Link_SelectBodyFoldState:
                move.b  #$12,routine(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_LinkFoldForSelfHit:
                move.b  #$14,d4
                bsr.w   FoldFBZMinibossLinksForBodyStrike
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_LinkWaitForPreviousFold:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   FBZMiniS3_LinkBeginRestReturn
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_LinkBeginRestReturn:
                move.b  #$16,routine(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_LinkReturnToRest:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.w   FBZMiniS3_LinkCopyOscillationAndDelay
                bsr.w   ReturnFBZMinibossArmToRestAngle
                beq.s   FBZMiniS3_LinkPlaceAfterRestReturn
                cmpi.b  #$A,subtype(a0)
                bne.s   FBZMiniS3_LinkPlaceAfterRestReturn
                movea.w $44(a0),a1
                bset    #2,$38(a1)

FBZMiniS3_LinkPlaceAfterRestReturn:
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_LinkRaiseAndSignalVertical:
                bsr.w   RaiseFBZMinibossArmToVerticalAngle
                beq.s   FBZMiniS3_LinkPlaceAfterVerticalRaise
                move.b  #$1A,routine(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   FBZMiniS3_LinkPlaceAfterVerticalRaise
                movea.w $44(a0),a1
                bset    #3,$38(a1)

FBZMiniS3_LinkPlaceAfterVerticalRaise:
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_LinkWaitForPreviousPunch:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   FBZMiniS3_LinkBeginPunchTravel
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_LinkBeginPunchTravel:
                move.b  #$1C,routine(a0)
                bset    #3,$38(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZMiniS3_LinkBeginPunchTurnaround,$34(a0)
                cmpi.b  #$A,subtype(a0)
                bne.w   FBZMiniS3_SharedGateReturn
                bra.w   FBZMiniS3_HandAimAtSavedTarget
; ---------------------------------------------------------------------------

FBZMiniS3_LinkInterpolatePunchAndWait:
                cmpi.b  #$A,subtype(a0)
                beq.s   FBZMiniS3_HandMoveAndTickPunch
                bsr.w   FBZMiniPunch_InterpolateLink
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_HandMoveAndTickPunch:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_LinkBeginPunchTurnaround:
                move.b  #$1E,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZMiniS3_LinkReversePunchVelocity,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_LinkBeginRestAfterPunch:
                move.b  #$16,routine(a0)
                rts
; ---------------------------------------------------------------------------

; Fall through to the reversal even if the wait has yet to expire
FBZMiniS3_LinkTickWaitAndReverse:
                jsr     Obj_Wait(pc)

FBZMiniS3_LinkReversePunchVelocity:
                move.b  #$1C,routine(a0)
                neg.w   x_vel(a0)
                neg.w   y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZMiniS3_LinkBeginRestAfterPunch,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniS3_InitReleasedBody:
                move.l  #FBZMiniS3_ReleasedBodySolidAndCull,(a0)
                lea     FBZMiniS3_ReleasedBodyAttributes(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

FBZMiniS3_ReleasedBodySolidAndCull:
                bsr.w   FBZMini_SolidBodyOrCapsule
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   FBZMiniS3_DeleteReleasedBody
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZMiniS3_DeleteReleasedBody:
                jmp     (Delete_Current_Sprite).l
