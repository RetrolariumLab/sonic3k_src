; Owner: memory/shared
; Responsibility: Object state, cartridge interfaces and shared collision scalar conventions
; Source provenance and ranges: config/reconstruction/source_layout.json

                padding off
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
