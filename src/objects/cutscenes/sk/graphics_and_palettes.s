; Owner: objects/cutscenes/sk
; Responsibility: Knuckles cutscene mappings, DPLC includes, palette records and scene art descriptors
; Source provenance and ranges: config/reconstruction/source_layout.json
Pal_CutsceneKnux:
                binclude "data/General/Sprites/Knuckles/Cutscene/Pal.bin"
                even
Pal_CNZFlash:
                binclude "data/Levels/CNZ/Palettes/Flash.bin"
                even
Pal_KnuxSSZEnd:
                binclude "data/General/Sprites/Knuckles/Palettes/SSZ End.bin"
                even
Pal_HPZ:
                binclude "data/Levels/HPZ/Palettes/Main.bin"
                even
Pal_SKIntroBomb:
                binclude "data/General/Sprites/Knuckles/Cutscene/Intro Bomb Pal.bin"
                even
Map_MHZKnuxPeer:
                include "src/objects/shared/zones/mhz/mappings/knuckles_peering.s"
Map_MHZKnuxDoor:
                include "src/objects/shared/zones/mhz/mappings/knuckles_switch_door.s"
Map_MHZKnuxPullSwitch:
                include "src/objects/shared/knuckles/cutscene/mappings/mhz2_press.s"
DPLC_MHZKnuxPress:
                include "src/objects/shared/knuckles/cutscene/dplc/mhz_press.s"
Map_MHZKnuxSwitch:
                include "src/objects/shared/knuckles/cutscene/act2/mappings/knuckles_switch.s"
Map_MHZKnuxLeaves:
                include "src/objects/shared/zones/mhz/act2/mappings/knuckles_leaves.s"
Map_LRZKnuxBoulder:
                include "src/objects/shared/zones/lrz/mappings/knuckles_boulder.s"
Map_SSZKnucklesTired:
                include "src/objects/shared/knuckles/cutscene/mappings/ssz_tired.s"
DPLC_SSZKnucklesTired:
                include "src/objects/shared/knuckles/cutscene/dplc/ssz_tired.s"
Map_SSZDeathEggSmall:
                include "src/objects/shared/zones/ssz/mappings/death_egg_small.s"
Map_SSZDeathEggCloud:
                include "src/objects/shared/zones/ssz/mappings/death_egg_cloud.s"
DPLC_SSZDeathEggCloud:
                include "src/objects/shared/zones/ssz/dplc/death_egg_cloud.s"
Map_HPZKnucklesGrab:
                include "src/objects/shared/knuckles/cutscene/mappings/hpz_grab.s"
DPLC_HPZKnucklesGrab:
                include "src/objects/shared/knuckles/cutscene/dplc/hpz_grab.s"
Map_KnuxFinalBossCrane:
                include "src/objects/shared/robotnik/mappings/ship_crane.s"
Map_HPZKnuxDizzyStars:
                include "src/objects/shared/zones/hpz/mappings/knuckles_dizzy_stars.s"
Map_KnuxIntroLay:
                include "src/objects/shared/knuckles/cutscene/mappings/intro_laying.s"
DPLC_KnuxIntroLay:
                include "src/objects/shared/knuckles/cutscene/dplc/intro_laying.s"
Map_KnuxIntroBomb:
                include "src/objects/shared/knuckles/cutscene/mappings/intro_bomb.s"
