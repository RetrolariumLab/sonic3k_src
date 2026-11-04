; Owner: objects/bosses/lbz/s3
; Responsibility: Launch Base act-one Robotnik and miniboss-box scene states, helpers and private object records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZ1Robotnik:
                lea     LBZSceneS3_CameraActivationBounds(pc),a1
                jsr     Check_CameraInRange(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZ1Robotnik_Index(pc,d0.w),d1
                jsr     LBZ1Robotnik_Index(pc,d1.w)
                jsr     (UpdateLBZAct1RobotnikHitCooldown).l
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
LBZ1Robotnik_Index:
                dc.w    LBZSceneS3_InitRobotnikSceneAndBox-LBZ1Robotnik_Index
                dc.w    LBZSceneS3_WaitPlayerForFirstRetreat-LBZ1Robotnik_Index
                dc.w    LBZSceneS3_RiseToFirstHeightGate-LBZ1Robotnik_Index
                dc.w    LBZSceneS3_CheckCameraAndGroundedPlayer-LBZ1Robotnik_Index
                dc.w    LBZSceneS3_WaitForCollapseEvent-LBZ1Robotnik_Index
                dc.w    LBZSceneS3_AdvanceCameraMinimumX-LBZ1Robotnik_Index
                dc.w    LBZSceneS3_RiseToSecondHeightGate-LBZ1Robotnik_Index
                dc.w    LBZSceneS3_MoveToExitHeight-LBZ1Robotnik_Index
LBZSceneS3_CameraActivationBounds:
                dc.w    $500,  $5E0, $3820, $3AC0
; ---------------------------------------------------------------------------

LBZSceneS3_InitRobotnikSceneAndBox:
                lea     ObjDat_LBZ1Robotnik(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #-1,collision_property(a0)
                st      (LbzRobotnikSceneLoadedLatch).w
                jsr     (Swing_Setup1).l
                move.w  #$3820,(Camera_min_X_pos).w
                move.w  #$3AE8,(Camera_max_X_pos).w
                moveq   #PLCID_60,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_LBZMinibossBox).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMinibossBox),d2
                jsr     (Queue_Kos_Module).l
                lea     (Child1_MakeRoboHead3).l,a2
                jsr     CreateChild1_Normal(pc)
                lea     LBZSceneS3_AttachedBoxChild(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

LBZSceneS3_WaitPlayerForFirstRetreat:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                tst.w   d1
                beq.s   LBZSceneS3_BeginFirstFastRetreat
                cmpi.w  #$70,d2
                bhs.s   LBZSceneS3_SwingAndMoveWhileWaiting
                cmpi.w  #$60,d3
                bhs.s   LBZSceneS3_SwingAndMoveWhileWaiting
                btst    #Status_InAir,status(a1)
                beq.s   LBZSceneS3_BeginFirstFastRetreat

LBZSceneS3_SwingAndMoveWhileWaiting:
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

LBZSceneS3_BeginFirstFastRetreat:
                move.b  #4,routine(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZSceneS3_RiseToFirstHeightGate:
                cmpi.w  #$300,y_pos(a0)
                blo.s   LBZSceneS3_TeleportToSecondGate
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

LBZSceneS3_TeleportToSecondGate:
                move.b  #6,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #$3EC0,x_pos(a0)
                move.w  #$1A0,y_pos(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

LBZSceneS3_CheckCameraAndGroundedPlayer:
                lea     (Player_1).w,a1
                cmpi.w  #$3B40,(Camera_X_pos).w
                blo.s   LBZSceneS3_CollapseGateReturn
                cmpi.w  #$1C0,y_pos(a1)
                blo.s   LBZSceneS3_CollapseGateReturn
                btst    #Status_InAir,status(a1)
                beq.s   LBZSceneS3_RequestLevelCollapse

LBZSceneS3_CollapseGateReturn:
                rts
; ---------------------------------------------------------------------------

; Set the event's high byte and then wait for the entire word to clear
LBZSceneS3_RequestLevelCollapse:
                move.b  #8,routine(a0)
                st      (Events_fg_4).w
                rts
; ---------------------------------------------------------------------------

LBZSceneS3_WaitForCollapseEvent:
                tst.w   (Events_fg_4).w
                beq.s   LBZSceneS3_QueueBoxArtAndOpenCamera
                rts
; ---------------------------------------------------------------------------

LBZSceneS3_QueueBoxArtAndOpenCamera:
                move.b  #$A,routine(a0)
                lea     (ArtKosM_LBZMinibossBox).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMinibossBox),d2
                jsr     (Queue_Kos_Module).l
                move.w  #$3EA0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

LBZSceneS3_AdvanceCameraMinimumX:
                move.w  (Camera_X_pos).w,d0
                cmpi.w  #$3E50,d0
                bhs.s   LBZSceneS3_WaitPlayerForSecondRetreat
                move.w  d0,(Camera_min_X_pos).w

LBZSceneS3_WaitPlayerForSecondRetreat:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                blo.s   LBZSceneS3_BeginSecondFastRetreat
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

LBZSceneS3_BeginSecondFastRetreat:
                move.b  #$C,routine(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZSceneS3_RiseToSecondHeightGate:
                cmpi.w  #$12C,y_pos(a0)
                bls.s   LBZSceneS3_ReleaseBoxAndExitDiagonally
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

LBZSceneS3_ReleaseBoxAndExitDiagonally:
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

LBZSceneS3_MoveToExitHeight:
                jsr     (MoveSprite2).l
                cmpi.w  #$1B8,y_pos(a0)
                bhs.s   LBZSceneS3_BeginHorizontalExit
                rts
; ---------------------------------------------------------------------------

LBZSceneS3_BeginHorizontalExit:
                move.l  #LBZSceneS3_MoveTickHitAndDraw,(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

LBZSceneS3_MoveTickHitAndDraw:
                jsr     (MoveSprite2).l
                jsr     (UpdateLBZAct1RobotnikHitCooldown).l
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

LBZSceneS3_InitAttachedBoxAndParts:
                move.l  #LBZSceneS3_AttachedBoxCheckRelease,(a0)
                lea     LBZSceneS3_BoxPartChildren(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

LBZSceneS3_AttachedBoxCheckRelease:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   LBZSceneS3_AttachedBoxFollow
                move.l  #Obj_Wait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #LBZSceneS3_AttachedBoxTryMusic,$34(a0)
                move.w  #$160,y_pos(a0)

LBZSceneS3_AttachedBoxFollow:
                jmp     Refresh_ChildPosition(pc)
; ---------------------------------------------------------------------------

LBZSceneS3_AttachedBoxTryMusic:
                jsr     (AllocateObject).l
                bne.s   LBZSceneS3_ReleasePartsAndSpawnBoss
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

LBZSceneS3_ReleasePartsAndSpawnBoss:
                bset    #3,$38(a0)
                moveq   #signextendB(sfx_BossActivate),d0
                jsr     (Play_SFX).l
                lea     LBZSceneS3_MinibossRootChild(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Go_Delete_Sprite_2(pc)
; ---------------------------------------------------------------------------

Obj_LBZMinibossBox:
                tst.b   (LbzRobotnikSceneLoadedLatch).w
                bne.s   LBZSceneS3_StandaloneBoxSetRangeCull
                move.l  #LBZSceneS3_StandaloneBoxCheckPlayer,(a0)
                move.w  #$3EA0,(Camera_max_X_pos).w
                move.w  #$3C00,(Camera_min_X_pos).w
                lea     (ArtKosM_LBZMiniboss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_LBZMinibossBox).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMinibossBox),d2
                jsr     (Queue_Kos_Module).l
                lea     PLC_BossExplosion(pc),a1
                jsr     (Load_PLC_Raw).l
                jsr     (AllocateObject).l
                bne.s   LBZSceneS3_StandaloneBoxSpawnParts
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

LBZSceneS3_StandaloneBoxSpawnParts:
                lea     LBZSceneS3_BoxPartChildren(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

LBZSceneS3_StandaloneBoxSetRangeCull:
                move.l  #Delete_Sprite_If_Not_In_Range,(a0)
                rts
; ---------------------------------------------------------------------------

LBZSceneS3_StandaloneBoxCheckPlayer:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                cmpi.w  #$70,d2
                bhs.s   LBZSceneS3_StandaloneBoxCheckRange
                move.l  #Obj_Wait,(a0)
                move.w  #$3DA0,(Camera_min_X_pos).w
                move.w  #$1F,$2E(a0)
                move.l  #LBZSceneS3_ReleasePartsAndSpawnBoss,$34(a0)

LBZSceneS3_StandaloneBoxCheckRange:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   LBZSceneS3_StandaloneBoxClearRespawn
                rts
; ---------------------------------------------------------------------------

LBZSceneS3_StandaloneBoxClearRespawn:
                jmp     S3Cull_ReleaseRespawnForStatusDelete(pc)
; ---------------------------------------------------------------------------

LBZSceneS3_BoxPartDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZSceneS3_BoxPartStateOffsets(pc,d0.w),d1
                jsr     LBZSceneS3_BoxPartStateOffsets(pc,d1.w)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZSceneS3_BoxPartDeleteWithParent
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZSceneS3_BoxPartDeleteWithParent:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------
LBZSceneS3_BoxPartStateOffsets:
                dc.w    LBZSceneS3_InitBoxPartAndPlan-LBZSceneS3_BoxPartStateOffsets
                dc.w    LBZSceneS3_BoxPartFollowUntilRelease-LBZSceneS3_BoxPartStateOffsets
                dc.w    LBZSceneS3_BoxPartTickOpeningDelay-LBZSceneS3_BoxPartStateOffsets
                dc.w    LBZSceneS3_BoxPartAnimateOpening-LBZSceneS3_BoxPartStateOffsets
                dc.w    LBZSceneS3_BoxPartMoveAndTickSplit-LBZSceneS3_BoxPartStateOffsets
                dc.w    LBZSceneS3_BoxPartAnimateFinal-LBZSceneS3_BoxPartStateOffsets
; ---------------------------------------------------------------------------

LBZSceneS3_InitBoxPartAndPlan:
                lea     LBZSceneS3_BoxPartAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bra.w   LBZSceneS3_BoxPartLoadSubtypePlan
; ---------------------------------------------------------------------------

LBZSceneS3_BoxPartFollowUntilRelease:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   LBZSceneS3_BoxPartBeginOpeningDelay
                jmp     Refresh_ChildPosition(pc)
; ---------------------------------------------------------------------------

LBZSceneS3_BoxPartBeginOpeningDelay:
                move.b  #4,routine(a0)
                move.w  #$55,(Events_fg_4).w
                rts
; ---------------------------------------------------------------------------

LBZSceneS3_BoxPartTickOpeningDelay:
                subq.w  #1,$2E(a0)
                bpl.s   LBZSceneS3_BoxPartDelayReturn
                move.b  #6,routine(a0)

LBZSceneS3_BoxPartDelayReturn:
                rts
; ---------------------------------------------------------------------------

LBZSceneS3_BoxPartAnimateOpening:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

LBZSceneS3_BoxPartBeginSplitFlight:
                move.b  #8,routine(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                subi.w  #$C,d0
                move.w  LBZSceneS3_BoxPartSplitYSpeeds(pc,d0.w),y_vel(a0)
                add.w   d0,d0
                move.l  LBZSceneS3_BoxPartFinalAnimPointers(pc,d0.w),$30(a0)
                move.l  #LBZSceneS3_BoxPartSetSettledDraw,$34(a0)
                move.w  #$5F,$2E(a0)
                rts
; ---------------------------------------------------------------------------
LBZSceneS3_BoxPartFinalAnimPointers:
                dc.l    LBZSceneS3_BoxSettleFrames0To2
                dc.l    LBZSceneS3_BoxSettleFrames0To2
                dc.l    LBZSceneS3_BoxSettleFrames3To5
                dc.l    LBZSceneS3_BoxSettleFrames3To5
LBZSceneS3_BoxPartSplitYSpeeds:
                dc.w    -$40,   $40,  -$40,   $40
; ---------------------------------------------------------------------------

LBZSceneS3_BoxPartMoveAndTickSplit:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   LBZSceneS3_BoxPartBeginFinalAnimation
                rts
; ---------------------------------------------------------------------------

LBZSceneS3_BoxPartBeginFinalAnimation:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

LBZSceneS3_BoxPartAnimateFinal:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

LBZSceneS3_BoxPartSetSettledDraw:
                move.l  #LBZSceneS3_SettledBoxPartDrawOrCull,(a0)
                move.w  #$380,priority(a0)
                rts
; ---------------------------------------------------------------------------

LBZSceneS3_SettledBoxPartDrawOrCull:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   LBZSceneS3_SettledBoxPartRestoreArt
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZSceneS3_SettledBoxPartRestoreArt:
                cmpi.b  #$C,subtype(a0)
                bne.s   LBZSceneS3_DeleteSettledBoxPart
                lea     PLC_MonitorsSpikesSprings(pc),a1
                jsr     (Load_PLC_Raw).l
                lea     PLC_LBZRobotnikAfter(pc),a1
                jsr     (Load_PLC_Raw).l

LBZSceneS3_DeleteSettledBoxPart:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
PLC_LBZRobotnikAfter:   plrlistheader
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
PLC_LBZRobotnikAfter_End:
; unused
                plreq   ArtTile_LBZMisc, ArtNem_LBZMisc
; ---------------------------------------------------------------------------

LBZSceneS3_BoxPartLoadSubtypePlan:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  LBZSceneS3_BoxPartOpeningDelays(pc,d0.w),$2E(a0)
                add.w   d0,d0
                move.l  LBZSceneS3_BoxPartOpeningAnimPointers(pc,d0.w),$30(a0)
                move.l  LBZSceneS3_BoxPartAnimCallbackPointers(pc,d0.w),$34(a0)
                lea     LBZSceneS3_BoxPartSubtypePoseRecords(pc),a1
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
LBZSceneS3_BoxPartOpeningDelays:
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
LBZSceneS3_BoxPartOpeningAnimPointers:
                dc.l    LBZSceneS3_BoxOpenFrames6To8
                dc.l    LBZSceneS3_BoxOpenFrames6To8
                dc.l    LBZSceneS3_BoxOpenFrames9To11
                dc.l    LBZSceneS3_BoxOpenFrames9To11
                dc.l    LBZSceneS3_BoxOpenFrames9To11
                dc.l    LBZSceneS3_BoxOpenFrames9To11
                dc.l    LBZSceneS3_BoxSplitFromFrame0
                dc.l    LBZSceneS3_BoxSplitFromFrame0
                dc.l    LBZSceneS3_BoxSplitFromFrame3
                dc.l    LBZSceneS3_BoxSplitFromFrame3
LBZSceneS3_BoxPartAnimCallbackPointers:
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    LBZSceneS3_BoxPartBeginSplitFlight
                dc.l    LBZSceneS3_BoxPartBeginSplitFlight
                dc.l    LBZSceneS3_BoxPartBeginSplitFlight
                dc.l    LBZSceneS3_BoxPartBeginSplitFlight
LBZSceneS3_BoxPartSubtypePoseRecords:
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
                bne.s   LBZSceneS3_RobotnikHitUpdateReturn
                tst.b   $20(a0)
                bne.s   LBZSceneS3_RobotnikTickHitCooldown
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

LBZSceneS3_RobotnikTickHitCooldown:
                subq.b  #1,$20(a0)
                bne.s   LBZSceneS3_RobotnikHitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

LBZSceneS3_RobotnikHitUpdateReturn:
                rts
; End of function UpdateLBZAct1RobotnikHitCooldown

; ---------------------------------------------------------------------------
ObjDat_LBZ1Robotnik:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $100
                dc.b    $20, $20,  $A,  $F
LBZSceneS3_BoxPartAttributes:
                dc.l    Map_LBZMinibossBox
                dc.w    make_art_tile(ArtTile_LBZMinibossBox,2,0)
                dc.w    $100
                dc.b    $14, $14,   0,   0
LBZSceneS3_AttachedBoxChild:
                dc.w    1-1
                dc.l    LBZSceneS3_InitAttachedBoxAndParts
                dc.b    0, $34
LBZSceneS3_BoxPartChildren:
                dc.w    $A-1
                dc.l    LBZSceneS3_BoxPartDispatchAndDraw
                dc.b    0,   0
LBZSceneS3_MinibossRootChild:
                dc.w    1-1
                dc.l    Obj_LBZMiniboss
                dc.b    0,   0
LBZSceneS3_BoxOpenFrames6To8:
                dc.b    0,   6,   7,   8, $F4
LBZSceneS3_BoxOpenFrames9To11:
                dc.b    0,   9,  $A,  $B, $F4
LBZSceneS3_BoxSettleFrames0To2:
                dc.b    5,   0,   1,   2, $F4
LBZSceneS3_BoxSettleFrames3To5:
                dc.b    5,   3,   4,   5, $F4
LBZSceneS3_BoxSplitFromFrame0:
                dc.b    0,   0,   0, $F4
LBZSceneS3_BoxSplitFromFrame3:
                dc.b    0,   3,   3, $F4
                even
