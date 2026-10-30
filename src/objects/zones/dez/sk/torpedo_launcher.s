; Owner: objects/zones/dez/sk
; Responsibility: Torpedo launcher activation, projectile creation and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZTorpedoLauncher:
                move.l  #Map_TorpedoLauncher,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZMisc+$26,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #8,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                move.w  d0,$2E(a0)
                move.w  d0,$30(a0)
                move.l  #loc_471D6,(a0)

loc_471D6:
                tst.b   render_flags(a0)
                bpl.w   loc_47266
                subq.w  #1,$2E(a0)
                bpl.w   loc_47266
                move.w  $30(a0),$2E(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_47252
                move.l  #loc_4728A,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  #make_art_tile(ArtTile_DEZMisc+$26,1,0),art_tile(a1)
                move.w  #$300,priority(a1)
                move.b  #8,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.b  #$9B,collision_flags(a1)
                move.b  #9,mapping_frame(a1)
                move.w  #$400,x_vel(a1)
                btst    #0,status(a0)
                bne.s   loc_4724A
                neg.w   x_vel(a1)

loc_4724A:
                moveq   #signextendB(sfx_ChainTension),d0
                jsr     (Play_SFX).l

loc_47252:
                move.l  #loc_4726C,(a0)
                move.b  #8,mapping_frame(a0)
                move.b  #$1F,anim_frame_timer(a0)
                bra.s   loc_4726C
; ---------------------------------------------------------------------------

loc_47266:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_4726C:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_47284
                move.b  #7,anim_frame_timer(a0)
                subq.b  #1,mapping_frame(a0)
                bne.s   loc_47284
                move.l  #loc_471D6,(a0)

loc_47284:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_4728A:
                tst.b   render_flags(a0)
                bpl.s   loc_472A2
                jsr     (MoveSprite2).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_472A2:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_TorpedoLauncher:
                include "src/objects/shared/zones/dez/map_torpedo_launcher.s"
; End of function Obj_DEZTorpedoLauncher
