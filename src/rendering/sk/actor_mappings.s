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
                include "src/objects/shared/spikebonker/mappings/spikebonker.s"
Map_Chainspike:
                include "src/objects/shared/chainspike/mappings/chainspike.s"
Map_EggRobo:
                include "src/objects/shared/egg_robo/mappings/badnik.s"
Map_DEZMiniboss:
                include "src/objects/shared/zones/dez/mappings/miniboss.s"
Map_MechaSonic:
                include "src/objects/shared/mecha_sonic/mappings/mecha_sonic.s"
Map_MechaSonicExtra:
                include "src/objects/shared/mecha_sonic/mappings/extra.s"
DPLC_MechaSonic:
                include "src/objects/shared/mecha_sonic/dplc/mecha_sonic.s"
Map_SpriteMask:
                include "src/objects/shared/level_misc/mappings/sprite_mask.s"
Map_DEZEndBoss:
                include "src/objects/shared/zones/dez/mappings/end_boss.s"
Map_MHZEndBoss:
                include "src/objects/shared/zones/mhz/mappings/end_boss.s"
Map_MHZMiniboss:
                include "src/objects/shared/zones/mhz/mappings/miniboss.s"
Map_MHZMinibossTree:
                include "src/objects/shared/zones/mhz/miniboss/mappings/tree.s"
Map_MHZMinibossLog:
                include "src/objects/shared/zones/mhz/miniboss/mappings/log.s"
Map_EggRoboStand:
                include "src/objects/shared/egg_robo/mappings/stand.s"
Map_EggRoboRun:
                include "src/objects/shared/egg_robo/mappings/run.s"
Map_Skorp:
                include "src/objects/shared/skorp/mappings/skorp.s"
Map_Sandworm:
                include "src/objects/shared/sandworm/mappings/sandworm.s"
Map_LRZRockCrusher:
                include "src/objects/shared/zones/lrz/mappings/rock_crusher.s"
Map_SSZMTZOrbs:
                include "src/objects/shared/zones/ssz/mappings/mtz_orbs.s"
Map_SSZGHZMisc:
                include "src/objects/shared/zones/ssz/mappings/ghz_misc.s"
Map_LRZMiniboss:
                include "src/objects/shared/zones/lrz/mappings/miniboss.s"
Map_FBZEggCapsule:
                include "src/objects/shared/zones/fbz/mappings/egg_capsule.s"
Map_SOZGhosts:
                include "src/objects/shared/soz_ghosts/mappings/soz_ghosts.s"
Map_LRZEndBoss:
                include "src/objects/shared/zones/lrz/mappings/end_boss.s"
Map_LRZ3Platform:
                include "src/objects/shared/zones/lrz/act3/mappings/platform.s"
Map_LRZ3Autoscroll:
                include "src/objects/shared/zones/lrz/act3/mappings/autoscroll.s"
Map_LRZ3DeathEggFlash:
                include "src/objects/shared/zones/lrz/act3/mappings/death_egg_flash.s"
Map_LRZ3Debris:
                include "src/objects/shared/zones/lrz/act3/mappings/platform_debris.s"
Map_DEZFinalBossMisc:
                include "src/objects/shared/zones/dez/final_boss/mappings/misc.s"
Map_BossMasterEmerald:
                include "src/objects/shared/zones/dez/final_boss/mappings/master_emerald.s"
Map_DEZFinalBossDebris:
                include "src/objects/shared/zones/dez/final_boss/mappings/debris.s"
                even
