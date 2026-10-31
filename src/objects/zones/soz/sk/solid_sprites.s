; Owner: objects/zones/soz/sk
; Responsibility: Solid sprite placement, collision and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZSolidSprites:
                move.l  #Map_SOZSolidSprites,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                tst.b   subtype(a0)
                beq.s   loc_41F7E
                move.b  #$20,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #loc_41FAC,(a0)
                bra.s   loc_41FAC
; ---------------------------------------------------------------------------

loc_41F7E:
                move.b  #$10,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.l  #loc_41F90,(a0)

loc_41F90:
                move.w  #$1B,d1
                move.w  #$18,d2
                move.w  #$19,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_41FAC:
                move.w  #$2B,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_SOZSolidSprites:
                include "src/objects/shared/zones/soz/mappings/solid_sprites.s"
; End of function Obj_SOZSolidSprites
