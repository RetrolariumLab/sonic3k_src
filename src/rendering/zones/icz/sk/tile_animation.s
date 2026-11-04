; Owner: rendering/zones/icz/sk
; Responsibility: IceCap animated tiles, transfer timing and frame selection
; Source provenance and ranges: config/reconstruction/source_layout.json
SKICZTiles_HorizontalDmaWordCounts:
                dc.w    $100
                dc.w    0
                dc.w    $C0
                dc.w    $40
                dc.w    $80
                dc.w    $80
                dc.w    $40
                dc.w    $C0
; ---------------------------------------------------------------------------

AnimateTiles_ICZ:
                lea     (Anim_Counters).w,a3
                moveq   #0,d0
                move.w  (Events_bg+$10).w,d0
                sub.w   (Camera_X_pos_BG_copy).w,d0
                andi.w  #$1F,d0
                cmp.b   1(a3),d0
                beq.s   SKICZTiles_TryUpdateVerticalBands
                move.b  d0,1(a3)
                move.l  d0,d1
                move.w  d0,d2
                andi.w  #7,d1
                ror.w   #7,d1
                move.l  d1,d5
                andi.w  #$18,d2
                move.w  d2,d0
                lsl.w   #4,d2
                add.w   d2,d1
                lsr.w   #1,d0
                lea     SKICZTiles_HorizontalDmaWordCounts(pc,d0.w),a4
                lea     (ArtUnc_AniICZ__1).l,a0
                move.w  #tiles_to_bytes($10E),d4
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
                beq.s   SKICZTiles_TryUpdateVerticalBands
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l

; In act 1, a change in the first vertical phase triggers DMA for all four bands
SKICZTiles_TryUpdateVerticalBands:
                addq.w  #2,a3
                tst.b   (Current_act).w
                bne.w   SKICZTiles_RunScriptedTileAnims
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d1
                sub.w   (Events_bg+$12).w,d1
                neg.w   d1
                andi.w  #$3F,d1
                cmp.b   1(a3),d1
                beq.w   SKICZTiles_RunScriptedTileAnims
                move.b  d1,1(a3)
                add.w   d1,d1
                add.w   d1,d1
                addi.l  #ArtUnc_AniICZ__2,d1
                move.w  #tiles_to_bytes($122),d2
                move.w  #$80,d3
                jsr     (Add_To_DMA_Queue).l
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d1
                move.w  (Events_bg+$12).w,d0
                asr.w   #1,d0
                sub.w   d0,d1
                asr.w   #1,d0
                sub.w   d0,d1
                neg.w   d1
                andi.w  #$1F,d1
                add.w   d1,d1
                add.w   d1,d1
                addi.l  #ArtUnc_AniICZ__3,d1
                move.w  #tiles_to_bytes($12A),d2
                move.w  #$40,d3
                jsr     (Add_To_DMA_Queue).l
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d1
                move.w  (Events_bg+$12).w,d0
                asr.w   #1,d0
                sub.w   d0,d1
                neg.w   d1
                andi.w  #$F,d1
                add.w   d1,d1
                add.w   d1,d1
                addi.l  #ArtUnc_AniICZ__4,d1
                move.w  #tiles_to_bytes($12E),d2
                move.w  #$20,d3
                jsr     (Add_To_DMA_Queue).l
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d1
                move.w  (Events_bg+$12).w,d0
                asr.w   #2,d0
                sub.w   d0,d1
                neg.w   d1
                andi.w  #7,d1
                add.w   d1,d1
                add.w   d1,d1
                addi.l  #ArtUnc_AniICZ__5,d1
                move.w  #tiles_to_bytes($130),d2
                move.w  #$10,d3
                jsr     (Add_To_DMA_Queue).l

SKICZTiles_RunScriptedTileAnims:
                addq.w  #2,a3
                bra.w   SKTileScripts_RunAtCounter
; ---------------------------------------------------------------------------
; unused
                rts
