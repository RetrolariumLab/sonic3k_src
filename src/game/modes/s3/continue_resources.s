; Owner: game/modes/s3
; Responsibility: Continue screen mapping entries, icon placement records and checked art resources
; Source provenance and ranges: config/reconstruction/source_layout.json
Map_ContinueSprites:
                include "src/ui/shared/continue/mappings/player_sprites_s3.s"
Map_ContinueIcons:
                include "src/ui/shared/continue/mappings/player_icons.s"
S3Continue_SonicCountIconFramePair: dc.b    0
                dc.b    1
S3Continue_TailsCountIconFramePair: dc.b    2
                dc.b    3
S3Continue_KnucklesCountIconFramePair:  dc.b    7
                dc.b    8
S3Continue_KnucklesDepartureAnim:
                dc.b    1, $12, $13, $14, $15, $FC
ContinueTailsIconChild_RawAnimation:
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
