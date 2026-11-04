; Owner: objects/bosses/mgz/end_boss/sk
; Responsibility: Marble Garden end-boss Sonic or Knuckles battle controllers, progression and defeat state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MGZEndBoss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZEndBoss_Index(pc,d0.w),d1
                jsr     MGZEndBoss_Index(pc,d1.w)
                bsr.w   MGZ2_SpecialCheckHit
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
MGZEndBoss_Index:
                dc.w    MGZBossSK_InitProtectedEntrance-MGZEndBoss_Index
                dc.w    MGZEndBossSK_Sonic_WaitForPhaseCallback-MGZEndBoss_Index
                dc.w    MGZBossSK_MoveAndTickDescent-MGZEndBoss_Index
                dc.w    MGZEndBossSK_Sonic_SwingMoveAndWait-MGZEndBoss_Index
                dc.w    MGZBossSK_SwingAndTurnToFloor-MGZEndBoss_Index
                dc.w    MGZEndBossSK_Sonic_WaitForPhaseCallback-MGZEndBoss_Index
                dc.w    MGZBossSK_MoveAndCheckFloorContact-MGZEndBoss_Index
                dc.w    MGZBossSK_TickFloorOrFlybyWait-MGZEndBoss_Index
                dc.w    MGZBossSK_MoveAndTickEntranceTransit-MGZEndBoss_Index
                dc.w    MGZEndBossSK_Sonic_WaitForPhaseCallback-MGZEndBoss_Index
                dc.w    MGZEndBossSK_Sonic_SweepAngleDownToZero-MGZEndBoss_Index
                dc.w    MGZEndBossSK_Sonic_WaitForPhaseCallback-MGZEndBoss_Index
                dc.w    MGZBossSK_MoveAndTickEntranceTransit-MGZEndBoss_Index
                dc.w    MGZBossSK_ApproachUntilPlayerPasses-MGZEndBoss_Index
                dc.w    MGZBossSK_MoveToFlybyThreshold-MGZEndBoss_Index
                dc.w    MGZBossSK_TickFloorOrFlybyWait-MGZEndBoss_Index
                dc.w    MGZBossSK_MoveAndTickEntranceTransit-MGZEndBoss_Index
; ---------------------------------------------------------------------------

MGZBossSK_InitProtectedEntrance:
                lea     ObjDat_MGZDrillBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #7,art_tile(a0)
                st      $46(a0)
                move.b  #8,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.b  #$1C,y_radius(a0)
                move.w  #$C,angle(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #2*60,$2E(a0)
                move.l  #MGZBossSK_BeginMusicAndSlowDescent,$34(a0)
                lea     (ArtKosM_MGZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_MGZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_MGZEndBossDebris).l,a1
                move.w  #tiles_to_bytes(ArtTile_MGZEndBossDebris),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_6D,d0
                jsr     (Load_PLC).l
                lea     Pal_MGZEndBoss(pc),a1
                jsr     (PalLoad_Line1).l
                lea     (Child1_MakeRoboShip3).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   MGZBossSK_SpawnEntranceAttachments
                move.b  #9,subtype(a1)

MGZBossSK_SpawnEntranceAttachments:
                lea     MGZBossSK_MainAttachmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZEndBossSK_Sonic_WaitForPhaseCallback:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossSK_BeginMusicAndSlowDescent:
                move.b  #4,routine(a0)
                moveq   #signextendB(mus_EndBoss),d0
                jsr     (Play_Music).l
                move.b  #mus_EndBoss,(Current_music+1).w
                move.w  #$80,y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #MGZEndBossSK_Sonic_StartInitialSwingHold,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_MoveAndTickDescent:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZEndBossSK_Sonic_StartInitialSwingHold:
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZBossSK_BeginTurnToFloor,$34(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

MGZEndBossSK_Sonic_SwingMoveAndWait:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossSK_BeginTurnToFloor:
                move.b  #8,routine(a0)
                move.w  #3,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_SwingAndTurnToFloor:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   MGZBossSK_FloorTurnReturn
                move.w  #3,$2E(a0)
                subq.w  #2,angle(a0)
                cmpi.w  #4,angle(a0)
                bls.s   MGZBossSK_ExtendDrillAndHold

MGZBossSK_FloorTurnReturn:
                rts
; ---------------------------------------------------------------------------

MGZBossSK_ExtendDrillAndHold:
                move.b  #$A,routine(a0)
                bset    #3,$38(a0)
                move.w  #$5F,$2E(a0)
                move.l  #MGZEndBossSK_Sonic_StartFloorDive,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZEndBossSK_Sonic_StartFloorDive:
                move.b  #$C,routine(a0)
                move.w  #$400,y_vel(a0)
                move.l  #MGZBossSK_BreakFloorAndTryTransition,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_MoveAndCheckFloorContact:
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

MGZBossSK_BreakFloorAndTryTransition:
                move.b  #$E,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZBossSK_BeginShortRebound,$34(a0)
                st      (Events_fg_4).w
                st      (Disable_death_plane).w
                moveq   #signextendB(sfx_BossHitFloor),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   MGZBossSK_TransitionSpawnReturn
                move.l  #Obj_MGZ2_BossTransition,(a1)

MGZBossSK_TransitionSpawnReturn:
                rts
; ---------------------------------------------------------------------------

MGZBossSK_TickFloorOrFlybyWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossSK_BeginShortRebound:
                move.b  #$10,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$17,$2E(a0)
                move.l  #MGZBossSK_RetractDrillAndHold,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_MoveAndTickEntranceTransit:
                jmp     (Move_WaitNoFall).l
; ---------------------------------------------------------------------------

MGZBossSK_RetractDrillAndHold:
                move.b  #$12,routine(a0)
                bclr    #3,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #MGZBossSK_BeginTurnToHorizontal,$34(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

MGZBossSK_BeginTurnToHorizontal:
                move.b  #$14,routine(a0)
                move.w  #3,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZEndBossSK_Sonic_SweepAngleDownToZero:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   MGZBossSK_HorizontalTurnReturn
                move.w  #3,$2E(a0)
                subq.w  #2,angle(a0)
                beq.s   MGZBossSK_HoldBeforeArenaRise

MGZBossSK_HorizontalTurnReturn:
                rts
; ---------------------------------------------------------------------------

MGZBossSK_HoldBeforeArenaRise:
                move.b  #$16,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZBossSK_BeginLongArenaRise,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_BeginLongArenaRise:
                move.b  #$18,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MGZBossSK_EnableFlightArenaCombat,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_EnableFlightArenaCombat:
                move.b  #$1A,routine(a0)
                clr.b   $46(a0)
                bset    #0,render_flags(a0)
                move.w  #$3E80,x_pos(a0)
                move.w  #$700,y_pos(a0)
                move.w  #-$80,x_vel(a0)
                move.b  #6,$3A(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

; Move a second time after swinging if the hit flag is clear and the player remains left of the boss
MGZBossSK_ApproachUntilPlayerPasses:
                jsr     (MoveSprite2).l
                btst    #6,status(a0)
                bne.s   MGZBossSK_BeginRightwardFlybyApproach
                move.w  (Player_1+x_pos).w,d0
                cmp.w   x_pos(a0),d0
                bhs.s   MGZBossSK_BeginRightwardFlybyApproach
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

MGZBossSK_BeginRightwardFlybyApproach:
                move.b  #$1C,routine(a0)
                move.w  #$200,x_vel(a0)
                move.l  #MGZBossSK_SpawnScaledFlybyAndHold,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_MoveToFlybyThreshold:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                cmpi.w  #$3E00,x_pos(a0)
                blo.w   MGZArrivalSK_SharedReturn

MGZBossSK_SpawnScaledFlybyAndHold:
                move.b  #$1E,routine(a0)
                moveq   #signextendB(sfx_BossZoom),d0
                jsr     (Play_SFX).l
                bclr    #3,$38(a0)
                bclr    #2,$38(a0)
                move.w  #$9F,$2E(a0)
                move.l  #MGZBossSK_LoadNextForegroundEntry,$34(a0)
                lea     MGZEndBossSK_Sonic_OneScaledFlybyRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossSK_LoadNextForegroundEntry:
                move.w  #$1F,$2E(a0)
                move.l  #MGZBossSK_ExtendDrillForForegroundPass,$34(a0)
                bra.w   MGZBossSK_LoadCameraRelativeEntry
; ---------------------------------------------------------------------------

MGZBossSK_ExtendDrillForForegroundPass:
                bset    #3,$38(a0)
                move.w  #$9F,$2E(a0)
                move.l  #MGZBossSK_BeginTimedForegroundPass,$34(a0)

MGZBossSK_BeginTimedForegroundPass:
                move.b  #$20,routine(a0)
                move.w  #$FF,$2E(a0)
                move.l  #MGZBossSK_SpawnScaledFlybyAndHold,$34(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------
MGZBossSK_KnucklesArenaCameraBounds:
                dc.w    0,  $128, $3C78, $3E78
                dc.w    $28,   $28, $3D78, $3D78
; ---------------------------------------------------------------------------

Obj_MGZEndBossKnux:
                lea     MGZBossSK_KnucklesArenaCameraBounds(pc),a1
                jsr     (Check_CameraInRange).l
                move.b  #mus_Miniboss,boss_saved_mus(a0)  ; different song than other end bosses
                jsr     (Boss_BeginCameraTransition).l
                move.l  #MGZBossSK_KnucklesTickArenaTransition,(a0)
                move.l  #MGZBossSK_KnucklesInstallDispatcher,$34(a0)
                lea     (ArtKosM_MGZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_MGZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_MGZEndBossDebris).l,a1
                move.w  #tiles_to_bytes(ArtTile_MGZEndBossDebris),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_6D,d0
                jsr     (Load_PLC).l
                cmpi.b  #2,(Player_1+character_id).w
                lea     Pal_MGZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesTickArenaTransition:
                jmp     (SKEndCamera_TickAndSaveMusic).l
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesInstallDispatcher:
                move.l  #MGZBossSK_KnucklesDispatchHitAndDraw,(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesDispatchHitAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZEndBossKnux_Index(pc,d0.w),d1
                jsr     MGZEndBossKnux_Index(pc,d1.w)
                bsr.w   MGZBossSK_KnucklesCheckHitOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
MGZEndBossKnux_Index:
                dc.w    MGZBossSK_InitProtectedKnucklesBoss-MGZEndBossKnux_Index
                dc.w    MGZBossSK_KnucklesTickAttackDelay-MGZEndBossKnux_Index
                dc.w    MGZBossSK_KnucklesWaitDrillPair-MGZEndBossKnux_Index
                dc.w    MGZBossSK_KnucklesTickPlanPause-MGZEndBossKnux_Index
                dc.w    MGZBossSK_KnucklesTryUpperCollapse-MGZEndBossKnux_Index
                dc.w    MGZBossSK_KnucklesTickPlanPause-MGZEndBossKnux_Index
                dc.w    MGZBossSK_KnucklesTryLowerCollapse-MGZEndBossKnux_Index
                dc.w    MGZBossSK_KnucklesWaitOffscreen-MGZEndBossKnux_Index
; ---------------------------------------------------------------------------

MGZBossSK_InitProtectedKnucklesBoss:
                lea     ObjDat_MGZDrillBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                st      $46(a0)
                move.b  #8,collision_property(a0)
                move.b  #$1C,y_radius(a0)
                move.w  #$C,angle(a0)
                move.b  #2,subtype(a0)
                bset    #3,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZBossSK_KnucklesRequestDrillPair,$34(a0)
                lea     (Child1_MakeRoboShip3).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   MGZBossSK_KnucklesSpawnAttachments
                move.b  #9,subtype(a1)

MGZBossSK_KnucklesSpawnAttachments:
                lea     MGZBossSK_MainAttachmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesTickAttackDelay:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesRequestDrillPair:
                move.b  #4,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesWaitDrillPair:
                btst    #2,$38(a0)
                bne.s   MGZBossSK_KnucklesDelayUpperPlan
                rts
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesDelayUpperPlan:
                move.b  #6,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MGZBossSK_KnucklesBeginUpperPlan,$34(a0)
                move.b  #0,subtype(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesBeginUpperPlan:
                move.b  #8,routine(a0)
                move.w  #$87,$2E(a0)
                move.l  #MGZBossSK_KnucklesPauseBetweenPlans,$34(a0)
                lea     (SceneTimerOrSharedMotionRecordBase).w,a1
                bra.w   MGZBossSK_ReplayDrillPlanAtHalfSpeed
; ---------------------------------------------------------------------------

; Spawn collapse debris at timer value 40 on the upper transit
MGZBossSK_KnucklesTryUpperCollapse:
                cmpi.w  #$28,$2E(a0)
                bne.s   MGZBossSK_KnucklesMoveAndTickUpper
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                lea     MGZBossSK_CollapseEmitterChild(pc),a2
                jsr     (CreateChild6_Simple).l

MGZBossSK_KnucklesMoveAndTickUpper:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesPauseBetweenPlans:
                move.b  #$A,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZBossSK_KnucklesBeginLowerPlan,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesTickPlanPause:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesBeginLowerPlan:
                move.b  #$C,routine(a0)
                move.w  #$9F,$2E(a0)
                move.l  #MGZBossSK_KnucklesResetAfterPair,$34(a0)
                move.b  #2,subtype(a0)
                lea     (DDZScrollAccelOrSceneMotion).w,a1
                bra.w   MGZBossSK_ReplayDrillPlanAtHalfSpeed
; ---------------------------------------------------------------------------

; Spawn collapse debris at timer value 72 on the lower transit
MGZBossSK_KnucklesTryLowerCollapse:
                cmpi.w  #$48,$2E(a0)
                bne.s   MGZBossSK_KnucklesMoveAndTickLower
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                lea     MGZBossSK_CollapseEmitterChild(pc),a2
                jsr     (CreateChild6_Simple).l

MGZBossSK_KnucklesMoveAndTickLower:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesResetAfterPair:
                move.b  #$E,routine(a0)
                move.w  #$3E18,x_pos(a0)
                move.w  #-$58,y_pos(a0)
                move.w  #(2*60)-1,$2E(a0)
                move.l  #MGZBossSK_KnucklesRequestDrillPair,$34(a0)
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesWaitOffscreen:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossSK_BeginDefeatWaitAndFragments:
                move.l  #Obj_Wait,(a0)
                move.w  #$200,priority(a0)
                move.l  #MGZBossSK_SpawnCapsuleAndInstallWait,$34(a0)
                bset    #4,$38(a0)
                lea     MGZBossSK_DefeatFragmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossSK_SpawnCapsuleAndInstallWait:
                move.l  #MGZBossSK_KnucklesWaitResultsAndLock,(a0)
                st      (ActCompletionHandshake).w
                clr.b   (Boss_flag).w
                jsr     (AllocateObject).l
                bne.s   MGZBossSK_KnucklesExtendExitCamera
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$3F40,x_pos(a1)
                move.w  #$B0,y_pos(a1)

MGZBossSK_KnucklesExtendExitCamera:
                move.w  (SceneMinimumXOrEmeraldSelectionTail).w,d0
                addi.w  #$118,d0
                move.w  d0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesWaitResultsAndLock:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (ActCompletionHandshake).w
                bne.w   MGZArrivalSK_SharedReturn
                move.l  #MGZBossSK_KnucklesRunToExitGate,(a0)
                clr.b   (ActCompletionHandshake).w
                jsr     (Restore_PlayerControl).l
                jsr     (Restore_LevelMusic).l
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                clr.w   $2E(a0)
                move.b  #1,(Scroll_lock).w
                addi.w  #$30,(Camera_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

MGZBossSK_KnucklesRunToExitGate:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$150,d0
                cmp.w   (Player_1+x_pos).w,d0
                bls.w   MGZBossSK_StartCarnivalNightAndDelete
                jmp     (SKInput_BuildAutoRightAndJump).l
