; Owner: objects/competition/sk
; Responsibility: Competition neon display animation, start countdown, race state and finish presentation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_3713A:
                move.l  #Map_2PNeonDisplay,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PLapNum+$56,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.l  #loc_3716C,(a0)
                tst.b   (Not_ghost_flag).w
                bne.s   loc_3716C
                bset    #3,render_flags(a0)

loc_3716C:
                lea     (Ani_2PNeonDisplay).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #1,anim(a0)
                bne.s   loc_371AE
                cmpi.b  #5,anim_frame_timer(a0)
                bne.s   loc_371AE
                moveq   #signextendB(sfx_LaunchReady),d0
                move.b  anim_frame(a0),d1
                cmpi.b  #1,d1
                beq.s   loc_371A8
                cmpi.b  #11,d1
                beq.s   loc_371A8
                cmpi.b  #21,d1
                beq.s   loc_371A8
                moveq   #signextendB(sfx_LaunchGo),d0
                cmpi.b  #31,d1
                bne.s   loc_371AE

loc_371A8:
                jsr     (Play_SFX).l

loc_371AE:
                bsr.s   CompetitionSKUpdateNeonRaceStartFinishAndProgression
                tst.w   (Events_bg+$14).w
                bne.s   locret_371BC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_371BC:
                rts

; =============== S U B R O U T I N E =======================================

CompetitionSKUpdateNeonRaceStartFinishAndProgression:
                move.b  $3A(a0),d0
                bne.s   loc_371F4
                tst.b   (Ctrl_1_locked).w
                beq.s   loc_371D8
                move.w  #1,anim(a0)
                move.b  #$A,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_371D8:
                cmpi.b  #3,mapping_frame(a0)
                bne.s   locret_371F2
                move.b  #1,(Update_HUD_timer).w
                move.b  #1,(Update_HUD_timer_P2).w
                move.b  #1,$3A(a0)

locret_371F2:
                rts
; ---------------------------------------------------------------------------

loc_371F4:
                subq.b  #1,d0
                bne.w   loc_372D0
                move.l  #(9<<16)|(59<<8)|99,d0
                cmp.l   (Competition_time_record).w,d0
                bls.s   loc_3720C
                cmp.l   (Competition_time_record_P2).w,d0
                bhi.s   loc_37218

loc_3720C:
                move.b  #2,$3A(a0)
                move.w  #$78,(Events_bg+$16).w

loc_37218:
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap).w,d0
                bhs.s   loc_37292
                move.b  #3,anim(a0)
                tst.b   (Not_ghost_flag).w
                beq.s   loc_37232
                addq.b  #1,anim(a0)

loc_37232:
                bset    #3,render_flags(a0)
                move.b  #2,$3A(a0)
                move.w  #$78,(Events_bg+$16).w
                tst.b   (Not_ghost_flag).w
                beq.s   loc_37256
                tst.b   (Competition_type).w
                bne.s   loc_37256
                move.w  #$168,(Events_bg+$16).w

loc_37256:
                move.b  #$80,(Update_HUD_timer).w
                jsr     CompetitionSKInsertP1TimeAttackTopThreeAndSave(pc)
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap_2P).w,d0
                bhs.s   loc_3728C
                move.b  #6,anim(a0)
                bclr    #3,render_flags(a0)
                move.w  #$78,(Events_bg+$16).w
                move.b  #$80,(Update_HUD_timer_P2).w
                rts
; ---------------------------------------------------------------------------

loc_3728C:
                bsr.w   CompetitionSKSpawnNeonLateFinisherDisplay
                rts
; ---------------------------------------------------------------------------

loc_37292:
                cmp.b   (Competition_current_lap_2P).w,d0
                bhs.s   locret_372CE
                move.b  #4,anim(a0)
                bset    #4,render_flags(a0)
                move.b  #2,$3A(a0)
                move.w  #$78,(Events_bg+$16).w
                tst.b   (Competition_type).w
                bne.s   loc_372BC
                move.w  #$168,(Events_bg+$16).w

loc_372BC:
                move.b  #$80,(Update_HUD_timer_P2).w
                bsr.w   CompetitionSKSpawnNeonLateFinisherDisplay
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

locret_372CE:
                rts
; ---------------------------------------------------------------------------

loc_372D0:
                subq.b  #1,d0
                bne.w   loc_373A4
                tst.b   (Competition_type).w
                beq.s   loc_37308
                tst.b   (Update_HUD_timer).w
                bpl.s   locret_37306
                tst.b   (Not_ghost_flag).w
                beq.s   loc_372EE
                tst.b   (Update_HUD_timer_P2).w
                bpl.s   locret_37306

loc_372EE:
                subq.w  #1,(Events_bg+$16).w
                bpl.s   locret_37306
                move.b  #GameMode_CompetitionLevelSelect,(Game_mode).w
                tst.b   (Competition_type).w
                bpl.s   locret_37306
                move.b  #GameMode_TimeAttackRecords,(Game_mode).w

locret_37306:
                rts
; ---------------------------------------------------------------------------

loc_37308:
                move.b  (Competition_current_lap).w,d0
                tst.b   (Update_HUD_timer).w
                bpl.s   loc_3731C
                move.b  (Competition_current_lap_2P).w,d0
                tst.b   (Update_HUD_timer).w
                bmi.s   loc_37322

loc_3731C:
                cmp.b   (Competition_total_laps).w,d0
                beq.s   loc_37328

loc_37322:
                subq.w  #1,(Events_bg+$16).w
                bmi.s   loc_3733C

loc_37328:
                cmpi.l  #(9<<16)|(59<<8)|99,(Competition_time_record).w
                bhs.s   loc_3733C
                cmpi.l  #(9<<16)|(59<<8)|99,(Competition_time_record_P2).w
                blo.s   locret_37398

loc_3733C:
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                subi.b  #$E,d0
                move.b  byte_3739F(pc,d0.w),d0
                lea     ((RAM_start+$7800)&$FFFFFF).l,a1
                move.l  (Competition_time_record).w,(a1,d0.w)
                move.l  (Competition_time_record_P2).w,$14(a1,d0.w)
                tst.b   (Update_HUD_timer).w
                bmi.s   loc_3736A
                move.l  #(9<<16)|(59<<8)|99,(a1,d0.w)

loc_3736A:
                tst.b   (Update_HUD_timer_P2).w
                bmi.s   loc_37378
                move.l  #(9<<16)|(59<<8)|99,$14(a1,d0.w)

loc_37378:
                move.b  (Current_zone).w,d0
                subi.b  #$E,d0
                move.b  byte_3739A(pc,d0.w),d0
                beq.s   loc_37392
                move.b  d0,(Current_zone).w
                move.b  #1,(Restart_level_flag).w
                rts
; ---------------------------------------------------------------------------

loc_37392:
                move.b  #GameMode_CompetitionResults,(Game_mode).w

locret_37398:
                rts
; ---------------------------------------------------------------------------
byte_3739A:
                dc.b    $F
                dc.b    $11
                dc.b    $12
                dc.b    $10
                dc.b    0
byte_3739F:
                dc.b    0
                dc.b    4
                dc.b    $C
                dc.b    8
                dc.b    $10
                even
; ---------------------------------------------------------------------------

loc_373A4:
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap).w,d0
                bhs.s   loc_373D4
                tst.b   (Update_HUD_timer).w
                bmi.s   loc_373D4
                move.b  #5,anim(a0)
                bset    #3,render_flags(a0)
                move.b  #$80,(Update_HUD_timer).w
                move.w  #$78,(Events_bg+$16).w
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

loc_373D4:
                move.b  (Competition_total_laps).w,d0
                cmp.b   (Competition_current_lap_2P).w,d0
                bhs.s   locret_37404
                tst.b   (Update_HUD_timer_P2).w
                bmi.s   locret_37404
                move.b  #5,anim(a0)
                bset    #4,render_flags(a0)
                move.b  #$80,(Update_HUD_timer_P2).w
                move.w  #$78,(Events_bg+$16).w
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

locret_37404:
                rts
; End of function CompetitionSKUpdateNeonRaceStartFinishAndProgression

; =============== S U B R O U T I N E =======================================

CompetitionSKSpawnNeonLateFinisherDisplay:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   locret_3742E
                move.l  #loc_3713A,(a1)
                move.w  #$120,x_pos(a1)
                move.w  #$B8,y_pos(a1)
                move.b  #2,anim(a1)
                move.b  #3,$3A(a1)

locret_3742E:
                rts
; End of function CompetitionSKSpawnNeonLateFinisherDisplay

; =============== S U B R O U T I N E =======================================

CompetitionSKInsertP1TimeAttackTopThreeAndSave:
                tst.b   (Competition_type).w
                bpl.w   locret_374B6
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                subi.w  #$E,d0
                lsl.w   #4,d0
                lea     (Competition_saved_data).w,a1
                adda.w  d0,a1
                move.l  (Competition_time_record).w,d0
                cmp.l   (a1),d0
                bhs.s   loc_37476
                move.b  $D(a1),$E(a1)
                move.b  $C(a1),$D(a1)
                move.b  (P1_character).w,$C(a1)
                move.l  4(a1),8(a1)
                move.l  (a1),4(a1)
                move.l  d0,(a1)
                clr.b   (Competition_time_attack_new_top_record).w
                bra.s   loc_374B0
; ---------------------------------------------------------------------------

loc_37476:
                cmp.l   4(a1),d0
                bhs.s   loc_3749A
                move.b  $D(a1),$E(a1)
                move.b  (P1_character).w,$D(a1)
                move.l  4(a1),8(a1)
                move.l  d0,4(a1)
                move.b  #1,(Competition_time_attack_new_top_record).w
                bra.s   loc_374B0
; ---------------------------------------------------------------------------

loc_3749A:
                cmp.l   8(a1),d0
                bhs.s   locret_374B6
                move.b  (P1_character).w,$E(a1)
                move.l  d0,8(a1)
                move.b  #2,(Competition_time_attack_new_top_record).w

loc_374B0:
                jsr     (Write_SaveGeneral).l

locret_374B6:
                rts
; End of function CompetitionSKInsertP1TimeAttackTopThreeAndSave

; ---------------------------------------------------------------------------

loc_374B8:
                move.l  #Map_2PNeonDisplay,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PLapNum+$56,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$B8,y_pos(a0)
                move.b  #7,anim(a0)
                move.l  #loc_374F0,(a0)

loc_374F0:
                tst.w   (Events_bg+$14).w
                bne.s   loc_374FC
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_374FC:
                lea     (Ani_2PNeonDisplay).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_2PNeonDisplay:
                include "src/game/competition/shared/animations/neon_display.s"
Map_2PNeonDisplay:
                include "src/game/competition/shared/mappings/neon_display.s"
