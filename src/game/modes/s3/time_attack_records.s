; Owner: game/modes/s3
; Responsibility: Competition time-attack record selection, record display, rank and zone-name resources
; Source provenance and ranges: config/reconstruction/source_layout.json
TimeAttack_Records:
                jsr     (Pal_FadeToBlack).l
                move    #$2700,sr
                move.w  (VDP_reg_1_command).w,d0
                andi.b  #$BF,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Clear_DisplayData).l
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8230,(a6)
                move.w  #$8407,(a6)
                move.w  #$8700,(a6)
                move.w  #$8B00,(a6)
                move.w  #$8C89,(a6)
                move.w  #$9011,(a6)
                jsr     Menu_FillPlaneAWithPriorityBlankTiles(pc)
                move.w  #VRAM_Plane_A_Name_Table+$1AA,d0
                jsr     Menu_ClearNineByEightTileArea(pc)
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                clr.w   (Level_frame_counter).w
                clr.w   (Competition_mode).w
                clr.b   (Level_started_flag).w
                move.w  #$1E,(Events_bg+$16).w
                move.w  #$FF78,(H_scroll_buffer).w
                lea     (MapEni_S3MenuBG).l,a0
                lea     (RAM_start).l,a1
                move.w  #make_art_tile(ArtTile_S3MenuBG,0,0),d0
                jsr     (Eni_Decomp).l
                lea     S3TimeRecords_InitialVRAMRectangles(pc),a0
                jsr     Copy_Listed_Data_To_VRAM(pc)
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                subi.w  #$E,d0
                lsl.w   #2,d0
                lea     CompTimeAttack_LevelNameMaps(pc),a1
                movea.l (a1,d0.w),a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$826,VRAM,WRITE),d0
                moveq   #13-1,d1
                moveq   #2-1,d2
                jsr     (Plane_Map_To_VRAM).l
                jsr     S3Comp_DrawLapTimesAndTopRecords(pc)
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Competition_Text),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_ContinueDigits).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Competition_Text+$14),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_S38x16Font).l,a0
                jsr     (Nem_Decomp).l
                lea     (ArtKos_S3MenuBG).l,a0          ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source
                movea.w #tiles_to_bytes(ArtTile_S3MenuBG),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.l  #S3SS_NoOpVBlankReturn,(MenuVInterruptCallbackPointer).w
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (ArtKos_CompetitionLevel).l,a0  ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source, used by the next two KosArt_To_VDP also
                movea.w #tiles_to_bytes(ArtTile_Competition_LevSel),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                lea     (ArtKos_CompetitionResults).l,a0  ; Decompress source
                movea.w #tiles_to_bytes(ArtTile_Competition_Results),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                lea     (ArtKos_CompetitionPlayer).l,a0  ; Decompress source
                movea.w #tiles_to_bytes(ArtTile_Competition_CharSel),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (ArtKos_SSResultsGeneral).l,a0
                lea     (RAM_start+$20).l,a1
                jsr     (Kos_Decomp).l
                lea     (ArtKos_SSResultsTKIcons).l,a0
                jsr     (Kos_Decomp).l
                move    #$2700,sr
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Competition_STKIcons),VRAM,WRITE),(VDP_control_port).l
                lea     (RAM_start+$EE0).l,a0
                lea     (VDP_data_port).l,a6
                move.w  #bytesToLcnt(tiles_to_bytes($1B)),d0

S3TimeRecords_UploadIconsAndPrepPalette:
                move.l  (a0)+,(a6)
                dbf     d0,S3TimeRecords_UploadIconsAndPrepPalette
                lea     (Pal_CompetitionMenuBG).l,a0
                lea     (Target_palette).w,a1
                moveq   #bytesToLcnt(Target_palette_line_2-Target_palette),d0

S3TimeRecords_CopyBackgroundPalette:
                move.l  (a0)+,(a1)+
                dbf     d0,S3TimeRecords_CopyBackgroundPalette
                lea     Pal_Competition2(pc),a0
                moveq   #bytesToLcnt(Target_palette_line_4-Target_palette_line_2),d0

S3TimeRecords_CopyMiddlePaletteLines:
                move.l  (a0)+,(a1)+
                dbf     d0,S3TimeRecords_CopyMiddlePaletteLines
                lea     Pal_CompetitionTimeAttack(pc),a0
                moveq   #bytesToLcnt(Target_palette_end-Target_palette_line_4),d0

S3TimeRecords_CopyPaletteAndPrepActors:
                move.l  (a0)+,(a1)+
                dbf     d0,S3TimeRecords_CopyPaletteAndPrepActors
                lea     (Object_RAM).w,a0
                lea     CompetitionTimeAttack_ActorRecords(pc),a1
                move.w  (a1)+,d0

S3TimeRecords_InitRecordActorsAndFadeIn:
                move.l  (a1)+,(a0)
                move.l  #Map_CompetitionSelect,mappings(a0)
                move.w  (a1),x_pos(a0)
                move.w  (a1)+,objoff_12(a0)
                move.w  (a1),y_pos(a0)
                move.w  (a1)+,objoff_16(a0)
                move.w  (a1)+,d1
                addi.w  #make_art_tile(ArtTile_Competition_LevSel,0,1),d1
                move.w  d1,art_tile(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,$2E(a0)
                lea     next_object(a0),a0
                dbf     d0,S3TimeRecords_InitRecordActorsAndFadeIn
                jsr     (Init_SpriteTable).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                moveq   #signextendB(mus_Continue),d0
                jsr     (Play_Music).l
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Pal_FadeFromBlack).l

S3TimeRecords_RunFrameAndBlinkRecord:
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                addq.w  #1,(Level_frame_counter).w
                move.w  (SceneColumnOrCompBlinkVRAM).w,d7
                beq.s   S3TimeRecords_Tick30FrameExitLockout
                btst    #3,(Level_frame_counter+1).w
                bne.s   S3TimeRecords_RedrawHighlightedTime
                lea     (Plane_buffer+$20).w,a1
                jsr     S3CompZones_Upload8By2TimeTiles(pc)
                bra.s   S3TimeRecords_Tick30FrameExitLockout
; ---------------------------------------------------------------------------

S3TimeRecords_RedrawHighlightedTime:
                move.l  (SceneAuxiliaryXOrCompetitionTime).w,d6
                jsr     S3Comp_DrawPackedTime(pc)

S3TimeRecords_Tick30FrameExitLockout:
                tst.w   (Events_bg+$16).w
                beq.s   S3TimeRecordMenu_ExitRecordsOnStartAOrC
                subq.w  #1,(Events_bg+$16).w
                bra.s   S3TimeRecords_RenderActorsAndRepeat
; ---------------------------------------------------------------------------

S3TimeRecordMenu_ExitRecordsOnStartAOrC:
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_start_mask|button_A_mask|button_C_mask,d0
                beq.s   S3TimeRecords_RenderActorsAndRepeat
                move.b  #GameMode_CompetitionLevelSelect+$80,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

S3TimeRecords_RenderActorsAndRepeat:
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                bra.s   S3TimeRecords_RunFrameAndBlinkRecord

; =============== S U B R O U T I N E =======================================

; Draw six current lap times and three saved records for the selected zone
S3Comp_DrawLapTimesAndTopRecords:
                lea     ((RAM_start+$7828)&$FFFFFF).l,a0
                move.w  #VRAM_Plane_A_Name_Table+$15A,d7
                moveq   #6-1,d0
                jsr     S3CompResults_DrawFiveRaceTimes(pc)
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                subi.w  #$E,d0
                lsl.w   #4,d0
                lea     (Competition_saved_data).w,a0
                adda.w  d0,a0
                move.w  #VRAM_Plane_A_Name_Table+$95A,d7
                move.l  (a0)+,d6
                jsr     S3Comp_DrawPackedTime(pc)
                addi.w  #$180,d7
                move.l  (a0)+,d6
                jsr     S3Comp_DrawPackedTime(pc)
                addi.w  #$180,d7
                move.l  (a0)+,d6
                jsr     S3Comp_DrawPackedTime(pc)
                clr.w   (SceneColumnOrCompBlinkVRAM).w
                rts
; End of function S3Comp_DrawLapTimesAndTopRecords

; ---------------------------------------------------------------------------

S3TimeRecords_InitIconFromSavedCharacter:
                move.l  #Map_Results,mappings(a0)
                move.w  #make_art_tile(ArtTile_Competition_STKIcons-$77,1,1),art_tile(a0)
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                subi.w  #$E,d0
                lsl.w   #4,d0
                lea     (Competition_saved_data).w,a1
                lea     $C(a1,d0.w),a1
                moveq   #0,d0
                move.b  $2E(a0),d0
                move.b  (a1,d0.w),d0
                cmpi.w  #2,d0
                bne.s   S3TimeRecords_SetIconFrameAndUpdate
                addi.w  #palette_line_1,art_tile(a0)

S3TimeRecords_SetIconFrameAndUpdate:
                addi.w  #$29,d0
                move.b  d0,mapping_frame(a0)
                move.l  #CompetitionRecordIcon_BlinkNewTopRecord,(a0)

CompetitionRecordIcon_BlinkNewTopRecord:
                move.b  (Competition_time_attack_new_top_record).w,d0
                cmp.b   $2E(a0),d0
                bne.s   CompetitionRecordIcon_Draw
                btst    #3,(Level_frame_counter+1).w
                beq.s   CompetitionRecordIcon_ReturnDuringBlink

CompetitionRecordIcon_Draw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

CompetitionRecordIcon_ReturnDuringBlink:
                rts
; ---------------------------------------------------------------------------
Pal_CompetitionTimeAttack:
                binclude "data/General/Competition Menu/Palettes/Time Attack.bin"
                even
CompetitionTimeAttack_ActorRecords:
                dc.w    5-1
                dc.l    Obj_Competition_StaticSprite
                dc.w    $14D,   $B9, palette_line_0
                dc.b    0,   0
                dc.l    S3CompResults_UpdatePlayerIcon
                dc.w    $14D,   $CB, palette_line_0
                dc.b    0,   0
                dc.l    S3TimeRecords_InitIconFromSavedCharacter
                dc.w    $130,  $120, palette_line_0
                dc.b    0,   0
                dc.l    S3TimeRecords_InitIconFromSavedCharacter
                dc.w    $130,  $138, palette_line_0
                dc.b    0,   1
                dc.l    S3TimeRecords_InitIconFromSavedCharacter
                dc.w    $130,  $150, palette_line_0
                dc.b    0,   2
S3TimeRecords_InitialVRAMRectangles:
                dc.w    9-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_B_Name_Table+$000,  40-1,  28-1
                dc.l    MapUnc_CompetitionLAPNum
                dc.w    VRAM_Plane_A_Name_Table+$144,   5-1,  10-1
                dc.l    MapUnc_CompetitionResultsDividers
                dc.w    VRAM_Plane_A_Name_Table+$152,   4-1,  10-1
                dc.l    MapUnc_CompetitionResultsTOTAL
                dc.w    VRAM_Plane_A_Name_Table+$650,   5-1,   2-1
                dc.l    MapUnc_CompetitionResultsDividers
                dc.w    VRAM_Plane_A_Name_Table+$952,   4-1,   2-1
                dc.l    MapUnc_CompetitionResultsDividers
                dc.w    VRAM_Plane_A_Name_Table+$AD2,   4-1,   2-1
                dc.l    MapUnc_CompetitionResultsDividers
                dc.w    VRAM_Plane_A_Name_Table+$C52,   4-1,   2-1
                dc.l    MapUnc_CompetitionRECORDS
                dc.w    VRAM_Plane_A_Name_Table+$92C,   7-1,   2-1
                dc.l    MapUnc_Competition1st2nd3rd
                dc.w    VRAM_Plane_A_Name_Table+$944,   3-1,   8-1
MapUnc_CompetitionLAPNum:
                binclude "data/General/Competition Menu/Uncompressed Map/LAP.bin"
                even
MapUnc_CompetitionRECORDS:
                binclude "data/General/Competition Menu/Uncompressed Map/RECORDS.bin"
                even
MapUnc_Competition1st2nd3rd:
                binclude "data/General/Competition Menu/Uncompressed Map/1ST 2ND 3RD.bin"
                even
CompTimeAttack_LevelNameMaps:
                dc.l    MapUnc_CompetitionAZURELAKE
                dc.l    MapUnc_CompetitionBALLOONPARK
                dc.l    MapUnc_CompetitionDESERTPALACE
                dc.l    MapUnc_CompetitionCHROMEGADGET
                dc.l    MapUnc_CompetitionENDLESSMINE
MapUnc_CompetitionAZURELAKE:
                binclude "data/General/Competition Menu/Uncompressed Map/AZURE LAKE.bin"
                even
MapUnc_CompetitionBALLOONPARK:
                binclude "data/General/Competition Menu/Uncompressed Map/BALLOON PARK.bin"
                even
MapUnc_CompetitionCHROMEGADGET:
                binclude "data/General/Competition Menu/Uncompressed Map/CHROME GADGET.bin"
                even
MapUnc_CompetitionDESERTPALACE:
                binclude "data/General/Competition Menu/Uncompressed Map/DESERT PALACE.bin"
                even
MapUnc_CompetitionENDLESSMINE:
                binclude "data/General/Competition Menu/Uncompressed Map/ENDLESS MINE.bin"
                even

; =============== S U B R O U T I N E =======================================
