; Owner: objects/zones/lrz/sk
; Responsibility: Fireball launcher timing, projectile creation and collision state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZFireballLauncher:
                move.l  #Map_LRZFireballLauncher,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZMisc,3,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #2,mapping_frame(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                move.w  d0,$30(a0)
                move.l  #loc_42BF6,(a0)

loc_42BF6:
                subq.w  #1,$2E(a0)
                bpl.s   loc_42C7A
                move.w  $30(a0),$2E(a0)
                tst.b   render_flags(a0)
                bpl.s   loc_42C7A
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_42C7A
                move.l  #loc_42C80,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #8,x_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  #make_art_tile(ArtTile_LRZMisc,0,0),art_tile(a1)
                move.w  #$300,priority(a1)
                move.b  #$C,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.b  #$9B,collision_flags(a1)
                bset    #4,shield_reaction(a1)
                move.w  #$200,x_vel(a1)
                btst    #0,status(a0)
                beq.s   loc_42C72
                neg.w   x_vel(a1)
                subi.w  #2*8,x_pos(a1)

loc_42C72:
                moveq   #signextendB(sfx_LevelProjectile),d0
                jsr     (Play_SFX).l

loc_42C7A:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_42C80:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                bne.s   loc_42C94
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

loc_42C94:
                tst.b   render_flags(a0)
                bpl.s   loc_42CAC
                jsr     (MoveSprite2).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_42CAC:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_LRZFireballLauncher:
                include "src/objects/shared/zones/lrz/map_fireball_launcher.s"
; End of function Obj_LRZFireballLauncher
