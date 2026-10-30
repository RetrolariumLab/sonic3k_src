; Owner: game/modes/s3
; Responsibility: Continue screen mapping entries, icon placement records and checked art resources
; Source provenance and ranges: config/reconstruction/source_layout.json
Map_ContinueSprites:
                include "src/ui/shared/continue/map_player_sprites_s3.s"
Map_ContinueIcons:
                include "src/ui/shared/continue/map_player_icons.s"
byte_3F834:     dc.b    0
                dc.b    1
byte_3F836:     dc.b    2
                dc.b    3
byte_3F838:     dc.b    7
                dc.b    8
byte_3F83A:
                dc.b    1, $12, $13, $14, $15, $FC
byte_3F840:
                dc.b    8,   4,   5,   6, $FC
                even
ArtNem_ContinueSprites:
                binclude "data/General/Continue/Nemesis Art/Player Sprites.nem"
                even
ArtNem_ContinueIcons:
                binclude "data/General/Continue/Nemesis Art/Player Icons.nem"
                even
ArtNem_ContinueDigits:
                binclude "data/General/Continue/Nemesis Art/Digits.nem"
                even
