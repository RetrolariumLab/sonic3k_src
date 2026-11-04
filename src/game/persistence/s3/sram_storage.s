; Owner: game/persistence/s3
; Responsibility: Initial lives, SRAM initialization, default records, checksum validation, record reads and game-state persistence
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Initialize both players with three lives and a 5000-point next-life threshold. Clear round counters
S3Comp_InitRoundState:
                move.w  #1,(Competition_mode).w
                bra.s   S3Sram_ResetPlayerStats
; ---------------------------------------------------------------------------

Set_Lives_and_Continues:
                clr.w   (Competition_mode).w

S3Sram_ResetPlayerStats:
                move.b  #3,(Life_count).w
                move.b  #3,(Life_count_P2).w
                moveq   #0,d0
                move.b  d0,(Last_star_post_hit).w
                move.b  d0,(Special_bonus_entry_flag).w
                move.w  d0,(Ring_count).w
                move.l  d0,(Timer).w
                move.l  d0,(Score).w
                move.w  d0,(Ring_count_P2).w
                move.l  d0,(Timer_P2).w
                move.l  d0,(Score_P2).w
                move.b  d0,(Continue_count).w
                move.l  #5000,(Next_extra_life_score).w
                move.l  #5000,(Next_extra_life_score_P2).w
                rts
; End of function S3Comp_InitRoundState

; =============== S U B R O U T I N E =======================================

SRAM_Load:
                move.b  #1,(SRAM_access_flag).l
                lea     (SRAM_competition).l,a0
                lea     (SRAM_competition_backup).l,a1
                lea     (Competition_saved_data).w,a2
                moveq   #bytesToWcnt(SRAM_competition_size),d0
                move.w  #$4C44,d1                       ; RAM integrity value
                jsr     Get_From_SRAM(pc)
                beq.s   S3Sram_LoadAndValidateGameRegion  ; If the data read was successful, branch
                lea     SaveData_GeneralDefault(pc),a0
                lea     (Competition_saved_data).w,a1
                moveq   #bytesToWcnt((Competition_saved_data_end-Competition_saved_data)-2),d0

S3Sram_CopyDefaultCompetitionData:
                move.w  (a0)+,(a1)+                     ; Reset the general save data to the default
                dbf     d0,S3Sram_CopyDefaultCompetitionData
                jsr     Write_SaveGeneral(pc)           ; Write default data back to SRAM

S3Sram_LoadAndValidateGameRegion:
                lea     (SRAM_S3game).l,a0
                lea     (SRAM_S3game_backup).l,a1
                lea     (Saved_data).w,a2
                moveq   #bytesToWcnt(SRAM_S3game_size),d0
                move.w  #$4244,d1                       ; RAM integrity value for save game data
                jsr     Get_From_SRAM(pc)
                beq.s   S3Sram_ResetMenuSelection       ; If the data read was not successful, branch
                lea     SaveData_GameDefault(pc),a0
                lea     (Saved_data).w,a1
                moveq   #bytesToWcnt((8*6)+2),d0

S3Sram_CopySixEmptySlots:
                move.w  (a0)+,(a1)+
                dbf     d0,S3Sram_CopySixEmptySlots
                jsr     Write_SaveGame(pc)

S3Sram_ResetMenuSelection:
                clr.w   (Dataselect_nosave_player).w
                move.b  #1,(Dataselect_entry).w
                rts
; End of function SRAM_Load

; ---------------------------------------------------------------------------
SaveData_GeneralDefault:
                dc.w    $8000,     0, $8000,     0, $8000,     0,     1,  $200
                dc.w    $8000,     0, $8000,     0, $8000,     0,     1,  $200
                dc.w    $8000,     0, $8000,     0, $8000,     0,     1,  $200
                dc.w    $8000,     0, $8000,     0, $8000,     0,     1,  $200
                dc.w    $8000,     0, $8000,     0, $8000,     0,     1,  $200
                dc.w    $4C44
SaveData_GameDefault:
                dc.w    $8000,     0,     0,     0
                dc.w    $8000,     0,     0,     0
                dc.w    $8000,     0,     0,     0
                dc.w    $8000,     0,     0,     0
                dc.w    $8000,     0,     0,     0
                dc.w    $8000,     0,     0,     0
                dc.w    $4244

; =============== S U B R O U T I N E =======================================

Get_From_SRAM:
                movea.l a2,a3
                move.w  d0,d2
                bsr.s   Read_SRAM
                beq.s   .end
                movea.l a1,a0
                movea.l a3,a2
                move.w  d2,d0
                bsr.s   Read_SRAM

                .end:
                rts
; End of function Get_From_SRAM

; =============== S U B R O U T I N E =======================================

Read_SRAM:
                movea.l a2,a6
                move.w  d0,d6

S3Sram_ReadOddBusWords:
                movep.w 0(a0),d3
                move.w  d3,(a2)+                        ; Read data from SRAM
                addq.w  #4,a0
                dbf     d0,S3Sram_ReadOddBusWords
                subq.w  #1,d6
                bsr.s   Create_SRAMChecksum             ; Get the checksum of the given data
                cmp.w   (a6),d7                         ; Compare the result
                bne.s   S3Sram_ReturnValidationStatus
                cmp.w   -2(a6),d1                       ; Also compare the data before with the data given in d1

S3Sram_ReturnValidationStatus:
                rts
; End of function Read_SRAM

; =============== S U B R O U T I N E =======================================

Create_SRAMChecksum:
                moveq   #0,d7

                .loop:
                move.w  (a6)+,d5
                eor.w   d5,d7
                lsr.w   #1,d7
                bcc.s   .skip
                eori.w  #$8810,d7

                .skip:
                dbf     d6,.loop
                rts
; End of function Create_SRAMChecksum

; =============== S U B R O U T I N E =======================================

Write_SRAM:
                movea.l a2,a6
                move.w  d0,d6
                subq.w  #1,d6
                bsr.s   Create_SRAMChecksum
                move.w  d7,(a6)
                movea.l a2,a3
                move.w  d0,d1

S3Sram_WritePrimaryOddBusWords:
                move.w  (a2)+,d2
                movep.w d2,0(a0)                        ; Copy data to SRAM
                addq.w  #4,a0
                dbf     d0,S3Sram_WritePrimaryOddBusWords

S3Sram_WriteBackupOddBusWords:
                move.w  (a3)+,d2
                movep.w d2,0(a1)                        ; Copy data to backup SRAM
                addq.w  #4,a1
                dbf     d1,S3Sram_WriteBackupOddBusWords
                rts
; End of function Write_SRAM

; =============== S U B R O U T I N E =======================================

Write_SaveGeneral:
                move.l  a0,-(sp)
                move.w  d7,-(sp)
                lea     (SRAM_competition).l,a0         ; Save general SRAM
                lea     (SRAM_competition_backup).l,a1  ; Save general Backup SRAM
                lea     (Competition_saved_data).w,a2   ; Save general RAM
                moveq   #bytesToWcnt(SRAM_competition_size),d0
                bsr.s   Write_SRAM
                move.w  (sp)+,d7
                movea.l (sp)+,a0
                rts
; End of function Write_SaveGeneral

; =============== S U B R O U T I N E =======================================

Write_SaveGame:
                move.l  a0,-(sp)
                move.w  d7,-(sp)
                lea     (SRAM_S3game).l,a0              ; Save game SRAM
                lea     (SRAM_S3game_backup).l,a1       ; Save game backup SRAM
                lea     (Saved_data).w,a2               ; Save game RAM
                moveq   #bytesToWcnt(SRAM_S3game_size),d0
                bsr.s   Write_SRAM
                move.w  (sp)+,d7
                movea.l (sp)+,a0
                rts
; End of function Write_SaveGame

; =============== S U B R O U T I N E =======================================

SaveGame:
                tst.b   (Apparent_act).w
                beq.s   S3Sram_ProgressSaveReturn
                move.l  (Save_pointer).w,d0
                beq.s   S3Sram_ClearGlobalSpecialRingFlags  ; If not playing on a save file, get out
                movea.l d0,a1
                cmpi.b  #6,3(a1)
                bhi.s   S3Sram_ClearGlobalSpecialRingFlags
                moveq   #0,d0
                move.b  (Apparent_zone).w,d0
                move.b  SaveGame_NextLevel(pc,d0.w),3(a1)
                clr.b   7(a1)
                clr.b   1(a1)
                jsr     Write_SaveGame(pc)

S3Sram_ClearGlobalSpecialRingFlags:
                clr.l   (Collected_special_ring_array).w  ; Clear special stage ring collection RAM

S3Sram_ProgressSaveReturn:
                rts
; End of function SaveGame

; ---------------------------------------------------------------------------
SaveGame_NextLevel:
                dc.b    1,   2,   3,   5,   5,   6,   7
                even

; =============== S U B R O U T I N E =======================================

SaveGame_SpecialStage:
                move.l  (Save_pointer).w,d0
                beq.s   S3Sram_SpecialStageSaveReturn
                movea.l d0,a1                           ; Get address of save slot
                move.b  (Current_special_stage).w,4(a1)
                move.b  (Chaos_emerald_count+1).w,5(a1)
                lea     (Collected_emeralds_array).w,a2
                moveq   #0,d0
                moveq   #7-1,d1

S3Sram_PackEmeraldPresence:
                tst.b   (a2)+
                beq.s   S3Sram_ShiftPackedEmeraldBit
                ori.w   #1,d0

; The seven stored emerald flags occupy bits 7 through 1
S3Sram_ShiftPackedEmeraldBit:
                lsl.b   #1,d0
                dbf     d1,S3Sram_PackEmeraldPresence
                move.b  d0,6(a1)                        ; Compress emerald collection RAM and put it into Save Game
                move.l  (Collected_special_ring_array).w,d0  ; Special stage entry ring memory is copied as well
                move.b  d0,7(a1)
                lsr.l   #8,d0
                move.b  d0,1(a1)
                jmp     Write_SaveGame(pc)
; ---------------------------------------------------------------------------

S3Sram_SpecialStageSaveReturn:
                rts
; End of function SaveGame_SpecialStage

; ---------------------------------------------------------------------------

S3Sram_SaveMenuVBlankReturn:
                rts
; ---------------------------------------------------------------------------
