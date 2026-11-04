; Owner: objects/cutscenes/sk
; Responsibility: Generic cutscene button and Carnival Night water-level cork or switch actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CutsceneButton:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                lea     ObjDat_CutsceneButton(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKSceneButton_CheckKnucklesAndDispatch,(a0)
                addq.w  #4,y_pos(a0)
                lea     PLC_CutsceneButton(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------
PLC_CutsceneButton: plrlistheader
                plreq   ArtTile_GrayButton, ArtNem_GrayButton
PLC_CutsceneButton_End:
; ---------------------------------------------------------------------------

SKSceneButton_CheckKnucklesAndDispatch:
                move.w  (SceneControllerObjectAddress).w,d0
                beq.s   SKSceneButton_DrawUnpressedOrDelete
                movea.w d0,a1
                lea     SKSceneButton_KnucklesContactBounds(pc),a2
                jsr     (Check_InMyRange).l
                beq.s   SKSceneButton_DrawUnpressedOrDelete
                move.l  #SKSceneButton_DrawPressedOrCull,(a0)
                move.b  #1,mapping_frame(a0)
                st      (SceneOutcomeOrActorReadySignal).w
                clr.w   respawn_addr(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SKCutsceneButton_PressActionOffsets(pc,d0.w),d0
                jsr     SKCutsceneButton_PressActionOffsets(pc,d0.w)

SKSceneButton_DrawUnpressedOrDelete:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
SKCutsceneButton_PressActionOffsets:
                dc.w    SKSceneButton_UnlockInputAndExpandCamera-SKCutsceneButton_PressActionOffsets
                dc.w    SKCutsceneButton_SetSceneTriggerEight-SKCutsceneButton_PressActionOffsets
                dc.w    SKSceneButton_StartWaterRiseAndTryGeyser-SKCutsceneButton_PressActionOffsets
                dc.w    SKSceneButton_PatchWaterAndTryTubes-SKCutsceneButton_PressActionOffsets
SKSceneButton_KnucklesContactBounds:
                dc.w    -$18,   $30,  -$18,   $30
; ---------------------------------------------------------------------------

SKSceneButton_DrawPressedOrCull:
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

SKSceneButton_UnlockInputAndExpandCamera:
                clr.b   (Ctrl_1_locked).w
                move.w  #$1000,d0
                move.w  d0,(Camera_stored_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                lea     (Child6_IncLevY).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

SKCutsceneButton_SetSceneTriggerEight:
                st      (Level_trigger_array+8).w
                rts
; ---------------------------------------------------------------------------

SKSceneButton_StartWaterRiseAndTryGeyser:
                move.w  #$14,(Screen_shake_flag).w
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$100,d0
                move.w  d0,(Mean_water_level).w
                move.w  #$350,(Target_water_level).w
                st      (ZoneButtonRequestOrBridgeReleaseSignal).w
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   SKSceneButton_WaterEffectSpawnReturn
                move.l  #SKCNZScene_TickFlashAndSelectBank,(a1)

SKSceneButton_WaterEffectSpawnReturn:
                rts
; ---------------------------------------------------------------------------

SKSceneButton_PatchWaterAndTryTubes:
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
                bne.s   SKSceneButton_TrySecondVacuumTube
                move.l  #Obj_CNZVacuumTube,(a1)
                move.w  #$4740,x_pos(a1)
                move.w  #$828,y_pos(a1)
                move.b  #$4C,subtype(a1)

SKSceneButton_TrySecondVacuumTube:
                jsr     (AllocateObject).l
                bne.s   SKSceneButton_VacuumTubeSpawnReturn
                move.l  #Obj_CNZVacuumTube,(a1)
                move.w  #$4740,x_pos(a1)
                move.w  #$A28,y_pos(a1)
                move.b  #$20,subtype(a1)

SKSceneButton_VacuumTubeSpawnReturn:
                rts
; ---------------------------------------------------------------------------

Obj_CNZWaterLevelCorkFloor:
                jsr     (Obj_WaitOffscreen).l
                move.l  #SKSceneButton_CheckWaterCorkBreak,(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKSceneButton_CheckWaterCorkBreak
                move.l  #Obj_CorkFloor,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  #1,subtype(a1)
                move.w  a1,$44(a0)

SKSceneButton_CheckWaterCorkBreak:
                movea.w $44(a0),a1
                cmpi.l  #SKCork_MoveFragmentAndApplyGravity,(a1)
                beq.s   SKSceneButton_LowerWaterAfterCorkBreak
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKSceneButton_LowerWaterAfterCorkBreak:
                tst.b   (ZoneEventLatchOrBossReleaseSignal).w
                bne.s   SKSceneButton_DeleteCorkController
                st      (ZoneEventLatchOrBossReleaseSignal).w
                move.w  #$958,(Target_water_level).w

SKSceneButton_DeleteCorkController:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_CNZWaterLevelButton:
                lea     ObjDat_CutsceneButton(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKSceneButton_ApplyStandingFrameAndRise,(a0)
                addq.w  #4,y_pos(a0)
                lea     PLC_CutsceneButton(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

SKSceneButton_ApplyStandingFrameAndRise:
                bsr.w   CutsceneKnucklesSolidThinWrapper
                move.b  #0,mapping_frame(a0)
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKSceneButton_DrawOrCullWaterButton
                move.b  #1,mapping_frame(a0)
                tst.b   (ZoneButtonRequestOrBridgeReleaseSignal).w
                beq.s   SKSceneButton_DrawOrCullWaterButton
                clr.b   (ZoneButtonRequestOrBridgeReleaseSignal).w
                move.w  #$A58,(Target_water_level).w
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   SKSceneButton_DrawOrCullWaterButton
                move.l  #SKCNZScene_TickFlashAndSelectBank,(a1)
                st      subtype(a1)

SKSceneButton_DrawOrCullWaterButton:
                jmp     (Sprite_OnScreen_Test).l
