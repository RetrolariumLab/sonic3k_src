; Owner: objects/scenery/sk
; Responsibility: Static scenery sprite initialization, zone-specific art and mapping selection
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_StillSprite:
                move.l  #Map_StillSprites,mappings(a0)
                ori.b   #4,render_flags(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                lea     word_2B968(pc,d0.w),a1
                move.w  (a1)+,art_tile(a0)
                move.w  (a1)+,priority(a0)
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.l  #loc_2B962,(a0)

loc_2B962:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
word_2B968:
                dc.w    make_art_tile(ArtTile_AIZMisc2,2,0)  ; 0 AIZ2 Bridge Post
                dc.w    $300
                dc.b    $C,  $C
                dc.w    make_art_tile(ArtTile_AIZMisc2,2,0)  ; 1 AIZ2 Large Rope Twist Tie
                dc.w    $300
                dc.b    $10,   8
                dc.w    make_art_tile(ArtTile_AIZMisc2,2,0)  ; 2 AIZ2 Rope Twist tie
                dc.w    $300
                dc.b    8,   4
                dc.w    make_art_tile($001,2,0)         ; 3 AIZ2 Tie Top Sprite
                dc.w    $300
                dc.b    8,   8
                dc.w    make_art_tile($001,3,0)         ; 4 AIZ2 Waterfall sprite
                dc.w    $300
                dc.b    8, $20
                dc.w    make_art_tile(ArtTile_AIZMisc2,2,1)  ; 5 AIZ2 Bridge Post (Different Palette)
                dc.w    $300
                dc.b    $C,  $C
                dc.w    make_art_tile($001,2,1)         ; 6 128x128 HCZ Waterfall
                dc.w    0
                dc.b    $40, $40
                dc.w    make_art_tile($001,2,1)         ; 7 128x64 HCZ Waterfall
                dc.w    0
                dc.b    $40, $20
                dc.w    make_art_tile($001,2,0)         ; 8 128x32 HCZ Waterfall
                dc.w    $300
                dc.b    $40, $10
                dc.w    make_art_tile($001,2,1)         ; 9 Stagger Down HCZ Waterfall
                dc.w    0
                dc.b    $40, $40
                dc.w    make_art_tile($001,2,1)         ; A Stagger Up HCZ Waterfall
                dc.w    0
                dc.b    $40, $60
                dc.w    make_art_tile(ArtTile_MGZSigns,2,0)  ; B MGZ Signpost Left
                dc.w    $300
                dc.b    $10, $18
                dc.w    make_art_tile(ArtTile_MGZSigns,2,0)  ; C MGZ Signpost Right
                dc.w    $300
                dc.b    $10, $18
                dc.w    make_art_tile(ArtTile_MGZSigns,2,0)  ; D MGZ Signpost Up
                dc.w    $300
                dc.b    $10, $18
                dc.w    make_art_tile(ArtTile_MGZSigns,2,0)  ; E MGZ Signpost Down
                dc.w    $300
                dc.b    $10, $18
                dc.w    make_art_tile(ArtTile_HCZ2Slide+$C,2,1)  ; F HCZ2 Tube Bend 1
                dc.w    0
                dc.b    8, $30
                dc.w    make_art_tile(ArtTile_HCZ2Slide+$1D,2,1)  ; 10 HCZ2 Tube Bend 2
                dc.w    0
                dc.b    $30, $18
                dc.w    make_art_tile(ArtTile_HCZ2Slide+$3D,2,1)  ; 11 HCZ2 Tube Bend 3
                dc.w    0
                dc.b    $C, $10
                dc.w    make_art_tile(ArtTile_HCZ2Slide+$48,2,1)  ; 12 HCZ2 Tube Crossover
                dc.w    0
                dc.b    $20, $34
                dc.w    make_art_tile(ArtTile_HCZ2BlockPlat+$10,2,0)  ; 13 HCZ2 Bridge Post
                dc.w    $300
                dc.b    4, $10
                dc.w    make_art_tile(ArtTile_LBZMisc+$4A,2,0)  ; 14 LBZ Cup Elevator Pole Top
                dc.w    $300
                dc.b    8,   8
                dc.w    make_art_tile(ArtTile_LBZMisc+$70,1,0)  ; 15 LBZ Steel Girder Low Priority
                dc.w    $300
                dc.b    $10, $40
                dc.w    make_art_tile(ArtTile_LBZMisc+$70,1,0)  ; 16 LBZ Large Steel Girder
                dc.w    $300
                dc.b    $10, $80
                dc.w    make_art_tile(ArtTile_LBZMisc+$70,1,0)  ; 17 LBZ Steel Girder High Priority
                dc.w    $80
                dc.b    $10, $40
                dc.w    make_art_tile(ArtTile_MHZMisc+$10,2,1)  ; 18 MHZ Cliff Edge
                dc.w    $80
                dc.b    4, $10
                dc.w    make_art_tile(ArtTile_MHZMisc+$10,2,1)  ; 19 MHZ Cliff Edge 2
                dc.w    $80
                dc.b    4, $10
                dc.w    make_art_tile(ArtTile_MHZMisc+$10,2,1)  ; 1A MHZ Grass
                dc.w    $80
                dc.b    $10,   4
                dc.w    make_art_tile(ArtTile_MHZMisc+$C7,3,1)  ; 1B MHZ Wood Column Bottom
                dc.w    $80
                dc.b    $10,   8
                dc.w    make_art_tile(ArtTile_MHZMisc+$C7,3,1)  ; 1C MHZ Wood Column Top
                dc.w    $80
                dc.b    $10,   8
                dc.w    make_art_tile(ArtTile_MHZMisc+$D7,2,0)  ; 1D MHZ Parachute Vines
                dc.w    $200
                dc.b    $10,   8
                dc.w    make_art_tile(ArtTile_MHZMisc,0,0)  ; 1E Diagonal Spring Pedestal
                dc.w    $280
                dc.b    8,   8
                dc.w    make_art_tile(ArtTile_LRZMisc,2,1)  ; 1F LRZ Horizontal Gear Rail Small (Unused)
                dc.w    $180
                dc.b    $10,   4
                dc.w    make_art_tile(ArtTile_LRZMisc,2,1)  ; 20 LRZ Horizontal Gear Rail Medium (Unused)
                dc.w    $180
                dc.b    $20,   4
                dc.w    make_art_tile(ArtTile_LRZMisc,2,1)  ; 21 LRZ Horizontal Gear Rail Large (Unused)
                dc.w    $180
                dc.b    $30,   4
                dc.w    make_art_tile($0D3,2,1)         ; 22 LRZ Foreground Rock Ceiling
                dc.w    $80
                dc.b    $10, $10
                dc.w    make_art_tile(ArtTile_LRZMisc,1,1)  ; 23 LRZ Gear Rail Top
                dc.w    $180
                dc.b    4, $10
                dc.w    make_art_tile(ArtTile_LRZMisc,1,1)  ; 24 LRZ Gear Rail Small
                dc.w    $180
                dc.b    4, $20
                dc.w    make_art_tile(ArtTile_LRZMisc,1,1)  ; 25 LRZ Gear Rail Large
                dc.w    $180
                dc.b    4, $40
                dc.w    make_art_tile(ArtTile_LRZMisc,1,1)  ; 26 LRZ Gear Rail Bottom
                dc.w    $180
                dc.b    4, $10
                dc.w    make_art_tile(ArtTile_FBZMisc,2,0)  ; 27 FBZ Single Metal Hanger
                dc.w    $80
                dc.b    8, $14
                dc.w    make_art_tile(ArtTile_FBZMisc,2,0)  ; 28 FBZ Two Metal Hangers
                dc.w    $80
                dc.b    $18, $14
                dc.w    make_art_tile(ArtTile_FBZMisc,2,0)  ; 29 FBZ Three Metal Hangers
                dc.w    $80
                dc.b    $28, $14
                dc.w    make_art_tile(ArtTile_FBZMisc,2,0)  ; 2A FBZ Four Metal Hangers
                dc.w    $80
                dc.b    $38, $14
                dc.w    make_art_tile(ArtTile_FBZMisc+$CA,1,0)  ; 2B Unknown?
                dc.w    $300
                dc.b    4, $10
                dc.w    make_art_tile(ArtTile_FBZMisc2+$67,1,0)  ; 2C FBZ2 Spider Rail
                dc.w    0
                dc.b    $40,   4
                dc.w    make_art_tile(ArtTile_FBZMisc2+$67,1,0)  ; 2D FBZ2 Spider Rail Low Priority
                dc.w    $280
                dc.b    $40,   4
                dc.w    make_art_tile($001,2,1)         ; 2E SOZ Indoor Sloped Edge
                dc.w    $100
                dc.b    $10,   8
                dc.w    make_art_tile(ArtTile_SOZ2Extra,0,0)  ; 2F SOZ2 Sand Cork Holder
                dc.w    0
                dc.b    $10,   4
                dc.w    make_art_tile(ArtTile_DEZMisc+$B2,1,0)  ; 30 DEZ Horizontal Beam Platform Shooter
                dc.w    $280
                dc.b    8,  $C
                dc.w    make_art_tile(ArtTile_DEZMisc+$B2,1,0)  ; 31 DEZ Vertical Beam Platform Shooter
                dc.w    $280
                dc.b    $C,   8
                dc.w    make_art_tile(ArtTile_DEZMisc+$38,1,0)  ; 32 DEZ Light Tunnel Post
                dc.w    $80
                dc.b    $10, $24
Map_StillSprites:
                include "src/objects/shared/world/still_sprites/mappings/main.s"
; End of function Obj_StillSprite
