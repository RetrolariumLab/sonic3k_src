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
                beq.s   S3CNZ2Screen_DrawForeground
                clr.w   (Events_bg+$06).w
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

S3CNZ2Screen_DrawForeground:
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
                bra.w   S3CNZ2Screen_BeginBackgroundRedraw
; ---------------------------------------------------------------------------
                bra.w   S3CNZ2Screen_DeformBeforeRedrawStep
; ---------------------------------------------------------------------------
                bra.w   S3CNZ2Screen_DeformNormalBackground
; ---------------------------------------------------------------------------

S3CNZ2Screen_BeginBackgroundRedraw:
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
                bra.s   S3CNZ2Screen_StepBackgroundRedraw
; ---------------------------------------------------------------------------

S3CNZ2Screen_DeformBeforeRedrawStep:
                jsr     CNZ1_Deform(pc)

S3CNZ2Screen_StepBackgroundRedraw:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                bpl.s   S3CNZ2Screen_DrawAndShakeBackground
                addq.w  #4,(Events_routine_bg).w
                bra.s   S3CNZ2Screen_DrawAndShakeBackground
; ---------------------------------------------------------------------------

S3CNZ2Screen_DeformNormalBackground:
                jsr     CNZ1_Deform(pc)

S3CNZ2Screen_DrawAndShakeBackground:
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
