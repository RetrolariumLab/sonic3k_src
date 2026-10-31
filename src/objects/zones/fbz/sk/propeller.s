; Owner: objects/zones/fbz/sk
; Responsibility: Propeller initialization, animation and display
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZPropeller:
                move.l  #Map_FBZPropeller,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZOutdoors,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$68,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  #$280,priority(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                move.l  #loc_3C1EE,(a0)

loc_3C1EE:
                lea     sub2_mapframe(a0),a2
                addq.b  #1,(a2)
                andi.b  #3,(a2)
                moveq   #0,d0
                move.b  (a2),d0
                move.b  CollisionSizes_FBZPropeller(pc,d0.w),collision_flags(a0)
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------
CollisionSizes_FBZPropeller:
                dc.b    $B6,   0, $B6, $B7
                even
Map_FBZPropeller:
                include "src/objects/shared/zones/fbz/mappings/propeller.s"
; End of function Obj_FBZPropeller
