; Owner: objects/players/knuckles/sk
; Responsibility: Complete Knuckles gliding, falling, sliding and wall-climbing state machine, ledge animation and wall-distance lookup
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Knux_Stand_Freespace:
                tst.b   double_jump_flag(a0)
                bne.s   Knux_Glide_Freespace
                bsr.w   Knux_JumpHeight
                bsr.w   Knux_ChgJumpDir
                bsr.w   Player_LevelBound
                jsr     (MoveSprite_TestGravity).l
                btst    #Status_Underwater,status(a0)
                beq.s   SKKnuxAir_AngleAndCollision
                subi.w  #$28,y_vel(a0)

SKKnuxAir_AngleAndCollision:
                bsr.w   Player_JumpAngle
                bsr.w   SonicKnux_DoLevelCollision
                rts
; ---------------------------------------------------------------------------

Knux_Glide_Freespace:
                bsr.w   Knuckles_Move_Glide
                bsr.w   Player_LevelBound
                jsr     (MoveSprite_TestGravity2).l
                bsr.w   Knuckles_Glide

SKKnuxGlide_UpdateReturn:
                rts

; =============== S U B R O U T I N E =======================================

Knuckles_Glide:
                move.b  double_jump_flag(a0),d0
                beq.s   SKKnuxGlide_UpdateReturn
                cmpi.b  #2,d0
                beq.w   Knuckles_Fall_From_Glide
                cmpi.b  #3,d0
                beq.w   Knuckles_Sliding
                cmpi.b  #4,d0
                beq.w   Knuckles_Wall_Climb
                cmpi.b  #5,d0
                beq.w   Knuckles_Climb_Ledge

; This function updates 'Gliding_collision_flags'
                bsr.w   Knux_DoLevelCollision_CheckRet

                btst    #Status_InAir,(Gliding_collision_flags).w
                beq.s   Knux_Gliding_HitFloor

                btst    #Status_Push,(Gliding_collision_flags).w
                bne.w   Knuckles_Gliding_HitWall

                move.b  (Ctrl_1_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   .continueGliding

; The player has let go of the jump button, so exit the gliding state
; and enter the falling state
                move.b  #2,double_jump_flag(a0)
                move.b  #$21,anim(a0)
                bclr    #Status_Facing,status(a0)
                tst.w   x_vel(a0)
                bpl.s   .skip1
                bset    #Status_Facing,status(a0)

                .skip1:
; Divide Knuckles' X velocity by 4
                asr.w   x_vel(a0)
                asr.w   x_vel(a0)

                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)

                rts
; ---------------------------------------------------------------------------
; loc_1690A:
                .continueGliding:
                bra.w   Knuckles_Set_Gliding_Animation
; ---------------------------------------------------------------------------

Knux_Gliding_HitFloor:
                bclr    #Status_Facing,status(a0)
                tst.w   x_vel(a0)
                bpl.s   +
                bset    #Status_Facing,status(a0)

                +:
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   SKKnuxGlide_BeginFlatSlide

                move.w  ground_vel(a0),x_vel(a0)
                move.w  #0,y_vel(a0)

                bra.w   Knux_TouchFloor
; ---------------------------------------------------------------------------

; Request slide dust only when at least 12 air units remain
SKKnuxGlide_BeginFlatSlide:
                move.b  #3,double_jump_flag(a0)
                move.b  #$CC,mapping_frame(a0)
                move.b  #$7F,anim_frame_timer(a0)
                move.b  #0,anim_frame(a0)

; The drowning countdown uses the dust clouds' VRAM, so don't create
; dust if Knuckles is drowning
                cmpi.b  #12,air_left(a0)
                blo.s   +
; Create dust clouds
                move.b  #6,routine(a6)
                move.b  #$15,mapping_frame(a6)

                +:
                rts
; ---------------------------------------------------------------------------

Knuckles_Gliding_HitWall:
                tst.b   (Disable_wall_grab).w
                bmi.w   .fail

                move.b  lrb_solid_bit(a0),d5
                move.b  double_jump_property(a0),d0
                addi.b  #$40,d0
                bpl.s   .right

; .left:
                bset    #Status_Facing,status(a0)

                bsr.w   CheckLeftCeilingDist
                or.w    d0,d1
                bne.s   .checkFloorLeft

                addq.w  #1,x_pos(a0)
                bra.s   .success

                .right:
                bclr    #Status_Facing,status(a0)

                bsr.w   CheckRightCeilingDist
                or.w    d0,d1
                bne.w   .checkFloorRight
; loc_169A6:
                .success:
                moveq   #signextendB(sfx_Grab),d0

; If Hyper Knuckles glides into a wall at a high-enough
; speed, then make the screen shake and harm all enemies
; on-screen
                tst.b   (Super_Sonic_Knux_flag).w
                bpl.s   .noQuake

                cmpi.w  #$480,ground_vel(a0)
                blo.s   .noQuake

                move.w  #$14,(Glide_screen_shake).w
                bsr.w   HyperAttackTouchResponse
                moveq   #signextendB(sfx_Thump),d0
; loc_169C2:
                .noQuake:
                jsr     (Play_SFX).l
                move.w  #0,ground_vel(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.b  #4,double_jump_flag(a0)
                move.b  #$B7,mapping_frame(a0)
                move.b  #$7F,anim_frame_timer(a0)
                move.b  #0,anim_frame(a0)
                move.b  #3,double_jump_property(a0)
; 'x_pos+2' holds the X coordinate that Knuckles was at when he first
; latched onto the wall
                move.w  x_pos(a0),x_pos+2(a0)
                rts
; ---------------------------------------------------------------------------
; loc_16A00:
                .checkFloorLeft:
; This adds the Y radius to the X coordinate
; This appears to be a bug, but, luckily, the X and Y radius are both
; 10, so this is harmless
                move.w  x_pos(a0),d3
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d3
                subq.w  #1,d3

                tst.b   (Reverse_gravity_flag).w
                bne.s   .reverseGravity
; loc_16A14:
                .checkFloorCommon:
                move.w  y_pos(a0),d2
                subi.w  #11,d2
                jsr     (ChkFloorEdge_Part3).l

                tst.w   d1
                bmi.s   .fail
                cmpi.w  #12,d1
                bhs.s   .fail
                add.w   d1,y_pos(a0)
                bra.w   .success
; ---------------------------------------------------------------------------
; loc_16A34:
                .reverseGravity:
                move.w  y_pos(a0),d2
                addi.w  #11,d2
                eori.w  #$F,d2
                jsr     (ChkFloorEdge_ReverseGravity_Part2).l

                tst.w   d1
                bmi.s   .fail
                cmpi.w  #12,d1
                bhs.s   .fail
                sub.w   d1,y_pos(a0)
                bra.w   .success
; ---------------------------------------------------------------------------
; loc_16A58:
                .checkFloorRight:
; This adds the Y radius to the X coordinate
; This appears to be a bug, but, luckily, the X and Y radius are both
; 10, so this is harmless
                move.w  x_pos(a0),d3
                move.b  y_radius(a0),d0
                ext.w   d0
                add.w   d0,d3
                addq.w  #1,d3

                tst.b   (Reverse_gravity_flag).w
                bne.s   Knuckles_Gliding_HitWall.reverseGravity

                bra.s   .checkFloorCommon
; ---------------------------------------------------------------------------
; loc_16A6E:
                .fail:
                move.b  #2,double_jump_flag(a0)
                move.b  #$21,anim(a0)
                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)
                bset    #Status_InAir,(Gliding_collision_flags).w
                rts
; ---------------------------------------------------------------------------

Knuckles_Fall_From_Glide:
                bsr.w   Knux_ChgJumpDir

; Apply gravity
                addi.w  #$38,y_vel(a0)

; Fall slower when underwater
                btst    #Status_Underwater,status(a0)
                beq.s   .skip1
                subi.w  #$28,y_vel(a0)

                .skip1:
; This function updates 'Gliding_collision_flags'
                bsr.w   Knux_DoLevelCollision_CheckRet

                btst    #Status_InAir,(Gliding_collision_flags).w
                bne.s   .return

; Knuckles has touched the ground
                move.w  #0,ground_vel(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)

                move.b  y_radius(a0),d0
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   .skip2
                neg.w   d0

                .skip2:
                add.w   d0,y_pos(a0)

                moveq   #signextendB(sfx_GlideLand),d0
                jsr     (Play_SFX).l

                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                beq.s   .skip3
                bra.w   Knux_TouchFloor

                .skip3:
                bsr.w   Knux_TouchFloor
                move.w  #$F,move_lock(a0)
                move.b  #$23,anim(a0)
; locret_16B04:
                .return:
                rts
; ---------------------------------------------------------------------------

Knuckles_Sliding:
                move.b  (Ctrl_1_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   .getUp

                tst.w   x_vel(a0)
                bpl.s   .goingRight

; .goingLeft:
                addi.w  #$20,x_vel(a0)
                bmi.s   .continueSliding2

                bra.s   .getUp
; ---------------------------------------------------------------------------
; loc_16B20:
                .continueSliding2:
                bra.s   .continueSliding
; ---------------------------------------------------------------------------
; loc_16B22:
                .goingRight:
                subi.w  #$20,x_vel(a0)
                bpl.s   .continueSliding
; loc_16B2A:
                .getUp:
                move.w  #0,ground_vel(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)

                move.b  y_radius(a0),d0
                sub.b   default_y_radius(a0),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   .skip1
                neg.w   d0

                .skip1:
                add.w   d0,y_pos(a0)

                bsr.w   Knux_TouchFloor

                move.w  #$F,move_lock(a0)
                move.b  #$22,anim(a0)

                rts
; ---------------------------------------------------------------------------
; loc_16B64:
                .continueSliding:
                bsr.w   Knux_DoLevelCollision_CheckRet

; Get distance from floor in 'd1', and angle of floor in 'd3'
                bsr.w   CheckSKPlayerGravityRelativeFloorAndNormalizeAngle

; If the distance from the floor is suddenly really high, then
; Knuckles must have slid off a ledge, so make him enter his falling
; state
                cmpi.w  #14,d1
                bge.s   .fail

                tst.b   (Reverse_gravity_flag).w
                beq.s   .skip2
                neg.w   d1

                .skip2:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)

; Play the sliding sound every 8 frames
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   .skip3

                moveq   #signextendB(sfx_GroundSlide),d0
                jsr     (Play_SFX).l
                .skip3:
                rts
; ---------------------------------------------------------------------------
; loc_16B96:
                .fail:
                move.b  #2,double_jump_flag(a0)
                move.b  #$21,anim(a0)

                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)

                bset    #Status_InAir,(Gliding_collision_flags).w
                rts
; ---------------------------------------------------------------------------

Knuckles_Wall_Climb:
                tst.b   (Disable_wall_grab).w
                bmi.w   Knuckles_LetGoOfWall

; If Knuckles' X coordinate is no longer the same as when he first
; latched onto the wall, then detach him from the wall. This is
; probably intended to detach Knuckles from the wall if something
; physically pushes him away from it
                move.w  x_pos(a0),d0
                cmp.w   x_pos+2(a0),d0
                bne.w   Knuckles_LetGoOfWall

; If an object is now carrying Knuckles, then detach him from the
; wall
                btst    #Status_OnObj,status(a0)
                bne.w   Knuckles_LetGoOfWall

                move.w  #0,ground_vel(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)

                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$D,lrb_solid_bit(a0)
                beq.s   +
                move.l  (Secondary_collision_addr).w,(Collision_addr).w
                +:
                move.b  lrb_solid_bit(a0),d5

                moveq   #0,d1                           ; Climbing animation delta: make the animation pause

                btst    #button_up,(Ctrl_1_logical).w
                beq.w   .notClimbingUp

; .climbingUp:
                tst.b   (Reverse_gravity_flag).w
                bne.w   .climbingUp_ReverseGravity

; Get Knuckles' distance from the wall in 'd1'
                move.w  y_pos(a0),d2
                subi.w  #11,d2
                bsr.w   GetDistanceFromWall

; If the wall is far away from Knuckles, then we must have reached a
; ledge, so make Knuckles climb up onto it
                cmpi.w  #4,d1
                bge.w   Knuckles_ClimbUp

; If Knuckles has encountered a small dip in the wall, then make him
; stop
                tst.w   d1
                bne.w   .notMoving

; Get Knuckles' distance from the ceiling in 'd1'
                move.b  lrb_solid_bit(a0),d5
                move.w  y_pos(a0),d2
                subq.w  #8,d2
                move.w  x_pos(a0),d3
                bsr.w   CheckCeilingDist_WithRadius

; Check if Knuckles has room above him
                tst.w   d1
                bpl.s   .moveUp

; Knuckles is bumping into the ceiling, so push him out
                sub.w   d1,y_pos(a0)

                moveq   #1,d1                           ; Climbing animation delta: make the animation play forwards
                bra.w   .finishMoving
; ---------------------------------------------------------------------------
; loc_16C4C:
                .moveUp:
                subq.w  #1,y_pos(a0)

; Super Knuckles and Hyper Knuckles climb walls faster
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   .notSuperOrHyper1
                subq.w  #1,y_pos(a0)

                .notSuperOrHyper1:
                moveq   #1,d1                           ; Climbing animation delta: make the animation play forwards

; Don't let Knuckles climb through the level's upper boundary
                move.w  (Camera_min_Y_pos).w,d0

; If the level wraps vertically, then don't bother with any of this
                cmpi.w  #-$100,d0
                beq.w   .finishMoving

; Check if Knuckles is over the level's top boundary
                addi.w  #16,d0
                cmp.w   y_pos(a0),d0
                ble.w   .finishMoving

; Knuckles is climbing over the level's top boundary: push him back
; down
                move.w  d0,y_pos(a0)
                bra.w   .finishMoving
; ---------------------------------------------------------------------------
; loc_16C7C:
                .climbingDown_ReverseGravity:
; Knuckles is climbing down

; ...I'm not sure what this code is for
                cmpi.b  #$BD,mapping_frame(a0)
                bne.s   .skip3
                move.b  #$B7,mapping_frame(a0)
                subq.w  #3,y_pos(a0)
                subq.w  #3,x_pos(a0)
                btst    #Status_Facing,status(a0)
                beq.s   .skip3
                addq.w  #3*2,x_pos(a0)

                .skip3:
; Get Knuckles' distance from the wall in 'd1'
                move.w  y_pos(a0),d2
                subi.w  #11,d2
                bsr.w   GetDistanceFromWall

; If Knuckles is no longer against the wall (he has climbed off the
; bottom of it) then make him let go
                tst.w   d1
                bne.w   Knuckles_LetGoOfWall

; Get Knuckles' distance from the floor in 'd1'
                move.b  top_solid_bit(a0),d5
                move.w  y_pos(a0),d2
                subi.w  #9,d2
                move.w  x_pos(a0),d3
                bsr.w   CheckCeilingDist_WithRadius

; Check if Knuckles has room below him
                tst.w   d1
                bpl.s   .moveDown_ReverseGravity

; Knuckles has reached the floor
                sub.w   d1,y_pos(a0)
                move.b  (Primary_Angle).w,d0
                addi.b  #$40,d0
                neg.b   d0
                subi.b  #$40,d0
                move.b  d0,angle(a0)

                move.w  #0,ground_vel(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)

                bsr.w   Knux_TouchFloor

                move.b  #5,anim(a0)

                rts
; ---------------------------------------------------------------------------
; loc_16CFC:
                .moveDown_ReverseGravity:
                subq.w  #1,y_pos(a0)

; Super Knuckles and Hyper Knuckles climb walls faster
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   .notSuperOrHyper2
                subq.w  #1,y_pos(a0)

                .notSuperOrHyper2:
                moveq   #-1,d1                          ; Climbing animation delta: make the animation play backwards
                bra.w   .finishMoving
; ---------------------------------------------------------------------------
; loc_16D10:
                .notClimbingUp:
                btst    #button_down,(Ctrl_1_logical).w
                beq.w   .finishMoving

; .climbingDown:
                tst.b   (Reverse_gravity_flag).w
                bne.w   .climbingDown_ReverseGravity

; ...I'm not sure what this code is for
                cmpi.b  #$BD,mapping_frame(a0)
                bne.s   .skip4
                move.b  #$B7,mapping_frame(a0)
                addq.w  #3,y_pos(a0)
                subq.w  #3,x_pos(a0)
                btst    #Status_Facing,status(a0)
                beq.s   .skip4
                addq.w  #3*2,x_pos(a0)

                .skip4:
; Get Knuckles' distance from the wall in 'd1'
                move.w  y_pos(a0),d2
                addi.w  #11,d2
                bsr.w   GetDistanceFromWall

; If Knuckles is no longer against the wall (he has climbed off the
; bottom of it) then make him let go
                tst.w   d1
                bne.w   Knuckles_LetGoOfWall

; Get Knuckles' distance from the floor in 'd1'
                move.b  top_solid_bit(a0),d5
                move.w  y_pos(a0),d2
                addi.w  #9,d2
                move.w  x_pos(a0),d3
                bsr.w   ProbeFloorWithXRadiusOffset

; Check if Knuckles has room below him
                tst.w   d1
                bpl.s   .moveDown
; loc_16D6E:
                .reachedFloor:
; Knuckles has reached the floor
                add.w   d1,y_pos(a0)
                move.b  (Primary_Angle).w,angle(a0)

                move.w  #0,ground_vel(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)

                bsr.w   Knux_TouchFloor

                move.b  #5,anim(a0)

                rts
; ---------------------------------------------------------------------------
; loc_16D96:
                .moveDown:
                addq.w  #1,y_pos(a0)

; Super Knuckles and Hyper Knuckles climb walls faster
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   .notSuperOrHyper3
                addq.w  #1,y_pos(a0)

                .notSuperOrHyper3:
                moveq   #-1,d1                          ; Climbing animation delta: make the animation play backwards
                bra.s   .finishMoving
; ---------------------------------------------------------------------------
; loc_16DA8:
                .climbingUp_ReverseGravity:
; Get Knuckles' distance from the wall in 'd1'
                move.w  y_pos(a0),d2
                addi.w  #11,d2
                bsr.w   GetDistanceFromWall

; If the wall is far away from Knuckles, then we must have reached a
; ledge, so make Knuckles climb up onto it
                cmpi.w  #4,d1
                bge.w   Knuckles_ClimbUp

; If Knuckles has encountered a small dip in the wall, then make him
; stop
                tst.w   d1
                bne.w   .notMoving

; Get Knuckles' distance from the ceiling in 'd1'
                move.b  lrb_solid_bit(a0),d5
                move.w  y_pos(a0),d2
                addq.w  #8,d2
                move.w  x_pos(a0),d3
                bsr.w   ProbeFloorWithXRadiusOffset

; Check if Knuckles has room above him
                tst.w   d1
                bpl.s   .moveUp_ReverseGravity

; Knuckles is bumping into the ceiling, so push him out
                add.w   d1,y_pos(a0)

                moveq   #1,d1                           ; Climbing animation delta: make the animation play forwards
                bra.w   .finishMoving
; ---------------------------------------------------------------------------
; loc_16DE2:
                .moveUp_ReverseGravity:
                addq.w  #1,y_pos(a0)

; Super Knuckles and Hyper Knuckles climb walls faster
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   .notSuperOrHyper4
                addq.w  #1,y_pos(a0)

                .notSuperOrHyper4:
                moveq   #1,d1                           ; Climbing animation delta: make the animation play forwards

; Don't let Knuckles climb through the level's upper boundary

; If the level wraps vertically, then don't bother with any of this
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                beq.w   .finishMoving

; Check if Knuckles is over the level's top boundary
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$D0,d0
                cmp.w   y_pos(a0),d0
                bge.w   .finishMoving

; Knuckles is climbing over the level's top boundary: push him back
; down
                move.w  d0,y_pos(a0)
; loc_16E10:
                .finishMoving:
; This block of code was not here in KiS2
; This code detaches Knuckles from the wall if there is
; ground directly below him. Note that this code specifically
; does not run if the player is holding up or down: this is
; because similar code already runs if either of those
; buttons are being held. Presumably, this check was added so
; that Knuckles would properly detach from the wall if a
; rising floor (think Marble Garden Zone Act 2) came up from
; under him. With that said, KiS2 lacks this logic, and yet
; Knuckles seems to detach from the wall in Hill Top Zone's
; rising wall section just fine, so I'm not sure whether this
; code was ever actually needed in the first place
                move.b  (Ctrl_1_held_logical).w,d0
                andi.b  #button_up_mask|button_down_mask,d0
                bne.s   .isMovingUpOrDown

; Get Knuckles' distance from the floor in 'd1'
                move.b  top_solid_bit(a0),d5
                move.w  y_pos(a0),d2
                addi.w  #9,d2
                move.w  x_pos(a0),d3
                bsr.w   ProbeFloorWithXRadiusOffset

; Bug: 'd1' has been overwritten by 'ProbeFloorWithXRadiusOffset', but the code
; after this needs it for updating Knuckles' animation. This
; bug is the reason why Knuckles resets to his first climbing
; frame when the player is not holding up or down

; Check if Knuckles has room below him
                tst.w   d1
                bmi.w   .reachedFloor

                .isMovingUpOrDown:
; If Knuckles has not moved, skip this
                tst.w   d1
                beq.s   .notMoving

; Only animate every 4 frames
                subq.b  #1,double_jump_property(a0)
                bpl.s   .notMoving
                move.b  #3,double_jump_property(a0)

; Add delta to animation frame
                add.b   mapping_frame(a0),d1

; Make the animation loop
                cmpi.b  #$B7,d1
                bhs.s   .noLoop1
                move.b  #$BC,d1

                .noLoop1:
                cmpi.b  #$BC,d1
                bls.s   .noLoop2
                move.b  #$B7,d1

                .noLoop2:
; Apply the frame
                move.b  d1,mapping_frame(a0)
; loc_16E60:
                .notMoving:
                move.b  #$20,anim_frame_timer(a0)
                move.b  #0,anim_frame(a0)

                move.w  (Ctrl_1_logical).w,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   .hasNotJumped

; Knuckles has jumped off the wall
                move.w  #-$380,y_vel(a0)
                move.w  #$400,x_vel(a0)

                bchg    #Status_Facing,status(a0)
                bne.s   .goingRight
                neg.w   x_vel(a0)

                .goingRight:
                bset    #Status_InAir,status(a0)
                move.b  #1,jumping(a0)

                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)

                move.b  #2,anim(a0)
                bset    #Status_Roll,status(a0)
                move.b  #0,double_jump_flag(a0)
; locret_16EB8:
                .hasNotJumped:
                rts
; ---------------------------------------------------------------------------
; loc_16EBA:
Knuckles_ClimbUp:
                move.b  #5,double_jump_flag(a0)

                cmpi.b  #$BD,mapping_frame(a0)
                beq.s   +

                move.b  #0,double_jump_property(a0)
                bsr.s   Knuckles_DoLedgeClimbingAnimation
                +:
                rts
; ---------------------------------------------------------------------------
; loc_16ED2:
Knuckles_LetGoOfWall:
                move.b  #2,double_jump_flag(a0)

                move.w  #($21<<8)|$21,anim(a0)          ; and prev_anim
                move.b  #$CB,mapping_frame(a0)
                move.b  #7,anim_frame_timer(a0)
                move.b  #1,anim_frame(a0)

                move.b  default_y_radius(a0),y_radius(a0)
                move.b  default_x_radius(a0),x_radius(a0)

                rts
; End of function Knuckles_Glide

; =============== S U B R O U T I N E =======================================

; sub_16EFE:
Knuckles_DoLedgeClimbingAnimation:
                moveq   #0,d0
                move.b  double_jump_property(a0),d0
                lea     Knuckles_ClimbLedge_Frames(pc,d0.w),a1

                move.b  (a1)+,mapping_frame(a0)

                move.b  (a1)+,d0
                ext.w   d0
                btst    #Status_Facing,status(a0)
                beq.s   +
                neg.w   d0

                +:
                add.w   d0,x_pos(a0)

                move.b  (a1)+,d1
                ext.w   d1
                tst.b   (Reverse_gravity_flag).w
                beq.s   +
                neg.w   d1

                +:
                add.w   d1,y_pos(a0)

                move.b  (a1)+,anim_frame_timer(a0)

                addq.b  #4,double_jump_property(a0)
                move.b  #0,anim_frame(a0)
                rts
; End of function Knuckles_DoLedgeClimbingAnimation

; ---------------------------------------------------------------------------
; Strangely, the last frame uses frame $D2. It will never be seen, however,
; because it is immediately overwritten by Knuckles' waiting animation

Knuckles_ClimbLedge_Frames:
; mapping_frame, x_pos, y_pos, anim_frame_timer
                dc.b    $BD,    3,   -3,    6
                dc.b    $BE,    8,  -10,    6
                dc.b    $BF,   -8,  -12,    6
                dc.b    $D2,    8,   -5,    6
Knuckles_ClimbLedge_Frames_End:

; =============== S U B R O U T I N E =======================================

; sub_16F4E:
GetDistanceFromWall:
                move.b  lrb_solid_bit(a0),d5
                btst    #Status_Facing,status(a0)
                bne.s   .facingLeft

; .facingRight:
                move.w  x_pos(a0),d3
                bra.w   SKClearance_RightAtXRadius
; ---------------------------------------------------------------------------
; loc_16F62:
                .facingLeft:
                move.w  x_pos(a0),d3
                subq.w  #1,d3
                bra.w   SKClearance_LeftAtXRadius
; End of function GetDistanceFromWall
