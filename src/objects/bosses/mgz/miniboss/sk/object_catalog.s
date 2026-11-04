; Owner: objects/bosses/mgz/miniboss/sk
; Responsibility: Marble Garden miniboss object or child construction, animation, spire mappings and graphics load records
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_Tunnelbot:
                dc.l    Map_MGZMiniboss
                dc.w    make_art_tile(ArtTile_MGZMiniboss,1,0)
                dc.w    $280
                dc.b    $28,  $C,   0, $10
MGZMiniSK_TremorDebrisAttributes:
                dc.l    Map_MGZEndBossDebris
                dc.w    make_art_tile(ArtTile_MGZMiniBossDebris,2,0)
                dc.w    $200
                dc.b    $20, $20,   0,   0
MGZMiniSK_TremorSpireAttributes:
                dc.l    Map_MGZMinibossSpires
                dc.w    make_art_tile(ArtTile_MGZSpire,2,0)
                dc.w    $200
                dc.b    4, $10,   0, $84
MGZMiniSK_DefeatFragmentAttributes:
                dc.w    $280
                dc.b    $C,  $C,   0,   0
MGZMinibossSK_MovingSpire_FullAttributes:
                dc.l    Map_MGZMovingSpikePlatform
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $18, $30,   0,   0
MGZMiniSK_SideCollisionChildren:
                dc.w    2-1
                dc.l    MGZMiniSK_InitCollisionChild
                dc.b    -$1C,-$16
                dc.l    MGZMiniSK_InitCollisionChild
                dc.b    $1C,-$16
MGZMiniSK_TremorDebrisChild:
                dc.w    1-1
                dc.l    MGZMiniSK_InitRandomTremorDebris
                dc.b    0,   0
MGZMiniSK_DefeatFragmentChildren:
                dc.w    5-1
                dc.l    MGZMiniSK_InitDefeatFragment
                dc.b    0,   0
                dc.l    MGZMiniSK_InitDefeatFragment
                dc.b    -$1C,   0
                dc.l    MGZMiniSK_InitDefeatFragment
                dc.b    $1C,   0
                dc.l    MGZMiniSK_InitDefeatFragment
                dc.b    -$1C,-$16
                dc.l    MGZMiniSK_InitDefeatFragment
                dc.b    $1C,-$16
MGZMiniSK_MovingSpireChild:
                dc.w    1-1
                dc.l    MGZMiniSK_InitMovingSpireAtCamera
                dc.b    0,   0
                dc.b    0,   5
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,   5
                dc.b    $FC
MGZMiniSK_DrillAccelerateAnim:
                dc.b    5,   4,   0,   1,   2, $FC
MGZMiniSK_DrillSpinAnim:
                dc.b    0,   0,   1,   2, $FC
                even
Map_MGZMinibossSpires:
                include "src/objects/shared/zones/mgz/miniboss/mappings/spires.s"
PLC_MGZMiniboss:    plrlistheader
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_MGZSpire, ArtNem_MGZSpire
PLC_MGZMiniboss_End:
