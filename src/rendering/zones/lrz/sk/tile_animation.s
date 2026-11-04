; Owner: rendering/zones/lrz/sk
; Responsibility: Lava Reef tile animation, act selection, timed transfers and frame geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AnimateTiles_LRZ3:
                move.w  #tiles_to_bytes($170),d4
                move.w  #tiles_to_bytes($194),d6
                bra.s   loc_282D0
; ---------------------------------------------------------------------------

AnimateTiles_LRZ1:
                move.w  #tiles_to_bytes($320),d4
                move.w  #tiles_to_bytes($344),d6
                bra.s   loc_282D0
; ---------------------------------------------------------------------------

AnimateTiles_LRZ2:
                move.w  #tiles_to_bytes($320),d4
                move.w  #tiles_to_bytes($344),d6

loc_282D0:
                lea     (Anim_Counters).w,a3
                moveq   #0,d0
                move.w  (Events_bg+$12).w,d0
                sub.w   (Camera_X_pos_BG_copy).w,d0
                subq.w  #1,d0
                divu.w  #$30,d0
                swap    d0
                cmp.b   1(a3),d0
                beq.s   loc_2833C
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
                lea     word_2834C(pc,d0.w),a4
                lea     (ArtUnc_AniLRZ__BG).l,a0
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
                beq.s   loc_2833C
                jsr     (Add_To_DMA_Queue).l

loc_2833C:
                cmpi.b  #$16,(Current_zone).w
                beq.s   locret_2834A
                addq.w  #2,a3
                bra.w   loc_28364
; ---------------------------------------------------------------------------

locret_2834A:
                rts
; ---------------------------------------------------------------------------
word_2834C:
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

loc_28364:
                moveq   #0,d0
                move.w  (Events_bg+$10).w,d0
                sub.w   (Camera_X_pos_BG_copy).w,d0
                andi.w  #$1F,d0
                cmp.b   1(a3),d0
                beq.s   loc_283CC
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
                lea     word_283D2(pc,d0.w),a4
                lea     (ArtUnc_AniLRZ__BG2).l,a0
                move.w  d6,d4
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
                beq.s   loc_283CC
                jsr     (Add_To_DMA_Queue).l

loc_283CC:
                addq.w  #2,a3
                bra.w   SKTileScripts_RunAtCounter
; ---------------------------------------------------------------------------
word_283D2:
                dc.w    $C0
                dc.w    0
                dc.w    $90
                dc.w    $30
                dc.w    $60
                dc.w    $60
                dc.w    $30
                dc.w    $90
