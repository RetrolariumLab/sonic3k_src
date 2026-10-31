; Owner: game/player/s3
; Responsibility: Player art and complete Sonic/Tails mapping and DPLC resource bindings, with physical post-audio alignment
; Source provenance and ranges: config/reconstruction/source_layout.json

                align   $8000
ArtUnc_Sonic:
                binclude "data/General/Sprites/Sonic/Art/Sonic.unc"
                even
ArtUnc_Tails:
                binclude "data/General/Sprites/Tails/Art/Tails.unc"
                even
ArtUnc_Tails_Tail:
                binclude "data/General/Sprites/Tails/Art/Tails tails.unc"
                even
ArtUnc_Sonic2P:
                binclude "data/General/Sprites/Sonic/Art/Sonic 2P.unc"
                even
ArtUnc_Tails2P:
                binclude "data/General/Sprites/Tails/Art/Tails 2P.unc"
                even
ArtUnc_Tails2P_Tail:
                binclude "data/General/Sprites/Tails/Art/Tails tails 2P.unc"
                even
ArtUnc_Knuckles2P:
                binclude "data/General/Sprites/Knuckles/Art/Knuckles 2P.unc"
                even
Map_Sonic:
                include "src/objects/shared/sonic/mappings/s3.s"
PLC_Sonic:
                include "src/objects/shared/sonic/dplc/s3.s"
Map_Tails:
                include "src/objects/shared/tails/mappings/s3.s"
PLC_Tails:
                include "src/objects/shared/tails/dplc/s3.s"
Map_Tails_Tail:
                include "src/objects/shared/tails/mappings/tail.s"
PLC_Tails_Tail:
                include "src/objects/shared/tails/dplc/tail.s"
