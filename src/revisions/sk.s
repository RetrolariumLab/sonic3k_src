; Owner: revisions/sk
; Responsibility: Official sibling engine assembly root and canonical owner order
; Source provenance and ranges: config/reconstruction/source_layout.json

                include "src/revisions/sk/engine_order.s"
                include "src/audio/banks/sk/music_bank_1.s"
                include "src/audio/banks/sk/music_bank_2.s"
                include "src/audio/banks/sk/dac_bank.s"
                include "Sound/Z80 Sound Driver.s"
                include "src/audio/banks/sk/effect_bank.s"
                include "src/revisions/sk/graphics_order.s"
                include "src/revisions/sk/cartridge_tail.s"
                include "Lockon S3/LockOn Pointers.s"
                END
