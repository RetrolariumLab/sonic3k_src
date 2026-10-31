; Owner: game/collision/sk
; Responsibility: Foreground/background chunk addressing and floor height sampling for players, objects and rings
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
; GetFloorPosition_BG
Find_Tile_BG:
                lea     (Level_layout_header).w,a1
                move.w  d2,d0
                lsr.w   #5,d0
                and.w   (Layout_row_index_mask).w,d0
                move.w  $A(a1,d0.w),d0
                move.w  d3,d1
                lsr.w   #3,d1
                move.w  d1,d4
                lsr.w   #4,d1
                add.w   d1,d0
                moveq   #-1,d1
                clr.w   d1
                movea.w d0,a1
                move.b  (a1),d1
                add.w   d1,d1
                move.w  ChunkAddrArray(pc,d1.w),d1
                move.w  d2,d0
                andi.w  #$70,d0
                add.w   d0,d1
                andi.w  #$E,d4
                add.w   d4,d1
                movea.l d1,a1
                rts
; ---------------------------------------------------------------------------
; GetFloorPosition_FG
Find_Tile_FG:
                lea     (Level_layout_header).w,a1
                move.w  d2,d0
                lsr.w   #5,d0
                and.w   (Layout_row_index_mask).w,d0
                move.w  8(a1,d0.w),d0
                move.w  d3,d1
                lsr.w   #3,d1
                move.w  d1,d4
                lsr.w   #4,d1
                add.w   d1,d0
                moveq   #-1,d1
                clr.w   d1
                movea.w d0,a1
                move.b  (a1),d1
                add.w   d1,d1
                move.w  ChunkAddrArray(pc,d1.w),d1
                move.w  d2,d0
                andi.w  #$70,d0
                add.w   d0,d1
                andi.w  #$E,d4
                add.w   d4,d1
                movea.l d1,a1
                rts
; ---------------------------------------------------------------------------
ChunkAddrArray:
                dc.w    0,  $80, $100, $180, $200, $280, $300, $380, $400, $480, $500, $580, $600, $680, $700, $780
                dc.w    $800, $880, $900, $980, $A00, $A80, $B00, $B80, $C00, $C80, $D00, $D80, $E00, $E80, $F00, $F80
                dc.w    $1000,$1080,$1100,$1180,$1200,$1280,$1300,$1380,$1400,$1480,$1500,$1580,$1600,$1680,$1700,$1780
                dc.w    $1800,$1880,$1900,$1980,$1A00,$1A80,$1B00,$1B80,$1C00,$1C80,$1D00,$1D80,$1E00,$1E80,$1F00,$1F80
                dc.w    $2000,$2080,$2100,$2180,$2200,$2280,$2300,$2380,$2400,$2480,$2500,$2580,$2600,$2680,$2700,$2780
                dc.w    $2800,$2880,$2900,$2980,$2A00,$2A80,$2B00,$2B80,$2C00,$2C80,$2D00,$2D80,$2E00,$2E80,$2F00,$2F80
                dc.w    $3000,$3080,$3100,$3180,$3200,$3280,$3300,$3380,$3400,$3480,$3500,$3580,$3600,$3680,$3700,$3780
                dc.w    $3800,$3880,$3900,$3980,$3A00,$3A80,$3B00,$3B80,$3C00,$3C80,$3D00,$3D80,$3E00,$3E80,$3F00,$3F80
                dc.w    $4000,$4080,$4100,$4180,$4200,$4280,$4300,$4380,$4400,$4480,$4500,$4580,$4600,$4680,$4700,$4780
                dc.w    $4800,$4880,$4900,$4980,$4A00,$4A80,$4B00,$4B80,$4C00,$4C80,$4D00,$4D80,$4E00,$4E80,$4F00,$4F80
                dc.w    $5000,$5080,$5100,$5180,$5200,$5280,$5300,$5380,$5400,$5480,$5500,$5580,$5600,$5680,$5700,$5780
                dc.w    $5800,$5880,$5900,$5980,$5A00,$5A80,$5B00,$5B80,$5C00,$5C80,$5D00,$5D80,$5E00,$5E80,$5F00,$5F80
                dc.w    $6000,$6080,$6100,$6180,$6200,$6280,$6300,$6380,$6400,$6480,$6500,$6580,$6600,$6680,$6700,$6780
                dc.w    $6800,$6880,$6900,$6980,$6A00,$6A80,$6B00,$6B80,$6C00,$6C80,$6D00,$6D80,$6E00,$6E80,$6F00,$6F80
                dc.w    $7000,$7080,$7100,$7180,$7200,$7280,$7300,$7380,$7400,$7480,$7500,$7580,$7600,$7680,$7700,$7780
                dc.w    $7800,$7880,$7900,$7980,$7A00,$7A80,$7B00,$7B80,$7C00,$7C80,$7D00,$7D80,$7E00,$7E80,$7F00,$7F80

; =============== S U B R O U T I N E =======================================

FindFloor:
                lea     (Find_Tile_FG).l,a5
                tst.b   (Background_collision_flag).w
                beq.s   sub_F264
                bsr.s   sub_F264
                move.b  (a4),Primary_Angle_save-Primary_Angle(a4)
                move.w  d1,-(sp)
                sub.w   (Camera_X_diff).w,d3
                sub.w   (Camera_Y_diff).w,d2
                lea     (Find_Tile_BG).l,a5
                bsr.s   sub_F264
                add.w   (Camera_X_diff).w,d3
                add.w   (Camera_Y_diff).w,d2
                move.w  (sp)+,d0
                cmp.w   d0,d1
                ble.s   locret_F262
                move.b  Primary_Angle_save-Primary_Angle(a4),(a4)
                move.w  d0,d1

locret_F262:
                rts
; End of function FindFloor

; =============== S U B R O U T I N E =======================================

sub_F264:
                jsr     (a5)
                move.w  (a1),d0
                move.w  d0,d4
                andi.w  #$3FF,d0
                beq.s   loc_F274
                btst    d5,d4
                bne.s   loc_F282

loc_F274:
                add.w   a3,d2
                bsr.w   sub_F30C
                sub.w   a3,d2
                addi.w  #$10,d1
                rts
; ---------------------------------------------------------------------------

loc_F282:
                movea.l (Collision_addr).w,a2
                add.w   d0,d0
                move.b  (a2,d0.w),d0
                andi.w  #$FF,d0
                beq.s   loc_F274
                lea     (AngleArray).l,a2
                move.b  (a2,d0.w),(a4)
                lsl.w   #4,d0
                move.w  d3,d1
                btst    #$A,d4
                beq.s   loc_F2AA
                not.w   d1
                neg.b   (a4)

loc_F2AA:
                btst    #$B,d4
                beq.s   loc_F2BA
                addi.b  #$40,(a4)
                neg.b   (a4)
                subi.b  #$40,(a4)

loc_F2BA:
                andi.w  #$F,d1
                add.w   d0,d1
                lea     (HeightMaps).l,a2
                move.b  (a2,d1.w),d0
                ext.w   d0
                eor.w   d6,d4
                btst    #$B,d4
                beq.s   loc_F2D6
                neg.w   d0

loc_F2D6:
                tst.w   d0
                beq.s   loc_F274
                bmi.s   loc_F2F2
                cmpi.b  #$10,d0
                beq.s   loc_F2FE
                move.w  d2,d1
                andi.w  #$F,d1
                add.w   d1,d0
                move.w  #$F,d1
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

loc_F2F2:
                move.w  d2,d1
                andi.w  #$F,d1
                add.w   d1,d0
                bpl.w   loc_F274

loc_F2FE:
                sub.w   a3,d2
                bsr.w   sub_F30C
                add.w   a3,d2
                subi.w  #$10,d1
                rts
; End of function sub_F264

; =============== S U B R O U T I N E =======================================

sub_F30C:
                jsr     (a5)
                move.w  (a1),d0
                move.w  d0,d4
                andi.w  #$3FF,d0
                beq.s   loc_F31C
                btst    d5,d4
                bne.s   loc_F32A

loc_F31C:
                move.w  #$F,d1
                move.w  d2,d0
                andi.w  #$F,d0
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

loc_F32A:
                movea.l (Collision_addr).w,a2
                add.w   d0,d0
                move.b  (a2,d0.w),d0
                andi.w  #$FF,d0
                beq.s   loc_F31C
                lea     (AngleArray).l,a2
                move.b  (a2,d0.w),(a4)
                lsl.w   #4,d0
                move.w  d3,d1
                btst    #$A,d4
                beq.s   loc_F352
                not.w   d1
                neg.b   (a4)

loc_F352:
                btst    #$B,d4
                beq.s   loc_F362
                addi.b  #$40,(a4)
                neg.b   (a4)
                subi.b  #$40,(a4)

loc_F362:
                andi.w  #$F,d1
                add.w   d0,d1
                lea     (HeightMaps).l,a2
                move.b  (a2,d1.w),d0
                ext.w   d0
                eor.w   d6,d4
                btst    #$B,d4
                beq.s   loc_F37E
                neg.w   d0

loc_F37E:
                tst.w   d0
                beq.s   loc_F31C
                bmi.s   loc_F394
                move.w  d2,d1
                andi.w  #$F,d1
                add.w   d1,d0
                move.w  #$F,d1
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

loc_F394:
                move.w  d2,d1
                andi.w  #$F,d1
                add.w   d1,d0
                bpl.w   loc_F31C
                not.w   d1
                rts
; End of function sub_F30C

; ---------------------------------------------------------------------------
; loc_F3A4
Ring_FindFloor:
                lea     (Find_Tile_FG).l,a5
                tst.b   (Background_collision_flag).w
                beq.s   sub_F3DE
                bsr.s   sub_F3DE
                move.b  (a4),Primary_Angle_save-Primary_Angle(a4)
                move.w  d1,-(sp)
                sub.w   (Camera_X_diff).w,d3
                sub.w   (Camera_Y_diff).w,d2
                lea     (Find_Tile_BG).l,a5
                bsr.s   sub_F3DE
                add.w   (Camera_X_diff).w,d3
                add.w   (Camera_Y_diff).w,d2
                move.w  (sp)+,d0
                cmp.w   d0,d1
                ble.s   locret_F3DC
                move.b  Primary_Angle_save-Primary_Angle(a4),(a4)
                move.w  d0,d1

locret_F3DC:
                rts

; =============== S U B R O U T I N E =======================================

sub_F3DE:
                jsr     (a5)
                move.w  (a1),d0
                move.w  d0,d4
                andi.w  #$3FF,d0
                beq.s   loc_F3EE
                btst    d5,d4
                bne.s   loc_F3F4

loc_F3EE:
                move.w  #$10,d1
                rts
; ---------------------------------------------------------------------------

loc_F3F4:
                movea.l (Collision_addr).w,a2
                add.w   d0,d0
                move.b  (a2,d0.w),d0
                andi.w  #$FF,d0
                beq.s   loc_F3EE
                lea     (AngleArray).l,a2
                move.b  (a2,d0.w),(a4)
                lsl.w   #4,d0
                move.w  d3,d1
                btst    #$A,d4
                beq.s   loc_F41C
                not.w   d1
                neg.b   (a4)

loc_F41C:
                btst    #$B,d4
                beq.s   loc_F42C
                addi.b  #$40,(a4)
                neg.b   (a4)
                subi.b  #$40,(a4)

loc_F42C:
                andi.w  #$F,d1
                add.w   d0,d1
                lea     (HeightMaps).l,a2
                move.b  (a2,d1.w),d0
                ext.w   d0
                eor.w   d6,d4
                btst    #$B,d4
                beq.s   loc_F448
                neg.w   d0

loc_F448:
                tst.w   d0
                beq.s   loc_F3EE
                bmi.s   loc_F464
                cmpi.b  #$10,d0
                beq.s   loc_F470
                move.w  d2,d1
                andi.w  #$F,d1
                add.w   d1,d0
                move.w  #$F,d1
                sub.w   d0,d1
                rts
; ---------------------------------------------------------------------------

loc_F464:
                move.w  d2,d1
                andi.w  #$F,d1
                add.w   d1,d0
                bpl.w   loc_F3EE

loc_F470:
                sub.w   a3,d2
                bsr.w   sub_F30C
                add.w   a3,d2
                subi.w  #$10,d1
                rts
; End of function sub_F3DE
