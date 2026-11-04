; Owner: game/modes/sk
; Responsibility: Save-slot selector, empty and populated slot displays, level icons and child sprite setup
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_SaveScreen_Selector:
                move.w  #$A8,d0
                moveq   #0,d1
                moveq   #0,d2
                move.b  (Dataselect_entry).w,d2
                subq.w  #1,d2
                bcs.s   SKSaveSlot_SetInitialCursorAndScroll

SKSaveSlot_Begin13CursorSubsteps:
                moveq   #$D-1,d4

SKSaveSlot_AdvancePreselectedCursor:
                addq.w  #8,d0
                cmpi.w  #$120,d0
                bls.s   SKSaveSlot_RepeatInitialCursorSteps
                subq.w  #8,d0
                addq.w  #8,d1
                cmpi.w  #$2C0,d1
                bls.s   SKSaveSlot_RepeatInitialCursorSteps
                subq.w  #8,d1
                addq.w  #8,d0

SKSaveSlot_RepeatInitialCursorSteps:
                dbf     d4,SKSaveSlot_AdvancePreselectedCursor
                dbf     d2,SKSaveSlot_Begin13CursorSubsteps

SKSaveSlot_SetInitialCursorAndScroll:
                move.w  d0,$12(a0)
                move.w  d1,(Camera_X_pos_copy).w
                neg.w   d1
                move.w  d1,(H_scroll_buffer+2).w
                move.l  #SKSaveSlot_CheckTitleExitOnB,(a0)

SKSaveSlot_CheckTitleExitOnB:
                tst.w   (Events_bg+$12).w
                bne.s   SKSaveSlot_GateSelectorInput
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKSaveSlot_GateSelectorInput
                move.b  #GameMode_TitleScreen,(Game_mode).w
                bra.w   SKSaveSlot_SelectEndpointCursorOffset
; ---------------------------------------------------------------------------

SKSaveSlot_GateSelectorInput:
                tst.w   (Events_bg+$10).w
                bne.w   SKSaveSlot_SelectEndpointCursorOffset
                tst.w   $30(a0)
                bne.s   SKSaveSlot_StepRightThroughScroll
                moveq   #0,d0
                btst    #button_left,(Ctrl_1_pressed).w
                beq.s   SKSaveSlot_IncrementChoiceWithinBounds
                tst.w   (Events_bg+$12).w
                beq.s   SKSaveSlot_DecrementChoiceAndSelectSound
                cmpi.b  #1,(Dataselect_entry).w
                beq.s   SKSaveSlot_IncrementChoiceWithinBounds

SKSaveSlot_DecrementChoiceAndSelectSound:
                tst.b   (Dataselect_entry).w
                beq.s   SKSaveSlot_IncrementChoiceWithinBounds
                subq.b  #1,(Dataselect_entry).w
                moveq   #signextendB(sfx_SlotMachine),d0
                tst.w   (Events_bg+$12).w
                beq.s   SKSaveSlot_PlayLeftSoundAndSetStep
                moveq   #signextendB(sfx_SmallBumpers),d0

SKSaveSlot_PlayLeftSoundAndSetStep:
                jsr     (Play_SFX).l
                moveq   #-8,d0

SKSaveSlot_IncrementChoiceWithinBounds:
                btst    #button_right,(Ctrl_1_pressed).w
                beq.s   SKSaveSlot_Start13StepCursorMove
                cmpi.b  #9,(Dataselect_entry).w
                beq.s   SKSaveSlot_Start13StepCursorMove
                addq.b  #1,(Dataselect_entry).w
                moveq   #signextendB(sfx_SlotMachine),d0
                tst.w   (Events_bg+$12).w
                beq.s   SKSaveSlot_PlayRightSoundAndSetStep
                moveq   #signextendB(sfx_SmallBumpers),d0

SKSaveSlot_PlayRightSoundAndSetStep:
                jsr     (Play_SFX).l
                moveq   #8,d0

SKSaveSlot_Start13StepCursorMove:
                move.w  d0,$2E(a0)
                beq.s   SKSaveSlot_DrawSelectorWithoutStep
                move.w  #$D,$30(a0)
                bra.s   SKSaveSlot_StepRightThroughScroll
; ---------------------------------------------------------------------------

SKSaveSlot_DrawSelectorWithoutStep:
                bra.s   SKSaveSlot_SelectEndpointCursorOffset
; ---------------------------------------------------------------------------

SKSaveSlot_StepRightThroughScroll:
                move.w  $12(a0),d0
                move.w  (Camera_X_pos_copy).w,d1
                move.w  $2E(a0),d2
                bmi.s   SKSaveSlot_StepLeftThroughScroll
                add.w   d2,d0
                cmpi.w  #$120,d0
                bls.s   SKSaveSlot_StoreMoveAndTickRemaining
                sub.w   d2,d0
                add.w   d2,d1
                cmpi.w  #$2C0,d1
                bls.s   SKSaveSlot_StoreMoveAndTickRemaining
                sub.w   d2,d1
                add.w   d2,d0
                bra.s   SKSaveSlot_StoreMoveAndTickRemaining
; ---------------------------------------------------------------------------

SKSaveSlot_StepLeftThroughScroll:
                add.w   d2,d0
                cmpi.w  #$120,d0
                bhs.s   SKSaveSlot_StoreMoveAndTickRemaining
                sub.w   d2,d0
                add.w   d2,d1
                bpl.s   SKSaveSlot_StoreMoveAndTickRemaining
                sub.w   d2,d1
                add.w   d2,d0

SKSaveSlot_StoreMoveAndTickRemaining:
                move.w  d0,$12(a0)
                move.w  d1,(Camera_X_pos_copy).w
                subq.w  #1,$30(a0)

SKSaveSlot_SelectEndpointCursorOffset:
                moveq   #8,d2
                move.b  (Dataselect_entry).w,d1
                beq.s   SKSaveSlot_PositionCursorAndSelectFrame
                neg.w   d2
                cmpi.b  #9,d1
                beq.s   SKSaveSlot_PositionCursorAndSelectFrame
                moveq   #0,d2

SKSaveSlot_PositionCursorAndSelectFrame:
                add.w   $12(a0),d2
                move.w  d2,x_pos(a0)
                moveq   #2,d0
                cmpi.w  #$F0,d2
                blo.s   SKSaveSlot_StoreCursorFrameAndBlink
                cmpi.w  #$148,d2
                bhi.s   SKSaveSlot_StoreCursorFrameAndBlink
                moveq   #1,d0

SKSaveSlot_StoreCursorFrameAndBlink:
                move.b  d0,mapping_frame(a0)
                btst    #2,(Level_frame_counter+1).w
                beq.s   SKSaveSlot_InvisibleCursorReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSaveSlot_InvisibleCursorReturn:
                rts
; ---------------------------------------------------------------------------

Obj_SaveScreen_NoSave_Slot:
                move.b  #$F,sub2_mapframe(a0)
                move.w  (Dataselect_nosave_player).w,d0
                addq.w  #4,d0
                move.b  d0,mapping_frame(a0)
                tst.b   (Dataselect_entry).w
                bne.s   SKSaveSlot_ClearNoSaveChildCount
                move.w  (Player_2+object_control).w,d0
                or.w    (Events_bg+$12).w,d0
                bne.s   SKSaveSlot_ClearNoSaveChildCount
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.s   SKSaveSlot_CycleNoSaveChoiceAndBlink
                move.b  #GameMode_Level,(Game_mode).w
                move.w  (Dataselect_nosave_player).w,(Player_option).w
                clr.w   (Current_zone_and_act).w
                clr.w   (Apparent_zone_and_act).w
                clr.w   (Current_special_stage).w
                clr.w   (Emerald_counts).w
                clr.l   (Collected_emeralds_array).w
                clr.w   (Collected_emeralds_array+4).w
                clr.b   (Collected_emeralds_array+6).w
                clr.l   (Collected_special_ring_array).w
                clr.b   (Emeralds_converted_flag).w
                clr.l   (Save_pointer).w
                jsr     (Set_Lives_and_Continues).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSaveSlot_CycleNoSaveChoiceAndBlink:
                move.w  (Dataselect_nosave_player).w,d0
                jsr     SKSave_TryCycleNewGameCharacter(pc)
                move.w  d0,(Dataselect_nosave_player).w
                addq.w  #4,d0
                move.b  d0,mapping_frame(a0)
                move.w  #1,mainspr_childsprites(a0)
                btst    #4,(Level_frame_counter+1).w
                bne.s   SKSaveSlot_DrawNoSaveChildren

SKSaveSlot_ClearNoSaveChildCount:
                clr.w   mainspr_childsprites(a0)

SKSaveSlot_DrawNoSaveChildren:
                bra.w   Set_ChildSprites
; ---------------------------------------------------------------------------

Obj_SaveScreen_Save_Slot:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKSaveSlot_BindTenByteSaveRecord
                move.l  #Obj_SaveScreen_Emeralds,(a1)
                move.w  a0,parent2(a1)

SKSaveSlot_BindTenByteSaveRecord:
                moveq   #0,d0
                move.b  $2E(a0),d0
                mulu.w  #$A,d0
                addi.l  #Saved_data,d0
                move.l  d0,$30(a0)
                movea.l d0,a1
                move.b  2(a1),d0
                lsr.b   #4,d0
                move.b  d0,$35(a0)
                move.b  3(a1),d0
                move.b  d0,$37(a0)
                move.b  d0,$3A(a0)
                move.b  (a1),d0
                andi.b  #3,d0
                move.b  d0,$3B(a0)
                move.w  6(a1),d0
                lea     (Collected_emeralds_array).w,a2
                jsr     SKSave_DecodeEmeraldStates(pc)
                move.b  d1,$3C(a0)
                move.b  d2,$3D(a0)
                tst.b   9(a1)
                bne.s   SKSaveSlot_CacheLivesAndContinues
                cmpi.b  #3,8(a1)
                bhs.s   SKSaveSlot_CacheLivesAndContinues
                move.b  #3,8(a1)
                move.l  a1,-(sp)
                st      (SRAM_mask_interrupts_flag).w
                jsr     Write_SaveGame(pc)
                movea.l (sp)+,a1

SKSaveSlot_CacheLivesAndContinues:
                move.b  8(a1),$3E(a0)
                move.b  9(a1),$3F(a0)
                move.l  #SKSaveSlot_RefreshSlotAndCheckSelection,(a0)

SKSaveSlot_RefreshSlotAndCheckSelection:
                clr.w   mainspr_childsprites(a0)
                movea.l $30(a0),a1
                move.b  (Dataselect_entry).w,d0
                subq.b  #1,d0
                cmp.b   $2E(a0),d0
                beq.s   Load_Level_Icons
                move.b  3(a1),$37(a0)
                clr.w   $38(a0)

SKSaveSlot_DrawCharacterChildFrame:
                move.w  $34(a0),d0
                addq.w  #4,d0
                move.b  d0,mapping_frame(a0)
                bra.w   Set_ChildSprites
; ---------------------------------------------------------------------------

Load_Level_Icons:
                tst.b   (a1)
                bmi.w   SKSaveSlot_ConfirmOrEditEmptySlot
                move.w  $36(a0),d1
                jsr     Load_Icon_Art(pc)
                move.b  #$17,sub3_mapframe(a0)
                move.w  $36(a0),d1
                cmp.b   $3A(a0),d1
                bne.s   SKSaveSlot_LatchCompletedProgressChoice
                move.b  $3B(a0),d0
                beq.s   SKSaveSlot_LatchCompletedProgressChoice
                addq.b  #1,sub3_mapframe(a0)
                cmpi.b  #1,d0
                beq.s   SKSaveSlot_UseTailsOrKnucklesFinishCard
                addq.b  #1,sub3_mapframe(a0)
                cmpi.b  #2,d0
                beq.s   SKSaveSlot_UseTailsOrKnucklesFinishCard
                addq.b  #2,sub3_mapframe(a0)
                bra.s   SKSaveSlot_LatchCompletedProgressChoice
; ---------------------------------------------------------------------------

SKSaveSlot_UseTailsOrKnucklesFinishCard:
                cmpi.w  #1,$34(a0)
                bls.s   SKSaveSlot_LatchCompletedProgressChoice
                move.b  #$23,sub3_mapframe(a0)

SKSaveSlot_LatchCompletedProgressChoice:
                tst.w   $38(a0)
                bne.s   SKSaveSlot_GateProgressSelectionInput
                tst.b   $3B(a0)
                beq.w   SKSaveSlot_CheckUnlatchedProgressDraw
                st      $38(a0)

SKSaveSlot_GateProgressSelectionInput:
                tst.w   (Player_2+object_control).w
                bne.s   SKSaveSlot_DrawCharacterChildFrame
                tst.w   (Events_bg+$12).w
                beq.s   SKSaveSlot_SelectProgressCeiling
                clr.b   sub2_mapframe(a0)
                move.w  #2,mainspr_childsprites(a0)
                bra.w   SKSaveSlot_DrawCharacterChildFrame
; ---------------------------------------------------------------------------

SKSaveSlot_SelectProgressCeiling:
                moveq   #$B,d6
                cmpi.w  #3,$34(a0)
                beq.s   SKSaveSlot_DecrementProgressOrWrap
                moveq   #$C,d6
                cmpi.w  #2,$34(a0)
                beq.s   SKSaveSlot_DecrementProgressOrWrap
                cmpi.b  #2,$3B(a0)
                blo.s   SKSaveSlot_DecrementProgressOrWrap
                moveq   #$D,d6

SKSaveSlot_DecrementProgressOrWrap:
                moveq   #0,d2
                move.w  $36(a0),d1
                move.b  (Ctrl_1_pressed).w,d0
                btst    #button_down,d0
                beq.s   SKSaveSlot_IncrementProgressOrWrap
                moveq   #signextendB(sfx_Switch),d2
                subq.w  #1,d1
                bpl.s   SKSaveSlot_StoreProgressAndBlinkMarker
                move.w  d6,d1
                bra.s   SKSaveSlot_StoreProgressAndBlinkMarker
; ---------------------------------------------------------------------------

SKSaveSlot_IncrementProgressOrWrap:
                btst    #button_up,d0
                beq.s   SKSaveSlot_StoreProgressAndBlinkMarker
                moveq   #signextendB(sfx_Switch),d2
                addq.w  #1,d1
                cmp.w   d6,d1
                bls.s   SKSaveSlot_StoreProgressAndBlinkMarker
                moveq   #0,d1

SKSaveSlot_StoreProgressAndBlinkMarker:
                move.w  d1,$36(a0)
                move.l  d2,d0
                jsr     (Play_SFX).l
                move.b  #$1A,sub2_mapframe(a0)
                btst    #4,(Level_frame_counter+1).w
                beq.s   SKSaveSlot_ClearProgressMarkerFrame
                bra.s   SKSaveSlot_ConfirmProgressBelowSaved
; ---------------------------------------------------------------------------

SKSaveSlot_CheckUnlatchedProgressDraw:
                tst.w   (Player_2+object_control).w
                bne.w   SKSaveSlot_DrawCharacterChildFrame

SKSaveSlot_ClearProgressMarkerFrame:
                clr.b   sub2_mapframe(a0)

SKSaveSlot_ConfirmProgressBelowSaved:
                move.w  #2,mainspr_childsprites(a0)
                tst.w   (Events_bg+$12).w
                bne.w   SKSaveSlot_DrawCharacterChildFrame
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.w   SKSaveSlot_DrawCharacterChildFrame
                move.w  4(a1),(Collected_special_ring_array+2).w
                move.b  3(a1),d0
                tst.b   $3B(a0)
                beq.s   SKSaveSlot_RestoreProgressAndSavedState
                move.w  $36(a0),d0
                cmp.b   $3A(a0),d0
                bhs.w   SKSaveSlot_DrawCharacterChildFrame
                clr.l   (Collected_special_ring_array).w

SKSaveSlot_RestoreProgressAndSavedState:
                jsr     SKSave_MapProgressToZoneAct(pc)
                move.w  d0,(Current_zone_and_act).w
                move.w  d0,(Apparent_zone_and_act).w
                moveq   #0,d0
                move.b  2(a1),d0
                lsr.b   #4,d0
                move.w  d0,(Player_option).w
                move.b  2(a1),d0
                andi.b  #$F,d0
                move.b  d0,(Current_special_stage).w
                move.w  6(a1),d0
                lea     (Collected_emeralds_array).w,a2
                jsr     SKSave_DecodeEmeraldStates(pc)
                move.b  d1,(Chaos_emerald_count).w
                move.b  d2,(Super_emerald_count).w
                move.l  a1,(Save_pointer).w
                jsr     (Set_Lives_and_Continues).l
                move.b  8(a1),d0
                beq.s   SKSaveSlot_ResetLivesAndConsumeContinue
                cmpi.b  #3,d0
                bhs.s   SKSaveSlot_PersistRestoredStatsAndStart
                tst.b   9(a1)
                bne.s   SKSaveSlot_PersistRestoredStatsAndStart

; Clamp the continue count to zero if the subtraction borrows
SKSaveSlot_ResetLivesAndConsumeContinue:
                move.b  #3,8(a1)
                subq.b  #1,9(a1)
                bcc.s   SKSaveSlot_PersistRestoredStatsAndStart
                clr.b   9(a1)

SKSaveSlot_PersistRestoredStatsAndStart:
                move.b  8(a1),(Life_count).w
                move.b  9(a1),(Continue_count).w
                st      (SRAM_mask_interrupts_flag).w
                jsr     Write_SaveGame(pc)
                move.b  #GameMode_Level,(Game_mode).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSaveSlot_ConfirmOrEditEmptySlot:
                move.b  #$F,sub2_mapframe(a0)
                clr.b   sub3_mapframe(a0)
                move.w  (Player_2+object_control).w,d0
                or.w    (Events_bg+$12).w,d0
                bne.w   SKSaveSlot_DrawCharacterChildFrame
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.s   SKSaveSlot_CycleNewFileChoiceAndBlink
                move.b  #GameMode_Level,(Game_mode).w
                clr.l   (a1)
                clr.l   4(a1)
                move.w  #$300,8(a1)
                move.w  $34(a0),d0
                move.w  d0,(Player_option).w
                lsl.b   #4,d0
                move.b  d0,2(a1)
                clr.w   (Current_zone_and_act).w
                clr.w   (Apparent_zone_and_act).w
                clr.w   (Current_special_stage).w
                clr.w   (Emerald_counts).w
                clr.l   (Collected_emeralds_array).w
                clr.w   (Collected_emeralds_array+4).w
                clr.b   (Collected_emeralds_array+6).w
                clr.l   (Collected_special_ring_array).w
                clr.b   (Emeralds_converted_flag).w
                move.l  a1,(Save_pointer).w
                jsr     (Set_Lives_and_Continues).l
                st      (SRAM_mask_interrupts_flag).w
                jsr     Write_SaveGame(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSaveSlot_CycleNewFileChoiceAndBlink:
                move.w  $34(a0),d0
                jsr     SKSave_TryCycleNewGameCharacter(pc)
                move.w  d0,$34(a0)
                addq.w  #4,d0
                move.b  d0,mapping_frame(a0)
                move.w  #1,mainspr_childsprites(a0)
                btst    #4,(Level_frame_counter+1).w
                bne.s   Set_ChildSprites
                clr.w   mainspr_childsprites(a0)

Set_ChildSprites:
                move.w  $12(a0),d0
                sub.w   (Camera_X_pos_copy).w,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a0),d1
                move.w  d0,sub2_x_pos(a0)
                move.w  d1,sub2_y_pos(a0)
                move.w  d0,sub3_x_pos(a0)
                move.w  d1,sub3_y_pos(a0)
                cmpi.b  #$1A,sub2_mapframe(a0)
                bne.s   SKSaveSlot_DrawSlotAndChildren
                subq.w  #8,sub2_y_pos(a0)

SKSaveSlot_DrawSlotAndChildren:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Use fresh Up or Down while cursor motion is idle
SKSave_TryCycleNewGameCharacter:
                moveq   #0,d2
                tst.w   (Player_2+objoff_30).w
                bne.s   SKSaveSlot_PlayCharacterChangeSound
                move.b  (Ctrl_1_pressed).w,d1
                lsr.w   #1,d1
                bcc.s   SKSaveSlot_CycleCharacterBackward
                moveq   #signextendB(sfx_Switch),d2
                addq.w  #1,d0
                cmpi.w  #3,d0
                bls.s   SKSaveSlot_PlayCharacterChangeSound
                moveq   #0,d0
                bra.s   SKSaveSlot_PlayCharacterChangeSound
; ---------------------------------------------------------------------------

SKSaveSlot_CycleCharacterBackward:
                lsr.w   #1,d1
                bcc.s   SKSaveSlot_PlayCharacterChangeSound
                moveq   #signextendB(sfx_Switch),d2
                subq.w  #1,d0
                bpl.s   SKSaveSlot_PlayCharacterChangeSound
                moveq   #3,d0

SKSaveSlot_PlayCharacterChangeSound:
                tst.w   d2
                beq.s   SKSaveSlot_CharacterChoiceReturn
                move.l  d0,-(sp)
                move.l  d2,d0
                jsr     (Play_SFX).l
                move.l  (sp)+,d0

SKSaveSlot_CharacterChoiceReturn:
                rts
; End of function SKSave_TryCycleNewGameCharacter

; ---------------------------------------------------------------------------
