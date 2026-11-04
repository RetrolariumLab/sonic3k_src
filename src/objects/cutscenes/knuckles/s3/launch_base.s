; Owner: objects/cutscenes/knuckles/s3
; Responsibility: Knuckles Launch Base act-one and act-two cutscene programs, helpers and scene records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_LBZ1:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_LBZ1_Index(pc,d0.w),d1
                jsr     CutsceneKnux_LBZ1_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
CutsceneKnux_LBZ1_Index:
                dc.w    S3LBZScene_InitAct1IfP1IsLeft-CutsceneKnux_LBZ1_Index
                dc.w    S3LBZScene_WaitForPrimaryRangeSignal-CutsceneKnux_LBZ1_Index
                dc.w    S3AIZScene_TickSharedWordWait-CutsceneKnux_LBZ1_Index
                dc.w    S3LBZScene_AnimateThrow-CutsceneKnux_LBZ1_Index
                dc.w    S3AIZScene_TickSharedWordWait-CutsceneKnux_LBZ1_Index
                dc.w    S3CNZScene_AnimateAndTickSharedWait-CutsceneKnux_LBZ1_Index
                dc.w    S3CNZScene_AnimateAndTickSharedWait-CutsceneKnux_LBZ1_Index
                dc.w    S3LBZScene_WalkWhilePreviouslyVisible-CutsceneKnux_LBZ1_Index
; ---------------------------------------------------------------------------

S3LBZScene_InitAct1IfP1IsLeft:
                move.w  (Player_1+x_pos).w,d0
                cmp.w   x_pos(a0),d0
                bhs.s   S3LBZScene_DeleteIfP1PassedTrigger
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.b  #$16,mapping_frame(a0)
                move.w  #$A0,(Camera_min_Y_pos).w
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     S3KnuxScene_LBZCaptureChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

S3LBZScene_DeleteIfP1PassedTrigger:
                jmp     (Go_Delete_SpriteSlotted2).l
; ---------------------------------------------------------------------------

S3LBZScene_WaitForPrimaryRangeSignal:
                btst    #3,$38(a0)
                bne.s   S3LBZScene_PlayMusicAndWait60
                rts
; ---------------------------------------------------------------------------

S3LBZScene_PlayMusicAndWait60:
                move.b  #4,routine(a0)
                bsr.w   SpawnKnucklesCutsceneMusicTransition
                move.w  #60-1,$2E(a0)
                move.l  #S3LBZScene_SetThrowAnimAndCallback,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3LBZScene_SetThrowAnimAndCallback:
                move.b  #6,routine(a0)
                move.l  #S3KnuxScene_LBZBombThrowAnim,$30(a0)
                move.l  #S3LBZScene_ThrowBombAndQueueArt,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3LBZScene_AnimateThrow:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

S3LBZScene_ThrowBombAndQueueArt:
                move.b  #8,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #S3LBZScene_BeginIdleBeforeShake,$34(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l
                lea     S3KnuxScene_LBZBombChild(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     (PLC_BossExplosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

S3LBZScene_BeginIdleBeforeShake:
                move.b  #$A,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #S3LBZScene_StartShakeAndTryExplosions,$34(a0)
                bra.w   S3AIZScene_ResetSharedIdleAnim
; ---------------------------------------------------------------------------

S3LBZScene_StartShakeAndTryExplosions:
                move.b  #$C,routine(a0)
                st      (Screen_shake_flag).w
                move.w  #$5F,$2E(a0)
                move.l  #S3LBZScene_BeginEscapeWalk,$34(a0)
                lea     S3KnuxScene_LBZRisingExplosions(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

S3LBZScene_BeginEscapeWalk:
                move.b  #$E,routine(a0)
                move.l  #S3KnuxScene_RunAnim,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                rts
; ---------------------------------------------------------------------------

S3LBZScene_WalkWhilePreviouslyVisible:
                tst.b   render_flags(a0)
                bpl.w   S3LBZScene_ReleasePlayersAndCamera
                addq.w  #2,x_pos(a0)
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

S3LBZScene_ReleasePlayersAndCamera:
                clr.b   (_unkFAA9).w
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

S3LBZScene_CheckPlayersAndSignalP1:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   S3LBZScene_DeleteRangeChild
                lea     S3LBZScene_PlayerTriggerBounds(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.l   d0
                beq.s   S3LBZScene_RangeChildReturn
                tst.w   d0
                beq.s   S3LBZScene_CheckSecondaryRange
                movea.w parent3(a0),a2
                bset    #3,$38(a2)
                bsr.w   S3LBZScene_LockPlayerFacingRight

S3LBZScene_CheckSecondaryRange:
                swap    d0
                tst.w   d0
                beq.s   S3LBZScene_RangeChildReturn
                bsr.w   S3LBZScene_LockPlayerFacingRight

S3LBZScene_RangeChildReturn:
                rts
; ---------------------------------------------------------------------------

S3LBZScene_DeleteRangeChild:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

; Set the scene scratch flag and apply the pose to the selected player if still alive
S3LBZScene_LockPlayerFacingRight:
                st      (_unkFAA9).w
                movea.w d0,a1
                cmpi.b  #6,routine(a1)
                bhs.s   S3LBZScene_RangeChildReturn
                move.b  #$81,object_control(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                rts
; End of function S3LBZScene_LockPlayerFacingRight

; ---------------------------------------------------------------------------
S3LBZScene_PlayerTriggerBounds:
                dc.w    -$40,   $80,  -$30,   $60
; ---------------------------------------------------------------------------

S3LBZScene_InitBombAndPlaySound:
                lea     S3KnuxScene_LBZBombAttrs(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #S3LBZScene_MoveBombAndCull,(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l

S3LBZScene_MoveBombAndCull:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

S3LBZScene_InitExplosionColumn:
                move.l  #S3LBZScene_RaiseExplosionAndTickTimer,(a0)
                move.l  #Obj_NormalExpControl,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     S3LBZScene_ExplosionPositionsBySubtype(pc,d0.w),a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                move.b  #$A,subtype(a0)
                jmp     (S3BossExpl_LoadSubtypeParams).l
; ---------------------------------------------------------------------------
S3LBZScene_ExplosionPositionsBySubtype:
                dc.w    $3BC0,  $1A0
                dc.w    $3B80,  $1A0
                dc.w    $3B40,  $1A0
                dc.w    $3B00,  $1A0
; ---------------------------------------------------------------------------

S3LBZScene_RaiseExplosionAndTickTimer:
                subq.w  #4,y_pos(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

CutsceneKnux_LBZ2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_LBZ2_Index(pc,d0.w),d1
                jsr     CutsceneKnux_LBZ2_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
CutsceneKnux_LBZ2_Index:
                dc.w    S3LBZScene_InitAct2AndFourPillars-CutsceneKnux_LBZ2_Index
                dc.w    S3LBZScene_WaitForAct2Signal-CutsceneKnux_LBZ2_Index
                dc.w    S3LBZScene_AnimateReaction-CutsceneKnux_LBZ2_Index
                dc.w    S3LBZScene_SelectShakeAnim-CutsceneKnux_LBZ2_Index
                dc.w    S3LBZScene_FollowBGUntilPillarRelease-CutsceneKnux_LBZ2_Index
                dc.w    S3LBZScene_SplashAtWaterlineOnce-CutsceneKnux_LBZ2_Index
                dc.w    S3LBZScene_ApplyBGDeltaAndGravity-CutsceneKnux_LBZ2_Index
; ---------------------------------------------------------------------------

S3LBZScene_InitAct2AndFourPillars:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bset    #0,render_flags(a0)
                move.b  #$20,mapping_frame(a0)
                bsr.w   SpawnKnucklesCutsceneMusicTransition
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     S3KnuxScene_LBZWobblingPillars(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

S3LBZScene_WaitForAct2Signal:
                btst    #1,$38(a0)
                bne.s   S3LBZScene_SelectReactionAndCallback
                rts
; ---------------------------------------------------------------------------

S3LBZScene_SelectReactionAndCallback:
                move.b  #4,routine(a0)
                move.l  #S3LBZScene_FaceRightAndResetIdle,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3LBZScene_AnimateReaction:
                lea     S3KnuxScene_LBZSecondSceneAnim(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

S3LBZScene_FaceRightAndResetIdle:
                move.b  #6,routine(a0)
                bclr    #0,render_flags(a0)
                bra.w   S3AIZScene_ResetSharedIdleAnim
; ---------------------------------------------------------------------------

S3LBZScene_SelectShakeAnim:
                tst.b   (Screen_shake_flag).w
                beq.s   S3LBZScene_AnimateAfterShakeCheck
                move.b  #8,routine(a0)
                move.l  #S3KnuxScene_LBZIdleAnim,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)

S3LBZScene_AnimateAfterShakeCheck:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

S3LBZScene_FollowBGUntilPillarRelease:
                btst    #3,$38(a0)
                bne.s   S3LBZScene_BeginFallAndTryMusicFade
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

S3LBZScene_BeginFallAndTryMusicFade:
                move.b  #$A,routine(a0)
                bset    #0,render_flags(a0)
                move.b  #9,mapping_frame(a0)
                move.w  #$200,x_vel(a0)
                move.w  #-$100,y_vel(a0)
                jsr     (AllocateObject).l
                bne.s   S3LBZScene_ReleaseMusicReturn
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

S3LBZScene_ReleaseMusicReturn:
                rts
; ---------------------------------------------------------------------------

S3LBZScene_SplashAtWaterlineOnce:
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   S3LBZScene_ApplyBGDeltaAndGravity
                moveq   #signextendB(sfx_Splash),d0
                jsr     (Play_SFX).l
                move.b  #$C,routine(a0)

S3LBZScene_ApplyBGDeltaAndGravity:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jmp     (MoveSprite_LightGravity).l
; ---------------------------------------------------------------------------

S3LBZScene_InitPillarMotionAndRestX:
                lea     S3KnuxScene_LBZPillarAttrs(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #S3LBZScene_WaitForShakeToMovePillar,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.l  S3LBZScene_PillarMotionPairs(pc,d0.w),$3E(a0)
                lsl.w   #3,d0
                add.w   d0,y_pos(a0)
                move.w  x_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------
S3LBZScene_PillarMotionPairs:
                dc.w    $100,   $10
                dc.w    $C0,    $C
                dc.w    $80,     8
                dc.w    $40,     4
; ---------------------------------------------------------------------------

S3LBZScene_WaitForShakeToMovePillar:
                tst.b   (Screen_shake_flag).w
                beq.s   S3LBZScene_DrawWaitingPillar
                move.l  #S3LBZScene_ApplyBGDeltaAndCheckRestSide,(a0)
                move.w  $3E(a0),x_vel(a0)
                move.b  #6,$39(a0)

S3LBZScene_DrawWaitingPillar:
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

S3LBZScene_ApplyBGDeltaAndCheckRestSide:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                move.w  x_pos(a0),d0
                move.w  $40(a0),d1
                cmp.w   $3A(a0),d0
                scs     d2
                bcs.s   S3LBZScene_AccelerateAndCheckSide
                neg.w   d1

S3LBZScene_AccelerateAndCheckSide:
                add.w   d1,x_vel(a0)
                cmp.b   $3C(a0),d2
                beq.s   S3LBZScene_MovePillarAndMaybeCarryX
                move.b  d2,$3C(a0)
                cmpi.b  #3,$39(a0)
                bne.s   S3LBZScene_TickCrossingsAndSignalParent
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.l  S3LBZScene_FastPillarMotionPairs(pc,d0.w),$3E(a0)
                move.w  $3E(a0),x_vel(a0)

S3LBZScene_TickCrossingsAndSignalParent:
                subq.b  #1,$39(a0)
                bne.s   S3LBZScene_MovePillarAndMaybeCarryX
                move.l  #S3LBZScene_FallPillarWithBGAndCull,(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)

S3LBZScene_MovePillarAndMaybeCarryX:
                jsr     (MoveSprite2).l
                tst.b   subtype(a0)
                bne.s   S3LBZScene_CullOrDrawPillar
                movea.w parent3(a0),a1
                move.w  x_pos(a0),x_pos(a1)

S3LBZScene_CullOrDrawPillar:
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------
S3LBZScene_FastPillarMotionPairs:
                dc.w    $200,   $20
                dc.w    $180,   $18
                dc.w    $100,   $10
                dc.w    $80,     8
; ---------------------------------------------------------------------------

S3LBZScene_FallPillarWithBGAndCull:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l
; End of function S3LBZScene_FallPillarWithBGAndCull
