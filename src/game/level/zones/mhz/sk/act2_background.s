; Owner: game/level/zones/mhz/sk
; Responsibility: Mushroom Hill act-two background initialization, events, deformation and private sequence data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

MHZ2_BackgroundInit:
                move.w  (Camera_X_pos_copy).w,(Events_fg_0).w
                move.w  (Camera_X_pos_copy).w,(Events_fg_1).w
                cmpi.w  #$3700,(Player_1+x_pos).w
                blo.s   SKMHZ2BG_InitOrdinaryBackground
                cmpi.w  #$500,(Player_1+y_pos).w
                bhs.s   SKMHZ2BG_InitOrdinaryBackground
                move.w  #8,(Events_routine_bg).w
                jsr     BuildMhz2ChaseBackgroundCoordinates(pc)
                bra.s   SKMHZ2BG_RefreshInitialBackground
; ---------------------------------------------------------------------------

SKMHZ2BG_InitOrdinaryBackground:
                jsr     MHZ_Deform(pc)

SKMHZ2BG_RefreshInitialBackground:
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

MHZ2_BackgroundEvent:
                lea     (Events_fg_0).w,a1
                move.w  (Camera_X_pos_copy).w,d0
                move.w  #$100,d2
                move.w  #$200,d3
                jsr     Adjust_BGDuringLoop(pc)
                move.w  (Events_routine_bg).w,d0
                jmp     MHZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

MHZ2_BackgroundEvent_Index:
                bra.w   SKMHZ2BG_TryBeginChaseRedraw
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2BG_UpdateChaseRedraw
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2BG_ChooseReverseOrCustomLayout
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2BG_UpdateReverseRedraw
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2BG_TryBeginShipForeground
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2BG_RedrawBossBGAndAllocActors
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2BG_WaitForForegroundFinish
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2BG_RestoreUpperBackground
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2BG_RestoreForegroundRows
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2BG_DrawChaseAndComposeScroll
; ---------------------------------------------------------------------------

SKMHZ2BG_TryBeginChaseRedraw:
                cmpi.w  #$3700,(Player_1+x_pos).w
                blo.s   SKMHZ2BG_UpdateOrdinaryBackground
                cmpi.w  #$500,(Player_1+y_pos).w
                bhs.s   SKMHZ2BG_UpdateOrdinaryBackground
                jsr     BuildMhz2ChaseBackgroundCoordinates(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKMHZ2BG_RedrawChaseBottomUp
; ---------------------------------------------------------------------------

SKMHZ2BG_UpdateOrdinaryBackground:
                jsr     MHZ_Deform(pc)

SKMHZ2BG_DrawOrdinaryRow:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

SKMHZ2BG_UpdateChaseRedraw:
                jsr     BuildMhz2ChaseBackgroundCoordinates(pc)

SKMHZ2BG_RedrawChaseBottomUp:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                bpl.w   SKMHZ2BG_DrawChaseRow
                addq.w  #4,(Events_routine_bg).w
                bra.w   SKMHZ2BG_DrawChaseRow
; ---------------------------------------------------------------------------

SKMHZ2BG_ChooseReverseOrCustomLayout:
                cmpi.w  #$500,(Player_1+y_pos).w
                blo.s   SKMHZ2BG_CheckCustomLayoutSwap
                jsr     MHZ_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.w   SKMHZ2BG_RedrawOrdinaryBottomUp
; ---------------------------------------------------------------------------

SKMHZ2BG_CheckCustomLayoutSwap:
                cmpi.w  #$420,(Player_1+y_pos).w
                bls.s   SKMHZ2BG_BindCustomLayoutCopy
                btst    #1,(Player_1+status).w
                bne.s   SKMHZ2BG_UpdateChaseWhileWaiting

SKMHZ2BG_BindCustomLayoutCopy:
                movem.l d7-a0/a2-a3,-(sp)
                lea     (MHZ_Custom_Layout).l,a1
                lea     (Level_layout_header).w,a2
                move.w  #$200-1,d0

; Copy $1000 layout bytes before queueing the custom chunks, blocks and art
SKMHZ2BG_CopyAndQueueCustomLayout:
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                dbf     d0,SKMHZ2BG_CopyAndQueueCustomLayout
                lea     (MHZ_128x128_Custom_Kos).l,a1
                lea     (Chunk_table+$2280).l,a2
                jsr     (Queue_Kos).l
                lea     (MHZ_16x16_Custom_Kos).l,a1
                lea     (Block_table+$B28).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_MHZ_Custom).l,a1
                move.w  #tiles_to_bytes($222),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3
                addq.w  #8,(Events_routine_bg).w
                bra.s   SKMHZ2BG_TryBeginShipForeground
; ---------------------------------------------------------------------------

SKMHZ2BG_UpdateChaseWhileWaiting:
                jsr     BuildMhz2ChaseBackgroundCoordinates(pc)

SKMHZ2BG_DrawChaseRow:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

SKMHZ2BG_UpdateReverseRedraw:
                jsr     MHZ_Deform(pc)

SKMHZ2BG_RedrawOrdinaryBottomUp:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                bpl.w   SKMHZ2BG_DrawOrdinaryRow
                clr.w   (Events_routine_bg).w
                bra.w   SKMHZ2BG_DrawOrdinaryRow
; ---------------------------------------------------------------------------

SKMHZ2BG_TryBeginShipForeground:
                tst.b   (Events_bg+$00).w
                bne.s   SKMHZ2BG_RedrawShipForeground
                cmpi.w  #$3F00,(Camera_X_pos).w
                blo.w   SKMHZ2BG_DrawChaseAndComposeScroll
                addq.w  #4,(Events_routine_fg).w
                clr.l   (HScroll_table).w
                move.w  (Camera_X_pos_copy).w,d0
                move.w  d0,(HScroll_table+$004).w
                andi.w  #$FFF0,d0
                move.w  d0,(HScroll_table+$006).w
                move.w  #$1A0,(Draw_delayed_position).w
                move.w  #2,(Draw_delayed_rowcount).w
                st      (Events_bg+$00).w
                lea     SKMHZ2BG_ChasePhaseScripts(pc),a1
                cmpi.w  #3,(Player_mode).w
                bne.s   SKMHZ2BG_SeedChasePhaseAndCamera
                lea     $10(a1),a1

SKMHZ2BG_SeedChasePhaseAndCamera:
                move.b  (a1),(Events_bg+$07).w
                st      (Scroll_lock).w
                move.w  #$C,(Special_events_routine).w
                movem.l d7-a0/a2-a3,-(sp)
                lea     (ArtKosM_MHZEndBossPillar).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZEndBossPillar),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3

SKMHZ2BG_RedrawShipForeground:
                move.w  #$4000,d1
                move.w  #$180,d2
                lea     (Level_layout_main).w,a3
                move.w  #VRAM_Plane_A_Name_Table,d7
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                addq.w  #2,a3
                move.w  #VRAM_Plane_B_Name_Table,d7
                tst.w   (Draw_delayed_rowcount).w
                bpl.w   SKMHZ2BG_DrawChaseAndComposeScroll
                move.w  #$80,(Draw_delayed_position).w
                move.w  #2,(Draw_delayed_rowcount).w
                st      (Events_bg+$01).w
                addq.w  #4,(Events_routine_bg).w

SKMHZ2BG_RedrawBossBGAndAllocActors:
                move.w  #$200,d1
                move.w  #$80,d2
                jsr     Draw_PlaneVertTopDown(pc)
                bpl.w   SKMHZ2BG_DrawChaseAndComposeScroll
                lea     (HScroll_table+$008).w,a5
                clr.l   (a5)
                clr.l   4(a5)
                jsr     (AllocateObject).l
                bne.s   SKMHZ2BG_AdvanceAfterBossRedraw
                move.l  #SKMHZ2BG_InitFixedPillar,(a1)
                jsr     (CreateNewSprite4).l
                bne.s   SKMHZ2BG_AdvanceAfterBossRedraw
                move.l  #SKMHZ2BG_InitProjectedPillar,(a1)
                move.w  a1,(a5)+
                moveq   #2,d1

; Keep already allocated actors if a later allocation fails
SKMHZ2BG_AllocSpikePairsByTier:
                jsr     (CreateNewSprite4).l
                bne.s   SKMHZ2BG_AdvanceAfterBossRedraw
                move.l  #SKMHZ2BG_InitTieredSpike,(a1)
                move.w  d1,$2E(a1)
                move.w  a1,(a5)+
                jsr     (CreateNewSprite4).l
                bne.s   SKMHZ2BG_AdvanceAfterBossRedraw
                move.l  #SKMHZ2BG_InitTieredSpike,(a1)
                move.w  d1,$2E(a1)
                st      $30(a1)
                move.w  a1,(a5)+
                dbf     d1,SKMHZ2BG_AllocSpikePairsByTier

SKMHZ2BG_AdvanceAfterBossRedraw:
                addq.w  #4,(Events_routine_bg).w

SKMHZ2BG_WaitForForegroundFinish:
                tst.w   (Events_fg_5).w
                bpl.s   SKMHZ2BG_DrawChaseAndComposeScroll
                move.w  #$180,(Draw_delayed_position).w
                move.w  #2,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w

SKMHZ2BG_RestoreUpperBackground:
                moveq   #0,d1
                move.w  #$180,d2
                jsr     Draw_PlaneVertTopDown(pc)
                bpl.s   SKMHZ2BG_DrawChaseAndComposeScroll
                clr.b   (Events_bg+$01).w
                move.w  #$280,(Draw_delayed_position).w
                move.w  #2,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w

SKMHZ2BG_RestoreForegroundRows:
                move.w  #$4080,d1
                move.w  #$280,d2
                lea     (Level_layout_main).w,a3
                move.w  #VRAM_Plane_A_Name_Table,d7
                jsr     Draw_PlaneVertTopDown(pc)
                addq.w  #2,a3
                move.w  #VRAM_Plane_B_Name_Table,d7
                tst.w   (Draw_delayed_rowcount).w
                bpl.s   SKMHZ2BG_DrawChaseAndComposeScroll
                clr.b   (Events_bg+$00).w
                clr.w   (Events_routine_fg).w
                addq.w  #4,(Events_routine_bg).w

SKMHZ2BG_DrawChaseAndComposeScroll:
                jsr     BuildMhz2ChaseBackgroundCoordinates(pc)
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                jsr     ComposeMhz2ShipAndBossPerspectiveScroll(pc)
                cmpi.w  #$10,(Events_routine_fg).w
                bne.s   SKMHZ2BG_ApplyScreenShake
                move.w  (SceneAuxiliaryYOrVerticalMotion).w,(V_scroll_value).w
                move.w  (Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
                addq.w  #4,sp

SKMHZ2BG_ApplyScreenShake:
                jmp     ShakeScreen_Setup(pc)

; =============== S U B R O U T I N E =======================================

BuildMhz2ChaseBackgroundCoordinates:
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$280,d0
                swap    d0
                clr.w   d0
                asr.l   #3,d0
                move.l  d0,d1
                asr.l   #2,d1
                add.l   d1,d0
                swap    d0
                addi.w  #$180,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Events_fg_1).w,d0
                move.w  (Screen_shake_offset).w,d2
                sub.w   d2,d0
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d1
                asr.l   #2,d1
                sub.l   d1,d0
                asr.l   #1,d1
                swap    d0
                add.w   d2,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,(Events_bg+$10).w
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,(Events_bg+$12).w
                rts
; End of function BuildMhz2ChaseBackgroundCoordinates

; =============== S U B R O U T I N E =======================================

ComposeMhz2ShipAndBossPerspectiveScroll:
                jsr     PlainDeformation(pc)
                cmpi.w  #$10,(Events_routine_fg).w
                bne.s   SKMHZ2BG_TryFillBossForegroundScroll
                lea     (H_scroll_buffer).w,a1
                move.w  (HScroll_table).w,d0
                neg.w   d0
                moveq   #$40-1,d1

SKMHZ2BG_FillShipForegroundScroll:
                move.w  d0,(a1)
                addq.w  #4,a1
                move.w  d0,(a1)
                addq.w  #4,a1
                dbf     d1,SKMHZ2BG_FillShipForegroundScroll
                bra.w   SKMHZ2BG_PerspectiveReturn
; ---------------------------------------------------------------------------

SKMHZ2BG_TryFillBossForegroundScroll:
                tst.b   (Events_bg+$00).w
                beq.s   SKMHZ2BG_CheckPerspectiveDistance
                lea     (H_scroll_buffer).w,a1
                move.w  (Camera_X_pos_BG_copy).w,d0
                neg.w   d0
                moveq   #$18-1,d1

SKMHZ2BG_FillBossForegroundScroll:
                move.w  d0,(a1)
                addq.w  #4,a1
                move.w  d0,(a1)
                addq.w  #4,a1
                dbf     d1,SKMHZ2BG_FillBossForegroundScroll

SKMHZ2BG_CheckPerspectiveDistance:
                tst.b   (Events_bg+$01).w
                beq.w   SKMHZ2BG_PerspectiveReturn
                move.w  (Camera_X_pos).w,d0
                subi.w  #$4180,d0
                cmpi.w  #-$140,d0
                blt.w   SKMHZ2BG_PrepareClearPerspective
                move.w  d0,d1
                muls.w  #$5600,d1
                add.l   d1,d1
                swap    d1
                sub.w   d1,d0
                subi.w  #$18,d0
                swap    d0
                clr.w   d0
                tst.l   d0
                smi     d3
                bpl.s   SKMHZ2BG_DividePerspectiveStep
                neg.l   d0

; Divide the fixed-point magnitude by $30 in two unsigned stages, then restore the sign
SKMHZ2BG_DividePerspectiveStep:
                moveq   #0,d2
                swap    d0
                move.w  d0,d2
                divu.w  #$30,d2
                move.w  d2,d1
                swap    d0
                move.w  d0,d2
                divu.w  #$30,d2
                swap    d1
                move.w  d2,d1
                tst.b   d3
                beq.s   SKMHZ2BG_SeedPerspectiveScroll
                neg.l   d1

SKMHZ2BG_SeedPerspectiveScroll:
                lea     (H_scroll_buffer+2).w,a1
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$80,d0
                neg.w   d0
                swap    d0
                clr.w   d0
                moveq   #$30-1,d2

SKMHZ2BG_WritePerspectiveScroll:
                swap    d0
                move.w  d0,(a1)
                swap    d0
                add.l   d1,d0
                addq.w  #4,a1
                dbf     d2,SKMHZ2BG_WritePerspectiveScroll
                lea     (HScroll_table+$008).w,a1
                lea     (H_scroll_buffer+$BE).w,a5
                moveq   #$1C,d0
                moveq   #7-1,d1

; A zero handle ends projection. Alternate scroll samples for the populated spike pairs
SKMHZ2BG_ProjectBossActorX:
                move.w  (a1)+,d2
                beq.s   SKMHZ2BG_PerspectiveReturn
                movea.w d2,a6
                move.w  (a5),d2
                subi.w  #$48,d2
                andi.w  #$1FF,d2
                add.w   (Camera_X_pos).w,d2
                move.w  d2,$10(a6)
                btst    #0,d1
                bne.s   SKMHZ2BG_NextBossActor
                suba.w  d0,a5
                addi.w  #$C,d0

SKMHZ2BG_NextBossActor:
                dbf     d1,SKMHZ2BG_ProjectBossActorX
                bra.s   SKMHZ2BG_PerspectiveReturn
; ---------------------------------------------------------------------------

SKMHZ2BG_PrepareClearPerspective:
                lea     (H_scroll_buffer+2).w,a1
                moveq   #$30-1,d0

SKMHZ2BG_ClearPerspectiveScroll:
                clr.w   (a1)
                addq.w  #4,a1
                dbf     d0,SKMHZ2BG_ClearPerspectiveScroll

SKMHZ2BG_PerspectiveReturn:
                rts
; End of function ComposeMhz2ShipAndBossPerspectiveScroll

; ---------------------------------------------------------------------------

SKMHZ2BG_StepChaseCamera:
                clr.w   (Level_repeat_offset).w
                move.w  (Camera_X_pos).w,d0
                addq.w  #4,d0
                cmpi.w  #3,(Player_mode).w
                bne.s   SKMHZ2BG_ChooseChaseWrapOrStop
                addq.w  #1,d0

SKMHZ2BG_ChooseChaseWrapOrStop:
                cmpi.w  #$4280,d0
                blo.s   SKMHZ2BG_SetChaseCameraMaxX
                tst.w   (Events_fg_5).w
                beq.s   SKMHZ2BG_WrapPlayersAndAdvancePhase
                st      (Events_fg_5).w
                cmpi.w  #$4420,d0
                blo.s   SKMHZ2BG_SetChaseCameraMaxX
                move.w  #$4420,d0
                move.w  #$45A0,(Camera_max_X_pos).w
                st      (Scroll_lock).w
                clr.w   (Special_events_routine).w
                bra.s   SKMHZ2BG_CommitCameraAndClampPlayers
; ---------------------------------------------------------------------------

SKMHZ2BG_WrapPlayersAndAdvancePhase:
                move.w  #$200,d1
                move.w  d1,(Level_repeat_offset).w
                sub.w   d1,(Player_1+x_pos).w
                sub.w   d1,(Player_2+x_pos).w
                sub.w   d1,d0
                move.w  d0,d1
                andi.w  #$FFF0,d1
                subi.w  #$10,d1
                move.w  d1,(Camera_X_pos_rounded).w
                addq.w  #1,(Events_bg+$08).w
                move.w  (Events_bg+$08).w,d1
                andi.w  #$F,d1
                lea     SKMHZ2BG_ChasePhaseScripts(pc),a1
                cmpi.w  #3,(Player_mode).w
                bne.s   SKMHZ2BG_StorePhaseAndConsumeShipLatch
                lea     $10(a1),a1

SKMHZ2BG_StorePhaseAndConsumeShipLatch:
                move.b  (a1,d1.w),(Events_bg+$07).w
                tst.b   (SceneOutcomeOrActorReadySignal).w
                beq.s   SKMHZ2BG_SetChaseCameraMaxX
                st      (Events_bg+$0A).w
                clr.b   (SceneOutcomeOrActorReadySignal).w

SKMHZ2BG_SetChaseCameraMaxX:
                move.w  d0,(Camera_max_X_pos).w

SKMHZ2BG_CommitCameraAndClampPlayers:
                move.w  d0,(Camera_X_pos).w
                move.w  d0,(Camera_X_pos_copy).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,d1
                lea     (Player_1).w,a1
                bsr.s   ClampPlayerToMhz2ChaseWindow
                move.w  d1,d0
                lea     (Player_2).w,a1

; =============== S U B R O U T I N E =======================================

ClampPlayerToMhz2ChaseWindow:
                cmpi.b  #5,anim(a1)
                bne.s   SKMHZ2BG_ClampLeftAndSetGroundSpeed
                clr.b   anim(a1)

SKMHZ2BG_ClampLeftAndSetGroundSpeed:
                addi.w  #$18,d0
                cmp.w   x_pos(a1),d0
                bls.s   SKMHZ2BG_ClampRight
                move.w  d0,x_pos(a1)
                move.w  #$400,ground_vel(a1)
                cmpi.w  #3,(Player_mode).w
                bne.s   SKMHZ2BG_PlayerClampReturn
                move.w  #$500,ground_vel(a1)
                bra.s   SKMHZ2BG_PlayerClampReturn
; ---------------------------------------------------------------------------

SKMHZ2BG_ClampRight:
                addi.w  #$A8,d0
                cmp.w   x_pos(a1),d0
                bhi.s   SKMHZ2BG_PlayerClampReturn
                move.w  d0,x_pos(a1)

SKMHZ2BG_PlayerClampReturn:
                rts
; End of function ClampPlayerToMhz2ChaseWindow

; ---------------------------------------------------------------------------

SKMHZ2BG_InitFixedPillar:
                move.l  #SKMHZ2BG_CheckPillarLifetime,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #$18,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_MHZEndBossPillar,3,1),art_tile(a0)
                move.l  #Map_MHZEndBossMisc,mappings(a0)
                move.w  #$4238,x_pos(a0)
                move.w  #$2F0,y_pos(a0)
                bra.s   SKMHZ2BG_CheckPillarLifetime
; ---------------------------------------------------------------------------

SKMHZ2BG_InitProjectedPillar:
                move.l  #SKMHZ2BG_CheckPillarLifetime,(a0)
                move.b  #$44,render_flags(a0)
                move.b  #$80,height_pixels(a0)
                move.b  #$C,width_pixels(a0)
                move.w  #$380,priority(a0)
                move.w  #make_art_tile(ArtTile_MHZEndBossPillar,3,0),art_tile(a0)
                move.l  #Map_MHZEndBossMisc,mappings(a0)
                move.w  #$300,y_pos(a0)
                move.b  #1,mapping_frame(a0)

SKMHZ2BG_CheckPillarLifetime:
                tst.b   (Events_bg+$01).w
                bne.s   SKMHZ2BG_DrawActivePillar
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKMHZ2BG_DrawActivePillar:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKMHZ2BG_InitTieredSpike:
                move.l  #SKMHZ2BG_CheckSpikeLifetime,(a0)
                move.b  #$44,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #make_art_tile(ArtTile_MHZEndBossSpikes,1,0),art_tile(a0)
                move.l  #Map_MHZEndBossMisc,mappings(a0)
                move.b  #$8B,collision_flags(a0)
                move.w  #$80,d0
                moveq   #4,d1
                move.w  $2E(a0),d2
                subq.w  #1,d2
                bcs.s   SKMHZ2BG_ApplySpikePriorityAndFrame

SKMHZ2BG_StepSpikePriorityAndFrame:
                addi.w  #$80,d0
                subq.w  #1,d1
                dbf     d2,SKMHZ2BG_StepSpikePriorityAndFrame

SKMHZ2BG_ApplySpikePriorityAndFrame:
                move.w  d0,priority(a0)
                move.b  d1,mapping_frame(a0)

SKMHZ2BG_CheckSpikeLifetime:
                tst.w   (Events_bg+$0A).w
                bne.s   SKMHZ2BG_DeleteRetiredSpike
                tst.b   (Events_bg+$01).w
                bne.s   SKMHZ2BG_GateSecondSpikeOnPhaseFour

SKMHZ2BG_DeleteRetiredSpike:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKMHZ2BG_GateSecondSpikeOnPhaseFour:
                move.w  (Events_bg+$06).w,d0
                tst.w   $30(a0)
                beq.s   SKMHZ2BG_DrawSpikeAndTryAddCollision
                cmpi.w  #4,d0
                bne.s   SKMHZ2BG_SpikeUpdateReturn
                moveq   #0,d0

; Select Y by phase and tier. Only the middle tier adds collision
SKMHZ2BG_DrawSpikeAndTryAddCollision:
                lsl.w   #2,d0
                add.w   $2E(a0),d0
                add.w   d0,d0
                lea     SKMHZ2BG_PhaseByTierSpikeYWordRows(pc),a1
                move.w  (a1,d0.w),y_pos(a0)
                jsr     (Draw_Sprite).l
                cmpi.w  #1,$2E(a0)
                bne.s   SKMHZ2BG_SpikeUpdateReturn
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

SKMHZ2BG_SpikeUpdateReturn:
                rts
; ---------------------------------------------------------------------------

SKMHZ2BG_InitShipPropeller:
                move.l  #SKMHZ2BG_AnimateShipPropellerThenDraw,(a0)
                move.w  #$380,priority(a0)
                move.w  #make_art_tile(ArtTile_MHZShipPropeller,1,1),art_tile(a0)
                move.l  #Map_MHZEndBossMisc,mappings(a0)

SKMHZ2BG_AnimateShipPropellerThenDraw:
                lea     Ani_MHZEndPropellers(pc),a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKMHZ2BG_AccelerateShipAndSelectY:
                addq.b  #1,$3C(a0)
                addi.l  #$C0,$38(a0)
                move.l  $38(a0),d0
                sub.l   d0,(SceneAuxiliaryXOrCompetitionTime).w
                tst.w   (Events_fg_4).w
                beq.s   SKMHZ2BG_CalcShipVerticalSwing
                cmpi.l  #$2800,$2E(a0)
                bne.s   SKMHZ2BG_CalcShipVerticalSwing
                move.w  $32(a0),d0
                move.b  $3C(a0),d1
                andi.w  #3,d1
                bne.s   SKMHZ2BG_StoreShipYAndCheckThreshold
                addq.w  #1,$32(a0)
                bra.s   SKMHZ2BG_StoreShipYAndCheckThreshold
; ---------------------------------------------------------------------------

SKMHZ2BG_CalcShipVerticalSwing:
                move.l  #$2800,d0
                move.l  #$C0,d1
                jsr     (Gradual_SwingOffset).l

SKMHZ2BG_StoreShipYAndCheckThreshold:
                add.w   (SceneRowAnchorOrCompetitionWinCounts).w,d0
                addq.w  #5,d0
                move.w  d0,(SceneAuxiliaryYOrVerticalMotion).w
                tst.b   (SceneOutcomeOrActorReadySignal).w
                bne.s   SKMHZ2BG_TickShipSound
                cmpi.w  #-$3E6,(SceneAuxiliaryXOrCompetitionTime).w
                bgt.s   SKMHZ2BG_TickShipSound
                st      (SceneOutcomeOrActorReadySignal).w
                st      (Events_fg_4).w
                st      (Scroll_lock).w

; Play the large ship sound on frames whose low nibble is 1
SKMHZ2BG_TickShipSound:
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   SKMHZ2BG_ShipUpdateReturn
                moveq   #signextendB(sfx_LargeShip),d0
                jsr     (Play_SFX).l

SKMHZ2BG_ShipUpdateReturn:
                rts
; ---------------------------------------------------------------------------
SKMHZ2BG_PhaseByTierSpikeYWordRows:
                dc.w    $336
                dc.w    $334
                dc.w    $333
                dc.w    0
                dc.w    $320
                dc.w    $320
                dc.w    $320
                dc.w    0
                dc.w    $2F6
                dc.w    $2F8
                dc.w    $2FA
                dc.w    0
                dc.w    $2C9
                dc.w    $2CF
                dc.w    $2D4
                dc.w    0
                dc.w    $2C9
                dc.w    $2CF
                dc.w    $2D4
; The normal and Knuckles scripts occupy 16 bytes each
SKMHZ2BG_ChasePhaseScripts:
                dc.w    $102
                dc.w    2
                dc.w    $102
                dc.w    $100
                dc.w    $200
                dc.w    $102
                dc.w    $102
                dc.w    $200
                dc.w    $102
                dc.w    3
                dc.w    $104
                dc.w    $200
                dc.w    $401
                dc.w    $304
                dc.w    $200
                dc.w    $402
Map_MHZEndBossMisc:
                include "src/objects/shared/zones/mhz/boss/mappings/misc.s"
Ani_MHZEndPropellers:
                include "src/objects/shared/zones/mhz/animations/end_propellers.s"
