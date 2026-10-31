; Owner: objects/zones/lrz/sk
; Responsibility: Shooting trigger activation, projectile behavior and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZShootingTrigger:
                move.l  #Map_LRZShootingTrigger,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZMisc,3,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$C6,collision_flags(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #$F0,d0
                lsr.w   #2,d0
                move.w  d0,$30(a0)
                move.l  #loc_42E00,(a0)

loc_42E00:
                subq.w  #1,$2E(a0)
                bpl.s   loc_42E84
                move.w  $30(a0),$2E(a0)
                tst.b   render_flags(a0)
                bpl.s   loc_42E84
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_42E84
                move.l  #loc_42EE8,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  #make_art_tile(ArtTile_LRZMisc,0,0),art_tile(a1)
                move.w  #$300,priority(a1)
                move.b  #4,width_pixels(a1)
                move.b  #4,height_pixels(a1)
                move.b  #$98,collision_flags(a1)
                bset    #3,$2B(a1)
                move.b  #1,mapping_frame(a1)
                move.w  #$200,x_vel(a1)
                move.w  #$200,y_vel(a1)
                btst    #0,status(a0)
                beq.s   loc_42E7C
                neg.w   x_vel(a1)

loc_42E7C:
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l

loc_42E84:
                move.b  collision_property(a0),d0
                beq.w   loc_42EBA
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d3
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   loc_42EAC
                bsr.s   sub_42EC0

loc_42EAC:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   loc_42EBA
                bsr.s   sub_42EC0

loc_42EBA:
                jmp     (Sprite_CheckDeleteTouch3).l

; =============== S U B R O U T I N E =======================================

sub_42EC0:
                cmpi.b  #2,anim(a1)
                bne.s   locret_42EE6
                neg.w   x_vel(a1)
                neg.w   y_vel(a1)
                bset    d3,(a3)
                move.l  #Obj_Explosion,(a0)
                move.b  #2,routine(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)

locret_42EE6:
                rts
; End of function sub_42EC0

; ---------------------------------------------------------------------------

loc_42EE8:
                tst.b   render_flags(a0)
                bpl.s   loc_42F00
                jsr     (MoveSprite2).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_42F00:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_LRZShootingTrigger:
                include "src/objects/shared/zones/lrz/mappings/shooting_trigger.s"
