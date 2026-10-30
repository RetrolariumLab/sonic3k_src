; Owner: objects/zones/dez/sk
; Responsibility: Retracting spring timing, extension and player launch response
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
word_4808A:
                dc.w    -$1000
                dc.w    -$A00
; ---------------------------------------------------------------------------

Obj_DEZRetractingSpring:
                move.l  #Map_DEZRetractingSpring,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZ2Extra,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  #$20,$32(a0)
                move.b  subtype(a0),d0
                andi.w  #2,d0
                move.w  word_4808A(pc,d0.w),$30(a0)
                move.l  #loc_480D4,(a0)

loc_480D4:
                move.w  (Player_1+y_pos).w,d0
                sub.w   y_pos(a0),d0
                bcs.s   loc_48102
                cmpi.w  #$20,d0
                blt.s   loc_48124
                move.w  $32(a0),d1
                cmp.w   $34(a0),d1
                beq.s   loc_48124
                tst.w   $34(a0)
                bne.s   loc_480FC
                moveq   #signextendB(sfx_SpringLatch),d0
                jsr     (Play_SFX).l

loc_480FC:
                addq.w  #8,$34(a0)
                bra.s   loc_48124
; ---------------------------------------------------------------------------

loc_48102:
                cmpi.w  #-$20,d0
                bge.s   loc_48124
                tst.w   $34(a0)
                beq.s   loc_48124
                move.w  $32(a0),d1
                cmp.w   $34(a0),d1
                bne.s   loc_48120
                moveq   #signextendB(sfx_SpringLatch),d0
                jsr     (Play_SFX).l

loc_48120:
                subq.w  #8,$34(a0)

loc_48124:
                move.w  $34(a0),d0
                btst    #0,status(a0)
                bne.s   loc_48132
                neg.w   d0

loc_48132:
                btst    #1,status(a0)
                beq.s   loc_4813C
                neg.w   d0

loc_4813C:
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #9,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                jsr     (SolidObjectTop_1P).l
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_4816E
                jsr     (sub_22F98).l

loc_4816E:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                jsr     (SolidObjectTop_1P).l
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_4818C
                jsr     (sub_22F98).l

loc_4818C:
                lea     (Ani_DEZRetractingSpring).l,a1
                jsr     (Animate_Sprite).l
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
Ani_DEZRetractingSpring:
                include "src/objects/shared/zones/dez/anim_retracting_spring.s"
Map_DEZRetractingSpring:
                include "src/objects/shared/zones/dez/map_retracting_spring.s"
; End of function Obj_DEZRetractingSpring
