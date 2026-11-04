; Owner: objects/zones/fbz/sk
; Responsibility: Mine movement, contact, explosion state and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZMine:
                move.l  #Map_FBZMine,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$91,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.l  #SKFBZMine_CheckPlayersAndDraw,(a0)

SKFBZMine_CheckPlayersAndDraw:
                lea     (Player_1).w,a1
                bsr.s   ArmFbzMineNearPlayer
                lea     (Player_2).w,a1
                bsr.s   ArmFbzMineNearPlayer
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

ArmFbzMineNearPlayer:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   SKFBZMine_ArmingReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$18,d0
                cmpi.w  #$20,d0
                bhs.s   SKFBZMine_ArmingReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKFBZMine_ArmingReturn
                move.w  #$1E,$30(a0)
                move.l  #SKFBZMine_FlashAndArmContact,(a0)

SKFBZMine_ArmingReturn:
                rts
; End of function ArmFbzMineNearPlayer

; ---------------------------------------------------------------------------

; Enable harmful contact for one update before switching to the explosion handler
SKFBZMine_FlashAndArmContact:
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)
                subq.w  #1,$30(a0)
                bpl.s   SKFBZMine_DrawAndCull
                move.l  #SKFBZMine_BecomeExplosion,(a0)
                move.b  #$8B,collision_flags(a0)
                jsr     (Add_SpriteToCollisionResponseList).l

SKFBZMine_DrawAndCull:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKFBZMine_BecomeExplosion:
                move.l  #Obj_Explosion,(a0)
                move.b  #6,routine(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)
                moveq   #signextendB(sfx_Explode),d0
                jsr     (Play_SFX).l
                jmp     (Obj_Explosion).l
; ---------------------------------------------------------------------------
Map_FBZMine:
                include "src/objects/shared/zones/fbz/mappings/mine.s"
