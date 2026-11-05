; Owner: objects/bosses/lbz/grabber_ship/sk
; Responsibility: Launch Base final boss attached actors, orbiting parts, capture children and defeat effects with private placement records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

LBZBoss2SK_InitBodyPartAndFollow:
                lea     LBZBoss2SK_BodyPartAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LBZBoss2SK_BodyPartSyncPriorityAndDraw,(a0)

LBZBoss2SK_BodyPartSyncPriorityAndDraw:
                jsr     (Child_GetPriorityOnce).l
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

LBZBoss2SK_ArmDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZBoss2SK_ArmStateOffsets(pc,d0.w),d1
                jsr     LBZBoss2SK_ArmStateOffsets(pc,d1.w)
                moveq   #$C,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
LBZBoss2SK_ArmStateOffsets:
                dc.w    LBZBoss2SK_InitArmAndSpawnChildren-LBZBoss2SK_ArmStateOffsets
                dc.w    LBZBoss2SK_ArmWaitForContactPriority-LBZBoss2SK_ArmStateOffsets
                dc.w    LBZBoss2SK_ArmTrackPlayerY-LBZBoss2SK_ArmStateOffsets
; ---------------------------------------------------------------------------

LBZBoss2SK_InitArmAndSpawnChildren:
                lea     LBZBoss2SK_PrimaryArmAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                movea.w parent3(a0),a1
                move.w  a0,$44(a1)
                move.b  #$14,child_dx(a0)
                move.b  #-6,child_dy(a0)
                lea     LBZBoss2SK_PrimaryArmChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LBZBoss2SK_ArmWaitForContactPriority:
                movea.w parent3(a0),a1
                btst    #7,art_tile(a1)
                beq.s   LBZBoss2SK_ArmPlaceFromCircle
                bset    #7,art_tile(a0)
                move.b  #4,routine(a0)
                move.b  #$AD,collision_flags(a0)

LBZBoss2SK_ArmPlaceFromCircle:
                lea     (LBZFinalBoss2_CircleLookup).l,a2
                jmp     (MoveSprite_CircularLookup).l
; ---------------------------------------------------------------------------

LBZBoss2SK_ArmTrackPlayerY:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.w   LBZBoss2SK_SharedReturn
                btst    #2,$38(a1)
                bne.s   LBZBoss2SK_ArmCopyFacingAndPlace
                lea     (Player_1).w,a1
                move.b  $3C(a0),d0
                move.w  y_pos(a0),d1
                sub.w   y_pos(a1),d1
                cmpi.w  #-2,d1
                blt.s   LBZBoss2SK_ArmIncreaseTrackingPhase
                cmpi.w  #2,d1
                ble.s   LBZBoss2SK_ArmCopyFacingAndPlace
                subq.b  #1,d0
                cmpi.b  #-$30,d0
                blt.s   LBZBoss2SK_ArmCopyFacingAndPlace
                bra.w   LBZBoss2SK_ArmStoreTrackingPhase
; ---------------------------------------------------------------------------

LBZBoss2SK_ArmIncreaseTrackingPhase:
                addq.b  #1,d0
                cmpi.b  #0,d0
                bgt.s   LBZBoss2SK_ArmCopyFacingAndPlace

LBZBoss2SK_ArmStoreTrackingPhase:
                move.b  d0,$3C(a0)

LBZBoss2SK_ArmCopyFacingAndPlace:
                jsr     (Change_FlipXUseParent).l
                lea     (LBZFinalBoss2_CircleLookup).l,a2
                jmp     (MoveSprite_CircularLookup).l
; ---------------------------------------------------------------------------

LBZBoss2SK_InitFollowerAndReparent:
                lea     LBZBoss2SK_SecondaryArmAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #LBZBoss2SK_FollowerSyncPhaseAndDraw,(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a2
                move.w  a2,parent3(a0)
                move.w  a1,$44(a0)
                move.w  a1,$44(a0)
                move.b  #$18,child_dx(a0)
                move.b  #-6,child_dy(a0)

LBZBoss2SK_FollowerSyncPhaseAndDraw:
                jsr     (Child_GetPriorityOnce).l
                jsr     (Change_FlipXUseParent).l
                movea.w $44(a0),a1
                move.b  $3C(a1),d0
                addi.b  #$14,d0
                move.b  d0,$3C(a0)
                lea     (LBZ2FinalBoss2_CircleLookup2).l,a2
                jsr     (MoveSprite_CircularLookup).l
                moveq   #$C,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

LBZBoss2SK_InitSegmentAndCacheBoss:
                lea     LBZBoss2SK_ArmSegmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                move.l  #LBZBoss2SK_SegmentLatchPriority,(a0)
                move.l  #LBZBoss2SK_ArmSegmentDefaultAnim,$30(a0)
                tst.b   subtype(a0)
                beq.s   LBZBoss2SK_SegmentLatchPriority
                move.b  #8,mapping_frame(a0)
                move.w  #$180,priority(a0)
                move.l  #LBZBoss2SK_ArmSegmentAlternateAnim,$30(a0)

LBZBoss2SK_SegmentLatchPriority:
                jsr     (Child_GetPriorityOnce).l

LBZBoss2SK_SegmentFollowAndCheckHeld:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Animate_Raw).l
                movea.w $44(a0),a1
                tst.b   $30(a1)
                beq.s   LBZBoss2SK_SegmentActiveTouchDraw
                move.l  #LBZBoss2SK_SegmentWaitFrozenForRelease,(a0)
                move.b  #7,mapping_frame(a0)
                tst.b   subtype(a0)
                beq.s   LBZBoss2SK_SegmentActiveTouchDraw
                move.b  #$B,mapping_frame(a0)
                addq.b  #8,child_dx(a0)

LBZBoss2SK_SegmentActiveTouchDraw:
                moveq   #$C,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

LBZBoss2SK_SegmentWaitFrozenForRelease:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w $44(a0),a1
                tst.b   $30(a1)
                bne.s   LBZBoss2SK_SegmentFrozenTouchDraw
                move.l  #LBZBoss2SK_SegmentFollowAndCheckHeld,(a0)
                tst.b   subtype(a0)
                beq.s   LBZBoss2SK_SegmentFrozenTouchDraw
                subq.b  #8,child_dx(a0)

LBZBoss2SK_SegmentFrozenTouchDraw:
                moveq   #$C,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

LBZBoss2SK_InitCoverAndFollow:
                lea     LBZBoss2SK_CoverAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LBZBoss2SK_CoverSyncPriorityAndDraw,(a0)

LBZBoss2SK_CoverSyncPriorityAndDraw:
                jsr     (Child_GetPriorityOnce).l
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

LBZBoss2SK_InitCollisionFlashVisual:
                lea     LBZBoss2SK_FlashVisualAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LBZBoss2SK_FlashVisualFollowAndFlicker,(a0)

LBZBoss2SK_FlashVisualFollowAndFlicker:
                move.b  #$9A,d0
                bsr.w   LBZBoss2Child_LatchPriorityAndColl
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZBoss2SK_DeleteDefeatedChild
                btst    #0,(V_int_run_count+3).w
                bne.w   LBZBoss2SK_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2SK_DeleteDefeatedChild:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2SK_InitInvisibleTouchProxy:
                move.l  #LBZBoss2SK_TouchProxyFollowAndSubmit,(a0)
                move.b  #$9C,collision_flags(a0)

LBZBoss2SK_TouchProxyFollowAndSubmit:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZBoss2SK_DeleteDefeatedChild
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

LBZBoss2SK_CaptureProbeCacheBoss:
                move.l  #LBZBoss2SK_CaptureProbeCheckPlayer,(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)

LBZBoss2SK_CaptureProbeCheckPlayer:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   LBZBoss2SK_CaptureProbeReleaseAndDelete
                btst    #3,$38(a1)
                bne.w   LBZBoss2SK_SharedReturn
                btst    #6,status(a1)
                bne.w   LBZBoss2SK_SharedReturn
                lea     LBZBoss2SK_CaptureProbeBounds(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                beq.s   LBZBoss2SK_CaptureProbeReturn
                movea.w d0,a1
                tst.b   invulnerability_timer(a1)
                bne.s   LBZBoss2SK_CaptureProbeReturn
                cmpi.b  #6,routine(a1)
                blo.s   LBZBoss2SK_CapturePlayerAndSignalBoss

LBZBoss2SK_CaptureProbeReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_CaptureProbeReleaseAndDelete:
                clr.b   (Player_1+object_control).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
LBZBoss2SK_CaptureProbeBounds:
                dc.w    -$10,   $20,  -$10,   $20
; ---------------------------------------------------------------------------

LBZBoss2SK_CapturePlayerAndSignalBoss:
                move.l  #LBZBoss2SK_FollowWhilePlayerHeld,(a0)
                movea.w $44(a0),a1
                st      $30(a1)
                move.b  #$1E,routine(a1)
                move.w  #$40,$2E(a1)
                move.l  #LBZBoss2SK_BeginCapturedPlayerAscent,$34(a1)
                lea     (Player_1).w,a1
                move.b  #$81,object_control(a1)
                move.b  #2,anim(a1)
                moveq   #0,d0
                move.w  d0,x_vel(a1)
                move.w  d0,y_vel(a1)
                move.w  d0,ground_vel(a1)

LBZBoss2SK_FollowWhilePlayerHeld:
                movea.w $44(a0),a1
                tst.b   $30(a1)
                beq.s   LBZBoss2SK_BeginCaptureCooldown
                btst    #7,status(a1)
                bne.w   LBZBoss2SK_DeleteDefeatedChild
                jsr     (Refresh_ChildPositionAdjusted).l
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                rts
; ---------------------------------------------------------------------------

; Preload $40 and decrement on entry, for 65 calls before rearming
LBZBoss2SK_BeginCaptureCooldown:
                move.l  #LBZBoss2SK_TickCaptureCooldown,(a0)
                move.w  #$40,$2E(a0)

LBZBoss2SK_TickCaptureCooldown:
                subq.w  #1,$2E(a0)
                bmi.s   LBZBoss2SK_RearmCaptureProbe
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_RearmCaptureProbe:
                move.l  #LBZBoss2SK_CaptureProbeCheckPlayer,(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_InitBodyFragment:
                lea     LBZBoss2SK_BodyFragmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                jsr     (Refresh_ChildPositionAdjusted).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$D,d0
                move.b  d0,mapping_frame(a0)
                moveq   #0,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2SK_RelayDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZBoss2SK_RelayStateOffsets(pc,d0.w),d1
                jsr     LBZBoss2SK_RelayStateOffsets(pc,d1.w)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
LBZBoss2SK_RelayStateOffsets:
                dc.w    LBZBoss2SK_InitDroppedRelay-LBZBoss2SK_RelayStateOffsets
                dc.w    LBZBoss2SK_RelayFallAndProbeFloor-LBZBoss2SK_RelayStateOffsets
                dc.w    LBZBoss2SK_RelayTryPeriodicExplosion-LBZBoss2SK_RelayStateOffsets
; ---------------------------------------------------------------------------

LBZBoss2SK_InitDroppedRelay:
                lea     LBZBoss2SK_DroppedRelayAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #$10,y_radius(a0)
                move.l  #LBZBoss2SK_RelayBounceOrSettle,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_RelayFallAndProbeFloor:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   LBZBoss2SK_SharedReturn
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

; Reflect half the downward speed until it falls below one pixel per frame
LBZBoss2SK_RelayBounceOrSettle:
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                blo.s   LBZBoss2SK_RelaySettleAndOpenArena
                asr.w   #1,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_RelaySettleAndOpenArena:
                move.l  #LBZBoss2SK_RelayTryPeriodicExplosion,(a0)
                move.b  #$7F,$39(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)
                lea     (AIZMiniSK_MissileImpactChildren).l,a2
                jsr     (CreateChild1_Normal).l
                move.w  #$1000,d0
                move.w  d0,(Camera_stored_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  #$6000,(Camera_stored_max_X_pos).w
                move.w  #0,(Camera_stored_min_Y_pos).w
                lea     (Child1_Act2LevelSize).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LBZBoss2SK_RelayTryPeriodicExplosion:
                bclr    #7,render_flags(a0)
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.w   LBZBoss2SK_SharedReturn
                subq.b  #1,$39(a0)
                bmi.s   LBZBoss2SK_RelayDeleteOnBudgetExpiry
                lea     LBZBoss2SK_RelayExplosionControllerChild(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

LBZBoss2SK_RelayDeleteOnBudgetExpiry:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2SK_InitDefeatUnderlay:
                lea     LBZBoss2SK_DefeatUnderlayAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LBZBoss2SK_DefeatUnderlayFollowDraw,(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_DefeatUnderlayFollowDraw:
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

LBZBoss2SK_InitRandomExplosionTimer:
                jsr     (Random_Number).l
                andi.w  #$3C,d0
                lea     LBZBoss2SK_RandomExplosionSites(pc,d0.w),a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                move.l  #Obj_Wait,(a0)
                move.w  #$60,$2E(a0)
                move.l  #LBZBoss2SK_StopExplosionController,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   LBZBoss2SK_RandomExplosionSpawnReturn
                move.b  #4,subtype(a1)

LBZBoss2SK_RandomExplosionSpawnReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_StopExplosionController:
                bset    #5,$38(a0)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
LBZBoss2SK_RandomExplosionSites:
                dc.w    $4310,  $3ED
                dc.w    $4330,  $3F0
                dc.w    $4350,  $3F0
                dc.w    $4370,  $3F0
                dc.w    $4390,  $3F0
                dc.w    $43B0,  $3F0
                dc.w    $43D0,  $3F0
                dc.w    $43F0,  $3F0
                dc.w    $4410,  $3F0
                dc.w    $4430,  $3ED
                dc.w    $4450,  $3E5
                dc.w    $4470,  $3D6
                dc.w    $4490,  $3B8
                dc.w    $44B0,  $3A2
                dc.w    $44D0,  $395
                dc.w    $44F0,  $390
