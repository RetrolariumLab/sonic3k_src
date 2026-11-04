; Owner: objects/players/tails/s3
; Responsibility: Normal Tails and tail animation sequences with dynamic pattern loading
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Tails:
                lea     (AniTails).l,a1

Animate_Tails_Part2:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   S3TailsAnimation_ResolveRelativeAnimationHeaderAndTimedOrdinaryFrames
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

S3TailsAnimation_ResolveRelativeAnimationHeaderAndTimedOrdinaryFrames:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   S3TailsAnimation_SelectWalkTumbleOrOtherNegativeHeaderDriver
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3TailsAnimation_ReturnAfterAnimationHoldOrStoredFrame
                move.b  d0,anim_frame_timer(a0)
; End of function Animate_Tails

; =============== S U B R O U T I N E =======================================

TailsS3StepNormalAnimationFrameBytecode:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$F0,d0
                bhs.s   S3TailsAnimation_ResolveFullStreamLoopCommandOrTryBacktrack

S3TailsAnimation_StoreInterpretedMappingFrameAndAdvanceByteCursor:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

S3TailsAnimation_ReturnAfterAnimationHoldOrStoredFrame:
                rts
; ---------------------------------------------------------------------------

S3TailsAnimation_ResolveFullStreamLoopCommandOrTryBacktrack:
                addq.b  #1,d0
                bne.s   S3TailsAnimation_ResolveByteBacktrackCommandOrTryAnimationChange
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   S3TailsAnimation_StoreInterpretedMappingFrameAndAdvanceByteCursor
; ---------------------------------------------------------------------------

S3TailsAnimation_ResolveByteBacktrackCommandOrTryAnimationChange:
                addq.b  #1,d0
                bne.s   S3TailsAnimation_DeferRequestedAnimationChangeForFdCommand
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   S3TailsAnimation_StoreInterpretedMappingFrameAndAdvanceByteCursor
; ---------------------------------------------------------------------------

S3TailsAnimation_DeferRequestedAnimationChangeForFdCommand:
                addq.b  #1,d0
                bne.s   S3TailsAnimation_ReturnAfterAnimationCommandChangeOrIgnoredOpcode
                move.b  2(a1,d1.w),anim(a0)

S3TailsAnimation_ReturnAfterAnimationCommandChangeOrIgnoredOpcode:
                rts
; End of function TailsS3StepNormalAnimationFrameBytecode

; ---------------------------------------------------------------------------

S3TailsAnimation_SelectWalkTumbleOrOtherNegativeHeaderDriver:
                addq.b  #1,d0
                bne.w   S3TailsAnimation_SelectRollHeaderOrDirectionalTailFallback
                moveq   #0,d0
                tst.b   flip_type(a0)
                bmi.w   Anim_Tumble
                move.b  flip_angle(a0),d0
                bne.w   Anim_Tumble
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   S3TailsAnimation_ReflectMovementAngleForCurrentFacing
                beq.s   S3TailsAnimation_ReflectMovementAngleForCurrentFacing
                subq.b  #1,d0

S3TailsAnimation_ReflectMovementAngleForCurrentFacing:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3TailsAnimation_ChooseMovementRenderFlipPairFromWrappedAngle
                not.b   d0

S3TailsAnimation_ChooseMovementRenderFlipPairFromWrappedAngle:
                addi.b  #$10,d0
                bpl.s   S3TailsAnimation_ApplyMovementFlipsAndChoosePushOrAngularSpeedGroup
                moveq   #3,d1

S3TailsAnimation_ApplyMovementFlipsAndChoosePushOrAngularSpeedGroup:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   S3TailsAnimation_GatePushAnimationStepBySignedByteTimer
                lsr.b   #4,d0
                andi.b  #6,d0
                move.w  ground_vel(a0),d2
                bpl.s   S3TailsAnimation_DoubleAnimationSpeedForSecondaryStatusSignBit
                neg.w   d2

S3TailsAnimation_DoubleAnimationSpeedForSecondaryStatusSignBit:
                tst.b   status_secondary(a0)
                bpl.w   S3TailsAnimation_ChooseWalkRunOrFastRunStreamAndAngularFrameStride
                add.w   d2,d2

S3TailsAnimation_ChooseWalkRunOrFastRunStreamAndAngularFrameStride:
                move.b  d0,d3
                add.b   d3,d3
                add.b   d3,d3
                lea     (AniTails00).l,a1
                cmpi.w  #$600,d2
                blo.s   S3TailsAnimation_ReadMovementFrameAndRestartOnFfTerminator
                lea     (AniTails01).l,a1
                move.b  d0,d3
                add.b   d3,d3
                cmpi.w  #$700,d2
                blo.s   S3TailsAnimation_ReadMovementFrameAndRestartOnFfTerminator
                lea     (AniTails1F).l,a1
                move.b  d0,d3

S3TailsAnimation_ReadMovementFrameAndRestartOnFfTerminator:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   S3TailsAnimation_WriteAngularMovementFrameBeforeTimerGate
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

S3TailsAnimation_WriteAngularMovementFrameBeforeTimerGate:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3TailsAnimation_ReturnAfterMovementFrameRefreshOrCursorStep
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   S3TailsAnimation_ReloadMovementDelayAndAdvanceFrameCursor
                moveq   #0,d2

S3TailsAnimation_ReloadMovementDelayAndAdvanceFrameCursor:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

S3TailsAnimation_ReturnAfterMovementFrameRefreshOrCursorStep:
                rts
; ---------------------------------------------------------------------------

S3TailsAnimation_SelectRollHeaderOrDirectionalTailFallback:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   S3TailsAnimation_ReturnAfterAnimationHoldOrStoredFrame
                addq.b  #1,d0
                bne.s   S3TailsAnimation_DeriveDirectionalTailFrameAngleFromParentVelocity
                move.w  ground_vel(a0),d2
                bpl.s   S3TailsAnimation_ChooseRollSpeedStreamAtSixHundred
                neg.w   d2

S3TailsAnimation_ChooseRollSpeedStreamAtSixHundred:
                lea     (AniTails03).l,a1
                cmpi.w  #$600,d2
                bhs.s   S3TailsAnimation_ComputeWrappedRollFrameDuration
                lea     (AniTails02).l,a1

S3TailsAnimation_ComputeWrappedRollFrameDuration:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   S3TailsAnimation_ReloadRollTimerAndStepNormalBytecode
                moveq   #0,d2

S3TailsAnimation_ReloadRollTimerAndStepNormalBytecode:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   TailsS3StepNormalAnimationFrameBytecode
; ---------------------------------------------------------------------------

S3TailsAnimation_GatePushAnimationStepBySignedByteTimer:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   S3TailsAnimation_ReturnAfterAnimationHoldOrStoredFrame
                move.w  ground_vel(a0),d2
                bmi.s   S3TailsAnimation_ClampWrappedPushDelayAfterAddingEightHundred
                neg.w   d2

S3TailsAnimation_ClampWrappedPushDelayAfterAddingEightHundred:
                addi.w  #$800,d2
                bpl.s   S3TailsAnimation_ReloadPushDelayAndInterpretPushSequence
                moveq   #0,d2

S3TailsAnimation_ReloadPushDelayAndInterpretPushSequence:
                lsr.w   #6,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniTails04).l,a1
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   TailsS3StepNormalAnimationFrameBytecode
; ---------------------------------------------------------------------------

S3TailsAnimation_DeriveDirectionalTailFrameAngleFromParentVelocity:
                move.w  x_vel(a2),d1
                move.w  y_vel(a2),d2
                jsr     (GetArcTan).l
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3TailsAnimation_RotateDirectionalTailAngleForFacingSet
                not.b   d0
                bra.s   S3TailsAnimation_ChooseDirectionalTailRenderFlipQuadrant
; ---------------------------------------------------------------------------

S3TailsAnimation_RotateDirectionalTailAngleForFacingSet:
                addi.b  #$80,d0

S3TailsAnimation_ChooseDirectionalTailRenderFlipQuadrant:
                addi.b  #$10,d0
                bpl.s   S3TailsAnimation_CommitDirectionalTailFlipsAndPrepareAngularFrameGroup
                moveq   #3,d1

S3TailsAnimation_CommitDirectionalTailFlipsAndPrepareAngularFrameGroup:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                lsr.b   #3,d0
                andi.b  #$C,d0
                move.b  d0,d3
                lea     (AniTails_Tail03).l,a1
                move.b  #3,anim_frame_timer(a0)
                bsr.w   TailsS3StepNormalAnimationFrameBytecode
                add.b   d3,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
AniTails:
                include "src/objects/shared/tails/animations/s3.s"
; ---------------------------------------------------------------------------

Tails_Tail_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   (Player_prev_frame_P2_tail).w,d0
                beq.s   S3TailsAnimation_ReturnAfterUnchangedFrameEmptyCueOrQueuedPatternList
                move.b  d0,(Player_prev_frame_P2_tail).w
                lea     (PLC_Tails_Tail).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   S3TailsAnimation_ReturnAfterUnchangedFrameEmptyCueOrQueuedPatternList
                move.w  #tiles_to_bytes(ArtTile_Player_2_Tail),d4
                move.l  #ArtUnc_Tails_Tail,d6
                bra.s   S3TailsAnimation_QueuePackedBodyOrTailPatternTransfersAndAdvanceVram

; =============== S U B R O U T I N E =======================================

Tails_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0

Tails_Load_PLC2:
                cmp.b   (Player_prev_frame_P2).w,d0
                beq.s   S3TailsAnimation_ReturnAfterUnchangedFrameEmptyCueOrQueuedPatternList
                move.b  d0,(Player_prev_frame_P2).w
                lea     (PLC_Tails).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   S3TailsAnimation_ReturnAfterUnchangedFrameEmptyCueOrQueuedPatternList
                move.w  #tiles_to_bytes(ArtTile_Player_2),d4
                move.l  #ArtUnc_Tails,d6

S3TailsAnimation_QueuePackedBodyOrTailPatternTransfersAndAdvanceVram:
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
                dbf     d5,S3TailsAnimation_QueuePackedBodyOrTailPatternTransfersAndAdvanceVram

S3TailsAnimation_ReturnAfterUnchangedFrameEmptyCueOrQueuedPatternList:
                rts
; End of function Tails_Load_PLC

; =============== S U B R O U T I N E =======================================
