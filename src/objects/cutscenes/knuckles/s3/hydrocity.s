; Owner: objects/cutscenes/knuckles/s3
; Responsibility: Knuckles Hydrocity act-two cutscene state and scene object records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_HCZ2:
                lea     S3HCZScene_CameraTriggerBounds(pc),a1
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
                dc.w    S3HCZScene_InitActorAndCameraBounds-CutsceneKnux_HCZ2_Index
                dc.w    S3HCZScene_WaitForStandingAtRight-CutsceneKnux_HCZ2_Index
                dc.w    S3AIZScene_TickSharedWordWait-CutsceneKnux_HCZ2_Index
                dc.w    S3HCZScene_WalkLeftAndTickPose-CutsceneKnux_HCZ2_Index
                dc.w    S3AIZScene_TickSharedWordWait-CutsceneKnux_HCZ2_Index
                dc.w    S3AIZScene_UpdateJumpAndBounceOnce-CutsceneKnux_HCZ2_Index
                dc.w    S3HCZScene_AnimateUntilOffscreen-CutsceneKnux_HCZ2_Index
S3HCZScene_CameraTriggerBounds:
                dc.w    $540,  $600, $3900, $3940
; ---------------------------------------------------------------------------

S3HCZScene_InitActorAndCameraBounds:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  (Camera_min_Y_pos).w,(Camera_stored_min_Y_pos).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  #$3940,(Camera_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

S3HCZScene_WaitForStandingAtRight:
                lea     (Player_1).w,a1
                cmpi.w  #$3990,x_pos(a1)
                blo.s   S3HCZScene_FollowCameraMinima
                tst.b   object_control(a1)
                bne.s   S3HCZScene_FollowCameraMinima
                btst    #Status_OnObj,status(a1)
                bne.s   S3HCZScene_PlayMusicAndWait3Seconds

S3HCZScene_FollowCameraMinima:
                move.w  (Camera_Y_pos).w,(Camera_min_Y_pos).w
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                rts
; ---------------------------------------------------------------------------

S3HCZScene_PlayMusicAndWait3Seconds:
                move.b  #4,routine(a0)
                bsr.w   SpawnKnucklesCutsceneMusicTransition
                move.w  #(3*60)-1,$2E(a0)
                move.l  #S3HCZScene_FaceLeftAndLowerCameraFloor,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3HCZScene_FaceLeftAndLowerCameraFloor:
                move.b  #6,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #$1F,$2E(a0)
                move.l  #S3HCZScene_WaitInPose20BeforeJump,$34(a0)
                move.w  #$5C0,(Camera_min_Y_pos).w
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

S3HCZScene_WalkLeftAndTickPose:
                subq.w  #4,x_pos(a0)
                lea     (S3KnuxScene_RunAnim).l,a1
                jsr     (Animate_RawNoSST).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

S3HCZScene_WaitInPose20BeforeJump:
                move.b  #8,routine(a0)
                move.b  #$20,mapping_frame(a0)
                move.w  #$3F,$2E(a0)
                move.l  #S3HCZScene_TurnAndSelectJump,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3HCZScene_TurnAndSelectJump:
                move.b  #$A,routine(a0)
                bchg    #0,render_flags(a0)
                bra.w   S3AIZScene_SetSharedLeftJumpSpeed
; ---------------------------------------------------------------------------

S3HCZScene_AnimateUntilOffscreen:
                jsr     (Animate_Raw).l
                tst.b   render_flags(a0)
                bmi.w   S3AIZScene_SharedSceneReturn
                lea     (Pal_HCZ2).l,a1
                jsr     (PalLoad_Line1).l
                lea     S3HCZScene_CameraRestoreChildren(pc),a2
                jsr     (CreateChild1_Normal).l
                jsr     (AllocateObject).l
                bne.s   S3HCZScene_ReleaseTrackingAndDelete
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

S3HCZScene_ReleaseTrackingAndDelete:
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
S3HCZScene_CameraRestoreChildren:
                dc.w    2-1
                dc.l    Obj_DecLevStartYGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndXGradual
                dc.b    0,   0
