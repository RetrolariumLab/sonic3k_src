; Owner: objects/cutscenes/sk
; Responsibility: Carnival Night Knuckles encounters and their local transition helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_CNZ2A:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                lea     SKHCZScene_CNZ1CameraTriggerBounds(pc),a1
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
                dc.w    SKCNZScene_InitFirstSceneAndCamera-CutsceneKnux_CNZ2A_Index
                dc.w    SKCNZScene_AnimateDuringCameraJoin-CutsceneKnux_CNZ2A_Index
                dc.w    SKCNZScene_AnimateAndTickSharedWait-CutsceneKnux_CNZ2A_Index
                dc.w    SKCNZScene_UpdateJumpWithTwoBounces-CutsceneKnux_CNZ2A_Index
                dc.w    SKCNZScene_AnimateAndTickSharedWait-CutsceneKnux_CNZ2A_Index
                dc.w    SKCNZScene_MoveExitAndRestoreScene-CutsceneKnux_CNZ2A_Index
SKCNZScene_FirstOriginalCameraBounds:                   ; used in S3, unused in S&K
                dc.w    $176,  $300, $1B00, $1D00
; ---------------------------------------------------------------------------

SKCNZScene_InitFirstSceneAndCamera:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.l  #SKSceneAnim_KnuxWaitTailFrames1E1F,$30(a0)
                move.l  #SKCNZScene_EndJoinAndStartLaunchPause,$34(a0)
                lea     SKHCZScene_CNZ1BossCameraBounds(pc),a1
                move.b  #mus_Knuckles,boss_saved_mus(a0)
                jsr     (SKEndCamera_FadeAndStartDelay).l
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

SKCNZScene_SavePaletteLine2:
                move.l  (a1)+,(a2)+
                dbf     d6,SKCNZScene_SavePaletteLine2
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     SKSceneData_CNZ2TallSolidChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKCNZScene_AnimateDuringCameraJoin:
                jsr     (Animate_Raw).l
                jmp     (SKEndCamera_TickAndSaveMusic).l
; ---------------------------------------------------------------------------

SKCNZScene_EndJoinAndStartLaunchPause:
                move.b  #4,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #SKCNZScene_LaunchRightWithSharedAnim,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKCNZScene_AnimateAndTickSharedWait:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKCNZScene_LaunchRightWithSharedAnim:
                move.b  #6,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$140,x_vel(a0)
                bra.w   SKAIZScene_ResetSharedJumpAnim
; ---------------------------------------------------------------------------

SKCNZScene_UpdateJumpWithTwoBounces:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   SKCNZScene_FirstJumpUpdateReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKCNZScene_FirstJumpUpdateReturn
                moveq   #0,d0
                move.b  $39(a0),d0
                cmpi.b  #8,d0
                bhs.s   SKCNZScene_EndBouncesAndSetExitJump
                move.l  SKCNZScene_BounceVelocityPairs(pc,d0.w),x_vel(a0)  ; and y_vel
                addq.b  #4,d0
                move.b  d0,$39(a0)
                bchg    #0,render_flags(a0)

SKCNZScene_FirstJumpUpdateReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZScene_EndBouncesAndSetExitJump:
                move.b  #8,routine(a0)
                bclr    #0,render_flags(a0)
                add.w   d1,y_pos(a0)
                move.w  #$3F,$2E(a0)
                move.l  #SKCNZScene_BeginFastRightExitJump,$34(a0)
                bra.w   SKAIZScene_ResetSharedIdleAnim
; ---------------------------------------------------------------------------
SKCNZScene_BounceVelocityPairs:
                dc.w    -$100, -$400
                dc.w    $100, -$400
; ---------------------------------------------------------------------------

SKCNZScene_BeginFastRightExitJump:
                move.b  #$A,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$400,x_vel(a0)
                bra.w   SKAIZScene_ResetSharedJumpAnim
; ---------------------------------------------------------------------------

SKCNZScene_MoveExitAndRestoreScene:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.w   SKAIZScene_SharedSceneReturn
                lea     SKSceneData_CNZ2CameraRestoreChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                move.w  (Camera_stored_max_Y_pos).w,(Camera_target_max_Y_pos).w

SKCNZScene_RestorePaletteAndFadeMusic:
                lea     (Target_palette_line_2).w,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

SKCNZScene_CopySavedPaletteBack:
                move.l  (a1)+,(a2)+
                dbf     d6,SKCNZScene_CopySavedPaletteBack
                lea     (PLC_Monitors).l,a1
                jsr     (Load_PLC_Raw).l
                jsr     (AllocateObject).l
                bne.s   SKCNZScene_ReleaseFirstSceneTracking
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

SKCNZScene_ReleaseFirstSceneTracking:
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SKCNZScene_ResolveInvisibleSolidChild:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   CutsceneKnux_Delete
                move.b  #8,width_pixels(a0)
                moveq   #$13,d1
                move.w  #$100,d2
                move.w  #$200,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull2).l
; ---------------------------------------------------------------------------

SKCNZScene_TickFlashAndSelectBank:
                subq.w  #1,$2E(a0)
                bpl.s   SKCNZScene_FlashUpdateReturn
                moveq   #0,d0
                move.b  $39(a0),d0
                cmpi.b  #6,d0
                bhs.s   SKCNZScene_RestorePaletteIfNeeded
                addq.b  #1,$39(a0)
                add.w   d0,d0
                move.w  SKCNZScene_FlashDelayTable(pc,d0.w),$2E(a0)
                moveq   #0,d1
                btst    #1,d0
                beq.s   SKCNZScene_ChooseFlashPaletteSource
                moveq   #$40,d1

SKCNZScene_ChooseFlashPaletteSource:
                lea     Pal_CNZFlash(pc),a1
                adda.w  d1,a1

; =============== S U B R O U T I N E =======================================

CNZCutsceneSKCopyTwoPaletteLines:
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($40),d0

SKCNZScene_CopyFlashPaletteLines3And4:
                move.l  (a1)+,(a2)+
                dbf     d0,SKCNZScene_CopyFlashPaletteLines3And4

SKCNZScene_FlashUpdateReturn:
                rts
; End of function CNZCutsceneSKCopyTwoPaletteLines

; ---------------------------------------------------------------------------

SKCNZScene_RestorePaletteIfNeeded:
                tst.b   subtype(a0)
                beq.s   SKCNZScene_DeleteFlashActor
                lea     (Pal_CNZ+$20).l,a1
                bsr.s   CNZCutsceneSKCopyTwoPaletteLines

SKCNZScene_DeleteFlashActor:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
SKCNZScene_FlashDelayTable:
                dc.w    8
                dc.w    4
                dc.w    3
                dc.w    2
                dc.w    4
                dc.w    8
                dc.w    8
; ---------------------------------------------------------------------------

CutsceneKnux_CNZ2B:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                lea     SKCNZScene_SecondCameraTriggerBounds(pc),a1
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
                dc.w    SKCNZScene_InitSecondSceneAndLockInput-CutsceneKnux_CNZ2B_Index
                dc.w    SKCNZScene_WaitForAirborneP1AtTrigger-CutsceneKnux_CNZ2B_Index
                dc.w    SKCNZScene_HoldRightUntilThreshold-CutsceneKnux_CNZ2B_Index
                dc.w    SKAIZScene_TickSharedWordWait-CutsceneKnux_CNZ2B_Index
                dc.w    SKAIZScene_UpdateJumpAndBounceOnce-CutsceneKnux_CNZ2B_Index
                dc.w    SKCNZScene_AnimateLandingAndTickDelay-CutsceneKnux_CNZ2B_Index
                dc.w    SKCNZScene_WalkOffscreenAndReleaseP1-CutsceneKnux_CNZ2B_Index
                dc.w    SKCNZScene_ScriptLeftUntilKnuxExits-CutsceneKnux_CNZ2B_Index
SKCNZScene_SecondCameraTriggerBounds:
                dc.w    $720,  $A00, $45C0, $46E0
; ---------------------------------------------------------------------------

SKCNZScene_InitSecondSceneAndLockInput:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                move.b  #$80,(Player_1+object_control).w
                bsr.w   CutsceneSpawnKnucklesMusicFadeTransition
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

SKCNZScene_WaitForAirborneP1AtTrigger:
                lea     (Player_1).w,a1
                cmpi.w  #$4728,x_pos(a1)
                blo.s   SKCNZScene_AirTriggerReturn
                btst    #Status_InAir,status(a1)
                bne.s   SKCNZScene_BeginScriptedRightRun

SKCNZScene_AirTriggerReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZScene_BeginScriptedRightRun:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKCNZScene_HoldRightUntilThreshold:
                move.w  #(button_right_mask<<8)+button_right_mask,(Ctrl_1_logical).w
                cmpi.w  #$4760,(Player_1+x_pos).w
                bhs.s   SKCNZScene_StopP1AndScheduleJump
                rts
; ---------------------------------------------------------------------------

SKCNZScene_StopP1AndScheduleJump:
                move.b  #6,routine(a0)
                clr.w   (Ctrl_1_logical).w
                lea     (Player_1).w,a1
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  #$1F,$2E(a0)
                move.l  #SKCNZScene_JumpAndStartWalkDelay,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKCNZScene_JumpAndStartWalkDelay:
                move.b  #8,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #SKCNZScene_BeginRightwardWalk,$34(a0)
                bra.w   SKAIZScene_SetSharedLeftJumpSpeed
; ---------------------------------------------------------------------------

SKCNZScene_AnimateLandingAndTickDelay:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKCNZScene_BeginRightwardWalk:
                move.b  #$C,routine(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #SKSceneAnim_KnuxTravelLoop,$30(a0)
                rts
; ---------------------------------------------------------------------------

SKCNZScene_WalkOffscreenAndReleaseP1:
                addq.w  #4,x_pos(a0)
                jsr     (Animate_Raw).l
                tst.b   render_flags(a0)
                bmi.w   SKAIZScene_SharedSceneReturn
                move.b  #$E,routine(a0)
                clr.b   (Player_1+object_control).w
                lea     (Pal_CNZ).l,a1
                jsr     (PalLoad_Line1).l
                jsr     (AllocateObject).l
                bne.s   SKCNZScene_SecondSceneMusicReturn
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

SKCNZScene_SecondSceneMusicReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZScene_ScriptLeftUntilKnuxExits:
                move.w  #(button_left_mask<<8)+button_left_mask,(Ctrl_1_logical).w
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$160,d0
                cmp.w   y_pos(a0),d0
                blo.s   SKCNZScene_UnlockAndDeleteSecondScene
                rts
; ---------------------------------------------------------------------------

SKCNZScene_UnlockAndDeleteSecondScene:
                clr.b   (Ctrl_1_locked).w
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; End of function SKCNZScene_ScriptLeftUntilKnuxExits
