; Owner: game/level/zones/cnz/s3
; Responsibility: Carnival Night act-two screen initialization, background setup and event control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CNZ2_ScreenInit:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

CNZ2_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                tst.w   (Events_bg+$06).w
                beq.s   loc_3DA50
                clr.w   (Events_bg+$06).w
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

loc_3DA50:
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

CNZ2_BackgroundInit:
                move.w  #8,(Events_routine_bg).w
                jsr     CNZ1_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                lea     CNZ1_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

CNZ2_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     CNZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

CNZ2_BackgroundEvent_Index:
                bra.w   loc_3DA88
; ---------------------------------------------------------------------------
                bra.w   loc_3DAB6
; ---------------------------------------------------------------------------
                bra.w   loc_3DACC
; ---------------------------------------------------------------------------

loc_3DA88:
                moveq   #0,d1
                move.w  #$200,d2
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                bpl.w   PlainDeformation
                jsr     CNZ1_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3DABA
; ---------------------------------------------------------------------------

loc_3DAB6:
                jsr     CNZ1_Deform(pc)

loc_3DABA:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                bpl.s   loc_3DAD0
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3DAD0
; ---------------------------------------------------------------------------

loc_3DACC:
                jsr     CNZ1_Deform(pc)

loc_3DAD0:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     CNZ1_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jsr     ApplyDeformation(pc)
                jmp     ShakeScreen_Setup(pc)
; End of function CNZ2_ScreenInit
