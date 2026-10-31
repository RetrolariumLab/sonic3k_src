; Owner: memory/shared
; Responsibility: Complete 68000 RAM allocation, aliases, interrupt trampolines and capacity guard
; Source provenance and ranges: config/reconstruction/source_layout.json

                padding off

; M68K RAM addresses

Map_2PTime_P1_RAM:              equ     ramaddr(   $FF7000 )  ; $34 bytes
Map_2PTime_P2_RAM:              equ     ramaddr(   $FF7080 )  ; $34 bytes
Sprite_table_alternate:         equ     ramaddr(   $FF7880 )  ; $280 bytes ; alternate sprite table for player 1 in competition mode
Sprite_table_alternate_end:     equ     Sprite_table_P2
Sprite_table_P2:                equ     ramaddr(   $FF7B00 )  ; $280 bytes ; sprite table for player 2 in competition mode
Sprite_table_P2_end:            equ     Sprite_table_P2_alternate
Sprite_table_P2_alternate:      equ     ramaddr(   $FF7D80 )  ; $280 bytes ; alternate sprite table for player 2 in competition mode
Sprite_table_P2_alternate_end:  equ     ramaddr(   $FF8000 )

                phase   $FFFF0000
RAM_start:      equ     *
Chunk_table:    ds.b    $8000                           ; chunk (128x128) definitions, $80 bytes per definition

Level_layout_header:                ds.b    8           ; first word = chunks per FG row, second word = chunks per BG row, third word = FG rows, fourth word = BG rows
Level_layout_main:                  ds.b    $FF8        ; $40 word-sized line pointers followed by actual layout data
Level_layout_main_end:              equ     *
Object_respawn_table_2:             set     Level_layout_header+$400  ; $200 bytes ; respawn table used by glowing spheres bonus stage, because... Reasons?
Ring_status_table_2:                set     Level_layout_header+$600  ; $400 bytes ; ring status table used by glowing spheres bonus stage, because... Reasons?
Ring_status_table_2_end:            set     Level_layout_header+$A00
Block_table:                        ds.b    $1800       ; block (16x16) definitions, 8 bytes per definition, space for $300 blocks
SStage_collision_response_list:     set     Block_table+$1400  ; $100 bytes ; sprite collision list during a special stage
SStage_blue_sphere_to_ring_queue:   set     Block_table+$1500  ; $100 bytes ; queue used by special stages to temporarily store the positions of blue spheres that have turned into rings
SStage_red_sphere_dfs_walk_stack:   set     Block_table+$1600  ; $100 bytes ; stack of (direction index bounds, direction index, position) used by special stages
        ; as part of the red sphere DFS walk to check for loops of red spheres
HScroll_table:          ds.b    $200                    ; array of background scroll positions for the level. WARNING: some references are before this label
_unkA880:               set     HScroll_table+$80       ; used in SSZ screen/background events
_unkA8E0:               set     HScroll_table+$E0       ; used in SSZ screen/background events
Nem_code_table:         ds.b    $200                    ; code table is built up here and then used during decompression
Sprite_table_input:     ds.b    $400                    ; 8 priority levels, $80 bytes per level
Sprite_table_input_end: equ     *

Object_RAM:             equ     *                       ; $1FCC bytes ; $4A bytes per object, 110 objects
Player_1:               ds.b    object_size             ; main character in 1 player mode, player 1 in Competition mode
Player_2:               ds.b    object_size             ; Tails in a Sonic and Tails game, player 2 in Competition mode
Reserved_object_3:      ds.b    object_size             ; during a level, an object whose sole purpose is to clear the collision response list is stored here
Dynamic_object_RAM:     ds.b    object_size*90          ; $1A04 bytes ; 90 objects
Dynamic_object_RAM_end: equ     *
Level_object_RAM:       equ     Dynamic_object_RAM_end  ; $4EA bytes ; various fixed in-level objects
                ds.b    object_size                     ; unknown
Breathing_bubbles:      ds.b    object_size             ; for the main character
Breathing_bubbles_P2:   ds.b    object_size             ; for Tails in a Sonic and Tails game
Super_stars:            equ     *                       ; for Super Sonic and Super Knuckles
Tails_tails_2P:         ds.b    object_size             ; Tails' tails in Competition mode
Tails_tails:            ds.b    object_size             ; Tails' tails
Dust:                   ds.b    object_size
Dust_P2:                ds.b    object_size
Shield:                 ds.b    object_size
Shield_P2:              ds.b    object_size             ; left over from Sonic 2 I'm guessing
Invincibility_stars:    ds.b    object_size*4
Invincibility_stars_P2: ds.b    object_size*3
Wave_Splash:            ds.b    object_size             ; Obj_HCZWaveSplash is loaded here
Object_RAM_end:         equ     *
                ds.b    $14                             ; unused
Conveyor_belt_load_array:   ds.b    $E                  ; each subtype of hcz conveyor belt uses a different byte to check if it's already loaded. Since they're so wide, the object loader may try loading them multiple times
                ds.b    $12                             ; unused

Kos_decomp_buffer:              ds.b    $1000           ; each module in a KosM archive is decompressed here and then DMAed to VRAM
H_scroll_buffer:                ds.b    $380            ; horizontal scroll table is built up here and then DMAed to VRAM
H_scroll_buffer_end:            equ     *
Collision_response_list:        ds.b    $80             ; only objects in this list are processed by the collision response routines
Collision_response_list_end:    equ     *
Stat_table:                     equ     *               ; used by Tails' AI in a Sonic and Tails game
Pos_table_P2:                   ds.b    $100            ; used by Player 2 in competition mode
Pos_table_P2_end:               equ     *
Pos_table:                      ds.b    $100            ;
Pos_table_end:                  equ     *
Competition_saved_data:         ds.b    $54             ; saved data from Competition Mode
Competition_saved_data_end:     equ     *
                ds.b    $C                              ; unused
Save_pointer:   set     *                               ; S3 uses a different address
                ds.l    1                               ; pointer to the active save slot in 1 player mode
                ds.w    1                               ; unused
Emerald_flicker_flag:   ds.w    1                       ; controls the emerald flicker in save screen and special stage results
                ds.b    $44                             ; unused
Saved_data:     set     *                               ; S3 uses a different address
                ds.b    $54                             ; saved data from 1 player mode
Ring_status_table:      ds.b    $400                    ; 1 word per ring
Ring_status_table_end:  equ     *
Object_respawn_table:   ds.b    $300                    ; 1 byte per object, every object in the level gets an entry

Camera_RAM:         equ     *                           ; various camera and scroll-related variables are stored here
H_scroll_amount:    ds.w    1                           ; number of pixels camera scrolled horizontally in the last frame * $100
V_scroll_amount:    ds.w    1                           ; number of pixels camera scrolled vertically in the last frame * $100
H_scroll_amount_P2: ds.w    1
V_scroll_amount_P2: ds.w    1
_unkEE08:           ds.b    1                           ; this is actually unused
                ds.b    1                               ; unused
Scroll_lock:                ds.b    1                   ; if this is set scrolling routines aren't called
Scroll_lock_P2:             ds.b    1
Camera_target_min_X_pos:    ds.w    1
Camera_target_max_X_pos:    ds.w    1
Camera_target_min_Y_pos:    ds.w    1
Camera_target_max_Y_pos:    ds.w    1
Camera_min_X_pos:           ds.w    1
Camera_max_X_pos:           ds.w    1
Camera_min_Y_pos:           ds.w    1
Camera_max_Y_pos:           ds.w    1                   ; this is the only one which ever differs from its target value
Camera_min_X_pos_P2:        ds.w    1
Camera_max_X_pos_P2:        ds.w    1
Camera_min_Y_pos_P2:        ds.w    1
Camera_max_Y_pos_P2:        ds.w    1
H_scroll_frame_offset:      ds.w    1                   ; if this is non-zero with value x, horizontal scrolling will be based on the player's position x / $100 + 1 frames ago
Pos_table_index:            ds.w    1                   ; goes up in increments of 4
H_scroll_frame_offset_P2:   ds.w    1
Pos_table_index_P2:         ds.w    1
Distance_from_top:          ds.w    1                   ; the vertical scroll manager scrolls the screen until the player's distance from the top of the screen is equal to this (or between this and this + $40 when in the air). $60 by default
Distance_from_top_P2:       ds.w    1
Deform_lock:                ds.b    1
                ds.b    1                               ; unused
Camera_max_Y_pos_changing:  ds.b    1                   ; set when the maximum camera Y pos is undergoing a change
Dynamic_resize_routine:     ds.b    1
                ds.b    5                               ; unused
Fast_V_scroll_flag:     ds.b    1                       ; if this is set vertical scroll when the player is on the ground and has a speed of less than $800 is capped at 24 pixels per frame instead of 6
V_scroll_value_P2_copy: ds.l    1                       ; upper word for foreground, lower word for background
Camera_X_diff:          ds.w    1                       ; difference between Camera_X_pos_copy and Camera_X_pos_BG_copy, used for background collision in SSZ and other levels
Camera_Y_diff:          ds.w    1                       ; difference between Camera_Y_pos_copy and Camera_Y_pos_BG_copy, used for background collision in SSZ and other levels
Ring_start_addr_ROM:    ds.l    1                       ; address in the ring layout of the first ring whose X position is >= camera X position - 8
Ring_end_addr_ROM:      ds.l    1                       ; address in the ring layout of the first ring whose X position is >= camera X position + 328
Ring_start_addr_RAM:    ds.w    1                       ; address in the ring status table of the first ring whose X position is >= camera X position - 8
                ds.w    1                               ; unused
Apparent_zone_and_act:                  equ     *
Apparent_zone:                          ds.b    1       ; always equal to actual zone
Apparent_act:                           ds.b    1       ; for example, after AIZ gets burnt, this indicates act 1 even though it's actually act 2
Palette_fade_timer:                     ds.w    1       ; the palette gets faded in until this timer expires
Competition_time_record:                ds.l    1       ; player 1's recorded time for the current run, to be displayed in menus and the result screen
Competition_time_record_minute:         equ     Competition_time_record+1
Competition_time_record_second:         equ     Competition_time_record+2
Competition_time_record_frame:          equ     Competition_time_record+3
Competition_time_record_P2:             ds.l    1       ; player 2's recorded time for the current run, to be displayed in menus and the result screen
Competition_time_record_minute_P2:      equ     Competition_time_record_P2+1
Competition_time_record_second_P2:      equ     Competition_time_record_P2+2
Competition_time_record_frame_P2:       equ     Competition_time_record_P2+3
Competition_time_attack_new_top_record: ds.b    1       ; signifies new time records in time attack mode. set: no new records, clear: 1st place, $1: 2nd place, $2: 3rd place record
                ds.b    1                               ; unused
Competition_lap_count:      ds.b    1                   ; number of laps that player 1 has completed
Competition_lap_count_2P:   ds.b    1                   ; number of laps that player 2 has completed
Act3_flag:                  ds.b    1                   ; set when entering LRZ 3 or DEZ 3 directly from previous act. Prevents title card from loading
                ds.b    1                               ; unused
Camera_X_pos_P2:        ds.l    1
Camera_Y_pos_P2:        ds.l    1
Camera_X_pos_P2_copy:   ds.w    1
                ds.w    1                               ; unused
Camera_Y_pos_P2_copy:   ds.w    1
                ds.w    1                               ; unused
Camera_X_pos_P2_BG_copy:    ds.w    1                   ; this is used in competition mode, and it acts as a copy of the x position for player 2's background
                ds.w    1                               ; unused
Camera_Y_pos_P2_BG_copy:    ds.w    1                   ; this is used in competition mode, and it acts as a copy of the y position for player 2's background
                ds.w    1                               ; unused
Camera_X_pos:           ds.l    1
Camera_Y_pos:           ds.l    1
Camera_X_pos_copy:      ds.l    1
Camera_Y_pos_copy:      ds.l    1
Camera_X_pos_rounded:   ds.w    1                       ; rounded down to the nearest block boundary ($10th pixel)
Camera_Y_pos_rounded:   ds.w    1                       ; rounded down to the nearest block boundary ($10th pixel)
Camera_X_pos_BG_copy:   ds.w    1
_unkEE8E:               ds.w    1                       ; various uses in screen/background events and competition mode

Camera_Y_pos_BG_copy:       ds.l    1
Camera_X_pos_BG_rounded:    ds.w    1                   ; rounded down to the nearest block boundary ($10th pixel)
Camera_Y_pos_BG_rounded:    ds.w    1                   ; rounded down to the nearest block boundary ($10th pixel)
_unkEE98:                   ds.l    1                   ; various uses in screen/background events and competition mode
_unkEE9C:                   ds.l    1                   ; various uses in screen/background events and competition mode
_unkEEA0:                   ds.w    1                   ; various uses in screen/background events and competition mode
_unkEEA2:                   ds.w    1                   ; various uses in screen/background events and competition mode
Plane_double_update_flag:   ds.w    1                   ; set when two block are to be updated instead of one (i.e. the camera's scrolled by more than $10 pixels)
Special_V_int_routine:      ds.w    1
Screen_X_wrap_value:        ds.w    1                   ; set to $FFFF
Screen_Y_wrap_value:        ds.w    1                   ; either $7FF or $FFF
Camera_Y_pos_mask:          ds.w    1                   ; either $7F0 or $FF0
Layout_row_index_mask:      ds.w    1                   ; either $3C or $7C

_unkEEB0:                   ds.w    1                   ; only ever set to $100 or $80, used in competition mode
Special_events_routine:     ds.w    1                   ; routine counter for various special events. Used for example with LBZ2 Death Egg sequence
Events_fg_0:                ds.w    1                   ; various flags used by screen events
Events_fg_1:                ds.w    1                   ; various flags used by screen events
Events_fg_2:                ds.w    1                   ; various flags used by screen events
_unkEEBA:                   ds.w    1                   ; only used in Sonic 3, and only used in the competition mode
Level_repeat_offset:        ds.w    1                   ; the number of pixels the screen was moved this frame, used to offset level objects horizontally. Used only for level repeat sections, such as AIZ airship
Events_fg_3:                ds.w    1                   ; various flags used by screen events
Events_routine_fg:          ds.w    1                   ; screen events routine counter
Events_routine_bg:          ds.w    1                   ; background events routine counter
Events_fg_4:                ds.w    1                   ; various flags used by screen events
Events_fg_5:                ds.w    1                   ; various flags used by screen events
Draw_delayed_position:      ds.w    1                   ; position to redraw screen from. Screen is reloaded 1 row at a time to avoid game lag
Draw_delayed_rowcount:      ds.w    1                   ; number of rows for screen redrawing. Screen is reloaded 1 row at a time to avoid game lag
Screen_shake_flag:          ds.w    1                   ; flag for enabling screen shake. Negative values cause screen to shake infinitely, positive values make the screen shake for a short amount of time
Screen_shake_offset:        ds.w    1                   ; vertical offset when screen_shake_flag is enabled. This is added to camera position later
Screen_shake_last_offset:   ds.w    1                   ; value of Screen_shake_offset for the previous frame

Events_bg:                  ds.b    $18                 ; $18 bytes ; various flags used by background events
SStage_results_object_addr: equ     Events_bg+$E        ; word ; RAM address of the special stage results object
FBZ_cloud_addr:             equ     *                   ; $14 bytes ; addresses for cloud objects in FBZ2
Vscroll_buffer:             equ     *                   ; $50 bytes ; vertical scroll buffer used in various levels
_unkEEEA:                   ds.w    1                   ; used in save screen to store VRAM addresses (4 word VRAM addresses), also used in SSZ screen events
                ds.w    1                               ; used in some instances (see above)
_unkEEEE:       ds.w    1                               ; used exclusively in SSZ background events code
                ds.w    1                               ; used in some instances (see above)
_unkEEF2:       ds.w    1                               ; used exclusively in SSZ background events code
_unkEEF4:       ds.w    1                               ; used exclusively in SSZ background events code
_unkEEF6:       ds.l    1                               ; used exclusively in SSZ background events code
_unkEEFA:       ds.w    1                               ; used exclusively in SSZ background events code
                ds.b    4
Camera_RAM_end: equ     *

                ds.b    $3A                             ; used in some instances (see above)

Spritemask_flag:    ds.w    1                           ; when set, indicates that special sprites are used for sprite masking

; These two variables implement page-flipping of the game's sprite tables in
; Competition Mode, to avoid incomplete sprite table data being uploaded to
; the VDP, which was a problem that Sonic 2 suffered from
Current_sprite_table_page:      ds.w    1
Sprite_table_page_flip_pending: ds.w    1

Event_LBZ2_DeathEgg:        equ     *                   ; if set, Launch Base 2 Death Egg is currently rising
_unkEF40_1:                 ds.l    1                   ; used as a part of calculating decimal scores
_unkEF44_1:                 equ     *                   ; used as a jump pointer in vint 1E, unknown why this is used
_unkEF44_2:                 ds.l    1                   ; used as a part of calculating decimal scores
Competition_menu_selection: ds.b    1                   ; 0 = Grandprix, 1 = Matchrace, 2 = Timeattack. 3 = Exit
Not_ghost_flag:             ds.b    1                   ; set if Player 2 in competition mode isn't a ghost of player 1
Competition_menu_zone:      ds.b    1                   ; competition mode zone id. This is different from the zone order in game
Dataselect_entry:           ds.b    1                   ; the selected save entry in data select menu. This includes no save and delete options, too
Dataselect_nosave_player:   ds.w    1                   ; Player mode for NO SAVE option in data select menu
Competition_menu_items:     ds.b    1                   ; 0 = Enabled, FF = Disabled
                ds.b    1                               ; unused
Demo_start_button:  ds.b    1                           ; keeps track of whether controller 1 has pressed the start button. May be used by the demo data itself
                ds.b    1                               ; unused
Demo_data_addr:             ds.l    1                   ; keeps getting incremented as the demo progresses
SRAM_mask_interrupts_flag:  ds.w    1                   ; if this is set SRAM routines will mask all interrupts (by setting the SR to $2700)
                ds.w    1                               ; unused
Object_index_addr:              ds.l    1               ; points to either the object index for S3 levels or that for S&K levels
Act3_ring_count:                ds.w    1               ; stores ring count during act 3 transition
Act3_timer:                     ds.l    1               ; stores timer during act 3 transition
Camera_Y_pos_coarse_back:       ds.w    1               ; Camera_Y_pos_coarse - $80
Glide_screen_shake:             ds.w    1               ; alternate screen shaking flag only used when hyper knuckles hits a wall after gliding
_unkEF68:                       ds.w    1               ; stores a tile used in special stage results screen, unknown purpose
Special_stage_zone_and_act:     ds.w    1               ; stored zone and act during special stage results screen?
HPZ_special_stage_completed:    ds.w    1               ; set if special stage was completed. This determines which cutscene to play when entering HPZS
Current_special_stage_2:        ds.b    1               ; seems to be just a copy of Current_special_stage
                ds.b    1                               ; unused
HPZ_current_special_stage:  ds.b    1                   ; seems to be just a copy of Current_special_stage used specifically for HPZS
                ds.b    1                               ; unused
Ending_running_flag:    ds.w    1                       ; the only thing this does is prevent the game from pausing
Plane_buffer_2_addr:    ds.l    1                       ; the address of the second plane buffer to process, if applicable
Demo_hold_counter:      ds.b    1                       ; the number of frames to hold the current buttons. This only applies to S&K demos
Demo_hold_buttons:      ds.b    1                       ; the buttons to hold. This only applies to S&K demos
Demo_number:            ds.w    1                       ; the currently running demo
                ds.l    1                               ; unused

Ring_consumption_table:     equ     *                   ; $80 bytes ; stores the addresses of all rings currently being consumed
Ring_consumption_count:     ds.w    1                   ; the number of rings being consumed currently
Ring_consumption_list:      ds.w    $3F                 ; the remaining part of the ring consumption table
Ring_consumption_table_end: equ     *

SStage_layout_buffer:       equ     *                   ; $600 bytes ; yes, this area is used to for special stage layouts!
Target_water_palette:       ds.b    $80                 ; used by palette fading routines
Target_water_palette_end:   equ     *
Water_palette:              ds.b    $80                 ; this is what actually gets displayed
Water_palette_line_2:       equ     Water_palette+$20   ; $20 bytes
Water_palette_line_3:       equ     Water_palette+$40   ; $20 bytes
Water_palette_line_4:       equ     Water_palette+$60   ; $20 bytes
Water_palette_end:          equ     *
Plane_buffer:               ds.b    $480                ; used by level drawing routines
VRAM_buffer:                ds.b    $80                 ; used to temporarily hold data while it is being transferred from one VRAM location to another

Game_mode:      ds.b    1
                ds.b    1                               ; unused
Ctrl_1_logical:         equ     *                       ; both held and pressed
Ctrl_1_held_logical:    ds.b    1
Ctrl_1_pressed_logical: ds.b    1
Ctrl_1:                 equ     *                       ; both held and pressed
Ctrl_1_held:            ds.b    1                       ; all held buttons
Ctrl_1_pressed:         ds.b    1                       ; buttons being pressed newly this frame
Ctrl_2:                 equ     *                       ; both held and pressed
Ctrl_2_held:            ds.b    1
Ctrl_2_pressed:         ds.b    1
_tempF608:              ds.b    6                       ; this is used in Sonic 3 Alone, but unused in Sonic & Knuckles and Sonic 3 Complete

VDP_reg_1_command:  ds.w    1                           ; AND the lower byte by $BF and write to VDP control port to disable display, OR by $40 to enable
                ds.l    1                               ; unused
Demo_timer:             ds.w    1                       ; the time left for a demo to start/run
V_scroll_value:         equ     *                       ; both foreground and background
V_scroll_value_FG:      ds.w    1
V_scroll_value_BG:      ds.w    1
_unkF61A:               ds.l    1                       ; unused
V_scroll_value_P2:      equ     *
V_scroll_value_FG_P2:   ds.w    1
V_scroll_value_BG_P2:   ds.w    1
Teleport_active_timer:  ds.b    1                       ; left over from Sonic 2
Teleport_active_flag:   ds.b    1                       ; left over from Sonic 2
H_int_counter_command:  ds.w    1                       ; contains a command to write to VDP register $0A (line interrupt counter)
H_int_counter:          equ     H_int_counter_command+1  ; just the counter part of the command
Palette_fade_info:      equ     *                       ; both index and count
Palette_fade_index:     ds.b    1                       ; colour to start fading from
Palette_fade_count:     ds.b    1                       ; the number of colours to fade
Lag_frame_count:        ds.w    1                       ; more specifically, the number of times V-int routine 0 has run. Reset at the end of a normal frame
V_int_routine:          ds.b    1
                ds.b    1                               ; unused
Sprites_drawn:  ds.b    1                               ; used to ensure the sprite limit isn't exceeded
                ds.b    1                               ; unused
Water_palette_data_addr:    ds.l    1                   ; points to the water palette data for the current level
Palette_cycle_counter0:     ds.w    1                   ; various counters and variables for palette cycles
Palette_cycle_counter1:     ds.w    1                   ; various counters and variables for palette cycles
RNG_seed:                   ds.l    1                   ; used by the random number generator
Game_paused:                ds.w    1
                ds.l    1                               ; unused
DMA_trigger_word:   ds.w    1                           ; transferred from RAM to avoid crashing the Mega Drive
                ds.w    1                               ; unused
H_int_flag:     ds.w    1                               ; unless this is set H-int will return immediately

Water_level:                ds.w    1                   ; keeps fluctuating
Mean_water_level:           ds.w    1                   ; the steady central value of the water level
Target_water_level:         ds.w    1
Water_speed:                ds.b    1                   ; this is added to or subtracted from Mean_water_level every frame till it reaches Target_water_level
Water_entered_counter:      ds.b    1                   ; incremented when entering and exiting water, read by the the floating AIZ spike log, cleared on level initialisation and dynamic events of certain levels
Water_full_screen_flag:     ds.b    1                   ; set if water covers the entire screen (i.e. the underwater palette should be DMAed during V-int rather than the normal palette)
Do_Updates_in_H_int:        ds.b    1                   ; if this is set Do_Updates will be called from H-int instead of V-int
Palette_cycle_counters:     ds.b    $C                  ; various counters and variables for palette cycles
Palette_frame:              ds.w    1
Palette_timer:              ds.b    1
Super_palette_status:       ds.b    1                   ; appears to be a flag for the palette's current status: '0' for 'off', '1' for 'fading', -1 for 'fading done'
_unkF660:                   ds.w    1                   ; unused in Sonic 3 Alone, used for Credits in Sonic & Knuckles
_unkF662:                   ds.w    1                   ; unused
Background_collision_flag:  ds.b    1                   ; if set, background collision is enabled
Disable_death_plane:        ds.b    1                   ; if set, going below the screen wont kill the player
Hyper_Sonic_flash_timer:    ds.b    1                   ; used for Hyper Sonic's double jump move
Super_Tails_flag:           ds.b    1
Palette_frame_Tails:        ds.b    1                   ; Tails would use Palette_frame and Palette_timer, but they're reserved for his Super Flickies
Palette_timer_Tails:        ds.b    1
Ctrl_2_logical:             equ     *                   ; both held and pressed
Ctrl_2_held_logical:        ds.b    1
Ctrl_2_pressed_logical:     ds.b    1
_unkF66C:                   ds.b    1
                ds.b    3                               ; unused
Super_frame_count:  ds.w    1
                ds.l    1                               ; unused
Scroll_force_positions: ds.b    1                       ; if this is set scrolling will be based on the two variables below rather than the player's actual position
                ds.b    1                               ; unused
Scroll_forced_X_pos:    ds.w    1
                ds.w    1                               ; unused
Scroll_forced_Y_pos:    ds.w    1                       ; note: must be exactly 4 bytes after Scroll_forced_X_pos
                ds.w    1                               ; unused

Nem_decomp_queue:           ds.b    6*$10               ; 6 bytes per entry, first longword is source location and next word is VRAM destination
Nem_decomp_queue_End:
Nem_decomp_source:          equ     Nem_decomp_queue    ; long ; the compressed data location for the first entry in the queue
Nem_decomp_destination:     equ     Nem_decomp_queue+4  ; word ; destination in VRAM for the first entry in the queue
Nem_decomp_vars:            equ     *                   ; $20 bytes ; various variables used by the Nemesis decompression queue processor
Nem_write_routine:          ds.l    1                   ; points to either Nem_PCD_WriteRowToVDP or Nem_PCD_WriteRowToVDP_XOR
Nem_repeat_count:           ds.l    1                   ; stored repeat count for the current palette index
Nem_palette_index:          ds.l    1                   ; the current palette index
Nem_previous_row:           ds.l    1                   ; used in XOR mode
Nem_data_word:              ds.l    1                   ; contains the current compressed word being processed
Nem_shift_value:            ds.l    1                   ; the number of bits the data word needs to be shifted by
Nem_patterns_left:          ds.w    1                   ; the number of patterns remaining to be decompressed
Nem_frame_patterns_left:    ds.w    1                   ; the number of patterns remaining to be decompressed in the current frame
                ds.l    1                               ; unused?

Tails_CPU_interact:     ds.w    1                       ; RAM address of the last object Tails stood on while controlled by AI
Tails_CPU_idle_timer:   ds.w    1                       ; counts down while controller 2 is idle, when it reaches 0 the AI takes over
Tails_CPU_flight_timer: ds.w    1                       ; counts up while Tails is respawning, when it reaches 300 he drops into the level
                ds.w    1                               ; unused
Tails_CPU_routine:          ds.w    1                   ; Tails' current AI routine in a Sonic and Tails game
Tails_CPU_target_X:         ds.w    1                   ; Tails' target x-position
Tails_CPU_target_Y:         ds.w    1                   ; Tails' target y-position
Tails_CPU_auto_fly_timer:   ds.b    1                   ; counts up until AI Tails automatically flies up to maintain altitude, while grabbing Sonic in Marble Garden Act 2's boss
Tails_CPU_auto_jump_flag:   ds.b    1                   ; set to #1 when AI Tails needs to jump of his own accord, regardless of whether Sonic jumped or not
Rings_manager_routine:      ds.b    1
Level_started_flag:         ds.b    1
_unkF712:                   ds.b    $1C                 ; Gumball Machine and HPZ Emerald throne room object respawn table
AIZ1_palette_cycle_flag:    ds.b    1                   ; selects which palette cycles are used in AIZ1
                ds.b    1                               ; unused
Water_flag:     ds.b    1
                ds.b    $D                              ; unused
Flying_carrying_Sonic_flag: ds.b    1                   ; set when Tails carries Sonic in a Sonic and Tails game
Flying_picking_Sonic_timer: ds.b    1                   ; until this is 0 Tails can't pick Sonic up
_unkF740:                   ds.w    1
                ds.w    1                               ; unused
_unkF744:                   ds.w    1
Tails_CPU_star_post_flag:   ds.b    1                   ; copy of Last_star_post_hit, sets Tails' starting behavior in a Sonic and Tails game
                ds.b    1                               ; unused
Ctrl_1_title:                   equ     *               ; copy of Ctrl_1, used on the title screen
Ctrl_1_held_title:              ds.b    1
Ctrl_1_pressed_title:           ds.b    1
Competition_lap_count_flag:     ds.b    1               ; flag to enable/disable lap counting in competition mode for player 1, 0 for enabled, 1 for disabled
Competition_lap_count_flag_P2:  ds.b    1               ; flag to enable/disable lap counting in competition mode for player 2, 0 for enabled, 1 for disabled
_unkF74C:                       ds.w    1
Gliding_collision_flags:        ds.b    1
Disable_wall_grab:              ds.b    1               ; if set, disables Knuckles wall grab
                ds.b    $10                             ; unused
Max_speed:          ds.w    1
Acceleration:       ds.w    1
Deceleration:       ds.w    1
Player_prev_frame:  ds.b    1                           ; used by DPLC routines to detect whether a DMA transfer is required
                ds.b    1                               ; unused
Primary_Angle:          ds.b    1
Primary_Angle_save:     ds.b    1                       ; Used in FindFloor/FindWall
Secondary_Angle:        ds.b    1
Secondary_Angle_save:   ds.b    1                       ; Used in FindFloor/FindWall

Object_load_routine:    ds.b    1                       ; routine counter for the object loading manager
                ds.b    1                               ; unused
Camera_X_pos_coarse:        ds.w    1                   ; rounded down to the nearest chunk boundary (128th pixel)
Camera_Y_pos_coarse:        ds.w    1                   ; rounded down to the nearest chunk boundary (128th pixel)
Object_load_addr_front:     ds.l    1                   ; the address inside the object placement data of the first object whose X pos is >= Camera_X_pos_coarse + $280
Object_load_addr_back:      ds.l    1                   ; the address inside the object placement data of the first object whose X pos is >= Camera_X_pos_coarse - $80
Object_respawn_index_front: ds.w    1                   ; the object respawn table index for the object at Obj_load_addr_front
Object_respawn_index_back:  ds.w    1                   ; the object respawn table index for the object at Obj_load_addr_back
                ds.b    $16                             ; unused
Pal_fade_delay: ds.w    1                               ; timer for palette fade routines
Collision_addr: ds.l    1                               ; points to the primary or secondary collision data as appropriate
                ds.b    $10                             ; unused
Boss_flag:      ds.b    1                               ; set if a boss fight is going on
                ds.b    5                               ; unused
_unkF7B0:       ds.b    4

Primary_collision_addr:     ds.l    1
Secondary_collision_addr:   ds.l    1
                ds.l    1                               ; unused
MHZ_pollen_counter:     ds.b    1                       ; number of currently active pollen or leaves in MHZ
_unkF7C1:               ds.b    1
_unkF7C2:               ds.b    1
SOZ_darkness_level:     ds.b    1
_unkF7C4:               ds.w    1
Reverse_gravity_flag:   ds.b    1
_unkF7C7:               ds.b    1
WindTunnel_flag:        ds.b    1
WindTunnel_flag_P2:     ds.b    1
Ctrl_1_locked:          ds.b    1
Ctrl_2_locked:          ds.b    1
                ds.l    1                               ; unused
Chain_bonus_counter:    ds.w    1
Time_bonus_countdown:   ds.w    1                       ; used on the results screen
Ring_bonus_countdown:   ds.w    1                       ; used on the results screen
                ds.l    1                               ; unused
Camera_X_pos_coarse_back:   ds.w    1                   ; Camera_X_pos_coarse - $80
_unkF7DC:                   ds.w    1
Player_prev_frame_P2:       ds.b    1                   ; used by DPLC routines to detect whether a DMA transfer is required
Player_prev_frame_P2_tail:  ds.b    1                   ; used by DPLC routines to detect whether a DMA transfer is required
Level_trigger_array:        ds.b    $10                 ; used by buttons, etc
Anim_Counters:              ds.b    $10                 ; each word stores data on animated level art, including duration and current frame

Sprite_table:               ds.b    $280
Sprite_table_end:           equ     *
_unkFA80:                   ds.w    1                   ; unused
_unkFA82:                   ds.b    1
_unkFA83:                   ds.b    1
_unkFA84:                   ds.w    1
_unkFA86:                   ds.w    1
_unkFA88:                   ds.b    1
_unkFA89:                   ds.b    1
_unkFA8A:                   ds.w    1
_unkFA8C:                   ds.w    1                   ; unused?
_unkFA8E:                   ds.w    1
_unkFA90:                   ds.w    1
Camera_stored_max_X_pos:    ds.w    1                   ; the target camera maximum x-position
Camera_stored_min_X_pos:    ds.w    1                   ; the target camera minimum x-position
Camera_stored_min_Y_pos:    ds.w    1                   ; the target camera minimum y-position
Camera_stored_max_Y_pos:    ds.w    1                   ; the target camera maximum y-position
Slotted_object_bits:        ds.w    1                   ; bits to determine which slots are used for slotted objects
                ds.b    6                               ; unused
_unkFAA2:                   ds.b    1
_unkFAA3:                   ds.b    1
_unkFAA4:                   ds.w    1
Signpost_addr:              ds.w    1                   ; address of the currently active signpost object. Hidden monitors use this for bouncing
_unkFAA8:                   ds.b    1
_unkFAA9:                   ds.b    1
End_of_level_flag:          ds.b    1                   ; set if end of level is current active, for example after beating a boss
_unkFAAB:                   ds.b    1
_unkFAAC:                   ds.b    1
Hyudoro_count:              ds.b    1
_unkFAAE:                   ds.w    1
_unkFAB0:                   ds.w    1
_unkFAB2:                   ds.w    1
_unkFAB4:                   ds.w    1
_unkFAB6:                   ds.w    1
_unkFAB8:                   ds.b    1
_unkFAB9:                   ds.b    1
_unkFABA:                   ds.w    1
_unkFABC:                   ds.b    1
_unkFABD:                   ds.b    1
_unkFABE:                   ds.b    1                   ; unused?
Palette_rotation_disable:   ds.b    1                   ; if set, palette rotation scripts are disabled
_unkFAC0:                   ds.b    1
_unkFAC1:                   ds.b    1
_unkFAC2:                   ds.w    1
_unkFAC4:                   ds.w    1
                ds.w    1                               ; unused
_unkFAC8:       ds.w    1
                ds.w    1                               ; unused
_unkFACC:           ds.b    1
_unkFACD:           ds.b    1
Pal_fade_delay2:    ds.w    1                           ; timer for palette fade from white routine
                ds.b    $A                              ; unused
Palette_rotation_custom:    ds.l    1                   ; custom routine for palette rotation scripts
Palette_rotation_data:      ds.w    9                   ; data used by palette rotation scripts. Last word must always be 0
SSZ_MTZ_boss_X_pos:         ds.w    1                   ; horizontal position of the Metropolis Zone boss in Sky Sanctuary
                ds.w    1                               ; unused
SSZ_MTZ_boss_Y_pos: ds.w    1                           ; vertical position of the Metropolis Zone boss in Sky Sanctuary
                ds.w    1                               ; unused
SSZ_MTZ_boss_X_vel:         ds.w    1                   ; horizontal velocity of the Metropolis Zone boss in Sky Sanctuary
SSZ_MTZ_boss_Y_vel:         ds.w    1                   ; vertical velocity of the Metropolis Zone boss in Sky Sanctuary
SSZ_MTZ_boss_laser_timer:   ds.w    1                   ; counts down until a laser is fired in Sky Sanctuary's Metropolis boss fight
                ds.w    1                               ; unused

DMA_queue:      ds.w    $12*7                           ; stores all the VDP commands necessary to initiate a DMA transfer
DMA_queue_slot: ds.l    1                               ; points to the next free slot on the queue

Normal_palette:         ds.b    $80
Normal_palette_line_2:  equ     Normal_palette+$20      ; $20 bytes
Normal_palette_line_3:  equ     Normal_palette+$40      ; $20 bytes
Normal_palette_line_4:  equ     Normal_palette+$60      ; $20 bytes
Normal_palette_end:     equ     *
Target_palette:         ds.b    $80                     ; used by palette fading routines
Target_palette_line_2:  equ     Target_palette+$20      ; $20 bytes
Target_palette_line_3:  equ     Target_palette+$40      ; $20 bytes
Target_palette_line_4:  equ     Target_palette+$60      ; $20 bytes
Target_palette_end:     equ     *
Stack_contents:         ds.b    $100                    ; stack contents
System_stack:           equ     *                       ; this is the top of the stack, it grows downwards

CrossResetRAM:                                          ; RAM in this region will not be cleared after a soft reset

                ds.w    1                               ; unused
Restart_level_flag:     ds.w    1
Level_frame_counter:    ds.w    1                       ; the number of frames which have elapsed since the level started
Debug_object:           ds.b    1                       ; the current position in the debug mode object list
                ds.b    1                               ; unused
Debug_placement_mode:       equ     *                   ; both routine and type
Debug_placement_routine:    ds.b    1
Debug_placement_type:       ds.b    1                   ; 0 = normal gameplay, 1 = normal object placement, 2 = frame cycling
Debug_camera_delay:         ds.b    1
Debug_camera_speed:         ds.b    1
V_int_run_count:            ds.l    1                   ; the number of times V-int has run
Current_zone_and_act:       equ     *
Current_zone:               ds.b    1
Current_act:                ds.b    1
Life_count:                 ds.b    1
                ds.b    3                               ; unused
Current_special_stage:  ds.b    1
                ds.b    1                               ; unused
Continue_count:         ds.b    1
Super_Sonic_Knux_flag:  ds.b    1
Time_over_flag:         ds.b    1
Extra_life_flags:       ds.b    1
Update_HUD_life_count:  ds.b    1
Update_HUD_ring_count:  ds.b    1
Update_HUD_timer:       ds.b    1
Update_HUD_score:       ds.b    1
Ring_count:             ds.w    1
Timer:                  ds.l    1
Timer_minute:           equ     Timer+1
Timer_second:           equ     Timer+2
Timer_frame:            equ     Timer+3                 ; the second gets incremented when this reaches 60
Score:                  ds.l    1
Last_star_post_hit:     ds.b    1

; the following variables are all saved when hitting a star post
Saved_last_star_post_hit:       ds.b    1
Saved_zone_and_act:             ds.w    1
Saved_X_pos:                    ds.w    1
Saved_Y_pos:                    ds.w    1
Saved_ring_count:               ds.w    1
Saved_timer:                    ds.l    1
Saved_art_tile:                 ds.w    1
Saved_solid_bits:               ds.w    1               ; copy of Player 1's top_solid_bit and lrb_solid_bit
Saved_camera_X_pos:             ds.w    1
Saved_camera_Y_pos:             ds.w    1
Saved_mean_water_level:         ds.w    1
Saved_water_full_screen_flag:   ds.b    1
Saved_extra_life_flags:         ds.b    1
Saved_camera_max_Y_pos:         ds.w    1
Saved_dynamic_resize_routine:   ds.b    1
Saved_status_secondary:         ds.b    1
Special_bonus_entry_flag:       ds.b    1               ; 1 for entering a Special Stage, 2 for entering a Bonus Stage

; the following variables are all saved when entering a special stage
Saved2_last_star_post_hit:      ds.b    1
Saved2_zone_and_act:            ds.w    1
Saved2_X_pos:                   ds.w    1
Saved2_Y_pos:                   ds.w    1
Saved2_ring_count:              ds.w    1
Saved2_timer:                   ds.l    1
Saved2_art_tile:                ds.w    1
Saved2_solid_bits:              ds.w    1
Saved2_camera_X_pos:            ds.w    1
Saved2_camera_Y_pos:            ds.w    1
Saved2_mean_water_level:        ds.w    1
Saved2_water_full_screen_flag:  ds.b    1
Saved2_extra_life_flags:        ds.b    1
Saved2_camera_max_Y_pos:        ds.w    1
Saved2_dynamic_resize_routine:  ds.b    1

LRZ_rocks_routine:                      ds.b    1       ; routine counter for lrz special rocks
LRZ_rocks_addr_front:                   ds.l    1       ; the address inside the lrz rocks data of the first rock whose X pos is >= Camera_X_pos_coarse + $280
LRZ_rocks_addr_back:                    ds.l    1       ; the address inside the lrz rocks data of the first rock whose X pos is >= Camera_X_pos_coarse - $80
Oscillating_table:                      ds.b    $42     ; various oscillating variables
Oscillating_table_end:                  equ     *       ; end of oscillating data array
Slot_machine_goal_frame_timer:          ds.b    1
Slot_machine_goal_frame:                ds.b    1
Rings_frame_timer:                      ds.b    1
Rings_frame:                            ds.b    1
Slot_machine_peppermint_frame_timer:    ds.b    1
Slot_machine_peppermint_frame:          ds.b    1
Ring_spill_anim_counter:                ds.b    1
Ring_spill_anim_frame:                  ds.b    1
Ring_spill_anim_accum:                  ds.w    1
AIZ_vine_angle:                         ds.w    1       ; controls the angle of AIZ giant vines
                ds.w    1                               ; unused
_unkFEBE:               ds.b    1                       ; unused
Extra_life_flags_P2:    ds.b    1
Max_speed_P2:           ds.w    1
Acceleration_P2:        ds.w    1
Deceleration_P2:        ds.w    1
Life_count_P2:          ds.b    1                       ; left over from Sonic 2
Update_HUD_timer_P2:    ds.b    1                       ; used in competition mode
Total_ring_count:       ds.w    1                       ; left over from Sonic 2
Total_ring_count_P2:    ds.w    1                       ; left over from Sonic 2
Monitors_broken:        ds.w    1                       ; left over from Sonic 2. Apparently Sonic 3 developers liked copypasting, since gaining a life from rings also increments this counter
Monitors_broken_P2:     ds.w    1                       ; left over from Sonic 2
Ring_count_P2:          ds.w    1                       ; left over from Sonic 2
Timer_P2:               ds.l    1                       ; used in competition mode
Timer_minute_P2:        equ     Timer_P2+1
Timer_second_P2:        equ     Timer_P2+2
Timer_frame_P2:         equ     Timer_P2+3              ; the second gets incremented when this reaches 60
Score_P2:               ds.l    1                       ; left over from Sonic 2
Competition_total_laps: ds.b    1                       ; total number of laps in competition mode (typically 5)
                ds.b    1                               ; unused
Competition_current_lap:    ds.b    1                   ; current lap number for player 1 in competition mode
Competition_current_lap_2P: ds.b    1                   ; current lap number for player 2 in competition mode
Loser_time_left:            ds.b    1                   ; left over from Sonic 2
                ds.b    $23                             ; unused
Results_screen_2P:  ds.w    1                           ; left over from Sonic 2
Perfect_rings_left: ds.w    1                           ; left over from Sonic 2
Perfect_rings_flag: ds.w    1                           ; unknown
Player_mode:        ds.w    1                           ; 0 = Sonic and Tails, 1 = Sonic alone, 2 = Tails alone, 3 = Knuckles alone
Player_option:      ds.w    1                           ; option selected on level select, data select screen or Sonic & Knuckles title screen
Two_player_items:   ds.w    1                           ; left over from Sonic 2

Kos_decomp_queue_count:         ds.w    1               ; the number of pieces of data on the queue. Sign bit set indicates a decompression is in progress
Kos_decomp_stored_registers:    ds.w    20              ; allows decompression to be spread over multiple frames
Kos_decomp_stored_SR:           ds.w    1
Kos_decomp_bookmark:            ds.l    1               ; the address within the Kosinski queue processor at which processing is to be resumed
Kos_description_field:          ds.w    1               ; used by the Kosinski queue processor the same way the stack is used by the normal Kosinski decompression routine
Kos_decomp_queue:               ds.l    2*4             ; 2 longwords per entry, first is source location and second is decompression location
Kos_decomp_source:              equ     Kos_decomp_queue  ; long ; the compressed data location for the first entry in the queue
Kos_decomp_destination:         equ     Kos_decomp_queue+4  ; long ; the decompression location for the first entry in the queue
Kos_modules_left:               ds.b    1               ; the number of modules left to decompresses. Sign bit set indicates a module is being decompressed/has been decompressed
                ds.b    1                               ; unused
Kos_last_module_size:   ds.w    1                       ; the uncompressed size of the last module in words. All other modules are $800 words
Kos_module_queue:       ds.w    3*4                     ; 6 bytes per entry, first longword is source location and next word is VRAM destination
Kos_module_source:      equ     Kos_module_queue        ; long ; the compressed data location for the first module in the queue
Kos_module_destination: equ     Kos_module_queue+4      ; word ; the VRAM destination for the first module in the queue

Kos_decomp_module_end:  equ     *

_unkFF7C:               ds.w    1
_unkFF7E:               ds.w    1
Level_select_repeat:    ds.w    1                       ; delay counter for repeating the button press. Allows the menu move even when up/down is held down
Level_select_option:    ds.w    1                       ; the current selected option in the level select
Sound_test_sound:       ds.w    1
Title_screen_option:    ds.b    1
                ds.b    1                               ; unused
_tempFF88:              ds.w    1                       ; this is used in Sonic 3 Alone, but unused in Sonic & Knuckles and Sonic 3 Complete
Competition_settings:   equ     *                       ; both items and game type
Competition_items:      ds.b    1                       ; 0 = Enabled, FF = Disabled
Competition_type:       ds.b    1                       ; 0 = grand prix, 3 = match race, -1 = time attack
_tempFF8C:              ds.b    1                       ; this is used in Sonic 3 Alone, but unused in Sonic & Knuckles and Sonic 3 Complete
                ds.b    1                               ; unused
Total_bonus_countup:            ds.w    1               ; the total points to be added due to various bonuses this frame in the end of level results screen
Current_music:                  ds.w    1
Collected_special_ring_array:   ds.l    1               ; each bit indicates a special stage entry ring in the current zone
Saved2_status_secondary:        ds.b    1
Respawn_table_keep:             ds.b    1               ; if set, respawn table is not reset during level load
_tempFF98:                      ds.w    1               ; this is used in Sonic 3 Alone, but unused in Sonic & Knuckles and Sonic 3 Complete
Saved_apparent_zone_and_act:    ds.w    1
Saved2_apparent_zone_and_act:   ds.w    1
                ds.b    1                               ; unused

Blue_spheres_header_flag:       ds.b    1               ; 0 = SEGA GENESIS, 1 = SEGA MEGA DRIVE
Blue_spheres_mode:              ds.b    1               ; 0 = single stage, 1 = full game
Blue_spheres_menu_flag:         ds.b    1               ; 0 = NO WAY!, 1 = normal, bit 7 set = entering a code
Blue_spheres_current_stage:     ds.b    4               ; the layout parts that make up the current stage
Blue_spheres_current_level:     ds.l    1               ; number shown at the top of the full game menu
Blue_spheres_option:            ds.b    1               ; 0 = level, 1 = start, 2 = code
Blue_spheres_progress_flag:     ds.b    1               ; 0 = normal, -1 = disabled (single stage mode or using a code from single stage mode)
Blue_spheres_difficulty:        ds.b    1               ; value currently displayed
Blue_spheres_target_difficulty: ds.b    1               ; value read from the layout
SK_alone_flag:                  ds.w    1               ; -1 if Sonic 3 isn't locked on
Emerald_counts:                 equ     *               ; both Chaos and Super emeralds
Chaos_emerald_count:            ds.b    1
Super_emerald_count:            ds.b    1
Collected_emeralds_array:       ds.b    7               ; 1 byte per emerald, 0 = not collected, 1 = Chaos Emerald collected, 2 = grey Super Emerald, 3 = Super Emerald collected
                ds.b    1                               ; unused

Emeralds_converted_flag:    ds.b    1                   ; set if at least one emerald has been converted to a Super Emerald
SK_special_stage_flag:      ds.b    1                   ; set if a Sonic & Knuckles special stage is being run
Title_anim_buffer:          ds.b    1                   ; status of the title animation buffer. Changes 2 different nametables in VDP while the other is being processed
Title_anim_delay:           ds.b    1                   ; title animation delay counter
Title_anim_frame:           ds.b    1                   ; title animation frame number
                ds.b    1                               ; unused
Next_extra_life_score:      ds.l    1
Next_extra_life_score_P2:   ds.l    1                   ; left over from Sonic 2
                ds.w    1                               ; unused
Debug_saved_mappings:   ds.l    1                       ; player 1 mappings before entering debug mode
Debug_saved_art_tile:   ds.w    1                       ; player 1 art_tile before entering debug mode
Demo_mode_flag:         set     *                       ; S3 uses a different address
                ds.w    1
Next_demo_number:   set     *                           ; S3 uses a different address
                ds.w    1
Blue_spheres_stage_flag:    set     *                   ; S3 uses a different address
                ds.b    1                               ; set if a Blue Sphere special stage is being run
                ds.b    1                               ; unused
V_blank_cycles: set     *                               ; S3 uses a different address
                ds.w    1                               ; the number of cycles between V-blanks
Graphics_flags: set     *                               ; S3 uses a different address
                ds.b    1                               ; bit 7 set = English system, bit 6 set = PAL system
                ds.b    1                               ; unused
Debug_mode_flag:    set     *                           ; S3 uses a different address
                ds.w    1
                ds.l    1                               ; unused
Level_select_flag:  set     *                           ; S3 uses a different address
                ds.b    1
Slow_motion_flag:   set     *                           ; S3 uses a different address
                ds.b    1
Debug_cheat_flag:   set     *                           ; S3 uses a different address
                ds.w    1                               ; set if the debug cheat's been entered
Level_select_cheat_counter: set     *                   ; S3 uses a different address
                ds.w    1                               ; progress entering level select cheat, unused
Debug_mode_cheat_counter:   set     *                   ; S3 uses a different address
                ds.w    1                               ; progress entering debug mode cheat, unused
Competition_mode:   set     *                           ; S3 uses a different address
                ds.w    1
P1_character:   set     *                               ; S3 uses a different address
                ds.b    1                               ; 0 = Sonic, 1 = Tails, 2 = Knuckles
P2_character:   set     *                               ; S3 uses a different address
                ds.b    1
                ds.l    1                               ; unused

CrossResetRAM_End:  set     *                           ; S3 uses a different address

V_int_jump:     set     *                               ; S3 uses a different address
                ds.b    6                               ; contains an instruction to jump to the V-int handler
V_int_addr:     set     V_int_jump+2                    ; long
H_int_jump:     set     *                               ; S3 uses a different address
                ds.b    6                               ; contains an instruction to jump to the H-int handler
H_int_addr:         set     H_int_jump+2                ; long
Checksum_string:    set     *                           ; S3 uses a different address
                ds.l    1                               ; set to Ref_Checksum_String once the checksum routine has run
Ref_Checksum_String:    set     'SM&K'

RAM_end:        equ     *
                .check: equ (*)&$FFFFFF
                if      (.check>0)&(.check<$FF0000)
                fatal   "Sonic & Knuckles RAM definitions are too large by $\{*} bytes!"
                endif
                dephase
