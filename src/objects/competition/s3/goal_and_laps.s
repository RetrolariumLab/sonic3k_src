; Owner: objects/competition/s3
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
                jsr     S3CompGoal_ClearLapAndRunTimes(pc)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3CompGoal_InstallGoalCrossingLoop
                move.l  #S3RaceHUD_InitItemWidget,(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3CompGoal_InstallGoalCrossingLoop
                move.l  #S3RaceHUD_InitItemWidget,(a1)
                move.b  #1,subtype(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3CompGoal_InstallGoalCrossingLoop
                move.l  #S3CompGoal_InitLapDigitAndSelectView,(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3CompGoal_InstallGoalCrossingLoop
                move.l  #S3CompGoal_InitLapDigitAndSelectView,(a1)
                move.b  #1,subtype(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3CompGoal_InstallGoalCrossingLoop
                move.l  #S3RaceNeon_InitRaceNeon,(a1)
                move.w  #$120,x_pos(a1)
                move.w  #$B8,y_pos(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3CompGoal_InstallGoalCrossingLoop
                move.l  #S3RaceHUD_InitP1TimeWidget,(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3CompGoal_InstallGoalCrossingLoop
                move.l  #S3RaceHUD_SkipP2TimeWidgetInGhostMode,(a1)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3CompGoal_InstallGoalCrossingLoop
                move.l  #S3CompetitionGoal_NoOpAuxiliaryHandler,(a1)

S3CompGoal_InstallGoalCrossingLoop:
                move.l  #S3CompGoal_TrackPlayersAndPublishLaps,(a0)

S3CompGoal_TrackPlayersAndPublishLaps:
                move.w  x_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                lea     (Competition_current_lap).w,a3
                lea     (Competition_lap_count_flag).w,a4
                lea     (Timer).w,a5
                lea     ((RAM_start+$7828)&$FFFFFF).l,a6
                bsr.w   S3CompGoal_TrackPlayerCrossing
                lea     (Player_2).w,a1
                lea     (Competition_current_lap_2P).w,a3
                lea     (Competition_lap_count_flag_P2).w,a4
                lea     (Timer_P2).w,a5
                lea     ((RAM_start+$7840)&$FFFFFF).l,a6
                bsr.w   S3CompGoal_TrackPlayerCrossing
                lea     (Ani_2PGoalMarker).l,a1
                jsr     (Animate_Sprite).l
                move.w  $36(a0),(Competition_lap_count).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3CompGoal_TickWrongWayWaitAndRestore:
                subq.w  #1,$3C(a0)
                bne.w   S3CompGoal_AnimateAndDrawWrongWayGoal
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
                beq.s   S3CompGoal_ResetClocksAndUnlock
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

S3CompGoal_ResetClocksAndUnlock:
                clr.w   (Competition_current_lap).w
                clr.b   (Update_HUD_timer).w
                clr.l   (Timer).w
                clr.b   (Update_HUD_timer_P2).w
                clr.l   (Timer_P2).w
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w
                jsr     S3CompGoal_ClearLapAndRunTimes(pc)
                clr.w   (Events_bg+$14).w
                move.l  #S3CompGoal_TrackPlayersAndPublishLaps,(a0)

S3CompGoal_AnimateAndDrawWrongWayGoal:
                lea     (Ani_2PGoalMarker).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Update lap high-water and cumulative time, rearm items on new laps and restart on a pre-start wrong-way crossing
S3CompGoal_TrackPlayerCrossing:
                tst.b   (a4)                            ; check the lap count flag
                bne.w   S3CompGoal_ConsumeRespawnAndAdjustLap  ; if not equal to zero, branch
                tst.b   (a2)+
                bne.w   S3CompGoal_CheckReverseCrossingAndY
                cmp.w   x_pos(a1),d1
                bhi.w   S3CompGoal_ReverseCrossingReturn
                move.b  #1,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                sub.w   $38(a0),d2
                addi.w  #$14,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   S3CompGoal_ReverseCrossingReturn
                cmp.w   d3,d4
                bge.w   S3CompGoal_ReverseCrossingReturn
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   S3CompGoal_GateForwardCrossing
                neg.w   d2

S3CompGoal_GateForwardCrossing:
                cmpi.w  #$20,d2
                bhs.w   S3CompGoal_ReverseCrossingReturn
                cmpi.b  #$C,top_solid_bit(a1)
                bne.s   S3CompGoal_ForwardCrossingReturn
                move.b  (a3),d0
                beq.s   S3CompGoal_GateStartOrBeginWrongWay
                cmp.b   1(a2),d0
                bls.s   S3CompGoal_IncrementCurrentLap
                move.b  d0,1(a2)
                subq.b  #1,d0
                bmi.s   S3CompGoal_RearmItemsBelowUpperBand
                cmpi.b  #5,d0
                bhs.s   S3CompGoal_RearmItemsBelowUpperBand
                ext.w   d0
                lsl.w   #2,d0
                move.l  (a6,d0.w),d5
                move.l  $14(a6),d6
                jsr     S3CompGoal_AddPackedTimes(pc)
                move.l  d6,$14(a6)
                clr.l   (a5)

S3CompGoal_RearmItemsBelowUpperBand:
                sub.w   y_pos(a0),d4
                neg.w   d4
                cmpi.w  #$14,d4
                bge.s   S3CompGoal_IncrementCurrentLap
                move.w  $3A(a0),d0
                andi.w  #$F,d0
                bsr.w   S3CompGoal_RearmOrbitingItems
                addq.w  #2,$3A(a0)

S3CompGoal_IncrementCurrentLap:
                addq.b  #1,(a3)

S3CompGoal_ForwardCrossingReturn:
                rts
; ---------------------------------------------------------------------------

S3CompGoal_GateStartOrBeginWrongWay:
                tst.b   1(a2)
                bne.s   S3CompGoal_IncrementCurrentLap
                tst.b   (Update_HUD_timer).w
                bne.s   S3CompGoal_IncrementCurrentLap
                move.b  #1,(Ctrl_1_locked).w
                move.b  #1,(Ctrl_2_locked).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_2_logical).w
                move.l  #S3CompGoal_TickWrongWayWaitAndRestore,(a0)
                move.w  #2*60,$3C(a0)
                st      (Events_bg+$14).w
                movea.l a1,a6
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3CompGoal_WrongWaySpawnReturn
                move.l  #S3RaceNeon_InitWrongWayIndicator,(a1)
                move.b  #8,render_flags(a1)
                cmpa.w  #Player_1,a6
                beq.s   S3CompGoal_PlayWrongWaySound
                eori.b  #$18,render_flags(a1)

S3CompGoal_PlayWrongWaySound:
                moveq   #signextendB(sfx_Error),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

S3CompGoal_WrongWaySpawnReturn:
                rts
; ---------------------------------------------------------------------------

S3CompGoal_ConsumeRespawnAndAdjustLap:
                clr.b   (a4)                            ; enable the lap count flag
                move.b  #0,(a2)+
                subq.b  #1,(a3)
                bcc.s   S3CompGoal_RespawnLapAdjustReturn
                move.b  #0,(a3)

S3CompGoal_RespawnLapAdjustReturn:
                rts
; ---------------------------------------------------------------------------

S3CompGoal_CheckReverseCrossingAndY:
                cmp.w   x_pos(a1),d1
                bls.w   S3CompGoal_ReverseCrossingReturn
                move.b  #0,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                sub.w   $38(a0),d2
                addi.w  #$14,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   S3CompGoal_ReverseCrossingReturn
                cmp.w   d3,d4
                bge.w   S3CompGoal_ReverseCrossingReturn
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   S3CompGoal_DecrementLapWithoutUnderflow
                neg.w   d2

S3CompGoal_DecrementLapWithoutUnderflow:
                cmpi.w  #$20,d2
                bhs.s   S3CompGoal_ReverseCrossingReturn
                cmpi.b  #$C,top_solid_bit(a1)
                bne.s   S3CompGoal_ReverseCrossingReturn
                subq.b  #1,(a3)
                bcc.s   S3CompGoal_ReverseCrossingReturn
                move.b  #0,(a3)

S3CompGoal_ReverseCrossingReturn:
                rts
; End of function S3CompGoal_TrackPlayerCrossing

; =============== S U B R O U T I N E =======================================

; Clear both six-long timing blocks and displayed totals. Mark that no new top-three record was assigned
S3CompGoal_ClearLapAndRunTimes:
                lea     ((RAM_start+$7828)&$FFFFFF).l,a1
                moveq   #bytesToLcnt($30),d0

                .loop:
                clr.l   (a1)+
                dbf     d0,.loop
                clr.l   (Competition_time_record).w
                clr.l   (Competition_time_record_P2).w
                st      (Competition_time_attack_new_top_record).w
                rts
; End of function S3CompGoal_ClearLapAndRunTimes

; =============== S U B R O U T I N E =======================================

; Add the binary time fields with base-100 centisecond and base-60 second carries. Return the sum in d6
S3CompGoal_AddPackedTimes:
                add.b   d5,d6
                moveq   #0,d3
                cmpi.b  #100,d6
                blo.s   S3CompGoal_AddPackedSecondsAndCarry
                subi.b  #100,d6
                moveq   #1,d3

S3CompGoal_AddPackedSecondsAndCarry:
                ror.l   #8,d5
                ror.l   #8,d6
                add.b   d3,d6
                add.b   d5,d6
                moveq   #0,d3
                cmpi.b  #60,d6
                blo.s   S3CompGoal_AddMinutesAndRestoreOrder
                subi.b  #60,d6
                moveq   #1,d3

S3CompGoal_AddMinutesAndRestoreOrder:
                ror.l   #8,d5
                ror.l   #8,d6
                add.b   d3,d6
                add.b   d5,d6
                swap    d5
                swap    d6
                rts
; End of function S3CompGoal_AddPackedTimes

; =============== S U B R O U T I N E =======================================

; Use the lap sequence to assign effect indices and touch flags. The slot scan advances before each test
S3CompGoal_RearmOrbitingItems:
                tst.b   (Competition_items).w
                bne.s   S3CompGoal_ItemRearmReturn
                lea     (S3CompGoal_OrbitingItemRearmAnims).l,a4
                adda.w  d0,a4
                lea     (Dynamic_object_RAM).w,a1
                moveq   #(Dynamic_object_RAM_end-Dynamic_object_RAM)/object_size-1,d0

S3CompGoal_ScanAndRearmOrbitingItem:
                lea     next_object(a1),a1
                cmpi.l  #S3CompItem_OrbitPickupUpdate,(a1)
                bne.s   S3CompGoal_ContinueItemBankScan
                move.b  (a4)+,anim(a1)
                move.b  #$C7,collision_flags(a1)

S3CompGoal_ContinueItemBankScan:
                dbf     d0,S3CompGoal_ScanAndRearmOrbitingItem

S3CompGoal_ItemRearmReturn:
                rts
; End of function S3CompGoal_RearmOrbitingItems

; ---------------------------------------------------------------------------
S3CompGoal_OrbitingItemRearmAnims:
                dc.b    0,   1,   2,   3,   4,   5,   6,   0,   1,   2,   3,   4,   5,   6,   2,   3,   0,   1,   2,   3
                dc.b    4,   5,   6,   0
                even
Ani_2PGoalMarker:
                include "src/game/competition/shared/animations/goal_marker.s"
Map_2PGoalMarker:
                include "src/game/competition/shared/mappings/goal_marker.s"
; ---------------------------------------------------------------------------

S3CompGoal_InitLapDigitAndSelectView:
                move.l  #Map_2PLapNumbers,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PLapNum,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.w  #$190,x_pos(a0)
                move.w  #$98,y_pos(a0)
                tst.b   subtype(a0)
                beq.s   S3CompGoal_InstallP1LapDigitUpdate
                tst.b   (Not_ghost_flag).w
                bne.s   S3CompGoal_InstallP2LapDigitUpdate
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3CompGoal_InstallP2LapDigitUpdate:
                bset    #4,render_flags(a0)
                move.l  #S3CompGoal_ReadAndClampP2Lap,(a0)
                bra.s   S3CompGoal_ReadAndClampP2Lap
; ---------------------------------------------------------------------------

S3CompGoal_InstallP1LapDigitUpdate:
                bset    #3,render_flags(a0)
                move.l  #S3CompGoal_ReadAndClampP1Lap,(a0)

S3CompGoal_ReadAndClampP1Lap:
                move.b  (Competition_current_lap).w,d0
                cmp.b   (Competition_total_laps).w,d0
                ble.s   S3CompGoal_DrawP1LapModulo10
                move.b  (Competition_total_laps).w,d0

S3CompGoal_DrawP1LapModulo10:
                subi.b  #$A,d0
                bcc.s   S3CompGoal_DrawP1LapModulo10
                addi.b  #$A,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3CompGoal_ReadAndClampP2Lap:
                move.b  (Competition_current_lap_2P).w,d0
                cmp.b   (Competition_total_laps).w,d0
                ble.s   S3CompGoal_DrawP2LapModulo10
                move.b  (Competition_total_laps).w,d0

S3CompGoal_DrawP2LapModulo10:
                subi.b  #$A,d0
                bcc.s   S3CompGoal_DrawP2LapModulo10
                addi.b  #$A,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_2PLapNumbers:
                include "src/game/competition/shared/mappings/lap_numbers.s"
