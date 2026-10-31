; Owner: rendering/sk
; Responsibility: Common sprites, special-stage graphics and perspective data resource bindings with their following physical padding
; Source provenance and ranges: config/reconstruction/source_layout.json
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
