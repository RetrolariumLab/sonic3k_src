; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles object dispatch, initialization, active control, timed powers and display state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Knuckles:
                lea     (Max_speed).w,a4
                lea     (Distance_from_top).w,a5
                lea     (Dust).w,a6
                tst.w   (Debug_placement_mode).w
                beq.s   Knuckles_Normal
                cmpi.b  #1,(Debug_placement_type).w
                beq.s   SKKnucklesLifecycle_DelegateObjectPlacementToDebugMode
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKKnucklesLifecycle_CycleDebugMappingFrameWithFbExclusiveLimit
                move.w  #0,(Debug_placement_mode).w

SKKnucklesLifecycle_CycleDebugMappingFrameWithFbExclusiveLimit:
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #$FB,mapping_frame(a0)
                blo.s   SKKnucklesLifecycle_LoadDebugFramePatternsAndQueueSprite
                move.b  #0,mapping_frame(a0)

SKKnucklesLifecycle_LoadDebugFramePatternsAndQueueSprite:
                bsr.w   Knuckles_Load_PLC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKKnucklesLifecycle_DelegateObjectPlacementToDebugMode:
                jmp     (DebugMode).l
; ---------------------------------------------------------------------------

Knuckles_Normal:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Knuckles_Index(pc,d0.w),d1
                jmp     Knuckles_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Knuckles_Index:
                dc.w    Knuckles_Init-Knuckles_Index
                dc.w    Knuckles_Control-Knuckles_Index
                dc.w    SKKnucklesRecovery_EnterDebugBeforeHurtMotionOrContinueHurtState-Knuckles_Index
                dc.w    SKKnucklesRecovery_EnterDebugBeforeDeathFinisherOrContinueDeathState-Knuckles_Index
                dc.w    SKKnucklesRecovery_CountNonzeroRestartDelayAndRequestLevelRestartAtZero-Knuckles_Index
                dc.w    SKKnucklesRecovery_ResumeControlOnlyWhenBothPrimaryScrollAmountsAreZero-Knuckles_Index
                dc.w    SKKnucklesRecovery_EnterDebugBeforeDrowningMotionOrContinueDrowning-Knuckles_Index
; ---------------------------------------------------------------------------

Knuckles_Init:
                addq.b  #2,routine(a0)
                move.b  #$13,y_radius(a0)
                move.b  #9,x_radius(a0)
                move.b  #$13,default_y_radius(a0)
                move.b  #9,default_x_radius(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.w  #$100,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.b  #2,character_id(a0)
                move.w  #$600,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)
                tst.b   (Last_star_post_hit).w
                bne.s   Knuckles_Init_Continued
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                cmpi.b  #2,(Special_bonus_entry_flag).w
                beq.s   Knuckles_Init_Continued
                move.w  x_pos(a0),(Saved_X_pos).w
                move.w  y_pos(a0),(Saved_Y_pos).w
                move.w  art_tile(a0),(Saved_art_tile).w
                move.w  top_solid_bit(a0),(Saved_solid_bits).w

Knuckles_Init_Continued:
                move.b  #0,flips_remaining(a0)
                move.b  #4,flip_speed(a0)
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #30,air_left(a0)
                subi.w  #$20,x_pos(a0)
                addi.w  #4,y_pos(a0)
                jsr     (Reset_Player_Position_Array).l
                addi.w  #$20,x_pos(a0)
                subi.w  #4,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

Knuckles_Control:
                tst.w   (Debug_mode_flag).w
                beq.s   SKKnucklesLifecycle_RefreshLogicalPrimaryInputUnlessLocked
                bclr    #button_A,(Ctrl_1_pressed).w
                beq.s   SKKnucklesLifecycle_SelectPlacementOrFrameViewerFromDebugButton
                eori.b  #1,(Reverse_gravity_flag).w

SKKnucklesLifecycle_SelectPlacementOrFrameViewerFromDebugButton:
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKKnucklesLifecycle_RefreshLogicalPrimaryInputUnlessLocked
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                btst    #button_C,(Ctrl_1_held).w
                beq.s   SKKnucklesLifecycle_ReturnAfterSelectingDebugPresentationMode
                move.w  #2,(Debug_placement_mode).w

SKKnucklesLifecycle_ReturnAfterSelectingDebugPresentationMode:
                rts
; ---------------------------------------------------------------------------

SKKnucklesLifecycle_RefreshLogicalPrimaryInputUnlessLocked:
                tst.b   (Ctrl_1_locked).w
                bne.s   SKKnucklesLifecycle_GateMovementAndResetGlideStateWhenControlled
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w

SKKnucklesLifecycle_GateMovementAndResetGlideStateWhenControlled:
                btst    #0,object_control(a0)
                beq.s   SKKnucklesLifecycle_DispatchStandingRollingAndAirModesWithSavedRegisters
                move.b  #0,double_jump_flag(a0)
                bra.s   SKKnucklesLifecycle_WrapIntegerYBeforeActiveServices
; ---------------------------------------------------------------------------

SKKnucklesLifecycle_DispatchStandingRollingAndAirModesWithSavedRegisters:
                movem.l a4-a6,-(sp)
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #6,d0
                move.w  Knux_Modes(pc,d0.w),d1
                jsr     Knux_Modes(pc,d1.w)
                movem.l (sp)+,a4-a6

SKKnucklesLifecycle_WrapIntegerYBeforeActiveServices:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   SKKnucklesLifecycle_RunDisplayPowerHistoryAndWaterBeforeAnimation
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

SKKnucklesLifecycle_RunDisplayPowerHistoryAndWaterBeforeAnimation:
                bsr.s   Knuckles_Display
                bsr.w   SonicKnux_SuperHyper
                bsr.w   Sonic_RecordPos
                bsr.w   Knuckles_Water
                move.b  (Primary_Angle).w,next_tilt(a0)
                move.b  (Secondary_Angle).w,tilt(a0)
                tst.b   (WindTunnel_flag).w
                beq.s   SKKnucklesLifecycle_GateAnimationAndApplyOuterGravityMirror
                tst.b   anim(a0)
                bne.s   SKKnucklesLifecycle_GateAnimationAndApplyOuterGravityMirror
                move.b  prev_anim(a0),anim(a0)

SKKnucklesLifecycle_GateAnimationAndApplyOuterGravityMirror:
                btst    #1,object_control(a0)
                bne.s   SKKnucklesLifecycle_GateTouchResponseByControlBitsFiveAndSeven
                bsr.w   Animate_Knuckles
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnucklesLifecycle_LoadPatternsAfterOptionalGravityMirror
                eori.b  #2,render_flags(a0)

SKKnucklesLifecycle_LoadPatternsAfterOptionalGravityMirror:
                bsr.w   Knuckles_Load_PLC

SKKnucklesLifecycle_GateTouchResponseByControlBitsFiveAndSeven:
                move.b  object_control(a0),d0
                andi.b  #$A0,d0
                bne.s   SKKnucklesLifecycle_ReturnAfterActiveControlAndContactGate
                jsr     (TouchResponse).l

SKKnucklesLifecycle_ReturnAfterActiveControlAndContactGate:
                rts
; ---------------------------------------------------------------------------
Knux_Modes:
                dc.w    Knux_Stand_Path-Knux_Modes
                dc.w    Knux_Stand_Freespace-Knux_Modes
                dc.w    Knux_Spin_Path-Knux_Modes
                dc.w    Knux_Spin_Freespace-Knux_Modes

; =============== S U B R O U T I N E =======================================

Knuckles_Display:
                move.b  invulnerability_timer(a0),d0
                beq.s   SKKnucklesLifecycle_QueueSpriteForSelectedInvulnerabilityFlashPhase
                subq.b  #1,invulnerability_timer(a0)
                lsr.b   #3,d0
                bcc.s   SKKnucklesLifecycle_TickInvincibilityOnGlobalEighthPhase

SKKnucklesLifecycle_QueueSpriteForSelectedInvulnerabilityFlashPhase:
                jsr     (Draw_Sprite).l

SKKnucklesLifecycle_TickInvincibilityOnGlobalEighthPhase:
                btst    #Status_Invincible,status_secondary(a0)
                beq.s   SKKnucklesLifecycle_TickSpeedShoesAndRestoreExpirySpeedProfile
                tst.b   invincibility_timer(a0)
                beq.s   SKKnucklesLifecycle_TickSpeedShoesAndRestoreExpirySpeedProfile
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   SKKnucklesLifecycle_TickSpeedShoesAndRestoreExpirySpeedProfile
                subq.b  #1,invincibility_timer(a0)
                bne.s   SKKnucklesLifecycle_TickSpeedShoesAndRestoreExpirySpeedProfile
                tst.b   (Boss_flag).w
                bne.s   SKKnucklesLifecycle_ClearInvincibilityAfterExpiryMusicDecision
                cmpi.b  #12,air_left(a0)
                blo.s   SKKnucklesLifecycle_ClearInvincibilityAfterExpiryMusicDecision
                move.w  (Current_music).w,d0
                jsr     (Play_Music).l

SKKnucklesLifecycle_ClearInvincibilityAfterExpiryMusicDecision:
                bclr    #Status_Invincible,status_secondary(a0)

SKKnucklesLifecycle_TickSpeedShoesAndRestoreExpirySpeedProfile:
                btst    #Status_SpeedShoes,status_secondary(a0)
                beq.s   SKKnucklesLifecycle_ReturnWithoutSpeedShoesExpiryCleanup
                tst.b   speed_shoes_timer(a0)
                beq.s   SKKnucklesLifecycle_ReturnWithoutSpeedShoesExpiryCleanup
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   SKKnucklesLifecycle_ReturnWithoutSpeedShoesExpiryCleanup
                subq.b  #1,speed_shoes_timer(a0)
                bne.s   SKKnucklesLifecycle_ReturnWithoutSpeedShoesExpiryCleanup
                move.w  #$600,Max_speed-Max_speed(a4)
                move.w  #$C,Acceleration-Max_speed(a4)
                move.w  #$80,Deceleration-Max_speed(a4)
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKKnucklesLifecycle_ClearSpeedShoesAndRequestNormalMusicTempo
                move.w  #$800,Max_speed-Max_speed(a4)
                move.w  #$18,Acceleration-Max_speed(a4)
                move.w  #$C0,Deceleration-Max_speed(a4)

SKKnucklesLifecycle_ClearSpeedShoesAndRequestNormalMusicTempo:
                bclr    #Status_SpeedShoes,status_secondary(a0)
                moveq   #0,d0
                jmp     (Change_Music_Tempo).l
; ---------------------------------------------------------------------------

SKKnucklesLifecycle_ReturnWithoutSpeedShoesExpiryCleanup:
                rts
; End of function Knuckles_Display
