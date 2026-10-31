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
; ---------------------------------------------------------------------------
; 1st PLC  palette                          2nd 8x8 data                                     2nd 16x16 data                                      2nd 128x128 data
; 2nd PLC           1st 8x8 data                                    1st 16x16 data                                    1st 128x128 data
LevelLoadBlock:
                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Primary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,         AIZ1_128x128_Kos  ; ANGEL ISLAND ZONE ACT 1
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ2_8x8_Primary_KosM, AIZ2_8x8_Secondary_KosM, AIZ2_16x16_Primary_Kos, AIZ2_16x16_Secondary_Kos, AIZ2_128x128_Kos,         AIZ2_128x128_Kos  ; ANGEL ISLAND ZONE ACT 2
                levartptrs PLCID_0E, PLCID_0F, PalID_HCZ1, HCZ_8x8_Primary_KosM,  HCZ1_8x8_Secondary_KosM, HCZ_16x16_Primary_Kos,  HCZ1_16x16_Secondary_Kos, HCZ_128x128_Primary_Kos,  HCZ1_128x128_Secondary_Kos  ; HYDROCITY ZONE ACT 1
                levartptrs PLCID_10, PLCID_11, PalID_HCZ2, HCZ_8x8_Primary_KosM,  HCZ2_8x8_Secondary_KosM, HCZ_16x16_Primary_Kos,  HCZ2_16x16_Secondary_Kos, HCZ_128x128_Primary_Kos,  HCZ2_128x128_Secondary_Kos  ; HYDROCITY ZONE ACT 2
                levartptrs PLCID_12, PLCID_12, PalID_MGZ1, MGZ_8x8_Primary_KosM,  MGZ1_8x8_Secondary_KosM, MGZ_16x16_Primary_Kos,  MGZ1_16x16_Secondary_Kos, MGZ_128x128_Primary_Kos,  MGZ1_128x128_Secondary_Kos  ; MARBLE GARDEN ZONE ACT 1
                levartptrs PLCID_14, PLCID_14, PalID_MGZ2, MGZ_8x8_Primary_KosM,  MGZ2_8x8_Secondary_KosM, MGZ_16x16_Primary_Kos,  MGZ2_16x16_Secondary_Kos, MGZ_128x128_Primary_Kos,  MGZ2_128x128_Secondary_Kos  ; MARBLE GARDEN ZONE ACT 2
                levartptrs PLCID_16, PLCID_17, PalID_CNZ1, CNZ_8x8_KosM,          CNZ_8x8_KosM,            CNZ_16x16_Kos,          CNZ_16x16_Kos,            CNZ_128x128_Kos,          CNZ_128x128_Kos  ; CARNIVAL NIGHT ZONE ACT 1
                levartptrs PLCID_18, PLCID_19, PalID_CNZ2, CNZ_8x8_KosM,          CNZ_8x8_KosM,            CNZ_16x16_Kos,          CNZ_16x16_Kos,            CNZ_128x128_Kos,          CNZ_128x128_Kos  ; CARNIVAL NIGHT ZONE ACT 2
                levartptrs PLCID_1A, PLCID_1A, PalID_FBZ1, ArtKosM_FBZ,           ArtKosM_FBZ,             FBZ_16x16_Kos,          FBZ_16x16_Kos,            FBZ_128x128_Kos,          FBZ_128x128_Kos  ; FLYING BATTERY ZONE ACT 1
                levartptrs PLCID_1C, PLCID_1C, PalID_FBZ2, ArtKosM_FBZ,           ArtKosM_FBZ,             FBZ_16x16_Kos,          FBZ_16x16_Kos,            FBZ_128x128_Kos,          FBZ_128x128_Kos  ; FLYING BATTERY ZONE ACT 2
                levartptrs PLCID_1E, PLCID_1E, PalID_ICZ1, ICZ_8x8_Primary_KosM,  ICZ1_8x8_Secondary_KosM, ICZ_16x16_Primary_Kos,  ICZ1_16x16_Secondary_Kos, ICZ_128x128_Primary_Kos,  ICZ1_128x128_Secondary_Kos  ; ICECAP ZONE ACT 1
                levartptrs PLCID_20, PLCID_20, PalID_ICZ2, ICZ_8x8_Primary_KosM,  ICZ2_8x8_Secondary_KosM, ICZ_16x16_Primary_Kos,  ICZ2_16x16_Secondary_Kos, ICZ_128x128_Primary_Kos,  ICZ2_128x128_Secondary_Kos  ; ICECAP ZONE ACT 2
                levartptrs PLCID_22, PLCID_22, PalID_LBZ1, LBZ_8x8_Primary_KosM,  LBZ1_8x8_Secondary_KosM, LBZ_16x16_Primary_Kos,  LBZ1_16x16_Secondary_Kos, LBZ1_128x128_Kos,         LBZ1_128x128_Kos  ; LAUNCH BASE ZONE ACT 1
                levartptrs PLCID_24, PLCID_25, PalID_LBZ2, LBZ_8x8_Primary_KosM,  LBZ2_8x8_Secondary_KosM, LBZ_16x16_Primary_Kos,  LBZ2_16x16_Secondary_Kos, LBZ2_128x128_Kos,         LBZ2_128x128_Kos  ; LAUNCH BASE ZONE ACT 2
                levartptrs PLCID_26, PLCID_26, PalID_MHZ1, ArtKosM_MHZ_Primary,   ArtKosM_MHZ_Secondary,   MHZ_16x16_Primary_Kos,  MHZ_16x16_Secondary_Kos,  MHZ_128x128_Primary_Kos,  MHZ_128x128_Secondary_Kos  ; MUSHROOM HILL ZONE ACT 1
                levartptrs PLCID_28, PLCID_28, PalID_MHZ2, ArtKosM_MHZ_Primary,   ArtKosM_MHZ_Secondary,   MHZ_16x16_Primary_Kos,  MHZ_16x16_Secondary_Kos,  MHZ_128x128_Primary_Kos,  MHZ_128x128_Secondary_Kos  ; MUSHROOM HILL ZONE ACT 2
                levartptrs PLCID_2A, PLCID_2A, PalID_SOZ1, ArtKosM_SOZ_Primary,   ArtKosM_SOZ1_Secondary,  SOZ_16x16_Primary_Kos,  SOZ1_16x16_Secondary_Kos, SOZ_128x128_Kos,          SOZ_128x128_Kos  ; SANDOPOLIS ZONE ACT 1
                levartptrs PLCID_2C, PLCID_2C, PalID_SOZ2, ArtKosM_SOZ_Primary,   ArtKosM_SOZ2_Secondary,  SOZ_16x16_Primary_Kos,  SOZ2_16x16_Secondary_Kos, SOZ_128x128_Kos,          SOZ_128x128_Kos  ; SANDOPOLIS ZONE ACT 2
                levartptrs PLCID_2E, PLCID_2F, PalID_LRZ1, ArtKosM_LRZ_Primary,   ArtKosM_LRZ1_Secondary,  LRZ_16x16_Primary_Kos,  LRZ1_16x16_Secondary_Kos, LRZ_128x128_Primary_Kos,  LRZ1_128x128_Secondary_Kos  ; LAVA REEF ZONE ACT 1
                levartptrs PLCID_30, PLCID_30, PalID_LRZ2, ArtKosM_LRZ_Primary,   ArtKosM_LRZ2_Secondary,  LRZ_16x16_Primary_Kos,  LRZ2_16x16_Secondary_Kos, LRZ_128x128_Primary_Kos,  LRZ2_128x128_Secondary_Kos  ; LAVA REEF ZONE ACT 2
                levartptrs PLCID_32, PLCID_32, PalID_SSZ1, ArtKosM_SSZ1_Primary,  ArtKosM_SSZ1_Secondary,  SSZ1_16x16_Primary_Kos, SSZ1_16x16_Secondary_Kos, SSZ1_128x128_Primary_Kos, SSZ1_128x128_Secondary_Kos  ; SKY SANCTUARY ZONE (SONIC/TAILS)
                levartptrs PLCID_34, PLCID_34, PalID_SSZ2, ArtKosM_SSZ2,          ArtKosM_SSZ2,            SSZ2_16x16_Kos,         SSZ2_16x16_Kos,           SSZ2_128x128_Kos,         SSZ2_128x128_Kos  ; SKY SANCTUARY ZONE (KNUCKLES)
                levartptrs PLCID_36, PLCID_36, PalID_DEZ1, ArtKosM_DEZ_Primary,   ArtKosM_DEZ1_Secondary,  DEZ_16x16_Primary_Kos,  DEZ1_16x16_Secondary_Kos, DEZ_128x128_Kos,          DEZ_128x128_Kos  ; DEATH EGG ZONE ACT 1
                levartptrs PLCID_38, PLCID_38, PalID_DEZ2, ArtKosM_DEZ_Primary,   ArtKosM_DEZ2_Secondary,  DEZ_16x16_Primary_Kos,  DEZ2_16x16_Secondary_Kos, DEZ_128x128_Kos,          DEZ_128x128_Kos  ; DEATH EGG ZONE ACT 2
                levartptrs PLCID_3A, PLCID_3A, PalID_DDZ1, ArtKosM_DDZ,           ArtKosM_DDZ,             DDZ_16x16_Kos,          DDZ_16x16_Kos,            DDZ_128x128_Kos,          DDZ_128x128_Kos  ; DOOMSDAY ZONE
                levartptrs PLCID_3C, PLCID_3C, PalID_DDZ2, ArtKosM_DDZ,           ArtKosM_DDZ,             DDZ_16x16_Kos,          DDZ_16x16_Kos,            DDZ_128x128_Kos,          DDZ_128x128_Kos  ; DOOMSDAY ZONE (unused)

                levartptrs PLCID_0B, PLCID_0B, PalID_AIZ, AIZ1_8x8_Primary_KosM, AIZ1_8x8_MainLevel_KosM, AIZ1_16x16_Primary_Kos, AIZ1_16x16_MainLevel_Kos, AIZ1_128x128_Kos,         AIZ1_128x128_Kos  ; SONIC/TAILS INTRO
                levartptrs PLCID_40, PLCID_40, PalID_Ending2, ArtKosM_SSZ2,          ArtKosM_SSZ2,            SSZ2_16x16_Kos,         SSZ2_16x16_Kos,           SSZ2_128x128_Kos,         SSZ2_128x128_Kos  ; SONIC/TAILS ENDING

                levartptrs PLCID_42, PLCID_42, PalID_ALZ, ALZ_8x8_KosM,          ALZ_8x8_KosM,            ALZ_16x16_Kos,          ALZ_16x16_Kos,            ALZ_128x128_Kos,          ALZ_128x128_Kos  ; AZURE LAKE ZONE
                levartptrs PLCID_42, PLCID_42, PalID_ALZ_2, ALZ_8x8_KosM,          ALZ_8x8_KosM,            ALZ_16x16_Kos,          ALZ_16x16_Kos,            ALZ_128x128_Kos,          ALZ_128x128_Kos  ; AZURE LAKE ZONE (unused)
                levartptrs PLCID_43, PLCID_43, PalID_BPZ, BPZ_8x8_KosM,          BPZ_8x8_KosM,            BPZ_16x16_Kos,          BPZ_16x16_Kos,            BPZ_128x128_Kos,          BPZ_128x128_Kos  ; BALLOON PARK ZONE
                levartptrs PLCID_43, PLCID_43, PalID_BPZ_2, BPZ_8x8_KosM,          BPZ_8x8_KosM,            BPZ_16x16_Kos,          BPZ_16x16_Kos,            BPZ_128x128_Kos,          BPZ_128x128_Kos  ; BALLOON PARK ZONE (unused)
                levartptrs PLCID_44, PLCID_44, PalID_DPZ, DPZ_8x8_KosM,          DPZ_8x8_KosM,            DPZ_16x16_Kos,          DPZ_16x16_Kos,            DPZ_128x128_Kos,          DPZ_128x128_Kos  ; DESERT PALACE ZONE
                levartptrs PLCID_44, PLCID_44, PalID_DPZ, DPZ_8x8_KosM,          DPZ_8x8_KosM,            DPZ_16x16_Kos,          DPZ_16x16_Kos,            DPZ_128x128_Kos,          DPZ_128x128_Kos  ; DESERT PALACE ZONE (unused)
                levartptrs PLCID_45, PLCID_45, PalID_CGZ, CGZ_8x8_KosM,          CGZ_8x8_KosM,            CGZ_16x16_Kos,          CGZ_16x16_Kos,            CGZ_128x128_Kos,          CGZ_128x128_Kos  ; CHROME GADGET ZONE
                levartptrs PLCID_45, PLCID_45, PalID_CGZ, CGZ_8x8_KosM,          CGZ_8x8_KosM,            CGZ_16x16_Kos,          CGZ_16x16_Kos,            CGZ_128x128_Kos,          CGZ_128x128_Kos  ; CHROME GADGET ZONE (unused)
                levartptrs PLCID_46, PLCID_46, PalID_EMZ, EMZ_8x8_KosM,          EMZ_8x8_KosM,            EMZ_16x16_Kos,          EMZ_16x16_Kos,            EMZ_128x128_Kos,          EMZ_128x128_Kos  ; ENDLESS MINE ZONE
                levartptrs PLCID_46, PLCID_46, PalID_EMZ, EMZ_8x8_KosM,          EMZ_8x8_KosM,            EMZ_16x16_Kos,          EMZ_16x16_Kos,            EMZ_128x128_Kos,          EMZ_128x128_Kos  ; ENDLESS MINE ZONE (unused)

                levartptrs PLCID_47, PLCID_47, PalID_Gumball_Special, Gumball_8x8_KosM,      Gumball_8x8_KosM,        Gumball_16x16_Kos,      Gumball_16x16_Kos,        Gumball_128x128_Kos,      Gumball_128x128_Kos  ; GUMBALL
                levartptrs PLCID_47, PLCID_47, PalID_Gumball_Special, Gumball_8x8_KosM,      Gumball_8x8_KosM,        Gumball_16x16_Kos,      Gumball_16x16_Kos,        Gumball_128x128_Kos,      Gumball_128x128_Kos  ; GUMBALL (unused)
                levartptrs PLCID_50, PLCID_50, PalID_Pachinko_Special, ArtKosM_Pachinko,      ArtKosM_Pachinko,        Pachinko_16x16_Kos,     Pachinko_16x16_Kos,       Pachinko_128x128_Kos,     Pachinko_128x128_Kos  ; PACHINKO
                levartptrs PLCID_50, PLCID_50, PalID_Pachinko_Special, ArtKosM_Pachinko,      ArtKosM_Pachinko,        Pachinko_16x16_Kos,     Pachinko_16x16_Kos,       Pachinko_128x128_Kos,     Pachinko_128x128_Kos  ; PACHINKO (unused)
                levartptrs PLCID_51, PLCID_51, PalID_Slot_Special, ArtKosM_Slots,         ArtKosM_Slots,           Slots_16x16_Kos,        Slots_16x16_Kos,          Slots_128x128_Kos,        Slots_128x128_Kos  ; SLOTS
                levartptrs PLCID_51, PLCID_51, PalID_Slot_Special, ArtKosM_Slots,         ArtKosM_Slots,           Slots_16x16_Kos,        Slots_16x16_Kos,          Slots_128x128_Kos,        Slots_128x128_Kos  ; SLOTS (unused)

                levartptrs PLCID_48, PLCID_48, PalID_LRZBoss, ArtKosM_HPZ_Primary,   ArtKosM_LRZ3_Secondary,  HPZ_16x16_Primary_Kos,  LRZ3_16x16_Secondary_Kos, HPZ_128x128_Primary_Kos,  LRZ3_128x128_Secondary_Kos  ; LAVA REEF ZONE BOSS
                levartptrs PLCID_48, PLCID_48, PalID_HPZIntro, ArtKosM_HPZ_Primary,   ArtKosM_HPZ_Secondary,   HPZ_16x16_Primary_Kos,  HPZ_16x16_Secondary_Kos,  HPZ_128x128_Primary_Kos,  HPZ_128x128_Secondary_Kos  ; HIDDEN PALACE ZONE
                levartptrs PLCID_4C, PLCID_4C, PalID_DEZBoss, ArtKosM_DEZ3,          ArtKosM_DEZ3,            DEZ3_16x16_Kos,         DEZ3_16x16_Kos,           DEZ3_128x128_Kos,         DEZ3_128x128_Kos  ; SONIC/TAILS FINAL BOSS
                levartptrs PLCID_48, PLCID_48, PalID_HPZIntro, ArtKosM_HPZ_Primary,   ArtKosM_HPZ_Secondary,   HPZ_16x16_Primary_Kos,  HPZ_16x16_Secondary_Kos,  HPZ_128x128_Primary_Kos,  HPZ_128x128_Secondary_Kos  ; SPECIAL STAGE HUB

; ---------------------------------------------------------------------------

; Assembly macro to define PLC pointer entry
plcptr:         macro   plc,{INTLABEL}
__LABEL__:      label   (*-Offs_PLC)/2
                    dc.w    plc-Offs_PLC
                endm

Offs_PLC:
PLCID_00:       plcptr  PLC_00                          ; Sonic life icon/universal level graphics (unused)
PLCID_01:       plcptr  PLC_01                          ; Sonic life icon/universal level graphics
PLCID_02:       plcptr  PLC_02                          ; Explosions + Squirrel/Flicky (unused)
PLCID_03:       plcptr  PLC_03                          ; Game Over text
PLCID_04:       plcptr  PLC_04                          ; Signpost art (unused)
PLCID_05:       plcptr  PLC_05                          ; Knuckles life icon/universal level graphics
PLCID_06:       plcptr  PLC_06                          ; 2P mode-specific art
PLCID_07:       plcptr  PLC_07                          ; Tails life icon/universal level graphics
PLCID_08:       plcptr  PLC_08                          ; Monitor art only
PLCID_09:       plcptr  PLC_09                          ; Repeat of 08 (revolving spheres in Sonic 3, unused)
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
PLCID_1A:       plcptr  PLC_1A_1B                       ; FBZ1
PLCID_1B:       plcptr  PLC_1A_1B                       ; FBZ1 (unused)
PLCID_1C:       plcptr  PLC_1C_1D                       ; FBZ2
PLCID_1D:       plcptr  PLC_1C_1D                       ; FBZ2 (unused)
PLCID_1E:       plcptr  PLC_1E_1F                       ; ICZ1
PLCID_1F:       plcptr  PLC_1E_1F                       ; ICZ1 (unused)
PLCID_20:       plcptr  PLC_20_21                       ; ICZ2
PLCID_21:       plcptr  PLC_20_21                       ; ICZ2 (unused)
PLCID_22:       plcptr  PLC_22_23                       ; LBZ1
PLCID_23:       plcptr  PLC_22_23                       ; LBZ1 (unused)
PLCID_24:       plcptr  PLC_24                          ; LBZ2
PLCID_25:       plcptr  PLC_25                          ; LBZ2 misc art
PLCID_26:       plcptr  PLC_26_27_28_29                 ; MHZ (used for act 1)
PLCID_27:       plcptr  PLC_26_27_28_29                 ; MHZ (act 1, unused)
PLCID_28:       plcptr  PLC_26_27_28_29                 ; MHZ (used for act 2)
PLCID_29:       plcptr  PLC_26_27_28_29                 ; MHZ (act 2, unused)
PLCID_2A:       plcptr  PLC_2A_2B                       ; SOZ1
PLCID_2B:       plcptr  PLC_2A_2B                       ; SOZ1 (unused)
PLCID_2C:       plcptr  PLC_2C_2D                       ; SOZ2
PLCID_2D:       plcptr  PLC_2C_2D                       ; SOZ2 (unused)
PLCID_2E:       plcptr  PLC_2E_2F                       ; LRZ1
PLCID_2F:       plcptr  PLC_2E_2F                       ; LRZ1 (unused)
PLCID_30:       plcptr  PLC_30_31                       ; LRZ2
PLCID_31:       plcptr  PLC_30_31                       ; LRZ2 (unused)
PLCID_32:       plcptr  PLC_32_33_34_35                 ; SSZ (used for act 1)
PLCID_33:       plcptr  PLC_32_33_34_35                 ; SSZ (act 1, unused)
PLCID_34:       plcptr  PLC_32_33_34_35                 ; SSZ (used for act 2)
PLCID_35:       plcptr  PLC_32_33_34_35                 ; SSZ (act 2, unused)
PLCID_36:       plcptr  PLC_36_37                       ; DEZ1
PLCID_37:       plcptr  PLC_36_37                       ; DEZ1 (unused)
PLCID_38:       plcptr  PLC_38_39                       ; DEZ2
PLCID_39:       plcptr  PLC_38_39                       ; DEZ2 (unused)
PLCID_3A:       plcptr  PLC_3A_3B_3C_3D_3E_3F           ; DDZ (used for act 1)
PLCID_3B:       plcptr  PLC_3A_3B_3C_3D_3E_3F           ; DDZ (unused)
PLCID_3C:       plcptr  PLC_3A_3B_3C_3D_3E_3F           ; DDZ (used for act 2)
PLCID_3D:       plcptr  PLC_3A_3B_3C_3D_3E_3F           ; DDZ (unused)
PLCID_3E:       plcptr  PLC_3A_3B_3C_3D_3E_3F           ; DDZ (ending 1, unused)
PLCID_3F:       plcptr  PLC_3A_3B_3C_3D_3E_3F           ; DDZ (ending 1, unused)
PLCID_40:       plcptr  PLC_40_41                       ; Ending (blank)
PLCID_41:       plcptr  PLC_40_41                       ; Ending (blank, unused)
PLCID_42:       plcptr  PLC_42                          ; ALZ
PLCID_43:       plcptr  PLC_43                          ; BPZ
PLCID_44:       plcptr  PLC_44                          ; DPZ
PLCID_45:       plcptr  PLC_45                          ; CGZ
PLCID_46:       plcptr  PLC_46                          ; EMZ
PLCID_47:       plcptr  PLC_47                          ; Gumball
PLCID_48:       plcptr  PLC_48_49_4A_4B                 ; HPZ
PLCID_49:       plcptr  PLC_48_49_4A_4B                 ; HPZ (unused)
PLCID_4A:       plcptr  PLC_48_49_4A_4B                 ; HPZ (unused)
PLCID_4B:       plcptr  PLC_48_49_4A_4B                 ; HPZ (unused)
PLCID_4C:       plcptr  PLC_4C_4D                       ; DEZ3
PLCID_4D:       plcptr  PLC_4C_4D                       ; DEZ3 (unused)
PLCID_4E:       plcptr  PLC_4E_4F                       ; Spikes and springs (unused)
PLCID_4F:       plcptr  PLC_4E_4F                       ; Spikes and springs (unused)
PLCID_50:       plcptr  PLC_50                          ; Glowing Bonus
PLCID_51:       plcptr  PLC_51                          ; Slots bonus
PLCID_52:       plcptr  PLC_52                          ; Miles life icon/universal level graphics
PLCID_53:       plcptr  PLC_53_Through_5A               ; AIZ1 boss (unused)
PLCID_54:       plcptr  PLC_53_Through_5A               ; AIZ1 boss (unused)
PLCID_55:       plcptr  PLC_53_Through_5A               ; AIZ1 boss (unused)
PLCID_56:       plcptr  PLC_53_Through_5A               ; AIZ1 boss (unused)
PLCID_57:       plcptr  PLC_53_Through_5A               ; AIZ1 boss (unused)
PLCID_58:       plcptr  PLC_53_Through_5A               ; AIZ1 boss (unused)
PLCID_59:       plcptr  PLC_53_Through_5A               ; AIZ1 boss (unused)
PLCID_5A:       plcptr  PLC_53_Through_5A               ; AIZ1 boss
PLCID_5B:       plcptr  PLC_5B                          ; HCZ1 boss
PLCID_5C:       plcptr  PLC_5C_5D                       ; CNZ1 boss (unused)
PLCID_5D:       plcptr  PLC_5C_5D                       ; CNZ1 boss
PLCID_5E:       plcptr  PLC_5E                          ; FBZ1 boss (unused)
PLCID_5F:       plcptr  PLC_5F                          ; ICZ1 boss
PLCID_60:       plcptr  PLC_60                          ; LBZ1 Eggman
PLCID_61:       plcptr  PLC_61                          ; Boss explosion (unused)
PLCID_62:       plcptr  PLC_62_Through_6A               ; FBZ2 subboss (unused)
PLCID_63:       plcptr  PLC_62_Through_6A               ; FBZ2 subboss (unused)
PLCID_64:       plcptr  PLC_62_Through_6A               ; FBZ2 subboss (unused)
PLCID_65:       plcptr  PLC_62_Through_6A               ; FBZ2 subboss (unused)
PLCID_66:       plcptr  PLC_62_Through_6A               ; FBZ2 subboss (unused)
PLCID_67:       plcptr  PLC_62_Through_6A               ; FBZ2 subboss (unused)
PLCID_68:       plcptr  PLC_62_Through_6A               ; FBZ2 subboss (unused)
PLCID_69:       plcptr  PLC_62_Through_6A               ; FBZ2 subboss (unused)
PLCID_6A:       plcptr  PLC_62_Through_6A               ; FBZ2 subboss (unused)
PLCID_6B:       plcptr  PLC_6B                          ; AIZ2 boss
PLCID_6C:       plcptr  PLC_6C                          ; HCZ2 boss
PLCID_6D:       plcptr  PLC_6D                          ; MGZ2 boss
PLCID_6E:       plcptr  PLC_6E                          ; CNZ2 boss
PLCID_6F:       plcptr  PLC_6F                          ; FBZ2 end boss
PLCID_70:       plcptr  PLC_70                          ; ICZ2 boss
PLCID_71:       plcptr  PLC_71                          ; LBZ2 final boss 1
PLCID_72:       plcptr  PLC_72_73_74_75_76              ; DEZ2 boss (unused)
PLCID_73:       plcptr  PLC_72_73_74_75_76              ; DEZ2 boss (unused)
PLCID_74:       plcptr  PLC_72_73_74_75_76              ; DEZ2 boss (unused)
PLCID_75:       plcptr  PLC_72_73_74_75_76              ; DEZ2 boss (unused)
PLCID_76:       plcptr  PLC_72_73_74_75_76              ; DEZ2 boss
PLCID_77:       plcptr  PLC_77                          ; LBZ2 Eggman
PLCID_78:       plcptr  PLC_78_79_7A_7B                 ; Boss ship and explosion (unused)
PLCID_79:       plcptr  PLC_78_79_7A_7B                 ; Boss ship and explosion (unused)
PLCID_7A:       plcptr  PLC_78_79_7A_7B                 ; Boss ship and explosion (unused)
PLCID_7B:       plcptr  PLC_78_79_7A_7B                 ; Boss ship and explosion

PLC_00:         plrlistheader
                plreq   ArtTile_PlayerLifeIcon, ArtNem_SonicLifeIcon  ; Unused evidently
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
                plreq   ArtTile_PlayerLifeIcon, ArtNem_KnucklesLifeIcon
                plreq   ArtTile_Monitors, ArtNem_Monitors
                plreq   ArtTile_Ring, ArtNem_RingHUDText
                plreq   ArtTile_StarPost, ArtNem_EnemyPtsStarPost
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
                plreq   ArtTile_Monitors, ArtNem_Monitors
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

PLC_1A_1B:      plrlistheader
                plreq   ArtTile_FBZMisc, ArtNem_FBZMisc
                plreq   ArtTile_FBZOutdoors, ArtNem_FBZOutdoors
                plreq   ArtTile_FBZEggCapsule, ArtNem_FBZEggCapsule
PLC_1A_1B_End:

PLC_1C_1D:      plrlistheader
                plreq   ArtTile_FBZMisc, ArtNem_FBZMisc
                plreq   ArtTile_FBZMisc2, ArtNem_FBZMisc2
                plreq   ArtTile_FBZEggCapsule, ArtNem_FBZEggCapsule
PLC_1C_1D_End:

PLC_1E_1F:      plrlistheader
                plreq   ArtTile_SnowboardDust, ArtNem_SnowboardDust
                plreq   ArtTile_DiagonalSpring, ArtNem_DiagonalSpring
                plreq   ArtTile_GrayButton, ArtNem_GrayButton
                plreq   ArtTile_ICZMisc1, ArtNem_ICZMisc1
                plreq   ArtTile_ICZIntroSprites, ArtNem_ICZIntroSprites
                plreq   ArtTile_ICZTeleport, ArtNem_ICZTeleport
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

PLC_26_27_28_29:    plrlistheader
                plreq   ArtTile_MGZMHZDiagonalSpring, ArtNem_DiagonalSpring
                plreq   ArtTile_MHZMisc, ArtNem_MHZMisc
                plreq   ArtTile_MHZ1CutsceneButton, ArtNem_GrayButton
PLC_26_27_28_29_End:

PLC_2A_2B:      plrlistheader
                plreq   ArtTile_SOZMisc, ArtNem_SOZMisc
                plreq   ArtTile_SOZTile, ArtNem_SOZTile
PLC_2A_2B_End:

PLC_2C_2D:      plrlistheader
                plreq   ArtTile_SOZMisc, ArtNem_SOZMisc
                plreq   ArtTile_SOZ2Extra, ArtNem_SOZ2Extra
PLC_2C_2D_End:

PLC_2E_2F:      plrlistheader
                plreq   ArtTile_LRZMisc, ArtNem_LRZMisc
                plreq   ArtTile_LRZ2Misc+$2B, ArtNem_LRZSpikes
                plreq   ArtTile_LRZBigSpike, ArtNem_LRZBigSpike
PLC_2E_2F_End:

PLC_30_31:      plrlistheader
                plreq   ArtTile_LRZ2Misc, ArtNem_LRZ2Misc
                plreq   ArtTile_LRZ2Drum, ArtNem_LRZ2Drum
PLC_30_31_End:

PLC_32_33_34_35:    plrlistheader
                plreq   ArtTile_SSZMisc, ArtNem_SSZMisc
                plreq   ArtTile_SSZCutsceneButton, ArtNem_GrayButton
PLC_32_33_34_35_End:

PLC_36_37:      plrlistheader
                plreq   ArtTile_DEZMisc, ArtNem_DEZMisc
                plreq   ArtTile_DEZMisc2, ArtNem_DEZMiniboss
PLC_36_37_End:

PLC_38_39:      plrlistheader
                plreq   ArtTile_DEZMisc, ArtNem_DEZMisc
                plreq   ArtTile_DEZ2Extra, ArtNem_DEZ2Extra
PLC_38_39_End:

PLC_3A_3B_3C_3D_3E_3F:  plrlistheader
                plreq   ArtTile_DiagonalSpring, ArtNem_DiagonalSpring
PLC_3A_3B_3C_3D_3E_3F_End:

PLC_40_41:      plrlistheader
PLC_40_41_End:

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
PLC_47_End:

PLC_48_49_4A_4B:    plrlistheader
                plreq   ArtTile_HPZEmeraldMisc, ArtNem_HPZEmeraldMisc
                plreq   ArtTile_HPZGrayEmerald, ArtNem_HPZGrayEmerald
PLC_48_49_4A_4B_End:

PLC_4C_4D:      plrlistheader
                plreq   ArtTile_DEZRobotnikRun, ArtNem_FBZRobotnikRun
PLC_4C_4D_End:

PLC_4E_4F:      plrlistheader
                plreq   ArtTile_SpikesSprings, ArtNem_SpikesSprings
PLC_4E_4F_End:

PLC_50:         plrlistheader
                plreq   ArtTile_PachinkoMain, ArtNem_PachinkoMain
                plreq   ArtTile_PachinkoGumballs, ArtNem_BonusStage
PLC_50_End:

PLC_51:         plrlistheader
                plreq   ArtTile_SlotsBlocks, ArtNem_SlotsBlocks
PLC_51_End:

PLC_52:         plrlistheader
                plreq   ArtTile_PlayerLifeIcon, ArtNem_MilesLifeIcon
                plreq   ArtTile_Monitors, ArtNem_Monitors
                plreq   ArtTile_Ring, ArtNem_RingHUDText
                plreq   ArtTile_StarPost, ArtNem_EnemyPtsStarPost
PLC_52_End:

PLC_53_Through_5A:  plrlistheader
                plreq   ArtTile_AIZMiniboss, ArtNem_AIZMiniboss
                plreq   ArtTile_AIZMinibossSmall, ArtNem_AIZMinibossSmall
                plreq   ArtTile_AIZBossFire, ArtNem_AIZBossFire
                plreq   ArtTile_BossExplosion2, ArtNem_BossExplosion
PLC_53_Through_5A_End:

PLC_5B:         plrlistheader
                plreq   ArtTile_HCZMiniboss, ArtNem_HCZMiniboss
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_5B_End:

PLC_5C_5D:      plrlistheader
                plreq   ArtTile_CNZMiniboss, ArtNem_CNZMiniboss
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_5C_5D_End:

PLC_5E:         plrlistheader
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_5E_End:

PLC_5F:         plrlistheader
                plreq   ArtTile_ICZMiniboss, ArtNem_ICZMiniboss
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_5F_End:

PLC_60:         plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_LBZKnuxBomb, ArtNem_LBZKnuxBomb
PLC_60_End:

PLC_61:         plrlistheader
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_61_End:

PLC_62_Through_6A:  plrlistheader
                plreq   ArtTile_FBZ2Subboss, ArtNem_FBZ2Subboss
                plreq   ArtTile_FBZRobotnikStand, ArtNem_FBZRobotnikStand
                plreq   ArtTile_FBZRobotnikRun, ArtNem_FBZRobotnikRun
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_62_Through_6A_End:

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
                plreq   ArtTile_FBZEndBoss, ArtNem_FBZEndBoss
                plreq   ArtTile_FBZRobotnikHead, ArtNem_FBZRobotnikHead
                plreq   ArtTile_FBZEndBossFlame, ArtNem_FBZEndBossFlame
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

PLC_72_73_74_75_76: plrlistheader
                plreq   ArtTile_FBZRobotnikStand, ArtNem_FBZRobotnikStand
                plreq   ArtTile_FBZRobotnikRun, ArtNem_FBZRobotnikRun
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_72_73_74_75_76_End:

PLC_77:         plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_FBZRobotnikRun, ArtNem_FBZRobotnikRun
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_77_End:

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
                dc.w    loc_92A20-DebugMode_Index
                dc.w    loc_92AB0-DebugMode_Index
; ---------------------------------------------------------------------------

loc_92A20:
                addq.b  #2,(Debug_placement_routine).w
                move.l  mappings(a0),(Debug_saved_mappings).w
                cmpi.b  #6,routine(a0)
                bhs.s   loc_92A38
                move.w  art_tile(a0),(Debug_saved_art_tile).w

loc_92A38:
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,(Player_1+y_pos).w
                and.w   d0,(Camera_Y_pos).w
                clr.b   (Scroll_lock).w
                clr.w   (WindTunnel_flag).w
                bclr    #Status_Underwater,status(a0)
                beq.s   loc_92A6E
                movea.l a0,a1
                jsr     (Player_ResetAirTimer).l
                move.w  #$600,(Max_speed).w
                move.w  #$C,(Acceleration).w
                move.w  #$80,(Deceleration).w

loc_92A6E:
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
                bhi.s   loc_92AA0
                move.b  #0,(Debug_object).w

loc_92AA0:
                bsr.w   sub_92C88
                move.b  #$C,(Debug_camera_delay).w
                move.b  #1,(Debug_camera_speed).w

loc_92AB0:
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #6,d0
                andi.w  #$7E,d0
                lea     (DebugOffs).l,a2
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d6
                bsr.w   sub_92AD4
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_92AD4:
                moveq   #0,d4
                move.w  #1,d1
                move.b  (Ctrl_1_pressed).w,d4
                andi.w  #button_up_mask|button_down_mask|button_left_mask|button_right_mask,d4
                bne.s   loc_92B16
                move.b  (Ctrl_1_held).w,d0
                andi.w  #button_up_mask|button_down_mask|button_left_mask|button_right_mask,d0
                bne.s   loc_92AFE
                move.b  #$C,(Debug_camera_delay).w
                move.b  #$F,(Debug_camera_speed).w
                bra.w   loc_92B7A
; ---------------------------------------------------------------------------

loc_92AFE:
                subq.b  #1,(Debug_camera_delay).w
                bne.s   loc_92B1A
                move.b  #1,(Debug_camera_delay).w
                addq.b  #1,(Debug_camera_speed).w
                bne.s   loc_92B16
                move.b  #255,(Debug_camera_speed).w

loc_92B16:
                move.b  (Ctrl_1_held).w,d4

loc_92B1A:
                moveq   #0,d1
                move.b  (Debug_camera_speed).w,d1
                addq.w  #1,d1
                swap    d1
                asr.l   #4,d1
                move.l  y_pos(a0),d2
                move.l  x_pos(a0),d3
                btst    #button_up,d4
                beq.s   loc_92B44
                sub.l   d1,d2
                moveq   #0,d0
                move.w  (Camera_min_Y_pos).w,d0
                swap    d0
                cmp.l   d0,d2
                bge.s   loc_92B44
                move.l  d0,d2

loc_92B44:
                btst    #button_down,d4
                beq.s   loc_92B5E
                add.l   d1,d2
                moveq   #0,d0
                move.w  (Camera_target_max_Y_pos).w,d0
                addi.w  #$DF,d0
                swap    d0
                cmp.l   d0,d2
                blt.s   loc_92B5E
                move.l  d0,d2

loc_92B5E:
                btst    #button_left,d4
                beq.s   loc_92B6A
                sub.l   d1,d3
                bcc.s   loc_92B6A
                moveq   #0,d3

loc_92B6A:
                btst    #button_right,d4
                beq.s   loc_92B72
                add.l   d1,d3

loc_92B72:
                move.l  d2,y_pos(a0)
                move.l  d3,x_pos(a0)

loc_92B7A:
                btst    #button_A,(Ctrl_1_held).w
                beq.s   loc_92BB2
                btst    #button_C,(Ctrl_1_pressed).w
                beq.s   loc_92B96
                subq.b  #1,(Debug_object).w
                bcc.s   loc_92BAE
                add.b   d6,(Debug_object).w
                bra.s   loc_92BAE
; ---------------------------------------------------------------------------

loc_92B96:
                btst    #button_A,(Ctrl_1_pressed).w
                beq.s   loc_92BB2
                addq.b  #1,(Debug_object).w
                cmp.b   (Debug_object).w,d6
                bhi.s   loc_92BAE
                move.b  #0,(Debug_object).w

loc_92BAE:
                bra.w   sub_92C88
; ---------------------------------------------------------------------------

loc_92BB2:
                btst    #button_C,(Ctrl_1_pressed).w
                beq.s   loc_92C0C
                jsr     (AllocateObject).l
                bne.s   loc_92C0C
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
                cmpi.l  #Obj_Monitor,(a1)
                bne.s   locret_92C0A
                move.b  #9,subtype(a1)

locret_92C0A:
                rts
; ---------------------------------------------------------------------------

loc_92C0C:
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   locret_92C52
                moveq   #0,d0
                move.w  d0,(Debug_placement_mode).w
                move    #$2700,sr
                jsr     (HUD_DrawInitial).l
                move.b  #1,(Update_HUD_score).w
                move.b  #$80,(Update_HUD_ring_count).w
                move    #$2300,sr
                lea     (Player_1).w,a1
                move.l  (Debug_saved_mappings).w,mappings(a1)
                move.w  (Debug_saved_art_tile).w,art_tile(a1)
                bsr.s   sub_92C54
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)

locret_92C52:
                rts
; End of function sub_92AD4

; =============== S U B R O U T I N E =======================================

sub_92C54:
; Bug: this tries to clear the player's variables using d0, but d0 becomes
; dirty after the HUD_DrawInitial call, which wasn't there in S3
; Miraculously, drawing the lives HUD sets d0 back to zero, but since that
; part is skipped in Competition mode, exiting debug is broken there
                move.b  d0,anim(a1)
                move.w  d0,x_pos+2(a1)
                move.w  d0,y_pos+2(a1)
                move.b  d0,object_control(a1)
                move.b  d0,spin_dash_flag(a1)
                move.w  d0,x_vel(a1)
                move.w  d0,y_vel(a1)
                move.w  d0,ground_vel(a1)
                andi.b  #1<<Status_Facing,status(a1)
                ori.b   #1<<Status_InAir,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function sub_92C54

; =============== S U B R O U T I N E =======================================

sub_92C88:
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
; End of function sub_92C88

; ---------------------------------------------------------------------------
DebugOffs:      include "src/system/debug/shared/debug_list_pointers.s"

Debug_AIZ1:             dbglistinclude "src/system/debug/shared/zones/aiz/act_1.s"
Debug_AIZ2:             dbglistinclude "src/system/debug/shared/zones/aiz/act_2.s"
Debug_HCZ:              dbglistinclude "src/system/debug/shared/zones/hcz/main.s"
Debug_MGZ:              dbglistinclude "src/system/debug/shared/zones/mgz/main.s"
Debug_CNZ:              dbglistinclude "src/system/debug/shared/zones/cnz/main.s"
Debug_FBZ1:             dbglistinclude "src/system/debug/shared/zones/fbz/act_1.s"
Debug_FBZ2:             dbglistinclude "src/system/debug/shared/zones/fbz/act_2.s"
Debug_ICZ1:             dbglistinclude "src/system/debug/shared/zones/icz/act_1.s"
Debug_ICZ2:             dbglistinclude "src/system/debug/shared/zones/icz/act_2.s"
Debug_LBZ1:             dbglistinclude "src/system/debug/shared/zones/lbz/act_1.s"
Debug_LBZ2:             dbglistinclude "src/system/debug/shared/zones/lbz/act_2.s"
Debug_MHZ:              dbglistinclude "src/system/debug/shared/zones/mhz/main.s"
Debug_SOZ1:             dbglistinclude "src/system/debug/shared/zones/soz/act_1.s"
Debug_SOZ2:             dbglistinclude "src/system/debug/shared/zones/soz/act_2.s"
Debug_LRZ1:             dbglistinclude "src/system/debug/shared/zones/lrz/act_1.s"
Debug_LRZ2:             dbglistinclude "src/system/debug/shared/zones/lrz/act_2.s"
Debug_SSZ:              dbglistinclude "src/system/debug/shared/zones/ssz/main.s"
Debug_DEZ1:             dbglistinclude "src/system/debug/shared/zones/dez/act_1.s"
Debug_DEZ2:             dbglistinclude "src/system/debug/shared/zones/dez/act_2.s"
Debug_DDZ1:             dbglistinclude "src/system/debug/shared/zones/ddz/main.s"
Debug_DDZ2:             dbglistinclude "src/system/debug/shared/zones/dez/boss.s"
Debug_Ending:           dbglistinclude "src/system/debug/shared/zones/ssz/ending.s"
Debug_ALZ:              dbglistinclude "src/system/debug/shared/zones/alz/main.s"
Debug_BPZ:              dbglistinclude "src/system/debug/shared/zones/bpz/main.s"
Debug_DPZ:              dbglistinclude "src/system/debug/shared/zones/dpz/main.s"
Debug_CGZ:              dbglistinclude "src/system/debug/shared/zones/cgz/main.s"
Debug_EMZ:              dbglistinclude "src/system/debug/shared/zones/emz/main.s"
Debug_Pachinko_Special: dbglistinclude "src/system/debug/shared/zones/pachinko/main.s"
Debug_HPZ:              dbglistinclude "src/system/debug/shared/zones/hpz/main.s"
Debug_Gumball_Special:  dbglistinclude "src/system/debug/shared/zones/gumball/main.s"

Sprite_Listing3:    include "src/objects/shared/world/object_pointers_sk_set_1.s"
Sprite_ListingK:    include "src/objects/shared/world/object_pointers_sk_set_2.s"

                align   $1000

AngleArray:
                binclude "data/Levels/Misc/angles.bin"
                even
HeightMaps:
                binclude "data/Levels/Misc/Height Maps.bin"
                even
HeightMapsRot:
                binclude "data/Levels/Misc/Height Maps Rotated.bin"
                even

Noninterleaved_Solid_Flag   EQU     0

SolidIndexes:
                dc.l    Solid_AIZ1+1+Noninterleaved_Solid_Flag
                dc.l    Solid_AIZ2+1+Noninterleaved_Solid_Flag
                dc.l    Solid_HCZ1+1+Noninterleaved_Solid_Flag
                dc.l    Solid_HCZ2+1+Noninterleaved_Solid_Flag
                dc.l    Solid_MGZ1+1+Noninterleaved_Solid_Flag
                dc.l    Solid_MGZ2+1+Noninterleaved_Solid_Flag
                dc.l    Solid_CNZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_CNZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_FBZ
                dc.l    Solid_FBZ
                dc.l    Solid_ICZ1+1+Noninterleaved_Solid_Flag
                dc.l    Solid_ICZ2+1+Noninterleaved_Solid_Flag
                dc.l    Solid_LBZ1+1+Noninterleaved_Solid_Flag
                dc.l    Solid_LBZ2+1+Noninterleaved_Solid_Flag
                dc.l    Solid_MHZ
                dc.l    Solid_MHZ
                dc.l    Solid_SOZ
                dc.l    Solid_SOZ
                dc.l    Solid_LRZ1
                dc.l    Solid_LRZ2
                dc.l    Solid_SSZ1
                dc.l    Solid_SSZ2
                dc.l    Solid_DEZ
                dc.l    Solid_DEZ
                dc.l    Solid_DDZ
                dc.l    Solid_DDZ
                dc.l    Solid_Pachinko_Special
                dc.l    Solid_Pachinko_Special
                dc.l    Solid_ALZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_ALZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_BPZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_BPZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_DPZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_DPZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_CGZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_CGZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_EMZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_EMZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_Gumball_Special+1+Noninterleaved_Solid_Flag
                dc.l    Solid_Gumball_Special+1+Noninterleaved_Solid_Flag
                dc.l    Solid_Pachinko_Special
                dc.l    Solid_Pachinko_Special
                dc.l    Solid_Slots_Special
                dc.l    Solid_Slots_Special
                dc.l    Solid_LRZBoss
                dc.l    Solid_HPZ
                dc.l    Solid_HPZ
                dc.l    Solid_HPZ
Solid_FBZ:
                binclude "data/Levels/FBZ/Collision/1.bin"
                even
Solid_MHZ:
                binclude "data/Levels/MHZ/Collision/1.bin"
                even
Solid_Unknown:
                binclude "data/Levels/Misc/Unknown Collision.bin"
                even
Solid_SOZ:
                binclude "data/Levels/SOZ/Collision/1.bin"
                even
Solid_LRZ1:
                binclude "data/Levels/LRZ/Collision/1.bin"
                even
Solid_LRZ2:
                binclude "data/Levels/LRZ/Collision/2.bin"
                even
Solid_SSZ1:
                binclude "data/Levels/SSZ/Collision/1.bin"
                even
Solid_SSZ2:
                binclude "data/Levels/SSZ/Collision/2.bin"
                even
Solid_DEZ:
                binclude "data/Levels/DEZ/Collision/1.bin"
                even
Solid_DDZ:
                binclude "data/Levels/DDZ/Collision/1.bin"
                even
Solid_Pachinko_Special:
                binclude "data/Levels/Pachinko/Collision/1.bin"
                even
Solid_Slots_Special:
                binclude "data/Levels/Slots/Collision/1.bin"
                even

Solid_LRZBoss:
                binclude "data/Levels/LRZ/Collision/3.bin"
                even
Solid_HPZ:
                binclude "data/Levels/HPZ/Collision/1.bin"
                even
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
                dc.l    Layout_MHZ1
                dc.l    Layout_MHZ2
                dc.l    Layout_SOZ1
                dc.l    Layout_SOZ2
                dc.l    Layout_LRZ1
                dc.l    Layout_LRZ2
                dc.l    Layout_SSZ1
                dc.l    Layout_SSZ2
                dc.l    Layout_DEZ1
                dc.l    Layout_DEZ2
                dc.l    Layout_DDZ
                dc.l    Layout_DDZ
                dc.l    Layout_SSZ2
                dc.l    Layout_SSZ2
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
                dc.l    Layout_Slots_Special
                dc.l    Layout_Slots_Special
                dc.l    Layout_LRZBoss
                dc.l    Layout_HPZ
                dc.l    Layout_DEZBoss
                dc.l    Layout_HPZ
Layout_FBZ1:
                binclude "data/Levels/FBZ/Layout/1.bin"
                even
Layout_FBZ2:
                binclude "data/Levels/FBZ/Layout/2.bin"
                even
Layout_MHZ1:
                binclude "data/Levels/MHZ/Layout/1.bin"
                even
Layout_MHZ2:
                binclude "data/Levels/MHZ/Layout/2.bin"
                even
Layout_SOZ1:
                binclude "data/Levels/SOZ/Layout/1.bin"
                even
Layout_SOZ2:
                binclude "data/Levels/SOZ/Layout/2.bin"
                even
Layout_LRZ1:
                binclude "data/Levels/LRZ/Layout/1.bin"
                even
Layout_LRZ2:
                binclude "data/Levels/LRZ/Layout/2.bin"
                even
Layout_SSZ1:
                binclude "data/Levels/SSZ/Layout/1.bin"
                even
Layout_SSZ2:
                binclude "data/Levels/SSZ/Layout/2.bin"
                even
Layout_DEZ1:
                binclude "data/Levels/DEZ/Layout/1.bin"
                even
Layout_DEZ2:
                binclude "data/Levels/DEZ/Layout/2.bin"
                even
Layout_DDZ:
                binclude "data/Levels/DDZ/Layout/1.bin"
                even
Layout_Pachinko_Special:
                binclude "data/Levels/Pachinko/Layout/1.bin"
                even
Layout_Slots_Special:
                binclude "data/Levels/Slots/Layout/1.bin"
                even

Layout_LRZBoss:
                binclude "data/Levels/LRZ/Layout/3.bin"
                even
Layout_HPZ:
                binclude "data/Levels/HPZ/Layout/1.bin"
                even
Layout_DEZBoss:
                binclude "data/Levels/DEZ/Layout/3.bin"
                even
MHZ_Custom_Layout:
                binclude "data/Levels/MHZ/Layout/3.bin"
                even
PalPoint:
                include "src/rendering/shared/palettes/palette_pointers.s"

Pal_S2Sega:
                binclude "data/General/S2Menu/Palettes/Sega Screen.bin"
                even
Pal_S2Title:
                binclude "data/General/S2Menu/Palettes/Title Screen SK.bin"
                even
Pal_S2LevSel:
                binclude "data/General/S2Menu/Palettes/Proto Level Select SK.bin"
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
Pal_FBZ1:
                binclude "data/Levels/FBZ/Palettes/FBZ1.bin"
                even
Pal_FBZ2:
                binclude "data/Levels/FBZ/Palettes/FBZ2.bin"
                even
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
Pal_MHZ1:
                binclude "data/Levels/MHZ/Palettes/1.bin"
                even
Pal_MHZ2:
                binclude "data/Levels/MHZ/Palettes/2.bin"
                even
Pal_SOZ1:
                binclude "data/Levels/SOZ/Palettes/1.bin"
                even
Pal_SOZ2:
                binclude "data/Levels/SOZ/Palettes/2.bin"
                even
Pal_SOZ1_Clone:
                binclude "data/Levels/SOZ/Palettes/Act 1 Clone.bin"
                even
Pal_SOZ2_Extra:
                binclude "data/Levels/SOZ/Palettes/Act 2 Extra.bin"
                even
Pal_LRZ1:
                binclude "data/Levels/LRZ/Palettes/1.bin"
                even
Pal_LRZ2:
                binclude "data/Levels/LRZ/Palettes/2.bin"
                even
Pal_SSZ1:
                binclude "data/Levels/SSZ/Palettes/1.bin"
                even
Pal_SSZ2:
                binclude "data/Levels/SSZ/Palettes/2.bin"
                even
Pal_Ending1:
                binclude "data/General/Ending/Palettes/Ending 1.bin"
                even
Pal_Ending2:
                binclude "data/General/Ending/Palettes/Ending 2.bin"
                even
Pal_DEZ1:
                binclude "data/Levels/DEZ/Palettes/1.bin"
                even
Pal_DEZ2:
                binclude "data/Levels/DEZ/Palettes/2.bin"
                even
Pal_DDZ:
                binclude "data/Levels/DDZ/Palettes/Main.bin"
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
                binclude "data/Levels/Pachinko/Palettes/Main.bin"
                even
Pal_Slot_Special:
                binclude "data/Levels/Slots/Palettes/Main.bin"
                even

Pal_LRZBoss:
                binclude "data/Levels/LRZ/Palettes/Boss Act.bin"
                even
Pal_HPZIntro:
                binclude "data/Levels/HPZ/Palettes/Intro.bin"
                even
Pal_DEZBoss:
                binclude "data/Levels/DEZ/Palettes/Boss.bin"
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

ArtUnc_SStageKnuckles:
                binclude "data/General/Sprites/Knuckles/Art/SStage Knuckles.unc"
                even
Map_SStageKnuckles:
                include "src/objects/shared/knuckles/map_sstage_knuckles.s"

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
ArtKosM_SStageSuperEmerald:
                binclude "data/General/Special Stage/KosinskiM Art/Special Stage Super Emerald.kosm"
                even
MapEni_SStageBG:
                binclude "data/General/Special Stage/Enigma Map/BG.eni"
                even
ArtNem_SStageBG:
                binclude "data/General/Special Stage/Nemesis Art/BG.nem"
                even
MapEni_SStageLayout:
                binclude "data/General/Special Stage/Enigma Map/Layout.eni"
                even
ArtNem_SStageLayout:
                binclude "data/General/Special Stage/Nemesis Art/Layout.nem"
                even
SStageKos_PerspectiveMaps:
                binclude "data/General/Special Stage/Layout/Perspective Maps.bin"
                even

                cnop0   -$40,$100

ArtUnc_AniFBZ__0:
                binclude "data/Levels/FBZ/Animated Tiles/0.unc"
                even
ArtUnc_AniFBZ__1:
                binclude "data/Levels/FBZ/Animated Tiles/1.unc"
                even
ArtUnc_AniFBZ__2:
                binclude "data/Levels/FBZ/Animated Tiles/2.unc"
                even
ArtUnc_AniFBZ__3:
                binclude "data/Levels/FBZ/Animated Tiles/3.unc"
                even
ArtUnc_AniFBZ__4:
                binclude "data/Levels/FBZ/Animated Tiles/4.unc"
                even
ArtUnc_AniMHZ__BG:
                binclude "data/Levels/MHZ/Animated Tiles/BG 1.unc"
                even
ArtUnc_AniMHZ__BG2:
                binclude "data/Levels/MHZ/Animated Tiles/BG 2.unc"
                even
ArtUnc_AniMHZ__0:
                binclude "data/Levels/MHZ/Animated Tiles/0.unc"
                even
ArtUnc_AniMHZ__1:
                binclude "data/Levels/MHZ/Animated Tiles/1.unc"
                even
ArtUnc_AniMHZ__2:
                binclude "data/Levels/MHZ/Animated Tiles/2.unc"
                even
ArtUnc_AniMHZ__3:
                binclude "data/Levels/MHZ/Animated Tiles/3.unc"
                even
ArtUnc_AniSOZ1_BG:
                binclude "data/Levels/SOZ/Animated Tiles/Act1 BG 1.unc"
                even
ArtUnc_AniSOZ1_BG2:
                binclude "data/Levels/SOZ/Animated Tiles/Act1 BG 2.unc"
                even
ArtUnc_AniSOZ2_BG:
                binclude "data/Levels/SOZ/Animated Tiles/Act2 BG.unc"
                even
ArtUnc_AniLRZ__BG:
                binclude "data/Levels/LRZ/Animated Tiles/BG 1.unc"
                even
ArtUnc_AniLRZ__BG2:
                binclude "data/Levels/LRZ/Animated Tiles/BG 2.unc"
                even
ArtUnc_AniLRZ1_0:
                binclude "data/Levels/LRZ/Animated Tiles/Act1 0.unc"
                even
ArtUnc_AniLRZ1_1:
                binclude "data/Levels/LRZ/Animated Tiles/Act1 1.unc"
                even
ArtUnc_AniLRZ2_0:
                binclude "data/Levels/LRZ/Animated Tiles/Act2 0.unc"
                even
ArtUnc_AniLRZ2_1:
                binclude "data/Levels/LRZ/Animated Tiles/Act2 1.unc"
                even
ArtUnc_AniHPZ__0:
                binclude "data/Levels/HPZ/Animated Tiles/0.unc"
                even
ArtUnc_AniHPZ__1:
                binclude "data/Levels/HPZ/Animated Tiles/1.unc"
                even
ArtUnc_AniHPZ__2:
                binclude "data/Levels/HPZ/Animated Tiles/2.unc"
                even
ArtUnc_AniHPZ__3:
                binclude "data/Levels/HPZ/Animated Tiles/3.unc"
                even
ArtUnc_AniSSZ__0:
                binclude "data/Levels/SSZ/Animated Tiles/0.unc"
                even
ArtUnc_AniSSZ__1:
                binclude "data/Levels/SSZ/Animated Tiles/1.unc"
                even
ArtUnc_AniSSZ__2:
                binclude "data/Levels/SSZ/Animated Tiles/2.unc"
                even
ArtUnc_AniSSZ__3:
                binclude "data/Levels/SSZ/Animated Tiles/3.unc"
                even
ArtUnc_AniSSZ__4:
                binclude "data/Levels/SSZ/Animated Tiles/4.unc"
                even
ArtUnc_AniSSZ__5:
                binclude "data/Levels/SSZ/Animated Tiles/5.unc"
                even
ArtUnc_AniDEZ__0:
                binclude "data/Levels/DEZ/Animated Tiles/0.unc"
                even
ArtUnc_AniDEZ__1:
                binclude "data/Levels/DEZ/Animated Tiles/1.unc"
                even
ArtUnc_AniDEZ__2:
                binclude "data/Levels/DEZ/Animated Tiles/2.unc"
                even
ArtUnc_AniDEZ__3:
                binclude "data/Levels/DEZ/Animated Tiles/3.unc"
                even
ArtUnc_AniDEZ__4:
                binclude "data/Levels/DEZ/Animated Tiles/4.unc"
                even
ArtUnc_AniDEZ__5:
                binclude "data/Levels/DEZ/Animated Tiles/5.unc"
                even
ArtUnc_AniDEZ__6:
                binclude "data/Levels/DEZ/Animated Tiles/6.unc"
                even
ArtUnc_AniDEZ__7:
                binclude "data/Levels/DEZ/Animated Tiles/7.unc"
                even
ArtUnc_AniPachinko:
                binclude "data/Levels/Pachinko/Animated Tiles/0.unc"
                even
ArtNem_S22POptions:
                binclude "data/General/S2Menu/Nemesis Art/2P Options.nem"
                even
MapEni_S22POptions:
                binclude "data/General/S2Menu/Enigma Map/2P Options.eni"
                even
LRZ1_Rock_Placement:
                dc.w    0, 0, 0
                binclude "data/Levels/LRZ/Misc/Act 1 Rock Placement.bin"
                even
LRZ2_Rock_Placement:
                dc.w    0, 0, 0
                binclude "data/Levels/LRZ/Misc/Act 2 Rock Placement.bin"
                even
Map_SKTitle_SonicFall:
                include "src/ui/shared/title/map_sk_sonic_falling.s"
                even
Map_SKTitle_DeathEgg:
                include "src/ui/shared/title/map_sk_death_egg.s"
                even
Map_SKTitle_Banner:
                include "src/ui/shared/title/map_sk_banner.s"
                even
Map_SKTitle_Mountain:
                include "src/ui/shared/title/map_sk_mountain.s"
                even
MapEni_SKTitle_Sega:
                binclude "data/General/Title/Enigma Map/SK SEGA.eni"
                even
MapEni_SKTitle_Frame1:
                binclude "data/General/Title/Enigma Map/SK SonicKnux Frame 1.eni"
                even
MapEni_SKTitle_Frame2:
                binclude "data/General/Title/Enigma Map/SK SonicKnux Frame 2.eni"
                even
MapEni_SKTitle_Frame3:
                binclude "data/General/Title/Enigma Map/SK SonicKnux Frame 3.eni"
                even
MapEni_SKTitle_Frame4:
                binclude "data/General/Title/Enigma Map/SK SonicKnux Frame 4.eni"
                even
MapEni_SKTitle_Background:
                binclude "data/General/Title/Enigma Map/SK Background.eni"
                even
ArtKos_BigSEGA:
                binclude "data/General/Title/Kosinski Art/SK Big SEGA.kos"
                even
ArtKos_SKTitleScreenBG:
                binclude "data/General/Title/Kosinski Art/SK Screen Background.kos"
                even
ArtKosM_SonicKnuxStand:
                binclude "data/General/Title/KosinskiM Art/SK Sonic Knuckles.kosm"
                even
ArtKosM_SonicLand:
                binclude "data/General/Title/KosinskiM Art/SK Sonic Land Frames.kosm"
                even
ArtKos_SKTitle_SonicFall:
                binclude "data/General/Title/Kosinski Art/SK Sonic Falling.kos"
                even
ArtKos_SKTitle_DeathEgg:
                binclude "data/General/Title/Kosinski Art/SK Death Egg.kos"
                even
ArtKos_SKTitle_Mountain:
                binclude "data/General/Title/Kosinski Art/SK Mountain Sprite.kos"
                even
ArtKosM_SKTitle_Banner:
                binclude "data/General/Title/KosinskiM Art/SK Banner.kosm"
                even
ArtKos_SKTitle_SonKnuxHand:
                binclude "data/General/Title/Kosinski Art/SK Sonic and Knuckles Hands.kos"
                even
ArtKosM_SKTitle_Menu:
                binclude "data/General/Title/KosinskiM Art/SK Menu.kosm"
                even
ArtNem_Title_ANDKnuckles:
                binclude "data/General/Title/Nemesis Art/SK ANDKnuckles.nem"
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
ArtKosM_TitleCardRedAct:
                binclude "data/General/Sprites/Title Card/Title Card Red ACT.kosm"
                even
ArtKosM_FBZTitleCard:
                binclude "data/Levels/FBZ/KosinskiM Art/Title Card.kosm"
                even
ArtKosM_BonusTitleCard:
                binclude "data/General/Sprites/Title Card/Bonus Title Card.kosm"
                even
ArtNem_BossExplosion:
                binclude "data/General/Sprites/Boss Explosion/Boss Explosion.nem"
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
ArtUnc_SSEntryRing:
                binclude "data/General/Sprites/SS Entry/Entry Ring.unc"
                even
ArtUnc_SSEntryFlash:
                binclude "data/General/Sprites/SS Entry/Entry Flash.unc"
                even
ArtKosM_BadnikExplosion:
                binclude "data/General/Sprites/SS Entry/Badnik Explosion.kosm"
                even
ArtNem_FBZMinibossUnused:
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
ArtUnc_EndSigns:
                binclude "data/General/Sprites/Signpost/End Signs.unc"
                even
ArtNem_SignpostStub:
                binclude "data/General/Sprites/Signpost/Stub.nem"
                even
ArtNem_EggCapsule:
                binclude "data/General/Sprites/Egg Capsule/Egg Capsule.nem"
                even
ArtNem_CreditsText:
                binclude "data/General/Ending/Nemesis Art/Large Text.nem"
                even
ArtNem_FBZEndBossFlame:
                binclude "data/Levels/FBZ/Nemesis Art/End Boss Flame.nem"
                even
ArtKosM_ANDKnuckles:
                binclude "data/General/Ending/KosinskiM Art/ANDKnuckles Subtitle.kosm"
                even

                cnop    -$600,$1000

ArtNem_KnuxEndPose:
                binclude "data/General/Ending/Nemesis Art/Knuckles Ending Pose.nem"
                even

; Local lists are preserved here; external Sonic 2 lists use their own fixed ABI names
; The Sonic 2 lock-on game profile is outside this repository's reconstruction scope
S2K_Sprite_Lists:
                dc.l    S2KSprite_EHZ1                  ; 0
                dc.l    S2KSprite_EHZ2                  ; 1
                dc.l    S2KSprite_NULL                  ; 2
                dc.l    S2KSprite_NULL                  ; 3
                dc.l    S2KSprite_NULL                  ; 4
                dc.l    S2KSprite_NULL                  ; 5
                dc.l    S2KSprite_NULL                  ; 6
                dc.l    S2KSprite_NULL                  ; 7
                dc.l    S2KSprite_MTZ1                  ; 8
                dc.l    S2KSprite_MTZ2                  ; 9
                dc.l    S2KSprite_MTZ3                  ; 10
                dc.l    S2KSprite_MTZ3                  ; 11
                dc.l    S2KSprite_WFZ1                  ; 12
                dc.l    S2KSprite_WFZ2                  ; 13
                dc.l    S2KSprite_HTZ1                  ; 14
                dc.l    S2KSprite_HTZ2                  ; 15
                dc.l    S2_External_Sprite_List_16      ; fixed Sonic 2 list 16
                dc.l    S2_External_Sprite_List_17      ; fixed Sonic 2 list 17
                dc.l    S2KSprite_NULL                  ; 18
                dc.l    S2KSprite_NULL                  ; 19
                dc.l    S2KSprite_OOZ1                  ; 20
                dc.l    S2KSprite_OOZ2                  ; 21
                dc.l    S2KSprite_MCZ1                  ; 22
                dc.l    S2KSprite_MCZ2                  ; 23
                dc.l    S2_External_Sprite_List_24      ; fixed Sonic 2 list 24
                dc.l    S2_External_Sprite_List_25      ; fixed Sonic 2 list 25
                dc.l    S2KSprite_CPZ1                  ; 26
                dc.l    S2KSprite_CPZ2                  ; 27
                dc.l    S2_External_Sprite_List_28      ; fixed Sonic 2 list 28
                dc.l    S2_External_Sprite_List_29      ; fixed Sonic 2 list 29
                dc.l    S2KSprite_ARZ1                  ; 30
                dc.l    S2KSprite_ARZ2                  ; 31
                dc.l    S2_External_Sprite_List_32      ; fixed Sonic 2 list 32
                dc.l    S2_External_Sprite_List_33      ; fixed Sonic 2 list 33
                dc.w    $FFFF, 0, 0
S2KSprite_EHZ1:
                binclude "data/Levels/Misc/S2K Object Pos/EHZ_1.bin"
                even
S2KSprite_EHZ2:
                binclude "data/Levels/Misc/S2K Object Pos/EHZ_2.bin"
                even
S2KSprite_MTZ1:
                binclude "data/Levels/Misc/S2K Object Pos/MTZ_1.bin"
                even
S2KSprite_MTZ2:
                binclude "data/Levels/Misc/S2K Object Pos/MTZ_2.bin"
                even
S2KSprite_MTZ3:
                binclude "data/Levels/Misc/S2K Object Pos/MTZ_3.bin"
                even
S2KSprite_WFZ1:
                binclude "data/Levels/Misc/S2K Object Pos/WFZ_1.bin"
                even
S2KSprite_WFZ2:
                binclude "data/Levels/Misc/S2K Object Pos/WFZ_2.bin"
                even
S2KSprite_HTZ1:
                binclude "data/Levels/Misc/S2K Object Pos/HTZ_1.bin"
                even
S2KSprite_HTZ2:
                binclude "data/Levels/Misc/S2K Object Pos/HTZ_2.bin"
                even
S2KSprite_OOZ1:
                binclude "data/Levels/Misc/S2K Object Pos/OOZ_1.bin"
                even
S2KSprite_OOZ2:
                binclude "data/Levels/Misc/S2K Object Pos/OOZ_2.bin"
                even
S2KSprite_MCZ1:
                binclude "data/Levels/Misc/S2K Object Pos/MCZ_1.bin"
                even
S2KSprite_MCZ2:
                binclude "data/Levels/Misc/S2K Object Pos/MCZ_2.bin"
                even
S2KSprite_CPZ1:
                binclude "data/Levels/Misc/S2K Object Pos/CPZ_1.bin"
                even
S2KSprite_CPZ2:
                binclude "data/Levels/Misc/S2K Object Pos/CPZ_2.bin"
                even
S2KSprite_ARZ1:
                binclude "data/Levels/Misc/S2K Object Pos/ARZ_1.bin"
                even
S2KSprite_ARZ2:
                binclude "data/Levels/Misc/S2K Object Pos/ARZ_2.bin"
                even
S2KSprite_NULL:
                dc.w    $FFFF, 0, 0

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
DAC_9B_Data:            include "Sound/DAC/metadata/9B.inc"
DAC_B2_B3_Data:         include "Sound/DAC/metadata/B2-B3 (Sonic & Knuckles).inc"

                finishBank

                align   $10

                include "Sound/Z80 Sound Driver.s"

; ===========================================================================
; Sound Bank
; ===========================================================================
SndBank:        startBank

SEGA_PCM:       include "Sound/PCM/metadata/Sega.inc"

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
