; Owner: objects/players/tails/s3
; Responsibility: Competition Tails animation and pattern loading plus normal and competition tail object rendering
; Source provenance and ranges: config/reconstruction/source_layout.json
Animate_Tails2P:
                lea     (AniTails2P).l,a1

Animate_Tails_Tail2P:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   S3TailsTailDriver_ResolveCompactRelativeHeaderAndOrdinaryTimer
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

S3TailsTailDriver_ResolveCompactRelativeHeaderAndOrdinaryTimer:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   S3TailsTailDriver_SelectCompactMovementTumbleOrOtherNegativeDriver
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3TailsTailDriver_ReturnAfterCompactAnimationHoldOrFrameWrite
                move.b  d0,anim_frame_timer(a0)
; End of function Animate_Tails2P

; =============== S U B R O U T I N E =======================================

TailsS3StepCompetitionAnimationFrameBytecode:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$F0,d0
                bhs.s   S3TailsTailDriver_ResolveCompactFfFullStreamRestart

S3TailsTailDriver_StoreCompactMappingFrameAndAdvanceByteCursor:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

S3TailsTailDriver_ReturnAfterCompactAnimationHoldOrFrameWrite:
                rts
; ---------------------------------------------------------------------------

S3TailsTailDriver_ResolveCompactFfFullStreamRestart:
                addq.b  #1,d0
                bne.s   S3TailsTailDriver_ResolveCompactFeByteBacktrack
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   S3TailsTailDriver_StoreCompactMappingFrameAndAdvanceByteCursor
; ---------------------------------------------------------------------------

S3TailsTailDriver_ResolveCompactFeByteBacktrack:
                addq.b  #1,d0
                bne.s   S3TailsTailDriver_DeferCompactAnimationChangeOrIgnoreOtherCommand
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   S3TailsTailDriver_StoreCompactMappingFrameAndAdvanceByteCursor
; ---------------------------------------------------------------------------

S3TailsTailDriver_DeferCompactAnimationChangeOrIgnoreOtherCommand:
                addq.b  #1,d0
                bne.s   S3TailsTailDriver_ReturnAfterCompactDeferredOrIgnoredCommand
                move.b  2(a1,d1.w),anim(a0)

S3TailsTailDriver_ReturnAfterCompactDeferredOrIgnoredCommand:
                rts
; End of function TailsS3StepCompetitionAnimationFrameBytecode

; ---------------------------------------------------------------------------

S3TailsTailDriver_SelectCompactMovementTumbleOrOtherNegativeDriver:
                addq.b  #1,d0
                bne.w   S3TailsTailDriver_GateCompactRollOrDirectionalTailByTimer
                moveq   #0,d0
                move.b  flip_angle(a0),d0
                bne.w   S3TailsTailDriver_QuantizeCompactTumbleForFacingClear
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   S3TailsTailDriver_OrientCompactMovementAngleByFacing
                beq.s   S3TailsTailDriver_OrientCompactMovementAngleByFacing
                subq.b  #1,d0

S3TailsTailDriver_OrientCompactMovementAngleByFacing:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3TailsTailDriver_ChooseCompactMovementFlipPairFromAngleSign
                not.b   d0

S3TailsTailDriver_ChooseCompactMovementFlipPairFromAngleSign:
                addi.b  #$10,d0
                bpl.s   S3TailsTailDriver_ApplyCompactMovementFlipsAndSelectPushOrSpeed
                moveq   #3,d1

S3TailsTailDriver_ApplyCompactMovementFlipsAndSelectPushOrSpeed:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   S3TailsTailDriver_GateCompactPushStepAndTakeNegativeSpeedMagnitude
                lsr.b   #5,d0
                andi.b  #3,d0
                move.w  ground_vel(a0),d2
                bpl.s   S3TailsTailDriver_DoubleCompactAnimationSpeedForSecondarySignBit
                neg.w   d2

S3TailsTailDriver_DoubleCompactAnimationSpeedForSecondarySignBit:
                tst.b   status_secondary(a0)
                bpl.w   S3TailsTailDriver_ChooseCompactWalkOrRunStreamAtSixHundred
                add.w   d2,d2

S3TailsTailDriver_ChooseCompactWalkOrRunStreamAtSixHundred:
                move.b  d0,d3
                lea     (AniTails2P01).l,a1
                cmpi.w  #$600,d2
                bhs.s   S3TailsTailDriver_ComputeCompactAngularStrideAndReadCurrentFrame
                lea     (AniTails2P00).l,a1
                add.b   d0,d0

S3TailsTailDriver_ComputeCompactAngularStrideAndReadCurrentFrame:
                add.b   d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   S3TailsTailDriver_RefreshCompactAngularFrameBeforeTimerAdvance
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

S3TailsTailDriver_RefreshCompactAngularFrameBeforeTimerAdvance:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3TailsTailDriver_ReturnAfterCompactMovementFrameRefresh
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   S3TailsTailDriver_ReloadCompactMovementDelayAndAdvanceCursor
                moveq   #0,d2

S3TailsTailDriver_ReloadCompactMovementDelayAndAdvanceCursor:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

S3TailsTailDriver_ReturnAfterCompactMovementFrameRefresh:
                rts
; ---------------------------------------------------------------------------

S3TailsTailDriver_QuantizeCompactTumbleForFacingClear:
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3TailsTailDriver_ChooseCompactFacingSetTumbleReflectionByFlipTypeSign
                andi.b  #$FC,render_flags(a0)
                addi.b  #$16,d0
                divu.w  #$2C,d0
                addi.b  #$15,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsTailDriver_ChooseCompactFacingSetTumbleReflectionByFlipTypeSign:
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   S3TailsTailDriver_MirrorCompactFacingSetTumbleWithByteNegation
                ori.b   #1,render_flags(a0)
                addi.b  #$16,d0
                bra.s   S3TailsTailDriver_StoreCompactFacingSetTumbleFrameAndZeroTimer
; ---------------------------------------------------------------------------

S3TailsTailDriver_MirrorCompactFacingSetTumbleWithByteNegation:
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$9A,d0

S3TailsTailDriver_StoreCompactFacingSetTumbleFrameAndZeroTimer:
                divu.w  #$2C,d0
                addi.b  #$15,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsTailDriver_GateCompactRollOrDirectionalTailByTimer:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   S3TailsTailDriver_ReturnAfterCompactAnimationHoldOrFrameWrite
                addq.b  #1,d0
                bne.s   S3TailsTailDriver_DeriveCompactDirectionalTailAngleFromParentVelocity
                move.w  ground_vel(a0),d2
                bpl.s   S3TailsTailDriver_ChooseCompactRollStreamAtUnsignedSixHundred
                neg.w   d2

S3TailsTailDriver_ChooseCompactRollStreamAtUnsignedSixHundred:
                lea     (AniTails2P03).l,a1
                cmpi.w  #$600,d2
                bhs.s   S3TailsTailDriver_ComputeCompactRollDurationFromWrappedSpeed
                lea     (AniTails2P02).l,a1

S3TailsTailDriver_ComputeCompactRollDurationFromWrappedSpeed:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   S3TailsTailDriver_ReloadCompactRollDelayAndApplyFacingBeforeFrameStep
                moveq   #0,d2

S3TailsTailDriver_ReloadCompactRollDelayAndApplyFacingBeforeFrameStep:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   TailsS3StepCompetitionAnimationFrameBytecode
; ---------------------------------------------------------------------------

S3TailsTailDriver_GateCompactPushStepAndTakeNegativeSpeedMagnitude:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   S3TailsTailDriver_ReturnAfterCompactAnimationHoldOrFrameWrite
                move.w  ground_vel(a0),d2
                bmi.s   S3TailsTailDriver_ClampCompactPushDurationAfterEightHundredAddition
                neg.w   d2

S3TailsTailDriver_ClampCompactPushDurationAfterEightHundredAddition:
                addi.w  #$800,d2
                bpl.s   S3TailsTailDriver_ReloadCompactPushDelayAndStepItsPayloadDirectly
                moveq   #0,d2

S3TailsTailDriver_ReloadCompactPushDelayAndStepItsPayloadDirectly:
                lsr.w   #6,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniTails2P04).l,a1
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   TailsS3StepCompetitionAnimationFrameBytecode
; ---------------------------------------------------------------------------

S3TailsTailDriver_DeriveCompactDirectionalTailAngleFromParentVelocity:
                move.w  x_vel(a2),d1
                move.w  y_vel(a2),d2
                jsr     (GetArcTan).l
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3TailsTailDriver_RotateCompactDirectionalTailAngleForFacingSet
                not.b   d0
                bra.s   S3TailsTailDriver_ChooseCompactDirectionalTailQuadrantFlipPair
; ---------------------------------------------------------------------------

S3TailsTailDriver_RotateCompactDirectionalTailAngleForFacingSet:
                addi.b  #$80,d0

S3TailsTailDriver_ChooseCompactDirectionalTailQuadrantFlipPair:
                addi.b  #$10,d0
                bpl.s   S3TailsTailDriver_StepCompactDirectionalTailAndAddThreeFrameAngularStride
                moveq   #3,d1

S3TailsTailDriver_StepCompactDirectionalTailAndAddThreeFrameAngularStride:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                lsr.b   #5,d0
                andi.b  #3,d0
                move.b  d0,d3
                add.b   d0,d0
                add.b   d0,d3
                lea     (AniTails2P_Tail03).l,a1
                move.b  #3,anim_frame_timer(a0)
                bsr.w   TailsS3StepCompetitionAnimationFrameBytecode
                add.b   d3,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
AniTails2P:
                include "src/objects/shared/tails/animations/competition.s"

; =============== S U B R O U T I N E =======================================

Tails2P_Tail_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                lea     (DPLC_Tails2P_Tail).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   S3TailsTailDriver_ReturnAfterCompactEmptyCueOrFinishedUncachedTransfers
                move.l  #ArtUnc_Tails2P_Tail,d6
                move.w  #tiles_to_bytes(ArtTile_Player_2_Tail),d4
                cmpa.w  #Tails_tails,a0
                beq.s   S3TailsTailDriver_QueueUncachedCompactBodyOrTailPackedTransfers
                move.w  #tiles_to_bytes(ArtTile_Player_1+$10),d4
                bra.s   S3TailsTailDriver_QueueUncachedCompactBodyOrTailPackedTransfers
; End of function Tails2P_Tail_Load_PLC

; =============== S U B R O U T I N E =======================================

Tails2P_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                lea     (PLC_Tails2P).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   S3TailsTailDriver_ReturnAfterCompactEmptyCueOrFinishedUncachedTransfers
                move.l  #ArtUnc_Tails2P,d6
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4
                cmpa.w  #Player_1,a0
                beq.s   S3TailsTailDriver_QueueUncachedCompactBodyOrTailPackedTransfers
                move.w  #tiles_to_bytes(ArtTile_Player_2),d4

S3TailsTailDriver_QueueUncachedCompactBodyOrTailPackedTransfers:
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
                dbf     d5,S3TailsTailDriver_QueueUncachedCompactBodyOrTailPackedTransfers

S3TailsTailDriver_ReturnAfterCompactEmptyCueOrFinishedUncachedTransfers:
                rts
; End of function Tails2P_Load_PLC

; ---------------------------------------------------------------------------

Obj_Tails_Tail:
; Init
                move.l  #Map_Tails_Tail,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_2_Tail,0,0),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.l  #Obj_Tails_Tail_Main,(a0)

Obj_Tails_Tail_Main:
; Here, several SSTs are inherited from the parent, normally Tails
                movea.w $30(a0),a2                      ; Is Parent in S2
                move.b  angle(a2),angle(a0)
                move.b  status(a2),status(a0)
                move.w  x_pos(a2),x_pos(a0)
                move.w  y_pos(a2),y_pos(a0)
                move.w  priority(a2),priority(a0)
                andi.w  #drawing_mask,art_tile(a0)
                tst.w   art_tile(a2)
                bpl.s   S3TailsTailDriver_ChooseNormalTailParentAnimationWithProfilePushOverride
                ori.w   #high_priority,art_tile(a0)

S3TailsTailDriver_ChooseNormalTailParentAnimationWithProfilePushOverride:
                moveq   #0,d0
                move.b  anim(a2),d0
                btst    #Status_Push,status(a2)
                beq.s   S3TailsTailDriver_RemapChangedNormalParentAnimationToTailBank
                tst.b   (WindTunnel_flag_P2).w
                bne.s   S3TailsTailDriver_RemapChangedNormalParentAnimationToTailBank
                moveq   #4,d0

S3TailsTailDriver_RemapChangedNormalParentAnimationToTailBank:
                cmp.b   objoff_34(a0),d0                ; Has the input parent anim changed since last check?
                beq.s   S3TailsTailDriver_AnimateNormalTailThenLoadPatternsAndQueueSprite  ; If not, branch and skip setting a matching Tails' Tails anim
                move.b  d0,objoff_34(a0)                ; Store d0 for the above comparison
                move.b  Obj_Tails_Tail_AniSelection(pc,d0.w),anim(a0)  ; Load anim relative to parent's

S3TailsTailDriver_AnimateNormalTailThenLoadPatternsAndQueueSprite:
                lea     (AniTails_Tail).l,a1
                bsr.w   Animate_Tails_Part2
                bsr.w   Tails_Tail_Load_PLC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
; animation master script table for the tails
; chooses which animation script to run depending on what Tails is doing

Obj_Tails_Tail_AniSelection:
                dc.b    0,0                             ; TailsAni_Walk,Run ->
                dc.b    3                               ; TailsAni_Roll  -> Directional
                dc.b    3                               ; TailsAni_Roll2 -> Directional
                dc.b    9                               ; TailsAni_Push  -> Pushing
                dc.b    1                               ; TailsAni_Wait  -> Swish
                dc.b    0                               ; TailsAni_Balance -> Blank
                dc.b    2                               ; TailsAni_LookUp -> Flick
                dc.b    1                               ; TailsAni_Duck  -> Swish
                dc.b    7                               ; TailsAni_Spindash -> Spindash
                dc.b    0,0,0                           ; TailsAni_Dummy1,2,3 ->
                dc.b    8                               ; TailsAni_Stop  -> Skidding
                dc.b    0,0                             ; TailsAni_Float,2 ->
                dc.b    0                               ; TailsAni_Spring ->
                dc.b    0                               ; TailsAni_Hang  ->
                dc.b    0                               ;
                dc.b    0                               ; TailsAni_Victory ->
                dc.b    $A                              ; TailsAni_Hang2 -> Hanging
                dc.b    0                               ; TailsAni_Bubble ->
                dc.b    0,0,0                           ; TailsAni_Death,2,3 ->
                dc.b    0                               ; TailsAni_Slide2? ->
                dc.b    0,0                             ; TailsAni_Hurt,Slide ->
                dc.b    0                               ; TailsAni_Blank ->
                dc.b    0,0                             ; TailsAni_Dummy4,5 ->
                dc.b    0                               ; TailsAni_HaulAss ->
                dc.b    $B,$C                           ; TailsAni_Fly,2 -> Fly1,2
                dc.b    $B                              ; TailsAni_Carry -> Fly1
                dc.b    $C                              ; TailsAni_Ascend -> Fly2
                dc.b    $B                              ; TailsAni_Tired -> Fly1
                dc.b    0,0                             ; TailsAni_Swim,2 ->
                dc.b    0                               ; TailsAni_Tired2 ->
                dc.b    0                               ; TailsAni_Tired3 ->
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                even
AniTails_Tail:
                include "src/objects/shared/tails/animations/tail.s"
; ---------------------------------------------------------------------------

Obj_Tails2P_Tail:
                move.l  #Map_Tails2P_Tail,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_2_Tail,0,0),art_tile(a0)
                cmpa.w  #Tails_tails,a0
                beq.s   S3TailsTailDriver_InitializeCompactTailGeometryAndInstallFollowCallback
                move.w  #make_art_tile(ArtTile_Player_1+$10,0,0),art_tile(a0)

S3TailsTailDriver_InitializeCompactTailGeometryAndInstallFollowCallback:
                move.w  #$100,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.l  #S3TailsTailDriver_FollowCompactTailParentCoordinatesStatusAndArtPriority,(a0)

S3TailsTailDriver_FollowCompactTailParentCoordinatesStatusAndArtPriority:
                movea.w $30(a0),a2
                move.b  angle(a2),angle(a0)
                move.b  status(a2),status(a0)
                move.w  x_pos(a2),x_pos(a0)
                move.w  y_pos(a2),y_pos(a0)
                move.w  priority(a2),priority(a0)
                andi.w  #drawing_mask,art_tile(a0)
                tst.w   art_tile(a2)
                bpl.s   S3TailsTailDriver_OverrideCompactTailSelectorForPushExceptIdleBankFive
                ori.w   #high_priority,art_tile(a0)

S3TailsTailDriver_OverrideCompactTailSelectorForPushExceptIdleBankFive:
                moveq   #0,d0
                move.b  anim(a2),d0
                btst    #Status_Push,status(a2)
                beq.s   S3TailsTailDriver_RemapChangedCompactParentSelectorThroughByteTable
                cmpi.b  #5,d0
                beq.s   S3TailsTailDriver_RemapChangedCompactParentSelectorThroughByteTable
                moveq   #4,d0

S3TailsTailDriver_RemapChangedCompactParentSelectorThroughByteTable:
                cmp.b   $34(a0),d0
                beq.s   S3TailsTailDriver_AnimateCompactTailQueueUncachedPatternsAndDraw
                move.b  d0,$34(a0)
                move.b  S3TailsTailDriver_CompetitionParentAnimationToTailBankBytes(pc,d0.w),anim(a0)

S3TailsTailDriver_AnimateCompactTailQueueUncachedPatternsAndDraw:
                lea     (AniTails2P_Tail).l,a1
                bsr.w   Animate_Tails_Tail2P
                bsr.w   Tails2P_Tail_Load_PLC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
S3TailsTailDriver_CompetitionParentAnimationToTailBankBytes:
                dc.b    0,0
                dc.b    3
                dc.b    3
                dc.b    0
                dc.b    1
                dc.b    1
                dc.b    1
                dc.b    1
                dc.b    0
                dc.b    1,1,1
                dc.b    0
                dc.b    0,0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0,0,0
                dc.b    0
                dc.b    0,0
                dc.b    0
                dc.b    0,0
                dc.b    0
                dc.b    0,0
                even
AniTails2P_Tail:
                include "src/objects/shared/tails/animations/competition_tail.s"
; ---------------------------------------------------------------------------
