; Owner: objects/bosses/mgz/miniboss/s3
; Responsibility: Marble Garden miniboss object or child construction, animation, spire mappings and graphics load records
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_Tunnelbot:
                dc.l    Map_MGZMiniboss
                dc.w    make_art_tile(ArtTile_MGZMiniboss,1,0)
                dc.w    $280
                dc.b    $28,  $C,   0, $10
MGZMiniS3_TremorDebrisAttributes:
                dc.l    Map_MGZEndBossDebris
                dc.w    make_art_tile(ArtTile_MGZMiniBossDebris,2,0)
                dc.w    $200
                dc.b    $20, $20,   0,   0
MGZMiniS3_TremorSpireAttributes:
                dc.l    Map_MGZMinibossSpires
                dc.w    make_art_tile(ArtTile_MGZSpire,2,0)
                dc.w    $200
                dc.b    4, $10,   0, $84
MGZMiniS3_DefeatFragmentAttributes:
                dc.w    $280
                dc.b    $C,  $C,   0,   0
MGZMinibossS3_MovingSpire_FullAttributes:
                dc.l    Map_MGZMovingSpikePlatform
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $18, $30,   0,   0
MGZMiniS3_SideCollisionChildren:
                dc.w    2-1
                dc.l    MGZMiniS3_InitCollisionChild
                dc.b    -$1C,-$16
                dc.l    MGZMiniS3_InitCollisionChild
                dc.b    $1C,-$16
MGZMiniS3_TremorDebrisChild:
                dc.w    1-1
                dc.l    MGZMiniS3_InitRandomTremorDebris
                dc.b    0,   0
MGZMiniS3_DefeatFragmentChildren:
                dc.w    5-1
                dc.l    MGZMiniS3_InitDefeatFragment
                dc.b    0,   0
                dc.l    MGZMiniS3_InitDefeatFragment
                dc.b    -$1C,   0
                dc.l    MGZMiniS3_InitDefeatFragment
                dc.b    $1C,   0
                dc.l    MGZMiniS3_InitDefeatFragment
                dc.b    -$1C,-$16
                dc.l    MGZMiniS3_InitDefeatFragment
                dc.b    $1C,-$16
MGZMiniS3_MovingSpireChild:
                dc.w    1-1
                dc.l    MGZMiniS3_InitMovingSpireAtCamera
                dc.b    0,   0

; unused
                dc.b    0,   5
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,   5
                dc.b    $FC
MGZMiniS3_DrillAccelerateAnim:
                dc.b    5,   4,   0,   1,   2, $FC
MGZMiniS3_DrillSpinAnim:
                dc.b    0,   0,   1,   2, $FC
                even
Map_MGZMinibossSpires:
                include "src/objects/shared/zones/mgz/miniboss/mappings/spires.s"
PLC_MGZMiniboss:    plrlistheader
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_MGZSpire, ArtNem_MGZSpire
PLC_MGZMiniboss_End:
