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
                bra.w   SKDEZ2Events_TryApplyFirstLayoutPatch
; ---------------------------------------------------------------------------
                bra.w   SKDEZ2Events_TryApplySecondLayoutPatch
; ---------------------------------------------------------------------------
                bra.w   SKDEZ2Events_DrawForeground
; ---------------------------------------------------------------------------

SKDEZ2Events_TryApplyFirstLayoutPatch:
                tst.w   (Events_fg_4).w
                beq.s   SKDEZ2Events_DrawForeground
                clr.w   (Events_fg_4).w
                movea.w $38(a3),a1
                addq.w  #1,a1
                move.b  #$D7,(a1)+
                move.b  #$DC,(a1)+
                move.b  #$D7,(a1)
                addq.w  #4,(Events_routine_fg).w
                jmp     (Refresh_PlaneScreenDirect).l
; ---------------------------------------------------------------------------

SKDEZ2Events_TryApplySecondLayoutPatch:
                tst.w   (Events_fg_4).w
                beq.s   SKDEZ2Events_DrawForeground
                clr.w   (Events_fg_4).w
                movea.w $18(a3),a1
                move.b  #$BC,$6B(a1)
                addq.w  #4,(Events_routine_fg).w
                jmp     (Refresh_PlaneScreenDirect).l
; ---------------------------------------------------------------------------

SKDEZ2Events_DrawForeground:
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
                bra.w   SKDEZ2Events_BeginStaticBackgroundRedraw
; ---------------------------------------------------------------------------
                bra.w   SKDEZ2Events_RedrawBackgroundBottomUp
; ---------------------------------------------------------------------------
                bra.w   SKDEZ2Events_ApplyStaticPlainScroll
; ---------------------------------------------------------------------------

SKDEZ2Events_BeginStaticBackgroundRedraw:
                clr.w   (Camera_X_pos_BG_copy).w
                clr.w   (Camera_Y_pos_BG_copy).w
                jsr     (Reset_TileOffsetPositionEff).l
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w

SKDEZ2Events_RedrawBackgroundBottomUp:
                moveq   #0,d1
                moveq   #0,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.s   SKDEZ2Events_ApplyStaticPlainScroll
                addq.w  #4,(Events_routine_bg).w

SKDEZ2Events_ApplyStaticPlainScroll:
                jmp     (PlainDeformation).l
; End of function DEZ2_ScreenInit
