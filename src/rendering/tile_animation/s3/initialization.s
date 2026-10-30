; Owner: rendering/tile_animation/s3
; Responsibility: Null script return and zone-specific initial animation counter state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AnimateTiles_NULL3:
                rts

; =============== S U B R O U T I N E =======================================

Animate_Init:
                cmpi.w  #$100,(Current_zone_and_act).w
                bne.s   loc_278C4
                bsr.w   sub_26D0E

loc_278C4:
                cmpi.w  #$101,(Current_zone_and_act).w
                bne.s   loc_278D8
                move.b  #$20,(Anim_Counters+1).w
                move.b  #$40,(Anim_Counters+3).w

loc_278D8:
                cmpi.b  #3,(Current_zone).w
                bne.s   loc_27910
                move.b  #$40,(Anim_Counters+1).w
                move.b  #0,(Anim_Counters+2).w
                move.b  #0,(Anim_Counters+4).w
                move.b  #0,(Anim_Counters+6).w
                move.b  #2,(Anim_Counters+8).w
                move.b  #2,(Anim_Counters+$A).w
                move.b  #2,(Anim_Counters+$C).w
                move.b  #1,(Anim_Counters+$E).w

loc_27910:
                cmpi.w  #$600,(Current_zone_and_act).w
                bne.s   loc_2791E
                move.b  #$20,(Anim_Counters+3).w

loc_2791E:
                cmpi.w  #$601,(Current_zone_and_act).w
                bne.s   loc_27930
                bsr.w   sub_273B4
                move.b  #$10,(Anim_Counters+1).w

loc_27930:
                cmpi.w  #$900,(Current_zone_and_act).w
                bne.s   loc_27944
                move.b  #-1,(Anim_Counters+1).w
                move.b  #-1,(Anim_Counters+3).w

loc_27944:
                cmpi.w  #$1000,(Current_zone_and_act).w
                bne.s   locret_27958
                move.b  #$40,(Anim_Counters+1).w
                move.b  #$40,(Anim_Counters+3).w

locret_27958:
                rts
; End of function Animate_Init
