; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace post-encounter Knuckles movement, ship-scene setup and recovery progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

HPZKnux_PlayPeriodicCollapseSound:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$1F,d0
                bne.s   HPZKnux_TickShakeBeforeDizzyChild
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l

HPZKnux_TickShakeBeforeDizzyChild:
                subq.w  #1,$2E(a0)
                bmi.s   HPZKnux_BeginDizzyPauseAndTryChild
                rts
; ---------------------------------------------------------------------------

HPZKnux_StartShakeAndTryExplosions:
                move.b  #$1C,routine(a0)
                move.w  #$7F,$2E(a0)
                st      (Screen_shake_flag).w
                lea     SKSceneData_HPZCameraExplosionChildren(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

SKHPZKnuckles_CountResetPoseDelay:
                subq.w  #1,$2E(a0)
                bmi.s   HPZKnux_RestoreMapAndDelayRightRun
                rts
; ---------------------------------------------------------------------------

HPZKnux_BeginDizzyPauseAndTryChild:
                move.b  #$1E,routine(a0)
                move.b  #6,mapping_frame(a0)
                move.w  #$F,$2E(a0)
                lea     SKHpzKnuckles_DizzyStarsSpawnList(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   HPZKnux_DizzyChildSpawnReturn
                st      subtype(a1)

HPZKnux_DizzyChildSpawnReturn:
                rts
; ---------------------------------------------------------------------------

HPZKnux_TickPreRunAnimDelay:
                subq.w  #1,$2E(a0)
                bmi.s   SKHPZKnuckles_BeginRightwardRunStream
                rts
; ---------------------------------------------------------------------------

HPZKnux_RestoreMapAndDelayRightRun:
                move.b  #$20,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$56,mapping_frame(a0)
                bclr    #0,render_flags(a0)
                move.w  #7,$2E(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

HPZKnux_AnimateAndAccelerateRight:
                jsr     (Animate_RawCheckResult).l
                move.w  x_vel(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$400,d0
                bhs.s   HPZKnux_MoveRightToCameraMargin
                move.w  d0,x_vel(a0)

HPZKnux_MoveRightToCameraMargin:
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$180,d0
                cmp.w   x_pos(a0),d0
                blo.s   HPZKnux_RelocateAndBeginShipScene
                rts
; ---------------------------------------------------------------------------

SKHPZKnuckles_BeginRightwardRunStream:
                move.b  #$22,routine(a0)
                lea     SKSceneAnim_KnuxTravelLoopDelay4(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_AnimateAndWaitForShipReady:
                jsr     (Animate_RawCheckResult).l
                btst    #0,(_unkFAB8).w
                bne.w   HPZKnux_LaunchRightJumpOnSignal
                rts
; ---------------------------------------------------------------------------

HPZKnux_RelocateAndBeginShipScene:
                move.b  #$24,routine(a0)
                move.w  #2,$44(a0)
                move.l  #Map_HPZKnucklesGrab,mappings(a0)
                move.b  #$A,mapping_frame(a0)
                lea     SKSceneAnim_HPZLowerGrabFrames9And10(pc),a1
                jsr     (Set_Raw_Animation).l
                bset    #7,art_tile(a0)
                move.w  #$1620,x_pos(a0)
                move.w  #$3AC,y_pos(a0)
                clr.b   (_unkFAB8).w
                clr.w   (Screen_shake_flag).w
                jsr     (AllocateObject).l
                bne.s   HPZKnux_TrySpawnShipAfterGuide
                move.l  #HPZKnux_GuideWaitForTriggerAndLock,(a1)

HPZKnux_TrySpawnShipAfterGuide:
                jsr     (AllocateObject).l
                bne.s   HPZKnux_TryCameraRightLimitActor
                move.l  #HPZShip_InitReferenceAndAttachments,(a1)

HPZKnux_TryCameraRightLimitActor:
                jsr     (AllocateObject).l
                bne.s   HPZKnux_TryCameraTopLimitActor
                move.l  #Obj_IncLevEndXGradual,(a1)

HPZKnux_TryCameraTopLimitActor:
                jsr     (AllocateObject).l
                bne.s   HPZKnux_RestoreAndTryCameraBottom
                move.l  #Obj_DecLevStartYGradual,(a1)

HPZKnux_RestoreAndTryCameraBottom:
                move.w  (Camera_stored_max_Y_pos).w,(Camera_target_max_Y_pos).w
                jsr     (AllocateObject).l
                bne.s   HPZKnux_QueueCraneAndShipArt
                move.l  #Obj_IncLevEndYGradual,(a1)

HPZKnux_QueueCraneAndShipArt:
                lea     (ArtKosM_KnuxFinalBossCrane).l,a1
                move.w  #tiles_to_bytes(ArtTile_HPZSSZBossCrane),d2
                jsr     (Queue_Kos_Module).l
                lea     PLC_KnuxHPZCutsceneShip(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------
PLC_KnuxHPZCutsceneShip:    plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
PLC_KnuxHPZCutsceneShip_End:
; ---------------------------------------------------------------------------

HPZKnux_JumpTowardShipAndCheckFloor:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   HPZKnux_ShipJumpUpdateReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   HPZKnux_LandShipJumpAndPause

HPZKnux_ShipJumpUpdateReturn:
                rts
; ---------------------------------------------------------------------------

HPZKnux_LaunchRightJumpOnSignal:
                move.b  #$26,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$9A,mapping_frame(a0)
                move.w  #$C0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                lea     SKSceneAnim_KnuxJumpAndFastTravel(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SKHPZKnuckles_CountShortLandedJumpPause:
                subq.w  #1,$2E(a0)
                bmi.s   HPZKnux_LaunchLeftJumpAfterPause
                rts
; ---------------------------------------------------------------------------

HPZKnux_LandShipJumpAndPause:
                add.w   d1,y_pos(a0)
                move.b  #$28,routine(a0)
                move.b  #$D6,mapping_frame(a0)
                move.w  #8,$2E(a0)
                rts
; ---------------------------------------------------------------------------

HPZKnux_JumpLeftAndCheckHeight:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   HPZKnux_LeftJumpUpdateReturn
                cmpi.w  #$339,y_pos(a0)
                bhs.s   HPZKnux_ClampHeightAndStartGrabPause

HPZKnux_LeftJumpUpdateReturn:
                rts
; ---------------------------------------------------------------------------

HPZKnux_LaunchLeftJumpAfterPause:
                move.b  #$2A,routine(a0)
                move.w  #-$C0,x_vel(a0)
                move.w  #-$500,y_vel(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                lea     SKSceneAnim_KnuxJumpAndFastTravel(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_TickGrabPauseBeforeRun:
                subq.w  #1,$2E(a0)
                bmi.s   HPZKnux_BeginRightRunAfterGrabPause
                jmp     (Animate_RawCheckResult).l
; ---------------------------------------------------------------------------

HPZKnux_ClampHeightAndStartGrabPause:
                move.b  #$2C,routine(a0)
                move.w  #$339,y_pos(a0)
                move.w  #2,$44(a0)
                move.l  #Map_HPZKnucklesGrab,mappings(a0)
                move.b  #$A,mapping_frame(a0)
                move.w  #$7F,$2E(a0)
                lea     SKSceneAnim_HPZUpperGrabFrames11And12(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_AnimateAndCapRightRun:
                jsr     (Animate_RawCheckResult).l
                move.w  x_vel(a0),d0
                addi.w  #$C,d0
                cmpi.w  #$300,d0
                bls.s   HPZKnux_StoreRunAndCheckApproachX
                move.w  #$300,d0

HPZKnux_StoreRunAndCheckApproachX:
                move.w  d0,x_vel(a0)
                jsr     (MoveSprite2).l
                cmpi.w  #$1660,x_pos(a0)
                bhs.s   HPZKnux_BeginGrabHoldNearShip
                rts
; ---------------------------------------------------------------------------

HPZKnux_BeginRightRunAfterGrabPause:
                move.b  #$2E,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #7,mapping_frame(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                lea     SKKnucklesCutscene_SharedTravelBodyLoop(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_TickGrabHoldBeforeJump:
                subq.w  #1,$2E(a0)
                bmi.s   HPZKnux_SignalApproachAndJumpToShip
                rts
; ---------------------------------------------------------------------------

HPZKnux_BeginGrabHoldNearShip:
                move.b  #$30,routine(a0)
                move.w  #2,$44(a0)
                move.l  #Map_HPZKnucklesGrab,mappings(a0)
                move.b  #$D,mapping_frame(a0)
                move.w  #30-1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

HPZKnux_JumpAndCheckShipContact:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                movea.w (_unkFAAE).w,a1
                lea     HPZKnux_ShipContactBounds(pc),a2
                jsr     (Check_InTheirRange).l
                bne.s   HPZKnux_PauseShipAndLaunchRebound
                rts
; ---------------------------------------------------------------------------
HPZKnux_ShipContactBounds:
                dc.w    -$20,   $40,  -$20,   $40
; ---------------------------------------------------------------------------

HPZKnux_SignalApproachAndJumpToShip:
                move.b  #$32,routine(a0)
                bset    #1,(_unkFAB8).w
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$9A,mapping_frame(a0)
                move.w  #$300,x_vel(a0)
                move.w  #-$500,y_vel(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                lea     SKSceneAnim_KnuxJumpAndFastTravel(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_ReboundAndCheckHeight:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   HPZKnux_ReboundUpdateReturn
                cmpi.w  #$3AB,y_pos(a0)
                bhs.s   HPZKnux_ClampReboundAndResumeRun

HPZKnux_ReboundUpdateReturn:
                rts
; ---------------------------------------------------------------------------
; unused
                dc.w    -$20,   $40,  -$20,   $40
; ---------------------------------------------------------------------------

HPZKnux_PauseShipAndLaunchRebound:
                bset    #6,status(a1)
                move.b  #$34,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$9A,mapping_frame(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$200,y_vel(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                lea     SKSceneAnim_KnuxJumpAndFastTravel(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_AccelerateTowardEmerald:
                jsr     (Animate_RawCheckResult).l
                move.w  x_vel(a0),d0
                addi.w  #$C,d0
                cmpi.w  #$300,d0
                bls.s   HPZKnux_MoveAndCheckWrappedEmeraldX
                move.w  #$300,d0

HPZKnux_MoveAndCheckWrappedEmeraldX:
                move.w  d0,x_vel(a0)
                jsr     (MoveSprite2).l
                movea.w (_unkFABA).w,a1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$30,d0
                blo.s   HPZKnux_JumpNearMasterEmerald
                rts
; ---------------------------------------------------------------------------

HPZKnux_ClampReboundAndResumeRun:
                move.w  #$3AB,y_pos(a0)
                move.b  #$36,routine(a0)
                bclr    #7,art_tile(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #7,mapping_frame(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                lea     SKKnucklesCutscene_SharedTravelBodyLoop(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_JumpAndCheckEmeraldContact:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                movea.w (_unkFABA).w,a1
                lea     HPZKnux_EmeraldGrabBounds(pc),a2
                jsr     (Check_InTheirRange).l
                bne.s   HPZKnux_SetGrabMapAndFollowEmerald
                rts
; ---------------------------------------------------------------------------
HPZKnux_EmeraldGrabBounds:
                dc.w    -$10,   $60,     0,   $10
; ---------------------------------------------------------------------------

HPZKnux_JumpNearMasterEmerald:
                move.b  #$38,routine(a0)
                move.w  #-$600,y_vel(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                lea     SKSceneAnim_KnuxJumpAndFastTravel(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

HPZKnux_CheckShipReleaseSignal:
                btst    #4,(_unkFAB8).w
                bne.s   HPZKnux_Begin60TickReleaseHold

HPZKnux_FollowEmeraldAtLeftOffset:
                movea.w (_unkFABA).w,a1
                move.w  x_pos(a1),d0
                subi.w  #$C,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                rts
; ---------------------------------------------------------------------------

HPZKnux_SetGrabMapAndFollowEmerald:
                move.b  #$3A,routine(a0)
                move.w  #2,$44(a0)
                move.l  #Map_HPZKnucklesGrab,mappings(a0)
                move.b  #0,mapping_frame(a0)
                bra.s   HPZKnux_FollowEmeraldAtLeftOffset
; ---------------------------------------------------------------------------

HPZKnux_TickHoldAndSelectParityFrame:
                subq.w  #1,$2E(a0)
                bmi.s   HPZKnux_ReleaseEmeraldAndFall
                moveq   #0,d0
                move.b  (V_int_run_count+3).w,d1
                btst    #0,d1
                beq.s   HPZKnux_StoreFrameAndPlayHoldSound
                moveq   #1,d0

; Play on VBlank phases 1 through 3 of each four-frame cycle
HPZKnux_StoreFrameAndPlayHoldSound:
                move.b  d0,mapping_frame(a0)
                andi.b  #3,d1
                beq.s   HPZKnux_FollowEmeraldAfterFrame
                moveq   #signextendB(sfx_GravityMachine),d0
                jsr     (Play_SFX).l

HPZKnux_FollowEmeraldAfterFrame:
                bra.s   HPZKnux_FollowEmeraldAtLeftOffset
; ---------------------------------------------------------------------------

HPZKnux_Begin60TickReleaseHold:
                move.b  #$3C,routine(a0)
                move.w  #60-1,$2E(a0)
                bra.s   HPZKnux_FollowEmeraldAtLeftOffset
; ---------------------------------------------------------------------------

HPZKnux_SelectParityFrameBeforeFall:
                moveq   #0,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   HPZKnux_FallLightAndCheckFloor
                moveq   #1,d0

HPZKnux_FallLightAndCheckFloor:
                move.b  d0,mapping_frame(a0)
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   HPZKnux_LandReleaseAndSignalGuide
                rts
; ---------------------------------------------------------------------------

HPZKnux_ReleaseEmeraldAndFall:
                move.b  #$3E,routine(a0)
                move.w  #-$100,x_vel(a0)
                move.w  #-$100,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

HPZKnux_AnimatePostReleaseLanding:
                jmp     (Animate_Raw2MultiDelay).l
; ---------------------------------------------------------------------------

HPZKnux_LandReleaseAndSignalGuide:
                add.w   d1,y_pos(a0)
                move.b  #$40,routine(a0)
                bset    #5,(_unkFAB8).w
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.l  #HPZKnux_FinishLandingAndWaitForGuide,$34(a0)
                lea     SKSceneAnim_HPZShipDepartureLanding(pc),a1
                jmp     (Set_Raw_Animation).l
; End of function HPZKnux_PlayPeriodicCollapseSound
