; Owner: objects/development/s3
; Responsibility: Sphere test object setup, projected motion, sprite display and experimental sphere mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SphereTest:
                lea     (S3SphereTest_AssignedGridRecordData).l,a6
                movea.l a0,a1
                move.l  #Obj_SphereTest_Main,(a1)
                cmpi.b  #1,subtype(a0)
                beq.w   S3SphereTest_BeginFourRingPointConstruction
                cmpi.b  #2,subtype(a0)
                beq.w   S3SphereTest_BeginThreeOrthogonalRingPointConstruction
                tst.b   (Ctrl_2).w
                bne.w   S3SphereTest_BeginThreeOrthogonalRingPointConstruction

S3SphereTest_BeginFourRingPointConstruction:
                moveq   #0,d2
                moveq   #$E-1,d3
                tst.w   (Sphere_test_address).w
                bne.s   S3SphereTest_InstallPointOnlyHandlerForPreexistingOwnerOrNewChild
                move.w  a0,(Sphere_test_address).w
                move.w  #0,(_unkE412).w
                move.w  #0,(_unkE414).w
                move.w  #$200,(_unkE416).w
                move.w  #0,(SStage_scalar_index_0).w
                move.w  #0,(SStage_scalar_index_1).w
                move.w  #0,(SStage_scalar_index_2).w
                bra.s   S3SphereTest_InitializeFirstRingAtNegativeFixedZ
; ---------------------------------------------------------------------------

S3SphereTest_AllocateNextFirstRingPointOrFinishPartialPrefix:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SphereTest_FinishFourRingPrefixWithPaletteAndArtRequest

S3SphereTest_InstallPointOnlyHandlerForPreexistingOwnerOrNewChild:
                move.l  #Obj_EosianSphere,(a1)

S3SphereTest_InitializeFirstRingAtNegativeFixedZ:
                bsr.w   SphereTestS3InitializeFourRingPointSpriteAndCenter
                bsr.w   SphereTestS3SkipQuarterTurnSamples
                move.w  d2,d0
                addi.w  #$10,d2
                jsr     (GetSineCosine).l
                asr.w   #1,d0
                asr.w   #1,d1
                move.w  d1,$34(a1)
                move.w  d0,$36(a1)
                move.w  #-$20,$38(a1)
                move.l  a6,$3A(a1)
                adda.w  #$10,a6
                dbf     d3,S3SphereTest_AllocateNextFirstRingPointOrFinishPartialPrefix
                moveq   #0,d2
                moveq   #$E-1,d3

S3SphereTest_AllocateSecondRingAtPositiveFixedZ:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SphereTest_FinishFourRingPrefixWithPaletteAndArtRequest
                move.l  #Obj_EosianSphere,(a1)
                bsr.w   SphereTestS3InitializeFourRingPointSpriteAndCenter
                bsr.w   SphereTestS3SkipQuarterTurnSamples
                move.w  d2,d0
                addi.w  #$10,d2
                jsr     (GetSineCosine).l
                asr.w   #1,d0
                asr.w   #1,d1
                move.w  d1,$34(a1)
                move.w  d0,$36(a1)
                move.w  #$20,$38(a1)
                move.l  a6,$3A(a1)
                adda.w  #$10,a6
                dbf     d3,S3SphereTest_AllocateSecondRingAtPositiveFixedZ
                moveq   #0,d2
                moveq   #$E-1,d3

S3SphereTest_AllocateThirdRingAtPositiveFixedX:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SphereTest_FinishFourRingPrefixWithPaletteAndArtRequest
                move.l  #Obj_EosianSphere,(a1)
                bsr.w   SphereTestS3InitializeFourRingPointSpriteAndCenter
                bsr.w   SphereTestS3SkipQuarterTurnSamples
                move.w  d2,d0
                addi.w  #$10,d2
                jsr     (GetSineCosine).l
                asr.w   #1,d0
                asr.w   #1,d1
                move.w  #$20,$34(a1)
                move.w  d0,$36(a1)
                move.w  d1,$38(a1)
                move.l  a6,$3A(a1)
                adda.w  #$10,a6
                dbf     d3,S3SphereTest_AllocateThirdRingAtPositiveFixedX
                moveq   #0,d2
                moveq   #$E-1,d3

S3SphereTest_AllocateFourthRingAtNegativeFixedX:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SphereTest_FinishFourRingPrefixWithPaletteAndArtRequest
                move.l  #Obj_EosianSphere,(a1)
                bsr.w   SphereTestS3InitializeFourRingPointSpriteAndCenter
                bsr.w   SphereTestS3SkipQuarterTurnSamples
                move.w  d2,d0
                addi.w  #$10,d2
                jsr     (GetSineCosine).l
                asr.w   #1,d0
                asr.w   #1,d1
                move.w  #-$20,$34(a1)
                move.w  d0,$36(a1)
                move.w  d1,$38(a1)
                move.l  a6,$3A(a1)
                adda.w  #$10,a6
                dbf     d3,S3SphereTest_AllocateFourthRingAtNegativeFixedX

S3SphereTest_FinishFourRingPrefixWithPaletteAndArtRequest:
                lea     (Pal_SphereTest).l,a1
                lea     (Normal_palette_line_2).w,a2
                move.w  #bytesToWcnt($20),d0

S3SphereTest_CopySixteenFourRingPaletteWords:
                move.w  (a1)+,(a2)+
                dbf     d0,S3SphereTest_CopySixteenFourRingPaletteWords
                moveq   #PLCID_09,d0
                jsr     (Load_PLC).l
                bra.w   Obj_SphereTest_Main

; =============== S U B R O U T I N E =======================================

SphereTestS3InitializeFourRingPointSpriteAndCenter:
                move.b  #4,render_flags(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.l  #Map_SphereTest,mappings(a1)
                move.w  #make_art_tile(ArtTile_SphereTest,1,0),art_tile(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  x_pos(a0),$30(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  y_pos(a0),$32(a1)
                rts
; End of function SphereTestS3InitializeFourRingPointSpriteAndCenter

; =============== S U B R O U T I N E =======================================

SphereTestS3SkipQuarterTurnSamples:
                cmpi.w  #$40,d2
                bne.s   S3SphereTest_SkipNegativeYQuarterPhaseWhenConstructingFourRings
                addi.w  #$10,d2

S3SphereTest_SkipNegativeYQuarterPhaseWhenConstructingFourRings:
                cmpi.w  #$C0,d2
                bne.s   S3SphereTest_ReturnAfterQuarterPhaseAdjustments
                addi.w  #$10,d2

S3SphereTest_ReturnAfterQuarterPhaseAdjustments:
                rts
; End of function SphereTestS3SkipQuarterTurnSamples

; ---------------------------------------------------------------------------

S3SphereTest_BeginThreeOrthogonalRingPointConstruction:
                moveq   #0,d2
                moveq   #$10-1,d3
                tst.w   (Sphere_test_address).w
                bne.s   S3SphereTest_InstallPointHandlerForThreeRingExistingOwnerOrChild
                move.w  a0,(Sphere_test_address).w
                move.w  #0,(_unkE412).w
                move.w  #0,(_unkE414).w
                move.w  #$200,(_unkE416).w
                move.w  #0,(SStage_scalar_index_0).w
                move.w  #0,(SStage_scalar_index_1).w
                move.w  #0,(SStage_scalar_index_2).w
                bra.s   S3SphereTest_InitializeFirstThreeRingInZeroZPlane
; ---------------------------------------------------------------------------

S3SphereTest_AllocateNextFirstThreeRingPointOrFinishPrefix:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SphereTest_FinishThreeRingPrefixWithPaletteAndArtRequest

S3SphereTest_InstallPointHandlerForThreeRingExistingOwnerOrChild:
                move.l  #Obj_EosianSphere,(a1)

S3SphereTest_InitializeFirstThreeRingInZeroZPlane:
                bsr.w   SphereTestS3InitializeThreeRingPointSpriteAndCenter
                move.w  d2,d0
                addi.w  #$10,d2
                jsr     (GetSineCosine).l
                asr.w   #1,d0
                asr.w   #1,d1
                move.w  d1,$34(a1)
                move.w  d0,$36(a1)
                move.w  #0,$38(a1)
                move.l  a6,$3A(a1)
                adda.w  #$10,a6
                dbf     d3,S3SphereTest_AllocateNextFirstThreeRingPointOrFinishPrefix
                moveq   #0,d2
                moveq   #$10-1,d3

S3SphereTest_AllocateSecondThreeRingInZeroXPlane:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SphereTest_FinishThreeRingPrefixWithPaletteAndArtRequest
                move.l  #Obj_EosianSphere,(a1)
                bsr.w   SphereTestS3InitializeThreeRingPointSpriteAndCenter
                move.w  d2,d0
                addi.w  #$10,d2
                jsr     (GetSineCosine).l
                asr.w   #1,d0
                asr.w   #1,d1
                move.w  #0,$34(a1)
                move.w  d0,$36(a1)
                move.w  d1,$38(a1)
                move.l  a6,$3A(a1)
                adda.w  #$10,a6
                dbf     d3,S3SphereTest_AllocateSecondThreeRingInZeroXPlane
                moveq   #0,d2
                moveq   #$10-1,d3

S3SphereTest_AllocateThirdThreeRingInZeroYPlane:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SphereTest_FinishThreeRingPrefixWithPaletteAndArtRequest
                move.l  #Obj_EosianSphere,(a1)
                bsr.w   SphereTestS3InitializeThreeRingPointSpriteAndCenter
                move.w  d2,d0
                addi.w  #$10,d2
                jsr     (GetSineCosine).l
                asr.w   #1,d0
                asr.w   #1,d1
                move.w  d0,$34(a1)
                move.w  #0,$36(a1)
                move.w  d1,$38(a1)
                move.l  a6,$3A(a1)
                adda.w  #$10,a6
                dbf     d3,S3SphereTest_AllocateThirdThreeRingInZeroYPlane

S3SphereTest_FinishThreeRingPrefixWithPaletteAndArtRequest:
                lea     (Pal_SphereTest).l,a1
                lea     (Normal_palette_line_2).w,a2
                move.w  #bytesToWcnt($20),d0

S3SphereTest_CopySixteenThreeRingPaletteWords:
                move.w  (a1)+,(a2)+
                dbf     d0,S3SphereTest_CopySixteenThreeRingPaletteWords
                moveq   #PLCID_09,d0
                jsr     (Load_PLC).l
                bra.w   Obj_SphereTest_Main

; =============== S U B R O U T I N E =======================================

SphereTestS3InitializeThreeRingPointSpriteAndCenter:
                move.b  #4,render_flags(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.l  #Map_SphereTest,mappings(a1)
                move.w  #make_art_tile(ArtTile_SphereTest,1,0),art_tile(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  x_pos(a0),$30(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  y_pos(a0),$32(a1)
                rts
; End of function SphereTestS3InitializeThreeRingPointSpriteAndCenter

; ---------------------------------------------------------------------------
Pal_SphereTest:
                binclude "data/General/Special Stage/Palettes/Eosian Spheres.bin"
                even
; ---------------------------------------------------------------------------

Obj_SphereTest_Main:
                move.b  (Ctrl_2).w,d1
                btst    #button_A,d1
                beq.s   S3SphereTest_ApplyHeldCDepthDecreaseBeforeModeControls
                cmpi.w  #$800,(_unkE416).w
                bcc.s   S3SphereTest_ApplyHeldCDepthDecreaseBeforeModeControls
                addq.w  #8,(_unkE416).w

S3SphereTest_ApplyHeldCDepthDecreaseBeforeModeControls:
                btst    #button_C,d1
                beq.s   S3SphereTest_SelectAutomaticOrManualScalarIndexControls
                cmpi.w  #$81,(_unkE416).w
                bcs.s   S3SphereTest_SelectAutomaticOrManualScalarIndexControls
                subq.w  #8,(_unkE416).w

S3SphereTest_SelectAutomaticOrManualScalarIndexControls:
                tst.w   $3E(a0)
                bne.s   S3SphereTest_DecrementManualFirstIndexWhileUpHeld
                btst    #button_up,d1
                bne.s   S3SphereTest_AdvanceAutomaticSecondIndexUnlessRightHeld
                addq.w  #3,(SStage_scalar_index_0).w

S3SphereTest_AdvanceAutomaticSecondIndexUnlessRightHeld:
                btst    #button_right,d1
                bne.s   S3SphereTest_AdvanceAutomaticThirdIndexUnlessBHeld
                addq.w  #2,(SStage_scalar_index_1).w

S3SphereTest_AdvanceAutomaticThirdIndexUnlessBHeld:
                btst    #button_B,d1
                bne.s   S3SphereTest_JoinStartToggleAfterAutomaticIndices
                addq.w  #1,(SStage_scalar_index_2).w

S3SphereTest_JoinStartToggleAfterAutomaticIndices:
                bra.s   S3SphereTest_ToggleControlModeAndResetAllAnglesOnNewStart
; ---------------------------------------------------------------------------

S3SphereTest_DecrementManualFirstIndexWhileUpHeld:
                btst    #button_up,d1
                beq.s   S3SphereTest_IncrementManualSecondIndexWhileRightHeld
                subq.w  #1,(SStage_scalar_index_0).w

S3SphereTest_IncrementManualSecondIndexWhileRightHeld:
                btst    #button_right,d1
                beq.s   S3SphereTest_IncrementManualThirdIndexWhileBHeld
                addq.w  #1,(SStage_scalar_index_1).w

S3SphereTest_IncrementManualThirdIndexWhileBHeld:
                btst    #button_B,d1
                beq.s   S3SphereTest_ToggleControlModeAndResetAllAnglesOnNewStart
                addq.w  #1,(SStage_scalar_index_2).w

S3SphereTest_ToggleControlModeAndResetAllAnglesOnNewStart:
                btst    #button_start,(Ctrl_2_pressed).w
                beq.s   S3SphereTest_IncreaseVerticalTranslationWhenDownNotHeld
                eori.w  #-1,$3E(a0)
                move.w  #0,(SStage_scalar_index_0).w
                move.w  #0,(SStage_scalar_index_1).w
                move.w  #0,(SStage_scalar_index_2).w

S3SphereTest_IncreaseVerticalTranslationWhenDownNotHeld:
                btst    #button_down,d1
                bne.s   S3SphereTest_DecreaseVerticalTranslationWhenLeftNotHeld
                addq.w  #8,(_unkE414).w

S3SphereTest_DecreaseVerticalTranslationWhenLeftNotHeld:
                btst    #button_left,d1
                bne.s   S3SphereTest_BuildThreeScalarPairsThenProjectCurrentPoint
                subq.w  #8,(_unkE414).w

S3SphereTest_BuildThreeScalarPairsThenProjectCurrentPoint:
                move.w  (SStage_scalar_index_2).w,d0
                lea     (SStage_scalar_result_2).w,a1
                bsr.w   GetScalars
                move.w  (SStage_scalar_index_1).w,d0
                lea     (SStage_scalar_result_1).w,a1
                bsr.w   GetScalars
                move.w  (SStage_scalar_index_0).w,d0
                lea     (SStage_scalar_result_0).w,a1
                bsr.w   GetScalars

Obj_EosianSphere:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3SphereTest_ReleaseRespawnBeforeOldProjectedXCull
                bra.s   S3SphereTest_RotatePointCheckDepthProjectAndChooseFrame
; ---------------------------------------------------------------------------

S3SphereTest_ReleaseRespawnBeforeOldProjectedXCull:
                move.w  respawn_addr(a0),d0
                beq.s   S3SphereTest_ClearGlobalOwnerOnlyWhenFullSignextendedHandleMatches
                movea.w d0,a2
                bclr    #7,(a2)

S3SphereTest_ClearGlobalOwnerOnlyWhenFullSignextendedHandleMatches:
                cmpa.w  (Sphere_test_address).w,a0
                bne.s   S3SphereTest_ClearCulledSpherePointImmediately
                move.w  #0,(Sphere_test_address).w

S3SphereTest_ClearCulledSpherePointImmediately:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3SphereTest_RotatePointCheckDepthProjectAndChooseFrame:
                movea.l $3A(a0),a6
                move.w  $34(a0),d1
                move.w  $36(a0),d2
                move.w  $38(a0),d0
                bsr.w   SphereTestS3RotateYZUsingScalarPair0
                bsr.w   SphereTestS3RotateXZUsingScalarPair1
                add.w   (_unkE416).w,d0
                cmpi.w  #$80,d0
                blt.s   S3SphereTest_ReturnAfterNearDepthRejectOrQueuedDraw
                bsr.w   SphereTestS3RotateXYUsingScalarPair2
                add.w   (_unkE414).w,d2
                bsr.w   SphereTestS3PerspectiveDivideXYByDepth
                add.w   $30(a0),d1
                move.w  d1,x_pos(a0)
                add.w   $32(a0),d2
                move.w  d2,y_pos(a0)
                subi.w  #$80,d0
                lsr.w   #5,d0
                addi.w  #0,d0
                cmpi.w  #$10,d0
                bcs.s   S3SphereTest_StoreDepthFrameAndQuantizedDrawPriority
                move.w  #$F,d0

S3SphereTest_StoreDepthFrameAndQuantizedDrawPriority:
                move.b  d0,mapping_frame(a0)
                lsl.w   #6,d0
                andi.w  #$380,d0
                move.w  d0,priority(a0)
                jsr     (Draw_Sprite).l

S3SphereTest_ReturnAfterNearDepthRejectOrQueuedDraw:
                rts
; ---------------------------------------------------------------------------
S3SphereTest_AssignedGridRecordData:
                dc.w    -$70, $8000,  -$70, $8000,     0, $8000,     0,  $234
                dc.w    -$50, $8000,  -$70, $8000,     0, $8000,     0,  $234
                dc.w    -$30, $8000,  -$70, $8000,     0, $8000,     0,  $234
                dc.w    -$10, $8000,  -$70, $8000,     0, $8000,     0,  $234
                dc.w    $10, $8000,  -$70, $8000,     0, $8000,     0,  $234
                dc.w    $30, $8000,  -$70, $8000,     0, $8000,     0,  $234
                dc.w    $50, $8000,  -$70, $8000,     0, $8000,     0,  $234
                dc.w    $70, $8000,  -$70, $8000,     0, $8000,     0,  $234
                dc.w    -$70, $8000,   $70, $8000,     0, $8000,     0,  $234
                dc.w    -$50, $8000,   $70, $8000,     0, $8000,     0,  $234
                dc.w    -$30, $8000,   $70, $8000,     0, $8000,     0,  $234
                dc.w    -$10, $8000,   $70, $8000,     0, $8000,     0,  $234
                dc.w    $10, $8000,   $70, $8000,     0, $8000,     0,  $234
                dc.w    $30, $8000,   $70, $8000,     0, $8000,     0,  $234
                dc.w    $50, $8000,   $70, $8000,     0, $8000,     0,  $234
                dc.w    $70, $8000,   $70, $8000,     0, $8000,     0,  $234

; =============== S U B R O U T I N E =======================================

SphereTestS3PerspectiveDivideXYByDepth:
                ext.l   d1
                lsl.l   #8,d1
                divs.w  d0,d1
                ext.l   d2
                lsl.l   #8,d2
                divs.w  d0,d2
                rts
; End of function SphereTestS3PerspectiveDivideXYByDepth

; =============== S U B R O U T I N E =======================================

SphereTestS3RotateXYUsingScalarPair2:
                swap    d0
                move.w  d1,d3
                move.w  d2,d4
                move.w  (SStage_scalar_result_2).w,d0
                muls.w  d0,d3
                muls.w  d0,d4
                move.w  (SStage_scalar_result_2+2).w,d0
                muls.w  d0,d1
                muls.w  d0,d2
                sub.l   d4,d1
                add.l   d1,d1
                add.l   d1,d1
                swap    d1
                add.l   d3,d2
                add.l   d2,d2
                add.l   d2,d2
                swap    d2
                swap    d0
                rts
; End of function SphereTestS3RotateXYUsingScalarPair2

; =============== S U B R O U T I N E =======================================

SphereTestS3RotateXZUsingScalarPair1:
                swap    d2
                move.w  d0,d3
                move.w  d1,d4
                move.w  (SStage_scalar_result_1).w,d2
                muls.w  d2,d3
                muls.w  d2,d4
                move.w  (SStage_scalar_result_1+2).w,d2
                muls.w  d2,d0
                muls.w  d2,d1
                sub.l   d4,d0
                add.l   d0,d0
                add.l   d0,d0
                swap    d0
                add.l   d3,d1
                add.l   d1,d1
                add.l   d1,d1
                swap    d1
                swap    d2
                rts
; End of function SphereTestS3RotateXZUsingScalarPair1

; =============== S U B R O U T I N E =======================================

SphereTestS3RotateYZUsingScalarPair0:
                swap    d1
                move.w  d0,d3
                move.w  d2,d4
                move.w  (SStage_scalar_result_0).w,d1
                muls.w  d1,d3
                muls.w  d1,d4
                move.w  (SStage_scalar_result_0+2).w,d1
                muls.w  d1,d0
                muls.w  d1,d2
                sub.l   d4,d0
                add.l   d0,d0
                add.l   d0,d0
                swap    d0
                add.l   d3,d2
                add.l   d2,d2
                add.l   d2,d2
                swap    d2
                swap    d1
                rts
; End of function SphereTestS3RotateYZUsingScalarPair0

; =============== S U B R O U T I N E =======================================

GetScalars:
                add.w   d0,d0
                andi.w  #$1FE,d0
                move.w  ScalarTable(pc,d0.w),(a1)+
                addi.w  #$80,d0
                andi.w  #$1FE,d0
                move.w  ScalarTable(pc,d0.w),(a1)+
                rts
; End of function GetScalars

; ---------------------------------------------------------------------------
ScalarTable:
                binclude "data/General/Special Stage/Scalars.bin"
                even
