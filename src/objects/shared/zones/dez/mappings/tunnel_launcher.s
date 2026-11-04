; Data owner: objects/shared/zones/dez
; Provenance and source range: config/reconstruction/source_layout.json
Map_DEZTunnelLauncher_:
                dc.w    DEZTunnelLaunchMap_Blank-Map_DEZTunnelLauncher_
                dc.w    DEZMap_TunnelLauncher_MainPulseOne-Map_DEZTunnelLauncher_
                dc.w    DEZMap_TunnelLauncher_MainPulseTwo-Map_DEZTunnelLauncher_
                dc.w    DEZTunnelLaunchMap_DescentFrame3-Map_DEZTunnelLauncher_
                dc.w    DEZTunnelLaunchMap_DescentFrame4-Map_DEZTunnelLauncher_
                dc.w    DEZTunnelLaunchMap_DescentFrame5-Map_DEZTunnelLauncher_
                dc.w    DEZTunnelLaunchMap_DescentFrame6-Map_DEZTunnelLauncher_
                dc.w    DEZTunnelLaunchMap_CountdownFrame7-Map_DEZTunnelLauncher_
                dc.w    DEZTunnelLaunchMap_CountdownFrame8-Map_DEZTunnelLauncher_
                dc.w    DEZTunnelLaunchMap_CountdownFrame9-Map_DEZTunnelLauncher_
                dc.w    DEZTunnelLaunchMap_CountdownFrame10-Map_DEZTunnelLauncher_
DEZTunnelLaunchMap_Blank:           dc.w    0
DEZMap_TunnelLauncher_MainPulseOne: dc.w    2
                dc.b    0,   5,   0, $10, $FF, $E8
                dc.b    0,   5,   0, $10,   0,   8
DEZMap_TunnelLauncher_MainPulseTwo: dc.w    2
                dc.b    0,   5,   0, $14, $FF, $E8
                dc.b    0,   5,   0, $14,   0,   8
DEZTunnelLaunchMap_DescentFrame3:   dc.w    2
                dc.b    4,   5,   0, $10, $FF, $E8
                dc.b    4,   5,   0, $10,   0,   8
DEZTunnelLaunchMap_DescentFrame4:   dc.w    2
                dc.b    8,   5,   0, $14, $FF, $E8
                dc.b    8,   5,   0, $14,   0,   8
DEZTunnelLaunchMap_DescentFrame5:   dc.w    2
                dc.b    $C,   5,   0, $10, $FF, $E8
                dc.b    $C,   5,   0, $10,   0,   8
DEZTunnelLaunchMap_DescentFrame6:   dc.w    2
                dc.b    $10,   5,   0, $14, $FF, $E8
                dc.b    $10,   5,   0, $14,   0,   8
DEZTunnelLaunchMap_CountdownFrame7: dc.w    1
                dc.b    $F8,   5,   0,  $C, $FF, $F8
DEZTunnelLaunchMap_CountdownFrame8: dc.w    1
                dc.b    $F8,   5,   0,   8, $FF, $F8
DEZTunnelLaunchMap_CountdownFrame9: dc.w    1
                dc.b    $F8,   5,   0,   4, $FF, $F8
DEZTunnelLaunchMap_CountdownFrame10:    dc.w    1
                dc.b    $F8,   5,   0,   0, $FF, $F8
