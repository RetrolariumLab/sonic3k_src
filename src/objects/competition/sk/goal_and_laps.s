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
                jsr     SKCompGoal_ClearLapAndRunTimes(pc)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKCompGoal_InstallGoalCrossingLoop
                move.l  #SKRaceHUD_InitItemWidget,(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKCompGoal_InstallGoalCrossingLoop
                move.l  #SKRaceHUD_InitItemWidget,(a1)
                move.b  #1,subtype(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKCompGoal_InstallGoalCrossingLoop
                move.l  #SKCompGoal_InitLapDigitAndSelectView,(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKCompGoal_InstallGoalCrossingLoop
                move.l  #SKCompGoal_InitLapDigitAndSelectView,(a1)
                move.b  #1,subtype(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKCompGoal_InstallGoalCrossingLoop
                move.l  #SKRaceNeon_InitRaceNeon,(a1)
                move.w  #$120,x_pos(a1)
                move.w  #$B8,y_pos(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKCompGoal_InstallGoalCrossingLoop
                move.l  #SKRaceHUD_InitP1TimeWidget,(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKCompGoal_InstallGoalCrossingLoop
                move.l  #SKRaceHUD_SkipP2TimeWidgetInGhostMode,(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKCompGoal_InstallGoalCrossingLoop
                move.l  #SKCompetitionGoal_NoOpAuxiliaryHandler,(a1)

SKCompGoal_InstallGoalCrossingLoop:
                move.l  #SKCompGoal_TrackPlayersAndPublishLaps,(a0)

SKCompGoal_TrackPlayersAndPublishLaps:
                move.w  x_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                lea     (Competition_current_lap).w,a3
                lea     (Competition_lap_count_flag).w,a4
                lea     (Timer).w,a5
                lea     ((RAM_start+$7828)&$FFFFFF).l,a6
                bsr.w   SKCompGoal_TrackPlayerCrossing
                lea     (Player_2).w,a1
                lea     (Competition_current_lap_2P).w,a3
                lea     (Competition_lap_count_flag_P2).w,a4
                lea     (Timer_P2).w,a5
                lea     ((RAM_start+$7840)&$FFFFFF).l,a6
                bsr.w   SKCompGoal_TrackPlayerCrossing
                lea     (Ani_2PGoalMarker).l,a1
                jsr     (Animate_Sprite).l
                move.w  $36(a0),(Competition_lap_count).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKCompGoal_TickWrongWayWaitAndRestore:
                subq.w  #1,$3C(a0)
                bne.w   SKCompGoal_AnimateAndDrawWrongWayGoal
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
                beq.s   SKCompGoal_ResetClocksAndUnlock
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

SKCompGoal_ResetClocksAndUnlock:
                clr.w   (Competition_current_lap).w
                clr.b   (Update_HUD_timer).w
                clr.l   (Timer).w
                clr.b   (Update_HUD_timer_P2).w
                clr.l   (Timer_P2).w
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w
                jsr     SKCompGoal_ClearLapAndRunTimes(pc)
                clr.w   (Events_bg+$14).w
                move.l  #SKCompGoal_TrackPlayersAndPublishLaps,(a0)

SKCompGoal_AnimateAndDrawWrongWayGoal:
                lea     (Ani_2PGoalMarker).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Update lap high-water and cumulative time, rearm items on new laps and restart on a pre-start wrong-way crossing
SKCompGoal_TrackPlayerCrossing:
                tst.b   (a4)
                bne.w   SKCompGoal_ConsumeRespawnAndAdjustLap
                tst.b   (a2)+
                bne.w   SKCompGoal_CheckReverseCrossingAndY
                cmp.w   x_pos(a1),d1
                bhi.w   SKCompGoal_ReverseCrossingReturn
                move.b  #1,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                sub.w   $38(a0),d2
                addi.w  #$14,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   SKCompGoal_ReverseCrossingReturn
                cmp.w   d3,d4
                bge.w   SKCompGoal_ReverseCrossingReturn
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   SKCompGoal_GateForwardCrossing
                neg.w   d2

SKCompGoal_GateForwardCrossing:
                cmpi.w  #$20,d2
                bhs.w   SKCompGoal_ReverseCrossingReturn
                cmpi.b  #$C,top_solid_bit(a1)
                bne.s   SKCompGoal_ForwardCrossingReturn
                move.b  (a3),d0
                beq.s   SKCompGoal_GateStartOrBeginWrongWay
                cmp.b   1(a2),d0
                bls.s   SKCompGoal_IncrementCurrentLap
                move.b  d0,1(a2)
                subq.b  #1,d0
                bmi.s   SKCompGoal_RearmItemsBelowUpperBand
                cmpi.b  #5,d0
                bhs.s   SKCompGoal_RearmItemsBelowUpperBand
                ext.w   d0
                lsl.w   #2,d0
                move.l  (a6,d0.w),d5
                move.l  $14(a6),d6
                jsr     SKCompGoal_AddPackedTimes(pc)
                move.l  d6,$14(a6)
                clr.l   (a5)

SKCompGoal_RearmItemsBelowUpperBand:
                sub.w   y_pos(a0),d4
                neg.w   d4
                cmpi.w  #$14,d4
                bge.s   SKCompGoal_IncrementCurrentLap
                move.w  $3A(a0),d0
                andi.w  #$F,d0
                bsr.w   SKCompGoal_RearmOrbitingItems
                addq.w  #2,$3A(a0)

SKCompGoal_IncrementCurrentLap:
                addq.b  #1,(a3)

SKCompGoal_ForwardCrossingReturn:
                rts
; ---------------------------------------------------------------------------

SKCompGoal_GateStartOrBeginWrongWay:
                tst.b   1(a2)
                bne.s   SKCompGoal_IncrementCurrentLap
                tst.b   (Update_HUD_timer).w
                bne.s   SKCompGoal_IncrementCurrentLap
                move.b  #1,(Ctrl_1_locked).w
                move.b  #1,(Ctrl_2_locked).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_2_logical).w
                move.l  #SKCompGoal_TickWrongWayWaitAndRestore,(a0)
                move.w  #2*60,$3C(a0)
                st      (Events_bg+$14).w
                movea.l a1,a6
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKCompGoal_WrongWaySpawnReturn
                move.l  #SKRaceNeon_InitWrongWayIndicator,(a1)
                move.b  #8,render_flags(a1)
                cmpa.w  #Player_1,a6
                beq.s   SKCompGoal_PlayWrongWaySound
                eori.b  #$18,render_flags(a1)

SKCompGoal_PlayWrongWaySound:
                moveq   #signextendB(sfx_Error),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SKCompGoal_WrongWaySpawnReturn:
                rts
; ---------------------------------------------------------------------------

SKCompGoal_ConsumeRespawnAndAdjustLap:
                clr.b   (a4)
                move.b  #0,(a2)+
                subq.b  #1,(a3)
                bcc.s   SKCompGoal_RespawnLapAdjustReturn
                move.b  #0,(a3)

SKCompGoal_RespawnLapAdjustReturn:
                rts
; ---------------------------------------------------------------------------

SKCompGoal_CheckReverseCrossingAndY:
                cmp.w   x_pos(a1),d1
                bls.w   SKCompGoal_ReverseCrossingReturn
                move.b  #0,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                sub.w   $38(a0),d2
                addi.w  #$14,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   SKCompGoal_ReverseCrossingReturn
                cmp.w   d3,d4
                bge.w   SKCompGoal_ReverseCrossingReturn
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   SKCompGoal_DecrementLapWithoutUnderflow
                neg.w   d2

SKCompGoal_DecrementLapWithoutUnderflow:
                cmpi.w  #$20,d2
                bhs.s   SKCompGoal_ReverseCrossingReturn
                cmpi.b  #$C,top_solid_bit(a1)
                bne.s   SKCompGoal_ReverseCrossingReturn
                subq.b  #1,(a3)
                bcc.s   SKCompGoal_ReverseCrossingReturn
                move.b  #0,(a3)

SKCompGoal_ReverseCrossingReturn:
                rts
; End of function SKCompGoal_TrackPlayerCrossing

; =============== S U B R O U T I N E =======================================

; Clear both six-long timing blocks and displayed totals. Mark that no new top-three record was assigned
SKCompGoal_ClearLapAndRunTimes:
                lea     ((RAM_start+$7828)&$FFFFFF).l,a1
                moveq   #bytesToLcnt($30),d0

                .loop:
                clr.l   (a1)+
                dbf     d0,.loop
                clr.l   (Competition_time_record).w
                clr.l   (Competition_time_record_P2).w
                st      (Competition_time_attack_new_top_record).w
                rts
; End of function SKCompGoal_ClearLapAndRunTimes

; =============== S U B R O U T I N E =======================================

; Add the binary time fields with base-100 centisecond and base-60 second carries. Return the sum in d6
SKCompGoal_AddPackedTimes:
                add.b   d5,d6
                moveq   #0,d3
                cmpi.b  #100,d6
                blo.s   SKCompGoal_AddPackedSecondsAndCarry
                subi.b  #100,d6
                moveq   #1,d3

SKCompGoal_AddPackedSecondsAndCarry:
                ror.l   #8,d5
                ror.l   #8,d6
                add.b   d3,d6
                add.b   d5,d6
                moveq   #0,d3
                cmpi.b  #60,d6
                blo.s   SKCompGoal_AddMinutesAndRestoreOrder
                subi.b  #60,d6
                moveq   #1,d3

SKCompGoal_AddMinutesAndRestoreOrder:
                ror.l   #8,d5
                ror.l   #8,d6
                add.b   d3,d6
                add.b   d5,d6
                swap    d5
                swap    d6
                rts
; End of function SKCompGoal_AddPackedTimes

; =============== S U B R O U T I N E =======================================

; Use the lap sequence to assign effect indices and touch flags. The slot scan advances before each test
SKCompGoal_RearmOrbitingItems:
                tst.b   (Competition_items).w
                bne.s   SKCompGoal_ItemRearmReturn
                lea     (SKCompGoal_OrbitingItemRearmAnims).l,a4
                adda.w  d0,a4
                lea     (Dynamic_object_RAM).w,a1
                moveq   #(Dynamic_object_RAM_end-Dynamic_object_RAM)/object_size-1,d0

SKCompGoal_ScanAndRearmOrbitingItem:
                lea     next_object(a1),a1
                cmpi.l  #SKCompItem_OrbitPickupUpdate,(a1)
                bne.s   SKCompGoal_ContinueItemBankScan
                move.b  (a4)+,anim(a1)
                move.b  #$C7,collision_flags(a1)

SKCompGoal_ContinueItemBankScan:
                dbf     d0,SKCompGoal_ScanAndRearmOrbitingItem

SKCompGoal_ItemRearmReturn:
                rts
; End of function SKCompGoal_RearmOrbitingItems

; ---------------------------------------------------------------------------
SKCompGoal_OrbitingItemRearmAnims:
                dc.b    0,   1,   2,   3,   4,   5,   6,   0,   1,   2,   3,   4,   5,   6,   2,   3,   0,   1,   2,   3
                dc.b    4,   5,   6,   0
                even
Ani_2PGoalMarker:
                include "src/game/competition/shared/animations/goal_marker.s"
Map_2PGoalMarker:
                include "src/game/competition/shared/mappings/goal_marker.s"
; ---------------------------------------------------------------------------

SKCompGoal_InitLapDigitAndSelectView:
                move.l  #Map_2PLapNumbers,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PLapNum,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.w  #$190,x_pos(a0)
                move.w  #$98,y_pos(a0)
                tst.b   subtype(a0)
                beq.s   SKCompGoal_InstallP1LapDigitUpdate
                tst.b   (Not_ghost_flag).w
                bne.s   SKCompGoal_InstallP2LapDigitUpdate
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKCompGoal_InstallP2LapDigitUpdate:
                bset    #4,render_flags(a0)
                move.l  #SKCompGoal_ReadAndClampP2Lap,(a0)
                bra.s   SKCompGoal_ReadAndClampP2Lap
; ---------------------------------------------------------------------------

SKCompGoal_InstallP1LapDigitUpdate:
                bset    #3,render_flags(a0)
                move.l  #SKCompGoal_ReadAndClampP1Lap,(a0)

SKCompGoal_ReadAndClampP1Lap:
                move.b  (Competition_current_lap).w,d0
                cmp.b   (Competition_total_laps).w,d0
                ble.s   SKCompGoal_DrawP1LapModulo10
                move.b  (Competition_total_laps).w,d0

SKCompGoal_DrawP1LapModulo10:
                subi.b  #$A,d0
                bcc.s   SKCompGoal_DrawP1LapModulo10
                addi.b  #$A,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKCompGoal_ReadAndClampP2Lap:
                move.b  (Competition_current_lap_2P).w,d0
                cmp.b   (Competition_total_laps).w,d0
                ble.s   SKCompGoal_DrawP2LapModulo10
                move.b  (Competition_total_laps).w,d0

SKCompGoal_DrawP2LapModulo10:
                subi.b  #$A,d0
                bcc.s   SKCompGoal_DrawP2LapModulo10
                addi.b  #$A,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_2PLapNumbers:
                include "src/game/competition/shared/mappings/lap_numbers.s"
