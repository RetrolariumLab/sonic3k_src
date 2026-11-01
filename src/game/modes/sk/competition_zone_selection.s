; Owner: game/modes/sk
; Responsibility: Competition zone selection, completion display, menu controls and zone preview resources
; Source provenance and ranges: config/reconstruction/source_layout.json
Competition_LevelSelect:
                bsr.w   Pal_FadeToBlack
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
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                clr.w   (Level_frame_counter).w
                clr.w   (Competition_mode).w
                clr.b   (Level_started_flag).w
                move.w  #-1,(Events_bg+$10).w
                clr.w   (Events_bg+$12).w
                clr.w   (Events_bg+$14).w
                lea     (MapEni_S3MenuBG).l,a0
                lea     (RAM_start).l,a1
                move.w  #make_art_tile(ArtTile_S3MenuBG,0,0),d0
                jsr     (Eni_Decomp).l
                lea     (RAM_start).l,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     (MapEni_CompetitionLevBorder).l,a0
                lea     (RAM_start).l,a1
                move.w  #make_art_tile(ArtTile_Competition_LevSel,0,1),d0
                jsr     (Eni_Decomp).l
                lea     (MapEni_CompetitionLevImage).l,a0
                lea     (RAM_start+$1000).l,a1
                move.w  #make_art_tile(ArtTile_Competition_LevSel,3,1),d0
                jsr     (Eni_Decomp).l
                lea     (MapEni_CompetitionLevName).l,a0
                lea     (RAM_start+$2000).l,a1
                move.w  #make_art_tile(ArtTile_Competition_LevSel,1,1),d0
                jsr     (Eni_Decomp).l
                lea     VRAMDatList_CompetitionLevelSelect(pc),a0
                jsr     Copy_Listed_Data_To_VRAM(pc)
                jsr     SKCompClampSelectedZoneToVisibleScrollRow(pc)
                mulu.w  #$48,d0
                move.w  d0,(V_scroll_value).w
                jsr     SKCompClearCharacterSelectAreasAtZoneWindowRow(pc)
                jsr     SKCompDrawFiveZoneBestTimesInMenuOrder(pc)
                lea     (ArtKos_S3MenuBG).l,a0          ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source
                movea.w #tiles_to_bytes(ArtTile_S3MenuBG),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.l  #locret_A85C,(_unkEF44_1).w
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (ArtKos_CompetitionLevel).l,a0  ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source, used by the next KosArt_To_VDP also
                movea.w #tiles_to_bytes(ArtTile_Competition_LevSel),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                lea     (ArtKos_CompetitionPlayer).l,a0  ; Decompress source
                movea.w #tiles_to_bytes(ArtTile_Competition_CharSel),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (Pal_CompetitionMenuBG).l,a0
                lea     (Target_palette).w,a1
                moveq   #bytesToLcnt($20),d0

loc_AD04:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_AD04
                lea     (Pal_Competition2).l,a0
                moveq   #bytesToLcnt($60),d0

loc_AD12:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_AD12
                lea     (Object_RAM).w,a0
                lea     ObjDat_CompetitionMatchRace(pc),a1
                tst.b   (Game_mode).w
                bpl.s   loc_AD2A
                lea     ObjDat_CompetitionTimeAttack(pc),a1

loc_AD2A:
                move.w  (a1)+,d0

loc_AD2C:
                move.l  (a1)+,(a0)
                move.l  #Map_CompetitionSelect,mappings(a0)
                move.w  (a1),x_pos(a0)
                move.w  (a1)+,$12(a0)
                move.w  (a1),y_pos(a0)
                move.w  (a1)+,$16(a0)
                move.w  (a1)+,d1
                addi.w  #make_art_tile(ArtTile_Competition_LevSel,0,1),d1
                move.w  d1,art_tile(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,$2E(a0)
                lea     next_object(a0),a0
                dbf     d0,loc_AD2C
                moveq   #0,d0
                move.b  (P1_character).w,d0
                mulu.w  #$55,d0
                addi.b  #$40,d0
                move.b  d0,(Reserved_object_3+objoff_2E).w
                tst.b   (Game_mode).w
                bmi.s   loc_AD8A
                moveq   #0,d0
                move.b  (P2_character).w,d0
                mulu.w  #$55,d0
                addi.b  #$40,d0
                move.b  d0,(Dynamic_object_RAM+(object_size*4)+objoff_2E).w

loc_AD8A:
                jsr     (Init_SpriteTable).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                jsr     Menu_UpdateBothCharacterDepthGroups(pc)
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                lea     (Dynamic_object_RAM+(object_size*9)).w,a0
                move.l  #loc_AF58,(a0)
                move.l  #Map_CompetitionSelect,mappings(a0)
                addi.w  #make_art_tile(ArtTile_Competition_LevSel,2,1),art_tile(a0)
                move.w  #$B0,x_pos(a0)
                moveq   #signextendB(mus_CompetitionMenu),d0
                jsr     (Play_Music).l
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Pal_FadeFromBlack).l

loc_ADF2:
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                addq.w  #1,(Level_frame_counter).w
                jsr     (Process_Sprites).l
                jsr     Menu_UpdateBothCharacterDepthGroups(pc)
                jsr     (Render_Sprites).l
                move.b  (Events_bg+$12).w,d0
                beq.s   loc_AE1E
                move.b  d0,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_AE1E:
                move.w  (Events_bg+$10).w,d0
                tst.b   (Not_ghost_flag).w
                bne.s   loc_AE2A
                lsr.w   #8,d0

loc_AE2A:
                tst.w   d0
                beq.s   loc_AE4A
                move.w  (H_scroll_buffer).w,d0
                beq.s   loc_ADF2
                cmpi.w  #-$58,d0
                bne.s   loc_AE42
                move.l  #loc_AFC8,(_unkEF44_1).w

loc_AE42:
                addq.w  #8,d0
                move.w  d0,(H_scroll_buffer).w
                bra.s   loc_ADF2
; ---------------------------------------------------------------------------

loc_AE4A:
                cmpi.w  #-$58,(H_scroll_buffer).w
                beq.s   loc_AE58
                subq.w  #8,(H_scroll_buffer).w
                bra.s   loc_ADF2
; ---------------------------------------------------------------------------

loc_AE58:
                moveq   #8,d0
                move.w  (Events_bg+$14).w,d1
                beq.s   loc_AE6E
                bpl.s   loc_AE64
                neg.w   d0

loc_AE64:
                add.w   d0,(V_scroll_value).w
                sub.w   d0,(Events_bg+$14).w
                bra.s   loc_ADF2
; ---------------------------------------------------------------------------

loc_AE6E:
                move.b  (Ctrl_1_pressed).w,d1
                moveq   #0,d2
                tst.b   (Not_ghost_flag).w
                beq.s   loc_AE7E
                move.b  (Ctrl_2_pressed).w,d2

loc_AE7E:
                btst    #button_B,d2
                beq.s   loc_AE8C
                sf      (Dynamic_object_RAM+(object_size*4)+objoff_2F).w
                st      (Events_bg+$11).w

loc_AE8C:
                btst    #button_B,d1
                beq.s   loc_AE9A
                sf      (Reserved_object_3+objoff_2F).w
                st      (Events_bg+$10).w

loc_AE9A:
                or.b    d2,d1
                move.b  d1,d2
                andi.w  #3,d2
                beq.s   loc_AEF2
                lea     (Competition_menu_zone).w,a0
                lsr.w   #1,d2
                bcs.s   loc_AED2
                cmpi.b  #4,(a0)
                beq.s   loc_AEF2
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l
                addq.b  #1,(a0)
                cmpi.b  #4,(a0)
                beq.s   loc_AEF2
                cmpi.b  #1,(a0)
                beq.s   loc_AEF2
                move.w  #$48,(Events_bg+$14).w
                bra.w   loc_ADF2
; ---------------------------------------------------------------------------

loc_AED2:
                tst.b   (a0)
                beq.s   loc_AEF2
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l
                subq.b  #1,(a0)
                beq.s   loc_AEF2
                cmpi.b  #3,(a0)
                beq.s   loc_AEF2
                move.w  #-$48,(Events_bg+$14).w
                bra.w   loc_ADF2
; ---------------------------------------------------------------------------

loc_AEF2:
                andi.w  #$E0,d1
                beq.w   loc_ADF2
                moveq   #signextendB(sfx_Starpost),d0
                jsr     (Play_SFX).l
                moveq   #0,d0
                move.b  (Competition_menu_zone).w,d0
                move.b  Comp_ZoneList(pc,d0.w),(Current_zone).w
                clr.b   (Current_act).w
                jsr     SKCompInitializeRoundLivesScoresTimersAndFlags(pc)
                move.b  #GameMode_Level,(Game_mode).w
                rts
; ---------------------------------------------------------------------------
Comp_ZoneList:
                dc.b    $E
                dc.b    $F
                dc.b    $11
                dc.b    $10
                dc.b    $12
                dc.b    $FF
; ---------------------------------------------------------------------------

Obj_Competition_ZoneSelect:
                cmpi.w  #-$58,(H_scroll_buffer).w
                bne.s   locret_AF56
                tst.w   (Events_bg+$14).w
                bne.s   locret_AF56
                moveq   #0,d0
                move.b  (Competition_menu_zone).w,d0
                mulu.w  #$48,d0
                addi.w  #$AC,d0
                sub.w   (V_scroll_value).w,d0
                move.w  d0,y_pos(a0)
                btst    #3,(Level_frame_counter+1).w
                beq.s   locret_AF56
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_AF56:
                rts
; ---------------------------------------------------------------------------

loc_AF58:
                cmpi.w  #-$58,(H_scroll_buffer).w
                bne.s   loc_AF9E
                tst.w   (Events_bg+$14).w
                bne.s   loc_AF9E
                moveq   #0,d0
                move.b  (Competition_menu_zone).w,d0
                mulu.w  #$48,d0
                addi.w  #$A8,d0
                sub.w   (V_scroll_value).w,d0
                move.w  d0,y_pos(a0)
                move.b  (Competition_menu_zone).w,d0
                addq.b  #6,d0
                move.b  d0,mapping_frame(a0)
                jsr     (Draw_Sprite).l
                moveq   #0,d0
                move.b  (Competition_menu_zone).w,d0
                lsl.w   #5,d0
                lea     (Pal_Competition4).l,a1
                adda.w  d0,a1
                bra.s   loc_AFA4
; ---------------------------------------------------------------------------

loc_AF9E:
                lea     (Pal_Competition3).l,a1

loc_AFA4:
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d0

loc_AFAA:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_AFAA
                rts

; =============== S U B R O U T I N E =======================================

SKCompClampSelectedZoneToVisibleScrollRow:
                moveq   #0,d0
                move.b  (Competition_menu_zone).w,d0
                subq.w  #1,d0
                bcc.s   loc_AFBE
                moveq   #0,d0

loc_AFBE:
                cmpi.w  #2,d0
                bls.s   locret_AFC6
                moveq   #2,d0

locret_AFC6:
                rts
; End of function SKCompClampSelectedZoneToVisibleScrollRow

; ---------------------------------------------------------------------------

loc_AFC8:
                move.l  #locret_A85C,(_unkEF44_1).w
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$204,VRAM,WRITE),d0
                lea     (VDP_data_port).l,a6
                move.l  #$80008000,d1
                move.w  #$8F80,VDP_control_port-VDP_data_port(a6)
                moveq   #9-1,d2

loc_AFEA:
                moveq   #$13-1,d3
                move.l  d0,VDP_control_port-VDP_data_port(a6)

loc_AFF0:
                move.l  d1,(a6)
                dbf     d3,loc_AFF0
                addi.l  #2<<16,d0
                dbf     d2,loc_AFEA
                move.w  #$8F02,VDP_control_port-VDP_data_port(a6)

; =============== S U B R O U T I N E =======================================

SKCompClearCharacterSelectAreasAtZoneWindowRow:
                bsr.s   SKCompClampSelectedZoneToVisibleScrollRow
                mulu.w  #$48,d0
                addi.w  #$20,d0
                lsl.w   #4,d0
                addi.w  #VRAM_Plane_A_Name_Table+$004,d0
                move.w  d0,d7
                tst.b   (Game_mode).w
                bmi.s   loc_B02E
                jsr     Menu_ClearNineByEightTileArea(pc)
                move.w  d7,d0
                addi.w  #$600,d0
                jmp     Menu_ClearNineByEightTileArea(pc)
; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------

loc_B02E:
                addi.w  #$300,d0
                jmp     Menu_ClearNineByEightTileArea(pc)
; End of function SKCompClearCharacterSelectAreasAtZoneWindowRow

; =============== S U B R O U T I N E =======================================

SKCompDrawFiveZoneBestTimesInMenuOrder:
                move.w  #VRAM_Plane_A_Name_Table+$2D2,d7
                move.l  (Competition_saved_data).w,d6
                bsr.s   SKCompFormatAndUploadMinuteSecondHundredthTime
                addi.w  #$480,d7
                move.l  (Competition_saved_data+$10).w,d6
                bsr.s   SKCompFormatAndUploadMinuteSecondHundredthTime
                addi.w  #$480,d7
                move.l  (Competition_saved_data+$30).w,d6
                bsr.s   SKCompFormatAndUploadMinuteSecondHundredthTime
                addi.w  #$480,d7
                move.l  (Competition_saved_data+$20).w,d6
                bsr.s   SKCompFormatAndUploadMinuteSecondHundredthTime
                addi.w  #$480,d7
                move.l  (Competition_saved_data+$40).w,d6
; End of function SKCompDrawFiveZoneBestTimesInMenuOrder

; =============== S U B R O U T I N E =======================================

SKCompFormatAndUploadMinuteSecondHundredthTime:
                moveq   #0,d5
                lsl.l   #8,d6
                moveq   #2,d3

loc_B06C:
                rol.l   #8,d6
                moveq   #0,d0
                move.b  d6,d0
                jsr     (LevResults_GetDecimalScore).l
                move.b  d1,d5
                lsl.l   #8,d5
                dbf     d3,loc_B06C
                lea     (Plane_buffer).w,a1
                lea     (MapUnc_CompetitionNumbers).l,a2
                moveq   #0,d0
                bsr.s   SKCompAppendNextTimeDigitWithFirstZeroBlankFlag
                st      d0
                bsr.s   SKCompAppendNextTimeDigitWithFirstZeroBlankFlag
                moveq   #$A,d1
                bsr.s   SKCompAppendTwoRowNumericGlyphColumn
                bsr.s   SKCompAppendNextTimeDigitWithFirstZeroBlankFlag
                bsr.s   SKCompAppendNextTimeDigitWithFirstZeroBlankFlag
                moveq   #$B,d1
                bsr.s   SKCompAppendTwoRowNumericGlyphColumn
                bsr.s   SKCompAppendNextTimeDigitWithFirstZeroBlankFlag
                bsr.s   SKCompAppendNextTimeDigitWithFirstZeroBlankFlag
                lea     (Plane_buffer).w,a1

CompetitionMenuUploadEightByTwoTileBlock:
                move.w  d7,d0
                swap    d0
                clr.w   d0
                swap    d0
                lsl.l   #2,d0
                lsr.w   #2,d0
                ori.w   #$4000,d0
                swap    d0
                moveq   #8-1,d1
                moveq   #2-1,d2
                jmp     (Plane_Map_To_VRAM).l
; End of function SKCompFormatAndUploadMinuteSecondHundredthTime

; =============== S U B R O U T I N E =======================================

SKCompAppendNextTimeDigitWithFirstZeroBlankFlag:
                rol.l   #4,d5
                move.w  d5,d1
                andi.w  #$F,d1
                bne.s   SKCompAppendTwoRowNumericGlyphColumn
                tst.w   d0
                bne.s   SKCompAppendTwoRowNumericGlyphColumn
                moveq   #$C,d1
                st      d0
; End of function SKCompAppendNextTimeDigitWithFirstZeroBlankFlag

; =============== S U B R O U T I N E =======================================

SKCompAppendTwoRowNumericGlyphColumn:
                add.w   d1,d1
                add.w   d1,d1
                move.w  (a2,d1.w),(a1)+
                move.w  2(a2,d1.w),$E(a1)
                rts
; End of function SKCompAppendTwoRowNumericGlyphColumn

; =============== S U B R O U T I N E =======================================

SKCompConvertTimerFrameByteToHundredths:
                lea     (byte_37E52).l,a1
                moveq   #0,d0
                move.b  d6,d0
                move.b  (a1,d0.w),d6
                rts
; End of function SKCompConvertTimerFrameByteToHundredths

; ---------------------------------------------------------------------------
VRAMDatList_CompetitionLevelSelect:
                dc.w    $19-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$0098,  27-1, 9-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$0518,  27-1, 9-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$0998,  27-1, 9-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$0E18,  27-1, 9-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_A_Name_Table+$1298,  27-1, 9-1
                dc.l    RAM_start+$1180
                dc.w    VRAM_Plane_A_Name_Table+$011A,   8-1, 6-1
                dc.l    RAM_start+$1120
                dc.w    VRAM_Plane_A_Name_Table+$059A,   8-1, 6-1
                dc.l    RAM_start+$1000
                dc.w    VRAM_Plane_A_Name_Table+$0A1A,   8-1, 6-1
                dc.l    RAM_start+$1060
                dc.w    VRAM_Plane_A_Name_Table+$0E9A,   8-1, 6-1
                dc.l    RAM_start+$10C0
                dc.w    VRAM_Plane_A_Name_Table+$131A,   8-1, 6-1
                dc.l    RAM_start+$2000
                dc.w    VRAM_Plane_A_Name_Table+$01AC,  15-1, 5-1
                dc.l    RAM_start+$2258
                dc.w    VRAM_Plane_A_Name_Table+$062C,  15-1, 5-1
                dc.l    RAM_start+$2096
                dc.w    VRAM_Plane_A_Name_Table+$0AAC,  15-1, 5-1
                dc.l    RAM_start+$21C2
                dc.w    VRAM_Plane_A_Name_Table+$0F2C,  15-1, 5-1
                dc.l    RAM_start+$212C
                dc.w    VRAM_Plane_A_Name_Table+$13AC,  15-1, 5-1
                dc.l    MapUnc_CompetitionTimeBorder
                dc.w    VRAM_Plane_A_Name_Table+$00CE,  12-1, 9-1
                dc.l    MapUnc_CompetitionTimeBorder
                dc.w    VRAM_Plane_A_Name_Table+$054E,  12-1, 9-1
                dc.l    MapUnc_CompetitionTimeBorder
                dc.w    VRAM_Plane_A_Name_Table+$09CE,  12-1, 9-1
                dc.l    MapUnc_CompetitionTimeBorder
                dc.w    VRAM_Plane_A_Name_Table+$0E4E,  12-1, 9-1
                dc.l    MapUnc_CompetitionTimeBorder
                dc.w    VRAM_Plane_A_Name_Table+$12CE,  12-1, 9-1
                dc.l    MapUnc_CompetitionBESTTIME
                dc.w    VRAM_Plane_A_Name_Table+$01D0,   9-1, 2-1
                dc.l    MapUnc_CompetitionBESTTIME
                dc.w    VRAM_Plane_A_Name_Table+$0650,   9-1, 2-1
                dc.l    MapUnc_CompetitionBESTTIME
                dc.w    VRAM_Plane_A_Name_Table+$0AD0,   9-1, 2-1
                dc.l    MapUnc_CompetitionBESTTIME
                dc.w    VRAM_Plane_A_Name_Table+$0F50,   9-1, 2-1
                dc.l    MapUnc_CompetitionBESTTIME
                dc.w    VRAM_Plane_A_Name_Table+$13D0,   9-1, 2-1
ObjDat_CompetitionMatchRace:
                dc.w    $C-1
                dc.l    Obj_Competition_ZoneSelect
                dc.w    $F4,     0, palette_line_0
                dc.b    2,   0
                dc.l    Obj_Competition_StaticSprite
                dc.w    $B0,   $A9, palette_line_1
                dc.b    3,   0
                dc.l    Obj_Competition_1PSelect
                dc.w    $B5,   $C1, palette_line_0
                dc.b    0,   0
                dc.l    Obj_CompetitionPlayerSprite
                dc.w    $B5,   $D5, palette_line_0
                dc.b    0,   0
                dc.l    Obj_CompetitionPlayerSprite
                dc.w    $B5,   $D5, palette_line_0
                dc.b    2,   1
                dc.l    Obj_CompetitionPlayerSprite
                dc.w    $B5,   $D5, palette_line_0
                dc.b    1,   2
                dc.l    Obj_Competition_StaticSprite
                dc.w    $B2,  $109, palette_line_1
                dc.b    4,   0
                dc.l    Obj_Competition_2PSelect
                dc.w    $B5,  $121, palette_line_0
                dc.b    0,   0
                dc.l    Obj_CompetitionPlayerSprite2P
                dc.w    $B5,  $135, palette_line_0
                dc.b    0,   0
                dc.l    Obj_CompetitionPlayerSprite2P
                dc.w    $B5,  $135, palette_line_0
                dc.b    2,   1
                dc.l    Obj_CompetitionPlayerSprite2P
                dc.w    $B5,  $135, palette_line_0
                dc.b    1,   2
                dc.l    Obj_Competition_PRESSSTART
                dc.w    $B1,  $126, palette_line_1
                dc.b    5,   0
ObjDat_CompetitionTimeAttack:
                dc.w    6-1
                dc.l    Obj_Competition_ZoneSelect
                dc.w    $F4,   $30, palette_line_0
                dc.b    2,   0
                dc.l    Obj_Competition_StaticSprite
                dc.w    $B0,     0, palette_line_1
                dc.b    3,   0
                dc.l    Obj_Competition_1PSelect
                dc.w    $B5,   $F1, palette_line_0
                dc.b    0,   0
                dc.l    Obj_CompetitionPlayerSprite
                dc.w    $B5,  $101, palette_line_0
                dc.b    0,   0
                dc.l    Obj_CompetitionPlayerSprite
                dc.w    $B5,  $101, palette_line_0
                dc.b    2,   1
                dc.l    Obj_CompetitionPlayerSprite
                dc.w    $B5,  $101, palette_line_0
                dc.b    1,   2
; ---------------------------------------------------------------------------
