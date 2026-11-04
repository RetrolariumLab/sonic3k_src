; Owner: objects/zones/ssz/sk
; Responsibility: Retracting spring timing, extension and player launch responses
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SSZRetractingSpring:
                move.l  #SKSSZRetractSpring_PollAreaOnOddFrame,(a0)
                bset    #2,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$18,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$CE,0,0),art_tile(a0)
                move.l  #Map_SSZRetractingSpring,mappings(a0)

SKSSZRetractSpring_PollAreaOnOddFrame:
                btst    #0,(Level_frame_counter+1).w
                beq.s   SKSSZRetractSpring_SelectCollisionX
                moveq   #0,d0
                move.w  y_pos(a0),d2
                addi.w  #$10,d2
                move.w  d2,d1
                subi.w  #$60,d1
                move.w  x_pos(a0),d3
                move.w  d3,d4
                subi.w  #$60,d3
                btst    #0,status(a0)
                beq.s   SKSSZRetractSpring_CountRidersSetFrame
                addi.w  #2*$60,d3
                exg     d3,d4

SKSSZRetractSpring_CountRidersSetFrame:
                lea     (Player_1).w,a1
                jsr     CountPlayerInSszSpringExtensionArea(pc)
                lea     (Player_2).w,a1
                jsr     CountPlayerInSszSpringExtensionArea(pc)
                move.b  mapping_frame(a0),d1
                tst.w   d0
                bne.s   SKSSZRetractSpring_TryPlayLatchSound
                tst.b   d1
                beq.s   SKSSZRetractSpring_ApplyExtensionFrame
                clr.l   $2E(a0)
                subq.b  #1,d1
                cmpi.b  #3,d1
                blo.s   SKSSZRetractSpring_ApplyExtensionFrame
                moveq   #2,d1
                bra.s   SKSSZRetractSpring_ApplyExtensionFrame
; ---------------------------------------------------------------------------

SKSSZRetractSpring_TryPlayLatchSound:
                cmpi.b  #3,d1
                bhs.s   SKSSZRetractSpring_ApplyExtensionFrame
                tst.b   d1
                bne.s   SKSSZRetractSpring_AdvanceExtensionFrame
                moveq   #signextendB(sfx_SpringLatch),d0
                jsr     (Play_SFX).l

SKSSZRetractSpring_AdvanceExtensionFrame:
                addq.b  #1,d1

SKSSZRetractSpring_ApplyExtensionFrame:
                move.b  d1,mapping_frame(a0)

; Temporarily move collision to X = $7FFF while the frame is below 2. Restore X after the probe
SKSSZRetractSpring_SelectCollisionX:
                move.w  x_pos(a0),$12(a0)
                cmpi.b  #2,mapping_frame(a0)
                bhs.s   SKSSZRetractSpring_CheckSolidAndLaunch
                move.w  #$7FFF,x_pos(a0)

SKSSZRetractSpring_CheckSolidAndLaunch:
                moveq   #$23,d1
                moveq   #$10,d2
                lea     SKSSZRetractSpring_SolidHeights(pc),a2
                move.w  x_pos(a0),d4
                jsr     (CollidePlayersWithHeightProfileSolid).l
                move.w  $12(a0),x_pos(a0)
                swap    d6
                move.w  d6,-(sp)
                lea     (Player_1).w,a1
                lea     $2E(a0),a2
                bsr.s   AdvancePlayerSszRetractingSpringLaunch
                move.w  (sp)+,d6
                lsr.w   #1,d6
                lea     (Player_2).w,a1
                lea     $30(a0),a2
                bsr.s   AdvancePlayerSszRetractingSpringLaunch
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

CountPlayerInSszSpringExtensionArea:
                tst.b   object_control(a1)
                bne.s   SKSSZRetractSpring_AreaCountReturn
                cmp.w   y_pos(a1),d1
                bhi.s   SKSSZRetractSpring_AreaCountReturn
                cmp.w   y_pos(a1),d2
                blo.s   SKSSZRetractSpring_AreaCountReturn
                cmp.w   x_pos(a1),d3
                bhi.s   SKSSZRetractSpring_AreaCountReturn
                cmp.w   x_pos(a1),d4
                blo.s   SKSSZRetractSpring_AreaCountReturn
                addq.w  #1,d0

SKSSZRetractSpring_AreaCountReturn:
                rts
; End of function CountPlayerInSszSpringExtensionArea

; =============== S U B R O U T I N E =======================================

AdvancePlayerSszRetractingSpringLaunch:
                move.b  (a2),d0
                bne.s   SKSSZRetractSpring_SelectImpulseOrRecoil
                lsr.w   #1,d6
                bcc.w   SKSSZRetractSpring_LaunchReturn
                moveq   #8,d1
                move.w  x_pos(a1),d2
                sub.w   x_pos(a0),d2
                bmi.s   SKSSZRetractSpring_CheckUnflippedContact
                btst    #0,status(a0)
                bne.s   SKSSZRetractSpring_NudgeAndArmLaunch
                bra.s   SKSSZRetractSpring_LaunchReturn
; ---------------------------------------------------------------------------

SKSSZRetractSpring_CheckUnflippedContact:
                btst    #0,status(a0)
                bne.s   SKSSZRetractSpring_LaunchReturn
                neg.w   d1

SKSSZRetractSpring_NudgeAndArmLaunch:
                sub.w   d1,x_pos(a1)
                move.b  #4,mapping_frame(a0)
                addq.b  #1,(a2)
                bra.s   SKSSZRetractSpring_LaunchReturn
; ---------------------------------------------------------------------------

SKSSZRetractSpring_SelectImpulseOrRecoil:
                subq.b  #1,d0
                bne.s   SKSSZRetractSpring_BeginRecoilHold
                move.w  #$C00,d1
                move.b  status(a0),d2
                andi.w  #1,d2
                eori.w  #1,d2
                beq.s   SKSSZRetractSpring_ApplyLaunchImpulse
                neg.w   d1

SKSSZRetractSpring_ApplyLaunchImpulse:
                move.w  d1,ground_vel(a1)
                move.w  d1,x_vel(a1)
                andi.b  #$FE,status(a1)
                or.b    d2,status(a1)
                andi.b  #$FE,render_flags(a1)
                or.b    d2,render_flags(a1)
                move.b  #3,mapping_frame(a0)
                addq.b  #1,(a2)
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SKSSZRetractSpring_BeginRecoilHold:
                subq.b  #1,d0
                bne.s   SKSSZRetractSpring_TickRecoilAndReset
                move.b  #5,mapping_frame(a0)
                move.b  #8,1(a2)
                addq.b  #1,(a2)
                bra.s   SKSSZRetractSpring_LaunchReturn
; ---------------------------------------------------------------------------

SKSSZRetractSpring_TickRecoilAndReset:
                subq.b  #1,1(a2)
                bne.s   SKSSZRetractSpring_LaunchReturn
                move.b  #3,mapping_frame(a0)
                clr.w   (a2)

SKSSZRetractSpring_LaunchReturn:
                rts
; End of function AdvancePlayerSszRetractingSpringLaunch

; =============== S U B R O U T I N E =======================================

Gradual_SwingOffset:
                move.l  $2E(a0),d2
                tst.b   $36(a0)
                beq.s   SKSSZSwing_StepPositiveHalf
                neg.l   d1
                add.l   d2,$32(a0)                      ; Moving up and then down. Reset speed/direction when center point is reached going down
                bmi.s   SKSSZSwing_ApplyAcceleration
                move.l  d0,$2E(a0)                      ; Reset initial speed (positive) to move downwards
                clr.l   $32(a0)
                clr.b   $36(a0)
                bra.s   SKSSZSwing_ReturnIntegerOffset
; ---------------------------------------------------------------------------

SKSSZSwing_StepPositiveHalf:
                add.l   d2,$32(a0)                      ; Moving down and then up. Reset speed/direction when center point is reached going up
                bmi.s   SKSSZSwing_ResetNegativeAtCenter
                bne.s   SKSSZSwing_ApplyAcceleration

SKSSZSwing_ResetNegativeAtCenter:
                neg.l   d0                              ; Reverse direction to move upwards when speed has reached
                move.l  d0,$2E(a0)                      ; Reset initial speed (negative)
                clr.l   $32(a0)
                st      $36(a0)
                bra.s   SKSSZSwing_ReturnIntegerOffset
; ---------------------------------------------------------------------------

SKSSZSwing_ApplyAcceleration:
                sub.l   d1,$2E(a0)                      ; Apply speed

SKSSZSwing_ReturnIntegerOffset:
                move.w  $32(a0),d0                      ; Get final offset for us by calling object
                rts
; End of function Gradual_SwingOffset

; ---------------------------------------------------------------------------
SKSSZColumn_ShardRecords:
                dc.w    -8,  -$18,   $32,     3
                dc.w    8,  -$18,   $31,     4
                dc.w    -8,    -8,   $29,     3
                dc.w    8,    -8,   $2E,     4
                dc.w    -8,     8,   $22,     3
                dc.w    8,     8,   $19,     4
                dc.w    -8,   $18,     1,     5
                dc.w    8,   $18,    $E,     6
SKSSZDiagBridge_SlopeHeights:
                dc.b    -6,  -6
                dc.b    -5,  -5
                dc.b    -4,  -4
                dc.b    -3,  -3
                dc.b    -2,  -2
                dc.b    -1,  -1
                dc.b    0,   0
                dc.b    1,   1
                dc.b    2,   2
                dc.b    3,   3
                dc.b    4,   4
                dc.b    5,   5
                dc.b    6,   6
                dc.b    7,   7
                dc.b    8,   8
                dc.b    9,   9
                dc.b    $A,  $A
                dc.b    $B,  $B
                dc.b    $C,  $C
                dc.b    $D,  $D
                dc.b    $E,  $E
                dc.b    $F,  $F
                dc.b    $10, $10
                dc.b    $11, $11
                dc.b    $12, $12
                dc.b    $13, $13
                dc.b    $14, $14
                dc.b    $15, $15
                dc.b    $16, $16
                dc.b    $17, $17
                dc.b    $18, $18
                dc.b    $19, $19
; The eighth byte is also referenced by the initial-compression label
SKSSZCloud_CompressionSamples:
                dc.b    0
                dc.b    $A
                dc.b    $12
                dc.b    $16
                dc.b    $17
                dc.b    $16
                dc.b    $12
SKSSZCloud_InitialCompressionSample:
                dc.b    $A
SKSSZCloud_RecoverySamples:
                dc.b    0,  -1,  -1,   0,   1,   2,   2,   1
                dc.b    0,  -3,  -4,  -4,  -3,   0,   4,   6
                dc.b    6,   4,   0,  -5,  -8,  -9,  -8,  -5
                dc.b    0,   6,  $A,  $C,  $C,  $A,   6,   0
                dc.b    -7, -$C, -$F,-$10, -$F, -$C,  -7,   0
                even
SKSSZCloud_BounceParticleRecords:
                dc.w    -$C
                dc.w    -$10
                dc.w    -$2C0
                dc.w    -$400
                dc.w    $C
                dc.w    -$10
                dc.w    $2C0
                dc.w    -$400
                dc.w    -$10
                dc.w    -$C
                dc.w    -$500
                dc.w    -$200
                dc.w    $10
                dc.w    -$C
                dc.w    $500
                dc.w    -$200
SKSSZTeleporter_SolidHeights:
                dc.b    9,   9,   9,   9,   9,   9,   9,   9,   9,   9,   9,   9,  $B,  $D,  $F, $11, $11, $11, $11, $11
                dc.b    $11,  $F,  $D,  $B,   9,   9,   9,   9,   9,   9,   9,   9,   9,   9,   9,   9
                even
SKSSZTeleporter_PaletteCyclePairs:
                dc.w    $408,  $40C
                dc.w    $60A,  $60C
                dc.w    $80C,  $80E
                dc.w    $A0E,  $C0E
                dc.w    $C0E,  $E0E
                dc.w    $E0E,  $E0E
                dc.w    $C0E,  $E0E
                dc.w    $A0E,  $C0E
                dc.w    $80C,  $80E
                dc.w    $60A,  $60C
SKSSZBeam_SSZAndHPZGeometry:
                dc.w    -6,     3,    -6,     4
                dc.w    -6,     3,    -6,     4
                dc.w    -5,     3,    -5,     4
                dc.w    -4,     3,    -4,     6
                dc.w    -2,     3,    -2,     6
                dc.w    0,     3,     0,     6
                dc.w    0,     3,     0,     6
                dc.w    0,     5,     0,     6
                dc.w    0,     5,     0,     6
                dc.w    0,     5,     0,     6
                dc.w    0,     5,     0,     6
                dc.w    0,     5,     0,     8
                dc.w    0,     5,     0,     8
                dc.w    0,     5,     0,     8
                dc.w    0,     5,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
SKSSZBeam_OtherZoneGeometry:
                dc.w    0,     3,     0,     4
                dc.w    0,     3,     0,     4
                dc.w    0,     3,     0,     4
                dc.w    0,     3,     0,     6
                dc.w    0,     3,     0,     6
                dc.w    0,     3,     0,     6
                dc.w    0,     3,     0,     6
                dc.w    0,     5,     0,     6
                dc.w    0,     5,     0,     6
                dc.w    0,     5,     0,     6
                dc.w    0,     5,     0,     6
                dc.w    0,     5,     0,     8
                dc.w    0,     5,     0,     8
                dc.w    0,     5,     0,     8
                dc.w    0,     5,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
                dc.w    0,     7,     0,     8
SKSSZRotatingRide_RiderFlipAndFramePairs:
                dc.b    1, $55
                dc.b    0, $59
                dc.b    0, $5A
                dc.b    0, $5B
                dc.b    1, $5A
                dc.b    1, $59
                dc.b    0, $55
                dc.b    0, $56
                dc.b    0, $57
                dc.b    0, $58
                dc.b    1, $57
                dc.b    1, $56
SKSSZRetractSpring_SolidHeights:
                dc.b    $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $10, $10,  $F
                dc.b    $E,  $D,  $C,  $B,   9,   7,   5,   2,  -1,  -5, -$C, -$C, -$C, -$C, -$C, -$C
                even
