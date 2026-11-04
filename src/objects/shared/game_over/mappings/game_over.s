; Data owner: objects/shared/game_over
; Provenance and source range: config/reconstruction/source_layout.json
Map_GameOver_:
                dc.w    SharedGameOverMap_LeftGameMessageFrame00-Map_GameOver_
                dc.w    GameOverMap_GameRightFrame01-Map_GameOver_
                dc.w    SharedGameOverMap_LeftTimeMessageFrame02-Map_GameOver_
                dc.w    GameOverMap_TimeRightFrame03-Map_GameOver_
SharedGameOverMap_LeftGameMessageFrame00:   dc.w    2
                dc.b    $F8,  $D,   0,   0, $FF, $B8
                dc.b    $F8,  $D,   0,   8, $FF, $D8
GameOverMap_GameRightFrame01:   dc.w    2
                dc.b    $F8,  $D,   0, $14,   0,   8
                dc.b    $F8,  $D,   0,  $C,   0, $28
SharedGameOverMap_LeftTimeMessageFrame02:   dc.w    2
                dc.b    $F8,   9,   0, $1C, $FF, $C4
                dc.b    $F8,  $D,   0,   8, $FF, $DC
GameOverMap_TimeRightFrame03:   dc.w    2
                dc.b    $F8,  $D,   0, $14,   0,  $C
                dc.b    $F8,  $D,   0,  $C,   0, $2C
