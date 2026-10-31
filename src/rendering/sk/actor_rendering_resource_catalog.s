; Owner: rendering/sk
; Responsibility: Actor mappings and DPLC bindings with boss motion angle lookup data
; Source provenance and ranges: config/reconstruction/source_layout.json
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
