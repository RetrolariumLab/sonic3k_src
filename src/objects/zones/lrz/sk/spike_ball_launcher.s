; Owner: objects/zones/lrz/sk
; Responsibility: Spike-ball launcher timing, projectile creation and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZSpikeBallLauncher:
                move.l  #Map_LRZSpikeBallLauncher,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_448A2
                move.l  #loc_44954,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #8,y_pos(a1)
                move.w  y_pos(a1),$46(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  #$280,priority(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.b  #$9A,collision_flags(a1)
                move.w  a1,$3C(a0)

loc_448A2:
                move.l  #loc_448A8,(a0)

loc_448A8:
                lea     (Ani_LRZSpikeBallLauncher).l,a1
                jsr     (Animate_SpriteIrregularDelay).l
                tst.b   routine(a0)
                beq.s   loc_448FA
                clr.b   routine(a0)
                tst.b   anim(a0)
                bne.s   loc_448D4
                tst.b   render_flags(a0)
                bpl.s   loc_448FA
                moveq   #signextendB(sfx_Charging),d0
                jsr     (Play_SFX).l
                bra.s   loc_448FA
; ---------------------------------------------------------------------------

loc_448D4:
                tst.b   render_flags(a0)
                bpl.s   loc_448E2
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_448E2:
                movea.w $3C(a0),a1
                move.l  #loc_44916,(a1)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #4,d0
                neg.w   d0
                move.w  d0,y_vel(a1)

loc_448FA:
                move.w  #$1B,d1
                move.w  #4,d2
                move.w  #5,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_44916:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_44934
                move.b  #2,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   loc_44934
                move.b  #0,mapping_frame(a0)

loc_44934:
                jsr     (MoveSprite).l
                move.w  $46(a0),d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_44954
                move.w  d0,y_pos(a0)
                move.b  #0,mapping_frame(a0)
                move.l  #loc_44954,(a0)

loc_44954:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------
Ani_LRZSpikeBallLauncher:
                include "src/objects/shared/zones/lrz/anim_spike_ball_launcher.s"
Map_LRZSpikeBallLauncher:
                include "src/objects/shared/zones/lrz/map_spike_ball_launcher.s"
; End of function Obj_LRZSpikeBallLauncher
