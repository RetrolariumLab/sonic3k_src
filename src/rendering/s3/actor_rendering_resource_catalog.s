; Owner: rendering/s3
; Responsibility: Actor mappings and DPLC bindings, boss motion lookup data and complete boss palette scripts
; Source provenance and ranges: config/reconstruction/source_layout.json
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
