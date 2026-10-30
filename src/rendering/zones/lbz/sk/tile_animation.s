; Owner: rendering/zones/lbz/sk
; Responsibility: Launch Base act-specific tile animation, counter setup and transfer helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AnimateTiles_LBZ1:
                lea     (Anim_Counters).w,a3
                subq.b  #1,(a3)
                bcc.s   loc_27E34
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

loc_27E34:
                addq.w  #2,a3
                moveq   #0,d0
                move.w  (Events_bg+$10).w,d0
                sub.w   (Camera_X_pos_BG_copy).w,d0
                andi.w  #$1F,d0
                cmp.b   1(a3),d0
                beq.s   loc_27EBC
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
                lea     word_27EE0(pc,d0.w),a4
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
                beq.s   loc_27EA4
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l

loc_27EA4:
                move.l  d6,d1
                lsl.w   #5,d1
                lea     (ArtUnc_AniLBZ1_2).l,a0
                add.l   a0,d1
                move.w  d4,d2
                move.w  #$10,d3
                jsr     (Add_To_DMA_Queue).l

loc_27EBC:
                addq.w  #2,a3
                tst.w   (a3)+
                bne.s   loc_27ECE
                cmpi.b  #1,1(a3)
                beq.s   loc_27ED2
                move.w  #0,(a3)

loc_27ECE:
                bsr.w   loc_286E8

loc_27ED2:
                lea     (Anim_Counters+$C).w,a3
                lea     (AniPLC_LBZSpec).l,a2
                bra.w   loc_286E8
; ---------------------------------------------------------------------------
word_27EE0:
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
                bne.s   loc_27F64
                subq.b  #1,(a3)
                bcc.s   loc_27F2A
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

loc_27F2A:
                addq.w  #2,a3
                moveq   #0,d1
                move.w  (Events_bg+$12).w,d1
                sub.w   (Camera_X_pos_BG_copy).w,d1
                andi.w  #$F,d1
                cmp.b   1(a3),d1
                beq.s   loc_27F5A
                move.b  d1,1(a3)
                lsl.w   #6,d1
                addi.l  #ArtUnc_AniLBZ2_2,d1
                move.w  #tiles_to_bytes($2E3),d2
                move.w  #$20,d3
                jsr     (Add_To_DMA_Queue).l

loc_27F5A:
                addq.w  #2,a3
                bsr.s   sub_27F66
                addq.w  #4,a3
                bra.w   loc_286E8
; ---------------------------------------------------------------------------

loc_27F64:
                addq.w  #4,a3

; =============== S U B R O U T I N E =======================================

sub_27F66:
                moveq   #0,d1
                move.w  (Events_bg+$10).w,d1
                cmp.w   (a3),d1
                beq.w   locret_28048
                move.w  d1,(a3)
                tst.w   d1
                beq.w   loc_2804A
                bpl.w   loc_27FE4
                addi.w  #$40,d1
                bcc.w   locret_28048
                lsl.w   #6,d1
                lea     (Chunk_table+$7E00).l,a4
                lea     (LBZ_WaterlineScroll_Data).l,a5
                adda.w  d1,a5
                move.w  #$40-1,d1

loc_27F9A:
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
                dbf     d1,loc_27F9A
                move.l  #Chunk_table+$7E00,d1
                move.w  #tiles_to_bytes($2C3),d2
                move.w  #$100,d3
                jsr     (Add_To_DMA_Queue).l
                tst.w   2(a3)
                beq.s   locret_27FE2
                move.w  #0,2(a3)
                bsr.w   sub_28066

locret_27FE2:
                rts
; ---------------------------------------------------------------------------

loc_27FE4:
                neg.w   d1
                addi.w  #$40,d1
                bcc.s   locret_28048
                lsl.w   #6,d1
                lea     (Chunk_table+$7E00).l,a4
                lea     (LBZ_WaterlineScroll_Data).l,a5
                adda.w  d1,a5
                move.w  #$40-1,d1

loc_28000:
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
                dbf     d1,loc_28000
                move.l  #Chunk_table+$7E00,d1
                move.w  #tiles_to_bytes($2D3),d2
                move.w  #$100,d3
                jsr     (Add_To_DMA_Queue).l
                tst.w   2(a3)
                bmi.s   locret_28046
                move.w  #-1,2(a3)
                bsr.s   sub_28052

locret_28046:
                rts
; ---------------------------------------------------------------------------

locret_28048:
                rts
; ---------------------------------------------------------------------------

loc_2804A:
                move.w  #1,2(a3)
                bsr.s   sub_28066
; End of function sub_27F66

; =============== S U B R O U T I N E =======================================

sub_28052:
                move.l  #ArtUnc_AniLBZ2_LowerBG,d1
                move.w  #tiles_to_bytes($2C3),d2
                move.w  #$100,d3
                jmp     (Add_To_DMA_Queue).l
; End of function sub_28052

; =============== S U B R O U T I N E =======================================

sub_28066:
                move.l  #ArtUnc_AniLBZ2_UpperBG,d1
                move.w  #tiles_to_bytes($2D3),d2
                move.w  #$100,d3
                jmp     (Add_To_DMA_Queue).l
; End of function sub_28066

; =============== S U B R O U T I N E =======================================

sub_2807A:
                lea     (Anim_Counters+4).w,a3
                move.w  #1,2(a3)
                move.w  (Events_bg+$10).w,d1
                beq.s   loc_2804A
                bpl.s   loc_280A6
                bsr.s   sub_28066
                move.l  #ArtUnc_AniLBZ2_WaterlineBelow,d1
                move.w  #tiles_to_bytes($2C3),d2
                move.w  #$100,d3
                jsr     (Add_To_DMA_Queue).l
                bra.w   sub_27F66
; ---------------------------------------------------------------------------

loc_280A6:
                bsr.s   sub_28052
                bra.w   sub_27F66
; End of function sub_2807A
