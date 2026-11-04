; Data owner: ui/shared/ending
; Provenance and source range: config/reconstruction/source_layout.json
Map_EndingAnimals_:
                dc.w    EndAnimal_LeapAscendMap-Map_EndingAnimals_
                dc.w    EndAnimal_LeapDescendMap-Map_EndingAnimals_
                dc.w    EndAnimal_FlightMap1-Map_EndingAnimals_
                dc.w    EndAnimal_FlightMap2-Map_EndingAnimals_
                dc.w    EndAnimal_FlightMap3-Map_EndingAnimals_
EndAnimal_LeapAscendMap:    dc.w    3
                dc.b    $F0,   5,   0,   0, $FF, $E0
                dc.b    $F0,  $F,   0,   4, $FF, $F0
                dc.b    0,   6,   0, $14,   0, $10
EndAnimal_LeapDescendMap:   dc.w    4
                dc.b    $E8,  $A,   0, $1A, $FF, $E8
                dc.b    0,  $D,   0, $23, $FF, $E0
                dc.b    $F0,   5,   0, $2B,   0,   0
                dc.b    $F8,   5,   0, $2F,   0, $10
EndAnimal_FlightMap1:   dc.w    1
                dc.b    $F8,   9,   0, $33, $FF, $F4
EndAnimal_FlightMap2:   dc.w    1
                dc.b    $F8,   9,   0, $39, $FF, $F4
EndAnimal_FlightMap3:   dc.w    1
                dc.b    $F4,  $A,   0, $3F, $FF, $F4
