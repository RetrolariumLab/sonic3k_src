; Owner: objects/players/ddz/sk
; Responsibility: Doomsday player flight controller, scripted entry, camera limits, debugging transition and failure state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

DDZ_FlightDispatchAndLatchDebug:
                bsr.w   DDZFlight_TryFailAfterSuperExpires
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DDZFlightController_EntryStateOffsets(pc,d0.w),d1
                jsr     DDZFlightController_EntryStateOffsets(pc,d1.w)
                move.w  (_unkFABC).w,d0
                move.w  (Debug_placement_mode).w,d1
                move.w  d1,(_unkFABC).w
                eor.w   d1,d0
                beq.s   DDZ_FlightCameraOrVirtualScroll
                bsr.w   HandleDDZFlightDebugModeTransition

DDZ_FlightCameraOrVirtualScroll:
                tst.w   d1
                bne.s   DDZ_FlightUpdateReturn
                bsr.w   DDZFlight_AdvanceCameraAndCarry
                bsr.w   DDZFlight_SyncPlayerAndTrackCamera
                btst    #1,(_unkFAB8).w
                beq.s   DDZ_FlightUpdateReturn
                move.l  #DDZ_FlightUpdateVirtualBossStage,(a0)
                bset    #3,$38(a0)
                move.l  (Camera_X_pos).w,d0
                move.l  d0,(_unkFA86).w
                swap    d0
                move.w  d0,(Camera_stored_min_X_pos).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                addi.w  #$140,d0
                move.w  d0,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   DDZ_FlightTryExpandCameraMaxX
                move.l  #Obj_DecLevStartXGradual,(a1)

DDZ_FlightTryExpandCameraMaxX:
                jsr     (AllocateObject).l
                bne.s   DDZ_FlightUpdateReturn
                move.l  #Obj_IncLevEndXGradual,(a1)

DDZ_FlightUpdateReturn:
                rts
; ---------------------------------------------------------------------------
DDZFlightController_EntryStateOffsets:
                dc.w    DDZ_FlightInitEntryAndPlayer-DDZFlightController_EntryStateOffsets
                dc.w    DDZ_FlightEntryGravityThenSuper-DDZFlightController_EntryStateOffsets
                dc.w    DDZ_FlightRiseUntilPlayerReleased-DDZFlightController_EntryStateOffsets
                dc.w    DDZ_FlightUpdateEarlyFreeFlight-DDZFlightController_EntryStateOffsets

; =============== S U B R O U T I N E =======================================

HandleDDZFlightDebugModeTransition:
                tst.w   d1
                bne.s   DDZ_FlightDebugUnlockCameraX
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.b  #1,object_control(a1)
                clr.b   anim(a1)
                move.w  #$800,x_vel(a1)
                move.w  #$800,ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

DDZ_FlightDebugUnlockCameraX:
                clr.w   (Camera_min_X_pos).w
                move.w  #$7FFF,(Camera_max_X_pos).w
                rts
; End of function HandleDDZFlightDebugModeTransition

; ---------------------------------------------------------------------------

DDZ_FlightInitEntryAndPlayer:
                move.b  #2,routine(a0)
                move.w  a0,(_unkFA8E).w
                move.w  #$17,$2E(a0)
                move.w  #$400,x_vel(a0)
                st      (Scroll_lock).w
                move.b  #1,(Boss_flag).w
                move.l  #$10000,(_unkFA82).w
                move.l  #$800,(_unkFA8A).w
                lea     (Player_1).w,a1
                bset    #7,art_tile(a1)
                move.b  #$81,object_control(a1)
                move.b  #2,anim(a1)
                clr.b   status(a1)
                move.w  (Camera_X_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$20,d0
                move.w  d0,y_pos(a0)
                lea     DDZ_FlightInitialWindowBounds(pc),a1
                lea     (_unkFAB0).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                move.w  #0,(Camera_min_Y_pos).w
                move.w  #$120,(Camera_max_Y_pos).w
                move.w  #$120,(Camera_target_max_Y_pos).w
                lea     (Player_2).w,a1
                moveq   #0,d0
                moveq   #$12-1,d1

DDZ_FlightClearP2AndTryTempoWatcher:
                move.l  d0,(a1)+
                dbf     d1,DDZ_FlightClearP2AndTryTempoWatcher
                clr.w   (a1)
                jsr     (AllocateObject).l
                bne.s   DDZFlightController_QueueDoomsdayMiscArt
                move.l  #DDZ_RingWarningCheckTenRingThreshold,(a1)

DDZFlightController_QueueDoomsdayMiscArt:
                lea     (ArtKosM_DDZMisc).l,a1
                move.w  #tiles_to_bytes(ArtTile_DDZMisc),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------
DDZ_FlightInitialWindowBounds:
                dc.w    $20,   $C0
                dc.w    $20,   $C0
; ---------------------------------------------------------------------------

DDZ_FlightEntryGravityThenSuper:
                jsr     (MoveSprite_LightGravity).l
                subq.w  #1,$2E(a0)
                bpl.w   DDZ_MotionHelpersReturn
                move.b  #4,routine(a0)
                bset    #7,$38(a0)
                addi.w  #50,(Ring_count).w
                move.b  #1,(Super_palette_status).w
                move.b  #$F,(Palette_timer).w
                move.b  #1,(Super_Sonic_Knux_flag).w
                move.w  #60,(Super_frame_count).w
                move.l  #Map_SuperSonic,(Player_1+mappings).w
                move.b  #$81,(Player_1+object_control).w
                move.b  #$1F,(Player_1+anim).w
                move.w  #$A00,(Max_speed).w
                move.w  #$30,(Acceleration).w
                move.w  #$100,(Deceleration).w
                move.b  #0,(Player_1+invincibility_timer).w
                bset    #Status_Invincible,(Player_1+status_secondary).w
                moveq   #signextendB(sfx_Whistle),d0    ; This is not the normal Super transformation SFX
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

DDZ_FlightRiseUntilPlayerReleased:
                subi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                lea     (Player_1).w,a1
                tst.b   object_control(a1)
                bne.w   DDZ_MotionHelpersReturn
                move.b  #6,routine(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                bset    #2,$38(a0)
                move.b  #1,object_control(a1)
                clr.b   anim(a1)
                move.w  #$1000,x_vel(a1)
                move.w  #$1000,ground_vel(a1)
                cmpi.b  #7,(Super_emerald_count).w
                beq.s   DDZ_FlightInstallHyperEffects
                move.l  #DDZ_InitSuperStarTrailAndArt,(Super_stars).w
                bra.w   DDZ_FlightLoadBossExplosionPLC
; ---------------------------------------------------------------------------

DDZ_FlightInstallHyperEffects:
                jsr     (EndingAndDDZPrepareHyperSonicVisualState).l
                move.l  #Obj_HyperSonic_Stars,(Invincibility_stars).w
                move.l  #Obj_HyperSonicKnux_Trail,(Super_stars).w

DDZ_FlightLoadBossExplosionPLC:
                lea     (PLC_BossExplosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

DDZ_FlightUpdateEarlyFreeFlight:
                bsr.w   DDZFlight_ComputeInputAndHitVel
                bra.w   DDZFlight_IntegrateWithinView
; ---------------------------------------------------------------------------

DDZ_FlightUpdateVirtualBossStage:
                bsr.w   DDZFlight_TryFailAfterSuperExpires
                bsr.w   DDZFlight_ComputeInputAndHitVel
                bsr.w   DDZFlight_IntegrateWithinView
                bsr.w   DDZBoss_AdvanceVirtualScroll
                bsr.w   DDZFlight_SyncPlayerAndTrackCamera
                btst    #0,(_unkFAB8).w
                beq.s   DDZ_FlightVirtualStageReturn
                move.l  #DDZ_FlightRebaseFinalChaseCamera,(a0)
                move.w  #$140,$3C(a0)

DDZ_FlightVirtualStageReturn:
                rts
; ---------------------------------------------------------------------------

DDZ_FlightRebaseFinalChaseCamera:
                clr.w   (_unkFAAE).w
                move.w  (Camera_X_pos).w,d0
                cmpi.w  #$7400,d0
                blo.s   DDZ_FlightUpdateFinalChase
                move.w  #$2000,d1
                sub.w   d1,d0
                move.w  d0,(Camera_X_pos).w
                jsr     (Seek_Object_Manager).l
                moveq   #0,d0
                lea     (Ring_status_table).w,a1
                move.w  #bytesToLcnt($400),d1

DDZ_FlightClearRingsAndSetWrapDelta:
                move.l  d0,(a1)+
                dbf     d1,DDZ_FlightClearRingsAndSetWrapDelta
                move.w  (Camera_X_pos).w,d0
                subi.w  #$80,d0
                andi.w  #$FF80,d0
                move.w  d0,(Camera_X_pos_coarse_back).w
                move.w  #$2000,d1
                move.w  d1,(_unkFAAE).w
                sub.w   d1,x_pos(a0)

DDZ_FlightUpdateFinalChase:
                bsr.w   DDZFlight_TryFailAfterSuperExpires
                bsr.w   DDZFlight_ComputeInputAndHitVel
                bsr.w   DDZFlight_IntegrateWithinView
                move.w  (_unkFABC).w,d0
                move.w  (Debug_placement_mode).w,d1
                move.w  d1,(_unkFABC).w
                eor.w   d1,d0
                beq.s   DDZ_FlightAdvanceCameraOutsideDebug
                bsr.w   HandleDDZFlightDebugModeTransition

DDZ_FlightAdvanceCameraOutsideDebug:
                tst.w   d1
                bne.w   DDZ_MotionHelpersReturn
                bsr.w   DDZFlight_AdvanceCameraAndCarry
                bra.w   DDZFlight_SyncPlayerAndTrackCamera
; ---------------------------------------------------------------------------

DDZ_FlightFallAndTryPlayerDeath:
                lea     (Player_1).w,a1
                jsr     (MoveSprite).l
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$F0,d0
                cmp.w   y_pos(a0),d0
                bhs.w   DDZ_MotionHelpersReturn
                movea.l a0,a2
                lea     (Player_1).w,a1
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l a2,a0
                jmp     (Delete_Current_Sprite).l
