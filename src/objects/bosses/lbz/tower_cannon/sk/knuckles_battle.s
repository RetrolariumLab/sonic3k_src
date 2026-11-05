; Owner: objects/bosses/lbz/tower_cannon/sk
; Responsibility: Launch Base Knuckles final-boss variant, coordinated actors, motion and collision helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZFinalBossKnux:
                lea     LBZBoss1SK_KnucklesEntryCameraBounds(pc),a1
                jsr     (Check_CameraInRange).l
                move.b  #mus_EndBoss,boss_saved_mus(a0)
                jsr     (Boss_BeginCameraTransition).l
                move.l  #LBZBoss1SK_KnucklesTickCameraTransition,(a0)
                move.l  #LBZBoss1SK_KnucklesInstallBossInit,$34(a0)
                clr.b   (ZoneEventLatchOrBossReleaseSignal).w
                clr.b   (ZoneButtonRequestOrBridgeReleaseSignal).w
                moveq   #PLCID_71,d0
                jsr     (Load_PLC).l

; =============== S U B R O U T I N E =======================================

LBZFinalBoss_QueueShipAndExplosionArt:
                lea     PLC_LBZFinalBoss_Extra(pc),a1
                jmp     (Load_PLC_Raw).l
; End of function LBZFinalBoss_QueueShipAndExplosionArt

; ---------------------------------------------------------------------------
PLC_LBZFinalBoss_Extra: plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_LBZFinalBoss_Extra_End:
; ---------------------------------------------------------------------------

LBZBoss1SK_KnucklesTickCameraTransition:
                jmp     (SKEndCamera_TickAndSaveMusic).l
; ---------------------------------------------------------------------------

LBZBoss1SK_KnucklesInstallBossInit:
                move.l  #Obj_LBZFinalBoss1,(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_KnucklesRiseToHandoffHeight:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                move.w  (Camera_Y_pos).w,d1
                subi.w  #$50,d1
                cmp.w   d1,d0
                blo.s   LBZBoss1SK_KnucklesTryFinalBossTwo
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_KnucklesTryFinalBossTwo:
                move.w  d1,y_pos(a0)
                bset    #5,$38(a0)
                jsr     (AllocateObject).l
                bne.s   LBZBoss1SK_KnucklesQueueDefeatDeletion
                move.l  #Obj_LBZFinalBoss2,(a1)

LBZBoss1SK_KnucklesQueueDefeatDeletion:
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

LBZBoss1SK_InitPrimarySectionAndCannons:
                lea     LBZBoss1SK_PrimarySectionAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LBZBoss1SK_SectionFollowAndCheckBreak,(a0)
                move.l  #LBZBoss1SK_SectionFollowAndCheckBreak,$34(a0)
                lea     LBZBoss1SK_SectionCannonChildren(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

LBZBoss1SK_SectionFollowAndCheckBreak:
                jsr     (Refresh_ChildPositionAdjusted).l
                bsr.w   BreakOrSuspendLBZFinalBoss1BodySection
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_SectionWaitHitAndAdjust:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                bne.s   LBZBoss1SK_SectionDrawDuringHit
                move.l  $34(a0),(a0)
                btst    #5,status(a1)
                beq.s   LBZBoss1SK_SectionDrawDuringHit
                subi.b  #$28,child_dy(a0)
                cmpi.b  #4,subtype(a0)
                bne.s   LBZBoss1SK_SectionDrawDuringHit
                bclr    #5,status(a1)

LBZBoss1SK_SectionDrawDuringHit:
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_DeleteBrokenSection:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_InitMiddleSection:
                move.w  #1,$3C(a0)
                bra.s   LBZBoss1SK_InitPrimarySectionAndCannons
; ---------------------------------------------------------------------------

LBZBoss1SK_InitLowerSectionAndFlames:
                lea     LBZBoss1SK_LowerSectionAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LBZBoss1SK_LowerSectionCheckBreak,(a0)
                move.l  #LBZBoss1SK_LowerSectionCheckBreak,$34(a0)
                move.w  #2,$3C(a0)
                lea     LBZBoss1SK_LowerSectionFlameChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LBZBoss1SK_LowerSectionCheckBreak:
                jsr     (Refresh_ChildPositionAdjusted).l
                bsr.w   BreakOrSuspendLBZFinalBoss1BodySection
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_InitSectionDebris:
                lea     LBZBoss1SK_SectionDebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #LBZBoss1SK_SectionDebrisFallAndDraw,(a0)
                move.w  #$60,$2E(a0)
                bsr.w   LBZBoss1Debris_InitFrameAndVel

LBZBoss1SK_SectionDebrisFallAndDraw:
                jsr     (MoveSprite).l
                jsr     (TimedSprite_ScreenLock).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_InitTopTrim:
                move.l  #LBZBoss1SK_TopTrimFollowOrDelete,(a0)
                lea     LBZFinalBoss1SK_TopTrim_FullAttributes(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

LBZBoss1SK_TopTrimFollowOrDelete:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZBoss1SK_DeleteTopTrim
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_DeleteTopTrim:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_InitHitOverlay:
                lea     LBZBoss1SK_HitOverlayAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LBZBoss1SK_HitOverlayDrawDuringFlash,(a0)
                tst.b   subtype(a0)
                beq.s   LBZBoss1SK_HitOverlayInitReturn
                move.b  #$22,mapping_frame(a0)

LBZBoss1SK_HitOverlayInitReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_HitOverlayDrawDuringFlash:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                beq.s   LBZBoss1SK_DeleteHitOverlay
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_DeleteHitOverlay:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_InitCannonAndCacheRoot:
                lea     LBZFinalBoss1SK_Cannon_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #LBZBoss1SK_CannonTurnAndCheckBreak,(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                tst.b   subtype(a0)
                beq.s   LBZBoss1SK_CannonTurnAndCheckBreak
                move.b  #8,$39(a0)

LBZBoss1SK_CannonTurnAndCheckBreak:
                bsr.w   AdvanceLBZFinalBoss1CannonTurnCycle
                moveq   #4,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
; unused
                movea.w $44(a0),a1
                btst    #6,status(a1)
                bne.s   LBZBoss1SK_CannonHitHoldDraw
                move.l  #LBZBoss1SK_CannonTurnAndCheckBreak,(a0)

LBZBoss1SK_CannonHitHoldDraw:
                moveq   #4,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

LBZBoss1SK_InitLaserCharge:
                lea     LBZBoss1SK_LaserChargeAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #LBZBoss1SK_LaserChargeAccelerateBlink,(a0)
                move.w  #8,$3A(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_LaserChargeAccelerateBlink:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZBoss1SK_DeleteChargeWithCannon
                jsr     (Refresh_ChildPositionAdjusted).l
                subq.w  #1,$2E(a0)
                bpl.w   LBZBoss1SK_SharedReturn
                move.w  $3A(a0),$2E(a0)
                subq.w  #1,$3A(a0)
                bpl.s   LBZBoss1SK_LaserChargeDraw
                move.l  #LBZBoss1SK_LaserChargeTickFinalBlink,(a0)
                move.w  #$18,$2E(a0)

LBZBoss1SK_LaserChargeDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_DeleteChargeWithCannon:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_LaserChargeTickFinalBlink:
                jsr     (Refresh_ChildPositionAdjusted).l
                subq.w  #1,$2E(a0)
                bmi.s   LBZBoss1SK_LaserChargeBeginLaunchAnim
                btst    #0,$2F(a0)
                bne.w   LBZBoss1SK_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_LaserChargeBeginLaunchAnim:
                move.l  #LBZBoss1SK_LaserChargeFollowAndDraw,(a0)
                move.l  #LBZBoss1SK_LaserChargeLaunchAnim,$30(a0)
                move.l  #LBZBoss1SK_LaserBeginFlight,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_LaserChargeFollowAndDraw:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_LaserBeginFlight:
                move.l  #LBZBoss1SK_LaserSpawnTrailByParity,(a0)
                tst.b   render_flags(a0)
                bpl.s   LBZBoss1SK_LaserChooseFacingLaunch
                moveq   #signextendB(sfx_Laser),d0
                jsr     (Play_SFX).l

LBZBoss1SK_LaserChooseFacingLaunch:
                move.b  #$9C,collision_flags(a0)
                move.b  #$11,mapping_frame(a0)
                moveq   #-$2C,d0
                move.w  #-$800,d1
                btst    #0,render_flags(a0)
                beq.s   LBZBoss1SK_LaserStoreOffsetAndSpeed
                neg.w   d0
                neg.w   d1

LBZBoss1SK_LaserStoreOffsetAndSpeed:
                add.w   d0,x_pos(a0)
                move.w  d1,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

; The parity paths write the trail animation pointer without a separate allocation check
LBZBoss1SK_LaserSpawnTrailByParity:
                btst    #0,(V_int_run_count+3).w
                bne.s   LBZBoss1SK_LaserSpawnOddTrail
                lea     LBZBoss1SK_LaserTrailChild(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #LBZBoss1SK_LaserTrailEvenAnim,$30(a1)
                bsr.w   RandomizeLBZFinalBoss1LaserTrailOffset
                bra.w   LBZBoss1SK_LaserMoveAndCull
; ---------------------------------------------------------------------------

LBZBoss1SK_LaserSpawnOddTrail:
                lea     LBZBoss1SK_LaserTrailChild(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #LBZBoss1SK_LaserTrailOddAnim,$30(a1)
                bsr.w   RandomizeLBZFinalBoss1LaserTrailOffset

LBZBoss1SK_LaserMoveAndCull:
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

LBZBoss1SK_InitLaserTrail:
                lea     LBZBoss1SK_LaserTrailAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #LBZBoss1SK_LaserTrailAnimateAndDraw,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jsr     (Refresh_ChildPositionAdjusted).l

LBZBoss1SK_LaserTrailAnimateAndDraw:
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_InitSectionFlame:
                lea     LBZBoss1SK_SectionFlameAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                bset    #4,shield_reaction(a0)
                move.l  #LBZBoss1SK_SectionFlameFollowAndDraw,(a0)
                move.l  #LBZBoss1SK_SectionFlameAnim,$30(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_SectionFlameFollowAndDraw:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Animate_Raw).l
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_InitOrbiter:
                lea     LBZFinalBoss1SK_Orbiter_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LBZBoss1SK_OrbiterAnimateAndCircle,(a0)
                move.l  #LBZBoss1SK_OrbiterFlipCycleAnim,$30(a0)
                move.l  #LBZBoss1SK_OrbiterCycleFlips,$34(a0)
                move.b  #-$14,child_dy(a0)
                tst.b   subtype(a0)
                beq.s   LBZBoss1SK_OrbiterPhaseInitReturn
                move.b  #$80,$3C(a0)

LBZBoss1SK_OrbiterPhaseInitReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_OrbiterAnimateAndCircle:
                jsr     (Animate_Raw).l
                addq.b  #1,$3C(a0)
                moveq   #3,d2
                jsr     (MoveSprite_CircularSimpleOffset).l
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_OrbiterCycleFlips:
                move.b  $39(a0),d0
                addq.b  #1,d0
                move.b  d0,$39(a0)
                andi.b  #3,d0
                andi.b  #$FC,render_flags(a0)
                or.b    d0,render_flags(a0)
                rts

; =============== S U B R O U T I N E =======================================

AdvanceLBZFinalBoss1CannonTurnCycle:
                moveq   #0,d0
                move.b  $39(a0),d0
                subq.w  #1,$2E(a0)
                bmi.s   LBZBoss1SK_CannonTurnFromRootFlip
                add.w   d0,d0
                bra.w   LBZBoss1SK_CannonApplySectionOffset
; ---------------------------------------------------------------------------

LBZBoss1SK_CannonTurnFromRootFlip:
                movea.w $44(a0),a1
                btst    #0,render_flags(a1)
                sne     d2
                beq.s   LBZBoss1SK_CannonStepAndWrapPhase
                subq.b  #1,d0
                bpl.s   LBZBoss1SK_CannonStorePhaseAndDecodeFlip
                moveq   #$B,d0
                bra.w   LBZBoss1SK_CannonStorePhaseAndDecodeFlip
; ---------------------------------------------------------------------------

LBZBoss1SK_CannonStepAndWrapPhase:
                addq.b  #1,d0
                cmpi.b  #$C,d0
                blo.s   LBZBoss1SK_CannonStorePhaseAndDecodeFlip
                moveq   #0,d0

LBZBoss1SK_CannonStorePhaseAndDecodeFlip:
                move.b  d0,$39(a0)
                lea     LBZBoss1SK_CannonFrameFlipBytes(pc),a2
                move.b  (a2,d0.w),d1
                bset    #0,render_flags(a0)
                bclr    #7,d1
                bne.s   LBZBoss1SK_CannonCheckChargeWindow
                bclr    #0,render_flags(a0)
                not.b   d2

; Open the firing window for cannon frame 4. Spawn a charge only when the mode permits
LBZBoss1SK_CannonCheckChargeWindow:
                bclr    #3,$38(a1)
                cmpi.b  #4,d1
                bne.s   LBZBoss1SK_CannonLoadFrameAndWait
                bset    #3,$38(a1)
                tst.b   d2
                beq.s   LBZBoss1SK_CannonLoadFrameAndWait
                movem.l d0-d1,-(sp)
                lea     LBZBoss1SK_CannonChargeChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                movem.l (sp)+,d0-d1

LBZBoss1SK_CannonLoadFrameAndWait:
                move.b  d1,mapping_frame(a0)
                add.w   d0,d0
                move.w  LBZBoss1SK_CannonPhaseWaits(pc,d0.w),$2E(a0)

LBZBoss1SK_CannonApplySectionOffset:
                lea     LBZBoss1SK_CannonPositionOffsets(pc,d0.w),a1
                movea.w parent3(a0),a2
                move.b  (a1)+,d1
                ext.w   d1
                move.w  x_pos(a2),d2
                add.w   d1,d2
                move.w  d2,x_pos(a0)
                move.b  (a1)+,d1
                ext.w   d1
                move.w  y_pos(a2),d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                rts
; End of function AdvanceLBZFinalBoss1CannonTurnCycle

; ---------------------------------------------------------------------------
LBZBoss1SK_CannonFrameFlipBytes:
                dc.b    3|$80
                dc.b    4|$80
                dc.b    5|$80
                dc.b    6|$80
                dc.b    7|$80
                dc.b    8|$80
                dc.b    7
                dc.b    6
                dc.b    5
                dc.b    4
                dc.b    3
                dc.b    $2D
                even
LBZBoss1SK_CannonPhaseWaits:
                dc.w    7
                dc.w    $5F
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    $5F
                dc.w    7
                dc.w    $27
LBZBoss1SK_CannonPositionOffsets:
                dc.b    $27,  -8
                dc.b    $24,  -8
                dc.b    $24,  -8
                dc.b    $14,  -8
                dc.b    $C,  -8
                dc.b    0,  -8
                dc.b    -$C,  -8
                dc.b    -$14,  -8
                dc.b    -$24,  -8
                dc.b    -$24,  -8
                dc.b    -$27,  -8

; =============== S U B R O U T I N E =======================================

RandomizeLBZFinalBoss1LaserTrailOffset:
                jsr     (Random_Number).l
                swap    d0
                andi.b  #7,d0
                addi.b  #$18,d0
                move.b  d0,child_dx(a1)
                rts
; End of function RandomizeLBZFinalBoss1LaserTrailOffset

; =============== S U B R O U T I N E =======================================

; A hit freezes and flashes the root and speeds its vertical movement. Request body-section loss at five and one HP
LBZBoss1_HandleHitOrDefeat:
                tst.b   collision_flags(a0)
                bne.w   LBZBoss1SK_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.w   LBZBoss1SK_BeginScoredDefeatHandoff
                tst.b   $20(a0)
                bne.s   LBZBoss1SK_HitChooseFlashRow
                move.b  routine(a0),$3A(a0)
                move.b  #6,routine(a0)
                move.b  #$20,$20(a0)
                bset    #6,status(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                move.w  y_vel(a0),d0
                asl.w   #1,d0
                cmpi.w  #-$800,d0
                blt.s   LBZBoss1SK_HitCheckSectionThresholds
                cmpi.w  #$800,d0
                bgt.s   LBZBoss1SK_HitCheckSectionThresholds
                move.w  d0,y_vel(a0)

; Drop a section at five and one remaining hit. One remaining hit also sets root bit 3
LBZBoss1SK_HitCheckSectionThresholds:
                cmpi.b  #5,collision_property(a0)
                beq.s   LBZBoss1SK_HitBeginNextSectionDrop
                cmpi.b  #1,collision_property(a0)
                bne.s   LBZBoss1SK_HitChooseFlashRow
                bset    #3,$38(a0)

LBZBoss1SK_HitBeginNextSectionDrop:
                move.w  $3C(a0),d0
                bset    d0,$38(a0)
                addq.w  #1,$3C(a0)
                move.b  #8,routine(a0)
                move.b  #$F,$40(a0)
                bset    #5,status(a0)
                lea     LBZBoss1SK_HitOverlayChildren(pc),a2
                jsr     (CreateChild1_Normal).l

LBZBoss1SK_HitChooseFlashRow:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   LBZBoss1SK_HitCopyColorsAndTick
                addi.w  #2*2,d0

LBZBoss1SK_HitCopyColorsAndTick:
                bsr.w   CopyLBZFinalBoss1TwoColorPalette
                subq.b  #1,$20(a0)
                bne.s   LBZBoss1SK_HitUpdateReturn
                move.b  $3A(a0),routine(a0)
                move.w  #$EEE,(Normal_palette_line_2+$2).w
                move.b  $25(a0),collision_flags(a0)
                bclr    #6,status(a0)

LBZBoss1SK_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_BeginScoredDefeatHandoff:
                jsr     (BossDefeated).l
                move.b  #5,mapping_frame(a0)
                bset    #6,status(a0)
                bset    #7,status(a0)
                clr.b   collision_flags(a0)
                move.w  $3C(a0),d0
                bset    d0,$38(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                move.b  #4,subtype(a1)
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   LBZBoss1SK_BeginAlternateExit
                move.l  #LBZBoss1SK_EndingDescendToCameraY,(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_BeginAlternateExit:
                move.l  #LBZBoss1SK_KnucklesRiseToHandoffHeight,(a0)
                rts
; End of function LBZBoss1_HandleHitOrDefeat

; =============== S U B R O U T I N E =======================================

CopyLBZFinalBoss1TwoColorPalette:
                lea     LBZBoss1SK_HitPaletteDestinations(pc),a1
                lea     LBZBoss1SK_HitPaletteColorRows(pc,d0.w),a2
                jmp     (CopyWordData_2).l
; End of function CopyLBZFinalBoss1TwoColorPalette

; ---------------------------------------------------------------------------
LBZBoss1SK_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$1C
LBZBoss1SK_HitPaletteColorRows:
                dc.w    $26,   $20
                dc.w    $EEE,  $EEE

; =============== S U B R O U T I N E =======================================

BreakOrSuspendLBZFinalBoss1BodySection:
                movea.w parent3(a0),a1
                move.w  $3C(a0),d0
                btst    d0,$38(a1)
                beq.s   LBZBoss1SK_SectionCheckHitSuspension
                move.l  #LBZBoss1SK_SectionDebrisFourFrames,$3E(a0)
                bset    #7,status(a0)
                lea     (LBZBoss1SK_BreakupFourDebrisChildren).l,a2
                cmpi.w  #2,d0
                bne.s   LBZBoss1SK_BreakSectionAndTryExplosion
                move.l  #LBZBoss1SK_SectionDebrisSixFrames,$3E(a0)
                lea     (LBZBoss1SK_BreakupSixDebrisChildren).l,a2

LBZBoss1SK_BreakSectionAndTryExplosion:
                move.w  #$10,$2E(a0)
                move.l  #LBZBoss1SK_DeleteBrokenSection,(a0)
                jsr     (CreateChild1_Normal).l
                lea     (Child6_CreateBossExplosion).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LBZBoss1SK_SectionCheckHitSuspension:
                btst    #6,status(a1)
                beq.s   LBZBoss1SK_SectionUnbrokenReturn
                move.l  #LBZBoss1SK_SectionWaitHitAndAdjust,(a0)

LBZBoss1SK_SectionUnbrokenReturn:
                rts
; End of function BreakOrSuspendLBZFinalBoss1BodySection

; =============== S U B R O U T I N E =======================================

; Choose the frame from the parent's selected row and velocity from the fragment subtype
LBZBoss1Debris_InitFrameAndVel:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d1
                movea.w parent3(a0),a1
                movea.l $3E(a1),a1
                move.b  (a1,d1.w),mapping_frame(a0)
                add.w   d0,d0
                lea     LBZBoss1SK_SectionDebrisVelocities(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; End of function LBZBoss1Debris_InitFrameAndVel

; ---------------------------------------------------------------------------
LBZBoss1SK_SectionDebrisVelocities:
                dc.w    -$100, -$200
                dc.w    $100, -$200
                dc.w    -$200, -$100
                dc.w    $200, -$100
                dc.w    -$300, -$300
                dc.w    $300, -$300
LBZBoss1SK_SectionDebrisFourFrames:
                dc.b    $23
                dc.b    $25
                dc.b    $24
                dc.b    $26
LBZBoss1SK_SectionDebrisSixFrames:
                dc.b    $27
                dc.b    $29
                dc.b    $28
                dc.b    $2A
                dc.b    $2B
                dc.b    $2C
                even
