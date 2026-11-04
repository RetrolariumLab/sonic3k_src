; Owner: objects/development/s3
; Responsibility: Sphere test object setup, projected motion, sprite display and experimental sphere mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SphereTest:
                lea     (S3SphereTest_AssignedGridRecordData).l,a6
                movea.l a0,a1
                move.l  #Obj_SphereTest_Main,(a1)
                cmpi.b  #1,subtype(a0)
                beq.w   S3SphereTest_BeginFourRings
                cmpi.b  #2,subtype(a0)
                beq.w   S3SphereTest_BeginThreeOrthogonalRings
                tst.b   (Ctrl_2).w
                bne.w   S3SphereTest_BeginThreeOrthogonalRings

S3SphereTest_BeginFourRings:
                moveq   #0,d2
                moveq   #$E-1,d3
                tst.w   (Sphere_test_address).w
                bne.s   S3SphereTest_SetFourRingPointHandler
                move.w  a0,(Sphere_test_address).w
                move.w  #0,(_unkE412).w
                move.w  #0,(_unkE414).w
                move.w  #$200,(_unkE416).w
                move.w  #0,(SStage_scalar_index_0).w
                move.w  #0,(SStage_scalar_index_1).w
                move.w  #0,(SStage_scalar_index_2).w
                bra.s   S3SphereTest_InitNegZRingPoint
; ---------------------------------------------------------------------------

S3SphereTest_AllocNegZRingPoint:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SphereTest_FinishFourRings

; An existing owner or a newly allocated child runs only the point handler
S3SphereTest_SetFourRingPointHandler:
                move.l  #Obj_EosianSphere,(a1)

S3SphereTest_InitNegZRingPoint:
                bsr.w   S3SphereTest_InitFourRingPoint
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
                dbf     d3,S3SphereTest_AllocNegZRingPoint
                moveq   #0,d2
                moveq   #$E-1,d3

S3SphereTest_AllocPosZRingPoint:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SphereTest_FinishFourRings
                move.l  #Obj_EosianSphere,(a1)
                bsr.w   S3SphereTest_InitFourRingPoint
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
                dbf     d3,S3SphereTest_AllocPosZRingPoint
                moveq   #0,d2
                moveq   #$E-1,d3

S3SphereTest_AllocPosXRingPoint:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SphereTest_FinishFourRings
                move.l  #Obj_EosianSphere,(a1)
                bsr.w   S3SphereTest_InitFourRingPoint
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
                dbf     d3,S3SphereTest_AllocPosXRingPoint
                moveq   #0,d2
                moveq   #$E-1,d3

S3SphereTest_AllocNegXRingPoint:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SphereTest_FinishFourRings
                move.l  #Obj_EosianSphere,(a1)
                bsr.w   S3SphereTest_InitFourRingPoint
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
                dbf     d3,S3SphereTest_AllocNegXRingPoint

; Load the palette and request art even if allocation produced only part of the rings
S3SphereTest_FinishFourRings:
                lea     (Pal_SphereTest).l,a1
                lea     (Normal_palette_line_2).w,a2
                move.w  #bytesToWcnt($20),d0

S3SphereTest_CopyFourRingPal16Words:
                move.w  (a1)+,(a2)+
                dbf     d0,S3SphereTest_CopyFourRingPal16Words
                moveq   #PLCID_09,d0
                jsr     (Load_PLC).l
                bra.w   Obj_SphereTest_Main

; =============== S U B R O U T I N E =======================================

; Set up the sprite and store its projection center. The caller sets the 3D position and handler
S3SphereTest_InitFourRingPoint:
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
; End of function S3SphereTest_InitFourRingPoint

; =============== S U B R O U T I N E =======================================

SphereTestS3SkipQuarterTurnSamples:
                cmpi.w  #$40,d2
                bne.s   S3SphereTest_SkipNegYQuarterPhase
                addi.w  #$10,d2

S3SphereTest_SkipNegYQuarterPhase:
                cmpi.w  #$C0,d2
                bne.s   S3SphereTest_QuarterPhaseReturn
                addi.w  #$10,d2

S3SphereTest_QuarterPhaseReturn:
                rts
; End of function SphereTestS3SkipQuarterTurnSamples

; ---------------------------------------------------------------------------

S3SphereTest_BeginThreeOrthogonalRings:
                moveq   #0,d2
                moveq   #$10-1,d3
                tst.w   (Sphere_test_address).w
                bne.s   S3SphereTest_SetThreeRingPointHandler
                move.w  a0,(Sphere_test_address).w
                move.w  #0,(_unkE412).w
                move.w  #0,(_unkE414).w
                move.w  #$200,(_unkE416).w
                move.w  #0,(SStage_scalar_index_0).w
                move.w  #0,(SStage_scalar_index_1).w
                move.w  #0,(SStage_scalar_index_2).w
                bra.s   S3SphereTest_InitZeroZRingPoint
; ---------------------------------------------------------------------------

S3SphereTest_AllocZeroZRingPoint:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SphereTest_FinishThreeRings

; An existing owner or a newly allocated child runs only the point handler
S3SphereTest_SetThreeRingPointHandler:
                move.l  #Obj_EosianSphere,(a1)

S3SphereTest_InitZeroZRingPoint:
                bsr.w   S3SphereTest_InitThreeRingPoint
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
                dbf     d3,S3SphereTest_AllocZeroZRingPoint
                moveq   #0,d2
                moveq   #$10-1,d3

S3SphereTest_AllocZeroXRingPoint:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SphereTest_FinishThreeRings
                move.l  #Obj_EosianSphere,(a1)
                bsr.w   S3SphereTest_InitThreeRingPoint
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
                dbf     d3,S3SphereTest_AllocZeroXRingPoint
                moveq   #0,d2
                moveq   #$10-1,d3

S3SphereTest_AllocZeroYRingPoint:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SphereTest_FinishThreeRings
                move.l  #Obj_EosianSphere,(a1)
                bsr.w   S3SphereTest_InitThreeRingPoint
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
                dbf     d3,S3SphereTest_AllocZeroYRingPoint

; Load the palette and request art even if allocation produced only part of the rings
S3SphereTest_FinishThreeRings:
                lea     (Pal_SphereTest).l,a1
                lea     (Normal_palette_line_2).w,a2
                move.w  #bytesToWcnt($20),d0

S3SphereTest_CopyThreeRingPal16Words:
                move.w  (a1)+,(a2)+
                dbf     d0,S3SphereTest_CopyThreeRingPal16Words
                moveq   #PLCID_09,d0
                jsr     (Load_PLC).l
                bra.w   Obj_SphereTest_Main

; =============== S U B R O U T I N E =======================================

; Set up the sprite and store its projection center. The caller sets the 3D position and handler
S3SphereTest_InitThreeRingPoint:
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
; End of function S3SphereTest_InitThreeRingPoint

; ---------------------------------------------------------------------------
Pal_SphereTest:
                binclude "data/General/Special Stage/Palettes/Eosian Spheres.bin"
                even
; ---------------------------------------------------------------------------

Obj_SphereTest_Main:
                move.b  (Ctrl_2).w,d1
                btst    #button_A,d1
                beq.s   S3SphereTest_ReduceDepthOnHeldC
                cmpi.w  #$800,(_unkE416).w
                bcc.s   S3SphereTest_ReduceDepthOnHeldC
                addq.w  #8,(_unkE416).w

S3SphereTest_ReduceDepthOnHeldC:
                btst    #button_C,d1
                beq.s   S3SphereTest_SelectAngleControls
                cmpi.w  #$81,(_unkE416).w
                bcs.s   S3SphereTest_SelectAngleControls
                subq.w  #8,(_unkE416).w

; Holding Up, Right or B freezes the corresponding automatic angle
S3SphereTest_SelectAngleControls:
                tst.w   $3E(a0)
                bne.s   S3SphereTest_ManualAngle0OnUp
                btst    #button_up,d1
                bne.s   S3SphereTest_AutoAngle1UnlessRight
                addq.w  #3,(SStage_scalar_index_0).w

S3SphereTest_AutoAngle1UnlessRight:
                btst    #button_right,d1
                bne.s   S3SphereTest_AutoAngle2UnlessB
                addq.w  #2,(SStage_scalar_index_1).w

S3SphereTest_AutoAngle2UnlessB:
                btst    #button_B,d1
                bne.s   S3SphereTest_AfterAutoAngles
                addq.w  #1,(SStage_scalar_index_2).w

S3SphereTest_AfterAutoAngles:
                bra.s   S3SphereTest_ToggleModeOnStartPress
; ---------------------------------------------------------------------------

S3SphereTest_ManualAngle0OnUp:
                btst    #button_up,d1
                beq.s   S3SphereTest_ManualAngle1OnRight
                subq.w  #1,(SStage_scalar_index_0).w

S3SphereTest_ManualAngle1OnRight:
                btst    #button_right,d1
                beq.s   S3SphereTest_ManualAngle2OnB
                addq.w  #1,(SStage_scalar_index_1).w

S3SphereTest_ManualAngle2OnB:
                btst    #button_B,d1
                beq.s   S3SphereTest_ToggleModeOnStartPress
                addq.w  #1,(SStage_scalar_index_2).w

; Reset all three angles when Start toggles the control mode
S3SphereTest_ToggleModeOnStartPress:
                btst    #button_start,(Ctrl_2_pressed).w
                beq.s   S3SphereTest_IncreaseYUnlessDown
                eori.w  #-1,$3E(a0)
                move.w  #0,(SStage_scalar_index_0).w
                move.w  #0,(SStage_scalar_index_1).w
                move.w  #0,(SStage_scalar_index_2).w

S3SphereTest_IncreaseYUnlessDown:
                btst    #button_down,d1
                bne.s   S3SphereTest_DecreaseYUnlessLeft
                addq.w  #8,(_unkE414).w

S3SphereTest_DecreaseYUnlessLeft:
                btst    #button_left,d1
                bne.s   S3SphereTest_BuildScalarsAndProject
                subq.w  #8,(_unkE414).w

S3SphereTest_BuildScalarsAndProject:
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
                bhi.w   S3SphereTest_ReleaseRespawnAndCull
                bra.s   S3SphereTest_RotateAndProjectPoint
; ---------------------------------------------------------------------------

; The cull uses the previous projected X before this frame updates the point
S3SphereTest_ReleaseRespawnAndCull:
                move.w  respawn_addr(a0),d0
                beq.s   S3SphereTest_ClearOwnerIfSameObject
                movea.w d0,a2
                bclr    #7,(a2)

; Compare A0 against the sign-extended owner word
S3SphereTest_ClearOwnerIfSameObject:
                cmpa.w  (Sphere_test_address).w,a0
                bne.s   S3SphereTest_DeleteCulledPoint
                move.w  #0,(Sphere_test_address).w

S3SphereTest_DeleteCulledPoint:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

; Reject depths below $80 before perspective division, then use depth to select a sprite frame
S3SphereTest_RotateAndProjectPoint:
                movea.l $3A(a0),a6
                move.w  $34(a0),d1
                move.w  $36(a0),d2
                move.w  $38(a0),d0
                bsr.w   SphereTestS3RotateYZUsingScalarPair0
                bsr.w   SphereTestS3RotateXZUsingScalarPair1
                add.w   (_unkE416).w,d0
                cmpi.w  #$80,d0
                blt.s   S3SphereTest_ProjectionReturn
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
                bcs.s   S3SphereTest_StoreDepthFrameAndPriority
                move.w  #$F,d0

S3SphereTest_StoreDepthFrameAndPriority:
                move.b  d0,mapping_frame(a0)
                lsl.w   #6,d0
                andi.w  #$380,d0
                move.w  d0,priority(a0)
                jsr     (Draw_Sprite).l

S3SphereTest_ProjectionReturn:
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
