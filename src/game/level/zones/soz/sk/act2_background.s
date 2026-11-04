; Owner: game/level/zones/soz/sk
; Responsibility: Sandopolis act-two background initialization, event control, deformation and private sequence data
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

SOZ2_BackgroundInit:
                jsr     ClearSoz2EntranceBackgroundChunkStrip(pc)
                moveq   #$10,d0
                cmpi.w  #$2980,(Player_1+x_pos).w
                blo.s   SKSOZ2BG_InitHalfSpeedBackground
                moveq   #$20,d0

SKSOZ2BG_InitHalfSpeedBackground:
                move.w  d0,(Events_routine_bg).w
                jsr     SetSoz2HalfSpeedBackgroundCoordinates(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                moveq   #0,d1
                jsr     (Refresh_PlaneFull).l
                jmp     (PlainDeformation).l
; ---------------------------------------------------------------------------

SOZ2_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     SOZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SOZ2_BackgroundEvent_Index:
                bra.w   SKSOZ2BG_TryBeginEntranceRedraw  ; $00
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_PositionEntranceBackground  ; $04
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_TrySpawnAct2TitleCard  ; $08
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_FadeInAndReleaseLocks  ; $0C
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_TryExitSandWindow      ; $10
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_CheckFirstStageExit    ; $14 Rising sand #1
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_CheckSecondStageExitAndLimit  ; $18 Rising sand #2
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_PositionExitBackground  ; $1C
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_TryEnterBossPlane      ; $20
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_TrackCameraMinY        ; $24
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_HoldTimersAndCheckBossEnd  ; $28
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_WaitForArtAndRedrawPostBoss  ; $2C
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_PositionPostBossBackground  ; $30
; ---------------------------------------------------------------------------

SKSOZ2BG_TryBeginEntranceRedraw:
                cmpi.w  #8,(Events_routine_fg).w
                blo.s   SKSOZ2BG_EntranceWaitReturn
                jsr     ClearSoz2EntranceBackgroundChunkStrip(pc)
                jsr     SetSoz2HalfSpeedBackgroundCoordinates(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKSOZ2BG_RedrawEntranceAndInitFade
; ---------------------------------------------------------------------------

SKSOZ2BG_EntranceWaitReturn:
                rts
; ---------------------------------------------------------------------------

SKSOZ2BG_PositionEntranceBackground:
                jsr     SetSoz2HalfSpeedBackgroundCoordinates(pc)

SKSOZ2BG_RedrawEntranceAndInitFade:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.w   SKSOZ2BG_DrawHalfSpeedRow
                move.w  #$10-1,(Palette_fade_info).w
                move.w  #$15,(Events_bg+$00).w
                addq.w  #4,(Events_routine_bg).w

SKSOZ2BG_TrySpawnAct2TitleCard:
                btst    #0,(Level_frame_counter+1).w
                beq.s   SKSOZ2BG_TryExitSandWindow
                cmpi.w  #5,(Events_bg+$00).w
                bne.s   SKSOZ2BG_FadeInFirstPaletteRange
                jsr     (AllocateObject).l
                bne.s   SKSOZ2BG_FadeInFirstPaletteRange
                move.l  #Obj_TitleCard,(a1)
                st      $3E(a1)

SKSOZ2BG_FadeInFirstPaletteRange:
                move.l  a0,-(sp)
                jsr     (Pal_FromBlack).l
                movea.l (sp)+,a0
                subq.w  #1,(Events_bg+$00).w
                bpl.s   SKSOZ2BG_TryExitSandWindow
                move.w  #$4020-1,(Palette_fade_info).w
                move.w  #$15,(Events_bg+$00).w
                addq.w  #4,(Events_routine_bg).w

SKSOZ2BG_FadeInAndReleaseLocks:
                btst    #0,(Level_frame_counter+1).w
                beq.s   SKSOZ2BG_TryExitSandWindow
                move.l  a0,-(sp)
                jsr     (Pal_FromBlack).l
                movea.l (sp)+,a0
                subq.w  #1,(Events_bg+$00).w
                bpl.s   SKSOZ2BG_TryExitSandWindow
                move.l  #$6000,d0
                move.l  d0,(Camera_min_X_pos).w
                move.l  d0,(Camera_target_min_X_pos).w
                move.l  #-$FFF800,d0
                move.l  d0,(Camera_min_Y_pos).w
                move.l  d0,(Camera_target_min_Y_pos).w
                clr.w   (Palette_fade_timer).w
                clr.w   (Ctrl_1_locked).w
                addq.w  #4,(Events_routine_bg).w

SKSOZ2BG_TryExitSandWindow:
                jsr     IsPlayerInSoz2RisingSandExitWindow(pc)
                beq.s   SKSOZ2BG_CheckRisingSandSignal
                move.w  #$18,(Events_routine_bg).w
                bra.w   SKSOZ2BG_CacheSandPositionAndRedraw
; ---------------------------------------------------------------------------

SKSOZ2BG_CheckRisingSandSignal:
                tst.w   (Events_fg_5).w
                bne.s   SKSOZ2BG_SelectRisingSandStage
                jsr     SetSoz2HalfSpeedBackgroundCoordinates(pc)

SKSOZ2BG_DrawHalfSpeedRow:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     (Draw_TileRow).l
                jmp     (PlainDeformation).l
; ---------------------------------------------------------------------------

SKSOZ2BG_SelectRisingSandStage:
                clr.w   (Events_fg_5).w
                addq.w  #4,(Events_routine_bg).w
                moveq   #0,d0
                move.w  #$80,d0
                cmpi.w  #$400,(Player_1+y_pos).w
                blo.s   SKSOZ2BG_SetSandOffsetAndStartScroll
                addq.w  #4,(Events_routine_bg).w
                move.w  #$3E0,d0

SKSOZ2BG_SetSandOffsetAndStartScroll:
                swap    d0
                move.l  d0,(SceneAuxiliaryYOrVerticalMotion).w
                jsr     AlignSoz2RisingSandBackgroundCamera(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                subi.w  #$10,(Camera_Y_pos_BG_rounded).w
                move.w  #$10,(Special_events_routine).w
                cmpi.w  #$14,(Events_routine_bg).w
                beq.s   SKSOZ2BG_DrawFirstStageAndCheckRiders
                bra.s   SKSOZ2BG_DrawSecondStageAndCheckRiders
; ---------------------------------------------------------------------------

SKSOZ2BG_CheckFirstStageExit:
                jsr     IsPlayerInSoz2RisingSandExitWindow(pc)
                beq.s   SKSOZ2BG_CheckFirstStageLimit
                move.w  #$18,(Events_routine_bg).w
                bra.s   SKSOZ2BG_CacheSandPositionAndRedraw
; ---------------------------------------------------------------------------

SKSOZ2BG_CheckFirstStageLimit:
                tst.w   (Events_fg_5).w
                bne.s   SKSOZ2BG_StartSecondStageScroll
                cmpi.w  #$400,(SceneAuxiliaryYOrVerticalMotion).w
                blo.s   SKSOZ2BG_AlignFirstStageBackground
                clr.w   (Special_events_routine).w

SKSOZ2BG_AlignFirstStageBackground:
                jsr     AlignSoz2RisingSandBackgroundCamera(pc)

SKSOZ2BG_DrawFirstStageAndCheckRiders:
                jsr     (DrawBGAsYouMove).l
                jsr     (PlainDeformation).l
                jmp     Go_CheckPlayerRelease(pc)
; ---------------------------------------------------------------------------

SKSOZ2BG_StartSecondStageScroll:
                clr.w   (Events_fg_5).w
                move.w  #$10,(Special_events_routine).w
                addq.w  #4,(Events_routine_bg).w

SKSOZ2BG_CheckSecondStageExitAndLimit:
                jsr     IsPlayerInSoz2RisingSandExitWindow(pc)
                bne.s   SKSOZ2BG_CacheSandPositionAndRedraw
                cmpi.w  #$A00,(SceneAuxiliaryYOrVerticalMotion).w
                blo.s   SKSOZ2BG_AlignSecondStageBackground
                clr.w   (Special_events_routine).w

SKSOZ2BG_AlignSecondStageBackground:
                jsr     AlignSoz2RisingSandBackgroundCamera(pc)

SKSOZ2BG_DrawSecondStageAndCheckRiders:
                jsr     (DrawBGAsYouMove).l
                jsr     (PlainDeformation).l
                jmp     Go_CheckPlayerRelease(pc)
; ---------------------------------------------------------------------------

SKSOZ2BG_CacheSandPositionAndRedraw:
                move.w  (Camera_X_pos_BG_copy).w,(Events_bg+$02).w
                move.w  (Camera_Y_pos_BG_copy).w,(Events_bg+$04).w
                jsr     SetSoz2HalfSpeedBackgroundCoordinates(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                move.w  #$1F0,(Draw_delayed_position).w
                move.w  #$1F,(Draw_delayed_rowcount).w
                clr.w   (Events_fg_5).w
                clr.w   (Special_events_routine).w
                clr.b   (Background_collision_flag).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKSOZ2BG_RedrawExitRightToLeft
; ---------------------------------------------------------------------------

SKSOZ2BG_PositionExitBackground:
                jsr     SetSoz2HalfSpeedBackgroundCoordinates(pc)

SKSOZ2BG_RedrawExitRightToLeft:
                move.w  (Camera_Y_pos_BG_copy).w,d1
                moveq   #0,d2
                jsr     (Draw_PlaneHorzRightToLeft).l
                bpl.s   SKSOZ2BG_DrawNewRowAndRestoreOldPos
                clr.w   (Events_bg+$02).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKSOZ2BG_DrawNewRowAndRestoreOldPos
; ---------------------------------------------------------------------------

SKSOZ2BG_TryEnterBossPlane:
                cmpi.w  #$5000,(Player_1+x_pos).w
                blo.s   SKSOZ2BG_PositionOrdinaryBackground
                cmpi.w  #$500,(Camera_Y_pos).w
                bhs.s   SKSOZ2BG_InitBossPlaneLayout

SKSOZ2BG_PositionOrdinaryBackground:
                jsr     SetSoz2HalfSpeedBackgroundCoordinates(pc)

SKSOZ2BG_DrawNewRowAndRestoreOldPos:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     (Draw_TileRow).l
                move.w  (Events_bg+$02).w,d0
                beq.s   SKSOZ2BG_ApplyOrdinaryDeformation
                move.w  d0,(Camera_X_pos_BG_copy).w
                move.w  (Events_bg+$04).w,(Camera_Y_pos_BG_copy).w

SKSOZ2BG_ApplyOrdinaryDeformation:
                jmp     (PlainDeformation).l
; ---------------------------------------------------------------------------

SKSOZ2BG_InitBossPlaneLayout:
                move.w  #$5250,(Events_bg+$0C).w
                move.w  #$6D8,(Events_bg+$0E).w
                movea.w (a3),a1
                move.w  -8(a3),d0
                subq.w  #4,d0
                moveq   #0,d1
                moveq   #$10-1,d2

SKSOZ2BG_BeginBossLayoutRow:
                moveq   #4-1,d3

SKSOZ2BG_ShiftAndClearBossLayoutBytes:
                move.b  (a1),4(a1)
                move.b  d1,(a1)+
                dbf     d3,SKSOZ2BG_ShiftAndClearBossLayoutBytes
                adda.w  d0,a1
                dbf     d2,SKSOZ2BG_BeginBossLayoutRow
                lea     (HScroll_table).w,a1
                moveq   #$80-1,d2

SKSOZ2BG_ClearBossScrollWorkspace:
                move.l  d1,(a1)+
                dbf     d2,SKSOZ2BG_ClearBossScrollWorkspace
                jsr     UpdateSoz2BossPlaneBandAnimation(pc)
                lea     (HScroll_table).w,a1
                moveq   #$D-1,d0

SKSOZ2BG_InitRoundedBandsAndArena:
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)+
                dbf     d0,SKSOZ2BG_InitRoundedBandsAndArena
                move.w  #$500,(Camera_min_Y_pos).w
                move.w  #$680,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  #$5140,(Camera_max_X_pos).w
                movem.l d7-a0/a2-a3,-(sp)
                lea     (SOZ2_16x16_Custom_Kos).l,a1
                lea     (Block_table+$EA0).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_SOZ2_Custom).l,a1
                move.w  #tiles_to_bytes($315),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$7FFF,(Palette_cycle_counter1).w
                move.b  #0,(SOZ_darkness_level).w
                move.w  (Palette_cycle_counters+$06).w,d0
                neg.b   d0
                move.b  d0,(Palette_cycle_counters+$00).w
                move.w  #0,(Palette_cycle_counters+$08).w
                move.b  #$7F,(Anim_Counters).w
                jsr     SpawnSoz2BossBandCollisionProxies(pc)
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKSOZ2BG_DrawBossBandsAndShake
; ---------------------------------------------------------------------------

SKSOZ2BG_TrackCameraMinY:
                move.w  (Camera_Y_pos_copy).w,d0
                cmp.w   (Camera_min_Y_pos).w,d0
                beq.s   SKSOZ2BG_CheckCameraAtBossMaxY
                move.w  d0,(Camera_min_Y_pos).w

SKSOZ2BG_CheckCameraAtBossMaxY:
                cmp.w   (Camera_max_Y_pos).w,d0
                bne.s   SKSOZ2BG_HoldTimersAndCheckBossEnd
                addq.w  #4,(Events_routine_bg).w

SKSOZ2BG_HoldTimersAndCheckBossEnd:
                move.w  #$7FFF,(Palette_cycle_counter1).w
                move.b  #$7F,(Anim_Counters).w
                tst.w   (Events_fg_5).w
                bmi.s   SKSOZ2BG_QueuePostBossRestoration
                jsr     UpdateSoz2BossPlaneBandAnimation(pc)

SKSOZ2BG_DrawBossBandsAndShake:
                lea     SOZ2_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #$D,d5
                jsr     (Draw_BG).l
                lea     SOZ2_BGDrawArray(pc),a4
                lea     (HScroll_table+$100).w,a5
                jsr     (ApplyDeformation).l
                jmp     (ShakeScreen_Setup).l
; ---------------------------------------------------------------------------

SKSOZ2BG_QueuePostBossRestoration:
                move.w  (Camera_X_pos_BG_copy).w,d0
                subi.w  #$100,d0
                move.w  d0,(Events_bg+$02).w
                jsr     SetSoz2PostBossBackgroundCoordinates(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                movem.l d7-a0/a2-a3,-(sp)
                lea     (SOZ2_16x16_Secondary_Kos).l,a1
                lea     (Block_table+$EA0).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_SOZ2_Secondary).l,a1
                move.w  #tiles_to_bytes($315),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PalID_SOZ2,d0
                jsr     (LoadPalette_Immediate).l
                movem.l (sp)+,d7-a0/a2-a3
                addq.w  #4,(Events_routine_bg).w

SKSOZ2BG_WaitForArtAndRedrawPostBoss:
                tst.b   (Kos_modules_left).w
                bne.s   SKSOZ2BG_TryRestoreCachedBossX
                jsr     SetSoz2PostBossBackgroundCoordinates(pc)
                move.w  #$200,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.s   SKSOZ2BG_DrawPostBossRow
                clr.w   (Events_bg+$02).w
                move.w  #$52C0,(Camera_max_X_pos).w
                clr.b   (Anim_Counters).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKSOZ2BG_DrawPostBossRow
; ---------------------------------------------------------------------------

SKSOZ2BG_PositionPostBossBackground:
                jsr     SetSoz2PostBossBackgroundCoordinates(pc)

SKSOZ2BG_DrawPostBossRow:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                move.w  #$200,d1
                moveq   #$20,d6
                jsr     (Draw_TileRow).l

SKSOZ2BG_TryRestoreCachedBossX:
                move.w  (Events_bg+$02).w,d0
                beq.s   SKSOZ2BG_ApplyPostBossScrollAndShake
                move.w  d0,(Camera_X_pos_BG_copy).w

SKSOZ2BG_ApplyPostBossScrollAndShake:
                jsr     (PlainDeformation).l
                jmp     (ShakeScreen_Setup).l

; =============== S U B R O U T I N E =======================================

SetSoz2HalfSpeedBackgroundCoordinates:
                move.w  (Camera_Y_pos_copy).w,d0
                asr.w   #1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                asr.w   #1,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                rts
; End of function SetSoz2HalfSpeedBackgroundCoordinates

; =============== S U B R O U T I N E =======================================

AlignSoz2RisingSandBackgroundCamera:
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$2E0,d0
                add.w   (SceneAuxiliaryYOrVerticalMotion).w,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$1930,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                rts
; End of function AlignSoz2RisingSandBackgroundCamera

; =============== S U B R O U T I N E =======================================

UpdateSoz2BossPlaneBandAnimation:
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$250,d0
                move.w  #$6D8,d1
                sub.w   (Events_bg+$0E).w,d1
                add.w   d1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$4010,d0
                move.w  #$5250,d1
                sub.w   (Events_bg+$0C).w,d1
                add.w   d1,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                cmpi.b  #6,(Player_1+routine).w
                bhs.w   SKSOZ2BG_ExportBossBandScroll
                move.w  (Events_bg+$08).w,d0
                jmp     SKSOZ2BG_BossBandStateBranches(pc,d0.w)
; ---------------------------------------------------------------------------

SKSOZ2BG_BossBandStateBranches:
                bra.w   SKSOZ2BG_TryStartImpactPulse
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_WaitForSecondPulse
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_WaitAndSelectWaveDelays
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_BeginOutwardWaveStep
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_StepReturnOrIntermission
; ---------------------------------------------------------------------------
                bra.w   SKSOZ2BG_BeginFinalCollapseStep
; ---------------------------------------------------------------------------

SKSOZ2BG_TryStartImpactPulse:
                jsr     SKSOZ2BG_CheckFinalCollapseOverride(pc)
                tst.w   (Events_bg+$0A).w
                beq.w   SKSOZ2BG_ExportBossBandScroll
                lea     (HScroll_table+$134).w,a1
                moveq   #-1,d0
                moveq   #9-1,d1

SKSOZ2BG_WriteFirstPulseOffsets:
                move.w  d0,-(a1)
                subq.w  #1,d0
                dbf     d1,SKSOZ2BG_WriteFirstPulseOffsets
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                move.w  #3,(Events_bg+$06).w
                addq.w  #4,(Events_bg+$08).w

SKSOZ2BG_WaitForSecondPulse:
                jsr     SKSOZ2BG_CheckFinalCollapseOverride(pc)
                subq.w  #1,(Events_bg+$06).w
                bpl.w   SKSOZ2BG_ExportBossBandScroll
                lea     (HScroll_table+$134).w,a1
                moveq   #-1,d0
                moveq   #9-1,d1

SKSOZ2BG_WriteSecondPulseOffsets:
                move.w  d0,-(a1)
                subq.w  #2,d0
                dbf     d1,SKSOZ2BG_WriteSecondPulseOffsets
                move.w  #8,(Events_bg+$06).w
                addq.w  #4,(Events_bg+$08).w

SKSOZ2BG_WaitAndSelectWaveDelays:
                jsr     SKSOZ2BG_CheckFinalCollapseOverride(pc)
                subq.w  #1,(Events_bg+$06).w
                bpl.w   SKSOZ2BG_ExportBossBandScroll
                lea     (HScroll_table+$184).w,a1
                lea     $3E(a1),a5
                lea     SKSOZ2BG_WaveDelayWindowCenter(pc),a6
                move.w  (Events_bg+$0A).w,d0
                sub.w   (Camera_Y_pos_copy).w,d0
                add.w   (Camera_Y_pos_BG_copy).w,d0
                subi.w  #$440,d0
                bcc.s   SKSOZ2BG_CalcWaveDelayWindowOffset
                moveq   #0,d0

SKSOZ2BG_CalcWaveDelayWindowOffset:
                lsr.w   #3,d0
                andi.w  #$FFFE,d0
                cmpi.w  #$10,d0
                bls.s   SKSOZ2BG_SelectWaveDelayWindow
                moveq   #$10,d0

SKSOZ2BG_SelectWaveDelayWindow:
                suba.w  d0,a6
                moveq   #9-1,d1

SKSOZ2BG_InitWaveVelocitiesAndDelays:
                move.l  #$80000,(a1)+
                move.w  (a6)+,(a5)+
                dbf     d1,SKSOZ2BG_InitWaveVelocitiesAndDelays
                clr.w   (Events_bg+$00).w
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                addq.w  #4,(Events_bg+$08).w

SKSOZ2BG_BeginOutwardWaveStep:
                jsr     SKSOZ2BG_CheckFinalCollapseOverride(pc)
                lea     (HScroll_table+$144).w,a1
                lea     $40(a1),a5
                lea     $3E(a5),a6
                moveq   #9,d0
                moveq   #9-1,d1

SKSOZ2BG_CheckOutwardBandState:
                tst.b   (a6)
                beq.s   SKSOZ2BG_MoveAndDecelOutwardBand
                bpl.s   SKSOZ2BG_TickOutwardBandDelay
                subq.w  #1,d0
                bra.s   SKSOZ2BG_AdvanceOutwardBand
; ---------------------------------------------------------------------------

SKSOZ2BG_TickOutwardBandDelay:
                subq.b  #1,(a6)
                bra.s   SKSOZ2BG_AdvanceOutwardBand
; ---------------------------------------------------------------------------

SKSOZ2BG_MoveAndDecelOutwardBand:
                move.l  (a5),d2
                sub.l   d2,(a1)
                subi.l  #$2800,(a5)
                bpl.s   SKSOZ2BG_AdvanceOutwardBand
                st      (a6)

; Play the recovery sound once when at least one band has finished and others are still pending
SKSOZ2BG_AdvanceOutwardBand:
                addq.w  #4,a1
                addq.w  #4,a5
                addq.w  #2,a6
                dbf     d1,SKSOZ2BG_CheckOutwardBandState
                tst.w   d0
                beq.s   SKSOZ2BG_BindPulseOffsetsForClear
                cmpi.w  #9,d0
                beq.w   SKSOZ2BG_ExportBossBandScroll
                tst.w   (Events_bg+$00).w
                bne.w   SKSOZ2BG_ExportBossBandScroll
                moveq   #signextendB(sfx_BossRecovery),d0
                jsr     (Play_SFX).l
                st      (Events_bg+$00).w
                bra.w   SKSOZ2BG_ExportBossBandScroll
; ---------------------------------------------------------------------------

SKSOZ2BG_BindPulseOffsetsForClear:
                lea     (HScroll_table+$122).w,a1
                moveq   #9-1,d1

SKSOZ2BG_ClearPulseAndBeginReturn:
                clr.w   (a1)+
                dbf     d1,SKSOZ2BG_ClearPulseAndBeginReturn
                clr.w   (Events_bg+$06).w
                addq.w  #4,(Events_bg+$08).w

SKSOZ2BG_StepReturnOrIntermission:
                jsr     SKSOZ2BG_CheckFinalCollapseOverride(pc)
                tst.w   (Events_bg+$06).w
                beq.s   SKSOZ2BG_BeginReturnWaveStep
                subq.w  #1,(Events_bg+$06).w
                bne.w   SKSOZ2BG_ExportBossBandScroll
                clr.w   (Events_bg+$0A).w
                clr.w   (Events_bg+$08).w
                bra.w   SKSOZ2BG_ExportBossBandScroll
; ---------------------------------------------------------------------------

SKSOZ2BG_BeginReturnWaveStep:
                lea     (HScroll_table+$144).w,a1
                lea     $40(a1),a5
                lea     $3F(a5),a6
                moveq   #9,d0
                moveq   #9-1,d1

SKSOZ2BG_CheckReturnBandState:
                tst.b   (a6)
                beq.s   SKSOZ2BG_MoveAndClampReturnBand
                bpl.s   SKSOZ2BG_TickReturnBandDelay
                subq.w  #1,d0
                bra.s   SKSOZ2BG_AdvanceReturnBand
; ---------------------------------------------------------------------------

SKSOZ2BG_TickReturnBandDelay:
                subq.b  #1,(a6)
                bra.s   SKSOZ2BG_AdvanceReturnBand
; ---------------------------------------------------------------------------

SKSOZ2BG_MoveAndClampReturnBand:
                move.l  (a5),d2
                subi.l  #$2800,(a5)
                sub.l   d2,(a1)
                bmi.s   SKSOZ2BG_AdvanceReturnBand
                clr.l   (a1)
                st      (a6)

SKSOZ2BG_AdvanceReturnBand:
                addq.w  #4,a1
                addq.w  #4,a5
                addq.w  #2,a6
                dbf     d1,SKSOZ2BG_CheckReturnBandState
                tst.w   d0
                bne.s   SKSOZ2BG_ExportBossBandScroll
                move.w  #$F,(Events_bg+$06).w
                bra.s   SKSOZ2BG_ExportBossBandScroll
; ---------------------------------------------------------------------------

SKSOZ2BG_CheckFinalCollapseOverride:
                tst.w   (Events_fg_5).w
                bne.s   SKSOZ2BG_InitFinalCollapseDelays
                rts
; ---------------------------------------------------------------------------

SKSOZ2BG_InitFinalCollapseDelays:
                lea     (HScroll_table+$1C2).w,a1
                moveq   #0,d0
                moveq   #$C-1,d1

; Discard the caller's return address and enter the final collapse in place of the current band state
SKSOZ2BG_WriteCollapseStaggerDelays:
                move.w  d0,(a1)+
                addq.w  #5,d0
                dbf     d1,SKSOZ2BG_WriteCollapseStaggerDelays
                move.w  #$5140,(Camera_max_X_pos).w
                move.w  #$14,(Events_bg+$08).w
                addq.w  #4,sp

SKSOZ2BG_BeginFinalCollapseStep:
                lea     (HScroll_table+$144).w,a1
                lea     $7E(a1),a5
                moveq   #$C,d0
                moveq   #$C-1,d1

SKSOZ2BG_TickCollapseDelayOrMove:
                tst.w   (a5)
                beq.s   SKSOZ2BG_MoveAndClampCollapseBand
                subq.w  #1,(a5)
                bra.s   SKSOZ2BG_AdvanceBandAndTrySignalEnd
; ---------------------------------------------------------------------------

SKSOZ2BG_MoveAndClampCollapseBand:
                subq.w  #5,(a1)
                cmpi.w  #-$100,(a1)
                bgt.s   SKSOZ2BG_AdvanceBandAndTrySignalEnd
                move.w  #-$100,(a1)
                subq.w  #1,d0

SKSOZ2BG_AdvanceBandAndTrySignalEnd:
                addq.w  #4,a1
                addq.w  #2,a5
                dbf     d1,SKSOZ2BG_TickCollapseDelayOrMove
                tst.w   d0
                bne.s   SKSOZ2BG_ExportBossBandScroll
                st      (Events_fg_5).w

SKSOZ2BG_ExportBossBandScroll:
                move.l  a0,-(sp)
                lea     (HScroll_table).w,a0
                lea     $100(a0),a1
                lea     $20(a1),a5
                lea     $20(a5),a6
                move.w  (Camera_X_pos_BG_copy).w,d0
                moveq   #$D-1,d1

SKSOZ2BG_WriteCompositeBandOffset:
                move.w  (a5)+,d2
                add.w   (a6),d2
                add.w   d0,d2
                move.w  d2,(a0)
                move.w  d2,(a1)+
                addq.w  #4,a0
                addq.w  #4,a6
                dbf     d1,SKSOZ2BG_WriteCompositeBandOffset
                movea.l (sp)+,a0
                rts
; End of function UpdateSoz2BossPlaneBandAnimation

; =============== S U B R O U T I N E =======================================

SetSoz2PostBossBackgroundCoordinates:
                move.w  (Camera_Y_pos_copy).w,d0
                asr.w   #1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                asr.w   #1,d0
                addi.w  #$200,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                rts
; End of function SetSoz2PostBossBackgroundCoordinates

; =============== S U B R O U T I N E =======================================

ClearSoz2EntranceBackgroundChunkStrip:
                movea.w $38(a3),a5
                movea.w $3C(a3),a6
                lea     $17(a5),a5
                lea     $17(a6),a6
                moveq   #$A-1,d0

SKSOZ2BG_ClearEntranceRows:
                clr.b   (a5)+
                clr.b   (a6)+
                dbf     d0,SKSOZ2BG_ClearEntranceRows
                rts
; End of function ClearSoz2EntranceBackgroundChunkStrip

; =============== S U B R O U T I N E =======================================

IsPlayerInSoz2RisingSandExitWindow:
                cmpi.w  #$2A00,(Player_1+x_pos).w
                blo.s   SKSOZ2BG_OutsideSandExitReturnZero
                move.w  (Player_1+y_pos).w,d0
                cmpi.w  #$140,d0
                blo.s   SKSOZ2BG_OutsideSandExitReturnZero
                cmpi.w  #$180,d0
                bhi.s   SKSOZ2BG_OutsideSandExitReturnZero
                moveq   #-1,d0
                rts
; ---------------------------------------------------------------------------

SKSOZ2BG_OutsideSandExitReturnZero:
                moveq   #0,d0
                rts
; End of function IsPlayerInSoz2RisingSandExitWindow

; ---------------------------------------------------------------------------

SKSOZ2BG_StepSandCollisionOffset:
                st      (Background_collision_flag).w
                addi.l  #$A000,(SceneAuxiliaryYOrVerticalMotion).w
                move.w  #$2E0,d0
                add.w   (SceneAuxiliaryYOrVerticalMotion).w,d0
                neg.w   d0
                move.w  d0,(Camera_Y_diff).w
                move.w  #$1930,(Camera_X_diff).w
                rts
; ---------------------------------------------------------------------------

Go_CheckPlayerRelease:
                movem.l d7-a0/a2-a3,-(sp)
                lea     (Player_1).w,a1
                btst    #Status_OnObj,status(a1)
                beq.s   SKSOZ2BG_CheckP2ObjectRelease
                movea.w interact(a1),a0
                jsr     (CheckPlayerReleaseFromObj).l

SKSOZ2BG_CheckP2ObjectRelease:
                lea     (Player_2).w,a1
                btst    #Status_OnObj,status(a1)
                beq.s   SKSOZ2BG_RestoreReleaseCheckRegisters
                movea.w interact(a1),a0
                jsr     (CheckPlayerReleaseFromObj).l

SKSOZ2BG_RestoreReleaseCheckRegisters:
                movem.l (sp)+,d7-a0/a2-a3
                rts

; =============== S U B R O U T I N E =======================================

SpawnSoz2BossBandCollisionProxies:
                jsr     (AllocateObject).l
                bne.s   SKSOZ2BG_ProxyAllocReturn
                move.l  #SKSOZ2BG_UpdateBandCollisionProxy,d1
                moveq   #8-1,d2

SKSOZ2BG_AllocateBandCollisionProxies:
                move.l  d1,(a1)
                move.w  d2,subtype(a1)
                jsr     (CreateNewSprite4).l
                dbne    d2,SKSOZ2BG_AllocateBandCollisionProxies

SKSOZ2BG_ProxyAllocReturn:
                rts
; End of function SpawnSoz2BossBandCollisionProxies

; ---------------------------------------------------------------------------

SKSOZ2BG_UpdateBandCollisionProxy:
                move.b  #$40,width_pixels(a0)
                bset    #7,status(a0)
                move.w  subtype(a0),d0
                lsl.w   #4,d0
                addi.w  #$458,d0
                sub.w   (Camera_Y_pos_BG_copy).w,d0
                add.w   (Camera_Y_pos_copy).w,d0
                move.w  d0,y_pos(a0)
                move.w  subtype(a0),d0
                add.w   d0,d0
                lea     SKSOZ2BG_ProxyXAnchors(pc),a1
                move.w  (a1,d0.w),d4
                add.w   d0,d0
                lea     (HScroll_table+$008).w,a1
                sub.w   (a1,d0.w),d4
                add.w   (Camera_X_pos_copy).w,d4
                cmpi.w  #$10,(Events_bg+$08).w
                beq.s   SKSOZ2BG_ResolveProxyAndTryKickP1
                move.w  #$7FFF,d4

SKSOZ2BG_ResolveProxyAndTryKickP1:
                move.w  d4,x_pos(a0)
                moveq   #$4B,d1
                moveq   #8,d2
                moveq   #8,d3
                jsr     (SolidObjectFull2).l
                move.w  #-$300,d0
                lea     (Player_1).w,a1
                btst    #$10,d6
                beq.s   SKSOZ2BG_TryKickP2
                move.w  d0,x_vel(a1)
                move.w  d0,y_vel(a1)

SKSOZ2BG_TryKickP2:
                lea     (Player_2).w,a1
                btst    #$11,d6
                beq.s   SKSOZ2BG_ProxyCollisionReturn
                move.w  d0,x_vel(a1)
                move.w  d0,y_vel(a1)

SKSOZ2BG_ProxyCollisionReturn:
                rts
; ---------------------------------------------------------------------------
SOZ2_BGDrawArray:
                dc.w    $440,   $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10, $7FFF
                dc.w    $1800
                dc.w    $1502
                dc.w    $1204
                dc.w    $0F06
                dc.w    $0C08
                dc.w    $090A
                dc.w    $060C
                dc.w    $030E
; The window can start up to eight words before this label. Each word stores outward delay high and return delay low
SKSOZ2BG_WaveDelayWindowCenter:
                dc.w    $0010
                dc.w    $030E
                dc.w    $060C
                dc.w    $090A
                dc.w    $0C08
                dc.w    $0F06
                dc.w    $1204
                dc.w    $1502
                dc.w    $1800
SKSOZ2BG_ProxyXAnchors:
                dc.w    $1268
                dc.w    $1260
                dc.w    $1260
                dc.w    $125C
                dc.w    $1254
                dc.w    $1248
                dc.w    $1248
                dc.w    $1248
