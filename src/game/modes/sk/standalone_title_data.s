; Owner: game/modes/sk
; Responsibility: Standalone title shake sequence and icon, trademark and copyright mapping owners
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
SKTitle_ShakeOffsets:
                dc.b    1,   2,   1,   3,   1,   2,   2,   1,   2,   3,   1,   2,   1,   2,   0,   0
                dc.b    2,   0,   3,   2,   2,   3,   2,   2,   1,   3,   0,   0,   1,   0,   1,   3
                dc.b    1,   2,   1,   3,   1,   2,   2,   1,   2,   3,   1,   2,   1,   2,   0,   0
                dc.b    2,   0,   3,   2,   2,   3,   2,   2,   1,   3,   0,   0,   1,   0,   1,   3,  1,   2
                even
Map_SKTitle_Icon:
                include "src/ui/shared/title/map_sk_icon.s"
Map_SKTitle_TM:
                include "src/ui/shared/title/map_sk_tm.s"
Map_SKTitle_Copyright:
                include "src/ui/shared/title/map_sk_copyright.s"
; ---------------------------------------------------------------------------
