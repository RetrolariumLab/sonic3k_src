; Owner: objects/cutscenes/sk
; Responsibility: Angel Island plane opening actor, flight sequence, child construction and private palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZPlaneIntro:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZPlaneIntro_Index(pc,d0.w),d1
                jsr     AIZPlaneIntro_Index(pc,d1.w)
                jsr     (Sonic_Load_PLC).l
                bsr.w   AdvanceAizPlaneIntroScrollOrPlayer
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
AIZPlaneIntro_Index:
                dc.w    AIZPlaneIntro_InitControllerAndPlayer-AIZPlaneIntro_Index
                dc.w    AIZPlaneIntro_WaitForLaunchCallback-AIZPlaneIntro_Index
                dc.w    AIZPlaneIntro_ReduceYSpeedUntilZero-AIZPlaneIntro_Index
                dc.w    SKAIZPlaneIntro_SwingMoveThenWaitForDash-AIZPlaneIntro_Index
                dc.w    AIZPlaneIntro_ArcLeftUntilY130-AIZPlaneIntro_Index
                dc.w    AIZPlaneIntro_AccelerateLeftBelowX40-AIZPlaneIntro_Index
                dc.w    AIZPlaneIntro_TickSuperMapHold-AIZPlaneIntro_Index
                dc.w    AIZPlaneIntro_EmitWavesAndMoveRight-AIZPlaneIntro_Index
                dc.w    AIZPlaneIntro_EmitWavesAndTickRightHold-AIZPlaneIntro_Index
                dc.w    AIZPlaneIntro_EmitWavesAndMoveLeft-AIZPlaneIntro_Index
                dc.w    AIZPlaneIntro_EmitWavesAndTickLeftHold-AIZPlaneIntro_Index
                dc.w    AIZPlaneIntro_WaitForPlayerX918-AIZPlaneIntro_Index
                dc.w    AIZPlaneIntro_WaitForPlayerX1240-AIZPlaneIntro_Index
                dc.w    AIZPlaneIntro_WaitForPlayerX13D0-AIZPlaneIntro_Index
; ---------------------------------------------------------------------------

AIZPlaneIntro_InitControllerAndPlayer:
                addq.b  #2,routine(a0)
                move.l  #Map_Sonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$BA,mapping_frame(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  #$60,x_pos(a0)
                move.w  #$30,y_pos(a0)
                move.w  #$40,$2E(a0)
                move.l  #AIZPlaneIntro_LaunchAndSpawnPlane,$34(a0)
                move.w  #8,$40(a0)
                move.w  #$E918,(Events_fg_1).w
                move.b  #-1,(Player_prev_frame).w
                lea     (Player_1).w,a1
                move.b  #0,mapping_frame(a1)
                move.b  #$53,object_control(a1)

AIZPlaneIntro_ControllerUpdateReturn:
                rts
; ---------------------------------------------------------------------------

AIZPlaneIntro_WaitForLaunchCallback:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_LaunchAndSpawnPlane:
                move.b  #4,routine(a0)
                move.w  #$300,x_vel(a0)
                move.w  #$600,y_vel(a0)
                lea     AIZPlaneIntro_PlaneChildRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_ReduceYSpeedUntilZero:
                subi.w  #$18,y_vel(a0)
                beq.s   AIZPlaneIntro_BeginSwingAndSetDash
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_BeginSwingAndSetDash:
                move.b  #6,routine(a0)
                clr.w   x_vel(a0)
                move.w  #$5F,$2E(a0)
                move.l  #AIZPlaneIntro_StartArcAndDetachPlane,$34(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

SKAIZPlaneIntro_SwingMoveThenWaitForDash:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_StartArcAndDetachPlane:
                move.b  #8,routine(a0)
                move.w  #$400,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                move.l  #AIZPlaneIntro_EightFrameCountedAnim,$30(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

AIZPlaneIntro_ArcLeftUntilY130:
                subi.w  #$40,x_vel(a0)
                jsr     (MoveSprite).l
                cmpi.w  #$130,y_pos(a0)
                bhs.s   AIZPlaneIntro_ClampYAndBeginXAccel
                jmp     (AIZPlaneIntro_DecodeCountedAnim).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_ClampYAndBeginXAccel:
                move.b  #$A,routine(a0)
                move.w  #$130,y_pos(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

AIZPlaneIntro_AccelerateLeftBelowX40:
                subi.w  #$40,x_vel(a0)
                jsr     (MoveSprite2).l
                cmpi.w  #$40,x_pos(a0)
                blo.s   AIZPlaneIntro_ClampXAndInitSuperHold
                rts
; ---------------------------------------------------------------------------

AIZPlaneIntro_ClampXAndInitSuperHold:
                move.b  #$C,routine(a0)
                move.w  #$40,x_pos(a0)
                move.w  #5,$2E(a0)
                move.l  #AIZPlaneIntro_ResetWaveTimerAndTrySpawn,$34(a0)
                move.w  #$3F,$3A(a0)
                bra.w   AIZPlaneIntro_InitSuperMapAndColors
; ---------------------------------------------------------------------------

; Check the pre-movement X against the lower bound $80
AIZPlaneIntro_ResetWaveTimerAndTrySpawn:
                move.w  #5,$2E(a0)
                cmpi.w  #$80,x_pos(a0)
                blo.w   AIZPlaneIntro_ControllerUpdateReturn
                lea     AIZPlaneIntro_WaveChildRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_TickSuperMapHold:
                subq.w  #1,$3A(a0)
                bpl.w   AIZPlaneIntro_ControllerUpdateReturn
                move.b  #$E,routine(a0)
                rts
; ---------------------------------------------------------------------------

AIZPlaneIntro_EmitWavesAndMoveRight:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                jsr     (Obj_Wait).l
                move.w  x_pos(a0),d0
                addq.w  #4,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$200,d0
                bhs.s   SKAIZPlaneIntro_EnterRightSideSuperHold
                rts
; ---------------------------------------------------------------------------

SKAIZPlaneIntro_EnterRightSideSuperHold:
                move.b  #$10,routine(a0)
                move.w  #$1F,$3A(a0)
                rts
; ---------------------------------------------------------------------------

AIZPlaneIntro_EmitWavesAndTickRightHold:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                jsr     (Obj_Wait).l
                subq.w  #1,$3A(a0)
                bpl.w   AIZPlaneIntro_ControllerUpdateReturn
                move.b  #$12,routine(a0)
                bset    #2,$38(a0)
                move.w  #$C,$40(a0)
                rts
; ---------------------------------------------------------------------------

AIZPlaneIntro_EmitWavesAndMoveLeft:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                jsr     (Obj_Wait).l
                move.w  x_pos(a0),d0
                subi.w  #4,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$120,d0
                bls.s   AIZPlaneIntro_EnterLeftHoldAndSetScroll
                rts
; ---------------------------------------------------------------------------

AIZPlaneIntro_EnterLeftHoldAndSetScroll:
                move.b  #$14,routine(a0)
                bset    #2,$38(a0)
                move.w  #$1F,$3A(a0)
                move.w  #$10,$40(a0)
                rts
; ---------------------------------------------------------------------------

AIZPlaneIntro_EmitWavesAndTickLeftHold:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                jsr     (Obj_Wait).l
                subq.w  #1,$3A(a0)
                bpl.w   AIZPlaneIntro_ControllerUpdateReturn
                move.b  #$16,routine(a0)
                rts
; ---------------------------------------------------------------------------

AIZPlaneIntro_WaitForPlayerX918:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                cmpi.w  #$918,(Player_1+x_pos).w
                bhs.s   AIZPlaneIntro_AdvanceAndSpawnKnuckles
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_AdvanceAndSpawnKnuckles:
                move.b  #$18,routine(a0)
                lea     AIZPlaneIntro_KnucklesChildRecord(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_WaitForPlayerX1240:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                cmpi.w  #$1240,(Player_1+x_pos).w
                bhs.s   AIZPlaneIntro_RaiseControllerBeforeExit
                rts
; ---------------------------------------------------------------------------

AIZPlaneIntro_RaiseControllerBeforeExit:
                move.b  #$1A,routine(a0)
                subi.w  #$20,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

AIZPlaneIntro_WaitForPlayerX13D0:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                cmpi.w  #$13D0,(Player_1+x_pos).w
                bhs.s   AIZPlaneIntro_ReleasePlayerPrepEmeralds
                rts
; ---------------------------------------------------------------------------

AIZPlaneIntro_ReleasePlayerPrepEmeralds:
                st      (Palette_cycle_counters+$00).w
                lea     (Player_1).w,a1
                move.b  #4,routine(a1)
                bset    #Status_InAir,status(a1)
                move.w  #-$400,y_vel(a1)
                move.w  #-$200,x_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #$1A,anim(a1)
                clr.b   object_control(a1)
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                clr.b   (Super_Sonic_Knux_flag).w
                move.b  #2,(Super_palette_status).w
                move.w  #$1E,(Palette_frame).w
                lea     Pal_AIZIntroEmeralds(pc),a1
                lea     (Normal_palette_line_4).w,a2
                moveq   #bytesToLcnt($20),d0

AIZPlaneIntro_CopyColorsAndSpawnEmeralds:
                move.l  (a1)+,(a2)+
                dbf     d0,AIZPlaneIntro_CopyColorsAndSpawnEmeralds
                lea     AIZPlaneIntro_EmeraldChildRecord(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_InitPlaneAndTwoDetails:
                move.l  #AIZPlaneIntro_SwingAndCheckDetach,(a0)
                move.l  #Map_AIZIntroPlane,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroPlane,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$40,width_pixels(a0)
; Bug: This is missing the height, and it overwrites what the previous line did
                move.b  #$20,width_pixels(a0)
                jsr     Swing_Setup1(pc)
                lea     (ArtKosM_AIZIntroPlane).l,a1
                move.w  #tiles_to_bytes(ArtTile_AIZIntroPlane),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_AIZIntroEmeralds).l,a1
                move.w  #tiles_to_bytes(ArtTile_AIZIntroEmeralds),d2
                jsr     (Queue_Kos_Module).l
                lea     AIZPlaneIntro_PlaneDetailChildRecords(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_SwingAndCheckDetach:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   AIZPlaneIntro_FollowWhileAttached
                move.l  #AIZPlaneIntro_SwingAndFlyLeft,(a0)

AIZPlaneIntro_FollowWhileAttached:
                btst    #3,$38(a1)
                bne.s   AIZPlaneIntro_DrawPlane
                jsr     (Refresh_ChildPosition).l

AIZPlaneIntro_DrawPlane:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_SwingAndFlyLeft:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #4,x_pos(a0)
                cmpi.w  #$20,x_pos(a0)
                blo.s   AIZPlaneIntro_DeleteExitedPlane
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_DeleteExitedPlane:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_InitPlaneDetail1:
                move.l  #Map_AIZIntroPlane,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroPlane,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #4,width_pixels(a0)
; Bug: This is missing the height, and it overwrites what the previous line did
                move.b  #$C,width_pixels(a0)
                move.l  #AIZPlaneIntro_AnimateAndFollowDetail1,(a0)

AIZPlaneIntro_AnimateAndFollowDetail1:
                lea     (AIZPlaneIntro_PlaneDetail1Anim).l,a1
                jsr     (Animate_RawNoSST).l
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_InitPlaneDetail2:
                move.l  #Map_AIZIntroPlane,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroPlane,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #4,width_pixels(a0)
; Bug: This is missing the height, and it overwrites what the previous line did
                move.b  #$C,width_pixels(a0)
                move.l  #AIZPlaneIntro_AnimateAndFollowDetail2,(a0)

AIZPlaneIntro_AnimateAndFollowDetail2:
                lea     (AIZPlaneIntro_PlaneDetail2Anim).l,a1
                jsr     (Animate_RawNoSST).l
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_InitWaveAndScroll:
                move.l  #AIZPlaneIntro_ScrollOrCullWave,(a0)
                move.l  #Map_AIZIntroWaves,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroSprites,0,0),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$10,width_pixels(a0)
                bset    #0,render_flags(a0)
                movea.w parent3(a0),a1
                move.l  #AIZPlaneIntro_WaveAnimAndDelete,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

AIZPlaneIntro_ScrollOrCullWave:
                cmpi.w  #$60,x_pos(a0)
                blo.s   AIZPlaneIntro_DeleteWave
                movea.w parent3(a0),a1
                move.w  $40(a1),d0
                sub.w   d0,x_pos(a0)
                jsr     (Animate_RawMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_DeleteWave:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_InitAndMoveEmerald:
                lea     AIZPlaneIntro_EmeraldAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  d0,mapping_frame(a0)
                move.l  #AIZPlaneIntro_MoveEmeraldAndProbeFloor,(a0)
                move.b  #4,y_radius(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                moveq   #$40,d0
                jsr     (Set_IndexedVelocity).l

; The floor probe uses the sign of the pre-movement vertical velocity returned by MoveSprite
AIZPlaneIntro_MoveEmeraldAndProbeFloor:
                jsr     (MoveSprite).l
                tst.l   d0
                bmi.s   AIZPlaneIntro_DrawEmeraldAfterMove
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   AIZPlaneIntro_DrawEmeraldAfterMove
                add.w   d1,y_pos(a0)
                move.l  #AIZPlaneIntro_CheckEmeraldNearKnuckles,(a0)

AIZPlaneIntro_DrawEmeraldAfterMove:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_CheckEmeraldNearKnuckles:
                movea.w (SceneControllerObjectAddress).w,a1
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                subq.w  #8,d0
                cmp.w   d0,d1
                blo.s   AIZPlaneIntro_DrawEmeraldOutsideWindow
                addi.w  #2*8,d0
                cmp.w   d0,d1
                blo.s   AIZPlaneIntro_ApplySubtypeXDirection

AIZPlaneIntro_DrawEmeraldOutsideWindow:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_ApplySubtypeXDirection:
                move.w  x_vel(a1),d0
                btst    #1,subtype(a0)
                beq.s   AIZPlaneIntro_HideEmeraldOrDelete
                neg.w   d0

AIZPlaneIntro_HideEmeraldOrDelete:
                tst.w   d0
                bmi.w   AIZPlaneIntro_ControllerUpdateReturn
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

AIZPlaneIntro_InitSuperMapAndColors:
                move.l  #Map_SuperSonic,mappings(a0)
                move.b  #$21,mapping_frame(a0)
                move.b  #0,(Palette_timer).w
                move.w  #$24,(Palette_frame).w
                move.w  #$7FFF,(Super_frame_count).w
                rts

; =============== S U B R O U T I N E =======================================

AnimateAizPlaneIntroSuperAppearance:
                move.b  #1,(Super_Sonic_Knux_flag).w
                move.b  #$21,mapping_frame(a0)
                btst    #1,(V_int_run_count+3).w
                beq.s   AIZPlaneIntro_TickSuperPaletteCycle
                move.b  #$22,mapping_frame(a0)

AIZPlaneIntro_TickSuperPaletteCycle:
                subq.b  #1,(Palette_timer).w
                bpl.s   AIZPlaneIntro_SuperAppearanceReturn
                move.b  #6,(Palette_timer).w
                lea     (PalCycle_SuperSonic).l,a1
                move.w  (Palette_frame).w,d0
                addq.w  #6,(Palette_frame).w
                cmpi.w  #$36,(Palette_frame).w
; This condition causes the last frame to be skipped
                blo.s   AIZPlaneIntro_CopyThreeSuperColors
                move.w  #$24,(Palette_frame).w

AIZPlaneIntro_CopyThreeSuperColors:
                lea     (Normal_palette+$4).w,a2
                move.l  (a1,d0.w),(a2)+
                move.w  4(a1,d0.w),(a2)

AIZPlaneIntro_SuperAppearanceReturn:
                rts
; End of function AnimateAizPlaneIntroSuperAppearance

; =============== S U B R O U T I N E =======================================

AdvanceAizPlaneIntroScrollOrPlayer:
                move.w  $40(a0),d1
                move.w  (Events_fg_1).w,d0
                bpl.s   AIZPlaneIntro_AdvancePlayerXAfterScroll
                add.w   d1,d0
                move.w  d0,(Events_fg_1).w
                rts
; ---------------------------------------------------------------------------

AIZPlaneIntro_AdvancePlayerXAfterScroll:
                add.w   d1,(Player_1+x_pos).w
                rts
; End of function AdvanceAizPlaneIntroScrollOrPlayer

; ---------------------------------------------------------------------------

AIZPlaneIntro_DecodeCountedAnim:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   AIZPlaneIntro_CountedAnimReturn
                move.b  (a1),anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                cmp.b   1(a1),d0
                blo.s   AIZPlaneIntro_StoreCursorAndFrame
                moveq   #0,d0

AIZPlaneIntro_StoreCursorAndFrame:
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  2(a1,d0.w),d1
                move.b  d1,mapping_frame(a0)

AIZPlaneIntro_CountedAnimReturn:
                rts
; ---------------------------------------------------------------------------
AIZPlaneIntro_EmeraldAttributes:
                dc.l    Map_AIZIntroEmeralds
                dc.w    make_art_tile(ArtTile_AIZIntroEmeralds,3,0)
                dc.w    $280
                dc.b    4,   4,   1,   0
AIZPlaneIntro_PlaneChildRecord:
                dc.w    1-1
                dc.l    AIZPlaneIntro_InitPlaneAndTwoDetails
                dc.b    -$22, $2C
AIZPlaneIntro_PlaneDetailChildRecords:
                dc.w    2-1
                dc.l    AIZPlaneIntro_InitPlaneDetail1
                dc.b    $38,   4
                dc.l    AIZPlaneIntro_InitPlaneDetail2
                dc.b    $18, $18
AIZPlaneIntro_WaveChildRecord:
                dc.w    1-1
                dc.l    AIZPlaneIntro_InitWaveAndScroll
                dc.b    0, $18
AIZPlaneIntro_KnucklesChildRecord:
                dc.w    1-1
                dc.l    Obj_CutsceneKnuckles
AIZPlaneIntro_EmeraldChildRecord:
                dc.w    7-1
                dc.l    AIZPlaneIntro_InitAndMoveEmerald
AIZPlaneIntro_EightFrameCountedAnim:
                dc.b    3,   8
                dc.b    $97, $96
                dc.b    $98, $96
                dc.b    $99, $96
                dc.b    $9A, $96
                dc.b    $FC
AIZPlaneIntro_PlaneDetail1Anim:
                dc.b    0,   1,   2,   3,   4,   3,   2, $FC
AIZPlaneIntro_PlaneDetail2Anim:
                dc.b    0,   5,   6, $FC
AIZPlaneIntro_WaveAnimAndDelete:
                dc.b    0,   1
                dc.b    0,   0
                dc.b    1,   1
                dc.b    2,   2
                dc.b    3,   2
                dc.b    4,   1
                dc.b    5,   1
                dc.b    $F4
                even
Pal_AIZIntroEmeralds:
                binclude "data/Levels/AIZ/Palettes/Intro Emeralds.bin"
                even
