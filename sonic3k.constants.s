; Fixed cartridge bus interfaces
MD_Cartridge_Bus_End:       equ     $400000
S2_Second_Cartridge_Base:   equ     $200000
; Fixed exports of the excluded Sonic 2 second-cartridge ABI
S2_External_Sprite_List_16: equ     S2_Second_Cartridge_Base+$E8C80
S2_External_Sprite_List_17: equ     S2_Second_Cartridge_Base+$E8D94
S2_External_Sprite_List_24: equ     S2_Second_Cartridge_Base+$13F06E
S2_External_Sprite_List_25: equ     S2_Second_Cartridge_Base+$13F74C
S2_External_Sprite_List_28: equ     S2_Second_Cartridge_Base+$EB230
S2_External_Sprite_List_29: equ     S2_Second_Cartridge_Base+$EB254
S2_External_Sprite_List_32: equ     S2_Second_Cartridge_Base+$EBBDE
S2_External_Sprite_List_33: equ     S2_Second_Cartridge_Base+$EBD4C
S2_LockOn_Patch_Start:      equ     $300000
S2_LockOn_Patch_End:        equ     $340000

; Collision probes advance one 16-pixel block at a time; a3 carries a scalar
Collision_Scan_Step:    equ     $10

; Equates section - names for variables

; ---------------------------------------------------------------------------
; Object Status Table offsets
; ---------------------------------------------------------------------------

; universally followed object conventions:
code:           equ     0                               ; longword
render_flags:   equ     4                               ; bitfield ; refer to SCHG for details
height_pixels:  equ     6                               ; byte
width_pixels:   equ     7                               ; byte
priority:       equ     8                               ; word ; in units of $80
art_tile:       equ     $A                              ; word ; PCCVH AAAAAAAAAAA ; P = priority, CC = palette line, V = y-flip; H = x-flip, A = starting cell index of art
mappings:       equ     $C                              ; long
x_pos:          equ     $10                             ; word, or long when extra precision is required
y_pos:          equ     $14                             ; word, or long when extra precision is required
mapping_frame:  equ     $22                             ; byte
; ---------------------------------------------------------------------------
; conventions followed by most objects:
routine:            equ     5                           ; byte
x_vel:              equ     $18                         ; word
y_vel:              equ     $1A                         ; word
y_radius:           equ     $1E                         ; byte ; collision height / 2
x_radius:           equ     $1F                         ; byte ; collision width / 2
anim:               equ     $20                         ; byte
prev_anim:          equ     $21                         ; byte ; when this isn't equal to anim the animation restarts
anim_frame:         equ     $23                         ; byte
anim_frame_timer:   equ     $24                         ; byte
angle:              equ     $26                         ; byte ; angle about axis into plane of the screen (00 = vertical, 360 degrees = 256)
status:             equ     $2A                         ; bitfield ; refer to SCHG for details
; ---------------------------------------------------------------------------
; conventions followed by many objects but not Sonic/Tails/Knuckles:
x_pixel:            equ     x_pos                       ; word ; x-coordinate for objects using screen positioning
y_pixel:            equ     y_pos                       ; word ; y-coordinate for objects using screen positioning
collision_flags:    equ     $28                         ; byte ; TT SSSSSS ; TT = collision type, SSSSSS = size
collision_property: equ     $29                         ; byte ; usage varies, bosses use it as a hit counter
shield_reaction:    equ     $2B                         ; byte ; bit 3 = bounces off shield, bit 4 = negated by fire shield, bit 5 = negated by lightning shield, bit 6 = negated by bubble shield
subtype:            equ     $2C                         ; byte
ros_bit:            equ     $3B                         ; byte ; the bit to be cleared when an object is destroyed if the ROS flag is set
ros_addr:           equ     $3C                         ; word ; the RAM address whose bit to clear when an object is destroyed if the ROS flag is set
routine_secondary:  equ     $3C                         ; byte ; used by monitors for this purpose at least
vram_art:           equ     $40                         ; word ; address of art in VRAM (same as art_tile * $20)
parent:             equ     $42                         ; word ; address of the object that owns or spawned this one, if applicable
child_dx:           equ     $42                         ; byte ; X offset of child relative to parent
child_dy:           equ     $43                         ; byte ; Y offset of child relative to parent
parent3:            equ     $46                         ; word ; parent of child objects
parent2:            equ     $48                         ; word ; several objects use this instead
respawn_addr:       equ     $48                         ; word ; the address of this object's entry in the respawn table
; ---------------------------------------------------------------------------
; conventions specific to Sonic/Tails/Knuckles:
ground_vel:             equ     $1C                     ; word ; overall velocity along ground, not updated when in the air
double_jump_property:   equ     $25                     ; byte ; remaining frames of flight / 2 for Tails, gliding-related for Knuckles
flip_angle:             equ     $27                     ; byte ; angle about horizontal axis (360 degrees = 256)
status_secondary:       equ     $2B                     ; byte ; see SCHG for details
air_left:               equ     $2C                     ; byte
flip_type:              equ     $2D                     ; byte ; bit 7 set means flipping is inverted, lower bits control flipping type
object_control:         equ     $2E                     ; byte ; bit 0 set means character can jump out, bit 7 set means he can't
double_jump_flag:       equ     $2F                     ; byte ; meaning depends on current character, see SCHG for details
flips_remaining:        equ     $30                     ; byte
flip_speed:             equ     $31                     ; byte
move_lock:              equ     $32                     ; word ; horizontal control lock, counts down to 0
invulnerability_timer:  equ     $34                     ; byte ; decremented every frame
invincibility_timer:    equ     $35                     ; byte ; decremented every 8 frames
speed_shoes_timer:      equ     $36                     ; byte ; decremented every 8 frames
status_tertiary:        equ     $37                     ; byte ; see SCHG for details
character_id:           equ     $38                     ; byte ; 0 for Sonic, 1 for Tails, 2 for Knuckles
scroll_delay_counter:   equ     $39                     ; byte ; incremented each frame the character is looking up/down, camera starts scrolling when this reaches 120
next_tilt:              equ     $3A                     ; byte ; angle on ground in front of character
tilt:                   equ     $3B                     ; byte ; angle on ground
stick_to_convex:        equ     $3C                     ; byte ; used to make character stick to convex surfaces such as the rotating discs in CNZ
spin_dash_flag:         equ     $3D                     ; byte ; bit 1 indicates spin dash, bit 7 indicates forced roll
spin_dash_counter:      equ     $3E                     ; word
jumping:                equ     $40                     ; byte
interact:               equ     $42                     ; word ; RAM address of the last object the character stood on
default_y_radius:       equ     $44                     ; byte ; default value of y_radius
default_x_radius:       equ     $45                     ; byte ; default value of x_radius
top_solid_bit:          equ     $46                     ; byte ; the bit to check for top solidity (either $C or $E)
lrb_solid_bit:          equ     $47                     ; byte ; the bit to check for left/right/bottom solidity (either $D or $F)
; ---------------------------------------------------------------------------
; conventions followed by some/most bosses:
boss_saved_mus: equ     $26                             ; byte ; used primarily by loc_85CA4 which is used by cutscene knuckles, and most of the boss objects
boss_hitcount2: equ     $29
; ---------------------------------------------------------------------------
; when childsprites are activated (i.e. bit #6 of render_flags set)
mainspr_childsprites:   equ     $16                     ; amount of child sprites
sub2_x_pos:             equ     $18                     ; x_vel
sub2_y_pos:             equ     $1A                     ; y_vel
sub2_mapframe:          equ     $1D
sub3_x_pos:             equ     $1E                     ; y_radius
sub3_y_pos:             equ     $20                     ; anim
sub3_mapframe:          equ     $23                     ; anim_frame
sub4_x_pos:             equ     $24                     ; anim_frame_timer
sub4_y_pos:             equ     $26                     ; angle
sub4_mapframe:          equ     $29                     ; collision_property
sub5_x_pos:             equ     $2A                     ; status
sub5_y_pos:             equ     $2C                     ; subtype
sub5_mapframe:          equ     $2F
sub6_x_pos:             equ     $30
sub6_y_pos:             equ     $32
sub6_mapframe:          equ     $35
sub7_x_pos:             equ     $36
sub7_y_pos:             equ     $38
sub7_mapframe:          equ     $3B
sub8_x_pos:             equ     $3C
sub8_y_pos:             equ     $3E
sub8_mapframe:          equ     $41
sub9_x_pos:             equ     $42
sub9_y_pos:             equ     $44
sub9_mapframe:          equ     $47
next_subspr:            equ     $6
; ---------------------------------------------------------------------------
; property of all objects:
object_size:    equ     $4A                             ; the size of an object's status table entry
next_object:    equ     object_size
; ---------------------------------------------------------------------------
; unknown or inconsistently used offsets that are not applicable to Sonic/Tails:
objoff_12:      equ     2+x_pos
objoff_16:      equ     2+y_pos
objoff_1C:      equ     $1C
objoff_1D:      equ     $1D
objoff_27:      equ     $27
objoff_2E:      equ     $2E
objoff_2F:      equ     $2F
objoff_30:      equ     $30
                enum    objoff_31=$31,objoff_32=$32,objoff_33=$33,objoff_34=$34,objoff_35=$35,objoff_36=$36,objoff_37=$37
                enum    objoff_38=$38,objoff_39=$39,objoff_3A=$3A,objoff_3B=$3B,objoff_3C=$3C,objoff_3D=$3D,objoff_3E=$3E
                enum    objoff_3F=$3F,objoff_40=$40,objoff_41=$41,objoff_42=$42,objoff_43=$43,objoff_44=$44,objoff_45=$45
                enum    objoff_46=$46,objoff_47=$47,objoff_48=$48,objoff_49=$49

; ---------------------------------------------------------------------------
; Bits 3-6 of an object's status after a SolidObject call is a
; bitfield with the following meaning:
p1_standing_bit:    equ     3
p2_standing_bit:    equ     p1_standing_bit + 1

p1_standing:    equ     1<<p1_standing_bit
p2_standing:    equ     1<<p2_standing_bit

pushing_bit_delta:  equ     2
p1_pushing_bit:     equ     p1_standing_bit + pushing_bit_delta
p2_pushing_bit:     equ     p1_pushing_bit + 1

p1_pushing:     equ     1<<p1_pushing_bit
p2_pushing:     equ     1<<p2_pushing_bit

standing_mask:  equ     p1_standing|p2_standing
pushing_mask:   equ     p1_pushing|p2_pushing

; ---------------------------------------------------------------------------
; Controller Buttons
;
; Buttons bit numbers
button_up:      EQU     0
button_down:    EQU     1
button_left:    EQU     2
button_right:   EQU     3
button_B:       EQU     4
button_C:       EQU     5
button_A:       EQU     6
button_start:   EQU     7
; Buttons masks (1 << x == pow(2, x))
button_up_mask:     EQU     1<<button_up                ; $01
button_down_mask:   EQU     1<<button_down              ; $02
button_left_mask:   EQU     1<<button_left              ; $04
button_right_mask:  EQU     1<<button_right             ; $08
button_B_mask:      EQU     1<<button_B                 ; $10
button_C_mask:      EQU     1<<button_C                 ; $20
button_A_mask:      EQU     1<<button_A                 ; $40
button_start_mask:  EQU     1<<button_start             ; $80

; ---------------------------------------------------------------------------
; Player Status Variables
Status_Facing:      equ     0
Status_InAir:       equ     1
Status_Roll:        equ     2
Status_OnObj:       equ     3
Status_RollJump:    equ     4
Status_Push:        equ     5
Status_Underwater:  equ     6

; ---------------------------------------------------------------------------
; Player status_secondary variables
Status_Shield:      equ     0
Status_Invincible:  equ     1
Status_SpeedShoes:  equ     2

Status_FireShield:  equ     4
Status_LtngShield:  equ     5
Status_BublShield:  equ     6

; ---------------------------------------------------------------------------
; Elemental Shield DPLC variables
shield_prev_frame:  equ     $34
shield_art:         equ     $38
shield_plc:         equ     $3C

; ---------------------------------------------------------------------------
; Clock equates
; ---------------------------------------------------------------------------

Master_Clock:       equ     53693175
M68000_Clock:       equ     Master_Clock/7
Z80_Clock:          equ     Master_Clock/15
FM_Sample_Rate:     equ     M68000_Clock/(6*6*4)
PSG_Sample_Rate:    equ     Z80_Clock/16

; ---------------------------------------------------------------------------
; Address equates
; ---------------------------------------------------------------------------

; Z80 addresses
Z80_RAM:            equ     $A00000                     ; start of Z80 RAM
Z80_RAM_end:        equ     $A02000                     ; end of non-reserved Z80 RAM
Z80_bus_request:    equ     $A11100
Z80_reset:          equ     $A11200

SRAM_access_flag:   equ     $A130F1
Security_addr:      equ     $A14000
; ---------------------------------------------------------------------------

; I/O Area
HW_Version:             equ     $A10001
HW_Port_1_Data:         equ     $A10003
HW_Port_2_Data:         equ     $A10005
HW_Expansion_Data:      equ     $A10007
HW_Port_1_Control:      equ     $A10009
HW_Port_2_Control:      equ     $A1000B
HW_Expansion_Control:   equ     $A1000D
HW_Port_1_TxData:       equ     $A1000F
HW_Port_1_RxData:       equ     $A10011
HW_Port_1_SCtrl:        equ     $A10013
HW_Port_2_TxData:       equ     $A10015
HW_Port_2_RxData:       equ     $A10017
HW_Port_2_SCtrl:        equ     $A10019
HW_Expansion_TxData:    equ     $A1001B
HW_Expansion_RxData:    equ     $A1001D
HW_Expansion_SCtrl:     equ     $A1001F
; ---------------------------------------------------------------------------

; VDP addresses
VDP_data_port:      equ     $C00000
VDP_control_port:   equ     $C00004
PSG_input:          equ     $C00011
; ---------------------------------------------------------------------------

; RAM addresses

; SRAM addresses
; Notes: SRAM in Sonic 3 Alone and Sonic 3 & Knuckles is 1KB in size
; Both games use odd 8-bit addresses for saving
; This means that even addresses cannot be used unless SRAM is set to use them
; Therefore, this is phased in word to skip the even bytes

SRAM_competition_size:  equ     $15*4                   ; $54 bytes
SRAM_S3game_size:       equ     $D*4                    ; $34 bytes
SRAM_SKgame_size:       equ     $15*4                   ; $54 bytes

                phase   $200001
SRAM_start:     equ     *
                ds.w    8                               ; unused
SRAM_competition:   ds.w    SRAM_competition_size       ; $54 bytes
                ds.w    2                               ; unused
SRAM_competition_backup:    ds.w    SRAM_competition_size  ; $54 bytes
                ds.w    2                               ; unused
SRAM_S3game:    ds.w    SRAM_S3game_size                ; $34 bytes
                ds.w    $12                             ; unused
SRAM_S3game_backup: ds.w    SRAM_S3game_size            ; $34 bytes
                ds.w    $12                             ; unused
SRAM_SKgame:    ds.w    SRAM_SKgame_size                ; $54 bytes
                ds.w    2                               ; unused
SRAM_SKgame_backup: ds.w    SRAM_SKgame_size            ; $54 bytes
                ds.w    $15                             ; unused
SRAM_end:       equ     *
                dephase

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

; extra Special Stage variables
                phase   Pos_table_P2
SStage_scalar_index_0:  ds.w    1                       ; unknown scalar table index value
SStage_scalar_index_1:  ds.w    1                       ; unknown scalar table index value
SStage_scalar_index_2:  ds.w    1                       ; unknown scalar table index value
SStage_scalar_result_0: ds.l    1                       ; unknown scalar table results values
SStage_scalar_result_1: ds.l    1                       ; unknown scalar table results values
SStage_scalar_result_2: ds.l    1                       ; unknown scalar table results values
                ds.b    $A
SStage_scalar_result_3:     ds.l    1                   ; unknown scalar table results values
Special_stage_anim_frame:   ds.w    1                   ; special stage globe's current animation frame, $10 and higher is turning
Special_stage_X_pos:        ds.w    1
Special_stage_Y_pos:        ds.w    1
Special_stage_angle:        ds.b    1                   ; $00 = north, $40 = west, $80 = south, $C0 = east
                ds.b    1                               ; unused
Special_stage_velocity:         ds.w    1               ; player's movement speed, negative when going backwards
Special_stage_turning:          ds.b    1               ; direction of next turn, 4 = left, -4 = right
Special_stage_bumper_lock:      ds.b    1               ; if set, the player can't start advancing by pressing up
Special_stage_prev_anim_frame:  ds.b    1
                ds.b    2                               ; unused
Special_stage_palette_frame:    ds.b    1               ; same as Special_stage_anim_frame, but set to 0 while turning
Special_stage_turn_lock:        ds.b    1               ; if set, the player can't turn
Special_stage_advancing:        ds.b    1               ; set when the player player presses up
Special_stage_jumping:          ds.b    1               ; $80 = normal jump, $81 = spring
Special_stage_fade_timer:       ds.b    1               ; counts up when leaving the special stage
Special_stage_prev_X_pos:       ds.w    1
Special_stage_prev_Y_pos:       ds.w    1
Special_stage_spheres_left:     ds.w    1
Special_stage_ring_count:       ds.w    1
Special_stage_sphere_HUD_flag:  ds.b    1
Special_stage_extra_life_flags: ds.b    1               ; when bit 7 is set, the ring HUD is updated
Special_stage_rate_timer:       ds.w    1               ; when this reaches 0, the special stage speeds up
Special_stage_jumping_P2:       ds.b    1               ; $80 = normal jump, $81 = spring
                ds.b    1                               ; unused
Special_stage_rings_left:       ds.w    1
Special_stage_rate:             ds.w    1               ; player's maximum speed in either direction
Special_stage_palette_addr:     ds.l    1               ; ROM address of the stage's color palette
Special_stage_clear_timer:      ds.w    1               ; counts up after getting the last sphere, when it reaches $100 the emerald appears
Special_stage_clear_routine:    ds.b    1               ; if set, the player can't jump
Special_stage_emerald_timer:    ds.b    1               ; counts down when the emerald appears, when it reaches 0 the emerald sound plays
Special_stage_interact:         ds.w    1               ; address of the last bumper touched, or the emerald at the end of the stage
Special_stage_started:          ds.b    1               ; set when the player begins moving at the start of the stage
                ds.b    $2F                             ; unused
SStage_extra_sprites:   set     *                       ; S3 uses a different address
                ds.b    $70                             ; some extra sprite info for special stages
                dephase
; ---------------------------------------------------------------------------
; Art tile stuff
palette_line_0: equ     (0<<13)
palette_line_1: equ     (1<<13)
palette_line_2: equ     (2<<13)
palette_line_3: equ     (3<<13)
high_priority:  equ     (1<<15)
tile_mask:      equ     $07FF
drawing_mask:   equ     $7FFF

; ---------------------------------------------------------------------------
; VRAM and tile art base addresses
; VRAM Reserved regions
VRAM_Plane_A_Name_Table:    equ     $C000               ; Extends until $CFFF
VRAM_Plane_B_Name_Table:    equ     $E000               ; Extends until $EFFF

; Menu background
ArtTile_S3MenuBG:   equ     $0001

; Competition mode
ArtTile_Competition_LevSel:     equ     $029F
ArtTile_Competition_ModeSel:    equ     $034A
ArtTile_Competition_Results:    equ     $034A
ArtTile_Competition_STKIcons:   equ     $0572
ArtTile_Competition_Text:       equ     $058D
ArtTile_Competition_CharSel:    equ     $05C9

; Save screen
ArtTile_Save_Misc:  equ     $029F
ArtTile_Save_Extra: equ     $0454
ArtTile_Save_Text:  equ     $0562

; Sonic 2 Menus
ArtTile_S2MenuBox:          equ     $0070
ArtTile_S2Sega:             equ     $0080
ArtTile_S2LevelSelectPics:  equ     $0090
ArtTile_S2Signpost:         equ     $0500

; Blue Sphere
ArtTile_BlueSphere_Difficulty:  equ     $0180
ArtTile_BlueSphere_BG:          equ     $0197
ArtTile_BlueSphere_Emeralds:    equ     $01DC
ArtTile_BlueSphere_Misc:        equ     $054E
ArtTile_BlueSphere_TitleText:   equ     $05BF
ArtTile_BlueSphere_Tails:       equ     $07A0

; Special Stage
ArtTile_SStage_GetBlueSpheres:  equ     $055F
ArtTile_SStage_Icons:           equ     $0589
ArtTile_SStage_BG:              equ     $059B
ArtTile_SStage_Ring:            equ     $05A7
ArtTile_SStage_Emerald:         equ     $05A7
ArtTile_SStage_Sphere:          equ     $0680
ArtTile_SStage_Digits:          equ     $0781
ArtTile_SStage_Shadow:          equ     $07A0
ArtTile_SStage_Player2_Tail:    equ     $07B0
ArtTile_SStage_Player1:         equ     $07D4
ArtTile_SStage_Player2:         equ     $07EB

; Title screen
ArtTile_Title_Buffer:           equ     $0300
ArtTile_Title_Misc:             equ     $0400
ArtTile_Title_ANDKnuckles:      equ     $04C0
ArtTile_Title_Banner:           equ     $0500
ArtTile_Title_Menu:             equ     $0680
ArtTile_SKTitle_SonicKnuxStand: equ     $00E2
ArtTile_SKTitle_Menu:           equ     $0462
ArtTile_SKTitle_Sega:           equ     $049C
ArtTile_SKTitle_Banner:         equ     $04EE
ArtTile_SKTitle_SonicFall:      equ     $04EF
ArtTile_SKTitle_DeathEgg:       equ     $0680
ArtTile_SKTitle_Mountain:       equ     $07A0

; Sonic 3 fonts (continue, credits)
ArtTile_S3Fonts_SmallText:  equ     $0001
ArtTile_S3Fonts_BigText:    equ     $0029

; Continue screen
ArtTile_Continue_Digits:    equ     $0001
ArtTile_Continue_Misc:      equ     $008C
ArtTile_Continue_Icons:     equ     $00D9
ArtTile_Continue_Text:      equ     $0347

; Ending
ArtTile_Ending_S3EndPose:           equ     $03D9
ArtTile_Ending_S3Sprites:           equ     $045D
ArtTile_Ending_Sprites:             equ     $008E
ArtTile_Ending_Plane:               equ     $01E3
ArtTile_Ending_Emeralds:            equ     $0211
ArtTile_Ending_PlaneExtra:          equ     $026E
ArtTile_Ending_KnuxEndPose:         equ     $02C1
ArtTile_Ending_IslandLiftGfx:       equ     $02FF
ArtTile_Ending_Animals:             equ     $02FF
ArtTile_Ending_EyecatchEggman:      equ     $0300
ArtTile_Ending_EyecatchEggRobo:     equ     $0300
ArtTile_Ending_SSZKnuckles:         equ     $0310
ArtTile_Ending_CreditsText:         equ     $0347
ArtTile_Ending_SonicTailsEndPose:   equ     $0347
ArtTile_Ending_Cloud:               equ     $03B6
ArtTile_Ending_ANDKnuckles:         equ     $03EF
ArtTile_Ending_Logo:                equ     $0415
ArtTile_Ending_MasterEmerald:       equ     $052E
ArtTile_Ending_Knuckles:            equ     $05E0

; Game objects
ArtTile_AIZEndBoss:             equ     $0180
ArtTile_AIZMisc2:               equ     $02E9
ArtTile_AIZSlideRope:           equ     $0324
ArtTile_AIZMisc1:               equ     $0333
ArtTile_AIZFallingLog:          equ     $03CF
ArtTile_AIZIntroSprites:        equ     $03D1
ArtTile_AIZFloatingPlatform:    equ     $03F7
ArtTile_AIZMiniboss:            equ     $041A
ArtTile_AIZSwingVine:           equ     $041B
ArtTile_AIZBackgroundTree:      equ     $0438
ArtTile_AIZ2FloatingPlatform:   equ     $0440
ArtTile_AIZMinibossSmall:       equ     $0474
ArtTile_AIZBossFire:            equ     $0482
ArtTile_SphereTest:             equ     $04E0
ArtTile_AIZ2Bombership:         equ     $0500
ArtTile_Rhinobot:               equ     $0500
ArtTile_AIZIntroPlane:          equ     $0529
ArtTile_Bloominator:            equ     $052A
ArtTile_MonkeyDude:             equ     $0548
ArtTile_CaterkillerJr:          equ     $055F
ArtTile_Surfboard:              equ     $0585
ArtTile_AIZIntroEmeralds:       equ     $05B1

ArtTile_HCZ2BlockPlat:      equ     $0028
ArtTile_HCZMiniboss:        equ     $0304
ArtTile_HCZEndBoss:         equ     $0320
ArtTile_HCZ1WaterSplash2:   equ     $0344
ArtTile_HCZ2KnuxWall:       equ     $0350
ArtTile_HCZ2Slide:          equ     $035C
ArtTile_HCZCutsceneGeyser:  equ     $036B
ArtTile_HCZ2WaterSplash2:   equ     $036E
ArtTile_HCZWaterRush:       equ     $037A
ArtTile_HCZWaterSplash:     equ     $03B2
ArtTile_HCZMisc:            equ     $03CA
ArtTile_HCZMinibossSplash:  equ     $03FC
ArtTile_HCZButton:          equ     $0426
ArtTile_HCZWaveSplash:      equ     $042E
ArtTile_HCZSpikeBall:       equ     $043E
ArtTile_Buggernaut:         equ     $044C
ArtTile_TurboSpiker:        equ     $0500
ArtTile_HCZGeyser:          equ     $0500
ArtTile_HCZLargeFan:        equ     $0500
ArtTile_Blastoid:           equ     $0539
ArtTile_Jawz:               equ     $0539
ArtTile_MegaChopper:        equ     $054D
ArtTile_Pointdexter:        equ     $0559

ArtTile_MGZEndBoss:             equ     $033F
ArtTile_MGZMisc1:               equ     $035F
ArtTile_MGZMisc2:               equ     $03FF
ArtTile_MGZSigns:               equ     $0451
ArtTile_MGZEndBossDebris:       equ     $045E
ArtTile_MGZEndBossScaled:       equ     $0469
ArtTile_MGZMHZDiagonalSpring:   equ     $0478
ArtTile_MGZSpire:               equ     $0500
ArtTile_BubblesBadnik:          equ     $0500
ArtTile_Spiker:                 equ     $0530
ArtTile_MGZMiniboss:            equ     $054F
ArtTile_Mantis:                 equ     $054F
ArtTile_MGZMiniBossDebris:      equ     $0570

ArtTile_CNZMisc:        equ     $0351
ArtTile_CNZEndBoss:     equ     $0430
ArtTile_CNZPlatform:    equ     $0430
ArtTile_CNZCannon:      equ     $0448
ArtTile_CNZTeleport:    equ     $0500
ArtTile_Clamer:         equ     $0500
ArtTile_Sparkle:        equ     $0524
ArtTile_CNZMiniboss:    equ     $052E
ArtTile_Batbot:         equ     $0552
ArtTile_CNZBalloon:     equ     $0574

ArtTile_S3Snowboard:        equ     $06A4
ArtTile_ICZEndBoss:         equ     $02A6
ArtTile_Snowboard:          equ     $0320
ArtTile_ICZIntroSprites:    equ     $0347
ArtTile_ICZMisc2:           equ     $0377
ArtTile_ICZMisc1:           equ     $03B6
ArtTile_ICZMiniboss:        equ     $04A9
ArtTile_Penguinator:        equ     $0500
ArtTile_StarPointer:        equ     $0548
ArtTile_ICZSnowdust:        equ     $0558
ArtTile_ICZTeleport:        equ     $0570
ArtTile_SnowboardDust:      equ     $06B8

ArtTile_LBZ2Misc:           equ     $02EA
ArtTile_LBZFinalBoss1:      equ     $03AA
ArtTile_LBZMisc:            equ     $03C3
ArtTile_LBZFinalBoss2:      equ     $03D9
ArtTile_LBZEndBoss:         equ     $0425
ArtTile_LBZTubeTrans:       equ     $0455
ArtTile_LBZMinibossBox:     equ     $0456
ArtTile_LBZ2DeathEggSmall:  equ     $04AE
ArtTile_LBZKnuxBomb:        equ     $04D6
ArtTile_LBZMiniboss:        equ     $04D6
ArtTile_Flybot767:          equ     $0500
ArtTile_SnaleBlaster:       equ     $0524
ArtTile_Ribot:              equ     $0547
ArtTile_Corkey:             equ     $0558
ArtTile_Orbinaut:           equ     $056E

ArtTile_MHZ1CutsceneButton: equ     $0341
ArtTile_MHZMisc:            equ     $0347
ArtTile_MHZMiniboss:        equ     $03AD
ArtTile_MHZEndBossSpikes:   equ     $03AF
ArtTile_MHZEndBoss:         equ     $03EC
ArtTile_MHZMinibossLog:     equ     $049F
ArtTile_Cluckoid:           equ     $0500
ArtTile_MHZShipPropeller:   equ     $0500
ArtTile_MHZKnuxPeer:        equ     $0500
ArtTile_Butterdroid:        equ     $0514
ArtTile_MHZKnuxSwitch:      equ     $0528
ArtTile_KnuxIntroBomb:      equ     $052E
ArtTile_Dragonfly:          equ     $0538
ArtTile_Madmole:            equ     $0545
ArtTile_Mushmeanie:         equ     $056D
ArtTile_MHZEndBossPillar:   equ     $0580

ArtTile_FBZSpikes:          equ     $0200
ArtTile_FBZMisc2:           equ     $02D2
ArtTile_FBZOutdoors:        equ     $02E5
ArtTile_FBZEggCapsule:      equ     $035D
ArtTile_FBZMisc:            equ     $0379
ArtTile_FBZCloud:           equ     $03A3
ArtTile_FBZBossPillar:      equ     $03D5
ArtTile_FBZExitDoor:        equ     $03E5
ArtTile_FBZExitHall:        equ     $03F4
ArtTile_FBZEndBoss:         equ     $0400
ArtTile_FBZAnimals1:        equ     $042E
ArtTile_FBZRobotnikHead:    equ     $0430
ArtTile_FBZAnimals2:        equ     $0440
ArtTile_FBZEndBossFlame:    equ     $0450
ArtTile_FBZRobotnikStand:   equ     $0466
ArtTile_FBZRobotnikRun:     equ     $04A9
ArtTile_FBZButton:          equ     $0500
ArtTile_Blaster:            equ     $0506
ArtTile_FBZ2Subboss:        equ     $052E
ArtTile_FBZMiniboss:        equ     $052E
ArtTile_Technosqueek:       equ     $052E

ArtTile_SOZEndBoss:         equ     $03A4
ArtTile_SOZ2Extra:          equ     $03AF
ArtTile_SOZMiniboss:        equ     $03B5
ArtTile_SOZTile:            equ     $03C0
ArtTile_SOZMisc:            equ     $03C9
ArtTile_SOZSand:            equ     $04F3
ArtTile_Rockn:              equ     $0500
ArtTile_SOZGhosts:          equ     $0500
ArtTile_Skorp:              equ     $0536
ArtTile_SOZGhostCapsule:    equ     $0536
ArtTile_Sandworm:           equ     $0557

ArtTile_LRZ2DeathEggBG:     equ     $039F
ArtTile_LRZMisc:            equ     $03A1
ArtTile_LRZ3DeathEggFlash:  equ     $03AB
ArtTile_LRZ2Drum:           equ     $03AD
ArtTile_LRZEndBoss:         equ     $03CC
ArtTile_LRZMiniboss:        equ     $03FB
ArtTile_LRZ2Misc:           equ     $040D
ArtTile_LRZ3Autoscroll:     equ     $0424
ArtTile_LRZBigSpike:        equ     $0442
ArtTile_LRZ3PlatformDebris: equ     $0487
ArtTile_Fireworm:           equ     $0500
ArtTile_LRZKnuxBoulder:     equ     $0500
ArtTile_FirewormSegments:   equ     $0512
ArtTile_LRZRockCrusher:     equ     $052E
ArtTile_Iwamodoki:          equ     $0530
ArtTile_Toxomister:         equ     $0562

ArtTile_HPZEmeraldMisc:     equ     $03B5
ArtTile_HPZGrayEmerald:     equ     $0477
ArtTile_HPZEntryTeleporter: equ     $0488
ArtTile_HPZSmallEmeralds:   equ     $04AC
ArtTile_HPZKnuxDizzy:       equ     $0500
ArtTile_HPZKnuxBossDust:    equ     $0500
ArtTile_HPZTeleporter:      equ     $052E

ArtTile_SSZMasterEmerald:   equ     $01EE
ArtTile_SSZMisc:            equ     $02D4
ArtTile_SSZSpiralRamp:      equ     $0348
ArtTile_MechaSonic:         equ     $03F4
ArtTile_MechaSonicExtra:    equ     $041C
ArtTile_SSZMTZOrbs:         equ     $041F
ArtTile_SSZGHZMisc:         equ     $0468
ArtTile_SSZCutsceneButton:  equ     $048E
ArtTile_HPZSSZBossCrane:    equ     $04A7
ArtTile_SSZDeathEggCloud:   equ     $04C9
ArtTile_EggRoboBadnik:      equ     $0500
ArtTile_SSZDeathEggSmall:   equ     $0500
ArtTile_EggRoboFlyScaled:   equ     $0500

ArtTile_DEZFinalBossDebris: equ     $0100
ArtTile_DEZMisc2:           equ     $02FC
ArtTile_DEZ2Extra:          equ     $0332
ArtTile_DEZMisc:            equ     $034D
ArtTile_DEZEndBoss:         equ     $038A
ArtTile_DEZFinalBossMisc:   equ     $038F
ArtTile_DEZMiniboss:        equ     $0400
ArtTile_DEZBossCrane:       equ     $049D
ArtTile_Spikebonker:        equ     $0500
ArtTile_Chainspike:         equ     $0542
ArtTile_DEZRobotnikRun:     equ     $058C

ArtTile_DDZMisc:            equ     $02DB
ArtTile_BossMasterEmerald:  equ     $04D0

ArtTile_2PArt_2:        equ     $0391
ArtTile_2PArt_1:        equ     $03AD
ArtTile_2PArt_3:        equ     $03C6
ArtTile_2PTime:         equ     $0600
ArtTile_2PStartPost:    equ     $06BC
ArtTile_2PLapNum:       equ     $0700
ArtTile_2PPosIcon:      equ     $075E

ArtTile_DPZMisc:    equ     $0280
ArtTile_BPZMisc:    equ     $0300
ArtTile_CGZMisc:    equ     $0300
ArtTile_EMZMisc:    equ     $0300

ArtTile_BonusStage:         equ     $015B
ArtTile_PachinkoMain:       equ     $02CD
ArtTile_SlotsBlocks:        equ     $033B
ArtTile_PachinkoGumballs:   equ     $0388

; ---------------------------------------------------------------------------
; Universal locations

; Universal (used on all standard levels)
ArtTile_DiagonalSpring: equ     $043A
ArtTile_GrayButton:     equ     $0456
ArtTile_Bubbles:        equ     $045C
ArtTile_EggCapsule:     equ     $0494
ArtTile_SpikesSprings:  equ     $0494
ArtTile_EndSigns:       equ     $04AC
ArtTile_Monitors:       equ     $04C4
ArtTile_BossExplosion2: equ     $04D2
ArtTile_CutsceneKnux:   equ     $04DA
ArtTile_BossExplosion:  equ     $0500
ArtTile_RobotnikShip:   equ     $052E
ArtTile_Animals1:       equ     $0580
ArtTile_Animals2:       equ     $0592
ArtTile_Explosion:      equ     $05A0
ArtTile_StarPost:       equ     $05E4
ArtTile_Player_1:       equ     $0680
ArtTile_SignpostStub:   equ     $069E
ArtTile_Player_2:       equ     $06A0
ArtTile_Player_2_Tail:  equ     $06B0
ArtTile_Ring:           equ     $06BC
ArtTile_Shield:         equ     $079C
ArtTile_Shield_Sparks:  equ     $07BB
ArtTile_PlayerLifeIcon: equ     $07D4
ArtTile_DashDust:       equ     $07E0
ArtTile_DashDust_P2:    equ     $07F0

; ---------------------------------------------------------------------------
; Sound commands list

                phase   $E1
cmd__First:     equ     *                               ; ID of the first sound command
cmd_FadeOut:    ds.b    1                               ; $E1 - fade out music
cmd_Stop:       ds.b    1                               ; $E2 - stop music and sound effects
cmd_MutePSG:    ds.b    1                               ; $E3 - mute all PSG channels
cmd_StopSFX:    ds.b    1                               ; $E4 - stop all sound effects
cmd_FadeOut2:   ds.b    1                               ; $E5 - fade out music (duplicate)
cmd__End:       equ     *                               ; next ID after last sound command

cmd_S2SEGA:     equ     $FA                             ; $FA - SEGA sound ID in Sonic 2
cmd_StopSEGA:   equ     $FE                             ; $FE - Stop SEGA sound
cmd_SEGA:       equ     $FF                             ; $FF - Play SEGA sound
                dephase
; ---------------------------------------------------------------------------
; Music ID's list. These do not affect the sound driver, be careful

                phase   $01
mus__First:             equ     *                       ; ID of the first music
mus_AIZ1:               ds.b    1                       ; $01
mus_AIZ2:               ds.b    1                       ; $02
mus_HCZ1:               ds.b    1                       ; $03
mus_HCZ2:               ds.b    1                       ; $04
mus_MGZ1:               ds.b    1                       ; $05
mus_MGZ2:               ds.b    1                       ; $06
mus_CNZ1:               ds.b    1                       ; $07
mus_CNZ2:               ds.b    1                       ; $08
mus_FBZ1:               ds.b    1                       ; $09
mus_FBZ2:               ds.b    1                       ; $0A
mus_ICZ1:               ds.b    1                       ; $0B
mus_ICZ2:               ds.b    1                       ; $0C
mus_LBZ1:               ds.b    1                       ; $0D
mus_LBZ2:               ds.b    1                       ; $0E
mus_MHZ1:               ds.b    1                       ; $0F
mus_MHZ2:               ds.b    1                       ; $10
mus_SOZ1:               ds.b    1                       ; $11
mus_SOZ2:               ds.b    1                       ; $12
mus_LRZ1:               ds.b    1                       ; $13
mus_LRZ2:               ds.b    1                       ; $14
mus_SSZ:                ds.b    1                       ; $15
mus_DEZ1:               ds.b    1                       ; $16
mus_DEZ2:               ds.b    1                       ; $17
mus_MinibossK:          ds.b    1                       ; $18
mus_EndBoss:            ds.b    1                       ; $19
mus_DDZ:                ds.b    1                       ; $1A
mus_Pachinko:           ds.b    1                       ; $1B
mus_SpecialStage:       ds.b    1                       ; $1C
mus_Slots:              ds.b    1                       ; $1D
mus_Gumball:            ds.b    1                       ; $1E
mus_Knuckles:           ds.b    1                       ; $1F
mus_ALZ:                ds.b    1                       ; $20
mus_BPZ:                ds.b    1                       ; $21
mus_DPZ:                ds.b    1                       ; $22
mus_CGZ:                ds.b    1                       ; $23
mus_EMZ:                ds.b    1                       ; $24
mus_TitleScreen:        ds.b    1                       ; $25
mus_Credits3:           ds.b    1                       ; $26
mus_GameOver:           ds.b    1                       ; $27
mus_Continue:           ds.b    1                       ; $28
mus_GotThroughAct:      ds.b    1                       ; $29
mus_ExtraLife:          ds.b    1                       ; $2A
mus_Emerald:            ds.b    1                       ; $2B
mus_Invincibility:      ds.b    1                       ; $2C
mus_CompetitionMenu:    ds.b    1                       ; $2D
mus_Miniboss:           ds.b    1                       ; $2E
mus_DataSelect:         ds.b    1                       ; $2F
mus_FinalBoss:          ds.b    1                       ; $30
mus_Drowning:           ds.b    1                       ; $31
mus_Ending:             ds.b    1                       ; $32
mus__End:               equ     *                       ; next ID after last music
                dephase

; ---------------------------------------------------------------------------
; Sound effect ID's list. These do not affect the sound driver, be careful

                phase   $33
sfx__First:             equ     *                       ; ID of the first sound effect
sfx_RingRight:          ds.b    1                       ; $33
sfx_RingLeft:           ds.b    1                       ; $34
sfx_Death:              ds.b    1                       ; $35
sfx_Skid:               ds.b    1                       ; $36
sfx_SpikeHit:           ds.b    1                       ; $37
sfx_Bubble:             ds.b    1                       ; $38
sfx_Splash:             ds.b    1                       ; $39
sfx_Shield:             ds.b    1                       ; $3A
sfx_Drown:              ds.b    1                       ; $3B
sfx_Roll:               ds.b    1                       ; $3C
sfx_Break:              ds.b    1                       ; $3D
sfx_FireShield:         ds.b    1                       ; $3E
sfx_BubbleShield:       ds.b    1                       ; $3F
sfx_UnknownShield:      ds.b    1                       ; $40
sfx_LightningShield:    ds.b    1                       ; $41
sfx_InstaAttack:        ds.b    1                       ; $42
sfx_FireAttack:         ds.b    1                       ; $43
sfx_BubbleAttack:       ds.b    1                       ; $44
sfx_ElectricAttack:     ds.b    1                       ; $45
sfx_Whistle:            ds.b    1                       ; $46
sfx_SandwallRise:       ds.b    1                       ; $47
sfx_Blast:              ds.b    1                       ; $48
sfx_Thump:              ds.b    1                       ; $49
sfx_Grab:               ds.b    1                       ; $4A
sfx_WaterfallSplash:    ds.b    1                       ; $4B
sfx_GlideLand:          ds.b    1                       ; $4C
sfx_Projectile:         ds.b    1                       ; $4D
sfx_MissileExplode:     ds.b    1                       ; $4E
sfx_FlamethrowerQuiet:  ds.b    1                       ; $4F
sfx_BossActivate:       ds.b    1                       ; $50
sfx_MissileThrow:       ds.b    1                       ; $51
sfx_SpikeMove:          ds.b    1                       ; $52
sfx_Charging:           ds.b    1                       ; $53
sfx_BossLaser:          ds.b    1                       ; $54
sfx_BlockConveyor:      ds.b    1                       ; $55
sfx_FlipBridge:         ds.b    1                       ; $56
sfx_Geyser:             ds.b    1                       ; $57
sfx_FanLatch:           ds.b    1                       ; $58
sfx_Collapse:           ds.b    1                       ; $59
sfx_UnknownCharge:      ds.b    1                       ; $5A
sfx_Switch:             ds.b    1                       ; $5B
sfx_MechaSpark:         ds.b    1                       ; $5C
sfx_FloorThump:         ds.b    1                       ; $5D
sfx_Laser:              ds.b    1                       ; $5E
sfx_Crash:              ds.b    1                       ; $5F
sfx_BossZoom:           ds.b    1                       ; $60
sfx_BossHitFloor:       ds.b    1                       ; $61
sfx_Jump:               ds.b    1                       ; $62
sfx_Starpost:           ds.b    1                       ; $63
sfx_PulleyGrab:         ds.b    1                       ; $64
sfx_BlueSphere:         ds.b    1                       ; $65
sfx_AllSpheres:         ds.b    1                       ; $66
sfx_LevelProjectile:    ds.b    1                       ; $67
sfx_Perfect:            ds.b    1                       ; $68
sfx_PushBlock:          ds.b    1                       ; $69
sfx_Goal:               ds.b    1                       ; $6A
sfx_ActionBlock:        ds.b    1                       ; $6B
sfx_Splash2:            ds.b    1                       ; $6C
sfx_UnknownShift:       ds.b    1                       ; $6D
sfx_BossHit:            ds.b    1                       ; $6E
sfx_Rumble2:            ds.b    1                       ; $6F
sfx_LavaBall:           ds.b    1                       ; $70
sfx_Shield2:            ds.b    1                       ; $71
sfx_Hoverpad:           ds.b    1                       ; $72
sfx_Transporter:        ds.b    1                       ; $73
sfx_TunnelBooster:      ds.b    1                       ; $74
sfx_BalloonPlatform:    ds.b    1                       ; $75
sfx_TrapDoor:           ds.b    1                       ; $76
sfx_Balloon:            ds.b    1                       ; $77
sfx_GravityMachine:     ds.b    1                       ; $78
sfx_Lightning:          ds.b    1                       ; $79
sfx_BossMagma:          ds.b    1                       ; $7A
sfx_SmallBumpers:       ds.b    1                       ; $7B
sfx_ChainTension:       ds.b    1                       ; $7C
sfx_UnknownPump:        ds.b    1                       ; $7D
sfx_GroundSlide:        ds.b    1                       ; $7E
sfx_FrostPuff:          ds.b    1                       ; $7F
sfx_IceSpikes:          ds.b    1                       ; $80
sfx_TubeLauncher:       ds.b    1                       ; $81
sfx_SandSplash:         ds.b    1                       ; $82
sfx_BridgeCollapse:     ds.b    1                       ; $83
sfx_UnknownPowerUp:     ds.b    1                       ; $84
sfx_UnknownPowerDown:   ds.b    1                       ; $85
sfx_Alarm:              ds.b    1                       ; $86
sfx_MushroomBounce:     ds.b    1                       ; $87
sfx_PulleyMove:         ds.b    1                       ; $88
sfx_WeatherMachine:     ds.b    1                       ; $89
sfx_Bouncy:             ds.b    1                       ; $8A
sfx_ChopTree:           ds.b    1                       ; $8B
sfx_ChopStuck:          ds.b    1                       ; $8C
sfx_UnknownFlutter:     ds.b    1                       ; $8D
sfx_UnknownRevving:     ds.b    1                       ; $8E
sfx_DoorOpen:           ds.b    1                       ; $8F
sfx_DoorMove:           ds.b    1                       ; $90
sfx_DoorClose:          ds.b    1                       ; $91
sfx_GhostAppear:        ds.b    1                       ; $92
sfx_BossRecovery:       ds.b    1                       ; $93
sfx_ChainTick:          ds.b    1                       ; $94
sfx_BossHand:           ds.b    1                       ; $95
sfx_MechaLand:          ds.b    1                       ; $96
sfx_EnemyBreath:        ds.b    1                       ; $97
sfx_BossProjectile:     ds.b    1                       ; $98
sfx_UnknownPlink:       ds.b    1                       ; $99
sfx_SpringLatch:        ds.b    1                       ; $9A
sfx_ThumpBoss:          ds.b    1                       ; $9B
sfx_SuperEmerald:       ds.b    1                       ; $9C
sfx_Targeting:          ds.b    1                       ; $9D
sfx_Clank:              ds.b    1                       ; $9E
sfx_SuperTransform:     ds.b    1                       ; $9F
sfx_MissileShoot:       ds.b    1                       ; $A0
sfx_UnknownOminous:     ds.b    1                       ; $A1
sfx_FloorLauncher:      ds.b    1                       ; $A2
sfx_GravityLift:        ds.b    1                       ; $A3
sfx_MechaTransform:     ds.b    1                       ; $A4
sfx_UnknownRise:        ds.b    1                       ; $A5
sfx_LaunchGrab:         ds.b    1                       ; $A6
sfx_LaunchReady:        ds.b    1                       ; $A7
sfx_EnergyZap:          ds.b    1                       ; $A8
sfx_AirDing:            ds.b    1                       ; $A9
sfx_Bumper:             ds.b    1                       ; $AA
sfx_Spindash:           ds.b    1                       ; $AB
sfx_Continue:           ds.b    1                       ; $AC
sfx_LaunchGo:           ds.b    1                       ; $AD
sfx_Flipper:            ds.b    1                       ; $AE
sfx_EnterSS:            ds.b    1                       ; $AF
sfx_Register:           ds.b    1                       ; $B0
sfx_Spring:             ds.b    1                       ; $B1
sfx_Error:              ds.b    1                       ; $B2
sfx_BigRing:            ds.b    1                       ; $B3
sfx_Explode:            ds.b    1                       ; $B4
sfx_Diamonds:           ds.b    1                       ; $B5
sfx_Dash:               ds.b    1                       ; $B6
sfx_SlotMachine:        ds.b    1                       ; $B7
sfx_Signpost:           ds.b    1                       ; $B8
sfx_RingLoss:           ds.b    1                       ; $B9
sfx_Flying:             ds.b    1                       ; $BA
sfx_FlyTired:           ds.b    1                       ; $BB
sfx__FirstContinuous:   equ     *                       ; ID of the first continuous sound effect
sfx_SlideSkidLoud:      ds.b    1                       ; $BC
sfx_LargeShip:          ds.b    1                       ; $BD
sfx_RobotnikSiren:      ds.b    1                       ; $BE
sfx_BossRotate:         ds.b    1                       ; $BF
sfx_FanBig:             ds.b    1                       ; $C0
sfx_FanSmall:           ds.b    1                       ; $C1
sfx_FlamethrowerLoud:   ds.b    1                       ; $C2
sfx_GravityTunnel:      ds.b    1                       ; $C3
sfx_BossPanic:          ds.b    1                       ; $C4
sfx_UnknownSpin:        ds.b    1                       ; $C5
sfx_WaveHover:          ds.b    1                       ; $C6
sfx_CannonTurn:         ds.b    1                       ; $C7
sfx_SlideSkidQuiet:     ds.b    1                       ; $C8
sfx_SpikeBalls:         ds.b    1                       ; $C9
sfx_LightTunnel:        ds.b    1                       ; $CA
sfx_Rumble:             ds.b    1                       ; $CB
sfx_BigRumble:          ds.b    1                       ; $CC
sfx_DeathEggRiseLoud:   ds.b    1                       ; $CD
sfx_WindQuiet:          ds.b    1                       ; $CE
sfx_WindLoud:           ds.b    1                       ; $CF
sfx_Rising:             ds.b    1                       ; $D0
sfx_UnknownFlutter2:    ds.b    1                       ; $D1
sfx_GumballTab:         ds.b    1                       ; $D2
sfx_DeathEggRiseQuiet:  ds.b    1                       ; $D3
sfx_TurbineHum:         ds.b    1                       ; $D4
sfx_LavaFall:           ds.b    1                       ; $D5
sfx_UnknownZap:         ds.b    1                       ; $D6
sfx_ConveyorPlatform:   ds.b    1                       ; $D7
sfx_UnknownSaw:         ds.b    1                       ; $D8
sfx_MagneticSpike:      ds.b    1                       ; $D9
sfx_LeafBlower:         ds.b    1                       ; $DA
sfx_WaterSkid:          ds.b    1                       ; $DB
mus_CreditsK:           ds.b    1                       ; $DC - Can also be treated as SFX?
                ds.b    3                               ; unused SFX slots, the driver will happily play them though
sfx__End:       equ     *                               ; next ID after the last sound effect

                dephase
                !org    0                               ; make sure we reset the ROM position to 0

; Nemesis writes eight pixel rows per 8x8 tile; a5 carries this loop count
Nem_Tile_Row_Count: equ     8
