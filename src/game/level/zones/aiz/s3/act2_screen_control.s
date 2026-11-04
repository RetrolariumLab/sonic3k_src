; Owner: game/level/zones/aiz/s3
; Responsibility: Angel Island act-two screen initialization, background setup and event control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AIZ2_ScreenInit:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

AIZ2_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                move.w  (Events_routine_fg).w,d0
                jmp     AIZ2_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

AIZ2_ScreenEvent_Index:
                bra.w   AIZ2SE_Normal
; ---------------------------------------------------------------------------
                bra.w   AIZ2SE_ShipRefresh
; ---------------------------------------------------------------------------
                bra.w   AIZ2SE_ShipDraw
; ---------------------------------------------------------------------------
                bra.w   AIZ2SE_EndRefresh
; ---------------------------------------------------------------------------
                bra.w   AIZ2SE_End
; ---------------------------------------------------------------------------

AIZ2SE_Normal:
                tst.w   (Events_fg_4).w
                beq.w   DrawTilesAsYouMove              ; Keep drawing as usual while flag isn't set
                clr.w   (Events_fg_4).w
                move.w  #$180,(Draw_delayed_position).w  ; Set up redraw memory
                move.w  #5,(Draw_delayed_rowcount).w
                clr.l   (HScroll_table+$1F8).w
                move.w  (Camera_X_pos_copy).w,d0
                andi.w  #$FFF0,d0
                subi.w  #$10,d0
                move.w  d0,(HScroll_table+$1FE).w
                move.b  #1,(Scroll_lock).w              ; Camera doesn't follow Sonic
                move.w  #4,(Special_events_routine).w
                addq.w  #4,(Events_routine_fg).w        ; Set speed of automatic movement

AIZ2SE_ShipRefresh:
                move.w  #$4380,d1
                move.w  (Camera_Y_pos_copy).w,d2
                subi.w  #$10,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.w   S3AIZ2Screen_DrawShipForegroundStrip
                move.w  #$4020,d0
                move.w  d0,(HScroll_table+$1F6).w
                move.w  d0,(SceneAuxiliaryXOrCompetitionTime).w
                clr.w   (SceneAuxiliaryXOrCompetitionTime+2).w  ; Set up secondary BG camera X
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$8F0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(SceneAuxiliaryYOrVerticalMotion).w
                move.w  d0,(SceneRowAnchorOrCompetitionWinCounts).w  ; Set up secondary BG camera Y
                jsr     (AllocateObject).l
                bne.s   S3AIZ2Screen_BeginShipForeground
                move.l  #Obj_AIZBattleship,(a1)         ; Start battleship sequence

; Advance the foreground state even if the ship object was not allocated
S3AIZ2Screen_BeginShipForeground:
                st      (Events_bg+$04).w
                move.l  #HInt7,(H_int_addr).w           ; HInt is needed to change Y scroll value to proper amount mid-draw
                clr.b   (Water_flag).w
                move.b  #$40,(H_int_counter).w          ; Set HInt position
                addq.w  #4,(Events_routine_fg).w

AIZ2SE_ShipDraw:
                tst.w   (Events_fg_4).w
                bne.s   S3AIZ2Screen_BeginShipExitRefresh  ; Branch when battleship has gone off-screen
                lea     AIZ2SE_BGShipDrawArray2(pc),a4
                lea     (HScroll_table+$1F4).w,a6
                move.w  (SceneAuxiliaryXOrCompetitionTime).w,(a6)
                moveq   #2,d5
                move.w  (SceneRowAnchorOrCompetitionWinCounts).w,d6
                jsr     Draw_BGNoVert(pc)

S3AIZ2Screen_DrawShipForegroundStrip:
                lea     AIZ2SE_BGShipDrawArray1(pc),a4
                lea     (HScroll_table+$1F8).w,a6
                move.w  (Camera_X_pos_copy).w,4(a6)
                moveq   #2,d5
                move.w  (Camera_Y_pos_rounded).w,d6
                jmp     Draw_BGNoVert(pc)
; ---------------------------------------------------------------------------

S3AIZ2Screen_BeginShipExitRefresh:
                clr.w   (Events_fg_4).w
                move.w  #$170,(Draw_delayed_position).w
                move.w  #4,(Draw_delayed_rowcount).w    ; Set redraw memory
                addq.w  #4,(Events_routine_fg).w

AIZ2SE_EndRefresh:
                move.w  #$4380,d1
                move.w  (Camera_Y_pos_copy).w,d2
                subi.w  #$10,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   S3AIZ2Screen_DrawShipForegroundStrip
                move.w  (Camera_X_pos_copy).w,d0
                andi.w  #$FFF0,d0
                subi.w  #$10,d0
                move.w  d0,(Camera_X_pos_rounded).w
                move.w  #$46C0,(Events_bg+$02).w        ; Set level X start to 46C0
                clr.w   (Events_bg+$04).w
                move.b  #-1,(H_int_counter).w
                addq.w  #4,(Events_routine_fg).w

AIZ2SE_End:
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

HInt7:
                move.w  #$8AFF,(VDP_control_port).l
                move.l  #vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
                move.w  (Camera_Y_pos_copy).w,(VDP_data_port).l
                rte
; ---------------------------------------------------------------------------
AIZ2SE_BGShipDrawArray1:
                dc.w    $180
                dc.w    $7FFF
AIZ2SE_BGShipDrawArray2:
                dc.w    $A80
                dc.w    $7FFF
; ---------------------------------------------------------------------------

AIZ2_BackgroundInit:
                move.w  (Camera_X_pos_copy).w,(Events_fg_0).w
                move.w  (Camera_X_pos_copy).w,(Events_fg_1).w
                move.w  #$C,(Events_routine_bg).w
                cmpi.w  #$3E80,(Camera_X_pos_copy).w
                blo.s   S3AIZ2Screen_InitBgPlaneAndDeform
                move.w  #$14,(Events_routine_bg).w
                move.w  #$4440,(Events_bg+$02).w

S3AIZ2Screen_InitBgPlaneAndDeform:
                jsr     AIZ2_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                jmp     AIZ2_ApplyDeform(pc)
; ---------------------------------------------------------------------------

AIZ2_BackgroundEvent:
                lea     (Events_fg_0).w,a1
                move.w  (Camera_X_pos_copy).w,d0
                move.w  #$100,d2
                move.w  #$200,d3
                jsr     Adjust_BGDuringLoop(pc)
                move.w  (Events_routine_bg).w,d0
                jmp     AIZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

AIZ2_BackgroundEvent_Index:
                bra.w   AIZ2BGE_FireRedraw
; ---------------------------------------------------------------------------
                bra.w   AIZ2BGE_WaitFire
; ---------------------------------------------------------------------------
                bra.w   AIZ2BGE_BGRedraw
; ---------------------------------------------------------------------------
                bra.w   AIZ2BGE_Normal
; ---------------------------------------------------------------------------
                bra.w   AIZ2BGE_ShipRefresh
; ---------------------------------------------------------------------------
                bra.w   AIZ2BGE_ShipMove
; ---------------------------------------------------------------------------

AIZ2BGE_FireRedraw:
                lea     (Level_layout_main).w,a3
                move.w  #VRAM_Plane_A_Name_Table,d7
                move.w  (Camera_X_pos_copy).w,d1
                move.w  (Camera_Y_pos_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bmi.s   S3AIZ2Screen_BeginFireAlignWait
                jsr     AIZ1_FireRise(pc)
                jsr     AIZTrans_WavyFlame(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

S3AIZ2Screen_BeginFireAlignWait:
                addq.w  #2,a3
                move.w  #VRAM_Plane_B_Name_Table,d7
                clr.w   (Events_bg+$00).w
                addq.w  #4,(Events_routine_bg).w

AIZ2BGE_WaitFire:
                jsr     AIZ1_FireRise(pc)
                jsr     AIZTrans_WavyFlame(pc)
                tst.w   (Events_bg+$00).w
                bne.s   S3AIZ2Screen_DrawFireRowsAndTryRestore
                move.w  (Camera_Y_pos_BG_copy).w,d0
                andi.w  #$7F,d0
                cmpi.w  #$20,d0
                blo.s   S3AIZ2Screen_UsePlainFireDeform
                cmpi.w  #$30,d0
                blo.s   S3AIZ2Screen_SetFireBgAlignment

S3AIZ2Screen_UsePlainFireDeform:
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

S3AIZ2Screen_SetFireBgAlignment:
                addi.w  #$180,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                and.w   (Camera_Y_pos_mask).w,d0
                subi.w  #$10,d0
                move.w  d0,(Camera_Y_pos_BG_rounded).w
                st      (Events_bg+$00).w

S3AIZ2Screen_DrawFireRowsAndTryRestore:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                move.w  #$200,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                cmpi.w  #$310,(Camera_Y_pos_BG_copy).w
                blo.s   S3AIZ2Screen_ApplyWavesAndFlattenBg  ; If fire hasn't subsided, branch
                movem.l d7-a0/a2-a3,-(sp)
                moveq   #PLCID_0C,d0
                jsr     (Load_PLC).l
                jsr     (LoadEnemyArt).l
                movem.l (sp)+,d7-a0/a2-a3
                lea     (Normal_palette_line_4+$2).w,a1
                move.l  #$8EE00AA,(a1)+
                move.l  #$8E004E,(a1)+
                move.l  #$2E000C,(a1)
                move.w  #$6000,d0
                move.w  d0,(Camera_max_X_pos).w
                move.w  d0,(Camera_target_max_X_pos).w
                jsr     AIZ2_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w    ; Set up Effective BG Y location for screen redraw
                move.w  #$F,(Draw_delayed_rowcount).w   ; Set up redraw count
                move.w  #$C,(Special_V_int_routine).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   S3AIZ2Screen_RefreshBgAndDraw
; ---------------------------------------------------------------------------

S3AIZ2Screen_ApplyWavesAndFlattenBg:
                jsr     AIZ2_ApplyDeform(pc)
                lea     (H_scroll_buffer+2).w,a1
                move.w  (Camera_X_pos_BG_copy).w,d0     ; Cancel out background deformation since we're still in the open field
                neg.w   d0
                moveq   #bytesToLcnt(224),d1

S3AIZ2Screen_FillFlatBgScroll:
                move.w  d0,(a1)
                addq.w  #4,a1
                move.w  d0,(a1)
                addq.w  #4,a1
                move.w  d0,(a1)
                addq.w  #4,a1
                move.w  d0,(a1)
                addq.w  #4,a1
                dbf     d1,S3AIZ2Screen_FillFlatBgScroll
                rts
; ---------------------------------------------------------------------------

AIZ2BGE_BGRedraw:
                jsr     AIZ2_Deform(pc)

S3AIZ2Screen_RefreshBgAndDraw:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   S3AIZ2Screen_DrawNormalBgAndShake
                addq.w  #4,(Events_routine_bg).w
                bra.s   S3AIZ2Screen_DrawNormalBgAndShake
; ---------------------------------------------------------------------------

AIZ2BGE_Normal:
                jsr     AIZ2_Deform(pc)
                tst.w   (Events_fg_5).w
                beq.s   S3AIZ2Screen_DrawNormalBgAndShake
                clr.w   (Events_fg_5).w
                move.w  #$A8,d0
                cmpi.w  #$400,(Camera_Y_pos_copy).w
                blo.s   S3AIZ2Screen_SetShipBgYAndRefresh
                move.w  #-$198,d0

S3AIZ2Screen_SetShipBgYAndRefresh:
                move.w  d0,(Events_bg+$16).w
                add.w   d0,(Camera_Y_pos_BG_copy).w
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                move.w  #$4440,(Events_bg+$02).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   S3AIZ2Screen_RefreshShipBgAndDraw
; ---------------------------------------------------------------------------

S3AIZ2Screen_DrawNormalBgAndShake:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                jsr     AIZ2_ApplyDeform(pc)
                jmp     ShakeScreen_Setup(pc)
; ---------------------------------------------------------------------------

AIZ2BGE_ShipRefresh:
                jsr     AIZ2_Deform(pc)

S3AIZ2Screen_RefreshShipBgAndDraw:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   S3AIZ2Screen_DrawShipBg
                addq.w  #4,(Events_routine_bg).w
                bra.s   S3AIZ2Screen_DrawShipBg
; ---------------------------------------------------------------------------

AIZ2BGE_ShipMove:
                jsr     AIZ2_Deform(pc)

; Skip the remaining ScreenEvents work when the effective ship camera supplies vertical scroll
S3AIZ2Screen_DrawShipBg:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                jsr     AIZ2_ApplyDeform(pc)
                tst.w   (Events_bg+$04).w
                beq.s   S3AIZ2Screen_ApplyScreenShake
                move.w  (SceneAuxiliaryYOrVerticalMotion).w,(V_scroll_value).w  ; Use effective camera position rather than actual camera position
                move.w  (Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
                addq.w  #4,sp                           ; Skip last part of ScreenEvents

S3AIZ2Screen_ApplyScreenShake:
                jmp     ShakeScreen_Setup(pc)
