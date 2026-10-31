; Owner: ui/blue_sphere/sk
; Responsibility: Blue Sphere title foreground/background, character sprites, lettering and logos
; Source provenance and ranges: config/reconstruction/source_layout.json
MapEni_BlueSphereTitleFG:
                binclude "data/General/Blue Sphere/Enigma Map/Title FG.eni"
                even
ArtKos_BlueSphereChar:
                binclude "data/General/Blue Sphere/Kosinski Art/Characters.kos"
                even
Map_BlueSphereCharSprite:
                include "src/game/blue_sphere/shared/blue_sphere/map_character_sprites.s"
                even
ArtKos_BlueSphereCharSprite:
                binclude "data/General/Blue Sphere/Kosinski Art/Character Sprites.kos"
                even
ArtKos_BlueSphereNormalText:
                binclude "data/General/Blue Sphere/Kosinski Art/Normal Text.kos"
                even
MapEni_BlueSphereTitleBG:
                binclude "data/General/Blue Sphere/Enigma Map/Title BG.eni"
                even
ArtNem_BlueSphereSKLogo:
                binclude "data/General/Blue Sphere/Nemesis Art/SK Logo.nem"
                even
ArtNem_BlueSphereTails:
                binclude "data/General/Blue Sphere/Nemesis Art/Tails Pose.nem"
                even
ArtNem_MilesLifeIcon:
                binclude "data/General/Sprites/HUD Icon/Miles Life Icon.nem"
                even
