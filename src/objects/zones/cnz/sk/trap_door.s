; Owner: objects/zones/cnz/sk
; Responsibility: Carnival Night trap-door opening, collision and animation state
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_CNZTrapDoor:
                move.l  #Map_CNZTrapDoor,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$9F,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.l  #loc_31CCA,(a0)

loc_31CCA:
                lea     (Player_1).w,a1
                bsr.s   sub_31CFA
                lea     (Player_2).w,a1
                bsr.s   sub_31CFA
                move.w  #$20,d1
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                lea     (Ani_CNZTrapDoor).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_31CFA:
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                addi.w  #$20,d0
                cmpi.w  #$40,d0
                bhs.s   locret_31D2C
                move.w  y_pos(a0),d0
                sub.w   y_pos(a1),d0
                addi.w  #$20,d0
                cmpi.w  #$20,d0
                bhs.s   locret_31D2C
                move.b  #1,anim(a0)
                moveq   #signextendB(sfx_TrapDoor),d0
                jsr     (Play_SFX).l

locret_31D2C:
                rts
; End of function sub_31CFA

; ---------------------------------------------------------------------------
Ani_CNZTrapDoor:
                include "src/objects/shared/zones/cnz/anim_trap_door.s"
