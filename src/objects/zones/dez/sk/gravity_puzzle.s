; Owner: objects/zones/dez/sk
; Responsibility: Gravity puzzle state, coordinated sprites and player interactions
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZGravityPuzzle:
                move.l  #Map_DEZGravityPuzzle,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZMisc2+$31,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.w  y_pos(a0),$46(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_49980
                move.l  #Sprite_OnScreen_Test,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  #$20,width_pixels(a1)
                move.b  #$30,height_pixels(a1)
                move.w  #$200,priority(a1)
                bset    #6,render_flags(a1)
                move.w  x_pos(a0),d2
                move.w  d2,x_pos(a1)
                move.w  y_pos(a0),d3
                move.w  d3,y_pos(a1)
                move.b  (MHZ_pollen_counter).w,d4
                lea     sub2_x_pos(a1),a2
                lea     byte_49A5A(pc),a3
                moveq   #6,d1
                move.w  d1,mainspr_childsprites(a1)
                subq.w  #1,d1

loc_4995C:
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,(a2)+
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,(a2)+
                addq.w  #1,a2
                move.b  (a3)+,(a2)+
                lsr.b   #1,d4
                bcc.s   loc_49978
                subq.b  #2,-1(a2)

loc_49978:
                dbf     d1,loc_4995C
                move.w  a1,$3E(a0)

loc_49980:
                move.l  #loc_49986,(a0)

loc_49986:
                move.b  angle(a0),d0
                addq.b  #1,angle(a0)
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                movea.w $3E(a0),a2
                lea     sub2_y_pos(a2),a3
                lea     byte_49A5A+1(pc),a4
                moveq   #6-1,d1

loc_499AC:
                move.b  (a4),d2
                ext.w   d2
                add.w   d0,d2
                move.w  d2,(a3)+
                addq.w  #4,a3
                addq.w  #3,a4
                dbf     d1,loc_499AC
                move.w  #$23,d1
                move.w  #$30,d2
                move.w  #$31,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull2).l
                swap    d6
                andi.w  #1|2,d6
                beq.s   loc_499FC
                move.w  d6,d0
                andi.w  #1,d0
                beq.s   loc_499EC
                lea     (Player_1).w,a1
                bsr.s   sub_49A0E
                moveq   #p1_pushing_bit,d5
                bsr.s   sub_49A02

loc_499EC:
                andi.w  #2,d6
                beq.s   loc_499FC
                bsr.s   sub_49A0E
                lea     (Player_2).w,a1
                moveq   #p2_pushing_bit,d5
                bsr.s   sub_49A02

loc_499FC:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_49A02:
                moveq   #signextendB(sfx_TunnelBooster),d0
                jsr     (Play_SFX).l
                bra.w   loc_49850
; End of function sub_49A02

; =============== S U B R O U T I N E =======================================

sub_49A0E:
                moveq   #0,d1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.s   loc_49A1C
                moveq   #3,d1

loc_49A1C:
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$30,d0
                bpl.s   loc_49A2C
                moveq   #0,d0

loc_49A2C:
                cmpi.w  #$60,d0
                blo.s   loc_49A34
                moveq   #$40,d0

loc_49A34:
                lsr.w   #5,d0
                add.w   d1,d0
                bset    d0,(MHZ_pollen_counter).w
                movea.w $3E(a0),a2
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                add.w   d0,d0
                addi.w  #$1D,d0
                cmpi.b  #3,(a2,d0.w)
                blo.s   locret_49A58
                subq.b  #2,(a2,d0.w)

locret_49A58:
                rts
; End of function sub_49A0E

; ---------------------------------------------------------------------------
byte_49A5A:
                dc.b    -$1C,-$20
                dc.b    3,-$1C
                dc.b    0,   3
                dc.b    -$1C, $20
                dc.b    3, $1C
                dc.b    -$20,   4
                dc.b    $1C,   0
                dc.b    4, $1C
                dc.b    $20,   4
                even
Map_DEZGravityPuzzle:
                include "src/objects/shared/zones/dez/mappings/gravity_puzzle.s"
