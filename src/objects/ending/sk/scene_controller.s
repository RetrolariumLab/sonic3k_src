; Owner: objects/ending/sk
; Responsibility: Ending scene coordination, player character state, completion progression and retained legacy credits return entry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

S3Credits:
                rts
; ---------------------------------------------------------------------------

EndScene_DispatchProxyAndSyncPlayer:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  EndingScene_StateOffsets(pc,d0.w),d1
                jsr     EndingScene_StateOffsets(pc,d1.w)
                cmpi.w  #2,(Player_mode).w
                bne.s   EndingScene_MirrorProxyPositionAndDraw
                move.b  #$7F,(Palette_timer).w

EndingScene_MirrorProxyPositionAndDraw:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
EndingScene_StateOffsets:
                dc.w    EndScene_InitProxyAndPlayerOutcome-EndingScene_StateOffsets
                dc.w    EndScene_TryOutcomeAccentDuringRise-EndingScene_StateOffsets
                dc.w    EndScene_ScrollUpAndSignalTornado-EndingScene_StateOffsets
                dc.w    EndingScene_WaitForTornadoToReachProxy-EndingScene_StateOffsets
                dc.w    EndScene_TickCarrierDepartureDelay-EndingScene_StateOffsets
                dc.w    EndScene_BobUntilCarrierReady-EndingScene_StateOffsets
                dc.w    EndScene_WaitThenStartIslandLift-EndingScene_StateOffsets
                dc.w    EndScene_ScrollDownRightDuringLift-EndingScene_StateOffsets
                dc.w    EndScene_ScrollRightDuringLiftHold-EndingScene_StateOffsets
                dc.w    EndScene_MoveLeftBeforeFGHandoff-EndingScene_StateOffsets
                dc.w    EndScene_WaitThenInitReturnPlane-EndingScene_StateOffsets
                dc.w    EndingScene_WaitBeforeReturnPlaneFlight-EndingScene_StateOffsets
                dc.w    EndScene_FlyReturnPlaneRight-EndingScene_StateOffsets
                dc.w    EndingScene_FlySmallPlaneLeftToCenter-EndingScene_StateOffsets
                dc.w    EndScene_WaitThenSpawnLiftEffects-EndingScene_StateOffsets
                dc.w    EndingScene_FlyLeftAndSwitchToFinalWait-EndingScene_StateOffsets
; ---------------------------------------------------------------------------

EndScene_InitProxyAndPlayerOutcome:
                lea     EndingSceneProxy_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.b  #2,routine(a0)
                bsr.w   Ending_InitEmeraldOutcome
                st      (Scroll_lock).w
                clr.b   (SceneSyncFlagsOrMHZState).w
                lea     (Player_1).w,a1
                bclr    #2,render_flags(a1)
                bset    #7,art_tile(a1)
                move.b  #$81,object_control(a1)
                move.b  #$F,anim(a1)
                clr.b   status(a1)
                move.w  #$800,ground_vel(a1)
                clr.l   (Player_2).w
                cmpi.w  #2,(Player_mode).w
                move.w  #$7FFF,(Super_frame_count).w
                move.b  #1,(Update_HUD_timer).w
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                bmi.w   EndingScene_PlaceProxyTornadoAndEmerald
                bne.s   EndScene_SelectSuperTailsOrHyperSonic
                cmpi.w  #2,(Player_mode).w
                bhs.w   EndingScene_PlaceProxyTornadoAndEmerald
                bsr.w   EndingPrepareSuperSonicVisualState
                jsr     (AllocateObject).l
                bne.s   EndScene_ContinueAfterSuperRevert
                move.l  #Obj_Ending_RevertSuperSonic,(a1)

EndScene_ContinueAfterSuperRevert:
                bra.w   EndingScene_SetBrightSonicPaletteEntries
; ---------------------------------------------------------------------------

EndScene_SelectSuperTailsOrHyperSonic:
                clr.b   (Player_1+anim).w
                cmpi.w  #2,(Player_mode).w
                bne.s   EndingScene_PrepareHyperSonicVisuals
                bsr.w   EndingPrepareSuperTailsPaletteState
                bra.w   EndingScene_PlaceProxyTornadoAndEmerald
; ---------------------------------------------------------------------------

EndingScene_PrepareHyperSonicVisuals:
                bsr.w   EndingAndDDZPrepareHyperSonicVisualState

EndingScene_SetBrightSonicPaletteEntries:
                move.l  #$EEE0EEE,d0
                move.l  d0,(Normal_palette+$4).w
                move.w  d0,(Normal_palette+$8).w

EndingScene_PlaceProxyTornadoAndEmerald:
                move.w  #$100,x_pos(a0)
                move.w  #$E0,y_pos(a0)
                lea     (Dynamic_object_RAM+(object_size*5)).w,a1
                move.w  a1,$44(a0)
                move.l  #EndingTornado_DispatchStateAndSubSprites,(a1)
                st      $2C(a1)
                bset    #2,$38(a1)
                move.w  a0,$46(a1)
                lea     (Dynamic_object_RAM+(object_size*45)).w,a1
                move.l  #EndingMasterEmerald_DispatchStateAndDraw,(a1)
                move.w  a0,$46(a1)
                move.w  #$11E,x_pos(a1)
                move.w  #$CF,y_pos(a1)
                lea     (Pal_SSZ2+$20).l,a1
                lea     (Target_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d6

EndScene_CopyPaletteAndQueueSceneArt:
                move.l  (a1)+,(a2)+
                dbf     d6,EndScene_CopyPaletteAndQueueSceneArt
                lea     (ArtKosM_EndingMasterEmerald).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_MasterEmerald),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SonicPlane).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Plane),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SonicPlaneEnding).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_PlaneExtra),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

EndScene_TryOutcomeAccentDuringRise:
                cmpi.w  #$EEE,(Normal_palette+$2).w
                bne.s   EndScene_ScrollUpAndTryCloudField
                bset    #7,$38(a0)
                bne.s   EndScene_ScrollUpAndTryCloudField
                move.b  #1,(EmeraldPresentationEnableAndPaletteRoute).w
                jsr     (AllocateObject).l
                bne.s   EndScene_ScrollUpAndTryCloudField
                move.l  #EndEmerald_CycleAllSuperAccent,(a1)

EndScene_ScrollUpAndTryCloudField:
                move.l  (SceneAuxiliaryYOrVerticalMotion).w,d0
                addi.l  #$8000,d0
                move.l  d0,(SceneAuxiliaryYOrVerticalMotion).w
                cmpi.l  #$800000,d0
                blo.s   EndingScene_ReturnFromInitialRise
                move.b  #4,routine(a0)
                jsr     (AllocateObject).l
                bne.s   EndScene_EnableCloudsAndDiagonalMove
                move.l  #EndCloud_InitFieldPaletteAndArt,(a1)

EndScene_EnableCloudsAndDiagonalMove:
                move.b  #$1F,(EndingCloudSpawnFrameMask).w
                move.w  #-$100,(EndingCloudHorizontalBaseVelocity).w
                move.w  #-$100,(EndingCloudVerticalBaseVelocity).w

EndingScene_ReturnFromInitialRise:
                rts
; ---------------------------------------------------------------------------

EndScene_ScrollUpAndSignalTornado:
                move.l  (SceneAuxiliaryYOrVerticalMotion).w,d0
                addi.l  #$8000,d0
                move.l  d0,(SceneAuxiliaryYOrVerticalMotion).w
                cmpi.l  #$1000000,d0
                blo.s   EndScene_ApproachSignalReturn
                move.b  #6,routine(a0)
                bset    #3,$38(a0)

EndScene_ApproachSignalReturn:
                rts
; ---------------------------------------------------------------------------

EndingScene_WaitForTornadoToReachProxy:
                movea.w $44(a0),a1
                move.w  x_pos(a1),d0
                addi.w  #$20,d0
                cmp.w   x_pos(a0),d0
                bgt.s   EndingScene_AlignProxyAndSignalBoarding
                move.l  (SceneAuxiliaryYOrVerticalMotion).w,d0
                addi.l  #$8000,d0
                move.l  d0,(SceneAuxiliaryYOrVerticalMotion).w
                rts
; ---------------------------------------------------------------------------

EndingScene_AlignProxyAndSignalBoarding:
                move.b  #8,routine(a0)
                bset    #0,(SceneSyncFlagsOrMHZState).w
                move.w  #$20,$2E(a0)
                moveq   #-$20,d0
                move.b  d0,$42(a1)
                move.w  x_pos(a1),d1
                neg.w   d0
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                moveq   #$2B,d0
                cmpi.w  #2,(Player_mode).w
                bne.s   EndScene_AlignProxyAndRestorePlayer
                subq.b  #4,d0
                bclr    #2,(Tails_tails+render_flags).w

EndScene_AlignProxyAndRestorePlayer:
                move.b  d0,$43(a1)
                move.w  y_pos(a1),d1
                neg.w   d0
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                move.w  d1,$3A(a0)
                lea     (Player_1).w,a1
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                bmi.s   EndScene_SetBoardedPoseAndLoadArt
                beq.s   EndScene_SetBoardedPoseAndLoadArt
                move.b  #2,(Super_palette_status).w
                move.w  #$1E,(Palette_frame).w
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #0,(Super_Tails_flag).w
                move.l  #Map_Sonic,mappings(a1)
                cmpi.w  #2,(Player_mode).w
                bne.s   EndScene_SetBoardedPoseAndLoadArt
                move.l  #Map_Tails,mappings(a1)

EndScene_SetBoardedPoseAndLoadArt:
                move.b  #5,anim(a1)
                move.b  #$83,$2E(a1)
                bsr.w   Ending_SetP1PoseAndLoadArt

EndScene_TickCarrierDepartureDelay:
                subq.w  #1,$2E(a0)
                bne.s   EndScene_MoveBoardedProxyAndCheckWait
                bset    #1,(SceneSyncFlagsOrMHZState).w

EndScene_MoveBoardedProxyAndCheckWait:
                addq.w  #2,x_pos(a0)
                cmpi.w  #$160,x_pos(a0)
                blo.s   EndingScene_BobAfterBoardedMovement
                move.b  #$A,routine(a0)
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                bpl.s   EndingScene_BobAfterBoardedMovement
                move.b  #$C,routine(a0)
                move.w  #(5*60)-1,$2E(a0)

EndingScene_BobAfterBoardedMovement:
                bra.w   EndingBobYFromSavedBaseAndByteSinePhase
; ---------------------------------------------------------------------------

EndScene_BobUntilCarrierReady:
                tst.w   (SceneControllerObjectAddress).w
                bne.s   EndingScene_BeginBoardedHoldDelay
                bra.w   EndingBobYFromSavedBaseAndByteSinePhase
; ---------------------------------------------------------------------------

EndingScene_BeginBoardedHoldDelay:
                move.b  #$C,routine(a0)
                move.w  #(5*60)-1,$2E(a0)

EndScene_WaitThenStartIslandLift:
                subq.w  #1,$2E(a0)
                bpl.s   EndingScene_BobDuringIslandLiftStartWait
                move.b  #$E,routine(a0)
                move.w  #-$100,(EndingCloudVerticalBaseVelocity).w
                clr.b   (EndingCloudSpawnFrameMask).w
                move.w  #$BF,$2E(a0)
                st      (Events_fg_5).w
                lea     EndScene_LiftInitialDetailPositions(pc),a2
                moveq   #$42,d1
                moveq   #2-1,d2
                bsr.w   Create_Continue_Sprite
                lea     (ArtKosM_IslandLiftGfx).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_IslandLiftGfx),d2
                jsr     (Queue_Kos_Module).l

EndingScene_BobDuringIslandLiftStartWait:
                bra.w   EndingBobYFromSavedBaseAndByteSinePhase
; ---------------------------------------------------------------------------
EndScene_LiftInitialDetailPositions:
                dc.w    $69C,  $384
                dc.w    $6DC,  $384
; ---------------------------------------------------------------------------

EndScene_ScrollDownRightDuringLift:
                addq.w  #2,(SceneAuxiliaryXOrCompetitionTime).w
                addq.w  #1,(SceneAuxiliaryYOrVerticalMotion).w
                subq.w  #1,$2E(a0)
                bpl.s   EndScene_BobDuringDiagonalScroll
                move.b  #$10,routine(a0)
                move.w  #(5*60)-1,$2E(a0)

EndScene_BobDuringDiagonalScroll:
                bra.w   EndingBobYFromSavedBaseAndByteSinePhase
; ---------------------------------------------------------------------------

EndScene_ScrollRightDuringLiftHold:
                addq.w  #2,(SceneAuxiliaryXOrCompetitionTime).w
                subq.w  #1,$2E(a0)
                bpl.s   EndScene_BobDuringHorizontalScroll
                move.b  #$12,routine(a0)
                move.w  #$8F,$2E(a0)

EndScene_BobDuringHorizontalScroll:
                bra.w   EndingBobYFromSavedBaseAndByteSinePhase
; ---------------------------------------------------------------------------

EndScene_MoveLeftBeforeFGHandoff:
                cmpi.w  #$60,x_pos(a0)
                bls.s   EndScene_ScrollAndSignalFGHandoff
                subq.w  #2,x_pos(a0)

EndScene_ScrollAndSignalFGHandoff:
                addq.w  #2,(SceneAuxiliaryXOrCompetitionTime).w
                bsr.w   EndingBobYFromSavedBaseAndByteSinePhase
                subq.w  #1,$2E(a0)
                bpl.s   EndScene_FGHandoffWaitReturn
                move.b  #$14,routine(a0)
                bset    #7,status(a0)
                st      (Events_fg_4).w
                move.w  #$8F,$2E(a0)
                clr.b   (Player_1+anim).w

EndScene_FGHandoffWaitReturn:
                rts
; ---------------------------------------------------------------------------

EndScene_WaitThenInitReturnPlane:
                addq.w  #2,(SceneAuxiliaryXOrCompetitionTime).w
                subq.w  #1,$2E(a0)
                bpl.w   EndingScene_SharedReturn
                move.b  #$16,routine(a0)
                move.b  #1,mapping_frame(a0)
                move.w  #$40,x_pos(a0)
                move.w  #$110,y_pos(a0)
                move.w  #(2*60)-1,$2E(a0)
                lea     (Player_1).w,a1
                clr.b   mapping_frame(a1)
                move.w  #$100,x_vel(a0)
                bsr.w   EndingInitializeGentleVerticalSwing
                lea     EndData_PlanePoseDetailChildRecord(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     EndingPlaneBlinkDetail_ChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     EndingPlanePoseOffsetDetail_ChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                bmi.w   EndingScene_SharedReturn
                lea     EndingPlaneWideDetail_ChildRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

EndingScene_WaitBeforeReturnPlaneFlight:
                subq.w  #1,$2E(a0)
                bpl.s   EndingScene_ReturnFromReturnPlaneDelay
                move.b  #$18,routine(a0)

EndingScene_ReturnFromReturnPlaneDelay:
                rts
; ---------------------------------------------------------------------------

EndScene_FlyReturnPlaneRight:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                cmpi.w  #$140,x_pos(a0)
                blo.s   EndScene_SwitchToSmallPlane
                lea     EndingReturnPlane_RawFrameDelayScript(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l

EndScene_SwitchToSmallPlane:
                cmpi.w  #$220,x_pos(a0)
                bls.w   EndingScene_SharedReturn
                move.b  #$1A,routine(a0)
                move.w  #make_art_tile(ArtTile_Ending_PlaneExtra,1,0),art_tile(a0)
                bset    #0,render_flags(a0)
                bclr    #7,art_tile(a0)
                bset    #4,$38(a0)
                subq.w  #8,y_pos(a0)
                move.w  #-$80,x_vel(a0)
                clr.w   y_vel(a0)
                move.b  #5,mapping_frame(a0)
                cmpi.w  #2,(Player_mode).w
                bne.s   EndScene_LoadSmallPlanePalAndChildren
                move.b  #6,mapping_frame(a0)

EndScene_LoadSmallPlanePalAndChildren:
                lea     Pal_EndingSmallPlane(pc),a1
                jsr     (PalLoad_Line1).l
                lea     EndData_SmallPlaneCyclingChild(pc),a2
                jsr     (CreateChild1_Normal).l
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                bmi.w   EndingScene_SharedReturn
                lea     EndData_SmallPlaneOutcomeChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

EndingScene_FlySmallPlaneLeftToCenter:
                jsr     (MoveSprite2).l
                cmpi.w  #$120,x_pos(a0)
                bhs.s   EndScene_SmallPlaneApproachReturn
                move.b  #$1C,routine(a0)
                move.w  #60-1,$2E(a0)
                bset    #5,$38(a0)
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                bmi.s   EndScene_SmallPlaneApproachReturn
                jsr     (AllocateObject).l
                bne.s   EndScene_SmallPlaneApproachReturn
                move.l  #EndLine3Flash_InitRaise,(a1)

EndScene_SmallPlaneApproachReturn:
                rts
; ---------------------------------------------------------------------------

EndScene_WaitThenSpawnLiftEffects:
                subq.w  #1,$2E(a0)
                bpl.s   EndScene_LiftEffectsSetupReturn
                move.b  #$1E,routine(a0)
                st      (Events_fg_4).w
                cmpi.w  #3,(Player_mode).w
                beq.s   EndScene_LiftEffectsSetupReturn
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                bmi.s   EndScene_LiftEffectsSetupReturn
                lea     EndScene_LiftEffectProjectionPoints(pc),a2
                moveq   #$41,d1
                moveq   #6-1,d2
                bsr.w   Create_Continue_Sprite
                lea     EndScene_LiftDetail43Positions(pc),a2
                moveq   #$43,d1
                moveq   #2-1,d2
                bsr.w   Create_Continue_Sprite
                lea     EndScene_LiftDetail44Positions(pc),a2
                moveq   #$44,d1
                moveq   #4-1,d2
                bsr.w   Create_Continue_Sprite
                lea     EndScene_LiftDetail45Positions(pc),a2
                moveq   #$45,d1
                moveq   #2-1,d2
                bsr.w   Create_Continue_Sprite
                lea     EndScene_LiftDetail46Positions(pc),a2
                moveq   #$46,d1
                moveq   #2-1,d2
                bsr.w   Create_Continue_Sprite
                lea     EndScene_LiftDetail47Positions(pc),a2
                moveq   #$47,d1
                moveq   #2-1,d2
                bsr.w   Create_Continue_Sprite

EndScene_LiftEffectsSetupReturn:
                rts
; ---------------------------------------------------------------------------
EndScene_LiftEffectProjectionPoints:
                dc.w    $2B0,   $D4
                dc.w    $2D0,   $D4
                dc.w    $2F0,   $D4
                dc.w    $310,   $D4
                dc.w    $330,   $D4
                dc.w    $350,   $D4
EndScene_LiftDetail43Positions:
                dc.w    $12C,  $11C
                dc.w    $F4,  $11C
EndScene_LiftDetail44Positions:
                dc.w    $E8,  $12C
                dc.w    $158,  $12C
                dc.w    $B8,  $12C
                dc.w    $188,  $12C
EndScene_LiftDetail45Positions:
                dc.w    $2FC,   $DC
                dc.w    $32C,   $DC
EndScene_LiftDetail46Positions:
                dc.w    $2C4,   $D8
                dc.w    $2EC,   $D8
EndScene_LiftDetail47Positions:
                dc.w    $304,   $D0
                dc.w    $344,   $D0
; ---------------------------------------------------------------------------

EndingScene_FlyLeftAndSwitchToFinalWait:
                jsr     (MoveSprite2).l
                cmpi.w  #$60,x_pos(a0)
                bhs.s   EndingScene_ReturnFromFinalLeftFlight
                move.l  #EndScene_WaitForFinalCameraOrFail,(a0)
                bset    #1,$38(a0)

EndingScene_ReturnFromFinalLeftFlight:
                rts
; ---------------------------------------------------------------------------

EndScene_WaitForFinalCameraOrFail:
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                bmi.s   EndScene_FadeMusicClearFlagsAndDelete
                cmpi.w  #$78,(Camera_Y_pos_copy).w
                blo.w   EndingScene_SharedReturn

EndScene_FadeMusicClearFlagsAndDelete:
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                clr.b   (EmeraldPresentationEnableAndPaletteRoute).w
                clr.b   (SceneSyncFlagsOrMHZState).w
                st      (Events_fg_4).w
                jmp     (Delete_Current_Sprite).l
