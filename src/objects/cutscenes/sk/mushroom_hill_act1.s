; Owner: objects/cutscenes/sk
; Responsibility: Mushroom Hill first-act Knuckles encounter, switch actor and attached scene objects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_MHZ1:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_MHZ1_Index(pc,d0.w),d1
                jsr     CutsceneKnux_MHZ1_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
CutsceneKnux_MHZ1_Index:
                dc.w    MHZ1Scene_InitKnucklesAndPalette-CutsceneKnux_MHZ1_Index
                dc.w    MHZ1Scene_TickApproachDelay-CutsceneKnux_MHZ1_Index
                dc.w    MHZ1Scene_ApproachToX360-CutsceneKnux_MHZ1_Index
                dc.w    MHZ1Scene_WaitForPeerCompletion-CutsceneKnux_MHZ1_Index
                dc.w    MHZ1Scene_ApproachParentMinus28-CutsceneKnux_MHZ1_Index
                dc.w    MHZ1Scene_MoveAndRunFloorCallback-CutsceneKnux_MHZ1_Index
                dc.w    MHZ1Scene_MoveAndRunFloorCallback-CutsceneKnux_MHZ1_Index
                dc.w    MHZ1Scene_ExitWhilePreviouslyVisible-CutsceneKnux_MHZ1_Index
; ---------------------------------------------------------------------------

MHZ1Scene_InitKnucklesAndPalette:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bclr    #7,art_tile(a0)
                move.w  #(2*60)-1,$2E(a0)
                move.l  #SKSceneAnim_KnuxTravelLoop,$30(a0)
                move.w  #$2B0,x_pos(a0)
                move.w  #$66C,y_pos(a0)
                move.w  #$200,x_vel(a0)
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

MHZ1Scene_SavePaletteAndLoadScene:
                move.l  (a1)+,(a2)+
                dbf     d6,MHZ1Scene_SavePaletteAndLoadScene
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

MHZ1Scene_TickApproachDelay:
                subq.w  #1,$2E(a0)
                bpl.s   MHZ1Scene_ApproachDelayReturn
                move.b  #4,routine(a0)

MHZ1Scene_ApproachDelayReturn:
                rts
; ---------------------------------------------------------------------------

MHZ1Scene_ApproachToX360:
                cmpi.w  #$360,x_pos(a0)
                bhs.s   MHZ1Scene_SpawnPeerAndWait
                jsr     (Animate_Raw).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

MHZ1Scene_SpawnPeerAndWait:
                move.b  #6,routine(a0)
                lea     SKSceneData_MHZ1PeeringChildren(pc),a2
                jsr     (CreateChild6_Simple).l

MHZ1Scene_WaitForPeerCompletion:
                btst    #3,$38(a0)
                bne.s   MHZ1Scene_BeginFollowParent
                rts
; ---------------------------------------------------------------------------

MHZ1Scene_BeginFollowParent:
                move.b  #8,routine(a0)

MHZ1Scene_ApproachParentMinus28:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                subi.w  #$28,d0
                cmp.w   x_pos(a0),d0
                bls.s   MHZ1Scene_ClampApproachAndStartJump
                rts
; ---------------------------------------------------------------------------

MHZ1Scene_ClampApproachAndStartJump:
                move.w  d0,x_pos(a0)
                move.b  #$A,routine(a0)
                move.b  #$17,y_radius(a0)
                move.w  #$100,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                move.l  #MHZ1Scene_FirstLandingBeginBounce,$34(a0)
                lea     SKKnucklesCutscene_LeapPhaseBodyLoop(pc),a1
                jsr     (Set_Raw_Animation).l

MHZ1Scene_MoveAndRunFloorCallback:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite).l
                jsr     (ObjHitFloor_DoRoutine).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZ1Scene_FirstLandingBeginBounce:
                move.b  #$C,routine(a0)
                move.b  #$13,y_radius(a0)
                move.w  #-$300,y_vel(a0)
                move.l  #MHZ1Scene_SecondLandingBeginExit,$34(a0)
                rts
; ---------------------------------------------------------------------------

MHZ1Scene_SecondLandingBeginExit:
                move.b  #$E,routine(a0)
                move.w  #$200,x_vel(a0)
                clr.w   y_vel(a0)
                lea     SKSceneAnim_KnuxTravelLoop(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

MHZ1Scene_ExitWhilePreviouslyVisible:
                tst.b   render_flags(a0)
                bpl.w   SKCNZScene_RestorePaletteAndFadeMusic
                jsr     (Animate_Raw).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

Obj_MHZ1CutsceneKnuckles:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                tst.b   (Last_star_post_hit).w
                bne.w   CutsceneKnux_Delete
                tst.w   (SK_alone_flag).w
                bne.w   CutsceneKnux_Delete
                lea     (Player_1).w,a1
                moveq   #0,d0
                move.b  (_unkFAB8).w,d0
                move.w  MHZ1CutsceneKnuckles_Index(pc,d0.w),d0
                jmp     MHZ1CutsceneKnuckles_Index(pc,d0.w)
; ---------------------------------------------------------------------------
MHZ1CutsceneKnuckles_Index:
                dc.w    MHZ1Scene_StartControllerAndTryFollower-MHZ1CutsceneKnuckles_Index
                dc.w    MHZ1Scene_CheckSelectedActorStopX-MHZ1CutsceneKnuckles_Index
                dc.w    MHZ1Scene_WaitForGroundedP1-MHZ1CutsceneKnuckles_Index
                dc.w    MHZ1Scene_TickForcedDownDelay-MHZ1CutsceneKnuckles_Index
                dc.w    MHZ1Scene_PanCameraDownTo5B0-MHZ1CutsceneKnuckles_Index
                dc.w    MHZ1Scene_ControllerWaitReturn-MHZ1CutsceneKnuckles_Index
                dc.w    MHZ1Scene_ReleaseInputsAndSaveCheckpoint-MHZ1CutsceneKnuckles_Index
; ---------------------------------------------------------------------------

MHZ1Scene_StartControllerAndTryFollower:
                move.b  #2,(_unkFAB8).w
                tst.l   (Player_2).w
                beq.s   MHZ1Scene_CheckSelectedActorStopX
                jsr     (AllocateObject).l
                bne.s   MHZ1Scene_CheckSelectedActorStopX
                move.l  #MHZ1Scene_WaitBeforeLockingP2,(a1)

MHZ1Scene_CheckSelectedActorStopX:
                move.w  #$389,d0
                cmp.w   x_pos(a1),d0
                bls.s   MHZ1Scene_ClampActorAndLockP1
                rts
; ---------------------------------------------------------------------------

MHZ1Scene_ClampActorAndLockP1:
                move.w  d0,x_pos(a1)
                move.b  #4,(_unkFAB8).w
                bclr    #0,render_flags(a1)
                bclr    #0,status(a1)
                st      (Ctrl_1_locked).w
                clr.w   (Ctrl_1_logical).w
                jsr     (Stop_Object).l
                bra.w   CutsceneSpawnKnucklesMusicFadeTransition
; ---------------------------------------------------------------------------

MHZ1Scene_WaitForGroundedP1:
                btst    #Status_InAir,status(a1)
                beq.s   MHZ1Scene_SetCameraCueDelay
                rts
; ---------------------------------------------------------------------------

MHZ1Scene_SetCameraCueDelay:
                move.b  #6,(_unkFAB8).w
                move.w  #$20,$2E(a0)

MHZ1Scene_TickForcedDownDelay:
                subq.w  #1,$2E(a0)
                bmi.s   MHZ1Scene_LockScrollAndForceDown
                rts
; ---------------------------------------------------------------------------

MHZ1Scene_LockScrollAndForceDown:
                move.b  #8,(_unkFAB8).w
                st      (Scroll_lock).w
                move.w  #(button_down_mask<<8)|button_down_mask,(Ctrl_1_logical).w

MHZ1Scene_PanCameraDownTo5B0:
                addq.w  #2,(Camera_Y_pos).w
                cmpi.w  #$5B0,(Camera_Y_pos).w
                bhs.s   MHZ1Scene_SetWaitingPhaseA
                rts
; ---------------------------------------------------------------------------

MHZ1Scene_SetWaitingPhaseA:
                move.b  #$A,(_unkFAB8).w

MHZ1Scene_ControllerWaitReturn:
                rts
; ---------------------------------------------------------------------------

MHZ1Scene_ReleaseInputsAndSaveCheckpoint:
                clr.b   (_unkFAB8).w
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w
                clr.b   (Scroll_lock).w
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                move.b  #5,(Player_2+anim).w
                move.b  #1,(Last_star_post_hit).w
                move.w  #$190,(Saved_X_pos).w
                move.w  #$56C,(Saved_Y_pos).w
                jsr     (Save_Level_Data).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

MHZ1Scene_WaitBeforeLockingP2:
                lea     (Player_2).w,a1
                cmpi.b  #4,(_unkFAB8).w
                bhs.s   MHZ1Scene_SetFollowerHelperXAndLockP2
                move.w  #$371,d0
                cmp.w   x_pos(a1),d0
                bls.s   MHZ1Scene_SetFollowerHelperXAndLockP2
                rts
; ---------------------------------------------------------------------------

MHZ1Scene_SetFollowerHelperXAndLockP2:
                move.w  d0,x_pos(a0)
                move.l  #MHZ1Scene_HoldOrResetFollowerControl,(a0)
                st      (Ctrl_2_locked).w
                clr.w   (Ctrl_2_logical).w
                jsr     (Stop_Object).l

MHZ1Scene_HoldOrResetFollowerControl:
                lea     (Player_2).w,a1
                move.b  (_unkFAB8).w,d0
                beq.s   MHZ1Scene_ReleaseP2AndDeleteHelper
                cmpi.b  #4,(_unkFAB8).w
                blo.s   MHZ1Scene_ResetFollowerWaitIfOffscreen
                move.w  #$371,d0
                cmp.w   x_pos(a1),d0
                bhi.s   MHZ1Scene_FollowerControlReturn
                move.b  #8,anim(a1)
                jmp     (Stop_Object).l
; ---------------------------------------------------------------------------

MHZ1Scene_ResetFollowerWaitIfOffscreen:
                tst.b   render_flags(a1)
                bmi.s   MHZ1Scene_FollowerControlReturn
                move.l  #MHZ1Scene_WaitBeforeLockingP2,(a0)
                clr.b   (Ctrl_2_locked).w
                clr.w   (Ctrl_2_logical).w

MHZ1Scene_FollowerControlReturn:
                rts
; ---------------------------------------------------------------------------

MHZ1Scene_ReleaseP2AndDeleteHelper:
                clr.b   (Ctrl_2_locked).w
                clr.w   (Ctrl_2_logical).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_MHZ1CutsceneButton:
                lea     ObjDat_MHZ1CutsceneButton(pc),a1
                jsr     (SetUp_ObjAttributes).l
                lea     SKMhzActOneCutscene_DoorSpawnList(pc),a2
                jsr     (CreateChild6_Simple).l
                move.l  #MHZ1Scene_TestStandingAndToggleDoor,(a0)
                tst.b   (Last_star_post_hit).w
                bne.s   MHZ1Scene_DrawInitializedButton
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   MHZ1Scene_DrawInitializedButton
                move.l  #MHZ1Scene_WaitForPhaseAToSpawnActor,(a0)

MHZ1Scene_DrawInitializedButton:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZ1Scene_WaitForPhaseAToSpawnActor:
                cmpi.b  #$A,(_unkFAB8).w
                bhs.s   MHZ1Scene_QueueArtAndTryActorChild
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZ1Scene_QueueArtAndTryActorChild:
                move.l  #MHZ1Scene_PressWhenActorEntersRange,(a0)
                lea     (ArtKosM_MHZKnuxPeer).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZKnuxPeer),d2
                jsr     (Queue_Kos_Module).l
                lea     SKSceneData_MHZ1KnuxDispatcherChildren(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   MHZ1Scene_PressWhenActorEntersRange
                move.b  #$1C,subtype(a1)

MHZ1Scene_PressWhenActorEntersRange:
                move.w  (_unkFAA4).w,d0
                beq.s   MHZ1Scene_DrawButtonAfterActorCheck
                movea.w d0,a1
                lea     SKSceneButton_KnucklesContactBounds(pc),a2
                jsr     (Check_InMyRange).l
                beq.s   MHZ1Scene_DrawButtonAfterActorCheck
                move.l  #MHZ1Scene_ClearPulseAndWaitRelease,(a0)
                move.w  #1,$2E(a0)
                move.b  #1,mapping_frame(a0)
                bset    #1,$38(a0)
                st      (_unkFAA9).w
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

MHZ1Scene_DrawButtonAfterActorCheck:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZ1Scene_ClearPulseAndWaitRelease:
                bclr    #1,$38(a0)
                subq.w  #1,$2E(a0)
                bpl.s   MHZ1Scene_DrawAutoPressedButton
                move.l  #Wait_Draw,(a0)
                move.w  #$5F,$2E(a0)
                move.l  #MHZ1Scene_SignalReleaseAndReuseButton,$34(a0)
                move.b  #0,mapping_frame(a0)

MHZ1Scene_DrawAutoPressedButton:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZ1Scene_SignalReleaseAndReuseButton:
                move.b  #$C,(_unkFAB8).w
                move.l  #MHZ1Scene_TestStandingAndToggleDoor,(a0)
                rts
; ---------------------------------------------------------------------------

MHZ1Scene_TestStandingAndToggleDoor:
                bsr.w   CutsceneKnucklesSolidThinWrapper
                move.b  status(a0),d1
                andi.b  #standing_mask,d1
                beq.s   MHZ1Scene_DrawOrCullReusableButton
                move.l  #MHZ1Scene_HoldButtonWhileStanding,(a0)
                move.b  #1,mapping_frame(a0)
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l
                btst    #2,$38(a0)
                bne.s   MHZ1Scene_DrawOrCullReusableButton
                bset    #1,$38(a0)
                not.b   (_unkFAA9).w
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

MHZ1Scene_DrawOrCullReusableButton:
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

MHZ1Scene_HoldButtonWhileStanding:
                bclr    #1,$38(a0)
                bsr.w   CutsceneKnucklesSolidThinWrapper
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   MHZ1Scene_DrawOrCullHeldButton
                move.l  #MHZ1Scene_TestStandingAndToggleDoor,(a0)
                move.b  #0,mapping_frame(a0)

MHZ1Scene_DrawOrCullHeldButton:
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

MHZ1Scene_InitPeerAndStartEightStepRun:
                lea     SKSceneData_MHZ1PeeringAttrs(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MHZ1Scene_MovePeerAndTickCallback,(a0)
                move.w  #$374,x_pos(a0)
                move.w  #$66C,y_pos(a0)
                move.w  #$200,x_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #MHZ1Scene_SetPeerAnimAndPriority,$34(a0)

MHZ1Scene_MovePeerAndTickCallback:
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZ1Scene_SetPeerAnimAndPriority:
                move.l  #MHZ1Scene_AnimatePeerWithCallback,(a0)
                move.l  #MHZ1Scene_ReversePeerAndSetSignalDelay,$34(a0)
                bset    #7,art_tile(a0)
                rts
; ---------------------------------------------------------------------------

MHZ1Scene_AnimatePeerWithCallback:
                lea     SKSceneAnim_MHZ1PeeringSequence(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZ1Scene_ReversePeerAndSetSignalDelay:
                move.l  #MHZ1Scene_MovePeerAndTickCallback,(a0)
                move.w  #-$400,x_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #MHZ1Scene_SignalPeerDoneAndDelete,$34(a0)
                bclr    #7,art_tile(a0)
                rts
; ---------------------------------------------------------------------------

MHZ1Scene_SignalPeerDoneAndDelete:
                movea.w parent3(a0),a1
                bset    #3,$38(a1)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

MHZ1Scene_InitDoorAndLinkButton:
                lea     SKMhzActOneCutscene_DoorAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                movea.w parent3(a0),a1
                move.w  a0,$44(a1)
                move.l  #MHZ1Scene_CheckDoorPulseAndAutoReset,(a0)
                move.w  #$390,x_pos(a0)
                move.w  #$620,y_pos(a0)
                tst.b   (_unkFAA9).w
                beq.s   MHZ1Scene_CheckDoorPulseAndAutoReset
                addi.w  #$40,y_pos(a0)

MHZ1Scene_CheckDoorPulseAndAutoReset:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   MHZ1Scene_BeginDoorMoveAndMarkBusy
                jsr     (CutsceneKnucklesSolidTallWrapper).l
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                tst.b   (_unkFAA9).w
                beq.s   MHZ1Scene_DrawDoorIfParentActive
                tst.w   d0
                bne.s   MHZ1Scene_DrawDoorIfParentActive
                cmpi.w  #$40,d2
                bhs.s   MHZ1Scene_DrawDoorIfParentActive
                cmpi.w  #$60,d3
                blo.s   MHZ1Scene_ClearDoorFlagForUpwardReset

MHZ1Scene_DrawDoorIfParentActive:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZ1Scene_ClearDoorFlagForUpwardReset:
                clr.b   (_unkFAA9).w

MHZ1Scene_BeginDoorMoveAndMarkBusy:
                move.l  #MHZ1Scene_MoveDoorAndResolveSolid,(a0)
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                move.w  #$100,d0
                tst.b   (_unkFAA9).w
                bne.s   MHZ1Scene_SetDoorDirectionAndDelay
                neg.w   d0

MHZ1Scene_SetDoorDirectionAndDelay:
                move.w  d0,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #MHZ1Scene_ResetDoorAndClearBusy,$34(a0)

MHZ1Scene_MoveDoorAndResolveSolid:
                jsr     (MoveSprite2).l
                jsr     (CutsceneKnucklesSolidTallWrapper).l
                jsr     (Obj_Wait).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZ1Scene_ResetDoorAndClearBusy:
                move.l  #MHZ1Scene_CheckDoorPulseAndAutoReset,(a0)
                movea.w parent3(a0),a1
                bclr    #2,$38(a1)
                rts
; ---------------------------------------------------------------------------
MHZ1Scene_Act2CameraBoundsAndSplitY:
                dc.w    $648,  $848
                dc.w    $2D0,  $4D0
                dc.w    $748,  $748
MHZ1Scene_Act2SplitXAndCameraTarget:
                dc.w    $3D0,  $3D0
