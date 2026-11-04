; Data owner: objects/shared/zones/dez
; Provenance and source range: config/reconstruction/source_layout.json
Map_DEZTransRings_:
                dc.w    DEZMap_TransporterRing_HoldShapeZero-Map_DEZTransRings_
                dc.w    DEZMap_TransporterRing_HoldShapeOne-Map_DEZTransRings_
                dc.w    DEZMap_TransporterRing_HoldShapeTwo-Map_DEZTransRings_
                dc.w    DEZTransportRingMap_SharedHoldFrames34-Map_DEZTransRings_
                dc.w    DEZTransportRingMap_SharedHoldFrames34-Map_DEZTransRings_
                dc.w    DEZMap_TransporterRing_TransitionFive-Map_DEZTransRings_
                dc.w    DEZMap_TransporterRing_TransitionSix-Map_DEZTransRings_
                dc.w    DEZTransportRingMap_NormalFrame7-Map_DEZTransRings_
                dc.w    DEZTransportRingMap_NormalFrame8-Map_DEZTransRings_
                dc.w    DEZTransportRingMap_NormalFrame9-Map_DEZTransRings_
                dc.w    DEZTransportRingMap_NormalFrameA-Map_DEZTransRings_
                dc.w    DEZTransportRingMap_NormalFrameB-Map_DEZTransRings_
                dc.w    DEZTransportRingMap_NormalFrameC-Map_DEZTransRings_
                dc.w    DEZTransportRingMap_NormalFrameD-Map_DEZTransRings_
DEZMap_TransporterRing_HoldShapeZero:   dc.w    2
                dc.b    $E8,   2,   0, $18, $FF, $FC
                dc.b    0,   2, $10, $18, $FF, $FC
DEZMap_TransporterRing_HoldShapeOne:    dc.w    2
                dc.b    $E8,   6,   0, $1B, $FF, $F8
                dc.b    0,   6, $10, $1B, $FF, $F8
DEZMap_TransporterRing_HoldShapeTwo:    dc.w    2
                dc.b    $E8,  $E,   0, $21, $FF, $F0
                dc.b    0,  $E, $10, $21, $FF, $F0
DEZTransportRingMap_SharedHoldFrames34: dc.w    4
                dc.b    $E8,  $A,   0, $2D, $FF, $EC
                dc.b    $E8,   6,   0, $36,   0,   4
                dc.b    0,  $A, $10, $2D, $FF, $EC
                dc.b    0,   6, $10, $36,   0,   4
DEZMap_TransporterRing_TransitionFive:  dc.w    1
                dc.b    $FC,   0,   0, $3C, $FF, $FC
DEZMap_TransporterRing_TransitionSix:   dc.w    1
                dc.b    $F8,   5,   0, $3D, $FF, $F8
DEZTransportRingMap_NormalFrame7:   dc.w    2
                dc.b    $E8,   6,   0, $50, $FF, $FC
                dc.b    0,   6,   0, $56, $FF, $F4
DEZTransportRingMap_NormalFrame8:   dc.w    3
                dc.b    $EC,   9,   0, $5C, $FF, $FC
                dc.b    $FC,   8,   0, $62, $FF, $F4
                dc.b    4,   9,   0, $65, $FF, $EC
DEZTransportRingMap_NormalFrame9:   dc.w    2
                dc.b    $F4,   9,   0, $6B,   0,   0
                dc.b    $FC,   9,   0, $71, $FF, $E8
DEZTransportRingMap_NormalFrameA:   dc.w    2
                dc.b    $FC,   8,   0, $77, $FF, $E8
                dc.b    $FC,   8,   8, $77,   0,   0
DEZTransportRingMap_NormalFrameB:   dc.w    2
                dc.b    $F4,   9, $10, $71, $FF, $E8
                dc.b    $FC,   9, $10, $6B,   0,   0
DEZTransportRingMap_NormalFrameC:   dc.w    3
                dc.b    $EC,   9, $10, $65, $FF, $EC
                dc.b    $FC,   8, $10, $62, $FF, $F4
                dc.b    4,   9, $10, $5C, $FF, $FC
DEZTransportRingMap_NormalFrameD:   dc.w    2
                dc.b    $E8,   6, $10, $56, $FF, $F4
                dc.b    0,   6, $10, $50, $FF, $FC
