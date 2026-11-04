; Owner: objects/competition/s3
; Responsibility: Competition neon display animation, start countdown, race state and finish presentation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

S3RaceNeon_InitRaceNeon:
                move.l  #Map_2PNeonDisplay,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PLapNum+$56,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.l  #S3RaceNeon_AnimateAndGateCountdownSound,(a0)
                tst.b   (Not_ghost_flag).w
                bne.s   S3RaceNeon_AnimateAndGateCountdownSound
                bset    #3,render_flags(a0)

S3RaceNeon_AnimateAndGateCountdownSound:
                lea     (Ani_2PNeonDisplay).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #1,anim(a0)
                bne.s   S3RaceNeon_UpdateRaceAndCheckWrongWay
                cmpi.b  #5,anim_frame_timer(a0)
                bne.s   S3RaceNeon_UpdateRaceAndCheckWrongWay
                moveq   #signextendB(sfx_LaunchReady),d0
                move.b  anim_frame(a0),d1
                cmpi.b  #1,d1
                beq.s   S3RaceNeon_PlayCountdownSound
                cmpi.b  #11,d1
                beq.s   S3RaceNeon_PlayCountdownSound
                cmpi.b  #21,d1
                beq.s   S3RaceNeon_PlayCountdownSound
                moveq   #signextendB(sfx_LaunchGo),d0
                cmpi.b  #31,d1
                bne.s   S3RaceNeon_UpdateRaceAndCheckWrongWay

S3RaceNeon_PlayCountdownSound:
                jsr     (Play_SFX).l

S3RaceNeon_UpdateRaceAndCheckWrongWay:
                bsr.s   S3CompNeon_UpdateRaceState
                tst.w   (Events_bg+$14).w
                bne.s   S3RaceNeon_SkipNeonDrawReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3RaceNeon_SkipNeonDrawReturn:
                rts

; =============== S U B R O U T I N E =======================================

; Start timing at GO and advance or wait on the Grand Prix results. A secondary display can acknowledge late finishers
S3CompNeon_UpdateRaceState:
                move.b  $3A(a0),d0
                bne.s   S3RaceNeon_DispatchRaceAndCheckTimeCap
                tst.b   (Ctrl_1_locked).w
                beq.s   S3RaceNeon_StartBothClocksAtFrame3
                move.w  #1,anim(a0)
                move.b  #$A,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

S3RaceNeon_StartBothClocksAtFrame3:
                cmpi.b  #3,mapping_frame(a0)
                bne.s   S3RaceNeon_RaceStartReturn
                move.b  #1,(Update_HUD_timer).w
                move.b  #1,(Update_HUD_timer_P2).w
                move.b  #1,$3A(a0)

S3RaceNeon_RaceStartReturn:
                rts
; ---------------------------------------------------------------------------

S3RaceNeon_DispatchRaceAndCheckTimeCap:
                subq.b  #1,d0
                bne.w   S3RaceNeon_DispatchPostRaceAndWait
                move.l  #(9<<16)|(59<<8)|99,d0
                cmp.l   (Competition_time_record).w,d0
                bls.s   S3RaceNeon_BeginTimeCapFinishWait
                cmp.l   (Competition_time_record_P2).w,d0
                bhi.s   S3RaceNeon_CheckP1FirstFinish

S3RaceNeon_BeginTimeCapFinishWait:
                move.b  #2,$3A(a0)
                move.w  #$78,(Events_bg+$16).w

S3RaceNeon_CheckP1FirstFinish:
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap).w,d0
                bhs.s   S3RaceNeon_CheckP2FirstFinish
                move.b  #3,anim(a0)
                tst.b   (Not_ghost_flag).w
                beq.s   S3RaceNeon_MarkP1FinishAndSetWait
                addq.b  #1,anim(a0)

S3RaceNeon_MarkP1FinishAndSetWait:
                bset    #3,render_flags(a0)
                move.b  #2,$3A(a0)
                move.w  #$78,(Events_bg+$16).w
                tst.b   (Not_ghost_flag).w
                beq.s   S3RaceNeon_StopP1ClockAndRecordTime
                tst.b   (Competition_type).w
                bne.s   S3RaceNeon_StopP1ClockAndRecordTime
                move.w  #$168,(Events_bg+$16).w

S3RaceNeon_StopP1ClockAndRecordTime:
                move.b  #$80,(Update_HUD_timer).w
                jsr     S3CompTimeAttack_TrySaveP1Top3(pc)
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap_2P).w,d0
                bhs.s   S3RaceNeon_TrySpawnP2LateFinisher
                move.b  #6,anim(a0)
                bclr    #3,render_flags(a0)
                move.w  #$78,(Events_bg+$16).w
                move.b  #$80,(Update_HUD_timer_P2).w
                rts
; ---------------------------------------------------------------------------

S3RaceNeon_TrySpawnP2LateFinisher:
                bsr.w   S3CompNeon_TrySpawnLateFinish
                rts
; ---------------------------------------------------------------------------

S3RaceNeon_CheckP2FirstFinish:
                cmp.b   (Competition_current_lap_2P).w,d0
                bhs.s   S3RaceNeon_P2FinishCheckReturn
                move.b  #4,anim(a0)
                bset    #4,render_flags(a0)
                move.b  #2,$3A(a0)
                move.w  #$78,(Events_bg+$16).w
                tst.b   (Competition_type).w
                bne.s   S3RaceNeon_StopP2ClockAndPlayGoal
                move.w  #$168,(Events_bg+$16).w

S3RaceNeon_StopP2ClockAndPlayGoal:
                move.b  #$80,(Update_HUD_timer_P2).w
                bsr.w   S3CompNeon_TrySpawnLateFinish
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

S3RaceNeon_P2FinishCheckReturn:
                rts
; ---------------------------------------------------------------------------

S3RaceNeon_DispatchPostRaceAndWait:
                subq.b  #1,d0
                bne.w   S3RaceNeon_CheckP1LateFinish
                tst.b   (Competition_type).w
                beq.s   S3RaceNeon_SelectGPLapGate
                tst.b   (Update_HUD_timer).w
                bpl.s   S3RaceNeon_FinishWaitReturn
                tst.b   (Not_ghost_flag).w
                beq.s   S3RaceNeon_FinishWaitAndExitRace
                tst.b   (Update_HUD_timer_P2).w
                bpl.s   S3RaceNeon_FinishWaitReturn

S3RaceNeon_FinishWaitAndExitRace:
                subq.w  #1,(Events_bg+$16).w
                bpl.s   S3RaceNeon_FinishWaitReturn
                move.b  #GameMode_CompetitionLevelSelect,(Game_mode).w
                tst.b   (Competition_type).w
                bpl.s   S3RaceNeon_FinishWaitReturn
                move.b  #GameMode_TimeAttackRecords,(Game_mode).w

S3RaceNeon_FinishWaitReturn:
                rts
; ---------------------------------------------------------------------------

; The original code checks the P1 timer flag again after loading the P2 lap
S3RaceNeon_SelectGPLapGate:
                move.b  (Competition_current_lap).w,d0
                tst.b   (Update_HUD_timer).w
                bpl.s   S3RaceNeon_SkipGPWaitAtTotalLap
                move.b  (Competition_current_lap_2P).w,d0
                tst.b   (Update_HUD_timer).w
                bmi.s   S3RaceNeon_TickGPWaitAndCommit

S3RaceNeon_SkipGPWaitAtTotalLap:
                cmp.b   (Competition_total_laps).w,d0
                beq.s   S3RaceNeon_CheckGPTimeCapOrHold

S3RaceNeon_TickGPWaitAndCommit:
                subq.w  #1,(Events_bg+$16).w
                bmi.s   S3RaceNeon_StoreGPTimesAndCheckP1

S3RaceNeon_CheckGPTimeCapOrHold:
                cmpi.l  #(9<<16)|(59<<8)|99,(Competition_time_record).w
                bhs.s   S3RaceNeon_StoreGPTimesAndCheckP1
                cmpi.l  #(9<<16)|(59<<8)|99,(Competition_time_record_P2).w
                blo.s   S3RaceNeon_GPFinishReturn

; Subtract the first competition zone ID before indexing the result-offset table, with no bounds check
S3RaceNeon_StoreGPTimesAndCheckP1:
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                subi.b  #$E,d0
                move.b  S3RaceNeon_GPResultOffsetTable(pc,d0.w),d0
                lea     ((RAM_start+$7800)&$FFFFFF).l,a1
                move.l  (Competition_time_record).w,(a1,d0.w)
                move.l  (Competition_time_record_P2).w,$14(a1,d0.w)
                tst.b   (Update_HUD_timer).w
                bmi.s   S3RaceNeon_MarkUnstoppedP2AtTimeCap
                move.l  #(9<<16)|(59<<8)|99,(a1,d0.w)

S3RaceNeon_MarkUnstoppedP2AtTimeCap:
                tst.b   (Update_HUD_timer_P2).w
                bmi.s   S3RaceNeon_SelectNextGPZoneOrResults
                move.l  #(9<<16)|(59<<8)|99,$14(a1,d0.w)

S3RaceNeon_SelectNextGPZoneOrResults:
                move.b  (Current_zone).w,d0
                subi.b  #$E,d0
                move.b  S3RaceNeon_GPNextZoneTable(pc,d0.w),d0
                beq.s   S3RaceNeon_OpenGrandPrixResults
                move.b  d0,(Current_zone).w
                move.b  #1,(Restart_level_flag).w
                rts
; ---------------------------------------------------------------------------

S3RaceNeon_OpenGrandPrixResults:
                move.b  #GameMode_CompetitionResults,(Game_mode).w

S3RaceNeon_GPFinishReturn:
                rts
; ---------------------------------------------------------------------------
S3RaceNeon_GPNextZoneTable:
                dc.b    $F
                dc.b    $11
                dc.b    $12
                dc.b    $10
                dc.b    0
S3RaceNeon_GPResultOffsetTable:
                dc.b    0
                dc.b    4
                dc.b    $C
                dc.b    8
                dc.b    $10
                even
; ---------------------------------------------------------------------------

S3RaceNeon_CheckP1LateFinish:
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap).w,d0
                bhs.s   S3RaceNeon_CheckP2LateFinish
                tst.b   (Update_HUD_timer).w
                bmi.s   S3RaceNeon_CheckP2LateFinish
                move.b  #5,anim(a0)
                bset    #3,render_flags(a0)
                move.b  #$80,(Update_HUD_timer).w
                move.w  #$78,(Events_bg+$16).w
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

S3RaceNeon_CheckP2LateFinish:
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap_2P).w,d0
                bhs.s   S3RaceNeon_LateFinishUpdateReturn
                tst.b   (Update_HUD_timer_P2).w
                bmi.s   S3RaceNeon_LateFinishUpdateReturn
                move.b  #5,anim(a0)
                bset    #4,render_flags(a0)
                move.b  #$80,(Update_HUD_timer_P2).w
                move.w  #$78,(Events_bg+$16).w
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

S3RaceNeon_LateFinishUpdateReturn:
                rts
; End of function S3CompNeon_UpdateRaceState

; =============== S U B R O U T I N E =======================================

S3CompNeon_TrySpawnLateFinish:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3RaceNeon_LateFinisherSpawnReturn
                move.l  #S3RaceNeon_InitRaceNeon,(a1)
                move.w  #$120,x_pos(a1)
                move.w  #$B8,y_pos(a1)
                move.b  #2,anim(a1)
                move.b  #3,$3A(a1)

S3RaceNeon_LateFinisherSpawnReturn:
                rts
; End of function S3CompNeon_TrySpawnLateFinish

; =============== S U B R O U T I N E =======================================

; Insert the time and selected character in the current zone's table when the competition type is negative
S3CompTimeAttack_TrySaveP1Top3:
                tst.b   (Competition_type).w
                bpl.w   S3RaceNeon_TimeRecordUpdateReturn
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                subi.w  #$E,d0
                lsl.w   #4,d0
                lea     (Competition_saved_data).w,a1
                adda.w  d0,a1
                move.l  (Competition_time_record).w,d0
                cmp.l   (a1),d0
                bhs.s   S3RaceNeon_TrySecondTimeRecord
                move.b  $D(a1),$E(a1)
                move.b  $C(a1),$D(a1)
                move.b  (P1_character).w,$C(a1)
                move.l  4(a1),8(a1)
                move.l  (a1),4(a1)
                move.l  d0,(a1)
                clr.b   (Competition_time_attack_new_top_record).w
                bra.s   S3RaceNeon_SaveUpdatedTimeRecords
; ---------------------------------------------------------------------------

S3RaceNeon_TrySecondTimeRecord:
                cmp.l   4(a1),d0
                bhs.s   S3RaceNeon_TryThirdTimeRecord
                move.b  $D(a1),$E(a1)
                move.b  (P1_character).w,$D(a1)
                move.l  4(a1),8(a1)
                move.l  d0,4(a1)
                move.b  #1,(Competition_time_attack_new_top_record).w
                bra.s   S3RaceNeon_SaveUpdatedTimeRecords
; ---------------------------------------------------------------------------

S3RaceNeon_TryThirdTimeRecord:
                cmp.l   8(a1),d0
                bhs.s   S3RaceNeon_TimeRecordUpdateReturn
                move.b  (P1_character).w,$E(a1)
                move.l  d0,8(a1)
                move.b  #2,(Competition_time_attack_new_top_record).w

S3RaceNeon_SaveUpdatedTimeRecords:
                jsr     (Write_SaveGeneral).l

S3RaceNeon_TimeRecordUpdateReturn:
                rts
; End of function S3CompTimeAttack_TrySaveP1Top3

; ---------------------------------------------------------------------------

S3RaceNeon_InitWrongWayIndicator:
                move.l  #Map_2PNeonDisplay,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PLapNum+$56,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$B8,y_pos(a0)
                move.b  #7,anim(a0)
                move.l  #S3RaceNeon_DeleteWrongWayIndicator,(a0)

S3RaceNeon_DeleteWrongWayIndicator:
                tst.w   (Events_bg+$14).w
                bne.s   S3RaceNeon_AnimateAndDrawWrongWay
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3RaceNeon_AnimateAndDrawWrongWay:
                lea     (Ani_2PNeonDisplay).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_2PNeonDisplay:
                include "src/game/competition/shared/animations/neon_display.s"
Map_2PNeonDisplay:
                include "src/game/competition/shared/mappings/neon_display.s"
