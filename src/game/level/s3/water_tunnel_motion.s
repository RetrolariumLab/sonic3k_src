; Owner: game/level/s3
; Responsibility: Hydrocity water tunnel detection, movement helpers and water-region player response
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Select the tunnel flag for the player mode. The matched rectangle allows one-pixel steering across the current
S3HCZ_ApplyWaterTunnelCurrents:
                tst.w   (Debug_placement_mode).w
                bne.w   locret_54A4
                cmpi.b  #1,(Current_zone).w
                bne.w   locret_54A4
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_53D2
                lea     (WindTunnel_flag).w,a3
                lea     (Player_1).w,a1
                move.b  (Ctrl_1_held_logical).w,d6
                moveq   #0,d5
                bsr.s   HCZ_WaterTunnels
                addq.w  #1,a3
                lea     (Player_2).w,a1
                move.b  (Ctrl_2_held_logical).w,d6
                moveq   #1,d5
                bra.s   HCZ_WaterTunnels
; ---------------------------------------------------------------------------

loc_53D2:
                lea     (WindTunnel_flag_P2).w,a3
                lea     (Player_1).w,a1
                move.b  (Ctrl_1_held_logical).w,d6
                moveq   #0,d5
; End of function S3HCZ_ApplyWaterTunnelCurrents

; =============== S U B R O U T I N E =======================================

HCZ_WaterTunnels:
                lea     (HCZ1_WaterTunLocs).l,a2
                tst.b   (Current_act).w
                beq.s   loc_53F2
                lea     (HCZ2_WaterTunLocs).l,a2

loc_53F2:
                move.w  (a2)+,d2

loc_53F4:
                move.w  x_pos(a1),d0
                cmp.w   (a2),d0
                blo.w   loc_5490
                cmp.w   4(a2),d0
                bhs.w   loc_5490
                move.w  y_pos(a1),d1
                cmp.w   2(a2),d1
                blo.w   loc_5490
                cmp.w   6(a2),d1
                bhs.s   loc_5490
                cmpi.b  #4,routine(a1)
                bhs.w   loc_54A2
                btst    d5,(_unkF7C7).w
                bne.s   locret_5478
                tst.b   object_control(a1)
                bne.s   loc_54A2
                move.b  #1,(a3)
                move.w  8(a2),d0
                move.w  d0,x_vel(a1)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a1)
                move.w  $A(a2),d1
                move.w  d1,y_vel(a1)
                ext.l   d1
                lsl.l   #8,d1
                add.l   d1,y_pos(a1)
                move.b  #$F,anim(a1)
                bset    #Status_InAir,status(a1)
                tst.b   $C(a2)
                bne.s   loc_547A
                btst    #button_up,d6
                beq.s   loc_546E
                subq.w  #1,y_pos(a1)

loc_546E:
                btst    #button_down,d6
                beq.s   locret_5478
                addq.w  #1,y_pos(a1)

locret_5478:
                rts
; ---------------------------------------------------------------------------

loc_547A:
                btst    #button_left,d6
                beq.s   loc_5484
                subq.w  #1,x_pos(a1)

loc_5484:
                btst    #button_right,d6
                beq.s   locret_548E
                addq.w  #1,x_pos(a1)

locret_548E:
                rts
; ---------------------------------------------------------------------------

loc_5490:
                adda.w  #$E,a2
                dbf     d2,loc_53F4
                tst.b   (a3)
                beq.s   locret_54A4
                move.b  #$1A,anim(a1)

loc_54A2:
                clr.b   (a3)

locret_54A4:
                rts
; End of function HCZ_WaterTunnels

; ---------------------------------------------------------------------------
HCZ1_WaterTunLocs:
                dc.w    $F-1
                dc.w    $380,  $580,  $5A0,  $5C0,  $3F0,  -$20,     0  ; Min X, Min Y, Max X, Max Y, X Velo, Y Velo, Player can influence which axis flag (Set = X, Clear = Y)
                dc.w    $5A0,  $560,  $A80,  $5C0,  $3F0,  -$10,     0
                dc.w    $1400,  $A80, $15A0,  $AC0,  $400,     0,     0
                dc.w    $15A0,  $A40, $1960,  $AC0,  $400,  -$40,     0
                dc.w    $1990,  $780, $19E0,  $7F0,     0, -$400,  $100
                dc.w    $1990,  $7F0, $19F0,  $878, -$140, -$400,  $100
                dc.w    $1990,  $878, $19F0,  $8FD,  $140, -$400,  $100
                dc.w    $1990,  $8FD, $19F0,  $978, -$140, -$400,  $100
                dc.w    $1990,  $978, $19F0,  $A10,  $100, -$400,  $100
                dc.w    $1960,  $A10, $19D0,  $A80,  $300, -$280,  $100
                dc.w    $2B00,  $800, $2C20,  $840,  $400,     0,     0
                dc.w    $2C20,  $7C0, $2EE0,  $840,  $400,  -$40,     0
                dc.w    $2EE0,  $790, $2F50,  $800,  $300, -$300,  $100
                dc.w    $2F00,  $700, $2F70,  $790,  $100, -$400,  $100
                dc.w    $2F30,  $680, $2F70,  $700,     0, -$400,  $100
HCZ2_WaterTunLocs:
                dc.w    2-1
                dc.w    $3980,  $800, $3AA0,  $840,  $400,     0,     0
                dc.w    $3AA0,  $7C0, $3F00,  $840,  $400,  -$40,     0

; =============== S U B R O U T I N E =======================================

; Dispatch forced ground motion for Hydrocity 2 and IceCap 1
S3Surface_DispatchBothPlayers:
                cmpi.w  #$101,(Current_zone_and_act).w
                beq.s   loc_55AA
                cmpi.w  #$500,(Current_zone_and_act).w
                beq.s   loc_5612
                rts
; ---------------------------------------------------------------------------

loc_55AA:
                lea     (Player_1).w,a1
                move.b  (Ctrl_1_held_logical).w,d2
                bsr.s   S3HCZ2_ApplyChunkGroundCurrent
                lea     (Player_2).w,a1
                move.b  (Ctrl_2_held_logical).w,d2
; End of function S3Surface_DispatchBothPlayers

; =============== S U B R O U T I N E =======================================

; On the selected chunks, force inertia toward negative eight pixels per frame
S3HCZ2_ApplyChunkGroundCurrent:
                btst    #Status_InAir,status(a1)
                bne.s   loc_55F8
                cmpi.b  #$C,top_solid_bit(a1)
                beq.s   loc_55F8
                lea     (Level_layout_header).w,a2
                move.w  y_pos(a1),d0
                lsr.w   #5,d0
                and.w   (Layout_row_index_mask).w,d0
                move.w  8(a2,d0.w),d0
                move.w  x_pos(a1),d1
                lsr.w   #7,d1
                add.w   d1,d0
                movea.w d0,a2
                move.b  (a2),d0
                lea     byte_574E(pc),a2
                moveq   #(byte_574E-byte_5744)-1,d1

loc_55F0:
                cmp.b   -(a2),d0
                dbeq    d1,loc_55F0
                beq.s   loc_560C

loc_55F8:
                tst.b   status_secondary(a1)
                bpl.s   locret_560A
                move.w  #5,move_lock(a1)
                andi.b  #$7F,status_secondary(a1)

locret_560A:
                rts
; ---------------------------------------------------------------------------

loc_560C:
                moveq   #-8,d0
                bra.w   loc_567E
; End of function S3HCZ2_ApplyChunkGroundCurrent

; ---------------------------------------------------------------------------

loc_5612:
                lea     (Player_1).w,a1
                move.b  (Ctrl_1_held_logical).w,d2
                bsr.s   S3ICZ1_ApplyChunkGroundSkid
                lea     (Player_2).w,a1
                move.b  (Ctrl_2_held_logical).w,d2

; =============== S U B R O U T I N E =======================================

; The chunk selects the direction and target speed. A zero target takes the shared friction path
S3ICZ1_ApplyChunkGroundSkid:
                btst    #Status_InAir,status(a1)
                bne.s   loc_5660
                btst    #Status_OnObj,status(a1)
                bne.s   loc_5660
                lea     (Level_layout_header).w,a2
                move.w  y_pos(a1),d0
                lsr.w   #5,d0
                and.w   (Layout_row_index_mask).w,d0
                move.w  8(a2,d0.w),d0
                move.w  x_pos(a1),d1
                lsr.w   #7,d1
                add.w   d1,d0
                movea.w d0,a2
                move.b  (a2),d0
                lea     WaterTransition_AIZ1(pc),a2
                moveq   #(WaterTransition_AIZ1-byte_574E)-1,d1

loc_5658:
                cmp.b   -(a2),d0
                dbeq    d1,loc_5658
                beq.s   loc_5674

loc_5660:
                tst.b   status_secondary(a1)
                bpl.s   locret_5672
                move.w  #5,move_lock(a1)
                andi.b  #$7F,status_secondary(a1)

locret_5672:
                rts
; ---------------------------------------------------------------------------

loc_5674:
                lea     (byte_573A).l,a2
                move.b  (a2,d1.w),d0

loc_567E:
                beq.s   loc_56CA
                move.b  ground_vel(a1),d1
                tst.b   d0
                bpl.s   loc_5694
                cmp.b   d0,d1
                ble.s   loc_569E
                subi.w  #$40,ground_vel(a1)
                bra.s   loc_569E
; ---------------------------------------------------------------------------

loc_5694:
                cmp.b   d0,d1
                bge.s   loc_569E
                addi.w  #$40,ground_vel(a1)

loc_569E:
                bclr    #Status_Facing,status(a1)
                tst.b   d1
                bpl.s   loc_56AE
                bset    #Status_Facing,status(a1)

loc_56AE:
                move.b  #$1B,anim(a1)
                cmpi.b  #5,(Current_zone).w
                bne.s   loc_56C2
                move.b  #$19,anim(a1)

loc_56C2:
                ori.b   #$80,status_secondary(a1)
                rts
; ---------------------------------------------------------------------------

loc_56CA:
                move.w  #4,d1
                move.w  ground_vel(a1),d0
                btst    #button_left,d2
                beq.s   loc_56EC
                move.b  #0,anim(a1)
                bset    #Status_Facing,status(a1)
                sub.w   d1,d0
                tst.w   d0
                bpl.s   loc_56EC
                sub.w   d1,d0

loc_56EC:
                btst    #button_right,d2
                beq.s   loc_5706
                move.b  #0,anim(a1)
                bclr    #Status_Facing,status(a1)
                add.w   d1,d0
                tst.w   d0
                bmi.s   loc_5706
                add.w   d1,d0

loc_5706:
                move.w  #4,d1
                tst.w   d0
                beq.s   loc_572E
                bmi.s   loc_5720
                sub.w   d1,d0
                bhi.s   loc_571E
                move.w  #0,d0
                move.b  #5,anim(a1)

loc_571E:
                bra.s   loc_572E
; ---------------------------------------------------------------------------

loc_5720:
                add.w   d1,d0
                bhi.s   loc_572E
                move.w  #0,d0
                move.b  #5,anim(a1)

loc_572E:
                move.w  d0,ground_vel(a1)
                ori.b   #$80,status_secondary(a1)
                rts
; End of function S3ICZ1_ApplyChunkGroundSkid
