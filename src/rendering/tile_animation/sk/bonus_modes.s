; Owner: rendering/tile_animation/sk
; Responsibility: Bonus-mode tile animation and frame transfers with product-specific bonus machines
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AnimateTiles_DPZ:
                lea     (Anim_Counters).w,a3
                moveq   #0,d1
                move.w  (Events_bg+$10).w,d1
                sub.w   (Camera_X_pos_BG_copy).w,d1
                andi.w  #$3F,d1
                cmp.b   1(a3),d1
                beq.s   loc_28442
                move.b  d1,1(a3)
                move.w  d1,d2
                andi.w  #7,d1
                ror.w   #6,d1
                move.l  d1,d5
                andi.w  #$38,d2
                move.w  d2,d0
                lsl.w   #4,d2
                add.w   d2,d1
                lsr.w   #1,d0
                lea     word_28446(pc,d0.w),a4
                lea     (ArtUnc_AniDPZ__BG).l,a0
                move.w  #tiles_to_bytes($153),d4
                add.l   a0,d1
                move.w  d4,d2
                move.w  (a4)+,d3
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                move.l  d5,d1
                add.l   a0,d1
                move.w  d4,d2
                move.w  (a4)+,d3
                beq.s   loc_28442
                jsr     (Add_To_DMA_Queue).l

loc_28442:
                addq.w  #2,a3
                bra.s   loc_28466
; ---------------------------------------------------------------------------
word_28446:
                dc.w    $200
                dc.w    0
                dc.w    $1C0
                dc.w    $40
                dc.w    $180
                dc.w    $80
                dc.w    $140
                dc.w    $C0
                dc.w    $100
                dc.w    $100
                dc.w    $C0
                dc.w    $140
                dc.w    $80
                dc.w    $180
                dc.w    $40
                dc.w    $1C0
; ---------------------------------------------------------------------------

loc_28466:
                moveq   #0,d1
                move.w  (Events_bg+$12).w,d1
                sub.w   (Camera_X_pos_P2_BG_copy).w,d1
                andi.w  #$3F,d1
                cmp.b   1(a3),d1
                beq.s   loc_284C2
                move.b  d1,1(a3)
                move.w  d1,d2
                andi.w  #7,d1
                ror.w   #6,d1
                move.l  d1,d5
                andi.w  #$38,d2
                move.w  d2,d0
                lsl.w   #4,d2
                add.w   d2,d1
                lsr.w   #1,d0
                lea     word_28446(pc,d0.w),a4
                lea     (ArtUnc_AniDPZ__BG).l,a0
                move.w  #tiles_to_bytes($173),d4
                add.l   a0,d1
                move.w  d4,d2
                move.w  (a4)+,d3
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                move.l  d5,d1
                add.l   a0,d1
                move.w  d4,d2
                move.w  (a4)+,d3
                beq.s   loc_284C2
                jsr     (Add_To_DMA_Queue).l

loc_284C2:
                addq.w  #2,a3
                bra.w   loc_286E8
; ---------------------------------------------------------------------------

AnimateTiles_Gumball:
                lea     (Anim_Counters).w,a3
                moveq   #0,d1
                move.w  (Events_bg+$10).w,d1
                sub.w   (Camera_Y_pos_BG_copy).w,d1
                andi.w  #$1F,d1
                cmp.b   1(a3),d1
                beq.s   locret_284FC
                move.b  d1,1(a3)
                add.w   d1,d1
                add.w   d1,d1
                addi.l  #ArtUnc_AniGumball,d1
                move.w  #tiles_to_bytes($054),d2
                move.w  #$40,d3
                jsr     (Add_To_DMA_Queue).l

locret_284FC:
                rts
; ---------------------------------------------------------------------------

AnimateTiles_Pachinko:
                lea     (Anim_Counters).w,a4
                tst.b   2(a4)
                bne.w   loc_285EE
                move.w  4(a4),d0
                subq.w  #4,4(a4)
                andi.w  #$7F,4(a4)
                lea     (RAM_start+$6000).l,a2
                lea     (a2,d0.w),a2
                lea     (Chunk_table+$7000).l,a3
                move.w  #$80,d2
                moveq   #3-1,d1

loc_2852E:
                moveq   #4-1,d0

loc_28530:
                rept    32
                move.l  (a2)+,(a3)+
                endm
                lea     (a2,d2.w),a2
                dbf     d0,loc_28530
                lea     $80(a3),a3
                dbf     d1,loc_2852E
                lea     (Chunk_table+$7200).l,a3
                moveq   #0,d7
                moveq   #2,d6

loc_2858A:
                moveq   #3,d5

loc_2858C:
                lea     (Chunk_table+$7000).l,a1
                movea.l a1,a2
                adda.w  word_285CE(pc,d7.w),a1
                adda.w  word_285D6(pc,d7.w),a2
                moveq   #-1,d2
                moveq   #0,d3
                moveq   #8-1,d4

loc_285A2:
                move.l  (a1)+,d0
                and.l   d2,d0
                move.l  (a2)+,d1
                and.l   d3,d1
                or.l    d1,d0
                move.l  d0,(a3)+
                asl.l   #4,d2
                asl.l   #4,d3
                ori.w   #$F,d3
                dbf     d4,loc_285A2
                addq.w  #2,d7
                dbf     d5,loc_2858C
                lea     $200(a3),a3
                dbf     d6,loc_2858A
                addq.b  #1,2(a4)
                bra.s   loc_28624
; ---------------------------------------------------------------------------
word_285CE:
                dc.w    $180
                dc.w    $120
                dc.w    $C0
                dc.w    $60
word_285D6:
                dc.w    $400
                dc.w    $3A0
                dc.w    $340
                dc.w    $2E0
                dc.w    $680
                dc.w    $620
                dc.w    $5C0
                dc.w    $560
                dc.w    $180
                dc.w    $120
                dc.w    $C0
                dc.w    $60
; ---------------------------------------------------------------------------

loc_285EE:
                bsr.s   sub_2863E
                addq.b  #1,2(a4)
                cmpi.b  #4,2(a4)
                blo.s   loc_28624
                move.b  #0,2(a4)
                addi.w  #$280,(a4)
                cmpi.w  #$5000,(a4)
                blo.s   loc_28610
                move.w  #0,(a4)

loc_28610:
                move.l  #Chunk_table+$7000,d1
                move.w  #tiles_to_bytes($0E9),d2
                move.w  #$3C0,d3
                jsr     (Add_To_DMA_Queue).l

loc_28624:
                lea     (AniPLC_Pachinko).l,a2
                lea     (Anim_Counters+6).w,a3
                bra.w   loc_286E8
; ---------------------------------------------------------------------------
byte_28632:
                dc.b    $50
                dc.b    5
                dc.b    $A0
                dc.b    $A
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    $A0
                dc.b    $A
                dc.b    $50
                dc.b    5
                even

; =============== S U B R O U T I N E =======================================

sub_2863E:
                lea     (Chunk_table+$7000).l,a3
                moveq   #0,d0
                move.b  2(a4),d0
                subq.b  #1,d0
                move.w  d0,d3
                lsl.w   #7,d0
                move.w  d0,d1
                lsl.w   #2,d0
                add.w   d1,d0
                adda.w  d0,a3
                lsl.w   #2,d3
                lea     byte_28632(pc,d3.w),a1
                move.b  (a1)+,d3
                move.b  (a1)+,d4
                move.b  (a1)+,d5
                move.b  (a1)+,d6
                lea     (RAM_start+$1000).l,a1
                adda.w  (a4),a1
                move.w  #$200-1,d2

loc_28672:
                move.b  (a1)+,d0
                beq.s   loc_28694
                move.b  d0,d1
                andi.b  #$F0,d0
                beq.s   loc_28686
                andi.b  #$F,(a3)
                add.b   d3,d0
                or.b    d0,(a3)

loc_28686:
                andi.b  #$F,d1
                beq.s   loc_28694
                andi.b  #$F0,(a3)
                add.b   d4,d1
                or.b    d1,(a3)

loc_28694:
                addq.w  #1,a3
                dbf     d2,loc_28672
                move.w  #$80-1,d2

loc_2869E:
                move.b  (a1)+,d0
                beq.s   loc_286DC
                move.b  d0,d1
                andi.b  #$F0,d0
                beq.s   loc_286BE
                bmi.s   loc_286B6
                andi.b  #$F,(a3)
                add.b   d3,d0
                or.b    d0,(a3)
                bra.s   loc_286BE
; ---------------------------------------------------------------------------

loc_286B6:
                andi.b  #$F,(a3)
                sub.b   d5,d0
                or.b    d0,(a3)

loc_286BE:
                andi.b  #$F,d1
                beq.s   loc_286DC
                btst    #3,d1
                bne.s   loc_286D4
                andi.b  #$F0,(a3)
                add.b   d4,d1
                or.b    d1,(a3)
                bra.s   loc_286DC
; ---------------------------------------------------------------------------

loc_286D4:
                andi.b  #$F0,(a3)
                sub.b   d6,d1
                or.b    d1,(a3)

loc_286DC:
                addq.w  #1,a3
                dbf     d2,loc_2869E
                rts
; End of function sub_2863E
