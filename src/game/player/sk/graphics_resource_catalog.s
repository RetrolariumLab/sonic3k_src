; Owner: game/player/sk
; Responsibility: Player art and complete Sonic/Tails/Knuckles mapping and DPLC resource bindings, with physical post-audio alignment
; Source provenance and ranges: config/reconstruction/source_layout.json

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
