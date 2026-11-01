; Owner: game/modes/sk
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
                lea     (MapEni_CompetitionResultsLED).l,a0
                lea     (RAM_start+$1000).l,a1
                move.w  #make_art_tile(ArtTile_Competition_Results,1,1),d0
                jsr     (Eni_Decomp).l
                lea     VRAMDatList_BBAC(pc),a0
                jsr     Copy_Listed_Data_To_VRAM(pc)
                jsr     SKCompBuildFiveRaceResultsTotalsWinsAndBlinkMap(pc)
                lea     (ArtKos_S3MenuBG).l,a0          ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source
                movea.w #tiles_to_bytes(ArtTile_S3MenuBG),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.l  #locret_A85C,(_unkEF44_1).w
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

loc_B888:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_B888
                lea     (Pal_Competition2).l,a0
                moveq   #bytesToLcnt(Target_palette_line_4-Target_palette_line_2),d0

loc_B896:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_B896
                lea     (Pal_CompetitionResults).l,a0
                moveq   #bytesToLcnt(Target_palette_end-Target_palette_line_4),d0

loc_B8A4:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_B8A4
                lea     (Object_RAM).w,a0
                lea     ObjDat_BB4A(pc),a1
                move.w  (a1)+,d0

loc_B8B4:
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
                dbf     d0,loc_B8B4
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

loc_B922:
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                addq.w  #1,(Level_frame_counter).w
                move.w  (_unkEEA0).w,d7
                beq.s   loc_B952
                btst    #3,(Level_frame_counter+1).w
                bne.s   loc_B94A
                lea     (Plane_buffer+$20).w,a1
                jsr     CompetitionMenuUploadEightByTwoTileBlock(pc)
                bra.s   loc_B952
; ---------------------------------------------------------------------------

loc_B94A:
                move.l  (_unkEE98).w,d6
                jsr     SKCompFormatAndUploadMinuteSecondHundredthTime(pc)

loc_B952:
                tst.w   (Events_bg+$16).w
                beq.s   loc_B95E
                subq.w  #1,(Events_bg+$16).w
                bra.s   loc_B996
; ---------------------------------------------------------------------------

loc_B95E:
                move.b  (Ctrl_1_pressed).w,d0
                tst.b   (Not_ghost_flag).w
                beq.s   loc_B96C
                or.b    (Ctrl_2_pressed).w,d0

loc_B96C:
                move.w  (H_scroll_buffer).w,d1
                beq.s   loc_B97A
                cmpi.w  #$FF78,d1
                beq.s   loc_B988
                bra.s   loc_B980
; ---------------------------------------------------------------------------

loc_B97A:
                andi.w  #button_start_mask|button_A_mask|button_C_mask,d0
                beq.s   loc_B996

loc_B980:
                subq.w  #8,d1
                move.w  d1,(H_scroll_buffer).w
                bra.s   loc_B996
; ---------------------------------------------------------------------------

loc_B988:
                andi.w  #button_start_mask|button_A_mask|button_C_mask,d0
                beq.s   loc_B996
                move.b  #GameMode_CompetitionMenu,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_B996:
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                bra.w   loc_B922
; ---------------------------------------------------------------------------

Obj_Competition_B9A6:
                move.l  #Map_CompetitionPlayerSprite,mappings(a0)
                move.w  #make_art_tile(ArtTile_Competition_CharSel,1,1),art_tile(a0)
                move.b  (P1_character).w,d0
                tst.b   $2E(a0)
                beq.s   loc_B9C2
                move.b  (P2_character).w,d0

loc_B9C2:
                move.b  d0,mapping_frame(a0)
                jmp     Obj_Competition_StaticSprite(pc)
; ---------------------------------------------------------------------------

Obj_Competition_B9CA:
                move.w  #make_art_tile(ArtTile_Competition_Results,1,1),art_tile(a0)
                move.b  (_unkEEA2).w,d0
                move.b  (_unkEEA2+1).w,d1
                tst.b   $2E(a0)
                beq.s   loc_B9E0
                exg     d0,d1

loc_B9E0:
                moveq   #$D,d2
                cmp.b   d0,d1
                beq.s   loc_B9EC
                bcs.s   loc_B9EA
                addq.w  #1,d2

loc_B9EA:
                subq.b  #2,d2

loc_B9EC:
                move.b  d2,mapping_frame(a0)
                cmpi.b  #$B,d2
                bne.w   Obj_Competition_StaticSprite
                btst    #3,(Level_frame_counter+1).w
                bne.w   Obj_Competition_StaticSprite
                rts

; =============== S U B R O U T I N E =======================================

SKCompBuildFiveRaceResultsTotalsWinsAndBlinkMap:
                lea     ((RAM_start+$7800)&$FFFFFF).l,a0
                move.w  #$C15A,d7
                jsr     SKCompDrawFiveSequentialTimeRows(pc)
                move.w  #$C7DA,d7
                jsr     SKCompDrawFiveSequentialTimeRows(pc)
                lea     ((RAM_start+$7800)&$FFFFFF).l,a0
                jsr     SKCompSumFiveBinaryMinuteSecondHundredthTimes(pc)
                move.w  #$C65A,d7
                move.l  d6,(_unkEE98).w
                move.w  d7,(_unkEEA0).w
                jsr     SKCompFormatAndUploadMinuteSecondHundredthTime(pc)
                jsr     SKCompSumFiveBinaryMinuteSecondHundredthTimes(pc)
                move.w  #$CCDA,d7
                cmp.l   (_unkEE98).w,d6
                bhi.s   loc_BA52
                bne.s   loc_BA4A
                clr.w   (_unkEEA0).w
                bra.s   loc_BA52
; ---------------------------------------------------------------------------

loc_BA4A:
                move.l  d6,(_unkEE98).w
                move.w  d7,(_unkEEA0).w

loc_BA52:
                jsr     SKCompFormatAndUploadMinuteSecondHundredthTime(pc)
                clr.w   (_unkEEA2).w
                lea     ((RAM_start+$7800)&$FFFFFF).l,a0
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$148,VRAM,WRITE),d5
                moveq   #5-1,d7

loc_BA68:
                lea     (MapUnc_ResultsWin).l,a1
                lea     (MapUnc_ResultsLose).l,a2
                addq.b  #1,(_unkEEA2).w
                move.l  (a0)+,d0
                cmp.l   x_pos(a0),d0
                beq.s   loc_BA8E
                bcs.s   loc_BA9A
                exg     a1,a2
                subq.b  #1,(_unkEEA2).w
                addq.b  #1,(_unkEEA2+1).w
                bra.s   loc_BA9A
; ---------------------------------------------------------------------------

loc_BA8E:
                lea     (MapUnc_ResultsTie).l,a1
                movea.l a1,a2
                subq.b  #1,(_unkEEA2).w

loc_BA9A:
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
                dbf     d7,loc_BA68
                move.w  (_unkEEA0).w,d7
                beq.s   locret_BAEC
                move.l  (_unkEE98).w,d6
                jsr     SKCompFormatAndUploadMinuteSecondHundredthTime(pc)
                lea     (Plane_buffer).w,a0
                lea     $20(a0),a1
                moveq   #$10-1,d0

loc_BADC:
                move.w  (a0)+,d1
                andi.w  #$9FFF,d1
                ori.w   #palette_line_3,d1
                move.w  d1,(a1)+
                dbf     d0,loc_BADC

locret_BAEC:
                rts
; End of function SKCompBuildFiveRaceResultsTotalsWinsAndBlinkMap

; =============== S U B R O U T I N E =======================================

SKCompDrawFiveSequentialTimeRows:
                moveq   #5-1,d0

loc_BAF0:
                move.w  d0,-(sp)
                move.l  (a0)+,d6
                jsr     SKCompFormatAndUploadMinuteSecondHundredthTime(pc)
                addi.w  #$100,d7
                move.w  (sp)+,d0
                dbf     d0,loc_BAF0
                rts
; End of function SKCompDrawFiveSequentialTimeRows

; =============== S U B R O U T I N E =======================================

SKCompSumFiveBinaryMinuteSecondHundredthTimes:
                clr.l   (_unkEF40_1).w
                moveq   #5-1,d7

loc_BB0A:
                move.l  (a0)+,d6
                lea     (_unkEF44_2).w,a1
                add.b   d6,-(a1)
                cmpi.b  #100,(a1)
                blo.s   loc_BB20
                subi.b  #100,(a1)
                addq.b  #1,-1(a1)

loc_BB20:
                lsr.l   #8,d6
                add.b   d6,-(a1)
                cmpi.b  #60,(a1)
                blo.s   loc_BB32
                subi.b  #60,(a1)
                addq.b  #1,-1(a1)

loc_BB32:
                lsr.l   #8,d6
                add.b   d6,-(a1)
                cmpi.b  #100,(a1)
                blo.s   loc_BB40
                move.b  #99,(a1)

loc_BB40:
                dbf     d7,loc_BB0A
                move.l  (_unkEF40_1).w,d6
                rts
; End of function SKCompSumFiveBinaryMinuteSecondHundredthTimes

; ---------------------------------------------------------------------------
ObjDat_BB4A:
                dc.w    8-1
                dc.l    Obj_Competition_StaticSprite
                dc.w    $148,   $A1, palette_line_1
                dc.b    3,   0
                dc.l    Obj_Competition_StaticSprite
                dc.w    $14D,   $B9, palette_line_0
                dc.b    0,   0
                dc.l    Obj_Competition_B9A6
                dc.w    $14D,   $D3, palette_line_0
                dc.b    0,   0
                dc.l    Obj_Competition_B9CA
                dc.w    $CC,   $BC, palette_line_0
                dc.b    0,   0
                dc.l    Obj_Competition_StaticSprite
                dc.w    $14A,  $109, palette_line_1
                dc.b    4,   0
                dc.l    Obj_Competition_StaticSprite
                dc.w    $14D,  $121, palette_line_0
                dc.b    0,   0
                dc.l    Obj_Competition_B9A6
                dc.w    $14D,  $13B, palette_line_0
                dc.b    0,   1
                dc.l    Obj_Competition_B9CA
                dc.w    $CC,  $124, palette_line_0
                dc.b    0,   1
VRAMDatList_BBAC:
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
; ---------------------------------------------------------------------------
