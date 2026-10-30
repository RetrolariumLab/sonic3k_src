; Owner: game/level/s3
; Responsibility: Level collision data initialization, deterministic object oscillators and ring animation updates
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

LoadSolids:
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #5,d0
                lea     (SolidIndexes).l,a1
                adda.l  d0,a1
                move.l  (a1),d0
                move.l  d0,(Primary_collision_addr).w
                addi.l  #$600,d0
                move.l  d0,(Secondary_collision_addr).w
                move.l  #Primary_collision_addr,(Collision_addr).w
                rts
; End of function LoadSolids

; =============== S U B R O U T I N E =======================================

OscillateNumInit:
                lea     (Oscillating_table).w,a1
                lea     (Osc_Data).l,a2
                moveq   #bytesToWcnt(Oscillating_table_end-Oscillating_table),d1

Osc_Loop:
                move.w  (a2)+,(a1)+
                dbf     d1,Osc_Loop
                rts
; End of function OscillateNumInit

; ---------------------------------------------------------------------------
Osc_Data:
                dc.w    %0000000001111101               ; oscillation direction bitfield
                dc.w    $80,     0                      ; baseline values
                dc.w    $80,     0
                dc.w    $80,     0
                dc.w    $80,     0
                dc.w    $80,     0
                dc.w    $80,     0
                dc.w    $80,     0
                dc.w    $80,     0
                dc.w    $80,     0
                dc.w    $3848,   $EE
                dc.w    $2080,   $B4
                dc.w    $3080,  $10E
                dc.w    $5080,  $1C2
                dc.w    $7080,  $276
                dc.w    $80,     0
                dc.w    $4000,   $FE

; =============== S U B R O U T I N E =======================================

OscillateNumDo:
                tst.w   (Competition_mode).w
                bne.s   loc_5958
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   OscillateNumDo_Return

loc_5958:
                lea     (Oscillating_table).w,a1
                lea     (Osc_Data2).l,a2
                move.w  (a1)+,d3
                moveq   #bytesToLcnt(Osc_Data2_end-Osc_Data2),d1

loc_5966:
                move.w  (a2)+,d2
                move.w  (a2)+,d4
                btst    d1,d3
                bne.s   loc_5982
                move.w  2(a1),d0
                add.w   d2,d0
                move.w  d0,2(a1)
                add.w   d0,(a1)
                cmp.b   (a1),d4
                bhi.s   loc_5994
                bset    d1,d3
                bra.s   loc_5994
; ---------------------------------------------------------------------------

loc_5982:
                move.w  2(a1),d0
                sub.w   d2,d0
                move.w  d0,2(a1)
                add.w   d0,(a1)
                cmp.b   (a1),d4
                bls.s   loc_5994
                bclr    d1,d3

loc_5994:
                addq.w  #4,a1
                dbf     d1,loc_5966
                move.w  d3,(Oscillating_table).w

OscillateNumDo_Return:
                rts
; End of function OscillateNumDo

; ---------------------------------------------------------------------------
Osc_Data2:
                dc.w    2, $10
                dc.w    2, $18
                dc.w    2, $20
                dc.w    2, $30
                dc.w    4, $20
                dc.w    8,   8
                dc.w    8, $40
                dc.w    4, $40
                dc.w    2, $38
                dc.w    2, $38
                dc.w    2, $20
                dc.w    3, $30
                dc.w    5, $50
                dc.w    7, $70
                dc.w    2, $40
                dc.w    2, $40
Osc_Data2_end:

; =============== S U B R O U T I N E =======================================

ChangeRingFrame:
                subq.b  #1,(Rings_frame_timer).w
                bpl.s   loc_59F6
                move.b  #7,(Rings_frame_timer).w
                addq.b  #1,(Rings_frame).w
                andi.b  #3,(Rings_frame).w

loc_59F6:
                tst.b   (Ring_spill_anim_counter).w
                beq.s   loc_5A18
                moveq   #0,d0
                move.b  (Ring_spill_anim_counter).w,d0
                add.w   (Ring_spill_anim_accum).w,d0
                move.w  d0,(Ring_spill_anim_accum).w
                rol.w   #7,d0
                andi.w  #3,d0
                move.b  d0,(Ring_spill_anim_frame).w
                subq.b  #1,(Ring_spill_anim_counter).w

loc_5A18:
                addi.w  #$180,(AIZ_vine_angle).w
                rts
; End of function ChangeRingFrame
