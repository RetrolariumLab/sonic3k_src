; Owner: game/collision/sk
; Responsibility: Overhead and floor clearance wrappers, floor-edge checks and object, fire and ring floor probes
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Subroutine to calculate how much space is empty above Sonic's/Tails' head
; d0 = input angle perpendicular to the spine
; d1 = output about how many pixels are overhead (up to some high enough amount)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

CalcRoomOverHead:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_F742
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_F742:
                move.b  lrb_solid_bit(a0),d5
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                addi.b  #$20,d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   CheckLeftCeilingDist
                cmpi.b  #$80,d0
                beq.w   Sonic_CheckCeiling
                cmpi.b  #$C0,d0
                beq.w   CheckRightCeilingDist
; End of function CalcRoomOverHead

; ---------------------------------------------------------------------------
; Subroutine to check if Sonic/Tails is near the floor
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sonic_CheckFloor:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_F782
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_F782:
                move.b  top_solid_bit(a0),d5
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
                sub.w   d0,d3
                lea     (Secondary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindFloor
                move.w  (sp)+,d0
                move.b  #0,d2

loc_F7E2:
                move.b  (Secondary_Angle).w,d3
                cmp.w   d0,d1
                ble.s   loc_F7F0
                move.b  (Primary_Angle).w,d3
                exg     d0,d1

loc_F7F0:
                btst    #0,d3
                beq.s   locret_F7F8
                move.b  d2,d3

locret_F7F8:
                rts
; End of function Sonic_CheckFloor

; ---------------------------------------------------------------------------

CheckFloorDist:                                         ; unused/dead code
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3

; Checks a 16x16 block to find solid ground. May check an additional
; 16x16 block up for ceilings
; d2 = y_pos
; d3 = x_pos
; d5 = ($c,$d) or ($e,$f) - solidity type bit (L/R/B or top)
; returns relevant block ID in (a1)
; returns distance in d1
; returns angle in d3, or zero if angle was odd

CheckFloorDist_Part2:
                addi.w  #$A,d2
                lea     (Primary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindFloor
                move.b  #0,d2

; d2 what to use as angle if (Primary_Angle).w is odd
; returns angle in d3, or value in d2 if angle was odd
loc_F81A:
                move.b  (Primary_Angle).w,d3
                btst    #0,d3
                beq.s   locret_F826
                move.b  d2,d3

locret_F826:
                rts

; =============== S U B R O U T I N E =======================================

ProbeFloorWithXRadiusOffset:
                move.b  x_radius(a0),d0
                ext.w   d0
                add.w   d0,d2
                lea     (Primary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindFloor
                move.b  #0,d2
                bra.s   loc_F81A
; End of function ProbeFloorWithXRadiusOffset

; =============== S U B R O U T I N E =======================================

CheckPlayerBodyFloorClearance:
                move.w  x_pos(a0),d3
                move.w  y_pos(a0),d2
                subq.w  #4,d2
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$D,lrb_solid_bit(a0)
                beq.s   loc_F864
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_F864:
                lea     (Primary_Angle).w,a4
                move.b  #0,(a4)
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                move.b  lrb_solid_bit(a0),d5
                movem.l a4-a6,-(sp)
                bsr.w   FindFloor
                movem.l (sp)+,a4-a6
                move.b  (Primary_Angle).w,d3
                btst    #0,d3
                beq.s   locret_F892
                move.b  #0,d3

locret_F892:
                rts
; End of function CheckPlayerBodyFloorClearance

; =============== S U B R O U T I N E =======================================

ChkFloorEdge:
                move.w  x_pos(a0),d3

ChkFloorEdge_Part2:
                move.w  y_pos(a0),d2
                moveq   #0,d0
                move.b  y_radius(a0),d0
                ext.w   d0
                add.w   d0,d2

ChkFloorEdge_Part3:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_F8BA
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_F8BA:
                lea     (Primary_Angle).w,a4
                move.b  #0,(a4)
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                move.b  top_solid_bit(a0),d5
                movem.l a4-a6,-(sp)
                bsr.w   FindFloor
                movem.l (sp)+,a4-a6
                move.b  (Primary_Angle).w,d3
                btst    #0,d3
                beq.s   locret_F8E8
                move.b  #0,d3

locret_F8E8:
                rts
; End of function ChkFloorEdge_Part3

; =============== S U B R O U T I N E =======================================

SonicOnObjHitFloor:
                move.w  x_pos(a1),d3
                move.w  y_pos(a1),d2
                moveq   #0,d0
                move.b  y_radius(a1),d0
                ext.w   d0
                add.w   d0,d2
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a1)
                beq.s   loc_F910
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_F910:
                lea     (Primary_Angle).w,a4
                move.b  #0,(a4)
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                move.b  top_solid_bit(a1),d5
                bsr.w   FindFloor
                move.b  (Primary_Angle).w,d3
                btst    #0,d3
                beq.s   locret_F936
                move.b  #0,d3

locret_F936:
                rts
; End of function SonicOnObjHitFloor

; ---------------------------------------------------------------------------
; Subroutine checking if an object should interact with the floor
; (objects such as a monitor Sonic bumps from underneath)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

ObjCheckFloorDist:
                move.w  x_pos(a0),d3

ObjCheckFloorDist2:
                move.w  y_pos(a0),d2                    ; Get object position
                move.b  y_radius(a0),d0                 ; Get object height
                ext.w   d0
                add.w   d0,d2
                lea     (Primary_Angle).w,a4
                move.b  #0,(a4)
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                moveq   #$C,d5
                bsr.w   FindFloor
                move.b  (Primary_Angle).w,d3
                btst    #0,d3
                beq.s   locret_F96C
                move.b  #0,d3

locret_F96C:
                rts
; End of function ObjCheckFloorDist

; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; Unused collision check used in S2 to let the HTZ boss fire attack hit the ground
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

FireCheckFloorDist:
                move.w  x_pos(a1),d3
                move.w  y_pos(a1),d2
                move.b  y_radius(a1),d0
                ext.w   d0
                add.w   d0,d2
                lea     (Primary_Angle).w,a4
                move.b  #0,(a4)
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                moveq   #$C,d5
                bra.w   FindFloor

; =============== S U B R O U T I N E =======================================

RingCheckFloorDist:
                move.w  x_pos(a0),d3
                move.w  y_pos(a0),d2
                move.b  y_radius(a0),d0
                ext.w   d0
                add.w   d0,d2
                lea     (Primary_Angle).w,a4
                move.b  #0,(a4)
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                moveq   #$C,d5
                bra.w   Ring_FindFloor
; End of function RingCheckFloorDist
