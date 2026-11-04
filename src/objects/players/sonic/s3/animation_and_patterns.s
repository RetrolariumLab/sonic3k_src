; Owner: objects/players/sonic/s3
; Responsibility: Sonic animation selection, dynamic pattern loading and the common player DPLC dispatch interface
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Sonic:
                lea     (AniSonic).l,a1
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   S3SonicAnimation_ResetAnimationCursorTimerAndPushFlagWhenIdChanges
                lea     (AniSuperSonic).l,a1

S3SonicAnimation_ResetAnimationCursorTimerAndPushFlagWhenIdChanges:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   S3SonicAnimation_ReadAnimationHeaderAndRunOrdinaryDelayOrSpeedMode
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

S3SonicAnimation_ReadAnimationHeaderAndRunOrdinaryDelayOrSpeedMode:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   S3SonicAnimation_SelectWalkTumbleForFfHeaderOrOtherNegativeSpeedMode
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3SonicAnimation_ReturnAfterFrameWriteOrNonnegativeTimerStep
                move.b  d0,anim_frame_timer(a0)

S3SonicAnimation_ReadNextFrameOrPlayerSpecificAnimationCommand:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$FC,d0
                bhs.s   S3SonicAnimation_RestartPlayerStreamOnFfOrTestRemainingCommands

S3SonicAnimation_StoreMappingFrameAndAdvanceByteCursor:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

S3SonicAnimation_ReturnAfterFrameWriteOrNonnegativeTimerStep:
                rts
; ---------------------------------------------------------------------------

S3SonicAnimation_RestartPlayerStreamOnFfOrTestRemainingCommands:
                addq.b  #1,d0
                bne.s   S3SonicAnimation_BacktrackPlayerStreamOnFeByFollowingByte
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   S3SonicAnimation_StoreMappingFrameAndAdvanceByteCursor
; ---------------------------------------------------------------------------

S3SonicAnimation_BacktrackPlayerStreamOnFeByFollowingByte:
                addq.b  #1,d0
                bne.s   S3SonicAnimation_ChangePlayerAnimationOnFdOtherwiseLeaveFcUnhandled
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   S3SonicAnimation_StoreMappingFrameAndAdvanceByteCursor
; ---------------------------------------------------------------------------

S3SonicAnimation_ChangePlayerAnimationOnFdOtherwiseLeaveFcUnhandled:
                addq.b  #1,d0
                bne.s   S3SonicAnimation_ReturnAfterFdBankRequestOrUnhandledFc
                move.b  2(a1,d1.w),anim(a0)

S3SonicAnimation_ReturnAfterFdBankRequestOrUnhandledFc:
                rts
; ---------------------------------------------------------------------------

S3SonicAnimation_SelectWalkTumbleForFfHeaderOrOtherNegativeSpeedMode:
                addq.b  #1,d0
                bne.w   S3SonicAnimation_CountNonFfNegativeHeaderRollCadence
                moveq   #0,d0
                tst.b   flip_type(a0)
                bmi.w   Anim_Tumble
                move.b  flip_angle(a0),d0
                bne.w   Anim_Tumble
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   S3SonicAnimation_OrientWalkingAngleByFacing
                beq.s   S3SonicAnimation_OrientWalkingAngleByFacing
                subq.b  #1,d0

S3SonicAnimation_OrientWalkingAngleByFacing:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3SonicAnimation_BiasWalkingAngleAndChooseQuadrantFlipMask
                not.b   d0

S3SonicAnimation_BiasWalkingAngleAndChooseQuadrantFlipMask:
                addi.b  #$10,d0
                bpl.s   S3SonicAnimation_ApplyWalkQuadrantFlipAndChoosePushOrSpeedSampling
                moveq   #3,d1

S3SonicAnimation_ApplyWalkQuadrantFlipAndChoosePushOrSpeedSampling:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   S3SonicAnimation_CountPushCadenceUsingRawGroundVelocity
                lsr.b   #4,d0
                andi.b  #6,d0
                move.w  ground_vel(a0),d2
                bpl.s   S3SonicAnimation_DoubleAnimationSpeedMagnitudeForSecondarySignBit
                neg.w   d2

S3SonicAnimation_DoubleAnimationSpeedMagnitudeForSecondarySignBit:
                tst.b   status_secondary(a0)
                bpl.w   S3SonicAnimation_ChooseNormalWalkOrRunStreamAtSixPixelsPerTick
                add.w   d2,d2

S3SonicAnimation_ChooseNormalWalkOrRunStreamAtSixPixelsPerTick:
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   S3SonicAnimation_ChooseSuperWalkOrRunAtEightPixelsPerTick
                lea     (AniSonic01).l,a1
                cmpi.w  #$600,d2
                bhs.s   S3SonicAnimation_ReadNormalLocomotionFrameAndSectorOffset
                lea     (AniSonic00).l,a1
                add.b   d0,d0

S3SonicAnimation_ReadNormalLocomotionFrameAndSectorOffset:
                add.b   d0,d0
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   S3SonicAnimation_StoreNormalSectorFrameAndCountCursorDelay
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

S3SonicAnimation_StoreNormalSectorFrameAndCountCursorDelay:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3SonicAnimation_ReturnAfterNormalWalkFrameOrCursorTiming
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   S3SonicAnimation_ReloadNormalWalkTimerFromClampedWordRemainder
                moveq   #0,d2

S3SonicAnimation_ReloadNormalWalkTimerFromClampedWordRemainder:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

S3SonicAnimation_ReturnAfterNormalWalkFrameOrCursorTiming:
                rts
; ---------------------------------------------------------------------------

S3SonicAnimation_ChooseSuperWalkOrRunAtEightPixelsPerTick:
                lea     (AniSuperSonic01).l,a1
                cmpi.w  #$800,d2
                bhs.s   S3SonicAnimation_DoubleSectorOffsetForSuperRunFrames
                lea     (AniSuperSonic00).l,a1
                add.b   d0,d0
                add.b   d0,d0
                bra.s   S3SonicAnimation_ReadSuperLocomotionFrameAndHandleFfWrap
; ---------------------------------------------------------------------------

S3SonicAnimation_DoubleSectorOffsetForSuperRunFrames:
                add.b   d0,d0

S3SonicAnimation_ReadSuperLocomotionFrameAndHandleFfWrap:
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   S3SonicAnimation_StoreSuperSectorFrameAndCountCursorDelay
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

S3SonicAnimation_StoreSuperSectorFrameAndCountCursorDelay:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3SonicAnimation_ReturnAfterSuperLocomotionFrameTiming
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   S3SonicAnimation_ReloadSuperWalkTimerFromClampedWordRemainder
                moveq   #0,d2

S3SonicAnimation_ReloadSuperWalkTimerFromClampedWordRemainder:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

S3SonicAnimation_ReturnAfterSuperLocomotionFrameTiming:
                rts
; ---------------------------------------------------------------------------

; loc_1360C:
Anim_Tumble:
                move.b  flip_type(a0),d1
                andi.w  #$7F,d1
                bne.s   S3SonicAnimation_ReadSubtypeTumbleBaseAndHandleTypeOne
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   Anim_TumbleLeft
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   S3SonicAnimation_BiasRightFacingTypeZeroTumblePhaseByEleven
                ori.b   #2,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                bra.s   S3SonicAnimation_QuantizeRightTypeZeroTumbleIntoBaseThirtyOneFrames
; ---------------------------------------------------------------------------

S3SonicAnimation_BiasRightFacingTypeZeroTumblePhaseByEleven:
                addi.b  #$B,d0

S3SonicAnimation_QuantizeRightTypeZeroTumbleIntoBaseThirtyOneFrames:
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

; loc_13658:
Anim_TumbleLeft:
                andi.b  #$FC,render_flags(a0)
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------
S3SonicAnimation_TumbleSubtypeFrameBaseBytes:
                dc.b    0, $3D, $49, $49
                even
; ---------------------------------------------------------------------------

S3SonicAnimation_ReadSubtypeTumbleBaseAndHandleTypeOne:
                move.b  S3SonicAnimation_TumbleSubtypeFrameBaseBytes(pc,d1.w),d3
                cmpi.b  #1,d1
                bne.s   S3SonicAnimation_HandleTypeTwoTumbleOrContinueOtherSubtypeDispatch
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3SonicAnimation_QuantizeLeftFacingTypeOneTumbleWithXFlip
                andi.b  #$FC,render_flags(a0)
                addi.b  #-8,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3SonicAnimation_QuantizeLeftFacingTypeOneTumbleWithXFlip:
                andi.b  #$FC,render_flags(a0)
                ori.b   #1,render_flags(a0)
                addi.b  #-8,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3SonicAnimation_HandleTypeTwoTumbleOrContinueOtherSubtypeDispatch:
                cmpi.b  #2,d1
                bne.s   S3SonicAnimation_HandleMirroredSubtypeThreeTumbleWithProfileFallback
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3SonicAnimation_QuantizeLeftFacingTypeTwoTumbleWithBothFlips
                andi.b  #$FC,render_flags(a0)
                addi.b  #$B,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3SonicAnimation_QuantizeLeftFacingTypeTwoTumbleWithBothFlips:
                andi.b  #$FC,render_flags(a0)
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3SonicAnimation_HandleMirroredSubtypeThreeTumbleWithProfileFallback:
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3SonicAnimation_QuantizeLeftFacingSubtypeThreeWithXFlip
                andi.b  #$FC,render_flags(a0)
                ori.b   #2,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3SonicAnimation_QuantizeLeftFacingSubtypeThreeWithXFlip:
                andi.b  #$FC,render_flags(a0)
                ori.b   #1,render_flags(a0)
                addi.b  #$B,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3SonicAnimation_CountNonFfNegativeHeaderRollCadence:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   S3SonicAnimation_ReturnAfterFrameWriteOrNonnegativeTimerStep
                move.w  ground_vel(a0),d2
                bpl.s   S3SonicAnimation_ChooseRollStreamAtSixPixelsPerTick
                neg.w   d2

S3SonicAnimation_ChooseRollStreamAtSixPixelsPerTick:
                lea     (AniSonic03).l,a1
                cmpi.w  #$600,d2
                bhs.s   S3SonicAnimation_ComputeRollDelayFromFourMinusSpeed
                lea     (AniSonic02).l,a1

S3SonicAnimation_ComputeRollDelayFromFourMinusSpeed:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   S3SonicAnimation_ReloadRollTimerAndReadNextFrameWithProfileFlipPolicy
                moveq   #0,d2

S3SonicAnimation_ReloadRollTimerAndReadNextFrameWithProfileFlipPolicy:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   S3SonicAnimation_ReadNextFrameOrPlayerSpecificAnimationCommand
; ---------------------------------------------------------------------------

S3SonicAnimation_CountPushCadenceUsingRawGroundVelocity:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   S3SonicAnimation_ReturnAfterFrameWriteOrNonnegativeTimerStep
                move.w  ground_vel(a0),d2
                bmi.s   S3SonicAnimation_ClampPushWordRemainderBeforeTimerScaling
                neg.w   d2

S3SonicAnimation_ClampPushWordRemainderBeforeTimerScaling:
                addi.w  #$800,d2
                bpl.s   S3SonicAnimation_ReloadPushTimerAndSelectNormalOrSuperStream
                moveq   #0,d2

S3SonicAnimation_ReloadPushTimerAndSelectNormalOrSuperStream:
                lsr.w   #6,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniSonic04).l,a1
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   S3SonicAnimation_ReadPushFrameWithProfileSpecificRenderFlipTail
                lea     (AniSuperSonic04).l,a1

S3SonicAnimation_ReadPushFrameWithProfileSpecificRenderFlipTail:
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   S3SonicAnimation_ReadNextFrameOrPlayerSpecificAnimationCommand
; End of function Animate_Sonic

; ---------------------------------------------------------------------------
AniSonic:
                include "src/objects/shared/sonic/animations/s3.s"

; =============== S U B R O U T I N E =======================================

Sonic_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0

Sonic_Load_PLC2:
                cmp.b   (Player_prev_frame).w,d0
                beq.s   S3SonicAnimation_ReturnFromSonicFrameCacheHitEmptyDplcOrTransferLoop
                move.b  d0,(Player_prev_frame).w
                lea     (PLC_Sonic).l,a2
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   S3SonicAnimation_ReadSelectedSonicDplcHeaderAndChooseSourceBank
                lea     (PLC_SuperSonic).l,a2

S3SonicAnimation_ReadSelectedSonicDplcHeaderAndChooseSourceBank:
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   S3SonicAnimation_ReturnFromSonicFrameCacheHitEmptyDplcOrTransferLoop
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4

S3SonicAnimation_QueueSonicPackedDplcEntryAndAdvanceVramDestination:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                addi.l  #ArtUnc_Sonic,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,S3SonicAnimation_QueueSonicPackedDplcEntryAndAdvanceVramDestination

S3SonicAnimation_ReturnFromSonicFrameCacheHitEmptyDplcOrTransferLoop:
                rts
; End of function Sonic_Load_PLC

; =============== S U B R O U T I N E =======================================

Perform_Player_DPLC:
                tst.b   character_id(a1)
                beq.s   Sonic_Load_PLC2
                bra.w   Tails_Load_PLC2
; End of function Perform_Player_DPLC

; =============== S U B R O U T I N E =======================================
