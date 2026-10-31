; Owner: objects/zones/fbz/sk
; Responsibility: Flying Battery exit hall actor, indexed attribute records and private mapping
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZExitHall:
                move.l  #Sprite_OnScreen_Test,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                movea.l off_86D12(pc,d0.w),a1
                move.l  #Map_FBZExitHall,mappings(a0)
                jmp     SetUp_ObjAttributes2(pc)
; ---------------------------------------------------------------------------
off_86D12:
                dc.l    word_86D1A
                dc.l    word_86D22
word_86D1A:
                dc.w    make_art_tile(ArtTile_FBZExitDoor,2,0)
                dc.w    0
                dc.b    8, $20,   0,   0
word_86D22:
                dc.w    make_art_tile(ArtTile_FBZExitHall,2,0)
                dc.w    $280
                dc.b    8, $18,   1,   0
Map_FBZExitHall:
                include "src/objects/shared/zones/fbz/mappings/exit_hall.s"
; End of function Obj_FBZExitHall
