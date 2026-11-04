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
                move.l  #SKDEZTorpedo_TickVisibleLaunchDelay,(a0)

SKDEZTorpedo_TickVisibleLaunchDelay:
                tst.b   render_flags(a0)
                bpl.w   SKDEZTorpedo_DrawIdleLauncher
                subq.w  #1,$2E(a0)
                bpl.w   SKDEZTorpedo_DrawIdleLauncher
                move.w  $30(a0),$2E(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKDEZTorpedo_BeginRecoil
                move.l  #SKDEZTorpedo_MoveVisibleTorpedo,(a1)
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
                bne.s   SKDEZTorpedo_PlayLaunchSound
                neg.w   x_vel(a1)

SKDEZTorpedo_PlayLaunchSound:
                moveq   #signextendB(sfx_ChainTension),d0
                jsr     (Play_SFX).l

; The launcher recoils even if the projectile allocation failed
SKDEZTorpedo_BeginRecoil:
                move.l  #SKDEZTorpedo_TickRecoilFrames,(a0)
                move.b  #8,mapping_frame(a0)
                move.b  #$1F,anim_frame_timer(a0)
                bra.s   SKDEZTorpedo_TickRecoilFrames
; ---------------------------------------------------------------------------

SKDEZTorpedo_DrawIdleLauncher:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKDEZTorpedo_TickRecoilFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKDEZTorpedo_DrawRecoilingLauncher
                move.b  #7,anim_frame_timer(a0)
                subq.b  #1,mapping_frame(a0)
                bne.s   SKDEZTorpedo_DrawRecoilingLauncher
                move.l  #SKDEZTorpedo_TickVisibleLaunchDelay,(a0)

SKDEZTorpedo_DrawRecoilingLauncher:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKDEZTorpedo_MoveVisibleTorpedo:
                tst.b   render_flags(a0)
                bpl.s   SKDEZTorpedo_DeleteTorpedo
                jsr     (MoveSprite2).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKDEZTorpedo_DeleteTorpedo:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_TorpedoLauncher:
                include "src/objects/shared/zones/dez/mappings/torpedo_launcher.s"
; End of function Obj_DEZTorpedoLauncher
