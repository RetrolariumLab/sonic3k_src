; Owner: game/level/zones/icz/sk
; Responsibility: IceCap act-two screen and background initialization, event control and deformation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

ICZ2_ScreenInit:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

ICZ2_ScreenEvent:
                jmp     DrawTilesAsYouMove(pc)          ; About as straightforward as you can get really
; ---------------------------------------------------------------------------

ICZ2_BackgroundInit:
                move.w  #4,(Events_routine_bg).w
                cmpi.w  #$3600,(Camera_X_pos).w         ; Check ranges for either indoor/outdoor BGs
                bhs.s   SKICZ2Events_ChooseInitialOutdoorPalette
                cmpi.w  #$720,(Camera_Y_pos).w
                bhs.s   SKICZ2Events_InitIndoorBackground
                cmpi.w  #$1000,(Camera_X_pos).w
                bhs.s   SKICZ2Events_ChooseInitialOutdoorPalette
                cmpi.w  #$580,(Camera_Y_pos).w
                bhs.s   SKICZ2Events_InitIndoorBackground

SKICZ2Events_ChooseInitialOutdoorPalette:
                clr.w   (Events_bg+$16).w               ; Outdoors
                cmpi.w  #$720,(Camera_X_pos).w
                bhs.s   SKICZ2Events_LoadInitialOutdoorPalette
                jsr     (ICZ2_SetICZ1Pal).l
                bra.s   SKICZ2Events_InitOutdoorBackground
; ---------------------------------------------------------------------------

SKICZ2Events_LoadInitialOutdoorPalette:
                jsr     (ICZ2_SetOutdoorsPal).l

SKICZ2Events_InitOutdoorBackground:
                jsr     (ICZ2_OutDeform).l
                moveq   #0,d0
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                lea     (ICZ2_OutBGDeformArray).l,a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

SKICZ2Events_InitIndoorBackground:
                st      (Events_bg+$16).w               ; Indoors
                jsr     (ICZ2_SetIndoorsPal).l
                jsr     (ICZ2_InDeform).l
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                lea     (ICZ2_InBGDeformArray).l,a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

ICZ2_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     ICZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

ICZ2_BackgroundEvent_Index:
                bra.w   ICZ2BGE_FromICZ1
; ---------------------------------------------------------------------------
                bra.w   ICZ2BGE_Normal
; ---------------------------------------------------------------------------
                bra.w   ICZ2BGE_Refresh
; ---------------------------------------------------------------------------

ICZ2BGE_FromICZ1:
                addq.w  #4,(Events_routine_bg).w        ; This only applies when coming from ICZ 1
                cmpi.w  #$580,(Camera_Y_pos).w
                bhs.s   SKICZ2Events_BeginIndoorRefresh
                bra.w   SKICZ2Events_ChooseReturnPalette
; ---------------------------------------------------------------------------

ICZ2BGE_Normal:
                tst.w   (Events_bg+$16).w
                bne.s   SKICZ2Events_CheckIndoorKeepRange
                move.w  (Camera_X_pos).w,d0             ; If outdoors
                cmpi.w  #$1000,d0
                blo.s   SKICZ2Events_DeformOutdoorBackground
                cmpi.w  #$3600,d0
                bhs.s   SKICZ2Events_DeformOutdoorBackground
                cmpi.w  #$720,(Camera_Y_pos).w
                blo.s   SKICZ2Events_DeformOutdoorBackground

SKICZ2Events_BeginIndoorRefresh:
                st      (Events_bg+$16).w               ; Set to go indoors
                jsr     (ICZ2_SetIndoorsPal).l
                jsr     (ICZ2_InDeform).l
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.w   SKICZ2Events_StepIndoorRefresh
; ---------------------------------------------------------------------------

SKICZ2Events_DeformOutdoorBackground:
                jsr     (ICZ2_OutDeform).l              ; No trigger, run normal deformation

SKICZ2Events_ApplyOutdoorBandSpans:
                lea     (ICZ2_OutBGDeformArray).l,a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

SKICZ2Events_CheckIndoorKeepRange:
                move.w  (Camera_X_pos).w,d0             ; If indoors
                cmpi.w  #$1900,d0
                blo.s   SKICZ2Events_CheckOutdoorReturnBounds
                cmpi.w  #$1B80,d0
                blo.s   SKICZ2Events_DeformIndoorBackground

SKICZ2Events_CheckOutdoorReturnBounds:
                cmpi.w  #$1000,d0
                blo.s   SKICZ2Events_DeformIndoorBackground
                cmpi.w  #$3600,d0
                bhs.s   SKICZ2Events_DeformIndoorBackground
                cmpi.w  #$720,(Camera_Y_pos).w
                bhs.s   SKICZ2Events_DeformIndoorBackground

SKICZ2Events_ChooseReturnPalette:
                clr.w   (Events_bg+$16).w
                cmpi.w  #$720,(Camera_X_pos).w
                bhs.s   SKICZ2Events_LoadReturnOutdoorPalette
                jsr     (ICZ2_SetICZ1Pal).l
                bra.s   SKICZ2Events_BeginOutdoorRefresh
; ---------------------------------------------------------------------------

SKICZ2Events_LoadReturnOutdoorPalette:
                jsr     (ICZ2_SetOutdoorsPal).l

SKICZ2Events_BeginOutdoorRefresh:
                jsr     (ICZ2_OutDeform).l
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKICZ2Events_StepOutdoorRefresh
; ---------------------------------------------------------------------------

SKICZ2Events_DeformIndoorBackground:
                jsr     (ICZ2_InDeform).l

SKICZ2Events_DrawIndoorAndApplyBands:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     (ICZ2_InBGDeformArray).l,a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

ICZ2BGE_Refresh:
                tst.w   (Events_bg+$16).w
                bne.s   SKICZ2Events_DeformBeforeIndoorRefresh
                jsr     (ICZ2_OutDeform).l

SKICZ2Events_StepOutdoorRefresh:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.w   SKICZ2Events_ApplyOutdoorBandSpans
                subq.w  #4,(Events_routine_bg).w
                bra.w   SKICZ2Events_ApplyOutdoorBandSpans
; ---------------------------------------------------------------------------

SKICZ2Events_DeformBeforeIndoorRefresh:
                jsr     (ICZ2_InDeform).l

SKICZ2Events_StepIndoorRefresh:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   SKICZ2Events_DrawIndoorAndApplyBands
                subq.w  #4,(Events_routine_bg).w
                bra.s   SKICZ2Events_DrawIndoorAndApplyBands
; End of function ICZ2_ScreenInit
