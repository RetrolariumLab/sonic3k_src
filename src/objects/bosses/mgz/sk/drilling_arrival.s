; Owner: objects/bosses/mgz/sk
; Responsibility: Marble Garden drilling Robotnik arrival scene, movement and battle transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MGZ2DrillingRobotnik:
                move.l  #Obj_Wait,(a0)
                move.b  #1,(Boss_flag).w
                move.w  #2*60,$2E(a0)
                move.l  #Obj_MGZ2DrillingRobotnikGo,$34(a0)
                clr.b   subtype(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                lea     (ArtKosM_MGZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_MGZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_MGZEndBossDebris).l,a1
                move.w  #tiles_to_bytes(ArtTile_MGZEndBossDebris),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_6D,d0
                jsr     (Load_PLC).l
                lea     Pal_MGZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

Obj_MGZ2DrillingRobotnikGo:
                move.l  #Obj_MGZ2DrillingRobotnikStart,(a0)
                moveq   #signextendB(mus_EndBoss),d0    ; Play boss music
                jsr     (Play_Music).l
                move.b  #mus_EndBoss,(Current_music+1).w

MGZArrivalSK_SharedReturn:
                rts
; ---------------------------------------------------------------------------

Obj_MGZ2DrillingRobotnikStart:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZ2DrillingRobotnik_Index(pc,d0.w),d1
                jsr     MGZ2DrillingRobotnik_Index(pc,d1.w)
                bsr.w   MGZ2_SpecialCheckHit
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
MGZ2DrillingRobotnik_Index:
                dc.w    MGZArrivalSK_InitDrillAndTryShip-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalSK_BeginCollapseMotion-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalSK_AccelerateEmergence-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalSK_SwingUntilHitOrCountEnd-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalSK_TickAngleTowardZero-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalSK_SwingMoveAndTickWait-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalSK_TickStationaryAttackWait-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalSK_WaitForAttachmentAttack-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalSK_SwingMoveAndTickWait-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalSK_SwingAndReturnAngle-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalSK_SwingMoveAndTickWait-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalSK_RetreatProbeCeiling-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalSK_MoveAndWaitAfterCeiling-MGZ2DrillingRobotnik_Index
; ---------------------------------------------------------------------------

MGZArrivalSK_InitDrillAndTryShip:
                lea     ObjDat_MGZDrillBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #-1,collision_property(a0)
                move.b  #$30,x_radius(a0)
                move.b  #$24,y_radius(a0)
                move.w  #$C,angle(a0)
                bset    #3,$38(a0)
                move.w  #-$800,y_vel(a0)
                lea     Child1_MakeRoboShip3(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   MGZArrivalSK_SpawnDrillAttachments
                move.b  #9,subtype(a1)

MGZArrivalSK_SpawnDrillAttachments:
                lea     MGZBossSK_MainAttachmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZArrivalSK_BeginCollapseMotion:
                move.b  #4,routine(a0)
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

MGZArrivalSK_AccelerateEmergence:
                move.w  y_vel(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$C0,d0
                bge.s   MGZArrivalSK_BeginCountedSwing
                move.w  d0,y_vel(a0)
                btst    #7,$38(a0)
                bne.s   MGZArrivalSK_MoveDuringEmergence
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$120,d1
                cmp.w   y_pos(a0),d1
                blo.s   MGZArrivalSK_MoveDuringEmergence
                bset    #7,$38(a0)
                lea     MGZBossSK_RightArrivalDebrisChildren(pc),a2
                btst    #0,render_flags(a0)
                beq.s   MGZArrivalSK_SpawnEmergenceDebris
                lea     MGZBossSK_LeftArrivalDebrisChildren(pc),a2

MGZArrivalSK_SpawnEmergenceDebris:
                jsr     (CreateChild3_NormalRepeated).l

MGZArrivalSK_MoveDuringEmergence:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

MGZArrivalSK_BeginCountedSwing:
                move.b  #6,routine(a0)
                move.b  #5,$39(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

MGZArrivalSK_SwingUntilHitOrCountEnd:
                btst    #6,status(a0)
                bne.s   MGZArrivalSK_BeginTimedSwingRetreat
                jsr     (Swing_UpAndDown_Count).l
                tst.b   $39(a0)
                bpl.s   MGZArrivalSK_MoveAfterCountedSwing

MGZArrivalSK_BeginTimedSwingRetreat:
                move.b  #$16,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #MGZArrivalSK_RestoreStageArtAndCamera,$34(a0)

MGZArrivalSK_MoveAfterCountedSwing:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

MGZArrivalSK_TickAngleTowardZero:
                subq.w  #1,$2E(a0)
                bpl.s   MGZArrivalSK_SwingMoveAfterAngleTick
                move.w  #3,$2E(a0)
                subq.w  #2,angle(a0)
                bne.s   MGZArrivalSK_SwingMoveAfterAngleTick
                move.b  #$A,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZArrivalSK_BeginPreAttackPause,$34(a0)

MGZArrivalSK_SwingMoveAfterAngleTick:
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

MGZArrivalSK_SwingMoveAndTickWait:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZArrivalSK_BeginPreAttackPause:
                move.l  #MGZArrivalSK_BeginStationaryAttackWait,$34(a0)

MGZArrivalSK_SetAttackReadyAndWait:
                bset    #3,$38(a0)
                move.w  #$5F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZArrivalSK_BeginStationaryAttackWait:
                move.b  #$C,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MGZArrivalSK_RequestAttachmentAttack,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZArrivalSK_TickStationaryAttackWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZArrivalSK_RequestAttachmentAttack:
                move.b  #$E,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

MGZArrivalSK_WaitForAttachmentAttack:
                btst    #1,$38(a0)
                beq.s   MGZArrivalSK_BeginBobCooldown
                rts
; ---------------------------------------------------------------------------

MGZArrivalSK_BeginBobCooldown:
                move.b  #$10,routine(a0)
                bclr    #3,$38(a0)
                move.w  #$5F,$2E(a0)
                move.l  #MGZArrivalSK_BeginAngleReturn,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZArrivalSK_BeginAngleReturn:
                move.b  #$12,routine(a0)
                move.w  #3,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZArrivalSK_SwingAndReturnAngle:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   MGZArrivalSK_AngleReturnUpdateDone
                move.w  #3,$2E(a0)
                addq.w  #2,angle(a0)
                cmpi.w  #$C,angle(a0)
                bhs.s   MGZArrivalSK_BeginFinalBobDelay

MGZArrivalSK_AngleReturnUpdateDone:
                rts
; ---------------------------------------------------------------------------

MGZArrivalSK_BeginFinalBobDelay:
                move.b  #$14,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MGZArrivalSK_ArmFinalRetreatPulse,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZArrivalSK_ArmFinalRetreatPulse:
                move.l  #MGZArrivalSK_BeginFinalRetreat,$34(a0)
                bra.w   MGZArrivalSK_SetAttackReadyAndWait
; ---------------------------------------------------------------------------

MGZArrivalSK_BeginFinalRetreat:
                move.b  #$16,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #MGZArrivalSK_RestoreStageArtAndCamera,$34(a0)
                bclr    #7,$38(a0)
                rts
; ---------------------------------------------------------------------------

MGZArrivalSK_RetreatProbeCeiling:
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bmi.s   MGZArrivalSK_ChooseCeilingDebrisSide
                jmp     (Move_WaitNoFall).l
; ---------------------------------------------------------------------------

MGZArrivalSK_ChooseCeilingDebrisSide:
                move.b  #$18,routine(a0)
                lea     MGZBossSK_RightArrivalDebrisChildren(pc),a2
                btst    #0,render_flags(a0)
                beq.s   MGZArrivalSK_SpawnCeilingDebris
                lea     MGZBossSK_LeftArrivalDebrisChildren(pc),a2

MGZArrivalSK_SpawnCeilingDebris:
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

MGZArrivalSK_RestoreStageArtAndCamera:
                bset    #5,$38(a0)
                clr.b   (Boss_flag).w
                move.l  #Delete_Current_Sprite,(a0)
                jsr     (Restore_LevelMusic).l
                lea     (MGZ_8x8_Primary_KosM).l,a1
                move.w  #tiles_to_bytes($000),d2
                jsr     (Queue_Kos_Module).l
                lea     (MGZ2_8x8_Secondary_KosM).l,a1
                move.w  #tiles_to_bytes($252),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_14,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_Spiker).l,a1
                move.w  #tiles_to_bytes(ArtTile_Spiker),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_Mantis).l,a1
                move.w  #tiles_to_bytes(ArtTile_Mantis),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_MonitorsSpikesSprings).l,a1
                jsr     (Load_PLC_Raw).l
                lea     (Pal_MGZ).l,a1
                jsr     (PalLoad_Line1).l
                move.w  #$1DF,(Camera_min_Y_pos).w
                st      (Events_fg_2).w
                btst    #0,render_flags(a0)
                bne.s   MGZArrivalSK_ReleaseCameraLeftLimit
                move.w  #$6000,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   MGZArrivalSK_CameraRightReleaseReturn
                move.l  #Obj_IncLevEndXGradual,(a1)

MGZArrivalSK_CameraRightReleaseReturn:
                rts
; ---------------------------------------------------------------------------

MGZArrivalSK_ReleaseCameraLeftLimit:
                clr.w   (Camera_stored_min_X_pos).w
                jsr     (AllocateObject).l
                bne.s   MGZArrivalSK_CameraLeftReleaseReturn
                move.l  #Obj_DecLevStartXGradual,(a1)

MGZArrivalSK_CameraLeftReleaseReturn:
                rts
; ---------------------------------------------------------------------------

MGZArrivalSK_MoveAndWaitAfterCeiling:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZArrivalSK_BeginDefeatWaitAndFragments:
                move.l  #Obj_Wait,(a0)
                bset    #4,$38(a0)
                move.l  #MGZArrivalSK_InstallCapsuleWait,$34(a0)
                move.w  #$200,priority(a0)
                lea     MGZBossSK_DefeatFragmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

; Reuse Angel Island's capsule initializer after installing the Marble Garden wait
MGZArrivalSK_InstallCapsuleWait:
                move.l  #MGZArrivalSK_WaitCapsuleAndTryPalette,(a0)
                jmp     (AIZBossSK_SignalAndSpawnCapsule).l
; ---------------------------------------------------------------------------

MGZArrivalSK_WaitCapsuleAndTryPalette:
                tst.b   (_unkFAA8).w
                bne.w   MGZArrivalSK_SharedReturn
                move.l  #MGZArrivalSK_DefeatedDrillIdle,(a0)
                bset    #4,$38(a0)
                jsr     (Restore_LevelMusic).l
                jsr     (AllocateObject).l
                bne.s   MGZArrivalSK_PaletteSpawnReturn
                move.l  #MGZBossSK_TickTransitionPalette,(a1)

MGZArrivalSK_PaletteSpawnReturn:
                rts
; ---------------------------------------------------------------------------

MGZArrivalSK_DefeatedDrillIdle:
                rts
