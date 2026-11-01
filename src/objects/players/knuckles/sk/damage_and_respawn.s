; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles hurt, death, recovery, restart and collision response states
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Knux_DoLevelCollision_CheckRet:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_17952
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_17952:
                move.b  lrb_solid_bit(a0),d5
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                subi.b  #$20,d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   loc_179DA
                cmpi.b  #$80,d0
                beq.w   loc_17A62
                cmpi.b  #$C0,d0
                beq.w   loc_17AB0
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_1799C
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

loc_1799C:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   loc_179B4
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

loc_179B4:
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   locret_179D8
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_179C4
                neg.w   d1

loc_179C4:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                bclr    #Status_InAir,(Gliding_collision_flags).w

locret_179D8:
                rts
; ---------------------------------------------------------------------------

loc_179DA:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_179F2
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

loc_179F2:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   loc_17A36
                neg.w   d1
                cmpi.w  #$14,d1
                bhs.s   loc_17A1C
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_17A0A
                neg.w   d1

loc_17A0A:
                add.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_17A1A
                move.w  #0,y_vel(a0)

locret_17A1A:
                rts
; ---------------------------------------------------------------------------

loc_17A1C:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   locret_17A34
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

locret_17A34:
                rts
; ---------------------------------------------------------------------------

loc_17A36:
                tst.w   y_vel(a0)
                bmi.s   locret_17A60
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   locret_17A60
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_17A4C
                neg.w   d1

loc_17A4C:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                bclr    #Status_InAir,(Gliding_collision_flags).w

locret_17A60:
                rts
; ---------------------------------------------------------------------------

loc_17A62:
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   loc_17A7A
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

loc_17A7A:
                jsr     (CheckRightWallDist).l
                tst.w   d1
                bpl.s   loc_17A94
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

loc_17A94:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   locret_17AAE
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_17AA4
                neg.w   d1

loc_17AA4:
                sub.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)

locret_17AAE:
                rts
; ---------------------------------------------------------------------------

loc_17AB0:
                jsr     (CheckRightWallDist).l
                tst.w   d1
                bpl.s   loc_17ACA
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                bset    #Status_Push,(Gliding_collision_flags).w

loc_17ACA:
                bsr.w   CheckSKPlayerGravityRelativeCeilingAndNormalizeAngle
                tst.w   d1
                bpl.s   loc_17AEC
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_17ADA
                neg.w   d1

loc_17ADA:
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_17AEA
                move.w  #0,y_vel(a0)

locret_17AEA:
                rts
; ---------------------------------------------------------------------------

loc_17AEC:
                tst.w   y_vel(a0)
                bmi.s   locret_17B16
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle
                tst.w   d1
                bpl.s   locret_17B16
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_17B02
                neg.w   d1

loc_17B02:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                move.w  #0,y_vel(a0)
                bclr    #Status_InAir,(Gliding_collision_flags).w

locret_17B16:
                rts
; End of function Knux_DoLevelCollision_CheckRet

; ---------------------------------------------------------------------------
; unused/dead code

Knux_TouchFloor_Check_Spindash:
                tst.b   spin_dash_flag(a0)
                bne.s   loc_17B6A
                move.b  #0,anim(a0)
; End of function Knux_TouchFloor_Check_Spindash

; =============== S U B R O U T I N E =======================================

Knux_TouchFloor:
                move.b  y_radius(a0),d0
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                btst    #Status_Roll,status(a0)
                beq.s   loc_17B6A
                bclr    #Status_Roll,status(a0)
                move.b  #0,anim(a0)
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_17B56
                neg.w   d0

loc_17B56:
                move.w  d0,-(sp)
                move.b  angle(a0),d0
                addi.b  #$40,d0
                bpl.s   loc_17B64
                neg.w   (sp)

loc_17B64:
                move.w  (sp)+,d0
                add.w   d0,y_pos(a0)

loc_17B6A:
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
                blo.s   locret_17BB4
                move.b  #0,anim(a0)

locret_17BB4:
                rts
; End of function Knux_TouchFloor

; ---------------------------------------------------------------------------

loc_17BB6:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_17BD0
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_17BD0
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_17BD0:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   loc_17BEA
                subi.w  #$20,y_vel(a0)

loc_17BEA:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_17BFA
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_17BFA:
                bsr.w   ResolveKnucklesHurtLandingOrDeathPlane
                bsr.w   Player_LevelBound
                bsr.w   Sonic_RecordPos
                bsr.w   AnimateKnucklesApplyGravityFlipAndQueuePatterns
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

ResolveKnucklesHurtLandingOrDeathPlane:
                tst.b   (Disable_death_plane).w
                bne.s   loc_17C3C
                tst.b   (Reverse_gravity_flag).w
                bne.s   loc_17C2E
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   loc_17C82
                bra.s   loc_17C3C
; ---------------------------------------------------------------------------

loc_17C2E:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   y_pos(a0),d0
                blt.s   loc_17C3C
                bra.w   loc_17C82
; ---------------------------------------------------------------------------

loc_17C3C:
                movem.l a4-a6,-(sp)
                bsr.w   SonicKnux_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   locret_17C80
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

locret_17C80:
                rts
; ---------------------------------------------------------------------------

loc_17C82:
                jmp     (Kill_Character).l
; End of function ResolveKnucklesHurtLandingOrDeathPlane

; ---------------------------------------------------------------------------

loc_17C88:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_17CA2
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_17CA2
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_17CA2:
                bsr.w   PlayerSKFinishDeathWithFollowerResetRestartOrCompetitionRespawn
                jsr     (MoveSprite_TestGravity).l
                bsr.w   Sonic_RecordPos
                bsr.w   AnimateKnucklesApplyGravityFlipAndQueuePatterns
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_17CBA:
                tst.w   $3E(a0)
                beq.s   locret_17CCC
                subq.w  #1,$3E(a0)
                bne.s   locret_17CCC
                move.w  #1,(Restart_level_flag).w

locret_17CCC:
                rts
; ---------------------------------------------------------------------------

loc_17CCE:
                tst.w   (H_scroll_amount).w
                bne.s   loc_17CE0
                tst.w   (V_scroll_amount).w
                bne.s   loc_17CE0
                move.b  #2,routine(a0)

loc_17CE0:
                bsr.w   AnimateKnucklesApplyGravityFlipAndQueuePatterns
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_17CEA:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_17D04
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_17D04
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_17D04:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   AnimateKnucklesApplyGravityFlipAndQueuePatterns
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

AnimateKnucklesApplyGravityFlipAndQueuePatterns:
                bsr.s   Animate_Knuckles
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_17D2C
                eori.b  #2,render_flags(a0)

loc_17D2C:
                bra.w   Knuckles_Load_PLC
; End of function AnimateKnucklesApplyGravityFlipAndQueuePatterns
