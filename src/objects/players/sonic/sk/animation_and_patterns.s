; Owner: objects/players/sonic/sk
; Responsibility: Sonic animation selection, dynamic pattern loading and the common player DPLC dispatch interface
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Sonic:
                lea     (AniSonic).l,a1
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKSonicAnimation_ResetAnimationCursorTimerAndPushFlagWhenIdChanges
                lea     (AniSuperSonic).l,a1

SKSonicAnimation_ResetAnimationCursorTimerAndPushFlagWhenIdChanges:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   SKSonicAnimation_ReadAnimationHeaderAndRunOrdinaryDelayOrSpeedMode
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

SKSonicAnimation_ReadAnimationHeaderAndRunOrdinaryDelayOrSpeedMode:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   SKSonicAnimation_SelectWalkTumbleForFfHeaderOrOtherNegativeSpeedMode
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKSonicAnimation_ReturnAfterFrameWriteOrNonnegativeTimerStep
                move.b  d0,anim_frame_timer(a0)

SKSonicAnimation_ReadNextFrameOrPlayerSpecificAnimationCommand:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$FC,d0
                bhs.s   SKSonicAnimation_RestartPlayerStreamOnFfOrTestRemainingCommands

SKSonicAnimation_StoreMappingFrameAndAdvanceByteCursor:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

SKSonicAnimation_ReturnAfterFrameWriteOrNonnegativeTimerStep:
                rts
; ---------------------------------------------------------------------------

SKSonicAnimation_RestartPlayerStreamOnFfOrTestRemainingCommands:
                addq.b  #1,d0
                bne.s   SKSonicAnimation_BacktrackPlayerStreamOnFeByFollowingByte
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   SKSonicAnimation_StoreMappingFrameAndAdvanceByteCursor
; ---------------------------------------------------------------------------

SKSonicAnimation_BacktrackPlayerStreamOnFeByFollowingByte:
                addq.b  #1,d0
                bne.s   SKSonicAnimation_ChangePlayerAnimationOnFdOtherwiseLeaveFcUnhandled
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   SKSonicAnimation_StoreMappingFrameAndAdvanceByteCursor
; ---------------------------------------------------------------------------

SKSonicAnimation_ChangePlayerAnimationOnFdOtherwiseLeaveFcUnhandled:
                addq.b  #1,d0
                bne.s   SKSonicAnimation_ReturnAfterFdBankRequestOrUnhandledFc
                move.b  2(a1,d1.w),anim(a0)

SKSonicAnimation_ReturnAfterFdBankRequestOrUnhandledFc:
                rts
; ---------------------------------------------------------------------------

SKSonicAnimation_SelectWalkTumbleForFfHeaderOrOtherNegativeSpeedMode:
                addq.b  #1,d0
                bne.w   SKSonicAnimation_CountNonFfNegativeHeaderRollCadence
                moveq   #0,d0
                tst.b   flip_type(a0)
                bmi.w   Anim_Tumble
                move.b  flip_angle(a0),d0
                bne.w   Anim_Tumble
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   SKSonicAnimation_OrientWalkingAngleByFacing
                beq.s   SKSonicAnimation_OrientWalkingAngleByFacing
                subq.b  #1,d0

SKSonicAnimation_OrientWalkingAngleByFacing:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKSonicAnimation_BiasWalkingAngleAndChooseQuadrantFlipMask
                not.b   d0

SKSonicAnimation_BiasWalkingAngleAndChooseQuadrantFlipMask:
                addi.b  #$10,d0
                bpl.s   SKSonicAnimation_ApplyWalkQuadrantFlipAndChoosePushOrSpeedSampling
                moveq   #3,d1

SKSonicAnimation_ApplyWalkQuadrantFlipAndChoosePushOrSpeedSampling:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   SKSonicAnimation_CountPushCadenceUsingRawGroundVelocity
                lsr.b   #4,d0
                andi.b  #6,d0
                move.w  ground_vel(a0),d2
                bpl.s   SKSonicAnimation_DoubleAnimationSpeedMagnitudeForSecondarySignBit
                neg.w   d2

SKSonicAnimation_DoubleAnimationSpeedMagnitudeForSecondarySignBit:
                tst.b   status_secondary(a0)
                bpl.w   SKSonicAnimation_ChooseNormalWalkOrRunStreamAtSixPixelsPerTick
                add.w   d2,d2

SKSonicAnimation_ChooseNormalWalkOrRunStreamAtSixPixelsPerTick:
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   SKSonicAnimation_ChooseSuperWalkOrRunAtEightPixelsPerTick
                lea     (AniSonic01).l,a1
                cmpi.w  #$600,d2
                bhs.s   SKSonicAnimation_ReadNormalLocomotionFrameAndSectorOffset
                lea     (AniSonic00).l,a1
                add.b   d0,d0

SKSonicAnimation_ReadNormalLocomotionFrameAndSectorOffset:
                add.b   d0,d0
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   SKSonicAnimation_StoreNormalSectorFrameAndCountCursorDelay
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

SKSonicAnimation_StoreNormalSectorFrameAndCountCursorDelay:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKSonicAnimation_ReturnAfterNormalWalkFrameOrCursorTiming
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   SKSonicAnimation_ReloadNormalWalkTimerFromClampedWordRemainder
                moveq   #0,d2

SKSonicAnimation_ReloadNormalWalkTimerFromClampedWordRemainder:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

SKSonicAnimation_ReturnAfterNormalWalkFrameOrCursorTiming:
                rts
; ---------------------------------------------------------------------------

SKSonicAnimation_ChooseSuperWalkOrRunAtEightPixelsPerTick:
                lea     (AniSuperSonic01).l,a1
                cmpi.w  #$800,d2
                bhs.s   SKSonicAnimation_DoubleSectorOffsetForSuperRunFrames
                lea     (AniSuperSonic00).l,a1
                add.b   d0,d0
                add.b   d0,d0
                bra.s   SKSonicAnimation_ReadSuperLocomotionFrameAndHandleFfWrap
; ---------------------------------------------------------------------------

SKSonicAnimation_DoubleSectorOffsetForSuperRunFrames:
                add.b   d0,d0

SKSonicAnimation_ReadSuperLocomotionFrameAndHandleFfWrap:
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   SKSonicAnimation_StoreSuperSectorFrameAndCountCursorDelay
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

SKSonicAnimation_StoreSuperSectorFrameAndCountCursorDelay:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKSonicAnimation_ReturnAfterSuperLocomotionFrameTiming
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   SKSonicAnimation_ReloadSuperWalkTimerFromClampedWordRemainder
                moveq   #0,d2

SKSonicAnimation_ReloadSuperWalkTimerFromClampedWordRemainder:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

SKSonicAnimation_ReturnAfterSuperLocomotionFrameTiming:
                rts
; ---------------------------------------------------------------------------

; loc_127C0:
Anim_Tumble:
                move.b  flip_type(a0),d1
                andi.w  #$7F,d1
                bne.w   SKSonicAnimation_ReadSubtypeTumbleBaseAndHandleTypeOne
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   Anim_TumbleLeft
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   SKSonicAnimation_BiasRightFacingTypeZeroTumblePhaseByEleven
                cmpi.b  #$B,(Current_zone).w            ; is this DEZ?
                beq.s   SKSonicAnimation_QuantizeRightTypeZeroTumbleIntoBaseThirtyOneFrames  ; if so, branch
                cmpi.b  #4,(Current_zone).w             ; is this FBZ?
                beq.s   SKSonicAnimation_QuantizeRightTypeZeroTumbleIntoBaseThirtyOneFrames  ; if so, branch
                ori.b   #2,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                bra.s   SKSonicAnimation_QuantizeRightTypeZeroTumbleIntoBaseThirtyOneFrames
; ---------------------------------------------------------------------------

SKSonicAnimation_BiasRightFacingTypeZeroTumblePhaseByEleven:
                addi.b  #$B,d0

SKSonicAnimation_QuantizeRightTypeZeroTumbleIntoBaseThirtyOneFrames:
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

; loc_1281E:
Anim_TumbleLeft:
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   SKSonicAnimation_MirrorOrdinaryLeftTypeZeroTumbleAcrossBothAxes
                cmpi.b  #4,(Current_zone).w             ; is this FBZ?
                beq.s   SKSonicAnimation_BiasNegativeTypeZeroLeftTumbleInFbzDezOrMhz  ; if so, branch
                cmpi.b  #$B,(Current_zone).w            ; is this DEZ?
                beq.s   SKSonicAnimation_BiasNegativeTypeZeroLeftTumbleInFbzDezOrMhz  ; if so, branch
                cmpi.b  #7,(Current_zone).w             ; is this MHZ?
                bne.s   SKSonicAnimation_MirrorOrdinaryLeftTypeZeroTumbleAcrossBothAxes  ; if not, branch

SKSonicAnimation_BiasNegativeTypeZeroLeftTumbleInFbzDezOrMhz:
                ori.b   #1,render_flags(a0)
                addi.b  #$B,d0
                bra.s   SKSonicAnimation_QuantizeLeftTypeZeroTumbleIntoBaseThirtyOneFrames
; ---------------------------------------------------------------------------

SKSonicAnimation_MirrorOrdinaryLeftTypeZeroTumbleAcrossBothAxes:
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0

SKSonicAnimation_QuantizeLeftTypeZeroTumbleIntoBaseThirtyOneFrames:
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------
SKSonicAnimation_TumbleSubtypeFrameBaseBytes:
                dc.b    0, $3D, $49, $49
                even
; ---------------------------------------------------------------------------

SKSonicAnimation_ReadSubtypeTumbleBaseAndHandleTypeOne:
                move.b  SKSonicAnimation_TumbleSubtypeFrameBaseBytes(pc,d1.w),d3
                cmpi.b  #1,d1
                bne.s   SKSonicAnimation_HandleTypeTwoTumbleOrContinueOtherSubtypeDispatch
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKSonicAnimation_QuantizeLeftFacingTypeOneTumbleWithXFlip
                andi.b  #$FC,render_flags(a0)
                addi.b  #-8,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicAnimation_QuantizeLeftFacingTypeOneTumbleWithXFlip:
                andi.b  #$FC,render_flags(a0)
                ori.b   #1,render_flags(a0)
                addi.b  #-8,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicAnimation_HandleTypeTwoTumbleOrContinueOtherSubtypeDispatch:
                cmpi.b  #2,d1
                bne.s   SKSonicAnimation_HandleMirroredSubtypeThreeTumbleWithProfileFallback
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKSonicAnimation_QuantizeLeftFacingTypeTwoTumbleWithBothFlips
                andi.b  #$FC,render_flags(a0)
                addi.b  #$B,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicAnimation_QuantizeLeftFacingTypeTwoTumbleWithBothFlips:
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

SKSonicAnimation_HandleMirroredSubtypeThreeTumbleWithProfileFallback:
                cmpi.b  #3,d1
                bne.s   SKSonicAnimation_DispatchTypeFourBeforeGenericFixedBaseTumble
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKSonicAnimation_QuantizeLeftFacingSubtypeThreeWithXFlip
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

SKSonicAnimation_QuantizeLeftFacingSubtypeThreeWithXFlip:
                andi.b  #$FC,render_flags(a0)
                ori.b   #1,render_flags(a0)
                addi.b  #$B,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicAnimation_DispatchTypeFourBeforeGenericFixedBaseTumble:
                cmpi.b  #4,d1
                bne.s   SKSonicAnimation_HandleTypesFiveAndAboveWithFixedBaseAndFacingXFlip
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKSonicAnimation_SelectLeftTypeFourMirrorWithIdenticalSignPaths
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   SKSonicAnimation_BiasNonnegativeRightFacingTypeFourTumble
                addi.b  #$B,d0
                bra.s   SKSonicAnimation_QuantizeRightFacingTypeFourUsingFixedBaseThirtyOne
; ---------------------------------------------------------------------------

SKSonicAnimation_BiasNonnegativeRightFacingTypeFourTumble:
                addi.b  #$B,d0

SKSonicAnimation_QuantizeRightFacingTypeFourUsingFixedBaseThirtyOne:
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicAnimation_SelectLeftTypeFourMirrorWithIdenticalSignPaths:
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   SKSonicAnimation_MirrorNonnegativeLeftFacingTypeFourTumble
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                bra.s   SKSonicAnimation_QuantizeLeftFacingTypeFourUsingFixedBaseThirtyOne
; ---------------------------------------------------------------------------

SKSonicAnimation_MirrorNonnegativeLeftFacingTypeFourTumble:
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0

SKSonicAnimation_QuantizeLeftFacingTypeFourUsingFixedBaseThirtyOne:
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicAnimation_HandleTypesFiveAndAboveWithFixedBaseAndFacingXFlip:
                move.b  flip_angle(a0),d0
                andi.b  #$FC,render_flags(a0)
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                beq.s   SKSonicAnimation_QuantizeGenericHigherTumbleTypeUsingFixedBaseThirtyOne
                ori.b   #1,render_flags(a0)

SKSonicAnimation_QuantizeGenericHigherTumbleTypeUsingFixedBaseThirtyOne:
                addi.b  #$B,d0
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicAnimation_CountNonFfNegativeHeaderRollCadence:
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKSonicAnimation_ReturnAfterFrameWriteOrNonnegativeTimerStep
                move.w  ground_vel(a0),d2
                bpl.s   SKSonicAnimation_ChooseRollStreamAtSixPixelsPerTick
                neg.w   d2

SKSonicAnimation_ChooseRollStreamAtSixPixelsPerTick:
                lea     (AniSonic03).l,a1
                cmpi.w  #$600,d2
                bhs.s   SKSonicAnimation_ComputeRollDelayFromFourMinusSpeed
                lea     (AniSonic02).l,a1

SKSonicAnimation_ComputeRollDelayFromFourMinusSpeed:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   SKSonicAnimation_ReloadRollTimerAndReadNextFrameWithProfileFlipPolicy
                moveq   #0,d2

SKSonicAnimation_ReloadRollTimerAndReadNextFrameWithProfileFlipPolicy:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                bra.w   SKSonicAnimation_ReadNextFrameOrPlayerSpecificAnimationCommand
; ---------------------------------------------------------------------------

SKSonicAnimation_CountPushCadenceUsingRawGroundVelocity:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKSonicAnimation_ReturnAfterFrameWriteOrNonnegativeTimerStep
                move.w  ground_vel(a0),d2
                bmi.s   SKSonicAnimation_ClampPushWordRemainderBeforeTimerScaling
                neg.w   d2

SKSonicAnimation_ClampPushWordRemainderBeforeTimerScaling:
                addi.w  #$800,d2
                bpl.s   SKSonicAnimation_ReloadPushTimerAndSelectNormalOrSuperStream
                moveq   #0,d2

SKSonicAnimation_ReloadPushTimerAndSelectNormalOrSuperStream:
                lsr.w   #6,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniSonic04).l,a1
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKSonicAnimation_ReadPushFrameWithProfileSpecificRenderFlipTail
                lea     (AniSuperSonic04).l,a1

SKSonicAnimation_ReadPushFrameWithProfileSpecificRenderFlipTail:
                bra.w   SKSonicAnimation_ReadNextFrameOrPlayerSpecificAnimationCommand
; End of function Animate_Sonic

; ---------------------------------------------------------------------------
AniSonic:
                include "src/objects/shared/sonic/animations/sonic.s"

; =============== S U B R O U T I N E =======================================

Sonic_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0

Sonic_Load_PLC2:
                cmp.b   (Player_prev_frame).w,d0
                beq.s   SKSonicAnimation_ReturnFromSonicFrameCacheHitEmptyDplcOrTransferLoop
                move.b  d0,(Player_prev_frame).w
                lea     (PLC_Sonic).l,a2
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKSonicAnimation_ReadSelectedSonicDplcHeaderAndChooseSourceBank
                lea     (PLC_SuperSonic).l,a2

SKSonicAnimation_ReadSelectedSonicDplcHeaderAndChooseSourceBank:
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   SKSonicAnimation_ReturnFromSonicFrameCacheHitEmptyDplcOrTransferLoop
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4
                move.l  #ArtUnc_Sonic,d6
                cmpi.w  #2*$DA,d0
                blo.s   SKSonicAnimation_QueueSonicPackedDplcEntryAndAdvanceVramDestination
                move.l  #ArtUnc_Sonic_Extra,d6

SKSonicAnimation_QueueSonicPackedDplcEntryAndAdvanceVramDestination:
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
                dbf     d5,SKSonicAnimation_QueueSonicPackedDplcEntryAndAdvanceVramDestination

SKSonicAnimation_ReturnFromSonicFrameCacheHitEmptyDplcOrTransferLoop:
                rts
; End of function Sonic_Load_PLC

; =============== S U B R O U T I N E =======================================

Perform_Player_DPLC:
                tst.b   character_id(a1)
                beq.s   Sonic_Load_PLC2
                cmpi.b  #1,character_id(a1)
                beq.w   Tails_Load_PLC2
                bra.w   Knuckles_Load_PLC2
; End of function Perform_Player_DPLC

; =============== S U B R O U T I N E =======================================
