; Owner: game/blue_sphere/sk
; Responsibility: Blue Sphere menu input, stage selection, stage-number widgets and numeric encoding helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

BlueSphereSelection_InitializeController:
                tst.b   (Blue_spheres_menu_flag).w
                bne.s   BlueSphereSelection_CreateMenuWidgets
                move.l  #BSSelect_CheckABCWithVectorGuard,(a0)

BSSelect_CheckABCWithVectorGuard:
; Bug: no idea what this was meant to be
                tst.b   (Vectors).w
                bne.s   BlueSphereSelection_ReturnFromABCCheck
                move.b  (Ctrl_1).w,d0
                cmpi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   BlueSphereSelection_EnableMenuFromABC

BlueSphereSelection_ReturnFromABCCheck:
                rts
; ---------------------------------------------------------------------------

BlueSphereSelection_EnableMenuFromABC:
                clr.b   (Ctrl_1_pressed).w
                moveq   #-1,d0
                move.w  d0,(Special_stage_spheres_left).w
                move.w  d0,(Special_stage_rings_left).w
                moveq   #signextendB(sfx_Starpost),d0
                jsr     (Play_SFX).l
                move    #$2700,sr
                lea     aGetBlueSpheres(pc),a1
                move.w  #$100,d2
                move.w  #make_art_tile(ArtTile_BlueSphere_TitleText,0,0),d6
                jsr     (SKCredits_BuildAndUploadText).l
                move    #$2300,sr

BlueSphereSelection_CreateMenuWidgets:
                move.l  #BSSelect_UpdateScrollAndOptions,(a0)
                move.l  #BlueSphereNumberRow_Initialize,(Dynamic_object_RAM+(object_size*3)).w
                move.w  #$C0,(Dynamic_object_RAM+(object_size*3)+y_pos).w
                move.b  #1,(Blue_spheres_menu_flag).w
                move.b  #0,(Blue_spheres_option).w
                move.l  #BlueSphereInitRotatingSelectionIcon,(Dynamic_object_RAM+(object_size*43)).w
                move.l  #BlueSphereInitRotatingSelectionIcon,(Dynamic_object_RAM+(object_size*44)).w
                bset    #0,(Dynamic_object_RAM+(object_size*44)+render_flags).w
                tst.b   (Blue_spheres_mode).w
                beq.s   BSSelect_ShowCodeForCompletedStage
                move.w  #$B0,(Dynamic_object_RAM+(object_size*3)+y_pos).w
                move.l  #BlueSphereCodeRow_InitializeEditable,(Dynamic_object_RAM+(object_size*15)).w
                move.w  #$144,(Dynamic_object_RAM+(object_size*15)+y_pos).w
                move.l  #BlueSphereCodeRow_InitializeGenerated,(Dynamic_object_RAM+(object_size*28)).w
                move.w  #$144,(Dynamic_object_RAM+(object_size*28)+y_pos).w
                move.l  #BlueSphereInitStartRowCaption,(Dynamic_object_RAM+(object_size*42)).w
                move.b  #1,(Blue_spheres_option).w
                rts
; ---------------------------------------------------------------------------

BSSelect_ShowCodeForCompletedStage:
                tst.w   (Special_stage_spheres_left).w
                bne.s   BSSelect_WidgetSetupReturn
                tst.w   (Special_stage_rings_left).w
                bne.s   BSSelect_WidgetSetupReturn
                move.l  #BlueSphereCodeRow_InitializeGenerated,(Dynamic_object_RAM+(object_size*28)).w
                move.w  #$144,(Dynamic_object_RAM+(object_size*28)+y_pos).w

BSSelect_WidgetSetupReturn:
                rts
; ---------------------------------------------------------------------------

BSSelect_UpdateScrollAndOptions:
                tst.b   (Blue_spheres_mode).w
                beq.w   BSSelect_StartOnStartAlone
                tst.w   (V_scroll_value).w
                beq.s   BlueSphereSelection_HandleOptionUp
                addq.w  #1,(V_scroll_value).w
                btst    #0,(V_scroll_value_FG+1).w
                bne.s   BSSelect_PrepareCharacterRise
                addq.w  #1,(V_scroll_value_BG).w

BSSelect_PrepareCharacterRise:
                lea     (Reserved_object_3).w,a1
                moveq   #4-1,d1

BlueSphereSelection_RaiseCharacterSlot:
                subq.w  #1,y_pos(a1)
                lea     next_object(a1),a1
                dbf     d1,BlueSphereSelection_RaiseCharacterSlot

BlueSphereSelection_HandleOptionUp:
                tst.b   (Blue_spheres_menu_flag).w
                bmi.s   BlueSphereSelection_CheckPlayableOption
                move.b  (Ctrl_1_pressed).w,d1
                btst    #0,d1
                beq.s   BlueSphereSelection_HandleOptionDown
                tst.b   (Blue_spheres_option).w
                beq.s   BlueSphereSelection_HandleOptionDown
                subq.b  #1,(Blue_spheres_option).w
                moveq   #signextendB(sfx_WeatherMachine),d0
                jsr     (Play_SFX).l

BlueSphereSelection_HandleOptionDown:
                btst    #1,d1
                beq.s   BlueSphereSelection_CheckPlayableOption
                cmpi.b  #2,(Blue_spheres_option).w
                bhs.s   BlueSphereSelection_CheckPlayableOption
                addq.b  #1,(Blue_spheres_option).w
                moveq   #signextendB(sfx_WeatherMachine),d0
                jsr     (Play_SFX).l
                cmpi.b  #2,(Blue_spheres_option).w
                bne.s   BlueSphereSelection_CheckPlayableOption
                ori.b   #$80,(Blue_spheres_menu_flag).w
                clr.b   (Ctrl_1_pressed).w

BlueSphereSelection_CheckPlayableOption:
                cmpi.b  #1,(Blue_spheres_option).w
                bne.s   BlueSphereSelection_ReturnFromMenuInput

; A simultaneous press of another button fails the exact pressed-byte comparison
BSSelect_StartOnStartAlone:
                move.b  (Ctrl_1_pressed).w,d0
                cmpi.b  #button_start_mask,d0
                bne.s   BlueSphereSelection_ReturnFromMenuInput
                move.b  #0,(Special_bonus_entry_flag).w
                move.b  #1,(Blue_spheres_stage_flag).w
                move.w  (Player_option).w,(Player_mode).w
                move.b  #3,(Life_count).w
                move.b  #0,(SK_special_stage_flag).w
                move.b  #0,(Current_special_stage).w
                move.b  #GameMode_SpecialStage,(Game_mode).w

BlueSphereSelection_ReturnFromMenuInput:
                rts
; ---------------------------------------------------------------------------

BlueSphereNumberRow_Initialize:
                move.l  #Map_BlueSpheresText,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc,0,1),art_tile(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #$14,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  y_pos(a0),d3
                addi.w  #$10,d3
                movea.l a0,a1
                move.b  #$A,next_object+mapping_frame(a1)
                move.w  #$F7,d2
                moveq   #$B-1,d1

BSSelect_InitNumberSlot:
                lea     next_object(a1),a1
                move.l  #BlueSphereDigit_InitializeAlwaysVisible,(a1)
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                addq.w  #8,d2
                dbf     d1,BSSelect_InitNumberSlot
                move.b  #$B,mapping_frame(a1)
                move.l  #BSSelect_SelectStageOrLevelNumber,(a0)

BSSelect_SelectStageOrLevelNumber:
                tst.b   (Blue_spheres_mode).w
                beq.s   BlueSphereNumberRow_FormatPackedStage
                tst.b   (Blue_spheres_option).w
                bne.s   BSSelect_CheckProgressForAltDisplay
                tst.b   (Blue_spheres_progress_flag).w
                bne.s   BlueSphereNumberRow_FormatCurrentLevel

BlueSphereNumberRow_FormatPackedStage:
                move.l  (Blue_spheres_current_stage).w,d1
                lsl.b   #1,d1
                lsl.w   #1,d1
                swap    d1
                lsl.b   #1,d1
                lsr.w   #1,d1
                swap    d1
                lsr.l   #2,d1
                andi.l  #$FFFFFFF,d1
                bsr.w   BlueSphereSetFixedWidthNineDigitWidget
                move.b  #1,mapping_frame(a0)
                bra.s   BlueSphereNumberRow_Draw
; ---------------------------------------------------------------------------

BSSelect_CheckProgressForAltDisplay:
                tst.b   (Blue_spheres_progress_flag).w
                bne.s   BlueSphereNumberRow_FormatPackedStage

BlueSphereNumberRow_FormatCurrentLevel:
                move.l  (Blue_spheres_current_level).w,d1
                addq.l  #1,d1
                andi.l  #$7FFFFFF,d1
                bsr.w   BlueSphere_CenterLevelDigits
                move.b  #0,mapping_frame(a0)

BlueSphereNumberRow_Draw:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

BlueSphereSetFixedWidthNineDigitWidget:
                andi.l  #$FFFFFFF,d1
                movea.l a0,a1
                lea     next_object(a1),a1
                lea     BSSelect_NineDigitDecimalDivisors(pc),a2
                moveq   #8,d6

BlueSphereDigits_FixedWidthNextPlace:
                lea     next_object(a1),a1
                moveq   #0,d2
                move.l  (a2)+,d3

BSSelect_SubtractFixedWidthDivisor:
                sub.l   d3,d1
                bcs.s   BlueSphereDigits_FixedWidthStoreDigit
                addq.w  #1,d2
                bra.s   BSSelect_SubtractFixedWidthDivisor
; ---------------------------------------------------------------------------

BlueSphereDigits_FixedWidthStoreDigit:
                add.l   d3,d1
                move.b  d2,mapping_frame(a1)
                dbf     d6,BlueSphereDigits_FixedWidthNextPlace
                move.w  #$F7,d2
                moveq   #$A,d1
                movea.l a0,a1

BlueSphereDigits_FixedWidthPositionSlot:
                lea     next_object(a1),a1
                move.w  d2,x_pos(a1)
                addq.w  #8,d2
                dbf     d1,BlueSphereDigits_FixedWidthPositionSlot
                rts
; End of function BlueSphereSetFixedWidthNineDigitWidget

; =============== S U B R O U T I N E =======================================

; Display the significant digits of the 27-bit level across nine digit objects and two padding objects
BlueSphere_CenterLevelDigits:
                andi.l  #$7FFFFFF,d1
                movea.l a0,a1
                lea     next_object(a1),a1
                lea     BSSelect_NineDigitDecimalDivisors(pc),a2
                moveq   #8,d6
                moveq   #0,d4

BlueSphereDigits_CenteredNextPlace:
                lea     next_object(a1),a1
                moveq   #0,d2
                move.l  (a2)+,d3

BlueSphereDigits_CenteredSubtractDivisor:
                sub.l   d3,d1
                bcs.s   BSSelect_CheckCenteredSignificance
                addq.w  #1,d2
                bra.s   BlueSphereDigits_CenteredSubtractDivisor
; ---------------------------------------------------------------------------

BSSelect_CheckCenteredSignificance:
                add.l   d3,d1
                tst.w   d2
                beq.s   BSSelect_SuppressCenteredLeadingZero
                tst.w   d4
                bne.s   BSSelect_SuppressCenteredLeadingZero
                move.w  d6,d4
                addq.w  #1,d4

BSSelect_SuppressCenteredLeadingZero:
                tst.w   d4
                bne.s   BSSelect_StoreCenteredDigitAndPrepX
                moveq   #$A,d2

BSSelect_StoreCenteredDigitAndPrepX:
                move.b  d2,mapping_frame(a1)
                dbf     d6,BlueSphereDigits_CenteredNextPlace
                move.w  #$F7,d2
                move.w  d4,d0
                subi.w  #9,d0
                neg.w   d0
                move.w  d0,d1
                lsl.w   #2,d0
                add.w   d0,d2
                movea.l a0,a1

BSSelect_PlaceCenteredLeadingSlots:
                lea     next_object(a1),a1
                move.w  d2,x_pos(a1)
                dbf     d1,BSSelect_PlaceCenteredLeadingSlots

BSSelect_PlaceCenteredSignificantSlots:
                lea     next_object(a1),a1
                addq.w  #8,d2
                move.w  d2,x_pos(a1)
                dbf     d4,BSSelect_PlaceCenteredSignificantSlots
                rts
; End of function BlueSphere_CenterLevelDigits

; =============== S U B R O U T I N E =======================================

; Use the low byte to format up to two significant digits in the four-child widget
BlueSphere_CenterDifficultyDigits:
                andi.l  #$FF,d1
                movea.l a0,a1
                lea     next_object(a1),a1
                lea     BlueSphereDigits_TwoPlaceDecimalDivisors(pc),a2
                moveq   #1,d6
                moveq   #0,d4

BlueSphereDifficultyDigits_NextPlace:
                lea     next_object(a1),a1
                moveq   #0,d2
                move.l  (a2)+,d3

BSSelect_SubtractDifficultyDivisor:
                sub.l   d3,d1
                bcs.s   BSSelect_CheckDifficultySignificance
                addq.w  #1,d2
                bra.s   BSSelect_SubtractDifficultyDivisor
; ---------------------------------------------------------------------------

BSSelect_CheckDifficultySignificance:
                add.l   d3,d1
                tst.w   d2
                beq.s   BSSelect_SuppressDifficultyLeadingZero
                tst.w   d4
                bne.s   BSSelect_SuppressDifficultyLeadingZero
                move.w  d6,d4
                addq.w  #1,d4

BSSelect_SuppressDifficultyLeadingZero:
                tst.w   d4
                bne.s   BSSelect_StoreDifficultyDigitAndPrepX
                moveq   #$A,d2

BSSelect_StoreDifficultyDigitAndPrepX:
                move.b  d2,$22(a1)
                dbf     d6,BlueSphereDifficultyDigits_NextPlace
                move.w  #$113,d2
                move.w  d4,d0
                subq.w  #2,d0
                neg.w   d0
                move.w  d0,d1
                lsl.w   #2,d0
                add.w   d0,d2
                movea.l a0,a1

BSSelect_PlaceDifficultyLeadingSlots:
                lea     next_object(a1),a1
                move.w  d2,x_pos(a1)
                dbf     d1,BSSelect_PlaceDifficultyLeadingSlots

BSSelect_PlaceDifficultySignificantSlots:
                lea     next_object(a1),a1
                addq.w  #8,d2
                move.w  d2,x_pos(a1)
                dbf     d4,BSSelect_PlaceDifficultySignificantSlots
                rts
; End of function BlueSphere_CenterDifficultyDigits

; ---------------------------------------------------------------------------
                dc.l    1000000000
BSSelect_NineDigitDecimalDivisors:  dc.l    100000000
                dc.l    10000000
                dc.l    1000000
                dc.l    100000
                dc.l    10000
                dc.l    1000
                dc.l    100
BlueSphereDigits_TwoPlaceDecimalDivisors:   dc.l    10
                dc.l    1
; ---------------------------------------------------------------------------

BSSelect_FormatUnsigned48BitCode:
                moveq   #$C-1,d6
                lea     BSSelect_Code48BitDecimalWeights(pc),a2

BlueSphereCodeDigits_PrepareFormatPlace:
                lea     next_object(a1),a1
                moveq   #0,d4
                move.w  (a2)+,d2
                move.l  (a2)+,d3

BlueSphereCodeDigits_Subtract48BitPlace:
                sub.l   d3,d1
                subx.w  d2,d0
                bcs.s   BSSelect_RestoreAndStoreCodeDigit
                addq.w  #1,d4
                bra.s   BlueSphereCodeDigits_Subtract48BitPlace
; ---------------------------------------------------------------------------

BSSelect_RestoreAndStoreCodeDigit:
                add.l   d3,d1
                addx.w  d2,d0
                move.b  d4,mapping_frame(a1)
                dbf     d6,BlueSphereCodeDigits_PrepareFormatPlace
                rts
; ---------------------------------------------------------------------------

BSSelect_ParseUnsigned48BitCode:
                movea.l a0,a1
                moveq   #0,d0
                moveq   #0,d1
                moveq   #$C-1,d6
                lea     BSSelect_Code48BitDecimalWeights(pc),a2

BlueSphereCodeDigits_PrepareParsePlace:
                lea     next_object(a1),a1
                moveq   #0,d4
                move.b  mapping_frame(a1),d4
                move.w  (a2)+,d2
                move.l  (a2)+,d3
                subq.w  #1,d4
                bcs.s   BlueSphereCodeDigits_AdvanceParsePlace

BSSelect_Add48BitDigitWeight:
                add.l   d3,d1
                addx.w  d2,d0
                dbf     d4,BSSelect_Add48BitDigitWeight

BlueSphereCodeDigits_AdvanceParsePlace:
                dbf     d6,BlueSphereCodeDigits_PrepareParsePlace
                rts
; ---------------------------------------------------------------------------
BSSelect_Code48BitDecimalWeights:
                dc.w    $17
                dc.l    $4876E800
                dc.w    2
                dc.l    $540BE400
                dc.w    0
                dc.l    1000000000
                dc.w    0
                dc.l    100000000
                dc.w    0
                dc.l    10000000
                dc.w    0
                dc.l    1000000
                dc.w    0
                dc.l    100000
                dc.w    0
                dc.l    10000
                dc.w    0
                dc.l    1000
                dc.w    0
                dc.l    100
                dc.w    0
                dc.l    10
                dc.w    0
                dc.l    1
