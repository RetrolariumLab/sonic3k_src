; Owner: game/level/sk
; Responsibility: Hydrocity water tunnel detection, movement helpers and water-region player response
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Select the tunnel flag for the player mode. The matched rectangle allows one-pixel steering across the current
SKHCZ_ApplyWaterTunnelCurrents:
                tst.w   (Debug_placement_mode).w
                bne.w   locret_705A
                cmpi.b  #1,(Current_zone).w
                bne.w   locret_705A
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_6F82
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

loc_6F82:
                lea     (WindTunnel_flag_P2).w,a3
                lea     (Player_1).w,a1
                move.b  (Ctrl_1_held_logical).w,d6
                moveq   #0,d5
; End of function SKHCZ_ApplyWaterTunnelCurrents

; =============== S U B R O U T I N E =======================================

HCZ_WaterTunnels:
                lea     (HCZ1_WaterTunLocs).l,a2
                tst.b   (Current_act).w
                beq.s   loc_6FA2
                lea     (HCZ2_WaterTunLocs).l,a2

loc_6FA2:
                move.w  (a2)+,d2

loc_6FA4:
                move.w  x_pos(a1),d0
                cmp.w   (a2),d0
                blo.w   loc_7046
                cmp.w   4(a2),d0
                bhs.w   loc_7046
                move.w  y_pos(a1),d1
                cmp.w   2(a2),d1
                blo.w   loc_7046
                cmp.w   6(a2),d1
                bhs.s   loc_7046
                cmpi.b  #4,routine(a1)
                bhs.w   loc_7058
                btst    d5,(_unkF7C7).w
                bne.s   locret_702E
                tst.b   object_control(a1)
                bne.s   loc_7058
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
                move.b  #0,double_jump_flag(a1)
                tst.b   $C(a2)
                bne.s   loc_7030
                btst    #button_up,d6
                beq.s   loc_7024
                subq.w  #1,y_pos(a1)

loc_7024:
                btst    #button_down,d6
                beq.s   locret_702E
                addq.w  #1,y_pos(a1)

locret_702E:
                rts
; ---------------------------------------------------------------------------

loc_7030:
                btst    #button_left,d6
                beq.s   loc_703A
                subq.w  #1,x_pos(a1)

loc_703A:
                btst    #button_right,d6
                beq.s   locret_7044
                addq.w  #1,x_pos(a1)

locret_7044:
                rts
; ---------------------------------------------------------------------------

loc_7046:
                adda.w  #$E,a2
                dbf     d2,loc_6FA4
                tst.b   (a3)
                beq.s   locret_705A
                move.b  #$1A,anim(a1)

loc_7058:
                clr.b   (a3)

locret_705A:
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

; Dispatch forced ground motion for Hydrocity 2, IceCap 1 and Mushroom Hill
SKSurface_DispatchBothPlayers:
                cmpi.w  #$101,(Current_zone_and_act).w
                beq.s   loc_716A
                cmpi.w  #$500,(Current_zone_and_act).w
                beq.s   loc_71D2
                cmpi.b  #8,(Current_zone).w
                beq.w   loc_72FA
                rts
; ---------------------------------------------------------------------------

loc_716A:
                lea     (Player_1).w,a1
                move.b  (Ctrl_1_held_logical).w,d2
                bsr.s   SKHCZ2_ApplyChunkGroundCurrent
                lea     (Player_2).w,a1
                move.b  (Ctrl_2_held_logical).w,d2
; End of function SKSurface_DispatchBothPlayers

; =============== S U B R O U T I N E =======================================

; On the selected chunks, force inertia toward negative eight pixels per frame
SKHCZ2_ApplyChunkGroundCurrent:
                btst    #Status_InAir,status(a1)
                bne.s   loc_71B8
                cmpi.b  #$C,top_solid_bit(a1)
                beq.s   loc_71B8
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
                lea     byte_7498(pc),a2
                moveq   #(byte_7498-byte_748E)-1,d1

loc_71B0:
                cmp.b   -(a2),d0
                dbeq    d1,loc_71B0
                beq.s   loc_71CC

loc_71B8:
                tst.b   status_secondary(a1)
                bpl.s   locret_71CA
                move.w  #5,move_lock(a1)
                andi.b  #$7F,status_secondary(a1)

locret_71CA:
                rts
; ---------------------------------------------------------------------------

loc_71CC:
                moveq   #-8,d0
                bra.w   loc_723E
; End of function SKHCZ2_ApplyChunkGroundCurrent

; ---------------------------------------------------------------------------

loc_71D2:
                lea     (Player_1).w,a1
                move.b  (Ctrl_1_held_logical).w,d2
                bsr.s   SKICZ1_ApplyChunkGroundSkid
                lea     (Player_2).w,a1
                move.b  (Ctrl_2_held_logical).w,d2

; =============== S U B R O U T I N E =======================================

; The chunk selects the direction and target speed. A zero target takes the shared friction path
SKICZ1_ApplyChunkGroundSkid:
                btst    #Status_InAir,status(a1)
                bne.s   loc_7220
                btst    #Status_OnObj,status(a1)
                bne.s   loc_7220
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
                lea     byte_74A2(pc),a2
                moveq   #(byte_74A2-byte_7498)-1,d1

loc_7218:
                cmp.b   -(a2),d0
                dbeq    d1,loc_7218
                beq.s   loc_7234

loc_7220:
                tst.b   status_secondary(a1)
                bpl.s   locret_7232
                move.w  #5,move_lock(a1)
                andi.b  #$7F,status_secondary(a1)

locret_7232:
                rts
; ---------------------------------------------------------------------------

loc_7234:
                lea     (byte_74A2).l,a2
                move.b  (a2,d1.w),d0

loc_723E:
                beq.s   loc_728A
                move.b  ground_vel(a1),d1
                tst.b   d0
                bpl.s   loc_7254
                cmp.b   d0,d1
                ble.s   loc_725E
                subi.w  #$40,ground_vel(a1)
                bra.s   loc_725E
; ---------------------------------------------------------------------------

loc_7254:
                cmp.b   d0,d1
                bge.s   loc_725E
                addi.w  #$40,ground_vel(a1)

loc_725E:
                bclr    #Status_Facing,status(a1)
                tst.b   d1
                bpl.s   loc_726E
                bset    #Status_Facing,status(a1)

loc_726E:
                move.b  #$1B,anim(a1)
                cmpi.b  #5,(Current_zone).w
                bne.s   loc_7282
                move.b  #$19,anim(a1)

loc_7282:
                ori.b   #$80,status_secondary(a1)
                rts
; ---------------------------------------------------------------------------

loc_728A:
                move.w  #4,d1
                move.w  ground_vel(a1),d0
                btst    #button_left,d2
                beq.s   loc_72AC
                move.b  #0,anim(a1)
                bset    #Status_Facing,status(a1)
                sub.w   d1,d0
                tst.w   d0
                bpl.s   loc_72AC
                sub.w   d1,d0

loc_72AC:
                btst    #button_right,d2
                beq.s   loc_72C6
                move.b  #0,anim(a1)
                bclr    #Status_Facing,status(a1)
                add.w   d1,d0
                tst.w   d0
                bmi.s   loc_72C6
                add.w   d1,d0

loc_72C6:
                move.w  #4,d1
                tst.w   d0
                beq.s   loc_72EE
                bmi.s   loc_72E0
                sub.w   d1,d0
                bhi.s   loc_72DE
                move.w  #0,d0
                move.b  #5,anim(a1)

loc_72DE:
                bra.s   loc_72EE
; ---------------------------------------------------------------------------

loc_72E0:
                add.w   d1,d0
                bhi.s   loc_72EE
                move.w  #0,d0
                move.b  #5,anim(a1)

loc_72EE:
                move.w  d0,ground_vel(a1)
                ori.b   #$80,status_secondary(a1)
                rts
; End of function SKICZ1_ApplyChunkGroundSkid

; ---------------------------------------------------------------------------

loc_72FA:
                lea     (Player_1).w,a1
                move.b  (Ctrl_1_logical).w,d2
                bsr.s   SKMHZ_ApplyChunkGroundSkid
                lea     (Player_2).w,a1
                move.b  (Ctrl_2_logical).w,d2

; =============== S U B R O U T I N E =======================================

; Gate by chunk and half-chunk, with path-dependent direction. First entry brakes the player and reduces collision radii
SKMHZ_ApplyChunkGroundSkid:
                btst    #Status_InAir,status(a1)
                bne.s   loc_734A
                btst    #Status_OnObj,status(a1)
                bne.s   loc_734A
                lea     (Level_layout_header).w,a2
                moveq   #$14,d0
                add.w   y_pos(a1),d0
                lsr.w   #5,d0
                and.w   (Layout_row_index_mask).w,d0
                move.w  8(a2,d0.w),d0
                move.w  x_pos(a1),d1
                lsr.w   #7,d1
                add.w   d1,d0
                movea.w d0,a2
                move.b  (a2),d0
                lea     byte_74BD(pc),a2
                moveq   #(byte_74BD-byte_74AC)-1,d1

loc_7342:
                cmp.b   -(a2),d0
                dbeq    d1,loc_7342
                beq.s   loc_7384

loc_734A:
                tst.b   status_secondary(a1)
                bpl.s   locret_7382
                move.w  #5,move_lock(a1)
                andi.b  #$7F,status_secondary(a1)
                btst    #Status_InAir,status(a1)
                bne.s   locret_7382
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                bclr    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,anim(a1)

locret_7382:
                rts
; ---------------------------------------------------------------------------

loc_7384:
                add.w   d1,d1
                lea     (byte_74BD).l,a2
                move.b  (a2,d1.w),d0
                move.b  1(a2,d1.w),d1
                bne.w   loc_7448

loc_7398:
                move.b  ground_vel(a1),d1
                tst.b   d0
                bpl.s   loc_73C8
                cmp.b   d0,d1
                ble.s   loc_73EE
                subi.w  #$40,ground_vel(a1)
                tst.b   status_secondary(a1)
                bmi.s   loc_73EE
                tst.w   ground_vel(a1)
                bmi.s   loc_73EE
                asr     ground_vel(a1)
                cmpi.b  #-8,d0
                bne.s   loc_73EE
                move.w  #0,ground_vel(a1)
                bra.s   loc_73EE
; ---------------------------------------------------------------------------

loc_73C8:
                cmp.b   d0,d1
                bge.s   loc_73EE
                addi.w  #$40,ground_vel(a1)
                tst.b   status_secondary(a1)
                bmi.s   loc_73EE
                tst.w   ground_vel(a1)
                bpl.s   loc_73EE
                asr     ground_vel(a1)
                cmpi.b  #8,d0
                bne.s   loc_73EE
                move.w  #0,ground_vel(a1)

loc_73EE:
                tst.b   d1
                beq.s   loc_7402
                bclr    #Status_Facing,status(a1)
                tst.b   d1
                bpl.s   loc_7402
                bset    #Status_Facing,status(a1)

loc_7402:
                move.b  #$19,anim(a1)
                move.b  y_radius(a1),d0
                subi.b  #$E,d0
                ext.w   d0
                add.w   d0,y_pos(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                bclr    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                ori.b   #$80,status_secondary(a1)
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   locret_7446
                moveq   #signextendB(sfx_SlideSkidQuiet),d0
                jsr     (Play_SFX).l

locret_7446:
                rts
; ---------------------------------------------------------------------------

loc_7448:
                cmpi.b  #1,d1
                bne.s   loc_7462
                move.w  x_pos(a1),d1
                andi.w  #$7F,d1
                cmpi.w  #$40,d1
                blo.w   loc_7398
                bra.w   loc_734A
; ---------------------------------------------------------------------------

loc_7462:
                cmpi.b  #2,d1
                bne.s   loc_747C
                move.w  x_pos(a1),d1
                andi.w  #$7F,d1
                cmpi.w  #$40,d1
                bhs.w   loc_7398
                bra.w   loc_734A
; ---------------------------------------------------------------------------

loc_747C:
                moveq   #-8,d0
                cmpi.b  #$C,top_solid_bit(a1)
                beq.w   loc_7398
                moveq   #8,d0
                bra.w   loc_7398
; End of function SKMHZ_ApplyChunkGroundSkid
