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
                move.l  #SKLRZFireball_TickShotTimer,(a0)

SKLRZFireball_TickShotTimer:
                subq.w  #1,$2E(a0)
                bpl.s   SKLRZFireball_DrawLauncher
                move.w  $30(a0),$2E(a0)
                tst.b   render_flags(a0)
                bpl.s   SKLRZFireball_DrawLauncher
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKLRZFireball_DrawLauncher
                move.l  #SKLRZFireball_TickFireballFrame,(a1)
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
                beq.s   SKLRZFireball_PlayLaunchSound
                neg.w   x_vel(a1)
                subi.w  #2*8,x_pos(a1)

SKLRZFireball_PlayLaunchSound:
                moveq   #signextendB(sfx_LevelProjectile),d0
                jsr     (Play_SFX).l

SKLRZFireball_DrawLauncher:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKLRZFireball_TickFireballFrame:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                bne.s   SKLRZFireball_MoveVisibleFireball
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

; Use the previous render flag to decide whether to move and queue collision
SKLRZFireball_MoveVisibleFireball:
                tst.b   render_flags(a0)
                bpl.s   SKLRZFireball_DeleteFireball
                jsr     (MoveSprite2).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLRZFireball_DeleteFireball:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_LRZFireballLauncher:
                include "src/objects/shared/zones/lrz/mappings/fireball_launcher.s"
; End of function Obj_LRZFireballLauncher
