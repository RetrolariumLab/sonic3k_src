; Owner: game/persistence/sk
; Responsibility: Initial lives, SRAM initialization, default records, checksum validation, record reads and game-state persistence
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Initialize both players with three lives and a 5000-point next-life threshold. Clear round counters
SKComp_InitRoundState:
                move.w  #1,(Competition_mode).w
                bra.s   loc_C110
; ---------------------------------------------------------------------------

Set_Lives_and_Continues:
                clr.w   (Competition_mode).w

loc_C110:
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
; End of function SKComp_InitRoundState

; =============== S U B R O U T I N E =======================================

SRAM_Load:
                tst.w   (SK_alone_flag).w
                bne.w   locret_C260                     ; Don't bother if we're playing only Sonic and Knuckles
                clr.w   (SRAM_mask_interrupts_flag).w   ; No interrupt shenanigans needed
                lea     (SRAM_competition).l,a0
                lea     (SRAM_competition_backup).l,a1
                lea     (Competition_saved_data).w,a2
                moveq   #bytesToWcnt(SRAM_competition_size),d0
                move.w  #$4C44,d1                       ; RAM integrity value
                jsr     Get_From_SRAM(pc)
                beq.s   loc_C190                        ; If the data read was successful, branch
                lea     SaveData_GeneralDefault(pc),a0
                lea     (Competition_saved_data).w,a1
                moveq   #bytesToWcnt((Competition_saved_data_end-Competition_saved_data)-2),d0

loc_C186:
                move.w  (a0)+,(a1)+                     ; Reset the general save data to the default
                dbf     d0,loc_C186
                jsr     Write_SaveGeneral2(pc)          ; Write default data back to SRAM

loc_C190:
                lea     (SRAM_SKgame).l,a0
                lea     (SRAM_SKgame_backup).l,a1
                lea     (Saved_data).w,a2
                moveq   #bytesToWcnt(SRAM_SKgame_size),d0
                move.w  #$4244,d1                       ; RAM integrity value for save game data
                jsr     Get_From_SRAM(pc)
                bne.s   loc_C1C0                        ; If the data read was not successful, branch
                lea     (Saved_data).w,a0
                moveq   #8-1,d0

loc_C1B2:
                tst.b   (a0)
                bpl.w   loc_C256                        ; If any of the save files are active, then we're done here
                lea     $A(a0),a0
                dbf     d0,loc_C1B2                     ; if not then we load them up with default data

loc_C1C0:
                lea     SaveData_GameDefault(pc),a0
                lea     (Saved_data).w,a1
                moveq   #bytesToWcnt(($A*8)+2),d0

loc_C1CA:
                move.w  (a0)+,(a1)+
                dbf     d0,loc_C1CA                     ; Write default game data
                lea     (SRAM_S3game).l,a0
                lea     (SRAM_S3game_backup).l,a1
                lea     ((RAM_start+$0)&$FFFFFF).l,a2   ; Attempt to see if there's any existing S3 save data
                moveq   #bytesToWcnt(SRAM_S3game_size),d0
                move.w  #$4244,d1
                jsr     Get_From_SRAM(pc)
                bne.s   loc_C252                        ; If write was not successful, branch
                lea     (Saved_data).w,a0               ; If there's valid data from Sonic 3, we'll now go through the process of migrating it to SK
                lea     ((RAM_start+$0)&$FFFFFF).l,a1
                lea     SaveData_S3LevRef(pc),a2
                moveq   #6-1,d0

loc_C1FE:
                tst.b   (a1)
                bmi.s   loc_C248                        ; If not an active save slot, branch
                clr.b   (a0)
                move.b  1(a1),4(a0)                     ; Special stage ring memory migration
                move.b  7(a1),5(a0)
                move.b  2(a1),d1
                lsl.b   #4,d1
                move.b  d1,2(a0)                        ; Character ID is stored differently
                moveq   #0,d1
                move.b  3(a1),d1
                move.b  (a2,d1.w),3(a0)                 ; Current level IDs are changed slightly between S3 and SK and need to be converted
                move.b  4(a1),d1
                or.b    d1,2(a0)                        ; The last completed special stage was previously its own byte
                move.b  6(a1),d1
                moveq   #0,d2
                moveq   #7-1,d3

loc_C236:
                lsl.b   #1,d1
                bcc.s   loc_C23E
                ori.w   #1,d2

loc_C23E:
                lsl.w   #2,d2
                dbf     d3,loc_C236
                move.w  d2,6(a0)                        ; The chaos/super emerald data is interleaved in SK and needs to be converted

loc_C248:
                lea     $A(a0),a0
                addq.w  #8,a1
                dbf     d0,loc_C1FE

loc_C252:
                jsr     Write_SaveGame(pc)

loc_C256:
                clr.w   (Dataselect_nosave_player).w
                move.b  #1,(Dataselect_entry).w

locret_C260:
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
                dc.w    $8000,     0,     0,     0,  $300
                dc.w    $8000,     0,     0,     0,  $300
                dc.w    $8000,     0,     0,     0,  $300
                dc.w    $8000,     0,     0,     0,  $300
                dc.w    $8000,     0,     0,     0,  $300
                dc.w    $8000,     0,     0,     0,  $300
                dc.w    $8000,     0,     0,     0,  $300
                dc.w    $8000,     0,     0,     0,  $300
                dc.w    $4244
SaveData_S3LevRef:
                dc.b    0
                dc.b    1
                dc.b    2
                dc.b    3
                dc.b    0
                dc.b    4
                dc.b    5
                dc.b    6
                even

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
                tst.w   (SRAM_mask_interrupts_flag).w
                beq.s   loc_C32A
                move    #$2700,sr                       ; Disable interrupts if EF56 is set

loc_C32A:
                move.b  #1,(SRAM_access_flag).l         ; Access SRAM
                movea.l a2,a6
                move.w  d0,d6

loc_C336:
                movep.w 0(a0),d3
                move.w  d3,(a2)+                        ; Read data from SRAM
                addq.w  #4,a0
                dbf     d0,loc_C336
                move.b  #0,(SRAM_access_flag).l         ; No longer access SRAM
                tst.w   (SRAM_mask_interrupts_flag).w
                beq.s   loc_C354
                move    #$2300,sr                       ; Restore interrupts if EF56 is set

loc_C354:
                subq.w  #1,d6
                bsr.s   Create_SRAMChecksum             ; Get the checksum of the given data
                cmp.w   (a6),d7                         ; Compare the result
                bne.s   locret_C360
                cmp.w   -2(a6),d1                       ; Also compare the data before with the data given in d1

locret_C360:
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
                tst.w   (SRAM_mask_interrupts_flag).w
                beq.s   loc_C38A
                move    #$2700,sr                       ; If EF56 is set, disable interrupts while saving is occurring

loc_C38A:
                move.b  #1,(SRAM_access_flag).l         ; Send I/O signal to SRAM, mapping it to $200001
                movea.l a2,a3
                move.w  d0,d1

loc_C396:
                move.w  (a2)+,d2
                movep.w d2,0(a0)                        ; Copy data to SRAM
                addq.w  #4,a0
                dbf     d0,loc_C396

loc_C3A2:
                move.w  (a3)+,d2
                movep.w d2,0(a1)                        ; Copy data to backup SRAM
                addq.w  #4,a1
                dbf     d1,loc_C3A2
                move.b  #0,(SRAM_access_flag).l         ; Stop SRAM access
                tst.w   (SRAM_mask_interrupts_flag).w
                beq.s   locret_C3C0
                move    #$2300,sr                       ; Restore interrupts if EF56 was set

locret_C3C0:
                rts
; End of function Write_SRAM

; =============== S U B R O U T I N E =======================================

Write_SaveGeneral:
                st      (SRAM_mask_interrupts_flag).w
; End of function Write_SaveGeneral

; =============== S U B R O U T I N E =======================================

Write_SaveGeneral2:
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
; End of function Write_SaveGeneral2

; =============== S U B R O U T I N E =======================================

Write_SaveGame:
                move.l  a0,-(sp)
                move.w  d7,-(sp)
                lea     (SRAM_SKgame).l,a0              ; Save game SRAM
                lea     (SRAM_SKgame_backup).l,a1       ; Save game backup SRAM
                lea     (Saved_data).w,a2               ; Save game RAM
                moveq   #bytesToWcnt(SRAM_SKgame_size),d0
                jsr     Write_SRAM(pc)
                move.w  (sp)+,d7
                movea.l (sp)+,a0
                rts
; End of function Write_SaveGame

; ---------------------------------------------------------------------------
SaveGame_NextLevel:
                dc.b    1,   1
                dc.b    2,   2
                dc.b    3,   3
                dc.b    4,   4
                dc.b    8,   8
                dc.b    5,   5
                dc.b    6,   6
                dc.b    7,   7
                dc.b    9,   9
                dc.b    $A,  $A
                dc.b    $C,  $C
                dc.b    $D,  $D
                dc.b    $E,  $E
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    $A,  $B
                dc.b    $D,   0
                even

; =============== S U B R O U T I N E =======================================

SaveGame:
                tst.w   (SK_alone_flag).w
                bne.w   loc_C4CC                        ; If this is SK, saving is disabled
                move.l  (Save_pointer).w,d0
                beq.w   loc_C4CC                        ; If not playing on a save file, get out
                movea.l d0,a1
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #7,d0
                move.b  SaveGame_NextLevel(pc,d0.w),d0
                move.b  (a1),d1
                andi.w  #3,d1
                beq.s   loc_C464
                cmp.b   3(a1),d0                        ; If game is complete, make it uncomplete if last level is less than the current level
                blo.s   loc_C4B4                        ; Think of, say, getting all the super emeralds then going to Doomsday on a completed save file
                andi.b  #$FC,(a1)

loc_C464:
                move.b  d0,3(a1)                        ; Move next level into current level
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_C478
                cmpi.b  #$C,d0
                blo.s   loc_C4B0
                bra.s   loc_C498                        ; If playing as Knuckles and level code is Death Egg or higher, make it a completed save file
; ---------------------------------------------------------------------------

loc_C478:
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_C488
                cmpi.b  #$D,d0
                blo.s   loc_C4B0
                bra.s   loc_C498                        ; If playing as Tails and level code is Doomsday or higher, make it a completed save file
; ---------------------------------------------------------------------------

loc_C488:
                cmpi.b  #$D,d0
                bhi.s   loc_C498                        ; If next level above Doomsday's code, make it a completed save file
                bne.s   loc_C4B0
                cmpi.b  #7,(Chaos_emerald_count).w      ; If next level IS Doomsday but the emeralds aren't collected, make it a completed save file
                bhs.s   loc_C4B0

loc_C498:
                moveq   #1,d0
                cmpi.b  #7,(Chaos_emerald_count).w
                blo.s   loc_C4AE                        ; code 1 is completed without all emeralds
                addq.b  #1,d0
                cmpi.b  #7,(Super_emerald_count).w
                blo.s   loc_C4AE                        ; code 2 is completed with all chaos emeralds
                addq.b  #1,d0                           ; code 3 is completed with all super emeralds

loc_C4AE:
                move.b  d0,(a1)

loc_C4B0:
                clr.w   4(a1)                           ; Clear the special stage ring collection memory

loc_C4B4:
                move.b  (Life_count).w,d0               ; Get number of lives
                cmpi.b  #99,d0
                bls.s   loc_C4C0
                moveq   #99,d0

loc_C4C0:
                move.b  d0,8(a1)                        ; Put number of lives into memory
                move.b  d0,(Life_count).w
                jsr     Write_SaveGame(pc)

loc_C4CC:
                clr.l   (Collected_special_ring_array).w  ; Clear special stage ring collection RAM
                rts
; End of function SaveGame

; =============== S U B R O U T I N E =======================================

SaveGame_SpecialStage:
                tst.w   (SK_alone_flag).w
                bne.s   locret_C530                     ; If playing Sonic and Knuckles, don't bother
                move.l  (Save_pointer).w,d0
                beq.s   locret_C530
                movea.l d0,a1                           ; Get address of save slot
                tst.b   (SK_special_stage_flag).w
                bne.s   loc_C4F8
                andi.b  #$F0,2(a1)
                move.b  (Current_special_stage).w,d0
                andi.b  #$F,d0
                or.b    d0,2(a1)                        ; Write last played special stage only if Sonic 3 special stages are in effect

loc_C4F8:
                lea     (Collected_emeralds_array).w,a2
                moveq   #0,d0
                moveq   #7-1,d1

loc_C500:
                move.b  (a2)+,d2
                andi.b  #3,d2
                or.b    d2,d0
                lsl.w   #2,d0
                dbf     d1,loc_C500
                move.w  d0,6(a1)                        ; Compress emerald collection RAM and put it into Save Game
                move.w  (Collected_special_ring_array+2).w,4(a1)  ; Special stage entry ring memory is copied as well
                move.b  (Continue_count).w,d0
                cmpi.b  #99,d0
                bls.s   loc_C524
                moveq   #99,d0

loc_C524:
                move.b  d0,9(a1)                        ; Save number of continues
                move.b  d0,(Continue_count).w
                jmp     Write_SaveGame(pc)
; ---------------------------------------------------------------------------

locret_C530:
                rts
; End of function SaveGame_SpecialStage

; =============== S U B R O U T I N E =======================================

SaveGame_LivesContinues:
                tst.w   (SK_alone_flag).w
                bne.s   locret_C56C                     ; If playing Sonic and Knuckles, don't bother
                move.l  (Save_pointer).w,d0
                beq.s   locret_C56C
                movea.l d0,a1
                move.b  (Life_count).w,d0
                cmpi.b  #99,d0
                bls.s   loc_C54C
                moveq   #99,d0

loc_C54C:
                move.b  d0,8(a1)                        ; Save number of lives
                move.b  d0,(Life_count).w
                move.b  (Continue_count).w,d0
                cmpi.b  #99,d0
                bls.s   loc_C560
                moveq   #99,d0

loc_C560:
                move.b  d0,9(a1)                        ; Save number of continues
                move.b  d0,(Continue_count).w
                jmp     Write_SaveGame(pc)
; ---------------------------------------------------------------------------

locret_C56C:
                rts
; End of function SaveGame_LivesContinues

; ---------------------------------------------------------------------------

locret_C56E:
                rts
; ---------------------------------------------------------------------------
