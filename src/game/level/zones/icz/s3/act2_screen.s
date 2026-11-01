; Owner: game/level/zones/icz/s3
; Responsibility: IceCap act-two indoor and outdoor screen control, background events and deformation
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
                cmpi.w  #$3600,(Camera_X_pos_copy).w    ; Check ranges for either indoor/outdoor BGs
                bhs.s   loc_3DF48
                cmpi.w  #$720,(Camera_Y_pos_copy).w
                bhs.s   loc_3DF76
                cmpi.w  #$1000,(Camera_X_pos_copy).w
                bhs.s   loc_3DF48
                cmpi.w  #$580,(Camera_Y_pos_copy).w
                bhs.s   loc_3DF76

loc_3DF48:
                clr.w   (Events_bg+$16).w               ; Outdoors
                cmpi.w  #$720,(Camera_X_pos_copy).w
                bhs.s   loc_3DF5A
                jsr     ICZ2_SetICZ1Pal(pc)
                bra.s   loc_3DF5E
; ---------------------------------------------------------------------------

loc_3DF5A:
                jsr     ICZ2_SetOutdoorsPal(pc)

loc_3DF5E:
                jsr     ICZ2_OutDeform(pc)
                moveq   #0,d0
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                lea     ICZ2_OutBGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

loc_3DF76:
                st      (Events_bg+$16).w               ; Indoors
                jsr     ICZ2_SetIndoorsPal(pc)
                jsr     ICZ2_InDeform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                lea     ICZ2_InBGDeformArray(pc),a4
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
                cmpi.w  #$580,(Camera_Y_pos_copy).w
                bhs.s   loc_3DFD8
                bra.s   loc_3E036
; ---------------------------------------------------------------------------

ICZ2BGE_Normal:
                tst.w   (Events_bg+$16).w
                bne.s   loc_3E012
                move.w  (Camera_X_pos_copy).w,d0        ; If outdoors
                cmpi.w  #$1000,d0
                blo.s   loc_3E002
                cmpi.w  #$3600,d0
                bhs.s   loc_3E002
                cmpi.w  #$720,(Camera_Y_pos_copy).w
                blo.s   loc_3E002

loc_3DFD8:
                st      (Events_bg+$16).w               ; Set to go indoors
                jsr     ICZ2_SetIndoorsPal(pc)
                jsr     ICZ2_InDeform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.w   loc_3E0B0
; ---------------------------------------------------------------------------

loc_3E002:
                jsr     ICZ2_OutDeform(pc)              ; No trigger, run normal deformation

loc_3E006:
                lea     ICZ2_OutBGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

loc_3E012:
                move.w  (Camera_X_pos_copy).w,d0        ; If indoors
                cmpi.w  #$1900,d0
                blo.s   loc_3E022
                cmpi.w  #$1B80,d0
                blo.s   loc_3E06C

loc_3E022:
                cmpi.w  #$1000,d0
                blo.s   loc_3E06C
                cmpi.w  #$3600,d0
                bhs.s   loc_3E06C
                cmpi.w  #$720,(Camera_Y_pos_copy).w
                bhs.s   loc_3E06C

loc_3E036:
                clr.w   (Events_bg+$16).w
                cmpi.w  #$720,(Camera_X_pos_copy).w
                bhs.s   loc_3E048
                jsr     ICZ2_SetICZ1Pal(pc)
                bra.s   loc_3E04C
; ---------------------------------------------------------------------------

loc_3E048:
                jsr     ICZ2_SetOutdoorsPal(pc)

loc_3E04C:
                jsr     ICZ2_OutDeform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3E096
; ---------------------------------------------------------------------------

loc_3E06C:
                jsr     ICZ2_InDeform(pc)

loc_3E070:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     ICZ2_InBGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

ICZ2BGE_Refresh:
                tst.w   (Events_bg+$16).w
                bne.s   loc_3E0AC
                jsr     ICZ2_OutDeform(pc)

loc_3E096:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.w   loc_3E006
                subq.w  #4,(Events_routine_bg).w
                bra.w   loc_3E006
; ---------------------------------------------------------------------------

loc_3E0AC:
                jsr     ICZ2_InDeform(pc)

loc_3E0B0:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   loc_3E070
                subq.w  #4,(Events_routine_bg).w
                bra.s   loc_3E070

; =============== S U B R O U T I N E =======================================

ICZ2_OutDeform:
                clr.w   (Camera_Y_pos_BG_copy).w        ; Effective Y is always 0
                move.w  (Camera_X_pos_copy).w,d0
                move.w  (Level_frame_counter).w,d1
                asr.w   #1,d1
                add.w   d1,d0
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                andi.l  #$7FFFFF,d0
                move.l  d0,d1
                asr.l   #6,d1
                lea     (HScroll_table+$064).w,a1
                moveq   #$28-1,d2

loc_3E0E8:
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                sub.l   d1,d0
                dbf     d2,loc_3E0E8
                lea     (HScroll_table).w,a1
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d1
                asr.l   #1,d0
                add.l   d0,d1
                move.l  d1,$64(a1)
                asr.l   #2,d0
                move.l  d0,d1
                swap    d0
                move.w  d0,(a1)+
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,(a1)+
                move.w  (Level_frame_counter).w,d1
                lsr.w   #2,d1
                andi.w  #$3E,d1
                lea     AIZ2_ALZ_BGDeformDelta(pc),a5
                adda.w  d1,a5
                moveq   #8-1,d1

loc_3E12E:
                move.w  (a5)+,d2
                add.w   d0,d2
                move.w  d2,(a1)+
                dbf     d1,loc_3E12E
                rts
; End of function ICZ2_OutDeform

; =============== S U B R O U T I N E =======================================

ICZ2_InDeform:
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$700,d0
                asr.w   #2,d0
                addi.w  #$118,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                lea     (HScroll_table).w,a1
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d1
                asr.l   #3,d1
                swap    d0
                move.w  d0,(a1)
                move.w  d0,$10(a1)
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,2(a1)
                move.w  d0,$E(a1)
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,4(a1)
                move.w  d0,$C(a1)
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,6(a1)
                move.w  d0,$A(a1)
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                move.w  d0,8(a1)
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,(Events_bg+$10).w
                rts
; End of function ICZ2_InDeform

; =============== S U B R O U T I N E =======================================

ICZ2_SetOutdoorsPal:
                tst.b   (Game_mode).w
                bmi.s   loc_3E1B6
                lea     (Normal_palette_line_4+2).w,a1
                bsr.s   WriteIcz2OutdoorPaletteColors

loc_3E1B6:
                lea     (Target_palette_line_4+2).w,a1

WriteIcz2OutdoorPaletteColors:
                move.l  #$EEE0EEA,(a1)+
                move.l  #$EC80EA4,(a1)+
                move.l  #$C820C60,(a1)+
                move.l  #$C400E20,(a1)+
                move.l  #$A000E00,(a1)
                rts
; End of function ICZ2_SetOutdoorsPal

; =============== S U B R O U T I N E =======================================

ICZ2_SetIndoorsPal:
                tst.b   (Game_mode).w
                bmi.s   loc_3E1E6
                lea     (Normal_palette_line_4+2).w,a1
                bsr.s   WriteIcz2IndoorPaletteColors

loc_3E1E6:
                lea     (Target_palette_line_4+2).w,a1

WriteIcz2IndoorPaletteColors:
                move.l  #$EE20E24,(a1)+
                move.l  #$E040E02,(a1)+
                move.l  #$4020200,(a1)+
                move.l  #$0000E20,(a1)+
                move.l  #$E400840,(a1)+
                move.w  #$600,(a1)
                rts
; End of function ICZ2_SetIndoorsPal

; =============== S U B R O U T I N E =======================================

ICZ2_SetICZ1Pal:
                tst.b   (Game_mode).w
                bmi.s   loc_3E21A
                lea     (Normal_palette_line_4+2).w,a1
                bsr.s   WriteIcz2Act1TransitionPaletteColors

loc_3E21A:
                lea     (Target_palette_line_4+2).w,a1

WriteIcz2Act1TransitionPaletteColors:
                move.l  #$EEC0CC6,(a1)+
                move.l  #$C800C60,(a1)+
                move.l  #$C400A40,(a1)+
                move.l  #$8200620,(a1)+
                move.l  #$2000600,(a1)
                rts
; End of function ICZ2_SetICZ1Pal

; ---------------------------------------------------------------------------
ICZ2_OutBGDeformArray:
                dc.w    $5A,   $26, $8030, $7FFF
ICZ2_InBGDeformArray:
                dc.w    $1A0,   $40,   $20,   $18,   $40,     8,     8,   $18, $7FFF
