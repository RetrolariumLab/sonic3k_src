; Owner: ui/s3
; Responsibility: Save-screen and competition-menu palette, art, frame and text resource bindings
; Source provenance and ranges: config/reconstruction/source_layout.json
Pal_SaveMenuBG:
                binclude "data/General/Save Menu/Palettes/BG.bin"
                even
Pal_CompetitionMenuBG:
                binclude "data/General/Competition Menu/Palettes/BG.bin"
                even
MapEni_S3MenuBG:
                binclude "data/General/Save Menu/Enigma Map/Menu BG.eni"
                even
ArtKos_S3MenuBG:
                binclude "data/General/Save Menu/Kosinski Art/Menu BG.kos"
                even
MapEni_CompetitionLevBorder:
                binclude "data/General/Competition Menu/Enigma Map/Level Border.eni"
                even
MapUnc_CompetitionTimeBorder:
                binclude "data/General/Competition Menu/Uncompressed Map/Time Border.bin"
                even
MapUnc_CompetitionBESTTIME:
                binclude "data/General/Competition Menu/Uncompressed Map/Time Text.bin"
                even
MapEni_CompetitionLevImage:
                binclude "data/General/Competition Menu/Enigma Map/Level Images.eni"
                even
MapEni_CompetitionLevName:
                binclude "data/General/Competition Menu/Enigma Map/Level Names.eni"
                even
ArtKos_CompetitionMode:
                binclude "data/General/Competition Menu/Kosinski Art/Mode Select.kos"
                even
ArtKos_CompetitionLevel:
                binclude "data/General/Competition Menu/Kosinski Art/Level Select.kos"
                even
ArtKos_CompetitionResults:
                binclude "data/General/Competition Menu/Kosinski Art/Results.kos"
                even
Map_CompetitionPlayerSprite:
                include "src/ui/shared/competition_menu/mappings/competition_player_sprites.s"
ArtKos_CompetitionPlayer:
                binclude "data/General/Competition Menu/Kosinski Art/Player Sprites.kos"
                even
MapEni_SaveScreen_Layout:
                binclude "data/General/Save Menu/Enigma Map/Save Screen Layout.eni"
                even
MapUnc_SaveScreenNEW:
                binclude "data/General/Save Menu/Uncompressed Map/NEW.bin"
                even
MapPtrs_SaveScreenStatic:
                dc.l    MapUnc_SaveScreenStatic1
                dc.l    MapUnc_SaveScreenStatic2
                dc.l    MapUnc_SaveScreenStatic3
                dc.l    MapUnc_SaveScreenStatic4
MapUnc_SaveScreenStatic1:
                binclude "data/General/Save Menu/Uncompressed Map/Static 1.bin"
                even
MapUnc_SaveScreenStatic2:
                binclude "data/General/Save Menu/Uncompressed Map/Static 2.bin"
                even
MapUnc_SaveScreenStatic3:
                binclude "data/General/Save Menu/Uncompressed Map/Static 3.bin"
                even
MapUnc_SaveScreenStatic4:
                binclude "data/General/Save Menu/Uncompressed Map/Static 4.bin"
                even
ArtKos_SaveScreenMisc:
                binclude "data/General/Save Menu/Kosinski Art/Misc.kos"
                even
