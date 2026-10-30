; Owner: objects/zones/lrz/sk
; Responsibility: Falling spike activation, gravity, collision and destruction
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZFallingSpike:
                move.l  #Map_LRZFallingSpike,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZMisc,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$C,y_radius(a0)
                move.w  #$280,priority(a0)
                move.b  #$82,collision_flags(a0)
                move.b  subtype(a0),$2F(a0)
                move.l  #loc_42898,(a0)

loc_42898:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bpl.s   loc_428A8
                neg.w   d0

loc_428A8:
                lea     (Player_2).w,a2
                move.w  x_pos(a0),d1
                sub.w   x_pos(a2),d1
                bpl.s   loc_428B8
                neg.w   d1

loc_428B8:
                cmp.w   d1,d0
                bls.s   loc_428BE
                move.w  d1,d0

loc_428BE:
                cmp.w   $2E(a0),d0
                bhs.s   loc_428D0
                tst.w   (Debug_placement_mode).w
                bne.s   loc_428D0
                move.l  #loc_428D6,(a0)

loc_428D0:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

loc_428D6:
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_428FE
                add.w   d1,y_pos(a0)
                move.b  #0,collision_flags(a0)
                move.l  #loc_42904,(a0)
                moveq   #signextendB(sfx_BossProjectile),d0
                jsr     (Play_SFX).l

loc_428FE:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

loc_42904:
                move.w  #$13,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_LRZFallingSpike:
                include "src/objects/shared/zones/lrz/map_falling_spike.s"
; End of function Obj_LRZFallingSpike
