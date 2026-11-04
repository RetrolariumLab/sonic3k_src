; Owner: game/level/s3
; Responsibility: Hydrocity water tunnel detection, movement helpers and water-region player response
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Select the tunnel flag for the player mode. The matched rectangle allows one-pixel steering across the current
S3HCZ_ApplyWaterTunnelCurrents:
                tst.w   (Debug_placement_mode).w
                bne.w   S3Tunnel_TunnelReturn
                cmpi.b  #1,(Current_zone).w
                bne.w   S3Tunnel_TunnelReturn
                cmpi.w  #2,(Player_mode).w
                beq.s   S3Tunnel_BindSoloTailsTunnel
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

; Mode 2 reads P1's actor and controls but uses the P2 tunnel flag
S3Tunnel_BindSoloTailsTunnel:
                lea     (WindTunnel_flag_P2).w,a3
                lea     (Player_1).w,a1
                move.b  (Ctrl_1_held_logical).w,d6
                moveq   #0,d5
; End of function S3HCZ_ApplyWaterTunnelCurrents

; =============== S U B R O U T I N E =======================================

HCZ_WaterTunnels:
                lea     (HCZ1_WaterTunLocs).l,a2
                tst.b   (Current_act).w
                beq.s   S3Tunnel_BeginTunnelScan
                lea     (HCZ2_WaterTunLocs).l,a2

S3Tunnel_BeginTunnelScan:
                move.w  (a2)+,d2

S3Tunnel_TryTunnelRect:
                move.w  x_pos(a1),d0
                cmp.w   (a2),d0
                blo.w   S3Tunnel_NextTunnelRectOrExit
                cmp.w   4(a2),d0
                bhs.w   S3Tunnel_NextTunnelRectOrExit
                move.w  y_pos(a1),d1
                cmp.w   2(a2),d1
                blo.w   S3Tunnel_NextTunnelRectOrExit
                cmp.w   6(a2),d1
                bhs.s   S3Tunnel_NextTunnelRectOrExit
                cmpi.b  #4,routine(a1)
                bhs.w   S3Tunnel_ClearTunnelFlag
                btst    d5,(_unkF7C7).w
                bne.s   S3Tunnel_NudgeYReturn
                tst.b   object_control(a1)
                bne.s   S3Tunnel_ClearTunnelFlag
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
                bne.s   S3Tunnel_TryNudgeLeft
                btst    #button_up,d6
                beq.s   S3Tunnel_TryNudgeDown
                subq.w  #1,y_pos(a1)

S3Tunnel_TryNudgeDown:
                btst    #button_down,d6
                beq.s   S3Tunnel_NudgeYReturn
                addq.w  #1,y_pos(a1)

S3Tunnel_NudgeYReturn:
                rts
; ---------------------------------------------------------------------------

S3Tunnel_TryNudgeLeft:
                btst    #button_left,d6
                beq.s   S3Tunnel_TryNudgeRight
                subq.w  #1,x_pos(a1)

S3Tunnel_TryNudgeRight:
                btst    #button_right,d6
                beq.s   S3Tunnel_NudgeXReturn
                addq.w  #1,x_pos(a1)

S3Tunnel_NudgeXReturn:
                rts
; ---------------------------------------------------------------------------

S3Tunnel_NextTunnelRectOrExit:
                adda.w  #$E,a2
                dbf     d2,S3Tunnel_TryTunnelRect
                tst.b   (a3)
                beq.s   S3Tunnel_TunnelReturn
                move.b  #$1A,anim(a1)

S3Tunnel_ClearTunnelFlag:
                clr.b   (a3)

S3Tunnel_TunnelReturn:
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
                beq.s   S3Ground_HCZ2_ApplyCurrentToBoth
                cmpi.w  #$500,(Current_zone_and_act).w
                beq.s   S3Ground_ICZ1_ApplySkidToBoth
                rts
; ---------------------------------------------------------------------------

S3Ground_HCZ2_ApplyCurrentToBoth:
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
                bne.s   S3Ground_HCZ2_ReleaseCurrent
                cmpi.b  #$C,top_solid_bit(a1)
                beq.s   S3Ground_HCZ2_ReleaseCurrent
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
                lea     S3Env_ICZ1SkidChunkIds(pc),a2
                moveq   #(S3Env_ICZ1SkidChunkIds-S3Env_HCZ2CurrentChunkIds)-1,d1

S3Ground_HCZ2_FindCurrentChunk:
                cmp.b   -(a2),d0
                dbeq    d1,S3Ground_HCZ2_FindCurrentChunk
                beq.s   S3Ground_HCZ2_SetLeftCurrentTarget

S3Ground_HCZ2_ReleaseCurrent:
                tst.b   status_secondary(a1)
                bpl.s   S3Ground_HCZ2_ReleaseReturn
                move.w  #5,move_lock(a1)
                andi.b  #$7F,status_secondary(a1)

S3Ground_HCZ2_ReleaseReturn:
                rts
; ---------------------------------------------------------------------------

S3Ground_HCZ2_SetLeftCurrentTarget:
                moveq   #-8,d0
                bra.w   S3Ground_StepTowardSpeedTarget
; End of function S3HCZ2_ApplyChunkGroundCurrent

; ---------------------------------------------------------------------------

S3Ground_ICZ1_ApplySkidToBoth:
                lea     (Player_1).w,a1
                move.b  (Ctrl_1_held_logical).w,d2
                bsr.s   S3ICZ1_ApplyChunkGroundSkid
                lea     (Player_2).w,a1
                move.b  (Ctrl_2_held_logical).w,d2

; =============== S U B R O U T I N E =======================================

; The chunk selects the direction and target speed. A zero target takes the shared friction path
S3ICZ1_ApplyChunkGroundSkid:
                btst    #Status_InAir,status(a1)
                bne.s   S3Ground_ICZ1_ReleaseSkid
                btst    #Status_OnObj,status(a1)
                bne.s   S3Ground_ICZ1_ReleaseSkid
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
                moveq   #(WaterTransition_AIZ1-S3Env_ICZ1SkidChunkIds)-1,d1

S3Ground_ICZ1_FindSkidChunk:
                cmp.b   -(a2),d0
                dbeq    d1,S3Ground_ICZ1_FindSkidChunk
                beq.s   S3Ground_ICZ1_ReadSkidSpeedTarget

S3Ground_ICZ1_ReleaseSkid:
                tst.b   status_secondary(a1)
                bpl.s   S3Ground_ICZ1_ReleaseReturn
                move.w  #5,move_lock(a1)
                andi.b  #$7F,status_secondary(a1)

S3Ground_ICZ1_ReleaseReturn:
                rts
; ---------------------------------------------------------------------------

S3Ground_ICZ1_ReadSkidSpeedTarget:
                lea     (S3Env_ICZChunkSpeedTargets).l,a2
                move.b  (a2,d1.w),d0

; The zero flag on entry selects the input-controlled path
S3Ground_StepTowardSpeedTarget:
                beq.s   S3Ground_TryInputLeft
                move.b  ground_vel(a1),d1
                tst.b   d0
                bpl.s   S3Ground_TryIncreaseGroundSpeed
                cmp.b   d0,d1
                ble.s   S3Ground_SetFacingFromOldSpeed
                subi.w  #$40,ground_vel(a1)
                bra.s   S3Ground_SetFacingFromOldSpeed
; ---------------------------------------------------------------------------

S3Ground_TryIncreaseGroundSpeed:
                cmp.b   d0,d1
                bge.s   S3Ground_SetFacingFromOldSpeed
                addi.w  #$40,ground_vel(a1)

; Use the velocity high byte read before applying the speed step
S3Ground_SetFacingFromOldSpeed:
                bclr    #Status_Facing,status(a1)
                tst.b   d1
                bpl.s   S3Ground_PickCurrentOrSkidAnim
                bset    #Status_Facing,status(a1)

S3Ground_PickCurrentOrSkidAnim:
                move.b  #$1B,anim(a1)
                cmpi.b  #5,(Current_zone).w
                bne.s   S3Ground_LatchInertiaAndReturn
                move.b  #$19,anim(a1)

S3Ground_LatchInertiaAndReturn:
                ori.b   #$80,status_secondary(a1)
                rts
; ---------------------------------------------------------------------------

S3Ground_TryInputLeft:
                move.w  #4,d1
                move.w  ground_vel(a1),d0
                btst    #button_left,d2
                beq.s   S3Ground_TryInputRight
                move.b  #0,anim(a1)
                bset    #Status_Facing,status(a1)
                sub.w   d1,d0
                tst.w   d0
                bpl.s   S3Ground_TryInputRight
                sub.w   d1,d0

S3Ground_TryInputRight:
                btst    #button_right,d2
                beq.s   S3Ground_DecayUnforcedInertia
                move.b  #0,anim(a1)
                bclr    #Status_Facing,status(a1)
                add.w   d1,d0
                tst.w   d0
                bmi.s   S3Ground_DecayUnforcedInertia
                add.w   d1,d0

S3Ground_DecayUnforcedInertia:
                move.w  #4,d1
                tst.w   d0
                beq.s   S3Ground_StoreInertiaAndLatch
                bmi.s   S3Ground_DecayNegativeInertia
                sub.w   d1,d0
                bhi.s   S3Ground_CommitPositiveDecay
                move.w  #0,d0
                move.b  #5,anim(a1)

S3Ground_CommitPositiveDecay:
                bra.s   S3Ground_StoreInertiaAndLatch
; ---------------------------------------------------------------------------

; Keep the result only on BHI after the addition. Otherwise reset velocity and animation
S3Ground_DecayNegativeInertia:
                add.w   d1,d0
                bhi.s   S3Ground_StoreInertiaAndLatch
                move.w  #0,d0
                move.b  #5,anim(a1)

S3Ground_StoreInertiaAndLatch:
                move.w  d0,ground_vel(a1)
                ori.b   #$80,status_secondary(a1)
                rts
; End of function S3ICZ1_ApplyChunkGroundSkid
