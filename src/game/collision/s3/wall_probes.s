; Owner: game/collision/s3
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
                bpl.s   S3Collision_SubtractBackgroundCameraXForPositiveWallStep
                eori.w  #$F,d3
                sub.w   (Camera_X_diff).w,d3
                eori.w  #$F,d3
                bra.s   S3Collision_SampleBackgroundWallAfterCameraTranslation
; ---------------------------------------------------------------------------

S3Collision_SubtractBackgroundCameraXForPositiveWallStep:
                sub.w   (Camera_X_diff).w,d3

S3Collision_SampleBackgroundWallAfterCameraTranslation:
                sub.w   (Camera_Y_diff).w,d2
                lea     (Find_Tile_BG).l,a5
                bsr.s   SampleWallDistanceWithNeighbor
                move.w  a3,d0
                bpl.s   S3Collision_RestoreWallXAfterPositiveBackgroundStep
                eori.w  #$F,d3
                add.w   (Camera_X_diff).w,d3
                eori.w  #$F,d3
                bra.s   S3Collision_RestoreWallYAndChooseCloserLayer
; ---------------------------------------------------------------------------

S3Collision_RestoreWallXAfterPositiveBackgroundStep:
                add.w   (Camera_X_diff).w,d3

S3Collision_RestoreWallYAndChooseCloserLayer:
                add.w   (Camera_Y_diff).w,d2
                move.w  (sp)+,d0
                cmp.w   d0,d1
                ble.s   S3Collision_ReturnSelectedWallLayerDistance
                move.b  Primary_Angle_save-Primary_Angle(a4),(a4)
                move.w  d0,d1

S3Collision_ReturnSelectedWallLayerDistance:
                rts
; End of function FindWall

; =============== S U B R O U T I N E =======================================

SampleWallDistanceWithNeighbor:
                jsr     (a5)
                move.w  (a1),d0
                move.w  d0,d4
                andi.w  #$3FF,d0
                beq.s   S3Collision_SampleForwardWallNeighborForMissingShape
                btst    d5,d4
                bne.s   S3Collision_LoadNeighborAwareWallShapeAndAngle

S3Collision_SampleForwardWallNeighborForMissingShape:
                add.w   a3,d3
                bsr.w   SampleSingleBlockWallDistance
                sub.w   a3,d3
                addi.w  #$10,d1
                rts
; ---------------------------------------------------------------------------

S3Collision_LoadNeighborAwareWallShapeAndAngle:
                movea.l (Collision_addr).w,a2
                add.w   d0,d0
                move.w  (a2,d0.w),d0
                beq.s   S3Collision_SampleForwardWallNeighborForMissingShape
                lea     (AngleArray).l,a2
                move.b  (a2,d0.w),(a4)
                lsl.w   #4,d0
                move.w  d2,d1
                btst    #$B,d4
                beq.s   S3Collision_TransformNeighborAwareWallAngleForXFlip
                not.w   d1
                addi.b  #$40,(a4)
                neg.b   (a4)
                subi.b  #$40,(a4)

S3Collision_TransformNeighborAwareWallAngleForXFlip:
                btst    #$A,d4
                beq.s   S3Collision_ReadNeighborAwareRotatedWallHeight
                neg.b   (a4)

S3Collision_ReadNeighborAwareRotatedWallHeight:
                andi.w  #$F,d1
                add.w   d0,d1
                lea     (HeightMapsRot).l,a2
                move.b  (a2,d1.w),d0
                ext.w   d0
                eor.w   d6,d4
                btst    #$A,d4
                beq.s   S3Collision_ResolveNeighborAwareWallHeightCase
                neg.w   d0

S3Collision_ResolveNeighborAwareWallHeightCase:
                tst.w   d0
                beq.s   S3Collision_SampleForwardWallNeighborForMissingShape
                bmi.s   S3Collision_TestNegativeWallProfileAgainstXFraction
                cmpi.b  #$10,d0
                beq.s   S3Collision_SampleBackwardWallNeighborAndSubtractBlock
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                move.w  #$F,d1
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

S3Collision_TestNegativeWallProfileAgainstXFraction:
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                bpl.w   S3Collision_SampleForwardWallNeighborForMissingShape

S3Collision_SampleBackwardWallNeighborAndSubtractBlock:
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
                beq.s   S3Collision_ReturnSingleBlockWallEmptyDistance
                btst    d5,d4
                bne.s   S3Collision_LoadSingleBlockWallShapeAndAngle

S3Collision_ReturnSingleBlockWallEmptyDistance:
                move.w  #$F,d1
                move.w  d3,d0
                andi.w  #$F,d0
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

S3Collision_LoadSingleBlockWallShapeAndAngle:
                movea.l (Collision_addr).w,a2
                add.w   d0,d0
                move.w  (a2,d0.w),d0
                beq.s   S3Collision_ReturnSingleBlockWallEmptyDistance
                lea     (AngleArray).l,a2
                move.b  (a2,d0.w),(a4)
                lsl.w   #4,d0
                move.w  d2,d1
                btst    #$B,d4
                beq.s   S3Collision_TransformSingleBlockWallAngleForXFlip
                not.w   d1
                addi.b  #$40,(a4)
                neg.b   (a4)
                subi.b  #$40,(a4)

S3Collision_TransformSingleBlockWallAngleForXFlip:
                btst    #$A,d4
                beq.s   S3Collision_ReadSingleBlockRotatedWallHeight
                neg.b   (a4)

S3Collision_ReadSingleBlockRotatedWallHeight:
                andi.w  #$F,d1
                add.w   d0,d1
                lea     (HeightMapsRot).l,a2
                move.b  (a2,d1.w),d0
                ext.w   d0
                eor.w   d6,d4
                btst    #$A,d4
                beq.s   S3Collision_ResolveSingleBlockWallHeightCase
                neg.w   d0

S3Collision_ResolveSingleBlockWallHeightCase:
                tst.w   d0
                beq.s   S3Collision_ReturnSingleBlockWallEmptyDistance
                bmi.s   S3Collision_ReturnOrRejectNegativeSingleBlockWallProfile
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                move.w  #$F,d1
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

S3Collision_ReturnOrRejectNegativeSingleBlockWallProfile:
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                bpl.w   S3Collision_ReturnSingleBlockWallEmptyDistance
                not.w   d1
                rts
; End of function SampleSingleBlockWallDistance

; =============== S U B R O U T I N E =======================================

ConvertCollisionArray:
                rts
; End of function ConvertCollisionArray

; =============== S U B R O U T I N E =======================================

ProbeNextSurfaceWithFixedLookahead:
                tst.w   (Competition_mode).w
                bne.w   ProbeNextSurfaceWithBodyRadius
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   S3Collision_PredictFixedLookaheadPositionAndQuantizeProbeAngle
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

S3Collision_PredictFixedLookaheadPositionAndQuantizeProbeAngle:
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
                bpl.s   S3Collision_AdjustFixedProbeOppositeAngleBoundary
                move.b  d1,d0
                bpl.s   S3Collision_RoundFixedProbeNegativeBoundaryWithTwenty
                subq.b  #1,d0

S3Collision_RoundFixedProbeNegativeBoundaryWithTwenty:
                addi.b  #$20,d0
                bra.s   S3Collision_DispatchFixedPredictedSurfaceQuadrant
; ---------------------------------------------------------------------------

S3Collision_AdjustFixedProbeOppositeAngleBoundary:
                move.b  d1,d0
                bpl.s   S3Collision_AddFixedProbeOneLessThanQuadrantBias
                addq.b  #1,d0

S3Collision_AddFixedProbeOneLessThanQuadrantBias:
                addi.b  #$1F,d0

S3Collision_DispatchFixedPredictedSurfaceQuadrant:
                andi.b  #$C0,d0
                beq.w   CheckFloorDist_Part2
                cmpi.b  #$80,d0
                beq.w   CheckCeilingDist_Part2
                tst.w   (Competition_mode).w
                bne.s   S3Collision_DispatchFixedPredictedWallSide
                andi.b  #$38,d1
                bne.s   S3Collision_DispatchFixedPredictedWallSide
                addq.w  #8,d2

S3Collision_DispatchFixedPredictedWallSide:
                cmpi.b  #$40,d0
                beq.w   S3Collision_ProbeLeftWallWithFixedTenPixelOffset
                bra.w   S3Collision_ProbeRightWallWithFixedTenPixelOffset
; End of function ProbeNextSurfaceWithFixedLookahead

; =============== S U B R O U T I N E =======================================

ProbeNextSurfaceWithBodyRadius:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   S3Collision_PredictBodyRadiusPositionAndQuantizeProbeAngle
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

S3Collision_PredictBodyRadiusPositionAndQuantizeProbeAngle:
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
                bpl.s   S3Collision_AdjustRadiusProbeOppositeAngleBoundary
                move.b  d1,d0
                bpl.s   S3Collision_RoundRadiusProbeNegativeBoundaryWithTwenty
                subq.b  #1,d0

S3Collision_RoundRadiusProbeNegativeBoundaryWithTwenty:
                addi.b  #$20,d0
                bra.s   S3Collision_DispatchPredictedSurfaceUsingBodyRadius
; ---------------------------------------------------------------------------

S3Collision_AdjustRadiusProbeOppositeAngleBoundary:
                move.b  d1,d0
                bpl.s   S3Collision_AddRadiusProbeOneLessThanQuadrantBias
                addq.b  #1,d0

S3Collision_AddRadiusProbeOneLessThanQuadrantBias:
                addi.b  #$1F,d0

S3Collision_DispatchPredictedSurfaceUsingBodyRadius:
                andi.b  #$C0,d0
                beq.w   ProbeFloorWithXRadiusOffset
                cmpi.b  #$80,d0
                beq.w   CheckCeilingDist_WithRadius
                cmpi.b  #$40,d0
                beq.w   S3Collision_ProbeLeftWallWithHorizontalRadius
                bra.w   S3Collision_ProbeRightWallWithHorizontalRadius
; End of function ProbeNextSurfaceWithBodyRadius
