; Owner: objects/ending/sk
; Responsibility: Ending player poses, rescued animals, plane sequence and final camera or palette transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Ending:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  EndingCreditsPlayerScene_StateOffsets(pc,d0.w),d1
                jsr     EndingCreditsPlayerScene_StateOffsets(pc,d1.w)
                subq.w  #2,(_unkEE98).w
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                rts
; ---------------------------------------------------------------------------
EndingCreditsPlayerScene_StateOffsets:
                dc.w    EndingCreditsPlayerScene_Initialize-EndingCreditsPlayerScene_StateOffsets
                dc.w    EndPlane_BobUntilCreditsSignal-EndingCreditsPlayerScene_StateOffsets
                dc.w    EndPlane_WaitThenLaunchJump-EndingCreditsPlayerScene_StateOffsets
                dc.w    EndPlane_JumpAndLoadLandingPose-EndingCreditsPlayerScene_StateOffsets
                dc.w    EndPlane_WaitThenShowFinalPose-EndingCreditsPlayerScene_StateOffsets
                dc.w    EndPlane_WaitForTransformRelease-EndingCreditsPlayerScene_StateOffsets
                dc.w    EndPlane_MoveRightBeforeReturn-EndingCreditsPlayerScene_StateOffsets
                dc.w    EndPlane_WaitThenSetReturnPose-EndingCreditsPlayerScene_StateOffsets
                dc.w    EndPlane_MoveLeftAndTryResultSelector-EndingCreditsPlayerScene_StateOffsets
                dc.w    EndingCreditsPlayerScene_HoldFinalPose-EndingCreditsPlayerScene_StateOffsets
; ---------------------------------------------------------------------------

EndingCreditsPlayerScene_Initialize:
                move.b  #2,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #$C0,x_pos(a0)
                move.w  #$E0,y_pos(a0)
                jsr     (Swing_Setup1).l
                cmpi.b  #2,(_unkFA88).w
                beq.s   EndPlane_SetUpPlayerAndTailsTail
                moveq   #signextendB(mus_CreditsK),d0
                jsr     (Play_Music).l

EndPlane_SetUpPlayerAndTailsTail:
                lea     (Player_1).w,a1
                bset    #0,render_flags(a1)
                bset    #0,status(a1)
                bclr    #7,art_tile(a1)
                move.b  #$83,$2E(a1)
                move.b  #5,anim(a1)
                cmpi.w  #2,(Player_mode).w
                bne.s   EndPlane_SetPoseAndTryPlaneChild
                lea     (Tails_tails).w,a2
                move.l  #Obj_Tails_Tail,(a2)
                move.w  a1,$30(a2)

EndPlane_SetPoseAndTryPlaneChild:
                bsr.w   Ending_SetP1PoseAndLoadArt
                lea     EndingTornado_ChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   EndPlane_TryAnimalGroups
                bset    #2,$38(a1)

EndPlane_TryAnimalGroups:
                tst.b   (_unkFA88).w
                bmi.s   EndPlane_QueuePlaneAndAnimalArt
                lea     EndingSwayingAnimals_SimpleChildRecord(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     EndingJumpingAnimals_SimpleChildRecord(pc),a2
                jsr     (CreateChild6_Simple).l

EndPlane_QueuePlaneAndAnimalArt:
                lea     (ArtKosM_SonicPlane).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Plane),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SonicPlaneEnding).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_PlaneExtra),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_EndingAnimals).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Animals),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

EndPlane_BobUntilCreditsSignal:
                bclr    #2,(Tails_tails+render_flags).w
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                tst.b   (_unkFACC).w
                beq.w   EndingScene_SharedReturn
                move.b  #4,routine(a0)
                move.w  #$1F,$2E(a0)
                lea     (Player_1).w,a1
                move.b  #$58,mapping_frame(a1)
                clr.b   anim(a1)
                jmp     (Player_Load_PLC).l
; ---------------------------------------------------------------------------

EndPlane_WaitThenLaunchJump:
                subq.w  #1,$2E(a0)
                bpl.w   EndingScene_SharedReturn
                move.b  #6,routine(a0)
                bset    #2,$38(a0)
                move.w  #$300,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                lea     (Player_1).w,a1
                bclr    #0,render_flags(a1)
                bclr    #0,status(a1)
                move.b  #$81,$2E(a1)
                move.w  #$200,anim(a1)
                clr.l   (Tails_tails).w
                moveq   #0,d0
                cmpi.w  #2,(Player_mode).w
                beq.s   EndPlane_SavePoseOffsetAndQueueArt
                moveq   #4,d0
                tst.b   (_unkFA88).w
                bmi.s   EndPlane_SavePoseOffsetAndQueueArt
                moveq   #8,d0

EndPlane_SavePoseOffsetAndQueueArt:
                move.w  d0,(Camera_stored_max_X_pos).w
                movea.l EndingCreditsPlayerScene_PoseArtPointers(pc,d0.w),a1
                move.w  #tiles_to_bytes(ArtTile_Ending_SonicTailsEndPose),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------
EndingCreditsPlayerScene_PoseArtPointers:
                dc.l    ArtKosM_TailsEndPose
                dc.l    ArtKosM_SonicEndPose
                dc.l    ArtKosM_SuperSonicEndPose
; ---------------------------------------------------------------------------

EndPlane_JumpAndLoadLandingPose:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   EndingScene_SharedReturn
                cmpi.w  #$E0,y_pos(a0)
                blo.w   EndingScene_SharedReturn
                move.l  #Map_SonicTailsEndPoses,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_SonicTailsEndPose,2,0),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$80,height_pixels(a0)
                cmpi.w  #2,(Player_mode).w
                bne.s   EndPlane_SelectPosePalette
                move.b  #3,mapping_frame(a0)

EndPlane_SelectPosePalette:
                move.w  (Camera_stored_max_X_pos).w,d0
                movea.l EndPlane_PosePalettePointers(pc,d0.w),a1
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d0

EndPlane_CopyPaletteAndChooseTransform:
                move.l  (a1)+,(a2)+
                dbf     d0,EndPlane_CopyPaletteAndChooseTransform
                tst.b   (_unkFA88).w
                bmi.s   EndPlane_BeginNormalPoseHold
                bne.s   EndPlane_StartSuperTransform
                cmpi.w  #2,(Player_mode).w
                bhs.s   EndPlane_BeginNormalPoseHold

EndPlane_StartSuperTransform:
                move.b  #$A,routine(a0)
                move.b  #1,(Update_HUD_timer).w
                clr.w   (Palette_frame).w
                jmp     (Ending_Give_SuperSonic).l
; ---------------------------------------------------------------------------
EndPlane_PosePalettePointers:
                dc.l    Pal_TailsEndPose
                dc.l    Pal_SonicEndPose
                dc.l    Pal_SuperSonicEndPose
; ---------------------------------------------------------------------------

EndPlane_BeginNormalPoseHold:
                move.b  #8,routine(a0)
                move.w  #5,$2E(a0)
                cmpi.w  #2,(Player_mode).w
                bne.s   EndPlane_HidePlayerAndDrawPose
                bset    #0,render_flags(a0)

EndPlane_HidePlayerAndDrawPose:
                lea     (Player_1).w,a1
                move.b  #$83,$2E(a1)
                clr.b   mapping_frame(a1)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndPlane_WaitThenShowFinalPose:
                subq.w  #1,$2E(a0)
                bpl.s   EndingCreditsPlayerScene_DrawNormalPose
                move.b  #$12,routine(a0)
                addq.b  #1,mapping_frame(a0)
                jsr     (AllocateObject).l
                bne.s   EndingCreditsPlayerScene_DrawNormalPose
                move.l  #EndingResults_SelectProgramAndStartDelay,(a1)

EndingCreditsPlayerScene_DrawNormalPose:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndPlane_WaitForTransformRelease:
                lea     (Player_1).w,a1
                tst.b   $2E(a1)
                bne.s   EndPlane_TransformWaitReturn
                cmpi.w  #2,(Player_mode).w
                beq.s   EndPlane_TrySuperTailsPaletteActor
                move.b  #$C,routine(a0)
                move.b  #$81,$2E(a1)
                clr.b   anim(a1)
                move.w  #$800,x_vel(a1)
                move.w  #$800,ground_vel(a1)

EndPlane_TransformWaitReturn:
                rts
; ---------------------------------------------------------------------------

EndPlane_TrySuperTailsPaletteActor:
                jsr     (AllocateObject).l
                bne.s   EndPlane_FlipAndHoldTailsPose
                move.l  #EndingSuperTailsPaletteActor_Initialize,(a1)

EndPlane_FlipAndHoldTailsPose:
                bset    #0,render_flags(a0)
                bra.w   EndPlane_BeginNormalPoseHold
; ---------------------------------------------------------------------------

EndPlane_MoveRightBeforeReturn:
                addq.w  #4,x_pos(a0)
                cmpi.w  #$200,x_pos(a0)
                blo.s   EndPlane_RightwardStepReturn
                move.b  #$E,routine(a0)
                move.w  #$1F,$2E(a0)

EndPlane_RightwardStepReturn:
                rts
; ---------------------------------------------------------------------------

EndPlane_WaitThenSetReturnPose:
                subq.w  #1,$2E(a0)
                bpl.s   EndPlane_ReturnPoseWaitReturn
                move.b  #$10,routine(a0)
                move.b  #2,mapping_frame(a0)
                bclr    #0,render_flags(a0)
                lea     (Player_1).w,a1
                move.b  #$83,$2E(a1)
                clr.b   mapping_frame(a1)
                jsr     (AllocateObject).l
                bne.s   EndPlane_ReturnPoseWaitReturn
                move.l  #EndPose_InitPaletteActorBySubtype,(a1)
                tst.b   (_unkFA88).w
                beq.s   EndPlane_ReturnPoseWaitReturn
                move.b  #2,subtype(a1)

EndPlane_ReturnPoseWaitReturn:
                rts
; ---------------------------------------------------------------------------

EndPlane_MoveLeftAndTryResultSelector:
                subq.w  #8,x_pos(a0)
                cmpi.w  #$160,x_pos(a0)
                bhi.s   EndPlane_DrawReturningPose
                move.b  #$12,routine(a0)
                move.w  #$160,x_pos(a0)
                jsr     (AllocateObject).l
                bne.s   EndPlane_DrawReturningPose
                move.l  #EndingResults_SelectProgramAndStartDelay,(a1)

EndPlane_DrawReturningPose:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndingCreditsPlayerScene_HoldFinalPose:
                cmpi.w  #2,(Player_mode).w
                bne.s   EndPlane_DrawUntilCleanup
                move.b  #$7F,(Palette_timer).w

EndPlane_DrawUntilCleanup:
                btst    #3,(_unkFAB8).w
                bne.s   EndingCreditsPlayerScene_DeleteOnCleanup
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndingCreditsPlayerScene_DeleteOnCleanup:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

EndingSwayingAnimal_Initialize:
                move.l  #EndPlane_AnimateSwayAnimalAndTickDelay,(a0)
                move.l  #Map_EndingAnimals,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Animals,0,0),art_tile(a0)
                move.w  #$380,priority(a0)
                move.b  #2,mapping_frame(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     EndingSwayingAnimal_InitialPositions(pc,d0.w),a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                lsl.w   #2,d0
                move.w  d0,$2E(a0)
                move.w  x_pos(a0),$3A(a0)
                bra.w   EndingInitializeGentleVerticalSwing
; ---------------------------------------------------------------------------
EndingSwayingAnimal_InitialPositions:
                dc.w    $170,   $B0
                dc.w    $150,   $C0
                dc.w    $190,   $D0
                dc.w    $140,   $E0
                dc.w    $168,   $F0
; ---------------------------------------------------------------------------

EndPlane_AnimateSwayAnimalAndTickDelay:
                btst    #3,(_unkFAB8).w
                bne.w   EndingChild_DeleteCurrentActor
                lea     EndingSwayingAnimal_RawAnimation(pc),a1
                jsr     (Animate_RawNoSST).l
                subq.w  #1,$2E(a0)
                bpl.s   EndPlane_DrawWaitingSwayAnimal
                move.l  #EndPlane_SwayAnimalMoveLeftAndReverse,(a0)
                move.w  #-$40,x_vel(a0)

EndPlane_DrawWaitingSwayAnimal:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndPlane_SwayAnimalMoveLeftAndReverse:
                btst    #3,(_unkFAB8).w
                bne.w   EndingChild_DeleteCurrentActor
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                lea     EndingSwayingAnimal_RawAnimation(pc),a1
                jsr     (Animate_RawNoSST).l
                move.w  $3A(a0),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$30,d0
                blt.s   EndingSwayingAnimal_DrawAfterLeftStep
                move.l  #EndPlane_SwayAnimalMoveRightPastOrigin,(a0)
                move.w  #$80,x_vel(a0)
                move.b  #2,mapping_frame(a0)

EndingSwayingAnimal_DrawAfterLeftStep:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndPlane_SwayAnimalMoveRightPastOrigin:
                btst    #3,(_unkFAB8).w
                bne.w   EndingChild_DeleteCurrentActor
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  $3A(a0),d0
                sub.w   x_pos(a0),d0
                bcc.s   EndingSwayingAnimal_DrawAfterRightStep
                move.l  #EndPlane_SwayAnimalMoveLeftAndReverse,(a0)
                move.w  #-$40,x_vel(a0)
                move.w  $3A(a0),x_pos(a0)

EndingSwayingAnimal_DrawAfterRightStep:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndingJumpingAnimal_InitializeDelay:
                move.l  #EndPlane_WaitAndRandomizeAnimalJump,(a0)
                move.l  #Map_EndingAnimals,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Animals,3,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                addi.w  #$60,d0
                move.w  d0,$2E(a0)
                rts
; ---------------------------------------------------------------------------

EndPlane_WaitAndRandomizeAnimalJump:
                btst    #3,(_unkFAB8).w
                bne.w   EndingChild_DeleteCurrentActor
                subq.w  #1,$2E(a0)
                bpl.s   EndPlane_AnimalLaunchWaitReturn
                move.l  #EndPlane_MoveAnimalAndSetNextJump,(a0)
                jsr     (Random_Number).l
                andi.w  #$3F,d0
                addi.w  #$180,d0
                move.w  d0,x_pos(a0)
                move.w  #$180,y_pos(a0)
                move.w  #-$300,x_vel(a0)
                move.w  #-$600,y_vel(a0)

EndPlane_AnimalLaunchWaitReturn:
                rts
; ---------------------------------------------------------------------------

EndPlane_MoveAnimalAndSetNextJump:
                btst    #3,(_unkFAB8).w
                bne.w   EndingChild_DeleteCurrentActor
                jsr     (MoveSprite).l
                clr.b   mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   EndingJumpingAnimal_DrawFlightFrame
                move.b  #1,mapping_frame(a0)
                cmpi.w  #$180,y_pos(a0)
                blo.s   EndingJumpingAnimal_DrawFlightFrame
                move.l  #EndPlane_WaitAndRandomizeAnimalJump,(a0)
                move.w  #60-1,$2E(a0)

EndingJumpingAnimal_DrawFlightFrame:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndPlane_DispatchKnuxPlaneAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  VInt_TableFC(pc,d0.w),d1
                jsr     VInt_TableFC(pc,d1.w)
                tst.b   (_unkFA88).w
                beq.s   EndPlane_MirrorPlayerAndDraw
                bmi.s   EndPlane_MirrorPlayerAndDraw
                lea     (SSZMasterEmeraldColorCycle_IndexedScript).l,a1
                lea     (Normal_palette_line_3+$1C).w,a2
                jsr     (Run_PalRotationScript2).l

EndPlane_MirrorPlayerAndDraw:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
VInt_TableFC:
                dc.w    EndingSSZKnucklesPlane_Initialize-VInt_TableFC
                dc.w    EndPlane_WaitWithWindBeforeRise-VInt_TableFC
                dc.w    EndingSSZKnucklesPlane_RiseUntilApex-VInt_TableFC
                dc.w    EndPlane_HoverBeforeDeparture-VInt_TableFC
                dc.w    EndPlane_FlyRightThenReturn-VInt_TableFC
                dc.w    EndPlane_FlyLeftAndGateAnim-VInt_TableFC
                dc.w    EndPlane_FlyRightAndSignalBackground-VInt_TableFC
                dc.w    EndPlane_WaitForBackgroundAlignment-VInt_TableFC
                dc.w    EndPlane_FlyOffscreenAndRevertSuper-VInt_TableFC
; ---------------------------------------------------------------------------

EndingSSZKnucklesPlane_Initialize:
                lea     EndingSSZKnucklesPlane_InitialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #(5*60)-1,$2E(a0)
                lea     (Player_1).w,a1
                move.b  #$83,$2E(a1)
                clr.b   mapping_frame(a1)
                st      (Scroll_lock).w
                clr.b   (_unkFAB8).w
                clr.b   (Level_started_flag).w
                clr.w   (Screen_shake_flag).w
                clr.l   (Timer).w
                move.w  (Camera_X_pos).w,d0
                addi.w  #$C0,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$110,d0
                move.w  d0,y_pos(a0)
                lea     EndingTornado_ChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #EndData_SSZPlaneMissingOutcomeAnim,$30(a0)
                bsr.w   Ending_InitEmeraldOutcome
                tst.b   (_unkFA88).w
                bmi.s   EndPlane_PrepareTargetPalette
                move.b  #4,mapping_frame(a0)
                move.l  #EndData_SSZPlaneEmeraldHoldAnim,$30(a0)
                lea     EndingAttachedMasterEmerald_ChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     (ArtKosM_EndingMasterEmerald).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_MasterEmerald),d2
                jsr     (Queue_Kos_Module).l
                tst.b   (_unkFA88).w
                beq.s   EndPlane_PrepareTargetPalette
                move.b  #1,(Update_HUD_timer).w
                move.b  #-1,(Super_palette_status).w
                move.b  #$F,(Palette_timer).w
                move.b  #1,(Super_Sonic_Knux_flag).w
                move.w  #$7FFF,(Super_frame_count).w

EndPlane_PrepareTargetPalette:
                lea     (Pal_SonicTails).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

EndPlane_CopyPaletteAndQueueSceneArt:
                move.l  (a1)+,(a2)+
                dbf     d6,EndPlane_CopyPaletteAndQueueSceneArt
                move.l  #$EE0088,(Target_palette_line_2+$A).w
                lea     (ArtKosM_KnuxEnding).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_SSZKnuckles),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SonicPlane).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Plane),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SonicPlaneEnding).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_PlaneExtra),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

EndPlane_WaitWithWindBeforeRise:
                moveq   #signextendB(sfx_WindQuiet),d0
                jsr     (Play_SFX_Continuous).l
                jsr     (Animate_RawMultiDelay).l
                subq.w  #1,$2E(a0)
                bpl.s   EndPlane_InitialDelayReturn
                move.b  #4,routine(a0)
                move.w  #-$6C0,y_vel(a0)
                jsr     (Restore_LevelMusic).l

EndPlane_InitialDelayReturn:
                rts
; ---------------------------------------------------------------------------

EndingSSZKnucklesPlane_RiseUntilApex:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.s   EndPlane_RiseUpdateReturn
                move.b  #6,routine(a0)
                jsr     (Swing_Setup1).l
                move.w  #(3*60)-1,$2E(a0)
                tst.b   (_unkFA88).w
                bmi.s   EndPlane_RiseUpdateReturn
                lea     (EndData_SSZPlaneEmeraldApexAnim).l,a1
                jsr     (Set_Raw_Animation).l

EndPlane_RiseUpdateReturn:
                rts
; ---------------------------------------------------------------------------

EndPlane_HoverBeforeDeparture:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Animate_RawMultiDelay).l
                subq.w  #1,$2E(a0)
                bpl.s   EndPlane_HoverUpdateReturn
                move.b  #8,routine(a0)
                move.w  #$400,x_vel(a0)

EndPlane_HoverUpdateReturn:
                rts
; ---------------------------------------------------------------------------

EndPlane_FlyRightThenReturn:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Animate_RawMultiDelay).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$200,d0
                cmp.w   x_pos(a0),d0
                bhi.w   EndingScene_SharedReturn
                move.b  #$A,routine(a0)
                move.l  #Map_SonicPlaneEnding,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_PlaneExtra,0,1),art_tile(a0)
                move.b  #1,mapping_frame(a0)
                bset    #0,render_flags(a0)
                bset    #7,status(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$50,d0
                move.w  d0,y_pos(a0)
                move.w  #-$200,x_vel(a0)
                bsr.w   EndingInitializeGentleVerticalSwing
                lea     EndingReturnPlane_RawFrameDelayScript(pc),a1
                jsr     (Set_Raw_Animation).l
                lea     EndingPlanePoseOffsetDetail_ChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     EndData_PlanePoseDetailChildRecord(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     EndingPlaneBlinkDetail_ChildRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

EndPlane_FlyLeftAndGateAnim:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d3
                addi.w  #$60,d3
                cmp.w   x_pos(a0),d3
                blo.s   EndPlane_SwitchToSmallRightPlane
                jsr     (Animate_RawMultiDelay).l

EndPlane_SwitchToSmallRightPlane:
                subi.w  #$A0,d3
                cmp.w   x_pos(a0),d3
                blo.w   EndingScene_SharedReturn
                move.b  #$C,routine(a0)
                move.w  #make_art_tile(ArtTile_Ending_PlaneExtra,1,0),art_tile(a0)
                move.b  #6,mapping_frame(a0)
                bclr    #0,render_flags(a0)
                bset    #4,$38(a0)
                move.w  (_unkEE9C).w,d0
                addi.w  #$448,d0
                move.w  d0,y_pos(a0)
                move.w  #$100,x_vel(a0)
                clr.w   y_vel(a0)
                lea     EndData_SmallPlaneCyclingChild(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     Pal_EndingSmallPlane(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

EndPlane_FlyRightAndSignalBackground:
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                cmp.w   x_pos(a0),d0
                bhs.s   EndPlane_BackgroundSignalReturn
                move.b  #$E,routine(a0)
                clr.b   mapping_frame(a0)
                st      (Events_fg_4).w
                tst.b   (_unkFA88).w
                bmi.s   EndPlane_BackgroundSignalReturn
                jsr     (AllocateObject).l
                bne.s   EndPlane_BackgroundSignalReturn
                move.l  #EndLine3Flash_InitRaise,(a1)

EndPlane_BackgroundSignalReturn:
                rts
; ---------------------------------------------------------------------------

EndPlane_WaitForBackgroundAlignment:
                tst.b   (_unkFAA9).w
                beq.s   EndPlane_BackgroundAlignmentReturn
                move.b  #$10,routine(a0)
                move.b  #$1A,mapping_frame(a0)
                move.w  (_unkEE9C).w,d0
                addi.w  #$448,d0
                move.w  d0,y_pos(a0)

EndPlane_BackgroundAlignmentReturn:
                rts
; ---------------------------------------------------------------------------

EndPlane_FlyOffscreenAndRevertSuper:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bmi.s   EndPlane_VisibilityCheckReturn
                move.l  #EndPlane_WaitThenTryCloudField,(a0)
                move.w  #(6*60)-1,$2E(a0)
                move.b  #2,(Super_palette_status).w
                move.w  #$1E,(Palette_frame).w
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #0,(Super_Tails_flag).w
                bset    #1,$38(a0)

EndPlane_VisibilityCheckReturn:
                rts
; ---------------------------------------------------------------------------

EndPlane_WaitThenTryCloudField:
                subq.w  #1,$2E(a0)
                bpl.w   EndingScene_SharedReturn
                jsr     (AllocateObject).l
                bne.s   EndPlane_SetCloudParameters
                move.l  #EndCloud_InitFieldPaletteAndArt,(a1)

; Set the scroll parameters even if the cloud actor allocation failed
EndPlane_SetCloudParameters:
                move.b  #$3F,(_unkFAB9).w
                clr.w   (_unkFAC2).w
                move.w  #-$80,(_unkFAC4).w
                tst.b   (_unkFA88).w
                bmi.s   EndPlane_DeleteAfterCloudSetup
                move.w  #$80,(_unkFAC4).w

EndPlane_DeleteAfterCloudSetup:
                jmp     (Delete_Current_Sprite).l
