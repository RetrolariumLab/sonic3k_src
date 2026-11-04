; Owner: rendering/tile_animation/sk
; Responsibility: Null script return and zone-specific initial animation counter state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AnimateTiles_NULL3:
                rts

; =============== S U B R O U T I N E =======================================

Animate_Init:
                cmpi.w  #$100,(Current_zone_and_act).w
                bne.s   SKTileInit_SeedHCZ2Caches
                bsr.w   AniHCZ1_InitWaterlineTiles

SKTileInit_SeedHCZ2Caches:
                cmpi.w  #$101,(Current_zone_and_act).w
                bne.s   SKTileInit_SeedCNZCounters
                move.b  #$20,(Anim_Counters+1).w
                move.b  #$40,(Anim_Counters+3).w

SKTileInit_SeedCNZCounters:
                cmpi.b  #3,(Current_zone).w
                bne.s   SKTileInit_SeedLBZ1Scroll
                move.b  #$40,(Anim_Counters+1).w
                move.b  #0,(Anim_Counters+2).w
                move.b  #0,(Anim_Counters+4).w
                move.b  #0,(Anim_Counters+6).w
                move.b  #2,(Anim_Counters+8).w
                move.b  #2,(Anim_Counters+$A).w
                move.b  #2,(Anim_Counters+$C).w
                move.b  #1,(Anim_Counters+$E).w

SKTileInit_SeedLBZ1Scroll:
                cmpi.w  #$600,(Current_zone_and_act).w
                bne.s   SKTileInit_SeedLBZ2Waterline
                move.b  #$20,(Anim_Counters+3).w

SKTileInit_SeedLBZ2Waterline:
                cmpi.w  #$601,(Current_zone_and_act).w
                bne.s   SKTileInit_SeedMHZCaches
                bsr.w   AniLBZ2_InitWaterlineTiles
                move.b  #$10,(Anim_Counters+1).w

SKTileInit_SeedMHZCaches:
                cmpi.b  #7,(Current_zone).w
                bne.s   SKTileInit_DirtySOZCache
                move.b  #$20,(Anim_Counters+1).w
                move.b  #$40,(Anim_Counters+3).w

SKTileInit_DirtySOZCache:
                cmpi.b  #8,(Current_zone).w
                bne.s   SKTileInit_DirtyLRZ1Caches
                move.b  #-1,(Anim_Counters+1).w

SKTileInit_DirtyLRZ1Caches:
                cmpi.w  #$900,(Current_zone_and_act).w
                bne.s   SKTileInit_SeedDPZCaches
                move.b  #-1,(Anim_Counters+1).w
                move.b  #-1,(Anim_Counters+3).w

SKTileInit_SeedDPZCaches:
                cmpi.w  #$1000,(Current_zone_and_act).w
                bne.s   SKTileInit_LoadPachinkoArt
                move.b  #$40,(Anim_Counters+1).w
                move.b  #$40,(Anim_Counters+3).w

SKTileInit_LoadPachinkoArt:
                cmpi.b  #$14,(Current_zone).w
                bne.s   SKTileInit_DirtyLRZ3Caches
                lea     (ArtKos_PachinkoBG1).l,a0
                lea     (RAM_start+$1000).l,a1
                jsr     (Kos_Decomp).l
                lea     (ArtKos_PachinkoBG2).l,a0
                lea     (Chunk_table+$7000).l,a1
                jsr     (Kos_Decomp).l
                lea     (RAM_start+$6000).l,a1
                lea     (Chunk_table+$7000).l,a2
                moveq   #$C-1,d0

SKTileInit_BeginPachinkoRow:
                moveq   #$20-1,d1

SKTileInit_DuplicatePachinkoLong:
                move.l  (a2),$80(a1)
                move.l  (a2)+,(a1)+
                dbf     d1,SKTileInit_DuplicatePachinkoLong
                lea     $80(a1),a1
                dbf     d0,SKTileInit_BeginPachinkoRow
                lea     (PalKos_Pachinko).l,a0
                lea     (Chunk_table+$7800).l,a1
                jsr     (Kos_Decomp).l

SKTileInit_DirtyLRZ3Caches:
                cmpi.w  #$1600,(Current_zone_and_act).w
                bne.s   SKTileInit_Return
                move.b  #-1,(Anim_Counters+1).w
                move.b  #-1,(Anim_Counters+3).w

SKTileInit_Return:
                rts
; End of function Animate_Init
