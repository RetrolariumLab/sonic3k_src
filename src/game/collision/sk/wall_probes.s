; Owner: game/collision/sk
; Responsibility: Wall height sampling and direction-dependent collision angle conversion
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

FindWall:
                lea     (Find_Tile_FG).l,a5
                tst.b   (Background_collision_flag).w
                beq.s   SampleWallDistanceWithNeighbor
                bsr.s   SampleWallDistanceWithNeighbor
                move.b  (a4),Primary_Angle_save-Primary_Angle(a4)
                move.w  d1,-(sp)
                move.w  a3,d0
                bpl.s   SKCollision_ShiftPositiveDirectionWallSampleIntoBackgroundX
                eori.w  #$F,d3
                sub.w   (Camera_X_diff).w,d3
                eori.w  #$F,d3
                bra.s   SKCollision_ProbeBackgroundWallAfterDirectionAwareXShift
; ---------------------------------------------------------------------------

SKCollision_ShiftPositiveDirectionWallSampleIntoBackgroundX:
                sub.w   (Camera_X_diff).w,d3

SKCollision_ProbeBackgroundWallAfterDirectionAwareXShift:
                sub.w   (Camera_Y_diff).w,d2
                lea     (Find_Tile_BG).l,a5
                bsr.s   SampleWallDistanceWithNeighbor
                move.w  a3,d0
                bpl.s   SKCollision_RestorePositiveDirectionWallSampleX
                eori.w  #$F,d3
                add.w   (Camera_X_diff).w,d3
                eori.w  #$F,d3
                bra.s   SKCollision_RestoreWallYAndSelectNearerLayer
; ---------------------------------------------------------------------------

SKCollision_RestorePositiveDirectionWallSampleX:
                add.w   (Camera_X_diff).w,d3

SKCollision_RestoreWallYAndSelectNearerLayer:
                add.w   (Camera_Y_diff).w,d2
                move.w  (sp)+,d0
                cmp.w   d0,d1
                ble.s   SKCollision_ReturnForegroundOrSelectedBackgroundWallDistance
                move.b  Primary_Angle_save-Primary_Angle(a4),(a4)
                move.w  d0,d1

SKCollision_ReturnForegroundOrSelectedBackgroundWallDistance:
                rts
; End of function FindWall

; =============== S U B R O U T I N E =======================================

SampleWallDistanceWithNeighbor:
                jsr     (a5)
                move.w  (a1),d0
                move.w  d0,d4
                andi.w  #$3FF,d0
                beq.s   SKCollision_SampleForwardNeighborForEmptyWallBlock
                btst    d5,d4
                bne.s   SKCollision_ReadWallCollisionByteAndVerticalFlipOfSample

SKCollision_SampleForwardNeighborForEmptyWallBlock:
                add.w   a3,d3
                bsr.w   SampleSingleBlockWallDistance
                sub.w   a3,d3
                addi.w  #$10,d1
                rts
; ---------------------------------------------------------------------------

SKCollision_ReadWallCollisionByteAndVerticalFlipOfSample:
                movea.l (Collision_addr).w,a2
                add.w   d0,d0
                move.b  (a2,d0.w),d0
                andi.w  #$FF,d0
                beq.s   SKCollision_SampleForwardNeighborForEmptyWallBlock
                lea     (AngleArray).l,a2
                move.b  (a2,d0.w),(a4)
                lsl.w   #4,d0
                move.w  d2,d1
                btst    #$B,d4
                beq.s   SKCollision_TransformWallAngleForHorizontalFlip
                not.w   d1
                addi.b  #$40,(a4)
                neg.b   (a4)
                subi.b  #$40,(a4)

SKCollision_TransformWallAngleForHorizontalFlip:
                btst    #$A,d4
                beq.s   SKCollision_ReadSignedRotatedHeightAndEffectiveHorizontalFlip
                neg.b   (a4)

SKCollision_ReadSignedRotatedHeightAndEffectiveHorizontalFlip:
                andi.w  #$F,d1
                add.w   d0,d1
                lea     (HeightMapsRot).l,a2
                move.b  (a2,d1.w),d0
                ext.w   d0
                eor.w   d6,d4
                btst    #$A,d4
                beq.s   SKCollision_ClassifyWallHeightAndPartialColumnDistance
                neg.w   d0

SKCollision_ClassifyWallHeightAndPartialColumnDistance:
                tst.w   d0
                beq.s   SKCollision_SampleForwardNeighborForEmptyWallBlock
                bmi.s   SKCollision_TestNegativeWallColumnAgainstWithinBlockX
                cmpi.b  #$10,d0
                beq.s   SKCollision_SampleBackwardNeighborForFullWallColumn
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                move.w  #$F,d1
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

SKCollision_TestNegativeWallColumnAgainstWithinBlockX:
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                bpl.w   SKCollision_SampleForwardNeighborForEmptyWallBlock

SKCollision_SampleBackwardNeighborForFullWallColumn:
                sub.w   a3,d3
                bsr.w   SampleSingleBlockWallDistance
                add.w   a3,d3
                subi.w  #$10,d1
                rts
; End of function SampleWallDistanceWithNeighbor

; =============== S U B R O U T I N E =======================================

SampleSingleBlockWallDistance:
                jsr     (a5)
                move.w  (a1),d0
                move.w  d0,d4
                andi.w  #$3FF,d0
                beq.s   SKCollision_ReturnEmptySingleWallBlockDistance
                btst    d5,d4
                bne.s   SKCollision_ReadSingleWallIndexAndVerticalFlip

SKCollision_ReturnEmptySingleWallBlockDistance:
                move.w  #$F,d1
                move.w  d3,d0
                andi.w  #$F,d0
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

SKCollision_ReadSingleWallIndexAndVerticalFlip:
                movea.l (Collision_addr).w,a2
                add.w   d0,d0
                move.b  (a2,d0.w),d0
                andi.w  #$FF,d0
                beq.s   SKCollision_ReturnEmptySingleWallBlockDistance
                lea     (AngleArray).l,a2
                move.b  (a2,d0.w),(a4)
                lsl.w   #4,d0
                move.w  d2,d1
                btst    #$B,d4
                beq.s   SKCollision_TransformSingleWallAngleForHorizontalFlip
                not.w   d1
                addi.b  #$40,(a4)
                neg.b   (a4)
                subi.b  #$40,(a4)

SKCollision_TransformSingleWallAngleForHorizontalFlip:
                btst    #$A,d4
                beq.s   SKCollision_ReadSingleWallRotatedHeightWithEffectiveFlip
                neg.b   (a4)

SKCollision_ReadSingleWallRotatedHeightWithEffectiveFlip:
                andi.w  #$F,d1
                add.w   d0,d1
                lea     (HeightMapsRot).l,a2
                move.b  (a2,d1.w),d0
                ext.w   d0
                eor.w   d6,d4
                btst    #$A,d4
                beq.s   SKCollision_ComputeSingleWallDistanceFromSignedHeight
                neg.w   d0

SKCollision_ComputeSingleWallDistanceFromSignedHeight:
                tst.w   d0
                beq.s   SKCollision_ReturnEmptySingleWallBlockDistance
                bmi.s   SKCollision_ResolveNegativeSingleWallColumnDistance
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                move.w  #$F,d1
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

SKCollision_ResolveNegativeSingleWallColumnDistance:
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                bpl.w   SKCollision_ReturnEmptySingleWallBlockDistance
                not.w   d1
                rts
; End of function SampleSingleBlockWallDistance

; =============== S U B R O U T I N E =======================================

ProbeNextSurfaceWithFixedLookahead:
                tst.w   (Competition_mode).w
                bne.w   ProbeNextSurfaceWithBodyRadius
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   SKCollision_PredictFixedLookaheadPositionFromFullFractionalCoordinates
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

SKCollision_PredictFixedLookaheadPositionFromFullFractionalCoordinates:
                move.b  lrb_solid_bit(a0),d5
                move.l  x_pos(a0),d3
                move.l  y_pos(a0),d2
                move.w  x_vel(a0),d1
                ext.l   d1
                asl.l   #8,d1
                add.l   d1,d3
                move.w  y_vel(a0),d1
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKCollision_FinishGravityAdjustedFixedLookaheadAndRoundDirection
                neg.w   d1

SKCollision_FinishGravityAdjustedFixedLookaheadAndRoundDirection:
                ext.l   d1
                asl.l   #8,d1
                add.l   d1,d2
                swap    d2
                swap    d3
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                move.b  d0,d1
                addi.b  #$20,d0
                bpl.s   SKCollision_AdjustNegativeDirectionInLowerFixedLookaheadHalf
                move.b  d1,d0
                bpl.s   SKCollision_FinishUpperHalfFixedLookaheadAngleBias
                subq.b  #1,d0

SKCollision_FinishUpperHalfFixedLookaheadAngleBias:
                addi.b  #$20,d0
                bra.s   SKCollision_DispatchFixedLookaheadFloorCeilingOrWall
; ---------------------------------------------------------------------------

SKCollision_AdjustNegativeDirectionInLowerFixedLookaheadHalf:
                move.b  d1,d0
                bpl.s   SKCollision_AddLowerHalfFixedLookaheadDirectionBias
                addq.b  #1,d0

SKCollision_AddLowerHalfFixedLookaheadDirectionBias:
                addi.b  #$1F,d0

SKCollision_DispatchFixedLookaheadFloorCeilingOrWall:
                andi.b  #$C0,d0
                beq.w   CheckFloorDist_Part2
                cmpi.b  #$80,d0
                beq.w   CheckCeilingDist_Part2
                tst.w   (Competition_mode).w
                bne.s   SKCollision_DispatchFixedLookaheadWallByQuadrant
                andi.b  #$38,d1
                bne.s   SKCollision_DispatchFixedLookaheadWallByQuadrant
                addq.w  #8,d2

SKCollision_DispatchFixedLookaheadWallByQuadrant:
                cmpi.b  #$40,d0
                beq.w   SKCollision_ProbeLeftWallAtFixedTenPixelOffset
                bra.w   SKCollision_ProbeRightWallAtFixedTenPixelOffset
; End of function ProbeNextSurfaceWithFixedLookahead

; =============== S U B R O U T I N E =======================================

ProbeNextSurfaceWithBodyRadius:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   SKCollision_PredictBodyRadiusLookaheadWithoutReverseYAdjustment
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

SKCollision_PredictBodyRadiusLookaheadWithoutReverseYAdjustment:
                move.b  lrb_solid_bit(a0),d5
                move.l  x_pos(a0),d3
                move.l  y_pos(a0),d2
                move.w  x_vel(a0),d1
                ext.l   d1
                asl.l   #8,d1
                add.l   d1,d3
                move.w  y_vel(a0),d1
                ext.l   d1
                asl.l   #8,d1
                add.l   d1,d2
                swap    d2
                swap    d3
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                move.b  d0,d1
                addi.b  #$20,d0
                bpl.s   SKCollision_AdjustNegativeDirectionInLowerBodyRadiusHalf
                move.b  d1,d0
                bpl.s   SKCollision_FinishUpperHalfBodyRadiusDirectionBias
                subq.b  #1,d0

SKCollision_FinishUpperHalfBodyRadiusDirectionBias:
                addi.b  #$20,d0
                bra.s   SKCollision_DispatchPredictedBodyRadiusSurfaceProbe
; ---------------------------------------------------------------------------

SKCollision_AdjustNegativeDirectionInLowerBodyRadiusHalf:
                move.b  d1,d0
                bpl.s   SKCollision_AddLowerHalfBodyRadiusDirectionBias
                addq.b  #1,d0

SKCollision_AddLowerHalfBodyRadiusDirectionBias:
                addi.b  #$1F,d0

SKCollision_DispatchPredictedBodyRadiusSurfaceProbe:
                andi.b  #$C0,d0
                beq.w   ProbeFloorWithXRadiusOffset
                cmpi.b  #$80,d0
                beq.w   CheckCeilingDist_WithRadius
                cmpi.b  #$40,d0
                beq.w   SKCollision_ProbeLeftWallAtSignedBodyXRadius
                bra.w   SKCollision_ProbeRightWallAtSignedBodyXRadius
; End of function ProbeNextSurfaceWithBodyRadius
