; Owner: game/level/zones/mhz/sk
; Responsibility: Mushroom Hill act-two screen initialization, event dispatch and progression control
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

MHZ2_ScreenInit:
                move.w  #4,(Events_routine_fg).w
                clr.w   (Events_bg+$16).w
                st      (ZoneMagnetOrLeafSelectionFlag).w
                move.w  (Player_1+x_pos).w,d0
                lea     Pal_MHZ2Gold(pc),a1
                cmpi.w  #$2940,d0
                bhs.s   SKMHZ2FG_BindInitPaletteTargets
                st      (Events_bg+$04).w
                lea     (Pal_MHZ2+$20).l,a1
                cmpi.w  #$9C0,d0
                bhs.s   SKMHZ2FG_BindInitPaletteTargets
                cmpi.w  #$600,(Player_1+y_pos).w
                blo.s   SKMHZ2FG_BindInitPaletteTargets
                clr.b   (Events_bg+$04).w
                clr.b   (ZoneMagnetOrLeafSelectionFlag).w
                lea     (Pal_MHZ1+$20).l,a1

SKMHZ2FG_BindInitPaletteTargets:
                lea     (Normal_palette_line_3).w,a5
                lea     (Target_palette_line_3).w,a6
                moveq   #bytesToLcnt($40),d0

SKMHZ2FG_CopyInitPalettes:
                move.l  (a1),(a5)+
                move.l  (a1)+,(a6)+
                dbf     d0,SKMHZ2FG_CopyInitPalettes
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

MHZ2_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_X_pos_copy).w
                move.w  (Events_routine_fg).w,d0
                jmp     MHZ2_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

MHZ2_ScreenEvent_Index:
                bra.w   SKMHZ2FG_WaitForLevelEnd
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2FG_TryBeginShipRedraw
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2FG_DrawDeformedBands
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2FG_RedrawAndInitShip
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2FG_CarryPlayerAndDrawShipBands
; ---------------------------------------------------------------------------

SKMHZ2FG_WaitForLevelEnd:
                tst.b   (End_of_level_flag).w
                beq.s   SKMHZ2FG_DrawForegroundAfterIdleFlagTest
                addq.w  #4,(Events_routine_fg).w

SKMHZ2FG_DrawForegroundAfterIdleFlagTest:
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

SKMHZ2FG_TryBeginShipRedraw:
                tst.w   (Events_fg_4).w
                beq.s   SKMHZ2FG_CheckLateCameraBounds
                clr.w   (Events_fg_4).w
                move.w  #$320,(Draw_delayed_position).w
                move.w  #$A,(Draw_delayed_rowcount).w
                addq.w  #8,(Events_routine_fg).w
                bra.w   SKMHZ2FG_RedrawAndInitShip
; ---------------------------------------------------------------------------

; The late camera lock only runs at X = $3C90. Positions past it skip to palette selection
SKMHZ2FG_CheckLateCameraBounds:
                cmpi.w  #$3C90,(Camera_X_pos).w
                blo.s   SKMHZ2FG_SelectCameraMinY
                bne.w   SKMHZ2FG_SwitchPaletteAndDraw
                move.w  #$3C90,(Camera_min_X_pos).w
                cmpi.w  #$280,(Camera_Y_pos).w
                blo.w   SKMHZ2FG_SwitchPaletteAndDraw
                move.w  #$280,(Camera_min_Y_pos).w
                bra.s   SKMHZ2FG_SwitchPaletteAndDraw
; ---------------------------------------------------------------------------

SKMHZ2FG_SelectCameraMinY:
                move.w  #$620,d0
                cmpi.w  #$380,(Camera_X_pos).w
                blo.s   SKMHZ2FG_UpdateCameraMinY
                moveq   #0,d0
                cmpi.w  #$3600,(Camera_X_pos).w
                blo.s   SKMHZ2FG_UpdateCameraMinY
                move.w  #$1A8,d0

SKMHZ2FG_UpdateCameraMinY:
                cmp.w   (Camera_min_Y_pos).w,d0
                beq.s   SKMHZ2FG_SelectEarlyMinimumXFromPlayerY
                move.w  d0,(Camera_min_Y_pos).w

SKMHZ2FG_SelectEarlyMinimumXFromPlayerY:
                cmpi.w  #$3600,(Camera_X_pos).w
                bhs.s   SKMHZ2FG_SelectMaxYFromPlayerRegion
                move.w  #$98,d0
                cmpi.w  #$5C0,(Player_1+y_pos).w
                bhs.s   SKMHZ2FG_TryUpdateCameraMinX
                move.w  #$380,d0

SKMHZ2FG_TryUpdateCameraMinX:
                cmp.w   (Camera_min_X_pos).w,d0
                beq.s   SKMHZ2FG_SelectMaxYFromPlayerRegion
                tst.w   (Events_bg+$16).w
                bne.s   SKMHZ2FG_SelectMaxYFromPlayerRegion
                move.w  d0,(Camera_min_X_pos).w

SKMHZ2FG_SelectMaxYFromPlayerRegion:
                move.w  #$9A0,d0
                cmpi.w  #$3A97,(Player_1+x_pos).w
                blo.s   SKMHZ2FG_UpdateCameraMaxY
                move.w  #$280,d0
                cmpi.w  #$3AC0,(Player_1+x_pos).w
                bhs.s   SKMHZ2FG_UpdateCameraMaxY
                cmpi.w  #$300,(Player_1+y_pos).w
                blo.s   SKMHZ2FG_UpdateCameraMaxY
                move.w  #$9A0,d0

SKMHZ2FG_UpdateCameraMaxY:
                cmp.w   (Camera_max_Y_pos).w,d0
                beq.s   SKMHZ2FG_SwitchPaletteAndDraw
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w

SKMHZ2FG_SwitchPaletteAndDraw:
                bsr.w   SwitchMhz2RegionPalettes
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

SKMHZ2FG_DrawDeformedBands:
                move.w  (Camera_X_pos_copy).w,(HScroll_table+$004).w
                lea     MHZ2_BGDrawArray1(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$15,d6
                moveq   #2,d5
                jmp     SKTileDraw_UpdateFgDeformed(pc)
; ---------------------------------------------------------------------------

SKMHZ2FG_RedrawAndInitShip:
                move.w  #$4280,d1
                move.w  #$280,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.w   SKMHZ2FG_ShipSetupReturn
                move.l  #$400000,(SceneAuxiliaryXOrCompetitionTime).w
                move.w  #$80,d0
                move.w  d0,(SceneRowAnchorOrCompetitionWinCounts).w
                move.w  d0,(SceneAuxiliaryYOrVerticalMotion).w
                jsr     UpdateMhz2ShipScrollCarryAndPropellers(pc)
                lea     (HScroll_table).w,a1
                move.w  (a1)+,d0
                andi.w  #$FFF0,d0
                move.w  d0,(a1)+
                clr.l   (a1)+
                move.w  (a1)+,d0
                andi.w  #$FFF0,d0
                move.w  d0,(a1)+
                lea     (Normal_palette_line_2).w,a1
                lea     Pal_MHZ2Ship(pc),a5
                moveq   #bytesToLcnt($20),d0

SKMHZ2FG_CopyShipPaletteAndAllocProps:
                move.l  (a5)+,(a1)+
                dbf     d0,SKMHZ2FG_CopyShipPaletteAndAllocProps
                lea     (HScroll_table+$00C).w,a5
                clr.l   (a5)
                jsr     (AllocateObject).l
                bne.s   SKMHZ2FG_InstallShipHIntAndAdvance
                move.l  #SKMHZ2BG_AccelerateShipAndSelectY,(a1)
                move.w  #$4C0,$30(a1)
                move.w  #$4000,$3A(a1)
                jsr     (CreateNewSprite4).l
                bne.s   SKMHZ2FG_InstallShipHIntAndAdvance
                move.l  #SKMHZ2BG_InitShipPropeller,(a1)
                move.w  a1,(a5)+
                jsr     (CreateNewSprite4).l
                bne.s   SKMHZ2FG_InstallShipHIntAndAdvance
                move.l  #SKMHZ2BG_InitShipPropeller,(a1)
                move.w  a1,(a5)+

; Queue propeller art and advance even if the movement or propeller allocations failed
SKMHZ2FG_InstallShipHIntAndAdvance:
                movem.l d7-a0/a2-a3,-(sp)
                lea     (ArtKosM_MHZShipPropeller).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZShipPropeller),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$4EF9,(H_int_jump).w
                move.l  #HInt7,(H_int_addr).w
                move.b  #$80,(H_int_counter).w
                move.w  #$8014,(VDP_control_port).l
                addq.w  #4,(Events_routine_fg).w

SKMHZ2FG_ShipSetupReturn:
                rts
; ---------------------------------------------------------------------------

SKMHZ2FG_CarryPlayerAndDrawShipBands:
                jsr     UpdateMhz2ShipScrollCarryAndPropellers(pc)
                lea     MHZ2_BGDrawArray3(pc),a4
                lea     (HScroll_table).w,a6
                moveq   #2,d5
                move.w  (SceneRowAnchorOrCompetitionWinCounts).w,d6
                jsr     Draw_BGNoVert(pc)
                lea     MHZ2_BGDrawArray2(pc),a4
                lea     (HScroll_table+$004).w,a6
                moveq   #2,d5
                move.w  (Camera_Y_pos_rounded).w,d6
                jmp     Draw_BGNoVert(pc)

; =============== S U B R O U T I N E =======================================

UpdateMhz2ShipScrollCarryAndPropellers:
                move.w  (Camera_X_pos_copy).w,d0
                move.w  d0,(HScroll_table+$008).w
                addi.w  #$1E0,d0
                add.w   (SceneAuxiliaryXOrCompetitionTime).w,d0
                move.w  (HScroll_table).w,d2
                move.w  d0,(HScroll_table).w
                move.w  (SceneAuxiliaryYOrVerticalMotion).w,d1
                lea     (Player_1).w,a1
                cmpi.b  #$81,object_control(a1)
                bne.s   SKMHZ2FG_CacheShipYAndPlacePropellers
                move.w  #$2DC,d3
                cmpi.w  #3,(Player_mode).w
                beq.s   SKMHZ2FG_CarryP1ByInverseShipDelta
                move.w  #$2CD,d3

SKMHZ2FG_CarryP1ByInverseShipDelta:
                move.w  (Events_bg+$0C).w,d4
                sub.w   d1,d4
                add.w   d4,y_pos(a1)
                sub.w   d0,d2
                add.w   d2,x_pos(a1)

SKMHZ2FG_CacheShipYAndPlacePropellers:
                move.w  d1,(Events_bg+$0C).w
                neg.w   d1
                addi.w  #$158,d1
                lea     (HScroll_table+$00C).w,a1
                move.w  #$46B8,d2
                bsr.s   PositionMhz2ShipPropellerFromScroll
                move.w  #$45B8,d2
; End of function UpdateMhz2ShipScrollCarryAndPropellers

; =============== S U B R O U T I N E =======================================

PositionMhz2ShipPropellerFromScroll:
                move.w  (a1)+,d3
                beq.s   SKMHZ2FG_PropellerPositionReturn
                movea.w d3,a5
                sub.w   d0,d2
                bcs.s   SKMHZ2FG_PropellerPositionReturn
                addi.w  #$5C,d2
                andi.w  #$1FF,d2
                move.w  d2,$10(a5)
                move.w  d1,$14(a5)

SKMHZ2FG_PropellerPositionReturn:
                rts
; End of function PositionMhz2ShipPropellerFromScroll

; =============== S U B R O U T I N E =======================================

SwitchMhz2RegionPalettes:
                lea     SKMHZ2FG_PaletteRegionBounds(pc),a1
                move.w  (Player_1+x_pos).w,d0
                move.w  (Player_1+y_pos).w,d1
                moveq   #0,d2
                move.w  #5-1,d3

; The X range includes both ends. The Y range excludes its upper end
SKMHZ2FG_CheckPaletteRegion:
                lea     (a1),a5
                cmp.w   (a5)+,d0
                blo.s   SKMHZ2FG_NextPaletteRegion
                cmp.w   (a5)+,d0
                bhi.s   SKMHZ2FG_NextPaletteRegion
                cmp.w   (a5)+,d1
                blo.s   SKMHZ2FG_NextPaletteRegion
                cmp.w   (a5)+,d1
                blo.s   SKMHZ2FG_DispatchPaletteRegion

SKMHZ2FG_NextPaletteRegion:
                adda.w  #$A,a1
                addq.w  #4,d2
                dbf     d3,SKMHZ2FG_CheckPaletteRegion
                rts
; ---------------------------------------------------------------------------

SKMHZ2FG_DispatchPaletteRegion:
                jmp     SKMHZ2FG_PaletteRegionBranches(pc,d2.w)
; End of function SwitchMhz2RegionPalettes

; ---------------------------------------------------------------------------

SKMHZ2FG_PaletteRegionBranches:
                bra.w   SKMHZ2FG_TryAct2PaletteAboveBoundary
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2FG_TryAct2PaletteRightBoundary
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2FG_TryAct2PaletteLeftOfBoundary
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2FG_TryAct2PaletteLeftOfBoundary
; ---------------------------------------------------------------------------
                bra.w   SKMHZ2FG_TryGoldRegionAct2Above
; ---------------------------------------------------------------------------

SKMHZ2FG_TryAct2PaletteAboveBoundary:
                tst.w   (Events_bg+$04).w
                bne.s   SKMHZ2FG_TryAct1PaletteBelowBoundary
                cmp.w   (a5),d1
                blo.s   SKMHZ2FG_SelectAct2Palette
                rts
; ---------------------------------------------------------------------------

SKMHZ2FG_TryAct1PaletteBelowBoundary:
                cmp.w   (a5),d1
                bhs.s   SKMHZ2FG_SelectAct1Palette
                rts
; ---------------------------------------------------------------------------

SKMHZ2FG_TryAct2PaletteRightBoundary:
                tst.w   (Events_bg+$04).w
                bne.s   SKMHZ2FG_TryAct1PaletteLeftOfBoundary
                cmp.w   (a5),d0
                bhs.s   SKMHZ2FG_SelectAct2Palette
                rts
; ---------------------------------------------------------------------------

SKMHZ2FG_TryAct1PaletteLeftOfBoundary:
                cmp.w   (a5),d0
                blo.s   SKMHZ2FG_SelectAct1Palette
                rts
; ---------------------------------------------------------------------------

SKMHZ2FG_TryAct2PaletteLeftOfBoundary:
                tst.w   (Events_bg+$04).w
                bne.s   SKMHZ2FG_TryGoldPaletteRightBoundary
                cmp.w   (a5),d0
                blo.s   SKMHZ2FG_SelectAct2Palette
                rts
; ---------------------------------------------------------------------------

SKMHZ2FG_TryGoldPaletteRightBoundary:
                cmp.w   (a5),d0
                bhs.s   SKMHZ2FG_SelectGoldPalette
                rts
; ---------------------------------------------------------------------------

SKMHZ2FG_TryGoldRegionAct2Above:
                tst.w   (Events_bg+$04).w
                bne.s   SKMHZ2FG_TryGoldPaletteBelowBoundary
                cmp.w   (a5),d1
                blo.s   SKMHZ2FG_SelectAct2Palette
                rts
; ---------------------------------------------------------------------------

SKMHZ2FG_TryGoldPaletteBelowBoundary:
                cmp.w   (a5),d1
                bhs.s   SKMHZ2FG_SelectGoldPalette
                rts
; ---------------------------------------------------------------------------

SKMHZ2FG_SelectAct2Palette:
                st      (Events_bg+$04).w
                st      (ZoneMagnetOrLeafSelectionFlag).w
                lea     (Pal_MHZ2+$20).l,a1
                bra.s   SKMHZ2FG_PrepareNormalPalette64ByteCopy
; ---------------------------------------------------------------------------

SKMHZ2FG_SelectAct1Palette:
                clr.w   (Events_bg+$04).w
                clr.b   (ZoneMagnetOrLeafSelectionFlag).w
                lea     (Pal_MHZ1+$20).l,a1
                bra.s   SKMHZ2FG_PrepareNormalPalette64ByteCopy
; ---------------------------------------------------------------------------

; Use the gold palette with the Act 2 leaf graphics selection
SKMHZ2FG_SelectGoldPalette:
                clr.w   (Events_bg+$04).w
                st      (ZoneMagnetOrLeafSelectionFlag).w
                lea     Pal_MHZ2Gold(pc),a1

SKMHZ2FG_PrepareNormalPalette64ByteCopy:
                lea     (Normal_palette_line_3).w,a5
                moveq   #bytesToLcnt($40),d0

SKMHZ2FG_CopySelectedPalette:
                move.l  (a1)+,(a5)+
                dbf     d0,SKMHZ2FG_CopySelectedPalette
                rts
; ---------------------------------------------------------------------------
MHZ2_BGDrawArray1:
                dc.w    $2B0, $7FFF
MHZ2_BGDrawArray2:
                dc.w    $300, $7FFF
MHZ2_BGDrawArray3:
                dc.w    $100, $7FFF
Pal_MHZ2Ship:
                binclude "data/Levels/MHZ/Palettes/Act 2 Ship.bin"
                even
Pal_MHZ2Gold:
                binclude "data/Levels/MHZ/Palettes/Act 2 Gold.bin"
                even
; Each region record holds four boundary words and one palette switch threshold
SKMHZ2FG_PaletteRegionBounds:
                dc.w    $420,  $4A0,  $640,  $6C0
                dc.w    $680,  $980,  $A00,  $7C0
                dc.w    $800,  $9C0, $2900, $2980
                dc.w    $280,  $300, $2940, $2B00
                dc.w    $2B80,  $540,  $580, $2B40
                dc.w    $2800, $2980,  $7C0,  $840
                dc.w    $800
