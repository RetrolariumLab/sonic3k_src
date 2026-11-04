; Data owner: game/blue_sphere/shared/blue_sphere
; Provenance and source range: config/reconstruction/source_layout.json
Map_BlueSpheresNum_:
                dc.w    BlueSphereDigit_ZeroPieces-Map_BlueSpheresNum_
                dc.w    BlueSphereDigit_OnePieces-Map_BlueSpheresNum_
                dc.w    BlueSphereDigit_TwoPieces-Map_BlueSpheresNum_
                dc.w    BlueSphereDigit_ThreePieces-Map_BlueSpheresNum_
                dc.w    BlueSphereDigit_FourPieces-Map_BlueSpheresNum_
                dc.w    BlueSphereDigit_FivePieces-Map_BlueSpheresNum_
                dc.w    BlueSphereDigit_SixPieces-Map_BlueSpheresNum_
                dc.w    BlueSphereDigit_SevenPieces-Map_BlueSpheresNum_
                dc.w    BlueSphereDigit_EightPieces-Map_BlueSpheresNum_
                dc.w    BlueSphereDigit_NinePieces-Map_BlueSpheresNum_
                dc.w    BSDigit_SuppressedAndSpacerMap-Map_BlueSpheresNum_
                dc.w    BlueSphereDigit_TrailingSpacerPieces-Map_BlueSpheresNum_
BlueSphereDigit_ZeroPieces: dc.w    1
                dc.b    $F8,   1,   0, $12, $FF, $FC
BlueSphereDigit_OnePieces:  dc.w    1
                dc.b    $F8,   1,   0, $14, $FF, $FC
BlueSphereDigit_TwoPieces:  dc.w    1
                dc.b    $F8,   1,   0, $16, $FF, $FC
BlueSphereDigit_ThreePieces:    dc.w    1
                dc.b    $F8,   1,   0, $18, $FF, $FC
BlueSphereDigit_FourPieces: dc.w    1
                dc.b    $F8,   1,   0, $1A, $FF, $FC
BlueSphereDigit_FivePieces: dc.w    1
                dc.b    $F8,   1,   0, $1C, $FF, $FC
BlueSphereDigit_SixPieces:  dc.w    1
                dc.b    $F8,   1,   0, $1E, $FF, $FC
BlueSphereDigit_SevenPieces:    dc.w    1
                dc.b    $F8,   1,   0, $20, $FF, $FC
BlueSphereDigit_EightPieces:    dc.w    1
                dc.b    $F8,   1,   0, $22, $FF, $FC
BlueSphereDigit_NinePieces: dc.w    1
                dc.b    $F8,   1,   0, $24, $FF, $FC
BSDigit_SuppressedAndSpacerMap: dc.w    1
                dc.b    $F8,   5,   0,   0, $FF, $F4
BlueSphereDigit_TrailingSpacerPieces:   dc.w    1
                dc.b    $F8,   5,   0,   0, $FF, $FC
