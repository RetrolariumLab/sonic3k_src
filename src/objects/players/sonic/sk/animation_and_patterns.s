; Owner: objects/players/sonic/sk
; Responsibility: Sonic animation selection, dynamic pattern loading and the common player DPLC dispatch interface
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Sonic:
                lea     (AniSonic).l,a1
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKSonicAnim_ResetOnAnimChange
                lea     (AniSuperSonic).l,a1

SKSonicAnim_ResetOnAnimChange:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   SKSonicAnim_DispatchHeader
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

SKSonicAnim_DispatchHeader:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   SKSonicAnim_DispatchMovementHeaderFF
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKSonicAnim_FrameReturn
                move.b  d0,anim_frame_timer(a0)

SKSonicAnim_ReadFrameOrCommand:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$FC,d0
                bhs.s   SKSonicAnim_TestRestartFF

SKSonicAnim_StoreFrameAndAdvance:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

SKSonicAnim_FrameReturn:
                rts
; ---------------------------------------------------------------------------

SKSonicAnim_TestRestartFF:
                addq.b  #1,d0
                bne.s   SKSonicAnim_TestBacktrackFE
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   SKSonicAnim_StoreFrameAndAdvance
; ---------------------------------------------------------------------------

SKSonicAnim_TestBacktrackFE:
                addq.b  #1,d0
                bne.s   SKSonicAnim_TestChangeFD
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   SKSonicAnim_StoreFrameAndAdvance
; ---------------------------------------------------------------------------

SKSonicAnim_TestChangeFD:
                addq.b  #1,d0
                bne.s   SKSonicAnim_CommandReturn
                move.b  2(a1,d1.w),anim(a0)

SKSonicAnim_CommandReturn:
                rts
; ---------------------------------------------------------------------------

; Header $FF selects walking or tumble. Other negative headers select roll cadence
SKSonicAnim_DispatchMovementHeaderFF:
                addq.b  #1,d0
                bne.w   SKSonicAnim_TickRollFrames
                moveq   #0,d0
                tst.b   flip_type(a0)
                bmi.w   Anim_Tumble
                move.b  flip_angle(a0),d0
                bne.w   Anim_Tumble
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   SKSonicAnim_OrientWalkAngle
                beq.s   SKSonicAnim_OrientWalkAngle
                subq.b  #1,d0

SKSonicAnim_OrientWalkAngle:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKSonicAnim_ChooseWalkFlip
                not.b   d0

SKSonicAnim_ChooseWalkFlip:
                addi.b  #$10,d0
                bpl.s   SKSonicAnim_ApplyWalkFlipAndCheckPush
                moveq   #3,d1

SKSonicAnim_ApplyWalkFlipAndCheckPush:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   SKSonicAnim_TickPushFrames
                lsr.b   #4,d0
                andi.b  #6,d0
                move.w  ground_vel(a0),d2
                bpl.s   SKSonicAnim_AdjustWalkSpeed
                neg.w   d2

; Double the animation speed magnitude when secondary status is negative
SKSonicAnim_AdjustWalkSpeed:
                tst.b   status_secondary(a0)
                bpl.w   SKSonicAnim_SelectWalkOrRunAt600
                add.w   d2,d2

SKSonicAnim_SelectWalkOrRunAt600:
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   SKSonicAnim_SelectSuperWalkOrRunAt800
                lea     (AniSonic01).l,a1
                cmpi.w  #$600,d2
                bhs.s   SKSonicAnim_ReadNormalMoveFrame
                lea     (AniSonic00).l,a1
                add.b   d0,d0

SKSonicAnim_ReadNormalMoveFrame:
                add.b   d0,d0
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   SKSonicAnim_StoreNormalMoveFrameAndTick
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

SKSonicAnim_StoreNormalMoveFrameAndTick:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKSonicAnim_NormalMoveReturn
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   SKSonicAnim_ReloadNormalMoveDelay
                moveq   #0,d2

SKSonicAnim_ReloadNormalMoveDelay:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

SKSonicAnim_NormalMoveReturn:
                rts
; ---------------------------------------------------------------------------

SKSonicAnim_SelectSuperWalkOrRunAt800:
                lea     (AniSuperSonic01).l,a1
                cmpi.w  #$800,d2
                bhs.s   SKSonicAnim_DoubleSuperRunSectorOffset
                lea     (AniSuperSonic00).l,a1
                add.b   d0,d0
                add.b   d0,d0
                bra.s   SKSonicAnim_ReadOrLoopSuperMoveFrame
; ---------------------------------------------------------------------------

SKSonicAnim_DoubleSuperRunSectorOffset:
                add.b   d0,d0

SKSonicAnim_ReadOrLoopSuperMoveFrame:
                move.b  d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   SKSonicAnim_StoreSuperMoveFrameAndTick
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

SKSonicAnim_StoreSuperMoveFrameAndTick:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKSonicAnim_SuperMoveReturn
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   SKSonicAnim_ReloadSuperMoveDelay
                moveq   #0,d2

SKSonicAnim_ReloadSuperMoveDelay:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

SKSonicAnim_SuperMoveReturn:
                rts
; ---------------------------------------------------------------------------

; loc_127C0:
Anim_Tumble:
                move.b  flip_type(a0),d1
                andi.w  #$7F,d1
                bne.w   SKSonicAnim_ReadTumbleBaseAndTestType1
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   Anim_TumbleLeft
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   SKSonicAnim_BiasRightTumble0Phase
                cmpi.b  #$B,(Current_zone).w            ; is this DEZ?
                beq.s   SKSonicAnim_StoreRightTumble0Frame  ; if so, branch
                cmpi.b  #4,(Current_zone).w             ; is this FBZ?
                beq.s   SKSonicAnim_StoreRightTumble0Frame  ; if so, branch
                ori.b   #2,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                bra.s   SKSonicAnim_StoreRightTumble0Frame
; ---------------------------------------------------------------------------

SKSonicAnim_BiasRightTumble0Phase:
                addi.b  #$B,d0

SKSonicAnim_StoreRightTumble0Frame:
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
                bpl.s   SKSonicAnim_MirrorLeftTumble0XY
                cmpi.b  #4,(Current_zone).w             ; is this FBZ?
                beq.s   SKSonicAnim_BiasSpecialLeftTumble0  ; if so, branch
                cmpi.b  #$B,(Current_zone).w            ; is this DEZ?
                beq.s   SKSonicAnim_BiasSpecialLeftTumble0  ; if so, branch
                cmpi.b  #7,(Current_zone).w             ; is this MHZ?
                bne.s   SKSonicAnim_MirrorLeftTumble0XY  ; if not, branch

; A negative flip type in FBZ, DEZ or MHZ uses X flip and the $B phase bias
SKSonicAnim_BiasSpecialLeftTumble0:
                ori.b   #1,render_flags(a0)
                addi.b  #$B,d0
                bra.s   SKSonicAnim_StoreLeftTumble0Frame
; ---------------------------------------------------------------------------

SKSonicAnim_MirrorLeftTumble0XY:
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0

SKSonicAnim_StoreLeftTumble0Frame:
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------
SKSonicAnim_TumbleFrameBases:
                dc.b    0, $3D, $49, $49
                even
; ---------------------------------------------------------------------------

SKSonicAnim_ReadTumbleBaseAndTestType1:
                move.b  SKSonicAnim_TumbleFrameBases(pc,d1.w),d3
                cmpi.b  #1,d1
                bne.s   SKSonicAnim_TestTumbleType2
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKSonicAnim_StoreLeftTumble1Frame
                andi.b  #$FC,render_flags(a0)
                addi.b  #-8,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicAnim_StoreLeftTumble1Frame:
                andi.b  #$FC,render_flags(a0)
                ori.b   #1,render_flags(a0)
                addi.b  #-8,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicAnim_TestTumbleType2:
                cmpi.b  #2,d1
                bne.s   SKSonicAnim_DispatchTumbleType3
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKSonicAnim_StoreLeftTumble2Frame
                andi.b  #$FC,render_flags(a0)
                addi.b  #$B,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicAnim_StoreLeftTumble2Frame:
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

SKSonicAnim_DispatchTumbleType3:
                cmpi.b  #3,d1
                bne.s   SKSonicAnim_TestTumbleType4
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKSonicAnim_StoreLeftTumble3Frame
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

SKSonicAnim_StoreLeftTumble3Frame:
                andi.b  #$FC,render_flags(a0)
                ori.b   #1,render_flags(a0)
                addi.b  #$B,d0
                divu.w  #$16,d0
                add.b   d3,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicAnim_TestTumbleType4:
                cmpi.b  #4,d1
                bne.s   SKSonicAnim_OrientHigherTumbleTypes
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   SKSonicAnim_SelectLeftTumble4Mirror
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   SKSonicAnim_BiasRightTumble4Phase
                addi.b  #$B,d0
                bra.s   SKSonicAnim_StoreRightTumble4Frame
; ---------------------------------------------------------------------------

SKSonicAnim_BiasRightTumble4Phase:
                addi.b  #$B,d0

SKSonicAnim_StoreRightTumble4Frame:
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicAnim_SelectLeftTumble4Mirror:
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   SKSonicAnim_MirrorLeftTumble4XY
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0
                bra.s   SKSonicAnim_StoreLeftTumble4Frame
; ---------------------------------------------------------------------------

SKSonicAnim_MirrorLeftTumble4XY:
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$8F,d0

SKSonicAnim_StoreLeftTumble4Frame:
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicAnim_OrientHigherTumbleTypes:
                move.b  flip_angle(a0),d0
                andi.b  #$FC,render_flags(a0)
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                beq.s   SKSonicAnim_StoreHigherTumbleFrame
                ori.b   #1,render_flags(a0)

SKSonicAnim_StoreHigherTumbleFrame:
                addi.b  #$B,d0
                divu.w  #$16,d0
                addi.b  #$31,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKSonicAnim_TickRollFrames:
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKSonicAnim_FrameReturn
                move.w  ground_vel(a0),d2
                bpl.s   SKSonicAnim_SelectRollSequenceAt600
                neg.w   d2

SKSonicAnim_SelectRollSequenceAt600:
                lea     (AniSonic03).l,a1
                cmpi.w  #$600,d2
                bhs.s   SKSonicAnim_CalcRollDelay
                lea     (AniSonic02).l,a1

SKSonicAnim_CalcRollDelay:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   SKSonicAnim_ReloadRollDelayAndReadFrame
                moveq   #0,d2

SKSonicAnim_ReloadRollDelayAndReadFrame:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                bra.w   SKSonicAnim_ReadFrameOrCommand
; ---------------------------------------------------------------------------

SKSonicAnim_TickPushFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKSonicAnim_FrameReturn
                move.w  ground_vel(a0),d2
                bmi.s   SKSonicAnim_ClampPushDelay
                neg.w   d2

SKSonicAnim_ClampPushDelay:
                addi.w  #$800,d2
                bpl.s   SKSonicAnim_SelectPushSequenceAndDelay
                moveq   #0,d2

SKSonicAnim_SelectPushSequenceAndDelay:
                lsr.w   #6,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniSonic04).l,a1
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKSonicAnim_ReadPushFrame
                lea     (AniSuperSonic04).l,a1

SKSonicAnim_ReadPushFrame:
                bra.w   SKSonicAnim_ReadFrameOrCommand
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
                beq.s   SKSonicAnim_DPLCLoadReturn
                move.b  d0,(Player_prev_frame).w
                lea     (PLC_Sonic).l,a2
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKSonicAnim_ReadDPLCHeaderAndPickArtBank
                lea     (PLC_SuperSonic).l,a2

; Frame $DA and later use the extra Sonic art bank
SKSonicAnim_ReadDPLCHeaderAndPickArtBank:
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   SKSonicAnim_DPLCLoadReturn
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4
                move.l  #ArtUnc_Sonic,d6
                cmpi.w  #2*$DA,d0
                blo.s   SKSonicAnim_QueueDPLCEntry
                move.l  #ArtUnc_Sonic_Extra,d6

SKSonicAnim_QueueDPLCEntry:
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
                dbf     d5,SKSonicAnim_QueueDPLCEntry

SKSonicAnim_DPLCLoadReturn:
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
