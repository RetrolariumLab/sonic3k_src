; Owner: objects/players/common/sk
; Responsibility: Existing shared player hurt, death, speed restoration, restart and animation dispatch state
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

SKRecovery_HurtState4:
                tst.w   (Debug_mode_flag).w
                beq.s   SKRecovery_MoveHurtAndApplyGravity
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKRecovery_MoveHurtAndApplyGravity
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKRecovery_MoveHurtAndApplyGravity:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   SKRecovery_WrapHurtYIfEnabled
                subi.w  #$20,y_vel(a0)

; Mask integer Y only when the camera minimum equals -$100
SKRecovery_WrapHurtYIfEnabled:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   SKRecovery_ResolveHurtAndDraw
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

SKRecovery_ResolveHurtAndDraw:
                bsr.w   SKPlayer_ResolveHurtLandingOrKill
                bsr.w   Player_LevelBound
                bsr.w   Sonic_RecordPos
                bsr.w   SKPlayer_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

SKPlayer_ResolveHurtLandingOrKill:
                tst.b   (Disable_death_plane).w
                bne.s   SKRecovery_CheckHurtLandingAndReset
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKRecovery_TestReverseHurtDeathPlane
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   SKRecovery_KillAtHurtDeathPlane
                bra.s   SKRecovery_CheckHurtLandingAndReset
; ---------------------------------------------------------------------------

; Under reverse gravity, reaching the camera minimum or going above it kills the hurt player
SKRecovery_TestReverseHurtDeathPlane:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   y_pos(a0),d0
                blt.s   SKRecovery_CheckHurtLandingAndReset
                bra.w   SKRecovery_KillAtHurtDeathPlane
; ---------------------------------------------------------------------------

SKRecovery_CheckHurtLandingAndReset:
                movem.l a4-a6,-(sp)
                bsr.w   SonicKnux_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   SKRecovery_HurtLandingReturn
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

SKRecovery_HurtLandingReturn:
                rts
; ---------------------------------------------------------------------------

SKRecovery_KillAtHurtDeathPlane:
                jmp     (Kill_Character).l
; End of function SKPlayer_ResolveHurtLandingOrKill

; ---------------------------------------------------------------------------

SKRecovery_DeathState6:
                tst.w   (Debug_mode_flag).w
                beq.s   SKRecovery_ResolveDeathAndDraw
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKRecovery_ResolveDeathAndDraw
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKRecovery_ResolveDeathAndDraw:
                bsr.w   SKPlayer_FinishDeath
                jsr     (MoveSprite_TestGravity).l
                bsr.w   Sonic_RecordPos
                bsr.w   SKPlayer_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; After the camera threshold, select follower catch-up, normal life and restart handling, or the saved competition spawn
SKPlayer_FinishDeath:
                cmpa.w  #Player_1,a0
                bne.s   SKRecovery_LockP2ScrollAndReadCameraY
                move.w  (Camera_Y_pos).w,d0
                move.b  #1,(Scroll_lock).w
                bra.s   SKRecovery_PrepareDeathExitDepth
; ---------------------------------------------------------------------------

; The secondary player uses the primary camera Y for this death threshold
SKRecovery_LockP2ScrollAndReadCameraY:
                move.w  (Camera_Y_pos).w,d0
                move.b  #1,(Scroll_lock_P2).w

SKRecovery_PrepareDeathExitDepth:
                move.b  #0,spin_dash_flag(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKRecovery_SetNormalDeathThreshold
                subi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                bge.w   SKRecovery_DispatchDeathOutcome
                bra.w   SKRecovery_DeathFinishReturn
; ---------------------------------------------------------------------------

SKRecovery_SetNormalDeathThreshold:
                addi.w  #$100,d0
                tst.w   (Competition_mode).w
                beq.s   SKRecovery_TestNormalDeathDepth
                subi.w  #$70,d0

SKRecovery_TestNormalDeathDepth:
                cmp.w   y_pos(a0),d0
                bge.w   SKRecovery_DeathFinishReturn

SKRecovery_DispatchDeathOutcome:
                tst.w   (Competition_mode).w
                bne.w   SKRecovery_RestoreCompP1OrP2
                cmpi.b  #1,character_id(a0)
                bne.s   SKRecovery_ChargeLifeAndPrepRestart
                cmpi.w  #2,(Player_mode).w
                beq.s   SKRecovery_ChargeLifeAndPrepRestart
                move.b  #2,routine(a0)
                bra.w   SKTailsCPU_BeginOffscreenCatchUp
; ---------------------------------------------------------------------------

SKRecovery_ChargeLifeAndPrepRestart:
                move.b  #8,routine(a0)
                move.w  #60,$3E(a0)
                move.b  #0,(Respawn_table_keep).w
                addq.b  #1,(Update_HUD_life_count).w
                subq.b  #1,(Life_count).w
                bne.s   SKRecovery_TryTimeOverWithLivesLeft
                move.w  #0,$3E(a0)
                move.l  #Obj_GameOver,(Reserved_object_3).w
                move.l  #Obj_GameOver,(Dynamic_object_RAM).w
                move.b  #0,(Reserved_object_3+mapping_frame).w
                move.b  #1,(Dynamic_object_RAM+mapping_frame).w
                move.w  a0,(Reserved_object_3+objoff_3E).w
                clr.b   (Time_over_flag).w

SKRecovery_StopTimersAndCueGameOver:
                clr.b   (Update_HUD_timer).w
                clr.b   (Update_HUD_timer_P2).w
                move.b  #8,routine(a0)
                move.w  #mus_GameOver,d0
                jsr     (Play_Music).l
                moveq   #PLCID_03,d0
                jmp     (Load_PLC_2).l
; ---------------------------------------------------------------------------

SKRecovery_TryTimeOverWithLivesLeft:
                tst.b   (Time_over_flag).w
                beq.s   SKRecovery_DeathFinishReturn
                move.w  #0,$3E(a0)
                move.l  #Obj_GameOver,(Reserved_object_3).w
                move.l  #Obj_GameOver,(Dynamic_object_RAM).w
                move.b  #2,(Reserved_object_3+mapping_frame).w
                move.b  #3,(Dynamic_object_RAM+mapping_frame).w
                move.w  a0,(Reserved_object_3+objoff_3E).w
                bra.s   SKRecovery_StopTimersAndCueGameOver
; ---------------------------------------------------------------------------

SKRecovery_DeathFinishReturn:
                rts
; ---------------------------------------------------------------------------

SKRecovery_RestoreCompP1OrP2:
                move.b  #2,routine(a0)
                cmpa.w  #Player_1,a0
                bne.s   SKRecovery_RestoreCompP2Spawn
                move.b  #0,(Scroll_lock).w
                move.w  (Saved_X_pos).w,x_pos(a0)
                move.w  (Saved_Y_pos).w,y_pos(a0)
                move.w  (Saved_art_tile).w,art_tile(a0)
                move.w  (Saved_solid_bits).w,top_solid_bit(a0)
                clr.w   (Ring_count).w
                clr.b   (Extra_life_flags).w
                move.b  #1,(Competition_lap_count_flag).w  ; disable the lap count flag, however, later on this value is reset to 0 in Obj_2PGoalMarker
                bra.s   SKRecovery_ResetCompMotionAndSpeeds
; ---------------------------------------------------------------------------

SKRecovery_RestoreCompP2Spawn:
                move.b  #0,(Scroll_lock_P2).w
                move.w  (Saved2_X_pos).w,x_pos(a0)
                move.w  (Saved2_Y_pos).w,y_pos(a0)
                move.w  (Saved2_art_tile).w,art_tile(a0)
                move.w  (Saved2_solid_bits).w,top_solid_bit(a0)
                clr.w   (Ring_count_P2).w
                move.b  #1,(Competition_lap_count_flag_P2).w  ; disable the lap count flag, however, later on this value is reset to 0 in Obj_2PGoalMarker

SKRecovery_ResetCompMotionAndSpeeds:
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
; End of function SKPlayer_FinishDeath

; ---------------------------------------------------------------------------

; Request a restart on the decrement to zero. An already-zero timer holds this state
SKRecovery_RestartState8:
                tst.w   $3E(a0)
                beq.s   SKRecovery_RestartReturn
                subq.w  #1,$3E(a0)
                bne.s   SKRecovery_RestartReturn
                move.w  #1,(Restart_level_flag).w

SKRecovery_RestartReturn:
                rts
; ---------------------------------------------------------------------------

; Restore control once both global scroll deltas are zero
SKRecovery_ScrollWaitStateA:
                tst.w   (H_scroll_amount).w
                bne.s   SKRecovery_DrawScrollWaitFrame
                tst.w   (V_scroll_amount).w
                bne.s   SKRecovery_DrawScrollWaitFrame
                move.b  #2,routine(a0)

SKRecovery_DrawScrollWaitFrame:
                bsr.w   SKPlayer_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRecovery_DrowningStateC:
                tst.w   (Debug_mode_flag).w
                beq.s   SKRecovery_MoveDrowningAndDraw
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKRecovery_MoveDrowningAndDraw
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKRecovery_MoveDrowningAndDraw:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   SKPlayer_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Dispatch to the competition animation and pattern loader when enabled. Normal mode mirrors the vertical render flag under reverse gravity
SKPlayer_AnimateRecoveryAndLoadArt:
                tst.w   (Competition_mode).w
                bne.s   SKRecovery_AnimateCompAndLoadPatterns
                bsr.s   Animate_Sonic
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKRecovery_LoadRecoverySonicPatterns
                eori.b  #2,render_flags(a0)

SKRecovery_LoadRecoverySonicPatterns:
                bra.w   Sonic_Load_PLC
; ---------------------------------------------------------------------------

SKRecovery_AnimateCompAndLoadPatterns:
                bsr.w   Animate_SonicKnuckles_2P
                bra.w   SonicKnuckles2P_Load_PLC
; End of function SKPlayer_AnimateRecoveryAndLoadArt
