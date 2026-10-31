; Owner: objects/zones/lrz/sk
; Responsibility: Lava Reef chained platform coordination, movement, player riding and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_LRZChainedPlatforms:
                move.b  subtype(a0),d0
                bmi.w   loc_4A6F4
                move.l  #Map_LRZChainedPlatforms,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #$200,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #3,d0
                andi.w  #$1E,d0
                lea     off_4A890(pc),a2
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,$3C(a0)
                move.l  a2,$40(a0)
                andi.w  #$F,d1
                lsl.w   #2,d1
                move.b  d1,$3C(a0)
                move.b  #4,$3E(a0)
                btst    #0,status(a0)
                beq.s   loc_4A6CE
                neg.b   $3E(a0)
                moveq   #0,d1
                move.b  $3C(a0),d1
                add.b   $3E(a0),d1
                cmp.b   $3D(a0),d1
                blo.s   loc_4A6CA
                move.b  d1,d0
                moveq   #0,d1
                tst.b   d0
                bpl.s   loc_4A6CA
                move.b  $3D(a0),d1
                subq.b  #4,d1

loc_4A6CA:
                move.b  d1,$3C(a0)

loc_4A6CE:
                move.w  (a2,d1.w),d0
                add.w   $34(a0),d0
                move.w  d0,$38(a0)
                move.w  2(a2,d1.w),d0
                add.w   $36(a0),d0
                move.w  d0,$3A(a0)
                bsr.w   sub_4A818
                move.l  #loc_4A74A,(a0)
                bra.w   loc_4A74A
; ---------------------------------------------------------------------------

loc_4A6F4:
                andi.w  #$7F,d0
                add.w   d0,d0
                lea     (off_4A914).l,a2
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d1
                movea.l a0,a1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                bra.s   loc_4A71A
; ---------------------------------------------------------------------------

loc_4A712:
                jsr     (AllocateObject).l
                bne.s   loc_4A744

loc_4A71A:
                move.l  #Obj_LRZChainedPlatforms,(a1)
                move.w  (a2)+,d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.w  (a2)+,d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  d2,$34(a1)
                move.w  d3,$36(a1)
                move.w  (a2)+,d0
                move.b  d0,subtype(a1)
                move.b  status(a0),status(a1)

loc_4A744:
                dbf     d1,loc_4A712
                rts
; ---------------------------------------------------------------------------

loc_4A74A:
                move.w  x_pos(a0),-(sp)
                bsr.w   sub_4A7BA
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.w  #4|8,d6
                beq.s   loc_4A798
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   loc_4A788
                lea     (Player_1).w,a1
                jsr     (sub_24280).l

loc_4A788:
                andi.b  #8,d6
                beq.s   loc_4A798
                lea     (Player_2).w,a1
                jsr     (sub_24280).l

loc_4A798:
                tst.b   render_flags(a0)
                bpl.s   loc_4A7B0
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   loc_4A7B0
                moveq   #signextendB(sfx_ChainTick),d0
                jsr     (Play_SFX).l

loc_4A7B0:
                move.w  $34(a0),d0
                jmp     (Sprite_OnScreen_Test2).l

; =============== S U B R O U T I N E =======================================

sub_4A7BA:
                move.w  x_pos(a0),d0
                cmp.w   $38(a0),d0
                bne.s   loc_4A810
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                bne.s   loc_4A810
                moveq   #0,d1
                move.b  $3C(a0),d1
                add.b   $3E(a0),d1
                cmp.b   $3D(a0),d1
                blo.s   loc_4A7EC
                move.b  d1,d0
                moveq   #0,d1
                tst.b   d0
                bpl.s   loc_4A7EC
                move.b  $3D(a0),d1
                subq.b  #4,d1

loc_4A7EC:
                move.b  d1,$3C(a0)
                movea.l $40(a0),a1
                move.w  (a1,d1.w),d0
                add.w   $34(a0),d0
                move.w  d0,$38(a0)
                move.w  2(a1,d1.w),d0
                add.w   $36(a0),d0
                move.w  d0,$3A(a0)
                bsr.w   sub_4A818

loc_4A810:
                jsr     (MoveSprite2).l
                rts
; End of function sub_4A7BA

; =============== S U B R O U T I N E =======================================

sub_4A818:
                moveq   #0,d0
                move.w  #-$100,d2
                move.w  x_pos(a0),d0
                sub.w   $38(a0),d0
                bcc.s   loc_4A82C
                neg.w   d0
                neg.w   d2

loc_4A82C:
                moveq   #0,d1
                move.w  #-$100,d3
                move.w  y_pos(a0),d1
                sub.w   $3A(a0),d1
                bcc.s   loc_4A840
                neg.w   d1
                neg.w   d3

loc_4A840:
                cmp.w   d0,d1
                blo.s   loc_4A86A
                move.w  x_pos(a0),d0
                sub.w   $38(a0),d0
                beq.s   loc_4A856
                ext.l   d0
                asl.l   #8,d0
                divs.w  d1,d0
                neg.w   d0

loc_4A856:
                move.w  d0,x_vel(a0)
                move.w  d3,y_vel(a0)
                swap    d0
                move.w  d0,$12(a0)
                clr.w   $16(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A86A:
                move.w  y_pos(a0),d1
                sub.w   $3A(a0),d1
                beq.s   loc_4A87C
                ext.l   d1
                asl.l   #8,d1
                divs.w  d0,d1
                neg.w   d1

loc_4A87C:
                move.w  d1,y_vel(a0)
                move.w  d2,x_vel(a0)
                swap    d1
                move.w  d1,$16(a0)
                clr.w   $12(a0)
                rts
; End of function sub_4A818

; ---------------------------------------------------------------------------
off_4A890:
                dc.w    word_4A896-off_4A890
                dc.w    word_4A8C0-off_4A890
                dc.w    word_4A8EA-off_4A890
word_4A896:     dc.w    $28
                dc.w    0,     0
                dc.w    -$16,    $A
                dc.w    -$20,   $20
                dc.w    -$20,   $C0
                dc.w    -$16,   $D6
                dc.w    0,   $E0
                dc.w    $16,   $D6
                dc.w    $20,   $C0
                dc.w    $20,   $20
                dc.w    $16,    $A
word_4A8C0:     dc.w    $28
                dc.w    0,     0
                dc.w    -$16,    $A
                dc.w    -$20,   $20
                dc.w    -$20,  $140
                dc.w    -$16,  $156
                dc.w    0,  $160
                dc.w    $16,  $156
                dc.w    $20,  $140
                dc.w    $20,   $20
                dc.w    $16,    $A
word_4A8EA:     dc.w    $28
                dc.w    0,     0
                dc.w    -$16,    $A
                dc.w    -$20,   $20
                dc.w    -$20,  $1C0
                dc.w    -$16,  $1D6
                dc.w    0,  $1E0
                dc.w    $16,  $1D6
                dc.w    $20,  $1C0
                dc.w    $20,   $20
                dc.w    $16,    $A
off_4A914:
                dc.w    word_4A91A-off_4A914
                dc.w    word_4A934-off_4A914
                dc.w    word_4A94E-off_4A914
word_4A91A:     dc.w    4-1
                dc.w    0,     0,     1
                dc.w    -$20,   $70,     3
                dc.w    0,   $E0,     6
                dc.w    $20,   $70,     8
word_4A934:     dc.w    4-1
                dc.w    0,     0,   $11
                dc.w    -$20,   $B0,   $13
                dc.w    0,  $160,   $16
                dc.w    $20,   $B0,   $18
word_4A94E:     dc.w    8-1
                dc.w    0,     0,   $21
                dc.w    -$20,   $72,   $23
                dc.w    -$20,   $F0,   $23
                dc.w    -$20,  $16E,   $23
                dc.w    0,  $1E0,   $26
                dc.w    $20,  $16E,   $28
                dc.w    $20,   $F0,   $28
                dc.w    $20,   $72,   $28
Map_LRZChainedPlatforms:
                include "src/objects/shared/zones/lrz/mappings/chained_platforms.s"
