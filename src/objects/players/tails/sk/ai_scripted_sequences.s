; Owner: objects/players/tails/sk
; Responsibility: Follower reset and interaction helpers, idle spindash and level-scripted flight or carrying sequences
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Reset the AI timers and park Tails outside the playfield for flying catch-up
SKTailsCPU_BeginOffscreenCatchUp:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Tails_CPU_flight_timer).w
                move.w  #2,(Tails_CPU_routine).w
                move.b  #$81,object_control(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #$7F00,x_pos(a0)
                move.w  #0,y_pos(a0)
                move.b  #0,double_jump_flag(a0)
                rts
; End of function SKTailsCPU_BeginOffscreenCatchUp

; =============== S U B R O U T I N E =======================================

; Check the offscreen timeout and the standing object's code signature. Retain this engine's interaction snapshot
SKTailsCPU_CheckCatchUpTriggers:
                tst.b   render_flags(a0)
                bmi.s   SKTailsScript_ClearTimeoutWhenVisible
                btst    #Status_OnObj,status(a0)
                beq.s   SKTailsScript_TickOffscreenTimeout
                moveq   #0,d0
                movea.w interact(a0),a3
                move.w  (Tails_CPU_interact).w,d0
                cmp.w   (a3),d0
                bne.s   SKTailsScript_ResetToOffscreenCatchUp

SKTailsScript_TickOffscreenTimeout:
                addq.w  #1,(Tails_CPU_flight_timer).w
                cmpi.w  #5*60,(Tails_CPU_flight_timer).w
                blo.s   SKTailsScript_ReadInteractCodeWord

SKTailsScript_ResetToOffscreenCatchUp:
                bra.w   SKTailsCPU_BeginOffscreenCatchUp
; ---------------------------------------------------------------------------

SKTailsScript_ClearTimeoutWhenVisible:
                move.w  #0,(Tails_CPU_flight_timer).w

SKTailsScript_ReadInteractCodeWord:
                btst    #Status_OnObj,status(a0)
                beq.s   SKTailsScript_InteractSampleReturn
                movea.w interact(a0),a3
                move.w  (a3),(Tails_CPU_interact).w

SKTailsScript_InteractSampleReturn:
                rts
; End of function SKTailsCPU_CheckCatchUpTriggers

; ---------------------------------------------------------------------------

SKTailsScript_CheckIdleSpinDash:
                bsr.w   SKTailsCPU_CheckCatchUpTriggers
                tst.w   (Tails_CPU_idle_timer).w
                bne.w   SKTailsScript_IdleSpinDashReturn
                tst.w   move_lock(a0)
                bne.s   SKTailsScript_IdleSpinDashReturn
                tst.b   spin_dash_flag(a0)
                bne.s   SKTailsScript_HoldSpinDashDown
                tst.w   ground_vel(a0)
                bne.s   SKTailsScript_IdleSpinDashReturn
                bclr    #Status_Facing,status(a0)
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   SKTailsScript_StartSpinDashInput
                bset    #Status_Facing,status(a0)

SKTailsScript_StartSpinDashInput:
                move.w  #(button_down_mask<<8)|button_down_mask,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$7F,d0
                beq.s   SKTailsScript_ReleaseSpinDashAndFollow
                cmpi.b  #8,anim(a0)
                bne.s   SKTailsScript_IdleSpinDashReturn
                move.w  #((button_A_mask|button_B_mask|button_C_mask|button_down_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask|button_down_mask),(Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

; Release on the 128-frame global phase
SKTailsScript_HoldSpinDashDown:
                move.w  #(button_down_mask<<8)|button_down_mask,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$7F,d0
                bne.s   SKTailsScript_PulseSpinChargeEvery32

SKTailsScript_ReleaseSpinDashAndFollow:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.w  #6,(Tails_CPU_routine).w
                rts
; ---------------------------------------------------------------------------

SKTailsScript_PulseSpinChargeEvery32:
                andi.b  #$1F,d0
                bne.s   SKTailsScript_IdleSpinDashReturn
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

SKTailsScript_IdleSpinDashReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsScript_InactiveStateReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsScript_StartIntroCarryRight:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #$100,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                lea     (Player_1).w,a1
                bsr.w   TailsSKInitializeCarriedPlayerAttachment
                move.b  #1,(Flying_carrying_Sonic_flag).w
                move.w  #$E,(Tails_CPU_routine).w

SKTailsScript_PulseIntroCarryRight:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   SKTailsScript_FinishIntroOnRiderGrounded
                ori.w   #(button_right_mask<<8)|button_right_mask,(Ctrl_2_logical).w

SKTailsScript_FinishIntroOnRiderGrounded:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   SKTailsScript_RunIntroCarry
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
                bpl.s   SKTailsScript_CopySolidityAndCheckExit
                ori.w   #high_priority,art_tile(a0)

SKTailsScript_CopySolidityAndCheckExit:
                move.b  top_solid_bit(a1),top_solid_bit(a0)
                move.b  lrb_solid_bit(a1),lrb_solid_bit(a0)
                cmpi.w  #1,(Player_mode).w
                bne.s   SKTailsScript_RunIntroCarry
                move.w  #$10,(Tails_CPU_routine).w

SKTailsScript_RunIntroCarry:
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

SKTailsScript_PulsePartnerExitInput:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   SKTailsScript_FinishPartnerExitOffscreen
                ori.w   #((button_A_mask|button_B_mask|button_C_mask|button_right_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask|button_right_mask),(Ctrl_2_logical).w

SKTailsScript_FinishPartnerExitOffscreen:
                tst.b   render_flags(a0)
                bmi.s   SKTailsScript_PartnerExitReturn
                moveq   #0,d0
                move.l  d0,(a0)
                move.w  d0,x_pos(a0)
                move.w  d0,y_pos(a0)
                move.w  #$A,(Tails_CPU_routine).w

SKTailsScript_PartnerExitReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsScript_ClearInputBeforeBossCarry:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

SKTailsScript_StartBossCarry:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                lea     (Player_1).w,a1
                bsr.w   TailsSKInitializeCarriedPlayerAttachment
                move.b  #1,(Flying_carrying_Sonic_flag).w
                move.w  #$16,(Tails_CPU_routine).w

SKTailsScript_PulseBossCarryFlap:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   SKTailsScript_CheckBossCarryAltitude
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

SKTailsScript_CheckBossCarryAltitude:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$90,d0
                cmp.w   y_pos(a0),d0
                blo.s   SKTailsScript_RunBossClimbCarry
                move.w  #$18,(Tails_CPU_routine).w

SKTailsScript_RunBossClimbCarry:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

SKTailsScript_ChooseAutoCarryOrReacquire:
                move.b  #(8*60)/2,double_jump_property(a0)
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   SKTailsScript_CheckDownForSlowFlaps
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.w   SKTailsScript_RunCarryWithLeaderInput
                bra.w   SKTailsScript_ChooseHoverOrChase
; ---------------------------------------------------------------------------

; Down takes priority over Up and pulses every $C0 ticks
SKTailsScript_CheckDownForSlowFlaps:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.w   SKTailsScript_ChooseHoverOrChase
                clr.b   (TailsChaseOrHPZAftermathLatch).w
                btst    #button_down,(Ctrl_1_held).w
                beq.s   SKTailsScript_CheckUpForFastFlaps
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$C0,(Tails_CPU_auto_fly_timer).w
                blo.s   SKTailsScript_MergeLeaderHeldXInput
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w
                bra.s   SKTailsScript_MergeLeaderHeldXInput
; ---------------------------------------------------------------------------

SKTailsScript_CheckUpForFastFlaps:
                btst    #button_up,(Ctrl_1_held).w
                beq.s   SKTailsScript_PulseNeutralFlapAt88
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$20,(Tails_CPU_auto_fly_timer).w
                blo.s   SKTailsScript_MergeLeaderHeldXInput
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w
                bra.s   SKTailsScript_MergeLeaderHeldXInput
; ---------------------------------------------------------------------------

SKTailsScript_PulseNeutralFlapAt88:
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$58,(Tails_CPU_auto_fly_timer).w
                blo.s   SKTailsScript_MergeLeaderHeldXInput
                move.b  #0,(Tails_CPU_auto_fly_timer).w
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

SKTailsScript_MergeLeaderHeldXInput:
                move.b  (Ctrl_1).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                or.b    (Ctrl_2_logical).w,d0
                move.b  d0,(Ctrl_2_logical).w

SKTailsScript_RunCarryWithLeaderInput:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic
; ---------------------------------------------------------------------------

SKTailsScript_StartSoloBossFlight:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.w  #$1C,(Tails_CPU_routine).w

SKTailsScript_PulseSoloClimbFlap:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.b  #(8*60)/2,double_jump_property(a0)
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   SKTailsScript_CheckSoloClimbAltitude
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

SKTailsScript_CheckSoloClimbAltitude:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$90,d0
                cmp.w   y_pos(a0),d0
                blo.s   SKTailsScript_SoloClimbReturn
                move.w  #$1E,(Tails_CPU_routine).w

SKTailsScript_SoloClimbReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsScript_RefreshSoloFlightBudget:
                move.b  #(8*60)/2,double_jump_property(a0)
                rts
; ---------------------------------------------------------------------------

SKTailsScript_StartPrimaryFlyInRight:
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                move.b  #2,status(a0)
                move.w  #$100,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.w  #$22,(Tails_CPU_routine).w

SKTailsScript_PulsePrimaryFlyInRight:
                move.w  #0,(Tails_CPU_idle_timer).w
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   SKTailsScript_FinishFlyInOnLanding
                ori.w   #(button_right_mask<<8)|button_right_mask,(Ctrl_2_logical).w

SKTailsScript_FinishFlyInOnLanding:
                btst    #Status_InAir,status(a0)
                bne.s   SKTailsScript_PrimaryFlyInReturn
                move.w  #6,(Tails_CPU_routine).w
                move.b  #0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #1<<Status_InAir,status(a0)
                move.w  #0,move_lock(a0)
                andi.w  #drawing_mask,art_tile(a0)

SKTailsScript_PrimaryFlyInReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsScript_ChooseHoverOrChase:
                tst.b   (TailsChaseOrHPZAftermathLatch).w
                bne.s   SKTailsScript_ChaseLeaderWithSavedAccel
                lea     (Player_1).w,a1
                tst.b   render_flags(a1)
                bpl.s   SKTailsScript_LatchChaseAndMeasureY
                tst.w   (Tails_CPU_idle_timer).w
                bne.w   SKTailsScript_RunCarryAfterHoverOrChase
                cmpi.w  #$300,y_vel(a1)
                bge.s   SKTailsScript_LatchChaseAndMeasureY
                move.w  #0,x_vel(a0)
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                cmpi.w  #$200,y_vel(a0)
                bge.s   SKTailsScript_EmitFallbackHoverFlap
                addq.b  #1,(Tails_CPU_auto_fly_timer).w
                cmpi.b  #$58,(Tails_CPU_auto_fly_timer).w
                blo.s   SKTailsScript_AfterHoverPulse
                move.b  #0,(Tails_CPU_auto_fly_timer).w

; The vertical speed shortcut pulses the flap while retaining the timer
SKTailsScript_EmitFallbackHoverFlap:
                ori.w   #((button_A_mask|button_B_mask|button_C_mask)<<8)|(button_A_mask|button_B_mask|button_C_mask),(Ctrl_2_logical).w

SKTailsScript_AfterHoverPulse:
                bra.s   SKTailsScript_RunCarryAfterHoverOrChase
; ---------------------------------------------------------------------------

SKTailsScript_LatchChaseAndMeasureY:
                st      (TailsChaseOrHPZAftermathLatch).w
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                bpl.s   SKTailsScript_StoreChaseYAccel
                neg.w   d1

; The chase temporarily keeps Y and X acceleration in the saved camera min and max X words
SKTailsScript_StoreChaseYAccel:
                lsr.w   #2,d1
                move.w  d1,d2
                lsr.w   #1,d2
                add.w   d2,d1
                move.w  d1,(Camera_stored_min_X_pos).w
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                bpl.s   SKTailsScript_StoreChaseXAccel
                neg.w   d1

SKTailsScript_StoreChaseXAccel:
                lsr.w   #2,d1
                move.w  d1,(Camera_stored_max_X_pos).w
                bra.w   SKTailsScript_RunCarryAfterHoverOrChase
; ---------------------------------------------------------------------------

SKTailsScript_ChaseLeaderWithSavedAccel:
                move.w  #(0<<8)|0,(Ctrl_2_logical).w
                lea     (Player_1).w,a1
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                subi.w  #$10,d1
                move.w  (Camera_stored_max_X_pos).w,d2
                bclr    #Status_Facing,status(a0)
                cmp.w   x_pos(a1),d0
                blo.s   SKTailsScript_ApplyChaseXAndCheckY
                bset    #Status_Facing,status(a0)
                neg.w   d2

SKTailsScript_ApplyChaseXAndCheckY:
                add.w   d2,x_vel(a0)
                cmp.w   y_pos(a1),d1
                bhs.s   SKTailsScript_RunCarryAfterHoverOrChase
                move.w  (Camera_stored_min_X_pos).w,d2
                cmp.w   y_pos(a1),d1
                blo.s   SKTailsScript_ApplyChaseY
                neg.w   d2

SKTailsScript_ApplyChaseY:
                add.w   d2,y_vel(a0)

SKTailsScript_RunCarryAfterHoverOrChase:
                lea     (Flying_carrying_Sonic_flag).w,a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bra.w   Tails_Carry_Sonic

; =============== S U B R O U T I N E =======================================
