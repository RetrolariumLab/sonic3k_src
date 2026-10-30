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
                bhs.s   loc_53CF6
                cmpi.w  #$720,(Camera_Y_pos).w
                bhs.s   loc_53D2C
                cmpi.w  #$1000,(Camera_X_pos).w
                bhs.s   loc_53CF6
                cmpi.w  #$580,(Camera_Y_pos).w
                bhs.s   loc_53D2C

loc_53CF6:
                clr.w   (Events_bg+$16).w               ; Outdoors
                cmpi.w  #$720,(Camera_X_pos).w
                bhs.s   loc_53D0A
                jsr     (ICZ2_SetICZ1Pal).l
                bra.s   loc_53D10
; ---------------------------------------------------------------------------

loc_53D0A:
                jsr     (ICZ2_SetOutdoorsPal).l

loc_53D10:
                jsr     (ICZ2_OutDeform).l
                moveq   #0,d0
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                lea     (ICZ2_OutBGDeformArray).l,a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

loc_53D2C:
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
                bhs.s   loc_53D96
                bra.w   loc_53DFC
; ---------------------------------------------------------------------------

ICZ2BGE_Normal:
                tst.w   (Events_bg+$16).w
                bne.s   loc_53DD8
                move.w  (Camera_X_pos).w,d0             ; If outdoors
                cmpi.w  #$1000,d0
                blo.s   loc_53DC4
                cmpi.w  #$3600,d0
                bhs.s   loc_53DC4
                cmpi.w  #$720,(Camera_Y_pos).w
                blo.s   loc_53DC4

loc_53D96:
                st      (Events_bg+$16).w               ; Set to go indoors
                jsr     (ICZ2_SetIndoorsPal).l
                jsr     (ICZ2_InDeform).l
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.w   loc_53E84
; ---------------------------------------------------------------------------

loc_53DC4:
                jsr     (ICZ2_OutDeform).l              ; No trigger, run normal deformation

loc_53DCA:
                lea     (ICZ2_OutBGDeformArray).l,a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

loc_53DD8:
                move.w  (Camera_X_pos).w,d0             ; If indoors
                cmpi.w  #$1900,d0
                blo.s   loc_53DE8
                cmpi.w  #$1B80,d0
                blo.s   loc_53E38

loc_53DE8:
                cmpi.w  #$1000,d0
                blo.s   loc_53E38
                cmpi.w  #$3600,d0
                bhs.s   loc_53E38
                cmpi.w  #$720,(Camera_Y_pos).w
                bhs.s   loc_53E38

loc_53DFC:
                clr.w   (Events_bg+$16).w
                cmpi.w  #$720,(Camera_X_pos).w
                bhs.s   loc_53E10
                jsr     (ICZ2_SetICZ1Pal).l
                bra.s   loc_53E16
; ---------------------------------------------------------------------------

loc_53E10:
                jsr     (ICZ2_SetOutdoorsPal).l

loc_53E16:
                jsr     (ICZ2_OutDeform).l
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_53E68
; ---------------------------------------------------------------------------

loc_53E38:
                jsr     (ICZ2_InDeform).l

loc_53E3E:
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
                bne.s   loc_53E7E
                jsr     (ICZ2_OutDeform).l

loc_53E68:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.w   loc_53DCA
                subq.w  #4,(Events_routine_bg).w
                bra.w   loc_53DCA
; ---------------------------------------------------------------------------

loc_53E7E:
                jsr     (ICZ2_InDeform).l

loc_53E84:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   loc_53E3E
                subq.w  #4,(Events_routine_bg).w
                bra.s   loc_53E3E
; End of function ICZ2_ScreenInit
