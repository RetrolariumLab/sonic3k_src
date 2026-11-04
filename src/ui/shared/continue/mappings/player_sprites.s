; Data owner: ui/shared/continue
; Provenance and source range: config/reconstruction/source_layout.json
Map_ContinueSprites_:
                dc.w    SKContinueSprite_SonicWaitFirstPieces-Map_ContinueSprites_
                dc.w    SKContinueSprite_SonicWaitSecondPieces-Map_ContinueSprites_
                dc.w    SKContinueSprite_KnucklesWaitMap1-Map_ContinueSprites_
                dc.w    SKContinueSprite_RetainedMap2-Map_ContinueSprites_
                dc.w    SKContinueSprite_KnucklesWaitMap3-Map_ContinueSprites_
                dc.w    SKContinueSprite_TailsWaitFirstPieces-Map_ContinueSprites_
                dc.w    SKContinueSprite_TailsWaitSecondPieces-Map_ContinueSprites_
                dc.w    SKContinueSprite_PairedDecorMap-Map_ContinueSprites_
SKContinueSprite_SonicWaitFirstPieces:  dc.w    3
                dc.b    $EC,  $A,   0,   0, $FF, $F4
                dc.b    4,   5,   0,   9, $FF, $F4
                dc.b    4,   1,   0,  $D,   0,   4
SKContinueSprite_SonicWaitSecondPieces: dc.w    3
                dc.b    $EC,  $A,   0,   0, $FF, $F4
                dc.b    4,   5,   0,  $F, $FF, $F4
                dc.b    4,   1,   0,  $D,   0,   4
SKContinueSprite_KnucklesWaitMap1:  dc.w    4
                dc.b    $FE,   8,   0, $13, $FF, $F4
                dc.b    6,   5,   0, $16, $FF, $EC
                dc.b    6,   5,   0, $1A, $FF, $FC
                dc.b    6,   1,   0, $1E,   0,  $C
SKContinueSprite_RetainedMap2:  dc.w    4
                dc.b    $FE,   8,   0, $13, $FF, $F4
                dc.b    6,   5,   0, $16, $FF, $EC
                dc.b    6,   5,   0, $20, $FF, $FC
                dc.b    6,   1,   0, $1E,   0,  $C
SKContinueSprite_KnucklesWaitMap3:  dc.w    4
                dc.b    $FE,   8,   0, $13, $FF, $F4
                dc.b    6,   5,   0, $16, $FF, $EC
                dc.b    6,   5,   0, $24, $FF, $FC
                dc.b    6,   1,   0, $1E,   0,  $C
SKContinueSprite_TailsWaitFirstPieces:  dc.w    2
                dc.b    $EC,   9,   0, $28, $FF, $F0
                dc.b    $FC,  $E,   0, $2E, $FF, $F0
SKContinueSprite_TailsWaitSecondPieces: dc.w    3
                dc.b    $EC,   0,   0, $3A,   0,   0
                dc.b    $F4,   9,   0, $3B, $FF, $F0
                dc.b    4,  $D,   0, $41, $FF, $F0
SKContinueSprite_PairedDecorMap:    dc.w    2
                dc.b    $FC,   5,   0, $49, $FF, $E8
                dc.b    $FC,   5,   0, $49,   0,   8
