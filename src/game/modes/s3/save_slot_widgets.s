; Owner: game/modes/s3
; Responsibility: Save-slot selector, empty and populated slot displays, level icons and child sprite setup
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_SaveScreen_Selector:
                move.w  #$A8,d0
                moveq   #0,d1
                moveq   #0,d2
                move.b  (Dataselect_entry).w,d2
                subq.w  #1,d2
                bcs.s   S3SaveSlot_SetInitialCursorAndScroll

S3SaveSlot_Begin13CursorSubsteps:
                moveq   #$D-1,d4

S3SaveSlot_AdvancePreselectedCursor:
                addq.w  #8,d0
                cmpi.w  #$120,d0
                bls.s   S3SaveSlot_RepeatInitialCursorSteps
                subq.w  #8,d0
                addq.w  #8,d1
                cmpi.w  #$1F0,d1
                bls.s   S3SaveSlot_RepeatInitialCursorSteps
                subq.w  #8,d1
                addq.w  #8,d0

S3SaveSlot_RepeatInitialCursorSteps:
                dbf     d4,S3SaveSlot_AdvancePreselectedCursor
                dbf     d2,S3SaveSlot_Begin13CursorSubsteps

S3SaveSlot_SetInitialCursorAndScroll:
                move.w  d0,$12(a0)
                move.w  d1,(Camera_X_pos_copy).w
                neg.w   d1
                move.w  d1,(H_scroll_buffer+2).w
                move.l  #S3SaveSlot_CheckTitleExitOnB,(a0)

S3SaveSlot_CheckTitleExitOnB:
                tst.w   (Events_bg+$12).w
                bne.s   S3SaveSlot_GateSelectorInput
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   S3SaveSlot_GateSelectorInput
                move.b  #GameMode_TitleScreen,(Game_mode).w
                bra.w   S3SaveSlot_SelectEndpointCursorOffset
; ---------------------------------------------------------------------------

S3SaveSlot_GateSelectorInput:
                tst.w   (Events_bg+$10).w
                bne.w   S3SaveSlot_SelectEndpointCursorOffset
                tst.w   $30(a0)
                bne.s   S3SaveSlot_StepRightThroughScroll
                moveq   #0,d0
                btst    #button_left,(Ctrl_1_pressed).w
                beq.s   S3SaveSlot_IncrementChoiceWithinBounds
                tst.w   (Events_bg+$12).w
                beq.s   S3SaveSlot_DecrementChoiceAndSelectSound
                cmpi.b  #1,(Dataselect_entry).w
                beq.s   S3SaveSlot_IncrementChoiceWithinBounds

S3SaveSlot_DecrementChoiceAndSelectSound:
                tst.b   (Dataselect_entry).w
                beq.s   S3SaveSlot_IncrementChoiceWithinBounds
                subq.b  #1,(Dataselect_entry).w
                moveq   #signextendB(sfx_SlotMachine),d0
                tst.w   (Events_bg+$12).w
                beq.s   S3SaveSlot_PlayLeftSoundAndSetStep
                moveq   #signextendB(sfx_SmallBumpers),d0

S3SaveSlot_PlayLeftSoundAndSetStep:
                jsr     (Play_SFX).l
                moveq   #-8,d0

S3SaveSlot_IncrementChoiceWithinBounds:
                btst    #button_right,(Ctrl_1_pressed).w
                beq.s   S3SaveSlot_Start13StepCursorMove
                cmpi.b  #7,(Dataselect_entry).w
                beq.s   S3SaveSlot_Start13StepCursorMove
                addq.b  #1,(Dataselect_entry).w
                moveq   #signextendB(sfx_SlotMachine),d0
                tst.w   (Events_bg+$12).w
                beq.s   S3SaveSlot_PlayRightSoundAndSetStep
                moveq   #signextendB(sfx_SmallBumpers),d0

S3SaveSlot_PlayRightSoundAndSetStep:
                jsr     (Play_SFX).l
                moveq   #8,d0

S3SaveSlot_Start13StepCursorMove:
                move.w  d0,$2E(a0)
                beq.s   S3SaveSlot_DrawSelectorWithoutStep
                move.w  #$D,$30(a0)
                bra.s   S3SaveSlot_StepRightThroughScroll
; ---------------------------------------------------------------------------

S3SaveSlot_DrawSelectorWithoutStep:
                bra.s   S3SaveSlot_SelectEndpointCursorOffset
; ---------------------------------------------------------------------------

S3SaveSlot_StepRightThroughScroll:
                move.w  $12(a0),d0
                move.w  (Camera_X_pos_copy).w,d1
                move.w  $2E(a0),d2
                bmi.s   S3SaveSlot_StepLeftThroughScroll
                add.w   d2,d0
                cmpi.w  #$120,d0
                bls.s   S3SaveSlot_StoreMoveAndTickRemaining
                sub.w   d2,d0
                add.w   d2,d1
                cmpi.w  #$1F0,d1
                bls.s   S3SaveSlot_StoreMoveAndTickRemaining
                sub.w   d2,d1
                add.w   d2,d0
                bra.s   S3SaveSlot_StoreMoveAndTickRemaining
; ---------------------------------------------------------------------------

S3SaveSlot_StepLeftThroughScroll:
                add.w   d2,d0
                cmpi.w  #$120,d0
                bcc.s   S3SaveSlot_StoreMoveAndTickRemaining
                sub.w   d2,d0
                add.w   d2,d1
                bpl.s   S3SaveSlot_StoreMoveAndTickRemaining
                sub.w   d2,d1
                add.w   d2,d0

S3SaveSlot_StoreMoveAndTickRemaining:
                move.w  d0,$12(a0)
                move.w  d1,(Camera_X_pos_copy).w
                subq.w  #1,$30(a0)

S3SaveSlot_SelectEndpointCursorOffset:
                moveq   #8,d2
                move.b  (Dataselect_entry).w,d1
                beq.s   S3SaveSlot_PositionCursorAndSelectFrame
                neg.w   d2
                cmpi.b  #7,d1
                beq.s   S3SaveSlot_PositionCursorAndSelectFrame
                moveq   #0,d2

S3SaveSlot_PositionCursorAndSelectFrame:
                add.w   $12(a0),d2
                move.w  d2,x_pos(a0)
                moveq   #2,d0
                cmpi.w  #$F0,d2
                bcs.s   S3SaveSlot_StoreCursorFrameAndBlink
                cmpi.w  #$148,d2
                bhi.s   S3SaveSlot_StoreCursorFrameAndBlink
                moveq   #1,d0

S3SaveSlot_StoreCursorFrameAndBlink:
                move.b  d0,mapping_frame(a0)
                btst    #2,(Level_frame_counter+1).w
                beq.s   S3SaveSlot_InvisibleCursorReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SaveSlot_InvisibleCursorReturn:
                rts
; ---------------------------------------------------------------------------

Obj_SaveScreen_NoSave_Slot:
                move.b  #$F,sub2_mapframe(a0)
                move.w  (Dataselect_nosave_player).w,d0
                addq.w  #4,d0
                move.b  d0,mapping_frame(a0)
                tst.b   (Dataselect_entry).w
                bne.s   S3SaveSlot_ClearNoSaveChildCount
                move.w  (Player_2+object_control).w,d0
                or.w    (Events_bg+$12).w,d0
                bne.s   S3SaveSlot_ClearNoSaveChildCount
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.s   S3SaveSlot_CycleNoSaveChoiceAndBlink
                move.b  #GameMode_Level,(Game_mode).w
                move.w  (Dataselect_nosave_player).w,(Player_option).w
                clr.w   (Current_zone_and_act).w
                clr.w   (Apparent_zone_and_act).w
                clr.w   (Current_special_stage).w
                clr.w   (Chaos_emerald_count).w
                clr.l   (Collected_emeralds_array).w
                clr.w   (Collected_emeralds_array+4).w
                clr.b   (Collected_emeralds_array+6).w
                clr.l   (Collected_special_ring_array).w
                clr.l   (Save_pointer).w
                jsr     (Set_Lives_and_Continues).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SaveSlot_CycleNoSaveChoiceAndBlink:
                move.w  (Dataselect_nosave_player).w,d0
                jsr     S3Save_TryCycleNewGameCharacter(pc)
                move.w  d0,(Dataselect_nosave_player).w
                addq.w  #4,d0
                move.b  d0,mapping_frame(a0)
                move.w  #1,mainspr_childsprites(a0)
                btst    #4,(Level_frame_counter+1).w
                bne.s   S3SaveSlot_DrawNoSaveChildren

S3SaveSlot_ClearNoSaveChildCount:
                clr.w   mainspr_childsprites(a0)

S3SaveSlot_DrawNoSaveChildren:
                bra.w   Set_ChildSprites
; ---------------------------------------------------------------------------

Obj_SaveScreen_Save_Slot:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3SaveSlot_BindEightByteSaveRecord
                move.l  #Obj_SaveScreen_Emeralds,(a1)
                move.w  a0,parent2(a1)

S3SaveSlot_BindEightByteSaveRecord:
                moveq   #0,d0
                move.b  $2E(a0),d0
                lsl.w   #3,d0
                addi.l  #Saved_data,d0
                move.l  d0,$30(a0)
                movea.l d0,a1
                move.b  2(a1),$35(a0)
                move.b  3(a1),$37(a0)
                move.l  #S3SaveSlot_RefreshSlotAndCheckSelection,(a0)

S3SaveSlot_RefreshSlotAndCheckSelection:
                clr.w   mainspr_childsprites(a0)
                movea.l $30(a0),a1
                move.b  (Dataselect_entry).w,d0
                subq.b  #1,d0
                cmp.b   $2E(a0),d0
                beq.s   Load_Level_Icons
                move.b  3(a1),$37(a0)
                clr.w   $38(a0)

S3SaveSlot_DrawCharacterChildFrame:
                move.w  $34(a0),d0
                addq.w  #4,d0
                move.b  d0,mapping_frame(a0)
                bra.w   Set_ChildSprites
; ---------------------------------------------------------------------------

Load_Level_Icons:
                tst.b   (a1)
                bmi.w   S3SaveSlot_ConfirmOrEditEmptySlot
                move.w  $36(a0),d1
                jsr     Load_Icon_Art(pc)
                move.b  #$17,sub3_mapframe(a0)
                cmpi.w  #6,$36(a0)
                bls.s   S3SaveSlot_LatchCompletedProgressChoice
                addq.b  #1,sub3_mapframe(a0)
                cmpi.b  #7,5(a1)
                bcs.s   S3SaveSlot_LatchCompletedProgressChoice
                addq.b  #1,sub3_mapframe(a0)

S3SaveSlot_LatchCompletedProgressChoice:
                tst.w   $38(a0)
                bne.s   S3SaveSlot_GateProgressSelectionInput
                cmpi.w  #6,$36(a0)
                bls.s   S3SaveSlot_CheckUnlatchedProgressDraw
                st      $38(a0)

S3SaveSlot_GateProgressSelectionInput:
                tst.w   (Player_2+object_control).w
                bne.s   S3SaveSlot_DrawCharacterChildFrame
                tst.w   (Events_bg+$12).w
                beq.s   S3SaveSlot_DecrementProgressOrWrapTo6
                clr.b   sub2_mapframe(a0)
                move.w  #2,mainspr_childsprites(a0)
                bra.s   S3SaveSlot_DrawCharacterChildFrame
; ---------------------------------------------------------------------------

S3SaveSlot_DecrementProgressOrWrapTo6:
                moveq   #0,d2
                move.w  $36(a0),d1
                move.b  (Ctrl_1_pressed).w,d0
                btst    #button_down,d0
                beq.s   S3SaveSlot_IncrementProgressAndSkip4
                moveq   #signextendB(sfx_Switch),d2
                subq.w  #1,d1
                bpl.s   S3SaveSlot_SkipProgress4Backward
                moveq   #6,d1
                bra.s   S3SaveSlot_StoreProgressAndBlinkMarker
; ---------------------------------------------------------------------------

S3SaveSlot_SkipProgress4Backward:
                cmpi.w  #4,d1
                bne.s   S3SaveSlot_StoreProgressAndBlinkMarker
                subq.w  #1,d1
                bra.s   S3SaveSlot_StoreProgressAndBlinkMarker
; ---------------------------------------------------------------------------

S3SaveSlot_IncrementProgressAndSkip4:
                btst    #button_up,d0
                beq.s   S3SaveSlot_StoreProgressAndBlinkMarker
                moveq   #signextendB(sfx_Switch),d2
                addq.w  #1,d1
                cmpi.w  #4,d1
                bne.s   S3SaveSlot_WrapProgressAbove6
                addq.w  #1,d1

S3SaveSlot_WrapProgressAbove6:
                cmpi.w  #6,d1
                bls.s   S3SaveSlot_StoreProgressAndBlinkMarker
                moveq   #0,d1

S3SaveSlot_StoreProgressAndBlinkMarker:
                move.w  d1,$36(a0)
                move.l  d2,d0
                jsr     (Play_SFX).l
                move.b  #$1A,sub2_mapframe(a0)
                btst    #4,(Level_frame_counter+1).w
                beq.s   S3SaveSlot_ClearProgressMarkerFrame
                bra.s   S3SaveSlot_ConfirmSelectedSave
; ---------------------------------------------------------------------------

S3SaveSlot_CheckUnlatchedProgressDraw:
                tst.w   (Player_2+object_control).w
                bne.w   S3SaveSlot_DrawCharacterChildFrame

S3SaveSlot_ClearProgressMarkerFrame:
                clr.b   sub2_mapframe(a0)

S3SaveSlot_ConfirmSelectedSave:
                move.w  #2,mainspr_childsprites(a0)
                tst.w   (Events_bg+$12).w
                bne.w   S3SaveSlot_DrawCharacterChildFrame
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.w   S3SaveSlot_DrawCharacterChildFrame
                move.b  #GameMode_Level,(Game_mode).w
                clr.l   (Collected_special_ring_array).w
                cmpi.b  #6,3(a1)
                bls.s   S3SaveSlot_RestoreRingFlagsAndProgress
                move.w  $36(a0),d0
                cmpi.b  #6,d0
                bls.s   S3SaveSlot_ShiftZoneIndexToHighByte
                move.w  #$601,d0
                move.b  #GameMode_S3Credits,(Game_mode).w
                bra.s   S3SaveSlot_RestoreSavedGameState
; ---------------------------------------------------------------------------

S3SaveSlot_RestoreRingFlagsAndProgress:
                move.b  1(a1),(Collected_special_ring_array+2).w
                move.b  7(a1),(Collected_special_ring_array+3).w
                move.b  3(a1),d0

S3SaveSlot_ShiftZoneIndexToHighByte:
                lsl.w   #8,d0

S3SaveSlot_RestoreSavedGameState:
                move.w  d0,(Current_zone_and_act).w
                move.w  d0,(Apparent_zone_and_act).w
                moveq   #0,d0
                move.b  2(a1),d0
                move.w  d0,(Player_option).w
                move.b  4(a1),(Current_special_stage).w
                moveq   #0,d0
                move.b  5(a1),d0
                move.w  d0,(Chaos_emerald_count).w
                move.b  6(a1),d0
                lea     (Collected_emeralds_array).w,a3
                moveq   #6,d1

S3SaveSlot_ExtractNextSavedEmeraldBit:
                moveq   #0,d2
                lsl.b   #1,d0
                bcc.s   S3SaveSlot_StoreEmeraldBitAndBindSave
                moveq   #1,d2

S3SaveSlot_StoreEmeraldBitAndBindSave:
                move.b  d2,(a3)+
                dbf     d1,S3SaveSlot_ExtractNextSavedEmeraldBit
                move.l  a1,(Save_pointer).w
                jsr     (Set_Lives_and_Continues).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SaveSlot_ConfirmOrEditEmptySlot:
                move.b  #$F,sub2_mapframe(a0)
                clr.b   sub3_mapframe(a0)
                move.w  (Player_2+object_control).w,d0
                or.w    (Events_bg+$12).w,d0
                bne.w   S3SaveSlot_DrawCharacterChildFrame
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.s   S3SaveSlot_CycleNewFileChoiceAndBlink
                move.b  #GameMode_Level,(Game_mode).w
                clr.l   (a1)
                clr.l   4(a1)
                move.w  $34(a0),d0
                move.b  d0,2(a1)
                move.w  d0,(Player_option).w
                clr.w   (Current_zone_and_act).w
                clr.w   (Apparent_zone_and_act).w
                clr.w   (Current_special_stage).w
                clr.w   (Chaos_emerald_count).w
                clr.l   (Collected_emeralds_array).w
                clr.w   (Collected_emeralds_array+4).w
                clr.b   (Collected_emeralds_array+6).w
                clr.l   (Collected_special_ring_array).w
                move.l  a1,(Save_pointer).w
                jsr     (Set_Lives_and_Continues).l
                jsr     Write_SaveGame(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SaveSlot_CycleNewFileChoiceAndBlink:
                move.w  $34(a0),d0
                jsr     S3Save_TryCycleNewGameCharacter(pc)
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
                bne.s   S3SaveSlot_DrawSlotAndChildren
                subq.w  #8,sub2_y_pos(a0)

S3SaveSlot_DrawSlotAndChildren:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Use fresh Up or Down while cursor motion is idle
S3Save_TryCycleNewGameCharacter:
                moveq   #0,d2
                tst.w   (Player_2+objoff_30).w
                bne.s   S3SaveSlot_PlayCharacterChangeSound
                move.b  (Ctrl_1_pressed).w,d1
                lsr.w   #1,d1
                bcc.s   S3SaveSlot_CycleCharacterBackward
                moveq   #signextendB(sfx_Switch),d2
                addq.w  #1,d0
                cmpi.w  #2,d0
                bls.s   S3SaveSlot_PlayCharacterChangeSound
                moveq   #0,d0
                bra.s   S3SaveSlot_PlayCharacterChangeSound
; ---------------------------------------------------------------------------

S3SaveSlot_CycleCharacterBackward:
                lsr.w   #1,d1
                bcc.s   S3SaveSlot_PlayCharacterChangeSound
                moveq   #signextendB(sfx_Switch),d2
                subq.w  #1,d0
                bpl.s   S3SaveSlot_PlayCharacterChangeSound
                moveq   #2,d0

S3SaveSlot_PlayCharacterChangeSound:
                tst.w   d2
                beq.s   S3SaveSlot_CharacterChoiceReturn
                move.l  d0,-(sp)
                move.l  d2,d0
                jsr     (Play_SFX).l
                move.l  (sp)+,d0

S3SaveSlot_CharacterChoiceReturn:
                rts
; End of function S3Save_TryCycleNewGameCharacter

; ---------------------------------------------------------------------------
