; Owner: objects/interface/continue/sk
; Responsibility: Continue-scene Sonic, Tails, Knuckles, EggRobo and attached icon actor state machines
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Continue_SonicWTails:
                move.l  #Map_ContinueSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Misc,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.w  #$118,x_pos(a0)
                move.w  #$120,y_pos(a0)
                move.l  #ContinueSonicPair_WaitAndBlink,(a0)

ContinueSonicPair_WaitAndBlink:
                movea.w (_unkFAA4).w,a1
                btst    #3,$38(a1)
                bne.s   ContinueSonicPair_InstallStateDispatch
                move.b  #0,mapping_frame(a0)
                btst    #4,(V_int_run_count+3).w
                beq.s   ContinueSonicPair_DrawWaiting
                move.b  #1,mapping_frame(a0)

ContinueSonicPair_DrawWaiting:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

ContinueSonicPair_InstallStateDispatch:
                move.l  #ContinueSonicPair_DispatchAndDraw,(a0)

ContinueSonicPair_DispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ContinueSonicPair_StateOffsets(pc,d0.w),d1
                jsr     ContinueSonicPair_StateOffsets(pc,d1.w)
                jsr     (Sonic_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
ContinueSonicPair_StateOffsets:
                dc.w    ContinueSonicPair_InitMapAndFrames-ContinueSonicPair_StateOffsets
                dc.w    ContinueSonicPair_StepFrameAndFlip-ContinueSonicPair_StateOffsets
                dc.w    ContinueSonicPair_AnimateAndTickDelay-ContinueSonicPair_StateOffsets
                dc.w    ContinueSonicPair_RunToExit-ContinueSonicPair_StateOffsets
                dc.w    ContinueSonicPair_TerminalStateReturn-ContinueSonicPair_StateOffsets
; ---------------------------------------------------------------------------

ContinueSonicPair_InitMapAndFrames:
                addq.b  #2,routine(a0)
                move.l  #Map_Sonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                clr.b   (Player_prev_frame).w
                move.b  #$5A,mapping_frame(a0)
                move.b  #6,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

ContinueSonicPair_StepFrameAndFlip:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   ContinueSonicPair_FrameUpdateReturn
                move.b  #6,anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                cmpi.b  #$A,d0
                bhs.s   ContinueSonicPair_SetRunAnimAndDelay
                move.b  d0,anim_frame(a0)
                lea     ContinueSonicPair_ManualFrameFlipPairs(pc,d0.w),a2
                move.b  (a2)+,mapping_frame(a0)
                bclr    #0,render_flags(a0)
                tst.b   (a2)
                beq.s   ContinueSonicPair_FrameUpdateReturn
                bset    #0,render_flags(a0)

ContinueSonicPair_FrameUpdateReturn:
                rts
; ---------------------------------------------------------------------------

ContinueSonicPair_SetRunAnimAndDelay:
                move.b  #4,routine(a0)
                move.w  #1,anim(a0)
                move.w  #$600,ground_vel(a0)
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------
ContinueSonicPair_ManualFrameFlipPairs:
                dc.b    $5A,   1
                dc.b    $59,   1
                dc.b    $55,   0
                dc.b    $56,   0
                dc.b    $57,   0
                even
; ---------------------------------------------------------------------------

ContinueSonicPair_AnimateAndTickDelay:
                jsr     (Animate_Sonic).l
                subq.w  #1,$2E(a0)
                bmi.s   ContinueSonicPair_SelectRun
                rts
; ---------------------------------------------------------------------------

ContinueSonicPair_SelectRun:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

ContinueSonicPair_RunToExit:
                jsr     (Animate_Sonic).l
                addq.w  #6,x_pos(a0)
                cmpi.w  #$1E0,x_pos(a0)
                bhs.s   ContinueSonicPair_SelectFinished
                rts
; ---------------------------------------------------------------------------

ContinueSonicPair_SelectFinished:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

ContinueSonicPair_TerminalStateReturn:
                rts
; ---------------------------------------------------------------------------

Obj_Continue_SonicAlone:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Continue_SonicAlone_Index(pc,d0.w),d1
                jsr     Continue_SonicAlone_Index(pc,d1.w)
                jsr     (Sonic_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Continue_SonicAlone_Index:
                dc.w    ContinueSonicSolo_InitWaitingSprite-Continue_SonicAlone_Index
                dc.w    ContinueSonicSolo_WaitForApproach-Continue_SonicAlone_Index
                dc.w    ContinueSonicSolo_TickDelayBeforeRun-Continue_SonicAlone_Index
                dc.w    ContinueSonicSolo_RunAndAnimate-Continue_SonicAlone_Index
                dc.w    ContinueSonicAlone_TerminalStateReturn-Continue_SonicAlone_Index
; ---------------------------------------------------------------------------

ContinueSonicSolo_InitWaitingSprite:
                move.b  #2,routine(a0)
                move.l  #Map_Sonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$120,y_pos(a0)

ContinueSonicSolo_WaitForApproach:
                movea.w (_unkFAA4).w,a1
                btst    #2,$38(a1)
                bne.s   ContinueSonicSolo_SetExitPoseAndDelay
                lea     ContinueSonicAlone_EscapedRawWaitLoop(pc),a1
                jmp     (Animate_RawNoSSTCheckResult).l
; ---------------------------------------------------------------------------

ContinueSonicSolo_SetExitPoseAndDelay:
                move.b  #4,routine(a0)
                move.b  #$BA,mapping_frame(a0)
                move.w  #7,$2E(a0)
                rts
; ---------------------------------------------------------------------------

ContinueSonicSolo_TickDelayBeforeRun:
                subq.w  #1,$2E(a0)
                bpl.s   ContinueSonicSolo_RunDelayReturn
                move.b  #6,routine(a0)
                move.b  #$21,mapping_frame(a0)

ContinueSonicSolo_RunDelayReturn:
                rts
; ---------------------------------------------------------------------------

ContinueSonicSolo_RunAndAnimate:
                addq.w  #6,x_pos(a0)
                cmpi.w  #$1E0,x_pos(a0)
                bhs.s   ContinueSonicSolo_StopAndSignalAccept
                lea     ContinueExit_SonicKnucklesRawLoop(pc),a1
                jmp     (Animate_RawNoSSTCheckResult).l
; ---------------------------------------------------------------------------

ContinueSonicSolo_StopAndSignalAccept:
                move.b  #8,routine(a0)
                move.b  #1,(_unkFAA9).w

ContinueSonicAlone_TerminalStateReturn:
                rts
; ---------------------------------------------------------------------------

Obj_Continue_TailsWSonic:
                move.l  #Map_ContinueSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Misc,0,0),art_tile(a0)
                move.w  #$200,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.w  #$12C,x_pos(a0)
                move.w  #$120,y_pos(a0)
                move.l  #ContinueTailsPair_WaitAndBlink,(a0)

ContinueTailsPair_WaitAndBlink:
                movea.w (_unkFAA4).w,a1
                btst    #3,$38(a1)
                bne.s   ContinueTailsPair_InstallExitActors
                move.b  #5,mapping_frame(a0)
                btst    #5,(V_int_run_count+3).w
                beq.s   ContinueTailsPair_DrawWaiting
                move.b  #6,mapping_frame(a0)

ContinueTailsPair_DrawWaiting:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

ContinueTailsPair_InstallExitActors:
                move.l  #ContinueTailsPair_DispatchAndDraw,(a0)
                addq.w  #4,y_pos(a0)
                lea     (Tails_tails).w,a1
                move.l  #Obj_Tails_Tail,(a1)
                move.w  a0,$30(a1)
                move.l  #ContinueTailsPair_FixFlagAndDeleteSlot,(Dust).w

ContinueTailsPair_DispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ContinueTailsPair_StateOffsets(pc,d0.w),d1
                jsr     ContinueTailsPair_StateOffsets(pc,d1.w)
                jsr     (Tails_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
ContinueTailsPair_StateOffsets:
                dc.w    ContinueTailsPair_InitMapAndAnim-ContinueTailsPair_StateOffsets
                dc.w    ContinueTailsPair_WaitThenAnimate-ContinueTailsPair_StateOffsets
                dc.w    ContinueTailsPair_TickDelayBeforeRun-ContinueTailsPair_StateOffsets
                dc.w    ContinueTailsPair_RunAndSignalAccept-ContinueTailsPair_StateOffsets
; ---------------------------------------------------------------------------

ContinueTailsPair_InitMapAndAnim:
                addq.b  #2,routine(a0)
                move.l  #Map_Tails,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                clr.b   (Player_prev_frame_P2).w
                move.w  #5<<8,anim(a0)                  ; and prev_anim
                move.w  #$AD<<8,mapping_frame(a0)       ; and anim_frame
                move.w  #40-1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

ContinueTailsPair_WaitThenAnimate:
                subq.w  #1,$2E(a0)
                bpl.w   SKContinueScene_ReturnAfterContinueSave
                move.b  #4,routine(a0)
                move.b  #0,anim(a0)
                move.w  #$600,ground_vel(a0)
                move.w  #20-1,$2E(a0)

ContinueTailsPair_TickDelayBeforeRun:
                subq.w  #1,$2E(a0)
                bpl.s   ContinueTailsPair_AnimateDuringRunDelay
                move.b  #6,routine(a0)

ContinueTailsPair_AnimateDuringRunDelay:
                jmp     (Animate_Tails).l
; ---------------------------------------------------------------------------

ContinueTailsPair_RunAndSignalAccept:
                addq.w  #6,x_pos(a0)
                cmpi.w  #$1E0,x_pos(a0)
                blo.s   ContinueTailsPair_AnimateRun
                move.b  #1,(_unkFAA9).w

ContinueTailsPair_AnimateRun:
                jmp     (Animate_Tails).l
; ---------------------------------------------------------------------------

ContinueTailsPair_FixFlagAndDeleteSlot:
                bclr    #2,(Tails_tails+render_flags).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

ContinueKnuckles_SelectEntrance:
                cmpi.w  #3,(Player_mode).w
                beq.s   ContinueKnuckles_InstallMiscSpriteInit
                lea     ContinueKnuckles_DispatchAndQueueArt(pc),a1
                move.l  a1,(a0)
                move.w  #$40,x_pos(a0)
                move.w  #$120,y_pos(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

ContinueKnuckles_InstallMiscSpriteInit:
                lea     ContinueKnuckles_InitWaitingSprite(pc),a1
                move.l  a1,(a0)

ContinueKnuckles_InitWaitingSprite:
                move.l  #Map_ContinueSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Misc,3,0),art_tile(a0)
                move.w  #$200,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #$11C,x_pos(a0)
                move.w  #$120,y_pos(a0)
                move.l  #ContinueKnuckles_TriggerEggRobo,(a0)

ContinueKnuckles_TriggerEggRobo:
                move.w  #$2F,$2E(a0)
                movea.w (_unkFAA4).w,a1
                btst    #3,$38(a1)
                beq.s   ContinueKnuckles_WaitThenInstallRun
                move.l  #ContinueKnuckles_WaitThenInstallRun,(a0)
                move.l  #ContinueEggRobo_InitAndRequestArt,(Dynamic_object_RAM+(object_size*13)).w

ContinueKnuckles_WaitThenInstallRun:
                subq.w  #1,$2E(a0)
                bpl.s   ContinueKnuckles_AnimateMiscAndDraw
                move.l  #ContinueKnuckles_DispatchAndQueueArt,(a0)

ContinueKnuckles_AnimateMiscAndDraw:
                lea     ContinueKnuckles_MiscOrdinaryRawWaitLoop(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

ContinueKnuckles_DispatchAndQueueArt:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ContinueKnuckles_StateOffsets(pc,d0.w),d1
                jsr     ContinueKnuckles_StateOffsets(pc,d1.w)
                jsr     (SKScene_LoadKnuxArtToSceneTiles).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
ContinueKnuckles_StateOffsets:
                dc.w    ContinueKnuckles_InitNativeMappings-ContinueKnuckles_StateOffsets
                dc.w    ContinueKnuckles_WaitForStart-ContinueKnuckles_StateOffsets
                dc.w    ContinueKnuckles_RunAndReleaseSonic-ContinueKnuckles_StateOffsets
                dc.w    ContinueKnuckles_TerminalStateReturn-ContinueKnuckles_StateOffsets
; ---------------------------------------------------------------------------

ContinueKnuckles_InitNativeMappings:
                addq.b  #2,routine(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.w  #make_art_tile(ArtTile_CutsceneKnux,3,0),art_tile(a0)
                move.w  #$80,priority(a0)
                move.b  #7,mapping_frame(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                rts
; ---------------------------------------------------------------------------

ContinueKnuckles_WaitForStart:
                movea.w (_unkFAA4).w,a1
                btst    #3,$38(a1)
                bne.s   ContinueKnuckles_BeginRun
                rts
; ---------------------------------------------------------------------------

ContinueKnuckles_BeginRun:
                move.b  #4,routine(a0)

ContinueKnuckles_RunAndReleaseSonic:
                move.w  x_pos(a0),d0
                addq.w  #6,d0
                move.w  d0,x_pos(a0)
                movea.w (_unkFAA4).w,a1
                cmpi.w  #$120,d0
                blo.s   ContinueKnuckles_AnimateOrStop
                bset    #2,$38(a1)

ContinueKnuckles_AnimateOrStop:
                cmpi.w  #$1E0,d0
                bhs.s   ContinueKnuckles_StopAndSignalSolo
                lea     ContinueExit_SonicKnucklesRawLoop(pc),a1
                jmp     (Animate_RawNoSSTCheckResult).l
; ---------------------------------------------------------------------------

ContinueKnuckles_StopAndSignalSolo:
                move.b  #6,routine(a0)
                cmpi.w  #3,(Player_mode).w
                bne.s   ContinueKnuckles_TerminalStateReturn
                move.b  #1,(_unkFAA9).w

ContinueKnuckles_TerminalStateReturn:
                rts
; ---------------------------------------------------------------------------

ContinueEggRobo_InitAndRequestArt:
                lea     (EggRoboSK_Hover_FullAttributes).l,a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                bset    #0,render_flags(a0)
                move.l  #ContinueEggRobo_SwingAnimateDraw,(a0)
                move.w  #$60,x_pos(a0)
                move.w  #$F0,y_pos(a0)
                move.w  #$600,x_vel(a0)
                jsr     (Swing_Setup1).l
                lea     (SKEggRobo_HoverAttachmentChildren).l,a2
                jsr     (CreateChild1_Normal).l
                lea     (ArtKosM_EggRoboBadnik).l,a1
                move.w  #tiles_to_bytes(ArtTile_EggRoboBadnik),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

ContinueEggRobo_SwingAnimateDraw:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (SetEggRoboFrameFromVblankParity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

ContinueDecoration_InitCenterSprite:
                move.l  #Map_ContinueSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Misc,2,0),art_tile(a0)
                move.w  #$380,priority(a0)
                move.b  #7,mapping_frame(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$F5,y_pos(a0)
                move.l  #ContinueDecoration_DrawCenterSprite,(a0)

ContinueDecoration_DrawCenterSprite:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

ContinueIcons_SelectMapAndPalette:
                move.l  #Map_ContinueIcons,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Icons,0,0),art_tile(a0)
                cmpi.w  #3,(Player_mode).w
                bne.s   ContinueIcons_InitPositionAndPair
                move.w  #make_art_tile(ArtTile_Continue_Icons,3,0),art_tile(a0)

ContinueIcons_InitPositionAndPair:
                move.w  #$380,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                bsr.w   ContinueIcon_SetCenterOutX
                move.w  #$D8,y_pos(a0)
                move.l  #ContinueIcons_SelectBlinkPairOffset,(a0)
                bsr.w   ContinueIcon_SelectCharacterFrames

ContinueIcons_SelectBlinkPairOffset:
                moveq   #0,d0
                btst    #4,(V_int_run_count+3).w
                beq.s   ContinueIcons_DrawSelectedFrame
                addq.w  #1,d0

ContinueIcons_DrawSelectedFrame:
                movea.l $30(a0),a1
                move.b  (a1,d0.w),mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

ContinueTailsIconChild_Initialize:
                move.l  #Map_ContinueIcons,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Icons,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.l  #ContinueTailsIconChild_AnimateAndDraw,(a0)

ContinueTailsIconChild_AnimateAndDraw:
                lea     ContinueTailsIconChild_RawAnimation(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
