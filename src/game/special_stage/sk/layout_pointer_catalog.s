; Owner: game/special_stage/sk
; Responsibility: Compressed special-stage layout pointers and private slot-bonus layout records
; Source provenance and ranges: config/reconstruction/source_layout.json
SSCompressedLayoutPtrs:
                dc.l    SSLayoutData1_Kos
                dc.l    SSLayoutData2_Kos
SlotBonusLayout:
                binclude "data/Levels/Slots/SSLayout/Bonus Player Start.bin"
                even
                binclude "data/Levels/Slots/SSLayout/Bonus Layout.bin"
                even
SKPachinko_WeightedItemSubtypeBytes:
                dc.b    1,   3,   1,   3,   8,   3,   8,   5,   1,   3,   6,   4,   1,   7,   6,   5,   8,   6,   4,   3
                dc.b    4,   3,   4,   5,   8,   4,   5,   3,   7,   3,   8,   3,   6,   5,   6,   7,   4,   3,   7,   5
                dc.b    6,   4,   6,   4,   7,   3,   3,   5,   4,   3,   4,   6,   3,   4,   3,   7,   4,   3,   4,   3
                dc.b    4,   3,   4,   3
SKPachinko_HighYBandRingAwardBytes:
                dc.b    $50, $32, $28, $23, $23, $1E, $1E, $14, $14,  $A,  $A,  $A,  $A,   5,   5,   5
                even
