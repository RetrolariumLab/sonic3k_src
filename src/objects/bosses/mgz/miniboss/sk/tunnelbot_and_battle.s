; Owner: objects/bosses/mgz/miniboss/sk
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
                dc.w    MGZMiniSK_InitTunnelbotAndCollision-Tunnelbot_Index
                dc.w    MGZMiniSK_TunnelSwingUntilPlayerNear-Tunnelbot_Index
                dc.w    MGZMiniSK_SwingMoveAndSpinUp-Tunnelbot_Index
                dc.w    MGZMiniSK_AscendAndProbeCeiling-Tunnelbot_Index
                dc.w    MGZMiniSK_AnimateAndChooseUpJitter-Tunnelbot_Index
; ---------------------------------------------------------------------------

MGZMiniSK_InitTunnelbotAndCollision:
                lea     ObjDat_Tunnelbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #-2,collision_property(a0)
                move.b  #$28,y_radius(a0)
                jsr     (Swing_Setup1).l
                lea     MGZMiniSK_SideCollisionChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

MGZMiniSK_TunnelSwingUntilPlayerNear:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.w   MGZMiniSK_SharedGateReturn
                move.b  #4,routine(a0)
                move.l  #MGZMiniSK_DrillAccelerateAnim,$30(a0)
                move.l  #MGZMiniSK_TunnelBeginCeilingAscent,$34(a0)

MGZMiniSK_SharedGateReturn:
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_SwingMoveAndSpinUp:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     Animate_RawGetFaster(pc)
; ---------------------------------------------------------------------------

MGZMiniSK_TunnelBeginCeilingAscent:
                move.b  #6,routine(a0)
                move.l  #MGZMiniSK_DrillSpinAnim,$30(a0)
                move.l  #MGZMiniSK_TunnelBeginLongTremor,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_AscendAndProbeCeiling:
                jsr     Animate_Raw(pc)
                subq.w  #1,y_pos(a0)
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   MGZMiniSK_CeilingCheckReturn
                movea.l $34(a0),a1
                jsr     (a1)

MGZMiniSK_CeilingCheckReturn:
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_TunnelBeginLongTremor:
                move.b  #8,routine(a0)
                st      (Screen_shake_flag).w
                move.w  #$BF,$2E(a0)
                move.l  #MGZMiniSK_SignalLevelAndDeleteTunnelbot,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_AnimateAndChooseUpJitter:
                jsr     Animate_Raw(pc)
                moveq   #-2,d0
                move.b  (V_int_run_count+3).w,d1
                btst    #0,d1
                beq.s   MGZMiniSK_ApplyUpJitterAndTryDebris
                moveq   #1,d0

MGZMiniSK_ApplyUpJitterAndTryDebris:
                add.w   d0,y_pos(a0)
                andi.b  #7,d1
                bne.s   MGZMiniSK_TickUpTremorWait
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l
                bsr.w   SpawnMGZTremorDebrisAtRandomScreenX

MGZMiniSK_TickUpTremorWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

MGZMiniSK_SignalLevelAndDeleteTunnelbot:
                clr.w   (Screen_shake_flag).w
                st      (Level_trigger_array+8).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

Obj_MGZMiniboss:
                lea     MGZMiniSK_FightCameraTriggerRect(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZMiniboss_Index(pc,d0.w),d1
                jsr     MGZMiniboss_Index(pc,d1.w)
                bsr.w   HandleMGZTunnelbotHitFlashOrDefeat
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
MGZMiniboss_Index:
                dc.w    MGZMiniSK_InitFightHealthAndCamera-MGZMiniboss_Index
                dc.w    MGZMiniSK_SwingUntilCameraReady-MGZMiniboss_Index
                dc.w    MGZMiniSK_SwingMoveAndSpinUp-MGZMiniboss_Index
                dc.w    MGZMiniSK_AscendAndProbeCeiling-MGZMiniboss_Index
                dc.w    MGZMiniSK_AnimateAndChooseUpJitter-MGZMiniboss_Index
                dc.w    MGZMiniSK_TickReappearWait-MGZMiniboss_Index
                dc.w    MGZMiniSK_AnimateAndChooseDownJitter-MGZMiniboss_Index
                dc.w    MGZMiniSK_StepDownAnimateAndWait-MGZMiniboss_Index
                dc.w    MGZMiniSK_StepUpAnimateAndWait-MGZMiniboss_Index
                dc.w    MGZMiniSK_BobMoveAnimateAndWait-MGZMiniboss_Index
MGZMiniSK_FightCameraTriggerRect:
                dc.w    $D20,  $EC0, $2B80, $3080
; ---------------------------------------------------------------------------

MGZMiniSK_InitFightHealthAndCamera:
                lea     ObjDat_Tunnelbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,collision_property(a0)
                move.b  #$28,y_radius(a0)
                move.w  #$2E00,(Camera_max_X_pos).w
                move.w  #$E10,(Camera_target_max_Y_pos).w
                move.w  #$2E00,$3A(a0)
                move.l  #MGZMiniSK_BeginFightSpinUp,$34(a0)
                jsr     (Swing_Setup1).l
                bset    #1,$38(a0)
                lea     PLC_MGZMiniboss(pc),a1
                jsr     (Load_PLC_Raw).l
                jsr     (AllocateObject).l
                bne.s   MGZMiniSK_SpawnFightCollisionChildren
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

MGZMiniSK_SpawnFightCollisionChildren:
                lea     MGZMiniSK_SideCollisionChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

MGZMiniSK_SwingUntilCameraReady:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (SKEndCamera_TrackMinXAndCheckY).l
; ---------------------------------------------------------------------------

MGZMiniSK_BeginFightSpinUp:
                move.b  #4,routine(a0)
                move.l  #MGZMiniSK_DrillAccelerateAnim,$30(a0)
                move.l  #MGZMiniSK_FightBeginCeilingAscent,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_FightBeginCeilingAscent:
                move.b  #6,routine(a0)
                move.l  #MGZMiniSK_DrillSpinAnim,$30(a0)
                move.l  #MGZMiniSK_FightBeginShortTremor,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_FightBeginShortTremor:
                move.b  #8,routine(a0)
                st      (Screen_shake_flag).w
                move.w  #$7F,$2E(a0)
                move.l  #MGZMiniSK_StopShakeAndSetReappearWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_StopShakeAndSetReappearWait:
                move.b  #$A,routine(a0)
                clr.w   (Screen_shake_flag).w
                move.w  #$3F,$2E(a0)
                move.l  #MGZMiniSK_ReappearAndTrySpire,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_TickReappearWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

; Choose one of eight X offsets from the camera, then check the profile's spire gate
MGZMiniSK_ReappearAndTrySpire:
                move.b  #$C,routine(a0)
                bset    #1,render_flags(a0)
                st      (Screen_shake_flag).w
                move.w  #$7F,$2E(a0)
                move.l  #MGZMiniSK_ChooseDownStepDuration,$34(a0)
                move.w  (Camera_X_pos).w,x_pos(a0)
                jsr     (Random_Number).l
                andi.w  #$E,d0
                move.w  MGZMiniSK_ReappearCameraXOffsets(pc,d0.w),d1
                add.w   d1,x_pos(a0)
                subi.w  #$40,y_pos(a0)
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   MGZMiniSK_ReappearReturn
                move.w  d0,d3
                lea     MGZMiniSK_MovingSpireChild(pc),a2
                jsr     CreateChild1_Normal(pc)
                cmpi.w  #8,d3
                bhs.s   MGZMiniSK_ReappearReturn
                bset    #0,render_flags(a1)

MGZMiniSK_ReappearReturn:
                rts
; ---------------------------------------------------------------------------
MGZMiniSK_ReappearCameraXOffsets:
                dc.w    $30,   $48,   $60,   $78,   $C8,   $E0,   $F8,  $110
; ---------------------------------------------------------------------------

MGZMiniSK_AnimateAndChooseDownJitter:
                jsr     Animate_Raw(pc)
                moveq   #2,d0
                move.b  (V_int_run_count+3).w,d1
                btst    #0,d1
                beq.s   MGZMiniSK_ApplyDownJitterAndTryDebris
                moveq   #-1,d0

MGZMiniSK_ApplyDownJitterAndTryDebris:
                add.w   d0,y_pos(a0)
                andi.b  #7,d1
                bne.s   MGZMiniSK_TickDownTremorWait
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l
                bsr.w   SpawnMGZTremorDebrisAtRandomScreenX

MGZMiniSK_TickDownTremorWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

MGZMiniSK_ChooseDownStepDuration:
                move.b  #$E,routine(a0)
                clr.w   (Screen_shake_flag).w
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   MGZMiniSK_BeginShortDownStep
                move.w  #$2F,$2E(a0)
                move.l  #MGZMiniSK_BeginTimedUpStep,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_BeginShortDownStep:
                move.w  #$17,$2E(a0)
                move.l  #MGZMiniSK_BeginBobBeforeFlipReset,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_StepDownAnimateAndWait:
                addq.w  #4,y_pos(a0)
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

MGZMiniSK_BeginTimedUpStep:
                move.b  #$10,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZMiniSK_BeginBobBeforeFlipReset,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_StepUpAnimateAndWait:
                jsr     Animate_Raw(pc)
                subq.w  #1,y_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

MGZMiniSK_BeginBobBeforeFlipReset:
                move.b  #$12,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZMiniSK_ClearYFlipAndWait,$34(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

MGZMiniSK_BobMoveAnimateAndWait:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

MGZMiniSK_ClearYFlipAndWait:
                bclr    #1,render_flags(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MGZMiniSK_RestartFightCeilingAscent,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_RestartFightCeilingAscent:
                move.b  #6,routine(a0)
                move.l  #MGZMiniSK_FightBeginShortTremor,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_StartSignControlAndFragments:
                jsr     (Obj_EndSignControl).l
                lea     MGZMiniSK_DefeatFragmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

; Move camera X and its minimum together until $2E00
MGZMiniSK_AdvanceDefeatCamera:
                move.w  (Camera_X_pos).w,d0
                addq.w  #1,d0
                move.w  d0,(Camera_X_pos).w
                move.w  d0,(Camera_min_X_pos).w
                cmpi.w  #$2E00,d0
                blo.w   MGZMiniSK_SharedGateReturn
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

MGZMiniSK_InitCollisionChild:
                move.l  #MGZMiniSK_CollisionChildFollowAndTouch,(a0)
                move.b  #$9E,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_CollisionChildFollowAndTouch:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   MGZMiniSK_CollisionChildDelete
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

MGZMiniSK_CollisionChildDelete:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

MGZMiniSK_InitRandomTremorDebris:
                lea     MGZMiniSK_TremorDebrisAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bset    #3,shield_reaction(a0)
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,mapping_frame(a0)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   MGZMiniSK_DebrisBeginLightGravity
                tst.b   d0
                bne.s   MGZMiniSK_DebrisBeginLightGravity
                lea     MGZMiniSK_TremorSpireAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)

MGZMiniSK_DebrisBeginLightGravity:
                move.l  #MoveDraw_SpriteTimed2,(a0)
                move.w  #$5F,$2E(a0)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

MGZMiniSK_InitMovingSpireAtCamera:
                lea     MGZMinibossSK_MovingSpire_FullAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #MGZMiniSK_SpireMoveSolidAndAnimate,(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$30,d0
                btst    #0,render_flags(a0)
                beq.s   MGZMiniSK_SpireSaveOriginAndWait
                addi.w  #$E0,d0

MGZMiniSK_SpireSaveOriginAndWait:
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$F0,d0
                move.w  d0,y_pos(a0)
                move.w  d0,$3A(a0)
                clr.b   routine(a0)
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_SpireMoveSolidAndAnimate:
                btst    #4,$38(a0)
                bne.w   MGZMiniSK_SpireReleaseRidersAndDelete
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
                beq.s   MGZMiniSK_SpireTickFourFrameLoop
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   MGZMiniSK_SpireCheckP2SideAndHurt
                bclr    #5,status(a0)
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$28,d0
                bmi.s   MGZMiniSK_SpireCheckP2SideAndHurt
                jsr     (HurtPlayerFromSolidHazard).l

MGZMiniSK_SpireCheckP2SideAndHurt:
                andi.b  #2,d6
                beq.s   MGZMiniSK_SpireTickFourFrameLoop
                bclr    #6,status(a0)
                lea     (Player_2).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$28,d0
                bmi.s   MGZMiniSK_SpireTickFourFrameLoop
                jsr     (HurtPlayerFromSolidHazard).l

MGZMiniSK_SpireTickFourFrameLoop:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   MGZMiniSK_SpireDraw
                move.b  #7,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

MGZMiniSK_SpireDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MGZMiniSK_SpireReleaseRidersAndDelete:
                jsr     Displace_PlayerOffObject(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

MGZMiniSK_InitDefeatFragment:
                lea     MGZMiniSK_DefeatFragmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  MGZMiniSK_FragmentFramesBySubtype(pc,d0.w),mapping_frame(a0)
                moveq   #4,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
MGZMiniSK_FragmentFramesBySubtype:
                dc.b    4,   3,   5,   6,   6
                even

; =============== S U B R O U T I N E =======================================

UpdateMGZMinibossSpireMotionState:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZMiniSK_SpireStateOffsets(pc,d0.w),d1
                jmp     MGZMiniSK_SpireStateOffsets(pc,d1.w)
; End of function UpdateMGZMinibossSpireMotionState

; ---------------------------------------------------------------------------
MGZMiniSK_SpireStateOffsets:
                dc.w    MGZMiniSK_SpireRiseAndPause-MGZMiniSK_SpireStateOffsets
                dc.w    MGZMiniSK_SpirePauseAndChooseDrift-MGZMiniSK_SpireStateOffsets
                dc.w    MGZMiniSK_SpireSwingAndPause-MGZMiniSK_SpireStateOffsets
                dc.w    MGZMiniSK_SpirePauseBeforeSink-MGZMiniSK_SpireStateOffsets
                dc.w    MGZMiniSK_SpireSinkToBaseline-MGZMiniSK_SpireStateOffsets
; ---------------------------------------------------------------------------

MGZMiniSK_SpireRiseAndPause:
                subq.w  #4,y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.w   MGZMiniSK_SharedGateReturn
                move.b  #2,routine(a0)
                move.w  #$3F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_SpirePauseAndChooseDrift:
                subq.w  #1,$2E(a0)
                bpl.w   MGZMiniSK_SharedGateReturn
                move.b  #4,routine(a0)
                move.w  #$100,d0
                btst    #0,render_flags(a0)
                beq.s   MGZMiniSK_SpireAddDriftAndResetSwing
                neg.w   d0

MGZMiniSK_SpireAddDriftAndResetSwing:
                add.w   d0,x_vel(a0)
                move.w  #$DF,$2E(a0)
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_SpireSwingAndPause:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.w   MGZMiniSK_SharedGateReturn
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_SpirePauseBeforeSink:
                subq.w  #1,$2E(a0)
                bpl.w   MGZMiniSK_SharedGateReturn
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_SpireSinkToBaseline:
                move.w  y_pos(a0),d0
                addq.w  #2,d0
                move.w  d0,y_pos(a0)
                cmp.w   $3A(a0),d0
                blo.w   MGZMiniSK_SharedGateReturn
                bset    #4,$38(a0)
                rts

; =============== S U B R O U T I N E =======================================

SpawnMGZTremorDebrisAtRandomScreenX:
                lea     MGZMiniSK_TremorDebrisChild(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   MGZMiniSK_TremorDebrisSpawnReturn
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                move.w  (Camera_X_pos).w,d1
                subi.w  #$40,d1
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a1)

MGZMiniSK_TremorDebrisSpawnReturn:
                rts
; End of function SpawnMGZTremorDebrisAtRandomScreenX

; =============== S U B R O U T I N E =======================================

HandleMGZTunnelbotHitFlashOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   MGZMiniSK_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   MGZMiniSK_BeginScoredDefeatWait
                tst.b   $20(a0)
                bne.s   MGZMiniSK_HitChooseFlashRow
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

MGZMiniSK_HitChooseFlashRow:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   MGZMiniSK_HitCopyColorsAndTick
                addq.w  #2*3,d0

MGZMiniSK_HitCopyColorsAndTick:
                lea     MGZMiniSK_HitPaletteDestinations(pc),a1
                lea     MGZMiniSK_HitPaletteColorRows(pc,d0.w),a2
                jsr     CopyWordData_3(pc)
                subq.b  #1,$20(a0)
                bne.s   MGZMiniSK_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

MGZMiniSK_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

MGZMiniSK_BeginScoredDefeatWait:
                move.l  #Wait_FadeToLevelMusic,(a0)
                clr.w   (Screen_shake_flag).w
                move.l  #MGZMiniSK_StartSignControlAndFragments,$34(a0)
                jsr     (AllocateObject).l
                bne.s   MGZMiniSK_TryDefeatExplosionAndScore
                move.l  #MGZMiniSK_AdvanceDefeatCamera,(a1)

MGZMiniSK_TryDefeatExplosionAndScore:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     BossDefeated_StopTimer(pc)
; End of function HandleMGZTunnelbotHitFlashOrDefeat

; ---------------------------------------------------------------------------
MGZMiniSK_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
MGZMiniSK_HitPaletteColorRows:
                dc.w    $CAA,  $866,  $644
                dc.w    $EEE,  $EEE,  $EEE
