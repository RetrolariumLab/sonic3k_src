; Owner: objects/zones/soz/sk
; Responsibility: Sandopolis rappel wire geometry, player attachment, constrained travel, character motion and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZRapelWire:
                movea.l a0,a1
                move.l  #SKSOZWire_WaitForP1Grab,(a1)
                bsr.w   InitializeSozRappelWirePieceDisplay
                move.b  #$20,mapping_frame(a1)
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  d2,$3E(a0)
                move.w  d3,$40(a0)
                move.b  subtype(a0),d1
                andi.b  #$F,d1
                move.b  d1,$36(a0)
                move.w  #$30,$32(a0)
                moveq   #$F,d1
                addq.w  #1,d1
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKSOZWire_EnterIdle
                move.w  a1,$44(a0)
                move.l  #SKSOZWire_LoadFirstLinkGeometry,(a1)
                move.w  a0,parent(a1)
                bra.s   SKSOZWire_InitAndCountLink
; ---------------------------------------------------------------------------

SKSOZWire_TryAllocNextLink:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKSOZWire_EnterIdle
                move.l  #SKSOZWire_FollowPreviousLink,(a1)
                move.w  a2,parent(a1)
                move.w  a1,$44(a2)
                move.w  a0,parent3(a1)

SKSOZWire_InitAndCountLink:
                movea.l a1,a2
                bsr.s   InitializeSozRappelWirePieceDisplay
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                addi.w  #$10,d3
                addq.w  #1,$34(a0)
                move.w  $34(a0),$34(a1)
                dbf     d1,SKSOZWire_TryAllocNextLink
                move.l  #SKSOZWire_MoveEndAndSaveOldX,(a1)
                move.b  #$21,mapping_frame(a1)
                move.w  a1,parent3(a0)

; Start the root even if only part of the chain could be allocated
SKSOZWire_EnterIdle:
                bra.s   SKSOZWire_WaitForP1Grab

; =============== S U B R O U T I N E =======================================

InitializeSozRappelWirePieceDisplay:
                move.b  #4,render_flags(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  #$280,priority(a1)
                move.l  #Map_SOZRapelWire,mappings(a1)
                move.w  #make_art_tile(ArtTile_SOZMisc+$48,2,0),art_tile(a1)
                move.b  status(a0),status(a1)
                move.w  x_pos(a0),$3E(a1)
                move.w  y_pos(a0),$40(a1)
                rts
; End of function InitializeSozRappelWirePieceDisplay

; ---------------------------------------------------------------------------

SKSOZWire_WaitForP1Grab:
                movea.w parent3(a0),a1
                tst.b   $38(a1)
                beq.s   SKSOZWire_DrawIdle
                move.l  #SKSOZWire_CheckP1BeforeExtension,(a0)

SKSOZWire_DrawIdle:
                bra.w   SKSOZWire_SetCullXFromRoot
; ---------------------------------------------------------------------------

SKSOZWire_CheckP1BeforeExtension:
                movea.w parent3(a0),a1
                tst.b   $38(a1)
                bne.s   SKSOZWire_StepInitialExtension
                move.l  #SKSOZWire_AlignBeforeRetraction,(a0)

SKSOZWire_StepInitialExtension:
                addq.w  #2,$32(a0)
                cmpi.w  #$C0,$32(a0)
                bne.s   SKSOZWire_DrawAfterExtension
                moveq   #signextendB(sfx_GlideLand),d0
                jsr     (Play_SFX).l
                move.l  #SKSOZWire_WaitForP1Action,(a0)
                move.w  #1,$2E(a0)

SKSOZWire_DrawAfterExtension:
                bra.w   SKSOZWire_SetCullXFromRoot
; ---------------------------------------------------------------------------

SKSOZWire_WaitForP1Action:
                movea.w parent3(a0),a1
                tst.b   $38(a1)
                bne.s   SKSOZWire_ChooseActionMotion
                move.l  #SKSOZWire_AlignBeforeRetraction,(a0)

SKSOZWire_ChooseActionMotion:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKSOZWire_DrawAfterAction
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                move.b  subtype(a0),d1
                andi.w  #$F0,d1
                bne.s   SKSOZWire_InitTravelSweep
                move.l  #SKSOZWire_CheckP1BeforeRepeatTurn,(a0)
                move.w  #$3F,$30(a0)
                move.b  #0,angle(a0)
                subq.b  #1,$36(a0)
                bne.s   SKSOZWire_DrawAfterAction
                move.l  #SKSOZWire_InitFinalTurn,(a0)
                bra.s   SKSOZWire_DrawAfterAction
; ---------------------------------------------------------------------------

SKSOZWire_InitTravelSweep:
                lsl.w   #1,d1
                subi.w  #6,d1
                subq.w  #1,d1
                move.w  d1,$30(a0)
                move.l  #SKSOZWire_MoveRepeatSweep,(a0)
                move.b  #$80,angle(a0)
                move.b  #$80,$37(a0)
                move.w  #$400,x_vel(a0)
                btst    #0,status(a0)
                bne.s   SKSOZWire_ReverseNextSweepAndCount
                neg.w   x_vel(a0)
                move.b  #0,$37(a0)

SKSOZWire_ReverseNextSweepAndCount:
                bchg    #0,status(a0)
                move.w  #3,$2E(a0)
                move.w  #6,$3C(a0)
                subq.b  #1,$36(a0)
                bne.s   SKSOZWire_DrawAfterAction
                move.l  #SKSOZWire_MoveFinalSweep,(a0)

SKSOZWire_DrawAfterAction:
                bra.w   SKSOZWire_SetCullXFromRoot
; ---------------------------------------------------------------------------

SKSOZWire_CheckP1BeforeRepeatTurn:
                movea.w parent3(a0),a1
                tst.b   $38(a1)
                bne.s   SKSOZWire_StepRepeatTurn
                move.l  #SKSOZWire_AlignBeforeRetraction,(a0)

SKSOZWire_StepRepeatTurn:
                addq.b  #2,angle(a0)
                addq.w  #2,$32(a0)
                subq.w  #1,$30(a0)
                bpl.s   SKSOZWire_DrawAfterRepeatTurn
                moveq   #signextendB(sfx_GlideLand),d0
                jsr     (Play_SFX).l
                move.l  #SKSOZWire_WaitForP1Action,(a0)

SKSOZWire_DrawAfterRepeatTurn:
                bra.w   SKSOZWire_SetCullXFromRoot
; ---------------------------------------------------------------------------

SKSOZWire_InitFinalTurn:
                move.w  #2,$2E(a0)
                move.l  #SKSOZWire_CheckP1BeforeFinalTurn,(a0)

SKSOZWire_CheckP1BeforeFinalTurn:
                movea.w parent3(a0),a1
                tst.b   $38(a1)
                bne.s   SKSOZWire_StepFinalTurnAndSavePhase
                move.l  #SKSOZWire_AlignBeforeRetraction,(a0)

SKSOZWire_StepFinalTurnAndSavePhase:
                addq.b  #2,angle(a0)
                addq.w  #2,$32(a0)
                subq.w  #1,$30(a0)
                bpl.s   SKSOZWire_DrawAfterFinalTurn
                move.b  angle(a0),$27(a0)
                move.l  #SKSOZWire_CheckP1BeforeLimitedTurn,(a0)

SKSOZWire_DrawAfterFinalTurn:
                bra.w   SKSOZWire_SetCullXFromRoot
; ---------------------------------------------------------------------------

SKSOZWire_MoveRepeatSweep:
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                tst.b   $38(a1)
                bne.s   SKSOZWire_CheckRepeatSweepPose
                move.l  #SKSOZWire_AlignBeforeRetraction,(a0)

; Select pose mode 1 when the remaining countdown reaches $1A exactly
SKSOZWire_CheckRepeatSweepPose:
                cmpi.w  #$1A,$30(a0)
                blo.s   SKSOZWire_StepRepeatTravel
                bne.s   SKSOZWire_StepTravelPose
                move.w  #1,$2E(a0)

SKSOZWire_StepTravelPose:
                addq.b  #4,$37(a0)

SKSOZWire_StepRepeatTravel:
                addq.b  #2,angle(a0)
                addq.w  #1,$32(a0)
                subq.w  #1,$30(a0)
                bpl.s   SKSOZWire_TryExtraRepeatStep
                move.w  #0,x_vel(a0)
                moveq   #signextendB(sfx_GlideLand),d0
                jsr     (Play_SFX).l
                move.l  #SKSOZWire_WaitForP1Action,(a0)

SKSOZWire_TryExtraRepeatStep:
                tst.w   $3C(a0)
                beq.s   SKSOZWire_DrawAfterRepeatTravel
                subq.w  #1,$3C(a0)
                addq.w  #1,$32(a0)
                addq.b  #2,angle(a0)

SKSOZWire_DrawAfterRepeatTravel:
                bra.w   SKSOZWire_SetCullXFromRoot
; ---------------------------------------------------------------------------

SKSOZWire_MoveFinalSweep:
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                tst.b   $38(a1)
                bne.s   SKSOZWire_TryStepFinalTravelPose
                move.l  #SKSOZWire_AlignBeforeRetraction,(a0)

SKSOZWire_TryStepFinalTravelPose:
                cmpi.w  #$1A,$30(a0)
                blo.s   SKSOZWire_StepFinalTravel
                addq.b  #4,$37(a0)

SKSOZWire_StepFinalTravel:
                addq.b  #2,angle(a0)
                addq.w  #1,$32(a0)
                subq.w  #1,$30(a0)
                bpl.s   SKSOZWire_TryExtraFinalStep
                move.w  #0,x_vel(a0)
                move.w  #2,$2E(a0)
                move.b  angle(a0),$27(a0)
                move.l  #SKSOZWire_CheckP1BeforeLimitedTurn,(a0)

SKSOZWire_TryExtraFinalStep:
                tst.w   $3C(a0)
                beq.s   SKSOZWire_DrawAfterFinalTravel
                subq.w  #1,$3C(a0)
                addq.w  #1,$32(a0)
                addq.b  #2,angle(a0)

SKSOZWire_DrawAfterFinalTravel:
                bra.w   SKSOZWire_SetCullXFromRoot
; ---------------------------------------------------------------------------

SKSOZWire_CheckP1BeforeLimitedTurn:
                movea.w $46(a0),a1
                tst.b   $38(a1)
                bne.s   SKSOZWire_StepLimitedTurn
                move.l  #SKSOZWire_AlignBeforeRetraction,(a0)

; Advance the phase each frame. The angle holds while phase is in $86 through $FB
SKSOZWire_StepLimitedTurn:
                addq.b  #2,$27(a0)
                cmpi.b  #-4,$27(a0)
                bhs.s   SKSOZWire_ApplyFinalPhase
                cmpi.b  #-$7A,$27(a0)
                bhs.s   SKSOZWire_DrawAfterLimitedTurn

SKSOZWire_ApplyFinalPhase:
                move.b  $27(a0),angle(a0)

SKSOZWire_DrawAfterLimitedTurn:
                bra.w   SKSOZWire_SetCullXFromRoot
; ---------------------------------------------------------------------------

SKSOZWire_AlignBeforeRetraction:
                tst.b   angle(a0)
                beq.s   SKSOZWire_RetractAndResetAtMinimum
                cmpi.b  #-$7A,$27(a0)
                bhs.s   SKSOZWire_WaitAtNearUprightAngle
                addq.b  #2,angle(a0)
                cmpi.b  #$80,angle(a0)
                blo.s   SKSOZWire_ClearRetractionPhase
                cmpi.b  #-4,angle(a0)
                bhs.s   SKSOZWire_ClearRetractionPhase
                move.b  #0,angle(a0)

SKSOZWire_ClearRetractionPhase:
                move.b  #0,$27(a0)
                bra.s   SKSOZWire_RetractAndResetAtMinimum
; ---------------------------------------------------------------------------

SKSOZWire_WaitAtNearUprightAngle:
                move.b  #-4,angle(a0)
                addq.b  #2,$27(a0)
                bmi.s   SKSOZWire_SetCullXFromRoot

SKSOZWire_RetractAndResetAtMinimum:
                subq.w  #4,$32(a0)
                cmpi.w  #$30,$32(a0)
                bhi.s   SKSOZWire_SetCullXFromRoot
                move.w  #$30,$32(a0)
                move.w  #0,$2E(a0)
                move.b  subtype(a0),d1
                andi.b  #$F,d1
                move.b  d1,$36(a0)
                move.l  #SKSOZWire_WaitForP1Grab,(a0)
                move.w  $3E(a0),d0
                bra.s   SKSOZWire_DrawOrCullWire
; ---------------------------------------------------------------------------

SKSOZWire_SetCullXFromRoot:
                move.w  x_pos(a0),d0

SKSOZWire_DrawOrCullWire:
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKSOZWire_BeginLinkCleanup
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSOZWire_BeginLinkCleanup:
                move.w  $34(a0),d2
                subq.w  #1,d2
                bcs.s   SKSOZWire_ClearPlacementRespawn
                movea.w $44(a0),a2

SKSOZWire_DeleteAndAdvanceLink:
                movea.l a2,a1
                movea.w $44(a1),a2
                jsr     (Delete_Referenced_Sprite).l
                dbf     d2,SKSOZWire_DeleteAndAdvanceLink

SKSOZWire_ClearPlacementRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   SKSOZWire_DeleteRoot
                movea.w d0,a2
                bclr    #7,(a2)

SKSOZWire_DeleteRoot:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSOZWire_LoadFirstLinkGeometry:
                movea.w parent(a0),a1
                move.w  angle(a1),angle(a0)
                move.w  $32(a1),$32(a0)
                move.b  angle(a0),d0
                btst    #0,status(a1)
                bne.s   SKSOZWire_CalcWireStepVector
                addi.b  #$80,d0

; Scale the Q14 sine and cosine by $20 divided by the current wire length
SKSOZWire_CalcWireStepVector:
                jsr     (GetSineCosineQ14).l
                muls.w  #$20,d0
                move.w  $32(a0),d2
                divs.w  d2,d0
                move.w  d0,x_vel(a0)
                move.w  d0,d1
                asr.w   #4,d1
                jsr     (GetArcTan).l
                jsr     (GetSineCosineQ14).l
                asr.w   #2,d0
                move.w  d0,y_vel(a0)
                moveq   #0,d0
                moveq   #0,d1
                move.w  d2,d4
                move.w  d2,d5
                neg.w   d5
                andi.w  #$F,d5
                move.w  x_vel(a0),d2
                ext.l   d2
                lsl.l   #4,d2
                move.w  y_vel(a0),d3
                ext.l   d3
                lsl.l   #4,d3
                subq.w  #1,d5
                bcs.s   SKSOZWire_CalcWholeLinkStep
                addi.w  #$10,d4

SKSOZWire_SubtractFractionalSteps:
                sub.l   d2,d0
                sub.l   d3,d1
                dbf     d5,SKSOZWire_SubtractFractionalSteps

SKSOZWire_CalcWholeLinkStep:
                lsl.l   #4,d2
                lsl.l   #4,d3
                lsr.w   #4,d4
                subi.w  #$10,d4
                bcc.s   SKSOZWire_PrepareWholeStepCount
                neg.w   d4
                neg.l   d2
                neg.l   d3

SKSOZWire_PrepareWholeStepCount:
                subq.w  #1,d4
                bcs.s   SKSOZWire_PlaceFirstLinkAndSetFrame

SKSOZWire_AccumulateWholeSteps:
                add.l   d2,d0
                add.l   d3,d1
                dbf     d4,SKSOZWire_AccumulateWholeSteps

SKSOZWire_PlaceFirstLinkAndSetFrame:
                add.l   x_pos(a1),d0
                move.l  d0,x_pos(a0)
                add.l   y_pos(a1),d1
                move.l  d1,y_pos(a0)
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                addi.b  #-$40,d0
                addq.b  #4,d0
                lsr.b   #3,d0
                move.b  d0,mapping_frame(a0)
                move.w  y_pos(a0),d0
                addi.w  #$10,d0
                cmp.w   $40(a0),d0
                ble.s   SKSOZWire_FirstLinkDrawReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSOZWire_FirstLinkDrawReturn:
                rts
; ---------------------------------------------------------------------------

; Link ordinal $D can change direction for the remaining links
SKSOZWire_FollowPreviousLink:
                movea.w parent(a0),a1
                move.b  mapping_frame(a1),mapping_frame(a0)
                bsr.w   PositionSozRappelPieceFromPreviousLink
                cmpi.w  #$D,$34(a0)
                bne.s   SKSOZWire_TryDrawIntermediateLink
                movea.w parent3(a0),a2
                cmpi.w  #2,$2E(a2)
                bne.s   SKSOZWire_TryDrawIntermediateLink
                cmpi.b  #-$7A,$27(a2)
                blo.s   SKSOZWire_TryDrawIntermediateLink
                bsr.s   BendSozRappelWireSegmentDirection

SKSOZWire_TryDrawIntermediateLink:
                move.w  y_pos(a0),d0
                addi.w  #$10,d0
                cmp.w   $40(a0),d0
                ble.s   SKSOZWire_IntermediateDrawReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSOZWire_IntermediateDrawReturn:
                rts

; =============== S U B R O U T I N E =======================================

BendSozRappelWireSegmentDirection:
                move.b  $27(a2),d0
                btst    #0,status(a2)
                beq.s   SKSOZWire_CalcBendVectorAndFrame
                addi.b  #$80,d0

SKSOZWire_CalcBendVectorAndFrame:
                jsr     (GetSineCosine).l
                muls.w  #$3C,d0
                asr.w   #8,d0
                addi.w  #$40,d0
                jsr     (GetSineCosineQ14).l
                asr.w   #2,d1
                move.w  d1,x_vel(a0)
                asr.w   #2,d0
                move.w  d0,y_vel(a0)
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                addi.b  #-$40,d0
                addq.b  #4,d0
                lsr.b   #3,d0
                move.b  d0,mapping_frame(a0)
                rts
; End of function BendSozRappelWireSegmentDirection

; =============== S U B R O U T I N E =======================================

PositionSozRappelPieceFromPreviousLink:
                move.w  x_vel(a1),d0
                move.w  d0,x_vel(a0)
                ext.l   d0
                lsl.l   #8,d0
                add.l   x_pos(a1),d0
                move.l  d0,x_pos(a0)
                move.w  y_vel(a1),d1
                move.w  d1,y_vel(a0)
                ext.l   d1
                lsl.l   #8,d1
                add.l   y_pos(a1),d1
                move.l  d1,y_pos(a0)
                rts
; End of function PositionSozRappelPieceFromPreviousLink

; ---------------------------------------------------------------------------

SKSOZWire_MoveEndAndSaveOldX:
                move.w  x_pos(a0),d4
                move.w  y_pos(a0),d5
                movea.w parent(a0),a1
                bsr.w   PositionSozRappelPieceFromPreviousLink
                cmp.w   x_pos(a0),d4
                beq.s   SKSOZWire_TrySaveOldEndY
                move.w  d4,$3E(a0)

SKSOZWire_TrySaveOldEndY:
                cmp.w   y_pos(a0),d5
                beq.s   SKSOZWire_UpdateRidersAndEndPose
                move.w  d5,$40(a0)

SKSOZWire_UpdateRidersAndEndPose:
                movea.w parent3(a0),a3
                lea     $38(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d0
                bsr.s   UpdateSozRappelEndpointPlayerAttachment
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2_logical).w,d0
                bsr.s   UpdateSozRappelEndpointPlayerAttachment
                move.b  #$21,mapping_frame(a0)
                cmpi.w  #3,$2E(a3)
                bne.s   SKSOZWire_DrawEndpoint
                moveq   #0,d0
                move.b  $37(a3),d0
                addq.b  #4,d0
                lsr.w   #4,d0
                move.b  SKSOZWire_TravelEndFrames(pc,d0.w),mapping_frame(a0)

SKSOZWire_DrawEndpoint:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
SKSOZWire_TravelEndFrames:
                dc.b    $24, $25, $26, $26, $21, $22, $22, $23, $24, $25, $26, $26, $21, $22, $22, $23
                even

; =============== S U B R O U T I N E =======================================

UpdateSozRappelEndpointPlayerAttachment:
                tst.b   (a2)
                beq.w   SKSOZWire_TickRecaptureCooldown
                bmi.w   SKSOZWire_EjectMarkedRider
                tst.b   render_flags(a1)
                bpl.w   SKSOZWire_ReleaseRiderWithCooldown
                cmpi.b  #4,routine(a1)
                bhs.w   SKSOZWire_ReleaseRiderWithCooldown
                tst.w   (Debug_placement_mode).w
                bne.w   SKSOZWire_ReleaseRiderWithCooldown
                cmpi.w  #2,$2E(a3)
                bne.w   SKSOZWire_PlaceRiderAndSelectPose
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   SKSOZWire_PlaceRiderAndSelectPose
                clr.b   object_control(a1)
                clr.b   (a2)
                move.w  x_pos(a0),d1
                sub.w   $3E(a0),d1
                asl.w   #8,d1
                move.w  d1,x_vel(a1)
                move.w  y_pos(a0),d1
                sub.w   $40(a0),d1
                asl.w   #8,d1
                move.w  d1,y_vel(a1)
                move.b  #60,2(a2)
                btst    #button_left+8,d0
                beq.s   SKSOZWire_TrySetJumpRight
                move.w  #-$200,x_vel(a1)

SKSOZWire_TrySetJumpRight:
                btst    #button_right+8,d0
                beq.s   SKSOZWire_ApplyJumpImpulseAndRoll
                move.w  #$200,x_vel(a1)

SKSOZWire_ApplyJumpImpulseAndRoll:
                addi.w  #-$380,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SKSOZWire_EjectMarkedRider:
                move.w  #$300,x_vel(a1)
                move.w  #$200,y_vel(a1)
                bset    #Status_InAir,status(a1)

SKSOZWire_ReleaseRiderWithCooldown:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #60,2(a2)
                rts
; ---------------------------------------------------------------------------

SKSOZWire_PlaceRiderAndSelectPose:
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$14,y_pos(a1)
                move.w  $2E(a3),d0
                bne.s   SKSOZWire_TryMode1RiderPose
                move.b  #$14,anim(a1)
                move.b  #$92,mapping_frame(a1)
                bra.s   SKSOZWire_UploadRiderPatterns
; ---------------------------------------------------------------------------

SKSOZWire_TryMode1RiderPose:
                cmpi.w  #1,d0
                bne.s   SKSOZWire_TryMode2RiderPose
                move.b  #$14,anim(a1)
                moveq   #0,d0
                move.b  angle(a3),d0
                add.b   d0,d0
                addq.b  #8,d0
                lsr.w   #4,d0
                move.b  SKSOZWire_Mode1RiderFrames(pc,d0.w),mapping_frame(a1)

SKSOZWire_UploadRiderPatterns:
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------
SKSOZWire_Mode1RiderFrames:
                dc.b    $93, $92, $92, $92, $91, $91, $90, $90, $90, $90, $90, $91, $91, $92, $92, $92
                even
; ---------------------------------------------------------------------------

SKSOZWire_TryMode2RiderPose:
                cmpi.w  #2,d0
                bne.s   SKSOZWire_SetTravelRiderPose
                move.b  #$14,anim(a1)
                moveq   #0,d0
                move.b  angle(a3),d0
                addq.b  #8,d0
                lsr.w   #4,d0
                move.b  SKSOZWire_Mode2RiderFrames(pc,d0.w),mapping_frame(a1)
                bra.s   SKSOZWire_UploadRiderPatterns
; ---------------------------------------------------------------------------
SKSOZWire_Mode2RiderFrames:
                dc.b    $90, $90, $90, $90, $90, $90, $90, $90, $91, $92, $92, $92, $92, $92, $92, $91
                even
; ---------------------------------------------------------------------------

SKSOZWire_SetTravelRiderPose:
                move.b  #0,anim(a1)
                moveq   #0,d0
                move.b  $37(a3),d0
                addq.b  #4,d0
                lsr.w   #4,d0
                move.b  SKSOZWire_TravelRiderFrames(pc,d0.w),mapping_frame(a1)
                move.b  SKSOZWire_TravelRiderFlipBits(pc,d0.w),d0
                andi.b  #$FC,render_flags(a1)
                or.b    d0,render_flags(a1)
                andi.b  #$FC,status(a1)
                or.b    d0,status(a1)
                bra.w   SKSOZWire_UploadRiderPatterns
; ---------------------------------------------------------------------------
SKSOZWire_TravelRiderFrames:
                dc.b    $E4, $E5, $E6, $E6, $E7, $E6, $E6, $E5, $E4, $E8, $E9, $E9, $EA, $E9, $E9, $E8
SKSOZWire_TravelRiderFlipBits:
                dc.b    0,   0,   0,   0,   0,   1,   1,   1,   1,   0,   0,   0,   0,   1,   1,   1
                even
; ---------------------------------------------------------------------------

SKSOZWire_TickRecaptureCooldown:
                tst.b   2(a2)
                beq.s   SKSOZWire_TryCaptureRider
                subq.b  #1,2(a2)
                bne.w   SKSOZWire_CaptureReturn

SKSOZWire_TryCaptureRider:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   SKSOZWire_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                cmpi.w  #$18,d1
                bhs.w   SKSOZWire_CaptureReturn
                tst.b   object_control(a1)
                bne.s   SKSOZWire_CaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.s   SKSOZWire_CaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKSOZWire_CaptureReturn
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$14,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #0,spin_dash_flag(a1)
                move.b  #3,object_control(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  status(a3),d0
                andi.b  #1,d0
                or.b    d0,render_flags(a1)
                andi.b  #$FC,status(a1)
                or.b    d0,status(a1)
                move.b  #1,(a2)
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

SKSOZWire_CaptureReturn:
                rts
; End of function UpdateSozRappelEndpointPlayerAttachment

; ---------------------------------------------------------------------------
Map_SOZRapelWire:
                include "src/objects/shared/zones/soz/mappings/rapel_wire.s"
