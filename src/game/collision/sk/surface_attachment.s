; Owner: game/collision/sk
; Responsibility: Player floor-angle attachment and transitions along right walls, ceilings and left walls
; Source provenance and ranges: config/reconstruction/source_layout.json
Player_AnglePos:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   SKCollision_BypassTerrainAttachmentForObjectRider
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

SKCollision_BypassTerrainAttachmentForObjectRider:
                move.b  top_solid_bit(a0),d5
                btst    #Status_OnObj,status(a0)
                beq.s   SKCollision_SeedUnresolvedAnglesAndRoundAttachmentQuadrant
                moveq   #0,d0
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                rts
; ---------------------------------------------------------------------------

SKCollision_SeedUnresolvedAnglesAndRoundAttachmentQuadrant:
                moveq   #3,d0
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                move.b  angle(a0),d0
                addi.b  #$20,d0
                bpl.s   SKCollision_AdjustNegativeAngleInNonnegativeAttachmentBiasHalf
                move.b  angle(a0),d0
                bpl.s   SKCollision_CompleteNegativeHalfAttachmentQuadrantBias
                subq.b  #1,d0

SKCollision_CompleteNegativeHalfAttachmentQuadrantBias:
                addi.b  #$20,d0
                bra.s   SKCollision_DispatchAttachmentAxisAndProbeFloorCorners
; ---------------------------------------------------------------------------

SKCollision_AdjustNegativeAngleInNonnegativeAttachmentBiasHalf:
                move.b  angle(a0),d0
                bpl.s   SKCollision_AddLowerHalfAttachmentQuadrantBias
                addq.b  #1,d0

SKCollision_AddLowerHalfAttachmentQuadrantBias:
                addi.b  #$1F,d0

SKCollision_DispatchAttachmentAxisAndProbeFloorCorners:
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
                beq.s   SKCollision_ReturnFloorAttachmentWithoutFurtherCorrection
                bpl.s   SKCollision_TestFloorGapAgainstConvexOverrideAndHorizontalSpeedHighByte
                cmpi.w  #-$E,d1
                blt.s   SKCollision_ReturnFloorAttachmentWithoutFurtherCorrection
                add.w   d1,y_pos(a0)

SKCollision_ReturnFloorAttachmentWithoutFurtherCorrection:
                rts
; ---------------------------------------------------------------------------

SKCollision_TestFloorGapAgainstConvexOverrideAndHorizontalSpeedHighByte:
                tst.b   stick_to_convex(a0)
                bne.s   SKCollision_SnapFloorAttachmentByFullWordDistance
                move.b  x_vel(a0),d0
                bpl.s   SKCollision_ClampFloorAttachmentGapAllowanceFromByteSpeed
                neg.b   d0

SKCollision_ClampFloorAttachmentGapAllowanceFromByteSpeed:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   SKCollision_CompareFloorGapLowByteAgainstAllowance
                move.b  #$E,d0

SKCollision_CompareFloorGapLowByteAgainstAllowance:
                cmp.b   d0,d1
                bgt.s   SKCollision_DetachFromFloorAndRestartAnimation

SKCollision_SnapFloorAttachmentByFullWordDistance:
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKCollision_DetachFromFloorAndRestartAnimation:
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
                ble.s   SKCollision_AcceptSelectedSurfaceAngleOnlyWithinByteDeltaTwentyHex
                move.b  (Primary_Angle).w,d2
                move.w  d1,d3
                move.w  d0,d1

SKCollision_AcceptSelectedSurfaceAngleOnlyWithinByteDeltaTwentyHex:
                btst    #0,d2
                bne.s   SKCollision_QuantizeExistingAngleWhenSampleOddOrAbrupt
                move.b  d2,d0
                sub.b   angle(a0),d0
                bpl.s   SKCollision_ApplySurfaceAngleDeltaThresholdOrQuantize
                neg.b   d0

SKCollision_ApplySurfaceAngleDeltaThresholdOrQuantize:
                cmpi.b  #$20,d0
                bhs.s   SKCollision_QuantizeExistingAngleWhenSampleOddOrAbrupt
                move.b  d2,angle(a0)
                rts
; ---------------------------------------------------------------------------

SKCollision_QuantizeExistingAngleWhenSampleOddOrAbrupt:
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
                beq.s   SKCollision_ReturnRightWallAttachment
                bpl.s   SKCollision_TestRightWallGapAgainstConvexOrVerticalSpeedHighByte
                cmpi.w  #-$E,d1
                blt.s   SKCollision_ArmRightWallDeepOverlapRetryOnlyInZoneActZero
                tst.b   $41(a0)
                bne.s   SKCollision_CountDownRightWallDeepOverlapRetry
                add.w   d1,x_pos(a0)

SKCollision_ReturnRightWallAttachment:
                rts
; ---------------------------------------------------------------------------

SKCollision_CountDownRightWallDeepOverlapRetry:
                subq.b  #1,$41(a0)
                move.b  #$C0,angle(a0)
                rts
; ---------------------------------------------------------------------------

SKCollision_ArmRightWallDeepOverlapRetryOnlyInZoneActZero:
                tst.w   (Current_zone_and_act).w
                bne.s   SKCollision_ReturnRightWallAttachment
                move.b  #$C0,angle(a0)
                move.b  #3,$41(a0)
                rts
; ---------------------------------------------------------------------------

SKCollision_TestRightWallGapAgainstConvexOrVerticalSpeedHighByte:
                tst.b   stick_to_convex(a0)
                bne.s   SKCollision_SnapRightWallAttachmentByWordDistance
                move.b  y_vel(a0),d0
                bpl.s   SKCollision_ClampRightWallGapAllowanceByte
                neg.b   d0

SKCollision_ClampRightWallGapAllowanceByte:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   SKCollision_CompareRightWallGapLowByte
                move.b  #$E,d0

SKCollision_CompareRightWallGapLowByte:
                cmp.b   d0,d1
                bgt.s   SKCollision_DetachFromRightWallAndRestartAnimation

SKCollision_SnapRightWallAttachmentByWordDistance:
                add.w   d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKCollision_DetachFromRightWallAndRestartAnimation:
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
                beq.s   SKCollision_ReturnCeilingAttachment
                bpl.s   SKCollision_TestCeilingGapAgainstConvexOrHorizontalSpeedHighByte
                cmpi.w  #-$E,d1
                blt.s   SKCollision_ReturnCeilingAttachment
                sub.w   d1,y_pos(a0)

SKCollision_ReturnCeilingAttachment:
                rts
; ---------------------------------------------------------------------------

SKCollision_TestCeilingGapAgainstConvexOrHorizontalSpeedHighByte:
                tst.b   stick_to_convex(a0)
                bne.s   SKCollision_SnapCeilingAttachmentByWordDistance
                move.b  x_vel(a0),d0
                bpl.s   SKCollision_ClampCeilingGapAllowanceByte
                neg.b   d0

SKCollision_ClampCeilingGapAllowanceByte:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   SKCollision_CompareCeilingGapLowByte
                move.b  #$E,d0

SKCollision_CompareCeilingGapLowByte:
                cmp.b   d0,d1
                bgt.s   SKCollision_DetachFromCeilingAndRestartAnimation

SKCollision_SnapCeilingAttachmentByWordDistance:
                sub.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKCollision_DetachFromCeilingAndRestartAnimation:
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
                beq.s   SKCollision_ReturnLeftWallAttachment
                bpl.s   SKCollision_TestLeftWallGapAgainstConvexOrVerticalSpeedHighByte
                cmpi.w  #-$E,d1
                blt.s   SKCollision_ReturnLeftWallAttachment
                sub.w   d1,x_pos(a0)

SKCollision_ReturnLeftWallAttachment:
                rts
; ---------------------------------------------------------------------------

SKCollision_TestLeftWallGapAgainstConvexOrVerticalSpeedHighByte:
                tst.b   stick_to_convex(a0)
                bne.s   SKCollision_SnapLeftWallAttachmentByWordDistance
                move.b  y_vel(a0),d0
                bpl.s   SKCollision_ClampLeftWallGapAllowanceByte
                neg.b   d0

SKCollision_ClampLeftWallGapAllowanceByte:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   SKCollision_CompareLeftWallGapLowByte
                move.b  #$E,d0

SKCollision_CompareLeftWallGapLowByte:
                cmp.b   d0,d1
                bgt.s   SKCollision_DetachFromLeftWallAndRestartAnimation

SKCollision_SnapLeftWallAttachmentByWordDistance:
                sub.w   d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKCollision_DetachFromLeftWallAndRestartAnimation:
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)
                rts
