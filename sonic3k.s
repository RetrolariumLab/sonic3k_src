; Sibling engine assembly order; semantic extraction is in progress
                include "src/system/sk/bootstrap.s"
                include "src/system/sk/video_interrupts.s"
                include "src/system/sk/horizontal_interrupts.s"
                include "src/system/sk/device_services.s"
                include "src/game/modes/sk/pause.s"
                include "src/rendering/sk/vram_dma.s"
                include "src/rendering/compression/sk/nemesis.s"
                include "src/rendering/compression/sk/nemesis_queue.s"
                include "src/rendering/compression/sk/enigma.s"
                include "src/rendering/compression/sk/kosinski_streaming.s"
                include "src/system/sk/runtime_primitives.s"
                include "src/rendering/palettes/sk/zone_cycles.s"
                include "src/rendering/palettes/sk/zone_cycle_colours.s"
                include "src/rendering/palettes/sk/transformation_cycles.s"
                include "src/rendering/palettes/sk/fades_and_loading.s"
                include "src/game/modes/sk/title_screen.s"
                include "src/game/modes/sk/title_widgets.s"
                include "src/game/modes/sk/title_data.s"
                include "src/game/modes/sk/standalone_title_screen.s"
                include "src/game/modes/sk/standalone_title_characters.s"
                include "src/game/modes/sk/standalone_title_badges.s"
                include "src/game/modes/sk/standalone_title_display.s"
                include "src/game/modes/sk/standalone_title_data.s"
                include "src/audio/sk/level_music_playlist.s"
                include "src/game/level/sk/mode_and_attract.s"
                include "src/game/level/sk/player_spawn.s"
                include "src/game/level/sk/environment_state.s"
                include "src/game/level/sk/water_tunnel_motion.s"
                include "src/game/level/sk/water_interrupt_tables.s"
                include "src/game/level/sk/demo_input.s"
                include "src/game/level/sk/collision_and_oscillation.s"
                include "src/game/level/sk/environment_loading.s"
                include "src/game/modes/sk/level_selection.s"
                include "src/game/modes/sk/level_selection_data.s"
                include "src/game/special_stage/sk/mode_and_display.s"
                include "src/game/special_stage/sk/palette_catalog.s"
                include "src/game/special_stage/sk/number_display.s"
                include "src/game/special_stage/sk/object_allocation.s"
                include "src/game/special_stage/sk/player_and_start_cues.s"
                include "src/game/special_stage/sk/tails_follower.s"
                include "src/game/special_stage/sk/projected_character_motion.s"
                include "src/game/special_stage/sk/sprite_rendering.s"
                include "src/game/special_stage/sk/sphere_contacts.s"
                include "src/game/modes/sk/competition_menu.s"
                include "src/game/modes/sk/competition_zone_selection.s"
                include "src/game/modes/sk/competition_player_selection.s"
                include "src/game/modes/sk/competition_results.s"
                include "src/game/modes/sk/time_attack_records.s"
                include "src/rendering/sk/menu_transfers.s"
                include "src/game/persistence/sk/sram_storage.s"
                include "src/game/modes/sk/save_screen.s"
                include "src/game/modes/sk/save_screen_data.s"
                include "src/game/modes/sk/save_slot_widgets.s"
                include "src/game/modes/sk/save_slot_erase.s"
                include "src/game/modes/sk/save_slot_text.s"
                include "src/rendering/sk/hud.s"
                include "src/rendering/sk/hud_fonts.s"
                include "src/objects/rings/sk/ring_runtime.s"
                include "src/objects/rings/sk/ring_rendering.s"
                include "src/game/collision/sk/surface_attachment.s"
                include "src/game/collision/sk/tile_and_floor_probes.s"
                include "src/game/collision/sk/wall_probes.s"
                include "src/game/collision/sk/floor_clearance.s"
                include "src/game/collision/sk/wall_and_ceiling_clearance.s"
                include "src/game/collision/sk/object_touch_response.s"
                include "src/objects/players/sonic/sk/competition_player.s"
                include "src/objects/players/sonic/sk/lifecycle.s"
                include "src/objects/players/sonic/sk/environment_and_modes.s"
                include "src/objects/players/sonic/sk/ground_movement.s"
                include "src/objects/players/sonic/sk/rolling_and_air_steering.s"
                include "src/objects/players/sonic/sk/jump_actions.s"
                include "src/objects/players/common/sk/transformation_and_spindash.s"
                include "src/objects/players/common/sk/slope_physics.s"
                include "src/objects/players/sonic/sk/terrain_landing.s"
                include "src/objects/players/common/sk/damage_and_respawn.s"
                include "src/objects/players/sonic/sk/animation_and_patterns.s"
                include "src/objects/players/common/sk/competition_animation.s"
                include "src/objects/players/tails/sk/competition_player.s"
                include "src/objects/players/tails/sk/lifecycle.s"
                include "src/objects/players/tails/sk/ai_tracking.s"
                include "src/objects/players/tails/sk/ai_scripted_sequences.s"
                include "src/objects/players/tails/sk/carrying.s"
                include "src/objects/players/tails/sk/environment_and_modes.s"
                include "src/objects/players/tails/sk/flight_and_swim.s"
                include "src/objects/players/tails/sk/ground_movement.s"
                include "src/objects/players/tails/sk/rolling_and_air_steering.s"
                include "src/objects/players/tails/sk/jump_actions.s"
                include "src/objects/players/tails/sk/spindash.s"
                include "src/objects/players/tails/sk/terrain_landing.s"
                include "src/objects/players/tails/sk/damage_and_respawn.s"
                include "src/objects/players/tails/sk/animation_and_patterns.s"
                include "src/objects/players/tails/sk/competition_and_tail_display.s"
                include "src/objects/zones/mgz/sk/boss_transition.s"
                include "src/objects/players/knuckles/sk/lifecycle.s"
                include "src/objects/players/knuckles/sk/environment_and_modes.s"
                include "src/objects/players/knuckles/sk/glide_and_climbing.s"
                include "src/objects/players/knuckles/sk/glide_motion.s"
                include "src/objects/players/knuckles/sk/ground_movement.s"
                include "src/objects/players/knuckles/sk/rolling_and_air_steering.s"
                include "src/objects/players/knuckles/sk/jump_actions.s"
                include "src/objects/players/knuckles/sk/damage_and_respawn.s"
                include "src/objects/players/knuckles/sk/animation_and_patterns.s"
                include "src/objects/players/common/sk/air_supply.s"
                include "src/objects/effects/sk/legacy_defense.s"
                include "src/objects/effects/sk/transient_player_effects.s"
                include "src/objects/effects/sk/elemental_shields.s"
                include "src/objects/effects/sk/super_player_effects.s"
                include "src/objects/rings/sk/ring_objects.s"
                include "src/objects/runtime/sk/execution_and_animation.s"
                include "src/rendering/sk/normal_sprite_renderer.s"
                include "src/rendering/sk/competition_sprite_renderer.s"
                include "src/objects/runtime/sk/visibility_and_culling.s"
                include "src/objects/runtime/sk/sprite_spawning.s"
                include "src/game/level/sk/bounds_catalog.s"
                include "src/game/level/sk/camera.s"
                include "src/game/level/sk/resource_setup.s"
                include "src/game/level/sk/camera_bounds_events.s"
                include "src/rendering/zones/lrz/sk/foreground_rocks.s"
                include "src/objects/shared/sk/path_switcher.s"
                include "src/objects/zones/soz/sk/path_switcher.s"
                include "src/objects/items/sk/monitor.s"
                include "src/game/collision/sk/solid_rectangles.s"
                include "src/game/collision/sk/solid_slopes_and_riding.s"
                include "src/objects/effects/sk/explosion_states.s"
                include "src/objects/zones/aiz/sk/static_decorations.s"
                include "src/objects/shared/sk/spin_trigger.s"
                include "src/objects/shared/sk/legacy_lava_markers.s"
                include "src/objects/shared/sk/invisible_solids.s"
                include "src/objects/zones/hcz/sk/breakable_bar.s"
                include "src/objects/zones/hcz/sk/wave_splash.s"
                include "src/objects/zones/hcz/sk/solid_block.s"
                include "src/objects/shared/sk/damage_regions.s"
                include "src/objects/zones/aiz/sk/hollow_tree.s"
                include "src/objects/shared/sk/breakable_rocks.s"
                include "src/objects/shared/sk/rock_break_responses.s"
                include "src/objects/shared/sk/collapsing_platforms.s"
                include "src/objects/shared/sk/breakable_walls.s"
                include "src/objects/zones/aiz/sk/ride_vine.s"
                include "src/objects/zones/aiz/sk/giant_ride_vine.s"
                include "src/objects/zones/mhz/sk/swing_vine.s"
                include "src/objects/shared/springs/sk/initialization.s"
                include "src/objects/shared/springs/sk/axis_response.s"
                include "src/objects/shared/springs/sk/diagonal_response.s"
                include "src/objects/shared/springs/sk/retracting.s"
                include "src/objects/shared/sk/spikes.s"
                include "src/rendering/sk/art_scaling.s"
                include "src/objects/shared/sk/twisted_ramp.s"
                include "src/objects/zones/lbz/sk/moving_platforms.s"
                include "src/objects/zones/lbz/sk/unused_bar_platform.s"
                include "src/objects/shared/sk/floating_platforms.s"
                include "src/objects/zones/hcz/sk/snake_blocks.s"
                include "src/objects/zones/lrz/sk/solid_moving_platforms.s"
                include "src/objects/zones/dez/sk/floating_platform.s"
                include "src/objects/zones/lbz/sk/unused_elevator.s"
                include "src/objects/zones/lbz/sk/exploding_trigger.s"
                include "src/objects/zones/mgz/sk/dash_trigger.s"
                include "src/objects/zones/lbz/sk/trigger_bridge.s"
                include "src/objects/zones/lbz/sk/player_launcher.s"
                include "src/objects/zones/lbz/sk/flamethrower.s"
                include "src/objects/zones/lbz/sk/ride_grapple.s"
                include "src/objects/zones/lbz/sk/cup_elevator.s"
                include "src/objects/zones/lbz/sk/unused_tilting_bridge.s"
                include "src/objects/zones/lbz/sk/pipe_plug.s"
                include "src/rendering/tile_animation/sk/dispatch.s"
                include "src/rendering/zones/aiz/sk/tile_animation.s"
                include "src/rendering/zones/hcz/sk/tile_animation.s"
                include "src/rendering/tile_animation/sk/marble_and_carnival.s"
                include "src/rendering/zones/icz/sk/tile_animation.s"
                include "src/rendering/zones/lbz/sk/tile_animation.s"
                include "src/rendering/zones/mhz/sk/tile_animation.s"
                include "src/rendering/zones/soz/sk/tile_animation.s"
                include "src/rendering/zones/lrz/sk/tile_animation.s"
                include "src/rendering/tile_animation/sk/bonus_modes.s"
                include "src/rendering/tile_animation/sk/script_player.s"
                include "src/rendering/tile_animation/sk/early_zone_scripts.s"
                include "src/rendering/tile_animation/sk/later_zone_scripts.s"
                include "src/rendering/tile_animation/sk/remaining_scripts.s"
                include "src/rendering/tile_animation/sk/initialization.s"
                include "src/objects/zones/lbz/sk/spin_launcher.s"
                include "src/objects/zones/lbz/sk/lowering_grapple.s"
                include "src/objects/shared/sk/smashing_pillar.s"
                include "src/objects/zones/lbz/sk/gate_laser.s"
                include "src/objects/zones/lbz/sk/alarm.s"
                include "src/objects/zones/lbz/sk/unused_force_fall.s"
                include "src/objects/shared/sk/automatic_tunnel.s"
                include "src/objects/shared/sk/tunnel_exhaust.s"
                include "src/objects/zones/lbz/sk/tube_elevator.s"
                include "src/objects/zones/aiz/sk/disappearing_floor.s"
                include "src/objects/shared/sk/cork_floor.s"
                include "src/objects/shared/sk/cork_floor_mappings.s"
                include "src/objects/zones/aiz/sk/flipping_bridge.s"
                include "src/objects/zones/aiz/sk/collapsing_log_bridge.s"
                include "src/objects/zones/aiz/sk/drawbridge.s"
                include "src/objects/zones/aiz/sk/falling_log.s"
                include "src/objects/zones/aiz/sk/spiked_log.s"
                include "src/objects/scenery/sk/static_sprites.s"
                include "src/objects/scenery/sk/animated_sprites.s"
                include "src/objects/zones/aiz/sk/foreground_plants.s"
                include "src/objects/zones/lbz/sk/rolling_drum.s"
                include "src/objects/shared/sk/buttons.s"
                include "src/objects/shared/sk/animals_and_score.s"
                include "src/objects/checkpoints/sk/starpost.s"
                include "src/objects/interface/sk/game_over.s"
                include "src/objects/interface/sk/title_card.s"
                include "src/objects/interface/sk/level_results.s"
                include "src/game/special_stage/sk/results_mode.s"
                include "src/objects/interface/sk/special_results_coordinator.s"
                include "src/objects/interface/sk/special_results_catalog.s"
                include "src/objects/interface/sk/special_results_widgets.s"
                include "src/objects/interface/sk/result_mappings.s"
                include "src/rendering/sk/enemy_art_loading.s"
                include "src/objects/zones/hcz/sk/water_and_air_objects.s"
                include "src/objects/zones/hcz/sk/fans.s"
                include "src/objects/zones/hcz/sk/hand_launcher.s"
                include "src/objects/shared/sk/doors.s"
                include "src/objects/zones/hcz/sk/conveyor_belt.s"
                include "src/objects/zones/cnz/sk/balloon.s"
                include "src/objects/zones/cnz/sk/cannon.s"
                include "src/objects/zones/cnz/sk/rising_platform.s"
                include "src/objects/zones/cnz/sk/trap_door.s"
                include "src/objects/zones/cnz/sk/light_bulb.s"
                include "src/objects/zones/cnz/sk/hover_fan.s"
                include "src/objects/zones/cnz/sk/vacuum_tube.s"
                include "src/objects/zones/cnz/sk/cylinder.s"
                include "src/objects/zones/hcz/sk/spinning_column.s"
                include "src/objects/zones/cnz/sk/giant_wheel.s"
                include "src/objects/zones/cnz/sk/triangle_bumpers.s"
                include "src/objects/shared/sk/sinking_mud.s"
                include "src/objects/competition/sk/triangle_bumpers.s"
                include "src/objects/shared/sk/bumpers.s"
                include "src/objects/zones/cnz/sk/spiral_tube.s"
                include "src/objects/zones/cnz/sk/barber_pole.s"
                include "src/objects/zones/cnz/sk/wire_cage.s"
                include "src/objects/zones/mgz/sk/twisting_loop.s"
                include "src/objects/zones/mgz/sk/swinging_platform.s"
                include "src/objects/zones/mgz/sk/swinging_spike_ball.s"
                include "src/objects/zones/mgz/sk/head_trigger.s"
                include "src/objects/zones/mgz/sk/trigger_platform.s"
                include "src/objects/zones/mgz/sk/moving_spike_platform.s"
                include "src/objects/zones/mgz/sk/pulley.s"
                include "src/objects/zones/mgz/top_platform/sk/state_and_riders.s"
                include "src/objects/zones/mgz/top_platform/sk/terrain_physics.s"
                include "src/objects/zones/mgz/top_platform/sk/scripted_paths.s"
                include "src/objects/zones/mgz/sk/top_launcher.s"
                include "src/objects/competition/sk/blade_platform.s"
                include "src/objects/competition/sk/elephant_block.s"
                include "src/objects/competition/sk/balloon.s"
                include "src/objects/competition/sk/dissolving_sand_bar.s"
                include "src/objects/competition/sk/desert_button.s"
                include "src/objects/competition/sk/item_objects.s"
                include "src/objects/competition/sk/goal_and_laps.s"
                include "src/objects/competition/sk/neon_display.s"
                include "src/objects/competition/sk/race_hud.s"
                include "src/objects/zones/emz/sk/dripper.s"
                include "src/objects/shared/sk/water_drop.s"
                include "src/objects/zones/hcz/sk/water_splash.s"
                include "src/objects/shared/tension_bridge/sk/state_and_segments.s"
                include "src/objects/shared/tension_bridge/sk/bending_and_collision.s"
                include "src/objects/shared/tension_bridge/sk/mappings.s"
                include "src/objects/zones/hcz/sk/twisting_loop.s"
                include "src/objects/zones/icz/sk/snowboard_intro.s"
                include "src/objects/shared/sk/intro_player_launch.s"
                include "src/objects/zones/icz/sk/tails_intro.s"
                include "src/objects/zones/lrz/sk/collapsing_bridge.s"
                include "src/objects/zones/fbz/sk/wire_cages.s"
                include "src/objects/zones/fbz/sk/floating_platform.s"
                include "src/objects/zones/fbz/sk/chain_link.s"
                include "src/objects/zones/fbz/sk/magnetic_spike_ball.s"
                include "src/objects/zones/fbz/sk/magnetic_platform.s"
                include "src/objects/zones/fbz/sk/snake_platform.s"
                include "src/objects/zones/fbz/sk/bent_pipe.s"
                include "src/objects/zones/fbz/sk/rotating_platform.s"
                include "src/objects/zones/fbz/sk/player_launcher.s"
                include "src/objects/zones/fbz/sk/disappearing_platform.s"
                include "src/objects/zones/fbz/sk/screw_door.s"
                include "src/objects/zones/fbz/sk/spinning_pole.s"
                include "src/objects/zones/fbz/sk/propeller.s"
                include "src/objects/zones/fbz/sk/piston.s"
                include "src/objects/zones/fbz/sk/platform_blocks.s"
                include "src/objects/zones/fbz/sk/missile_launcher.s"
                include "src/objects/zones/fbz/sk/wall_missile.s"
                include "src/objects/zones/fbz/sk/mine.s"
                include "src/objects/zones/fbz/sk/elevator.s"
                include "src/objects/zones/fbz/sk/trap_spring.s"
                include "src/objects/zones/fbz/sk/flamethrower.s"
                include "src/objects/zones/fbz/sk/spider_crane.s"
                include "src/objects/zones/fbz/sk/magnetic_pendulum.s"
                include "src/objects/zones/mhz/sk/pollen.s"
                include "src/objects/zones/mhz/sk/twisted_vine.s"
                include "src/objects/zones/mhz/sk/mushroom_cap.s"
                include "src/objects/zones/mhz/sk/pulley_lift.s"
                include "src/objects/zones/mhz/sk/curled_vine.s"
                include "src/objects/zones/mhz/sk/sticky_vine.s"
                include "src/objects/zones/mhz/sk/horizontal_swing_bar.s"
                include "src/objects/zones/mhz/sk/horizontal_swing_bar_mapping.s"
                include "src/objects/zones/mhz/sk/vertical_swing_bar.s"
                include "src/objects/zones/mhz/sk/mushroom_platform.s"
                include "src/objects/zones/mhz/sk/mushroom_parachute.s"
                include "src/objects/zones/mhz/sk/mushroom_catapult.s"
                include "src/objects/shared/sk/updraft.s"
                include "src/objects/zones/soz/sk/quicksand.s"
                include "src/objects/zones/soz/sk/spawning_sand_blocks.s"
                include "src/objects/zones/soz/sk/loop_fallthrough.s"
                include "src/objects/zones/soz/sk/pushable_rock.s"
                include "src/objects/zones/soz/sk/spring_vine.s"
                include "src/objects/zones/soz/sk/rising_sand_wall.s"
                include "src/objects/zones/soz/sk/light_switch.s"
                include "src/objects/zones/soz/sk/floating_pillar.s"
                include "src/objects/zones/soz/sk/swinging_platform.s"
                include "src/objects/zones/soz/sk/breakable_sand_rock.s"
                include "src/objects/zones/soz/sk/push_switch.s"
                include "src/objects/zones/soz/sk/door.s"
                include "src/objects/zones/soz/sk/sand_cork.s"
                include "src/objects/zones/soz/sk/solid_sprites.s"
                include "src/objects/shared/sk/intro_player_ground_fall.s"
                include "src/objects/zones/lrz/sk/corkscrew.s"
                include "src/objects/zones/lrz/sk/wall_ride.s"
                include "src/objects/zones/lrz/sk/sinking_rock.s"
                include "src/objects/zones/lrz/sk/falling_spike.s"
                include "src/objects/zones/lrz/sk/door.s"
                include "src/objects/zones/lrz/sk/big_door.s"
                include "src/objects/zones/lrz/sk/fireball_launcher.s"
                include "src/objects/zones/lrz/sk/horizontal_button.s"
                include "src/objects/zones/lrz/sk/shooting_trigger.s"
                include "src/objects/zones/lrz/sk/dash_elevator.s"
                include "src/objects/zones/lrz/sk/smashing_spike_platform.s"
                include "src/objects/zones/lrz/sk/swinging_spike_ball.s"
                include "src/objects/zones/lrz/sk/lava_fall.s"
                include "src/objects/zones/lrz/sk/spike_ball.s"
                include "src/objects/zones/lrz/sk/orbiting_spike_balls.s"
                include "src/objects/zones/lrz/sk/flamethrower.s"
                include "src/objects/zones/lrz/sk/solid_rock.s"
                include "src/objects/zones/lrz/sk/turbine_sprites.s"
                include "src/objects/zones/lrz/sk/spike_ball_launcher.s"
                include "src/objects/shared/sk/intro_player_run.s"
                include "src/objects/zones/ssz/sk/floating_platform.s"
                include "src/objects/zones/ssz/sk/collapsing_column.s"
                include "src/objects/zones/ssz/sk/collapsing_bridges.s"
                include "src/objects/zones/ssz/sk/cutscene_bridge.s"
                include "src/objects/zones/ssz/sk/bouncy_cloud.s"
                include "src/objects/zones/ssz/sk/elevator_bar.s"
                include "src/objects/zones/ssz/sk/hidden_palace_teleporter.s"
                include "src/objects/zones/ssz/sk/teleporter_beam.s"
                include "src/objects/zones/ssz/sk/rotating_platform.s"
                include "src/objects/zones/ssz/sk/swinging_carrier.s"
                include "src/objects/zones/ssz/sk/retracting_spring.s"
                include "src/objects/zones/ssz/sk/mapping_catalog.s"
                include "src/objects/zones/dez/sk/tilting_bridge.s"
                include "src/objects/zones/dez/sk/hanging_carrier.s"
                include "src/objects/zones/dez/sk/torpedo_launcher.s"
                include "src/objects/zones/dez/sk/lift_pad.s"
                include "src/objects/zones/dez/sk/staircase.s"
                include "src/objects/zones/dez/sk/conveyor_belt.s"
                include "src/objects/zones/dez/sk/lightning.s"
                include "src/objects/zones/dez/sk/conveyor_pad.s"
                include "src/objects/zones/dez/sk/energy_bridges.s"
                include "src/objects/zones/dez/sk/retracting_spring.s"
                include "src/objects/zones/dez/sk/tunnel_launcher.s"
                include "src/objects/zones/dez/sk/tunnel_control.s"
                include "src/objects/zones/dez/sk/gravity_switch.s"
                include "src/objects/zones/dez/sk/teleporter.s"
                include "src/objects/zones/dez/sk/gravity_tube.s"
                include "src/objects/zones/dez/sk/gravity_swap.s"
                include "src/objects/zones/dez/sk/gravity_hub.s"
                include "src/objects/zones/dez/sk/hover_machine.s"
                include "src/objects/zones/dez/sk/gravity_room.s"
                include "src/objects/zones/dez/sk/bumper_wall.s"
                include "src/objects/zones/dez/sk/gravity_puzzle.s"
                include "src/objects/bonus/pachinko/sk/triangle_bumper.s"
                include "src/objects/bonus/pachinko/sk/flipper.s"
                include "src/objects/bonus/pachinko/sk/energy_trap.s"
                include "src/objects/bonus/pachinko/sk/invisible_object.s"
                include "src/objects/bonus/pachinko/sk/platform.s"
                include "src/objects/bonus/pachinko/sk/item_orb.s"
                include "src/objects/bonus/sk/gumball_item.s"
                include "src/objects/bonus/pachinko/sk/magnet_orb.s"
                include "src/objects/zones/lrz/sk/chained_platforms.s"
                include "src/objects/zones/soz/sk/rappel_wire.s"
                include "src/game/bonus/slots/sk/layout_rendering.s"
                include "src/game/bonus/slots/sk/player_controller.s"
                include "src/objects/bonus/slots/sk/spike.s"
                include "src/game/bonus/slots/sk/slot_outcomes.s"
                include "src/game/blue_sphere/sk/title_mode.s"
                include "src/game/blue_sphere/sk/menu_and_stage_number.s"
                include "src/game/blue_sphere/sk/code_entry_widgets.s"
                include "src/game/blue_sphere/sk/mode_label_and_icons.s"
                include "src/game/blue_sphere/sk/title_mapping_catalog.s"
                include "src/game/blue_sphere/sk/title_footer.s"
                include "src/game/blue_sphere/sk/results_mode.s"
                include "src/game/blue_sphere/sk/results_widgets.s"
                include "src/game/blue_sphere/sk/difficulty_character_display.s"
                include "src/game/level/sk/screen_dispatch.s"
                include "src/rendering/sk/level_video_transfers.s"
                include "src/rendering/sk/tile_grid_drawing.s"
                include "src/rendering/sk/plane_refresh.s"
                include "src/rendering/sk/deformed_tile_drawing.s"
                include "src/rendering/sk/deformation_operators.s"
                include "src/game/level/sk/scroll_events.s"
                include "src/game/level/zones/aiz/sk/act1_screen.s"
                include "src/game/level/zones/aiz/sk/act2_screen_control.s"
                include "src/game/level/zones/aiz/sk/act2_air_raid.s"
                include "src/game/level/zones/hcz/sk/act1_screen.s"
                include "src/game/level/zones/hcz/sk/act2_screen.s"
                include "src/game/level/zones/mgz/sk/act1_screen.s"
                include "src/game/level/zones/mgz/sk/act2_screen_control.s"
                include "src/game/level/zones/mgz/sk/act2_collapse_background.s"
                include "src/game/level/zones/cnz/sk/act1_screen.s"
                include "src/game/level/zones/cnz/sk/act2_screen.s"
                include "src/game/level/zones/fbz/sk/act1_screen_control.s"
                include "src/game/level/zones/fbz/sk/act1_background.s"
                include "src/game/level/zones/fbz/sk/act2_screen_control.s"
                include "src/game/level/zones/fbz/sk/act2_background.s"
                include "src/game/level/zones/icz/sk/act1_screen.s"
                include "src/game/level/zones/icz/sk/act2_screen.s"
                include "src/game/level/zones/lbz/sk/act1_screen.s"
                include "src/game/level/zones/lbz/sk/act2_screen_control.s"
                include "src/game/level/zones/lbz/sk/act2_deformation.s"
                include "src/game/level/zones/mhz/sk/act1_screen.s"
                include "src/game/level/zones/mhz/sk/act2_screen_control.s"
                include "src/game/level/zones/mhz/sk/act2_background.s"
                include "src/game/level/zones/soz/sk/act1_screen.s"
                include "src/game/level/zones/soz/sk/act2_screen_control.s"
                include "src/game/level/zones/soz/sk/act2_background.s"
                include "src/game/level/zones/lrz/sk/act1_screen.s"
                include "src/game/level/zones/lrz/sk/act2_screen.s"
                include "src/game/level/zones/ssz/sk/act1_screen_control.s"
                include "src/game/level/zones/ssz/sk/act1_background.s"
                include "src/game/level/zones/ssz/sk/act1_arrival_transport.s"
                include "src/game/level/zones/ssz/sk/act1_camera_transition.s"
                include "src/game/level/zones/ssz/sk/act1_ramp_debris.s"
                include "src/game/level/zones/ssz/sk/act2_screen_control.s"
                include "src/game/level/zones/ssz/sk/act2_background.s"
                include "src/game/level/zones/dez/sk/act1_screen.s"
                include "src/game/level/zones/dez/sk/act2_screen.s"
                include "src/game/level/zones/ddz/sk/screen.s"
                include "src/game/level/zones/pachinko/sk/screen.s"
                include "src/game/level/zones/slots/sk/screen.s"
                include "src/game/level/zones/lrz/sk/act3_screen.s"
                include "src/game/level/zones/hpz/sk/screen.s"
                include "src/game/level/zones/dez/sk/act3_screen.s"
                include "src/game/level/zones/hpz/sk/special_screen.s"
                include "src/game/level/ending/sk/screen.s"
                include "src/game/level/ending/sk/background.s"
                include "src/game/modes/ending/sk/credits_sequence.s"
                include "src/game/modes/ending/sk/pose_pattern_lists.s"
                include "src/game/modes/ending/sk/scroll_parameters.s"
                include "src/game/modes/ending/sk/credits_glyphs.s"
                include "src/game/modes/ending/sk/standalone_opening_credits.s"
                include "src/game/modes/ending/sk/standalone_closing_credits.s"
                include "src/game/modes/ending/sk/lockon_opening_credits.s"
                include "src/game/modes/ending/sk/lockon_closing_credits.s"
                include "src/game/modes/continue/sk/screen.s"
                include "src/objects/interface/continue/sk/characters.s"
                include "src/objects/interface/continue/sk/countdown_and_patterns.s"
                include "src/game/modes/continue/sk/resources.s"
                include "src/objects/ending/sk/scene_controller.s"
                include "src/objects/ending/sk/master_emerald.s"
                include "src/objects/ending/sk/plane_and_knuckles.s"
                include "src/objects/ending/sk/pose_and_plane_scene.s"
                include "src/objects/ending/sk/scene_companion.s"
                include "src/objects/ending/sk/plane_attachment.s"
                include "src/objects/ending/sk/scenery_and_creatures.s"
                include "src/objects/ending/sk/result_selector.s"
                include "src/objects/ending/sk/result_banners.s"
                include "src/objects/ending/sk/character_poses.s"
                include "src/objects/ending/sk/eggman_and_egg_robo_eyecatch.s"
                include "src/objects/ending/sk/mecha_sonic_eyecatch.s"
                include "src/objects/ending/sk/result_emerald.s"
                include "src/objects/ending/sk/cloud_field.s"
                include "src/objects/interface/blue_sphere/sk/difficulty_banner_portrait.s"
                include "src/rendering/palettes/sk/ending_pose_effects.s"
                include "src/objects/ending/sk/super_character_transition.s"
                include "src/objects/ending/sk/sprite_and_pattern_helpers.s"
                include "src/objects/ending/sk/child_motion.s"
                include "src/objects/ending/sk/object_catalog.s"
                include "src/game/modes/ending/sk/graphics_and_palettes.s"
                include "src/objects/bonus/gumball/sk/machine.s"
                include "src/objects/bonus/gumball/sk/triangle_bumper.s"
                include "src/objects/bonus/gumball/sk/mechanism_helpers.s"
                include "src/objects/bonus/gumball/sk/object_catalog.s"
                include "src/objects/special_stage/sk/entry_ring.s"
                include "src/objects/special_stage/sk/entry_ring_resources.s"
                include "src/objects/cutscenes/sk/angel_island.s"
                include "src/objects/cutscenes/sk/hydrocity.s"
                include "src/objects/cutscenes/sk/carnival_encounters.s"
                include "src/objects/cutscenes/sk/launch_base.s"
                include "src/objects/cutscenes/sk/launch_base_pillar.s"
                include "src/objects/cutscenes/sk/mushroom_hill_act1.s"
                include "src/objects/cutscenes/sk/mushroom_hill_act2.s"
                include "src/objects/cutscenes/sk/opening.s"
                include "src/objects/cutscenes/sk/lava_reef.s"
                include "src/objects/cutscenes/hpz/sk/encounter.s"
                include "src/objects/cutscenes/hpz/sk/recovery.s"
                include "src/objects/cutscenes/hpz/sk/aftermath_and_player_guidance.s"
                include "src/objects/cutscenes/hpz/sk/ship.s"
                include "src/objects/cutscenes/hpz/sk/ship_attachments.s"
                include "src/objects/cutscenes/hpz/sk/effects.s"
                include "src/objects/cutscenes/hpz/sk/crane.s"
                include "src/objects/cutscenes/hpz/sk/platforms.s"
                include "src/rendering/palettes/sk/hidden_palace_control.s"
                include "src/objects/cutscenes/sk/sky_sanctuary.s"
                include "src/objects/cutscenes/sk/buttons.s"
                include "src/objects/cutscenes/sk/movement_and_collision.s"
                include "src/objects/cutscenes/sk/state_and_patterns.s"
                include "src/objects/cutscenes/sk/object_catalog.s"
                include "src/objects/cutscenes/sk/animation_and_patterns.s"
                include "src/objects/cutscenes/sk/graphics_and_palettes.s"
                include "src/objects/cutscenes/sk/angel_island_plane.s"
                include "src/objects/bosses/shared/sk/robotnik_heads.s"
                include "src/objects/bosses/shared/sk/robotnik_ships.s"
                include "src/objects/bosses/aiz/sk/miniboss_arrival.s"
                include "src/objects/bosses/aiz/sk/miniboss.s"
                include "src/objects/bosses/aiz/end_boss/sk/main_control.s"
                include "src/objects/bosses/aiz/end_boss/sk/attachments_and_attacks.s"
                include "src/objects/bosses/aiz/end_boss/sk/child_motion_helpers.s"
                include "src/objects/bosses/aiz/end_boss/sk/object_catalog.s"
                include "src/objects/bosses/hcz/miniboss/sk/main_and_loop.s"
                include "src/objects/bosses/hcz/miniboss/sk/rockets.s"
                include "src/objects/bosses/hcz/miniboss/sk/engine_and_effects.s"
                include "src/objects/bosses/hcz/miniboss/sk/motion_helpers.s"
                include "src/objects/bosses/hcz/miniboss/sk/object_catalog.s"
                include "src/objects/bosses/hcz/end_boss/sk/main_and_chassis.s"
                include "src/objects/bosses/hcz/end_boss/sk/attacks_and_transition.s"
                include "src/objects/bosses/hcz/end_boss/sk/motion_helpers.s"
                include "src/objects/bosses/hcz/end_boss/sk/object_catalog.s"
                include "src/objects/bosses/mgz/sk/drilling_arrival.s"
                include "src/objects/bosses/mgz/end_boss/sk/battle_control.s"
                include "src/objects/bosses/mgz/end_boss/sk/attachments.s"
                include "src/objects/bosses/mgz/end_boss/sk/projectiles_and_defeat.s"
                include "src/objects/bosses/mgz/end_boss/sk/motion_helpers.s"
                include "src/objects/bosses/mgz/end_boss/sk/object_catalog.s"
                include "src/objects/bosses/cnz/miniboss/sk/main_and_top.s"
                include "src/objects/bosses/cnz/miniboss/sk/coil_and_sparks.s"
                include "src/objects/bosses/cnz/miniboss/sk/motion_and_collision.s"
                include "src/objects/bosses/cnz/miniboss/sk/object_catalog.s"
                include "src/objects/bosses/cnz/end_boss/sk/battle_and_attacks.s"
                include "src/objects/bosses/cnz/end_boss/sk/motion_helpers.s"
                include "src/objects/bosses/cnz/end_boss/sk/object_catalog.s"
                include "src/objects/bosses/fbz/miniboss/sk/battle_and_attacks.s"
                include "src/objects/bosses/fbz/miniboss/sk/motion_helpers.s"
                include "src/objects/bosses/fbz/miniboss/sk/object_catalog.s"
                include "src/objects/bosses/fbz/sk/act2_subboss.s"
                include "src/objects/bosses/fbz/sk/act2_subboss_resources.s"
                include "src/objects/bosses/fbz/end_boss/sk/battle_and_attacks.s"
                include "src/objects/bosses/fbz/end_boss/sk/exit_door.s"
                include "src/objects/bosses/fbz/end_boss/sk/motion_helpers.s"
                include "src/objects/bosses/fbz/end_boss/sk/object_catalog.s"
                include "src/objects/bosses/icz/sk/miniboss.s"
                include "src/objects/bosses/icz/sk/miniboss_palette_script.s"
                include "src/objects/bosses/icz/sk/end_boss.s"
                include "src/objects/bosses/lbz/sk/miniboss.s"
                include "src/objects/bosses/lbz/final_boss_1/sk/sonic_tails_battle.s"
                include "src/objects/bosses/lbz/final_boss_1/sk/knuckles_battle.s"
                include "src/objects/bosses/lbz/final_boss_1/sk/object_catalog.s"
                include "src/objects/bosses/lbz/end_boss/sk/battle_and_attacks.s"
                include "src/objects/bosses/lbz/end_boss/sk/motion_helpers.s"
                include "src/objects/bosses/lbz/end_boss/sk/object_catalog.s"
                include "src/objects/bosses/lbz/final_boss_2/sk/battle_control.s"
                include "src/objects/bosses/lbz/final_boss_2/sk/attachments_and_effects.s"
                include "src/objects/bosses/lbz/final_boss_2/sk/motion_helpers.s"
                include "src/objects/bosses/lbz/final_boss_2/sk/object_catalog.s"
                include "src/objects/bosses/mhz/miniboss/sk/battle_control.s"
                include "src/objects/bosses/mhz/miniboss/sk/battle_helpers.s"
                include "src/objects/bosses/mhz/miniboss/sk/tree_actor.s"
                include "src/objects/bosses/mhz/miniboss/sk/motion_helpers.s"
                include "src/objects/bosses/mhz/miniboss/sk/object_catalog.s"
                include "src/objects/bosses/mhz/end_boss/sk/battle_and_attacks.s"
                include "src/objects/bosses/mhz/end_boss/sk/motion_helpers.s"
                include "src/objects/bosses/mhz/end_boss/sk/object_catalog.s"
                include "src/objects/bosses/soz/miniboss/sk/battle_and_attacks.s"
                include "src/objects/bosses/soz/miniboss/sk/motion_helpers.s"
                include "src/objects/bosses/soz/miniboss/sk/object_catalog.s"
                include "src/objects/bosses/soz/end_boss/sk/battle_and_attacks.s"
                include "src/objects/bosses/soz/end_boss/sk/motion_helpers.s"
                include "src/objects/bosses/soz/end_boss/sk/object_catalog.s"
                include "src/objects/bosses/lrz/miniboss/sk/battle_and_attacks.s"
                include "src/objects/bosses/lrz/miniboss/sk/motion_helpers.s"
                include "src/objects/bosses/lrz/miniboss/sk/object_catalog.s"
                include "src/game/level/zones/lrz/sk/act3_autoscroll.s"
                include "src/objects/bosses/lrz/end_boss/sk/battle_and_attacks.s"
                include "src/objects/bosses/lrz/end_boss/sk/platform.s"
                include "src/objects/bosses/lrz/end_boss/sk/motion_helpers.s"
                include "src/objects/bosses/lrz/end_boss/sk/object_catalog.s"
                include "src/objects/bosses/ssz/ghz/sk/battle.s"
                include "src/objects/bosses/ssz/mtz/sk/battle_control.s"
                include "src/objects/bosses/ssz/mtz/sk/attachments_and_attacks.s"
                include "src/objects/bosses/ssz/mtz/sk/motion_and_orb_helpers.s"
                include "src/objects/bosses/ssz/mtz/sk/orb_resources.s"
                include "src/objects/bosses/ssz/end_boss/sk/battle.s"
                include "src/objects/bosses/ssz/knuckles_boss/sk/battle.s"
                include "src/objects/bosses/ssz/knuckles_boss/sk/phase_helpers.s"
                include "src/objects/bosses/ssz/shared/sk/sparks_and_camera.s"
                include "src/objects/bosses/ssz/knuckles_boss/sk/crane.s"
                include "src/objects/interface/blue_sphere/sk/mecha_and_emerald_widgets.s"
                include "src/objects/bosses/ssz/shared/sk/scene_transition_callbacks.s"
                include "src/objects/bosses/ssz/shared/sk/motion_and_palette_helpers.s"
                include "src/objects/bosses/ssz/shared/sk/object_catalog.s"
                include "src/objects/bosses/dez/miniboss/sk/battle_control.s"
                include "src/objects/bosses/dez/miniboss/sk/child_attack_states.s"
                include "src/objects/bosses/dez/miniboss/sk/motion_helpers.s"
                include "src/objects/bosses/dez/miniboss/sk/object_catalog.s"
                include "src/objects/bosses/dez/end_boss/sk/battle_control.s"
                include "src/objects/bosses/dez/end_boss/sk/child_attack_states.s"
                include "src/objects/bosses/dez/end_boss/sk/motion_helpers.s"
                include "src/objects/bosses/dez/end_boss/sk/object_catalog.s"
                include "src/objects/bosses/dez/final_boss/sk/stage_controller.s"
                include "src/objects/bosses/dez/final_boss/sk/escape_ship.s"
                include "src/objects/bosses/dez/final_boss/sk/attached_control_actors.s"
                include "src/objects/bosses/dez/final_boss/sk/body_and_arm_parts.s"
                include "src/objects/bosses/dez/final_boss/sk/fireball.s"
                include "src/objects/bosses/dez/final_boss/sk/attack_and_defeat_actors.s"
                include "src/objects/bosses/dez/final_boss/sk/motion_helpers.s"
                include "src/objects/bosses/dez/final_boss/sk/object_catalog.s"
                include "src/objects/players/ddz/sk/flight_controller.s"
                include "src/objects/bosses/ddz/sk/battle_control.s"
                include "src/objects/bosses/ddz/sk/missile.s"
                include "src/objects/bosses/ddz/sk/asteroids.s"
                include "src/objects/players/ddz/sk/flight_helpers.s"
                include "src/objects/bosses/ddz/sk/tracking_and_motion_helpers.s"
                include "src/objects/bosses/ddz/sk/palette_and_defeat_helpers.s"
                include "src/objects/bosses/ddz/sk/object_catalog.s"
                include "src/objects/items/sk/hidden_monitor.s"
                include "src/objects/level_end/sk/signpost.s"
                include "src/game/level/sk/post_boss_cleanup.s"
                include "src/game/level/sk/post_boss_resources.s"
                include "src/objects/effects/sk/boss_explosions.s"
                include "src/objects/runtime/sk/attributes_and_children.s"
                include "src/objects/runtime/sk/raw_animation.s"
                include "src/objects/runtime/sk/swing_motion.s"
                include "src/objects/runtime/sk/wait_and_surface_transitions.s"
                include "src/objects/runtime/sk/child_drawing.s"
                include "src/game/level/sk/gradual_bounds.s"
                include "src/objects/runtime/sk/target_selection.s"
                include "src/objects/runtime/sk/curved_motion.s"
                include "src/objects/runtime/sk/timed_display_and_patterns.s"
                include "src/objects/runtime/sk/deletion_and_tracking.s"
                include "src/objects/runtime/sk/velocity_and_chasing.s"
                include "src/rendering/palettes/sk/object_fade_out.s"
                include "src/rendering/palettes/sk/object_fade_in.s"
                include "src/objects/runtime/sk/movement_and_drawing.s"
                include "src/objects/runtime/sk/player_interactions.s"
                include "src/rendering/palettes/sk/rotation_script.s"
                include "src/objects/runtime/sk/child_initialization.s"
                include "src/objects/runtime/sk/offscreen_wait.s"
                include "src/audio/sk/level_music_transition.s"
                include "src/objects/level_end/sk/signpost_control.s"
                include "src/game/level/sk/act_transition.s"
                include "src/objects/effects/sk/sound_and_color_callbacks.s"
                include "src/game/level/sk/boss_completion_and_patterns.s"
                include "src/rendering/sk/animal_pattern_lists.s"
                include "src/game/level/sk/ring_awards.s"
                include "src/objects/runtime/sk/object_transformations.s"
                include "src/objects/runtime/sk/angle_targeting.s"
                include "src/objects/runtime/sk/mask_and_player_callbacks.s"
                include "src/game/level/sk/level_restart_actor.s"
                include "src/objects/ending/sk/grant_super_character.s"
                include "src/objects/level_end/sk/egg_capsule.s"
                include "src/objects/level_end/sk/capsule_resources.s"
                include "src/objects/zones/fbz/sk/exit_hall.s"
                include "src/objects/enemies/aiz/sk/bloominator.s"
                include "src/objects/enemies/aiz/sk/rhinobot.s"
                include "src/objects/enemies/aiz/sk/monkey_dude.s"
                include "src/objects/enemies/hcz/sk/caterkiller_jr.s"
                include "src/objects/enemies/hcz/sk/jawz.s"
                include "src/objects/enemies/hcz/sk/blastoid.s"
                include "src/objects/enemies/hcz/sk/buggernaut.s"
                include "src/objects/enemies/hcz/sk/turbo_spiker.s"
                include "src/objects/enemies/hcz/sk/mega_chopper.s"
                include "src/objects/enemies/hcz/sk/poindexter.s"
                include "src/objects/enemies/mgz/sk/bubbles.s"
                include "src/objects/bosses/mgz/miniboss/sk/tunnelbot_and_battle.s"
                include "src/objects/bosses/mgz/miniboss/sk/object_catalog.s"
                include "src/objects/enemies/mgz/sk/spiker.s"
                include "src/objects/enemies/mgz/sk/mantis.s"
                include "src/objects/enemies/cnz/sk/clamer.s"
                include "src/objects/enemies/cnz/sk/sparkle.s"
                include "src/objects/enemies/fbz/sk/batbot.s"
                include "src/objects/enemies/fbz/sk/blaster.s"
                include "src/objects/enemies/fbz/sk/techno_squeek.s"
                include "src/objects/terrain/icz/sk/path_platform.s"
                include "src/objects/terrain/icz/sk/breakable_ice.s"
                include "src/objects/terrain/icz/sk/crushing_column.s"
                include "src/objects/terrain/icz/sk/freezer.s"
                include "src/objects/terrain/icz/sk/segment_column.s"
                include "src/objects/terrain/icz/sk/swinging_platform.s"
                include "src/objects/terrain/icz/sk/stalactite.s"
                include "src/objects/terrain/icz/sk/ice_spikes.s"
                include "src/objects/terrain/icz/sk/ice_cube.s"
                include "src/objects/terrain/icz/sk/harmful_ice.s"
                include "src/objects/terrain/icz/sk/snow_pile.s"
                include "src/objects/terrain/icz/sk/tension_platform.s"
                include "src/objects/enemies/icz/sk/penguinator.s"
                include "src/objects/enemies/icz/sk/star_pointer.s"
                include "src/objects/enemies/icz/sk/snale_blaster.s"
                include "src/objects/enemies/lbz/sk/ribot.s"
                include "src/objects/enemies/lbz/sk/orbinaut.s"
                include "src/objects/enemies/lbz/sk/corkey.s"
                include "src/objects/enemies/lbz/sk/flybot_767.s"
                include "src/objects/bosses/lbz/sk/act1_robotnik_scene.s"
                include "src/objects/bosses/lbz/sk/act2_robotnik_ship.s"
                include "src/objects/enemies/sk/madmole.s"
                include "src/objects/enemies/sk/mushmeanie.s"
                include "src/objects/enemies/sk/dragonfly.s"
                include "src/objects/enemies/sk/butterdroid.s"
                include "src/objects/enemies/sk/cluckoid.s"
                include "src/objects/enemies/sk/skorp.s"
                include "src/objects/enemies/sk/sandworm.s"
                include "src/objects/enemies/sk/rockn.s"
                include "src/objects/zones/soz/sk/ghost_controller.s"
                include "src/objects/zones/soz/sk/ghost_capsule.s"
                include "src/objects/zones/soz/sk/ghost_motion.s"
                include "src/objects/zones/soz/sk/ghost_resources.s"
                include "src/objects/enemies/sk/fireworm.s"
                include "src/objects/enemies/sk/iwamodoki.s"
                include "src/objects/enemies/sk/toxomister.s"
                include "src/objects/zones/lrz/sk/rock_crusher.s"
                include "src/objects/zones/hpz/sk/master_emerald.s"
                include "src/objects/zones/hpz/sk/super_emerald.s"
                include "src/objects/zones/hpz/sk/special_stage_control.s"
                include "src/objects/zones/hpz/sk/emerald_resources.s"
                include "src/objects/enemies/sk/egg_robo.s"
                include "src/objects/enemies/sk/spikebonker.s"
                include "src/objects/enemies/sk/chainspike.s"
                include "src/game/level/sk/resource_load_records.s"
                include "src/rendering/sk/pattern_load_catalog.s"
                include "src/system/debug/sk/placement_control.s"
                include "src/system/debug/sk/placement_catalog.s"
                include "src/objects/sk/world/object_catalog.s"
                include "src/collision/sk/height_and_angle_resources.s"
                include "src/collision/sk/zone_collision_catalog.s"
                include "src/game/level/sk/layout_catalog.s"
                include "src/rendering/sk/palettes/resource_catalog.s"
                include "src/rendering/sk/common_sprite_resource_catalog.s"
                include "src/rendering/sk/zone_animation_resources.s"
                include "src/ui/sk/competition_options_resources.s"
                include "src/game/level/zones/lrz/sk/rock_placement_resources.s"
                include "src/ui/sk/title_resource_catalog.s"
                include "src/ui/sk/results_and_title_card_resources.s"
                include "src/rendering/sk/actor_and_ending_resource_catalog.s"
                include "src/game/lockon/sk/sonic2_placement_catalog.s"
; ===========================================================================
; Music Banks
; ===========================================================================
                cnop    -Size_of_Snd_Bank1, $8000       ; aligned to end of bank

; ---------------------------------------------------------------------------
; Music Bank 1
; ---------------------------------------------------------------------------
Snd_Bank1_Start:
Snd_SKCredits:  binclude "data/Sound/SMPS/sk/Music/Credits (Sonic & Knuckles).bin"
Snd_GameOver:   binclude "data/Sound/SMPS/sk/Music/Game Over.bin"
Snd_Continue:   binclude "data/Sound/SMPS/sk/Music/Continue (Sonic & Knuckles).bin"
Snd_Results:    binclude "data/Sound/SMPS/sk/Music/Level Outro.bin"
Snd_Invic:      binclude "data/Sound/SMPS/sk/Music/Invincible (Sonic & Knuckles).bin"
Snd_Menu:       binclude "data/Sound/SMPS/sk/Music/Menu (Sonic & Knuckles).bin"
Snd_FinalBoss:  binclude "data/Sound/SMPS/sk/Music/Final Boss.bin"
Snd_PresSega:   binclude "data/Sound/SMPS/sk/Music/Game Complete (Sonic & Knuckles).bin"

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
Snd_FBZ1:           binclude "data/Sound/SMPS/sk/Music/FBZ1 (Sonic & Knuckles).bin"
Snd_FBZ2:           binclude "data/Sound/SMPS/sk/Music/FBZ2.bin"
Snd_MHZ1:           binclude "data/Sound/SMPS/sk/Music/MHZ1.bin"
Snd_MHZ2:           binclude "data/Sound/SMPS/sk/Music/MHZ2.bin"
Snd_SOZ1:           binclude "data/Sound/SMPS/sk/Music/SOZ1.bin"
Snd_SOZ2:           binclude "data/Sound/SMPS/sk/Music/SOZ2.bin"
Snd_LRZ1:           binclude "data/Sound/SMPS/sk/Music/LRZ1.bin"
Snd_LRZ2:           binclude "data/Sound/SMPS/sk/Music/LRZ2.bin"
Snd_SSZ:            binclude "data/Sound/SMPS/sk/Music/SSZ (Sonic & Knuckles).bin"
Snd_DEZ1:           binclude "data/Sound/SMPS/sk/Music/DEZ1.bin"
Snd_DEZ2:           binclude "data/Sound/SMPS/sk/Music/DEZ2.bin"
Snd_Minib_SK:       binclude "data/Sound/SMPS/sk/Music/Miniboss (Sonic & Knuckles).bin"
Snd_Boss:           binclude "data/Sound/SMPS/sk/Music/Zone Boss.bin"
Snd_DDZ:            binclude "data/Sound/SMPS/sk/Music/DDZ.bin"
Snd_PachBonus:      binclude "data/Sound/SMPS/sk/Music/Pachinko.bin"
Snd_SpecialS:       binclude "data/Sound/SMPS/sk/Music/Special Stage.bin"
Snd_SlotBonus:      binclude "data/Sound/SMPS/sk/Music/Slots.bin"
Snd_Knux:           binclude "data/Sound/SMPS/sk/Music/Knuckles (Sonic & Knuckles).bin"
Snd_Title:          binclude "data/Sound/SMPS/sk/Music/Title (Sonic & Knuckles).bin"
Snd_1UP:            binclude "data/Sound/SMPS/sk/Music/1UP (Sonic & Knuckles).bin"
Snd_Emerald:        binclude "data/Sound/SMPS/sk/Music/Chaos Emerald.bin"

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
DAC_9B_Data:            include "src/audio/dac/shared/sample_9b.inc"
DAC_B2_B3_Data:         include "src/audio/dac/sk/sample_b2_b3.inc"

                finishBank

                align   $10

                include "Sound/Z80 Sound Driver.s"

; ===========================================================================
; Sound Bank
; ===========================================================================
SndBank:        startBank

SEGA_PCM:       include "src/audio/pcm/shared/sega_voice.inc"

                align   2
Sound_33:       binclude "data/Sound/SMPS/sk/SFX/33 - Ring (Right).bin"
Sound_34:       binclude "data/Sound/SMPS/sk/SFX/34 - Ring (Left).bin"
Sound_35:       binclude "data/Sound/SMPS/sk/SFX/35 - Death.bin"
Sound_36:       binclude "data/Sound/SMPS/sk/SFX/36 - Skid.bin"
Sound_37:       binclude "data/Sound/SMPS/sk/SFX/37 - Spike Hit.bin"
Sound_38:       binclude "data/Sound/SMPS/sk/SFX/38 - Bubble.bin"
Sound_39:       binclude "data/Sound/SMPS/sk/SFX/39 - Splash.bin"
Sound_3A:       binclude "data/Sound/SMPS/sk/SFX/3A - Shield.bin"
Sound_3B:       binclude "data/Sound/SMPS/sk/SFX/3B - Drown.bin"
Sound_3C:       binclude "data/Sound/SMPS/sk/SFX/3C - Roll.bin"
Sound_3D:       binclude "data/Sound/SMPS/sk/SFX/3D - Break.bin"
Sound_3E:       binclude "data/Sound/SMPS/sk/SFX/3E - Fire Shield.bin"
Sound_3F:       binclude "data/Sound/SMPS/sk/SFX/3F - Bubble Shield.bin"
Sound_40:       binclude "data/Sound/SMPS/sk/SFX/40 - Unknown Shield.bin"
Sound_41:       binclude "data/Sound/SMPS/sk/SFX/41 - Lightning Shield.bin"
Sound_42:       binclude "data/Sound/SMPS/sk/SFX/42 - Insta Shield Attack.bin"
Sound_43:       binclude "data/Sound/SMPS/sk/SFX/43 - Fire Shield Attack.bin"
Sound_44:       binclude "data/Sound/SMPS/sk/SFX/44 - Bubble Shield Attack.bin"
Sound_45:       binclude "data/Sound/SMPS/sk/SFX/45 - Lightning Shield Attack.bin"
Sound_46:       binclude "data/Sound/SMPS/sk/SFX/46 - Whistle.bin"
Sound_47:       binclude "data/Sound/SMPS/sk/SFX/47 - Sand Wall Rise.bin"
Sound_48:       binclude "data/Sound/SMPS/sk/SFX/48 - Blast.bin"
Sound_49:       binclude "data/Sound/SMPS/sk/SFX/49 - Thump.bin"
Sound_4A:       binclude "data/Sound/SMPS/sk/SFX/4A - Grab.bin"
Sound_4B:       binclude "data/Sound/SMPS/sk/SFX/4B - Waterfall Splash.bin"
Sound_4C:       binclude "data/Sound/SMPS/sk/SFX/4C - Glide Land.bin"
Sound_4D:       binclude "data/Sound/SMPS/sk/SFX/4D - Projectile.bin"
Sound_4E:       binclude "data/Sound/SMPS/sk/SFX/4E - Missile Explode.bin"
Sound_4F:       binclude "data/Sound/SMPS/sk/SFX/4F - Flamethrower (Quiet).bin"
Sound_50:       binclude "data/Sound/SMPS/sk/SFX/50 - Boss Activate.bin"
Sound_51:       binclude "data/Sound/SMPS/sk/SFX/51 - Missile Throw.bin"
Sound_52:       binclude "data/Sound/SMPS/sk/SFX/52 - Spike Move.bin"
Sound_53:       binclude "data/Sound/SMPS/sk/SFX/53 - Charging.bin"
Sound_54:       binclude "data/Sound/SMPS/sk/SFX/54 - Boss Laser.bin"
Sound_55:       binclude "data/Sound/SMPS/sk/SFX/55 - Block Conveyor.bin"
Sound_56:       binclude "data/Sound/SMPS/sk/SFX/56 - Flip Bridge.bin"
Sound_57:       binclude "data/Sound/SMPS/sk/SFX/57 - Geyser.bin"
Sound_58:       binclude "data/Sound/SMPS/sk/SFX/58 - Fan Latch.bin"
Sound_59:       binclude "data/Sound/SMPS/sk/SFX/59 - Collapse.bin"
Sound_5A:       binclude "data/Sound/SMPS/sk/SFX/5A - Unknown Charge.bin"
Sound_5B:       binclude "data/Sound/SMPS/sk/SFX/5B - Switch.bin"
Sound_5C:       binclude "data/Sound/SMPS/sk/SFX/5C - Mecha Spark.bin"
Sound_5D:       binclude "data/Sound/SMPS/sk/SFX/5D - Floor Thump.bin"
Sound_5E:       binclude "data/Sound/SMPS/sk/SFX/5E - Laser.bin"
Sound_5F:       binclude "data/Sound/SMPS/sk/SFX/5F - Crash.bin"
Sound_60:       binclude "data/Sound/SMPS/sk/SFX/60 - Boss Zoom.bin"
Sound_61:       binclude "data/Sound/SMPS/sk/SFX/61 - Boss Hit Floor.bin"
Sound_62:       binclude "data/Sound/SMPS/sk/SFX/62 - Jump.bin"
Sound_63:       binclude "data/Sound/SMPS/sk/SFX/63 - Star Post.bin"
Sound_64:       binclude "data/Sound/SMPS/sk/SFX/64 - Pulley Grab.bin"
Sound_65:       binclude "data/Sound/SMPS/sk/SFX/65 - Blue Sphere.bin"
Sound_66:       binclude "data/Sound/SMPS/sk/SFX/66 - All Spheres Collected.bin"
Sound_67:       binclude "data/Sound/SMPS/sk/SFX/67 - Level Projectile.bin"
Sound_68:       binclude "data/Sound/SMPS/sk/SFX/68 - Perfect.bin"
Sound_69:       binclude "data/Sound/SMPS/sk/SFX/69 - Push Block.bin"
Sound_6A:       binclude "data/Sound/SMPS/sk/SFX/6A - Goal.bin"
Sound_6B:       binclude "data/Sound/SMPS/sk/SFX/6B - Action Block.bin"
Sound_6C:       binclude "data/Sound/SMPS/sk/SFX/6C - Splash 2.bin"
Sound_6D:       binclude "data/Sound/SMPS/sk/SFX/6D - Unknown Shift.bin"
Sound_6E:       binclude "data/Sound/SMPS/sk/SFX/6E - Boss Hit.bin"
Sound_6F:       binclude "data/Sound/SMPS/sk/SFX/6F - Rumble 2.bin"
Sound_70:       binclude "data/Sound/SMPS/sk/SFX/70 - Lava Ball.bin"
Sound_71:       binclude "data/Sound/SMPS/sk/SFX/71 - Shield 2.bin"
Sound_72:       binclude "data/Sound/SMPS/sk/SFX/72 - Hoverpad.bin"
Sound_73:       binclude "data/Sound/SMPS/sk/SFX/73 - Transporter.bin"
Sound_74:       binclude "data/Sound/SMPS/sk/SFX/74 - Tunnel Booster.bin"
Sound_75:       binclude "data/Sound/SMPS/sk/SFX/75 - Balloon Platform.bin"
Sound_76:       binclude "data/Sound/SMPS/sk/SFX/76 - Trap Door.bin"
Sound_77:       binclude "data/Sound/SMPS/sk/SFX/77 - Balloon.bin"
Sound_78:       binclude "data/Sound/SMPS/sk/SFX/78 - Gravity Machine.bin"
Sound_79:       binclude "data/Sound/SMPS/sk/SFX/79 - Lightning.bin"
Sound_7A:       binclude "data/Sound/SMPS/sk/SFX/7A - Boss Magma.bin"
Sound_7B:       binclude "data/Sound/SMPS/sk/SFX/7B - Small Bumpers.bin"
Sound_7C:       binclude "data/Sound/SMPS/sk/SFX/7C - Chain Tension.bin"
Sound_7D:       binclude "data/Sound/SMPS/sk/SFX/7D - Unknown Pump.bin"
Sound_7E:       binclude "data/Sound/SMPS/sk/SFX/7E - Ground Slide.bin"
Sound_7F:       binclude "data/Sound/SMPS/sk/SFX/7F - Frost Puff.bin"
Sound_80:       binclude "data/Sound/SMPS/sk/SFX/80 - Ice Spikes.bin"
Sound_81:       binclude "data/Sound/SMPS/sk/SFX/81 - Tube Launcher.bin"
Sound_82:       binclude "data/Sound/SMPS/sk/SFX/82 - Sand Splash.bin"
Sound_83:       binclude "data/Sound/SMPS/sk/SFX/83 - Bridge Collapse.bin"
Sound_84:       binclude "data/Sound/SMPS/sk/SFX/84 - Unknown Power-Up.bin"
Sound_85:       binclude "data/Sound/SMPS/sk/SFX/85 - Unknown Power-Down.bin"
Sound_86:       binclude "data/Sound/SMPS/sk/SFX/86 - Alarm.bin"
Sound_87:       binclude "data/Sound/SMPS/sk/SFX/87 - Mushroom Bounce.bin"
Sound_88:       binclude "data/Sound/SMPS/sk/SFX/88 - Pulley Move.bin"
Sound_89:       binclude "data/Sound/SMPS/sk/SFX/89 - Weather Machine.bin"
Sound_8A:       binclude "data/Sound/SMPS/sk/SFX/8A - Bouncy.bin"
Sound_8B:       binclude "data/Sound/SMPS/sk/SFX/8B - Chop Tree.bin"
Sound_8C:       binclude "data/Sound/SMPS/sk/SFX/8C - Chop Stuck.bin"
Sound_8D:       binclude "data/Sound/SMPS/sk/SFX/8D - Unknown Flutter.bin"
Sound_8E:       binclude "data/Sound/SMPS/sk/SFX/8E - Unknown Revving.bin"
Sound_8F:       binclude "data/Sound/SMPS/sk/SFX/8F - Door Open.bin"
Sound_90:       binclude "data/Sound/SMPS/sk/SFX/90 - Door Move.bin"
Sound_91:       binclude "data/Sound/SMPS/sk/SFX/91 - Door Close.bin"
Sound_92:       binclude "data/Sound/SMPS/sk/SFX/92 - Ghost Appear.bin"
Sound_93:       binclude "data/Sound/SMPS/sk/SFX/93 - Boss Recovery.bin"
Sound_94:       binclude "data/Sound/SMPS/sk/SFX/94 - Chain Tick.bin"
Sound_95:       binclude "data/Sound/SMPS/sk/SFX/95 - Boss Hand.bin"
Sound_96:       binclude "data/Sound/SMPS/sk/SFX/96 - Mecha Land.bin"
Sound_97:       binclude "data/Sound/SMPS/sk/SFX/97 - Enemy Breath.bin"
Sound_98:       binclude "data/Sound/SMPS/sk/SFX/98 - Boss Projectile.bin"
Sound_99:       binclude "data/Sound/SMPS/sk/SFX/99 - Unknown Plink.bin"
Sound_9A:       binclude "data/Sound/SMPS/sk/SFX/9A - Spring Latch.bin"
Sound_9B:       binclude "data/Sound/SMPS/sk/SFX/9B - Thump Boss (Sonic & Knuckles).bin"
Sound_9C:       binclude "data/Sound/SMPS/sk/SFX/9C - Super Emerald.bin"
Sound_9D:       binclude "data/Sound/SMPS/sk/SFX/9D - Targeting.bin"
Sound_9E:       binclude "data/Sound/SMPS/sk/SFX/9E - Clank.bin"
Sound_9F:       binclude "data/Sound/SMPS/sk/SFX/9F - Super Transform.bin"
Sound_A0:       binclude "data/Sound/SMPS/sk/SFX/A0 - Missile Shoot.bin"
Sound_A1:       binclude "data/Sound/SMPS/sk/SFX/A1 - Unknown Ominous.bin"
Sound_A2:       binclude "data/Sound/SMPS/sk/SFX/A2 - Floor Launcher.bin"
Sound_A3:       binclude "data/Sound/SMPS/sk/SFX/A3 - Gravity Lift.bin"
Sound_A4:       binclude "data/Sound/SMPS/sk/SFX/A4 - Mecha Transform.bin"
Sound_A5:       binclude "data/Sound/SMPS/sk/SFX/A5 - Unknown Rise.bin"
Sound_A6:       binclude "data/Sound/SMPS/sk/SFX/A6 - Launch Grab.bin"
Sound_A7:       binclude "data/Sound/SMPS/sk/SFX/A7 - Launch Ready.bin"
Sound_A8:       binclude "data/Sound/SMPS/sk/SFX/A8 - Energy Zap.bin"
Sound_A9:       binclude "data/Sound/SMPS/sk/SFX/A9 - Air Ding.bin"
Sound_AA:       binclude "data/Sound/SMPS/sk/SFX/AA - Bumper.bin"
Sound_AB:       binclude "data/Sound/SMPS/sk/SFX/AB - Spin Dash.bin"
Sound_AC:       binclude "data/Sound/SMPS/sk/SFX/AC - Continue.bin"
Sound_AD:       binclude "data/Sound/SMPS/sk/SFX/AD - Launch Go (Sonic & Knuckles).bin"
Sound_AE:       binclude "data/Sound/SMPS/sk/SFX/AE - Flipper.bin"
Sound_AF:       binclude "data/Sound/SMPS/sk/SFX/AF - Enter Special Stage.bin"
Sound_B0:       binclude "data/Sound/SMPS/sk/SFX/B0 - Register.bin"
Sound_B1:       binclude "data/Sound/SMPS/sk/SFX/B1 - Spring.bin"
Sound_B2:       binclude "data/Sound/SMPS/sk/SFX/B2 - Error.bin"
Sound_B3:       binclude "data/Sound/SMPS/sk/SFX/B3 - Big Ring.bin"
Sound_B4:       binclude "data/Sound/SMPS/sk/SFX/B4 - Explode.bin"
Sound_B5:       binclude "data/Sound/SMPS/sk/SFX/B5 - Diamonds.bin"
Sound_B6:       binclude "data/Sound/SMPS/sk/SFX/B6 - Dash.bin"
Sound_B7:       binclude "data/Sound/SMPS/sk/SFX/B7 - Slot Machine.bin"
Sound_B8:       binclude "data/Sound/SMPS/sk/SFX/B8 - Signpost.bin"
Sound_B9:       binclude "data/Sound/SMPS/sk/SFX/B9 - Ring Loss.bin"
Sound_BA:       binclude "data/Sound/SMPS/sk/SFX/BA - Flying.bin"
Sound_BB:       binclude "data/Sound/SMPS/sk/SFX/BB - Flying (Tired).bin"
Sound_BC:       binclude "data/Sound/SMPS/sk/SFX/BC - Slide Skid (Loud).bin"
Sound_BD:       binclude "data/Sound/SMPS/sk/SFX/BD - Large Ship.bin"
Sound_BE:       binclude "data/Sound/SMPS/sk/SFX/BE - Robotnik Siren.bin"
Sound_BF:       binclude "data/Sound/SMPS/sk/SFX/BF - Boss Rotate.bin"
Sound_C0:       binclude "data/Sound/SMPS/sk/SFX/C0 - Fan (Big).bin"
Sound_C1:       binclude "data/Sound/SMPS/sk/SFX/C1 - Fan (Small).bin"
Sound_C2:       binclude "data/Sound/SMPS/sk/SFX/C2 - Flamethrower (Loud).bin"
Sound_C3:       binclude "data/Sound/SMPS/sk/SFX/C3 - Gravity Tunnel.bin"
Sound_C4:       binclude "data/Sound/SMPS/sk/SFX/C4 - Boss Panic.bin"
Sound_C5:       binclude "data/Sound/SMPS/sk/SFX/C5 - Unknown Spin.bin"
Sound_C6:       binclude "data/Sound/SMPS/sk/SFX/C6 - Wave Hover.bin"
Sound_C7:       binclude "data/Sound/SMPS/sk/SFX/C7 - Cannon Turn.bin"
Sound_C8:       binclude "data/Sound/SMPS/sk/SFX/C8 - Slide Skid (Quiet).bin"
Sound_C9:       binclude "data/Sound/SMPS/sk/SFX/C9 - Spike Balls.bin"
Sound_CA:       binclude "data/Sound/SMPS/sk/SFX/CA - Light Tunnel.bin"
Sound_CB:       binclude "data/Sound/SMPS/sk/SFX/CB - Rumble.bin"
Sound_CC:       binclude "data/Sound/SMPS/sk/SFX/CC - Big Rumble.bin"
Sound_CD:       binclude "data/Sound/SMPS/sk/SFX/CD - Death Egg Rise (Loud).bin"
Sound_CE:       binclude "data/Sound/SMPS/sk/SFX/CE - Wind (Quiet).bin"
Sound_CF:       binclude "data/Sound/SMPS/sk/SFX/CF - Wind (Loud).bin"
Sound_D0:       binclude "data/Sound/SMPS/sk/SFX/D0 - Rising.bin"
Sound_D1:       binclude "data/Sound/SMPS/sk/SFX/D1 - Unknown Flutter 2.bin"
Sound_D2:       binclude "data/Sound/SMPS/sk/SFX/D2 - Gumball Tab.bin"
Sound_D3:       binclude "data/Sound/SMPS/sk/SFX/D3 - Death Egg Rise (Quiet).bin"
Sound_D4:       binclude "data/Sound/SMPS/sk/SFX/D4 - Turbine Hum.bin"
Sound_D5:       binclude "data/Sound/SMPS/sk/SFX/D5 - Lava Fall.bin"
Sound_D6:       binclude "data/Sound/SMPS/sk/SFX/D6 - Unknown Zap.bin"
Sound_D7:       binclude "data/Sound/SMPS/sk/SFX/D7 - Conveyor Platform.bin"
Sound_D8:       binclude "data/Sound/SMPS/sk/SFX/D8 - Unknown Saw.bin"
Sound_D9:       binclude "data/Sound/SMPS/sk/SFX/D9 - Magnetic Spike.bin"
Sound_DA:       binclude "data/Sound/SMPS/sk/SFX/DA - Leaf Blower.bin"
Sound_DB:       binclude "data/Sound/SMPS/sk/SFX/DB - Water Skid.bin"

                finishBank

                align   $8000

ArtUnc_Sonic:
                binclude "data/General/Sprites/Sonic/Art/Sonic.unc"
                even
ArtUnc_Knux:
                binclude "data/General/Sprites/Knuckles/Art/Knuckles.unc"
                even
ArtUnc_Sonic_Extra:
                binclude "data/General/Sprites/Sonic/Art/Sonic Extra.unc"
                even
ArtUnc_Tails_Extra:
                binclude "data/General/Sprites/Tails/Art/Tails Extra.unc"
                even
; [FixBugs]: These two files contain some bugs. Read their contents for details
Map_Sonic:
                include "src/objects/shared/sonic/map_sonic.s"
PLC_Sonic:
                include "src/objects/shared/sonic/dplc_sonic.s"

Map_Tails:
                include "src/objects/shared/tails/map_tails.s"
PLC_Tails:
                include "src/objects/shared/tails/dplc_tails.s"
Map_Knuckles:
                include "src/objects/shared/knuckles/map_knuckles.s"
PLC_Knuckles:
                include "src/objects/shared/knuckles/dplc_knuckles.s"
ArtKosM_HyperSonicStars:
                binclude "data/General/Sprites/Sonic/Art/Hyper Sonic Stars.kosm"
                even
ArtKosM_SuperTailsBirds:
                binclude "data/General/Sprites/Tails/Art/Super Tails birds.kosm"
                even
ArtNem_FBZMisc:
                binclude "data/Levels/FBZ/Nemesis Art/Misc Art 1.nem"
                even
ArtNem_FBZOutdoors:
                binclude "data/Levels/FBZ/Nemesis Art/Outdoors.nem"
                even
ArtNem_FBZMisc2:
                binclude "data/Levels/FBZ/Nemesis Art/Misc Art 2.nem"
                even
ArtNem_MHZMisc:
                binclude "data/Levels/MHZ/Nemesis Art/Misc Art.nem"
                even
ArtNem_SOZMisc:
                binclude "data/Levels/SOZ/Nemesis Art/Misc Art.nem"
                even
ArtNem_SOZTile:
                binclude "data/Levels/SOZ/Nemesis Art/Tile.nem"
                even
ArtNem_SOZ2Extra:
                binclude "data/Levels/SOZ/Nemesis Art/Act 2 Extra Art.nem"
                even
ArtNem_LRZMisc:
                binclude "data/Levels/LRZ/Nemesis Art/Misc Art.nem"
                even
ArtNem_LRZSpikes:
                binclude "data/Levels/LRZ/Nemesis Art/Spike Crush.nem"
                even
ArtNem_LRZBigSpike:
                binclude "data/Levels/LRZ/Nemesis Art/Big Spike Ball.nem"
                even
ArtNem_LRZ2Misc:
                binclude "data/Levels/LRZ/Nemesis Art/Act 2 Misc Art.nem"
                even
ArtNem_LRZ2Drum:
                binclude "data/Levels/LRZ/Nemesis Art/Act 2 Spinning Drum.nem"
                even
ArtNem_SSZMisc:
                binclude "data/Levels/SSZ/Nemesis Art/Misc.nem"
                even
ArtKosM_SSZSpiralRamp:
                binclude "data/Levels/SSZ/KosinskiM Art/Spiral Ramp.kosm"
                even
ArtNem_DEZMisc:
                binclude "data/Levels/DEZ/Nemesis Art/Misc Art.nem"
                even
ArtNem_DEZMiniboss:
                binclude "data/Levels/DEZ/Nemesis Art/Miniboss.nem"
                even
ArtNem_DEZ2Extra:
                binclude "data/Levels/DEZ/Nemesis Art/Act 2 Extra Art.nem"
                even
ArtNem_PachinkoMain:
                binclude "data/Levels/Pachinko/Nemesis Art/Main.nem"
                even
ArtKos_PachinkoBG1:
                binclude "data/Levels/Pachinko/Kosinski Art/Animated BG 1.kos"
                even
ArtKos_PachinkoBG2:
                binclude "data/Levels/Pachinko/Kosinski Art/Animated BG 2.kos"
                even
PalKos_Pachinko:
                binclude "data/Levels/Pachinko/Palettes/Compressed Pal.bin"
                even
ArtNem_SlotsBlocks:
                binclude "data/Levels/Slots/Nemesis Art/Blocks.nem"
                even
ArtUnc_SlotOptions:
                binclude "data/Levels/Slots/Uncompressed Art/Options.unc"
                even
ArtKosM_CNZTeleport:
                binclude "data/Levels/CNZ/KosinskiM Art/Teleporter Beam.kosm"
                even
ArtNem_ICZTeleport:
                binclude "data/Levels/ICZ/Nemesis Art/Teleporter Beam.nem"
                even
ArtKosM_MHZEndBossPillar:
                binclude "data/Levels/MHZ/KosinskiM Art/End Boss Pillar.kosm"
                even
ArtKosM_MHZShipPropeller:
                binclude "data/Levels/MHZ/KosinskiM Art/Ship Propeller.kosm"
                even
ArtKosM_LRZ2DeathEggBG:
                binclude "data/Levels/LRZ/KosinskiM Art/BG Death Egg.kosm"
                even
ArtUnc_DEZFBLaser:
                binclude "data/Levels/DEZ/Uncompressed Art/Final Boss Laser.unc"
                even
ArtKos_SaveScreen:
                binclude "data/General/Save Menu/Kosinski Art/SK Extra.kos"
                even
ArtKosM_SSResultsSUPER:
                binclude "data/General/Special Stage/KosinskiM Art/SSResults SUPER.kosm"
                even
ArtKosM_SSResultsSUPERk:
                binclude "data/General/Special Stage/KosinskiM Art/SSResults SUPER (K).kosm"
                even
ArtKosM_SSResultsHYPER:
                binclude "data/General/Special Stage/KosinskiM Art/SSResults HYPER.kosm"
                even
ArtKosM_SSResultsHYPERk:
                binclude "data/General/Special Stage/KosinskiM Art/SSResults HYPER (K).kosm"
                even
ArtKosM_ResultsSONIC:
                binclude "data/General/Sprites/Results/Results SONIC.kosm"
                even
ArtKosM_SSResults:
                dc.w    $12A0
ArtKos_SSResultsGeneral:
                binclude "data/General/Special Stage/Kosinski Art/SSResults General.kos"
ArtKos_SSResultsTKIcons:
                binclude "data/General/Special Stage/Kosinski Art/SSResults Tails Knuckles Icons.kos"
                even
ArtKosM_TitleCardSKZone:
                binclude "data/General/Sprites/Title Card/Title Card SK Zone.kosm"
                even
ArtKosM_TitleCardS3KZone:
                binclude "data/General/Sprites/Title Card/Title Card S3K Zone.kosm"
                even
ArtKosM_MHZTitleCard:
                binclude "data/Levels/MHZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_SOZTitleCard:
                binclude "data/Levels/SOZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_LRZTitleCard:
                binclude "data/Levels/LRZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_SSZTitleCard:
                binclude "data/Levels/SSZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_DEZTitleCard:
                binclude "data/Levels/DEZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_DDZTitleCard:
                binclude "data/Levels/DDZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_HPZTitleCard:
                binclude "data/Levels/HPZ/KosinskiM Art/Title Card.kosm"
                even
ArtKos_SaveScreenSKZone:
                binclude "data/General/Save Menu/Kosinski Art/SK Zone Art.kos"
                even
ArtKos_SaveScreenPortrait:
                binclude "data/General/Save Menu/Kosinski Art/Portraits.kos"
                even
DemoDat_MHZ:
                binclude "data/Levels/MHZ/Demodata/1.bin"
                even
DemoDat_FBZ:
                binclude "data/Levels/FBZ/Demodata/1.bin"
                even
DemoDat_SOZ:
                binclude "data/Levels/SOZ/Demodata/1.bin"
                even
DemoDat_SpecialStage:
                binclude "data/General/Special Stage/Demodata/1.bin"
                even
ArtKosM_EggRoboHead:
                binclude "data/General/Sprites/Egg Robo/Egg Robo Head.kosm"
                even
ArtNem_EggRoboRun:
                binclude "data/General/Sprites/Egg Robo/Egg Robo Run.nem"
                even
ArtNem_EggRoboStand:
                binclude "data/General/Sprites/Egg Robo/Egg Robo Stand.nem"
                even
ArtKosM_KnuxFinalBossCrane:
                binclude "data/General/Sprites/Robotnik/Robotnik Ship Crane.kosm"
                even
ArtKosM_IslandLiftGfx:
                binclude "data/General/Ending/KosinskiM Art/Island Lift Animated Tiles.kosm"
                even
ArtKosM_EndingAnimals:
                binclude "data/General/Ending/KosinskiM Art/Pelican and Dolphin.kosm"
                even
ArtKosM_EggRoboSKEnding:
                binclude "data/General/Ending/KosinskiM Art/Egg Robo.kosm"
                even
ArtKosM_SonicEndPose:
                binclude "data/General/Ending/KosinskiM Art/Sonic Ending Pose.kosm"
                even
ArtKosM_SuperSonicEndPose:
                binclude "data/General/Ending/KosinskiM Art/Super Sonic Ending Pose.kosm"
                even
ArtKosM_SonicPlaneEnding:
                binclude "data/General/Ending/KosinskiM Art/Sonic Plane Ending.kosm"
                even
ArtKosM_RobotnikSmug:
                binclude "data/General/Ending/KosinskiM Art/Robotnik Standing Smug.kosm"
                even
ArtKosM_SonicPlane:
                binclude "data/General/Ending/KosinskiM Art/Sonic Plane.kosm"
                even
ArtKosM_KnuxEnding:
                binclude "data/General/Sprites/Knuckles/Cutscene/Knuckles Ending Cutscene.kosm"
                even
ArtKosM_SKPoseBanner:
                binclude "data/General/Ending/KosinskiM Art/Sonic Knuckles Pose Banner.kosm"
                even
ArtKosM_S3PoseBanner:
                binclude "data/General/Ending/KosinskiM Art/Sonic 3 Pose Banner.kosm"
                even
ArtUnc_KnuxIntroLay:
                binclude "data/General/Sprites/Knuckles/Cutscene/Intro Laying.unc"
                even
ArtKosM_KnuxIntroBomb:
                binclude "data/General/Sprites/Knuckles/Cutscene/Knuckles Intro Bomb.kosm"
                even
ArtKosM_FBZExitHall:
                binclude "data/Levels/FBZ/KosinskiM Art/Exit Hall.kosm"
                even
ArtKosM_FBZMiniboss:
                binclude "data/Levels/FBZ/KosinskiM Art/Miniboss.kosm"
                even
ArtKosM_FBZCloud:
                binclude "data/Levels/FBZ/KosinskiM Art/Cloud.kosm"
                even
ArtKosM_FBZBossPillar:
                binclude "data/Levels/FBZ/KosinskiM Art/Before Boss Pillar.kosm"
                even
ArtKosM_FBZExitDoor:
                binclude "data/Levels/FBZ/KosinskiM Art/Exit Door.kosm"
                even
ArtNem_FBZEggCapsule:
                binclude "data/Levels/FBZ/Nemesis Art/Egg Capsule.nem"
                even
ArtKosM_FBZButton:
                binclude "data/Levels/FBZ/KosinskiM Art/Button.kosm"
                even
ArtKosM_Madmole:
                binclude "data/General/Sprites/Madmole/Madmole.kosm"
                even
ArtKosM_Mushmeanie:
                binclude "data/General/Sprites/Mushmeanie/Mushmeanie.kosm"
                even
ArtKosM_Dragonfly:
                binclude "data/General/Sprites/Dragonfly/Dragonfly.kosm"
                even
ArtKosM_CluckoidArrow:
                binclude "data/General/Sprites/Cluckoid/Cluckoid Arrow.kosm"
                even
ArtUnc_Butterdroid:
                binclude "data/General/Sprites/Butterdroid/Butterdroid.unc"
                even
ArtUnc_Cluckoid:
                binclude "data/General/Sprites/Cluckoid/Cluckoid.unc"
                even
ArtKosM_MHZMiniboss:
                binclude "data/Levels/MHZ/KosinskiM Art/Miniboss.kosm"
                even
ArtKosM_MHZMinibossLog:
                binclude "data/Levels/MHZ/KosinskiM Art/Miniboss Log.kosm"
                even
ArtKosM_MHZEndBossSpikes:
                binclude "data/Levels/MHZ/KosinskiM Art/End Boss Spikes.kosm"
                even
ArtKosM_MHZKnuxPeer:
                binclude "data/General/Sprites/Knuckles/Cutscene/Knuckles Peering.kosm"
                even
ArtUnc_MHZKnuxPress:
                binclude "data/General/Sprites/Knuckles/Cutscene/MHZ2 Press.unc"
                even
ArtKosM_MHZKnuxSwitch:
                binclude "data/General/Sprites/Knuckles/Cutscene/Knuckles MHZ Switch.kosm"
                even
ArtKosM_MHZEndBoss:
                binclude "data/Levels/MHZ/KosinskiM Art/End Boss.kosm"
                even
ArtKosM_Skorp:
                binclude "data/General/Sprites/Skorp/Skorp.kosm"
                even
ArtKosM_Sandworm:
                binclude "data/General/Sprites/Sandworm/Sandworm.kosm"
                even
ArtKosM_Rockn:
                binclude "data/General/Sprites/Rockn/Rock'n.kosm"
                even
ArtUnc_SOZGhosts:
                binclude "data/General/Sprites/SOZ Ghosts/SOZ Ghosts.unc"
                even
ArtKosM_SOZMiniboss:
                binclude "data/Levels/SOZ/KosinskiM Art/Miniboss.kosm"
                even
ArtKosM_SOZSand:
                binclude "data/Levels/SOZ/KosinskiM Art/Sand Particles.kosm"
                even
ArtKosM_SOZEndBoss:
                binclude "data/Levels/SOZ/KosinskiM Art/End Boss.kosm"
                even
ArtUnc_Fireworm:
                binclude "data/General/Sprites/Fireworm/Fireworm.unc"
                even
ArtKosM_FirewormSegments:
                binclude "data/General/Sprites/Fireworm/Fireworm Segments.kosm"
                even
ArtKosM_Iwamodoki:
                binclude "data/General/Sprites/Iwamodoki/Iwamodoki.kosm"
                even
ArtKosM_Toxomister:
                binclude "data/General/Sprites/Toxomister/Toxomister.kosm"
                even
ArtKosM_LRZRockCrusher:
                binclude "data/Levels/LRZ/KosinskiM Art/Rock Crusher.kosm"
                even
ArtKosM_LRZMiniboss:
                binclude "data/Levels/LRZ/KosinskiM Art/Miniboss.kosm"
                even
ArtKosM_LRZ3Autoscroll:
                binclude "data/Levels/LRZ/KosinskiM Art/Autoscroll.kosm"
                even
ArtKosM_LRZ3DeathEggFlash:
                binclude "data/Levels/LRZ/KosinskiM Art/Death Egg Flash.kosm"
                even
ArtKosM_LRZ3PlatformDebris:
                binclude "data/Levels/LRZ/KosinskiM Art/Platform Debris.kosm"
                even
ArtKosM_LRZEndBoss:
                binclude "data/Levels/LRZ/KosinskiM Art/End Boss.kosm"
                even
ArtKosM_LRZKnuxBoulder:
                binclude "data/Levels/LRZ/KosinskiM Art/Knuckles Boulder.kosm"
                even
ArtUnc_HPZKnucklesGrab:
                binclude "data/General/Sprites/Knuckles/Cutscene/HPZ Emerald Grab.unc"
                even
ArtKosM_HPZKnuxDizzy:
                binclude "data/Levels/HPZ/KosinskiM Art/Knuckles Dizzy Stars.kosm"
                even
ArtNem_HPZEmeraldMisc:
                binclude "data/Levels/HPZ/Nemesis Art/Emerald Misc Art.nem"
                even
ArtNem_HPZGrayEmerald:
                binclude "data/Levels/HPZ/Nemesis Art/Gray Emerald.nem"
                even
ArtKosM_Teleporter:
                binclude "data/General/Sprites/Teleporter/Teleporter.kosm"
                even
ArtKosM_HPZSmallEmeralds:
                binclude "data/Levels/HPZ/KosinskiM Art/Special Stage Emeralds.kosm"
                even
ArtUnc_MechaSonic:
                binclude "data/General/Sprites/Mecha Sonic/Mecha Sonic.unc"
                even
ArtKosM_EggRoboBadnik:
                binclude "data/General/Sprites/Egg Robo/Egg Robo Badnik.kosm"
                even
ArtScaled_EggRoboFly:
                binclude "data/General/Sprites/Egg Robo/Egg Robo Fly Scaled.bin"
                even
ArtKosM_MechaSonicHead:
                binclude "data/General/Sprites/Mecha Sonic/Mecha Sonic Head.kosm"
                even
ArtUnc_SSZDeathEggCloud:
                binclude "data/Levels/SSZ/Uncompressed Art/Death Egg Cloud.unc"
                even
ArtKosM_SSZDeathEggSmall:
                binclude "data/Levels/SSZ/KosinskiM Art/Death Egg Small.kosm"
                even
ArtUnc_SSZKnucklesTired:
                binclude "data/General/Sprites/Knuckles/Cutscene/SSZ Tired.unc"
                even
ArtKosM_SSZGHZMisc:
                binclude "data/Levels/SSZ/KosinskiM Art/GHZ Ball and Chain.kosm"
                even
ArtKosM_SSZMTZOrbs:
                binclude "data/Levels/SSZ/KosinskiM Art/MTZ Orbs.kosm"
                even
ArtKosM_MechaSonicExtra:
                binclude "data/General/Sprites/Mecha Sonic/Mecha Sonic Extra Art.kosm"
                even
ArtKosM_EndingMasterEmerald:
                binclude "data/General/Sprites/SSZ Master Emerald/Master Emerald.kosm"
                even
ArtKosM_Spikebonker:
                binclude "data/General/Sprites/Spikebonker/Spikebonker.kosm"
                even
ArtKosM_Chainspike:
                binclude "data/General/Sprites/Chainspike/Chainspike.kosm"
                even
ArtKosM_DEZMinibossMisc:
                binclude "data/Levels/DEZ/KosinskiM Art/Miniboss Misc Art.kosm"
                even
ArtKosM_DEZEndBoss:
                binclude "data/Levels/DEZ/KosinskiM Art/End Boss.kosm"
                even
ArtKosM_DEZFinalBossMisc:
                binclude "data/Levels/DEZ/KosinskiM Art/Final Boss Misc Art.kosm"
                even
ArtKosM_BossMasterEmerald:
                binclude "data/Levels/DEZ/KosinskiM Art/Final Boss Master Emerald.kosm"
                even
ArtKosM_DEZFinalBossDebris:
                binclude "data/Levels/DEZ/KosinskiM Art/Final Boss Debris.kosm"
                even
ArtKosM_DDZMisc:
                binclude "data/Levels/DDZ/KosinskiM Art/Misc Art.kosm"
                even
AngleLookup_1:
                dc.b    0,   0,   1,   1,   1,   1,   2,   2,   2,   3,   3,   3,   3,   4,   4,   4,   5,   5,   5,   5
                dc.b    6,   6,   6,   6,   7,   7,   7,   7,   8,   8,   8,   8,   8,   9,   9,   9,   9,   9,  $A,  $A
                dc.b    $A,  $A,  $A,  $A,  $B,  $B,  $B,  $B,  $B,  $B,  $B,  $B,  $B,  $C,  $C,  $C,  $C,  $C,  $C,  $C
                dc.b    $C,  $C,  $C,  $C
AngleLookup_2:
                dc.b    0,   1,   1,   2,   2,   3,   4,   4,   5,   5,   6,   6,   7,   8,   8,   9,   9,  $A,  $A,  $B
                dc.b    $B,  $C,  $C,  $D,  $D,  $E,  $E,  $F,  $F, $10, $10, $11, $11, $11, $12, $12, $13, $13, $13, $14
                dc.b    $14, $14, $15, $15, $15, $15, $16, $16, $16, $16, $17, $17, $17, $17, $17, $17, $18, $18, $18, $18
                dc.b    $18, $18, $18, $18
AngleLookup_3:
                dc.b    0,   1,   2,   3,   4,   4,   5,   6,   7,   8,   9,  $A,  $A,  $B,  $C,  $D,  $E,  $F,  $F, $10
                dc.b    $11, $12, $13, $13, $14, $15, $15, $16, $17, $18, $18, $19, $19, $1A, $1B, $1B, $1C, $1C, $1D, $1D
                dc.b    $1E, $1E, $1F, $1F, $20, $20, $21, $21, $21, $22, $22, $22, $22, $23, $23, $23, $23, $23, $24, $24
                dc.b    $24, $24, $24, $24
                even
Map_Spikebonker:
                include "src/objects/shared/spikebonker/map_spikebonker.s"
Map_Chainspike:
                include "src/objects/shared/chainspike/map_chainspike.s"
Map_EggRobo:
                include "src/objects/shared/egg_robo/map_egg_robo_badnik.s"
Map_DEZMiniboss:
                include "src/objects/shared/zones/dez/map_miniboss.s"
Map_MechaSonic:
                include "src/objects/shared/mecha_sonic/map_mecha_sonic.s"
Map_MechaSonicExtra:
                include "src/objects/shared/mecha_sonic/map_mecha_sonic_extra.s"
DPLC_MechaSonic:
                include "src/objects/shared/mecha_sonic/dplc_mecha_sonic.s"
Map_SpriteMask:
                include "src/objects/shared/level_misc/map_sprite_mask.s"
Map_DEZEndBoss:
                include "src/objects/shared/zones/dez/map_end_boss.s"
Map_MHZEndBoss:
                include "src/objects/shared/zones/mhz/map_end_boss.s"
Map_MHZMiniboss:
                include "src/objects/shared/zones/mhz/map_miniboss.s"
Map_MHZMinibossTree:
                include "src/objects/shared/zones/mhz/map_miniboss_tree.s"
Map_MHZMinibossLog:
                include "src/objects/shared/zones/mhz/map_miniboss_log.s"
Map_EggRoboStand:
                include "src/objects/shared/egg_robo/map_egg_robo_stand.s"
Map_EggRoboRun:
                include "src/objects/shared/egg_robo/map_egg_robo_run.s"
Map_Skorp:
                include "src/objects/shared/skorp/map_skorp.s"
Map_Sandworm:
                include "src/objects/shared/sandworm/map_sandworm.s"
Map_LRZRockCrusher:
                include "src/objects/shared/zones/lrz/map_rock_crusher.s"
Map_SSZMTZOrbs:
                include "src/objects/shared/zones/ssz/map_mtz_orbs.s"
Map_SSZGHZMisc:
                include "src/objects/shared/zones/ssz/map_ghz_misc.s"
Map_LRZMiniboss:
                include "src/objects/shared/zones/lrz/map_miniboss.s"
Map_FBZEggCapsule:
                include "src/objects/shared/zones/fbz/map_egg_capsule.s"
Map_SOZGhosts:
                include "src/objects/shared/soz_ghosts/map_soz_ghosts.s"
Map_LRZEndBoss:
                include "src/objects/shared/zones/lrz/map_end_boss.s"
Map_LRZ3Platform:
                include "src/objects/shared/zones/lrz/map_act_3_platform.s"
Map_LRZ3Autoscroll:
                include "src/objects/shared/zones/lrz/map_act_3_autoscroll.s"
Map_LRZ3DeathEggFlash:
                include "src/objects/shared/zones/lrz/map_act_3_death_egg_flash.s"
Map_LRZ3Debris:
                include "src/objects/shared/zones/lrz/map_act_3_platform_debris.s"
Map_DEZFinalBossMisc:
                include "src/objects/shared/zones/dez/map_final_boss_misc.s"
Map_BossMasterEmerald:
                include "src/objects/shared/zones/dez/map_final_boss_master_emerald.s"
Map_DEZFinalBossDebris:
                include "src/objects/shared/zones/dez/map_final_boss_debris.s"
                even
; [BUG]: These three files have incorrect Moduled Kosinski headers!
; The size specified in the header reflects the compressed data ($60)
; rather than the uncompressed data ($C0). This causes only the first 3
; out of 6 tiles to be loaded from each file. This can be easily seen
; by pausing after activating a starpost, as the corner of the larger
; star sprite will be the wrong color due to using leftover tile data
; in VRAM
ArtKosM_StarPost_Stars1:
                binclude "data/General/Sprites/Starpost/Starpost Stars 1.kosm"
                even
ArtKosM_StarPostStars2:
                binclude "data/General/Sprites/Starpost/Starpost Stars 2.kosm"
                even
ArtKosM_StarPostStars3:
                binclude "data/General/Sprites/Starpost/Starpost Stars 3.kosm"
                even
MapEni_BlueSphereTitleFG:
                binclude "data/General/Blue Sphere/Enigma Map/Title FG.eni"
                even
ArtKos_BlueSphereChar:
                binclude "data/General/Blue Sphere/Kosinski Art/Characters.kos"
                even
Map_BlueSphereCharSprite:
                include "src/game/blue_sphere/shared/blue_sphere/map_character_sprites.s"
                even
ArtKos_BlueSphereCharSprite:
                binclude "data/General/Blue Sphere/Kosinski Art/Character Sprites.kos"
                even
ArtKos_BlueSphereNormalText:
                binclude "data/General/Blue Sphere/Kosinski Art/Normal Text.kos"
                even
MapEni_BlueSphereTitleBG:
                binclude "data/General/Blue Sphere/Enigma Map/Title BG.eni"
                even
ArtNem_BlueSphereSKLogo:
                binclude "data/General/Blue Sphere/Nemesis Art/SK Logo.nem"
                even
ArtNem_BlueSphereTails:
                binclude "data/General/Blue Sphere/Nemesis Art/Tails Pose.nem"
                even
ArtNem_MilesLifeIcon:
                binclude "data/General/Sprites/HUD Icon/Miles Life Icon.nem"
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
ArtNem_GrayButton:
                binclude "data/General/Sprites/Buttons/Gray Button.nem"
                even
ArtNem_DiagonalSpring:
                binclude "data/General/Sprites/Level Misc/Diagonal Spring.nem"
                even
ArtNem_SonicLifeIcon:
                binclude "data/General/Sprites/HUD Icon/Sonic Life Icon.nem"
                even
ArtNem_KnucklesLifeIcon:
                binclude "data/General/Sprites/HUD Icon/Knuckles Life Icon.nem"
                even
ArtNem_Monitors:
                binclude "data/General/Sprites/Monitors/Monitors.nem"
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
ArtNem_BonusStage:
                binclude "data/Levels/Gumball/Nemesis Art/Gumball Bonus.nem"
                even

                align   $100

FBZ_16x16_Kos:
                binclude "data/Levels/FBZ/Blocks/Primary.kos"
                even
ArtKosM_FBZ:
                binclude "data/Levels/FBZ/Tiles/Primary.kosm"
                even
FBZ_128x128_Kos:
                binclude "data/Levels/FBZ/Chunks/Primary.kos"
                even
MHZ_16x16_Primary_Kos:
                binclude "data/Levels/MHZ/Blocks/Primary.kos"
                even
ArtKosM_MHZ_Primary:
                binclude "data/Levels/MHZ/Tiles/Primary.kosm"
                even
MHZ_128x128_Primary_Kos:
                binclude "data/Levels/MHZ/Chunks/Primary.kos"
                even
MHZ_16x16_Secondary_Kos:
                binclude "data/Levels/MHZ/Blocks/Secondary.kos"
                even
ArtKosM_MHZ_Secondary:
                binclude "data/Levels/MHZ/Tiles/Secondary.kosm"
                even
MHZ_128x128_Secondary_Kos:
                binclude "data/Levels/MHZ/Chunks/Secondary.kos"
                even
MHZ_16x16_Custom_Kos:
                binclude "data/Levels/MHZ/Blocks/Custom.kos"
                even
ArtKosM_MHZ_Custom:
                binclude "data/Levels/MHZ/Tiles/Custom.kosm"
                even
MHZ_128x128_Custom_Kos:
                binclude "data/Levels/MHZ/Chunks/Custom.kos"
                even
SOZ_16x16_Primary_Kos:
                binclude "data/Levels/SOZ/Blocks/Primary.kos"
                even
ArtKosM_SOZ_Primary:
                binclude "data/Levels/SOZ/Tiles/Primary.kosm"
                even
SOZ_128x128_Kos:    binclude "data/Levels/SOZ/Chunks/Primary.bin"
                even
SOZ1_16x16_Secondary_Kos:
                binclude "data/Levels/SOZ/Blocks/Act 1 Secondary.kos"
                even
ArtKosM_SOZ1_Secondary:
                binclude "data/Levels/SOZ/Tiles/Act 1 Secondary.kosm"
                even
SOZ_128x128_Unused_Kos:
                binclude "data/Levels/SOZ/Chunks/Unused.kos"  ; This is in the same spot Act 1 Secondary chunks go
                even
SOZ1_16x16_Custom_Kos:
                binclude "data/Levels/SOZ/Blocks/Act 1 Custom.kos"
                even
ArtKosM_SOZ1_Custom:
                binclude "data/Levels/SOZ/Tiles/Act 1 Custom.kosm"
                even
SOZ2_16x16_Secondary_Kos:
                binclude "data/Levels/SOZ/Blocks/Act 2 Secondary.kos"
                even
ArtKosM_SOZ2_Secondary:
                binclude "data/Levels/SOZ/Tiles/Act 2 Secondary.kosm"
                even
SOZ_128x128_Unused2_Kos:
                binclude "data/Levels/SOZ/Chunks/Unused2.kos"  ; This is in the same spot Act 2 Secondary chunks go
                even
SOZ2_16x16_Custom_Kos:
                binclude "data/Levels/SOZ/Blocks/Act 2 Custom.kos"
                even
ArtKosM_SOZ2_Custom:
                binclude "data/Levels/SOZ/Tiles/Act 2 Custom.kosm"
                even
LRZ_16x16_Primary_Kos:
                binclude "data/Levels/LRZ/Blocks/Primary.kos"
                even
ArtKosM_LRZ_Primary:
                binclude "data/Levels/LRZ/Tiles/Primary.kosm"
                even
LRZ_128x128_Primary_Kos:
                binclude "data/Levels/LRZ/Chunks/Primary.kos"
                even
LRZ1_16x16_Secondary_Kos:
                binclude "data/Levels/LRZ/Blocks/Act 1 Secondary.kos"
                even
ArtKosM_LRZ1_Secondary:
                binclude "data/Levels/LRZ/Tiles/Act 1 Secondary.kosm"
                even
LRZ1_128x128_Secondary_Kos:
                binclude "data/Levels/LRZ/Chunks/Act 1 Secondary.kos"
                even
LRZ2_16x16_Secondary_Kos:
                binclude "data/Levels/LRZ/Blocks/Act 2 Secondary.kos"
                even
ArtKosM_LRZ2_Secondary:
                binclude "data/Levels/LRZ/Tiles/Act 2 Secondary.kosm"
                even
LRZ2_128x128_Secondary_Kos:
                binclude "data/Levels/LRZ/Chunks/Act 2 Secondary.kos"
                even
HPZ_16x16_Primary_Kos:
                binclude "data/Levels/HPZ/Blocks/Primary.kos"
                even
ArtKosM_HPZ_Primary:
                binclude "data/Levels/HPZ/Tiles/Primary.kosm"
                even
HPZ_128x128_Primary_Kos:
                binclude "data/Levels/HPZ/Chunks/Primary.kos"
                even
LRZ3_16x16_Secondary_Kos:
                binclude "data/Levels/LRZ/Blocks/Act 3 Secondary.kos"
                even
ArtKosM_LRZ3_Secondary:
                binclude "data/Levels/LRZ/Tiles/Boss Secondary.kosm"
                even
LRZ3_128x128_Secondary_Kos:
                binclude "data/Levels/LRZ/Chunks/Act 3 Secondary.kos"
                even
HPZ_16x16_Secondary_Kos:
                binclude "data/Levels/HPZ/Blocks/Secondary.kos"
                even
ArtKosM_HPZ_Secondary:
                binclude "data/Levels/HPZ/Tiles/Secondary.kosm"
                even
HPZ_128x128_Secondary_Kos:
                binclude "data/Levels/HPZ/Chunks/Secondary.kos"
                even
SSZ1_16x16_Primary_Kos:
                binclude "data/Levels/SSZ/Blocks/Act 1 Primary.kos"
                even
ArtKosM_SSZ1_Primary:
                binclude "data/Levels/SSZ/Tiles/Act 1 Primary.kosm"
                even
SSZ1_128x128_Primary_Kos:
                binclude "data/Levels/SSZ/Chunks/Act 1 Primary.kos"
                even
SSZ1_16x16_Secondary_Kos:
                binclude "data/Levels/SSZ/Blocks/Act 1 Secondary.kos"
                even
ArtKosM_SSZ1_Secondary:
                binclude "data/Levels/SSZ/Tiles/Act 1 Secondary.kosm"
                even
SSZ1_128x128_Secondary_Kos:
                binclude "data/Levels/SSZ/Chunks/Act 1 Secondary.kos"
                even
SSZ1_16x16_Custom_Kos:
                binclude "data/Levels/SSZ/Blocks/Act 1 Custom.kos"
                even
ArtKosM_SSZ1_Custom:
                binclude "data/Levels/SSZ/Tiles/Act 1 Custom.kosm"
                even
SSZ1_128x128_Custom_Kos:
                binclude "data/Levels/SSZ/Chunks/Act 1 Custom.kos"
                even
SSZ2_16x16_Kos:
                binclude "data/Levels/SSZ/Blocks/Act 2.kos"
                even
ArtKosM_SSZ2:
                binclude "data/Levels/SSZ/Tiles/Act 2.kosm"
                even
SSZ2_128x128_Kos:
                binclude "data/Levels/SSZ/Chunks/Act 2.kos"
                even
DEZ_16x16_Primary_Kos:
                binclude "data/Levels/DEZ/Blocks/Primary.kos"
                even
ArtKosM_DEZ_Primary:
                binclude "data/Levels/DEZ/Tiles/Primary.kosm"
                even
DEZ_128x128_Kos:
                binclude "data/Levels/DEZ/Chunks/Primary.kos"
                even
DEZ1_16x16_Secondary_Kos:
                binclude "data/Levels/DEZ/Blocks/Act 1 Secondary.kos"
                even
ArtKosM_DEZ1_Secondary:
                binclude "data/Levels/DEZ/Tiles/Act 1 Secondary.kosm"
                even
DEZ2_16x16_Secondary_Kos:
                binclude "data/Levels/DEZ/Blocks/Act 2 Secondary.kos"
                even
ArtKosM_DEZ2_Secondary:
                binclude "data/Levels/DEZ/Tiles/Act 2 Secondary.kosm"
                even
DEZ3_16x16_Kos:
                binclude "data/Levels/DEZ/Blocks/Act 3.kos"
                even
ArtKosM_DEZ3:
                binclude "data/Levels/DEZ/Tiles/Final Boss Act.kosm"
                even
DEZ3_128x128_Kos:
                binclude "data/Levels/DEZ/Chunks/Act 3.kos"
                even
DDZ_16x16_Kos:
                binclude "data/Levels/DDZ/Blocks/Primary.kos"
                even
ArtKosM_DDZ:
                binclude "data/Levels/DDZ/Tiles/Primary.kosm"
                even
DDZ_128x128_Kos:
                binclude "data/Levels/DDZ/Chunks/Primary.kos"
                even
Pachinko_16x16_Kos:
                binclude "data/Levels/Pachinko/Blocks/Primary.kos"
                even
ArtKosM_Pachinko:
                binclude "data/Levels/Pachinko/Tiles/Pachinko.kosm"
                even
Pachinko_128x128_Kos:
                binclude "data/Levels/Pachinko/Chunks/Primary.kos"
                even
Slots_16x16_Kos:
                binclude "data/Levels/Slots/Blocks/Primary.kos"
                even
ArtKosM_Slots:
                binclude "data/Levels/Slots/Tiles/Slots.kosm"
                even
Slots_128x128_Kos:
                binclude "data/Levels/Slots/Chunks/Primary.kos"
                even

                align   $100

Character_Speeds:
                dc.w    $600,  $10,  $20,    0          ; Sonic
                dc.w    $4C0,  $1C,  $70,    0          ; Tails
                dc.w    $580,  $10, $200,    0          ; Knuckles
Sonic_Start_Locations:
                binclude "data/Levels/AIZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/AIZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/HCZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/HCZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/MGZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/MGZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/CNZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/CNZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/FBZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/FBZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/ICZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/ICZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/LBZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/LBZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/MHZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/MHZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/SOZ/Start Location/Sonic/1.bin"
SOZ2_Start:     binclude "data/Levels/SOZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/LRZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/LRZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/SSZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/SSZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/DEZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/DEZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/DDZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/DDZ/Start Location/Sonic/2.bin"
                binclude "data/Levels/AIZ/Start Location/Sonic/Intro.bin"
                binclude "data/Levels/SSZ/Start Location/Sonic/Ending.bin"
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
                binclude "data/Levels/Pachinko/Start Location/Sonic/1.bin"
                binclude "data/Levels/Pachinko/Start Location/Sonic/2.bin"
                binclude "data/Levels/Slots/Start Location/Sonic/1.bin"
                binclude "data/Levels/Slots/Start Location/Sonic/2.bin"
                binclude "data/Levels/LRZ/Start Location/Sonic/Boss.bin"
                binclude "data/Levels/HPZ/Start Location/Sonic/1.bin"
                binclude "data/Levels/DEZ/Start Location/Sonic/Boss.bin"
                binclude "data/Levels/HPZ/Start Location/Sonic/Special Stage.bin"
Knux_Start_Locations:
                binclude "data/Levels/AIZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/AIZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/HCZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/HCZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/MGZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/MGZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/CNZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/CNZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/FBZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/FBZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/ICZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/ICZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/LBZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/LBZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/MHZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/MHZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/SOZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/SOZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/LRZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/LRZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/SSZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/SSZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/DEZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/DEZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/DDZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/DDZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/AIZ/Start Location/Knuckles/Intro.bin"
                binclude "data/Levels/SSZ/Start Location/Knuckles/Ending.bin"
                binclude "data/Levels/ALZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/ALZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/BPZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/BPZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/DPZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/DPZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/CGZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/CGZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/EMZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/EMZ/Start Location/Knuckles/2.bin"
                binclude "data/Levels/Gumball/Start Location/Knuckles/1.bin"
                binclude "data/Levels/Gumball/Start Location/Knuckles/2.bin"
                binclude "data/Levels/Pachinko/Start Location/Knuckles/1.bin"
                binclude "data/Levels/Pachinko/Start Location/Knuckles/2.bin"
                binclude "data/Levels/Slots/Start Location/Knuckles/1.bin"
                binclude "data/Levels/Slots/Start Location/Knuckles/2.bin"
                binclude "data/Levels/LRZ/Start Location/Knuckles/Boss.bin"
                binclude "data/Levels/HPZ/Start Location/Knuckles/1.bin"
                binclude "data/Levels/DEZ/Start Location/Knuckles/Boss.bin"
                binclude "data/Levels/HPZ/Start Location/Knuckles/Special Stage.bin"
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
                dc.l    Ending_Sprites
                dc.l    Ending_Sprites
                dc.l    ALZ_Sprites
                dc.l    ALZ_Sprites
                dc.l    BPZ_Sprites
                dc.l    BPZ_Sprites
                dc.l    DPZ_Sprites
                dc.l    DPZ_Sprites
                dc.l    CGZ_Sprites
                dc.l    CGZ_Sprites
                dc.l    EMZ_Sprites
                dc.l    EMZ_Sprites
                dc.l    Gumball_Sprites
                dc.l    Gumball_Sprites
                dc.l    Pachinko_Sprites
                dc.l    Pachinko_Sprites
                dc.l    Slots_Sprites
                dc.l    Slots_Sprites
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
                dc.l    Ending_Rings
                dc.l    Ending_Rings
                dc.l    ALZ_Rings
                dc.l    ALZ_Rings
                dc.l    BPZ_Rings
                dc.l    BPZ_Rings
                dc.l    DPZ_Rings
                dc.l    DPZ_Rings
                dc.l    CGZ_Rings
                dc.l    CGZ_Rings
                dc.l    EMZ_Rings
                dc.l    EMZ_Rings
                dc.l    Gumball_Rings
                dc.l    Gumball_Rings
                dc.l    Pachinko_Rings
                dc.l    Pachinko_Rings
                dc.l    Slots_Rings
                dc.l    Slots_Rings
                dc.l    LRZ3_Rings
                dc.l    HPZ_Rings
                dc.l    DEZ3_Rings
                dc.l    DEZ3_Rings
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
                dc.l    AutoTunnel_15                   ; LRZ2 first
                dc.l    AutoTunnel_16
                dc.l    AutoTunnel_17
                dc.l    AutoTunnel_18
                dc.l    AutoTunnel_19
                dc.l    SpriteTerminatB
                dc.l    SpriteTerminatB
                dc.l    SpriteTerminatB
                dc.l    SpriteTerminatB
                dc.l    SpriteTerminatB
                dc.l    SpriteTerminatB
FBZSnakePlatform_Data:
                dc.l    word_1EE2D4
                dc.l    word_1EE2E4
                dc.l    word_1EE2F4
                dc.l    word_1EE310
                dc.l    word_1EE330
                dc.l    word_1EE350
                dc.l    word_1EE36C
                dc.l    word_1EE398
                dc.l    SpriteTerminat7
                dc.l    SpriteTerminat7
                dc.l    SpriteTerminat7
                dc.l    SpriteTerminat7
                dc.l    SpriteTerminat7
                dc.l    SpriteTerminat7
                dc.l    SpriteTerminat7
                dc.l    SpriteTerminat7
SOZRockRideInfo:
                dc.l    word_1F6C70
                dc.l    word_1F6C78
                dc.l    word_1F6C82
                dc.l    word_1F6C8E
                dc.l    word_1F6C9A
                dc.l    word_1F6CA6
                dc.l    word_1F6CB0
                dc.l    word_1F6CBC
                dc.l    word_1F6CC2
                dc.l    word_1F6CCA
                dc.l    word_1F6CD4
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
                dc.l    word_1F6CDA
DEZTunnelPaths:
                dc.l    word_1FB49E
                dc.l    word_1FB518
                dc.l    word_1FB5B2
                dc.l    word_1FB5B2
                dc.l    word_1FB5F0
                dc.l    word_1FB646
                dc.l    word_1FB6B4
                dc.l    word_1FB6CE
SSCompressedLayoutPtrs:
                dc.l    SSLayoutData1_Kos
                dc.l    SSLayoutData2_Kos
SlotBonusLayout:
                binclude "data/Levels/Slots/SSLayout/Bonus Player Start.bin"
                even
                binclude "data/Levels/Slots/SSLayout/Bonus Layout.bin"
                even
byte_1E4484:
                dc.b    1,   3,   1,   3,   8,   3,   8,   5,   1,   3,   6,   4,   1,   7,   6,   5,   8,   6,   4,   3
                dc.b    4,   3,   4,   5,   8,   4,   5,   3,   7,   3,   8,   3,   6,   5,   6,   7,   4,   3,   7,   5
                dc.b    6,   4,   6,   4,   7,   3,   3,   5,   4,   3,   4,   6,   3,   4,   3,   7,   4,   3,   4,   3
                dc.b    4,   3,   4,   3
byte_1E44C4:
                dc.b    $50, $32, $28, $23, $23, $1E, $1E, $14, $14,  $A,  $A,  $A,  $A,   5,   5,   5
                even
SpriteTerminat1:
                dc.w    $FFFF, 0, 0
AIZ1_Sprites:
                binclude "data/Levels/AIZ/Object Pos/1.bin"
                even
AIZ2_Sprites:
                binclude "data/Levels/AIZ/Object Pos/2.bin"
                even
AIZ1_Rings:
                binclude "data/Levels/AIZ/Ring Pos/1.bin"
                even
AIZ2_Rings:
                binclude "data/Levels/AIZ/Ring Pos/2.bin"
                even
SpriteTerminat2:
                dc.w    $FFFF, 0, 0
HCZ1_Sprites:
                binclude "data/Levels/HCZ/Object Pos/1.bin"
                even
HCZ2_Sprites:
                binclude "data/Levels/HCZ/Object Pos/2.bin"
                even
HCZ1_Rings:
                binclude "data/Levels/HCZ/Ring Pos/1.bin"
                even
HCZ2_Rings:
                binclude "data/Levels/HCZ/Ring Pos/2.bin"
                even
SpriteTerminat3:
                dc.w    $FFFF, 0, 0
MGZ1_Sprites:
                binclude "data/Levels/MGZ/Object Pos/1.bin"
                even
MGZ1_Rings:
                binclude "data/Levels/MGZ/Ring Pos/1.bin"
                even
SpriteTerminat4:
                dc.w    $FFFF, 0, 0
MGZ2_Sprites:
                binclude "data/Levels/MGZ/Object Pos/2.bin"
                even
MGZ2_Rings:
                binclude "data/Levels/MGZ/Ring Pos/2.bin"
                even
SpriteTerminat5:
                dc.w    $FFFF, 0, 0
CNZ1_Sprites:
                binclude "data/Levels/CNZ/Object Pos/1.bin"
                even
CNZ2_Sprites:
                binclude "data/Levels/CNZ/Object Pos/2.bin"
                even
CNZ1_Rings:
                binclude "data/Levels/CNZ/Ring Pos/1.bin"
                even
CNZ2_Rings:
                binclude "data/Levels/CNZ/Ring Pos/2.bin"
                even
SpriteTerminat6:
                dc.w    $FFFF, 0, 0
FBZ1_Sprites:
                binclude "data/Levels/FBZ/Object Pos/1.bin"
                even
FBZ2_Sprites:
                binclude "data/Levels/FBZ/Object Pos/2.bin"
                even
FBZ1_Rings:
                binclude "data/Levels/FBZ/Ring Pos/1.bin"
                even
FBZ2_Rings:
                binclude "data/Levels/FBZ/Ring Pos/2.bin"
                even
word_1EE2D4:
                dc.w    $10F1
                dc.w    $118C
                dc.w    $118C
                dc.w    $770
                dc.w    $10F1
                dc.w    $770
                dc.w    $FFFF
                dc.w    $3C
word_1EE2E4:
                dc.w    $1174
                dc.w    $120F
                dc.w    $1174
                dc.w    $7F0
                dc.w    $120F
                dc.w    $7F0
                dc.w    $FFFF
                dc.w    $3C
word_1EE2F4:
                dc.w    $C56
                dc.w    $D64
                dc.w    $D64
                dc.w    $420
                dc.w    $C56
                dc.w    $420
                dc.w    $C56
                dc.w    $510
                dc.w    $D64
                dc.w    $510
                dc.w    $D64
                dc.w    $420
                dc.w    $FFFF
                dc.w    0
word_1EE310:
                dc.w    $B64
                dc.w    $CE3
                dc.w    $C1A
                dc.w    $317
                dc.w    $CE3
                dc.w    $317
                dc.w    $CE3
                dc.w    $3C8
                dc.w    $B64
                dc.w    $3C8
                dc.w    $B64
                dc.w    $317
                dc.w    $C1A
                dc.w    $317
                dc.w    $FFFF
                dc.w    0
word_1EE330:
                dc.w    $B64
                dc.w    $CE3
                dc.w    $C1B
                dc.w    $3C8
                dc.w    $B65
                dc.w    $3C8
                dc.w    $B65
                dc.w    $317
                dc.w    $CE3
                dc.w    $317
                dc.w    $CE3
                dc.w    $3C8
                dc.w    $C1B
                dc.w    $3C8
                dc.w    $FFFF
                dc.w    0
word_1EE350:
                dc.w    $C56
                dc.w    $D64
                dc.w    $C56
                dc.w    $510
                dc.w    $D64
                dc.w    $510
                dc.w    $D64
                dc.w    $420
                dc.w    $C56
                dc.w    $420
                dc.w    $C56
                dc.w    $510
                dc.w    $FFFF
                dc.w    0
word_1EE36C:
                dc.w    $1D79
                dc.w    $1EEB
                dc.w    $1EEB
                dc.w    $213
                dc.w    $1EEB
                dc.w    $400
                dc.w    $1D79
                dc.w    $400
                dc.w    $1D79
                dc.w    $319
                dc.w    $1E82
                dc.w    $319
                dc.w    $1E82
                dc.w    $369
                dc.w    $1E1E
                dc.w    $369
                dc.w    $1E1E
                dc.w    $213
                dc.w    $1EEB
                dc.w    $213
                dc.w    $FFFF
                dc.w    0
word_1EE398:
                dc.w    $1D79
                dc.w    $1EEB
                dc.w    $1E82
                dc.w    $319
                dc.w    $1E82
                dc.w    $369
                dc.w    $1E1E
                dc.w    $369
                dc.w    $1E1E
                dc.w    $213
                dc.w    $1EEB
                dc.w    $213
                dc.w    $1EEB
                dc.w    $400
                dc.w    $1D79
                dc.w    $400
                dc.w    $1D79
                dc.w    $319
                dc.w    $1E82
                dc.w    $319
                dc.w    $FFFF
                dc.w    0
SpriteTerminat7:
                dc.w    $FFFF, 0, 0
ICZ1_Sprites:
                binclude "data/Levels/ICZ/Object Pos/1.bin"
                even
ICZ2_Sprites:
                binclude "data/Levels/ICZ/Object Pos/2.bin"
                even
ICZ1_Rings:
                binclude "data/Levels/ICZ/Ring Pos/1.bin"
                even
ICZ2_Rings:
                binclude "data/Levels/ICZ/Ring Pos/2.bin"
                even
SpriteTerminat8:
                dc.w    $FFFF, 0, 0
LBZ1_Sprites:
                binclude "data/Levels/LBZ/Object Pos/1.bin"
                even
LBZ2_Sprites:
                binclude "data/Levels/LBZ/Object Pos/2.bin"
                even
LBZ1_Rings:
                binclude "data/Levels/LBZ/Ring Pos/1.bin"
                even
LBZ2_Rings:
                binclude "data/Levels/LBZ/Ring Pos/2.bin"
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
                dc.w    $FFFF, 0, 0
MHZ1_Sprites:
                binclude "data/Levels/MHZ/Object Pos/1.bin"
                even
MHZ2_Sprites:
                binclude "data/Levels/MHZ/Object Pos/2.bin"
                even
MHZ1_Rings:
                binclude "data/Levels/MHZ/Ring Pos/1.bin"
                even
MHZ2_Rings:
                binclude "data/Levels/MHZ/Ring Pos/2.bin"
                even
SpriteTerminatA:
                dc.w    $FFFF, 0, 0
SOZ1_Sprites:
                binclude "data/Levels/SOZ/Object Pos/1.bin"
                even
SOZ2_Sprites:
                binclude "data/Levels/SOZ/Object Pos/2.bin"
                even
SOZ1_Rings:
                binclude "data/Levels/SOZ/Ring Pos/1.bin"
                even
SOZ2_Rings:
                binclude "data/Levels/SOZ/Ring Pos/2.bin"
                even
word_1F6C70:
                dc.w    $A68, $13A0
                dc.w    $D00, $FFFF
word_1F6C78:
                dc.w    $A70, $19C0
                dc.w    $AD2, $1AF0
                dc.w    $FFFF
word_1F6C82:
                dc.w    $470, $1F40
                dc.w    $490, $1FA0
                dc.w    $D00, $FFFF
word_1F6C8E:
                dc.w    $AD0, $2D80
                dc.w    $B00, $2E30
                dc.w    $D00, $FFFF
word_1F6C9A:
                dc.w    $450, $24C0
                dc.w    $4F0, $2560
                dc.w    $D00, $FFFF
word_1F6CA6:
                dc.w    $270, $1600
                dc.w    $2D2, $1730
                dc.w    $FFFF
word_1F6CB0:
                dc.w    $A68, $2740
                dc.w    $A80, $2838
                dc.w    $D00, $FFFF
word_1F6CBC:
                dc.w    $5EC, $47F0
                dc.w    $FFFF
word_1F6CC2:
                dc.w    $4E0, $4620
                dc.w    $600, $FFFF
word_1F6CCA:
                dc.w    $630,  $460
                dc.w    $652,  $4F0
                dc.w    $FFFF
word_1F6CD4:
                dc.w    $6F0, $2D70
                dc.w    $FFFF
word_1F6CDA:
                dc.w    $FFFF
AutoTunnel_15:
                dc.w    $30
                dc.w    $11B8,  $6F0
                dc.w    $1270,  $6F0
                dc.w    $128C,  $6F3
                dc.w    $12A1,  $6FE
                dc.w    $12AD,  $710
                dc.w    $12B0,  $728
                dc.w    $12B0,  $8B0
                dc.w    $12AC,  $8D1
                dc.w    $12A0,  $8E3
                dc.w    $128C,  $8EE
                dc.w    $1270,  $8F0
                dc.w    $11B8,  $8F0
AutoTunnel_16:
                dc.w    $80
                dc.w    $17B8,  $B70
                dc.w    $1870,  $B70
                dc.w    $1890,  $B6D
                dc.w    $18A0,  $B63
                dc.w    $18AD,  $B53
                dc.w    $18B0,  $B33
                dc.w    $18B0,  $8B0
                dc.w    $18B2,  $893
                dc.w    $18BC,  $880
                dc.w    $18CE,  $872
                dc.w    $18F0,  $870
                dc.w    $1A70,  $870
                dc.w    $1A90,  $86D
                dc.w    $1AA2,  $862
                dc.w    $1AAE,  $84E
                dc.w    $1AB0,  $830
                dc.w    $1AB0,  $6B0
                dc.w    $1AB2,  $692
                dc.w    $1ABD,  $67E
                dc.w    $1AD2,  $671
                dc.w    $1AF0,  $670
                dc.w    $1B70,  $670
                dc.w    $1B90,  $66D
                dc.w    $1BA2,  $662
                dc.w    $1BAF,  $64E
                dc.w    $1BB0,  $630
                dc.w    $1BB0,  $4B0
                dc.w    $1BB0,  $495
                dc.w    $1BA2,  $47E
                dc.w    $1B8D,  $471
                dc.w    $1B70,  $470
                dc.w    $1AB8,  $470
AutoTunnel_17:
                dc.w    $2C
                dc.w    $22B8,   $70
                dc.w    $2370,   $70
                dc.w    $2390,   $73
                dc.w    $23A1,   $7E
                dc.w    $23AD,   $90
                dc.w    $23B0,   $B0
                dc.w    $23B0,  $1B0
                dc.w    $23B2,  $1D1
                dc.w    $23BF,  $1E4
                dc.w    $23D6,  $1F0
                dc.w    $2448,  $1F0
AutoTunnel_18:
                dc.w    $58
                dc.w    $2D48,  $7F0
                dc.w    $2CF0,  $7F0
                dc.w    $2CD0,  $7EE
                dc.w    $2CBD,  $7E3
                dc.w    $2CB2,  $7D0
                dc.w    $2CB0,  $7B0
                dc.w    $2CB0,  $430
                dc.w    $2CB1,  $411
                dc.w    $2CBB,  $3FF
                dc.w    $2CCF,  $3F2
                dc.w    $2CF0,  $3F0
                dc.w    $2D70,  $3F0
                dc.w    $2D90,  $3ED
                dc.w    $2DA2,  $3E2
                dc.w    $2DAF,  $3CE
                dc.w    $2DB0,  $3B0
                dc.w    $2DB0,  $330
                dc.w    $2DB2,  $311
                dc.w    $2DBC,  $2FE
                dc.w    $2DD1,  $2F1
                dc.w    $2DEF,  $2F0
                dc.w    $30F0,  $2F0
AutoTunnel_19:
                dc.w    $30
                dc.w    $3A38,  $3F0
                dc.w    $3AF0,  $3F0
                dc.w    $3B10,  $3EE
                dc.w    $3B23,  $3E0
                dc.w    $3B2F,  $3CA
                dc.w    $3B30,  $3B0
                dc.w    $3B30,  $230
                dc.w    $3B32,  $211
                dc.w    $3B3C,  $1FF
                dc.w    $3B50,  $1F2
                dc.w    $3B70,  $1F0
                dc.w    $3BC8,  $1F0
SpriteTerminatB:
                dc.w    $FFFF, 0, 0
LRZ1_Sprites:
                binclude "data/Levels/LRZ/Object Pos/1.bin"
                even
LRZ2_Sprites:
                binclude "data/Levels/LRZ/Object Pos/2.bin"
                even
LRZ1_Rings:
                binclude "data/Levels/LRZ/Ring Pos/1.bin"
                even
LRZ2_Rings:
                binclude "data/Levels/LRZ/Ring Pos/2.bin"
                even
SpriteTerminatC:
                dc.w    $FFFF, 0, 0
SSZ1_Sprites:
                binclude "data/Levels/SSZ/Object Pos/1.bin"
                even
SSZ2_Sprites:
                binclude "data/Levels/SSZ/Object Pos/2.bin"
                even
SSZ1_Rings:
                binclude "data/Levels/SSZ/Ring Pos/1.bin"
                even
SSZ2_Rings:
                binclude "data/Levels/SSZ/Ring Pos/2.bin"
                even
SpriteTerminatD:
                dc.w    $FFFF, 0, 0
DEZ1_Sprites:
                binclude "data/Levels/DEZ/Object Pos/1.bin"
                even
DEZ2_Sprites:
                binclude "data/Levels/DEZ/Object Pos/2.bin"
                even
DEZ1_Rings:
                binclude "data/Levels/DEZ/Ring Pos/1.bin"
                even
DEZ2_Rings:
                binclude "data/Levels/DEZ/Ring Pos/2.bin"
                even
word_1FB49E:    dc.w    $1E
                dc.w    $1B80,  $331
                dc.w    $1BD8,  $328
                dc.w    $1C8C,  $328
                dc.w    $8004,  $400
                dc.w    $8108,  $800
                dc.w    $80FC, $7C80
                dc.w    $80FC, $7C40
                dc.w    $81F8, $3880
                dc.w    $8004,  $480
                dc.w    $8108, $8840
                dc.w    $81F8, $B840
                dc.w    $8108, $C840
                dc.w    $8004, $44C0
                dc.w    $8108, $C800
                dc.w    $81F8, $7880
                dc.w    $8004,  $440
                dc.w    $80FC, $BC80
                dc.w    $8108,  $800
                dc.w    $81F8, $7840
                dc.w    $8004, $C400
                dc.w    $8108,  $800
                dc.w    $8004,  $840
                dc.w    $8108, $4840
                dc.w    $8004, $4480
                dc.w    $81F8, $F880
                dc.w    $80FC, $7C00
                dc.w    $81F8, $F880
                dc.w    $202C,  $1A8
                dc.w    $81F8, $7880
                dc.w    $20D4,  $1A8
word_1FB518:    dc.w    $26
                dc.w    $2B80,  $3B1
                dc.w    $2BD8,  $3A8
                dc.w    $2C78,  $3A8
                dc.w    $8004,  $4C0
                dc.w    $8108, $C8C0
                dc.w    $8004, $C400
                dc.w    $81F8, $7840
                dc.w    $8108, $C800
                dc.w    $8004,  $480
                dc.w    $81F8, $F800
                dc.w    $8108, $88C0
                dc.w    $8004, $C440
                dc.w    $8108, $48C0
                dc.w    $8004, $C440
                dc.w    $81F8, $B840
                dc.w    $80FC, $3C80
                dc.w    $81F8, $7800
                dc.w    $80FC, $FC40
                dc.w    $81F8, $38C0
                dc.w    $80FC, $BC40
                dc.w    $81F8, $38C0
                dc.w    $80FC, $BC40
                dc.w    $81F8, $38C0
                dc.w    $80FC, $BC40
                dc.w    $81F8, $38C0
                dc.w    $80FC, $BC80
                dc.w    $3044,  $268
                dc.w    $81F8, $7880
                dc.w    $80FC, $7CC0
                dc.w    $81F8, $B880
                dc.w    $8108,  $800
                dc.w    $8004,  $440
                dc.w    $81F8, $B880
                dc.w    $80FC, $7CC0
                dc.w    $81F8, $B880
                dc.w    $3140,  $228
                dc.w    $81F8, $7880
                dc.w    $31D0,  $228
word_1FB5B2:    dc.w    $F
                dc.w    $1D00,  $1B1
                dc.w    $1D54,  $1A8
                dc.w    $1E08,  $1A8
                dc.w    $8004,  $400
                dc.w    $8108,  $800
                dc.w    $81F8, $7880
                dc.w    $81F8, $78C0
                dc.w    $80FC, $BC40
                dc.w    $8108, $C8C0
                dc.w    $8108, $C800
                dc.w    $1F44,  $228
                dc.w    $81F8, $7840
                dc.w    $8108, $C8C0
                dc.w    $81F8, $3880
                dc.w    $204C,  $228
word_1FB5F0:    dc.w    $15
                dc.w    $2B80,  $5B1
                dc.w    $2BD8,  $5A8
                dc.w    $2C80,  $5A8
                dc.w    $8108,  $800
                dc.w    $8004,  $400
                dc.w    $2CC8,  $5A8
                dc.w    $80FC, $7C40
                dc.w    $8004, $C440
                dc.w    $8108, $4840
                dc.w    $8108, $4880
                dc.w    $80FC, $FC80
                dc.w    $81F8, $7800
                dc.w    $8108, $8880
                dc.w    $8004, $8400
                dc.w    $2EBC,  $668
                dc.w    $81F8, $7800
                dc.w    $80FC, $FC80
                dc.w    $8108,  $8C0
                dc.w    $8004, $C000
                dc.w    $2F08,  $628
                dc.w    $2F44,  $628
word_1FB646:    dc.w    $1B
                dc.w    $2F00,  $8F1
                dc.w    $2EA8,  $8E8
                dc.w    $2DF4,  $8E8
                dc.w    $80FC, $FCC0
                dc.w    $81F8, $B880
                dc.w    $80FC, $7C00
                dc.w    $80FC, $FC00
                dc.w    $8108, $8840
                dc.w    $8004, $4000
                dc.w    $8108,  $880
                dc.w    $8004, $8480
                dc.w    $81F8, $F840
                dc.w    $80FC, $40C0
                dc.w    $8108, $48C0
                dc.w    $81F8, $3840
                dc.w    $2C34,  $9DC
                dc.w    $8004, $C440
                dc.w    $2D34,  $9AC
                dc.w    $8108, $4880
                dc.w    $81F8, $F800
                dc.w    $8108, $8880
                dc.w    $2C88,  $96C
                dc.w    $80FC, $FC00
                dc.w    $81F8, $F8C0
                dc.w    $8108, $48C0
                dc.w    $81F8, $3800
                dc.w    $2AB0,  $968
word_1FB6B4:    dc.w    6
                dc.w    $2C00,  $6B1
                dc.w    $2BA8,  $6A8
                dc.w    $2AF4,  $688
                dc.w    $8304, $8480
                dc.w    $8304, $8480
                dc.w    $2A40,  $4E8
word_1FB6CE:    dc.w    9
                dc.w    $2500,  $38E
                dc.w    $24A8,  $398
                dc.w    $240C,  $398
                dc.w    $8204, $8480
                dc.w    $8204, $8480
                dc.w    $8204, $8480
                dc.w    $8204, $84C0
                dc.w    $8204, $C400
                dc.w    $24D8,  $638
SpriteTerminatE:
                dc.w    $FFFF, 0, 0
DDZ1_Sprites:
                binclude "data/Levels/DDZ/Object Pos/1.bin"
                even
DDZ2_Sprites:
                binclude "data/Levels/DDZ/Object Pos/2.bin"
                even
DDZ1_Rings:
                binclude "data/Levels/DDZ/Ring Pos/1.bin"
                even
DDZ2_Rings:
                binclude "data/Levels/DDZ/Ring Pos/2.bin"
                even
SpriteTerminatF:
                dc.w    $FFFF, 0, 0
Ending_Sprites:
                binclude "data/Levels/SSZ/Object Pos/Ending.bin"
                even
Ending_Rings:
                binclude "data/Levels/SSZ/Ring Pos/Ending.bin"
                even
SpriteTerminatG:
                dc.w    $FFFF, 0, 0
ALZ_Sprites:
                binclude "data/Levels/ALZ/Object Pos/1.bin"
                even
ALZ_Rings:
                binclude "data/Levels/ALZ/Ring Pos/1.bin"
                even
SpriteTerminatH:
                dc.w    $FFFF, 0, 0
BPZ_Sprites:
                binclude "data/Levels/BPZ/Object Pos/1.bin"
                even
BPZ_Rings:
                binclude "data/Levels/BPZ/Ring Pos/1.bin"
                even
SpriteTerminatI:
                dc.w    $FFFF, 0, 0
DPZ_Sprites:
                binclude "data/Levels/DPZ/Object Pos/1.bin"
                even
DPZ_Rings:
                binclude "data/Levels/DPZ/Ring Pos/1.bin"
                even
SpriteTerminatJ:
                dc.w    $FFFF, 0, 0
CGZ_Sprites:
                binclude "data/Levels/CGZ/Object Pos/1.bin"
                even
CGZ_Rings:
                binclude "data/Levels/CGZ/Ring Pos/1.bin"
                even
SpriteTerminatK:
                dc.w    $FFFF, 0, 0
EMZ_Sprites:
                binclude "data/Levels/EMZ/Object Pos/1.bin"
                even
EMZ_Rings:
                binclude "data/Levels/EMZ/Ring Pos/1.bin"
                even
SpriteTerminatL:
                dc.w    $FFFF, 0, 0
Gumball_Sprites:
                binclude "data/Levels/Gumball/Object Pos/1.bin"
                even
Gumball_Rings:
                binclude "data/Levels/Gumball/Ring Pos/1.bin"
                even
SpriteTerminatM:
                dc.w    $FFFF, 0, 0
Pachinko_Sprites:
                binclude "data/Levels/Pachinko/Object Pos/1.bin"
                even
Pachinko_Rings:
                binclude "data/Levels/Pachinko/Ring Pos/1.bin"
                even
SpriteTerminatN:
                dc.w    $FFFF, 0, 0
Slots_Sprites:
                binclude "data/Levels/Slots/Object Pos/1.bin"
                even
Slots_Rings:
                binclude "data/Levels/Slots/Ring Pos/1.bin"
                even
SpriteTerminatO:
                dc.w    $FFFF, 0, 0
LRZ3_Sprites:
                binclude "data/Levels/LRZ/Object Pos/3.bin"
                even
HPZ_Sprites:
                binclude "data/Levels/HPZ/Object Pos/1.bin"
                even
LRZ3_Rings:
                binclude "data/Levels/LRZ/Ring Pos/3.bin"
                even
HPZ_Rings:
                binclude "data/Levels/HPZ/Ring Pos/1.bin"
                even
SpriteTerminatP:
                dc.w    $FFFF, 0, 0
DEZ3_Sprites:
                binclude "data/Levels/DEZ/Object Pos/3.bin"
                even
HPZMini_Sprites:
                binclude "data/Levels/HPZ/Object Pos/Mini.bin"
                even
DEZ3_Rings:
                binclude "data/Levels/DEZ/Ring Pos/3.bin"
                even
SSLayoutData1_Kos:
                binclude "data/General/Special Stage/Layout/SK Set 1.kos"
                even
SSLayoutData2_Kos:
                binclude "data/General/Special Stage/Layout/SK Set 2.kos"
                even

; AS would automatically strip this padding if we didn't specifically declare one byte at the end
                if      (*)&(*-1)
                cnop    -1,2<<lastbit(*)
                dc.b    $FF
                else
                even
                endif

EndOfROM:
                org     $200000                         ; needed if you want to combine the ROM with Sonic 3 or Sonic 2 and the UPMEM
                include "Lockon S3/LockOn Pointers.s"

                END
