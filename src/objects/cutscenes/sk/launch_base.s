; Owner: objects/cutscenes/sk
; Responsibility: Launch Base Knuckles encounters in both acts and their local transition helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_LBZ1:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_LBZ1_Index(pc,d0.w),d1
                jsr     CutsceneKnux_LBZ1_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
CutsceneKnux_LBZ1_Index:
                dc.w    SKLBZScene_InitAct1IfP1IsLeft-CutsceneKnux_LBZ1_Index
                dc.w    SKLBZScene_WaitForPrimaryRangeSignal-CutsceneKnux_LBZ1_Index
                dc.w    SKAIZScene_TickSharedWordWait-CutsceneKnux_LBZ1_Index
                dc.w    SKLBZScene_AnimateThrow-CutsceneKnux_LBZ1_Index
                dc.w    SKAIZScene_TickSharedWordWait-CutsceneKnux_LBZ1_Index
                dc.w    SKCNZScene_AnimateAndTickSharedWait-CutsceneKnux_LBZ1_Index
                dc.w    SKCNZScene_AnimateAndTickSharedWait-CutsceneKnux_LBZ1_Index
                dc.w    SKLBZScene_WalkWhilePreviouslyVisible-CutsceneKnux_LBZ1_Index
; ---------------------------------------------------------------------------

SKLBZScene_InitAct1IfP1IsLeft:
                move.w  (Player_1+x_pos).w,d0
                cmp.w   x_pos(a0),d0
                bhs.s   SKLBZScene_DeleteIfP1PassedTrigger
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.b  #$16,mapping_frame(a0)
                move.w  #$A0,(Camera_min_Y_pos).w
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     SKSceneData_LBZ1RangeLockChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKLBZScene_DeleteIfP1PassedTrigger:
                jmp     (Go_Delete_SpriteSlotted2).l
; ---------------------------------------------------------------------------

SKLBZScene_WaitForPrimaryRangeSignal:
                btst    #3,$38(a0)
                bne.s   SKLBZScene_PlayMusicAndWait60
                rts
; ---------------------------------------------------------------------------

SKLBZScene_PlayMusicAndWait60:
                move.b  #4,routine(a0)
                bsr.w   CutsceneSpawnKnucklesMusicFadeTransition
                move.w  #60-1,$2E(a0)
                move.l  #SKLBZScene_SetThrowAnimAndCallback,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKLBZScene_SetThrowAnimAndCallback:
                move.b  #6,routine(a0)
                move.l  #SKSceneAnim_LBZ1PreBombSequence,$30(a0)
                move.l  #SKLBZScene_ThrowBombAndQueueArt,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKLBZScene_AnimateThrow:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SKLBZScene_ThrowBombAndQueueArt:
                move.b  #8,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #SKLBZScene_BeginIdleBeforeShake,$34(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l
                lea     SKLbzActOneCutscene_BombSpawnList(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     (PLC_BossExplosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

SKLBZScene_BeginIdleBeforeShake:
                move.b  #$A,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #SKLBZScene_StartShakeAndTryExplosions,$34(a0)
                bra.w   SKAIZScene_ResetSharedIdleAnim
; ---------------------------------------------------------------------------

SKLBZScene_StartShakeAndTryExplosions:
                move.b  #$C,routine(a0)
                st      (Screen_shake_flag).w
                move.w  #$5F,$2E(a0)
                move.l  #SKLBZScene_BeginEscapeWalk,$34(a0)
                lea     SKSceneData_LBZ1RisingExplosionChildren(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

SKLBZScene_BeginEscapeWalk:
                move.b  #$E,routine(a0)
                move.l  #SKSceneAnim_KnuxTravelLoop,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                rts
; ---------------------------------------------------------------------------

SKLBZScene_WalkWhilePreviouslyVisible:
                tst.b   render_flags(a0)
                bpl.w   SKLBZScene_ReleasePlayersAndCamera
                addq.w  #2,x_pos(a0)
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

SKLBZScene_ReleasePlayersAndCamera:
                clr.b   (SceneOutcomeOrActorReadySignal).w
                clr.b   (Player_1+object_control).w
                clr.b   (Player_2+object_control).w
                move.w  #$3B60,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jsr     (CreateChild6_Simple).l
                move.w  #$148,(Camera_target_max_Y_pos).w
                jsr     (Remove_From_TrackingSlot).l
                lea     (Pal_LBZ1).l,a1
                jsr     (PalLoad_Line1).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SKLBZScene_CheckPlayersAndSignalP1:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   CutsceneKnux_Delete
                lea     SKLBZScene_PlayerTriggerBounds(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.l   d0
                beq.s   SKLBZScene_RangeChildReturn
                tst.w   d0
                beq.s   SKLBZScene_CheckSecondaryRange
                movea.w parent3(a0),a2
                bset    #3,$38(a2)
                bsr.w   SKLBZScene_LockPlayerFacingRight

SKLBZScene_CheckSecondaryRange:
                swap    d0
                tst.w   d0
                beq.s   SKLBZScene_RangeChildReturn
                bsr.w   SKLBZScene_LockPlayerFacingRight

SKLBZScene_RangeChildReturn:
                rts

; =============== S U B R O U T I N E =======================================

; Set the scene scratch flag and apply the pose to the selected player if still alive
SKLBZScene_LockPlayerFacingRight:
                st      (SceneOutcomeOrActorReadySignal).w
                movea.w d0,a1
                cmpi.b  #6,routine(a1)
                bhs.s   SKLBZScene_RangeChildReturn
                move.b  #$81,object_control(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                rts
; End of function SKLBZScene_LockPlayerFacingRight

; ---------------------------------------------------------------------------
SKLBZScene_PlayerTriggerBounds:
                dc.w    -$40,   $80,  -$30,   $60
; ---------------------------------------------------------------------------

SKLBZScene_InitBombAndPlaySound:
                lea     SKLbzCutscene_BombAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKLBZScene_MoveBombAndCull,(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l

SKLBZScene_MoveBombAndCull:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

SKLBZScene_InitExplosionColumn:
                move.l  #SKLBZScene_RaiseExplosionAndTickTimer,(a0)
                move.l  #Obj_BossExpControl1,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     SKLBZScene_ExplosionPositionsBySubtype(pc,d0.w),a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                move.b  #$20,$39(a0)
                move.b  #$20,$3A(a0)
                move.b  #$20,$3B(a0)
                rts
; ---------------------------------------------------------------------------
SKLBZScene_ExplosionPositionsBySubtype:
                dc.w    $3BC0,  $1A0
                dc.w    $3B80,  $1A0
                dc.w    $3B40,  $1A0
                dc.w    $3B00,  $1A0
; ---------------------------------------------------------------------------

SKLBZScene_RaiseExplosionAndTickTimer:
                subq.w  #4,y_pos(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

CutsceneKnux_LBZ2:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_LBZ2_Index(pc,d0.w),d1
                jsr     CutsceneKnux_LBZ2_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
CutsceneKnux_LBZ2_Index:
                dc.w    SKLBZScene_InitAct2AndFourPillars-CutsceneKnux_LBZ2_Index
                dc.w    SKLBZScene_WaitForAct2Signal-CutsceneKnux_LBZ2_Index
                dc.w    SKLBZScene_AnimateReaction-CutsceneKnux_LBZ2_Index
                dc.w    SKLBZScene_SelectShakeAnim-CutsceneKnux_LBZ2_Index
                dc.w    SKLBZScene_FollowBGUntilPillarRelease-CutsceneKnux_LBZ2_Index
                dc.w    SKLBZScene_SplashAtWaterlineOnce-CutsceneKnux_LBZ2_Index
                dc.w    SKLBZScene_ApplyBGDeltaAndGravity-CutsceneKnux_LBZ2_Index
; ---------------------------------------------------------------------------

SKLBZScene_InitAct2AndFourPillars:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bset    #0,render_flags(a0)
                move.b  #$20,mapping_frame(a0)
                bsr.w   CutsceneSpawnKnucklesMusicFadeTransition
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     SKSceneData_LBZ2PillarChildren(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

SKLBZScene_WaitForAct2Signal:
                btst    #1,$38(a0)
                bne.s   SKLBZScene_SelectReactionAndCallback
                rts
; ---------------------------------------------------------------------------

SKLBZScene_SelectReactionAndCallback:
                move.b  #4,routine(a0)
                move.l  #SKLBZScene_FaceRightAndResetIdle,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKLBZScene_AnimateReaction:
                lea     SKSceneAnim_LBZ2PreTurnSequence(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

SKLBZScene_FaceRightAndResetIdle:
                move.b  #6,routine(a0)
                bclr    #0,render_flags(a0)
                bra.w   SKAIZScene_ResetSharedIdleAnim
; ---------------------------------------------------------------------------

SKLBZScene_SelectShakeAnim:
                tst.b   (Screen_shake_flag).w
                beq.s   SKLBZScene_AnimateAfterShakeCheck
                move.b  #8,routine(a0)
                move.l  #SKSceneAnim_LBZ2ShakeLoop,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)

SKLBZScene_AnimateAfterShakeCheck:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

SKLBZScene_FollowBGUntilPillarRelease:
                btst    #3,$38(a0)
                bne.s   SKLBZScene_BeginFallAndTryMusicFade
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

SKLBZScene_BeginFallAndTryMusicFade:
                move.b  #$A,routine(a0)
                bset    #0,render_flags(a0)
                move.b  #9,mapping_frame(a0)
                move.w  #$200,x_vel(a0)
                move.w  #-$100,y_vel(a0)
                jsr     (AllocateObject).l
                bne.s   SKLBZScene_ReleaseMusicReturn
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

SKLBZScene_ReleaseMusicReturn:
                rts
; ---------------------------------------------------------------------------

SKLBZScene_SplashAtWaterlineOnce:
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   SKLBZScene_ApplyBGDeltaAndGravity
                moveq   #signextendB(sfx_Splash),d0
                jsr     (Play_SFX).l
                move.b  #$C,routine(a0)

SKLBZScene_ApplyBGDeltaAndGravity:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jmp     (MoveSprite_LightGravity).l
; ---------------------------------------------------------------------------

SKLBZScene_InitPillarMotionAndRestX:
                lea     SKSceneData_LBZ2PillarAttrs(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKLBZScene_WaitForShakeToMovePillar,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.l  SKLBZScene_PillarMotionPairs(pc,d0.w),$3E(a0)
                lsl.w   #3,d0
                add.w   d0,y_pos(a0)
                move.w  x_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------
SKLBZScene_PillarMotionPairs:
                dc.w    $100,   $10
                dc.w    $C0,    $C
                dc.w    $80,     8
                dc.w    $40,     4
; ---------------------------------------------------------------------------

SKLBZScene_WaitForShakeToMovePillar:
                tst.b   (Screen_shake_flag).w
                beq.s   SKLBZScene_DrawWaitingPillar
                move.l  #SKLBZScene_ApplyBGDeltaAndCheckRestSide,(a0)
                move.w  $3E(a0),x_vel(a0)
                move.b  #6,$39(a0)

SKLBZScene_DrawWaitingPillar:
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

SKLBZScene_ApplyBGDeltaAndCheckRestSide:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                move.w  x_pos(a0),d0
                move.w  $40(a0),d1
                cmp.w   $3A(a0),d0
                scs     d2
                bcs.s   SKLBZScene_AccelerateAndCheckSide
                neg.w   d1

SKLBZScene_AccelerateAndCheckSide:
                add.w   d1,x_vel(a0)
                cmp.b   $3C(a0),d2
                beq.s   SKLBZScene_MovePillarAndMaybeCarryX
                move.b  d2,$3C(a0)
                cmpi.b  #3,$39(a0)
                bne.s   SKLBZScene_TickCrossingsAndSignalParent
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.l  SKLBZScene_FastPillarMotionPairs(pc,d0.w),$3E(a0)
                move.w  $3E(a0),x_vel(a0)

SKLBZScene_TickCrossingsAndSignalParent:
                subq.b  #1,$39(a0)
                bne.s   SKLBZScene_MovePillarAndMaybeCarryX
                move.l  #SKLBZScene_FallPillarWithBGAndCull,(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)

SKLBZScene_MovePillarAndMaybeCarryX:
                jsr     (MoveSprite2).l
                tst.b   subtype(a0)
                bne.s   SKLBZScene_CullOrDrawPillar
                movea.w parent3(a0),a1
                move.w  x_pos(a0),x_pos(a1)

SKLBZScene_CullOrDrawPillar:
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------
SKLBZScene_FastPillarMotionPairs:
                dc.w    $200,   $20
                dc.w    $180,   $18
                dc.w    $100,   $10
                dc.w    $80,     8
; ---------------------------------------------------------------------------

SKLBZScene_FallPillarWithBGAndCull:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l
; End of function SKLBZScene_SplashAtWaterlineOnce
