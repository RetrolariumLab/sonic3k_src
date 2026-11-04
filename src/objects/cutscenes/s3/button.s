; Owner: objects/cutscenes/s3
; Responsibility: Cutscene button contact, activation and trigger state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CutsceneButton:
                lea     ObjDat_CutsceneButton(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #S3SceneButton_CheckActorAndDispatchPress,(a0)
                addq.w  #4,y_pos(a0)
                lea     PLC_CutsceneButton(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------
PLC_CutsceneButton: plrlistheader
                plreq   ArtTile_GrayButton, ArtNem_GrayButton
PLC_CutsceneButton_End:
; ---------------------------------------------------------------------------

S3SceneButton_CheckActorAndDispatchPress:
                move.w  (_unkFAA4).w,d0
                beq.s   S3SceneButton_CheckVisibilityAfterPress
                movea.w d0,a1
                lea     S3SceneButton_ActorContactBounds(pc),a2
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                add.w   (a2)+,d0
                cmp.w   d0,d1
                bcs.s   S3SceneButton_CheckVisibilityAfterPress
                add.w   (a2)+,d0
                cmp.w   d0,d1
                bcc.s   S3SceneButton_CheckVisibilityAfterPress
                move.w  y_pos(a0),d0
                move.w  y_pos(a1),d1
                add.w   (a2)+,d0
                cmp.w   d0,d1
                bcs.s   S3SceneButton_CheckVisibilityAfterPress
                add.w   (a2)+,d0
                cmp.w   d0,d1
                bcc.s   S3SceneButton_CheckVisibilityAfterPress
                move.l  #S3SceneButton_DrawPressedOrCull,(a0)
                move.b  #1,mapping_frame(a0)
                st      (_unkFAA9).w
                clr.w   respawn_addr(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  S3SceneButton_PressActionOffsets(pc,d0.w),d0
                jsr     S3SceneButton_PressActionOffsets(pc,d0.w)

S3SceneButton_CheckVisibilityAfterPress:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
S3SceneButton_ActorContactBounds:
                dc.w    -$18,   $30,  -$18,   $30
S3SceneButton_PressActionOffsets:
                dc.w    S3SceneButton_UnlockInputAndExpandCamera-S3SceneButton_PressActionOffsets
                dc.w    S3SceneButton_SetLevelTrigger8-S3SceneButton_PressActionOffsets
                dc.w    S3SceneButton_StartWaterShiftAndTryFlash-S3SceneButton_PressActionOffsets
                dc.w    S3SceneButton_PatchWaterAndTryTubes-S3SceneButton_PressActionOffsets
; ---------------------------------------------------------------------------

S3SceneButton_DrawPressedOrCull:
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

S3SceneButton_UnlockInputAndExpandCamera:
                clr.b   (Ctrl_1_locked).w
                move.w  #$1000,d0
                move.w  d0,(Camera_stored_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                lea     (Child6_IncLevY).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

S3SceneButton_SetLevelTrigger8:
                st      (Level_trigger_array+8).w
                rts
; ---------------------------------------------------------------------------

S3SceneButton_StartWaterShiftAndTryFlash:
                move.w  #$14,(Screen_shake_flag).w
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$100,d0
                move.w  d0,(Mean_water_level).w
                move.w  #$350,(Target_water_level).w
                st      (_unkFAA3).w
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   S3SceneButton_WaterEffectSpawnReturn
                move.l  #S3CNZScene_TickFlashAndSelectBank,(a1)

S3SceneButton_WaterEffectSpawnReturn:
                rts
; ---------------------------------------------------------------------------

S3SceneButton_PatchWaterAndTryTubes:
                move.w  #$14,(Screen_shake_flag).w
                movea.w (Level_layout_main+$40).w,a1
                lea     $8E(a1),a1
                move.w  (Level_layout_header).w,d0
                move.b  #$14,(a1)
                adda.w  d0,a1
                move.b  #$F,(a1)
                adda.w  d0,a1
                move.b  #$F,(a1)
                adda.w  d0,a1
                move.b  #$88,(a1)
                jsr     (AllocateObject).l
                bne.s   S3SceneButton_TrySecondVacuumTube
                move.l  #Obj_CNZVacuumTube,(a1)
                move.w  #$4740,x_pos(a1)
                move.w  #$828,y_pos(a1)
                move.b  #$4C,subtype(a1)

S3SceneButton_TrySecondVacuumTube:
                jsr     (AllocateObject).l
                bne.s   S3SceneButton_VacuumTubeSpawnReturn
                move.l  #Obj_CNZVacuumTube,(a1)
                move.w  #$4740,x_pos(a1)
                move.w  #$A28,y_pos(a1)
                move.b  #$20,subtype(a1)

S3SceneButton_VacuumTubeSpawnReturn:
                rts
