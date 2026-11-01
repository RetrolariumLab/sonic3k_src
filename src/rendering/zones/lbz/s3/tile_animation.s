; Owner: rendering/zones/lbz/s3
; Responsibility: Launch Base act-specific tile animation, counter setup and transfer helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AnimateTiles_LBZ1:
                lea     (Anim_Counters).w,a3
                subq.b  #1,(a3)
                bcc.s   loc_2716E
                move.b  #3,(a3)
                moveq   #0,d0
                move.b  1(a3),d0
                addq.b  #1,1(a3)
                andi.b  #$F,1(a3)
                ror.w   #7,d0
                move.l  #ArtUnc_AniLBZ__0,d1
                add.l   d0,d1
                move.w  #tiles_to_bytes($160),d2
                move.w  #$100,d3
                jsr     (Add_To_DMA_Queue).l

loc_2716E:
                addq.w  #2,a3
                moveq   #0,d0
                move.w  (Events_bg+$10).w,d0
                sub.w   (Camera_X_pos_BG_copy).w,d0
                andi.w  #$1F,d0
                cmp.b   1(a3),d0
                beq.s   loc_271F6
                move.b  d0,1(a3)
                moveq   #0,d1
                move.w  d0,d2
                andi.w  #7,d0
                move.l  d0,d6
                lsl.w   #7,d0
                move.w  d0,d1
                lsl.w   #2,d0
                add.w   d0,d1
                move.l  d1,d5
                andi.w  #$18,d2
                move.w  d2,d0
                lsl.w   #2,d2
                add.w   d2,d1
                lsl.w   #2,d2
                add.w   d2,d1
                lsr.w   #1,d0
                lea     word_2721A(pc,d0.w),a4
                lea     (ArtUnc_AniLBZ1_1).l,a0
                move.w  #tiles_to_bytes($350),d4
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
                beq.s   loc_271DE
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l

loc_271DE:
                move.l  d6,d1
                lsl.w   #5,d1
                lea     (ArtUnc_AniLBZ1_2).l,a0
                add.l   a0,d1
                move.w  d4,d2
                move.w  #$10,d3
                jsr     (Add_To_DMA_Queue).l

loc_271F6:
                addq.w  #2,a3
                tst.w   (a3)+
                bne.s   loc_27208
                cmpi.b  #1,1(a3)
                beq.s   loc_2720C
                move.w  #0,(a3)

loc_27208:
                bsr.w   loc_275F0

loc_2720C:
                lea     (Anim_Counters+$C).w,a3
                lea     (AniPLC_LBZSpec).l,a2
                bra.w   loc_275F0
; ---------------------------------------------------------------------------
word_2721A:
                dc.w    $140
                dc.w    0
                dc.w    $F0
                dc.w    $50
                dc.w    $A0
                dc.w    $A0
                dc.w    $50
                dc.w    $F0
; ---------------------------------------------------------------------------

AnimateTiles_LBZ2:
                lea     (Anim_Counters).w,a3
                tst.b   $F(a3)
                bne.s   loc_2729E
                subq.b  #1,(a3)
                bcc.s   loc_27264
                move.b  #3,(a3)
                moveq   #0,d0
                move.b  1(a3),d0
                addq.b  #1,1(a3)
                andi.b  #$F,1(a3)
                ror.w   #7,d0
                move.l  #ArtUnc_AniLBZ__0,d1
                add.l   d0,d1
                move.w  #tiles_to_bytes($160),d2
                move.w  #$100,d3
                jsr     (Add_To_DMA_Queue).l

loc_27264:
                addq.w  #2,a3
                moveq   #0,d1
                move.w  (Events_bg+$12).w,d1
                sub.w   (Camera_X_pos_BG_copy).w,d1
                andi.w  #$F,d1
                cmp.b   1(a3),d1
                beq.s   loc_27294
                move.b  d1,1(a3)
                lsl.w   #6,d1
                addi.l  #ArtUnc_AniLBZ2_2,d1
                move.w  #tiles_to_bytes($2E3),d2
                move.w  #$20,d3
                jsr     (Add_To_DMA_Queue).l

loc_27294:
                addq.w  #2,a3
                bsr.s   AniLBZ2_UpdateWaterlineTiles
                addq.w  #4,a3
                bra.w   loc_275F0
; ---------------------------------------------------------------------------

loc_2729E:
                addq.w  #4,a3

; =============== S U B R O U T I N E =======================================

AniLBZ2_UpdateWaterlineTiles:
                moveq   #0,d1
                move.w  (Events_bg+$10).w,d1
                cmp.w   (a3),d1
                beq.w   locret_27382
                move.w  d1,(a3)
                tst.w   d1
                beq.w   loc_27384
                bpl.w   loc_2731E
                addi.w  #$40,d1
                bcc.w   locret_27382
                lsl.w   #6,d1
                lea     (Chunk_table+$7E00).l,a4
                lea     (LBZ_WaterlineScroll_Data).l,a5
                adda.w  d1,a5
                move.w  #$40-1,d1

loc_272D4:
                moveq   #0,d0
                move.b  (a5)+,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (ArtUnc_AniLBZ2_WaterlineBelow).l,a0
                adda.w  d0,a0
                move.l  (a0),(a4)
                lea     $100(a0),a0
                lea     $100(a4),a4
                move.l  (a0),(a4)
                lea     -$FC(a4),a4
                dbf     d1,loc_272D4
                move.l  #Chunk_table+$7E00,d1
                move.w  #tiles_to_bytes($2C3),d2
                move.w  #$100,d3
                jsr     (Add_To_DMA_Queue).l
                tst.w   2(a3)
                beq.s   locret_2731C
                move.w  #0,2(a3)
                bsr.w   AniLBZ2_RestoreUpperBackground

locret_2731C:
                rts
; ---------------------------------------------------------------------------

loc_2731E:
                neg.w   d1
                addi.w  #$40,d1
                bcc.s   locret_27382
                lsl.w   #6,d1
                lea     (Chunk_table+$7E00).l,a4
                lea     (LBZ_WaterlineScroll_Data).l,a5
                adda.w  d1,a5
                move.w  #$40-1,d1

loc_2733A:
                moveq   #0,d0
                move.b  (a5)+,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (ArtUnc_AniLBZ2_WaterlineAbove).l,a0
                adda.w  d0,a0
                move.l  (a0),(a4)
                lea     $100(a0),a0
                lea     $100(a4),a4
                move.l  (a0),(a4)
                lea     -$FC(a4),a4
                dbf     d1,loc_2733A
                move.l  #Chunk_table+$7E00,d1
                move.w  #tiles_to_bytes($2D3),d2
                move.w  #$100,d3
                jsr     (Add_To_DMA_Queue).l
                tst.w   2(a3)
                bmi.s   locret_27380
                move.w  #-1,2(a3)
                bsr.s   AniLBZ2_RestoreLowerBackground

locret_27380:
                rts
; ---------------------------------------------------------------------------

locret_27382:
                rts
; ---------------------------------------------------------------------------

loc_27384:
                move.w  #1,2(a3)
                bsr.s   AniLBZ2_RestoreUpperBackground
; End of function AniLBZ2_UpdateWaterlineTiles

; =============== S U B R O U T I N E =======================================

AniLBZ2_RestoreLowerBackground:
                move.l  #ArtUnc_AniLBZ2_LowerBG,d1
                move.w  #tiles_to_bytes($2C3),d2
                move.w  #$100,d3
                jmp     (Add_To_DMA_Queue).l
; End of function AniLBZ2_RestoreLowerBackground

; =============== S U B R O U T I N E =======================================

AniLBZ2_RestoreUpperBackground:
                move.l  #ArtUnc_AniLBZ2_UpperBG,d1
                move.w  #tiles_to_bytes($2D3),d2
                move.w  #$100,d3
                jmp     (Add_To_DMA_Queue).l
; End of function AniLBZ2_RestoreUpperBackground

; =============== S U B R O U T I N E =======================================

AniLBZ2_InitWaterlineTiles:
                lea     (Anim_Counters+4).w,a3
                move.w  #1,2(a3)
                move.w  (Events_bg+$10).w,d1
                beq.s   loc_27384
                bpl.s   loc_273CC
                bsr.s   AniLBZ2_RestoreUpperBackground
                bra.w   AniLBZ2_UpdateWaterlineTiles
; ---------------------------------------------------------------------------

loc_273CC:
                bsr.s   AniLBZ2_RestoreLowerBackground
                bra.w   AniLBZ2_UpdateWaterlineTiles
; End of function AniLBZ2_InitWaterlineTiles
