; Owner: game/level/zones/dez/sk
; Responsibility: Death Egg act-three screen and background events, deformation and coordinated scene actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

DEZ3_ScreenInit:
                clr.w   (Events_bg+$10).w
                st      (Events_bg+$12).w
                jsr     QueueChangedDez3LaserArtWindow(pc)
                move.w  (a3),d0
                move.w  d0,$10(a3)
                move.w  d0,$12(a3)
                move.w  d0,$7C(a3)
                move.w  d0,$7E(a3)
                lea     (Level_layout_main+$02).w,a3
                move.w  #VRAM_Plane_B_Name_Table,d7
                lea     (Level_layout_header).w,a1
                move.w  (a1),d0
                mulu.w  4(a1),d0
                move.w  2(a1),d1
                mulu.w  6(a1),d1
                add.w   d1,d0
                addi.w  #$88,d0
                adda.w  d0,a1
                move.w  #$1000-1,d1
                sub.w   d0,d1

SKDEZ3Events_ClearLayoutAndSpawnActors:
                clr.b   (a1)+
                dbf     d1,SKDEZ3Events_ClearLayoutAndSpawnActors
                jsr     (AllocateObject).l
                bne.s   SKDEZ3Events_InitBossPlaneAndRefresh
                move.l  #DEZ3FloorSpan_Initialize,(a1)
                jsr     (CreateNewSprite4).l
                bne.s   SKDEZ3Events_InitBossPlaneAndRefresh
                move.l  #DEZ3InitialLeftFloor_Initialize,(a1)
                jsr     (CreateNewSprite4).l
                bne.s   SKDEZ3Events_InitBossPlaneAndRefresh
                move.l  #Obj_DEZ3_Boss,(a1)
                move.w  #$3C0,d0
                move.w  #$F8,d1
                move.w  d0,$10(a1)
                move.w  d1,$14(a1)
                move.w  d0,(Events_bg+$02).w
                move.w  d1,(Events_bg+$04).w

; Refresh the arena even if allocation stopped after only a prefix of its initial actors
SKDEZ3Events_InitBossPlaneAndRefresh:
                move.w  #$6C0,(Events_bg+$00).w
                st      (Scroll_lock).w
                move.w  #$80,d0
                move.w  d0,(Camera_X_pos).w
                move.w  d0,(Camera_X_pos_copy).w
                move.w  d0,(Events_bg+$16).w
                jsr     PrepareDez3EnvironmentPlaneScroll(pc)
                jsr     (Reset_TileOffsetPositionActual).l
                lea     (HScroll_table).w,a1
                clr.l   (a1)+
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)+
                clr.w   (a1)
                lea     DEZ3_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     (Refresh_PlaneTileDeform).l
; ---------------------------------------------------------------------------

DEZ3_ScreenEvent:
                lea     (Level_layout_main+$02).w,a3
                move.w  #VRAM_Plane_B_Name_Table,d7
                move.w  (Events_routine_fg).w,d0
                jmp     DEZ3_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

DEZ3_ScreenEvent_Index:
                bra.w   SKDEZ3Events_TryRestoreSavedRings
; ---------------------------------------------------------------------------
                bra.w   SKDEZ3Events_DrawEnvironmentAndTryRepair
; ---------------------------------------------------------------------------

SKDEZ3Events_TryRestoreSavedRings:
                move.w  (Act3_ring_count).w,d0
                beq.s   SKDEZ3Events_TryRestoreSavedTimer
                clr.w   (Act3_ring_count).w
                move.w  d0,(Ring_count).w
                move.b  #1,(Update_HUD_ring_count).w

SKDEZ3Events_TryRestoreSavedTimer:
                move.l  (Act3_timer).w,d0
                beq.s   SKDEZ3Events_AdvanceForegroundState
                clr.l   (Act3_timer).w
                move.l  d0,(Timer).w
                st      (Update_HUD_timer).w

SKDEZ3Events_AdvanceForegroundState:
                addq.w  #4,(Events_routine_fg).w

SKDEZ3Events_DrawEnvironmentAndTryRepair:
                jsr     PrepareDez3EnvironmentPlaneScroll(pc)
                lea     DEZ3_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a6
                moveq   #2,d5
                move.w  (Camera_Y_pos_rounded).w,d6
                jsr     (Draw_BGNoVert).l
                move.w  (Events_bg+$06).w,d1
                beq.s   SKDEZ3Events_EnvironmentDrawReturn
                clr.w   (Events_bg+$06).w
                move.w  #$1E0,d0
                and.w   d0,d1
                moveq   #2,d6
                moveq   #2-1,d2

SKDEZ3Events_RedrawEnvironmentRows:
                movem.w d0-d2/d6,-(sp)
                jsr     (Setup_TileRowDraw).l
                movem.w (sp)+,d0-d2/d6
                addi.w  #$10,d0
                dbf     d2,SKDEZ3Events_RedrawEnvironmentRows

SKDEZ3Events_EnvironmentDrawReturn:
                rts

; =============== S U B R O U T I N E =======================================

PrepareDez3EnvironmentPlaneScroll:
                moveq   #$20,d0
                add.w   (Screen_shake_offset).w,d0
                move.w  d0,(Camera_Y_pos_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                move.w  d0,(HScroll_table+$00A).w
                andi.w  #$1FF,d0
                move.w  d0,(HScroll_table+$004).w
                rts
; End of function PrepareDez3EnvironmentPlaneScroll

; ---------------------------------------------------------------------------
DEZ3_BGDrawArray:
                dc.w    $E0, $7FFF
; ---------------------------------------------------------------------------

DEZ3_BackgroundInit:
                lea     (Level_layout_main).w,a3
                move.w  #VRAM_Plane_A_Name_Table,d7
                jsr     ComputeDez3BossPlaneScroll(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                jsr     (Refresh_PlaneFull).l
                bra.w   SKDEZ3Events_BindSwappedPlaneScroll
; ---------------------------------------------------------------------------

DEZ3_BackgroundEvent:
                lea     (Level_layout_main).w,a3
                move.w  #VRAM_Plane_A_Name_Table,d7
                jsr     ComputeDez3BossPlaneScroll(pc)
                move.w  (Events_routine_bg).w,d0
                jmp     DEZ3_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

DEZ3_BackgroundEvent_Index:
                bra.w   SKDEZ3Events_TryRefreshBossPlane
; ---------------------------------------------------------------------------
                bra.w   SKDEZ3Events_TrySpawnRumbleActor
; ---------------------------------------------------------------------------
                bra.w   SKDEZ3Events_TryBeginFirstPlaneRedraw
; ---------------------------------------------------------------------------
                bra.w   SKDEZ3Events_StepFirstPlaneRedraw
; ---------------------------------------------------------------------------
                bra.w   SKDEZ3Events_TryBeginSecondPlaneRedraw
; ---------------------------------------------------------------------------
                bra.w   SKDEZ3Events_StepSecondPlaneRedraw
; ---------------------------------------------------------------------------
                bra.w   SKDEZ3Events_SelectFinalRedrawOrAnimate
; ---------------------------------------------------------------------------
                bra.w   SKDEZ3Events_StepFinalPlaneRedraw
; ---------------------------------------------------------------------------
                bra.w   SKDEZ3Events_DrawBossPlane
; ---------------------------------------------------------------------------

SKDEZ3Events_TryRefreshBossPlane:
                move.b  #1,(Update_HUD_life_count).w
                tst.w   (Events_fg_5).w
                beq.w   SKDEZ3Events_DrawBossPlane
                clr.w   (Events_fg_5).w
                movea.w 8(a3),a1
                move.b  #$1A,$D(a1)
                move.w  (Camera_Y_pos_BG_copy).w,d0
                move.w  (Camera_X_pos_BG_copy).w,d1
                moveq   #$15,d6
                jsr     (Refresh_PlaneDirect).l
                addq.w  #4,(Events_routine_bg).w
                bra.w   SKDEZ3Events_BindSwappedPlaneScroll
; ---------------------------------------------------------------------------

SKDEZ3Events_TrySpawnRumbleActor:
                tst.w   (Screen_shake_flag).w
                beq.w   SKDEZ3Events_DrawBossPlane
                jsr     (AllocateObject).l
                bne.s   SKDEZ3Events_DrawAfterRumbleAttempt
                move.l  #SKDEZ3Events_EmitTimedFloorColumns,(a1)
                move.w  #$13,$2E(a1)
                move.w  #$2D0,$30(a1)
                move.w  #$2C0,(Events_bg+$16).w
                addq.w  #4,(Events_routine_bg).w

SKDEZ3Events_DrawAfterRumbleAttempt:
                bra.w   SKDEZ3Events_DrawBossPlane
; ---------------------------------------------------------------------------

SKDEZ3Events_TryBeginFirstPlaneRedraw:
                cmpi.w  #$6C0,(Events_bg+$00).w
                beq.w   SKDEZ3Events_DrawBossPlane
                jsr     (Reset_TileOffsetPositionEff).l
                move.w  #$F0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                move.w  (BackgroundEffectPhaseOrSavedX).w,(Events_bg+$0C).w
                addq.w  #4,(Events_routine_bg).w

SKDEZ3Events_StepFirstPlaneRedraw:
                moveq   #0,d1
                moveq   #0,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.s   SKDEZ3Events_TryBeginSecondPlaneRedraw
                clr.w   (Events_bg+$0C).w
                addq.w  #4,(Events_routine_bg).w

SKDEZ3Events_TryBeginSecondPlaneRedraw:
                cmpi.w  #$2C0,(Events_bg+$00).w
                beq.w   SKDEZ3Events_DrawBossPlane
                jsr     (Reset_TileOffsetPositionEff).l
                move.w  #$F0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                move.w  (BackgroundEffectPhaseOrSavedX).w,(Events_bg+$0C).w
                jsr     (AllocateObject).l
                bne.s   SKDEZ3Events_AdvanceAfterFloorSpawn
                move.l  #SKDEZ3Events_CheckAct3EmitterLifetime,(a1)
                move.w  (Camera_X_pos_copy).w,d0
                andi.w  #$FFE0,d0
                move.w  d0,(Events_bg+$16).w
                subi.w  #$10,d0
                move.w  d0,$30(a1)

SKDEZ3Events_AdvanceAfterFloorSpawn:
                addq.w  #4,(Events_routine_bg).w

SKDEZ3Events_StepSecondPlaneRedraw:
                moveq   #0,d1
                moveq   #0,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.s   SKDEZ3Events_SelectFinalRedrawOrAnimate
                clr.w   (Events_bg+$0C).w
                addq.w  #4,(Events_routine_bg).w

SKDEZ3Events_SelectFinalRedrawOrAnimate:
                tst.w   (Events_bg+$00).w
                beq.w   SKDEZ3Events_BeginFinalPlaneRedraw
                jsr     QueueChangedDez3LaserArtWindow(pc)
                tst.w   (Events_fg_5).w
                beq.w   SKDEZ3Events_DrawBossPlane
                clr.w   (Events_fg_5).w
                move.w  (Events_bg+$0A).w,d0
                jmp     SKDEZ3Events_ChunkCycleBranches(pc,d0.w)
; ---------------------------------------------------------------------------

SKDEZ3Events_ChunkCycleBranches:
                bra.s   SKDEZ3Events_SelectChunkPair0603
; ---------------------------------------------------------------------------
                bra.s   SKDEZ3Events_SelectChunkPair0903
; ---------------------------------------------------------------------------
                bra.s   SKDEZ3Events_SelectChunkPair0603
; ---------------------------------------------------------------------------
                bra.s   SKDEZ3Events_SelectChunkPair0807AndWrap
; ---------------------------------------------------------------------------

SKDEZ3Events_SelectChunkPair0603:
                move.w  #$603,d0
                bra.s   SKDEZ3Events_ApplyNextChunkPair
; ---------------------------------------------------------------------------

SKDEZ3Events_SelectChunkPair0903:
                move.w  #$903,d0
                bra.s   SKDEZ3Events_ApplyNextChunkPair
; ---------------------------------------------------------------------------

SKDEZ3Events_SelectChunkPair0807AndWrap:
                move.w  #$807,d0
                move.w  #-2,(Events_bg+$0A).w

SKDEZ3Events_ApplyNextChunkPair:
                addq.w  #2,(Events_bg+$0A).w
                movea.w 8(a3),a1
                move.b  d0,$E(a1)
                lsr.w   #8,d0
                movea.w $C(a3),a1
                move.b  d0,$E(a1)
                move.w  #$700,d1
                move.w  #$160,d0
                moveq   #8,d6
                moveq   #9,d2
                move.w  (Camera_Y_pos_BG_copy).w,d3
                andi.w  #$FFF0,d3
                addi.w  #$E0,d3

SKDEZ3Events_RedrawChunkCycleRows:
                movem.w d0-d3/d6,-(sp)
                jsr     (Setup_TileRowDraw).l
                movem.w (sp)+,d0-d3/d6
                addi.w  #$10,d0
                cmp.w   d3,d0
                bhi.s   SKDEZ3Events_DrawAfterChunkCycle
                dbf     d2,SKDEZ3Events_RedrawChunkCycleRows

SKDEZ3Events_DrawAfterChunkCycle:
                bra.s   SKDEZ3Events_DrawBossPlane
; ---------------------------------------------------------------------------

SKDEZ3Events_BeginFinalPlaneRedraw:
                jsr     (Reset_TileOffsetPositionEff).l
                move.w  #$F0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                move.w  (BackgroundEffectPhaseOrSavedX).w,(Events_bg+$0C).w
                addq.w  #4,(Events_routine_bg).w

SKDEZ3Events_StepFinalPlaneRedraw:
                moveq   #0,d1
                moveq   #0,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.s   SKDEZ3Events_DrawBossPlane
                clr.w   (Events_bg+$0C).w
                addq.w  #4,(Events_routine_bg).w

SKDEZ3Events_DrawBossPlane:
                jsr     (DrawBGAsYouMove).l

SKDEZ3Events_BindSwappedPlaneScroll:
                lea     DEZ3_BGDrawArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                lea     (H_scroll_buffer).w,a1
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Events_bg+$0C).w,d3
                bne.s   SKDEZ3Events_ApplySwappedPlaneScroll
                move.w  (Camera_X_pos_BG_copy).w,d3

; Swap the vertical scroll words between planes and skip the caller's remaining screen event
SKDEZ3Events_ApplySwappedPlaneScroll:
                move.w  #$E0-1,d1
                jsr     (ApplyDeformation2).l
                move.w  (Camera_Y_pos_BG_copy).w,(V_scroll_value).w
                move.w  (Camera_Y_pos_copy).w,(V_scroll_value_BG).w
                addq.w  #4,sp
                jmp     (ShakeScreen_Setup).l

; =============== S U B R O U T I N E =======================================

ComputeDez3BossPlaneScroll:
                move.w  (Camera_X_pos_BG_copy).w,(BackgroundEffectPhaseOrSavedX).w
                tst.w   (Events_bg+$00).w
                bne.s   SKDEZ3Events_CalcBossPlaneX
                moveq   #0,d0
                bra.s   SKDEZ3Events_ApplyBossPlaneXY
; ---------------------------------------------------------------------------

SKDEZ3Events_CalcBossPlaneX:
                move.w  (Camera_X_pos_copy).w,d0
                sub.w   (Events_bg+$02).w,d0
                add.w   (Events_bg+$00).w,d0

SKDEZ3Events_ApplyBossPlaneXY:
                move.w  d0,(Camera_X_pos_BG_copy).w
                move.w  (Camera_Y_pos_copy).w,d0
                sub.w   (Events_bg+$04).w,d0
                addi.w  #$180,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                rts
; End of function ComputeDez3BossPlaneScroll

; =============== S U B R O U T I N E =======================================

QueueChangedDez3LaserArtWindow:
                moveq   #0,d1
                move.w  (Events_bg+$10).w,d1
                cmp.w   (Events_bg+$12).w,d1
                beq.s   SKDEZ3Events_LaserDmaReturn
                move.w  d1,(Events_bg+$12).w
                addq.w  #2,d1
                lsl.w   #2,d1
                addi.l  #ArtUnc_DEZFBLaser,d1
                move.w  #tiles_to_bytes($208),d2
                move.w  #$40,d3
                jsr     (Add_To_DMA_Queue).l

SKDEZ3Events_LaserDmaReturn:
                rts
; End of function QueueChangedDez3LaserArtWindow

; ---------------------------------------------------------------------------

DEZ3FloorSpan_Initialize:
                move.l  #DEZ3FloorSpan_DeleteOutsideAct3Zone,(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$130,x_pos(a0)
                move.w  #$F0,y_pos(a0)
                bset    #7,status(a0)
                move.w  #$80,$2E(a0)

DEZ3FloorSpan_DeleteOutsideAct3Zone:
                cmpi.b  #$17,(Current_zone).w
                beq.s   SKDEZ3Events_TrySpawnCollapseColumn
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKDEZ3Events_TrySpawnCollapseColumn:
                move.w  (Events_bg+$08).w,d1
                beq.s   SKDEZ3Events_SelectCoarseFloorStep
                clr.w   (Events_bg+$08).w
                cmp.w   (Events_bg+$16).w,d1
                blo.s   SKDEZ3Events_SelectCoarseFloorStep
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   DEZ3FloorSpan_AdvanceCollapseFrontier
                move.l  #DEZ3FallingFloorBlock_Initialize,(a1)
                move.w  d1,x_pos(a1)
                move.w  $2E(a0),d2
                subi.w  #$20,d2
                cmp.w   d1,d2
                bhi.s   DEZ3FloorSpan_AdvanceCollapseFrontier
                move.w  d1,(Events_bg+$06).w

DEZ3FloorSpan_AdvanceCollapseFrontier:
                moveq   #$20,d0
                add.w   d0,(Events_bg+$16).w
                cmp.w   $2E(a0),d1
                blo.s   SKDEZ3Events_SelectCoarseFloorStep
                add.w   d0,x_pos(a0)

SKDEZ3Events_SelectCoarseFloorStep:
                moveq   #-$20,d1
                move.w  (Camera_X_pos_copy).w,d0
                andi.w  #$FFE0,d0
                move.w  $2E(a0),d2
                cmp.w   d2,d0
                beq.s   DEZ3FloorSpan_ApplySolidTopCollision
                bcs.s   DEZ3FloorSpan_ApplyOneColumnXStep
                cmp.w   (Events_bg+$16).w,d2
                blo.s   DEZ3FloorSpan_StoreCoarseCameraColumn
                neg.w   d1

DEZ3FloorSpan_ApplyOneColumnXStep:
                add.w   d1,x_pos(a0)

DEZ3FloorSpan_StoreCoarseCameraColumn:
                move.w  d0,$2E(a0)

DEZ3FloorSpan_ApplySolidTopCollision:
                move.w  #$B0,d1
                moveq   #$10,d2
                moveq   #$10,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectTop).l
; ---------------------------------------------------------------------------

DEZ3FallingFloorBlock_Initialize:
                move.l  #SKDEZ3Events_RelocateOffscreenFloorBlock,(a0)
                move.b  #$84,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$C,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile($001,2,1),art_tile(a0)
                move.l  #Map_DEZ3Blocks,mappings(a0)
                move.w  #$F0,y_pos(a0)
                move.w  x_pos(a0),d0
                andi.w  #$60,d0
                lsr.w   #5,d0
                move.b  d0,mapping_frame(a0)

SKDEZ3Events_RelocateOffscreenFloorBlock:
                tst.b   render_flags(a0)
                bmi.s   SKDEZ3Events_MoveFloorBlockAndCheckTop
                move.w  (Camera_X_pos_coarse_back).w,d0
                addi.w  #$400,d0
                move.w  d0,x_pos(a0)

SKDEZ3Events_MoveFloorBlockAndCheckTop:
                jsr     (MoveSprite2).l
                addi.w  #$1A,y_vel(a0)
                moveq   #$10,d1
                moveq   #$10,d2
                moveq   #$10,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

DEZ3InitialLeftFloor_Initialize:
                move.l  #SKDEZ3Events_CheckInitialFloorLifetime,(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$40,x_pos(a0)
                move.w  #$F0,y_pos(a0)
                bset    #7,status(a0)

SKDEZ3Events_CheckInitialFloorLifetime:
                cmpi.w  #$6C0,(Events_bg+$00).w
                beq.s   SKDEZ3Events_CheckInitialFloorSolid
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKDEZ3Events_CheckInitialFloorSolid:
                moveq   #$40,d1
                moveq   #$10,d2
                moveq   #$10,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectTop).l
; ---------------------------------------------------------------------------

SKDEZ3Events_EmitTimedFloorColumns:
                subq.w  #1,$32(a0)
                bpl.s   SKDEZ3Events_TimedColumnReturn
                move.w  #$10-1,$32(a0)
                move.w  $30(a0),(Events_bg+$08).w
                addi.w  #$20,$30(a0)
                subq.w  #1,$2E(a0)
                bne.s   SKDEZ3Events_TimedColumnReturn
                clr.w   (Screen_shake_flag).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKDEZ3Events_TimedColumnReturn:
                rts
; ---------------------------------------------------------------------------

SKDEZ3Events_CheckAct3EmitterLifetime:
                cmpi.b  #$17,(Current_zone).w
                beq.s   SKDEZ3Events_CheckCameraColumnDistance
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKDEZ3Events_CheckCameraColumnDistance:
                tst.w   (Events_bg+$00).w
                bne.s   SKDEZ3Events_CheckBossColumnDistance
                move.w  (Camera_X_pos_copy).w,d0
                addi.w  #$9C,d0
                cmp.w   $30(a0),d0
                blo.s   SKDEZ3Events_ProximityColumnReturn
                move.w  $30(a0),(Events_bg+$08).w
                addi.w  #$20,$30(a0)
                bra.s   SKDEZ3Events_ProximityColumnReturn
; ---------------------------------------------------------------------------

SKDEZ3Events_CheckBossColumnDistance:
                cmpi.w  #$110,(Events_bg+$04).w
                bhs.s   SKDEZ3Events_ProximityColumnReturn
                subq.w  #1,$32(a0)
                bpl.s   SKDEZ3Events_ProximityColumnReturn
                move.w  (Events_bg+$02).w,d0
                addi.w  #$90,d0
                cmp.w   $30(a0),d0
                blo.s   SKDEZ3Events_ProximityColumnReturn
                move.w  $30(a0),(Events_bg+$08).w
                addi.w  #$20,$30(a0)
                move.w  #$D,$32(a0)

SKDEZ3Events_ProximityColumnReturn:
                rts
; ---------------------------------------------------------------------------
Map_DEZ3Blocks:
                include "src/objects/shared/zones/dez/act3/mappings/blocks.s"
