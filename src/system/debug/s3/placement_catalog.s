; Owner: system/debug/s3
; Responsibility: Zone debug-list pointer table and literal inclusions of each owned placement catalog
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
DebugOffs:      include "src/system/debug/shared/debug_list_pointers.s"

Debug_AIZ1:     dbglistinclude "src/system/debug/shared/zones/aiz/act_1_s3.s"
Debug_AIZ2:     dbglistinclude "src/system/debug/shared/zones/aiz/act_2_s3.s"
Debug_HCZ:      dbglistinclude "src/system/debug/shared/zones/hcz/s3.s"
Debug_MGZ:      dbglistinclude "src/system/debug/shared/zones/mgz/s3.s"
Debug_CNZ:      dbglistinclude "src/system/debug/shared/zones/cnz/s3.s"
Debug_FBZ1:
Debug_FBZ2:     dbglistinclude "src/system/debug/shared/zones/fbz/s3.s"
Debug_ICZ1:     dbglistinclude "src/system/debug/shared/zones/icz/act_1_s3.s"
Debug_ICZ2:     dbglistinclude "src/system/debug/shared/zones/icz/act_2_s3.s"
Debug_LBZ1:     dbglistinclude "src/system/debug/shared/zones/lbz/act_1_s3.s"
Debug_LBZ2:     dbglistinclude "src/system/debug/shared/zones/lbz/act_2_s3.s"
Debug_MHZ:      dbglistinclude "src/system/debug/shared/zones/mhz/s3.s"
Debug_SOZ1:
Debug_SOZ2:     dbglistinclude "src/system/debug/shared/zones/soz/s3.s"
Debug_LRZ1:
Debug_LRZ2:     dbglistinclude "src/system/debug/shared/zones/lrz/s3.s"
    ; Presumably, these belong to the LRZ debug list, but the header only counts five entries, ignoring these three
                dbglistobj Obj_Spring, Map_Spring, $90,   3, make_art_tile(ArtTile_SpikesSprings+$20,0,0)
                dbglistobj Obj_Spring, Map_Spring, $A0,   6, make_art_tile(ArtTile_SpikesSprings+$10,0,0)
                dbglistobj Obj_Spikes, Map_Spikes,   0,   0, make_art_tile(ArtTile_SpikesSprings+$8,0,0)
Debug_SSZ:              dbglistinclude "src/system/debug/shared/zones/ssz/s3.s"
Debug_DEZ1:
Debug_DEZ2:             dbglistinclude "src/system/debug/shared/zones/dez/s3.s"
Debug_DDZ1:
Debug_DDZ2:             dbglistinclude "src/system/debug/shared/zones/ddz/s3.s"
Debug_Ending:           dbglistinclude "src/system/debug/shared/zones/ssz/ending_s3.s"
Debug_ALZ:              dbglistinclude "src/system/debug/shared/zones/alz/main.s"
Debug_BPZ:              dbglistinclude "src/system/debug/shared/zones/bpz/main.s"
Debug_DPZ:              dbglistinclude "src/system/debug/shared/zones/dpz/main.s"
Debug_CGZ:              dbglistinclude "src/system/debug/shared/zones/cgz/main.s"
Debug_EMZ:              dbglistinclude "src/system/debug/shared/zones/emz/main.s"
Debug_Pachinko_Special:
Debug_HPZ:
Debug_Gumball_Special:  dbglistinclude "src/system/debug/shared/zones/gumball/s3.s"
