; Owner: objects/bosses/lbz/tower_cannon/s3
; Responsibility: Launch Base first final boss battle state, attacks and coordinated child actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZFinalBoss1:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZFinalBoss1_Index(pc,d0.w),d1
                jsr     LBZFinalBoss1_Index(pc,d1.w)
                bsr.w   LBZBoss1_HandleHitOrDefeat
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
LBZFinalBoss1_Index:
                dc.w    LBZBoss1S3_InitBossAndChildren-LBZFinalBoss1_Index
                dc.w    LBZFinalBoss1S3_Root_CountInitialWait-LBZFinalBoss1_Index
                dc.w    LBZBoss1S3_CheckLowerPassBoundary-LBZFinalBoss1_Index
                dc.w    LBZBoss1S3_HoldDuringHit-LBZFinalBoss1_Index
                dc.w    LBZBoss1S3_TickSectionDropPause-LBZFinalBoss1_Index
                dc.w    LBZBoss1S3_StepSectionDrop-LBZFinalBoss1_Index
; ---------------------------------------------------------------------------

LBZBoss1S3_InitBossAndChildren:
                lea     ObjDat_LBZFinalBoss1(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #9,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.w  #$7F,$2E(a0)
                move.l  #LBZBoss1S3_BeginVerticalPass,$34(a0)
                moveq   #PLCID_71,d0
                jsr     (Load_PLC).l
                jsr     (AllocateObject).l
                bne.s   LBZBoss1S3_SpawnBossChildGroups
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

LBZBoss1S3_SpawnBossChildGroups:
                lea     (Child1_MakeRoboHead3).l,a2
                jsr     CreateChild1_Normal(pc)
                lea     LBZBoss1S3_TopTrimChild(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     LBZBoss1S3_BodySectionChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     LBZBoss1S3_OrbiterChild(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

LBZFinalBoss1S3_Root_CountInitialWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZBoss1S3_BeginVerticalPass:
                move.b  #4,routine(a0)
                move.w  #-$100,y_vel(a0)
                lea     Pal_LBZFinalBoss1(pc),a1
                jmp     PalLoad_Line1(pc)
; ---------------------------------------------------------------------------

LBZBoss1S3_CheckLowerPassBoundary:
                move.w  y_pos(a0),d0
                move.w  (Camera_Y_pos).w,d1
                tst.w   y_vel(a0)
                bmi.s   LBZBoss1S3_CheckUpperPassBoundary
                addi.w  #$118,d1
                cmp.w   d1,d0
                bhs.s   LBZBoss1S3_CheckTurnaroundWindow
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

LBZBoss1S3_CheckUpperPassBoundary:
                subi.w  #$B0,d1
                cmp.w   d1,d0
                bls.s   LBZBoss1S3_CheckTurnaroundWindow
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

; Above two remaining hits, reverse only during the cannon window
LBZBoss1S3_CheckTurnaroundWindow:
                cmpi.b  #2,collision_property(a0)
                bls.s   LBZBoss1S3_ChooseRandomPassSide
                btst    #3,$38(a0)
                beq.s   LBZBoss1S3_TurnaroundReturn

LBZBoss1S3_ChooseRandomPassSide:
                jsr     (Random_Number).l
                swap    d0
                moveq   #0,d1
                bclr    #0,render_flags(a0)
                btst    #0,d0
                beq.s   LBZBoss1S3_ApplySideAndReverseY
                moveq   #2,d1
                bset    #0,render_flags(a0)

LBZBoss1S3_ApplySideAndReverseY:
                move.w  LBZBoss1S3_PassSideCameraXOffsets(pc,d1.w),d1
                move.w  (Camera_X_pos).w,d2
                add.w   d1,d2
                move.w  d2,x_pos(a0)
                move.w  #$100,d0
                tst.w   y_vel(a0)
                bmi.s   LBZBoss1S3_StoreReversedYSpeed
                neg.w   d0

LBZBoss1S3_StoreReversedYSpeed:
                move.w  d0,y_vel(a0)

LBZBoss1S3_TurnaroundReturn:
                rts
; ---------------------------------------------------------------------------
LBZBoss1S3_PassSideCameraXOffsets:
                dc.w    $110
                dc.w    $30
; ---------------------------------------------------------------------------

LBZBoss1S3_HoldDuringHit:
                rts
; ---------------------------------------------------------------------------

LBZBoss1S3_TickSectionDropPause:
                subq.b  #1,$40(a0)
                bmi.s   LBZBoss1S3_BeginSectionDrop
                rts
; ---------------------------------------------------------------------------

LBZBoss1S3_BeginSectionDrop:
                move.b  #$A,routine(a0)
                move.b  #4,$40(a0)

LBZBoss1S3_SharedReturn:
                rts
; ---------------------------------------------------------------------------

; Move eight pixels down on each of five updates before returning to the hit hold
LBZBoss1S3_StepSectionDrop:
                addq.w  #8,y_pos(a0)
                subq.b  #1,$40(a0)
                bmi.s   LBZBoss1S3_ResumeHitHold
                rts
; ---------------------------------------------------------------------------

LBZBoss1S3_ResumeHitHold:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1S3_DescendToHandoffHeight:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$140,d1
                cmp.w   d1,d0
                bcc.s   LBZBoss1S3_TryFinalBossTwo
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_TryFinalBossTwo:
                bset    #5,$38(a0)
                move.w  (Camera_X_pos).w,d2
                addi.w  #$100,d2
                move.w  d2,x_pos(a0)
                move.w  d1,y_pos(a0)
                bclr    #0,render_flags(a0)
                bclr    #7,art_tile(a0)
                jsr     (AllocateObject).l
                bne.s   LBZBoss1S3_QueueDefeatDeletion
                move.l  #Obj_LBZFinalBoss2,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)

LBZBoss1S3_QueueDefeatDeletion:
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

LBZBoss1S3_AltExitRiseAboveCamera:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                move.w  (Camera_Y_pos).w,d1
                subi.w  #$40,d1
                cmp.w   d1,d0
                bcs.s   LBZBoss1S3_AltExitRepositionAndFlip
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_AltExitRepositionAndFlip:
                move.l  #LBZBoss1S3_AltExitDescendToCamera,(a0)
                bset    #5,$38(a0)
                bset    #0,render_flags(a0)
                move.w  (Camera_X_pos).w,d2
                addi.w  #$40,d2
                move.w  d2,x_pos(a0)
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1S3_AltExitDescendToCamera:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$40,d1
                cmp.w   d1,d0
                bcc.s   LBZBoss1S3_AltExitSpawnFlameAndMove
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_AltExitSpawnFlameAndMove:
                move.l  #LBZBoss1S3_AltExitApproachPayloadX,(a0)
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_AltExitApproachPayloadX:
                move.w  x_pos(a0),d0
                addq.w  #2,d0
                move.w  (Camera_X_pos).w,d1
                addi.w  #$A0,d1
                cmp.w   d1,d0
                bcc.s   LBZBoss1S3_AltExitDropPayload
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_AltExitDropPayload:
                move.w  d0,x_pos(a0)
                move.l  #LBZBoss1S3_AltExitApproachRightGate,(a0)
                lea     LBZBoss1S3_AlternatePayloadChild(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_AltExitApproachRightGate:
                move.w  x_pos(a0),d0
                addq.w  #2,d0
                move.w  (Camera_X_pos).w,d1
                addi.w  #$1C0,d1
                cmp.w   d1,d0
                bcc.s   LBZBoss1S3_AltExitSignalChildRemoval
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_AltExitSignalChildRemoval:
                move.l  #LBZBoss1S3_AltExitClearBossAndDelete,(a0)
                bset    #6,status(a0)
                bset    #4,$38(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_AltExitClearBossAndDelete:
                clr.b   (Boss_flag).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_InitPrimarySectionAndCannons:
                lea     LBZBoss1S3_PrimarySectionAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #LBZBoss1S3_SectionFollowAndCheckBreak,(a0)
                move.l  #LBZBoss1S3_SectionFollowAndCheckBreak,$34(a0)
                lea     LBZBoss1S3_SectionCannonChildren(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

LBZBoss1S3_SectionFollowAndCheckBreak:
                jsr     Refresh_ChildPositionAdjusted(pc)
                bsr.w   BreakOrSuspendLBZFinalBoss1BodySection
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

LBZBoss1S3_SectionWaitHitAndAdjust:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                bne.s   LBZBoss1S3_SectionDrawDuringHit
                move.l  $34(a0),(a0)
                btst    #5,status(a1)
                beq.s   LBZBoss1S3_SectionDrawDuringHit
                subi.b  #$28,child_dy(a0)
                cmpi.b  #4,subtype(a0)
                bne.s   LBZBoss1S3_SectionDrawDuringHit
                bclr    #5,status(a1)

LBZBoss1S3_SectionDrawDuringHit:
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

LBZBoss1S3_DeleteBrokenSection:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_InitMiddleSection:
                move.w  #1,$3C(a0)
                bra.s   LBZBoss1S3_InitPrimarySectionAndCannons
; ---------------------------------------------------------------------------

LBZBoss1S3_InitLowerSectionAndFlames:
                lea     LBZBoss1S3_LowerSectionAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #LBZBoss1S3_LowerSectionCheckBreak,(a0)
                move.l  #LBZBoss1S3_LowerSectionCheckBreak,$34(a0)
                move.w  #2,$3C(a0)
                lea     LBZBoss1S3_LowerSectionFlameChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

LBZBoss1S3_LowerSectionCheckBreak:
                jsr     Refresh_ChildPositionAdjusted(pc)
                bsr.w   BreakOrSuspendLBZFinalBoss1BodySection
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

LBZBoss1S3_InitSectionDebris:
                lea     LBZBoss1S3_SectionDebrisAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #LBZBoss1S3_SectionDebrisFallAndDraw,(a0)
                move.w  #$60,$2E(a0)
                bsr.w   LBZBoss1Debris_InitFrameAndVel

LBZBoss1S3_SectionDebrisFallAndDraw:
                jsr     (MoveSprite).l
                jsr     TimedSprite_ScreenLock(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_InitTopTrim:
                move.l  #LBZBoss1S3_TopTrimFollowOrDelete,(a0)
                lea     LBZFinalBoss1S3_TopTrim_FullAttributes(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

LBZBoss1S3_TopTrimFollowOrDelete:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZBoss1S3_DeleteTopTrim
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_DeleteTopTrim:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_InitHitOverlay:
                lea     LBZBoss1S3_HitOverlayAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #LBZBoss1S3_HitOverlayDrawDuringFlash,(a0)
                tst.b   subtype(a0)
                beq.s   LBZBoss1S3_HitOverlayInitReturn
                move.b  #$22,mapping_frame(a0)

LBZBoss1S3_HitOverlayInitReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss1S3_HitOverlayDrawDuringFlash:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                beq.s   LBZBoss1S3_DeleteHitOverlay
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_DeleteHitOverlay:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_InitCannonAndCacheRoot:
                lea     LBZFinalBoss1S3_Cannon_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #LBZBoss1S3_CannonTurnAndCheckBreak,(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                tst.b   subtype(a0)
                beq.s   LBZBoss1S3_CannonTurnAndCheckBreak
                move.b  #8,$39(a0)

LBZBoss1S3_CannonTurnAndCheckBreak:
                bsr.w   AdvanceLBZFinalBoss1CannonTurnCycle
                moveq   #4,d0
                jmp     Child_Draw_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------
; unused
                movea.w $44(a0),a1
                btst    #6,status(a1)
                bne.s   LBZBoss1S3_CannonHitHoldDraw
                move.l  #LBZBoss1S3_CannonTurnAndCheckBreak,(a0)

LBZBoss1S3_CannonHitHoldDraw:
                moveq   #4,d0
                jmp     Child_Draw_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------

LBZBoss1S3_InitLaserCharge:
                lea     LBZBoss1S3_LaserChargeAttributes(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #LBZBoss1S3_LaserChargeAccelerateBlink,(a0)
                move.w  #8,$3A(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1S3_LaserChargeAccelerateBlink:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZBoss1S3_DeleteChargeWithCannon
                jsr     Refresh_ChildPositionAdjusted(pc)
                subq.w  #1,$2E(a0)
                bpl.w   LBZBoss1S3_SharedReturn
                move.w  $3A(a0),$2E(a0)
                subq.w  #1,$3A(a0)
                bpl.s   LBZBoss1S3_LaserChargeDraw
                move.l  #LBZBoss1S3_LaserChargeTickFinalBlink,(a0)
                move.w  #$18,$2E(a0)

LBZBoss1S3_LaserChargeDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_DeleteChargeWithCannon:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_LaserChargeTickFinalBlink:
                jsr     Refresh_ChildPositionAdjusted(pc)
                subq.w  #1,$2E(a0)
                bmi.s   LBZBoss1S3_LaserChargeBeginLaunchAnim
                btst    #0,$2F(a0)
                bne.w   LBZBoss1S3_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_LaserChargeBeginLaunchAnim:
                move.l  #LBZBoss1S3_LaserChargeFollowAndDraw,(a0)
                move.l  #LBZBoss1S3_LaserChargeLaunchAnim,$30(a0)
                move.l  #LBZBoss1S3_LaserBeginFlight,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_LaserChargeFollowAndDraw:
                jsr     Refresh_ChildPositionAdjusted(pc)
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_LaserBeginFlight:
                move.l  #LBZBoss1S3_LaserSpawnTrailByParity,(a0)
                tst.b   render_flags(a0)
                bpl.s   LBZBoss1S3_LaserChooseFacingLaunch
                moveq   #signextendB(sfx_Laser),d0
                jsr     (Play_SFX).l

LBZBoss1S3_LaserChooseFacingLaunch:
                move.b  #$9C,collision_flags(a0)
                move.b  #$11,mapping_frame(a0)
                moveq   #-$2C,d0
                move.w  #-$800,d1
                btst    #0,render_flags(a0)
                beq.s   LBZBoss1S3_LaserStoreOffsetAndSpeed
                neg.w   d0
                neg.w   d1

LBZBoss1S3_LaserStoreOffsetAndSpeed:
                add.w   d0,x_pos(a0)
                move.w  d1,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

; The parity paths write the trail animation pointer without a separate allocation check
LBZBoss1S3_LaserSpawnTrailByParity:
                btst    #0,(V_int_run_count+3).w
                bne.s   LBZBoss1S3_LaserSpawnOddTrail
                lea     LBZBoss1S3_LaserTrailChild(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.l  #LBZBoss1S3_LaserTrailEvenAnim,$30(a1)
                bsr.w   RandomizeLBZFinalBoss1LaserTrailOffset
                bra.w   LBZBoss1S3_LaserMoveAndCull
; ---------------------------------------------------------------------------

LBZBoss1S3_LaserSpawnOddTrail:
                lea     LBZBoss1S3_LaserTrailChild(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.l  #LBZBoss1S3_LaserTrailOddAnim,$30(a1)
                bsr.w   RandomizeLBZFinalBoss1LaserTrailOffset

LBZBoss1S3_LaserMoveAndCull:
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

LBZBoss1S3_InitLaserTrail:
                lea     LBZBoss1S3_LaserTrailAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #LBZBoss1S3_LaserTrailAnimateAndDraw,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jsr     Refresh_ChildPositionAdjusted(pc)

LBZBoss1S3_LaserTrailAnimateAndDraw:
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_InitSectionFlame:
                lea     LBZBoss1S3_SectionFlameAttributes(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #LBZBoss1S3_SectionFlameFollowAndDraw,(a0)
                move.l  #LBZBoss1S3_SectionFlameAnim,$30(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1S3_SectionFlameFollowAndDraw:
                jsr     Refresh_ChildPositionAdjusted(pc)
                jsr     Animate_Raw(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

LBZBoss1S3_InitAlternateUnderside:
                lea     LBZBoss1S3_AlternateUndersideAttributes(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #LBZBoss1S3_AlternateUndersideDraw,(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1S3_AlternateUndersideDraw:
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

LBZBoss1S3_PayloadDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZBoss1S3_PayloadStateOffsets(pc,d0.w),d1
                jsr     LBZBoss1S3_PayloadStateOffsets(pc,d1.w)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
LBZBoss1S3_PayloadStateOffsets:
                dc.w    LBZBoss1S3_InitBouncingPayload-LBZBoss1S3_PayloadStateOffsets
                dc.w    LBZBoss1S3_PayloadFallAndProbe-LBZBoss1S3_PayloadStateOffsets
                dc.w    LBZFinalBoss1S3_Payload_DeleteDirectly-LBZBoss1S3_PayloadStateOffsets
; ---------------------------------------------------------------------------

LBZBoss1S3_InitBouncingPayload:
                lea     LBZBoss1S3_PayloadAttributes(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.b  #$10,y_radius(a0)
                move.l  #LBZBoss1S3_PayloadBounceOrSettle,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1S3_PayloadFallAndProbe:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   LBZBoss1S3_SharedReturn
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

; Reflect half the downward speed unless it is below one pixel per frame
LBZBoss1S3_PayloadBounceOrSettle:
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                bcs.s   LBZBoss1S3_PayloadBreakUpAndDelete
                asr.w   #1,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1S3_PayloadBreakUpAndDelete:
                move.b  #4,routine(a0)
                lea     (AIZMiniS3_MissileImpactChildren).l,a2
                jsr     CreateChild1_Normal(pc)
                lea     (Child6_CreateBossExplosion).l,a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

LBZFinalBoss1S3_Payload_DeleteDirectly:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1S3_InitOrbiter:
                lea     LBZFinalBoss1S3_Orbiter_FullAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #LBZBoss1S3_OrbiterAnimateAndCircle,(a0)
                move.l  #LBZBoss1S3_OrbiterFlipCycleAnim,$30(a0)
                move.l  #LBZBoss1S3_OrbiterCycleFlips,$34(a0)
                move.b  #-$14,child_dy(a0)
                tst.b   subtype(a0)
                beq.s   LBZBoss1S3_OrbiterPhaseInitReturn
                move.b  #$80,$3C(a0)

LBZBoss1S3_OrbiterPhaseInitReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss1S3_OrbiterAnimateAndCircle:
                jsr     Animate_Raw(pc)
                addq.b  #1,$3C(a0)
                moveq   #3,d2
                jsr     MoveSprite_CircularSimpleOffset(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

LBZBoss1S3_OrbiterCycleFlips:
                move.b  $39(a0),d0
                addq.b  #1,d0
                move.b  d0,$39(a0)
                andi.b  #3,d0
                andi.b  #$FC,render_flags(a0)
                or.b    d0,render_flags(a0)
                rts
