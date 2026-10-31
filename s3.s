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
                include "src/objects/items/s3/hidden_monitor.s"
                include "src/objects/level_end/s3/signpost.s"
                include "src/game/level/s3/post_boss_cleanup.s"
                include "src/game/level/s3/post_boss_resources.s"
                include "src/objects/effects/s3/boss_explosions.s"
                include "src/objects/runtime/s3/attributes_and_children.s"
                include "src/objects/runtime/s3/raw_animation.s"
                include "src/objects/runtime/s3/swing_motion.s"
                include "src/objects/runtime/s3/wait_and_surface_transitions.s"
                include "src/objects/runtime/s3/child_drawing.s"
                include "src/game/level/s3/gradual_bounds.s"
                include "src/objects/runtime/s3/target_selection.s"
                include "src/objects/runtime/s3/curved_motion.s"
                include "src/objects/runtime/s3/timed_display_and_patterns.s"
                include "src/objects/runtime/s3/deletion_and_tracking.s"
                include "src/objects/runtime/s3/velocity_and_chasing.s"
                include "src/rendering/palettes/s3/object_fade.s"
                include "src/objects/runtime/s3/movement_and_drawing.s"
                include "src/objects/runtime/s3/player_interactions.s"
                include "src/rendering/palettes/s3/rotation_script.s"
                include "src/objects/runtime/s3/child_initialization.s"
                include "src/objects/runtime/s3/offscreen_wait.s"
                include "src/audio/s3/level_music_transition.s"
                include "src/objects/level_end/s3/signpost_control.s"
                include "src/game/level/s3/act_transition.s"
                include "src/objects/effects/s3/sound_and_color_callbacks.s"
                include "src/objects/level_end/s3/boss_completion.s"
                include "src/rendering/s3/player_and_animal_patterns.s"
                include "src/rendering/s3/animal_pattern_lists.s"
                include "src/game/level/s3/ring_awards.s"
                include "src/objects/level_end/s3/egg_capsule.s"
                include "src/objects/level_end/s3/capsule_resources.s"
                include "src/objects/enemies/aiz/s3/bloominator.s"
                include "src/objects/enemies/aiz/s3/rhinobot.s"
                include "src/objects/enemies/aiz/s3/monkey_dude.s"
                include "src/objects/enemies/hcz/s3/caterkiller_jr.s"
                include "src/objects/enemies/hcz/s3/jawz.s"
                include "src/objects/enemies/hcz/s3/blastoid.s"
                include "src/objects/enemies/hcz/s3/buggernaut.s"
                include "src/objects/enemies/hcz/s3/turbo_spiker.s"
                include "src/objects/enemies/hcz/s3/mega_chopper.s"
                include "src/objects/enemies/hcz/s3/poindexter.s"
                include "src/objects/enemies/mgz/s3/bubbles.s"
                include "src/objects/bosses/mgz/miniboss/s3/tunnelbot_and_battle.s"
                include "src/objects/bosses/mgz/miniboss/s3/object_catalog.s"
                include "src/objects/enemies/mgz/s3/spiker.s"
                include "src/objects/enemies/mgz/s3/mantis.s"
                include "src/objects/enemies/cnz/s3/clamer.s"
                include "src/objects/enemies/cnz/s3/sparkle.s"
                include "src/objects/enemies/fbz/s3/batbot.s"
                include "src/objects/enemies/fbz/s3/blaster.s"
                include "src/objects/enemies/fbz/s3/techno_squeek.s"
                include "src/objects/terrain/icz/s3/path_platform.s"
                include "src/objects/terrain/icz/s3/breakable_ice.s"
                include "src/objects/terrain/icz/s3/crushing_column.s"
                include "src/objects/terrain/icz/s3/freezer.s"
                include "src/objects/terrain/icz/s3/segment_column.s"
                include "src/objects/terrain/icz/s3/swinging_platform.s"
                include "src/objects/terrain/icz/s3/stalactite.s"
                include "src/objects/terrain/icz/s3/ice_spikes.s"
                include "src/objects/terrain/icz/s3/ice_cube.s"
                include "src/objects/terrain/icz/s3/harmful_ice.s"
                include "src/objects/terrain/icz/s3/snow_pile.s"
                include "src/objects/terrain/icz/s3/tension_platform.s"
                include "src/objects/enemies/icz/s3/penguinator.s"
                include "src/objects/enemies/icz/s3/star_pointer.s"
                include "src/objects/enemies/icz/s3/snale_blaster.s"
                include "src/objects/enemies/lbz/s3/ribot.s"
                include "src/objects/enemies/lbz/s3/orbinaut.s"
                include "src/objects/enemies/lbz/s3/corkey.s"
                include "src/objects/enemies/lbz/s3/flybot_767.s"
                include "src/objects/bosses/lbz/s3/act1_robotnik_scene.s"
                include "src/objects/bosses/lbz/s3/act2_robotnik_ship.s"
                include "src/game/level/s3/resource_load_records.s"
                include "src/rendering/s3/pattern_load_catalog.s"
                include "src/system/debug/s3/placement_control.s"
                include "src/system/debug/s3/placement_catalog.s"
                include "src/objects/s3/world/object_catalog.s"
                include "src/game/level/s3/character_start_records.s"
                include "src/game/level/s3/placement_pointers.s"
                include "src/game/level/s3/main_zone_placements.s"
                include "src/game/level/s3/automatic_tunnel_paths.s"
                include "src/game/level/s3/competition_and_unused_placements.s"
                include "src/game/special_stage/s3/layout_catalog.s"
                include "src/rendering/s3/waterline_scroll_resources.s"
                include "src/collision/s3/height_and_angle_resources.s"
                include "src/collision/s3/zone_collision_catalog.s"
                include "src/game/level/s3/layout_catalog.s"
                include "src/rendering/s3/palettes/resource_catalog.s"
                include "src/rendering/s3/common_sprite_resource_catalog.s"
                include "src/rendering/s3/zone_animation_resources.s"
                include "src/ui/s3/title_and_menu_art_catalog.s"
                include "src/game/demo/s3/input_resource_catalog.s"
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

DAC_86_Data:            include "src/audio/dac/shared/sample_86.inc"
DAC_81_Data:            include "src/audio/dac/shared/sample_81.inc"
DAC_82_83_84_85_Data:   include "src/audio/dac/shared/sample_82_85.inc"
DAC_94_95_96_97_Data:   include "src/audio/dac/shared/sample_94_97.inc"
DAC_90_91_92_93_Data:   include "src/audio/dac/shared/sample_90_93.inc"
DAC_88_Data:            include "src/audio/dac/shared/sample_88.inc"
DAC_8A_8B_Data:         include "src/audio/dac/shared/sample_8a_8b.inc"
DAC_8C_Data:            include "src/audio/dac/shared/sample_8c.inc"
DAC_8D_8E_Data:         include "src/audio/dac/shared/sample_8d_8e.inc"
DAC_87_Data:            include "src/audio/dac/shared/sample_87.inc"
DAC_8F_Data:            include "src/audio/dac/shared/sample_8f.inc"
DAC_89_Data:            include "src/audio/dac/shared/sample_89.inc"
DAC_98_99_9A_Data:      include "src/audio/dac/shared/sample_98_9a.inc"

                finishBank

                align   $1000

                include "Sound/Z80 Sound Driver.s"

; ---------------------------------------------------------------------------
; Dac Bank 2
; ---------------------------------------------------------------------------
DacBank2:       startDACBank

DAC_9B_Data:    include "src/audio/dac/shared/sample_9b.inc"
DAC_9C_Data:    include "src/audio/dac/s3/sample_9c.inc"
DAC_9D_Data:    include "src/audio/dac/s3/sample_9d.inc"
DAC_9E_Data:    include "src/audio/dac/s3/sample_9e.inc"
DAC_9F_Data:    include "src/audio/dac/s3/sample_9f.inc"
DAC_A0_Data:    include "src/audio/dac/s3/sample_a0.inc"
DAC_A1_Data:    include "src/audio/dac/s3/sample_a1.inc"
DAC_A2_Data:    include "src/audio/dac/s3/sample_a2.inc"
DAC_A3_Data:    include "src/audio/dac/s3/sample_a3.inc"
DAC_A4_Data:    include "src/audio/dac/s3/sample_a4.inc"
DAC_A5_Data:    include "src/audio/dac/s3/sample_a5.inc"
DAC_A6_Data:    include "src/audio/dac/s3/sample_a6.inc"
DAC_A7_Data:    include "src/audio/dac/s3/sample_a7.inc"
DAC_A8_Data:    include "src/audio/dac/s3/sample_a8.inc"
DAC_A9_Data:    include "src/audio/dac/s3/sample_a9.inc"
DAC_AA_Data:    include "src/audio/dac/s3/sample_aa.inc"

                finishBank

; ---------------------------------------------------------------------------
; Dac Bank 3
; ---------------------------------------------------------------------------
DacBank3:       startDACBank

DAC_AB_Data:                include "src/audio/dac/s3/sample_ab.inc"
DAC_AC_Data:                include "src/audio/dac/s3/sample_ac.inc"
DAC_AD_AE_Data:             include "src/audio/dac/s3/sample_ad_ae.inc"
DAC_AF_B0_Data:             include "src/audio/dac/s3/sample_af_b0.inc"
DAC_Unused_Data:            include "src/audio/dac/s3/unused_sample.inc"
DAC_B1_Data:                include "src/audio/dac/s3/sample_b1.inc"
DAC_B2_B3_Data:             include "src/audio/dac/s3/sample_b2_b3.inc"
DAC_B4_C1_C2_C3_C4_Data:    include "src/audio/dac/s3/sample_b4c1_c4.inc"
DAC_B5_Data:                include "src/audio/dac/s3/sample_b5.inc"
DAC_B6_Data:                include "src/audio/dac/s3/sample_b6.inc"
DAC_B7_Data:                include "src/audio/dac/s3/sample_b7.inc"
DAC_B8_B9_Data:             include "src/audio/dac/s3/sample_b8_b9.inc"
DAC_BA_Data:                include "src/audio/dac/s3/sample_ba.inc"
DAC_BB_Data:                include "src/audio/dac/s3/sample_bb.inc"
DAC_BC_Data:                include "src/audio/dac/s3/sample_bc.inc"
DAC_BD_Data:                include "src/audio/dac/s3/sample_bd.inc"
DAC_BE_Data:                include "src/audio/dac/s3/sample_be.inc"
DAC_BF_Data:                include "src/audio/dac/s3/sample_bf.inc"
DAC_C0_Data:                include "src/audio/dac/s3/sample_c0.inc"

                finishBank

; ===========================================================================
; Sound Bank
; ===========================================================================
SndBank:        startBank

SEGA_PCM:       include "src/audio/pcm/shared/sega_voice.inc"

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
