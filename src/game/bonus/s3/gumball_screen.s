; Owner: game/bonus/s3
; Responsibility: Gumball bonus screen setup, vertical scroll, background events and deformation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Gumball_ScreenInit:
                move.w  #$3FF,(Screen_Y_wrap_value).w
                move.w  #$3F0,(Camera_Y_pos_mask).w
                move.w  #$1C,(Layout_row_index_mask).w
                move.w  #4,(Special_V_int_routine).w
                move.w  #$C0,d0
                move.w  d0,d1
                jsr     Gumball_VScroll(pc)
                jsr     Reset_TileOffsetPositionActual(pc)
                move.w  d2,(HScroll_table+$002).w
                move.w  d2,(HScroll_table+$00A).w
                move.w  (HScroll_table+$00E).w,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(HScroll_table+$006).w
                lea     Gumball_VScrollArray(pc),a4
                lea     (HScroll_table).w,a5
                move.w  (Camera_X_pos_rounded).w,d0
                jmp     Refresh_PlaneDirectVScroll(pc)
; ---------------------------------------------------------------------------

Gumball_ScreenEvent:
                jsr     Gumball_SetUpVScroll(pc)
                lea     Gumball_VScrollArray(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$F,d6
                moveq   #3,d5
                jmp     DrawTilesVDeform(pc)

; =============== S U B R O U T I N E =======================================

Gumball_SetUpVScroll:
                move.w  (Camera_Y_pos_copy).w,d0
                movea.w (SceneControllerObjectAddress).w,a5
                move.w  $14(a5),d1
                subi.w  #$C8,d1
                sub.w   d0,d1
                neg.w   d1

Gumball_VScroll:
                lea     (HScroll_table).w,a1
                move.w  d0,(a1)
                move.w  d0,8(a1)
                move.w  d0,$C(a1)
                move.w  d0,$10(a1)
                move.w  d1,4(a1)
                move.w  d1,$E(a1)
                rts
; End of function Gumball_SetUpVScroll

; ---------------------------------------------------------------------------
Gumball_VScrollArray:
                dc.w    $C0, $80, $7FFF
; ---------------------------------------------------------------------------

Gumball_BackgroundInit:
                jsr     Gumball_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

Gumball_BackgroundEvent:
                jsr     Gumball_Deform(pc)
                jsr     PlainDeformation(pc)
                lea     Gumball_VScrollArray(pc),a4
                lea     (HScroll_table+$00A).w,a5
                jmp     Apply_FGVScroll(pc)

; =============== S U B R O U T I N E =======================================

Gumball_Deform:
                move.w  #$FFE0,(Camera_X_pos_BG_copy).w
                move.w  (Camera_Y_pos_copy).w,d0
                asr.w   #1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                asr.w   #1,d0
                move.w  d0,(Events_bg+$10).w
                rts
; End of function Gumball_Deform
