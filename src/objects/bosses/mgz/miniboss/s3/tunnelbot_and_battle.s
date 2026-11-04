; Owner: objects/bosses/mgz/miniboss/s3
; Responsibility: Marble Garden Tunnelbot and miniboss state machines, spawned spires, movement helpers and private palette constants
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Tunnelbot:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Tunnelbot_Index(pc,d0.w),d1
                jsr     Tunnelbot_Index(pc,d1.w)
                bsr.w   HandleMGZTunnelbotHitFlashOrDefeat
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Tunnelbot_Index:
                dc.w    MGZMiniS3_InitTunnelbotAndCollision-Tunnelbot_Index
                dc.w    MGZMiniS3_TunnelSwingUntilPlayerNear-Tunnelbot_Index
                dc.w    MGZMiniS3_SwingMoveAndSpinUp-Tunnelbot_Index
                dc.w    MGZMiniS3_AscendAndProbeCeiling-Tunnelbot_Index
                dc.w    MGZMiniS3_AnimateAndChooseUpJitter-Tunnelbot_Index
; ---------------------------------------------------------------------------

MGZMiniS3_InitTunnelbotAndCollision:
                lea     ObjDat_Tunnelbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #-2,collision_property(a0)
                move.b  #$28,y_radius(a0)
                jsr     (Swing_Setup1).l
                lea     MGZMiniS3_SideCollisionChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

MGZMiniS3_TunnelSwingUntilPlayerNear:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.w   MGZMiniS3_SharedGateReturn
                move.b  #4,routine(a0)
                move.l  #MGZMiniS3_DrillAccelerateAnim,$30(a0)
                move.l  #MGZMiniS3_TunnelBeginCeilingAscent,$34(a0)

MGZMiniS3_SharedGateReturn:
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_SwingMoveAndSpinUp:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     Animate_RawGetFaster(pc)
; ---------------------------------------------------------------------------

MGZMiniS3_TunnelBeginCeilingAscent:
                move.b  #6,routine(a0)
                move.l  #MGZMiniS3_DrillSpinAnim,$30(a0)
                move.l  #MGZMiniS3_TunnelBeginLongTremor,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_AscendAndProbeCeiling:
                jsr     Animate_Raw(pc)
                subq.w  #1,y_pos(a0)
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   MGZMiniS3_CeilingCheckReturn
                movea.l $34(a0),a1
                jsr     (a1)

MGZMiniS3_CeilingCheckReturn:
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_TunnelBeginLongTremor:
                move.b  #8,routine(a0)
                st      (Screen_shake_flag).w
                move.w  #$BF,$2E(a0)
                move.l  #MGZMiniS3_SignalLevelAndDeleteTunnelbot,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_AnimateAndChooseUpJitter:
                jsr     Animate_Raw(pc)
                moveq   #-2,d0
                move.b  (V_int_run_count+3).w,d1
                btst    #0,d1
                beq.s   MGZMiniS3_ApplyUpJitterAndTryDebris
                moveq   #1,d0

MGZMiniS3_ApplyUpJitterAndTryDebris:
                add.w   d0,y_pos(a0)
                andi.b  #7,d1
                bne.s   MGZMiniS3_TickUpTremorWait
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l
                bsr.w   SpawnMGZTremorDebrisAtRandomScreenX

MGZMiniS3_TickUpTremorWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

MGZMiniS3_SignalLevelAndDeleteTunnelbot:
                clr.w   (Screen_shake_flag).w
                st      (Level_trigger_array+8).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

Obj_MGZMiniboss:
                lea     MGZMiniS3_FightCameraTriggerRect(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZMiniboss_Index(pc,d0.w),d1
                jsr     MGZMiniboss_Index(pc,d1.w)
                bsr.w   HandleMGZTunnelbotHitFlashOrDefeat
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
MGZMiniboss_Index:
                dc.w    MGZMiniS3_InitFightHealthAndCamera-MGZMiniboss_Index
                dc.w    MGZMiniS3_SwingUntilCameraReady-MGZMiniboss_Index
                dc.w    MGZMiniS3_SwingMoveAndSpinUp-MGZMiniboss_Index
                dc.w    MGZMiniS3_AscendAndProbeCeiling-MGZMiniboss_Index
                dc.w    MGZMiniS3_AnimateAndChooseUpJitter-MGZMiniboss_Index
                dc.w    MGZMiniS3_TickReappearWait-MGZMiniboss_Index
                dc.w    MGZMiniS3_AnimateAndChooseDownJitter-MGZMiniboss_Index
                dc.w    MGZMiniS3_StepDownAnimateAndWait-MGZMiniboss_Index
                dc.w    MGZMiniS3_StepUpAnimateAndWait-MGZMiniboss_Index
                dc.w    MGZMiniS3_BobMoveAnimateAndWait-MGZMiniboss_Index
MGZMiniS3_FightCameraTriggerRect:
                dc.w    $D20,  $EC0, $2B80, $3080
; ---------------------------------------------------------------------------

MGZMiniS3_InitFightHealthAndCamera:
                lea     ObjDat_Tunnelbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,collision_property(a0)
                move.b  #$28,y_radius(a0)
                move.w  #$2E00,(Camera_max_X_pos).w
                move.w  #$E10,(Camera_target_max_Y_pos).w
                move.w  #$2E00,$3A(a0)
                move.l  #MGZMiniS3_BeginFightSpinUp,$34(a0)
                jsr     (Swing_Setup1).l
                bset    #1,$38(a0)
                lea     PLC_MGZMiniboss(pc),a1
                jsr     (Load_PLC_Raw).l
                jsr     (AllocateObject).l
                bne.s   MGZMiniS3_SpawnFightCollisionChildren
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

MGZMiniS3_SpawnFightCollisionChildren:
                lea     MGZMiniS3_SideCollisionChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

MGZMiniS3_SwingUntilCameraReady:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (S3EndCamera_TrackMinXAndCheckY).l
; ---------------------------------------------------------------------------

MGZMiniS3_BeginFightSpinUp:
                move.b  #4,routine(a0)
                move.l  #MGZMiniS3_DrillAccelerateAnim,$30(a0)
                move.l  #MGZMiniS3_FightBeginCeilingAscent,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_FightBeginCeilingAscent:
                move.b  #6,routine(a0)
                move.l  #MGZMiniS3_DrillSpinAnim,$30(a0)
                move.l  #MGZMiniS3_FightBeginShortTremor,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_FightBeginShortTremor:
                move.b  #8,routine(a0)
                st      (Screen_shake_flag).w
                move.w  #$7F,$2E(a0)
                move.l  #MGZMiniS3_StopShakeAndSetReappearWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_StopShakeAndSetReappearWait:
                move.b  #$A,routine(a0)
                clr.w   (Screen_shake_flag).w
                move.w  #$3F,$2E(a0)
                move.l  #MGZMiniS3_ReappearAndTrySpire,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_TickReappearWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

; Choose one of eight X offsets from the camera, then check the profile's spire gate
MGZMiniS3_ReappearAndTrySpire:
                move.b  #$C,routine(a0)
                bset    #1,render_flags(a0)
                st      (Screen_shake_flag).w
                move.w  #$7F,$2E(a0)
                move.l  #MGZMiniS3_ChooseDownStepDuration,$34(a0)
                move.w  (Camera_X_pos).w,x_pos(a0)
                jsr     (Random_Number).l
                andi.w  #$E,d0
                move.w  MGZMiniS3_ReappearCameraXOffsets(pc,d0.w),d1
                add.w   d1,x_pos(a0)
                subi.w  #$40,y_pos(a0)
                tst.b   (_unkFA80+1).w
                beq.s   MGZMiniS3_ReappearReturn
                move.w  d0,d3
                lea     MGZMiniS3_MovingSpireChild(pc),a2
                jsr     CreateChild1_Normal(pc)
                cmpi.w  #8,d3
                bhs.s   MGZMiniS3_ReappearReturn
                bset    #0,render_flags(a1)

MGZMiniS3_ReappearReturn:
                rts
; ---------------------------------------------------------------------------
MGZMiniS3_ReappearCameraXOffsets:
                dc.w    $30,   $48,   $60,   $78,   $C8,   $E0,   $F8,  $110
; ---------------------------------------------------------------------------

MGZMiniS3_AnimateAndChooseDownJitter:
                jsr     Animate_Raw(pc)
                moveq   #2,d0
                move.b  (V_int_run_count+3).w,d1
                btst    #0,d1
                beq.s   MGZMiniS3_ApplyDownJitterAndTryDebris
                moveq   #-1,d0

MGZMiniS3_ApplyDownJitterAndTryDebris:
                add.w   d0,y_pos(a0)
                andi.b  #7,d1
                bne.s   MGZMiniS3_TickDownTremorWait
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l
                bsr.w   SpawnMGZTremorDebrisAtRandomScreenX

MGZMiniS3_TickDownTremorWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

MGZMiniS3_ChooseDownStepDuration:
                move.b  #$E,routine(a0)
                clr.w   (Screen_shake_flag).w
                tst.b   (_unkFA80+1).w
                bne.s   MGZMiniS3_BeginShortDownStep
                move.w  #$2F,$2E(a0)
                move.l  #MGZMiniS3_BeginTimedUpStep,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_BeginShortDownStep:
                move.w  #$17,$2E(a0)
                move.l  #MGZMiniS3_BeginBobBeforeFlipReset,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_StepDownAnimateAndWait:
                addq.w  #4,y_pos(a0)
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

MGZMiniS3_BeginTimedUpStep:
                move.b  #$10,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZMiniS3_BeginBobBeforeFlipReset,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_StepUpAnimateAndWait:
                jsr     Animate_Raw(pc)
                subq.w  #1,y_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

MGZMiniS3_BeginBobBeforeFlipReset:
                move.b  #$12,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZMiniS3_ClearYFlipAndWait,$34(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

MGZMiniS3_BobMoveAnimateAndWait:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

MGZMiniS3_ClearYFlipAndWait:
                bclr    #1,render_flags(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MGZMiniS3_RestartFightCeilingAscent,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_RestartFightCeilingAscent:
                move.b  #6,routine(a0)
                move.l  #MGZMiniS3_FightBeginShortTremor,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_StartSignControlAndFragments:
                jsr     (Obj_EndSignControl).l
                lea     MGZMiniS3_DefeatFragmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZMiniS3_InitCollisionChild:
                move.l  #MGZMiniS3_CollisionChildFollowAndTouch,(a0)
                move.b  #$9E,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_CollisionChildFollowAndTouch:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   MGZMiniS3_CollisionChildDelete
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

MGZMiniS3_CollisionChildDelete:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

MGZMiniS3_InitRandomTremorDebris:
                lea     MGZMiniS3_TremorDebrisAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bset    #3,shield_reaction(a0)
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,mapping_frame(a0)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   MGZMiniS3_DebrisBeginLightGravity
                tst.b   d0
                bne.s   MGZMiniS3_DebrisBeginLightGravity
                lea     MGZMiniS3_TremorSpireAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)

MGZMiniS3_DebrisBeginLightGravity:
                move.l  #MoveDraw_SpriteTimed2,(a0)
                move.w  #$5F,$2E(a0)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

MGZMiniS3_InitMovingSpireAtCamera:
                lea     MGZMinibossS3_MovingSpire_FullAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #MGZMiniS3_SpireMoveSolidAndAnimate,(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$30,d0
                btst    #0,render_flags(a0)
                beq.s   MGZMiniS3_SpireSaveOriginAndWait
                addi.w  #$E0,d0

MGZMiniS3_SpireSaveOriginAndWait:
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$F0,d0
                move.w  d0,y_pos(a0)
                move.w  d0,$3A(a0)
                clr.b   routine(a0)
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_SpireMoveSolidAndAnimate:
                btst    #4,$38(a0)
                bne.w   MGZMiniS3_SpireReleaseRidersAndDelete
                move.w  x_pos(a0),-(sp)
                bsr.w   UpdateMGZMinibossSpireMotionState
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.w  #1|2,d6
                beq.s   MGZMiniS3_SpireTickFourFrameLoop
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   MGZMiniS3_SpireCheckP2SideAndHurt
                bclr    #5,status(a0)
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$28,d0
                bmi.s   MGZMiniS3_SpireCheckP2SideAndHurt
                jsr     (HurtPlayerFromSolidHazard).l

MGZMiniS3_SpireCheckP2SideAndHurt:
                andi.b  #2,d6
                beq.s   MGZMiniS3_SpireTickFourFrameLoop
                bclr    #6,status(a0)
                lea     (Player_2).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$28,d0
                bmi.s   MGZMiniS3_SpireTickFourFrameLoop
                jsr     (HurtPlayerFromSolidHazard).l

MGZMiniS3_SpireTickFourFrameLoop:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   MGZMiniS3_SpireDraw
                move.b  #7,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

MGZMiniS3_SpireDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MGZMiniS3_SpireReleaseRidersAndDelete:
                jsr     Displace_PlayerOffObject(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

MGZMiniS3_InitDefeatFragment:
                lea     MGZMiniS3_DefeatFragmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  MGZMiniS3_FragmentFramesBySubtype(pc,d0.w),mapping_frame(a0)
                moveq   #4,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
MGZMiniS3_FragmentFramesBySubtype:
                dc.b    4,   3,   5,   6,   6
                even

; =============== S U B R O U T I N E =======================================

UpdateMGZMinibossSpireMotionState:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZMiniS3_SpireStateOffsets(pc,d0.w),d1
                jmp     MGZMiniS3_SpireStateOffsets(pc,d1.w)
; End of function UpdateMGZMinibossSpireMotionState

; ---------------------------------------------------------------------------
MGZMiniS3_SpireStateOffsets:
                dc.w    MGZMiniS3_SpireRiseAndPause-MGZMiniS3_SpireStateOffsets
                dc.w    MGZMiniS3_SpirePauseAndChooseDrift-MGZMiniS3_SpireStateOffsets
                dc.w    MGZMiniS3_SpireSwingAndPause-MGZMiniS3_SpireStateOffsets
                dc.w    MGZMiniS3_SpirePauseBeforeSink-MGZMiniS3_SpireStateOffsets
                dc.w    MGZMiniS3_SpireSinkToBaseline-MGZMiniS3_SpireStateOffsets
; ---------------------------------------------------------------------------

MGZMiniS3_SpireRiseAndPause:
                subq.w  #4,y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.w   MGZMiniS3_SharedGateReturn
                move.b  #2,routine(a0)
                move.w  #$3F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_SpirePauseAndChooseDrift:
                subq.w  #1,$2E(a0)
                bpl.w   MGZMiniS3_SharedGateReturn
                move.b  #4,routine(a0)
                move.w  #$100,d0
                btst    #0,render_flags(a0)
                beq.s   MGZMiniS3_SpireAddDriftAndResetSwing
                neg.w   d0

MGZMiniS3_SpireAddDriftAndResetSwing:
                add.w   d0,x_vel(a0)
                move.w  #$DF,$2E(a0)
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_SpireSwingAndPause:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.w   MGZMiniS3_SharedGateReturn
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_SpirePauseBeforeSink:
                subq.w  #1,$2E(a0)
                bpl.w   MGZMiniS3_SharedGateReturn
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_SpireSinkToBaseline:
                move.w  y_pos(a0),d0
                addq.w  #2,d0
                move.w  d0,y_pos(a0)
                cmp.w   $3A(a0),d0
                blo.w   MGZMiniS3_SharedGateReturn
                bset    #4,$38(a0)
                rts

; =============== S U B R O U T I N E =======================================

SpawnMGZTremorDebrisAtRandomScreenX:
                lea     MGZMiniS3_TremorDebrisChild(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   MGZMiniS3_TremorDebrisSpawnReturn
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                move.w  (Camera_X_pos).w,d1
                subi.w  #$40,d1
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a1)

MGZMiniS3_TremorDebrisSpawnReturn:
                rts
; End of function SpawnMGZTremorDebrisAtRandomScreenX

; =============== S U B R O U T I N E =======================================

HandleMGZTunnelbotHitFlashOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   MGZMiniS3_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   MGZMiniS3_BeginScoredDefeatWait
                tst.b   $20(a0)
                bne.s   MGZMiniS3_HitChooseFlashRow
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

MGZMiniS3_HitChooseFlashRow:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   MGZMiniS3_HitCopyColorsAndTick
                addq.w  #2*3,d0

MGZMiniS3_HitCopyColorsAndTick:
                lea     MGZMiniS3_HitPaletteDestinations(pc),a1
                lea     MGZMiniS3_HitPaletteColorRows(pc,d0.w),a2
                jsr     CopyWordData_3(pc)
                subq.b  #1,$20(a0)
                bne.s   MGZMiniS3_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

MGZMiniS3_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

MGZMiniS3_BeginScoredDefeatWait:
                move.l  #Wait_Draw,(a0)
                clr.w   (Screen_shake_flag).w
                move.l  #MGZMiniS3_StartSignControlAndFragments,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     BossDefeated_StopTimer(pc)
; End of function HandleMGZTunnelbotHitFlashOrDefeat

; ---------------------------------------------------------------------------
MGZMiniS3_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
MGZMiniS3_HitPaletteColorRows:
                dc.w    $CAA,  $866,  $644
                dc.w    $EEE,  $EEE,  $EEE
