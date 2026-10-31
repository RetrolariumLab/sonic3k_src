; Owner: game/modes/ending/sk
; Responsibility: Ending mappings, scene palettes and the Super Tails palette rotation script
; Source provenance and ranges: config/reconstruction/source_layout.json
Map_KnuxEnding:
                include "src/objects/shared/knuckles/cutscene/map_ending_cutscene.s"
Map_SonicPlane:
                include "src/ui/shared/ending/map_sonic_plane.s"
Map_SonicPlaneEnding:
                include "src/ui/shared/ending/map_sonic_plane_ending.s"
Map_SKPoseBanner:
                include "src/ui/shared/ending/map_sonic_and_knuckles_pose_banner.s"
Map_S3PoseBanner:
                include "src/ui/shared/ending/map_sonic_3_pose_banner.s"
Map_IslandLiftGfx:
                include "src/ui/shared/ending/map_island_lift_sprites.s"
Map_EndingAnimals:
                include "src/ui/shared/ending/map_ending_pelican_and_dolphin.s"
Map_SonicTailsEndPoses:
                include "src/ui/shared/ending/map_sonic_tails_ending_poses.s"
Map_ANDKnuckles:
                include "src/ui/shared/ending/map_andknuckles_subtitle.s"
Map_EndingEyecatchEggRobo:
                include "src/ui/shared/ending/map_ending_egg_robo_eyecatch.s"
Map_EndingEyecatchEggman:
                include "src/ui/shared/ending/map_ending_eggman_eyecatch.s"
Map_KnuxEndPose:
                include "src/ui/shared/ending/map_knuckles_end_pose.s"
Pal_EndingSmallPlane:
                binclude "data/General/Ending/Palettes/Small Plane.bin"
                even
Pal_EndingSKLogo:
                binclude "data/General/Ending/Palettes/SK Logo.bin"
                even
Pal_EndingS3KLogo:
                binclude "data/General/Ending/Palettes/S3K Logo.bin"
                even
Pal_EndingEyecatchKnuckles:
                binclude "data/General/Ending/Palettes/Knuckles Eyecatch.bin"
                even
Pal_EndingMasterEmerald:
                binclude "data/General/Ending/Palettes/Master Emerald.bin"
                even
Pal_FBZCloud:
                binclude "data/Levels/FBZ/Palettes/FBZ Cloud.bin"
                even
Pal_TailsEndPose:
                binclude "data/General/Ending/Palettes/Tails End Pose.bin"
                even
Pal_SonicEndPose:
                binclude "data/General/Ending/Palettes/Sonic End Pose.bin"
                even
Pal_SuperSonicEndPose:
                binclude "data/General/Ending/Palettes/Super Sonic End Pose.bin"
                even
Pal_EndingEyecatchEggRobo:
                binclude "data/General/Ending/Palettes/Egg Robo Eyecatch.bin"
                even
Pal_EndingEyecatchEggman:
                binclude "data/General/Ending/Palettes/Eggman Eyecatch.bin"
                even
Pal_KnuxEndPose:
                binclude "data/General/Ending/Palettes/Knuckles End Pose.bin"
                even
PalSPtr_EndingSuperTails:
                palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_3+$04, 4, 0
                .data:  palscriptdata 24,$06C, $08E, $0AE, $8CE
                palscriptdata 8, $28E, $2AE, $2CE, $AEE
                palscriptdata 8, $4AE, $4CE, $4EE, $CEE
                palscriptdata 8, $6CE, $6EE, $6EE, $EEE
                palscriptdata 8, $4AE, $4CE, $4EE, $CEE
                palscriptdata 8, $28E, $2AE, $2CE, $AEE
                palscriptrept
