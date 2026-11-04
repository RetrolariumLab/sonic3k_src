; Owner: objects/cutscenes/knuckles/s3
; Responsibility: Knuckles cutscene dispatch and Angel Island act-one and act-two scene programs
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CutsceneKnuckles:
                move.w  a0,(_unkFAA4).w
                moveq   #0,d0
                move.b  subtype(a0),d0
                movea.l CutsceneKnuckles_Index(pc,d0.w),a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------
CutsceneKnuckles_Index:
                dc.l    CutsceneKnux_AIZ1
                dc.l    CutsceneKnux_AIZ2
                dc.l    CutsceneKnux_HCZ2
                dc.l    CutsceneKnux_CNZ2A
                dc.l    CutsceneKnux_CNZ2B
                dc.l    CutsceneKnux_LBZ1
                dc.l    CutsceneKnux_LBZ2
; ---------------------------------------------------------------------------

CutsceneKnux_AIZ1:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_AIZ1_Index(pc,d0.w),d1
                jsr     CutsceneKnux_AIZ1_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
CutsceneKnux_AIZ1_Index:
                dc.w    S3AIZScene_InitKnucklesAndCork-CutsceneKnux_AIZ1_Index
                dc.w    S3AIZScene_WaitForParentDeleteFlag-CutsceneKnux_AIZ1_Index
                dc.w    S3AIZScene_JumpAndProbeFloor-CutsceneKnux_AIZ1_Index
                dc.w    S3AIZScene_TickFirstPause-CutsceneKnux_AIZ1_Index
                dc.w    S3AIZScene_MoveAndTickDash-CutsceneKnux_AIZ1_Index
                dc.w    S3AIZScene_AnimateIdleAndTickExit-CutsceneKnux_AIZ1_Index
                dc.w    S3AIZScene_MoveWhilePreviouslyVisible-CutsceneKnux_AIZ1_Index
; ---------------------------------------------------------------------------

S3AIZScene_InitKnucklesAndCork:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bclr    #7,art_tile(a0)
                move.b  #$13,y_radius(a0)
                move.b  #8,mapping_frame(a0)
                move.w  #$1400,x_pos(a0)
                move.w  #$440,y_pos(a0)
                bsr.w   SpawnKnucklesCutsceneMusicTransition
                lea     S3KnuxScene_AIZ1CorkChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

S3AIZScene_WaitForParentDeleteFlag:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   S3AIZScene_LaunchAndLoadPalette
                rts
; ---------------------------------------------------------------------------

S3AIZScene_LaunchAndLoadPalette:
                move.b  #4,routine(a0)
                bset    #7,status(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$80,x_vel(a0)
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

; Probe the floor only when MoveSprite reports a nonnegative previous vertical velocity
S3AIZScene_JumpAndProbeFloor:
                lea     S3KnuxScene_JumpAnim(pc),a1
                jsr     (Animate_RawNoSST).l
                jsr     (MoveSprite).l
                tst.l   d0
                bmi.s   S3AIZScene_IntroJumpReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   S3AIZScene_LandAndStartFirstPause

S3AIZScene_IntroJumpReturn:
                rts
; ---------------------------------------------------------------------------

S3AIZScene_LandAndStartFirstPause:
                move.b  #6,routine(a0)
                add.w   d1,y_pos(a0)
                move.b  #$16,mapping_frame(a0)
                move.w  #$7F,$2E(a0)
                move.l  #S3AIZScene_BeginLeftDashAndMove,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3AIZScene_TickFirstPause:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

S3AIZScene_BeginLeftDashAndMove:
                move.b  #8,routine(a0)
                bchg    #0,render_flags(a0)
                move.l  #S3KnuxScene_AIZDashAnim,$30(a0)
                move.w  #-$600,x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$29,$2E(a0)
                move.l  #S3AIZScene_ReverseDashAndPause,$34(a0)

S3AIZScene_MoveAndTickDash:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

S3AIZScene_ReverseDashAndPause:
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  #$29,$2E(a0)
                move.l  #S3AIZScene_EnterIdlePause,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3AIZScene_EnterIdlePause:
                move.b  #$A,routine(a0)
                move.b  #$16,mapping_frame(a0)
                move.w  #$3F,$2E(a0)
                move.l  #S3AIZScene_BeginRightExitAndTryFade,$34(a0)
                bra.w   S3AIZScene_ResetSharedIdleAnim
; ---------------------------------------------------------------------------

S3AIZScene_AnimateIdleAndTickExit:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

S3AIZScene_BeginRightExitAndTryFade:
                move.b  #$C,routine(a0)
                move.l  #S3KnuxScene_AIZDashAnim,$30(a0)
                move.w  #$600,x_vel(a0)
                jsr     (AllocateObject).l
                bne.s   S3AIZScene_ExitMusicSpawnReturn
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

S3AIZScene_ExitMusicSpawnReturn:
                rts
; ---------------------------------------------------------------------------

S3AIZScene_MoveWhilePreviouslyVisible:
                tst.b   render_flags(a0)
                bpl.s   S3AIZScene_RestoreLevelAndTryTitleCard
                jsr     (Animate_Raw).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3AIZScene_RestoreLevelAndTryTitleCard:
                clr.b   (Palette_cycle_counters+$00).w
                clr.b   (Ctrl_1_locked).w
                jsr     (AfterBoss_Cleanup).l
                jsr     (Remove_From_TrackingSlot).l
                jsr     (AllocateObject).l
                bne.s   S3AIZScene_CommitLevelStartAndDelete
                move.l  #Obj_TitleCard,(a1)

S3AIZScene_CommitLevelStartAndDelete:
                move.b  #$91,(Level_started_flag).w
                move.b  #$80,(Update_HUD_timer).w
                clr.l   (Timer).w
                move.b  #1,(Update_HUD_life_count).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

S3AIZScene_InitCorkAndCheckParent:
                lea     S3KnuxScene_AIZCorkAttrs(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #S3AIZScene_DrawCorkUntilBreakSignal,(a0)

S3AIZScene_DrawCorkUntilBreakSignal:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   S3AIZScene_BreakCorkIntoPieces
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3AIZScene_BreakCorkIntoPieces:
                lea     (S3Cork_AIZCorkVelocityPairs).l,a4
                addq.b  #1,mapping_frame(a0)
                move.l  #S3Cork_MoveFragmentAndApplyGravity,(a0)
                jmp     (BreakObjectToPieces).l
; ---------------------------------------------------------------------------

CutsceneKnux_AIZ2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_AIZ2_Index(pc,d0.w),d1
                jsr     CutsceneKnux_AIZ2_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
CutsceneKnux_AIZ2_Index:
                dc.w    S3AIZScene_InitAct2AndSolidChild-CutsceneKnux_AIZ2_Index
                dc.w    S3AIZScene_TickSharedWordWait-CutsceneKnux_AIZ2_Index
                dc.w    S3AIZScene_WalkLeftToAct2Threshold-CutsceneKnux_AIZ2_Index
                dc.w    S3AIZScene_AnimateIdleAndTickJumpPause-CutsceneKnux_AIZ2_Index
                dc.w    S3AIZScene_UpdateJumpAndBounceOnce-CutsceneKnux_AIZ2_Index
                dc.w    S3AIZScene_AnimateAct2FinalIdle-CutsceneKnux_AIZ2_Index
; ---------------------------------------------------------------------------

S3AIZScene_InitAct2AndSolidChild:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  #$4B8E,x_pos(a0)
                move.w  #$17D,y_pos(a0)
                bset    #0,render_flags(a0)
                bsr.w   SpawnKnucklesCutsceneMusicTransition
                move.w  #(2*60)-1,$2E(a0)
                move.l  #S3AIZScene_EndAct2PauseAndWalk,$34(a0)
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     S3KnuxScene_AIZ2BarrierChild(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   S3AIZScene_Act2InitReturn
                move.w  #$4B08,x_pos(a1)
                move.w  #$178,y_pos(a1)

S3AIZScene_Act2InitReturn:
                rts
; ---------------------------------------------------------------------------

S3AIZScene_TickSharedWordWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

S3AIZScene_EndAct2PauseAndWalk:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3AIZScene_WalkLeftToAct2Threshold:
                move.w  x_pos(a0),d0
                subq.w  #2,d0
                cmpi.w  #$4B3C,d0
                blo.s   S3AIZScene_FaceRightAndStartJumpPause
                move.w  d0,x_pos(a0)
                lea     S3KnuxScene_RunAnim(pc),a1
                jmp     (Animate_RawNoSST).l
; ---------------------------------------------------------------------------

S3AIZScene_FaceRightAndStartJumpPause:
                move.b  #6,routine(a0)
                bclr    #0,render_flags(a0)
                move.w  #$5F,$2E(a0)
                move.l  #S3AIZScene_SelectAct2Jump,$34(a0)

S3AIZScene_ResetSharedIdleAnim:
                move.l  #S3KnuxScene_ChuckleStartAnim,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                move.b  #$1C,mapping_frame(a0)

S3AIZScene_SharedSceneReturn:
                rts
; ---------------------------------------------------------------------------

S3AIZScene_AnimateIdleAndTickJumpPause:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

S3AIZScene_SelectAct2Jump:
                move.b  #8,routine(a0)

S3AIZScene_SetSharedLeftJumpSpeed:
                move.w  #-$100,x_vel(a0)
                move.w  #-$400,y_vel(a0)

S3AIZScene_ResetSharedJumpAnim:
                move.l  #S3KnuxScene_JumpAnim,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                move.b  #8,mapping_frame(a0)
                move.b  #$13,y_radius(a0)
                rts
; ---------------------------------------------------------------------------

S3AIZScene_UpdateJumpAndBounceOnce:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   S3AIZScene_SharedJumpUpdateReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   S3AIZScene_SharedJumpUpdateReturn
                bset    #2,$38(a0)
                bne.s   S3AIZScene_LandSecondContactAndIdle
                neg.w   x_vel(a0)
                neg.w   y_vel(a0)

S3AIZScene_SharedJumpUpdateReturn:
                rts
; ---------------------------------------------------------------------------

S3AIZScene_LandSecondContactAndIdle:
                addq.b  #2,routine(a0)
                add.w   d1,y_pos(a0)
                bra.w   S3AIZScene_ResetSharedIdleAnim
; ---------------------------------------------------------------------------

S3AIZScene_AnimateAct2FinalIdle:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

S3AIZScene_ResolveAct2SolidChild:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   CutsceneKnux_Delete
                move.b  #8,width_pixels(a0)
                moveq   #$13,d1
                move.w  #$20,d2
                move.w  #$40,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull2).l
; ---------------------------------------------------------------------------

CutsceneKnux_Delete:
                jmp     (Delete_Current_Sprite).l
; End of function CutsceneKnux_Delete
