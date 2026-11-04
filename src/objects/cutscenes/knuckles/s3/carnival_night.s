; Owner: objects/cutscenes/knuckles/s3
; Responsibility: Knuckles Carnival Night act-two cutscene variants, trigger logic and scene object records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_CNZ2A:
                lea     S3CNZScene_FirstOriginalCameraBounds(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_CNZ2A_Index(pc,d0.w),d1
                jsr     CutsceneKnux_CNZ2A_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
CutsceneKnux_CNZ2A_Index:
                dc.w    S3CNZScene_InitFirstSceneAndCamera-CutsceneKnux_CNZ2A_Index
                dc.w    S3CNZScene_AnimateDuringCameraJoin-CutsceneKnux_CNZ2A_Index
                dc.w    S3CNZScene_AnimateAndTickSharedWait-CutsceneKnux_CNZ2A_Index
                dc.w    S3CNZScene_UpdateJumpWithTwoBounces-CutsceneKnux_CNZ2A_Index
                dc.w    S3CNZScene_AnimateAndTickSharedWait-CutsceneKnux_CNZ2A_Index
                dc.w    S3CNZScene_MoveExitAndRestoreScene-CutsceneKnux_CNZ2A_Index
S3CNZScene_FirstOriginalCameraBounds:
                dc.w    $176,  $300, $1B00, $1D00
; ---------------------------------------------------------------------------

S3CNZScene_InitFirstSceneAndCamera:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.l  #S3KnuxScene_ChuckleLoopAnim,$30(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #2*60,$2E(a0)
                move.b  #mus_Knuckles,$26(a0)
                move.w  (Camera_min_Y_pos).w,(Camera_stored_min_Y_pos).w
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  (Camera_min_X_pos).w,(Camera_stored_min_X_pos).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  #$280,(Camera_target_max_Y_pos).w
                move.w  #$1D00,$1C(a0)
                move.w  #$1D00,(Camera_max_X_pos).w
                move.l  #S3CNZScene_EndJoinAndStartLaunchPause,$34(a0)
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     S3KnuxScene_CNZTallBarrierChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

S3CNZScene_AnimateDuringCameraJoin:
                jsr     (Animate_Raw).l
                jmp     (S3EndCamera_TickMusicDelay).l
; ---------------------------------------------------------------------------

S3CNZScene_EndJoinAndStartLaunchPause:
                move.b  #4,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #S3CNZScene_LaunchRightWithSharedAnim,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZScene_AnimateAndTickSharedWait:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

S3CNZScene_LaunchRightWithSharedAnim:
                move.b  #6,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$140,x_vel(a0)
                bra.w   S3AIZScene_ResetSharedJumpAnim
; ---------------------------------------------------------------------------

S3CNZScene_UpdateJumpWithTwoBounces:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   S3CNZScene_FirstJumpUpdateReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   S3CNZScene_FirstJumpUpdateReturn
                moveq   #0,d0
                move.b  $39(a0),d0
                cmpi.b  #8,d0
                bhs.s   S3CNZScene_EndBouncesAndSetExitJump
                move.l  S3CNZScene_BounceVelocityPairs(pc,d0.w),x_vel(a0)  ; and y_vel
                addq.b  #4,d0
                move.b  d0,$39(a0)
                bchg    #0,render_flags(a0)

S3CNZScene_FirstJumpUpdateReturn:
                rts
; ---------------------------------------------------------------------------

S3CNZScene_EndBouncesAndSetExitJump:
                move.b  #8,routine(a0)
                bclr    #0,render_flags(a0)
                add.w   d1,y_pos(a0)
                move.w  #$3F,$2E(a0)
                move.l  #S3CNZScene_BeginFastRightExitJump,$34(a0)
                bra.w   S3AIZScene_ResetSharedIdleAnim
; ---------------------------------------------------------------------------
S3CNZScene_BounceVelocityPairs:
                dc.w    -$100, -$400
                dc.w    $100, -$400
; ---------------------------------------------------------------------------

S3CNZScene_BeginFastRightExitJump:
                move.b  #$A,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$400,x_vel(a0)
                bra.w   S3AIZScene_ResetSharedJumpAnim
; ---------------------------------------------------------------------------

S3CNZScene_MoveExitAndRestoreScene:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.w   S3AIZScene_SharedSceneReturn
                lea     (Pal_CNZ).l,a1
                jsr     (PalLoad_Line1).l
                lea     (PLC_Monitors).l,a1
                jsr     (Load_PLC_Raw).l
                lea     S3CNZScene_FirstCameraRestoreChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                move.w  (Camera_stored_max_Y_pos).w,(Camera_target_max_Y_pos).w
                jsr     (AllocateObject).l
                bne.s   S3CNZScene_ReleaseFirstSceneTracking
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

S3CNZScene_ReleaseFirstSceneTracking:
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
S3CNZScene_FirstCameraRestoreChildren:
                dc.w    3-1
                dc.l    Obj_DecLevStartYGradual
                dc.b    0,   0
                dc.l    Obj_DecLevStartXGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndXGradual
                dc.b    0,   0
; ---------------------------------------------------------------------------

S3CNZScene_ResolveInvisibleSolidChild:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   S3CNZScene_DeleteFirstSolidChild
                move.b  #8,width_pixels(a0)
                moveq   #$13,d1
                move.w  #$100,d2
                move.w  #$200,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull2).l
; ---------------------------------------------------------------------------

S3CNZScene_DeleteFirstSolidChild:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3CNZScene_TickFlashAndSelectBank:
                subq.w  #1,$2E(a0)
                bpl.s   S3CNZScene_FlashUpdateReturn
                moveq   #0,d0
                move.b  $39(a0),d0
                cmpi.b  #6,d0
                bhs.s   S3CNZScene_RestorePaletteIfNeeded
                addq.b  #1,$39(a0)
                add.w   d0,d0
                move.w  S3CNZScene_FlashDelayTable(pc,d0.w),$2E(a0)
                moveq   #0,d1
                btst    #1,d0
                beq.s   S3CNZScene_ChooseFlashPaletteSource
                moveq   #$40,d1

S3CNZScene_ChooseFlashPaletteSource:
                lea     Pal_CNZFlash(pc),a1
                adda.w  d1,a1

; =============== S U B R O U T I N E =======================================

CNZCutsceneS3CopyTwoPaletteLines:
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($40),d0

S3CNZScene_CopyFlashPaletteLines3And4:
                move.l  (a1)+,(a2)+
                dbf     d0,S3CNZScene_CopyFlashPaletteLines3And4

S3CNZScene_FlashUpdateReturn:
                rts
; End of function CNZCutsceneS3CopyTwoPaletteLines

; ---------------------------------------------------------------------------

S3CNZScene_RestorePaletteIfNeeded:
                tst.b   subtype(a0)
                beq.s   S3CNZScene_DeleteFlashActor
                lea     (Pal_CNZ+$20).l,a1
                bsr.s   CNZCutsceneS3CopyTwoPaletteLines

S3CNZScene_DeleteFlashActor:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
S3CNZScene_FlashDelayTable:
                dc.w    8
                dc.w    4
                dc.w    3
                dc.w    2
                dc.w    4
                dc.w    8
                dc.w    8
; ---------------------------------------------------------------------------

CutsceneKnux_CNZ2B:
                lea     S3CNZScene_SecondCameraTriggerBounds(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_CNZ2B_Index(pc,d0.w),d1
                jsr     CutsceneKnux_CNZ2B_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
CutsceneKnux_CNZ2B_Index:
                dc.w    S3CNZScene_InitSecondSceneAndLockInput-CutsceneKnux_CNZ2B_Index
                dc.w    S3CNZScene_WaitForAirborneP1AtTrigger-CutsceneKnux_CNZ2B_Index
                dc.w    S3CNZScene_HoldRightUntilThreshold-CutsceneKnux_CNZ2B_Index
                dc.w    S3AIZScene_TickSharedWordWait-CutsceneKnux_CNZ2B_Index
                dc.w    S3AIZScene_UpdateJumpAndBounceOnce-CutsceneKnux_CNZ2B_Index
                dc.w    S3CNZScene_AnimateLandingAndTickDelay-CutsceneKnux_CNZ2B_Index
                dc.w    S3CNZScene_WalkOffscreenAndReleaseP1-CutsceneKnux_CNZ2B_Index
                dc.w    S3CNZScene_ScriptLeftUntilKnuxExits-CutsceneKnux_CNZ2B_Index
S3CNZScene_SecondCameraTriggerBounds:
                dc.w    $720,  $A00, $45C0, $46E0
; ---------------------------------------------------------------------------

S3CNZScene_InitSecondSceneAndLockInput:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                move.b  #$80,(Player_1+object_control).w
                bsr.w   SpawnKnucklesCutsceneMusicTransition
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

S3CNZScene_WaitForAirborneP1AtTrigger:
                lea     (Player_1).w,a1
                cmpi.w  #$4728,x_pos(a1)
                blo.s   S3CNZScene_AirTriggerReturn
                btst    #Status_InAir,status(a1)
                bne.s   S3CNZScene_BeginScriptedRightRun

S3CNZScene_AirTriggerReturn:
                rts
; ---------------------------------------------------------------------------

S3CNZScene_BeginScriptedRightRun:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZScene_HoldRightUntilThreshold:
                move.w  #(button_right_mask<<8)+button_right_mask,(Ctrl_1_logical).w
                cmpi.w  #$4760,(Player_1+x_pos).w
                bhs.s   S3CNZScene_StopP1AndScheduleJump
                rts
; ---------------------------------------------------------------------------

S3CNZScene_StopP1AndScheduleJump:
                move.b  #6,routine(a0)
                clr.w   (Ctrl_1_logical).w
                lea     (Player_1).w,a1
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  #$1F,$2E(a0)
                move.l  #S3CNZScene_JumpAndStartWalkDelay,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZScene_JumpAndStartWalkDelay:
                move.b  #8,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #S3CNZScene_BeginRightwardWalk,$34(a0)
                bra.w   S3AIZScene_SetSharedLeftJumpSpeed
; ---------------------------------------------------------------------------

S3CNZScene_AnimateLandingAndTickDelay:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

S3CNZScene_BeginRightwardWalk:
                move.b  #$C,routine(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #S3KnuxScene_RunAnim,$30(a0)
                rts
; ---------------------------------------------------------------------------

S3CNZScene_WalkOffscreenAndReleaseP1:
                addq.w  #4,x_pos(a0)
                jsr     (Animate_Raw).l
                tst.b   render_flags(a0)
                bmi.w   S3AIZScene_SharedSceneReturn
                move.b  #$E,routine(a0)
                clr.b   (Player_1+object_control).w
                lea     (Pal_CNZ).l,a1
                jsr     (PalLoad_Line1).l
                jsr     (AllocateObject).l
                bne.s   S3CNZScene_SecondSceneMusicReturn
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

S3CNZScene_SecondSceneMusicReturn:
                rts
; ---------------------------------------------------------------------------

S3CNZScene_ScriptLeftUntilKnuxExits:
                move.w  #(button_left_mask<<8)+button_left_mask,(Ctrl_1_logical).w
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$160,d0
                cmp.w   y_pos(a0),d0
                blo.s   S3CNZScene_UnlockAndDeleteSecondScene
                rts
; ---------------------------------------------------------------------------

S3CNZScene_UnlockAndDeleteSecondScene:
                clr.b   (Ctrl_1_locked).w
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; End of function S3CNZScene_ScriptLeftUntilKnuxExits
