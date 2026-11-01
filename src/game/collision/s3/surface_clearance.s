; Owner: game/collision/s3
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
                bra.w   loc_10B3E

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
                bra.w   loc_10B3E
; End of function ProbeRightWallAtBodyExtents

; =============== S U B R O U T I N E =======================================

CheckRightWallDist:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                tst.w   (Competition_mode).w
                bne.s   loc_10E00

loc_10DE4:
                addi.w  #$A,d3
                lea     (Primary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindWall
                move.b  #-$40,d2
                bra.w   loc_10B76
; ---------------------------------------------------------------------------

loc_10E00:
                move.b  x_radius(a0),d0
                ext.w   d0
                add.w   d0,d3
                lea     (Primary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindWall
                move.b  #-$40,d2
                bra.w   loc_10B76
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
                beq.s   locret_10E4C
                move.b  #-$40,d3

locret_10E4C:
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
                bra.w   loc_10B3E
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
                bra.w   loc_10B3E
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
                bra.w   loc_10B76
; ---------------------------------------------------------------------------

; loc_10F4A
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
                bra.w   loc_10B76

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
                beq.s   locret_10FA4
                move.b  #$80,d3

locret_10FA4:
                rts
; End of function ObjCheckCeilingDist

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
                bra.w   loc_10B3E

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
                bra.w   loc_10B3E
; End of function ProbeLeftWallAtBodyExtents

; =============== S U B R O U T I N E =======================================

CheckLeftWallDist:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                tst.w   (Competition_mode).w
                bne.s   loc_110A4

loc_11084:
                subi.w  #$A,d3
                eori.w  #$F,d3
                lea     (Primary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$400,d6
                bsr.w   FindWall
                move.b  #$40,d2
                bra.w   loc_10B76
; ---------------------------------------------------------------------------

loc_110A4:
                move.b  x_radius(a0),d0
                ext.w   d0
                sub.w   d0,d3
                eori.w  #$F,d3
                lea     (Primary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$400,d6
                bsr.w   FindWall
                move.b  #$40,d2
                bra.w   loc_10B76
; End of function CheckLeftWallDist

; =============== S U B R O U T I N E =======================================

ProbeLeftWallUsingYRadius:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_110DC
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_110DC:
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
                beq.s   locret_11116
                move.b  #$40,d3

locret_11116:
                rts
; End of function ProbeLeftWallUsingYRadius

; =============== S U B R O U T I N E =======================================

ObjCheckLeftWallDist:
                add.w   x_pos(a0),d3

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
                beq.s   locret_11144
                move.b  #$40,d3

locret_11144:
                rts
; End of function ObjCheckLeftWallDist

; ---------------------------------------------------------------------------
; unused
                rts

; =============== S U B R O U T I N E =======================================
