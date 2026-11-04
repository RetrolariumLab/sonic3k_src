; Owner: objects/players/tails/s3
; Responsibility: Competition Tails animation and pattern loading plus normal and competition tail object rendering
; Source provenance and ranges: config/reconstruction/source_layout.json
Animate_Tails2P:
                lea     (AniTails2P).l,a1

Animate_Tails_Tail2P:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   S3TailsTail_CompDispatchHeader
                move.b  d0,prev_anim(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                bclr    #Status_Push,status(a0)

S3TailsTail_CompDispatchHeader:
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),d0
                bmi.s   S3TailsTail_CompDispatchMovementFF
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3TailsTail_CompFrameReturn
                move.b  d0,anim_frame_timer(a0)
; End of function Animate_Tails2P

; =============== S U B R O U T I N E =======================================

TailsS3StepCompetitionAnimationFrameBytecode:
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #$F0,d0
                bhs.s   S3TailsTail_CompTestRestartFF

S3TailsTail_CompStoreFrameAndAdvance:
                move.b  d0,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)

S3TailsTail_CompFrameReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsTail_CompTestRestartFF:
                addq.b  #1,d0
                bne.s   S3TailsTail_CompTestBacktrackFE
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   S3TailsTail_CompStoreFrameAndAdvance
; ---------------------------------------------------------------------------

S3TailsTail_CompTestBacktrackFE:
                addq.b  #1,d0
                bne.s   S3TailsTail_CompTestChangeFD
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   S3TailsTail_CompStoreFrameAndAdvance
; ---------------------------------------------------------------------------

S3TailsTail_CompTestChangeFD:
                addq.b  #1,d0
                bne.s   S3TailsTail_CompCommandReturn
                move.b  2(a1,d1.w),anim(a0)

S3TailsTail_CompCommandReturn:
                rts
; End of function TailsS3StepCompetitionAnimationFrameBytecode

; ---------------------------------------------------------------------------

S3TailsTail_CompDispatchMovementFF:
                addq.b  #1,d0
                bne.w   S3TailsTail_CompTickRollOrTail
                moveq   #0,d0
                move.b  flip_angle(a0),d0
                bne.w   S3TailsTail_CompSelectTumbleFrame
                moveq   #0,d1
                move.b  angle(a0),d0
                bmi.s   S3TailsTail_CompOrientWalkAngle
                beq.s   S3TailsTail_CompOrientWalkAngle
                subq.b  #1,d0

S3TailsTail_CompOrientWalkAngle:
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3TailsTail_CompChooseWalkFlip
                not.b   d0

S3TailsTail_CompChooseWalkFlip:
                addi.b  #$10,d0
                bpl.s   S3TailsTail_CompApplyFlipAndCheckPush
                moveq   #3,d1

S3TailsTail_CompApplyFlipAndCheckPush:
                andi.b  #$FC,render_flags(a0)
                eor.b   d1,d2
                or.b    d2,render_flags(a0)
                btst    #Status_Push,status(a0)
                bne.w   S3TailsTail_CompTickPushFrames
                lsr.b   #5,d0
                andi.b  #3,d0
                move.w  ground_vel(a0),d2
                bpl.s   S3TailsTail_CompAdjustWalkSpeed
                neg.w   d2

; Double the animation speed magnitude when secondary status is negative
S3TailsTail_CompAdjustWalkSpeed:
                tst.b   status_secondary(a0)
                bpl.w   S3TailsTail_CompSelectWalkOrRunAt600
                add.w   d2,d2

S3TailsTail_CompSelectWalkOrRunAt600:
                move.b  d0,d3
                lea     (AniTails2P01).l,a1
                cmpi.w  #$600,d2
                bhs.s   S3TailsTail_CompReadAngularMoveFrame
                lea     (AniTails2P00).l,a1
                add.b   d0,d0

S3TailsTail_CompReadAngularMoveFrame:
                add.b   d0,d3
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   S3TailsTail_CompStoreMoveFrameAndTick
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0

S3TailsTail_CompStoreMoveFrameAndTick:
                move.b  d0,mapping_frame(a0)
                add.b   d3,mapping_frame(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3TailsTail_CompMovementReturn
                neg.w   d2
                addi.w  #$800,d2
                bpl.s   S3TailsTail_CompReloadMoveDelay
                moveq   #0,d2

S3TailsTail_CompReloadMoveDelay:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)

S3TailsTail_CompMovementReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsTail_CompSelectTumbleFrame:
                move.b  flip_angle(a0),d0
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3TailsTail_CompChooseLeftTumbleFlip
                andi.b  #$FC,render_flags(a0)
                addi.b  #$16,d0
                divu.w  #$2C,d0
                addi.b  #$15,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsTail_CompChooseLeftTumbleFlip:
                andi.b  #$FC,render_flags(a0)
                tst.b   flip_type(a0)
                bpl.s   S3TailsTail_CompMirrorLeftTumble
                ori.b   #1,render_flags(a0)
                addi.b  #$16,d0
                bra.s   S3TailsTail_CompStoreLeftTumbleFrame
; ---------------------------------------------------------------------------

S3TailsTail_CompMirrorLeftTumble:
                ori.b   #3,render_flags(a0)
                neg.b   d0
                addi.b  #$9A,d0

S3TailsTail_CompStoreLeftTumbleFrame:
                divu.w  #$2C,d0
                addi.b  #$15,d0
                move.b  d0,mapping_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3TailsTail_CompTickRollOrTail:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   S3TailsTail_CompFrameReturn
                addq.b  #1,d0
                bne.s   S3TailsTail_CompGetTailAngleFromSpeed
                move.w  ground_vel(a0),d2
                bpl.s   S3TailsTail_CompSelectRollStreamAt600
                neg.w   d2

S3TailsTail_CompSelectRollStreamAt600:
                lea     (AniTails2P03).l,a1
                cmpi.w  #$600,d2
                bhs.s   S3TailsTail_CompCalcRollDelay
                lea     (AniTails2P02).l,a1

S3TailsTail_CompCalcRollDelay:
                neg.w   d2
                addi.w  #$400,d2
                bpl.s   S3TailsTail_CompReloadRollAndRead
                moveq   #0,d2

S3TailsTail_CompReloadRollAndRead:
                lsr.w   #8,d2
                move.b  d2,anim_frame_timer(a0)
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   TailsS3StepCompetitionAnimationFrameBytecode
; ---------------------------------------------------------------------------

S3TailsTail_CompTickPushFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   S3TailsTail_CompFrameReturn
                move.w  ground_vel(a0),d2
                bmi.s   S3TailsTail_CompClampPushDelay
                neg.w   d2

S3TailsTail_CompClampPushDelay:
                addi.w  #$800,d2
                bpl.s   S3TailsTail_CompReloadPushAndRead
                moveq   #0,d2

S3TailsTail_CompReloadPushAndRead:
                lsr.w   #6,d2
                move.b  d2,anim_frame_timer(a0)
                lea     (AniTails2P04).l,a1
                move.b  status(a0),d1
                andi.b  #1,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                bra.w   TailsS3StepCompetitionAnimationFrameBytecode
; ---------------------------------------------------------------------------

S3TailsTail_CompGetTailAngleFromSpeed:
                move.w  x_vel(a2),d1
                move.w  y_vel(a2),d2
                jsr     (GetArcTan).l
                moveq   #0,d1
                move.b  status(a0),d2
                andi.b  #1,d2
                bne.s   S3TailsTail_CompRotateTailForFacing
                not.b   d0
                bra.s   S3TailsTail_CompChooseTailFlip
; ---------------------------------------------------------------------------

S3TailsTail_CompRotateTailForFacing:
                addi.b  #$80,d0

S3TailsTail_CompChooseTailFlip:
                addi.b  #$10,d0
                bpl.s   S3TailsTail_CompStepDirectionalTail
                moveq   #3,d1

; Advance the mapping by three frames per angle sector
S3TailsTail_CompStepDirectionalTail:
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
                bmi.s   S3TailsTail_CompDPLCLoadReturn
                move.l  #ArtUnc_Tails2P_Tail,d6
                move.w  #tiles_to_bytes(ArtTile_Player_2_Tail),d4
                cmpa.w  #Tails_tails,a0
                beq.s   S3TailsTail_CompQueueUncachedDPLC
                move.w  #tiles_to_bytes(ArtTile_Player_1+$10),d4
                bra.s   S3TailsTail_CompQueueUncachedDPLC
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
                bmi.s   S3TailsTail_CompDPLCLoadReturn
                move.l  #ArtUnc_Tails2P,d6
                move.w  #tiles_to_bytes(ArtTile_Player_1),d4
                cmpa.w  #Player_1,a0
                beq.s   S3TailsTail_CompQueueUncachedDPLC
                move.w  #tiles_to_bytes(ArtTile_Player_2),d4

S3TailsTail_CompQueueUncachedDPLC:
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
                dbf     d5,S3TailsTail_CompQueueUncachedDPLC

S3TailsTail_CompDPLCLoadReturn:
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
                bpl.s   S3TailsTail_ChooseNormalParentAnim
                ori.w   #high_priority,art_tile(a0)

S3TailsTail_ChooseNormalParentAnim:
                moveq   #0,d0
                move.b  anim(a2),d0
                btst    #Status_Push,status(a2)
                beq.s   S3TailsTail_RemapChangedNormalAnim
                tst.b   (WindTunnel_flag_P2).w
                bne.s   S3TailsTail_RemapChangedNormalAnim
                moveq   #4,d0

S3TailsTail_RemapChangedNormalAnim:
                cmp.b   objoff_34(a0),d0                ; Has the input parent anim changed since last check?
                beq.s   S3TailsTail_AnimateAndDrawNormalTail  ; If not, branch and skip setting a matching Tails' Tails anim
                move.b  d0,objoff_34(a0)                ; Store d0 for the above comparison
                move.b  Obj_Tails_Tail_AniSelection(pc,d0.w),anim(a0)  ; Load anim relative to parent's

S3TailsTail_AnimateAndDrawNormalTail:
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
                beq.s   S3TailsTail_InitCompTail
                move.w  #make_art_tile(ArtTile_Player_1+$10,0,0),art_tile(a0)

S3TailsTail_InitCompTail:
                move.w  #$100,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.l  #S3TailsTail_FollowCompParent,(a0)

S3TailsTail_FollowCompParent:
                movea.w $30(a0),a2
                move.b  angle(a2),angle(a0)
                move.b  status(a2),status(a0)
                move.w  x_pos(a2),x_pos(a0)
                move.w  y_pos(a2),y_pos(a0)
                move.w  priority(a2),priority(a0)
                andi.w  #drawing_mask,art_tile(a0)
                tst.w   art_tile(a2)
                bpl.s   S3TailsTail_CheckCompPushOverride
                ori.w   #high_priority,art_tile(a0)

S3TailsTail_CheckCompPushOverride:
                moveq   #0,d0
                move.b  anim(a2),d0
                btst    #Status_Push,status(a2)
                beq.s   S3TailsTail_RemapChangedCompAnim
                cmpi.b  #5,d0
                beq.s   S3TailsTail_RemapChangedCompAnim
                moveq   #4,d0

S3TailsTail_RemapChangedCompAnim:
                cmp.b   $34(a0),d0
                beq.s   S3TailsTail_AnimateAndDrawCompTail
                move.b  d0,$34(a0)
                move.b  S3TailsTail_CompParentToTailAnim(pc,d0.w),anim(a0)

S3TailsTail_AnimateAndDrawCompTail:
                lea     (AniTails2P_Tail).l,a1
                bsr.w   Animate_Tails_Tail2P
                bsr.w   Tails2P_Tail_Load_PLC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
S3TailsTail_CompParentToTailAnim:
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
