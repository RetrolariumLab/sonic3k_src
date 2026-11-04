; Data owner: objects/shared/zones/dez
; Provenance and source range: config/reconstruction/source_layout.json
Map_DEZGravityPuzzle_:
                dc.w    DEZGravPuzzleMap_PuzzleBody-Map_DEZGravityPuzzle_
                dc.w    DEZGravPuzzleMap_LeftMarker-Map_DEZGravityPuzzle_
                dc.w    DEZGravPuzzleMap_RightMarker-Map_DEZGravityPuzzle_
                dc.w    DEZGravPuzzleMap_SharedInactiveFrame-Map_DEZGravityPuzzle_
                dc.w    DEZGravPuzzleMap_SharedInactiveFrame-Map_DEZGravityPuzzle_
DEZGravPuzzleMap_PuzzleBody:    dc.w    6               ; DATA XREF: ROM:00049A6C o
                dc.b    $D0,  $F,   0,   0, $FF, $E0
                dc.b    $D0,  $F,   8,   0,   0,  0
                dc.b    $F0,  $F,   0,   0, $FF, $E0
                dc.b    $F0,  $F,   8,   0,   0,  0
                dc.b    $10,  $F,   0,   0, $FF, $E0
                dc.b    $10,  $F,   8,   0,   0,  0
DEZGravPuzzleMap_LeftMarker:    dc.w    1               ; DATA XREF: ROM:00049A6C o
                dc.b    $F0,   3,   0, $1C, $FF, $FC
DEZGravPuzzleMap_RightMarker:   dc.w    1               ; DATA XREF: ROM:00049A6C o
                dc.b    $F0,   3,   8, $1C, $FF, $FC
DEZGravPuzzleMap_SharedInactiveFrame:   dc.w    0       ; DATA XREF: ROM:00049A6C o
