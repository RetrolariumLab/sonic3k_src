; Owner: objects/bosses/lbz/sk
; Responsibility: Launch Base act-one Robotnik and miniboss-box scene states, helpers and private object records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZ1Robotnik:
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   LBZSceneSK_DeleteRobotnikForKnuckles
                lea     LBZSceneSK_CameraActivationBounds(pc),a1
                jsr     Check_CameraInRange(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZ1Robotnik_Index(pc,d0.w),d1
                jsr     LBZ1Robotnik_Index(pc,d1.w)
                jsr     (UpdateLBZAct1RobotnikHitCooldown).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
LBZ1Robotnik_Index:
                dc.w    LBZSceneSK_InitRobotnikSceneAndBox-LBZ1Robotnik_Index
                dc.w    LBZSceneSK_WaitPlayerForFirstRetreat-LBZ1Robotnik_Index
                dc.w    LBZSceneSK_RiseToFirstHeightGate-LBZ1Robotnik_Index
                dc.w    LBZSceneSK_CheckCameraAndGroundedPlayer-LBZ1Robotnik_Index
                dc.w    LBZSceneSK_WaitForCollapseEvent-LBZ1Robotnik_Index
                dc.w    LBZSceneSK_AdvanceCameraMinimumX-LBZ1Robotnik_Index
                dc.w    LBZSceneSK_RiseToSecondHeightGate-LBZ1Robotnik_Index
                dc.w    LBZSceneSK_MoveToExitHeight-LBZ1Robotnik_Index
; ---------------------------------------------------------------------------

LBZSceneSK_DeleteRobotnikForKnuckles:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
LBZSceneSK_CameraActivationBounds:
                dc.w    $500,  $5E0, $3820, $3AC0
; ---------------------------------------------------------------------------

LBZSceneSK_InitRobotnikSceneAndBox:
                lea     ObjDat_LBZ1Robotnik(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #-1,collision_property(a0)
                st      (_unkFAAB).w
                jsr     (Swing_Setup1).l
                move.w  #$3820,(Camera_min_X_pos).w
                move.w  #$3AE8,(Camera_max_X_pos).w
                moveq   #PLCID_60,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_LBZMinibossBox).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMinibossBox),d2
                jsr     (Queue_Kos_Module).l
                lea     (Child1_MakeRoboHead3).l,a2
                jsr     (CreateChild1_Normal).l
                lea     LBZSceneSK_AttachedBoxChild(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

LBZSceneSK_WaitPlayerForFirstRetreat:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                tst.w   d1
                beq.s   LBZSceneSK_BeginFirstFastRetreat
                cmpi.w  #$70,d2
                bhs.s   LBZSceneSK_SwingAndMoveWhileWaiting
                cmpi.w  #$60,d3
                bhs.s   LBZSceneSK_SwingAndMoveWhileWaiting
                btst    #Status_InAir,status(a1)
                beq.s   LBZSceneSK_BeginFirstFastRetreat

LBZSceneSK_SwingAndMoveWhileWaiting:
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

LBZSceneSK_BeginFirstFastRetreat:
                move.b  #4,routine(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_RiseToFirstHeightGate:
                cmpi.w  #$300,y_pos(a0)
                blo.s   LBZSceneSK_TeleportToSecondGate
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

LBZSceneSK_TeleportToSecondGate:
                move.b  #6,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #$3EC0,x_pos(a0)
                move.w  #$1A0,y_pos(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

LBZSceneSK_CheckCameraAndGroundedPlayer:
                lea     (Player_1).w,a1
                cmpi.w  #$3B40,(Camera_X_pos).w
                blo.s   LBZSceneSK_CollapseGateReturn
                cmpi.w  #$1C0,y_pos(a1)
                blo.s   LBZSceneSK_CollapseGateReturn
                btst    #Status_InAir,status(a1)
                beq.s   LBZSceneSK_RequestLevelCollapse

LBZSceneSK_CollapseGateReturn:
                rts
; ---------------------------------------------------------------------------

; Set the event's high byte and then wait for the entire word to clear
LBZSceneSK_RequestLevelCollapse:
                move.b  #8,routine(a0)
                st      (Events_fg_4).w
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_WaitForCollapseEvent:
                tst.w   (Events_fg_4).w
                beq.s   LBZSceneSK_QueueBoxArtAndOpenCamera
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_QueueBoxArtAndOpenCamera:
                move.b  #$A,routine(a0)
                lea     (ArtKosM_LBZMinibossBox).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMinibossBox),d2
                jsr     (Queue_Kos_Module).l
                move.w  #$3EA0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

LBZSceneSK_AdvanceCameraMinimumX:
                move.w  (Camera_X_pos).w,d0
                cmpi.w  #$3E50,d0
                bhs.s   LBZSceneSK_WaitPlayerForSecondRetreat
                move.w  d0,(Camera_min_X_pos).w

LBZSceneSK_WaitPlayerForSecondRetreat:
                jsr     (Find_SonicTails).l
                cmpi.w  #$60,d2
                blo.s   LBZSceneSK_BeginSecondFastRetreat
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

LBZSceneSK_BeginSecondFastRetreat:
                move.b  #$C,routine(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_RiseToSecondHeightGate:
                cmpi.w  #$12C,y_pos(a0)
                bls.s   LBZSceneSK_ReleaseBoxAndExitDiagonally
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

LBZSceneSK_ReleaseBoxAndExitDiagonally:
                move.b  #$E,routine(a0)
                move.w  #$12C,y_pos(a0)
                bset    #1,$38(a0)
                move.w  #$200,x_vel(a0)
                move.w  #$200,y_vel(a0)
                lea     (ArtKosM_LBZMiniboss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     (Child1_MakeRoboShipFlame).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

LBZSceneSK_MoveToExitHeight:
                jsr     (MoveSprite2).l
                cmpi.w  #$1B8,y_pos(a0)
                bhs.s   LBZSceneSK_BeginHorizontalExit
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_BeginHorizontalExit:
                move.l  #LBZSceneSK_MoveTickHitAndDraw,(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_MoveTickHitAndDraw:
                jsr     (MoveSprite2).l
                jsr     (UpdateLBZAct1RobotnikHitCooldown).l
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

LBZSceneSK_InitAttachedBoxAndParts:
                move.l  #LBZSceneSK_AttachedBoxCheckRelease,(a0)
                lea     LBZSceneSK_BoxPartChildren(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

LBZSceneSK_AttachedBoxCheckRelease:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   LBZSceneSK_AttachedBoxFollow
                move.l  #Obj_Wait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #LBZSceneSK_AttachedBoxTryMusic,$34(a0)
                move.w  #$160,y_pos(a0)

LBZSceneSK_AttachedBoxFollow:
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

LBZSceneSK_AttachedBoxTryMusic:
                bsr.w   ScheduleLBZMinibossMusicTransition

LBZSceneSK_ReleasePartsAndSpawnBoss:
                bset    #3,$38(a0)
                moveq   #signextendB(sfx_BossActivate),d0
                jsr     (Play_SFX).l
                lea     LBZSceneSK_MinibossRootChild(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     Go_Delete_Sprite_2(pc)
; ---------------------------------------------------------------------------

Obj_LBZMinibossBox:
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   LBZSceneSK_StandaloneBoxSetRangeCull
                tst.b   (_unkFAAB).w
                bne.s   LBZSceneSK_StandaloneBoxSetRangeCull
                move.l  #LBZSceneSK_StandaloneBoxCheckPlayer,(a0)
                move.w  #$3EA0,(Camera_max_X_pos).w
                move.w  #$3C00,(Camera_min_X_pos).w
                lea     LBZSceneSK_BoxPartChildren(pc),a2
                jsr     (CreateChild3_NormalRepeated).l
                bsr.w   ScheduleLBZMinibossMusicTransition
                bra.w   QueueLBZMinibossBoxAndExplosionGraphics
; ---------------------------------------------------------------------------

LBZSceneSK_StandaloneBoxSetRangeCull:
                move.l  #Delete_Sprite_If_Not_In_Range,(a0)
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_StandaloneBoxCheckPlayer:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                cmpi.w  #$70,d2
                bhs.s   LBZSceneSK_StandaloneBoxCheckRange
                move.l  #Obj_Wait,(a0)
                move.w  #$3DA0,(Camera_min_X_pos).w
                move.w  #$1F,$2E(a0)
                move.l  #LBZSceneSK_ReleasePartsAndSpawnBoss,$34(a0)

LBZSceneSK_StandaloneBoxCheckRange:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   LBZSceneSK_StandaloneBoxClearRespawn
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_StandaloneBoxClearRespawn:
                jmp     SKCull_ReleaseRespawnForStatusDelete(pc)
; ---------------------------------------------------------------------------

LBZSceneSK_BoxPartDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZSceneSK_BoxPartStateOffsets(pc,d0.w),d1
                jsr     LBZSceneSK_BoxPartStateOffsets(pc,d1.w)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZSceneSK_BoxPartDeleteWithParent
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZSceneSK_BoxPartDeleteWithParent:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------
LBZSceneSK_BoxPartStateOffsets:
                dc.w    LBZSceneSK_InitBoxPartAndPlan-LBZSceneSK_BoxPartStateOffsets
                dc.w    LBZSceneSK_BoxPartFollowUntilRelease-LBZSceneSK_BoxPartStateOffsets
                dc.w    LBZSceneSK_BoxPartTickOpeningDelay-LBZSceneSK_BoxPartStateOffsets
                dc.w    LBZSceneSK_BoxPartAnimateOpening-LBZSceneSK_BoxPartStateOffsets
                dc.w    LBZSceneSK_BoxPartMoveAndTickSplit-LBZSceneSK_BoxPartStateOffsets
                dc.w    LBZSceneSK_BoxPartAnimateFinal-LBZSceneSK_BoxPartStateOffsets
; ---------------------------------------------------------------------------

LBZSceneSK_InitBoxPartAndPlan:
                lea     LBZSceneSK_BoxPartAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bra.w   LBZSceneSK_BoxPartLoadSubtypePlan
; ---------------------------------------------------------------------------

LBZSceneSK_BoxPartFollowUntilRelease:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   LBZSceneSK_BoxPartBeginOpeningDelay
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

LBZSceneSK_BoxPartBeginOpeningDelay:
                move.b  #4,routine(a0)
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   LBZSceneSK_BoxPartLayoutGateReturn
                move.w  #$55,(Events_fg_4).w

LBZSceneSK_BoxPartLayoutGateReturn:
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_BoxPartTickOpeningDelay:
                subq.w  #1,$2E(a0)
                bpl.s   LBZSceneSK_BoxPartDelayReturn
                move.b  #6,routine(a0)

LBZSceneSK_BoxPartDelayReturn:
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_BoxPartAnimateOpening:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

LBZSceneSK_BoxPartBeginSplitFlight:
                move.b  #8,routine(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                subi.w  #$C,d0
                move.w  LBZSceneSK_BoxPartSplitYSpeeds(pc,d0.w),y_vel(a0)
                add.w   d0,d0
                move.l  LBZSceneSK_BoxPartFinalAnimPointers(pc,d0.w),$30(a0)
                move.l  #LBZSceneSK_BoxPartSetSettledDraw,$34(a0)
                move.w  #$5F,$2E(a0)
                rts
; ---------------------------------------------------------------------------
LBZSceneSK_BoxPartFinalAnimPointers:
                dc.l    LBZSceneSK_BoxSettleFrames0To2
                dc.l    LBZSceneSK_BoxSettleFrames0To2
                dc.l    LBZSceneSK_BoxSettleFrames3To5
                dc.l    LBZSceneSK_BoxSettleFrames3To5
LBZSceneSK_BoxPartSplitYSpeeds:
                dc.w    -$40,   $40,  -$40,   $40
; ---------------------------------------------------------------------------

LBZSceneSK_BoxPartMoveAndTickSplit:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   LBZSceneSK_BoxPartBeginFinalAnimation
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_BoxPartBeginFinalAnimation:
                move.b  #$A,routine(a0)

LBZSceneSK_BoxPartAndDualDefeatReturn:
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_BoxPartAnimateFinal:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

LBZSceneSK_BoxPartSetSettledDraw:
                move.l  #LBZSceneSK_SettledBoxPartDrawOrCull,(a0)
                move.w  #$380,priority(a0)
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_SettledBoxPartDrawOrCull:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   LBZSceneSK_SettledBoxPartRestoreArt
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZSceneSK_SettledBoxPartRestoreArt:
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   LBZSceneSK_SettledBoxPartLoadBubbles
                cmpi.b  #$C,subtype(a0)
                bne.s   LBZSceneSK_DeleteSettledBoxPart
                lea     (PLC_MonitorsSpikesSprings).l,a1
                jsr     (Load_PLC_Raw).l

LBZSceneSK_SettledBoxPartLoadBubbles:
                lea     PLC_LBZRobotnikAfter(pc),a1
                jsr     (Load_PLC_Raw).l

LBZSceneSK_DeleteSettledBoxPart:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
PLC_LBZRobotnikAfter:   plrlistheader
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
PLC_LBZRobotnikAfter_End:
                plreq   ArtTile_LBZMisc, ArtNem_LBZMisc

LBZSceneSK_KnucklesArenaCameraBounds:
                dc.w    $7B6,  $9C0, $3BA0, $3CA0
                dc.w    $7B6,  $936, $3BC0, $3C80
; ---------------------------------------------------------------------------

Obj_LBZMinibossBoxKnux:
                lea     LBZSceneSK_KnucklesArenaCameraBounds(pc),a1
                jsr     (Check_CameraInRange).l
                move.w  (a1)+,(Camera_min_Y_pos).w
                move.w  (a1),(Camera_max_Y_pos).w
                move.w  (a1)+,(Camera_target_max_Y_pos).w
                move.w  (a1)+,(Camera_min_X_pos).w
                move.w  (a1)+,(Camera_max_X_pos).w
                bsr.w   QueueLBZMinibossBoxAndExplosionGraphics
                lea     LBZSceneSK_KnucklesBoxChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #LBZSceneSK_KnucklesWaitToReleaseBoxes,(a0)

LBZSceneSK_KnucklesWaitToReleaseBoxes:
                cmpi.w  #$932,(Camera_Y_pos).w
                blo.s   LBZSceneSK_KnucklesReleaseGateReturn
                move.l  #LBZSceneSK_KnucklesWaitBothBosses,(a0)
                bset    #1,$38(a0)

LBZSceneSK_KnucklesReleaseGateReturn:
                rts
; ---------------------------------------------------------------------------

; Completion requires both subtype bits, 0 and 2, before the exit sequence starts
LBZSceneSK_KnucklesWaitBothBosses:
                move.b  $38(a0),d0
                andi.b  #5,d0
                cmpi.b  #5,d0
                bne.w   LBZSceneSK_BoxPartAndDualDefeatReturn
                move.l  #LBZSceneSK_KnucklesTickLayoutWait,(a0)
                move.w  #$1F,$2E(a0)
                move.w  #$A80,d0
                move.w  d0,(Camera_stored_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                jsr     (AllocateObject).l
                bne.s   LBZSceneSK_KnucklesStopTimerAndSpawnExit
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

LBZSceneSK_KnucklesStopTimerAndSpawnExit:
                clr.b   (Update_HUD_timer).w
                lea     (Child6_IncLevY).l,a2
                jsr     (CreateChild6_Simple).l
                lea     LBZSceneSK_KnucklesExitExplosionChildren(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

LBZSceneSK_KnucklesTickLayoutWait:
                subq.w  #1,$2E(a0)
                bmi.s   LBZSceneSK_KnucklesRequestExitLayout
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_KnucklesRequestExitLayout:
                move.l  #LBZSceneSK_KnucklesFadeAtFinalCameraY,(a0)
                move.w  #$55,(Events_fg_4).w
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_KnucklesFadeAtFinalCameraY:
                cmpi.w  #$A7C,(Camera_Y_pos).w
                blo.s   LBZSceneSK_KnucklesFinalCameraReturn
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #Obj_EndSignControl,$34(a0)

LBZSceneSK_KnucklesFinalCameraReturn:
                rts
; ---------------------------------------------------------------------------

LBZSceneSK_InitKnucklesBoxAndParts:
                move.l  #LBZSceneSK_KnucklesBoxWaitRelease,(a0)
                lea     LBZSceneSK_BoxPartChildren(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

LBZSceneSK_KnucklesBoxWaitRelease:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   LBZSceneSK_KnucklesBoxReleaseReturn
                move.l  #Obj_Wait,(a0)
                move.w  #(2*60)-1,$2E(a0)
                move.l  #LBZSceneSK_KnucklesBoxSpawnBoss,$34(a0)
                tst.b   subtype(a0)
                bne.s   LBZSceneSK_KnucklesBoxReleaseReturn
                bsr.w   ScheduleLBZMinibossMusicTransition

LBZSceneSK_KnucklesBoxReleaseReturn:
                rts
; ---------------------------------------------------------------------------

; Give the spawned boss the box's subtype and the shared coordinator as its parent
LBZSceneSK_KnucklesBoxSpawnBoss:
                bset    #3,$38(a0)
                moveq   #signextendB(sfx_BossActivate),d0
                jsr     (Play_SFX).l
                lea     LBZSceneSK_MinibossRootChild(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   LBZSceneSK_KnucklesBoxQueueDelete
                movea.w parent3(a0),a2
                move.w  a2,parent3(a1)
                move.b  subtype(a0),subtype(a1)

LBZSceneSK_KnucklesBoxQueueDelete:
                jmp     Go_Delete_Sprite_2(pc)
; ---------------------------------------------------------------------------

LBZSceneSK_InitKnucklesExitExplosion:
                move.l  #Obj_Wait,(a0)
                move.w  #$FF,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  LBZSceneSK_KnucklesExitExplosionXs(pc,d0.w),x_pos(a0)
                move.w  #$A20,y_pos(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
LBZSceneSK_KnucklesExitExplosionXs:
                dc.w    $3C40, $3C80, $3CC0, $3D00, $3D40

; =============== S U B R O U T I N E =======================================

QueueLBZMinibossBoxAndExplosionGraphics:
                lea     (ArtKosM_LBZMiniboss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_LBZMinibossBox).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMinibossBox),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_BossExplosion).l,a1
                jmp     (Load_PLC_Raw).l
; End of function QueueLBZMinibossBoxAndExplosionGraphics

; =============== S U B R O U T I N E =======================================

ScheduleLBZMinibossMusicTransition:
                jsr     (AllocateObject).l
                bne.s   LBZSceneSK_MinibossMusicSpawnReturn
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

LBZSceneSK_MinibossMusicSpawnReturn:
                rts
; End of function ScheduleLBZMinibossMusicTransition

; ---------------------------------------------------------------------------

LBZSceneSK_BoxPartLoadSubtypePlan:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  LBZSceneSK_BoxPartOpeningDelays(pc,d0.w),$2E(a0)
                add.w   d0,d0
                move.l  LBZSceneSK_BoxPartOpeningAnimPointers(pc,d0.w),$30(a0)
                move.l  LBZSceneSK_BoxPartAnimCallbackPointers(pc,d0.w),$34(a0)
                lea     LBZSceneSK_BoxPartSubtypePoseRecords(pc),a1
                adda.w  d0,a1
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,d1
                or.b    d1,render_flags(a0)
                move.b  (a1)+,d1
                move.b  d1,child_dx(a0)
                ext.w   d1
                add.w   d1,x_pos(a0)
                move.b  (a1)+,d1
                move.b  d1,child_dy(a0)
                ext.w   d1
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
LBZSceneSK_BoxPartOpeningDelays:
                dc.w    0
                dc.w    0
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $40
                dc.w    $50
                dc.w    $70
                dc.w    $60
LBZSceneSK_BoxPartOpeningAnimPointers:
                dc.l    LBZSceneSK_BoxOpenFrames6To8
                dc.l    LBZSceneSK_BoxOpenFrames6To8
                dc.l    LBZSceneSK_BoxOpenFrames9To11
                dc.l    LBZSceneSK_BoxOpenFrames9To11
                dc.l    LBZSceneSK_BoxOpenFrames9To11
                dc.l    LBZSceneSK_BoxOpenFrames9To11
                dc.l    LBZSceneSK_BoxSplitFromFrame0
                dc.l    LBZSceneSK_BoxSplitFromFrame0
                dc.l    LBZSceneSK_BoxSplitFromFrame3
                dc.l    LBZSceneSK_BoxSplitFromFrame3
LBZSceneSK_BoxPartAnimCallbackPointers:
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    LBZSceneSK_BoxPartBeginSplitFlight
                dc.l    LBZSceneSK_BoxPartBeginSplitFlight
                dc.l    LBZSceneSK_BoxPartBeginSplitFlight
                dc.l    LBZSceneSK_BoxPartBeginSplitFlight
LBZSceneSK_BoxPartSubtypePoseRecords:
                dc.b    6,   0,-$10,   0
                dc.b    6,   2, $10,   0
                dc.b    9,   0,   0, $14
                dc.b    9,   1,   0,  $C
                dc.b    9,   0,   0, -$C
                dc.b    9,   1,   0,-$14
                dc.b    0,   0, -$C,-$10
                dc.b    0,   3,  $C, $10
                dc.b    3,   0, $14, -$C
                dc.b    3,   3,-$14,  $C
                even

; =============== S U B R O U T I N E =======================================

UpdateLBZAct1RobotnikHitCooldown:
                tst.b   collision_flags(a0)
                bne.s   LBZSceneSK_RobotnikHitUpdateReturn
                tst.b   $20(a0)
                bne.s   LBZSceneSK_RobotnikTickHitCooldown
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

LBZSceneSK_RobotnikTickHitCooldown:
                subq.b  #1,$20(a0)
                bne.s   LBZSceneSK_RobotnikHitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

LBZSceneSK_RobotnikHitUpdateReturn:
                rts
; End of function UpdateLBZAct1RobotnikHitCooldown

; ---------------------------------------------------------------------------
ObjDat_LBZ1Robotnik:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $100
                dc.b    $20, $20,  $A,  $F
LBZSceneSK_BoxPartAttributes:
                dc.l    Map_LBZMinibossBox
                dc.w    make_art_tile(ArtTile_LBZMinibossBox,2,0)
                dc.w    $100
                dc.b    $14, $14,   0,   0
LBZSceneSK_UnusedRingAttributes:                        ; unused
                dc.l    Map_Ring
                dc.w    make_art_tile(ArtTile_Ring,1,1)
                dc.w    0
                dc.b    8,   8,   0,   0
LBZSceneSK_AttachedBoxChild:
                dc.w    1-1
                dc.l    LBZSceneSK_InitAttachedBoxAndParts
                dc.b    0, $34
LBZSceneSK_BoxPartChildren:
                dc.w    $A-1
                dc.l    LBZSceneSK_BoxPartDispatchAndDraw
                dc.b    0,   0
LBZSceneSK_MinibossRootChild:
                dc.w    1-1
                dc.l    Obj_LBZMiniboss
                dc.b    0,   0
LBZSceneSK_KnucklesBoxChildren:
                dc.w    2-1
                dc.l    LBZSceneSK_InitKnucklesBoxAndParts
                dc.b    -$20,   0
                dc.l    LBZSceneSK_InitKnucklesBoxAndParts
                dc.b    $20,   0
LBZSceneSK_KnucklesExitExplosionChildren:
                dc.w    5-1
                dc.l    LBZSceneSK_InitKnucklesExitExplosion
LBZSceneSK_BoxOpenFrames6To8:
                dc.b    0,   6,   7,   8, $F4
LBZSceneSK_BoxOpenFrames9To11:
                dc.b    0,   9,  $A,  $B, $F4
LBZSceneSK_BoxSettleFrames0To2:
                dc.b    5,   0,   1,   2, $F4
LBZSceneSK_BoxSettleFrames3To5:
                dc.b    5,   3,   4,   5, $F4
LBZSceneSK_BoxSplitFromFrame0:
                dc.b    0,   0,   0, $F4
LBZSceneSK_BoxSplitFromFrame3:
                dc.b    0,   3,   3, $F4
                even
