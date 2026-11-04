; Owner: game/level/zones/hpz/sk
; Responsibility: Hidden Palace screen and background initialization, event state and progression control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

HPZ_ScreenInit:
                cmpi.w  #3,(Player_mode).w
                bne.s   SKHPZEvents_TryPinUpperStartMinX
                move.w  #$AA0,(Camera_max_X_pos).w
                bra.s   SKHPZEvents_RefreshInitialForeground
; ---------------------------------------------------------------------------

SKHPZEvents_TryPinUpperStartMinX:
                cmpi.w  #$480,(Player_1+y_pos).w
                bhs.s   SKHPZEvents_RefreshInitialForeground
                move.w  #$AA0,(Camera_min_X_pos).w

SKHPZEvents_RefreshInitialForeground:
                jsr     (Reset_TileOffsetPositionActual).l
                jmp     (Refresh_PlaneFull).l
; ---------------------------------------------------------------------------

HPZ_ScreenEvent:
                tst.w   (Events_bg+$00).w
                bne.s   SKHPZEvents_AddShakeAndTryPatch
                tst.w   (Palette_fade_timer).w
                bne.s   SKHPZEvents_AddShakeAndTryPatch
                jsr     (AllocateObject).l
                bne.s   SKHPZEvents_LatchPaletteSetup
                move.l  #Obj_HPZPaletteControl,(a1)

; Record the setup attempt even if allocating the palette controller failed
SKHPZEvents_LatchPaletteSetup:
                st      (Events_bg+$00).w

SKHPZEvents_AddShakeAndTryPatch:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                tst.w   (Events_fg_4).w
                beq.s   SKHPZEvents_DrawForeground
                clr.w   (Events_fg_4).w
                movea.w $1C(a3),a1
                move.b  #$61,$30(a1)
                move.b  #$61,$31(a1)
                jmp     (Refresh_PlaneScreenDirect).l
; ---------------------------------------------------------------------------

SKHPZEvents_DrawForeground:
                jmp     (DrawTilesAsYouMove).l
; ---------------------------------------------------------------------------

HPZ_BackgroundInit:
                move.w  $14(a3),$18(a3)
                cmpi.w  #3,(Player_mode).w
                bne.s   SKHPZEvents_SelectInitialRegion
                movea.w 4(a3),a1
                move.b  #$8E,3(a1)
                move.b  #$8F,4(a1)

SKHPZEvents_SelectInitialRegion:
                cmpi.w  #$EC0,(Player_1+x_pos).w
                bhs.s   SKHPZEvents_InitRightRegion
                jsr     BuildHpzLeftRegionParallax(pc)
                bra.s   SKHPZEvents_RoundScrollAndRefresh
; ---------------------------------------------------------------------------

SKHPZEvents_InitRightRegion:
                move.w  #8,(Events_routine_bg).w
                jsr     BuildHpzRightRegionParallax(pc)

SKHPZEvents_RoundScrollAndRefresh:
                jsr     (Reset_TileOffsetPositionEff).l
                lea     (HScroll_table).w,a1
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)+
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)
                lea     HPZ_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                jsr     (Refresh_PlaneTileDeform).l
                lea     HPZ_BGDeformArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                jmp     (ApplyDeformation).l
; ---------------------------------------------------------------------------

HPZ_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     HPZ_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

HPZ_BackgroundEvent_Index:
                bra.w   SKHPZEvents_TryBeginRightRegion
; ---------------------------------------------------------------------------
                bra.w   SKHPZEvents_PositionRightEntry
; ---------------------------------------------------------------------------
                bra.w   SKHPZEvents_TryReturnToLeftRegion
; ---------------------------------------------------------------------------
                bra.w   SKHPZEvents_PositionLeftReturn
; ---------------------------------------------------------------------------

SKHPZEvents_TryBeginRightRegion:
                cmpi.w  #$EC0,(Player_1+x_pos).w
                blo.s   SKHPZEvents_PositionLeftBackground
                jsr     BuildHpzRightRegionParallax(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                lea     (HScroll_table).w,a1
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)+
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKHPZEvents_RedrawRightBottomUp
; ---------------------------------------------------------------------------

SKHPZEvents_PositionLeftBackground:
                jsr     BuildHpzLeftRegionParallax(pc)

SKHPZEvents_DrawLeftBackground:
                lea     HPZ_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #2,d5
                jsr     (Draw_BG).l
                lea     HPZ_BGDeformArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                jsr     (ApplyDeformation).l
                jmp     (ShakeScreen_Setup).l
; ---------------------------------------------------------------------------

SKHPZEvents_PositionRightEntry:
                jsr     BuildHpzRightRegionParallax(pc)

SKHPZEvents_RedrawRightBottomUp:
                lea     HPZ_BGDrawArray(pc),a4
                lea     (HScroll_table-$04).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d1
                jsr     (Draw_PlaneVertBottomUpComplex).l
                bpl.s   SKHPZEvents_DrawRightBackground
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKHPZEvents_DrawRightBackground
; ---------------------------------------------------------------------------

SKHPZEvents_TryReturnToLeftRegion:
                cmpi.w  #$EC0,(Player_1+x_pos).w
                bhs.s   SKHPZEvents_PositionRightBackground
                jsr     BuildHpzLeftRegionParallax(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                lea     (HScroll_table).w,a1
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)+
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKHPZEvents_RedrawLeftBottomUp
; ---------------------------------------------------------------------------

SKHPZEvents_PositionRightBackground:
                jsr     BuildHpzRightRegionParallax(pc)

SKHPZEvents_DrawRightBackground:
                lea     HPZ_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #2,d5
                jsr     (Draw_BG).l
                lea     HPZ_BGDeformArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                jsr     (ApplyDeformation).l
                jmp     (ShakeScreen_Setup).l
; ---------------------------------------------------------------------------

SKHPZEvents_PositionLeftReturn:
                jsr     BuildHpzLeftRegionParallax(pc)

SKHPZEvents_RedrawLeftBottomUp:
                lea     HPZ_BGDrawArray(pc),a4
                lea     (HScroll_table-$04).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d1
                jsr     (Draw_PlaneVertBottomUpComplex).l
                bpl.w   SKHPZEvents_DrawLeftBackground
                clr.w   (Events_routine_bg).w
                bra.w   SKHPZEvents_DrawLeftBackground

; =============== S U B R O U T I N E =======================================

BuildHpzLeftRegionParallax:
                move.w  #$348,d2
                moveq   #0,d3
                bra.s   SKHPZEvents_BuildSharedParallax
; End of function BuildHpzLeftRegionParallax

; =============== S U B R O U T I N E =======================================

BuildHpzRightRegionParallax:
                move.w  #$E00,d2
                move.w  #$700,d3

SKHPZEvents_BuildSharedParallax:
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Screen_shake_offset).w,d4
                sub.w   d4,d0
                add.w   d3,d0
                swap    d0
                clr.w   d0
                asr.l   #4,d0
                move.l  d0,d1
                add.l   d0,d0
                add.l   d1,d0
                swap    d0
                add.w   d4,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                sub.w   d2,d0
                swap    d0
                clr.w   d0
                move.l  d0,d2
                asr.l   #4,d0
                move.l  d0,d1
                add.l   d0,d0
                add.l   d1,d0
                swap    d0
                move.w  d0,(HScroll_table).w
                move.w  d0,(HScroll_table+$008).w
                lea     (HScroll_table+$01C).w,a1
                move.l  d2,d0
                asr.l   #2,d2
                sub.l   d2,d0
                asr.l   #2,d2
                moveq   #9-1,d1

SKHPZEvents_WriteReverseParallaxBands:
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                sub.l   d2,d0
                dbf     d1,SKHPZEvents_WriteReverseParallaxBands
                move.w  (HScroll_table+$01A).w,(HScroll_table+$004).w
                rts
; End of function BuildHpzRightRegionParallax

; ---------------------------------------------------------------------------
HPZ_BGDrawArray:
                dc.w    $200, $7FFF
HPZ_BGDeformArray:
                dc.w    $198,     8,     4,     4,     8,     8,   $10,     8,   $30, $7FFF
