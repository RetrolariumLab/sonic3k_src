; Owner: game/modes/s3
; Responsibility: Competition entry menu, shared menu objects, palette and menu-object mapping storage
; Source provenance and ranges: config/reconstruction/source_layout.json
Competition_Menu:
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
                move.w  #$8730,(a6)
                move.w  #$8B00,(a6)
                move.w  #$8C81,(a6)
                move.w  #$9011,(a6)
                jsr     Menu_FillPlaneAWithPriorityBlankTiles(pc)
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                clr.w   (Level_frame_counter).w
                cmpi.b  #3,(Competition_menu_selection).w
                blo.s   S3CompMenu_LoadBackgroundAndQueueArt
                clr.b   (Competition_menu_selection).w

S3CompMenu_LoadBackgroundAndQueueArt:
                lea     (MapEni_S3MenuBG).l,a0
                lea     (RAM_start).l,a1
                move.w  #make_art_tile(ArtTile_S3MenuBG,3,0),d0
                jsr     (Eni_Decomp).l
                lea     (RAM_start).l,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     (ArtKos_S3MenuBG).l,a0          ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source
                movea.w #tiles_to_bytes(ArtTile_S3MenuBG),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.l  #locret_952E,(_unkEF44_1).w
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     (ArtKos_CompetitionLevel).l,a0  ; Decompress source
                lea     (RAM_start).l,a1                ; Decompress destination/Transfer source, used by the next KosArt_To_VDP also
                movea.w #tiles_to_bytes(ArtTile_Competition_LevSel),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                lea     (ArtKos_CompetitionMode).l,a0   ; Decompress source
                movea.w #tiles_to_bytes(ArtTile_Competition_ModeSel),a2  ; Transfer destination
                jsr     KosArt_To_VDP(pc)
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                lea     Pal_Competition1(pc),a0
                lea     (Target_palette).w,a1
                moveq   #bytesToLcnt($60),d0

S3CompMenu_CopyThreeTargetPaletteLines:
                move.l  (a0)+,(a1)+
                dbf     d0,S3CompMenu_CopyThreeTargetPaletteLines
                lea     (Pal_CompetitionMenuBG).l,a0
                moveq   #bytesToLcnt($20),d0

S3CompMenu_CopyBGPaletteAndPrepActors:
                move.l  (a0)+,(a1)+
                dbf     d0,S3CompMenu_CopyBGPaletteAndPrepActors
                lea     (Object_RAM).w,a0
                lea     CompetitionMenu_ActorRecords(pc),a1
                move.w  (a1)+,d0

S3CompMenu_BuildActorsAndEnableDisplay:
                move.l  (a1)+,(a0)
                move.w  #make_art_tile(ArtTile_Competition_ModeSel,0,0),art_tile(a0)
                move.l  #Map_CompetitionObject,mappings(a0)
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,$2E(a0)
                lea     next_object(a0),a0
                dbf     d0,S3CompMenu_BuildActorsAndEnableDisplay
                jsr     (Init_SpriteTable).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                moveq   #signextendB(mus_CompetitionMenu),d0
                jsr     (Play_Music).l
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                bsr.w   Pal_FadeFromBlack

S3CompMenu_RunMenuAndCheckCancelFirst:
                move.b  #VInt_ID_1E,(V_int_routine).w
                jsr     (Wait_VSync).l
                addq.w  #1,(Level_frame_counter).w
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                move.b  d0,d1
                andi.b  #button_A_mask|button_B_mask|button_C_mask|button_start_mask,d1
                beq.w   S3CompMenu_HandleUpAndWrap
                btst    #button_B,d1
                bne.s   S3CompMenu_ReturnToTitle
                moveq   #0,d2
                move.b  (Competition_menu_selection).w,d2
                add.w   d2,d2
                jmp     S3CompMenu_DispatchRaceOrExit(pc,d2.w)
; ---------------------------------------------------------------------------

S3CompMenu_DispatchRaceOrExit:
                bra.s   S3CompMenu_OpenPlayerMenu
; ---------------------------------------------------------------------------
                bra.s   S3CompMenu_OpenZoneMenu
; ---------------------------------------------------------------------------
                bra.s   S3CompMenu_OpenTimeAttackOnP1Confirm
; ---------------------------------------------------------------------------

S3CompMenu_ReturnToTitle:
                move.b  #GameMode_TitleScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

S3CompMenu_OpenPlayerMenu:
                clr.b   (Competition_type).w
                move.b  (Competition_menu_items).w,(Competition_items).w
                move.b  (Ctrl_2_pressed).w,d0
                andi.b  #button_A_mask|button_C_mask|button_start_mask,d0
                sne     (Not_ghost_flag).w
                move.b  #GameMode_CompetitionPlayerSelect,(Game_mode).w
                bra.s   S3CompMenu_PrepareScratchClear
; ---------------------------------------------------------------------------

S3CompMenu_OpenZoneMenu:
                move.b  #3,(Competition_type).w
                move.b  (Competition_menu_items).w,(Competition_items).w
                move.b  (Ctrl_2_pressed).w,d0
                andi.b  #button_A_mask|button_C_mask|button_start_mask,d0
                sne     (Not_ghost_flag).w
                move.b  #GameMode_CompetitionLevelSelect,(Game_mode).w
                bra.s   S3CompMenu_PrepareScratchClear
; ---------------------------------------------------------------------------

S3CompMenu_OpenTimeAttackOnP1Confirm:
                move.b  (Ctrl_1_pressed).w,d2
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d2
                beq.s   S3CompMenu_HandleUpAndWrap
                move.w  #-1,(Competition_settings).w
                clr.b   (Not_ghost_flag).w
                move.b  #GameMode_CompetitionLevelSelect+$80,(Game_mode).w

S3CompMenu_PrepareScratchClear:
                lea     ((RAM_start+$7800)&$FFFFFF).l,a1
                moveq   #0,d0
                moveq   #bytesToLcnt($28),d1

S3CompMenu_ClearScratchAndPlayConfirm:
                move.l  d0,(a1)+
                dbf     d1,S3CompMenu_ClearScratchAndPlayConfirm
                moveq   #signextendB(sfx_Starpost),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

S3CompMenu_HandleUpAndWrap:
                moveq   #0,d2
                move.b  (Competition_menu_selection).w,d1
                lsr.w   #1,d0
                bcc.s   S3CompMenu_HandleDownAndWrap
                moveq   #signextendB(sfx_Switch),d2
                subq.b  #1,d1
                bcc.s   S3CompMenu_StoreChoiceAndPlaySwitch
                moveq   #3,d1
                bra.s   S3CompMenu_StoreChoiceAndPlaySwitch
; ---------------------------------------------------------------------------

S3CompMenu_HandleDownAndWrap:
                lsr.w   #1,d0
                bcc.s   S3CompMenu_StoreChoiceAndPlaySwitch
                moveq   #signextendB(sfx_Switch),d2
                addq.b  #1,d1
                cmpi.b  #3,d1
                bls.s   S3CompMenu_StoreChoiceAndPlaySwitch
                moveq   #0,d1

S3CompMenu_StoreChoiceAndPlaySwitch:
                move.b  d1,(Competition_menu_selection).w
                move.w  d2,d0
                beq.s   S3CompMenu_RepeatMenuFrame
                jsr     (Play_SFX).l

S3CompMenu_RepeatMenuFrame:
                bra.w   S3CompMenu_RunMenuAndCheckCancelFirst
; ---------------------------------------------------------------------------

CompetitionMenu_UpdateSelectionPalette:
                move.b  $2E(a0),d0
                bmi.s   CompetitionMenu_DrawLabel
                andi.w  #$9FFF,art_tile(a0)
                move.w  #palette_line_1,d1
                cmp.b   (Competition_menu_selection).w,d0
                bne.s   CompetitionMenu_ApplyLabelPalette
                move.w  #palette_line_2,d1

CompetitionMenu_ApplyLabelPalette:
                or.w    d1,art_tile(a0)

CompetitionMenu_DrawLabel:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

CompetitionMenu_UpdateItemsToggleCursor:
                cmpi.b  #1,(Competition_menu_selection).w
                bhi.s   CompetitionMenu_ReturnFromItemsCursor
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                andi.w  #button_left_mask|button_right_mask,d0
                beq.s   CompetitionMenu_SelectItemsCursorX
                tst.b   (Competition_menu_items).w
                seq     (Competition_menu_items).w
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

CompetitionMenu_SelectItemsCursorX:
                move.w  #$15C,d0
                tst.b   (Competition_menu_items).w
                beq.s   S3CompMenu_PositionAndBlinkItemsCursor
                addi.w  #$20,d0

S3CompMenu_PositionAndBlinkItemsCursor:
                move.w  d0,x_pos(a0)
                btst    #3,(Level_frame_counter+1).w
                beq.s   CompetitionMenu_ReturnFromItemsCursor
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

CompetitionMenu_ReturnFromItemsCursor:
                rts
; ---------------------------------------------------------------------------
Pal_Competition1:
                binclude "data/General/Competition Menu/Palettes/1.bin"
                even
CompetitionMenu_ActorRecords:
                dc.w    7-1
                dc.l    CompetitionMenu_UpdateSelectionPalette
                dc.w    $114,   $A0
                dc.b    0,   0
                dc.l    CompetitionMenu_UpdateSelectionPalette
                dc.w    $10C,   $C0
                dc.b    1,   1
                dc.l    CompetitionMenu_UpdateSelectionPalette
                dc.w    $108,   $E0
                dc.b    2,   2
                dc.l    CompetitionMenu_UpdateSelectionPalette
                dc.w    $13C,  $120
                dc.b    3,   3
                dc.l    CompetitionMenu_UpdateSelectionPalette
                dc.w    $164,   $B0
                dc.b    4, $FF
                dc.l    CompetitionMenu_UpdateSelectionPalette
                dc.w    $184,   $B0
                dc.b    5, $FF
                dc.l    CompetitionMenu_UpdateItemsToggleCursor
                dc.w    0,   $A8
                dc.b    6, $FF
Map_CompetitionObject:
                include "src/ui/shared/competition_menu/mappings/competition_objects.s"
; ---------------------------------------------------------------------------
