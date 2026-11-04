; Owner: objects/players/tails/s3
; Responsibility: Follower reset and interaction helpers, idle spindash and level-scripted flight or carrying sequences
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

TailsS3ResetCPUFollowerToOffscreenCatchUp:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Tails_CPU_flight_timer).w
                move.w  #2,(Tails_CPU_routine).w
                move.b  #$81,object_control(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #$7F00,x_pos(a0)
                move.w  #0,y_pos(a0)
                move.b  #0,double_jump_flag(a0)
                rts
; End of function TailsS3ResetCPUFollowerToOffscreenCatchUp

; =============== S U B R O U T I N E =======================================

TailsS3WatchCPUOffscreenTimeoutAndInteractionCode:
                tst.b   render_flags(a0)
                bmi.s   S3TailsScript_ClearTimeoutWhenVisible
                btst    #Status_OnObj,status(a0)
                beq.s   S3TailsScript_TickOffscreenTimeout
                moveq   #0,d0
                movea.w interact(a0),a3
                move.w  (Tails_CPU_interact).w,d0
                cmp.w   (a3),d0
                bne.s   S3TailsScript_ResetToOffscreenCatchUp

S3TailsScript_TickOffscreenTimeout:
                addq.w  #1,(Tails_CPU_flight_timer).w
                cmpi.w  #5*60,(Tails_CPU_flight_timer).w
                blo.s   S3TailsScript_ReadInteractCodeWord

S3TailsScript_ResetToOffscreenCatchUp:
                bra.w   TailsS3ResetCPUFollowerToOffscreenCatchUp
; ---------------------------------------------------------------------------

S3TailsScript_ClearTimeoutWhenVisible:
                move.w  #0,(Tails_CPU_flight_timer).w

S3TailsScript_ReadInteractCodeWord:
                movea.w interact(a0),a3
                move.w  (a3),(Tails_CPU_interact).w
                rts
; End of function TailsS3WatchCPUOffscreenTimeoutAndInteractionCode

; ---------------------------------------------------------------------------

S3TailsScript_CheckIdleSpinDash:
                bsr.w   TailsS3WatchCPUOffscreenTimeoutAndInteractionCode
                tst.w   (Tails_CPU_idle_timer).w
                bne.w   S3TailsScript_IdleSpinDashReturn
                tst.w   move_lock(a0)
                bne.s   S3TailsScript_IdleSpinDashReturn
                tst.b   spin_dash_flag(a0)
                bne.s   S3TailsScript_HoldSpinDashDown
                tst.w   ground_vel(a0)
                bne.s   S3TailsScript_IdleSpinDashReturn
                bclr    #Status_Facing,status(a0)
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   S3TailsScript_StartSpinDashInput
                bset    #Status_Facing,status(a0)

S3TailsScript_StartSpinDashInput:
                move.w  #(button_down_mask<<8)|button_down_mask,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$7F,d0
                beq.s   S3TailsScript_ReleaseSpinDashAndFollow
                cmpi.b  #8,anim(a0)
                bne.s   S3TailsScript_IdleSpinDashReturn
                move.w  #((button_A_mask|button_B_mask|button_C_mask|button_down_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask|button_down_mask),(Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

; Release on the 128-frame global phase
S3TailsScript_HoldSpinDashDown:
                move.w  #(button_down_mask<<8)|button_down_mask,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$7F,d0
                bne.s   S3TailsScript_PulseSpinChargeEvery32

S3TailsScript_ReleaseSpinDashAndFollow:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.w  #6,(Tails_CPU_routine).w
                rts
; ---------------------------------------------------------------------------

S3TailsScript_PulseSpinChargeEvery32:
                andi.b  #$1F,d0
                bne.s   S3TailsScript_IdleSpinDashReturn
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

S3TailsScript_IdleSpinDashReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsScript_InactiveStateReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsScript_StartIntroCarryRight:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #$100,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                lea     (Player_1).w,a1
                bsr.w   TailsS3InitializeCarriedPlayerAttachment
                move.b  #1,(Flying_carrying_Sonic_flag).w
                move.w  #$E,(Tails_CPU_routine).w

S3TailsScript_PulseIntroCarryRight:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   S3TailsScript_FinishIntroOnRiderGrounded
                ori.w   #(button_right_mask<<8)|button_right_mask,(Ctrl_2_logical).w

S3TailsScript_FinishIntroOnRiderGrounded:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   S3TailsScript_RunIntroCarry
                move.w  #6,(Tails_CPU_routine).w
                move.b  #0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,move_lock(a0)
                andi.w  #drawing_mask,art_tile(a0)
                tst.b   art_tile(a1)
                bpl.s   S3TailsScript_CopySolidityAndCheckExit
                ori.w   #high_priority,art_tile(a0)

S3TailsScript_CopySolidityAndCheckExit:
                move.b  top_solid_bit(a1),top_solid_bit(a0)
                move.b  lrb_solid_bit(a1),lrb_solid_bit(a0)
                cmpi.w  #1,(Player_mode).w
                bne.s   S3TailsScript_RunIntroCarry
                move.w  #$10,(Tails_CPU_routine).w

S3TailsScript_RunIntroCarry:
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

S3TailsScript_PulsePartnerExitInput:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   S3TailsScript_FinishPartnerExitOffscreen
                ori.w   #((button_A_mask|button_B_mask|button_C_mask|button_right_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask|button_right_mask),(Ctrl_2_logical).w

S3TailsScript_FinishPartnerExitOffscreen:
                tst.b   render_flags(a0)
                bmi.s   S3TailsScript_PartnerExitReturn
                move.w  #$7F00,x_pos(a0)
                move.w  #0,y_pos(a0)
                move.w  #$A,(Tails_CPU_routine).w

S3TailsScript_PartnerExitReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsScript_ClearInputBeforeBossCarry:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

S3TailsScript_StartBossCarry:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                lea     (Player_1).w,a1
                bsr.w   TailsS3InitializeCarriedPlayerAttachment
                move.b  #1,(Flying_carrying_Sonic_flag).w
                move.w  #$16,(Tails_CPU_routine).w

S3TailsScript_PulseBossCarryFlap:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   S3TailsScript_CheckBossCarryAltitude
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

S3TailsScript_CheckBossCarryAltitude:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$90,d0
                cmp.w   y_pos(a0),d0
                blo.s   S3TailsScript_RunBossClimbCarry
                move.w  #$18,(Tails_CPU_routine).w

S3TailsScript_RunBossClimbCarry:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

S3TailsScript_ChooseAutoCarryOrReacquire:
                move.b  #(8*60)/2,double_jump_property(a0)
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   S3TailsScript_CheckDownForSlowFlaps
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.w   S3TailsScript_RunCarryWithLeaderInput
                bra.w   S3TailsScript_ChooseHoverOrChase
; ---------------------------------------------------------------------------

; Down takes priority over Up and pulses every $C0 ticks
S3TailsScript_CheckDownForSlowFlaps:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.w   S3TailsScript_ChooseHoverOrChase
                clr.b   (_unkFAAC).w
                btst    #button_down,(Ctrl_1_held).w
                beq.s   S3TailsScript_CheckUpForFastFlaps
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$C0,(Tails_CPU_auto_fly_timer).w
                blo.s   S3TailsScript_MergeLeaderHeldXInput
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w
                bra.s   S3TailsScript_MergeLeaderHeldXInput
; ---------------------------------------------------------------------------

S3TailsScript_CheckUpForFastFlaps:
                btst    #button_up,(Ctrl_1_held).w
                beq.s   S3TailsScript_PulseNeutralFlapAt88
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$20,(Tails_CPU_auto_fly_timer).w
                blo.s   S3TailsScript_MergeLeaderHeldXInput
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w
                bra.s   S3TailsScript_MergeLeaderHeldXInput
; ---------------------------------------------------------------------------

S3TailsScript_PulseNeutralFlapAt88:
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$58,(Tails_CPU_auto_fly_timer).w
                bcs.s   S3TailsScript_MergeLeaderHeldXInput
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

S3TailsScript_MergeLeaderHeldXInput:
                move.b  (Ctrl_1_held).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                or.b    (Ctrl_2_held_logical).w,d0
                move.b  d0,(Ctrl_2_logical).w

S3TailsScript_RunCarryWithLeaderInput:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

S3TailsScript_StartSoloBossFlight:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.w  #$1C,(Tails_CPU_routine).w

S3TailsScript_PulseSoloClimbFlap:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   S3TailsScript_CheckSoloClimbAltitude
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

S3TailsScript_CheckSoloClimbAltitude:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$90,d0
                cmp.w   y_pos(a0),d0
                blo.s   S3TailsScript_SoloClimbReturn
                move.w  #$1E,(Tails_CPU_routine).w

S3TailsScript_SoloClimbReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsScript_RefreshSoloFlightBudget:
                move.b  #(8*60)/2,double_jump_property(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsScript_StartPrimaryFlyInRight:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #2,status(a0)
                move.w  #$100,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.w  #$22,(Tails_CPU_routine).w

S3TailsScript_PulsePrimaryFlyInRight:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   S3TailsScript_FinishFlyInOnLanding
                ori.w   #(button_right_mask<<8)|button_right_mask,(Ctrl_2_logical).w

S3TailsScript_FinishFlyInOnLanding:
                btst    #Status_InAir,status(a0)
                bne.s   S3TailsScript_PrimaryFlyInReturn
                move.w  #6,(Tails_CPU_routine).w
                move.b  #0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,move_lock(a0)
                andi.w  #drawing_mask,art_tile(a0)

S3TailsScript_PrimaryFlyInReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsScript_ChooseHoverOrChase:
                tst.b   (_unkFAAC).w
                bne.s   S3TailsScript_ChaseLeaderWithSavedAccel
                lea     (Player_1).w,a1
                tst.b   render_flags(a1)
                bpl.s   S3TailsScript_LatchChaseAndMeasureY
                tst.w   (Tails_CPU_idle_timer).w
                bne.w   S3TailsScript_RunCarryAfterHoverOrChase
                cmpi.w  #$300,y_vel(a1)
                bge.s   S3TailsScript_LatchChaseAndMeasureY
                move.w  #0,x_vel(a0)
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                cmpi.w  #$200,y_vel(a0)
                bge.s   S3TailsScript_EmitFallbackHoverFlap
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$58,(Tails_CPU_auto_fly_timer).w
                blo.s   S3TailsScript_AfterHoverPulse
                move.b  #0,(Tails_CPU_auto_fly_timer).w

; The vertical speed shortcut pulses the flap while retaining the timer
S3TailsScript_EmitFallbackHoverFlap:
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

S3TailsScript_AfterHoverPulse:
                bra.s   S3TailsScript_RunCarryAfterHoverOrChase
; ---------------------------------------------------------------------------

S3TailsScript_LatchChaseAndMeasureY:
                st      (_unkFAAC).w
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                bpl.s   S3TailsScript_StoreChaseYAccel
                neg.w   d1

; The chase temporarily keeps Y and X acceleration in the saved camera min and max X words
S3TailsScript_StoreChaseYAccel:
                lsr.w   #2,d1
                move.w  d1,d2
                lsr.w   #1,d2
                add.w   d2,d1
                move.w  d1,(Camera_stored_min_X_pos).w
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                bpl.s   S3TailsScript_StoreChaseXAccel
                neg.w   d1

S3TailsScript_StoreChaseXAccel:
                lsr.w   #2,d1
                move.w  d1,(Camera_stored_max_X_pos).w
                bra.w   S3TailsScript_RunCarryAfterHoverOrChase
; ---------------------------------------------------------------------------

S3TailsScript_ChaseLeaderWithSavedAccel:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                lea     (Player_1).w,a1
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                subi.w  #$10,d1
                move.w  (Camera_stored_max_X_pos).w,d2
                bclr    #Status_Facing,status(a0)
                cmp.w   x_pos(a1),d0
                blo.s   S3TailsScript_ApplyChaseXAndCheckY
                bset    #Status_Facing,status(a0)
                neg.w   d2

S3TailsScript_ApplyChaseXAndCheckY:
                add.w   d2,x_vel(a0)
                cmp.w   y_pos(a1),d1
                bhs.s   S3TailsScript_RunCarryAfterHoverOrChase
                move.w  (Camera_stored_min_X_pos).w,d2
                cmp.w   y_pos(a1),d1
                blo.s   S3TailsScript_ApplyChaseY
                neg.w   d2

S3TailsScript_ApplyChaseY:
                add.w   d2,y_vel(a0)

S3TailsScript_RunCarryAfterHoverOrChase:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic

; =============== S U B R O U T I N E =======================================
