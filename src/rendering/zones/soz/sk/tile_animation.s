; Owner: rendering/zones/soz/sk
; Responsibility: Sandopolis act-specific tile animation and frame transfer
; Source provenance and ranges: config/reconstruction/source_layout.json
word_281B8:
                dc.w    $C0
                dc.w    0
                dc.w    $90
                dc.w    $30
                dc.w    $60
                dc.w    $60
                dc.w    $30
                dc.w    $90
; ---------------------------------------------------------------------------

AnimateTiles_SOZ1:
                lea     (Anim_Counters).w,a3
                moveq   #0,d0
                move.w  (Events_bg+$10).w,d0
                sub.w   (Camera_X_pos_BG_copy).w,d0
                andi.w  #$1F,d0
                cmp.b   1(a3),d0
                beq.s   locret_2825A
                move.b  d0,1(a3)
                moveq   #0,d1
                move.w  d0,d2
                andi.w  #7,d0
                lsl.w   #7,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                move.w  d0,d1
                move.l  d1,d5
                andi.w  #$18,d2
                move.w  d2,d0
                lsl.w   #2,d2
                add.w   d2,d1
                add.w   d2,d2
                add.w   d2,d1
                lsr.w   #1,d0
                lea     word_281B8(pc,d0.w),a4
                lea     (ArtUnc_AniSOZ1_BG).l,a0
                move.w  #tiles_to_bytes($330),d4
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
                beq.s   loc_28236
                jsr     (Add_To_DMA_Queue).l

loc_28236:
                moveq   #0,d1
                move.b  1(a3),d1
                lsl.w   #6,d1
                move.w  d1,d0
                add.w   d1,d1
                add.w   d0,d1
                lea     (ArtUnc_AniSOZ1_BG2).l,a0
                add.l   a0,d1
                move.w  #tiles_to_bytes($33C),d2
                move.w  #$60,d3
                jsr     (Add_To_DMA_Queue).l

locret_2825A:
                rts
; ---------------------------------------------------------------------------

AnimateTiles_SOZ2:
                lea     (Anim_Counters).w,a3
                subq.b  #1,(a3)
                bpl.s   locret_282B2
                move.b  #7,(a3)
                moveq   #0,d0
                move.b  1(a3),d0
                addq.b  #1,1(a3)
                cmpi.b  #2,d0
                blo.s   loc_2827E
                move.b  #0,1(a3)

loc_2827E:
                move.w  (Palette_cycle_counters+$06).w,d1
                andi.w  #6,d1
                move.w  d1,d2
                lsr.w   #1,d2
                add.w   d2,d1
                cmpi.w  #6,d1
                beq.s   loc_28294
                add.w   d0,d1

loc_28294:
                lsl.w   #6,d1
                move.w  d1,d0
                add.w   d1,d1
                add.w   d0,d1
                lea     (ArtUnc_AniSOZ2_BG).l,a0
                add.l   a0,d1
                move.w  #$6600,d2
                move.w  #$60,d3
                jsr     (Add_To_DMA_Queue).l

locret_282B2:
                rts
