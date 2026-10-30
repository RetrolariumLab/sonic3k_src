; Owner: game/collision/s3
; Responsibility: Player floor-angle attachment and transitions along right walls, ceilings and left walls
; Source provenance and ranges: config/reconstruction/source_layout.json
Player_AnglePos:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_FFB8
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_FFB8:
                move.b  top_solid_bit(a0),d5
                btst    #Status_OnObj,status(a0)
                beq.s   loc_FFD0
                moveq   #0,d0
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                rts
; ---------------------------------------------------------------------------

loc_FFD0:
                moveq   #3,d0
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                move.b  angle(a0),d0
                addi.b  #$20,d0
                bpl.s   loc_FFF2
                move.b  angle(a0),d0
                bpl.s   loc_FFEC
                subq.b  #1,d0

loc_FFEC:
                addi.b  #$20,d0
                bra.s   loc_FFFE
; ---------------------------------------------------------------------------

loc_FFF2:
                move.b  angle(a0),d0
                bpl.s   loc_FFFA
                addq.b  #1,d0

loc_FFFA:
                addi.b  #$1F,d0

loc_FFFE:
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
                beq.s   locret_10088
                bpl.s   loc_1008A
                cmpi.w  #-$E,d1
                blt.s   locret_10088
                add.w   d1,y_pos(a0)

locret_10088:
                rts
; ---------------------------------------------------------------------------

loc_1008A:
                tst.b   stick_to_convex(a0)
                bne.s   loc_100A8
                move.b  x_vel(a0),d0
                bpl.s   loc_10098
                neg.b   d0

loc_10098:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   loc_100A4
                move.b  #$E,d0

loc_100A4:
                cmp.b   d0,d1
                bgt.s   loc_100AE

loc_100A8:
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_100AE:
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
                ble.s   loc_100D4
                move.b  (Primary_Angle).w,d2
                move.w  d1,d3
                move.w  d0,d1

loc_100D4:
                btst    #0,d2
                bne.s   loc_100F0
                move.b  d2,d0
                sub.b   angle(a0),d0
                bpl.s   loc_100E4
                neg.b   d0

loc_100E4:
                cmpi.b  #$20,d0
                bhs.s   loc_100F0
                move.b  d2,angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_100F0:
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
                beq.s   locret_10176
                bpl.s   loc_10198
                cmpi.w  #-$E,d1
                blt.s   loc_10184
                tst.b   $41(a0)
                bne.s   loc_10178
                add.w   d1,x_pos(a0)

locret_10176:
                rts
; ---------------------------------------------------------------------------

loc_10178:
                subq.b  #1,$41(a0)
                move.b  #$C0,angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_10184:
                tst.w   (Current_zone_and_act).w
                bne.s   locret_10176
                move.b  #$C0,angle(a0)
                move.b  #3,$41(a0)
                rts
; ---------------------------------------------------------------------------

loc_10198:
                tst.b   stick_to_convex(a0)
                bne.s   loc_101B6
                move.b  y_vel(a0),d0
                bpl.s   loc_101A6
                neg.b   d0

loc_101A6:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   loc_101B2
                move.b  #$E,d0

loc_101B2:
                cmp.b   d0,d1
                bgt.s   loc_101BC

loc_101B6:
                add.w   d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_101BC:
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
                beq.s   locret_10244
                bpl.s   loc_10246
                cmpi.w  #-$E,d1
                blt.s   locret_10244
                sub.w   d1,y_pos(a0)

locret_10244:
                rts
; ---------------------------------------------------------------------------

loc_10246:
                tst.b   stick_to_convex(a0)
                bne.s   loc_10264
                move.b  x_vel(a0),d0
                bpl.s   loc_10254
                neg.b   d0

loc_10254:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   loc_10260
                move.b  #$E,d0

loc_10260:
                cmp.b   d0,d1
                bgt.s   loc_1026A

loc_10264:
                sub.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_1026A:
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
                beq.s   locret_102F2
                bpl.s   loc_102F4
                cmpi.w  #-$E,d1
                blt.s   locret_102F2
                sub.w   d1,x_pos(a0)

locret_102F2:
                rts
; ---------------------------------------------------------------------------

loc_102F4:
                tst.b   stick_to_convex(a0)
                bne.s   loc_10312
                move.b  y_vel(a0),d0
                bpl.s   loc_10302
                neg.b   d0

loc_10302:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   loc_1030E
                move.b  #$E,d0

loc_1030E:
                cmp.b   d0,d1
                bgt.s   loc_10318

loc_10312:
                sub.w   d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_10318:
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)
                rts
