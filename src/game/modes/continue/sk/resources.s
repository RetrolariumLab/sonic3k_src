; Owner: game/modes/continue/sk
; Responsibility: Continue sprite and icon mappings, compressed art and digit graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
Map_ContinueSprites:
                include "src/ui/shared/continue/map_player_sprites.s"
Map_ContinueIcons:
                include "src/ui/shared/continue/map_player_icons.s"
ArtNem_ContinueSprites:
                binclude "data/General/Continue/Nemesis Art/Player Sprites.nem"
                even
ArtNem_ContinueIcons:
                binclude "data/General/Continue/Nemesis Art/Player Icons.nem"
                even
ArtNem_ContinueDigits:
                binclude "data/General/Continue/Nemesis Art/Digits.nem"
                even
