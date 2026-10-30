; Owner: game/modes/sk
; Responsibility: Save slot text strings and product-specific zone icon art storage
; Source provenance and ranges: config/reconstruction/source_layout.json
                save
                codepage LEVELSELECT
; byte_DB1C
NoSave_Delete_Text:
                dc.b    "NO#SAVE", $FF                  ; The space in the middle was changed in Sonic 3 & Knuckles to fix a tile gap in the menu box plane map
                dc.b    "DELETE", $FF
; byte_DB2B
BlankSave_Text:
                dc.b    "     ", $FF
; byte_DB31
D_S_Zone_Text:
                dc.b    "ZONE", $FF
; byte_DB36
Clear_Text:
                dc.b    "CLEAR", $FF
                even
                restore
; =============== S U B R O U T I N E =======================================
