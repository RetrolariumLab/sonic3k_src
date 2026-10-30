; Owner: game/modes/s3
; Responsibility: Level selection text, mapping offsets, identifier sequences and display asset storage
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
S2LevelSelectCodeDat:
                dc.b    $19, $65,   9, $17,   0
S2ContinueCodeDat:
                dc.b    1,   1,   2,   4,   0
DebugCodeDat:
                dc.b    1,   3,   5,   7,   0
AllEmeraldsCodeDat:
                dc.b    2,   4,   5,   6,   0
TextOptScr_PlayerSelect:
                levselstr "* PLAYER SELECT *"
TextOptScr_SonicAndMiles:
                levselstr "SONIC AND MILES"
TextOptScr_SonicAndTails:
                levselstr "SONIC AND TAILS"
TextOptScr_SonicAlone:
                levselstr "SONIC ALONE    "
TextOptScr_MilesAlone:
                levselstr "MILES ALONE    "
TextOptScr_TailsAlone:
                levselstr "TAILS ALONE    "
TextOptScr_VsModeItems:
                levselstr "* VS MODE ITEMS *"
TextOptScr_AllKindsItems:
                levselstr "ALL KINDS ITEMS"
TextOptScr_TeleportOnly:
                levselstr "TELEPORT ONLY  "
TextOptScr_SoundTest:
                levselstr "*  SOUND TEST   *"
TextOptScr_0:
                levselstr "      00       "
Text2P_EmeraldHill:
                levselstr "EMERALD HILL"
Text2P_MysticCave:
                levselstr " MYSTIC CAVE"
Text2P_CasinoNight:
                levselstr "CASINO NIGHT"
Text2P_SpecialStage:
                levselstr "SPECIAL STAGE"
Text2P_Special:
                levselstr "   SPECIAL  "
Text2P_Zone:
                levselstr "ZONE "
Text2P_Stage:
                levselstr "STAGE"
Text2P_GameOver:
                levselstr "GAME OVER"
Text2P_TimeOver:
                levselstr "TIME OVER"
Text2P_NoGame:
                levselstr "NO GAME"
Text2P_Tied:
                levselstr "TIED"
Text2P_1P:
                levselstr " 1P"
Text2P_2P:
                levselstr " 2P"
Text2P_Blank:
                levselstr "    "
LevelSelectText:
                levselstr "ANGEL ISLAND"
                levselstr "HYDROCITY"
                levselstr "MARBLE GARDEN"
                levselstr "CARNIVAL NIGHT"
                levselstr "FLYING BATTERY"
                levselstr "ICECAP"
                levselstr "LAUNCH BASE"
                levselstr "MUSHROOM VALLEY"
                levselstr "SANDOPOLIS"
                levselstr "2P VS"
                levselstr "2P VS"
                levselstr "2P VS"
                levselstr "BONUS"
                levselstr "SPECIAL STAGE"
                levselstr "SOUND TEST  *"
                even
Pal_S2LevelIcons:
                binclude "data/General/S2Menu/Palettes/Level Select Icons.bin"
                even
MapEni_S2LevSel2P:
                binclude "data/General/S2Menu/Enigma Map/Level Select 2P.eni"
                even
MapEni_S2Options:
                binclude "data/General/S2Menu/Enigma Map/Options Screen.eni"
                even
MapEni_S2LevSel:
                binclude "data/General/S2Menu/Enigma Map/Level Select.eni"
                even
MapEni_S2LevSelIcon:
                binclude "data/General/S2Menu/Enigma Map/Level Select Icons.eni"
                even
AniPLC_SONICMILES:  zoneanimstart
; Sonic/Miles animated background
                zoneanimdecl -1, ArtUnc_SONICMILES, $001,  6, $A
                dc.b    0, $C7
                dc.b    $A,   5
                dc.b    $14,   5
                dc.b    $1E, $C7
                dc.b    $14,   5
                dc.b    $A,   5
                even
                zoneanimend
; ---------------------------------------------------------------------------
