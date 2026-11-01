; Owner: objects/zones/hcz/s3
; Responsibility: Hydrocity breakable bar attachment, movement, breakage and shared player geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
byte_1C8E2:
                dc.b    $14, $28, $20,   0
                dc.b    $24, $48, $30,   1
                dc.b    $34, $68, $40,   2
                even
; ---------------------------------------------------------------------------

Obj_HCZBreakableBar:
                move.l  #Map_HCZBreakableBar,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZMisc,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$200,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                andi.b  #$F,d0
                mulu.w  #60,d0
                move.w  d0,$30(a0)
                andi.w  #$30,d1
                lsr.w   #2,d1
                lea     byte_1C8E2(pc,d1.w),a1
                tst.b   subtype(a0)
                bpl.s   loc_1C956
                moveq   #0,d0
                move.b  (a1)+,d0
                move.w  d0,$36(a0)
                move.b  (a1)+,d0
                move.w  d0,$38(a0)
                move.b  (a1)+,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.b  (a1)+,d0
                addq.b  #4,d0
                move.b  d0,mapping_frame(a0)
                move.l  #loc_1CB2C,(a0)
                bra.w   loc_1CB2C
; ---------------------------------------------------------------------------

loc_1C956:
                moveq   #0,d0
                move.b  (a1)+,d0
                move.w  d0,$36(a0)
                move.b  (a1)+,d0
                move.w  d0,$38(a0)
                move.b  #4,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.l  #loc_1C978,(a0)

loc_1C978:
                lea     $32(a0),a2
                tst.w   $30(a0)
                beq.s   loc_1C98E
                tst.w   (a2)
                beq.s   loc_1C98E
                subq.w  #1,$30(a0)
                beq.w   loc_1CAB4

loc_1C98E:
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d1
                moveq   #0,d2
                bsr.s   UpdatePlayerOnHczVerticalBreakableBar
                addq.w  #1,a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2).w,d1
                moveq   #1,d2
                bsr.s   UpdatePlayerOnHczVerticalBreakableBar
                tst.b   $3A(a0)
                bne.w   loc_1CAB4
                bra.w   Sprite_OnScreen_Test

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnHczVerticalBreakableBar:
                tst.b   (a2)
                beq.s   loc_1CA16
                move.w  y_pos(a0),d0
                sub.w   $36(a0),d0
                btst    #button_up+8,d1
                beq.s   loc_1C9D4
                subq.w  #1,y_pos(a1)
                cmp.w   y_pos(a1),d0
                blo.s   loc_1C9D4
                move.w  d0,y_pos(a1)

loc_1C9D4:
                add.w   $38(a0),d0
                btst    #button_down+8,d1
                beq.s   loc_1C9EC
                addq.w  #1,y_pos(a1)
                cmp.w   y_pos(a1),d0
                bhs.s   loc_1C9EC
                move.w  d0,y_pos(a1)

loc_1C9EC:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d1
                beq.w   locret_1CAB2
                clr.b   (a2)
                move.b  #$3C,2(a2)
                bclr    d2,(_unkF7C7).w
                andi.b  #$FE,object_control(a1)
                btst    #6,subtype(a0)
                bne.s   locret_1CA14
                move.b  #1,$3A(a0)

locret_1CA14:
                rts
; ---------------------------------------------------------------------------

loc_1CA16:
                tst.b   2(a2)
                beq.s   loc_1CA22
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_1CA22:
                moveq   #0,d1
                move.b  height_pixels(a0),d1
                move.w  y_pos(a0),d0
                sub.w   d1,d0
                move.w  y_pos(a1),d2
                cmp.w   d0,d2
                blo.s   locret_1CAB2
                add.w   d1,d0
                add.w   d1,d0
                cmp.w   d0,d2
                bhs.s   locret_1CAB2
                move.w  x_pos(a0),d0
                addi.w  #$14,d0
                cmp.w   x_pos(a1),d0
                bhs.s   locret_1CAB2
                addi.w  #$10,d0
                cmp.w   x_pos(a1),d0
                blo.s   locret_1CAB2
                cmpi.b  #4,routine(a1)
                bhs.s   locret_1CAB2
                tst.b   object_control(a1)
                bne.s   locret_1CAB2
                move.w  y_pos(a0),d0
                sub.w   $36(a0),d0
                cmp.w   y_pos(a1),d0
                blo.s   loc_1CA76
                move.w  d0,y_pos(a1)

loc_1CA76:
                add.w   $38(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   loc_1CA84
                move.w  d0,y_pos(a1)

loc_1CA84:
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                move.w  x_pos(a0),d0
                addi.w  #$14,d0
                move.w  d0,x_pos(a1)
                bclr    #Status_Facing,status(a1)
                move.b  #$11,anim(a1)
                move.b  #1,object_control(a1)
                bset    d2,(_unkF7C7).w
                move.b  #1,(a2)

locret_1CAB2:
                rts
; End of function UpdatePlayerOnHczVerticalBreakableBar

; ---------------------------------------------------------------------------

loc_1CAB4:
                tst.b   $32(a0)
                beq.s   loc_1CAC0
                andi.b  #$FE,(Player_1+object_control).w

loc_1CAC0:
                tst.b   $33(a0)
                beq.s   loc_1CACC
                andi.b  #$FE,(Player_2+object_control).w

loc_1CACC:
                clr.b   (_unkF7C7).w
                clr.w   $32(a0)
                move.l  #loc_1CB06,(a0)
                move.b  #3,mapping_frame(a0)
                move.w  #$400,x_vel(a0)
                move.w  #0,y_vel(a0)
                lea     (word_1CCD0).l,a4
                lea     (byte_1CCB8).l,a2
                moveq   #0,d1
                move.b  height_pixels(a0),d1
                lsr.w   #2,d1
                subq.w  #1,d1
                bsr.w   SplitHczBreakableBarIntoPieces

loc_1CB06:
                tst.b   $3F(a0)
                beq.s   loc_1CB12
                subq.b  #1,$3F(a0)
                bra.s   loc_1CB1E
; ---------------------------------------------------------------------------

loc_1CB12:
                jsr     (MoveSprite2).l
                addi.w  #8,y_vel(a0)

loc_1CB1E:
                tst.b   render_flags(a0)
                bpl.w   loc_1C778
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_1CB2C:
                lea     $32(a0),a2
                tst.w   $30(a0)
                beq.s   loc_1CB42
                tst.w   (a2)
                beq.s   loc_1CB42
                subq.w  #1,$30(a0)
                beq.w   loc_1CC62

loc_1CB42:
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d1
                moveq   #0,d2
                bsr.s   UpdatePlayerOnHczHorizontalBreakableBar
                addq.w  #1,a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2).w,d1
                moveq   #1,d2
                bsr.s   UpdatePlayerOnHczHorizontalBreakableBar
                tst.b   $3A(a0)
                bne.w   loc_1CC62
                bra.w   Sprite_OnScreen_Test

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnHczHorizontalBreakableBar:
                tst.b   (a2)
                beq.s   loc_1CBCA
                move.w  x_pos(a0),d0
                sub.w   $36(a0),d0
                btst    #button_left+8,d1
                beq.s   loc_1CB88
                subq.w  #1,x_pos(a1)
                cmp.w   x_pos(a1),d0
                blo.s   loc_1CB88
                move.w  d0,x_pos(a1)

loc_1CB88:
                add.w   $38(a0),d0
                btst    #button_right+8,d1
                beq.s   loc_1CBA0
                addq.w  #1,x_pos(a1)
                cmp.w   x_pos(a1),d0
                bhs.s   loc_1CBA0
                move.w  d0,x_pos(a1)

loc_1CBA0:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d1
                beq.w   locret_1CC60
                clr.b   (a2)
                move.b  #$3C,2(a2)
                bclr    d2,(_unkF7C7).w
                andi.b  #$FE,object_control(a1)
                btst    #6,subtype(a0)
                bne.s   locret_1CBC8
                move.b  #1,$3A(a0)

locret_1CBC8:
                rts
; ---------------------------------------------------------------------------

loc_1CBCA:
                tst.b   2(a2)
                beq.s   loc_1CBD6
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_1CBD6:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  x_pos(a0),d0
                sub.w   d1,d0
                move.w  x_pos(a1),d2
                cmp.w   d0,d2
                blo.s   locret_1CC60
                add.w   d1,d0
                add.w   d1,d0
                cmp.w   d0,d2
                bhs.s   locret_1CC60
                move.w  y_pos(a0),d0
                subi.w  #$14,d0
                cmp.w   y_pos(a1),d0
                bhs.s   locret_1CC60
                addi.w  #$10,d0
                cmp.w   y_pos(a1),d0
                blo.s   locret_1CC60
                cmpi.b  #4,routine(a1)
                bhs.s   locret_1CC60
                tst.b   object_control(a1)
                bne.s   locret_1CC60
                move.w  x_pos(a0),d0
                sub.w   $36(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   loc_1CC2A
                move.w  d0,x_pos(a1)

loc_1CC2A:
                add.w   $38(a0),d0
                cmp.w   x_pos(a1),d0
                bhs.s   loc_1CC38
                move.w  d0,x_pos(a1)

loc_1CC38:
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                move.w  y_pos(a0),d0
                subi.w  #$14,d0
                move.w  d0,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #1,object_control(a1)
                bset    d2,(_unkF7C7).w
                move.b  #1,(a2)

locret_1CC60:
                rts
; End of function UpdatePlayerOnHczHorizontalBreakableBar

; ---------------------------------------------------------------------------

loc_1CC62:
                tst.b   $32(a0)
                beq.s   loc_1CC6E
                andi.b  #$FE,(Player_1+object_control).w

loc_1CC6E:
                tst.b   $33(a0)
                beq.s   loc_1CC7A
                andi.b  #$FE,(Player_2+object_control).w

loc_1CC7A:
                clr.b   (_unkF7C7).w
                clr.w   $32(a0)
                move.l  #loc_1CB06,(a0)
                move.b  #7,mapping_frame(a0)
                move.w  #0,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                lea     (word_1CD10).l,a4
                lea     (byte_1CCB8).l,a2
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                lsr.w   #2,d1
                subq.w  #1,d1
                bsr.w   SplitHczBreakableBarIntoPieces
                bra.w   loc_1CB06
; ---------------------------------------------------------------------------
byte_1CCB8:
                dc.b    7,   5,   2,   0,   1,   3,   4,   6,   7,   5,   2,   0,   1,   3,   4,   6,   8,   9,  $A,  $B
                dc.b    $C,  $D,  $E,  $F
                even
word_1CCD0:
                dc.w    0,  -$1C
                dc.w    0,  -$14
                dc.w    0,   -$C
                dc.w    0,    -4
                dc.w    0,     4
                dc.w    0,    $C
                dc.w    0,   $14
                dc.w    0,   $1C
                dc.w    0,   $24
                dc.w    0,  -$24
                dc.w    0,   $2C
                dc.w    0,  -$2C
                dc.w    0,   $34
                dc.w    0,  -$34
                dc.w    0,   $3C
                dc.w    0,  -$3C
word_1CD10:
                dc.w    -$1C,     0
                dc.w    -$14,     0
                dc.w    -$C,     0
                dc.w    -4,     0
                dc.w    4,     0
                dc.w    $C,     0
                dc.w    $14,     0
                dc.w    $1C,     0
                dc.w    $24,     0
                dc.w    -$24,     0
                dc.w    $2C,     0
                dc.w    -$2C,     0
                dc.w    $34,     0
                dc.w    -$34,     0
                dc.w    $3C,     0
                dc.w    -$3C,     0

; =============== S U B R O U T I N E =======================================

SplitHczBreakableBarIntoPieces:
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  priority(a0),d4
                movea.l a0,a1
                bra.s   loc_1CD68
; ---------------------------------------------------------------------------

loc_1CD60:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_1CDC2

loc_1CD68:
                move.l  (a0),(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  (a4)+,d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.w  (a4)+,d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  d4,priority(a1)
                move.b  #4,width_pixels(a1)
                move.b  #4,height_pixels(a1)
                move.b  mapping_frame(a0),mapping_frame(a1)
                move.w  x_vel(a0),x_vel(a1)
                move.w  y_vel(a0),y_vel(a1)
                move.b  (a2)+,$3F(a1)
                dbf     d1,loc_1CD60

loc_1CDC2:
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; End of function SplitHczBreakableBarIntoPieces

; ---------------------------------------------------------------------------
Map_HCZBreakableBar:
                include "src/objects/shared/zones/hcz/mappings/breakable_bar.s"
