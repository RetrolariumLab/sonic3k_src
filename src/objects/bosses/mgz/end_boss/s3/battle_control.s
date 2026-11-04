; Owner: objects/bosses/mgz/end_boss/s3
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
                dc.w    MGZBossS3_InitProtectedEntrance-MGZEndBoss_Index
                dc.w    MGZBossS3_TickEntranceCallbackWait-MGZEndBoss_Index
                dc.w    MGZBossS3_MoveAndTickDescent-MGZEndBoss_Index
                dc.w    MGZEndBossS3_Root_SwingMoveAndWait-MGZEndBoss_Index
                dc.w    MGZBossS3_SwingAndTurnToFloor-MGZEndBoss_Index
                dc.w    MGZBossS3_TickEntranceCallbackWait-MGZEndBoss_Index
                dc.w    MGZBossS3_MoveAndCheckFloorContact-MGZEndBoss_Index
                dc.w    MGZBossS3_TickFloorOrFlybyWait-MGZEndBoss_Index
                dc.w    MGZBossS3_MoveAndTickEntranceTransit-MGZEndBoss_Index
                dc.w    MGZBossS3_TickEntranceCallbackWait-MGZEndBoss_Index
                dc.w    MGZBossS3_SwingAndTurnToHorizontal-MGZEndBoss_Index
                dc.w    MGZBossS3_TickEntranceCallbackWait-MGZEndBoss_Index
                dc.w    MGZBossS3_MoveAndTickEntranceTransit-MGZEndBoss_Index
                dc.w    MGZBossS3_ApproachUntilPlayerPasses-MGZEndBoss_Index
                dc.w    MGZBossS3_MoveToFlybyThreshold-MGZEndBoss_Index
                dc.w    MGZBossS3_TickFloorOrFlybyWait-MGZEndBoss_Index
                dc.w    MGZBossS3_MoveAndTickEntranceTransit-MGZEndBoss_Index
; ---------------------------------------------------------------------------

MGZBossS3_InitProtectedEntrance:
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
                move.l  #MGZBossS3_BeginMusicAndSlowDescent,$34(a0)
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
                move.b  #9,subtype(a1)
                lea     MGZBossS3_MainAttachmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossS3_TickEntranceCallbackWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossS3_BeginMusicAndSlowDescent:
                move.b  #4,routine(a0)
                moveq   #signextendB(mus_EndBoss),d0
                jsr     (Play_Music).l
                move.w  #$80,y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #MGZBossS3_BeginSwingBeforeTurn,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_MoveAndTickDescent:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossS3_BeginSwingBeforeTurn:
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZBossS3_BeginTurnToFloor,$34(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

MGZEndBossS3_Root_SwingMoveAndWait:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossS3_BeginTurnToFloor:
                move.b  #8,routine(a0)
                move.w  #3,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_SwingAndTurnToFloor:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   MGZBossS3_FloorTurnReturn
                move.w  #3,$2E(a0)
                subq.w  #2,angle(a0)
                cmpi.w  #4,angle(a0)
                bls.s   MGZBossS3_ExtendDrillAndHold

MGZBossS3_FloorTurnReturn:
                rts
; ---------------------------------------------------------------------------

MGZBossS3_ExtendDrillAndHold:
                move.b  #$A,routine(a0)
                bset    #3,$38(a0)
                move.w  #$5F,$2E(a0)
                move.l  #MGZEndBossS3_Root_StartFastFloorDrop,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZEndBossS3_Root_StartFastFloorDrop:
                move.b  #$C,routine(a0)
                move.w  #$400,y_vel(a0)
                move.l  #MGZBossS3_BreakFloorAndTryTransition,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_MoveAndCheckFloorContact:
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

MGZBossS3_BreakFloorAndTryTransition:
                move.b  #$E,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZBossS3_BeginShortRebound,$34(a0)
                st      (Events_fg_4).w
                st      (Disable_death_plane).w
                moveq   #signextendB(sfx_BossHitFloor),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   MGZBossS3_TransitionSpawnReturn
                move.l  #Obj_MGZ2_BossTransition,(a1)

MGZBossS3_TransitionSpawnReturn:
                rts
; ---------------------------------------------------------------------------

MGZBossS3_TickFloorOrFlybyWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossS3_BeginShortRebound:
                move.b  #$10,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$17,$2E(a0)
                move.l  #MGZBossS3_RetractDrillAndHold,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_MoveAndTickEntranceTransit:
                jmp     (Move_WaitNoFall).l
; ---------------------------------------------------------------------------

MGZBossS3_RetractDrillAndHold:
                move.b  #$12,routine(a0)
                bclr    #3,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #MGZBossS3_BeginTurnToHorizontal,$34(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

MGZBossS3_BeginTurnToHorizontal:
                move.b  #$14,routine(a0)
                move.w  #3,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_SwingAndTurnToHorizontal:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   MGZBossS3_HorizontalTurnReturn
                move.w  #3,$2E(a0)
                subq.w  #2,angle(a0)
                beq.s   MGZBossS3_HoldBeforeArenaRise

MGZBossS3_HorizontalTurnReturn:
                rts
; ---------------------------------------------------------------------------

MGZBossS3_HoldBeforeArenaRise:
                move.b  #$16,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZEndBossS3_Root_StartFinalEntranceRise,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZEndBossS3_Root_StartFinalEntranceRise:
                move.b  #$18,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MGZBossS3_EnableFlightArenaCombat,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_EnableFlightArenaCombat:
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
MGZBossS3_ApproachUntilPlayerPasses:
                jsr     (MoveSprite2).l
                btst    #6,status(a0)
                bne.s   MGZEndBossS3_Root_SelectRightwardRetreat
                move.w  (Player_1+x_pos).w,d0
                cmp.w   x_pos(a0),d0
                bhs.s   MGZEndBossS3_Root_SelectRightwardRetreat
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

MGZEndBossS3_Root_SelectRightwardRetreat:
                move.b  #$1C,routine(a0)
                move.w  #$200,x_vel(a0)
                move.l  #MGZBossS3_SpawnScaledFlybyAndHold,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_MoveToFlybyThreshold:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                cmpi.w  #$3E00,x_pos(a0)
                blo.w   MGZArrivalS3_SharedReturn

MGZBossS3_SpawnScaledFlybyAndHold:
                move.b  #$1E,routine(a0)
                moveq   #signextendB(sfx_BossZoom),d0
                jsr     (Play_SFX).l
                bclr    #3,$38(a0)
                bclr    #2,$38(a0)
                move.w  #$9F,$2E(a0)
                move.l  #MGZBossS3_LoadNextForegroundEntry,$34(a0)
                lea     MGZBossS3_ScaledFlybyChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossS3_LoadNextForegroundEntry:
                move.w  #$1F,$2E(a0)
                move.l  #MGZBossS3_ExtendDrillForForegroundPass,$34(a0)
                bra.w   MGZBossS3_LoadCameraRelativeEntry
; ---------------------------------------------------------------------------

MGZBossS3_ExtendDrillForForegroundPass:
                bset    #3,$38(a0)
                move.w  #$9F,$2E(a0)
                move.l  #MGZBossS3_BeginTimedForegroundPass,$34(a0)

MGZBossS3_BeginTimedForegroundPass:
                move.b  #$20,routine(a0)
                move.w  #$FF,$2E(a0)
                move.l  #MGZBossS3_SpawnScaledFlybyAndHold,$34(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

Obj_MGZEndBossKnux:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZEndBossKnux_Index(pc,d0.w),d1
                jsr     MGZEndBossKnux_Index(pc,d1.w)
                bsr.w   MGZ2_SpecialCheckHit
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
MGZEndBossKnux_Index:
                dc.w    MGZBossS3_InitProtectedEntrance-MGZEndBossKnux_Index
                dc.w    MGZBossS3_KnucklesWaitArenaGate-MGZEndBossKnux_Index
                dc.w    MGZBossS3_KnucklesTickAttackDelay-MGZEndBossKnux_Index
                dc.w    MGZBossS3_KnucklesWaitDrillPair-MGZEndBossKnux_Index
                dc.w    MGZBossS3_KnucklesTickPlanPause-MGZEndBossKnux_Index
                dc.w    MGZBossS3_KnucklesMoveAndTickPlan-MGZEndBossKnux_Index
                dc.w    MGZBossS3_KnucklesTickPlanPause-MGZEndBossKnux_Index
                dc.w    MGZBossS3_KnucklesMoveAndTickPlan-MGZEndBossKnux_Index
                dc.w    MGZBossS3_KnucklesTickPlanPause-MGZEndBossKnux_Index
; ---------------------------------------------------------------------------

MGZBossS3_KnucklesWaitArenaGate:
                jsr     (Obj_Wait).l
                move.w  #$3A50,d0
                cmp.w   (Camera_X_pos).w,d0
                bls.s   MGZBossS3_KnucklesLockArenaAndDelay
                rts
; ---------------------------------------------------------------------------

MGZBossS3_KnucklesLockArenaAndDelay:
                move.b  #4,routine(a0)
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                move.w  #3*60,$30(a0)
                move.b  #2,subtype(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_KnucklesTickAttackDelay:
                jsr     (Obj_Wait).l
                subq.w  #1,$30(a0)
                bmi.s   MGZBossS3_KnucklesRequestDrillPair
                rts
; ---------------------------------------------------------------------------

MGZBossS3_KnucklesRequestDrillPair:
                move.b  #6,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_KnucklesWaitDrillPair:
                btst    #2,$38(a0)
                bne.s   MGZBossS3_KnucklesDelayUpperPlan
                rts
; ---------------------------------------------------------------------------

MGZBossS3_KnucklesDelayUpperPlan:
                move.b  #8,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MGZBossS3_KnucklesBeginUpperPlan,$34(a0)
                move.b  #0,subtype(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_KnucklesBeginUpperPlan:
                move.b  #$A,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #MGZBossS3_KnucklesPauseBetweenPlans,$34(a0)
                lea     (_unkFA82).w,a1
                bra.w   MGZBossS3_ReplayDrillPlanAtHalfSpeed
; ---------------------------------------------------------------------------

MGZBossS3_KnucklesMoveAndTickPlan:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossS3_KnucklesPauseBetweenPlans:
                move.b  #$C,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZBossS3_KnucklesBeginLowerPlan,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_KnucklesTickPlanPause:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZBossS3_KnucklesBeginLowerPlan:
                move.b  #$E,routine(a0)
                move.w  #$9F,$2E(a0)
                move.l  #MGZBossS3_KnucklesResetAfterPair,$34(a0)
                move.b  #2,subtype(a0)
                lea     (_unkFA8A).w,a1
                bra.w   MGZBossS3_ReplayDrillPlanAtHalfSpeed
; ---------------------------------------------------------------------------

MGZBossS3_KnucklesResetAfterPair:
                move.b  #$10,routine(a0)
                move.w  #$3AF0,x_pos(a0)
                move.w  #$4C0,y_pos(a0)
                move.w  #(2*60)-1,$2E(a0)
                move.l  #MGZBossS3_KnucklesRequestDrillPair,$34(a0)
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_BeginDefeatWaitAndFragments:
                move.l  #Obj_Wait,(a0)
                bclr    #7,render_flags(a0)
                bset    #4,$38(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #$7F,$2E(a0)
                move.l  #MGZBossS3_SpawnCapsuleAndInstallWait,$34(a0)
                move.w  #$200,priority(a0)
                lea     MGZBossS3_DefeatFragmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossS3_SpawnCapsuleAndInstallWait:
                move.l  #MGZBossS3_WaitCapsuleAndTryPalette,(a0)
                jmp     (AIZBossS3_SignalAndSpawnCapsule).l
; ---------------------------------------------------------------------------

MGZBossS3_WaitCapsuleAndTryPalette:
                tst.b   (_unkFAA8).w
                bne.w   MGZArrivalS3_SharedReturn
                move.l  #MGZBossS3_DefeatedBossIdle,(a0)
                bset    #4,$38(a0)
                jsr     (AllocateObject).l
                bne.s   MGZBossS3_PaletteSpawnReturn
                move.l  #MGZBossS3_TickTransitionPalette,(a1)

MGZBossS3_PaletteSpawnReturn:
                rts
; ---------------------------------------------------------------------------

MGZBossS3_DefeatedBossIdle:
                rts
