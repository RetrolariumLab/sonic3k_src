; Owner: game/level/zones/cnz/sk
; Responsibility: Carnival Night act-two screen control, background events and teleporter actor
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CNZ2_ScreenInit:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

CNZ2_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                cmpi.w  #$4600,(Player_1+x_pos).w
                bhs.s   SKCNZ2Screen_TryDirectFgRefresh  ; If player is far enough to the right, skip ahead
                moveq   #0,d0
                cmpi.w  #$940,(Player_1+x_pos).w
                bhs.s   SKCNZ2Screen_TrySetMinY
                move.w  #$580,d0                        ; If player is still in old boss arena, set the level Y start to $580, otherwise, make it 0 like normal

SKCNZ2Screen_TrySetMinY:
                cmp.w   (Camera_min_Y_pos).w,d0
                beq.s   SKCNZ2Screen_TryDirectFgRefresh
                move.w  d0,(Camera_min_Y_pos).w

SKCNZ2Screen_TryDirectFgRefresh:
                tst.w   (Events_bg+$06).w
                beq.s   SKCNZ2Screen_DispatchForeground
                clr.w   (Events_bg+$06).w
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

SKCNZ2Screen_DispatchForeground:
                move.w  (Events_routine_fg).w,d0
                jmp     CNZ2_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

CNZ2_ScreenEvent_Index:
                bra.w   SKCNZ2Screen_SelectKnucklesExit
; ---------------------------------------------------------------------------
                bra.w   SKCNZ2Screen_TryExtendCameraAfterExit
; ---------------------------------------------------------------------------
                bra.w   CNZ2SE_Normal
; ---------------------------------------------------------------------------

SKCNZ2Screen_SelectKnucklesExit:
                cmpi.w  #3,(Player_mode).w
                beq.s   SKCNZ2Screen_TrySpawnExitObjects
                move.w  #8,(Events_routine_fg).w        ; If playing as Sonic/Tails, don't do any special screen events
                bra.w   CNZ2SE_Normal
; ---------------------------------------------------------------------------

SKCNZ2Screen_TrySpawnExitObjects:
                lea     (Player_1).w,a1                 ; Only do all this is Knuckles is playing
                cmpi.w  #$4880,x_pos(a1)
                blo.w   CNZ2SE_Normal                   ; If Knuckles is not past $4880 X, just play normally
                cmpi.w  #$B00,y_pos(a1)
                blo.s   CNZ2SE_Normal                   ; If Knuckles is not past $B00 Y, play normally
                jsr     (AllocateObject).l
                bne.s   SKCNZ2Screen_LockExitCamera
                move.l  #Obj_CNZTeleporter,(a1)
                jsr     (CreateNewSprite4).l
                bne.s   SKCNZ2Screen_LockExitCamera
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$4980,x_pos(a1)
                move.w  #$A20,y_pos(a1)
                movem.l d7-a0/a2-a3,-(sp)
                lea     (PLC_EggCapsule).l,a1
                jsr     (Load_PLC_Raw).l
                movem.l (sp)+,d7-a0/a2-a3

; Lock the camera and advance the foreground event even if either exit object fails to allocate
SKCNZ2Screen_LockExitCamera:
                move.w  #$4750,(Camera_min_X_pos).w
                move.w  #$48E0,(Camera_max_X_pos).w
                clr.b   (End_of_level_flag).w
                addq.w  #4,(Events_routine_fg).w

SKCNZ2Screen_TryExtendCameraAfterExit:
                tst.b   (End_of_level_flag).w
                beq.s   CNZ2SE_Normal
                jsr     (AllocateObject).l
                bne.s   CNZ2SE_Normal
                move.l  #Obj_IncLevEndXGradual,(a1)
                move.w  #$49A0,(Camera_stored_max_X_pos).w
                lea     (a2),a6
                jsr     (Restore_LevelMusic).l
                lea     (a6),a2
                jsr     (Restore_PlayerControl).l
                addq.w  #4,(Events_routine_fg).w

CNZ2SE_Normal:
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
                bra.w   SKCNZ2Screen_BeginBackgroundRedraw
; ---------------------------------------------------------------------------
                bra.w   SKCNZ2Screen_DeformBeforeRedrawStep
; ---------------------------------------------------------------------------
                bra.w   SKCNZ2Screen_DeformNormalBackground
; ---------------------------------------------------------------------------

SKCNZ2Screen_BeginBackgroundRedraw:
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
                bra.s   SKCNZ2Screen_StepBackgroundRedraw
; ---------------------------------------------------------------------------

SKCNZ2Screen_DeformBeforeRedrawStep:
                jsr     CNZ1_Deform(pc)

SKCNZ2Screen_StepBackgroundRedraw:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                bpl.s   SKCNZ2Screen_DrawAndShakeBackground
                addq.w  #4,(Events_routine_bg).w
                bra.s   SKCNZ2Screen_DrawAndShakeBackground
; ---------------------------------------------------------------------------

SKCNZ2Screen_DeformNormalBackground:
                jsr     CNZ1_Deform(pc)

SKCNZ2Screen_DrawAndShakeBackground:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     CNZ1_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jsr     ApplyDeformation(pc)
                jmp     ShakeScreen_Setup(pc)
; ---------------------------------------------------------------------------

Obj_CNZTeleporter:
                lea     (Player_1).w,a1
                cmpi.w  #$4A38,x_pos(a1)
                blo.s   SKCNZ2Screen_WarpInitReturn     ; If Knuckles isn't in range, don't bother
                btst    #Status_InAir,status(a1)
                beq.s   SKCNZ2Screen_LockPlayerAndLoadWarpArt
                move.w  #$4A40,d0
                cmp.w   x_pos(a1),d0
                bhi.s   SKCNZ2Screen_WarpInitReturn
                move.w  d0,x_pos(a1)                    ; While jumping, don't allow Knuckles past this point (so he lands on the teleporter)

SKCNZ2Screen_LockPlayerAndLoadWarpArt:
                clr.w   x_vel(a1)
                clr.w   ground_vel(a1)                  ; Stop Knuckles' momentum
                st      (Ctrl_1_locked).w               ; Turn off player control
                clr.w   (Ctrl_1_logical).w              ; Clear buttons
                lea     (ArtKosM_CNZTeleport).l,a1
                move.w  #tiles_to_bytes(ArtTile_CNZTeleport),d2
                jsr     (Queue_Kos_Module).l            ; Load teleporter graphics
                lea     (Normal_palette_line_2+$2).w,a1
                move.l  #$EEE0EC0,(a1)
                move.w  #$EA2,$E(a1)
                move.w  #$E80,$12(a1)                   ; Replace applicable palette entries
                move.l  #Obj_CNZTeleporterMain,(a0)

SKCNZ2Screen_WarpInitReturn:
                rts
; ---------------------------------------------------------------------------

Obj_CNZTeleporterMain:
                tst.b   (Kos_modules_left).w
                bne.s   SKCNZ2Screen_WarpSpawnReturn    ; Don't do anything while art is loading
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   SKCNZ2Screen_WarpSpawnReturn    ; Wait till Knuckles is not in the air
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKCNZ2Screen_WarpSpawnReturn
                move.w  a1,$3C(a0)
                move.l  #Obj_TeleporterBeam,(a1)
                move.w  a0,parent2(a1)
                move.w  #$4A40,d0
                move.w  d0,x_pos(a0)
                move.w  d0,x_pos(a1)
                move.w  #$A38,y_pos(a1)                 ; Set teleporter position/attributes
                moveq   #signextendB(sfx_Charging),d0
                jsr     (Play_SFX).l
                move.l  #SKCNZ2Screen_UpdatePlayerByBeamPhase,(a0)

SKCNZ2Screen_WarpSpawnReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZ2Screen_UpdatePlayerByBeamPhase:
                lea     (Player_1).w,a1
                movea.w $3C(a0),a2
                cmpi.b  #8,$46(a2)
                blt.s   SKCNZ2Screen_BeamPhaseReturn
                beq.s   SKCNZ2Screen_StartWarpRollPose  ; Once beam has expanded halfway. On the first frame this happen, set player state
                cmpi.b  #$18,$46(a2)
                bhs.s   SKCNZ2Screen_FreezePlayerAndRaiseCam
                btst    #0,(Level_frame_counter+1).w
                beq.s   SKCNZ2Screen_BeamPhaseReturn
                subq.w  #1,y_pos(a1)                    ; Raise player slightly
                btst    #1,(Level_frame_counter+1).w
                beq.s   SKCNZ2Screen_BeamPhaseReturn
                moveq   #1,d1
                move.w  x_pos(a1),d0
                cmp.w   x_pos(a0),d0
                beq.s   SKCNZ2Screen_BeamPhaseReturn
                bcs.s   SKCNZ2Screen_StepTowardWarpCenter
                neg.w   d1

SKCNZ2Screen_StepTowardWarpCenter:
                add.w   d1,x_pos(a1)                    ; Move player X towards center of beam X
                bra.s   SKCNZ2Screen_BeamPhaseReturn
; ---------------------------------------------------------------------------

SKCNZ2Screen_FreezePlayerAndRaiseCam:
                move.l  #SKCNZ2Screen_RaiseCameraToIceCap,(a0)  ; When beam has expanded all the way
                move.b  #3,object_control(a1)           ; Stop player animation
                moveq   #0,d0
                move.w  d0,y_pos(a1)                    ; Make player disappear!
                move.b  d0,anim(a1)
                move.b  d0,mapping_frame(a1)
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l
                st      (Scroll_lock).w
                bra.s   SKCNZ2Screen_BeamPhaseReturn
; ---------------------------------------------------------------------------

SKCNZ2Screen_StartWarpRollPose:
                move.b  #1,object_control(a1)           ; Player under object control
                bset    #Status_Roll,status(a1)         ; Set to jumping state
                move.b  #2,anim(a1)                     ; Rolling animation

SKCNZ2Screen_BeamPhaseReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZ2Screen_RaiseCameraToIceCap:
                subi.w  #$10,(Camera_Y_pos).w
                cmpi.w  #$780,(Camera_Y_pos).w
                bhs.s   SKCNZ2Screen_CameraAscentReturn
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #$500,d0                        ; Start Ice Cap
                jmp     (StartNewLevel).l
; ---------------------------------------------------------------------------

SKCNZ2Screen_CameraAscentReturn:
                rts
