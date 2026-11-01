; Owner: objects/competition/sk
; Responsibility: Competition goal marker activation, race lap accounting and lap number sprites
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_2PGoalMarker:
                move.l  #Map_2PGoalMarker,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PStartPost,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                subi.w  #$14,d0
                move.w  d0,$38(a0)
                move.b  #5,(Competition_total_laps).w
                clr.w   (Competition_current_lap).w
                clr.w   (Events_bg+$14).w
                clr.b   (Update_HUD_timer).w
                clr.l   (Timer).w
                clr.b   (Update_HUD_timer_P2).w
                clr.l   (Timer_P2).w
                clr.w   (Ring_count).w
                clr.w   (Ring_count_P2).w
                jsr     CompetitionGoalSKClearBothLapTimeBlocksAndRunRecords(pc)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_36CE4
                move.l  #loc_37EC2,(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_36CE4
                move.l  #loc_37EC2,(a1)
                move.b  #1,subtype(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_36CE4
                move.l  #loc_3703A,(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_36CE4
                move.l  #loc_3703A,(a1)
                move.b  #1,subtype(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_36CE4
                move.l  #loc_3713A,(a1)
                move.w  #$120,x_pos(a1)
                move.w  #$B8,y_pos(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_36CE4
                move.l  #loc_37C8E,(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_36CE4
                move.l  #loc_37D00,(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_36CE4
                move.l  #locret_3827A,(a1)

loc_36CE4:
                move.l  #loc_36CEA,(a0)

loc_36CEA:
                move.w  x_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                lea     (Competition_current_lap).w,a3
                lea     (Competition_lap_count_flag).w,a4
                lea     (Timer).w,a5
                lea     ((RAM_start+$7828)&$FFFFFF).l,a6
                bsr.w   CompetitionGoalSKTrackPlayerCrossingLapAndWrongWayRestart
                lea     (Player_2).w,a1
                lea     (Competition_current_lap_2P).w,a3
                lea     (Competition_lap_count_flag_P2).w,a4
                lea     (Timer_P2).w,a5
                lea     ((RAM_start+$7840)&$FFFFFF).l,a6
                bsr.w   CompetitionGoalSKTrackPlayerCrossingLapAndWrongWayRestart
                lea     (Ani_2PGoalMarker).l,a1
                jsr     (Animate_Sprite).l
                move.w  $36(a0),(Competition_lap_count).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_36D3E:
                subq.w  #1,$3C(a0)
                bne.w   loc_36DEA
                lea     (Player_1).w,a1
                move.w  (Saved_X_pos).w,x_pos(a1)
                move.w  (Saved_Y_pos).w,y_pos(a1)
                move.w  (Saved_art_tile).w,art_tile(a1)
                move.w  (Saved_solid_bits).w,top_solid_bit(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #1<<Status_InAir,status(a1)
                move.w  #0,move_lock(a1)
                tst.b   (Not_ghost_flag).w
                beq.s   loc_36DC0
                lea     (Player_2).w,a1
                move.w  (Saved2_X_pos).w,x_pos(a1)
                move.w  (Saved2_Y_pos).w,y_pos(a1)
                move.w  (Saved2_art_tile).w,art_tile(a1)
                move.w  (Saved2_solid_bits).w,top_solid_bit(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #1<<Status_InAir,status(a1)
                move.w  #0,move_lock(a1)

loc_36DC0:
                clr.w   (Competition_current_lap).w
                clr.b   (Update_HUD_timer).w
                clr.l   (Timer).w
                clr.b   (Update_HUD_timer_P2).w
                clr.l   (Timer_P2).w
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w
                jsr     CompetitionGoalSKClearBothLapTimeBlocksAndRunRecords(pc)
                clr.w   (Events_bg+$14).w
                move.l  #loc_36CEA,(a0)

loc_36DEA:
                lea     (Ani_2PGoalMarker).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CompetitionGoalSKTrackPlayerCrossingLapAndWrongWayRestart:
                tst.b   (a4)
                bne.w   loc_36EFC
                tst.b   (a2)+
                bne.w   loc_36F0C
                cmp.w   x_pos(a1),d1
                bhi.w   locret_36F58
                move.b  #1,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                sub.w   $38(a0),d2
                addi.w  #$14,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   locret_36F58
                cmp.w   d3,d4
                bge.w   locret_36F58
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   loc_36E3E
                neg.w   d2

loc_36E3E:
                cmpi.w  #$20,d2
                bhs.w   locret_36F58
                cmpi.b  #$C,top_solid_bit(a1)
                bne.s   locret_36E9A
                move.b  (a3),d0
                beq.s   loc_36E9C
                cmp.b   1(a2),d0
                bls.s   loc_36E98
                move.b  d0,1(a2)
                subq.b  #1,d0
                bmi.s   loc_36E7C
                cmpi.b  #5,d0
                bhs.s   loc_36E7C
                ext.w   d0
                lsl.w   #2,d0
                move.l  (a6,d0.w),d5
                move.l  $14(a6),d6
                jsr     CompetitionGoalSKAddPackedMinuteSecondCentisecondTimes(pc)
                move.l  d6,$14(a6)
                clr.l   (a5)

loc_36E7C:
                sub.w   y_pos(a0),d4
                neg.w   d4
                cmpi.w  #$14,d4
                bge.s   loc_36E98
                move.w  $3A(a0),d0
                andi.w  #$F,d0
                bsr.w   CompetitionGoalSKRearmOrbitingItemsFromLapSequence
                addq.w  #2,$3A(a0)

loc_36E98:
                addq.b  #1,(a3)

locret_36E9A:
                rts
; ---------------------------------------------------------------------------

loc_36E9C:
                tst.b   1(a2)
                bne.s   loc_36E98
                tst.b   (Update_HUD_timer).w
                bne.s   loc_36E98
                move.b  #1,(Ctrl_1_locked).w
                move.b  #1,(Ctrl_2_locked).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_2_logical).w
                move.l  #loc_36D3E,(a0)
                move.w  #2*60,$3C(a0)
                st      (Events_bg+$14).w
                movea.l a1,a6
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_36EFA
                move.l  #loc_374B8,(a1)
                move.b  #8,render_flags(a1)
                cmpa.w  #Player_1,a6
                beq.s   loc_36EF2
                eori.b  #$18,render_flags(a1)

loc_36EF2:
                moveq   #signextendB(sfx_Error),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

locret_36EFA:
                rts
; ---------------------------------------------------------------------------

loc_36EFC:
                clr.b   (a4)
                move.b  #0,(a2)+
                subq.b  #1,(a3)
                bcc.s   locret_36F0A
                move.b  #0,(a3)

locret_36F0A:
                rts
; ---------------------------------------------------------------------------

loc_36F0C:
                cmp.w   x_pos(a1),d1
                bls.w   locret_36F58
                move.b  #0,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                sub.w   $38(a0),d2
                addi.w  #$14,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   locret_36F58
                cmp.w   d3,d4
                bge.w   locret_36F58
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   loc_36F42
                neg.w   d2

loc_36F42:
                cmpi.w  #$20,d2
                bhs.s   locret_36F58
                cmpi.b  #$C,top_solid_bit(a1)
                bne.s   locret_36F58
                subq.b  #1,(a3)
                bcc.s   locret_36F58
                move.b  #0,(a3)

locret_36F58:
                rts
; End of function CompetitionGoalSKTrackPlayerCrossingLapAndWrongWayRestart

; =============== S U B R O U T I N E =======================================

CompetitionGoalSKClearBothLapTimeBlocksAndRunRecords:
                lea     ((RAM_start+$7828)&$FFFFFF).l,a1
                moveq   #bytesToLcnt($30),d0

                .loop:
                clr.l   (a1)+
                dbf     d0,.loop
                clr.l   (Competition_time_record).w
                clr.l   (Competition_time_record_P2).w
                st      (Competition_time_attack_new_top_record).w
                rts
; End of function CompetitionGoalSKClearBothLapTimeBlocksAndRunRecords

; =============== S U B R O U T I N E =======================================

CompetitionGoalSKAddPackedMinuteSecondCentisecondTimes:
                add.b   d5,d6
                moveq   #0,d3
                cmpi.b  #100,d6
                blo.s   loc_36F86
                subi.b  #100,d6
                moveq   #1,d3

loc_36F86:
                ror.l   #8,d5
                ror.l   #8,d6
                add.b   d3,d6
                add.b   d5,d6
                moveq   #0,d3
                cmpi.b  #60,d6
                blo.s   loc_36F9C
                subi.b  #60,d6
                moveq   #1,d3

loc_36F9C:
                ror.l   #8,d5
                ror.l   #8,d6
                add.b   d3,d6
                add.b   d5,d6
                swap    d5
                swap    d6
                rts
; End of function CompetitionGoalSKAddPackedMinuteSecondCentisecondTimes

; =============== S U B R O U T I N E =======================================

CompetitionGoalSKRearmOrbitingItemsFromLapSequence:
                tst.b   (Competition_items).w
                bne.s   locret_36FD8
                lea     (byte_36FDA).l,a4
                adda.w  d0,a4
                lea     (Dynamic_object_RAM).w,a1
                moveq   #(Dynamic_object_RAM_end-Dynamic_object_RAM)/object_size-1,d0

loc_36FBE:
                lea     next_object(a1),a1
                cmpi.l  #loc_363D0,(a1)
                bne.s   loc_36FD4
                move.b  (a4)+,anim(a1)
                move.b  #$C7,collision_flags(a1)

loc_36FD4:
                dbf     d0,loc_36FBE

locret_36FD8:
                rts
; End of function CompetitionGoalSKRearmOrbitingItemsFromLapSequence

; ---------------------------------------------------------------------------
byte_36FDA:
                dc.b    0,   1,   2,   3,   4,   5,   6,   0,   1,   2,   3,   4,   5,   6,   2,   3,   0,   1,   2,   3
                dc.b    4,   5,   6,   0
                even
Ani_2PGoalMarker:
                include "src/game/competition/shared/animations/goal_marker.s"
Map_2PGoalMarker:
                include "src/game/competition/shared/mappings/goal_marker.s"
; ---------------------------------------------------------------------------

loc_3703A:
                move.l  #Map_2PLapNumbers,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PLapNum,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.w  #$190,x_pos(a0)
                move.w  #$98,y_pos(a0)
                tst.b   subtype(a0)
                beq.s   loc_37086
                tst.b   (Not_ghost_flag).w
                bne.s   loc_37078
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_37078:
                bset    #4,render_flags(a0)
                move.l  #loc_370B4,(a0)
                bra.s   loc_370B4
; ---------------------------------------------------------------------------

loc_37086:
                bset    #3,render_flags(a0)
                move.l  #loc_37092,(a0)

loc_37092:
                move.b  (Competition_current_lap).w,d0
                cmp.b   (Competition_total_laps).w,d0
                ble.s   loc_370A0
                move.b  (Competition_total_laps).w,d0

loc_370A0:
                subi.b  #$A,d0
                bcc.s   loc_370A0
                addi.b  #$A,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_370B4:
                move.b  (Competition_current_lap_2P).w,d0
                cmp.b   (Competition_total_laps).w,d0
                ble.s   loc_370C2
                move.b  (Competition_total_laps).w,d0

loc_370C2:
                subi.b  #$A,d0
                bcc.s   loc_370C2
                addi.b  #$A,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_2PLapNumbers:
                include "src/game/competition/shared/mappings/lap_numbers.s"
