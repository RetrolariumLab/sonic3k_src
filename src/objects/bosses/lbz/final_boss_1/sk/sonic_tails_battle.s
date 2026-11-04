; Owner: objects/bosses/lbz/final_boss_1/sk
; Responsibility: Launch Base first final-boss battle controller, attack state and helper callbacks for Sonic or Tails
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZFinalBoss1:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZFinalBoss1_Index(pc,d0.w),d1
                jsr     LBZFinalBoss1_Index(pc,d1.w)
                bsr.w   LBZBoss1_HandleHitOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
LBZFinalBoss1_Index:
                dc.w    LBZBoss1SK_InitBossAndChildren-LBZFinalBoss1_Index
                dc.w    LBZFinalBoss1SK_Root_CountInitialWait-LBZFinalBoss1_Index
                dc.w    LBZBoss1SK_CheckLowerPassBoundary-LBZFinalBoss1_Index
                dc.w    LBZBoss1SK_HoldDuringHit-LBZFinalBoss1_Index
                dc.w    LBZBoss1SK_TickSectionDropPause-LBZFinalBoss1_Index
                dc.w    LBZBoss1SK_StepSectionDrop-LBZFinalBoss1_Index
; ---------------------------------------------------------------------------

LBZBoss1SK_InitBossAndChildren:
                lea     ObjDat_LBZFinalBoss1(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #9,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.l  #LBZBoss1SK_BeginVerticalPass,$34(a0)
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   LBZBoss1SK_SpawnBossChildGroups
                move.w  #$7F,$2E(a0)
                st      (Update_HUD_timer).w
                moveq   #PLCID_71,d0
                jsr     (Load_PLC).l
                jsr     (AllocateObject).l
                bne.s   LBZBoss1SK_SpawnBossChildGroups
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

LBZBoss1SK_SpawnBossChildGroups:
                lea     (Child1_MakeRoboHead3).l,a2
                jsr     (CreateChild1_Normal).l
                lea     LBZBoss1SK_TopTrimChild(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     LBZBoss1SK_BodySectionChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     LBZBoss1SK_OrbiterChild(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

LBZFinalBoss1SK_Root_CountInitialWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBoss1SK_BeginVerticalPass:
                move.b  #4,routine(a0)
                move.w  #-$100,y_vel(a0)
                lea     Pal_LBZFinalBoss1(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

LBZBoss1SK_CheckLowerPassBoundary:
                move.w  y_pos(a0),d0
                move.w  (Camera_Y_pos).w,d1
                tst.w   y_vel(a0)
                bmi.s   LBZBoss1SK_CheckUpperPassBoundary
                addi.w  #$118,d1
                cmp.w   d1,d0
                bhs.s   LBZBoss1SK_CheckTurnaroundWindow
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

LBZBoss1SK_CheckUpperPassBoundary:
                subi.w  #$B0,d1
                cmp.w   d1,d0
                bls.s   LBZBoss1SK_CheckTurnaroundWindow
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

; Above two remaining hits, reverse only during the cannon window
LBZBoss1SK_CheckTurnaroundWindow:
                cmpi.b  #2,collision_property(a0)
                bls.s   LBZBoss1SK_ChooseRandomPassSide
                btst    #3,$38(a0)
                beq.s   LBZBoss1SK_TurnaroundReturn

LBZBoss1SK_ChooseRandomPassSide:
                jsr     (Random_Number).l
                swap    d0
                moveq   #0,d1
                bclr    #0,render_flags(a0)
                btst    #0,d0
                beq.s   LBZBoss1SK_ApplySideAndReverseY
                moveq   #2,d1
                bset    #0,render_flags(a0)

LBZBoss1SK_ApplySideAndReverseY:
                move.w  LBZBoss1SK_PassSideCameraXOffsets(pc,d1.w),d1
                move.w  (Camera_X_pos).w,d2
                add.w   d1,d2
                move.w  d2,x_pos(a0)
                move.w  #$100,d0
                tst.w   y_vel(a0)
                bmi.s   LBZBoss1SK_StoreReversedYSpeed
                neg.w   d0

LBZBoss1SK_StoreReversedYSpeed:
                move.w  d0,y_vel(a0)

LBZBoss1SK_TurnaroundReturn:
                rts
; ---------------------------------------------------------------------------
LBZBoss1SK_PassSideCameraXOffsets:
                dc.w    $110
                dc.w    $30
; ---------------------------------------------------------------------------

LBZBoss1SK_HoldDuringHit:
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_TickSectionDropPause:
                subq.b  #1,$40(a0)
                bmi.s   LBZBoss1SK_BeginSectionDrop
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_BeginSectionDrop:
                move.b  #$A,routine(a0)
                move.b  #4,$40(a0)

LBZBoss1SK_SharedReturn:
                rts
; ---------------------------------------------------------------------------

; Move eight pixels down on each of five updates before returning to the hit hold
LBZBoss1SK_StepSectionDrop:
                addq.w  #8,y_pos(a0)
                subq.b  #1,$40(a0)
                bmi.s   LBZBoss1SK_ResumeHitHold
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_ResumeHitHold:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingDescendToCameraY:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$140,d1
                cmp.w   d1,d0
                bhs.s   LBZBoss1SK_EndingBeginPoseDelay
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingBeginPoseDelay:
                move.l  #LBZBoss1SK_EndingWaitGroundedAndScore,(a0)
                move.w  #$3F,$2E(a0)
                st      (Ctrl_2_locked).w
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingWaitGroundedAndScore:
                subq.w  #1,$2E(a0)
                bpl.s   LBZBoss1SK_EndingPoseSetupReturn
                lea     (Player_1).w,a1
                btst    #7,status(a1)
                bne.s   LBZBoss1SK_EndingPoseSetupReturn
                btst    #Status_InAir,status(a1)
                bne.s   LBZBoss1SK_EndingPoseSetupReturn
                cmpi.b  #6,routine(a1)
                bhs.s   LBZBoss1SK_EndingPoseSetupReturn
                move.l  #LBZBoss1SK_EndingWaitResultsAndMusic,(a0)
                jsr     (Set_PlayerEndingPose).l
                clr.b   (End_of_level_flag).w
                jsr     (AllocateObject).l
                bne.s   LBZBoss1SK_EndingTryP2PoseHelper
                move.l  #Obj_LevelResults,(a1)

LBZBoss1SK_EndingTryP2PoseHelper:
                jsr     (AllocateObject).l
                bne.s   LBZBoss1SK_EndingPoseSetupReturn
                move.l  #LBZBoss1SK_EndingWaitForP2Grounded,(a1)

LBZBoss1SK_EndingPoseSetupReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingWaitResultsAndMusic:
                tst.b   (End_of_level_flag).w
                beq.w   LBZBoss1SK_SharedReturn
                move.l  #LBZBoss1SK_EndingRestoreAndLockInput,(a0)
                jsr     (Restore_LevelMusic).l
                move.w  #$1F,$2E(a0)
                lea     (PLC_BossExplosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingRestoreAndLockInput:
                subq.w  #1,$2E(a0)
                bpl.w   LBZBoss1SK_SharedReturn
                move.l  #LBZBoss1SK_EndingCenterGroundedPlayer,(a0)
                bset    #5,$38(a0)
                move.w  a0,(_unkFAA4).w
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                st      (Ctrl_1_locked).w
                clr.w   (Ctrl_1_logical).w
                jsr     (AllocateObject).l
                bne.s   LBZBoss1SK_EndingQueueDeathEggArt
                move.l  #SKInput_LockP2IfActive,(a1)

LBZBoss1SK_EndingQueueDeathEggArt:
                lea     (ArtKosM_LBZ2DeathEggSmall).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZ2DeathEggSmall),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingCenterGroundedPlayer:
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   LBZBoss1SK_EndingCenteringReturn
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                sub.w   x_pos(a1),d0
                scs     d2
                bpl.s   LBZBoss1SK_EndingChooseCenterDirection
                neg.w   d0

LBZBoss1SK_EndingChooseCenterDirection:
                cmpi.w  #4,d0
                blo.s   LBZBoss1SK_EndingStopPlayerAndSpawnBurst
                moveq   #button_right,d1
                tst.b   d2
                beq.s   LBZBoss1SK_EndingSetHeldDirection
                moveq   #button_left,d1

LBZBoss1SK_EndingSetHeldDirection:
                bset    d1,(Ctrl_1_held_logical).w

LBZBoss1SK_EndingCenteringReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingStopPlayerAndSpawnBurst:
                move.l  #LBZBoss1SK_EndingTakeAnimationControl,(a0)
                clr.b   (_unkFA88).w
                jsr     (Stop_Object).l
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                lea     LBZBoss1SK_EndingBurstChildren(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingTakeAnimationControl:
                btst    #0,(_unkFA88).w
                beq.s   LBZBoss1SK_EndingAnimSetupReturn
                move.l  #LBZBoss1SK_EndingAnimateBothPlayers,(a0)
                move.l  #LBZBoss1SK_EndingInstallFallFlagPoll,$34(a0)
                lea     (Player_1).w,a1
                bsr.w   LBZEnding_InitExternalPlayerAnim
                lea     (Player_2).w,a1
; Bug: this tries to hide Tails' tails by clearing his anim, but Tails is
; in a1. loc_72C9E fixes this, but only for player 2. Conversely, S3 only
; clears player 1's anim here, as P2 is absent from the final boss
                clr.b   anim(a0)

LBZEnding_InitExternalPlayerAnim:
                move.b  #$83,object_control(a1)
                clr.b   anim_frame_timer(a1)
                clr.b   anim_frame(a1)

LBZBoss1SK_EndingAnimSetupReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingAnimateBothPlayers:
                lea     (Player_1).w,a1
                lea     LBZBoss1SK_EndingP1FrameFlipAnim(pc),a2
                jsr     (Animate_ExternalPlayerSprite).l
                lea     (Player_2).w,a1
                clr.b   anim(a1)
                lea     LBZBoss1SK_EndingP2FrameFlipAnim(pc),a2
                jmp     (Animate_ExternalPlayerSprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingInstallFallFlagPoll:
                move.l  #LBZBoss1SK_EndingWaitDeathEggFall,(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingWaitDeathEggFall:
                btst    #1,(_unkFA88).w
                beq.s   LBZBoss1SK_EndingFallPollReturn
                move.l  #LBZBoss1SK_EndingStartNextLevel,(a0)
                st      (Events_fg_5).w

LBZBoss1SK_EndingFallPollReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingStartNextLevel:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   (Player_1+y_pos).w,d0
                bhi.w   LBZBoss1SK_SharedReturn
                move.w  #$700,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingWaitForP2Grounded:
                lea     (Player_2).w,a1
                btst    #7,status(a1)
                bne.s   LBZBoss1SK_EndingP2PoseReturn
                btst    #Status_InAir,status(a1)
                bne.s   LBZBoss1SK_EndingP2PoseReturn
                cmpi.b  #6,routine(a1)
                blo.s   LBZBoss1SK_EndingSetP2PoseAndDelete

LBZBoss1SK_EndingP2PoseReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingSetP2PoseAndDelete:
                jsr     (Set_PlayerEndingPose).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_InitBurstController:
                move.l  #LBZBoss1SK_BurstTryPeriodicExplosion,(a0)
                move.w  #$4430,x_pos(a0)
                move.w  #$728,y_pos(a0)
                move.w  #$1010,$3A(a0)
                move.w  #$200,d0
                tst.b   subtype(a0)
                beq.s   LBZBoss1SK_BurstSetHorizontalLeg
                neg.w   d0

LBZBoss1SK_BurstSetHorizontalLeg:
                move.w  d0,x_vel(a0)
                move.w  #$41,$2E(a0)
                move.l  #LBZBoss1SK_BurstBeginUpwardLeg,$34(a0)

LBZBoss1SK_BurstTryPeriodicExplosion:
                subq.b  #1,$39(a0)
                bpl.s   LBZBoss1SK_BurstMoveAndTickWait
                move.b  #3,$39(a0)
                jsr     (BossExplosionSKSpawnAtMaskedRandomOffset).l

LBZBoss1SK_BurstMoveAndTickWait:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBoss1SK_BurstBeginUpwardLeg:
                clr.w   x_vel(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$57,$2E(a0)
                move.l  #LBZBoss1SK_BurstTryFinalExplosion,$34(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_BurstTryFinalExplosion:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   LBZBoss1SK_BurstTryEndingCoordinator
                move.w  #$4430,x_pos(a1)
                move.w  #$678,y_pos(a1)
                move.b  #$C,subtype(a1)

; Only the controller with subtype zero creates the ending coordinator
LBZBoss1SK_BurstTryEndingCoordinator:
                tst.b   subtype(a0)
                bne.s   LBZBoss1SK_BurstQueueDeletion
                jsr     (AllocateObject).l
                bne.s   LBZBoss1SK_BurstQueueDeletion
                move.l  #LBZBoss1SK_EndingTickDebrisIntervals,(a1)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$D0,d0
                move.w  d0,x_pos(a1)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a1)
                move.w  #5,$3A(a1)

LBZBoss1SK_BurstQueueDeletion:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingTickDebrisIntervals:
                subq.w  #1,$2E(a0)
                bpl.s   LBZBoss1SK_EndingDebrisUpdateReturn
                addq.b  #1,$39(a0)
                cmpi.b  #8,$39(a0)
                bne.s   LBZBoss1SK_EndingTryDebrisOrPause
                st      (Events_fg_5).w

LBZBoss1SK_EndingTryDebrisOrPause:
                cmpi.b  #$18,$39(a0)
                bhs.s   LBZBoss1SK_EndingBeginLongPause
                move.w  $3A(a0),$2E(a0)
                addq.w  #1,$3A(a0)
                jsr     (AllocateObject).l
                bne.s   LBZBoss1SK_EndingDebrisUpdateReturn
                move.l  #LBZBoss1SK_InitFallingDebris,(a1)

LBZBoss1SK_EndingDebrisUpdateReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingBeginLongPause:
                move.l  #LBZBoss1SK_EndingTickLongPause,(a0)
                move.w  #$17F,$2E(a0)

LBZBoss1SK_EndingTickLongPause:
                subq.w  #1,$2E(a0)
                bmi.s   LBZBoss1SK_EndingSignalAnimAndSpawnEgg
                rts
; ---------------------------------------------------------------------------

LBZBoss1SK_EndingSignalAnimAndSpawnEgg:
                bset    #0,(_unkFA88).w
                clr.b   $39(a0)
                clr.w   $2E(a0)
                lea     LBZBoss1SK_DeathEggPieceChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_InitFallingDebris:
                lea     LBZBoss1SK_FallingDebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MoveChkDel,(a0)
                jsr     (Random_Number).l
                andi.w  #7,d0
                move.b  LBZBoss1SK_FallingDebrisFrames(pc,d0.w),mapping_frame(a0)
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
LBZBoss1SK_FallingDebrisFrames:
                dc.b    7,   8,   9,  $A,  $B,   7,   8,   9
                even
; ---------------------------------------------------------------------------

LBZBoss1SK_InitDeathEggPiece:
                lea     LBZBoss1SK_DeathEggPieceAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LBZBoss1SK_DeathEggEmitParticle,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                beq.s   LBZBoss1SK_DeathEggPieceLoadSubtype
                move.l  #LBZBoss1SK_DeathEggPieceMoveAndDraw,(a0)

LBZBoss1SK_DeathEggPieceLoadSubtype:
                move.w  LBZBoss1SK_DeathEggPieceYSpeeds(pc,d0.w),y_vel(a0)
                lea     LBZBoss1SK_DeathEggPieceFrameFlips(pc,d0.w),a1
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,d0
                or.b    d0,render_flags(a0)
                lea     Pal_LBZEnding(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------
LBZBoss1SK_DeathEggPieceFrameFlips:
                dc.b    0,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    2,   0
                dc.b    2,   1
                dc.b    2,   2
                dc.b    2,   3
LBZBoss1SK_DeathEggPieceYSpeeds:
                dc.w    $40
                dc.w    $38
                dc.w    $3C
                dc.w    $40
                dc.w    $44
                dc.w    $48
                dc.w    $4C
                dc.w    $50
; ---------------------------------------------------------------------------

; The periodic spawn uses the returned child pointer directly for its random offsets
LBZBoss1SK_DeathEggEmitParticle:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   LBZBoss1SK_DeathEggCheckFallThreshold
                lea     LBZBoss1SK_DeathEggParticleChild(pc),a2
                jsr     (CreateChild6_Simple).l
                jsr     (Random_Number).l
                andi.w  #$1F,d0
                subi.w  #$10,d0
                add.w   d0,x_pos(a1)
                swap    d0
                andi.w  #$1F,d0
                subi.w  #$10,d0
                add.w   d0,y_pos(a1)

; Compare the pre-move position against camera Y plus $80
LBZBoss1SK_DeathEggCheckFallThreshold:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmp.w   y_pos(a0),d0
                bhs.s   LBZBoss1SK_DeathEggPieceMoveAndDraw
                bset    #1,(_unkFA88).w

LBZBoss1SK_DeathEggPieceMoveAndDraw:
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_InitDeathEggParticle:
                lea     LBZBoss1SK_DeathEggParticleAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LBZBoss1SK_DeathEggParticleTickFlip,(a0)
                move.w  #-$40,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                lea     LBZBoss1SK_DeathEggNestedParticleChild(pc),a2
                jsr     (CreateChild6_Simple).l

LBZBoss1SK_DeathEggParticleTickFlip:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   LBZBoss1SK_DeathEggParticleMoveAndWait
                move.b  $39(a0),d0
                addq.b  #1,d0
                move.b  d0,$39(a0)
                andi.b  #3,d0
                move.b  render_flags(a0),d1
                andi.b  #$FC,d1
                or.b    d0,d1
                move.b  d1,render_flags(a0)

LBZBoss1SK_DeathEggParticleMoveAndWait:
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss1SK_InitDeathEggNestedParticle:
                lea     LBZBoss1SK_DeathEggNestedFxAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LBZBoss1SK_NestedParticleAnimateAndMove,(a0)
                move.l  #LBZBoss1SK_DeathEggNestedParticleAnim,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$40,y_vel(a0)

LBZBoss1SK_NestedParticleAnimateAndMove:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
LBZBoss1SK_KnucklesEntryCameraBounds:
                dc.w    0,  $428, $4280, $4380
                dc.w    $328,  $328, $4300, $4300
