; Owner: objects/players/common/sk
; Responsibility: Existing shared player hurt, death, speed restoration, restart and animation dispatch state
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

loc_122BE:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_122D8
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_122D8
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_122D8:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   loc_122F2
                subi.w  #$20,y_vel(a0)

loc_122F2:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_12302
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_12302:
                bsr.w   sub_12318
                bsr.w   Player_LevelBound
                bsr.w   Sonic_RecordPos
                bsr.w   sub_125E0
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_12318:
                tst.b   (Disable_death_plane).w
                bne.s   loc_12344
                tst.b   (Reverse_gravity_flag).w
                bne.s   loc_12336
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   loc_1238A
                bra.s   loc_12344
; ---------------------------------------------------------------------------

loc_12336:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   y_pos(a0),d0
                blt.s   loc_12344
                bra.w   loc_1238A
; ---------------------------------------------------------------------------

loc_12344:
                movem.l a4-a6,-(sp)
                bsr.w   SonicKnux_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   locret_12388
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

locret_12388:
                rts
; ---------------------------------------------------------------------------

loc_1238A:
                jmp     (Kill_Character).l
; End of function sub_12318

; ---------------------------------------------------------------------------

loc_12390:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_123AA
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_123AA
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_123AA:
                bsr.w   sub_123C2
                jsr     (MoveSprite_TestGravity).l
                bsr.w   Sonic_RecordPos
                bsr.w   sub_125E0
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_123C2:
                cmpa.w  #Player_1,a0
                bne.s   loc_123D4
                move.w  (Camera_Y_pos).w,d0
                move.b  #1,(Scroll_lock).w
                bra.s   loc_123DE
; ---------------------------------------------------------------------------

loc_123D4:
                move.w  (Camera_Y_pos).w,d0
                move.b  #1,(Scroll_lock_P2).w

loc_123DE:
                move.b  #0,spin_dash_flag(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_123FA
                subi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                bge.w   loc_12410
                bra.w   locret_124C6
; ---------------------------------------------------------------------------

loc_123FA:
                addi.w  #$100,d0
                tst.w   (Competition_mode).w
                beq.s   loc_12408
                subi.w  #$70,d0

loc_12408:
                cmp.w   y_pos(a0),d0
                bge.w   locret_124C6

loc_12410:
                tst.w   (Competition_mode).w
                bne.w   loc_124C8
                cmpi.b  #1,character_id(a0)
                bne.s   loc_12432
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_12432
                move.b  #2,routine(a0)
                bra.w   sub_13ECA
; ---------------------------------------------------------------------------

loc_12432:
                move.b  #8,routine(a0)
                move.w  #60,$3E(a0)
                move.b  #0,(Respawn_table_keep).w
                addq.b  #1,(Update_HUD_life_count).w
                subq.b  #1,(Life_count).w
                bne.s   loc_12498
                move.w  #0,$3E(a0)
                move.l  #Obj_GameOver,(Reserved_object_3).w
                move.l  #Obj_GameOver,(Dynamic_object_RAM).w
                move.b  #0,(Reserved_object_3+mapping_frame).w
                move.b  #1,(Dynamic_object_RAM+mapping_frame).w
                move.w  a0,(Reserved_object_3+objoff_3E).w
                clr.b   (Time_over_flag).w

loc_12478:
                clr.b   (Update_HUD_timer).w
                clr.b   (Update_HUD_timer_P2).w
                move.b  #8,routine(a0)
                move.w  #mus_GameOver,d0
                jsr     (Play_Music).l
                moveq   #PLCID_03,d0
                jmp     (Load_PLC_2).l
; ---------------------------------------------------------------------------

loc_12498:
                tst.b   (Time_over_flag).w
                beq.s   locret_124C6
                move.w  #0,$3E(a0)
                move.l  #Obj_GameOver,(Reserved_object_3).w
                move.l  #Obj_GameOver,(Dynamic_object_RAM).w
                move.b  #2,(Reserved_object_3+mapping_frame).w
                move.b  #3,(Dynamic_object_RAM+mapping_frame).w
                move.w  a0,(Reserved_object_3+objoff_3E).w
                bra.s   loc_12478
; ---------------------------------------------------------------------------

locret_124C6:
                rts
; ---------------------------------------------------------------------------

loc_124C8:
                move.b  #2,routine(a0)
                cmpa.w  #Player_1,a0
                bne.s   loc_12502
                move.b  #0,(Scroll_lock).w
                move.w  (Saved_X_pos).w,x_pos(a0)
                move.w  (Saved_Y_pos).w,y_pos(a0)
                move.w  (Saved_art_tile).w,art_tile(a0)
                move.w  (Saved_solid_bits).w,top_solid_bit(a0)
                clr.w   (Ring_count).w
                clr.b   (Extra_life_flags).w
                move.b  #1,(Competition_lap_count_flag).w  ; disable the lap count flag, however, later on this value is reset to 0 in Obj_2PGoalMarker
                bra.s   loc_1252A
; ---------------------------------------------------------------------------

loc_12502:
                move.b  #0,(Scroll_lock_P2).w
                move.w  (Saved2_X_pos).w,x_pos(a0)
                move.w  (Saved2_Y_pos).w,y_pos(a0)
                move.w  (Saved2_art_tile).w,art_tile(a0)
                move.w  (Saved2_solid_bits).w,top_solid_bit(a0)
                clr.w   (Ring_count_P2).w
                move.b  #1,(Competition_lap_count_flag_P2).w  ; disable the lap count flag, however, later on this value is reset to 0 in Obj_2PGoalMarker

loc_1252A:
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
; End of function sub_123C2

; ---------------------------------------------------------------------------

loc_1257C:
                tst.w   $3E(a0)
                beq.s   locret_1258E
                subq.w  #1,$3E(a0)
                bne.s   locret_1258E
                move.w  #1,(Restart_level_flag).w

locret_1258E:
                rts
; ---------------------------------------------------------------------------

loc_12590:
                tst.w   (H_scroll_amount).w
                bne.s   loc_125A2
                tst.w   (V_scroll_amount).w
                bne.s   loc_125A2
                move.b  #2,routine(a0)

loc_125A2:
                bsr.w   sub_125E0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_125AC:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_125C6
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_125C6
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_125C6:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   sub_125E0
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_125E0:
                tst.w   (Competition_mode).w
                bne.s   loc_125F8
                bsr.s   Animate_Sonic
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_125F4
                eori.b  #2,render_flags(a0)

loc_125F4:
                bra.w   Sonic_Load_PLC
; ---------------------------------------------------------------------------

loc_125F8:
                bsr.w   Animate_SonicKnuckles_2P
                bra.w   SonicKnuckles2P_Load_PLC
; End of function sub_125E0
