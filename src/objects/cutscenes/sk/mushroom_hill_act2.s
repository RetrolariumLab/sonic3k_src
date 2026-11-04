; Owner: objects/cutscenes/sk
; Responsibility: Mushroom Hill second-act Knuckles encounter, motion and scene transition helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_MHZ2:
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   MHZ2Scene_SpawnKnucklesSwitchAndDelete
                cmpi.b  #7,(Last_star_post_hit).w
                bhs.w   CutsceneKnux_Delete
                lea     MHZ1Scene_Act2CameraBoundsAndSplitY(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_MHZ2_Index(pc,d0.w),d1
                jsr     CutsceneKnux_MHZ2_Index(pc,d1.w)
                lea     DPLCPtr_MHZKnuxPress(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------

MHZ2Scene_SpawnKnucklesSwitchAndDelete:
                lea     SKMhzActTwoCutscene_SwitchChildSpawnList(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
CutsceneKnux_MHZ2_Index:
                dc.w    MHZ2Scene_InitBlowerAndCamera-CutsceneKnux_MHZ2_Index
                dc.w    MHZ2Scene_TrackCameraMinimumToTarget-CutsceneKnux_MHZ2_Index
                dc.w    MHZ2Scene_WaitForGroundedOrTimeout-CutsceneKnux_MHZ2_Index
                dc.w    MHZ2Scene_ForcePoseAndCheckLeafCursor-CutsceneKnux_MHZ2_Index
                dc.w    MHZ2Scene_EmitLeavesUntilOffscreen-CutsceneKnux_MHZ2_Index
; ---------------------------------------------------------------------------

MHZ2Scene_InitBlowerAndCamera:
                lea     ObjSlot_CutsceneKnux_MHZ2(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.l  #MHZ2Scene_SetTargetAndLockControllers,$34(a0)
                move.w  (Camera_min_X_pos).w,(Camera_stored_min_X_pos).w
                move.w  (MHZ1Scene_Act2SplitXAndCameraTarget).l,(_unkFAB4).w
                bsr.w   CutsceneSpawnKnucklesMusicFadeTransition
                st      (Events_bg+$16).w
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     SKMhzActTwoCutscene_SwitchChildSpawnList(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MHZ2Scene_TrackCameraMinimumToTarget:
                move.w  (Camera_X_pos).w,d0
                move.w  (_unkFAB4).w,d1
                cmp.w   d1,d0
                bhs.s   MHZ2Scene_SetTargetAndLockControllers
                move.w  d0,(Camera_min_X_pos).w
                rts
; ---------------------------------------------------------------------------

MHZ2Scene_SetTargetAndLockControllers:
                move.w  d1,(Camera_min_X_pos).w
                move.b  #4,routine(a0)
                move.w  #60-1,$2E(a0)
                st      (Ctrl_1_locked).w
                st      (Ctrl_2_locked).w
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

MHZ2Scene_WaitForGroundedOrTimeout:
                subi.w  #1,$2E(a0)
                bmi.s   MHZ2Scene_StartBlowerAndLockActors
                moveq   #0,d0
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   MHZ2Scene_CheckVisibleFollowerReady
                bset    #0,d0

MHZ2Scene_CheckVisibleFollowerReady:
                lea     (Player_2).w,a2
                tst.l   (a2)
                beq.s   MHZ2Scene_MarkFollowerReady
                tst.b   render_flags(a2)
                bpl.s   MHZ2Scene_MarkFollowerReady
                btst    #Status_InAir,status(a2)
                bne.s   MHZ2Scene_StartWhenBothReady

MHZ2Scene_MarkFollowerReady:
                bset    #1,d0

MHZ2Scene_StartWhenBothReady:
                cmpi.b  #3,d0
                beq.s   MHZ2Scene_StartBlowerAndLockActors

MHZ2Scene_BlowerReadinessReturn:
                rts
; ---------------------------------------------------------------------------

MHZ2Scene_StartBlowerAndLockActors:
                move.b  #6,routine(a0)
                move.l  #MHZ2Scene_FinishScriptAndTryP1Lift,$34(a0)
                move.w  #$10,$3E(a0)
                clr.w   $2E(a0)
                move.b  #1,$39(a0)
                lea     (Player_1).w,a1
                bsr.w   MHZBlowerLockAndStopSelectedPlayer
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   MHZ2Scene_BlowerReadinessReturn

; =============== S U B R O U T I N E =======================================

MHZBlowerLockAndStopSelectedPlayer:
                move.b  #$81,object_control(a1)
                move.b  #5,anim(a1)
                jmp     (Stop_Object).l
; End of function MHZBlowerLockAndStopSelectedPlayer

; ---------------------------------------------------------------------------

MHZ2Scene_ForcePoseAndCheckLeafCursor:
                bsr.w   MHZBlower_ApplyPoseToBothPlayers
                cmpi.b  #8,anim_frame(a0)
                blo.s   MHZ2Scene_AnimateBlowerAndTestZ
                moveq   #signextendB(sfx_LeafBlower),d0
                jsr     (Play_SFX_Continuous).l
                bsr.w   MHZBlowerEmitLeafOnReloadedTimer

; The follow-up work depends on the Z flag returned by the raw animation reader
MHZ2Scene_AnimateBlowerAndTestZ:
                lea     SKSceneAnim_MHZ2BlowerSequence(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                beq.s   MHZ2Scene_BlowerAnimReturn
                cmpi.b  #$C,anim_frame(a0)
                bne.s   MHZ2Scene_IncreaseBlowerOnFrame2
                lea     (Player_1).w,a1
                move.b  #$14,anim(a1)
                lea     (Player_2).w,a1
                tst.b   render_flags(a1)
                bpl.s   MHZ2Scene_IncreaseBlowerOnFrame2
                move.b  #$14,anim(a1)

MHZ2Scene_IncreaseBlowerOnFrame2:
                cmpi.b  #2,mapping_frame(a0)
                bne.s   MHZ2Scene_BlowerAnimReturn
                addq.b  #1,$39(a0)
                subq.w  #4,$3E(a0)
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

MHZ2Scene_BlowerAnimReturn:
                rts
; ---------------------------------------------------------------------------

MHZ2Scene_FinishScriptAndTryP1Lift:
                move.b  #8,routine(a0)
                jsr     (AllocateObject).l
                bne.s   MHZ2Scene_TryVisibleFollowerLift
                move.l  #MHZ2Scene_SelectLiftTargetBySubtype,(a1)

MHZ2Scene_TryVisibleFollowerLift:
                tst.b   (Player_2+render_flags).w
                bpl.s   MHZ2Scene_EmitLeavesUntilOffscreen
                jsr     (AllocateObject).l
                bne.s   MHZ2Scene_EmitLeavesUntilOffscreen
                move.l  #MHZ2Scene_SelectLiftTargetBySubtype,(a1)
                move.b  #2,subtype(a1)

MHZ2Scene_EmitLeavesUntilOffscreen:
                tst.b   render_flags(a0)
                bpl.w   SKCNZScene_RestorePaletteAndFadeMusic
                bra.w   MHZBlowerEmitLeafOnReloadedTimer
; ---------------------------------------------------------------------------
; unused
                lea     (Pal_MHZ2).l,a1
                jsr     (PalLoad_Line1).l
                bra.w   SKCNZScene_RestorePaletteAndFadeMusic
; ---------------------------------------------------------------------------

MHZ2Scene_InitLinkedOrStandaloneSwitch:
                lea     SKMhzActTwoCutscene_SwitchAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MHZ2Scene_SetSwitchFrameFromParent,(a0)
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   MHZ2Scene_QueueSwitchArt
                move.l  #Sprite_OnScreen_Test,(a0)
                move.w  #make_art_tile(ArtTile_MHZKnuxSwitch,0,1),art_tile(a0)
                movea.w parent3(a0),a1
                move.w  respawn_addr(a1),respawn_addr(a0)

MHZ2Scene_QueueSwitchArt:
                lea     (ArtKosM_MHZKnuxSwitch).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZKnuxSwitch),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

MHZ2Scene_SetSwitchFrameFromParent:
                movea.w parent3(a0),a1
                clr.b   mapping_frame(a0)
                cmpi.b  #2,mapping_frame(a1)
                bne.s   MHZ2Scene_DrawSwitchIfParentActive
                move.b  #1,mapping_frame(a0)

MHZ2Scene_DrawSwitchIfParentActive:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZ2Scene_InitLeafWithBiasedX:
                lea     SKMhzSceneBossLeaf_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MHZ2Scene_StepLeafAndCullAbove,(a0)
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                cmpi.w  #$140,d0
                blo.s   MHZ2Scene_PlaceLeafAndSetStep
                andi.w  #$3F,d0
                lsl.w   #2,d0

MHZ2Scene_PlaceLeafAndSetStep:
                move.w  (Camera_X_pos_copy).w,d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.w  (Camera_Y_pos_copy).w,d1
                addi.w  #$E8,d1
                move.w  d1,y_pos(a0)
                moveq   #0,d1
                movea.w parent3(a0),a1
                move.b  $39(a1),d1
                add.w   d1,d1
                neg.w   d1
                move.w  d1,y_vel(a0)

MHZ2Scene_StepLeafAndCullAbove:
                move.w  y_vel(a0),d0
                add.w   d0,y_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subq.w  #8,d0
                cmp.w   y_pos(a0),d0
                bhs.w   CutsceneKnux_Delete
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZ2Scene_SelectLiftTargetBySubtype:
                lea     (Player_1).w,a1
                tst.b   subtype(a0)
                beq.s   MHZ2Scene_InitLiftAndLockTarget
                lea     (Player_2).w,a1

MHZ2Scene_InitLiftAndLockTarget:
                move.l  #MHZ2Scene_LiftTargetUntilApex,(a0)
                move.w  a1,$44(a0)
                move.w  #-$1000,y_vel(a0)
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.b  #$81,object_control(a1)
                move.b  #$F,anim(a1)
                bclr    #1,render_flags(a1)
                bset    #7,art_tile(a1)
                st      (Fast_V_scroll_flag).w
                rts
; ---------------------------------------------------------------------------

MHZ2Scene_LiftTargetUntilApex:
                moveq   #signextendB(sfx_LeafBlower),d0
                jsr     (Play_SFX_Continuous).l
                jsr     (MoveSprite_LightGravity).l
                movea.w $44(a0),a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                tst.w   y_vel(a0)
                bmi.w   SKAIZScene_SharedSceneReturn
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                clr.b   object_control(a1)
                bclr    #7,art_tile(a1)
                clr.b   anim(a1)
                move.w  #$10,ground_vel(a1)
                clr.b   (Fast_V_scroll_flag).w
                clr.b   (Events_bg+$16).w
                move.b  #7,(Last_star_post_hit).w
                move.w  #$52A,(Saved_X_pos).w
                move.w  #$5AC,(Saved_Y_pos).w
                jsr     (Save_Level_Data).l
                jmp     (Delete_Current_Sprite).l
