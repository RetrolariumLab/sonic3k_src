; Owner: objects/zones/dez/sk
; Responsibility: Lightning hazard timing, animation, player collision and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_DEZLightning:
                move.l  #Map_DEZLightning,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZMisc+$2C,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #8,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$9F,collision_flags(a0)

loc_478BE:
                tst.b   render_flags(a0)
                bpl.s   loc_478CC
                moveq   #signextendB(sfx_Lightning),d0
                jsr     (Play_SFX).l

loc_478CC:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$30(a0)
                move.w  #1,anim(a0)                     ; and prev_anim
                move.l  #loc_478E2,(a0)

loc_478E2:
                lea     (Ani_DEZLightning).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)
                beq.s   loc_47906
                move.b  #0,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.l  #loc_4791A,(a0)

loc_47906:
                cmpi.b  #3,mapping_frame(a0)
                bne.s   loc_47914
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

loc_47914:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_4791A:
                subq.w  #1,$30(a0)
                bmi.s   loc_478BE
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Ani_DEZLightning:
                include "src/objects/shared/zones/dez/anim_lightning.s"
Map_DEZLightning:
                include "src/objects/shared/zones/dez/map_lightning.s"
; End of function Obj_DEZLightning
