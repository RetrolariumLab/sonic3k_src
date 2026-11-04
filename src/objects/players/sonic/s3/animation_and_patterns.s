; Owner: objects/players/sonic/s3
; Responsibility: Sonic animation selection, dynamic pattern loading and the common player DPLC dispatch interface
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Sonic:
                lea     (AniSonic).l,a1
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   S3SonicAnim_ResetOnAnimChange
                lea     (AniSuperSonic).l,a1

S3SonicAnim_ResetOnAnimChange:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   S3SonicAnim_DispatchHeader
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

S3SonicAnim_DispatchHeader:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   S3SonicAnim_DispatchMovementHeaderFF
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3SonicAnim_FrameReturn
                move.b  d0,anim_frame_timer(a0)

S3SonicAnim_ReadFrameOrCommand:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$FC,d0
                bhs.s   S3SonicAnim_TestRestartFF

S3SonicAnim_StoreFrameAndAdvance:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

S3SonicAnim_FrameReturn:
                rts
; ---------------------------------------------------------------------------

S3SonicAnim_TestRestartFF:
                addq.b  #1,d0
                bne.s   S3SonicAnim_TestBacktrackFE
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   S3SonicAnim_StoreFrameAndAdvance
; ---------------------------------------------------------------------------

S3SonicAnim_TestBacktrackFE:
                addq.b  #1,d0
                bne.s   S3SonicAnim_TestChangeFD
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   S3SonicAnim_StoreFrameAndAdvance
; ---------------------------------------------------------------------------

S3SonicAnim_TestChangeFD:
                addq.b  #1,d0
                bne.s   S3SonicAnim_CommandReturn
                move.b  2(a1,d1.w),anim(a0)

S3SonicAnim_CommandReturn:
                rts
; ---------------------------------------------------------------------------

; Header $FF selects walking or tumble. Other negative headers select roll cadence
S3SonicAnim_DispatchMovementHeaderFF:
                addq.b  #1,d0
                bne.w   S3SonicAnim_TickRollFrames
                moveq   #0,d0
                tst.b   flip_type(a0)
                bmi.w   Anim_Tumble
                move.b  flip_angle(a0),d0
                bne.w   Anim_Tumble
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   S3SonicAnim_OrientWalkAngle
                beq.s   S3SonicAnim_OrientWalkAngle
                subq.b  #1,d0

S3SonicAnim_OrientWalkAngle:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3SonicAnim_ChooseWalkFlip
                not.b   d0

S3SonicAnim_ChooseWalkFlip:
                addi.b  #$10,d0
                bpl.s   S3SonicAnim_ApplyWalkFlipAndCheckPush
                moveq   #3,d1

S3SonicAnim_ApplyWalkFlipAndCheckPush:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   S3SonicAnim_TickPushFrames
                lsr.b   #4,d0
                andi.b  #6,d0
                move.w  ground_vel(a0),d2
                bpl.s   S3SonicAnim_AdjustWalkSpeed
                neg.w   d2

; Double the animation speed magnitude when secondary status is negative
S3SonicAnim_AdjustWalkSpeed:
                tst.b   status_secondary(a0)
                bpl.w   S3SonicAnim_SelectWalkOrRunAt600
                add.w   d2,d2

S3SonicAnim_SelectWalkOrRunAt600:
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   S3SonicAnim_SelectSuperWalkOrRunAt800
                lea     (AniSonic01).l,a1
                cmpi.w  #$600,d2
                bhs.s   S3SonicAnim_ReadNormalMoveFrame
                lea     (AniSonic00).l,a1
                add.b   d0,d0

S3SonicAnim_ReadNormalMoveFrame:
                add.b   d0,d0
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   S3SonicAnim_StoreNormalMoveFrameAndTick
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

S3SonicAnim_StoreNormalMoveFrameAndTick:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3SonicAnim_NormalMoveReturn
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   S3SonicAnim_ReloadNormalMoveDelay
                moveq   #0,d2

S3SonicAnim_ReloadNormalMoveDelay:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

S3SonicAnim_NormalMoveReturn:
                rts
; ---------------------------------------------------------------------------

S3SonicAnim_SelectSuperWalkOrRunAt800:
                lea     (AniSuperSonic01).l,a1
                cmpi.w  #$800,d2
                bhs.s   S3SonicAnim_DoubleSuperRunSectorOffset
                lea     (AniSuperSonic00).l,a1
                add.b   d0,d0
                add.b   d0,d0
                bra.s   S3SonicAnim_ReadOrLoopSuperMoveFrame
; ---------------------------------------------------------------------------

S3SonicAnim_DoubleSuperRunSectorOffset:
                add.b   d0,d0

S3SonicAnim_ReadOrLoopSuperMoveFrame:
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   S3SonicAnim_StoreSuperMoveFrameAndTick
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

S3SonicAnim_StoreSuperMoveFrameAndTick:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3SonicAnim_SuperMoveReturn
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   S3SonicAnim_ReloadSuperMoveDelay
                moveq   #0,d2

S3SonicAnim_ReloadSuperMoveDelay:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

S3SonicAnim_SuperMoveReturn:
                rts
; ---------------------------------------------------------------------------

; loc_1360C:
Anim_Tumble:
                move.b  flip_type(a0),d1
                andi.w  #$7F,d1
                bne.s   S3SonicAnim_ReadTumbleBaseAndTestType1
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   Anim_TumbleLeft
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   S3SonicAnim_BiasRightTumble0Phase
                ori.b   #2,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                bra.s   S3SonicAnim_StoreRightTumble0Frame
; ---------------------------------------------------------------------------

S3SonicAnim_BiasRightTumble0Phase:
                addi.b  #$B,d0

S3SonicAnim_StoreRightTumble0Frame:
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
S3SonicAnim_TumbleFrameBases:
                dc.b    0, $3D, $49, $49
                even
; ---------------------------------------------------------------------------

S3SonicAnim_ReadTumbleBaseAndTestType1:
                move.b  S3SonicAnim_TumbleFrameBases(pc,d1.w),d3
                cmpi.b  #1,d1
                bne.s   S3SonicAnim_TestTumbleType2
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3SonicAnim_StoreLeftTumble1Frame
                andi.b  #$FC,render_flags(a0)
                addi.b  #-8,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3SonicAnim_StoreLeftTumble1Frame:
                andi.b  #$FC,render_flags(a0)
                ori.b   #1,render_flags(a0)
                addi.b  #-8,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3SonicAnim_TestTumbleType2:
                cmpi.b  #2,d1
                bne.s   S3SonicAnim_DispatchTumbleType3
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3SonicAnim_StoreLeftTumble2Frame
                andi.b  #$FC,render_flags(a0)
                addi.b  #$B,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3SonicAnim_StoreLeftTumble2Frame:
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

S3SonicAnim_DispatchTumbleType3:
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3SonicAnim_StoreLeftTumble3Frame
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

S3SonicAnim_StoreLeftTumble3Frame:
                andi.b  #$FC,render_flags(a0)
                ori.b   #1,render_flags(a0)
                addi.b  #$B,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3SonicAnim_TickRollFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   S3SonicAnim_FrameReturn
                move.w  ground_vel(a0),d2
                bpl.s   S3SonicAnim_SelectRollSequenceAt600
                neg.w   d2

S3SonicAnim_SelectRollSequenceAt600:
                lea     (AniSonic03).l,a1
                cmpi.w  #$600,d2
                bhs.s   S3SonicAnim_CalcRollDelay
                lea     (AniSonic02).l,a1

S3SonicAnim_CalcRollDelay:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   S3SonicAnim_ReloadRollDelayAndReadFrame
                moveq   #0,d2

S3SonicAnim_ReloadRollDelayAndReadFrame:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   S3SonicAnim_ReadFrameOrCommand
; ---------------------------------------------------------------------------

S3SonicAnim_TickPushFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   S3SonicAnim_FrameReturn
                move.w  ground_vel(a0),d2
                bmi.s   S3SonicAnim_ClampPushDelay
                neg.w   d2

S3SonicAnim_ClampPushDelay:
                addi.w  #$800,d2
                bpl.s   S3SonicAnim_SelectPushSequenceAndDelay
                moveq   #0,d2

S3SonicAnim_SelectPushSequenceAndDelay:
                lsr.w   #6,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniSonic04).l,a1
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   S3SonicAnim_ReadPushFrame
                lea     (AniSuperSonic04).l,a1

S3SonicAnim_ReadPushFrame:
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   S3SonicAnim_ReadFrameOrCommand
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
                beq.s   S3SonicAnim_DPLCLoadReturn
                move.b  d0,(Player_prev_frame).w
                lea     (PLC_Sonic).l,a2
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   S3SonicAnim_ReadDPLCHeader
                lea     (PLC_SuperSonic).l,a2

S3SonicAnim_ReadDPLCHeader:
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   S3SonicAnim_DPLCLoadReturn
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4

S3SonicAnim_QueueDPLCEntry:
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
                dbf     d5,S3SonicAnim_QueueDPLCEntry

S3SonicAnim_DPLCLoadReturn:
                rts
; End of function Sonic_Load_PLC

; =============== S U B R O U T I N E =======================================

Perform_Player_DPLC:
                tst.b   character_id(a1)
                beq.s   Sonic_Load_PLC2
                bra.w   Tails_Load_PLC2
; End of function Perform_Player_DPLC

; =============== S U B R O U T I N E =======================================
