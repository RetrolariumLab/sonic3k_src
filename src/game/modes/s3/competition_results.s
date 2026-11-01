; Owner: game/modes/s3
; Responsibility: Competition results initialization, win and loss displays, totals and results resources
; Source provenance and ranges: config/reconstruction/source_layout.json
Competition_Results:
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
                move.w  #VRAM_Plane_A_Name_Table+$82A,d0
                jsr     Menu_ClearNineByEightTileArea(pc)
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                clr.w   (Level_frame_counter).w
                clr.w   (Competition_mode).w
                clr.b   (Level_started_flag).w
                move.w  #$1E,(Events_bg+$16).w
                lea     (MapEni_S3MenuBG).l,a0
                lea     (RAM_start).l,a1
                move.w  #make_art_tile(ArtTile_S3MenuBG,0,0),d0
                jsr     (Eni_Decomp).l
                lea     MapEni_CompetitionResultsLED(pc),a0
                lea     (RAM_start+$1000).l,a1
                move.w  #make_art_tile(ArtTile_Competition_Results,1,1),d0
                jsr     (Eni_Decomp).l
                lea     VRAMDatList_AE06(pc),a0
                jsr     Copy_Listed_Data_To_VRAM(pc)
                jsr     S3CompBuildFiveRaceResultsTotalsWinsAndBlinkMap(pc)
                lea     (ArtKos_S3MenuBG).l,a0          ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source
                movea.w #tiles_to_bytes(ArtTile_S3MenuBG),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.l  #locret_952E,(_unkEF44_1).w
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
                lea     (Pal_CompetitionMenuBG).l,a0
                lea     (Target_palette).w,a1
                moveq   #bytesToLcnt(Target_palette_line_2-Target_palette),d0

loc_AACC:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_AACC
                lea     Pal_Competition2(pc),a0
                moveq   #bytesToLcnt(Target_palette_line_4-Target_palette_line_2),d0

loc_AAD8:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_AAD8
                lea     Pal_CompetitionResults(pc),a0
                moveq   #bytesToLcnt(Target_palette_end-Target_palette_line_4),d0

loc_AAE4:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_AAE4
                lea     (Object_RAM).w,a0
                lea     ObjDat_ADA4(pc),a1
                move.w  (a1)+,d0

loc_AAF4:
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
                dbf     d0,loc_AAF4
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

loc_AB62:
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                addq.w  #1,(Level_frame_counter).w
                move.w  (_unkEEA0).w,d7
                beq.s   loc_AB92
                btst    #3,(Level_frame_counter+1).w
                bne.s   loc_AB8A
                lea     (Plane_buffer+$20).w,a1
                jsr     loc_9F0A(pc)
                bra.s   loc_AB92
; ---------------------------------------------------------------------------

loc_AB8A:
                move.l  (_unkEE98).w,d6
                jsr     S3CompFormatAndUploadMinuteSecondHundredthTime(pc)

loc_AB92:
                tst.w   (Events_bg+$16).w
                beq.s   loc_AB9E
                subq.w  #1,(Events_bg+$16).w
                bra.s   loc_ABD6
; ---------------------------------------------------------------------------

loc_AB9E:
                move.b  (Ctrl_1_pressed).w,d0
                tst.b   (Not_ghost_flag).w
                beq.s   loc_ABAC
                or.b    (Ctrl_2_pressed).w,d0

loc_ABAC:
                move.w  (H_scroll_buffer).w,d1
                beq.s   loc_ABBA
                cmpi.w  #$FF78,d1
                beq.s   loc_ABC8
                bra.s   loc_ABC0
; ---------------------------------------------------------------------------

loc_ABBA:
                andi.w  #button_start_mask|button_A_mask|button_C_mask,d0
                beq.s   loc_ABD6

loc_ABC0:
                subq.w  #8,d1
                move.w  d1,(H_scroll_buffer).w
                bra.s   loc_ABD6
; ---------------------------------------------------------------------------

loc_ABC8:
                andi.w  #button_start_mask|button_A_mask|button_C_mask,d0
                beq.s   loc_ABD6
                move.b  #GameMode_CompetitionMenu,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_ABD6:
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                bra.w   loc_AB62
; ---------------------------------------------------------------------------

Obj_Competition_ABE6:
                move.l  #Map_CompetitionPlayerSprite,mappings(a0)
                move.w  #make_art_tile(ArtTile_Competition_CharSel,1,1),art_tile(a0)
                move.b  (P1_character).w,d0
                tst.b   $2E(a0)
                beq.s   loc_AC02
                move.b  (P2_character).w,d0

loc_AC02:
                move.b  d0,mapping_frame(a0)
                jmp     Obj_Competition_StaticSprite(pc)
; ---------------------------------------------------------------------------

Obj_Competition_AC0A:
                move.w  #make_art_tile(ArtTile_Competition_Results,1,1),art_tile(a0)
                move.b  (_unkEEA2).w,d0
                move.b  (_unkEEA2+1).w,d1
                tst.b   $2E(a0)
                beq.s   loc_AC20
                exg     d0,d1

loc_AC20:
                moveq   #$D,d2
                cmp.b   d0,d1
                beq.s   loc_AC2C
                bcs.s   loc_AC2A
                addq.w  #1,d2

loc_AC2A:
                subq.b  #2,d2

loc_AC2C:
                move.b  d2,mapping_frame(a0)
                cmpi.b  #$B,d2
                bne.w   Obj_Competition_StaticSprite
                btst    #3,(Level_frame_counter+1).w
                bne.w   Obj_Competition_StaticSprite
                rts

; =============== S U B R O U T I N E =======================================

S3CompBuildFiveRaceResultsTotalsWinsAndBlinkMap:
                lea     ((RAM_start+$7800)&$FFFFFF).l,a0
                move.w  #$C15A,d7
                jsr     S3CompDrawFiveSequentialTimeRows(pc)
                move.w  #$C7DA,d7
                jsr     S3CompDrawFiveSequentialTimeRows(pc)
                lea     ((RAM_start+$7800)&$FFFFFF).l,a0
                jsr     S3CompSumFiveBinaryMinuteSecondHundredthTimes(pc)
                move.w  #$C65A,d7
                move.l  d6,(_unkEE98).w
                move.w  d7,(_unkEEA0).w
                jsr     S3CompFormatAndUploadMinuteSecondHundredthTime(pc)
                jsr     S3CompSumFiveBinaryMinuteSecondHundredthTimes(pc)
                move.w  #$CCDA,d7
                cmp.l   (_unkEE98).w,d6
                bhi.s   loc_AC92
                bne.s   loc_AC8A
                clr.w   (_unkEEA0).w
                bra.s   loc_AC92
; ---------------------------------------------------------------------------

loc_AC8A:
                move.l  d6,(_unkEE98).w
                move.w  d7,(_unkEEA0).w

loc_AC92:
                jsr     S3CompFormatAndUploadMinuteSecondHundredthTime(pc)
                clr.w   (_unkEEA2).w
                lea     ((RAM_start+$7800)&$FFFFFF).l,a0
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$148,VRAM,WRITE),d5
                moveq   #5-1,d7

loc_ACA8:
                lea     MapUnc_ResultsWin(pc),a1
                lea     MapUnc_ResultsLose(pc),a2
                addq.b  #1,(_unkEEA2).w
                move.l  (a0)+,d0
                cmp.l   x_pos(a0),d0
                beq.s   loc_ACCA
                bcs.s   loc_ACD4
                exg     a1,a2
                subq.b  #1,(_unkEEA2).w
                addq.b  #1,(_unkEEA2+1).w
                bra.s   loc_ACD4
; ---------------------------------------------------------------------------

loc_ACCA:
                lea     MapUnc_ResultsTie(pc),a1
                movea.l a1,a2
                subq.b  #1,(_unkEEA2).w

loc_ACD4:
                move.l  d5,d0
                moveq   #2-1,d1
                moveq   #2-1,d2
                jsr     (Plane_Map_To_VRAM).l
                movea.l a2,a1
                move.l  d5,d0
                addi.l  #$680<<16,d0
                moveq   #2-1,d1
                moveq   #2-1,d2
                jsr     (Plane_Map_To_VRAM).l
                addi.l  #$100<<16,d5
                dbf     d7,loc_ACA8
                move.w  (_unkEEA0).w,d7
                beq.s   locret_AD26
                move.l  (_unkEE98).w,d6
                jsr     S3CompFormatAndUploadMinuteSecondHundredthTime(pc)
                lea     (Plane_buffer).w,a0
                lea     $20(a0),a1
                moveq   #$10-1,d0

loc_AD16:
                move.w  (a0)+,d1
                andi.w  #$9FFF,d1
                ori.w   #$6000,d1
                move.w  d1,(a1)+
                dbf     d0,loc_AD16

locret_AD26:
                rts
; End of function S3CompBuildFiveRaceResultsTotalsWinsAndBlinkMap

; =============== S U B R O U T I N E =======================================

S3CompDrawFiveSequentialTimeRows:
                moveq   #5-1,d0

loc_AD2A:
                move.w  d0,-(sp)
                move.l  (a0)+,d6
                jsr     S3CompFormatAndUploadMinuteSecondHundredthTime(pc)
                addi.w  #$100,d7
                move.w  (sp)+,d0
                dbf     d0,loc_AD2A
                rts
; End of function S3CompDrawFiveSequentialTimeRows

; =============== S U B R O U T I N E =======================================

S3CompSumFiveBinaryMinuteSecondHundredthTimes:
                clr.l   (_unkEF40_1).w
                moveq   #5-1,d7

loc_AD44:
                move.l  (a0)+,d6
                lea     (_unkEF44_2).w,a1
                add.b   d6,-(a1)
                cmpi.b  #100,(a1)
                blo.s   loc_AD5A
                subi.b  #100,(a1)
                addq.b  #1,-1(a1)

loc_AD5A:
                lsr.l   #8,d6
                add.b   d6,-(a1)
                cmpi.b  #60,(a1)
                blo.s   loc_AD6C
                subi.b  #60,(a1)
                addq.b  #1,-1(a1)

loc_AD6C:
                lsr.l   #8,d6
                add.b   d6,-(a1)
                cmpi.b  #100,(a1)
                blo.s   loc_AD7A
                move.b  #99,(a1)

loc_AD7A:
                dbf     d7,loc_AD44
                move.l  (_unkEF40_1).w,d6
                rts
; End of function S3CompSumFiveBinaryMinuteSecondHundredthTimes

; ---------------------------------------------------------------------------
Pal_CompetitionResults:
                binclude "data/General/Competition Menu/Palettes/Results.bin"
                even
ObjDat_ADA4:
                dc.w    8-1
                dc.l    Obj_Competition_StaticSprite
                dc.w    $148,   $A1, palette_line_1
                dc.b    3,   0
                dc.l    Obj_Competition_StaticSprite
                dc.w    $14D,   $B9, palette_line_0
                dc.b    0,   0
                dc.l    Obj_Competition_ABE6
                dc.w    $14D,   $D3, palette_line_0
                dc.b    0,   0
                dc.l    Obj_Competition_AC0A
                dc.w    $CC,   $BC, palette_line_0
                dc.b    0,   0
                dc.l    Obj_Competition_StaticSprite
                dc.w    $14A,  $109, palette_line_1
                dc.b    4,   0
                dc.l    Obj_Competition_StaticSprite
                dc.w    $14D,  $121, palette_line_0
                dc.b    0,   0
                dc.l    Obj_Competition_ABE6
                dc.w    $14D,  $13B, palette_line_0
                dc.b    0,   1
                dc.l    Obj_Competition_AC0A
                dc.w    $CC,  $124, palette_line_0
                dc.b    0,   1
VRAMDatList_AE06:
                dc.w    9-1
                dc.l    RAM_start+$0000
                dc.w    VRAM_Plane_B_Name_Table+$000,  40-1,  28-1
                dc.l    RAM_start+$1000
                dc.w    VRAM_Plane_A_Name_Table+$204,  15-1,   6-1
                dc.l    RAM_start+$1000
                dc.w    VRAM_Plane_A_Name_Table+$884,  15-1,   6-1
                dc.l    MapUnc_CompetitionResultsLetters
                dc.w    VRAM_Plane_A_Name_Table+$142,   2-1,  10-1
                dc.l    MapUnc_CompetitionResultsLetters
                dc.w    VRAM_Plane_A_Name_Table+$7C2,   2-1,  10-1
                dc.l    MapUnc_CompetitionResultsDividers
                dc.w    VRAM_Plane_A_Name_Table+$152,   4-1,  10-1
                dc.l    MapUnc_CompetitionResultsDividers
                dc.w    VRAM_Plane_A_Name_Table+$7D2,   4-1,  10-1
                dc.l    MapUnc_CompetitionResultsTOTAL
                dc.w    VRAM_Plane_A_Name_Table+$650,   5-1,   2-1
                dc.l    MapUnc_CompetitionResultsTOTAL
                dc.w    VRAM_Plane_A_Name_Table+$CD0,   5-1,   2-1
MapEni_CompetitionResultsLED:
                binclude "data/General/Competition Menu/Enigma Map/Menu.eni"
                even
MapUnc_CompetitionResultsLetters:
                binclude "data/General/Competition Menu/Uncompressed Map/Results Letters.bin"
                even
MapUnc_CompetitionResultsDividers:
                binclude "data/General/Competition Menu/Uncompressed Map/Results Dividers.bin"
                even
MapUnc_CompetitionResultsTOTAL:
                binclude "data/General/Competition Menu/Uncompressed Map/Results TOTAL.bin"
                even
MapUnc_ResultsWin:
                binclude "data/General/Competition Menu/Uncompressed Map/Results Win.bin"
                even
MapUnc_ResultsLose:
                binclude "data/General/Competition Menu/Uncompressed Map/Results Lose.bin"
                even
MapUnc_ResultsTie:
                binclude "data/General/Competition Menu/Uncompressed Map/Results Tie.bin"
                even
; ---------------------------------------------------------------------------
