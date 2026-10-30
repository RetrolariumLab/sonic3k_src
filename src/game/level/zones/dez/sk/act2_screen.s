; Owner: game/level/zones/dez/sk
; Responsibility: Death Egg act-two screen and background initialization and event control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

DEZ2_ScreenInit:
                move.w  #4,(Events_routine_fg).w
                jsr     (Reset_TileOffsetPositionActual).l
                jmp     (Refresh_PlaneFull).l
; ---------------------------------------------------------------------------

DEZ2_ScreenEvent:
                move.w  (Events_routine_fg).w,d0
                jmp     DEZ2_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

DEZ2_ScreenEvent_Index:
                bra.w   loc_594B4
; ---------------------------------------------------------------------------
                bra.w   loc_594DA
; ---------------------------------------------------------------------------
                bra.w   loc_594F8
; ---------------------------------------------------------------------------

loc_594B4:
                tst.w   (Events_fg_4).w
                beq.s   loc_594F8
                clr.w   (Events_fg_4).w
                movea.w $38(a3),a1
                addq.w  #1,a1
                move.b  #$D7,(a1)+
                move.b  #$DC,(a1)+
                move.b  #$D7,(a1)
                addq.w  #4,(Events_routine_fg).w
                jmp     (Refresh_PlaneScreenDirect).l
; ---------------------------------------------------------------------------

loc_594DA:
                tst.w   (Events_fg_4).w
                beq.s   loc_594F8
                clr.w   (Events_fg_4).w
                movea.w $18(a3),a1
                move.b  #$BC,$6B(a1)
                addq.w  #4,(Events_routine_fg).w
                jmp     (Refresh_PlaneScreenDirect).l
; ---------------------------------------------------------------------------

loc_594F8:
                jmp     (DrawTilesAsYouMove).l
; ---------------------------------------------------------------------------

DEZ2_BackgroundInit:
                move.w  #8,(Events_routine_bg).w
                clr.w   (Camera_X_pos_BG_copy).w
                clr.w   (Camera_Y_pos_BG_copy).w
                jsr     (Reset_TileOffsetPositionEff).l
                jsr     (Refresh_PlaneFull).l
                jmp     (PlainDeformation).l
; ---------------------------------------------------------------------------

DEZ2_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     DEZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

DEZ2_BackgroundEvent_Index:
                bra.w   loc_59532
; ---------------------------------------------------------------------------
                bra.w   loc_59556
; ---------------------------------------------------------------------------
                bra.w   loc_59566
; ---------------------------------------------------------------------------

loc_59532:
                clr.w   (Camera_X_pos_BG_copy).w
                clr.w   (Camera_Y_pos_BG_copy).w
                jsr     (Reset_TileOffsetPositionEff).l
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w

loc_59556:
                moveq   #0,d1
                moveq   #0,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.s   loc_59566
                addq.w  #4,(Events_routine_bg).w

loc_59566:
                jmp     (PlainDeformation).l
; End of function DEZ2_ScreenInit
