; Owner: game/level/sk
; Responsibility: Hydrocity water tunnel detection, movement helpers and water-region player response
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Select the tunnel flag for the player mode. The matched rectangle allows one-pixel steering across the current
SKHCZ_ApplyWaterTunnelCurrents:
                tst.w   (Debug_placement_mode).w
                bne.w   SKTunnel_TunnelReturn
                cmpi.b  #1,(Current_zone).w
                bne.w   SKTunnel_TunnelReturn
                cmpi.w  #2,(Player_mode).w
                beq.s   SKTunnel_BindSoloTailsTunnel
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
SKTunnel_BindSoloTailsTunnel:
                lea     (WindTunnel_flag_P2).w,a3
                lea     (Player_1).w,a1
                move.b  (Ctrl_1_held_logical).w,d6
                moveq   #0,d5
; End of function SKHCZ_ApplyWaterTunnelCurrents

; =============== S U B R O U T I N E =======================================

HCZ_WaterTunnels:
                lea     (HCZ1_WaterTunLocs).l,a2
                tst.b   (Current_act).w
                beq.s   SKTunnel_BeginTunnelScan
                lea     (HCZ2_WaterTunLocs).l,a2

SKTunnel_BeginTunnelScan:
                move.w  (a2)+,d2

SKTunnel_TryTunnelRect:
                move.w  x_pos(a1),d0
                cmp.w   (a2),d0
                blo.w   SKTunnel_NextTunnelRectOrExit
                cmp.w   4(a2),d0
                bhs.w   SKTunnel_NextTunnelRectOrExit
                move.w  y_pos(a1),d1
                cmp.w   2(a2),d1
                blo.w   SKTunnel_NextTunnelRectOrExit
                cmp.w   6(a2),d1
                bhs.s   SKTunnel_NextTunnelRectOrExit
                cmpi.b  #4,routine(a1)
                bhs.w   SKTunnel_ClearTunnelFlag
                btst    d5,(_unkF7C7).w
                bne.s   SKTunnel_NudgeYReturn
                tst.b   object_control(a1)
                bne.s   SKTunnel_ClearTunnelFlag
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
                bne.s   SKTunnel_TryNudgeLeft
                btst    #button_up,d6
                beq.s   SKTunnel_TryNudgeDown
                subq.w  #1,y_pos(a1)

SKTunnel_TryNudgeDown:
                btst    #button_down,d6
                beq.s   SKTunnel_NudgeYReturn
                addq.w  #1,y_pos(a1)

SKTunnel_NudgeYReturn:
                rts
; ---------------------------------------------------------------------------

SKTunnel_TryNudgeLeft:
                btst    #button_left,d6
                beq.s   SKTunnel_TryNudgeRight
                subq.w  #1,x_pos(a1)

SKTunnel_TryNudgeRight:
                btst    #button_right,d6
                beq.s   SKTunnel_NudgeXReturn
                addq.w  #1,x_pos(a1)

SKTunnel_NudgeXReturn:
                rts
; ---------------------------------------------------------------------------

SKTunnel_NextTunnelRectOrExit:
                adda.w  #$E,a2
                dbf     d2,SKTunnel_TryTunnelRect
                tst.b   (a3)
                beq.s   SKTunnel_TunnelReturn
                move.b  #$1A,anim(a1)

SKTunnel_ClearTunnelFlag:
                clr.b   (a3)

SKTunnel_TunnelReturn:
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
                beq.s   SKGround_HCZ2_ApplyCurrentToBoth
                cmpi.w  #$500,(Current_zone_and_act).w
                beq.s   SKGround_ICZ1_ApplySkidToBoth
                cmpi.b  #8,(Current_zone).w
                beq.w   SKSOZSkid_ApplyToBothPlayers
                rts
; ---------------------------------------------------------------------------

SKGround_HCZ2_ApplyCurrentToBoth:
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
                bne.s   SKGround_HCZ2_ReleaseCurrent
                cmpi.b  #$C,top_solid_bit(a1)
                beq.s   SKGround_HCZ2_ReleaseCurrent
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
                lea     SKEnv_ICZ1SkidChunkIds(pc),a2
                moveq   #(SKEnv_ICZ1SkidChunkIds-SKEnv_HCZ2CurrentChunkIds)-1,d1

SKGround_HCZ2_FindCurrentChunk:
                cmp.b   -(a2),d0
                dbeq    d1,SKGround_HCZ2_FindCurrentChunk
                beq.s   SKGround_HCZ2_SetLeftCurrentTarget

SKGround_HCZ2_ReleaseCurrent:
                tst.b   status_secondary(a1)
                bpl.s   SKGround_HCZ2_ReleaseReturn
                move.w  #5,move_lock(a1)
                andi.b  #$7F,status_secondary(a1)

SKGround_HCZ2_ReleaseReturn:
                rts
; ---------------------------------------------------------------------------

SKGround_HCZ2_SetLeftCurrentTarget:
                moveq   #-8,d0
                bra.w   SKGround_StepTowardSpeedTarget
; End of function SKHCZ2_ApplyChunkGroundCurrent

; ---------------------------------------------------------------------------

SKGround_ICZ1_ApplySkidToBoth:
                lea     (Player_1).w,a1
                move.b  (Ctrl_1_held_logical).w,d2
                bsr.s   SKICZ1_ApplyChunkGroundSkid
                lea     (Player_2).w,a1
                move.b  (Ctrl_2_held_logical).w,d2

; =============== S U B R O U T I N E =======================================

; The chunk selects the direction and target speed. A zero target takes the shared friction path
SKICZ1_ApplyChunkGroundSkid:
                btst    #Status_InAir,status(a1)
                bne.s   SKGround_ICZ1_ReleaseSkid
                btst    #Status_OnObj,status(a1)
                bne.s   SKGround_ICZ1_ReleaseSkid
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
                lea     SKEnv_ICZChunkSpeedTargets(pc),a2
                moveq   #(SKEnv_ICZChunkSpeedTargets-SKEnv_ICZ1SkidChunkIds)-1,d1

SKGround_ICZ1_FindSkidChunk:
                cmp.b   -(a2),d0
                dbeq    d1,SKGround_ICZ1_FindSkidChunk
                beq.s   SKGround_ICZ1_ReadSkidSpeedTarget

SKGround_ICZ1_ReleaseSkid:
                tst.b   status_secondary(a1)
                bpl.s   SKGround_ICZ1_ReleaseReturn
                move.w  #5,move_lock(a1)
                andi.b  #$7F,status_secondary(a1)

SKGround_ICZ1_ReleaseReturn:
                rts
; ---------------------------------------------------------------------------

SKGround_ICZ1_ReadSkidSpeedTarget:
                lea     (SKEnv_ICZChunkSpeedTargets).l,a2
                move.b  (a2,d1.w),d0

; The zero flag on entry selects the input-controlled path
SKGround_StepTowardSpeedTarget:
                beq.s   SKGround_TryInputLeft
                move.b  ground_vel(a1),d1
                tst.b   d0
                bpl.s   SKGround_TryIncreaseGroundSpeed
                cmp.b   d0,d1
                ble.s   SKGround_SetFacingFromOldSpeed
                subi.w  #$40,ground_vel(a1)
                bra.s   SKGround_SetFacingFromOldSpeed
; ---------------------------------------------------------------------------

SKGround_TryIncreaseGroundSpeed:
                cmp.b   d0,d1
                bge.s   SKGround_SetFacingFromOldSpeed
                addi.w  #$40,ground_vel(a1)

; Use the velocity high byte read before applying the speed step
SKGround_SetFacingFromOldSpeed:
                bclr    #Status_Facing,status(a1)
                tst.b   d1
                bpl.s   SKGround_PickCurrentOrSkidAnim
                bset    #Status_Facing,status(a1)

SKGround_PickCurrentOrSkidAnim:
                move.b  #$1B,anim(a1)
                cmpi.b  #5,(Current_zone).w
                bne.s   SKGround_LatchInertiaAndReturn
                move.b  #$19,anim(a1)

SKGround_LatchInertiaAndReturn:
                ori.b   #$80,status_secondary(a1)
                rts
; ---------------------------------------------------------------------------

SKGround_TryInputLeft:
                move.w  #4,d1
                move.w  ground_vel(a1),d0
                btst    #button_left,d2
                beq.s   SKGround_TryInputRight
                move.b  #0,anim(a1)
                bset    #Status_Facing,status(a1)
                sub.w   d1,d0
                tst.w   d0
                bpl.s   SKGround_TryInputRight
                sub.w   d1,d0

SKGround_TryInputRight:
                btst    #button_right,d2
                beq.s   SKGround_DecayUnforcedInertia
                move.b  #0,anim(a1)
                bclr    #Status_Facing,status(a1)
                add.w   d1,d0
                tst.w   d0
                bmi.s   SKGround_DecayUnforcedInertia
                add.w   d1,d0

SKGround_DecayUnforcedInertia:
                move.w  #4,d1
                tst.w   d0
                beq.s   SKGround_StoreInertiaAndLatch
                bmi.s   SKGround_DecayNegativeInertia
                sub.w   d1,d0
                bhi.s   SKGround_CommitPositiveDecay
                move.w  #0,d0
                move.b  #5,anim(a1)

SKGround_CommitPositiveDecay:
                bra.s   SKGround_StoreInertiaAndLatch
; ---------------------------------------------------------------------------

; Keep the result only on BHI after the addition. Otherwise reset velocity and animation
SKGround_DecayNegativeInertia:
                add.w   d1,d0
                bhi.s   SKGround_StoreInertiaAndLatch
                move.w  #0,d0
                move.b  #5,anim(a1)

SKGround_StoreInertiaAndLatch:
                move.w  d0,ground_vel(a1)
                ori.b   #$80,status_secondary(a1)
                rts
; End of function SKICZ1_ApplyChunkGroundSkid

; ---------------------------------------------------------------------------

SKSOZSkid_ApplyToBothPlayers:
                lea     (Player_1).w,a1
                move.b  (Ctrl_1_logical).w,d2
                bsr.s   SKMHZ_ApplyChunkGroundSkid
                lea     (Player_2).w,a1
                move.b  (Ctrl_2_logical).w,d2

; =============== S U B R O U T I N E =======================================

; Gate by chunk and half-chunk, with path-dependent direction. First entry brakes the player and reduces collision radii
SKMHZ_ApplyChunkGroundSkid:
                btst    #Status_InAir,status(a1)
                bne.s   SKSOZSkid_ReleaseAndRestoreRadii
                btst    #Status_OnObj,status(a1)
                bne.s   SKSOZSkid_ReleaseAndRestoreRadii
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
                lea     SKEnv_SOZSkidAndRegionPairs(pc),a2
                moveq   #(SKEnv_SOZSkidAndRegionPairs-SKEnvironment_SozGroundSkidChunkIdBytes)-1,d1

SKSOZSkid_FindChunk:
                cmp.b   -(a2),d0
                dbeq    d1,SKSOZSkid_FindChunk
                beq.s   SKSOZSkid_ReadSpeedAndRegion

SKSOZSkid_ReleaseAndRestoreRadii:
                tst.b   status_secondary(a1)
                bpl.s   SKSOZSkid_ReleaseReturn
                move.w  #5,move_lock(a1)
                andi.b  #$7F,status_secondary(a1)
                btst    #Status_InAir,status(a1)
                bne.s   SKSOZSkid_ReleaseReturn
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                bclr    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,anim(a1)

SKSOZSkid_ReleaseReturn:
                rts
; ---------------------------------------------------------------------------

SKSOZSkid_ReadSpeedAndRegion:
                add.w   d1,d1
                lea     (SKEnv_SOZSkidAndRegionPairs).l,a2
                move.b  (a2,d1.w),d0
                move.b  1(a2,d1.w),d1
                bne.w   SKSOZSkid_TryLeftHalf

; On first contact, damp opposing velocity and clear it for the -8 target
SKSOZSkid_StepTowardNegative:
                move.b  ground_vel(a1),d1
                tst.b   d0
                bpl.s   SKSOZSkid_StepTowardPositive
                cmp.b   d0,d1
                ble.s   SKSOZSkid_UpdateFacing
                subi.w  #$40,ground_vel(a1)
                tst.b   status_secondary(a1)
                bmi.s   SKSOZSkid_UpdateFacing
                tst.w   ground_vel(a1)
                bmi.s   SKSOZSkid_UpdateFacing
                asr     ground_vel(a1)
                cmpi.b  #-8,d0
                bne.s   SKSOZSkid_UpdateFacing
                move.w  #0,ground_vel(a1)
                bra.s   SKSOZSkid_UpdateFacing
; ---------------------------------------------------------------------------

; On first contact, damp opposing velocity and clear it for the +8 target
SKSOZSkid_StepTowardPositive:
                cmp.b   d0,d1
                bge.s   SKSOZSkid_UpdateFacing
                addi.w  #$40,ground_vel(a1)
                tst.b   status_secondary(a1)
                bmi.s   SKSOZSkid_UpdateFacing
                tst.w   ground_vel(a1)
                bpl.s   SKSOZSkid_UpdateFacing
                asr     ground_vel(a1)
                cmpi.b  #8,d0
                bne.s   SKSOZSkid_UpdateFacing
                move.w  #0,ground_vel(a1)

; Use the old velocity high byte. Keep facing unchanged when it is zero
SKSOZSkid_UpdateFacing:
                tst.b   d1
                beq.s   SKSOZSkid_SetPoseAndSound
                bclr    #Status_Facing,status(a1)
                tst.b   d1
                bpl.s   SKSOZSkid_SetPoseAndSound
                bset    #Status_Facing,status(a1)

SKSOZSkid_SetPoseAndSound:
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
                bne.s   SKSOZSkid_PoseReturn
                moveq   #signextendB(sfx_SlideSkidQuiet),d0
                jsr     (Play_SFX).l

SKSOZSkid_PoseReturn:
                rts
; ---------------------------------------------------------------------------

SKSOZSkid_TryLeftHalf:
                cmpi.b  #1,d1
                bne.s   SKSOZSkid_TryRightHalf
                move.w  x_pos(a1),d1
                andi.w  #$7F,d1
                cmpi.w  #$40,d1
                blo.w   SKSOZSkid_StepTowardNegative
                bra.w   SKSOZSkid_ReleaseAndRestoreRadii
; ---------------------------------------------------------------------------

SKSOZSkid_TryRightHalf:
                cmpi.b  #2,d1
                bne.s   SKSOZSkid_PickSpeedByPlane
                move.w  x_pos(a1),d1
                andi.w  #$7F,d1
                cmpi.w  #$40,d1
                bhs.w   SKSOZSkid_StepTowardNegative
                bra.w   SKSOZSkid_ReleaseAndRestoreRadii
; ---------------------------------------------------------------------------

SKSOZSkid_PickSpeedByPlane:
                moveq   #-8,d0
                cmpi.b  #$C,top_solid_bit(a1)
                beq.w   SKSOZSkid_StepTowardNegative
                moveq   #8,d0
                bra.w   SKSOZSkid_StepTowardNegative
; End of function SKMHZ_ApplyChunkGroundSkid
