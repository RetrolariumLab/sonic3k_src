; Owner: objects/interface/s3
; Responsibility: Special-stage results object dispatch, score tally, presentation choreography and result object allocation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SpecialStage_Results:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SpecialStage_Results_Index(pc,d0.w),d1
                jmp     SpecialStage_Results_Index(pc,d1.w)
; ---------------------------------------------------------------------------
SpecialStage_Results_Index:
                dc.w    S3SSResults_Prepare19FixedElements-SpecialStage_Results_Index
                dc.w    S3SSResults_TickWaitAndPlayClearAt289-SpecialStage_Results_Index
                dc.w    S3SSResults_WaitBeforeContinue-SpecialStage_Results_Index
                dc.w    S3SSResults_WaitBeforeFullSetCheck-SpecialStage_Results_Index
                dc.w    S3SSResults_WaitForFiveWidgetExits-SpecialStage_Results_Index
                dc.w    S3SSResults_TickFinalMessageHold-SpecialStage_Results_Index
; ---------------------------------------------------------------------------

S3SSResults_Prepare19FixedElements:
                lea     next_object(a0),a1
                lea     S3SSResults_InitialElementRecords(pc),a2
                moveq   #$13-1,d1

S3SSResults_SeedElementsAndInitBonuses:
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
                dbf     d1,S3SSResults_SeedElementsAndInitBonuses
                move.w  (Special_stage_ring_count).w,d0
                mulu.w  #10,d0
                move.w  d0,(Ring_bonus_countdown).w
                clr.w   (Time_bonus_countdown).w
                tst.w   (Special_stage_rings_left).w
                bne.s   S3SSResults_StartSixSecondTallyWait
                move.w  #5000,(Time_bonus_countdown).w

S3SSResults_StartSixSecondTallyWait:
                move.w  #6*60,$2E(a0)
                addq.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3SSResults_TickWaitAndPlayClearAt289:
                tst.w   $2E(a0)
                beq.s   S3SSResults_StartTallyWithPerfectBonus
                subq.w  #1,$2E(a0)
                cmpi.w  #289,$2E(a0)
                bne.s   S3SSResults_TallyUpdateReturn
                moveq   #signextendB(mus_GotThroughAct),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

S3SSResults_StartTallyWithPerfectBonus:
                moveq   #0,d0
                tst.w   (Time_bonus_countdown).w
                beq.s   S3SSResults_AddRingBonusToTally
                addi.w  #10,d0
                subi.w  #10,(Time_bonus_countdown).w

S3SSResults_AddRingBonusToTally:
                tst.w   (Ring_bonus_countdown).w
                beq.s   S3SSResults_AwardTallyOrBeginEndWait
                addi.w  #10,d0
                subi.w  #10,(Ring_bonus_countdown).w

S3SSResults_AwardTallyOrBeginEndWait:
                tst.w   d0
                beq.s   S3SSResults_PlayTallyEndAndStartWait
                jsr     (HUD_AddToScore).l
                move.w  (Level_frame_counter).w,d0
                andi.w  #3,d0
                bne.s   S3SSResults_TallyUpdateReturn
                moveq   #signextendB(sfx_Switch),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

S3SSResults_TallyUpdateReturn:
                rts
; ---------------------------------------------------------------------------

S3SSResults_PlayTallyEndAndStartWait:
                moveq   #signextendB(sfx_Register),d0
                jsr     (Play_SFX).l
                move.w  #2*60,$2E(a0)
                addq.b  #2,routine(a0)

S3SSResults_WaitBeforeContinue:
                tst.w   $2E(a0)
                beq.s   S3SSResults_TryContinueAt50Rings
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

S3SSResults_TryContinueAt50Rings:
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.s   S3SSResults_AdvanceAfterContinueGate
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3SSResults_AdvanceAfterContinueGate
                move.l  #S3SSResults_InitContinueMapAndFrame,(a1)
                move.w  #270,$2E(a0)
                moveq   #signextendB(sfx_Continue),d0
                jsr     (Play_SFX).l

S3SSResults_AdvanceAfterContinueGate:
                addq.b  #2,routine(a0)

S3SSResults_WaitBeforeFullSetCheck:
                tst.w   $2E(a0)
                beq.s   S3SSResults_CheckSonicClearAndFullSet
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

S3SSResults_CheckSonicClearAndFullSet:
                cmpi.w  #1,(Player_mode).w
                bhi.s   S3SSResults_ExitWithoutExtraMessage
                tst.w   (Special_stage_spheres_left).w
                bne.s   S3SSResults_ExitWithoutExtraMessage
                cmpi.b  #7,(Chaos_emerald_count+1).w
                blo.s   S3SSResults_ExitWithoutExtraMessage
                lea     (Dynamic_object_RAM+(object_size*16)).w,a1
                moveq   #5-1,d0

S3SSResults_InstallFiveWidgetExits:
                move.l  #S3SSResults_TickWidgetExitDelay,(a1)
                lea     next_object(a1),a1
                dbf     d0,S3SSResults_InstallFiveWidgetExits
                move.w  #4,(Dynamic_object_RAM+(object_size*18)+objoff_2E).w
                move.w  #4,(Dynamic_object_RAM+(object_size*20)+objoff_2E).w
                move.w  #5,$30(a0)
                addq.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3SSResults_ExitWithoutExtraMessage:
                move.b  #GameMode_Level,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

S3SSResults_WaitForFiveWidgetExits:
                tst.w   $30(a0)
                bne.s   S3SSResults_FinalReseedReturn
                lea     (Dynamic_object_RAM+(object_size*16)).w,a1
                lea     S3SSResults_PostCollectionMessageRecords(pc),a2
                moveq   #5-1,d1

S3SSResults_SeedFiveFinalMessageWidgets:
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
                dbf     d1,S3SSResults_SeedFiveFinalMessageWidgets
                move.w  #4*60,$2E(a0)
                addq.b  #2,routine(a0)

S3SSResults_FinalReseedReturn:
                rts
; ---------------------------------------------------------------------------

S3SSResults_TickFinalMessageHold:
                tst.w   $2E(a0)
                beq.s   S3SSResults_ReturnToLevelAfterMessage
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

S3SSResults_ReturnToLevelAfterMessage:
                move.b  #GameMode_Level,(Game_mode).w
                rts
