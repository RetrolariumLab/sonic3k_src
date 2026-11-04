; Owner: objects/zones/cnz/s3
; Responsibility: Carnival Night cylinder player capture, axial transport, release and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
S3CNZCylinder_SpringSpeedLimits:
                dc.w    $4E0
                dc.w    $6F0
                dc.w    $870
                dc.w    $9C0
                dc.w    $AE0
                dc.w    $C00
                dc.w    $CF0
                dc.w    $DE0
; ---------------------------------------------------------------------------

Obj_CNZCylinder:
                move.b  subtype(a0),d0
                move.b  d0,d1
                lsr.b   #3,d1
                andi.w  #$E,d1
                move.w  S3CNZCylinder_SpringSpeedLimits(pc,d1.w),d1
                move.w  d1,$3E(a0)
                add.w   d0,d0
                andi.w  #$1E,d0
                move.w  d0,$3A(a0)
                move.l  #Map_CNZCylinder,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$3D,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  x_pos(a0),$2E(a0)
                move.w  y_pos(a0),$30(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.b  #$F,d0
                subi.b  #$A,d0
                andi.b  #3,d0
                move.b  d0,$44(a0)
                andi.w  #$F0,d1
                lsl.w   #2,d1
                btst    #0,status(a0)
                beq.s   S3CNZCylinder_SetPhaseStepAndStart
                neg.w   d1

S3CNZCylinder_SetPhaseStepAndStart:
                move.w  d1,$46(a0)
                move.l  #S3CNZCylinder_UpdateMotionAndRiders,(a0)

S3CNZCylinder_UpdateMotionAndRiders:
                bsr.s   UpdateCnzCylinderMotion
                lea     $32(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.w   UpdatePlayerOnCnzCylinder
                addq.w  #4,a2
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.w   UpdatePlayerOnCnzCylinder
                move.w  #$2B,d1
                move.w  #$20,d2
                move.w  #$21,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3CNZCylinder_DrawFromBaseX
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

S3CNZCylinder_DrawFromBaseX:
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l

; =============== S U B R O U T I N E =======================================

UpdateCnzCylinderMotion:
                move.w  $3A(a0),d0
                move.w  S3CNZCylinder_MotionTable(pc,d0.w),d0
                jmp     S3CNZCylinder_MotionTable(pc,d0.w)
; End of function UpdateCnzCylinderMotion

; ---------------------------------------------------------------------------
S3CNZCylinder_MotionTable:
                dc.w    S3CNZCylinder_TrySpringOnNewContact-S3CNZCylinder_MotionTable
                dc.w    S3CNZCylinder_OscillateX32-S3CNZCylinder_MotionTable
                dc.w    S3CNZCylinder_OscillateX64-S3CNZCylinder_MotionTable
                dc.w    S3CNZCylinder_OscillateX96-S3CNZCylinder_MotionTable
                dc.w    S3CNZCylinder_OscillateX128-S3CNZCylinder_MotionTable
                dc.w    S3CNZCylinder_OscillateY32-S3CNZCylinder_MotionTable
                dc.w    S3CNZCylinder_OscillateY64-S3CNZCylinder_MotionTable
                dc.w    S3CNZCylinder_OscillateY96-S3CNZCylinder_MotionTable
                dc.w    S3CNZCylinder_OscillateY128-S3CNZCylinder_MotionTable
                dc.w    S3CNZCylinder_StepSquarePhase-S3CNZCylinder_MotionTable
                dc.w    S3CNZCylinder_StepSquarePhase-S3CNZCylinder_MotionTable
                dc.w    S3CNZCylinder_StepSquarePhase-S3CNZCylinder_MotionTable
                dc.w    S3CNZCylinder_StepSquarePhase-S3CNZCylinder_MotionTable
; ---------------------------------------------------------------------------

; Compare standing masks numerically to decide whether to apply an impulse
S3CNZCylinder_TrySpringOnNewContact:
                move.w  $3C(a0),d1
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                cmp.w   d1,d0
                beq.s   S3CNZCylinder_MoveSpringAndReadInput
                move.w  d0,$3C(a0)
                sub.w   d1,d0
                bcs.s   S3CNZCylinder_MoveSpringAndReadInput
                move.w  y_vel(a0),d0
                bpl.s   S3CNZCylinder_TryApplySpringImpulse
                neg.w   d0

S3CNZCylinder_TryApplySpringImpulse:
                cmpi.w  #$200,d0
                bhs.s   S3CNZCylinder_MoveSpringAndReadInput
                move.w  y_pos(a0),d0
                sub.w   $30(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$80,d0
                bhs.s   S3CNZCylinder_MoveSpringAndReadInput
                addi.w  #$400,y_vel(a0)
                move.w  $3E(a0),d0
                cmp.w   y_vel(a0),d0
                bgt.s   S3CNZCylinder_MoveSpringAndReadInput
                move.w  d0,y_vel(a0)

S3CNZCylinder_MoveSpringAndReadInput:
                jsr     (MoveSprite2).l
                moveq   #0,d5
                btst    #p1_standing_bit,status(a0)
                beq.s   S3CNZCylinder_MergeP2HeldInput
                move.b  (Ctrl_1_held_logical).w,d5

S3CNZCylinder_MergeP2HeldInput:
                btst    #p2_standing_bit,status(a0)
                beq.s   S3CNZCylinder_CheckSpringSide
                or.b    (Ctrl_2_held_logical).w,d5

S3CNZCylinder_CheckSpringSide:
                move.w  y_pos(a0),d0
                sub.w   $30(a0),d0
                beq.s   S3CNZCylinder_CheckSpeedAtBase
                bcc.s   S3CNZCylinder_AccelerateBelowBase
                move.w  $3E(a0),d0
                cmp.w   y_vel(a0),d0
                ble.s   CNZCylinderS3_ReturnFromSpringMotionMode
                addi.w  #$20,y_vel(a0)
                tst.w   y_vel(a0)
                bmi.s   S3CNZCylinder_BrakeAboveBase
                btst    #button_down,d5
                beq.s   S3CNZCylinder_AboveBaseReturn
                addi.w  #$20,y_vel(a0)
                bra.s   S3CNZCylinder_AboveBaseReturn
; ---------------------------------------------------------------------------

S3CNZCylinder_BrakeAboveBase:
                addi.w  #$10,y_vel(a0)

S3CNZCylinder_AboveBaseReturn:
                bra.s   CNZCylinderS3_ReturnFromSpringMotionMode
; ---------------------------------------------------------------------------

S3CNZCylinder_AccelerateBelowBase:
                move.w  $3E(a0),d0
                neg.w   d0
                cmp.w   y_vel(a0),d0
                bge.s   CNZCylinderS3_ReturnFromSpringMotionMode
                subi.w  #$20,y_vel(a0)
                tst.w   y_vel(a0)
                bpl.s   S3CNZCylinder_BrakeBelowBase
                btst    #button_up,d5
                beq.s   S3CNZCylinder_BelowBaseReturn
                subi.w  #$20,y_vel(a0)
                bra.s   S3CNZCylinder_BelowBaseReturn
; ---------------------------------------------------------------------------

S3CNZCylinder_BrakeBelowBase:
                subi.w  #$10,y_vel(a0)

S3CNZCylinder_BelowBaseReturn:
                bra.s   CNZCylinderS3_ReturnFromSpringMotionMode
; ---------------------------------------------------------------------------

S3CNZCylinder_CheckSpeedAtBase:
                move.w  y_vel(a0),d0
                bpl.s   S3CNZCylinder_TryStopSpringAtBase
                neg.w   d0

S3CNZCylinder_TryStopSpringAtBase:
                cmpi.w  #$80,d0
                bhs.s   CNZCylinderS3_ReturnFromSpringMotionMode
                move.w  #0,y_vel(a0)

CNZCylinderS3_ReturnFromSpringMotionMode:
                rts
; ---------------------------------------------------------------------------

S3CNZCylinder_OscillateX32:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #3,d0
                add.w   $2E(a0),d0
                move.w  d0,x_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZCylinder_OscillateX64:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                add.w   $2E(a0),d0
                move.w  d0,x_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZCylinder_OscillateX96:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                move.w  d0,d1
                asr.w   #1,d0
                add.w   d1,d0
                add.w   $2E(a0),d0
                move.w  d0,x_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZCylinder_OscillateX128:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #1,d0
                add.w   $2E(a0),d0
                move.w  d0,x_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZCylinder_OscillateY32:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #3,d0
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZCylinder_OscillateY64:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZCylinder_OscillateY96:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                move.w  d0,d1
                asr.w   #1,d0
                add.w   d1,d0
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZCylinder_OscillateY128:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #1,d0
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                move.w  $46(a0),d0
                add.w   d0,angle(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZCylinder_StepSquarePhase:
                move.w  $46(a0),d0
                bpl.s   S3CNZCylinder_StepForwardSquarePhase
                add.w   d0,angle(a0)
                move.b  angle(a0),d0
                cmpi.b  #$80,d0
                bhs.s   S3CNZCylinder_ClampReverseSquarePhase
                andi.b  #$7F,d0
                addi.b  #$80,d0
                move.b  d0,angle(a0)
                subq.b  #1,$44(a0)
                andi.b  #3,$44(a0)

S3CNZCylinder_ClampReverseSquarePhase:
                move.w  #$20,d2
                move.b  angle(a0),d0
                cmpi.b  #$80,d0
                bhs.s   S3CNZCylinder_ProjectSquareTop
                move.b  #$80,d0
                move.b  d0,angle(a0)
                bra.s   S3CNZCylinder_ProjectSquareTop
; ---------------------------------------------------------------------------

S3CNZCylinder_StepForwardSquarePhase:
                add.w   d0,angle(a0)
                move.b  angle(a0),d0
                cmpi.b  #$80,d0
                bhs.s   S3CNZCylinder_SetSquareHalfSize
                andi.b  #$7F,d0
                addi.b  #$80,d0
                move.b  d0,angle(a0)
                addq.b  #1,$44(a0)
                andi.b  #3,$44(a0)

S3CNZCylinder_SetSquareHalfSize:
                move.w  #$20,d2

S3CNZCylinder_ProjectSquareTop:
                jsr     (GetSineCosine).l
                asr.w   #3,d1
                move.b  $44(a0),d3
                andi.b  #3,d3
                bne.s   S3CNZCylinder_TryProjectSquareRight
                add.w   $2E(a0),d1
                move.w  d1,x_pos(a0)
                neg.w   d2
                add.w   $30(a0),d2
                move.w  d2,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZCylinder_TryProjectSquareRight:
                subq.b  #1,d3
                bne.s   S3CNZCylinder_TryProjectSquareBottom
                add.w   $30(a0),d1
                move.w  d1,y_pos(a0)
                add.w   $2E(a0),d2
                move.w  d2,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZCylinder_TryProjectSquareBottom:
                subq.b  #1,d3
                bne.s   CNZCylinderS3_ProjectSquareLeftEdge
                neg.w   d1
                add.w   $2E(a0),d1
                move.w  d1,x_pos(a0)
                add.w   $30(a0),d2
                move.w  d2,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

CNZCylinderS3_ProjectSquareLeftEdge:
                neg.w   d1
                add.w   $30(a0),d1
                move.w  d1,y_pos(a0)
                neg.w   d2
                add.w   $2E(a0),d2
                move.w  d2,x_pos(a0)
                rts

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnCnzCylinder:
                move.b  (a2),d0
                bne.s   S3CNZCylinder_OrbitOrReleaseRider
                btst    d6,status(a0)
                beq.s   S3CNZCylinder_EntryReturn
                move.b  #0,1(a2)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bpl.s   S3CNZCylinder_CaptureRiderAndSetTwist
                neg.w   d0
                move.b  #$80,1(a2)

S3CNZCylinder_CaptureRiderAndSetTwist:
                move.b  d0,2(a2)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #3,object_control(a1)
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                bclr    #Status_Roll,status(a1)
                bclr    #Status_InAir,status(a1)
                bclr    #Status_Push,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,jumping(a1)
                move.b  #0,anim(a1)
                move.b  #1,(a2)
                bra.w   S3CNZCylinder_LoadRiderTwistPhase
; ---------------------------------------------------------------------------

S3CNZCylinder_EntryReturn:
                rts
; ---------------------------------------------------------------------------

S3CNZCylinder_OrbitOrReleaseRider:
                tst.b   render_flags(a1)
                bpl.w   S3CNZCylinder_ReleaseControlAndPriority
                cmpi.b  #4,routine(a1)
                bhs.w   S3CNZCylinder_ReleaseControlAndPriority
                btst    d6,status(a0)
                beq.w   S3CNZCylinder_ClearRiderRecord
                moveq   #0,d0
                move.b  1(a2),d0
                jsr     (GetSineCosine).l
                addi.w  #$100,d0
                asr.w   #2,d0
                move.b  d0,3(a2)
                moveq   #0,d2
                move.w  2(a2),d2
                muls.w  d2,d1
                swap    d1
                add.w   x_pos(a0),d1
                move.w  d1,x_pos(a1)
                addq.b  #2,1(a2)
                move.w  #$100,priority(a1)
                move.b  $35(a0),d0
                cmp.b   3(a2),d0
                bls.s   S3CNZCylinder_CalcSpringSpeedForPose
                move.w  #$80,priority(a1)

S3CNZCylinder_CalcSpringSpeedForPose:
                move.w  #0,ground_vel(a1)
                move.w  y_vel(a0),d0
                bpl.s   S3CNZCylinder_TrySetFastRiderPose
                neg.w   d0

S3CNZCylinder_TrySetFastRiderPose:
                btst    #Status_InAir,status(a1)
                bne.s   S3CNZCylinder_TryJumpWithSpringSpeed
                cmpi.w  #$480,d0
                blo.s   S3CNZCylinder_TryJumpWithSpringSpeed
                move.w  #$800,ground_vel(a1)

S3CNZCylinder_TryJumpWithSpringSpeed:
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.s   S3CNZCylinder_LoadRiderTwistPhase
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.w  y_vel(a0),y_vel(a1)
                addi.w  #-$680,y_vel(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,ground_vel(a1)

S3CNZCylinder_ReleaseControlAndPriority:
                bset    #Status_InAir,status(a1)
                move.w  #$100,priority(a1)
                move.b  #0,object_control(a1)

S3CNZCylinder_ClearRiderRecord:
                move.b  #0,(a2)
                rts
; ---------------------------------------------------------------------------

S3CNZCylinder_LoadRiderTwistPhase:
                moveq   #0,d0
                move.b  1(a2),d0

S3CNZCylinder_ApplyTwistFrameAndTiles:                  ; Used by LBZ cup elevator
                addi.b  #$B,d0
                divu.w  #$16,d0
                move.b  PlayerTwistFrames(pc,d0.w),mapping_frame(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  PlayerTwistFlip(pc,d0.w),d0
                or.b    d0,render_flags(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; End of function UpdatePlayerOnCnzCylinder

; ---------------------------------------------------------------------------
PlayerTwistFrames:
                dc.b    $55, $59, $5A, $5B, $5A, $59, $55, $56, $57, $58, $57, $56
PlayerTwistFlip:
                dc.b    0,   1,   1,   0,   0,   0,   1,   1,   1,   0,   0,   0
                even
