; Owner: game/blue_sphere/sk
; Responsibility: Blue Sphere title character sprites, private placement records, animation and copyright display
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
BlueSphereTitleCharacters_Positions:
                dc.w    $B8,  $100
                dc.w    $10C,   $F8
                dc.w    $130,   $F4
                dc.w    $178,   $E0
; ---------------------------------------------------------------------------

BlueSphereTitleCharacters_Initialize:
                lea     BlueSphereTitleCharacters_Positions(pc),a2
                movea.l a0,a1
                moveq   #4-1,d1

BlueSphereTitleCharacters_InitializeSlot:
                move.l  #Map_BlueSphereCharSprite,mappings(a1)
                move.w  #make_art_tile($0FE,1,0),art_tile(a1)
                move.w  (a2)+,x_pos(a1)
                move.w  (a2)+,y_pos(a1)
                tst.b   (Blue_spheres_menu_flag).w
                beq.s   BSFooter_SetSlotAnim
                tst.b   (Blue_spheres_mode).w
                beq.s   BSFooter_SetSlotAnim
                subi.w  #$10,y_pos(a1)

BSFooter_SetSlotAnim:
                move.w  #$180,priority(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.l  #BSFooter_UpdateSlotAnim,(a1)
                move.b  d1,anim(a1)
                move.w  d1,d0
                add.w   d0,d0
                lea     (Ani_BlueSphereCharSprite).l,a3
                adda.w  (a3,d0.w),a3
                move.b  (a3),mapping_frame(a1)
                lea     next_object(a1),a1
                dbf     d1,BlueSphereTitleCharacters_InitializeSlot

BSFooter_UpdateSlotAnim:
                tst.b   (Blue_spheres_mode).w
                beq.s   BlueSphereTitleCharacters_Draw
                lea     (Ani_BlueSphereCharSprite).l,a1
                jsr     (Animate_SpriteIrregularDelay).l

BlueSphereTitleCharacters_Draw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_BlueSphereCharSprite:
                include "src/game/blue_sphere/shared/animations/character_sprites.s"
; End of function BlueSphereTitleCharacters_Initialize
; ---------------------------------------------------------------------------

BlueSphereCopyright_Initialize:
                move.l  #Map_BlueSpheresCopyright,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc+$64,0,1),art_tile(a0)
                move.w  #$180,x_pos(a0)
                move.w  #$152,y_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #$2C,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.l  #BlueSphereCopyright_Draw,(a0)

BlueSphereCopyright_Draw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_BlueSpheresCopyright:
                include "src/game/blue_sphere/shared/mappings/copyright.s"
; End of function BlueSphereCopyright_Initialize
