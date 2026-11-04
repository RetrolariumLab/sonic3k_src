; Owner: objects/bosses/aiz/sk
; Responsibility: Angel Island miniboss lifecycle, attack states, coordinated child actors and private object or animation records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZMiniboss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMiniboss_Index(pc,d0.w),d1
                jsr     AIZMiniboss_Index(pc,d1.w)
                bra.w   AIZMiniSK_CheckHitFlashOrDefeat
; ---------------------------------------------------------------------------
AIZMiniboss_Index:
                dc.w    AIZMiniSK_InitFightBoss-AIZMiniboss_Index
                dc.w    AIZMiniSK_ChooseFightCameraByCharacter-AIZMiniboss_Index
                dc.w    AIZMiniSK_TickCallbackWait-AIZMiniboss_Index
                dc.w    AIZMiniSK_FightDescendAndDraw-AIZMiniboss_Index
                dc.w    AIZMiniSK_SwingMoveAndDraw-AIZMiniboss_Index
                dc.w    AIZMiniSK_CheckFlameSwingEnd-AIZMiniboss_Index
                dc.w    AIZMiniSK_TickStationaryWaitAndDraw-AIZMiniboss_Index
                dc.w    AIZMiniSK_TickSweep-AIZMiniboss_Index
; ---------------------------------------------------------------------------

AIZMiniSK_InitFightBoss:
                lea     ObjDat_AIZMiniboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #6,collision_property(a0)
                move.b  #1,(Boss_flag).w
                moveq   #PLCID_5A,d0
                jsr     (Load_PLC).l
                lea     Pal_AIZMiniboss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

AIZMiniSK_ChooseFightCameraByCharacter:
                move.w  (Camera_X_pos).w,d0
                move.w  #$10E0,d5
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   AIZMiniSK_WaitForFightCamera
                move.w  #$10C0,d5

AIZMiniSK_WaitForFightCamera:
                cmp.w   d5,d0
                bhs.s   AIZMiniSK_LockFightCamera
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_LockFightCamera:
                move.l  #AIZMiniSK_SpawnFightBodyAndDescend,$34(a0)
                bra.w   AIZMiniSK_LockCameraAndFadeMusic
; ---------------------------------------------------------------------------

AIZMiniSK_SpawnFightBodyAndDescend:
                move.l  #AIZMiniSK_BeginFightSwingWait,$34(a0)
                move.b  #6,routine(a0)
                bsr.w   StartAIZMinibossDescentAndMusic
                lea     AIZMiniSK_BodyAndTrimChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     AIZMiniSK_FightBarrelChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZMiniSK_FightDescendAndDraw:
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniSK_BeginFightSwingWait:
                move.l  #AIZMiniSK_DelayAndArmKnucklesBarrels,$34(a0)
                move.w  #20,$2E(a0)
                bra.w   AIZMiniSK_BeginVerticalSwing
; ---------------------------------------------------------------------------

AIZMiniSK_DelayAndArmKnucklesBarrels:
                move.l  #AIZMiniSK_BeginFlameSwing,$34(a0)
                move.w  #30,$2E(a0)
                cmpi.b  #2,(Player_1+character_id).w
                bne.w   AIZMiniSK_SharedReturn
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_BeginFlameSwing:
                move.b  #$A,routine(a0)
                move.b  #8,$39(a0)
                moveq   #signextendB(sfx_FlamethrowerQuiet),d0
                jsr     (Play_SFX).l
                lea     Child1_AIZ_MinibossFlames(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

; Leave the counted swing only after its counter expires and the motion is upward
AIZMiniSK_CheckFlameSwingEnd:
                jsr     (Swing_UpAndDown_Count).l
                beq.s   AIZMiniSK_MoveAndDrawAfterSwing
                tst.w   d1
                bmi.s   AIZMiniSK_BeginAlternatingYTransfer

AIZMiniSK_MoveAndDrawAfterSwing:
                jsr     (MoveSprite2).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniSK_BeginAlternatingYTransfer:
                move.b  #6,routine(a0)
                move.w  #$5F,$2E(a0)
                move.l  #AIZMiniSK_SetSweepCallbackAndPause,$34(a0)
                move.w  #-$100,d0
                bchg    #2,$38(a0)
                beq.s   AIZMiniSK_StoreTransferYSpeedAndDraw
                neg.w   d0
                move.l  #AIZMiniSK_BeginFightSwingWait,$34(a0)

AIZMiniSK_StoreTransferYSpeedAndDraw:
                move.w  d0,y_vel(a0)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniSK_TickStationaryWaitAndDraw:
                jsr     (Obj_Wait).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniSK_SetSweepCallbackAndPause:
                move.l  #AIZMiniSK_BeginAlternatingXSweep,$34(a0)

AIZMiniSK_StopMotionAndBeginPause:
                move.b  #$C,routine(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$10,$2E(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_BeginAlternatingXSweep:
                move.b  #$E,routine(a0)
                move.b  #4,$39(a0)
                move.l  #AIZMiniSK_TurnAtFirstSweepEnd,$34(a0)
                move.w  #$100,d0
                bchg    #3,$38(a0)
                bne.s   AIZMiniSK_StoreSweepSpeedAndResetSwing
                neg.w   d0

AIZMiniSK_StoreSweepSpeedAndResetSwing:
                move.w  d0,x_vel(a0)
                bra.w   Swing_Setup1
; ---------------------------------------------------------------------------

AIZMiniSK_TickSweep:
                jsr     (Swing_UpAndDown_Count).l
                bne.s   AIZMiniSK_RunSweepCallbackAndDraw
                jsr     (MoveSprite2).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniSK_RunSweepCallbackAndDraw:
                movea.l $34(a0),a1
                jsr     (a1)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniSK_TurnAtFirstSweepEnd:
                move.b  #4,$39(a0)
                move.l  #AIZMiniSK_ArmNextYTransfer,$34(a0)
                bchg    #0,render_flags(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

AIZMiniSK_ArmNextYTransfer:
                move.l  #AIZMiniSK_BeginAlternatingYTransfer,$34(a0)
                bra.w   AIZMiniSK_StopMotionAndBeginPause
; ---------------------------------------------------------------------------

AIZMiniSK_StartSignControlAndDebris:
                jsr     (Obj_EndSignControl).l
                lea     AIZMiniSK_DefeatDebrisChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZMiniSK_FightBarrelFollowDispatch:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMinibossSK_Barrel_StateOffsets(pc,d0.w),d1
                jsr     AIZMinibossSK_Barrel_StateOffsets(pc,d1.w)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
AIZMinibossSK_Barrel_StateOffsets:
                dc.w    AIZMiniSK_InitBarrelAttributes-AIZMinibossSK_Barrel_StateOffsets
                dc.w    AIZMiniSK_FightBarrelWaitRequest-AIZMinibossSK_Barrel_StateOffsets
                dc.w    AIZMiniSK_TickCallbackWait-AIZMinibossSK_Barrel_StateOffsets
                dc.w    AIZMiniSK_BarrelAnimatePairs-AIZMinibossSK_Barrel_StateOffsets
                dc.w    AIZMiniSK_BarrelAnimatePairs-AIZMinibossSK_Barrel_StateOffsets
                dc.w    AIZMiniSK_SharedReturn-AIZMinibossSK_Barrel_StateOffsets
; ---------------------------------------------------------------------------

AIZMiniSK_FightBarrelWaitRequest:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   AIZMiniSK_FightBarrelSetStagger
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_FightBarrelSetStagger:
                move.b  #4,routine(a0)
                move.l  #AIZMiniSK_FightBarrelBeginOpening,$34(a0)
                bra.w   AIZMiniSK_LoadBarrelStagger
; ---------------------------------------------------------------------------

AIZMiniSK_FightBarrelBeginOpening:
                move.l  #AIZMiniSK_FightBarrelFireAndClose,$34(a0)
                bra.w   AIZMiniSK_BarrelBeginOpening
; ---------------------------------------------------------------------------

AIZMiniSK_FightBarrelFireAndClose:
                move.b  #8,routine(a0)
                move.l  #AIZMiniSK_FightBarrelResetRequest,$34(a0)
                move.l  #AIZMiniSK_BarrelCloseAnimation,$30(a0)
                lea     AIZMiniSK_BurstAndFloorMissileChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZMiniSK_FightBarrelResetRequest:
                move.b  #2,routine(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_FloorMissileDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMinibossSK_Missile_StateOffsets(pc,d0.w),d1
                jsr     AIZMinibossSK_Missile_StateOffsets(pc,d1.w)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                btst    #7,status(a1)
                bne.s   AIZMiniSK_FloorMissileDeleteOnBossDeath
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniSK_FloorMissileDeleteOnBossDeath:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
AIZMinibossSK_Missile_StateOffsets:
                dc.w    AIZMiniSK_InitFloorMissileRise-AIZMinibossSK_Missile_StateOffsets
                dc.w    AIZMiniSK_FloorMissileRiseAndWait-AIZMinibossSK_Missile_StateOffsets
                dc.w    AIZMiniSK_TickCallbackWait-AIZMinibossSK_Missile_StateOffsets
                dc.w    AIZMiniSK_FloorMissileWaitToDescend-AIZMinibossSK_Missile_StateOffsets
                dc.w    AIZMiniSK_FloorMissileDescendAndProbe-AIZMinibossSK_Missile_StateOffsets
; ---------------------------------------------------------------------------

; A missile from an arrival barrel rises without collision
AIZMiniSK_InitFloorMissileRise:
                bsr.w   InitializeAIZMinibossRisingMissile
                movea.w parent3(a0),a1
                cmpi.l  #AIZMiniSK_ArrivalBarrelFollowDispatch,(a1)
                bne.s   AIZMiniSK_FloorMissileSetRiseCallback
                clr.b   collision_flags(a0)

AIZMiniSK_FloorMissileSetRiseCallback:
                move.l  #AIZMiniSK_FloorMissilePauseAtApex,$34(a0)
                move.b  #8,y_radius(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_FloorMissileRiseAndWait:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZMiniSK_FloorMissilePauseAtApex:
                move.b  #4,routine(a0)
                move.w  #8,$2E(a0)
                move.l  #AIZMiniSK_FloorMissileMoveToDescentLane,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_FloorMissileMoveToDescentLane:
                move.b  #6,routine(a0)
                move.l  #AIZMiniSK_FloorMissileBeginDescent,$34(a0)
                bset    #1,render_flags(a0)
                bsr.w   AIZMiniMissile_InitDescent
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_FloorMissileWaitToDescend:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZMiniSK_FloorMissileBeginDescent:
                move.b  #8,routine(a0)
                move.w  #$80,priority(a0)
                move.l  #AIZMiniSK_FloorMissileSpawnImpact,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_FloorMissileDescendAndProbe:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

AIZMiniSK_FloorMissileSpawnImpact:
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l
                lea     AIZMiniSK_MissileImpactChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniSK_ImpactExplosionDispatch:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMiniSK_ImpactExplosionStateOffsets(pc,d0.w),d1
                jmp     AIZMiniSK_ImpactExplosionStateOffsets(pc,d1.w)
; ---------------------------------------------------------------------------
AIZMiniSK_ImpactExplosionStateOffsets:
                dc.w    AIZMiniSK_InitImpactExplosionByZone-AIZMiniSK_ImpactExplosionStateOffsets
                dc.w    AIZMiniSK_ImpactTickHiddenDelay-AIZMiniSK_ImpactExplosionStateOffsets
                dc.w    AIZMiniSK_ImpactAnimateAndDraw-AIZMiniSK_ImpactExplosionStateOffsets
; ---------------------------------------------------------------------------

AIZMiniSK_InitImpactExplosionByZone:
                lea     AIZMiniSK_ImpactExplosionAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                cmpi.b  #0,(Current_zone).w
                beq.s   AIZMiniSK_ImpactInheritCollisionGate
                move.w  #make_art_tile(ArtTile_BossExplosion,0,0),art_tile(a0)

AIZMiniSK_ImpactInheritCollisionGate:
                movea.w parent3(a0),a1
                tst.b   collision_flags(a1)
                bne.s   AIZMiniSK_ImpactSetAnimAndStagger
                clr.b   collision_flags(a0)

AIZMiniSK_ImpactSetAnimAndStagger:
                move.l  #AniRaw_BossExplosion,$30(a0)
                move.l  #AIZMiniSK_ImpactBeginVisibleAnimation,$34(a0)
                moveq   #$C,d1
                bra.w   AIZMiniSK_SetFlameStaggerFromSubtype
; ---------------------------------------------------------------------------

AIZMiniSK_ImpactTickHiddenDelay:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZMiniSK_ImpactBeginVisibleAnimation:
                move.b  #4,routine(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_ImpactAnimateAndDraw:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZMiniSK_InitSmallFlyby:
                lea     AIZMinibossSK_SmallFlyby_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #AIZMiniSK_FlybyTickHiddenDelay,(a0)
                move.l  #AIZMiniSK_FlybyBeginHorizontalMove,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  (Camera_X_pos).w,d1
                move.w  AIZMiniSK_FlybyCameraXOffsets(pc,d0.w),d2
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                move.w  (Camera_Y_pos).w,d1
                move.w  AIZMiniSK_FlybyWorldYPositions(pc,d0.w),d2
                move.w  d2,y_pos(a0)
                move.w  AIZMiniSK_FlybySpeedAndDelay(pc,d0.w),x_vel(a0)
                move.w  AIZMiniSK_FlybySpeedAndDelay(pc,d0.w),$2E(a0)
                lsr.w   #1,d0
                move.b  AIZMiniSK_FlybyMappingFrames(pc,d0.w),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
AIZMiniSK_FlybyCameraXOffsets:
                dc.w    -$20
                dc.w    -$68
                dc.w    -$10
                dc.w    -$58
                dc.w    -8
                dc.w    -$50
AIZMiniSK_FlybyWorldYPositions:
                dc.w    $310
                dc.w    $310
                dc.w    $31C
                dc.w    $31C
                dc.w    $328
                dc.w    $328
AIZMiniSK_FlybySpeedAndDelay:
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
AIZMiniSK_FlybyMappingFrames:
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    1
                dc.b    2
                dc.b    2
                even
; ---------------------------------------------------------------------------

AIZMiniSK_FlybyTickHiddenDelay:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZMiniSK_FlybyBeginHorizontalMove:
                move.l  #AIZMiniSK_FlybyMoveUntilDeparture,(a0)
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_FlybyMoveUntilDeparture:
                jsr     (MoveSprite2).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

AIZMiniSK_InitDefeatDebris:
                lea     AIZMiniSK_DebrisAttributes(pc),a1
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

AIZMiniSK_LoadBarrelStagger:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  AIZMinibossSK_Barrel_OpeningWaitWords(pc,d0.w),$2E(a0)
                rts
; ---------------------------------------------------------------------------
AIZMinibossSK_Barrel_OpeningWaitWords:
                dc.w    0
                dc.w    $10
                dc.w    $20

; =============== S U B R O U T I N E =======================================

; Use the launcher's subtype for the wait and its phase and facing for the camera-relative lane
AIZMiniMissile_InitDescent:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  subtype(a1),d0
                move.w  AIZMiniSK_DescentWaitByBarrel(pc,d0.w),$2E(a0)

SelectAIZMinibossMissileDescentLane:
                lsr.w   #1,d0
                move.b  $39(a1),d1
                addq.b  #4,d1
                move.b  d1,$39(a1)
                andi.w  #$C,d1
                add.w   d1,d0
                lea     AIZMiniSK_DescentColumnsUnflipped(pc),a2
                lea     AIZMiniSK_DescentXOffsetsUnflipped(pc),a3
                btst    #0,render_flags(a1)
                beq.s   AIZMiniSK_ApplyDescentLaneAndSpeed
                lea     AIZMiniSK_DescentColumnsFlipped(pc),a2
                lea     AIZMiniSK_DescentXOffsetsFlipped(pc),a3

AIZMiniSK_ApplyDescentLaneAndSpeed:
                move.b  (a2,d0.w),d0
                add.w   d0,d0
                move.w  (a3,d0.w),d0
                add.w   (Camera_X_pos).w,d0
                move.w  d0,x_pos(a0)
                move.w  #$400,y_vel(a0)
                rts
; End of function AIZMiniMissile_InitDescent

; ---------------------------------------------------------------------------
AIZMiniSK_DescentWaitByBarrel:
                dc.w    0
                dc.w    $20
                dc.w    $40
AIZMiniSK_DescentColumnsUnflipped:
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
AIZMiniSK_DescentColumnsFlipped:
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
AIZMiniSK_DescentXOffsetsUnflipped:
                dc.w    $24
                dc.w    $4C
                dc.w    $74
                dc.w    $9C
                dc.w    $C4
AIZMiniSK_DescentXOffsetsFlipped:
                dc.w    $7C
                dc.w    $A4
                dc.w    $CC
                dc.w    $F4
                dc.w    $11C
; ---------------------------------------------------------------------------

AIZMiniSK_CheckHitFlashOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   AIZMiniSK_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   AIZMiniSK_BeginDefeatWaitAndExplosion
                tst.b   $20(a0)
                bne.s   AIZMiniSK_ChooseHitFlashColors
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

AIZMiniSK_ChooseHitFlashColors:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   AIZMiniSK_CopyFlashColorsAndTick
                addq.w  #2*4,d0

AIZMiniSK_CopyFlashColorsAndTick:
                lea     AIZMiniSK_FlashPaletteDestinations(pc),a1
                lea     AIZMiniSK_FlashPaletteColorRows(pc,d0.w),a2
                jsr     (CopyWordData_4).l
                subq.b  #1,$20(a0)
                bne.s   AIZMiniSK_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

AIZMiniSK_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

AIZMiniSK_BeginDefeatWaitAndExplosion:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #AIZMiniSK_StartSignControlAndDebris,$34(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   AIZMiniSK_StopTimerAndAwardScore
                move.b  #$10,subtype(a1)

AIZMiniSK_StopTimerAndAwardScore:
                jmp     (BossDefeated_StopTimer).l
; ---------------------------------------------------------------------------
AIZMiniSK_FlashPaletteDestinations:
                dc.w    Normal_palette_line_2+$0E, Normal_palette_line_2+$14, Normal_palette_line_2+$16, Normal_palette_line_2+$1C
AIZMiniSK_FlashPaletteColorRows:
                dc.w    $644,  $240,   $20,  $644
                dc.w    $888,  $AAA,  $EEE,  $AAA
ObjDat_AIZMiniboss:
                dc.l    Map_AIZMiniboss
                dc.w    make_art_tile(ArtTile_AIZMiniboss,1,1)
                dc.w    $200
                dc.b    $20, $20,   0,  $F
AIZMiniSK_RotorAttributes:
                dc.w    make_art_tile(ArtTile_AIZMiniboss,0,1)
                dc.w    $180
                dc.b    $28, $10,   2, $9C
AIZMiniSK_TrimAttributes:
                dc.w    make_art_tile(ArtTile_AIZMiniboss,1,1)
                dc.w    $200
                dc.b    4,   8,   6,   0
AIZMiniSK_BarrelAttributes:
                dc.w    make_art_tile(ArtTile_AIZMiniboss,1,1)
                dc.w    $280
                dc.b    8,   8,   3,   0
AIZMiniSK_BurstAttributes:
                dc.w    make_art_tile(ArtTile_AIZMiniboss,0,0)
                dc.w    $200
                dc.b    8,   8,   7,   0
AIZMiniSK_MissileAttributes:
                dc.w    make_art_tile(ArtTile_AIZMiniboss,0,0)
                dc.w    $280
                dc.b    8, $10,  $C, $98
AIZMiniSK_ImpactExplosionAttributes:
                dc.l    Map_BossExplosion
                dc.w    make_art_tile(ArtTile_BossExplosion2,0,0)
                dc.w    $80
                dc.b    $C,  $C,   0, $97
ObjDat_AIZMiniboss_Flame:
                dc.l    Map_AIZMinibossFlame
                dc.w    make_art_tile(ArtTile_AIZBossFire,0,1)
                dc.w    $100
                dc.b    $10, $10,   0, $8B
AIZMinibossSK_SmallFlyby_FullAttributes:
                dc.l    Map_AIZMinibossSmall
                dc.w    make_art_tile(ArtTile_AIZMinibossSmall,1,0)
                dc.w    $380
                dc.b    $10, $10,   0,   0
AIZMiniSK_DebrisAttributes:
                dc.w    $200
                dc.b    $10, $14,   0,   0
AIZMiniSK_BodyAndTrimChildren:
                dc.w    2-1
                dc.l    AIZMiniSK_InitArrivalRotor
                dc.b    0, $20
                dc.l    AIZMiniSK_InitArrivalTrim
                dc.b    -$24,   8
AIZMiniSK_FlybyChildren:
                dc.w    6-1
                dc.l    AIZMiniSK_InitSmallFlyby
                dc.b    0,   0
AIZMiniSK_ArrivalBarrelChildren:
                dc.w    3-1
                dc.l    AIZMiniSK_ArrivalBarrelFollowDispatch
                dc.b    0,-$20
                dc.l    AIZMiniSK_ArrivalBarrelFollowDispatch
                dc.b    9,-$1C
                dc.l    AIZMiniSK_ArrivalBarrelFollowDispatch
                dc.b    $12,-$18
AIZMiniSK_FightBarrelChildren:
                dc.w    3-1
                dc.l    AIZMiniSK_FightBarrelFollowDispatch
                dc.b    0,-$20
                dc.l    AIZMiniSK_FightBarrelFollowDispatch
                dc.b    9,-$1C
                dc.l    AIZMiniSK_FightBarrelFollowDispatch
                dc.b    $12,-$18
AIZMiniSK_BurstAndTimedMissileChildren:
                dc.w    2-1
                dc.l    AIZMiniSK_BarrelBurstFollowAndDraw
                dc.b    0,   4
                dc.l    AIZMiniSK_TimedMissileDispatch
                dc.b    0,   4
AIZMiniSK_BurstAndFloorMissileChildren:
                dc.w    2-1
                dc.l    AIZMiniSK_BarrelBurstFollowAndDraw
                dc.b    0,   4
                dc.l    AIZMiniSK_FloorMissileDispatchAndDraw
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
AIZMiniSK_AdvancingFlameChild:
                dc.w    1-1
                dc.l    AIZMiniSK_FlameTrailDispatchAndDraw
                dc.b    0,   0
AIZMiniSK_MissileImpactChildren:
                dc.w    7-1
                dc.l    AIZMiniSK_ImpactExplosionDispatch
                dc.b    0,-$24
                dc.l    AIZMiniSK_ImpactExplosionDispatch
                dc.b    8,-$1C
                dc.l    AIZMiniSK_ImpactExplosionDispatch
                dc.b    -8,-$1C
                dc.l    AIZMiniSK_ImpactExplosionDispatch
                dc.b    4,-$14
                dc.l    AIZMiniSK_ImpactExplosionDispatch
                dc.b    -4,-$14
                dc.l    AIZMiniSK_ImpactExplosionDispatch
                dc.b    4,  -4
                dc.l    AIZMiniSK_ImpactExplosionDispatch
                dc.b    -4,  -4
AIZMiniSK_DepartureBlastChild:
                dc.w    1-1
                dc.l    Obj_BossExplosionSpecial
                dc.b    0,   0
AIZMiniSK_DefeatDebrisChildren:
                dc.w    4-1
                dc.l    AIZMiniSK_InitDefeatDebris
                dc.b    -$10,  -8
                dc.l    AIZMiniSK_InitDefeatDebris
                dc.b    $C,-$10
                dc.l    AIZMiniSK_InitDefeatDebris
                dc.b    -$10, $14
                dc.l    AIZMiniSK_InitDefeatDebris
                dc.b    $10,  $C
AIZMiniSK_RotorLoopAnimation:
                dc.b    1,   1,   2, $FC
                dc.b    7,   3,   4,   5, $F4
AIZMiniSK_BarrelOpenAnimation:
                dc.b    3,   5
                dc.b    4,   5
                dc.b    5, $17
                dc.b    $F4
AIZMiniSK_BarrelCloseAnimation:
                dc.b    5, $17
                dc.b    5, $17
                dc.b    4,   5
                dc.b    3,   5
                dc.b    $F4
AIZMiniSK_BurstAnimation:
                dc.b    7,   1
                dc.b    7,   1
                dc.b    8,   1
                dc.b    9,   3
                dc.b    $A,   3
                dc.b    $B,   3
                dc.b    $F4
AIZMiniSK_MissileLoopAnimation:
                dc.b    1,  $C,  $D, $FC
                dc.b    0,   0
                dc.b    0,   0
                dc.b    1,   1
                dc.b    2,   2
                dc.b    3,   3
                dc.b    4,   4
                dc.b    5,   4
                dc.b    $F4
AIZMinibossSK_Flame_HoldFrameDelayStream:
                dc.b    0,   1
                dc.b    0,   1
                dc.b    $F4
AIZMiniSK_FlameExplosionAnimation:
                dc.b    2,   1
                dc.b    2,   1
                dc.b    3,   2
                dc.b    4,   4
                dc.b    5,   1
                dc.b    $F4
AIZMiniSK_AdvancingFlameAnimation:
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
; ---------------------------------------------------------------------------
AIZBossSonicDat:
                dc.w    $4880, $48E0,  $15A
AIZBossKnuxDat:
                dc.w    $4100, $4160,  $5DA
