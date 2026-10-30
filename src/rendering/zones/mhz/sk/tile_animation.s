; Owner: rendering/zones/mhz/sk
; Responsibility: Mushroom Hill tile animation, counter state and timed art transfer
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

AnimateTiles_MHZ:
                lea     (Anim_Counters).w,a3
                moveq   #0,d0
                move.w  (Events_bg+$12).w,d0
                sub.w   (Camera_X_pos_BG_copy).w,d0
                andi.w  #$1F,d0
                cmp.b   1(a3),d0
                beq.s   loc_28110
                move.b  d0,1(a3)
                moveq   #0,d1
                move.w  d0,d2
                andi.w  #7,d0
                lsl.w   #8,d0
                move.w  d0,d1
                move.l  d1,d5
                andi.w  #$18,d2
                move.w  d2,d0
                lsl.w   #3,d2
                add.w   d2,d1
                lsr.w   #1,d0
                lea     word_28114(pc,d0.w),a4
                lea     (ArtUnc_AniMHZ__BG).l,a0
                move.w  #tiles_to_bytes($1B8),d4
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
                beq.s   loc_28110
                jsr     (Add_To_DMA_Queue).l

loc_28110:
                addq.w  #2,a3
                bra.s   loc_28124
; ---------------------------------------------------------------------------
word_28114:
                dc.w    $80
                dc.w    0
                dc.w    $60
                dc.w    $20
                dc.w    $40
                dc.w    $40
                dc.w    $20
                dc.w    $60
; ---------------------------------------------------------------------------

loc_28124:
                moveq   #0,d1
                move.w  (Events_bg+$10).w,d1
                sub.w   (Camera_X_pos_BG_copy).w,d1
                andi.w  #$3F,d1
                cmp.b   1(a3),d1
                beq.s   loc_28180
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
                lea     word_28198(pc,d0.w),a4
                lea     (ArtUnc_AniMHZ__BG2).l,a0
                move.w  #tiles_to_bytes($1D5),d4
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
                beq.s   loc_28180
                jsr     (Add_To_DMA_Queue).l

loc_28180:
                addq.w  #2,a3
                move.b  (Anim_Counters+$F).w,d0
                addq.b  #2,d0
                cmpi.b  #$58,d0
                blo.s   loc_28190
                moveq   #0,d0

loc_28190:
                move.b  d0,(Anim_Counters+$F).w
                bra.w   loc_286E8
; ---------------------------------------------------------------------------
word_28198:
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
; End of function AnimateTiles_MHZ
