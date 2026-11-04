; Owner: objects/zones/hpz/sk
; Responsibility: Hidden Palace special-stage selection, transition, hub state and common emerald control helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HPZSSEntryControl:
                lea     (ArtKosM_HPZSmallEmeralds).l,a1
                move.w  #tiles_to_bytes(ArtTile_HPZSmallEmeralds),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_Teleporter).l,a1
                move.w  #tiles_to_bytes(ArtTile_HPZEntryTeleporter),d2
                jsr     (Queue_Kos_Module).l
                lea     (Pal_CutsceneKnux).l,a1
                cmpi.w  #3,(Player_mode).w
                bne.s   HPZEntry_SetCharacterPaletteDestination
                lea     (Pal_SonicTails).l,a1

HPZEntry_SetCharacterPaletteDestination:
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d0

HPZEntry_CopyCharacterPaletteLongs:
                move.l  (a1)+,(a2)+
                dbf     d0,HPZEntry_CopyCharacterPaletteLongs
                lea     (Pal_HPZ+$20).l,a1
                lea     (Target_palette_line_3).w,a2
                moveq   #bytesToLcnt($40),d6

HPZEntry_CopyHubPalettesAndTryMaster:
                move.l  (a1)+,(a2)+
                dbf     d6,HPZEntry_CopyHubPalettesAndTryMaster
                move.l  #$6A00660,(Target_palette_line_4+$2).w
                jsr     (AllocateObject).l
                bne.s   HPZEntry_TryCreateReturnTeleporter
                move.l  #Obj_HPZMasterEmerald,(a1)

HPZEntry_TryCreateReturnTeleporter:
                jsr     (AllocateObject).l
                bne.s   HPZEntry_SelectEmeraldSetup
                move.l  #Obj_SSZHPZTeleporter,(a1)
                move.w  #$1640,x_pos(a1)
                move.w  #$3C7,y_pos(a1)
                move.w  a1,$44(a0)

HPZEntry_SelectEmeraldSetup:
                tst.w   (HPZ_special_stage_completed).w
                beq.s   HPZEntry_InitializeConversionController
                moveq   #0,d2
                moveq   #7-1,d3

; The completed-room path assumes allocation succeeds for all seven emeralds
HPZEntry_SpawnCompletedEmeralds:
                jsr     (AllocateObject).l
                move.l  #Obj_HPZSuperEmerald,(a1)
                move.b  d2,subtype(a1)
                addq.w  #1,d2
                dbf     d3,HPZEntry_SpawnCompletedEmeralds
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

HPZEntry_InitializeConversionController:
                move.l  #HPZEntry_WaitThenTryInitialPlayerBeam,(a0)
                move.w  #$1F,$2E(a0)
                lea     (Collected_emeralds_array).w,a2
                moveq   #2,d1
                moveq   #0,d2
                moveq   #7-1,d3

HPZEntry_SpawnConvertedEmeralds:
                cmp.b   (a2)+,d1
                bhi.s   HPZEntry_NextEmeraldOrStagePlayers
                jsr     (AllocateObject).l
                move.l  #Obj_HPZSuperEmerald,(a1)
                move.b  d2,subtype(a1)

HPZEntry_NextEmeraldOrStagePlayers:
                addq.w  #1,d2
                dbf     d3,HPZEntry_SpawnConvertedEmeralds
                lea     (Player_1).w,a1
                bsr.w   PreparePlayerForHpzEmeraldConversion
                lea     (Player_2).w,a1

; =============== S U B R O U T I N E =======================================

PreparePlayerForHpzEmeraldConversion:
                move.b  #$83,object_control(a1)
                bset    #7,art_tile(a1)
                move.b  #0,mapping_frame(a1)
                move.b  #$1C,anim(a1)
                move.w  #$1640,x_pos(a1)
                move.w  #$3A3,y_pos(a1)
                rts
; End of function PreparePlayerForHpzEmeraldConversion

; ---------------------------------------------------------------------------

HPZEntry_WaitThenTryInitialPlayerBeam:
                subq.w  #1,$2E(a0)
                bpl.s   HPZEntry_ReturnFromInitialBeamWait
                move.l  #HPZEntry_TryBuildConversionQueue,(a0)
                jsr     (AllocateObject).l
                bne.s   HPZEntry_ReturnFromInitialBeamWait
                move.l  #HPZBeam_InitializeFromSubtypePosition,(a1)
                move.b  #7,subtype(a1)

HPZEntry_ReturnFromInitialBeamWait:
                rts
; ---------------------------------------------------------------------------

HPZEntry_TryBuildConversionQueue:
                bclr    #0,(_unkFAB8).w
                beq.w   HPZEntry_SharedStateReturn
                lea     (Collected_emeralds_array).w,a1
                lea     HPZEntry_ConversionColorScanOrder(pc),a2
                lea     (_unkFA82).w,a3
                lea     HPZEntry_CameraTargetsByEmeraldColor(pc),a4
                lea     (_unkFAB0).w,a5
                moveq   #0,d0
                moveq   #0,d1
                moveq   #0,d2
                moveq   #7-1,d3

HPZEntry_QueueOneCollectedChaosEmerald:
                move.b  (a2)+,d0
                move.b  (a1,d0.w),d4
                beq.s   HPZEntry_RecordGrayEmeraldPresence
                cmpi.b  #1,d4
                bne.s   HPZEntry_RecordGrayEmeraldPresence
                move.b  d0,(a5)+
                add.w   d0,d0
                move.w  (a4,d0.w),(a3)+
                moveq   #1,d1

HPZEntry_RecordGrayEmeraldPresence:
                cmpi.b  #2,d4
                bne.s   HPZEntry_FinishQueueOrPermitReturn
                moveq   #1,d2

HPZEntry_FinishQueueOrPermitReturn:
                dbf     d3,HPZEntry_QueueOneCollectedChaosEmerald
                clr.w   (a3)
                tst.w   d1
                bne.s   HPZEntry_BeginConversion
                tst.w   d2
                bne.s   HPZEntry_SkipEmptyConversion
                bset    #5,$38(a0)

HPZEntry_SkipEmptyConversion:
                bra.w   HPZEntry_ReleasePlayersAndWatchReturn
; ---------------------------------------------------------------------------

HPZEntry_BeginConversion:
                move.l  #HPZEntry_TickPresentationDelay,(a0)
                move.w  #$21F,$2E(a0)
                st      (Emeralds_converted_flag).w
                lea     HPZEntry_ConversionChild(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------
HPZEntry_CameraTargetsByEmeraldColor:
                dc.w    $15A0, $1540, $1600, $1520, $1620, $1520, $1620
HPZEntry_ConversionColorScanOrder:
                dc.b    5,   3,   1,   0,   2,   4,   6
                even
; ---------------------------------------------------------------------------

HPZEntry_TickPresentationDelay:
                subq.w  #1,$2E(a0)
                bpl.w   HPZEntry_SharedStateReturn
                move.l  #HPZEntry_TryBeamAtQueuedColor,$34(a0)

HPZEntry_SelectNextViewingTarget:
                move.l  #HPZEntry_PanCameraTowardSelectedTarget,(a0)
                st      (Scroll_lock).w
                moveq   #0,d0
                move.b  $39(a0),d0
                addq.b  #1,$39(a0)
                lea     (_unkFAB0).w,a1
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                move.b  d1,$3C(a0)
                add.w   d0,d0
                lea     (_unkFA82).w,a1
                move.w  (a1,d0.w),$3A(a0)
                bne.s   HPZEntry_ApplyBothViewingPoses
                move.l  #HPZEntry_ReleasePlayersAndWatchReturn,$34(a0)
                move.w  #$15A0,$3A(a0)
                moveq   #2,d1

HPZEntry_ApplyBothViewingPoses:
                add.w   d1,d1
                lea     HPZEntry_ViewFacingAndFrameGroupPairs(pc,d1.w),a2
                lea     (Player_1).w,a1
                bsr.w   SetPlayerHpzEmeraldViewingPose
                lea     (Player_2).w,a1

; =============== S U B R O U T I N E =======================================

SetPlayerHpzEmeraldViewingPose:
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                tst.b   (a2)
                beq.s   HPZEntry_ApplyPoseAndLoadArt
                bset    #0,render_flags(a1)
                bset    #Status_Facing,status(a1)

HPZEntry_ApplyPoseAndLoadArt:
                moveq   #0,d0
                move.b  1(a2),d0
                add.b   character_id(a1),d0
                move.b  HPZEntry_AlignedViewingPoseFrameGroups(pc,d0.w),mapping_frame(a1)
                move.l  a2,-(sp)
                jsr     (Player_Load_PLC2).l
                movea.l (sp)+,a2
                rts
; End of function SetPlayerHpzEmeraldViewingPose

; ---------------------------------------------------------------------------
HPZEntry_ViewFacingAndFrameGroupPairs:
                dc.b    1,   4
                dc.b    1,   0
                dc.b    0,   0
                dc.b    1,   4
                dc.b    0,   4
                dc.b    1,   0
                dc.b    0,   0
HPZEntry_AlignedViewingPoseFrameGroups:
                dc.b    $BA, $AD, $56
                even
                dc.b    $C4, $B0, $D6
                even
; ---------------------------------------------------------------------------

HPZEntry_PanCameraTowardSelectedTarget:
                move.w  (Camera_X_pos).w,d0
                moveq   #-$10,d1
                sub.w   $3A(a0),d0
                bpl.s   HPZEntry_StepCameraUnlessWithinSixteen
                neg.w   d0
                neg.w   d1

HPZEntry_StepCameraUnlessWithinSixteen:
                cmpi.w  #$10,d0
                blo.s   HPZEntry_TailCallCameraArrivalCallback
                add.w   d1,(Camera_X_pos).w
                rts
; ---------------------------------------------------------------------------

HPZEntry_TailCallCameraArrivalCallback:
                movea.l $34(a0),a1
                jmp     (a1)
; ---------------------------------------------------------------------------

HPZEntry_TryBeamAtQueuedColor:
                move.l  #HPZEntry_WaitBeforeNextCameraTarget,(a0)
                move.w  #$1F,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   HPZEntry_ReturnAfterQueuedBeamAttempt
                move.l  #HPZBeam_InitializeFromSubtypePosition,(a1)
                move.b  $3C(a0),subtype(a1)

HPZEntry_ReturnAfterQueuedBeamAttempt:
                rts
; ---------------------------------------------------------------------------

HPZEntry_ReleasePlayersAndWatchReturn:
                move.l  #HPZEntry_GetP1ReturnDistance,(a0)
                clr.b   (Scroll_lock).w
                clr.b   (Player_1+object_control).w
                clr.b   (Player_2+object_control).w
                rts
; ---------------------------------------------------------------------------

HPZEntry_WaitBeforeNextCameraTarget:
                subq.w  #1,$2E(a0)
                bmi.w   HPZEntry_SelectNextViewingTarget

HPZEntry_SharedStateReturn:
                rts
; ---------------------------------------------------------------------------

HPZEntry_GetP1ReturnDistance:
                lea     (Player_1).w,a1
                move.w  x_pos(a1),d0
                subi.w  #$1640,d0
                bpl.s   HPZEntry_CheckReturnWindow
                neg.w   d0

HPZEntry_CheckReturnWindow:
                cmpi.w  #8,d0
                blo.s   HPZEntry_ConsumeArmedCenterReentry
                cmpi.w  #$18,d0
                blo.s   HPZEntry_ReturnFromCenterMonitor
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

HPZEntry_ConsumeArmedCenterReentry:
                bclr    #3,$38(a0)
                beq.s   HPZEntry_ReturnFromCenterMonitor
                movea.w $44(a0),a1
                btst    #3,status(a1)
                beq.s   HPZEntry_ReturnFromCenterMonitor
                btst    #5,$38(a0)
                beq.s   HPZEntry_ReturnFromCenterMonitor
                moveq   #signextendB(sfx_EnterSS),d0
                jsr     (Play_SFX).l
                move.w  #1,(Restart_level_flag).w
                move.b  (Saved2_last_star_post_hit).w,(Last_star_post_hit).w
                move.w  (Saved2_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved2_apparent_zone_and_act).w,(Apparent_zone_and_act).w
                move.b  (Player_1+status_secondary).w,(Saved2_status_secondary).w
                ori.b   #$80,(Last_star_post_hit).w

HPZEntry_ReturnFromCenterMonitor:
                rts
; ---------------------------------------------------------------------------

HPZBeam_InitializeFromSubtypePosition:
                lea     HPZBeam_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HPZBeam_DescendAndArmMidpointTimer,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                lea     HPZBeam_SubtypeXAndTargetY(pc,d0.w),a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,$3A(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$80,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
HPZBeam_SubtypeXAndTargetY:
                dc.w    $1640,  $300
                dc.w    $15E0,  $328
                dc.w    $16A0,  $328
                dc.w    $15A0,  $2D8
                dc.w    $16E0,  $2D8
                dc.w    $1550,  $318
                dc.w    $1730,  $318
                dc.w    $1640,  $340
; ---------------------------------------------------------------------------

HPZBeam_DescendAndArmMidpointTimer:
                move.w  y_pos(a0),d0
                addi.w  #$10,d0
                move.w  d0,y_pos(a0)
                cmp.w   $3A(a0),d0
                blo.s   HPZBeam_DrawOnEvenVint
                move.l  #HPZBeam_WaitForMidpointOrUnderflow,(a0)
                move.w  #$3F,$2E(a0)
                move.w  #8,(Screen_shake_flag).w
                moveq   #signextendB(sfx_BossLaser),d0
                jsr     (Play_SFX).l

HPZBeam_DrawOnEvenVint:
                btst    #0,(V_int_run_count+3).w
                bne.w   HPZEntry_SharedStateReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZBeam_WaitForMidpointOrUnderflow:
                subq.w  #1,$2E(a0)
                bmi.s   HPZBeam_InstallCompletionRawPhase
                cmpi.w  #$20,$2E(a0)
                bne.s   HPZBeam_DrawOnEvenVint
                bsr.w   ApplyHpzConversionBeamMidpoint

HPZBeam_InstallCompletionRawPhase:
                move.l  #HPZBeam_AnimateCompletionAndFlicker,(a0)
                move.l  #HPZBeam_SignalDoneAndGrayChild,$34(a0)
                bra.s   HPZBeam_DrawOnEvenVint
; ---------------------------------------------------------------------------

HPZBeam_AnimateCompletionAndFlicker:
                lea     HPZBeam_CompletionRawFrameStream(pc),a1
                jsr     (Animate_RawNoSST).l
                bra.s   HPZBeam_DrawOnEvenVint
; ---------------------------------------------------------------------------

HPZBeam_SignalDoneAndGrayChild:
                bset    #0,(_unkFAB8).w
                move.w  $44(a0),d0
                beq.s   HPZBeam_DeferDeletionAfterCompletion
                movea.w d0,a1
                bset    #5,$38(a1)

HPZBeam_DeferDeletionAfterCompletion:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

HPZConversion_InitRisingCoordinator:
                move.l  #HPZConversion_RiseThenRevealBothPlayers,(a0)
                bset    #2,render_flags(a0)
                move.w  #-$80,y_vel(a0)
                move.w  #$7F,$2E(a0)
                moveq   #signextendB(sfx_Signpost),d0
                jsr     (Play_SFX).l
                lea     HPZConversion_ParticleChildren(pc),a2
                jsr     (CreateChild6_Simple).l

HPZConversion_RiseThenRevealBothPlayers:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   HPZConversion_RiseReturn
                move.l  #HPZConversion_TryReleaseParticles,(a0)
                lea     (Player_1).w,a1
                bsr.w   SetPlayerHpzEmeraldRevealPose
                lea     (Player_2).w,a1

; =============== S U B R O U T I N E =======================================

SetPlayerHpzEmeraldRevealPose:
                moveq   #0,d0
                move.b  character_id(a1),d0
                move.b  HPZConversion_RevealFramesByCharacter(pc,d0.w),mapping_frame(a1)
                move.l  a2,-(sp)
                jsr     (Player_Load_PLC2).l
                movea.l (sp)+,a2

HPZConversion_RiseReturn:
                rts
; End of function SetPlayerHpzEmeraldRevealPose

; ---------------------------------------------------------------------------
HPZConversion_RevealFramesByCharacter:
                dc.b    $C4, $B0, $D6
                even
; ---------------------------------------------------------------------------

HPZConversion_TryReleaseParticles:
                cmpi.b  #$7F,$27(a0)
                bne.s   HPZConversion_ReturnFromCompletionGate
                bset    #2,$38(a0)
                bset    #7,$38(a0)
                bne.s   HPZConversion_ReturnFromCompletionGate
                moveq   #signextendB(sfx_SuperEmerald),d0
                jsr     (Play_SFX).l

HPZConversion_ReturnFromCompletionGate:
                rts
; ---------------------------------------------------------------------------

HPZParticle_InitializeAndEnterExpansion:
                lea     HPZParticle_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HPZParticle_ExpandRadiusToTarget,(a0)
                bset    #7,render_flags(a0)
                move.w  #$7F,$2E(a0)
                bsr.w   HPZEmeraldConvert_InitParticle

HPZParticle_ExpandRadiusToTarget:
                move.w  $3A(a0),d0
                addi.w  #$10,d0
                move.w  d0,$3A(a0)
                cmpi.w  #$1800,d0
                blo.s   HPZParticle_AdvanceOrbitAndPosition
                move.l  #HPZParticle_CheckUnsignedPhaseDistance,(a0)

HPZParticle_AdvanceOrbitAndPosition:
                addq.b  #4,$3C(a0)
                jsr     (MoveSprite_Circular).l

HPZParticle_DrawOnEvenVint:
                btst    #0,(V_int_run_count+3).w
                bne.w   HPZEntry_SharedStateReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZParticle_CheckUnsignedPhaseDistance:
                move.b  $3D(a0),d0
                sub.b   $3C(a0),d0
                cmpi.b  #4,d0
                blo.s   HPZParticle_SetParentColorCompletionBit
                bra.s   HPZParticle_AdvanceOrbitAndPosition
; ---------------------------------------------------------------------------

HPZParticle_SetParentColorCompletionBit:
                move.l  #HPZParticle_WaitForCoordinatorRelease,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                movea.w parent3(a0),a1
                bset    d0,$27(a1)

HPZParticle_WaitForCoordinatorRelease:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   HPZParticle_DrawOnEvenVint
                move.l  #HPZParticle_MoveUntilPreviouslyOffscreen,(a0)
                bra.s   HPZParticle_DrawOnEvenVint
; ---------------------------------------------------------------------------

HPZParticle_MoveUntilPreviouslyOffscreen:
                tst.b   render_flags(a0)
                bpl.s   HPZParticle_DeleteAfterVisibilityLoss
                jsr     (MoveSprite2).l
                bra.s   HPZParticle_DrawOnEvenVint
; ---------------------------------------------------------------------------

HPZParticle_DeleteAfterVisibilityLoss:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

ApplyHpzConversionBeamMidpoint:
                cmpi.b  #7,subtype(a0)
                bne.s   HPZBeam_RecordConversionAndSpawn
                lea     (Player_1).w,a1
                bsr.w   SetPlayerHpzBeamReactionPose
                lea     (Player_2).w,a1
; End of function ApplyHpzConversionBeamMidpoint

; =============== S U B R O U T I N E =======================================

SetPlayerHpzBeamReactionPose:
                moveq   #0,d0
                move.b  character_id(a1),d0
                cmpi.b  #1,d0
                bne.s   HPZEntry_ApplyBeamReactionFrameAndArt
                addq.w  #4,y_pos(a1)

HPZEntry_ApplyBeamReactionFrameAndArt:
                move.b  HPZEntry_BeamReactionFramesByCharacter(pc,d0.w),mapping_frame(a1)
                move.b  #5,anim(a1)
                jmp     (Player_Load_PLC2).l
; End of function SetPlayerHpzBeamReactionPose

; ---------------------------------------------------------------------------

HPZBeam_RecordConversionAndSpawn:
                lea     (Collected_emeralds_array).w,a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                addq.b  #1,(a1,d0.w)
                jsr     (AllocateObject).l
                bne.s   HPZBeam_RequestSaveAfterConversion
                move.l  #Obj_HPZSuperEmerald,(a1)
                move.b  subtype(a0),subtype(a1)
                bset    #7,$38(a1)
                move.w  a1,$44(a0)

HPZBeam_RequestSaveAfterConversion:
                st      (SRAM_mask_interrupts_flag).w
                jmp     (SaveGame_SpecialStage).l
; ---------------------------------------------------------------------------
HPZEntry_BeamReactionFramesByCharacter:
                dc.b    $BA, $AD, $56
                even

; =============== S U B R O U T I N E =======================================

; Select phase, velocity and art by color. If conversion is unnecessary, mark completion and delete the particle
HPZEmeraldConvert_InitParticle:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d0
                move.b  d0,subtype(a0)
                move.b  HPZParticle_InitialPhasesByColor(pc,d0.w),$3C(a0)
                move.b  HPZParticle_TargetPhasesByColor(pc,d0.w),$3D(a0)
                lea     (Collected_emeralds_array).w,a1
                move.b  (a1,d0.w),d2
                beq.s   HPZParticle_MarkSkippedColorAndDelete
                cmpi.b  #2,d2
                bhs.s   HPZParticle_MarkSkippedColorAndDelete
                move.b  d0,mapping_frame(a0)
                add.w   d1,d1
                move.l  HPZParticle_DepartureVelocityPairs(pc,d1.w),x_vel(a0)  ; and y_vel
                cmpi.w  #3,(Player_mode).w
                bne.s   HPZParticle_ApplyModePairedArt
                addq.w  #2,d1

HPZParticle_ApplyModePairedArt:
                move.w  HPZParticle_ModePairedArtWords(pc,d1.w),d2
                move.w  d2,art_tile(a0)
                rts
; ---------------------------------------------------------------------------

; Drop the helper return address so the particle update ends here
HPZParticle_MarkSkippedColorAndDelete:
                movea.w parent3(a0),a1
                bset    d0,$27(a1)
                addq.w  #4,sp
                jmp     (Delete_Current_Sprite).l
; End of function HPZEmeraldConvert_InitParticle

; ---------------------------------------------------------------------------
HPZParticle_InitialPhasesByColor:
                dc.b    0, $24, $48, $6C, $90, $B4, $D8
                even
HPZParticle_TargetPhasesByColor:
                dc.b    $80, $86, $7A, $8C, $74, $92, $6E
                even
HPZParticle_DepartureVelocityPairs:
                dc.w    0, -$400
                dc.w    -$F8, -$3E0
                dc.w    $F8, -$3E0
                dc.w    -$1E0, -$384
                dc.w    $1E0, -$384
                dc.w    -$2AC, -$2F4
                dc.w    $2AC, -$2F4
HPZParticle_ModePairedArtWords:
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,2,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,2,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,0,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,1,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,2,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,2,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,0,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,1,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,0,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,1,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,0,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,1,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,3,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,3,1)
