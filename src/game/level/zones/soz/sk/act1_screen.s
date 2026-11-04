; Owner: game/level/zones/soz/sk
; Responsibility: Sandopolis act-one screen and background initialization, event control, deformation and private sequence data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SOZ1_ScreenInit:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

SOZ1_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

SOZ1_BackgroundInit:
                move.w  (a3),$1C(a3)
                movea.w $18(a3),a1
                move.b  #$FD,$D(a1)
                jsr     BuildSoz1DistantBackgroundBands(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     (Refresh_PlaneFull).l
                jmp     SKSOZ1Events_ComposeDistantHeatScroll(pc)
; ---------------------------------------------------------------------------

SOZ1_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     SOZ1_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SOZ1_BackgroundEvent_Index:
                bra.w   SKSOZ1Events_TryBeginPyramidRise
; ---------------------------------------------------------------------------
                bra.w   SKSOZ1Events_PositionPyramidForRedraw
; ---------------------------------------------------------------------------
                bra.w   SKSOZ1Events_CheckBossFadeTrigger
; ---------------------------------------------------------------------------
                bra.w   SKSOZ1Events_TickFirstFadeDoorDelay
; ---------------------------------------------------------------------------
                bra.w   SKSOZ1Events_TickSecondFadeDelay
; ---------------------------------------------------------------------------
                bra.w   SKSOZ1Events_WaitForArtAndEnterAct2
; ---------------------------------------------------------------------------

SKSOZ1Events_TryBeginPyramidRise:
                tst.w   (Events_fg_5).w
                beq.s   SKSOZ1Events_SelectCameraMaxY
                clr.w   (Events_fg_5).w
                move.w  #-8,(_unkEE9C).w
                st      (Screen_shake_flag).w
                jsr     PositionSoz1PyramidBackgroundAndRumble(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKSOZ1Events_RedrawAndLoadPyramid
; ---------------------------------------------------------------------------

SKSOZ1Events_SelectCameraMaxY:
                move.w  #$B20,d0
                cmpi.w  #$4000,(Player_1+x_pos).w
                blo.s   SKSOZ1Events_SetCameraLimitsAndDrawHeat
                move.w  #$960,d0

SKSOZ1Events_SetCameraLimitsAndDrawHeat:
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                jsr     TriggerSoz1PyramidCameraLock(pc)
                jsr     BuildSoz1DistantBackgroundBands(pc)
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     (Draw_TileRow).l
                jmp     SKSOZ1Events_ComposeDistantHeatScroll(pc)
; ---------------------------------------------------------------------------

SKSOZ1Events_PositionPyramidForRedraw:
                jsr     PositionSoz1PyramidBackgroundAndRumble(pc)

SKSOZ1Events_RedrawAndLoadPyramid:
                move.w  (Camera_X_pos_BG_copy).w,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.w   SKSOZ1Events_DrawPyramidDoorAndHeat
                movem.l d7-a0/a2-a3,-(sp)
                lea     (SOZ1_16x16_Custom_Kos).l,a1
                lea     (Block_table+$EA0).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_SOZ1_Custom).l,a1
                move.w  #tiles_to_bytes($315),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3
                jsr     (AllocateObject).l
                bne.s   SKSOZ1Events_AdvancePyramidState
                move.l  #SKSOZ1Events_DispatchDoorTimer,(a1)
                jsr     (CreateNewSprite4).l
                bne.s   SKSOZ1Events_AdvancePyramidState
                move.l  #SKSOZ1Events_InitPyramidMask,(a1)
                jsr     (CreateNewSprite4).l
                bne.s   SKSOZ1Events_AdvancePyramidState
                move.l  #SKSOZ1Events_InitPyramidDoor,(a1)

; Advance even if only a prefix of the pyramid actors could be allocated
SKSOZ1Events_AdvancePyramidState:
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKSOZ1Events_DrawPyramidDoorAndHeat
; ---------------------------------------------------------------------------

; P1 must be at or left of $4378 and at or below $9A8. In Sonic-and-Tails mode, P2 passes if right of $4378 or at or below $9A8
SKSOZ1Events_CheckBossFadeTrigger:
                cmpi.w  #$55,(Events_fg_5).w
                bne.s   SKSOZ1Events_UpdatePyramidRise
                move.w  #$4378,d0
                cmp.w   (Player_1+x_pos).w,d0
                bhi.s   SKSOZ1Events_UpdatePyramidRise
                cmpi.w  #$9A8,(Player_1+y_pos).w
                blo.s   SKSOZ1Events_UpdatePyramidRise
                tst.w   (Player_mode).w
                bne.s   SKSOZ1Events_InitFirstFadeAndDoorDelay
                cmp.w   (Player_2+x_pos).w,d0
                blo.s   SKSOZ1Events_InitFirstFadeAndDoorDelay
                cmpi.w  #$9A8,(Player_2+y_pos).w
                bhs.s   SKSOZ1Events_InitFirstFadeAndDoorDelay

SKSOZ1Events_UpdatePyramidRise:
                jsr     SOZ1_UpdatePyramidRise(pc)

SKSOZ1Events_DrawPyramidDoorAndHeat:
                jsr     (DrawBGAsYouMove).l
                jsr     ApplySoz1PyramidDoorChunkRequest(pc)
                jsr     ComposeSoz1PyramidPairedHeatScroll(pc)
                jmp     ShakeScreen_Setup(pc)
; ---------------------------------------------------------------------------

SKSOZ1Events_InitFirstFadeAndDoorDelay:
                move.w  #$10-1,(Palette_fade_info).w
                move.w  #$15,(Events_bg+$04).w
                move.w  #$10,(Events_bg+$06).w
                st      (Palette_fade_timer).w
                addq.w  #4,(Events_routine_bg).w

SKSOZ1Events_TickFirstFadeDoorDelay:
                tst.w   (Events_bg+$06).w
                beq.s   SKSOZ1Events_TryFadeFirstRange
                subq.w  #1,(Events_bg+$06).w
                bne.s   SKSOZ1Events_DrawPyramidDuringFade
                st      (Events_bg+$02).w
                bra.s   SKSOZ1Events_DrawPyramidDuringFade
; ---------------------------------------------------------------------------

SKSOZ1Events_TryFadeFirstRange:
                tst.w   (Events_bg+$02).w
                bne.s   SKSOZ1Events_DrawPyramidDuringFade
                btst    #0,(Level_frame_counter+1).w
                beq.s   SKSOZ1Events_DrawPyramidDuringFade
                move.l  a0,-(sp)
                jsr     (Pal_ToBlack).l
                movea.l (sp)+,a0
                subq.w  #1,(Events_bg+$04).w
                bmi.s   SKSOZ1Events_InitSecondFadeDelay

SKSOZ1Events_DrawPyramidDuringFade:
                jsr     SOZ1_UpdatePyramidRise(pc)
                jsr     (DrawBGAsYouMove).l
                jsr     ApplySoz1PyramidDoorChunkRequest(pc)
                jmp     ComposeSoz1PyramidPairedHeatScroll(pc)
; ---------------------------------------------------------------------------

SKSOZ1Events_InitSecondFadeDelay:
                move.w  #$4020-1,(Palette_fade_info).w
                move.w  #$15,(Events_bg+$04).w
                move.w  #8,(Events_bg+$06).w
                addq.w  #4,(Events_routine_bg).w

SKSOZ1Events_TickSecondFadeDelay:
                tst.w   (Events_bg+$06).w
                beq.s   SKSOZ1Events_TryFadeSecondRange
                subq.w  #1,(Events_bg+$06).w
                bra.s   SKSOZ1Events_DrawHeatDuringSecondFade
; ---------------------------------------------------------------------------

SKSOZ1Events_TryFadeSecondRange:
                btst    #0,(Level_frame_counter+1).w
                beq.s   SKSOZ1Events_DrawHeatDuringSecondFade
                move.l  a0,-(sp)
                jsr     (Pal_ToBlack).l
                movea.l (sp)+,a0
                subq.w  #1,(Events_bg+$04).w
                bmi.s   SKSOZ1Events_QueueAct2Resources

SKSOZ1Events_DrawHeatDuringSecondFade:
                jmp     ComposeSoz1PyramidPairedHeatScroll(pc)
; ---------------------------------------------------------------------------

SKSOZ1Events_QueueAct2Resources:
                movem.l d7-a0/a2-a3,-(sp)
                lea     (SOZ2_16x16_Secondary_Kos).l,a1
                lea     (Block_table+$EA0).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_SOZ2_Secondary).l,a1
                move.w  #tiles_to_bytes($315),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_2C,d0
                jsr     (Load_PLC).l
                movem.l (sp)+,d7-a0/a2-a3
                addq.w  #4,(Events_routine_bg).w
                rts
; ---------------------------------------------------------------------------

SKSOZ1Events_WaitForArtAndEnterAct2:
                tst.b   (Kos_modules_left).w
                bne.w   SKSOZ1Events_Act2TransitionReturn
                move.w  #$801,(Current_zone_and_act).w
                clr.b   (Dynamic_resize_routine).w
                clr.b   (Object_load_routine).w
                clr.b   (Rings_manager_routine).w
                clr.b   (Boss_flag).w
                clr.b   (Respawn_table_keep).w
                jsr     Clear_Switches(pc)
                movem.l d7-a0/a2-a3,-(sp)
                jsr     (Load_Level).l
                jsr     (LoadSolids).l
                moveq   #PalID_SonicTails,d0
                cmpi.w  #3,(Player_mode).w
                bne.s   SKSOZ1Events_LoadAct2TransitionPalettes
                moveq   #PalID_Knuckles,d0

SKSOZ1Events_LoadAct2TransitionPalettes:
                jsr     (LoadPalette).l
                moveq   #PalID_SOZ2,d0
                jsr     (LoadPalette).l
                moveq   #PalID_SOZ2,d0
                jsr     (LoadPalette_Immediate).l
                movem.l (sp)+,d7-a0/a2-a3
                jsr     InitializeSoz2DarkTransitionPalettes(pc)
                lea     (Normal_palette_line_3).w,a1
                moveq   #bytesToLcnt($40),d0

SKSOZ1Events_ClearPaletteAndRebaseAct2:
                clr.l   (a1)+
                dbf     d0,SKSOZ1Events_ClearPaletteAndRebaseAct2
                move.w  (Player_1+x_pos).w,d2
                sub.w   (Player_2+x_pos).w,d2
                move.w  (Player_1+y_pos).w,d3
                sub.w   (Player_2+y_pos).w,d3
                move.w  #$140,d0
                move.w  #$3AC,d1
                move.w  d0,(Player_1+x_pos).w
                move.w  d1,(Player_1+y_pos).w
                sub.w   d2,d0
                sub.w   d3,d1
                move.w  d0,(Player_2+x_pos).w
                move.w  d1,(Player_2+y_pos).w
                move.w  #$A0,d0
                move.w  #$34C,d1
                move.w  d0,(Camera_X_pos).w
                move.w  d1,(Camera_Y_pos).w
                move.w  d0,(Camera_X_pos_copy).w
                move.w  d1,(Camera_Y_pos_copy).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                move.w  d1,(Camera_min_Y_pos).w
                move.w  d1,(Camera_max_Y_pos).w
                move.w  d1,(Camera_target_max_Y_pos).w
                clr.l   (Events_bg+$02).w
                clr.w   (Events_fg_5).w
                clr.w   (Events_routine_bg).w

SKSOZ1Events_Act2TransitionReturn:
                rts

; =============== S U B R O U T I N E =======================================

BuildSoz1DistantBackgroundBands:
                move.w  (Camera_Y_pos_copy).w,d0
                asr.w   #4,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #4,d0
                move.l  d0,d1
                asr.l   #1,d1
                swap    d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                swap    d0
                swap    d1
                move.w  d1,(Events_bg+$10).w
                swap    d1
                asr.l   #1,d1
                lea     (HScroll_table).w,a1
                moveq   #7-1,d2

SKSOZ1Events_WriteDistantScrollBands:
                swap    d0
                move.w  d0,(a1)+
                swap    d0
                add.l   d1,d0
                dbf     d2,SKSOZ1Events_WriteDistantScrollBands
                rts
; End of function BuildSoz1DistantBackgroundBands

; =============== S U B R O U T I N E =======================================

; Advance on three out of four updates during continuous shake. Always apply the background position and rumble
SOZ1_UpdatePyramidRise:
                tst.w   (Screen_shake_flag).w
                bpl.s   PositionSoz1PyramidBackgroundAndRumble
                move.w  (Level_frame_counter).w,d0
                andi.w  #3,d0
                beq.s   PositionSoz1PyramidBackgroundAndRumble
                addq.w  #1,(_unkEE9C).w
                cmpi.w  #$280,(_unkEE9C).w
                blt.s   PositionSoz1PyramidBackgroundAndRumble
                move.w  #8,(Screen_shake_flag).w
; End of function SOZ1_UpdatePyramidRise

; =============== S U B R O U T I N E =======================================

PositionSoz1PyramidBackgroundAndRumble:
                tst.w   (Screen_shake_flag).w
                bpl.s   SKSOZ1Events_SetPyramidBackgroundPos
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   SKSOZ1Events_SetPyramidBackgroundPos
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l

SKSOZ1Events_SetPyramidBackgroundPos:
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$900,d0
                add.w   (_unkEE9C).w,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$3CD0,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                move.w  d0,(Events_bg+$10).w
                rts
; End of function PositionSoz1PyramidBackgroundAndRumble

; ---------------------------------------------------------------------------

SKSOZ1Events_ComposeDistantHeatScroll:
                lea     (HScroll_table+$010).w,a1
                lea     AIZ2_SOZ1_LRZ3_FGDeformDelta(pc),a6
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  #$DF,d1
                move.w  (Level_frame_counter).w,d2
                asr.w   #1,d2
                add.w   d0,d2
                add.w   d0,d2
                andi.w  #$3E,d2
                adda.w  d2,a6
                move.w  (Camera_X_pos_copy).w,d6
                neg.w   d6
                jsr     MakeFGDeformArray(pc)
                lea     (H_scroll_buffer).w,a1
                lea     (HScroll_table+$010).w,a2
                lea     SKSOZ1Events_DistantHeatBandSpans(pc),a4
                lea     (HScroll_table).w,a5
                lea     AIZ2_SOZ1_LRZ3_FGDeformDelta(pc),a6
                move.w  (Camera_Y_pos_BG_copy).w,d0
                move.w  #$DF,d1
                move.w  (Level_frame_counter).w,d2
                asr.w   #1,d2
                add.w   d0,d2
                add.w   d0,d2
                andi.w  #$3E,d2
                adda.w  d2,a6
                jmp     ApplyFGandBGDeformation(pc)

; =============== S U B R O U T I N E =======================================

ComposeSoz1PyramidPairedHeatScroll:
                lea     (H_scroll_buffer).w,a1
                lea     AIZ2_SOZ1_LRZ3_FGDeformDelta(pc),a6
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Level_frame_counter).w,d1
                asr.w   #1,d1
                add.w   d0,d1
                add.w   d0,d1
                andi.w  #$3E,d1
                adda.w  d1,a6
                move.w  (Camera_X_pos_copy).w,d0
                neg.w   d0
                move.w  (Camera_X_pos_BG_copy).w,d1
                neg.w   d1
                move.w  #$70-1,d2

SKSOZ1Events_WritePyramidHeatPairs:
                move.w  (a6)+,d3
                move.w  d3,d4
                add.w   d0,d3
                add.w   d1,d4
                move.w  d3,(a1)+
                move.w  d4,(a1)+
                move.w  (a6)+,d3
                move.w  d3,d4
                add.w   d0,d3
                add.w   d1,d4
                move.w  d3,(a1)+
                move.w  d4,(a1)+
                dbf     d2,SKSOZ1Events_WritePyramidHeatPairs
                rts
; End of function ComposeSoz1PyramidPairedHeatScroll

; =============== S U B R O U T I N E =======================================

TriggerSoz1PyramidCameraLock:
                move.w  (Camera_max_Y_pos).w,d0
                cmpi.w  #$960,d0
                bne.s   SKSOZ1Events_CameraLockReturn
                cmp.w   (Camera_Y_pos).w,d0
                bhi.s   SKSOZ1Events_CameraLockReturn
                move.w  d0,(Camera_min_Y_pos).w
                cmpi.w  #$4310,(Camera_X_pos).w
                blo.s   SKSOZ1Events_CameraLockReturn
                move.w  #$4180,(Camera_min_X_pos).w
                st      (Events_fg_5).w

SKSOZ1Events_CameraLockReturn:
                rts
; End of function TriggerSoz1PyramidCameraLock

; =============== S U B R O U T I N E =======================================

ApplySoz1PyramidDoorChunkRequest:
                move.w  (Events_bg+$00).w,d0
                beq.s   SKSOZ1Events_DoorPatchReturn
                clr.w   (Events_bg+$00).w
                movea.w $18(a3),a1
                move.b  d0,$D(a1)
                cmpi.w  #$540,(Camera_X_pos_BG_copy).w
                blo.s   SKSOZ1Events_DoorPatchReturn
                move.w  #$6A0,d1
                move.w  #$320,d0
                moveq   #5,d6
                moveq   #6-1,d2

SKSOZ1Events_RedrawDoorTileRows:
                movem.w d0-d2/d6,-(sp)
                jsr     (Setup_TileRowDraw).l
                movem.w (sp)+,d0-d2/d6
                addi.w  #$10,d0
                dbf     d2,SKSOZ1Events_RedrawDoorTileRows

SKSOZ1Events_DoorPatchReturn:
                rts
; End of function ApplySoz1PyramidDoorChunkRequest

; =============== S U B R O U T I N E =======================================

InitializeSoz2DarkTransitionPalettes:
                lea     (Normal_palette_line_3+$2).w,a1
                lea     (Target_palette_line_3+$2).w,a5
                lea     SKSOZ1Events_DarkPaletteLine3(pc),a6
                moveq   #$B-1,d0

SKSOZ1Events_CopyDarkPaletteLine3:
                move.w  (a6),(a1)+
                move.w  (a6)+,(a5)+
                dbf     d0,SKSOZ1Events_CopyDarkPaletteLine3
                lea     (Normal_palette_line_4+$2).w,a1
                lea     (Target_palette_line_4+$2).w,a5
                lea     SKSOZ1Events_DarkPaletteLine4(pc),a6
                moveq   #$F-1,d0

SKSOZ1Events_CopyDarkLine4AndInitTimers:
                move.w  (a6),(a1)+
                move.w  (a6)+,(a5)+
                dbf     d0,SKSOZ1Events_CopyDarkLine4AndInitTimers
                move.b  #5,(SOZ_darkness_level).w
                move.w  #(30*60)-1,(Palette_cycle_counter1).w
                move.b  #0,(Palette_cycle_counters+$00).w
                move.w  #4,(Palette_cycle_counters+$06).w
                move.w  #$D0,(Palette_cycle_counters+$02).w
                rts
; End of function InitializeSoz2DarkTransitionPalettes

; ---------------------------------------------------------------------------

SKSOZ1Events_DispatchDoorTimer:
                moveq   #0,d0
                move.b  routine(a0),d0
                jmp     SKSOZ1Events_DoorTimerBranches(pc,d0.w)
; ---------------------------------------------------------------------------

SKSOZ1Events_DoorTimerBranches:
                bra.w   SKSOZ1Events_WaitForShakeToEnd
; ---------------------------------------------------------------------------
                bra.w   SKSOZ1Events_TickDoorOpenDelay
; ---------------------------------------------------------------------------
                bra.w   SKSOZ1Events_WaitForDoorAndTryMiniboss
; ---------------------------------------------------------------------------

SKSOZ1Events_WaitForShakeToEnd:
                tst.w   (Screen_shake_flag).w
                bne.s   SKSOZ1Events_DoorTimerReturn
                move.w  #60,$2E(a0)
                addq.b  #4,routine(a0)

SKSOZ1Events_TickDoorOpenDelay:
                subq.w  #1,$2E(a0)
                bne.s   SKSOZ1Events_DoorTimerReturn
                st      (Events_bg+$02).w
                addq.b  #4,routine(a0)

SKSOZ1Events_WaitForDoorAndTryMiniboss:
                tst.w   (Events_bg+$02).w
                bne.s   SKSOZ1Events_DoorTimerReturn
                jsr     (AllocateObject).l
                bne.s   SKSOZ1Events_DeleteDoorTimer
                move.l  #Obj_SOZMiniboss,(a1)

SKSOZ1Events_DeleteDoorTimer:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSOZ1Events_DoorTimerReturn:
                rts
; ---------------------------------------------------------------------------

SKSOZ1Events_InitPyramidMask:
                move.l  #SKSOZ1Events_CheckMaskAct,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$24,width_pixels(a0)
                move.w  #$200,priority(a0)
                move.l  #Map_SOZ1EndDoor,mappings(a0)
                move.w  #$A00,y_pos(a0)

SKSOZ1Events_CheckMaskAct:
                tst.b   (Current_act).w
                beq.s   SKSOZ1Events_FollowCameraAndDrawMask
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSOZ1Events_FollowCameraAndDrawMask:
                move.w  (Camera_X_pos).w,x_pos(a0)
                st      (Spritemask_flag).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; This actor uses the X and Y velocity words for its base coordinates
SKSOZ1Events_InitPyramidDoor:
                move.l  #SKSOZ1Events_WaitForDoorOpenSignal,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$24,width_pixels(a0)
                move.w  #$380,priority(a0)
                move.w  #make_art_tile($029,2,1),art_tile(a0)
                move.l  #Map_SOZ1EndDoor,mappings(a0)
                move.w  #$439C,x_vel(a0)
                move.w  #$9D4,y_vel(a0)
                move.b  #1,mapping_frame(a0)

SKSOZ1Events_WaitForDoorOpenSignal:
                bclr    #7,render_flags(a0)
                tst.w   (Events_bg+$02).w
                bne.s   SKSOZ1Events_BeginDoorOpening
                rts
; ---------------------------------------------------------------------------

SKSOZ1Events_BeginDoorOpening:
                moveq   #signextendB(sfx_DoorOpen),d0
                jsr     (Play_SFX).l
                move.w  #$F6,(Events_bg+$00).w
                move.l  #SKSOZ1Events_StepDoorOpening,(a0)

; Compute position first, then clamp the stored offset and acknowledge the opening
SKSOZ1Events_StepDoorOpening:
                moveq   #1,d0
                bsr.s   StepSoz1PyramidDoorWithJitter
                cmpi.w  #$58,$2E(a0)
                blo.s   SKSOZ1Events_DrawOpeningDoor
                move.w  #$58,$2E(a0)
                clr.w   (Events_bg+$02).w
                move.l  #SKSOZ1Events_CheckOpenDoorAct,(a0)

SKSOZ1Events_DrawOpeningDoor:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSOZ1Events_CheckOpenDoorAct:
                tst.b   (Current_act).w
                beq.s   SKSOZ1Events_WaitForDoorCloseSignal
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSOZ1Events_WaitForDoorCloseSignal:
                bclr    #7,render_flags(a0)
                tst.w   (Events_bg+$02).w
                bne.s   SKSOZ1Events_BeginDoorClosing
                rts
; ---------------------------------------------------------------------------

SKSOZ1Events_BeginDoorClosing:
                moveq   #signextendB(sfx_DoorOpen),d0
                jsr     (Play_SFX).l
                move.l  #SKSOZ1Events_StepDoorClosing,(a0)

SKSOZ1Events_StepDoorClosing:
                moveq   #-1,d0
                bsr.s   StepSoz1PyramidDoorWithJitter
                tst.w   $2E(a0)
                bpl.s   SKSOZ1Events_DrawClosingDoor
                clr.w   $2E(a0)
                move.w  #$FD,(Events_bg+$00).w
                clr.w   (Events_bg+$02).w
                move.l  #SKSOZ1Events_WaitForDoorOpenSignal,(a0)

SKSOZ1Events_DrawClosingDoor:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

StepSoz1PyramidDoorWithJitter:
                move.w  (Level_frame_counter).w,d1
                andi.w  #3,d1
                bne.s   SKSOZ1Events_ApplyDoorOffsetAndJitter
                add.w   d0,d0

SKSOZ1Events_ApplyDoorOffsetAndJitter:
                add.w   d0,$2E(a0)
                move.w  $1A(a0),d0
                add.w   $2E(a0),d0
                move.w  d0,y_pos(a0)
                lea     ScreenShakeArray2(pc),a1
                move.w  $2E(a0),d0
                andi.w  #$3F,d0
                move.b  (a1,d0.w),d0
                andi.w  #1,d0
                add.w   $18(a0),d0
                move.w  d0,x_pos(a0)
                rts
; End of function StepSoz1PyramidDoorWithJitter

; ---------------------------------------------------------------------------
SKSOZ1Events_DistantHeatBandSpans:
                dc.w    $110,     8,     8,     8,     8,     8, $7FFF
SKSOZ1Events_DarkPaletteLine3:
                dc.w    $C46,  $824,  $804,  $402,  $202,  $200,     0,  $422,  $402,  $200,   $40
SKSOZ1Events_DarkPaletteLine4:
                dc.w    $6AE,  $664,  $422,  $402,  $200,     0,     0,  $EEE,  $466,  $224,     0,   $46,  $6EE,  $48C,  $26A
Map_SOZ1EndDoor:
                include "src/objects/shared/zones/soz/act1/mappings/end_door.s"
