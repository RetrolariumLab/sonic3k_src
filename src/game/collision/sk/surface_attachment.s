; Owner: game/collision/sk
; Responsibility: Player floor-angle attachment and transitions along right walls, ceilings and left walls
; Source provenance and ranges: config/reconstruction/source_layout.json
Player_AnglePos:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_EC42
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_EC42:
                move.b  top_solid_bit(a0),d5
                btst    #Status_OnObj,status(a0)
                beq.s   loc_EC5A
                moveq   #0,d0
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                rts
; ---------------------------------------------------------------------------

loc_EC5A:
                moveq   #3,d0
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                move.b  angle(a0),d0
                addi.b  #$20,d0
                bpl.s   loc_EC7C
                move.b  angle(a0),d0
                bpl.s   loc_EC76
                subq.b  #1,d0

loc_EC76:
                addi.b  #$20,d0
                bra.s   loc_EC88
; ---------------------------------------------------------------------------

loc_EC7C:
                move.b  angle(a0),d0
                bpl.s   loc_EC84
                addq.b  #1,d0

loc_EC84:
                addi.b  #$1F,d0

loc_EC88:
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
                beq.s   locret_ED12
                bpl.s   loc_ED14
                cmpi.w  #-$E,d1
                blt.s   locret_ED12
                add.w   d1,y_pos(a0)

locret_ED12:
                rts
; ---------------------------------------------------------------------------

loc_ED14:
                tst.b   stick_to_convex(a0)
                bne.s   loc_ED32
                move.b  x_vel(a0),d0
                bpl.s   loc_ED22
                neg.b   d0

loc_ED22:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   loc_ED2E
                move.b  #$E,d0

loc_ED2E:
                cmp.b   d0,d1
                bgt.s   loc_ED38

loc_ED32:
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_ED38:
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
                ble.s   loc_ED5E
                move.b  (Primary_Angle).w,d2
                move.w  d1,d3
                move.w  d0,d1

loc_ED5E:
                btst    #0,d2
                bne.s   loc_ED7A
                move.b  d2,d0
                sub.b   angle(a0),d0
                bpl.s   loc_ED6E
                neg.b   d0

loc_ED6E:
                cmpi.b  #$20,d0
                bhs.s   loc_ED7A
                move.b  d2,angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_ED7A:
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
                beq.s   locret_EE00
                bpl.s   loc_EE22
                cmpi.w  #-$E,d1
                blt.s   loc_EE0E
                tst.b   $41(a0)
                bne.s   loc_EE02
                add.w   d1,x_pos(a0)

locret_EE00:
                rts
; ---------------------------------------------------------------------------

loc_EE02:
                subq.b  #1,$41(a0)
                move.b  #$C0,angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_EE0E:
                tst.w   (Current_zone_and_act).w
                bne.s   locret_EE00
                move.b  #$C0,angle(a0)
                move.b  #3,$41(a0)
                rts
; ---------------------------------------------------------------------------

loc_EE22:
                tst.b   stick_to_convex(a0)
                bne.s   loc_EE40
                move.b  y_vel(a0),d0
                bpl.s   loc_EE30
                neg.b   d0

loc_EE30:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   loc_EE3C
                move.b  #$E,d0

loc_EE3C:
                cmp.b   d0,d1
                bgt.s   loc_EE46

loc_EE40:
                add.w   d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_EE46:
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
                beq.s   locret_EECE
                bpl.s   loc_EED0
                cmpi.w  #-$E,d1
                blt.s   locret_EECE
                sub.w   d1,y_pos(a0)

locret_EECE:
                rts
; ---------------------------------------------------------------------------

loc_EED0:
                tst.b   stick_to_convex(a0)
                bne.s   loc_EEEE
                move.b  x_vel(a0),d0
                bpl.s   loc_EEDE
                neg.b   d0

loc_EEDE:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   loc_EEEA
                move.b  #$E,d0

loc_EEEA:
                cmp.b   d0,d1
                bgt.s   loc_EEF4

loc_EEEE:
                sub.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_EEF4:
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
                beq.s   locret_EF7C
                bpl.s   loc_EF7E
                cmpi.w  #-$E,d1
                blt.s   locret_EF7C
                sub.w   d1,x_pos(a0)

locret_EF7C:
                rts
; ---------------------------------------------------------------------------

loc_EF7E:
                tst.b   stick_to_convex(a0)
                bne.s   loc_EF9C
                move.b  y_vel(a0),d0
                bpl.s   loc_EF8C
                neg.b   d0

loc_EF8C:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   loc_EF98
                move.b  #$E,d0

loc_EF98:
                cmp.b   d0,d1
                bgt.s   loc_EFA2

loc_EF9C:
                sub.w   d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_EFA2:
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)
                rts
