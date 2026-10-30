; Owner: objects/zones/soz/sk
; Responsibility: Spring vine player contact, deformation, launch response and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZSpringVine:
                move.l  #Map_SOZSpringVine,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZMisc,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$2C,width_pixels(a0)
                move.b  #$2C,height_pixels(a0)
                move.w  #$280,priority(a0)
                bset    #7,status(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_40840
                move.l  #loc_40872,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  #$40,width_pixels(a1)
                move.b  #$40,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                moveq   #8,d0
                bset    #6,render_flags(a1)
                move.w  d0,mainspr_childsprites(a1)
                move.l  x_pos(a0),d1
                move.l  y_pos(a0),d2
                subi.l  #$280000,d1
                addi.l  #$280000,d2
                lea     sub2_x_pos(a1),a2
                move.w  mainspr_childsprites(a1),d0
                subq.w  #1,d0

loc_4081C:
                swap    d1
                swap    d2
                move.w  d1,(a2)+
                move.w  d2,(a2)+
                swap    d1
                swap    d2
                move.w  #0,(a2)+
                addi.l  #$B504F,d1
                subi.l  #$B504F,d2
                dbf     d0,loc_4081C
                move.w  a1,$3C(a0)

loc_40840:
                addi.w  #$28,y_pos(a0)
                move.w  #$60,$30(a0)
                move.l  #loc_40852,(a0)

loc_40852:
                bsr.s   sub_40878
                bsr.w   sub_40A08
                move.w  #$30,d1
                lea     ((RAM_start+$8F00)&$FFFFFF).l,a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped).l
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_40872:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_40878:
                moveq   #0,d4
                move.w  $30(a0),d5
                lea     $35(a0),a2
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   sub_4093E
                subq.w  #1,a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.w   sub_4093E
                move.w  d5,$30(a0)
                tst.b   $36(a0)
                bne.s   loc_408B6
                move.w  #$40,d0
                cmp.w   $32(a0),d4
                beq.s   locret_408B4
                bge.s   loc_408B0
                neg.w   d0

loc_408B0:
                add.w   d0,$32(a0)

locret_408B4:
                rts
; ---------------------------------------------------------------------------

loc_408B6:
                moveq   #0,d0
                move.b  $23(a0),d0
                addq.b  #2,$23(a0)
                move.w  word_408D4(pc,d0.w),d0
                move.w  d0,$32(a0)
                bne.s   locret_408B4
                move.b  d0,$36(a0)
                move.b  d0,$23(a0)
                rts
; End of function sub_40878

; ---------------------------------------------------------------------------
word_408D4:
                dc.w    -$100
                dc.w    -$C0
                dc.w    -$80
                dc.w    -$40
                dc.w    -1
                dc.w    $40
                dc.w    $80
                dc.w    $C0
                dc.w    $100
                dc.w    $C0
                dc.w    $80
                dc.w    $40
                dc.w    1
                dc.w    -$20
                dc.w    -$40
                dc.w    -$60
                dc.w    -$80
                dc.w    -$60
                dc.w    -$40
                dc.w    -$20
                dc.w    -1
                dc.w    $10
                dc.w    $20
                dc.w    $30
                dc.w    $40
                dc.w    $30
                dc.w    $20
                dc.w    $10
                dc.w    1
                dc.w    -8
                dc.w    -$10
                dc.w    -$18
                dc.w    -$20
                dc.w    -$18
                dc.w    -$10
                dc.w    -8
                dc.w    -1
                dc.w    4
                dc.w    8
                dc.w    $C
                dc.w    $10
                dc.w    $C
                dc.w    8
                dc.w    4
                dc.w    1
                dc.w    -2
                dc.w    -4
                dc.w    -6
                dc.w    -8
                dc.w    -6
                dc.w    -4
                dc.w    -2
                dc.w    0

; =============== S U B R O U T I N E =======================================

sub_4093E:
                btst    d6,status(a0)
                bne.s   loc_4094A
                move.b  #0,(a2)
                rts
; ---------------------------------------------------------------------------

loc_4094A:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$30,d0
                cmpi.w  #$60,d0
                bhs.s   locret_409B8
                btst    #0,status(a0)
                beq.s   loc_4096A
                not.w   d0
                addi.w  #$60,d0

loc_4096A:
                move.w  d0,d5
                move.w  #-$100,d4
                tst.b   (a2)
                bne.s   loc_40982
                moveq   #1,d1
                cmpi.w  #$3C,d0
                bhs.s   loc_4097E
                neg.w   d1

loc_4097E:
                move.b  d1,(a2)
                rts
; ---------------------------------------------------------------------------

loc_40982:
                bpl.s   loc_40996
                cmpi.w  #$3C,d0
                blo.s   locret_409B8
                move.b  #0,(a2)
                move.b  #1,$36(a0)
                bra.s   loc_409BA
; ---------------------------------------------------------------------------

loc_40996:
                moveq   #$18,d1
                btst    #0,status(a0)
                beq.s   loc_409A2
                not.w   d1

loc_409A2:
                sub.w   d1,ground_vel(a1)
                cmpi.w  #$3C,d0
                bhs.s   locret_409B8
                move.b  #0,(a2)
                move.b  #1,$36(a0)
                bra.s   loc_409BA
; ---------------------------------------------------------------------------

locret_409B8:
                rts
; ---------------------------------------------------------------------------

loc_409BA:
                move.w  #-$EF0,y_vel(a1)
                move.w  #-$EF0,x_vel(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,status(a0)
                beq.s   loc_409DE
                bclr    #Status_Facing,status(a1)
                neg.w   x_vel(a1)

loc_409DE:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)
                move.b  #0,double_jump_flag(a1)
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function sub_4093E

; =============== S U B R O U T I N E =======================================

sub_40A08:
                move.w  $30(a0),d5
                beq.w   locret_40AA8
                lea     (byte_40AAA).l,a1
                moveq   #0,d0
                move.b  (a1,d5.w),d0
                muls.w  $32(a0),d0
                move.w  d5,d1
                ext.l   d1
                asl.l   #8,d1
                add.l   d1,d0
                move.l  d0,d4
                move.w  d5,d1
                divs.w  d1,d0
                ext.l   d0
                asl.l   #8,d0
                move.w  d1,d2
                subq.w  #1,d2
                lea     ((RAM_start+$8F00)&$FFFFFF).l,a2
                moveq   #0,d3

loc_40A3E:
                move.b  d3,(a2)+
                swap    d3
                add.l   d0,d3
                swap    d3
                dbf     d2,loc_40A3E
                move.w  #$60,d2
                sub.w   d1,d2
                bls.s   loc_40A6E
                move.l  #$6000,d0
                sub.l   d4,d0
                divs.w  d2,d0
                ext.l   d0
                asl.l   #8,d0
                subq.w  #1,d2

loc_40A62:
                move.b  d3,(a2)+
                swap    d3
                add.l   d0,d3
                swap    d3
                dbf     d2,loc_40A62

loc_40A6E:
                lea     ((RAM_start+$8F06)&$FFFFFF).l,a3
                move.w  y_pos(a0),d2
                addq.w  #6,d2
                movea.w $3C(a0),a1
                lea     y_vel(a1),a2
                moveq   #6,d3
                btst    #0,status(a0)
                beq.s   loc_40A92
                lea     default_y_radius(a1),a2
                neg.w   d3

loc_40A92:
                moveq   #8-1,d0

loc_40A94:
                move.b  (a3),d1
                ext.w   d1
                neg.w   d1
                add.w   d2,d1
                move.w  d1,(a2)
                adda.w  d3,a2
                adda.w  #$C,a3
                dbf     d0,loc_40A94

locret_40AA8:
                rts
; End of function sub_40A08

; ---------------------------------------------------------------------------
byte_40AAA:
                dc.b    0,   0,   1,   1,   2,   3,   3,   4,   5,   5,   6,   7,   7,   8,   9,   9,  $A,  $B,  $B,  $C
                dc.b    $D,  $D,  $E,  $F,  $F, $10, $11, $11, $12, $13, $13, $14, $15, $15, $16, $17, $17, $18, $19, $19
                dc.b    $1A, $1B, $1B, $1C, $1D, $1D, $1E, $1F, $1F, $20, $21, $21, $22, $23, $23, $24, $25, $25, $26, $27
                dc.b    $27, $28, $27, $27, $26, $25, $24, $23, $22, $21, $20, $1F, $1E, $1D, $1C, $1B, $1A, $19, $18, $17
                dc.b    $16, $15, $14, $13, $12, $11, $10,  $F,  $E,  $D,  $C,  $B,  $A,   9,   8,   7,   0,   0
                even
Map_SOZSpringVine:
                include "src/objects/shared/zones/soz/map_spring_vine.s"
