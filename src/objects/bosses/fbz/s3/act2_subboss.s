; Owner: objects/bosses/fbz/s3
; Responsibility: Flying Battery act-two subboss lifecycle, battle state, coordinated actors and resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZ2Subboss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZ2Subboss_Index(pc,d0.w),d1
                jsr     FBZ2Subboss_Index(pc,d1.w)
                bsr.w   FlashAndResetFBZAct2SubbossHitState
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
FBZ2Subboss_Index:
                dc.w    FBZAct2S3_InitBossAndArena-FBZ2Subboss_Index
                dc.w    FBZAct2S3_WaitMusicAndTryBarriers-FBZ2Subboss_Index
                dc.w    FBZAct2S3_WaitProximityOrTimeout-FBZ2Subboss_Index
                dc.w    FBZAct2S3_MoveAndTickDescent-FBZ2Subboss_Index
                dc.w    FBZAct2S3_TickChargeCycleWait-FBZ2Subboss_Index
                dc.w    FBZAct2S3_ChaseUntilChargeReady-FBZ2Subboss_Index
; ---------------------------------------------------------------------------

FBZAct2S3_InitBossAndArena:
                lea     ObjDat_FBZ2Subboss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$7F,collision_property(a0)
                move.b  #6,$39(a0)
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  #$240,(Camera_target_max_Y_pos).w
                move.w  #2*60,$2E(a0)
                move.l  #FBZAct2S3_BeginMusicAndProximityHold,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.b  #1,(Boss_flag).w
                moveq   #PLCID_6A,d0
                jsr     (Load_PLC).l
                lea     Pal_FBZ2Subboss(pc),a1
                jsr     PalLoad_Line1(pc)
                lea     FBZAct2S3_CornerChildren(pc),a2
                jsr     CreateChild3_NormalRepeated(pc)
                lea     FBZAct2S3_SceneAttachmentChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

FBZAct2S3_WaitMusicAndTryBarriers:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                cmpi.w  #$18,d2
                bhs.s   FBZAct2S3_TickInitialMusicWait
                bsr.w   CreateFBZAct2SubbossSideBarriersOnce

FBZAct2S3_TickInitialMusicWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZAct2S3_BeginMusicAndProximityHold:
                move.b  #4,routine(a0)
                move.w  #$3F,$2E(a0)
                moveq   #signextendB(mus_Miniboss),d0
                jsr     (Play_Music).l

FBZAct2S3_SharedReturn:
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_WaitProximityOrTimeout:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                cmpi.w  #$18,d2
                blo.s   FBZAct2S3_BeginDescentAndTryBarriers
                subq.w  #1,$2E(a0)
                bmi.s   FBZAct2S3_BeginDescentAndTryBarriers
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_BeginDescentAndTryBarriers:
                move.b  #6,routine(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #FBZAct2S3_PauseBeforeFirstCharge,$34(a0)

CreateFBZAct2SubbossSideBarriersOnce:
                bset    #7,$38(a0)
                bne.w   FBZAct2S3_SharedReturn
                lea     FBZAct2S3_SolidBarrierChildren(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

FBZAct2S3_MoveAndTickDescent:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZAct2S3_PauseBeforeFirstCharge:
                move.b  #8,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #FBZAct2S3_SpawnChargeAndAimChase,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_TickChargeCycleWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

FBZAct2S3_TickCyclesOrBeginDefeat:
                subq.b  #1,$39(a0)
                bmi.s   FBZAct2S3_BeginTimedDefeat
                bset    #3,$38(a0)
                bclr    #0,$38(a0)

FBZAct2S3_SpawnChargeAndAimChase:
                move.b  #$A,routine(a0)
                bclr    #1,$38(a0)
                clr.w   y_vel(a0)
                lea     FBZAct2S3_ChargeChild(pc),a2
                jsr     CreateChild1_Normal(pc)

; =============== S U B R O U T I N E =======================================

SetFBZAct2SubbossChaseVelocity:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                move.w  #$100,d1
                tst.w   d0
                bne.s   FBZAct2S3_StoreChaseXSpeed
                neg.w   d1

FBZAct2S3_StoreChaseXSpeed:
                move.w  d1,x_vel(a0)
                rts
; End of function SetFBZAct2SubbossChaseVelocity

; ---------------------------------------------------------------------------

FBZAct2S3_BeginTimedDefeat:
                move.l  #Wait_Draw,(a0)
                bset    #7,status(a0)
                move.w  #$3F,$2E(a0)
                move.l  #FBZAct2S3_ReleaseOperatorAfterDefeat,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_ChaseUntilChargeReady:
                btst    #1,$38(a0)
                bne.s   FBZAct2S3_PauseBeforeNextCycle
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$1F,d0
                bne.s   FBZAct2S3_CheckChaseCornerBounds
                bsr.s   SetFBZAct2SubbossChaseVelocity

FBZAct2S3_CheckChaseCornerBounds:
                move.w  #$100,d0
                movea.w $44(a0),a1
                move.w  x_pos(a1),d1
                move.w  x_pos(a0),d2
                addi.w  #$20,d1
                cmp.w   d1,d2
                blo.s   FBZAct2S3_StoreBoundaryRecoverySpeed
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d1
                subi.w  #$20,d1
                cmp.w   d1,d2
                blo.s   FBZAct2S3_MoveChaseX
                neg.w   d0

FBZAct2S3_StoreBoundaryRecoverySpeed:
                move.w  d0,x_vel(a0)

FBZAct2S3_MoveChaseX:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

FBZAct2S3_PauseBeforeNextCycle:
                move.b  #8,routine(a0)
                move.w  #$BF,$2E(a0)
                move.l  #FBZAct2S3_TickCyclesOrBeginDefeat,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_ReleaseOperatorAfterDefeat:
                bset    #4,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #FBZAct2S3_ReleaseBarriersAndClearBoss,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_ReleaseBarriersAndClearBoss:
                bset    #2,$38(a0)
                clr.b   (Boss_flag).w
                move.l  #Sprite_OnScreen_Test,(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_InitCornerAndRegister:
                lea     FBZAct2S3_CornerAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #FBZAct2S3_CornerCheckMoveRequest,(a0)
                bra.w   FBZAct2S3_RegisterCornersAndPlace
; ---------------------------------------------------------------------------

FBZAct2S3_CornerCheckMoveRequest:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   FBZAct2S3_CornerCullAfterDefeat
                btst    #1,subtype(a0)
                bne.s   FBZAct2S3_CornerDraw
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   FBZAct2S3_CornerDraw
                move.l  #FBZAct2S3_CornerMoveAndTickWait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZAct2S3_CornerFinishMove,$34(a0)
                move.w  #$100,x_vel(a0)

FBZAct2S3_CornerDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2S3_CornerCullAfterDefeat:
                move.l  #Sprite_OnScreen_Test,(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_CornerMoveAndTickWait:
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2S3_CornerFinishMove:
                move.l  #FBZAct2S3_CornerCheckMoveRequest,(a0)
                movea.w parent3(a0),a1
                bclr    #3,$38(a1)
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_InitFixedCover:
                lea     FBZAct2S3_FixedCoverAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #FBZAct2S3_FixedCoverDrawUntilDefeat,(a0)
                addi.w  #$CC,x_pos(a0)
                addi.w  #$7C,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_FixedCoverDrawUntilDefeat:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   FBZAct2S3_FixedCoverBreakAndExplode
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2S3_FixedCoverBreakAndExplode:
                move.l  #Sprite_OnScreen_Test,(a0)
                move.b  #3,mapping_frame(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2S3_InitOperatorAndIdleAnim:
                lea     FBZAct2S3_OperatorAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #FBZAct2S3_OperatorIdleAndCheckFeedback,(a0)
                addi.w  #$D8,x_pos(a0)
                addi.w  #$74,y_pos(a0)
                move.l  #FBZAct2S3_OperatorIdleAnim,$30(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_OperatorIdleAndCheckFeedback:
                jsr     Animate_RawMultiDelay(pc)
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                beq.s   FBZAct2S3_OperatorSelectDefeatPose
                move.b  #2,mapping_frame(a0)

FBZAct2S3_OperatorSelectDefeatPose:
                btst    #7,status(a1)
                beq.s   FBZAct2S3_OperatorDrawStanding
                move.l  #FBZAct2S3_OperatorWaitThenBeginRun,(a0)
                move.b  #3,mapping_frame(a0)

FBZAct2S3_OperatorDrawStanding:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2S3_OperatorWaitThenBeginRun:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                beq.s   FBZAct2S3_OperatorDrawAfterWait
                move.l  #FBZAct2S3_OperatorRunAndCull,(a0)
                subq.w  #4,y_pos(a0)
                move.w  #$200,x_vel(a0)
                move.l  #Map_FBZRobotnikRun,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZRobotnikRun,0,0),art_tile(a0)
                clr.b   mapping_frame(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                bset    #0,render_flags(a0)

FBZAct2S3_OperatorDrawAfterWait:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2S3_OperatorRunAndCull:
                lea     FBZAct2S3_OperatorRunAnim(pc),a1
                jsr     Animate_RawNoSST(pc)
                jsr     (MoveSprite2).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

FBZAct2S3_InitBarrierAndBindCorner:
                lea     FBZAct2S3_BarrierAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #FBZAct2S3_BarrierFollowSolidAndFlicker,(a0)
                move.w  #$B0,d0
                move.b  subtype(a0),d1
                bne.s   FBZAct2S3_BarrierChooseSideOffset
                neg.w   d0

FBZAct2S3_BarrierChooseSideOffset:
                add.w   d0,x_pos(a0)
                addi.w  #$60,y_pos(a0)
                movea.w parent3(a0),a1
                moveq   #$44,d0
                tst.b   d1
                beq.s   FBZAct2S3_BarrierStoreCornerHandle
                moveq   #parent3,d0

FBZAct2S3_BarrierStoreCornerHandle:
                move.w  (a1,d0.w),$44(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_BarrierFollowSolidAndFlicker:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   FBZAct2S3_DeleteReleasedBarrier
                move.w  x_pos(a0),-(sp)
                movea.w $44(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                moveq   #$13,d1
                moveq   #$50,d2
                move.w  #$60,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                btst    #0,(V_int_run_count+3).w
                bne.w   FBZAct2S3_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2S3_DeleteReleasedBarrier:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

FBZAct2S3_InitAcceleratingCharge:
                lea     FBZAct2S3_ChargeAttributes(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #FBZAct2S3_ChargeFollowAndAccelerate,(a0)
                move.l  #FBZAct2S3_ChargeAccelerateAnim,$30(a0)
                move.l  #FBZAct2S3_LaserBeginFire,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_ChargeFollowAndAccelerate:
                jsr     Refresh_ChildPosition(pc)
                jsr     Animate_RawGetFaster(pc)
                tst.w   d2
                bpl.s   FBZAct2S3_ChargeTouchAndDraw
                cmpi.b  #$60,$2F(a0)
                bne.s   FBZAct2S3_ChargeTouchAndDraw
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

FBZAct2S3_ChargeTouchAndDraw:
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

FBZAct2S3_LaserBeginFire:
                move.l  #FBZAct2S3_LaserSetTouchFromFrame,(a0)
                move.b  #6,mapping_frame(a0)
                move.l  #FBZAct2S3_LaserFireAnim,$30(a0)
                addi.w  #$3C,y_pos(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZAct2S3_LaserPauseAndTryExplosion,$34(a0)
                rts
; ---------------------------------------------------------------------------

; Evaluate the existing frame before advancing the animation
FBZAct2S3_LaserSetTouchFromFrame:
                clr.b   collision_flags(a0)
                cmpi.b  #8,mapping_frame(a0)
                bne.s   FBZAct2S3_LaserCheckPlayersHurt
                move.b  #$AC,collision_flags(a0)

FBZAct2S3_LaserCheckPlayersHurt:
                lea     (Player_1).w,a2
                cmpi.b  #4,routine(a2)
                beq.s   FBZAct2S3_LaserLatchHurtFeedback
                lea     (Player_2).w,a2
                cmpi.b  #4,routine(a2)
                bne.s   FBZAct2S3_LaserAnimateAndWait

FBZAct2S3_LaserLatchHurtFeedback:
                bset    #0,$38(a0)

FBZAct2S3_LaserAnimateAndWait:
                jsr     Animate_Raw(pc)
                jsr     Obj_Wait(pc)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

FBZAct2S3_LaserPauseAndTryExplosion:
                move.l  #FBZAct2S3_LaserRetractAndReportMiss,$34(a0)
                move.w  #$1F,$2E(a0)
                st      (Screen_shake_flag).w
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   FBZAct2S3_LaserExplosionSpawnReturn
                addi.w  #$60,y_pos(a1)

FBZAct2S3_LaserExplosionSpawnReturn:
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_LaserRetractAndReportMiss:
                move.l  #FBZAct2S3_LaserRetractAnim,$30(a0)
                move.l  #FBZAct2S3_LaserBeginFinalWait,$34(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                btst    #0,$38(a0)
                bne.s   FBZAct2S3_LaserMissCheckReturn
                movea.w parent3(a0),a1
                bset    #0,$38(a1)

FBZAct2S3_LaserMissCheckReturn:
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_LaserBeginFinalWait:
                move.l  #Obj_Wait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #FBZAct2S3_LaserCheckShakeAndDelete,$34(a0)
                rts
; ---------------------------------------------------------------------------

FBZAct2S3_LaserCheckShakeAndDelete:
                clr.w   (Screen_shake_flag).w
                movea.w parent3(a0),a1
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

FBZAct2S3_RegisterCornersAndPlace:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                cmpi.w  #4,d0
                bhs.s   FBZAct2S3_CornerApplySubtypeOffsets
                moveq   #$44,d1
                tst.b   d0
                beq.s   FBZAct2S3_CornerStoreParentAndFlip
                moveq   #parent3,d1

FBZAct2S3_CornerStoreParentAndFlip:
                move.w  a0,(a1,d1.w)
                bset    #1,render_flags(a0)

FBZAct2S3_CornerApplySubtypeOffsets:
                add.w   d0,d0
                lea     FBZAct2S3_CornerPlacementOffsets(pc,d0.w),a1
                move.w  (a1)+,d0
                add.w   d0,x_pos(a0)
                move.w  (a1)+,d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
FBZAct2S3_CornerPlacementOffsets:
                dc.w    -$B0,   $18
                dc.w    $B0,   $18
                dc.w    -$B0,   $A8
                dc.w    $B0,   $A8

; =============== S U B R O U T I N E =======================================

FlashAndResetFBZAct2SubbossHitState:
                tst.b   collision_flags(a0)
                bne.s   FBZAct2S3_HitUpdateReturn
                tst.b   $20(a0)
                bne.s   FBZAct2S3_HitCopyColorsAndTick
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

FBZAct2S3_HitCopyColorsAndTick:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   FBZAct2S3_HitCopyPaletteRow
; Bug: this should be 2*3
                addq.w  #2*2,d0

FBZAct2S3_HitCopyPaletteRow:
                lea     FBZAct2S3_HitPaletteDestinations(pc),a1
                lea     FBZAct2S3_HitPaletteColorRows(pc,d0.w),a2
                jsr     CopyWordData_3(pc)
                subq.b  #1,$20(a0)
                bne.s   FBZAct2S3_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)
                move.b  #$7F,collision_property(a0)

FBZAct2S3_HitUpdateReturn:
                rts
; End of function FlashAndResetFBZAct2SubbossHitState

; ---------------------------------------------------------------------------
FBZAct2S3_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
FBZAct2S3_HitPaletteColorRows:
                dc.w    $866,  $644,   $20
                dc.w    $EEE,  $EEE,  $EEE
ObjDat_FBZ2Subboss:
                dc.l    Map_FBZ2Subboss
                dc.w    make_art_tile(ArtTile_FBZ2Subboss,1,0)
                dc.w    $280
                dc.b    $20, $20,   0, $1C
FBZAct2S3_CornerAttributes:
                dc.w    $80
                dc.b    8,   8,   1,   0
FBZAct2S3_FixedCoverAttributes:
                dc.w    $280
                dc.b    $C, $14,   2,   0
FBZAct2S3_BarrierAttributes:
                dc.w    $80
                dc.b    8, $60,   4,   0
FBZAct2S3_ChargeAttributes:
                dc.w    make_art_tile(ArtTile_FBZ2Subboss,1,1)
                dc.w    $80
                dc.b    $18,   4,   5,   0
FBZAct2S3_OperatorAttributes:
                dc.l    Map_FBZRobotnikStand
                dc.w    make_art_tile(ArtTile_FBZRobotnikStand,0,1)
                dc.w    $280
                dc.b    $20, $20,   0,   0
FBZAct2S3_CornerChildren:
                dc.w    4-1
                dc.l    FBZAct2S3_InitCornerAndRegister
                dc.b    0,   0
FBZAct2S3_SceneAttachmentChildren:
                dc.w    2-1
                dc.l    FBZAct2S3_InitFixedCover
                dc.b    0,   0
                dc.l    FBZAct2S3_InitOperatorAndIdleAnim
                dc.b    0,   0
FBZAct2S3_SolidBarrierChildren:
                dc.w    2-1
                dc.l    FBZAct2S3_InitBarrierAndBindCorner
                dc.b    0,   0
FBZAct2S3_ChargeChild:
                dc.w    1-1
                dc.l    FBZAct2S3_InitAcceleratingCharge
                dc.b    0,   8
FBZAct2S3_OperatorIdleAnim:
                dc.b    0,   7
                dc.b    1, $17
                dc.b    0,   7
                dc.b    1,  $F
                dc.b    0, $3F
                dc.b    1,   7
                dc.b    $FC
FBZAct2S3_ChargeAccelerateAnim:
                dc.b    $B, $80
                dc.b    5,  $A
                dc.b    $FC
FBZAct2S3_LaserFireAnim:
                dc.b    0,   6,   6,  $A,   7,  $A
                dc.b    $F8, .jump-FBZAct2S3_LaserFireAnim

                .jump:
                dc.b    0,   8,  $A, $FC
FBZAct2S3_LaserRetractAnim:
                dc.b    0,   7
                dc.b    7,  $A
                dc.b    6,  $A
                dc.b    $F4
FBZAct2S3_OperatorRunAnim:
                dc.b    7,   0,   1,   2,   1, $FC
                even
Pal_FBZ2Subboss:
                binclude "data/Levels/FBZ/Palettes/FBZ2 Subboss.bin"
                even
