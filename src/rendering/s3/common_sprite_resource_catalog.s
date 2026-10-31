; Owner: rendering/s3
; Responsibility: Common sprites, special-stage graphics and perspective data, and competition character mapping/DPLC bindings
; Source provenance and ranges: config/reconstruction/source_layout.json
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
