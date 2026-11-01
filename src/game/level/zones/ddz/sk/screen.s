; Owner: game/level/zones/ddz/sk
; Responsibility: Doomsday screen and background initialization, progression events and private state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

DDZ_ScreenInit:
                jsr     (AllocateObject).l
                bne.s   loc_5957A
                move.l  #loc_81492,(a1)

loc_5957A:
                clr.w   (_unkEE98).w
                clr.w   (_unkEEA0).w
                clr.w   (_unkEE9C).w
                clr.w   (_unkEEA2).w
                moveq   #0,d1
                moveq   #0,d0
                jmp     (Refresh_PlaneFull).l
; ---------------------------------------------------------------------------

DDZ_ScreenEvent:
                jsr     ComputeDdzBossRelativePlaneScroll(pc)
                move.w  (Events_routine_fg).w,d4
                jmp     DDZ_ScreenEvent_Index(pc,d4.w)
; ---------------------------------------------------------------------------

DDZ_ScreenEvent_Index:
                bra.w   loc_595B0
; ---------------------------------------------------------------------------
                bra.w   loc_595C0
; ---------------------------------------------------------------------------
                bra.w   loc_595EE
; ---------------------------------------------------------------------------
                bra.w   loc_59602
; ---------------------------------------------------------------------------

loc_595B0:
                tst.w   (Events_bg+$00).w
                beq.w   locret_59646
                jsr     ResetDdzBossPlaneTileDrawAnchors(pc)
                addq.w  #4,(Events_routine_fg).w

loc_595C0:
                cmpi.w  #$200,(Events_bg+$00).w
                bne.s   loc_595D6
                cmpi.w  #$400,d0
                bhs.s   RestorePreviousDdzBossPlaneScroll
                cmpi.w  #$220,d1
                bhs.s   RestorePreviousDdzBossPlaneScroll
                bra.s   loc_5961E
; ---------------------------------------------------------------------------

loc_595D6:
                jsr     ResetDdzBossPlaneTileDrawAnchors(pc)
                bsr.s   RestorePreviousDdzBossPlaneScroll
                move.w  #$F0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_fg).w
                bra.s   loc_595F0
; ---------------------------------------------------------------------------

loc_595EE:
                bsr.s   RestorePreviousDdzBossPlaneScroll

loc_595F0:
                moveq   #0,d1
                moveq   #0,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.s   locret_59646
                addq.w  #4,(Events_routine_fg).w
                bra.s   locret_59646
; ---------------------------------------------------------------------------

loc_59602:
                cmpi.w  #$400,d0
                blo.s   RestorePreviousDdzBossPlaneScroll
                cmpi.w  #$800,d0
                bhs.s   RestorePreviousDdzBossPlaneScroll
                cmpi.w  #$220,d1
                blo.s   loc_5961E

; =============== S U B R O U T I N E =======================================

RestorePreviousDdzBossPlaneScroll:
                move.w  d2,(_unkEE98).w
                move.w  d3,(_unkEE9C).w
                bra.s   locret_59646
; ---------------------------------------------------------------------------

loc_5961E:
                lea     (_unkEE98).w,a6
                lea     (_unkEEA0).w,a5
                move.w  (_unkEE9C).w,d1
                moveq   #$F,d6
                jsr     (Draw_TileColumn).l
                lea     (_unkEE9C).w,a6
                lea     (_unkEEA2).w,a5
                move.w  (_unkEE98).w,d1
                moveq   #$15,d6
                jmp     (Draw_TileRow).l
; ---------------------------------------------------------------------------

locret_59646:
                rts
; End of function RestorePreviousDdzBossPlaneScroll

; =============== S U B R O U T I N E =======================================

ComputeDdzBossRelativePlaneScroll:
                move.w  (_unkEE98).w,d2
                move.w  (_unkEE9C).w,d3
                move.w  (Camera_X_pos_copy).w,d0
                sub.w   (Events_bg+$02).w,d0
                add.w   (Events_bg+$00).w,d0
                move.w  d0,(_unkEE98).w
                move.w  (Camera_Y_pos_copy).w,d1
                sub.w   (Events_bg+$04).w,d1
                addi.w  #$100,d1
                move.w  d1,(_unkEE9C).w
                rts
; End of function ComputeDdzBossRelativePlaneScroll

; =============== S U B R O U T I N E =======================================

ResetDdzBossPlaneTileDrawAnchors:
                move.w  (_unkEE98).w,d5
                move.w  d5,d4
                andi.w  #$FFF0,d5
                move.w  d5,(_unkEEA0).w
                move.w  (_unkEE9C).w,d5
                and.w   (Camera_Y_pos_mask).w,d5
                move.w  d5,(_unkEEA2).w
                rts
; End of function ResetDdzBossPlaneTileDrawAnchors

; ---------------------------------------------------------------------------

DDZ_BackgroundInit:
                clr.w   (HScroll_table).w
                jsr     BuildDdzBackgroundParallaxBands(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                moveq   #0,d1
                jsr     (Refresh_PlaneFull).l
                bra.s   loc_596BC
; ---------------------------------------------------------------------------

DDZ_BackgroundEvent:
                jsr     BuildDdzBackgroundParallaxBands(pc)
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     (Draw_TileRow).l

loc_596BC:
                lea     DDZ_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                lea     (H_scroll_buffer).w,a1
                move.w  (_unkEE98).w,d3
                move.w  (Camera_Y_pos_BG_copy).w,d0
                move.w  #$E0-1,d1
                jsr     (ApplyDeformation2).l
                move.w  (_unkEE9C).w,(V_scroll_value).w
                move.w  (Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
                addq.w  #4,sp
                rts

; =============== S U B R O U T I N E =======================================

BuildDdzBackgroundParallaxBands:
                move.w  (Camera_Y_pos_copy).w,d0
                asr.w   #1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Events_bg+$06).w,d0
                swap    d0
                clr.w   d0
                asr.l   #4,d0
                move.l  d0,d1
                asr.l   #3,d1
                moveq   #5,d2
                lea     (HScroll_table+$00E).w,a1

loc_59708:
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                sub.l   d1,d0
                dbf     d2,loc_59708
                rts
; End of function BuildDdzBackgroundParallaxBands

; ---------------------------------------------------------------------------
DDZ_BGDeformArray:
                dc.w    $B0,   $10,     8,     8,   $18,   $38, $7FFF
