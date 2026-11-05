; Owner: objects/bosses/lbz/grabber_ship/s3
; Responsibility: Launch Base second final boss defeat, ending pose actors, palette transition and ending handoff
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

LBZBoss2S3_InitDeathEggPiece:
                lea     LBZBoss2S3_DeathEggPieceAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #LBZBoss2S3_DeathEggFadeAndEmitSparkles,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                beq.s   LBZBoss2S3_DeathEggLoadPieceVariant
                move.l  #LBZBoss2S3_DeathEggPieceMoveAndDraw,(a0)

LBZBoss2S3_DeathEggLoadPieceVariant:
                move.w  LBZBoss2S3_DeathEggPieceYSpeeds(pc,d0.w),y_vel(a0)
                lea     LBZBoss2S3_DeathEggPieceFrameFlips(pc,d0.w),a1
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,d0
                or.b    d0,render_flags(a0)
                lea     Pal_LBZEnding(pc),a1
                jmp     PalLoad_Line1(pc)
; ---------------------------------------------------------------------------
LBZBoss2S3_DeathEggPieceFrameFlips:
                dc.b    0,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    2,   0
                dc.b    2,   1
                dc.b    2,   2
                dc.b    2,   3
                even
LBZBoss2S3_DeathEggPieceYSpeeds:
                dc.w    $40
                dc.w    $38
                dc.w    $3C
                dc.w    $40
                dc.w    $44
                dc.w    $48
                dc.w    $4C
                dc.w    $50
; ---------------------------------------------------------------------------

LBZBoss2S3_DeathEggFadeAndEmitSparkles:
                bsr.w   FadeLBZEndingMusicOnceAtCameraYOffset
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   LBZBoss2S3_DeathEggCheckFallThreshold
                lea     LBZBoss2S3_DeathEggSparkleChild(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     (Random_Number).l
                andi.w  #$1F,d0
                subi.w  #$10,d0
                add.w   d0,x_pos(a1)
                swap    d0
                andi.w  #$1F,d0
                subi.w  #$10,d0
                add.w   d0,y_pos(a1)

LBZBoss2S3_DeathEggCheckFallThreshold:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$A0,d0
                cmp.w   y_pos(a0),d0
                bcs.s   LBZBoss2S3_TryEndingWhiteFade

LBZBoss2S3_DeathEggPieceMoveAndDraw:
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

FadeLBZEndingMusicOnceAtCameraYOffset:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmp.w   y_pos(a0),d0
                bcc.s   LBZBoss2S3_DeathEggMusicFadeReturn
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.l  (sp),(a0)

LBZBoss2S3_DeathEggMusicFadeReturn:
                rts
; End of function FadeLBZEndingMusicOnceAtCameraYOffset

; ---------------------------------------------------------------------------

LBZBoss2S3_TryEndingWhiteFade:
                lea     LBZBoss2S3_EndingWhiteFadeChild(pc),a2
                jsr     CreateChild6_Simple(pc)
                bne.w   LBZBoss2S3_SharedReturn
                move.w  a1,$44(a0)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($80),d0

LBZBoss2S3_SavePaletteAndQueuePoseArt:
                move.l  (a1)+,(a2)+
                dbf     d0,LBZBoss2S3_SavePaletteAndQueuePoseArt
                move.l  #LBZBoss2S3_WaitWhiteThenFadeToTarget,(a0)
                moveq   #signextendB(sfx_FlamethrowerQuiet),d0
                jsr     (Play_SFX).l
                moveq   #signextendB(mus_Ending),d0
                jsr     (Play_Music).l
                jsr     GetS3LBZEndingCharacterVariant(pc)
                lsl.w   #2,d0
                movea.l LBZBoss2S3_EndingPoseArtPointers(pc,d0.w),a1
                move.w  #tiles_to_bytes(ArtTile_Ending_S3EndPose),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------
LBZBoss2S3_EndingPoseArtPointers:
                dc.l    ArtKosM_SonicEndPose
                dc.l    ArtKosM_TailsEndPose
                dc.l    ArtKosM_SuperSonicEndPose
; ---------------------------------------------------------------------------

LBZBoss2S3_WaitWhiteThenFadeToTarget:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.s   LBZBoss2S3_DrawDuringPaletteFade
                clr.b   (Level_started_flag).w
                lea     LBZBoss2S3_EndingTargetFadeChild(pc),a2
                jsr     CreateChild6_Simple(pc)
                bne.s   LBZBoss2S3_DrawDuringPaletteFade
                move.w  a1,$44(a0)
                move.l  #LBZBoss2S3_WaitTargetThenSignalEnding,(a0)

LBZBoss2S3_DrawDuringPaletteFade:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2S3_WaitTargetThenSignalEnding:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.w   LBZBoss2S3_SharedReturn
                bset    #1,(EndingOutcomeOrBossSceneSignals).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2S3_InitEndingPaletteActor:
                move.l  #LBZBoss2S3_RunEndingPaletteScript,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                movea.l LBZBoss2S3_EndingPaletteScriptPointers(pc,d0.w),a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #Go_Delete_Sprite,(Palette_rotation_custom).w
                rts
; ---------------------------------------------------------------------------
LBZBoss2S3_EndingPaletteScriptPointers:
                dc.l    PalSPtr_LBZFinalBoss2_FadeIn
                dc.l    PalSPtr_LBZFinalBoss2_FadeOut
; ---------------------------------------------------------------------------

LBZBoss2S3_RunEndingPaletteScript:
                jmp     Run_PalRotationScript(pc)
; ---------------------------------------------------------------------------

LBZBoss2S3_WaitAndTakeExternalAnim:
                btst    #0,(EndingOutcomeOrBossSceneSignals).w
                beq.w   LBZBoss2S3_SharedReturn
                move.l  #LBZBoss2S3_AnimateFirstExternalPose,(a0)
                move.l  #LBZBoss2S3_InstallSecondEventWait,$34(a0)
                clr.b   (Ctrl_1_locked).w
                lea     (Player_1).w,a1
                move.b  #$53,object_control(a1)
                move.b  #0,anim(a1)

LBZBoss2S3_AnimateFirstExternalPose:
                lea     LBZBoss2S3_EndingFirstExternalAnim(pc),a1
                bsr.w   Animate_ExternalPlayerSprite
                jmp     (Player_Load_PLC).l
; ---------------------------------------------------------------------------

LBZBoss2S3_InstallSecondEventWait:
                move.l  #LBZBoss2S3_WaitSecondEventAndResetAnim,(a0)

LBZBoss2S3_WaitSecondEventAndResetAnim:
                btst    #1,(EndingOutcomeOrBossSceneSignals).w
                beq.w   LBZBoss2S3_SharedReturn
                move.l  #LBZBoss2S3_AnimateSecondExternalPose,(a0)
                move.l  #LBZBoss2S3_BeginCharacterTimedAnim,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

LBZBoss2S3_AnimateSecondExternalPose:
                lea     LBZBoss2S3_EndingSecondExternalAnim(pc),a1
                bsr.w   Animate_ExternalPlayerSprite
                jmp     (Player_Load_PLC).l
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginCharacterTimedAnim:
                move.l  #LBZBoss2S3_TickTimedExternalAnim,(a0)
                move.w  #$FF,$2E(a0)
                move.l  #LBZBoss2S3_InstallEndingPose,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                lea     (Player_1).w,a1
                moveq   #0,d0
                move.b  character_id(a1),d0
                lsl.w   #2,d0
                lea     LBZBoss2S3_EndingAnimByCharacter(pc),a2
                move.l  (a2,d0.w),$30(a0)

LBZBoss2S3_TickTimedExternalAnim:
                movea.l $30(a0),a1
                bsr.w   Animate_ExternalPlayerSprite
                jsr     (Player_Load_PLC).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

LBZBoss2S3_InstallEndingPose:
                move.l  #LBZBoss2S3_InitEndingPoseByVariant,(a0)

LBZBoss2S3_InitEndingPoseByVariant:
                lea     LBZBoss2S3_EndingPoseAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                movea.w (SceneControllerObjectAddress).w,a1
                move.l  #Go_Delete_Sprite,(a1)
                jsr     GetS3LBZEndingCharacterVariant(pc)
                moveq   #0,d1
                subq.w  #1,d0
                beq.s   LBZBoss2S3_AddFinalPoseVariant
                bmi.s   LBZBoss2S3_BindPoseHandlerAndPalette
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   LBZBoss2S3_AddMiddlePoseVariant
                addq.w  #4,d1

LBZBoss2S3_AddMiddlePoseVariant:
                addq.w  #4,d1

LBZBoss2S3_AddFinalPoseVariant:
                addq.w  #4,d1

LBZBoss2S3_BindPoseHandlerAndPalette:
                move.l  LBZBoss2S3_EndingPoseHandlerPointers(pc,d1.w),(a0)
                move.w  d1,$3A(a0)
                rts
; ---------------------------------------------------------------------------
LBZBoss2S3_EndingPoseHandlerPointers:
                dc.l    LBZBoss2S3_BeginSonicEndingPose
                dc.l    LBZBoss2S3_BeginTailsEndingPose
                dc.l    LBZBoss2S3_BeginSuperJump
                dc.l    LBZBoss2S3_BeginSuperRun
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginSonicEndingPose:
                move.l  #LBZBoss2S3_TickPoseAndArmCredits,(a0)
                move.w  #6,$2E(a0)
                move.b  #0,mapping_frame(a0)
                subi.w  #$10,y_pos(a0)
                move.b  #0,(Player_1+mapping_frame).w
                bsr.w   LoadLBZEndingPosePaletteLine

LBZBoss2S3_TickPoseAndArmCredits:
                subq.w  #1,$2E(a0)
                bpl.s   LBZBoss2S3_DrawEndingPose
                move.l  #Wait_Draw,(a0)
                addq.b  #1,mapping_frame(a0)
                move.w  #5*60,$2E(a0)
                move.l  #LBZBoss2S3_StartCreditsAndDeletePose,$34(a0)
                subi.w  #$20,y_pos(a0)

LBZBoss2S3_DrawEndingPose:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2S3_StartCreditsAndDeletePose:
                move.b  #GameMode_S3Credits,(Game_mode).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginTailsEndingPose:
                move.l  #LBZBoss2S3_TickPoseAndArmCredits,(a0)
                move.w  #4,$2E(a0)
                move.b  #2,mapping_frame(a0)
                subi.w  #$10,y_pos(a0)
                move.b  #0,(Player_1+mapping_frame).w
                bsr.w   LoadLBZEndingPosePaletteLine
                bra.s   LBZBoss2S3_TickPoseAndArmCredits
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginSuperJump:
                move.l  #LBZBoss2S3_MoveSuperJumpAndSyncPlayer,(a0)
                move.b  #4,mapping_frame(a0)
                move.w  #$100,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                lea     (Player_1).w,a1
                move.b  #$81,object_control(a1)
                move.b  #2,anim(a1)

LBZBoss2S3_MoveSuperJumpAndSyncPlayer:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                jsr     (MoveSprite).l
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$140,d0
                cmp.w   y_pos(a0),d0
                bcs.s   LBZBoss2S3_RepositionForReturnFlight
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_RepositionForReturnFlight:
                move.l  #LBZBoss2S3_FlyToCameraCenterForCredits,(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$180,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$C0,d0
                move.w  d0,y_pos(a0)
                move.w  #-$800,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                bra.w   LoadLBZEndingPosePaletteLine
; ---------------------------------------------------------------------------

LBZBoss2S3_FlyToCameraCenterForCredits:
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                cmp.w   x_pos(a0),d0
                bcs.s   LBZBoss2S3_DrawReturnFlight
                move.l  #Wait_Draw,(a0)
                move.w  #3*60,$2E(a0)
                move.l  #LBZBoss2S3_StartCreditsAndDeletePose,$34(a0)

LBZBoss2S3_DrawReturnFlight:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2S3_BeginSuperRun:
                move.l  #LBZBoss2S3_MoveSuperRunAndCheckGate,(a0)
                move.b  #4,mapping_frame(a0)
                move.w  #$600,x_vel(a0)
                lea     (Player_1).w,a1
                move.b  #$81,object_control(a1)
                move.b  #0,anim(a1)
                move.w  #$600,x_vel(a1)
                move.w  #$600,ground_vel(a1)

; Compare the actor's Y against camera X plus $180, as in the original
LBZBoss2S3_MoveSuperRunAndCheckGate:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$180,d0
                cmp.w   y_pos(a0),d0
                bcs.w   LBZBoss2S3_RepositionForReturnFlight
                rts
; ---------------------------------------------------------------------------

LBZBoss2S3_InitSparkleAndTryTrail:
                lea     LBZBoss2S3_SparkleAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #LBZBoss2S3_SparkleTickFlips,(a0)
                move.w  #-$40,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                lea     LBZBoss2S3_SparkleTrailChild(pc),a2
                jsr     CreateChild6_Simple(pc)

LBZBoss2S3_SparkleTickFlips:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   LBZFinalBoss2S3_Sparkle_MoveWaitThenDraw
                move.b  $39(a0),d0
                addq.b  #1,d0
                move.b  d0,$39(a0)
                andi.b  #3,d0
                move.b  render_flags(a0),d1
                andi.b  #$FC,d1
                or.b    d0,d1
                move.b  d1,render_flags(a0)

LBZFinalBoss2S3_Sparkle_MoveWaitThenDraw:
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBoss2S3_InitFallingSparkleTrail:
                lea     LBZBoss2S3_SparkleTrailAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #LBZBoss2S3_SparkleTrailAnimateAndMove,(a0)
                move.l  #LBZBoss2S3_SparkleTrailDeleteAnim,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$40,y_vel(a0)

LBZBoss2S3_SparkleTrailAnimateAndMove:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
