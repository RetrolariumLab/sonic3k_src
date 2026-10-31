; Owner: memory/shared
; Responsibility: Reset the non-emitting allocation cursor before cartridge assembly
; Source provenance and ranges: config/reconstruction/source_layout.json

                padding off
                !org    0                               ; make sure we reset the ROM position to 0

; Nemesis writes eight pixel rows per 8x8 tile; a5 carries this loop count
Nem_Tile_Row_Count: equ     8
