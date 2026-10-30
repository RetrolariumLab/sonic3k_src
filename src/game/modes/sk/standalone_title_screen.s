; Owner: game/modes/sk
; Responsibility: Standalone Sonic and Knuckles title initialization, active loop and Mushroom Hill attract preparation
; Source provenance and ranges: config/reconstruction/source_layout.json
SK_Alone_Title_Screen:
                lea     (ArtKos_SKTitleScreenBG).l,a0
                lea     (RAM_start).l,a1
                bsr.w   Kos_Decomp
                lea     (ArtKos_BigSEGA).l,a0
                bsr.w   Kos_Decomp
                lea     (ArtKos_SKTitle_SonicFall).l,a0  ; Get title BG, Sega logo, and Sonic falling frame going
                bsr.w   Kos_Decomp
                move.w  a1,d3
                lsr.w   #1,d3
                move.l  #RAM_start&$FFFFFF,d1
                move.w  #tiles_to_bytes($000),d2
                move.w  #$E20,d3
                jsr     (Add_To_DMA_Queue).l            ; DMA the BG first to $0 in VRAM
                move.l  #RAM_start&$FFFFFF+$1C40,d1
                move.w  #tiles_to_bytes(ArtTile_SKTitle_Sega),d2
                move.w  #$1640,d3
                jsr     (Add_To_DMA_Queue).l            ; Then DMA the logo and Sonic falling frame to $9380 in VRAM
                lea     (RAM_start+$4E00).l,a1
                lea     (ArtKos_SKTitle_DeathEgg).l,a0
                bsr.w   Kos_Decomp
                move.l  #RAM_start&$FFFFFF+$4E00,d1
                move.w  #tiles_to_bytes(ArtTile_SKTitle_DeathEgg),d2
                move.w  #$720,d3
                jsr     (Add_To_DMA_Queue).l            ; DMA the Death Egg title screen art to $D000 in VRAM
                lea     (RAM_start+$5D00).l,a1
                lea     (ArtKos_SKTitle_Mountain).l,a0
                bsr.w   Kos_Decomp
                move.l  #RAM_start&$FFFFFF+$5D00,d1
                move.w  #tiles_to_bytes(ArtTile_SKTitle_Mountain),d2
                move.w  #$150,d3
                jsr     (Add_To_DMA_Queue).l            ; DMA the little section of mountain that is drawn above the Death Egg
                lea     (RAM_start+$7400).l,a1
                lea     (MapEni_SKTitle_Sega).l,a0      ; Get the SEGA logo mappings
                move.w  #make_art_tile(ArtTile_SKTitle_Sega,0,1),d0
                bsr.w   Eni_Decomp
                tst.b   (Graphics_flags).w
                bmi.s   loc_5122
                move.w  #make_art_tile(ArtTile_SKTitle_Sega,1,1),d0
                move.w  d0,(RAM_start+$775C).l
                move.w  d0,(RAM_start+$775E).l
                move.w  d0,(RAM_start+$7760).l
                move.w  d0,(RAM_start+$77AC).l
                move.w  d0,(RAM_start+$77AE).l
                move.w  d0,(RAM_start+$77B0).l          ; Remove the TM from the Sega logo if on a Japan console

loc_5122:
                lea     (RAM_start+$7400).l,a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l           ; Copy Sega logo mappings to VRAM location $C000
                lea     (RAM_start+$7CC0).l,a1
                lea     (MapEni_SKTitle_Background).l,a0
                move.w  #make_art_tile($000,0,0),d0
                bsr.w   Eni_Decomp
                lea     (RAM_start+$7CC0).l,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
                bsr.w   RAM_Map_Data_To_VDP             ; Copy SK Title Background mappings to VRAM location $E000
                lea     (RAM_start+$8580).w,a1
                lea     (MapEni_SKTitle_Frame1).l,a0
                move.w  #make_art_tile(ArtTile_SKTitle_SonicKnuxStand,0,1),d0
                bsr.w   Eni_Decomp
                lea     (RAM_start+$8E40).w,a1
                lea     (MapEni_SKTitle_Frame2).l,a0
                move.w  #make_art_tile(ArtTile_SKTitle_SonicKnuxStand,0,1),d0
                bsr.w   Eni_Decomp
                lea     (RAM_start+$9700).w,a1
                lea     (MapEni_SKTitle_Frame3).l,a0
                move.w  #make_art_tile(ArtTile_SKTitle_SonicKnuxStand,0,1),d0
                bsr.w   Eni_Decomp
                lea     (RAM_start+$9FC0).w,a1
                lea     (MapEni_SKTitle_Frame4).l,a0
                move.w  #make_art_tile(ArtTile_SKTitle_SonicKnuxStand,0,1),d0
                bsr.w   Eni_Decomp
                lea     (ArtKos_SKTitle_SonKnuxHand).l,a1
                lea     (RAM_start+$4800).l,a2
                jsr     (Queue_Kos).l                   ; Queue the Sonic/Knuckles hand animation art
                lea     (Target_palette).w,a1
                moveq   #4-1,d1

loc_51BC:
                move.w  #0,(a1)+
                moveq   #$F-1,d0

loc_51C2:
                move.w  #$EEE,(a1)+                     ; Set up the palette to full white
                dbf     d0,loc_51C2
                dbf     d1,loc_51BC
                lea     (Pal_SKTitle_SegaBG).l,a0
                lea     (Target_palette_line_2).w,a1
                moveq   #bytesToLcnt($20),d0

loc_51DA:
                move.l  (a0)+,(a1)+                     ; Load Sega palette into the first F colors of pal line 1
                dbf     d0,loc_51DA
                move.w  #3*60,(Demo_timer).w            ; Set vsync timer to 3 seconds (180 frames NTSC)
                btst    #6,(Graphics_flags).w
                beq.s   loc_51F4
                move.w  #3*50,(Demo_timer).w            ; Set vsync timer to 3 seconds (150 frames PAL)

loc_51F4:
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l         ; Turn the display on
                bsr.w   Pal_FadeFromBlack               ; Fade to Sega screen
                moveq   #signextendB(cmd_SEGA),d0       ; SEGA sound
                bsr.w   Play_Music

loc_520C:
                move.b  #VInt_ID_14,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                bsr.w   Wait_VSync
                jsr     (Process_Kos_Module_Queue).l
                tst.b   (Kos_modules_left).w
                bne.s   loc_520C                        ; Don't allow the game to continue until the Knuckles art has been decompressed
                move.b  (Ctrl_1_pressed).w,d0
                andi.b  #button_start_mask,d0
                bne.w   loc_523A                        ; If start is pressed afterwards, skip to next part of title
                tst.w   (Demo_timer).w
                bne.s   loc_520C                        ; Otherwise, wait for vsync timer to run out

loc_523A:
                moveq   #signextendB(cmd_StopSEGA),d0
                bsr.w   Play_Music                      ; Stop the SEGA sound if necessary
                lea     (Pal_SKTitle_Sonic).l,a0
                lea     (Target_palette).w,a1
                moveq   #bytesToLcnt($80),d0

loc_524C:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_524C                     ; Load the Sonic palette and Sega palette
                lea     (ArtKosM_SonicKnuxStand).l,a1
                move.w  #tiles_to_bytes(ArtTile_SKTitle_SonicKnuxStand),d2
                jsr     (Queue_Kos_Module).l            ; Cue the art Sonic and Knuckles standing
                move.w  #$40-1,(Palette_fade_info).w
                move.w  #$16,(Palette_fade_timer).w     ; Number of frames to fade from white
                move.l  #Obj_SKTitle_SonicFall,(Player_1).w
                move.l  #Obj_SKTitle_DeathEgg,(Player_2).w
                move.l  #Obj_SKTitle_Mountain,(Reserved_object_3).w
                moveq   #signextendB(mus_TitleScreen),d0
                bsr.w   Play_Music                      ; Play the title screen music
                move.b  #3,(Life_count).w
                move.w  #18*60,(Demo_timer).w           ; 18 second delay (1080 frames NTSC)
                btst    #6,(Graphics_flags).w
                beq.s   loc_52A6
                move.w  #18*50,(Demo_timer).w           ; 18 second delay (900 frames PAL)

loc_52A6:
                move.b  #VInt_ID_1A,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                bsr.w   Wait_VSync
                tst.w   (Palette_fade_timer).w
                beq.s   loc_52C4
                subq.w  #1,(Palette_fade_timer).w
                bsr.w   Pal_FromWhite                   ; Fade from white for set number of frames

loc_52C4:
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                bsr.w   SKTitle_DeformBG
                jsr     (Process_Kos_Module_Queue).l
                move.b  (Ctrl_1_pressed).w,d0
                andi.b  #button_start_mask,d0
                bne.w   loc_52F0                        ; If start is pressed, branch
                tst.l   (Dynamic_object_RAM).w          ; test if banner object has been created
                beq.s   loc_52A6                        ; If not, continue with the above
                bra.w   loc_537C
; ---------------------------------------------------------------------------

loc_52F0:
                tst.w   (Palette_fade_timer).w
                bne.s   loc_52A6                        ; If palette fade hasn't completed, go back
                lea     (Dynamic_object_RAM+object_size).w,a0
                bsr.w   Obj_SKTitle_HandAnim            ; Initialize Hand animation object
                move.l  #Obj_SKTitle_DeathEggShake,(Player_2).w  ; Change Death Egg object to second phase
                move.w  #$140,(Player_2+objoff_2E).l
                move.w  #$70,(Player_2+objoff_32).l     ; Set its proper position
                move.w  #3,(Events_routine_fg).w        ; Put title routine counter to max
                moveq   #0,d0
                move.w  d0,(Screen_shake_flag).w        ; Turn off shaking
                move.w  #$100,d0
                move.w  d0,(V_scroll_value_BG).w
                move.w  d0,(V_scroll_value_BG).w
                move.w  d0,(Camera_Y_pos).w
                move.w  d0,(Camera_Y_pos_P2).w          ; Set all Y scrolls to $100
                lea     (Pal_SKTitle_Knux).l,a0
                lea     (Normal_palette_line_2).w,a2
                moveq   #8-1,d0

loc_5342:
                move.l  (a0),$80(a2)
                move.l  (a0)+,(a2)+                     ; Change to Knuckles palette
                dbf     d0,loc_5342
                bsr.w   SKTitle_DeformBG                ; Deform the BG to apply the changes
                move.b  #VInt_ID_1A,(V_int_routine).w
                bsr.w   Wait_VSync                      ; Refresh the screen
                move    #$2700,sr
                lea     (Chunk_table+$7CC0).l,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l           ; Load the background
                lea     (Player_1).w,a0
                bsr.w   Obj_SKTitle_SonicFallFinish     ; Finish the sonic fall object

loc_537C:
                move.b  #VInt_ID_1A,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                bsr.w   Wait_VSync
                tst.w   (Palette_fade_timer).w
                beq.s   loc_539A
                subq.w  #1,(Palette_fade_timer).w
                bsr.w   Pal_FromWhite

loc_539A:
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                bsr.w   SKTitle_DeformBG
                jsr     (Process_Kos_Module_Queue).l
                bsr.w   S3_Level_Select_Code            ; This routine is dummied out
                tst.l   (Dynamic_object_RAM+(object_size*2)).w
                beq.s   loc_537C                        ; If menu object isn't loaded, branch
                tst.w   (Demo_timer).w
                beq.w   loc_546C                        ; If timer has run out, branch forward
                move.b  (Ctrl_1_pressed).w,d0
                andi.b  #button_start_mask,d0
                beq.w   loc_537C                        ; If start is not pressed, branch back
                move.b  #GameMode_Level,(Game_mode).w   ; Play a level
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
                bsr.w   Play_SFX
                moveq   #0,d0
                move.b  (Title_screen_option).w,d0
                cmpi.b  #2,d0
                bhs.w   loc_5464
                add.w   d0,d0
                addq.w  #1,d0
                move.w  d0,(Player_option).w
                move.w  #$700,d0
                move.w  d0,(Current_zone_and_act).w
                move.w  d0,(Apparent_zone_and_act).w
                move.w  d0,(Saved_zone_and_act).w
                clr.w   (Current_special_stage).w
                clr.w   (Emerald_counts).w
                clr.l   (Collected_emeralds_array).w
                clr.w   (Collected_emeralds_array+4).w
                clr.b   (Collected_emeralds_array+6).w
                clr.l   (Collected_special_ring_array).w
                clr.l   (Save_pointer).w
                tst.b   (Level_select_flag).w
                beq.s   locret_546A
                btst    #button_A,(Ctrl_1).w
                beq.s   locret_546A

loc_5464:
                move.b  #GameMode_LevelSelect,(Game_mode).w

locret_546A:
                rts
; ---------------------------------------------------------------------------

loc_546C:
                moveq   #signextendB(cmd_FadeOut),d0    ; Start demo by fading out music
                bsr.w   Play_SFX
                move.w  (Next_demo_number).w,d0         ; Get demo number
                cmpi.w  #3,d0
                bhs.s   loc_547E
                moveq   #3,d0

loc_547E:
                move.w  d0,(Next_demo_number).w
                move.w  d0,(Demo_number).w
                andi.w  #7,d0
                add.w   d0,d0
                lea     DemoLevels(pc),a0
                move.w  (a0,d0.w),d0                    ; Get the right demo level
                move.w  d0,(Current_zone_and_act).w
                move.w  d0,(Apparent_zone_and_act).w
                move.w  d0,(Saved_zone_and_act).w       ; Move it to various level ID locations
                move.w  (Next_demo_number).w,d1
                addq.w  #1,d1
                cmpi.w  #7,d1
                blo.s   loc_54AE
                moveq   #3,d1

loc_54AE:
                move.w  d1,(Next_demo_number).w
                tst.w   d0
                bpl.s   loc_54E0
                move.b  #GameMode_SpecialStage,(Game_mode).w  ; Special stage
                move.b  #1,(Current_special_stage).w
                move.b  #1,(SK_special_stage_flag).w
                move.b  #7,(Current_zone).w
                clr.w   (Emerald_counts).w
                clr.l   (Collected_emeralds_array).w
                clr.w   (Collected_emeralds_array+4).w
                clr.b   (Collected_emeralds_array+6).w
                bra.s   loc_54F0
; ---------------------------------------------------------------------------

loc_54E0:
                cmpi.w  #$700,d0
                bne.s   loc_54EA
                jsr     Prep_MHZDemo(pc)                ; If doing Mushroom Hill demo, do this routine

loc_54EA:
                move.b  #GameMode_Demo,(Game_mode).w

loc_54F0:
                move.w  #1,(Demo_mode_flag).w
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
                rts

; =============== S U B R O U T I N E =======================================

Prep_MHZDemo:
                move.w  #$6F4,(Saved_X_pos).w
                move.w  #$9EC,(Saved_Y_pos).w
                move.b  #1,(Last_star_post_hit).w
                move.b  #1,(Saved_last_star_post_hit).w
                move.w  d0,(Saved_zone_and_act).w
                move.w  d0,(Saved_apparent_zone_and_act).w
                move.w  #make_art_tile(ArtTile_Player_1,0,0),(Saved_art_tile).w
                move.w  #$C0D,(Saved_solid_bits).w
                clr.w   (Saved_ring_count).w
                clr.b   (Saved_extra_life_flags).w
                clr.l   (Saved_timer).w
                clr.b   (Saved_dynamic_resize_routine).w
                move.w  #$AA0,(Saved_camera_max_Y_pos).w
                move.w  #$680,(Saved_camera_X_pos).w
                move.w  #$98C,(Saved_camera_Y_pos).w
                move.w  #$1000,(Saved_mean_water_level).w
                clr.b   (Saved_water_full_screen_flag).w
                rts
; End of function Prep_MHZDemo
