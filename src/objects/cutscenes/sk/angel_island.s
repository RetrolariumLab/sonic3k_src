; Owner: objects/cutscenes/sk
; Responsibility: Knuckles cutscene dispatch and Angel Island act-one and act-two encounters
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
                dc.l    CutsceneKnux_MHZ1
                dc.l    CutsceneKnux_MHZ2
                dc.l    CutsceneKnux_LRZ2
                dc.l    CutsceneKnux_HPZ
                dc.l    CutsceneKnux_SSZ
                dc.l    CutsceneKnux_SKIntro
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
                dc.w    SKAIZScene_InitKnucklesAndCork-CutsceneKnux_AIZ1_Index
                dc.w    SKAIZScene_WaitForParentDeleteFlag-CutsceneKnux_AIZ1_Index
                dc.w    SKAIZScene_JumpAndProbeFloor-CutsceneKnux_AIZ1_Index
                dc.w    SKAIZScene_TickFirstPause-CutsceneKnux_AIZ1_Index
                dc.w    SKAIZScene_MoveAndTickDash-CutsceneKnux_AIZ1_Index
                dc.w    SKAIZScene_AnimateIdleAndTickExit-CutsceneKnux_AIZ1_Index
                dc.w    SKAIZScene_MoveWhilePreviouslyVisible-CutsceneKnux_AIZ1_Index
; ---------------------------------------------------------------------------

SKAIZScene_InitKnucklesAndCork:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bclr    #7,art_tile(a0)
                move.b  #$13,y_radius(a0)
                move.b  #8,mapping_frame(a0)
                move.w  #$1400,x_pos(a0)
                move.w  #$440,y_pos(a0)
                bsr.w   CutsceneSpawnKnucklesMusicFadeTransition
                lea     SKSceneData_AIZ1CorkFloorChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKAIZScene_WaitForParentDeleteFlag:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   SKAIZScene_LaunchAndLoadPalette
                rts
; ---------------------------------------------------------------------------

SKAIZScene_LaunchAndLoadPalette:
                move.b  #4,routine(a0)
                bset    #7,status(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$80,x_vel(a0)
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

; Probe the floor only when MoveSprite reports a nonnegative previous vertical velocity
SKAIZScene_JumpAndProbeFloor:
                lea     SKKnucklesCutscene_LeapPhaseBodyLoop(pc),a1
                jsr     (Animate_RawNoSST).l
                jsr     (MoveSprite).l
                tst.l   d0
                bmi.s   SKAIZScene_IntroJumpReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   SKAIZScene_LandAndStartFirstPause

SKAIZScene_IntroJumpReturn:
                rts
; ---------------------------------------------------------------------------

SKAIZScene_LandAndStartFirstPause:
                move.b  #6,routine(a0)
                add.w   d1,y_pos(a0)
                move.b  #$16,mapping_frame(a0)
                move.w  #$7F,$2E(a0)
                move.l  #SKAIZScene_BeginLeftDashAndMove,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKAIZScene_TickFirstPause:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKAIZScene_BeginLeftDashAndMove:
                move.b  #8,routine(a0)
                bchg    #0,render_flags(a0)
                move.l  #SKSceneAnim_KnuxFastTravelLoop,$30(a0)
                move.w  #-$600,x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$29,$2E(a0)
                move.l  #SKAIZScene_ReverseDashAndPause,$34(a0)

SKAIZScene_MoveAndTickDash:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKAIZScene_ReverseDashAndPause:
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  #$29,$2E(a0)
                move.l  #SKAIZScene_EnterIdlePause,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKAIZScene_EnterIdlePause:
                move.b  #$A,routine(a0)
                move.b  #$16,mapping_frame(a0)
                move.w  #$3F,$2E(a0)
                move.l  #SKAIZScene_BeginRightExitAndTryFade,$34(a0)
                bra.w   SKAIZScene_ResetSharedIdleAnim
; ---------------------------------------------------------------------------

SKAIZScene_AnimateIdleAndTickExit:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKAIZScene_BeginRightExitAndTryFade:
                move.b  #$C,routine(a0)
                move.l  #SKSceneAnim_KnuxFastTravelLoop,$30(a0)
                move.w  #$600,x_vel(a0)
                jsr     (AllocateObject).l
                bne.s   SKAIZScene_ExitMusicSpawnReturn
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

SKAIZScene_ExitMusicSpawnReturn:
                rts
; ---------------------------------------------------------------------------

SKAIZScene_MoveWhilePreviouslyVisible:
                tst.b   render_flags(a0)
                bpl.s   SKAIZScene_RestoreLevelAndTryTitleCard
                jsr     (Animate_Raw).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

SKAIZScene_RestoreLevelAndTryTitleCard:
                clr.b   (Palette_cycle_counters+$00).w
                clr.b   (Ctrl_1_locked).w
                jsr     (AfterBoss_Cleanup).l
                jsr     (Remove_From_TrackingSlot).l
                jsr     (AllocateObject).l
                bne.s   SKAIZScene_CommitLevelStartAndDelete
                move.l  #Obj_TitleCard,(a1)

SKAIZScene_CommitLevelStartAndDelete:
                move.b  #$91,(Level_started_flag).w
                move.b  #$80,(Update_HUD_timer).w
                clr.l   (Timer).w
                move.b  #1,(Update_HUD_life_count).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SKAIZScene_InitCorkAndCheckParent:
                lea     SKAizCutscene_CorkFloorAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKAIZScene_DrawCorkUntilBreakSignal,(a0)

SKAIZScene_DrawCorkUntilBreakSignal:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   SKAIZScene_BreakCorkIntoPieces
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKAIZScene_BreakCorkIntoPieces:
                lea     (SKCork_AIZCorkVelocityPairs).l,a4
                addq.b  #1,mapping_frame(a0)
                move.l  #SKCork_MoveFragmentAndApplyGravity,(a0)
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
                dc.w    SKAIZScene_InitAct2AndSolidChild-CutsceneKnux_AIZ2_Index
                dc.w    SKAIZScene_TickSharedWordWait-CutsceneKnux_AIZ2_Index
                dc.w    SKAIZScene_WalkLeftToAct2Threshold-CutsceneKnux_AIZ2_Index
                dc.w    SKAIZScene_AnimateIdleAndTickJumpPause-CutsceneKnux_AIZ2_Index
                dc.w    SKAIZScene_UpdateJumpAndBounceOnce-CutsceneKnux_AIZ2_Index
                dc.w    SKAIZScene_AnimateAct2FinalIdle-CutsceneKnux_AIZ2_Index
; ---------------------------------------------------------------------------

SKAIZScene_InitAct2AndSolidChild:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  #$4B8E,x_pos(a0)
                move.w  #$17D,y_pos(a0)
                bset    #0,render_flags(a0)
                bsr.w   CutsceneSpawnKnucklesMusicFadeTransition
                move.w  #(2*60)-1,$2E(a0)
                move.l  #SKAIZScene_EndAct2PauseAndWalk,$34(a0)
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     SKSceneData_AIZ2SolidChildren(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   SKAIZScene_Act2InitReturn
                move.w  #$4B08,x_pos(a1)
                move.w  #$178,y_pos(a1)

SKAIZScene_Act2InitReturn:
                rts
; ---------------------------------------------------------------------------

SKAIZScene_TickSharedWordWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKAIZScene_EndAct2PauseAndWalk:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKAIZScene_WalkLeftToAct2Threshold:
                move.w  x_pos(a0),d0
                subq.w  #2,d0
                cmpi.w  #$4B3C,d0
                blo.s   SKAIZScene_FaceRightAndStartJumpPause
                move.w  d0,x_pos(a0)
                lea     SKSceneAnim_KnuxTravelLoop(pc),a1
                jmp     (Animate_RawNoSST).l
; ---------------------------------------------------------------------------

SKAIZScene_FaceRightAndStartJumpPause:
                move.b  #6,routine(a0)
                bclr    #0,render_flags(a0)
                move.w  #$5F,$2E(a0)
                move.l  #SKAIZScene_SelectAct2Jump,$34(a0)

SKAIZScene_ResetSharedIdleAnim:
                move.l  #SKSceneAnim_KnuxWaitWithTailLoop,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                move.b  #$1C,mapping_frame(a0)

SKAIZScene_SharedSceneReturn:
                rts
; ---------------------------------------------------------------------------

SKAIZScene_AnimateIdleAndTickJumpPause:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKAIZScene_SelectAct2Jump:
                move.b  #8,routine(a0)

SKAIZScene_SetSharedLeftJumpSpeed:
                move.w  #-$100,x_vel(a0)
                move.w  #-$400,y_vel(a0)

SKAIZScene_ResetSharedJumpAnim:
                move.l  #SKKnucklesCutscene_LeapPhaseBodyLoop,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                move.b  #8,mapping_frame(a0)
                move.b  #$13,y_radius(a0)
                rts
; ---------------------------------------------------------------------------

SKAIZScene_UpdateJumpAndBounceOnce:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   SKAIZScene_SharedJumpUpdateReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKAIZScene_SharedJumpUpdateReturn
                bset    #2,$38(a0)
                bne.s   SKAIZScene_LandSecondContactAndIdle
                neg.w   x_vel(a0)
                neg.w   y_vel(a0)

SKAIZScene_SharedJumpUpdateReturn:
                rts
; ---------------------------------------------------------------------------

SKAIZScene_LandSecondContactAndIdle:
                addq.b  #2,routine(a0)
                add.w   d1,y_pos(a0)
                bra.w   SKAIZScene_ResetSharedIdleAnim
; ---------------------------------------------------------------------------

SKAIZScene_AnimateAct2FinalIdle:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

SKAIZScene_ResolveAct2SolidChild:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   CutsceneKnux_Delete
                move.b  #8,width_pixels(a0)
                moveq   #$13,d1
                move.w  #$20,d2
                move.w  #$40,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull2).l
; End of function SKAIZScene_UpdateJumpAndBounceOnce
