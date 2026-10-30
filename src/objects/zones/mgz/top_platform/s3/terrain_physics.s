; Owner: objects/zones/mgz/top_platform/s3
; Responsibility: Marble Garden spinning top terrain contact, slope handling, acceleration and braking
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_347FC:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_34810
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_34810:
                move.b  lrb_solid_bit(a0),d5
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                subi.b  #$20,d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   loc_34900
                cmpi.b  #$80,d0
                beq.w   loc_3498A
                cmpi.b  #-$40,d0
                beq.w   loc_34A0C
                move.b  #$C,y_radius(a0)
                move.b  #$18,x_radius(a0)
                jsr     (sub_1100E).l
                tst.w   d1
                bpl.s   loc_34862
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_34862:
                jsr     (sub_10D76).l
                tst.w   d1
                bpl.s   loc_34876
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_34876:
                move.b  #$1F,y_radius(a0)
                move.b  #$A,x_radius(a0)
                jsr     (Sonic_CheckFloor).l
                tst.w   d1
                bpl.s   locret_348FE
                move.b  y_vel(a0),d2
                addq.b  #8,d2
                neg.b   d2
                cmp.b   d2,d1
                bge.s   loc_3489C
                cmp.b   d2,d0
                blt.s   locret_348FE

loc_3489C:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                bclr    #1,status(a0)
                move.b  #0,$2D(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   loc_348DC
                move.b  d3,d0
                addi.b  #$10,d0
                andi.b  #$20,d0
                beq.s   loc_348CE
                asr     y_vel(a0)
                bra.s   loc_348F0
; ---------------------------------------------------------------------------

loc_348CE:
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_348DC:
                move.w  #0,x_vel(a0)
                cmpi.w  #$FC0,y_vel(a0)
                ble.s   loc_348F0
                move.w  #$FC0,y_vel(a0)

loc_348F0:
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   locret_348FE
                neg.w   ground_vel(a0)

locret_348FE:
                rts
; ---------------------------------------------------------------------------

loc_34900:
                move.b  #$C,y_radius(a0)
                move.b  #$18,x_radius(a0)
                jsr     (sub_1100E).l
                tst.w   d1
                bpl.s   loc_34930
                sub.w   d1,x_pos(a0)
                addi.b  #$30,d3
                cmpi.b  #$60,d3
                blo.s   loc_34930
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

loc_34930:
                move.b  #$1F,y_radius(a0)
                move.b  #$A,x_radius(a0)
                jsr     (sub_10EB6).l
                tst.w   d1
                bpl.s   loc_34958
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_34956
                move.w  #0,y_vel(a0)

locret_34956:
                rts
; ---------------------------------------------------------------------------

loc_34958:
                tst.w   y_vel(a0)
                bmi.s   locret_34988
                jsr     (Sonic_CheckFloor).l
                tst.w   d1
                bpl.s   locret_34988
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                bclr    #1,status(a0)
                move.b  #0,$2D(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)

locret_34988:
                rts
; ---------------------------------------------------------------------------

loc_3498A:
                move.b  #$C,y_radius(a0)
                move.b  #$18,x_radius(a0)
                jsr     (sub_1100E).l
                tst.w   d1
                bpl.s   loc_349AA
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_349AA:
                jsr     (sub_10D76).l
                tst.w   d1
                bpl.s   loc_349BE
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_349BE:
                move.b  #$1F,y_radius(a0)
                move.b  #$A,x_radius(a0)
                jsr     (sub_10EB6).l
                tst.w   d1
                bpl.s   locret_34A0A
                sub.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   loc_349EC
                move.w  #0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_349EC:
                move.b  d3,angle(a0)
                bclr    #1,status(a0)
                move.b  #0,$2D(a0)
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   locret_34A0A
                neg.w   ground_vel(a0)

locret_34A0A:
                rts
; ---------------------------------------------------------------------------

loc_34A0C:
                move.b  #$C,y_radius(a0)
                move.b  #$18,x_radius(a0)
                jsr     (sub_10D76).l
                tst.w   d1
                bpl.s   loc_34A3C
                add.w   d1,x_pos(a0)
                addi.b  #$30,d3
                cmpi.b  #$60,d3
                blo.s   loc_34A3C
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

loc_34A3C:
                move.b  #$1F,y_radius(a0)
                move.b  #$A,x_radius(a0)
                jsr     (sub_10EB6).l
                tst.w   d1
                bpl.s   loc_34A64
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_34A62
                move.w  #0,y_vel(a0)

locret_34A62:
                rts
; ---------------------------------------------------------------------------

loc_34A64:
                tst.w   y_vel(a0)
                bmi.s   locret_34A94
                jsr     (Sonic_CheckFloor).l
                tst.w   d1
                bpl.s   locret_34A94
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                bclr    #1,status(a0)
                move.b  #0,$2D(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)

locret_34A94:
                rts
; End of function sub_347FC

; =============== S U B R O U T I N E =======================================

sub_34A96:
                move.w  #$600,d6
                move.w  #$C,d5
                move.w  #$80,d4
                btst    #$A,d3
                beq.s   loc_34AAC
                bsr.w   sub_34AEE

loc_34AAC:
                btst    #$B,d3
                beq.s   loc_34AB6
                bsr.w   sub_34B76

loc_34AB6:
                move.w  d3,d0
                andi.w  #$C00,d0
                bne.s   loc_34AE0
                move.w  ground_vel(a0),d0
                beq.s   loc_34AE0
                bmi.s   loc_34AD4
                sub.w   d5,d0
                bcc.s   loc_34ACE
                move.w  #0,d0

loc_34ACE:
                move.w  d0,ground_vel(a0)
                bra.s   loc_34AE0
; ---------------------------------------------------------------------------

loc_34AD4:
                add.w   d5,d0
                bcc.s   loc_34ADC
                move.w  #0,d0

loc_34ADC:
                move.w  d0,ground_vel(a0)

loc_34AE0:
                move.w  ground_vel(a0),x_vel(a0)
                move.w  #0,y_vel(a0)
                rts
; End of function sub_34A96

; =============== S U B R O U T I N E =======================================

sub_34AEE:
                move.w  ground_vel(a0),d0
                beq.s   loc_34AF6
                bpl.s   loc_34B28

loc_34AF6:
                bset    #0,status(a0)
                bne.s   loc_34B0A
                bclr    #5,status(a0)
                move.b  #1,prev_anim(a0)

loc_34B0A:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   loc_34B1C
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   loc_34B1C
                move.w  d1,d0

loc_34B1C:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_34B28:
                sub.w   d4,d0
                bcc.s   loc_34B30
                move.w  #-$80,d0

loc_34B30:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   locret_34B74
                cmpi.w  #$400,d0
                blt.s   locret_34B74
                move.b  #$D,anim(a0)
                bclr    #0,status(a0)
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                movea.l a0,a2
                suba.w  #Player_1,a2
                adda.w  #Dust,a2
                move.b  #6,routine(a2)
                move.b  #$15,mapping_frame(a2)

locret_34B74:
                rts
; End of function sub_34AEE

; =============== S U B R O U T I N E =======================================

sub_34B76:
                move.w  ground_vel(a0),d0
                bmi.s   loc_34BAA
                bclr    #0,status(a0)
                beq.s   loc_34B90
                bclr    #5,status(a0)
                move.b  #1,prev_anim(a0)

loc_34B90:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   loc_34B9E
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   loc_34B9E
                move.w  d6,d0

loc_34B9E:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_34BAA:
                add.w   d4,d0
                bcc.s   loc_34BB2
                move.w  #$80,d0

loc_34BB2:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   locret_34BF6
                cmpi.w  #-$400,d0
                bgt.s   locret_34BF6
                move.b  #$D,anim(a0)
                bset    #0,status(a0)
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                movea.l a0,a2
                suba.w  #Player_1,a2
                adda.w  #Dust,a2
                move.b  #6,routine(a2)
                move.b  #$15,mapping_frame(a2)

locret_34BF6:
                rts
; End of function sub_34B76
