; Owner: game/level/zones/ssz/sk
; Responsibility: Sky Sanctuary act-one screen initialization, event dispatch and progression control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SSZ1_ScreenInit:
                tst.b   (Last_star_post_hit).w
                bne.s   SKSSZ1FG_ResetEscapeOffsets
                jsr     (AllocateObject).l
                bne.s   SKSSZ1FG_ResetEscapeOffsets
                move.l  #SSZArrival_AttemptBeamAllocation,(a1)
                move.w  #$100,x_pos(a1)
                move.b  #$6C,$2D(a1)
                st      (Events_bg+$05).w
                move.w  #$200,(Camera_max_X_pos).w
                move.w  #$BC0,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                moveq   #$60,d0
                move.w  d0,(Camera_X_pos_copy).w
                move.w  d0,(Camera_X_pos).w
                move.w  #$F49,d0
                move.w  d0,(Camera_Y_pos_copy).w
                move.w  d0,(Camera_Y_pos).w
                st      (Scroll_lock).w

SKSSZ1FG_ResetEscapeOffsets:
                clr.w   (SceneAuxiliaryXOrCompetitionTime).w
                clr.w   (SceneAuxiliaryYOrVerticalMotion).w
                lea     (HScroll_table+$1F6).w,a1
                lea     (a1),a5
                moveq   #5-1,d0

SKSSZ1FG_ClearCloudHandlesAndAlloc:
                clr.w   (a1)+
                dbf     d0,SKSSZ1FG_ClearCloudHandlesAndAlloc
                lea     SKSSZ1Geometry_CloudMotionSeeds(pc),a6
                moveq   #5-1,d1
                jsr     (AllocateObject).l
                bne.s   SKSSZ1FG_PlaceCloudsAndRefresh

SKSSZ1FG_InitRoamingCloud:
                move.w  a1,(a5)+
                move.l  #SKSSZ1BG_InitRoamingCloud,(a1)
                move.w  (a6)+,$38(a1)
                move.w  (a6)+,$3A(a1)
                move.w  (a6)+,$40(a1)
                move.w  (a6)+,d2
                move.b  d2,mapping_frame(a1)
                jsr     (CreateNewSprite4).l
                dbne    d1,SKSSZ1FG_InitRoamingCloud

SKSSZ1FG_PlaceCloudsAndRefresh:
                jsr     PositionSsz1RoamingCloudSprites(pc)
                jsr     (Reset_TileOffsetPositionActual).l
                jmp     (Refresh_PlaneFull).l
; ---------------------------------------------------------------------------

SSZ1_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                move.w  (Events_routine_fg).w,d0
                jmp     SSZ1_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SSZ1_ScreenEvent_Index:
                bra.w   SKSSZ1FG_UpdateOrdinaryRoute
; ---------------------------------------------------------------------------
                bra.w   SKSSZ1FG_TryStepStripCollapse
; ---------------------------------------------------------------------------
                bra.w   SKSSZ1FG_DrawEscapeForeground
; ---------------------------------------------------------------------------

SKSSZ1FG_UpdateOrdinaryRoute:
                tst.b   (End_of_level_flag).w
                bne.s   SKSSZ1FG_TrySpawnEscapeCamera
                jsr     SSZ1_UpdateRouteAndBossGates(pc)
                jsr     PositionSsz1RoamingCloudSprites(pc)
                jmp     (DrawTilesAsYouMove).l
; ---------------------------------------------------------------------------

SKSSZ1FG_TrySpawnEscapeCamera:
                jsr     (AllocateObject).l
                bne.s   SKSSZ1FG_BindCollapseArrays
                move.l  #SSZEscape_UpdateControllerAndRumble,(a1)
                move.w  #$1E,$2E(a1)

SKSSZ1FG_BindCollapseArrays:
                lea     (HScroll_table+$E0).w,a1
                lea     $20(a1),a5
                moveq   #$A-1,d0

SKSSZ1FG_InitStripCollapse:
                move.w  #-1,(a1)+
                clr.l   (a5)+
                clr.l   $3C(a5)
                dbf     d0,SKSSZ1FG_InitStripCollapse
                jsr     UpdateSsz1TenStripForegroundCollapse(pc)
                lea     (HScroll_table+$80).w,a1
                move.w  (Camera_Y_pos_mask).w,d0
                moveq   #$A-1,d1

SKSSZ1FG_SeedRoundedYAndEnableVInt:
                move.w  (a1)+,(a1)
                and.w   d0,(a1)+
                dbf     d1,SKSSZ1FG_SeedRoundedYAndEnableVInt
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                st      (Ctrl_1_locked).w
                st      (Ctrl_2_locked).w
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                st      (Scroll_lock).w
                st      (Screen_shake_flag).w
                move.w  #4,(Special_V_int_routine).w
                addq.w  #4,(Events_routine_fg).w
                bra.s   SKSSZ1FG_DrawCollapsedStrips
; ---------------------------------------------------------------------------

SKSSZ1FG_TryStepStripCollapse:
                tst.w   (Events_fg_4).w
                bne.s   SKSSZ1FG_LoadEscapeArtAndLayout
                jsr     UpdateSsz1TenStripForegroundCollapse(pc)

SKSSZ1FG_DrawCollapsedStrips:
                lea     SKSSZ1FG_CollapseStripSpans(pc),a4
                lea     (HScroll_table+$80).w,a5
                moveq   #$F,d6
                moveq   #$A,d5
                jmp     (DrawTilesVDeform).l
; ---------------------------------------------------------------------------

SKSSZ1FG_LoadEscapeArtAndLayout:
                movem.l d7-a0/a2-a3,-(sp)
                lea     (SSZ1_128x128_Custom_Kos).l,a1
                lea     (Chunk_table+$180).l,a2
                jsr     (Queue_Kos).l
                lea     (SSZ1_16x16_Custom_Kos).l,a1
                lea     (Block_table+$B8).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_SSZ1_Custom).l,a1
                move.w  #tiles_to_bytes($073),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SSZSpiralRamp).l,a1
                move.w  #tiles_to_bytes(ArtTile_SSZSpiralRamp),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  -8(a3),d0
                subq.w  #3,d0
                movea.w (a3),a1
                move.b  #4,(a1,d0.w)
                move.b  #5,1(a1,d0.w)
                move.b  #6,2(a1,d0.w)
                movea.w 4(a3),a1
                move.b  #7,(a1,d0.w)
                move.b  #8,1(a1,d0.w)
                move.b  #9,2(a1,d0.w)
                lea     (Normal_palette_line_2).w,a1
                lea     Pal_SSZDeathEgg(pc),a5
                moveq   #bytesToLcnt($20),d0

SKSSZ1FG_CopyEscapePaletteAndSetup:
                move.l  (a5)+,(a1)+
                dbf     d0,SKSSZ1FG_CopyEscapePaletteAndSetup
                jsr     SSZ1Escape_UpdateCameraAndClouds(pc)
                move.w  (SszEscapeXOrSaveDigitTileBuffer).w,d0
                move.w  d0,d1
                andi.w  #$FFF0,d0
                move.w  d0,(SszEscapeRoundedColumnAnchor).w
                move.w  (SszEscapeYOrSaveLowerDigitTiles).w,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(SszEscapeRoundedRowAnchor).w
                st      (SceneAuxiliaryXOrCompetitionTime).w
                clr.l   (SszEscapeVerticalDriftAccumulator).w
                clr.w   (SszDebrisClearRowVramRequest).w
                jsr     (AllocateObject).l
                bne.w   SKSSZ1FG_SignalRampReadyAndSetVInt
                move.w  #$5A8,d1
                move.w  #$58C,d2
                move.w  #$554,d3
                moveq   #$A-1,d4

; The last group uses two pieces. An allocation failure leaves any earlier pieces in place
SKSSZ1FG_TrySpawnRampGroup:
                move.l  #SSZSpiralLeftInnerSection_Initialize,(a1)
                move.w  #$1A38,x_pos(a1)
                move.w  d1,y_pos(a1)
                jsr     (CreateNewSprite4).l
                bne.s   SKSSZ1FG_SignalRampReadyAndSetVInt
                move.l  #SSZSpiralRightOuterSection_Initialize,(a1)
                move.w  #$1A80,x_pos(a1)
                move.w  d2,y_pos(a1)
                tst.w   d4
                beq.s   SKSSZ1FG_SignalRampReadyAndSetVInt
                jsr     (CreateNewSprite4).l
                bne.s   SKSSZ1FG_SignalRampReadyAndSetVInt
                move.l  #SSZSpiralRightInnerSection_Initialize,(a1)
                move.w  #$1A48,x_pos(a1)
                move.w  d1,y_pos(a1)
                subi.w  #$38,y_pos(a1)
                jsr     (CreateNewSprite4).l
                bne.s   SKSSZ1FG_SignalRampReadyAndSetVInt
                move.l  #SSZSpiralLeftOuterSection_Initialize,(a1)
                move.w  #$19F8,x_pos(a1)
                move.w  d3,y_pos(a1)
                moveq   #$70,d5
                sub.w   d5,d1
                sub.w   d5,d2
                sub.w   d5,d3
                jsr     (CreateNewSprite4).l
                dbne    d4,SKSSZ1FG_TrySpawnRampGroup

SKSSZ1FG_SignalRampReadyAndSetVInt:
                st      (Events_fg_4).w
                move.w  #$C,(Special_V_int_routine).w
                addq.w  #4,(Events_routine_fg).w
                rts
; ---------------------------------------------------------------------------

SKSSZ1FG_DrawEscapeForeground:
                jsr     SSZ1Escape_UpdateCameraAndClouds(pc)
                lea     (SszEscapeXOrSaveDigitTileBuffer).w,a6
                lea     (SszEscapeRoundedColumnAnchor).w,a5
                move.w  (SszEscapeYOrSaveLowerDigitTiles).w,d1
                moveq   #$F,d6
                jsr     (Draw_TileColumn).l
                lea     (SszEscapeYOrSaveLowerDigitTiles).w,a6
                lea     (SszEscapeRoundedRowAnchor).w,a5
                move.w  (SszEscapeXOrSaveDigitTileBuffer).w,d1
                moveq   #$15,d6
                jmp     (Draw_TileRow).l

; =============== S U B R O U T I N E =======================================

; Maintain the separate foreground draw and vertical-scroll origin during the spiral escape
SSZ1Escape_UpdateCameraAndClouds:
                move.w  (Camera_X_pos_copy).w,(SszEscapeXOrSaveDigitTileBuffer).w
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$110,d0
                asr.w   #2,d0
                move.w  d0,(SszEscapeYOrSaveLowerDigitTiles).w
                cmpi.w  #$110,(Camera_Y_pos).w
                bne.w   PositionSsz1RoamingCloudSprites
                addi.l  #$6000,(SszEscapeVerticalDriftAccumulator).w
                move.w  (SszEscapeVerticalDriftAccumulator).w,d0
                add.w   d0,(SszEscapeYOrSaveLowerDigitTiles).w
                bra.s   PositionSsz1RoamingCloudSprites
; End of function SSZ1Escape_UpdateCameraAndClouds

; =============== S U B R O U T I N E =======================================

UpdateSsz1TenStripForegroundCollapse:
                lea     (HScroll_table+$80).w,a5
                lea     $60(a5),a6
                move.w  (Camera_Y_pos_copy).w,d0
                moveq   #$A,d1
                moveq   #$A-1,d2

SKSSZ1FG_SelectStripFallState:
                tst.w   (a6)
                beq.s   SKSSZ1FG_MoveAndAccelStrip
                bmi.s   SKSSZ1FG_ClampStripYAndCount
                subq.w  #1,(a6)
                bra.s   SKSSZ1FG_ClampStripYAndCount
; ---------------------------------------------------------------------------

SKSSZ1FG_MoveAndAccelStrip:
                move.l  $80(a5),d3
                addi.l  #$800,$80(a5)
                sub.l   d3,$C0(a5)

SKSSZ1FG_ClampStripYAndCount:
                move.w  $C0(a5),d3
                add.w   d0,d3
                cmpi.w  #$580,d3
                bhs.s   SKSSZ1FG_WriteStripYAndPlaceActor
                clr.l   $80(a5)
                move.w  #$580,d3
                subq.w  #1,d1

; Place the tracked actor from the unclamped strip displacement, independent of the exported draw Y
SKSSZ1FG_WriteStripYAndPlaceActor:
                move.w  d3,(a5)
                move.w  d3,-$20(a6)
                addq.w  #4,a5
                addq.w  #2,a6
                dbf     d2,SKSSZ1FG_SelectStripFallState
                movea.w (SceneControllerObjectAddress).w,a1
                move.w  $10(a1),d0
                subi.w  #$19A0,d0
                lsr.w   #3,d0
                andi.w  #$FFFC,d0
                lea     (HScroll_table+$140).w,a5
                move.w  #$660,d2
                sub.w   (a5,d0.w),d2
                move.w  d2,$14(a1)
                tst.w   d1
                bne.s   PositionSsz1RoamingCloudSprites
                st      (Events_fg_4+1).w
                move.l  #Delete_Current_Sprite,(a1)
; End of function UpdateSsz1TenStripForegroundCollapse

; =============== S U B R O U T I N E =======================================

PositionSsz1RoamingCloudSprites:
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Screen_shake_offset).w,d3
                sub.w   d3,d0
                move.w  d0,d1
                asr.w   #2,d1
                add.w   d1,d0
                move.w  (SceneAuxiliaryYOrVerticalMotion).w,d1
                move.w  d1,d2
                asr.w   #2,d2
                add.w   d2,d1
                asr.w   #1,d1
                add.w   d1,d0
                add.w   d3,d0
                move.w  (Camera_X_pos_copy).w,d1
                move.w  d1,d2
                asr.w   #2,d2
                add.w   d2,d1
                lea     (HScroll_table+$1F6).w,a5
                moveq   #5-1,d2

SKSSZ1FG_TryPlaceRoamingCloud:
                move.w  (a5)+,d3
                beq.s   SKSSZ1FG_NextRoamingCloudHandle
                movea.w d3,a6
                move.w  $38(a6),d3
                sub.w   d0,d3
                andi.w  #$FF,d3
                addi.w  #$70,d3
                move.w  d3,$14(a6)
                move.w  $3A(a6),d3
                sub.w   d1,d3
                andi.w  #$1FF,d3
                addi.w  #$50,d3
                move.w  d3,$10(a6)

SKSSZ1FG_NextRoamingCloudHandle:
                dbf     d2,SKSSZ1FG_TryPlaceRoamingCloud
                rts
; End of function PositionSsz1RoamingCloudSprites

; =============== S U B R O U T I N E =======================================

; Lock the two replica-boss arenas, spawn their bosses and latch the final area's camera bounds
SSZ1_UpdateRouteAndBossGates:
                tst.b   (Events_bg+$06).w
                bne.w   SKSSZ1FG_RouteUpdateReturn
                cmpi.w  #$19A0,(Camera_X_pos).w
                blo.s   SKSSZ1FG_CheckOrdinaryCameraLimits
                cmpi.w  #$680,(Player_1+y_pos).w
                bhs.s   SKSSZ1FG_CheckOrdinaryCameraLimits
                move.w  #$19A0,(Camera_min_X_pos).w
                move.w  #$5C0,d0
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                st      (Events_bg+$06).w
                bra.w   SKSSZ1FG_RouteUpdateReturn
; ---------------------------------------------------------------------------

SKSSZ1FG_CheckOrdinaryCameraLimits:
                tst.b   (Events_bg+$05).w
                bne.w   SKSSZ1FG_RouteUpdateReturn
                move.b  (Events_bg+$01).w,d0
                or.b    (Events_bg+$03).w,d0
                bne.s   SKSSZ1FG_SelectReplicaBossRoute
                move.w  (Camera_Y_pos).w,d0
                cmpi.w  #$100,d0
                blo.s   SKSSZ1FG_EnableVerticalWrapLimits
                cmpi.w  #$E00,d0
                bhs.s   SKSSZ1FG_EnableVerticalWrapLimits
                lea     SKSSZ1FG_MinYByCameraX(pc),a1
                move.w  (Player_1+x_pos).w,d1

SKSSZ1FG_ScanMinYByCameraX:
                cmp.w   (a1)+,d1
                blo.s   SKSSZ1FG_TrySetCameraMinY
                addq.w  #2,a1
                bra.s   SKSSZ1FG_ScanMinYByCameraX
; ---------------------------------------------------------------------------

SKSSZ1FG_TrySetCameraMinY:
                move.w  (a1),d2
                cmp.w   d0,d2
                bhi.s   SKSSZ1FG_BindMaxYTable
                move.w  d2,(Camera_min_Y_pos).w

SKSSZ1FG_BindMaxYTable:
                lea     SKSSZ1FG_MaxYByCameraX(pc),a1

SKSSZ1FG_ScanMaxYByCameraX:
                cmp.w   (a1)+,d1
                blo.s   SKSSZ1FG_TrySetCameraMaxY
                addq.w  #2,a1
                bra.s   SKSSZ1FG_ScanMaxYByCameraX
; ---------------------------------------------------------------------------

SKSSZ1FG_TrySetCameraMaxY:
                move.w  (a1),d2
                cmp.w   d0,d2
                blo.s   SKSSZ1FG_SelectReplicaBossRoute
                move.w  d2,(Camera_max_Y_pos).w
                move.w  d2,(Camera_target_max_Y_pos).w
                bra.s   SKSSZ1FG_SelectReplicaBossRoute
; ---------------------------------------------------------------------------

SKSSZ1FG_EnableVerticalWrapLimits:
                move.w  #-$100,(Camera_min_Y_pos).w
                move.w  #$1000,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w

SKSSZ1FG_SelectReplicaBossRoute:
                move.w  (Player_1+y_pos).w,d0
                cmpi.w  #$440,d0
                blo.s   SKSSZ1FG_CheckMTZRouteAndLockX
                cmpi.w  #$880,d0
                bhs.w   SKSSZ1FG_OpenHorizontalRoute
                tst.b   (Events_bg+$00).w
                bmi.w   SKSSZ1FG_OpenHorizontalRoute
                bne.w   SKSSZ1FG_RouteUpdateReturn
                tst.b   (Events_bg+$01).w
                bne.s   SKSSZ1FG_TrySpawnGHZReplica
                move.w  #$160,(Camera_min_X_pos).w
                move.w  #$19A0,(Camera_max_X_pos).w
                cmpi.w  #$7C0,d0
                blo.w   SKSSZ1FG_RouteUpdateReturn
                cmpi.w  #$160,(Camera_X_pos).w
                bne.w   SKSSZ1FG_RouteUpdateReturn
                btst    #1,(Player_1+status).w
                bne.w   SKSSZ1FG_RouteUpdateReturn
                move.w  #$160,(Camera_max_X_pos).w
                move.w  #$7C0,d0
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                st      (Events_bg+$01).w

SKSSZ1FG_TrySpawnGHZReplica:
                cmpi.w  #$7C0,(Camera_Y_pos).w
                bne.w   SKSSZ1FG_RouteUpdateReturn
                jsr     (AllocateObject).l
                bne.s   SKSSZ1FG_ReturnAfterGHZSpawn
                move.l  #Obj_SSZGHZBoss,(a1)
                st      (Events_bg+$05).w
                move.w  #$7F00,(Events_bg+$00).w

SKSSZ1FG_ReturnAfterGHZSpawn:
                bra.s   SKSSZ1FG_RouteUpdateReturn
; ---------------------------------------------------------------------------

SKSSZ1FG_CheckMTZRouteAndLockX:
                tst.b   (Events_bg+$02).w
                bmi.s   SKSSZ1FG_OpenHorizontalRoute
                bne.s   SKSSZ1FG_RouteUpdateReturn
                tst.b   (Events_bg+$03).w
                bne.s   SKSSZ1FG_TrySpawnMTZReplica
                move.w  #$1660,(Camera_max_X_pos).w
                moveq   #0,d1
                tst.w   (Events_bg+$00).w
                bne.s   SKSSZ1FG_SetMTZMinXAndCheckP1
                move.w  #$160,d1

SKSSZ1FG_SetMTZMinXAndCheckP1:
                move.w  d1,(Camera_min_X_pos).w
                cmpi.w  #$420,d0
                blo.s   SKSSZ1FG_RouteUpdateReturn
                cmpi.w  #$1660,(Camera_X_pos).w
                bne.s   SKSSZ1FG_RouteUpdateReturn
                btst    #1,(Player_1+status).w
                bne.s   SKSSZ1FG_RouteUpdateReturn
                move.w  #$1660,(Camera_min_X_pos).w
                move.w  #$380,d0
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                st      (Events_bg+$03).w

SKSSZ1FG_TrySpawnMTZReplica:
                cmpi.w  #$380,(Camera_Y_pos).w
                bne.s   SKSSZ1FG_RouteUpdateReturn
                jsr     (AllocateObject).l
                bne.s   SKSSZ1FG_ReturnAfterMTZSpawn
                move.l  #Obj_SSZMTZBoss,(a1)
                st      (Events_bg+$05).w
                move.w  #$7F00,(Events_bg+$02).w

SKSSZ1FG_ReturnAfterMTZSpawn:
                bra.s   SKSSZ1FG_RouteUpdateReturn
; ---------------------------------------------------------------------------

SKSSZ1FG_OpenHorizontalRoute:
                clr.w   (Camera_min_X_pos).w
                move.w  #$19A0,(Camera_max_X_pos).w

SKSSZ1FG_RouteUpdateReturn:
                rts
; End of function SSZ1_UpdateRouteAndBossGates

; ---------------------------------------------------------------------------
SKSSZ1FG_MinYByCameraX:
                dc.w    $EE0,  $D00
                dc.w    $11E0,  $CC0
                dc.w    $1340,  $B20
                dc.w    $7FFF,     0
SKSSZ1FG_MaxYByCameraX:
                dc.w    $640,  $C60
                dc.w    $880,  $CA0
                dc.w    $1200,  $C60
                dc.w    $1380,  $A80
                dc.w    $13C0,  $660
                dc.w    $7FFF,  $3E0
SKSSZ1FG_CollapseStripSpans:
                dc.w    $19C0
                dc.w    $20
                dc.w    $20
                dc.w    $20
                dc.w    $20
                dc.w    $20
                dc.w    $20
                dc.w    $20
                dc.w    $20
                dc.w    $7FFF
SSZEscape_ForegroundStripStartCountdowns:
                dc.w    0,     9
                dc.w    $C,     6
                dc.w    3,    $C
                dc.w    0,     9
                dc.w    $C,     3
Pal_SSZDeathEgg:
                binclude "data/Levels/SSZ/Palettes/Death Egg.bin"
                even
