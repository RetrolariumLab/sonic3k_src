; Owner: objects/bonus/pachinko/sk
; Responsibility: Pachinko platform placement, movement and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Pachinko_Platform:
                move.l  #Map_PachinkoPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_PachinkoMain+$8B,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.l  #PachinkoPlatform_CollideTopAndCull,(a0)

PachinkoPlatform_CollideTopAndCull:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (PachinkoTriangle_DrawWithinCoarseY).l
; ---------------------------------------------------------------------------
Map_PachinkoPlatform:
                include "src/objects/shared/zones/pachinko/mappings/platform.s"
; End of function Obj_Pachinko_Platform
