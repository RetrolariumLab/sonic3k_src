; Owner: objects/players/tails/sk
; Responsibility: Normal Tails and tail animation sequences with dynamic pattern loading
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Tails:
                lea     (AniTails).l,a1

Animate_Tails_Part2:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   SKTailsAnimation_ResolveRelativeAnimationHeaderAndTimedOrdinaryFrames
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

SKTailsAnimation_ResolveRelativeAnimationHeaderAndTimedOrdinaryFrames:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   SKTailsAnimation_SelectWalkTumbleOrOtherNegativeHeaderDriver
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKTailsAnimation_ReturnAfterAnimationHoldOrStoredFrame
                move.b  d0,anim_frame_timer(a0)
; End of function Animate_Tails

; =============== S U B R O U T I N E =======================================

TailsSKStepNormalAnimationFrameBytecode:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$FC,d0
                bhs.s   SKTailsAnimation_ResolveFullStreamLoopCommandOrTryBacktrack

SKTailsAnimation_StoreInterpretedMappingFrameAndAdvanceByteCursor:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

SKTailsAnimation_ReturnAfterAnimationHoldOrStoredFrame:
                rts
; ---------------------------------------------------------------------------

SKTailsAnimation_ResolveFullStreamLoopCommandOrTryBacktrack:
                addq.b  #1,d0
                bne.s   SKTailsAnimation_ResolveByteBacktrackCommandOrTryAnimationChange
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   SKTailsAnimation_StoreInterpretedMappingFrameAndAdvanceByteCursor
; ---------------------------------------------------------------------------

SKTailsAnimation_ResolveByteBacktrackCommandOrTryAnimationChange:
                addq.b  #1,d0
                bne.s   SKTailsAnimation_DeferRequestedAnimationChangeForFdCommand
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   SKTailsAnimation_StoreInterpretedMappingFrameAndAdvanceByteCursor
; ---------------------------------------------------------------------------

SKTailsAnimation_DeferRequestedAnimationChangeForFdCommand:
                addq.b  #1,d0
                bne.s   SKTailsAnimation_ReturnAfterAnimationCommandChangeOrIgnoredOpcode
                move.b  2(a1,d1.w),anim(a0)

SKTailsAnimation_ReturnAfterAnimationCommandChangeOrIgnoredOpcode:
                rts
; End of function TailsSKStepNormalAnimationFrameBytecode

; ---------------------------------------------------------------------------

SKTailsAnimation_SelectWalkTumbleOrOtherNegativeHeaderDriver:
                addq.b  #1,d0
                bne.w   SKTailsAnimation_SelectRollHeaderOrDirectionalTailFallback
                moveq   #0,d0
                tst.b   flip_type(a0)
                bmi.w   Anim_Tumble
                move.b  flip_angle(a0),d0
                bne.w   Anim_Tumble
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   SKTailsAnimation_ReflectMovementAngleForCurrentFacing
                beq.s   SKTailsAnimation_ReflectMovementAngleForCurrentFacing
                subq.b  #1,d0

SKTailsAnimation_ReflectMovementAngleForCurrentFacing:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKTailsAnimation_ChooseMovementRenderFlipPairFromWrappedAngle
                not.b   d0

SKTailsAnimation_ChooseMovementRenderFlipPairFromWrappedAngle:
                addi.b  #$10,d0
                bpl.s   SKTailsAnimation_ApplyMovementFlipsAndChoosePushOrAngularSpeedGroup
                moveq   #3,d1

SKTailsAnimation_ApplyMovementFlipsAndChoosePushOrAngularSpeedGroup:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   SKTailsAnimation_GatePushAnimationStepBySignedByteTimer
                lsr.b   #4,d0
                andi.b  #6,d0
                move.w  ground_vel(a0),d2
                bpl.s   SKTailsAnimation_DoubleAnimationSpeedForSecondaryStatusSignBit
                neg.w   d2

SKTailsAnimation_DoubleAnimationSpeedForSecondaryStatusSignBit:
                tst.b   status_secondary(a0)
                bpl.w   SKTailsAnimation_ChooseWalkRunOrFastRunStreamAndAngularFrameStride
                add.w   d2,d2

SKTailsAnimation_ChooseWalkRunOrFastRunStreamAndAngularFrameStride:
                move.b  d0,d3
                add.b   d3,d3
                add.b   d3,d3
                lea     (AniTails00).l,a1
                cmpi.w  #$600,d2
                blo.s   SKTailsAnimation_ReadMovementFrameAndRestartOnFfTerminator
                lea     (AniTails01).l,a1
                move.b  d0,d3
                add.b   d3,d3
                cmpi.w  #$700,d2
                blo.s   SKTailsAnimation_ReadMovementFrameAndRestartOnFfTerminator
                lea     (AniTails1F).l,a1
                move.b  d0,d3

SKTailsAnimation_ReadMovementFrameAndRestartOnFfTerminator:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   SKTailsAnimation_WriteAngularMovementFrameBeforeTimerGate
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

SKTailsAnimation_WriteAngularMovementFrameBeforeTimerGate:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKTailsAnimation_ReturnAfterMovementFrameRefreshOrCursorStep
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   SKTailsAnimation_ReloadMovementDelayAndAdvanceFrameCursor
                moveq   #0,d2

SKTailsAnimation_ReloadMovementDelayAndAdvanceFrameCursor:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

SKTailsAnimation_ReturnAfterMovementFrameRefreshOrCursorStep:
                rts
; ---------------------------------------------------------------------------

SKTailsAnimation_SelectRollHeaderOrDirectionalTailFallback:
                addq.b  #1,d0
                bne.s   SKTailsAnimation_DeriveDirectionalTailFrameAngleFromParentVelocity
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKTailsAnimation_ReturnAfterAnimationHoldOrStoredFrame
                move.w  ground_vel(a0),d2
                bpl.s   SKTailsAnimation_ChooseRollSpeedStreamAtSixHundred
                neg.w   d2

SKTailsAnimation_ChooseRollSpeedStreamAtSixHundred:
                lea     (AniTails03).l,a1
                cmpi.w  #$600,d2
                bhs.s   SKTailsAnimation_ComputeWrappedRollFrameDuration
                lea     (AniTails02).l,a1

SKTailsAnimation_ComputeWrappedRollFrameDuration:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   SKTailsAnimation_ReloadRollTimerAndStepNormalBytecode
                moveq   #0,d2

SKTailsAnimation_ReloadRollTimerAndStepNormalBytecode:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                bra.w   TailsSKStepNormalAnimationFrameBytecode
; ---------------------------------------------------------------------------

SKTailsAnimation_GatePushAnimationStepBySignedByteTimer:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKTailsAnimation_ReturnAfterAnimationHoldOrStoredFrame
                move.w  ground_vel(a0),d2
                bmi.s   SKTailsAnimation_ClampWrappedPushDelayAfterAddingEightHundred
                neg.w   d2

SKTailsAnimation_ClampWrappedPushDelayAfterAddingEightHundred:
                addi.w  #$800,d2
                bpl.s   SKTailsAnimation_ReloadPushDelayAndInterpretPushSequence
                moveq   #0,d2

SKTailsAnimation_ReloadPushDelayAndInterpretPushSequence:
                lsr.w   #6,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniTails04).l,a1
                bra.w   TailsSKStepNormalAnimationFrameBytecode
; ---------------------------------------------------------------------------

SKTailsAnimation_DeriveDirectionalTailFrameAngleFromParentVelocity:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKTailsAnimation_ReturnAfterAnimationHoldOrStoredFrame
                move.w  x_vel(a2),d1
                move.w  y_vel(a2),d2
                jsr     (GetArcTan).l
                cmpi.b  #$15,(Current_zone).w
                bne.s   SKTailsAnimation_OrientDirectionalTailAfterOptionalSlotsRotation
                add.b   (Stat_table).w,d0

SKTailsAnimation_OrientDirectionalTailAfterOptionalSlotsRotation:
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKTailsAnimation_RotateDirectionalTailAngleForFacingSet
                not.b   d0
                bra.s   SKTailsAnimation_ChooseDirectionalTailRenderFlipQuadrant
; ---------------------------------------------------------------------------

SKTailsAnimation_RotateDirectionalTailAngleForFacingSet:
                addi.b  #$80,d0

SKTailsAnimation_ChooseDirectionalTailRenderFlipQuadrant:
                addi.b  #$10,d0
                bpl.s   SKTailsAnimation_CommitDirectionalTailFlipsAndPrepareAngularFrameGroup
                moveq   #3,d1

SKTailsAnimation_CommitDirectionalTailFlipsAndPrepareAngularFrameGroup:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsAnimation_StepDirectionalTailFrameAfterGravityFlip
                eori.b  #2,render_flags(a0)

SKTailsAnimation_StepDirectionalTailFrameAfterGravityFlip:
                lsr.b   #3,d0
                andi.b  #$C,d0
                move.b  d0,d3
                lea     (AniTails_Tail03).l,a1
                move.b  #3,anim_frame_timer(a0)
                bsr.w   TailsSKStepNormalAnimationFrameBytecode
                add.b   d3,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
AniTails:
                include "src/objects/shared/tails/animations/tails.s"
; ---------------------------------------------------------------------------

Tails_Tail_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   (Player_prev_frame_P2_tail).w,d0
                beq.w   SKTailsAnimation_ReturnAfterUnchangedFrameEmptyCueOrQueuedPatternList
                move.b  d0,(Player_prev_frame_P2_tail).w
                lea     (PLC_Tails_Tail).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   SKTailsAnimation_ReturnAfterUnchangedFrameEmptyCueOrQueuedPatternList
                move.w  #tiles_to_bytes(ArtTile_Player_2_Tail),d4
                move.l  #ArtUnc_Tails_Tail,d6
                bra.s   SKTailsAnimation_QueuePackedBodyOrTailPatternTransfersAndAdvanceVram

; =============== S U B R O U T I N E =======================================

Tails_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0

Tails_Load_PLC2:
                cmp.b   (Player_prev_frame_P2).w,d0
                beq.s   SKTailsAnimation_ReturnAfterUnchangedFrameEmptyCueOrQueuedPatternList
                move.b  d0,(Player_prev_frame_P2).w
                lea     (PLC_Tails).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   SKTailsAnimation_ReturnAfterUnchangedFrameEmptyCueOrQueuedPatternList
                move.w  #tiles_to_bytes(ArtTile_Player_2),d4
                move.l  #ArtUnc_Tails,d6
                cmpi.w  #2*$D1,d0
                blo.s   SKTailsAnimation_QueuePackedBodyOrTailPatternTransfersAndAdvanceVram
                move.l  #ArtUnc_Tails_Extra,d6

SKTailsAnimation_QueuePackedBodyOrTailPatternTransfersAndAdvanceVram:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,SKTailsAnimation_QueuePackedBodyOrTailPatternTransfersAndAdvanceVram

SKTailsAnimation_ReturnAfterUnchangedFrameEmptyCueOrQueuedPatternList:
                rts
; End of function Tails_Load_PLC

; =============== S U B R O U T I N E =======================================
