; Owner: objects/zones/fbz/sk
; Responsibility: Wall missile initialization, flight, player collision and destruction
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZWallMissile:
                move.l  #Map_FBZWallMissile,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZOutdoors+$46,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.w  #$280,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                move.w  d0,$2E(a0)
                move.w  d0,$30(a0)
                move.l  #loc_3C828,(a0)

loc_3C828:
                tst.b   render_flags(a0)
                bpl.w   loc_3C8B0
                subq.w  #1,$2E(a0)
                bpl.s   loc_3C8B0
                move.w  $30(a0),$2E(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_3C89C
                move.l  #loc_3C8D4,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  #make_art_tile(ArtTile_FBZOutdoors+$46,1,0),art_tile(a1)
                move.w  #$300,priority(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #4,height_pixels(a1)
                move.b  #$9B,collision_flags(a1)
                move.w  #$400,x_vel(a1)
                btst    #0,status(a0)
                bne.s   loc_3C894
                neg.w   x_vel(a1)

loc_3C894:
                moveq   #signextendB(sfx_LevelProjectile),d0
                jsr     (Play_SFX).l

loc_3C89C:
                move.l  #loc_3C8B6,(a0)
                move.b  #7,mapping_frame(a0)
                move.b  #$1F,anim_frame_timer(a0)
                bra.s   loc_3C8B6
; ---------------------------------------------------------------------------

loc_3C8B0:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_3C8B6:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_3C8CE
                move.b  #7,anim_frame_timer(a0)
                subq.b  #1,mapping_frame(a0)
                bne.s   loc_3C8CE
                move.l  #loc_3C828,(a0)

loc_3C8CE:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_3C8D4:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                bne.s   loc_3C8E8
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

loc_3C8E8:
                tst.b   render_flags(a0)
                bpl.s   loc_3C900
                jsr     (MoveSprite2).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_3C900:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_FBZWallMissile:
                include "src/objects/shared/zones/fbz/mappings/wall_missile.s"
; End of function Obj_FBZWallMissile
