; Owner: memory/s3
; Responsibility: Official Sonic 3 RAM overlay and interrupt storage overrides
; Source provenance and ranges: config/reconstruction/source_layout.json

                padding off
; Zone IDs from Sonic 2
emerald_hill_zone:  equ     $00
mystic_cave_zone:   equ     $0B
casino_night_zone:  equ     $0C

; Zone and act IDs from Sonic 2
emerald_hill_zone_act_1:    equ     (emerald_hill_zone<<8)|$00
emerald_hill_zone_act_2:    equ     (emerald_hill_zone<<8)|$01
casino_night_zone_act_1:    equ     (casino_night_zone<<8)|$00
casino_night_zone_act_2:    equ     (casino_night_zone<<8)|$01
mystic_cave_zone_act_1:     equ     (mystic_cave_zone<<8)|$00
mystic_cave_zone_act_2:     equ     (mystic_cave_zone<<8)|$01

                phase   Level_layout_header+$400
SStage_extra_sprites:   set     *                       ; Sonic & Knuckles uses a different address
                ds.b    $70                             ; some extra sprite info for special stages
                ds.b    $390                            ; unused
SStage_collision_response_list: set     *               ; Sonic & Knuckles uses a different address
                ds.b    $100                            ; some extra sprite info for special stages
SStage_blue_sphere_to_ring_queue:   set     *           ; Sonic & Knuckles uses a different address
                ds.b    $100                            ; queue used by special stages to temporarily store the positions of blue spheres that have turned into rings
SStage_red_sphere_dfs_walk_stack:   set     *           ; Sonic & Knuckles uses a different address
                ds.b    $100                            ; stack of (direction index bounds, direction index, position) used by special stages
        ; as part of the red sphere DFS walk to check for loops of red spheres
                dephase

                phase   Stat_table+$12
S3SphereTestResetOnlyReservedWord:  ds.w    1           ; unused, but referenced in sphere test
S3SphereTestVerticalProjectionBias: ds.w    1           ; used in sphere test
S3SphereTestDepthProjectionBias:    ds.w    1           ; used in sphere test
Sphere_test_address:                ds.w    1           ; address of the sphere test object

Save_pointer:   set     Competition_saved_data+$B8      ; long ; pointer to the active save slot in 1 player mode
Saved_data:     set     Competition_saved_data+$CC      ; $34 bytes ; saved data from 1 player mode
H_int_jump:     set     S3HInterruptTrampolineStorage   ; 6 bytes ; contains an instruction to jump to the H-int handler
H_int_addr:     set     H_int_jump+2                    ; long
                dephase

                phase   CompactSceneObjectRespawnBytes+8
CNZ_bumper_routine:             ds.b    1               ; left over from Sonic 2
CNZ_bumper_unk:                 ds.b    1               ; left over from Sonic 2 ; set only, never used again
CNZ_visible_bumpers_start:      ds.l    1               ; left over from Sonic 2
CNZ_Visible_bumpers_end:        ds.l    1               ; left over from Sonic 2
CNZ_Visible_bumpers_start_P2:   ds.l    1               ; left over from Sonic 2
CNZ_Visible_bumpers_end_P2:     ds.l    1               ; left over from Sonic 2
                dephase

                phase   S3LegacyVersusZoneActOverlayStorage
Current_zone_2P:                ds.b    1               ; left over from Sonic 2
Current_act_2P:                 ds.b    1               ; left over from Sonic 2
Options_menu_box:               equ     S3LegacyOptionsSelectionOverlayStorage  ; byte ; left over from Sonic 2
S3LegacyClearOnlyOverlayAlias:  equ     S3LegacyClearOnlyOverlayStorage  ; word ; unused
                dephase

                phase   Demo_mode_flag
Level_select_flag:  set     *                           ; Sonic & Knuckles uses a different address
                ds.b    1
Slow_motion_flag:   set     *                           ; Sonic & Knuckles uses a different address
                ds.b    1
Debug_cheat_flag:   set     *                           ; Sonic & Knuckles uses a different address
                ds.w    1                               ; set if the debug cheat's been entered
Level_select_cheat_counter: set     *                   ; Sonic & Knuckles uses a different address
                ds.w    1                               ; progress entering level select cheat, unused
Debug_mode_cheat_counter:   set     *                   ; Sonic & Knuckles uses a different address
                ds.w    1                               ; progress entering debug mode cheat, unused
Competition_mode:   set     *                           ; Sonic & Knuckles uses a different address
                ds.w    1
P1_character:   set     *                               ; Sonic & Knuckles uses a different address
                ds.b    1                               ; 0 = Sonic, 1 = Tails, 2 = Knuckles
P2_character:   set     *                               ; Sonic & Knuckles uses a different address
                ds.b    1
_dbgFFDC:       ds.b    1                               ; seems like a leftover constant. Existed in Sonic 1 and Sonic 2 as well
_dbgFFDD:       ds.b    1                               ; seems like a leftover constant. Existed in Sonic 1 and Sonic 2 as well
_dbgFFDE:       ds.b    1                               ; seems like a leftover constant. Existed in Sonic 1 and Sonic 2 as well
_dbgFFDF:       ds.b    1                               ; seems like a leftover constant. Existed in Sonic 1 and Sonic 2 as well
                dephase

                phase   V_int_jump
Demo_mode_flag: set     *                               ; Sonic & Knuckles uses a different address
                ds.w    1
Next_demo_number:   set     *                           ; Sonic & Knuckles uses a different address
                ds.w    1
Ending_demo_number: ds.w    1                           ; zone for the ending demos, unused
V_blank_cycles:     set     *                           ; Sonic & Knuckles uses a different address
                ds.w    1                               ; the number of cycles between V-blanks
Graphics_flags: set     *                               ; Sonic & Knuckles uses a different address
                ds.b    1                               ; bit 7 set = English system, bit 6 set = PAL system
                ds.b    1                               ; unused
Debug_mode_flag:    set     *                           ; Sonic & Knuckles uses a different address
                ds.w    1
Checksum_string:    set     *                           ; Sonic & Knuckles uses a different address
                ds.l    1                               ; set to Ref_Checksum_String once the checksum routine has run

CrossResetRAM_End:  set     *                           ; Sonic & Knuckles uses a different address

Ref_Checksum_String:    set     'init'
                dephase
                !org    0

                .check2: equ (*)&$FFFFFF
                if      (.check2>0)&(.check2<$FF0000)
                fatal   "Sonic 3 RAM definitions are too large by $\{*} bytes!"
                endif
