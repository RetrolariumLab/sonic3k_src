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
                move.l  #loc_3C972,(a0)

loc_3C972:
                lea     (Player_1).w,a1
                bsr.s   sub_3C984
                lea     (Player_2).w,a1
                bsr.s   sub_3C984
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_3C984:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   locret_3C9BA
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$18,d0
                cmpi.w  #$20,d0
                bhs.s   locret_3C9BA
                tst.w   (Debug_placement_mode).w
                bne.s   locret_3C9BA
                move.w  #$1E,$30(a0)
                move.l  #loc_3C9BC,(a0)

locret_3C9BA:
                rts
; End of function sub_3C984

; ---------------------------------------------------------------------------

loc_3C9BC:
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)
                subq.w  #1,$30(a0)
                bpl.s   loc_3C9DE
                move.l  #loc_3C9E4,(a0)
                move.b  #$8B,collision_flags(a0)
                jsr     (Add_SpriteToCollisionResponseList).l

loc_3C9DE:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_3C9E4:
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
