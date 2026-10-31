; Owner: objects/zones/mgz/sk
; Responsibility: Marble Garden head trigger activation, coordinated motion and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_MGZHeadTrigger:
                move.l  #Map_MGZHeadTrigger,mappings(a0)
                move.w  #make_art_tile(ArtTile_MGZMisc2,1,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$38,height_pixels(a0)
                move.b  #2,mapping_frame(a0)
                move.b  #$17,collision_flags(a0)
                move.b  #3,collision_property(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #6,(a2)+
                btst    #0,status(a0)
                bne.s   loc_34364
                move.w  #$C0,$30(a0)

loc_34364:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                beq.s   loc_34388
                move.b  #1,$34(a0)
                move.b  #0,mapping_frame(a0)
                move.b  #0,collision_flags(a0)

loc_34388:
                move.l  #loc_3438E,(a0)

loc_3438E:
                tst.b   $34(a0)
                bne.w   loc_34512
                move.w  (Player_1+x_pos).w,d0
                sub.w   x_pos(a0),d0
                add.w   $30(a0),d0
                cmpi.w  #$C0,d0
                bhs.s   loc_343C6
                move.w  (Player_1+y_pos).w,d0
                sub.w   y_pos(a0),d0
                addi.w  #$80,d0
                cmpi.w  #$C0,d0
                bhs.s   loc_343C6
                tst.b   anim(a0)
                bne.s   loc_343C6
                move.w  #1<<8,anim(a0)                  ; and prev_anim

loc_343C6:
                tst.b   collision_flags(a0)
                bne.w   loc_3447C
                tst.w   $32(a0)
                beq.s   loc_343E6
                subq.w  #1,$32(a0)
                bne.w   loc_3447C
                move.b  #$17,collision_flags(a0)
                bra.w   loc_3447C
; ---------------------------------------------------------------------------

loc_343E6:
                move.w  #60,$32(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_34474
                move.l  #loc_34536,(a1)
                tst.b   collision_property(a0)
                bne.s   loc_34432
                move.l  #Obj_Explosion,(a1)
                move.w  #make_art_tile($000,0,1),art_tile(a1)
                move.b  #2,routine(a1)
                move.b  #1,$34(a0)
                move.b  #0,mapping_frame(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                move.b  #1,(a3,d0.w)

loc_34432:
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                andi.b  #$BF,render_flags(a1)
                move.b  status(a0),status(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  #$200,priority(a1)
                move.b  #8,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.b  #2,anim(a1)

loc_34474:
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_3447C:
                lea     (Ani_MGZHeadTrigger).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)
                beq.w   loc_34512
                clr.b   routine(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_34512
                move.l  #loc_34518,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$10,x_pos(a1)
                addi.w  #$20,y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                andi.b  #$BF,render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                andi.w  #drawing_mask,art_tile(a1)
                move.w  #$300,priority(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #4,height_pixels(a1)
                move.b  #$9B,collision_flags(a1)
                move.w  #-$400,x_vel(a1)
                btst    #0,status(a0)
                beq.s   loc_3450A
                neg.w   x_vel(a1)
                subi.w  #$20,x_pos(a1)

loc_3450A:
                moveq   #signextendB(sfx_LevelProjectile),d0
                jsr     (Play_SFX).l

loc_34512:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

loc_34518:
                tst.b   render_flags(a0)
                bpl.s   loc_34530
                jsr     (MoveSprite2).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_34530:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_34536:
                lea     (Ani_MGZHeadTrigger).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Ani_MGZHeadTrigger:
                include "src/objects/shared/zones/mgz/animations/head_trigger.s"
; End of function Obj_MGZHeadTrigger
