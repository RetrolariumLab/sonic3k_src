; Owner: objects/zones/cnz/sk
; Responsibility: Carnival Night spiral tube player transport, directional motion and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZSpiralTube:
                lea     (Player_1).w,a1
                lea     $30(a0),a4
                bsr.s   UpdatePlayerInCnzSpiralTube
                lea     (Player_2).w,a1
                lea     $3A(a0),a4
                bsr.s   UpdatePlayerInCnzSpiralTube
                move.b  $30(a0),d0
                add.b   $3A(a0),d0
                beq.s   loc_330E8
                rts
; ---------------------------------------------------------------------------

loc_330E8:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInCnzSpiralTube:
                moveq   #0,d0
                move.b  (a4),d0
                move.w  off_330FA(pc,d0.w),d0
                jmp     off_330FA(pc,d0.w)
; End of function UpdatePlayerInCnzSpiralTube

; ---------------------------------------------------------------------------
off_330FA:
                dc.w    loc_33102-off_330FA
                dc.w    loc_3318E-off_330FA
                dc.w    loc_331CA-off_330FA
                dc.w    loc_3320E-off_330FA
; ---------------------------------------------------------------------------

loc_33102:
                tst.w   (Debug_placement_mode).w
                bne.w   locret_3318C
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$80,d0
                bhs.s   locret_3318C
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$10,d1
                cmpi.w  #$20,d1
                bhs.s   locret_3318C
                tst.b   object_control(a1)
                bne.s   locret_3318C
                addq.b  #2,(a4)
                move.b  #$81,object_control(a1)
                move.b  #2,anim(a1)
                move.w  #$800,ground_vel(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                clr.b   1(a4)
                moveq   #$30,d1
                cmpi.w  #$40,d0
                bhs.s   loc_33174
                neg.w   d1
                move.b  #$80,1(a4)

loc_33174:
                add.w   x_pos(a0),d1
                move.w  d1,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l

locret_3318C:
                rts
; ---------------------------------------------------------------------------

loc_3318E:
                move.b  1(a4),d0
                addq.b  #8,1(a4)
                jsr     (GetSineCosine).l
                asr.w   #3,d1
                move.w  d1,d0
                asr.w   #1,d1
                add.w   d1,d0
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                moveq   #0,d0
                btst    #0,(Ring_count+1).w
                beq.s   loc_331BA
                move.w  #$80,d0

loc_331BA:
                cmp.b   1(a4),d0
                bne.s   locret_331C8
                addq.b  #2,(a4)
                move.w  #$C0,2(a4)

locret_331C8:
                rts
; ---------------------------------------------------------------------------

loc_331CA:
                move.b  1(a4),d0
                addi.b  #$C,1(a4)
                jsr     (GetSineCosine).l
                asr.w   #3,d1
                move.w  d1,d0
                asr.w   #1,d1
                add.w   d1,d0
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                addq.w  #2,y_pos(a1)
                subq.w  #1,2(a4)
                bne.s   locret_3320C
                moveq   #0,d0
                move.w  x_pos(a0),d1
                sub.w   x_pos(a1),d1
                bcc.s   loc_33202
                moveq   #1,d0

loc_33202:
                add.b   subtype(a0),d0
                bsr.w   InitializeCnzSpiralExitRoute
                addq.b  #2,(a4)

locret_3320C:
                rts
; ---------------------------------------------------------------------------

loc_3320E:
                subq.b  #1,2(a4)
                bpl.s   loc_3323A
                movea.l 6(a4),a2
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)
                move.l  a2,6(a4)
                subq.w  #4,4(a4)
                beq.s   loc_33260
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  #$C00,d2
                bra.w   loc_332A2
; ---------------------------------------------------------------------------

loc_3323A:
                move.l  x_pos(a1),d2
                move.l  y_pos(a1),d3
                move.w  x_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d2
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d2,x_pos(a1)
                move.l  d3,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

loc_33260:
                andi.w  #$FFF,y_pos(a1)
                clr.b   (a4)
                clr.b   object_control(a1)
                clr.b   jumping(a1)
                bra.s   loc_3323A

; =============== S U B R O U T I N E =======================================

InitializeCnzSpiralExitRoute:
                andi.w  #$F,d0
                add.w   d0,d0
                lea     (off_33320).l,a2
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,4(a4)
                subq.w  #4,4(a4)
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)
                move.l  a2,6(a4)
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  #$C00,d2

loc_332A2:
                moveq   #0,d0
                move.w  d2,d3
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                bge.s   loc_332B2
                neg.w   d0
                neg.w   d2

loc_332B2:
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                bge.s   loc_332C0
                neg.w   d1
                neg.w   d3

loc_332C0:
                cmp.w   d0,d1
                blo.s   loc_332F2
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                swap    d1
                divs.w  d3,d1
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                beq.s   loc_332DE
                swap    d0
                divs.w  d1,d0

loc_332DE:
                move.w  d0,x_vel(a1)
                move.w  d3,y_vel(a1)
                tst.w   d1
                bpl.s   loc_332EC
                neg.w   d1

loc_332EC:
                move.w  d1,2(a4)
                rts
; ---------------------------------------------------------------------------

loc_332F2:
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                swap    d0
                divs.w  d2,d0
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                beq.s   loc_3330C
                swap    d1
                divs.w  d0,d1

loc_3330C:
                move.w  d1,y_vel(a1)
                move.w  d2,x_vel(a1)
                tst.w   d0
                bpl.s   loc_3331A
                neg.w   d0

loc_3331A:
                move.w  d0,2(a4)
                rts
; End of function InitializeCnzSpiralExitRoute

; ---------------------------------------------------------------------------
off_33320:
                dc.w    word_33328-off_33320
                dc.w    word_33336-off_33320
                dc.w    word_33344-off_33320
                dc.w    word_33352-off_33320
word_33328:     dc.w    $C
                dc.w    $1390,  $2D0
                dc.w    $1230,  $2D0
                dc.w    $1230,  $300
word_33336:     dc.w    $C
                dc.w    $13F0,  $2D0
                dc.w    $1560,  $2D0
                dc.w    $1560,  $280
word_33344:     dc.w    $C
                dc.w    $2090,  $650
                dc.w    $2030,  $650
                dc.w    $2030,  $680
word_33352:     dc.w    $C
                dc.w    $20F0,  $650
                dc.w    $21E0,  $650
                dc.w    $21E0,  $600
