; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles hurt, death, recovery, restart and collision response states
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Knux_DoLevelCollision_CheckRet:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   SKKnuxGlideHit_DispatchVelocitySector
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

SKKnuxGlideHit_DispatchVelocitySector:
                move.b  lrb_solid_bit(a0),d5
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                subi.b  #$20,d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   SKKnuxGlideHit_CheckLeftSectorWall
                cmpi.b  #$80,d0
                beq.w   SKKnuxGlideHit_CheckUpwardLeftWall
                cmpi.b  #$C0,d0
                beq.w   SKKnuxGlideHit_CheckRightSectorWall
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKKnuxGlideHit_CheckDefaultRightWall
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

SKKnuxGlideHit_CheckDefaultRightWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKKnuxGlideHit_ProbeDefaultFloor
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

SKKnuxGlideHit_ProbeDefaultFloor:
                bsr.w   SKPlayer_ProbeGravityFloor
                tst.w   d1
                bpl.s   SKKnuxGlideHit_DefaultFloorReturn
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnuxGlideHit_LandOnDefaultFloor
                neg.w   d1

; Clear the air bit in the glide collision flags
SKKnuxGlideHit_LandOnDefaultFloor:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                bclr    #Status_InAir,(Gliding_collision_flags).w

SKKnuxGlideHit_DefaultFloorReturn:
                rts
; ---------------------------------------------------------------------------

SKKnuxGlideHit_CheckLeftSectorWall:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKKnuxGlideHit_CheckLeftSectorCeiling
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

SKKnuxGlideHit_CheckLeftSectorCeiling:
                bsr.w   SKPlayer_ProbeGravityCeiling
                tst.w   d1
                bpl.s   SKKnuxGlideHit_TryLeftSectorFloor
                neg.w   d1
                cmpi.w  #$14,d1
                bhs.s   SKKnuxGlideHit_ProbeWallAtDeepCeiling
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnuxGlideHit_CorrectLeftCeilingY
                neg.w   d1

SKKnuxGlideHit_CorrectLeftCeilingY:
                add.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   SKKnuxGlideHit_LeftCeilingReturn
                move.w  #0,y_vel(a0)

SKKnuxGlideHit_LeftCeilingReturn:
                rts
; ---------------------------------------------------------------------------

; Ceiling penetration of at least $14 pixels routes the left sector to the opposite wall probe
SKKnuxGlideHit_ProbeWallAtDeepCeiling:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKKnuxGlideHit_DeepCeilingWallReturn
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

SKKnuxGlideHit_DeepCeilingWallReturn:
                rts
; ---------------------------------------------------------------------------

SKKnuxGlideHit_TryLeftSectorFloor:
                tst.w   y_vel(a0)
                bmi.s   SKKnuxGlideHit_LeftFloorReturn
                bsr.w   SKPlayer_ProbeGravityFloor
                tst.w   d1
                bpl.s   SKKnuxGlideHit_LeftFloorReturn
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnuxGlideHit_LandOnLeftSectorFloor
                neg.w   d1

SKKnuxGlideHit_LandOnLeftSectorFloor:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                bclr    #Status_InAir,(Gliding_collision_flags).w

SKKnuxGlideHit_LeftFloorReturn:
                rts
; ---------------------------------------------------------------------------

SKKnuxGlideHit_CheckUpwardLeftWall:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKKnuxGlideHit_CheckUpwardRightWall
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

SKKnuxGlideHit_CheckUpwardRightWall:
                jsr     (CheckRightWallDist).l
                tst.w   d1
                bpl.s   SKKnuxGlideHit_ProbeUpwardSectorCeiling
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

SKKnuxGlideHit_ProbeUpwardSectorCeiling:
                bsr.w   SKPlayer_ProbeGravityCeiling
                tst.w   d1
                bpl.s   SKKnuxGlideHit_UpwardCeilingReturn
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnuxGlideHit_CorrectUpwardCeilingY
                neg.w   d1

SKKnuxGlideHit_CorrectUpwardCeilingY:
                sub.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)

SKKnuxGlideHit_UpwardCeilingReturn:
                rts
; ---------------------------------------------------------------------------

SKKnuxGlideHit_CheckRightSectorWall:
                jsr     (CheckRightWallDist).l
                tst.w   d1
                bpl.s   SKKnuxGlideHit_CheckRightSectorCeiling
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

SKKnuxGlideHit_CheckRightSectorCeiling:
                bsr.w   SKPlayer_ProbeGravityCeiling
                tst.w   d1
                bpl.s   SKKnuxGlideHit_TryRightSectorFloor
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnuxGlideHit_CorrectRightCeilingY
                neg.w   d1

SKKnuxGlideHit_CorrectRightCeilingY:
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   SKKnuxGlideHit_RightCeilingReturn
                move.w  #0,y_vel(a0)

SKKnuxGlideHit_RightCeilingReturn:
                rts
; ---------------------------------------------------------------------------

SKKnuxGlideHit_TryRightSectorFloor:
                tst.w   y_vel(a0)
                bmi.s   SKKnuxGlideHit_RightFloorReturn
                bsr.w   SKPlayer_ProbeGravityFloor
                tst.w   d1
                bpl.s   SKKnuxGlideHit_RightFloorReturn
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnuxGlideHit_LandOnRightSectorFloor
                neg.w   d1

SKKnuxGlideHit_LandOnRightSectorFloor:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                bclr    #Status_InAir,(Gliding_collision_flags).w

SKKnuxGlideHit_RightFloorReturn:
                rts
; End of function Knux_DoLevelCollision_CheckRet

; ---------------------------------------------------------------------------
; unused/dead code

Knux_TouchFloor_Check_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   SKKnuxLand_ResetLandingAndGlide
                move.b  #0,anim(a0)
; End of function Knux_TouchFloor_Check_Spindash

; =============== S U B R O U T I N E =======================================

Knux_TouchFloor:
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                btst    #Status_Roll,status(a0)
                beq.s   SKKnuxLand_ResetLandingAndGlide
                bclr    #Status_Roll,status(a0)
                move.b  #0,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnuxLand_AdjustUnrollOffsetForSurface
                neg.w   d0

SKKnuxLand_AdjustUnrollOffsetForSurface:
                move.w  d0,-(sp)
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bpl.s   SKKnuxLand_ApplyUnrollYOffset
                neg.w   (sp)

SKKnuxLand_ApplyUnrollYOffset:
                move.w  (sp)+,d0
                add.w   d0,y_pos(a0)

SKKnuxLand_ResetLandingAndGlide:
                bclr    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                bclr    #Status_RollJump,status(a0)
                move.b  #0,jumping(a0)
                move.w  #0,(Chain_bonus_counter).w
                move.b  #0,flip_angle(a0)
                move.b  #0,flip_type(a0)
                move.b  #0,flips_remaining(a0)
                move.b  #0,scroll_delay_counter(a0)
                move.b  #0,double_jump_flag(a0)
                cmpi.b  #$20,anim(a0)
                blo.s   SKKnuxLand_LandingResetReturn
                move.b  #0,anim(a0)

SKKnuxLand_LandingResetReturn:
                rts
; End of function Knux_TouchFloor

; ---------------------------------------------------------------------------

SKKnuxRecovery_CheckHurtDebugEntry:
                tst.w   (Debug_mode_flag).w
                beq.s   SKKnuxRecovery_MoveHurtAndApplyGravity
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKKnuxRecovery_MoveHurtAndApplyGravity
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKKnuxRecovery_MoveHurtAndApplyGravity:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   SKKnuxRecovery_WrapHurtYIfEnabled
                subi.w  #$20,y_vel(a0)

SKKnuxRecovery_WrapHurtYIfEnabled:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   SKKnuxRecovery_ResolveHurtAndDraw
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

SKKnuxRecovery_ResolveHurtAndDraw:
                bsr.w   ResolveKnucklesHurtLandingOrDeathPlane
                bsr.w   Player_LevelBound
                bsr.w   Sonic_RecordPos
                bsr.w   Knux_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

ResolveKnucklesHurtLandingOrDeathPlane:
                tst.b   (Disable_death_plane).w
                bne.s   SKKnuxRecovery_CheckHurtLandingAndReset
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKKnuxRecovery_CheckReverseDeathPlane
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   SKKnuxRecovery_KillAtHurtDeathPlane
                bra.s   SKKnuxRecovery_CheckHurtLandingAndReset
; ---------------------------------------------------------------------------

; The reverse death plane includes equality at the camera minimum
SKKnuxRecovery_CheckReverseDeathPlane:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   y_pos(a0),d0
                blt.s   SKKnuxRecovery_CheckHurtLandingAndReset
                bra.w   SKKnuxRecovery_KillAtHurtDeathPlane
; ---------------------------------------------------------------------------

SKKnuxRecovery_CheckHurtLandingAndReset:
                movem.l a4-a6,-(sp)
                bsr.w   SonicKnux_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   SKKnuxRecovery_HurtLandingReturn
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

SKKnuxRecovery_HurtLandingReturn:
                rts
; ---------------------------------------------------------------------------

SKKnuxRecovery_KillAtHurtDeathPlane:
                jmp     (Kill_Character).l
; End of function ResolveKnucklesHurtLandingOrDeathPlane

; ---------------------------------------------------------------------------

SKKnuxRecovery_CheckDeathDebugEntry:
                tst.w   (Debug_mode_flag).w
                beq.s   SKKnuxRecovery_ResolveDeathAndDraw
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKKnuxRecovery_ResolveDeathAndDraw
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKKnuxRecovery_ResolveDeathAndDraw:
                bsr.w   SKPlayer_FinishDeath
                jsr     (MoveSprite_TestGravity).l
                bsr.w   Sonic_RecordPos
                bsr.w   Knux_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Request the restart on the decrement to zero. An already-zero timer holds
SKKnuxRecovery_TickRestartTimer:
                tst.w   $3E(a0)
                beq.s   SKKnuxRecovery_RestartReturn
                subq.w  #1,$3E(a0)
                bne.s   SKKnuxRecovery_RestartReturn
                move.w  #1,(Restart_level_flag).w

SKKnuxRecovery_RestartReturn:
                rts
; ---------------------------------------------------------------------------

SKKnuxRecovery_CheckP1ScrollSettled:
                tst.w   (H_scroll_amount).w
                bne.s   SKKnuxRecovery_DrawScrollWaitFrame
                tst.w   (V_scroll_amount).w
                bne.s   SKKnuxRecovery_DrawScrollWaitFrame
                move.b  #2,routine(a0)

SKKnuxRecovery_DrawScrollWaitFrame:
                bsr.w   Knux_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKKnuxRecovery_CheckDrownDebugEntry:
                tst.w   (Debug_mode_flag).w
                beq.s   SKKnuxRecovery_MoveDrowningAndDraw
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKKnuxRecovery_MoveDrowningAndDraw
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKKnuxRecovery_MoveDrowningAndDraw:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   Knux_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Mirror vertical rendering after animation when gravity is reversed. Tail-call the normal pattern loader
Knux_AnimateRecoveryAndLoadArt:
                bsr.s   Animate_Knuckles
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKKnuxRecovery_LoadRecoveryPatterns
                eori.b  #2,render_flags(a0)

SKKnuxRecovery_LoadRecoveryPatterns:
                bra.w   Knuckles_Load_PLC
; End of function Knux_AnimateRecoveryAndLoadArt
