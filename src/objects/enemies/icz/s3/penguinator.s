; Owner: objects/enemies/icz/s3
; Responsibility: Penguinator sliding or attack states, snowdust effect actors and private pattern resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Penguinator:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Penguinator_Index(pc,d0.w),d1
                jsr     Penguinator_Index(pc,d1.w)
                lea     DPLCPtr_Penguinator(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Sprite_CheckDeleteTouchSlotted(pc)
; ---------------------------------------------------------------------------
Penguinator_Index:
                dc.w    S3Penguinator_InitSlotAndArtFlip-Penguinator_Index
                dc.w    S3Penguinator_AnimateAndCheckAccel-Penguinator_Index
                dc.w    S3Penguinator_AnimateSlideTransition-Penguinator_Index
                dc.w    S3Penguinator_FallAndCheckFloor-Penguinator_Index
                dc.w    S3Penguinator_UpdateGroundSlide-Penguinator_Index
                dc.w    S3Penguinator_UpdateSlideRecovery-Penguinator_Index
                dc.w    S3Penguinator_BrakeAndFollowFloor-Penguinator_Index
                dc.w    S3Penguinator_TickWait-Penguinator_Index
; ---------------------------------------------------------------------------

S3Penguinator_InitSlotAndArtFlip:
                lea     ObjSlot_Penguinator(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                bclr    #1,render_flags(a0)
                beq.s   S3Penguinator_BeginAcceleration
                bset    #7,art_tile(a0)

S3Penguinator_BeginAcceleration:
                move.b  #2,routine(a0)
                move.b  #$F,y_radius(a0)
                move.b  #4,x_radius(a0)
                bclr    #5,$38(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                clr.w   $2E(a0)
                move.l  #S3Penguinator_AccelerationAnim,$30(a0)
                move.l  #S3Penguinator_ReverseMotionAndFacing,$34(a0)
                moveq   #2,d0
                btst    #0,render_flags(a0)
                bne.s   S3Penguinator_SetHorizontalAccel
                neg.w   d0

S3Penguinator_SetHorizontalAccel:
                move.w  d0,$40(a0)
                rts
; ---------------------------------------------------------------------------

S3Penguinator_AnimateAndCheckAccel:
                jsr     Animate_RawGetFaster(pc)
                beq.s   S3Penguinator_AccelerateAndProbeFloor
                cmpi.b  #2,$2E(a0)
                bls.s   S3Penguinator_ChooseSlideOrTurn

S3Penguinator_AccelerateAndProbeFloor:
                move.w  $40(a0),d0
                move.w  x_vel(a0),d1
                add.w   d0,d1
                move.w  d1,x_vel(a0)
                jsr     (MoveSprite2).l
                jmp     ObjHitFloor2_DoRoutine(pc)
; ---------------------------------------------------------------------------

S3Penguinator_ChooseSlideOrTurn:
                jsr     (ObjCheckFloorDist).l
                tst.b   d3
                beq.s   S3Penguinator_BeginSlideTransition
                btst    #0,render_flags(a0)
                beq.s   S3Penguinator_CheckFacingSlope
                bchg    #6,d3

S3Penguinator_CheckFacingSlope:
                btst    #6,d3
                beq.s   S3Penguinator_BeginTurnWait

S3Penguinator_BeginSlideTransition:
                move.b  #4,routine(a0)
                move.w  #-$200,d0
                move.w  #$40,d1
                btst    #0,render_flags(a0)
                beq.s   S3Penguinator_SetSlideMotionAndAnim
                neg.w   d0
                neg.w   d1

S3Penguinator_SetSlideMotionAndAnim:
                move.w  d0,x_vel(a0)
                move.w  d1,$40(a0)
                move.l  #S3Penguinator_SlideTransitionAnim,$30(a0)
                move.l  #S3Penguinator_BeginSlideFall,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Penguinator_BeginTurnWait:
                move.b  #$E,routine(a0)
                move.w  #$40,$2E(a0)
                move.l  #S3Penguinator_BeginSlideTransition,$34(a0)

S3Penguinator_ReverseMotionAndFacing:
                neg.w   x_vel(a0)
                neg.w   $40(a0)
                bchg    #0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

S3Penguinator_AnimateSlideTransition:
                jmp     Move_AnimateRaw(pc)
; ---------------------------------------------------------------------------

S3Penguinator_BeginSlideFall:
                move.b  #6,routine(a0)
                move.b  #$B,y_radius(a0)
                move.l  #S3Penguinator_CalcAbsLandingAngle,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Penguinator_FallAndCheckFloor:
                jsr     MoveSprite_LightGravity(pc)
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

S3Penguinator_CalcAbsLandingAngle:
                tst.b   d3
                move.b  d3,d4
                bpl.s   S3Penguinator_CheckLandingSlope
                neg.b   d4

S3Penguinator_CheckLandingSlope:
                andi.b  #$F8,d4
                beq.s   S3Penguinator_BeginGroundSlide
                tst.w   x_vel(a0)
                bmi.s   S3Penguinator_TryReverseOnLanding
                bchg    #6,d3

S3Penguinator_TryReverseOnLanding:
                btst    #6,d3
                bne.s   S3Penguinator_BeginGroundSlide
                neg.w   x_vel(a0)
                neg.w   $40(a0)
                bchg    #0,render_flags(a0)

S3Penguinator_BeginGroundSlide:
                move.b  #8,routine(a0)
                move.w  #$20,$2E(a0)
                move.l  #S3Penguinator_BeginSlideRecovery,$34(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3Penguinator_UpdateGroundSlide:
                bsr.w   Penguinator_ProbeFloorAhead
                cmpi.w  #-2,d1
                blt.w   S3Penguinator_ReverseMotionAndFacing
                cmpi.w  #$C,d1
                bge.s   S3Penguinator_BeginSlideFall
                add.w   d1,y_pos(a0)
                bsr.w   SetPenguinatorSlidingPoseFromFloorAngle
                bsr.w   Penguinator_TrySkidSoundAndDust
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

; Enter the recovery animation at cursor 8 minus the current slope frame
S3Penguinator_BeginSlideRecovery:
                move.b  #$A,routine(a0)
                moveq   #8,d0
                sub.b   mapping_frame(a0),d0
                move.b  d0,anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #S3Penguinator_SlideRecoveryAnim,$30(a0)
                move.l  #S3Penguinator_BeginUprightBrake,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Penguinator_UpdateSlideRecovery:
                bsr.w   Penguinator_ProbeFloorAhead
                cmpi.w  #-2,d1
                blt.w   S3Penguinator_ReverseMotionAndFacing
                cmpi.w  #$C,d1
                bge.w   S3Penguinator_BeginSlideFall
                add.w   d1,y_pos(a0)
                jsr     (MoveSprite2).l
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

S3Penguinator_BeginUprightBrake:
                move.b  #$C,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.b  #$F,y_radius(a0)
                subq.w  #4,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3Penguinator_BrakeAndFollowFloor:
                move.w  x_vel(a0),d0
                add.w   $40(a0),d0
                move.w  d0,x_vel(a0)
                beq.s   S3Penguinator_BeginRestartWait
                bsr.w   Penguinator_ProbeFloorAhead
                cmpi.w  #-2,d1
                blt.s   S3Penguinator_BeginRestartWait
                cmpi.w  #$C,d1
                bge.s   S3Penguinator_BeginRestartWait
                add.w   d1,y_pos(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3Penguinator_BeginRestartWait:
                move.b  #$E,routine(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$2E(a0)
                move.l  #S3Penguinator_BeginAcceleration,$34(a0)
                bchg    #0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

S3Penguinator_TickWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_ICZSnowdust:
                lea     ObjDat_ICZSnowdust(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                beq.s   S3Penguinator_BeginSnowdustAnim
                move.l  #Obj_Wait,(a0)
                lsl.w   #2,d0
                subq.w  #1,d0
                move.w  d0,$2E(a0)
                move.l  #S3Penguinator_BeginSnowdustAnim,$34(a0)

S3Penguinator_SnowdustReturn:
                rts
; ---------------------------------------------------------------------------

S3Penguinator_BeginSnowdustAnim:
                move.l  #S3Penguinator_AnimateAndDrawSnowdust,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

S3Penguinator_AnimateAndDrawSnowdust:
                lea     S3Penguinator_SnowdustAnim(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

Penguinator_ProbeFloorAhead:
                move.w  x_vel(a0),d3
                ext.l   d3
                lsl.l   #8,d3
                add.l   x_pos(a0),d3
                swap    d3
                jmp     (ObjCheckFloorDist2).l
; End of function Penguinator_ProbeFloorAhead

; =============== S U B R O U T I N E =======================================

SetPenguinatorSlidingPoseFromFloorAngle:
                moveq   #4,d0
                tst.b   d3
                beq.s   S3Penguinator_SetSlopeSlideFrame
                lsr.b   #3,d3
                andi.w  #$F,d3
                move.b  S3Penguinator_SlopeSlideFrames(pc,d3.w),d0

S3Penguinator_SetSlopeSlideFrame:
                move.b  d0,mapping_frame(a0)
                rts
; End of function SetPenguinatorSlidingPoseFromFloorAngle

; ---------------------------------------------------------------------------
S3Penguinator_SlopeSlideFrames:
                dc.b    4,  5,  6,  6,  7,  7,  8,  8,  8,  8,  7,  7,  6,  6,  5,  4
                even

; =============== S U B R O U T I N E =======================================

; Play the sound and try one attached snowdust actor when the slide countdown is divisible by four
Penguinator_TrySkidSoundAndDust:
                move.w  $2E(a0),d0
                andi.w  #3,d0
                bne.s   S3Penguinator_SnowdustReturn
                moveq   #signextendB(sfx_SlideSkidQuiet),d0
                jsr     (Play_SFX).l
                lea     S3Penguinator_SnowdustChild(pc),a2
                jmp     CreateChild1_Normal(pc)
; End of function Penguinator_TrySkidSoundAndDust

; ---------------------------------------------------------------------------
ObjSlot_Penguinator:
                dc.w    4-1
                dc.w    make_art_tile(ArtTile_Penguinator,1,0)
                dc.w    $12,     0
                dc.l    Map_Penguinator
                dc.w    $280
                dc.b    $14, $10,   0, $1A
ObjDat_ICZSnowdust:
                dc.l    Map_ICZSnowdust
                dc.w    make_art_tile(ArtTile_ICZSnowdust,1,0)
                dc.w    0
                dc.b    4, $18,   0,   0
S3Penguinator_SnowdustChild:
                dc.w    1-1
                dc.l    Obj_ICZSnowdust
                dc.b    0,  $C
DPLCPtr_Penguinator:
                dc.l    ArtUnc_Penguinator
                dc.l    DPLC_Penguinator
S3Penguinator_AccelerationAnim:
                dc.b    7, $10
                dc.b    0,   1
                dc.b    0,   2
                dc.b    $FC
S3Penguinator_SlideTransitionAnim:
                dc.b    3,   3,   3,   4, $F4
S3Penguinator_SlideRecoveryAnim:
                dc.b    3,   8,   8,   7,   6,   5,   4,   3, $F4
S3Penguinator_SnowdustAnim:
                dc.b    0,   0,   0,   1,   2,   3,   4,   5,   4,   3,   2,   1,   0, $F4
                even
