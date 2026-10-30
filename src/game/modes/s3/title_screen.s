; Owner: game/modes/s3
; Responsibility: SEGA transition, Sonic 3 title initialization, title loop and animated player-frame loading
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Sega_Screen:
                move.b  #GameMode_TitleScreen,(Game_mode).w  ; set to title screen
                rts
; ---------------------------------------------------------------------------

Title_Screen:
                moveq   #signextendB(cmd_FadeOut),d0
                bsr.w   Play_Music                      ; Fade music if any is playing
                bsr.w   Clear_Nem_Queue
                bsr.w   Pal_FadeToBlack                 ; Fade out
                move    #$2700,sr
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)                     ; Command $8004 - Disable HInt, HV Counter
                move.w  #$8230,(a6)                     ; Command $8230 - Nametable A at $C000
                move.w  #$8407,(a6)                     ; Command $8407 - Nametable B at $E000
                move.w  #$9011,(a6)                     ; Command $9011 - 64x64 cell nametable area
                move.w  #$9200,(a6)                     ; Command $9200 - Window V position at default
                move.w  #$8B03,(a6)                     ; Command $8B03 - Vscroll full, HScroll line-based
                move.w  #$8700,(a6)                     ; Command $8700 - BG color is Pal 0 Color 0
                clr.b   (Water_full_screen_flag).w
                move.w  #$8C81,(a6)                     ; Command $8C81 - 40cell screen size, no interlacing, no s/h
                bsr.w   Clear_DisplayData
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)  ; Clear object display array
                clearRAM Object_RAM,(Kos_decomp_buffer-Object_RAM)  ; Clear SST array
                clearRAM Tails_CPU_interact,(Sprite_table-Tails_CPU_interact)  ; Clear active play variables
                clearRAM Camera_RAM,(Camera_RAM_end-Camera_RAM)  ; Clear play positional values
                jsr     (Init_SpriteTable).l            ; Initialize the sprite table
                clearRAM Normal_palette,(Stack_contents-Normal_palette)  ; Clear main palette
                move.b  #0,(Last_star_post_hit).w
                move.b  #0,(Special_bonus_entry_flag).w
                move.w  #0,(Debug_placement_mode).w
                move.w  #0,(Demo_mode_flag).w
                move.w  #0,(Palette_cycle_counter1).w
                move.w  #0,(Competition_mode).w         ; Clear Competition mode
                move.b  #0,(Level_started_flag).w
                move.b  #0,(Debug_mode_flag).w
                move.w  #0,(Competition_mode).w         ; Clear Competition mode again?
                move.w  #0,(Level_select_cheat_counter).w
                move.w  #0,(Debug_mode_cheat_counter).w
                move.w  #(6*60)-1,(Demo_timer).w        ; Wait on title screen for six seconds
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w   ; Clear DMA queue
                lea     (ArtKos_S3TitleSonic1).l,a0
                lea     (RAM_start).l,a1
                bsr.w   Kos_Decomp
                move.w  a1,d3
                lsr.w   #1,d3
                move.l  #RAM_start,d1
                move.w  #tiles_to_bytes($000),d2
                andi.l  #$FFFFFF,d1
                jsr     (Add_To_DMA_Queue).l            ; DMA Sega logo+Sonic art data 1 to $0 in VRAM
                lea     (RAM_start+$8000).w,a1
                lea     (MapEni_S3TitleSonic1).l,a0
                move.w  #make_art_tile($000,0,0),d0
                bsr.w   Eni_Decomp                      ; Decompress Enigma mappings
                lea     (RAM_start+$8000).w,a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l           ; Copy screen mappings to VRAM
                lea     (Pal_TitleSonic1).l,a0
                lea     (Target_palette).w,a1
                moveq   #bytesToLcnt(Target_palette_line_2-Target_palette),d0

loc_36AE:
                move.l  (a0)+,(a1)+                     ; Fill 2 palette lines with title screen data
                dbf     d0,loc_36AE
                move.w  #4*60,(Demo_timer).w
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l         ; Turn the display on
                bsr.w   Pal_FadeFromBlack               ; Fade in to logo
                moveq   #signextendB(cmd_SEGA),d0
                bsr.w   Play_Music
                move.w  #3*60,(Demo_timer).w            ; Set to wait for 3 seconds

Wait_Sega:
                move.b  #VInt_ID_14,(V_int_routine).w
                bsr.w   Wait_VSync                      ; Wait for SEGA sound
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                andi.b  #button_start_mask,d0
                bne.w   loc_36F8                        ; If start was pressed, skip ahead
                tst.w   (Demo_timer).w
                bne.s   Wait_Sega

loc_36F8:
                moveq   #signextendB(cmd_StopSEGA),d0
                bsr.w   Play_Music                      ; Stop SEGA sound
                lea     (Pal_Title).l,a1

loc_3704:
                move.b  #VInt_ID_2,(V_int_routine).w
                bsr.w   Wait_VSync
                lea     (Normal_palette).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                move.w  (a1)+,(a2)+
                tst.w   -$E(a1)                         ; Wait for BG color to turn to black
                bne.s   loc_3704
                clr.w   (_unkF660).w
                clr.w   (_unkF662).w
                move.b  #-1,(Title_anim_buffer).w
                move.b  #0,(Title_anim_delay).w
                move.w  #1,(Title_anim_frame).w         ; Set initial variables for Sonic animation page flipping
                moveq   #1,d0
                bsr.w   TitleSonic_LoadFrame
                move.w  #15*60,(Demo_timer).w           ; Set to wait 15 seconds (900 frames in NTSC)
                lea     (ArtKos_S3TitleSonic8).l,a1
                lea     (RAM_start).l,a2
                jsr     (Queue_Kos).l                   ; Queue frame 8 of data into a2 since frame 1 is already in VRAM
                moveq   #signextendB(mus_TitleScreen),d0
                bsr.w   Play_Music                      ; Start playing the title screen music

Wait_Title:
                move.b  #VInt_ID_4,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                bsr.w   Wait_VSync
                bsr.w   Iterate_TitleSonicFrame
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                bsr.w   Process_Nem_Queue_Init
                bsr.w   S3_Level_Select_Code
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                andi.b  #button_start_mask,d0
                bne.w   loc_379E                        ; If start was pressed, skip straight to title
                cmpi.w  #$C,(Title_anim_frame).w
                blo.s   Wait_Title                      ; If last frame was reached, don't repeat

loc_379E:
                move.w  #$C,(Title_anim_frame).w
                lea     (Normal_palette).w,a1
                moveq   #bytesToWcnt(Normal_palette_end-Normal_palette),d1

loc_37AA:
                move.w  #$EEE,(a1)+
                dbf     d1,loc_37AA                     ; Flash palette white
                move.b  #3,(Title_anim_delay).w
                move.b  #VInt_ID_4,(V_int_routine).w
                bsr.w   Wait_VSync
                lea     (ArtKos_S3TitleSonicD).l,a0
                lea     (RAM_start).l,a1
                bsr.w   Kos_Decomp
                move.w  a1,d3
                lsr.w   #1,d3
                move.l  #RAM_start,d1
                move.w  #tiles_to_bytes($000),d2
                andi.l  #$FFFFFF,d1
                jsr     (Add_To_DMA_Queue).l            ; Load Sonic art frame 14
                lea     (Level_layout_header).w,a1
                lea     (MapEni_S3TitleSonicD).l,a0
                move.w  #make_art_tile($000,0,1),d0
                bsr.w   Eni_Decomp
                lea     (Level_layout_header).w,a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l           ; Load Sonic mapping frame 14 to $C000 VRAM
                lea     (Level_layout_header).w,a1
                lea     (MapEni_S3TitleBg).l,a0
                move.w  #make_art_tile($000,2,0),d0
                bsr.w   Eni_Decomp
                lea     (Level_layout_header).w,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l           ; Load S3K Title BG to $E000 VRAM
                move.b  #VInt_ID_4,(V_int_routine).w
                bsr.w   Wait_VSync
                lea     (Pal_TitleSonicD).l,a0          ; Title palette
                lea     (Target_palette).w,a1
                moveq   #bytesToLcnt(Target_palette_end-Target_palette),d0

loc_384E:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_384E
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Title_Banner),VRAM,WRITE),(VDP_control_port).l  ; to VRAM $A000
                lea     (ArtNem_Title_S3Banner).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Title_Menu),VRAM,WRITE),(VDP_control_port).l  ; to VRAM $D000
                lea     (ArtNem_TitleScreenText).l,a0
                bsr.w   Nem_Decomp
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Title_Misc),VRAM,WRITE),(VDP_control_port).l  ; to VRAM $8000
                lea     (ArtNem_Title_SonicSprites).l,a0
                bsr.w   Nem_Decomp
                move.l  #Obj_TitleBanner,(Player_1).w
                move.l  #Obj_TitleSelection,(Player_2).w
                move.l  #Obj_TitleCopyright,(Dynamic_object_RAM).w
                move.l  #Obj_TitleSonicFinger,(Dynamic_object_RAM+object_size).w
                move.l  #Obj_TitleSonicWink,(Dynamic_object_RAM+(object_size*2)).w
                move.l  #Obj_TitleTailsPlane,(Dynamic_object_RAM+(object_size*3)).w  ; Load all applicable title objects
                moveq   #PLCID_00,d0
                bsr.w   Load_PLC_2
                if      0
; Sonic 2 Beta 4 reveals that these were the original instructions
; The original source code may have been able to produce debug builds with this enabled
                move.w  #$101,(Level_select_flag).w
                move.w  #$101,(Debug_mode_flag).w
                else
                nop
                nop
                nop
                nop
                nop
                nop
                endif
                move.b  #0,(Title_anim_delay).w

loc_38D8:
                move.b  #VInt_ID_4,(V_int_routine).w
                bsr.w   Wait_VSync
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                bsr.w   Process_Nem_Queue_Init
                tst.l   (Reserved_object_3).w
                beq.s   loc_38D8                        ; Don't do anything at all until banner has finished moving
                tst.w   (Demo_timer).w
                beq.w   loc_3978                        ; If the timer has run out, go do the level demos
                move.b  (Ctrl_1_pressed).w,d0
                andi.b  #button_start_mask,d0
                beq.w   loc_38D8                        ; Repeat until start has been pressed
                move.b  #GameMode_Level,(Game_mode).w
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
                bsr.w   Play_SFX                        ; Fade out the title screen music
                moveq   #0,d0
                move.b  (Title_screen_option).w,d0      ; Selection is stored here
                bne.w   loc_3964
                move.b  #GameMode_SaveScreen,(Game_mode).w  ; Game Mode 4C is the save select
                rts
; ---------------------------------------------------------------------------

loc_3964:
                subq.b  #1,d0
                bne.s   loc_3970
                move.b  #GameMode_CompetitionMenu,(Game_mode).w  ; Game Mode 38 is Competition mode
                rts
; ---------------------------------------------------------------------------

loc_3970:
                move.b  #GameMode_LevelSelect,(Game_mode).w  ; Game Mode 28 is the level select
                rts
; ---------------------------------------------------------------------------

loc_3978:
                moveq   #signextendB(cmd_FadeOut),d0
                bsr.w   Play_SFX                        ; Fade out music
                move.w  (Next_demo_number).w,d0         ; Get index of current demo to run
                andi.w  #7,d0
                add.w   d0,d0
                move.w  DemoLevels(pc,d0.w),d0
                move.w  d0,(Current_zone_and_act).w     ; Load level index to the appropriate variables
                move.w  d0,(Apparent_zone_and_act).w
                move.w  d0,(Saved_zone_and_act).w
                addq.w  #1,(Next_demo_number).w
                cmpi.w  #3,(Next_demo_number).w
                bcs.s   loc_39AA
                move.w  #0,(Next_demo_number).w

loc_39AA:
                move.w  #1,(Demo_mode_flag).w
                move.b  #GameMode_Demo,(Game_mode).w    ; We're about to perform a level demo
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
; ---------------------------------------------------------------------------
DemoLevels:
                dc.w    0                               ; Angel Island
                dc.w    $100                            ; Hydrocity
                dc.w    $200                            ; Marble Garden
; ---------------------------------------------------------------------------

TitleAnim_FlipBuffer:
                tst.b   (Title_anim_delay).w
                bne.s   loc_3A4E
                move.b  #4-1,(Title_anim_delay).w
                cmpi.w  #$C,(Title_anim_frame).w
                bhs.s   loc_3A54
                move.b  #4-1,(Title_anim_delay).w
                lea     (Target_palette).w,a0
                lea     (Normal_palette).w,a1
                moveq   #bytesToLcnt(Target_palette_line_3-Target_palette),d0

loc_3A18:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_3A18
                eori.b  #-1,(Title_anim_buffer).w
                tst.b   (Title_anim_buffer).w
                beq.s   loc_3A3C
                move.w  #$8406,(VDP_control_port).l     ; Nametable B Address $C000
                move.w  #$8230,(VDP_control_port).l     ; Nametable A Address $C000
                rts
; ---------------------------------------------------------------------------

loc_3A3C:
                move.w  #$8407,(VDP_control_port).l     ; Nametable B Address $E000
                move.w  #$8238,(VDP_control_port).l     ; Nametable A Address $E000
                rts
; ---------------------------------------------------------------------------

loc_3A4E:
                subq.b  #1,(Title_anim_delay).w
                rts
; ---------------------------------------------------------------------------

loc_3A54:
                lea     (Target_palette).w,a0
                lea     (Normal_palette).w,a1
                moveq   #bytesToLcnt(Target_palette_end-Target_palette),d0

loc_3A5E:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_3A5E
                move.w  #$8407,(VDP_control_port).l     ; Nametable B Address $E000
                move.w  #$8230,(VDP_control_port).l     ; Nametable A Address $C000
                rts

; =============== S U B R O U T I N E =======================================

Iterate_TitleSonicFrame:
                cmpi.b  #1,(Title_anim_delay).w
                bne.s   locret_3A92
                move.w  (Title_anim_frame).w,d0
                move.b  SonicFrameIndex(pc,d0.w),d0
                ext.w   d0
                bmi.s   loc_3A94                        ; if negative, do not load anymore frames
                bsr.w   TitleSonic_LoadFrame
                addq.w  #1,(Title_anim_frame).w

locret_3A92:
                rts
; ---------------------------------------------------------------------------

loc_3A94:
                move.w  #$C,(Title_anim_frame).w
                move.b  #3,(Title_anim_delay).w
                bra.w   locret_3AB0
; ---------------------------------------------------------------------------
SonicFrameIndex:
                dc.b    1,   2,   3,   4,   5,   6,   7,   8,   9,  $A,  $B, $FF
                even
; ---------------------------------------------------------------------------

locret_3AB0:
                rts
; ---------------------------------------------------------------------------
; unused
                move.b  (Title_anim_buffer).w,d2
                cmpi.b  #1,d2
                beq.s   locret_3B0A
                move.w  (V_scroll_amount).w,d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,(Camera_Y_pos).w
                move.w  (Camera_Y_pos).w,d0
                move.w  d0,(V_scroll_value).w
                move.b  #0,(Title_anim_buffer).w
                move.w  #$40,d1
                cmpi.w  #0,d0
                blt.s   loc_3AFC
                bne.s   loc_3AF2
                cmpi.w  #-$5B,(V_scroll_amount).w
                bne.s   loc_3AF2
                move.b  #1,(Title_anim_buffer).w
                bra.s   locret_3B0A
; ---------------------------------------------------------------------------

loc_3AF2:
                move.b  #-1,(Title_anim_buffer).w
                move.w  #-$40,d1

loc_3AFC:
                add.w   d1,(V_scroll_amount).w
                cmp.b   (Title_anim_buffer).w,d2
                beq.s   locret_3B0A
                asr     (V_scroll_amount).w

locret_3B0A:
                rts

; =============== S U B R O U T I N E =======================================

TitleSonic_LoadFrame:
                move.w  d0,d7
                add.w   d0,d0
                add.w   d0,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                lea     (TitleSonic_Frames).l,a2
                lea     (a2,d0.w),a2
                move.w  #$2C60,d3
                move.l  (a2)+,d0                        ; Art data
                cmpi.w  #7,d7
                beq.s   loc_3B46
                bcs.s   loc_3B66
                andi.l  #$FFFFFF,d0
                movea.l d0,a0
                lea     (RAM_start).l,a1
                bsr.w   Kos_Decomp
                move.w  a1,d3
                lsr.w   #1,d3

loc_3B46:
                move.l  #RAM_start,d1
                move.w  #0,d2
                tst.b   (Title_anim_buffer).w           ; FFFFBC toggles on and off so that each animation frame could alternate locations for a sort of makeshift double-buffering
                beq.s   loc_3B5A
                move.w  #tiles_to_bytes(ArtTile_Title_Buffer),d2

loc_3B5A:
                andi.l  #$FFFFFF,d1
                jsr     (Add_To_DMA_Queue).l

loc_3B66:
                movea.l (a2)+,a0                        ; Palette data address
                lea     (Target_palette).w,a1
                moveq   #bytesToLcnt(Target_palette_line_3-Target_palette),d0

loc_3B6E:
                move.l  (a0)+,(a1)+
                dbf     d0,loc_3B6E
                tst.b   (Title_anim_buffer).w
                bne.s   loc_3BA6
                lea     (RAM_start+$8000).w,a1          ; Buffer 1
                movea.l (a2)+,a0                        ; Enigma Mappings
                move.w  #make_art_tile($000,0,0),d0
                bsr.w   Eni_Decomp
                move    #$2700,sr
                lea     (RAM_start+$8000).w,a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0  ; to $C000 in VRAM, Nametable A
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l
                move    #$2300,sr
                rts
; ---------------------------------------------------------------------------

loc_3BA6:
                lea     (RAM_start+$8000).w,a1          ; Buffer 2
                movea.l (a2)+,a0                        ; Enigma Mappings
                move.w  #make_art_tile(ArtTile_Title_Buffer,0,0),d0
                cmpi.w  #7,d7
                bhs.s   loc_3BBA
                move.w  #make_art_tile($000,0,0),d0

loc_3BBA:
                bsr.w   Eni_Decomp
                move    #$2700,sr
                lea     (RAM_start+$8000).w,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0  ; to $E000 in VRAM Nametable B
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l
                move    #$2300,sr
                rts
; End of function TitleSonic_LoadFrame
