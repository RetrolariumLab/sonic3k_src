; Owner: game/level/zones/icz/s3
; Responsibility: IceCap act-one introductory screen control, background events and deformation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

ICZ1_ScreenInit:
                move.w  #$7FF,(Screen_Y_wrap_value).w
                move.w  #$7F0,(Camera_Y_pos_mask).w
                move.w  #$3C,(Layout_row_index_mask).w  ; We're in a looping level!
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

ICZ1_ScreenEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     ICZ1_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

ICZ1_ScreenEvent_Index:
                bra.w   ICZ1SE_Init
; ---------------------------------------------------------------------------
                bra.w   ICZ1SE_WaitQuake
; ---------------------------------------------------------------------------
                bra.w   ICZ1SE_Normal
; ---------------------------------------------------------------------------
                bra.w   ICZ1SE_Normal
; ---------------------------------------------------------------------------
                bra.w   ICZ1SE_Normal
; ---------------------------------------------------------------------------
                bra.w   ICZ1SE_Normal
; ---------------------------------------------------------------------------

ICZ1SE_Init:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_X_pos_copy).w
                bra.s   ICZ1SE_Normal
; ---------------------------------------------------------------------------

ICZ1SE_WaitQuake:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w

ICZ1SE_Normal:
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

ICZ1_BackgroundInit:
                lea     (a3),a1
                moveq   #8-1,d0

loc_3DB44:
                move.w  (a1),$20(a1)                    ; Upper $400 of BG is mirrored in lower $400
                addq.w  #4,a1
                dbf     d0,loc_3DB44
                move.w  (Camera_Y_pos_copy).w,(Events_fg_0).w
                move.w  (Camera_Y_pos_copy).w,(Events_fg_1).w  ; Camera BG Y is noted in two variables
                cmpi.w  #$3940,(Camera_X_pos_copy).w
                bhs.s   loc_3DB9C
                cmpi.w  #$3600,(Camera_X_pos_copy).w
                blo.s   loc_3DB70
                addi.w  #$2800,(Events_fg_1).w          ; If past $3580 X, adjust BG camera

loc_3DB70:
                cmpi.w  #$580,(Camera_Y_pos_copy).w
                bcc.s   loc_3DB9C
                clr.w   (Events_bg+$16).w               ; No VScrolling when outside
                jsr     ICZ1_SetIntroPal(pc)
                jsr     ICZ1_IntroDeform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                move.w  #$1880,d1
                jsr     Refresh_PlaneFull(pc)
                lea     ICZ1_IntroBGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

loc_3DB9C:
                move.w  #$10,(Events_routine_bg).w      ; If past $3940 X, we're indoors already
                st      (Events_bg+$16).w               ; Go indoors
                jsr     ICZ1_SetIndoorPal(pc)
                jsr     ICZ1_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                jsr     Refresh_PlaneFull(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

ICZ1_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     ICZ1_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

ICZ1_BackgroundEvent_Index:
                bra.w   ICZ1BGE_Intro
; ---------------------------------------------------------------------------
                bra.w   ICZ1BGE_SnowFall
; ---------------------------------------------------------------------------
                bra.w   ICZ1BGE_Refresh
; ---------------------------------------------------------------------------
                bra.w   ICZ1BGE_Refresh2
; ---------------------------------------------------------------------------
                bra.w   ICZ1BGE_Normal
; ---------------------------------------------------------------------------
                bra.w   ICZ1BGE_Transition
; ---------------------------------------------------------------------------

ICZ1BGE_Intro:
                tst.w   (Events_fg_5).w
                beq.s   loc_3DBFA
                clr.w   (Events_fg_5).w                 ; If flag is set
                clr.l   (Events_bg+$00).w
                clr.l   (Events_bg+$04).w               ; Clear offsets
                jsr     ICZ1_BigSnowFall(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3DC2A
; ---------------------------------------------------------------------------

loc_3DBFA:
                jsr     ICZ1_IntroDeform(pc)            ; Deformation is pretty standard during the intro portion
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                move.w  #$1880,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     ICZ1_IntroBGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jsr     ApplyDeformation(pc)
                jmp     ShakeScreen_Setup(pc)
; ---------------------------------------------------------------------------

ICZ1BGE_SnowFall:
                tst.w   (Events_fg_5).w
                bne.s   loc_3DC36
                jsr     ICZ1_BigSnowFall(pc)

loc_3DC2A:
                jsr     DrawBGAsYouMove(pc)
                jsr     PlainDeformation(pc)
                jmp     ShakeScreen_Setup(pc)
; ---------------------------------------------------------------------------

loc_3DC36:
                clr.w   (Events_fg_5).w
                move.w  #$2E0,(Draw_delayed_position).w  ; Set BG refresh position
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w

ICZ1BGE_Refresh:
                move.w  #$1880,d1
                move.w  #$200,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.w   PlainDeformation
                jsr     ICZ1_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3DC7E
; ---------------------------------------------------------------------------

ICZ1BGE_Refresh2:
                jsr     ICZ1_Deform(pc)

loc_3DC7E:
                move.w  (Camera_X_pos_BG_copy).w,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   loc_3DCEC
                st      (Events_bg+$16).w               ; Go indoors
                jsr     ICZ1_SetIndoorPal(pc)           ; Set indoor palette
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3DCEC
; ---------------------------------------------------------------------------

ICZ1BGE_Normal:
                cmpi.w  #$6900,(Camera_X_pos_copy).w
                blo.s   loc_3DCE8
                movem.l d7-a0/a2-a3,-(sp)
                lea     (ICZ2_128x128_Secondary_Kos).l,a1
                lea     (RAM_start+$A00).l,a2
                jsr     (Queue_Kos).l
                lea     (ICZ2_16x16_Secondary_Kos).l,a1
                lea     (Block_table+$408).w,a2
                jsr     (Queue_Kos).l
                lea     (ICZ2_8x8_Secondary_KosM).l,a1
                move.w  #tiles_to_bytes($122),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_20,d0
                jsr     (Load_PLC).l
                movem.l (sp)+,d7-a0/a2-a3
                addq.w  #4,(Events_routine_bg).w

loc_3DCE8:
                jsr     ICZ1_Deform(pc)

loc_3DCEC:
                jsr     DrawBGAsYouMove(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

ICZ1BGE_Transition:
                tst.w   (Kos_decomp_queue_count).w
                bne.w   loc_3DDA6
                move.w  #$501,(Current_zone_and_act).w
                clr.b   (Dynamic_resize_routine).w
                clr.b   (Object_load_routine).w
                clr.b   (Rings_manager_routine).w
                clr.b   (Boss_flag).w
                clr.b   (Respawn_table_keep).w
                jsr     Clear_Switches(pc)
                movem.l d7-a0/a2-a3,-(sp)
                jsr     (Load_Level).l
                jsr     (LoadSolids).l
                jsr     (CheckLevelForWater).l
                move.w  #$8014,(VDP_control_port).l     ; Turn on HInt since ICZ2 has water
                moveq   #PalID_ICZ2,d0
                jsr     (LoadPalette_Immediate).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$6880,d0
                move.w  #-$100,d1
                sub.w   d0,(Player_1+x_pos).w
                sub.w   d1,(Player_1+y_pos).w
                sub.w   d0,(Player_2+x_pos).w
                sub.w   d1,(Player_2+y_pos).w
                jsr     Offset_ObjectsDuringTransition(pc)
                sub.w   d0,(Camera_X_pos).w
                sub.w   d1,(Camera_Y_pos).w
                sub.w   d0,(Camera_X_pos_copy).w
                sub.w   d1,(Camera_Y_pos_copy).w
                move.l  #$7000,d0
                move.l  d0,(Camera_min_X_pos).w
                move.l  d0,(Camera_target_min_X_pos).w
                move.l  #$B20,d0
                move.l  d0,(Camera_min_Y_pos).w
                move.l  d0,(Camera_target_min_Y_pos).w
                move.w  #$FFF,(Screen_Y_wrap_value).w
                move.w  #$FF0,(Camera_Y_pos_mask).w
                move.w  #$7C,(Layout_row_index_mask).w
                jsr     Reset_TileOffsetPositionActual(pc)
                clr.w   (Events_routine_bg).w

loc_3DDA6:
                jsr     ICZ1_Deform(pc)
                jmp     PlainDeformation(pc)

; =============== S U B R O U T I N E =======================================

ICZ1_IntroDeform:
                lea     (Events_fg_0).w,a1
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  #$400,d2
                move.w  #$800,d3
                jsr     Adjust_BGDuringLoop(pc)
                move.w  (Events_fg_1).w,d0
                asr.w   #7,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                move.w  (Screen_shake_offset).w,d3
                sub.w   d3,d0
                swap    d0
                clr.w   d0
                asr.l   #5,d0
                move.l  d0,d1
                swap    d0
                add.w   d3,d0
                swap    d0
                lea     (HScroll_table).w,a1
                moveq   #5-1,d2                         ; First five deformation speeds are constant
                bsr.s   sub_3DDF6
                add.l   d1,d0
                move.l  d1,d2
                asr.l   #1,d2
                add.l   d2,d1
                moveq   #9-1,d2                         ; Last 9 move slowly automatically
; End of function ICZ1_IntroDeform

; =============== S U B R O U T I N E =======================================

sub_3DDF6:
                swap    d0
                move.w  d0,(a1)+
                swap    d0
                add.l   d1,d0
                dbf     d2,sub_3DDF6
                rts
; End of function sub_3DDF6

; =============== S U B R O U T I N E =======================================

ICZ1_BigSnowFall:
                cmpi.w  #-$120,(Events_bg+$00).w
                ble.s   loc_3DE36
                st      (Screen_shake_flag).w
                addi.l  #$2400,(Events_bg+$04).w
                move.l  (Events_bg+$04).w,d0
                sub.l   d0,(Events_bg+$00).w
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   loc_3DE42
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l
                bra.s   loc_3DE42
; ---------------------------------------------------------------------------

loc_3DE36:
                tst.w   (Screen_shake_flag).w
                bpl.s   loc_3DE42
                move.w  #4,(Screen_shake_flag).w

loc_3DE42:
                move.w  (Camera_Y_pos_copy).w,d0        ; Use portion of background to show snow object
                subi.w  #$460,d0
                add.w   (Events_bg+$00).w,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$1D40,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                rts
; End of function ICZ1_BigSnowFall

; =============== S U B R O U T I N E =======================================

ICZ1_Deform:
                move.w  (Camera_Y_pos_copy).w,d0
                asr.w   #1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w     ; BG moves up/down at half speed
                asr.w   #1,d0
                move.w  d0,(Events_bg+$12).w            ; Dynamic BG moves up/down at quarter speed
                move.w  (Camera_X_pos_copy).w,d0
                asr.w   #1,d0
                subi.w  #$1D80,d0
                move.w  d0,(Camera_X_pos_BG_copy).w     ; BG moves left/right at half speed
                asr.w   #1,d0
                move.w  d0,(Events_bg+$10).w            ; Dynamic BG moves left/right at quarter speed
                rts
; End of function ICZ1_Deform

; =============== S U B R O U T I N E =======================================

ICZ1_SetIntroPal:
                tst.b   (Game_mode).w
                bmi.s   loc_3DE92
                lea     (Normal_palette_line_4+2).w,a1
                bsr.s   sub_3DE96

loc_3DE92:
                lea     (Target_palette_line_4+2).w,a1

sub_3DE96:
                move.l  #$EEE0EEC,(a1)+
                move.l  #$EEA0ECA,(a1)+
                move.l  #$EC80EA6,(a1)+
                move.l  #$E860E64,(a1)+
                move.l  #$E400E00,(a1)+
                move.l  #$C000000,(a1)+
                move.l  #$AEC0CEA,(a1)+
                move.w  #$E80,(a1)
                rts
; End of function ICZ1_SetIntroPal

; =============== S U B R O U T I N E =======================================

ICZ1_SetIndoorPal:
                tst.b   (Game_mode).w
                bmi.s   loc_3DED2
                lea     (Normal_palette_line_4+2).w,a1
                bsr.s   sub_3DED6

loc_3DED2:
                lea     (Target_palette_line_4+2).w,a1

sub_3DED6:
                move.l  #$EC00E40,(a1)+
                move.l  #$E040C00,(a1)+
                move.l  #$6000200,(a1)+
                move.l  #$0000E64,(a1)+
                move.l  #$E240A02,(a1)+
                move.w  #$402,(a1)
                rts
; End of function ICZ1_SetIndoorPal

; ---------------------------------------------------------------------------
ICZ1_IntroBGDeformArray:
                dc.w    $44,    $C,    $B,    $D,   $18,   $50,     2,     6,     8,   $10,   $18,   $20,   $28, $7FFF
