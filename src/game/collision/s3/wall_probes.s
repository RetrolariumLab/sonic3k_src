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
                bpl.s   S3Wall_ShiftPositiveXToBG
                eori.w  #$F,d3
                sub.w   (Camera_X_diff).w,d3
                eori.w  #$F,d3
                bra.s   S3Wall_SampleBG
; ---------------------------------------------------------------------------

S3Wall_ShiftPositiveXToBG:
                sub.w   (Camera_X_diff).w,d3

S3Wall_SampleBG:
                sub.w   (Camera_Y_diff).w,d2
                lea     (Find_Tile_BG).l,a5
                bsr.s   SampleWallDistanceWithNeighbor
                move.w  a3,d0
                bpl.s   S3Wall_RestorePositiveX
                eori.w  #$F,d3
                add.w   (Camera_X_diff).w,d3
                eori.w  #$F,d3
                bra.s   S3Wall_RestoreYAndPickLayer
; ---------------------------------------------------------------------------

S3Wall_RestorePositiveX:
                add.w   (Camera_X_diff).w,d3

S3Wall_RestoreYAndPickLayer:
                add.w   (Camera_Y_diff).w,d2
                move.w  (sp)+,d0
                cmp.w   d0,d1
                ble.s   S3Wall_LayerReturn
                move.b  Primary_Angle_save-Primary_Angle(a4),(a4)
                move.w  d0,d1

S3Wall_LayerReturn:
                rts
; End of function FindWall

; =============== S U B R O U T I N E =======================================

SampleWallDistanceWithNeighbor:
                jsr     (a5)
                move.w  (a1),d0
                move.w  d0,d4
                andi.w  #$3FF,d0
                beq.s   S3Wall_SampleNextBlock
                btst    d5,d4
                bne.s   S3Wall_LoadShapeAndAngle

S3Wall_SampleNextBlock:
                add.w   a3,d3
                bsr.w   SampleSingleBlockWallDistance
                sub.w   a3,d3
                addi.w  #$10,d1
                rts
; ---------------------------------------------------------------------------

S3Wall_LoadShapeAndAngle:
                movea.l (Collision_addr).w,a2
                add.w   d0,d0
                move.w  (a2,d0.w),d0
                beq.s   S3Wall_SampleNextBlock
                lea     (AngleArray).l,a2
                move.b  (a2,d0.w),(a4)
                lsl.w   #4,d0
                move.w  d2,d1
                btst    #$B,d4
                beq.s   S3Wall_FlipAngleX
                not.w   d1
                addi.b  #$40,(a4)
                neg.b   (a4)
                subi.b  #$40,(a4)

S3Wall_FlipAngleX:
                btst    #$A,d4
                beq.s   S3Wall_ReadRotatedHeight
                neg.b   (a4)

; Combine the block's X flip with the scan direction mask before applying the sign
S3Wall_ReadRotatedHeight:
                andi.w  #$F,d1
                add.w   d0,d1
                lea     (HeightMapsRot).l,a2
                move.b  (a2,d1.w),d0
                ext.w   d0
                eor.w   d6,d4
                btst    #$A,d4
                beq.s   S3Wall_ClassifyHeight
                neg.w   d0

S3Wall_ClassifyHeight:
                tst.w   d0
                beq.s   S3Wall_SampleNextBlock
                bmi.s   S3Wall_TestNegHeightAtLocalX
                cmpi.b  #$10,d0
                beq.s   S3Wall_SamplePrevBlock
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                move.w  #$F,d1
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

S3Wall_TestNegHeightAtLocalX:
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                bpl.w   S3Wall_SampleNextBlock

S3Wall_SamplePrevBlock:
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
                beq.s   S3WallBlock_EmptyDistance
                btst    d5,d4
                bne.s   S3WallBlock_LoadShapeAndAngle

S3WallBlock_EmptyDistance:
                move.w  #$F,d1
                move.w  d3,d0
                andi.w  #$F,d0
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

S3WallBlock_LoadShapeAndAngle:
                movea.l (Collision_addr).w,a2
                add.w   d0,d0
                move.w  (a2,d0.w),d0
                beq.s   S3WallBlock_EmptyDistance
                lea     (AngleArray).l,a2
                move.b  (a2,d0.w),(a4)
                lsl.w   #4,d0
                move.w  d2,d1
                btst    #$B,d4
                beq.s   S3WallBlock_FlipAngleX
                not.w   d1
                addi.b  #$40,(a4)
                neg.b   (a4)
                subi.b  #$40,(a4)

S3WallBlock_FlipAngleX:
                btst    #$A,d4
                beq.s   S3WallBlock_ReadRotatedHeight
                neg.b   (a4)

S3WallBlock_ReadRotatedHeight:
                andi.w  #$F,d1
                add.w   d0,d1
                lea     (HeightMapsRot).l,a2
                move.b  (a2,d1.w),d0
                ext.w   d0
                eor.w   d6,d4
                btst    #$A,d4
                beq.s   S3WallBlock_ClassifyHeight
                neg.w   d0

S3WallBlock_ClassifyHeight:
                tst.w   d0
                beq.s   S3WallBlock_EmptyDistance
                bmi.s   S3WallBlock_TestNegHeight
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                move.w  #$F,d1
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

S3WallBlock_TestNegHeight:
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                bpl.w   S3WallBlock_EmptyDistance
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
                beq.s   S3FixedProbe_PredictXY
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

S3FixedProbe_PredictXY:
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
                bpl.s   S3FixedProbe_AdjustLowerHalfAngle
                move.b  d1,d0
                bpl.s   S3FixedProbe_UpperHalfBias
                subq.b  #1,d0

S3FixedProbe_UpperHalfBias:
                addi.b  #$20,d0
                bra.s   S3FixedProbe_DispatchSurface
; ---------------------------------------------------------------------------

S3FixedProbe_AdjustLowerHalfAngle:
                move.b  d1,d0
                bpl.s   S3FixedProbe_LowerHalfBias
                addq.b  #1,d0

S3FixedProbe_LowerHalfBias:
                addi.b  #$1F,d0

; For an almost horizontal wall probe outside Competition, add eight pixels to sample lower
S3FixedProbe_DispatchSurface:
                andi.b  #$C0,d0
                beq.w   CheckFloorDist_Part2
                cmpi.b  #$80,d0
                beq.w   CheckCeilingDist_Part2
                tst.w   (Competition_mode).w
                bne.s   S3FixedProbe_DispatchWall
                andi.b  #$38,d1
                bne.s   S3FixedProbe_DispatchWall
                addq.w  #8,d2

S3FixedProbe_DispatchWall:
                cmpi.b  #$40,d0
                beq.w   S3Clearance_LeftAt10px
                bra.w   S3Clearance_RightAt10px
; End of function ProbeNextSurfaceWithFixedLookahead

; =============== S U B R O U T I N E =======================================

ProbeNextSurfaceWithBodyRadius:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   S3RadiusProbe_PredictXY
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

S3RadiusProbe_PredictXY:
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
                bpl.s   S3RadiusProbe_AdjustLowerHalfAngle
                move.b  d1,d0
                bpl.s   S3RadiusProbe_UpperHalfBias
                subq.b  #1,d0

S3RadiusProbe_UpperHalfBias:
                addi.b  #$20,d0
                bra.s   S3RadiusProbe_DispatchSurface
; ---------------------------------------------------------------------------

S3RadiusProbe_AdjustLowerHalfAngle:
                move.b  d1,d0
                bpl.s   S3RadiusProbe_LowerHalfBias
                addq.b  #1,d0

S3RadiusProbe_LowerHalfBias:
                addi.b  #$1F,d0

S3RadiusProbe_DispatchSurface:
                andi.b  #$C0,d0
                beq.w   ProbeFloorWithXRadiusOffset
                cmpi.b  #$80,d0
                beq.w   CheckCeilingDist_WithRadius
                cmpi.b  #$40,d0
                beq.w   S3Clearance_LeftAtXRadius
                bra.w   S3Clearance_RightAtXRadius
; End of function ProbeNextSurfaceWithBodyRadius
