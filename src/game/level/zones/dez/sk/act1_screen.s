; Owner: game/level/zones/dez/sk
; Responsibility: Death Egg act-one screen and background initialization, event dispatch and deformation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

DEZ1_ScreenInit:
                jsr     (Reset_TileOffsetPositionActual).l
                jmp     (Refresh_PlaneFull).l
; ---------------------------------------------------------------------------

DEZ1_ScreenEvent:
                tst.w   (Events_fg_4).w
                beq.s   loc_59378
                clr.w   (Events_fg_4).w
                movea.w $14(a3),a1
                move.b  #$BD,$6E(a1)
                jmp     (Refresh_PlaneScreenDirect).l
; ---------------------------------------------------------------------------

loc_59378:
                jmp     (DrawTilesAsYouMove).l
; ---------------------------------------------------------------------------

DEZ1_BackgroundInit:
                clr.w   (Camera_X_pos_BG_copy).w
                clr.w   (Camera_Y_pos_BG_copy).w
                jsr     (Reset_TileOffsetPositionEff).l
                jsr     (Refresh_PlaneFull).l
                jmp     (PlainDeformation).l
; ---------------------------------------------------------------------------

DEZ1_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     DEZ1_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

DEZ1_BackgroundEvent_Index:
                bra.w   loc_593A8
; ---------------------------------------------------------------------------
                bra.w   loc_593EC
; ---------------------------------------------------------------------------

loc_593A8:
                tst.w   (Events_fg_5).w
                beq.s   loc_593E6
                clr.w   (Events_fg_5).w
                movem.l d7-a0/a2-a3,-(sp)
                lea     (DEZ2_16x16_Secondary_Kos).l,a1
                lea     (Block_table+$15E0).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_DEZ2_Secondary).l,a1
                move.w  #tiles_to_bytes($292),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_38,d0
                jsr     (Load_PLC).l
                movem.l (sp)+,d7-a0/a2-a3
                addq.w  #4,(Events_routine_bg).w

loc_593E6:
                jmp     (PlainDeformation).l
; ---------------------------------------------------------------------------

loc_593EC:
                tst.b   (Kos_modules_left).w
                bne.w   loc_59488
                move.w  #$B01,(Current_zone_and_act).w
                clr.b   (Dynamic_resize_routine).w
                clr.b   (Object_load_routine).w
                clr.b   (Rings_manager_routine).w
                clr.b   (Boss_flag).w
                clr.b   (Respawn_table_keep).w
                jsr     (Clear_Switches).l
                movem.l d7-a0/a2-a3,-(sp)
                jsr     (Load_Level).l
                jsr     (LoadSolids).l
                lea     (Normal_palette_line_3).w,a0
                lea     (Pal_DEZ2+$20).l,a1
                moveq   #bytesToLcnt($40),d0

loc_59430:
                move.l  (a1)+,(a0)+
                dbf     d0,loc_59430
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$3600,d0
                move.w  #-$400,d1
                sub.w   d0,(Player_1+x_pos).w
                sub.w   d1,(Player_1+y_pos).w
                sub.w   d0,(Player_2+x_pos).w
                sub.w   d1,(Player_2+y_pos).w
                jsr     (Offset_ObjectsDuringTransition).l
                sub.w   d0,(Camera_X_pos).w
                sub.w   d1,(Camera_Y_pos).w
                sub.w   d0,(Camera_X_pos_copy).w
                sub.w   d1,(Camera_Y_pos_copy).w
                sub.w   d0,(Camera_min_X_pos).w
                sub.w   d0,(Camera_max_X_pos).w
                sub.w   d1,(Camera_min_Y_pos).w
                sub.w   d1,(Camera_max_Y_pos).w
                move.w  (Camera_max_Y_pos).w,(Camera_target_max_Y_pos).w
                jsr     (Reset_TileOffsetPositionActual).l
                clr.w   (Events_routine_bg).w

loc_59488:
                jmp     (PlainDeformation).l
; End of function DEZ1_ScreenInit
