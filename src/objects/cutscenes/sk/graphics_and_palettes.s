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
                include "src/objects/shared/zones/mhz/map_knuckles_peering.s"
Map_MHZKnuxDoor:
                include "src/objects/shared/zones/mhz/map_knuckles_switch_door.s"
Map_MHZKnuxPullSwitch:
                include "src/objects/shared/knuckles/cutscene/map_mhz2_press.s"
DPLC_MHZKnuxPress:
                include "src/objects/shared/knuckles/cutscene/dplc_mhz_press.s"
Map_MHZKnuxSwitch:
                include "src/objects/shared/knuckles/cutscene/map_act_2_knuckles_switch.s"
Map_MHZKnuxLeaves:
                include "src/objects/shared/zones/mhz/map_act_2_knuckles_leaves.s"
Map_LRZKnuxBoulder:
                include "src/objects/shared/zones/lrz/map_knuckles_boulder.s"
Map_SSZKnucklesTired:
                include "src/objects/shared/knuckles/cutscene/map_ssz_tired.s"
DPLC_SSZKnucklesTired:
                include "src/objects/shared/knuckles/cutscene/dplc_ssz_tired.s"
Map_SSZDeathEggSmall:
                include "src/objects/shared/zones/ssz/map_death_egg_small.s"
Map_SSZDeathEggCloud:
                include "src/objects/shared/zones/ssz/map_death_egg_cloud.s"
DPLC_SSZDeathEggCloud:
                include "src/objects/shared/zones/ssz/dplc_death_egg_cloud.s"
Map_HPZKnucklesGrab:
                include "src/objects/shared/knuckles/cutscene/map_hpz_grab.s"
DPLC_HPZKnucklesGrab:
                include "src/objects/shared/knuckles/cutscene/dplc_hpz_grab.s"
Map_KnuxFinalBossCrane:
                include "src/objects/shared/robotnik/map_robotnik_ship_crane.s"
Map_HPZKnuxDizzyStars:
                include "src/objects/shared/zones/hpz/map_knuckles_dizzy_stars.s"
Map_KnuxIntroLay:
                include "src/objects/shared/knuckles/cutscene/map_intro_laying.s"
DPLC_KnuxIntroLay:
                include "src/objects/shared/knuckles/cutscene/dplc_intro_laying.s"
Map_KnuxIntroBomb:
                include "src/objects/shared/knuckles/cutscene/map_intro_bomb.s"
