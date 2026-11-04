; Owner: objects/players/knuckles/sk
; Responsibility: Knuckles animation selection and dynamic pattern loading
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Knuckles:
                lea     (AniKnuckles).l,a1
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   SKKnuxAnim_DispatchHeader
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

SKKnuxAnim_DispatchHeader:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   SKKnuxAnim_DispatchMovementHeaderFF
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKKnuxAnim_FrameReturn
                move.b  d0,anim_frame_timer(a0)

SKKnuxAnim_ReadFrameOrCommand:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$FC,d0
                bhs.s   SKKnuxAnim_TestRestartFF

SKKnuxAnim_StoreFrameAndAdvance:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

SKKnuxAnim_FrameReturn:
                rts
; ---------------------------------------------------------------------------

SKKnuxAnim_TestRestartFF:
                addq.b  #1,d0
                bne.s   SKKnuxAnim_TestBacktrackFE
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   SKKnuxAnim_StoreFrameAndAdvance
; ---------------------------------------------------------------------------

SKKnuxAnim_TestBacktrackFE:
                addq.b  #1,d0
                bne.s   SKKnuxAnim_TestChangeFD
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   SKKnuxAnim_StoreFrameAndAdvance
; ---------------------------------------------------------------------------

SKKnuxAnim_TestChangeFD:
                addq.b  #1,d0
                bne.s   SKKnuxAnim_CommandReturn
                move.b  2(a1,d1.w),anim(a0)

SKKnuxAnim_CommandReturn:
                rts
; ---------------------------------------------------------------------------

; Header $FF selects movement or tumble. Other negative headers select roll cadence
SKKnuxAnim_DispatchMovementHeaderFF:
                addq.b  #1,d0
                bne.w   SKKnuxAnim_TickRollFrames
                moveq   #0,d0
                tst.b   flip_type(a0)
                bmi.w   Anim_Tumble
                move.b  flip_angle(a0),d0
                bne.w   Anim_Tumble
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   SKKnuxAnim_OrientWalkAngle
                beq.s   SKKnuxAnim_OrientWalkAngle
                subq.b  #1,d0

SKKnuxAnim_OrientWalkAngle:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKKnuxAnim_ChooseWalkFlip
                not.b   d0

SKKnuxAnim_ChooseWalkFlip:
                addi.b  #$10,d0
                bpl.s   SKKnuxAnim_ApplyWalkFlipAndCheckPush
                moveq   #3,d1

SKKnuxAnim_ApplyWalkFlipAndCheckPush:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   SKKnuxAnim_TickPushFrames
                lsr.b   #4,d0
                andi.b  #6,d0
                move.w  ground_vel(a0),d2
                bpl.s   SKKnuxAnim_AdjustWalkSpeed
                neg.w   d2

; Double the animation speed magnitude when secondary status is negative
SKKnuxAnim_AdjustWalkSpeed:
                tst.b   status_secondary(a0)
                bpl.w   SKKnuxAnim_SelectWalkOrRunAt600
                add.w   d2,d2

SKKnuxAnim_SelectWalkOrRunAt600:
                lea     (AniKnuckles01).l,a1
                cmpi.w  #$600,d2
                bhs.s   SKKnuxAnim_ReadAngularMoveFrame
                lea     (AniKnuckles00).l,a1
                add.b   d0,d0

SKKnuxAnim_ReadAngularMoveFrame:
                add.b   d0,d0
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   SKKnuxAnim_StoreMoveFrameAndTick
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

SKKnuxAnim_StoreMoveFrameAndTick:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKKnuxAnim_MovementReturn
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   SKKnuxAnim_ReloadMoveDelayAndAdvance
                moveq   #0,d2

SKKnuxAnim_ReloadMoveDelayAndAdvance:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

SKKnuxAnim_MovementReturn:
                rts
; ---------------------------------------------------------------------------

SKKnuxAnim_TickRollFrames:
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKKnuxAnim_FrameReturn
                move.w  ground_vel(a0),d2
                bpl.s   SKKnuxAnim_SelectRollSequenceAt600
                neg.w   d2

SKKnuxAnim_SelectRollSequenceAt600:
                lea     (AniKnuckles03).l,a1
                cmpi.w  #$600,d2
                bhs.s   SKKnuxAnim_ClampRollDelay
                lea     (AniKnuckles02).l,a1

SKKnuxAnim_ClampRollDelay:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   SKKnuxAnim_ReloadRollDelayAndReadFrame
                moveq   #0,d2

SKKnuxAnim_ReloadRollDelayAndReadFrame:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                bra.w   SKKnuxAnim_ReadFrameOrCommand
; ---------------------------------------------------------------------------

SKKnuxAnim_TickPushFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKKnuxAnim_FrameReturn
                move.w  ground_vel(a0),d2
                bmi.s   SKKnuxAnim_ClampPushDelay
                neg.w   d2

SKKnuxAnim_ClampPushDelay:
                addi.w  #$800,d2
                bpl.s   SKKnuxAnim_ReloadPushDelayAndReadFrame
                moveq   #0,d2

SKKnuxAnim_ReloadPushDelayAndReadFrame:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniKnuckles04).l,a1
                bra.w   SKKnuxAnim_ReadFrameOrCommand
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
