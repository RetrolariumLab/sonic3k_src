; Owner: game/blue_sphere/sk
; Responsibility: Blue Sphere level and serial-code entry widgets, digit state and conversion helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
BlueSphereCodeRow_DigitXPositions:
                dc.w    $10C
                dc.w    $114
                dc.w    $11C
                dc.w    $124
                dc.w    $134
                dc.w    $13C
                dc.w    $144
                dc.w    $14C
                dc.w    $15C
                dc.w    $164
                dc.w    $16C
                dc.w    $174
; ---------------------------------------------------------------------------

BlueSphereCodeRow_InitializeEditable:
                move.l  #BlueSphereCodeRow_UpdateEditorWhenActive,(a0)
                move.l  #BlueSphereDigit_InitializeEditableCode,d2
                bra.s   BSCode_InitLabelAndDigitSlots
; ---------------------------------------------------------------------------

BlueSphereCodeRow_InitializeGenerated:
                move.l  #BSCode_UpdateCodeOutsideEditor,(a0)
                move.l  #BlueSphereDigit_InitializeGeneratedCode,d2

BSCode_InitLabelAndDigitSlots:
                move.l  #Map_BlueSpheresText,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc,0,1),art_tile(a0)
                move.w  #$D4,x_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #$14,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #2,mapping_frame(a0)
                lea     BlueSphereCodeRow_DigitXPositions(pc),a2
                movea.l a0,a1
                moveq   #$C-1,d1

BlueSphereCodeRow_InitializeDigitSlot:
                lea     next_object(a1),a1
                move.l  d2,(a1)
                move.w  (a2)+,x_pos(a1)
                subi.w  #$C,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                dbf     d1,BlueSphereCodeRow_InitializeDigitSlot
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

BSCode_UpdateCodeOutsideEditor:
                tst.b   (Blue_spheres_menu_flag).w
                bpl.s   BlueSphereCodeRow_PrepareLevelCheckValue
                rts
; ---------------------------------------------------------------------------

BlueSphereCodeRow_PrepareLevelCheckValue:
                lea     (Stat_table).w,a2
                move.l  (Blue_spheres_current_level).w,(a2)
                tst.b   (Blue_spheres_progress_flag).w
                beq.s   BSCode_ComputeProgressTaggedCheckBits
                addi.l  #$7654321,(a2)

BSCode_ComputeProgressTaggedCheckBits:
                andi.l  #$7FFFFFF,(a2)
                moveq   #1,d6
                bsr.w   BlueSphere_ComputeCodeCheck
                move.w  d4,d0
                andi.w  #$3F,d0
                tst.b   (Blue_spheres_progress_flag).w
                beq.s   BSCode_EncodeAndFormatGeneratedCode
                ori.w   #$40,d0

BSCode_EncodeAndFormatGeneratedCode:
                eori.w  #$55,d0
                move.l  (Blue_spheres_current_level).w,d1
                addi.l  #$1234567,d1
                andi.l  #$7FFFFFF,d1
                swap    d1
                lsl.w   #5,d4
                andi.w  #$F800,d4
                or.w    d4,d1
                swap    d1
                ror.l   #6,d1
                eori.l  #$AAAAAAAA,d1
                movea.l a0,a1
                bsr.w   BSSelect_FormatUnsigned48BitCode
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

BlueSphereCodeRow_UpdateEditorWhenActive:
                tst.b   (Blue_spheres_menu_flag).w
                bmi.s   BlueSphereCodeRow_ValidateOnExactStart
                move.w  #0,$30(a0)
                rts
; ---------------------------------------------------------------------------

BlueSphereCodeRow_ValidateOnExactStart:
                move.b  (Ctrl_1_pressed).w,d0
                cmpi.b  #button_start_mask,d0
                bne.s   BlueSphereCodeRow_SelectDigitAndHandleUp
                bsr.w   BlueSphere_TryRestoreEnteredCode

BlueSphereCodeRow_SelectDigitAndHandleUp:
                movea.l a0,a1
                move.w  $30(a0),d0
                addq.w  #1,d0
                mulu.w  #object_size,d0
                adda.w  d0,a1
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc,0,1),art_tile(a1)
                move.b  (Ctrl_1_pressed).w,d1
                btst    #button_up,d1
                beq.s   BlueSphereCodeRow_HandleDownIncrement
                subq.b  #1,mapping_frame(a1)
                bcc.s   BlueSphereCodeRow_HandleDownIncrement
                move.b  #9,mapping_frame(a1)

BlueSphereCodeRow_HandleDownIncrement:
                btst    #1,d1
                beq.s   BlueSphereCodeRow_HandleCursorLeft
                addq.b  #1,mapping_frame(a1)
                cmpi.b  #$A,mapping_frame(a1)
                blo.s   BlueSphereCodeRow_HandleCursorLeft
                move.b  #0,mapping_frame(a1)

BlueSphereCodeRow_HandleCursorLeft:
                btst    #2,d1
                beq.s   BlueSphereCodeRow_HandleCursorRight
                subq.w  #1,$30(a0)
                bcc.s   BlueSphereCodeRow_HandleCursorRight
                move.w  #$B,$30(a0)

BlueSphereCodeRow_HandleCursorRight:
                btst    #3,d1
                beq.s   BlueSphereCodeRow_HighlightSelectedDigit
                addq.w  #1,$30(a0)
                cmpi.w  #$C,$30(a0)
                blo.s   BlueSphereCodeRow_HighlightSelectedDigit
                move.w  #0,$30(a0)

BlueSphereCodeRow_HighlightSelectedDigit:
                tst.b   (Blue_spheres_menu_flag).w
                bpl.s   BSCode_PlayEditDirectionSound
                movea.l a0,a1
                move.w  $30(a0),d0
                addq.w  #1,d0
                mulu.w  #object_size,d0
                adda.w  d0,a1
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc+$14,0,1),art_tile(a1)

BSCode_PlayEditDirectionSound:
                move.b  (Ctrl_1_pressed).w,d1
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask,d1
                beq.s   BlueSphereCodeRow_DrawEditorLabel
                moveq   #signextendB(sfx_WeatherMachine),d0
                jsr     (Play_SFX).l

BlueSphereCodeRow_DrawEditorLabel:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Decode the twelve decimal digits and validate the embedded 11-bit check value before restoring level, progress and stage
BlueSphere_TryRestoreEnteredCode:
                bsr.w   BSSelect_ParseUnsigned48BitCode
                eori.w  #$55,d0
                move.w  d0,d2
                andi.w  #$3F,d0
                eori.l  #$AAAAAAAA,d1
                rol.l   #6,d1
                swap    d1
                move.w  d1,d3
                andi.w  #$F800,d3
                lsr.w   #5,d3
                or.w    d0,d3
                andi.w  #$7FF,d3
                swap    d1
                subi.l  #$1234567,d1
                andi.w  #$40,d2
                beq.s   BSCode_CheckDecodedLevel
                addi.l  #$7654321,d1

BSCode_CheckDecodedLevel:
                andi.l  #$7FFFFFF,d1
                move.l  d1,(Stat_table).w
                lea     (Stat_table).w,a2
                moveq   #1,d6
                bsr.w   BlueSphere_ComputeCodeCheck
                andi.w  #$7FF,d4
                cmp.w   d4,d3
                bne.w   BSCode_RejectCodeAndExitEditor
                move.b  #0,(Blue_spheres_progress_flag).w
                tst.w   d2
                beq.s   BSCode_InstallLevelAndStageBytes
                subi.l  #$7654321,d1
                andi.l  #$7FFFFFF,d1
                move.b  #-1,(Blue_spheres_progress_flag).w

BSCode_InstallLevelAndStageBytes:
                move.l  d1,(Blue_spheres_current_level).w
                lea     (Blue_spheres_current_stage).w,a2
                move.l  d1,d0
                andi.b  #$7F,d0
                move.b  d0,(a2)+
                move.l  d1,d0
                add.l   d0,d0
                add.l   d1,d0
                addq.l  #1,d0
                moveq   #0,d2
                swap    d0
                move.w  d0,d2
                swap    d0
                divu.w  #$7F,d2
                move.w  d0,d2
                divu.w  #$7F,d2
                swap    d2
                move.b  d2,(a2)+
                move.l  d1,d0
                add.l   d0,d0
                add.l   d0,d0
                add.l   d1,d0
                addq.l  #2,d0
                moveq   #0,d2
                swap    d0
                move.w  d0,d2
                swap    d0
                divu.w  #$7E,d2
                move.w  d0,d2
                divu.w  #$7E,d2
                swap    d2
                move.b  d2,(a2)+
                move.l  d1,d0
                add.l   d0,d0
                add.l   d1,d0
                add.l   d0,d0
                add.l   d1,d0
                addq.l  #3,d0
                moveq   #0,d2
                swap    d0
                move.w  d0,d2
                swap    d0
                divu.w  #$7D,d2
                move.w  d0,d2
                divu.w  #$7D,d2
                swap    d2
                move.b  d2,(a2)+
                lea     (Normal_palette).w,a2
                bsr.w   BlueSphere_CopyProgressPalette
                moveq   #signextendB(sfx_Starpost),d0
                jsr     (Play_SFX).l
                andi.b  #$7F,(Blue_spheres_menu_flag).w
                move.b  #1,(Blue_spheres_option).w
                rts
; ---------------------------------------------------------------------------

BSCode_RejectCodeAndExitEditor:
                moveq   #signextendB(sfx_Error),d0
                jsr     (Play_SFX).l
                andi.b  #$7F,(Blue_spheres_menu_flag).w
                move.b  #1,(Blue_spheres_option).w
                rts
; End of function BlueSphere_TryRestoreEnteredCode

; =============== S U B R O U T I N E =======================================

; For each word, XOR into the accumulator, shift right once and conditionally XOR $8810
BlueSphere_ComputeCodeCheck:
                moveq   #0,d4

BlueSphereCodeCheck_XorWordAndShift:
                move.w  (a2)+,d5
                eor.w   d5,d4
                lsr.w   #1,d4
                bcc.s   BlueSphereCodeCheck_AdvanceWord
                eori.w  #$8810,d4

BlueSphereCodeCheck_AdvanceWord:
                dbf     d6,BlueSphereCodeCheck_XorWordAndShift
                rts
; End of function BlueSphere_ComputeCodeCheck

; ---------------------------------------------------------------------------

BlueSphereDigit_InitializeAlwaysVisible:
                bsr.s   BlueSphere_InitNumericSprite
                move.l  #BlueSphereDigit_DrawAlways,(a0)

BlueSphereDigit_DrawAlways:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

BlueSphere_InitNumericSprite:
                move.l  #Map_BlueSpheresNum,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc,0,1),art_tile(a0)
                move.w  #$80,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                rts
; End of function BlueSphere_InitNumericSprite

; ---------------------------------------------------------------------------

BlueSphereDigit_InitializeGeneratedCode:
                bsr.s   BlueSphere_InitNumericSprite
                move.l  #BSCode_UpdateGeneratedDigitVisibility,(a0)

BSCode_UpdateGeneratedDigitVisibility:
                tst.b   (Blue_spheres_menu_flag).w
                bpl.s   BlueSphereDigit_DrawGenerated
                rts
; ---------------------------------------------------------------------------

BlueSphereDigit_DrawGenerated:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

BlueSphereDigit_InitializeEditableCode:
                bsr.s   BlueSphere_InitNumericSprite
                move.l  #BlueSphereDigit_UpdateEditableVisibility,(a0)

BlueSphereDigit_UpdateEditableVisibility:
                tst.b   (Blue_spheres_menu_flag).w
                bmi.s   BlueSphereDigit_DrawEditable
                rts
; ---------------------------------------------------------------------------

BlueSphereDigit_DrawEditable:
                jmp     (Draw_Sprite).l
; End of function BlueSphereDigit_InitializeEditableCode
