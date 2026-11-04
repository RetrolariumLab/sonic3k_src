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
                move.l  #SKFBZWallMissile_TickVisibleFireDelay,(a0)

SKFBZWallMissile_TickVisibleFireDelay:
                tst.b   render_flags(a0)
                bpl.w   SKFBZWallMissile_DrawIdleLauncher
                subq.w  #1,$2E(a0)
                bpl.s   SKFBZWallMissile_DrawIdleLauncher
                move.w  $30(a0),$2E(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKFBZWallMissile_BeginLauncherRecoil
                move.l  #SKFBZWallMissile_AnimateMissile,(a1)
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
                bne.s   SKFBZWallMissile_PlayFireSound
                neg.w   x_vel(a1)

SKFBZWallMissile_PlayFireSound:
                moveq   #signextendB(sfx_LevelProjectile),d0
                jsr     (Play_SFX).l

SKFBZWallMissile_BeginLauncherRecoil:
                move.l  #SKFBZWallMissile_StepLauncherRecoil,(a0)
                move.b  #7,mapping_frame(a0)
                move.b  #$1F,anim_frame_timer(a0)
                bra.s   SKFBZWallMissile_StepLauncherRecoil
; ---------------------------------------------------------------------------

SKFBZWallMissile_DrawIdleLauncher:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKFBZWallMissile_StepLauncherRecoil:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKFBZWallMissile_DrawRecoilFrame
                move.b  #7,anim_frame_timer(a0)
                subq.b  #1,mapping_frame(a0)
                bne.s   SKFBZWallMissile_DrawRecoilFrame
                move.l  #SKFBZWallMissile_TickVisibleFireDelay,(a0)

SKFBZWallMissile_DrawRecoilFrame:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKFBZWallMissile_AnimateMissile:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                bne.s   SKFBZWallMissile_MoveVisibleMissile
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

SKFBZWallMissile_MoveVisibleMissile:
                tst.b   render_flags(a0)
                bpl.s   SKFBZWallMissile_DeleteHiddenMissile
                jsr     (MoveSprite2).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKFBZWallMissile_DeleteHiddenMissile:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_FBZWallMissile:
                include "src/objects/shared/zones/fbz/mappings/wall_missile.s"
; End of function Obj_FBZWallMissile
