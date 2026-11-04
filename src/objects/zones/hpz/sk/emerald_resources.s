; Owner: objects/zones/hpz/sk
; Responsibility: Hidden Palace Master or Super Emerald object attributes, animation, palette and graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
ObjDat_HPZMasterEmerald:
                dc.l    Map_HPZEmeraldMisc
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,3,0)
                dc.w    $200
                dc.b    $20, $18,  $B,   0
HPZMaster_CompanionPartialAttributes:
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,2,0)
                dc.w    $180
                dc.b    $10, $10,  $C,   0
ObjDat_HPZSuperEmerald:
                dc.l    Map_HPZEmeraldMisc
                dc.w    make_art_tile($000,0,0)
                dc.w    $80
                dc.b    $18, $10, $1E,   0
HPZBeam_FullAttributes:
                dc.l    Map_HPZEmeraldMisc
                dc.w    make_art_tile(ArtTile_HPZEmeraldMisc,0,1)
                dc.w    0
                dc.b    $10, $80,   8,   0
HPZParticle_FullAttributes:
                dc.l    Map_HPZChaosEmeralds
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,1,1)
                dc.w    $180
                dc.b    4,   4,   0,   0
HPZMaster_PaletteCompanionSimpleChild:
                dc.w    1-1
                dc.l    HPZMaster_InitPaletteCompanion
HPZEntry_ConversionChild:
                dc.w    1-1
                dc.l    HPZConversion_InitRisingCoordinator
HPZConversion_ParticleChildren:
                dc.w    7-1
                dc.l    HPZParticle_InitializeAndEnterExpansion
HPZBeam_CompletionRawFrameStream:
                dc.b    0, $1D, $1F, $1D, $20, $1D, $21, $1D, $22, $1D, $23, $1D, $24, $1D, $F4
                even
Map_HPZEmeraldMisc:
                include "src/objects/shared/zones/hpz/mappings/emerald_misc_art.s"
Map_HPZChaosEmeralds:
                include "src/objects/shared/zones/hpz/mappings/chaos_emeralds.s"
HPZMaster_TwoColorLocalPaletteSequence:
                dc.l    HPZMaster_LocalPalettePairOffsets
                dc.w    2-1
; this data here seems completely broken
                dc.b    0,  $F
                dc.b    1,   9
                dc.b    2,   9
                dc.b    3,   7
                dc.b    4,   7
                dc.b    5,   5
                dc.b    6,   5
                dc.b    5,   5
                dc.b    4,   7
                dc.b    3,   7
                dc.b    2,   9
                dc.b    1,   9
                dc.b    $FF, $FC
HPZMaster_LocalPalettePairOffsets:
                dc.w    HPZMaster_LocalPalettePairZero-HPZMaster_LocalPalettePairOffsets
                dc.w    HPZMaster_LocalPalettePairOne-HPZMaster_LocalPalettePairOffsets
                dc.w    HPZMaster_LocalPalettePairTwo-HPZMaster_LocalPalettePairOffsets
                dc.w    HPZMaster_LocalPalettePairThree-HPZMaster_LocalPalettePairOffsets
                dc.w    HPZMaster_LocalPalettePairFour-HPZMaster_LocalPalettePairOffsets
                dc.w    HPZMaster_LocalPalettePairFive-HPZMaster_LocalPalettePairOffsets
                dc.w    HPZMaster_LocalPalettePairSix-HPZMaster_LocalPalettePairOffsets
HPZMaster_LocalPalettePairZero:
                dc.w    $6A0,   $660
HPZMaster_LocalPalettePairOne:
                dc.w    $8C0,   $680
HPZMaster_LocalPalettePairTwo:
                dc.w    $AC0,   $680
HPZMaster_LocalPalettePairThree:
                dc.w    $CE0,   $880
HPZMaster_LocalPalettePairFour:
                dc.w    $CE6,   $6A2
HPZMaster_LocalPalettePairFive:
                dc.w    $CE8,   $AC0
HPZMaster_LocalPalettePairSix:
                dc.w    $EEC,   $CE8
