; Owner: game/modes/s3
; Responsibility: Level selection initialization, zone dispatch, cursor control, sound test and cheat input processing
; Source provenance and ranges: config/reconstruction/source_layout.json
MenuScreen_LevelSelect:
; Loaded S2's level select plane map here, for the level icon emblem
                lea     (RAM_start).l,a1
                lea     (MapEni_S2LevSel).l,a0
                move.w  #make_art_tile($000,0,0),d0
                bsr.w   Eni_Decomp

                lea     (RAM_start).l,a3
; Only clear 1600 bytes, in order to preserve the level icon emblem
                move.w  #bytesToWcnt($320*2),d1

                .clearloop:
                move.w  #0,(a3)+
                dbf     d1,.clearloop

; S3 would remove the one zone name that wasn't cleared: Oil Ocean
                lea     (RAM_start+planeLocH28(3,$15)).l,a3
                move.w  #bytesToWcnt($20),d1

                .loop:
                move.w  #0,(a3)+
                dbf     d1,.loop

; Build new plane map from LevelSelectText and LevSel_MappingOffsets
                save
                codepage LEVELSELECT                    ; This is here so we can use '*' instead of '$1A'

                lea     (RAM_start).l,a3
                lea     (LevelSelectText).l,a1
                lea     (LevSel_MappingOffsets).l,a5
                moveq   #0,d0
                move.w  #$F-1,d1                        ; This is how many entries there are in LevelSelectText

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

                restore

; Send our built plane map to VRAM
                lea     (RAM_start).l,a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l

                moveq   #palette_line_0,d3
                bsr.w   LevelSelect_DrawSoundNumber

                lea     (RAM_start+($28*$1C*2)).l,a1    ; 2240; after the plane map
                lea     (MapEni_S2LevSelIcon).l,a0
                move.w  #make_art_tile(ArtTile_S2LevelSelectPics,0,0),d0
                bsr.w   Eni_Decomp
                bsr.w   LevelSelect_DrawIcon

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
                moveq   #bytesToLcnt(Normal_palette_line_4-Normal_palette_line_3),d1

loc_696C:
                move.l  (a1),(a2)+
                clr.l   (a1)+
                dbf     d1,loc_696C
                moveq   #signextendB(mus_DataSelect),d0
                jsr     (Play_Music).l
                move.w  #(30*60)-1,(Demo_timer).w
                clr.w   (Competition_mode).w
                clr.l   (Camera_X_pos).w
                clr.l   (Camera_Y_pos).w
                clr.l   (Save_pointer).w
                move.w  #(1<<8)|1,(Level_select_flag).w
                move.w  #(1<<8)|1,(Debug_cheat_flag).w
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
                bsr.w   LevelSelect_DrawIcon
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
                move.w  (Level_select_option).w,d0
                add.w   d0,d0
                move.w  LS_Level_Order(pc,d0.w),d0
                bmi.w   LevelSelect_Return              ; sound test
                cmpi.w  #$5555,d0                       ; S&K zones
                beq.w   LevelSelect_Main                ; If entry is $5555, don't do anything
                cmpi.w  #$4001,d0                       ; Is Special Stage 2 selected?
                beq.w   LevelSelect_SpecialStage        ; If so, branch
                cmpi.w  #$4000,d0                       ; Is Special Stage 1 selected?
                bne.w   LevelSelect_StartZone           ; If not, branch
                move.b  #GameMode_SpecialStage,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

LevelSelect_SpecialStage:
                move.b  #GameMode_SpecialStage3,(Game_mode).w
                rts
; ---------------------------------------------------------------------------
; unused leftover from Sonic 2
                move.b  #GameMode_SpecialStage_S2,(Game_mode).w
                clr.w   (Current_zone_and_act).w
                clr.w   (Apparent_zone_and_act).w
                clr.w   (Saved_zone_and_act).w
                move.b  #3,(Life_count).w
                move.b  #3,(Life_count_P2).w
                moveq   #0,d0
                move.w  d0,(Ring_count).w
                move.l  d0,(Timer).w
                move.l  d0,(Score).w
                move.w  d0,(Ring_count_P2).w
                move.l  d0,(Timer_P2).w
                move.l  d0,(Score_P2).w
                move.l  #5000,(Next_extra_life_score).w
                move.l  #5000,(Next_extra_life_score_P2).w
                move.w  (Player_option).w,(Player_mode).w
                rts
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
                dc.w    $5555                           ; FBZ act 1 (disabled)
                dc.w    $5555                           ; FBZ act 2 (disabled)
                dc.w    $500                            ; ICZ act 1
                dc.w    $501                            ; ICZ act 2
                dc.w    $600                            ; LBZ act 1
                dc.w    $601                            ; LBZ act 2
                dc.w    $5555                           ; MHZ act 1 (disabled)
                dc.w    $5555                           ; MHZ act 2 (disabled)
                dc.w    $5555                           ; SOZ act 1 (disabled)
                dc.w    $5555                           ; SOZ act 2 (disabled)
                dc.w    $E00                            ; ALZ
                dc.w    $F00                            ; BPZ
                dc.w    $1000                           ; DPZ
                dc.w    $1100                           ; CGZ
                dc.w    $1200                           ; EMZ
                dc.w    $1300                           ; 2P VS (Bonus Stage)
                dc.w    $5555                           ; Bonus Stage (disabled)
                dc.w    $5555                           ; Bonus Stage (disabled)
                dc.w    $4000                           ; Special Stage 1
                dc.w    $4001                           ; Special Stage 2
                dc.w    $FFFF                           ; Sound Test
; ---------------------------------------------------------------------------

LevelSelect_Return:
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

LevelSelect_StartZone:
                andi.w  #$3FFF,d0
                move.w  d0,(Current_zone_and_act).w
                move.w  d0,(Apparent_zone_and_act).w
                move.w  d0,(Saved_zone_and_act).w
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
                move.l  #5000,(Next_extra_life_score).w
                move.l  #5000,(Next_extra_life_score_P2).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_SFX).l
                moveq   #0,d0
                move.w  d0,(Competition_settings).w
                move.w  d0,(Competition_mode).w
                cmpi.b  #$E,(Current_zone).w
                blo.s   locret_6B48
                cmpi.b  #$13,(Current_zone).w
                bhs.s   locret_6B48
                move.w  #1,(Competition_mode).w

locret_6B48:
                rts

; =============== S U B R O U T I N E =======================================

LevSelControls:
                move.b  (Ctrl_1_pressed).w,d1
                andi.b  #button_up_mask|button_down_mask,d1
                bne.s   loc_6B5A                        ; up/down pressed
                subq.w  #1,(Level_select_repeat).w
                bpl.s   LevSelControls_CheckLR

loc_6B5A:
                move.w  #$B,(Level_select_repeat).w
                move.b  (Ctrl_1_held).w,d1
                andi.b  #button_up_mask|button_down_mask,d1
                beq.s   LevSelControls_CheckLR          ; up/down not pressed, check for left & right
                move.w  (Level_select_option).w,d0
                btst    #button_up,d1
                beq.s   loc_6B7A
                subq.w  #1,d0                           ; decrease by 1
                bcc.s   loc_6B7A                        ; >= 0?
                moveq   #$1C,d0                         ; set to $1C

loc_6B7A:
                btst    #button_down,d1
                beq.s   loc_6B8A
                addq.w  #1,d0                           ; yes, add 1
                cmpi.w  #$1D,d0
                blo.s   loc_6B8A                        ; smaller than $1D?
                moveq   #0,d0                           ; if not, set to 0

loc_6B8A:
                move.w  d0,(Level_select_option).w
                rts
; ---------------------------------------------------------------------------

LevSelControls_CheckLR:
                cmpi.w  #$1C,(Level_select_option).w    ; are we in the sound test?
                bne.s   LevSelControls_SwitchSide       ; no
                move.w  (Sound_test_sound).w,d0
                move.b  (Ctrl_1_pressed).w,d1
                btst    #button_left,d1
                beq.s   loc_6BAC
                subq.b  #1,d0
                bcc.s   loc_6BAC
                moveq   #0,d0

loc_6BAC:
                btst    #button_right,d1
                beq.s   loc_6BBC
                addq.b  #1,d0
                cmpi.w  #$100,d0
                blo.s   loc_6BBC
                moveq   #0,d0

loc_6BBC:
                btst    #button_A,d1
                beq.s   loc_6BCA
                addi.b  #$10,d0
                andi.b  #$FF,d0

loc_6BCA:
                move.w  d0,(Sound_test_sound).w
                btst    #button_C,d1
                beq.s   loc_6BF4
                move.w  (Sound_test_sound).w,d0
                jsr     (Play_Music).l
                lea     (DebugCodeDat).l,a0
                lea     (AllEmeraldsCodeDat).l,a2
                lea     (Debug_cheat_flag).w,a1
                moveq   #1,d2
                bra.w   CheckCheats
; ---------------------------------------------------------------------------

loc_6BF4:
                btst    #button_B,d1
                beq.s   locret_6C02
                moveq   #signextendB(cmd_MutePSG),d0
                jsr     (Play_Music).l

locret_6C02:
                rts
; ---------------------------------------------------------------------------

LevSelControls_SwitchSide:
                move.b  (Ctrl_1_pressed).w,d1
                andi.b  #button_left_mask|button_right_mask,d1
                beq.s   loc_6C1A
                move.w  (Level_select_option).w,d0
                move.b  LevelSelect_SwitchTable(pc,d0.w),d0
                move.w  d0,(Level_select_option).w

loc_6C1A:
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
                dc.b    $1C                             ; 11
                dc.b    $1C                             ; 12
                dc.b    $1C                             ; 13
                dc.b    $1C                             ; 14
                dc.b    $1C                             ; 15
                dc.b    $1C                             ; 16
                dc.b    $1C                             ; 17
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
; ---------------------------------------------------------------------------

LevelSelect_PickCharacterNumber:
                btst    #button_C,(Ctrl_1_pressed).w
                beq.s   loc_6C56
                addq.b  #1,(P1_character).w
                cmpi.b  #3,(P1_character).w
                blo.s   loc_6C56
                move.b  #0,(P1_character).w

loc_6C56:
                btst    #button_C,(Ctrl_2_pressed).w
                beq.s   locret_6C70
                addq.b  #1,(P2_character).w
                cmpi.b  #3,(P2_character).w
                blo.s   locret_6C70
                move.b  #0,(P2_character).w

locret_6C70:
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

loc_6CC2:
                move.w  (a1)+,d0
                add.w   d3,d0
                move.w  d0,(a6)
                dbf     d2,loc_6CC2
                addq.w  #2,a3
                moveq   #0,d0
                move.b  (a3),d0
                beq.s   loc_6D06
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

loc_6D06:
                cmpi.w  #$1C,(Level_select_option).w
                bne.s   LevelSelect_DrawCharacterNumber
                bra.w   LevelSelect_DrawSoundNumber
; ---------------------------------------------------------------------------

LevelSelect_DrawCharacterNumber:
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$1B8,VRAM,WRITE),(VDP_control_port).l
                move.b  (P1_character).w,d0
                bsr.s   LevelSelect_DrawContinued
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$1C0,VRAM,WRITE),(VDP_control_port).l
                move.b  (P2_character).w,d0
                bra.s   LevelSelect_DrawContinued
; End of function LevelSelect_MarkFields

; =============== S U B R O U T I N E =======================================

LevelSelect_DrawSoundNumber:
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$846,VRAM,WRITE),(VDP_control_port).l
                move.w  (Sound_test_sound).w,d0

LevelSelect_DrawContinued:
                move.b  d0,d2
                lsr.b   #4,d0
                bsr.s   sub_6D48
                move.b  d2,d0

sub_6D48:
                andi.w  #$F,d0
                cmpi.b  #$A,d0
                blo.s   loc_6D56
                addi.b  #4,d0

loc_6D56:
                addi.b  #$10,d0
                add.w   d3,d0
                move.w  d0,(a6)
                rts
; End of function LevelSelect_DrawSoundNumber

; =============== S U B R O U T I N E =======================================

LevelSelect_DrawIcon:
                move.w  (Level_select_option).w,d0
                lea     (LevSel_IconTable).l,a3
                lea     (a3,d0.w),a3
                lea     (RAM_start+$8C0).l,a1
                moveq   #0,d0
                move.b  (a3),d0
                lsl.w   #3,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                lea     (a1,d0.w),a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$B36,VRAM,WRITE),d0
                moveq   #4-1,d1
                moveq   #3-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     (Pal_S2LevelIcons).l,a1
                moveq   #0,d0
                move.b  (a3),d0
                lsl.w   #5,d0
                lea     (a1,d0.w),a1
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d1

loc_6DAA:
                move.l  (a1)+,(a2)+
                dbf     d1,loc_6DAA
                rts
; End of function LevelSelect_DrawIcon

; ---------------------------------------------------------------------------
LevSel_IconTable:
                dc.b    0,   0
                dc.b    7,   7
                dc.b    8,   8
                dc.b    6,   6
                dc.b    2,   2
                dc.b    5,   5
                dc.b    4,   4
                dc.b    1,   1
                dc.b    9,   9
                dc.b    $A,  $A
                dc.b    3,   3
                dc.b    $B,  $B
                dc.b    $B,  $B
                dc.b    $C,  $C
                dc.b    $E,   0
LevSel_MarkTable:                                       ; 4 bytes per level select entry
; line primary, 2*column ($E fields), line secondary, 2*column secondary (1 field)
                dc.b    1,   6,   1, $24
                dc.b    1,   6,   2, $24
                dc.b    4,   6,   4, $24
                dc.b    4,   6,   5, $24
                dc.b    7,   6,   7, $24
                dc.b    7,   6,   8, $24
                dc.b    $A,   6,  $A, $24
                dc.b    $A,   6,  $B, $24
                dc.b    $D,   6,  $D, $24
                dc.b    $D,   6,  $E, $24
                dc.b    $10,   6, $10, $24
                dc.b    $10,   6, $11, $24
                dc.b    $13,   6, $13, $24
                dc.b    $13,   6, $14, $24
                dc.b    $16,   6, $16, $24
                dc.b    $16,   6, $17, $24
                dc.b    $19,   6, $19, $24
                dc.b    $19,   6, $1A, $24
; --- second column ---
                dc.b    1, $2C,   1, $4A
                dc.b    1, $2C,   2, $4A
                dc.b    4, $2C,   4, $4A
                dc.b    4, $2C,   5, $4A
                dc.b    7, $2C,   7, $4A
                dc.b    7, $2C,   8, $4A
                dc.b    $A, $2C,  $A, $4A
                dc.b    $A, $2C,  $B, $4A
                dc.b    $D, $2C,  $D, $4A
                dc.b    $D, $2C,  $E, $4A
                dc.b    $10, $2C, $10, $4A
LevSel_MappingOffsets:
                dc.w    planeLocH28(3,1)
                dc.w    planeLocH28(3,4)
                dc.w    planeLocH28(3,7)
                dc.w    planeLocH28(3,$A)
                dc.w    planeLocH28(3,$D)
                dc.w    planeLocH28(3,$10)
                dc.w    planeLocH28(3,$13)
                dc.w    planeLocH28(3,$16)
                dc.w    planeLocH28(3,$19)
                dc.w    planeLocH28($16,1)
                dc.w    planeLocH28($16,4)
                dc.w    planeLocH28($16,7)
                dc.w    planeLocH28($16,$A)
                dc.w    planeLocH28($16,$D)
                dc.w    planeLocH28($16,$10)
                dc.w    planeLocH28($16,$13)

; =============== S U B R O U T I N E =======================================

CheckCheats:
                move.w  (Level_select_cheat_counter).w,d0
                adda.w  d0,a0
                move.w  (Sound_test_sound).w,d0
                cmp.b   (a0),d0
                bne.s   loc_6E88
                addq.w  #1,(Level_select_cheat_counter).w
                tst.b   1(a0)
                bne.s   loc_6E8E
                move.w  #(1<<8)|1,(a1)
                moveq   #signextendB(sfx_RingRight),d0
                jsr     (Play_SFX).l

loc_6E88:
                move.w  #0,(Level_select_cheat_counter).w

loc_6E8E:
                move.w  (Debug_mode_cheat_counter).w,d0
                adda.w  d0,a2
                move.w  (Sound_test_sound).w,d0
                cmp.b   (a2),d0
                bne.s   loc_6EC8
                addq.w  #1,(Debug_mode_cheat_counter).w
                tst.b   1(a2)
                bne.s   locret_6ECE
                tst.w   d2
                bne.s   loc_6EBA
                move.b  #$F,(Continue_count).w
                moveq   #signextendB(mus_Continue),d0
                jsr     (Play_Music).l
                bra.s   loc_6EC8
; ---------------------------------------------------------------------------

loc_6EBA:
                move.w  #7,(Chaos_emerald_count).w
                moveq   #signextendB(mus_Emerald),d0
                jsr     (Play_Music).l

loc_6EC8:
                move.w  #0,(Debug_mode_cheat_counter).w

locret_6ECE:
                rts
; End of function CheckCheats
