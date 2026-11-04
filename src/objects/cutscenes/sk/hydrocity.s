; Owner: objects/cutscenes/sk
; Responsibility: Hydrocity Knuckles cutscene, deletion callback and private children
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_HCZ2:
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   CutsceneKnux_Delete
                lea     SKHCZScene_CameraTriggerBounds(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_HCZ2_Index(pc,d0.w),d1
                jsr     CutsceneKnux_HCZ2_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
CutsceneKnux_HCZ2_Index:
                dc.w    SKHCZScene_InitActorAndCameraBounds-CutsceneKnux_HCZ2_Index
                dc.w    SKHCZScene_WaitForStandingAtRight-CutsceneKnux_HCZ2_Index
                dc.w    SKAIZScene_TickSharedWordWait-CutsceneKnux_HCZ2_Index
                dc.w    SKHCZScene_WalkLeftAndTickPose-CutsceneKnux_HCZ2_Index
                dc.w    SKAIZScene_TickSharedWordWait-CutsceneKnux_HCZ2_Index
                dc.w    SKAIZScene_UpdateJumpAndBounceOnce-CutsceneKnux_HCZ2_Index
                dc.w    SKHCZScene_AnimateUntilOffscreen-CutsceneKnux_HCZ2_Index
SKHCZScene_CameraTriggerBounds:
                dc.w    $540,  $600, $3900, $3940
; ---------------------------------------------------------------------------

CutsceneKnux_Delete:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKHCZScene_InitActorAndCameraBounds:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  (Camera_min_Y_pos).w,(Camera_stored_min_Y_pos).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  #$3940,(Camera_max_X_pos).w
                lea     SKHczActTwoCutscene_ButtonChildSpawnList(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   SKHCZScene_OffsetAfterButtonAttempt
                move.b  #2,subtype(a1)

SKHCZScene_OffsetAfterButtonAttempt:
                addi.w  #$9E,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKHCZScene_WaitForStandingAtRight:
                lea     (Player_1).w,a1
                cmpi.w  #$3990,x_pos(a1)
                blo.s   SKHCZScene_FollowCameraMinima
                tst.b   object_control(a1)
                bne.s   SKHCZScene_FollowCameraMinima
                btst    #Status_OnObj,status(a1)
                bne.s   SKHCZScene_PlayMusicAndWait3Seconds

SKHCZScene_FollowCameraMinima:
                move.w  (Camera_Y_pos).w,(Camera_min_Y_pos).w
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                rts
; ---------------------------------------------------------------------------

SKHCZScene_PlayMusicAndWait3Seconds:
                move.b  #4,routine(a0)
                bsr.w   CutsceneSpawnKnucklesMusicFadeTransition
                move.w  #(3*60)-1,$2E(a0)
                move.l  #SKHCZScene_FaceLeftAndLowerCameraFloor,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKHCZScene_FaceLeftAndLowerCameraFloor:
                move.b  #6,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #$1F,$2E(a0)
                move.l  #SKHCZScene_WaitInPose20BeforeJump,$34(a0)
                move.w  #$5C0,(Camera_min_Y_pos).w
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

SKHCZScene_WalkLeftAndTickPose:
                subq.w  #4,x_pos(a0)
                lea     (SKSceneAnim_KnuxTravelLoop).l,a1
                jsr     (Animate_RawNoSST).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKHCZScene_WaitInPose20BeforeJump:
                move.b  #8,routine(a0)
                move.b  #$20,mapping_frame(a0)
                move.w  #$3F,$2E(a0)
                move.l  #SKHCZScene_TurnAndSelectJump,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKHCZScene_TurnAndSelectJump:
                move.b  #$A,routine(a0)
                bchg    #0,render_flags(a0)
                bra.w   SKAIZScene_SetSharedLeftJumpSpeed
; ---------------------------------------------------------------------------

SKHCZScene_AnimateUntilOffscreen:
                jsr     (Animate_Raw).l
                tst.b   render_flags(a0)
                bmi.w   SKAIZScene_SharedSceneReturn
                lea     (Pal_HCZ2).l,a1
                jsr     (PalLoad_Line1).l
                lea     SKHCZScene_CameraRestoreChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                jsr     (AllocateObject).l
                bne.s   SKHCZScene_ReleaseTrackingAndDelete
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

SKHCZScene_ReleaseTrackingAndDelete:
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
SKHCZScene_CameraRestoreChildren:
                dc.w    2-1
                dc.l    Obj_DecLevStartYGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndXGradual
                dc.b    0,   0
SKHCZScene_CNZ1CameraTriggerBounds:
                dc.w    $176,  $300, $1C00, $1E00
SKHCZScene_CNZ1BossCameraBounds:
                dc.w    $280,  $280, $1D00, $1D00
