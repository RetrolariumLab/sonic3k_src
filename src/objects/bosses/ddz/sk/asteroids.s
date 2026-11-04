; Owner: objects/bosses/ddz/sk
; Responsibility: Doomsday asteroid actor variants, movement, collisions, fragments and scene effects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DDZAsteroid:
                move.l  #DDZ_AsteroidMoveOutsideDebug,(a0)
                move.l  #Map_DDZMissileAsteroid,mappings(a0)
                move.w  #make_art_tile(ArtTile_DDZMisc,1,1),art_tile(a0)
                move.w  #0,priority(a0)
                bsr.w   DDZAsteroid_InitFromSubtype

DDZ_AsteroidMoveOutsideDebug:
                tst.w   (Debug_placement_mode).w
                bne.s   DDZ_AsteroidWrapAndCheckSuperContact
                jsr     (MoveSprite2).l

DDZ_AsteroidWrapAndCheckSuperContact:
                move.w  (SceneActorOrWorldOffset).w,d0
                sub.w   d0,x_pos(a0)
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   DDZ_AsteroidCullOrDraw
                lea     (Player_1).w,a1
                movea.l $30(a0),a2
                jsr     Check_InMyRange(pc)
                bne.s   DDZ_AsteroidBreakAndKnockPlayer

DDZ_AsteroidCullOrDraw:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

DDZ_AsteroidBreakAndKnockPlayer:
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                move.w  (DdzFlightControllerOrLowerMotionPlanX).w,d0
                beq.s   DDZ_AsteroidReduceScrollSpeed
                movea.w d0,a2
                move.w  #-$400,x_vel(a2)

; The one-pixel floor uses an unsigned comparison after subtraction
DDZ_AsteroidReduceScrollSpeed:
                move.l  (SceneTimerOrSharedMotionRecordBase).w,d0
                move.l  #$10000,d1
                sub.l   d1,d0
                cmp.l   d1,d0
                bhs.s   DDZ_AsteroidStoreSpeedAndCheckSize
                move.l  d1,d0

DDZ_AsteroidStoreSpeedAndCheckSize:
                move.l  d0,(SceneTimerOrSharedMotionRecordBase).w
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.b  #$F0,d0
                cmpi.b  #$20,d0
                bne.s   DDZ_AsteroidSelectParticleRecord
                moveq   #0,d1
                move.w  y_pos(a0),d2
                sub.w   (Player_1+y_pos).w,d2
                smi     d3
                bpl.s   DDZ_LargeAsteroidSelectSplitByY
                neg.w   d2

DDZ_LargeAsteroidSelectSplitByY:
                cmpi.w  #$10,d2
                blo.s   DDZ_LargeAsteroidSelectSplitOffsets
                moveq   #4,d1
                tst.b   d3
                beq.s   DDZ_LargeAsteroidSelectSplitOffsets
                moveq   #8,d1

DDZ_LargeAsteroidSelectSplitOffsets:
                lea     DDZ_LargeAsteroidSplitLayoutTable(pc),a2
                movea.l (a2,d1.w),a2
                moveq   #3-1,d4

DDZ_LargeAsteroidSpawnMediumPieces:
                jsr     (AllocateObject).l
                bne.w   DDZ_AsteroidClearRespawnBit
                move.l  #Obj_DDZAsteroid,(a1)
                move.w  x_pos(a0),d2
                add.w   (a2)+,d2
                move.w  d2,x_pos(a1)
                move.w  y_pos(a0),d3
                add.w   (a2)+,d3
                move.w  d3,y_pos(a1)
                move.b  subtype(a0),d0
                andi.b  #$F,d0
                addi.b  #$10,d0
                move.b  d0,subtype(a1)
                dbf     d4,DDZ_LargeAsteroidSpawnMediumPieces
                lea     DDZ_LargeAsteroidParticleYShifts(pc),a1
                adda.w  d1,a1
                move.w  (a1)+,d1
                add.w   d1,x_pos(a0)
                move.w  (a1)+,d1
                add.w   d1,y_pos(a0)

DDZ_AsteroidSelectParticleRecord:
                move.b  subtype(a0),d0
                andi.w  #$10,d0
                lsr.w   #2,d0
                lea     DDZ_AsteroidParticleRecordsBySize(pc),a2
                movea.l (a2,d0.w),a2
                move.l  #DDZ_InitAsteroidParticle,d1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  (a2)+,d4

DDZ_AsteroidSpawnBreakupParticles:
                jsr     (AllocateObject).l
                bne.s   DDZ_AsteroidClearRespawnBit
                move.l  d1,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  (a2)+,d5
                ext.w   d5
                add.w   d2,d5
                move.w  d5,x_pos(a1)
                move.b  (a2)+,d5
                ext.w   d5
                add.w   d3,d5
                move.w  d5,y_pos(a1)
                move.w  (a2)+,subtype(a1)
                move.w  (a2)+,x_vel(a1)
                move.w  (a2)+,y_vel(a1)
                dbf     d4,DDZ_AsteroidSpawnBreakupParticles

DDZ_AsteroidClearRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   DDZ_AsteroidDeleteAfterBreakup
                movea.w d0,a2
                bclr    #7,(a2)

DDZ_AsteroidDeleteAfterBreakup:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
DDZ_LargeAsteroidSplitLayoutTable:
                dc.l    DDZ_LargeAsteroidCenteredOffsets
                dc.l    DDZ_LargeAsteroidLowerOffsets
                dc.l    DDZ_LargeAsteroidUpperOffsets
DDZ_LargeAsteroidCenteredOffsets:
                dc.w    0, $FFE8
                dc.w    $18,     0
                dc.w    0,   $18
DDZ_LargeAsteroidLowerOffsets:
                dc.w    -$18,     0
                dc.w    0,   $18
                dc.w    $18,     0
DDZ_LargeAsteroidUpperOffsets:
                dc.w    -$18,     0
                dc.w    0,  -$18
                dc.w    $18,     0
DDZ_LargeAsteroidParticleYShifts:
                dc.w    -$10,     0
                dc.w    0,  -$18
                dc.w    0,   $18
DDZ_AsteroidParticleRecordsBySize:
                dc.l    DDZ_AsteroidFiveParticleRecords
                dc.l    DDZ_AsteroidSevenParticleRecords
DDZ_AsteroidFiveParticleRecords:
                dc.w    5-1
                dc.b    -8,   2
                dc.w    0,  -$80,  $140
                dc.b    8,  -4
                dc.w    0,  -$C0, -$100
                dc.b    -4,  -8
                dc.w    $100, -$100, -$200
                dc.b    8,   4
                dc.w    $100, -$200,  $100
                dc.b    4,   8
                dc.w    $100, -$180,  $280
DDZ_AsteroidSevenParticleRecords:
                dc.w    7-1
                dc.b    -$C,  -4
                dc.w    0,  -$80, -$180
                dc.b    -4,  $C
                dc.w    0, -$100,  $100
                dc.b    6,  -8
                dc.w    0,  -$C0,  -$80
                dc.b    -$C,  $C
                dc.w    $100, -$200,  $100
                dc.b    -4, -$C
                dc.w    $100, -$100,  -$80
                dc.b    8,   8
                dc.w    $100,  -$C0,   $60
                dc.b    0,   0
                dc.w    $100, -$140,   $80
; ---------------------------------------------------------------------------

DDZ_InitAsteroidParticle:
                lea     DDZAsteroidFragment_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DDZ_AsteroidParticleWrapAnimateCull,(a0)
                move.l  #DDZ_AsteroidFragmentSubtype0Anim,$30(a0)
                tst.b   subtype(a0)
                beq.s   DDZ_AsteroidParticleWrapAnimateCull
                move.l  #DDZ_AsteroidFragmentOtherAnim,$30(a0)

DDZ_AsteroidParticleWrapAnimateCull:
                move.w  (SceneActorOrWorldOffset).w,d0
                sub.w   d0,x_pos(a0)
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite2).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

DDZ_InitSuperStarTrailAndArt:
                lea     DDZSuperPlayerTrailingStars_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #DDZ_SuperStarTrailCycleSnapshots,(a0)
                move.b  #6,mapping_frame(a0)
                move.l  #ArtUnc_SuperSonic_Stars,d1
                move.w  #tiles_to_bytes(ArtTile_Shield),d2
                move.w  #$1A0,d3
                jmp     (Add_To_DMA_Queue).l
; ---------------------------------------------------------------------------

DDZ_SuperStarTrailCycleSnapshots:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.w   DDZ_MotionHelpersReturn
                move.w  (SceneActorOrWorldOffset).w,d0
                sub.w   d0,x_pos(a0)
                subq.w  #8,x_pos(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   DDZSuperStarTrail_DrawCurrentSnapshot
                move.b  #1,anim_frame_timer(a0)
                move.b  mapping_frame(a0),d0
                addq.b  #1,d0
                cmpi.b  #6,d0
                blo.s   DDZ_SuperStarTrailStoreFrame
                moveq   #0,d0
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)

DDZ_SuperStarTrailStoreFrame:
                move.b  d0,mapping_frame(a0)

DDZSuperStarTrail_DrawCurrentSnapshot:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DDZ_InitHeavyLinearShot:
                lea     DDZHorizontalHeavyProjectile_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #DDZ_HeavyLinearShotWaitAndAttach,(a0)
                move.w  #$400,x_vel(a0)
                move.b  (V_int_run_count+3).w,d0
                andi.w  #$18,d0
                moveq   #0,d1
                move.b  subtype(a0),d1
                add.w   d1,d0
                move.w  DDZ_HeavyLinearShotYVelocities(pc,d0.w),y_vel(a0)
                lsl.w   #3,d1
                move.w  d1,$2E(a0)
                move.w  (SceneActorOrWorldOffset).w,d0
                sub.w   d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------
DDZ_HeavyLinearShotYVelocities:
                dc.w    -$140
                dc.w    -$120
                dc.w    $100
                dc.w    $E0
                dc.w    -$C0
                dc.w    -$A0
                dc.w    $80
                dc.w    $60
                dc.w    -$80
                dc.w    -$60
                dc.w    $40
                dc.w    $20
                dc.w    -$100
                dc.w    -$E0
                dc.w    $C0
                dc.w    $A0
; ---------------------------------------------------------------------------

DDZ_HeavyLinearShotWaitAndAttach:
                move.w  (SceneActorOrWorldOffset).w,d0
                sub.w   d0,x_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.w   DDZ_MotionHelpersReturn
                move.l  #DDZ_HeavyLinearShotSetFlightPriority,(a0)
                move.w  #$10,$2E(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                addi.w  #$20,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),d0
                addi.w  #$20,d0
                move.w  d0,y_pos(a0)
                moveq   #signextendB(sfx_TubeLauncher),d0
                jsr     (Play_SFX).l
                lea     DDZ_HorizontalHeavyShotEffects(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

DDZ_HeavyLinearShotSetFlightPriority:
                subq.w  #1,$2E(a0)
                bpl.s   DDZ_HeavyLinearShotMoveDuringLaunch
                move.l  #DDZ_HeavyLinearShotAccelerateLeft,(a0)
                move.w  #$180,priority(a0)
                bset    #7,$38(a0)

DDZ_HeavyLinearShotMoveDuringLaunch:
                addq.w  #4,x_pos(a0)
                bra.w   DDZ_HeavyLinearShotAnimateAndCollide
; ---------------------------------------------------------------------------

DDZ_HeavyLinearShotAccelerateLeft:
                addi.w  #-$20,x_vel(a0)
                jsr     (MoveSprite2).l

DDZ_HeavyLinearShotAnimateAndCollide:
                lea     DDZ_HorizontalHeavyShotAnim(pc),a1
                jsr     Animate_RawNoSST(pc)
                move.w  (DdzFrameScrollDeltaOrLowerMotionPlanY).w,d0
                add.w   d0,x_pos(a0)
                move.w  (SceneActorOrWorldOffset).w,d0
                sub.w   d0,x_pos(a0)
                bsr.w   DDZHeavyShot_CheckHitAndSlowFlight
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

DDZ_InitHeavyShotFrontChild:
                move.l  #DDZ_HeavyShotChildInheritPriority,(a0)
                lea     DDZ_HeavyShotFrontPartialAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DDZ_HeavyShotChildInheritPriority:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                beq.s   DDZ_HeavyShotChildAnimateAndFollow
                move.w  #$100,priority(a0)

DDZ_HeavyShotChildAnimateAndFollow:
                lea     DDZ_HorizontalHeavyShotFrontAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jsr     Refresh_ChildPosition(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DDZ_InitHeavyShotRearTrail:
                move.l  #DDZ_MissileTrailTryPuffEvery8Frames,(a0)
                lea     DDZ_MissileFlamePartialAttributes(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

DDZ_InitHeavyCurveShot:
                lea     DDZCurvedHeavyProjectile_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #DDZ_HeavyCurveShotSetCurveTimer,(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a0),d0
                addi.w  #$52,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a0),d0
                addi.w  #$5A,d0
                move.w  d0,y_pos(a0)
                move.w  #$200,x_vel(a0)
                move.w  #$200,y_vel(a0)
                move.w  #4,$2E(a0)

DDZ_HeavyCurveShotSetCurveTimer:
                move.w  (SceneActorOrWorldOffset).w,d0
                sub.w   d0,x_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   DDZ_HeavyCurveShotMoveDuringLaunch
                move.l  #DDZ_HeavyCurveShotWaitAndCurve,(a0)
                move.w  #$80,priority(a0)
                bset    #7,art_tile(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$2E(a0)

DDZ_HeavyCurveShotMoveDuringLaunch:
                jsr     (MoveSprite2).l
                move.w  (DdzFrameScrollDeltaOrLowerMotionPlanY).w,d0
                add.w   d0,x_pos(a0)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   DDZ_DeleteSceneActor
                jmp     Sprite_CheckDeleteXY(pc)
; ---------------------------------------------------------------------------

; A negative Y-velocity candidate leaves the stored Y velocity unchanged
DDZ_HeavyCurveShotWaitAndCurve:
                move.w  (SceneActorOrWorldOffset).w,d0
                sub.w   d0,x_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   DDZ_HeavyCurveShotTryPuffEvery8Frames
                addi.w  #-$40,x_vel(a0)
                move.w  y_vel(a0),d0
                addi.w  #-$20,d0
                bmi.s   DDZ_HeavyCurveShotMoveAndCollide
                move.w  d0,y_vel(a0)
                bra.w   DDZ_HeavyCurveShotMoveAndCollide
; ---------------------------------------------------------------------------

DDZ_HeavyCurveShotTryPuffEvery8Frames:
                move.b  (V_int_run_count+3).w,d3
                andi.b  #7,d3
                bne.s   DDZ_HeavyCurveShotMoveAndCollide
                lea     DDZ_CurvedHeavyShotPuffChild(pc),a2
                jsr     CreateChild6_Simple(pc)

DDZ_HeavyCurveShotMoveAndCollide:
                jsr     (MoveSprite2).l
                move.w  (DdzFrameScrollDeltaOrLowerMotionPlanY).w,d0
                add.w   d0,x_pos(a0)
                bsr.w   DDZHeavyShot_CheckHitAndSlowFlight
                jmp     Sprite_CheckDeleteXY(pc)
; ---------------------------------------------------------------------------

DDZ_InitHeavyCurveShotPuff:
                lea     DDZ_TrailPuffPartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DDZ_MissilePuffAnimateMoveAndCull,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$200,y_vel(a0)
                move.w  (SceneActorOrWorldOffset).w,d0
                sub.w   d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

DDZ_InitDefeatExplosion:
                lea     ObjDat_BossExplosion1(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #DDZ_DefeatExplosionSelectScrollCarry,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

DDZ_DefeatExplosionSelectScrollCarry:
                movea.w parent3(a0),a1
                tst.b   subtype(a1)
                beq.s   DDZ_DefeatExplosionAnimateAndMove
                move.w  (SceneActorOrWorldOffset).w,d0
                sub.w   d0,x_pos(a0)
                move.w  (DdzFrameScrollDeltaOrLowerMotionPlanY).w,d0
                add.w   d0,x_pos(a0)

DDZ_DefeatExplosionAnimateAndMove:
                lea     (AniRaw_BossExplosion).l,a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                move.w  $3A(a0),d0
                add.w   d0,x_vel(a0)
                move.w  $3C(a0),d0
                add.w   d0,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DDZ_RingWarningCheckTenRingThreshold:
                move.w  $3A(a0),d1
                moveq   #0,d0
                cmpi.w  #10,(Ring_count).w
                bhi.s   DDZ_RingWarningApplyChangedTempo
                moveq   #8,d0

DDZ_RingWarningApplyChangedTempo:
                cmp.w   d1,d0
                beq.w   DDZ_MotionHelpersReturn
                move.w  d0,$3A(a0)
                jmp     (Change_Music_Tempo).l
