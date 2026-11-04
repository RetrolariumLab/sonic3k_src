; Owner: objects/players/tails/s3
; Responsibility: Tails screen bounds, rolling initiation, jump launch and jump height control
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Tails_Check_Screen_Boundaries:
                move.l  x_pos(a0),d1
                move.w  x_vel(a0),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d1
                swap    d1
                move.w  (Camera_min_X_pos).w,d0
                addi.w  #$10,d0
                cmp.w   d1,d0
                bhi.s   S3TailsJump_ClampXAndStopMotion
                move.w  (Camera_max_X_pos).w,d0
                addi.w  #$128,d0
                cmp.w   d1,d0
                bls.s   S3TailsJump_ClampXAndStopMotion

S3TailsJump_CheckVerticalDeathPlane:
                tst.b   (Disable_death_plane).w
                bne.s   S3TailsJump_LevelBoundsReturn
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.s   S3TailsJump_KillAtScreenDeathPlane

S3TailsJump_LevelBoundsReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsJump_KillAtScreenDeathPlane:
                jmp     (Kill_Character).l
; ---------------------------------------------------------------------------

S3TailsJump_ClampXAndStopMotion:
                move.w  d0,x_pos(a0)
                move.w  #0,2+x_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,ground_vel(a0)
                bra.s   S3TailsJump_CheckVerticalDeathPlane
; End of function Tails_Check_Screen_Boundaries

; =============== S U B R O U T I N E =======================================

Tails_Roll:
                tst.b   status_secondary(a0)
                bmi.s   S3TailsJump_RollInputReturn
                move.w  ground_vel(a0),d0
                bpl.s   S3TailsJump_CheckRollStartSpeed
                neg.w   d0

S3TailsJump_CheckRollStartSpeed:
                cmpi.w  #$80,d0
                bcs.s   S3TailsJump_RollInputReturn
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   S3TailsJump_RollInputReturn
                btst    #button_down,(Ctrl_2_held_logical).w
                bne.s   S3TailsJump_CheckAlreadyRolling

S3TailsJump_RollInputReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsJump_CheckAlreadyRolling:
                btst    #Status_Roll,status(a0)
                beq.s   S3TailsJump_InitRollGeometry
                rts
; ---------------------------------------------------------------------------

S3TailsJump_InitRollGeometry:
                bset    #Status_Roll,status(a0)
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                addq.w  #1,y_pos(a0)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l
                tst.w   ground_vel(a0)
                bne.s   S3TailsJump_StartRollReturn
                move.w  #$200,ground_vel(a0)

S3TailsJump_StartRollReturn:
                rts
; End of function Tails_Roll

; =============== S U B R O U T I N E =======================================

Tails_Jump:
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3TailsJump_LaunchReturn
                moveq   #0,d0
                move.b  angle(a0),d0
                addi.b  #$80,d0
                movem.l a4-a6,-(sp)
                bsr.w   CalcRoomOverHead
                movem.l (sp)+,a4-a6
                cmpi.w  #6,d1
                blt.w   S3TailsJump_LaunchReturn
                move.w  #$680,d2
                btst    #Status_Underwater,status(a0)
                beq.s   S3TailsJump_ApplyImpulseAndSkipGround
                move.w  #$380,d2

; Launch along the surface normal and discard the ground movement return address
S3TailsJump_ApplyImpulseAndSkipGround:
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
                bne.s   S3TailsJump_MarkRollJump
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.b  #2,anim(a0)
                bset    #Status_Roll,status(a0)
                move.b  y_radius(a0),d0
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                sub.w   d0,y_pos(a0)

S3TailsJump_LaunchReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsJump_MarkRollJump:
                bset    #Status_RollJump,status(a0)
                rts
; End of function Tails_Jump

; =============== S U B R O U T I N E =======================================

Tails_JumpHeight:
                tst.b   jumping(a0)
                beq.s   S3TailsJump_CapNonJumpAscent
                move.w  #-$400,d1
                btst    #Status_Underwater,status(a0)
                beq.s   S3TailsJump_CheckReleaseOrFlight
                move.w  #-$200,d1

S3TailsJump_CheckReleaseOrFlight:
                cmp.w   y_vel(a0),d1
                ble.s   Tails_Test_For_Flight
                move.b  (Ctrl_2_held_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   S3TailsJump_ReleaseCapReturn
                move.w  d1,y_vel(a0)

S3TailsJump_ReleaseCapReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsJump_CapNonJumpAscent:
                tst.b   spin_dash_flag(a0)
                bne.s   S3TailsJump_UpwardSpeedLimitReturn
                cmpi.w  #-$FC0,y_vel(a0)
                bge.s   S3TailsJump_UpwardSpeedLimitReturn
                move.w  #-$FC0,y_vel(a0)

S3TailsJump_UpwardSpeedLimitReturn:
                rts
; ---------------------------------------------------------------------------

Tails_Test_For_Flight:
                tst.b   double_jump_flag(a0)
                bne.w   S3TailsJump_FlightStartReturn
                move.b  (Ctrl_2_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3TailsJump_FlightStartReturn
                cmpi.w  #2,(Player_mode).w
                beq.s   S3TailsJump_UnrollForFlight
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   S3TailsJump_FlightStartReturn

S3TailsJump_UnrollForFlight:
                btst    #Status_Roll,status(a0)
                beq.s   S3TailsJump_StartFlightAndAnimate
                bclr    #Status_Roll,status(a0)
                move.b  y_radius(a0),d1
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                sub.b   default_y_radius(a0),d1
                ext.w   d1
                add.w   d1,y_pos(a0)

S3TailsJump_StartFlightAndAnimate:
                bclr    #Status_RollJump,status(a0)
                move.b  #1,double_jump_flag(a0)
                move.b  #(8*60)/2,double_jump_property(a0)
                bsr.w   Tails_Set_Flying_Animation

S3TailsJump_FlightStartReturn:
                rts
; End of function Tails_JumpHeight
