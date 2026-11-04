; Owner: objects/players/common/s3
; Responsibility: Shared Sonic and Knuckles competition animation and compact dynamic pattern loading
; Source provenance and ranges: config/reconstruction/source_layout.json
Animate_SonicKnuckles_2P:
                lea     (AniSonic2P).l,a1
                tst.b   character_id(a0)
                beq.s   S3CompAnim_ResetOnAnimChange
                lea     (AniKnuckles2P).l,a1

S3CompAnim_ResetOnAnimChange:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   S3CompAnim_DispatchHeader
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

S3CompAnim_DispatchHeader:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   S3CompAnim_DispatchMovementHeaderFF
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3CompAnim_FrameReturn
                move.b  d0,anim_frame_timer(a0)

; Bytes $FC through $FF enter the command decoder
S3CompAnim_ReadFrameOrCommand:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$FC,d0
                bhs.s   S3CompAnim_TestLoopFF

S3CompAnim_StoreFrameAndAdvance:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

S3CompAnim_FrameReturn:
                rts
; ---------------------------------------------------------------------------

S3CompAnim_TestLoopFF:
                addq.b  #1,d0
                bne.s   S3CompAnim_TestRewindFE
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   S3CompAnim_StoreFrameAndAdvance
; ---------------------------------------------------------------------------

S3CompAnim_TestRewindFE:
                addq.b  #1,d0
                bne.s   S3CompAnim_TestChangeFD
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   S3CompAnim_StoreFrameAndAdvance
; ---------------------------------------------------------------------------

S3CompAnim_TestChangeFD:
                addq.b  #1,d0
                bne.s   S3CompAnim_CommandReturn
                move.b  2(a1,d1.w),anim(a0)

S3CompAnim_CommandReturn:
                rts
; ---------------------------------------------------------------------------

; Header $FF selects movement or tumble. Other negative headers use rolling frames
S3CompAnim_DispatchMovementHeaderFF:
                addq.b  #1,d0
                bne.w   S3CompAnim_TickRollingFrames
                moveq   #0,d0
                move.b  flip_angle(a0),d0
                bne.w   S3CompAnim_SelectTumbleOrientation
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   S3CompAnim_ReflectAngleIfFacingRight
                beq.s   S3CompAnim_ReflectAngleIfFacingRight
                subq.b  #1,d0

S3CompAnim_ReflectAngleIfFacingRight:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3CompAnim_PickMovementFlip
                not.b   d0

S3CompAnim_PickMovementFlip:
                addi.b  #$10,d0
                bpl.s   S3CompAnim_ApplyFlipAndCheckPush
                moveq   #3,d1

S3CompAnim_ApplyFlipAndCheckPush:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   S3CompAnim_TickPushingFrames
                lsr.b   #5,d0
                andi.b  #3,d0
                move.w  ground_vel(a0),d2
                bpl.s   S3CompAnim_AdjustMovementSpeed
                neg.w   d2

; Double the speed used for frame selection when secondary status is negative
S3CompAnim_AdjustMovementSpeed:
                tst.b   status_secondary(a0)
                bpl.w   S3CompAnim_SelectWalkOrRunSequence
                add.w   d2,d2

S3CompAnim_SelectWalkOrRunSequence:
                move.b  d0,d3
                lea     (AniSonic2P01).l,a1
                cmpi.w  #$600,d2
                bhs.s   S3CompAnim_ReadOrLoopMovementFrame
                lea     (AniSonic2P00).l,a1
                add.b   d0,d0

S3CompAnim_ReadOrLoopMovementFrame:
                add.b   d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   S3CompAnim_StoreMovementFrameAndTick
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

; Write the oriented frame every call. Advance the cursor on timer underflow
S3CompAnim_StoreMovementFrameAndTick:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3CompAnim_MovementReturn
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   S3CompAnim_ReloadMoveDelayAndAdvance
                moveq   #0,d2

S3CompAnim_ReloadMoveDelayAndAdvance:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

S3CompAnim_MovementReturn:
                rts
; ---------------------------------------------------------------------------

S3CompAnim_SelectTumbleOrientation:
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3CompAnim_SelectLeftTumbleFlip
                andi.b  #$FC,render_flags(a0)
                addi.b  #$16,d0
                divu.w  #$2C,d0
                addi.b  #$15,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3CompAnim_SelectLeftTumbleFlip:
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   S3CompAnim_ReverseTumbleAndFlipXY
                ori.b   #1,render_flags(a0)
                addi.b  #$16,d0
                bra.s   S3CompAnim_StoreLeftTumbleFrame
; ---------------------------------------------------------------------------

S3CompAnim_ReverseTumbleAndFlipXY:
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$9A,d0

S3CompAnim_StoreLeftTumbleFrame:
                divu.w  #$2C,d0
                addi.b  #$15,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3CompAnim_TickRollingFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   S3CompAnim_FrameReturn
                move.w  ground_vel(a0),d2
                bpl.s   S3CompAnim_SelectRollSequence
                neg.w   d2

S3CompAnim_SelectRollSequence:
                lea     (AniSonic2P03).l,a1
                cmpi.w  #$600,d2
                bhs.s   S3CompAnim_CalcRollDelay
                lea     (AniSonic2P02).l,a1

S3CompAnim_CalcRollDelay:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   S3CompAnim_ReloadRollDelayAndFacing
                moveq   #0,d2

S3CompAnim_ReloadRollDelayAndFacing:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   S3CompAnim_ReadFrameOrCommand
; ---------------------------------------------------------------------------

S3CompAnim_TickPushingFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   S3CompAnim_FrameReturn
                move.w  ground_vel(a0),d2
                bmi.s   S3CompAnim_CalcPushDelay
                neg.w   d2

S3CompAnim_CalcPushDelay:
                addi.w  #$800,d2
                bpl.s   S3CompAnim_SelectPushSequence
                moveq   #0,d2

; Knuckles uses a separate sequence and an additional divide by four for the delay
S3CompAnim_SelectPushSequence:
                lsr.w   #6,d2
                lea     (AniSonic2P04).l,a1
                tst.b   character_id(a0)
                beq.s   S3CompAnim_StorePushDelayAndFacing
                lea     (AniKnuckles2P04).l,a1
                lsr.w   #2,d2

S3CompAnim_StorePushDelayAndFacing:
                move.b  d2,anim_frame_timer(a0)
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   S3CompAnim_ReadFrameOrCommand
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
                beq.s   S3CompAnim_SelectPatternsAndPlayerVRAM
                lea     (PLC_Knuckles2P).l,a2
                move.l  #ArtUnc_Knuckles2P,d6

S3CompAnim_SelectPatternsAndPlayerVRAM:
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   S3CompAnim_PatternQueueReturn
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4
                cmpa.w  #Player_1,a0
                beq.s   S3CompAnim_QueuePatternRun
                move.w  #tiles_to_bytes(ArtTile_Player_2),d4

S3CompAnim_QueuePatternRun:
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
                dbf     d5,S3CompAnim_QueuePatternRun

S3CompAnim_PatternQueueReturn:
                rts
; End of function SonicKnuckles2P_Load_PLC

; ---------------------------------------------------------------------------
