; Owner: objects/shared/s3
; Responsibility: Automatic tunnel player capture, scripted movement, final movement and release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_AutomaticTunnelDelayed:
                subq.b  #1,anim_frame_timer(a0)
                bmi.s   S3AutoTunnel_EnterTunnelAfterSignedDelay
                rts
; ---------------------------------------------------------------------------

S3AutoTunnel_EnterTunnelAfterSignedDelay:
                move.b  #0,anim_frame_timer(a0)

Obj_AutomaticTunnel:
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$280,priority(a0)
                move.l  #S3AutoTunnel_UpdateBothPlayers,(a0)

S3AutoTunnel_UpdateBothPlayers:
                lea     (Player_1).w,a1
                lea     $30(a0),a4
                bsr.s   UpdateAutomaticTunnelForPlayer
                lea     (Player_2).w,a1
                lea     $3A(a0),a4
                bsr.s   UpdateAutomaticTunnelForPlayer
                move.b  $30(a0),d0
                add.b   $3A(a0),d0
                beq.s   S3AutoTunnel_CullWhenBothIdle   ; As long as this object is attached to a character, do not destroy it
                rts
; ---------------------------------------------------------------------------

S3AutoTunnel_CullWhenBothIdle:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdateAutomaticTunnelForPlayer:
                moveq   #0,d0
                move.b  (a4),d0
                move.w  AutoTunnel_Index(pc,d0.w),d0
                jmp     AutoTunnel_Index(pc,d0.w)
; End of function UpdateAutomaticTunnelForPlayer

; ---------------------------------------------------------------------------
AutoTunnel_Index:
                dc.w    Obj_AutoTunnelInit-AutoTunnel_Index
                dc.w    Obj_AutoTunnelRun-AutoTunnel_Index
                dc.w    Obj_AutoTunnelLastMove-AutoTunnel_Index
; ---------------------------------------------------------------------------

Obj_AutoTunnelInit:
                tst.w   (Debug_placement_mode).w
                bne.w   S3AutoTunnel_CaptureReturn      ; If debug mode is on, don't bother
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   S3AutoTunnel_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$18,d1
                cmpi.w  #$28,d1
                bhs.w   S3AutoTunnel_CaptureReturn      ; Only activate if player is in range
                tst.b   object_control(a1)
                bne.s   S3AutoTunnel_CaptureReturn      ; If under control of another object, don't activate
                addq.b  #2,(a4)
                move.b  #$81,object_control(a1)         ; Lock this object to Sonic/Tails
                move.b  #2,anim(a1)                     ; Set player to rolling animation
                clr.b   jumping(a1)                     ; Ensure they're no longer jumping
                move.w  #$800,ground_vel(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)                    ; Null actual velocity but make player very fast
                bclr    #p1_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)        ; Player is not pushing anything and not in the air
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)             ; Lock player's position to object's position
                clr.b   1(a4)
                bsr.w   AutoTunnel_GetPath              ; Get the first path of the tunnel
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                btst    #5,subtype(a0)
                beq.s   S3AutoTunnel_CaptureReturn
                tst.b   (Current_act).w                 ; If bit 5 of object subtype is set and we're in an act 2
                beq.s   S3AutoTunnel_CaptureReturn
                bclr    #Status_FireShield,status_secondary(a1)
                beq.s   S3AutoTunnel_StripLightningShield
                bclr    #Status_Shield,status_secondary(a1)

S3AutoTunnel_StripLightningShield:
                bclr    #Status_LtngShield,status_secondary(a1)
                beq.s   S3AutoTunnel_CaptureReturn
                bclr    #Status_Shield,status_secondary(a1)  ; Disable fire/lightning shields. This is probably for the water tunnels in LBZ2

S3AutoTunnel_CaptureReturn:
                rts
; ---------------------------------------------------------------------------

Obj_AutoTunnelRun:
                subq.b  #1,2(a4)
                bhi.w   S3AutoTunnel_IntegratePlayerPosition
                movea.l 6(a4),a2                        ; If timer has exhausted, get address of path data
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)                    ; Get the new starting position
                tst.b   subtype(a0)
                bpl.s   S3AutoTunnel_AdvanceWaypoint
                subq.w  #8,a2                           ; See if we're going backwards

S3AutoTunnel_AdvanceWaypoint:
                move.l  a2,6(a4)                        ; Replace address of path
                subq.w  #4,4(a4)
                beq.s   S3AutoTunnel_BeginFinalMove     ; If path has exhausted, branch
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  #$1000,d2
                bra.w   AutoTunnel_CalcSpeed            ; Get new velocity
; ---------------------------------------------------------------------------

S3AutoTunnel_BeginFinalMove:
                addq.b  #2,(a4)                         ; Go to next routine
                move.b  #2,2(a4)
                andi.w  #$FFF,y_pos(a1)                 ; Make sure the player's Y position remains valid
                btst    #6,subtype(a0)                  ; If bit 6 is not set
                bne.s   S3AutoTunnel_PlayExitAndTryExhaust
                move.w  #0,x_vel(a1)                    ; Then stop player movement. Otherwise he'll continue moving
                move.w  #0,y_vel(a1)

S3AutoTunnel_PlayExitAndTryExhaust:
                moveq   #signextendB(sfx_TubeLauncher),d0
                jsr     (Play_SFX).l                    ; Play that nifty little cannon shooting sound
                btst    #5,subtype(a0)
                beq.s   S3AutoTunnel_IntegratePlayerPosition
                movea.l a1,a2                           ; If bit 5 set (for LBZ2, again), make the waterfall
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3AutoTunnel_RestorePlayerPointer
                move.l  #Obj_TunnelExhaustControl,(a1)
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                move.w  x_vel(a2),x_vel(a1)
                move.w  y_vel(a2),y_vel(a1)

S3AutoTunnel_RestorePlayerPointer:
                movea.l a2,a1

S3AutoTunnel_IntegratePlayerPosition:
                move.l  x_pos(a1),d2                    ; Perform movement
                move.l  y_pos(a1),d3
                move.w  x_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d2
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3                           ; Add velocity to player
                move.l  d2,x_pos(a1)
                move.l  d3,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

Obj_AutoTunnelLastMove:
                subq.b  #1,2(a4)
                bne.s   S3AutoTunnel_ApplyFinalGravityAndMove  ; This is the last movement
                clr.b   object_control(a1)
                clr.b   (a4)

; Apply gravity on the release update as well as the preceding final movement
S3AutoTunnel_ApplyFinalGravityAndMove:
                addi.w  #$38,y_vel(a1)                  ; Reapply gravity
                bra.s   S3AutoTunnel_IntegratePlayerPosition

; =============== S U B R O U T I N E =======================================

AutoTunnel_GetPath:
                move.b  subtype(a0),d0
                bpl.s   S3AutoTunnel_SelectForwardPathOrFallback
                andi.w  #$1F,d0                         ; If negative, then the path is reversed
                add.w   d0,d0
                add.w   d0,d0
                lea     (AutoTunnel_Data).l,a2
                movea.l (a2,d0.w),a2                    ; Get address of movement data
                move.w  (a2)+,d0
                subq.w  #4,d0
                move.w  d0,4(a4)
                lea     (a2,d0.w),a2
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)                    ; Set absolute position of player
                subq.w  #8,a2
                bra.s   S3AutoTunnel_SavePtrAndCalcFirstLeg
; ---------------------------------------------------------------------------

S3AutoTunnel_SelectForwardPathOrFallback:
                cmpi.b  #$10,d0
                bne.s   S3AutoTunnel_InitForwardPath
                cmpi.w  #2,(Player_mode).w
                bne.s   S3AutoTunnel_InitForwardPath
                moveq   #0,d0                           ; If playing as Tails, use path 0 when doing path $10

S3AutoTunnel_InitForwardPath:
                andi.w  #$1F,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (AutoTunnel_Data).l,a2
                movea.l (a2,d0.w),a2
                move.w  (a2)+,4(a4)
                subq.w  #4,4(a4)
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)                    ; Set absolute position of player

S3AutoTunnel_SavePtrAndCalcFirstLeg:
                move.l  a2,6(a4)
                move.w  (a2)+,d4
                move.w  (a2)+,d5                        ; Get next position
                move.w  #$1000,d2

AutoTunnel_CalcSpeed:
                moveq   #0,d0
                move.w  d2,d3
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                bge.s   S3AutoTunnel_GetYDistanceAndSpeedSign
                neg.w   d0
                neg.w   d2                              ; Change X velocity depending on direction of destination

S3AutoTunnel_GetYDistanceAndSpeedSign:
                moveq   #0,d1
                move.w  d5,d1
                sub.w   $14(a1),d1
                bge.s   S3AutoTunnel_CalcYLedTimeAndXVel
                neg.w   d1
                neg.w   d3                              ; Change Y velocity depending on direction of destination

S3AutoTunnel_CalcYLedTimeAndXVel:
                cmp.w   d0,d1
                blo.s   S3AutoTunnel_CalcXLedTimeAndYVel
                moveq   #0,d1                           ; If X distance is less than Y distance
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                swap    d1
                divs.w  d3,d1
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                beq.s   S3AutoTunnel_SetYLedVelAndAbsTime
                swap    d0
                divs.w  d1,d0

S3AutoTunnel_SetYLedVelAndAbsTime:
                move.w  d0,x_vel(a1)                    ; Calculate and set X velocity assuming a Y velocity of $10 pixels
                move.w  d3,y_vel(a1)
                tst.w   d1
                bpl.s   S3AutoTunnel_StoreYLedFixedPointTime
                neg.w   d1

S3AutoTunnel_StoreYLedFixedPointTime:
                move.w  d1,2(a4)                        ; The quotient of the distance/speed produces a proper timer used for movement
                rts
; ---------------------------------------------------------------------------

S3AutoTunnel_CalcXLedTimeAndYVel:
                moveq   #0,d0                           ; If Y distance is less than X distance
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                swap    d0
                divs.w  d2,d0
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                beq.s   S3AutoTunnel_SetXLedVelAndAbsTime
                swap    d1
                divs.w  d0,d1

S3AutoTunnel_SetXLedVelAndAbsTime:
                move.w  d1,y_vel(a1)                    ; Calculate and set Y velocity assuming a X velocity of $10 pixels
                move.w  d2,x_vel(a1)
                tst.w   d0
                bpl.s   S3AutoTunnel_StoreXLedFixedPointTime
                neg.w   d0

S3AutoTunnel_StoreXLedFixedPointTime:
                move.w  d0,2(a4)                        ; See above
                rts
; End of function AutoTunnel_GetPath
