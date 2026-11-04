; Owner: objects/bosses/ssz/knuckles_boss/sk
; Responsibility: Knuckles final-boss crane actor, linked children, platform interaction and scene motion
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_KnuxFinalBossCrane:
                move.l  #SSZCrane_WaitForPlayerAirborne,(a0)
                move.w  (Camera_min_X_pos).w,(Camera_max_X_pos).w
                lea     PLC_KnuxFinalBossCrane(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------
PLC_KnuxFinalBossCrane: plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
PLC_KnuxFinalBossCrane_End:
; ---------------------------------------------------------------------------

SSZCrane_WaitForPlayerAirborne:
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                beq.w   SSZMechaBattleAndChildren_SharedReturn
                move.l  #SSZCrane_MoveLeftToDeployClaw,(a0)
                lea     (SKHpzSszSceneShip_CoreAttributes).l,a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #-$80,x_vel(a0)
                jsr     (Swing_Setup1).l
                jsr     (AllocateObject).l
                bne.s   SSZCrane_SpawnAttachmentsAndLoadArt
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

SSZCrane_SpawnAttachmentsAndLoadArt:
                lea     (Child1_MakeRoboHead4).l,a2
                jsr     CreateChild1_Normal(pc)
                lea     SSZCraneGrabber_NormalChildRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     CreateChild1_Normal(pc)
                lea     (ArtKosM_KnuxFinalBossCrane).l,a1
                move.w  #tiles_to_bytes(ArtTile_HPZSSZBossCrane),d2
                jsr     (Queue_Kos_Module).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZCrane_MoveLeftToDeployClaw:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                cmpi.w  #$120,x_pos(a0)
                bhs.s   SSZKnucklesCraneShip_DrawEntryMotion
                move.l  #SSZCrane_CheckClawLowered,(a0)
                clr.w   x_vel(a0)
                bset    #0,(SceneSyncFlagsOrMHZState).w

SSZKnucklesCraneShip_DrawEntryMotion:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZCrane_CheckClawLowered:
                btst    #1,(SceneSyncFlagsOrMHZState).w
                beq.s   SSZCrane_CheckPlayerCaptured
                move.l  #SSZCrane_CheckPlayerCaptured,(a0)
                move.w  #-$80,x_vel(a0)

SSZCrane_CheckPlayerCaptured:
                btst    #2,(SceneSyncFlagsOrMHZState).w
                beq.s   SSZCrane_CheckClawRetracted
                move.l  #SSZCrane_CheckClawRetracted,(a0)
                clr.w   x_vel(a0)

SSZCrane_CheckClawRetracted:
                btst    #3,(SceneSyncFlagsOrMHZState).w
                beq.s   SSZCrane_BobMoveAndDraw
                move.l  #SSZCrane_ReturnRightAndDelayBoss,(a0)
                move.w  #$80,x_vel(a0)
                bset    #0,render_flags(a0)
                bclr    #0,(Player_1+render_flags).w

SSZCrane_BobMoveAndDraw:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZCrane_ReturnRightAndDelayBoss:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                cmpi.w  #$120,x_pos(a0)
                blo.s   SSZKnucklesCraneShip_DrawReturningMotion
                move.l  #SSZCrane_TickBossSpawnDelay,(a0)
                clr.w   x_vel(a0)
                move.w  #60-1,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   SSZKnucklesCraneShip_DrawReturningMotion
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_FinalBoss,subtype(a1)

SSZKnucklesCraneShip_DrawReturningMotion:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZCrane_TickBossSpawnDelay:
                subq.w  #1,$2E(a0)
                bne.s   SSZCrane_BobAndDrawDuringBossDelay
                move.l  #SSZCrane_CheckPlayerReleaseRange,(a0)
                st      (Scroll_lock).w
                jsr     (AllocateObject).l
                bne.s   SSZCrane_TryBossAtCameraGate
                move.l  #SSZCraneSceneCamera_AdvanceTowardFixedX,(a1)

SSZCrane_TryBossAtCameraGate:
                jsr     (AllocateObject).l
                bne.s   SSZCrane_StoreBossHandle
                move.l  #Obj_SSZEndBoss,(a1)

; Preserve the original path that stores the returned handle without a separate allocation check
SSZCrane_StoreBossHandle:
                move.w  a1,(SceneControllerObjectAddress).w

SSZCrane_BobAndDrawDuringBossDelay:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZCrane_CheckPlayerReleaseRange:
                movea.w (SceneControllerObjectAddress).w,a1
                lea     SSZCrane_PlayerReleaseBounds(pc),a2
                jsr     (Check_InMyRange).l
                beq.s   SSZCrane_MoveAndCheckBreakupRange
                move.l  #SSZCrane_MoveAndCheckBreakupRange,(a0)
                jsr     (AllocateObject).l
                bne.s   SSZCrane_SignalPlayerRelease
                move.l  #SSZCrane_InitPlayerTransfer,(a1)

SSZCrane_SignalPlayerRelease:
                bset    #5,(SceneSyncFlagsOrMHZState).w

SSZCrane_MoveAndCheckBreakupRange:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                movea.w (SceneControllerObjectAddress).w,a1
                lea     SSZCrane_ShipBreakupBounds(pc),a2
                jsr     (Check_InMyRange).l
                beq.s   SSZCrane_DrawAfterRangeChecks
                move.l  #Wait_Draw,(a0)
                move.w  #$80,priority(a0)
                move.w  #$3F,$2E(a0)
                move.l  #SSZCrane_BreakShipAndDelete,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l

SSZCrane_DrawAfterRangeChecks:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
SSZCrane_PlayerReleaseBounds:
                dc.w    -$20,   $40,     0,   $78
SSZCrane_ShipBreakupBounds:
                dc.w    -$20,   $40,     0,   $30
; ---------------------------------------------------------------------------

SSZCrane_BreakShipAndDelete:
                lea     SSZCraneShipFragments_SimpleChildRecord(pc),a2
                jsr     CreateChild6_Simple(pc)
                ori.b   #$30,$38(a0)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SSZCrane_InitPlayerTransfer:
                move.l  #SSZCrane_TransferMoveToRightBound,(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.b  #$C0,mapping_frame(a1)
                move.w  #$400,x_vel(a0)
                move.w  #$80,y_vel(a0)
                jsr     (Player_Load_PLC).l

SSZCrane_TransferMoveToRightBound:
                jsr     (MoveSprite2).l
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_pos(a0),d0
                cmp.w   (SceneMaximumXOrEmeraldSelectionTail).w,d0
                blo.w   SSZMechaBattleAndChildren_SharedReturn
                move.l  #SSZCrane_TransferTickPoseChange,(a0)
                move.w  #6,$2E(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.b  #$13,y_radius(a0)
                move.b  #$CA,mapping_frame(a1)
                jmp     (Player_Load_PLC).l
; ---------------------------------------------------------------------------

SSZCrane_TransferTickPoseChange:
                subq.w  #1,$2E(a0)
                bne.s   SSZCrane_TransferFallAndRelease
                lea     (Player_1).w,a1
                move.b  #$CB,mapping_frame(a1)
                jsr     (Player_Load_PLC).l

SSZCrane_TransferFallAndRelease:
                jsr     (MoveSprite).l
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.w   SSZMechaBattleAndChildren_SharedReturn
                lea     (Player_1).w,a1
                add.w   d1,y_pos(a1)
                clr.b   $2E(a1)
                jsr     Stop_Object(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SSZCrane_InitClawAndDetails:
                lea     (SKHpzSszCrane_LiftingHeadAttributes).l,a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #0,priority(a0)
                move.l  #SSZCrane_ClawFollowUntilDeploy,(a0)
                lea     (SKSceneData_CraneFollowerChildren).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SSZCrane_ClawFollowUntilDeploy:
                btst    #0,(SceneSyncFlagsOrMHZState).w
                bne.s   SSZCrane_ClawSaveBaseline
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZCrane_ClawSaveBaseline:
                move.l  #SSZCrane_ClawLowerTowardPlayer,(a0)
                move.b  child_dy(a0),$3A(a0)

SSZCrane_ClawLowerTowardPlayer:
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d0
                subi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                bls.s   SSZCrane_ClawSignalLowered
                move.b  y_vel(a0),d0
                addi.b  #1,d0
                move.b  d0,y_vel(a0)
                move.b  $3A(a0),d1
                add.b   d0,d1
                move.b  d1,child_dy(a0)
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZCrane_ClawSignalLowered:
                move.l  #SSZCrane_ClawCalcLengthToPlayer,(a0)
                bset    #1,(SceneSyncFlagsOrMHZState).w

SSZCrane_ClawCalcLengthToPlayer:
                move.b  $3A(a0),d0
                ext.w   d0
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d1
                add.w   d0,d1
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d2
                subi.w  #$10,d2
                sub.w   d1,d2
                bpl.s   SSZCrane_ClawStoreLengthAndClamp
                moveq   #0,d2

SSZCrane_ClawStoreLengthAndClamp:
                move.b  d2,y_vel(a0)
                add.b   d2,d0
                bpl.s   SSZCrane_ClawCheckCaptureXRange
                move.b  #$7F,d0

SSZCrane_ClawCheckCaptureXRange:
                move.b  d0,child_dy(a0)
                move.w  x_pos(a0),d0
                cmpi.w  #8,d0
                bls.s   SSZCrane_ClawCaptureAndRetract
                move.w  x_pos(a1),d1
                subi.w  #$C,d0
                cmp.w   d0,d1
                blo.s   SSZCrane_ClawTrackAndDraw
                addi.w  #$18,d0
                cmp.w   d0,d1
                bhs.s   SSZCrane_ClawTrackAndDraw

SSZCrane_ClawCaptureAndRetract:
                move.l  #SSZCrane_ClawRetractToBase,(a0)
                bset    #2,(SceneSyncFlagsOrMHZState).w
                move.b  #2,mapping_frame(a0)
                move.b  #$83,object_control(a1)
                move.b  #$CB,mapping_frame(a1)
                bset    #0,render_flags(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                jsr     (Player_Load_PLC).l
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

SSZCrane_ClawTrackAndDraw:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZCrane_ClawRetractToBase:
                move.b  y_vel(a0),d0
                subq.b  #1,d0
                bpl.s   SSZCrane_ClawStoreRetractedOffset
                move.l  #SSZCrane_ClawFollowAndCarryPlayer,(a0)
                bset    #3,(SceneSyncFlagsOrMHZState).w
                moveq   #0,d0

SSZCrane_ClawStoreRetractedOffset:
                move.b  d0,y_vel(a0)
                move.b  $3A(a0),d1
                add.b   d0,d1
                move.b  d1,child_dy(a0)

SSZCrane_ClawFollowAndCarryPlayer:
                jsr     (Refresh_ChildPositionAdjusted).l
                btst    #5,(SceneSyncFlagsOrMHZState).w
                bne.s   SSZCrane_ClawDraw
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),d0
                addi.w  #$16,d0
                move.w  d0,y_pos(a1)

SSZCrane_ClawDraw:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZCrane_InitShipDebris:
                lea     SSZCraneShipFragment_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  d0,mapping_frame(a0)
                moveq   #8,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

SSZCrane_InitFinalDebris:
                lea     SSZMechaDefeatFragment_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SSZCrane_FinalDebrisFlickerUntilExit,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     SSZCrane_FinalDebrisPositionOffsets(pc,d0.w),a1
                move.b  (a1)+,d1
                ext.w   d1
                movea.w parent3(a0),a2
                btst    #0,render_flags(a2)
                beq.s   SSZCrane_FinalDebrisSetMotionAndFrame

; Bug: should be d1
; Otherwise, Mecha Sonic's pieces will be positioned incorrectly
; when Mecha Sonic is facing the right side
                neg.w   d2
                bset    #0,render_flags(a0)

SSZCrane_FinalDebrisSetMotionAndFrame:
                add.w   d1,x_pos(a0)
                move.b  (a1)+,d2
                ext.w   d2
                add.w   d2,y_pos(a0)
                asl.w   #5,d1
                move.w  d1,x_vel(a0)
                asl.w   #4,d2
                move.w  d2,y_vel(a0)
                lsr.w   #1,d0
                move.b  d0,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
SSZCrane_FinalDebrisPositionOffsets:
                dc.b    -$14,-$24
                dc.b    -$C,-$28
                dc.b    -$C,-$18
                dc.b    -4,-$28
                dc.b    -4,-$18
                dc.b    4,-$28
                dc.b    4,-$18
                dc.b    $C,-$28
                dc.b    $C,-$18
                dc.b    $14,-$20
                dc.b    $14,-$10
                dc.b    -$14,  -4
                dc.b    -$C,  -8
                dc.b    -4,  -8
                dc.b    4,  -8
                dc.b    $C,  -8
                even
; ---------------------------------------------------------------------------

SSZCrane_FinalDebrisFlickerUntilExit:
                tst.b   (ZoneEventLatchOrBossReleaseSignal).w
                bne.s   SSZMechaFinalDebris_DeleteForSceneExit
                jmp     (Obj_FlickerMove).l
; ---------------------------------------------------------------------------

SSZMechaFinalDebris_DeleteForSceneExit:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SSZCrane_InitFinalExplosionEmitter:
                move.b  subtype(a0),d0
                subq.b  #2,d0
                bpl.s   SSZCrane_InitSideEmitterMotion
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$D0,d0
                move.w  d0,y_pos(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   SSZCrane_DeleteCenterEmitter
                move.b  #$C,subtype(a1)

SSZCrane_DeleteCenterEmitter:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SSZCrane_InitSideEmitterMotion:
                move.l  #SSZCrane_MoveEmitterUntilOffscreen,(a0)
                addi.w  #$30,y_pos(a0)
                moveq   #2,d1
                tst.b   d0
                bne.s   SSZCrane_SetStepAndTryController
                neg.w   d1

SSZCrane_SetStepAndTryController:
                move.w  d1,x_vel(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   SSZCrane_SideEmitterSpawnReturn
                move.b  #$1E,subtype(a1)

SSZCrane_SideEmitterSpawnReturn:
                rts
; ---------------------------------------------------------------------------

SSZCrane_MoveEmitterUntilOffscreen:
                move.w  x_vel(a0),d0
                move.w  x_pos(a0),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.w  (Camera_X_pos).w,d0
                subi.w  #$10,d0
                cmp.w   d0,d1
                blo.w   SSZMechaChildren_DeleteCurrent
                addi.w  #$160,d0
                cmp.w   d0,d1
                bhi.w   SSZMechaChildren_DeleteCurrent
                rts
