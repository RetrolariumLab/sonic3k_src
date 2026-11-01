; Owner: objects/competition/s3
; Responsibility: Competition neon display animation, start countdown, race state and finish presentation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_366CC:
                move.l  #Map_2PNeonDisplay,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PLapNum+$56,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.l  #loc_366FE,(a0)
                tst.b   (Not_ghost_flag).w
                bne.s   loc_366FE
                bset    #3,render_flags(a0)

loc_366FE:
                lea     (Ani_2PNeonDisplay).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #1,anim(a0)
                bne.s   loc_36740
                cmpi.b  #5,anim_frame_timer(a0)
                bne.s   loc_36740
                moveq   #signextendB(sfx_LaunchReady),d0
                move.b  anim_frame(a0),d1
                cmpi.b  #1,d1
                beq.s   loc_3673A
                cmpi.b  #11,d1
                beq.s   loc_3673A
                cmpi.b  #21,d1
                beq.s   loc_3673A
                moveq   #signextendB(sfx_LaunchGo),d0
                cmpi.b  #31,d1
                bne.s   loc_36740

loc_3673A:
                jsr     (Play_SFX).l

loc_36740:
                bsr.s   CompetitionS3UpdateNeonRaceStartFinishAndProgression
                tst.w   (Events_bg+$14).w
                bne.s   locret_3674E
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_3674E:
                rts

; =============== S U B R O U T I N E =======================================

CompetitionS3UpdateNeonRaceStartFinishAndProgression:
                move.b  $3A(a0),d0
                bne.s   loc_36786
                tst.b   (Ctrl_1_locked).w
                beq.s   loc_3676A
                move.w  #1,anim(a0)
                move.b  #$A,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_3676A:
                cmpi.b  #3,mapping_frame(a0)
                bne.s   locret_36784
                move.b  #1,(Update_HUD_timer).w
                move.b  #1,(Update_HUD_timer_P2).w
                move.b  #1,$3A(a0)

locret_36784:
                rts
; ---------------------------------------------------------------------------

loc_36786:
                subq.b  #1,d0
                bne.w   loc_36862
                move.l  #(9<<16)|(59<<8)|99,d0
                cmp.l   (Competition_time_record).w,d0
                bls.s   loc_3679E
                cmp.l   (Competition_time_record_P2).w,d0
                bhi.s   loc_367AA

loc_3679E:
                move.b  #2,$3A(a0)
                move.w  #$78,(Events_bg+$16).w

loc_367AA:
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap).w,d0
                bhs.s   loc_36824
                move.b  #3,anim(a0)
                tst.b   (Not_ghost_flag).w
                beq.s   loc_367C4
                addq.b  #1,anim(a0)

loc_367C4:
                bset    #3,render_flags(a0)
                move.b  #2,$3A(a0)
                move.w  #$78,(Events_bg+$16).w
                tst.b   (Not_ghost_flag).w
                beq.s   loc_367E8
                tst.b   (Competition_type).w
                bne.s   loc_367E8
                move.w  #$168,(Events_bg+$16).w

loc_367E8:
                move.b  #$80,(Update_HUD_timer).w
                jsr     CompetitionS3InsertP1TimeAttackTopThreeAndSave(pc)
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap_2P).w,d0
                bhs.s   loc_3681E
                move.b  #6,anim(a0)
                bclr    #3,render_flags(a0)
                move.w  #$78,(Events_bg+$16).w
                move.b  #$80,(Update_HUD_timer_P2).w
                rts
; ---------------------------------------------------------------------------

loc_3681E:
                bsr.w   CompetitionS3SpawnNeonLateFinisherDisplay
                rts
; ---------------------------------------------------------------------------

loc_36824:
                cmp.b   (Competition_current_lap_2P).w,d0
                bhs.s   locret_36860
                move.b  #4,anim(a0)
                bset    #4,render_flags(a0)
                move.b  #2,$3A(a0)
                move.w  #$78,(Events_bg+$16).w
                tst.b   (Competition_type).w
                bne.s   loc_3684E
                move.w  #$168,(Events_bg+$16).w

loc_3684E:
                move.b  #$80,(Update_HUD_timer_P2).w
                bsr.w   CompetitionS3SpawnNeonLateFinisherDisplay
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

locret_36860:
                rts
; ---------------------------------------------------------------------------

loc_36862:
                subq.b  #1,d0
                bne.w   loc_36936
                tst.b   (Competition_type).w
                beq.s   loc_3689A
                tst.b   (Update_HUD_timer).w
                bpl.s   locret_36898
                tst.b   (Not_ghost_flag).w
                beq.s   loc_36880
                tst.b   (Update_HUD_timer_P2).w
                bpl.s   locret_36898

loc_36880:
                subq.w  #1,(Events_bg+$16).w
                bpl.s   locret_36898
                move.b  #GameMode_CompetitionLevelSelect,(Game_mode).w
                tst.b   (Competition_type).w
                bpl.s   locret_36898
                move.b  #GameMode_TimeAttackRecords,(Game_mode).w

locret_36898:
                rts
; ---------------------------------------------------------------------------

loc_3689A:
                move.b  (Competition_current_lap).w,d0
                tst.b   (Update_HUD_timer).w
                bpl.s   loc_368AE
                move.b  (Competition_current_lap_2P).w,d0
                tst.b   (Update_HUD_timer).w
                bmi.s   loc_368B4

loc_368AE:
                cmp.b   (Competition_total_laps).w,d0
                beq.s   loc_368BA

loc_368B4:
                subq.w  #1,(Events_bg+$16).w
                bmi.s   loc_368CE

loc_368BA:
                cmpi.l  #(9<<16)|(59<<8)|99,(Competition_time_record).w
                bhs.s   loc_368CE
                cmpi.l  #(9<<16)|(59<<8)|99,(Competition_time_record_P2).w
                blo.s   locret_3692A

loc_368CE:
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                subi.b  #$E,d0
                move.b  byte_36931(pc,d0.w),d0
                lea     ((RAM_start+$7800)&$FFFFFF).l,a1
                move.l  (Competition_time_record).w,(a1,d0.w)
                move.l  (Competition_time_record_P2).w,$14(a1,d0.w)
                tst.b   (Update_HUD_timer).w
                bmi.s   loc_368FC
                move.l  #(9<<16)|(59<<8)|99,(a1,d0.w)

loc_368FC:
                tst.b   (Update_HUD_timer_P2).w
                bmi.s   loc_3690A
                move.l  #(9<<16)|(59<<8)|99,$14(a1,d0.w)

loc_3690A:
                move.b  (Current_zone).w,d0
                subi.b  #$E,d0
                move.b  byte_3692C(pc,d0.w),d0
                beq.s   loc_36924
                move.b  d0,(Current_zone).w
                move.b  #1,(Restart_level_flag).w
                rts
; ---------------------------------------------------------------------------

loc_36924:
                move.b  #GameMode_CompetitionResults,(Game_mode).w

locret_3692A:
                rts
; ---------------------------------------------------------------------------
byte_3692C:
                dc.b    $F
                dc.b    $11
                dc.b    $12
                dc.b    $10
                dc.b    0
byte_36931:
                dc.b    0
                dc.b    4
                dc.b    $C
                dc.b    8
                dc.b    $10
                even
; ---------------------------------------------------------------------------

loc_36936:
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap).w,d0
                bhs.s   loc_36966
                tst.b   (Update_HUD_timer).w
                bmi.s   loc_36966
                move.b  #5,anim(a0)
                bset    #3,render_flags(a0)
                move.b  #$80,(Update_HUD_timer).w
                move.w  #$78,(Events_bg+$16).w
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

loc_36966:
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap_2P).w,d0
                bhs.s   locret_36996
                tst.b   (Update_HUD_timer_P2).w
                bmi.s   locret_36996
                move.b  #5,anim(a0)
                bset    #4,render_flags(a0)
                move.b  #$80,(Update_HUD_timer_P2).w
                move.w  #$78,(Events_bg+$16).w
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

locret_36996:
                rts
; End of function CompetitionS3UpdateNeonRaceStartFinishAndProgression

; =============== S U B R O U T I N E =======================================

CompetitionS3SpawnNeonLateFinisherDisplay:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   locret_369C0
                move.l  #loc_366CC,(a1)
                move.w  #$120,x_pos(a1)
                move.w  #$B8,y_pos(a1)
                move.b  #2,anim(a1)
                move.b  #3,$3A(a1)

locret_369C0:
                rts
; End of function CompetitionS3SpawnNeonLateFinisherDisplay

; =============== S U B R O U T I N E =======================================

CompetitionS3InsertP1TimeAttackTopThreeAndSave:
                tst.b   (Competition_type).w
                bpl.w   locret_36A48
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                subi.w  #$E,d0
                lsl.w   #4,d0
                lea     (Competition_saved_data).w,a1
                adda.w  d0,a1
                move.l  (Competition_time_record).w,d0
                cmp.l   (a1),d0
                bhs.s   loc_36A08
                move.b  $D(a1),$E(a1)
                move.b  $C(a1),$D(a1)
                move.b  (P1_character).w,$C(a1)
                move.l  4(a1),8(a1)
                move.l  (a1),4(a1)
                move.l  d0,(a1)
                clr.b   (Competition_time_attack_new_top_record).w
                bra.s   loc_36A42
; ---------------------------------------------------------------------------

loc_36A08:
                cmp.l   4(a1),d0
                bhs.s   loc_36A2C
                move.b  $D(a1),$E(a1)
                move.b  (P1_character).w,$D(a1)
                move.l  4(a1),8(a1)
                move.l  d0,4(a1)
                move.b  #1,(Competition_time_attack_new_top_record).w
                bra.s   loc_36A42
; ---------------------------------------------------------------------------

loc_36A2C:
                cmp.l   8(a1),d0
                bhs.s   locret_36A48
                move.b  (P1_character).w,$E(a1)
                move.l  d0,8(a1)
                move.b  #2,(Competition_time_attack_new_top_record).w

loc_36A42:
                jsr     (Write_SaveGeneral).l

locret_36A48:
                rts
; End of function CompetitionS3InsertP1TimeAttackTopThreeAndSave

; ---------------------------------------------------------------------------

loc_36A4A:
                move.l  #Map_2PNeonDisplay,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PLapNum+$56,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$B8,y_pos(a0)
                move.b  #7,anim(a0)
                move.l  #loc_36A82,(a0)

loc_36A82:
                tst.w   (Events_bg+$14).w
                bne.s   loc_36A8E
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_36A8E:
                lea     (Ani_2PNeonDisplay).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_2PNeonDisplay:
                include "src/game/competition/shared/animations/neon_display.s"
Map_2PNeonDisplay:
                include "src/game/competition/shared/mappings/neon_display.s"
