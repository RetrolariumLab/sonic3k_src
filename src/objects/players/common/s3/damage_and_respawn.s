; Owner: objects/players/common/s3
; Responsibility: Existing shared player hurt, death, speed restoration, restart and animation dispatch state
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

loc_13142:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_1315C
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_1315C
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_1315C:
                jsr     (MoveSprite2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   loc_13176
                subi.w  #$20,y_vel(a0)

loc_13176:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_13186
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_13186:
                bsr.w   PlayerS3ResolveCommonHurtLandingOrDeathPlane
                bsr.w   Player_LevelBound
                bsr.w   Sonic_RecordPos
                bsr.w   PlayerS3AnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

PlayerS3ResolveCommonHurtLandingOrDeathPlane:
                tst.b   (Disable_death_plane).w
                bne.s   loc_131B2
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   loc_131F8

loc_131B2:
                movem.l a4-a6,-(sp)
                bsr.w   Sonic_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   locret_131F6
                moveq   #0,d0
                move.w  d0,y_vel(a0)
                move.w  d0,x_vel(a0)
                move.w  d0,ground_vel(a0)
                move.b  d0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #$100,priority(a0)
                move.b  #2,routine(a0)
                move.b  #2*60,invulnerability_timer(a0)
                move.b  #0,spin_dash_flag(a0)

locret_131F6:
                rts
; ---------------------------------------------------------------------------

loc_131F8:
                jmp     (Kill_Character).l
; End of function PlayerS3ResolveCommonHurtLandingOrDeathPlane

; ---------------------------------------------------------------------------

loc_131FE:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_13218
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_13218
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_13218:
                bsr.w   PlayerS3FinishDeathWithFollowerResetRestartOrCompetitionRespawn
                jsr     (MoveSprite).l
                bsr.w   Sonic_RecordPos
                bsr.w   PlayerS3AnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

PlayerS3FinishDeathWithFollowerResetRestartOrCompetitionRespawn:
                cmpa.w  #Player_1,a0
                bne.s   loc_13242
                move.w  (Camera_Y_pos).w,d0
                move.b  #1,(Scroll_lock).w
                bra.s   loc_1324C
; ---------------------------------------------------------------------------

loc_13242:
                move.w  (Camera_Y_pos).w,d0
                move.b  #1,(Scroll_lock_P2).w

loc_1324C:
                move.b  #0,spin_dash_flag(a0)
                addi.w  #$100,d0
                tst.w   (Competition_mode).w
                beq.s   loc_13260
                subi.w  #$70,d0

loc_13260:
                cmp.w   y_pos(a0),d0
                bge.w   locret_1331E
                tst.w   (Competition_mode).w
                bne.w   loc_13320
                cmpi.b  #1,character_id(a0)
                bne.s   loc_1328A
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_1328A
                move.b  #2,routine(a0)
                bra.w   TailsS3ResetCPUFollowerToOffscreenCatchUp
; ---------------------------------------------------------------------------

loc_1328A:
                move.b  #8,routine(a0)
                move.w  #60,$3E(a0)
                move.b  #0,(Respawn_table_keep).w
                addq.b  #1,(Update_HUD_life_count).w
                subq.b  #1,(Life_count).w
                bne.s   loc_132F0
                move.w  #0,$3E(a0)
                move.l  #Obj_GameOver,(Reserved_object_3).w
                move.l  #Obj_GameOver,(Dynamic_object_RAM).w
                move.b  #0,(Reserved_object_3+mapping_frame).w
                move.b  #1,(Dynamic_object_RAM+mapping_frame).w
                move.w  a0,(Reserved_object_3+objoff_3E).w
                clr.b   (Time_over_flag).w

loc_132D0:
                clr.b   (Update_HUD_timer).w
                clr.b   (Update_HUD_timer_P2).w
                move.b  #8,routine(a0)
                move.w  #mus_GameOver,d0
                jsr     (Play_Music).l
                moveq   #PLCID_03,d0
                jmp     (Load_PLC_2).l
; ---------------------------------------------------------------------------

loc_132F0:
                tst.b   (Time_over_flag).w
                beq.s   locret_1331E
                move.w  #0,$3E(a0)
                move.l  #Obj_GameOver,(Reserved_object_3).w
                move.l  #Obj_GameOver,(Dynamic_object_RAM).w
                move.b  #2,(Reserved_object_3+mapping_frame).w
                move.b  #3,(Dynamic_object_RAM+mapping_frame).w
                move.w  a0,(Reserved_object_3+objoff_3E).w
                bra.s   loc_132D0
; ---------------------------------------------------------------------------

locret_1331E:
                rts
; ---------------------------------------------------------------------------

loc_13320:
                move.b  #2,routine(a0)
                cmpa.w  #Player_1,a0
                bne.s   loc_1335A
                move.b  #0,(Scroll_lock).w
                move.w  (Saved_X_pos).w,x_pos(a0)
                move.w  (Saved_Y_pos).w,y_pos(a0)
                move.w  (Saved_art_tile).w,art_tile(a0)
                move.w  (Saved_solid_bits).w,top_solid_bit(a0)
                clr.w   (Ring_count).w
                clr.b   (Extra_life_flags).w
                move.b  #1,(Competition_lap_count_flag).w  ; disable the lap count flag, however, later on this value is reset to 0 in Obj_2PGoalMarker
                bra.s   loc_13382
; ---------------------------------------------------------------------------

loc_1335A:
                move.b  #0,(Scroll_lock_P2).w
                move.w  (Saved2_X_pos).w,x_pos(a0)
                move.w  (Saved2_Y_pos).w,y_pos(a0)
                move.w  (Saved2_art_tile).w,art_tile(a0)
                move.w  (Saved2_solid_bits).w,top_solid_bit(a0)
                clr.w   (Ring_count_P2).w
                move.b  #1,(Competition_lap_count_flag_P2).w  ; disable the lap count flag, however, later on this value is reset to 0 in Obj_2PGoalMarker

loc_13382:
                move.b  #0,object_control(a0)
                move.b  #5,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #2,status(a0)
                move.w  #0,move_lock(a0)
                move.w  #0,spin_dash_counter(a0)
                clr.b   speed_shoes_timer(a0)
                lea     (Character_Speeds).l,a1
                moveq   #0,d0
                move.b  character_id(a0),d0
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,Max_speed-Max_speed(a4)
                move.w  (a1)+,Acceleration-Max_speed(a4)
                move.w  (a1)+,Deceleration-Max_speed(a4)
                rts
; End of function PlayerS3FinishDeathWithFollowerResetRestartOrCompetitionRespawn

; ---------------------------------------------------------------------------

loc_133D4:
                tst.w   $3E(a0)
                beq.s   locret_133E6
                subq.w  #1,$3E(a0)
                bne.s   locret_133E6
                move.w  #1,(Restart_level_flag).w

locret_133E6:
                rts
; ---------------------------------------------------------------------------

loc_133E8:
                tst.w   (H_scroll_amount).w
                bne.s   loc_133FA
                tst.w   (V_scroll_amount).w
                bne.s   loc_133FA
                move.b  #2,routine(a0)

loc_133FA:
                bsr.w   PlayerS3AnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_13404:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_1341E
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_1341E
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_1341E:
                jsr     (MoveSprite2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   PlayerS3AnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

PlayerS3AnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns:
                tst.w   (Competition_mode).w
                bne.s   loc_13444
                bsr.s   Animate_Sonic
                bra.w   Sonic_Load_PLC
; ---------------------------------------------------------------------------

loc_13444:
                bsr.w   Animate_SonicKnuckles_2P
                bra.w   SonicKnuckles2P_Load_PLC
; End of function PlayerS3AnimateCommonRecoveryStateAndQueueSonicOrCompetitionPatterns
