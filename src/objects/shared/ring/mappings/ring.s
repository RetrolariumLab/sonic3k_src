; Data owner: objects/shared/ring
; Provenance and source range: config/reconstruction/source_layout.json
Map_Ring_:
                dc.w    SharedRingMap_SpinFrame00-Map_Ring_
                dc.w    SharedRingMap_SpinFrame01-Map_Ring_
                dc.w    SharedRingMap_SpinFrame02-Map_Ring_
                dc.w    SharedRingMap_SpinFrame03-Map_Ring_
                dc.w    SharedRingMap_SparkleFrame04-Map_Ring_
                dc.w    SharedRingMap_SparkleFrame05-Map_Ring_
                dc.w    SharedRingMap_SparkleFrame06-Map_Ring_
                dc.w    SharedRingMap_SparkleFrame07-Map_Ring_
                dc.w    SharedRingMap_BlankFrame08-Map_Ring_
SharedRingMap_SpinFrame00:  dc.w    1
                dc.b    $F8,   5,   0,   0, $FF, $F8
SharedRingMap_SpinFrame01:  dc.w    1
                dc.b    $F8,   5,   0,   4, $FF, $F8
SharedRingMap_SpinFrame02:  dc.w    1
                dc.b    $F8,   1,   0,   8, $FF, $FC
SharedRingMap_SpinFrame03:  dc.w    1
                dc.b    $F8,   5,   8,   4, $FF, $F8
SharedRingMap_SparkleFrame04:   dc.w    1
                dc.b    $F8,   5,   0,  $A, $FF, $F8
SharedRingMap_SparkleFrame05:   dc.w    1
                dc.b    $F8,   5, $18,  $A, $FF, $F8
SharedRingMap_SparkleFrame06:   dc.w    1
                dc.b    $F8,   5,   8,  $A, $FF, $F8
SharedRingMap_SparkleFrame07:   dc.w    1
                dc.b    $F8,   5, $10,  $A, $FF, $F8
SharedRingMap_BlankFrame08: dc.w    0
