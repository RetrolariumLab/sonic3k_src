; Owner: objects/players/tails/s3
; Responsibility: Tails object dispatch, initialization, active player control, timed powers and normal display state
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_Tails:
                lea     (Max_speed_P2).w,a4
                lea     (Distance_from_top_P2).w,a5
                lea     (Dust_P2).w,a6
                cmpi.w  #2,(Player_mode).w
                bne.s   Tails_Normal
                tst.w   (Debug_placement_mode).w
                beq.s   Tails_Normal
                cmpi.b  #1,(Debug_placement_type).w
                beq.s   S3TailsLifecycle_TailEnterDebugPlacementForSoloTails
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   S3TailsLifecycle_AdvanceDebugFrameAfterOptionalBExit
                move.w  #0,(Debug_placement_mode).w

S3TailsLifecycle_AdvanceDebugFrameAfterOptionalBExit:
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #$D1,mapping_frame(a0)
                blo.s   S3TailsLifecycle_LoadCurrentDebugFrameAndQueueDisplay
                move.b  #0,mapping_frame(a0)

S3TailsLifecycle_LoadCurrentDebugFrameAndQueueDisplay:
                bsr.w   Tails_Load_PLC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3TailsLifecycle_TailEnterDebugPlacementForSoloTails:
                jmp     (DebugMode).l
; ---------------------------------------------------------------------------

Tails_Normal:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Tails_Index(pc,d0.w),d1
                jmp     Tails_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Tails_Index:
                dc.w    Tails_Init-Tails_Index
                dc.w    Tails_Control-Tails_Index
                dc.w    S3TailsRecovery_ReleaseCarriedPrimaryBeforeHurtMovement-Tails_Index
                dc.w    S3TailsRecovery_ReleaseCarriedPrimaryBeforeDeathMovement-Tails_Index
                dc.w    S3TailsRecovery_CountNonzeroRestartWordDownToRestartRequest-Tails_Index
                dc.w    S3TailsRecovery_WaitForBothSecondaryScrollAmountsBeforeNormalRoutine-Tails_Index
                dc.w    S3TailsRecovery_ReleaseCarriedPrimaryBeforeDrowningMovement-Tails_Index
; ---------------------------------------------------------------------------

Tails_Init:
                addq.b  #2,routine(a0)
                move.b  #$F,y_radius(a0)
                move.b  #9,x_radius(a0)
                move.b  #$F,default_y_radius(a0)
                move.b  #9,default_x_radius(a0)
                move.l  #Map_Tails,mappings(a0)
                move.w  #$100,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #$84,render_flags(a0)
                move.b  #1,character_id(a0)
                move.w  #$600,Max_speed_P2-Max_speed_P2(a4)
                move.w  #$C,Acceleration_P2-Max_speed_P2(a4)
                move.w  #$80,Deceleration_P2-Max_speed_P2(a4)
                cmpi.w  #2,(Player_mode).w
                bne.s   S3TailsLifecycle_InitializeFollowerArtFromPrimarySolidityAndPriority
                tst.b   (Last_star_post_hit).w
                bne.s   Tails_Init_Continued
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.b  #$C,top_solid_bit(a0)
                move.b  #$D,lrb_solid_bit(a0)
                cmpi.b  #2,(Special_bonus_entry_flag).w
                beq.s   Tails_Init_Continued
                move.w  x_pos(a0),(Saved_X_pos).w
                move.w  y_pos(a0),(Saved_Y_pos).w
                move.w  art_tile(a0),(Saved_art_tile).w
                move.w  top_solid_bit(a0),(Saved_solid_bits).w
                bra.s   Tails_Init_Continued
; ---------------------------------------------------------------------------

S3TailsLifecycle_InitializeFollowerArtFromPrimarySolidityAndPriority:
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.w  (Player_1+top_solid_bit).w,top_solid_bit(a0)
                tst.w   (Player_1+art_tile).w
                bpl.s   Tails_Init_Continued
                ori.w   #high_priority,art_tile(a0)

Tails_Init_Continued:
                move.b  #0,flips_remaining(a0)
                move.b  #4,flip_speed(a0)
                move.b  #30,air_left(a0)
                cmpi.w  #$20,(Tails_CPU_routine).w
                beq.s   S3TailsLifecycle_ResetFollowerTimersAndBindNormalTailActor
                cmpi.w  #$12,(Tails_CPU_routine).w
                beq.s   S3TailsLifecycle_ResetFollowerTimersAndBindNormalTailActor
                move.w  #0,(Tails_CPU_routine).w

S3TailsLifecycle_ResetFollowerTimersAndBindNormalTailActor:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Tails_CPU_flight_timer).w
                move.l  #Obj_Tails_Tail,(Tails_tails).w
                move.w  a0,(Tails_tails+$30).w
                move.b  (Last_star_post_hit).w,(Tails_CPU_star_post_flag).w
                rts
; ---------------------------------------------------------------------------

Tails_Control:
                cmpi.w  #2,(Player_mode).w
                bne.s   S3TailsLifecycle_SelectPrimaryControllerAndFollowerCpuEligibility
                tst.w   (Debug_mode_flag).w
                beq.s   S3TailsLifecycle_SelectPrimaryControllerAndFollowerCpuEligibility
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   S3TailsLifecycle_SelectPrimaryControllerAndFollowerCpuEligibility
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                btst    #button_C,(Ctrl_1_held).w
                beq.s   S3TailsLifecycle_ReturnAfterEnteringSoloTailsDebugMode
                move.w  #2,(Debug_placement_mode).w

S3TailsLifecycle_ReturnAfterEnteringSoloTailsDebugMode:
                rts
; ---------------------------------------------------------------------------

S3TailsLifecycle_SelectPrimaryControllerAndFollowerCpuEligibility:
                cmpa.w  #Player_1,a0
                bne.s   S3TailsLifecycle_GateSecondaryControllerCopyAndCpuByProfileLockPolicy
                move.w  (Ctrl_1_logical).w,(Ctrl_2_logical).w
                tst.b   (Ctrl_1_locked).w
                bne.s   S3TailsLifecycle_SkipOwnMovementAndReleaseCarryForExternalControl
                move.w  (Ctrl_1).w,(Ctrl_2_logical).w
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w
                cmpi.w  #$1A,(Tails_CPU_routine).w
                bhs.s   S3TailsLifecycle_RunFollowerCpuOnlyOutsideCompetition
                bra.s   S3TailsLifecycle_SkipOwnMovementAndReleaseCarryForExternalControl
; ---------------------------------------------------------------------------

S3TailsLifecycle_GateSecondaryControllerCopyAndCpuByProfileLockPolicy:
                tst.b   (Ctrl_2_locked).w
                bne.s   S3TailsLifecycle_SkipOwnMovementAndReleaseCarryForExternalControl
                move.w  (Ctrl_2).w,(Ctrl_2_logical).w

S3TailsLifecycle_RunFollowerCpuOnlyOutsideCompetition:
                tst.w   (Competition_mode).w
                bne.s   S3TailsLifecycle_SkipOwnMovementAndReleaseCarryForExternalControl
                bsr.w   Tails_CPU_Control

S3TailsLifecycle_SkipOwnMovementAndReleaseCarryForExternalControl:
                btst    #0,object_control(a0)
                beq.s   S3TailsLifecycle_DispatchNormalTailsModeWhileSavingSharedBases
                move.b  #0,double_jump_flag(a0)
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsLifecycle_WrapNormalTailsIntegerYAtSharedCameraMinimumSentinel
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w
                bra.s   S3TailsLifecycle_WrapNormalTailsIntegerYAtSharedCameraMinimumSentinel
; ---------------------------------------------------------------------------

S3TailsLifecycle_DispatchNormalTailsModeWhileSavingSharedBases:
                movem.l a4-a6,-(sp)
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #6,d0
                move.w  Tails_Modes(pc,d0.w),d1
                jsr     Tails_Modes(pc,d1.w)
                movem.l (sp)+,a4-a6

S3TailsLifecycle_WrapNormalTailsIntegerYAtSharedCameraMinimumSentinel:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   S3TailsLifecycle_RunNormalDisplayHistoryWaterAndWindAnimationServices
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

S3TailsLifecycle_RunNormalDisplayHistoryWaterAndWindAnimationServices:
                bsr.s   Tails_Display
                bsr.w   Sonic_RecordPos
                bsr.w   Tails_Water
                move.b  (Primary_Angle).w,next_tilt(a0)
                move.b  (Secondary_Angle).w,tilt(a0)
                tst.b   (WindTunnel_flag_P2).w
                beq.s   S3TailsLifecycle_GateNormalTailsAnimationAndPatternsByControlBitOne
                tst.b   anim(a0)
                bne.s   S3TailsLifecycle_GateNormalTailsAnimationAndPatternsByControlBitOne
                move.b  prev_anim(a0),anim(a0)

S3TailsLifecycle_GateNormalTailsAnimationAndPatternsByControlBitOne:
                btst    #1,object_control(a0)
                bne.s   S3TailsLifecycle_RunNormalTouchUnlessControlBitsFiveOrSevenSet
                bsr.w   Animate_Tails
                bsr.w   Tails_Load_PLC

S3TailsLifecycle_RunNormalTouchUnlessControlBitsFiveOrSevenSet:
                move.b  object_control(a0),d0
                andi.b  #$A0,d0
                bne.s   S3TailsLifecycle_ReturnAfterNormalTailsServicesAndOptionalTouch
                jsr     (TouchResponse).l

S3TailsLifecycle_ReturnAfterNormalTailsServicesAndOptionalTouch:
                rts
; ---------------------------------------------------------------------------
Tails_Modes:
                dc.w    Tails_Stand_Path-Tails_Modes
                dc.w    Tails_Stand_Freespace-Tails_Modes
                dc.w    Tails_Spin_Path-Tails_Modes
                dc.w    Tails_Spin_Freespace-Tails_Modes
; ---------------------------------------------------------------------------

Tails_Display:
                move.b  invulnerability_timer(a0),d0
                beq.s   S3TailsLifecycle_QueueVisibleOldBlinkPhaseBeforePowerChecks
                subq.b  #1,invulnerability_timer(a0)
                lsr.b   #3,d0
                bcc.s   S3TailsLifecycle_CheckTimedInvincibilityExpiryOnGlobalEightFramePhase

S3TailsLifecycle_QueueVisibleOldBlinkPhaseBeforePowerChecks:
                jsr     (Draw_Sprite).l

S3TailsLifecycle_CheckTimedInvincibilityExpiryOnGlobalEightFramePhase:
                btst    #Status_Invincible,status_secondary(a0)
                beq.s   S3TailsLifecycle_ExpireSpeedShoesAndRestoreProfileAppropriateSpeeds
                tst.b   invincibility_timer(a0)
                beq.s   S3TailsLifecycle_ExpireSpeedShoesAndRestoreProfileAppropriateSpeeds
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   S3TailsLifecycle_ExpireSpeedShoesAndRestoreProfileAppropriateSpeeds
                subq.b  #1,invincibility_timer(a0)
                bne.s   S3TailsLifecycle_ExpireSpeedShoesAndRestoreProfileAppropriateSpeeds
                tst.b   (Boss_flag).w
                bne.s   S3TailsLifecycle_ClearExpiredInvincibilityBeforeSpeedShoesCheck
                cmpi.b  #12,air_left(a0)
                blo.s   S3TailsLifecycle_ClearExpiredInvincibilityBeforeSpeedShoesCheck
                move.w  (Current_music).w,d0
                jsr     (Play_Music).l

S3TailsLifecycle_ClearExpiredInvincibilityBeforeSpeedShoesCheck:
                bclr    #Status_Invincible,status_secondary(a0)

S3TailsLifecycle_ExpireSpeedShoesAndRestoreProfileAppropriateSpeeds:
                btst    #Status_SpeedShoes,status_secondary(a0)
                beq.s   S3TailsLifecycle_ReturnAfterPowerChecksOrUnexpiredSpeedShoes
                tst.b   speed_shoes_timer(a0)
                beq.s   S3TailsLifecycle_ReturnAfterPowerChecksOrUnexpiredSpeedShoes
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   S3TailsLifecycle_ReturnAfterPowerChecksOrUnexpiredSpeedShoes
                subq.b  #1,speed_shoes_timer(a0)
                bne.s   S3TailsLifecycle_ReturnAfterPowerChecksOrUnexpiredSpeedShoes
                tst.w   (Competition_mode).w
                bne.s   S3TailsLifecycle_RestoreCompetitionSpeedRecordOnShoesExpiry
                move.w  #$600,Max_speed_P2-Max_speed_P2(a4)
                move.w  #$C,Acceleration_P2-Max_speed_P2(a4)
                move.w  #$80,Deceleration_P2-Max_speed_P2(a4)
                bclr    #Status_SpeedShoes,status_secondary(a0)
                moveq   #0,d0
                jmp     (Change_Music_Tempo).l
; ---------------------------------------------------------------------------

S3TailsLifecycle_ReturnAfterPowerChecksOrUnexpiredSpeedShoes:
                rts
; ---------------------------------------------------------------------------

S3TailsLifecycle_RestoreCompetitionSpeedRecordOnShoesExpiry:
                lea     (Character_Speeds).l,a1
                moveq   #0,d0
                move.b  character_id(a0),d0
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,Max_speed_P2-Max_speed_P2(a4)
                move.w  (a1)+,Acceleration_P2-Max_speed_P2(a4)
                move.w  (a1)+,Deceleration_P2-Max_speed_P2(a4)
                bclr    #Status_SpeedShoes,status_secondary(a0)
                rts
