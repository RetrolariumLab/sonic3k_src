; Data owner: objects/shared/zones/pachinko
; Provenance and source range: config/reconstruction/source_layout.json
Ani_PachinkoTriangleBumper_:
                dc.w    PachinkoTriangleSTD_IdleBlank-Ani_PachinkoTriangleBumper_
                dc.w    PachinkoTriangleSTD_FlashThenReturnIdle-Ani_PachinkoTriangleBumper_
PachinkoTriangleSTD_IdleBlank:              dc.b    $1F,   0, $FF
PachinkoTriangleSTD_FlashThenReturnIdle:    dc.b    0,   1,   2,   1,   2,   1,   2,   1,   2,   1,   2, $FD,   0
                even
