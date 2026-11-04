; Owner: game/blue_sphere/sk
; Responsibility: Blue Sphere title mode, display setup, serial and date text and title helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

BlueSpheresTitle:
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                jsr     (Pal_FadeToBlack).l
                bsr.w   BlueSphere_ResetVideoAndSceneRAM
                bsr.w   BlueSphere_InitSelectionFromSerial
                lea     (Target_palette).w,a2
                bsr.w   BlueSphere_CopyProgressPalette
                move.l  #vdpComm(tiles_to_bytes(ArtTile_BlueSphere_TitleText),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_CreditsText).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_BlueSphere_BG),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_BlueSphereSKLogo).l,a0
                jsr     (Nem_Decomp).l
                lea     (RAM_start).l,a1
                lea     (ArtKos_BlueSphereChar).l,a0
                jsr     (Kos_Decomp).l
                lea     (ArtKos_BlueSphereCharSprite).l,a0
                jsr     (Kos_Decomp).l
                move.w  a1,d3
                lsr.w   #1,d3
                move.l  #RAM_start&$FFFFFF,d1
                move.w  #0,d2
                jsr     (Add_To_DMA_Queue).l
                lea     (RAM_start+$4000).l,a1
                lea     (ArtKos_BlueSphereNormalText).l,a0
                jsr     (Kos_Decomp).l
                move.l  #(RAM_start+$4000)&$FFFFFF,d1
                move.w  #tiles_to_bytes(ArtTile_BlueSphere_Misc),d2
                move.w  #$6D0,d3
                jsr     (Add_To_DMA_Queue).l
                lea     (Level_layout_header).w,a1
                lea     (MapEni_BlueSphereTitleFG).l,a0
                move.w  #make_art_tile($000,1,0),d0
                jsr     (Eni_Decomp).l
                lea     (Level_layout_header).w,a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$380,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #16-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     (Level_layout_header).w,a1
                lea     (MapEni_BlueSphereTitleBG).l,a0
                move.w  #make_art_tile(ArtTile_BlueSphere_BG,2,0),d0
                jsr     (Eni_Decomp).l
                lea     (Level_layout_header).w,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table+$09C,VRAM,WRITE),d0
                moveq   #12-1,d1
                moveq   #8-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     aGetBlueSpheres(pc),a1
                tst.b   (Blue_spheres_menu_flag).w
                bne.s   BSTitle_UploadHeadingAndSetScroll
                lea     aNoWayNoWayNoWa(pc),a1
                move.w  #1,(Player_option).w
                move.l  #$FFF0FFF8,(V_scroll_value).w

BSTitle_UploadHeadingAndSetScroll:
                move.w  #$100,d2
                move.w  #make_art_tile(ArtTile_BlueSphere_TitleText,0,0),d6
                jsr     (SKCredits_BuildAndUploadText).l
                tst.b   (Blue_spheres_mode).w
                bne.s   BSTitle_InstallActorsAndFadeIn
                move.l  #$FFF0FFF8,(V_scroll_value).w

BSTitle_InstallActorsAndFadeIn:
                move.l  #BlueSphereSelection_InitializeController,(Player_1).w
                move.l  #BlueSphereCopyright_Initialize,(Player_2).w
                move.l  #BlueSphereTitleCharacters_Initialize,(Reserved_object_3).w
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                moveq   #signextendB(mus_Continue),d0
                jsr     (Play_Music).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Pal_FadeFromBlack).l

BSTitle_RunTitleUntilModeChanges:
                move.b  #VInt_ID_1A,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                jsr     (Wait_VSync).l
                bsr.w   BlueSphere_ScrollTop64FgLines
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                jsr     (Process_Kos_Module_Queue).l
                cmpi.b  #GameMode_BlueSpheresTitle,(Game_mode).w
                beq.s   BSTitle_RunTitleUntilModeChanges
                rts

; =============== S U B R O U T I N E =======================================

; Use the progress flag to select one complete 128-byte palette for the caller's destination
BlueSphere_CopyProgressPalette:
                lea     (Pal_SpheresTitle_2).l,a1
                tst.b   (Blue_spheres_progress_flag).w
                bne.s   BSTitle_Set64WordPaletteCount
                lea     (Pal_SpheresTitle_1).l,a1

BSTitle_Set64WordPaletteCount:
                moveq   #bytesToWcnt($80),d0

BSTitle_CopyFullPalette:
                move.w  (a1)+,(a2)+
                dbf     d0,BSTitle_CopyFullPalette
                rts
; End of function BlueSphere_CopyProgressPalette

; ---------------------------------------------------------------------------
Pal_SpheresTitle_1:
                binclude "data/General/Blue Sphere/Palettes/Title 1.bin"
                even
Pal_SpheresTitle_2:
                binclude "data/General/Blue Sphere/Palettes/Title 2.bin"
                even
aNoWayNoWayNoWa:
                dc.b    "NO WAY!    NO WAY!    NO WAY!    NO WAY?   ",0
                even
aGetBlueSpheres:
                dc.b    "GET   BLUE   SPHERES !                            ",0
                even

; =============== S U B R O U T I N E =======================================

; Subtract two from foreground scroll on each title update
BlueSphere_ScrollTop64FgLines:
                lea     (H_scroll_buffer).w,a1
                moveq   #$40-1,d1

                .loop:
                subq.w  #2,(a1)
                addq.w  #4,a1
                dbf     d1,.loop
                rts
; End of function BlueSphere_ScrollTop64FgLines

; =============== S U B R O U T I N E =======================================

; Recognized Sonic 1 serials use normal selection. Other cartridges seed a challenge from their header
BlueSphere_InitSelectionFromSerial:
                lea     (BlueSpheresSerialsText).l,a1
                moveq   #4-1,d1

BSTitle_Begin13ByteSerialWindow:
                lea     (LockonSerialNumber).l,a0
                moveq   #0,d3
                moveq   #$D-1,d2

BSTitle_CompareByteAndLatchMismatch:
                move.b  (a1)+,d0
                cmp.b   (a0)+,d0
                beq.s   BSTitle_FinishOrAdvanceSerialWindow
                moveq   #1,d3

BSTitle_FinishOrAdvanceSerialWindow:
                dbf     d2,BSTitle_CompareByteAndLatchMismatch
                tst.b   d3
                beq.s   BSTitle_EnableModeAndCheckReset
                dbf     d1,BSTitle_Begin13ByteSerialWindow
                move.b  #0,(Blue_spheres_mode).w
                move.b  #-1,(Blue_spheres_progress_flag).w
                bsr.s   BlueSphere_DeriveLevelFromHeader

BSTitle_SerialModeInitReturn:
                rts
; ---------------------------------------------------------------------------

BSTitle_EnableModeAndCheckReset:
                move.b  #1,(Blue_spheres_mode).w
                tst.b   (Blue_spheres_menu_flag).w
                bne.s   BSTitle_SerialModeInitReturn
                clr.b   (Blue_spheres_progress_flag).w
                move.l  #0,(Blue_spheres_current_level).w
                move.l  #$10203,(Blue_spheres_current_stage).w
                rts
; End of function BlueSphere_InitSelectionFromSerial

; ---------------------------------------------------------------------------
BlueSpheresSerialsText:
                dc.b    "GM 00001009-0"                 ; Sonic 1 REV00/1
                dc.b    "GM 00004049-0"
                even

; =============== S U B R O U T I N E =======================================

; Fold the serial, date and other header fields to 27 bits, then derive four modular stage indices
BlueSphere_DeriveLevelFromHeader:
                lea     (LockonSerialNumber).l,a1
                moveq   #$B-1,d1

BSTitle_FindFirstNonzeroSerialDigit:
                move.b  (a1),d0
                subi.b  #'0',d0
                beq.s   BSTitle_SkipZeroOrNondigit
                cmpi.b  #10,d0
                blo.s   BSTitle_ClearSerialAccumulator

BSTitle_SkipZeroOrNondigit:
                addq.w  #1,a1
                dbf     d1,BSTitle_FindFirstNonzeroSerialDigit

BSTitle_ClearSerialAccumulator:
                moveq   #0,d2

; Decimal accumulation wraps to a word on each accepted digit
BSTitle_AccumulateSerialDigits:
                move.b  (a1)+,d0
                subi.b  #$30,d0
                cmpi.b  #$A,d0
                bhs.s   BSTitle_FinishDigitsAndPackHeader
                andi.b  #$F,d0
                mulu.w  #$A,d2
                add.w   d0,d2

BSTitle_FinishDigitsAndPackHeader:
                dbf     d1,BSTitle_AccumulateSerialDigits
                andi.w  #$7FFF,d2
                moveq   #0,d6
                move.w  d2,d6
                andi.w  #$3F,d6
                lea     (BlueSpheresMonthText).l,a2
                move.l  (LockonDate).l,d0
                moveq   #$E,d1

BSTitle_MapDateAndPackSerialHeader:
                cmp.l   (a2)+,d0
                dbeq    d1,BSTitle_MapDateAndPackSerialHeader
                subi.w  #$E,d1
                neg.w   d1
                andi.w  #$F,d1
                lsl.w   #4,d6
                or.b    d1,d6
                move.w  d2,d0
                lsr.w   #6,d0
                andi.w  #$F,d0
                lsl.w   #4,d6
                or.b    d0,d6
                move.b  (Lockon_OverseasTitleParityByte).l,d1
                andi.b  #1,d1
                lsl.l   #1,d6
                or.b    d1,d6
                lea     (Lockon_CopyrightYearDigits).l,a1
                moveq   #0,d0
                move.b  (a1)+,d0
                subi.b  #$30,d0
                mulu.w  #$A,d0
                move.b  (a1)+,d1
                subi.b  #$30,d1
                add.b   d1,d0
                subi.b  #$58,d0
                andi.b  #7,d0
                lsl.l   #3,d6
                or.b    d0,d6
                rol.w   #6,d2
                andi.w  #$1F,d2
                lsl.l   #5,d6
                or.b    d2,d6
                move.w  (Lockon_ROMEndUpperWord).l,d0
                lsr.b   #3,d0
                andi.b  #3,d0
                lsl.l   #2,d6
                or.b    d0,d6
                moveq   #0,d1
                cmpi.w  #"EG",(Lockon_CopyrightEGProbe).l
                beq.s   BSTitle_Finish27BitLevelAndResidues
                moveq   #1,d1

BSTitle_Finish27BitLevelAndResidues:
                lsl.l   #1,d6
                or.b    d1,d6
                move.b  (Blue_spheres_header_flag).w,d1
                andi.b  #1,d1
                lsl.l   #1,d6
                or.b    d1,d6
                andi.l  #$7FFFFFF,d6
                move.l  d6,(Blue_spheres_current_level).w
                lea     (Blue_spheres_current_stage).w,a2
                move.l  d6,d0
                andi.b  #$7F,d0
                move.b  d0,(a2)+
                move.l  d6,d0
                add.l   d0,d0
                add.l   d6,d0
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
                move.l  d6,d0
                add.l   d0,d0
                add.l   d0,d0
                add.l   d6,d0
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
                move.l  d6,d0
                add.l   d0,d0
                add.l   d6,d0
                add.l   d0,d0
                add.l   d6,d0
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
                rts
; End of function BlueSphere_DeriveLevelFromHeader

; ---------------------------------------------------------------------------
BlueSpheresMonthText:
                dc.b    ".JAN"
                dc.b    ".FEB"
                dc.b    ".MAR"
                dc.b    ".APR"
                dc.b    ".MAY"
                dc.b    ".JUN"
                dc.b    ".JUL"
                dc.b    ".AUG"
                dc.b    ".SEP"
                dc.b    ".OCT"
                dc.b    ".NOV"
                dc.b    ".DEC"
                dc.b    ".   "
                dc.b    "    "
                dc.b    "...."
