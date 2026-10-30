; Owner: objects/zones/dez/sk
; Responsibility: Staircase activation, coordinated block movement and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZStaircase:
                ori.b   #4,render_flags(a0)
                move.b  subtype(a0),d0
                andi.w  #7,d0
                cmpi.w  #4,d0
                blo.s   loc_47658
                bchg    #0,render_flags(a0)

loc_47658:
                btst    #1,render_flags(a0)
                beq.s   loc_47666
                bchg    #0,render_flags(a0)

loc_47666:
                moveq   #$34,d3
                moveq   #2,d4
                btst    #0,status(a0)
                beq.s   loc_47676
                moveq   #$3A,d3
                moveq   #-2,d4

loc_47676:
                move.w  x_pos(a0),d2
                movea.l a0,a1
                moveq   #3,d1
                bra.s   loc_47690
; ---------------------------------------------------------------------------

loc_47680:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_476E4
                move.l  #loc_476FE,(a1)

loc_47690:
                move.l  #Map_DEZTiltingBridge,mappings(a1)
                move.w  #make_art_tile(ArtTile_DEZMisc+$133,1,0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.w  #$180,priority(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.b  subtype(a0),subtype(a1)
                move.w  d2,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_pos(a0),$44(a1)
                move.w  y_pos(a1),$46(a1)
                addi.w  #$20,d2
                move.b  d3,$33(a1)
                move.w  a0,$3E(a1)
                add.b   d4,d3
                dbf     d1,loc_47680

loc_476E4:
                move.l  #loc_476EA,(a0)

loc_476EA:
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #7,d0
                add.w   d0,d0
                move.w  off_4773A(pc,d0.w),d1
                jsr     off_4773A(pc,d1.w)

loc_476FE:
                movea.w $3E(a0),a2
                moveq   #0,d0
                move.b  $33(a0),d0
                move.w  (a2,d0.w),d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                or.b    d6,$32(a2)
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
off_4773A:
                dc.w    loc_4774A-off_4773A
                dc.w    loc_477C2-off_4773A
                dc.w    loc_47774-off_4773A
                dc.w    loc_477C2-off_4773A
                dc.w    loc_4774A-off_4773A
                dc.w    loc_477EC-off_4773A
                dc.w    loc_47774-off_4773A
                dc.w    loc_477EC-off_4773A
; ---------------------------------------------------------------------------

loc_4774A:
                tst.w   $30(a0)
                bne.s   loc_47762
                move.b  $32(a0),d0
                andi.b  #$30,d0
                beq.s   locret_47760
                move.w  #30,$30(a0)

locret_47760:
                rts
; ---------------------------------------------------------------------------

loc_47762:
                subq.w  #1,$30(a0)
                bne.s   locret_47760
                addq.b  #1,subtype(a0)
                moveq   #signextendB(sfx_FanBig),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

loc_47774:
                tst.w   $30(a0)
                bne.s   loc_4778C
                move.b  $32(a0),d0
                andi.b  #$C,d0
                beq.s   locret_4778A
                move.w  #$3C,$30(a0)

locret_4778A:
                rts
; ---------------------------------------------------------------------------

loc_4778C:
                subq.w  #1,$30(a0)
                bne.s   loc_4779E
                addq.b  #1,subtype(a0)
                moveq   #signextendB(sfx_FanBig),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

loc_4779E:
                lea     $34(a0),a1
                move.w  $30(a0),d0
                lsr.b   #2,d0
                andi.b  #1,d0
                move.w  d0,(a1)+
                eori.b  #1,d0
                move.w  d0,(a1)+
                eori.b  #1,d0
                move.w  d0,(a1)+
                eori.b  #1,d0
                move.w  d0,(a1)+
                rts
; ---------------------------------------------------------------------------

loc_477C2:
                lea     $34(a0),a1
                cmpi.w  #$80,(a1)
                beq.s   locret_477EA
                addq.w  #1,(a1)
                moveq   #0,d1
                move.w  (a1)+,d1
                swap    d1
                lsr.l   #1,d1
                move.l  d1,d2
                lsr.l   #1,d1
                move.l  d1,d3
                add.l   d2,d3
                swap    d1
                swap    d2
                swap    d3
                move.w  d3,(a1)+
                move.w  d2,(a1)+
                move.w  d1,(a1)+

locret_477EA:
                rts
; ---------------------------------------------------------------------------

loc_477EC:
                lea     $34(a0),a1
                cmpi.w  #-$80,(a1)
                beq.s   locret_47814
                subq.w  #1,(a1)
                moveq   #0,d1
                move.w  (a1)+,d1
                swap    d1
                asr.l   #1,d1
                move.l  d1,d2
                asr.l   #1,d1
                move.l  d1,d3
                add.l   d2,d3
                swap    d1
                swap    d2
                swap    d3
                move.w  d3,(a1)+
                move.w  d2,(a1)+
                move.w  d1,(a1)+

locret_47814:
                rts
