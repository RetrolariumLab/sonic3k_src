; Owner: game/modes/sk
; Responsibility: Sonic and Knuckles level selection, permitted character checks, cursor control and sound test
; Source provenance and ranges: config/reconstruction/source_layout.json
LevelSelect_S2Options:
                clr.w   (Current_zone_and_act).w
                bsr.w   Pal_FadeToBlack
                move    #$2700,sr
                move.w  (VDP_reg_1_command).w,d0
                andi.b  #$BF,d0
                move.w  d0,(VDP_control_port).l
                bsr.w   Clear_DisplayData
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8230,(a6)
                move.w  #$8407,(a6)
                move.w  #$8230,(a6)
                move.w  #$8700,(a6)
                move.w  #$8C81,(a6)
                move.w  #$9001,(a6)
                move.w  #$8B00,(a6)
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                move.l  #vdpComm(tiles_to_bytes($010),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_S22POptions).l,a0
                bsr.w   Nem_Decomp
                lea     (RAM_start).l,a1
                lea     (MapEni_S22POptions).l,a0
                move.w  #make_art_tile($000,3,0),d0
                bsr.w   Eni_Decomp
                lea     (RAM_start).l,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l

; Begin level select code

; S3 loaded S2's level select plane map here, for the level icon emblem
; lea (RAM_start).l,a1
; lea (MapEni_S2LevSel).l,a0
; move.w #make_art_tile($000,0,0),d0
; bsr.w Eni_Decomp

; Remember that plane map we just decompressed? Yeah, we're deleting that
                lea     (RAM_start).l,a3
; S3 only cleared 1600 bytes, to preserve the level icon emblem
                move.w  #bytesToWcnt($28*$1C*2),d1      ; This is the size of your usual decompressed plane map

                .clearloop:
                move.w  #0,(a3)+
                dbf     d1,.clearloop

; S3 would remove the one zone name that wasn't cleared: Oil Ocean
; lea (RAM_start+planeLocH28(3,$15)).l,a3
; move.w #bytesToWcnt($20),d1

; .loop:
; move.w #0,(a3)+
; dbf d1,.loop

; Build new plane map from LevelSelectText and LevSel_MappingOffsets
                save
                codepage LEVELSELECT                    ; This is here so we can use '*' instead of '$1A'

                lea     (RAM_start).l,a3
                lea     (LevelSelectText).l,a1
                lea     (LevSel_MappingOffsets).l,a5
                moveq   #0,d0
                move.w  #$11-1,d1                       ; This is how many entries there are in LevelSelectText

                .writezone:
                move.w  (a5)+,d3                        ; Get relative address in plane map to write to
                lea     (a3,d3.w),a2                    ; Get absolute address
                moveq   #0,d2
                move.b  (a1)+,d2                        ; Get length of string
                move.w  d2,d3                           ; Store it

                .writeletter:
                move.b  (a1)+,d0                        ; Get character from string
; ori.w #make_art_tile($000,0,0),d0
                move.w  d0,(a2)+                        ; Send it to plane map
                dbf     d2,.writeletter                 ; Loop for entire string

                move.w  #$D,d2                          ; Maximum length of string
                sub.w   d3,d2                           ; Get remaining space in string
                bcs.s   .stringfull                     ; If there is none, skip ahead

                .blankloop:
                move.w  #make_art_tile(' ',0,0),(a2)+   ; Full the remaining space with blank characters
                dbf     d2,.blankloop

                .stringfull:
                move.w  #make_art_tile('1',0,0),(a2)    ; Write (act) '1'
                lea     $28*2(a2),a2                    ; Next line
                move.w  #make_art_tile('2',0,0),(a2)    ; Write (act) '2'
                dbf     d1,.writezone

; Assuming the last line was the sound test
                move.w  #make_art_tile(' ',0,0),(a2)    ; Get rid of (act) '2'
                lea     -$28*2(a2),a2                   ; Go back to (act) '1'
                move.w  #make_art_tile('*',0,0),(a2)    ; Replace that with '*'

; Overwrite duplicate LAVA REEF 1/2 with 3/4 (obviously, S3 didn't do this)
                move.w  #make_art_tile('3',0,0),(RAM_start+planeLocH28($25,4)).l
                move.w  #make_art_tile('4',0,0),(RAM_start+planeLocH28($25,5)).l

                restore

; Send our built plane map to VRAM
                lea     (RAM_start).l,a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l

                moveq   #palette_line_0,d3
                bsr.w   LevelSelect_DrawSoundNumber

; in S3, there was some code here for the zone icons, but it was removed in S&K
; lea (RAM_start+($28*$1C*2)).l,a1 ; 2240; after the plane map
; lea (MapEni_S2LevSelIcon).l,a0
; move.w #make_art_tile(ArtTile_S2LevelSelectPics,0,0),d0
; bsr.w Eni_Decomp
; bsr.w LevelSelect_DrawIcon

                clr.w   (Player_mode).w
                clr.w   (Results_screen_2P).w
                clr.b   (Level_started_flag).w
                clr.w   (Anim_Counters).w
                lea     (AniPLC_SONICMILES).l,a2
                jsr     (AnimateTiles_DoAniPLC).l
                moveq   #PalID_S2Menu,d0
                bsr.w   LoadPalette
                lea     (Normal_palette_line_3).w,a1
                lea     (Target_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d1

loc_7BE4:
                move.l  (a1),(a2)+
                clr.l   (a1)+
                dbf     d1,loc_7BE4
                moveq   #signextendB(mus_DataSelect),d0
                jsr     (Play_Music).l
                move.w  #(30*60)-1,(Demo_timer).w
                clr.w   (Competition_mode).w
                clr.l   (Camera_X_pos).w
                clr.l   (Camera_Y_pos).w
                clr.l   (Save_pointer).w
                clr.l   (Collected_special_ring_array).w
                clr.b   (Last_star_post_hit).w
                clr.b   (Special_bonus_entry_flag).w
                clr.b   (Blue_spheres_stage_flag).w
                if      0
; Sonic 2 Beta 4 reveals that these were the original instructions
; The original source code may have been able to produce debug builds with this enabled
                move.w  #$101,(Level_select_flag).w
                move.w  #$101,(Debug_mode_flag).w
                else
                nop
                nop
                nop
                nop
                nop
                nop
                endif
                clr.w   (Level_select_cheat_counter).w
                clr.w   (Debug_mode_cheat_counter).w
                move.b  #VInt_ID_16,(V_int_routine).w
                bsr.w   Wait_VSync
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                bsr.w   Pal_FadeFromBlack

LevelSelect_Main:                                       ; routine running during level select
                move.b  #VInt_ID_16,(V_int_routine).w
                bsr.w   Wait_VSync
                move    #$2700,sr
                moveq   #palette_line_0,d3
                bsr.w   LevelSelect_MarkFields
                bsr.w   LevSelControls
                move.w  #palette_line_3,d3
                bsr.w   LevelSelect_MarkFields
; In S3, there was a branch to some zone icon code here
; bsr.w LevelSelect_DrawIcon
                move    #$2300,sr
                lea     (AniPLC_SONICMILES).l,a2
                jsr     (AnimateTiles_DoAniPLC).l
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                andi.b  #button_start_mask,d0
                bne.s   LevelSelect_PressStart
                bra.w   LevelSelect_Main
; ---------------------------------------------------------------------------

LevelSelect_PressStart:
                tst.w   (SK_alone_flag).w
                beq.s   loc_7CA0
                cmpi.w  #3,(Player_option).w
                bhs.s   loc_7CA0
                move.w  #1,(Player_option).w

loc_7CA0:
                move.w  (Player_option).w,(Player_mode).w
                lea     LS_Level_Order(pc),a1
                move.w  (Level_select_option).w,d0
                add.w   d0,d0
                move.w  (a1,d0.w),d0
                bmi.w   LevelSelect_Return              ; sound test
                cmpi.w  #$5555,d0                       ; This was used in Sonic 3 for the S&K zones
                beq.w   LevelSelect_Main                ; If entry is $5555, don't do anything
                move.b  #3,(Life_count).w
                move.b  #0,(SK_special_stage_flag).w
                cmpi.w  #$4000,d0                       ; Is Special Stage 1 selected?
                beq.w   LevelSelect_SpecialStageCheck   ; If so, branch
                cmpi.w  #$4001,d0                       ; Is Special Stage 2 selected?
                bne.w   LevelSelect_CheckKnuckles       ; If not, branch
                move.b  #1,(SK_special_stage_flag).w

LevelSelect_SpecialStage:
                move.b  #GameMode_SpecialStage,(Game_mode).w
                tst.w   (SK_alone_flag).w
                beq.s   locret_7D12
                cmpi.w  #$400,(Current_zone_and_act).w
                beq.s   locret_7D12
                cmpi.w  #$700,(Current_zone_and_act).w
                bhs.s   locret_7D12
                move.w  #$700,d0
                move.w  d0,(Current_zone_and_act).w
                move.w  d0,(Apparent_zone_and_act).w
                move.w  d0,(Saved_zone_and_act).w
                move.w  d0,(Saved_apparent_zone_and_act).w

locret_7D12:
                rts
; ---------------------------------------------------------------------------

LevelSelect_SpecialStageCheck:
                tst.w   (SK_alone_flag).w
                beq.s   LevelSelect_SpecialStage
                move.b  #1,(SK_special_stage_flag).w
                bra.s   LevelSelect_SpecialStage
; ---------------------------------------------------------------------------
LS_Level_Order:
                dc.w    0                               ; AIZ act 1
                dc.w    1                               ; AIZ act 2
                dc.w    $100                            ; HCZ act 1
                dc.w    $101                            ; HCZ act 2
                dc.w    $200                            ; MGZ act 1
                dc.w    $201                            ; MGZ act 2
                dc.w    $300                            ; CNZ act 1
                dc.w    $301                            ; CNZ act 2
                dc.w    $500                            ; ICZ act 1
                dc.w    $501                            ; ICZ act 2
                dc.w    $600                            ; LBZ act 1
                dc.w    $601                            ; LBZ act 2
                dc.w    $700                            ; MHZ act 1
                dc.w    $701                            ; MHZ act 2
                dc.w    $400                            ; FBZ act 1
                dc.w    $401                            ; FBZ act 2
                dc.w    $800                            ; SOZ act 1
                dc.w    $801                            ; SOZ act 2
                dc.w    $900                            ; LRZ act 1
                dc.w    $901                            ; LRZ act 2
                dc.w    $1600                           ; LRZ act 3
                dc.w    $1601                           ; LRZ act 4
                dc.w    $A00                            ; SSZ act 1
                dc.w    $A01                            ; SSZ act 2
                dc.w    $B00                            ; DEZ act 1
                dc.w    $B01                            ; DEZ act 2
                dc.w    $C00                            ; DDZ act 1
                dc.w    $1700                           ; DDZ act 2
                dc.w    $1400                           ; Bonus Stage 1
                dc.w    $1500                           ; Bonus Stage 2
                dc.w    $4000                           ; Special Stage 1
                dc.w    $4001                           ; Special Stage 2
                dc.w    $FFFF                           ; Sound Test
; ---------------------------------------------------------------------------

LevelSelect_Return:
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

LevelSelect_CheckKnuckles:
                tst.w   (Debug_cheat_flag).w
                bne.s   loc_7DBA
                cmpi.w  #3,(Player_mode).w              ; Are we Knuckles?
                bne.s   LevelSelect_CheckSonicTails     ; If not, branch
                cmpi.w  #$A00,d0                        ; Is SSZ act 1 selected?
                beq.s   LevelSelect_DenySelection       ; If so, branch and deny entry
                cmpi.w  #$C00,d0                        ; Is DDZ act 1 selected?
                beq.s   LevelSelect_DenySelection       ; If so, branch and deny entry
                cmpi.w  #$1600,d0                       ; Is LRZ act 3 selected?
                beq.s   LevelSelect_DenySelection       ; If so, branch and deny entry
                cmpi.w  #$1700,d0                       ; Is DDZ act 2 selected?
                bne.s   LevelSelect_CheckSonicTails     ; If not, branch

LevelSelect_DenySelection:
                moveq   #signextendB(sfx_Error),d0      ; Play error buzzer sound
                jsr     (Play_SFX).l
                bra.w   LevelSelect_Main
; ---------------------------------------------------------------------------

LevelSelect_CheckSonicTails:
                cmpi.w  #3,(Player_mode).w              ; Are we Knuckles (any character with an ID of 3+)?
                bhs.s   loc_7DAC                        ; If so, branch
                cmpi.w  #$A01,d0                        ; Is SSZ act 2 selected?
                beq.s   LevelSelect_DenySelection       ; If so, branch and deny entry

loc_7DAC:
                cmpi.w  #2,(Player_mode).w              ; Are we Tails?
                bne.s   loc_7DBA                        ; If not, branch
                cmpi.w  #$C00,d0                        ; Is DDZ act 1 selected?
                beq.s   LevelSelect_DenySelection       ; If so, branch and deny entry

loc_7DBA:
                tst.w   (SK_alone_flag).w               ; Are we playing S3K and not S&K?
                beq.s   LevelSelect_StartZone           ; If so, branch
; This here stops you from accessing S3 zones in S&K
                move.w  d0,d1                           ; Load selection
                move.b  #0,d1                           ; Eliminate act byte, leaving only the zone
                cmpi.w  #$400,d1                        ; Is FBZ selected?
                beq.s   LevelSelect_StartZone           ; If so, branch
                cmpi.w  #$700,d1                        ; Is any other S&K zone selected?
                bhs.s   LevelSelect_StartZone           ; If so, branch
                move.w  #$700,d0                        ; If any S3 zone is selected, force it to be MHZ

LevelSelect_StartZone:
                andi.w  #$3FFF,d0
                move.w  d0,(Current_zone_and_act).w
                move.w  d0,(Apparent_zone_and_act).w
                move.w  d0,(Saved_zone_and_act).w
                move.w  d0,(Saved_apparent_zone_and_act).w
                move.w  #$1000,d0
                move.w  d0,(Saved_camera_max_Y_pos).w
                move.w  d0,(Saved2_camera_max_Y_pos).w
                move.b  #GameMode_Level,(Game_mode).w
                move.b  #3,(Life_count).w
                move.b  #3,(Life_count_P2).w
                moveq   #0,d0
                move.w  d0,(Ring_count).w
                move.l  d0,(Timer).w
                move.l  d0,(Score).w
                move.w  d0,(Ring_count_P2).w
                move.l  d0,(Timer_P2).w
                move.l  d0,(Score_P2).w
                move.b  d0,(Continue_count).w
                move.w  d0,(Demo_mode_flag).w
                move.l  #5000,(Next_extra_life_score).w
                move.l  #5000,(Next_extra_life_score_P2).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_SFX).l
                moveq   #0,d0
                move.w  d0,(Competition_settings).w
                move.w  d0,(Competition_mode).w
                cmpi.b  #$E,(Current_zone).w
                blo.s   locret_7E62
                cmpi.b  #$13,(Current_zone).w
                bhs.s   locret_7E62
                move.w  #1,(Competition_mode).w

locret_7E62:
                rts

; =============== S U B R O U T I N E =======================================

LevSelControls:
                move.b  (Ctrl_1_pressed).w,d1
                andi.b  #button_up_mask|button_down_mask,d1
                bne.s   loc_7E74                        ; up/down pressed
                subq.w  #1,(Level_select_repeat).w
                bpl.s   LevSelControls_CheckLR

loc_7E74:
                move.w  #$B,(Level_select_repeat).w
                move.b  (Ctrl_1).w,d1
                andi.b  #button_up_mask|button_down_mask,d1
                beq.s   LevSelControls_CheckLR          ; up/down not pressed, check for left & right
                move.w  (Level_select_option).w,d0
                btst    #button_up,d1
                beq.s   loc_7E94
                subq.w  #1,d0                           ; decrease by 1
                bcc.s   loc_7E94                        ; >= 0?
                moveq   #$20,d0                         ; set to $20

loc_7E94:
                btst    #button_down,d1
                beq.s   loc_7EA4
                addq.w  #1,d0                           ; yes, add 1
                cmpi.w  #$21,d0
                blo.s   loc_7EA4                        ; smaller than $21?
                moveq   #0,d0                           ; if not, set to 0

loc_7EA4:
                move.w  d0,(Level_select_option).w
                rts
; ---------------------------------------------------------------------------

LevSelControls_CheckLR:
                cmpi.w  #$20,(Level_select_option).w    ; are we in the sound test?
                bne.s   LevSelControls_SwitchSide       ; no
                move.w  (Sound_test_sound).w,d0
                move.b  (Ctrl_1_pressed).w,d1
                btst    #button_left,d1
                beq.s   loc_7EC6
                subq.b  #1,d0
                bcc.s   loc_7EC6
                moveq   #0,d0

loc_7EC6:
                btst    #button_right,d1
                beq.s   loc_7ED6
                addq.b  #1,d0
                cmpi.w  #$100,d0
                blo.s   loc_7ED6
                moveq   #0,d0

loc_7ED6:
                btst    #button_A,d1
                beq.s   loc_7EE4
                addi.b  #$10,d0
                andi.b  #$FF,d0

loc_7EE4:
                move.w  d0,(Sound_test_sound).w
                btst    #button_C,d1
                beq.s   loc_7EF8
                move.w  (Sound_test_sound).w,d0
                jsr     (Play_Music).l

loc_7EF8:
                btst    #button_B,d1
                beq.s   locret_7F06
                moveq   #signextendB(cmd_MutePSG),d0
                jsr     (Play_Music).l

locret_7F06:
                rts
; ---------------------------------------------------------------------------

LevSelControls_SwitchSide:
                move.b  (Ctrl_1_pressed).w,d1
                andi.b  #button_left_mask|button_right_mask,d1
                beq.s   loc_7F1E
                move.w  (Level_select_option).w,d0
                move.b  LevelSelect_SwitchTable(pc,d0.w),d0
                move.w  d0,(Level_select_option).w

loc_7F1E:
                bra.s   LevelSelect_PickCharacterNumber
; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------
LevelSelect_SwitchTable:
                dc.b    $12                             ; 0
                dc.b    $13                             ; 1
                dc.b    $14                             ; 2
                dc.b    $15                             ; 3
                dc.b    $16                             ; 4
                dc.b    $17                             ; 5
                dc.b    $18                             ; 6
                dc.b    $19                             ; 7
                dc.b    $1A                             ; 8
                dc.b    $1B                             ; 9
                dc.b    $1C                             ; 10
                dc.b    $1D                             ; 11
                dc.b    $1E                             ; 12
                dc.b    $1F                             ; 13
                dc.b    $20                             ; 14
                dc.b    $20                             ; 15
                dc.b    $20                             ; 16
                dc.b    $20                             ; 17
                dc.b    0                               ; 18
                dc.b    1                               ; 19
                dc.b    2                               ; 20
                dc.b    3                               ; 21
                dc.b    4                               ; 22
                dc.b    5                               ; 23
                dc.b    6                               ; 24
                dc.b    7                               ; 25
                dc.b    8                               ; 26
                dc.b    9                               ; 27
                dc.b    $A                              ; 28
                dc.b    $B                              ; 29
                dc.b    $C                              ; 30
                dc.b    $D                              ; 31
                dc.b    $E                              ; 32
                dc.b    $F                              ; 33
                dc.b    $10                             ; 34
                dc.b    $11                             ; 35
; ---------------------------------------------------------------------------

LevelSelect_PickCharacterNumber:
                btst    #button_C,(Ctrl_1_pressed).w
                beq.s   locret_7F60
                addq.w  #1,(Player_option).w
                cmpi.w  #4,(Player_option).w
                blo.s   locret_7F60
                move.w  #0,(Player_option).w

locret_7F60:
                rts
; End of function LevSelControls

; =============== S U B R O U T I N E =======================================

LevelSelect_MarkFields:
                lea     (RAM_start).l,a4
                lea     (LevSel_MarkTable).l,a5
                lea     (VDP_data_port).l,a6
                moveq   #0,d0
                move.w  (Level_select_option).w,d0
                lsl.w   #2,d0
                lea     (a5,d0.w),a3
                moveq   #0,d0
                move.b  (a3),d0
                mulu.w  #$28*2,d0
                moveq   #0,d1
                move.b  1(a3),d1
                add.w   d1,d0
                lea     (a4,d0.w),a1
                moveq   #0,d1
                move.b  (a3),d1
                lsl.w   #7,d1
                add.b   1(a3),d1
                addi.w  #VRAM_Plane_A_Name_Table,d1
                lsl.l   #2,d1
                lsr.w   #2,d1
                ori.w   #vdpComm($0000,VRAM,WRITE)>>16,d1
                swap    d1
                move.l  d1,VDP_control_port-VDP_data_port(a6)
                moveq   #$F-1,d2

loc_7FB2:
                move.w  (a1)+,d0
                add.w   d3,d0
                move.w  d0,(a6)
                dbf     d2,loc_7FB2
                addq.w  #2,a3
                moveq   #0,d0
                move.b  (a3),d0
                beq.s   loc_7FF6
                mulu.w  #$50,d0
                moveq   #0,d1
                move.b  1(a3),d1
                add.w   d1,d0
                lea     (a4,d0.w),a1
                moveq   #0,d1
                move.b  (a3),d1
                lsl.w   #7,d1
                add.b   1(a3),d1
                addi.w  #VRAM_Plane_A_Name_Table,d1
                lsl.l   #2,d1
                lsr.w   #2,d1
                ori.w   #vdpComm($0000,VRAM,WRITE)>>16,d1
                swap    d1
                move.l  d1,VDP_control_port-VDP_data_port(a6)
                move.w  (a1)+,d0
                add.w   d3,d0
                move.w  d0,(a6)

loc_7FF6:
                cmpi.w  #$20,(Level_select_option).w
                bne.s   LevelSelect_DrawCharacterNumber
                bra.w   LevelSelect_DrawSoundNumber
; ---------------------------------------------------------------------------

LevelSelect_DrawCharacterNumber:
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$19C,VRAM,WRITE),(VDP_control_port).l
                move.w  (Player_option).w,d0
                bra.s   LevelSelect_DrawContinued
; End of function LevelSelect_MarkFields

; =============== S U B R O U T I N E =======================================

LevelSelect_DrawSoundNumber:
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$B46,VRAM,WRITE),(VDP_control_port).l
                move.w  (Sound_test_sound).w,d0

LevelSelect_DrawContinued:
                move.b  d0,d2
                lsr.b   #4,d0
                bsr.s   LevelSelectSKWriteOneHexNibbleTile
                move.b  d2,d0

LevelSelectSKWriteOneHexNibbleTile:
                andi.w  #$F,d0
                cmpi.b  #$A,d0
                blo.s   loc_8036
                addi.b  #4,d0

loc_8036:
                addi.b  #$10,d0
                add.w   d3,d0
                move.w  d0,(a6)
                rts
; End of function LevelSelect_DrawSoundNumber
