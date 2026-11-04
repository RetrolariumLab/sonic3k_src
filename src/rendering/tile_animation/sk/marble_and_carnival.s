; Owner: rendering/tile_animation/sk
; Responsibility: Marble Garden and Carnival Night tile-animation dispatch and timed frame transfers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AnimateTiles_MGZ:
                tst.b   (Boss_flag).w
                beq.w   AnimateTiles_DoAniPLC
                rts
; ---------------------------------------------------------------------------

AnimateTiles_CNZ:
                lea     (Anim_Counters).w,a3
                moveq   #0,d1
                move.w  (Events_bg+$10).w,d1
                sub.w   (Camera_X_pos_BG_copy).w,d1
                andi.w  #$3F,d1
                cmp.b   1(a3),d1
                beq.s   SKCNZTiles_SkipSlotAndRunScripts
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
                lea     SKCNZTiles_CyclicSplitWordCounts(pc,d0.w),a4
                lea     (ArtUnc_AniCNZ__6).l,a0
                move.w  #tiles_to_bytes($308),d4
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
                beq.s   SKCNZTiles_SkipSlotAndRunScripts
                jsr     (Add_To_DMA_Queue).l

SKCNZTiles_SkipSlotAndRunScripts:
                addq.w  #2,a3
                bra.w   SKTileScripts_RunAtCounter
; ---------------------------------------------------------------------------
SKCNZTiles_CyclicSplitWordCounts:
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
