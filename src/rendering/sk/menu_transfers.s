; Owner: rendering/sk
; Responsibility: Menu art decompression, listed map and VRAM transfers and shared menu display helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
KosArt_To_VDP:
                movea.l a1,a3                           ; a1 will be changed by Kos_Decomp, so we're backing it up to a3
                jsr     (Kos_Decomp).l

                move.l  a3,d1                           ; move the backed-up a1 to d1
                andi.l  #$FFFFFF,d1                     ; d1 will be used in the DMA transfer as the Source Address

                move.l  a1,d3                           ; move end address of decompressed art to d3
                sub.l   a3,d3                           ; subtract 'start address of decompressed art' from 'end address of decompressed art', giving you the size of the decompressed art
                lsr.l   #1,d3                           ; divide size of decompressed art by two, d3 will be used in the DMA transfer as the Transfer Length (size/2)

                move.w  a2,d2                           ; move VRAM address to d2, d2 will be used in the DMA transfer as the Destination Address

                movea.l a1,a3                           ; backup a1, this allows the same address to be used by multiple calls to KosArt_To_VDP without constant redefining
                jsr     (Add_To_DMA_Queue).l            ; transfer *Transfer Length* of data from *Source Address* to *Destination Address*
                movea.l a3,a1                           ; restore a1
                rts
; End of function KosArt_To_VDP

; =============== S U B R O U T I N E =======================================

Menu_FillPlaneAWithPriorityBlankTiles:
                move.l  #$80008000,d0
                move.w  #bytesToLcnt($2000),d1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),(VDP_control_port).l
                lea     (VDP_data_port).l,a6

                .loop:
                move.l  d0,(a6)
                dbf     d1,.loop
                rts
; End of function Menu_FillPlaneAWithPriorityBlankTiles

; =============== S U B R O U T I N E =======================================

Menu_ClearNineByEightTileArea:
                moveq   #8-1,d2
                lea     (VDP_data_port).l,a6
                moveq   #0,d1

                .loop:
                move.w  d0,d3
                bsr.s   Menu_WriteNineTileWords
                addi.w  #$80,d0
                andi.w  #$DFFF,d0
                dbf     d2,.loop
                rts
; End of function Menu_ClearNineByEightTileArea

; =============== S U B R O U T I N E =======================================

Menu_WriteNineTileWords:
                swap    d3
                clr.w   d3
                swap    d3
                lsl.l   #2,d3
                lsr.w   #2,d3
                ori.w   #$4000,d3
                swap    d3
                move.l  d3,VDP_control_port-VDP_data_port(a6)
                move.l  d1,(a6)
                move.l  d1,(a6)
                move.l  d1,(a6)
                move.l  d1,(a6)
                move.w  d1,(a6)
                rts
; End of function Menu_WriteNineTileWords

; =============== S U B R O U T I N E =======================================

Copy_Listed_Data_To_VRAM:
                move.w  (a0)+,d7

                .loop:
                movea.l (a0)+,a1
                move.w  (a0)+,d0
                swap    d0
                clr.w   d0
                swap    d0
                lsl.l   #2,d0
                lsr.w   #2,d0
                ori.w   #$4000,d0
                swap    d0
                move.w  (a0)+,d1
                move.w  (a0)+,d2
                jsr     (Plane_Map_To_VRAM).l
                dbf     d7,.loop
                rts
; End of function Copy_Listed_Data_To_VRAM

; =============== S U B R O U T I N E =======================================

Menu_UpdateBothCharacterDepthGroups:
                lea     (Dynamic_object_RAM).w,a0
                bsr.s   Menu_SetCharacterGroupDepthPriorities
                lea     (Dynamic_object_RAM+(object_size*5)).w,a0
; End of function Menu_UpdateBothCharacterDepthGroups

; =============== S U B R O U T I N E =======================================

Menu_SetCharacterGroupDepthPriorities:
                lea     next_object(a0),a1
                lea     next_object(a1),a2
                bsr.s   Menu_CompareSwapCharacterDepths
                bsr.s   Menu_CompareSwapCharacterDepths
                move.w  #$80,priority(a0)
                move.w  #$100,priority(a1)
                move.w  #$180,priority(a2)
                bset    #7,art_tile(a0)
                bclr    #7,art_tile(a1)
                bclr    #7,art_tile(a2)
                rts
; End of function Menu_SetCharacterGroupDepthPriorities

; =============== S U B R O U T I N E =======================================

Menu_CompareSwapCharacterDepths:
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bgt.s   SKMenuDepth_CompareAndSwapA1A2
                exg     a0,a1

SKMenuDepth_CompareAndSwapA1A2:
                move.w  y_pos(a1),d0
                cmp.w   y_pos(a2),d0
                bgt.s   SKMenuDepth_Return
                exg     a1,a2

SKMenuDepth_Return:
                rts
; End of function Menu_CompareSwapCharacterDepths
