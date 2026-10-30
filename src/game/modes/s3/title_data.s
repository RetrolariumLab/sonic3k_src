; Owner: game/modes/s3
; Responsibility: Sonic 3 title cheat sequence, mapping owners and compressed screen-text storage
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
LSelect3CodeDat:
                dc.b    button_up_mask
                dc.b    button_up_mask
                dc.b    button_down_mask
                dc.b    button_down_mask
                dc.b    button_up_mask
                dc.b    button_up_mask
                dc.b    button_up_mask
                dc.b    button_up_mask
                dc.b    0
                even
Map_TitleScreenText:
                include "src/ui/shared/title/map_s3_screen_text.s"
ArtNem_TitleScreenText:
                binclude "data/General/Title/Nemesis Art/S3 Screen Text.nem"
                even
Map_TitleSonicAnim:
                include "src/ui/shared/title/map_s3_sonic_anim.s"
Map_TitleTailsPlane:
                include "src/ui/shared/title/map_s3_tails_plane.s"
