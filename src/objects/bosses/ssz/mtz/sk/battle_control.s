; Owner: objects/bosses/ssz/mtz/sk
; Responsibility: Sky Sanctuary Metropolis-style boss controller, attack progression and initial coordinated actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSZMTZBoss:
                move.l  #Obj_Wait,(a0)
                move.b  #1,(Boss_flag).w
                move.w  #$1F,$2E(a0)
                move.l  #SSZMTZBoss_InstallMainDispatcher,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                jsr     (AllocateObject).l
                bne.s   SSZMTZ_QueueArtAndSavePalette
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

SSZMTZ_QueueArtAndSavePalette:
                clr.w   (_unkFA88).w
                moveq   #PLCID_7B,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_SSZMTZOrbs).l,a1
                move.w  #tiles_to_bytes(ArtTile_SSZMTZOrbs),d2
                jsr     (Queue_Kos_Module).l
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

SSZMTZBoss_SavePaletteAndLoadOrbColors:
                move.l  (a1)+,(a2)+
                dbf     d6,SSZMTZBoss_SavePaletteAndLoadOrbColors
                lea     Pal_SSZMTZOrbs(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

SSZMTZBoss_InstallMainDispatcher:
                move.l  #SSZMTZBoss_DispatchMainRoutine,(a0)

SSZMTZBoss_ReturnFromSetupOrSharedPolicy:
                rts
; ---------------------------------------------------------------------------

SSZMTZBoss_DispatchMainRoutine:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SSZMTZBoss_MainRoutineOffsets(pc,d0.w),d1
                jmp     SSZMTZBoss_MainRoutineOffsets(pc,d1.w)
; ---------------------------------------------------------------------------
SSZMTZBoss_MainRoutineOffsets:
                dc.w    SSZMTZ_InitShipAndOrbRing-SSZMTZBoss_MainRoutineOffsets
                dc.w    SSZMTZBoss_DispatchAttackPhase-SSZMTZBoss_MainRoutineOffsets
; ---------------------------------------------------------------------------

SSZMTZ_InitShipAndOrbRing:
                move.l  #Map_RobotnikShip,mappings(a0)
                move.w  #make_art_tile(ArtTile_RobotnikShip,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$180,priority(a0)
                move.w  #$1700,x_pos(a0)
                move.w  #$300,y_pos(a0)
                move.b  #$A,mapping_frame(a0)
                addq.b  #2,routine(a0)
                move.b  #$11,collision_flags(a0)
                move.b  #8,collision_property(a0)
                move.b  #7,$3C(a0)
                move.w  x_pos(a0),(SSZ_MTZ_boss_X_pos).w
                move.w  y_pos(a0),(SSZ_MTZ_boss_Y_pos).w
                move.w  #0,(SSZ_MTZ_boss_X_vel).w
                move.w  #$100,(SSZ_MTZ_boss_Y_vel).w
                move.b  #$20,width_pixels(a0)
                clr.b   $2E(a0)
                clr.b   $30(a0)
                move.b  #$40,$1D(a0)
                move.b  #$27,$38(a0)
                move.b  #$27,$3A(a0)
                lea     (Child1_MakeMechaHead).l,a2
                jsr     (CreateChild1_Normal).l
                jsr     (AllocateObject).l
                bne.s   SSZMTZ_SeedPackedAnimScratch
                move.l  #SSZMTZOrb_DispatchState,(a1)
                move.l  a0,$34(a1)

SSZMTZ_SeedPackedAnimScratch:
                lea     (_unkFA82).w,a2
                move.b  #$10,(a2)+
                move.b  #0,(a2)+
                move.b  #3,(a2)+
                move.b  #0,(a2)+
                move.b  #1,(a2)+
                move.b  #0,(a2)+
                rts
; ---------------------------------------------------------------------------

SSZMTZBoss_DispatchAttackPhase:
                moveq   #0,d0
                move.b  $26(a0),d0
                move.w  SSZMTZBoss_AttackPhaseOffsets(pc,d0.w),d1
                jmp     SSZMTZBoss_AttackPhaseOffsets(pc,d1.w)
; ---------------------------------------------------------------------------
SSZMTZBoss_AttackPhaseOffsets:
                dc.w    SSZMTZ_DescendAndChooseDirection-SSZMTZBoss_AttackPhaseOffsets
                dc.w    SSZMTZ_MovePassAndCheckLeftLimit-SSZMTZBoss_AttackPhaseOffsets
                dc.w    SSZMTZ_RiseToCenterAndStopY-SSZMTZBoss_AttackPhaseOffsets
                dc.w    SSZMTZ_ExpandAndFlattenOrbit-SSZMTZBoss_AttackPhaseOffsets
                dc.w    SSZMTZBoss_RetractOrbitRadius-SSZMTZBoss_AttackPhaseOffsets
                dc.w    SSZMTZ_FlattenOrbitAfterOrbRelease-SSZMTZBoss_AttackPhaseOffsets
                dc.w    SSZMTZ_RecoverOrbitOrBeginLaser-SSZMTZBoss_AttackPhaseOffsets
                dc.w    SSZMTZ_TickPauseOrDispatchLaser-SSZMTZBoss_AttackPhaseOffsets
; ---------------------------------------------------------------------------

SSZMTZ_DescendAndChooseDirection:
                bsr.w   Boss_MoveObject
                move.w  (SSZ_MTZ_boss_Y_pos).w,$14(a0)
                cmpi.w  #$420,(SSZ_MTZ_boss_Y_pos).w
                blo.s   SSZMTZ_CheckHitAndTouchDraw
                addq.b  #2,$26(a0)
                move.w  #0,(SSZ_MTZ_boss_Y_vel).w
                move.w  #-$100,(SSZ_MTZ_boss_X_vel).w
                bclr    #7,$2E(a0)
                bclr    #0,render_flags(a0)
                move.w  (Player_1+x_pos).w,d0
                cmp.w   (SSZ_MTZ_boss_X_pos).w,d0
                blo.s   SSZMTZ_CheckHitAndTouchDraw
                move.w  #$100,(SSZ_MTZ_boss_X_vel).w
                bset    #7,$2E(a0)
                bset    #0,render_flags(a0)

SSZMTZ_CheckHitAndTouchDraw:
                bsr.w   SSZMTZBoss_CheckHitOrbRelease
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

ApplySSZMTZBossFourPixelSineBob:
                move.b  $1D(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #6,d0
                add.w   (SSZ_MTZ_boss_Y_pos).w,d0
                move.w  d0,y_pos(a0)
                addq.b  #4,$1D(a0)
                rts
; End of function ApplySSZMTZBossFourPixelSineBob

; ---------------------------------------------------------------------------

SSZMTZ_MovePassAndCheckLeftLimit:
                bsr.w   Boss_MoveObject
                btst    #7,$2E(a0)
                bne.s   SSZMTZBoss_TestRightBoundaryAndTurn
                cmpi.w  #$1680,(SSZ_MTZ_boss_X_pos).w
                bhs.s   SSZMTZBoss_SynchronizeXAndApplySineBob
                bchg    #7,$2E(a0)
                move.w  #$100,(SSZ_MTZ_boss_X_vel).w
                bset    #0,render_flags(a0)
                bset    #6,$2E(a0)
                beq.s   SSZMTZBoss_SynchronizeXAndApplySineBob
                addq.b  #2,$26(a0)
                move.w  #-$100,(SSZ_MTZ_boss_Y_vel).w
                bra.s   SSZMTZBoss_SynchronizeXAndApplySineBob
; ---------------------------------------------------------------------------

SSZMTZBoss_TestRightBoundaryAndTurn:
                cmpi.w  #$1780,(SSZ_MTZ_boss_X_pos).w
                blo.s   SSZMTZBoss_SynchronizeXAndApplySineBob
                bchg    #7,$2E(a0)
                move.w  #-$100,(SSZ_MTZ_boss_X_vel).w
                bclr    #0,render_flags(a0)
                bset    #6,$2E(a0)
                beq.s   SSZMTZBoss_SynchronizeXAndApplySineBob
                addq.b  #2,$26(a0)
                move.w  #-$100,(SSZ_MTZ_boss_Y_vel).w

SSZMTZBoss_SynchronizeXAndApplySineBob:
                move.w  (SSZ_MTZ_boss_X_pos).w,x_pos(a0)
                bsr.w   ApplySSZMTZBossFourPixelSineBob

SSZMTZBoss_ApplyActiveHitPolicyAndDraw:
                bsr.w   SSZMTZBoss_CheckHitOrbRelease
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZMTZ_RiseToCenterAndStopY:
                bsr.w   Boss_MoveObject
                cmpi.w  #$3F0,(SSZ_MTZ_boss_Y_pos).w
                bhs.s   SSZMTZ_StopXAtCenter
                move.w  #0,(SSZ_MTZ_boss_Y_vel).w

SSZMTZ_StopXAtCenter:
                btst    #7,$2E(a0)
                bne.s   SSZMTZBoss_StopRightwardMotionAtCenter
                cmpi.w  #$1700,(SSZ_MTZ_boss_X_pos).w
                bhs.s   SSZMTZ_AdvanceAfterMotionStops
                move.w  #0,(SSZ_MTZ_boss_X_vel).w
                bra.s   SSZMTZ_AdvanceAfterMotionStops
; ---------------------------------------------------------------------------

SSZMTZBoss_StopRightwardMotionAtCenter:
                cmpi.w  #$1700,(SSZ_MTZ_boss_X_pos).w
                blo.s   SSZMTZ_AdvanceAfterMotionStops
                move.w  #0,(SSZ_MTZ_boss_X_vel).w

SSZMTZ_AdvanceAfterMotionStops:
                move.w  (SSZ_MTZ_boss_X_vel).w,d0
                or.w    (SSZ_MTZ_boss_Y_vel).w,d0
                bne.s   SSZMTZBoss_DrawAfterCenteringStep
                addq.b  #2,$26(a0)

SSZMTZBoss_DrawAfterCenteringStep:
                bra.s   SSZMTZBoss_SynchronizeXAndApplySineBob
; ---------------------------------------------------------------------------

SSZMTZ_ExpandAndFlattenOrbit:
                cmpi.b  #$68,$38(a0)
                bhs.s   SSZMTZBoss_FlattenOrbitUntilZeroScale
                addq.b  #1,$38(a0)
                addq.b  #1,$3A(a0)
                bra.s   SSZMTZBoss_DrawExpandedOrFlatteningOrbit
; ---------------------------------------------------------------------------

SSZMTZBoss_FlattenOrbitUntilZeroScale:
                subq.b  #1,$3A(a0)
                bne.s   SSZMTZBoss_DrawExpandedOrFlatteningOrbit
                addq.b  #2,$26(a0)

SSZMTZBoss_DrawExpandedOrFlatteningOrbit:
                bra.s   SSZMTZBoss_SynchronizeXAndApplySineBob
; ---------------------------------------------------------------------------

SSZMTZBoss_RetractOrbitRadius:
                cmpi.b  #$27,$38(a0)
                blo.s   SSZMTZ_RestoreOrbitAndDescend
                subq.b  #1,$38(a0)
                bra.s   SSZMTZBoss_DrawRetractingOrRestoredOrbit
; ---------------------------------------------------------------------------

SSZMTZ_RestoreOrbitAndDescend:
                addq.b  #1,$3A(a0)
                cmpi.b  #$27,$3A(a0)
                blo.s   SSZMTZBoss_DrawRetractingOrRestoredOrbit
                move.w  #$100,(SSZ_MTZ_boss_Y_vel).w
                move.b  #0,$26(a0)
                bclr    #6,$2E(a0)

SSZMTZBoss_DrawRetractingOrRestoredOrbit:
                bra.w   SSZMTZBoss_SynchronizeXAndApplySineBob
; ---------------------------------------------------------------------------

SSZMTZ_FlattenOrbitAfterOrbRelease:
                tst.b   $3A(a0)
                beq.s   SSZMTZBoss_RequestOrbPhaseFold
                subq.b  #1,$3A(a0)
                bra.s   SSZMTZBoss_RetractRadiusAfterOrbRelease
; ---------------------------------------------------------------------------

SSZMTZBoss_RequestOrbPhaseFold:
                move.b  #-1,$3B(a0)

SSZMTZBoss_RetractRadiusAfterOrbRelease:
                cmpi.b  #$27,$38(a0)
                blo.s   SSZMTZ_RiseAfterOrbRelease
                subq.b  #1,$38(a0)

SSZMTZ_RiseAfterOrbRelease:
                bsr.w   Boss_MoveObject
                cmpi.w  #$3B0,(SSZ_MTZ_boss_Y_pos).w
                bhs.s   SSZMTZ_WaitForDetachedOrbs
                move.w  #0,(SSZ_MTZ_boss_Y_vel).w

SSZMTZ_WaitForDetachedOrbs:
                tst.b   $30(a0)
                bne.s   SSZMTZBoss_DrawDuringReleasedOrbWait
                tst.b   $3B(a0)
                beq.s   SSZMTZBoss_AdvanceToOrbRecoveryPhase
                move.b  #$80,$3B(a0)

SSZMTZBoss_AdvanceToOrbRecoveryPhase:
                addq.b  #2,$26(a0)

SSZMTZBoss_DrawDuringReleasedOrbWait:
                bra.w   SSZMTZBoss_SynchronizeXAndApplySineBob
; ---------------------------------------------------------------------------

SSZMTZ_RecoverOrbitOrBeginLaser:
                tst.b   $3C(a0)
                beq.s   SSZMTZ_BeginUnshieldedDiagonal
                tst.b   $3B(a0)
                bne.s   SSZMTZ_DrawDuringRecovery
                cmpi.b  #$27,$3A(a0)
                bhs.s   SSZMTZ_DescendAfterOrbitRecovery
                addq.b  #1,$3A(a0)
                bra.s   SSZMTZ_DrawDuringRecovery
; ---------------------------------------------------------------------------

SSZMTZ_DescendAfterOrbitRecovery:
                move.w  #$100,(SSZ_MTZ_boss_Y_vel).w
                move.b  #0,$26(a0)
                bclr    #6,$2E(a0)
                bra.s   SSZMTZ_DrawDuringRecovery
; ---------------------------------------------------------------------------

SSZMTZ_BeginUnshieldedDiagonal:
                move.w  #-$180,(SSZ_MTZ_boss_Y_vel).w
                move.w  #-$100,(SSZ_MTZ_boss_X_vel).w
                bclr    #0,render_flags(a0)
                btst    #7,$2E(a0)
                beq.s   SSZMTZ_InitLaserSubstate
                move.w  #$100,(SSZ_MTZ_boss_X_vel).w
                bset    #0,render_flags(a0)

SSZMTZ_InitLaserSubstate:
                move.b  #$E,$26(a0)
                move.b  #0,$32(a0)
                bclr    #6,$2E(a0)
                move.b  #0,$33(a0)

SSZMTZ_DrawDuringRecovery:
                bra.w   SSZMTZBoss_SynchronizeXAndApplySineBob
; ---------------------------------------------------------------------------

SSZMTZ_TickPauseOrDispatchLaser:
                tst.b   $33(a0)
                beq.s   SSZMTZ_DispatchLaserSubstate
                subq.b  #1,$33(a0)
                bra.w   SSZMTZBoss_ApplyActiveHitPolicyAndDraw
; ---------------------------------------------------------------------------

SSZMTZ_DispatchLaserSubstate:
                moveq   #0,d0
                move.b  $32(a0),d0
                move.w  SSZMTZBoss_UnshieldedMovementOffsets(pc,d0.w),d1
                jmp     SSZMTZBoss_UnshieldedMovementOffsets(pc,d1.w)
; ---------------------------------------------------------------------------
SSZMTZBoss_UnshieldedMovementOffsets:
                dc.w    SSZMTZ_MoveUpperApproach-SSZMTZBoss_UnshieldedMovementOffsets
                dc.w    SSZMTZ_DescendAndReverseLaserPass-SSZMTZBoss_UnshieldedMovementOffsets
                dc.w    SSZMTZ_RiseAndRestoreXMotion-SSZMTZBoss_UnshieldedMovementOffsets
; ---------------------------------------------------------------------------

SSZMTZ_MoveUpperApproach:
                bsr.w   Boss_MoveObject
                cmpi.w  #$3B0,(SSZ_MTZ_boss_Y_pos).w
                bhs.s   SSZMTZ_CheckLeftAndArmBurst
                move.w  #0,(SSZ_MTZ_boss_Y_vel).w

SSZMTZ_CheckLeftAndArmBurst:
                btst    #7,$2E(a0)
                bne.s   SSZMTZ_CheckRightAndArmBurst
                cmpi.w  #$16A0,(SSZ_MTZ_boss_X_pos).w
                bhs.s   SSZMTZBoss_DrawAfterUnshieldedApproach
                addq.b  #2,$32(a0)
                move.w  #$180,(SSZ_MTZ_boss_Y_vel).w
                move.b  #3,$31(a0)
                move.w  #$1E,(SSZ_MTZ_boss_laser_timer).w
                bset    #0,render_flags(a0)
                bra.s   SSZMTZBoss_DrawAfterUnshieldedApproach
; ---------------------------------------------------------------------------

SSZMTZ_CheckRightAndArmBurst:
                cmpi.w  #$1760,(SSZ_MTZ_boss_X_pos).w
                blo.s   SSZMTZBoss_DrawAfterUnshieldedApproach
                addq.b  #2,$32(a0)
                move.w  #$180,(SSZ_MTZ_boss_Y_vel).w
                move.b  #3,$31(a0)
                move.w  #$1E,(SSZ_MTZ_boss_laser_timer).w
                bclr    #0,render_flags(a0)

SSZMTZBoss_DrawAfterUnshieldedApproach:
                bra.w   SSZMTZBoss_SynchronizeXAndApplySineBob
; ---------------------------------------------------------------------------

SSZMTZ_DescendAndReverseLaserPass:
                bsr.w   Boss_MoveObject
                cmpi.w  #$420,(SSZ_MTZ_boss_Y_pos).w
                blo.s   SSZMTZ_StopLaserPassAtLeft
                move.w  #-$180,(SSZ_MTZ_boss_Y_vel).w
                addq.b  #2,$32(a0)
                bchg    #7,$2E(a0)
                bra.s   SSZMTZ_TickLaserBurst
; ---------------------------------------------------------------------------

SSZMTZ_StopLaserPassAtLeft:
                btst    #7,$2E(a0)
                bne.s   SSZMTZ_StopLaserPassAtRight
                cmpi.w  #$1680,(SSZ_MTZ_boss_X_pos).w
                bhs.s   SSZMTZ_TickLaserBurst
                move.w  #0,(SSZ_MTZ_boss_X_vel).w
                bra.s   SSZMTZ_TickLaserBurst
; ---------------------------------------------------------------------------

SSZMTZ_StopLaserPassAtRight:
                cmpi.w  #$1780,(SSZ_MTZ_boss_X_pos).w
                blo.s   SSZMTZ_TickLaserBurst
                move.w  #0,(SSZ_MTZ_boss_X_vel).w

SSZMTZ_TickLaserBurst:
                bsr.w   TickSSZMTZBossLaserPairBurst
                bra.w   SSZMTZBoss_SynchronizeXAndApplySineBob
; ---------------------------------------------------------------------------

SSZMTZ_RiseAndRestoreXMotion:
                bsr.w   Boss_MoveObject
                cmpi.w  #$3F0,(SSZ_MTZ_boss_Y_pos).w
                bhs.s   SSZMTZ_StopRiseAndRestartApproach
                move.w  #$100,(SSZ_MTZ_boss_X_vel).w
                btst    #7,$2E(a0)
                bne.s   SSZMTZ_StopRiseAndRestartApproach
                move.w  #-$100,(SSZ_MTZ_boss_X_vel).w

SSZMTZ_StopRiseAndRestartApproach:
                cmpi.w  #$3B0,(SSZ_MTZ_boss_Y_pos).w
                bhs.s   SSZMTZBoss_TickLaserBurstAfterReturnStep
                move.w  #0,(SSZ_MTZ_boss_Y_vel).w
                move.b  #0,$32(a0)

SSZMTZBoss_TickLaserBurstAfterReturnStep:
                bsr.w   TickSSZMTZBossLaserPairBurst
                bra.w   SSZMTZBoss_SynchronizeXAndApplySineBob
