; Owner: objects/bosses/dez/miniboss/sk
; Responsibility: Death Egg miniboss child attack, timed motion, collision and defeat callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

DEZMiniPlatform_RestoreIdleBySide:
                move.l  #DEZMini_CheckExpansionAndAlignment,(a0)
                tst.b   subtype(a0)
                beq.s   DEZMini_PlatformIdleRestoreReturn
                move.l  #DEZMini_LinkedPlatformCheckCatch,(a0)

DEZMini_PlatformIdleRestoreReturn:
                rts
; ---------------------------------------------------------------------------

DEZMini_GrowPlatformOrbitRadius:
                bsr.w   DEZMiniPlatform_AccelAndStepAngle
                move.b  $3A(a0),d0
                addq.b  #1,d0
                cmpi.b  #$60,d0
                bhs.s   DEZMini_HoldExpandedRadius
                move.b  d0,$3A(a0)
                bra.w   DEZMini_PlaceVariableOrbitPlatform
; ---------------------------------------------------------------------------

DEZMini_HoldExpandedRadius:
                move.l  #DEZMini_WaitBeforeRadiusShrink,(a0)
                move.w  #$3F,$2E(a0)
                bra.w   DEZMini_PlaceVariableOrbitPlatform
; ---------------------------------------------------------------------------

DEZMini_WaitBeforeRadiusShrink:
                subq.w  #1,$2E(a0)
                bpl.s   DEZMini_AdvanceAngleDuringHold
                move.l  #DEZMini_ShrinkRadiusAndClearRequest,(a0)

DEZMini_AdvanceAngleDuringHold:
                bsr.w   DEZMiniPlatform_AccelAndStepAngle
                bra.w   DEZMini_PlaceVariableOrbitPlatform
; ---------------------------------------------------------------------------

DEZMini_ShrinkRadiusAndClearRequest:
                bsr.w   DEZMiniPlatform_AccelAndStepAngle
                move.b  $3A(a0),d0
                subq.b  #1,d0
                cmpi.b  #$40,d0
                bhi.s   DEZMini_StoreRadiusAndProject
                bsr.s   DEZMiniPlatform_RestoreIdleBySide
                movea.w parent3(a0),a1
                bclr    #7,$38(a1)
                moveq   #$40,d0

DEZMini_StoreRadiusAndProject:
                move.b  d0,$3A(a0)
                bra.w   DEZMini_PlaceVariableOrbitPlatform
; End of function DEZMiniPlatform_RestoreIdleBySide

; ---------------------------------------------------------------------------

DEZMinibossPlatformContact_Initialize:
                lea     DEZMini_PlatformContactAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DEZMini_PlatformContactFollowDraw,(a0)

DEZMini_PlatformContactFollowDraw:
                lea     DEZMini_PlatformContactAnim(pc),a1
                jsr     Animate_RawNoSST(pc)
                jsr     Refresh_ChildPosition(pc)
                jmp     Child_DrawTouch_Sprite2(pc)
; ---------------------------------------------------------------------------

DEZMinibossEye_DispatchAndDrawOrFlicker:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DEZMinibossEye_StateOffsets(pc,d0.w),d1
                jsr     DEZMinibossEye_StateOffsets(pc,d1.w)
                moveq   #$14,d0
                jmp     Child_Draw_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------
DEZMinibossEye_StateOffsets:
                dc.w    DEZMini_InitEyeAndStoreParentWord-DEZMinibossEye_StateOffsets
                dc.w    DEZMini_TrackEyeUntilBossActive-DEZMinibossEye_StateOffsets
                dc.w    DEZMini_EyeTrackAndCheckFormOne-DEZMinibossEye_StateOffsets
                dc.w    DEZMini_EyeTrackUntilTransitionEnds-DEZMinibossEye_StateOffsets
                dc.w    DEZMini_EyeTrackAndTouch-DEZMinibossEye_StateOffsets
; ---------------------------------------------------------------------------

DEZMini_InitEyeAndStoreParentWord:
                lea     DEZMinibossEye_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.b  #-1,collision_property(a0)
                movea.w parent3(a0),a1
                move.w  d0,$44(a1)

DEZMini_TrackEyeUntilBossActive:
                bsr.w   TrackDEZMinibossEyeTowardPlayerOne
                movea.w parent3(a0),a1
                cmpi.l  #DEZMini_FormOneDispatchSoundAndHit,(a1)
                beq.s   DEZMini_EnableFormOneEyeHits
                rts
; ---------------------------------------------------------------------------

DEZMini_EnableFormOneEyeHits:
                move.b  #4,routine(a0)

DEZMini_EyeTrackAndCheckFormOne:
                bsr.w   TrackDEZMinibossEyeTowardPlayerOne
                bsr.w   DEZMiniEye_TickHitFlash
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                bne.s   DEZMini_EyeWaitDuringTransition
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

DEZMini_EyeWaitDuringTransition:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_EyeTrackUntilTransitionEnds:
                bsr.w   TrackDEZMinibossEyeTowardPlayerOne
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                beq.s   DEZMini_EnableFormTwoEyeHits
                rts
; ---------------------------------------------------------------------------

DEZMini_EnableFormTwoEyeHits:
                move.b  #8,routine(a0)
                move.b  #-1,collision_property(a0)
                move.b  #$17,collision_flags(a0)
                clr.b   anim(a0)
                rts
; ---------------------------------------------------------------------------

DEZMini_EyeTrackAndTouch:
                bsr.w   TrackDEZMinibossEyeTowardPlayerOne
                bsr.w   DEZMiniEye_TickHitFlash
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

DEZMinibossOrbitHazard_Initialize:
                lea     DEZMinibossOrbitHazard_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DEZMini_OrbitHazardStepOrLaunch,(a0)
                bsr.w   SeedDEZMinibossEightOrbitHazardPhases

DEZMini_OrbitHazardStepOrLaunch:
                bsr.w   DEZOrbitHazard_UpdateCollision
                addq.b  #4,$3C(a0)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   DEZMini_OrbitHazardBeginLaunch
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                move.w  $3A(a1),d1
                muls.w  d1,d0
                swap    d0
                move.w  d0,d1
                add.w   x_pos(a1),d0
                move.w  d0,x_pos(a0)
                addi.w  #$20,d1
                cmpi.w  #$40,d1
                scs     d5
                move.b  $3C(a1),d0
                ext.w   d0
                add.w   y_pos(a1),d0
                move.w  d0,y_pos(a0)
                move.b  $3C(a0),d0
                bpl.s   DEZMini_OrbitHazardChooseDepth
                not.b   d0

DEZMini_OrbitHazardChooseDepth:
                lsr.w   #2,d0
                andi.w  #$1C,d0
                lea     DEZMini_OrbitHazardDepthRows(pc,d0.w),a2
                move.b  (a2)+,mapping_frame(a0)
                bclr    #7,art_tile(a0)
                move.b  (a2)+,d1
                or.b    d1,art_tile(a0)
                move.w  (a2)+,priority(a0)
                tst.b   d5
                beq.s   DEZMini_OrbitHazardTouchDraw
                tst.b   d1
                beq.w   DEZMinibossAndScene_SharedReturn

DEZMini_OrbitHazardTouchDraw:
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

DEZMini_OrbitHazardBeginLaunch:
                bclr    #1,$38(a1)
                move.l  #DEZMinibossOrbitHazard_FlyUntilApex,(a0)
                move.b  #$15,mapping_frame(a0)
                bset    #7,art_tile(a0)
                move.w  #$180,priority(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
DEZMini_OrbitHazardDepthRows:
                dc.b    $15, $80
                dc.w    $180
                dc.b    $15, $80
                dc.w    $180
                dc.b    $15, $80
                dc.w    $180
                dc.b    $16, $80
                dc.w    $180
                dc.b    $16,   0
                dc.w    $300
                dc.b    $17,   0
                dc.w    $300
                dc.b    $17,   0
                dc.w    $300
                dc.b    $17,   0
                dc.w    $300
; ---------------------------------------------------------------------------

DEZMinibossOrbitHazard_FlyUntilApex:
                bsr.w   DEZOrbitHazard_UpdateCollision
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bpl.s   DEZMini_TryHazardApexExplosion
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

DEZMini_TryHazardApexExplosion:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   DEZMini_SpawnRadialShotsAndDelete
                move.b  #6,subtype(a1)

DEZMini_SpawnRadialShotsAndDelete:
                lea     DEZMini_RadialShotChild(pc),a2
                jsr     CreateChild6_Simple(pc)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_InitRadialShot:
                lea     DEZMini_RadialShotAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DEZMini_RadialShotMoveAndCull,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     DEZMini_RadialShotFrameFlips(pc,d0.w),a1
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,d1
                or.b    d1,render_flags(a0)
                add.w   d0,d0
                move.l  DEZMinibossRadialFragment_VelocityPairs(pc,d0.w),x_vel(a0)  ; and y_vel
                rts
; ---------------------------------------------------------------------------
DEZMini_RadialShotFrameFlips:
                dc.b    $19,   2
                dc.b    $18,   3
                dc.b    $1A,   1
                dc.b    $18,   1
                dc.b    $19,   0
                dc.b    $18,   0
                dc.b    $1A,   0
                dc.b    $18,   2
DEZMinibossRadialFragment_VelocityPairs:
                dc.w    0,  $200
                dc.w    $16A,  $16A
                dc.w    $200,     0
                dc.w    $16A, -$16A
                dc.w    0, -$200
                dc.w    -$16A, -$16A
                dc.w    -$200,     0
                dc.w    -$16A,  $16A
; ---------------------------------------------------------------------------

DEZMini_RadialShotMoveAndCull:
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouchXY).l
; ---------------------------------------------------------------------------

DEZMinibossBeam_InitializeExtension:
                lea     DEZMini_BeamControllerAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DEZMinibossBeam_ExtendOffsetOnEvenFrames,(a0)

DEZMinibossBeam_ExtendOffsetOnEvenFrames:
                jsr     Refresh_ChildPosition(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   DEZMini_BeamCheckLifeDuringGrowth
                btst    #0,(V_int_run_count+3).w
                bne.w   DEZMinibossAndScene_SharedReturn
                move.b  child_dy(a0),d0
                addq.b  #1,d0
                move.b  d0,child_dy(a0)
                cmpi.b  #$24,d0
                blo.s   DEZMinibossBeam_DrawDuringExtension
                move.l  #DEZMinibossBeam_WaitWithEvenFrameDisplay,(a0)
                move.w  #$3F,$2E(a0)
                move.l  #DEZMinibossBeam_BeginFrameGrowth,$34(a0)

DEZMinibossBeam_DrawDuringExtension:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_BeamCheckLifeDuringGrowth:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

DEZMinibossBeam_WaitWithEvenFrameDisplay:
                jsr     Refresh_ChildPosition(pc)
                jsr     Obj_Wait(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   DEZMini_BeamCheckLifeDuringDelay
                btst    #0,(V_int_run_count+3).w
                bne.w   DEZMinibossAndScene_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_BeamCheckLifeDuringDelay:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

DEZMinibossBeam_BeginFrameGrowth:
                move.l  #DEZMini_BeamGrowAndSpawnEnds,(a0)
                move.b  #$1B,mapping_frame(a0)
                clr.b   $39(a0)
                subq.b  #4,child_dy(a0)
                rts
; ---------------------------------------------------------------------------

; Switch to the next handler and spawn the end details when the frame reaches $22
DEZMini_BeamGrowAndSpawnEnds:
                move.b  mapping_frame(a0),d0
                addq.b  #1,d0
                move.b  d0,mapping_frame(a0)
                cmpi.b  #$22,d0
                blo.s   DEZMinibossBeam_MoveGrowingOffsetAndDraw
                move.l  #DEZMinibossBeam_UpdateActiveOrDelete,(a0)
                lea     DEZMini_BeamSideDetailChild(pc),a2
                jsr     CreateChild6_Simple(pc)

DEZMinibossBeam_MoveGrowingOffsetAndDraw:
                addq.b  #8,child_dy(a0)
                jsr     Refresh_ChildPosition(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DEZMinibossBeam_UpdateActiveOrDelete:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   DEZMini_DeleteBeamWhenFlagClears
                jsr     Refresh_ChildPosition(pc)
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$1F,d0
                bne.s   DEZMini_BeamHurtAndDraw
                moveq   #signextendB(sfx_BossPanic),d0
                jsr     (Play_SFX).l

DEZMini_BeamHurtAndDraw:
                bsr.w   DEZMiniBeam_CheckBothPlayers
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DEZMini_DeleteBeamWhenFlagClears:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_InitBeamEndAndSide:
                lea     DEZMini_BeamSideDetailAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DEZMini_BeamEndFollowAndAnimate,(a0)
                move.w  (SceneMinimumYOrEmeraldSelectionBytes).w,d0
                addi.w  #$B0,d0
                move.w  d0,y_pos(a0)
                moveq   #-$10,d0
                tst.b   subtype(a0)
                beq.s   DEZMini_StoreBeamEndXOffset
                neg.w   d0
                bset    #0,render_flags(a0)

DEZMini_StoreBeamEndXOffset:
                move.w  d0,$3A(a0)

DEZMini_BeamEndFollowAndAnimate:
                lea     DEZMini_BeamSideDetailAnim(pc),a1
                jsr     Animate_RawNoSST(pc)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                add.w   $3A(a0),d0
                move.w  d0,x_pos(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DEZMini_InitRandomDebris:
                lea     DEZMini_RandomDebrisAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bsr.w   SeedDEZMinibossRandomFlickerDebris
                move.l  #DEZMini_RandomDebrisFlicker,(a0)

DEZMini_RandomDebrisFlicker:
                jmp     Obj_FlickerMove(pc)
; ---------------------------------------------------------------------------

DEZMini_InitDelayedSideDebris:
                lea     DEZMini_DelayedSideDebrisAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DEZMini_SideDebrisTickDelay,(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #-$200,d0
                tst.b   subtype(a0)
                beq.s   DEZMini_StoreSideDebrisMotion
                bset    #0,render_flags(a0)
                neg.w   d0

DEZMini_StoreSideDebrisMotion:
                move.w  d0,x_vel(a0)
                move.w  #$3F,$2E(a0)

DEZMini_SideDebrisTickDelay:
                subq.w  #1,$2E(a0)
                bpl.s   DEZMinibossSideDebris_DrawDuringDelay
                move.l  #Obj_FlickerMove,(a0)

DEZMinibossSideDebris_DrawDuringDelay:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_InitDefeatFragment:
                lea     DEZMini_DefeatFragmentAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$23,d0
                move.b  d0,mapping_frame(a0)
                moveq   #8,d0
                jmp     (Set_IndexedVelocity).l
