; Owner: objects/players/sonic/sk
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
                blo.s   Player_Boundary_Sides

Player_Boundary_CheckBottom:
                tst.b   (Disable_death_plane).w
                bne.s   SKSonicJump_LevelBoundsReturn
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKSonicJump_CheckReverseDeathPlane
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0                    ; has Sonic touched the bottom boundary?
                blt.s   Player_Boundary_Bottom          ; if yes, branch

SKSonicJump_LevelBoundsReturn:
                rts
; ---------------------------------------------------------------------------

SKSonicJump_CheckReverseDeathPlane:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   y_pos(a0),d0
                blt.s   SKSonicJump_LevelBoundsReturn

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

SonicKnux_Roll:
                tst.b   status_secondary(a0)
                bmi.s   SKSonicJump_RollInputReturn
                move.b  (Ctrl_1_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0  ; is left/right being pressed?
                bne.s   SKSonicJump_RollInputReturn     ; if yes, branch
                btst    #button_down,(Ctrl_1_logical).w  ; is down being pressed?
                beq.s   Player_ChkWalk                  ; if not, branch
                move.w  ground_vel(a0),d0
                bpl.s   SKSonicJump_CheckRollStartSpeed
                neg.w   d0

SKSonicJump_CheckRollStartSpeed:
                cmpi.w  #$100,d0                        ; is Sonic moving at $100 speed or faster?
                bhs.s   Player_ChkRoll                  ; if so, branch
                btst    #Status_OnObj,status(a0)
                bne.s   SKSonicJump_RollInputReturn
                move.b  #8,anim(a0)                     ; enter ducking animation

SKSonicJump_RollInputReturn:
                rts
; ---------------------------------------------------------------------------

Player_ChkWalk:
                cmpi.b  #8,anim(a0)                     ; is Sonic ducking?
                bne.s   SKSonicJump_RollInputReturn
                move.b  #0,anim(a0)                     ; if so, enter walking animation
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
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicJump_PlayRollSFXAndSeedSpeed
                subi.w  #2*5,y_pos(a0)

SKSonicJump_PlayRollSFXAndSeedSpeed:
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l
                tst.w   ground_vel(a0)
                bne.s   SKSonicJump_StartRollReturn
                move.w  #$200,ground_vel(a0)

SKSonicJump_StartRollReturn:
                rts
; End of function SonicKnux_Roll

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to jump
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_Jump:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0  ; is A, B or C pressed?
                beq.w   SKSonicJump_LaunchReturn        ; if not, return
                moveq   #0,d0
                move.b  angle(a0),d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicJump_ProbeLaunchClearance
                addi.b  #$40,d0
                neg.b   d0
                subi.b  #$40,d0

SKSonicJump_ProbeLaunchClearance:
                addi.b  #$80,d0
                movem.l a4-a6,-(sp)
                bsr.w   CalcRoomOverHead
                movem.l (sp)+,a4-a6
                cmpi.w  #6,d1                           ; does Sonic have enough room to jump?
                blt.w   SKSonicJump_LaunchReturn        ; if not, branch
                move.w  #$680,d2
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKSonicJump_SelectUnderwaterImpulse
                move.w  #$800,d2                        ; set higher jump speed if super

SKSonicJump_SelectUnderwaterImpulse:
                btst    #Status_Underwater,status(a0)   ; Test if underwater
                beq.s   SKSonicJump_ApplyImpulseAndSkipGround
                move.w  #$380,d2                        ; set lower jump speed if under

; Use the surface normal for the launch and discard the ground movement return address
SKSonicJump_ApplyImpulseAndSkipGround:
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
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSonicJump_ApplyJumpRadiusOffset
                neg.w   d0

SKSonicJump_ApplyJumpRadiusOffset:
                sub.w   d0,y_pos(a0)

SKSonicJump_LaunchReturn:
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
                beq.s   SKSonicJump_CheckReleaseOrShieldAction  ; if not, branch
                move.w  #-$200,d1                       ; Underwater-specific

SKSonicJump_CheckReleaseOrShieldAction:
                cmp.w   y_vel(a0),d1                    ; is y speed greater than 4? (2 if underwater)
                ble.w   Sonic_ShieldMoves               ; if not, branch
                move.b  (Ctrl_1_held_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0  ; are buttons A, B or C being pressed?
                bne.s   SKSonicJump_ReleaseCapReturn    ; if yes, branch
                move.w  d1,y_vel(a0)                    ; cap jump height

SKSonicJump_ReleaseCapReturn:
                rts
; ---------------------------------------------------------------------------

Sonic_UpVelCap:
                tst.b   spin_dash_flag(a0)              ; is Sonic charging his spin dash?
                bne.s   SKSonicJump_UpwardSpeedLimitReturn  ; if yes, branch
                cmpi.w  #-$FC0,y_vel(a0)                ; is Sonic's Y speed faster (less than) than -15.75 (-$FC0)?
                bge.s   SKSonicJump_UpwardSpeedLimitReturn  ; if not, branch
                move.w  #-$FC0,y_vel(a0)                ; cap upward speed

SKSonicJump_UpwardSpeedLimitReturn:
                rts
; ---------------------------------------------------------------------------

Sonic_ShieldMoves:
                tst.b   double_jump_flag(a0)            ; is Sonic currently performing a double jump?
                bne.w   SKSonicJump_ShieldActionReturn  ; if yes, branch
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0  ; are buttons A, B, or C being pressed?
                beq.w   SKSonicJump_ShieldActionReturn  ; if not, branch
                bclr    #Status_RollJump,status(a0)
                tst.b   (Super_Sonic_Knux_flag).w       ; check Super-state
                beq.s   Sonic_FireShield                ; if not in a super-state, branch
                bmi.w   Sonic_HyperDash                 ; if Hyper, branch
                move.b  #1,double_jump_flag(a0)
                rts
; ---------------------------------------------------------------------------

Sonic_FireShield:
                btst    #Status_Invincible,status_secondary(a0)  ; first, does Sonic have invincibility?
                bne.w   SKSonicJump_ShieldActionReturn  ; if yes, branch
                btst    #Status_FireShield,status_secondary(a0)  ; does Sonic have a Fire Shield?
                beq.s   Sonic_LightningShield           ; if not, branch
                move.b  #1,(Shield+anim).w
                move.b  #1,double_jump_flag(a0)
                move.w  #$800,d0
                btst    #Status_Facing,status(a0)       ; is Sonic facing left?
                beq.s   SKSonicJump_ApplyFireDashAndResetHistory  ; if not, branch
                neg.w   d0                              ; reverse speed value, moving Sonic left

SKSonicJump_ApplyFireDashAndResetHistory:
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
                cmpi.b  #7,(Super_emerald_count).w      ; does Sonic have all 7 Super Emeralds?
                bhs.s   SKSonicJump_CheckTransformRingsAndTimer  ; if yes, branch
                cmpi.b  #7,(Chaos_emerald_count).w      ; does Sonic have all 7 Chaos Emeralds?
                blo.s   Sonic_InstaShield               ; if not, branch
                tst.b   (Emeralds_converted_flag).w
                bne.s   Sonic_InstaShield

SKSonicJump_CheckTransformRingsAndTimer:
                cmpi.w  #50,(Ring_count).w              ; does Sonic have at least 50 rings?
                blo.s   Sonic_InstaShield               ; if not, perform Insta-Shield
                tst.b   (Update_HUD_timer).w
                bne.s   Sonic_Transform

Sonic_InstaShield:
                btst    #Status_Shield,status_secondary(a0)  ; does Sonic have an S2 shield? (the elementals were already filtered out at this point)
                bne.s   SKSonicJump_ShieldActionReturn  ; if yes, branch
                move.b  #1,(Shield+anim).w
                move.b  #1,double_jump_flag(a0)
                move.w  #sfx_InstaAttack,d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SKSonicJump_ShieldActionReturn:
                rts
; ---------------------------------------------------------------------------

Sonic_Transform:
                move.b  #1,(Super_palette_status).w     ; set Super/Hyper palette status to 'fading'
                move.b  #$F,(Palette_timer).w
                move.w  #60,(Super_frame_count).w
                move.l  #Map_SuperSonic,mappings(a0)
                move.b  #$81,object_control(a0)
                move.b  #$1F,anim(a0)                   ; enter 'transformation' animation
                cmpi.b  #7,(Super_emerald_count).w      ; does Sonic have all 7 Super Emeralds?
                blo.s   .super                          ; if not, turn Super

                move.b  #-1,(Super_Sonic_Knux_flag).w   ; set flag to Hyper Sonic
                move.l  #Obj_HyperSonic_Stars,(Invincibility_stars).w  ; load Hyper Stars object
                move.l  #Obj_HyperSonicKnux_Trail,(Super_stars).w  ; load After-Images object
                bra.s   .continued
; ---------------------------------------------------------------------------

                .super:
                move.b  #1,(Super_Sonic_Knux_flag).w    ; set flag to Super Sonic
                move.l  #Obj_SuperSonicKnux_Stars,(Super_stars).w  ; load Super Stars object

                .continued:
                move.w  #$A00,Max_speed-Max_speed(a4)
                move.w  #$30,Acceleration-Max_speed(a4)
                move.w  #$100,Deceleration-Max_speed(a4)
                move.b  #0,invincibility_timer(a0)
                bset    #Status_Invincible,status_secondary(a0)
                moveq   #signextendB(sfx_SuperTransform),d0
                jsr     (Play_SFX).l
                moveq   #signextendB(mus_Invincibility),d0  ; play invincibility theme
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

Sonic_HyperDash:
                bsr.w   HyperAttackTouchResponse
                move.w  #$2000,(H_scroll_frame_offset).w
                bsr.w   Reset_Player_Position_Array
                move.b  #1,double_jump_flag(a0)
                move.b  #1,(Invincibility_stars+anim).w  ; This causes the screen flash, and sparks to come out of Sonic
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                move.b  (Ctrl_1_logical).w,d0
                andi.w  #button_up_mask|button_down_mask|button_left_mask|button_right_mask,d0  ; Get D-pad input
                beq.s   .noInput
; Any values totaling $B or above are produced by holding
; both opposing directions on the D-pad, which is invalid
                cmpi.b  #$B,d0
                bhs.s   .noInput
                lsl.w   #2,d0
                lea     Sonic_HyperDash_Velocities-4(pc,d0.w),a1
                move.w  (a1)+,d0
                move.w  d0,x_vel(a0)
                move.w  d0,ground_vel(a0)
                move.w  (a1)+,d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

                .noInput:
; If there's no directional input, we just dash forward
                move.w  #$800,d0                        ; Go right
                btst    #Status_Facing,status(a0)       ; ...unless Sonic is facing left
                beq.s   .applySpeeds
                neg.w   d0                              ; ...in which case, go left

                .applySpeeds:
                move.w  d0,x_vel(a0)
                move.w  d0,ground_vel(a0)
                move.w  #0,y_vel(a0)
                rts
; End of function Sonic_JumpHeight

; ---------------------------------------------------------------------------
Sonic_HyperDash_Velocities:
                dc.w    0, -$800                        ; up
                dc.w    0,  $800                        ; down
                dc.w    0,     0                        ; up + down (shouldn't happen)
                dc.w    -$800,     0                    ; left
                dc.w    -$800, -$800                    ; left + up
                dc.w    -$800,  $800                    ; left + down
                dc.w    0,     0                        ; left + up + down (shouldn't happen)
                dc.w    $800,     0                     ; right
                dc.w    $800, -$800                     ; right + up
                dc.w    $800,  $800                     ; right + down
; Everything after this would be bad button combinations
; ---------------------------------------------------------------------------
