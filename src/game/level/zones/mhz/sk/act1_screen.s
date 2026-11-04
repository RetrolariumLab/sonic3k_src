; Owner: game/level/zones/mhz/sk
; Responsibility: Mushroom Hill act-one screen and background initialization, events and deformation
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

MHZ1_ScreenInit:
                clr.w   (Events_bg+$16).w
                clr.b   (ZoneMagnetOrLeafSelectionFlag).w
                jsr     SelectMhz1CameraLeftLimit(pc)
                tst.w   (SK_alone_flag).w
                beq.s   SKMHZ1Events_RefreshInitialForeground
                move.b  (Last_star_post_hit).w,d0
                beq.s   SKMHZ1Events_SetStandaloneStart
                cmpi.w  #3,(Player_mode).w
                bne.s   SKMHZ1Events_RefreshInitialForeground
                subq.b  #1,d0
                bne.s   SKMHZ1Events_RefreshInitialForeground
                move.w  #$680,d2
                bra.s   SKMHZ1Events_StoreStartCameraX
; ---------------------------------------------------------------------------

; Use the standalone Act 1 start camera and move P1 only outside Knuckles mode
SKMHZ1Events_SetStandaloneStart:
                move.w  #$560,d2
                move.w  #$948,d3
                cmpi.w  #3,(Player_mode).w
                beq.s   SKMHZ1Events_StoreStartCameraY
                lea     (Player_1).w,a1
                move.w  #$718,x_pos(a1)
                move.w  #$62D,y_pos(a1)
                move.w  #$680,d2
                move.w  #$5CD,d3

SKMHZ1Events_StoreStartCameraY:
                move.w  d3,(Camera_Y_pos).w
                move.w  d3,(Camera_Y_pos_copy).w

SKMHZ1Events_StoreStartCameraX:
                move.w  d2,(Camera_X_pos).w
                move.w  d2,(Camera_X_pos_copy).w

SKMHZ1Events_RefreshInitialForeground:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

MHZ1_ScreenEvent:
                tst.b   (Events_bg+$00).w
                bne.s   SKMHZ1Events_DrawForeground
                tst.w   (Events_bg+$16).w
                bne.s   SKMHZ1Events_DrawForeground
                jsr     SelectMhz1CameraLeftLimit(pc)
                move.w  #$AA0,d0
                cmpi.w  #$4100,(Player_1+x_pos).w
                blo.s   SKMHZ1Events_UpdateCameraMaxY
                move.w  #$710,d0

SKMHZ1Events_UpdateCameraMaxY:
                cmp.w   (Camera_max_Y_pos).w,d0
                beq.s   SKMHZ1Events_TryStartMiniboss
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w

SKMHZ1Events_TryStartMiniboss:
                cmpi.w  #$710,(Camera_Y_pos).w
                blo.s   SKMHZ1Events_DrawForeground
                cmpi.w  #$4298,(Camera_X_pos).w
                blo.s   SKMHZ1Events_DrawForeground
                move.w  #$710,(Camera_min_Y_pos).w
                move.w  #8,(Special_events_routine).w
                st      (Events_bg+$00).w
                jsr     (AllocateObject).l
                bne.s   SKMHZ1Events_DrawForeground
                move.l  #Obj_MHZMiniboss,(a1)

SKMHZ1Events_DrawForeground:
                jmp     DrawTilesAsYouMove(pc)

; =============== S U B R O U T I N E =======================================

SelectMhz1CameraLeftLimit:
                move.w  #$680,d0
                tst.w   (SK_alone_flag).w
                bne.s   SKMHZ1Events_UpdateCameraMinX
                moveq   #0,d0
                cmpi.w  #$580,(Player_1+y_pos).w
                bhs.s   SKMHZ1Events_UpdateCameraMinX
                move.w  #$C0,d0

SKMHZ1Events_UpdateCameraMinX:
                cmp.w   (Camera_min_X_pos).w,d0
                beq.s   SKMHZ1Events_LeftLimitReturn
                move.w  d0,(Camera_min_X_pos).w

SKMHZ1Events_LeftLimitReturn:
                rts
; End of function SelectMhz1CameraLeftLimit

; ---------------------------------------------------------------------------

MHZ1_BackgroundInit:
                move.w  (Camera_X_pos_copy).w,(Events_fg_0).w
                move.w  (Camera_X_pos_copy).w,(Events_fg_1).w
                jsr     MHZ_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

MHZ1_BackgroundEvent:
                tst.w   (Events_fg_5).w
                beq.w   SKMHZ1Events_DrawLoopedBackground
                clr.w   (Events_fg_5).w
                movem.l d7-a0/a2-a3,-(sp)
                moveq   #PLCID_28,d0
                jsr     (Load_PLC).l
                move.w  #$701,(Current_zone_and_act).w
                clr.b   (Dynamic_resize_routine).w
                clr.b   (Object_load_routine).w
                clr.b   (Rings_manager_routine).w
                clr.b   (Boss_flag).w
                clr.b   (Respawn_table_keep).w
                jsr     Clear_Switches(pc)
                jsr     (Load_Level).l
                jsr     (LoadSolids).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$4200,d0
                moveq   #0,d1
                sub.w   d0,(Player_1+x_pos).w
                sub.w   d0,(Player_2+x_pos).w
                jsr     MHZ_TranslateObjectsForAct2(pc)
                sub.w   d0,(Camera_X_pos).w
                sub.w   d0,(Camera_X_pos_copy).w
                move.w  (Camera_X_pos_copy).w,(Events_fg_0).w
                sub.w   d0,(Camera_min_X_pos).w
                sub.w   d0,(Camera_max_X_pos).w
                jsr     Reset_TileOffsetPositionActual(pc)
                clr.w   (Special_events_routine).w
                clr.b   (Events_bg+$00).w

SKMHZ1Events_DrawLoopedBackground:
                lea     (Events_fg_0).w,a1
                move.w  (Camera_X_pos_copy).w,d0
                move.w  #$100,d2
                move.w  #$200,d3
                jsr     Adjust_BGDuringLoop(pc)
                jsr     MHZ_Deform(pc)
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                jmp     PlainDeformation(pc)

; =============== S U B R O U T I N E =======================================

MHZ_Deform:
                move.w  (Camera_Y_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #3,d0
                move.l  d0,d1
                asr.l   #2,d1
                add.l   d1,d0
                swap    d0
                addi.w  #$76,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Events_fg_1).w,d0
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d1
                asr.l   #2,d1
                sub.l   d1,d0
                asr.l   #1,d1
                swap    d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,(Events_bg+$10).w
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,(Events_bg+$12).w
                rts
; End of function MHZ_Deform

; ---------------------------------------------------------------------------

SKMHZ1Events_WrapChaseCameraAndPlayers:
                clr.w   (Level_repeat_offset).w
                move.w  (Camera_X_pos).w,d0
                cmpi.w  #$4400,d0
                blo.s   SKMHZ1Events_PinCameraMinX
                move.w  #$200,d1
                move.w  d1,(Level_repeat_offset).w
                sub.w   d1,(Player_1+x_pos).w
                sub.w   d1,(Player_2+x_pos).w
                sub.w   d1,d0
                move.w  d0,d1
                andi.w  #$FFF0,d1
                subi.w  #$10,d1
                move.w  d1,(Camera_X_pos_rounded).w
                move.w  d0,(Camera_X_pos).w
                move.w  d0,(Camera_X_pos_copy).w
                move.w  #$4298,d2
                move.w  d2,(Camera_max_X_pos).w

SKMHZ1Events_PinCameraMinX:
                move.w  d0,(Camera_min_X_pos).w
                rts

; =============== S U B R O U T I N E =======================================

; Translate active world-coordinate objects and retire initialized static scenery from the old layout
MHZ_TranslateObjectsForAct2:
                lea     (Dynamic_object_RAM+object_size).w,a1
                moveq   #((Breathing_bubbles)-(Dynamic_object_RAM+object_size))/object_size-1,d2

SKMHZ1Events_TryRetireStaticObject:
                move.l  (a1),d3
                beq.s   SKMHZ1Events_NextTransitionObject
                cmpi.l  #SKStaticScenery_CullOrEnqueue,d3
                bne.s   SKMHZ1Events_ShiftWorldObject
                move.l  #Delete_Current_Sprite,(a1)
                move.w  respawn_addr(a1),d3
                beq.s   SKMHZ1Events_ShiftWorldObject
                movea.w d3,a5
                clr.b   (a5)

SKMHZ1Events_ShiftWorldObject:
                btst    #2,render_flags(a1)
                beq.s   SKMHZ1Events_NextTransitionObject
                sub.w   d0,x_pos(a1)
                sub.w   d1,y_pos(a1)

SKMHZ1Events_NextTransitionObject:
                lea     next_object(a1),a1
                dbf     d2,SKMHZ1Events_TryRetireStaticObject
                rts
; End of function MHZ_TranslateObjectsForAct2
