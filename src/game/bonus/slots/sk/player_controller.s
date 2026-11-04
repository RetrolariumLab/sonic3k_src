; Owner: game/bonus/slots/sk
; Responsibility: Rotating slot bonus Sonic lifecycle, movement, collision, gravity and cage sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Sonic_RotatingSlotBonus:
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w
                tst.w   (Debug_placement_mode).w
                beq.s   SlotsPlayer_DispatchRoutineByByteOffset
                jsr     (DebugMode).l
                bra.w   Slots_CenterCameraPastInset
; ---------------------------------------------------------------------------

SlotsPlayer_DispatchRoutineByByteOffset:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Obj_Sonic_RotatingSlotBonus_Index(pc,d0.w),d1
                jsr     Obj_Sonic_RotatingSlotBonus_Index(pc,d1.w)

SlotsPlayer_RollLoadArtCenterAndDraw:
                move.b  #2,anim(a0)
                bsr.s   SlotsAnimateSelectedPlayerCharacter
                lea     (Player_1).w,a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jsr     (Perform_Player_DPLC).l
                bsr.w   Slots_CenterCameraPastInset
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

SlotsAnimateSelectedPlayerCharacter:
                move.b  character_id(a0),d0
                bne.s   SlotsPlayer_SelectTailsAnimator
                jmp     (Animate_Sonic).l
; ---------------------------------------------------------------------------

SlotsPlayer_SelectTailsAnimator:
                cmpi.b  #1,d0
                bne.s   SlotsPlayer_SelectKnucklesAnimator
                jmp     (Animate_Tails).l
; ---------------------------------------------------------------------------

SlotsPlayer_SelectKnucklesAnimator:
                jmp     (Animate_Knuckles).l
; End of function SlotsAnimateSelectedPlayerCharacter

; ---------------------------------------------------------------------------
Obj_Sonic_RotatingSlotBonus_Index:
                dc.w    SlotsPlayer_InitRadiiAndClampMode-Obj_Sonic_RotatingSlotBonus_Index
                dc.w    SlotsPlayer_CheckDebugPlacementOnB-Obj_Sonic_RotatingSlotBonus_Index
                dc.w    SlotsPlayer_AccelerateExitSpin-Obj_Sonic_RotatingSlotBonus_Index
SlotsPlayer_CharacterMapPointers:
                dc.l    Map_Sonic
                dc.l    Map_Tails
                dc.l    Map_Knuckles
; ---------------------------------------------------------------------------

SlotsPlayer_InitRadiiAndClampMode:
                addq.b  #2,routine(a0)
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.w  (Player_mode).w,d0
                subq.w  #1,d0
                bcc.s   SlotsPlayer_InstallMapAndAirRollState
                moveq   #0,d0

SlotsPlayer_InstallMapAndAirRollState:
                move.b  d0,character_id(a0)
                lsl.w   #2,d0
                move.l  SlotsPlayer_CharacterMapPointers(pc,d0.w),mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$100,priority(a0)
                move.b  #2,anim(a0)
                bset    #Status_Roll,status(a0)
                bset    #Status_InAir,status(a0)
                cmpi.w  #2,(Player_mode).w
                bne.s   SlotsPlayer_ResetSpinAndRestoreRings
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.l  #Obj_Tails_Tail,(Tails_tails).w
                move.w  a0,(Tails_tails+$30).w

SlotsPlayer_ResetSpinAndRestoreRings:
                clr.w   (Stat_table).w
                move.w  #$40,(SStage_scalar_index_1).w
                move.w  (Saved_ring_count).w,(Ring_count).w
                move.b  (Saved_extra_life_flags).w,(Extra_life_flags).w
                move.b  #1,(Update_HUD_ring_count).w

SlotsPlayer_CheckDebugPlacementOnB:
                tst.w   (Debug_mode_flag).w
                beq.s   SlotsPlayer_ClearCellAndDispatchMotion
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SlotsPlayer_ClearCellAndDispatchMotion
                move.w  #1,(Debug_placement_mode).w

SlotsPlayer_ClearCellAndDispatchMotion:
                move.b  #0,$30(a0)
                tst.b   object_control(a0)
                bne.s   SlotsPlayer_AdvanceControlledRotation16x
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #2,d0
                move.w  SlotsPlayer_GroundAndAirMotionOffsets(pc,d0.w),d1
                jmp     SlotsPlayer_GroundAndAirMotionOffsets(pc,d1.w)
; ---------------------------------------------------------------------------

SlotsPlayer_AdvanceControlledRotation16x:
                move.w  (SStage_scalar_index_1).w,d0
                asl.w   #4,d0
                add.w   (Stat_table).w,d0
                move.w  d0,(Stat_table).w
                rts
; ---------------------------------------------------------------------------
SlotsPlayer_GroundAndAirMotionOffsets:
                dc.w    SlotsPlayer_TryJumpThenMove-SlotsPlayer_GroundAndAirMotionOffsets
                dc.w    SlotsPlayer_ApplyForcesAndIntegrate-SlotsPlayer_GroundAndAirMotionOffsets
; ---------------------------------------------------------------------------

SlotsPlayer_TryJumpThenMove:
                bsr.w   Slots_TryJumpAgainstGravity

SlotsPlayer_ApplyForcesAndIntegrate:
                bsr.w   Slots_TryTangentialInputStep
                bsr.w   Slots_IntegrateGravityAndProbeAxes
                bsr.w   Slots_TryCollectCenterRing
                bsr.w   Slots_ApplyLatchedCellEffect
                jsr     (MoveSprite2).l
                move.w  (Stat_table).w,d0
                add.w   (SStage_scalar_index_1).w,d0
                move.w  d0,(Stat_table).w
                rts

; =============== S U B R O U T I N E =======================================

; Apply inertia and friction along the nearest cardinal tangent. A solid probe rolls back the entire position step
Slots_TryTangentialInputStep:
                btst    #button_left,(Ctrl_1_logical).w
                beq.s   SlotsPlayer_ApplyRightInput
                bsr.w   SlotsAccelerateLeftGroundInertia

SlotsPlayer_ApplyRightInput:
                btst    #button_right,(Ctrl_1_logical).w
                beq.s   SlotsPlayer_ApplyNoInputFriction
                bsr.w   SlotsAccelerateRightGroundInertia

SlotsPlayer_ApplyNoInputFriction:
                move.b  (Ctrl_1_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   SlotsPlayer_StepTangentAndUndoBlocked
                move.w  ground_vel(a0),d0
                beq.s   SlotsPlayer_StepTangentAndUndoBlocked
                bmi.s   SlotsPlayer_ApplyNegativeFriction
                subi.w  #$C,d0
                bcc.s   SlotsPlayer_StorePositiveFrictionResult
                move.w  #0,d0

SlotsPlayer_StorePositiveFrictionResult:
                move.w  d0,ground_vel(a0)
                bra.s   SlotsPlayer_StepTangentAndUndoBlocked
; ---------------------------------------------------------------------------

SlotsPlayer_ApplyNegativeFriction:
                addi.w  #$C,d0
                bcc.s   SlotsPlayer_StoreNegativeFrictionResult
                move.w  #0,d0

SlotsPlayer_StoreNegativeFrictionResult:
                move.w  d0,ground_vel(a0)

SlotsPlayer_StepTangentAndUndoBlocked:
                move.b  (Stat_table).w,d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                neg.b   d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                add.l   d1,x_pos(a0)
                muls.w  ground_vel(a0),d0
                add.l   d0,y_pos(a0)
                movem.l d0-d1,-(sp)
                move.l  y_pos(a0),d2
                move.l  x_pos(a0),d3
                bsr.w   Slots_ProbeFourCandidateCells
                beq.s   SlotsPlayer_RestoreClearTangentDeltas
                movem.l (sp)+,d0-d1
                sub.l   d1,x_pos(a0)
                sub.l   d0,y_pos(a0)
                move.w  #0,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_RestoreClearTangentDeltas:
                movem.l (sp)+,d0-d1
                rts
; End of function Slots_TryTangentialInputStep

; =============== S U B R O U T I N E =======================================

SlotsAccelerateLeftGroundInertia:
                bset    #Status_Facing,status(a0)
                move.w  ground_vel(a0),d0
                beq.s   SlotsPlayer_AccelerateLeftWithinLimit
                bpl.s   SlotsPlayer_BrakeRightwardInertia

SlotsPlayer_AccelerateLeftWithinLimit:
                subi.w  #$C,d0
                cmpi.w  #-$800,d0
                bgt.s   SlotsPlayer_StoreLeftAcceleration
                move.w  #-$800,d0

SlotsPlayer_StoreLeftAcceleration:
                move.w  d0,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_BrakeRightwardInertia:
                subi.w  #$40,d0
                bcc.s   SlotsPlayer_StoreUnclampedLeftBrake
                nop

SlotsPlayer_StoreUnclampedLeftBrake:
                move.w  d0,ground_vel(a0)
                rts
; End of function SlotsAccelerateLeftGroundInertia

; =============== S U B R O U T I N E =======================================

SlotsAccelerateRightGroundInertia:
                bclr    #Status_Facing,status(a0)
                move.w  ground_vel(a0),d0
                bmi.s   SlotsPlayer_BrakeLeftwardInertia
                addi.w  #$C,d0
                cmpi.w  #$800,d0
                blt.s   SlotsPlayer_StoreRightAcceleration
                move.w  #$800,d0

SlotsPlayer_StoreRightAcceleration:
                move.w  d0,ground_vel(a0)
                bra.s   SlotsPlayer_RightAccelerationReturn
; ---------------------------------------------------------------------------

SlotsPlayer_BrakeLeftwardInertia:
                addi.w  #$40,d0
                bcc.s   SlotsPlayer_StoreUnclampedRightBrake
                nop

SlotsPlayer_StoreUnclampedRightBrake:
                move.w  d0,ground_vel(a0)

SlotsPlayer_RightAccelerationReturn:
                rts
; End of function SlotsAccelerateRightGroundInertia

; =============== S U B R O U T I N E =======================================

; Require a fresh A, B or C press and launch away from the rotating gravity vector
Slots_TryJumpAgainstGravity:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   SlotsPlayer_JumpCheckReturn
                move.b  (Stat_table).w,d0
                andi.b  #$FC,d0
                neg.b   d0
                subi.b  #$40,d0
                jsr     (GetSineCosine).l
                muls.w  #$680,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  #$680,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                bset    #Status_InAir,status(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l

SlotsPlayer_JumpCheckReturn:
                rts
; End of function Slots_TryJumpAgainstGravity

; =============== S U B R O U T I N E =======================================

; For each axis, subtract the screen-center inset when the unsigned player coordinate permits it
Slots_CenterCameraPastInset:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                move.w  (Camera_X_pos).w,d0
                subi.w  #$A0,d3
                bcs.s   SlotsPlayer_CenterCameraYAboveInset
                sub.w   d3,d0
                sub.w   d0,(Camera_X_pos).w

SlotsPlayer_CenterCameraYAboveInset:
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$70,d2
                bcs.s   SlotsPlayer_CameraCenteringReturn
                sub.w   d2,d0
                sub.w   d0,(Camera_Y_pos).w

SlotsPlayer_CameraCenteringReturn:
                rts
; End of function Slots_CenterCameraPastInset

; ---------------------------------------------------------------------------

; Start the fade when the updated speed equals $1800
SlotsPlayer_AccelerateExitSpin:
                addi.w  #$40,(SStage_scalar_index_1).w
                cmpi.w  #$1800,(SStage_scalar_index_1).w
                bne.s   SlotsPlayer_AdvanceExitRotation
                move.w  #$40-1,(Palette_fade_info).w
                clr.w   (Pal_fade_delay).w
                move.l  #SlotsPlayer_TickExitFade,(a0)
                move.w  #60,$38(a0)
                st      (Palette_cycle_counters+$00).w

SlotsPlayer_AdvanceExitRotation:
                move.w  (Stat_table).w,d0
                add.w   (SStage_scalar_index_1).w,d0
                move.w  d0,(Stat_table).w
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_TickExitFade:
                subq.w  #1,(Pal_fade_delay).w
                bpl.s   SlotsPlayer_SpinAndRestoreSceneAtZero
                move.w  #2,(Pal_fade_delay).w
                move.l  a0,-(sp)
                jsr     (Pal_ToBlack).l
                movea.l (sp)+,a0

SlotsPlayer_SpinAndRestoreSceneAtZero:
                addi.w  #$40,(SStage_scalar_index_1).w
                move.w  (Stat_table).w,d0
                add.w   (SStage_scalar_index_1).w,d0
                move.w  d0,(Stat_table).w
                subq.w  #1,$38(a0)
                bne.s   SlotsPlayer_DrawDuringExitFade
                move.w  (Saved_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved_apparent_zone_and_act).w,(Apparent_zone_and_act).w
                move.b  (Saved_last_star_post_hit).w,(Last_star_post_hit).w
                move.b  #0,(Special_bonus_entry_flag).w
                move.b  #1,(Restart_level_flag).w
                move.w  (Ring_count).w,(Saved_ring_count).w
                move.b  (Extra_life_flags).w,(Saved_extra_life_flags).w

SlotsPlayer_DrawDuringExitFade:
                bra.w   SlotsPlayer_RollLoadArtCenterAndDraw

; =============== S U B R O U T I N E =======================================

; Reject blocked axes independently and preserve the four-count ground grace state
Slots_IntegrateGravityAndProbeAxes:
                move.l  y_pos(a0),d2
                move.l  x_pos(a0),d3
                move.b  (Stat_table).w,d0
                andi.b  #$FC,d0
                jsr     (GetSineCosine).l
                move.w  x_vel(a0),d4
                ext.l   d4
                asl.l   #8,d4
                muls.w  #$2A,d0
                add.l   d4,d0
                move.w  y_vel(a0),d4
                ext.l   d4
                asl.l   #8,d4
                muls.w  #$2A,d1
                add.l   d4,d1
                add.l   d0,d3
                bsr.w   Slots_ProbeFourCandidateCells
                beq.s   SlotsPlayer_ProbeYAndGroundIfBlocked
                sub.l   d0,d3
                moveq   #0,d0
                move.w  d0,x_vel(a0)
                bclr    #Status_InAir,status(a0)
                move.b  #4,$3A(a0)
                add.l   d1,d2
                bsr.w   Slots_ProbeFourCandidateCells
                beq.s   SlotsPlayer_ConvertDeltasToWordVelocity
                sub.l   d1,d2
                moveq   #0,d1
                move.w  d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_ProbeYAndGroundIfBlocked:
                add.l   d1,d2
                bsr.w   Slots_ProbeFourCandidateCells
                beq.s   SlotsPlayer_StoreFreeAxisAndTickGrace
                sub.l   d1,d2
                moveq   #0,d1
                move.w  d1,y_vel(a0)
                bclr    #Status_InAir,status(a0)
                move.b  #4,$3A(a0)

SlotsPlayer_ConvertDeltasToWordVelocity:
                asr.l   #8,d0
                asr.l   #8,d1
                move.w  d0,x_vel(a0)
                move.w  d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_StoreFreeAxisAndTickGrace:
                asr.l   #8,d0
                asr.l   #8,d1
                move.w  d0,x_vel(a0)
                move.w  d1,y_vel(a0)
                tst.b   $3A(a0)
                bne.s   SlotsPlayer_TickAirGrace
                bset    #Status_InAir,status(a0)
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_TickAirGrace:
                subq.b  #1,$3A(a0)
                rts
; End of function Slots_IntegrateGravityAndProbeAxes

; =============== S U B R O U T I N E =======================================

; Probe a two-by-two block of 24-pixel cells at the candidate 16.16 position. Z reports whether all probes cleared
Slots_ProbeFourCandidateCells:
                lea     (RAM_start+$3000).l,a1
                moveq   #0,d4
                swap    d2
                move.w  d2,d4
                swap    d2
                addi.w  #$44,d4
                divu.w  #$18,d4
                mulu.w  #$80,d4
                adda.l  d4,a1
                moveq   #0,d4
                swap    d3
                move.w  d3,d4
                swap    d3
                addi.w  #$14,d4
                divu.w  #$18,d4
                adda.w  d4,a1
                moveq   #0,d5
                move.b  (a1)+,d4
                bsr.s   Slots_ClassifyCellAndLatchContact
                move.b  (a1)+,d4
                bsr.s   Slots_ClassifyCellAndLatchContact
                adda.w  #$7E,a1
                move.b  (a1)+,d4
                bsr.s   Slots_ClassifyCellAndLatchContact
                move.b  (a1)+,d4
                bsr.s   Slots_ClassifyCellAndLatchContact
                tst.b   d5
                rts
; End of function Slots_ProbeFourCandidateCells

; =============== S U B R O U T I N E =======================================

; Accumulate solidity and latch interactive cell types 1 through 6
Slots_ClassifyCellAndLatchContact:
                beq.s   SlotsPlayer_NonblockingCellReturn
                cmpi.b  #8,d4
                beq.s   SlotsPlayer_NonblockingCellReturn
                cmpi.b  #$10,d4
                blo.s   SlotsPlayer_LatchInteractiveSolidCell

SlotsPlayer_NonblockingCellReturn:
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_LatchInteractiveSolidCell:
                cmpi.b  #7,d4
                beq.s   SlotsPlayer_MarkSolidProbe
                cmpi.b  #9,d4
                bhs.s   SlotsPlayer_MarkSolidProbe
                move.b  d4,$30(a0)
                move.l  a1,$32(a0)

SlotsPlayer_MarkSolidProbe:
                moveq   #-1,d5
                rts
; End of function Slots_ClassifyCellAndLatchContact

; =============== S U B R O U T I N E =======================================

; Use a free record for ring removal and award the 50-ring continue once per flag
Slots_TryCollectCenterRing:
                lea     (RAM_start+$3000).l,a1
                moveq   #0,d4
                move.w  y_pos(a0),d4
                addi.w  #$50,d4
                divu.w  #$18,d4
                mulu.w  #$80,d4
                adda.l  d4,a1
                moveq   #0,d4
                move.w  x_pos(a0),d4
                addi.w  #$20,d4
                divu.w  #$18,d4
                adda.w  d4,a1
                move.b  (a1),d4
                bne.s   SlotsPlayer_TryRingRemovalAnim
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_TryRingRemovalAnim:
                cmpi.b  #8,d4
                bne.s   SlotsPlayer_CenterNonRingReturnMinusOne
                bsr.w   Slots_FindFreeCellAnimRecord
                bne.s   SlotsPlayer_AwardRingAndCheckContinue
                move.b  #1,(a2)
                move.l  a1,4(a2)

SlotsPlayer_AwardRingAndCheckContinue:
                jsr     (GiveRing).l
                cmpi.w  #50,(Ring_count).w
                blo.s   SlotsPlayer_CenterEmptyOrRingReturnZero
                bset    #0,(Extra_life_flags).w
                bne.s   SlotsPlayer_CenterEmptyOrRingReturnZero
                addq.b  #1,(Continue_count).w
                moveq   #signextendB(sfx_Continue),d0
                jsr     (Play_Music).l

SlotsPlayer_CenterEmptyOrRingReturnZero:
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_CenterNonRingReturnMinusOne:
                moveq   #-1,d4
                rts
; End of function Slots_TryCollectCenterRing

; =============== S U B R O U T I N E =======================================

Slots_ApplyLatchedCellEffect:
                move.b  $30(a0),d0
                bne.s   SlotsPlayer_RepelFromBumperAndTryAnim
                subq.b  #1,$36(a0)
                bpl.s   SlotsPlayer_TickReverseCooldownIfClear
                move.b  #0,$36(a0)

SlotsPlayer_TickReverseCooldownIfClear:
                subq.b  #1,$37(a0)
                bpl.s   SlotsPlayer_ReturnNoContactCooldownWork
                move.b  #0,$37(a0)

SlotsPlayer_ReturnNoContactCooldownWork:
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_RepelFromBumperAndTryAnim:
                cmpi.b  #5,d0
                bne.s   SlotsPlayer_StartExitAtGoalCell
                move.l  $32(a0),d1
                subi.l  #-$CFFF,d1
                move.w  d1,d2
                andi.w  #$7F,d1
                mulu.w  #$18,d1
                subi.w  #$14,d1
                lsr.w   #7,d2
                andi.w  #$7F,d2
                mulu.w  #$18,d2
                subi.w  #$44,d2
                sub.w   x_pos(a0),d1
                sub.w   y_pos(a0),d2
                jsr     (GetArcTan).l
                jsr     (GetSineCosine).l
                muls.w  #-$700,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  #-$700,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                bset    #Status_InAir,status(a0)
                bsr.w   Slots_FindFreeCellAnimRecord
                bne.s   SlotsPlayer_PlayBumperSound
                move.b  #2,(a2)
                move.l  $32(a0),d0
                subq.l  #1,d0
                move.l  d0,4(a2)

SlotsPlayer_PlayBumperSound:
                moveq   #signextendB(sfx_Bumper),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SlotsPlayer_StartExitAtGoalCell:
                cmpi.b  #4,d0
                bne.s   SlotsPlayer_CheckReverseCellCooldown
                addq.b  #2,routine(a0)
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_CheckReverseCellCooldown:
                cmpi.b  #6,d0
                bne.s   SlotsPlayer_SelectWallCellCycle
                tst.b   $37(a0)
                bne.w   SlotsPlayer_CellContactReturn
                move.b  #$1E,$37(a0)
                bsr.w   Slots_FindFreeCellAnimRecord
                bne.s   SlotsPlayer_ReverseRotationSpeed
                move.b  #4,(a2)
                move.l  $32(a0),d0
                subq.l  #1,d0
                move.l  d0,4(a2)

SlotsPlayer_ReverseRotationSpeed:
                neg.w   (SStage_scalar_index_1).w
                moveq   #signextendB(sfx_LaunchGo),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SlotsPlayer_SelectWallCellCycle:
                cmpi.b  #1,d0
                beq.s   SlotsPlayer_TryAllocateWallCycle
                cmpi.b  #2,d0
                beq.s   SlotsPlayer_TryAllocateWallCycle
                cmpi.b  #3,d0
                beq.s   SlotsPlayer_TryAllocateWallCycle
                cmpi.b  #4,d0
                bne.s   SlotsPlayer_CellContactReturn

SlotsPlayer_TryAllocateWallCycle:
                bsr.w   Slots_FindFreeCellAnimRecord
                bne.s   SlotsPlayer_PlayWallFeedbackSound
                move.b  #3,(a2)
                movea.l $32(a0),a1
                subq.l  #1,a1
                move.l  a1,4(a2)
                move.b  (a1),d0
                addq.b  #1,d0
                cmpi.b  #4,d0
                bls.s   SlotsPlayer_PackWallTypeIntoPointer
                clr.b   d0
                move.b  #4,d0

SlotsPlayer_PackWallTypeIntoPointer:
                move.b  d0,4(a2)

; Play the sound even if the transient queue has no free record
SlotsPlayer_PlayWallFeedbackSound:
                moveq   #signextendB(sfx_Flipper),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SlotsPlayer_CellContactReturn:
                rts
; End of function Slots_ApplyLatchedCellEffect

; ---------------------------------------------------------------------------

SlotsPlayer_InitCageAtCenter:
                move.w  #$460,x_pos(a0)
                move.w  #$430,y_pos(a0)
                move.l  #Map_SlotBonusCage,mappings(a0)
                move.w  #make_art_tile(ArtTile_SlotsBlocks+$146,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.l  #SlotsPlayer_RotateCageAndDispatchCapture,(a0)

SlotsPlayer_RotateCageAndDispatchCapture:
                move.b  (Stat_table).w,d0
                andi.b  #$FC,d0
                jsr     (GetSineCosine).l
                lea     (Player_1).w,a1
                move.w  #$460,d2
                sub.w   x_pos(a1),d2
                move.w  d2,d4
                move.w  #$430,d3
                sub.w   y_pos(a1),d3
                move.w  d3,d5
                muls.w  d0,d4
                muls.w  d0,d5
                muls.w  d1,d2
                muls.w  d1,d3
                add.l   d4,d3
                asr.l   #8,d3
                sub.l   d5,d2
                asr.l   #8,d2
                add.w   x_pos(a1),d2
                add.w   y_pos(a1),d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                move.w  d2,(Events_bg+$00).w
                move.w  d3,(Events_bg+$02).w
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.w   Slots_DispatchCageState
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SlotsPlayer_CageUpdateReturn
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #6,mapping_frame(a0)
                blo.s   SlotsPlayer_CageUpdateReturn
                move.b  #0,mapping_frame(a0)

SlotsPlayer_CageUpdateReturn:
                rts

; =============== S U B R O U T I N E =======================================

; The cage states capture the player, spawn the outcome, release in alignment and wait through cooldown
Slots_DispatchCageState:
                move.w  (a2),d0
                move.w  SlotsPlayer_CageStateOffsets(pc,d0.w),d0
                jmp     SlotsPlayer_CageStateOffsets(pc,d0.w)
; End of function Slots_DispatchCageState

; ---------------------------------------------------------------------------
SlotsPlayer_CageStateOffsets:
                dc.w    SlotsPlayer_TryCapturePlayerInCage-SlotsPlayer_CageStateOffsets
                dc.w    SlotsPlayer_RefreshPlayerAndWaitOutcome-SlotsPlayer_CageStateOffsets
                dc.w    SlotsPlayer_ReleaseAtQuarterTurn-SlotsPlayer_CageStateOffsets
                dc.w    SlotsPlayer_TickCageRecaptureCooldown-SlotsPlayer_CageStateOffsets
; ---------------------------------------------------------------------------

SlotsPlayer_TryCapturePlayerInCage:
                tst.b   object_control(a1)
                bne.s   SlotsPlayer_CageCaptureReturn
                tst.w   (SStage_scalar_result_0).w
                bne.s   SlotsPlayer_CageCaptureReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$18,d0
                cmpi.w  #$30,d0
                bhs.s   SlotsPlayer_CageCaptureReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$18,d0
                cmpi.w  #$30,d0
                bhs.s   SlotsPlayer_CageCaptureReturn
                move.w  #$460,x_pos(a1)
                move.w  #$430,y_pos(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #$81,object_control(a1)
                addq.w  #2,(a2)+
                move.w  #$78,(a2)
                move.w  a1,$42(a0)
                move.b  #1,(Palette_cycle_counters+$00).w
                cmpi.b  #$18,(SStage_scalar_result_0+2).w
                bne.s   SlotsPlayer_CageCaptureReturn
                move.b  #8,(SStage_scalar_result_0+2).w
                clr.w   $32(a0)
                move.w  #-1,(SStage_scalar_result_0).w
                move.w  #-1,$2E(a0)

SlotsPlayer_CageCaptureReturn:
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_ChooseSignedPayoutPath:
                move.w  (SStage_scalar_result_1+2).w,d0
                bpl.w   SlotsPlayer_TryOddPhaseRingSpawn
                tst.w   $2E(a0)
                bpl.s   SlotsPlayer_TryOddPhaseSpikeSpawn
                move.w  #$64,$2E(a0)

SlotsPlayer_TryOddPhaseSpikeSpawn:
                tst.w   $2E(a0)
                beq.w   SlotsPlayer_WaitForSpikeChildren
                btst    #0,(Level_frame_counter+1).w
                beq.w   SlotsPlayer_TickSpikePayoutWait
                cmpi.w  #$10,$30(a0)
                bhs.w   SlotsPlayer_TickSpikePayoutWait
                jsr     (AllocateObject).l
                bne.w   SlotsPlayer_TickSpikePayoutWait
                move.l  #Obj_SlotSpike,(a1)
                move.l  #Map_SlotSpike,mappings(a1)
                move.w  #make_art_tile(ArtTile_SlotsBlocks+$155,1,0),art_tile(a1)
                move.b  #4,render_flags(a1)
                move.b  #$10,width_pixels(a1)
                move.w  #$200,priority(a1)
                move.w  #$1E,$40(a1)
                move.w  $32(a0),$32(a1)
                addi.w  #$90,$32(a0)
                move.w  x_pos(a0),$3C(a1)
                move.w  y_pos(a0),$3E(a1)
                move.w  $32(a1),d0
                jsr     (GetSineCosine).l
                asr.w   #1,d1
                add.w   $3C(a1),d1
                move.w  d1,$34(a1)
                move.w  d1,x_pos(a1)
                asr.w   #1,d0
                add.w   $3E(a1),d0
                move.w  d0,$38(a1)
                move.w  d0,y_pos(a1)
                lea     $30(a0),a2
                move.l  a2,$2E(a1)
                move.w  $42(a0),$42(a1)
                addq.w  #1,$30(a0)
                subq.w  #1,$2E(a0)

SlotsPlayer_WaitForSpikeChildren:
                tst.w   $30(a0)
                beq.w   SlotsPlayer_BeginCageRelease

SlotsPlayer_TickSpikePayoutWait:
                addq.w  #1,(SStage_scalar_index_2).w
                rts
; ---------------------------------------------------------------------------

; The branch on entry uses Z from the signed payout word loaded by the caller path
SlotsPlayer_TryOddPhaseRingSpawn:
                beq.w   SlotsPlayer_WaitForRingsAndRelease
                btst    #0,(Level_frame_counter+1).w
                beq.w   SlotsPlayer_RingPayoutUpdateReturn
                cmpi.w  #$10,$30(a0)
                bhs.w   SlotsPlayer_RingPayoutUpdateReturn
                jsr     (AllocateObject).l
                bne.w   SlotsPlayer_RingPayoutUpdateReturn
                move.l  #Obj_SlotRing,(a1)
                move.l  #Map_Ring,mappings(a1)
                move.w  #make_art_tile(ArtTile_Ring,1,0),art_tile(a1)
                move.b  #4,render_flags(a1)
                move.w  #$180,priority(a1)
                move.b  #8,width_pixels(a1)
                move.w  #$1A,$40(a1)
                move.w  $32(a0),$32(a1)
                addi.w  #$89,$32(a0)
                move.w  x_pos(a0),$3C(a1)
                move.w  y_pos(a0),$3E(a1)
                move.w  $32(a1),d0
                jsr     (GetSineCosine).l
                asr.w   #1,d1
                add.w   $3C(a1),d1
                move.w  d1,$34(a1)
                move.w  d1,x_pos(a1)
                asr.w   #1,d0
                add.w   $3E(a1),d0
                move.w  d0,$38(a1)
                move.w  d0,y_pos(a1)
                lea     $30(a0),a2
                move.l  a2,$2E(a1)
                move.w  $42(a0),$42(a1)
                addq.w  #1,$30(a0)
                subq.w  #1,(SStage_scalar_result_1+2).w

SlotsPlayer_WaitForRingsAndRelease:
                tst.w   $30(a0)
                beq.s   SlotsPlayer_BeginCageRelease

SlotsPlayer_RingPayoutUpdateReturn:
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_RefreshPlayerAndWaitOutcome:
                move.w  a1,$42(a0)
                cmpi.b  #$18,(SStage_scalar_result_0+2).w
                beq.w   SlotsPlayer_ChooseSignedPayoutPath
                move.b  (V_int_run_count+3).w,d0
                andi.w  #$F,d0
                bne.s   SlotsPlayer_CageOutcomeWaitReturn
                moveq   #signextendB(sfx_SlotMachine),d0
                jsr     (Play_SFX).l

SlotsPlayer_CageOutcomeWaitReturn:
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_BeginCageRelease:
                move.w  #0,$30(a0)
                addq.w  #2,(a2)+
                move.w  #8,(a2)
                clr.b   (Palette_cycle_counters+$00).w
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_ReleaseAtQuarterTurn:
                move.b  (Stat_table).w,d0
                andi.w  #$3C,d0
                bne.s   SlotsPlayer_CageReleaseReturn
                move.b  (Stat_table).w,d0
                andi.b  #$FC,d0
                jsr     (GetSineCosine).l
                asl.w   #2,d0
                asl.w   #2,d1
                move.w  d0,x_vel(a1)
                move.w  d1,y_vel(a1)
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                neg.w   (SStage_scalar_index_1).w
                addq.w  #2,(a2)+
                move.w  #8,(a2)

SlotsPlayer_CageReleaseReturn:
                rts
; ---------------------------------------------------------------------------

SlotsPlayer_TickCageRecaptureCooldown:
                subq.w  #1,2(a2)
                bpl.s   SlotsPlayer_CageCooldownReturn
                clr.w   (a2)
                clr.w   (SStage_scalar_result_0).w

SlotsPlayer_CageCooldownReturn:
                rts
; ---------------------------------------------------------------------------
Map_SlotBonusCage:
                include "src/objects/shared/zones/slots/mappings/bonus_cage_unused.s"
