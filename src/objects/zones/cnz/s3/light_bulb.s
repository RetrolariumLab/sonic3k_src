; Owner: objects/zones/cnz/s3
; Responsibility: Carnival Night light-bulb initialization and display state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZLightBulb:
                move.l  #Map_CNZLightBulb,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$B3,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                tst.b   (Water_flag).w
                bne.s   loc_30E30
                move.l  #loc_30E4C,(a0)
                bra.s   loc_30E4C
; ---------------------------------------------------------------------------

loc_30E30:
                move.l  #loc_30E36,(a0)

loc_30E36:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_30E4C
                move.b  #1,mapping_frame(a0)
                move.l  #loc_30E4C,(a0)

loc_30E4C:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_CNZLightBulb:
                include "src/objects/shared/zones/cnz/map_light_bulb.s"
; End of function Obj_CNZLightBulb
