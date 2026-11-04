; Owner: game/level/zones/lrz/sk
; Responsibility: Lava Reef act-three autoscroll event, bridge or rock actors, movement helpers and private scene resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZ3Autoscroll:
                move.l  #SKLRZ3Scene_LockControlsAndTickDelay,(a0)
                move.w  #60-1,$2E(a0)
                lea     (ArtKosM_LRZ3DeathEggFlash).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZ3DeathEggFlash),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_LRZ3PlatformDebris).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZ3PlatformDebris),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_LockControlsAndTickDelay:
                st      (Ctrl_1_locked).w
                st      (Ctrl_2_locked).w
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                subq.w  #1,$2E(a0)
                bpl.s   SKLRZ3Scene_SceneWaitReturn
                move.l  #SKLRZ3Scene_WaitForFlashAndInitCarrier,(a0)
                jsr     (AllocateObject).l
                bne.s   SKLRZ3Scene_SceneWaitReturn
                move.l  #SKLRZ3Scene_InitDeathEggFlash,(a1)

SKLRZ3Scene_SceneWaitReturn:
                rts
; ---------------------------------------------------------------------------

SKLRZ3Scene_WaitForFlashAndInitCarrier:
                btst    #0,(SceneSyncFlagsOrMHZState).w
                beq.s   SKLRZ3Scene_SceneWaitReturn
                move.l  #SKLRZ3Scene_DispatchCarrierAndDraw,(a0)
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w
                lea     SKLRZ3Scene_CarrierAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                clr.b   routine(a0)
                move.w  #-$40,x_pos(a0)
                move.w  #$460,y_pos(a0)
                move.w  #$100,x_vel(a0)
                jsr     (Swing_Setup1).l
                move.w  #$11F,$2E(a0)
                move.l  #SKLRZ3Scene_StopCarrierAndSignalLaunch,$34(a0)
                lea     SKLRZ3Scene_DelayedLaunchChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_DispatchCarrierAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKLRZ3Scene_CarrierStateOffsets(pc,d0.w),d1
                jsr     SKLRZ3Scene_CarrierStateOffsets(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
SKLRZ3Scene_CarrierStateOffsets:
                dc.w    SKLRZ3Scene_PlayCarrierSiren-SKLRZ3Scene_CarrierStateOffsets
                dc.w    SKLRZ3Scene_MoveCarrierAndTickWait-SKLRZ3Scene_CarrierStateOffsets
; ---------------------------------------------------------------------------

SKLRZ3Scene_PlayCarrierSiren:
                moveq   #signextendB(sfx_RobotnikSiren),d0
                jsr     (Play_SFX_Continuous).l

SKLRZ3Scene_MoveCarrierAndTickWait:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_StopCarrierAndSignalLaunch:
                move.b  #2,routine(a0)
                bset    #1,(SceneSyncFlagsOrMHZState).w
                clr.w   x_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #SKLRZ3Scene_BeginCarrierDeparture,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKLRZ3Scene_BeginCarrierDeparture:
                move.l  #SKLRZ3Scene_UpdateDepartingCarrier,(a0)
                st      (Events_fg_4).w
                clr.w   $2E(a0)
                move.w  #$200,x_vel(a0)
                lea     SKLRZ3Scene_ImpactTargetChildren(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_UpdateDepartingCarrier:
                tst.b   render_flags(a0)
                bpl.s   SKLRZ3Scene_RetireCarrier
                moveq   #signextendB(sfx_RobotnikSiren),d0
                jsr     (Play_SFX_Continuous).l
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  $2E(a0),d0
                addq.w  #1,d0
                move.w  d0,$2E(a0)
                cmpi.w  #$1B0,d0
                blo.s   SKLRZ3Scene_DrawDepartingCarrier
                addq.w  #1,y_pos(a0)

SKLRZ3Scene_DrawDepartingCarrier:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_RetireCarrier:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_InitImpactTarget:
                lea     SKLRZ3Scene_TargetAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKLRZ3Scene_WaitForTargetAtRightEdge,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SKLRZ3Scene_ImpactTargetXPositions(pc,d0.w),x_pos(a0)
                move.w  #$4C0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
SKLRZ3Scene_ImpactTargetXPositions:
                dc.w    $108
                dc.w    $208
                dc.w    $308
                dc.w    $3F8
; ---------------------------------------------------------------------------

SKLRZ3Scene_WaitForTargetAtRightEdge:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$120,d0
                cmp.w   x_pos(a0),d0
                bhs.s   SKLRZ3Scene_ActivateTargetAndSpawnActors
                rts
; ---------------------------------------------------------------------------

SKLRZ3Scene_ActivateTargetAndSpawnActors:
                move.l  #SKLRZ3Scene_WaitForChildImpact,(a0)
                moveq   #signextendB(sfx_Targeting),d0
                jsr     (Play_SFX).l
                lea     SKLRZ3Scene_FallingImpactChildren(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     SKLRZ3Scene_TargetMarkerChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_WaitForChildImpact:
                btst    #1,$38(a0)
                bne.s   SKLRZ3Scene_PublishImpactAndSpawnDebris
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_PublishImpactAndSpawnDebris:
                move.w  x_pos(a0),d0
                subi.w  #$40,d0
                move.w  d0,(Events_bg+$0C).w
                move.w  #$480,(Events_bg+$0E).w
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l
                lea     SKLRZ3Scene_PlatformDebrisChildren(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_InitTargetMarker:
                lea     SKLRZ3Scene_MarkerAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKLRZ3Scene_MoveMarkerOutward,(a0)
                move.w  x_pos(a0),$3A(a0)
                move.w  y_pos(a0),$3C(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d0
                move.b  SKLRZ3Scene_FourMarkerMappingFrameBytes(pc,d0.w),mapping_frame(a0)
                add.w   d1,d1
                move.l  SKLRZ3Scene_MarkerVelocityPairs(pc,d1.w),x_vel(a0)  ; and y_vel
                move.w  #$B,$2E(a0)
                rts
; ---------------------------------------------------------------------------
SKLRZ3Scene_FourMarkerMappingFrameBytes:
                dc.b    $E,  $F, $10, $11
                even
SKLRZ3Scene_MarkerVelocityPairs:
                dc.w    $100,     0
                dc.w    -$100,     0
                dc.w    0,  $100
                dc.w    0, -$100
; ---------------------------------------------------------------------------

SKLRZ3Scene_MoveMarkerOutward:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   SKLRZ3Scene_DrawTargetMarker
                move.l  #SKLRZ3Scene_WaitAndResetTargetMarker,(a0)
                move.w  #$F,$2E(a0)

SKLRZ3Scene_DrawTargetMarker:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_WaitAndResetTargetMarker:
                subq.w  #1,$2E(a0)
                bpl.s   SKLRZ3Scene_CheckMarkerParent
                move.l  #SKLRZ3Scene_MoveMarkerOutward,(a0)
                move.w  $3A(a0),x_pos(a0)
                move.w  $3C(a0),y_pos(a0)
                move.w  #$B,$2E(a0)

SKLRZ3Scene_CheckMarkerParent:
                jmp     (Child_CheckParent).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_InitFallingImpactActor:
                lea     SKLRZ3Scene_FallingImpactAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKLRZ3Scene_FallTowardTarget,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SKLRZ3Scene_ImpactActorStartY(pc,d0.w),y_pos(a0)
                lea     SKLRZ3Scene_FollowingImpactChild(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------
SKLRZ3Scene_ImpactActorStartY:
                dc.w    $340,  $2C0
; ---------------------------------------------------------------------------

SKLRZ3Scene_FallTowardTarget:
                addq.w  #4,y_pos(a0)
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                subi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                bls.s   SKLRZ3Scene_ArmImpactCollisionAndSignal
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Only the second falling actor signals the target to apply the foreground patch
SKLRZ3Scene_ArmImpactCollisionAndSignal:
                move.l  #SKLRZ3Scene_TickImpactCollision,(a0)
                bclr    #7,render_flags(a0)
                move.b  #$91,collision_flags(a0)
                move.w  #$1F,$2E(a0)
                addq.w  #8,y_pos(a0)
                lea     (AIZMiniSK_MissileImpactChildren).l,a2
                jsr     (CreateChild1_Normal).l
                addi.w  #$18,y_pos(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                tst.b   subtype(a0)
                beq.s   SKLRZ3Scene_ImpactSetupReturn
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

SKLRZ3Scene_ImpactSetupReturn:
                rts
; ---------------------------------------------------------------------------

SKLRZ3Scene_TickImpactCollision:
                subq.w  #1,$2E(a0)
                bmi.s   SKLRZ3Scene_RetireImpactActor
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_RetireImpactActor:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_InitImpactEffect:
                lea     SKLRZ3Scene_FollowingEffectAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKLRZ3Scene_FollowAndAnimateImpact,(a0)
                move.l  #SKLRZ3Scene_FollowingImpactAnim,$30(a0)

SKLRZ3Scene_FollowAndAnimateImpact:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jsr     (Animate_Raw).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_InitDelayedLaunchChild:
                lea     SKLRZ3Scene_LaunchChildAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKLRZ3Scene_WaitAttachedForLaunch,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SKLRZ3Scene_EightDelayedLaunchWaitWords(pc,d0.w),$2E(a0)
                move.w  SKLRZ3Scene_LaunchChildXSpeeds(pc,d0.w),x_vel(a0)
                rts
; ---------------------------------------------------------------------------
SKLRZ3Scene_EightDelayedLaunchWaitWords:
                dc.w    $24,   $64,   $18,   $58,    $C,   $4C,     0,   $40
SKLRZ3Scene_LaunchChildXSpeeds:
                dc.w    -$80,   $80,  -$C0,   $C0, -$100,  $100, -$140,  $140
; ---------------------------------------------------------------------------

SKLRZ3Scene_WaitAttachedForLaunch:
                btst    #1,(SceneSyncFlagsOrMHZState).w
                bne.s   SKLRZ3Scene_TickAttachedLaunchDelay
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_TickAttachedLaunchDelay:
                move.l  #SKLRZ3Scene_BeginLightGravity,$34(a0)
                jsr     (Refresh_ChildPosition).l
                jsr     (Obj_Wait).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_BeginLightGravity:
                move.l  #SKLRZ3Scene_MoveWithLightGravity,(a0)
                move.w  #$14,$2E(a0)
                move.l  #SKLRZ3Scene_BeginPoweredRise,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKLRZ3Scene_MoveWithLightGravity:
                jsr     (MoveSprite_LightGravity).l
                jsr     (Obj_Wait).l
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_BeginPoweredRise:
                move.l  #SKLRZ3Scene_RiseAndTryEmitExhaust,(a0)
                moveq   #signextendB(sfx_MissileShoot),d0
                jsr     (Play_SFX).l
                lea     SKLRZ3Scene_FollowingRiseChild(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_RiseAndTryEmitExhaust:
                addi.w  #-$40,y_vel(a0)
                jsr     (MoveSprite2).l
                bsr.w   EmitLrz3RisingActorExhaust
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_InitFollowingRiseEffect:
                lea     SKLRZ3Scene_FollowingEffectAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKLRZ3Scene_FollowAndAnimateRiseEffect,(a0)
                move.l  #SKLRZ3Scene_FollowingRiseAnim,$30(a0)

SKLRZ3Scene_FollowAndAnimateRiseEffect:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jsr     (Animate_RawMultiDelay).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_InitExhaustParticle:
                lea     SKLRZ3Scene_ExhaustAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKLRZ3Scene_AnimateAndMoveExhaust,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$100,y_vel(a0)

SKLRZ3Scene_AnimateAndMoveExhaust:
                lea     SKLRZ3Scene_ExhaustParticleAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                addi.w  #-$10,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_InitDeathEggFlash:
                lea     SKLRZ3Scene_DeathEggFlashAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKLRZ3Scene_AnimateDeathEggFlash,(a0)
                move.w  #$B0,x_pos(a0)
                move.w  #$449,y_pos(a0)
                move.l  #SKLRZ3Scene_BeginFirePaletteTransition,$34(a0)

SKLRZ3Scene_AnimateDeathEggFlash:
                lea     SKLRZ3Scene_DeathEggFlashAnim(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_BeginFirePaletteTransition:
                move.l  #SKLRZ3Scene_WaitForPaletteEffect,(a0)
                move.b  #$80,(Palette_cycle_counters+$00).w
                move.w  #$F,$2E(a0)
                moveq   #signextendB(sfx_SuperTransform),d0
                jsr     (Play_SFX).l
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($20),d6

SKLRZ3Scene_CopyNormalPaletteLine1:
                move.l  (a1)+,(a2)+
                dbf     d6,SKLRZ3Scene_CopyNormalPaletteLine1
                lea     (Pal_LRZBossFire).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($60),d6

SKLRZ3Scene_CopyFirePaletteAndTryEffect:
                move.l  (a1)+,(a2)+
                dbf     d6,SKLRZ3Scene_CopyFirePaletteAndTryEffect
                jsr     (AllocateObject).l
                bne.s   SKLRZ3Scene_QueueSceneArt
                move.l  #SKPalEffect_InitWhiteAndLockRotation,(a1)
                move.w  a1,$44(a0)
                move.w  #3,$3A(a1)

; Queue the art and explosion PLC even if allocating the palette effect failed
SKLRZ3Scene_QueueSceneArt:
                lea     (ArtKosM_LRZ3Autoscroll).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZ3Autoscroll),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_BossExplosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_WaitForPaletteEffect:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.w   SKLRZ3Scene_SceneWaitReturn
                move.b  #1,(Palette_cycle_counters+$00).w
                bset    #0,(SceneSyncFlagsOrMHZState).w
                st      (Events_fg_4).w
                moveq   #signextendB(sfx_SuperEmerald),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   SKLRZ3Scene_TrySpawnCollapsingBridge
                move.l  #SKPalEffect_InitTargetPasses,(a1)
                move.w  a1,$44(a0)

SKLRZ3Scene_TrySpawnCollapsingBridge:
                jsr     (AllocateObject).l
                bne.s   SKLRZ3Scene_DeleteFlashActor
                move.l  #Obj_CollapsingBridge,(a1)
                move.w  #$60,x_pos(a1)
                move.w  #$4D0,y_pos(a1)

SKLRZ3Scene_DeleteFlashActor:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKLRZ3Scene_InitPlatformDebris:
                lea     SKLRZ3Scene_PlatformDebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_FlickerMove,(a0)
                bsr.w   InitializeLrz3PlatformDebrisPiece
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

EmitLrz3RisingActorExhaust:
                tst.w   y_vel(a0)
                bpl.w   SKLRZ3Scene_SceneWaitReturn
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.w   SKLRZ3Scene_SceneWaitReturn
                lea     SKLRZ3Scene_ExhaustParticleChild(pc),a2
                jmp     (CreateChild1_Normal).l
; End of function EmitLrz3RisingActorExhaust

; =============== S U B R O U T I N E =======================================

InitializeLrz3PlatformDebrisPiece:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d0
                move.b  SKLRZ3Scene_PlatformDebrisFrames(pc,d0.w),mapping_frame(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                lea     SKLRZ3Scene_PlatformDebrisOffsets(pc,d1.w),a2
                move.b  (a2)+,d0
                ext.w   d0
                add.w   d0,d2
                move.b  (a2)+,d0
                ext.w   d0
                add.w   d0,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                add.w   d1,d1
                move.l  SKLRZ3Scene_PlatformDebrisVelocities(pc,d1.w),x_vel(a0)  ; and y_vel
                rts
; End of function InitializeLrz3PlatformDebrisPiece

; ---------------------------------------------------------------------------
SKLRZ3Scene_PlatformDebrisFrames:
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    1
                dc.b    1
                dc.b    1
                dc.b    3
                dc.b    3
                dc.b    2
                dc.b    2
                dc.b    3
                dc.b    2
                dc.b    2
                dc.b    3
                even
SKLRZ3Scene_PlatformDebrisOffsets:
                dc.b    $20,  -8
                dc.b    -$20, $10
                dc.b    0, $10
                dc.b    $20, $10
                dc.b    -$10, $28
                dc.b    $10, $28
                dc.b    -$10, $10
                dc.b    $10, $10
                dc.b    -$28, $28
                dc.b    $28, $28
                dc.b    -$2C,   4
                dc.b    -$10,   4
                dc.b    $10,   4
                dc.b    $2C,   4
                dc.b    -$20, $20
                dc.b    0, $20
                dc.b    $20, $20
                dc.b    0, $2C
SKLRZ3Scene_PlatformDebrisVelocities:
                dc.w    $200, -$200
                dc.w    -$180, -$180
                dc.w    $80, -$100
                dc.w    $180, -$200
                dc.w    -$180, -$200
                dc.w    $100, -$100
                dc.w    -$200, -$280
                dc.w    $200, -$280
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    -$300, -$400
                dc.w    -$200, -$300
                dc.w    $200, -$300
                dc.w    $300, -$400
                dc.w    -$200, -$380
                dc.w    $100, -$200
                dc.w    $200, -$380
                dc.w    $80, -$100
SKLRZ3Scene_CarrierAttributes:
                dc.l    Map_LRZ3Autoscroll
                dc.w    make_art_tile(ArtTile_LRZ3Autoscroll,1,0)
                dc.w    $300
                dc.b    $20, $20,   0,   0
SKLRZ3Scene_LaunchChildAttributes:
                dc.w    $280
                dc.b    4, $10,   1,   0
SKLRZ3Scene_FollowingEffectAttributes:
                dc.w    $280
                dc.b    $10, $10,   2,   0
SKLRZ3Scene_ExhaustAttributes:
                dc.w    $280
                dc.b    8,   8,   7,   0
SKLRZ3Scene_TargetAttributes:
                dc.w    $280
                dc.b    $C,  $C,  $D,   0
SKLRZ3Scene_MarkerAttributes:
                dc.w    $280
                dc.b    4,   4,  $E,   0
SKLRZ3Scene_FallingImpactAttributes:
                dc.w    $280
                dc.b    8, $1C,  $C, $92
SKLRZ3Scene_DeathEggFlashAttributes:
                dc.l    Map_LRZ3DeathEggFlash
                dc.w    make_art_tile(ArtTile_LRZ3DeathEggFlash,1,0)
                dc.w    $300
                dc.b    $2C, $28,   0,   0
SKLRZ3Scene_PlatformDebrisAttributes:
                dc.l    Map_LRZ3Debris
                dc.w    make_art_tile(ArtTile_LRZ3PlatformDebris,3,1)
                dc.w    $80
                dc.b    $C,  $C,   0,   0
SKLRZ3Scene_DelayedLaunchChildren:
                dc.w    8-1
                dc.l    SKLRZ3Scene_InitDelayedLaunchChild
                dc.b    -$C,  $C
                dc.l    SKLRZ3Scene_InitDelayedLaunchChild
                dc.b    $C,  $C
                dc.l    SKLRZ3Scene_InitDelayedLaunchChild
                dc.b    -$14,  $C
                dc.l    SKLRZ3Scene_InitDelayedLaunchChild
                dc.b    $14,  $C
                dc.l    SKLRZ3Scene_InitDelayedLaunchChild
                dc.b    -$14,   4
                dc.l    SKLRZ3Scene_InitDelayedLaunchChild
                dc.b    $14,   4
                dc.l    SKLRZ3Scene_InitDelayedLaunchChild
                dc.b    -$18,   4
                dc.l    SKLRZ3Scene_InitDelayedLaunchChild
                dc.b    $18,   4
SKLRZ3Scene_FollowingRiseChild:
                dc.w    1-1
                dc.l    SKLRZ3Scene_InitFollowingRiseEffect
SKLRZ3Scene_ImpactTargetChildren:
                dc.w    4-1
                dc.l    SKLRZ3Scene_InitImpactTarget
SKLRZ3Scene_TargetMarkerChildren:
                dc.w    4-1
                dc.l    SKLRZ3Scene_InitTargetMarker
                dc.b    -$10,   0
                dc.l    SKLRZ3Scene_InitTargetMarker
                dc.b    $10,   0
                dc.l    SKLRZ3Scene_InitTargetMarker
                dc.b    0,-$10
                dc.l    SKLRZ3Scene_InitTargetMarker
                dc.b    0, $10
SKLRZ3Scene_FallingImpactChildren:
                dc.w    2-1
                dc.l    SKLRZ3Scene_InitFallingImpactActor
SKLRZ3Scene_FollowingImpactChild:
                dc.w    1-1
                dc.l    SKLRZ3Scene_InitImpactEffect
SKLRZ3Scene_ExhaustParticleChild:
                dc.w    1-1
                dc.l    SKLRZ3Scene_InitExhaustParticle
                dc.b    0, $18
SKLRZ3Scene_PlatformDebrisChildren:
                dc.w    $12-1
                dc.l    SKLRZ3Scene_InitPlatformDebris
SKLRZ3Scene_DeathEggFlashAnim:
                dc.b    4,   0,   0,   1,   2,   3,   4, $F4
SKLRZ3Scene_FollowingRiseAnim:
                dc.b    2,   1
                dc.b    2,   1
                dc.b    3,   1
                dc.b    2,   1
                dc.b    3,   1
                dc.b    4,   1
                dc.b    3,   1
                dc.b    4,   1
                dc.b    5,   0
                dc.b    4,   1
                dc.b    5,   0
                dc.b    6,   0
                dc.b    5,   0
                dc.b    $F8, .jump-SKLRZ3Scene_FollowingRiseAnim

                .jump:
                dc.b    6,   0
                dc.b    $12,   0
                dc.b    $FC
SKLRZ3Scene_FollowingImpactAnim:
                dc.b    0, $12, $13, $FC
SKLRZ3Scene_ExhaustParticleAnim:
                dc.b    6,   2
                dc.b    7,   2
                dc.b    8,   3
                dc.b    9,   4
                dc.b    $A,   5
                dc.b    $B,   5
                dc.b    $F4
                even
                binclude "data/Levels/LRZ/Palettes/Boss Act Fire (Unused).bin"
                even
Pal_LRZBossFire:
                binclude "data/Levels/LRZ/Palettes/Boss Act Fire.bin"
                even
