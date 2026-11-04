; Owner: objects/competition/sk
; Responsibility: Competition neon display animation, start countdown, race state and finish presentation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SKRaceNeon_InitRaceNeon:
                move.l  #Map_2PNeonDisplay,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PLapNum+$56,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.l  #SKRaceNeon_AnimateAndGateCountdownSound,(a0)
                tst.b   (Not_ghost_flag).w
                bne.s   SKRaceNeon_AnimateAndGateCountdownSound
                bset    #3,render_flags(a0)

SKRaceNeon_AnimateAndGateCountdownSound:
                lea     (Ani_2PNeonDisplay).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #1,anim(a0)
                bne.s   SKRaceNeon_UpdateRaceAndCheckWrongWay
                cmpi.b  #5,anim_frame_timer(a0)
                bne.s   SKRaceNeon_UpdateRaceAndCheckWrongWay
                moveq   #signextendB(sfx_LaunchReady),d0
                move.b  anim_frame(a0),d1
                cmpi.b  #1,d1
                beq.s   SKRaceNeon_PlayCountdownSound
                cmpi.b  #11,d1
                beq.s   SKRaceNeon_PlayCountdownSound
                cmpi.b  #21,d1
                beq.s   SKRaceNeon_PlayCountdownSound
                moveq   #signextendB(sfx_LaunchGo),d0
                cmpi.b  #31,d1
                bne.s   SKRaceNeon_UpdateRaceAndCheckWrongWay

SKRaceNeon_PlayCountdownSound:
                jsr     (Play_SFX).l

SKRaceNeon_UpdateRaceAndCheckWrongWay:
                bsr.s   SKCompNeon_UpdateRaceState
                tst.w   (Events_bg+$14).w
                bne.s   SKRaceNeon_SkipNeonDrawReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRaceNeon_SkipNeonDrawReturn:
                rts

; =============== S U B R O U T I N E =======================================

; Start timing at GO and advance or wait on the Grand Prix results. A secondary display can acknowledge late finishers
SKCompNeon_UpdateRaceState:
                move.b  $3A(a0),d0
                bne.s   SKRaceNeon_DispatchRaceAndCheckTimeCap
                tst.b   (Ctrl_1_locked).w
                beq.s   SKRaceNeon_StartBothClocksAtFrame3
                move.w  #1,anim(a0)
                move.b  #$A,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

SKRaceNeon_StartBothClocksAtFrame3:
                cmpi.b  #3,mapping_frame(a0)
                bne.s   SKRaceNeon_RaceStartReturn
                move.b  #1,(Update_HUD_timer).w
                move.b  #1,(Update_HUD_timer_P2).w
                move.b  #1,$3A(a0)

SKRaceNeon_RaceStartReturn:
                rts
; ---------------------------------------------------------------------------

SKRaceNeon_DispatchRaceAndCheckTimeCap:
                subq.b  #1,d0
                bne.w   SKRaceNeon_DispatchPostRaceAndWait
                move.l  #(9<<16)|(59<<8)|99,d0
                cmp.l   (Competition_time_record).w,d0
                bls.s   SKRaceNeon_BeginTimeCapFinishWait
                cmp.l   (Competition_time_record_P2).w,d0
                bhi.s   SKRaceNeon_CheckP1FirstFinish

SKRaceNeon_BeginTimeCapFinishWait:
                move.b  #2,$3A(a0)
                move.w  #$78,(Events_bg+$16).w

SKRaceNeon_CheckP1FirstFinish:
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap).w,d0
                bhs.s   SKRaceNeon_CheckP2FirstFinish
                move.b  #3,anim(a0)
                tst.b   (Not_ghost_flag).w
                beq.s   SKRaceNeon_MarkP1FinishAndSetWait
                addq.b  #1,anim(a0)

SKRaceNeon_MarkP1FinishAndSetWait:
                bset    #3,render_flags(a0)
                move.b  #2,$3A(a0)
                move.w  #$78,(Events_bg+$16).w
                tst.b   (Not_ghost_flag).w
                beq.s   SKRaceNeon_StopP1ClockAndRecordTime
                tst.b   (Competition_type).w
                bne.s   SKRaceNeon_StopP1ClockAndRecordTime
                move.w  #$168,(Events_bg+$16).w

SKRaceNeon_StopP1ClockAndRecordTime:
                move.b  #$80,(Update_HUD_timer).w
                jsr     SKCompTimeAttack_TrySaveP1Top3(pc)
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap_2P).w,d0
                bhs.s   SKRaceNeon_TrySpawnP2LateFinisher
                move.b  #6,anim(a0)
                bclr    #3,render_flags(a0)
                move.w  #$78,(Events_bg+$16).w
                move.b  #$80,(Update_HUD_timer_P2).w
                rts
; ---------------------------------------------------------------------------

SKRaceNeon_TrySpawnP2LateFinisher:
                bsr.w   SKCompNeon_TrySpawnLateFinish
                rts
; ---------------------------------------------------------------------------

SKRaceNeon_CheckP2FirstFinish:
                cmp.b   (Competition_current_lap_2P).w,d0
                bhs.s   SKRaceNeon_P2FinishCheckReturn
                move.b  #4,anim(a0)
                bset    #4,render_flags(a0)
                move.b  #2,$3A(a0)
                move.w  #$78,(Events_bg+$16).w
                tst.b   (Competition_type).w
                bne.s   SKRaceNeon_StopP2ClockAndPlayGoal
                move.w  #$168,(Events_bg+$16).w

SKRaceNeon_StopP2ClockAndPlayGoal:
                move.b  #$80,(Update_HUD_timer_P2).w
                bsr.w   SKCompNeon_TrySpawnLateFinish
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

SKRaceNeon_P2FinishCheckReturn:
                rts
; ---------------------------------------------------------------------------

SKRaceNeon_DispatchPostRaceAndWait:
                subq.b  #1,d0
                bne.w   SKRaceNeon_CheckP1LateFinish
                tst.b   (Competition_type).w
                beq.s   SKRaceNeon_SelectGPLapGate
                tst.b   (Update_HUD_timer).w
                bpl.s   SKRaceNeon_FinishWaitReturn
                tst.b   (Not_ghost_flag).w
                beq.s   SKRaceNeon_FinishWaitAndExitRace
                tst.b   (Update_HUD_timer_P2).w
                bpl.s   SKRaceNeon_FinishWaitReturn

SKRaceNeon_FinishWaitAndExitRace:
                subq.w  #1,(Events_bg+$16).w
                bpl.s   SKRaceNeon_FinishWaitReturn
                move.b  #GameMode_CompetitionLevelSelect,(Game_mode).w
                tst.b   (Competition_type).w
                bpl.s   SKRaceNeon_FinishWaitReturn
                move.b  #GameMode_TimeAttackRecords,(Game_mode).w

SKRaceNeon_FinishWaitReturn:
                rts
; ---------------------------------------------------------------------------

; The original code checks the P1 timer flag again after loading the P2 lap
SKRaceNeon_SelectGPLapGate:
                move.b  (Competition_current_lap).w,d0
                tst.b   (Update_HUD_timer).w
                bpl.s   SKRaceNeon_SkipGPWaitAtTotalLap
                move.b  (Competition_current_lap_2P).w,d0
                tst.b   (Update_HUD_timer).w
                bmi.s   SKRaceNeon_TickGPWaitAndCommit

SKRaceNeon_SkipGPWaitAtTotalLap:
                cmp.b   (Competition_total_laps).w,d0
                beq.s   SKRaceNeon_CheckGPTimeCapOrHold

SKRaceNeon_TickGPWaitAndCommit:
                subq.w  #1,(Events_bg+$16).w
                bmi.s   SKRaceNeon_StoreGPTimesAndCheckP1

SKRaceNeon_CheckGPTimeCapOrHold:
                cmpi.l  #(9<<16)|(59<<8)|99,(Competition_time_record).w
                bhs.s   SKRaceNeon_StoreGPTimesAndCheckP1
                cmpi.l  #(9<<16)|(59<<8)|99,(Competition_time_record_P2).w
                blo.s   SKRaceNeon_GPFinishReturn

; Subtract the first competition zone ID before indexing the result-offset table, with no bounds check
SKRaceNeon_StoreGPTimesAndCheckP1:
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                subi.b  #$E,d0
                move.b  SKRaceNeon_GPResultOffsetTable(pc,d0.w),d0
                lea     ((RAM_start+$7800)&$FFFFFF).l,a1
                move.l  (Competition_time_record).w,(a1,d0.w)
                move.l  (Competition_time_record_P2).w,$14(a1,d0.w)
                tst.b   (Update_HUD_timer).w
                bmi.s   SKRaceNeon_MarkUnstoppedP2AtTimeCap
                move.l  #(9<<16)|(59<<8)|99,(a1,d0.w)

SKRaceNeon_MarkUnstoppedP2AtTimeCap:
                tst.b   (Update_HUD_timer_P2).w
                bmi.s   SKRaceNeon_SelectNextGPZoneOrResults
                move.l  #(9<<16)|(59<<8)|99,$14(a1,d0.w)

SKRaceNeon_SelectNextGPZoneOrResults:
                move.b  (Current_zone).w,d0
                subi.b  #$E,d0
                move.b  SKRaceNeon_GPNextZoneTable(pc,d0.w),d0
                beq.s   SKRaceNeon_OpenGrandPrixResults
                move.b  d0,(Current_zone).w
                move.b  #1,(Restart_level_flag).w
                rts
; ---------------------------------------------------------------------------

SKRaceNeon_OpenGrandPrixResults:
                move.b  #GameMode_CompetitionResults,(Game_mode).w

SKRaceNeon_GPFinishReturn:
                rts
; ---------------------------------------------------------------------------
SKRaceNeon_GPNextZoneTable:
                dc.b    $F
                dc.b    $11
                dc.b    $12
                dc.b    $10
                dc.b    0
SKRaceNeon_GPResultOffsetTable:
                dc.b    0
                dc.b    4
                dc.b    $C
                dc.b    8
                dc.b    $10
                even
; ---------------------------------------------------------------------------

SKRaceNeon_CheckP1LateFinish:
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap).w,d0
                bhs.s   SKRaceNeon_CheckP2LateFinish
                tst.b   (Update_HUD_timer).w
                bmi.s   SKRaceNeon_CheckP2LateFinish
                move.b  #5,anim(a0)
                bset    #3,render_flags(a0)
                move.b  #$80,(Update_HUD_timer).w
                move.w  #$78,(Events_bg+$16).w
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

SKRaceNeon_CheckP2LateFinish:
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap_2P).w,d0
                bhs.s   SKRaceNeon_LateFinishUpdateReturn
                tst.b   (Update_HUD_timer_P2).w
                bmi.s   SKRaceNeon_LateFinishUpdateReturn
                move.b  #5,anim(a0)
                bset    #4,render_flags(a0)
                move.b  #$80,(Update_HUD_timer_P2).w
                move.w  #$78,(Events_bg+$16).w
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

SKRaceNeon_LateFinishUpdateReturn:
                rts
; End of function SKCompNeon_UpdateRaceState

; =============== S U B R O U T I N E =======================================

SKCompNeon_TrySpawnLateFinish:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKRaceNeon_LateFinisherSpawnReturn
                move.l  #SKRaceNeon_InitRaceNeon,(a1)
                move.w  #$120,x_pos(a1)
                move.w  #$B8,y_pos(a1)
                move.b  #2,anim(a1)
                move.b  #3,$3A(a1)

SKRaceNeon_LateFinisherSpawnReturn:
                rts
; End of function SKCompNeon_TrySpawnLateFinish

; =============== S U B R O U T I N E =======================================

; Insert the time and selected character in the current zone's table when the competition type is negative
SKCompTimeAttack_TrySaveP1Top3:
                tst.b   (Competition_type).w
                bpl.w   SKRaceNeon_TimeRecordUpdateReturn
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                subi.w  #$E,d0
                lsl.w   #4,d0
                lea     (Competition_saved_data).w,a1
                adda.w  d0,a1
                move.l  (Competition_time_record).w,d0
                cmp.l   (a1),d0
                bhs.s   SKRaceNeon_TrySecondTimeRecord
                move.b  $D(a1),$E(a1)
                move.b  $C(a1),$D(a1)
                move.b  (P1_character).w,$C(a1)
                move.l  4(a1),8(a1)
                move.l  (a1),4(a1)
                move.l  d0,(a1)
                clr.b   (Competition_time_attack_new_top_record).w
                bra.s   SKRaceNeon_SaveUpdatedTimeRecords
; ---------------------------------------------------------------------------

SKRaceNeon_TrySecondTimeRecord:
                cmp.l   4(a1),d0
                bhs.s   SKRaceNeon_TryThirdTimeRecord
                move.b  $D(a1),$E(a1)
                move.b  (P1_character).w,$D(a1)
                move.l  4(a1),8(a1)
                move.l  d0,4(a1)
                move.b  #1,(Competition_time_attack_new_top_record).w
                bra.s   SKRaceNeon_SaveUpdatedTimeRecords
; ---------------------------------------------------------------------------

SKRaceNeon_TryThirdTimeRecord:
                cmp.l   8(a1),d0
                bhs.s   SKRaceNeon_TimeRecordUpdateReturn
                move.b  (P1_character).w,$E(a1)
                move.l  d0,8(a1)
                move.b  #2,(Competition_time_attack_new_top_record).w

SKRaceNeon_SaveUpdatedTimeRecords:
                jsr     (Write_SaveGeneral).l

SKRaceNeon_TimeRecordUpdateReturn:
                rts
; End of function SKCompTimeAttack_TrySaveP1Top3

; ---------------------------------------------------------------------------

SKRaceNeon_InitWrongWayIndicator:
                move.l  #Map_2PNeonDisplay,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PLapNum+$56,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$B8,y_pos(a0)
                move.b  #7,anim(a0)
                move.l  #SKRaceNeon_DeleteWrongWayIndicator,(a0)

SKRaceNeon_DeleteWrongWayIndicator:
                tst.w   (Events_bg+$14).w
                bne.s   SKRaceNeon_AnimateAndDrawWrongWay
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKRaceNeon_AnimateAndDrawWrongWay:
                lea     (Ani_2PNeonDisplay).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_2PNeonDisplay:
                include "src/game/competition/shared/animations/neon_display.s"
Map_2PNeonDisplay:
                include "src/game/competition/shared/mappings/neon_display.s"
