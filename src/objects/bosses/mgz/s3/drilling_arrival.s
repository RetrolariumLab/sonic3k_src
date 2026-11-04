; Owner: objects/bosses/mgz/s3
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

MGZArrivalS3_SharedReturn:
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
                dc.w    MGZArrivalS3_InitDrillAndTryShip-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalS3_BeginCollapseMotion-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalS3_AccelerateEmergence-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalS3_SwingUntilHitOrCountEnd-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalS3_TickAngleTowardZero-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalS3_SwingMoveAndTickWait-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalS3_TickStationaryAttackWait-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalS3_WaitForAttachmentAttack-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalS3_SwingMoveAndTickWait-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalS3_SwingAndReturnAngle-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalS3_SwingMoveAndTickWait-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalS3_RetreatProbeCeiling-MGZ2DrillingRobotnik_Index
                dc.w    MGZArrivalS3_MoveAndWaitAfterCeiling-MGZ2DrillingRobotnik_Index
; ---------------------------------------------------------------------------

MGZArrivalS3_InitDrillAndTryShip:
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
                bne.s   MGZArrivalS3_SpawnDrillAttachments
                move.b  #9,subtype(a1)

MGZArrivalS3_SpawnDrillAttachments:
                lea     MGZBossS3_MainAttachmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZArrivalS3_BeginCollapseMotion:
                tst.l   (Nem_decomp_queue).w
                bne.w   MGZArrivalS3_SharedReturn
                move.b  #4,routine(a0)
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

MGZArrivalS3_AccelerateEmergence:
                move.w  y_vel(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$C0,d0
                bge.s   MGZArrivalS3_BeginCountedSwing
                move.w  d0,y_vel(a0)
                btst    #7,$38(a0)
                bne.s   MGZArrivalS3_MoveDuringEmergence
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$120,d1
                cmp.w   y_pos(a0),d1
                blo.s   MGZArrivalS3_MoveDuringEmergence
                bset    #7,$38(a0)
                lea     MGZBossS3_RightArrivalDebrisChildren(pc),a2
                btst    #0,render_flags(a0)
                beq.s   MGZArrivalS3_SpawnEmergenceDebris
                lea     MGZBossS3_LeftArrivalDebrisChildren(pc),a2

MGZArrivalS3_SpawnEmergenceDebris:
                jsr     (CreateChild3_NormalRepeated).l

MGZArrivalS3_MoveDuringEmergence:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

MGZArrivalS3_BeginCountedSwing:
                move.b  #6,routine(a0)
                move.b  #5,$39(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

MGZArrivalS3_SwingUntilHitOrCountEnd:
                btst    #6,status(a0)
                bne.s   MGZArrivalS3_BeginTimedSwingRetreat
                jsr     (Swing_UpAndDown_Count).l
                tst.b   $39(a0)
                bpl.s   MGZArrivalS3_MoveAfterCountedSwing

MGZArrivalS3_BeginTimedSwingRetreat:
                move.b  #$16,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #MGZArrivalS3_RestoreStageArtAndCamera,$34(a0)

MGZArrivalS3_MoveAfterCountedSwing:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

MGZArrivalS3_TickAngleTowardZero:
                subq.w  #1,$2E(a0)
                bpl.s   MGZArrivalS3_SwingMoveAfterAngleTick
                move.w  #3,$2E(a0)
                subq.w  #2,angle(a0)
                bne.s   MGZArrivalS3_SwingMoveAfterAngleTick
                move.b  #$A,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MGZArrivalS3_BeginPreAttackPause,$34(a0)

MGZArrivalS3_SwingMoveAfterAngleTick:
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

MGZArrivalS3_SwingMoveAndTickWait:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZArrivalS3_BeginPreAttackPause:
                move.l  #MGZArrivalS3_BeginStationaryAttackWait,$34(a0)

MGZArrivalS3_SetAttackReadyAndWait:
                bset    #3,$38(a0)
                move.w  #$5F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZArrivalS3_BeginStationaryAttackWait:
                move.b  #$C,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MGZArrivalS3_RequestAttachmentAttack,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZArrivalS3_TickStationaryAttackWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MGZArrivalS3_RequestAttachmentAttack:
                move.b  #$E,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

MGZArrivalS3_WaitForAttachmentAttack:
                btst    #1,$38(a0)
                beq.s   MGZArrivalS3_BeginBobCooldown
                rts
; ---------------------------------------------------------------------------

MGZArrivalS3_BeginBobCooldown:
                move.b  #$10,routine(a0)
                bclr    #3,$38(a0)
                move.w  #$5F,$2E(a0)
                move.l  #MGZArrivalS3_BeginAngleReturn,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZArrivalS3_BeginAngleReturn:
                move.b  #$12,routine(a0)
                move.w  #3,$2E(a0)
                rts
; ---------------------------------------------------------------------------

MGZArrivalS3_SwingAndReturnAngle:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   MGZArrivalS3_AngleReturnUpdateDone
                move.w  #3,$2E(a0)
                addq.w  #2,angle(a0)
                cmpi.w  #$C,angle(a0)
                bhs.s   MGZArrivalS3_BeginFinalBobDelay

MGZArrivalS3_AngleReturnUpdateDone:
                rts
; ---------------------------------------------------------------------------

MGZArrivalS3_BeginFinalBobDelay:
                move.b  #$14,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MGZArrivalS3_ArmFinalRetreatPulse,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZArrivalS3_ArmFinalRetreatPulse:
                move.l  #MGZArrivalS3_BeginFinalRetreat,$34(a0)
                bra.w   MGZArrivalS3_SetAttackReadyAndWait
; ---------------------------------------------------------------------------

MGZArrivalS3_BeginFinalRetreat:
                move.b  #$16,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #MGZArrivalS3_RestoreStageArtAndCamera,$34(a0)
                bclr    #7,$38(a0)
                rts
; ---------------------------------------------------------------------------

MGZArrivalS3_RetreatProbeCeiling:
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bmi.s   MGZArrivalS3_ChooseCeilingDebrisSide
                jmp     (Move_WaitNoFall).l
; ---------------------------------------------------------------------------

MGZArrivalS3_ChooseCeilingDebrisSide:
                move.b  #$18,routine(a0)
                lea     MGZBossS3_RightArrivalDebrisChildren(pc),a2
                btst    #0,render_flags(a0)
                beq.s   MGZArrivalS3_SpawnCeilingDebris
                lea     MGZBossS3_LeftArrivalDebrisChildren(pc),a2

MGZArrivalS3_SpawnCeilingDebris:
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

MGZArrivalS3_RestoreStageArtAndCamera:
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
                btst    #0,render_flags(a0)
                bne.s   MGZArrivalS3_ReleaseCameraLeftLimit
                lea     (Child6_IncLevX).l,a2
                move.w  #$6000,(Camera_stored_max_X_pos).w
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

MGZArrivalS3_ReleaseCameraLeftLimit:
                lea     (Child6_DecLevX).l,a2
                move.w  #0,(Camera_stored_min_X_pos).w
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

MGZArrivalS3_MoveAndWaitAfterCeiling:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
