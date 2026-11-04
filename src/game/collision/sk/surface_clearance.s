; Owner: game/collision/sk
; Responsibility: Left and right wall and ceiling clearance wrappers, including product-specific reverse-gravity probes
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

CheckRightCeilingDist:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  x_radius(a0),d0
                ext.w   d0
                sub.w   d0,d2
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
                move.b  #-$40,d2
                bra.w   SKClearance_PickNearerCorner

; =============== S U B R O U T I N E =======================================

ProbeRightWallAtBodyExtents:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d2
                move.b  x_radius(a0),d0
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
                move.b  y_radius(a0),d0
                ext.w   d0
                add.w   d0,d2
                move.b  x_radius(a0),d0
                ext.w   d0
                add.w   d0,d3
                lea     (Secondary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindWall
                move.w  (sp)+,d0
                move.b  #-$40,d2
                bra.w   SKClearance_PickNearerCorner
; End of function ProbeRightWallAtBodyExtents

; =============== S U B R O U T I N E =======================================

CheckRightWallDist:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                tst.w   (Competition_mode).w
                bne.s   SKClearance_RightAtXRadius

SKClearance_RightAt10px:
                addi.w  #$A,d3
                lea     (Primary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindWall
                move.b  #-$40,d2
                bra.w   SKClearance_FilterPrimaryAngle
; ---------------------------------------------------------------------------

SKClearance_RightAtXRadius:
                move.b  x_radius(a0),d0
                ext.w   d0
                add.w   d0,d3
                lea     (Primary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindWall
                move.b  #-$40,d2
                bra.w   SKClearance_FilterPrimaryAngle
; End of function CheckRightWallDist

; =============== S U B R O U T I N E =======================================

ObjCheckRightWallDist:
                add.w   x_pos(a0),d3
                move.w  y_pos(a0),d2
                lea     (Primary_Angle).w,a4
                move.b  #0,(a4)
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                moveq   #$D,d5
                bsr.w   FindWall
                move.b  (Primary_Angle).w,d3
                btst    #0,d3
                beq.s   SKClearance_RightReturn
                move.b  #-$40,d3

SKClearance_RightReturn:
                rts
; End of function ObjCheckRightWallDist

; =============== S U B R O U T I N E =======================================

Sonic_CheckCeiling:
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
                move.b  #$80,d2
                bra.w   SKClearance_PickNearerCorner
; End of function Sonic_CheckCeiling

; =============== S U B R O U T I N E =======================================

ProbeCeilingWithInsetHorizontalRadius:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d2
                eori.w  #$F,d2
                move.b  x_radius(a0),d0
                ext.w   d0
                subq.w  #2,d0
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
                subq.w  #2,d0
                sub.w   d0,d3
                lea     (Secondary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$800,d6
                bsr.w   FindFloor
                move.w  (sp)+,d0
                move.b  #$80,d2
                bra.w   SKClearance_PickNearerCorner
; End of function ProbeCeilingWithInsetHorizontalRadius

; ---------------------------------------------------------------------------

CheckCeilingDist:                                       ; unused/dead code
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3

CheckCeilingDist_Part2:
                subi.w  #$A,d2
                eori.w  #$F,d2
                lea     (Primary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$800,d6
                bsr.w   FindFloor
                move.b  #$80,d2
                bra.w   SKClearance_FilterPrimaryAngle
; ---------------------------------------------------------------------------

; sub_FBEE
CheckCeilingDist_WithRadius:
                move.b  x_radius(a0),d0
                ext.w   d0
                sub.w   d0,d2
                eori.w  #$F,d2
                lea     (Primary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$800,d6
                bsr.w   FindFloor
                move.b  #$80,d2
                bra.w   SKClearance_FilterPrimaryAngle

; =============== S U B R O U T I N E =======================================

ObjCheckCeilingDist:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d2
                eori.w  #$F,d2
                lea     (Primary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$800,d6
                moveq   #$D,d5
                bsr.w   FindFloor
                move.b  (Primary_Angle).w,d3
                btst    #0,d3
                beq.s   SKClearance_CeilingReturn
                move.b  #$80,d3

SKClearance_CeilingReturn:
                rts
; End of function ObjCheckCeilingDist

; ---------------------------------------------------------------------------

ChkFloorEdge_ReverseGravity:
                move.w  y_pos(a0),d2
                moveq   #0,d0
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d2
                eori.w  #$F,d2

ChkFloorEdge_ReverseGravity_Part2:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   SKClearance_ReverseGravityFloor
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

SKClearance_ReverseGravityFloor:
                lea     (Primary_Angle).w,a4
                move.b  #0,(a4)
                movea.w #-Collision_Scan_Step,a3
                move.w  #$800,d6
                move.b  top_solid_bit(a0),d5
                movem.l a4-a6,-(sp)
                bsr.w   FindFloor
                movem.l (sp)+,a4-a6
                move.b  (Primary_Angle).w,d3
                btst    #0,d3
                beq.s   SKClearance_ReverseFloorReturn
                move.b  #0,d3

SKClearance_ReverseFloorReturn:
                rts
; End of function ChkFloorEdge_ReverseGravity_Part2

; =============== S U B R O U T I N E =======================================

; sub_FCA0
RingCheckFloorDist_ReverseGravity:
                move.w  x_pos(a0),d3
                move.w  y_pos(a0),d2
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d2
                eori.w  #$F,d2
                lea     (Primary_Angle).w,a4
                move.b  #0,(a4)
                movea.w #-Collision_Scan_Step,a3
                move.w  #$800,d6
                moveq   #$C,d5
                bra.w   Ring_FindFloor
; End of function RingCheckFloorDist_ReverseGravity

; ---------------------------------------------------------------------------

CheckLeftCeilingDist:
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
                move.b  #$40,d2
                bra.w   SKClearance_PickNearerCorner

; =============== S U B R O U T I N E =======================================

ProbeLeftWallAtBodyExtents:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d2
                move.b  x_radius(a0),d0
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
                move.b  y_radius(a0),d0
                ext.w   d0
                add.w   d0,d2
                move.b  x_radius(a0),d0
                ext.w   d0
                sub.w   d0,d3
                eori.w  #$F,d3
                lea     (Secondary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$400,d6
                bsr.w   FindWall
                move.w  (sp)+,d0
                move.b  #$40,d2
                bra.w   SKClearance_PickNearerCorner
; End of function ProbeLeftWallAtBodyExtents

; =============== S U B R O U T I N E =======================================

CheckLeftWallDist:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                tst.w   (Competition_mode).w
                bne.s   SKClearance_LeftAtXRadius

SKClearance_LeftAt10px:
                subi.w  #$A,d3
                eori.w  #$F,d3
                lea     (Primary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$400,d6
                bsr.w   FindWall
                move.b  #$40,d2
                bra.w   SKClearance_FilterPrimaryAngle
; ---------------------------------------------------------------------------

SKClearance_LeftAtXRadius:
                move.b  x_radius(a0),d0
                ext.w   d0
                sub.w   d0,d3
                eori.w  #$F,d3
                lea     (Primary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$400,d6
                bsr.w   FindWall
                move.b  #$40,d2
                bra.w   SKClearance_FilterPrimaryAngle
; End of function CheckLeftWallDist

; =============== S U B R O U T I N E =======================================

ProbeLeftWallUsingYRadius:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   SKClearance_LeftAtYRadius
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

; Use the object's side solidity bit for the probe
SKClearance_LeftAtYRadius:
                move.w  x_pos(a0),d3
                move.w  y_pos(a0),d2
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d3
                eori.w  #$F,d3
                lea     (Primary_Angle).w,a4
                move.b  #0,(a4)
                movea.w #-Collision_Scan_Step,a3
                move.w  #$400,d6
                move.b  lrb_solid_bit(a0),d5
                bsr.w   FindWall
                move.b  (Primary_Angle).w,d3
                btst    #0,d3
                beq.s   SKCollision_ReturnLeftWallYRadiusProbe
                move.b  #$40,d3

SKCollision_ReturnLeftWallYRadiusProbe:
                rts
; End of function ProbeLeftWallUsingYRadius

; =============== S U B R O U T I N E =======================================

ObjCheckLeftWallDist:
                add.w   x_pos(a0),d3
                eori.w  #$F,d3                          ; this was not here in S1/S2/S3, resulting in a bug

ObjCheckLeftWallDist_Part2:
                move.w  y_pos(a0),d2
                lea     (Primary_Angle).w,a4
                move.b  #0,(a4)
                movea.w #-Collision_Scan_Step,a3
                move.w  #$400,d6
                moveq   #$D,d5
                bsr.w   FindWall
                move.b  (Primary_Angle).w,d3
                btst    #0,d3
                beq.s   SKClearance_LeftReturn
                move.b  #$40,d3

SKClearance_LeftReturn:
                rts
; End of function ObjCheckLeftWallDist

; =============== S U B R O U T I N E =======================================
