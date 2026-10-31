; Sibling engine assembly order; semantic extraction is in progress
                include "src/system/s3/bootstrap.s"
                include "src/system/s3/video_interrupts.s"
                include "src/system/s3/horizontal_interrupts.s"
                include "src/system/s3/device_services.s"
                include "src/game/modes/s3/pause.s"
                include "src/rendering/s3/vram_dma.s"
                include "src/rendering/compression/s3/nemesis.s"
                include "src/rendering/compression/s3/nemesis_queue.s"
                include "src/rendering/compression/s3/enigma.s"
                include "src/rendering/compression/s3/kosinski_streaming.s"
                include "src/system/s3/runtime_primitives.s"
                include "src/rendering/palettes/s3/zone_cycles.s"
                include "src/rendering/palettes/s3/zone_cycle_colours.s"
                include "src/rendering/palettes/s3/transformation_cycles.s"
                include "src/rendering/palettes/s3/fades_and_loading.s"
                include "src/game/modes/s3/title_screen.s"
                include "src/game/modes/s3/title_widgets.s"
                include "src/game/modes/s3/title_data.s"
                include "src/audio/s3/level_music_playlist.s"
                include "src/game/level/s3/mode_and_attract.s"
                include "src/game/level/s3/player_spawn.s"
                include "src/game/level/s3/environment_state.s"
                include "src/game/level/s3/water_tunnel_motion.s"
                include "src/game/level/s3/water_interrupt_tables.s"
                include "src/game/level/s3/demo_input.s"
                include "src/game/level/s3/collision_and_oscillation.s"
                include "src/game/level/s3/environment_loading.s"
                include "src/game/modes/s3/legacy_competition_selection.s"
                include "src/game/modes/s3/legacy_options.s"
                include "src/game/modes/s3/level_selection.s"
                include "src/game/modes/s3/level_selection_data.s"
                include "src/game/special_stage/s3/mode_and_display.s"
                include "src/game/special_stage/s3/palette_catalog.s"
                include "src/game/special_stage/s3/number_display.s"
                include "src/game/special_stage/s3/object_allocation.s"
                include "src/game/special_stage/s3/player_and_start_cues.s"
                include "src/game/special_stage/s3/tails_follower.s"
                include "src/game/special_stage/s3/projected_character_motion.s"
                include "src/game/special_stage/s3/sprite_rendering.s"
                include "src/game/special_stage/s3/sphere_contacts.s"
                include "src/game/modes/s3/competition_menu.s"
                include "src/game/modes/s3/competition_zone_selection.s"
                include "src/game/modes/s3/competition_player_selection.s"
                include "src/game/modes/s3/competition_results.s"
                include "src/game/modes/s3/time_attack_records.s"
                include "src/rendering/s3/menu_transfers.s"
                include "src/game/persistence/s3/sram_storage.s"
                include "src/game/modes/s3/save_screen.s"
                include "src/game/modes/s3/save_screen_data.s"
                include "src/game/modes/s3/save_slot_widgets.s"
                include "src/game/modes/s3/save_slot_erase.s"
                include "src/game/modes/s3/save_slot_text.s"
                include "src/rendering/s3/hud.s"
                include "src/rendering/s3/hud_fonts.s"
                include "src/objects/rings/s3/ring_runtime.s"
                include "src/objects/rings/s3/ring_rendering.s"
                include "src/objects/zones/cnz/s3/legacy_bumpers.s"
                include "src/objects/zones/cnz/s3/legacy_bumper_layouts.s"
                include "src/game/collision/s3/surface_attachment.s"
                include "src/game/collision/s3/tile_and_floor_probes.s"
                include "src/game/collision/s3/wall_probes.s"
                include "src/game/collision/s3/floor_clearance.s"
                include "src/game/collision/s3/wall_and_ceiling_clearance.s"
                include "src/game/collision/s3/object_touch_response.s"
                include "src/objects/players/sonic/s3/competition_player.s"
                include "src/objects/players/sonic/s3/lifecycle.s"
                include "src/objects/players/sonic/s3/environment_and_modes.s"
                include "src/objects/players/sonic/s3/ground_movement.s"
                include "src/objects/players/sonic/s3/rolling_and_air_steering.s"
                include "src/objects/players/sonic/s3/jump_actions.s"
                include "src/objects/players/common/s3/transformation_and_spindash.s"
                include "src/objects/players/common/s3/slope_physics.s"
                include "src/objects/players/sonic/s3/terrain_landing.s"
                include "src/objects/players/common/s3/damage_and_respawn.s"
                include "src/objects/players/sonic/s3/animation_and_patterns.s"
                include "src/objects/players/common/s3/competition_animation.s"
                include "src/objects/players/tails/s3/competition_player.s"
                include "src/objects/players/tails/s3/lifecycle.s"
                include "src/objects/players/tails/s3/ai_tracking.s"
                include "src/objects/players/tails/s3/ai_scripted_sequences.s"
                include "src/objects/players/tails/s3/carrying.s"
                include "src/objects/players/tails/s3/environment_and_modes.s"
                include "src/objects/players/tails/s3/flight_and_swim.s"
                include "src/objects/players/tails/s3/ground_movement.s"
                include "src/objects/players/tails/s3/rolling_and_air_steering.s"
                include "src/objects/players/tails/s3/jump_actions.s"
                include "src/objects/players/tails/s3/spindash_and_slopes.s"
                include "src/objects/players/tails/s3/terrain_landing.s"
                include "src/objects/players/tails/s3/damage_and_respawn.s"
                include "src/objects/players/tails/s3/animation_and_patterns.s"
                include "src/objects/players/tails/s3/competition_and_tail_display.s"
                include "src/objects/zones/mgz/s3/boss_transition.s"
                include "src/objects/players/common/s3/air_supply.s"
                include "src/objects/effects/s3/legacy_defense.s"
                include "src/objects/effects/s3/transient_player_effects.s"
                include "src/objects/effects/s3/elemental_shields.s"
                include "src/objects/rings/s3/ring_objects.s"
                include "src/objects/runtime/s3/execution_and_animation.s"
                include "src/rendering/s3/normal_sprite_renderer.s"
                include "src/rendering/s3/competition_sprite_renderer.s"
                include "src/objects/runtime/s3/visibility_and_culling.s"
                include "src/objects/runtime/s3/sprite_spawning.s"
                include "src/game/level/s3/bounds_catalog.s"
                include "src/game/level/s3/camera.s"
                include "src/game/level/s3/resource_setup.s"
                include "src/game/level/s3/camera_bounds_events.s"
                include "src/rendering/zones/lrz/s3/foreground_rocks.s"
                include "src/objects/shared/s3/path_switcher.s"
                include "src/objects/items/s3/monitor.s"
                include "src/game/collision/s3/solid_rectangles.s"
                include "src/game/collision/s3/solid_slopes_and_riding.s"
                include "src/objects/effects/s3/explosion_states.s"
                include "src/objects/zones/aiz/s3/static_decorations.s"
                include "src/objects/shared/s3/spin_trigger.s"
                include "src/objects/shared/s3/legacy_lava_markers.s"
                include "src/objects/shared/s3/invisible_solids.s"
                include "src/objects/zones/hcz/s3/breakable_bar.s"
                include "src/objects/zones/hcz/s3/wave_splash.s"
                include "src/objects/zones/hcz/s3/solid_block.s"
                include "src/objects/shared/s3/damage_regions.s"
                include "src/objects/zones/aiz/s3/hollow_tree.s"
                include "src/objects/shared/s3/breakable_rocks.s"
                include "src/objects/shared/s3/collapsing_platforms.s"
                include "src/objects/shared/s3/breakable_walls.s"
                include "src/objects/zones/aiz/s3/ride_vine.s"
                include "src/objects/zones/aiz/s3/giant_ride_vine.s"
                include "src/objects/zones/aiz/s3/surfboard_intro.s"
                include "src/objects/shared/springs/s3/initialization.s"
                include "src/objects/shared/springs/s3/axis_response.s"
                include "src/objects/shared/springs/s3/diagonal_response.s"
                include "src/objects/shared/springs/s3/retracting.s"
                include "src/objects/shared/s3/spikes.s"
                include "src/rendering/s3/art_scaling.s"
                include "src/objects/development/s3/sphere_test.s"
                include "src/objects/development/s3/sphere_mapping.s"
                include "src/objects/shared/s3/twisted_ramp.s"
                include "src/objects/zones/lbz/s3/moving_platforms.s"
                include "src/objects/zones/lbz/s3/unused_bar_platform.s"
                include "src/objects/shared/s3/floating_platforms.s"
                include "src/objects/zones/hcz/s3/snake_blocks.s"
                include "src/objects/zones/lbz/s3/unused_elevator.s"
                include "src/objects/zones/lbz/s3/exploding_trigger.s"
                include "src/objects/zones/mgz/s3/dash_trigger.s"
                include "src/objects/zones/lbz/s3/trigger_bridge.s"
                include "src/objects/zones/lbz/s3/player_launcher.s"
                include "src/objects/zones/lbz/s3/flamethrower.s"
                include "src/objects/zones/lbz/s3/ride_grapple.s"
                include "src/objects/zones/lbz/s3/cup_elevator.s"
                include "src/objects/zones/lbz/s3/unused_tilting_bridge.s"
                include "src/objects/zones/lbz/s3/pipe_plug.s"
                include "src/objects/zones/lbz/s3/unused_solid_hazard.s"
                include "src/rendering/tile_animation/s3/dispatch.s"
                include "src/rendering/zones/aiz/s3/tile_animation.s"
                include "src/rendering/zones/hcz/s3/tile_animation.s"
                include "src/rendering/tile_animation/s3/marble_and_carnival.s"
                include "src/rendering/zones/icz/s3/tile_animation.s"
                include "src/rendering/zones/lbz/s3/tile_animation.s"
                include "src/rendering/zones/lrz/s3/tile_animation.s"
                include "src/rendering/tile_animation/s3/bonus_modes.s"
                include "src/rendering/tile_animation/s3/script_player.s"
                include "src/rendering/tile_animation/s3/early_zone_scripts.s"
                include "src/rendering/tile_animation/s3/remaining_scripts.s"
                include "src/rendering/tile_animation/s3/initialization.s"
                include "src/objects/zones/lbz/s3/spin_launcher.s"
                include "src/objects/zones/lbz/s3/lowering_grapple.s"
                include "src/objects/shared/s3/smashing_pillar.s"
                include "src/objects/zones/lbz/s3/gate_laser.s"
                include "src/objects/zones/lbz/s3/alarm.s"
                include "src/objects/zones/lbz/s3/unused_force_fall.s"
                include "src/objects/shared/s3/automatic_tunnel.s"
                include "src/objects/shared/s3/tunnel_exhaust.s"
                include "src/objects/zones/lbz/s3/tube_elevator.s"
                include "src/objects/zones/aiz/s3/disappearing_floor.s"
                include "src/objects/shared/s3/cork_floor.s"
                include "src/objects/shared/s3/cork_floor_mappings.s"
                include "src/objects/zones/aiz/s3/flipping_bridge.s"
                include "src/objects/zones/aiz/s3/collapsing_log_bridge.s"
                include "src/objects/zones/aiz/s3/drawbridge.s"
                include "src/objects/zones/aiz/s3/falling_log.s"
                include "src/objects/zones/aiz/s3/spiked_log.s"
                include "src/objects/zones/aiz/s3/spiked_log_mapping.s"
                include "src/objects/scenery/s3/static_sprites.s"
                include "src/objects/scenery/s3/animated_sprites.s"
                include "src/objects/zones/aiz/s3/foreground_plants.s"
                include "src/objects/zones/aiz/s3/foreground_tree.s"
                include "src/objects/zones/lbz/s3/rolling_drum.s"
                include "src/objects/shared/s3/buttons.s"
                include "src/objects/shared/s3/animals_and_score.s"
                include "src/objects/checkpoints/s3/starpost.s"
                include "src/objects/interface/s3/game_over.s"
                include "src/objects/interface/s3/title_card.s"
                include "src/objects/interface/s3/level_results.s"
                include "src/game/special_stage/s3/results_mode.s"
                include "src/objects/interface/s3/special_results_coordinator.s"
                include "src/objects/interface/s3/special_results_catalog.s"
                include "src/objects/interface/s3/special_results_widgets.s"
                include "src/objects/interface/s3/result_mappings.s"
                include "src/rendering/s3/enemy_art_loading.s"
                include "src/objects/zones/hcz/s3/water_and_air_objects.s"
                include "src/objects/zones/hcz/s3/fans.s"
                include "src/objects/zones/hcz/s3/hand_launcher.s"
                include "src/objects/shared/s3/doors.s"
                include "src/objects/zones/hcz/s3/conveyor_belt.s"
                include "src/objects/zones/hcz/s3/conveyor_spike_mapping.s"
                include "src/objects/zones/cnz/s3/balloon.s"
                include "src/objects/zones/cnz/s3/cannon.s"
                include "src/objects/zones/cnz/s3/rising_platform.s"
                include "src/objects/zones/cnz/s3/trap_door.s"
                include "src/objects/zones/cnz/s3/light_bulb.s"
                include "src/objects/zones/cnz/s3/hover_fan.s"
                include "src/objects/zones/cnz/s3/vacuum_tube.s"
                include "src/objects/zones/cnz/s3/cylinder.s"
                include "src/objects/zones/cnz/s3/cylinder_mapping.s"
                include "src/objects/zones/hcz/s3/spinning_column.s"
                include "src/objects/zones/cnz/s3/giant_wheel.s"
                include "src/objects/zones/cnz/s3/triangle_bumpers.s"
                include "src/objects/shared/s3/sinking_mud.s"
                include "src/objects/competition/s3/triangle_bumpers.s"
                include "src/objects/shared/s3/bumpers.s"
                include "src/objects/zones/cnz/s3/spiral_tube.s"
                include "src/objects/zones/cnz/s3/barber_pole.s"
                include "src/objects/zones/cnz/s3/wire_cage.s"
                include "src/objects/zones/mgz/s3/twisting_loop.s"
                include "src/objects/zones/mgz/s3/swinging_platform.s"
                include "src/objects/zones/mgz/s3/swinging_spike_ball.s"
                include "src/objects/zones/mgz/s3/head_trigger.s"
                include "src/objects/zones/mgz/s3/trigger_platform.s"
                include "src/objects/zones/mgz/s3/moving_spike_platform.s"
                include "src/objects/zones/mgz/s3/pulley.s"
                include "src/objects/zones/mgz/top_platform/s3/state_and_riders.s"
                include "src/objects/zones/mgz/top_platform/s3/terrain_physics.s"
                include "src/objects/zones/mgz/top_platform/s3/scripted_paths.s"
                include "src/objects/zones/mgz/s3/top_launcher.s"
                include "src/objects/competition/s3/blade_platform.s"
                include "src/objects/competition/s3/elephant_block.s"
                include "src/objects/competition/s3/balloon.s"
                include "src/objects/competition/s3/dissolving_sand_bar.s"
                include "src/objects/competition/s3/desert_button.s"
                include "src/objects/competition/s3/item_objects.s"
                include "src/objects/competition/s3/goal_and_laps.s"
                include "src/objects/competition/s3/neon_display.s"
                include "src/objects/competition/s3/race_hud.s"
                include "src/objects/zones/emz/s3/dripper.s"
                include "src/objects/shared/s3/water_drop.s"
                include "src/objects/zones/hcz/s3/water_splash.s"
                include "src/objects/shared/tension_bridge/s3/state_and_segments.s"
                include "src/objects/shared/tension_bridge/s3/bending_and_collision.s"
                include "src/objects/shared/tension_bridge/s3/mappings.s"
                include "src/objects/zones/hcz/s3/twisting_loop.s"
                include "src/objects/zones/icz/s3/snowboard_intro.s"
                include "src/objects/shared/s3/intro_player_launch.s"
                include "src/objects/zones/icz/s3/tails_intro.s"
                include "src/game/level/s3/screen_dispatch.s"
                include "src/rendering/s3/level_video_transfers.s"
                include "src/rendering/s3/tile_grid_drawing.s"
                include "src/rendering/s3/plane_refresh.s"
                include "src/rendering/s3/deformed_tile_drawing.s"
                include "src/rendering/s3/deformation_operators.s"
                include "src/game/level/s3/scroll_events.s"
                include "src/game/level/s3/default_screen_handlers.s"
                include "src/game/competition/s3/screen_backgrounds.s"
                include "src/game/level/zones/aiz/s3/act1_screen_control.s"
                include "src/game/level/zones/aiz/s3/act1_deformation.s"
                include "src/game/level/zones/aiz/s3/act2_screen_control.s"
                include "src/game/level/zones/aiz/s3/act2_deformation.s"
                include "src/game/level/zones/aiz/s3/act2_air_raid.s"
                include "src/game/level/zones/hcz/s3/act1_screen.s"
                include "src/game/level/zones/hcz/s3/act2_screen.s"
                include "src/game/level/zones/mgz/s3/act1_screen.s"
                include "src/game/level/zones/mgz/s3/act2_screen_control.s"
                include "src/game/level/zones/mgz/s3/act2_collapse_background.s"
                include "src/game/level/zones/cnz/s3/act1_screen.s"
                include "src/game/level/zones/cnz/s3/act2_screen.s"
                include "src/game/level/zones/icz/s3/act1_screen.s"
                include "src/game/level/zones/icz/s3/act2_screen.s"
                include "src/game/level/zones/lbz/s3/act1_screen.s"
                include "src/game/level/zones/lbz/s3/act2_screen_control.s"
                include "src/game/level/zones/lbz/s3/act2_deformation.s"
                include "src/game/bonus/s3/gumball_screen.s"
                include "src/game/modes/s3/continue_screen.s"
                include "src/game/modes/s3/continue_resources.s"
                include "src/game/modes/s3/ending_credits.s"
                include "src/game/modes/s3/ending_credits_data.s"
                include "src/objects/interface/s3/sega_screen_actor.s"
                include "src/rendering/s3/sega_screen_transfers.s"
                include "src/rendering/s3/pixel_scale_2x.s"
                include "src/objects/bonus/s3/gumball_machine.s"
                include "src/objects/bonus/s3/gumball_bumpers.s"
                include "src/objects/bonus/s3/gumball_mapping.s"
                include "src/objects/special_stage/s3/entry_ring.s"
                include "src/objects/cutscenes/knuckles/s3/angel_island.s"
                include "src/objects/cutscenes/knuckles/s3/hydrocity.s"
                include "src/objects/cutscenes/knuckles/s3/carnival_night.s"
                include "src/objects/cutscenes/knuckles/s3/launch_base.s"
                include "src/objects/zones/lbz/s3/knuckles_pillar.s"
                include "src/objects/cutscenes/s3/button.s"
                include "src/objects/zones/cnz/s3/water_level_controls.s"
                include "src/objects/zones/aiz/s3/plane_intro.s"
                include "src/objects/bosses/common/s3/robotnik_heads.s"
                include "src/objects/bosses/common/s3/robotnik_ships.s"
                include "src/objects/bosses/aiz/s3/miniboss_arrival.s"
                include "src/objects/bosses/aiz/s3/miniboss.s"
                include "src/objects/bosses/aiz/end_boss/s3/main_control.s"
                include "src/objects/bosses/aiz/end_boss/s3/attachments_and_attacks.s"
                include "src/objects/bosses/aiz/end_boss/s3/child_motion_helpers.s"
                include "src/objects/bosses/aiz/end_boss/s3/object_catalog.s"
                include "src/objects/bosses/hcz/miniboss/s3/main_and_loop.s"
                include "src/objects/bosses/hcz/miniboss/s3/rockets.s"
                include "src/objects/bosses/hcz/miniboss/s3/engine_and_effects.s"
                include "src/objects/bosses/hcz/miniboss/s3/motion_helpers.s"
                include "src/objects/bosses/hcz/miniboss/s3/object_catalog.s"
                include "src/objects/bosses/hcz/end_boss/s3/main_and_chassis.s"
                include "src/objects/bosses/hcz/end_boss/s3/attacks_and_transition.s"
                include "src/objects/bosses/hcz/end_boss/s3/motion_helpers.s"
                include "src/objects/bosses/hcz/end_boss/s3/object_catalog.s"
                include "src/objects/bosses/mgz/s3/drilling_arrival.s"
                include "src/objects/bosses/mgz/end_boss/s3/battle_control.s"
                include "src/objects/bosses/mgz/end_boss/s3/attachments.s"
                include "src/objects/bosses/mgz/end_boss/s3/projectiles_and_defeat.s"
                include "src/objects/bosses/mgz/end_boss/s3/motion_helpers.s"
                include "src/objects/bosses/mgz/end_boss/s3/object_catalog.s"
                include "src/objects/bosses/cnz/miniboss/s3/main_and_top.s"
                include "src/objects/bosses/cnz/miniboss/s3/coil_and_sparks.s"
                include "src/objects/bosses/cnz/miniboss/s3/motion_and_collision.s"
                include "src/objects/bosses/cnz/miniboss/s3/object_catalog.s"
                include "src/objects/bosses/cnz/end_boss/s3/battle_and_attacks.s"
                include "src/objects/bosses/cnz/end_boss/s3/motion_helpers.s"
                include "src/objects/bosses/cnz/end_boss/s3/object_catalog.s"
                include "src/objects/bosses/fbz/miniboss/s3/battle_and_attacks.s"
                include "src/objects/bosses/fbz/miniboss/s3/motion_helpers.s"
                include "src/objects/bosses/fbz/miniboss/s3/object_catalog.s"
                include "src/objects/bosses/fbz/s3/act2_subboss.s"
                include "src/objects/bosses/fbz/s3/end_boss.s"
                include "src/objects/bosses/icz/s3/miniboss.s"
                include "src/objects/bosses/icz/s3/miniboss_palette_script.s"
                include "src/objects/bosses/icz/s3/end_boss.s"
                include "src/objects/bosses/lbz/s3/miniboss.s"
                include "src/objects/bosses/lbz/final_boss_1/s3/battle_and_attacks.s"
                include "src/objects/bosses/lbz/final_boss_1/s3/motion_helpers.s"
                include "src/objects/bosses/lbz/final_boss_1/s3/object_catalog.s"
                include "src/objects/bosses/lbz/s3/end_boss.s"
                include "src/objects/bosses/lbz/final_boss_2/s3/battle_control.s"
                include "src/objects/bosses/lbz/final_boss_2/s3/attachments_and_effects.s"
                include "src/objects/bosses/lbz/final_boss_2/s3/defeat_and_ending.s"
                include "src/objects/bosses/lbz/s3/unused_robotnik.s"
                include "src/objects/bosses/lbz/final_boss_2/s3/motion_and_ending_helpers.s"
                include "src/objects/bosses/lbz/final_boss_2/s3/object_and_ending_catalog.s"
; ---------------------------------------------------------------------------

Obj_HiddenMonitor:
                lea     ObjDat_HiddenMonitor(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #Obj_HiddenMonitorMain,(a0)
                move.b  #$F,y_radius(a0)
                move.b  #$F,x_radius(a0)
                move.b  #$46,collision_flags(a0)
                move.b  subtype(a0),anim(a0)            ; Backup object subtype
                rts
; ---------------------------------------------------------------------------

Obj_HiddenMonitorMain:
                movea.w (Signpost_addr).w,a1
                cmpi.l  #Obj_EndSign,(a1)
                bne.s   loc_52360                       ; If no signpost is active, branch
                btst    #0,$38(a1)
                beq.s   loc_52360                       ; If signpost hasn't landed, branch
                lea     word_52392(pc),a2
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                add.w   (a2)+,d0
                cmp.w   d0,d1
                blo.s   loc_52352
                add.w   (a2)+,d0
                cmp.w   d0,d1
                bhs.s   loc_52352
                move.w  y_pos(a0),d0
                move.w  y_pos(a1),d1
                add.w   (a2)+,d0
                cmp.w   d0,d1
                blo.s   loc_52352
                add.w   (a2)+,d0
                cmp.w   d0,d1
                blo.s   loc_52366

loc_52352:
                moveq   #signextendB(sfx_GroundSlide),d0  ; If signpost has landed
                jsr     (Play_SFX).l
                move.l  #Sprite_OnScreen_Test,(a0)

loc_52360:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_52366:
                bclr    #0,$38(a1)                      ; If signpost has landed and is in range
                move.l  #Obj_Monitor,(a0)               ; make this object a monitor
                move.b  #2,routine(a0)
                move.b  #4,$3C(a0)
                move.w  #-$500,y_vel(a0)
                moveq   #signextendB(sfx_BubbleAttack),d0
                jsr     (Play_SFX).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
word_52392:
                dc.w    -$E,   $1C,  -$80,   $C0
ObjDat_HiddenMonitor:
                dc.l    Map_Monitor
                dc.w    make_art_tile(ArtTile_Monitors,0,0)
                dc.w    $180
                dc.b    $E, $10,   0,   0
; ---------------------------------------------------------------------------

Obj_EndSign:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  EndSign_Index(pc,d0.w),d1
                jsr     EndSign_Index(pc,d1.w)
                lea     PLCPtr_EndSigns(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
EndSign_Index:
                dc.w    Obj_EndSignInit-EndSign_Index
                dc.w    Obj_EndSignFall-EndSign_Index
                dc.w    Obj_EndSignLanded-EndSign_Index
                dc.w    Obj_EndSignResults-EndSign_Index
                dc.w    Obj_EndSignAfter-EndSign_Index
; ---------------------------------------------------------------------------

Obj_EndSignInit:
                lea     ObjSlot_EndSigns(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.w  a0,(Signpost_addr).w            ; Put RAM address here for use by hidden monitor object
                move.b  #$18,x_radius(a0)
                move.b  #$1E,y_radius(a0)
                move.l  #AniRaw_EndSigns,$30(a0)
                cmpi.b  #6,(Current_zone).w
                bne.s   loc_523FA
                move.w  #$3EC0,x_pos(a0)

loc_523FA:
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a0)                    ; Place vertical position at top of screen
                moveq   #signextendB(sfx_Signpost),d0
                jsr     (Play_SFX).l
                lea     Child1_EndSignStub(pc),a2       ; Make the little stub at the bottom of the signpost
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

Obj_EndSignFall:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   loc_52428
                lea     Child6_EndSignSparkle(pc),a2    ; Create a signpost sparkle every 4 frames
                jsr     CreateChild6_Simple(pc)

loc_52428:
                bsr.w   EndSign_CheckPlayerHit
                addi.w  #$C,y_vel(a0)
                jsr     (MoveSprite2).l                 ; Move downward
                bsr.w   EndSign_CheckWall
                jsr     Animate_Raw(pc)
                move.w  (Camera_Y_pos).w,d0
                cmpi.b  #6,(Current_zone).w
                bne.s   loc_52450
                addi.w  #$60,d0

loc_52450:
                cmp.w   y_pos(a0),d0
                bhi.s   locret_5247C                    ; Ensure that signpost can't land if too far up the screen itself
                tst.w   y_vel(a0)
                bmi.s   locret_5247C                    ; And also when the signpost is still moving up
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   locret_5247C
                add.w   d1,y_pos(a0)
                move.b  #4,routine(a0)                  ; If signpost has landed
                bset    #0,$38(a0)
                move.w  #$40,$2E(a0)

locret_5247C:
                rts
; ---------------------------------------------------------------------------

Obj_EndSignLanded:
                btst    #0,$38(a0)
                beq.s   loc_524AA
                jsr     Animate_Raw(pc)
                subq.w  #1,$2E(a0)                      ; Keep animating while landing for X amount of frames
                bmi.s   loc_52492
                rts
; ---------------------------------------------------------------------------

loc_52492:
                move.b  #6,routine(a0)
                moveq   #0,d0
                move.b  (Player_mode+1).w,d0            ; Get current character "mode"
                move.b  FrameArray_EndSign(pc,d0.w),mapping_frame(a0)
                st      (Ctrl_2_locked).w               ; Null Sonic's input
                rts
; ---------------------------------------------------------------------------

loc_524AA:
                move.b  #2,routine(a0)                  ; If a hidden monitor was hit, bounce ths signpost again
                move.b  #$20,$20(a0)
                move.w  #-$200,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
FrameArray_EndSign:
                dc.b    0,   0,   1,   2
                even
; ---------------------------------------------------------------------------

Obj_EndSignResults:
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   locret_524E6                    ; If player is not standing on the ground, wait until he is
                move.b  #8,routine(a0)
                jsr     Set_PlayerEndingPose(pc)
                jsr     (AllocateObject).l
                bne.s   locret_524E6
                move.l  #Obj_LevelResults,(a1)

locret_524E6:
                rts
; ---------------------------------------------------------------------------

Obj_EndSignAfter:
                move.w  x_pos(a0),d0                    ; Check for whether signpost goes out of range
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_52500
                jmp     (Check_TailsEndPose).l
; ---------------------------------------------------------------------------

loc_52500:
                lea     PLC_SpikesSprings(pc),a1
                jsr     (Load_PLC_Raw).l
                jsr     Remove_From_TrackingSlot(pc)
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------
PLC_SpikesSprings:  plrlistheader
                plreq   ArtTile_SpikesSprings, ArtNem_SpikesSprings
PLC_SpikesSprings_End:
; ---------------------------------------------------------------------------

Obj_SignpostSparkle:
                lea     ObjDat_SignpostSparkle(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #Obj_SignpostSparkleMain,(a0)
                jsr     (Random_Number).l
                andi.w  #$1F,d0
                subi.w  #$10,d0
                add.w   d0,y_pos(a0)                    ; Random vertical position
                move.w  x_pos(a0),$3A(a0)
                move.w  #$1000,x_vel(a0)
                move.w  #$20,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

Obj_SignpostSparkleMain:
                move.w  #$400,d0
                move.w  x_pos(a0),d1
                cmp.w   $3A(a0),d1
                blo.s   loc_52564
                neg.w   d0

loc_52564:
                move.w  #$80,d1
                add.w   d0,x_vel(a0)                    ; Do rotation around sign
                bpl.s   loc_52572
                move.w  #$180,d1

loc_52572:
                move.w  d1,priority(a0)
                jsr     (MoveSprite2).l
                lea     AniRaw_SignpostSparkle(pc),a1
                jsr     Animate_RawNoSST(pc)
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_SignpostStub:
                move.l  #Obj_SignpostStubMain,(a0)
                lea     ObjDat_SignpostStub(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

Obj_SignpostStubMain:
                jsr     Refresh_ChildPosition(pc)
                jmp     (Child_Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

EndSign_CheckPlayerHit:
                tst.b   $20(a0)
                bne.s   loc_5260E
                lea     EndSign_Range(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   locret_52612                    ; If neither player is in range, don't do anything
                tst.w   d0                              ; Is Sonic?
                beq.s   loc_525C0                       ; If it's not Sonic, branch

; Bug: After returning from the subroutine, the address of the characters in d0
; will be corrupted and the check will not work correctly
                bsr.w   sub_525C6

loc_525C0:
                swap    d0                              ; Get Tails address
                tst.w   d0                              ; Is Tails?
                beq.s   locret_52612                    ; If it's not Tails, branch
; End of function EndSign_CheckPlayerHit

; =============== S U B R O U T I N E =======================================

sub_525C6:
                movea.w d0,a1                           ; This can be done up to twice depending on who hit the signpost
                cmpi.b  #2,anim(a1)
                bne.s   locret_52612                    ; only go on if Player is currently jumping
                tst.w   y_vel(a1)
                bpl.s   locret_52612                    ; And if he's actually moving upwards
                move.b  #$20,$20(a0)                    ; Set delay for when it checks for the next hit
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bne.s   loc_525E8
                moveq   #8,d0

loc_525E8:
                lsl.w   #4,d0
                move.w  d0,x_vel(a0)                    ; Modify strength of X velocity based on how far to the left/right player is
                move.w  #-$200,y_vel(a0)                ; New vertical velocity is always the same
                moveq   #signextendB(sfx_Signpost),d0
                jsr     (Play_SFX).l
                lea     Child6_EndSignScore(pc),a2
                jsr     CreateChild6_Simple(pc)
                moveq   #10,d0
                movea.l a1,a3
                jmp     (HUD_AddToScore).l              ; Add 100 points whenever hit
; ---------------------------------------------------------------------------

loc_5260E:
                subq.b  #1,$20(a0)

locret_52612:
                rts
; End of function sub_525C6

; ---------------------------------------------------------------------------
EndSign_Range:
                dc.w    -$20,   $40,  -$18,   $30

; =============== S U B R O U T I N E =======================================

EndSign_CheckWall:
                move.w  (Camera_X_pos).w,d0
                tst.w   x_vel(a0)
                bmi.s   loc_5263E
                addi.w  #$128,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_52654
                moveq   #$20,d3
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   loc_52654
                rts
; ---------------------------------------------------------------------------

loc_5263E:
                addi.w  #$18,d0
                cmp.w   x_pos(a0),d0
                bhi.s   loc_52654
                moveq   #-$20,d3
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bpl.s   locret_52658

loc_52654:
                neg.w   x_vel(a0)

locret_52658:
                rts
; End of function EndSign_CheckWall

; ---------------------------------------------------------------------------
ObjSlot_EndSigns:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_EndSigns,0,0)
                dc.w    $C,     0
                dc.l    Map_EndSigns
                dc.w    $100
                dc.b    $18, $10,   0,   0
ObjDat_SignpostStub:
                dc.l    Map_SignpostStub
                dc.w    make_art_tile(ArtTile_SignpostStub,0,0)
                dc.w    $100
                dc.b    4,   8,   0,   0
ObjDat_SignpostSparkle:
                dc.l    Map_Ring
                dc.w    make_art_tile(ArtTile_Ring,1,0)
                dc.w    $80
                dc.b    8,   8,   4,   0
Child1_EndSignStub:
                dc.w    1-1
                dc.l    Obj_SignpostStub
                dc.b    0, $18
Child6_EndSignSparkle:
                dc.w    1-1
                dc.l    Obj_SignpostSparkle
Child6_EndSignScore:
                dc.w    1-1
                dc.l    Obj_EnemyScore
PLCPtr_EndSigns:
                dc.l    ArtUnc_EndSigns
                dc.l    DPLC_EndSigns
AniRaw_EndSigns:
                dc.b    1,   0,   4,   5,   6,   1,   4,   5,   6,   2,   4,   5,   6,   3,   4,   5,   6, $FC
AniRaw_SignpostSparkle:
                dc.b    1,   4,   5,   6,   7, $FC
                even

; =============== S U B R O U T I N E =======================================

AfterBoss_Cleanup:
                moveq   #0,d0
                lea     (Current_zone_and_act).w,a1
                move.b  (a1)+,d0
                add.b   d0,d0
                add.b   (a1)+,d0
                add.b   d0,d0
                move.w  AfterBoss_Index(pc,d0.w),d0
                jmp     AfterBoss_Index(pc,d0.w)
; End of function AfterBoss_Cleanup

; ---------------------------------------------------------------------------
AfterBoss_Index:
                dc.w    AfterBoss_AIZ1-AfterBoss_Index
                dc.w    AfterBoss_AIZ2-AfterBoss_Index
                dc.w    AfterBoss_HCZ-AfterBoss_Index
                dc.w    AfterBoss_HCZ-AfterBoss_Index
                dc.w    AfterBoss_MGZ-AfterBoss_Index
                dc.w    AfterBoss_MGZ-AfterBoss_Index
                dc.w    AfterBoss_CNZ-AfterBoss_Index
                dc.w    AfterBoss_CNZ-AfterBoss_Index
                dc.w    AfterBoss_FBZ-AfterBoss_Index
                dc.w    AfterBoss_FBZ-AfterBoss_Index
                dc.w    AfterBoss_ICZ1-AfterBoss_Index
                dc.w    AfterBoss_ICZ2-AfterBoss_Index
                dc.w    AfterBoss_LBZ-AfterBoss_Index
                dc.w    AfterBoss_LBZ-AfterBoss_Index
; ---------------------------------------------------------------------------

AfterBoss_AIZ1:
                lea     (Pal_AIZ).l,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($60),d0

                .loop:
                move.l  (a1)+,(a2)+
                dbf     d0,.loop
                rts
; ---------------------------------------------------------------------------

AfterBoss_AIZ2:
                lea     (Pal_AIZFire).l,a1
                jsr     (PalLoad_Line1).l
                lea     PLC_AfterMiniboss_AIZ(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

AfterBoss_HCZ:
                rts
; ---------------------------------------------------------------------------

AfterBoss_MGZ:
                lea     PLC_MonitorsSpikesSprings(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

AfterBoss_CNZ:
AfterBoss_FBZ:
AfterBoss_ICZ1:
                rts
; ---------------------------------------------------------------------------

AfterBoss_ICZ2:
                lea     (Pal_ICZ2).l,a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

AfterBoss_LBZ:
                rts
; ---------------------------------------------------------------------------
PLC_AfterMiniboss_AIZ:  plrlistheader
                plreq   ArtTile_Monitors, ArtNem_Monitors
                plreq   ArtTile_AIZMisc2, ArtNem_AIZMisc2
                plreq   ArtTile_AIZSwingVine, ArtNem_AIZSwingVine
                plreq   ArtTile_AIZBackgroundTree, ArtNem_AIZBackgroundTree
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
                plreq   ArtTile_GrayButton, ArtNem_GrayButton
                plreq   ArtTile_AIZ2FloatingPlatform, ArtNem_AIZCorkFloor2
PLC_AfterMiniboss_AIZ_End:

Pal_AfterMiniboss_AIZ:
                binclude "data/Levels/AIZ/Palettes/Miniboss After.bin"
                even
Pal_AfterMiniboss_ICZ:
                binclude "data/Levels/ICZ/Palettes/Miniboss After.bin"
                even
PLC_MonitorsSpikesSprings:  plrlistheader
                plreq   ArtTile_Monitors, ArtNem_Monitors
                plreq   ArtTile_SpikesSprings, ArtNem_SpikesSprings
PLC_MonitorsSpikesSprings_End:

PLC_Monitors:   plrlistheader
                plreq   ArtTile_Monitors, ArtNem_Monitors
PLC_Monitors_End:

PLC_AnimalsAndExplosion:    plrlistheader               ; unused
                plreq   ArtTile_Explosion, ArtNem_Explosion
                plreq   ArtTile_Animals1, ArtNem_Squirrel
                plreq   ArtTile_Animals2, ArtNem_BlueFlicky
PLC_AnimalsAndExplosion_End:

PLC_BossExplosion:  plrlistheader
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_BossExplosion_End:

PLC_Explosion:  plrlistheader
                plreq   ArtTile_Explosion, ArtNem_Explosion
PLC_Explosion_End:

PLC_EggCapsule: plrlistheader
                plreq   ArtTile_EggCapsule, ArtNem_EggCapsule
PLC_EggCapsule_End:
; ---------------------------------------------------------------------------

Obj_CreateBossExplosion:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CreateBossExplosion_Index(pc,d0.w),d1
                jmp     CreateBossExplosion_Index(pc,d1.w)
; ---------------------------------------------------------------------------
CreateBossExplosion_Index:
                dc.w    Obj_BossExpControl-CreateBossExplosion_Index
                dc.w    loc_5281C-CreateBossExplosion_Index
                dc.w    Obj_WaitForParent-CreateBossExplosion_Index

; =============== S U B R O U T I N E =======================================

Obj_BossExpControl:
                lea     ObjDat_BossExplosion(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #Obj_NormalExpControl,$34(a0)
                cmpi.b  #8,subtype(a0)
                bne.s   loc_52812
                move.l  #loc_5289A,$34(a0)

loc_52812:
                move.w  #3-1,$2E(a0)
                bra.w   loc_528BA
; ---------------------------------------------------------------------------

loc_5281C:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_WaitForParent:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.w   loc_52896
                tst.l   (a1)
                beq.w   loc_52896
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_NormalExpControl:
                subq.b  #1,$39(a0)
                bmi.s   loc_52896
                move.w  #3-1,$2E(a0)
; End of function Obj_BossExpControl

; =============== S U B R O U T I N E =======================================

sub_52850:
                moveq   #signextendB(sfx_Explode),d0
                jsr     (Play_SFX).l
                lea     Child1_MakeBossExplosion(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.w   locret_5293E

loc_52864:
                jsr     (Random_Number).l               ; Offset the explosion by a random amount capped by an effective range
                moveq   #0,d1
                move.b  $3A(a0),d1
                move.w  d1,d2
                add.w   d2,d2
                subq.w  #1,d2
                and.w   d2,d0
                sub.w   d1,d0
                add.w   d0,x_pos(a1)
                swap    d0
                moveq   #0,d1
                move.b  $3B(a0),d1
                move.w  d1,d2
                add.w   d2,d2
                subq.w  #1,d2
                and.w   d2,d0
                sub.w   d1,d0
                add.w   d0,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

loc_52896:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

loc_5289A:
                subq.b  #1,$39(a0)                      ; Same as above, but uses regular explosions (no animals of course)
                bmi.s   loc_52896
                move.w  #2,$2E(a0)
                lea     Child1_MakeNormalExplosion(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.w   locret_5293E
                move.b  #2,routine(a1)
                bra.s   loc_52864
; ---------------------------------------------------------------------------

loc_528BA:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     CreateBossExpParameterIndex(pc),a1
                adda.w  (a1,d0.w),a1
                move.b  (a1)+,$39(a0)
                move.b  (a1)+,$3A(a0)
                move.b  (a1)+,$3B(a0)
                move.b  (a1)+,routine(a0)
                rts
; ---------------------------------------------------------------------------
CreateBossExpParameterIndex:
                dc.w    CreateBossExp00-CreateBossExpParameterIndex
                dc.w    CreateBossExp02-CreateBossExpParameterIndex
                dc.w    CreateBossExp04-CreateBossExpParameterIndex
                dc.w    CreateBossExp06-CreateBossExpParameterIndex
                dc.w    CreateBossExp08-CreateBossExpParameterIndex
                dc.w    CreateBossExp0A-CreateBossExpParameterIndex
                dc.w    CreateBossExp0C-CreateBossExpParameterIndex
CreateBossExp00:    dc.b    $20, $20, $20,   2
CreateBossExp02:    dc.b    $28, $80, $80,   2
CreateBossExp04:    dc.b    $80, $20, $20,   4
CreateBossExp06:    dc.b    4,   8,   8,   2
CreateBossExp08:    dc.b    8, $20, $20,   2
CreateBossExp0A:    dc.b    $20, $20, $20,   2
CreateBossExp0C:    dc.b    $40, $80, $20,   2
; ---------------------------------------------------------------------------

Obj_BossExplosionSpecial:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  BossExplosionSpecial_Index(pc,d0.w),d1
                jmp     BossExplosionSpecial_Index(pc,d1.w)
; ---------------------------------------------------------------------------
BossExplosionSpecial_Index:
                dc.w    loc_52916-BossExplosionSpecial_Index
                dc.w    loc_5281C-BossExplosionSpecial_Index
; ---------------------------------------------------------------------------

loc_52916:
                move.b  #2,subtype(a0)
                bsr.w   Obj_BossExpControl
                move.w  #2,$2E(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #320/2,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #224/2,d0
                move.w  d0,y_pos(a0)

locret_5293E:
                rts
; End of function sub_52850

; ---------------------------------------------------------------------------

Obj_BossExplosion:
                lea     ObjDat_BossExplosion(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                tst.b   (Current_zone).w
                bne.s   loc_52954
                move.w  #make_art_tile(ArtTile_BossExplosion2,0,1),art_tile(a0)

loc_52954:
                move.l  #Obj_BossExplosionAnim,(a0)
                move.l  #AniRaw_BossExplosion,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

Obj_BossExplosionAnim:
                jsr     Animate_RawMultiDelay(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_BossExplosion:
                dc.l    Map_BossExplosion
                dc.w    make_art_tile(ArtTile_BossExplosion,0,1)
                dc.w    0
                dc.b    $C,  $C,   0,   0
AniRaw_BossExplosion:
                dc.b    0,   0,   0,   1,   1,   1,   2,   2,   3,   3,   4,   4,   5,   4, $F4
                even
Child1_MakeBossExplosion:
                dc.w    1-1
                dc.l    Obj_BossExplosion
                dc.b    0,   0
Child6_CreateBossExplosion:
                dc.w    1-1
                dc.l    Obj_CreateBossExplosion
                dc.b    0,   0
Child1_MakeNormalExplosion:
                dc.w    1-1
                dc.l    Obj_Explosion
                dc.b    0,   0

; =============== S U B R O U T I N E =======================================

SetUp_ObjAttributes:
                move.l  (a1)+,mappings(a0)              ; Mappings location

SetUp_ObjAttributes2:
                move.w  (a1)+,art_tile(a0)              ; VRAM offset

SetUp_ObjAttributes3:
                move.w  (a1)+,priority(a0)              ; Priority
                move.b  (a1)+,width_pixels(a0)          ; Width
                move.b  (a1)+,height_pixels(a0)         ; Height
                move.b  (a1)+,mapping_frame(a0)         ; Mappings frame
                move.b  (a1)+,collision_flags(a0)       ; Collision Number
                bset    #2,render_flags(a0)             ; Object uses world coordinates
                addq.b  #2,routine(a0)                  ; Increase routine counter

locret_529CE:
                rts
; End of function SetUp_ObjAttributes

; =============== S U B R O U T I N E =======================================

CreateChild1_Normal:
                moveq   #0,d2                           ; Includes positional offset data
                move.w  (a2)+,d6

                .loop:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   .end
                move.w  a0,parent3(a1)                  ; Parent RAM address into $46
                move.l  mappings(a0),mappings(a1)
                move.l  art_tile(a0),art_tile(a1)       ; Mappings and VRAM offset copied from parent object
                move.l  (a2)+,(a1)                      ; Object address
                move.b  d2,subtype(a1)                  ; Index of child object (done sequentially for each object)
                move.w  x_pos(a0),d0
                move.b  (a2)+,d1                        ; X Positional offset
                move.b  d1,child_dx(a1)                 ; $42 has the X offset
                ext.w   d1
                add.w   d1,d0
                move.w  d0,x_pos(a1)                    ; Apply offset to new position
                move.w  y_pos(a0),d0
                move.b  (a2)+,d1                        ; Same as above for Y
                move.b  d1,child_dy(a1)                 ; $43 has the Y offset
                ext.w   d1
                add.w   d1,d0
                move.w  d0,y_pos(a1)                    ; Apply offset
                addq.w  #2,d2                           ; Add 2 to index
                dbf     d6,.loop                        ; Loop
                moveq   #0,d0

                .end:
                rts
; End of function CreateChild1_Normal

; =============== S U B R O U T I N E =======================================

CreateChild2_Complex:
                moveq   #0,d2                           ; Includes positional offset data, velocity, and a few pointers
                move.w  (a2)+,d6

                .loop:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   .end
                move.w  a0,parent3(a1)                  ; Parent RAM address into $46
                move.l  mappings(a0),mappings(a1)
                move.l  art_tile(a0),art_tile(a1)       ; Mappings and VRAM offset copied from parent object
                move.l  (a2)+,(a1)                      ; Object address
                move.l  (a2)+,$3E(a1)                   ; Object data (to be read by SetUp_ObjAttributes)
                move.l  (a2)+,$30(a1)                   ; Raw animation pointer
                move.l  (a2)+,$34(a1)                   ; Next routine
                move.b  d2,subtype(a1)
                move.w  x_pos(a0),d0
                move.b  (a2)+,d1
                move.b  d1,child_dx(a1)                 ; See offset information above
                ext.w   d1
                add.w   d1,d0
                move.w  d0,x_pos(a1)
                move.w  y_pos(a0),d0
                move.b  (a2)+,d1
                move.b  d1,child_dy(a1)                 ; See offset information above
                ext.w   d1
                add.w   d1,d0
                move.w  d0,y_pos(a1)
                move.w  (a2)+,x_vel(a1)                 ; X velocity
                move.w  (a2)+,y_vel(a1)                 ; Y velocity
                addq.w  #2,d2
                dbf     d6,.loop
                moveq   #0,d0

                .end:
                rts
; End of function CreateChild2_Complex

; =============== S U B R O U T I N E =======================================

CreateChild3_NormalRepeated:
                moveq   #0,d2                           ; Same as Child creation routine 1, except it repeats one object several times rather than different objects sequentially
                move.w  (a2)+,d6

                .loop:
                movea.l a2,a3
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   .end
                move.w  a0,parent3(a1)
                move.l  mappings(a0),mappings(a1)
                move.l  art_tile(a0),art_tile(a1)
                move.l  (a3)+,(a1)
                move.b  d2,subtype(a1)
                move.w  x_pos(a0),d0
                move.b  (a3)+,d1
                move.b  d1,child_dx(a1)
                ext.w   d1
                add.w   d1,d0
                move.w  d0,x_pos(a1)
                move.w  y_pos(a0),d0
                move.b  (a3)+,d1
                move.b  d1,child_dy(a1)
                ext.w   d1
                add.w   d1,d0
                move.w  d0,y_pos(a1)
                addq.w  #2,d2
                dbf     d6,.loop
                moveq   #0,d0

                .end:
                rts
; End of function CreateChild3_NormalRepeated

; =============== S U B R O U T I N E =======================================

CreateChild4_LinkListRepeated:
                movea.l a0,a3                           ; Creates a linked object list. Previous object address is in $46, while next object in list is at $44
                moveq   #0,d2
                move.w  (a2)+,d6

                .loop:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   .end
                move.w  a3,parent3(a1)
                move.w  a1,$44(a3)
                movea.l a1,a3
                move.l  mappings(a0),mappings(a1)
                move.l  art_tile(a0),art_tile(a1)
                move.l  (a2),(a1)
                move.b  d2,subtype(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addq.w  #2,d2
                dbf     d6,.loop
                moveq   #0,d0

                .end:
                rts
; End of function CreateChild4_LinkListRepeated

; =============== S U B R O U T I N E =======================================

CreateChild5_ComplexAdjusted:
                moveq   #0,d2                           ; Same as child routine 2, but adjusts both X position and X velocity based on parent object's orientation
                move.w  (a2)+,d6

                .loop:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   .end
                move.w  a0,parent3(a1)
                move.l  mappings(a0),mappings(a1)
                move.l  art_tile(a0),art_tile(a1)
                move.l  (a2)+,(a1)
                move.l  (a2)+,$3E(a1)
                move.l  (a2)+,$30(a1)
                move.l  (a2)+,$34(a1)
                move.b  d2,subtype(a1)
                move.w  x_pos(a0),d0
                move.b  (a2)+,d1
                move.b  d1,child_dx(a1)
                ext.w   d1
                btst    #0,render_flags(a0)
                beq.s   .noflip
                neg.w   d1

                .noflip:
                add.w   d1,d0
                move.w  d0,x_pos(a1)
                move.w  y_pos(a0),d0
                move.b  (a2)+,d1
                move.b  d1,child_dy(a1)
                ext.w   d1
                add.w   d1,d0
                move.w  d0,y_pos(a1)
                move.w  (a2)+,d1
                btst    #0,render_flags(a0)
                beq.s   .noflip2
                neg.w   d1

                .noflip2:
                move.w  d1,x_vel(a1)
                move.w  (a2)+,y_vel(a1)
                addq.w  #2,d2
                dbf     d6,.loop
                moveq   #0,d0

                .end:
                rts
; End of function CreateChild5_ComplexAdjusted

; =============== S U B R O U T I N E =======================================

CreateChild6_Simple:
                moveq   #0,d2                           ; Simple child creation routine, merely creates x number of the same object at the parent's position
                move.w  (a2)+,d6

                .loop:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   .end
                move.w  a0,parent3(a1)
                move.l  (a2),(a1)
                move.b  d2,subtype(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addq.w  #2,d2
                dbf     d6,.loop
                moveq   #0,d0

                .end:
                rts
; End of function CreateChild6_Simple

; =============== S U B R O U T I N E =======================================

CreateChild7_Normal2:
                moveq   #0,d2                           ; Same as child routine 1, but does not limit children to object slots after the parent
                move.w  (a2)+,d6

                .loop:
                jsr     (AllocateObject).l
                bne.s   .end
                move.w  a0,parent3(a1)
                move.l  mappings(a0),mappings(a1)
                move.l  art_tile(a0),art_tile(a1)
                move.l  (a2)+,(a1)
                move.b  d2,subtype(a1)
                move.w  x_pos(a0),d0
                move.b  (a2)+,d1
                move.b  d1,child_dx(a1)
                ext.w   d1
                add.w   d1,d0
                move.w  d0,x_pos(a1)
                move.w  y_pos(a0),d0
                move.b  (a2)+,d1
                move.b  d1,child_dy(a1)
                ext.w   d1
                add.w   d1,d0
                move.w  d0,y_pos(a1)
                addq.w  #2,d2
                dbf     d6,.loop
                moveq   #0,d0

                .end:
                rts
; End of function CreateChild7_Normal2

; =============== S U B R O U T I N E =======================================

CreateChild8_TreeListRepeated:
                movea.l a0,a3                           ; Creates a linked object list like routine 4, but they only chain themselves one way. All maintain the calling object as their parent
                moveq   #0,d2
                move.w  (a2)+,d6

                .loop:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   .end
                move.w  a3,parent3(a1)
                move.w  a0,$44(a1)
                movea.l a1,a3
                move.l  mappings(a0),mappings(a1)
                move.l  art_tile(a0),art_tile(a1)
                move.l  (a2),(a1)
                move.b  d2,subtype(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addq.w  #2,d2
                dbf     d6,.loop
                moveq   #0,d0

                .end:
                rts
; End of function CreateChild8_TreeListRepeated

; =============== S U B R O U T I N E =======================================

Refresh_ChildPosition:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                move.b  child_dx(a0),d1
                ext.w   d1
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                add.w   d1,d0
                move.w  d0,y_pos(a0)
                rts
; End of function Refresh_ChildPosition

; =============== S U B R O U T I N E =======================================

Refresh_ChildPositionAdjusted:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                move.b  child_dx(a0),d1
                ext.w   d1
                bclr    #0,render_flags(a0)
                btst    #0,render_flags(a1)
                beq.s   loc_52C96
                neg.w   d1
                bset    #0,render_flags(a0)

loc_52C96:
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                bclr    #1,render_flags(a0)
                btst    #1,render_flags(a1)
                beq.s   loc_52CBC
                neg.w   d1
                bset    #1,render_flags(a0)

loc_52CBC:
                add.w   d1,d0
                move.w  d0,y_pos(a0)
                rts
; End of function Refresh_ChildPositionAdjusted

; =============== S U B R O U T I N E =======================================

Animate_Raw:
                movea.l $30(a0),a1
; End of function Animate_Raw

; =============== S U B R O U T I N E =======================================

Animate_RawNoSST:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_52CEA
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.s   loc_52CEC
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

locret_52CEA:
                rts
; ---------------------------------------------------------------------------

loc_52CEC:
                neg.b   d1
                jsr     off_52CF8-4(pc,d1.w)
                clr.b   anim_frame(a0)
                rts
; End of function Animate_RawNoSST

off_52CF8:
                bra.w   AnimateRaw_Restart              ; FC
; ---------------------------------------------------------------------------
                bra.w   AnimateRaw_Jump                 ; F8
; ---------------------------------------------------------------------------
                bra.w   AnimateRaw_CustomCode           ; F4
; ---------------------------------------------------------------------------

AnimateRaw_Jump:
                move.b  2(a1,d0.w),d1
                ext.w   d1
                lea     (a1,d1.w),a1
                move.l  a1,$30(a0)

AnimateRaw_Restart:
                move.b  1(a1),mapping_frame(a0)
                move.b  (a1),anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

AnimateRaw_CustomCode:
                clr.b   anim_frame_timer(a0)
                movea.l $34(a0),a1
                jmp     (a1)

; =============== S U B R O U T I N E =======================================

Animate_RawAdjustFlipX:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_52D5A
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.s   loc_52CEC
                bclr    #6,d1
                beq.s   loc_52D52
                bchg    #0,render_flags(a0)

loc_52D52:
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

locret_52D5A:
                rts
; End of function Animate_RawAdjustFlipX

; ---------------------------------------------------------------------------

Animate_RawAdjustFlipY:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_52D90
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  1(a1,d0.w),d1
                bmi.w   loc_52CEC
                bclr    #6,d1
                beq.s   loc_52D88
                bchg    #1,render_flags(a0)

loc_52D88:
                move.b  (a1),anim_frame_timer(a0)
                move.b  d1,mapping_frame(a0)

locret_52D90:
                rts

; =============== S U B R O U T I N E =======================================

Animate_RawMultiDelay:
                movea.l $30(a0),a1

Animate_RawNoSSTMultiDelay:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_52DBE
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.s   loc_52DC2
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

loc_52DBE:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

loc_52DC2:
                neg.b   d1
                jsr     off_52DCE-4(pc,d1.w)
                clr.b   anim_frame(a0)
                rts
; End of function Animate_RawMultiDelay

off_52DCE:
                bra.w   loc_52DE8
; ---------------------------------------------------------------------------
                bra.w   loc_52DDA
; ---------------------------------------------------------------------------
                bra.w   loc_52DF6
; ---------------------------------------------------------------------------

loc_52DDA:
                move.b  1(a1,d0.w),d1
                ext.w   d1
                lea     (a1,d1.w),a1
                move.l  a1,$30(a0)

loc_52DE8:
                move.b  (a1),mapping_frame(a0)
                move.b  1(a1),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

loc_52DF6:
                clr.b   anim_frame_timer(a0)
                movea.l $34(a0),a1
                jsr     (a1)
                moveq   #-1,d2
                rts

; =============== S U B R O U T I N E =======================================

Animate_RawMultiDelayFlipX:
                movea.l $30(a0),a1

Animate_RawNoSSTMultiDelayFlipX:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_52E3C
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.s   loc_52DC2
                bclr    #6,d1
                beq.s   loc_52E2E
                bchg    #0,render_flags(a0)

loc_52E2E:
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

loc_52E3C:
                moveq   #0,d2
                rts
; End of function Animate_RawMultiDelayFlipX

; =============== S U B R O U T I N E =======================================

Animate_RawMultiDelayFlipY:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_52E7A
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                bmi.w   loc_52DC2
                bclr    #6,d1
                beq.s   loc_52E6C
                bchg    #1,render_flags(a0)

loc_52E6C:
                move.b  d1,mapping_frame(a0)
                move.b  1(a1,d0.w),anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

loc_52E7A:
                moveq   #0,d2
                rts
; End of function Animate_RawMultiDelayFlipY

; =============== S U B R O U T I N E =======================================

Animate_RawGetFaster:
                movea.l $30(a0),a1
                bset    #5,$38(a0)
                bne.s   loc_52E92
                move.b  (a1),$2E(a0)
                clr.b   $2F(a0)

loc_52E92:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_52ECA
                move.b  $2E(a0),d2
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,d0
                move.b  2(a1,d0.w),d1
                bpl.s   loc_52EBA
                moveq   #0,d0
                move.b  2(a1),d1
                tst.b   d2
                beq.s   loc_52ECE
                subq.b  #1,d2
                move.b  d2,$2E(a0)

loc_52EBA:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                moveq   #1,d2
                rts
; ---------------------------------------------------------------------------

loc_52ECA:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

loc_52ECE:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                move.b  $2F(a0),d0
                addq.b  #1,d0
                move.b  d0,$2F(a0)
                cmp.b   1(a1),d0
                blo.s   loc_52EFA
                bclr    #5,$38(a0)
                clr.b   $2F(a0)
                movea.l $34(a0),a2
                jsr     (a2)

loc_52EFA:
                moveq   #-1,d2
                rts
; End of function Animate_RawGetFaster

; ---------------------------------------------------------------------------

Animate_RawGetSlower:
                movea.l $30(a0),a1
                bset    #5,$38(a0)
                bne.s   loc_52F0E
                clr.w   $2E(a0)

loc_52F0E:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_52F42
                move.b  $2E(a0),d2
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,d0
                move.b  1(a1,d0.w),d1
                bpl.s   loc_52F2E
                moveq   #0,d0
                move.b  1(a1),d1
                addq.b  #1,d2

loc_52F2E:
                move.b  d0,anim_frame(a0)
                move.b  d1,mapping_frame(a0)
                move.b  d2,anim_frame_timer(a0)
                cmp.b   (a1),d2
                bhs.s   loc_52F44
                move.b  d2,$2E(a0)

locret_52F42:
                rts
; ---------------------------------------------------------------------------

loc_52F44:
                move.b  $2F(a0),d0
                addq.b  #1,d0
                move.b  d0,$2F(a0)
                cmp.b   1(a1),d0
                blo.s   locret_52F42
                bclr    #5,$38(a0)
                clr.b   $2F(a0)
                movea.l $34(a0),a2
                jmp     (a2)

; =============== S U B R O U T I N E =======================================

Swing_UpAndDown:
                move.w  $40(a0),d0                      ; Acceleration
                move.w  y_vel(a0),d1                    ; Velocity
                move.w  $3E(a0),d2                      ; Maximum acceleration before "swinging"
                moveq   #0,d3
                btst    #0,$38(a0)
                bne.s   loc_52F90
                neg.w   d0                              ; Apply upward acceleration
                add.w   d0,d1
                neg.w   d2
                cmp.w   d2,d1
                bgt.s   loc_52FA2
                bset    #0,$38(a0)
                neg.w   d0
                neg.w   d2
                moveq   #1,d3

loc_52F90:
                add.w   d0,d1                           ; Apply downward acceleration
                cmp.w   d2,d1
                blt.s   loc_52FA2
                bclr    #0,$38(a0)
                neg.w   d0
                add.w   d0,d1
                moveq   #1,d3

loc_52FA2:
                move.w  d1,y_vel(a0)
                rts
; End of function Swing_UpAndDown

; =============== S U B R O U T I N E =======================================

Swing_LeftAndRight:
                move.w  $3C(a0),d0
                move.w  x_vel(a0),d1
                move.w  $3A(a0),d2
                moveq   #0,d3
                btst    #3,$38(a0)
                bne.s   loc_52FD4
                neg.w   d0
                add.w   d0,d1
                neg.w   d2
                cmp.w   d2,d1
                bgt.s   loc_52FE6
                bset    #3,$38(a0)
                neg.w   d0
                neg.w   d2
                moveq   #1,d3

loc_52FD4:
                add.w   d0,d1
                cmp.w   d2,d1
                blt.s   loc_52FE6
                bclr    #3,$38(a0)
                neg.w   d0
                add.w   d0,d1
                moveq   #1,d3

loc_52FE6:
                move.w  d1,x_vel(a0)
                rts
; End of function Swing_LeftAndRight

; =============== S U B R O U T I N E =======================================

Swing_UpAndDown_Count:
                bsr.w   Swing_UpAndDown
                tst.w   d3
                beq.s   locret_53006
                move.b  $39(a0),d2
                subq.b  #1,d2
                move.b  d2,$39(a0)
                bmi.s   loc_53004
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

loc_53004:
                moveq   #1,d0

locret_53006:
                rts
; End of function Swing_UpAndDown_Count

; =============== S U B R O U T I N E =======================================

Obj_Wait:
                subq.w  #1,$2E(a0)
                bmi.s   loc_53010
                rts
; ---------------------------------------------------------------------------

loc_53010:
                movea.l $34(a0),a1
                jmp     (a1)
; End of function Obj_Wait

; =============== S U B R O U T I N E =======================================

ObjHitFloor_DoRoutine:
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_53024
                beq.s   loc_53024
                rts
; ---------------------------------------------------------------------------

loc_53024:
                add.w   d1,y_pos(a0)
                movea.l $34(a0),a1
                jmp     (a1)
; End of function ObjHitFloor_DoRoutine

; =============== S U B R O U T I N E =======================================

ObjHitFloor2_DoRoutine:
                move.w  x_vel(a0),d3
                ext.l   d3
                lsl.l   #8,d3
                add.l   x_pos(a0),d3
                swap    d3
                jsr     (ObjCheckFloorDist2).l
                cmpi.w  #-1,d1
                blt.s   loc_53054
                cmpi.w  #$C,d1
                bge.s   loc_53054
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_53054:
                movea.l $34(a0),a1
                jmp     (a1)
; End of function ObjHitFloor2_DoRoutine

; =============== S U B R O U T I N E =======================================

ObjHitWall_DoRoutine:
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   loc_53066
                rts
; ---------------------------------------------------------------------------

loc_53066:
                add.w   d1,x_pos(a0)
                movea.l $34(a0),a1
                jmp     (a1)
; End of function ObjHitWall_DoRoutine

; ---------------------------------------------------------------------------

ObjHitWall2_DoRoutine:
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bmi.s   loc_5307C
                rts
; ---------------------------------------------------------------------------

loc_5307C:
                add.w   d1,x_pos(a0)
                movea.l $34(a0),a1
                jmp     (a1)
; ---------------------------------------------------------------------------

Draw_And_Touch_Sprite:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_Draw_Sprite:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_530A4
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_530A4:
                bra.w   Go_Delete_Sprite
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_530C0
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_530C0:
                bra.w   Go_Delete_Sprite
; ---------------------------------------------------------------------------

Child_Remember_Draw_Sprite:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_530D6
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_530D6:
                bsr.w   Remove_From_TrackingSlot
                bra.w   Go_Delete_Sprite
; ---------------------------------------------------------------------------

Child_Draw_Sprite2:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_530F0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_530F0:
                bra.w   Go_Delete_Sprite_2
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite2:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_53114
                btst    #7,status(a1)
                bne.s   loc_5310E
                jsr     (Add_SpriteToCollisionResponseList).l

loc_5310E:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_53114:
                bra.w   Go_Delete_Sprite_2
; ---------------------------------------------------------------------------

Child_Draw_Sprite_FlickerMove:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_5312A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5312A:
                bset    #7,status(a0)
                move.l  #Obj_FlickerMove,(a0)
                clr.b   collision_flags(a0)
                bsr.w   Set_IndexedVelocity
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_Draw_Sprite2_FlickerMove:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_5312A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite_FlickerMove:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_5312A
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite2_FlickerMove:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_5312A
                btst    #7,status(a1)
                beq.s   loc_5318E
                bset    #7,status(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5318E:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_IncLevEndXGradual:
                move.w  (Camera_max_X_pos).w,d0
                move.l  $30(a0),d1
                addi.l  #$4000,d1
                move.l  d1,$30(a0)
                swap    d1
                add.w   d1,d0
                cmp.w   (Camera_stored_max_X_pos).w,d0
                bhs.s   loc_531BC
                move.w  d0,(Camera_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_531BC:
                move.w  (Camera_stored_max_X_pos).w,(Camera_max_X_pos).w

loc_531C2:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_DecLevStartXGradual:
                move.w  (Camera_min_X_pos).w,d0
                move.l  $30(a0),d1
                addi.l  #$4000,d1
                move.l  d1,$30(a0)
                swap    d1
                sub.w   d1,d0
                cmp.w   (Camera_stored_min_X_pos).w,d0
                ble.s   loc_531EA
                move.w  d0,(Camera_min_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_531EA:
                move.w  (Camera_stored_min_X_pos).w,(Camera_min_X_pos).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_DecLevStartYGradual:
                move.w  (Camera_min_Y_pos).w,d0
                move.l  $30(a0),d1
                addi.l  #$4000,d1
                move.l  d1,$30(a0)
                swap    d1
                sub.w   d1,d0
                cmp.w   (Camera_stored_min_Y_pos).w,d0
                ble.s   loc_53218
                move.w  d0,(Camera_min_Y_pos).w
                rts
; ---------------------------------------------------------------------------

loc_53218:
                move.w  (Camera_stored_min_Y_pos).w,(Camera_min_Y_pos).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_IncLevEndYGradual:
                move.w  (Camera_max_Y_pos).w,d0
                move.l  $30(a0),d1
                addi.l  #$8000,d1
                move.l  d1,$30(a0)
                swap    d1
                add.w   d1,d0
                cmp.w   (Camera_stored_max_Y_pos).w,d0
                bgt.s   loc_53246
                move.w  d0,(Camera_max_Y_pos).w
                rts
; ---------------------------------------------------------------------------

loc_53246:
                move.w  (Camera_stored_max_Y_pos).w,(Camera_max_Y_pos).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Child6_IncLevX:
                dc.w    1-1
                dc.l    Obj_IncLevEndXGradual
Child6_DecLevX:
                dc.w    1-1
                dc.l    Obj_DecLevStartXGradual
Child6_DecLevY:
                dc.w    1-1
                dc.l    Obj_DecLevStartYGradual
Child6_IncLevY:
                dc.w    1-1
                dc.l    Obj_IncLevEndYGradual

; =============== S U B R O U T I N E =======================================

Find_SonicTails:
                moveq   #0,d0                           ; d0 = 0 if Sonic/Tails is left of object, 2 if right of object
                moveq   #0,d1                           ; d1 = 0 if Sonic/Tails is above object, 2 if below object
                lea     (Player_1).w,a1
                move.w  x_pos(a0),d2
                sub.w   x_pos(a1),d2
                bpl.s   loc_53280
                neg.w   d2
                addq.w  #2,d0

loc_53280:
                lea     (Player_2).w,a2
                move.w  x_pos(a0),d3
                sub.w   x_pos(a2),d3
                bpl.s   loc_53292
                neg.w   d3
                addq.w  #2,d1

loc_53292:
                cmp.w   d3,d2
                bls.s   loc_5329C
                movea.l a2,a1
                move.w  d1,d0
                move.w  d3,d2

loc_5329C:
                moveq   #0,d1
                move.w  y_pos(a0),d3
                sub.w   y_pos(a1),d3
                bpl.s   locret_532AC
                neg.w   d3
                addq.w  #2,d1

locret_532AC:
                rts
; End of function Find_SonicTails

; =============== S U B R O U T I N E =======================================

Change_FlipX:
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   .return
                bset    #0,render_flags(a0)

                .return:
                rts
; End of function Change_FlipX

; =============== S U B R O U T I N E =======================================

Change_FlipXWithVelocity:
                bclr    #0,render_flags(a0)
                tst.w   x_vel(a0)
                bmi.s   .return
                bset    #0,render_flags(a0)

                .return:
                rts
; End of function Change_FlipXWithVelocity

; =============== S U B R O U T I N E =======================================

Change_FlipXUseParent:
                bclr    #0,render_flags(a0)
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   .return
                bset    #0,render_flags(a0)

                .return:
                rts
; End of function Change_FlipXUseParent

; =============== S U B R O U T I N E =======================================

Find_OtherObject:
                moveq   #0,d0                           ; d0 = 0 if other object is left of calling object, 2 if right of it
                moveq   #0,d1                           ; d1 = 0 if other object is above calling object, 2 if below it
                move.w  x_pos(a0),d2
                sub.w   x_pos(a1),d2
                bpl.s   loc_53300
                neg.w   d2
                addq.w  #2,d0

loc_53300:
                moveq   #0,d1
                move.w  y_pos(a0),d3
                sub.w   y_pos(a1),d3
                bpl.s   locret_53310
                neg.w   d3
                addq.w  #2,d1

locret_53310:
                rts
; End of function Find_OtherObject

; =============== S U B R O U T I N E =======================================

MoveSprite_LightGravity:
                moveq   #$20,d1
                move.w  x_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a0)
                move.w  y_vel(a0),d0
                add.w   d1,y_vel(a0)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a0)
                rts
; End of function MoveSprite_LightGravity

; =============== S U B R O U T I N E =======================================

MoveSprite_CircularSimple:
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                asr.w   d2,d0
                asr.w   d2,d1
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                add.w   d0,d2
                add.w   d1,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                rts
; End of function MoveSprite_CircularSimple

; =============== S U B R O U T I N E =======================================

MoveSprite_CircularSimpleOffset:
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                asr.w   d2,d0
                asr.w   d2,d1
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                move.b  child_dx(a0),d4
                ext.w   d4
                add.w   d4,d2
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d3
                add.w   d0,d2
                add.w   d1,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                rts
; End of function MoveSprite_CircularSimpleOffset

; =============== S U B R O U T I N E =======================================

MoveSprite_AtAngleLookup:
                moveq   #0,d0
                move.b  $3C(a0),d0
                move.w  d0,d1
                andi.w  #$3F,d0
                lsr.w   #5,d1
                andi.w  #6,d1
                movea.w parent3(a0),a1
                lea     $40(a2),a3
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                move.w  d0,d4
                not.w   d4
                move.w  AtAngle_LookupIndex(pc,d1.w),d1
                jsr     AtAngle_LookupIndex(pc,d1.w)
                add.w   d5,d2
                add.w   d6,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                rts
; End of function MoveSprite_AtAngleLookup

; ---------------------------------------------------------------------------
AtAngle_LookupIndex:
                dc.w    AtAngle_00_3F-AtAngle_LookupIndex
                dc.w    AtAngle_40_7F-AtAngle_LookupIndex
                dc.w    AtAngle_80_BF-AtAngle_LookupIndex
                dc.w    AtAngle_C0_FF-AtAngle_LookupIndex
; ---------------------------------------------------------------------------

AtAngle_00_3F:
                moveq   #0,d5
                move.b  (a2,d0.w),d5
                moveq   #0,d6
                move.b  (a3,d4.w),d6
                rts
; ---------------------------------------------------------------------------

AtAngle_40_7F:
                moveq   #0,d5
                move.b  (a3,d4.w),d5
                moveq   #0,d6
                move.b  (a2,d0.w),d6
                neg.w   d6
                rts
; ---------------------------------------------------------------------------

AtAngle_80_BF:
                moveq   #0,d5
                move.b  (a2,d0.w),d5
                neg.w   d5
                moveq   #0,d6
                move.b  (a3,d4.w),d6
                neg.w   d6
                rts
; ---------------------------------------------------------------------------

AtAngle_C0_FF:
                moveq   #0,d5
                move.b  (a3,d4.w),d5
                neg.w   d5
                moveq   #0,d6
                move.b  (a2,d0.w),d6
                rts

; =============== S U B R O U T I N E =======================================

MoveSprite_CircularLookup:
                moveq   #0,d0
                move.b  $3C(a0),d0
                move.w  d0,d1
                andi.w  #$3F,d0
                lsr.w   #5,d1
                andi.w  #6,d1
                movea.w parent3(a0),a1
                lea     $40(a2),a3
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                move.b  child_dx(a0),d4
                ext.w   d4
                btst    #0,render_flags(a0)
                beq.s   loc_53448
                neg.w   d4

loc_53448:
                add.w   d4,d2
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d3
                move.w  d0,d4
                not.w   d4
                lea     AtAngle_LookupIndex(pc),a4
                move.w  (a4,d1.w),d1
                jsr     (a4,d1.w)
                btst    #0,render_flags(a0)
                beq.s   loc_5346C
                neg.w   d5

loc_5346C:
                add.w   d5,d2
                add.w   d6,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                rts
; End of function MoveSprite_CircularLookup

; =============== S U B R O U T I N E =======================================

MoveSprite_AngleYLookup:
                moveq   #0,d0
                move.b  $3C(a0),d0
                move.w  d0,d1
                andi.w  #$3F,d0
                lsr.w   #5,d1
                andi.w  #6,d1
                movea.w parent3(a0),a1
                lea     $40(a2),a3
                move.w  y_pos(a1),d3
                move.w  d0,d4
                not.w   d4
                move.w  AngleY_LookupIndex(pc,d1.w),d1
                jsr     AngleY_LookupIndex(pc,d1.w)
                add.w   d1,d3
                move.w  d3,y_pos(a0)
                rts
; End of function MoveSprite_AngleYLookup

; ---------------------------------------------------------------------------
AngleY_LookupIndex:
                dc.w    loc_534B4-AngleY_LookupIndex
                dc.w    loc_534BC-AngleY_LookupIndex
                dc.w    loc_534C6-AngleY_LookupIndex
                dc.w    loc_534D0-AngleY_LookupIndex
; ---------------------------------------------------------------------------

loc_534B4:
                moveq   #0,d1
                move.b  (a3,d4.w),d1
                rts
; ---------------------------------------------------------------------------

loc_534BC:
                moveq   #0,d1
                move.b  (a2,d0.w),d1
                neg.w   d1
                rts
; ---------------------------------------------------------------------------

loc_534C6:
                moveq   #0,d1
                move.b  (a3,d4.w),d1
                neg.w   d1
                rts
; ---------------------------------------------------------------------------

loc_534D0:
                moveq   #0,d1
                move.b  (a2,d0.w),d1
                rts

; =============== S U B R O U T I N E =======================================

MoveSprite_AngleXLookupOffset:
                moveq   #0,d0
                move.b  $3C(a0),d0
                move.b  d0,d1
                rol.b   #3,d1
                andi.w  #6,d1
                move.w  AngleX_LookupIndex(pc,d1.w),d2
                jmp     AngleX_LookupIndex(pc,d2.w)
; End of function MoveSprite_AngleXLookupOffset

; ---------------------------------------------------------------------------
AngleX_LookupIndex:
                dc.w    loc_534F6-AngleX_LookupIndex
                dc.w    loc_534FE-AngleX_LookupIndex
                dc.w    loc_5350A-AngleX_LookupIndex
                dc.w    loc_5351A-AngleX_LookupIndex
; ---------------------------------------------------------------------------

loc_534F6:
                move.b  (a1,d0.w),d1
                bra.w   loc_5352A
; ---------------------------------------------------------------------------

loc_534FE:
                moveq   #$7F,d1
                sub.w   d0,d1
                move.b  (a1,d1.w),d1
                bra.w   loc_5352A
; ---------------------------------------------------------------------------

loc_5350A:
                move.w  d0,d1
                andi.w  #$3F,d1
                move.b  (a1,d1.w),d1
                neg.w   d1
                bra.w   loc_5352A
; ---------------------------------------------------------------------------

loc_5351A:
                move.w  #$FF,d1
                sub.w   d0,d1
                move.b  (a1,d1.w),d1
                neg.w   d1
                bra.w   loc_5352A
; ---------------------------------------------------------------------------

loc_5352A:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.b  child_dx(a0),d3
                ext.w   d3
                add.w   d3,d2
                add.w   d1,d2
                move.w  d2,x_pos(a0)
                move.w  y_pos(a1),d2
                move.b  child_dy(a0),d3
                ext.w   d3
                add.w   d3,d2
                move.w  d2,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
                moveq   #0,d0                           ; Same as above but unused
                move.b  $3C(a0),d0
                move.b  d0,d1
                rol.b   #3,d1
                andi.w  #6,d1
                move.w  off_53568(pc,d1.w),d2
                jmp     off_53568(pc,d2.w)
; ---------------------------------------------------------------------------
off_53568:
                dc.w    loc_53570-off_53568
                dc.w    loc_53578-off_53568
                dc.w    loc_53584-off_53568
                dc.w    loc_53594-off_53568
; ---------------------------------------------------------------------------

loc_53570:
                move.b  (a1,d0.w),d1
                bra.w   loc_535A4
; ---------------------------------------------------------------------------

loc_53578:
                moveq   #$7F,d1
                sub.w   d0,d1
                move.w  (a1,d1.w),d1
                bra.w   loc_535A4
; ---------------------------------------------------------------------------

loc_53584:
                move.w  d0,d1
                andi.w  #$3F,d1
                move.w  (a1,d1.w),d1
                neg.w   d1
                bra.w   loc_535A4
; ---------------------------------------------------------------------------

loc_53594:
                move.w  #$FF,d1
                sub.w   d0,d1
                move.w  (a1,d1.w),d1
                neg.w   d1
                bra.w   loc_535A4
; ---------------------------------------------------------------------------

loc_535A4:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.b  child_dx(a0),d3
                ext.w   d3
                add.w   d3,d2
                move.w  d2,x_pos(a0)
                move.w  y_pos(a1),d2
                move.b  child_dy(a0),d3
                ext.w   d3
                add.w   d3,d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
                subq.w  #1,$2E(a0)                      ; Timed object, not actually used
                bmi.w   Go_Delete_Sprite
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                subq.w  #1,$2E(a0)                      ; Timed object with gravity-influenced movement
                bmi.w   Go_Delete_Sprite
                jsr     (MoveSprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MoveDraw_SpriteTimed:
                subq.w  #1,$2E(a0)
                bmi.w   Go_Delete_Sprite
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MoveDraw_SpriteTimed2:
                subq.w  #1,$2E(a0)
                bmi.w   Go_Delete_Sprite
                jsr     (MoveSprite_LightGravity).l
                bra.w   Draw_And_Touch_Sprite

; =============== S U B R O U T I N E =======================================

TimedSprite_ScreenLock:
                subq.w  #1,$2E(a0)
                bmi.s   loc_5361C
                rts
; ---------------------------------------------------------------------------

loc_5361C:
                move.b  #1,(Boss_flag).w
                bra.w   Go_Delete_Sprite_2
; End of function TimedSprite_ScreenLock

; =============== S U B R O U T I N E =======================================

BossFlash:
                lea     (Normal_palette_line_2+$2).w,a1
                moveq   #0,d0
                tst.w   (a1)
                bne.s   .noflash
                move.w  #$EEE,d0

                .noflash:
                move.w  d0,(a1)
                rts
; End of function BossFlash

; =============== S U B R O U T I N E =======================================

SetUp_ObjAttributesSlotted:
                moveq   #0,d0
                move.w  (a1)+,d1                        ; Maximum number of objects that can be made in this array
                move.w  d1,d2
                move.w  (a1)+,d3                        ; Base VRAM offset of object
                move.w  (a1)+,d4                        ; Amount to add to base VRAM offset for each slot
                moveq   #0,d5
                move.w  (a1)+,d5                        ; Index of slot array to use
                lea     (Slotted_object_bits).w,a2
                adda.w  d5,a2                           ; Get the address of the array to use
                move.b  (a2),d5
                beq.s   loc_53678                       ; If array is clear, just make the object

loc_53650:
                lsr.b   #1,d5                           ; Check slot (each bit)
                bcc.s   loc_53678                       ; If clear, make object
                addq.w  #1,d0                           ; Increment bit number
                add.w   d4,d3                           ; Add VRAM offset
                dbf     d1,loc_53650                    ; Repeat max times
                moveq   #0,d0
                move.l  d0,(a0)
                move.l  d0,x_pos(a0)
                move.l  d0,y_pos(a0)
                move.b  d0,subtype(a0)
                move.b  d0,render_flags(a0)
                move.w  d0,status(a0)                   ; If no open slots, then destroy this object period
                addq.w  #8,sp
                rts
; ---------------------------------------------------------------------------

loc_53678:
                bset    d0,(a2)                         ; Turn this slot on
                move.b  d0,ros_bit(a0)
                move.w  a2,ros_addr(a0)                 ; Keep track of slot address and bit number
                move.w  d3,art_tile(a0)                 ; Use correct VRAM offset
                move.l  (a1)+,mappings(a0)              ; Mapping address
                move.w  (a1)+,priority(a0)              ; Priority
                move.b  (a1)+,width_pixels(a0)          ; Width
                move.b  (a1)+,height_pixels(a0)         ; Height
                move.b  (a1)+,mapping_frame(a0)         ; Frame number
                move.b  (a1)+,collision_flags(a0)       ; Collision number
                bset    #2,status(a0)                   ; Turn object slotting on
                move.b  #-1,objoff_3A(a0)               ; Reset objoff_3A (used by Perform_DPLC)
                bset    #2,render_flags(a0)             ; Use screen coordinates
                addq.b  #2,routine(a0)                  ; Next routine
                rts
; End of function SetUp_ObjAttributesSlotted

; =============== S U B R O U T I N E =======================================

Perform_DPLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0            ; Get the frame number
                cmp.b   $3A(a0),d0                      ; If frame number remains the same as before, don't do anything
                beq.s   .end
                move.b  d0,$3A(a0)
                movea.l (a2)+,a3                        ; Source address of art
                move.w  art_tile(a0),d4
                andi.w  #$7FF,d4                        ; Isolate tile location offset
                lsl.w   #5,d4                           ; Convert to VRAM address
                movea.l (a2)+,a2                        ; Address of DPLC script
                add.w   d0,d0
                adda.w  (a2,d0.w),a2                    ; Apply offset to script
                move.w  (a2)+,d5                        ; Get number of DMA transactions
                moveq   #0,d3

                .loop:
                move.w  (a2)+,d3                        ; Art source offset
                move.l  d3,d1
                andi.w  #$FFF0,d1                       ; Isolate all but lower 4 bits
                add.w   d1,d1
                add.l   a3,d1                           ; Get final source address of art
                move.w  d4,d2                           ; Destination VRAM address
                andi.w  #$F,d3
                addq.w  #1,d3
                lsl.w   #4,d3                           ; d3 is the total number of words to transfer (maximum 16 tiles per transaction)
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l            ; Add to queue
                dbf     d5,.loop                        ; Keep going

                .end:
                rts
; End of function Perform_DPLC

; ---------------------------------------------------------------------------

Sprite_CheckDelete:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_5371C
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5371C:
                move.w  respawn_addr(a0),d0
                beq.s   loc_53728
                movea.w d0,a2
                bclr    #7,(a2)

loc_53728:
                bset    #7,status(a0)
                move.l  #Delete_Current_Sprite,(a0)
                rts
; ---------------------------------------------------------------------------

Sprite_CheckDelete2:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_5374E
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5374E:
                move.w  respawn_addr(a0),d0
                beq.s   loc_5375A
                movea.w d0,a2
                bclr    #7,(a2)

loc_5375A:
                bset    #4,$38(a0)
                move.l  #Delete_Current_Sprite,(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_5371C
                rts
; ---------------------------------------------------------------------------

Sprite_CheckDeleteXY:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmpi.w  #$200,d0
                bhi.w   Go_Delete_Sprite
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_FlickerMove:
                jsr     (MoveSprite).l
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmpi.w  #$200,d0
                bhi.w   Go_Delete_Sprite
                btst    #0,(V_int_run_count+3).w
                beq.w   locret_529CE
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Sprite_CheckDeleteTouch:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_5371C
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Sprite_CheckDeleteTouch2:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_5374E
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
; unused
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_5371C
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

Sprite_CheckDeleteTouchXY:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmpi.w  #$200,d0
                bhi.w   Go_Delete_Sprite
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Sprite_CheckDeleteSlotted:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   Go_Delete_SpriteSlotted
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Go_Delete_SpriteSlotted:
                move.w  respawn_addr(a0),d0
                beq.s   Go_Delete_SpriteSlotted2
                movea.w d0,a2
                bclr    #7,(a2)

Go_Delete_SpriteSlotted2:
                move.l  #Delete_Current_Sprite,(a0)
                bset    #7,status(a0)

; =============== S U B R O U T I N E =======================================

Remove_From_TrackingSlot:
                move.b  ros_bit(a0),d0
                movea.w ros_addr(a0),a1
                bclr    d0,(a1)
                rts
; End of function Remove_From_TrackingSlot

; ---------------------------------------------------------------------------
; unused
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   Go_Delete_SpriteSlotted
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Sprite_CheckDeleteTouchSlotted:
                tst.b   status(a0)
                bmi.s   Go_Delete_SpriteSlotted3
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   Go_Delete_SpriteSlotted
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Go_Delete_SpriteSlotted3:
                move.l  #Delete_Current_Sprite,(a0)
                bra.s   Remove_From_TrackingSlot
; ---------------------------------------------------------------------------
                tst.b   status(a0)                      ; Unused, seems to be identical to the above
                bmi.s   Go_Delete_SpriteSlotted3
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_SpriteSlotted
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                move.w  x_pos(a0),d0                    ; Next six are unused, virtually the same
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite_2
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite_2
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_SpriteSlotted2
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_SpriteSlotted2
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_539C4:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   Go_Delete_Sprite_2
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

Go_Delete_Sprite:
                move.l  #Delete_Current_Sprite,(a0)
                bset    #7,status(a0)
                rts
; End of function Go_Delete_Sprite

; =============== S U B R O U T I N E =======================================

Go_Delete_Sprite_2:
                move.l  #Delete_Current_Sprite,(a0)
                bset    #4,$38(a0)
                rts
; End of function Go_Delete_Sprite_2

; =============== S U B R O U T I N E =======================================

Set_IndexedVelocity:
                moveq   #0,d1
                move.b  subtype(a0),d1
                add.w   d1,d1
                add.w   d1,d0
                lea     Obj_VelocityIndex(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                btst    #0,render_flags(a0)
                beq.s   .noflip
                neg.w   x_vel(a0)

                .noflip:
                rts
; End of function Set_IndexedVelocity

; ---------------------------------------------------------------------------
Obj_VelocityIndex:
                dc.w    -$100, -$100
                dc.w    $100, -$100
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    -$300, -$200
                dc.w    $300, -$200
                dc.w    -$200, -$200
                dc.w    0, -$200
                dc.w    -$400, -$300
                dc.w    $400, -$300
                dc.w    $300, -$300
                dc.w    -$400, -$300
                dc.w    $400, -$300
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    0, -$100
                dc.w    -$40, -$700
                dc.w    -$80, -$700
                dc.w    -$180, -$700
                dc.w    -$100, -$700
                dc.w    -$200, -$700
                dc.w    -$280, -$700
                dc.w    -$300, -$700

; =============== S U B R O U T I N E =======================================

Find_SonicTails8Way:
                bsr.w   Find_SonicTails                 ; This routine seems bugged slightly. Shouldn't the first two cmpi instructions look at d3 and not d2?
                cmp.w   d2,d3
                beq.s   loc_53AD0
                bhi.s   loc_53AAA
                swap    d3                              ; If Y distance is closer to object
                clr.w   d3
                divu.w  d2,d3
                tst.w   d0
                beq.s   loc_53A9C
                cmpi.w  #$8000,d2                       ; If Y was closer and Sonic is to right of object
                blo.s   loc_53AEC
                tst.w   d0
                beq.s   loc_53AE8
                bra.w   loc_53AF0
; ---------------------------------------------------------------------------

loc_53A9C:
                cmpi.w  #$8000,d2                       ; If Y was closer and Sonic is to left of object
                blo.s   loc_53AFC
                tst.w   d1
                bne.s   loc_53AF8
                bra.w   loc_53B00
; ---------------------------------------------------------------------------

loc_53AAA:
                swap    d2                              ; If X distance is closer to object
                clr.w   d2
                divu.w  d3,d2
                tst.w   d1
                bne.s   loc_53AC2
                cmpi.w  #$8000,d2
                blo.s   loc_53AE4
                tst.w   d0
                bne.s   loc_53AE8
                bra.w   loc_53B00
; ---------------------------------------------------------------------------

loc_53AC2:
                cmpi.w  #$8000,d2
                blo.s   loc_53AF4
                tst.w   d0
                bne.s   loc_53AF0
                bra.w   loc_53AF8
; ---------------------------------------------------------------------------

loc_53AD0:
                tst.w   d0                              ; If X and Y distance are identical
                beq.s   loc_53ADC
                tst.w   d1
                beq.s   loc_53AE8
                bra.w   loc_53AF0
; ---------------------------------------------------------------------------

loc_53ADC:
                tst.w   d1
                bne.s   loc_53AF8
                bra.w   loc_53B00
; ---------------------------------------------------------------------------

loc_53AE4:
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_53AE8:
                moveq   #1,d4
                rts
; ---------------------------------------------------------------------------

loc_53AEC:
                moveq   #2,d4
                rts
; ---------------------------------------------------------------------------

loc_53AF0:
                moveq   #3,d4
                rts
; ---------------------------------------------------------------------------

loc_53AF4:
                moveq   #4,d4
                rts
; ---------------------------------------------------------------------------

loc_53AF8:
                moveq   #5,d4
                rts
; ---------------------------------------------------------------------------

loc_53AFC:
                moveq   #6,d4
                rts
; ---------------------------------------------------------------------------

loc_53B00:
                moveq   #7,d4
                rts
; End of function Find_SonicTails8Way

; =============== S U B R O U T I N E =======================================

Set_VelocityXTrackSonic:
                lea     (Player_1).w,a1
                bsr.w   Find_OtherObject
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   loc_53B1E
                neg.w   d4
                bset    #0,render_flags(a0)

loc_53B1E:
                move.w  d4,x_vel(a0)
                rts
; End of function Set_VelocityXTrackSonic

; =============== S U B R O U T I N E =======================================

Chase_Object:
                move.w  d0,d2                           ; d0 = Maximum speed
                neg.w   d2
                move.w  d1,d3                           ; d1 = acceleration
                move.w  x_pos(a0),d4
                cmp.w   x_pos(a1),d4
                seq     d5
                beq.s   loc_53B4C
                bcs.s   loc_53B3A
                neg.w   d1

loc_53B3A:
                move.w  x_vel(a0),d4
                add.w   d1,d4
                cmp.w   d2,d4
                blt.s   loc_53B4C
                cmp.w   d0,d4
                bgt.s   loc_53B4C
                move.w  d4,x_vel(a0)

loc_53B4C:
                move.w  y_pos(a0),d4
                cmp.w   y_pos(a1),d4
                beq.s   loc_53B6E
                bcs.s   loc_53B5A
                neg.w   d3

loc_53B5A:
                move.w  y_vel(a0),d4
                add.w   d3,d4
                cmp.w   d2,d4
                blt.s   locret_53B6C
                cmp.w   d0,d4
                bgt.s   locret_53B6C
                move.w  d4,y_vel(a0)

locret_53B6C:
                rts
; ---------------------------------------------------------------------------

loc_53B6E:
                tst.b   d5
                beq.s   locret_53B6C
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
; End of function Chase_Object

; =============== S U B R O U T I N E =======================================

Chase_ObjectXOnly:
                move.w  d0,d2
                neg.w   d2
                move.w  x_pos(a1),d3
                move.b  child_dx(a0),d4
                ext.w   d4
                add.w   d4,d3
                cmp.w   x_pos(a0),d3
                bhs.s   loc_53B94
                neg.w   d1

loc_53B94:
                move.w  x_vel(a0),d3
                add.w   d1,d3
                cmp.w   d2,d3
                blt.s   locret_53BA6
                cmp.w   d0,d3
                bgt.s   locret_53BA6
                move.w  d3,x_vel(a0)

locret_53BA6:
                rts
; End of function Chase_ObjectXOnly

; =============== S U B R O U T I N E =======================================

Chase_ObjectYOnly:
                move.w  d0,d2
                neg.w   d2
                move.w  y_pos(a1),d3
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d3
                cmp.w   y_pos(a0),d3
                bhs.s   loc_53BC0
                neg.w   d1

loc_53BC0:
                move.w  y_vel(a0),d3
                add.w   d1,d3
                cmp.w   d2,d3
                blt.s   locret_53BD2
                cmp.w   d0,d3
                bgt.s   locret_53BD2
                move.w  d3,y_vel(a0)

locret_53BD2:
                rts
; End of function Chase_ObjectYOnly

; ---------------------------------------------------------------------------
                move.w  d0,d2                           ; Unused, seems to be a combination of the above two routines, but additionally using offsets
                neg.w   d2
                move.w  d1,d3
                move.w  x_pos(a1),d6
                move.b  child_dx(a0),d4
                ext.w   d4
                add.w   d4,d6
                cmp.w   x_pos(a0),d6
                seq     d5
                beq.s   loc_53C04
                bcc.s   loc_53BF2
                neg.w   d1

loc_53BF2:
                move.w  x_vel(a0),d4
                add.w   d1,d4
                cmp.w   d2,d4
                blt.s   loc_53C04
                cmp.w   d0,d4
                bgt.s   loc_53C04
                move.w  d4,x_vel(a0)

loc_53C04:
                move.w  y_pos(a1),d6
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d6
                cmp.w   y_pos(a0),d6
                beq.s   loc_53C2E
                bcc.s   loc_53C1A
                neg.w   d3

loc_53C1A:
                move.w  y_vel(a0),d4
                add.w   d3,d4
                cmp.w   d2,d4
                blt.s   locret_53C2C
                cmp.w   d0,d4
                bgt.s   locret_53C2C
                move.w  d4,y_vel(a0)

locret_53C2C:
                rts
; ---------------------------------------------------------------------------

loc_53C2E:
                tst.b   d5
                beq.s   locret_53C2C
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

Obj_FadeSelectedFromBlack:
                move.l  #loc_53C4E,(a0)
                move.b  #7,$39(a0)
                move.b  #3,$2F(a0)

loc_53C4E:
                subq.b  #1,$2E(a0)
                bmi.s   loc_53C56
                rts
; ---------------------------------------------------------------------------

loc_53C56:
                subq.b  #1,$39(a0)
                bmi.w   loc_531C2
                move.b  $2F(a0),$2E(a0)
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #$E,d4
                moveq   #-$20,d5
                moveq   #$20-1,d6

loc_53C72:
                bsr.w   IncColor_Obj
                dbf     d6,loc_53C72
                rts

; =============== S U B R O U T I N E =======================================

IncColor_Obj:
                move.b  (a1),d0
                and.b   d4,d0
                move.b  (a2)+,d1
                and.b   d4,d1
                cmp.b   d1,d0
                bhs.s   loc_53C8A
                addq.b  #2,d0

loc_53C8A:
                move.b  d0,(a1)+
                move.b  (a1),d0
                move.b  d0,d1
                and.b   d5,d0
                move.b  (a2)+,d2
                move.b  d2,d3
                and.b   d5,d2
                cmp.b   d2,d0
                bhs.s   loc_53CA0
                addi.b  #$20,d0

loc_53CA0:
                and.b   d4,d1
                and.b   d4,d3
                cmp.b   d3,d1
                bhs.s   loc_53CAA
                addq.b  #2,d1

loc_53CAA:
                or.b    d0,d1
                move.b  d1,(a1)+
                rts
; End of function IncColor_Obj

; ---------------------------------------------------------------------------

MoveFall_AnimateRaw:
                jsr     (MoveSprite).l
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

Move_AnimateRaw:
                jsr     (MoveSprite2).l
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

MoveSlowFall_AnimateRaw:
                jsr     MoveSprite_LightGravity(pc)
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------
; unused
                jsr     Swing_UpAndDown(pc)

Move_AnimateRaw_Wait:
                jsr     (MoveSprite2).l

loc_53CD6:
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Refresh_ChildPosWait:
                jsr     Refresh_ChildPosition(pc)

Wait_Draw:
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MoveWaitTouch:
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_53CFA:
                jsr     Refresh_ChildPosition(pc)

AnimateRaw_DrawTouch:
                jsr     Animate_RawMultiDelay(pc)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

AnimateRaw_MoveChkDel:
                jsr     Animate_Raw(pc)

MoveChkDel:
                jsr     (MoveSprite).l
                jmp     Sprite_CheckDeleteXY(pc)
; ---------------------------------------------------------------------------
; unused
                jsr     Animate_Raw(pc)

MoveTouchChkDel:
                jsr     (MoveSprite).l
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

Move_WaitNoFall:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Swing_MoveWaitNoFall:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------
; unused
                jsr     Animate_Raw(pc)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
; unused
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
; unused
                jsr     (MoveSprite2).l
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------
; unused
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
; unused
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------
; unused
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

EnemyDefeat_Score:
                bset    #7,status(a0)
                movea.w $44(a0),a1
                moveq   #0,d0
                move.w  (Chain_bonus_counter).w,d0
                addq.w  #2,(Chain_bonus_counter).w
                cmpi.w  #6,d0
                blo.s   loc_53D88
                moveq   #6,d0

loc_53D88:
                move.w  d0,$3E(a0)
                move.w  word_53DE8(pc,d0.w),d0
                cmpi.w  #$20,(Chain_bonus_counter).w
                blo.s   loc_53DA2
                move.w  #1000,d0                        ; 10000 points
                move.w  #$A,$3E(a0)

loc_53DA2:
                movea.w a1,a3
                jsr     (HUD_AddToScore).l
                move.l  #Obj_Explosion,(a0)
                move.b  #0,routine(a0)
                tst.w   y_vel(a1)
                bmi.s   loc_53DD0
                move.w  y_pos(a1),d0
                cmp.w   y_pos(a0),d0
                bcc.s   loc_53DDC
                neg.w   y_vel(a1)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_53DD0:
                addi.w  #$100,y_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_53DDC:
                subi.w  #$100,y_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_53DE8:
                dc.w    10                              ; 100 points
                dc.w    20                              ; 200 points
                dc.w    50                              ; 500 points
                dc.w    100                             ; 1000 points

; =============== S U B R O U T I N E =======================================

Check_LRControllerShake:
                subq.b  #1,$3D(a0)
                bpl.s   loc_53E02
                move.b  #5,$3C(a0)
                move.b  #60,$3D(a0)

loc_53E02:
                movea.w $3E(a0),a2
                move.w  (a2),d0
                andi.w  #$C,d0
                beq.s   locret_53E26
                move.w  $3A(a0),d1
                move.w  d0,$3A(a0)
                andi.w  #$C,d1
                eor.w   d1,d0
                beq.s   locret_53E26
                subq.b  #1,$3C(a0)
                bmi.s   locret_53E26
                moveq   #0,d0

locret_53E26:
                rts
; End of function Check_LRControllerShake

; =============== S U B R O U T I N E =======================================

Check_PlayerCollision:
                move.b  collision_property(a0),d0
                beq.s   locret_53E50
                clr.b   collision_property(a0)
                move.w  parent3(a0),d1
                beq.s   loc_53E40
                movea.w d1,a1
                bset    #0,$38(a1)

loc_53E40:
                andi.w  #3,d0
                add.w   d0,d0
                movea.w word_53E52-2(pc,d0.w),a1
                move.w  a1,$44(a0)
                moveq   #1,d1

locret_53E50:
                rts
; End of function Check_PlayerCollision

; ---------------------------------------------------------------------------
word_53E52:
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_1

; =============== S U B R O U T I N E =======================================

Check_PlayerInRange:
                moveq   #0,d0
                lea     (Player_2).w,a2
                move.w  x_pos(a2),d1
                move.w  y_pos(a2),d2
                move.w  x_pos(a0),d3
                move.w  y_pos(a0),d4
                add.w   (a1)+,d3
                move.w  d3,d5
                add.w   (a1)+,d5
                add.w   (a1)+,d4
                move.w  d4,d6
                add.w   (a1)+,d6
                bsr.w   sub_53E8C
                swap    d0
                lea     (Player_1).w,a2
                move.w  x_pos(a2),d1
                move.w  y_pos(a2),d2
; End of function Check_PlayerInRange

; =============== S U B R O U T I N E =======================================

sub_53E8C:
                cmp.w   d3,d1
                blo.s   locret_53E9E
                cmp.w   d5,d1
                bhs.s   locret_53E9E
                cmp.w   d4,d2
                blo.s   locret_53E9E
                cmp.w   d6,d2
                bhs.s   locret_53E9E
                move.w  a2,d0

locret_53E9E:
                rts
; End of function sub_53E8C

; =============== S U B R O U T I N E =======================================

PalLoad_Line1:
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d0

                .loop:
                move.l  (a1)+,(a2)+
                dbf     d0,.loop
                rts
; End of function PalLoad_Line1

; =============== S U B R O U T I N E =======================================

Displace_PlayerOffObject:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   locret_53EE8
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_53ED0
                lea     (Player_1).w,a1
; Bug: This should clear Status_OnObj instead of p1_standing_bit
; Thankfully, they both equal 3. Sonic (3) & Knuckles corrects this
                bclr    #p1_standing_bit,status(a1)
                bset    #Status_InAir,status(a1)

loc_53ED0:
                bclr    #p2_standing_bit,status(a0)
                beq.s   locret_53EE8
                lea     (Player_2).w,a1
; Bug: this should clear Status_OnObj instead of p2_standing_bit
; As a result, player 2's Status_RollJump is cleared instead
; Sonic (3) & Knuckles corrects this as well
                bclr    #p2_standing_bit,status(a1)
                bset    #Status_InAir,status(a1)

locret_53EE8:
                rts
; End of function Displace_PlayerOffObject

; =============== S U B R O U T I N E =======================================

Run_PalRotationScript:
                lea     (Palette_rotation_data).w,a1

loc_53EEE:
                move.w  (a1),d0                         ; load palette displacement to d0
                beq.s   locret_53F32                    ; if 0, return
                subq.b  #1,2(a1)                        ; decrement delay
                bpl.s   loc_53F22                       ; if still positive, go to next entry
                movea.l 4(a1),a2                        ; load palette script address to a2
                movea.w (a2),a3                         ; load destination address to a3
                lea     (a2,d0.w),a4                    ; copy script address to a4 and skip to palette data
                move.w  (a4),d1                         ; load the first entry to d1
                bpl.s   loc_53F0A                       ; if positive, it is a normal entry
                bsr.w   sub_53F26                       ; this is a command

loc_53F0A:
                moveq   #0,d2
                move.b  2(a2),d2                        ; load number of colors to d2

loc_53F10:
                move.w  (a4)+,(a3)+                     ; copy the next color into destination
                dbf     d2,loc_53F10                    ; loop for every color
                move.w  (a4)+,d0                        ; load next delay
                move.b  d0,2(a1)                        ; save the delay
                move.l  a4,d0                           ; copy current script position into d0
                sub.l   a2,d0                           ; calculate the current displacement from palette script origin
                move.w  d0,(a1)                         ; store it back

loc_53F22:
                addq.w  #8,a1                           ; go to next script
                bra.s   loc_53EEE                       ; run the code again
; End of function Run_PalRotationScript

; =============== S U B R O U T I N E =======================================

sub_53F26:
                move.b  3(a2),d2                        ; load additional parameter to d2
                bne.s   loc_53F34
                moveq   #4,d0                           ; Start from the beginning of the rotation
                lea     (a2,d0.w),a4

locret_53F32:
                rts
; ---------------------------------------------------------------------------

loc_53F34:
                neg.w   d1
                jmp     .table-8(pc,d1.w)
; End of function sub_53F26

; ---------------------------------------------------------------------------

                .table:
                bra.w   loc_53F42
                bra.w   loc_53F64
; ---------------------------------------------------------------------------

loc_53F42:
                addq.b  #1,3(a1)                        ; Add one to counter
                cmp.b   3(a1),d2                        ; Compare with max counter
                bhi.s   loc_53F5C
                move.w  2(a4),d2
                adda.w  d2,a2
                move.l  a2,4(a1)                        ; Load new script after counter has finished
                movea.w (a2),a3
                clr.w   2(a1)

loc_53F5C:
                moveq   #4,d0                           ; Start from the beginning of the rotation
                lea     (a2,d0.w),a4
                rts
; ---------------------------------------------------------------------------

loc_53F64:
                addq.b  #1,3(a1)
                cmp.b   3(a1),d2
                bls.s   loc_53F76
                moveq   #4,d0                           ; Start from the beginning of the rotation
                lea     (a2,d0.w),a4
                rts
; ---------------------------------------------------------------------------

loc_53F76:
                movea.l (Palette_rotation_custom).w,a2
                move.l  a1,-(sp)
                jsr     (a2)                            ; Run custom routine
                movea.l (sp)+,a1
                addq.w  #4,sp
                bra.s   loc_53F22

; =============== S U B R O U T I N E =======================================

Child_GetPriority:
                movea.w parent3(a0),a1
                bclr    #7,art_tile(a0)
                btst    #7,art_tile(a1)
                beq.s   loc_53F9C
                bset    #7,art_tile(a0)

loc_53F9C:
                move.w  priority(a1),priority(a0)
                rts
; End of function Child_GetPriority

; =============== S U B R O U T I N E =======================================

Child_GetPriorityOnce:
                movea.w parent3(a0),a1
                btst    #7,art_tile(a1)
                beq.s   locret_53FB8
                bset    #7,art_tile(a0)
                move.l  (sp),(a0)

locret_53FB8:
                rts
; End of function Child_GetPriorityOnce

; =============== S U B R O U T I N E =======================================

CopyWordData_7:
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+

CopyWordData_6:
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+

CopyWordData_5:
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
; End of function CopyWordData_7

; =============== S U B R O U T I N E =======================================

CopyWordData_4:
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
; End of function CopyWordData_4

; =============== S U B R O U T I N E =======================================

CopyWordData_3:
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+

CopyWordData_2:
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
                rts
; End of function CopyWordData_3

; =============== S U B R O U T I N E =======================================

Obj_WaitOffscreen:
                move.l  #Map_Offscreen,mappings(a0)
                bset    #2,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  (sp)+,$34(a0)
                move.l  #loc_53FFC,(a0)

loc_53FFC:
                tst.b   render_flags(a0)
                bmi.s   loc_5402C
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_5401A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5401A:
                move.w  respawn_addr(a0),d0
                beq.s   loc_54026
                movea.w d0,a2
                bclr    #7,(a2)

loc_54026:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_5402C:
                move.l  $34(a0),(a0)                    ; Restore normal object operation when onscreen
                rts
; End of function Obj_WaitOffscreen

; ---------------------------------------------------------------------------
Map_Offscreen:
                dc.w    0
; ---------------------------------------------------------------------------

Obj_Song_Fade_ToLevelMusic:
                move.w  #2*60,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.l  #loc_54048,(a0)

loc_54048:
                subq.w  #1,$2E(a0)
                bpl.w   locret_529CE
                bsr.w   Restore_LevelMusic
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_Song_Fade_Transition:
                move.w  #2*60,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.l  #loc_5406E,(a0)

loc_5406E:
                subq.w  #1,$2E(a0)
                bpl.w   locret_529CE
                move.b  subtype(a0),d0
                jsr     (Play_Music).l
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

Restore_LevelMusic:
                moveq   #0,d0
                lea     (Apparent_zone_and_act).w,a1
                move.b  (a1)+,d0
                add.b   d0,d0
                add.b   (a1),d0
                move.b  PlayLevelMusic_Playlist(pc,d0.w),d0
                move.w  d0,(Current_music).w
                btst    #Status_Invincible,(Player_1+status_secondary).w
                beq.s   loc_540A4
                moveq   #signextendB(mus_Invincibility),d0  ; If invincible, play invincibility

loc_540A4:
                jmp     (Play_Music).l
; End of function Restore_LevelMusic

; ---------------------------------------------------------------------------
PlayLevelMusic_Playlist:
                dc.b    mus_AIZ1, mus_AIZ2
                dc.b    mus_HCZ1, mus_HCZ2
                dc.b    mus_MGZ1, mus_MGZ2
                dc.b    mus_CNZ1, mus_CNZ2
                dc.b    mus_FBZ1, mus_FBZ2
                dc.b    mus_ICZ1, mus_ICZ2
                dc.b    mus_LBZ1, mus_LBZ2

; =============== S U B R O U T I N E =======================================

Restore_PlayerControl:
                lea     (Player_1).w,a1

Restore_PlayerControl2:
                clr.b   object_control(a1)
                bclr    #Status_InAir,status(a1)
                move.w  #(5<<8)|5,anim(a1)              ; and prev_anim
                clr.b   anim_frame(a1)
                clr.b   anim_frame_timer(a1)
                rts
; End of function Restore_PlayerControl

; =============== S U B R O U T I N E =======================================

Obj_EndSignControl:
                move.l  #Obj_EndSignControlWait,(a0)
                st      (_unkFAA8).w                    ; End of level is in effect
                bclr    #7,render_flags(a0)
                bset    #4,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #Obj_EndSignControlDoSign,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                rts
; End of function Obj_EndSignControl

; ---------------------------------------------------------------------------
PLC_EndSignStuff:   plrlistheader
                plreq   ArtTile_SignpostStub, ArtNem_SignpostStub
                plreq   ArtTile_Monitors, ArtNem_Monitors
PLC_EndSignStuff_End:
; ---------------------------------------------------------------------------

Obj_EndSignControlWait:
                bclr    #7,render_flags(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_EndSignControlDoSign:
                move.l  #Obj_EndSignControlAwaitStart,(a0)
                clr.b   (Boss_flag).w
                jsr     Restore_LevelMusic(pc)
                lea     Child6_EndSign(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     PLC_EndSignStuff(pc),a1
                jsr     (Load_PLC_Raw).l
                jmp     AfterBoss_Cleanup(pc)
; ---------------------------------------------------------------------------
Child6_EndSign:
                dc.w    1-1
                dc.l    Obj_EndSign
; ---------------------------------------------------------------------------

Obj_EndSignControlAwaitStart:
                tst.b   (_unkFAA8).w
                bne.w   locret_529CE
                move.l  #Obj_EndSignControlDoStart,(a0)
                jsr     Restore_PlayerControl(pc)
                lea     (Player_2).w,a1
                jmp     Restore_PlayerControl2(pc)
; ---------------------------------------------------------------------------

Obj_EndSignControlDoStart:
                tst.b   (End_of_level_flag).w           ; Wait for title card to finish
                beq.w   locret_529CE
                jsr     Change_Act2Sizes(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
; unused
                jsr     Displace_PlayerOffObject(pc)
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

Check_CameraInRange:
                move.w  (Camera_Y_pos).w,d0
                cmp.w   (a1)+,d0
                blo.s   loc_54198
                cmp.w   (a1)+,d0
                bhi.s   loc_54198
                move.w  (Camera_X_pos).w,d1
                cmp.w   (a1)+,d1
                blo.s   loc_54198
                cmp.w   (a1)+,d1
                bhi.s   loc_54198
                move.l  (sp),(a0)
                rts
; ---------------------------------------------------------------------------

loc_54198:
                jsr     (Delete_Sprite_If_Not_In_Range).l
                addq.w  #4,sp
                rts
; End of function Check_CameraInRange

; ---------------------------------------------------------------------------

loc_541A2:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                move.w  (Camera_target_max_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                blo.s   locret_541C6
                move.w  d0,(Camera_min_Y_pos).w
                move.w  $3A(a0),d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   locret_541C6
                movea.l $34(a0),a1
                jsr     (a1)

locret_541C6:
                rts
; ---------------------------------------------------------------------------

loc_541C8:
                btst    #0,$38(a0)
                bne.s   loc_541E6
                subq.w  #1,$2E(a0)
                bpl.s   loc_541E6
                move.b  $26(a0),d0
                jsr     (Play_Music).l
                bset    #0,$38(a0)

loc_541E6:
                btst    #1,$38(a0)
                bne.s   loc_54202
                move.w  (Camera_target_max_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                bne.s   loc_54202
                move.w  d0,(Camera_min_Y_pos).w
                bset    #1,$38(a0)

loc_54202:
                btst    #2,$38(a0)
                bne.s   loc_54220
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                move.w  $1C(a0),d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   loc_54220
                bset    #2,$38(a0)

loc_54220:
                move.b  $38(a0),d0
                andi.b  #7,d0
                cmpi.b  #7,d0
                bne.w   locret_529CE
                clr.b   $38(a0)
                clr.w   $1C(a0)
                clr.b   $26(a0)
                movea.l $34(a0),a1
                jmp     (a1)

; =============== S U B R O U T I N E =======================================

Change_Act2Sizes:
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                lsl.w   #4,d0
                lea     (LevelSizes).l,a1
                lea     8(a1,d0.w),a1                   ; Get level sizes for act 2
                move.w  (a1)+,(Camera_stored_min_X_pos).w
                move.w  (a1)+,(Camera_stored_max_X_pos).w
                move.w  (a1)+,(Camera_stored_min_Y_pos).w
                move.w  (a1)+,d1
                move.w  d1,(Camera_stored_max_Y_pos).w  ; Put level sizes into the target size memory
                move.w  d1,(Camera_target_max_Y_pos).w
                cmpi.b  #$10,d0
                beq.w   locret_529CE                    ; If we're in HCZ, don't immediately apply these changes. There's another event to do
; End of function Change_Act2Sizes

; =============== S U B R O U T I N E =======================================

Make_LevelSizeObj:
                lea     Child1_Act2LevelSize(pc),a2
                jmp     CreateChild1_Normal(pc)
; End of function Make_LevelSizeObj

; ---------------------------------------------------------------------------
Child1_Act2LevelSize:
                dc.w    3-1
                dc.l    Obj_IncLevEndXGradual
                dc.b    0,   0
                dc.l    Obj_DecLevStartYGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndYGradual
                dc.b    0,   0

; =============== S U B R O U T I N E =======================================

StartNewLevel:
                move.w  d0,(Current_zone_and_act).w
                move.w  d0,(Apparent_zone_and_act).w
                move.w  #1,(Restart_level_flag).w
                clr.b   (Last_star_post_hit).w
                clr.b   (Special_bonus_entry_flag).w
                rts
; End of function StartNewLevel

; =============== S U B R O U T I N E =======================================

Play_SFX_Continuous:
                move.b  (V_int_run_count+3).w,d1
                andi.b  #$F,d1
                bne.w   locret_529CE
                jmp     (Play_SFX).l
; End of function Play_SFX_Continuous

; ---------------------------------------------------------------------------

loc_542B8:
                move.b  #7,$39(a0)
                move.w  #3,$2E(a0)
                move.l  #loc_542CA,(a0)

loc_542CA:
                subq.w  #1,$2E(a0)
                bpl.w   locret_529CE
                move.w  #3,$2E(a0)
                lea     (Normal_palette).w,a1
                moveq   #$40-1,d0

loc_542DE:
                bsr.w   sub_542F0
                dbf     d0,loc_542DE
                subq.b  #1,$39(a0)
                bmi.w   Go_Delete_Sprite
                rts

; =============== S U B R O U T I N E =======================================

sub_542F0:
                moveq   #$E,d2
                move.b  (a1),d3
                and.b   d2,d3
                cmp.b   d2,d3
                bhs.s   loc_542FE
                addq.b  #2,d3
                move.b  d3,(a1)

loc_542FE:
                addq.w  #1,a1
                move.b  (a1),d3
                move.b  d3,d4
                andi.b  #$E0,d3
                andi.b  #$E,d4
                cmpi.b  #$E0,d3
                bhs.s   loc_54316
                addi.b  #$20,d3

loc_54316:
                cmp.b   d2,d4
                bhs.s   loc_5431C
                addq.b  #2,d4

loc_5431C:
                or.b    d3,d4
                move.b  d4,(a1)+
                rts
; End of function sub_542F0

; ---------------------------------------------------------------------------

loc_54322:
                move.b  #7,$39(a0)
                move.w  #3,$2E(a0)
                move.l  #loc_54334,(a0)

loc_54334:
                subq.w  #1,$2E(a0)
                bpl.w   locret_529CE
                move.w  #3,$2E(a0)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #$40-1,d0

loc_5434C:
                bsr.w   sub_5435E
                dbf     d0,loc_5434C
                subq.b  #1,$39(a0)
                bmi.w   Go_Delete_Sprite
                rts

; =============== S U B R O U T I N E =======================================

sub_5435E:
                move.b  (a2)+,d2
                andi.b  #$E,d2
                move.b  (a1),d3
                cmp.b   d2,d3
                bls.s   loc_5436E
                subq.b  #2,d3
                move.b  d3,(a1)

loc_5436E:
                addq.w  #1,a1
                move.b  (a2)+,d2
                move.b  d2,d3
                andi.b  #$E0,d2
                andi.b  #$E,d3
                move.b  (a1),d4
                move.b  d4,d5
                andi.b  #$E0,d4
                andi.b  #$E,d5
                cmp.b   d2,d4
                bls.s   loc_54390
                subi.b  #$20,d4

loc_54390:
                cmp.b   d3,d5
                bls.s   loc_54396
                subq.b  #2,d5

loc_54396:
                or.b    d4,d5
                move.b  d5,(a1)+
                rts
; End of function sub_5435E

; ---------------------------------------------------------------------------
sub_5439C:
                move.w  (Player_mode).w,d0
                cmpi.w  #2,d0
                beq.s   loc_543B2
                cmpi.w  #7,(Chaos_emerald_count).w
                beq.s   loc_543B6
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

loc_543B2:
                moveq   #1,d0
                rts
; ---------------------------------------------------------------------------

loc_543B6:
                moveq   #2,d0
                rts

; =============== S U B R O U T I N E =======================================

BossDefeated_StopTimer:
                clr.b   (Update_HUD_timer).w
; End of function BossDefeated_StopTimer

; =============== S U B R O U T I N E =======================================

BossDefeated:
                move.w  #$3F,$2E(a0)
                moveq   #100,d0
                jsr     (HUD_AddToScore).l
                bclr    #7,render_flags(a0)
                rts
; End of function BossDefeated

; =============== S U B R O U T I N E =======================================

Player_Load_PLC:
                move.l  a0,-(sp)
                lea     (Player_1).w,a0
                moveq   #0,d0
                move.b  character_id(a0),d0
                lsl.w   #2,d0
                movea.l Player_Load_PLC_Index(pc,d0.w),a1
                jsr     (a1)
                movea.l (sp)+,a0
                rts
; End of function Player_Load_PLC

; ---------------------------------------------------------------------------
Player_Load_PLC_Index:
                dc.l    Sonic_Load_PLC
                dc.l    Tails_Load_PLC

; =============== S U B R O U T I N E =======================================

PLCLoad_AnimalsAndExplosion:
                lea     PLC_Explosion(pc),a1
                jsr     (Load_PLC_Raw).l
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                add.w   d0,d0
                move.w  PLCLoad_Animals_Index(pc,d0.w),d0
                lea     PLCLoad_Animals_Index(pc,d0.w),a1
                jmp     (Load_PLC_Raw).l
; End of function PLCLoad_AnimalsAndExplosion

; ---------------------------------------------------------------------------
PLCLoad_Animals_Index:
                dc.w    PLC_Animals_AIZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_HCZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_MGZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_CNZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_FBZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_ICZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_LBZ-PLCLoad_Animals_Index
PLC_Animals_AIZ:    plrlistheader
                plreq   ArtTile_Animals1, ArtNem_BlueFlicky
                plreq   ArtTile_Animals2, ArtNem_Chicken
PLC_Animals_AIZ_End:

PLC_Animals_HCZ:    plrlistheader
                plreq   ArtTile_Animals1, ArtNem_Rabbit
                plreq   ArtTile_Animals2, ArtNem_Seal
PLC_Animals_HCZ_End:

PLC_Animals_MGZ:    plrlistheader
                plreq   ArtTile_Animals1, ArtNem_BlueFlicky
                plreq   ArtTile_Animals2, ArtNem_Chicken
PLC_Animals_MGZ_End:

PLC_Animals_CNZ:    plrlistheader
                plreq   ArtTile_Animals1, ArtNem_Rabbit
                plreq   ArtTile_Animals2, ArtNem_BlueFlicky
PLC_Animals_CNZ_End:

PLC_Animals_FBZ:    plrlistheader
                plreq   ArtTile_Animals1, ArtNem_Squirrel
                plreq   ArtTile_Animals2, ArtNem_BlueFlicky
PLC_Animals_FBZ_End:

PLC_Animals_ICZ:    plrlistheader
                plreq   ArtTile_Animals1, ArtNem_Penguin
                plreq   ArtTile_Animals2, ArtNem_Seal
PLC_Animals_ICZ_End:

PLC_Animals_LBZ:    plrlistheader
                plreq   ArtTile_Animals1, ArtNem_Squirrel
                plreq   ArtTile_Animals2, ArtNem_Chicken
PLC_Animals_LBZ_End:
; ---------------------------------------------------------------------------

AddRings:
                lea     (Ring_count).w,a2
                lea     (Update_HUD_ring_count).w,a3
                lea     (Extra_life_flags).w,a4
                lea     (Total_ring_count).w,a5
                move.w  #999,d1
                add.w   d0,(a5)
                cmp.w   (a5),d1
                bhs.s   loc_544A0
                move.w  d1,(a5)

loc_544A0:
                add.w   d0,(a2)
                cmp.w   (a2),d1
                bhs.s   loc_544A8
                move.w  d1,(a2)

loc_544A8:
                ori.b   #1,(a3)
                cmpi.w  #100,(a2)
                blo.s   loc_544C4
                bset    #1,(a4)
                beq.s   loc_544CC
                cmpi.w  #200,(a2)
                blo.s   loc_544C4
                bset    #2,(a4)
                beq.s   loc_544CC

loc_544C4:
                moveq   #signextendB(sfx_RingRight),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

loc_544CC:
                addq.w  #1,(Monitors_broken).w          ; Add an extra life
                addq.b  #1,(Life_count).w
                addq.b  #1,(Update_HUD_life_count).w
                moveq   #signextendB(mus_ExtraLife),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

Obj_EggCapsule:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  EggCapsule_Index(pc,d0.w),d1
                move.w  x_pos(a0),-(sp)
                jsr     EggCapsule_Index(pc,d1.w)
                moveq   #$2B,d1
                moveq   #$18,d2
                moveq   #$18,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                jmp     loc_539C4(pc)
; ---------------------------------------------------------------------------
EggCapsule_Index:
                dc.w    loc_54514-EggCapsule_Index
                dc.w    loc_5456A-EggCapsule_Index
                dc.w    loc_545B4-EggCapsule_Index
                dc.w    loc_545BC-EggCapsule_Index
                dc.w    loc_545C0-EggCapsule_Index
                dc.w    loc_54640-EggCapsule_Index
                dc.w    loc_54652-EggCapsule_Index
                dc.w    loc_54660-EggCapsule_Index
; ---------------------------------------------------------------------------

loc_54514:
                lea     ObjDat_EggCapsule(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                btst    #1,render_flags(a0)
                bne.s   loc_5452C
                lea     ChildObjDat_54AA6(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_5452C:
                move.b  #8,routine(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                move.w  d0,x_pos(a0)
                move.w  d0,$3E(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$40,d0
                move.w  d0,y_pos(a0)
                move.w  #1,$3A(a0)
                jsr     (Swing_Setup1).l
                lea     ChildObjDat_54AAE(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_54AB6(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_5456A:
                btst    #1,$38(a0)
                beq.s   locret_545B2
                move.b  #4,routine(a0)

; =============== S U B R O U T I N E =======================================

sub_54578:
                cmpi.b  #2,(Current_zone).w
                beq.s   loc_54584
                st      (Ctrl_2_locked).w

loc_54584:
                move.b  #1,mapping_frame(a0)
                move.w  #$40,$2E(a0)
                lea     ChildObjDat_54AC4(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_54AE4(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                move.b  #8,subtype(a1)

locret_545B2:
                rts
; End of function sub_54578

; ---------------------------------------------------------------------------

loc_545B4:
                move.b  #6,d0
                bra.w   sub_5484E
; ---------------------------------------------------------------------------

loc_545BC:
                bra.w   Check_TailsEndPose
; ---------------------------------------------------------------------------

loc_545C0:
                move.w  (Camera_X_pos).w,d0
                move.w  $3A(a0),d1
                bmi.s   loc_545D8
                addi.w  #$110,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_545E2
                bra.w   loc_545E4
; ---------------------------------------------------------------------------

loc_545D8:
                addi.w  #$30,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_545E4

loc_545E2:
                neg.w   d1

loc_545E4:
                move.w  d1,$3A(a0)
                add.w   d1,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$40,d0
                cmpi.b  #2,(Current_zone).w
                bne.s   loc_54600
                subi.w  #$20,d0

loc_54600:
                move.l  #$4000,d1
                cmp.w   y_pos(a0),d0
                bhi.s   loc_5460E
                neg.l   d1

loc_5460E:
                add.l   d1,y_pos(a0)
                btst    #1,$38(a0)
                beq.s   loc_54636
                move.b  #$A,routine(a0)
                cmpi.b  #2,(Current_zone).w
                bne.s   loc_5462E
                move.b  #$E,routine(a0)

loc_5462E:
                move.w  a1,$44(a0)
                bsr.w   sub_54578

loc_54636:
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_54640:
                move.b  #$C,d0
                bsr.w   sub_5484E
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_54652:
                bsr.w   Check_TailsEndPose
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_54660:
                move.b  #$C,d0
                bsr.w   sub_548DA
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_54672:
                move.l  #loc_54680,(a0)
                lea     word_54A88(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_54680:
                bsr.w   sub_5499E
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_546A2
                move.l  #loc_546A6,(a0)
                addq.w  #8,y_pos(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

loc_546A2:
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_546A6:
                bsr.w   sub_5499E
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_546AE:
                move.l  #loc_546C2,(a0)
                bset    #1,render_flags(a0)
                lea     word_54A88(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_546C2:
                jsr     Refresh_ChildPosition(pc)
                moveq   #6,d2
                bsr.w   loc_549A0
                lea     word_54716(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   loc_54712
                tst.w   d0
                beq.s   loc_546F4
                movea.w d0,a1
                tst.w   y_vel(a1)
                bpl.s   loc_546F4
                cmpi.b  #2,anim(a1)
                beq.s   loc_546FE
                cmpi.b  #1,character_id(a1)
                beq.s   loc_546FE

loc_546F4:
                swap    d0
                movea.w d0,a1
                tst.w   y_vel(a1)
                bpl.s   loc_54712

loc_546FE:
                move.l  #loc_5471E,(a0)
                subq.b  #8,child_dy(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

loc_54712:
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------
word_54716:
                dc.w    -$1A,   $34,  -$1C,   $38
; ---------------------------------------------------------------------------

loc_5471E:
                jsr     Refresh_ChildPosition(pc)
                moveq   #5,d2
                bsr.w   loc_549A0
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_5472C:
                lea     ObjDat3_54A8E(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                cmpi.w  #$400,(Current_zone_and_act).w
                bne.s   loc_54742
                move.w  #make_art_tile(ArtTile_EggCapsule-$46,0,0),art_tile(a0)

loc_54742:
                move.l  #Obj_FlickerMove,(a0)
                bsr.w   sub_549AE
                moveq   #4,d0
                jsr     Set_IndexedVelocity(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_54758:
                lea     word_54AA0(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_54766,(a0)

loc_54766:
                jsr     Refresh_ChildPosition(pc)
                lea     byte_54B40(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_54776:
                lea     word_54A9A(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_54794,(a0)
                move.b  #8,y_radius(a0)
                bsr.w   sub_549C4
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_54794:
                subq.w  #1,$2E(a0)
                bpl.s   loc_547A6
                move.l  #loc_547AA,(a0)
                move.w  #$80,priority(a0)

loc_547A6:
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_547AA:
                jsr     MoveSprite_LightGravity(pc)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_547DE
                add.w   d1,y_pos(a0)
                move.w  $3E(a0),y_vel(a0)
                jsr     Find_SonicTails(pc)
                move.w  #-$200,d1
                tst.b   (_unkFAA8).w
                beq.s   loc_547D6
                tst.w   d0
                beq.s   loc_547D6
                neg.w   d1

loc_547D6:
                move.w  d1,x_vel(a0)
                bsr.w   sub_54A68

loc_547DE:
                moveq   #0,d0
                btst    #3,(V_int_run_count+3).w
                bne.s   loc_547EA
                moveq   #1,d0

loc_547EA:
                move.b  d0,mapping_frame(a0)
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_547F2:
                jsr     Refresh_ChildPosition(pc)
                subq.w  #1,$2E(a0)
                bpl.s   loc_54808
                move.l  #loc_5480C,(a0)
                move.w  #$80,priority(a0)

loc_54808:
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_5480C:
                lea     (Player_1).w,a1
                move.w  #$300,d0
                move.w  #$100,d1
                moveq   #$10,d2
                move.w  #0,d3
                move.w  #-$30,d4
                sub.b   subtype(a0),d4
                bsr.w   sub_54946
                jsr     (MoveSprite2).l
                bsr.w   sub_54A68
                tst.b   (_unkFAA8).w
                bne.s   loc_54846
                move.l  #loc_54848,(a0)
                bset    #0,render_flags(a0)

loc_54846:
                bra.s   loc_547DE
; ---------------------------------------------------------------------------

loc_54848:
                subq.w  #2,x_pos(a0)
                bra.s   loc_547DE

; =============== S U B R O U T I N E =======================================

sub_5484E:
                subq.w  #1,$2E(a0)
                bpl.s   locret_54886
                lea     (Player_1).w,a1
                btst    #7,status(a1)
                bne.s   locret_54886
                btst    #Status_InAir,status(a1)
                bne.s   locret_54886
                cmpi.b  #6,routine(a1)
                bhs.s   locret_54886
                move.b  d0,routine(a0)
                bsr.w   Set_PlayerEndingPose
                jsr     (AllocateObject).l
                bne.s   locret_54886
                move.l  #Obj_LevelResults,(a1)

locret_54886:
                rts
; End of function sub_5484E

; =============== S U B R O U T I N E =======================================

Check_TailsEndPose:
                tst.b   (_unkFAA8).w
                beq.w   locret_545B2
                cmpi.b  #3,(Current_zone).w
                bne.s   loc_548A0
                lea     (Player_1).w,a1
                bsr.w   Set_PlayerEndingPose

loc_548A0:
                btst    #7,$38(a0)
                bne.w   locret_545B2
                lea     (Player_2).w,a1
                btst    #7,status(a1)
                bne.w   locret_545B2
                btst    #Status_InAir,status(a1)
                bne.w   locret_545B2
                cmpi.b  #6,routine(a1)
                bhs.w   locret_545B2
                bset    #7,$38(a0)
                clr.b   (Ctrl_2_locked).w
                jmp     Set_PlayerEndingPose(pc)
; End of function Check_TailsEndPose

; =============== S U B R O U T I N E =======================================

sub_548DA:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5491A
                lea     (Player_1).w,a1
                cmpi.b  #6,routine(a1)
                bhs.s   locret_5491A
                tst.b   render_flags(a1)
                bpl.s   locret_5491A
                cmpi.b  #1,$38(a1)
                beq.s   loc_54900
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   locret_5491A

loc_54900:
                move.w  #-$100,x_vel(a0)
                move.b  d0,routine(a0)
                jsr     (AllocateObject).l
                bne.s   loc_54918
                move.l  #Obj_LevelResults,(a1)

loc_54918:
                moveq   #1,d0

locret_5491A:
                rts
; End of function sub_548DA

; =============== S U B R O U T I N E =======================================

Set_PlayerEndingPose:
                move.b  #$81,object_control(a1)
                move.b  #$13,anim(a1)
                clr.b   spin_dash_flag(a1)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                bclr    #5,status(a0)
                bclr    #Status_Push,status(a1)
                rts
; End of function Set_PlayerEndingPose

; =============== S U B R O U T I N E =======================================

sub_54946:
                move.w  d2,d5
                move.w  x_pos(a1),d6
                add.w   d3,d6
                cmp.w   x_pos(a0),d6
                bhs.s   loc_54956
                neg.w   d2

loc_54956:
                move.w  x_vel(a0),d6
                add.w   d2,d6
                cmp.w   d0,d6
                bgt.s   loc_5496A
                neg.w   d0
                cmp.w   d0,d6
                blt.s   loc_5496A
                move.w  d6,x_vel(a0)

loc_5496A:
                move.w  y_pos(a1),d6
                add.w   d4,d6
                cmp.w   y_pos(a0),d6
                bhs.s   loc_54978
                neg.w   d5

loc_54978:
                move.w  y_vel(a0),d6
                add.w   d5,d6
                cmp.w   d1,d6
                bgt.s   locret_5498C
                neg.w   d1
                cmp.w   d1,d6
                blt.s   loc_5496A
                move.w  d6,y_vel(a0)

locret_5498C:
                rts
; End of function sub_54946

; ---------------------------------------------------------------------------
; unused
                moveq   #$2B,d1
                moveq   #$18,d2
                moveq   #$18,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l

; =============== S U B R O U T I N E =======================================

sub_5499E:
                moveq   #8,d2

loc_549A0:
                moveq   #$1B,d1
                moveq   #9,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function sub_5499E

; =============== S U B R O U T I N E =======================================

sub_549AE:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  byte_549BE(pc,d0.w),mapping_frame(a0)
                rts
; End of function sub_549AE

; ---------------------------------------------------------------------------
byte_549BE:
                dc.b    2,   3,  $A,   4,  $B
                even

; =============== S U B R O U T I N E =======================================

sub_549C4:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                andi.w  #6,d0
                lea     word_54A58(pc),a1
                move.w  (a1,d0.w),d2
                move.w  d2,y_vel(a0)
                move.w  d2,$3E(a0)
                movea.w parent3(a0),a1
                btst    #1,render_flags(a1)
                beq.s   loc_549FA
                move.l  #loc_547F2,(a0)
                addq.b  #8,child_dy(a0)
                clr.w   y_vel(a0)

loc_549FA:
                andi.w  #2,d0
                move.w  d0,d2
                cmpi.w  #$400,(Current_zone_and_act).w
                bne.s   loc_54A0A
                addq.w  #4,d2

loc_54A0A:
                move.w  word_54A60(pc,d2.w),art_tile(a0)
                moveq   #0,d2
                move.b  (Current_zone).w,d2
                add.w   d2,d2
                lea     (byte_2BDDA).l,a1
                adda.w  d2,a1
                lsr.w   #1,d0
                move.b  (a1,d0.w),d0
                lsl.w   #3,d0
                lea     (word_2BDF4).l,a2
                move.l  4(a2,d0.w),mappings(a0)
                lsl.w   #2,d1
                move.w  d1,$2E(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a0),d0
                move.w  #$200,d1
                cmp.w   x_pos(a1),d0
                bhs.s   loc_54A4E
                neg.w   d1

loc_54A4E:
                move.w  d1,x_vel(a0)
                bsr.w   sub_54A68
                rts
; End of function sub_549C4

; ---------------------------------------------------------------------------
word_54A58:
                dc.w    -$380, -$300, -$280, -$200
word_54A60:
                dc.w    make_art_tile(ArtTile_Animals1,0,1)
                dc.w    make_art_tile(ArtTile_Animals2,0,1)
                dc.w    make_art_tile(ArtTile_FBZAnimals1,0,1)
                dc.w    make_art_tile(ArtTile_FBZAnimals2,0,1)

; =============== S U B R O U T I N E =======================================

sub_54A68:
                bclr    #0,render_flags(a0)
                tst.w   x_vel(a0)
                bpl.s   locret_54A7A
                bset    #0,render_flags(a0)

locret_54A7A:
                rts
; End of function sub_54A68

; ---------------------------------------------------------------------------
ObjDat_EggCapsule:
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_EggCapsule,0,1)
                dc.w    $200
                dc.b    $20, $20,   0,   0
word_54A88:
                dc.w    $200
                dc.b    $10,   8,   5,   0
ObjDat3_54A8E:
                dc.l    Map_EggCapsule
                dc.w    make_art_tile(ArtTile_EggCapsule,0,1)
                dc.w    $180
                dc.b    $C,  $C,   0,   0
word_54A9A:
                dc.w    $280
                dc.b    8,   8,   2,   0
word_54AA0:
                dc.w    $200
                dc.b    $14,   4,   6,   0
ChildObjDat_54AA6:
                dc.w    1-1
                dc.l    loc_54672
                dc.b    0,-$28
ChildObjDat_54AAE:
                dc.w    1-1
                dc.l    loc_546AE
                dc.b    0, $28
ChildObjDat_54AB6:
                dc.w    2-1
                dc.l    loc_54758
                dc.b    -$14,-$24
                dc.l    loc_54758
                dc.b    $14,-$24
ChildObjDat_54AC4:
                dc.w    5-1
                dc.l    loc_5472C
                dc.b    0,  -8
                dc.l    loc_5472C
                dc.b    -$10,  -8
                dc.l    loc_5472C
                dc.b    $10,  -8
                dc.l    loc_5472C
                dc.b    -$18,  -8
                dc.l    loc_5472C
                dc.b    $18,  -8
ChildObjDat_54AE4:
                dc.w    9-1                             ; 15 entries are defined below
                dc.l    loc_54776
                dc.b    0,  -4
                dc.l    loc_54776
                dc.b    -8,  -4
                dc.l    loc_54776
                dc.b    8,  -4
                dc.l    loc_54776
                dc.b    $10,  -4
                dc.l    loc_54776
                dc.b    -$10,  -4
                dc.l    loc_54776
                dc.b    -$18,  -4
                dc.l    loc_54776
                dc.b    $18,  -4
                dc.l    loc_54776
                dc.b    -4,  -4
                dc.l    loc_54776
                dc.b    4,  -4
                dc.l    loc_54776
                dc.b    $C,  -4
                dc.l    loc_54776
                dc.b    -$C,  -4
                dc.l    loc_54776
                dc.b    -$14,  -4
                dc.l    loc_54776
                dc.b    $14,  -4
                dc.l    loc_54776
                dc.b    $1C,  -4
                dc.l    loc_54776
                dc.b    -$1C,  -4
byte_54B40:
                dc.b    0,   6,   7,   8,   9, $FC
                even
; ---------------------------------------------------------------------------

loc_54B46:
                movea.l $3E(a0),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_54B5A,(a0)
                bset    #3,shield_reaction(a0)

loc_54B5A:
                movea.l $34(a0),a1
                jsr     (a1)
                jmp     (Sprite_CheckDeleteTouchXY).l
; ---------------------------------------------------------------------------

Obj_Bloominator:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Bloominator_Index(pc,d0.w),d1
                jsr     Bloominator_Index(pc,d1.w)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
Bloominator_Index:
                dc.w    loc_54B86-Bloominator_Index
                dc.w    loc_54B9E-Bloominator_Index
                dc.w    loc_54BC2-Bloominator_Index
; ---------------------------------------------------------------------------

loc_54B86:
                lea     ObjDat_Bloominator(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #$1F,$2E(a0)
                move.l  #loc_54BAA,$34(a0)

locret_54B9C:
                rts
; ---------------------------------------------------------------------------

loc_54B9E:
                tst.b   render_flags(a0)
                bpl.w   locret_54B9C
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_54BAA:
                move.b  #4,routine(a0)
                move.l  #byte_54C3E,$30(a0)
                move.l  #loc_54BF8,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_54BC2:
                jsr     Animate_RawMultiDelay(pc)
                beq.s   locret_54B9C
                cmpi.b  #6,d0
                beq.s   loc_54BD4
                cmpi.b  #$E,d0
                bne.s   locret_54B9C

loc_54BD4:
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_54C26(pc),a2
                jsr     CreateChild2_Complex(pc)
                bne.s   locret_54BF6
                addq.b  #1,$39(a0)
                btst    #0,$39(a0)
                beq.s   locret_54BF6
                neg.w   x_vel(a1)

locret_54BF6:
                rts
; ---------------------------------------------------------------------------

loc_54BF8:
                move.b  #2,routine(a0)
                move.w  #2*60,$2E(a0)
                move.l  #loc_54BAA,$34(a0)
                rts
; ---------------------------------------------------------------------------
ObjDat_Bloominator:
                dc.l    Map_Bloominator
                dc.w    make_art_tile(ArtTile_Bloominator,1,0)
                dc.w    $200
                dc.b    $C, $18,   0, $23
ObjDat3_54C1A:
                dc.l    Map_Bloominator
                dc.w    make_art_tile(ArtTile_Bloominator,1,0)
                dc.w    $280
                dc.b    8,   8,   4, $98
ChildObjDat_54C26:
                dc.w    1-1
                dc.l    loc_54B46
                dc.l    ObjDat3_54C1A
                dc.l    0
                dc.l    MoveSprite
                dc.b    0,-$10
                dc.w    $100, -$500
byte_54C3E:
                dc.b    0,   7
                dc.b    1,   9
                dc.b    2,   4
                dc.b    3,   4
                dc.b    0,   9
                dc.b    1,   9
                dc.b    2,   4
                dc.b    3,   4
                dc.b    0,   0
                dc.b    $F4
                even
; ---------------------------------------------------------------------------

Obj_Rhinobot:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Rhinobot_Index(pc,d0.w),d1
                jsr     Rhinobot_Index(pc,d1.w)
                lea     DPLCPtr_AIZRhinobot(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Sprite_CheckDeleteTouchSlotted(pc)
; ---------------------------------------------------------------------------
Rhinobot_Index:
                dc.w    loc_54C7A-Rhinobot_Index
                dc.w    loc_54CC0-Rhinobot_Index
                dc.w    loc_54CE6-Rhinobot_Index
                dc.w    loc_54CEA-Rhinobot_Index
; ---------------------------------------------------------------------------

loc_54C7A:
                lea     ObjSlot_Rhinobot(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.b  #8,x_radius(a0)
                move.b  #$10,y_radius(a0)
                move.w  #-$10,d0
                move.w  #-$300,d1
                btst    #0,render_flags(a0)
                beq.s   loc_54CAE
                neg.w   d0
                neg.w   d1
                bset    #3,$38(a0)
                bset    #2,$38(a0)

loc_54CAE:
                move.w  d0,$40(a0)
                move.w  d1,$3E(a0)
                move.l  #loc_54D3C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_54CC0:
                lea     loc_54D8E(pc),a3
                bsr.w   sub_54EA0
                lea     loc_54D70(pc),a3
                bsr.w   sub_54EC6
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                bsr.w   sub_54DF4
                bra.w   loc_54E18
; ---------------------------------------------------------------------------

loc_54CE6:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_54CEA:
                lea     loc_54DE4(pc),a3
                bsr.w   sub_54EC6
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_54CF8:
                cmpi.w  #1,(Current_zone_and_act).w
                beq.s   loc_54D22
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_54D1E(pc,d0.w),d1
                jsr     off_54D1E(pc,d1.w)
                lea     DPLCPtr_AIZRhinobot(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Child_Remember_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_54D1E:
                dc.w    loc_54D28-off_54D1E
                dc.w    loc_54D38-off_54D1E
; ---------------------------------------------------------------------------

loc_54D22:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_54D28:
                lea     ObjSlot_54F0C(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.l  #Go_Delete_SpriteSlotted3,$34(a0)

loc_54D38:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_54D3C:
                bchg    #2,$38(a0)
                move.l  #loc_54D54,$34(a0)
                neg.w   $40(a0)
                neg.w   $3E(a0)
                rts
; ---------------------------------------------------------------------------

loc_54D54:
                bchg    #3,$38(a0)
                bchg    #0,render_flags(a0)
                bclr    #1,$38(a0)
                move.l  #loc_54D3C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_54D70:
                bclr    #2,$38(a0)
                btst    #3,$38(a0)
                bne.s   loc_54D84
                bset    #2,$38(a0)

loc_54D84:
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                bra.s   loc_54D54
; ---------------------------------------------------------------------------

loc_54D8E:
                move.b  #4,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.w  #$20,$2E(a0)
                move.l  #loc_54DCA,$34(a0)
                bset    #1,$38(a0)
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_54F26(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_54DC8
                move.l  #byte_54F46,$30(a1)

locret_54DC8:
                rts
; ---------------------------------------------------------------------------

loc_54DCA:
                move.b  #6,routine(a0)
                move.w  #$400,d0
                btst    #3,$38(a0)
                bne.s   loc_54DDE
                neg.w   d0

loc_54DDE:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_54DE4:
                move.b  #2,routine(a0)
                move.b  #0,mapping_frame(a0)
                bra.w   loc_54D70

; =============== S U B R O U T I N E =======================================

sub_54DF4:
                move.w  x_vel(a0),d0
                beq.s   loc_54E12
                btst    #2,$38(a0)
                beq.s   loc_54E0A
                cmp.w   $3E(a0),d0
                bge.s   loc_54E12
                rts
; ---------------------------------------------------------------------------

loc_54E0A:
                cmp.w   $3E(a0),d0
                ble.s   loc_54E12
                rts
; ---------------------------------------------------------------------------

loc_54E12:
                movea.l $34(a0),a1
                jmp     (a1)
; End of function sub_54DF4

; ---------------------------------------------------------------------------

loc_54E18:
                moveq   #0,d1
                btst    #3,$38(a0)
                beq.s   loc_54E50
                btst    #2,$38(a0)
                beq.s   loc_54E38
                cmpi.w  #$80,x_vel(a0)
                bgt.s   loc_54E7A
                moveq   #1,d1
                bra.w   loc_54E7A
; ---------------------------------------------------------------------------

loc_54E38:
                moveq   #1,d1
                cmpi.w  #$280,x_vel(a0)
                bgt.s   loc_54E7A
                moveq   #2,d1
                bset    #1,$38(a0)
                beq.s   loc_54E80
                bra.w   loc_54E7A
; ---------------------------------------------------------------------------

loc_54E50:
                btst    #2,$38(a0)
                bne.s   loc_54E66
                cmpi.w  #-$80,x_vel(a0)
                ble.s   loc_54E7A
                moveq   #1,d1
                bra.w   loc_54E7A
; ---------------------------------------------------------------------------

loc_54E66:
                moveq   #1,d1
                cmpi.w  #-$280,x_vel(a0)
                ble.s   loc_54E7A
                moveq   #2,d1
                bset    #1,$38(a0)
                beq.s   loc_54E80

loc_54E7A:
                move.b  d1,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_54E80:
                move.b  d1,mapping_frame(a0)
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_54F1E(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_54E9E
                move.l  #byte_54F36,$30(a1)

locret_54E9E:
                rts

; =============== S U B R O U T I N E =======================================

sub_54EA0:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$20,d3
                bhi.s   locret_54EBE
                cmpi.w  #$60,d2
                bhi.s   locret_54EBE
                btst    #3,$38(a0)
                bne.s   loc_54EBA
                subq.w  #2,d0

loc_54EBA:
                tst.w   d0
                bne.s   loc_54EC0

locret_54EBE:
                rts
; ---------------------------------------------------------------------------

loc_54EC0:
                jsr     (a3)
                addq.w  #4,sp
                rts
; End of function sub_54EA0

; =============== S U B R O U T I N E =======================================

sub_54EC6:
                moveq   #4,d0
                btst    #3,$38(a0)
                bne.s   loc_54ED2
                neg.w   d0

loc_54ED2:
                move.w  x_pos(a0),d3
                add.w   d0,d3
                move.l  a3,-(sp)
                jsr     (ObjCheckFloorDist2).l
                movea.l (sp)+,a3
                cmpi.w  #-1,d1
                blt.s   loc_54EF4
                cmpi.w  #$C,d1
                bge.s   loc_54EF4
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_54EF4:
                jsr     (a3)
                addq.w  #4,sp
                rts
; End of function sub_54EC6

; ---------------------------------------------------------------------------
ObjSlot_Rhinobot:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Rhinobot,1,0)
                dc.w    $15,     0
                dc.l    Map_Rhinobot
                dc.w    $280
                dc.b    $14, $10,   0,  $B
ObjSlot_54F0C:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Rhinobot-$B6,0,0)
                dc.w    6,     2
                dc.l    Map_Rhinobot
                dc.w    $200
                dc.b    $C,   8,   4,   0
ChildObjDat_54F1E:
                dc.w    1-1
                dc.l    loc_54CF8
                dc.b    $C,   8
ChildObjDat_54F26:
                dc.w    1-1
                dc.l    loc_54CF8
                dc.b    $10,   8
DPLCPtr_AIZRhinobot:
                dc.l    ArtUnc_AIZRhinobot
                dc.l    DPLC_Rhinobot
byte_54F36:
                dc.b    2,   4,   4,   5,   6,   7,   4,   5,   6,   7,   4,   5,   6,   7, $F4
                even
byte_54F46:
                dc.b    2,   4,   4,   5,   6,   7,   4,   5,   6,   7, $F4
                even
; ---------------------------------------------------------------------------

Obj_MonkeyDude:
                jsr     Obj_WaitOffscreen(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MonkeyDude_Index(pc,d0.w),d1
                jsr     MonkeyDude_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
MonkeyDude_Index:
                dc.w    loc_54F6E-MonkeyDude_Index
                dc.w    loc_54FB8-MonkeyDude_Index
                dc.w    loc_54FD6-MonkeyDude_Index
; ---------------------------------------------------------------------------

loc_54F6E:
                lea     ObjDat_MonkeyDude(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #2,d0
                move.b  d0,subtype(a0)
                lsr.w   #1,d0
                move.b  d0,$39(a0)
                move.l  #byte_554B0,$30(a0)
                move.w  #60-1,$2E(a0)
                move.l  #loc_54FBE,$34(a0)
                btst    #0,render_flags(a0)
                bne.w   loc_54FB0
                lea     ChildObjDat_5547C(pc),a2
                jmp     CreateChild4_LinkListRepeated(pc)
; ---------------------------------------------------------------------------

loc_54FB0:
                lea     ChildObjDat_55482(pc),a2
                jmp     CreateChild4_LinkListRepeated(pc)
; ---------------------------------------------------------------------------

loc_54FB8:
                jmp     (loc_53CD6).l
; ---------------------------------------------------------------------------

loc_54FBE:
                move.b  #4,routine(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #byte_554B4,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_54FD6:
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   locret_54FFE
                btst    #2,$38(a0)
                bne.s   loc_55000
                cmpi.b  #0,mapping_frame(a0)
                bne.s   locret_54FFE
                addq.w  #8,y_pos(a0)
                subq.b  #1,$39(a0)
                cmpi.b  #1,$39(a0)
                beq.s   loc_55014

locret_54FFE:
                rts
; ---------------------------------------------------------------------------

loc_55000:
                cmpi.b  #2,mapping_frame(a0)
                bne.s   locret_54FFE
                subq.b  #1,$39(a0)
                beq.s   loc_55014
                subq.w  #8,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_55014:
                move.b  #2,routine(a0)
                move.b  subtype(a0),$39(a0)
                bchg    #2,$38(a0)
                move.w  #60-1,$2E(a0)
                move.l  #byte_554B0,$30(a0)
                move.b  #0,mapping_frame(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_55044:
                bset    #3,$38(a0)

loc_5504A:
                lea     word_55462(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                clr.b   routine(a0)
                move.b  subtype(a0),d0
                add.b   d0,d0
                move.b  d0,$3B(a0)
                move.b  d0,$3A(a0)
                tst.b   subtype(a0)
                bne.s   loc_5508E
                move.l  #loc_550C8,(a0)
                moveq   #$E,d0
                btst    #3,$38(a0)
                bne.s   loc_5507C
                neg.w   d0

loc_5507C:
                add.w   d0,x_pos(a0)
                subq.w  #2,y_pos(a0)
                move.w  y_pos(a0),$3E(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_5508E:
                cmpi.b  #8,subtype(a0)
                beq.s   loc_550A0
                move.l  #loc_55218,(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_550A0:
                move.l  #loc_55248,(a0)
                move.b  #6,mapping_frame(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                move.w  a1,$3E(a0)
                movea.w parent3(a1),a1
                movea.w parent3(a1),a1
                move.w  a1,$44(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_550C8:
                bsr.w   sub_552FC
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_550DE(pc,d0.w),d1
                jsr     off_550DE(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_550DE:
                dc.w    loc_550EA-off_550DE
                dc.w    loc_55126-off_550DE
                dc.w    loc_5517E-off_550DE
                dc.w    loc_551B0-off_550DE
                dc.w    loc_551E6-off_550DE
                dc.w    loc_5512C-off_550DE
; ---------------------------------------------------------------------------

loc_550EA:
                move.b  $3C(a0),d0
                btst    #3,$38(a0)
                beq.s   loc_55104
                addq.b  #4,d0
                cmpi.b  #$80,d0
                bhs.s   loc_55112
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

loc_55104:
                subq.b  #4,d0
                cmpi.b  #$80,d0
                bls.s   loc_55112
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

loc_55112:
                move.b  #2,routine(a0)

loc_55118:
                bsr.w   sub_55434
                move.l  #loc_5516C,$34(a0)

locret_55124:
                rts
; ---------------------------------------------------------------------------

loc_55126:
                bsr.w   sub_55320
                beq.s   loc_55170

loc_5512C:
                btst    #3,$38(a0)
                beq.s   loc_5514A
                move.b  $41(a0),d1
                bsr.w   sub_5533C
                subi.b  #$20,d0
                cmpi.b  #$60,d0
                bhs.s   loc_5515C
                bra.w   loc_55168
; ---------------------------------------------------------------------------

loc_5514A:
                move.b  $41(a0),d1
                bsr.w   sub_5533C
                subi.b  #$80,d0
                cmpi.b  #$60,d0
                blo.s   loc_55168

loc_5515C:
                neg.w   $40(a0)
                move.b  $41(a0),d1
                bsr.w   sub_5533C

loc_55168:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5516C:
                bra.w   sub_55434
; ---------------------------------------------------------------------------

loc_55170:
                move.b  #4,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_5517E:
                btst    #3,$38(a0)
                beq.s   loc_55194
                moveq   #4,d1
                bsr.w   sub_5533C
                cmpi.b  #-$40,d0
                bhs.s   loc_551A2
                rts
; ---------------------------------------------------------------------------

loc_55194:
                moveq   #-4,d1
                bsr.w   sub_5533C
                cmpi.b  #$40,d0
                bls.s   loc_551A2
                rts
; ---------------------------------------------------------------------------

loc_551A2:
                move.b  #6,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_551B0:
                btst    #3,$38(a0)
                beq.s   loc_551C6
                moveq   #-8,d1
                bsr.w   sub_5533C
                moveq   #$60,d1
                cmp.b   d1,d0
                bls.s   loc_551D4
                rts
; ---------------------------------------------------------------------------

loc_551C6:
                moveq   #8,d1
                bsr.w   sub_5533C
                moveq   #-$60,d1
                cmp.b   d1,d0
                bhs.s   loc_551D4
                rts
; ---------------------------------------------------------------------------

loc_551D4:
                move.b  #8,routine(a0)
                move.b  d1,$3C(a0)
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_551E6:
                btst    #3,$38(a0)
                bne.s   loc_551FC
                moveq   #-2,d1
                bsr.w   sub_5533C
                moveq   #-$80,d1
                cmp.b   d1,d0
                bls.s   loc_5520A
                rts
; ---------------------------------------------------------------------------

loc_551FC:
                moveq   #2,d1
                bsr.w   sub_5533C
                moveq   #-$80,d1
                cmp.b   d1,d0
                bhs.s   loc_5520A
                rts
; ---------------------------------------------------------------------------

loc_5520A:
                move.b  #$A,routine(a0)
                move.b  d1,$3C(a0)
                bra.w   loc_55118
; ---------------------------------------------------------------------------

loc_55218:
                bsr.w   sub_55314
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5522E(pc,d0.w),d1
                jsr     off_5522E(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_5522E:
                dc.w    loc_55234-off_5522E
                dc.w    loc_5523E-off_5522E
                dc.w    loc_5523A-off_5522E
; ---------------------------------------------------------------------------

loc_55234:
                moveq   #2,d1
                bsr.w   sub_55366

loc_5523A:
                bra.w   loc_55348
; ---------------------------------------------------------------------------

loc_5523E:
                moveq   #4,d1
                bsr.w   sub_5538E
                bra.w   loc_55348
; ---------------------------------------------------------------------------

loc_55248:
                bsr.w   sub_55314
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5525E(pc,d0.w),d1
                jsr     off_5525E(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_5525E:
                dc.w    loc_55264-off_5525E
                dc.w    loc_5526E-off_5525E
                dc.w    loc_5526A-off_5525E
; ---------------------------------------------------------------------------

loc_55264:
                moveq   #2,d1
                bsr.w   sub_55366

loc_5526A:
                bra.w   loc_55348
; ---------------------------------------------------------------------------

loc_5526E:
                bsr.w   sub_553B0
                moveq   #4,d1
                bsr.w   sub_5538E
                bra.w   loc_55348
; ---------------------------------------------------------------------------

loc_5527C:
                lea     word_55468(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_552B2,(a0)
                move.l  #byte_554B9,$30(a0)
                move.l  #loc_552C6,$34(a0)
                move.b  #8,y_radius(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

loc_552B2:
                jsr     (MoveSprite_LightGravity).l
                jsr     Animate_RawMultiDelay(pc)
                jsr     ObjHitFloor_DoRoutine(pc)
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

loc_552C6:
                move.l  #loc_552CE,(a0)
                rts
; ---------------------------------------------------------------------------

loc_552CE:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------
; unused
                movea.w parent3(a0),a1
                move.b  render_flags(a1),d0
                btst    #3,$38(a0)
                beq.s   loc_552E8
                bchg    #0,d0

loc_552E8:
                move.w  #$200,priority(a0)
                btst    #0,d0
                beq.s   locret_552FA
                move.w  #$300,priority(a0)

locret_552FA:
                rts

; =============== S U B R O U T I N E =======================================

sub_552FC:
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                subq.w  #2,d0
                tst.b   mapping_frame(a1)
                beq.s   loc_5530E
                subq.w  #2,d0

loc_5530E:
                move.w  d0,y_pos(a0)
                rts
; End of function sub_552FC

; =============== S U B R O U T I N E =======================================

sub_55314:
                movea.w parent3(a0),a1
                move.w  priority(a1),priority(a0)
                rts
; End of function sub_55314

; =============== S U B R O U T I N E =======================================

sub_55320:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                bhs.s   loc_55338
                btst    #3,$38(a0)
                beq.s   loc_55334
                subq.w  #2,d0

loc_55334:
                tst.w   d0
                rts
; ---------------------------------------------------------------------------

loc_55338:
                moveq   #1,d4
                rts
; End of function sub_55320

; =============== S U B R O U T I N E =======================================

sub_5533C:
                move.b  $3C(a0),d0
                add.b   d1,d0
                move.b  d0,$3C(a0)
                rts
; End of function sub_5533C

; ---------------------------------------------------------------------------

loc_55348:
                subq.b  #1,$3B(a0)
                bne.s   loc_5535E
                move.b  $3A(a0),$3B(a0)
                movea.w parent3(a0),a1
                move.b  $3C(a1),$3C(a0)

loc_5535E:
                moveq   #5,d2
                jsr     MoveSprite_CircularSimple(pc)
                rts

; =============== S U B R O U T I N E =======================================

sub_55366:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   locret_5538C
                move.b  d1,routine(a0)
                bset    #1,$38(a0)
                move.b  $3A(a0),d0
                lsr.b   #1,d0
                move.b  d0,$3A(a0)
                move.b  #1,$3B(a0)

locret_5538C:
                rts
; End of function sub_55366

; =============== S U B R O U T I N E =======================================

sub_5538E:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   locret_553AE
                move.b  d1,routine(a0)
                move.b  $3A(a0),d0
                add.b   d0,d0
                move.b  d0,$3A(a0)
                move.b  #1,$3B(a0)

locret_553AE:
                rts
; End of function sub_5538E

; =============== S U B R O U T I N E =======================================

sub_553B0:
                btst    #3,$38(a0)
                beq.s   loc_553DC
                btst    #0,$38(a0)
                bne.w   locret_55124
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                beq.s   locret_553DA
                movea.w $3E(a0),a1
                cmpi.b  #-$7C,$3C(a1)
                blo.s   loc_55406

locret_553DA:
                rts
; ---------------------------------------------------------------------------

loc_553DC:
                btst    #0,$38(a0)
                bne.w   locret_55124
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                beq.s   locret_553DA
                movea.w $3E(a0),a1
                cmpi.b  #$7C,$3C(a1)
                blo.w   locret_55124
                move.w  #make_art_tile(ArtTile_MonkeyDude,1,0),art_tile(a0)

loc_55406:
                bset    #0,$38(a0)
                move.b  #4,mapping_frame(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l
                lea     (ChildObjDat_55498).l,a2
                jsr     CreateChild2_Complex(pc)
                bne.s   locret_553DA
                btst    #3,$38(a0)
                beq.s   locret_553DA
                neg.w   x_vel(a1)
                rts
; End of function sub_553B0

; =============== S U B R O U T I N E =======================================

sub_55434:
                jsr     (Random_Number).l
                move.w  (RNG_seed).w,d0
                moveq   #1,d1
                btst    #0,d0
                beq.s   loc_55448
                neg.w   d1

loc_55448:
                move.w  d1,$40(a0)
                andi.w  #$3C,d0
                move.w  d0,$2E(a0)
                rts
; End of function sub_55434

; ---------------------------------------------------------------------------
ObjDat_MonkeyDude:
                dc.l    Map_MonkeyDude
                dc.w    make_art_tile(ArtTile_MonkeyDude,1,0)
                dc.w    $280
                dc.b    $20, $20,   0,  $B
word_55462:
                dc.w    $300
                dc.b    4,   4,   3,   0
word_55468:
                dc.w    make_art_tile(ArtTile_MonkeyDude,1,1)
                dc.w    $280
                dc.b    $20, $20,   6,  $B
ObjDat3_55470:
                dc.l    Map_MonkeyDude
                dc.w    make_art_tile(ArtTile_MonkeyDude,0,0)
                dc.w    $280
                dc.b    $20, $20,   6, $98
ChildObjDat_5547C:
                dc.w    5-1
                dc.l    loc_5504A
ChildObjDat_55482:
                dc.w    5-1
                dc.l    loc_55044
                dc.w    1-1
                dc.l    loc_5504A
                dc.b    0,   8
                dc.w    1-1
                dc.l    loc_5527C
                dc.b    0,   0
ChildObjDat_55498:
                dc.w    1-1
                dc.l    loc_54B46
                dc.l    ObjDat3_55470
                dc.l    0
                dc.l    MoveSprite_LightGravity
                dc.b    0,   0
                dc.w    -$200, -$400
byte_554B0:
                dc.b    7,   0,   1, $FC
byte_554B4:
                dc.b    0,   7
                dc.b    2,   7
                dc.b    $FC
byte_554B9:
                dc.b    8,  $F
                dc.b    8,  $F
                dc.b    9,  $F
                dc.b    $A,  $F
                dc.b    $F8, .jump-byte_554B9

                .jump:
                dc.b    6, $7E
                dc.b    $FC
                even
; ---------------------------------------------------------------------------

Obj_CaterKillerJr:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CaterKillerJr_Index(pc,d0.w),d1
                jsr     CaterKillerJr_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
CaterKillerJr_Index:
                dc.w    loc_554E8-CaterKillerJr_Index
                dc.w    loc_55524-CaterKillerJr_Index
                dc.w    loc_55524-CaterKillerJr_Index
                dc.w    loc_55554-CaterKillerJr_Index
                dc.w    loc_55576-CaterKillerJr_Index
; ---------------------------------------------------------------------------

loc_554E8:
                lea     ObjDat_CaterKillerJr(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #-$100,x_vel(a0)
                lea     ChildObjDat_55694(pc),a2
                jsr     CreateChild3_NormalRepeated(pc)

loc_554FE:
                move.b  #4,routine(a0)
                move.b  #3,$39(a0)
                move.w  #$80,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_55524:
                jsr     Swing_UpAndDown_Count(pc)
                bne.s   loc_55534
                jsr     (MoveSprite2).l
                bra.w   loc_5563A
; ---------------------------------------------------------------------------

loc_55534:
                move.b  #6,routine(a0)
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_55554:
                jsr     Swing_UpAndDown(pc)
                tst.w   d3
                beq.s   loc_5556C
                move.b  #8,routine(a0)
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_5556C:
                jsr     (MoveSprite2).l
                bra.w   loc_5563A
; ---------------------------------------------------------------------------

loc_55576:
                jsr     Swing_UpAndDown(pc)
                tst.w   d3
                bne.s   loc_554FE
                jsr     (MoveSprite2).l
                bra.w   loc_5563A
; ---------------------------------------------------------------------------

loc_55588:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5559E(pc,d0.w),d1
                jsr     off_5559E(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_5559E:
                dc.w    loc_555A8-off_5559E
                dc.w    loc_555D4-off_5559E
                dc.w    loc_55524-off_5559E
                dc.w    loc_55554-off_5559E
                dc.w    loc_55576-off_5559E
; ---------------------------------------------------------------------------

loc_555A8:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  off_555C2(pc,d0.w),d1
                lea     off_555C2(pc,d1.w),a1
                lsr.w   #1,d0
                move.b  byte_555CE(pc,d0.w),$2F(a0)
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------
off_555C2:
                dc.w    ObjDat3_5566A-off_555C2
                dc.w    ObjDat3_5566A-off_555C2
                dc.w    ObjDat3_5566A-off_555C2
                dc.w    ObjDat3_55676-off_555C2
                dc.w    ObjDat3_55682-off_555C2
                dc.w    ObjDat3_55682-off_555C2
byte_555CE:
                dc.b    $B, $17, $23, $2F, $37, $3F
                even
; ---------------------------------------------------------------------------

loc_555D4:
                subq.w  #1,$2E(a0)
                bmi.s   loc_555DC
                rts
; ---------------------------------------------------------------------------

loc_555DC:
                move.b  #4,routine(a0)
                moveq   #$40,d1
                moveq   #0,d0
                move.b  subtype(a0),d0
                addq.w  #2,d0
                lsl.w   #2,d0
                sub.w   d0,d1
                move.w  d1,$2E(a0)
                move.l  #loc_55650,$34(a0)
                move.w  #-$100,x_vel(a0)
                bra.w   loc_554FE
; ---------------------------------------------------------------------------

loc_55606:
                lea     word_5568E(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_55628,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                bset    #4,shield_reaction(a0)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_55628:
                jsr     Refresh_ChildPositionAdjusted(pc)
                lea     byte_556A4(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5563A:
                cmpi.l  #loc_55588,(a0)
                bne.s   locret_5564E
                cmpi.b  #6,subtype(a0)
                bhs.s   locret_5564E
                jsr     Obj_Wait(pc)

locret_5564E:
                rts
; ---------------------------------------------------------------------------

loc_55650:
                move.w  #$1A,$2E(a0)
                lea     ChildObjDat_5569C(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------
ObjDat_CaterKillerJr:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,   8,   0, $17
ObjDat3_5566A:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,  $C,   1, $97
ObjDat3_55676:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,   8,   2, $97
ObjDat3_55682:
                dc.l    Map_MonkeyDude
                dc.w    make_art_tile(ArtTile_MonkeyDude,1,1)
                dc.w    $280
                dc.b    4,   4,   3, $98
word_5568E:
                dc.w    $200
                dc.b    $10, $10,   3,   0
ChildObjDat_55694:
                dc.w    6-1
                dc.l    loc_55588
                dc.b    0,   0
ChildObjDat_5569C:
                dc.w    1-1
                dc.l    loc_55606
                dc.b    0,   0
byte_556A4:
                dc.b    3,   2
                dc.b    3,   2
                dc.b    4,   3
                dc.b    5,   4
                dc.b    $F4
                even
; ---------------------------------------------------------------------------

Obj_Jawz:
                jsr     (Obj_WaitOffscreen).l
                lea     ObjDat_Jawz(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_556CA,(a0)
                move.w  #-$200,d4
                jmp     Set_VelocityXTrackSonic(pc)
; ---------------------------------------------------------------------------

loc_556CA:
                jsr     (MoveSprite2).l
                lea     byte_55722(pc),a1
                jsr     Animate_RawNoSST(pc)
                moveq   #0,d0
                move.b  collision_property(a0),d0
                bne.s   loc_556E4
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_556E4:
                add.w   d0,d0
                movea.w word_55710-2(pc,d0.w),a1
                cmpi.b  #2,anim(a1)
                beq.s   loc_55708
                cmpi.b  #9,anim(a1)
                beq.s   loc_55708
                lea     (ChildObjDat_49BF4).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

loc_55708:
                move.w  a1,$44(a0)
                jmp     EnemyDefeat_Score(pc)
; ---------------------------------------------------------------------------
word_55710:
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_1
ObjDat_Jawz:
                dc.l    Map_Jawz
                dc.w    make_art_tile(ArtTile_Jawz,1,1)
                dc.w    $280
                dc.b    $1C,  $C,   0, $D7
byte_55722:
                dc.b    0,   0,   1, $FC
                even
; ---------------------------------------------------------------------------

Obj_Blastoid:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Blastoid_Index(pc,d0.w),d1
                jsr     Blastoid_Index(pc,d1.w)
                bsr.w   sub_557A6
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Blastoid_Index:
                dc.w    loc_55748-Blastoid_Index
                dc.w    loc_55750-Blastoid_Index
                dc.w    loc_55774-Blastoid_Index
; ---------------------------------------------------------------------------

loc_55748:
                lea     ObjDat_Blastoid(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_55750:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                blo.s   loc_5575C
                rts
; ---------------------------------------------------------------------------

loc_5575C:
                move.b  #4,routine(a0)
                move.l  #byte_557F6,$30(a0)
                move.l  #loc_5579E,$34(a0)

locret_55772:
                rts
; ---------------------------------------------------------------------------

loc_55774:
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   locret_55772
                bmi.s   locret_55772
                cmpi.b  #1,mapping_frame(a0)
                bne.s   locret_55772
                tst.b   render_flags(a0)
                bpl.w   locret_55772
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_557DE(pc),a2
                jmp     CreateChild5_ComplexAdjusted(pc)
; ---------------------------------------------------------------------------

loc_5579E:
                move.b  #2,routine(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_557A6:
                jsr     Check_PlayerCollision(pc)
                beq.w   locret_55772
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                st      (a3,d0.w)
                jmp     EnemyDefeat_Score(pc)
; End of function sub_557A6

; ---------------------------------------------------------------------------
; unused
                dc.w    Player_1
                dc.w    Player_2
ObjDat_Blastoid:
                dc.l    Map_Blastoid
                dc.w    make_art_tile(ArtTile_Blastoid,1,1)
                dc.w    $280
                dc.b    $14,  $C,   0, $D7
ObjDat3_557D2:
                dc.l    Map_Blastoid
                dc.w    make_art_tile(ArtTile_Blastoid,1,1)
                dc.w    $280
                dc.b    4,   4,   2, $98
ChildObjDat_557DE:
                dc.w    1-1
                dc.l    loc_54B46
                dc.l    ObjDat3_557D2
                dc.l    byte_55805
                dc.l    Move_AnimateRaw
                dc.b    -$14,  -7
                dc.w    -$200, -$100
byte_557F6:
                dc.b    0, $7F
                dc.b    1,   4
                dc.b    0,   9
                dc.b    1,   4
                dc.b    0,   9
                dc.b    1,   4
                dc.b    0, $3F
                dc.b    $F4
byte_55805:
                dc.b    0,   2,   3, $FC
                even
; ---------------------------------------------------------------------------

Obj_Buggernaut:
                jsr     (Obj_WaitOffscreen).l

Obj_Buggernaut_2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Buggernaut_Index(pc,d0.w),d1
                jsr     Buggernaut_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Buggernaut_Index:
                dc.w    loc_55828-Buggernaut_Index
                dc.w    loc_5585A-Buggernaut_Index
                dc.w    loc_55878-Buggernaut_Index
; ---------------------------------------------------------------------------

loc_55828:
                lea     ObjDat_Buggernaut(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AniRaw_Buggernaut,$30(a0)
                lea     ChildObjDat_Buggernaught_Baby(pc),a2
                jsr     CreateChild1_Normal(pc)
                addq.b  #1,$39(a0)

loc_55844:
                move.b  #2,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_55862,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5585A:
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_55862:
                move.b  #4,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_55844,$34(a0)

locret_55876:
                rts
; ---------------------------------------------------------------------------

loc_55878:
                tst.b   render_flags(a0)
                bpl.s   locret_55876
                jsr     Find_SonicTails(pc)
                jsr     Change_FlipX(pc)
                move.w  #$200,d0
                moveq   #$10,d1
                jsr     Chase_Object(pc)
                bsr.w   sub_5596E
                jsr     (MoveSprite2).l
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_Buggernaught_Baby:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Buggernaught_Baby_Index(pc,d0.w),d1
                jsr     Buggernaught_Baby_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------
Buggernaught_Baby_Index:
                dc.w    loc_558BA-Buggernaught_Baby_Index
                dc.w    loc_558CC-Buggernaught_Baby_Index
                dc.w    loc_55932-Buggernaught_Baby_Index
; ---------------------------------------------------------------------------

loc_558BA:
                lea     ObjDat3_Buggernaught_Baby(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #AniRaw_Buggernaut_Baby,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_558CC:
                jsr     Animate_Raw(pc)
                movea.w parent3(a0),a1
                cmpi.l  #Obj_Buggernaut_2,(a1)
                beq.s   loc_558E2
                bsr.w   sub_5593C
                beq.s   loc_5590A

loc_558E2:
                bclr    #0,render_flags(a0)
                btst    #0,render_flags(a1)
                beq.s   loc_558F6
                bset    #0,render_flags(a0)

loc_558F6:
                move.w  #$200,d0
                moveq   #$20,d1
                jsr     Chase_Object(pc)
                bsr.w   sub_5596E
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_5590A:
                move.b  #4,routine(a0)
                move.w  x_pos(a0),d0
                move.w  #$200,d1
                bset    #0,render_flags(a0)
                cmp.w   (Player_1+x_pos).w,d0
                bhs.s   loc_5592C
                neg.w   d1
                bclr    #0,render_flags(a0)

loc_5592C:
                move.w  d1,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_55932:
                jsr     Animate_Raw(pc)
                jmp     (MoveSprite2).l

; =============== S U B R O U T I N E =======================================

sub_5593C:
                lea     (Dynamic_object_RAM+object_size).w,a2
                move.w  #((Breathing_bubbles)-(Dynamic_object_RAM+object_size))/object_size-1,d0

loc_55944:
                cmpi.l  #Obj_Buggernaut_2,(a2)
                beq.s   loc_55958

loc_5594C:
                lea     next_object(a2),a2
                dbf     d0,loc_55944
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

loc_55958:
                move.b  $39(a2),d1
                addq.b  #1,d1
                cmpi.b  #4,d1
                bhi.s   loc_5594C
                move.b  d1,$39(a2)
                move.w  a2,parent3(a0)
                rts
; End of function sub_5593C

; =============== S U B R O U T I N E =======================================

sub_5596E:
                move.w  y_pos(a0),d0
                move.w  (Water_level).w,d1
                subi.w  #8,d1
                cmp.w   d1,d0
                blo.s   locret_55984
                move.w  #-$200,y_vel(a0)

locret_55984:
                rts
; End of function sub_5596E

; ---------------------------------------------------------------------------
ObjDat_Buggernaut:
                dc.l    Map_Buggernaut
                dc.w    make_art_tile(ArtTile_Buggernaut,1,1)
                dc.w    $280
                dc.b    $10,  $C,   0, $17
ObjDat3_Buggernaught_Baby:
                dc.w    $280
                dc.b    $C,  $C,   3,   0
ChildObjDat_Buggernaught_Baby:
                dc.w    1-1
                dc.l    Obj_Buggernaught_Baby
                dc.b    $20,   0
AniRaw_Buggernaut:
                dc.b    0,   0,   1,   2, $FC
AniRaw_Buggernaut_Baby:
                dc.b    0,   3,   4,   5, $FC
                even
; ---------------------------------------------------------------------------

Obj_TurboSpiker:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  TurboSpiker_Index(pc,d0.w),d1
                jsr     TurboSpiker_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
TurboSpiker_Index:
                dc.w    loc_559D2-TurboSpiker_Index
                dc.w    loc_55A2E-TurboSpiker_Index
                dc.w    loc_55A94-TurboSpiker_Index
                dc.w    loc_55AB4-TurboSpiker_Index
                dc.w    loc_55AD2-TurboSpiker_Index
                dc.w    loc_55AE0-TurboSpiker_Index
                dc.w    loc_55B06-TurboSpiker_Index
                dc.w    loc_55B22-TurboSpiker_Index
; ---------------------------------------------------------------------------

loc_559D2:
                lea     ObjDat_TurboSpiker(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bclr    #1,render_flags(a0)
                beq.s   loc_559F0
                move.b  #$A,routine(a0)
                lea     ChildObjDat_55D04(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_559F0:
                move.b  #$10,x_radius(a0)
                move.b  #$F,y_radius(a0)
                move.l  #byte_55D0C,$30(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.w  d0,$3C(a0)
                move.l  #loc_55A58,$34(a0)
                move.w  #-$80,d4
                jsr     Set_VelocityXTrackSonic(pc)
                lea     ChildObjDat_55CCC(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_55A2E:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.s   loc_55A46
                btst    #0,render_flags(a0)
                beq.s   loc_55A42
                subq.w  #2,d0

loc_55A42:
                tst.w   d0
                beq.s   loc_55A74

loc_55A46:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     ObjHitFloor2_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_55A58:
                move.b  routine(a0),d0
                cmpi.b  #4,d0
                beq.s   locret_55A72
                move.b  d0,$3A(a0)
                move.b  #4,routine(a0)
                move.w  #$F,$2E(a0)

locret_55A72:
                rts
; ---------------------------------------------------------------------------

loc_55A74:
                move.b  #6,routine(a0)
                move.w  #$F,$2E(a0)
                move.w  #$200,d0
                bchg    #0,render_flags(a0)
                beq.s   loc_55A8E
                neg.w   d0

loc_55A8E:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_55A94:
                subq.w  #1,$2E(a0)
                bmi.s   loc_55A9C
                rts
; ---------------------------------------------------------------------------

loc_55A9C:
                move.b  $3A(a0),routine(a0)
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  $3C(a0),$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_55AB4:
                subq.w  #1,$2E(a0)
                bmi.s   loc_55ABC
                rts
; ---------------------------------------------------------------------------

loc_55ABC:
                move.b  #8,routine(a0)
                bset    #1,$38(a0)
                move.l  #byte_55D11,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_55AD2:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite2).l
                jmp     ObjHitFloor2_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_55AE0:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                blo.s   loc_55AEC
                rts
; ---------------------------------------------------------------------------

loc_55AEC:
                move.b  #$C,routine(a0)
                bset    #0,$38(a0)
                move.w  #3,$2E(a0)
                lea     ChildObjDat_55CE4(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_55B06:
                subq.w  #1,$2E(a0)
                bmi.s   loc_55B0E
                rts
; ---------------------------------------------------------------------------

loc_55B0E:
                move.b  #$E,routine(a0)
                move.w  #$180,priority(a0)
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_55B22:
                subq.w  #1,$2E(a0)
                bmi.s   loc_55B2A
                rts
; ---------------------------------------------------------------------------

loc_55B2A:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_55B32:
                lea     word_55CA6(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_55B44,(a0)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_55B44:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_55B58
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_55B58:
                move.l  #loc_55B8A,(a0)
                move.w  #$100,d0
                btst    #0,render_flags(a0)
                beq.s   loc_55B6C
                neg.w   d0

loc_55B6C:
                move.w  d0,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_FloorLauncher),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_55CD4(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

loc_55B8A:
                jsr     (MoveSprite2).l
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

loc_55B94:
                lea     word_55CAC(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_55BA6,(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_55BA6:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_55BCA
                bsr.w   sub_55BCE
                bchg    #0,$38(a0)
                beq.w   locret_55A72
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_55BCA:
                jmp     Go_Delete_Sprite(pc)

; =============== S U B R O U T I N E =======================================

sub_55BCE:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   locret_55BFE
                lea     ChildObjDat_55CDC(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_55BFE
                jsr     (Random_Number).l
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,x_pos(a1)
                swap    d0
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,y_pos(a1)

locret_55BFE:
                rts
; End of function sub_55BCE

; ---------------------------------------------------------------------------

loc_55C00:
                lea     word_55CB2(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_55C24,(a0)
                move.l  #byte_55D16,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_55C24:
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_55C2E:
                lea     word_55CB8(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_55C4C,(a0)
                move.b  subtype(a0),$2F(a0)
                moveq   #signextendB(sfx_Splash),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_55C4C:
                subq.w  #1,$2E(a0)
                bmi.s   loc_55C54
                rts
; ---------------------------------------------------------------------------

loc_55C54:
                move.l  #loc_55C6C,(a0)
                move.l  #byte_55D1D,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_55C6C:
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_55C76:
                move.l  #loc_55C84,(a0)
                lea     ObjDat3_55CC0(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_55C84:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   loc_55C94
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_55C94:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_TurboSpiker:
                dc.l    Map_TurboSpiker
                dc.w    make_art_tile(ArtTile_TurboSpiker,1,0)
                dc.w    $280
                dc.b    $20, $20,   0, $1A
word_55CA6:
                dc.w    $280
                dc.b    8, $10,   3, $9E
word_55CAC:
                dc.w    $200
                dc.b    4,   8,   4,   0
word_55CB2:
                dc.w    $280
                dc.b    4,   4,   5,   0
word_55CB8:
                dc.w    make_art_tile(ArtTile_TurboSpiker,0,1)
                dc.w    $200
                dc.b    8,   8,   8,   0
ObjDat3_55CC0:
                dc.l    Map_TurboSpikerHidden
                dc.w    make_art_tile($001,2,1)
                dc.w    $180
                dc.b    $10, $10,   0,   0
ChildObjDat_55CCC:
                dc.w    1-1
                dc.l    loc_55B32
                dc.b    4,   0
ChildObjDat_55CD4:
                dc.w    1-1
                dc.l    loc_55B94
                dc.b    -4, $14
ChildObjDat_55CDC:
                dc.w    1-1
                dc.l    loc_55C00
                dc.b    0,   4
ChildObjDat_55CE4:
                dc.w    5-1
                dc.l    loc_55C2E
                dc.b    4,  -8
                dc.l    loc_55C2E
                dc.b    -6,   0
                dc.l    loc_55C2E
                dc.b    6,   0
                dc.l    loc_55C2E
                dc.b    -8,   0
                dc.l    loc_55C2E
                dc.b    8,   0
ChildObjDat_55D04:
                dc.w    1-1
                dc.l    loc_55C76
                dc.b    0,   0
byte_55D0C:
                dc.b    5,   0,   1,   2, $FC
byte_55D11:
                dc.b    1,   0,   1,   2, $FC
byte_55D16:
                dc.b    0,   5,   5,   5,   6,   7, $F4
byte_55D1D:
                dc.b    1,   8,   9,  $A,  $B,  $C,  $D, $F4
                even
Map_TurboSpikerHidden:
                include "src/objects/shared/turbo_spiker/map_turbo_spiker_hidden.s"
; ---------------------------------------------------------------------------

Obj_MegaChopper:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MegaChopper_Index(pc,d0.w),d1
                jsr     MegaChopper_Index(pc,d1.w)
                btst    #7,status(a0)
                bne.w   EnemyDefeat_Score
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
MegaChopper_Index:
                dc.w    loc_55D66-MegaChopper_Index
                dc.w    loc_55D8A-MegaChopper_Index
                dc.w    loc_55E02-MegaChopper_Index
                dc.w    loc_55E40-MegaChopper_Index
; ---------------------------------------------------------------------------

loc_55D66:
                lea     ObjDat_MegaChopper(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AniRaw_MegaChopper,$30(a0)
                clr.w   child_dx(a0)                    ; and child_dy
                bclr    #1,render_flags(a0)
                beq.s   locret_55D88
                bset    #7,art_tile(a0)

locret_55D88:
                rts
; ---------------------------------------------------------------------------

loc_55D8A:
                bsr.w   sub_55F18
                jsr     Animate_Raw(pc)
                jsr     Find_SonicTails(pc)
                move.b  (V_int_run_count+3).w,d4
                andi.b  #7,d4
                bne.s   loc_55DAC
                moveq   #1,d4
                tst.w   d1
                bne.s   loc_55DA8
                neg.w   d4

loc_55DA8:
                add.w   d4,y_pos(a0)

loc_55DAC:
                move.w  y_pos(a0),d4
                move.w  (Water_level).w,d5
                addq.w  #8,d5
                cmp.w   d5,d4
                bhi.s   loc_55DC2
                btst    #Status_Underwater,status(a1)
                beq.s   loc_55DDA

loc_55DC2:
                move.w  #$200,d0
                move.w  #8,d1
                jsr     (Chase_ObjectXOnly).l
                jsr     Change_FlipXWithVelocity(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_55DDA:
                move.b  #4,routine(a0)
                move.w  #$200,d4
                bset    #0,render_flags(a0)
                tst.w   d0
                bne.s   loc_55DF6
                neg.w   d4
                bclr    #0,render_flags(a0)

loc_55DF6:
                move.w  d4,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_55E02:
                bsr.w   sub_55F18
                jsr     Animate_Raw(pc)
                tst.w   y_vel(a0)
                bmi.s   loc_55E30
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   loc_55E30
                move.w  y_vel(a0),d0
                addi.w  #-$20,d0
                move.w  d0,y_vel(a0)
                beq.s   loc_55E34
                bmi.s   loc_55E34
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_55E30:
                jmp     MoveSprite_LightGravity(pc)
; ---------------------------------------------------------------------------

loc_55E34:
                move.b  #2,routine(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_55E40:
                move.b  #0,mapping_frame(a0)
                btst    #2,(V_int_run_count+3).w
                beq.s   loc_55E54
                move.b  #2,mapping_frame(a0)

loc_55E54:
                movea.w $44(a0),a1
                cmpi.b  #4,routine(a1)
                beq.w   loc_55EE6
                cmpi.b  #2,anim(a1)
                beq.s   loc_55EE6
                cmpi.b  #9,anim(a1)
                beq.s   loc_55EE6
                jsr     Check_LRControllerShake(pc)
                bne.s   loc_55EE6
                btst    #2,$38(a0)
                beq.s   loc_55E8C
                move.w  (Ctrl_1).w,d0
                andi.w  #($8C<<8)|$8C,d0
                move.w  d0,(Ctrl_1_logical).w

loc_55E8C:
                move.w  x_pos(a1),d0
                move.b  child_dx(a0),d1
                ext.w   d1
                move.b  $38(a0),d2
                andi.b  #1,d2
                move.b  render_flags(a1),d3
                andi.b  #1,d3
                eor.b   d2,d3
                beq.s   loc_55EBA
                bchg    #0,render_flags(a0)
                bchg    #0,$38(a0)
                neg.b   child_dx(a0)

loc_55EBA:
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                bpl.s   loc_55ED8
                cmpi.b  #8,anim(a1)
                bne.s   loc_55ED8
                addi.w  #$10,d1

loc_55ED8:
                add.w   d1,d0
                move.w  d0,y_pos(a0)
                bsr.w   sub_55FEA
                beq.w   locret_55D88

loc_55EE6:
                bclr    #2,$38(a0)
                beq.s   loc_55EF2
                clr.b   (Ctrl_1_locked).w

loc_55EF2:
                move.l  #MoveChkDel,(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #$200,d0
                btst    #0,render_flags(a0)
                beq.s   loc_55F0C
                neg.w   d0

loc_55F0C:
                move.w  d0,x_vel(a0)
                move.w  #-$200,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

sub_55F18:
                move.b  collision_property(a0),d0
                beq.w   locret_55D88
                clr.b   collision_property(a0)
                andi.w  #3,d0
                move.w  d0,d2
                lsl.w   #2,d0
                lea     word_55FD6-4(pc),a2
                lea     (a2,d0.w),a2
                movea.w (a2)+,a1
                move.w  a1,$44(a0)
                btst    #Status_Invincible,status_secondary(a1)
                bne.w   loc_55FE2
                move.w  y_pos(a0),d1
                sub.w   y_pos(a1),d1
                cmpi.w  #-$10,d1
                blt.w   locret_55D88
                cmpi.w  #$10,d1
                bge.w   locret_55D88
                move.w  a1,$44(a0)
                cmpi.b  #2,anim(a1)
                beq.s   loc_55FE2
                cmpi.w  #1,d2
                bne.s   loc_55F7C
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                bset    #2,$38(a0)

loc_55F7C:
                movea.w (a2)+,a3
                move.w  a3,$3E(a0)
                move.w  (a3),parent3(a0)
                move.b  #6,routine(a0)
                move.w  #0,priority(a0)
                move.w  #60,$2E(a0)
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                move.b  d0,child_dx(a0)
                bclr    #0,render_flags(a0)
                tst.w   d0
                bpl.s   loc_55FB4
                bset    #0,render_flags(a0)

loc_55FB4:
                move.w  y_pos(a0),d0
                sub.w   y_pos(a1),d0
                move.b  d0,child_dy(a0)
                bclr    #0,$38(a0)
                btst    #0,render_flags(a1)
                beq.s   locret_55FD4
                bset    #0,$38(a0)

locret_55FD4:
                rts
; ---------------------------------------------------------------------------
word_55FD6:
                dc.w    Player_1, Ctrl_1
                dc.w    Player_2, Ctrl_2
                dc.w    Player_1, Ctrl_1
; ---------------------------------------------------------------------------

loc_55FE2:
                bset    #7,status(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_55FEA:
                subq.w  #1,$2E(a0)
                bpl.s   loc_56032
                move.w  #60-1,$2E(a0)
                ori.b   #1,(Update_HUD_ring_count).w
                bset    #7,$38(a0)
                move.w  (Ring_count).w,d0
                subq.w  #1,d0
                bmi.s   loc_56044
                beq.s   loc_5601C
                cmpi.w  #10,(Ring_count).w
                beq.s   loc_5601C
                cmpi.w  #100,(Ring_count).w
                bne.s   loc_56022

loc_5601C:
                ori.b   #$80,(Update_HUD_ring_count).w

loc_56022:
                move.w  d0,(Ring_count).w
                moveq   #signextendB(sfx_RingRight),d0
                jsr     (Play_SFX).l

loc_5602E:
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

loc_56032:
                bclr    #7,$38(a0)
                beq.s   loc_5602E
                andi.b  #$FE,(Update_HUD_ring_count).w
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

loc_56044:
                movea.l a0,a2
                movea.w $44(a0),a1
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l a2,a0
                moveq   #1,d0
                rts
; End of function sub_55FEA

; ---------------------------------------------------------------------------
ObjDat_MegaChopper:
                dc.l    Map_MegaChopper
                dc.w    make_art_tile(ArtTile_MegaChopper,1,0)
                dc.w    $280
                dc.b    $20, $20,   0, $D7
AniRaw_MegaChopper:
                dc.b    2,   0,   1, $FC
                even
; ---------------------------------------------------------------------------

Obj_Poindexter:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Poindexter_Index(pc,d0.w),d1
                jsr     Poindexter_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Poindexter_Index:
                dc.w    loc_56084-Poindexter_Index
                dc.w    loc_560D2-Poindexter_Index
; ---------------------------------------------------------------------------

loc_56084:
                lea     ObjDat_Poindexter(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AniRaw_Poindexter,$30(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                add.w   d0,d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.w  d0,$3A(a0)
                move.l  #loc_560FA,$34(a0)
                move.w  #-$40,d4
                jsr     Set_VelocityXTrackSonic(pc)
                move.w  #$20,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #1,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_560D2:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                jsr     Animate_RawMultiDelay(pc)
                jsr     Obj_Wait(pc)
                move.b  #$A,collision_flags(a0)
                cmpi.b  #2,mapping_frame(a0)
                bne.s   locret_560F8
                move.b  #$86,collision_flags(a0)

locret_560F8:
                rts
; ---------------------------------------------------------------------------

loc_560FA:
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  $3A(a0),$2E(a0)
                rts
; ---------------------------------------------------------------------------
ObjDat_Poindexter:
                dc.l    Map_Poindexter
                dc.w    make_art_tile(ArtTile_Pointdexter,1,1)
                dc.w    $280
                dc.b    $14, $14,   0,   0
AniRaw_Poindexter:
                dc.b    0, $7F
                dc.b    1,   4
                dc.b    2, $3F
                dc.b    1,   4
                dc.b    $FC
                even
; ---------------------------------------------------------------------------

Obj_BubblesBadnik:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  BubblesBadnik_Index(pc,d0.w),d1
                jsr     BubblesBadnik_Index(pc,d1.w)
                move.b  #$12,collision_flags(a0)
                cmpi.b  #4,mapping_frame(a0)
                bne.s   loc_5614A
                move.b  #$86,collision_flags(a0)

loc_5614A:
                lea     PLCPtr_BubblesBadnik(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Sprite_CheckDeleteTouchSlotted(pc)
; ---------------------------------------------------------------------------
BubblesBadnik_Index:
                dc.w    loc_5615C-BubblesBadnik_Index
                dc.w    loc_56198-BubblesBadnik_Index
                dc.w    loc_561D2-BubblesBadnik_Index
; ---------------------------------------------------------------------------

loc_5615C:
                lea     ObjSlot_BubblesBadnik(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.w  #-$80,x_vel(a0)
                btst    #0,render_flags(a0)
                beq.s   loc_56176
                neg.w   x_vel(a0)

loc_56176:
                move.l  #byte_56239,$30(a0)
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #2,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_56198:
                jsr     Animate_RawMultiDelay(pc)
                move.w  y_vel(a0),d4
                jsr     Swing_UpAndDown(pc)
                tst.w   y_vel(a0)
                bne.s   loc_561CC
                tst.w   d4
                bmi.s   loc_561CC
                move.b  #4,routine(a0)
                move.l  #byte_5622A,$30(a0)
                move.l  #loc_56200,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

loc_561CC:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_561D2:
                jsr     Animate_RawMultiDelay(pc)
                beq.s   loc_561E8
                cmpi.b  #4,anim_frame(a0)
                bne.s   loc_561E8
                moveq   #signextendB(sfx_ChainTick),d0
                jsr     (Play_SFX).l

loc_561E8:
                jsr     Swing_UpAndDown(pc)
                tst.w   d3
                beq.s   loc_561FA
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_561FA:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_56200:
                move.b  #2,routine(a0)
                move.l  #byte_56239,$30(a0)
                rts
; ---------------------------------------------------------------------------
ObjSlot_BubblesBadnik:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_BubblesBadnik,1,1)
                dc.w    $18,     0
                dc.l    Map_BubblesBadnik
                dc.w    $280
                dc.b    $14, $18,   0,   0
PLCPtr_BubblesBadnik:
                dc.l    ArtUnc_BubblesBadnik
                dc.l    DPLC_BubblesBadnik
byte_5622A:
                dc.b    0,  $F
                dc.b    0, $77
                dc.b    1,   3
                dc.b    2,   3
                dc.b    2,   3
                dc.b    1,   3
                dc.b    0, $77
                dc.b    $F4
byte_56239:
                dc.b    0, $7F
                dc.b    3,   3
                dc.b    4, $6B
                dc.b    4, $6B
                dc.b    3,   3
                dc.b    0, $7F
                dc.b    $FC
                even
; ---------------------------------------------------------------------------

Obj_Tunnelbot:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Tunnelbot_Index(pc,d0.w),d1
                jsr     Tunnelbot_Index(pc,d1.w)
                bsr.w   sub_5682E
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Tunnelbot_Index:
                dc.w    loc_5626C-Tunnelbot_Index
                dc.w    loc_5628E-Tunnelbot_Index
                dc.w    loc_562BE-Tunnelbot_Index
                dc.w    loc_562E6-Tunnelbot_Index
                dc.w    loc_5631A-Tunnelbot_Index
; ---------------------------------------------------------------------------

loc_5626C:
                lea     ObjDat_Tunnelbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #-2,collision_property(a0)
                move.b  #$28,y_radius(a0)
                jsr     (Swing_Setup1).l
                lea     ChildObjDat_568EA(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_5628E:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.w   locret_562BC
                move.b  #4,routine(a0)
                move.l  #byte_56931,$30(a0)
                move.l  #loc_562CE,$34(a0)

locret_562BC:
                rts
; ---------------------------------------------------------------------------

loc_562BE:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     Animate_RawGetFaster(pc)
; ---------------------------------------------------------------------------

loc_562CE:
                move.b  #6,routine(a0)
                move.l  #byte_56937,$30(a0)
                move.l  #loc_56300,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_562E6:
                jsr     Animate_Raw(pc)
                subq.w  #1,y_pos(a0)
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   locret_562FE
                movea.l $34(a0),a1
                jsr     (a1)

locret_562FE:
                rts
; ---------------------------------------------------------------------------

loc_56300:
                move.b  #8,routine(a0)
                st      (Screen_shake_flag).w
                move.w  #$BF,$2E(a0)
                move.l  #loc_56346,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5631A:
                jsr     Animate_Raw(pc)
                moveq   #-2,d0
                move.b  (V_int_run_count+3).w,d1
                btst    #0,d1
                beq.s   loc_5632C
                moveq   #1,d0

loc_5632C:
                add.w   d0,y_pos(a0)
                andi.b  #7,d1
                bne.s   loc_56342
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l
                bsr.w   sub_567FE

loc_56342:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_56346:
                clr.w   (Screen_shake_flag).w
                st      (Level_trigger_array+8).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

Obj_MGZMiniboss:
                lea     word_56388(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZMiniboss_Index(pc,d0.w),d1
                jsr     MGZMiniboss_Index(pc,d1.w)
                bsr.w   sub_5682E
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
MGZMiniboss_Index:
                dc.w    loc_56390-MGZMiniboss_Index
                dc.w    loc_563F0-MGZMiniboss_Index
                dc.w    loc_562BE-MGZMiniboss_Index
                dc.w    loc_562E6-MGZMiniboss_Index
                dc.w    loc_5631A-MGZMiniboss_Index
                dc.w    loc_56466-MGZMiniboss_Index
                dc.w    loc_564D4-MGZMiniboss_Index
                dc.w    loc_56530-MGZMiniboss_Index
                dc.w    loc_56552-MGZMiniboss_Index
                dc.w    loc_56578-MGZMiniboss_Index
word_56388:
                dc.w    $D20,  $EC0, $2B80, $3080
; ---------------------------------------------------------------------------

loc_56390:
                lea     ObjDat_Tunnelbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,collision_property(a0)
                move.b  #$28,y_radius(a0)
                move.w  #$2E00,(Camera_max_X_pos).w
                move.w  #$E10,(Camera_target_max_Y_pos).w
                move.w  #$2E00,$3A(a0)
                move.l  #loc_56402,$34(a0)
                jsr     (Swing_Setup1).l
                bset    #1,$38(a0)
                lea     PLC_MGZMiniboss(pc),a1
                jsr     (Load_PLC_Raw).l
                jsr     (AllocateObject).l
                bne.s   loc_563E8
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

loc_563E8:
                lea     ChildObjDat_568EA(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_563F0:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (loc_541A2).l
; ---------------------------------------------------------------------------

loc_56402:
                move.b  #4,routine(a0)
                move.l  #byte_56931,$30(a0)
                move.l  #loc_5641A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5641A:
                move.b  #6,routine(a0)
                move.l  #byte_56937,$30(a0)
                move.l  #loc_56432,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56432:
                move.b  #8,routine(a0)
                st      (Screen_shake_flag).w
                move.w  #$7F,$2E(a0)
                move.l  #loc_5644C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5644C:
                move.b  #$A,routine(a0)
                clr.w   (Screen_shake_flag).w
                move.w  #$3F,$2E(a0)
                move.l  #loc_5646A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56466:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5646A:
                move.b  #$C,routine(a0)
                bset    #1,render_flags(a0)
                st      (Screen_shake_flag).w
                move.w  #$7F,$2E(a0)
                move.l  #loc_56500,$34(a0)
                move.w  (Camera_X_pos).w,x_pos(a0)
                jsr     (Random_Number).l
                andi.w  #$E,d0
                move.w  word_564C4(pc,d0.w),d1
                add.w   d1,x_pos(a0)
                subi.w  #$40,y_pos(a0)
                tst.b   (_unkFA80+1).w
                beq.s   locret_564C2
                move.w  d0,d3
                lea     ChildObjDat_56920(pc),a2
                jsr     CreateChild1_Normal(pc)
                cmpi.w  #8,d3
                bhs.s   locret_564C2
                bset    #0,render_flags(a1)

locret_564C2:
                rts
; ---------------------------------------------------------------------------
word_564C4:
                dc.w    $30,   $48,   $60,   $78,   $C8,   $E0,   $F8,  $110
; ---------------------------------------------------------------------------

loc_564D4:
                jsr     Animate_Raw(pc)
                moveq   #2,d0
                move.b  (V_int_run_count+3).w,d1
                btst    #0,d1
                beq.s   loc_564E6
                moveq   #-1,d0

loc_564E6:
                add.w   d0,y_pos(a0)
                andi.b  #7,d1
                bne.s   loc_564FC
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l
                bsr.w   sub_567FE

loc_564FC:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_56500:
                move.b  #$E,routine(a0)
                clr.w   (Screen_shake_flag).w
                tst.b   (_unkFA80+1).w
                bne.s   loc_56520
                move.w  #$2F,$2E(a0)
                move.l  #loc_5653C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56520:
                move.w  #$17,$2E(a0)
                move.l  #loc_5655E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56530:
                addq.w  #4,y_pos(a0)
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5653C:
                move.b  #$10,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_5655E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56552:
                jsr     Animate_Raw(pc)
                subq.w  #1,y_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5655E:
                move.b  #$12,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_5658C,$34(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

loc_56578:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5658C:
                bclr    #1,render_flags(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_565A2,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_565A2:
                move.b  #6,routine(a0)
                move.l  #loc_56432,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_565B2:
                jsr     (Obj_EndSignControl).l
                lea     ChildObjDat_56900(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_565C2:
                move.l  #loc_565D0,(a0)
                move.b  #$9E,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_565D0:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_565E6
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

loc_565E6:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_565EC:
                lea     ObjDat3_568C0(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bset    #3,shield_reaction(a0)
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,mapping_frame(a0)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_56620
                tst.b   d0
                bne.s   loc_56620
                lea     ObjDat3_568CC(pc),a1
                jsr     SetUp_ObjAttributes(pc)

loc_56620:
                move.l  #MoveDraw_SpriteTimed2,(a0)
                move.w  #$5F,$2E(a0)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_56630:
                lea     ObjDat3_568DE(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_56672,(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$30,d0
                btst    #0,render_flags(a0)
                beq.s   loc_56652
                addi.w  #$E0,d0

loc_56652:
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$F0,d0
                move.w  d0,y_pos(a0)
                move.w  d0,$3A(a0)
                clr.b   routine(a0)
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_56672:
                btst    #4,$38(a0)
                bne.w   loc_5670E
                move.w  x_pos(a0),-(sp)
                bsr.w   sub_56742
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.w  #1|2,d6
                beq.s   loc_566F2
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   loc_566CE
                bclr    #5,status(a0)
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$28,d0
                bmi.s   loc_566CE
                jsr     (sub_228EC).l

loc_566CE:
                andi.b  #2,d6
                beq.s   loc_566F2
                bclr    #6,status(a0)
                lea     (Player_2).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$28,d0
                bmi.s   loc_566F2
                jsr     (sub_228EC).l

loc_566F2:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_56708
                move.b  #7,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

loc_56708:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5670E:
                jsr     Displace_PlayerOffObject(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_56718:
                lea     word_568D8(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  RawAni_5673C(pc,d0.w),mapping_frame(a0)
                moveq   #4,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
RawAni_5673C:
                dc.b    4,   3,   5,   6,   6
                even

; =============== S U B R O U T I N E =======================================

sub_56742:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_56750(pc,d0.w),d1
                jmp     off_56750(pc,d1.w)
; End of function sub_56742

; ---------------------------------------------------------------------------
off_56750:
                dc.w    loc_5675A-off_56750
                dc.w    loc_56774-off_56750
                dc.w    loc_567B4-off_56750
                dc.w    loc_567D4-off_56750
                dc.w    loc_567E4-off_56750
; ---------------------------------------------------------------------------

loc_5675A:
                subq.w  #4,y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.w   locret_562BC
                move.b  #2,routine(a0)
                move.w  #$3F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_56774:
                subq.w  #1,$2E(a0)
                bpl.w   locret_562BC
                move.b  #4,routine(a0)
                move.w  #$100,d0
                btst    #0,render_flags(a0)
                beq.s   loc_56790
                neg.w   d0

loc_56790:
                add.w   d0,x_vel(a0)
                move.w  #$DF,$2E(a0)
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_567B4:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.w   locret_562BC
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_567D4:
                subq.w  #1,$2E(a0)
                bpl.w   locret_562BC
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_567E4:
                move.w  y_pos(a0),d0
                addq.w  #2,d0
                move.w  d0,y_pos(a0)
                cmp.w   $3A(a0),d0
                blo.w   locret_562BC
                bset    #4,$38(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_567FE:
                lea     ChildObjDat_568F8(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_5682C
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                move.w  (Camera_X_pos).w,d1
                subi.w  #$40,d1
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a1)

locret_5682C:
                rts
; End of function sub_567FE

; =============== S U B R O U T I N E =======================================

sub_5682E:
                tst.b   collision_flags(a0)
                bne.s   locret_5687E
                tst.b   collision_property(a0)
                beq.s   loc_56880
                tst.b   $20(a0)
                bne.s   loc_56854
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

loc_56854:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_56860
                addq.w  #2*3,d0

loc_56860:
                lea     word_568A2(pc),a1
                lea     word_568A8(pc,d0.w),a2
                jsr     CopyWordData_3(pc)
                subq.b  #1,$20(a0)
                bne.s   locret_5687E
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_5687E:
                rts
; ---------------------------------------------------------------------------

loc_56880:
                move.l  #Wait_Draw,(a0)
                clr.w   (Screen_shake_flag).w
                move.l  #loc_565B2,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     BossDefeated_StopTimer(pc)
; End of function sub_5682E

; ---------------------------------------------------------------------------
word_568A2:
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_568A8:
                dc.w    $CAA,  $866,  $644
                dc.w    $EEE,  $EEE,  $EEE
ObjDat_Tunnelbot:
                dc.l    Map_MGZMiniboss
                dc.w    make_art_tile(ArtTile_MGZMiniboss,1,0)
                dc.w    $280
                dc.b    $28,  $C,   0, $10
ObjDat3_568C0:
                dc.l    Map_MGZEndBossDebris
                dc.w    make_art_tile(ArtTile_MGZMiniBossDebris,2,0)
                dc.w    $200
                dc.b    $20, $20,   0,   0
ObjDat3_568CC:
                dc.l    Map_MGZMinibossSpires
                dc.w    make_art_tile(ArtTile_MGZSpire,2,0)
                dc.w    $200
                dc.b    4, $10,   0, $84
word_568D8:
                dc.w    $280
                dc.b    $C,  $C,   0,   0
ObjDat3_568DE:
                dc.l    Map_MGZMovingSpikePlatform
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $18, $30,   0,   0
ChildObjDat_568EA:
                dc.w    2-1
                dc.l    loc_565C2
                dc.b    -$1C,-$16
                dc.l    loc_565C2
                dc.b    $1C,-$16
ChildObjDat_568F8:
                dc.w    1-1
                dc.l    loc_565EC
                dc.b    0,   0
ChildObjDat_56900:
                dc.w    5-1
                dc.l    loc_56718
                dc.b    0,   0
                dc.l    loc_56718
                dc.b    -$1C,   0
                dc.l    loc_56718
                dc.b    $1C,   0
                dc.l    loc_56718
                dc.b    -$1C,-$16
                dc.l    loc_56718
                dc.b    $1C,-$16
ChildObjDat_56920:
                dc.w    1-1
                dc.l    loc_56630
                dc.b    0,   0

; unused
                dc.b    0,   5
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,   5
                dc.b    $FC
byte_56931:
                dc.b    5,   4,   0,   1,   2, $FC
byte_56937:
                dc.b    0,   0,   1,   2, $FC
                even
Map_MGZMinibossSpires:
                include "src/objects/shared/zones/mgz/map_miniboss_spires.s"
PLC_MGZMiniboss:    plrlistheader
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_MGZSpire, ArtNem_MGZSpire
PLC_MGZMiniboss_End:
; ---------------------------------------------------------------------------

Obj_Spiker:
                jsr     (Obj_WaitOffscreen).l
                moveq   #$A,d0
                bsr.w   sub_56B8C
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Spiker_Index(pc,d0.w),d1
                jsr     Spiker_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Spiker_Index:
                dc.w    loc_5697E-Spiker_Index
                dc.w    loc_5698E-Spiker_Index
                dc.w    loc_569A8-Spiker_Index
                dc.w    loc_569C2-Spiker_Index
                dc.w    loc_569E2-Spiker_Index
                dc.w    loc_569F6-Spiker_Index
; ---------------------------------------------------------------------------

loc_5697E:
                lea     ObjDat_Spiker(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     ChildObjDat_56BDC(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_5698E:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                blo.s   loc_5699A
                rts
; ---------------------------------------------------------------------------

loc_5699A:
                move.b  #4,routine(a0)
                move.w  #7,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_569A8:
                subq.w  #1,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   loc_569B4
                rts
; ---------------------------------------------------------------------------

loc_569B4:
                move.b  #6,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_569C2:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   loc_569CE
                rts
; ---------------------------------------------------------------------------

loc_569CE:
                move.b  #8,routine(a0)
                bclr    #2,$38(a0)
                move.w  #7,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_569E2:
                addq.w  #1,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   loc_569EE
                rts
; ---------------------------------------------------------------------------

loc_569EE:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_569F6:
                lea     byte_56C08(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_56A2A
                cmpi.b  #4,anim_frame(a0)
                bne.s   locret_56A2A
                movea.w $44(a0),a1
                move.w  #-$600,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #2,routine(a1)

locret_56A2A:
                rts
; ---------------------------------------------------------------------------

loc_56A2C:
                move.b  $3A(a0),routine(a0)
                move.b  #$A,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_56A3A:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_56A50(pc,d0.w),d1
                jsr     off_56A50(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_56A50:
                dc.w    loc_56A58-off_56A50
                dc.w    loc_56A6E-off_56A50
                dc.w    loc_56A84-off_56A50
                dc.w    loc_56AC0-off_56A50
; ---------------------------------------------------------------------------

loc_56A58:
                lea     word_56BC4(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                tst.b   subtype(a0)
                bne.s   locret_56A6C
                bset    #0,render_flags(a0)

locret_56A6C:
                rts
; ---------------------------------------------------------------------------

loc_56A6E:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_56A7C
                rts
; ---------------------------------------------------------------------------

loc_56A7C:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_56A84:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   loc_56AB8
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   locret_56AA6
                tst.b   subtype(a0)
                beq.s   loc_56AA2
                subq.w  #2,d0

loc_56AA2:
                tst.w   d0
                beq.s   loc_56AA8

locret_56AA6:
                rts
; ---------------------------------------------------------------------------

loc_56AA8:
                move.b  #6,routine(a0)
                move.l  #loc_56AE6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56AB8:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_56AC0:
                lea     byte_56C11(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_56AE4
                cmpi.b  #4,mapping_frame(a0)
                bne.s   locret_56AE4
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_56BF0(pc),a2
                jsr     CreateChild5_ComplexAdjusted(pc)

locret_56AE4:
                rts
; ---------------------------------------------------------------------------

loc_56AE6:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_56AEE:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_56B04(pc,d0.w),d1
                jsr     off_56B04(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
off_56B04:
                dc.w    loc_56B0A-off_56B04
                dc.w    loc_56B12-off_56B04
                dc.w    loc_56B52-off_56B04
; ---------------------------------------------------------------------------

loc_56B0A:
                lea     word_56BCA(pc),a1
                jsr     SetUp_ObjAttributes3(pc)

loc_56B12:
                jsr     Check_PlayerCollision(pc)
                bne.s   loc_56B1A
                rts
; ---------------------------------------------------------------------------

loc_56B1A:
                bsr.w   sub_56B64
                move.b  #4,routine(a0)
                clr.b   collision_flags(a0)
                move.w  #$10,$2E(a0)
                move.l  #loc_56B56,$34(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)
                move.b  #1,mapping_frame(a1)
                clr.b   collision_flags(a1)
                move.w  $44(a0),$44(a1)
                rts
; ---------------------------------------------------------------------------

loc_56B52:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_56B56:
                move.b  #2,routine(a0)
                move.b  #$CA,collision_flags(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_56B64:
                clr.w   y_vel(a1)
                bset    #Status_InAir,status(a1)
                addq.w  #6,y_pos(a1)
                move.b  #2,routine(a1)
                clr.b   jumping(a1)
                bclr    #Status_RollJump,status(a1)
                moveq   #signextendB(sfx_Spring),d0
                jsr     (Play_SFX).l
                rts
; End of function sub_56B64

; =============== S U B R O U T I N E =======================================

sub_56B8C:
                btst    #3,$38(a0)
                bne.s   loc_56B96
                rts
; ---------------------------------------------------------------------------

loc_56B96:
                bclr    #3,$38(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.b  routine(a0),$3A(a0)
                move.b  d0,routine(a0)
                move.l  #loc_56A2C,$34(a0)
                rts
; End of function sub_56B8C

; ---------------------------------------------------------------------------
ObjDat_Spiker:
                dc.l    Map_Spiker
                dc.w    make_art_tile(ArtTile_Spiker,1,0)
                dc.w    $280
                dc.b    $20, $10,   0,  $A
word_56BC4:
                dc.w    $280
                dc.b    $20,   4,   3,   0
word_56BCA:
                dc.w    $200
                dc.b    $20,   4,   7, $CA
ObjDat3_56BD0:
                dc.l    Map_Spiker
                dc.w    make_art_tile(ArtTile_Spiker,0,0)
                dc.w    $280
                dc.b    4,   4,   5, $98
ChildObjDat_56BDC:
                dc.w    3-1
                dc.l    loc_56A3A
                dc.b    -$10,  $C
                dc.l    loc_56A3A
                dc.b    $10,  $C
                dc.l    loc_56AEE
                dc.b    0, -$C
ChildObjDat_56BF0:
                dc.w    1-1
                dc.l    loc_54B46
                dc.l    ObjDat3_56BD0
                dc.l    byte_56C1A
                dc.l    MoveSlowFall_AnimateRaw
                dc.b    4,   0
                dc.w    $200, -$200
byte_56C08:
                dc.b    1,   0
                dc.b    2,   1
                dc.b    1,   0
                dc.b    0,   5
                dc.b    $F4
byte_56C11:
                dc.b    3,   1
                dc.b    3,  $F
                dc.b    4,   7
                dc.b    3, $3F
                dc.b    $F4
byte_56C1A:
                dc.b    1,   5,   6, $FC
                even
; ---------------------------------------------------------------------------

Obj_Mantis:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Mantis_Index(pc,d0.w),d1
                jsr     Mantis_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Mantis_Index:
                dc.w    loc_56C40-Mantis_Index
                dc.w    loc_56C56-Mantis_Index
                dc.w    loc_56C82-Mantis_Index
                dc.w    loc_56CBC-Mantis_Index
                dc.w    loc_56CE0-Mantis_Index
; ---------------------------------------------------------------------------

loc_56C40:
                lea     ObjDat_Mantis(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$29,y_radius(a0)
                lea     ChildObjDat_56D5A(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_56C56:
                jsr     Find_SonicTails(pc)
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   loc_56C6A
                bset    #0,render_flags(a0)

loc_56C6A:
                cmpi.w  #$40,d2
                blo.s   loc_56C72
                rts
; ---------------------------------------------------------------------------

loc_56C72:
                move.b  #4,routine(a0)
                move.l  #loc_56CA6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56C82:
                lea     byte_56D62(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_56C9E
                bmi.s   locret_56C9E
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.w  word_56CA0(pc,d0.w),d0
                add.w   d0,y_pos(a0)

locret_56C9E:
                rts
; ---------------------------------------------------------------------------
word_56CA0:
                dc.w    0,    -5,  -$13
; ---------------------------------------------------------------------------

loc_56CA6:
                move.b  #6,routine(a0)
                move.w  #-$600,y_vel(a0)
                move.l  #loc_56CCC,$34(a0)

locret_56CBA:
                rts
; ---------------------------------------------------------------------------

loc_56CBC:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_56CBA
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_56CCC:
                move.b  #8,routine(a0)
                clr.w   y_vel(a0)
                move.l  #loc_56D06,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56CE0:
                lea     byte_56D69(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_56CFC
                bmi.s   locret_56CFC
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.w  word_56CFE(pc,d0.w),d0
                add.w   d0,y_pos(a0)

locret_56CFC:
                rts
; ---------------------------------------------------------------------------
word_56CFE:
                dc.w    0,   $12,     6,    -1
; ---------------------------------------------------------------------------

loc_56D06:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_56D0E:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_56D24(pc,d0.w),d1
                jsr     off_56D24(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_56D24:
                dc.w    loc_56D28-off_56D24
                dc.w    loc_56D30-off_56D24
; ---------------------------------------------------------------------------

loc_56D28:
                lea     word_56D54(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_56D30:
                movea.w parent3(a0),a1
                move.b  #5,mapping_frame(a0)
                tst.w   y_vel(a1)
                bmi.s   locret_56D46
                move.b  #4,mapping_frame(a0)

locret_56D46:
                rts
; ---------------------------------------------------------------------------
ObjDat_Mantis:
                dc.l    Map_Mantis
                dc.w    make_art_tile(ArtTile_Mantis,1,0)
                dc.w    $280
                dc.b    $14, $1C,   0, $1A
word_56D54:
                dc.w    $200
                dc.b    4,   4,   5,   0
ChildObjDat_56D5A:
                dc.w    1-1
                dc.l    loc_56D0E
                dc.b    -9, -$B
byte_56D62:
                dc.b    0,   0
                dc.b    1,   2
                dc.b    2,   0
                dc.b    $F4
byte_56D69:
                dc.b    2,   0
                dc.b    1,   2
                dc.b    3,   2
                dc.b    0, $1F
                dc.b    $F4
                even
; ---------------------------------------------------------------------------

Obj_Clamer:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Clamer_Index(pc,d0.w),d1
                jsr     Clamer_Index(pc,d1.w)
                lea     PLCPtr_Clamer(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Sprite_CheckDeleteTouchSlotted(pc)
; ---------------------------------------------------------------------------
Clamer_Index:
                dc.w    loc_56D9A-Clamer_Index
                dc.w    loc_56DAA-Clamer_Index
                dc.w    loc_56E0C-Clamer_Index
                dc.w    loc_56E22-Clamer_Index
; ---------------------------------------------------------------------------

loc_56D9A:
                lea     ObjSlot_Clamer(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                lea     ChildObjDat_56EFC(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_56DAA:
                btst    #0,$38(a0)
                bne.s   loc_56DD2
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.s   loc_56DCA
                btst    #0,render_flags(a0)
                beq.s   loc_56DC6
                subq.w  #2,d0

loc_56DC6:
                tst.w   d0
                beq.s   loc_56DF4

loc_56DCA:
                lea     byte_56F24(pc),a1
                jmp     Animate_RawNoSSTMultiDelay(pc)
; ---------------------------------------------------------------------------

loc_56DD2:
                move.b  #4,routine(a0)
                clr.b   collision_flags(a0)
                bclr    #0,$38(a0)
                move.l  #loc_56E14,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_56DF4:
                move.b  #6,routine(a0)
                move.l  #loc_56E14,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

locret_56E0A:
                rts
; ---------------------------------------------------------------------------

loc_56E0C:
                lea     byte_56F2D(pc),a1
                jmp     Animate_RawNoSST(pc)
; ---------------------------------------------------------------------------

loc_56E14:
                move.b  #2,routine(a0)
                move.b  #$A,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_56E22:
                lea     byte_56F39(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.w   locret_56E0A
                cmpi.b  #8,mapping_frame(a0)
                bne.w   locret_56E0A
                tst.b   render_flags(a0)
                bpl.w   locret_56E0A
                lea     ChildObjDat_56F04(pc),a2
                jmp     CreateChild5_ComplexAdjusted(pc)
; ---------------------------------------------------------------------------

loc_56E4A:
                lea     word_56EEA(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                move.b  render_flags(a1),render_flags(a0)
                clr.w   art_tile(a0)
                move.l  #loc_56E68,(a0)
                rts
; ---------------------------------------------------------------------------

loc_56E68:
                bsr.w   Check_PlayerCollision
                beq.s   loc_56E78
                move.l  #loc_56E7C,(a0)
                bsr.w   sub_56E8C

loc_56E78:
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_56E7C:
                subq.w  #1,$2E(a0)
                bmi.s   loc_56E84
                rts
; ---------------------------------------------------------------------------

loc_56E84:
                move.l  #loc_56E68,(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_56E8C:
                move.w  #$800,d0
                bclr    #Status_Facing,status(a1)
                btst    #0,render_flags(a0)
                beq.s   loc_56EA6
                neg.w   d0
                bset    #Status_Facing,status(a1)

loc_56EA6:
                move.w  d0,x_vel(a1)
                move.w  d0,ground_vel(a1)
                move.w  #-$800,y_vel(a1)
                bset    #Status_InAir,status(a1)
                addq.w  #6,y_pos(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)
                clr.b   jumping(a1)
                moveq   #signextendB(sfx_Spring),d0
                jsr     (Play_SFX).l
                rts
; End of function sub_56E8C

; ---------------------------------------------------------------------------
ObjSlot_Clamer:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Clamer,1,1)
                dc.w    $12,     0
                dc.l    Map_Clamer
                dc.w    $280
                dc.b    $14, $10,   0,  $A
word_56EEA:
                dc.w    $280
                dc.b    8,   4,  $B, $D7
ObjDat3_56EF0:
                dc.l    Map_Clamer
                dc.w    make_art_tile(ArtTile_Clamer+$70,1,1)
                dc.w    $200
                dc.b    8,   8,   9, $98
ChildObjDat_56EFC:
                dc.w    1-1
                dc.l    loc_56E4A
                dc.b    0,  -8
ChildObjDat_56F04:
                dc.w    1-1
                dc.l    loc_54B46
                dc.l    ObjDat3_56EF0
                dc.l    0
                dc.l    MoveSprite2
                dc.b    -$10,   2
                dc.w    -$200,     0
PLCPtr_Clamer:
                dc.l    ArtUnc_Clamer
                dc.l    DPLC_Clamer
byte_56F24:
                dc.b    1,   1
                dc.b    0, $5F
                dc.b    1,   1
                dc.b    2,   1
                dc.b    $FC
byte_56F2D:
                dc.b    0,   0,   1,   2,   3,   4,   3,   2,   1,  $A,   0, $F4
byte_56F39:
                dc.b    0,   2
                dc.b    5,   2
                dc.b    6,   2
                dc.b    7, $2F
                dc.b    8,   5
                dc.b    7, $1F
                dc.b    6,   2
                dc.b    5,   2
                dc.b    0, $1F
                dc.b    $F4
                even
; ---------------------------------------------------------------------------

Obj_Sparkle:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Sparkle_Index(pc,d0.w),d1
                jsr     Sparkle_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Sparkle_Index:
                dc.w    loc_56F6E-Sparkle_Index
                dc.w    loc_56F76-Sparkle_Index
                dc.w    loc_56FA2-Sparkle_Index
                dc.w    loc_56FC2-Sparkle_Index
                dc.w    loc_56FC2-Sparkle_Index
; ---------------------------------------------------------------------------

loc_56F6E:
                lea     ObjDat_Sparkle(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_56F76:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                blo.s   loc_56F82
                rts
; ---------------------------------------------------------------------------

loc_56F82:
                move.b  #4,routine(a0)
                move.l  #byte_57116,$30(a0)
                move.l  #loc_56FA6,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

locret_56FA0:
                rts
; ---------------------------------------------------------------------------

loc_56FA2:
                jmp     Animate_RawGetFaster(pc)
; ---------------------------------------------------------------------------

loc_56FA6:
                move.b  #6,routine(a0)
                move.w  #4,$2E(a0)
                move.l  #loc_56FC6,$34(a0)
                lea     ChildObjDat_57106(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_56FC2:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_56FC6:
                move.b  #8,routine(a0)
                moveq   #$68,d0
                bchg    #1,render_flags(a0)
                bne.s   loc_56FD8
                neg.w   d0

loc_56FD8:
                add.w   d0,y_pos(a0)
                move.w  #$20,$2E(a0)
                move.l  #loc_57002,$34(a0)
                moveq   #signextendB(sfx_Lightning),d0
                jsr     (Play_SFX).l
                tst.b   render_flags(a0)
                bpl.w   locret_56FA0
                lea     ChildObjDat_5710E(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

loc_57002:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_5700A:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5701C(pc,d0.w),d1
                jsr     off_5701C(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
off_5701C:
                dc.w    loc_57020-off_5701C
                dc.w    loc_5704C-off_5701C
; ---------------------------------------------------------------------------

loc_57020:
                lea     word_570FA(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #5,shield_reaction(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                moveq   #$34,d0
                btst    #1,render_flags(a1)
                bne.s   loc_57046
                neg.w   d0

loc_57046:
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_5704C:
                lea     byte_5711B(pc),a1
                jmp     Animate_RawNoSST(pc)
; ---------------------------------------------------------------------------

loc_57054:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_57066(pc,d0.w),d1
                jsr     off_57066(pc,d1.w)
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------
off_57066:
                dc.w    loc_5706C-off_57066
                dc.w    loc_570A2-off_57066
                dc.w    loc_570E8-off_57066
; ---------------------------------------------------------------------------

loc_5706C:
                lea     word_57100(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #5,shield_reaction(a0)
                movea.w parent3(a0),a1
                move.w  #$600,d0
                btst    #1,render_flags(a1)
                bne.s   loc_5708C
                neg.w   d0

loc_5708C:
                move.w  d0,y_vel(a0)
                move.w  #$600,d0
                tst.b   subtype(a0)
                bne.s   loc_5709C
                neg.w   d0

loc_5709C:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_570A2:
                lea     byte_57126(pc),a1
                jsr     Animate_RawNoSST(pc)
                moveq   #$40,d0
                move.w  x_vel(a0),d1
                bmi.s   loc_570B4
                neg.w   d0

loc_570B4:
                add.w   d0,d1
                cmpi.w  #-$100,d1
                blt.s   loc_570C2
                cmpi.w  #$100,d1
                ble.s   loc_570DC

loc_570C2:
                move.w  d1,x_vel(a0)
                moveq   #$40,d0
                move.w  y_vel(a0),d1
                bmi.s   loc_570D0
                neg.w   d0

loc_570D0:
                add.w   d0,d1
                move.w  d1,y_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_570DC:
                move.b  #4,routine(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_570E8:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------
ObjDat_Sparkle:
                dc.l    Map_Sparkle
                dc.w    make_art_tile(ArtTile_Sparkle,1,1)
                dc.w    $280
                dc.b    $C,  $C,   0,  $B
word_570FA:
                dc.w    $200
                dc.b    $C, $40,   2, $AB
word_57100:
                dc.w    $280
                dc.b    8,   8,   6, $98
ChildObjDat_57106:
                dc.w    1-1
                dc.l    loc_5700A
                dc.b    0,   0
ChildObjDat_5710E:
                dc.w    2-1
                dc.l    loc_57054
                dc.b    0,   0
byte_57116:
                dc.b    9, $10
                dc.b    0,   1
                dc.b    $FC
byte_5711B:
                dc.b    0,   2,   8,   3,   8,   4,   8,   5,   8,   2, $F4
byte_57126:
                dc.b    3,   6,   7, $FC
                even
; ---------------------------------------------------------------------------

Obj_Batbot:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Batbot_Index(pc,d0.w),d1
                jsr     Batbot_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Batbot_Index:
                dc.w    loc_57148-Batbot_Index
                dc.w    loc_57158-Batbot_Index
                dc.w    loc_57180-Batbot_Index
; ---------------------------------------------------------------------------

loc_57148:
                lea     ObjDat_Batbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     ChildObjDat_57220(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_57158:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                blo.s   loc_57164
                rts
; ---------------------------------------------------------------------------

loc_57164:
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                move.w  #$200,d0
                tst.w   d0
                bne.s   loc_5717A
                neg.w   d0

loc_5717A:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_57180:
                lea     byte_5722E(pc),a1
                jsr     Animate_RawNoSST(pc)
                lea     (Player_1).w,a1
                move.w  #$200,d0
                moveq   #8,d1
                jsr     Chase_Object(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_5719C:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_571B2(pc,d0.w),d1
                jsr     off_571B2(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_571B2:
                dc.w    loc_571B8-off_571B2
                dc.w    loc_571C0-off_571B2
                dc.w    loc_571DA-off_571B2
; ---------------------------------------------------------------------------

loc_571B8:
                lea     word_57214(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_571C0:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_571CE
                rts
; ---------------------------------------------------------------------------

loc_571CE:
                move.b  #4,routine(a0)
                addq.b  #1,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_571DA:
                lea     byte_57234(pc),a1
                jmp     Animate_RawNoSSTMultiDelay(pc)
; ---------------------------------------------------------------------------

loc_571E2:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_571F8(pc,d0.w),d1
                jsr     off_571F8(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_571F8:
                dc.w    loc_571FE-off_571F8
                dc.w    loc_571C0-off_571F8
                dc.w    locret_57206-off_571F8
; ---------------------------------------------------------------------------

loc_571FE:
                lea     word_5721A(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

locret_57206:
                rts
; ---------------------------------------------------------------------------
ObjDat_Batbot:
                dc.l    Map_Batbot
                dc.w    make_art_tile(ArtTile_Batbot,1,1)
                dc.w    $280
                dc.b    $20,   8,   2,  $D
word_57214:
                dc.w    $200
                dc.b    8,   8,   3,   0
word_5721A:
                dc.w    $200
                dc.b    4,   4,   5,   0
ChildObjDat_57220:
                dc.w    2-1
                dc.l    loc_5719C
                dc.b    0, $10
                dc.l    loc_571E2
                dc.b    0,   3
byte_5722E:
                dc.b    2,   0,   1,   2,   1, $FC
byte_57234:
                dc.b    3, $1D
                dc.b    4,   2
                dc.b    3,   1
                dc.b    4,   2
                dc.b    3,  $E
                dc.b    4,   2
                dc.b    $FC
                even
; ---------------------------------------------------------------------------

Obj_Blaster:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Blaster_Index(pc,d0.w),d1
                jsr     Blaster_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Blaster_Index:
                dc.w    loc_5726A-Blaster_Index
                dc.w    loc_572B2-Blaster_Index
                dc.w    loc_5731C-Blaster_Index
                dc.w    loc_5731C-Blaster_Index
                dc.w    loc_57362-Blaster_Index
                dc.w    loc_57384-Blaster_Index
                dc.w    loc_573AC-Blaster_Index
                dc.w    loc_573BC-Blaster_Index
; ---------------------------------------------------------------------------

loc_5726A:
                lea     ObjDat_Blaster(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$10,y_radius(a0)
                bset    #1,render_flags(a0)
                bclr    #1,render_flags(a0)
                beq.s   loc_5728A
                st      $3C(a0)

loc_5728A:
                move.b  #$E,y_radius(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.w  d0,$3A(a0)
                move.l  #loc_57306,$34(a0)
                move.w  #-$80,d4
                jmp     Set_VelocityXTrackSonic(pc)
; ---------------------------------------------------------------------------

loc_572B2:
                bsr.w   sub_57414
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.s   loc_572CE
                btst    #0,render_flags(a0)
                beq.s   loc_572CA
                subq.w  #2,d0

loc_572CA:
                tst.w   d0
                beq.s   loc_572E4

loc_572CE:
                lea     byte_5749A(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jsr     (MoveSprite2).l
                jsr     ObjHitFloor2_DoRoutine(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_572E4:
                move.b  #6,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.w  $2E(a0),$3A(a0)
                move.w  #$10,$2E(a0)
                move.l  #loc_57344,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_57306:
                move.b  #4,routine(a0)
                move.w  #$20,$2E(a0)
                move.l  #loc_57324,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5731C:
                bsr.w   sub_57414
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_57324:
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_5732E:
                move.b  #2,routine(a0)
                move.w  $3A(a0),$2E(a0)
                move.l  #loc_57306,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_57344:
                move.b  #8,routine(a0)
                move.l  #loc_5732E,$34(a0)
                lea     ChildObjDat_57462(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_5746A(pc),a2
                jmp     CreateChild5_ComplexAdjusted(pc)
; ---------------------------------------------------------------------------

loc_57362:
                bsr.w   sub_57414
                lea     byte_574A4(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_57382
                cmpi.b  #6,anim_frame(a0)
                bne.s   locret_57382
                lea     ChildObjDat_57482(pc),a2
                jsr     CreateChild5_ComplexAdjusted(pc)

locret_57382:
                rts
; ---------------------------------------------------------------------------

loc_57384:
                addi.w  #-$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bmi.s   loc_5739C
                rts
; ---------------------------------------------------------------------------

loc_5739C:
                add.w   d1,y_pos(a0)
                move.b  #$C,routine(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_573AC:
                tst.b   (_unkFAA2).w
                beq.s   loc_573B4
                rts
; ---------------------------------------------------------------------------

loc_573B4:
                move.b  #$E,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_573BC:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_573D4
                rts
; ---------------------------------------------------------------------------

loc_573D4:
                add.w   d1,y_pos(a0)
                move.b  $3D(a0),routine(a0)
                move.w  $3E(a0),x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_573EA:
                lea     word_57444(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_57402,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_57402:
                jsr     Refresh_ChildPositionAdjusted(pc)
                lea     byte_5749F(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_57414:
                tst.b   $3C(a0)
                beq.s   locret_57436
                tst.b   (_unkFAA2).w
                beq.s   locret_57436
                move.b  routine(a0),$3D(a0)
                move.b  #$A,routine(a0)
                move.w  x_vel(a0),$3E(a0)
                clr.w   x_vel(a0)

locret_57436:
                rts
; End of function sub_57414

; ---------------------------------------------------------------------------
ObjDat_Blaster:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster-6,1,1)
                dc.w    $280
                dc.b    $18, $10,   0,  $A
word_57444:
                dc.w    $200
                dc.b    8,   8,   4,   0
ObjDat3_5744A:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster-6,1,1)
                dc.w    $280
                dc.b    4,   4,   5, $18
ObjDat3_57456:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster-6,1,1)
                dc.w    $200
                dc.b    4,   4,   7,   0
ChildObjDat_57462:
                dc.w    1-1
                dc.l    loc_573EA
                dc.b    -$1B,-$16
ChildObjDat_5746A:
                dc.w    1-1
                dc.l    loc_54B46
                dc.l    ObjDat3_5744A
                dc.l    byte_574AD
                dc.l    MoveFall_AnimateRaw
                dc.b    -$20,-$20
                dc.w    -$200, -$400
ChildObjDat_57482:
                dc.w    1-1
                dc.l    loc_54B46
                dc.l    ObjDat3_57456
                dc.l    byte_574B1
                dc.l    MoveFall_AnimateRaw
                dc.b    -$C,  -4
                dc.w    $100, -$200
byte_5749A:
                dc.b    0, $17
                dc.b    1,   2
                dc.b    $FC
byte_5749F:
                dc.b    0,   4,   4,   5, $F4
byte_574A4:
                dc.b    0,   1
                dc.b    0,   1
                dc.b    2,   5
                dc.b    0, $1F
                dc.b    $F4
byte_574AD:
                dc.b    1,   5,   6, $FC
byte_574B1:
                dc.b    2,   7,   8,   9,  $A, $FC
                even
; ---------------------------------------------------------------------------

Obj_TechnoSqueek:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Technosqueek_Index(pc,d0.w),d1
                jsr     Technosqueek_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Technosqueek_Index:
                dc.w    loc_574DA-Technosqueek_Index
                dc.w    loc_57574-Technosqueek_Index
                dc.w    loc_575C6-Technosqueek_Index
                dc.w    loc_575F4-Technosqueek_Index
                dc.w    loc_57638-Technosqueek_Index
; ---------------------------------------------------------------------------

loc_574DA:
                move.w  #$800,$2E(a0)
                move.l  #loc_575BE,$34(a0)
                cmpi.b  #4,subtype(a0)
                beq.s   loc_57536
                lea     ObjDat_576F2(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #byte_57718,$30(a0)
                bset    #0,render_flags(a0)
                cmpi.b  #2,subtype(a0)
                bne.s   loc_57514
                bset    #1,render_flags(a0)

loc_57514:
                lea     ChildObjDat_57710(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  #$400,d0
                move.w  d0,$3A(a0)
                move.w  d0,x_vel(a0)
                move.w  #$20,$3C(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_57536:
                lea     ObjDat3_576FE(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,routine(a0)
                move.l  #byte_5773E,$30(a0)
                bset    #1,render_flags(a0)
                lea     ChildObjDat_57710(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  #$400,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$20,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_57574:
                jsr     Animate_RawMultiDelayFlipX(pc)
                tst.w   d2
                beq.s   loc_5758A
                cmpi.b  #6,anim_frame(a0)
                bne.s   loc_5758A
                bset    #1,$38(a0)

loc_5758A:
                jsr     Swing_LeftAndRight(pc)
                tst.w   x_vel(a0)
                beq.s   loc_5759E
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5759E:
                move.b  #4,routine(a0)
                move.l  #byte_5772E,$30(a0)
                move.l  #loc_575CA,$34(a0)

loc_575B4:
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_575BE:
                bclr    #5,$38(a0)

locret_575C4:
                rts
; ---------------------------------------------------------------------------

loc_575C6:
                jmp     Animate_RawAdjustFlipX(pc)
; ---------------------------------------------------------------------------

loc_575CA:
                move.b  #2,routine(a0)
                move.l  #byte_57723,$30(a0)

loc_575D8:
                bclr    #1,$38(a0)
                bset    #5,$38(a0)
                move.w  #$10,$2E(a0)
                move.l  #loc_575BE,$34(a0)
                bra.s   loc_575B4
; ---------------------------------------------------------------------------

loc_575F4:
                jsr     Animate_RawMultiDelayFlipY(pc)
                tst.w   d2
                beq.s   loc_5760A
                cmpi.b  #6,anim_frame(a0)
                bne.s   loc_5760A
                bset    #1,$38(a0)

loc_5760A:
                jsr     Swing_UpAndDown(pc)
                tst.w   y_vel(a0)
                beq.s   loc_5761E
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5761E:
                move.b  #8,routine(a0)
                move.l  #byte_57754,$30(a0)
                move.l  #loc_5763C,$34(a0)
                bra.w   loc_575B4
; ---------------------------------------------------------------------------

loc_57638:
                jmp     Animate_RawAdjustFlipY(pc)
; ---------------------------------------------------------------------------

loc_5763C:
                move.b  #6,routine(a0)
                move.l  #byte_57749,$30(a0)
                bra.s   loc_575D8
; ---------------------------------------------------------------------------

loc_5764C:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5765E(pc,d0.w),d1
                jsr     off_5765E(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_5765E:
                dc.w    loc_57664-off_5765E
                dc.w    loc_57680-off_5765E
                dc.w    loc_576B8-off_5765E
; ---------------------------------------------------------------------------

loc_57664:
                lea     word_5770A(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                cmpi.b  #4,subtype(a1)
                bne.s   locret_5767E
                move.b  #4,routine(a0)

locret_5767E:
                rts
; ---------------------------------------------------------------------------

loc_57680:
                lea     byte_57739(pc),a1
                jsr     Animate_RawNoSST(pc)
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                btst    #1,$38(a1)
                beq.s   loc_5769C
                moveq   #2,d0

loc_5769C:
                add.w   d0,d0
                move.w  byte_576B2(pc,d0.w),child_dx(a0)  ; and child_dy
                btst    #5,$38(a1)
                bne.w   locret_575C4
                jmp     Refresh_ChildPositionAdjusted(pc)
; ---------------------------------------------------------------------------
byte_576B2:
                dc.b    $14,   4
                dc.b    $C,   4
                dc.b    0,   4
                even
; ---------------------------------------------------------------------------

loc_576B8:
                lea     byte_5775F(pc),a1
                jsr     Animate_RawNoSST(pc)
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                subq.w  #5,d0
                btst    #1,$38(a1)
                beq.s   loc_576D6
                moveq   #2,d0

loc_576D6:
                add.w   d0,d0
                move.w  byte_576EC(pc,d0.w),child_dx(a0)  ; and child_dy
                btst    #5,$38(a1)
                bne.w   locret_575C4
                jmp     Refresh_ChildPositionAdjusted(pc)
; ---------------------------------------------------------------------------
byte_576EC:
                dc.b    -4, $14
                dc.b    -4,  $C
                dc.b    -4,   0
                even
ObjDat_576F2:
                dc.l    Map_TechnoSqueek
                dc.w    make_art_tile(ArtTile_Technosqueek-6,1,1)
                dc.w    $280
                dc.b    $C,   8,   0,  $B
ObjDat3_576FE:
                dc.l    Map_TechnoSqueek
                dc.w    make_art_tile(ArtTile_Technosqueek-6,1,1)
                dc.w    $280
                dc.b    8,  $C,   5,  $B
word_5770A:
                dc.w    $280
                dc.b    8,   4,   2,   0
ChildObjDat_57710:
                dc.w    1-1
                dc.l    loc_5764C
                dc.b    $14,   4
byte_57718:
                dc.b    0,       0
                dc.b    0,     $17
                dc.b    1,       1
                dc.b    1|$40,   1
                dc.b    0,     $1F
                dc.b    $F4
byte_57723:
                dc.b    0,       0
                dc.b    0,     $37
                dc.b    1,       1
                dc.b    1|$40,   1
                dc.b    0,     $1F
                dc.b    $F4
byte_5772E:
                dc.b    3,   0,   0,   1, 1|$40,   0,   0,   1, 1|$40,   0, $F4
byte_57739:
                dc.b    3,   2,   3,   4, $FC
byte_5773E:
                dc.b    5,       0
                dc.b    5,     $17
                dc.b    6,       1
                dc.b    6|$20,   1
                dc.b    0,     $1F
                dc.b    $F4
byte_57749:
                dc.b    5,       0
                dc.b    5,     $37
                dc.b    6,       1
                dc.b    6|$20,   1
                dc.b    5,     $1F
                dc.b    $F4
byte_57754:
                dc.b    3,   5,   5,   6, 6|$20,   5,   5,   6, 6|$20,   5, $F4
byte_5775F:
                dc.b    3,   7,   8,   9, $FC
                even
; ---------------------------------------------------------------------------

Obj_ICZPathFollowPlatform:
                jsr     (Obj_WaitOffscreen).l

Obj_ICZPathFollowPlatform_2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZPathFollowPlatform_Index(pc,d0.w),d1
                move.w  x_pos(a0),-(sp)
                jsr     ICZPathFollowPlatform_Index(pc,d1.w)
                moveq   #$2B,d1
                moveq   #$14,d2
                moveq   #$14,d3
                move.w  (sp)+,d4
                btst    #7,status(a0)
                bne.s   loc_57796
                jsr     (SolidObjectFull).l
                bsr.w   sub_57BDA

loc_57796:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
ICZPathFollowPlatform_Index:
                dc.w    loc_577B0-ICZPathFollowPlatform_Index
                dc.w    loc_577E8-ICZPathFollowPlatform_Index
                dc.w    loc_57808-ICZPathFollowPlatform_Index
                dc.w    loc_57824-ICZPathFollowPlatform_Index
                dc.w    loc_57868-ICZPathFollowPlatform_Index
                dc.w    loc_57942-ICZPathFollowPlatform_Index
                dc.w    locret_5799C-ICZPathFollowPlatform_Index
                dc.w    loc_5799E-ICZPathFollowPlatform_Index
                dc.w    loc_579B8-ICZPathFollowPlatform_Index
                dc.w    loc_579D4-ICZPathFollowPlatform_Index
; ---------------------------------------------------------------------------

loc_577B0:
                lea     ObjDat_ICZPathFollowPlatform(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  a0,(_unkFAA4).w
                move.b  #$20,x_radius(a0)
                move.b  #$12,y_radius(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  byte_577E4(pc,d0.w),routine(a0)
                tst.w   d0
                bne.w   locret_57866
                lea     ChildObjDat_57C40(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------
byte_577E4:
                dc.b    2,   6,  $C,  $E
                even
; ---------------------------------------------------------------------------

loc_577E8:
                btst    #p1_standing_bit,status(a0)
                bne.s   loc_577F2
                rts
; ---------------------------------------------------------------------------

loc_577F2:
                move.b  #4,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_5781C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_57808:
                moveq   #1,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_57814
                neg.w   d0

loc_57814:
                add.w   d0,x_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5781C:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_57824:
                btst    #p1_pushing_bit,status(a0)
                beq.s   loc_57836
                move.b  (Ctrl_1_held).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   loc_5783C

loc_57836:
                clr.b   $39(a0)
                rts
; ---------------------------------------------------------------------------

loc_5783C:
                addq.b  #1,$39(a0)
                cmpi.b  #$10,$39(a0)
                blo.w   locret_57866
                move.b  #8,routine(a0)
                lea     (Player_1).w,a1
                jsr     Find_SonicTails(pc)
                move.w  #$80,d1
                tst.w   d0
                beq.s   loc_57862
                neg.w   d1

loc_57862:
                move.w  d1,x_vel(a0)

locret_57866:
                rts
; ---------------------------------------------------------------------------

loc_57868:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_57878
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_57878:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                cmpi.w  #8,d1
                bge.s   loc_578D0
                move.b  d3,angle(a0)
                add.w   d1,y_pos(a0)
                move.b  d3,d0
                bpl.s   loc_57898
                neg.b   d0

loc_57898:
                andi.b  #$F8,d0
                beq.s   loc_578AE
                move.w  x_vel(a0),d0
                add.w   d3,d3
                ext.w   d3
                asr.w   #1,d3
                add.w   d3,d0
                bsr.w   sub_57B70

loc_578AE:
                tst.w   x_vel(a0)
                bmi.s   loc_578C2
                moveq   #$1C,d3
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   loc_578DC
                rts
; ---------------------------------------------------------------------------

loc_578C2:
                moveq   #-$1C,d3
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bmi.s   loc_5791A
                rts
; ---------------------------------------------------------------------------

loc_578D0:
                move.b  #$A,routine(a0)
                bsr.w   sub_57B9C
                rts
; ---------------------------------------------------------------------------

loc_578DC:
                move.b  #$C,routine(a0)
                tst.b   subtype(a0)
                beq.w   locret_57866
                lea     ChildObjDat_57C34(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_57912
                move.l  #Obj_Spring,(a1)
                move.w  #$5D5A,x_pos(a1)
                move.w  #$27A,y_pos(a1)
                move.b  #0,subtype(a1)

loc_57912:
                jsr     Displace_PlayerOffObject(pc)
                jmp     loc_5371C(pc)
; ---------------------------------------------------------------------------

loc_5791A:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                dc.w    0,     8,   $10,   $18,   $20,   $28,   $30,   $38
                dc.w    -$38,  -$30,  -$28,  -$20,  -$18,  -$10,    -8,     0
; ---------------------------------------------------------------------------

loc_57942:
                bsr.w   sub_57B82
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_57984
                tst.w   x_vel(a0)
                beq.s   locret_57982
                bmi.s   loc_5796E
                moveq   #$20,d3
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   loc_5797A
                bra.w   locret_57982
; ---------------------------------------------------------------------------

loc_5796E:
                moveq   #-$20,d3
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bpl.s   locret_57982

loc_5797A:
                add.w   d1,x_pos(a0)
                clr.w   x_vel(a0)

locret_57982:
                rts
; ---------------------------------------------------------------------------

loc_57984:
                move.b  #8,routine(a0)
                move.w  y_vel(a0),d0
                btst    #6,d3
                beq.s   loc_57996
                neg.w   d0

loc_57996:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

locret_5799C:
                rts
; ---------------------------------------------------------------------------

loc_5799E:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_579AA
                rts
; ---------------------------------------------------------------------------

loc_579AA:
                move.b  #$10,routine(a0)
                move.w  y_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_579B8:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_579C8
                addq.w  #1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_579C8:
                move.b  #$12,routine(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_579D4:
                addi.w  #-$20,y_vel(a0)
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                bls.s   loc_579EC
                rts
; ---------------------------------------------------------------------------

loc_579EC:
                move.b  #$E,routine(a0)
                move.w  $3A(a0),y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_579FA:
                lea     ObjDat3_57C1C(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #byte_57C48,$30(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  byte_57A26(pc,d0.w),child_dx(a0)  ; and child_dy
                jsr     Refresh_ChildPosition(pc)
                moveq   #8,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
byte_57A26:
                dc.b    -$14,  -9
                dc.b    $14, -$C
                dc.b    $14,   0
                dc.b    $C,  $C
                dc.b    -8,   9
                dc.b    -4,  -6
                even
; ---------------------------------------------------------------------------

loc_57A32:
                lea     ObjDat3_57C28(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_57A7E,(a0)
                move.l  #byte_57C4E,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$5F,$2E(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  byte_57A6C(pc,d0.w),child_dx(a0)  ; and child_dy
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
byte_57A6C:
                dc.b    -$14,-$30
                dc.b    8,-$34
                dc.b    -$C,-$14
                dc.b    $10,-$20
                dc.b    $A,  -4
                dc.b    -$14,  $C
                dc.b    8, $18
                dc.b    -$10, $28
                dc.b    $C, $34
                even
; ---------------------------------------------------------------------------

loc_57A7E:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite).l
                jsr     Obj_Wait(pc)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_ICZBreakableWall:
                lea     ObjDat_ICZBreakableWall(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_57AA6,(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_57AA6:
                moveq   #$2B,d1
                moveq   #$40,d2
                moveq   #$70,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                movea.w (_unkFAA4).w,a1
                cmpi.l  #Obj_ICZPathFollowPlatform_2,(a1)
                bne.s   loc_57AF2
                move.w  x_pos(a1),d0
                move.w  y_pos(a1),d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                lea     word_57B12(pc),a2
                add.w   (a2)+,d2
                cmp.w   d2,d0
                blo.s   loc_57AF2
                add.w   (a2)+,d2
                cmp.w   d2,d0
                bhs.s   loc_57AF2
                add.w   (a2)+,d3
                cmp.w   d3,d1
                blo.s   loc_57AF2
                add.w   (a2)+,d3
                cmp.w   d3,d1
                blo.s   loc_57AF8

loc_57AF2:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_57AF8:
                lea     ChildObjDat_57C3A(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     Go_Delete_Sprite(pc)
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
word_57B12:
                dc.w    -$30,   $60,  -$40,   $80
; ---------------------------------------------------------------------------

loc_57B1A:
                lea     ObjDat3_57C04(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_57B2E,(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_57B2E:
                movea.w parent3(a0),a1
                btst    #p1_standing_bit,status(a1)
                beq.s   loc_57B40
                move.l  #MoveChkDel,(a0)

loc_57B40:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_ICZIceBlock:
                jsr     (Obj_WaitOffscreen).l
                lea     ObjDat_ICZIceBlock(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_57B5A,(a0)

loc_57B5A:
                moveq   #$1B,d1
                moveq   #$10,d2
                moveq   #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_57B70:
                cmpi.w  #-$C00,d0
                blt.s   locret_57B80
                cmpi.w  #$C00,d0
                bgt.s   locret_57B80
                move.w  d0,x_vel(a0)

locret_57B80:
                rts
; End of function sub_57B70

; =============== S U B R O U T I N E =======================================

sub_57B82:
                move.w  y_vel(a0),d0
                addi.w  #$38,d0
                cmpi.w  #-$C00,d0
                blt.s   locret_57B9A
                cmpi.w  #$C00,d0
                bgt.s   locret_57B9A
                move.w  d0,y_vel(a0)

locret_57B9A:
                rts
; End of function sub_57B82

; =============== S U B R O U T I N E =======================================

sub_57B9C:
                move.b  angle(a0),d3
                lsr.b   #3,d3
                andi.w  #$E,d3
                move.w  x_vel(a0),d1
                bpl.s   loc_57BAE
                neg.w   d1

loc_57BAE:
                move.w  off_57BB6(pc,d3.w),d0
                jmp     off_57BB6(pc,d0.w)
; End of function sub_57B9C

; ---------------------------------------------------------------------------
off_57BB6:
                dc.w    loc_57BC6-off_57BB6
                dc.w    loc_57BCC-off_57BB6
                dc.w    loc_57BD4-off_57BB6
                dc.w    loc_57BCC-off_57BB6
                dc.w    loc_57BC6-off_57BB6
                dc.w    loc_57BCC-off_57BB6
                dc.w    loc_57BD4-off_57BB6
                dc.w    loc_57BCC-off_57BB6
; ---------------------------------------------------------------------------

loc_57BC6:
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_57BCC:
                lsr.w   #1,d1
                move.w  d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_57BD4:
                move.w  d1,y_vel(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_57BDA:
                clr.b   (Fast_V_scroll_flag).w
                btst    #p1_standing_bit,status(a0)
                beq.s   locret_57BEA
                st      (Fast_V_scroll_flag).w

locret_57BEA:
                rts
; End of function sub_57BDA

; ---------------------------------------------------------------------------
ObjDat_ICZPathFollowPlatform:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $20, $14,   0,   0
ObjDat_ICZIceBlock:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,0)
                dc.w    $280
                dc.b    $10, $10, $1E,   0
ObjDat3_57C04:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $10,  $C,   8,   0
ObjDat_ICZBreakableWall:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $20, $40,   6,   0
ObjDat3_57C1C:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,1)
                dc.w    $80
                dc.b    8,   8, $23,   0
ObjDat3_57C28:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZIntroSprites,2,1)
                dc.w    $80
                dc.b    $C,  $C, $1C,   0
ChildObjDat_57C34:
                dc.w    6-1
                dc.l    loc_579FA
ChildObjDat_57C3A:
                dc.w    9-1
                dc.l    loc_57A32
ChildObjDat_57C40:
                dc.w    1-1
                dc.l    loc_57B1A
                dc.b    -$10, $10
byte_57C48:
                dc.b    2, $23, $13, $24, $14, $FC
byte_57C4E:
                dc.b    2, $1C, $1D, $25, $26, $FC
                even
; ---------------------------------------------------------------------------

Obj_ICZCrushingColumn:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZCrushingColumn_Index(pc,d0.w),d1
                move.w  x_pos(a0),-(sp)
                jsr     ICZCrushingColumn_Index(pc,d1.w)
                moveq   #$2B,d1
                moveq   #$70,d2
                moveq   #$70,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------
ICZCrushingColumn_Index:
                dc.w    loc_57C90-ICZCrushingColumn_Index
                dc.w    loc_57CCC-ICZCrushingColumn_Index
                dc.w    loc_57CDE-ICZCrushingColumn_Index
                dc.w    loc_57CE6-ICZCrushingColumn_Index
                dc.w    loc_57D0C-ICZCrushingColumn_Index
                dc.w    loc_57D14-ICZCrushingColumn_Index
                dc.w    loc_57D5A-ICZCrushingColumn_Index
                dc.w    loc_57D7E-ICZCrushingColumn_Index
                dc.w    loc_57D8E-ICZCrushingColumn_Index
                dc.w    loc_57DA4-ICZCrushingColumn_Index
                dc.w    loc_57DC0-ICZCrushingColumn_Index
                dc.w    loc_57DDC-ICZCrushingColumn_Index
; ---------------------------------------------------------------------------

loc_57C90:
                lea     ObjDat_ICZCrushingColumn(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$70,y_radius(a0)
                move.w  y_pos(a0),$3E(a0)
                move.w  #$1F,$2E(a0)
                cmpi.b  #3,subtype(a0)
                bhs.s   loc_57CC0
                move.b  #$C,mapping_frame(a0)
                lea     ChildObjDat_57E30(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_57CC0:
                move.b  subtype(a0),d0
                add.b   d0,d0
                move.b  d0,routine(a0)

locret_57CCA:
                rts
; ---------------------------------------------------------------------------

loc_57CCC:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   locret_57CCA

loc_57CD6:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_57CDE:
                subq.w  #1,$2E(a0)
                bmi.s   loc_57CD6
                rts
; ---------------------------------------------------------------------------

loc_57CE6:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                cmpi.w  #$28,d2
                blo.w   locret_57CCA
                btst    #0,render_flags(a0)
                beq.s   loc_57D00
                subq.w  #2,d0

loc_57D00:
                tst.w   d0
                beq.s   locret_57CCA

loc_57D04:
                move.b  #$E,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_57D0C:
                subq.w  #1,$2E(a0)
                bmi.s   loc_57D04
                rts
; ---------------------------------------------------------------------------

loc_57D14:
                move.w  y_vel(a0),d0
                addi.w  #-$20,d0
                cmpi.w  #-$400,d0
                ble.s   loc_57D26
                move.w  d0,y_vel(a0)

loc_57D26:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.w   locret_57CCA

loc_57D38:
                add.w   d1,y_pos(a0)
                move.b  #$10,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_57D92,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_57D5A:
                move.w  y_vel(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$400,d0
                bgt.s   loc_57D6C
                move.w  d0,y_vel(a0)

loc_57D6C:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_57D38
                rts
; ---------------------------------------------------------------------------

loc_57D7E:
                addq.w  #8,y_pos(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_57D38
                rts
; ---------------------------------------------------------------------------

loc_57D8E:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_57D92:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  byte_57DA0-1(pc,d0.w),routine(a0)
                rts
; ---------------------------------------------------------------------------
byte_57DA0:
                dc.b    $14, $14, $16, $12
                even
; ---------------------------------------------------------------------------

loc_57DA4:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                cmp.w   $3E(a0),d0
                bls.s   loc_57DB6
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_57DB6:
                move.w  #$5F,$2E(a0)
                bra.w   loc_57CC0
; ---------------------------------------------------------------------------

loc_57DC0:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                cmp.w   $3E(a0),d0
                bhs.s   loc_57DD2
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_57DD2:
                move.w  #$5F,$2E(a0)
                bra.w   loc_57CC0
; ---------------------------------------------------------------------------

loc_57DDC:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                btst    #0,render_flags(a0)
                beq.s   loc_57DEE
                subq.w  #2,d0

loc_57DEE:
                tst.w   d0
                bne.w   locret_57CCA
                move.b  #$12,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_57DFC:
                move.l  #loc_57E0A,(a0)
                lea     word_57E2A(pc),a1
                jsr     SetUp_ObjAttributes3(pc)

loc_57E0A:
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                addi.w  #$B0,d0
                move.w  d0,y_pos(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
ObjDat_ICZCrushingColumn:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $20, $70,   2,   0
word_57E2A:
                dc.w    $280
                dc.b    $20, $40,  $D,   0
ChildObjDat_57E30:
                dc.w    1-1
                dc.l    loc_57DFC
                dc.b    0,   0
; ---------------------------------------------------------------------------

Obj_ICZFreezer:
                jsr     Obj_WaitOffscreen(pc)
                move.l  #loc_57E4E,(a0)
                lea     ObjDat_ICZFreezer(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_57E4E:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   loc_57E72
                move.l  #loc_57E76,(a0)
                clr.w   $2E(a0)
                clr.w   $30(a0)
                clr.b   $39(a0)
                moveq   #signextendB(sfx_FrostPuff),d0
                jsr     (Play_SFX).l

loc_57E72:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_57E76:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   loc_57EBE
                subq.w  #1,$30(a0)
                bpl.s   loc_57EA2
                moveq   #0,d0
                move.b  $39(a0),d0
                bchg    #1,d0
                move.b  d0,$39(a0)
                move.w  word_57ED6(pc,d0.w),$30(a0)
                move.w  off_57EDA(pc,d0.w),d0
                jsr     off_57EDA(pc,d0.w)

loc_57EA2:
                btst    #1,$38(a0)
                beq.s   loc_57EBA
                subq.w  #1,$2E(a0)
                bpl.s   loc_57EBA
                move.w  #1,$2E(a0)
                bsr.w   sub_57F00

loc_57EBA:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_57EBE:
                move.l  #loc_57E4E,(a0)
                bclr    #1,$38(a0)
                moveq   #signextendB(cmd_StopSFX),d0
                jsr     (Play_SFX).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
word_57ED6:
                dc.w    $40,   $40
off_57EDA:
                dc.w    loc_57EDE-off_57EDA
                dc.w    loc_57EE6-off_57EDA
; ---------------------------------------------------------------------------

loc_57EDE:
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_57EE6:
                bset    #1,$38(a0)
                lea     ChildObjDat_582A8(pc),a2
                btst    #1,render_flags(a0)
                beq.s   loc_57EFC
                lea     ChildObjDat_582B0(pc),a2

loc_57EFC:
                jmp     CreateChild1_Normal(pc)

; =============== S U B R O U T I N E =======================================

sub_57F00:
                lea     ChildObjDat_58298(pc),a2
                btst    #1,render_flags(a0)
                beq.s   loc_57F10
                lea     ChildObjDat_582A0(pc),a2

loc_57F10:
                jmp     CreateChild1_Normal(pc)
; End of function sub_57F00

; ---------------------------------------------------------------------------

loc_57F14:
                lea     word_58278(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_57F24,(a0)

locret_57F22:
                rts
; ---------------------------------------------------------------------------

loc_57F24:
                bsr.w   sub_580EC
                jsr     Refresh_ChildPosition(pc)
                subq.b  #1,$3A(a0)
                bpl.w   locret_57F22
                move.b  #2,$3A(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_57F40:
                move.l  #loc_57F54,(a0)
                move.w  #$1F,$2E(a0)
                lea     ObjDat_ICZFreezer(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_57F54:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_57F84
                subq.w  #1,$2E(a0)
                bmi.s   loc_57F68
                rts
; ---------------------------------------------------------------------------

loc_57F68:
                move.l  #loc_57F70,(a0)
                rts
; ---------------------------------------------------------------------------

loc_57F70:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_57F84
                lea     word_58206(pc),a1
                bra.w   sub_5819C
; ---------------------------------------------------------------------------

loc_57F84:
                move.l  #loc_57F9A,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_57F9A:
                jsr     Obj_Wait(pc)
                lea     word_58206(pc),a1
                bra.w   sub_5819C
; ---------------------------------------------------------------------------

loc_57FA6:
                lea     ObjDat3_58280(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_58004,(a0)
                move.b  #$10,y_radius(a0)
                movea.w $44(a0),a1
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                btst    #0,render_flags(a1)
                beq.s   loc_57FDA
                bset    #0,render_flags(a0)

loc_57FDA:
                movea.w parent3(a0),a2
                move.w  #$200,d1
                cmp.w   x_pos(a2),d0
                bhs.s   loc_57FEA
                neg.w   d1

loc_57FEA:
                move.w  d1,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_58066,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_58004:
                move.w  (Camera_X_pos).w,d0
                tst.w   x_vel(a0)
                bmi.s   loc_5801C
                addi.w  #$128,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_58026
                bra.w   loc_5802A
; ---------------------------------------------------------------------------

loc_5801C:
                addi.w  #$20,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_5802A

loc_58026:
                clr.w   x_vel(a0)

loc_5802A:
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_58044
                add.w   d1,y_pos(a0)
                move.l  #loc_58044,(a0)

loc_58044:
                movea.w $44(a0),a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subq.w  #1,$2E(a0)
                bmi.s   loc_58066
                bsr.w   sub_5820E
                bne.s   loc_58090
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_58066:
                movea.w $44(a0),a1
                movea.l a0,a2
                movea.l a1,a0
                jsr     (HurtCharacter).l
                cmpi.b  #$18,anim(a0)
                beq.s   loc_5808E
                move.w  #$200,d0
                btst    #0,render_flags(a0)
                bne.s   loc_5808A
                neg.w   d0

loc_5808A:
                move.w  d0,x_vel(a0)

loc_5808E:
                movea.l a2,a0

loc_58090:
                movea.w $44(a0),a1
                bset    #1,status(a1)
                clr.b   object_control(a1)
                move.b  #2*60,invulnerability_timer(a1)
                lea     ChildObjDat_582C0(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_580B2:
                lea     ObjDat3_5828C(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #byte_58314,$30(a0)
                cmpi.b  #8,subtype(a0)
                bhs.s   loc_580D8
                move.l  #byte_5830A,$30(a0)

loc_580D8:
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,anim_frame(a0)
                moveq   #$C,d0
                jmp     Set_IndexedVelocity(pc)

; =============== S U B R O U T I N E =======================================

sub_580EC:
                subq.w  #1,$2E(a0)
                bpl.s   locret_58144
                move.w  #2,$2E(a0)
                moveq   #0,d0
                move.b  $39(a0),d0
                addq.b  #4,d0
                cmpi.b  #$48,d0
                bhs.s   loc_58146
                move.b  d0,$39(a0)
                lea     byte_58150(pc,d0.w),a1
                move.b  (a1)+,child_dy(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,d2
                jsr     (Random_Number).l
                and.b   d2,d0
                move.w  d2,d3
                lsr.b   #1,d3
                sub.b   d3,d0
                move.b  d0,child_dx(a0)
                swap    d0
                and.b   d2,d0
                sub.b   d3,d0
                movea.w parent3(a0),a1
                btst    #1,render_flags(a1)
                beq.s   loc_58140
                neg.b   child_dy(a0)

loc_58140:
                add.b   d0,child_dy(a0)

locret_58144:
                rts
; ---------------------------------------------------------------------------

loc_58146:
                jsr     (Delete_Current_Sprite).l
                addq.w  #4,sp
                rts
; End of function sub_580EC

; ---------------------------------------------------------------------------
byte_58150:
                dc.b    $10, $16,   3
                even
                dc.b    $10, $16,   3
                even
                dc.b    $14, $16,   3
                even
                dc.b    $18, $16,   3
                even
                dc.b    $1C, $16,   7
                even
                dc.b    $22, $17,   7
                even
                dc.b    $26, $17,   7
                even
                dc.b    $2E, $17,   7
                even
                dc.b    $32, $17,   7
                even
                dc.b    $3C, $18,   7
                even
                dc.b    $40, $18,  $F
                even
                dc.b    $4D, $19,  $F
                even
                dc.b    $52, $19,  $F
                even
                dc.b    $4B, $19,  $F
                even
                dc.b    $44, $19,  $F
                even
                dc.b    $42, $19,  $F
                even
                dc.b    $3E, $18,  $F
                even
                dc.b    $3B, $17,  $F
                even
                dc.b    $38, $16,  $F
                even

; =============== S U B R O U T I N E =======================================

sub_5819C:
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   locret_58204
                tst.w   d0
                beq.s   loc_581AE
                movea.w d0,a4
                bsr.w   sub_581B6

loc_581AE:
                swap    d0
                tst.w   d0
                beq.s   locret_58204
                movea.w d0,a4
; End of function sub_5819C

; =============== S U B R O U T I N E =======================================

sub_581B6:
                tst.b   object_control(a4)
                bne.s   locret_58204
                btst    #Status_Invincible,status_secondary(a4)
                bne.s   locret_58204
                tst.b   invulnerability_timer(a4)
                bne.s   locret_58204
                cmpi.b  #4,routine(a4)
                bhs.s   locret_58204
                move.b  #$81,object_control(a4)
                move.b  #$1A,anim(a4)
                bset    #Status_InAir,status(a4)
                clr.b   spin_dash_flag(a4)
                clr.w   x_vel(a4)
                clr.w   y_vel(a4)
                clr.w   ground_vel(a4)
                move.l  d0,d4
                lea     ChildObjDat_582B8(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.l  d4,d0
                move.w  a4,$44(a1)

locret_58204:
                rts
; End of function sub_581B6

; ---------------------------------------------------------------------------
word_58206:
                dc.w    -$10,   $20,  -$28,   $50

; =============== S U B R O U T I N E =======================================

sub_5820E:
                lea     (Player_1).w,a3
                cmpa.w  $44(a0),a3
                bne.s   loc_5821C
                lea     (Player_2).w,a3

loc_5821C:
                tst.w   y_vel(a3)
                bmi.s   loc_58260
                cmpi.b  #2,anim(a3)
                beq.s   loc_58232
                cmpi.b  #9,anim(a3)
                bne.s   loc_58260

loc_58232:
                lea     word_58264(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   locret_5825E
                tst.w   d0
                beq.s   loc_5824A
                movea.w d0,a4
                tst.b   object_control(a4)
                beq.s   loc_58258

loc_5824A:
                swap    d0
                tst.w   d0
                beq.s   locret_5825E
                movea.w d0,a4
                tst.b   object_control(a4)
                bne.s   loc_58260

loc_58258:
                neg.w   y_vel(a3)
                moveq   #1,d0

locret_5825E:
                rts
; ---------------------------------------------------------------------------

loc_58260:
                moveq   #0,d0
                rts
; End of function sub_5820E

; ---------------------------------------------------------------------------
word_58264:
                dc.w    -$1C,   $38,  -$18,   $30
ObjDat_ICZFreezer:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,1,0)
                dc.w    $280
                dc.b    $10,  $C,   6, $9A
word_58278:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    $C,  $C, $16,   0
ObjDat3_58280:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    $14, $10,   2,   0
ObjDat3_5828C:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    4,   4,  $C,   0
ChildObjDat_58298:
                dc.w    1-1
                dc.l    loc_57F14
                dc.b    0,  $C
ChildObjDat_582A0:
                dc.w    1-1
                dc.l    loc_57F14
                dc.b    0, -$C
ChildObjDat_582A8:
                dc.w    1-1
                dc.l    loc_57F40
                dc.b    0, $30
ChildObjDat_582B0:
                dc.w    1-1
                dc.l    loc_57F40
                dc.b    0,-$30
ChildObjDat_582B8:
                dc.w    1-1
                dc.l    loc_57FA6
                dc.b    0,   0
ChildObjDat_582C0:
                dc.w    $C-1
                dc.l    loc_580B2
                dc.b    -$C,  -8
                dc.l    loc_580B2
                dc.b    -4,  -8
                dc.l    loc_580B2
                dc.b    4,  -8
                dc.l    loc_580B2
                dc.b    $C,  -8
                dc.l    loc_580B2
                dc.b    -$C,   0
                dc.l    loc_580B2
                dc.b    -4,   0
                dc.l    loc_580B2
                dc.b    4,   0
                dc.l    loc_580B2
                dc.b    $C,   0
                dc.l    loc_580B2
                dc.b    -$C,   8
                dc.l    loc_580B2
                dc.b    -4,   8
                dc.l    loc_580B2
                dc.b    4,   8
                dc.l    loc_580B2
                dc.b    $C,   8
byte_5830A:
                dc.b    0, $27, $23, $27, $13, $27, $24, $27, $14, $FC
byte_58314:
                dc.b    0, $27,  $C, $27,  $D, $27,  $E, $FC
byte_5831C:
                dc.b    0, $27,  $F, $27, $10, $27, $11, $FC
                even
; ---------------------------------------------------------------------------

Obj_ICZSegmentColumn:
                lea     ObjDat_ICZSegmentColumn(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #Sprite_CheckDelete2,(a0)
                lea     ChildObjDat_584AC(pc),a2
                tst.b   subtype(a0)
                beq.s   loc_58340
                lea     ChildObjDat_584B4(pc),a2

loc_58340:
                jmp     CreateChild8_TreeListRepeated(pc)
; ---------------------------------------------------------------------------

loc_58344:
                lea     word_584A6(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_5836E,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                cmpi.b  #6,d0
                bne.s   loc_58364
                move.b  #3,mapping_frame(a0)

loc_58364:
                lsl.w   #4,d0
                sub.w   d0,y_pos(a0)
                bra.w   loc_58486
; ---------------------------------------------------------------------------

loc_5836E:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   loc_583B0
                move.w  (Player_1+x_vel).w,-(sp)
                move.w  (Player_2+x_vel).w,-(sp)
                bsr.w   sub_58428
                move.l  (sp)+,d0
                moveq   #p1_pushing_bit,d1
                cmpi.b  #3,mapping_frame(a0)
                beq.s   loc_583AC
                tst.b   subtype(a0)
                bne.s   loc_583AC
                lea     (Player_1).w,a1
                bsr.w   sub_58438
                lea     (Player_2).w,a1
                swap    d0
                addq.b  #p2_pushing_bit-p1_pushing_bit,d1
                bsr.w   sub_58438

loc_583AC:
                bra.w   loc_58486
; ---------------------------------------------------------------------------

loc_583B0:
                move.l  #loc_583D6,(a0)
                bset    #0,$38(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                addi.w  #$F,d0
                move.w  d0,$2E(a0)
                move.l  #loc_583E2,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_583D6:
                bsr.w   sub_58428
                jsr     Obj_Wait(pc)
                bra.w   loc_58486
; ---------------------------------------------------------------------------

loc_583E2:
                move.l  #loc_583FC,(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_5840C,$34(a0)
                subq.b  #2,subtype(a0)
                rts
; ---------------------------------------------------------------------------

loc_583FC:
                bsr.w   sub_58428
                addq.w  #4,y_pos(a0)
                jsr     Obj_Wait(pc)
                bra.w   loc_58486
; ---------------------------------------------------------------------------

loc_5840C:
                move.l  #loc_5836E,(a0)
                bclr    #0,$38(a0)
                move.w  #$10,(Screen_shake_flag).w
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                rts

; =============== S U B R O U T I N E =======================================

sub_58428:
                moveq   #$2B,d1
                moveq   #$10,d2
                moveq   #$10,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function sub_58428

; =============== S U B R O U T I N E =======================================

sub_58438:
                btst    d1,status(a0)
                beq.s   locret_58484
                move.w  d0,d3
                tst.w   d3
                bpl.s   loc_58446
                neg.w   d3

loc_58446:
                cmpi.b  #2,anim(a1)
                bne.s   locret_58484
                cmpi.w  #$600,d3
                blo.s   locret_58484
                move.w  d0,x_vel(a1)
                move.w  d0,ground_vel(a1)
                bclr    d1,status(a0)
                bclr    d1,status(a1)
                bset    #0,$38(a0)
                lea     ChildObjDat_582C0(pc),a2
                jsr     CreateChild1_Normal(pc)
                jsr     Displace_PlayerOffObject(pc)
                jsr     Go_Delete_Sprite(pc)
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                addq.w  #4,sp

locret_58484:
                rts
; End of function sub_58438

; ---------------------------------------------------------------------------

loc_58486:
                movea.w $44(a0),a1
                btst    #4,$38(a1)
                bne.w   Go_Delete_Sprite_2
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_ICZSegmentColumn:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $20, $10,  $B,   0
word_584A6:
                dc.w    $280
                dc.b    $20, $10,  $A,   0
ChildObjDat_584AC:
                dc.w    3-1
                dc.l    loc_58344
                dc.b    0,   0
ChildObjDat_584B4:
                dc.w    4-1
                dc.l    loc_58344
                dc.b    0,   0
; ---------------------------------------------------------------------------

Obj_ICZSwingingPlatform:
                lea     ObjDat_ICZSwingingPlatform(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_584D8,(a0)
                lea     ChildObjDat_5891C(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  a1,parent3(a0)
                rts
; ---------------------------------------------------------------------------

loc_584D8:
                btst    #3,$38(a0)
                beq.s   loc_584F4
                move.l  #loc_584F8,(a0)
                btst    #0,render_flags(a0)
                beq.s   loc_584F4
                move.l  #loc_58582,(a0)

loc_584F4:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_584F8:
                move.w  $3E(a0),d0
                subi.w  #$10,d0
                move.w  d0,$3E(a0)
                move.w  $3C(a0),d1
                add.w   d0,d1
                scc     d2
                tst.w   d0
                bpl.s   loc_58514
                tst.b   d2
                bne.s   loc_5853A

loc_58514:
                move.w  d1,$3C(a0)
                tst.b   subtype(a0)
                beq.s   loc_5852A
                cmpi.w  #$4800,d1
                blo.s   loc_5852A
                cmpi.w  #$200,d0
                bhs.s   loc_58554

loc_5852A:
                cmpi.w  #$6E00,d1
                bhs.s   loc_58536
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)

loc_58536:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_5853A:
                move.l  #loc_584D8,(a0)
                bclr    #3,$38(a0)
                clr.w   $3C(a0)
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_58554:
                move.l  #loc_585C4,(a0)
                bset    #2,$38(a0)
                move.b  #$10,y_radius(a0)
                move.w  #$400,d0
                btst    #0,render_flags(a0)
                beq.s   loc_58574
                neg.w   d0

loc_58574:
                move.w  d0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_58582:
                move.w  $3E(a0),d0
                addi.w  #$10,d0
                move.w  d0,$3E(a0)
                move.w  $3C(a0),d1
                add.w   d0,d1
                scs     d2
                tst.w   d0
                bmi.s   loc_5859E
                tst.b   d2
                bne.s   loc_5853A

loc_5859E:
                move.w  d1,$3C(a0)
                tst.b   subtype(a0)
                beq.s   loc_585B4
                cmpi.w  #-$4800,d1
                bhi.s   loc_585B4
                cmpi.w  #$200,d0
                bhs.s   loc_58554

loc_585B4:
                cmpi.w  #-$6E00,d1
                bls.s   loc_585C0
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)

loc_585C0:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_585C4:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   loc_585F8
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_585F8
                add.w   d1,y_pos(a0)
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                blo.s   loc_585FC
                asr.w   #2,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                lea     ChildObjDat_58936(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_585F8:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_585FC:
                move.l  #loc_5861A,(a0)
                move.w  #$10,d0
                tst.w   x_vel(a0)
                bmi.s   loc_5860E
                neg.w   d0

loc_5860E:
                move.w  d0,$40(a0)
                clr.w   y_vel(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_5861A:
                move.w  x_vel(a0),d0
                move.w  d0,d1
                add.w   $40(a0),d0
                eor.w   d0,d1
                bmi.s   loc_5864E
                move.w  d0,x_vel(a0)
                move.w  x_pos(a0),d1
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                eor.w   d0,d1
                btst    #3,d1
                beq.s   loc_5864A
                lea     ChildObjDat_58944(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_5864A:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_5864E:
                move.l  #loc_58658,(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_58658:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_5865C:
                lea     word_58910(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_5866A,(a0)

loc_5866A:
                bsr.w   sub_58838
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_58672:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_58684
                move.l  #loc_5866A,(a0)

loc_58684:
                bsr.w   sub_5880C
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_5868C:
                lea     word_58916(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_5869A,(a0)

loc_5869A:
                bsr.w   sub_58822
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_586A2:
                lea     word_588FC(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_586EA,(a0)
                subi.w  #$80,y_pos(a0)
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   loc_586C8
                bset    #0,render_flags(a0)

loc_586C8:
                bset    #6,render_flags(a0)
                move.w  #7,mainspr_childsprites(a0)
                lea     sub2_mapframe-1(a0),a1
                moveq   #7-1,d6

loc_586DA:
                move.w  #8,(a1)
                addq.w  #next_subspr,a1
                dbf     d6,loc_586DA
                move.b  #8,mapping_frame(a0)

loc_586EA:
                bsr.w   sub_588CC
                bsr.w   sub_5875A
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_586F6:
                lea     ObjDat3_58904(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_58756,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_5873E(pc,d0.w),d1
                neg.w   d1
                move.w  d1,y_vel(a0)
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                bne.s   loc_58722
                neg.w   d1

loc_58722:
                move.w  d1,x_vel(a0)
                lsr.w   #1,d0
                move.b  byte_5874E(pc,d0.w),d0
                movea.w parent3(a0),a1
                move.w  (a1,d0.w),x_pos(a0)
                move.w  sub2_y_pos-sub2_x_pos(a1,d0.w),y_pos(a0)
                rts
; ---------------------------------------------------------------------------
word_5873E:
                dc.w    $80
                dc.w    $100
                dc.w    $180
                dc.w    $200
                dc.w    $280
                dc.w    $300
                dc.w    $380
                dc.w    $400
byte_5874E:
                dc.b    sub9_x_pos
                dc.b    sub2_x_pos
                dc.b    sub3_x_pos
                dc.b    sub4_x_pos
                dc.b    sub5_x_pos
                dc.b    sub6_x_pos
                dc.b    sub7_x_pos
                dc.b    sub8_x_pos
                even
; ---------------------------------------------------------------------------

loc_58756:
                jmp     MoveChkDel(pc)

; =============== S U B R O U T I N E =======================================

sub_5875A:
                movea.w parent3(a0),a1
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                sub.w   d0,d1
                swap    d0
                swap    d1
                move.w  y_pos(a0),d0
                move.w  y_pos(a1),d1
                sub.w   d0,d1
                moveq   #0,d5
                moveq   #6,d6

loc_5877E:
                move.l  d1,d2
                move.w  off_58798(pc,d5.w),d4
                jsr     off_58798(pc,d4.w)
                move.l  d0,(a2)
                swap    d2
                add.l   d2,(a2)+
                addq.w  #2,a2
                addq.w  #2,d5
                dbf     d6,loc_5877E
                rts
; End of function sub_5875A

; ---------------------------------------------------------------------------
off_58798:
                dc.w    loc_587A8-off_58798
                dc.w    loc_587B0-off_58798
                dc.w    loc_587B8-off_58798
                dc.w    loc_587CC-off_58798
                dc.w    loc_587D4-off_58798
                dc.w    loc_587E8-off_58798
                dc.w    loc_587FC-off_58798
                dc.w    locret_5880A-off_58798
; ---------------------------------------------------------------------------

loc_587A8:
                asr.w   #3,d2
                swap    d2
                asr.w   #3,d2
                rts
; ---------------------------------------------------------------------------

loc_587B0:
                asr.w   #2,d2
                swap    d2
                asr.w   #2,d2
                rts
; ---------------------------------------------------------------------------

loc_587B8:
                asr.w   #2,d2
                move.w  d2,d3
                asr.w   #1,d2
                add.w   d3,d2
                swap    d2
                asr.w   #2,d2
                move.w  d2,d3
                asr.w   #1,d2
                add.w   d3,d2
                rts
; ---------------------------------------------------------------------------

loc_587CC:
                asr.w   #1,d2
                swap    d2
                asr.w   #1,d2
                rts
; ---------------------------------------------------------------------------

loc_587D4:
                asr.w   #1,d2
                move.w  d2,d3
                asr.w   #2,d2
                add.w   d3,d2
                swap    d2
                asr.w   #1,d2
                move.w  d2,d3
                asr.w   #2,d2
                add.w   d3,d2
                rts
; ---------------------------------------------------------------------------

loc_587E8:
                asr.w   #1,d2
                move.w  d2,d3
                asr.w   #1,d2
                add.w   d3,d2
                swap    d2
                asr.w   #1,d2
                move.w  d2,d3
                asr.w   #1,d2
                add.w   d3,d2
                rts
; ---------------------------------------------------------------------------

loc_587FC:
                move.w  d2,d3
                asr.w   #3,d3
                sub.w   d3,d2
                swap    d2
                move.w  d2,d3
                asr.w   #3,d3
                sub.w   d3,d2

locret_5880A:
                rts

; =============== S U B R O U T I N E =======================================

sub_5880C:
                move.w  x_pos(a0),-(sp)
                jsr     Refresh_ChildPosition(pc)
                moveq   #$2B,d1
                moveq   #8,d2
                moveq   #8,d3
                move.w  (sp)+,d4
                jmp     (SolidObjectFull).l
; End of function sub_5880C

; =============== S U B R O U T I N E =======================================

sub_58822:
                move.w  x_pos(a0),-(sp)
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #$F,d1
                moveq   #8,d2
                moveq   #8,d3
                move.w  (sp)+,d4
                jmp     (SolidObjectFull).l
; End of function sub_58822

; =============== S U B R O U T I N E =======================================

sub_58838:
                move.b  status(a0),$39(a0)
                bsr.s   sub_5880C
                move.b  $39(a0),d0
                move.b  status(a0),d1
                andi.b  #standing_mask,d1
                beq.s   locret_58866
                movea.w parent3(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d2
                bsr.w   sub_58868
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d2
                bsr.w   sub_58868

locret_58866:
                rts
; End of function sub_58838

; =============== S U B R O U T I N E =======================================

sub_58868:
                btst    d2,d1
                beq.s   locret_58866
                move.w  x_vel(a1),d3
                smi     d4
                cmpi.w  #-$200,d3
                ble.s   loc_5887E
                cmpi.w  #$200,d3
                blt.s   locret_58866

loc_5887E:
                btst    d2,d0
                beq.s   loc_58884
                asr.w   #1,d3

loc_58884:
                btst    #0,render_flags(a2)
                beq.s   loc_5888E
                not.b   d4

loc_5888E:
                tst.b   d4
                bne.s   locret_58866
                move.l  #loc_58672,(a0)
                bset    #3,$38(a2)
                asr.w   #1,d3
                bmi.s   loc_588B0
                cmpi.w  #$400,d3
                ble.s   loc_588BA
                move.w  #$400,d3
                bra.w   loc_588BA
; ---------------------------------------------------------------------------

loc_588B0:
                cmpi.w  #-$400,d3
                bge.s   loc_588BA
                move.w  #-$400,d3

loc_588BA:
                move.w  d3,$3E(a2)
                asl.w   #1,d3
                move.w  d3,x_vel(a1)
                move.w  d3,ground_vel(a1)
                addq.w  #4,sp

locret_588CA:
                rts
; End of function sub_58868

; =============== S U B R O U T I N E =======================================

sub_588CC:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   locret_588CA
                move.w  x_pos(a0),sub5_x_pos(a0)
                move.w  y_pos(a0),sub5_y_pos(a0)
                lea     ChildObjDat_58930(pc),a2
                jsr     CreateChild6_Simple(pc)
                jmp     Go_Delete_Sprite_2(pc)
; End of function sub_588CC

; ---------------------------------------------------------------------------
ObjDat_ICZSwingingPlatform:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,1,0)
                dc.w    $80
                dc.b    $20, $10,   7,   0
word_588FC:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $80, $80,   8,   0
ObjDat3_58904:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    8,   8,   8,   0
word_58910:
                dc.w    $300
                dc.b    $20, $10, $27,   0
word_58916:
                dc.w    $300
                dc.b    $30,   8, $27,   0
ChildObjDat_5891C:
                dc.w    3-1
                dc.l    loc_5865C
                dc.b    0,   8
                dc.l    loc_5868C
                dc.b    $1C,  -8
                dc.l    loc_586A2
                dc.b    0,   0
ChildObjDat_58930:
                dc.w    8-1
                dc.l    loc_586F6
ChildObjDat_58936:
                dc.w    2-1
                dc.l    Obj_ICZSnowdust
                dc.b    $1C, $10
                dc.l    Obj_ICZSnowdust
                dc.b    $14, $10
ChildObjDat_58944:
                dc.w    1-1
                dc.l    Obj_ICZSnowdust
                dc.b    $1C, $10
; ---------------------------------------------------------------------------

Obj_ICZStalagtite:
                jsr     Obj_WaitOffscreen(pc)
                lea     ObjDat_ICZStalagtite(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_58966,(a0)
                move.b  #$10,y_radius(a0)
                rts
; ---------------------------------------------------------------------------

loc_58966:
                bsr.w   sub_58A22
                jsr     Find_SonicTails(pc)
                cmpi.w  #$70,d2
                bhs.s   loc_58988
                move.l  #loc_5898C,(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_589A4,$34(a0)

loc_58988:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5898C:
                moveq   #2,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_58998
                neg.w   d0

loc_58998:
                add.w   d0,x_pos(a0)
                jsr     Obj_Wait(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_589A4:
                move.l  #loc_589B2,(a0)
                move.b  #$82,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_589B2:
                jsr     (MoveSprite).l
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   loc_589DC
                move.l  #loc_589E0,(a0)
                clr.b   collision_flags(a0)
                lea     ChildObjDat_58A4A(pc),a2
                jsr     CreateChild6_Simple(pc)
                moveq   #signextendB(sfx_FloorThump),d0
                jsr     (Play_SFX).l

loc_589DC:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_589E0:
                bsr.w   sub_58A22
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_589E8:
                lea     ObjDat3_58A3E(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #byte_5831C,$30(a0)
                cmpi.b  #6,subtype(a0)
                bhs.s   loc_58A0E
                move.l  #byte_58314,$30(a0)

loc_58A0E:
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d0
                jmp     Set_IndexedVelocity(pc)

; =============== S U B R O U T I N E =======================================

sub_58A22:
                moveq   #$1B,d1
                moveq   #$20,d2
                moveq   #$20,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function sub_58A22

; ---------------------------------------------------------------------------
ObjDat_ICZStalagtite:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $10, $20,   7,   0
ObjDat3_58A3E:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,1)
                dc.w    $280
                dc.b    4,   4,  $F,   0
ChildObjDat_58A4A:
                dc.w    $C-1
                dc.l    loc_589E8
                dc.b    0, $27
                dc.b    $F, $27, $10, $27, $11, $FC
                even
; ---------------------------------------------------------------------------

Obj_ICZIceSpikes:
                jsr     Obj_WaitOffscreen(pc)
                lea     ObjDat_ICZIceSpikes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                tst.b   subtype(a0)
                bne.s   loc_58A84
                move.l  #loc_58A92,(a0)
                lea     ChildObjDat_58B14(pc),a2
                btst    #1,render_flags(a0)
                beq.s   loc_58A80
                lea     ChildObjDat_58B1C(pc),a2

loc_58A80:
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_58A84:
                move.l  #loc_58AA6,(a0)
                move.b  #$92,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_58A92:
                moveq   #$17,d1
                moveq   #8,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_58AA6:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   loc_58AC4
                move.l  #loc_58AC8,(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_58AE0,$34(a0)

loc_58AC4:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_58AC8:
                moveq   #2,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_58AD4
                neg.w   d0

loc_58AD4:
                add.w   d0,x_pos(a0)
                jsr     Obj_Wait(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_58AE0:
                move.l  #MoveTouchChkDel,(a0)

locret_58AE6:
                rts
; ---------------------------------------------------------------------------

loc_58AE8:
                move.b  #$98,collision_flags(a0)
                jsr     (Add_SpriteToCollisionResponseList).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.w   locret_58AE6
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_ICZIceSpikes:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $C, $10,   5,   0
ChildObjDat_58B14:
                dc.w    1-1
                dc.l    loc_58AE8
                dc.b    0,  $C
ChildObjDat_58B1C:
                dc.w    1-1
                dc.l    loc_58AE8
                dc.b    0, -$C
; ---------------------------------------------------------------------------

Obj_ICZIceCube:
                jsr     Obj_WaitOffscreen(pc)
                move.l  #loc_58B3C,(a0)
                lea     ObjDat_ICZIceCube(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_58B3C:
                move.b  (Player_1+anim).w,$3A(a0)
                move.b  (Player_2+anim).w,$3B(a0)
                moveq   #$23,d1
                moveq   #$10,d2
                moveq   #$10,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                bsr.w   sub_58B62
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_58B62:
                move.b  status(a0),d0
                btst    #p1_standing_bit,d0
                beq.s   loc_58B78
                lea     (Player_1).w,a1
                cmpi.b  #2,$3A(a0)
                beq.s   loc_58B8A

loc_58B78:
                btst    #p2_standing_bit,d0
                beq.s   locret_58BD0
; Bug: this should instead write Player_2 to a1
                lea     (Player_1).w,a2
                cmpi.b  #2,$3B(a0)
                bne.s   locret_58BD0

loc_58B8A:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                lea     ChildObjDat_58C20(pc),a2
                jsr     CreateChild1_Normal(pc)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                jsr     (Go_Delete_Sprite).l

locret_58BD0:
                rts
; End of function sub_58B62

; ---------------------------------------------------------------------------

loc_58BD2:
                lea     word_58C18(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #byte_5830A,$30(a0)
                cmpi.b  #$C,subtype(a0)
                blo.s   loc_58BF8
                move.l  #byte_58314,$30(a0)

loc_58BF8:
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
ObjDat_ICZIceCube:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    $18, $10,   3, $2E
word_58C18:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,1)
                dc.w    $280
                dc.b    $20, $20, $12,   0
ChildObjDat_58C20:
                dc.w    $C-1
                dc.l    loc_58BD2
                dc.b    0,  -8
                dc.l    loc_58BD2
                dc.b    0,   8
                dc.l    loc_58BD2
                dc.b    -$10,  -8
                dc.l    loc_58BD2
                dc.b    $10,  -8
                dc.l    loc_58BD2
                dc.b    -$10,   8
                dc.l    loc_58BD2
                dc.b    $10,   8
                dc.l    loc_58BD2
                dc.b    0,   0
                dc.l    loc_58BD2
                dc.b    0,   0
                dc.l    loc_58BD2
                dc.b    0,   0
                dc.l    loc_58BD2
                dc.b    0,   0
                dc.l    loc_58BD2
                dc.b    0,   0
                dc.l    loc_58BD2
                dc.b    0,   0
; ---------------------------------------------------------------------------

Obj_ICZHarmfulIce:
                jsr     Obj_WaitOffscreen(pc)
                lea     ObjDat3_58CCA(pc),a1
                move.l  #Sprite_CheckDeleteTouch,(a0)
                tst.b   subtype(a0)
                beq.s   loc_58C88
                lea     ObjDat3_58CD6(pc),a1
                move.l  #loc_58C8C,(a0)

loc_58C88:
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_58C8C:
                moveq   #0,d0
                move.b  collision_property(a0),d0
                bne.s   loc_58C98
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_58C98:
                add.w   d0,d0
                movea.w word_58CC4-2(pc,d0.w),a1
; Bug: no invincibility or invulnerability checks are performed,
; allowing Super Sonic to be hurt
                movea.l a0,a2
                movea.l a1,a0
                jsr     (HurtCharacter).l
                movea.l a2,a0

                lea     ChildObjDat_58CE2(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     Go_Delete_Sprite(pc)
                moveq   #signextendB(sfx_IceSpikes),d0
                jsr     (Play_SFX).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_58CC4:
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_1
ObjDat3_58CCA:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $10, $18,   5, $82
ObjDat3_58CD6:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $10, $10,   4, $D7
ChildObjDat_58CE2:
                dc.w    $C-1
                dc.l    loc_589E8
; ---------------------------------------------------------------------------

Obj_ICZSnowPile:
                jsr     Obj_WaitOffscreen(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                bclr    #7,d0
                lea     off_58F8C(pc),a1
                lea     (a1,d0.w),a2
                move.l  (a2)+,(a0)
                movea.l (a2)+,a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_58D06:
                lea     word_58D28(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   loc_58D24
                tst.w   d0
                beq.s   loc_58D1A
                bsr.w   sub_58D30

loc_58D1A:
                swap    d0
                tst.w   d0
                beq.s   loc_58D24
                bsr.w   sub_58D30

loc_58D24:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
word_58D28:
                dc.w    -$28,   $50,  -$18,   $20

; =============== S U B R O U T I N E =======================================

sub_58D30:
                movea.w d0,a3
                move.w  d0,$44(a0)
                cmpi.b  #9,anim(a3)
                beq.s   loc_58D5E
                btst    #Status_InAir,status(a3)
                bne.s   locret_58D5C
                move.w  x_vel(a3),d2
                move.w  d2,d3
                bpl.s   loc_58D50
                neg.w   d2

loc_58D50:
                cmpi.w  #$600,d2
                bhs.s   loc_58D5E
                asr.w   #1,d3
                move.w  d3,ground_vel(a3)

locret_58D5C:
                rts
; ---------------------------------------------------------------------------

loc_58D5E:
                move.w  a3,$44(a0)
                lea     ChildObjDat_58FE4(pc),a2
                jsr     CreateChild1_Normal(pc)
                jsr     (Go_Delete_Sprite).l
                addq.w  #4,sp

locret_58D72:
                rts
; End of function sub_58D30

; ---------------------------------------------------------------------------

loc_58D74:
                lea     word_58DA6(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.w   d0
                bne.s   loc_58D84
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_58D84:
                move.w  d0,$44(a0)
                beq.s   loc_58DA0
                movea.w d0,a1
                move.w  #$800,x_vel(a1)
                move.w  #$800,ground_vel(a1)
                lea     ChildObjDat_5900A(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_58DA0:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
word_58DA6:
                dc.w    -8,   $10,  -$10,   $20
; ---------------------------------------------------------------------------

loc_58DAE:
                lea     word_58DF0(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.w   d0
                bne.s   loc_58DBE
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_58DBE:
                move.w  d0,$44(a0)
                beq.s   loc_58DEA
                movea.w d0,a1
                move.w  #$800,x_vel(a1)
                move.w  #$800,ground_vel(a1)
                lea     ChildObjDat_59018(pc),a2
                jsr     CreateChild1_Normal(pc)
                btst    #7,subtype(a0)
                beq.s   loc_58DEA
                move.w  #$600,d0
                jsr     StartNewLevel(pc)

loc_58DEA:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
word_58DF0:
                dc.w    -8,   $10,  -$10,   $20
; ---------------------------------------------------------------------------

loc_58DF8:
                move.w  a0,(_unkFAAE).w
                btst    #5,$38(a0)
                bne.s   loc_58E40
                move.w  (Camera_X_pos_copy).w,x_pos(a0)
                move.w  (Camera_Y_pos_copy).w,y_pos(a0)
                subq.w  #8,y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   locret_58E3E
                move.w  #8,$2E(a0)
                move.b  (Hyudoro_count).w,d0
                addq.b  #1,d0
                cmpi.b  #$3C,d0
                bhi.s   locret_58E3E
                move.b  d0,(Hyudoro_count).w
                jsr     (AllocateObject).l
                bne.s   locret_58E3E
                move.l  #loc_58E46,(a1)

locret_58E3E:
                rts
; ---------------------------------------------------------------------------

loc_58E40:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_58E46:
                lea     ObjDat3_58FD0(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_58EB8,(a0)
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                cmpi.w  #$140,d0
                blo.s   loc_58E6A
                andi.w  #$3F,d0
                lsl.w   #2,d0

loc_58E6A:
                add.w   (Camera_X_pos).w,d0
                cmpi.w  #$380,d0
                blo.s   loc_58EEE
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subq.w  #4,d0
                move.w  d0,y_pos(a0)
                swap    d0
                move.w  d0,d1
                andi.w  #3,d0
                move.b  RawAni_58EAC(pc,d0.w),mapping_frame(a0)
                add.w   d0,d0
                move.w  word_58EB0(pc,d0.w),priority(a0)
                andi.w  #$3C,d1
                subi.w  #$20,d1
                move.w  d1,x_vel(a0)
                move.w  #$100,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
RawAni_58EAC:
                dc.b    $B, $10,  $B,  $B
                even
word_58EB0:
                dc.w    $80
                dc.w    $380
                dc.w    $80
                dc.w    $80
; ---------------------------------------------------------------------------

loc_58EB8:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bmi.s   loc_58ECA
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_58ECA:
                move.l  #loc_58ED2,(a0)
                rts
; ---------------------------------------------------------------------------

loc_58ED2:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bpl.s   loc_58EEE
                bchg    #0,$38(a0)
                bne.w   locret_58D72
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_58EEE:
                move.b  (Hyudoro_count).w,d0
                subq.b  #1,d0
                bmi.s   loc_58EFA
                move.b  d0,(Hyudoro_count).w

loc_58EFA:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_58F00:
                lea     word_58FDC(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_58F1E,(a0)
                move.l  #loc_58F28,$34(a0)
                bsr.w   sub_58F38
                jsr     Refresh_ChildPositionAdjusted(pc)

loc_58F1E:
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_58F28:
                move.l  #loc_58F30,(a0)
                rts
; ---------------------------------------------------------------------------

loc_58F30:
                jsr     MoveSprite_LightGravity(pc)
                jmp     Sprite_CheckDeleteXY(pc)

; =============== S U B R O U T I N E =======================================

sub_58F38:
                movea.w parent3(a0),a1
                move.w  $44(a1),d0
                beq.s   locret_58F72
                movea.w d0,a2
                lea     word_58F74(pc),a3
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.l  (a3,d0.w),x_vel(a0)             ; and y_vel
                btst    #0,render_flags(a2)
                beq.s   locret_58F72
                bset    #0,render_flags(a0)
                bset    #0,render_flags(a1)
                neg.w   x_vel(a0)

locret_58F72:
                rts
; End of function sub_58F38

; ---------------------------------------------------------------------------
word_58F74:
                dc.w    -$300, -$200
                dc.w    -$400, -$300
                dc.w    -$400, -$280
                dc.w    -$280, -$200
                dc.w    -$200, -$180
                dc.w    -$200, -$100
off_58F8C:
                dc.l    loc_58D06
                dc.l    ObjDat3_58FAC
                dc.l    loc_58D74
                dc.l    ObjDat3_58FB8
                dc.l    loc_58DAE
                dc.l    ObjDat3_58FC4
                dc.l    loc_58DF8
                dc.l    ObjDat3_58FD0
ObjDat3_58FAC:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,0)
                dc.w    $80
                dc.b    $18,   8, $20,   0
ObjDat3_58FB8:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,1)
                dc.w    $80
                dc.b    8, $10, $21,   0
ObjDat3_58FC4:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,1)
                dc.w    $80
                dc.b    $10, $10, $22,   0
ObjDat3_58FD0:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    4,   4,  $B,   0
word_58FDC:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    8,   8,   9,   0
ChildObjDat_58FE4:
                dc.w    6-1
                dc.l    loc_58F00
                dc.b    -8,  -8
                dc.l    loc_58F00
                dc.b    8,  -8
                dc.l    loc_58F00
                dc.b    -$18,   0
                dc.l    loc_58F00
                dc.b    -8,   0
                dc.l    loc_58F00
                dc.b    8,   0
                dc.l    loc_58F00
                dc.b    $18,   0
ChildObjDat_5900A:
                dc.w    2-1
                dc.l    loc_58F00
                dc.b    0,  -8
                dc.l    loc_58F00
                dc.b    0,   8
ChildObjDat_59018:
                dc.w    4-1
                dc.l    loc_58F00
                dc.b    -8,  -8
                dc.l    loc_58F00
                dc.b    0,   8
                dc.l    loc_58F00
                dc.b    8,  -8
                dc.l    loc_58F00
                dc.b    8,   8
; ---------------------------------------------------------------------------

Obj_ICZTensionPlatform:
                lea     ObjDat_ICZTensionPlatform(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_5904E,(a0)
                move.w  y_pos(a0),$30(a0)
                lea     ChildObjDat_59268(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_5904E:
                bsr.w   sub_590E8
                bsr.w   sub_591B4
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5905A:
                lea     word_59260(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_5908A,(a0)
                tst.b   subtype(a0)
                beq.s   loc_59074
                bset    #0,render_flags(a0)

loc_59074:
                bset    #6,render_flags(a0)
                move.w  #2,mainspr_childsprites(a0)
                bsr.w   sub_59092
                move.b  #8,mapping_frame(a0)

loc_5908A:
                bsr.w   sub_590C8
                jmp     Child_Draw_Sprite(pc)

; =============== S U B R O U T I N E =======================================

sub_59092:
                lea     sub2_x_pos(a0),a1
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                moveq   #0,d2
                moveq   #1,d3

loc_590A2:
                move.w  d0,d4
                move.w  word_590C4(pc,d2.w),d5
                btst    #0,render_flags(a0)
                beq.s   loc_590B2
                neg.w   d5

loc_590B2:
                add.w   d5,d4
                move.w  d4,(a1)+
                move.w  d1,(a1)+
                move.w  #8,(a1)+
                addq.w  #2,d2
                dbf     d3,loc_590A2
                rts
; End of function sub_59092

; ---------------------------------------------------------------------------
word_590C4:
                dc.w    $C,   $18

; =============== S U B R O U T I N E =======================================

sub_590C8:
                movea.w parent3(a0),a1
                lea     sub2_y_pos(a0),a2
                move.w  y_pos(a0),d0
                move.w  y_pos(a1),d1
                move.w  d1,d2
                sub.w   d0,d1
                asr.w   #1,d1
                add.w   d0,d1
                move.w  d1,(a2)
                addq.w  #6,a2
                move.w  d2,(a2)
                rts
; End of function sub_590C8

; =============== S U B R O U T I N E =======================================

sub_590E8:
                btst    #2,$38(a0)
                beq.s   locret_5916E
                move.w  #$80,d0
                move.w  y_pos(a0),d1
                move.w  sub2_y_pos(a0),d2
                move.b  $39(a0),d3
                sub.w   $32(a0),d1
                scs     $39(a0)
                bcs.s   loc_59110
                neg.w   d0
                bra.w   loc_59112
; ---------------------------------------------------------------------------

loc_59110:
                neg.w   d1

loc_59112:
                cmp.b   $39(a0),d3
                beq.s   loc_59142
                add.w   d0,d2
                add.w   d0,d2
                cmpi.w  #-$80,d2
                bge.s   loc_59130
                cmpi.w  #-$400,d2
                bgt.s   loc_59142
                bsr.w   sub_59170
                bra.w   loc_59142
; ---------------------------------------------------------------------------

loc_59130:
                cmpi.w  #$80,d2
                bgt.s   loc_59142
                cmpi.w  #1,d1
                bhi.s   loc_59142
                bclr    #2,$38(a0)

loc_59142:
                add.w   d0,d2
                move.w  #-$900,d3
                cmp.w   d3,d2
                bge.s   loc_59150
                bra.w   loc_59156
; ---------------------------------------------------------------------------

loc_59150:
                neg.w   d3
                cmp.w   d3,d2
                ble.s   loc_59158

loc_59156:
                move.w  d3,d2

loc_59158:
                move.w  d2,y_vel(a0)
                jsr     (MoveSprite2).l
                cmpi.w  #$50,d1
                blo.s   locret_5916E
                move.w  #-$100,y_vel(a0)

locret_5916E:
                rts
; End of function sub_590E8

; =============== S U B R O U T I N E =======================================

sub_59170:
                move.b  $3A(a0),d3
                andi.b  #standing_mask,d3
                beq.s   locret_591B2
                btst    #p1_standing_bit,d3
                beq.s   loc_59188
                lea     (Player_1).w,a1
                bsr.w   sub_59192

loc_59188:
                btst    #p2_standing_bit,d3
                beq.s   locret_591B2
                lea     (Player_2).w,a1
; End of function sub_59170

; =============== S U B R O U T I N E =======================================

sub_59192:
                move.w  d2,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)

locret_591B2:
                rts
; End of function sub_59192

; =============== S U B R O U T I N E =======================================

sub_591B4:
                move.b  status(a0),$3A(a0)
                move.w  (Player_1+y_vel).w,-(sp)
                move.w  (Player_2+y_vel).w,-(sp)
                moveq   #$23,d1
                moveq   #$14,d2
                moveq   #$B,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                move.l  (sp)+,d0
                move.b  status(a0),d1
                move.b  $3A(a0),d2
                move.b  d1,$3A(a0)
                eor.b   d1,d2
                andi.b  #standing_mask,d2
                beq.s   locret_59214
                bsr.w   sub_59236
                bset    #2,$38(a0)
                clr.b   $39(a0)
                moveq   #p1_standing_bit,d4
                btst    d4,d2
                beq.s   loc_59204
                lea     (Player_1).w,a1
                bsr.w   sub_59216

loc_59204:
                moveq   #p2_standing_bit,d4
                btst    d4,d2
                beq.s   locret_59214
                swap    d0
                lea     (Player_2).w,a1
                bsr.w   sub_59216

locret_59214:
                rts
; End of function sub_591B4

; =============== S U B R O U T I N E =======================================

sub_59216:
                move.w  y_vel(a0),d5
                btst    d4,d1
                bne.s   loc_59228
                tst.w   d0
                bpl.s   loc_59228
                add.w   d5,y_vel(a1)
                neg.w   d0

loc_59228:
                add.w   d0,d5
                move.w  d5,d6
                asr.w   #2,d6
                sub.w   d6,d5
                move.w  d5,y_vel(a0)
                rts
; End of function sub_59216

; =============== S U B R O U T I N E =======================================

sub_59236:
                moveq   #0,d5
                btst    #3,d1
                beq.s   loc_59240
                addq.w  #8,d5

loc_59240:
                btst    #4,d1
                beq.s   loc_59248
                addq.w  #8,d5

loc_59248:
                move.w  $30(a0),d3
                add.w   d5,d3
                move.w  d3,$32(a0)
                rts
; End of function sub_59236

; ---------------------------------------------------------------------------
ObjDat_ICZTensionPlatform:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,0)
                dc.w    $280
                dc.b    $18,  $C, $1F,   0
word_59260:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $40, $40,   8,   0
ChildObjDat_59268:
                dc.w    2-1
                dc.l    loc_5905A
                dc.b    -$38,   0
                dc.l    loc_5905A
                dc.b    $38,   0
; ---------------------------------------------------------------------------

Obj_Penguinator:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Penguinator_Index(pc,d0.w),d1
                jsr     Penguinator_Index(pc,d1.w)
                lea     DPLCPtr_Penguinator(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Sprite_CheckDeleteTouchSlotted(pc)
; ---------------------------------------------------------------------------
Penguinator_Index:
                dc.w    loc_592A6-Penguinator_Index
                dc.w    loc_59302-Penguinator_Index
                dc.w    loc_5939C-Penguinator_Index
                dc.w    loc_593B6-Penguinator_Index
                dc.w    loc_59404-Penguinator_Index
                dc.w    loc_59452-Penguinator_Index
                dc.w    loc_5948C-Penguinator_Index
                dc.w    loc_594D4-Penguinator_Index
; ---------------------------------------------------------------------------

loc_592A6:
                lea     ObjSlot_Penguinator(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                bclr    #1,render_flags(a0)
                beq.s   loc_592BC
                bset    #7,art_tile(a0)

loc_592BC:
                move.b  #2,routine(a0)
                move.b  #$F,y_radius(a0)
                move.b  #4,x_radius(a0)
                bclr    #5,$38(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                clr.w   $2E(a0)
                move.l  #byte_595A2,$30(a0)
                move.l  #loc_5938C,$34(a0)
                moveq   #2,d0
                btst    #0,render_flags(a0)
                bne.s   loc_592FC
                neg.w   d0

loc_592FC:
                move.w  d0,$40(a0)
                rts
; ---------------------------------------------------------------------------

loc_59302:
                jsr     Animate_RawGetFaster(pc)
                beq.s   loc_59310
                cmpi.b  #2,$2E(a0)
                bls.s   loc_59328

loc_59310:
                move.w  $40(a0),d0
                move.w  x_vel(a0),d1
                add.w   d0,d1
                move.w  d1,x_vel(a0)
                jsr     (MoveSprite2).l
                jmp     ObjHitFloor2_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_59328:
                jsr     (ObjCheckFloorDist).l
                tst.b   d3
                beq.s   loc_59344
                btst    #0,render_flags(a0)
                beq.s   loc_5933E
                bchg    #6,d3

loc_5933E:
                btst    #6,d3
                beq.s   loc_59378

loc_59344:
                move.b  #4,routine(a0)
                move.w  #-$200,d0
                move.w  #$40,d1
                btst    #0,render_flags(a0)
                beq.s   loc_5935E
                neg.w   d0
                neg.w   d1

loc_5935E:
                move.w  d0,x_vel(a0)
                move.w  d1,$40(a0)
                move.l  #byte_595A9,$30(a0)
                move.l  #loc_593A0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_59378:
                move.b  #$E,routine(a0)
                move.w  #$40,$2E(a0)
                move.l  #loc_59344,$34(a0)

loc_5938C:
                neg.w   x_vel(a0)
                neg.w   $40(a0)
                bchg    #0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_5939C:
                jmp     Move_AnimateRaw(pc)
; ---------------------------------------------------------------------------

loc_593A0:
                move.b  #6,routine(a0)
                move.b  #$B,y_radius(a0)
                move.l  #loc_593BE,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_593B6:
                jsr     MoveSprite_LightGravity(pc)
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_593BE:
                tst.b   d3
                move.b  d3,d4
                bpl.s   loc_593C6
                neg.b   d4

loc_593C6:
                andi.b  #$F8,d4
                beq.s   loc_593EA
                tst.w   x_vel(a0)
                bmi.s   loc_593D6
                bchg    #6,d3

loc_593D6:
                btst    #6,d3
                bne.s   loc_593EA
                neg.w   x_vel(a0)
                neg.w   $40(a0)
                bchg    #0,render_flags(a0)

loc_593EA:
                move.b  #8,routine(a0)
                move.w  #$20,$2E(a0)
                move.l  #loc_5942C,$34(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_59404:
                bsr.w   sub_59520
                cmpi.w  #-2,d1
                blt.w   loc_5938C
                cmpi.w  #$C,d1
                bge.s   loc_593A0
                add.w   d1,y_pos(a0)
                bsr.w   sub_59534
                bsr.w   sub_5955A
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5942C:
                move.b  #$A,routine(a0)
                moveq   #8,d0
                sub.b   mapping_frame(a0),d0
                move.b  d0,anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #byte_595AE,$30(a0)
                move.l  #loc_59474,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_59452:
                bsr.w   sub_59520
                cmpi.w  #-2,d1
                blt.w   loc_5938C
                cmpi.w  #$C,d1
                bge.w   loc_593A0
                add.w   d1,y_pos(a0)
                jsr     (MoveSprite2).l
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_59474:
                move.b  #$C,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.b  #$F,y_radius(a0)
                subq.w  #4,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_5948C:
                move.w  x_vel(a0),d0
                add.w   $40(a0),d0
                move.w  d0,x_vel(a0)
                beq.s   loc_594B4
                bsr.w   sub_59520
                cmpi.w  #-2,d1
                blt.s   loc_594B4
                cmpi.w  #$C,d1
                bge.s   loc_594B4
                add.w   d1,y_pos(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_594B4:
                move.b  #$E,routine(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$2E(a0)
                move.l  #loc_592BC,$34(a0)
                bchg    #0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_594D4:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_ICZSnowdust:
                lea     ObjDat_ICZSnowdust(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                beq.s   loc_59504
                move.l  #Obj_Wait,(a0)
                lsl.w   #2,d0
                subq.w  #1,d0
                move.w  d0,$2E(a0)
                move.l  #loc_59504,$34(a0)

locret_59502:
                rts
; ---------------------------------------------------------------------------

loc_59504:
                move.l  #loc_59512,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

loc_59512:
                lea     byte_595B7(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_59520:
                move.w  x_vel(a0),d3
                ext.l   d3
                lsl.l   #8,d3
                add.l   x_pos(a0),d3
                swap    d3
                jmp     (ObjCheckFloorDist2).l
; End of function sub_59520

; =============== S U B R O U T I N E =======================================

sub_59534:
                moveq   #4,d0
                tst.b   d3
                beq.s   loc_59544
                lsr.b   #3,d3
                andi.w  #$F,d3
                move.b  RawAni_5954A(pc,d3.w),d0

loc_59544:
                move.b  d0,mapping_frame(a0)
                rts
; End of function sub_59534

; ---------------------------------------------------------------------------
RawAni_5954A:
                dc.b    4,  5,  6,  6,  7,  7,  8,  8,  8,  8,  7,  7,  6,  6,  5,  4
                even

; =============== S U B R O U T I N E =======================================

sub_5955A:
                move.w  $2E(a0),d0
                andi.w  #3,d0
                bne.s   locret_59502
                moveq   #signextendB(sfx_SlideSkidQuiet),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_59592(pc),a2
                jmp     CreateChild1_Normal(pc)
; End of function sub_5955A

; ---------------------------------------------------------------------------
ObjSlot_Penguinator:
                dc.w    4-1
                dc.w    make_art_tile(ArtTile_Penguinator,1,0)
                dc.w    $12,     0
                dc.l    Map_Penguinator
                dc.w    $280
                dc.b    $14, $10,   0, $1A
ObjDat_ICZSnowdust:
                dc.l    Map_ICZSnowdust
                dc.w    make_art_tile(ArtTile_ICZSnowdust,1,0)
                dc.w    0
                dc.b    4, $18,   0,   0
ChildObjDat_59592:
                dc.w    1-1
                dc.l    Obj_ICZSnowdust
                dc.b    0,  $C
DPLCPtr_Penguinator:
                dc.l    ArtUnc_Penguinator
                dc.l    DPLC_Penguinator
byte_595A2:
                dc.b    7, $10
                dc.b    0,   1
                dc.b    0,   2
                dc.b    $FC
byte_595A9:
                dc.b    3,   3,   3,   4, $F4
byte_595AE:
                dc.b    3,   8,   8,   7,   6,   5,   4,   3, $F4
byte_595B7:
                dc.b    0,   0,   0,   1,   2,   3,   4,   5,   4,   3,   2,   1,   0, $F4
                even
; ---------------------------------------------------------------------------

Obj_StarPointer:
                jsr     (Obj_WaitOffscreen).l
                lea     ObjDat_StarPointer(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_5960C,(a0)
                bclr    #1,render_flags(a0)
                beq.s   loc_595E8
                bset    #7,art_tile(a0)

loc_595E8:
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #6,d0
                move.w  word_59604(pc,d0.w),d4
                jsr     (Set_VelocityXTrackSonic).l
                lea     ChildObjDat_59738(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------
word_59604:
                dc.w    -$40,  -$60,  -$80, -$100
; ---------------------------------------------------------------------------

loc_5960C:
                jsr     (MoveSprite2).l
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                bhs.s   loc_5962A
                btst    #0,render_flags(a0)
                beq.s   loc_59626
                subq.w  #2,d0

loc_59626:
                tst.w   d0
                beq.s   loc_5962E

loc_5962A:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5962E:
                move.l  #loc_5963E,(a0)
                bset    #1,$38(a0)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5963E:
                jsr     (MoveSprite2).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_59648:
                lea     word_59732(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #3,shield_reaction(a0)
                move.b  #8,x_radius(a0)
                move.l  #loc_5967E,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  byte_5967A(pc,d0.w),$3C(a0)
                move.l  #loc_596FC,$34(a0)
                rts
; ---------------------------------------------------------------------------
byte_5967A:
                dc.b    0, $40, $80, $C0
                even
; ---------------------------------------------------------------------------

loc_5967E:
                btst    #0,(V_int_run_count+3).w
                bne.s   loc_596D6
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   loc_5969A
                addq.b  #1,$3C(a0)
                bra.w   loc_5969E
; ---------------------------------------------------------------------------

loc_5969A:
                subq.b  #1,$3C(a0)

loc_5969E:
                bne.s   loc_596D6
                btst    #1,$38(a1)
                beq.s   loc_596D6
                move.l  #loc_596E4,(a0)
                move.w  x_vel(a1),d0
                asl.w   #1,d0
                move.l  #ObjHitWall_DoRoutine,$30(a0)
                move.w  #8,$44(a0)
                move.w  d0,x_vel(a0)
                bpl.s   loc_596D6
                move.l  #ObjHitWall2_DoRoutine,$30(a0)
                move.w  #-8,$44(a0)

loc_596D6:
                bsr.w   sub_59718
                moveq   #4,d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_596E4:
                jsr     (MoveSprite2).l
                movea.l $30(a0),a1
                move.w  $44(a0),d3
                jsr     (a1)
                bsr.w   sub_59718
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

loc_596FC:
                move.l  #loc_5970C,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5970C:
                lea     byte_59740(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     Sprite_CheckDeleteTouchXY(pc)

; =============== S U B R O U T I N E =======================================

sub_59718:
                tst.b   collision_flags(a0)
                bne.s   locret_59724
                movea.l $34(a0),a1
                jsr     (a1)

locret_59724:
                rts
; End of function sub_59718

; ---------------------------------------------------------------------------
ObjDat_StarPointer:
                dc.l    Map_StarPointer
                dc.w    make_art_tile(ArtTile_StarPointer,1,0)
                dc.w    $280
                dc.b    8,   8,   0,  $B
word_59732:
                dc.w    $280
                dc.b    8,   8,   1, $8B
ChildObjDat_59738:
                dc.w    4-1
                dc.l    loc_59648
                dc.b    0,   0
byte_59740:
                dc.b    3,   1,   2,   3, $F4
                even
; ---------------------------------------------------------------------------

Obj_SnaleBlaster:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SnaleBlaster_Index(pc,d0.w),d1
                jsr     SnaleBlaster_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
SnaleBlaster_Index:
                dc.w    loc_5976C-SnaleBlaster_Index
                dc.w    loc_5978A-SnaleBlaster_Index
                dc.w    loc_597BE-SnaleBlaster_Index
                dc.w    loc_597EA-SnaleBlaster_Index
                dc.w    loc_59842-SnaleBlaster_Index
                dc.w    loc_5986C-SnaleBlaster_Index
                dc.w    loc_5988C-SnaleBlaster_Index
; ---------------------------------------------------------------------------

loc_5976C:
                lea     ObjDat_SnaleBlaster(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #$20,$2E(a0)
                move.l  #loc_597A6,$34(a0)
                lea     ChildObjDat_59A1C(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_5978A:
                move.b  #$1A,collision_flags(a0)
                clr.b   collision_property(a0)
                btst    #1,$38(a0)
                bne.s   loc_597A2
                move.b  #$7F,collision_property(a0)

loc_597A2:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_597A6:
                move.b  #4,routine(a0)
                move.l  #byte_59A48,$30(a0)
                move.l  #loc_597C8,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_597BE:
                move.b  #$1A,collision_flags(a0)
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_597C8:
                move.w  #-2,$40(a0)
                move.l  #byte_59A52,$30(a0)

loc_597D6:
                move.b  #6,routine(a0)
                move.b  #2,$39(a0)
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_597EA:
                move.b  #$1A,collision_flags(a0)
                move.b  #$7F,collision_property(a0)
                bsr.w   sub_599CE
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   locret_59820
                moveq   #3,d0
                tst.w   $40(a0)
                bmi.s   loc_5980C
                moveq   #4,d0

loc_5980C:
                cmp.b   mapping_frame(a0),d0
                bne.s   locret_59820
                move.w  $40(a0),d0
                add.w   d0,y_pos(a0)
                subq.b  #1,$39(a0)
                bmi.s   loc_59822

locret_59820:
                rts
; ---------------------------------------------------------------------------

loc_59822:
                move.b  #2,routine(a0)
                move.w  #$90,$2E(a0)
                bset    #1,$38(a0)
                move.l  #loc_597D6,$34(a0)
                neg.w   $40(a0)
                rts
; ---------------------------------------------------------------------------

loc_59842:
                move.b  #$7F,collision_property(a0)
                subq.b  #1,mapping_frame(a0)
                beq.s   loc_59850
                rts
; ---------------------------------------------------------------------------

loc_59850:
                move.b  #$A,routine(a0)
                move.b  #$7F,collision_property(a0)
                move.w  #60-1,$2E(a0)
                move.l  #loc_59876,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5986C:
                move.b  #$7F,collision_property(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_59876:
                move.b  #$C,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_59890,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5988C:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_59890:
                move.b  #$1A,collision_flags(a0)
                move.b  #$7F,collision_property(a0)
                move.w  #2,$2E(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   locret_598B4
                move.b  #6,routine(a0)

locret_598B4:
                rts
; ---------------------------------------------------------------------------

loc_598B6:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_598CC(pc,d0.w),d1
                jsr     off_598CC(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_598CC:
                dc.w    loc_598D2-off_598CC
                dc.w    loc_598DA-off_598CC
                dc.w    Animate_RawMultiDelay-off_598CC
; ---------------------------------------------------------------------------

loc_598D2:
                lea     word_59A14(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_598DA:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_598E8
                rts
; ---------------------------------------------------------------------------

loc_598E8:
                move.b  #4,routine(a0)
                move.l  #byte_59A57,$30(a0)
                move.l  #loc_59900,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_59900:
                move.b  #2,routine(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_59912:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_59928(pc,d0.w),d1
                jsr     off_59928(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
off_59928:
                dc.w    loc_59930-off_59928
                dc.w    loc_59938-off_59928
                dc.w    loc_5996C-off_59928
                dc.w    loc_599B8-off_59928
; ---------------------------------------------------------------------------

loc_59930:
                lea     word_59A1A(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_59938:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_59946
                rts
; ---------------------------------------------------------------------------

loc_59946:
                move.b  #4,routine(a0)
                move.l  #byte_59A62,$30(a0)
                tst.b   subtype(a0)
                beq.s   loc_59962
                move.l  #byte_59A6B,$30(a0)

loc_59962:
                move.l  #loc_599B0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5996C:
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   locret_599AE
                bmi.s   locret_599AE
                cmpi.b  #4,anim_frame(a0)
                bne.s   locret_599AE
                tst.b   render_flags(a0)
                bpl.s   locret_599AE
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_59A30(pc),a2
                jsr     CreateChild2_Complex(pc)
                movea.w parent3(a0),a2
                btst    #0,render_flags(a2)
                beq.s   loc_599A4
                neg.w   x_vel(a1)

loc_599A4:
                tst.b   subtype(a0)
                beq.s   locret_599AE
                neg.w   y_vel(a1)

locret_599AE:
                rts
; ---------------------------------------------------------------------------

loc_599B0:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_599B8:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_599C6
                rts
; ---------------------------------------------------------------------------

loc_599C6:
                move.b  #2,routine(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_599CE:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$30,d2
                bhs.s   locret_599E6
                cmpi.w  #$30,d3
                bhs.s   locret_599E6
                cmpi.b  #2,anim(a1)
                beq.s   loc_599E8

locret_599E6:
                rts
; ---------------------------------------------------------------------------

loc_599E8:
                move.b  #8,routine(a0)
                move.b  #3,mapping_frame(a0)
                addq.w  #4,sp
                rts
; End of function sub_599CE

; ---------------------------------------------------------------------------
ObjDat_SnaleBlaster:
                dc.l    Map_SnaleBlaster
                dc.w    make_art_tile(ArtTile_SnaleBlaster,1,0)
                dc.w    $200
                dc.b    $10, $10,   0,  $B
word_59A14:
                dc.w    $180
                dc.b    4,  $C,   5,   0
word_59A1A:
                dc.w    $200
                dc.b    4,   4,   7,   0
ObjDat3_59A10:
                dc.l    Map_SnaleBlaster
                dc.w    make_art_tile(ArtTile_SnaleBlaster,0,1)
                dc.w    $200
                dc.b    4,   4,   9, $98
ChildObjDat_59A1C:
                dc.w    3-1
                dc.l    loc_59912
                dc.b    -8,   0
                dc.l    loc_59912
                dc.b    -8,   7
                dc.l    loc_598B6
                dc.b    -8,   4
ChildObjDat_59A30:
                dc.w    1-1
                dc.l    loc_54B46
                dc.l    ObjDat3_59A10
                dc.l    0
                dc.l    MoveSprite2
                dc.b    0,   0
                dc.w    -$200, -$100
byte_59A48:
                dc.b    5,   0,   1,   2,   3,   4,   4,   4,   4, $F4
byte_59A52:
                dc.b    4,  $F
                dc.b    3,  $F
                dc.b    $FC
byte_59A57:
                dc.b    5,   2
                dc.b    6,   2
                dc.b    $A, $5F
                dc.b    6,   2
                dc.b    5,   2
                dc.b    $F4
byte_59A62:
                dc.b    7,   2
                dc.b    7, $1F
                dc.b    8,   3
                dc.b    7,   0
                dc.b    $F4
byte_59A6B:
                dc.b    7,   2
                dc.b    7, $2F
                dc.b    8,   3
                dc.b    7,   0
                dc.b    $F4
                even
; ---------------------------------------------------------------------------

Obj_Ribot:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Ribot_Index(pc,d0.w),d1
                jsr     Ribot_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Ribot_Index:
                dc.w    loc_59A90-Ribot_Index
                dc.w    loc_59AD8-Ribot_Index
; ---------------------------------------------------------------------------

loc_59A90:
                lea     ObjDat_Ribot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bset    #2,$38(a0)
                move.b  subtype(a0),d0
                subq.b  #2,d0
                beq.s   loc_59AB8
                bpl.s   loc_59AC8
                move.l  #byte_59DA6,$30(a0)
                lea     ChildObjDat_59D62(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_59AB8:
                move.l  #byte_59DA6,$30(a0)
                lea     ChildObjDat_59D70(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_59AC8:
                move.l  #byte_59DAC,$30(a0)
                lea     ChildObjDat_59D7E(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_59AD8:
                bclr    #2,$38(a0)
                beq.s   loc_59AF6
                andi.b  #$FC,$38(a0)
                moveq   #0,d0
                bchg    #3,$38(a0)
                beq.s   loc_59AF2
                moveq   #1,d0

loc_59AF2:
                bset    d0,$38(a0)

loc_59AF6:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_59AFA:
                moveq   #0,d2
                movea.w parent3(a0),a1
                move.b  subtype(a1),d2
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_59B16(pc,d0.w),d1
                jsr     off_59B16(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
off_59B16:
                dc.w    loc_59B20-off_59B16
                dc.w    loc_59B44-off_59B16
                dc.w    loc_59BB0-off_59B16
                dc.w    loc_59C16-off_59B16
                dc.w    loc_59C42-off_59B16
; ---------------------------------------------------------------------------

loc_59B20:
                lea     word_59D56(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.b  #8,y_radius(a0)
                move.b  #-$10,child_dy(a0)
                move.w  x_pos(a0),$3E(a0)
                move.w  y_pos(a0),$40(a0)
                bra.w   loc_59D1A
; ---------------------------------------------------------------------------

loc_59B44:
                move.w  off_59B4C(pc,d2.w),d3
                jmp     off_59B4C(pc,d3.w)
; ---------------------------------------------------------------------------
off_59B4C:
                dc.w    loc_59B52-off_59B4C
                dc.w    loc_59B74-off_59B4C
                dc.w    loc_59BA6-off_59B4C
; ---------------------------------------------------------------------------

loc_59B52:
                moveq   #0,d0
                tst.b   subtype(a0)
                bne.s   loc_59B5C
                moveq   #1,d0

loc_59B5C:
                btst    d0,$38(a1)
                bne.s   loc_59B64
                rts
; ---------------------------------------------------------------------------

loc_59B64:
                move.b  #4,routine(a0)
                move.l  #loc_59BDE,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_59B74:
                moveq   #0,d0
                move.w  #$400,d1
                tst.b   subtype(a0)
                bne.s   loc_59B84
                moveq   #1,d0
                neg.w   d1

loc_59B84:
                btst    d0,$38(a1)
                bne.s   loc_59B8C
                rts
; ---------------------------------------------------------------------------

loc_59B8C:
                move.b  #4,routine(a0)
                move.w  d1,x_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_59BF2,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_59BA6:
                addq.b  #2,$3C(a0)
                moveq   #2,d2
                jmp     MoveSprite_CircularSimpleOffset(pc)
; ---------------------------------------------------------------------------

loc_59BB0:
                move.w  off_59BB8(pc,d2.w),d3
                jmp     off_59BB8(pc,d3.w)
; ---------------------------------------------------------------------------
off_59BB8:
                dc.w    loc_59BBE-off_59BB8
                dc.w    loc_59C0C-off_59BB8
                dc.w    loc_59BBE-off_59BB8
; ---------------------------------------------------------------------------

loc_59BBE:
                move.w  y_pos(a0),d0
                sub.w   $40(a0),d0
                cmpi.w  #$80,d0
                bhs.s   loc_59BF2
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   locret_59C0A
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_59BDE:
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                blo.s   loc_59BF2
                asr.w   #2,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_59BF2:
                move.b  #6,routine(a0)
                move.w  #$10,$2E(a0)
                move.l  #loc_59C28,$34(a0)
                clr.w   y_vel(a0)

locret_59C0A:
                rts
; ---------------------------------------------------------------------------

loc_59C0C:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_59C16:
                move.w  off_59C1E(pc,d2.w),d3
                jmp     off_59C1E(pc,d3.w)
; ---------------------------------------------------------------------------
off_59C1E:
                dc.w    loc_59C24-off_59C1E
                dc.w    loc_59C24-off_59C1E
                dc.w    loc_59C24-off_59C1E
; ---------------------------------------------------------------------------

loc_59C24:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_59C28:
                move.b  #8,routine(a0)
                neg.w   x_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_59C62,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_59C42:
                move.w  off_59C4A(pc,d2.w),d3
                jmp     off_59C4A(pc,d3.w)
; ---------------------------------------------------------------------------
off_59C4A:
                dc.w    loc_59C50-off_59C4A
                dc.w    loc_59C80-off_59C4A
                dc.w    loc_59C50-off_59C4A
; ---------------------------------------------------------------------------

loc_59C50:
                move.w  y_pos(a0),d0
                subq.w  #2,d0
                cmp.w   $40(a0),d0
                bls.s   loc_59C62
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_59C62:
                move.b  #2,routine(a0)
                move.w  $3E(a0),x_pos(a0)
                move.w  $40(a0),y_pos(a0)
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_59C80:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_59C8A:
                lea     word_59D5C(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_59CA8,(a0)
                move.w  x_pos(a0),$3E(a0)
                move.w  y_pos(a0),$40(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_59CA8:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                sub.w   $3E(a0),d2
                sub.w   $40(a0),d3
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  off_59CCE(pc,d0.w),d1
                jsr     off_59CCE(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_59CCE:
                dc.w    loc_59CD4-off_59CCE
                dc.w    loc_59CEE-off_59CCE
                dc.w    loc_59D04-off_59CCE
; ---------------------------------------------------------------------------

loc_59CD4:
                asr.w   #2,d2
                neg.w   d2
                add.w   x_pos(a1),d2
                move.w  d2,x_pos(a0)
                asr.w   #2,d3
                neg.w   d3
                add.w   y_pos(a1),d3
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_59CEE:
                asr.w   #1,d2
                add.w   $3E(a0),d2
                move.w  d2,x_pos(a0)
                asr.w   #1,d3
                add.w   $40(a0),d3
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_59D04:
                asr.w   #2,d2
                add.w   $3E(a0),d2
                move.w  d2,x_pos(a0)
                asr.w   #2,d3
                add.w   $40(a0),d3
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_59D1A:
                movea.w parent3(a0),a1
                move.b  subtype(a1),d0
                subq.b  #2,d0
                beq.s   loc_59D30
                bpl.s   loc_59D42
                lea     ChildObjDat_59D86(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

loc_59D30:
                lea     ChildObjDat_59D8E(pc),a2
                tst.b   subtype(a0)
                beq.s   loc_59D3E
                lea     ChildObjDat_59D96(pc),a2

loc_59D3E:
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

loc_59D42:
                lea     ChildObjDat_59D9E(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------
ObjDat_Ribot:
                dc.l    Map_Ribot
                dc.w    make_art_tile(ArtTile_Ribot,1,0)
                dc.w    $280
                dc.b    $10,  $C,   0,  $B
word_59D56:
                dc.w    $200
                dc.b    8,   8,   7, $97
word_59D5C:
                dc.w    $200
                dc.b    4,   4,   6,   0
ChildObjDat_59D62:
                dc.w    2-1
                dc.l    loc_59AFA
                dc.b    -$C,  $C
                dc.l    loc_59AFA
                dc.b    $C,  $C
ChildObjDat_59D70:
                dc.w    2-1
                dc.l    loc_59AFA
                dc.b    -$18,   0
                dc.l    loc_59AFA
                dc.b    $18,   0
ChildObjDat_59D7E:
                dc.w    1-1
                dc.l    loc_59AFA
                dc.b    0,-$10
ChildObjDat_59D86:
                dc.w    3-1
                dc.l    loc_59C8A
                dc.b    0, -$C
ChildObjDat_59D8E:
                dc.w    3-1
                dc.l    loc_59C8A
                dc.b    $C,   0
ChildObjDat_59D96:
                dc.w    3-1
                dc.l    loc_59C8A
                dc.b    -$C,   0
ChildObjDat_59D9E:
                dc.w    3-1
                dc.l    loc_59C8A
                dc.b    0,   0
byte_59DA6:
                dc.b    7,   0,   1,   2,   1, $FC
byte_59DAC:
                dc.b    7,   3,   4,   5,   4, $FC
                even
; ---------------------------------------------------------------------------

Obj_Orbinaut:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Orbinaut_Index(pc,d0.w),d1
                jsr     Orbinaut_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Orbinaut_Index:
                dc.w    loc_59DCE-Orbinaut_Index
                dc.w    loc_59DE0-Orbinaut_Index
; ---------------------------------------------------------------------------

loc_59DCE:
                lea     ObjDat_Orbinaut(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     ChildObjDat_59E80(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_59DE0:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                bclr    #0,render_flags(a0)
                move.w  #-$80,d1
                tst.w   d0
                beq.s   loc_59DFE
                bset    #0,render_flags(a0)
                neg.w   d1

loc_59DFE:
                move.w  d1,x_vel(a0)
                bsr.w   sub_59E50
                beq.w   locret_59E6C
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_59E10:
                lea     word_59E7A(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_59E2C,(a0)
                move.b  subtype(a0),d0
                lsl.b   #5,d0
                move.b  d0,$3C(a0)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_59E2C:
                movea.w parent3(a0),a1
                bsr.w   sub_59E50
                beq.s   loc_59E46
                moveq   #8,d0
                btst    #0,render_flags(a1)
                beq.s   loc_59E42
                moveq   #-8,d0

loc_59E42:
                add.b   d0,$3C(a0)

loc_59E46:
                moveq   #4,d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Child_DrawTouch_Sprite(pc)

; =============== S U B R O U T I N E =======================================

sub_59E50:
                lea     (Player_1).w,a2
                btst    #Status_InAir,status(a2)
                bne.s   loc_59E68
                tst.w   x_vel(a2)
                bne.s   locret_59E6C
                tst.w   y_vel(a2)
                bne.s   locret_59E6C

loc_59E68:
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

locret_59E6C:
                rts
; End of function sub_59E50

; ---------------------------------------------------------------------------
ObjDat_Orbinaut:
                dc.l    Map_Orbinaut
                dc.w    make_art_tile(ArtTile_Orbinaut,1,0)
                dc.w    $280
                dc.b    8,   8,   0,  $B
word_59E7A:
                dc.w    $280
                dc.b    8,   8,   1, $8B
ChildObjDat_59E80:
                dc.w    4-1
                dc.l    loc_59E10
                dc.b    0, $10
                dc.l    loc_59E10
                dc.b    $10,   0
                dc.l    loc_59E10
                dc.b    0,-$10
                dc.l    loc_59E10
                dc.b    -$10,   0

; unused
                dc.b    0,   5
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,   5
                dc.b    $FC
                even
; ---------------------------------------------------------------------------

Obj_Corkey:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Corkey_Index(pc,d0.w),d1
                jsr     Corkey_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Corkey_Index:
                dc.w    loc_59EC2-Corkey_Index
                dc.w    loc_59F18-Corkey_Index
                dc.w    loc_59F48-Corkey_Index
; ---------------------------------------------------------------------------

loc_59EC2:
                lea     ObjDat_Corkey(pc),a1
                jsr     (SetUp_ObjAttributes).l
                moveq   #-1,d0
                btst    #0,render_flags(a0)
                beq.s   loc_59ED8
                neg.w   d0

loc_59ED8:
                move.w  d0,$40(a0)
                move.b  subtype(a0),d0
                move.b  d0,$2F(a0)
                move.l  #loc_59F38,$34(a0)
                add.b   d0,d0
                move.b  d0,subtype(a0)
                lea     ChildObjDat_5A082(pc),a2
                jsr     (CreateChild1_Normal).l

loc_59EFC:
                jsr     (Random_Number).l
                andi.w  #$3F,d0
                move.w  d0,d1
                andi.w  #$30,d1
                bne.s   loc_59F12
                ori.w   #$30,d0

loc_59F12:
                move.w  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_59F18:
                subq.w  #1,$3A(a0)
                bmi.s   loc_59F2A
                move.w  $40(a0),d0
                add.w   d0,x_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_59F2A:
                move.b  #4,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_59F38:
                neg.w   $40(a0)
                clr.b   $2E(a0)
                move.b  subtype(a0),$2F(a0)
                rts
; ---------------------------------------------------------------------------

loc_59F48:
                btst    #1,$38(a0)
                beq.s   loc_59F52
                rts
; ---------------------------------------------------------------------------

loc_59F52:
                move.b  #2,routine(a0)
                bra.s   loc_59EFC
; ---------------------------------------------------------------------------

loc_59F5A:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_59F6C(pc,d0.w),d1
                jsr     off_59F6C(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_59F6C:
                dc.w    loc_59F74-off_59F6C
                dc.w    loc_59F7E-off_59F6C
                dc.w    loc_59FA6-off_59F6C
                dc.w    loc_5A020-off_59F6C
; ---------------------------------------------------------------------------

loc_59F74:
                lea     word_5A074(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

loc_59F7E:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   locret_59FA4
                move.b  #4,routine(a0)
                move.l  #loc_5A004,$34(a0)
                move.l  #byte_5A0A2,$30(a0)

locret_59FA4:
                rts
; ---------------------------------------------------------------------------

loc_59FA6:
                jsr     Animate_RawGetFaster(pc)
                tst.w   d2
                bpl.s   locret_59FC6
                cmpi.b  #4,$2F(a0)
                beq.s   loc_59FC8
                cmpi.b  #5,$2F(a0)
                beq.s   loc_59FDC
                cmpi.b  #6,$2F(a0)
                beq.s   loc_59FF0

locret_59FC6:
                rts
; ---------------------------------------------------------------------------

loc_59FC8:
                lea     ChildObjDat_5A08A(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #byte_5A0A7,$30(a1)
                rts
; ---------------------------------------------------------------------------

loc_59FDC:
                lea     ChildObjDat_5A092(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #byte_5A0B0,$30(a1)
                rts
; ---------------------------------------------------------------------------

loc_59FF0:
                lea     ChildObjDat_5A09A(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #byte_5A0B9,$30(a1)
                rts
; ---------------------------------------------------------------------------

loc_5A004:
                move.b  #6,routine(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_5A024,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A020:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5A024:
                move.b  #2,routine(a0)
                move.b  #1,mapping_frame(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_5A03C:
                lea     word_5A07A(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_5A05C,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #signextendB(sfx_Laser),d0
                jsr     (Play_SFX).l

loc_5A05C:
                addq.w  #1,$3A(a0)
                jsr     Animate_RawMultiDelay(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
ObjDat_Corkey:
                dc.l    Map_Corkey
                dc.w    make_art_tile(ArtTile_Corkey,1,0)
                dc.w    $280
                dc.b    $10,  $C,   0,  $B
word_5A074:
                dc.w    $280
                dc.b    8,   4,   1,   0
word_5A07A:
                dc.w    make_art_tile(ArtTile_Corkey,0,0)
                dc.w    $280
                dc.b    4, $50,   0, $A0
ChildObjDat_5A082:
                dc.w    1-1
                dc.l    loc_59F5A
                dc.b    0,  $C
ChildObjDat_5A08A:
                dc.w    1-1
                dc.l    loc_5A03C
                dc.b    -4, $54
ChildObjDat_5A092:
                dc.w    1-1
                dc.l    loc_5A03C
                dc.b    4, $54
ChildObjDat_5A09A:
                dc.w    1-1
                dc.l    loc_5A03C
                dc.b    0, $54
byte_5A0A2:
                dc.b    7, $10
                dc.b    1,   3
                dc.b    $FC
byte_5A0A7:
                dc.b    6,   0
                dc.b    6,   0
                dc.b    7,   4
                dc.b    5,   0
                dc.b    $F4
byte_5A0B0:
                dc.b    5,   0
                dc.b    5,   0
                dc.b    7,   4
                dc.b    6,   0
                dc.b    $F4
byte_5A0B9:
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    6,   3
                dc.b    $F4
                even
; ---------------------------------------------------------------------------

Obj_Flybot767:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Flybot767_Index(pc,d0.w),d1
                jsr     Flybot767_Index(pc,d1.w)
                lea     DPLCPtr_Flybot767(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
Flybot767_Index:
                dc.w    loc_5A108-Flybot767_Index
                dc.w    loc_5A126-Flybot767_Index
                dc.w    loc_5A188-Flybot767_Index
                dc.w    loc_5A1D0-Flybot767_Index
                dc.w    loc_5A204-Flybot767_Index
                dc.w    loc_5A248-Flybot767_Index
; ---------------------------------------------------------------------------

loc_5A108:
                lea     ObjSlot_Flybot767(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.l  #byte_5A294,$30(a0)
                move.b  #0,child_dx(a0)
                move.b  #-$40,child_dy(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A126:
                lea     (Player_1).w,a1
                move.w  #$200,d0
                moveq   #$10,d1
                jsr     Chase_ObjectXOnly(pc)
                move.w  #$100,d0
                moveq   #$10,d1
                jsr     Chase_ObjectYOnly(pc)
                jsr     (MoveSprite2).l
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                tst.w   d1
                beq.s   loc_5A156
                cmpi.w  #$60,d2
                blo.s   loc_5A15E

loc_5A156:
                jsr     Change_FlipXWithVelocity(pc)
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_5A15E:
                move.b  #4,routine(a0)
                clr.w   y_vel(a0)
                move.w  y_pos(a0),$44(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #byte_5A2A0,$30(a0)
                move.l  #loc_5A192,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A188:
                jsr     (MoveSprite2).l
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_5A192:
                move.b  #6,routine(a0)
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                move.w  #$200,d1
                bset    #0,render_flags(a0)
                tst.w   d0
                bne.s   loc_5A1B6
                neg.w   d1
                bclr    #0,render_flags(a0)

loc_5A1B6:
                move.w  d1,x_vel(a0)
                move.l  #byte_5A2A9,$30(a0)
                move.w  #$200,y_vel(a0)
                move.w  #$20,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A1D0:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   loc_5A1E4
                jsr     Find_SonicTails(pc)
                tst.w   d1
                beq.s   loc_5A1E8

loc_5A1E4:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_5A1E8:
                move.b  #8,routine(a0)
                move.l  #byte_5A2B5,$30(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                neg.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A204:
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $44(a0),d0
                blo.s   loc_5A21A
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_5A21A:
                move.b  #$A,routine(a0)
                move.l  #byte_5A294,$30(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_5A272,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A248:
                lea     (Player_1).w,a1
                move.w  #$200,d0
                moveq   #$10,d1
                jsr     Chase_ObjectXOnly(pc)
                move.w  #$100,d0
                moveq   #$10,d1
                jsr     Chase_ObjectYOnly(pc)
                jsr     (MoveSprite2).l
                jsr     Change_FlipXWithVelocity(pc)
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5A272:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------
ObjSlot_Flybot767:
                dc.w    3-1
                dc.w    make_art_tile(ArtTile_Flybot767,1,1)
                dc.w    $C,     0
                dc.l    Map_Flybot767
                dc.w    $280
                dc.b    $10, $10,   0, $1A
DPLCPtr_Flybot767:
                dc.l    ArtUnc_Flybot767
                dc.l    DPLC_Flybot767
byte_5A294:
                dc.b    4,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9, $FC
byte_5A2A0:
                dc.b    2,  $A,  $A,  $B,  $C,  $D,  $E,  $F, $F4
byte_5A2A9:
                dc.b    3, $10, $10, $11, $12, $13
                dc.b    $F8, .jump-byte_5A2A9

                .jump:
                dc.b    3, $13, $13, $FC
byte_5A2B5:
                dc.b    3,  $A,  $A, $14
                dc.b    $F8, .jump-byte_5A2B5

                .jump:
                dc.b    3, $14, $14, $FC
                even
; ---------------------------------------------------------------------------

Obj_LBZ1Robotnik:
                lea     word_5A2F0(pc),a1
                jsr     Check_CameraInRange(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZ1Robotnik_Index(pc,d0.w),d1
                jsr     LBZ1Robotnik_Index(pc,d1.w)
                jsr     (sub_5A7B4).l
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
LBZ1Robotnik_Index:
                dc.w    loc_5A2F8-LBZ1Robotnik_Index
                dc.w    loc_5A348-LBZ1Robotnik_Index
                dc.w    loc_5A380-LBZ1Robotnik_Index
                dc.w    loc_5A3AC-LBZ1Robotnik_Index
                dc.w    loc_5A3D6-LBZ1Robotnik_Index
                dc.w    loc_5A406-LBZ1Robotnik_Index
                dc.w    loc_5A436-LBZ1Robotnik_Index
                dc.w    loc_5A47E-LBZ1Robotnik_Index
word_5A2F0:
                dc.w    $500,  $5E0, $3820, $3AC0
; ---------------------------------------------------------------------------

loc_5A2F8:
                lea     ObjDat_LBZ1Robotnik(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #-1,collision_property(a0)
                st      (_unkFAAB).w
                jsr     (Swing_Setup1).l
                move.w  #$3820,(Camera_min_X_pos).w
                move.w  #$3AE8,(Camera_max_X_pos).w
                moveq   #PLCID_60,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_LBZMinibossBox).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMinibossBox),d2
                jsr     (Queue_Kos_Module).l
                lea     (Child1_MakeRoboHead3).l,a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_5A800(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

loc_5A348:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                tst.w   d1
                beq.s   loc_5A372
                cmpi.w  #$70,d2
                bhs.s   loc_5A368
                cmpi.w  #$60,d3
                bhs.s   loc_5A368
                btst    #Status_InAir,status(a1)
                beq.s   loc_5A372

loc_5A368:
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_5A372:
                move.b  #4,routine(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A380:
                cmpi.w  #$300,y_pos(a0)
                blo.s   loc_5A38E
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_5A38E:
                move.b  #6,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #$3EC0,x_pos(a0)
                move.w  #$1A0,y_pos(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

loc_5A3AC:
                lea     (Player_1).w,a1
                cmpi.w  #$3B40,(Camera_X_pos).w
                blo.s   locret_5A3C8
                cmpi.w  #$1C0,y_pos(a1)
                blo.s   locret_5A3C8
                btst    #Status_InAir,status(a1)
                beq.s   loc_5A3CA

locret_5A3C8:
                rts
; ---------------------------------------------------------------------------

loc_5A3CA:
                move.b  #8,routine(a0)
                st      (Events_fg_4).w
                rts
; ---------------------------------------------------------------------------

loc_5A3D6:
                tst.w   (Events_fg_4).w
                beq.s   loc_5A3DE
                rts
; ---------------------------------------------------------------------------

loc_5A3DE:
                move.b  #$A,routine(a0)
                lea     (ArtKosM_LBZMinibossBox).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMinibossBox),d2
                jsr     (Queue_Kos_Module).l
                move.w  #$3EA0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_5A406:
                move.w  (Camera_X_pos).w,d0
                cmpi.w  #$3E50,d0
                bhs.s   loc_5A414
                move.w  d0,(Camera_min_X_pos).w

loc_5A414:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                blo.s   loc_5A428
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_5A428:
                move.b  #$C,routine(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A436:
                cmpi.w  #$12C,y_pos(a0)
                bls.s   loc_5A444
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_5A444:
                move.b  #$E,routine(a0)
                move.w  #$12C,y_pos(a0)
                bset    #1,$38(a0)
                move.w  #$200,x_vel(a0)
                move.w  #$200,y_vel(a0)
                lea     (ArtKosM_LBZMiniboss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     (Child1_MakeRoboShipFlame).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_5A47E:
                jsr     (MoveSprite2).l
                cmpi.w  #$1B8,y_pos(a0)
                bhs.s   loc_5A48E
                rts
; ---------------------------------------------------------------------------

loc_5A48E:
                move.l  #loc_5A49A,(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A49A:
                jsr     (MoveSprite2).l
                jsr     (sub_5A7B4).l
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_5A4AA:
                move.l  #loc_5A4BA,(a0)
                lea     ChildObjDat_5A808(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_5A4BA:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_5A4E0
                move.l  #Obj_Wait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_5A4E4,$34(a0)
                move.w  #$160,y_pos(a0)

loc_5A4E0:
                jmp     Refresh_ChildPosition(pc)
; ---------------------------------------------------------------------------

loc_5A4E4:
                jsr     (AllocateObject).l
                bne.s   loc_5A4F8
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

loc_5A4F8:
                bset    #3,$38(a0)
                moveq   #signextendB(sfx_BossActivate),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_5A810(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Go_Delete_Sprite_2(pc)
; ---------------------------------------------------------------------------

Obj_LBZMinibossBox:
                tst.b   (_unkFAAB).w
                bne.s   loc_5A572
                move.l  #loc_5A57A,(a0)
                move.w  #$3EA0,(Camera_max_X_pos).w
                move.w  #$3C00,(Camera_min_X_pos).w
                lea     (ArtKosM_LBZMiniboss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_LBZMinibossBox).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZMinibossBox),d2
                jsr     (Queue_Kos_Module).l
                lea     PLC_BossExplosion(pc),a1
                jsr     (Load_PLC_Raw).l
                jsr     (AllocateObject).l
                bne.s   loc_5A568
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

loc_5A568:
                lea     ChildObjDat_5A808(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_5A572:
                move.l  #Delete_Sprite_If_Not_In_Range,(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A57A:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                cmpi.w  #$70,d2
                bhs.s   loc_5A5A4
                move.l  #Obj_Wait,(a0)
                move.w  #$3DA0,(Camera_min_X_pos).w
                move.w  #$1F,$2E(a0)
                move.l  #loc_5A4F8,$34(a0)

loc_5A5A4:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_5A5B8
                rts
; ---------------------------------------------------------------------------

loc_5A5B8:
                jmp     loc_5371C(pc)
; ---------------------------------------------------------------------------

loc_5A5BC:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5A5E0(pc,d0.w),d1
                jsr     off_5A5E0(pc,d1.w)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_5A5DC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5A5DC:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------
off_5A5E0:
                dc.w    loc_5A5EC-off_5A5E0
                dc.w    loc_5A5FA-off_5A5E0
                dc.w    loc_5A618-off_5A5E0
                dc.w    loc_5A626-off_5A5E0
                dc.w    loc_5A672-off_5A5E0
                dc.w    loc_5A688-off_5A5E0
; ---------------------------------------------------------------------------

loc_5A5EC:
                lea     ObjDat3_5A7F4(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bra.w   loc_5A6E4
; ---------------------------------------------------------------------------

loc_5A5FA:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_5A60A
                jmp     Refresh_ChildPosition(pc)
; ---------------------------------------------------------------------------

loc_5A60A:
                move.b  #4,routine(a0)
                move.w  #$55,(Events_fg_4).w
                rts
; ---------------------------------------------------------------------------

loc_5A618:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5A624
                move.b  #6,routine(a0)

locret_5A624:
                rts
; ---------------------------------------------------------------------------

loc_5A626:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_5A62C:
                move.b  #8,routine(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                subi.w  #$C,d0
                move.w  word_5A66A(pc,d0.w),y_vel(a0)
                add.w   d0,d0
                move.l  off_5A65A(pc,d0.w),$30(a0)
                move.l  #loc_5A68E,$34(a0)
                move.w  #$5F,$2E(a0)
                rts
; ---------------------------------------------------------------------------
off_5A65A:
                dc.l    byte_5A822
                dc.l    byte_5A822
                dc.l    byte_5A827
                dc.l    byte_5A827
word_5A66A:
                dc.w    -$40,   $40,  -$40,   $40
; ---------------------------------------------------------------------------

loc_5A672:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_5A680
                rts
; ---------------------------------------------------------------------------

loc_5A680:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A688:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_5A68E:
                move.l  #loc_5A69C,(a0)
                move.w  #$380,priority(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A69C:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_5A6B4
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5A6B4:
                cmpi.b  #$C,subtype(a0)
                bne.s   loc_5A6D0
                lea     PLC_MonitorsSpikesSprings(pc),a1
                jsr     (Load_PLC_Raw).l
                lea     PLC_LBZRobotnikAfter(pc),a1
                jsr     (Load_PLC_Raw).l

loc_5A6D0:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
PLC_LBZRobotnikAfter:   plrlistheader
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
PLC_LBZRobotnikAfter_End:
; unused
                plreq   ArtTile_LBZMisc, ArtNem_LBZMisc
; ---------------------------------------------------------------------------

loc_5A6E4:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_5A728(pc,d0.w),$2E(a0)
                add.w   d0,d0
                move.l  off_5A73C(pc,d0.w),$30(a0)
                move.l  off_5A764(pc,d0.w),$34(a0)
                lea     byte_5A78C(pc),a1
                adda.w  d0,a1
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,d1
                or.b    d1,render_flags(a0)
                move.b  (a1)+,d1
                move.b  d1,child_dx(a0)
                ext.w   d1
                add.w   d1,x_pos(a0)
                move.b  (a1)+,d1
                move.b  d1,child_dy(a0)
                ext.w   d1
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
word_5A728:
                dc.w    0
                dc.w    0
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $40
                dc.w    $50
                dc.w    $70
                dc.w    $60
off_5A73C:
                dc.l    byte_5A818
                dc.l    byte_5A818
                dc.l    byte_5A81D
                dc.l    byte_5A81D
                dc.l    byte_5A81D
                dc.l    byte_5A81D
                dc.l    byte_5A82C
                dc.l    byte_5A82C
                dc.l    byte_5A830
                dc.l    byte_5A830
off_5A764:
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    Go_Delete_Sprite
                dc.l    loc_5A62C
                dc.l    loc_5A62C
                dc.l    loc_5A62C
                dc.l    loc_5A62C
byte_5A78C:
                dc.b    6,   0,-$10,   0
                dc.b    6,   2, $10,   0
                dc.b    9,   0,   0, $14
                dc.b    9,   1,   0,  $C
                dc.b    9,   0,   0, -$C
                dc.b    9,   1,   0,-$14
                dc.b    0,   0, -$C,-$10
                dc.b    0,   3,  $C, $10
                dc.b    3,   0, $14, -$C
                dc.b    3,   3,-$14,  $C
                even

; =============== S U B R O U T I N E =======================================

sub_5A7B4:
                tst.b   collision_flags(a0)
                bne.s   locret_5A7E6
                tst.b   $20(a0)
                bne.s   loc_5A7D4
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

loc_5A7D4:
                subq.b  #1,$20(a0)
                bne.s   locret_5A7E6
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_5A7E6:
                rts
; End of function sub_5A7B4

; ---------------------------------------------------------------------------
ObjDat_LBZ1Robotnik:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $100
                dc.b    $20, $20,  $A,  $F
ObjDat3_5A7F4:
                dc.l    Map_LBZMinibossBox
                dc.w    make_art_tile(ArtTile_LBZMinibossBox,2,0)
                dc.w    $100
                dc.b    $14, $14,   0,   0
ChildObjDat_5A800:
                dc.w    1-1
                dc.l    loc_5A4AA
                dc.b    0, $34
ChildObjDat_5A808:
                dc.w    $A-1
                dc.l    loc_5A5BC
                dc.b    0,   0
ChildObjDat_5A810:
                dc.w    1-1
                dc.l    Obj_LBZMiniboss
                dc.b    0,   0
byte_5A818:
                dc.b    0,   6,   7,   8, $F4
byte_5A81D:
                dc.b    0,   9,  $A,  $B, $F4
byte_5A822:
                dc.b    5,   0,   1,   2, $F4
byte_5A827:
                dc.b    5,   3,   4,   5, $F4
byte_5A82C:
                dc.b    0,   0,   0, $F4
byte_5A830:
                dc.b    0,   3,   3, $F4
                even
; ---------------------------------------------------------------------------

Obj_LBZ2RobotnikShip:
                move.w  a0,(Events_bg+$00).w
                lea     ObjDat_LBZ2RobotnikShip(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_5A84E,(a0)
                bset    #0,render_flags(a0)

loc_5A84E:
                moveq   #0,d0
                move.b  collision_property(a0),d0
                beq.w   loc_5A8E2
                clr.b   collision_property(a0)
                cmpi.b  #2,d0
                beq.w   loc_5A8E2
                lea     (Player_1).w,a1
                tst.b   object_control(a1)
                bne.w   loc_5A8E2
                move.l  #loc_5A912,(a0)
                move.b  #$83,object_control(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                move.b  #5,anim(a1)
                bset    #7,art_tile(a1)
                move.w  #-$100,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_5A8E6,$34(a0)
                moveq   #signextendB(sfx_Rising),d0
                jsr     (Play_SFX).l
                st      (Anim_Counters+$F).w
                move.w  #$6000,(Camera_stored_max_X_pos).w
                lea     Child6_IncLevX(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     CreateChild1_Normal(pc)
                st      (Ctrl_2_locked).w
                jsr     (AllocateObject).l
                bne.s   loc_5A8DE
                move.l  #loc_5AAAE,(a1)

loc_5A8DE:
                jsr     sub_5AACA(pc)

loc_5A8E2:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5A8E6:
                move.l  #loc_5A90C,(a0)
                move.w  y_pos(a0),$3A(a0)
                move.w  #$100,x_vel(a0)
                move.w  #$1DF,$2E(a0)
                move.l  #loc_5A92A,$34(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

loc_5A90C:
                jsr     (Swing_UpAndDown).l

loc_5A912:
                jsr     (MoveSprite2).l
                bsr.w   sub_5AA92
                jsr     (Obj_Wait).l
                jsr     sub_5AACA(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5A92A:
                move.w  #$3F,$2E(a0)
                clr.w   x_vel(a0)
                move.l  #loc_5A93E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A93E:
                move.l  #loc_5A94C,(a0)
                move.w  #$100,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A94C:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                bsr.w   sub_5AA92
                movea.w (_unkFAA4).w,a1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$50,d0
                bhs.s   loc_5A988
                bset    #1,$38(a1)
                move.l  #loc_5A90C,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_5A990,$34(a0)

loc_5A988:
                jsr     sub_5AACA(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5A990:
                move.l  #loc_5A9AC,(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$200,y_vel(a0)
                moveq   #signextendB(sfx_Thump),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_5A9AC:
                jsr     (MoveSprite_LightGravity).l
                bsr.w   sub_5AA92
                tst.w   y_vel(a0)
                bmi.s   loc_5A9E4
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                blo.s   loc_5A9E4
                move.l  #loc_5A90C,(a0)
                clr.w   x_vel(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_5A9EC,$34(a0)
                jsr     (Swing_Setup1).l

loc_5A9E4:
                jsr     sub_5AACA(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5A9EC:
                move.l  #loc_5A90C,(a0)
                st      (Screen_shake_flag).w
                st      (Events_fg_5).w
                move.w  #$FF,$2E(a0)
                move.l  #loc_5AA0A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5AA0A:
                move.l  #loc_5AA18,(a0)
                move.w  #$100,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_5AA18:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                bsr.w   sub_5AA92
                cmpi.w  #$4440,x_pos(a0)
                blo.s   loc_5AA78
                move.l  #loc_5AA82,(a0)
                clr.w   (Screen_shake_flag).w
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                move.w  #-$100,x_vel(a1)
                move.w  #-$600,y_vel(a1)
                move.b  #2,anim(a1)
                clr.b   jumping(a1)
                jsr     (AllocateObject).l
                bne.s   loc_5AA78
                move.l  #Obj_LBZFinalBoss1,(a1)
                move.w  #$44A0,x_pos(a1)
                move.w  #$780,y_pos(a1)

loc_5AA78:
                jsr     sub_5AACA(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5AA82:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     Sprite_CheckDeleteTouch2(pc)

; =============== S U B R O U T I N E =======================================

sub_5AA92:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),d0
                subq.w  #4,d0
                move.w  d0,x_pos(a1)
                move.w  y_pos(a0),d0
                subi.w  #$12,d0
                move.w  d0,y_pos(a1)
                rts
; End of function sub_5AA92

; ---------------------------------------------------------------------------

loc_5AAAE:
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   loc_5AAC4
                tst.b   render_flags(a1)
                bpl.s   loc_5AABE
                rts
; ---------------------------------------------------------------------------

loc_5AABE:
                clr.l   (a1)
                clr.l   (Tails_tails).w

loc_5AAC4:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_5AACA:
                lea     (Player_1).w,a1
                moveq   #0,d0
                move.b  character_id(a1),d0
                move.b  RawAni_5AAE8(pc,d0.w),mapping_frame(a1)
                add.w   d0,d0
                movea.w word_5AAEA(pc,d0.w),a2
                clr.b   (a2)
                jmp     (Player_Load_PLC).l
; End of function sub_5AACA

; ---------------------------------------------------------------------------
RawAni_5AAE8:
                dc.b    $BA, $AD
                even
word_5AAEA:
                dc.w    Player_prev_frame, Player_prev_frame_P2
ObjDat_LBZ2RobotnikShip:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,1)
                dc.w    $80
                dc.b    $20, $20,  $A, $CA

; unused
                dc.w    1-1
                dc.l    Obj_LBZ2RobotnikShip
                dc.b    0,   0

; unused
                dc.b    0,   5
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,   5
                dc.b    $FC
                even
; ---------------------------------------------------------------------------
; 1st PLC        palette           2nd 8x8 data       2nd 16x16 data         2nd 128x128 data
; 2nd PLC   1st 8x8 data     1st 16x16 data         1st 128x128 data
LevelLoadBlock:
                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Primary_Kos,   AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; ANGEL ISLAND ZONE ACT 1
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ2_8x8_Primary_KosM, AIZ2_8x8_Secondary_KosM, AIZ2_16x16_Primary_Kos,   AIZ2_16x16_Secondary_Kos, AIZ2_128x128_Kos,        AIZ2_128x128_Kos  ; ANGEL ISLAND ZONE ACT 2
                levartptrs PLCID_0E, PLCID_0F, PalID_HCZ1, HCZ_8x8_Primary_KosM,  HCZ1_8x8_Secondary_KosM, HCZ_16x16_Primary_Kos,    HCZ1_16x16_Secondary_Kos, HCZ_128x128_Primary_Kos, HCZ1_128x128_Secondary_Kos  ; HYDROCITY ZONE ACT 1
                levartptrs PLCID_10, PLCID_11, PalID_HCZ2, HCZ_8x8_Primary_KosM,  HCZ2_8x8_Secondary_KosM, HCZ_16x16_Primary_Kos,    HCZ2_16x16_Secondary_Kos, HCZ_128x128_Primary_Kos, HCZ2_128x128_Secondary_Kos  ; HYDROCITY ZONE ACT 2
                levartptrs PLCID_12, PLCID_12, PalID_MGZ1, MGZ_8x8_Primary_KosM,  MGZ1_8x8_Secondary_KosM, MGZ_16x16_Primary_Kos,    MGZ1_16x16_Secondary_Kos, MGZ_128x128_Primary_Kos, MGZ1_128x128_Secondary_Kos  ; MARBLE GARDEN ZONE ACT 1
                levartptrs PLCID_14, PLCID_14, PalID_MGZ2, MGZ_8x8_Primary_KosM,  MGZ2_8x8_Secondary_KosM, MGZ_16x16_Primary_Kos,    MGZ2_16x16_Secondary_Kos, MGZ_128x128_Primary_Kos, MGZ2_128x128_Secondary_Kos  ; MARBLE GARDEN ZONE ACT 2
                levartptrs PLCID_16, PLCID_17, PalID_CNZ1, CNZ_8x8_KosM,          CNZ_8x8_KosM,            CNZ_16x16_Kos,            CNZ_16x16_Kos,            CNZ_128x128_Kos,         CNZ_128x128_Kos  ; CARNIVAL NIGHT ZONE ACT 1
                levartptrs PLCID_18, PLCID_19, PalID_CNZ2, CNZ_8x8_KosM,          CNZ_8x8_KosM,            CNZ_16x16_Kos,            CNZ_16x16_Kos,            CNZ_128x128_Kos,         CNZ_128x128_Kos  ; CARNIVAL NIGHT ZONE ACT 2
                levartptrs PLCID_1A, PLCID_1A, PalID_FBZ1, FBZ1_8x8_KosM,         FBZ1_8x8_KosM,           FBZ1_16x16_Kos,           FBZ1_16x16_Kos,           FBZ1_128x128_Kos,        FBZ1_128x128_Kos  ; FLYING BATTERY ZONE ACT 1 (unused)
                levartptrs PLCID_1C, PLCID_1C, PalID_FBZ2, FBZ2_8x8_KosM,         FBZ2_8x8_KosM,           FBZ2_16x16_Kos,           FBZ2_16x16_Kos,           FBZ2_128x128_Kos,        FBZ2_128x128_Kos  ; FLYING BATTERY ZONE ACT 2 (unused)
                levartptrs PLCID_1E, PLCID_1E, PalID_ICZ1, ICZ_8x8_Primary_KosM,  ICZ1_8x8_Secondary_KosM, ICZ_16x16_Primary_Kos,    ICZ1_16x16_Secondary_Kos, ICZ_128x128_Primary_Kos, ICZ1_128x128_Secondary_Kos  ; ICECAP ZONE ACT 1
                levartptrs PLCID_20, PLCID_20, PalID_ICZ2, ICZ_8x8_Primary_KosM,  ICZ2_8x8_Secondary_KosM, ICZ_16x16_Primary_Kos,    ICZ2_16x16_Secondary_Kos, ICZ_128x128_Primary_Kos, ICZ2_128x128_Secondary_Kos  ; ICECAP ZONE ACT 2
                levartptrs PLCID_22, PLCID_22, PalID_LBZ1, LBZ_8x8_Primary_KosM,  LBZ1_8x8_Secondary_KosM, LBZ_16x16_Primary_Kos,    LBZ1_16x16_Secondary_Kos, LBZ1_128x128_Kos,        LBZ1_128x128_Kos  ; LAUNCH BASE ZONE ACT 1
                levartptrs PLCID_24, PLCID_25, PalID_LBZ2, LBZ_8x8_Primary_KosM,  LBZ2_8x8_Secondary_KosM, LBZ_16x16_Primary_Kos,    LBZ2_16x16_Secondary_Kos, LBZ2_128x128_Kos,        LBZ2_128x128_Kos  ; LAUNCH BASE ZONE ACT 2
                levartptrs PLCID_26, PLCID_26, PalID_MHZ1, ArtKosM_MHZ,           ArtKosM_MHZ,             MHZ_16x16_Kos,            MHZ_16x16_Kos,            MHZ_128x128_Kos,         MHZ_128x128_Kos  ; MUSHROOM HILL ZONE ACT 1 (unused)
                levartptrs PLCID_28, PLCID_28, PalID_MHZ2, ArtKosM_MHZ,           ArtKosM_MHZ,             MHZ_16x16_Kos,            MHZ_16x16_Kos,            MHZ_128x128_Kos,         MHZ_128x128_Kos  ; MUSHROOM HILL ZONE ACT 2 (unused)
                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SANDOPOLIS ZONE ACT 1 (unused)
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SANDOPOLIS ZONE ACT 2 (unused)
                levartptrs PLCID_2E, PLCID_2E, PalID_LRZ1, ArtKosM_LRZ,           ArtKosM_LRZ,             LRZ_16x16_Kos,            LRZ_16x16_Kos,            LRZ_128x128_Kos,         LRZ_128x128_Kos  ; LAVA REEF ZONE ACT 1 (unused)
                levartptrs PLCID_30, PLCID_30, PalID_LRZ2, ArtKosM_LRZ,           ArtKosM_LRZ,             LRZ_16x16_Kos,            LRZ_16x16_Kos,            LRZ_128x128_Kos,         LRZ_128x128_Kos  ; LAVA REEF ZONE ACT 2 (unused)
                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SKY SANCTUARY ZONE (SONIC/TAILS) (unused)
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SKY SANCTUARY ZONE (KNUCKLES) (unused)
                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; DEATH EGG ZONE ACT 1 (unused)
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; DEATH EGG ZONE ACT 2 (unused)
                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; DOOMSDAY ZONE (unused)
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; DOOMSDAY ZONE (unused)

                levartptrs PLCID_0B, PLCID_0B, PalID_AIZ, AIZ1_8x8_Primary_KosM, AIZ1_8x8_MainLevel_KosM, AIZ1_16x16_Primary_Kos,   AIZ1_16x16_MainLevel_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SONIC/TAILS INTRO (unused)
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SONIC/TAILS ENDING (unused)

                levartptrs PLCID_42, PLCID_42, PalID_ALZ, ALZ_8x8_KosM,          ALZ_8x8_KosM,            ALZ_16x16_Kos,            ALZ_16x16_Kos,            ALZ_128x128_Kos,         ALZ_128x128_Kos  ; AZURE LAKE ZONE
                levartptrs PLCID_42, PLCID_42, PalID_ALZ_2, ALZ_8x8_KosM,          ALZ_8x8_KosM,            ALZ_16x16_Kos,            ALZ_16x16_Kos,            ALZ_128x128_Kos,         ALZ_128x128_Kos  ; AZURE LAKE ZONE (unused)
                levartptrs PLCID_43, PLCID_43, PalID_BPZ, BPZ_8x8_KosM,          BPZ_8x8_KosM,            BPZ_16x16_Kos,            BPZ_16x16_Kos,            BPZ_128x128_Kos,         BPZ_128x128_Kos  ; BALLOON PARK ZONE
                levartptrs PLCID_43, PLCID_43, PalID_BPZ_2, BPZ_8x8_KosM,          BPZ_8x8_KosM,            BPZ_16x16_Kos,            BPZ_16x16_Kos,            BPZ_128x128_Kos,         BPZ_128x128_Kos  ; BALLOON PARK ZONE (unused)
                levartptrs PLCID_44, PLCID_44, PalID_DPZ, DPZ_8x8_KosM,          DPZ_8x8_KosM,            DPZ_16x16_Kos,            DPZ_16x16_Kos,            DPZ_128x128_Kos,         DPZ_128x128_Kos  ; DESERT PALACE ZONE
                levartptrs PLCID_44, PLCID_44, PalID_DPZ, DPZ_8x8_KosM,          DPZ_8x8_KosM,            DPZ_16x16_Kos,            DPZ_16x16_Kos,            DPZ_128x128_Kos,         DPZ_128x128_Kos  ; DESERT PALACE ZONE (unused)
                levartptrs PLCID_45, PLCID_45, PalID_CGZ, CGZ_8x8_KosM,          CGZ_8x8_KosM,            CGZ_16x16_Kos,            CGZ_16x16_Kos,            CGZ_128x128_Kos,         CGZ_128x128_Kos  ; CHROME GADGET ZONE
                levartptrs PLCID_45, PLCID_45, PalID_CGZ, CGZ_8x8_KosM,          CGZ_8x8_KosM,            CGZ_16x16_Kos,            CGZ_16x16_Kos,            CGZ_128x128_Kos,         CGZ_128x128_Kos  ; CHROME GADGET ZONE (unused)
                levartptrs PLCID_46, PLCID_46, PalID_EMZ, EMZ_8x8_KosM,          EMZ_8x8_KosM,            EMZ_16x16_Kos,            EMZ_16x16_Kos,            EMZ_128x128_Kos,         EMZ_128x128_Kos  ; ENDLESS MINE ZONE
                levartptrs PLCID_46, PLCID_46, PalID_EMZ, EMZ_8x8_KosM,          EMZ_8x8_KosM,            EMZ_16x16_Kos,            EMZ_16x16_Kos,            EMZ_128x128_Kos,         EMZ_128x128_Kos  ; ENDLESS MINE ZONE (unused)

                levartptrs PLCID_47, PLCID_47, PalID_Gumball_Special, Gumball_8x8_KosM,      Gumball_8x8_KosM,        Gumball_16x16_Kos,        Gumball_16x16_Kos,        Gumball_128x128_Kos,     Gumball_128x128_Kos  ; GUMBALL
                levartptrs PLCID_47, PLCID_47, PalID_Gumball_Special, Gumball_8x8_KosM,      Gumball_8x8_KosM,        Gumball_16x16_Kos,        Gumball_16x16_Kos,        Gumball_128x128_Kos,     Gumball_128x128_Kos  ; GUMBALL (unused)
                levartptrs PLCID_47, PLCID_47, PalID_Pachinko_Special, ArtKosM_Pachinko,      ArtKosM_Pachinko,        Pachinko_16x16_Kos,       Pachinko_16x16_Kos,       Pachinko_128x128_Kos,    Pachinko_128x128_Kos  ; PACHINKO (unused)
                levartptrs PLCID_47, PLCID_47, PalID_Pachinko_Special, ArtKosM_Pachinko,      ArtKosM_Pachinko,        Pachinko_16x16_Kos,       Pachinko_16x16_Kos,       Pachinko_128x128_Kos,    Pachinko_128x128_Kos  ; PACHINKO (unused)
                levartptrs PLCID_47, PLCID_47, PalID_Slot_Special, ArtKosM_Slots,         ArtKosM_Slots,           Slots_16x16_Kos,          Slots_16x16_Kos,          Slots_128x128_Kos,       Slots_128x128_Kos  ; SLOTS (unused)
                levartptrs PLCID_47, PLCID_47, PalID_Slot_Special, ArtKosM_Slots,         ArtKosM_Slots,           Slots_16x16_Kos,          Slots_16x16_Kos,          Slots_128x128_Kos,       Slots_128x128_Kos  ; SLOTS (unused)

                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; LAVA REEF ZONE BOSS (unused)
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; HIDDEN PALACE ZONE (unused)
                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SONIC/TAILS FINAL BOSS (unused)
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SPECIAL STAGE HUB (unused)

; ---------------------------------------------------------------------------

; Assembly macro to define PLC pointer entry
plcptr:         macro   plc,{INTLABEL}
__LABEL__:      label   (*-Offs_PLC)/2
                    dc.w    plc-Offs_PLC
                endm

Offs_PLC:
PLCID_00:       plcptr  PLC_00                          ; Sonic life icon/universal level graphics
PLCID_01:       plcptr  PLC_01                          ; Sonic life icon/universal level graphics
PLCID_02:       plcptr  PLC_02                          ; Explosions + Squirrel/Flicky (unused)
PLCID_03:       plcptr  PLC_03                          ; Game Over text
PLCID_04:       plcptr  PLC_04                          ; Signpost art (unused)
PLCID_05:       plcptr  PLC_05                          ; Spikes and springs (unused)
PLCID_06:       plcptr  PLC_06                          ; 2P mode-specific art
PLCID_07:       plcptr  PLC_07                          ; Tails life icon/universal level graphics
PLCID_08:       plcptr  PLC_08                          ; Monitor art only
PLCID_09:       plcptr  PLC_09                          ; Revolving spheres
PLCID_0A:       plcptr  PLC_0A                          ; AIZ intro graphics
PLCID_0B:       plcptr  PLC_0B                          ; AIZ1
PLCID_0C:       plcptr  PLC_0C_0D                       ; AIZ2
PLCID_0D:       plcptr  PLC_0C_0D                       ; AIZ2 (unused)
PLCID_0E:       plcptr  PLC_0E                          ; HCZ1 part 1
PLCID_0F:       plcptr  PLC_0F                          ; HCZ1 part 2
PLCID_10:       plcptr  PLC_10                          ; HCZ2 part 1
PLCID_11:       plcptr  PLC_11                          ; HCZ2 part 2
PLCID_12:       plcptr  PLC_12_13                       ; MGZ1
PLCID_13:       plcptr  PLC_12_13                       ; MGZ1 (unused)
PLCID_14:       plcptr  PLC_14_15                       ; MGZ2
PLCID_15:       plcptr  PLC_14_15                       ; MGZ2 (unused)
PLCID_16:       plcptr  PLC_16_17_18_19                 ; CNZ (used for act 1)
PLCID_17:       plcptr  PLC_16_17_18_19                 ; CNZ (used for act 1)
PLCID_18:       plcptr  PLC_16_17_18_19                 ; CNZ (used for act 2)
PLCID_19:       plcptr  PLC_16_17_18_19                 ; CNZ (used for act 2)
PLCID_1A:       plcptr  PLC_1A_1B_1C_1D                 ; FBZ (used for act 1)
PLCID_1B:       plcptr  PLC_1A_1B_1C_1D                 ; FBZ (act 1, unused)
PLCID_1C:       plcptr  PLC_1A_1B_1C_1D                 ; FBZ (used for act 2)
PLCID_1D:       plcptr  PLC_1A_1B_1C_1D                 ; FBZ (act 2, unused)
PLCID_1E:       plcptr  PLC_1E_1F                       ; ICZ1
PLCID_1F:       plcptr  PLC_1E_1F                       ; ICZ1 (unused)
PLCID_20:       plcptr  PLC_20_21                       ; ICZ2
PLCID_21:       plcptr  PLC_20_21                       ; ICZ2 (unused)
PLCID_22:       plcptr  PLC_22_23                       ; LBZ1
PLCID_23:       plcptr  PLC_22_23                       ; LBZ1 (unused)
PLCID_24:       plcptr  PLC_24                          ; LBZ2
PLCID_25:       plcptr  PLC_25                          ; LBZ2 misc art
PLCID_26:       plcptr  PLC_26_Through_2D               ; MHZ (used for act 1)
PLCID_27:       plcptr  PLC_26_Through_2D               ; MHZ (act 1, unused)
PLCID_28:       plcptr  PLC_26_Through_2D               ; MHZ (used for act 2)
PLCID_29:       plcptr  PLC_26_Through_2D               ; MHZ (act 2, unused)
PLCID_2A:       plcptr  PLC_26_Through_2D               ; MHZ (SOZ1, unused)
PLCID_2B:       plcptr  PLC_26_Through_2D               ; MHZ (SOZ1, unused)
PLCID_2C:       plcptr  PLC_26_Through_2D               ; MHZ (SOZ2, unused)
PLCID_2D:       plcptr  PLC_26_Through_2D               ; MHZ (SOZ2, unused)
PLCID_2E:       plcptr  PLC_2E_Through_41               ; LRZ (used for act 1)
PLCID_2F:       plcptr  PLC_2E_Through_41               ; LRZ (act 1, unused)
PLCID_30:       plcptr  PLC_2E_Through_41               ; LRZ (used for act 2)
PLCID_31:       plcptr  PLC_2E_Through_41               ; LRZ (act 2, unused)
PLCID_32:       plcptr  PLC_2E_Through_41               ; LRZ (SSZ1, unused)
PLCID_33:       plcptr  PLC_2E_Through_41               ; LRZ (SSZ1, unused)
PLCID_34:       plcptr  PLC_2E_Through_41               ; LRZ (SSZ2, unused)
PLCID_35:       plcptr  PLC_2E_Through_41               ; LRZ (SSZ2, unused)
PLCID_36:       plcptr  PLC_2E_Through_41               ; LRZ (DEZ1, unused)
PLCID_37:       plcptr  PLC_2E_Through_41               ; LRZ (DEZ1, unused)
PLCID_38:       plcptr  PLC_2E_Through_41               ; LRZ (DEZ2, unused)
PLCID_39:       plcptr  PLC_2E_Through_41               ; LRZ (DEZ2, unused)
PLCID_3A:       plcptr  PLC_2E_Through_41               ; LRZ (DDZ1, unused)
PLCID_3B:       plcptr  PLC_2E_Through_41               ; LRZ (DDZ1, unused)
PLCID_3C:       plcptr  PLC_2E_Through_41               ; LRZ (DDZ2, unused)
PLCID_3D:       plcptr  PLC_2E_Through_41               ; LRZ (DDZ2, unused)
PLCID_3E:       plcptr  PLC_2E_Through_41               ; LRZ (ending 1, unused)
PLCID_3F:       plcptr  PLC_2E_Through_41               ; LRZ (ending 1, unused)
PLCID_40:       plcptr  PLC_2E_Through_41               ; LRZ (ending 2, unused)
PLCID_41:       plcptr  PLC_2E_Through_41               ; LRZ (ending 2, unused)
PLCID_42:       plcptr  PLC_42                          ; ALZ
PLCID_43:       plcptr  PLC_43                          ; BPZ
PLCID_44:       plcptr  PLC_44                          ; DPZ
PLCID_45:       plcptr  PLC_45                          ; CGZ
PLCID_46:       plcptr  PLC_46                          ; EMZ
PLCID_47:       plcptr  PLC_47                          ; Gumball Bonus
PLCID_48:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_49:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_4A:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_4B:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_4C:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_4D:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_4E:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_4F:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_50:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_51:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_52:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_53:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_54:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_55:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_56:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_57:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_58:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_59:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_5A:       plcptr  PLC_48_Through_5A               ; AIZ1 boss
PLCID_5B:       plcptr  PLC_5B                          ; HCZ1 boss
PLCID_5C:       plcptr  PLC_5C_5D                       ; CNZ1 boss (unused)
PLCID_5D:       plcptr  PLC_5C_5D                       ; CNZ1 boss
PLCID_5E:       plcptr  PLC_5E                          ; FBZ1 boss
PLCID_5F:       plcptr  PLC_5F                          ; ICZ1 boss
PLCID_60:       plcptr  PLC_60                          ; LBZ1 Eggman
PLCID_61:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_62:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_63:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_64:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_65:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_66:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_67:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_68:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_69:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_6A:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss
PLCID_6B:       plcptr  PLC_6B                          ; AIZ2 boss
PLCID_6C:       plcptr  PLC_6C                          ; HCZ2 boss
PLCID_6D:       plcptr  PLC_6D                          ; MGZ2 boss
PLCID_6E:       plcptr  PLC_6E                          ; CNZ2 boss
PLCID_6F:       plcptr  PLC_6F                          ; FBZ2 end boss
PLCID_70:       plcptr  PLC_70                          ; ICZ2 boss
PLCID_71:       plcptr  PLC_71                          ; LBZ2 final boss 1
PLCID_72:       plcptr  PLC_72_73_74_75_76_77           ; LBZ2 Eggman (unused)
PLCID_73:       plcptr  PLC_72_73_74_75_76_77           ; LBZ2 Eggman (unused)
PLCID_74:       plcptr  PLC_72_73_74_75_76_77           ; LBZ2 Eggman (unused)
PLCID_75:       plcptr  PLC_72_73_74_75_76_77           ; LBZ2 Eggman (unused)
PLCID_76:       plcptr  PLC_72_73_74_75_76_77           ; LBZ2 Eggman (unused)
PLCID_77:       plcptr  PLC_72_73_74_75_76_77           ; LBZ2 Eggman
PLCID_78:       plcptr  PLC_78_79_7A_7B                 ; Boss ship and explosion (unused)
PLCID_79:       plcptr  PLC_78_79_7A_7B                 ; Boss ship and explosion (unused)
PLCID_7A:       plcptr  PLC_78_79_7A_7B                 ; Boss ship and explosion (unused)
PLCID_7B:       plcptr  PLC_78_79_7A_7B                 ; Boss ship and explosion (unused)

PLC_00:         plrlistheader
                plreq   ArtTile_PlayerLifeIcon, ArtNem_SonicLifeIcon
                plreq   ArtTile_Ring, ArtNem_RingHUDText
                plreq   ArtTile_StarPost, ArtNem_EnemyPtsStarPost
                plreq   ArtTile_Monitors, ArtNem_Monitors
PLC_00_End:

PLC_01:         plrlistheader
                plreq   ArtTile_PlayerLifeIcon, ArtNem_SonicLifeIcon
                plreq   ArtTile_Monitors, ArtNem_Monitors
                plreq   ArtTile_Ring, ArtNem_RingHUDText
                plreq   ArtTile_StarPost, ArtNem_EnemyPtsStarPost
PLC_01_End:

PLC_02:         plrlistheader
                plreq   ArtTile_Explosion, ArtNem_Explosion
                plreq   ArtTile_Animals1, ArtNem_Squirrel
                plreq   ArtTile_Animals2, ArtNem_BlueFlicky
PLC_02_End:

PLC_03:         plrlistheader
                plreq   ArtTile_Shield, ArtNem_GameOver
PLC_03_End:

PLC_04:         plrlistheader
                plreq   ArtTile_S2Signpost, ArtNem_S2Signpost
PLC_04_End:

PLC_05:         plrlistheader
                plreq   ArtTile_SpikesSprings, ArtNem_SpikesSprings
PLC_05_End:

PLC_06:         plrlistheader
                plreq   ArtTile_2PArt_2, ArtNem_2PArt_2
                plreq   ArtTile_2PArt_1, ArtNem_2PArt_1
                plreq   ArtTile_2PArt_3, ArtNem_2PArt_3
PLC_06_End:

PLC_07:         plrlistheader
                plreq   ArtTile_PlayerLifeIcon, ArtNem_TailsLifeIcon
                plreq   ArtTile_Monitors, ArtNem_Monitors
                plreq   ArtTile_Ring, ArtNem_RingHUDText
                plreq   ArtTile_StarPost, ArtNem_EnemyPtsStarPost
PLC_07_End:

PLC_08:         plrlistheader
                plreq   ArtTile_Monitors, ArtNem_Monitors
PLC_08_End:

PLC_09:         plrlistheader
                plreq   ArtTile_SphereTest, ArtNem_SphereTest
PLC_09_End:

PLC_0A:         plrlistheader
                plreq   ArtTile_AIZIntroSprites, ArtNem_AIZIntroSprites
PLC_0A_End:

PLC_0B:         plrlistheader
                plreq   ArtTile_AIZSwingVine, ArtNem_AIZSwingVine
                plreq   ArtTile_AIZSlideRope, ArtNem_AIZSlideRope
                plreq   ArtTile_AIZMisc1, ArtNem_AIZMisc1
                plreq   ArtTile_AIZFallingLog, ArtNem_AIZFallingLog
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
                plreq   ArtTile_AIZFloatingPlatform, ArtNem_AIZCorkFloor
PLC_0B_End:

PLC_0C_0D:      plrlistheader
                plreq   ArtTile_AIZMisc2, ArtNem_AIZMisc2
                plreq   ArtTile_AIZSwingVine, ArtNem_AIZSwingVine
                plreq   ArtTile_AIZBackgroundTree, ArtNem_AIZBackgroundTree
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
                plreq   ArtTile_GrayButton, ArtNem_GrayButton
                plreq   ArtTile_AIZ2FloatingPlatform, ArtNem_AIZCorkFloor2
PLC_0C_0D_End:

PLC_0E:         plrlistheader
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
                plreq   ArtTile_HCZMisc, ArtNem_HCZMisc
                plreq   ArtTile_HCZButton, ArtNem_HCZButton
                plreq   ArtTile_HCZWaterRush, ArtNem_HCZWaterRush
                plreq   ArtTile_HCZWaveSplash, ArtNem_HCZWaveSplash
                plreq   ArtTile_HCZSpikeBall, ArtNem_HCZSpikeBall
PLC_0E_End:

PLC_0F:         plrlistheader
                plreq   ArtTile_Buggernaut, ArtNem_HCZDragonfly
PLC_0F_End:

PLC_10:         plrlistheader
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
                plreq   ArtTile_HCZMisc, ArtNem_HCZMisc
                plreq   ArtTile_HCZButton, ArtNem_HCZButton
                plreq   ArtTile_HCZWaveSplash, ArtNem_HCZWaveSplash
                plreq   ArtTile_HCZSpikeBall, ArtNem_HCZSpikeBall
                plreq   ArtTile_HCZ2Slide, ArtNem_HCZ2Slide
PLC_10_End:

PLC_11:         plrlistheader
                plreq   ArtTile_HCZ2KnuxWall, ArtNem_HCZ2KnuxWall
                plreq   ArtTile_HCZ2BlockPlat, ArtNem_HCZ2BlockPlat
                plreq   ArtTile_Buggernaut, ArtNem_HCZDragonfly
PLC_11_End:

PLC_12_13:      plrlistheader
                plreq   ArtTile_MGZMisc1, ArtNem_MGZMisc1
                plreq   ArtTile_MGZMisc2, ArtNem_MGZMisc2
                plreq   ArtTile_MGZSigns, ArtNem_MGZSigns
                plreq   ArtTile_MGZMHZDiagonalSpring, ArtNem_DiagonalSpring
PLC_12_13_End:

PLC_14_15:      plrlistheader
                plreq   ArtTile_MGZMisc1, ArtNem_MGZMisc1
                plreq   ArtTile_MGZMisc2, ArtNem_MGZMisc2
                plreq   ArtTile_MGZSigns, ArtNem_MGZSigns
                plreq   ArtTile_MGZMHZDiagonalSpring, ArtNem_DiagonalSpring
PLC_14_15_End:

PLC_16_17_18_19:    plrlistheader
                plreq   ArtTile_CNZMisc, ArtNem_CNZMisc
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
                plreq   ArtTile_CNZPlatform, ArtNem_CNZPlatform
PLC_16_17_18_19_End:

PLC_1A_1B_1C_1D:    plrlistheader
                plreq   ArtTile_DiagonalSpring, ArtNem_DiagonalSpring
PLC_1A_1B_1C_1D_End:

PLC_1E_1F:      plrlistheader
                plreq   ArtTile_SnowboardDust, ArtNem_SnowboardDust
                plreq   ArtTile_DiagonalSpring, ArtNem_DiagonalSpring
                plreq   ArtTile_GrayButton, ArtNem_GrayButton
                plreq   ArtTile_ICZMisc1, ArtNem_ICZMisc1
                plreq   ArtTile_ICZIntroSprites, ArtNem_ICZIntroSprites
PLC_1E_1F_End:

PLC_20_21:      plrlistheader
                plreq   ArtTile_DiagonalSpring, ArtNem_DiagonalSpring
                plreq   ArtTile_GrayButton, ArtNem_GrayButton
                plreq   ArtTile_ICZMisc1, ArtNem_ICZMisc1
                plreq   ArtTile_ICZMisc2, ArtNem_ICZMisc2
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
PLC_20_21_End:

PLC_22_23:      plrlistheader
                plreq   ArtTile_LBZMisc, ArtNem_LBZMisc
                plreq   ArtTile_LBZTubeTrans, ArtNem_LBZTubeTrans
PLC_22_23_End:

PLC_24:         plrlistheader
                plreq   ArtTile_LBZMisc, ArtNem_LBZMisc
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
PLC_24_End:

PLC_25:         plrlistheader
                plreq   ArtTile_LBZ2Misc, ArtNem_LBZ2Misc
PLC_25_End:

PLC_26_Through_2D:  plrlistheader
                plreq   ArtTile_DiagonalSpring, ArtNem_DiagonalSpring
                plreq   ArtTile_SpikesSprings, ArtNem_SpikesSprings
PLC_26_Through_2D_End:

PLC_2E_Through_41:  plrlistheader
                plreq   ArtTile_DiagonalSpring, ArtNem_DiagonalSpring
                plreq   ArtTile_SpikesSprings, ArtNem_SpikesSprings
PLC_2E_Through_41_End:

PLC_42:         plrlistheader
                plreq   ArtTile_DashDust, ArtNem_2PDashdust
                plreq   ArtTile_2PStartPost, ArtNem_2PStartPost
                plreq   ArtTile_2PLapNum, ArtNem_2PLapNum
                plreq   ArtTile_2PTime, ArtNem_2PTime
                plreq   ArtTile_2PPosIcon, ArtNem_2PPosIcon
                plreq   ArtTile_2PArt_2, ArtNem_2PArt_2
                plreq   ArtTile_2PArt_1, ArtNem_2PArt_1
                plreq   ArtTile_2PArt_3, ArtNem_2PArt_3
PLC_42_End:

PLC_43:         plrlistheader
                plreq   ArtTile_BPZMisc, ArtNem_BPZMisc
                plreq   ArtTile_DashDust, ArtNem_2PDashdust
                plreq   ArtTile_2PStartPost, ArtNem_2PStartPost
                plreq   ArtTile_2PLapNum, ArtNem_2PLapNum
                plreq   ArtTile_2PTime, ArtNem_2PTime
                plreq   ArtTile_2PPosIcon, ArtNem_2PPosIcon
                plreq   ArtTile_2PArt_2, ArtNem_2PArt_2
                plreq   ArtTile_2PArt_1, ArtNem_2PArt_1
                plreq   ArtTile_2PArt_3, ArtNem_2PArt_3
PLC_43_End:

PLC_44:         plrlistheader
                plreq   ArtTile_DPZMisc, ArtNem_DPZMisc
                plreq   ArtTile_DashDust, ArtNem_2PDashdust
                plreq   ArtTile_2PStartPost, ArtNem_2PStartPost
                plreq   ArtTile_2PLapNum, ArtNem_2PLapNum
                plreq   ArtTile_2PTime, ArtNem_2PTime
                plreq   ArtTile_2PPosIcon, ArtNem_2PPosIcon
                plreq   ArtTile_2PArt_2, ArtNem_2PArt_2
                plreq   ArtTile_2PArt_1, ArtNem_2PArt_1
                plreq   ArtTile_2PArt_3, ArtNem_2PArt_3
PLC_44_End:

PLC_45:         plrlistheader
                plreq   ArtTile_CGZMisc, ArtNem_CGZMisc
                plreq   ArtTile_DashDust, ArtNem_2PDashdust
                plreq   ArtTile_2PStartPost, ArtNem_2PStartPost
                plreq   ArtTile_2PLapNum, ArtNem_2PLapNum
                plreq   ArtTile_2PTime, ArtNem_2PTime
                plreq   ArtTile_2PPosIcon, ArtNem_2PPosIcon
                plreq   ArtTile_2PArt_2, ArtNem_2PArt_2
                plreq   ArtTile_2PArt_1, ArtNem_2PArt_1
                plreq   ArtTile_2PArt_3, ArtNem_2PArt_3
PLC_45_End:

PLC_46:         plrlistheader
                plreq   ArtTile_EMZMisc, ArtNem_EMZMisc
                plreq   ArtTile_DashDust, ArtNem_2PDashdust
                plreq   ArtTile_2PStartPost, ArtNem_2PStartPost
                plreq   ArtTile_2PLapNum, ArtNem_2PLapNum
                plreq   ArtTile_2PTime, ArtNem_2PTime
                plreq   ArtTile_2PPosIcon, ArtNem_2PPosIcon
                plreq   ArtTile_2PArt_2, ArtNem_2PArt_2
                plreq   ArtTile_2PArt_1, ArtNem_2PArt_1
                plreq   ArtTile_2PArt_3, ArtNem_2PArt_3
PLC_46_End:

PLC_47:         plrlistheader
                plreq   ArtTile_BonusStage, ArtNem_BonusStage
                plreq   ArtTile_SpikesSprings, ArtNem_SpikesSprings
PLC_47_End:

PLC_48_Through_5A:  plrlistheader
                plreq   ArtTile_AIZMiniboss, ArtNem_AIZMiniboss
                plreq   ArtTile_AIZMinibossSmall, ArtNem_AIZMinibossSmall
                plreq   ArtTile_AIZBossFire, ArtNem_AIZBossFire
                plreq   ArtTile_BossExplosion2, ArtNem_BossExplosion
PLC_48_Through_5A_End:

PLC_5B:         plrlistheader
                plreq   ArtTile_HCZMiniboss, ArtNem_HCZMiniboss
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_5B_End:

PLC_5C_5D:      plrlistheader
                plreq   ArtTile_CNZMiniboss, ArtNem_CNZMiniboss
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_5C_5D_End:

PLC_5E:         plrlistheader
                plreq   ArtTile_FBZMiniboss, ArtNem_FBZMiniboss
                plreq   ArtTile_EggCapsule-$46, ArtNem_EggCapsule
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_FBZAnimals1, ArtNem_Squirrel
                plreq   ArtTile_FBZAnimals2, ArtNem_BlueFlicky
PLC_5E_End:

PLC_5F:         plrlistheader
                plreq   ArtTile_ICZMiniboss, ArtNem_ICZMiniboss
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_5F_End:

PLC_60:         plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_LBZKnuxBomb, ArtNem_LBZKnuxBomb
PLC_60_End:

PLC_61_Through_6A:  plrlistheader
                plreq   ArtTile_FBZ2Subboss, ArtNem_FBZ2Subboss
                plreq   ArtTile_FBZRobotnikStand, ArtNem_FBZRobotnikStand
                plreq   ArtTile_FBZRobotnikRun, ArtNem_FBZRobotnikRun
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_61_Through_6A_End:

PLC_6B:         plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion2, ArtNem_BossExplosion
PLC_6B_End:

PLC_6C:         plrlistheader
                plreq   ArtTile_HCZEndBoss, ArtNem_HCZEndBoss
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_EggCapsule, ArtNem_EggCapsule
PLC_6C_End:

PLC_6D:         plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_EggCapsule, ArtNem_EggCapsule
PLC_6D_End:

PLC_6E:         plrlistheader
                plreq   ArtTile_CNZEndBoss, ArtNem_CNZEndBoss
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_EggCapsule, ArtNem_EggCapsule
PLC_6E_End:

PLC_6F:         plrlistheader
                plreq   ArtTile_FBZEndBoss-$20, ArtNem_FBZEndBoss
                plreq   ArtTile_FBZRobotnikHead-$20, ArtNem_FBZRobotnikHead
                plreq   ArtTile_FBZEndBossFlame+$4, ArtNem_FBZEndBossFlame
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_EggCapsule, ArtNem_EggCapsule
PLC_6F_End:

PLC_70:         plrlistheader
                plreq   ArtTile_ICZEndBoss, ArtNem_ICZEndBoss
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_EggCapsule, ArtNem_EggCapsule
PLC_70_End:

PLC_71:         plrlistheader
                plreq   ArtTile_LBZFinalBoss1, ArtNem_LBZFinalBoss1
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_71_End:

PLC_72_73_74_75_76_77:  plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_FBZRobotnikRun, ArtNem_FBZRobotnikRun
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_72_73_74_75_76_77_End:

PLC_78_79_7A_7B:    plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_78_79_7A_7B_End:

; =============== S U B R O U T I N E =======================================

DebugMode:
                moveq   #0,d0
                move.b  (Debug_placement_routine).w,d0
                move.w  DebugMode_Index(pc,d0.w),d1
                jmp     DebugMode_Index(pc,d1.w)
; End of function DebugMode

; ---------------------------------------------------------------------------
DebugMode_Index:
                dc.w    loc_5B532-DebugMode_Index
                dc.w    loc_5B5BA-DebugMode_Index
; ---------------------------------------------------------------------------

loc_5B532:
                addq.b  #2,(Debug_placement_routine).w
                move.l  mappings(a0),(Debug_saved_mappings).w
                move.w  art_tile(a0),(Debug_saved_art_tile).w
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,(Player_1+y_pos).w
                and.w   d0,(Camera_Y_pos).w
                clr.b   (Scroll_lock).w
                clr.w   (WindTunnel_flag).w
                bclr    #Status_Underwater,status(a0)
                beq.s   loc_5B578
                movea.l a0,a1
                jsr     (Player_ResetAirTimer).l
                move.w  #$600,(Max_speed).w
                move.w  #$C,(Acceleration).w
                move.w  #$80,(Deceleration).w

loc_5B578:
                move.b  #0,mapping_frame(a0)
                move.b  #0,anim(a0)
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #6,d0
                andi.w  #$7E,d0
                lea     (DebugOffs).l,a2
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d6
                cmp.b   (Debug_object).w,d6
                bhi.s   loc_5B5AA
                move.b  #0,(Debug_object).w

loc_5B5AA:
                bsr.w   sub_5B764
                move.b  #$C,(Debug_camera_delay).w
                move.b  #1,(Debug_camera_speed).w

loc_5B5BA:
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #6,d0
                andi.w  #$7E,d0
                lea     (DebugOffs).l,a2
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d6
                bsr.w   sub_5B5DE
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_5B5DE:
                moveq   #0,d4
                move.w  #1,d1
                move.b  (Ctrl_1_pressed).w,d4
                andi.w  #button_up_mask|button_down_mask|button_left_mask|button_right_mask,d4
                bne.s   loc_5B620
                move.b  (Ctrl_1_held).w,d0
                andi.w  #button_up_mask|button_down_mask|button_left_mask|button_right_mask,d0
                bne.s   loc_5B608
                move.b  #$C,(Debug_camera_delay).w
                move.b  #$F,(Debug_camera_speed).w
                bra.w   loc_5B684
; ---------------------------------------------------------------------------

loc_5B608:
                subq.b  #1,(Debug_camera_delay).w
                bne.s   loc_5B624
                move.b  #1,(Debug_camera_delay).w
                addq.b  #1,(Debug_camera_speed).w
                bne.s   loc_5B620
                move.b  #255,(Debug_camera_speed).w

loc_5B620:
                move.b  (Ctrl_1_held).w,d4

loc_5B624:
                moveq   #0,d1
                move.b  (Debug_camera_speed).w,d1
                addq.w  #1,d1
                swap    d1
                asr.l   #4,d1
                move.l  y_pos(a0),d2
                move.l  x_pos(a0),d3
                btst    #button_up,d4
                beq.s   loc_5B64E
                sub.l   d1,d2
                moveq   #0,d0
                move.w  (Camera_min_Y_pos).w,d0
                swap    d0
                cmp.l   d0,d2
                bge.s   loc_5B64E
                move.l  d0,d2

loc_5B64E:
                btst    #button_down,d4
                beq.s   loc_5B668
                add.l   d1,d2
                moveq   #0,d0
                move.w  (Camera_target_max_Y_pos).w,d0
                addi.w  #$DF,d0
                swap    d0
                cmp.l   d0,d2
                blt.s   loc_5B668
                move.l  d0,d2

loc_5B668:
                btst    #button_left,d4
                beq.s   loc_5B674
                sub.l   d1,d3
                bcc.s   loc_5B674
                moveq   #0,d3

loc_5B674:
                btst    #button_right,d4
                beq.s   loc_5B67C
                add.l   d1,d3

loc_5B67C:
                move.l  d2,y_pos(a0)
                move.l  d3,x_pos(a0)

loc_5B684:
                btst    #button_A,(Ctrl_1_held).w
                beq.s   loc_5B6BC
                btst    #button_C,(Ctrl_1_pressed).w
                beq.s   loc_5B6A0
                subq.b  #1,(Debug_object).w
                bcc.s   loc_5B6B8
                add.b   d6,(Debug_object).w
                bra.s   loc_5B6B8
; ---------------------------------------------------------------------------

loc_5B6A0:
                btst    #button_A,(Ctrl_1_pressed).w
                beq.s   loc_5B6BC
                addq.b  #1,(Debug_object).w
                cmp.b   (Debug_object).w,d6
                bhi.s   loc_5B6B8
                move.b  #0,(Debug_object).w

loc_5B6B8:
                bra.w   sub_5B764
; ---------------------------------------------------------------------------

loc_5B6BC:
                btst    #button_C,(Ctrl_1_pressed).w
                beq.s   loc_5B708
                jsr     (AllocateObject).l
                bne.s   loc_5B708
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  render_flags(a0),status(a1)
                andi.b  #$7F,status(a1)
                moveq   #0,d0
                move.b  (Debug_object).w,d0
                add.w   d0,d0
                move.w  d0,d1
                lsl.w   #2,d0
                add.w   d1,d0
                move.b  4(a2,d0.w),subtype(a1)
                move.l  (a2,d0.w),(a1)
                move.b  #0,(a1)
                rts
; ---------------------------------------------------------------------------

loc_5B708:
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   locret_5B734
                moveq   #0,d0
                move.w  d0,(Debug_placement_mode).w
                lea     (Player_1).w,a1
                move.l  (Debug_saved_mappings).w,mappings(a1)
                move.w  (Debug_saved_art_tile).w,art_tile(a1)
                bsr.s   sub_5B736
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)

locret_5B734:
                rts
; End of function sub_5B5DE

; =============== S U B R O U T I N E =======================================

sub_5B736:
                move.b  d0,anim(a1)
                move.w  d0,x_pos+2(a1)
                move.w  d0,y_pos+2(a1)
                move.b  d0,object_control(a1)
                move.b  d0,spin_dash_flag(a1)
                move.w  d0,x_vel(a1)
                move.w  d0,y_vel(a1)
                move.w  d0,ground_vel(a1)
                move.b  #1<<Status_InAir,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function sub_5B736

; =============== S U B R O U T I N E =======================================

sub_5B764:
                moveq   #0,d0
                move.b  (Debug_object).w,d0
                add.w   d0,d0
                move.w  d0,d1
                lsl.w   #2,d0
                add.w   d1,d0
                move.l  4(a2,d0.w),mappings(a0)
                move.w  8(a2,d0.w),art_tile(a0)
                move.b  (a2,d0.w),mapping_frame(a0)
                rts
; End of function sub_5B764

; ---------------------------------------------------------------------------
DebugOffs:      include "src/system/debug/shared/debug_list_pointers.s"

Debug_AIZ1:     dbglistinclude "src/system/debug/shared/zones/aiz/act_1_s3.s"
Debug_AIZ2:     dbglistinclude "src/system/debug/shared/zones/aiz/act_2_s3.s"
Debug_HCZ:      dbglistinclude "src/system/debug/shared/zones/hcz/s3.s"
Debug_MGZ:      dbglistinclude "src/system/debug/shared/zones/mgz/s3.s"
Debug_CNZ:      dbglistinclude "src/system/debug/shared/zones/cnz/s3.s"
Debug_FBZ1:
Debug_FBZ2:     dbglistinclude "src/system/debug/shared/zones/fbz/s3.s"
Debug_ICZ1:     dbglistinclude "src/system/debug/shared/zones/icz/act_1_s3.s"
Debug_ICZ2:     dbglistinclude "src/system/debug/shared/zones/icz/act_2_s3.s"
Debug_LBZ1:     dbglistinclude "src/system/debug/shared/zones/lbz/act_1_s3.s"
Debug_LBZ2:     dbglistinclude "src/system/debug/shared/zones/lbz/act_2_s3.s"
Debug_MHZ:      dbglistinclude "src/system/debug/shared/zones/mhz/s3.s"
Debug_SOZ1:
Debug_SOZ2:     dbglistinclude "src/system/debug/shared/zones/soz/s3.s"
Debug_LRZ1:
Debug_LRZ2:     dbglistinclude "src/system/debug/shared/zones/lrz/s3.s"
    ; Presumably, these belong to the LRZ debug list, but the header only counts five entries, ignoring these three
                dbglistobj Obj_Spring, Map_Spring, $90,   3, make_art_tile(ArtTile_SpikesSprings+$20,0,0)
                dbglistobj Obj_Spring, Map_Spring, $A0,   6, make_art_tile(ArtTile_SpikesSprings+$10,0,0)
                dbglistobj Obj_Spikes, Map_Spikes,   0,   0, make_art_tile(ArtTile_SpikesSprings+$8,0,0)
Debug_SSZ:              dbglistinclude "src/system/debug/shared/zones/ssz/s3.s"
Debug_DEZ1:
Debug_DEZ2:             dbglistinclude "src/system/debug/shared/zones/dez/s3.s"
Debug_DDZ1:
Debug_DDZ2:             dbglistinclude "src/system/debug/shared/zones/ddz/s3.s"
Debug_Ending:           dbglistinclude "src/system/debug/shared/zones/ssz/ending_s3.s"
Debug_ALZ:              dbglistinclude "src/system/debug/shared/zones/alz/main.s"
Debug_BPZ:              dbglistinclude "src/system/debug/shared/zones/bpz/main.s"
Debug_DPZ:              dbglistinclude "src/system/debug/shared/zones/dpz/main.s"
Debug_CGZ:              dbglistinclude "src/system/debug/shared/zones/cgz/main.s"
Debug_EMZ:              dbglistinclude "src/system/debug/shared/zones/emz/main.s"
Debug_Pachinko_Special:
Debug_HPZ:
Debug_Gumball_Special:  dbglistinclude "src/system/debug/shared/zones/gumball/s3.s"

Sprite_Listing: include "src/objects/shared/world/object_pointers_s3_set.s"

                align   $2000
Character_Speeds:
                dc.w    $600,  $10,  $20,    0
                dc.w    $4C0,  $1C,  $70,    0
                dc.w    $580,  $10, $200,    0
Start_Locations:
                binclude "data/Levels/AIZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/AIZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/HCZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/HCZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/MGZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/MGZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/CNZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/CNZ/Start Location/Sonic/2.bin"
                dc.w    $60,  $6EC
                dc.w    $60,  $5EC
                binclude "data/Levels/ICZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/ICZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/LBZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/LBZ/Start Location/Sonic/2.bin"
                dc.w    $80,  $6AA
                dc.w    $80,  $3AA
                dc.w    $230,  $1AC
                dc.w    $230,  $1AC
                dc.w    $100,   $20
                dc.w    $100,   $20
                dc.w    $60,  $6AC
                dc.w    $60,  $56C
                dc.w    $60,  $6AC
                dc.w    $60,  $5AC
                dc.w    $60,  $2AC
                dc.w    $60,  $58C
                dc.w    $60,  $1EC
                dc.w    $60,  $12C
                binclude "data/Levels/ALZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/ALZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/BPZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/BPZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/DPZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/DPZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/CGZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/CGZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/EMZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/EMZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/Gumball/Start Location/Sonic/1.bin"
                binclude "data/Levels/Gumball/Start Location/Sonic/2.bin"
                dc.w    $60,   $70
                dc.w    $60,   $70
                dc.w    $60,   $70
                dc.w    $60,   $70
                dc.w    $60,   $70
                dc.w    $60,   $70
                dc.w    $60,   $70
                dc.w    $60,   $70
SpriteLocPtrs:
                dc.l    AIZ1_Sprites
                dc.l    AIZ2_Sprites
                dc.l    HCZ1_Sprites
                dc.l    HCZ2_Sprites
                dc.l    MGZ1_Sprites
                dc.l    MGZ2_Sprites
                dc.l    CNZ1_Sprites
                dc.l    CNZ2_Sprites
                dc.l    FBZ1_Sprites
                dc.l    FBZ2_Sprites
                dc.l    ICZ1_Sprites
                dc.l    ICZ2_Sprites
                dc.l    LBZ1_Sprites
                dc.l    LBZ2_Sprites
                dc.l    MHZ1_Sprites
                dc.l    MHZ2_Sprites
                dc.l    SOZ1_Sprites
                dc.l    SOZ2_Sprites
                dc.l    LRZ1_Sprites
                dc.l    LRZ2_Sprites
                dc.l    SSZ1_Sprites
                dc.l    SSZ2_Sprites
                dc.l    DEZ1_Sprites
                dc.l    DEZ2_Sprites
                dc.l    DDZ1_Sprites
                dc.l    DDZ2_Sprites
                dc.l    Ending1_Sprites
                dc.l    Ending2_Sprites
                dc.l    ALZ1_Sprites
                dc.l    ALZ2_Sprites
                dc.l    BPZ1_Sprites
                dc.l    BPZ2_Sprites
                dc.l    DPZ1_Sprites
                dc.l    DPZ2_Sprites
                dc.l    CGZ1_Sprites
                dc.l    CGZ2_Sprites
                dc.l    EMZ1_Sprites
                dc.l    EMZ2_Sprites
                dc.l    Gumball1_Sprites
                dc.l    Gumball2_Sprites
                dc.l    Pachinko1_Sprites
                dc.l    Pachinko2_Sprites
                dc.l    Slots1_Sprites
                dc.l    Slots2_Sprites
                dc.l    LRZ3_Sprites
                dc.l    HPZ_Sprites
                dc.l    DEZ3_Sprites
                dc.l    HPZMini_Sprites
RingLocPtrs:
                dc.l    AIZ1_Rings
                dc.l    AIZ2_Rings
                dc.l    HCZ1_Rings
                dc.l    HCZ2_Rings
                dc.l    MGZ1_Rings
                dc.l    MGZ2_Rings
                dc.l    CNZ1_Rings
                dc.l    CNZ2_Rings
                dc.l    FBZ1_Rings
                dc.l    FBZ2_Rings
                dc.l    ICZ1_Rings
                dc.l    ICZ2_Rings
                dc.l    LBZ1_Rings
                dc.l    LBZ2_Rings
                dc.l    MHZ1_Rings
                dc.l    MHZ2_Rings
                dc.l    SOZ1_Rings
                dc.l    SOZ2_Rings
                dc.l    LRZ1_Rings
                dc.l    LRZ2_Rings
                dc.l    SSZ1_Rings
                dc.l    SSZ2_Rings
                dc.l    DEZ1_Rings
                dc.l    DEZ2_Rings
                dc.l    DDZ1_Rings
                dc.l    DDZ2_Rings
                dc.l    Ending1_Rings
                dc.l    Ending2_Rings
                dc.l    ALZ1_Rings
                dc.l    ALZ2_Rings
                dc.l    BPZ1_Rings
                dc.l    BPZ2_Rings
                dc.l    DPZ1_Rings
                dc.l    DPZ2_Rings
                dc.l    CGZ1_Rings
                dc.l    CGZ2_Rings
                dc.l    EMZ1_Rings
                dc.l    EMZ2_Rings
                dc.l    Gumball1_Rings
                dc.l    Gumball2_Rings
                dc.l    Pachinko1_Rings
                dc.l    Pachinko2_Rings
                dc.l    Slots1_Rings
                dc.l    Slots2_Rings
                dc.l    LRZ3_Rings
                dc.l    HPZ_Rings
                dc.l    DEZ3_Rings
                dc.l    HPZMini_Rings
AutoTunnel_Data:
                dc.l    AutoTunnel_00
                dc.l    AutoTunnel_01_02
                dc.l    AutoTunnel_01_02
                dc.l    AutoTunnel_03
                dc.l    AutoTunnel_04
                dc.l    AutoTunnel_05
                dc.l    AutoTunnel_06
                dc.l    AutoTunnel_07
                dc.l    AutoTunnel_08
                dc.l    AutoTunnel_09
                dc.l    AutoTunnel_0A
                dc.l    AutoTunnel_0B
                dc.l    AutoTunnel_0C
                dc.l    AutoTunnel_0D
                dc.l    AutoTunnel_0E
                dc.l    AutoTunnel_0F
                dc.l    AutoTunnel_10
                dc.l    AutoTunnel_11
                dc.l    AutoTunnel_12
                dc.l    AutoTunnel_13
                dc.l    AutoTunnel_14
                dc.l    SpriteTerminat9
                dc.l    SpriteTerminat9
                dc.l    SpriteTerminat9
                dc.l    SpriteTerminat9
                dc.l    SpriteTerminat9
                dc.l    SpriteTerminat9
                dc.l    SpriteTerminat9
                dc.l    SpriteTerminat9
                dc.l    SpriteTerminat9
                dc.l    SpriteTerminat9
                dc.l    SpriteTerminat9
SStageLayoutPtrs:
                dc.l    SStage1_Layout
                dc.l    SStage2_Layout
                dc.l    SStage3_Layout
                dc.l    SStage4_Layout
                dc.l    SStage5_Layout
                dc.l    SStage6_Layout
                dc.l    SStage7_Layout
                dc.l    SStage8_Layout
SpriteTerminat1:
                dc.w    $FFFF,     0,     0
AIZ1_Sprites:
                binclude "data/Levels/AIZ/Object Pos/1-S3.bin"
                even
AIZ2_Sprites:
                binclude "data/Levels/AIZ/Object Pos/2-S3.bin"
                even
AIZ1_Rings:
                binclude "data/Levels/AIZ/Ring Pos/1-S3.bin"
                even
AIZ2_Rings:
                binclude "data/Levels/AIZ/Ring Pos/2-S3.bin"
                even
SpriteTerminat2:
                dc.w    $FFFF,     0,     0
HCZ1_Sprites:
                binclude "data/Levels/HCZ/Object Pos/1-S3.bin"
                even
HCZ2_Sprites:
                binclude "data/Levels/HCZ/Object Pos/2-S3.bin"
                even
HCZ1_Rings:
                binclude "data/Levels/HCZ/Ring Pos/1-S3.bin"
                even
HCZ2_Rings:
                binclude "data/Levels/HCZ/Ring Pos/2-S3.bin"
                even
SpriteTerminat3:
                dc.w    $FFFF,     0,     0
MGZ1_Sprites:
                binclude "data/Levels/MGZ/Object Pos/1-S3.bin"
                even
MGZ1_Rings:
                binclude "data/Levels/MGZ/Ring Pos/1-S3.bin"
                even
SpriteTerminat4:
                dc.w    $FFFF,     0,     0
MGZ2_Sprites:
                binclude "data/Levels/MGZ/Object Pos/2-S3.bin"
                even
MGZ2_Rings:
                binclude "data/Levels/MGZ/Ring Pos/2-S3.bin"
                even
SpriteTerminat5:
                dc.w    $FFFF,     0,     0
CNZ1_Sprites:
                binclude "data/Levels/CNZ/Object Pos/1-S3.bin"
                even
CNZ2_Sprites:
                binclude "data/Levels/CNZ/Object Pos/2-S3.bin"
                even
CNZ1_Rings:
                binclude "data/Levels/CNZ/Ring Pos/1-S3.bin"
                even
CNZ2_Rings:
                binclude "data/Levels/CNZ/Ring Pos/2-S3.bin"
                even
SpriteTerminat6:
                dc.w    $FFFF,     0,     0
FBZ1_Sprites:
                binclude "data/Levels/FBZ/Object Pos/1-S3.bin"
                even
FBZ2_Sprites:
                binclude "data/Levels/FBZ/Object Pos/2-S3.bin"
                even
FBZ1_Rings:
                binclude "data/Levels/FBZ/Ring Pos/1-S3.bin"
                even
FBZ2_Rings:
                binclude "data/Levels/FBZ/Ring Pos/2-S3.bin"
                even
SpriteTerminat7:
                dc.w    $FFFF,     0,     0
ICZ1_Sprites:
                binclude "data/Levels/ICZ/Object Pos/1-S3.bin"
                even
ICZ2_Sprites:
                binclude "data/Levels/ICZ/Object Pos/2-S3.bin"
                even
ICZ1_Rings:
                binclude "data/Levels/ICZ/Ring Pos/1-S3.bin"
                even
ICZ2_Rings:
                binclude "data/Levels/ICZ/Ring Pos/2-S3.bin"
                even
SpriteTerminat8:
                dc.w    $FFFF,     0,     0
LBZ1_Sprites:
                binclude "data/Levels/LBZ/Object Pos/1-S3.bin"
                even
LBZ2_Sprites:
                binclude "data/Levels/LBZ/Object Pos/2-S3.bin"
                even
LBZ1_Rings:
                binclude "data/Levels/LBZ/Ring Pos/1-S3.bin"
                even
LBZ2_Rings:
                binclude "data/Levels/LBZ/Ring Pos/2-S3.bin"
                even
AutoTunnel_00:
                dc.w    $C
                dc.w    $F60,  $578
                dc.w    $F60,  $548
                dc.w    $F60,  $378
AutoTunnel_01_02:
                dc.w    $38
                dc.w    $D40,  $770
                dc.w    $D48,  $770
                dc.w    $D50,  $770
                dc.w    $D58,  $770
                dc.w    $D60,  $770
                dc.w    $DB0,  $770
                dc.w    $DD0,  $77C
                dc.w    $DE0,  $79C
                dc.w    $DD6,  $7BC
                dc.w    $DB6,  $7CE
                dc.w    $D96,  $7CE
                dc.w    $D86,  $7C8
                dc.w    $D70,  $7A8
                dc.w    $D70,  $688
AutoTunnel_03:
                dc.w    $28
                dc.w    $D30,  $770
                dc.w    $DB0,  $770
                dc.w    $DD0,  $77C
                dc.w    $DE0,  $79C
                dc.w    $DD6,  $7BC
                dc.w    $DB6,  $7CE
                dc.w    $D96,  $7CE
                dc.w    $D86,  $7C8
                dc.w    $D70,  $7A8
                dc.w    $D70,  $748
AutoTunnel_04:
                dc.w    $38
                dc.w    $2CC0,  $9F0
                dc.w    $2CC8,  $9F0
                dc.w    $2CD0,  $9F0
                dc.w    $2CD8,  $9F0
                dc.w    $2CE0,  $9F0
                dc.w    $2D30,  $9F0
                dc.w    $2D50,  $9FC
                dc.w    $2D60,  $A1C
                dc.w    $2D56,  $A3C
                dc.w    $2D36,  $A4E
                dc.w    $2D16,  $A4E
                dc.w    $2D06,  $A48
                dc.w    $2CF0,  $A28
                dc.w    $2CF0,  $908
AutoTunnel_05:
                dc.w    $28
                dc.w    $2CB0,  $9F0
                dc.w    $2D30,  $9F0
                dc.w    $2D50,  $9FC
                dc.w    $2D60,  $A1C
                dc.w    $2D56,  $A3C
                dc.w    $2D36,  $A4E
                dc.w    $2D16,  $A4E
                dc.w    $2D06,  $A48
                dc.w    $2CF0,  $A28
                dc.w    $2CF0,  $9C8
AutoTunnel_06:
                dc.w    $38
                dc.w    $3640,  $A70
                dc.w    $3648,  $A70
                dc.w    $3650,  $A70
                dc.w    $3658,  $A70
                dc.w    $3660,  $A70
                dc.w    $36B0,  $A70
                dc.w    $36D0,  $A7C
                dc.w    $36E0,  $A9C
                dc.w    $36D6,  $ABC
                dc.w    $36B6,  $ACE
                dc.w    $3696,  $ACE
                dc.w    $3686,  $AC8
                dc.w    $3670,  $AA8
                dc.w    $3670,  $988
AutoTunnel_07:
                dc.w    $28
                dc.w    $3630,  $A70
                dc.w    $36B0,  $A70
                dc.w    $36D0,  $A7C
                dc.w    $36E0,  $A9C
                dc.w    $36D6,  $ABC
                dc.w    $36B6,  $ACE
                dc.w    $3696,  $ACE
                dc.w    $3686,  $AC8
                dc.w    $3670,  $AA8
                dc.w    $3670,  $A48
AutoTunnel_08:
                dc.w    $38
                dc.w    $37C0,  $7F0
                dc.w    $37C8,  $7F0
                dc.w    $37D0,  $7F0
                dc.w    $37D8,  $7F0
                dc.w    $37E0,  $7F0
                dc.w    $3830,  $7F0
                dc.w    $3850,  $7FC
                dc.w    $3860,  $81C
                dc.w    $3856,  $83C
                dc.w    $3836,  $84E
                dc.w    $3816,  $84E
                dc.w    $3806,  $848
                dc.w    $37F0,  $828
                dc.w    $37F0,  $708
AutoTunnel_09:
                dc.w    $28
                dc.w    $37B0,  $7F0
                dc.w    $3830,  $7F0
                dc.w    $3850,  $7FC
                dc.w    $3860,  $81C
                dc.w    $3856,  $83C
                dc.w    $3836,  $84E
                dc.w    $3816,  $84E
                dc.w    $3806,  $848
                dc.w    $37F0,  $828
                dc.w    $37F0,  $7C8
AutoTunnel_0A:
                dc.w    $38
                dc.w    $29C0,  $470
                dc.w    $29C8,  $470
                dc.w    $29D0,  $470
                dc.w    $29D8,  $470
                dc.w    $29E0,  $470
                dc.w    $2A30,  $470
                dc.w    $2A50,  $47C
                dc.w    $2A60,  $49C
                dc.w    $2A56,  $4BC
                dc.w    $2A36,  $4CE
                dc.w    $2A16,  $4CE
                dc.w    $2A06,  $4C8
                dc.w    $29F0,  $4A8
                dc.w    $29F0,  $388
AutoTunnel_0B:
                dc.w    $28
                dc.w    $29B0,  $470
                dc.w    $2A30,  $470
                dc.w    $2A50,  $47C
                dc.w    $2A60,  $49C
                dc.w    $2A56,  $4BC
                dc.w    $2A36,  $4CE
                dc.w    $2A16,  $4CE
                dc.w    $2A06,  $4C8
                dc.w    $29F0,  $4A8
                dc.w    $29F0,  $448
AutoTunnel_0C:
                dc.w    $104
                dc.w    $26C0,  $530
                dc.w    $26C0,  $6E0
                dc.w    $26B2,  $700
                dc.w    $2692,  $710
                dc.w    $25F2,  $710
                dc.w    $25D2,  $704
                dc.w    $25C0,  $6E4
                dc.w    $25C0,  $4B4
                dc.w    $25B0,  $484
                dc.w    $2590,  $464
                dc.w    $2560,  $450
                dc.w    $24D0,  $450
                dc.w    $2490,  $43B
                dc.w    $2450,  $41F
                dc.w    $2400,  $410
                dc.w    $2300,  $410
                dc.w    $22D0,  $415
                dc.w    $22A0,  $42B
                dc.w    $2280,  $448
                dc.w    $2240,  $468
                dc.w    $2200,  $470
                dc.w    $21C0,  $468
                dc.w    $2180,  $448
                dc.w    $2160,  $42B
                dc.w    $2130,  $415
                dc.w    $2100,  $410
                dc.w    $20D0,  $415
                dc.w    $20A0,  $42B
                dc.w    $2080,  $448
                dc.w    $2040,  $468
                dc.w    $2000,  $470
                dc.w    $1FC0,  $468
                dc.w    $1F80,  $448
                dc.w    $1F60,  $42B
                dc.w    $1F30,  $415
                dc.w    $1F00,  $410
                dc.w    $1ED0,  $415
                dc.w    $1EA0,  $42B
                dc.w    $1E80,  $448
                dc.w    $1E40,  $468
                dc.w    $1E00,  $470
                dc.w    $1C70,  $470
                dc.w    $1C40,  $440
                dc.w    $1C40,  $320
                dc.w    $1C50,  $300
                dc.w    $1C70,  $2F0
                dc.w    $1F80,  $2F0
                dc.w    $1FD0,  $2E4
                dc.w    $2000,  $2C8
                dc.w    $2020,  $2AB
                dc.w    $2040,  $29A
                dc.w    $2080,  $290
                dc.w    $20C0,  $2A7
                dc.w    $2170,  $357
                dc.w    $21B0,  $370
                dc.w    $2400,  $370
                dc.w    $2440,  $380
                dc.w    $2480,  $390
                dc.w    $24B0,  $384
                dc.w    $24C0,  $364
                dc.w    $24C0,   $C4
                dc.w    $2490,   $90
                dc.w    $2450,   $9C
                dc.w    $2440,   $CC
                dc.w    $2440,   $FC
AutoTunnel_0D:
                dc.w    $64
                dc.w    $33C0,  $130
                dc.w    $33C0,  $1E0
                dc.w    $33D0,  $200
                dc.w    $3400,  $210
                dc.w    $3450,  $220
                dc.w    $34A0,  $270
                dc.w    $34C0,  $2A0
                dc.w    $34C0,  $460
                dc.w    $34CE,  $480
                dc.w    $34F0,  $490
                dc.w    $3710,  $490
                dc.w    $372E,  $480
                dc.w    $3740,  $460
                dc.w    $3740,  $330
                dc.w    $3720,  $310
                dc.w    $35F0,  $310
                dc.w    $35CE,  $300
                dc.w    $35C0,  $2E0
                dc.w    $35C0,   $40
                dc.w    $35CC,   $20
                dc.w    $3600,   $10
                dc.w    $3690,   $10
                dc.w    $36B4,   $20
                dc.w    $36C0,   $40
                dc.w    $36C0,   $80
AutoTunnel_0E:
                dc.w    $38
                dc.w    $14C0,  $AB0
                dc.w    $14C0,  $B60
                dc.w    $14D0,  $B80
                dc.w    $14F0,  $B90
                dc.w    $1610,  $B90
                dc.w    $1630,  $B80
                dc.w    $1640,  $B60
                dc.w    $1640,  $8C0
                dc.w    $1650,  $8A0
                dc.w    $1670,  $890
                dc.w    $1890,  $890
                dc.w    $18B0,  $89C
                dc.w    $18C0,  $8BC
                dc.w    $18C0,  $8FC
AutoTunnel_0F:
                dc.w    $38
                dc.w    $3840,  $730
                dc.w    $3840,  $860
                dc.w    $3832,  $880
                dc.w    $3802,  $890
                dc.w    $37D2,  $884
                dc.w    $37C0,  $864
                dc.w    $37C0,  $3D4
                dc.w    $37D0,  $3B4
                dc.w    $37F0,  $39C
                dc.w    $3820,  $390
                dc.w    $3990,  $390
                dc.w    $39B0,  $39C
                dc.w    $39C0,  $3BC
                dc.w    $39C0,  $3FC
AutoTunnel_10:
                dc.w    $7C
                dc.w    $F60,  $5C8
                dc.w    $F60,  $950
                dc.w    $F64,  $980
                dc.w    $F68,  $990
                dc.w    $F73,  $9B0
                dc.w    $F82,  $9D0
                dc.w    $F8C,  $9E0
                dc.w    $F98,  $9F0
                dc.w    $FA5,  $A00
                dc.w    $FB5,  $A10
                dc.w    $FC5,  $A1C
                dc.w    $FD5,  $A28
                dc.w    $FF5,  $A38
                dc.w    $1005,  $A40
                dc.w    $1025,  $A4A
                dc.w    $1035,  $A4C
                dc.w    $1055,  $A50
                dc.w    $1265,  $A50
                dc.w    $12A5,  $A48
                dc.w    $12C5,  $A3C
                dc.w    $12E5,  $A2C
                dc.w    $12F5,  $A20
                dc.w    $1305,  $A14
                dc.w    $1315,  $A08
                dc.w    $1320,  $9F8
                dc.w    $132F,  $9E8
                dc.w    $1343,  $9C8
                dc.w    $1350,  $9A8
                dc.w    $135A,  $988
                dc.w    $1360,  $958
                dc.w    $1360,  $878
AutoTunnel_11:
                dc.w    $7C
                dc.w    $3760,  $1C8
                dc.w    $3760,  $510
                dc.w    $375A,  $540
                dc.w    $3750,  $560
                dc.w    $3743,  $580
                dc.w    $372F,  $5A0
                dc.w    $3720,  $5B0
                dc.w    $3715,  $5C0
                dc.w    $3705,  $5CC
                dc.w    $36F5,  $5D8
                dc.w    $36E5,  $5E4
                dc.w    $36C5,  $5F4
                dc.w    $36A5,  $600
                dc.w    $3665,  $608
                dc.w    $3655,  $608
                dc.w    $3635,  $604
                dc.w    $3625,  $602
                dc.w    $3605,  $5F8
                dc.w    $35F5,  $5F0
                dc.w    $35D5,  $5E0
                dc.w    $35C5,  $5D4
                dc.w    $35B5,  $5C8
                dc.w    $35A5,  $5B8
                dc.w    $3598,  $5A8
                dc.w    $358C,  $598
                dc.w    $3582,  $588
                dc.w    $3573,  $568
                dc.w    $3568,  $548
                dc.w    $3564,  $538
                dc.w    $3560,  $508
                dc.w    $3560,  $478
AutoTunnel_12:
                dc.w    $7C
                dc.w    $3460,  $5C8
                dc.w    $3460,  $690
                dc.w    $345A,  $6C0
                dc.w    $3450,  $6E0
                dc.w    $3443,  $700
                dc.w    $342F,  $720
                dc.w    $3420,  $730
                dc.w    $3415,  $740
                dc.w    $3405,  $74C
                dc.w    $33F5,  $758
                dc.w    $33E5,  $764
                dc.w    $33C5,  $774
                dc.w    $33A5,  $780
                dc.w    $3365,  $788
                dc.w    $3355,  $788
                dc.w    $3335,  $784
                dc.w    $3325,  $782
                dc.w    $3305,  $778
                dc.w    $32F5,  $770
                dc.w    $32D5,  $760
                dc.w    $32C5,  $754
                dc.w    $32B5,  $748
                dc.w    $32A5,  $738
                dc.w    $3298,  $728
                dc.w    $328C,  $718
                dc.w    $3282,  $708
                dc.w    $3273,  $6E8
                dc.w    $3268,  $6C8
                dc.w    $3264,  $6B8
                dc.w    $3260,  $688
                dc.w    $3260,  $5F8
AutoTunnel_13:
                dc.w    $28
                dc.w    $1C70,  $730
                dc.w    $1C70,  $6C0
                dc.w    $1C62,  $6A0
                dc.w    $1C42,  $692
                dc.w    $1C32,  $692
                dc.w    $1C12,  $69B
                dc.w    $1C00,  $6BB
                dc.w    $1C08,  $6DB
                dc.w    $1C28,  $6F0
                dc.w    $1CA8,  $6F0
AutoTunnel_14:
                dc.w    $28
                dc.w    $3670,  $830
                dc.w    $3670,  $7C0
                dc.w    $3662,  $7A0
                dc.w    $3642,  $792
                dc.w    $3632,  $792
                dc.w    $3612,  $79B
                dc.w    $3600,  $7BB
                dc.w    $3608,  $7DB
                dc.w    $3628,  $7F0
                dc.w    $36A8,  $7F0
SpriteTerminat9:
                dc.w    $FFFF,     0,     0
MHZ1_Sprites:
                binclude "data/Levels/MHZ/Object Pos/1-S3.bin"
                even
MHZ2_Sprites:
                binclude "data/Levels/MHZ/Object Pos/2-S3.bin"
                even
MHZ1_Rings:
                dc.w    $80, $7100, $FFFF
MHZ2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatA:
                dc.w    $FFFF,     0,     0
SOZ1_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
SOZ2_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
SOZ1_Rings:
                dc.w    $80, $7100, $FFFF
SOZ2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatB:
                dc.w    $FFFF,     0,     0
LRZ1_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
LRZ2_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
LRZ1_Rings:
                dc.w    $80, $7100, $FFFF
LRZ2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatC:
                dc.w    $FFFF,     0,     0
SSZ1_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
SSZ2_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
SSZ1_Rings:
                dc.w    $80, $7100, $FFFF
SSZ2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatD:
                dc.w    $FFFF,     0,     0
DEZ1_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
DEZ2_Sprites:
                dc.w    $550,     0,  $289
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
DEZ1_Rings:
                dc.w    $80, $7100, $FFFF
DEZ2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatE:
                dc.w    $FFFF,     0,     0
DDZ1_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
DDZ2_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
DDZ1_Rings:
                dc.w    $80, $7100, $FFFF
DDZ2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatF:
                dc.w    $FFFF,     0,     0
Ending1_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
Ending2_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
Ending1_Rings:
                dc.w    $80, $7100, $FFFF
Ending2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatG:
                dc.w    $FFFF,     0,     0
ALZ1_Sprites:
                binclude "data/Levels/ALZ/Object Pos/1.bin"
                even
ALZ2_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
ALZ1_Rings:
                dc.w    $80, $7100, $FFFF
ALZ2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatH:
                dc.w    $FFFF,     0,     0
BPZ1_Sprites:
                binclude "data/Levels/BPZ/Object Pos/1.bin"
                even
BPZ2_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
BPZ1_Rings:
                dc.w    $80, $7100, $FFFF
BPZ2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatI:
                dc.w    $FFFF,     0,     0
DPZ1_Sprites:
                binclude "data/Levels/DPZ/Object Pos/1.bin"
                even
DPZ2_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
DPZ1_Rings:
                dc.w    $80, $7100, $FFFF
DPZ2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatJ:
                dc.w    $FFFF,     0,     0
CGZ1_Sprites:
                binclude "data/Levels/CGZ/Object Pos/1.bin"
                even
CGZ2_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
CGZ1_Rings:
                dc.w    $80, $7100, $FFFF
CGZ2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatK:
                dc.w    $FFFF,     0,     0
EMZ1_Sprites:
                binclude "data/Levels/EMZ/Object Pos/1.bin"
                even
EMZ2_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
EMZ1_Rings:
                dc.w    $80, $7100, $FFFF
EMZ2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatL:
                dc.w    $FFFF,     0,     0
Gumball1_Sprites:
                binclude "data/Levels/Gumball/Object Pos/1-S3.bin"
                even
Gumball2_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
Gumball1_Rings:
                dc.w    $200,  $200, $FFFF
Gumball2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatM:
                dc.w    $FFFF,     0,     0
Pachinko1_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
Pachinko2_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
Pachinko1_Rings:
                dc.w    $80, $7100, $FFFF
Pachinko2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatN:
                dc.w    $FFFF,     0,     0
Slots1_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
Slots2_Sprites:
                dc.w    $80,   $80,     0
                dc.w    $FFFF,     0,     0
Slots1_Rings:
                dc.w    $80, $7100, $FFFF
Slots2_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatO:
                dc.w    $FFFF,     0,     0
LRZ3_Sprites:
                dc.w    $FFFF,     0,     0
HPZ_Sprites:
                dc.w    $FFFF,     0,     0
LRZ3_Rings:
                dc.w    $80, $7100, $FFFF
HPZ_Rings:
                dc.w    $80, $7100, $FFFF
SpriteTerminatP:
                dc.w    $FFFF,     0,     0
DEZ3_Sprites:
                dc.w    $FFFF,     0,     0
HPZMini_Sprites:
                dc.w    $FFFF,     0,     0
DEZ3_Rings:
                dc.w    $80, $7100, $FFFF
HPZMini_Rings:
                dc.w    $80, $7100, $FFFF
SStage1_Layout:
                binclude "data/General/Special Stage/Layout/S3 1.bin"
                even
SStage2_Layout:
                binclude "data/General/Special Stage/Layout/S3 2.bin"
                even
SStage3_Layout:
                binclude "data/General/Special Stage/Layout/S3 3.bin"
                even
SStage4_Layout:
                binclude "data/General/Special Stage/Layout/S3 4.bin"
                even
SStage5_Layout:
                binclude "data/General/Special Stage/Layout/S3 5.bin"
                even
SStage6_Layout:
                binclude "data/General/Special Stage/Layout/S3 6.bin"
                even
SStage7_Layout:
                binclude "data/General/Special Stage/Layout/S3 7.bin"
                even
SStage8_Layout:
                binclude "data/General/Special Stage/Layout/S3 8.bin"
                align   $1000
HCZ_WaterlineScroll_Data:
                binclude "data/Levels/HCZ/Misc/HCZ Waterline Scroll Data.bin"
                even
LBZ_WaterlineScroll_Data:
                binclude "data/Levels/LBZ/Misc/LBZ Waterline Scroll Data.bin"
                even
AngleArray:
                binclude "data/Levels/Misc/Angles S3.bin"
                even
HeightMaps:
                binclude "data/Levels/Misc/Height Maps S3.bin"
                even
HeightMapsRot:
                binclude "data/Levels/Misc/Height Maps Rotated S3.bin"
                even
SolidIndexes:
                dc.l    Solid_AIZ1
                dc.l    Solid_AIZ2
                dc.l    Solid_HCZ1
                dc.l    Solid_HCZ2
                dc.l    Solid_MGZ1
                dc.l    Solid_MGZ2
                dc.l    Solid_CNZ
                dc.l    Solid_CNZ
                dc.l    Solid_FBZ1
                dc.l    Solid_FBZ2
                dc.l    Solid_ICZ1
                dc.l    Solid_ICZ2
                dc.l    Solid_LBZ1
                dc.l    Solid_LBZ2
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_ALZ
                dc.l    Solid_BPZ
                dc.l    Solid_BPZ
                dc.l    Solid_DPZ
                dc.l    Solid_DPZ
                dc.l    Solid_CGZ
                dc.l    Solid_CGZ
                dc.l    Solid_EMZ
                dc.l    Solid_EMZ
                dc.l    Solid_Gumball_Special
                dc.l    Solid_Gumball_Special
                dc.l    Solid_Pachinko_Special
                dc.l    Solid_Pachinko_Special
                dc.l    Solid_Slots_Special
                dc.l    Solid_Slots_Special
                dc.l    Solid_Slots_Special
                dc.l    Solid_Slots_Special
                dc.l    Solid_Slots_Special
                dc.l    Solid_Slots_Special
Solid_AIZ1:
                binclude "data/Levels/AIZ/Collision/1.bin"
                even
Solid_AIZ2:
                binclude "data/Levels/AIZ/Collision/2.bin"
                even
Solid_HCZ1:
                binclude "data/Levels/HCZ/Collision/1.bin"
                even
Solid_HCZ2:
                binclude "data/Levels/HCZ/Collision/2.bin"
                even
Solid_MGZ1:
                binclude "data/Levels/MGZ/Collision/1.bin"
                even
Solid_MGZ2:
                binclude "data/Levels/MGZ/Collision/2.bin"
                even
Solid_CNZ:
                binclude "data/Levels/CNZ/Collision/1.bin"
                even
Solid_FBZ1:
Solid_FBZ2:
Solid_ICZ1:

                binclude "data/Levels/ICZ/Collision/1.bin"
                even
Solid_ICZ2:
                binclude "data/Levels/ICZ/Collision/2.bin"
                even
Solid_LBZ1:
                binclude "data/Levels/LBZ/Collision/1.bin"
                even
Solid_LBZ2:
                binclude "data/Levels/LBZ/Collision/2.bin"
                even
Solid_ALZ:
                binclude "data/Levels/ALZ/Collision/1.bin"
                even
Solid_BPZ:
                binclude "data/Levels/BPZ/Collision/1.bin"
                even
Solid_DPZ:
                binclude "data/Levels/DPZ/Collision/1.bin"
                even
Solid_CGZ:
                binclude "data/Levels/CGZ/Collision/1.bin"
                even
Solid_EMZ:
                binclude "data/Levels/EMZ/Collision/1.bin"
                even
Solid_Gumball_Special:
                binclude "data/Levels/Gumball/Collision/1.bin"
                even
Solid_Pachinko_Special:
Solid_Slots_Special:
LevelPtrs:
                dc.l    Layout_AIZ1
                dc.l    Layout_AIZ2
                dc.l    Layout_HCZ1
                dc.l    Layout_HCZ2
                dc.l    Layout_MGZ1
                dc.l    Layout_MGZ2
                dc.l    Layout_CNZ1
                dc.l    Layout_CNZ2
                dc.l    Layout_FBZ1
                dc.l    Layout_FBZ2
                dc.l    Layout_ICZ1
                dc.l    Layout_ICZ2
                dc.l    Layout_LBZ1
                dc.l    Layout_LBZ2
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_ALZ
                dc.l    Layout_BPZ
                dc.l    Layout_BPZ
                dc.l    Layout_DPZ
                dc.l    Layout_DPZ
                dc.l    Layout_CGZ
                dc.l    Layout_CGZ
                dc.l    Layout_EMZ
                dc.l    Layout_EMZ
                dc.l    Layout_Gumball_Special
                dc.l    Layout_Gumball_Special
                dc.l    Layout_Pachinko_Special
                dc.l    Layout_Pachinko_Special
                dc.l    Layout_Slot_Special
                dc.l    Layout_Slot_Special
                dc.l    Layout_Slot_Special
                dc.l    Layout_Slot_Special
                dc.l    Layout_Slot_Special
                dc.l    Layout_Slot_Special
Layout_AIZ1:
                binclude "data/Levels/AIZ/Layout/1.bin"
                even
Layout_AIZ2:
                binclude "data/Levels/AIZ/Layout/2.bin"
                even
Layout_HCZ1:
                binclude "data/Levels/HCZ/Layout/1.bin"
                even
Layout_HCZ2:
                binclude "data/Levels/HCZ/Layout/2.bin"
                even
Layout_MGZ1:
                binclude "data/Levels/MGZ/Layout/1.bin"
                even
Layout_MGZ2:
                binclude "data/Levels/MGZ/Layout/2.bin"
                even
Layout_CNZ1:
                binclude "data/Levels/CNZ/Layout/1.bin"
                even
Layout_CNZ2:
                binclude "data/Levels/CNZ/Layout/2.bin"
                even
Layout_FBZ1:
Layout_FBZ2:
Layout_ICZ1:
                binclude "data/Levels/ICZ/Layout/1.bin"
                even
Layout_ICZ2:
                binclude "data/Levels/ICZ/Layout/2.bin"
                even
Layout_LBZ1:
                binclude "data/Levels/LBZ/Layout/1.bin"
                even
Layout_LBZ2:
                binclude "data/Levels/LBZ/Layout/2.bin"
                even
Layout_ALZ:
                binclude "data/Levels/ALZ/Layout/1.bin"
                even
Layout_BPZ:
                binclude "data/Levels/BPZ/Layout/1.bin"
                even
Layout_DPZ:
                binclude "data/Levels/DPZ/Layout/1.bin"
                even
Layout_CGZ:
                binclude "data/Levels/CGZ/Layout/1.bin"
                even
Layout_EMZ:
                binclude "data/Levels/EMZ/Layout/1.bin"
                even
Layout_Gumball_Special:
                binclude "data/Levels/Gumball/Layout/1.bin"
                even
Layout_Pachinko_Special:
                binclude "data/Levels/Pachinko/Layout/1-S3.bin"
                even
Layout_Slot_Special:
                binclude "data/Levels/Slots/Layout/1-S3.bin"
                even
PalPoint:
                include "src/rendering/shared/palettes/palette_pointers_s3.s"

Pal_S2Sega:
                binclude "data/General/S2Menu/Palettes/Sega Screen.bin"
                even
Pal_S2Title:
                binclude "data/General/S2Menu/Palettes/Title Screen.bin"
                even
Pal_S2LevSel:
                binclude "data/General/S2Menu/Palettes/Proto Level Select.bin"
                even
Pal_SonicTails:
                binclude "data/General/Sprites/Sonic/Palettes/SonicAndTails.bin"
                even
Pal_S2Menu:
                binclude "data/General/S2Menu/Palettes/Main.bin"
                even
Pal_Knuckles:
                binclude "data/General/Sprites/Knuckles/Palettes/Main.bin"
                even
Pal_AIZIntro:
                binclude "data/Levels/AIZ/Palettes/Intro.bin"
                even
Pal_AIZ:
                binclude "data/Levels/AIZ/Palettes/Main.bin"
                even
Pal_AIZFire:
                binclude "data/Levels/AIZ/Palettes/Fire.bin"
                even
Pal_AIZBoss:
                binclude "data/Levels/AIZ/Palettes/Boss.bin"
                even
Pal_AIZ_Water:
                binclude "data/Levels/AIZ/Palettes/Water.bin"
                even
Pal_AIZ2_Water:
                binclude "data/Levels/AIZ/Palettes/Act 2 Water.bin"
                even
Pal_HCZ1:
                binclude "data/Levels/HCZ/Palettes/1.bin"
                even
Pal_HCZ2:
                binclude "data/Levels/HCZ/Palettes/2.bin"
                even
Pal_HCZ1_Water:
                binclude "data/Levels/HCZ/Palettes/Act 1 Water.bin"
                even
Pal_HCZ2_Water:
                binclude "data/Levels/HCZ/Palettes/Act 2 Water.bin"
                even
Pal_MGZ:
                binclude "data/Levels/MGZ/Palettes/Main.bin"
                even
Pal_CNZ:
                binclude "data/Levels/CNZ/Palettes/Main.bin"
                even
Pal_CNZ_Water:
                binclude "data/Levels/CNZ/Palettes/Water.bin"
                even
Pal_FBZ:
Pal_ICZ1:
                binclude "data/Levels/ICZ/Palettes/1.bin"
                even
Pal_ICZ2:
                binclude "data/Levels/ICZ/Palettes/2.bin"
                even
Pal_ICZ2_Water:
                binclude "data/Levels/ICZ/Palettes/Act 2 Water.bin"
                even
Pal_LBZ1:
                binclude "data/Levels/LBZ/Palettes/1.bin"
                even
Pal_LBZ2:
                binclude "data/Levels/LBZ/Palettes/2.bin"
                even
Pal_LBZ_Water:
                binclude "data/Levels/LBZ/Palettes/Act 2 Water.bin"
                even
Pal_LBZ_Water2:
                binclude "data/Levels/LBZ/Palettes/Act 2 Water 2.bin"
                even
Pal_ALZ:
                binclude "data/Levels/ALZ/Palettes/Main.bin"
                even
Pal_BPZ:
                binclude "data/Levels/BPZ/Palettes/Main.bin"
                even
Pal_DPZ:
                binclude "data/Levels/DPZ/Palettes/Main.bin"
                even
Pal_CGZ:
                binclude "data/Levels/CGZ/Palettes/Main.bin"
                even
Pal_EMZ:
                binclude "data/Levels/EMZ/Palettes/Main.bin"
                even
Pal_Gumball_Special:
                binclude "data/Levels/Gumball/Palettes/Main.bin"
                even
Pal_Pachinko_Special:
                binclude "data/Levels/Pachinko/Palettes/S3.bin"
                even
Pal_Slot_Special:
                binclude "data/Levels/Slots/Palettes/S3.bin"
                even
ArtUnc_CNZCannon:
                binclude "data/Levels/CNZ/Uncompressed Art/Cannon.unc"
                even
ArtUnc_AirCountdown:
                binclude "data/General/Sprites/Bubbles/Air Countdown.unc"
                even
ArtUnc_SONICMILES:
                binclude "data/General/S2Menu/Uncompressed Art/SONICMILES.unc"
                even
ArtUnc_SStageSonic:
                binclude "data/General/Sprites/Sonic/Art/SStage Sonic.unc"
                even
Map_SStageSonic:
                include "src/objects/shared/sonic/map_sstage_sonic.s"
ArtUnc_SStageTails:
                binclude "data/General/Sprites/Tails/Art/SStage Tails.unc"
                even
Map_SStageTails:
                include "src/objects/shared/tails/map_sstage_tails.s"
ArtUnc_SStageTailstails:
                binclude "data/General/Sprites/Tails/Art/SStage Tails tails.unc"
                even
Map_SStageTailstails:
                include "src/objects/shared/tails/map_sstage_tails_tails.s"
ArtNem_SphereTest:
                binclude "data/General/Special Stage/Nemesis Art/Eosian Spheres.nem"
                even
ArtNem_SStageShadow:
                binclude "data/General/Special Stage/Nemesis Art/Shadow.nem"
                even
ArtNem_GetBlueSpheres:
                binclude "data/General/Special Stage/Nemesis Art/Get Blue Spheres.nem"
                even
ArtNem_GBSArrow:
                binclude "data/General/Special Stage/Nemesis Art/Get Blue Spheres Arrow.nem"
                even
ArtNem_SStageDigits:
                binclude "data/General/Special Stage/Nemesis Art/Digits.nem"
                even
ArtNem_SStageIcons:
                binclude "data/General/Special Stage/Nemesis Art/Icons.nem"
                even
ArtNem_SStageSphere:
                binclude "data/General/Special Stage/Nemesis Art/Sphere.nem"
                even
ArtNem_SStageRing:
                binclude "data/General/Special Stage/Nemesis Art/Ring.nem"
                even
ArtKosM_SStageChaosEmerald:
                binclude "data/General/Special Stage/KosinskiM Art/Special Stage Chaos Emerald.kosm"
                even
MapEni_SStageBG:
                binclude "data/General/Special Stage/Enigma Map/BG.eni"
                even
ArtNem_SStageBG:
                binclude "data/General/Special Stage/Nemesis Art/BG.nem"
                even
MapUnc_SStageLayout:
                binclude "data/General/Special Stage/Uncompressed Map/Layout S3.bin"
                even
ArtNem_SStageLayout:
                binclude "data/General/Special Stage/Nemesis Art/Layout.nem"
                even
SStage_PerspectiveMapPtrs:
                dc.l    SStage_PerspectiveMaps
                dc.l    SStage_PerspectiveMaps+$5A0
                dc.l    SStage_PerspectiveMaps+$B40
                dc.l    SStage_PerspectiveMaps+$10E0
                dc.l    SStage_PerspectiveMaps+$1680
                dc.l    SStage_PerspectiveMaps+$1C20
                dc.l    SStage_PerspectiveMaps+$21C0
                dc.l    SStage_PerspectiveMaps+$2760
                dc.l    SStage_PerspectiveMaps
                dc.l    SStage_PerspectiveMaps+$5A0
                dc.l    SStage_PerspectiveMaps+$B40
                dc.l    SStage_PerspectiveMaps+$10E0
                dc.l    SStage_PerspectiveMaps+$1680
                dc.l    SStage_PerspectiveMaps+$1C20
                dc.l    SStage_PerspectiveMaps+$21C0
                dc.l    SStage_PerspectiveMaps+$2760
                dc.l    SStage_PerspectiveMaps+$2D00
                dc.l    SStage_PerspectiveMaps+$32A0
                dc.l    SStage_PerspectiveMaps+$3840
                dc.l    SStage_PerspectiveMaps+$3DE0
                dc.l    SStage_PerspectiveMaps+$4380
                dc.l    SStage_PerspectiveMaps+$4920
                dc.l    SStage_PerspectiveMaps+$4EC0
SStage_PerspectiveMaps:
                binclude "data/General/Special Stage/Layout/S3 Perspective Maps.bin"
                even
Map_Sonic2P:
                include "src/objects/shared/sonic/map_sonic_2p.s"
PLC_Sonic2P:
                include "src/objects/shared/sonic/dplc_sonic_2p.s"
Map_Tails2P:
                include "src/objects/shared/tails/map_tails_2p.s"
Map_Tails2P_Tail:
                include "src/objects/shared/tails/map_tails_tail_2p.s"
PLC_Tails2P:
                include "src/objects/shared/tails/dplc_tails_2p.s"
DPLC_Tails2P_Tail:
                include "src/objects/shared/tails/dplc_tails_tails_2p.s"
Map_Knuckles2P:
                include "src/objects/shared/knuckles/map_knuckles_2p.s"
PLC_Knuckles2P:
                include "src/objects/shared/knuckles/dplc_knuckles_2p.s"
ArtUnc_SurfboardIntro:
                binclude "data/General/Sprites/Sonic/Art/Sonic Surfboarding.unc"
                align0  $20
ArtUnc_AniAIZ1_0:
                binclude "data/Levels/AIZ/Animated Tiles/Act1 0.unc"
                even
ArtUnc_AniAIZ1_1:
                binclude "data/Levels/AIZ/Animated Tiles/Act1 1.unc"
                even
ArtUnc_AniAIZ2_1:
                binclude "data/Levels/AIZ/Animated Tiles/Act2 1.unc"
                even
ArtUnc_AniAIZ2_0:
                binclude "data/Levels/AIZ/Animated Tiles/Act2 0.unc"
                even
ArtUnc_AniAIZ2_3:
                binclude "data/Levels/AIZ/Animated Tiles/Act2 3.unc"
                even
ArtUnc_AniAIZ2_2:
                binclude "data/Levels/AIZ/Animated Tiles/Act2 2.unc"
                even
ArtUnc_AniAIZ2_FirstTree:
                binclude "data/Levels/AIZ/Animated Tiles/Act2 First Tree.unc"
                even
ArtUnc_AniHCZ1_0:
                binclude "data/Levels/HCZ/Animated Tiles/Act1 0.unc"
                even
ArtUnc_AniHCZ1_WaterlineBelow:
                binclude "data/Levels/HCZ/Animated Tiles/Act1 Water Below 1.unc"
                even
ArtUnc_FixHCZ1_UpperBG1:
                binclude "data/Levels/HCZ/Animated Tiles/Act1 Upper BG 1.unc"
                even
ArtUnc_AniHCZ1_WaterlineAbove:
                binclude "data/Levels/HCZ/Animated Tiles/Act1 Water Above 1.unc"
                even
ArtUnc_FixHCZ1_LowerBG1:
                binclude "data/Levels/HCZ/Animated Tiles/Act1 Lower BG 1.unc"
                even
ArtUnc_AniHCZ1_WaterlineBelow2:
                binclude "data/Levels/HCZ/Animated Tiles/Act1 Water Below 2.unc"
                even
ArtUnc_FixHCZ1_UpperBG2:
                binclude "data/Levels/HCZ/Animated Tiles/Act1 Upper BG 2.unc"
                even
ArtUnc_AniHCZ1_WaterlineAbove2:
                binclude "data/Levels/HCZ/Animated Tiles/Act1 Water Above 2.unc"
                even
ArtUnc_FixHCZ1_LowerBG2:
                binclude "data/Levels/HCZ/Animated Tiles/Act1 Lower BG 2.unc"
                even
ArtUnc_AniHCZ__1:
                binclude "data/Levels/HCZ/Animated Tiles/0.unc"
                even
ArtUnc_AniHCZ2_0:
                binclude "data/Levels/HCZ/Animated Tiles/Act2 0.unc"
                even
ArtUnc_AniHCZ2_SmallBGLine:
                binclude "data/Levels/HCZ/Animated Tiles/Act2 1.unc"
                even
ArtUnc_AniHCZ2_2:
                binclude "data/Levels/HCZ/Animated Tiles/Act2 2.unc"
                even
ArtUnc_AniHCZ2_3:
                binclude "data/Levels/HCZ/Animated Tiles/Act2 3.unc"
                even
ArtUnc_AniHCZ2_4:
                binclude "data/Levels/HCZ/Animated Tiles/Act2 4.unc"
                even
ArtUnc_AniMGZ__0:
                binclude "data/Levels/MGZ/Animated Tiles/MGZ Animated 0.unc"
                even
ArtUnc_AniMGZ__1:
                binclude "data/Levels/MGZ/Animated Tiles/MGZ Animated 1.unc"
                even
ArtUnc_AniCNZ__0:
                binclude "data/Levels/CNZ/Animated Tiles/0.unc"
                even
ArtUnc_AniCNZ__1:
                binclude "data/Levels/CNZ/Animated Tiles/1.unc"
                even
ArtUnc_AniCNZ__2:
                binclude "data/Levels/CNZ/Animated Tiles/2.unc"
                even
ArtUnc_AniCNZ__3:
                binclude "data/Levels/CNZ/Animated Tiles/3.unc"
                even
ArtUnc_AniCNZ__4:
                binclude "data/Levels/CNZ/Animated Tiles/4.unc"
                even
ArtUnc_AniCNZ__6:
                binclude "data/Levels/CNZ/Animated Tiles/6.unc"
                even
ArtUnc_AniCNZ__5:
                binclude "data/Levels/CNZ/Animated Tiles/5.unc"
                even
ArtUnc_AniICZ__1:
                binclude "data/Levels/ICZ/Animated Tiles/1.unc"
                even
ArtUnc_AniICZ__2:
                binclude "data/Levels/ICZ/Animated Tiles/2.unc"
                even
ArtUnc_AniICZ__3:
                binclude "data/Levels/ICZ/Animated Tiles/3.unc"
                even
ArtUnc_AniICZ__4:
                binclude "data/Levels/ICZ/Animated Tiles/4.unc"
                even
ArtUnc_AniICZ__5:
                binclude "data/Levels/ICZ/Animated Tiles/5.unc"
                even
ArtUnc_AniICZ__0:
                binclude "data/Levels/ICZ/Animated Tiles/0.unc"
                even
ArtUnc_AniLBZ1_0:
                binclude "data/Levels/LBZ/Animated Tiles/Act1 0.unc"
                even
ArtUnc_AniLBZ1_1:
                binclude "data/Levels/LBZ/Animated Tiles/Act1 1.unc"
                even
ArtUnc_AniLBZ1_2:
                binclude "data/Levels/LBZ/Animated Tiles/Act1 2.unc"
                even
ArtUnc_AniLBZ2_2:
                binclude "data/Levels/LBZ/Animated Tiles/Act2 2.unc"
                even
ArtUnc_AniLBZ2_WaterlineBelow:
                binclude "data/Levels/LBZ/Animated Tiles/Act2 Water Below.unc"
                even
ArtUnc_AniLBZ2_LowerBG:
                binclude "data/Levels/LBZ/Animated Tiles/Act2 Lower BG.unc"
                even
ArtUnc_AniLBZ2_WaterlineAbove:
                binclude "data/Levels/LBZ/Animated Tiles/Act2 Water Above.unc"
                even
ArtUnc_AniLBZ2_UpperBG:
                binclude "data/Levels/LBZ/Animated Tiles/Act2 Upper BG.unc"
                even
ArtUnc_AniLBZ__0:
                binclude "data/Levels/LBZ/Animated Tiles/0.unc"
                even
ArtUnc_AniLBZ2_0:
                binclude "data/Levels/LBZ/Animated Tiles/Act2 0.unc"
                even
ArtUnc_AniLBZ2_1:
                binclude "data/Levels/LBZ/Animated Tiles/Act2 1.unc"
                even
ArtUnc_AniLRZ__BG:
ArtUnc_AniLRZ__BG2:
ArtUnc_AniALZ:
                binclude "data/Levels/ALZ/Animated Tiles/0.unc"
                even
ArtUnc_AniBPZ__0:
                binclude "data/Levels/BPZ/Animated Tiles/0.unc"
                even
ArtUnc_AniBPZ__1:
                binclude "data/Levels/BPZ/Animated Tiles/1.unc"
                even
ArtUnc_AniBPZ__2:
                binclude "data/Levels/BPZ/Animated Tiles/2.unc"
                even
ArtUnc_AniBPZ__3:
                binclude "data/Levels/BPZ/Animated Tiles/3.unc"
                even
ArtUnc_AniDPZ:
                binclude "data/Levels/DPZ/Animated Tiles/0.unc"
                even
ArtUnc_AniDPZ__BG:
                binclude "data/Levels/DPZ/Animated Tiles/BG 0.unc"
                even
ArtUnc_AniGumball:
                binclude "data/Levels/Gumball/Animated Tiles/0.unc"
                even
ArtUnc_SplashDrown:
                binclude "data/General/Sprites/Dash Dust/Splash Drown.unc"
                even
ArtNem_S22POptions:
                binclude "data/General/S2Menu/Nemesis Art/2P Options.nem"
                even
ArtNem_1P2PWins:
                binclude "data/General/S2Menu/Nemesis Art/1P 2P Wins.nem"
                even
MapEni_S22POptions:
                binclude "data/General/S2Menu/Enigma Map/2P Options.eni"
                even
ArtNem_S2MenuBox:
                binclude "data/General/S2Menu/Nemesis Art/Menu Box.nem"
                even
ArtNem_S2LevelSelectPics:
                binclude "data/General/S2Menu/Nemesis Art/Level Select Icons.nem"
                even
ArtNem_Title_SonicSprites:
                binclude "data/General/Title/Nemesis Art/S3 Sonic Sprites.nem"
                even
DemoDat_AIZ:
                binclude "data/Levels/AIZ/Demodata/1.bin"
                even
DemoDat_HCZ:
                binclude "data/Levels/HCZ/Demodata/1.bin"
                even
DemoDat_MGZ:
                binclude "data/Levels/MGZ/Demodata/1.bin"
                even

; ===========================================================================
; Music Banks
; ===========================================================================
                cnop    -Size_of_Snd_Bank1, $8000       ; aligned to end of bank

; ---------------------------------------------------------------------------
; Music Bank 1
; ---------------------------------------------------------------------------
Snd_Bank1_Start:
Snd_Minib:      binclude "data/Sound/SMPS/s3/Music/Miniboss (Sonic 3).bin"
Snd_FinalBoss:  binclude "data/Sound/SMPS/s3/Music/Final Boss.bin"
Snd_Bank1_End:

                if      Snd_Bank1_End - Snd_Bank1_Start > $8000
                fatal   "Snd_Bank1_Start must fit within $8000 bytes, but was $\{Snd_Bank1_End-Snd_Bank1_Start }. Try moving something to the other bank."
                endif
                if      Snd_Bank1_End - Snd_Bank1_Start > Size_of_Snd_Bank1
                fatal   "Size_of_Snd_Bank1 = $\{Size_of_Snd_Bank1}, but you have $\{Snd_Bank1_End-Snd_Bank1_Start} bytes of music."
                endif

; ---------------------------------------------------------------------------
; Music Bank 2
; ---------------------------------------------------------------------------
Snd_Bank2_Start:    startBank
Snd_AIZ1:           binclude "data/Sound/SMPS/s3/Music/AIZ1.bin"
Snd_AIZ2:           binclude "data/Sound/SMPS/s3/Music/AIZ2.bin"
Snd_HCZ1:           binclude "data/Sound/SMPS/s3/Music/HCZ1.bin"
Snd_HCZ2:           binclude "data/Sound/SMPS/s3/Music/HCZ2.bin"
Snd_MGZ1:           binclude "data/Sound/SMPS/s3/Music/MGZ1.bin"
Snd_MGZ2:           binclude "data/Sound/SMPS/s3/Music/MGZ2.bin"
Snd_CNZ2:           binclude "data/Sound/SMPS/s3/Music/CNZ2.bin"
Snd_CNZ1:           binclude "data/Sound/SMPS/s3/Music/CNZ1.bin"
Snd_FBZ1:           binclude "data/Sound/SMPS/s3/Music/FBZ1 (Sonic 3).bin"
Snd_FBZ2:           binclude "data/Sound/SMPS/s3/Music/FBZ2.bin"
Snd_DDZ:            binclude "data/Sound/SMPS/s3/Music/DDZ.bin"

                finishBank

; ---------------------------------------------------------------------------
; Music Bank 3
; ---------------------------------------------------------------------------
Snd_Bank3_Start:    startBank
Snd_ICZ2:           binclude "data/Sound/SMPS/s3/Music/ICZ2.bin"
Snd_ICZ1:           binclude "data/Sound/SMPS/s3/Music/ICZ1.bin"
Snd_LBZ2:           binclude "data/Sound/SMPS/s3/Music/LBZ2.bin"
Snd_LBZ1:           binclude "data/Sound/SMPS/s3/Music/LBZ1.bin"
Snd_MHZ1:           binclude "data/Sound/SMPS/s3/Music/MHZ1.bin"
Snd_MHZ2:           binclude "data/Sound/SMPS/s3/Music/MHZ2.bin"
Snd_SOZ1:           binclude "data/Sound/SMPS/s3/Music/SOZ1.bin"
Snd_SOZ2:           binclude "data/Sound/SMPS/s3/Music/SOZ2.bin"
Snd_LRZ1:           binclude "data/Sound/SMPS/s3/Music/LRZ1.bin"
Snd_LRZ2:           binclude "data/Sound/SMPS/s3/Music/LRZ2.bin"
Snd_SSZ:            binclude "data/Sound/SMPS/s3/Music/SSZ (Sonic 3).bin"
Snd_DEZ1:           binclude "data/Sound/SMPS/s3/Music/DEZ1.bin"
Snd_DEZ2:           binclude "data/Sound/SMPS/s3/Music/DEZ2.bin"
Snd_Minib_SK:       binclude "data/Sound/SMPS/s3/Music/Miniboss (Sonic & Knuckles).bin"
Snd_Boss:           binclude "data/Sound/SMPS/s3/Music/Zone Boss.bin"
Snd_PachBonus:      binclude "data/Sound/SMPS/s3/Music/Pachinko.bin"
Snd_SpecialS:       binclude "data/Sound/SMPS/s3/Music/Special Stage.bin"
Snd_Results:        binclude "data/Sound/SMPS/s3/Music/Level Outro.bin"
Snd_Menu:           binclude "data/Sound/SMPS/s3/Music/Menu (Sonic 3).bin"

                finishBank

; ---------------------------------------------------------------------------
; Music Bank 4
; ---------------------------------------------------------------------------
Snd_Bank4_Start:    startBank
Snd_SlotBonus:      binclude "data/Sound/SMPS/s3/Music/Slots.bin"
Snd_GumBonus:       binclude "data/Sound/SMPS/s3/Music/Gum Ball Machine.bin"
Snd_Knux:           binclude "data/Sound/SMPS/s3/Music/Knuckles (Sonic 3).bin"
Snd_ALZ:            binclude "data/Sound/SMPS/s3/Music/Azure Lake.bin"
Snd_BPZ:            binclude "data/Sound/SMPS/s3/Music/Balloon Park.bin"
Snd_DPZ:            binclude "data/Sound/SMPS/s3/Music/Desert Palace.bin"
Snd_CGZ:            binclude "data/Sound/SMPS/s3/Music/Chrome Gadget.bin"
Snd_EMZ:            binclude "data/Sound/SMPS/s3/Music/Endless Mine.bin"
Snd_Title:          binclude "data/Sound/SMPS/s3/Music/Title (Sonic 3).bin"
Snd_S3Credits:      binclude "data/Sound/SMPS/s3/Music/Credits (Sonic 3).bin"
Snd_GameOver:       binclude "data/Sound/SMPS/s3/Music/Game Over.bin"
Snd_Continue:       binclude "data/Sound/SMPS/s3/Music/Continue (Sonic 3).bin"
Snd_1UP:            binclude "data/Sound/SMPS/s3/Music/1UP (Sonic 3).bin"
Snd_Emerald:        binclude "data/Sound/SMPS/s3/Music/Chaos Emerald.bin"
Snd_Invic:          binclude "data/Sound/SMPS/s3/Music/Invincible (Sonic 3).bin"
Snd_2PMenu:         binclude "data/Sound/SMPS/s3/Music/Competition Menu.bin"
Snd_Drown:          binclude "data/Sound/SMPS/s3/Music/Countdown.bin"
Snd_PresSega:       binclude "data/Sound/SMPS/s3/Music/Game Complete (Sonic 3).bin"

                finishBank

; ---------------------------------------------------------------------------
; ===========================================================================
; DAC Banks
; ===========================================================================
; DAC Bank 1
; ---------------------------------------------------------------------------
DacBank1:       startDACBank

DAC_86_Data:            include "Sound/DAC/metadata/86.inc"
DAC_81_Data:            include "Sound/DAC/metadata/81.inc"
DAC_82_83_84_85_Data:   include "Sound/DAC/metadata/82-85.inc"
DAC_94_95_96_97_Data:   include "Sound/DAC/metadata/94-97.inc"
DAC_90_91_92_93_Data:   include "Sound/DAC/metadata/90-93.inc"
DAC_88_Data:            include "Sound/DAC/metadata/88.inc"
DAC_8A_8B_Data:         include "Sound/DAC/metadata/8A-8B.inc"
DAC_8C_Data:            include "Sound/DAC/metadata/8C.inc"
DAC_8D_8E_Data:         include "Sound/DAC/metadata/8D-8E.inc"
DAC_87_Data:            include "Sound/DAC/metadata/87.inc"
DAC_8F_Data:            include "Sound/DAC/metadata/8F.inc"
DAC_89_Data:            include "Sound/DAC/metadata/89.inc"
DAC_98_99_9A_Data:      include "Sound/DAC/metadata/98-9A.inc"

                finishBank

                align   $1000

                include "Sound/Z80 Sound Driver.s"

; ---------------------------------------------------------------------------
; Dac Bank 2
; ---------------------------------------------------------------------------
DacBank2:       startDACBank

DAC_9B_Data:    include "Sound/DAC/metadata/9B.inc"
DAC_9C_Data:    include "Sound/DAC/metadata/9C.inc"
DAC_9D_Data:    include "Sound/DAC/metadata/9D.inc"
DAC_9E_Data:    include "Sound/DAC/metadata/9E.inc"
DAC_9F_Data:    include "Sound/DAC/metadata/9F.inc"
DAC_A0_Data:    include "Sound/DAC/metadata/A0.inc"
DAC_A1_Data:    include "Sound/DAC/metadata/A1.inc"
DAC_A2_Data:    include "Sound/DAC/metadata/A2.inc"
DAC_A3_Data:    include "Sound/DAC/metadata/A3.inc"
DAC_A4_Data:    include "Sound/DAC/metadata/A4.inc"
DAC_A5_Data:    include "Sound/DAC/metadata/A5.inc"
DAC_A6_Data:    include "Sound/DAC/metadata/A6.inc"
DAC_A7_Data:    include "Sound/DAC/metadata/A7.inc"
DAC_A8_Data:    include "Sound/DAC/metadata/A8.inc"
DAC_A9_Data:    include "Sound/DAC/metadata/A9.inc"
DAC_AA_Data:    include "Sound/DAC/metadata/AA.inc"

                finishBank

; ---------------------------------------------------------------------------
; Dac Bank 3
; ---------------------------------------------------------------------------
DacBank3:       startDACBank

DAC_AB_Data:                include "Sound/DAC/metadata/AB.inc"
DAC_AC_Data:                include "Sound/DAC/metadata/AC.inc"
DAC_AD_AE_Data:             include "Sound/DAC/metadata/AD-AE.inc"
DAC_AF_B0_Data:             include "Sound/DAC/metadata/AF-B0.inc"
DAC_Unused_Data:            include "Sound/DAC/metadata/Unused.inc"
DAC_B1_Data:                include "Sound/DAC/metadata/B1.inc"
DAC_B2_B3_Data:             include "Sound/DAC/metadata/B2-B3 (Sonic 3).inc"
DAC_B4_C1_C2_C3_C4_Data:    include "Sound/DAC/metadata/B4C1-C4.inc"
DAC_B5_Data:                include "Sound/DAC/metadata/B5.inc"
DAC_B6_Data:                include "Sound/DAC/metadata/B6.inc"
DAC_B7_Data:                include "Sound/DAC/metadata/B7.inc"
DAC_B8_B9_Data:             include "Sound/DAC/metadata/B8-B9.inc"
DAC_BA_Data:                include "Sound/DAC/metadata/BA.inc"
DAC_BB_Data:                include "Sound/DAC/metadata/BB.inc"
DAC_BC_Data:                include "Sound/DAC/metadata/BC.inc"
DAC_BD_Data:                include "Sound/DAC/metadata/BD.inc"
DAC_BE_Data:                include "Sound/DAC/metadata/BE.inc"
DAC_BF_Data:                include "Sound/DAC/metadata/BF.inc"
DAC_C0_Data:                include "Sound/DAC/metadata/C0.inc"

                finishBank

; ===========================================================================
; Sound Bank
; ===========================================================================
SndBank:        startBank

SEGA_PCM:       include "Sound/PCM/metadata/Sega.inc"

                align   2
Sound_33:       binclude "data/Sound/SMPS/s3/SFX/33 - Ring (Right).bin"
Sound_34:       binclude "data/Sound/SMPS/s3/SFX/34 - Ring (Left).bin"
Sound_35:       binclude "data/Sound/SMPS/s3/SFX/35 - Death.bin"
Sound_36:       binclude "data/Sound/SMPS/s3/SFX/36 - Skid.bin"
Sound_37:       binclude "data/Sound/SMPS/s3/SFX/37 - Spike Hit.bin"
Sound_38:       binclude "data/Sound/SMPS/s3/SFX/38 - Bubble.bin"
Sound_39:       binclude "data/Sound/SMPS/s3/SFX/39 - Splash.bin"
Sound_3A:       binclude "data/Sound/SMPS/s3/SFX/3A - Shield.bin"
Sound_3B:       binclude "data/Sound/SMPS/s3/SFX/3B - Drown.bin"
Sound_3C:       binclude "data/Sound/SMPS/s3/SFX/3C - Roll.bin"
Sound_3D:       binclude "data/Sound/SMPS/s3/SFX/3D - Break.bin"
Sound_3E:       binclude "data/Sound/SMPS/s3/SFX/3E - Fire Shield.bin"
Sound_3F:       binclude "data/Sound/SMPS/s3/SFX/3F - Bubble Shield.bin"
Sound_40:       binclude "data/Sound/SMPS/s3/SFX/40 - Unknown Shield.bin"
Sound_41:       binclude "data/Sound/SMPS/s3/SFX/41 - Lightning Shield.bin"
Sound_42:       binclude "data/Sound/SMPS/s3/SFX/42 - Insta Shield Attack.bin"
Sound_43:       binclude "data/Sound/SMPS/s3/SFX/43 - Fire Shield Attack.bin"
Sound_44:       binclude "data/Sound/SMPS/s3/SFX/44 - Bubble Shield Attack.bin"
Sound_45:       binclude "data/Sound/SMPS/s3/SFX/45 - Lightning Shield Attack.bin"
Sound_46:       binclude "data/Sound/SMPS/s3/SFX/46 - Whistle.bin"
Sound_47:       binclude "data/Sound/SMPS/s3/SFX/47 - Sand Wall Rise.bin"
Sound_48:       binclude "data/Sound/SMPS/s3/SFX/48 - Blast.bin"
Sound_49:       binclude "data/Sound/SMPS/s3/SFX/49 - Thump.bin"
Sound_4A:       binclude "data/Sound/SMPS/s3/SFX/4A - Grab.bin"
Sound_4B:       binclude "data/Sound/SMPS/s3/SFX/4B - Waterfall Splash.bin"
Sound_4C:       binclude "data/Sound/SMPS/s3/SFX/4C - Glide Land.bin"
Sound_4D:       binclude "data/Sound/SMPS/s3/SFX/4D - Projectile.bin"
Sound_4E:       binclude "data/Sound/SMPS/s3/SFX/4E - Missile Explode.bin"
Sound_4F:       binclude "data/Sound/SMPS/s3/SFX/4F - Flamethrower (Quiet).bin"
Sound_50:       binclude "data/Sound/SMPS/s3/SFX/50 - Boss Activate.bin"
Sound_51:       binclude "data/Sound/SMPS/s3/SFX/51 - Missile Throw.bin"
Sound_52:       binclude "data/Sound/SMPS/s3/SFX/52 - Spike Move.bin"
Sound_53:       binclude "data/Sound/SMPS/s3/SFX/53 - Charging.bin"
Sound_54:       binclude "data/Sound/SMPS/s3/SFX/54 - Boss Laser.bin"
Sound_55:       binclude "data/Sound/SMPS/s3/SFX/55 - Block Conveyor.bin"
Sound_56:       binclude "data/Sound/SMPS/s3/SFX/56 - Flip Bridge.bin"
Sound_57:       binclude "data/Sound/SMPS/s3/SFX/57 - Geyser.bin"
Sound_58:       binclude "data/Sound/SMPS/s3/SFX/58 - Fan Latch.bin"
Sound_59:       binclude "data/Sound/SMPS/s3/SFX/59 - Collapse.bin"
Sound_5A:       binclude "data/Sound/SMPS/s3/SFX/5A - Unknown Charge.bin"
Sound_5B:       binclude "data/Sound/SMPS/s3/SFX/5B - Switch.bin"
Sound_5C:       binclude "data/Sound/SMPS/s3/SFX/5C - Mecha Spark.bin"
Sound_5D:       binclude "data/Sound/SMPS/s3/SFX/5D - Floor Thump.bin"
Sound_5E:       binclude "data/Sound/SMPS/s3/SFX/5E - Laser.bin"
Sound_5F:       binclude "data/Sound/SMPS/s3/SFX/5F - Crash.bin"
Sound_60:       binclude "data/Sound/SMPS/s3/SFX/60 - Boss Zoom.bin"
Sound_61:       binclude "data/Sound/SMPS/s3/SFX/61 - Boss Hit Floor.bin"
Sound_62:       binclude "data/Sound/SMPS/s3/SFX/62 - Jump.bin"
Sound_63:       binclude "data/Sound/SMPS/s3/SFX/63 - Star Post.bin"
Sound_64:       binclude "data/Sound/SMPS/s3/SFX/64 - Pulley Grab.bin"
Sound_65:       binclude "data/Sound/SMPS/s3/SFX/65 - Blue Sphere.bin"
Sound_66:       binclude "data/Sound/SMPS/s3/SFX/66 - All Spheres Collected.bin"
Sound_67:       binclude "data/Sound/SMPS/s3/SFX/67 - Level Projectile.bin"
Sound_68:       binclude "data/Sound/SMPS/s3/SFX/68 - Perfect.bin"
Sound_69:       binclude "data/Sound/SMPS/s3/SFX/69 - Push Block.bin"
Sound_6A:       binclude "data/Sound/SMPS/s3/SFX/6A - Goal.bin"
Sound_6B:       binclude "data/Sound/SMPS/s3/SFX/6B - Action Block.bin"
Sound_6C:       binclude "data/Sound/SMPS/s3/SFX/6C - Splash 2.bin"
Sound_6D:       binclude "data/Sound/SMPS/s3/SFX/6D - Unknown Shift.bin"
Sound_6E:       binclude "data/Sound/SMPS/s3/SFX/6E - Boss Hit.bin"
Sound_6F:       binclude "data/Sound/SMPS/s3/SFX/6F - Rumble 2.bin"
Sound_70:       binclude "data/Sound/SMPS/s3/SFX/70 - Lava Ball.bin"
Sound_71:       binclude "data/Sound/SMPS/s3/SFX/71 - Shield 2.bin"
Sound_72:       binclude "data/Sound/SMPS/s3/SFX/72 - Hoverpad.bin"
Sound_73:       binclude "data/Sound/SMPS/s3/SFX/73 - Transporter.bin"
Sound_74:       binclude "data/Sound/SMPS/s3/SFX/74 - Tunnel Booster.bin"
Sound_75:       binclude "data/Sound/SMPS/s3/SFX/75 - Balloon Platform.bin"
Sound_76:       binclude "data/Sound/SMPS/s3/SFX/76 - Trap Door.bin"
Sound_77:       binclude "data/Sound/SMPS/s3/SFX/77 - Balloon.bin"
Sound_78:       binclude "data/Sound/SMPS/s3/SFX/78 - Gravity Machine.bin"
Sound_79:       binclude "data/Sound/SMPS/s3/SFX/79 - Lightning.bin"
Sound_7A:       binclude "data/Sound/SMPS/s3/SFX/7A - Boss Magma.bin"
Sound_7B:       binclude "data/Sound/SMPS/s3/SFX/7B - Small Bumpers.bin"
Sound_7C:       binclude "data/Sound/SMPS/s3/SFX/7C - Chain Tension.bin"
Sound_7D:       binclude "data/Sound/SMPS/s3/SFX/7D - Unknown Pump.bin"
Sound_7E:       binclude "data/Sound/SMPS/s3/SFX/7E - Ground Slide.bin"
Sound_7F:       binclude "data/Sound/SMPS/s3/SFX/7F - Frost Puff.bin"
Sound_80:       binclude "data/Sound/SMPS/s3/SFX/80 - Ice Spikes.bin"
Sound_81:       binclude "data/Sound/SMPS/s3/SFX/81 - Tube Launcher.bin"
Sound_82:       binclude "data/Sound/SMPS/s3/SFX/82 - Sand Splash.bin"
Sound_83:       binclude "data/Sound/SMPS/s3/SFX/83 - Bridge Collapse.bin"
Sound_84:       binclude "data/Sound/SMPS/s3/SFX/84 - Unknown Power-Up.bin"
Sound_85:       binclude "data/Sound/SMPS/s3/SFX/85 - Unknown Power-Down.bin"
Sound_86:       binclude "data/Sound/SMPS/s3/SFX/86 - Alarm.bin"
Sound_87:       binclude "data/Sound/SMPS/s3/SFX/87 - Mushroom Bounce.bin"
Sound_88:       binclude "data/Sound/SMPS/s3/SFX/88 - Pulley Move.bin"
Sound_89:       binclude "data/Sound/SMPS/s3/SFX/89 - Weather Machine.bin"
Sound_8A:       binclude "data/Sound/SMPS/s3/SFX/8A - Bouncy.bin"
Sound_8B:       binclude "data/Sound/SMPS/s3/SFX/8B - Chop Tree.bin"
Sound_8C:       binclude "data/Sound/SMPS/s3/SFX/8C - Chop Stuck.bin"
Sound_8D:       binclude "data/Sound/SMPS/s3/SFX/8D - Unknown Flutter.bin"
Sound_8E:       binclude "data/Sound/SMPS/s3/SFX/8E - Unknown Revving.bin"
Sound_8F:       binclude "data/Sound/SMPS/s3/SFX/8F - Door Open.bin"
Sound_90:       binclude "data/Sound/SMPS/s3/SFX/90 - Door Move.bin"
Sound_91:       binclude "data/Sound/SMPS/s3/SFX/91 - Door Close.bin"
Sound_92:       binclude "data/Sound/SMPS/s3/SFX/92 - Ghost Appear.bin"
Sound_93:       binclude "data/Sound/SMPS/s3/SFX/93 - Boss Recovery.bin"
Sound_94:       binclude "data/Sound/SMPS/s3/SFX/94 - Chain Tick.bin"
Sound_95:       binclude "data/Sound/SMPS/s3/SFX/95 - Boss Hand.bin"
Sound_96:       binclude "data/Sound/SMPS/s3/SFX/96 - Mecha Land.bin"
Sound_97:       binclude "data/Sound/SMPS/s3/SFX/97 - Enemy Breath.bin"
Sound_98:       binclude "data/Sound/SMPS/s3/SFX/98 - Boss Projectile.bin"
Sound_99:       binclude "data/Sound/SMPS/s3/SFX/99 - Unknown Plink.bin"
Sound_9A:       binclude "data/Sound/SMPS/s3/SFX/9A - Spring Latch.bin"
Sound_9B:       binclude "data/Sound/SMPS/s3/SFX/9B - Thump Boss (Sonic 3).bin"
Sound_9C:       binclude "data/Sound/SMPS/s3/SFX/9C - Super Emerald.bin"
Sound_9D:       binclude "data/Sound/SMPS/s3/SFX/9D - Targeting.bin"
Sound_9E:       binclude "data/Sound/SMPS/s3/SFX/9E - Clank.bin"
Sound_9F:       binclude "data/Sound/SMPS/s3/SFX/9F - Super Transform.bin"
Sound_A0:       binclude "data/Sound/SMPS/s3/SFX/A0 - Missile Shoot.bin"
Sound_A1:       binclude "data/Sound/SMPS/s3/SFX/A1 - Unknown Ominous.bin"
Sound_A2:       binclude "data/Sound/SMPS/s3/SFX/A2 - Floor Launcher.bin"
Sound_A3:       binclude "data/Sound/SMPS/s3/SFX/A3 - Gravity Lift.bin"
Sound_A4:       binclude "data/Sound/SMPS/s3/SFX/A4 - Mecha Transform.bin"
Sound_A5:       binclude "data/Sound/SMPS/s3/SFX/A5 - Unknown Rise.bin"
Sound_A6:       binclude "data/Sound/SMPS/s3/SFX/A6 - Launch Grab.bin"
Sound_A7:       binclude "data/Sound/SMPS/s3/SFX/A7 - Launch Ready.bin"
Sound_A8:       binclude "data/Sound/SMPS/s3/SFX/A8 - Energy Zap.bin"
Sound_A9:       binclude "data/Sound/SMPS/s3/SFX/A9 - Air Ding.bin"
Sound_AA:       binclude "data/Sound/SMPS/s3/SFX/AA - Bumper.bin"
Sound_AB:       binclude "data/Sound/SMPS/s3/SFX/AB - Spin Dash.bin"
Sound_AC:       binclude "data/Sound/SMPS/s3/SFX/AC - Continue.bin"
Sound_AD:       binclude "data/Sound/SMPS/s3/SFX/AD - Launch Go (Sonic 3).bin"
Sound_AE:       binclude "data/Sound/SMPS/s3/SFX/AE - Flipper.bin"
Sound_AF:       binclude "data/Sound/SMPS/s3/SFX/AF - Enter Special Stage.bin"
Sound_B0:       binclude "data/Sound/SMPS/s3/SFX/B0 - Register.bin"
Sound_B1:       binclude "data/Sound/SMPS/s3/SFX/B1 - Spring.bin"
Sound_B2:       binclude "data/Sound/SMPS/s3/SFX/B2 - Error.bin"
Sound_B3:       binclude "data/Sound/SMPS/s3/SFX/B3 - Big Ring.bin"
Sound_B4:       binclude "data/Sound/SMPS/s3/SFX/B4 - Explode.bin"
Sound_B5:       binclude "data/Sound/SMPS/s3/SFX/B5 - Diamonds.bin"
Sound_B6:       binclude "data/Sound/SMPS/s3/SFX/B6 - Dash.bin"
Sound_B7:       binclude "data/Sound/SMPS/s3/SFX/B7 - Slot Machine.bin"
Sound_B8:       binclude "data/Sound/SMPS/s3/SFX/B8 - Signpost.bin"
Sound_B9:       binclude "data/Sound/SMPS/s3/SFX/B9 - Ring Loss.bin"
Sound_BA:       binclude "data/Sound/SMPS/s3/SFX/BA - Flying.bin"
Sound_BB:       binclude "data/Sound/SMPS/s3/SFX/BB - Flying (Tired).bin"
Sound_BC:       binclude "data/Sound/SMPS/s3/SFX/BC - Slide Skid (Loud).bin"
Sound_BD:       binclude "data/Sound/SMPS/s3/SFX/BD - Large Ship.bin"
Sound_BE:       binclude "data/Sound/SMPS/s3/SFX/BE - Robotnik Siren.bin"
Sound_BF:       binclude "data/Sound/SMPS/s3/SFX/BF - Boss Rotate.bin"
Sound_C0:       binclude "data/Sound/SMPS/s3/SFX/C0 - Fan (Big).bin"
Sound_C1:       binclude "data/Sound/SMPS/s3/SFX/C1 - Fan (Small).bin"
Sound_C2:       binclude "data/Sound/SMPS/s3/SFX/C2 - Flamethrower (Loud).bin"
Sound_C3:       binclude "data/Sound/SMPS/s3/SFX/C3 - Gravity Tunnel.bin"
Sound_C4:       binclude "data/Sound/SMPS/s3/SFX/C4 - Boss Panic.bin"
Sound_C5:       binclude "data/Sound/SMPS/s3/SFX/C5 - Unknown Spin.bin"
Sound_C6:       binclude "data/Sound/SMPS/s3/SFX/C6 - Wave Hover.bin"
Sound_C7:       binclude "data/Sound/SMPS/s3/SFX/C7 - Cannon Turn.bin"
Sound_C8:       binclude "data/Sound/SMPS/s3/SFX/C8 - Slide Skid (Quiet).bin"
Sound_C9:       binclude "data/Sound/SMPS/s3/SFX/C9 - Spike Balls.bin"
Sound_CA:       binclude "data/Sound/SMPS/s3/SFX/CA - Light Tunnel.bin"
Sound_CB:       binclude "data/Sound/SMPS/s3/SFX/CB - Rumble.bin"
Sound_CC:       binclude "data/Sound/SMPS/s3/SFX/CC - Big Rumble.bin"
Sound_CD:       binclude "data/Sound/SMPS/s3/SFX/CD - Death Egg Rise (Loud).bin"
Sound_CE:       binclude "data/Sound/SMPS/s3/SFX/CE - Wind (Quiet).bin"
Sound_CF:       binclude "data/Sound/SMPS/s3/SFX/CF - Wind (Loud).bin"
Sound_D0:       binclude "data/Sound/SMPS/s3/SFX/D0 - Rising.bin"
Sound_D1:       binclude "data/Sound/SMPS/s3/SFX/D1 - Unknown Flutter 2.bin"
Sound_D2:       binclude "data/Sound/SMPS/s3/SFX/D2 - Gumball Tab.bin"
Sound_D3:       binclude "data/Sound/SMPS/s3/SFX/D3 - Death Egg Rise (Quiet).bin"
Sound_D4:       binclude "data/Sound/SMPS/s3/SFX/D4 - Turbine Hum.bin"
Sound_D5:       binclude "data/Sound/SMPS/s3/SFX/D5 - Lava Fall.bin"
Sound_D6:       binclude "data/Sound/SMPS/s3/SFX/D6 - Unknown Zap.bin"
Sound_D7:       binclude "data/Sound/SMPS/s3/SFX/D7 - Conveyor Platform.bin"
Sound_D8:       binclude "data/Sound/SMPS/s3/SFX/D8 - Unknown Saw.bin"
Sound_D9:       binclude "data/Sound/SMPS/s3/SFX/D9 - Magnetic Spike.bin"
Sound_DA:       binclude "data/Sound/SMPS/s3/SFX/DA - Leaf Blower.bin"
Sound_DB:       binclude "data/Sound/SMPS/s3/SFX/DB - Water Skid.bin"

                finishBank

                align   $8000
ArtUnc_Sonic:
                binclude "data/General/Sprites/Sonic/Art/Sonic.unc"
                even
ArtUnc_Tails:
                binclude "data/General/Sprites/Tails/Art/Tails.unc"
                even
ArtUnc_Tails_Tail:
                binclude "data/General/Sprites/Tails/Art/Tails tails.unc"
                even
ArtUnc_Sonic2P:
                binclude "data/General/Sprites/Sonic/Art/Sonic 2P.unc"
                even
ArtUnc_Tails2P:
                binclude "data/General/Sprites/Tails/Art/Tails 2P.unc"
                even
ArtUnc_Tails2P_Tail:
                binclude "data/General/Sprites/Tails/Art/Tails tails 2P.unc"
                even
ArtUnc_Knuckles2P:
                binclude "data/General/Sprites/Knuckles/Art/Knuckles 2P.unc"
                even
Map_Sonic:
                include "src/objects/shared/sonic/map_sonic_s3.s"
PLC_Sonic:
                include "src/objects/shared/sonic/dplc_sonic_s3.s"
Map_Tails:
                include "src/objects/shared/tails/map_tails_s3.s"
PLC_Tails:
                include "src/objects/shared/tails/dplc_tails_s3.s"
Map_Tails_Tail:
                include "src/objects/shared/tails/map_tails_tails.s"
PLC_Tails_Tail:
                include "src/objects/shared/tails/dplc_tails_tails.s"
ICZSnowboard_Slope1:
                binclude "data/Levels/ICZ/Misc/ICZ Snowboard Slope 1.bin"
                even
ICZSnowboard_Slope2:
                binclude "data/Levels/ICZ/Misc/ICZ Snowboard Slope 2.bin"
                even
ArtUnc_SonicSnowboard:
                binclude "data/General/Sprites/Sonic/Art/Sonic Snowboarding.unc"
                even
ArtUnc_Snowboard:
                binclude "data/General/Sprites/Snowboard/Snowboard.unc"
                even
Map_SonicSnowboard:
                include "src/objects/shared/sonic/map_sonic_snowboarding.s"
DPLC_SonicSnowboard:
                include "src/objects/shared/sonic/dplc_sonic_snowboarding.s"
Map_Snowboard:
                include "src/objects/shared/snowboard/map_snowboard.s"
DPLC_Snowboard:
                include "src/objects/shared/snowboard/dplc_snowboard.s"
ArtNem_AIZIntroSprites:
                binclude "data/Levels/AIZ/Nemesis Art/Intro Waves.nem"
                even
ArtNem_SurfboardSplash:
                binclude "data/General/Sprites/Surfboard/Surfboard Splash.nem"
                even
ArtNem_Surfboard:
                binclude "data/General/Sprites/Surfboard/Surfboard.nem"
                even
ArtUnc_Invincibility:
                binclude "data/General/Sprites/Shields/Invincibility.unc"
ArtUnc_Invincibility_end:
                even
ArtUnc_DashDust:
                binclude "data/General/Sprites/Dash Dust/Dash Dust.unc"
                even
ArtUnc_SuperSonic_Stars:
                binclude "data/General/Sprites/Shields/Super Sonic Stars.unc"
                even
ArtUnc_InstaShield:
                binclude "data/General/Sprites/Shields/Insta-Shield.unc"
                even
ArtUnc_FireShield:
                binclude "data/General/Sprites/Shields/Fire Shield.unc"
                even
ArtUnc_LightningShield:
                binclude "data/General/Sprites/Shields/Lightning Shield.unc"
                even
ArtUnc_LightningShield_Sparks:
                binclude "data/General/Sprites/Shields/Sparks.unc"
ArtUnc_LightningShield_Sparks_end:
                even
ArtUnc_BubbleShield:
                binclude "data/General/Sprites/Shields/Bubble Shield.unc"
                even
ArtNem_2PDashdust:
                binclude "data/General/2P Zone/Nemesis Art/Spindash Dust.nem"
                even
MapEni_S3TitleSonic1:
                binclude "data/General/Title/Enigma Map/S3 Sonic 1.eni"
                even
MapEni_S3TitleSonic2:
                binclude "data/General/Title/Enigma Map/S3 Sonic 2.eni"
                even
MapEni_S3TitleSonic3:
                binclude "data/General/Title/Enigma Map/S3 Sonic 3.eni"
                even
MapEni_S3TitleSonic4:
                binclude "data/General/Title/Enigma Map/S3 Sonic 4.eni"
                even
MapEni_S3TitleSonic5:
                binclude "data/General/Title/Enigma Map/S3 Sonic 5.eni"
                even
MapEni_S3TitleSonic6:
                binclude "data/General/Title/Enigma Map/S3 Sonic 6.eni"
                even
MapEni_S3TitleSonic7:
                binclude "data/General/Title/Enigma Map/S3 Sonic 7.eni"
                even
MapEni_S3TitleSonic8:
                binclude "data/General/Title/Enigma Map/S3 Sonic 8.eni"
                even
MapEni_S3TitleSonic9:
                binclude "data/General/Title/Enigma Map/S3 Sonic 9.eni"
                even
MapEni_S3TitleSonicA:
                binclude "data/General/Title/Enigma Map/S3 Sonic A.eni"
                even
MapEni_S3TitleSonicB:
                binclude "data/General/Title/Enigma Map/S3 Sonic B.eni"
                even
MapEni_S3TitleSonicC:
                binclude "data/General/Title/Enigma Map/S3 Sonic C.eni"
                even
MapEni_S3TitleSonicD:
                binclude "data/General/Title/Enigma Map/S3 Sonic D.eni"
                even
MapEni_S3TitleBg:
                binclude "data/General/Title/Enigma Map/S3 BG.eni"
                even
Map_S3TitleBanner:
                include "src/ui/shared/title/map_s3_banner.s"
ArtNem_Title_S3Banner:
                binclude "data/General/Title/Nemesis Art/S3 Banner.nem"
                even
ArtKos_S3TitleSonic1:
                binclude "data/General/Title/Kosinski Art/S3 Sonic 1.kos"
                even
ArtKos_S3TitleSonic8:
                binclude "data/General/Title/Kosinski Art/S3 Sonic 8.kos"
                even
ArtKos_S3TitleSonic9:
                binclude "data/General/Title/Kosinski Art/S3 Sonic 9.kos"
                even
ArtKos_S3TitleSonicA:
                binclude "data/General/Title/Kosinski Art/S3 Sonic A.kos"
                even
ArtKos_S3TitleSonicB:
                binclude "data/General/Title/Kosinski Art/S3 Sonic B.kos"
                even
ArtKos_S3TitleSonicC:
                binclude "data/General/Title/Kosinski Art/S3 Sonic C.kos"
                even
ArtKos_S3TitleSonicD:
                binclude "data/General/Title/Kosinski Art/S3 Sonic D.kos"
                align   $100
ArtNem_GrayButton:
                binclude "data/General/Sprites/Buttons/Gray Button.nem"
                even
ArtNem_VerticalSpring:
                binclude "data/General/Sprites/Level Misc/Vertical Spring.nem"
                even
ArtNem_HorizontalSpring:
                binclude "data/General/Sprites/Level Misc/Horizontal Spring.nem"
                even
ArtNem_DiagonalSpring:
                binclude "data/General/Sprites/Level Misc/Diagonal Spring.nem"
                even
ArtNem_HUDText:
                binclude "data/General/Sprites/HUD Icon/HUD Text.nem"
                even
ArtNem_SonicLifeIcon:
                binclude "data/General/Sprites/HUD Icon/Sonic Life Icon.nem"
                even
ArtNem_TailsLifeIcon:
                binclude "data/General/Sprites/HUD Icon/Tails Life Icon.nem"
                even
ArtNem_KnucklesLifeIcon:
                binclude "data/General/Sprites/HUD Icon/Knuckles Life Icon.nem"
                even
ArtNem_Ring:
                binclude "data/General/Sprites/Ring/Ring.nem"
                even
ArtNem_Monitors:
                binclude "data/General/Sprites/Monitors/Monitors.nem"
                even
ArtNem_VerticalSpikes:
                binclude "data/General/Sprites/Level Misc/Vertical Spikes.nem"
                even
ArtNem_HorizontalSpikes:
                binclude "data/General/Sprites/Level Misc/Horizontal Spikes.nem"
                even
ArtNem_EnemyPoints:
                binclude "data/General/Sprites/Enemy Misc/Enemy Points.nem"
                even
ArtNem_StarPost:
                binclude "data/General/Sprites/Starpost/Starpost.nem"
                even
ArtNem_S2Signpost:
                binclude "data/General/S2Menu/Nemesis Art/Signpost.nem"
                even
ArtNem_Bubbles:
                binclude "data/General/Sprites/Bubbles/Bubbles.nem"
                even
ArtNem_GameOver:
                binclude "data/General/Sprites/Game Over/GameOver.nem"
                even
ArtNem_Explosion:
                binclude "data/General/Sprites/Enemy Misc/Explosion.nem"
                even
ArtNem_ContinueTails:
                binclude "data/General/S2Menu/Nemesis Art/Tails Continue Sprites.nem"
                even
ArtNem_MiniSonic:
                binclude "data/General/S2Menu/Nemesis Art/Sonic Continue Icon.nem"
                even
ArtNem_MiniTails:
                binclude "data/General/S2Menu/Nemesis Art/Tails Continue Icon.nem"
                even
ArtNem_SpikesSprings:
                binclude "data/General/Sprites/Level Misc/SpikesSprings.nem"
                even
ArtNem_RingHUDText:
                binclude "data/General/Sprites/Ring/RingHUDText.nem"
                even
ArtNem_EnemyPtsStarPost:
                binclude "data/General/Sprites/Enemy Misc/EnemyPtsStarpost.nem"
                even
ArtNem_Seal:
                binclude "data/General/Sprites/Animals/Seal.nem"
                even
ArtNem_Pig:
                binclude "data/General/Sprites/Animals/Pig.nem"
                even
ArtNem_BlueFlicky:
                binclude "data/General/Sprites/Animals/Blue Flicky.nem"
                even
ArtNem_Chicken:
                binclude "data/General/Sprites/Animals/Chicken.nem"
                even
ArtNem_Penguin:
                binclude "data/General/Sprites/Animals/Penguin.nem"
                even
ArtNem_Squirrel:
                binclude "data/General/Sprites/Animals/Squirrel.nem"
                even
ArtNem_Rabbit:
                binclude "data/General/Sprites/Animals/Rabbit.nem"
                even
Map_RobotnikShip:
                include "src/objects/shared/robotnik/map_robotnik_ship.s"
Map_FBZRobotnikRun:
                include "src/objects/shared/robotnik/map_fbz_robotnik_run.s"
Map_FBZRobotnikHead:
                include "src/objects/shared/robotnik/map_fbz_robotnik_head.s"
Map_LBZMiniboss:
                include "src/objects/shared/zones/lbz/map_miniboss.s"
Map_LBZMinibossBox:
                include "src/objects/shared/zones/lbz/map_miniboss_box.s"
Map_SnaleBlaster:
                include "src/objects/shared/snale_blaster/map_snale_blaster.s"
Map_Orbinaut:
                include "src/objects/shared/orbinaut/map_orbinaut.s"
Map_Ribot:
                include "src/objects/shared/ribot/map_ribot.s"
Map_Corkey:
                include "src/objects/shared/corkey/map_corkey.s"
Map_Flybot767:
                include "src/objects/shared/flybot767/map_flybot767.s"
DPLC_Flybot767:
                include "src/objects/shared/flybot767/dplc_flybot767.s"
Map_LBZEndBoss:
                include "src/objects/shared/zones/lbz/map_end_boss.s"
Map_CNZEndBoss:
                include "src/objects/shared/zones/cnz/map_end_boss.s"
CNZEndBossMagnet_AngleX:
                dc.b    0,   1,   2,   3,   4,   5,   6,   8,   9,  $A,  $B,  $C,  $D,  $E,  $F, $10
                dc.b    $11, $12, $13, $14, $15, $16, $17, $18, $18, $19, $1A, $1B, $1C, $1D, $1E, $1E
                dc.b    $1F, $20, $21, $21, $22, $23, $23, $24, $25, $25, $26, $26, $27, $27, $28, $28
                dc.b    $29, $29, $29, $2A, $2A, $2A, $2B, $2B, $2B, $2B, $2C, $2C, $2C, $2C, $2C, $2C
LBZFinalBoss2_CircleLookup:
                dc.b    0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  $A,  $B,  $C,  $D,  $D,  $E
                dc.b    $F, $10, $11, $12, $13, $14, $15, $15, $16, $17, $18, $19, $19, $1A, $1B, $1C
                dc.b    $1C, $1D, $1E, $1E, $1F, $20, $20, $21, $21, $22, $22, $23, $23, $24, $24, $25
                dc.b    $25, $25, $26, $26, $26, $27, $27, $27, $27, $27, $28, $28, $28, $28, $28, $28
Map_FBZMiniboss:
                include "src/objects/shared/zones/fbz/map_miniboss.s"
Map_FBZEggCapsule:
                include "src/objects/shared/zones/fbz/map_egg_capsule_s3.s"
Map_Blastoid:
                include "src/objects/shared/blastoid/map_blastoid.s"
Map_Toxomister:
                include "src/objects/shared/toxomister/map_toxomister_s3.s"
Map_Poindexter:
                include "src/objects/shared/pointdexter/map_pointdexter.s"
Map_Buggernaut:
                include "src/objects/shared/buggernaut/map_buggernaut.s"
Map_MegaChopper:
                include "src/objects/shared/mega_chopper/map_mega_chopper.s"
Map_Dragonfly:
                include "src/objects/shared/dragonfly/map_dragonfly.s"
DPLC_Cluckoid:
                include "src/objects/shared/cluckoid/dplc_cluckoid.s"
Map_CluckoidArrow:
                include "src/objects/shared/cluckoid/map_cluckoid_arrow.s"
Map_Cluckoid:
                include "src/objects/shared/cluckoid/map_cluckoid.s"
Map_Butterdroid:
                include "src/objects/shared/butterdroid/map_butterdroid.s"
DPLC_Butterdroid:
                include "src/objects/shared/butterdroid/dplc_butterdroid.s"
Map_TurboSpiker:
                include "src/objects/shared/turbo_spiker/map_turbo_spiker.s"
Map_FirewormSegments:
                include "src/objects/shared/fireworm/map_fireworm_segments.s"
DPLC_Fireworm:
                include "src/objects/shared/fireworm/dplc_fireworm.s"
Map_Fireworm:
                include "src/objects/shared/fireworm/map_fireworm.s"
Map_Jawz:
                include "src/objects/shared/jawz/map_jawz.s"
Map_Mushmeanie:
                include "src/objects/shared/mushmeanie/map_mushmeanie.s"
Map_Madmole:
                include "src/objects/shared/madmole/map_madmole_s3.s"
Map_Iwamodoki:
                include "src/objects/shared/iwamodoki/map_iwamodoki_s3.s"
DPLC_Rhinobot:
                include "src/objects/shared/rhinobot/dplc_rhinobot.s"
Map_Rhinobot:
                include "src/objects/shared/rhinobot/map_rhinobot.s"
                dc.w    $A
                dc.w    $1C
                dc.w    $24
                dc.w    $2C
                dc.w    $34
Map_BossExplosion:
                include "src/objects/shared/boss_explosion/map_boss_explosion.s"
Map_AIZMinibossFlame:
                include "src/objects/shared/zones/aiz/map_miniboss_flame.s"
Map_FBZEndBossFlame:
                include "src/objects/shared/zones/fbz/map_end_boss_flame.s"
Map_Bloominator:
                include "src/objects/shared/bloominator/map_bloominator.s"
Map_MonkeyDude:
                include "src/objects/shared/monkey_dude/map_monkey_dude.s"
Map_SOZMiniboss:
                include "src/objects/shared/zones/soz/map_miniboss.s"
Map_MGZMiniboss:
                include "src/objects/shared/zones/mgz/map_miniboss.s"
Map_CaterKillerJr:
                include "src/objects/shared/caterkiller_jr/map_caterkiller_jr.s"
DPLC_Clamer:
                include "src/objects/shared/clamer/dplc_clamer.s"
Map_Clamer:
                include "src/objects/shared/clamer/map_clamer.s"
Map_Sparkle:
                include "src/objects/shared/sparkle/map_sparkle.s"
Map_Batbot:
                include "src/objects/shared/batbot/map_batbot.s"
DPLC_BubblesBadnik:
                include "src/objects/shared/bubbles_badnik/dplc_bubbles_badnik.s"
Map_BubblesBadnik:
                include "src/objects/shared/bubbles_badnik/map_bubbles_badnik.s"
Map_Spiker:
                include "src/objects/shared/spiker/map_spiker.s"
Map_Mantis:
                include "src/objects/shared/mantis/map_mantis.s"
Map_Blaster:
                include "src/objects/shared/blaster/map_blaster.s"
DPLC_Penguinator:
                include "src/objects/shared/penguinator/dplc_penguinator.s"
Map_Penguinator:
                include "src/objects/shared/penguinator/map_penguinator.s"
Map_ICZSnowdust:
                include "src/objects/shared/zones/icz/map_snowdust.s"
Map_TechnoSqueek:
                include "src/objects/shared/technosqueek/map_technosqueek.s"
Map_StarPointer:
                include "src/objects/shared/star_pointer/map_star_pointer.s"
Map_AIZEndBoss:
                include "src/objects/shared/zones/aiz/map_end_boss.s"
Map_AIZMiniboss:
                include "src/objects/shared/zones/aiz/map_miniboss.s"
Map_AIZMinibossSmall:
                include "src/objects/shared/zones/aiz/map_miniboss_small.s"
Map_MGZEndBoss:
                include "src/objects/shared/zones/mgz/map_end_boss.s"
HCZMiniboss_RocketTwistLookup:
                dc.b    $18, $18, $18, $18, $18, $18, $18, $18, $18, $17, $17, $17, $17, $17, $17, $16
                dc.b    $16, $16, $16, $15, $15, $15, $15, $14, $14, $14, $13, $13, $13, $12, $12, $11
                dc.b    $11, $11, $10, $10,  $F,  $F,  $E,  $E,  $D,  $D,  $C,  $C,  $B,  $B,  $A,  $A
                dc.b    9,   9,   8,   8,   7,   6,   6,   5,   5,   4,   4,   3,   2,   2,   1,   1
                dc.b    0,  -1,  -1,  -2,  -2,  -3,  -4,  -4,  -5,  -5,  -6,  -6,  -7,  -8,  -8,  -9
                dc.b    -9, -$A, -$A, -$B, -$B, -$C, -$C, -$D, -$D, -$E, -$E, -$F, -$F,-$10,-$10,-$11
                dc.b    -$11,-$11,-$12,-$12,-$13,-$13,-$13,-$14,-$14,-$14,-$15,-$15,-$15,-$15,-$16,-$16
                dc.b    -$16,-$16,-$17,-$17,-$17,-$17,-$17,-$17,-$18,-$18,-$18,-$18,-$18,-$18,-$18,-$18
FBZEndBoss_CircleLookup1:
                dc.b    0,   2,   4,   5,   7,   9,  $B,  $C,  $E, $10, $11, $13, $15, $17, $18, $1A
                dc.b    $1C, $1D, $1F, $20, $22, $23, $25, $27, $28, $29, $2B, $2C, $2E, $2F, $30, $32
                dc.b    $33, $34, $35, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $3F, $40, $41, $42
                dc.b    $43, $43, $44, $44, $45, $45, $46, $46, $47, $47, $47, $47, $48, $48, $48, $48
FBZEndBoss_CircleLookup2:
                dc.b    0,   1,   2,   2,   3,   4,   5,   5,   6,   7,   8,   9,   9,  $A,  $B,  $C
                dc.b    $C,  $D,  $E,  $E,  $F, $10, $10, $11, $12, $12, $13, $14, $14, $15, $15, $16
                dc.b    $17, $17, $18, $18, $19, $19, $1A, $1A, $1B, $1B, $1B, $1C, $1C, $1D, $1D, $1D
                dc.b    $1E, $1E, $1E, $1E, $1F, $1F, $1F, $1F, $1F, $20, $20, $20, $20, $20, $20, $20
LBZ2FinalBoss2_CircleLookup2:
                dc.b    0,   0,   1,   1,   2,   2,   3,   3,   4,   4,   5,   5,   6,   6,   7,   7
                dc.b    8,   8,   9,   9,   9,  $A,  $A,  $B,  $B,  $C,  $C,  $C,  $D,  $D,  $D,  $E
                dc.b    $E,  $E,  $F,  $F,  $F, $10, $10, $10, $11, $11, $11, $11, $12, $12, $12, $12
                dc.b    $12, $13, $13, $13, $13, $13, $13, $14, $14, $14, $14, $14, $14, $14, $14, $14
                even
Map_HCZMiniboss:
                include "src/objects/shared/zones/hcz/map_miniboss.s"
Map_HCZMinibossSplash:
                include "src/objects/shared/zones/hcz/map_miniboss_splash.s"
DPLC_HCZMinibossSplash:
                include "src/objects/shared/zones/hcz/dplc_miniboss_splash.s"
Map_ICZEndBoss:
                include "src/objects/shared/zones/icz/map_end_boss.s"

PalSPtr_CNZMinibossNormal:
                palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                .data:  palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 6, $020
                palscriptloop .headr2
                .headr2: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 4, $020
                palscriptloop .headr3
                .headr3: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 2, $020
                palscriptloop .headr4
                .headr4: palscripthdr Normal_palette_line_2+$14, 1, $B-1
                palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 1, $020
                palscriptrun

PalSPtr_CNZMinibossSparks:
                palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$14, 1, $31-1
                .data:  palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 1, $020
                palscriptloop .headr2
                .headr2: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 2, $020
                palscriptloop .headr3
                .headr3: palscripthdr Normal_palette_line_2+$14, 1, 4-1
                palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 4, $020
                palscriptloop .headr4
                .headr4: palscripthdr Normal_palette_line_2+$14, 1, 2-1
                palscriptdata 96, $020
                palscriptloop PalSPtr_CNZMinibossNormal.headr3

PalSPtr_CNZMinibossOpen:
                palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$14, 1, 0
                .data:  palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 2, $020
                palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 8, $020
                palscriptdata 1, $EEE
                palscriptdata 1, $A22
                palscriptdata 3, $020
                palscriptrept

Map_CNZMiniboss:
                include "src/objects/shared/zones/cnz/map_miniboss.s"

word_16322C:    palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                .data:  palscriptdata 8, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr2
                .headr2: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 6, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr3
                .headr3: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 4, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr4
                .headr4: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 2, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr5
                .headr5: palscripthdr Normal_palette_line_2+$14, 1, 0
                palscriptdata 1, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptrept

word_163298:    palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                .data:  palscriptdata 2, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr2
                .headr2: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 4, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr3
                .headr3: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 6, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr4
                .headr4: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 8, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr5
                .headr5: palscripthdr Normal_palette_line_2+$14, 1, 5-1
                palscriptdata 10,$222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptrun

ICZMiniboss_OrbAngleLookup:
                dc.b    0,   1,   2,   4,   5,   6,   7,   8,   9,  $B,  $C,  $D,  $E,  $F, $10, $11
                dc.b    $12, $13, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1E, $1F, $20, $21
                dc.b    $22, $23, $24, $24, $25, $26, $27, $27, $28, $29, $29, $2A, $2A, $2B, $2B, $2C
                dc.b    $2C, $2D, $2D, $2E, $2E, $2E, $2F, $2F, $2F, $2F, $2F, $30, $30, $30, $30, $30
                even
Map_ICZMiniboss:
                include "src/objects/shared/zones/icz/map_miniboss.s"
Map_FBZEndBoss:
                include "src/objects/shared/zones/fbz/map_end_boss.s"
Map_HCZEndBoss:
                include "src/objects/shared/zones/hcz/map_end_boss.s"
Map_MGZEndBossDebris:
                include "src/objects/shared/zones/mgz/map_end_boss_debris.s"
Map_FBZ2Subboss:
                include "src/objects/shared/zones/fbz/map_act_2_subboss_s3.s"
Map_FBZRobotnikStand:
                include "src/objects/shared/robotnik/map_fbz_robotnik_stand.s"
Map_ICZWallAndColumn:
                include "src/objects/shared/zones/icz/map_wall_and_column.s"
Map_ICZPlatforms:
                include "src/objects/shared/zones/icz/map_platforms.s"
DPLC_EndSigns:
                include "src/objects/shared/signpost/dplc_end_signs.s"
Map_EndSigns:
                include "src/objects/shared/signpost/map_end_signs.s"
Map_SignpostStub:
                include "src/objects/shared/signpost/map_signpost_stub.s"
Map_EggCapsule:
                include "src/objects/shared/egg_capsule/map_egg_capsule_s3.s"
Map_LBZKnuxBomb:
                include "src/objects/shared/knuckles/cutscene/map_knuckles_bomb.s"
Map_CutsceneKnux:
                include "src/objects/shared/knuckles/cutscene/map_cutscene_knuckles.s"
DPLC_CutsceneKnux:
                include "src/objects/shared/knuckles/cutscene/dplc_cutscene_knuckles.s"
Map_AIZIntroPlane:
                include "src/objects/shared/zones/aiz/map_intro_plane.s"
Map_AIZIntroEmeralds:
                include "src/objects/shared/zones/aiz/map_intro_emeralds.s"
Map_LBZFinalBoss1:
                include "src/objects/shared/zones/lbz/map_final_boss_1.s"
Map_LBZDeathEggSmall:
                include "src/objects/shared/zones/lbz/map_death_egg_small.s"
Pal_MGZFadeCNZ:
                binclude "data/Levels/MGZ/Palettes/Fade to CNZ.bin"
                even
Map_LBZFinalBoss2:
                include "src/objects/shared/zones/lbz/map_final_boss_2.s"
ArtNem_AIZMiniboss:
                binclude "data/Levels/AIZ/Nemesis Art/Miniboss.nem"
                even
ArtKosM_AIZEndBoss:
                binclude "data/Levels/AIZ/KosinskiM Art/End Boss.kosm"
                even
ArtNem_AIZMinibossSmall:
                binclude "data/Levels/AIZ/Nemesis Art/Miniboss Small.nem"
                even
ArtUnc_AIZRhinobot:
                binclude "data/General/Sprites/Rhinobot/Rhinobot.unc"
                even
ArtKosM_AIZ_Bloominator:
                binclude "data/General/Sprites/Bloominator/Bloominator.kosm"
                even
ArtKosM_AIZ_MonkeyDude:
                binclude "data/General/Sprites/Monkey Dude/Monkey Dude.kosm"
                even
ArtKosM_AIZ_CaterkillerJr:
                binclude "data/General/Sprites/Caterkiller Jr/Caterkiller Jr.kosm"
                even
ArtNem_HCZMiniboss:
                binclude "data/Levels/HCZ/Nemesis Art/Miniboss.nem"
                even
ArtNem_HCZEndBoss:
                binclude "data/Levels/HCZ/Nemesis Art/End Boss.nem"
                even
ArtNem_HCZDragonfly:
                binclude "data/General/Sprites/Buggernaut/Buggernaut.nem"
                even
ArtKosM_Jawz:
                binclude "data/General/Sprites/Jawz/Jawz.kosm"
                even
ArtKosM_MegaChopper:
                binclude "data/General/Sprites/Mega Chopper/Mega Chopper.kosm"
                even
ArtKosM_Blastoid:
                binclude "data/General/Sprites/Blastoid/Blastoid.kosm"
                even
ArtKosM_TurboSpiker:
                binclude "data/General/Sprites/Turbo Spiker/Turbo Spiker.kosm"
                even
ArtKosM_Pointdexter:
                binclude "data/General/Sprites/Pointdexter/Pointdexter.kosm"
                even
ArtKosM_MGZMiniboss:
                binclude "data/Levels/MGZ/KosinskiM Art/Miniboss.kosm"
                even
ArtNem_MGZSpire:
                binclude "data/Levels/MGZ/Nemesis Art/Spire.nem"
                even
ArtKosM_MGZEndBoss:
                binclude "data/Levels/MGZ/KosinskiM Art/End Boss.kosm"
                even
ArtScaled_MGZEndBoss:
                binclude "data/Levels/MGZ/Misc/MGZ End Boss Scaled.bin"
                even
ArtKosM_MGZEndBossDebris:
                binclude "data/Levels/MGZ/KosinskiM Art/End Boss Debris.kosm"
                even
ArtUnc_BubblesBadnik:
                binclude "data/General/Sprites/Bubbles Badnik/Bubbles Badnik.unc"
                even
ArtKosM_Spiker:
                binclude "data/General/Sprites/Spiker/Spiker.kosm"
                even
ArtKosM_Mantis:
                binclude "data/General/Sprites/Mantis/Mantis.kosm"
                even
ArtNem_CNZMiniboss:
                binclude "data/Levels/CNZ/Nemesis Art/Miniboss.nem"
                even
ArtNem_CNZEndBoss:
                binclude "data/Levels/CNZ/Nemesis Art/End Boss.nem"
                even
ArtUnc_Clamer:
                binclude "data/General/Sprites/Clamer/Clamer.unc"
                even
ArtKosM_ClamerShot:
                binclude "data/General/Sprites/Clamer/Clamer Shot.kosm"
                even
ArtKosM_Sparkle:
                binclude "data/General/Sprites/Sparkle/Sparkle.kosm"
                even
ArtKosM_Batbot:
                binclude "data/General/Sprites/Batbot/Batbot.kosm"
                even
ArtKosM_CNZBalloon:
                binclude "data/Levels/CNZ/KosinskiM Art/Balloon.kosm"
                even
ArtNem_FBZMiniboss:
                binclude "data/Levels/FBZ/Nemesis Art/S3 Miniboss.nem"
                even
ArtNem_FBZ2Subboss:
                binclude "data/Levels/FBZ/Nemesis Art/Act 2 Subboss.nem"
                even
ArtNem_FBZEndBoss:
                binclude "data/Levels/FBZ/Nemesis Art/End Boss.nem"
                even
ArtKosM_Blaster:
                binclude "data/General/Sprites/Blaster/Blaster.kosm"
                even
ArtKosM_Technosqueek:
                binclude "data/General/Sprites/Technosqueek/Technosqueek.kosm"
                even
ArtNem_ICZMisc1:
                binclude "data/Levels/ICZ/Nemesis Art/Misc Art 1.nem"
                even
ArtNem_ICZIntroSprites:
                binclude "data/Levels/ICZ/Nemesis Art/Intro Sprites.nem"
                even
ArtNem_ICZMisc2:
                binclude "data/Levels/ICZ/Nemesis Art/Misc Art 2.nem"
                even
ArtNem_ICZEndBoss:
                binclude "data/Levels/ICZ/Nemesis Art/End Boss.nem"
                even
ArtNem_ICZMiniboss:
                binclude "data/Levels/ICZ/Nemesis Art/Miniboss.nem"
                even
ArtUnc_Penguinator:
                binclude "data/General/Sprites/Penguinator/Penguinator.unc"
                even
ArtKosM_ICZSnowdust:
                binclude "data/Levels/ICZ/KosinskiM Art/Snowdust.kosm"
                even
ArtKosM_StarPointer:
                binclude "data/General/Sprites/Star Pointer/Star Pointer.kosm"
                even
ArtKosM_LBZMiniboss:
                binclude "data/Levels/LBZ/KosinskiM Art/Miniboss.kosm"
                even
ArtKosM_LBZMinibossBox:
                binclude "data/Levels/LBZ/KosinskiM Art/Miniboss Box.kosm"
                even
ArtNem_LBZFinalBoss1:
                binclude "data/Levels/LBZ/Nemesis Art/Final Boss 1.nem"
                even
ArtKosM_LBZEndBoss:
                binclude "data/Levels/LBZ/KosinskiM Art/End Boss.kosm"
                even
ArtKosM_LBZFinalBoss2:
                binclude "data/Levels/LBZ/KosinskiM Art/Final Boss 2.kosm"
                even
ArtKosM_SnaleBlaster:
                binclude "data/General/Sprites/Snale Blaster/Snale Blaster.kosm"
                even
ArtKosM_Ribot:
                binclude "data/General/Sprites/Ribot/Ribot.kosm"
                even
ArtKosM_Orbinaut:
                binclude "data/General/Sprites/Orbinaut/Orbinaut.kosm"
                even
ArtKosM_Corkey:
                binclude "data/General/Sprites/Corkey/Corkey.kosm"
                even
ArtUnc_Flybot767:
                binclude "data/General/Sprites/Flybot767/Flybot767.unc"
                even
ArtNem_LBZKnuxBomb:
                binclude "data/General/Sprites/Knuckles/Cutscene/Knuckles Bomb.nem"
                even
ArtKosM_LBZ2DeathEggSmall:
                binclude "data/Levels/LBZ/KosinskiM Art/Act 2 Death Egg Small.kosm"
                even
ArtScaled_LBZ2UnusedRobotnik:
                binclude "data/General/Sprites/Robotnik/Robotnik Fly Scaled.bin"
                even
ArtKosM_LBZ2DeathEgg2_8x8:
                binclude "data/Levels/LBZ/Tiles/Act 2 Death Egg 2.kosm"
                even
ArtNem_BossExplosion:
                binclude "data/General/Sprites/Boss Explosion/Boss Explosion.nem"
                even
ArtNem_AIZBossFire:
                binclude "data/Levels/AIZ/Nemesis Art/Miniboss Fire.nem"
                even
ArtNem_FBZEndBossFlame:
                binclude "data/Levels/FBZ/Nemesis Art/End Boss Flame.nem"
                even
ArtNem_RobotnikShip:
                binclude "data/General/Sprites/Robotnik/Ship.nem"
                even
ArtNem_FBZRobotnikHead:
                binclude "data/General/Sprites/Robotnik/FBZ Robotnik Head.nem"
                even
ArtNem_FBZRobotnikStand:
                binclude "data/General/Sprites/Robotnik/FBZ Robotnik Stand.nem"
                even
ArtNem_FBZRobotnikRun:
                binclude "data/General/Sprites/Robotnik/FBZ Robotnik Run.nem"
                even
ArtUnc_EndSigns:
                binclude "data/General/Sprites/Signpost/End Signs.unc"
                even
ArtNem_SignpostStub:
                binclude "data/General/Sprites/Signpost/Stub.nem"
                even
ArtNem_EggCapsule:
                binclude "data/General/Sprites/Egg Capsule/Egg Capsule.nem"
                even
ArtKosM_AIZIntroPlane:
                binclude "data/Levels/AIZ/KosinskiM Art/Intro Plane.kosm"
                even
ArtUnc_CutsceneKnux:
                binclude "data/General/Sprites/Knuckles/Cutscene/Cutscene Main.unc"
                even
ArtKosM_AIZIntroEmeralds:
                binclude "data/Levels/AIZ/KosinskiM Art/Intro Emeralds.kosm"
                even
ArtUnc_SSEntryRing:
                binclude "data/General/Sprites/SS Entry/Entry Ring.unc"
                even
ArtUnc_SSEntryFlash:
                binclude "data/General/Sprites/SS Entry/Entry Flash.unc"
                even
ArtKosM_BadnikExplosion:
                binclude "data/General/Sprites/SS Entry/Badnik Explosion.kosm"
                even
ArtNem_BonusStage:
                binclude "data/Levels/Gumball/Nemesis Art/Gumball Bonus.nem"
                even
ArtKosM_SonicEndPose:
                binclude "data/General/Ending/KosinskiM Art/Sonic 3 Sonic Ending Pose.kosm"
                even
ArtKosM_TailsEndPose:
                binclude "data/General/Ending/KosinskiM Art/Tails Ending Pose.kosm"
                even
ArtKosM_SuperSonicEndPose:
                binclude "data/General/Ending/KosinskiM Art/Sonic 3 Super Sonic Ending Pose.kosm"
                even
ArtNem_S3CreditsText:
                binclude "data/General/Ending/Nemesis Art/S3 Large Text.nem"
                even
ArtNem_S38x16Font:
                binclude "data/General/Ending/Nemesis Art/S3 8x16 Font.nem"
                even
ArtNem_AIZCorkFloor:
                binclude "data/Levels/AIZ/Nemesis Art/Cork Floor 1.nem"
                even
ArtNem_AIZCorkFloor2:
                binclude "data/Levels/AIZ/Nemesis Art/Cork Floor 2.nem"
                even
ArtNem_AIZSwingVine:
                binclude "data/Levels/AIZ/Nemesis Art/Swing Vine.nem"
                even
ArtNem_AIZSlideRope:
                binclude "data/Levels/AIZ/Nemesis Art/Zip Vine.nem"
                even
ArtNem_AIZBackgroundTree:
                binclude "data/Levels/AIZ/Nemesis Art/BG Tree.nem"
                even
ArtNem_AIZMisc1:
                binclude "data/Levels/AIZ/Nemesis Art/Misc Art 1.nem"
                even
ArtNem_AIZFallingLog:
                binclude "data/Levels/AIZ/Nemesis Art/Falling Log.nem"
                even
ArtNem_AIZMisc2:
                binclude "data/Levels/AIZ/Nemesis Art/Misc Art 2.nem"
                even
ArtNem_HCZSpikeBall:
                binclude "data/Levels/HCZ/Nemesis Art/Spike Ball.nem"
                even
ArtNem_HCZWaveSplash:
                binclude "data/Levels/HCZ/Nemesis Art/Wave Splash.nem"
                even
ArtNem_HCZButton:
                binclude "data/Levels/HCZ/Nemesis Art/Button.nem"
                even
ArtNem_HCZMisc:
                binclude "data/Levels/HCZ/Nemesis Art/Misc Art.nem"
                even
ArtNem_HCZWaterRush:
                binclude "data/Levels/HCZ/Nemesis Art/Water Rush.nem"
                even
ArtKosM_HCZLargeFan:
                binclude "data/Levels/HCZ/KosinskiM Art/Large Fan.kosm"
                even
ArtKosM_HCZGeyserHorz:
                binclude "data/Levels/HCZ/KosinskiM Art/Geyser Horizontal.kosm"
                even
ArtKosM_HCZGeyserVert:
                binclude "data/Levels/HCZ/KosinskiM Art/Geyser Vertical.kosm"
                even
ArtNem_HCZ2Slide:
                binclude "data/Levels/HCZ/Nemesis Art/Act 2 Slide.nem"
                even
ArtNem_HCZ2BlockPlat:
                binclude "data/Levels/HCZ/Nemesis Art/Act 2 Block Platform.nem"
                even
ArtUnc_HCZWaterSplash2:
                binclude "data/Levels/HCZ/Animated Tiles/Water Splash 2.unc"
                even
ArtUnc_HCZWaterSplash:
                binclude "data/Levels/HCZ/Animated Tiles/Water Splash.unc"
                even
ArtNem_HCZ2KnuxWall:
                binclude "data/Levels/HCZ/Nemesis Art/Act 2 Knuckles Wall.nem"
                even
ArtNem_MGZMisc1:
                binclude "data/Levels/MGZ/Nemesis Art/Misc Art 1.nem"
                even
ArtNem_MGZMisc2:
                binclude "data/Levels/MGZ/Nemesis Art/Misc Art 2.nem"
                even
ArtNem_MGZSigns:
                binclude "data/Levels/MGZ/Nemesis Art/Direction Signs.nem"
                even
ArtNem_CNZMisc:
                binclude "data/Levels/CNZ/Nemesis Art/Misc Art.nem"
                even
ArtNem_CNZPlatform:
                binclude "data/Levels/CNZ/Nemesis Art/Platform.nem"
                even
ArtNem_LBZMisc:
                binclude "data/Levels/LBZ/Nemesis Art/Misc Art.nem"
                even
ArtNem_LBZTubeTrans:
                binclude "data/Levels/LBZ/Nemesis Art/Tube Transport.nem"
                even
ArtNem_LBZ2Misc:
                binclude "data/Levels/LBZ/Nemesis Art/Act 2 Misc Art.nem"
                even
ArtNem_2PArt_1:
                binclude "data/General/2P Zone/Nemesis Art/Misc Art 1.nem"
                even
ArtNem_2PArt_2:
                binclude "data/General/2P Zone/Nemesis Art/Misc Art 2.nem"
                even
ArtNem_2PArt_3:
                binclude "data/General/2P Zone/Nemesis Art/Misc Art 3.nem"
                even
ArtNem_2PStartPost:
                binclude "data/General/2P Zone/Nemesis Art/Start Post.nem"
                even
ArtNem_2PTime:
                binclude "data/General/2P Zone/Nemesis Art/Time Display.nem"
                even
ArtNem_2PLapNum:
                binclude "data/General/2P Zone/Nemesis Art/Lap Numbers.nem"
                even
ArtNem_2PPosIcon:
                binclude "data/General/2P Zone/Nemesis Art/Position Icons.nem"
                even
ArtNem_BPZMisc:
                binclude "data/Levels/BPZ/Nemesis Art/Misc Art.nem"
                even
ArtNem_DPZMisc:
                binclude "data/Levels/DPZ/Nemesis Art/Misc Art.nem"
                even
ArtNem_CGZMisc:
                binclude "data/Levels/CGZ/Nemesis Art/Platform.nem"
                even
ArtNem_EMZMisc:
                binclude "data/Levels/EMZ/Nemesis Art/Misc Art.nem"
                even
ArtKosM_AIZ2Bombership2_8x8:
                binclude "data/Levels/AIZ/Tiles/Act 2 Bombership 2.kosm"
                even
ArtKosM_ResultsSONIC:
                binclude "data/General/Sprites/Results/Results SONIC S3.kosm"
                even
ArtKosM_ResultsMILES:
                binclude "data/General/Sprites/Results/Results MILES.kosm"
                even
ArtKosM_ResultsTAILS:
                binclude "data/General/Sprites/Results/Results TAILS.kosm"
                even
ArtKosM_ResultsKNUCKLES:
                binclude "data/General/Sprites/Results/Results KNUCKLES.kosm"
                even
ArtKosM_ResultsGeneral:
                binclude "data/General/Sprites/Results/Results General.kosm"
                even
ArtKosM_TitleCardNum1:
                binclude "data/General/Sprites/Title Card/Title Card Number 1.kosm"
                even
ArtKosM_TitleCardNum2:
                binclude "data/General/Sprites/Title Card/Title Card Number 2.kosm"
                even
ArtKosM_SSResults:
                dc.w    $1220
ArtKos_SSResultsGeneral:
                binclude "data/General/Special Stage/Kosinski Art/S3 SSResults General.kos"
ArtKos_SSResultsTKIcons:
                binclude "data/General/Special Stage/Kosinski Art/S3 SSResults Tails Knuckles Icons.kos"
                even
ArtKosM_TitleCardRedAct:
                binclude "data/General/Sprites/Title Card/Title Card Red ACT.kosm"
                even
ArtKosM_AIZTitleCard:
                binclude "data/Levels/AIZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_HCZTitleCard:
                binclude "data/Levels/HCZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_MGZTitleCard:
                binclude "data/Levels/MGZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_CNZTitleCard:
                binclude "data/Levels/CNZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_FBZTitleCard:
                binclude "data/Levels/FBZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_ICZTitleCard:
                binclude "data/Levels/ICZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_LBZTitleCard:
                binclude "data/Levels/LBZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_ALZTitleCard:
                binclude "data/Levels/ALZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_BPZTitleCard:
                binclude "data/Levels/BPZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_CGZTitleCard:
                binclude "data/Levels/CGZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_DPZTitleCard:
                binclude "data/Levels/DPZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_EMZTitleCard:
                binclude "data/Levels/EMZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_BonusTitleCard:
                binclude "data/General/Sprites/Title Card/Bonus Title Card.kosm"
                even
Pal_SaveMenuBG:
                binclude "data/General/Save Menu/Palettes/BG.bin"
                even
Pal_CompetitionMenuBG:
                binclude "data/General/Competition Menu/Palettes/BG.bin"
                even
MapEni_S3MenuBG:
                binclude "data/General/Save Menu/Enigma Map/Menu BG.eni"
                even
ArtKos_S3MenuBG:
                binclude "data/General/Save Menu/Kosinski Art/Menu BG.kos"
                even
MapEni_CompetitionLevBorder:
                binclude "data/General/Competition Menu/Enigma Map/Level Border.eni"
                even
MapUnc_CompetitionTimeBorder:
                binclude "data/General/Competition Menu/Uncompressed Map/Time Border.bin"
                even
MapUnc_CompetitionBESTTIME:
                binclude "data/General/Competition Menu/Uncompressed Map/Time Text.bin"
                even
MapEni_CompetitionLevImage:
                binclude "data/General/Competition Menu/Enigma Map/Level Images.eni"
                even
MapEni_CompetitionLevName:
                binclude "data/General/Competition Menu/Enigma Map/Level Names.eni"
                even
ArtKos_CompetitionMode:
                binclude "data/General/Competition Menu/Kosinski Art/Mode Select.kos"
                even
ArtKos_CompetitionLevel:
                binclude "data/General/Competition Menu/Kosinski Art/Level Select.kos"
                even
ArtKos_CompetitionResults:
                binclude "data/General/Competition Menu/Kosinski Art/Results.kos"
                even
Map_CompetitionPlayerSprite:
                include "src/ui/shared/competition_menu/map_competition_player_sprites.s"
ArtKos_CompetitionPlayer:
                binclude "data/General/Competition Menu/Kosinski Art/Player Sprites.kos"
                even
MapEni_SaveScreen_Layout:
                binclude "data/General/Save Menu/Enigma Map/Save Screen Layout.eni"
                even
MapUnc_SaveScreenNEW:
                binclude "data/General/Save Menu/Uncompressed Map/NEW.bin"
                even
MapPtrs_SaveScreenStatic:
                dc.l    MapUnc_SaveScreenStatic1
                dc.l    MapUnc_SaveScreenStatic2
                dc.l    MapUnc_SaveScreenStatic3
                dc.l    MapUnc_SaveScreenStatic4
MapUnc_SaveScreenStatic1:
                binclude "data/General/Save Menu/Uncompressed Map/Static 1.bin"
                even
MapUnc_SaveScreenStatic2:
                binclude "data/General/Save Menu/Uncompressed Map/Static 2.bin"
                even
MapUnc_SaveScreenStatic3:
                binclude "data/General/Save Menu/Uncompressed Map/Static 3.bin"
                even
MapUnc_SaveScreenStatic4:
                binclude "data/General/Save Menu/Uncompressed Map/Static 4.bin"
                even
ArtKos_SaveScreenMisc:
                binclude "data/General/Save Menu/Kosinski Art/Misc.kos"
                even
AIZ1_16x16_Primary_Kos:
                binclude "data/Levels/AIZ/Blocks/Act 1 Primary.kos"
                even
AIZ1_16x16_Secondary_Kos:
                binclude "data/Levels/AIZ/Blocks/Act 1 Secondary.kos"
                even
AIZ1_16x16_MainLevel_Kos:
                binclude "data/Levels/AIZ/Blocks/Act 1 Main Level.kos"
                even
AIZ1_8x8_Primary_KosM:
                binclude "data/Levels/AIZ/Tiles/Act 1 Primary.kosm"
                even
AIZ1_8x8_Secondary_KosM:
                binclude "data/Levels/AIZ/Tiles/Act 1 Secondary.kosm"
                even
AIZ1_8x8_MainLevel_KosM:
                binclude "data/Levels/AIZ/Tiles/Act 1 Main Level.kosm"
                even
AIZ1_128x128_Kos:
                binclude "data/Levels/AIZ/Chunks/Act 1.kos"
                even
AIZ1_8x8_Flames_KosM:
                binclude "data/Levels/AIZ/Tiles/Act 1 Fire Overlay.kosm"
                even
AIZ2_16x16_Primary_Kos:
                binclude "data/Levels/AIZ/Blocks/Act 2 Primary.kos"
                even
AIZ2_16x16_Secondary_Kos:
                binclude "data/Levels/AIZ/Blocks/Act 2 Secondary.kos"
                even
AIZ2_16x16_BomberShip_Kos:
                binclude "data/Levels/AIZ/Blocks/Act 2 BomberShip.kos"
                even
AIZ2_8x8_Primary_KosM:
                binclude "data/Levels/AIZ/Tiles/Act 2 Primary.kosm"
                even
AIZ2_8x8_Secondary_KosM:
                binclude "data/Levels/AIZ/Tiles/Act 2 Secondary.kosm"
                even
AIZ2_8x8_BomberShip_KosM:
                binclude "data/Levels/AIZ/Tiles/Act 2 Bombership.kosm"
                even
AIZ2_128x128_Kos:
                binclude "data/Levels/AIZ/Chunks/Act 2.kos"
                even
HCZ_16x16_Primary_Kos:
                binclude "data/Levels/HCZ/Blocks/Primary.kos"
                even
HCZ_8x8_Primary_KosM:
                binclude "data/Levels/HCZ/Tiles/Primary.kosm"
                even
HCZ_128x128_Primary_Kos:
                binclude "data/Levels/HCZ/Chunks/Primary.kos"
                even
HCZ1_16x16_Secondary_Kos:
                binclude "data/Levels/HCZ/Blocks/Act 1 Secondary.kos"
                even
HCZ1_8x8_Secondary_KosM:
                binclude "data/Levels/HCZ/Tiles/Act 1 Secondary.kosm"
                even
HCZ1_128x128_Secondary_Kos:
                binclude "data/Levels/HCZ/Chunks/Act 1 Secondary.kos"
                even
HCZ2_16x16_Secondary_Kos:
                binclude "data/Levels/HCZ/Blocks/Act 2 Secondary.kos"
                even
HCZ2_8x8_Secondary_KosM:
                binclude "data/Levels/HCZ/Tiles/Act 2 Secondary.kosm"
                even
HCZ2_128x128_Secondary_Kos:
                binclude "data/Levels/HCZ/Chunks/Act 2 Secondary.kos"
                even
MGZ_16x16_Primary_Kos:
                binclude "data/Levels/MGZ/Blocks/Primary.kos"
                even
MGZ_8x8_Primary_KosM:
                binclude "data/Levels/MGZ/Tiles/Primary.kosm"
                even
MGZ_128x128_Primary_Kos:
                binclude "data/Levels/MGZ/Chunks/Primary.kos"
                even
MGZ1_16x16_Secondary_Kos:
                binclude "data/Levels/MGZ/Blocks/Act 1 Secondary.kos"
                even
MGZ1_8x8_Secondary_KosM:
                binclude "data/Levels/MGZ/Tiles/Act 1 Secondary.kosm"
                even
MGZ1_128x128_Secondary_Kos:
                binclude "data/Levels/MGZ/Chunks/Act 1 Secondary.kos"
                even
MGZ2_16x16_Secondary_Kos:
                binclude "data/Levels/MGZ/Blocks/Act 2 Secondary.kos"
                even
MGZ2_8x8_Secondary_KosM:
                binclude "data/Levels/MGZ/Tiles/Act 2 Secondary.kosm"
                even
MGZ2_128x128_Secondary_Kos:
                binclude "data/Levels/MGZ/Chunks/Act 2 Secondary.kos"
                even
MGZ2_QuakeChunks:
                binclude "data/Levels/MGZ/Misc/Act 2 Quake Chunks.bin"
                even
CNZ_16x16_Kos:
                binclude "data/Levels/CNZ/Blocks/Primary.kos"
                even
CNZ_8x8_KosM:
                binclude "data/Levels/CNZ/Tiles/Primary.kosm"
                even
CNZ_128x128_Kos:
                binclude "data/Levels/CNZ/Chunks/Primary.kos"
                even
FBZ1_16x16_Kos:
FBZ1_8x8_KosM:
FBZ1_128x128_Kos:
FBZ2_16x16_Kos:
FBZ2_8x8_KosM:
FBZ2_128x128_Kos:
ICZ_16x16_Primary_Kos:
                binclude "data/Levels/ICZ/Blocks/Primary.kos"
                even
ICZ_8x8_Primary_KosM:
                binclude "data/Levels/ICZ/Tiles/Primary.kosm"
                even
ICZ_128x128_Primary_Kos:
                binclude "data/Levels/ICZ/Chunks/Primary.kos"
                even
ICZ1_16x16_Secondary_Kos:
                binclude "data/Levels/ICZ/Blocks/Act 1 Secondary.kos"
                even
ICZ1_8x8_Secondary_KosM:
                binclude "data/Levels/ICZ/Tiles/Act 1 Secondary.kosm"
                even
ICZ1_128x128_Secondary_Kos:
                binclude "data/Levels/ICZ/Chunks/Act 1 Secondary.kos"
                even
ICZ2_16x16_Secondary_Kos:
                binclude "data/Levels/ICZ/Blocks/Act 2 Secondary.kos"
                even
ICZ2_8x8_Secondary_KosM:
                binclude "data/Levels/ICZ/Tiles/Act 2 Secondary.kosm"
                even
ICZ2_128x128_Secondary_Kos:
                binclude "data/Levels/ICZ/Chunks/Act 2 Secondary.kos"
                even
LBZ_16x16_Primary_Kos:
                binclude "data/Levels/LBZ/Blocks/Primary.kos"
                even
LBZ1_16x16_Secondary_Kos:
                binclude "data/Levels/LBZ/Blocks/Act 1 Secondary.kos"
                even
LBZ_8x8_Primary_KosM:
                binclude "data/Levels/LBZ/Tiles/Primary.kosm"
                even
LBZ1_8x8_Secondary_KosM:
                binclude "data/Levels/LBZ/Tiles/Act 1 Secondary.kosm"
                even
LBZ1_Unknown_Kos:
                binclude "data/Levels/LBZ/Chunks/Unknown Unused.kos"
                even
LBZ1_128x128_Kos:
                binclude "data/Levels/LBZ/Chunks/Act 1.kos"
                even
LBZ2_16x16_Secondary_Kos:
                binclude "data/Levels/LBZ/Blocks/Act 2 Secondary.kos"
                even
LBZ2_16x16_DeathEgg_Kos:
                binclude "data/Levels/LBZ/Blocks/Act 2 Death Egg.kos"
                even
LBZ2_8x8_Secondary_KosM:
                binclude "data/Levels/LBZ/Tiles/Act 2 Secondary.kosm"
                even
LBZ2_8x8_DeathEgg_KosM:
                binclude "data/Levels/LBZ/Tiles/Act 2 Death Egg.kosm"
                even
LBZ2_128x128_Kos:
                binclude "data/Levels/LBZ/Chunks/Act 2.kos"
                even
LBZ2_128x128_DeathEgg_Kos:
                binclude "data/Levels/LBZ/Chunks/Act 2 Death Egg.kos"
                even
MHZ_16x16_Kos:
ArtKosM_MHZ:
MHZ_128x128_Kos:
LRZ_16x16_Kos:
ArtKosM_LRZ:
LRZ_128x128_Kos:
ALZ_16x16_Kos:
                binclude "data/Levels/ALZ/Blocks/Primary.kos"
                even
ALZ_8x8_KosM:
                binclude "data/Levels/ALZ/Tiles/Primary.kosm"
                even
ALZ_128x128_Kos:
                binclude "data/Levels/ALZ/Chunks/Primary.kos"
                even
BPZ_16x16_Kos:
                binclude "data/Levels/BPZ/Blocks/Primary.kos"
                even
BPZ_8x8_KosM:
                binclude "data/Levels/BPZ/Tiles/Primary.kosm"
                even
BPZ_128x128_Kos:
                binclude "data/Levels/BPZ/Chunks/Primary.kos"
                even
DPZ_16x16_Kos:
                binclude "data/Levels/DPZ/Blocks/Primary.kos"
                even
DPZ_8x8_KosM:
                binclude "data/Levels/DPZ/Tiles/Primary.kosm"
                even
DPZ_128x128_Kos:
                binclude "data/Levels/DPZ/Chunks/Primary.kos"
                even
CGZ_16x16_Kos:
                binclude "data/Levels/CGZ/Blocks/Primary.kos"
                even
CGZ_8x8_KosM:
                binclude "data/Levels/CGZ/Tiles/Primary.kosm"
                even
CGZ_128x128_Kos:
                binclude "data/Levels/CGZ/Chunks/Primary.kos"
                even
EMZ_16x16_Kos:
                binclude "data/Levels/EMZ/Blocks/Primary.kos"
                even
EMZ_8x8_KosM:
                binclude "data/Levels/EMZ/Tiles/Primary.kosm"
                even
EMZ_128x128_Kos:
                binclude "data/Levels/EMZ/Chunks/Primary.kos"
                even
Gumball_16x16_Kos:
                binclude "data/Levels/Gumball/Blocks/Primary.kos"
                even
Gumball_8x8_KosM:
                binclude "data/Levels/Gumball/Tiles/Gumball.kosm"
                even
Gumball_128x128_Kos:
                binclude "data/Levels/Gumball/Chunks/Primary.kos"
                even
Pachinko_16x16_Kos:
ArtKosM_Pachinko:
Pachinko_128x128_Kos:
Slots_16x16_Kos:
ArtKosM_Slots:
Slots_128x128_Kos:
                org     $200000
EndOfROM:
                END
