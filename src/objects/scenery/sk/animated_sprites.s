; Owner: objects/scenery/sk
; Responsibility: Animated scenery sprite initialization, animation state and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AnimatedStillSprite:
                move.l  #Map_AnimatedStillSprites,mappings(a0)
                ori.b   #4,render_flags(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  d0,anim(a0)
                add.w   d0,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                lea     SKAnimatedScenery_SubtypeAttributes(pc,d0.w),a1
                move.w  (a1)+,art_tile(a0)
                move.w  (a1)+,priority(a0)
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.l  #SKAnimatedScenery_AnimateAndCullOrDraw,(a0)

SKAnimatedScenery_AnimateAndCullOrDraw:
                lea     (Ani_AnimatedStillSprites).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
SKAnimatedScenery_SubtypeAttributes:
                dc.w    make_art_tile(ArtTile_AIZMisc2,3,0)
                dc.w    $300
                dc.b    8,  $C
                dc.w    make_art_tile(ArtTile_AIZMisc2,3,0)
                dc.w    $300
                dc.b    8,  $C
                dc.w    make_art_tile($0D3,2,1)
                dc.w    $200
                dc.b    $10,   4
                dc.w    make_art_tile(ArtTile_LRZ2Misc,1,0)
                dc.w    $300
                dc.b    $10,   4
                dc.w    make_art_tile(ArtTile_SOZMisc+$46,2,0)
                dc.w    $300
                dc.b    4,   4
                dc.w    make_art_tile(ArtTile_SOZMisc+$46,2,0)
                dc.w    $300
                dc.b    $14,   4
                dc.w    make_art_tile(ArtTile_SOZMisc+$46,2,0)
                dc.w    $300
                dc.b    $34,   4
                dc.w    make_art_tile(ArtTile_SOZMisc+$46,2,0)
                dc.w    $300
                dc.b    $54,   4
Ani_AnimatedStillSprites:
                include "src/objects/shared/world/still_sprites/animations/animated.s"
Map_AnimatedStillSprites:
                include "src/objects/shared/world/still_sprites/mappings/animated.s"
; End of function Obj_AnimatedStillSprite
