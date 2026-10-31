; Owner: memory/shared
; Responsibility: Special-stage scratch overlays in player position history storage
; Source provenance and ranges: config/reconstruction/source_layout.json

                padding off

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
