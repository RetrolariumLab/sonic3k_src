; Owner: objects/zones/aiz/s3
; Responsibility: Static Angel Island tree and zipline peg sprite setup and their display-only updates
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZ1Tree:
                move.l  #Map_AIZ1Tree,mappings(a0)
                move.w  #$180,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #4,render_flags(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.l  #loc_1C3E2,(a0)

loc_1C3E2:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_AIZ1Tree:
                include "src/objects/shared/zones/aiz/act1/mappings/tree.s"
; End of function Obj_AIZ1Tree
; ---------------------------------------------------------------------------

Obj_AIZ1ZiplinePeg:
                move.l  #Map_AIZ1ZiplinePeg,mappings(a0)
                move.w  #$380,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #4,render_flags(a0)
                move.w  #make_art_tile(ArtTile_AIZSlideRope,2,0),art_tile(a0)
                move.l  #loc_1C424,(a0)

loc_1C424:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_AIZ1ZiplinePeg:
                include "src/objects/shared/zones/aiz/act1/mappings/zipline_peg.s"
; End of function Obj_AIZ1ZiplinePeg
