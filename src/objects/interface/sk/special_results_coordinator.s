; Owner: objects/interface/sk
; Responsibility: Special-stage results object dispatch, score tally, presentation choreography and result object allocation
; Source provenance and ranges: config/reconstruction/source_layout.json
SKSSResults_ProjectionCenterXThenY:
                dc.w    $15A0
                dc.w    $1540
                dc.w    $1600
                dc.w    $1500
                dc.w    $1640
                dc.w    $14B0
                dc.w    $1690
                dc.w    $15A0
                dc.w    $368
                dc.w    $3A0
                dc.w    $3A0
                dc.w    $350
                dc.w    $350
                dc.w    $390
                dc.w    $390
                dc.w    $368
; ---------------------------------------------------------------------------

Obj_SpecialStage_Results:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SpecialStage_Results_Index(pc,d0.w),d1
                jmp     SpecialStage_Results_Index(pc,d1.w)
; ---------------------------------------------------------------------------
SpecialStage_Results_Index:
                dc.w    SKSSResults_SeedElementsAndInitBonuses-SpecialStage_Results_Index
                dc.w    SKSSResults_TickWaitAndMaybeFadeHPZ-SpecialStage_Results_Index
                dc.w    SKSSResults_Check50RingsBeforeContinue-SpecialStage_Results_Index
                dc.w    SKSSResults_CheckLockOnHPZPresentation-SpecialStage_Results_Index
                dc.w    SKSSResults_WaitThenSeedSixMessageActors-SpecialStage_Results_Index
                dc.w    SKSSResults_TickFinalMessageHold-SpecialStage_Results_Index
                dc.w    SKSSResults_WaitThenSeedThreeAltActors-SpecialStage_Results_Index
                dc.w    SKSSResults_TickHPZPanDelay-SpecialStage_Results_Index
                dc.w    SKSSResults_CheckSignalAndLatchSound-SpecialStage_Results_Index
                dc.w    SKSSResults_TickHoldBeforeFinalMessage-SpecialStage_Results_Index
; ---------------------------------------------------------------------------

SKSSResults_SeedElementsAndInitBonuses:
                lea     next_object(a0),a1
                lea     SKSSResults_InitialElementRecords(pc),a2
                moveq   #$13-1,d1
                jsr     SpecialResults_InitElementSlots(pc)
                move.w  (Special_stage_ring_count).w,d0
                mulu.w  #10,d0
                move.w  d0,(Ring_bonus_countdown).w
                clr.w   (Time_bonus_countdown).w
                tst.w   (Special_stage_rings_left).w
                bne.s   SKSSResults_StartSixSecondTallyWait
                move.w  #5000,(Time_bonus_countdown).w

SKSSResults_StartSixSecondTallyWait:
                move.w  #6*60,$2E(a0)
                addq.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKSSResults_TickWaitAndMaybeFadeHPZ:
                tst.w   $2E(a0)
                beq.s   SKSSResults_StartTallyWithPerfectBonus
                subq.w  #1,$2E(a0)
                bne.s   SKSSResults_PlayClearMusicAt289
                tst.w   (SK_alone_flag).w
                bne.s   SKSSResults_PlayClearMusicAt289
                tst.b   (SK_special_stage_flag).w
                beq.s   SKSSResults_PlayClearMusicAt289
                tst.w   (Special_stage_spheres_left).w
                bne.s   SKSSResults_PlayClearMusicAt289
                move.w  #$40-1,(Palette_fade_info).w
                move.w  #$16,(Palette_fade_timer).w
                lea     (Normal_palette).w,a1
                move.w  #$EEE,$42(a1)
                move.w  #$EEE,$44(a1)
                move.w  #$EEE,$4C(a1)
                move.w  #$EEE,$62(a1)
                move.w  #$EEE,$66(a1)
                move.w  #$EEE,$6E(a1)
                move.w  #$EEE,$70(a1)
                move.w  #$EEE,$7C(a1)
                move.w  #$EEE,$7E(a1)

SKSSResults_PlayClearMusicAt289:
                cmpi.w  #289,$2E(a0)
                bne.s   SKSSResults_TallyUpdateReturn
                moveq   #signextendB(mus_GotThroughAct),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

SKSSResults_StartTallyWithPerfectBonus:
                moveq   #0,d0
                tst.w   (Time_bonus_countdown).w
                beq.s   SKSSResults_AddRingBonusToTally
                addi.w  #10,d0
                subi.w  #10,(Time_bonus_countdown).w

SKSSResults_AddRingBonusToTally:
                tst.w   (Ring_bonus_countdown).w
                beq.s   SKSSResults_AwardTallyAndMaybePlaySwitch
                addi.w  #10,d0
                subi.w  #10,(Ring_bonus_countdown).w

SKSSResults_AwardTallyAndMaybePlaySwitch:
                tst.w   d0
                beq.s   SKSSResults_StartPostTallyWait
                jsr     (HUD_AddToScore).l
                move.w  (Level_frame_counter).w,d0
                andi.w  #3,d0
                bne.s   SKSSResults_TallyUpdateReturn
                moveq   #signextendB(sfx_Switch),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SKSSResults_TallyUpdateReturn:
                rts
; ---------------------------------------------------------------------------

SKSSResults_StartPostTallyWait:
                moveq   #signextendB(sfx_Register),d0
                jsr     (Play_SFX).l
                move.w  #2*60,$2E(a0)
                addq.b  #2,routine(a0)

SKSSResults_Check50RingsBeforeContinue:
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.s   SKSSResults_AdvanceAfterContinueGate
                tst.w   $2E(a0)
                beq.s   SKSSResults_ClearAndTryContinueActor
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SKSSResults_ClearAndTryContinueActor:
                clr.w   (SStage_results_object_addr).w
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKSSResults_AdvanceAfterContinueGate
                move.w  a1,(SStage_results_object_addr).w
                move.l  #SKSSResults_InitContinueMapAndFrame,(a1)
                move.w  #270,$2E(a0)
                moveq   #signextendB(sfx_Continue),d0
                jsr     (Play_SFX).l

SKSSResults_AdvanceAfterContinueGate:
                addq.b  #2,routine(a0)

SKSSResults_CheckLockOnHPZPresentation:
                tst.w   (SK_alone_flag).w
                bne.s   SKSSResults_TickOrdinaryMessageWait
                tst.b   (SK_special_stage_flag).w
                beq.s   SKSSResults_TickOrdinaryMessageWait
                tst.w   (Special_stage_spheres_left).w
                bne.s   SKSSResults_TickOrdinaryMessageWait
                move.w  #60,$2E(a0)
                move.b  #$E,routine(a0)
                bra.w   SKSSResults_TickHPZPanDelay
; ---------------------------------------------------------------------------

SKSSResults_TickOrdinaryMessageWait:
                tst.w   $2E(a0)
                beq.s   SKSSResults_CheckClearAndSevenChaos
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SKSSResults_CheckClearAndSevenChaos:
                tst.w   (Special_stage_spheres_left).w
                bne.s   SKSSResults_ExitWithoutExtraMessage
                cmpi.b  #7,(Chaos_emerald_count).w
                blo.s   SKSSResults_ExitWithoutExtraMessage
                cmpi.w  #3,(Player_mode).w
                beq.s   SKSSResults_ChooseSonicOrKnuxMessage
                cmpi.w  #1,(Player_mode).w
                bls.s   SKSSResults_ChooseSonicOrKnuxMessage
                cmpi.b  #4,(Special_stage_zone_and_act).w
                beq.s   SKSSResults_SelectAltMessageContinuation
                cmpi.b  #7,(Special_stage_zone_and_act).w
                blo.s   SKSSResults_ExitWithoutExtraMessage
                bra.s   SKSSResults_SelectAltMessageContinuation
; ---------------------------------------------------------------------------

SKSSResults_ChooseSonicOrKnuxMessage:
                tst.w   (SK_alone_flag).w
                bne.s   SKSSResults_PrepareFiveExitsAtSlot44
                cmpi.b  #4,(Special_stage_zone_and_act).w
                beq.s   SKSSResults_SelectAltMessageContinuation
                cmpi.b  #7,(Special_stage_zone_and_act).w
                blo.s   SKSSResults_PrepareFiveExitsAtSlot44

SKSSResults_SelectAltMessageContinuation:
                move.b  #$A,routine(a0)

SKSSResults_PrepareFiveExitsAtSlot44:
                lea     (Dynamic_object_RAM+(object_size*44)).w,a1
                moveq   #4,d0

SKSSResults_InstallFiveWidgetExits:
                move.l  #SKSSResults_TickMessageExitDelay,(a1)
                lea     next_object(a1),a1
                dbf     d0,SKSSResults_InstallFiveWidgetExits
                move.w  #4,(Dynamic_object_RAM+(object_size*46)+objoff_2E).w
                move.w  #4,(Dynamic_object_RAM+(object_size*48)+objoff_2E).w
                move.w  #5,$30(a0)
                addq.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKSSResults_ExitWithoutExtraMessage:
                move.b  #GameMode_Level,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

SKSSResults_WaitThenSeedSixMessageActors:
                tst.w   $30(a0)
                bne.s   SKSSResults_OrdinaryReseedReturn
                lea     (Dynamic_object_RAM+(object_size*44)).w,a1
                lea     SKSSResults_FullSetMessageRecords(pc),a2
                moveq   #6-1,d1
                jsr     SpecialResults_InitElementSlots(pc)
                move.w  #4*60,$2E(a0)
                addq.b  #2,routine(a0)

SKSSResults_OrdinaryReseedReturn:
                rts
; ---------------------------------------------------------------------------

SKSSResults_TickFinalMessageHold:
                tst.w   $2E(a0)
                beq.s   SKSSResults_ReturnToLevelAfterMessage
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SKSSResults_ReturnToLevelAfterMessage:
                move.b  #GameMode_Level,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

SKSSResults_WaitThenSeedThreeAltActors:
                tst.w   $30(a0)
                bne.s   SKSSResults_AlternateReseedReturn
                lea     (Dynamic_object_RAM+(object_size*44)).w,a1
                lea     SKSSResults_AltFullSetMessageRecords(pc),a2
                moveq   #3-1,d1
                jsr     SpecialResults_InitElementSlots(pc)
                move.w  #4*60,$2E(a0)
                move.b  #$A,routine(a0)

SKSSResults_AlternateReseedReturn:
                rts
; ---------------------------------------------------------------------------

SKSSResults_TickHPZPanDelay:
                tst.w   $2E(a0)
                beq.s   SKSSResults_StepCameraYAndCheckAt2A0
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SKSSResults_StepCameraYAndCheckAt2A0:
                move.w  (Camera_Y_pos).w,d0
                cmpi.w  #$320,d0
                bhs.w   SKSSResults_QueueArtAndTryConvergence
                addq.w  #1,d0
                move.w  d0,(Camera_Y_pos).w
                cmpi.w  #$2A0,d0
                bne.w   SKSSResults_ProjectionSetupReturn
                moveq   #4,d0
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.s   SKSSResults_StoreExitCountAndSelect30
                move.w  (SStage_results_object_addr).w,d1
                beq.s   SKSSResults_CountContinueLabelExit
                movea.w d1,a1
                move.l  #SKSSResults_TickContinueExitDelay,(a1)
                move.w  #20,$2E(a1)

; The label contributes even if the separate indicator allocation failed
SKSSResults_CountContinueLabelExit:
                addq.w  #1,d0

SKSSResults_StoreExitCountAndSelect30:
                move.w  d0,$30(a0)
                lea     (Dynamic_object_RAM+(object_size*30)).w,a1

SKSSResults_InstallFirstGroupExits:
                move.l  #SKSSResults_TickMessageExitDelay,(a1)
                lea     next_object(a1),a1
                dbf     d0,SKSSResults_InstallFirstGroupExits
                moveq   #2,d0
                cmpi.b  #7,(Super_emerald_count).w
                blo.s   SKSSResults_AddExitCountAndSelect44
                addq.w  #2,d0

SKSSResults_AddExitCountAndSelect44:
                add.w   d0,$30(a0)
                lea     (Dynamic_object_RAM+(object_size*44)).w,a1

SKSSResults_InstallSecondGroupExits:
                move.l  #SKSSResults_TickMessageExitDelay,(a1)
                lea     next_object(a1),a1
                dbf     d0,SKSSResults_InstallSecondGroupExits
                addq.w  #2,$30(a0)
                lea     (Dynamic_object_RAM+(object_size*30)).w,a1
                move.w  #8,$2E(a1)
                move.w  #12,next_object+$2E(a1)
                move.w  #12,(next_object*2)+$2E(a1)
                move.w  #16,(next_object*3)+$2E(a1)
                move.w  #16,(next_object*4)+$2E(a1)
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.s   SKSSResults_HideDigitListsAndDelayExits
                move.w  #20,(next_object*5)+$2E(a1)

SKSSResults_HideDigitListsAndDelayExits:
                clr.w   (next_object*2)+mainspr_childsprites(a1)
                clr.w   (next_object*4)+mainspr_childsprites(a1)
                lea     (Dynamic_object_RAM+(object_size*44)).w,a1
                move.w  #4,(next_object*2)+$2E(a1)
                cmpi.b  #7,(Super_emerald_count).w
                blo.s   SKSSResults_HPZExitSchedulingReturn
                move.w  #4,(next_object*4)+$2E(a1)

SKSSResults_HPZExitSchedulingReturn:
                bra.s   SKSSResults_ProjectionSetupReturn
; ---------------------------------------------------------------------------

SKSSResults_QueueArtAndTryConvergence:
                move.l  #ArtUnc_Invincibility,d1
                move.w  #tiles_to_bytes(ArtTile_Shield),d2
                move.w  #$200,d3
                jsr     (Add_To_DMA_Queue).l
                jsr     (AllocateObject).l
                bne.s   SKSSResults_WaitForProjectionSignal
                moveq   #0,d1
                moveq   #0,d2
                moveq   #7,d3

SKSSResults_SeedConvergingActors:
                move.l  #SKSSResults_InitOpposedProjectionPair,(a1)
                move.w  d1,$2E(a1)
                move.w  d2,$30(a1)
                move.w  a0,$34(a1)
                addi.w  #$10,d1
                addq.w  #1,d2
                jsr     (CreateNewSprite4).l
                dbne    d3,SKSSResults_SeedConvergingActors

; Enter this state even if the preceding allocation could not seed an actor
SKSSResults_WaitForProjectionSignal:
                move.w  #30,$2E(a0)
                clr.w   $30(a0)
                addq.b  #2,routine(a0)
                moveq   #signextendB(sfx_Signpost),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SKSSResults_ProjectionSetupReturn:
                rts
; ---------------------------------------------------------------------------

; A positive signal triggers the sound once and sets the high byte to $FF
SKSSResults_CheckSignalAndLatchSound:
                tst.w   $30(a0)
                beq.w   SKSSResults_SignalOrCameraHoldReturn
                bmi.s   SKSSResults_SelectReturnOrCenterCamera
                st      $30(a0)
                moveq   #signextendB(sfx_SuperEmerald),d0
                jsr     (Play_SFX).l

SKSSResults_SelectReturnOrCenterCamera:
                cmpi.b  #7,(Super_emerald_count).w
                bhs.s   SKSSResults_TickHoldBeforeCentering
                move.w  #60,$2E(a0)
                move.b  #$A,routine(a0)
                bra.s   SKSSResults_SignalOrCameraHoldReturn
; ---------------------------------------------------------------------------

SKSSResults_TickHoldBeforeCentering:
                tst.w   $2E(a0)
                beq.s   SKSSResults_ChooseCameraXStepTo15A0
                subq.w  #1,$2E(a0)
                bra.s   SKSSResults_SignalOrCameraHoldReturn
; ---------------------------------------------------------------------------

SKSSResults_ChooseCameraXStepTo15A0:
                moveq   #1,d0
                cmpi.w  #$15A0,(Camera_X_pos).w
                beq.s   SKSSResults_TryExpandingProjection
                bcs.s   SKSSResults_ApplyOnePixelCameraXStep
                neg.w   d0

SKSSResults_ApplyOnePixelCameraXStep:
                add.w   d0,(Camera_X_pos).w
                bra.s   SKSSResults_SignalOrCameraHoldReturn
; ---------------------------------------------------------------------------

SKSSResults_TryExpandingProjection:
                jsr     (AllocateObject).l
                bne.s   SKSSResults_StartTwoSecondProjectionHold
                moveq   #0,d1
                moveq   #0,d2
                moveq   #7,d3

SKSSResults_SeedExpandingActors:
                move.l  #SKSSResults_InitOpposedProjectionPair,(a1)
                move.w  d1,$2E(a1)
                move.w  d2,$30(a1)
                move.w  a0,$34(a1)
                st      $36(a1)
                addi.w  #$10,d1
                addq.w  #1,d2
                jsr     (CreateNewSprite4).l
                dbne    d3,SKSSResults_SeedExpandingActors

SKSSResults_StartTwoSecondProjectionHold:
                move.w  #2*60,$2E(a0)
                addq.b  #2,routine(a0)
                moveq   #signextendB(sfx_Signpost),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SKSSResults_SignalOrCameraHoldReturn:
                rts
; ---------------------------------------------------------------------------

SKSSResults_TickHoldBeforeFinalMessage:
                tst.w   $2E(a0)
                beq.s   SKSSResults_SeedSevenFinalWidgets
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SKSSResults_SeedSevenFinalWidgets:
                lea     (Dynamic_object_RAM+(object_size*61)).w,a1
                lea     SKSSResults_FinalHyperMessageRecords(pc),a2
                moveq   #7-1,d1
                jsr     SpecialResults_InitElementSlots(pc)
                move.w  #6*60,$2E(a0)
                move.b  #$A,routine(a0)
                rts

; =============== S U B R O U T I N E =======================================

; Write twelve-byte descriptors directly into the caller's consecutive object slots
SpecialResults_InitElementSlots:
                move.l  (a2)+,(a1)
                move.w  (a2)+,$46(a1)
                move.w  (a2)+,x_pos(a1)
                move.w  (a2)+,y_pos(a1)
                move.b  (a2)+,mapping_frame(a1)
                move.b  (a2)+,width_pixels(a1)
                move.b  #$40,render_flags(a1)
                move.l  #Map_Results,mappings(a1)
                move.w  a0,parent2(a1)
                lea     next_object(a1),a1
                dbf     d1,SpecialResults_InitElementSlots
                rts
; End of function SpecialResults_InitElementSlots
