; Data owner: objects/shared/zones/soz
; Provenance and source range: config/reconstruction/source_layout.json
Map_SOZPushSwitch_:
                dc.w    SOZMap_PushSwitch_EmbeddedFixedBase-Map_SOZPushSwitch_
                dc.w    SOZMap_PushSwitch_MainMovingSinglePiece-Map_SOZPushSwitch_
SOZMap_PushSwitch_EmbeddedFixedBase:    dc.w    2
                dc.b    8,  $C,   0,   0, $FF, $E0
                dc.b    8,  $C,   8,   0,   0,   0
SOZMap_PushSwitch_MainMovingSinglePiece:    dc.w    1
                dc.b    $F0,  $B,   0,   4, $FF, $F4
