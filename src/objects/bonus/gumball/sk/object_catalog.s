; Owner: objects/bonus/gumball/sk
; Responsibility: Gumball object attributes, construction records, raw animations and mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
SKGumball_DecorationAttributes:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,0,0)
                dc.w    $200
                dc.b    $10, $20,   0,   0
SKGumball_PlatformAttributeDescriptor:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    $40, $10, $13,   0
SKGumball_TriangleBumperAttributes:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    4, $10, $12,   0
ObjDat_GumballMachine:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    $18, $18,   5,   0
SKGumball_MechanismBodyAttributes:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    $14, $14,   2,   0
SKGumball_PlatformSpringAttributes:
                dc.l    Map_Spring
                dc.w    make_art_tile(ArtTile_SpikesSprings+$10,0,0)
                dc.w    $100
                dc.b    $10, $10,   0,   0
SKGumball_PlatformDebrisAttributes:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    8,   8, $15,   0
SKGumball_RewardItemAttributes:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,0,1)
                dc.w    $100
                dc.b    8,   8,   8,   0
SKGumball_SpriteMaskAttributes:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile($000,0,0)
                dc.w    $180
                dc.b    4, $10, $17,   0
SKGumball_MachineChildRecords:
                dc.w    7-1
                dc.l    SKGumball_InitPlatformAndFourSprings
                dc.b    0,   0
                dc.l    SKGumball_InitMechanismBody
                dc.b    0, $24
                dc.l    SKGumball_InitExitMonitor
                dc.b    0,   0
                dc.l    SKGumball_InitAttachedDecoration
                dc.b    -$38,-$2C
                dc.l    SKGumball_InitAttachedDecoration
                dc.b    0,-$2C
                dc.l    SKGumball_InitAttachedDecoration
                dc.b    $38,-$2C
                dc.l    SKGumball_InitAttachedDecoration
                dc.b    0,-$28
SKGumball_PlatformSpringChildRecords:
                dc.w    4-1
                dc.l    SKGumball_InitAndCheckSpringP1
                dc.b    -$30,-$18
                dc.l    SKGumball_InitAndCheckSpringP1
                dc.b    -$10,-$18
                dc.l    SKGumball_InitAndCheckSpringP1
                dc.b    $10,-$18
                dc.l    SKGumball_InitAndCheckSpringP1
                dc.b    $30,-$18
SKGumball_PlatformDebrisChildRecord:
                dc.w    $10-1
                dc.l    SKGumball_InitDebrisAndSetDelay
SKGumball_BodyRewardChildRecord:
                dc.w    1-1
                dc.l    SKGumball_InitWeightedRewardItem
SKGumball_SpriteMaskChildRecord:
                dc.w    1-1
                dc.l    SKGumball_InitializeDecorationMaskActor
SKGumball_MachineActivationAnim:
                dc.b    3,   5,   6,   7, $14,   5, $F4
                dc.b    $7F,   5,   5, $FC
SKGumball_BodyCycleCallbackAnim:
                dc.b    2,   3,   3,   3,   4,  $F,   3,   3,   2,   3, $F4
SKGumball_LifeRewardSingleDelayRawStream:
                dc.b    $7F,   8,   8, $FC
SKGumball_PlatformRefillAnim:
                dc.b    $7F,   9,   9, $FC
SKGumball_RingRewardSingleDelayRawStream:
                dc.b    $7F,  $A,  $A, $FC
SKGumball_NoopRewardSingleDelayRawStream:
                dc.b    $7F,  $B,  $B, $FC
SKGumball_PersistentRoundRewardAnim:
                dc.b    $7F,  $C,  $C, $FC
SKGumball_FireShieldRewardAnim:
                dc.b    $7F,  $D,  $D, $FC
SKGumball_BubbleShieldRewardAnim:
                dc.b    $7F,  $E,  $E, $FC
SKGumball_LightningShieldRewardAnim:
                dc.b    $7F,  $F,  $F, $FC
SKGumball_SavedStatusBit7RewardAnim:
                dc.b    1, $10, $11, $FC
Map_GumballBonus:
                include "src/objects/shared/zones/gumball/mappings/bonus.s"
