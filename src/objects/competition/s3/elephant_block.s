; Owner: objects/competition/s3
; Responsibility: Balloon Park elephant-block movement, player collision and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_BPZElephantBlock:
                move.l  #Map_BPZElephantBlock,mappings(a0)
                move.w  #make_art_tile(ArtTile_BPZMisc,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$30,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  x_pos(a0),$30(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                move.b  subtype(a0),d0
                lsl.w   #8,d0
                move.w  d0,$38(a0)
                bset    #7,status(a0)
                btst    #0,status(a0)
                beq.s   loc_351FE
                move.w  d0,$34(a0)
                move.b  #1,$3A(a0)
                move.l  #loc_3525C,(a0)
                bra.w   loc_3525C
; ---------------------------------------------------------------------------

loc_351FE:
                move.l  #loc_35204,(a0)

loc_35204:
                bsr.w   sub_352B4
                lea     sub2_x_pos(a0),a2
                move.w  $30(a0),d0
                move.b  $34(a0),d1
                ext.w   d1
                sub.w   d1,d0
                move.w  d0,(a2)
                move.w  $30(a0),d0
                asr.w   #1,d1
                sub.w   d1,d0
                move.w  d0,x_pos(a0)
                addq.w  #8,d1
                move.b  d1,width_pixels(a0)
                move.w  #0,4(a2)
                cmpi.w  #$20,d1
                blo.s   loc_3523E
                move.w  #1,4(a2)

loc_3523E:
                addi.w  #7,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_3525C:
                bsr.w   sub_352B4
                lea     sub2_x_pos(a0),a2
                move.w  $30(a0),d0
                move.b  $34(a0),d1
                ext.w   d1
                add.w   d1,d0
                move.w  d0,(a2)
                move.w  $30(a0),d0
                asr.w   #1,d1
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                addq.w  #8,d1
                move.b  d1,width_pixels(a0)
                move.w  #0,4(a2)
                cmpi.w  #$20,d1
                blo.s   loc_35296
                move.w  #1,4(a2)

loc_35296:
                addi.w  #7,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_352B4:
                tst.b   $3A(a0)
                bne.s   loc_352D6
                move.w  $38(a0),d0
                addi.w  #$80,$34(a0)
                cmp.w   $34(a0),d0
                bhi.s   loc_352D4
                move.w  d0,$34(a0)
                move.b  #1,$3A(a0)

loc_352D4:
                bra.s   locret_352EA
; ---------------------------------------------------------------------------

loc_352D6:
                subi.w  #$80,$34(a0)
                bhi.s   locret_352EA
                move.w  #0,$34(a0)
                move.b  #0,$3A(a0)

locret_352EA:
                rts
; End of function sub_352B4

; ---------------------------------------------------------------------------
Map_BPZElephantBlock:
                include "src/objects/shared/zones/bpz/map_elephant_block.s"
