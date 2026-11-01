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
                bpl.s   loc_F4A4
                eori.w  #$F,d3
                sub.w   (Camera_X_diff).w,d3
                eori.w  #$F,d3
                bra.s   loc_F4A8
; ---------------------------------------------------------------------------

loc_F4A4:
                sub.w   (Camera_X_diff).w,d3

loc_F4A8:
                sub.w   (Camera_Y_diff).w,d2
                lea     (Find_Tile_BG).l,a5
                bsr.s   SampleWallDistanceWithNeighbor
                move.w  a3,d0
                bpl.s   loc_F4C6
                eori.w  #$F,d3
                add.w   (Camera_X_diff).w,d3
                eori.w  #$F,d3
                bra.s   loc_F4CA
; ---------------------------------------------------------------------------

loc_F4C6:
                add.w   (Camera_X_diff).w,d3

loc_F4CA:
                add.w   (Camera_Y_diff).w,d2
                move.w  (sp)+,d0
                cmp.w   d0,d1
                ble.s   locret_F4DA
                move.b  Primary_Angle_save-Primary_Angle(a4),(a4)
                move.w  d0,d1

locret_F4DA:
                rts
; End of function FindWall

; =============== S U B R O U T I N E =======================================

SampleWallDistanceWithNeighbor:
                jsr     (a5)
                move.w  (a1),d0
                move.w  d0,d4
                andi.w  #$3FF,d0
                beq.s   loc_F4EC
                btst    d5,d4
                bne.s   loc_F4FA

loc_F4EC:
                add.w   a3,d3
                bsr.w   SampleSingleBlockWallDistance
                sub.w   a3,d3
                addi.w  #$10,d1
                rts
; ---------------------------------------------------------------------------

loc_F4FA:
                movea.l (Collision_addr).w,a2
                add.w   d0,d0
                move.b  (a2,d0.w),d0
                andi.w  #$FF,d0
                beq.s   loc_F4EC
                lea     (AngleArray).l,a2
                move.b  (a2,d0.w),(a4)
                lsl.w   #4,d0
                move.w  d2,d1
                btst    #$B,d4
                beq.s   loc_F52A
                not.w   d1
                addi.b  #$40,(a4)
                neg.b   (a4)
                subi.b  #$40,(a4)

loc_F52A:
                btst    #$A,d4
                beq.s   loc_F532
                neg.b   (a4)

loc_F532:
                andi.w  #$F,d1
                add.w   d0,d1
                lea     (HeightMapsRot).l,a2
                move.b  (a2,d1.w),d0
                ext.w   d0
                eor.w   d6,d4
                btst    #$A,d4
                beq.s   loc_F54E
                neg.w   d0

loc_F54E:
                tst.w   d0
                beq.s   loc_F4EC
                bmi.s   loc_F56A
                cmpi.b  #$10,d0
                beq.s   loc_F576
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                move.w  #$F,d1
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

loc_F56A:
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                bpl.w   loc_F4EC

loc_F576:
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
                beq.s   loc_F594
                btst    d5,d4
                bne.s   loc_F5A2

loc_F594:
                move.w  #$F,d1
                move.w  d3,d0
                andi.w  #$F,d0
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

loc_F5A2:
                movea.l (Collision_addr).w,a2
                add.w   d0,d0
                move.b  (a2,d0.w),d0
                andi.w  #$FF,d0
                beq.s   loc_F594
                lea     (AngleArray).l,a2
                move.b  (a2,d0.w),(a4)
                lsl.w   #4,d0
                move.w  d2,d1
                btst    #$B,d4
                beq.s   loc_F5D2
                not.w   d1
                addi.b  #$40,(a4)
                neg.b   (a4)
                subi.b  #$40,(a4)

loc_F5D2:
                btst    #$A,d4
                beq.s   loc_F5DA
                neg.b   (a4)

loc_F5DA:
                andi.w  #$F,d1
                add.w   d0,d1
                lea     (HeightMapsRot).l,a2
                move.b  (a2,d1.w),d0
                ext.w   d0
                eor.w   d6,d4
                btst    #$A,d4
                beq.s   loc_F5F6
                neg.w   d0

loc_F5F6:
                tst.w   d0
                beq.s   loc_F594
                bmi.s   loc_F60C
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                move.w  #$F,d1
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

loc_F60C:
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                bpl.w   loc_F594
                not.w   d1
                rts
; End of function SampleSingleBlockWallDistance

; =============== S U B R O U T I N E =======================================

ProbeNextSurfaceWithFixedLookahead:
                tst.w   (Competition_mode).w
                bne.w   ProbeNextSurfaceWithBodyRadius
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_F638
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_F638:
                move.b  lrb_solid_bit(a0),d5
                move.l  x_pos(a0),d3
                move.l  y_pos(a0),d2
                move.w  x_vel(a0),d1
                ext.l   d1
                asl.l   #8,d1
                add.l   d1,d3
                move.w  y_vel(a0),d1
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_F65A
                neg.w   d1

loc_F65A:
                ext.l   d1
                asl.l   #8,d1
                add.l   d1,d2
                swap    d2
                swap    d3
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                move.b  d0,d1
                addi.b  #$20,d0
                bpl.s   loc_F680
                move.b  d1,d0
                bpl.s   loc_F67A
                subq.b  #1,d0

loc_F67A:
                addi.b  #$20,d0
                bra.s   loc_F68A
; ---------------------------------------------------------------------------

loc_F680:
                move.b  d1,d0
                bpl.s   loc_F686
                addq.b  #1,d0

loc_F686:
                addi.b  #$1F,d0

loc_F68A:
                andi.b  #$C0,d0
                beq.w   CheckFloorDist_Part2
                cmpi.b  #$80,d0
                beq.w   CheckCeilingDist_Part2
                tst.w   (Competition_mode).w
                bne.s   loc_F6A8
                andi.b  #$38,d1
                bne.s   loc_F6A8
                addq.w  #8,d2

loc_F6A8:
                cmpi.b  #$40,d0
                beq.w   loc_FDA8
                bra.w   loc_FA88
; End of function ProbeNextSurfaceWithFixedLookahead

; =============== S U B R O U T I N E =======================================

ProbeNextSurfaceWithBodyRadius:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_F6C8
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_F6C8:
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
                bpl.s   loc_F708
                move.b  d1,d0
                bpl.s   loc_F702
                subq.b  #1,d0

loc_F702:
                addi.b  #$20,d0
                bra.s   loc_F712
; ---------------------------------------------------------------------------

loc_F708:
                move.b  d1,d0
                bpl.s   loc_F70E
                addq.b  #1,d0

loc_F70E:
                addi.b  #$1F,d0

loc_F712:
                andi.b  #$C0,d0
                beq.w   ProbeFloorWithXRadiusOffset
                cmpi.b  #$80,d0
                beq.w   CheckCeilingDist_WithRadius
                cmpi.b  #$40,d0
                beq.w   loc_FDC8
                bra.w   loc_FAA4
; End of function ProbeNextSurfaceWithBodyRadius
