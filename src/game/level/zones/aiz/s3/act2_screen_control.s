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
                bpl.w   loc_3B368
                move.w  #$4020,d0
                move.w  d0,(HScroll_table+$1F6).w
                move.w  d0,(_unkEE98).w
                clr.w   (_unkEE98+2).w                  ; Set up secondary BG camera X
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$8F0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(_unkEE9C).w
                move.w  d0,(_unkEEA2).w                 ; Set up secondary BG camera Y
                jsr     (AllocateObject).l
                bne.s   loc_3B332
                move.l  #Obj_AIZBattleship,(a1)         ; Start battleship sequence

loc_3B332:
                st      (Events_bg+$04).w
                move.l  #HInt7,(H_int_addr).w           ; HInt is needed to change Y scroll value to proper amount mid-draw
                clr.b   (Water_flag).w
                move.b  #$40,(H_int_counter).w          ; Set HInt position
                addq.w  #4,(Events_routine_fg).w

AIZ2SE_ShipDraw:
                tst.w   (Events_fg_4).w
                bne.s   loc_3B380                       ; Branch when battleship has gone off-screen
                lea     AIZ2SE_BGShipDrawArray2(pc),a4
                lea     (HScroll_table+$1F4).w,a6
                move.w  (_unkEE98).w,(a6)
                moveq   #2,d5
                move.w  (_unkEEA2).w,d6
                jsr     Draw_BGNoVert(pc)

loc_3B368:
                lea     AIZ2SE_BGShipDrawArray1(pc),a4
                lea     (HScroll_table+$1F8).w,a6
                move.w  (Camera_X_pos_copy).w,4(a6)
                moveq   #2,d5
                move.w  (Camera_Y_pos_rounded).w,d6
                jmp     Draw_BGNoVert(pc)
; ---------------------------------------------------------------------------

loc_3B380:
                clr.w   (Events_fg_4).w
                move.w  #$170,(Draw_delayed_position).w
                move.w  #4,(Draw_delayed_rowcount).w    ; Set redraw memory
                addq.w  #4,(Events_routine_fg).w

AIZ2SE_EndRefresh:
                move.w  #$4380,d1
                move.w  (Camera_Y_pos_copy).w,d2
                subi.w  #$10,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   loc_3B368
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
                blo.s   loc_3B418
                move.w  #$14,(Events_routine_bg).w
                move.w  #$4440,(Events_bg+$02).w

loc_3B418:
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
                bmi.s   loc_3B480
                jsr     AIZ1_FireRise(pc)
                jsr     AIZTrans_WavyFlame(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

loc_3B480:
                addq.w  #2,a3
                move.w  #VRAM_Plane_B_Name_Table,d7
                clr.w   (Events_bg+$00).w
                addq.w  #4,(Events_routine_bg).w

AIZ2BGE_WaitFire:
                jsr     AIZ1_FireRise(pc)
                jsr     AIZTrans_WavyFlame(pc)
                tst.w   (Events_bg+$00).w
                bne.s   loc_3B4CC
                move.w  (Camera_Y_pos_BG_copy).w,d0
                andi.w  #$7F,d0
                cmpi.w  #$20,d0
                blo.s   loc_3B4B0
                cmpi.w  #$30,d0
                blo.s   loc_3B4B4

loc_3B4B0:
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

loc_3B4B4:
                addi.w  #$180,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                and.w   (Camera_Y_pos_mask).w,d0
                subi.w  #$10,d0
                move.w  d0,(Camera_Y_pos_BG_rounded).w
                st      (Events_bg+$00).w

loc_3B4CC:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                move.w  #$200,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                cmpi.w  #$310,(Camera_Y_pos_BG_copy).w
                blo.s   loc_3B544                       ; If fire hasn't subsided, branch
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
                bra.s   loc_3B56E
; ---------------------------------------------------------------------------

loc_3B544:
                jsr     AIZ2_ApplyDeform(pc)
                lea     (H_scroll_buffer+2).w,a1
                move.w  (Camera_X_pos_BG_copy).w,d0     ; Cancel out background deformation since we're still in the open field
                neg.w   d0
                moveq   #bytesToLcnt(224),d1

loc_3B554:
                move.w  d0,(a1)
                addq.w  #4,a1
                move.w  d0,(a1)
                addq.w  #4,a1
                move.w  d0,(a1)
                addq.w  #4,a1
                move.w  d0,(a1)
                addq.w  #4,a1
                dbf     d1,loc_3B554
                rts
; ---------------------------------------------------------------------------

AIZ2BGE_BGRedraw:
                jsr     AIZ2_Deform(pc)

loc_3B56E:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   loc_3B5C8
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3B5C8
; ---------------------------------------------------------------------------

AIZ2BGE_Normal:
                jsr     AIZ2_Deform(pc)
                tst.w   (Events_fg_5).w
                beq.s   loc_3B5C8
                clr.w   (Events_fg_5).w
                move.w  #$A8,d0
                cmpi.w  #$400,(Camera_Y_pos_copy).w
                blo.s   loc_3B59E
                move.w  #-$198,d0

loc_3B59E:
                move.w  d0,(Events_bg+$16).w
                add.w   d0,(Camera_Y_pos_BG_copy).w
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                move.w  #$4440,(Events_bg+$02).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3B5E4
; ---------------------------------------------------------------------------

loc_3B5C8:
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

loc_3B5E4:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   loc_3B5FA
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3B5FA
; ---------------------------------------------------------------------------

AIZ2BGE_ShipMove:
                jsr     AIZ2_Deform(pc)

loc_3B5FA:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                jsr     AIZ2_ApplyDeform(pc)
                tst.w   (Events_bg+$04).w
                beq.s   loc_3B622
                move.w  (_unkEE9C).w,(V_scroll_value).w  ; Use effective camera position rather than actual camera position
                move.w  (Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
                addq.w  #4,sp                           ; Skip last part of ScreenEvents

loc_3B622:
                jmp     ShakeScreen_Setup(pc)
