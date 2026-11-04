; Data owner: game/competition/shared/2p_zone
; Provenance and source range: config/reconstruction/source_layout.json
Map_2PItemIcon_:
                dc.w    RaceItemHUD_EmptyBorderMap-Map_2PItemIcon_
                dc.w    RaceItemHUD_SpeedUpMap-Map_2PItemIcon_
                dc.w    RaceItemHUD_SlowdownMap-Map_2PItemIcon_
                dc.w    RaceItemHUD_NonzeroRingsMap-Map_2PItemIcon_
RaceItemHUD_EmptyBorderMap: dc.w    4
                dc.b    $F0,  $C,   0,   0, $FF, $F0
                dc.b    $F8,   1,   0,   4, $FF, $F0
                dc.b    $F8,   1,   8,   4,   0,   8
                dc.b    8,  $C, $10,   0, $FF, $F0
RaceItemHUD_SpeedUpMap: dc.w    5
                dc.b    $F0,  $C,   0,   0, $FF, $F0
                dc.b    $F8,   1,   0,   4, $FF, $F0
                dc.b    $F8,   1,   8,   4,   0,   8
                dc.b    8,  $C, $10,   0, $FF, $F0
                dc.b    $F8,   5, $FC, $76, $FF, $F8
RaceItemHUD_SlowdownMap:    dc.w    5
                dc.b    $F0,  $C,   0,   0, $FF, $F0
                dc.b    $F8,   1,   0,   4, $FF, $F0
                dc.b    $F8,   1,   8,   4,   0,   8
                dc.b    8,  $C, $10,   0, $FF, $F0
                dc.b    $F8,   5, $FC, $7A, $FF, $F8
RaceItemHUD_NonzeroRingsMap:    dc.w    5
                dc.b    $F0,  $C,   0,   0, $FF, $F0
                dc.b    $F8,   1,   0,   4, $FF, $F0
                dc.b    $F8,   1,   8,   4,   0,   8
                dc.b    8,  $C, $10,   0, $FF, $F0
                dc.b    $F8,   5, $5C, $82, $FF, $F8
