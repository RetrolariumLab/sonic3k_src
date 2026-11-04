; Owner: objects/ending/sk
; Responsibility: Ending Master Emerald actor state, movement and scene transitions
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EndingMasterEmerald_DispatchStateAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  EndingMasterEmerald_StateOffsets(pc,d0.w),d1
                jsr     EndingMasterEmerald_StateOffsets(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
EndingMasterEmerald_StateOffsets:
                dc.w    EndEmerald_InitMasterEmeraldAndOutcome-EndingMasterEmerald_StateOffsets
                dc.w    EndEmerald_WaitForBoardingSignal-EndingMasterEmerald_StateOffsets
                dc.w    EndEmerald_DriftUntilCarrierReady-EndingMasterEmerald_StateOffsets
                dc.w    EndEmerald_FollowCarrierAndCheckExit-EndingMasterEmerald_StateOffsets
                dc.w    EndEmerald_WaitBeforeMissingOutcomeExit-EndingMasterEmerald_StateOffsets
                dc.w    EndingMasterEmerald_RiseUntilTopCutoff-EndingMasterEmerald_StateOffsets
; ---------------------------------------------------------------------------

EndEmerald_InitMasterEmeraldAndOutcome:
                move.b  #2,routine(a0)
                move.l  #Map_SSZMasterEmerald,mappings(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #2,mapping_frame(a0)
                tst.b   subtype(a0)
                bne.s   EndEmerald_SetAlternateAppearance
                move.w  #make_art_tile(ArtTile_Ending_MasterEmerald,2,1),art_tile(a0)
                move.w  #$280,priority(a0)
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                bpl.s   EndEmerald_MasterEmeraldInitReturn
                move.b  #8,routine(a0)
                move.w  #(2*60)-1,$2E(a0)

EndEmerald_MasterEmeraldInitReturn:
                rts
; ---------------------------------------------------------------------------

EndEmerald_SetAlternateAppearance:
                move.w  #make_art_tile(ArtTile_Ending_MasterEmerald,1,0),art_tile(a0)
                move.w  #$300,priority(a0)
                rts
; ---------------------------------------------------------------------------

EndEmerald_WaitForBoardingSignal:
                btst    #0,(SceneSyncFlagsOrMHZState).w
                bne.s   EndingMasterEmerald_BeginLeftDownDrift
                rts
; ---------------------------------------------------------------------------

EndingMasterEmerald_BeginLeftDownDrift:
                move.b  #4,routine(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #$100,y_vel(a0)

EndEmerald_DriftUntilCarrierReady:
                move.w  (SceneControllerObjectAddress).w,d0
                bne.s   EndEmerald_AttachToCarrier
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

EndEmerald_AttachToCarrier:
                move.b  #6,routine(a0)
                move.w  d0,parent3(a0)
                move.b  #-$20,child_dx(a0)
                move.b  #1,child_dy(a0)

EndEmerald_FollowCarrierAndCheckExit:
                jsr     (Refresh_ChildPosition).l
                cmpi.w  #$50,x_pos(a0)
                bls.s   EndEmerald_DeleteMasterEmerald
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   EndEmerald_DeleteMasterEmerald
                rts
; ---------------------------------------------------------------------------

EndEmerald_DeleteMasterEmerald:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

EndEmerald_WaitBeforeMissingOutcomeExit:
                subq.w  #1,$2E(a0)
                bpl.s   EndingMasterEmerald_ReturnFromExitDelay
                move.b  #$A,routine(a0)
                move.w  #-$80,y_vel(a0)

EndingMasterEmerald_ReturnFromExitDelay:
                rts
; ---------------------------------------------------------------------------

EndingMasterEmerald_RiseUntilTopCutoff:
                jsr     (MoveSprite2).l
                cmpi.w  #$40,y_pos(a0)
                blo.s   EndEmerald_DeleteMasterEmerald
                rts
; ---------------------------------------------------------------------------

EndEmerald_CycleAllSuperAccent:
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                beq.s   EndEmerald_AccentPaletteUpdateReturn
                bmi.s   EndEmerald_AccentPaletteUpdateReturn
                move.b  (EmeraldPresentationEnableAndPaletteRoute).w,d0
                beq.s   EndEmerald_AccentPaletteUpdateReturn
                lea     (SSZMasterEmeraldColorCycle_IndexedScript).l,a1
                lea     (Normal_palette_line_3+$1C).w,a2
                tst.b   d0
                bpl.s   EndEmerald_RunOutcomePaletteScript
                lea     (Normal_palette_line_2+$1C).w,a2

EndEmerald_RunOutcomePaletteScript:
                jsr     (Run_PalRotationScript2).l

EndEmerald_AccentPaletteUpdateReturn:
                rts
; ---------------------------------------------------------------------------

EndEmerald_InitCarrierPlaneExtension:
                lea     EndData_EmeraldCarrierAttrs(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.l  #EndEmerald_CarrierWaitForDeparture,(a0)
                rts
; ---------------------------------------------------------------------------

EndEmerald_CarrierWaitForDeparture:
                btst    #1,(SceneSyncFlagsOrMHZState).w
                beq.s   EndEmerald_FollowParentBeforeDeparture
                move.l  #EndEmerald_ShiftCarrierAndPublishHandle,(a0)

EndEmerald_FollowParentBeforeDeparture:
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

EndEmerald_ShiftCarrierAndPublishHandle:
                move.b  child_dx(a0),d0
                subq.b  #2,d0
                move.b  d0,child_dx(a0)
                cmpi.b  #-$74,d0
                bgt.s   EndEmerald_RefreshShiftedCarrier
                move.l  #EndEmerald_FollowUntilCarrierCutoff,(a0)
                move.w  a0,(SceneControllerObjectAddress).w

EndEmerald_RefreshShiftedCarrier:
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

EndEmerald_FollowUntilCarrierCutoff:
                jsr     (Refresh_ChildPosition).l
                cmpi.w  #$50,x_pos(a0)
                bls.w   EndingChild_DeleteCurrentActor
                jmp     (Child_Draw_Sprite).l
