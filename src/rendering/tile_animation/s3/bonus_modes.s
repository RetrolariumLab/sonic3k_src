; Owner: rendering/tile_animation/s3
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
                beq.s   S3DPZTiles_AdvanceToP2
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
                lea     S3DPZTiles_CyclicSplitWordCounts(pc,d0.w),a4
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
                beq.s   S3DPZTiles_AdvanceToP2
                jsr     (Add_To_DMA_Queue).l

S3DPZTiles_AdvanceToP2:
                addq.w  #2,a3
                bra.s   S3DPZTiles_UpdateP2Band
; ---------------------------------------------------------------------------
S3DPZTiles_CyclicSplitWordCounts:
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

S3DPZTiles_UpdateP2Band:
                moveq   #0,d1
                move.w  (Events_bg+$12).w,d1
                sub.w   (Camera_X_pos_P2_BG_copy).w,d1
                andi.w  #$3F,d1
                cmp.b   1(a3),d1
                beq.s   S3DPZTiles_RunRemainingScripts
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
                lea     S3DPZTiles_CyclicSplitWordCounts(pc,d0.w),a4
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
                beq.s   S3DPZTiles_RunRemainingScripts
                jsr     (Add_To_DMA_Queue).l

S3DPZTiles_RunRemainingScripts:
                addq.w  #2,a3
                bra.w   S3TileScripts_RunAtCounter
; ---------------------------------------------------------------------------

AnimateTiles_Gumball:
                lea     (Anim_Counters).w,a3
                moveq   #0,d1
                move.w  (Events_bg+$10).w,d1
                sub.w   (Camera_Y_pos_BG_copy).w,d1
                andi.w  #$1F,d1
                cmp.b   1(a3),d1
                beq.s   S3GumballTiles_UpdateReturn
                move.b  d1,1(a3)
                add.w   d1,d1
                add.w   d1,d1
                addi.l  #ArtUnc_AniGumball,d1
                move.w  #tiles_to_bytes($054),d2
                move.w  #$40,d3
                jsr     (Add_To_DMA_Queue).l

S3GumballTiles_UpdateReturn:
                rts
