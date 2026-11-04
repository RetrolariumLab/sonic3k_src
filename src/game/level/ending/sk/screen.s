; Owner: game/level/ending/sk
; Responsibility: Ending foreground screen initialization, event sequence and camera tracking
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Ending_ScreenInit:
                jsr     (AllocateObject).l
                bne.s   loc_5AAB0
                move.l  #Obj_5D86A,(a1)

loc_5AAB0:
                st      (Ending_running_flag).w
                st      (Scroll_lock).w
                move.b  #3,(Player_1+object_control).w
                move.l  #$2000000,d0
                move.l  d0,(Camera_X_pos).w
                move.l  d0,(Camera_X_pos_copy).w
                move.l  d0,(Camera_Y_pos).w
                move.l  d0,(Camera_Y_pos_copy).w
                clr.l   (_unkEE98).w
                clr.l   (_unkEE9C).w
                move.w  #$2B4,(Events_bg+$02).w
                jsr     SKEnding_LoadSkyColorsToTarget(pc)
                jsr     (Reset_TileOffsetPositionActual).l
                jmp     (Refresh_PlaneFull).l
; ---------------------------------------------------------------------------

Ending_ScreenEvent:
                move.w  (Events_routine_fg).w,d0
                jmp     Ending_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

Ending_ScreenEvent_Index:
                bra.w   loc_5AB36
; ---------------------------------------------------------------------------
                bra.w   loc_5AB58
; ---------------------------------------------------------------------------
                bra.w   loc_5AB6E
; ---------------------------------------------------------------------------
                bra.w   loc_5ABBC
; ---------------------------------------------------------------------------
                bra.w   loc_5AC70
; ---------------------------------------------------------------------------
                bra.w   loc_5ACFC
; ---------------------------------------------------------------------------
                bra.w   loc_5AD16
; ---------------------------------------------------------------------------
                bra.w   loc_5AD30
; ---------------------------------------------------------------------------
                bra.w   loc_5AD56
; ---------------------------------------------------------------------------
                bra.w   loc_5AD8E
; ---------------------------------------------------------------------------
                bra.w   loc_5AE0A
; ---------------------------------------------------------------------------
                bra.w   loc_5AE76
; ---------------------------------------------------------------------------
                bra.w   loc_5AE90
; ---------------------------------------------------------------------------
                bra.w   loc_5AEA8
; ---------------------------------------------------------------------------
                bra.w   loc_5AED4
; ---------------------------------------------------------------------------

loc_5AB36:
                tst.w   (Events_fg_4).w
                beq.w   loc_5AEE4
                clr.w   (Events_fg_4).w
                move.w  (_unkEE98).w,(Events_bg+$00).w
                jsr     SKEnding_PublishForegroundCamera(pc)
                jsr     (Reset_TileOffsetPositionActual).l
                addq.w  #4,(Events_routine_fg).w
                bra.s   loc_5AB62
; ---------------------------------------------------------------------------

loc_5AB58:
                tst.w   (Events_fg_4).w
                bne.s   loc_5AB66
                jsr     SKEnding_PublishForegroundCamera(pc)

loc_5AB62:
                bra.w   loc_5AEE4
; ---------------------------------------------------------------------------

loc_5AB66:
                clr.w   (Events_fg_4).w
                addq.w  #4,(Events_routine_fg).w

loc_5AB6E:
                jsr     SKEnding_PublishForegroundCamera(pc)
                cmpi.b  #7,(Chaos_emerald_count).w
                blo.s   loc_5AB96
                moveq   #0,d0
                move.w  (Events_bg+$06).w,d0
                addi.w  #$10,d0
                cmpi.w  #$8000,d0
                blo.s   loc_5AB8E
                move.w  #$8000,d0

loc_5AB8E:
                move.w  d0,(Events_bg+$06).w
                sub.l   d0,(Events_bg+$02).w

loc_5AB96:
                tst.w   (Events_fg_4).w
                beq.w   loc_5AEE4
                clr.w   (Events_fg_4).w
                move.w  #$40-1,(Palette_fade_info).w
                move.w  #$15,(Events_bg+$08).w
                st      (Palette_fade_timer).w
                st      (Palette_cycle_counters+$00).w
                addq.w  #4,(Events_routine_fg).w
                bra.s   loc_5ABC0
; ---------------------------------------------------------------------------

loc_5ABBC:
                jsr     SKEnding_PublishForegroundCamera(pc)

loc_5ABC0:
                move.l  a0,-(sp)
                jsr     (Pal_ToBlack).l
                movea.l (sp)+,a0
                subq.w  #1,(Events_bg+$08).w
                bpl.w   loc_5AEE4
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Player_2,(Kos_decomp_buffer-Player_2)-2
                cmpi.b  #7,(Super_emerald_count).w
                bhs.s   loc_5AC04
                move.w  #$24,(Events_routine_fg).w
                bra.w   loc_5ADC0
; ---------------------------------------------------------------------------

loc_5AC04:
                jsr     (AllocateObject).l
                bne.s   loc_5AC12
                move.l  #Obj_5DFEE,(a1)

loc_5AC12:
                movem.l d7-a0/a2-a3,-(sp)
                lea     (AIZ1_128x128_Kos).l,a1
                lea     (RAM_start).l,a2
                jsr     (Queue_Kos).l
                lea     (AIZ1_16x16_Primary_Kos).l,a1
                lea     (Block_table).w,a2
                jsr     (Queue_Kos).l
                lea     (AIZ1_16x16_MainLevel_Kos).l,a1
                lea     (Block_table+$268).w,a2
                jsr     (Queue_Kos).l
                lea     (AIZ1_8x8_Primary_KosM).l,a1
                move.w  #tiles_to_bytes($000),d2
                jsr     (Queue_Kos_Module).l
                lea     (AIZ1_8x8_MainLevel_KosM).l,a1
                move.w  #tiles_to_bytes($0BE),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3
                addq.w  #4,(Events_routine_fg).w

loc_5AC70:
                tst.b   (Kos_modules_left).w
                bne.w   loc_5AEE4
                movem.l d7-a0/a2-a3,-(sp)
                clr.w   (Current_zone_and_act).w
                move.b  #1,(Last_star_post_hit).w
                jsr     (Load_Level).l
                jsr     (LoadSolids).l
                move.w  #$D01,(Current_zone_and_act).w
                clr.b   (Last_star_post_hit).w
                moveq   #PalID_SonicTails,d0
                jsr     (LoadPalette).l
                moveq   #PalID_AIZ,d0
                jsr     (LoadPalette).l
                lea     (Pal_SSZ2+$20).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_5ACB8:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5ACB8
                jsr     (Adjust_AIZ1Chunks2).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$1EB8,d0
                move.w  d0,(Camera_X_pos).w
                move.w  d0,(Camera_X_pos_copy).w
                move.w  #$1E0,d0
                move.w  d0,(Camera_Y_pos).w
                move.w  d0,(Camera_Y_pos_copy).w
                jsr     (Reset_TileOffsetPositionActual).l
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_fg).w

loc_5ACFC:
                move.w  (Camera_X_pos_copy).w,d1
                move.w  (Camera_Y_pos_copy).w,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.w   loc_5AEE4
                addq.w  #4,(Events_routine_bg).w
                addq.w  #4,(Events_routine_fg).w

loc_5AD16:
                cmpi.w  #$10,(Events_routine_bg).w
                blo.w   loc_5AEE4
                move.w  #$40-1,(Palette_fade_info).w
                move.w  #$15,(Events_bg+$08).w
                addq.w  #4,(Events_routine_fg).w

loc_5AD30:
                move.l  a0,-(sp)
                jsr     (Pal_FromBlack).l
                movea.l (sp)+,a0
                subq.w  #1,(Events_bg+$08).w
                bpl.w   loc_5AEE4
                clr.w   (Palette_fade_timer).w
                clr.b   (Palette_cycle_counters+$00).w
                clr.w   (Palette_cycle_counter1).w
                clr.w   (Palette_cycle_counter0).w
                addq.w  #4,(Events_routine_fg).w

loc_5AD56:
                tst.w   (Events_fg_4).w
                bne.s   loc_5AD72
                addi.l  #$1000,(Events_bg+$0A).w
                move.l  a0,-(sp)
                jsr     (AnPal_AIZ1).l
                movea.l (sp)+,a0
                bra.w   loc_5AEE4
; ---------------------------------------------------------------------------

loc_5AD72:
                clr.w   (Events_fg_4).w
                move.w  #$40-1,(Palette_fade_info).w
                move.w  #$15,(Events_bg+$08).w
                st      (Palette_fade_timer).w
                st      (Palette_cycle_counters+$00).w
                addq.w  #4,(Events_routine_fg).w

loc_5AD8E:
                move.l  a0,-(sp)
                jsr     (Pal_ToBlack).l
                movea.l (sp)+,a0
                subq.w  #1,(Events_bg+$08).w
                bpl.w   loc_5AEE4
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Player_2,(Kos_decomp_buffer-Player_2)-2

loc_5ADC0:
                jsr     (AllocateObject).l
                bne.s   loc_5ADCE
                move.l  #Obj_Ending,(a1)

loc_5ADCE:
                movem.l d7-a0/a2-a3,-(sp)
                lea     (SSZ2_128x128_Kos).l,a1
                lea     (RAM_start).l,a2
                jsr     (Queue_Kos).l
                lea     (SSZ2_16x16_Kos).l,a1
                lea     (Block_table).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_SSZ2).l,a1
                moveq   #tiles_to_bytes($000),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3
                addq.w  #4,(Events_routine_fg).w

loc_5AE0A:
                tst.b   (Kos_modules_left).w
                bne.w   loc_5AEE4
                movem.l d7-a0/a2-a3,-(sp)
                jsr     (Load_Level).l
                jsr     (LoadSolids).l
                moveq   #PalID_SonicTails,d0
                jsr     (LoadPalette).l
                lea     (Pal_Ending1).l,a1
                lea     (Target_palette_line_2).w,a5
                moveq   #bytesToLcnt($60),d0

loc_5AE36:
                move.l  (a1)+,(a5)+
                dbf     d0,loc_5AE36
                jsr     SKEnding_LoadSkyColorsToTarget(pc)
                movem.l (sp)+,d7-a0/a2-a3
                move.l  #$2000000,d0
                move.l  d0,(Camera_X_pos).w
                move.l  d0,(Camera_X_pos_copy).w
                move.l  d0,(Camera_Y_pos).w
                move.l  d0,(Camera_Y_pos_copy).w
                jsr     (Reset_TileOffsetPositionActual).l
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_fg).w

loc_5AE76:
                move.w  (Camera_X_pos_copy).w,d1
                move.w  (Camera_Y_pos_copy).w,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.s   loc_5AEE4
                move.w  #$14,(Events_routine_bg).w
                addq.w  #4,(Events_routine_fg).w

loc_5AE90:
                cmpi.w  #4,(Events_routine_bg).w
                bhi.s   loc_5AEE4
                move.w  #$40-1,(Palette_fade_info).w
                move.w  #$15,(Events_bg+$08).w
                addq.w  #4,(Events_routine_fg).w

loc_5AEA8:
                move.l  a0,-(sp)
                jsr     (Pal_FromBlack).l
                movea.l (sp)+,a0
                subq.w  #1,(Events_bg+$08).w
                bpl.s   loc_5AEE4
                clr.w   (Palette_fade_timer).w
                clr.b   (Palette_cycle_counters+$00).w
                clr.w   (Palette_cycle_counter1).w
                clr.w   (Palette_cycle_counter0).w
                clr.l   (Camera_Y_pos).w
                clr.l   (Camera_Y_pos_copy).w
                addq.w  #4,(Events_routine_fg).w

loc_5AED4:
                movem.l d7-a0/a2-a3,-(sp)
                jsr     (SKCredits_DispatchScrollState).l
                movem.l (sp)+,d7-a0/a2-a3
                rts
; ---------------------------------------------------------------------------

loc_5AEE4:
                jmp     (DrawTilesAsYouMove).l

; =============== S U B R O U T I N E =======================================

; Subtract the saved transition origins and add $140 to X before writing the foreground camera copies
SKEnding_PublishForegroundCamera:
                move.w  (_unkEE98).w,d0
                sub.w   (Events_bg+$00).w,d0
                addi.w  #$140,d0
                move.w  d0,(Camera_X_pos_copy).w
                move.w  (_unkEE9C).w,d0
                sub.w   (Events_bg+$02).w,d0
                move.w  d0,(Camera_Y_pos_copy).w
                rts
; End of function SKEnding_PublishForegroundCamera
