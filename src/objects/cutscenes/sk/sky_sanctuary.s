; Owner: objects/cutscenes/sk
; Responsibility: Sky Sanctuary Knuckles encounter, tired actor and scene button program
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_SSZ:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_SSZ_Index(pc,d0.w),d1
                jsr     CutsceneKnux_SSZ_Index(pc,d1.w)
                btst    #6,$38(a0)
                bne.s   SSZScene_SelectTiredGraphics
                move.l  #Map_Knuckles,mappings(a0)
                bsr.w   SKScene_LoadKnuxArtToSceneTiles
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZScene_SelectTiredGraphics:
                move.l  #Map_SSZKnucklesTired,mappings(a0)
                lea     DPLCPtr_SSZKnucklesTired(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
CutsceneKnux_SSZ_Index:
                dc.w    SSZScene_InitSlottedKnuxAndFlags-CutsceneKnux_SSZ_Index
                dc.w    SSZScene_AnimateUntilArrivalSignal-CutsceneKnux_SSZ_Index
                dc.w    SSZScene_FallAndSeedGroundWait-CutsceneKnux_SSZ_Index
                dc.w    SSZScene_TickDelayAndSetTiredLoop-CutsceneKnux_SSZ_Index
                dc.w    SSZScene_AnimateTiredUntilEggDone-CutsceneKnux_SSZ_Index
                dc.w    SSZScene_WaitThenRestoreNormalArt-CutsceneKnux_SSZ_Index
                dc.w    SSZScene_WaitThenBeginFirstJump-CutsceneKnux_SSZ_Index
                dc.w    SSZScene_AnimateAndLandFirstJump-CutsceneKnux_SSZ_Index
                dc.w    SSZScene_RunRightToX2A8ThenJump-CutsceneKnux_SSZ_Index
                dc.w    SSZScene_LandAndOpenBridgeEvent-CutsceneKnux_SSZ_Index
                dc.w    SSZScene_AnimateAndCheckCameraExit-CutsceneKnux_SSZ_Index
; ---------------------------------------------------------------------------

SSZScene_InitSlottedKnuxAndFlags:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                clr.b   (_unkFAB8).w
                move.w  #$80,priority(a0)
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

SSZScene_SavePaletteAndLoadScene:
                move.l  (a1)+,(a2)+
                dbf     d6,SSZScene_SavePaletteAndLoadScene
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

SSZScene_AnimateUntilArrivalSignal:
                lea     SKSceneAnim_KnuxJumpAndFastTravel(pc),a1
                jsr     (Animate_RawNoSSTCheckResult).l
                btst    #0,(_unkFAB8).w
                beq.w   SKAIZScene_SharedSceneReturn
                move.b  #4,routine(a0)
                move.b  #$56,mapping_frame(a0)
                move.b  #$33,y_radius(a0)
                lea     (ArtKosM_SSZDeathEggSmall).l,a1
                move.w  #tiles_to_bytes(ArtTile_SSZDeathEggSmall),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

SSZScene_FallAndSeedGroundWait:
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.w   SKAIZScene_SharedSceneReturn
                add.w   d1,y_pos(a0)
                move.b  #6,routine(a0)
                move.w  #5,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   SSZScene_TrySmallEggAfterObserver
                move.l  #SKScene_SSZStartHalfCameraTracker,(a1)

SSZScene_TrySmallEggAfterObserver:
                lea     SKSszCutscene_SmallDeathEggRootSpawnList(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

SSZScene_TickDelayAndSetTiredLoop:
                moveq   #signextendB(sfx_DeathEggRiseQuiet),d0
                jsr     (Play_SFX_Continuous).l
                subq.w  #1,$2E(a0)
                bpl.w   SKAIZScene_SharedSceneReturn
                move.b  #8,routine(a0)
                bset    #0,render_flags(a0)
                bset    #6,$38(a0)
                clr.b   mapping_frame(a0)
                lea     SKSceneAnim_SSZTiredLeadIn(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZScene_AnimateTiredUntilEggDone:
                moveq   #signextendB(sfx_DeathEggRiseQuiet),d0
                jsr     (Play_SFX_Continuous).l
                btst    #1,(_unkFAB8).w
                bne.s   SSZScene_BeginTiredPoseWait
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SSZScene_BeginTiredPoseWait:
                move.b  #$A,routine(a0)
                clr.b   mapping_frame(a0)
                move.w  #5,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SSZScene_WaitThenRestoreNormalArt:
                subq.w  #1,$2E(a0)
                bpl.s   SSZScene_NormalArtWaitReturn
                move.b  #$C,routine(a0)
                bclr    #0,render_flags(a0)
                bclr    #6,$38(a0)
                move.b  #$56,mapping_frame(a0)
                move.w  #5,$2E(a0)

SSZScene_NormalArtWaitReturn:
                rts
; ---------------------------------------------------------------------------

SSZScene_WaitThenBeginFirstJump:
                subq.w  #1,$2E(a0)
                bpl.w   SKAIZScene_SharedSceneReturn
                move.b  #$E,routine(a0)
                move.b  #$13,y_radius(a0)
                move.w  #$200,x_vel(a0)
                move.w  #-$300,y_vel(a0)
                lea     SKSceneAnim_KnuxJumpAndFastTravel(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

; Test the updated vertical velocity after MoveSprite before probing the floor
SSZScene_AnimateAndLandFirstJump:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   SKAIZScene_SharedSceneReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.w   SKAIZScene_SharedSceneReturn
                add.w   d1,y_pos(a0)
                move.b  #$10,routine(a0)
                move.w  #$300,x_vel(a0)
                clr.w   y_vel(a0)
                bclr    #0,render_flags(a0)
                lea     SKSceneAnim_KnuxTravelLoopDelay4(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZScene_RunRightToX2A8ThenJump:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite2).l
                cmpi.w  #$2A8,x_pos(a0)
                blo.w   SKAIZScene_SharedSceneReturn
                move.b  #$12,routine(a0)
                move.b  #$1B,y_radius(a0)
                move.w  #$480,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                lea     SKSceneAnim_KnuxJumpAndFastTravel(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZScene_LandAndOpenBridgeEvent:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   SKAIZScene_SharedSceneReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.w   SKAIZScene_SharedSceneReturn
                add.w   d1,y_pos(a0)
                move.b  #$14,routine(a0)
                move.w  #$200,priority(a0)
                bclr    #0,render_flags(a0)
                bset    #6,$38(a0)
                move.b  #1,mapping_frame(a0)
                st      (Events_bg+$08).w
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l
                lea     SKSszHpzKnuckles_TiredBodyTimedLoop(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

SSZScene_AnimateAndCheckCameraExit:
                bsr.w   SSZKnucklesReactToCrouchingP1OnRight
                jsr     (Animate_RawMultiDelay).l
                move.w  (Camera_X_pos).w,d0
                subi.w  #$80,d0
                cmp.w   x_pos(a0),d0
                bgt.s   SSZScene_SaveCheckpointAndPrepPalette
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmpi.w  #$200,d0
                bls.w   SKAIZScene_SharedSceneReturn

SSZScene_SaveCheckpointAndPrepPalette:
                move.b  #1,(Last_star_post_hit).w
                move.w  #$140,(Saved_X_pos).w
                move.w  #$C6C,(Saved_Y_pos).w
                jsr     (Save_Level_Data).l
                lea     (Target_palette_line_2).w,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

SSZScene_RestorePaletteAndReleaseSlot:
                move.l  (a1)+,(a2)+
                dbf     d6,SSZScene_RestorePaletteAndReleaseSlot
                lea     (PLC_Monitors).l,a1
                jsr     (Load_PLC_Raw).l
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

Obj_SSZCutsceneButton:
                lea     ObjDat_SSZCutsceneButton(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SSZScene_DrawOrCullSceneButton,(a0)

SSZScene_DrawOrCullSceneButton:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SSZScene_InitSmallDeathEggAndPalette:
                lea     SKSszCutscene_SmallDeathEggAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SSZScene_DrawSmallEggAndTickDelay,(a0)
                move.w  #$200,x_pos(a0)
                move.w  #$C68,d0
                move.w  d0,y_pos(a0)
                move.w  d0,y_vel(a0)
                move.w  #-$40,$40(a0)
                move.w  #$100,$2E(a0)
                move.l  (V_int_run_count).w,(RNG_seed).w
                lea     SKSceneData_SSZDeathEggCompositeChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     (Normal_palette_line_4).w,a1
                lea     (Target_palette_line_4).w,a2
                moveq   #bytesToLcnt($20),d6

SSZScene_SaveLine4AndPrepSparseCopy:
                move.l  (a1)+,(a2)+
                dbf     d6,SSZScene_SaveLine4AndPrepSparseCopy
                lea     Pal_KnuxSSZEnd(pc),a1
                lea     (Normal_palette_line_4).w,a2
                moveq   #bytesToWcnt($20),d0

SSZScene_CopyNonzeroEggColors:
                move.w  (a1)+,d1
                beq.s   SSZScene_AdvanceSparsePaletteCopy
                move.w  d1,(a2)

SSZScene_AdvanceSparsePaletteCopy:
                addq.w  #2,a2
                dbf     d0,SSZScene_CopyNonzeroEggColors

SSZScene_DrawSmallEggAndTickDelay:
                jsr     (MoveSprite_SSZBGAdjust).l
                jsr     (Draw_Sprite).l
                subq.w  #1,$2E(a0)
                bpl.s   SSZScene_SmallEggDelayReturn
                move.l  #SSZScene_EmitAndMoveEggUntilSignal,(a0)

SSZScene_SmallEggDelayReturn:
                rts
; ---------------------------------------------------------------------------

SSZScene_EmitAndMoveEggUntilSignal:
                bsr.w   SSZSmallDeathEgg_TryParticleEvery32
                jsr     (MoveSprite_SSZBGAdjust).l
                jsr     (Draw_Sprite).l
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$38,d0
                cmp.w   y_pos(a0),d0
                bls.w   SKAIZScene_SharedSceneReturn
                bset    #5,$38(a0)
                bset    #1,(_unkFAB8).w
                lea     (Target_palette_line_4).w,a1
                lea     (Normal_palette_line_4).w,a2
                moveq   #bytesToLcnt($20),d6

SSZScene_RestoreEggPaletteAndDelete:
                move.l  (a1)+,(a2)+
                dbf     d6,SSZScene_RestoreEggPaletteAndDelete
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SSZScene_DispatchMoveAndDrawCloud:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SSZScene_CloudRoutineOffsets(pc,d0.w),d1
                jsr     SSZScene_CloudRoutineOffsets(pc,d1.w)
                jsr     (MoveSprite_SSZBGAdjust).l
                lea     DPLCPtr_SSZDeathEggCloud(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
SSZScene_CloudRoutineOffsets:
                dc.w    SSZScene_InitSlottedCloudAndTick-SSZScene_CloudRoutineOffsets
                dc.w    SSZScene_AnimateCloudUntilUnderflow-SSZScene_CloudRoutineOffsets
                dc.w    SSZScene_TickFinalCloudDelay-SSZScene_CloudRoutineOffsets
; ---------------------------------------------------------------------------

SSZScene_InitSlottedCloudAndTick:
                lea     SKSceneData_SSZDeathEggCloudSlotAttrs(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.l  #SKSceneAnim_SSZDeathEggCloud,$30(a0)
                move.w  y_pos(a0),y_vel(a0)
                move.w  #$190,$2E(a0)

SSZScene_AnimateCloudUntilUnderflow:
                jsr     (Animate_RawMultiDelay).l
                subq.w  #1,$2E(a0)
                bpl.w   SKAIZScene_SharedSceneReturn
                move.b  #4,routine(a0)
                move.w  #$10,$40(a0)
                move.w  #$180,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SSZScene_TickFinalCloudDelay:
                subq.w  #1,$2E(a0)
                bmi.s   SSZScene_ReleaseCloudSlotAndDelete
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SSZScene_ReleaseCloudSlotAndDelete:
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SSZScene_InitBackgroundSpriteMask:
                lea     SKSszSmallDeathEgg_SpriteMaskAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SSZScene_ApplyMaskAndCheckRelease,(a0)
                move.w  y_pos(a0),y_vel(a0)

SSZScene_ApplyMaskAndCheckRelease:
                st      (Spritemask_flag).w
                btst    #2,(_unkFAB8).w
                bne.s   SSZScene_DeleteReleasedMask
                jsr     (MoveSprite_SSZBGAdjust).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZScene_DeleteReleasedMask:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SSZScene_InitTimedChildEffect:
                lea     SKSceneData_SSZDeathEggPiecePartialAttrs(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SSZScene_FollowParentAndAnimateEffect,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

SSZScene_FollowParentAndAnimateEffect:
                jsr     (Refresh_ChildPosition).l
                lea     SKSceneAnim_SSZDeathEggBackgroundPiece(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZScene_InitSmallEggParticle:
                lea     SKSceneData_SSZDeathEggParticlePartAttrs(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #SSZScene_SelectParticleParityFrame,(a0)
                jsr     (Random_Number).l
                move.w  #$100,d1
                andi.w  #$3F,d0
                subi.w  #$20,d0
                bpl.s   SSZScene_StoreParticleSpeedAndOffsets
                neg.w   d1

; The particle's Y offset comes from the high word of the random value
SSZScene_StoreParticleSpeedAndOffsets:
                move.w  d1,x_vel(a0)
                add.w   d0,x_pos(a0)
                swap    d0
                andi.w  #$1F,d0
                add.w   d0,y_pos(a0)
                move.w  #$100,y_vel(a0)

SSZScene_SelectParticleParityFrame:
                move.b  #4,mapping_frame(a0)
                btst    #0,(V_int_run_count+3).w
                beq.s   SSZScene_AccelerateMoveAndCullParticle
                move.b  #5,mapping_frame(a0)

SSZScene_AccelerateMoveAndCullParticle:
                addi.w  #-$10,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteXY).l
