; Owner: game/collision/s3
; Responsibility: Wall height sampling and direction-dependent collision angle conversion
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

FindWall:
                lea     (Find_Tile_FG).l,a5
                tst.b   (Background_collision_flag).w
                beq.s   sub_10846
                bsr.s   sub_10846
                move.b  (a4),Primary_Angle_save-Primary_Angle(a4)
                move.w  d1,-(sp)
                move.w  a3,d0
                bpl.s   loc_1080E
                eori.w  #$F,d3
                sub.w   (Camera_X_diff).w,d3
                eori.w  #$F,d3
                bra.s   loc_10812
; ---------------------------------------------------------------------------

loc_1080E:
                sub.w   (Camera_X_diff).w,d3

loc_10812:
                sub.w   (Camera_Y_diff).w,d2
                lea     (Find_Tile_BG).l,a5
                bsr.s   sub_10846
                move.w  a3,d0
                bpl.s   loc_10830
                eori.w  #$F,d3
                add.w   (Camera_X_diff).w,d3
                eori.w  #$F,d3
                bra.s   loc_10834
; ---------------------------------------------------------------------------

loc_10830:
                add.w   (Camera_X_diff).w,d3

loc_10834:
                add.w   (Camera_Y_diff).w,d2
                move.w  (sp)+,d0
                cmp.w   d0,d1
                ble.s   locret_10844
                move.b  Primary_Angle_save-Primary_Angle(a4),(a4)
                move.w  d0,d1

locret_10844:
                rts
; End of function FindWall

; =============== S U B R O U T I N E =======================================

sub_10846:
                jsr     (a5)
                move.w  (a1),d0
                move.w  d0,d4
                andi.w  #$3FF,d0
                beq.s   loc_10856
                btst    d5,d4
                bne.s   loc_10864

loc_10856:
                add.w   a3,d3
                bsr.w   sub_108EA
                sub.w   a3,d3
                addi.w  #$10,d1
                rts
; ---------------------------------------------------------------------------

loc_10864:
                movea.l (Collision_addr).w,a2
                add.w   d0,d0
                move.w  (a2,d0.w),d0
                beq.s   loc_10856
                lea     (AngleArray).l,a2
                move.b  (a2,d0.w),(a4)
                lsl.w   #4,d0
                move.w  d2,d1
                btst    #$B,d4
                beq.s   loc_10890
                not.w   d1
                addi.b  #$40,(a4)
                neg.b   (a4)
                subi.b  #$40,(a4)

loc_10890:
                btst    #$A,d4
                beq.s   loc_10898
                neg.b   (a4)

loc_10898:
                andi.w  #$F,d1
                add.w   d0,d1
                lea     (HeightMapsRot).l,a2
                move.b  (a2,d1.w),d0
                ext.w   d0
                eor.w   d6,d4
                btst    #$A,d4
                beq.s   loc_108B4
                neg.w   d0

loc_108B4:
                tst.w   d0
                beq.s   loc_10856
                bmi.s   loc_108D0
                cmpi.b  #$10,d0
                beq.s   loc_108DC
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                move.w  #$F,d1
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

loc_108D0:
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                bpl.w   loc_10856

loc_108DC:
                sub.w   a3,d3
                bsr.w   sub_108EA
                add.w   a3,d3
                subi.w  #$10,d1
                rts
; End of function sub_10846

; =============== S U B R O U T I N E =======================================

sub_108EA:
                jsr     (a5)
                move.w  (a1),d0
                move.w  d0,d4
                andi.w  #$3FF,d0
                beq.s   loc_108FA
                btst    d5,d4
                bne.s   loc_10908

loc_108FA:
                move.w  #$F,d1
                move.w  d3,d0
                andi.w  #$F,d0
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

loc_10908:
                movea.l (Collision_addr).w,a2
                add.w   d0,d0
                move.w  (a2,d0.w),d0
                beq.s   loc_108FA
                lea     (AngleArray).l,a2
                move.b  (a2,d0.w),(a4)
                lsl.w   #4,d0
                move.w  d2,d1
                btst    #$B,d4
                beq.s   loc_10934
                not.w   d1
                addi.b  #$40,(a4)
                neg.b   (a4)
                subi.b  #$40,(a4)

loc_10934:
                btst    #$A,d4
                beq.s   loc_1093C
                neg.b   (a4)

loc_1093C:
                andi.w  #$F,d1
                add.w   d0,d1
                lea     (HeightMapsRot).l,a2
                move.b  (a2,d1.w),d0
                ext.w   d0
                eor.w   d6,d4
                btst    #$A,d4
                beq.s   loc_10958
                neg.w   d0

loc_10958:
                tst.w   d0
                beq.s   loc_108FA
                bmi.s   loc_1096E
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                move.w  #$F,d1
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

loc_1096E:
                move.w  d3,d1
                andi.w  #$F,d1
                add.w   d1,d0
                bpl.w   loc_108FA
                not.w   d1
                rts
; End of function sub_108EA

; =============== S U B R O U T I N E =======================================

ConvertCollisionArray:
                rts
; End of function ConvertCollisionArray

; =============== S U B R O U T I N E =======================================

sub_10980:
                tst.w   (Competition_mode).w
                bne.w   sub_10A10
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_1099C
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_1099C:
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
                bpl.s   loc_109DC
                move.b  d1,d0
                bpl.s   loc_109D6
                subq.b  #1,d0

loc_109D6:
                addi.b  #$20,d0
                bra.s   loc_109E6
; ---------------------------------------------------------------------------

loc_109DC:
                move.b  d1,d0
                bpl.s   loc_109E2
                addq.b  #1,d0

loc_109E2:
                addi.b  #$1F,d0

loc_109E6:
                andi.b  #$C0,d0
                beq.w   CheckFloorDist_Part2
                cmpi.b  #$80,d0
                beq.w   CheckCeilingDist_Part2
                tst.w   (Competition_mode).w
                bne.s   loc_10A04
                andi.b  #$38,d1
                bne.s   loc_10A04
                addq.w  #8,d2

loc_10A04:
                cmpi.b  #$40,d0
                beq.w   loc_11084
                bra.w   loc_10DE4
; End of function sub_10980

; =============== S U B R O U T I N E =======================================

sub_10A10:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   loc_10A24
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

loc_10A24:
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
                bpl.s   loc_10A64
                move.b  d1,d0
                bpl.s   loc_10A5E
                subq.b  #1,d0

loc_10A5E:
                addi.b  #$20,d0
                bra.s   loc_10A6E
; ---------------------------------------------------------------------------

loc_10A64:
                move.b  d1,d0
                bpl.s   loc_10A6A
                addq.b  #1,d0

loc_10A6A:
                addi.b  #$1F,d0

loc_10A6E:
                andi.b  #$C0,d0
                beq.w   sub_10B84
                cmpi.b  #$80,d0
                beq.w   CheckCeilingDist_WithRadius
                cmpi.b  #$40,d0
                beq.w   loc_110A4
                bra.w   loc_10E00
; End of function sub_10A10
