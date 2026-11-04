; Owner: objects/bosses/fbz/s3
; Responsibility: Flying Battery end-boss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZEndBoss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZEndBoss_Index(pc,d0.w),d1
                jsr     FBZEndBoss_Index(pc,d1.w)
                bsr.w   HandleFBZEndBossFourColorHitOrDefeat
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
FBZEndBoss_Index:
                dc.w    FBZBossS3_InitBodyAndTryShip-FBZEndBoss_Index
                dc.w    FBZBossS3_TrackCameraDuringActivation-FBZEndBoss_Index
                dc.w    FBZBossS3_TrackCameraToTrigger-FBZEndBoss_Index
                dc.w    FBZBossS3_CenterAndCheckOrbitRequest-FBZEndBoss_Index
                dc.w    FBZBossS3_AdvanceOrbitAndDepth-FBZEndBoss_Index
; ---------------------------------------------------------------------------

FBZBossS3_InitBodyAndTryShip:
                lea     ObjDat_FBZEndBoss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #8,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  #$3090,(Camera_max_X_pos).w
                moveq   #PLCID_6F,d0
                jsr     (Load_PLC).l
                lea     Pal_FBZEndBoss(pc),a1
                jsr     (PalLoad_Line1).l
                move.w  #2*60,$2E(a0)
                move.l  #FBZBossS3_SetCameraGateAndStartMusic,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                lea     (Child1_MakeFBZRoboShip).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   FBZBossS3_SpawnSupportsAndRequester
                move.b  #$B,subtype(a1)
                move.w  a1,$3E(a0)

FBZBossS3_SpawnSupportsAndRequester:
                lea     FBZBossS3_SupportAndFlameChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

FBZBossS3_TrackCameraDuringActivation:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZBossS3_SetCameraGateAndStartMusic:
                move.b  #4,routine(a0)
                moveq   #signextendB(mus_EndBoss),d0
                jsr     (Play_Music).l

FBZBossS3_SharedGateReturn:
                rts
; ---------------------------------------------------------------------------

FBZBossS3_TrackCameraToTrigger:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                move.w  #$3090,d0
                cmp.w   (Camera_X_pos).w,d0
                bls.s   FBZBossS3_LockCameraAndBeginPulses
                rts
; ---------------------------------------------------------------------------

FBZBossS3_LockCameraAndBeginPulses:
                move.w  d0,(Camera_min_X_pos).w

FBZBossS3_BeginSupportPulseCycle:
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                move.b  #9,$39(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_CenterAndCheckOrbitRequest:
                bsr.w   CenterFBZEndBossXBetweenSupports
                jsr     Find_SonicTails(pc)
                btst    #1,$38(a0)
                bne.s   FBZBossS3_OrbitRequestReturn
                cmpi.w  #$18,d2
                bhs.s   FBZBossS3_TickPulseAndChooseSide
                btst    #Status_InAir,status(a1)
                bne.s   FBZBossS3_TickPulseAndChooseSide
                bset    #1,$38(a0)

FBZBossS3_TickPulseAndChooseSide:
                subq.w  #1,$2E(a0)
                bpl.s   FBZBossS3_OrbitRequestReturn
                move.w  #$1F,$2E(a0)
                subq.b  #1,$39(a0)
                bmi.s   FBZBossS3_BeginOrbitAndSignalHinges
                bset    #3,$38(a0)
                bclr    #0,render_flags(a0)
                tst.w   d0
                bne.s   FBZBossS3_OrbitRequestReturn
                bset    #0,render_flags(a0)

FBZBossS3_OrbitRequestReturn:
                rts
; ---------------------------------------------------------------------------

FBZBossS3_BeginOrbitAndSignalHinges:
                move.b  #8,routine(a0)
                bset    #2,$38(a0)
                move.b  #2,$40(a0)
                move.w  #$1FF,$2E(a0)
                move.l  #FBZBossS3_EndOrbitAndResetPulses,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_AdvanceOrbitAndDepth:
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                lea     (FBZEndBoss_CircleLookup1).l,a2
                jsr     MoveSprite_AngleYLookup(pc)
                bsr.w   SetFBZEndBossBodyDepthFromPhase
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZBossS3_EndOrbitAndResetPulses:
                bclr    #2,$38(a0)
                bra.w   FBZBossS3_BeginSupportPulseCycle
; ---------------------------------------------------------------------------

; Continue drawing the orbit until the phase is exactly zero
FBZBossS3_DefeatAlignOrbitToZero:
                tst.b   $3C(a0)
                beq.s   FBZBossS3_BeginVisibleDefeatDelay
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                lea     (FBZEndBoss_CircleLookup1).l,a2
                jsr     MoveSprite_AngleYLookup(pc)
                bsr.w   SetFBZEndBossBodyDepthFromPhase
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZBossS3_BeginVisibleDefeatDelay:
                move.l  #Wait_Draw,(a0)
                move.w  #$280,priority(a0)
                move.w  #$3F,$2E(a0)
                move.l  #FBZBossS3_SignalReleaseAndBreakUp,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_SignalReleaseAndBreakUp:
                move.l  #Obj_Wait,(a0)
                bset    #4,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #FBZBossS3_BeginPostBreakupWait,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                lea     FBZBossS3_BodyFragmentChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

FBZBossS3_BeginPostBreakupWait:
                move.l  #Obj_Wait,(a0)
                bclr    #7,render_flags(a0)
                st      (_unkFAA8).w
                move.w  #$7F,$2E(a0)
                move.l  #FBZBossS3_BeginCapsuleAndCameraRelease,$34(a0)
                jmp     (Restore_LevelMusic).l
; ---------------------------------------------------------------------------

FBZBossS3_BeginCapsuleAndCameraRelease:
                move.l  #FBZBossS3_LockExitCameraAndRestore,(a0)
                clr.b   (Boss_flag).w
                move.w  #$3170,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

FBZBossS3_LockExitCameraAndRestore:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (_unkFAA8).w
                bne.w   FBZBossS3_SharedGateReturn
                clr.b   (_unkFAA8).w
                jsr     Restore_PlayerControl(pc)
                lea     (Player_2).w,a1
                jsr     Restore_PlayerControl2(pc)
                move.w  #$6000,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

FBZBossS3_SupportDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZEndBossS3_Support_StateOffsets(pc,d0.w),d1
                jsr     FBZEndBossS3_Support_StateOffsets(pc,d1.w)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
FBZEndBossS3_Support_StateOffsets:
                dc.w    FBZBossS3_InitSupportAndHinge-FBZEndBossS3_Support_StateOffsets
                dc.w    FBZBossS3_SupportWaitForPulse-FBZEndBossS3_Support_StateOffsets
                dc.w    FBZBossS3_SupportTickStartDelay-FBZEndBossS3_Support_StateOffsets
                dc.w    FBZBossS3_SupportMoveAndWait-FBZEndBossS3_Support_StateOffsets
; ---------------------------------------------------------------------------

FBZBossS3_InitSupportAndHinge:
                lea     FBZBossS3_SupportAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                lea     FBZBossS3_SupportHingeChild(pc),a2
                jsr     CreateChild1_Normal(pc)
                movea.w parent3(a0),a1
                tst.b   subtype(a0)
                bne.s   FBZBossS3_SupportBindRoot
                move.w  a0,$44(a1)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_SupportBindRoot:
                move.w  a0,parent3(a1)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_SupportWaitForPulse:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   FBZBossS3_SupportBreakUpAndDelete
                btst    #3,$38(a1)
                bne.s   FBZBossS3_SupportChooseStep
                rts
; ---------------------------------------------------------------------------

FBZBossS3_SupportChooseStep:
                move.b  #4,routine(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                btst    #0,render_flags(a1)
                beq.s   FBZBossS3_SupportLoadSpeedAndDelay
                addq.w  #8,d0

FBZBossS3_SupportLoadSpeedAndDelay:
                lea     FBZBossS3_SupportSpeedDelayRecords(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,$2E(a0)
                move.l  #FBZBossS3_SupportBeginMovement,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_SupportBreakUpAndDelete:
                lea     FBZBossS3_SupportFragmentChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Go_Delete_Sprite_2(pc)
; ---------------------------------------------------------------------------
FBZBossS3_SupportSpeedDelayRecords:
                dc.w    $100,     7
                dc.w    $100,     0
                dc.w    -$100,     0
                dc.w    -$100,     7
; ---------------------------------------------------------------------------

FBZBossS3_SupportTickStartDelay:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZBossS3_SupportBeginMovement:
                move.b  #6,routine(a0)
                move.w  #7,$2E(a0)
                move.l  #FBZBossS3_SupportClearPulseAndRearm,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_SupportMoveAndWait:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZBossS3_SupportClearPulseAndRearm:
                move.b  #2,routine(a0)
                movea.w parent3(a0),a1
                bclr    #3,$38(a1)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_HingeDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZEndBossS3_Hinge_ThreeStateOffsets(pc,d0.w),d1
                jsr     FBZEndBossS3_Hinge_ThreeStateOffsets(pc,d1.w)
                moveq   #0,d0
                jmp     Child_Draw_Sprite2_FlickerMove(pc)
; ---------------------------------------------------------------------------
FBZEndBossS3_Hinge_ThreeStateOffsets:
                dc.w    FBZBossS3_InitHingeAndChooseSide-FBZEndBossS3_Hinge_ThreeStateOffsets
                dc.w    FBZBossS3_HingeFollowAndWaitOrbit-FBZEndBossS3_Hinge_ThreeStateOffsets
                dc.w    FBZBossS3_HingeApplyOrbitHeight-FBZEndBossS3_Hinge_ThreeStateOffsets
; ---------------------------------------------------------------------------

FBZBossS3_InitHingeAndChooseSide:
                lea     FBZBossS3_ConnectorAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                tst.b   subtype(a1)
                beq.s   FBZBossS3_HingeBindRootAndSpawnLinks
                bset    #0,render_flags(a0)

FBZBossS3_HingeBindRootAndSpawnLinks:
                move.w  parent3(a1),$44(a0)
                lea     FBZBossS3_HingeConnectorChildren(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

FBZBossS3_HingeFollowAndWaitOrbit:
                jsr     Refresh_ChildPosition(pc)
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                bne.s   FBZBossS3_HingeBeginOrbitWait
                rts
; ---------------------------------------------------------------------------

FBZBossS3_HingeBeginOrbitWait:
                move.b  #4,routine(a0)
                move.b  #2,$40(a0)
                move.w  #$1FF,$2E(a0)
                move.l  #FBZBossS3_HingeResumeFollowing,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_HingeApplyOrbitHeight:
                movea.w $44(a0),a1
                move.b  $3C(a1),$3C(a0)
                lea     (FBZEndBoss_CircleLookup2).l,a2
                jsr     MoveSprite_AngleYLookup(pc)
                bsr.w   SetFBZEndBossHingeDepthFromPhase
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZBossS3_HingeResumeFollowing:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_ConnectorDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZEndBossS3_Connector_TwoStateOffsets(pc,d0.w),d1
                jsr     FBZEndBossS3_Connector_TwoStateOffsets(pc,d1.w)
                moveq   #8,d0
                jmp     Child_Draw_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------
FBZEndBossS3_Connector_TwoStateOffsets:
                dc.w    FBZBossS3_InitConnectorSideOffset-FBZEndBossS3_Connector_TwoStateOffsets
                dc.w    FBZBossS3_ConnectorSyncAndInterpolate-FBZEndBossS3_Connector_TwoStateOffsets
; ---------------------------------------------------------------------------

FBZBossS3_InitConnectorSideOffset:
                lea     FBZBossS3_ConnectorAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                moveq   #-$1C,d0
                btst    #0,render_flags(a1)
                beq.s   FBZBossS3_ConnectorBindEndpoints
                bset    #0,render_flags(a0)
                neg.w   d0

FBZBossS3_ConnectorBindEndpoints:
                movea.w parent3(a1),a1
                move.w  parent3(a1),$44(a0)
                move.b  d0,child_dx(a0)
                move.b  #2,child_dy(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_ConnectorSyncAndInterpolate:
                jsr     Child_GetPriority(pc)
                bra.w   FBZBossS3_ConnectorInterpolateXY
; ---------------------------------------------------------------------------

FBZBossS3_InitFlameRequester:
                lea     FBZBossS3_FlameRequesterAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)

FBZBossS3_FlameRequesterRearm:
                move.l  #FBZBossS3_FlameRequesterCheckRequest,(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_FlameRequesterCheckRequest:
                jsr     Child_GetPriority(pc)
                btst    #7,status(a1)
                bne.s   FBZBossS3_FlameRequesterFollowShip
                btst    #1,$38(a1)
                beq.s   FBZBossS3_FlameRequesterFollowAndDraw
                move.l  #Refresh_ChildPosWait,(a0)
                move.w  #$5F,$2E(a0)
                move.l  #FBZBossS3_FlameRequesterRearm,$34(a0)
                lea     FBZBossS3_FlamePartChildren(pc),a2
                jsr     CreateChild6_Simple(pc)

FBZBossS3_FlameRequesterFollowAndDraw:
                jsr     Refresh_ChildPosition(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZBossS3_FlameRequesterFollowShip:
                move.l  #FBZBossS3_FlameRequesterWaitRelease,(a0)
                move.w  $3E(a1),$46(a0)
                subq.b  #4,child_dy(a0)
                jsr     Refresh_ChildPosition(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZBossS3_FlameRequesterWaitRelease:
                jsr     Refresh_ChildPosition(pc)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

FBZBossS3_InitFlamePartAndDelay:
                bsr.w   InitializeFBZEndBossFlameColumnPart
                move.l  #Obj_Wait,(a0)
                move.l  #FBZBossS3_FlamePartBeginAnimation,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_FlamePartBeginAnimation:
                move.l  #S3ChildRaw_RefreshAnimateAndTouch,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_InitBodyFragment:
                lea     FBZBossS3_FragmentAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #8,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$34,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------

FBZBossS3_InitSupportFragment:
                lea     FBZBossS3_FragmentAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$C,d0
                move.b  d0,mapping_frame(a0)
                moveq   #8,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------

FBZBossS3_ConnectorInterpolateXY:
                movea.w $44(a0),a1
                movea.w parent3(a0),a2
                move.w  x_pos(a1),d0
                move.b  child_dx(a0),d1
                ext.w   d1
                add.w   d0,d1
                move.w  x_pos(a2),d2
                sub.w   d2,d1
                moveq   #$10,d3
                moveq   #0,d4
                move.b  subtype(a0),d4
                bsr.w   PositionFBZEndBossConnectorAxisByQuarter
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                add.w   d0,d1
                move.w  y_pos(a2),d2
                sub.w   d2,d1
                moveq   #$14,d3
                bsr.w   PositionFBZEndBossConnectorAxisByQuarter
                tst.b   $3C(a2)
                beq.s   FBZBossS3_ConnectorPhaseQueueReturn
                bmi.s   FBZBossS3_ConnectorPhaseQueueReturn
                move.w  FBZBossS3_ConnectorPhaseQueueWords(pc,d4.w),priority(a0)

FBZBossS3_ConnectorPhaseQueueReturn:
                rts
; ---------------------------------------------------------------------------
FBZBossS3_ConnectorPhaseQueueWords:
                dc.w    $200
                dc.w    $180
                dc.w    $100
                dc.w    $80

; =============== S U B R O U T I N E =======================================

PositionFBZEndBossConnectorAxisByQuarter:
                move.w  FBZBossS3_ConnectorFractionOffsets(pc,d4.w),d5
                jmp     FBZBossS3_ConnectorFractionOffsets(pc,d5.w)
; End of function PositionFBZEndBossConnectorAxisByQuarter

; ---------------------------------------------------------------------------
FBZBossS3_ConnectorFractionOffsets:
                dc.w    FBZBossS3_ConnectorQuarterDelta-FBZBossS3_ConnectorFractionOffsets
                dc.w    FBZEndBossS3_Connector_HalfSignedDelta-FBZBossS3_ConnectorFractionOffsets
                dc.w    FBZBossS3_ConnectorThreeQuarterDelta-FBZBossS3_ConnectorFractionOffsets
                dc.w    FBZBossS3_ConnectorStoreInterpolatedAxis-FBZBossS3_ConnectorFractionOffsets
; ---------------------------------------------------------------------------

FBZBossS3_ConnectorQuarterDelta:
                asr.w   #2,d1
                bra.w   FBZBossS3_ConnectorStoreInterpolatedAxis
; ---------------------------------------------------------------------------

FBZEndBossS3_Connector_HalfSignedDelta:
                asr.w   #1,d1
                bra.w   FBZBossS3_ConnectorStoreInterpolatedAxis
; ---------------------------------------------------------------------------

FBZBossS3_ConnectorThreeQuarterDelta:
                asr.w   #1,d1
                move.w  d1,d0
                asr.w   #1,d1
                add.w   d0,d1

FBZBossS3_ConnectorStoreInterpolatedAxis:
                add.w   d1,d2
                move.w  d2,(a0,d3.w)
                rts

; =============== S U B R O U T I N E =======================================

InitializeFBZEndBossFlameColumnPart:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  FBZBossS3_FlamePartWaits(pc,d0.w),$2E(a0)
                move.w  FBZBossS3_FlamePartOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                add.w   d0,d0
                move.l  FBZBossS3_FlamePartAnimationPointers(pc,d0.w),$30(a0)
                movea.l FBZBossS3_FlamePartAttributePointers(pc,d0.w),a1
                jsr     SetUp_ObjAttributes(pc)
                bset    #4,shield_reaction(a0)
                jmp     Refresh_ChildPosition(pc)
; End of function InitializeFBZEndBossFlameColumnPart

; ---------------------------------------------------------------------------
FBZBossS3_FlamePartWaits:
                dc.w    $50
                dc.w    $4D
                dc.w    $4A
                dc.w    $47
                dc.w    $44
                dc.w    $41
                dc.w    $3E
                dc.w    $3B
                dc.w    0
FBZBossS3_FlamePartOffsets:
                dc.b    0,-$68
                dc.b    8,-$5C
                dc.b    -8,-$5C
                dc.b    0,-$4C
                dc.b    0,-$3C
                dc.b    0,-$2C
                dc.b    0,-$1C
                dc.b    0, -$C
                dc.b    0,-$10
FBZBossS3_FlamePartAnimationPointers:
                dc.l    FBZBossS3_FlameAnimation
                dc.l    FBZBossS3_FlameAnimation
                dc.l    FBZBossS3_FlameAnimation
                dc.l    FBZBossS3_FlameExplosionAnimation
                dc.l    FBZBossS3_FlameExplosionAnimation
                dc.l    FBZBossS3_FlameExplosionAnimation
                dc.l    FBZBossS3_FlameExplosionAnimation
                dc.l    FBZBossS3_FlameExplosionAnimation
                dc.l    FBZBossS3_FlameBodyAnimation
FBZBossS3_FlamePartAttributePointers:
                dc.l    FBZBossS3_FlameAttributes
                dc.l    FBZBossS3_FlameAttributes
                dc.l    FBZBossS3_FlameAttributes
                dc.l    FBZBossS3_FlameExplosionAttributes
                dc.l    FBZBossS3_FlameExplosionAttributes
                dc.l    FBZBossS3_FlameExplosionAttributes
                dc.l    FBZBossS3_FlameExplosionAttributes
                dc.l    FBZBossS3_FlameExplosionAttributes
                dc.l    FBZBossS3_FlameBodyAttributes

; =============== S U B R O U T I N E =======================================

CenterFBZEndBossXBetweenSupports:
                movea.w $44(a0),a1
                movea.w parent3(a0),a2
                move.w  x_pos(a1),d0
                move.w  x_pos(a2),d1
                sub.w   d0,d1
                asr.w   #1,d1
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                rts
; End of function CenterFBZEndBossXBetweenSupports

; =============== S U B R O U T I N E =======================================

SetFBZEndBossBodyDepthFromPhase:
                tst.b   $3C(a0)
                beq.s   FBZBossS3_DepthSetPriority
                bmi.s   FBZBossS3_DepthClearPriority
                bset    #7,art_tile(a0)
                move.w  #$80,priority(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_DepthClearPriority:
                bclr    #7,art_tile(a0)
                move.w  #$380,priority(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossS3_DepthSetPriority:
                bset    #7,art_tile(a0)
                move.w  #$380,priority(a0)
                rts
; End of function SetFBZEndBossBodyDepthFromPhase

; =============== S U B R O U T I N E =======================================

SetFBZEndBossHingeDepthFromPhase:
                tst.b   $3C(a0)
                beq.s   FBZBossS3_DepthSetPriority
                bmi.s   FBZBossS3_DepthClearPriority
                bset    #7,art_tile(a0)
                move.w  #$280,priority(a0)
                rts
; End of function SetFBZEndBossHingeDepthFromPhase

; =============== S U B R O U T I N E =======================================

HandleFBZEndBossFourColorHitOrDefeat:
                tst.l   (a0)
                beq.s   FBZBossS3_HitUpdateReturn
                tst.b   collision_flags(a0)
                bne.s   FBZBossS3_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   FBZBossS3_BeginScoredDefeatAlignment
                tst.b   $20(a0)
                bne.s   FBZBossS3_HitChooseFlashRow
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

FBZBossS3_HitChooseFlashRow:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   FBZBossS3_HitCopyColorsAndTick
                addq.w  #2*4,d0

FBZBossS3_HitCopyColorsAndTick:
                lea     FBZBossS3_HitPaletteDestinations(pc),a1
                lea     FBZEndBossS3_Hit_TwoFourColorSourceRows(pc,d0.w),a2
                jsr     CopyWordData_4(pc)
                subq.b  #1,$20(a0)
                bne.s   FBZBossS3_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

FBZBossS3_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

FBZBossS3_BeginScoredDefeatAlignment:
                move.l  #FBZBossS3_DefeatAlignOrbitToZero,(a0)
                jmp     BossDefeated_StopTimer(pc)
; End of function HandleFBZEndBossFourColorHitOrDefeat

; ---------------------------------------------------------------------------
FBZBossS3_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$06, Normal_palette_line_2+$08, Normal_palette_line_2+$12, Normal_palette_line_2+$1C
FBZEndBossS3_Hit_TwoFourColorSourceRows:
                dc.w    $2A,   $26,   $20,  $644
                dc.w    $888,  $AAA,  $EEE,  $AAA
ObjDat_FBZEndBoss:
                dc.l    Map_FBZEndBoss
                dc.w    make_art_tile(ArtTile_FBZEndBoss-$20,1,1)
                dc.w    $280
                dc.b    $28, $18,   0, $16
FBZBossS3_SupportAttributes:
                dc.w    $300
                dc.b    $10, $20,   1, $A3
FBZBossS3_ConnectorAttributes:
                dc.w    $280
                dc.b    8,   8,   2,   0
FBZBossS3_FlameRequesterAttributes:
                dc.w    $200
                dc.b    $C,   8,   3,   0
FBZBossS3_FragmentAttributes:
                dc.w    $100
                dc.b    $14, $10,   8,   0
FBZBossS3_FlameBodyAttributes:
                dc.l    Map_FBZEndBoss
                dc.w    make_art_tile(ArtTile_FBZEndBoss-$20,0,1)
                dc.w    $80
                dc.b    4,   8,   4, $8B
FBZBossS3_FlameExplosionAttributes:
                dc.l    Map_BossExplosion
                dc.w    make_art_tile(ArtTile_BossExplosion,0,1)
                dc.w    $80
                dc.b    $10, $10,   0, $8B
FBZBossS3_FlameAttributes:
                dc.l    Map_FBZEndBossFlame
                dc.w    make_art_tile(ArtTile_FBZEndBossFlame+$4,0,1)
                dc.w    $80
                dc.b    $10, $10,   0, $8B
FBZBossS3_SupportAndFlameChildren:
                dc.w    3-1
                dc.l    FBZBossS3_SupportDispatchAndDraw
                dc.b    -$30,-$48
                dc.l    FBZBossS3_SupportDispatchAndDraw
                dc.b    $30,-$48
                dc.l    FBZBossS3_InitFlameRequester
                dc.b    0,-$28
FBZBossS3_SupportHingeChild:
                dc.w    1-1
                dc.l    FBZBossS3_HingeDispatchAndDraw
                dc.b    0, $20
FBZBossS3_HingeConnectorChildren:
                dc.w    4-1
                dc.l    FBZBossS3_ConnectorDispatchAndDraw
                dc.b    0,   0
FBZBossS3_FlamePartChildren:
                dc.w    9-1
                dc.l    FBZBossS3_InitFlamePartAndDelay
FBZBossS3_BodyFragmentChildren:
                dc.w    4-1
                dc.l    FBZBossS3_InitBodyFragment
                dc.b    -$14,   8
                dc.l    FBZBossS3_InitBodyFragment
                dc.b    $14,   8
                dc.l    FBZBossS3_InitBodyFragment
                dc.b    -$10, $20
                dc.l    FBZBossS3_InitBodyFragment
                dc.b    $10, $20
FBZBossS3_SupportFragmentChildren:
                dc.w    4-1
                dc.l    FBZBossS3_InitSupportFragment
                dc.b    -8,-$10
                dc.l    FBZBossS3_InitSupportFragment
                dc.b    8,-$10
                dc.l    FBZBossS3_InitSupportFragment
                dc.b    -8, $10
                dc.l    FBZBossS3_InitSupportFragment
                dc.b    8, $10
FBZBossS3_FlameBodyAnimation:
                dc.b    4,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    6,   3
                dc.b    7,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    6,   3
                dc.b    7,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    6,   3
                dc.b    7,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    6,   3
                dc.b    7,   3
                dc.b    $F4
FBZBossS3_FlameExplosionAnimation:
                dc.b    0,   2
                dc.b    0,   2
                dc.b    1,   2
                dc.b    2,   3
                dc.b    3,   4
                dc.b    4,   5
                dc.b    5,   6
                dc.b    $F4
FBZBossS3_FlameAnimation:
                dc.b    0,   2
                dc.b    0,   2
                dc.b    1,   3
                dc.b    2,   4
                dc.b    3,   5
                dc.b    4,   6
                dc.b    $F4
                even
Pal_FBZEndBoss:
                binclude "data/Levels/FBZ/Palettes/FBZ End Boss.bin"
                even
