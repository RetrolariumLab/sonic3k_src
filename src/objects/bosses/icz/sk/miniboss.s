; Owner: objects/bosses/icz/sk
; Responsibility: IceCap miniboss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZMiniboss:
                cmpi.w  #$501,(Apparent_zone_and_act).w
                beq.s   ICZMiniSK_DeleteForAct0501
                lea     FBZBossSK_ICZMinibossDefaultCamera(pc),a1
                tst.b   subtype(a0)
                beq.s   ICZMiniSK_BeginSubtypeArenaTransition
                lea     FBZBossSK_ICZMinibossAlternateCamera(pc),a1

ICZMiniSK_BeginSubtypeArenaTransition:
                jsr     (Check_CameraInRange).l
                move.b  #mus_Miniboss,boss_saved_mus(a0)
                jsr     (Boss_BeginCameraTransition).l
                move.l  #ICZMiniSK_TickArenaTransition,(a0)
                move.l  #ICZMiniSK_InstallBattleDispatcher,$34(a0)
                moveq   #PLCID_5F,d0
                jsr     (Load_PLC).l
                lea     Pal_ICZMiniboss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

ICZMiniSK_DeleteForAct0501:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

ICZMiniSK_TickArenaTransition:
                jmp     (SKEndCamera_TickAndSaveMusic).l
; ---------------------------------------------------------------------------

ICZMiniSK_InstallBattleDispatcher:
                move.l  #ICZMiniSK_BattleDispatchHitAndDraw,(a0)

ICZMiniSK_SharedReturn:
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_BattleDispatchHitAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZMiniSK_BattleStateOffsets(pc,d0.w),d1
                jsr     ICZMiniSK_BattleStateOffsets(pc,d1.w)
                bsr.w   HandleICZMinibossTwoColorHitOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
ICZMiniSK_BattleStateOffsets:
                dc.w    ICZMiniSK_InitBodyOrbAndTrim-ICZMiniSK_BattleStateOffsets
                dc.w    ICZMiniSK_MoveAndTickTransit-ICZMiniSK_BattleStateOffsets
                dc.w    ICZMiniSK_TickPaletteStartWait-ICZMiniSK_BattleStateOffsets
                dc.w    ICZMiniSK_RunPaletteAndTickWait-ICZMiniSK_BattleStateOffsets
                dc.w    ICZMiniSK_DescendRunPaletteAndWait-ICZMiniSK_BattleStateOffsets
                dc.w    ICZMiniSK_RunPaletteAndMoveArc-ICZMiniSK_BattleStateOffsets
                dc.w    ICZMiniSK_RunPaletteAndTickWait-ICZMiniSK_BattleStateOffsets
                dc.w    ICZMiniSK_RunPaletteAndPollOrbRelease-ICZMiniSK_BattleStateOffsets
                dc.w    ICZMiniSK_RunPaletteUntilCallback-ICZMiniSK_BattleStateOffsets
                dc.w    ICZMiniSK_TickPostReleaseCooldown-ICZMiniSK_BattleStateOffsets
                dc.w    ICZMiniSK_MoveAndTickTransit-ICZMiniSK_BattleStateOffsets
; ---------------------------------------------------------------------------

ICZMiniSK_InitBodyOrbAndTrim:
                lea     ICZMiniSK_BodyAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #6,collision_property(a0)
                move.w  #$200,$3E(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #ICZMiniSK_RequestTrimSeparation,$34(a0)
                lea     ICZMinibossSK_Root_EightSimpleOrbRecord(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     ICZMinibossSK_Root_SixNormalTrimRecords(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

ICZMiniSK_MoveAndTickTransit:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZMiniSK_RequestTrimSeparation:
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                move.w  #$1F,$2E(a0)
                move.l  #ICZMiniSK_BeginForwardPaletteWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_TickPaletteStartWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZMiniSK_BeginForwardPaletteWait:
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #ICZMiniSK_RequestOrbAssembly,$34(a0)
                lea     (ICZMiniSK_AccelPaletteScript).l,a1

; Copy two longwords and clear the following word in palette rotation RAM
ICZMiniSK_CopyPaletteScriptSlot:
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_RunPaletteAndTickWait:
                jsr     (Run_PalRotationScript).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZMiniSK_RequestOrbAssembly:
                bset    #2,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #ICZMiniSK_BeginFastDescent,$34(a0)
                moveq   #signextendB(sfx_TunnelBooster),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_BeginFastDescent:
                move.b  #8,routine(a0)
                move.w  #$300,y_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #ICZMiniSK_LoadArcRepeatCount,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_DescendRunPaletteAndWait:
                jsr     (MoveSprite2).l
                jsr     (Run_PalRotationScript).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZMiniSK_LoadArcRepeatCount:
                bsr.w   SelectICZMinibossArcRepeatCount

ICZMiniSK_ReverseXAndBeginArc:
                move.b  #$A,routine(a0)
                move.w  #$300,y_vel(a0)
                neg.w   $3E(a0)
                move.w  $3E(a0),x_vel(a0)
                move.w  #$5F,$2E(a0)
                moveq   #signextendB(sfx_BossRotate),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_RunPaletteAndMoveArc:
                jsr     (Run_PalRotationScript).l
                subq.w  #1,$2E(a0)
                bmi.s   ICZMiniSK_BeginArcRepeatWait
                addi.w  #-$10,y_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

ICZMiniSK_BeginArcRepeatWait:
                move.b  #$C,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #ICZMiniSK_RepeatArcOrReleaseOrbs,$34(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                jsr     (Run_PalRotationScript).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZMiniSK_RepeatArcOrReleaseOrbs:
                subq.b  #1,$39(a0)
                bpl.s   ICZMiniSK_ReverseXAndBeginArc
                move.b  #$E,routine(a0)
                bset    #1,$38(a0)
                move.w  (SceneMinimumXOrEmeraldSelectionTail).w,d0
                addi.w  #$A0,d0
                cmp.w   x_pos(a0),d0
                scc     $43(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_RunPaletteAndPollOrbRelease:
                btst    #1,$38(a0)
                beq.s   ICZMiniSK_BeginReversePalette
                jmp     (Run_PalRotationScript).l
; ---------------------------------------------------------------------------

ICZMiniSK_BeginReversePalette:
                move.b  #$10,routine(a0)
                bclr    #2,$38(a0)
                move.l  #ICZMiniSK_ResetPaletteAndBeginCooldown,(Palette_rotation_custom).w
                lea     (ICZMiniSK_DecelPaletteScript).l,a1
                bra.w   ICZMiniSK_CopyPaletteScriptSlot
; ---------------------------------------------------------------------------

ICZMiniSK_RunPaletteUntilCallback:
                jmp     (Run_PalRotationScript).l
; ---------------------------------------------------------------------------

ICZMiniSK_ResetPaletteAndBeginCooldown:
                move.b  #$12,routine(a0)
                move.w  #$222,(Normal_palette_line_2+$14).w
                move.w  #$3F,$2E(a0)
                move.l  #ICZMiniSK_BeginVerticalReturn,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_TickPostReleaseCooldown:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZMiniSK_BeginVerticalReturn:
                move.b  #$14,routine(a0)
                move.w  #-$100,y_vel(a0)
                clr.w   x_vel(a0)
                move.w  #$17,$2E(a0)
                move.l  #ICZMiniSK_HoldBeforePaletteRestart,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_HoldBeforePaletteRestart:
                move.b  #4,routine(a0)
                move.w  #$FF,$2E(a0)
                move.l  #ICZMiniSK_BeginForwardPaletteWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_StartSignAndStopSnow:
                jsr     (Obj_EndSignControl).l
                movea.w (SceneActorOrWorldOffset).w,a1
                cmpi.l  #SKICZSnowPile_UpdateCameraSnowEmitter,(a1)
                bne.s   ICZMiniSK_TryDefeatPaletteActor
                bset    #5,$38(a1)

ICZMiniSK_TryDefeatPaletteActor:
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   ICZMiniSK_SpawnBreakupFragments
                jsr     (AllocateObject).l
                bne.s   ICZMiniSK_SpawnBreakupFragments
                move.l  #ICZMiniSK_InitDefeatPaletteActor,(a1)

ICZMiniSK_SpawnBreakupFragments:
                lea     ICZMiniSK_DefeatFragmentChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

ICZMiniSK_InitDefeatPaletteActor:
                move.l  #ICZMiniSK_DefeatPaletteActorUpdate,(a0)
                lea     (ICZMiniSK_DefeatPaletteScript).l,a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #Go_Delete_Sprite,(Palette_rotation_custom).w
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_DefeatPaletteActorUpdate:
                jmp     (Run_PalRotationScript).l
; ---------------------------------------------------------------------------

ICZMiniSK_TrimFollowDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZMiniSK_TrimStateOffsets(pc,d0.w),d1
                jsr     ICZMiniSK_TrimStateOffsets(pc,d1.w)
                jsr     (Refresh_ChildPosition).l
                moveq   #0,d0
                jmp     (Child_Draw_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------
ICZMiniSK_TrimStateOffsets:
                dc.w    ICZMiniSK_InitTrimBySubtype-ICZMiniSK_TrimStateOffsets
                dc.w    ICZMiniSK_TrimWaitForSeparation-ICZMiniSK_TrimStateOffsets
                dc.w    ICZMiniSK_TrimApplyByteStepsAndWait-ICZMiniSK_TrimStateOffsets
                dc.w    ICZMinibossSK_Trim_ReturnFromFinalIdle-ICZMiniSK_TrimStateOffsets
; ---------------------------------------------------------------------------

ICZMiniSK_InitTrimBySubtype:
                lea     ICZMiniSK_TrimAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bra.w   ICZMiniSK_TrimSelectSubtypeFrame
; ---------------------------------------------------------------------------

ICZMiniSK_TrimWaitForSeparation:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   ICZMiniSK_TrimBeginOffsetMotion
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_TrimBeginOffsetMotion:
                move.b  #4,routine(a0)
                move.l  #ICZMinibossSK_Trim_SelectFinalOffsetIdle,$34(a0)
                bra.w   ICZMiniSK_TrimLoadStepsAndWait
; ---------------------------------------------------------------------------

ICZMiniSK_TrimApplyByteStepsAndWait:
                move.b  x_vel(a0),d0
                add.b   d0,child_dx(a0)
                move.b  x_vel+1(a0),d0
                add.b   d0,child_dy(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZMinibossSK_Trim_SelectFinalOffsetIdle:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

ICZMinibossSK_Trim_ReturnFromFinalIdle:
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_OrbDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZMiniSK_OrbStateOffsets(pc,d0.w),d1
                jsr     ICZMiniSK_OrbStateOffsets(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------
ICZMiniSK_OrbStateOffsets:
                dc.w    ICZMiniSK_InitOrbAtLowerBand-ICZMiniSK_OrbStateOffsets
                dc.w    ICZMiniSK_OrbWaitForAssembly-ICZMiniSK_OrbStateOffsets
                dc.w    ICZMiniSK_OrbApplyVIntJitter-ICZMiniSK_OrbStateOffsets
                dc.w    ICZMiniSK_OrbMoveAndTickFlight-ICZMiniSK_OrbStateOffsets
                dc.w    ICZMiniSK_OrbOrbitOrAlignForRelease-ICZMiniSK_OrbStateOffsets
                dc.w    ICZMiniSK_OrbChooseReleaseTilt-ICZMiniSK_OrbStateOffsets
                dc.w    ICZMiniSK_OrbOrbitAndCheckAck-ICZMiniSK_OrbStateOffsets
                dc.w    ICZMiniSK_OrbWaitForDispersalPhase-ICZMiniSK_OrbStateOffsets
                dc.w    ICZMiniSK_OrbMoveAndTickFlight-ICZMiniSK_OrbStateOffsets
                dc.w    ICZMiniSK_OrbWaitBeforeDrop-ICZMiniSK_OrbStateOffsets
                dc.w    ICZMiniSK_OrbMoveAndTickFlight-ICZMiniSK_OrbStateOffsets
                dc.w    ICZMiniSK_OrbFinalIdle-ICZMiniSK_OrbStateOffsets
; ---------------------------------------------------------------------------

ICZMiniSK_InitOrbAtLowerBand:
                lea     ICZMiniSK_OrbAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bra.w   ICZMiniSK_OrbSetLowerSpawnBand
; ---------------------------------------------------------------------------

ICZMiniSK_OrbWaitForAssembly:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   ICZMiniSK_OrbBeginJitteredRise
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_OrbBeginJitteredRise:
                move.b  #4,routine(a0)
                move.w  #-$40,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #ICZMiniSK_OrbBeginOrbitApproach,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_OrbApplyVIntJitter:
                moveq   #1,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   ICZMinibossSK_Orb_AddJitterMoveThenWait
                neg.w   d0

ICZMinibossSK_Orb_AddJitterMoveThenWait:
                add.w   d0,x_pos(a0)
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZMiniSK_OrbBeginOrbitApproach:
                move.b  #6,routine(a0)
                move.w  #$180,priority(a0)
                bsr.w   SetICZMinibossOrbApproachVelocity
                move.w  #$1F,$2E(a0)
                move.l  #ICZMiniSK_OrbEnableCollisionAndOrbit,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_OrbMoveAndTickFlight:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZMiniSK_OrbEnableCollisionAndOrbit:
                move.b  #8,routine(a0)
                move.b  #$8B,collision_flags(a0)
                moveq   #signextendB(sfx_BossRotate),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_OrbOrbitOrAlignForRelease:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   ICZMiniSK_OrbBeginReleaseAlignment
                bra.w   ICZMiniSK_OrbAdvanceTiltAndProject
; ---------------------------------------------------------------------------

ICZMiniSK_OrbBeginReleaseAlignment:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_OrbChooseReleaseTilt:
                movea.w parent3(a0),a1
                moveq   #0,d0
                tst.b   $43(a1)
                bne.s   ICZMiniSK_OrbWaitForReleaseTilt
                moveq   #-$80,d0

ICZMiniSK_OrbWaitForReleaseTilt:
                cmp.b   $3D(a0),d0
                beq.s   ICZMiniSK_OrbBeginReleaseOrbit
                bra.w   ICZMiniSK_OrbAdvanceTiltAndProject
; ---------------------------------------------------------------------------

ICZMiniSK_OrbBeginReleaseOrbit:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_OrbOrbitAndCheckAck:
                addq.b  #4,$3C(a0)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                moveq   #0,d0
                bsr.w   TiltAndDepthSortICZMinibossOrb
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   ICZMiniSK_OrbAckAndLoadDispersal
                tst.b   subtype(a0)
                bne.w   ICZMiniSK_SharedReturn
                moveq   #0,d0
                tst.b   $43(a1)
                bne.s   ICZMiniSK_OrbZeroCheckReleasePhase
                moveq   #-$80,d0

; Only orb zero clears the shared request when it reaches the phase for the selected side
ICZMiniSK_OrbZeroCheckReleasePhase:
                cmp.b   $3C(a0),d0
                bne.w   ICZMiniSK_SharedReturn

ICZMiniSK_OrbAckAndLoadDispersal:
                move.b  #$E,routine(a0)
                bclr    #1,$38(a1)
                bra.w   ICZMiniSK_OrbChooseDispersalPlan
; ---------------------------------------------------------------------------

ICZMiniSK_OrbWaitForDispersalPhase:
                move.b  $3C(a0),d0
                cmp.b   $42(a0),d0
                beq.s   ICZMiniSK_OrbBeginDispersalFlight
                addq.b  #4,$3C(a0)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                moveq   #0,d0
                bra.w   TiltAndDepthSortICZMinibossOrb
; ---------------------------------------------------------------------------

ICZMiniSK_OrbBeginDispersalFlight:
                move.b  #$10,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #ICZMiniSK_OrbRandomizeUpperDropPoint,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_OrbRandomizeUpperDropPoint:
                move.b  #$12,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #ICZMiniSK_OrbBeginVerticalDrop,$34(a0)
                bra.w   ICZMiniSK_OrbSetUpperSpawnBand
; ---------------------------------------------------------------------------

ICZMiniSK_OrbWaitBeforeDrop:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

ICZMiniSK_OrbBeginVerticalDrop:
                move.b  #$14,routine(a0)
                moveq   #signextendB(sfx_LevelProjectile),d0
                jsr     (Play_SFX).l
                move.w  #$400,y_vel(a0)
                clr.w   x_vel(a0)
                move.w  #$45,$2E(a0)
                move.l  #ICZMiniSK_OrbDisableAndRearmAssembly,$34(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_OrbDisableAndRearmAssembly:
                move.b  #2,routine(a0)
                clr.b   collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_OrbFinalIdle:
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_InitDefeatFragment:
                lea     ICZMiniSK_FragmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$B,d0
                move.b  d0,mapping_frame(a0)
                moveq   #8,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

ICZMiniSK_TrimSelectSubtypeFrame:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  ICZMiniSK_TrimFramesBySubtype(pc,d0.w),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
ICZMiniSK_TrimFramesBySubtype:
                dc.b    1,   9,   3,   2,  $A,   4
                even
; ---------------------------------------------------------------------------

ICZMiniSK_TrimLoadStepsAndWait:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  ICZMiniSK_TrimPackedOffsetSteps(pc,d0.w),x_vel(a0)
                move.w  ICZMiniSK_TrimOffsetStepWaits(pc,d0.w),$2E(a0)
                rts
; ---------------------------------------------------------------------------
ICZMiniSK_TrimPackedOffsetSteps:
                dc.w    -1,  $1FF,     1,    -1,  $1FF,     1
ICZMiniSK_TrimOffsetStepWaits:
                dc.w    2,     2,     3,     6,     6,     8
; ---------------------------------------------------------------------------

ICZMiniSK_OrbSetLowerSpawnBand:
                move.w  (SceneMinimumYOrEmeraldSelectionBytes).w,d0
                addi.w  #$D8,d0
                move.w  d0,y_pos(a0)

ICZMiniSK_OrbRandomizeLaneAndHeight:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  ICZMiniSK_OrbLaneXOffsets(pc,d0.w),d2
                jsr     (Random_Number).l
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,d2
                move.w  (SceneMinimumXOrEmeraldSelectionTail).w,x_pos(a0)
                add.w   d2,x_pos(a0)
                swap    d0
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
ICZMiniSK_OrbLaneXOffsets:
                dc.w    -$20
                dc.w    $20
                dc.w    $60
                dc.w    $A0
                dc.w    $E0
                dc.w    $120
                dc.w    $160
                dc.w    $1A0

; =============== S U B R O U T I N E =======================================

SetICZMinibossOrbApproachVelocity:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #4,d0
                move.b  d0,$3C(a0)
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                movem.w d0-d1,-(sp)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                moveq   #0,d0
                moveq   #0,d1
                moveq   #0,d2
                moveq   #0,d3
                movem.w (sp)+,d0-d1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  d0,x_pos(a0)
                move.w  d1,y_pos(a0)
                swap    d0
                swap    d1
                swap    d2
                swap    d3
                sub.l   d0,d2
                sub.l   d1,d3
                lsl.l   #3,d2
                lsl.l   #3,d3
                swap    d2
                swap    d3
                move.w  d2,x_vel(a0)
                move.w  d3,y_vel(a0)
                rts
; End of function SetICZMinibossOrbApproachVelocity

; ---------------------------------------------------------------------------

ICZMiniSK_OrbAdvanceTiltAndProject:
                addq.b  #4,$3C(a0)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                move.b  $3D(a0),d0
                addq.b  #1,d0
                move.b  d0,$3D(a0)

; =============== S U B R O U T I N E =======================================

TiltAndDepthSortICZMinibossOrb:
                jsr     (GetSineCosine).l
                tst.w   d1
                bpl.s   ICZMiniSK_TiltGetYDistanceAndSide
                neg.w   d1

ICZMiniSK_TiltGetYDistanceAndSide:
                move.w  y_pos(a0),d2
                move.w  y_pos(a1),d4
                sub.w   d4,d2
                scs     d3
                bcc.s   ICZMiniSK_TiltScaleYDistance
                neg.w   d2

; Invert the projection sign for tilt angles in the middle half-turn
ICZMiniSK_TiltScaleYDistance:
                mulu.w  d1,d2
                lsr.l   #8,d2
                cmpi.b  #$40,$3D(a0)
                blo.s   ICZMiniSK_TiltRestoreYOffsetSign
                cmpi.b  #-$40,$3D(a0)
                bhs.s   ICZMiniSK_TiltRestoreYOffsetSign
                not.b   d3

ICZMiniSK_TiltRestoreYOffsetSign:
                tst.b   d3
                beq.s   ICZMiniSK_TiltStoreYAndChooseSide
                neg.w   d2

ICZMiniSK_TiltStoreYAndChooseSide:
                add.w   d2,d4
                move.w  d4,y_pos(a0)
                move.b  $3D(a0),d0
                spl     d3
                cmpi.b  #$40,$3C(a0)
                blo.s   ICZMiniSK_TiltChooseOrbFrame
                cmpi.b  #-$40,$3C(a0)
                bhs.s   ICZMiniSK_TiltChooseOrbFrame
                not.b   d3

ICZMiniSK_TiltChooseOrbFrame:
                move.b  #6,mapping_frame(a0)
                cmpi.b  #$20,d0
                blo.s   ICZMiniSK_TiltChooseSpritePriority
                cmpi.b  #$60,d0
                blo.s   ICZMiniSK_TiltChooseSideFrame
                cmpi.b  #-$60,d0
                blo.s   ICZMiniSK_TiltChooseSpritePriority
                cmpi.b  #-$20,d0
                bhs.s   ICZMiniSK_TiltChooseSpritePriority

ICZMiniSK_TiltChooseSideFrame:
                move.b  #5,mapping_frame(a0)
                tst.b   d3
                bne.s   ICZMiniSK_TiltChooseSpritePriority
                move.b  #8,mapping_frame(a0)

ICZMiniSK_TiltChooseSpritePriority:
                move.w  #$180,priority(a0)
                tst.b   d3
                bne.s   ICZMiniSK_TiltProjectionReturn
                move.w  #$300,priority(a0)

ICZMiniSK_TiltProjectionReturn:
                rts
; End of function TiltAndDepthSortICZMinibossOrb

; =============== S U B R O U T I N E =======================================

SelectICZMinibossArcRepeatCount:
                move.b  $3A(a0),d0
                addq.b  #1,$3A(a0)
                andi.w  #7,d0
                move.b  ICZMiniSK_ArcRepeatCounts(pc,d0.w),$39(a0)
                rts
; End of function SelectICZMinibossArcRepeatCount

; ---------------------------------------------------------------------------
ICZMiniSK_ArcRepeatCounts:
                dc.b    1,   0,   1,   1,   0,   1,   0,   0
                even
; ---------------------------------------------------------------------------

ICZMiniSK_OrbChooseDispersalPlan:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d1
                tst.b   $43(a1)
                bne.s   ICZMiniSK_OrbApplyDispersalPlan
                addq.w  #8,d1

ICZMiniSK_OrbApplyDispersalPlan:
                move.b  ICZMiniSK_OrbDispersalPhaseBanks(pc,d1.w),$42(a0)
                add.w   d0,d0
                move.l  ICZMiniSK_OrbDispersalVelocities(pc,d0.w),x_vel(a0)  ; and y_vel
                tst.b   $43(a1)
                bne.s   ICZMiniSK_OrbDispersalSetupReturn
                neg.w   x_vel(a0)

ICZMiniSK_OrbDispersalSetupReturn:
                rts
; ---------------------------------------------------------------------------
ICZMiniSK_OrbDispersalPhaseBanks:
                dc.b    $60, $5C, $58, $54, $50, $4C, $48, $44
                dc.b    $E0, $DC, $D8, $D4, $D0, $CC, $C8, $C4
                even
ICZMiniSK_OrbDispersalVelocities:
                dc.w    -$300, -$400
                dc.w    -$200, -$400
                dc.w    -$100, -$400
                dc.w    0, -$400
                dc.w    $100, -$400
                dc.w    $200, -$400
                dc.w    $300, -$400
                dc.w    $400, -$400
; ---------------------------------------------------------------------------

ICZMiniSK_OrbSetUpperSpawnBand:
                move.w  (SceneMinimumYOrEmeraldSelectionBytes).w,d0
                subi.w  #$40,d0
                move.w  d0,y_pos(a0)
                bra.w   ICZMiniSK_OrbRandomizeLaneAndHeight

; =============== S U B R O U T I N E =======================================

HandleICZMinibossTwoColorHitOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   ICZMiniSK_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   ICZMiniSK_BeginDefeatWaitAndExplosion
                tst.b   $20(a0)
                bne.s   ICZMiniSK_HitChooseFlashRow
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

ICZMiniSK_HitChooseFlashRow:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   ICZMiniSK_HitCopyColorsAndTick
                addi.w  #2*2,d0

ICZMiniSK_HitCopyColorsAndTick:
                bsr.w   CopyICZMinibossTwoColorPalette
                subq.b  #1,$20(a0)
                bne.s   ICZMiniSK_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

ICZMiniSK_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

ICZMiniSK_BeginDefeatWaitAndExplosion:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #ICZMiniSK_StartSignAndStopSnow,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     (BossDefeated_StopTimer).l
; End of function HandleICZMinibossTwoColorHitOrDefeat

; =============== S U B R O U T I N E =======================================

CopyICZMinibossTwoColorPalette:
                lea     ICZMiniSK_HitPaletteDestinations(pc),a1
                lea     ICZMiniSK_HitPaletteColorRows(pc,d0.w),a2
                jmp     (CopyWordData_2).l
; End of function CopyICZMinibossTwoColorPalette

; ---------------------------------------------------------------------------
ICZMiniSK_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$14, Normal_palette_line_2+$16
ICZMiniSK_HitPaletteColorRows:
                dc.w    $222,   $20
                dc.w    $EEE,  $EEE
ICZMiniSK_BodyAttributes:
                dc.l    Map_ICZMiniboss
                dc.w    make_art_tile(ArtTile_ICZMiniboss,1,1)
                dc.w    $280
                dc.b    $18, $18,   0,   6
ICZMiniSK_TrimAttributes:
                dc.w    $280
                dc.b    $10,  $C,   1,   0
ICZMiniSK_OrbAttributes:
                dc.l    Map_ICZMiniboss
                dc.w    make_art_tile(ArtTile_ICZMiniboss,2,0)
                dc.w    $280
                dc.b    $C,  $C,   6,   0
ICZMiniSK_FragmentAttributes:
                dc.w    $180
                dc.b    $C,  $C,  $B,   0
ICZMinibossSK_Root_SixNormalTrimRecords:
                dc.w    6-1
                dc.l    ICZMiniSK_TrimFollowDispatchAndDraw
                dc.b    -$E, -$B
                dc.l    ICZMiniSK_TrimFollowDispatchAndDraw
                dc.b    $E, -$B
                dc.l    ICZMiniSK_TrimFollowDispatchAndDraw
                dc.b    0, $12
                dc.l    ICZMiniSK_TrimFollowDispatchAndDraw
                dc.b    -$E, -$B
                dc.l    ICZMiniSK_TrimFollowDispatchAndDraw
                dc.b    $E, -$B
                dc.l    ICZMiniSK_TrimFollowDispatchAndDraw
                dc.b    0,  $E
ICZMinibossSK_Root_EightSimpleOrbRecord:
                dc.w    8-1
                dc.l    ICZMiniSK_OrbDispatchAndDraw
ICZMiniSK_DefeatFragmentChildren:
                dc.w    4-1
                dc.l    ICZMiniSK_InitDefeatFragment
                dc.b    -$C, -$C
                dc.l    ICZMiniSK_InitDefeatFragment
                dc.b    $C, -$C
                dc.l    ICZMiniSK_InitDefeatFragment
                dc.b    -$C,  $C
                dc.l    ICZMiniSK_InitDefeatFragment
                dc.b    $C,  $C
                dc.b    0
                dc.b    3
                dc.b    1
                dc.b    3
                dc.b    2
                dc.b    3
                dc.b    3
                dc.b    3
                dc.b    4
                dc.b    3
                dc.b    5
                dc.b    3
                dc.b    6
                dc.b    3
                dc.b    $F4
                even
Pal_ICZMiniboss:
                binclude "data/Levels/ICZ/Palettes/Miniboss.bin"
                even
