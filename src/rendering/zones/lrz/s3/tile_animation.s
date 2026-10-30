; Owner: rendering/zones/lrz/s3
; Responsibility: Lava Reef tile animation, act selection, timed transfers and frame geometry
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

AnimateTiles_LRZ1:
                lea     (Anim_Counters).w,a3
                moveq   #0,d0
                move.w  (Events_bg+$12).w,d0
                sub.w   (Camera_X_pos_BG_copy).w,d0
                divu.w  #$30,d0
                swap    d0
                cmp.b   1(a3),d0
                beq.s   loc_27440
                move.b  d0,1(a3)
                moveq   #0,d1
                move.w  d0,d2
                andi.w  #7,d0
                lsl.w   #7,d0
                move.w  d0,d1
                lsl.w   #3,d0
                add.w   d0,d1
                move.l  d1,d5
                andi.w  #$38,d2
                move.w  d2,d0
                lsl.w   #3,d2
                add.w   d2,d1
                add.w   d2,d2
                add.w   d2,d1
                lsr.w   #1,d0
                lea     word_27446(pc,d0.w),a4
                lea     (ArtUnc_AniLRZ__BG).l,a0
                move.w  #tiles_to_bytes($301),d4
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
                beq.s   loc_27440
                jsr     (Add_To_DMA_Queue).l

loc_27440:
                addq.w  #2,a3
                bra.w   loc_2745E
; ---------------------------------------------------------------------------
word_27446:
                dc.w    $240
                dc.w    0
                dc.w    $1E0
                dc.w    $60
                dc.w    $180
                dc.w    $C0
                dc.w    $120
                dc.w    $120
                dc.w    $C0
                dc.w    $180
                dc.w    $60
                dc.w    $1E0
; ---------------------------------------------------------------------------

loc_2745E:
                moveq   #0,d0
                move.w  (Events_bg+$10).w,d0
                sub.w   (Camera_X_pos_BG_copy).w,d0
                andi.w  #$1F,d0
                cmp.b   1(a3),d0
                beq.s   locret_274BE
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
                lea     word_274C0(pc,d0.w),a4
                lea     (ArtUnc_AniLRZ__BG2).l,a0
                move.w  #tiles_to_bytes($325),d4
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
                beq.s   locret_274BE
                jsr     (Add_To_DMA_Queue).l

locret_274BE:
                rts
; ---------------------------------------------------------------------------
word_274C0:
                dc.w    $80
                dc.w    0
                dc.w    $60
                dc.w    $20
                dc.w    $40
                dc.w    $40
                dc.w    $20
                dc.w    $60
