; Owner: objects/players/sonic/s3
; Responsibility: Player level bounds, rolling initiation, jump launch, jump height and shield or hyper jump actions with private direction data
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Subroutine to prevent Sonic from leaving the boundaries of a level
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Player_LevelBound:
                move.l  x_pos(a0),d1
                move.w  x_vel(a0),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d1
                swap    d1
                move.w  (Camera_min_X_pos).w,d0
                addi.w  #$10,d0
                cmp.w   d1,d0                           ; has Sonic touched the left boundary?
                bhi.s   Player_Boundary_Sides           ; if yes, branch
                move.w  (Camera_max_X_pos).w,d0
                addi.w  #$128,d0
                cmp.w   d1,d0
                bls.s   Player_Boundary_Sides

Player_Boundary_CheckBottom:
                tst.b   (Disable_death_plane).w
                bne.s   S3SonicJumpActions_ReturnAfterDeathPlaneDisabledOrBoundsPassed
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0                    ; has Sonic touched the bottom boundary?
                blt.s   Player_Boundary_Bottom          ; if yes, branch

S3SonicJumpActions_ReturnAfterDeathPlaneDisabledOrBoundsPassed:
                rts
; ---------------------------------------------------------------------------

Player_Boundary_Bottom:
                jmp     (Kill_Character).l
; ---------------------------------------------------------------------------

Player_Boundary_Sides:
                move.w  d0,x_pos(a0)
                move.w  #0,2+x_pos(a0)                  ; subpixel x
                move.w  #0,x_vel(a0)
                move.w  #0,ground_vel(a0)
                bra.s   Player_Boundary_CheckBottom
; End of function Player_LevelBound

; =============== S U B R O U T I N E =======================================

Sonic_Roll:
                tst.b   status_secondary(a0)
                bmi.s   S3SonicJumpActions_ReturnAfterRollInputGateOrDuckSelection
                move.w  ground_vel(a0),d0
                bpl.s   S3SonicJumpActions_CompareRollingStartSpeedMagnitude
                neg.w   d0

S3SonicJumpActions_CompareRollingStartSpeedMagnitude:
                cmpi.w  #$80,d0                         ; is Sonic moving at $80 speed or faster?
                blo.s   S3SonicJumpActions_ReturnAfterRollInputGateOrDuckSelection  ; if so, branch
                move.b  (Ctrl_1_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0  ; is left/right being pressed?
                bne.s   S3SonicJumpActions_ReturnAfterRollInputGateOrDuckSelection  ; if yes, branch
                btst    #button_down,(Ctrl_1_held_logical).w  ; is down being pressed?
                bne.s   Player_ChkRoll                  ; if not, branch

S3SonicJumpActions_ReturnAfterRollInputGateOrDuckSelection:
                rts
; ---------------------------------------------------------------------------

Player_ChkRoll:
                btst    #Status_Roll,status(a0)         ; is Sonic already rolling?
                beq.s   Player_DoRoll                   ; if not, branch
                rts
; ---------------------------------------------------------------------------

Player_DoRoll:
                bset    #Status_Roll,status(a0)
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)                     ; enter roll animation
                addq.w  #5,y_pos(a0)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l
                tst.w   ground_vel(a0)
                bne.s   S3SonicJumpActions_ReturnAfterRollingShapeAndOptionalMinimumSpeed
                move.w  #$200,ground_vel(a0)

S3SonicJumpActions_ReturnAfterRollingShapeAndOptionalMinimumSpeed:
                rts
; End of function Sonic_Roll

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to jump
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_Jump:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0  ; is A, B or C pressed?
                beq.w   S3SonicJumpActions_ReturnFromRejectedJumpOrCompletedLaunch  ; if not, return
                moveq   #0,d0
                move.b  angle(a0),d0
                addi.b  #$80,d0
                movem.l a4-a6,-(sp)
                bsr.w   CalcRoomOverHead
                movem.l (sp)+,a4-a6
                cmpi.w  #6,d1                           ; does Sonic have enough room to jump?
                blt.w   S3SonicJumpActions_ReturnFromRejectedJumpOrCompletedLaunch  ; if not, branch
                move.w  #$680,d2
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   S3SonicJumpActions_OverrideJumpImpulseForUnderwaterStatus
                move.w  #$800,d2                        ; set higher jump speed if super

S3SonicJumpActions_OverrideJumpImpulseForUnderwaterStatus:
                btst    #Status_Underwater,status(a0)   ; Test if underwater
                beq.s   S3SonicJumpActions_ApplySurfaceNormalJumpImpulseAndAbortGroundCaller
                move.w  #$380,d2                        ; set lower jump speed if under

S3SonicJumpActions_ApplySurfaceNormalJumpImpulseAndAbortGroundCaller:
                moveq   #0,d0
                move.b  angle(a0),d0
                subi.b  #$40,d0
                jsr     (GetSineCosine).l
                muls.w  d2,d1
                asr.l   #8,d1
                add.w   d1,x_vel(a0)                    ; make Sonic jump (in X... this adds nothing on level ground)
                muls.w  d2,d0
                asr.l   #8,d0
                add.w   d0,y_vel(a0)                    ; make Sonic jump (in Y)
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
                bne.s   Sonic_RollJump
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)                     ; use "jumping" animation
                bset    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                sub.w   d0,y_pos(a0)

S3SonicJumpActions_ReturnFromRejectedJumpOrCompletedLaunch:
                rts
; ---------------------------------------------------------------------------

Sonic_RollJump:
                bset    #Status_RollJump,status(a0)     ; set the rolling+jumping flag
                rts
; End of function Sonic_Jump

; =============== S U B R O U T I N E =======================================

Sonic_JumpHeight:
                tst.b   jumping(a0)                     ; is Sonic jumping?
                beq.s   Sonic_UpVelCap                  ; if not, branch

                move.w  #-$400,d1
                btst    #Status_Underwater,status(a0)   ; is Sonic underwater?
                beq.s   S3SonicJumpActions_GateJumpReleaseCapVersusShieldAction  ; if not, branch
                move.w  #-$200,d1                       ; Underwater-specific

S3SonicJumpActions_GateJumpReleaseCapVersusShieldAction:
                cmp.w   y_vel(a0),d1                    ; is y speed greater than 4? (2 if underwater)
                ble.w   Sonic_ShieldMoves               ; if not, branch
                move.b  (Ctrl_1_held_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0  ; are buttons A, B or C being pressed?
                bne.s   S3SonicJumpActions_ReturnAfterHeldJumpOrReleaseVelocityCap  ; if yes, branch
                move.w  d1,y_vel(a0)                    ; cap jump height

S3SonicJumpActions_ReturnAfterHeldJumpOrReleaseVelocityCap:
                rts
; ---------------------------------------------------------------------------

Sonic_UpVelCap:
                tst.b   spin_dash_flag(a0)              ; is Sonic charging his spin dash?
                bne.s   S3SonicJumpActions_ReturnAfterNonJumpingUpwardVelocityLimit  ; if yes, branch
                cmpi.w  #-$FC0,y_vel(a0)                ; is Sonic's Y speed faster (less than) than -15.75 (-$FC0)?
                bge.s   S3SonicJumpActions_ReturnAfterNonJumpingUpwardVelocityLimit  ; if not, branch
                move.w  #-$FC0,y_vel(a0)                ; cap upward speed

S3SonicJumpActions_ReturnAfterNonJumpingUpwardVelocityLimit:
                rts
; ---------------------------------------------------------------------------

Sonic_ShieldMoves:
                tst.b   double_jump_flag(a0)            ; is Sonic currently performing a double jump?
                bne.w   S3SonicJumpActions_ReturnWhenAirActionUnavailableOrBasicShieldBlocks  ; if yes, branch
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0  ; are buttons A, B, or C being pressed?
                beq.w   S3SonicJumpActions_ReturnWhenAirActionUnavailableOrBasicShieldBlocks  ; if not, branch
                bclr    #Status_RollJump,status(a0)
                tst.b   (Super_Sonic_Knux_flag).w       ; check Super-state
                beq.s   Sonic_FireShield                ; if not in a super-state, branch
                move.b  #1,double_jump_flag(a0)
                rts
; ---------------------------------------------------------------------------

Sonic_FireShield:
                btst    #Status_Invincible,status_secondary(a0)  ; first, does Sonic have invincibility?
                bne.w   S3SonicJumpActions_ReturnWhenAirActionUnavailableOrBasicShieldBlocks  ; if yes, branch
                btst    #Status_FireShield,status_secondary(a0)  ; does Sonic have a Fire Shield?
                beq.s   Sonic_LightningShield           ; if not, branch
                move.b  #1,(Shield+anim).w
                move.b  #1,double_jump_flag(a0)
                move.w  #$800,d0
                btst    #Status_Facing,status(a0)       ; is Sonic facing left?
                beq.s   S3SonicJumpActions_ApplyFacingFireShieldDashAndResetHistory  ; if not, branch
                neg.w   d0                              ; reverse speed value, moving Sonic left

S3SonicJumpActions_ApplyFacingFireShieldDashAndResetHistory:
                move.w  d0,x_vel(a0)                    ; apply velocity
                move.w  d0,ground_vel(a0)               ; ...both ground and air
                move.w  #0,y_vel(a0)                    ; kill y-velocity
                move.w  #$2000,(H_scroll_frame_offset).w
                bsr.w   Reset_Player_Position_Array
                move.w  #sfx_FireAttack,d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

Sonic_LightningShield:
                btst    #Status_LtngShield,status_secondary(a0)  ; does Sonic have a Lightning Shield?
                beq.s   Sonic_BubbleShield              ; if not, branch
                move.b  #1,(Shield+anim).w
                move.b  #1,double_jump_flag(a0)
                move.w  #-$580,y_vel(a0)                ; bounce Sonic up, creating the double jump effect
                clr.b   jumping(a0)
                move.w  #sfx_ElectricAttack,d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

Sonic_BubbleShield:
                btst    #Status_BublShield,status_secondary(a0)  ; does Sonic have a Bubble Shield?
                beq.s   Sonic_CheckTransform            ; if not, branch
                move.b  #1,(Shield+anim).w
                move.b  #1,double_jump_flag(a0)
                move.w  #0,x_vel(a0)                    ; halt horizontal speed
                move.w  #0,ground_vel(a0)               ; ...both ground and air
                move.w  #$800,y_vel(a0)                 ; force Sonic down
                move.w  #sfx_BubbleAttack,d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------
; Code that transforms Sonic into Super/Hyper Sonic
; if he has enough rings and emeralds
; ---------------------------------------------------------------------------

Sonic_CheckTransform:
                cmpi.w  #7,(Chaos_emerald_count).w      ; does Sonic have all 7 Chaos Emeralds?
                blo.s   Sonic_InstaShield               ; if not, branch
                cmpi.w  #50,(Ring_count).w              ; does Sonic have at least 50 rings?
                blo.s   Sonic_InstaShield               ; if not, perform Insta-Shield
                tst.b   (Update_HUD_timer).w
                bne.s   Sonic_Transform

Sonic_InstaShield:
                btst    #Status_Shield,status_secondary(a0)  ; does Sonic have an S2 shield? (the elementals were already filtered out at this point)
                bne.s   S3SonicJumpActions_ReturnWhenAirActionUnavailableOrBasicShieldBlocks  ; if yes, branch
                move.b  #1,(Shield+anim).w
                move.b  #1,double_jump_flag(a0)
                move.w  #sfx_InstaAttack,d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

S3SonicJumpActions_ReturnWhenAirActionUnavailableOrBasicShieldBlocks:
                rts
; ---------------------------------------------------------------------------

Sonic_Transform:
                move.b  #1,(Super_palette_status).w     ; set Super palette status to 'fading'
                move.b  #$F,(Palette_timer).w
                move.b  #1,(Super_Sonic_Knux_flag).w    ; set flag to Super Sonic
                move.w  #60,(Super_frame_count).w
                move.l  #Map_SuperSonic,mappings(a0)
                move.b  #$81,object_control(a0)
                move.b  #$1F,anim(a0)                   ; enter 'transformation' animation
                move.l  #Obj_SuperSonic_Stars,(Super_stars).w  ; load Super Stars object
                move.w  #$A00,Max_speed-Max_speed(a4)
                move.w  #$30,Acceleration-Max_speed(a4)
                move.w  #$100,Deceleration-Max_speed(a4)
                move.b  #0,invincibility_timer(a0)
                bset    #Status_Invincible,status_secondary(a0)
                move.w  #signextendB(sfx_SuperTransform),d0
                jsr     (Play_SFX).l
                move.w  #signextendB(mus_Invincibility),d0  ; play invincibility theme
                jmp     (Play_Music).l
; End of function Sonic_JumpHeight

; =============== S U B R O U T I N E =======================================
