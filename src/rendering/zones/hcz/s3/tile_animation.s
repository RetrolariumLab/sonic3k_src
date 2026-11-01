; Owner: rendering/zones/hcz/s3
; Responsibility: Hydrocity tile and background animation, scrolling fixes and act-specific transfer logic
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AnimateTiles_HCZ1:
                tst.b   (Events_bg+$16).w
                beq.s   loc_26BC2
                rts
; ---------------------------------------------------------------------------
; This section determines which tiles to load at what position to simulate a
; waterline extending into the background
; ---------------------------------------------------------------------------

loc_26BC2:
                lea     (Anim_Counters+4).w,a3

loc_26BC6:
                moveq   #0,d1
                move.w  (Events_bg+$10).w,d1
                cmp.w   (a3),d1
                beq.w   loc_26CB4
                move.w  d1,(a3)
                tst.w   d1
                beq.w   loc_26CB8
                bpl.w   loc_26C4C
                addi.w  #$60,d1
                bcc.w   loc_26CB4
                move.w  d1,d0
                add.w   d1,d1
                add.w   d0,d1
                lsl.w   #5,d1
                lea     (Chunk_table+$7C00).l,a4
                lea     (HCZ_WaterlineScroll_Data).l,a5
                adda.w  d1,a5
                move.w  #$60-1,d1

loc_26C00:
                moveq   #0,d0
                move.b  (a5)+,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (ArtUnc_AniHCZ1_WaterlineBelow).l,a0
                adda.w  d0,a0
                move.l  (a0),(a4)
                lea     $600(a0),a0
                lea     $180(a4),a4
                move.l  (a0),(a4)
                lea     -$17C(a4),a4
                dbf     d1,loc_26C00
                move.l  #Chunk_table+$7C00,d1
                move.w  #tiles_to_bytes($2DC),d2
                move.w  #$180,d3
                jsr     (Add_To_DMA_Queue).l
                tst.w   2(a3)
                bmi.s   loc_26C48
                move.w  #-1,2(a3)
                bsr.w   AniHCZ_FixLowerBG

loc_26C48:
                bra.w   loc_26CB4
; ---------------------------------------------------------------------------

loc_26C4C:
                neg.w   d1
                addi.w  #$60,d1
                bcc.s   loc_26CB4
                move.w  d1,d0
                add.w   d1,d1
                add.w   d0,d1
                lsl.w   #5,d1
                lea     (Chunk_table+$7C00).l,a4
                lea     (HCZ_WaterlineScroll_Data).l,a5
                adda.w  d1,a5
                move.w  #$60-1,d1

loc_26C6E:
                moveq   #0,d0
                move.b  (a5)+,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (ArtUnc_AniHCZ1_WaterlineAbove).l,a0
                adda.w  d0,a0
                move.l  (a0),(a4)
                lea     $600(a0),a0
                lea     $180(a4),a4
                move.l  (a0),(a4)
                lea     -$17C(a4),a4
                dbf     d1,loc_26C6E
                move.l  #Chunk_table+$7C00,d1
                move.w  #tiles_to_bytes($2F4),d2
                move.w  #$180,d3
                jsr     (Add_To_DMA_Queue).l
                tst.w   2(a3)
                beq.s   loc_26CB4
                move.w  #0,2(a3)
                bsr.s   AniHCZ_FixUpperBG

loc_26CB4:
                bra.w   AnimateTiles_DoAniPLC
; ---------------------------------------------------------------------------

loc_26CB8:
                move.w  #1,(a3)
                bsr.s   AniHCZ_FixLowerBG

; ---------------------------------------------------------------------------
; When the special waterline goes below water, this routine loads tiles to
; fix the background area that was affected when the waterline was above
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

AniHCZ_FixUpperBG:
                move.l  #ArtUnc_FixHCZ1_UpperBG1,d1
                move.w  #tiles_to_bytes($2DC),d2
                move.w  #$C0,d3
                jsr     (Add_To_DMA_Queue).l
                move.l  #ArtUnc_FixHCZ1_UpperBG2,d1
                move.w  #tiles_to_bytes($2E8),d2
                move.w  #$C0,d3
                jmp     (Add_To_DMA_Queue).l
; End of function AniHCZ_FixUpperBG

; ---------------------------------------------------------------------------
; When the special waterline goes above water, this routine loads tiles to
; fix the background area that was affected when the waterline was below
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

AniHCZ_FixLowerBG:
                move.l  #ArtUnc_FixHCZ1_LowerBG1,d1
                move.w  #tiles_to_bytes($2F4),d2
                move.w  #$C0,d3
                jsr     (Add_To_DMA_Queue).l
                move.l  #ArtUnc_FixHCZ1_LowerBG2,d1
                move.w  #tiles_to_bytes($300),d2
                move.w  #$C0,d3
                jmp     (Add_To_DMA_Queue).l
; End of function AniHCZ_FixLowerBG

; =============== S U B R O U T I N E =======================================

AniHCZ1_InitWaterlineTiles:
                lea     (AniPLC_HCZ1).l,a2
                lea     (Anim_Counters+4).w,a3
                move.w  (Events_bg+$10).w,d1
                beq.s   loc_26CB8
                bpl.s   loc_26D56
                addi.w  #$60,d1
                bcc.s   loc_26D2C
                bsr.s   AniHCZ_FixLowerBG
                bra.w   loc_26BC6
; ---------------------------------------------------------------------------

loc_26D2C:
                bsr.s   AniHCZ_FixLowerBG
                move.l  #ArtUnc_AniHCZ1_WaterlineBelow,d1
                move.w  #tiles_to_bytes($2DC),d2
                move.w  #$C0,d3
                jsr     (Add_To_DMA_Queue).l
                move.l  #ArtUnc_AniHCZ1_WaterlineBelow2,d1
                move.w  #tiles_to_bytes($2E8),d2
                move.w  #$C0,d3
                jmp     (Add_To_DMA_Queue).l
; ---------------------------------------------------------------------------

loc_26D56:
                neg.w   d1
                addi.w  #$60,d1
                bcc.s   loc_26D66
                bsr.w   AniHCZ_FixUpperBG
                bra.w   loc_26BC6
; ---------------------------------------------------------------------------

loc_26D66:
                bsr.w   AniHCZ_FixUpperBG
                move.l  #ArtUnc_AniHCZ1_WaterlineAbove,d1
                move.w  #tiles_to_bytes($2F4),d2
                move.w  #$C0,d3
                jsr     (Add_To_DMA_Queue).l
                move.l  #ArtUnc_AniHCZ1_WaterlineAbove2,d1
                move.w  #tiles_to_bytes($300),d2
                move.w  #$C0,d3
                jmp     (Add_To_DMA_Queue).l
; End of function AniHCZ1_InitWaterlineTiles

; ---------------------------------------------------------------------------

AnimateTiles_HCZ2:
                lea     (Anim_Counters).w,a3
                moveq   #0,d1
                move.w  (Events_bg+$12).w,d1
                andi.w  #$1F,d1
                cmp.b   1(a3),d1
                beq.s   loc_26DEE
                move.b  d1,1(a3)
                move.w  d1,d2
                andi.w  #7,d1
                lsl.w   #7,d1
                move.l  d1,d5
                andi.w  #$18,d2
                move.w  d2,d0
                lsl.w   #2,d2
                add.w   d2,d1
                lsr.w   #1,d0
                lea     word_26DF2(pc,d0.w),a4
                lea     (ArtUnc_AniHCZ2_SmallBGLine).l,a0
                move.w  #tiles_to_bytes($2D2),d4
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
                beq.s   loc_26DEE
                jsr     (Add_To_DMA_Queue).l

loc_26DEE:
                addq.w  #2,a3
                bra.s   loc_26E02
; ---------------------------------------------------------------------------
word_26DF2:
                dc.w    $40
                dc.w    0
                dc.w    $30
                dc.w    $10
                dc.w    $20
                dc.w    $20
                dc.w    $10
                dc.w    $30
; ---------------------------------------------------------------------------

loc_26E02:
                moveq   #0,d1
                move.w  (Events_bg+$12).w,d1
                andi.w  #$1F,d1
                cmp.b   1(a3),d1
                beq.s   loc_26E5A
                move.b  d1,1(a3)
                move.w  d1,d2
                andi.w  #7,d1
                lsl.w   #8,d1
                move.l  d1,d5
                andi.w  #$18,d2
                move.w  d2,d0
                lsl.w   #3,d2
                add.w   d2,d1
                lsr.w   #1,d0
                lea     word_26E5E(pc,d0.w),a4
                lea     (ArtUnc_AniHCZ2_2).l,a0
                move.w  #tiles_to_bytes($2D6),d4
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
                beq.s   loc_26E5A
                jsr     (Add_To_DMA_Queue).l

loc_26E5A:
                addq.w  #2,a3
                bra.s   loc_26E6E
; ---------------------------------------------------------------------------
word_26E5E:
                dc.w    $80
                dc.w    0
                dc.w    $60
                dc.w    $20
                dc.w    $40
                dc.w    $40
                dc.w    $20
                dc.w    $60
; ---------------------------------------------------------------------------

loc_26E6E:
                moveq   #0,d1
                move.w  (Events_bg+$14).w,d1
                andi.w  #$1F,d1
                cmp.b   1(a3),d1
                beq.s   loc_26EC6
                move.b  d1,1(a3)
                move.w  d1,d2
                andi.w  #7,d1
                ror.w   #7,d1
                move.l  d1,d5
                andi.w  #$18,d2
                move.w  d2,d0
                lsl.w   #4,d2
                add.w   d2,d1
                lsr.w   #1,d0
                lea     word_26ECA(pc,d0.w),a4
                lea     (ArtUnc_AniHCZ2_3).l,a0
                move.w  #tiles_to_bytes($2DE),d4
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
                beq.s   loc_26EC6
                jsr     (Add_To_DMA_Queue).l

loc_26EC6:
                addq.w  #2,a3
                bra.s   loc_26EDA
; ---------------------------------------------------------------------------
word_26ECA:
                dc.w    $100
                dc.w    0
                dc.w    $C0
                dc.w    $40
                dc.w    $80
                dc.w    $80
                dc.w    $40
                dc.w    $C0
; ---------------------------------------------------------------------------

loc_26EDA:
                moveq   #0,d1
                move.w  (Events_bg+$14).w,d1
                andi.w  #$3F,d1
                cmp.b   1(a3),d1
                beq.s   loc_26F40
                move.b  d1,1(a3)
                neg.w   d1
                move.w  d1,d2
                andi.w  #7,d1
                ror.w   #7,d1
                move.w  d1,d0
                add.w   d0,d0
                add.w   d0,d1
                move.l  d1,d5
                not.w   d2
                andi.w  #$38,d2
                move.w  d2,d0
                lsl.w   #3,d2
                add.w   d2,d1
                add.w   d2,d2
                add.w   d2,d1
                lsr.w   #1,d0
                lea     word_26F46(pc,d0.w),a4
                lea     (ArtUnc_AniHCZ2_4).l,a0
                move.w  #tiles_to_bytes($2EE),d4
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
                beq.s   loc_26F40
                jsr     (Add_To_DMA_Queue).l

loc_26F40:
                addq.w  #2,a3
                bra.w   loc_275F0
; ---------------------------------------------------------------------------
word_26F46:
                dc.w    $300
                dc.w    0
                dc.w    $2A0
                dc.w    $60
                dc.w    $240
                dc.w    $C0
                dc.w    $1E0
                dc.w    $120
                dc.w    $180
                dc.w    $180
                dc.w    $120
                dc.w    $1E0
                dc.w    $C0
                dc.w    $240
                dc.w    $60
                dc.w    $2A0
