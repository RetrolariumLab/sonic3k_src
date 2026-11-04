; Owner: objects/bosses/fbz/sk
; Responsibility: Flying Battery act-two subboss state machine, attack actors and collision or movement helpers with their private lookup constants
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZ2Subboss:
                lea     FBZMiniSK_ActTwoArenaCameraBounds(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZ2Subboss_Index(pc,d0.w),d1
                jsr     FBZ2Subboss_Index(pc,d1.w)
                bsr.w   FlashAndResetFBZAct2SubbossHitState
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
FBZ2Subboss_Index:
                dc.w    FBZAct2SK_InitBossAndArena-FBZ2Subboss_Index
                dc.w    FBZAct2SK_WaitForPlayerXProximity-FBZ2Subboss_Index
                dc.w    FBZAct2SK_MoveAndTickDescent-FBZ2Subboss_Index
                dc.w    FBZAct2SK_TickChargeCycleWait-FBZ2Subboss_Index
                dc.w    FBZAct2SK_ChaseUntilChargeReady-FBZ2Subboss_Index
; ---------------------------------------------------------------------------

FBZAct2SK_InitBossAndArena:
                lea     ObjDat_FBZ2Subboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #$7F,collision_property(a0)
                move.b  #6,$39(a0)
                move.b  #1,(Boss_flag).w
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  #$2900,(Camera_min_X_pos).w
                move.w  #$5E0,(Camera_target_max_Y_pos).w
                lea     PLC_FBZ2Subboss_SonicTails(pc),a1
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   FBZAct2SK_LoadArtAndTryMusicActor
                lea     PLC_FBZ2Subboss_Knuckles(pc),a1

FBZAct2SK_LoadArtAndTryMusicActor:
                jsr     (Load_PLC_Raw).l
                lea     Pal_FBZ2Subboss(pc),a1
                jsr     (PalLoad_Line1).l
                jsr     (AllocateObject).l
                bne.s   FBZAct2SK_SpawnAttachmentAndMaskGroups
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

FBZAct2SK_SpawnAttachmentAndMaskGroups:
                lea     FBZAct2SK_SceneAttachmentChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     FBZAct2SK_ParentFlagMaskChild(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   FBZAct2SK_TryRepeatedCorners
                move.b  #$49,subtype(a1)

FBZAct2SK_TryRepeatedCorners:
                lea     FBZAct2SK_CornerChildren(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

; Require player one within $18 pixels horizontally before descending
FBZAct2SK_WaitForPlayerXProximity:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                cmpi.w  #$18,d2
                blo.s   FBZAct2SK_BeginDescentAndTryBarriers
                rts
; ---------------------------------------------------------------------------

FBZAct2SK_BeginDescentAndTryBarriers:
                move.b  #4,routine(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$37,$2E(a0)
                move.l  #FBZAct2SK_PauseBeforeFirstCharge,$34(a0)

FBZAct2SK_LatchBarrierSpawnAttempt:
                bset    #7,$38(a0)
                bne.w   FBZAct2SK_SharedReturn
                lea     FBZAct2SK_SolidBarrierChildren(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

FBZAct2SK_MoveAndTickDescent:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZAct2SK_PauseBeforeFirstCharge:
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #FBZAct2SK_SpawnChargeAndAimChase,$34(a0)

FBZAct2SK_SharedReturn:
                rts
; ---------------------------------------------------------------------------

FBZAct2SK_TickChargeCycleWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

FBZAct2SK_TickCyclesOrBeginDefeat:
                subq.b  #1,$39(a0)
                bmi.s   FBZAct2SK_BeginTimedDefeat
                bset    #3,$38(a0)
                bclr    #6,status(a0)

FBZAct2SK_SpawnChargeAndAimChase:
                move.b  #8,routine(a0)
                bclr    #1,$38(a0)
                clr.w   y_vel(a0)
                lea     FBZAct2SK_ChargeChild(pc),a2
                jsr     (CreateChild1_Normal).l

; =============== S U B R O U T I N E =======================================

SetFBZAct2SubbossChaseVelocity:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                move.w  #$100,d1
                tst.w   d0
                bne.s   FBZAct2SK_StoreChaseXSpeed
                neg.w   d1

FBZAct2SK_StoreChaseXSpeed:
                move.w  d1,x_vel(a0)
                rts
; End of function SetFBZAct2SubbossChaseVelocity

; ---------------------------------------------------------------------------

FBZAct2SK_BeginTimedDefeat:
                move.l  #Wait_Draw,(a0)
                bset    #7,status(a0)
                bset    #5,$38(a0)
                move.w  #$5F,$2E(a0)
                move.l  #FBZAct2SK_ReleaseOperatorAfterDefeat,$34(a0)
                lea     PLCKosM_FBZ2Subboss(pc),a6
                move.w  (a6)+,d6

FBZAct2SK_QueueDefeatCloudAndPillarArt:
                movea.l (a6)+,a1
                move.w  (a6)+,d2
                jsr     (Queue_Kos_Module).l
                dbf     d6,FBZAct2SK_QueueDefeatCloudAndPillarArt
                rts
; ---------------------------------------------------------------------------
PLCKosM_FBZ2Subboss:    plrlistheader
                plreq   ArtTile_FBZCloud, ArtKosM_FBZCloud
                plreq   ArtTile_FBZBossPillar, ArtKosM_FBZBossPillar
PLCKosM_FBZ2Subboss_End:
; ---------------------------------------------------------------------------

FBZAct2SK_ChaseUntilChargeReady:
                btst    #1,$38(a0)
                bne.s   FBZAct2SK_PauseBeforeNextCycle
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$1F,d0
                bne.s   FBZAct2SK_CheckChaseCornerBounds
                bsr.s   SetFBZAct2SubbossChaseVelocity

FBZAct2SK_CheckChaseCornerBounds:
                move.w  #$100,d0
                movea.w $44(a0),a1
                move.w  x_pos(a1),d1
                move.w  x_pos(a0),d2
                addi.w  #$20,d1
                cmp.w   d1,d2
                blo.s   FBZAct2SK_StoreBoundaryRecoverySpeed
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d1
                subi.w  #$20,d1
                cmp.w   d1,d2
                blo.s   FBZAct2SK_MoveChaseX
                neg.w   d0

FBZAct2SK_StoreBoundaryRecoverySpeed:
                move.w  d0,x_vel(a0)

FBZAct2SK_MoveChaseX:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

FBZAct2SK_PauseBeforeNextCycle:
                move.b  #6,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #FBZAct2SK_TickCyclesOrBeginDefeat,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2SK_ReleaseOperatorAfterDefeat:
                bset    #4,$38(a0)
                move.w  #$5F,$2E(a0)
                move.l  #FBZAct2SK_ReleaseBarriersAndClearBoss,$34(a0)
                jsr     (AllocateObject).l
                bne.s   FBZAct2SK_DefeatMusicFadeSpawnReturn
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

FBZAct2SK_DefeatMusicFadeSpawnReturn:
                rts
; ---------------------------------------------------------------------------

FBZAct2SK_ReleaseBarriersAndClearBoss:
                bset    #2,$38(a0)
                clr.b   (Boss_flag).w
                move.l  #FBZAct2SK_LockCameraMinXAndCull,(a0)
                lea     (PLC_Monitors).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

FBZAct2SK_LockCameraMinXAndCull:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

FBZAct2SK_InitCornerAndRegister:
                lea     FBZAct2SK_CornerAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #FBZAct2SK_CornerCheckMoveRequest,(a0)
                bra.w   FBZAct2SK_RegisterCornersAndPlace
; ---------------------------------------------------------------------------

FBZAct2SK_CornerCheckMoveRequest:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   FBZAct2SK_CornerCullAfterDefeat
                btst    #1,subtype(a0)
                bne.s   FBZAct2SK_CornerDraw
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   FBZAct2SK_CornerDraw
                move.l  #FBZAct2SK_CornerMoveAndTickWait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZAct2SK_CornerFinishMove,$34(a0)
                move.w  #$100,x_vel(a0)

FBZAct2SK_CornerDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2SK_CornerCullAfterDefeat:
                move.l  #Sprite_OnScreen_Test,(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2SK_CornerMoveAndTickWait:
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2SK_CornerFinishMove:
                move.l  #FBZAct2SK_CornerCheckMoveRequest,(a0)
                movea.w parent3(a0),a1
                bclr    #3,$38(a1)
                rts
; ---------------------------------------------------------------------------

FBZAct2SK_InitFixedCover:
                lea     FBZAct2SK_FixedCoverAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #FBZAct2SK_FixedCoverDrawUntilDefeat,(a0)
                addi.w  #$CC,x_pos(a0)
                addi.w  #$7C,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2SK_FixedCoverDrawUntilDefeat:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   FBZAct2SK_FixedCoverBreakAndExplode
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2SK_FixedCoverBreakAndExplode:
                move.l  #Sprite_OnScreen_Test,(a0)
                move.b  #3,mapping_frame(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2SK_InitOperatorAndIdleAnim:
                lea     FBZAct2SK_OperatorAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #FBZAct2SK_OperatorIdleAndCheckFeedback,(a0)
                move.l  #FBZAct2SK_OperatorRunAndCull,$34(a0)
                addi.w  #$D8,x_pos(a0)
                addi.w  #$74,y_pos(a0)
                move.l  #FBZAct2SK_OperatorIdleAnim,$30(a0)
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   FBZAct2SK_OperatorMappingSetupReturn
                move.l  #Map_EggRoboStand,mappings(a0)

FBZAct2SK_OperatorMappingSetupReturn:
                rts
; ---------------------------------------------------------------------------

FBZAct2SK_OperatorIdleAndCheckFeedback:
                jsr     (Animate_RawMultiDelay).l
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                beq.s   FBZAct2SK_OperatorSelectDefeatPose
                move.b  #2,mapping_frame(a0)

FBZAct2SK_OperatorSelectDefeatPose:
                btst    #7,status(a1)
                beq.s   FBZAct2SK_OperatorDrawStanding
                move.l  #FBZAct2SK_OperatorWaitThenBeginRun,(a0)
                move.b  #3,mapping_frame(a0)

FBZAct2SK_OperatorDrawStanding:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2SK_OperatorWaitThenBeginRun:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                beq.s   FBZAct2SK_OperatorDrawAfterWait
                move.l  $34(a0),(a0)
                subq.w  #4,y_pos(a0)
                move.w  #$200,x_vel(a0)
                move.l  #Map_FBZRobotnikRun,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZRobotnikRun,0,1),art_tile(a0)
                clr.b   mapping_frame(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                bset    #0,render_flags(a0)
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   FBZAct2SK_OperatorDrawAfterWait
                move.l  #Map_EggRoboRun,mappings(a0)

FBZAct2SK_OperatorDrawAfterWait:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2SK_OperatorRunAndCull:
                tst.b   render_flags(a0)
                bpl.s   FBZAct2SK_OperatorRestoreArtAndDelete
                lea     FBZAct2SK_OperatorRunAnim(pc),a1
                jsr     (Animate_RawNoSST).l
                jsr     (MoveSprite2).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

FBZAct2SK_OperatorRestoreArtAndDelete:
                lea     (PLC_MonitorsSpikesSprings).l,a1
                jsr     (Load_PLC_Raw).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2SK_InitBarrierAndBindCorner:
                lea     FBZAct2SK_BarrierAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #FBZAct2SK_BarrierFollowSolidAndFlicker,(a0)
                move.w  #$B0,d0
                move.b  subtype(a0),d1
                bne.s   FBZAct2SK_BarrierChooseSideOffset
                neg.w   d0

FBZAct2SK_BarrierChooseSideOffset:
                add.w   d0,x_pos(a0)
                addi.w  #$60,y_pos(a0)
                movea.w parent3(a0),a1
                moveq   #$44,d0
                tst.b   d1
                beq.s   FBZAct2SK_BarrierStoreCornerHandle
                moveq   #parent3,d0

FBZAct2SK_BarrierStoreCornerHandle:
                move.w  (a1,d0.w),$44(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2SK_BarrierFollowSolidAndFlicker:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   FBZAct2SK_DeleteReleasedBarrier
                move.w  x_pos(a0),-(sp)
                movea.w $44(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                moveq   #$13,d1
                moveq   #$50,d2
                move.w  #$60,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                btst    #0,(V_int_run_count+3).w
                bne.w   FBZAct2SK_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2SK_DeleteReleasedBarrier:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2SK_InitAcceleratingCharge:
                lea     FBZAct2SK_ChargeAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #FBZAct2SK_ChargeFollowAndAccelerate,(a0)
                move.l  #FBZAct2SK_ChargeAccelerateAnim,$30(a0)
                move.l  #FBZAct2SK_LaserBeginFire,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2SK_ChargeFollowAndAccelerate:
                jsr     (Refresh_ChildPosition).l
                jsr     (Animate_RawGetFaster).l
                tst.w   d2
                beq.s   FBZAct2SK_ChargeTouchAndDraw
                bmi.s   FBZAct2SK_ChargeCheckReadyCount
                cmpi.b  #4,$2E(a0)
                bne.s   FBZAct2SK_ChargeTouchAndDraw
                moveq   #signextendB(sfx_Charging),d0
                jsr     (Play_SFX).l

FBZAct2SK_ChargeCheckReadyCount:
                cmpi.b  #$20,$2F(a0)
                bne.s   FBZAct2SK_ChargeTouchAndDraw
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

FBZAct2SK_ChargeTouchAndDraw:
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2SK_LaserBeginFire:
                move.l  #FBZAct2SK_LaserSetTouchFromFrame,(a0)
                move.b  #6,mapping_frame(a0)
                move.l  #FBZAct2SK_LaserFireAnim,$30(a0)
                addi.w  #$3C,y_pos(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZAct2SK_LaserPauseAndTryExplosion,$34(a0)
                moveq   #signextendB(sfx_BossLaser),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

; Evaluate the existing frame before advancing the animation
FBZAct2SK_LaserSetTouchFromFrame:
                clr.b   collision_flags(a0)
                cmpi.b  #8,mapping_frame(a0)
                bne.s   FBZAct2SK_LaserCheckPlayersHurt
                move.b  #$AC,collision_flags(a0)

FBZAct2SK_LaserCheckPlayersHurt:
                lea     (Player_1).w,a2
                cmpi.b  #4,routine(a2)
                beq.s   FBZAct2SK_LaserLatchHurtFeedback
                lea     (Player_2).w,a2
                cmpi.b  #4,routine(a2)
                bne.s   FBZAct2SK_LaserAnimateAndWait

FBZAct2SK_LaserLatchHurtFeedback:
                bset    #6,status(a0)

FBZAct2SK_LaserAnimateAndWait:
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2SK_LaserPauseAndTryExplosion:
                move.l  #FBZAct2SK_LaserRetractAndReportMiss,$34(a0)
                move.w  #$1F,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   FBZAct2SK_LaserTryExplosionAfterShake
                move.l  #SKLevel_InitializeScreenShakeRumbleActor,(a1)

FBZAct2SK_LaserTryExplosionAfterShake:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   FBZAct2SK_LaserExplosionSpawnReturn
                addi.w  #$60,y_pos(a1)

FBZAct2SK_LaserExplosionSpawnReturn:
                rts
; ---------------------------------------------------------------------------

FBZAct2SK_LaserRetractAndReportMiss:
                move.l  #FBZAct2SK_LaserRetractAnim,$30(a0)
                move.l  #FBZAct2SK_LaserBeginFinalWait,$34(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                btst    #6,status(a0)
                bne.s   FBZAct2SK_LaserMissCheckReturn
                movea.w parent3(a0),a1
                bset    #6,status(a1)

FBZAct2SK_LaserMissCheckReturn:
                rts
; ---------------------------------------------------------------------------

FBZAct2SK_LaserBeginFinalWait:
                move.l  #Obj_Wait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZAct2SK_LaserCheckShakeAndDelete,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2SK_LaserCheckShakeAndDelete:
                movea.w parent3(a0),a1
                tst.b   $39(a1)
                bmi.s   FBZAct2SK_LaserQueueDeletion
                clr.w   (Screen_shake_flag).w

FBZAct2SK_LaserQueueDeletion:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2SK_RegisterCornersAndPlace:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                cmpi.w  #4,d0
                bhs.s   FBZAct2SK_CornerApplySubtypeOffsets
                moveq   #$44,d1
                tst.b   d0
                beq.s   FBZAct2SK_CornerStoreParentAndFlip
                moveq   #parent3,d1

FBZAct2SK_CornerStoreParentAndFlip:
                move.w  a0,(a1,d1.w)
                bset    #1,render_flags(a0)

FBZAct2SK_CornerApplySubtypeOffsets:
                add.w   d0,d0
                lea     FBZAct2SK_CornerPlacementOffsets(pc,d0.w),a1
                move.w  (a1)+,d0
                add.w   d0,x_pos(a0)
                move.w  (a1)+,d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
FBZAct2SK_CornerPlacementOffsets:
                dc.w    -$B0,   $18
                dc.w    $B0,   $18
                dc.w    -$B0,   $A8
                dc.w    $B0,   $A8

; =============== S U B R O U T I N E =======================================

FlashAndResetFBZAct2SubbossHitState:
                tst.b   collision_flags(a0)
                bne.s   FBZAct2SK_HitUpdateReturn
                tst.b   $20(a0)
                bne.s   FBZAct2SK_HitCopyColorsAndTick
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

FBZAct2SK_HitCopyColorsAndTick:
                bsr.w   CopyFBZAct2SubbossFlashPalette
                subq.b  #1,$20(a0)
                bne.s   FBZAct2SK_HitUpdateReturn
                move.b  $25(a0),collision_flags(a0)
                move.b  #$7F,collision_property(a0)

FBZAct2SK_HitUpdateReturn:
                rts
; End of function FlashAndResetFBZAct2SubbossHitState

; =============== S U B R O U T I N E =======================================

CopyFBZAct2SubbossFlashPalette:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   FBZAct2SK_HitCopyPaletteRow
                btst    #7,status(a0)
                bne.s   FBZAct2SK_HitCopyPaletteRow
                addq.w  #2*3,d0

FBZAct2SK_HitCopyPaletteRow:
                lea     FBZAct2SK_HitPaletteDestinations(pc),a1
                lea     FBZAct2SK_HitPaletteColorRows(pc,d0.w),a2
                jmp     (CopyWordData_3).l
; End of function CopyFBZAct2SubbossFlashPalette

; ---------------------------------------------------------------------------
FBZAct2SK_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
FBZAct2SK_HitPaletteColorRows:
                dc.w    $866,  $644,   $20
                dc.w    $EEE,  $EEE,  $EEE
