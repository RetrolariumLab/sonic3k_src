; Owner: objects/bosses/lbz/grabber_ship/sk
; Responsibility: Launch Base final boss object attributes, child construction, animation, mappings and palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_LBZFinalBoss2:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $280
                dc.b    $1C, $20,   5,   0
LBZBoss2SK_BodyPartAttributes:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,0)
                dc.w    $200
                dc.b    $28, $28,   0,   0
LBZBoss2SK_PrimaryArmAttributes:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,0)
                dc.w    $180
                dc.b    $20, $10,   2,   0
LBZBoss2SK_ArmSegmentAttributes:
                dc.w    $80
                dc.b    $14, $14,   4,   0
LBZBoss2SK_SecondaryArmAttributes:
                dc.w    $180
                dc.b    8,   8,   3,   0
LBZBoss2SK_CoverAttributes:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,0)
                dc.w    $300
                dc.b    $14,  $C,   1,   0
LBZBoss2SK_FlashVisualAttributes:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,0,0)
                dc.w    $300
                dc.b    $C,  $C,  $C,   0
LBZBoss2SK_BodyFragmentAttributes:
                dc.l    Map_LBZFinalBoss2
                dc.w    make_art_tile(ArtTile_LBZFinalBoss2,1,1)
                dc.w    $100
                dc.b    $10, $14,  $D,   0
LBZBoss2SK_DroppedRelayAttributes:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $300
                dc.b    $C, $10, $16,   0
LBZBoss2SK_DefeatUnderlayAttributes:
                dc.l    Map_LBZFinalBoss1
                dc.w    make_art_tile(ArtTile_LBZFinalBoss1,1,1)
                dc.w    $200
                dc.b    $10,   4, $15,   0
LBZBoss2SK_BodyPartChildren:
                dc.w    4-1
                dc.l    LBZBoss2SK_ArmDispatchAndDraw
                dc.b    $14, $24
                dc.l    LBZBoss2SK_InitBodyPartAndFollow
                dc.b    $C,-$14
                dc.l    LBZBoss2SK_InitCoverAndFollow
                dc.b    0,-$18
                dc.l    LBZBoss2SK_InitCollisionFlashVisual
                dc.b    $38,-$14
LBZBoss2SK_TouchProxyChild:
                dc.w    1-1
                dc.l    LBZBoss2SK_InitInvisibleTouchProxy
                dc.b    4,-$34
LBZBoss2SK_PrimaryArmChildren:
                dc.w    4-1
                dc.l    LBZBoss2SK_InitSegmentAndCacheBoss
                dc.b    -$2A,  -2
                dc.l    LBZBoss2SK_InitSegmentAndCacheBoss
                dc.b    -$4A,  -2
                dc.l    LBZBoss2SK_InitFollowerAndReparent
                dc.b    0,   0
                dc.l    LBZBoss2SK_CaptureProbeCacheBoss
                dc.b    -$40,  -2
LBZBoss2SK_DefeatFragmentChildren:
                dc.w    4
                dc.l    LBZBoss2SK_InitBodyFragment
                dc.b    -$C,-$2C
                dc.l    LBZBoss2SK_InitBodyFragment
                dc.b    $14,-$2C
                dc.l    LBZBoss2SK_InitBodyFragment
                dc.b    $2C,-$18
                dc.l    LBZBoss2SK_InitBodyFragment
                dc.b    -$C,  -4
                dc.l    LBZBoss2SK_InitBodyFragment
                dc.b    $14,  -4
LBZBoss2SK_DroppedRelayChild:
                dc.w    1-1
                dc.l    LBZBoss2SK_RelayDispatchAndDraw
                dc.b    0,   8
LBZBoss2SK_DefeatUnderlayChild:
                dc.w    1-1
                dc.l    LBZBoss2SK_InitDefeatUnderlay
                dc.b    0, $10
LBZBoss2SK_RelayExplosionControllerChild:
                dc.w    1-1
                dc.l    LBZBoss2SK_InitRandomExplosionTimer
LBZBoss2SK_ArmSegmentDefaultAnim:
                dc.b    9,   7,   4,   5,   6,   5,   4, $FC
LBZBoss2SK_ArmSegmentAlternateAnim:
                dc.b    9,  $B,   8,   9,  $A,   9,   8, $FC
LBZBoss2SK_UnusedSectionCallbackAnim:                   ; used in S3, unused in S3K
                dc.b    2,   4,   4,   5,   6, $F4
Pal_LBZFinalBoss2:
                binclude "data/Levels/LBZ/Palettes/Final Boss 2.bin"
                even
