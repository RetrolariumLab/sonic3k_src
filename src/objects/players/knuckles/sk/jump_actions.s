; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles jump launch, jump height control and glide initiation
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Knux_Jump:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKKnucklesJump_ReturnFromRejectedOrNewlyRollingJumpWithProperStackContext
                moveq   #0,d0
                move.b  angle(a0),d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnucklesJump_ProbeOverheadAfterOptionalGravityAngleNormalization
                addi.b  #$40,d0
                neg.b   d0
                subi.b  #$40,d0

SKKnucklesJump_ProbeOverheadAfterOptionalGravityAngleNormalization:
                addi.b  #$80,d0
                movem.l a4-a6,-(sp)
                jsr     (CalcRoomOverHead).l
                movem.l (sp)+,a4-a6
                cmpi.w  #6,d1
                blt.w   SKKnucklesJump_ReturnFromRejectedOrNewlyRollingJumpWithProperStackContext
                move.w  #$600,d2
                btst    #Status_Underwater,status(a0)
                beq.s   SKKnucklesJump_AddKnucklesJumpImpulseAndDiscardGroundReturn
                move.w  #$300,d2

SKKnucklesJump_AddKnucklesJumpImpulseAndDiscardGroundReturn:
                moveq   #0,d0
                move.b  angle(a0),d0
                subi.b  #$40,d0
                jsr     (GetSineCosine).l
                muls.w  d2,d1
                asr.l   #8,d1
                add.w   d1,x_vel(a0)
                muls.w  d2,d0
                asr.l   #8,d0
                add.w   d0,y_vel(a0)
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                addq.l  #4,sp
                move.b  #1,jumping(a0)
                clr.b   stick_to_convex(a0)
                move.w  #sfx_Jump,d0
                jsr     (Play_SFX).l
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                btst    #Status_Roll,status(a0)
                bne.s   SKKnucklesJump_MarkJumpStartedWhileAlreadyRolling
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                bset    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnucklesJump_ApplySignedJumpRadiusDeltaToIntegerY
                neg.w   d0

SKKnucklesJump_ApplySignedJumpRadiusDeltaToIntegerY:
                sub.w   d0,y_pos(a0)

SKKnucklesJump_ReturnFromRejectedOrNewlyRollingJumpWithProperStackContext:
                rts
; ---------------------------------------------------------------------------

SKKnucklesJump_MarkJumpStartedWhileAlreadyRolling:
                bset    #Status_RollJump,status(a0)
                rts
; End of function Knux_Jump

; =============== S U B R O U T I N E =======================================

Knux_JumpHeight:
                tst.b   jumping(a0)
                beq.s   SKKnucklesJump_CapNonJumpUpwardVelocityUnlessSpinFlagSet
                move.w  #-$400,d1
                btst    #Status_Underwater,status(a0)
                beq.s   SKKnucklesJump_TestGlideOrCapReleasedJumpAtSignedYThreshold
                move.w  #-$200,d1

SKKnucklesJump_TestGlideOrCapReleasedJumpAtSignedYThreshold:
                cmp.w   y_vel(a0),d1
                ble.w   Knux_Test_For_Glide
                move.b  (Ctrl_1_held_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   SKKnucklesJump_ReturnAfterHeldOrReleasedJumpHeightDecision
                move.w  d1,y_vel(a0)

SKKnucklesJump_ReturnAfterHeldOrReleasedJumpHeightDecision:
                rts
; ---------------------------------------------------------------------------

SKKnucklesJump_CapNonJumpUpwardVelocityUnlessSpinFlagSet:
                tst.b   spin_dash_flag(a0)
                bne.s   SKKnucklesJump_ReturnAfterNonJumpVelocityCapOrSpinExemption
                cmpi.w  #-$FC0,y_vel(a0)
                bge.s   SKKnucklesJump_ReturnAfterNonJumpVelocityCapOrSpinExemption
                move.w  #-$FC0,y_vel(a0)

SKKnucklesJump_ReturnAfterNonJumpVelocityCapOrSpinExemption:
                rts
; ---------------------------------------------------------------------------

Knux_Test_For_Glide:
                tst.b   double_jump_flag(a0)
                bne.w   SKKnucklesJump_ReturnAfterRejectedOrInitializedGlide
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKKnucklesJump_ReturnAfterRejectedOrInitializedGlide
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   SKKnucklesJump_EnterGlideWithTenPixelRadiiAndNonnegativeAdjustedY
                cmpi.b  #7,(Super_emerald_count).w
                bhs.s   SKKnucklesJump_GateSuperOrHyperTransformByRingsAndRunningHudTimer
                cmpi.b  #7,(Chaos_emerald_count).w
                blo.s   SKKnucklesJump_EnterGlideWithTenPixelRadiiAndNonnegativeAdjustedY
                tst.b   (Emeralds_converted_flag).w
                bne.s   SKKnucklesJump_EnterGlideWithTenPixelRadiiAndNonnegativeAdjustedY

SKKnucklesJump_GateSuperOrHyperTransformByRingsAndRunningHudTimer:
                cmpi.w  #50,(Ring_count).w
                blo.s   SKKnucklesJump_EnterGlideWithTenPixelRadiiAndNonnegativeAdjustedY
                tst.b   (Update_HUD_timer).w
                bne.s   Knux_Transform

SKKnucklesJump_EnterGlideWithTenPixelRadiiAndNonnegativeAdjustedY:
                bclr    #Status_Roll,status(a0)
                move.b  #$A,y_radius(a0)
                move.b  #$A,x_radius(a0)
                bclr    #Status_RollJump,status(a0)
                move.b  #1,double_jump_flag(a0)
                addi.w  #$200,y_vel(a0)
                bpl.s   SKKnucklesJump_InitializePositiveGlideMagnitudeAndFacingSignedHeading
                move.w  #0,y_vel(a0)

SKKnucklesJump_InitializePositiveGlideMagnitudeAndFacingSignedHeading:
                moveq   #0,d1
                move.w  #$400,d0
                move.w  d0,ground_vel(a0)
                btst    #Status_Facing,status(a0)
                beq.s   SKKnucklesJump_StoreGlideXHeadingClearBothAnglesAndInitializeContactFlags
                neg.w   d0
                moveq   #-$80,d1

SKKnucklesJump_StoreGlideXHeadingClearBothAnglesAndInitializeContactFlags:
                move.w  d0,x_vel(a0)
                move.b  d1,double_jump_property(a0)
                move.w  #0,angle(a0)
                move.b  #0,(Gliding_collision_flags).w
                bset    #Status_InAir,(Gliding_collision_flags).w
                bsr.w   Knuckles_Set_Gliding_Animation

SKKnucklesJump_ReturnAfterRejectedOrInitializedGlide:
                rts
; ---------------------------------------------------------------------------

Knux_Transform:
                move.b  #1,(Super_palette_status).w     ; set Super/Hyper palette status to 'fading'
                move.b  #$F,(Palette_timer).w
                move.w  #60,(Super_frame_count).w
                move.b  #$81,object_control(a0)
                move.b  #$1F,anim(a0)                   ; enter 'transformation' animation
                cmpi.b  #7,(Super_emerald_count).w      ; does Knuckles have all 7 Super Emeralds?
                blo.s   .super                          ; if not, turn Super

                move.b  #-1,(Super_Sonic_Knux_flag).w   ; set flag to Hyper Knuckles
                move.l  #Obj_HyperSonicKnux_Trail,(Super_stars).w  ; load After-Images object
                bra.s   .continued
; ---------------------------------------------------------------------------

                .super:
                move.b  #1,(Super_Sonic_Knux_flag).w    ; set flag to Super Knuckles
                move.l  #Obj_SuperSonicKnux_Stars,(Super_stars).w  ; load Super Stars object

                .continued:
                move.w  #$800,Max_speed-Max_speed(a4)
                move.w  #$18,Acceleration-Max_speed(a4)
                move.w  #$C0,Deceleration-Max_speed(a4)
                move.b  #0,invincibility_timer(a0)
                bset    #Status_Invincible,status_secondary(a0)
                moveq   #signextendB(sfx_SuperTransform),d0
                jsr     (Play_SFX).l
                moveq   #signextendB(mus_Invincibility),d0  ; play invincibility theme
                jmp     (Play_Music).l
; End of function Knux_JumpHeight
