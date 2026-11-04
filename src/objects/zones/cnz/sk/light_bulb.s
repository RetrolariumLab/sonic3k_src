; Owner: objects/zones/cnz/sk
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
                bne.s   SKCNZLightBulb_StartWaterPoll
                move.l  #SKCNZLightBulb_DrawAndCull,(a0)
                bra.s   SKCNZLightBulb_DrawAndCull
; ---------------------------------------------------------------------------

SKCNZLightBulb_StartWaterPoll:
                move.l  #SKCNZLightBulb_LatchFloodedFrame,(a0)

SKCNZLightBulb_LatchFloodedFrame:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   SKCNZLightBulb_DrawAndCull
                move.b  #1,mapping_frame(a0)
                move.l  #SKCNZLightBulb_DrawAndCull,(a0)

SKCNZLightBulb_DrawAndCull:
                jmp     (Sprite_OnScreen_Test).l
; End of function Obj_CNZLightBulb
