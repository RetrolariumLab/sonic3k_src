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
                beq.s   SKDPZTiles_AdvanceToP2
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
                lea     SKDPZTiles_CyclicSplitWordCounts(pc,d0.w),a4
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
                beq.s   SKDPZTiles_AdvanceToP2
                jsr     (Add_To_DMA_Queue).l

SKDPZTiles_AdvanceToP2:
                addq.w  #2,a3
                bra.s   SKDPZTiles_UpdateP2Band
; ---------------------------------------------------------------------------
SKDPZTiles_CyclicSplitWordCounts:
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

SKDPZTiles_UpdateP2Band:
                moveq   #0,d1
                move.w  (Events_bg+$12).w,d1
                sub.w   (Camera_X_pos_P2_BG_copy).w,d1
                andi.w  #$3F,d1
                cmp.b   1(a3),d1
                beq.s   SKDPZTiles_RunRemainingScripts
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
                lea     SKDPZTiles_CyclicSplitWordCounts(pc,d0.w),a4
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
                beq.s   SKDPZTiles_RunRemainingScripts
                jsr     (Add_To_DMA_Queue).l

SKDPZTiles_RunRemainingScripts:
                addq.w  #2,a3
                bra.w   SKTileScripts_RunAtCounter
; ---------------------------------------------------------------------------

AnimateTiles_Gumball:
                lea     (Anim_Counters).w,a3
                moveq   #0,d1
                move.w  (Events_bg+$10).w,d1
                sub.w   (Camera_Y_pos_BG_copy).w,d1
                andi.w  #$1F,d1
                cmp.b   1(a3),d1
                beq.s   SKGumballTiles_UpdateReturn
                move.b  d1,1(a3)
                add.w   d1,d1
                add.w   d1,d1
                addi.l  #ArtUnc_AniGumball,d1
                move.w  #tiles_to_bytes($054),d2
                move.w  #$40,d3
                jsr     (Add_To_DMA_Queue).l

SKGumballTiles_UpdateReturn:
                rts
; ---------------------------------------------------------------------------

AnimateTiles_Pachinko:
                lea     (Anim_Counters).w,a4
                tst.b   2(a4)
                bne.w   SKPachinkoTiles_CompositeNextSlice
                move.w  4(a4),d0
                subq.w  #4,4(a4)
                andi.w  #$7F,4(a4)
                lea     (RAM_start+$6000).l,a2
                lea     (a2,d0.w),a2
                lea     (Chunk_table+$7000).l,a3
                move.w  #$80,d2
                moveq   #3-1,d1

SKPachinkoTiles_BeginBaseRow:
                moveq   #4-1,d0

SKPachinkoTiles_CopyBaseBlock:
                rept    32
                move.l  (a2)+,(a3)+
                endm
                lea     (a2,d2.w),a2
                dbf     d0,SKPachinkoTiles_CopyBaseBlock
                lea     $80(a3),a3
                dbf     d1,SKPachinkoTiles_BeginBaseRow
                lea     (Chunk_table+$7200).l,a3
                moveq   #0,d7
                moveq   #2,d6

SKPachinkoTiles_BeginGap:
                moveq   #3,d5

SKPachinkoTiles_PickBlendSources:
                lea     (Chunk_table+$7000).l,a1
                movea.l a1,a2
                adda.w  SKPachinkoTiles_PrimaryBlendOffsets(pc,d7.w),a1
                adda.w  SKPachinkoTiles_SecondaryBlendOffsets(pc,d7.w),a2
                moveq   #-1,d2
                moveq   #0,d3
                moveq   #8-1,d4

; Move the boundary one nibble per longword across all eight longwords
SKPachinkoTiles_BlendGapTile:
                move.l  (a1)+,d0
                and.l   d2,d0
                move.l  (a2)+,d1
                and.l   d3,d1
                or.l    d1,d0
                move.l  d0,(a3)+
                asl.l   #4,d2
                asl.l   #4,d3
                ori.w   #$F,d3
                dbf     d4,SKPachinkoTiles_BlendGapTile
                addq.w  #2,d7
                dbf     d5,SKPachinkoTiles_PickBlendSources
                lea     $200(a3),a3
                dbf     d6,SKPachinkoTiles_BeginGap
                addq.b  #1,2(a4)
                bra.s   SKPachinkoTiles_RunStandardScripts
; ---------------------------------------------------------------------------
SKPachinkoTiles_PrimaryBlendOffsets:
                dc.w    $180
                dc.w    $120
                dc.w    $C0
                dc.w    $60
; The last eight primary offsets share the first eight entries here
SKPachinkoTiles_SecondaryBlendOffsets:
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

SKPachinkoTiles_CompositeNextSlice:
                bsr.s   AniPachinko_CompositeRecoloredArtSlice
                addq.b  #1,2(a4)
                cmpi.b  #4,2(a4)
                blo.s   SKPachinkoTiles_RunStandardScripts
                move.b  #0,2(a4)
                addi.w  #$280,(a4)
                cmpi.w  #$5000,(a4)
                blo.s   SKPachinkoTiles_QueueFinishedImage
                move.w  #0,(a4)

SKPachinkoTiles_QueueFinishedImage:
                move.l  #Chunk_table+$7000,d1
                move.w  #tiles_to_bytes($0E9),d2
                move.w  #$3C0,d3
                jsr     (Add_To_DMA_Queue).l

SKPachinkoTiles_RunStandardScripts:
                lea     (AniPLC_Pachinko).l,a2
                lea     (Anim_Counters+6).w,a3
                bra.w   SKTileScripts_RunAtCounter
; ---------------------------------------------------------------------------
SKPachinkoTiles_RecolorParams:
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

AniPachinko_CompositeRecoloredArtSlice:
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
                lea     SKPachinkoTiles_RecolorParams(pc,d3.w),a1
                move.b  (a1)+,d3
                move.b  (a1)+,d4
                move.b  (a1)+,d5
                move.b  (a1)+,d6
                lea     (RAM_start+$1000).l,a1
                adda.w  (a4),a1
                move.w  #$200-1,d2

; Use additive recoloring for the first $200 source bytes
SKPachinkoTiles_AddMainOverlay:
                move.b  (a1)+,d0
                beq.s   SKPachinkoTiles_NextMainByte
                move.b  d0,d1
                andi.b  #$F0,d0
                beq.s   SKPachinkoTiles_AddMainLowNibble
                andi.b  #$F,(a3)
                add.b   d3,d0
                or.b    d0,(a3)

SKPachinkoTiles_AddMainLowNibble:
                andi.b  #$F,d1
                beq.s   SKPachinkoTiles_NextMainByte
                andi.b  #$F0,(a3)
                add.b   d4,d1
                or.b    d1,(a3)

; After the main region, process $80 bytes with class-dependent recoloring
SKPachinkoTiles_NextMainByte:
                addq.w  #1,a3
                dbf     d2,SKPachinkoTiles_AddMainOverlay
                move.w  #$80-1,d2

SKPachinkoTiles_RecolorSpecialByte:
                move.b  (a1)+,d0
                beq.s   SKPachinkoTiles_NextSpecialByte
                move.b  d0,d1
                andi.b  #$F0,d0
                beq.s   SKPachinkoTiles_RecolorSpecialLow
                bmi.s   SKPachinkoTiles_SubtractHighColor
                andi.b  #$F,(a3)
                add.b   d3,d0
                or.b    d0,(a3)
                bra.s   SKPachinkoTiles_RecolorSpecialLow
; ---------------------------------------------------------------------------

SKPachinkoTiles_SubtractHighColor:
                andi.b  #$F,(a3)
                sub.b   d5,d0
                or.b    d0,(a3)

SKPachinkoTiles_RecolorSpecialLow:
                andi.b  #$F,d1
                beq.s   SKPachinkoTiles_NextSpecialByte
                btst    #3,d1
                bne.s   SKPachinkoTiles_SubtractLowColor
                andi.b  #$F0,(a3)
                add.b   d4,d1
                or.b    d1,(a3)
                bra.s   SKPachinkoTiles_NextSpecialByte
; ---------------------------------------------------------------------------

SKPachinkoTiles_SubtractLowColor:
                andi.b  #$F0,(a3)
                sub.b   d6,d1
                or.b    d1,(a3)

SKPachinkoTiles_NextSpecialByte:
                addq.w  #1,a3
                dbf     d2,SKPachinkoTiles_RecolorSpecialByte
                rts
; End of function AniPachinko_CompositeRecoloredArtSlice
