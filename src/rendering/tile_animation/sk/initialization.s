; Owner: rendering/tile_animation/sk
; Responsibility: Null script return and zone-specific initial animation counter state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AnimateTiles_NULL3:
                rts

; =============== S U B R O U T I N E =======================================

Animate_Init:
                cmpi.w  #$100,(Current_zone_and_act).w
                bne.s   loc_28C8C
                bsr.w   sub_279D4

loc_28C8C:
                cmpi.w  #$101,(Current_zone_and_act).w
                bne.s   loc_28CA0
                move.b  #$20,(Anim_Counters+1).w
                move.b  #$40,(Anim_Counters+3).w

loc_28CA0:
                cmpi.b  #3,(Current_zone).w
                bne.s   loc_28CD8
                move.b  #$40,(Anim_Counters+1).w
                move.b  #0,(Anim_Counters+2).w
                move.b  #0,(Anim_Counters+4).w
                move.b  #0,(Anim_Counters+6).w
                move.b  #2,(Anim_Counters+8).w
                move.b  #2,(Anim_Counters+$A).w
                move.b  #2,(Anim_Counters+$C).w
                move.b  #1,(Anim_Counters+$E).w

loc_28CD8:
                cmpi.w  #$600,(Current_zone_and_act).w
                bne.s   loc_28CE6
                move.b  #$20,(Anim_Counters+3).w

loc_28CE6:
                cmpi.w  #$601,(Current_zone_and_act).w
                bne.s   loc_28CF8
                bsr.w   sub_2807A
                move.b  #$10,(Anim_Counters+1).w

loc_28CF8:
                cmpi.b  #7,(Current_zone).w
                bne.s   loc_28D0C
                move.b  #$20,(Anim_Counters+1).w
                move.b  #$40,(Anim_Counters+3).w

loc_28D0C:
                cmpi.b  #8,(Current_zone).w
                bne.s   loc_28D1A
                move.b  #-1,(Anim_Counters+1).w

loc_28D1A:
                cmpi.w  #$900,(Current_zone_and_act).w
                bne.s   loc_28D2E
                move.b  #-1,(Anim_Counters+1).w
                move.b  #-1,(Anim_Counters+3).w

loc_28D2E:
                cmpi.w  #$1000,(Current_zone_and_act).w
                bne.s   loc_28D42
                move.b  #$40,(Anim_Counters+1).w
                move.b  #$40,(Anim_Counters+3).w

loc_28D42:
                cmpi.b  #$14,(Current_zone).w
                bne.s   loc_28DA2
                lea     (ArtKos_PachinkoBG1).l,a0
                lea     (RAM_start+$1000).l,a1
                jsr     (Kos_Decomp).l
                lea     (ArtKos_PachinkoBG2).l,a0
                lea     (Chunk_table+$7000).l,a1
                jsr     (Kos_Decomp).l
                lea     (RAM_start+$6000).l,a1
                lea     (Chunk_table+$7000).l,a2
                moveq   #$C-1,d0

loc_28D7C:
                moveq   #$20-1,d1

loc_28D7E:
                move.l  (a2),$80(a1)
                move.l  (a2)+,(a1)+
                dbf     d1,loc_28D7E
                lea     $80(a1),a1
                dbf     d0,loc_28D7C
                lea     (PalKos_Pachinko).l,a0
                lea     (Chunk_table+$7800).l,a1
                jsr     (Kos_Decomp).l

loc_28DA2:
                cmpi.w  #$1600,(Current_zone_and_act).w
                bne.s   locret_28DB6
                move.b  #-1,(Anim_Counters+1).w
                move.b  #-1,(Anim_Counters+3).w

locret_28DB6:
                rts
; End of function Animate_Init
