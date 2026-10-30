; Owner: game/modes/s3
; Responsibility: Preserved Sonic 2 style competition selection, completion marks and menu text transfer
; Source provenance and ranges: config/reconstruction/source_layout.json
LevelSelect_S2Options:
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
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                move.l  #vdpComm(tiles_to_bytes($010),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_S22POptions).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_S2MenuBox),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_S2MenuBox).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_S2LevelSelectPics),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_S2LevelSelectPics).l,a0
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
                cmpi.b  #GameMode_OptionsMenu,(Game_mode).w  ; is the game mode id equal to $24?
                beq.w   MenuScreen_Options              ; if so, then branch to the options menu (leftover from Sonic 2)
                cmpi.b  #GameMode_LevelSelect,(Game_mode).w  ; is the game mode id equal to $28?
                beq.w   MenuScreen_LevelSelect          ; if so, then branch to the level select menu
                lea     (RAM_start).l,a1
                lea     (MapEni_S2LevSel2P).l,a0
                move.w  #make_art_tile(ArtTile_S2MenuBox,0,0),d0
                bsr.w   Eni_Decomp
                lea     (RAM_start+$198).l,a1
                lea     (MapEni_S2LevSel2P).l,a0
                move.w  #make_art_tile(ArtTile_S2MenuBox,1,0),d0
                bsr.w   Eni_Decomp
                lea     (RAM_start+$330).l,a1
                lea     (MapEni_S2LevSelIcon).l,a0
                move.w  #make_art_tile(ArtTile_S2LevelSelectPics,0,0),d0
                bsr.w   Eni_Decomp
                lea     (RAM_start+$498).l,a2
                moveq   #$10-1,d1

loc_626C:
                move.w  #make_art_tile(ArtTile_S2MenuBox+$B,1,0),(a2)+
                dbf     d1,loc_626C
                bsr.w   Update2PLevSelSelection
                addq.b  #1,(Current_zone_2P).w
                andi.b  #3,(Current_zone_2P).w
                bsr.w   ClearOld2PLevSelSelection
                addq.b  #1,(Current_zone_2P).w
                andi.b  #3,(Current_zone_2P).w
                bsr.w   ClearOld2PLevSelSelection
                addq.b  #1,(Current_zone_2P).w
                andi.b  #3,(Current_zone_2P).w
                bsr.w   ClearOld2PLevSelSelection
                addq.b  #1,(Current_zone_2P).w
                andi.b  #3,(Current_zone_2P).w
                clr.w   (Player_mode).w
                clr.b   (Current_act_2P).w
                clr.w   (Results_screen_2P).w
                clr.b   (Level_started_flag).w
                clr.w   (Anim_Counters).w
                clr.w   (_unkFF98).w
                lea     (AniPLC_SONICMILES).l,a2
                jsr     (AnimateTiles_DoAniPLC).l
                moveq   #PalID_S2Menu,d0
                bsr.w   LoadPalette
                lea     (Normal_palette_line_3).w,a1
                lea     (Target_palette_line_3).w,a2
                moveq   #bytesToLcnt(Normal_palette_line_4-Normal_palette_line_3),d1

loc_62E0:
                move.l  (a1),(a2)+
                clr.l   (a1)+
                dbf     d1,loc_62E0
                moveq   #signextendB(mus_DataSelect),d0
                bsr.w   Play_Music
                move.w  #(30*60)-1,(Demo_timer).w
                clr.w   (Competition_mode).w
                clr.l   (Camera_X_pos).w
                clr.l   (Camera_Y_pos).w
                move.b  #VInt_ID_16,(V_int_routine).w
                bsr.w   Wait_VSync
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                bsr.w   Pal_FadeFromBlack

LevelSelect2P_Main:
                move.b  #VInt_ID_16,(V_int_routine).w
                bsr.w   Wait_VSync
                move    #$2700,sr
                bsr.w   ClearOld2PLevSelSelection
                bsr.w   LevelSelect2P_Controls
                bsr.w   Update2PLevSelSelection
                move    #$2300,sr
                lea     (AniPLC_SONICMILES).l,a2
                jsr     (AnimateTiles_DoAniPLC).l
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                andi.b  #button_start_mask,d0
                bne.s   LevelSelect2P_PressStart
                bra.w   LevelSelect2P_Main
; ---------------------------------------------------------------------------

LevelSelect2P_PressStart:
                bsr.w   Chk2PZoneCompletion
                bmi.s   loc_6368
                moveq   #signextendB(sfx_Error),d0
                bsr.w   Play_SFX
                bra.w   LevelSelect2P_Main
; ---------------------------------------------------------------------------

loc_6368:
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------
; unused leftover from Sonic 2
                moveq   #0,d0
                move.b  (Current_zone_2P).w,d0
                add.w   d0,d0
                move.w  LevelSelect2P_LevelOrder(pc,d0.w),d0
                bmi.s   loc_63BE
                move.w  d0,(Current_zone_and_act).w
                move.w  d0,(Apparent_zone_and_act).w
                move.w  d0,(Saved_zone_and_act).w
                move.w  #1,(Competition_mode).w
                move.b  #GameMode_Level,(Game_mode).w
                move.b  #0,(Last_star_post_hit).w
                move.b  #0,(Special_bonus_entry_flag).w
                moveq   #0,d0
                move.l  d0,(Score).w
                move.l  d0,(Score_P2).w
                move.l  #5000,(Next_extra_life_score).w
                move.l  #5000,(Next_extra_life_score_P2).w
                rts
; ---------------------------------------------------------------------------

loc_63BE:
                move.b  #4,(Current_special_stage).w
                move.b  #GameMode_SpecialStage_S2,(Game_mode).w
                moveq   #1,d0
                move.w  d0,(Competition_mode).w
                move.w  d0,(Competition_settings).w
                rts
; ---------------------------------------------------------------------------
LevelSelect2P_LevelOrder:
                dc.w    emerald_hill_zone_act_1
                dc.w    mystic_cave_zone_act_1
                dc.w    casino_night_zone_act_1
                dc.w    $FFFF

; =============== S U B R O U T I N E =======================================

LevelSelect2P_Controls:
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                move.b  d0,d1
                andi.b  #button_up_mask|button_down_mask,d0
                beq.s   loc_63F4
                bchg    #1,(Current_zone_2P).w

loc_63F4:
                andi.b  #button_left_mask|button_right_mask,d1
                beq.s   locret_6400
                bchg    #0,(Current_zone_2P).w

locret_6400:
                rts
; End of function LevelSelect2P_Controls

; =============== S U B R O U T I N E =======================================

Update2PLevSelSelection:
                moveq   #0,d0
                move.b  (Current_zone_2P).w,d0
                lsl.w   #4,d0
                lea     (S2LevSel2PIconData).l,a3
                lea     (a3,d0.w),a3
                move.w  #palette_line_3,d0
                lea     (RAM_start+$48).l,a2
                movea.l (a3)+,a1
                bsr.w   MenuScreenTextToRAM
                lea     (RAM_start+$94).l,a2
                movea.l (a3)+,a1
                bsr.w   MenuScreenTextToRAM
                lea     (RAM_start+$D8).l,a2
                movea.l 4(a3),a1
                bsr.w   Chk2PZoneCompletion
                bmi.s   loc_6446
                lea     (RAM_start+$468).l,a1

loc_6446:
                moveq   #3-1,d1

loc_6448:
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                lea     $1A(a2),a2
                dbf     d1,loc_6448
                lea     (RAM_start).l,a1
                move.l  (a3)+,d0
                moveq   #17-1,d1
                moveq   #12-1,d2
                bsr.w   Plane_Map_To_VRAM
                lea     (Pal_S2LevelIcons).l,a1
                moveq   #0,d0
                move.b  (a3),d0
                lsl.w   #5,d0
                lea     (a1,d0.w),a1
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d1

loc_647A:
                move.l  (a1)+,(a2)+
                dbf     d1,loc_647A
                rts
; End of function Update2PLevSelSelection

; =============== S U B R O U T I N E =======================================

Chk2PZoneCompletion:
                moveq   #0,d0
                move.b  (Current_zone_2P).w,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                add.w   d0,d0
                lea     (a5,d0.w),a5
                move.w  (a5),d0
                add.w   2(a5),d0
                rts
; End of function Chk2PZoneCompletion

; =============== S U B R O U T I N E =======================================

ClearOld2PLevSelSelection:
                moveq   #0,d0
                move.b  (Current_zone_2P).w,d0
                lsl.w   #4,d0
                lea     (S2LevSel2PIconData).l,a3
                lea     (a3,d0.w),a3
                moveq   #palette_line_0,d0
                lea     (RAM_start+$1E0).l,a2
                movea.l (a3)+,a1
                bsr.w   MenuScreenTextToRAM
                lea     (RAM_start+$22C).l,a2
                movea.l (a3)+,a1
                bsr.w   MenuScreenTextToRAM
                lea     (RAM_start+$270).l,a2
                lea     (RAM_start+$498).l,a1
                bsr.w   Chk2PZoneCompletion
                bmi.s   loc_64E0
                lea     (RAM_start+$468).l,a1

loc_64E0:
                moveq   #3-1,d1

loc_64E2:
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                lea     $1A(a2),a2
                dbf     d1,loc_64E2
                lea     (RAM_start+$198).l,a1
                move.l  (a3)+,d0
                moveq   #17-1,d1
                moveq   #12-1,d2
                bra.w   Plane_Map_To_VRAM
; End of function ClearOld2PLevSelSelection

; ---------------------------------------------------------------------------
S2LevSel2PIconData:

; Assembly macro to declare icon data for a 2P level select icon
iconData        macro   txtlabel,txtlabel2,vramAddr,iconPal,iconAddr
                    dc.l    txtlabel, txtlabel2         ; text locations
                    dc.l    vdpComm(vramAddr,VRAM,WRITE)  ; VRAM location to place data
                    dc.l    iconPal<<24|((iconAddr)&$FFFFFF)  ; icon palette and plane data location
                endm

                iconData Text2P_EmeraldHill,Text2P_Zone, VRAM_Plane_A_Name_Table+planeLoc(64,2,2),   0,RAM_start+$330
                iconData Text2P_MysticCave, Text2P_Zone, VRAM_Plane_A_Name_Table+planeLoc(64,22,2),  5,RAM_start+$3A8
                iconData Text2P_CasinoNight,Text2P_Zone, VRAM_Plane_A_Name_Table+planeLoc(64,2,15),  6,RAM_start+$3C0
                iconData Text2P_Special,    Text2P_Stage,VRAM_Plane_A_Name_Table+planeLoc(64,22,15),12,RAM_start+$450

; =============== S U B R O U T I N E =======================================

MenuScreenTextToRAM:
                moveq   #0,d1
                move.b  (a1)+,d1

                .loop:
                move.b  (a1)+,d0
                move.w  d0,(a2)+
                dbf     d1,.loop
                rts
; End of function MenuScreenTextToRAM

; ---------------------------------------------------------------------------

; leftover from Sonic 2
