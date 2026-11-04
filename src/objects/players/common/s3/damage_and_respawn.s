; Owner: objects/players/common/s3
; Responsibility: Existing shared player hurt, death, speed restoration, restart and animation dispatch state
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

S3Recovery_HurtState4:
                tst.w   (Debug_mode_flag).w
                beq.s   S3Recovery_MoveHurtAndApplyGravity
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   S3Recovery_MoveHurtAndApplyGravity
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

S3Recovery_MoveHurtAndApplyGravity:
                jsr     (MoveSprite2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   S3Recovery_WrapHurtYIfEnabled
                subi.w  #$20,y_vel(a0)

; Mask integer Y only when the camera minimum equals -$100
S3Recovery_WrapHurtYIfEnabled:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   S3Recovery_ResolveHurtAndDraw
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

S3Recovery_ResolveHurtAndDraw:
                bsr.w   S3Player_ResolveHurtLandingOrKill
                bsr.w   Player_LevelBound
                bsr.w   Sonic_RecordPos
                bsr.w   S3Player_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

S3Player_ResolveHurtLandingOrKill:
                tst.b   (Disable_death_plane).w
                bne.s   S3Recovery_CheckHurtLandingAndReset
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   S3Recovery_KillAtHurtDeathPlane

S3Recovery_CheckHurtLandingAndReset:
                movem.l a4-a6,-(sp)
                bsr.w   Sonic_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   S3Recovery_HurtLandingReturn
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

S3Recovery_HurtLandingReturn:
                rts
; ---------------------------------------------------------------------------

S3Recovery_KillAtHurtDeathPlane:
                jmp     (Kill_Character).l
; End of function S3Player_ResolveHurtLandingOrKill

; ---------------------------------------------------------------------------

S3Recovery_DeathState6:
                tst.w   (Debug_mode_flag).w
                beq.s   S3Recovery_ResolveDeathAndDraw
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   S3Recovery_ResolveDeathAndDraw
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

S3Recovery_ResolveDeathAndDraw:
                bsr.w   S3Player_FinishDeath
                jsr     (MoveSprite).l
                bsr.w   Sonic_RecordPos
                bsr.w   S3Player_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; After the camera threshold, select follower catch-up, normal life and restart handling, or the saved competition spawn
S3Player_FinishDeath:
                cmpa.w  #Player_1,a0
                bne.s   S3Recovery_LockP2ScrollAndReadCameraY
                move.w  (Camera_Y_pos).w,d0
                move.b  #1,(Scroll_lock).w
                bra.s   S3Recovery_PrepareDeathExitDepth
; ---------------------------------------------------------------------------

; The secondary player uses the primary camera Y for this death threshold
S3Recovery_LockP2ScrollAndReadCameraY:
                move.w  (Camera_Y_pos).w,d0
                move.b  #1,(Scroll_lock_P2).w

S3Recovery_PrepareDeathExitDepth:
                move.b  #0,spin_dash_flag(a0)
                addi.w  #$100,d0
                tst.w   (Competition_mode).w
                beq.s   S3Recovery_TestNormalDeathDepth
                subi.w  #$70,d0

S3Recovery_TestNormalDeathDepth:
                cmp.w   y_pos(a0),d0
                bge.w   S3Recovery_DeathFinishReturn
                tst.w   (Competition_mode).w
                bne.w   S3Recovery_RestoreCompP1OrP2
                cmpi.b  #1,character_id(a0)
                bne.s   S3Recovery_ChargeLifeAndPrepRestart
                cmpi.w  #2,(Player_mode).w
                beq.s   S3Recovery_ChargeLifeAndPrepRestart
                move.b  #2,routine(a0)
                bra.w   S3TailsCPU_BeginOffscreenCatchUp
; ---------------------------------------------------------------------------

S3Recovery_ChargeLifeAndPrepRestart:
                move.b  #8,routine(a0)
                move.w  #60,$3E(a0)
                move.b  #0,(Respawn_table_keep).w
                addq.b  #1,(Update_HUD_life_count).w
                subq.b  #1,(Life_count).w
                bne.s   S3Recovery_TryTimeOverWithLivesLeft
                move.w  #0,$3E(a0)
                move.l  #Obj_GameOver,(Reserved_object_3).w
                move.l  #Obj_GameOver,(Dynamic_object_RAM).w
                move.b  #0,(Reserved_object_3+mapping_frame).w
                move.b  #1,(Dynamic_object_RAM+mapping_frame).w
                move.w  a0,(Reserved_object_3+objoff_3E).w
                clr.b   (Time_over_flag).w

S3Recovery_StopTimersAndCueGameOver:
                clr.b   (Update_HUD_timer).w
                clr.b   (Update_HUD_timer_P2).w
                move.b  #8,routine(a0)
                move.w  #mus_GameOver,d0
                jsr     (Play_Music).l
                moveq   #PLCID_03,d0
                jmp     (Load_PLC_2).l
; ---------------------------------------------------------------------------

S3Recovery_TryTimeOverWithLivesLeft:
                tst.b   (Time_over_flag).w
                beq.s   S3Recovery_DeathFinishReturn
                move.w  #0,$3E(a0)
                move.l  #Obj_GameOver,(Reserved_object_3).w
                move.l  #Obj_GameOver,(Dynamic_object_RAM).w
                move.b  #2,(Reserved_object_3+mapping_frame).w
                move.b  #3,(Dynamic_object_RAM+mapping_frame).w
                move.w  a0,(Reserved_object_3+objoff_3E).w
                bra.s   S3Recovery_StopTimersAndCueGameOver
; ---------------------------------------------------------------------------

S3Recovery_DeathFinishReturn:
                rts
; ---------------------------------------------------------------------------

S3Recovery_RestoreCompP1OrP2:
                move.b  #2,routine(a0)
                cmpa.w  #Player_1,a0
                bne.s   S3Recovery_RestoreCompP2Spawn
                move.b  #0,(Scroll_lock).w
                move.w  (Saved_X_pos).w,x_pos(a0)
                move.w  (Saved_Y_pos).w,y_pos(a0)
                move.w  (Saved_art_tile).w,art_tile(a0)
                move.w  (Saved_solid_bits).w,top_solid_bit(a0)
                clr.w   (Ring_count).w
                clr.b   (Extra_life_flags).w
                move.b  #1,(Competition_lap_count_flag).w  ; disable the lap count flag, however, later on this value is reset to 0 in Obj_2PGoalMarker
                bra.s   S3Recovery_ResetCompMotionAndSpeeds
; ---------------------------------------------------------------------------

S3Recovery_RestoreCompP2Spawn:
                move.b  #0,(Scroll_lock_P2).w
                move.w  (Saved2_X_pos).w,x_pos(a0)
                move.w  (Saved2_Y_pos).w,y_pos(a0)
                move.w  (Saved2_art_tile).w,art_tile(a0)
                move.w  (Saved2_solid_bits).w,top_solid_bit(a0)
                clr.w   (Ring_count_P2).w
                move.b  #1,(Competition_lap_count_flag_P2).w  ; disable the lap count flag, however, later on this value is reset to 0 in Obj_2PGoalMarker

S3Recovery_ResetCompMotionAndSpeeds:
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
; End of function S3Player_FinishDeath

; ---------------------------------------------------------------------------

; Request a restart on the decrement to zero. An already-zero timer holds this state
S3Recovery_RestartState8:
                tst.w   $3E(a0)
                beq.s   S3Recovery_RestartReturn
                subq.w  #1,$3E(a0)
                bne.s   S3Recovery_RestartReturn
                move.w  #1,(Restart_level_flag).w

S3Recovery_RestartReturn:
                rts
; ---------------------------------------------------------------------------

; Restore control once both global scroll deltas are zero
S3Recovery_ScrollWaitStateA:
                tst.w   (H_scroll_amount).w
                bne.s   S3Recovery_DrawScrollWaitFrame
                tst.w   (V_scroll_amount).w
                bne.s   S3Recovery_DrawScrollWaitFrame
                move.b  #2,routine(a0)

S3Recovery_DrawScrollWaitFrame:
                bsr.w   S3Player_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Recovery_DrowningStateC:
                tst.w   (Debug_mode_flag).w
                beq.s   S3Recovery_MoveDrowningAndDraw
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   S3Recovery_MoveDrowningAndDraw
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

S3Recovery_MoveDrowningAndDraw:
                jsr     (MoveSprite2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   S3Player_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Dispatch to the competition animation and pattern loader when enabled
S3Player_AnimateRecoveryAndLoadArt:
                tst.w   (Competition_mode).w
                bne.s   S3Recovery_AnimateCompAndLoadPatterns
                bsr.s   Animate_Sonic
                bra.w   Sonic_Load_PLC
; ---------------------------------------------------------------------------

S3Recovery_AnimateCompAndLoadPatterns:
                bsr.w   Animate_SonicKnuckles_2P
                bra.w   SonicKnuckles2P_Load_PLC
; End of function S3Player_AnimateRecoveryAndLoadArt
