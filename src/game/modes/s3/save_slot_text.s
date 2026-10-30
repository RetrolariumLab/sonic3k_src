; Owner: game/modes/s3
; Responsibility: Save slot text strings and product-specific zone icon art storage
; Source provenance and ranges: config/reconstruction/source_layout.json
                save
                codepage LEVELSELECT
; byte_C7BE
NoSave_Delete_Text:
                dc.b    "NO SAVE", $FF
                dc.b    "DELETE", $FF
; byte_C7CD
BlankSave_Text:
                dc.b    "     ", $FF
; byte_C7D3
D_S_Zone_Text:
                dc.b    "ZONE ", $FF
; byte_C7D9
Clear_Text:
                dc.b    "CLEAR", $FF
                even
                restore

ArtKos_SaveScreenS3Zone:
                binclude "data/General/Save Menu/Kosinski Art/Zone Art.kos"
                even

; =============== S U B R O U T I N E =======================================
