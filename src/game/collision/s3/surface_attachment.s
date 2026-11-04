; Owner: game/collision/s3
; Responsibility: Player floor-angle attachment and transitions along right walls, ceilings and left walls
; Source provenance and ranges: config/reconstruction/source_layout.json
Player_AnglePos:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   S3Collision_ChooseObjectStandingOrTerrainAngleAttachment
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

S3Collision_ChooseObjectStandingOrTerrainAngleAttachment:
                move.b  top_solid_bit(a0),d5
                btst    #Status_OnObj,status(a0)
                beq.s   S3Collision_SeedUnknownAnglesAndRoundAttachmentQuadrant
                moveq   #0,d0
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                rts
; ---------------------------------------------------------------------------

S3Collision_SeedUnknownAnglesAndRoundAttachmentQuadrant:
                moveq   #3,d0
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                move.b  angle(a0),d0
                addi.b  #$20,d0
                bpl.s   S3Collision_AdjustOppositeAttachmentAngleBoundary
                move.b  angle(a0),d0
                bpl.s   S3Collision_ApplyTwentyBiasForAttachmentBoundary
                subq.b  #1,d0

S3Collision_ApplyTwentyBiasForAttachmentBoundary:
                addi.b  #$20,d0
                bra.s   S3Collision_DispatchAttachmentAxisOrProbeBothFeet
; ---------------------------------------------------------------------------

S3Collision_AdjustOppositeAttachmentAngleBoundary:
                move.b  angle(a0),d0
                bpl.s   S3Collision_ApplyOneLessThanQuadrantAttachmentBias
                addq.b  #1,d0

S3Collision_ApplyOneLessThanQuadrantAttachmentBias:
                addi.b  #$1F,d0

S3Collision_DispatchAttachmentAxisOrProbeBothFeet:
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   Player_WalkVertL
                cmpi.b  #$80,d0
                beq.w   Player_WalkCeiling
                cmpi.b  #$C0,d0
                beq.w   Player_WalkVertR
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  y_radius(a0),d0
                ext.w   d0
                add.w   d0,d2
                move.b  x_radius(a0),d0
                ext.w   d0
                add.w   d0,d3
                lea     (Primary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindFloor
                move.w  d1,-(sp)
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  y_radius(a0),d0
                ext.w   d0
                add.w   d0,d2
                move.b  x_radius(a0),d0
                ext.w   d0
                neg.w   d0
                add.w   d0,d3
                lea     (Secondary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindFloor
                move.w  (sp)+,d0
                bsr.w   Player_Angle
                tst.w   d1
                beq.s   S3Collision_ReturnWithoutFurtherFloorAttachmentCorrection
                bpl.s   S3Collision_GatePositiveFloorGapByConvexOrXSpeedByte
                cmpi.w  #-$E,d1
                blt.s   S3Collision_ReturnWithoutFurtherFloorAttachmentCorrection
                add.w   d1,y_pos(a0)

S3Collision_ReturnWithoutFurtherFloorAttachmentCorrection:
                rts
; ---------------------------------------------------------------------------

S3Collision_GatePositiveFloorGapByConvexOrXSpeedByte:
                tst.b   stick_to_convex(a0)
                bne.s   S3Collision_ApplyPositiveFloorAttachmentGap
                move.b  x_vel(a0),d0
                bpl.s   S3Collision_ComputeFloorGapAllowanceFromXVelocityHighByte
                neg.b   d0

S3Collision_ComputeFloorGapAllowanceFromXVelocityHighByte:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   S3Collision_CompareFloorGapLowByteAgainstAllowance
                move.b  #$E,d0

S3Collision_CompareFloorGapLowByteAgainstAllowance:
                cmp.b   d0,d1
                bgt.s   S3Collision_DetachPlayerFromFloorAttachment

S3Collision_ApplyPositiveFloorAttachmentGap:
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3Collision_DetachPlayerFromFloorAttachment:
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)
                rts
; End of function Player_AnglePos

; =============== S U B R O U T I N E =======================================

Player_Angle:
                move.w  d0,d3
                move.b  (Secondary_Angle).w,d2
                cmp.w   d0,d1
                ble.s   S3Collision_ValidateSelectedTerrainAngleAgainstCurrentAngle
                move.b  (Primary_Angle).w,d2
                move.w  d1,d3
                move.w  d0,d1

S3Collision_ValidateSelectedTerrainAngleAgainstCurrentAngle:
                btst    #0,d2
                bne.s   S3Collision_QuantizeCurrentAngleAfterInvalidTerrainAngle
                move.b  d2,d0
                sub.b   angle(a0),d0
                bpl.s   S3Collision_AcceptSmallTerrainAngleDifferenceOrQuantize
                neg.b   d0

S3Collision_AcceptSmallTerrainAngleDifferenceOrQuantize:
                cmpi.b  #$20,d0
                bhs.s   S3Collision_QuantizeCurrentAngleAfterInvalidTerrainAngle
                move.b  d2,angle(a0)
                rts
; ---------------------------------------------------------------------------

S3Collision_QuantizeCurrentAngleAfterInvalidTerrainAngle:
                move.b  angle(a0),d2
                addi.b  #$20,d2
                andi.b  #$C0,d2
                move.b  d2,angle(a0)
                rts
; End of function Player_Angle

; ---------------------------------------------------------------------------

Player_WalkVertR:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  x_radius(a0),d0
                ext.w   d0
                neg.w   d0
                add.w   d0,d2
                move.b  y_radius(a0),d0
                ext.w   d0
                add.w   d0,d3
                lea     (Primary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindWall
                move.w  d1,-(sp)
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  x_radius(a0),d0
                ext.w   d0
                add.w   d0,d2
                move.b  y_radius(a0),d0
                ext.w   d0
                add.w   d0,d3
                lea     (Secondary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindWall
                move.w  (sp)+,d0
                bsr.w   Player_Angle
                tst.w   d1
                beq.s   S3Collision_ReturnRightWallAttachmentWithoutFurtherCorrection
                bpl.s   S3Collision_GatePositiveRightWallGapByConvexOrYSpeedByte
                cmpi.w  #-$E,d1
                blt.s   S3Collision_ArmRightWallAngleHoldOnlyInFirstAct
                tst.b   $41(a0)
                bne.s   S3Collision_ConsumeRightWallSpecialAngleHoldByte
                add.w   d1,x_pos(a0)

S3Collision_ReturnRightWallAttachmentWithoutFurtherCorrection:
                rts
; ---------------------------------------------------------------------------

S3Collision_ConsumeRightWallSpecialAngleHoldByte:
                subq.b  #1,$41(a0)
                move.b  #$C0,angle(a0)
                rts
; ---------------------------------------------------------------------------

S3Collision_ArmRightWallAngleHoldOnlyInFirstAct:
                tst.w   (Current_zone_and_act).w
                bne.s   S3Collision_ReturnRightWallAttachmentWithoutFurtherCorrection
                move.b  #$C0,angle(a0)
                move.b  #3,$41(a0)
                rts
; ---------------------------------------------------------------------------

S3Collision_GatePositiveRightWallGapByConvexOrYSpeedByte:
                tst.b   stick_to_convex(a0)
                bne.s   S3Collision_ApplyPositiveRightWallAttachmentGap
                move.b  y_vel(a0),d0
                bpl.s   S3Collision_ComputeRightWallGapAllowanceFromYVelocityHighByte
                neg.b   d0

S3Collision_ComputeRightWallGapAllowanceFromYVelocityHighByte:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   S3Collision_CompareRightWallGapLowByteAgainstAllowance
                move.b  #$E,d0

S3Collision_CompareRightWallGapLowByteAgainstAllowance:
                cmp.b   d0,d1
                bgt.s   S3Collision_DetachPlayerFromRightWallAttachment

S3Collision_ApplyPositiveRightWallAttachmentGap:
                add.w   d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3Collision_DetachPlayerFromRightWallAttachment:
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)
                rts
; ---------------------------------------------------------------------------

Player_WalkCeiling:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d2
                eori.w  #$F,d2
                move.b  x_radius(a0),d0
                ext.w   d0
                add.w   d0,d3
                lea     (Primary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$800,d6
                bsr.w   FindFloor
                move.w  d1,-(sp)
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d2
                eori.w  #$F,d2
                move.b  x_radius(a0),d0
                ext.w   d0
                sub.w   d0,d3
                lea     (Secondary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$800,d6
                bsr.w   FindFloor
                move.w  (sp)+,d0
                bsr.w   Player_Angle
                tst.w   d1
                beq.s   S3Collision_ReturnCeilingAttachmentWithoutFurtherCorrection
                bpl.s   S3Collision_GatePositiveCeilingGapByConvexOrXSpeedByte
                cmpi.w  #-$E,d1
                blt.s   S3Collision_ReturnCeilingAttachmentWithoutFurtherCorrection
                sub.w   d1,y_pos(a0)

S3Collision_ReturnCeilingAttachmentWithoutFurtherCorrection:
                rts
; ---------------------------------------------------------------------------

S3Collision_GatePositiveCeilingGapByConvexOrXSpeedByte:
                tst.b   stick_to_convex(a0)
                bne.s   S3Collision_ApplyPositiveCeilingAttachmentGap
                move.b  x_vel(a0),d0
                bpl.s   S3Collision_ComputeCeilingGapAllowanceFromXVelocityHighByte
                neg.b   d0

S3Collision_ComputeCeilingGapAllowanceFromXVelocityHighByte:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   S3Collision_CompareCeilingGapLowByteAgainstAllowance
                move.b  #$E,d0

S3Collision_CompareCeilingGapLowByteAgainstAllowance:
                cmp.b   d0,d1
                bgt.s   S3Collision_DetachPlayerFromCeilingAttachment

S3Collision_ApplyPositiveCeilingAttachmentGap:
                sub.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3Collision_DetachPlayerFromCeilingAttachment:
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)
                rts
; ---------------------------------------------------------------------------

Player_WalkVertL:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  x_radius(a0),d0
                ext.w   d0
                sub.w   d0,d2
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d3
                eori.w  #$F,d3
                lea     (Primary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$400,d6
                bsr.w   FindWall
                move.w  d1,-(sp)
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  x_radius(a0),d0
                ext.w   d0
                add.w   d0,d2
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d3
                eori.w  #$F,d3
                lea     (Secondary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$400,d6
                bsr.w   FindWall
                move.w  (sp)+,d0
                bsr.w   Player_Angle
                tst.w   d1
                beq.s   S3Collision_ReturnLeftWallAttachmentWithoutFurtherCorrection
                bpl.s   S3Collision_GatePositiveLeftWallGapByConvexOrYSpeedByte
                cmpi.w  #-$E,d1
                blt.s   S3Collision_ReturnLeftWallAttachmentWithoutFurtherCorrection
                sub.w   d1,x_pos(a0)

S3Collision_ReturnLeftWallAttachmentWithoutFurtherCorrection:
                rts
; ---------------------------------------------------------------------------

S3Collision_GatePositiveLeftWallGapByConvexOrYSpeedByte:
                tst.b   stick_to_convex(a0)
                bne.s   S3Collision_ApplyPositiveLeftWallAttachmentGap
                move.b  y_vel(a0),d0
                bpl.s   S3Collision_ComputeLeftWallGapAllowanceFromYVelocityHighByte
                neg.b   d0

S3Collision_ComputeLeftWallGapAllowanceFromYVelocityHighByte:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   S3Collision_CompareLeftWallGapLowByteAgainstAllowance
                move.b  #$E,d0

S3Collision_CompareLeftWallGapLowByteAgainstAllowance:
                cmp.b   d0,d1
                bgt.s   S3Collision_DetachPlayerFromLeftWallAttachment

S3Collision_ApplyPositiveLeftWallAttachmentGap:
                sub.w   d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3Collision_DetachPlayerFromLeftWallAttachment:
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)
                rts
