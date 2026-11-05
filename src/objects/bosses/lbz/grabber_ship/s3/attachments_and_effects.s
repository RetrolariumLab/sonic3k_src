; Owner: objects/bosses/lbz/grabber_ship/s3
; Responsibility: Launch Base second final boss attachments, arms, circular motion, attack actors and detached effects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

LBZBoss2S3_InitBodyPartAndFollow:
                lea     LBZBoss2S3_BodyPartAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #LBZBoss2S3_BodyPartSyncPriorityAndDraw,(a0)

LBZBoss2S3_BodyPartSyncPriorityAndDraw:
                jsr     Child_GetPriorityOnce(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_ArmDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZBoss2S3_ArmStateOffsets(pc,d0.w),d1
                jsr     LBZBoss2S3_ArmStateOffsets(pc,d1.w)
                moveq   #$C,d0
                jmp     Child_DrawTouch_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------
LBZBoss2S3_ArmStateOffsets:
                dc.w    LBZBoss2S3_InitArmAndSpawnChildren-LBZBoss2S3_ArmStateOffsets
                dc.w    LBZBoss2S3_ArmWaitForContactPriority-LBZBoss2S3_ArmStateOffsets
                dc.w    LBZBoss2S3_ArmTrackPlayerY-LBZBoss2S3_ArmStateOffsets
; ---------------------------------------------------------------------------

LBZBoss2S3_InitArmAndSpawnChildren:
                lea     LBZBoss2S3_PrimaryArmAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                movea.w parent3(a0),a1
                move.w  a0,$44(a1)
                move.b  #$14,child_dx(a0)
                move.b  #-6,child_dy(a0)
                lea     LBZBoss2S3_PrimaryArmChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_ArmWaitForContactPriority:
                movea.w parent3(a0),a1
                btst    #7,art_tile(a1)
                beq.s   LBZBoss2S3_ArmPlaceFromCircle
                bset    #7,art_tile(a0)
                move.b  #4,routine(a0)
                move.b  #$AD,collision_flags(a0)

LBZBoss2S3_ArmPlaceFromCircle:
                lea     (LBZFinalBoss2_CircleLookup).l,a2
                jmp     MoveSprite_CircularLookup(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_ArmTrackPlayerY:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.w   LBZBoss2S3_SharedReturn
                btst    #2,$38(a1)
                bne.s   LBZBoss2S3_ArmCopyFacingAndPlace
                lea     (Player_1).w,a1
                move.b  $3C(a0),d0
                move.w  y_pos(a0),d1
                sub.w   y_pos(a1),d1
                cmpi.w  #-2,d1
                blt.s   LBZBoss2S3_ArmIncreaseTrackingPhase
                cmpi.w  #2,d1
                ble.s   LBZBoss2S3_ArmCopyFacingAndPlace
                subq.b  #1,d0
                cmpi.b  #-$30,d0
                blt.s   LBZBoss2S3_ArmCopyFacingAndPlace
                bra.w   LBZBoss2S3_ArmStoreTrackingPhase
; ---------------------------------------------------------------------------

LBZBoss2S3_ArmIncreaseTrackingPhase:
                addq.b  #1,d0
                cmpi.b  #0,d0
                bgt.s   LBZBoss2S3_ArmCopyFacingAndPlace

LBZBoss2S3_ArmStoreTrackingPhase:
                move.b  d0,$3C(a0)

LBZBoss2S3_ArmCopyFacingAndPlace:
                jsr     Change_FlipXUseParent(pc)
                lea     (LBZFinalBoss2_CircleLookup).l,a2
                jmp     MoveSprite_CircularLookup(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_InitFollowerAndReparent:
                lea     LBZBoss2S3_SecondaryArmAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #LBZBoss2S3_FollowerSyncPhaseAndDraw,(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a2
                move.w  a2,parent3(a0)
                move.w  a1,$44(a0)
                move.w  a1,$44(a0)
                move.b  #$18,child_dx(a0)
                move.b  #-6,child_dy(a0)

LBZBoss2S3_FollowerSyncPhaseAndDraw:
                jsr     Child_GetPriorityOnce(pc)
                jsr     Change_FlipXUseParent(pc)
                movea.w $44(a0),a1
                move.b  $3C(a1),d0
                addi.b  #$14,d0
                move.b  d0,$3C(a0)
                lea     (LBZ2FinalBoss2_CircleLookup2).l,a2
                jsr     MoveSprite_CircularLookup(pc)
                moveq   #$C,d0
                jmp     Child_DrawTouch_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_InitSegmentAndCacheBoss:
                lea     LBZBoss2S3_ArmSegmentAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                move.l  #LBZBoss2S3_SegmentLatchPriority,(a0)
                move.l  #LBZBoss2S3_ArmSegmentDefaultAnim,$30(a0)
                tst.b   subtype(a0)
                beq.s   LBZBoss2S3_SegmentLatchPriority
                move.b  #8,mapping_frame(a0)
                move.w  #$180,priority(a0)
                move.l  #LBZBoss2S3_ArmSegmentAlternateAnim,$30(a0)

LBZBoss2S3_SegmentLatchPriority:
                jsr     Child_GetPriorityOnce(pc)

LBZBoss2S3_SegmentFollowAndCheckHeld:
                jsr     Refresh_ChildPositionAdjusted(pc)
                jsr     Animate_Raw(pc)
                movea.w $44(a0),a1
                tst.b   $30(a1)
                beq.s   LBZBoss2S3_SegmentActiveTouchDraw
                move.l  #LBZBoss2S3_SegmentWaitFrozenForRelease,(a0)
                move.b  #7,mapping_frame(a0)
                tst.b   subtype(a0)
                beq.s   LBZBoss2S3_SegmentActiveTouchDraw
                move.b  #$B,mapping_frame(a0)
                addq.b  #8,child_dx(a0)

LBZBoss2S3_SegmentActiveTouchDraw:
                moveq   #$C,d0
                jmp     Child_DrawTouch_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_SegmentWaitFrozenForRelease:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w $44(a0),a1
                tst.b   $30(a1)
                bne.s   LBZBoss2S3_SegmentFrozenTouchDraw
                move.l  #LBZBoss2S3_SegmentFollowAndCheckHeld,(a0)
                tst.b   subtype(a0)
                beq.s   LBZBoss2S3_SegmentFrozenTouchDraw
                subq.b  #8,child_dx(a0)

LBZBoss2S3_SegmentFrozenTouchDraw:
                moveq   #$C,d0
                jmp     Child_DrawTouch_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_InitCoverAndFollow:
                lea     LBZBoss2S3_CoverAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #LBZBoss2S3_CoverSyncPriorityAndDraw,(a0)

LBZBoss2S3_CoverSyncPriorityAndDraw:
                jsr     Child_GetPriorityOnce(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_InitCollisionFlashVisual:
                lea     LBZBoss2S3_TilePartAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #LBZBoss2S3_FlashVisualFollowAndFlicker,(a0)

LBZBoss2S3_FlashVisualFollowAndFlicker:
                move.b  #$9A,d0
                bsr.w   LBZBoss2Child_LatchPriorityAndColl
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZBoss2S3_DeleteDefeatedChild
                btst    #0,(V_int_run_count+3).w
                bne.w   LBZBoss2S3_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2S3_DeleteDefeatedChild:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2S3_InitInvisibleTouchProxy:
                move.l  #LBZBoss2S3_TouchProxyFollowAndSubmit,(a0)
                move.b  #$99,collision_flags(a0)

LBZBoss2S3_TouchProxyFollowAndSubmit:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZBoss2S3_DeleteDefeatedChild
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

LBZBoss2S3_CaptureProbeCacheBoss:
                move.l  #LBZBoss2S3_CaptureProbeCheckPlayer,(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)

LBZBoss2S3_CaptureProbeCheckPlayer:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   LBZBoss2S3_CaptureProbeReleaseAndDelete
                btst    #3,$38(a1)
                bne.w   LBZBoss2S3_SharedReturn
                btst    #6,status(a1)
                bne.w   LBZBoss2S3_SharedReturn
                lea     LBZBoss2S3_CaptureProbeBounds(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                beq.s   LBZBoss2S3_CaptureProbeReturn
                movea.w d0,a1
                tst.b   invulnerability_timer(a1)
                bne.s   LBZBoss2S3_CaptureProbeReturn
                cmpi.b  #6,routine(a1)
                blo.s   LBZBoss2S3_CapturePlayerAndSignalBoss

LBZBoss2S3_CaptureProbeReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_CaptureProbeReleaseAndDelete:
                clr.b   (Player_1+object_control).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
LBZBoss2S3_CaptureProbeBounds:
                dc.w    -$18,   $30,  -$18,   $30
; ---------------------------------------------------------------------------

LBZBoss2S3_CapturePlayerAndSignalBoss:
                move.l  #LBZBoss2S3_FollowWhilePlayerHeld,(a0)
                movea.w $44(a0),a1
                st      $30(a1)
                move.b  #$1E,routine(a1)
                move.w  #$40,$2E(a1)
                move.l  #LBZBoss2S3_BeginCapturedPlayerAscent,$34(a1)
                lea     (Player_1).w,a1
                move.b  #$81,object_control(a1)
                move.b  #2,anim(a1)
                moveq   #0,d0
                move.w  d0,x_vel(a1)
                move.w  d0,y_vel(a1)
                move.w  d0,ground_vel(a1)

LBZBoss2S3_FollowWhilePlayerHeld:
                movea.w $44(a0),a1
                tst.b   $30(a1)
                beq.s   LBZBoss2S3_BeginCaptureCooldown
                btst    #7,status(a1)
                bne.w   LBZBoss2S3_DeleteDefeatedChild
                jsr     Refresh_ChildPositionAdjusted(pc)
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                rts
; ---------------------------------------------------------------------------

; Preload $40 and decrement on entry, for 65 calls before rearming
LBZBoss2S3_BeginCaptureCooldown:
                move.l  #LBZBoss2S3_TickCaptureCooldown,(a0)
                move.w  #$40,$2E(a0)

LBZBoss2S3_TickCaptureCooldown:
                subq.w  #1,$2E(a0)
                bmi.s   LBZBoss2S3_RearmCaptureProbe
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_RearmCaptureProbe:
                move.l  #LBZBoss2S3_CaptureProbeCheckPlayer,(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_InitBodyFragment:
                lea     LBZBoss2S3_BodyFragmentAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$D,d0
                move.b  d0,mapping_frame(a0)
                moveq   #0,d0
                jsr     Set_IndexedVelocity(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2S3_InitExplosionTravel:
                move.l  #LBZBoss2S3_ExplosionTravelTryPeriodic,(a0)
                move.w  #$4430,x_pos(a0)
                move.w  #$728,y_pos(a0)
                move.w  #$1010,$3A(a0)
                move.w  #$200,d0
                tst.b   subtype(a0)
                beq.s   LBZBoss2S3_ExplosionTravelBeginXLeg
                neg.w   d0

LBZBoss2S3_ExplosionTravelBeginXLeg:
                move.w  d0,x_vel(a0)
                move.w  #$41,$2E(a0)
                move.l  #LBZBoss2S3_ExplosionTravelBeginYLeg,$34(a0)

LBZBoss2S3_ExplosionTravelTryPeriodic:
                subq.b  #1,$39(a0)
                bpl.s   LBZBoss2S3_ExplosionTravelMoveAndWait
                move.b  #3,$39(a0)
                jsr     (BossExplosionS3SpawnAtMaskedRandomOffset).l

LBZBoss2S3_ExplosionTravelMoveAndWait:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_ExplosionTravelBeginYLeg:
                clr.w   x_vel(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$57,$2E(a0)
                move.l  #LBZBoss2S3_ExplosionTravelTryFixedBurst,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_ExplosionTravelTryFixedBurst:
                lea     Child6_CreateBossExplosion(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   LBZBoss2S3_ExplosionTravelTryCoordinator
                move.w  #$4430,x_pos(a1)
                move.w  #$678,y_pos(a1)
                move.b  #$C,subtype(a1)

LBZBoss2S3_ExplosionTravelTryCoordinator:
                tst.b   subtype(a0)
                bne.s   LBZBoss2S3_ExplosionTravelQueueDelete
                jsr     (AllocateObject).l
                bne.s   LBZBoss2S3_ExplosionTravelQueueDelete
                move.l  #LBZBoss2S3_DebrisCoordinatorTick,(a1)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$D0,d0
                move.w  d0,x_pos(a1)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a1)
                move.w  #5,$3A(a1)

LBZBoss2S3_ExplosionTravelQueueDelete:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_DebrisCoordinatorTick:
                subq.w  #1,$2E(a0)
                bpl.s   LBZBoss2S3_DebrisCoordinatorReturn
                addq.b  #1,$39(a0)
                cmpi.b  #8,$39(a0)
                bne.s   LBZBoss2S3_DebrisTrySpawnOrFinish
                st      (Events_fg_5).w

LBZBoss2S3_DebrisTrySpawnOrFinish:
                cmpi.b  #$18,$39(a0)
                bcc.s   LBZBoss2S3_DebrisBeginFinalWait
                move.w  $3A(a0),$2E(a0)
                addq.w  #1,$3A(a0)
                jsr     (AllocateObject).l
                bne.s   LBZBoss2S3_DebrisCoordinatorReturn
                move.l  #LBZBoss2S3_InitRandomFallingDebris,(a1)

LBZBoss2S3_DebrisCoordinatorReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_DebrisBeginFinalWait:
                move.l  #LBZBoss2S3_DebrisTickFinalWait,(a0)
                move.w  #$17F,$2E(a0)

LBZBoss2S3_DebrisTickFinalWait:
                subq.w  #1,$2E(a0)
                bmi.s   LBZBoss2S3_DebrisSignalEndingAndPalette
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_DebrisSignalEndingAndPalette:
                bset    #0,(EndingOutcomeOrBossSceneSignals).w
                clr.b   $39(a0)
                clr.w   $2E(a0)
                jsr     (AllocateObject).l
                bne.s   LBZBoss2S3_SpawnDeathEggPiecesAndDelete
                move.l  #LBZBoss2S3_InitEndingPaletteActor,(a1)
                move.b  #4,subtype(a1)

LBZBoss2S3_SpawnDeathEggPiecesAndDelete:
                lea     LBZBoss2S3_DeathEggPieceChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_InitRandomFallingDebris:
                lea     LBZBoss2S3_FallingDebrisAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #MoveChkDel,(a0)
                jsr     (Random_Number).l
                andi.w  #7,d0
                move.b  LBZBoss2S3_FallingDebrisFrames(pc,d0.w),mapping_frame(a0)
                swap    d0
                andi.w  #$FF,d0
                move.w  (Camera_X_pos).w,d1
                addi.w  #$20,d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
LBZBoss2S3_FallingDebrisFrames:
                dc.b    7,   8,   9,  $A,  $B,   7,   8,   9
                even
