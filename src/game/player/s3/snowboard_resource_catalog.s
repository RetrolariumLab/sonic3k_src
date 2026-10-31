; Owner: game/player/s3
; Responsibility: Icecap snowboard slopes, Sonic and board art, mappings and DPLC resource bindings
; Source provenance and ranges: config/reconstruction/source_layout.json
ICZSnowboard_Slope1:
                binclude "data/Levels/ICZ/Misc/ICZ Snowboard Slope 1.bin"
                even
ICZSnowboard_Slope2:
                binclude "data/Levels/ICZ/Misc/ICZ Snowboard Slope 2.bin"
                even
ArtUnc_SonicSnowboard:
                binclude "data/General/Sprites/Sonic/Art/Sonic Snowboarding.unc"
                even
ArtUnc_Snowboard:
                binclude "data/General/Sprites/Snowboard/Snowboard.unc"
                even
Map_SonicSnowboard:
                include "src/objects/shared/sonic/mappings/snowboarding.s"
DPLC_SonicSnowboard:
                include "src/objects/shared/sonic/dplc/snowboarding.s"
Map_Snowboard:
                include "src/objects/shared/snowboard/mappings/snowboard.s"
DPLC_Snowboard:
                include "src/objects/shared/snowboard/dplc/snowboard.s"
