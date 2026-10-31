; Owner: objects/special_stage/sk
; Responsibility: Special-stage entry ring and flash mappings, DPLC resources and palette scripts
; Source provenance and ranges: config/reconstruction/source_layout.json
Map_SSEntryRing:
                include "src/objects/shared/ss_entry/map_entry_ring.s"
DPLC_SSEntryRing:
                include "src/objects/shared/ss_entry/dplc_special_stage_entry_ring.s"
Map_SSEntryFlash:
                include "src/objects/shared/ss_entry/map_entry_flash.s"
DPLC_SSEntryFlash:
                include "src/objects/shared/ss_entry/dplc_special_stage_entry_flash.s"
PalSPtr_SSEntry:
                palscriptptr .header, .data
                .header: palscripthdr Normal_palette_line_2+$A, 2, 0
                .data:  palscriptdata 3, $ECE, $A8A
                palscriptdata 3, $AEE, $6EE
                palscriptdata 3, $ECA, $A86
                palscriptdata 3, $AEE, $6EE
                palscriptdata 3, $8E8, $4C4
                palscriptdata 3, $AEE, $6EE
                palscriptdata 3, $6EC, $4CA
                palscriptdata 3, $AEE, $6EE
                palscriptdata 3, $6CE, $2AC
                palscriptdata 3, $AEE, $6EE
                palscriptrept
                palscriptdata 2, $6EE, $0AA
                palscriptdata 2, $8EE, $0CC
                palscriptdata 2, $AEE, $6EE
                palscriptdata 2, $CEE, $AEE
                palscriptdata 2, $EEE, $EEE
                palscriptdata 2, $CEE, $AEE
                palscriptdata 2, $AEE, $6EE
                palscriptdata 2, $8EE, $0CC
                palscriptrept

PalSPtr_SSEntry2:
                palscriptptr .header, .data
                .header: palscripthdr Normal_palette_line_2+$1E, 1, 0
                .data:  palscriptdata 3, $868
                palscriptdata 3, $0AA
                palscriptdata 3, $864
                palscriptdata 3, $0AA
                palscriptdata 3, $2A2
                palscriptdata 3, $0AA
                palscriptdata 3, $4A8
                palscriptdata 3, $0AA
                palscriptdata 3, $28A
                palscriptdata 3, $0AA
                palscriptrept
                palscriptdata 2, $066
                palscriptdata 2, $088
                palscriptdata 2, $0AA
                palscriptdata 2, $0CC
                palscriptdata 2, $EEE
                palscriptdata 2, $0CC
                palscriptdata 2, $0AA
                palscriptdata 2, $088
                palscriptrept
                palscriptdata 2, $6EE, $0AA
                palscriptdata 2, $8EE, $0CC
                palscriptdata 2, $AEE, $6EE
                palscriptdata 2, $CEE, $AEE
                palscriptdata 2, $EEE, $EEE
                palscriptdata 2, $CEE, $AEE
                palscriptdata 2, $AEE, $6EE
                palscriptdata 2, $8EE, $0CC
                palscriptdata 1, $066
                palscriptdata 1, $088
                palscriptdata 1, $0AA
                palscriptdata 1, $0CC
                palscriptdata 1, $EEE
                palscriptdata 1, $0CC
                palscriptdata 1, $0AA
                palscriptdata 1, $088
