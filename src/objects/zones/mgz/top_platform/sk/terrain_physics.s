; Owner: objects/zones/mgz/top_platform/sk
; Responsibility: Marble Garden spinning top terrain contact, slope handling, acceleration and braking
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

ResolveAirborneTopPlatformTerrain:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_3527E
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_3527E:
                move.b  lrb_solid_bit(a0),d5
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                subi.b  #$20,d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   loc_3536E
                cmpi.b  #$80,d0
                beq.w   loc_353F8
                cmpi.b  #-$40,d0
                beq.w   loc_3547A
                move.b  #$C,y_radius(a0)
                move.b  #$18,x_radius(a0)
                jsr     (ProbeLeftWallAtBodyExtents).l
                tst.w   d1
                bpl.s   loc_352D0
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_352D0:
                jsr     (ProbeRightWallAtBodyExtents).l
                tst.w   d1
                bpl.s   loc_352E4
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_352E4:
                move.b  #$1F,y_radius(a0)
                move.b  #$A,x_radius(a0)
                jsr     (Sonic_CheckFloor).l
                tst.w   d1
                bpl.s   locret_3536C
                move.b  y_vel(a0),d2
                addq.b  #8,d2
                neg.b   d2
                cmp.b   d2,d1
                bge.s   loc_3530A
                cmp.b   d2,d0
                blt.s   locret_3536C

loc_3530A:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                bclr    #1,status(a0)
                move.b  #0,$2D(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   loc_3534A
                move.b  d3,d0
                addi.b  #$10,d0
                andi.b  #$20,d0
                beq.s   loc_3533C
                asr     y_vel(a0)
                bra.s   loc_3535E
; ---------------------------------------------------------------------------

loc_3533C:
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_3534A:
                move.w  #0,x_vel(a0)
                cmpi.w  #$FC0,y_vel(a0)
                ble.s   loc_3535E
                move.w  #$FC0,y_vel(a0)

loc_3535E:
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   locret_3536C
                neg.w   ground_vel(a0)

locret_3536C:
                rts
; ---------------------------------------------------------------------------

loc_3536E:
                move.b  #$C,y_radius(a0)
                move.b  #$18,x_radius(a0)
                jsr     (ProbeLeftWallAtBodyExtents).l
                tst.w   d1
                bpl.s   loc_3539E
                sub.w   d1,x_pos(a0)
                addi.b  #$30,d3
                cmpi.b  #$60,d3
                blo.s   loc_3539E
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

loc_3539E:
                move.b  #$1F,y_radius(a0)
                move.b  #$A,x_radius(a0)
                jsr     (ProbeCeilingWithInsetHorizontalRadius).l
                tst.w   d1
                bpl.s   loc_353C6
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_353C4
                move.w  #0,y_vel(a0)

locret_353C4:
                rts
; ---------------------------------------------------------------------------

loc_353C6:
                tst.w   y_vel(a0)
                bmi.s   locret_353F6
                jsr     (Sonic_CheckFloor).l
                tst.w   d1
                bpl.s   locret_353F6
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                bclr    #1,status(a0)
                move.b  #0,$2D(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)

locret_353F6:
                rts
; ---------------------------------------------------------------------------

loc_353F8:
                move.b  #$C,y_radius(a0)
                move.b  #$18,x_radius(a0)
                jsr     (ProbeLeftWallAtBodyExtents).l
                tst.w   d1
                bpl.s   loc_35418
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_35418:
                jsr     (ProbeRightWallAtBodyExtents).l
                tst.w   d1
                bpl.s   loc_3542C
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_3542C:
                move.b  #$1F,y_radius(a0)
                move.b  #$A,x_radius(a0)
                jsr     (ProbeCeilingWithInsetHorizontalRadius).l
                tst.w   d1
                bpl.s   locret_35478
                sub.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   loc_3545A
                move.w  #0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_3545A:
                move.b  d3,angle(a0)
                bclr    #1,status(a0)
                move.b  #0,$2D(a0)
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   locret_35478
                neg.w   ground_vel(a0)

locret_35478:
                rts
; ---------------------------------------------------------------------------

loc_3547A:
                move.b  #$C,y_radius(a0)
                move.b  #$18,x_radius(a0)
                jsr     (ProbeRightWallAtBodyExtents).l
                tst.w   d1
                bpl.s   loc_354AA
                add.w   d1,x_pos(a0)
                addi.b  #$30,d3
                cmpi.b  #$60,d3
                blo.s   loc_354AA
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

loc_354AA:
                move.b  #$1F,y_radius(a0)
                move.b  #$A,x_radius(a0)
                jsr     (ProbeCeilingWithInsetHorizontalRadius).l
                tst.w   d1
                bpl.s   loc_354D2
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_354D0
                move.w  #0,y_vel(a0)

locret_354D0:
                rts
; ---------------------------------------------------------------------------

loc_354D2:
                tst.w   y_vel(a0)
                bmi.s   locret_35502
                jsr     (Sonic_CheckFloor).l
                tst.w   d1
                bpl.s   locret_35502
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                bclr    #1,status(a0)
                move.b  #0,$2D(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)

locret_35502:
                rts
; End of function ResolveAirborneTopPlatformTerrain

; =============== S U B R O U T I N E =======================================

ControlTopRiderGroundSpeed:
                move.w  #$600,d6
                move.w  #$C,d5
                move.w  #$80,d4
                btst    #$A,d3
                beq.s   loc_3551A
                bsr.w   AccelerateTopRiderLeft

loc_3551A:
                btst    #$B,d3
                beq.s   loc_35524
                bsr.w   AccelerateTopRiderRight

loc_35524:
                move.w  d3,d0
                andi.w  #$C00,d0
                bne.s   loc_3554E
                move.w  ground_vel(a0),d0
                beq.s   loc_3554E
                bmi.s   loc_35542
                sub.w   d5,d0
                bcc.s   loc_3553C
                move.w  #0,d0

loc_3553C:
                move.w  d0,ground_vel(a0)
                bra.s   loc_3554E
; ---------------------------------------------------------------------------

loc_35542:
                add.w   d5,d0
                bcc.s   loc_3554A
                move.w  #0,d0

loc_3554A:
                move.w  d0,ground_vel(a0)

loc_3554E:
                move.w  ground_vel(a0),x_vel(a0)
                move.w  #0,y_vel(a0)
                rts
; End of function ControlTopRiderGroundSpeed

; =============== S U B R O U T I N E =======================================

AccelerateTopRiderLeft:
                move.w  ground_vel(a0),d0
                beq.s   loc_35564
                bpl.s   loc_35596

loc_35564:
                bset    #0,status(a0)
                bne.s   loc_35578
                bclr    #5,status(a0)
                move.b  #1,prev_anim(a0)

loc_35578:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   loc_3558A
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   loc_3558A
                move.w  d1,d0

loc_3558A:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_35596:
                sub.w   d4,d0
                bcc.s   loc_3559E
                move.w  #-$80,d0

loc_3559E:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   locret_355E2
                cmpi.w  #$400,d0
                blt.s   locret_355E2
                move.b  #$D,anim(a0)
                bclr    #0,status(a0)
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                movea.l a0,a2
                suba.w  #Player_1,a2
                adda.w  #Dust,a2
                move.b  #6,routine(a2)
                move.b  #$15,mapping_frame(a2)

locret_355E2:
                rts
; End of function AccelerateTopRiderLeft

; =============== S U B R O U T I N E =======================================

AccelerateTopRiderRight:
                move.w  ground_vel(a0),d0
                bmi.s   loc_35618
                bclr    #0,status(a0)
                beq.s   loc_355FE
                bclr    #5,status(a0)
                move.b  #1,prev_anim(a0)

loc_355FE:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   loc_3560C
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   loc_3560C
                move.w  d6,d0

loc_3560C:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_35618:
                add.w   d4,d0
                bcc.s   loc_35620
                move.w  #$80,d0

loc_35620:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   locret_35664
                cmpi.w  #-$400,d0
                bgt.s   locret_35664
                move.b  #$D,anim(a0)
                bset    #0,status(a0)
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                movea.l a0,a2
                suba.w  #Player_1,a2
                adda.w  #Dust,a2
                move.b  #6,routine(a2)
                move.b  #$15,mapping_frame(a2)

locret_35664:
                rts
; End of function AccelerateTopRiderRight
