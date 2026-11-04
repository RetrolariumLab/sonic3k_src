; Owner: objects/bosses/aiz/s3
; Responsibility: Angel Island miniboss lifecycle, attack states, coordinated child actors and private object or animation records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZMiniboss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMiniboss_Index(pc,d0.w),d1
                jsr     AIZMiniboss_Index(pc,d1.w)
                bra.w   AIZMiniS3_CheckHitFlashOrDefeat
; ---------------------------------------------------------------------------
AIZMiniboss_Index:
                dc.w    AIZMiniS3_InitFightBoss-AIZMiniboss_Index
                dc.w    AIZMiniS3_WaitForFightCamera-AIZMiniboss_Index
                dc.w    AIZMiniS3_TickCallbackWait-AIZMiniboss_Index
                dc.w    AIZMiniS3_FightDescendAndDraw-AIZMiniboss_Index
                dc.w    AIZMiniS3_SwingMoveAndDraw-AIZMiniboss_Index
                dc.w    AIZMiniS3_CheckFlameSwingEnd-AIZMiniboss_Index
                dc.w    AIZMiniS3_TickStationaryWaitAndDraw-AIZMiniboss_Index
                dc.w    AIZMiniS3_TickSweep-AIZMiniboss_Index
; ---------------------------------------------------------------------------

AIZMiniS3_InitFightBoss:
                lea     ObjDat_AIZMiniboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #6,collision_property(a0)
                move.b  #1,(Boss_flag).w
                moveq   #PLCID_5A,d0
                jsr     (Load_PLC).l
                lea     Pal_AIZMiniboss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

AIZMiniS3_WaitForFightCamera:
                move.w  (Camera_X_pos).w,d0
                move.w  #$10E0,d5
                cmp.w   d5,d0
                bhs.s   AIZMiniS3_LockFightCamera
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_LockFightCamera:
                move.l  #AIZMiniS3_SpawnFightBodyAndDescend,$34(a0)
                bra.w   AIZMiniS3_LockCameraAndFadeMusic
; ---------------------------------------------------------------------------

AIZMiniS3_SpawnFightBodyAndDescend:
                move.l  #AIZMiniS3_BeginFightSwingWait,$34(a0)
                move.b  #6,routine(a0)
                bsr.w   StartAIZMinibossDescentAndMusic
                lea     AIZMiniS3_BodyAndTrimChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     AIZMiniS3_FightBarrelChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZMiniS3_FightDescendAndDraw:
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniS3_BeginFightSwingWait:
                move.l  #AIZMiniS3_DelayAndCheckBarrelRequest,$34(a0)
                move.w  #20,$2E(a0)
                bra.w   AIZMiniS3_BeginVerticalSwing
; ---------------------------------------------------------------------------

AIZMiniS3_DelayAndCheckBarrelRequest:
                move.l  #AIZMiniS3_BeginFlameSwing,$34(a0)
                move.w  #30,$2E(a0)
                tst.b   (BossSceneResetBaseAndRetainedGate+1).w
                beq.w   AIZMiniS3_SharedReturn
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_BeginFlameSwing:
                move.b  #$A,routine(a0)
                move.b  #8,$39(a0)
                moveq   #signextendB(sfx_FlamethrowerQuiet),d0
                jsr     (Play_SFX).l
                lea     Child1_AIZ_MinibossFlames(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

; Leave the counted swing only after its counter expires and the motion is upward
AIZMiniS3_CheckFlameSwingEnd:
                jsr     (Swing_UpAndDown_Count).l
                beq.s   AIZMiniS3_MoveAndDrawAfterSwing
                tst.w   d1
                bmi.s   AIZMiniS3_BeginAlternatingYTransfer

AIZMiniS3_MoveAndDrawAfterSwing:
                jsr     (MoveSprite2).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniS3_BeginAlternatingYTransfer:
                move.b  #6,routine(a0)
                move.w  #$5F,$2E(a0)
                move.l  #AIZMiniS3_SetSweepCallbackAndPause,$34(a0)
                move.w  #-$100,d0
                bchg    #2,$38(a0)
                beq.s   AIZMiniS3_StoreTransferYSpeedAndDraw
                neg.w   d0
                move.l  #AIZMiniS3_BeginFightSwingWait,$34(a0)

AIZMiniS3_StoreTransferYSpeedAndDraw:
                move.w  d0,y_vel(a0)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniS3_TickStationaryWaitAndDraw:
                jsr     (Obj_Wait).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniS3_SetSweepCallbackAndPause:
                move.l  #AIZMiniS3_BeginAlternatingXSweep,$34(a0)

AIZMiniS3_StopMotionAndBeginPause:
                move.b  #$C,routine(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$10,$2E(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_BeginAlternatingXSweep:
                move.b  #$E,routine(a0)
                move.b  #4,$39(a0)
                move.l  #AIZMiniS3_TurnAtFirstSweepEnd,$34(a0)
                move.w  #$100,d0
                bchg    #3,$38(a0)
                bne.s   AIZMiniS3_StoreSweepSpeedAndResetSwing
                neg.w   d0

AIZMiniS3_StoreSweepSpeedAndResetSwing:
                move.w  d0,x_vel(a0)
                bra.w   Swing_Setup1
; ---------------------------------------------------------------------------

AIZMiniS3_TickSweep:
                jsr     (Swing_UpAndDown_Count).l
                bne.s   AIZMiniS3_RunSweepCallbackAndDraw
                jsr     (MoveSprite2).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniS3_RunSweepCallbackAndDraw:
                movea.l $34(a0),a1
                jsr     (a1)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniS3_TurnAtFirstSweepEnd:
                move.b  #4,$39(a0)
                move.l  #AIZMiniS3_ArmNextYTransfer,$34(a0)
                bchg    #0,render_flags(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

AIZMiniS3_ArmNextYTransfer:
                move.l  #AIZMiniS3_BeginAlternatingYTransfer,$34(a0)
                bra.w   AIZMiniS3_StopMotionAndBeginPause
; ---------------------------------------------------------------------------

AIZMiniS3_StartSignControlAndDebris:
                jsr     (Obj_EndSignControl).l
                lea     AIZMiniS3_DefeatDebrisChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZMiniS3_FightBarrelFollowDispatch:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMinibossS3_Barrel_StateOffsets(pc,d0.w),d1
                jsr     AIZMinibossS3_Barrel_StateOffsets(pc,d1.w)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
AIZMinibossS3_Barrel_StateOffsets:
                dc.w    AIZMiniS3_InitBarrelAttributes-AIZMinibossS3_Barrel_StateOffsets
                dc.w    AIZMiniS3_FightBarrelWaitRequest-AIZMinibossS3_Barrel_StateOffsets
                dc.w    AIZMiniS3_TickCallbackWait-AIZMinibossS3_Barrel_StateOffsets
                dc.w    AIZMiniS3_BarrelAnimatePairs-AIZMinibossS3_Barrel_StateOffsets
                dc.w    AIZMiniS3_BarrelAnimatePairs-AIZMinibossS3_Barrel_StateOffsets
                dc.w    AIZMiniS3_SharedReturn-AIZMinibossS3_Barrel_StateOffsets
; ---------------------------------------------------------------------------

AIZMiniS3_FightBarrelWaitRequest:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   AIZMiniS3_FightBarrelSetStagger
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_FightBarrelSetStagger:
                move.b  #4,routine(a0)
                move.l  #AIZMiniS3_FightBarrelBeginOpening,$34(a0)
                bra.w   AIZMiniS3_LoadBarrelStagger
; ---------------------------------------------------------------------------

AIZMiniS3_FightBarrelBeginOpening:
                move.l  #AIZMiniS3_FightBarrelFireAndClose,$34(a0)
                bra.w   AIZMiniS3_BarrelBeginOpening
; ---------------------------------------------------------------------------

AIZMiniS3_FightBarrelFireAndClose:
                move.b  #8,routine(a0)
                move.l  #AIZMiniS3_FightBarrelResetRequest,$34(a0)
                move.l  #AIZMiniS3_BarrelCloseAnimation,$30(a0)
                lea     AIZMiniS3_BurstAndFloorMissileChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZMiniS3_FightBarrelResetRequest:
                move.b  #2,routine(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_FloorMissileDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMinibossS3_Missile_StateOffsets(pc,d0.w),d1
                jsr     AIZMinibossS3_Missile_StateOffsets(pc,d1.w)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
AIZMinibossS3_Missile_StateOffsets:
                dc.w    AIZMiniS3_InitFloorMissileRise-AIZMinibossS3_Missile_StateOffsets
                dc.w    AIZMiniS3_FloorMissileRiseAndWait-AIZMinibossS3_Missile_StateOffsets
                dc.w    AIZMiniS3_TickCallbackWait-AIZMinibossS3_Missile_StateOffsets
                dc.w    AIZMiniS3_FloorMissileWaitToDescend-AIZMinibossS3_Missile_StateOffsets
                dc.w    AIZMiniS3_FloorMissileDescendAndProbe-AIZMinibossS3_Missile_StateOffsets
; ---------------------------------------------------------------------------

; A missile from an arrival barrel rises without collision
AIZMiniS3_InitFloorMissileRise:
                bsr.w   InitializeAIZMinibossRisingMissile
                movea.w parent3(a0),a1
                cmpi.l  #AIZMiniS3_ArrivalBarrelFollowDispatch,(a1)
                bne.s   AIZMiniS3_FloorMissileSetRiseCallback
                clr.b   collision_flags(a0)

AIZMiniS3_FloorMissileSetRiseCallback:
                move.l  #AIZMiniS3_FloorMissilePauseAtApex,$34(a0)
                move.b  #8,y_radius(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_FloorMissileRiseAndWait:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZMiniS3_FloorMissilePauseAtApex:
                move.b  #4,routine(a0)
                move.w  #8,$2E(a0)
                move.l  #AIZMiniS3_FloorMissileMoveToDescentLane,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_FloorMissileMoveToDescentLane:
                move.b  #6,routine(a0)
                move.l  #AIZMiniS3_FloorMissileBeginDescent,$34(a0)
                bset    #1,render_flags(a0)
                bsr.w   AIZMiniMissile_InitDescent
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_FloorMissileWaitToDescend:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZMiniS3_FloorMissileBeginDescent:
                move.b  #8,routine(a0)
                move.w  #$80,priority(a0)
                move.l  #AIZMiniS3_FloorMissileSpawnImpact,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_FloorMissileDescendAndProbe:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

AIZMiniS3_FloorMissileSpawnImpact:
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l
                lea     AIZMiniS3_MissileImpactChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniS3_ImpactExplosionDispatch:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMiniS3_ImpactExplosionStateOffsets(pc,d0.w),d1
                jmp     AIZMiniS3_ImpactExplosionStateOffsets(pc,d1.w)
; ---------------------------------------------------------------------------
AIZMiniS3_ImpactExplosionStateOffsets:
                dc.w    AIZMiniS3_InitImpactExplosion-AIZMiniS3_ImpactExplosionStateOffsets
                dc.w    AIZMiniS3_TickCallbackWait-AIZMiniS3_ImpactExplosionStateOffsets
                dc.w    AIZMiniS3_ImpactAnimateAndCheckTouch-AIZMiniS3_ImpactExplosionStateOffsets
; ---------------------------------------------------------------------------

AIZMiniS3_InitImpactExplosion:
                lea     AIZMiniS3_ImpactExplosionAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                movea.w parent3(a0),a1
                tst.b   collision_flags(a1)
                bne.s   AIZMiniS3_ImpactSetAnimAndStagger
                clr.b   collision_flags(a0)

AIZMiniS3_ImpactSetAnimAndStagger:
                move.l  #AniRaw_BossExplosion,$30(a0)
                move.l  #AIZMiniS3_ImpactBeginVisibleAnimation,$34(a0)
                moveq   #$C,d1
                bra.w   AIZMiniS3_SetFlameStaggerFromSubtype
; ---------------------------------------------------------------------------

AIZMiniS3_ImpactBeginVisibleAnimation:
                move.b  #4,routine(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_ImpactAnimateAndCheckTouch:
                jsr     (Animate_RawMultiDelay).l
                tst.b   collision_flags(a0)
                beq.s   AIZMiniS3_ImpactDrawWithoutTouch
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniS3_ImpactDrawWithoutTouch:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniS3_InitSmallFlyby:
                lea     AIZMinibossS3_SmallFlyby_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #AIZMiniS3_FlybyTickHiddenDelay,(a0)
                move.l  #AIZMiniS3_FlybyBeginHorizontalMove,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  (Camera_X_pos).w,d1
                move.w  AIZMiniS3_FlybyCameraXOffsets(pc,d0.w),d2
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                move.w  (Camera_Y_pos).w,d1
                move.w  AIZMiniS3_FlybyWorldYPositions(pc,d0.w),d2
                move.w  d2,y_pos(a0)
                move.w  AIZMiniS3_FlybySpeedAndDelay(pc,d0.w),x_vel(a0)
                move.w  AIZMiniS3_FlybySpeedAndDelay(pc,d0.w),$2E(a0)
                lsr.w   #1,d0
                move.b  AIZMiniS3_FlybyMappingFrames(pc,d0.w),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
AIZMiniS3_FlybyCameraXOffsets:
                dc.w    -$20
                dc.w    -$68
                dc.w    -$10
                dc.w    -$58
                dc.w    -8
                dc.w    -$50
AIZMiniS3_FlybyWorldYPositions:
                dc.w    $310
                dc.w    $310
                dc.w    $31C
                dc.w    $31C
                dc.w    $328
                dc.w    $328
AIZMiniS3_FlybySpeedAndDelay:
                dc.w    $200
                dc.w    $200
                dc.w    $180
                dc.w    $180
                dc.w    $100
                dc.w    $100
                dc.w    0
                dc.w    0
                dc.w    0
                dc.w    0
                dc.w    0
                dc.w    0
AIZMiniS3_FlybyMappingFrames:
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    1
                dc.b    2
                dc.b    2
                even
; ---------------------------------------------------------------------------

AIZMiniS3_FlybyTickHiddenDelay:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZMiniS3_FlybyBeginHorizontalMove:
                move.l  #AIZMiniS3_FlybyMoveUntilDeparture,(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_FlybyMoveUntilDeparture:
                jsr     (MoveSprite2).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

AIZMiniS3_InitDefeatDebris:
                lea     AIZMiniS3_DebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$E,d0
                move.b  d0,mapping_frame(a0)
                moveq   #8,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

AIZMiniS3_LoadBarrelStagger:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  AIZMinibossS3_Barrel_OpeningWaitWords(pc,d0.w),$2E(a0)
                rts
; ---------------------------------------------------------------------------
AIZMinibossS3_Barrel_OpeningWaitWords:
                dc.w    0
                dc.w    $10
                dc.w    $20

; =============== S U B R O U T I N E =======================================

; Use the launcher's subtype for the wait and its phase and facing for the camera-relative lane
AIZMiniMissile_InitDescent:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  subtype(a1),d0
                move.w  AIZMiniS3_DescentWaitByBarrel(pc,d0.w),$2E(a0)

AIZMiniS3_AdvanceDescentLanePattern:
                lsr.w   #1,d0
                move.b  $39(a1),d1
                addq.b  #4,d1
                move.b  d1,$39(a1)
                andi.w  #$C,d1
                add.w   d1,d0
                lea     AIZMiniS3_DescentColumnsUnflipped(pc),a2
                lea     AIZMiniS3_DescentXOffsetsUnflipped(pc),a3
                btst    #0,render_flags(a1)
                beq.s   AIZMiniS3_ApplyDescentLaneAndSpeed
                lea     AIZMiniS3_DescentColumnsFlipped(pc),a2
                lea     AIZMiniS3_DescentXOffsetsFlipped(pc),a3

AIZMiniS3_ApplyDescentLaneAndSpeed:
                move.b  (a2,d0.w),d0
                add.w   d0,d0
                move.w  (a3,d0.w),d0
                add.w   (Camera_X_pos).w,d0
                move.w  d0,x_pos(a0)
                move.w  #$400,y_vel(a0)
                rts
; End of function AIZMiniMissile_InitDescent

; ---------------------------------------------------------------------------
AIZMiniS3_DescentWaitByBarrel:
                dc.w    0
                dc.w    $20
                dc.w    $40
AIZMiniS3_DescentColumnsUnflipped:
                dc.b    2
                dc.b    3
                dc.b    4
                dc.b    0
                dc.b    0
                dc.b    2
                dc.b    4
                dc.b    0
                dc.b    1
                dc.b    3
                dc.b    4
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    4
                dc.b    0
AIZMiniS3_DescentColumnsFlipped:
                dc.b    3
                dc.b    2
                dc.b    0
                dc.b    0
                dc.b    4
                dc.b    3
                dc.b    1
                dc.b    0
                dc.b    4
                dc.b    2
                dc.b    0
                dc.b    0
                dc.b    3
                dc.b    2
                dc.b    1
                dc.b    0
                even
AIZMiniS3_DescentXOffsetsUnflipped:
                dc.w    $24
                dc.w    $4C
                dc.w    $74
                dc.w    $9C
                dc.w    $C4
AIZMiniS3_DescentXOffsetsFlipped:
                dc.w    $7C
                dc.w    $A4
                dc.w    $CC
                dc.w    $F4
                dc.w    $11C
; ---------------------------------------------------------------------------

AIZMiniS3_CheckHitFlashOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   AIZMiniS3_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   AIZMiniS3_BeginDefeatWaitAndExplosion
                tst.b   $20(a0)
                bne.s   AIZMiniS3_ChooseHitFlashColors
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

AIZMiniS3_ChooseHitFlashColors:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   AIZMiniS3_CopyFlashColorsAndTick
                addq.w  #2*4,d0

AIZMiniS3_CopyFlashColorsAndTick:
                lea     AIZMiniS3_FlashPaletteDestinations(pc),a1
                lea     AIZMiniS3_FlashPaletteColorRows(pc,d0.w),a2
                jsr     (CopyWordData_4).l
                subq.b  #1,$20(a0)
                bne.s   AIZMiniS3_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

AIZMiniS3_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

AIZMiniS3_BeginDefeatWaitAndExplosion:
                move.l  #Wait_Draw,(a0)
                move.l  #AIZMiniS3_StartSignControlAndDebris,$34(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     (BossDefeated_StopTimer).l
; ---------------------------------------------------------------------------
AIZMiniS3_FlashPaletteDestinations:
                dc.w    Normal_palette_line_2+$0E, Normal_palette_line_2+$14, Normal_palette_line_2+$16, Normal_palette_line_2+$1C
AIZMiniS3_FlashPaletteColorRows:
                dc.w    $644,  $240,   $20,  $644
                dc.w    $888,  $AAA,  $EEE,  $AAA
ObjDat_AIZMiniboss:
                dc.l    Map_AIZMiniboss
                dc.w    make_art_tile(ArtTile_AIZMiniboss,1,1)
                dc.w    $200
                dc.b    $20, $20,   0,  $F
AIZMiniS3_RotorAttributes:
                dc.w    make_art_tile(ArtTile_AIZMiniboss,0,1)
                dc.w    $180
                dc.b    $28, $10,   2, $9C
AIZMiniS3_TrimAttributes:
                dc.w    make_art_tile(ArtTile_AIZMiniboss,1,1)
                dc.w    $200
                dc.b    4,   8,   6,   0
AIZMiniS3_BarrelAttributes:
                dc.w    make_art_tile(ArtTile_AIZMiniboss,1,1)
                dc.w    $280
                dc.b    8,   8,   3,   0
AIZMiniS3_BurstAttributes:
                dc.w    make_art_tile(ArtTile_AIZMiniboss,0,0)
                dc.w    $200
                dc.b    8,   8,   7,   0
AIZMiniS3_MissileAttributes:
                dc.w    make_art_tile(ArtTile_AIZMiniboss,0,0)
                dc.w    $280
                dc.b    8, $10,  $C, $98
AIZMiniS3_ImpactExplosionAttributes:
                dc.l    Map_BossExplosion
                dc.w    make_art_tile(ArtTile_BossExplosion2,0,0)
                dc.w    $80
                dc.b    $C,  $C,   0, $97
ObjDat_AIZMiniboss_Flame:
                dc.l    Map_AIZMinibossFlame
                dc.w    make_art_tile(ArtTile_AIZBossFire,0,1)
                dc.w    $100
                dc.b    $10, $10,   0, $8B
AIZMinibossS3_SmallFlyby_FullAttributes:
                dc.l    Map_AIZMinibossSmall
                dc.w    make_art_tile(ArtTile_AIZMinibossSmall,1,0)
                dc.w    $380
                dc.b    $10, $10,   0,   0
AIZMiniS3_DebrisAttributes:
                dc.w    $200
                dc.b    $10, $14,   0,   0
AIZMiniS3_BodyAndTrimChildren:
                dc.w    2-1
                dc.l    AIZMiniS3_InitArrivalRotor
                dc.b    0, $20
                dc.l    AIZMiniS3_InitArrivalTrim
                dc.b    -$24,   8
AIZMiniS3_FlybyChildren:
                dc.w    6-1
                dc.l    AIZMiniS3_InitSmallFlyby
                dc.b    0,   0
AIZMiniS3_ArrivalBarrelChildren:
                dc.w    3-1
                dc.l    AIZMiniS3_ArrivalBarrelFollowDispatch
                dc.b    0,-$20
                dc.l    AIZMiniS3_ArrivalBarrelFollowDispatch
                dc.b    9,-$1C
                dc.l    AIZMiniS3_ArrivalBarrelFollowDispatch
                dc.b    $12,-$18
AIZMiniS3_FightBarrelChildren:
                dc.w    3-1
                dc.l    AIZMiniS3_FightBarrelFollowDispatch
                dc.b    0,-$20
                dc.l    AIZMiniS3_FightBarrelFollowDispatch
                dc.b    9,-$1C
                dc.l    AIZMiniS3_FightBarrelFollowDispatch
                dc.b    $12,-$18
AIZMiniS3_BurstAndTimedMissileChildren:
                dc.w    2-1
                dc.l    AIZMiniS3_BarrelBurstFollowAndDraw
                dc.b    0,   4
                dc.l    AIZMiniS3_TimedMissileDispatch
                dc.b    0,   4
AIZMiniS3_BurstAndFloorMissileChildren:
                dc.w    2-1
                dc.l    AIZMiniS3_BarrelBurstFollowAndDraw
                dc.b    0,   4
                dc.l    AIZMiniS3_FloorMissileDispatchAndDraw
                dc.b    0,   4
Child1_AIZ_MinibossFlames:
                dc.w    4-1
                dc.l    Obj_AIZMiniboss_Flame
                dc.b    -$64,   4
                dc.l    Obj_AIZMiniboss_Flame
                dc.b    -$54,   4
                dc.l    Obj_AIZMiniboss_Flame
                dc.b    -$44,   4
                dc.l    Obj_AIZMiniboss_Flame
                dc.b    -$2C,   3
AIZMiniS3_AdvancingFlameChild:
                dc.w    1-1
                dc.l    AIZMiniS3_FlameTrailDispatchAndDraw
                dc.b    0,   0
AIZMiniS3_MissileImpactChildren:
                dc.w    7-1
                dc.l    AIZMiniS3_ImpactExplosionDispatch
                dc.b    0,-$24
                dc.l    AIZMiniS3_ImpactExplosionDispatch
                dc.b    8,-$1C
                dc.l    AIZMiniS3_ImpactExplosionDispatch
                dc.b    -8,-$1C
                dc.l    AIZMiniS3_ImpactExplosionDispatch
                dc.b    4,-$14
                dc.l    AIZMiniS3_ImpactExplosionDispatch
                dc.b    -4,-$14
                dc.l    AIZMiniS3_ImpactExplosionDispatch
                dc.b    4,  -4
                dc.l    AIZMiniS3_ImpactExplosionDispatch
                dc.b    -4,  -4
AIZMiniS3_DepartureBlastChild:
                dc.w    1-1
                dc.l    Obj_BossExplosionSpecial
                dc.b    0,   0
AIZMiniS3_DefeatDebrisChildren:
                dc.w    4-1
                dc.l    AIZMiniS3_InitDefeatDebris
                dc.b    -$10,  -8
                dc.l    AIZMiniS3_InitDefeatDebris
                dc.b    $C,-$10
                dc.l    AIZMiniS3_InitDefeatDebris
                dc.b    -$10, $14
                dc.l    AIZMiniS3_InitDefeatDebris
                dc.b    $10,  $C
AIZMiniS3_RotorLoopAnimation:
                dc.b    1,   1,   2, $FC
                dc.b    7,   3,   4,   5, $F4
AIZMiniS3_BarrelOpenAnimation:
                dc.b    3,   5
                dc.b    4,   5
                dc.b    5, $17
                dc.b    $F4
AIZMiniS3_BarrelCloseAnimation:
                dc.b    5, $17
                dc.b    5, $17
                dc.b    4,   5
                dc.b    3,   5
                dc.b    $F4
AIZMiniS3_BurstAnimation:
                dc.b    7,   1
                dc.b    7,   1
                dc.b    8,   1
                dc.b    9,   3
                dc.b    $A,   3
                dc.b    $B,   3
                dc.b    $F4
AIZMiniS3_MissileLoopAnimation:
                dc.b    1,  $C,  $D, $FC
                dc.b    0,   0
                dc.b    0,   0
                dc.b    1,   1
                dc.b    2,   2
                dc.b    3,   3
                dc.b    4,   4
                dc.b    5,   4
                dc.b    $F4
AIZMinibossS3_Flame_HoldFrameDelayStream:
                dc.b    0,   1
                dc.b    0,   1
                dc.b    $F4
AIZMiniS3_FlameExplosionAnimation:
                dc.b    2,   1
                dc.b    2,   1
                dc.b    3,   2
                dc.b    4,   4
                dc.b    5,   1
                dc.b    $F4
AIZMiniS3_AdvancingFlameAnimation:
                dc.b    0,   1
                dc.b    0,   1
                dc.b    1,   2
                dc.b    2,   2
                dc.b    3,   4
                dc.b    4,   4
                dc.b    $F4
                even
Pal_AIZMiniboss:
                binclude "data/Levels/AIZ/Palettes/Miniboss.bin"
                even
