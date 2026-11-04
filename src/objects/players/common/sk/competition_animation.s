; Owner: objects/players/common/sk
; Responsibility: Shared Sonic and Knuckles competition animation and compact dynamic pattern loading
; Source provenance and ranges: config/reconstruction/source_layout.json
Animate_SonicKnuckles_2P:
                lea     (AniSonic2P).l,a1
                tst.b   character_id(a0)
                beq.s   SKPlayerCompetitionAnimation_RestartChangedCompetitionAnimationAndClearPush
                lea     (AniKnuckles2P).l,a1

SKPlayerCompetitionAnimation_RestartChangedCompetitionAnimationAndClearPush:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   SKPlayerCompetitionAnimation_DispatchCompetitionSequenceHeaderAndTimedFrames
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

SKPlayerCompetitionAnimation_DispatchCompetitionSequenceHeaderAndTimedFrames:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   SKPlayerCompetitionAnimation_DispatchFFHeaderToMovementOrTumble
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKPlayerCompetitionAnimation_ReturnAfterTimedFrameHoldOrGenericFrameStore
                move.b  d0,anim_frame_timer(a0)

SKPlayerCompetitionAnimation_ReadCompetitionFrameOrGenericSequenceCommand:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$FC,d0
                bhs.s   SKPlayerCompetitionAnimation_LoopCompetitionSequenceOnFFCommand

SKPlayerCompetitionAnimation_StoreCompetitionMappingFrameAndAdvanceSequence:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

SKPlayerCompetitionAnimation_ReturnAfterTimedFrameHoldOrGenericFrameStore:
                rts
; ---------------------------------------------------------------------------

SKPlayerCompetitionAnimation_LoopCompetitionSequenceOnFFCommand:
                addq.b  #1,d0
                bne.s   SKPlayerCompetitionAnimation_RewindCompetitionSequenceOnFECommand
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   SKPlayerCompetitionAnimation_StoreCompetitionMappingFrameAndAdvanceSequence
; ---------------------------------------------------------------------------

SKPlayerCompetitionAnimation_RewindCompetitionSequenceOnFECommand:
                addq.b  #1,d0
                bne.s   SKPlayerCompetitionAnimation_ChangeCompetitionAnimationOnFDCommand
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   SKPlayerCompetitionAnimation_StoreCompetitionMappingFrameAndAdvanceSequence
; ---------------------------------------------------------------------------

SKPlayerCompetitionAnimation_ChangeCompetitionAnimationOnFDCommand:
                addq.b  #1,d0
                bne.s   SKPlayerCompetitionAnimation_ReturnAfterAnimationChangeOrUnhandledFCCommand
                move.b  2(a1,d1.w),anim(a0)

SKPlayerCompetitionAnimation_ReturnAfterAnimationChangeOrUnhandledFCCommand:
                rts
; ---------------------------------------------------------------------------

SKPlayerCompetitionAnimation_DispatchFFHeaderToMovementOrTumble:
                addq.b  #1,d0
                bne.w   SKPlayerCompetitionAnimation_HandleOtherNegativeHeadersAsTimedRollingFrames
                moveq   #0,d0
                move.b  flip_angle(a0),d0
                bne.w   SKPlayerCompetitionAnimation_ChooseCompactTumbleOrientationByFacing
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   SKPlayerCompetitionAnimation_ReflectMovementAngleWhenFacingRight
                beq.s   SKPlayerCompetitionAnimation_ReflectMovementAngleWhenFacingRight
                subq.b  #1,d0

SKPlayerCompetitionAnimation_ReflectMovementAngleWhenFacingRight:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKPlayerCompetitionAnimation_SelectMovementRenderInversionFromWrappedAngle
                not.b   d0

SKPlayerCompetitionAnimation_SelectMovementRenderInversionFromWrappedAngle:
                addi.b  #$10,d0
                bpl.s   SKPlayerCompetitionAnimation_ApplyMovementFlipAndGatePushingBeforeSpeedFrames
                moveq   #3,d1

SKPlayerCompetitionAnimation_ApplyMovementFlipAndGatePushingBeforeSpeedFrames:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   SKPlayerCompetitionAnimation_AdvancePushingOnlyWhenAnimationTimerExpires
                lsr.b   #5,d0
                andi.b  #3,d0
                move.w  ground_vel(a0),d2
                bpl.s   SKPlayerCompetitionAnimation_DoubleMovementAnimationSpeedForSecondarySignBit
                neg.w   d2

SKPlayerCompetitionAnimation_DoubleMovementAnimationSpeedForSecondarySignBit:
                tst.b   status_secondary(a0)
                bpl.w   SKPlayerCompetitionAnimation_ChooseCompactWalkOrRunSequenceAndOrientationStride
                add.w   d2,d2

SKPlayerCompetitionAnimation_ChooseCompactWalkOrRunSequenceAndOrientationStride:
                move.b  d0,d3
                lea     (AniSonic2P01).l,a1
                cmpi.w  #$600,d2
                bhs.s   SKPlayerCompetitionAnimation_ReadMovementFrameWithCompactOrientationOffset
                lea     (AniSonic2P00).l,a1
                add.b   d0,d0

SKPlayerCompetitionAnimation_ReadMovementFrameWithCompactOrientationOffset:
                add.b   d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   SKPlayerCompetitionAnimation_WriteMovementFrameBeforeCheckingAdvanceTimer
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

SKPlayerCompetitionAnimation_WriteMovementFrameBeforeCheckingAdvanceTimer:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKPlayerCompetitionAnimation_ReturnAfterMovementFrameWriteAndOptionalAdvance
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   SKPlayerCompetitionAnimation_ReloadMovementDurationAndAdvanceFrameIndex
                moveq   #0,d2

SKPlayerCompetitionAnimation_ReloadMovementDurationAndAdvanceFrameIndex:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

SKPlayerCompetitionAnimation_ReturnAfterMovementFrameWriteAndOptionalAdvance:
                rts
; ---------------------------------------------------------------------------

SKPlayerCompetitionAnimation_ChooseCompactTumbleOrientationByFacing:
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKPlayerCompetitionAnimation_ChooseLeftFacingTumbleFlipType
                andi.b  #$FC,render_flags(a0)
                addi.b  #$16,d0
                divu.w  #$2C,d0
                addi.b  #$15,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKPlayerCompetitionAnimation_ChooseLeftFacingTumbleFlipType:
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   SKPlayerCompetitionAnimation_ReverseLeftFacingTumbleAngleAndFlipBothAxes
                ori.b   #1,render_flags(a0)
                addi.b  #$16,d0
                bra.s   SKPlayerCompetitionAnimation_QuantizeLeftTumbleAngleIntoCompactFrame
; ---------------------------------------------------------------------------

SKPlayerCompetitionAnimation_ReverseLeftFacingTumbleAngleAndFlipBothAxes:
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$9A,d0

SKPlayerCompetitionAnimation_QuantizeLeftTumbleAngleIntoCompactFrame:
                divu.w  #$2C,d0
                addi.b  #$15,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKPlayerCompetitionAnimation_HandleOtherNegativeHeadersAsTimedRollingFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKPlayerCompetitionAnimation_ReturnAfterTimedFrameHoldOrGenericFrameStore
                move.w  ground_vel(a0),d2
                bpl.s   SKPlayerCompetitionAnimation_SelectRollingSequenceFromUnsignedSpeedMagnitude
                neg.w   d2

SKPlayerCompetitionAnimation_SelectRollingSequenceFromUnsignedSpeedMagnitude:
                lea     (AniSonic2P03).l,a1
                cmpi.w  #$600,d2
                bhs.s   SKPlayerCompetitionAnimation_ComputeWrappedRollingFrameDuration
                lea     (AniSonic2P02).l,a1

SKPlayerCompetitionAnimation_ComputeWrappedRollingFrameDuration:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   SKPlayerCompetitionAnimation_ReloadRollingTimerAndFacingBeforeGenericFrameRead
                moveq   #0,d2

SKPlayerCompetitionAnimation_ReloadRollingTimerAndFacingBeforeGenericFrameRead:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   SKPlayerCompetitionAnimation_ReadCompetitionFrameOrGenericSequenceCommand
; ---------------------------------------------------------------------------

SKPlayerCompetitionAnimation_AdvancePushingOnlyWhenAnimationTimerExpires:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKPlayerCompetitionAnimation_ReturnAfterTimedFrameHoldOrGenericFrameStore
                move.w  ground_vel(a0),d2
                bmi.s   SKPlayerCompetitionAnimation_ComputeWrappedPushingDurationNumerator
                neg.w   d2

SKPlayerCompetitionAnimation_ComputeWrappedPushingDurationNumerator:
                addi.w  #$800,d2
                bpl.s   SKPlayerCompetitionAnimation_SelectCharacterPushingSequenceAndTimerScale
                moveq   #0,d2

SKPlayerCompetitionAnimation_SelectCharacterPushingSequenceAndTimerScale:
                lsr.w   #6,d2
                lea     (AniSonic2P04).l,a1
                tst.b   character_id(a0)
                beq.s   SKPlayerCompetitionAnimation_StorePushingTimerAndFacingBeforeGenericFrameRead
                lea     (AniKnuckles2P04).l,a1
                lsr.w   #2,d2

SKPlayerCompetitionAnimation_StorePushingTimerAndFacingBeforeGenericFrameRead:
                move.b  d2,anim_frame_timer(a0)
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   SKPlayerCompetitionAnimation_ReadCompetitionFrameOrGenericSequenceCommand
; End of function Animate_SonicKnuckles_2P

; ---------------------------------------------------------------------------
AniSonic2P:
                include "src/objects/shared/sonic/animations/knuckles_2p.s"

; =============== S U B R O U T I N E =======================================

SonicKnuckles2P_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                lea     (PLC_Sonic2P).l,a2
                move.l  #ArtUnc_Sonic2P,d6
                tst.b   character_id(a0)
                beq.s   SKPlayerCompetitionAnimation_ResolveCompetitionFramePatternListAndPlayerDestination
                lea     (PLC_Knuckles2P).l,a2
                move.l  #ArtUnc_Knuckles2P,d6

SKPlayerCompetitionAnimation_ResolveCompetitionFramePatternListAndPlayerDestination:
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   SKPlayerCompetitionAnimation_ReturnAfterEmptyOrQueuedCompetitionPatternList
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4
                cmpa.w  #Player_1,a0
                beq.s   SKPlayerCompetitionAnimation_QueueCompactPatternRunAndAdvanceVramDestination
                move.w  #tiles_to_bytes(ArtTile_Player_2),d4

SKPlayerCompetitionAnimation_QueueCompactPatternRunAndAdvanceVramDestination:
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
                dbf     d5,SKPlayerCompetitionAnimation_QueueCompactPatternRunAndAdvanceVramDestination

SKPlayerCompetitionAnimation_ReturnAfterEmptyOrQueuedCompetitionPatternList:
                rts
; End of function SonicKnuckles2P_Load_PLC

; ---------------------------------------------------------------------------
