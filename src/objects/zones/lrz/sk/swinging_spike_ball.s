; Owner: objects/zones/lrz/sk
; Responsibility: Swinging spike-ball movement, chain control and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZSwingingSpikeBall:
                move.l  #Map_LRZSwingingSpikeBall,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZMisc,1,1),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                move.b  #$9A,collision_flags(a0)
                tst.b   (Current_act).w
                beq.s   loc_4354E
                move.l  #Map_LRZSwingingSpikeBall2,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,1,1),art_tile(a0)

loc_4354E:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_435CA
                move.l  #loc_435FE,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                andi.w  #$9FFF,art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  #$50,width_pixels(a1)
                move.b  #$50,height_pixels(a1)
                move.w  #$280,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                bset    #6,render_flags(a1)
                move.w  d0,mainspr_childsprites(a1)
                lea     sub2_x_pos(a1),a2
                move.w  mainspr_childsprites(a1),d0
                subq.w  #1,d0

loc_435B0:
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #1,(a2)+
                dbf     d0,loc_435B0
                move.b  #1,mapping_frame(a1)
                move.w  a1,$3C(a0)

loc_435CA:
                moveq   #2,d0
                btst    #0,status(a0)
                beq.s   loc_435D6
                neg.w   d0

loc_435D6:
                move.b  d0,$36(a0)
                move.l  #loc_435E0,(a0)

loc_435E0:
                movea.w $3C(a0),a1
                bsr.w   sub_43604
                move.b  $34(a0),d2
                move.b  $36(a0),d0
                add.b   d0,$34(a0)
                move.w  $44(a0),d0
                jmp     (loc_1B666).l
; ---------------------------------------------------------------------------

loc_435FE:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_43604:
                move.b  $34(a0),d0
                jsr     (GetSineCosine).l
                move.w  $46(a0),d2
                move.w  $44(a0),d3
                swap    d0
                swap    d1
                asr.l   #4,d0
                asr.l   #4,d1
                move.l  d0,d4
                move.l  d1,d5
                tst.b   subtype(a0)
                bpl.s   loc_4362C
                add.l   d0,d4
                add.l   d1,d5

loc_4362C:
                lea     sub2_x_pos(a1),a2
                move.w  mainspr_childsprites(a1),d6
                subq.w  #1,d6

loc_43636:
                movem.l d4-d5,-(sp)
                swap    d4
                swap    d5
                add.w   d2,d4
                add.w   d3,d5
                move.w  d5,(a2)+
                move.w  d4,(a2)+
                movem.l (sp)+,d4-d5
                add.l   d0,d4
                add.l   d1,d5
                addq.w  #2,a2
                dbf     d6,loc_43636
                swap    d4
                swap    d5
                add.w   d2,d4
                add.w   d3,d5
                move.w  d5,x_pos(a0)
                move.w  d4,y_pos(a0)
                rts
; End of function sub_43604

; ---------------------------------------------------------------------------
Map_LRZSwingingSpikeBall:
                include "src/objects/shared/zones/lrz/map_swinging_spike_ball.s"
