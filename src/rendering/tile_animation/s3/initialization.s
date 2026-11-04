; Owner: rendering/tile_animation/s3
; Responsibility: Null script return and zone-specific initial animation counter state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AnimateTiles_NULL3:
                rts

; =============== S U B R O U T I N E =======================================

Animate_Init:
                cmpi.w  #$100,(Current_zone_and_act).w
                bne.s   S3TileInit_SeedHCZ2Caches
                bsr.w   AniHCZ1_InitWaterlineTiles

S3TileInit_SeedHCZ2Caches:
                cmpi.w  #$101,(Current_zone_and_act).w
                bne.s   S3TileInit_SeedCarnivalCounterBytes
                move.b  #$20,(Anim_Counters+1).w
                move.b  #$40,(Anim_Counters+3).w

S3TileInit_SeedCarnivalCounterBytes:
                cmpi.b  #3,(Current_zone).w
                bne.s   S3TileInit_SeedLaunchBaseFirstActCache
                move.b  #$40,(Anim_Counters+1).w
                move.b  #0,(Anim_Counters+2).w
                move.b  #0,(Anim_Counters+4).w
                move.b  #0,(Anim_Counters+6).w
                move.b  #2,(Anim_Counters+8).w
                move.b  #2,(Anim_Counters+$A).w
                move.b  #2,(Anim_Counters+$C).w
                move.b  #1,(Anim_Counters+$E).w

S3TileInit_SeedLaunchBaseFirstActCache:
                cmpi.w  #$600,(Current_zone_and_act).w
                bne.s   S3TileInit_SeedLBZ2Waterline
                move.b  #$20,(Anim_Counters+3).w

S3TileInit_SeedLBZ2Waterline:
                cmpi.w  #$601,(Current_zone_and_act).w
                bne.s   S3TileInit_DirtyLRZ1Caches
                bsr.w   AniLBZ2_InitWaterlineTiles
                move.b  #$10,(Anim_Counters+1).w

S3TileInit_DirtyLRZ1Caches:
                cmpi.w  #$900,(Current_zone_and_act).w
                bne.s   S3TileInit_SeedDPZCaches
                move.b  #-1,(Anim_Counters+1).w
                move.b  #-1,(Anim_Counters+3).w

S3TileInit_SeedDPZCaches:
                cmpi.w  #$1000,(Current_zone_and_act).w
                bne.s   S3TileInit_Return
                move.b  #$40,(Anim_Counters+1).w
                move.b  #$40,(Anim_Counters+3).w

S3TileInit_Return:
                rts
; End of function Animate_Init
