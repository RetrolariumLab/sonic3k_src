; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles ledge departure, gliding animation selection and horizontal glide motion helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Knuckles_Climb_Ledge:
                tst.b   anim_frame_timer(a0)
                bne.s   SKKnuxLedge_ClimbReturn

                bsr.w   Knuckles_DoLedgeClimbingAnimation

; Have we reached the end of the ledge-climbing animation?
                cmpi.b  #Knuckles_ClimbLedge_Frames_End-Knuckles_ClimbLedge_Frames,double_jump_property(a0)
                bne.s   SKKnuxLedge_ClimbReturn

; Yes
                move.w  #0,ground_vel(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)

                btst    #Status_Facing,status(a0)
                beq.s   +
                subq.w  #1,x_pos(a0)
                +:
                bsr.w   Knux_TouchFloor
                move.b  #5,anim(a0)

SKKnuxLedge_ClimbReturn:
                rts

; =============== S U B R O U T I N E =======================================

Knuckles_Set_Gliding_Animation:
                move.b  #$20,anim_frame_timer(a0)
                move.b  #0,anim_frame(a0)
                move.w  #($20<<8)|$20,anim(a0)          ; and prev_anim
                bclr    #Status_Push,status(a0)
                bclr    #Status_Facing,status(a0)

; Update Knuckles' frame, depending on where he's facing
                moveq   #0,d0
                move.b  double_jump_property(a0),d0
                addi.b  #$10,d0
                lsr.w   #5,d0
                move.b  RawAni_Knuckles_GlideTurn(pc,d0.w),d1
                move.b  d1,mapping_frame(a0)
                cmpi.b  #$C4,d1
                bne.s   +
                bset    #Status_Facing,status(a0)
                move.b  #$C0,mapping_frame(a0)

                +:
                rts
; End of function Knuckles_Set_Gliding_Animation

; ---------------------------------------------------------------------------
RawAni_Knuckles_GlideTurn:
                dc.b    $C0
                dc.b    $C1
                dc.b    $C2
                dc.b    $C3
                dc.b    $C4
                dc.b    $C3
                dc.b    $C2
                dc.b    $C1
                even

; =============== S U B R O U T I N E =======================================

Knuckles_Move_Glide:
                cmpi.b  #1,double_jump_flag(a0)
                bne.w   .doNotKillspeed

                move.w  ground_vel(a0),d0
                cmpi.w  #$400,d0
                bhs.s   .mediumSpeed

; .lowSpeed:
; Increase Knuckles' speed
                addq.w  #8,d0
                bra.s   .applySpeed
; ---------------------------------------------------------------------------
; loc_1700E:
                .mediumSpeed:
; If Knuckles is at his speed limit, then don't increase his speed
                cmpi.w  #$1800,d0
                bhs.s   .applySpeed

; If Knuckles is turning, then don't increase his speed either
                move.b  double_jump_property(a0),d1
                andi.b  #$7F,d1
                bne.s   .applySpeed

; Increase Knuckles' speed
                addq.w  #4,d0

; Super Knuckles and Hyper Knuckles glide faster
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   .applySpeed
                addq.w  #8,d0
; loc_17028:
                .applySpeed:
                move.w  d0,ground_vel(a0)

                move.b  double_jump_property(a0),d0
                btst    #button_left,(Ctrl_1_logical).w
                beq.s   .notHoldingLeft

; .holdingLeft:
; Playing is holding left
                cmpi.b  #$80,d0
                beq.s   .notHoldingLeft
                tst.b   d0
                bpl.s   .doNotNegate1
                neg.b   d0

                .doNotNegate1:
                addq.b  #2,d0
                bra.s   .setNewTurningValue
; ---------------------------------------------------------------------------
; loc_17048:
                .notHoldingLeft:
                btst    #button_right,(Ctrl_1_logical).w
                beq.s   .notHoldingRight

; .holdingRight:
; Playing is holding right
                tst.b   d0
                beq.s   .notHoldingRight
                bmi.s   .doNotNegate2
                neg.b   d0

                .doNotNegate2:
                addq.b  #2,d0
                bra.s   .setNewTurningValue
; ---------------------------------------------------------------------------
; loc_1705C:
                .notHoldingRight:
                move.b  d0,d1
                andi.b  #$7F,d1
                beq.s   .setNewTurningValue
                addq.b  #2,d0
; loc_17066:
                .setNewTurningValue:
                move.b  d0,double_jump_property(a0)

                move.b  double_jump_property(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)

; Is Knuckles is falling at a high speed, then create a parachute
; effect, where gliding makes Knuckles fall slower
                cmpi.w  #$80,y_vel(a0)
                blt.s   .fallingSlow
                subi.w  #$20,y_vel(a0)
                bra.s   .fallingFast
; ---------------------------------------------------------------------------
; loc_1708E:
                .fallingSlow:
; Apply gravity
                addi.w  #$20,y_vel(a0)
; loc_17094:
                .fallingFast:
; If Knuckles is above the level's top boundary, then kill his
; horizontal speed
                move.w  (Camera_min_Y_pos).w,d0
                cmpi.w  #-$100,d0
                beq.w   .doNotKillspeed

                addi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                ble.w   .doNotKillspeed

                asr.w   x_vel(a0)
                asr.w   ground_vel(a0)
; loc_170B4:
                .doNotKillspeed:
                cmpi.w  #$60,(a5)
                beq.s   .doNotModifyBias
                bhs.s   .goUp
                addq.w  #2*2,(a5)

                .goUp:
                subq.w  #2,(a5)
; locret_170C0:
                .doNotModifyBias:
                rts
; End of function Knuckles_Move_Glide

; ---------------------------------------------------------------------------

Knux_Spin_Path:
                tst.b   spin_dash_flag(a0)
                bne.s   SKKnuxRoll_RunGroundRoll
                bsr.w   Knux_Jump

SKKnuxRoll_RunGroundRoll:
                bsr.w   Player_RollRepel
                bsr.w   Knux_RollSpeed
                bsr.w   Player_LevelBound
                jsr     (MoveSprite_TestGravity2).l
                bsr.w   Call_Player_AnglePos
                bsr.w   Player_SlopeRepel
                tst.b   (Background_collision_flag).w
                beq.s   SKKnuxRoll_GroundRollReturn
                bsr.w   CheckPlayerBodyFloorClearance
                tst.w   d1
                bmi.w   Kill_Character
                movem.l a4-a6,-(sp)
                bsr.w   CheckLeftWallDist
                tst.w   d1
                bpl.s   SKKnuxRoll_CheckGroundRollRightWall
                sub.w   d1,x_pos(a0)

SKKnuxRoll_CheckGroundRollRightWall:
                bsr.w   CheckRightWallDist
                tst.w   d1
                bpl.s   SKKnuxRoll_RestoreRollWallRegisters
                add.w   d1,x_pos(a0)

SKKnuxRoll_RestoreRollWallRegisters:
                movem.l (sp)+,a4-a6

SKKnuxRoll_GroundRollReturn:
                rts
; ---------------------------------------------------------------------------

Knux_Spin_Freespace:
                bsr.w   Knux_JumpHeight
                bsr.w   Knux_ChgJumpDir
                bsr.w   Player_LevelBound
                jsr     (MoveSprite_TestGravity).l
                btst    #Status_Underwater,status(a0)
                beq.s   SKKnuxAir_BallAngleAndCollision
                subi.w  #$28,y_vel(a0)

SKKnuxAir_BallAngleAndCollision:
                bsr.w   Player_JumpAngle
                bsr.w   SonicKnux_DoLevelCollision
                rts
