; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles animation selection and dynamic pattern loading
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Knuckles:
                lea     (AniKnuckles).l,a1
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   SKKnucklesAnimation_ResolveRelativeKnucklesAnimationHeaderAndOrdinaryTimer
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

SKKnucklesAnimation_ResolveRelativeKnucklesAnimationHeaderAndOrdinaryTimer:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   SKKnucklesAnimation_ChooseKnucklesWalkTumbleOrNegativeHeaderRoll
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKKnucklesAnimation_ReturnAfterKnucklesAnimationHoldOrFrameStore
                move.b  d0,anim_frame_timer(a0)

SKKnucklesAnimation_ReadKnucklesFrameBytecodeWithFcThreshold:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$FC,d0
                bhs.s   SKKnucklesAnimation_RestartKnucklesStreamForFfCommand

SKKnucklesAnimation_StoreKnucklesMappingFrameAndAdvanceByteCursor:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

SKKnucklesAnimation_ReturnAfterKnucklesAnimationHoldOrFrameStore:
                rts
; ---------------------------------------------------------------------------

SKKnucklesAnimation_RestartKnucklesStreamForFfCommand:
                addq.b  #1,d0
                bne.s   SKKnucklesAnimation_BacktrackKnucklesStreamForFeCommand
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   SKKnucklesAnimation_StoreKnucklesMappingFrameAndAdvanceByteCursor
; ---------------------------------------------------------------------------

SKKnucklesAnimation_BacktrackKnucklesStreamForFeCommand:
                addq.b  #1,d0
                bne.s   SKKnucklesAnimation_DeferKnucklesAnimationChangeForFdCommand
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   SKKnucklesAnimation_StoreKnucklesMappingFrameAndAdvanceByteCursor
; ---------------------------------------------------------------------------

SKKnucklesAnimation_DeferKnucklesAnimationChangeForFdCommand:
                addq.b  #1,d0
                bne.s   SKKnucklesAnimation_ReturnAfterKnucklesDeferredChangeOrIgnoredFc
                move.b  2(a1,d1.w),anim(a0)

SKKnucklesAnimation_ReturnAfterKnucklesDeferredChangeOrIgnoredFc:
                rts
; ---------------------------------------------------------------------------

SKKnucklesAnimation_ChooseKnucklesWalkTumbleOrNegativeHeaderRoll:
                addq.b  #1,d0
                bne.w   SKKnucklesAnimation_ApplyFacingAndGateAllOtherNegativeHeadersAsRoll
                moveq   #0,d0
                tst.b   flip_type(a0)
                bmi.w   Anim_Tumble
                move.b  flip_angle(a0),d0
                bne.w   Anim_Tumble
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   SKKnucklesAnimation_ReflectKnucklesMovementAngleForFacingClear
                beq.s   SKKnucklesAnimation_ReflectKnucklesMovementAngleForFacingClear
                subq.b  #1,d0

SKKnucklesAnimation_ReflectKnucklesMovementAngleForFacingClear:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKKnucklesAnimation_ChooseKnucklesMovementQuadrantFlipPair
                not.b   d0

SKKnucklesAnimation_ChooseKnucklesMovementQuadrantFlipPair:
                addi.b  #$10,d0
                bpl.s   SKKnucklesAnimation_CommitKnucklesMovementFlipsAndSelectPushOrSpeed
                moveq   #3,d1

SKKnucklesAnimation_CommitKnucklesMovementFlipsAndSelectPushOrSpeed:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   SKKnucklesAnimation_GateKnucklesPushFrameAndPrepareNegativeSpeed
                lsr.b   #4,d0
                andi.b  #6,d0
                move.w  ground_vel(a0),d2
                bpl.s   SKKnucklesAnimation_DoubleKnucklesAnimationSpeedForSecondarySignBit
                neg.w   d2

SKKnucklesAnimation_DoubleKnucklesAnimationSpeedForSecondarySignBit:
                tst.b   status_secondary(a0)
                bpl.w   SKKnucklesAnimation_ChooseKnucklesWalkOrRunAtUnsignedSixHundred
                add.w   d2,d2

SKKnucklesAnimation_ChooseKnucklesWalkOrRunAtUnsignedSixHundred:
                lea     (AniKnuckles01).l,a1
                cmpi.w  #$600,d2
                bhs.s   SKKnucklesAnimation_ComputeKnucklesAngularStrideAndReadCurrentMovementFrame
                lea     (AniKnuckles00).l,a1
                add.b   d0,d0

SKKnucklesAnimation_ComputeKnucklesAngularStrideAndReadCurrentMovementFrame:
                add.b   d0,d0
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   SKKnucklesAnimation_WriteKnucklesAngularFrameBeforeTimerGate
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

SKKnucklesAnimation_WriteKnucklesAngularFrameBeforeTimerGate:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKKnucklesAnimation_ReturnAfterKnucklesMovementFrameRefresh
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   SKKnucklesAnimation_ReloadKnucklesMovementDelayAndAdvanceCursor
                moveq   #0,d2

SKKnucklesAnimation_ReloadKnucklesMovementDelayAndAdvanceCursor:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

SKKnucklesAnimation_ReturnAfterKnucklesMovementFrameRefresh:
                rts
; ---------------------------------------------------------------------------

SKKnucklesAnimation_ApplyFacingAndGateAllOtherNegativeHeadersAsRoll:
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKKnucklesAnimation_ReturnAfterKnucklesAnimationHoldOrFrameStore
                move.w  ground_vel(a0),d2
                bpl.s   SKKnucklesAnimation_ChooseKnucklesRollStreamAtUnsignedSixHundred
                neg.w   d2

SKKnucklesAnimation_ChooseKnucklesRollStreamAtUnsignedSixHundred:
                lea     (AniKnuckles03).l,a1
                cmpi.w  #$600,d2
                bhs.s   SKKnucklesAnimation_ClampWrappedKnucklesRollDuration
                lea     (AniKnuckles02).l,a1

SKKnucklesAnimation_ClampWrappedKnucklesRollDuration:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   SKKnucklesAnimation_ReloadKnucklesRollDelayAndStepPayload
                moveq   #0,d2

SKKnucklesAnimation_ReloadKnucklesRollDelayAndStepPayload:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                bra.w   SKKnucklesAnimation_ReadKnucklesFrameBytecodeWithFcThreshold
; ---------------------------------------------------------------------------

SKKnucklesAnimation_GateKnucklesPushFrameAndPrepareNegativeSpeed:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKKnucklesAnimation_ReturnAfterKnucklesAnimationHoldOrFrameStore
                move.w  ground_vel(a0),d2
                bmi.s   SKKnucklesAnimation_ClampWrappedKnucklesPushDuration
                neg.w   d2

SKKnucklesAnimation_ClampWrappedKnucklesPushDuration:
                addi.w  #$800,d2
                bpl.s   SKKnucklesAnimation_ReloadKnucklesPushDelayAndStepPushPayload
                moveq   #0,d2

SKKnucklesAnimation_ReloadKnucklesPushDelayAndStepPushPayload:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniKnuckles04).l,a1
                bra.w   SKKnucklesAnimation_ReadKnucklesFrameBytecodeWithFcThreshold
; End of function Animate_Knuckles

; ---------------------------------------------------------------------------
AniKnuckles:
                include "src/objects/shared/knuckles/animations/knuckles.s"

; =============== S U B R O U T I N E =======================================

Knuckles_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0

Knuckles_Load_PLC2:
                cmp.b   (Player_prev_frame).w,d0
                beq.s   KnucklesFrameDMA_Return
                move.b  d0,(Player_prev_frame).w
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4

KnucklesQueueFramePatternsAtVRAMBase:
                lea     (PLC_Knuckles).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   KnucklesFrameDMA_Return
                move.l  #ArtUnc_Knux,d6

KnucklesFrameDMA_QueueNextDescriptor:
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
                dbf     d5,KnucklesFrameDMA_QueueNextDescriptor

KnucklesFrameDMA_Return:
                rts
; End of function Knuckles_Load_PLC
