; Owner: objects/shared/s3
; Responsibility: Tunnel exhaust control, directional vents, timed emission and smoke sprite motion
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_TunnelExhaustControl:
                move.l  #Map_TunnelExhaust,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$180,priority(a0)
                tst.b   subtype(a0)
                beq.s   S3Exhaust_InitFiniteLifeAndDirection
                move.l  #Obj_TunnelExContinuous,(a0)
                bra.w   Obj_TunnelExContinuous
; ---------------------------------------------------------------------------

S3Exhaust_InitFiniteLifeAndDirection:
                move.w  #60,$30(a0)
                tst.w   y_vel(a0)
                beq.s   S3Exhaust_SelectDirectionFromXVel
                bmi.s   S3Exhaust_SelectActEmitter
                move.w  #6,angle(a0)                    ; angle is 6 if moving downward, 0 if moving upward
                bra.s   S3Exhaust_SelectActEmitter
; ---------------------------------------------------------------------------

S3Exhaust_SelectDirectionFromXVel:
                move.w  #$C,angle(a0)                   ; If vertical movement is null
                tst.w   x_vel(a0)
                bmi.s   S3Exhaust_SelectActEmitter
                move.w  #$12,angle(a0)                  ; angle is $C if X velocity is to the left, $12 if to the right

S3Exhaust_SelectActEmitter:
                tst.b   (Current_act).w
                bne.s   S3Exhaust_InstallFiniteJet
                move.l  #Obj_TunnelExSmoke,(a0)         ; If in act 1, just make smoke
                bra.w   Obj_TunnelExSmoke
; ---------------------------------------------------------------------------

S3Exhaust_InstallFiniteJet:
                move.l  #Obj_TunnelExhaustControlMain,(a0)  ; If in act 2

Obj_TunnelExhaustControlMain:
                subq.w  #1,$2E(a0)
                bpl.s   S3Exhaust_TickFiniteEmitterLife
                move.w  #4-1,$2E(a0)                    ; Make a new exhaust sprite every 4 frames
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3Exhaust_TickFiniteEmitterLife
                move.l  #Obj_TunnelExhaustUp,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_TunnelExhaust,mappings(a1)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  #$380,priority(a1)
                move.w  angle(a0),d0
                cmpi.w  #6,d0
                bne.s   S3Exhaust_ApplyDirectionAndSelectJet
                move.l  #Obj_TunnelExhaustDown,(a1)     ; If moving downward, change the object to use

S3Exhaust_ApplyDirectionAndSelectJet:
                lea     S3Exhaust_DirectionRecords(pc,d0.w),a2
                move.w  (a2)+,x_vel(a1)
                move.w  (a2)+,y_vel(a1)
                move.b  (a2)+,render_flags(a1)
                move.b  (a2)+,mapping_frame(a1)
                bne.s   S3Exhaust_TickFiniteEmitterLife
                move.l  #Obj_TunnelExhaustHorz,(a1)
                bsr.s   ReduceNewHorizontalExhaustSpeed

S3Exhaust_TickFiniteEmitterLife:
                subq.w  #1,$30(a0)                      ; Continue doing this until timer runs out
                bpl.s   S3Exhaust_CullFiniteEmitter
                move.w  #$7FF0,x_pos(a0)

S3Exhaust_CullFiniteEmitter:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------
S3Exhaust_DirectionRecords:
                dc.w    0                               ; X velocity
                dc.w    -$600                           ; Y velocity
                dc.b    $86                             ; Flip value
                dc.b    1                               ; Mapping frame
                dc.w    0
                dc.w    $400
                dc.b    $84
                dc.b    1
                dc.w    -$600
                dc.w    0
                dc.b    $85
                dc.b    0
                dc.w    $600
                dc.w    0
                dc.b    $84
                dc.b    0

; =============== S U B R O U T I N E =======================================

ReduceNewHorizontalExhaustSpeed:
                moveq   #0,d0                           ; Slow down exhaust trickle over time
                move.w  $30(a0),d0
                subi.w  #$3C,d0
                neg.w   d0
                lsl.w   #4,d0
                tst.w   x_vel(a1)
                bmi.s   S3Exhaust_ApplyElapsedSpeedTaper
                neg.w   d0

S3Exhaust_ApplyElapsedSpeedTaper:
                add.w   d0,x_vel(a1)
                rts
; End of function ReduceNewHorizontalExhaustSpeed

; ---------------------------------------------------------------------------

Obj_TunnelExhaustUp:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                bne.s   S3Exhaust_MoveUpAndCheckCull
                bchg    #0,render_flags(a0)             ; Change X flip every 2 frames

S3Exhaust_MoveUpAndCheckCull:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.s   S3TunnelExhaust_CullAndDrawUpParticle  ; If on-screen, branch
                tst.w   y_vel(a0)
                bmi.s   S3TunnelExhaust_CullAndDrawUpParticle  ; If vertical velocity is going upwards, branch
                move.w  #$7FF0,x_pos(a0)                ; Ensure that the object is definitely offscreen

S3TunnelExhaust_CullAndDrawUpParticle:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_TunnelExhaustDown:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                bne.s   S3Exhaust_MoveDownAndCheckCull
                bchg    #0,render_flags(a0)             ; Change X flip every 2 frames

S3Exhaust_MoveDownAndCheckCull:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.s   S3TunnelExhaust_CullAndDrawDownParticle  ; If on-screen, branch
                cmpi.w  #$C00,y_vel(a0)
                blt.s   S3TunnelExhaust_CullAndDrawDownParticle  ; If vertical velocity is less than $C00, branch
                move.w  #$7FF0,x_pos(a0)

S3TunnelExhaust_CullAndDrawDownParticle:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_TunnelExhaustHorz:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                bne.s   S3Exhaust_MoveHorizontalAndCheckCull
                bchg    #1,render_flags(a0)

; When offscreen, move X to $7FF0 once falling speed reaches $600
S3Exhaust_MoveHorizontalAndCheckCull:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.s   S3Exhaust_DrawHorizontalIfVisible
                cmpi.w  #$600,y_vel(a0)
                blt.s   S3Exhaust_DrawHorizontalIfVisible
                move.w  #$7FF0,x_pos(a0)

S3Exhaust_DrawHorizontalIfVisible:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_TunnelExContinuous:
                move.b  (Level_frame_counter+1).w,d0    ; This control object creates new sprites continuously
                andi.b  #3,d0
                bne.s   S3Exhaust_CullContinuousEmitter
                jsr     (AllocateObjectAfterCurrent).l  ; Create a new sprite every four frames
                bne.w   S3Exhaust_CullContinuousEmitter
                move.l  #Obj_TunnelExhaustTimed,(a1)    ; This is a timed exhaust (the short waterfalls in LBZ2 for example)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_TunnelExhaust,mappings(a1)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  #$380,priority(a1)
                move.w  #0,x_vel(a1)
                move.w  #$400,y_vel(a1)
                move.b  #$84,render_flags(a1)
                move.b  #1,mapping_frame(a1)
                move.w  #$C-1,$2E(a1)

S3Exhaust_CullContinuousEmitter:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

Obj_TunnelExhaustTimed:
                subq.w  #1,$2E(a0)
                bpl.s   S3Exhaust_ToggleTimedXFlip
                move.w  #$C-1,$2E(a0)
                move.w  #$7FF0,x_pos(a0)

S3Exhaust_ToggleTimedXFlip:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                bne.s   S3Exhaust_MoveTimedAndMarkHidden
                bchg    #0,render_flags(a0)

S3Exhaust_MoveTimedAndMarkHidden:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.s   S3TunnelExhaust_CullAndDrawTimedParticle
                move.w  #$7FF0,x_pos(a0)

S3TunnelExhaust_CullAndDrawTimedParticle:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_TunnelExSmoke:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                bne.s   S3Exhaust_TickSmokeEmitterLife
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3Exhaust_TickSmokeEmitterLife
                move.l  #Obj_FireShield_Dissipate,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_vel(a0),x_vel(a1)
                move.w  y_vel(a0),y_vel(a1)

S3Exhaust_TickSmokeEmitterLife:
                subq.w  #1,$30(a0)
                bpl.s   S3Exhaust_CullSmokeEmitter
                move.w  #$7FF0,x_pos(a0)

S3Exhaust_CullSmokeEmitter:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------
; unused
                move.l  #Map_TunnelExhaust,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$180,priority(a0)
                move.w  #2*60,$30(a0)
                move.l  #S3Exhaust_UpdateUnusedLeftEmitter,(a0)

S3Exhaust_UpdateUnusedLeftEmitter:
                tst.b   $32(a0)
                bne.s   S3Exhaust_ToggleUnusedEmitterPhase
                subq.w  #1,$2E(a0)
                bpl.s   S3Exhaust_ToggleUnusedEmitterPhase
                move.w  #4-1,$2E(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3Exhaust_ToggleUnusedEmitterPhase
                move.l  #S3Exhaust_ToggleUnusedJetYFlip,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_TunnelExhaust,mappings(a1)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  #$380,priority(a1)
                ori.b   #4,render_flags(a1)
                bset    #0,render_flags(a1)
                move.w  #-$800,x_vel(a1)
                moveq   #0,d0
                move.b  subtype(a0),d0
                addq.w  #1,d0
                add.w   d0,d0
                move.w  d0,$2E(a1)
                addi.w  #$10,x_pos(a1)
                move.b  #$C6,collision_flags(a1)

S3Exhaust_ToggleUnusedEmitterPhase:
                subq.w  #1,$30(a0)
                bpl.s   S3Exhaust_CullUnusedEmitter
                move.w  #2*60,$30(a0)
                eori.b  #$FF,$32(a0)

S3Exhaust_CullUnusedEmitter:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

S3Exhaust_ToggleUnusedJetYFlip:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                bne.s   S3Exhaust_MoveUnusedJetAndTickLife
                bchg    #1,render_flags(a0)

S3Exhaust_MoveUnusedJetAndTickLife:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   S3Exhaust_ConsumeUnusedJetContacts
                move.w  #$7FF0,x_pos(a0)

S3Exhaust_ConsumeUnusedJetContacts:
                move.b  collision_property(a0),d0
                beq.w   S3Exhaust_DrawAndRegisterUnusedJet
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   S3Exhaust_TryUnusedJetLaunchP2
                bsr.s   LaunchPlayerLeftFromExhaustJet

S3Exhaust_TryUnusedJetLaunchP2:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   S3Exhaust_DrawAndRegisterUnusedJet
                bsr.s   LaunchPlayerLeftFromExhaustJet

S3Exhaust_DrawAndRegisterUnusedJet:
                jmp     (Sprite_CheckDeleteTouch3).l

; =============== S U B R O U T I N E =======================================

LaunchPlayerLeftFromExhaustJet:
                tst.b   object_control(a1)
                bne.s   S3Exhaust_UnusedJetLaunchReturn
                move.w  y_pos(a0),y_pos(a1)
                cmpi.w  #-$1000,x_vel(a1)
                beq.s   S3Exhaust_UnusedJetLaunchReturn
                move.b  #$1A,anim(a1)
                clr.b   jumping(a1)
                move.w  #0,ground_vel(a1)
                move.w  #-$1000,x_vel(a1)
                move.w  #0,y_vel(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)

S3Exhaust_UnusedJetLaunchReturn:
                rts
; End of function LaunchPlayerLeftFromExhaustJet

; ---------------------------------------------------------------------------
Map_TunnelExhaust:
                include "src/objects/shared/zones/lbz/mappings/lrz_tunnel_exhaust.s"
