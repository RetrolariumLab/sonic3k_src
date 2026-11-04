; Data owner: objects/shared/level_misc
; Provenance and source range: config/reconstruction/source_layout.json
Map_PathSwap_:
                dc.w    PathSwapMapping_XBoundaryFrame00-Map_PathSwap_
                dc.w    PathSwapMapping_XBoundaryFrame01-Map_PathSwap_
                dc.w    PathSwapMapping_XBoundaryFrames02And03-Map_PathSwap_
                dc.w    PathSwapMapping_XBoundaryFrames02And03-Map_PathSwap_
                dc.w    PathSwapMapping_YBoundaryFrame04-Map_PathSwap_
                dc.w    PathSwapMapping_YBoundaryFrame05-Map_PathSwap_
                dc.w    PathSwapMapping_YBoundaryFrames06And07-Map_PathSwap_
                dc.w    PathSwapMapping_YBoundaryFrames06And07-Map_PathSwap_
PathSwapMapping_XBoundaryFrame00:   dc.w    4
                dc.b    $E0,   5,   0,   0, $FF, $F8
                dc.b    $F0,   5,   0,   0, $FF, $F8
                dc.b    0,   5,   0,   0, $FF, $F8
                dc.b    $10,   5,   0,   0, $FF, $F8
PathSwapMapping_XBoundaryFrame01:   dc.w    4
                dc.b    $C0,   5,   0,   0, $FF, $F8
                dc.b    $E0,   5,   0,   0, $FF, $F8
                dc.b    0,   5,   0,   0, $FF, $F8
                dc.b    $30,   5,   0,   0, $FF, $F8
PathSwapMapping_XBoundaryFrames02And03: dc.w    4
                dc.b    $80,   5,   0,   0, $FF, $F8
                dc.b    $E0,   5,   0,   0, $FF, $F8
                dc.b    0,   5,   0,   0, $FF, $F8
                dc.b    $70,   5,   0,   0, $FF, $F8
PathSwapMapping_YBoundaryFrame04:   dc.w    4
                dc.b    $F8,   5,   0,   0, $FF, $E0
                dc.b    $F8,   5,   0,   0, $FF, $F0
                dc.b    $F8,   5,   0,   0,   0,   0
                dc.b    $F8,   5,   0,   0,   0, $10
PathSwapMapping_YBoundaryFrame05:   dc.w    4
                dc.b    $F8,   5,   0,   0, $FF, $C0
                dc.b    $F8,   5,   0,   0, $FF, $E0
                dc.b    $F8,   5,   0,   0,   0,   0
                dc.b    $F8,   5,   0,   0,   0, $30
PathSwapMapping_YBoundaryFrames06And07: dc.w    4
                dc.b    $F8,   5,   0,   0, $FF, $80
                dc.b    $F8,   5,   0,   0, $FF, $E0
                dc.b    $F8,   5,   0,   0,   0,   0
                dc.b    $F8,   5,   0,   0,   0, $70
