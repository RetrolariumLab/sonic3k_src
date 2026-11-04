; Owner: objects/bosses/hcz/miniboss/sk
; Responsibility: Hydrocity miniboss motion, acceleration, child positioning, collision and animation helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

AccelerateHCZVortexActorTowardCenterX:
                move.w  x_pos(a0),d0
                move.w  x_vel(a0),d1
                move.w  #$100,d2
                cmp.w   $3A(a0),d0
                scs     d3
                bcs.s   HCZMiniSK_AccelerateXAcrossCenter
                neg.w   d2

; Apply the acceleration twice when the subject crosses the center
HCZMiniSK_AccelerateXAcrossCenter:
                add.w   d2,d1
                cmp.b   $3C(a0),d3
                beq.s   HCZMiniSK_StoreCenteringXSpeed
                move.b  d3,$3C(a0)
                add.w   d2,d1

HCZMiniSK_StoreCenteringXSpeed:
                move.w  d1,x_vel(a0)
                rts
; End of function AccelerateHCZVortexActorTowardCenterX

; =============== S U B R O U T I N E =======================================

SetHCZVortexLaunchVelocityFromOffset:
                add.w   d0,d0
                smi     d2
                bpl.s   HCZMiniSK_ClampLaunchMagnitude
                neg.w   d0

HCZMiniSK_ClampLaunchMagnitude:
                move.w  #$100,d3
                sub.w   d0,d3
                bpl.s   HCZMiniSK_ScaleAndSignLaunchX
                moveq   #0,d3

HCZMiniSK_ScaleAndSignLaunchX:
                lsl.w   #4,d3
                tst.b   d2
                beq.s   HCZMiniSK_StoreLaunchXSpeed
                neg.w   d3

HCZMiniSK_StoreLaunchXSpeed:
                move.w  d3,x_vel(a0)
                rts
; End of function SetHCZVortexLaunchVelocityFromOffset

; =============== S U B R O U T I N E =======================================

SwitchHCZVortexToParentDefeatState:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.w   HCZMiniSK_SharedReturn
                move.l  #HCZMiniSK_VortexWaitThenBreakUp,(a0)
                clr.b   collision_flags(a0)
                bclr    #3,$38(a0)
                beq.w   HCZMiniSK_SharedReturn
                bra.w   HCZMiniSK_VortexReleaseP1ThenP2

HCZMiniSK_VortexReleaseP1ThenP2:
                move.w  $42(a0),d0
                beq.s   HCZMiniSK_VortexReleaseP2
                bsr.w   ReleaseHCZVortexControlledPlayer

HCZMiniSK_VortexReleaseP2:
                move.w  $44(a0),d0
                beq.s   HCZMiniSK_VortexReleaseReturn
; End of function SwitchHCZVortexToParentDefeatState

; =============== S U B R O U T I N E =======================================

ReleaseHCZVortexControlledPlayer:
                movea.w d0,a2
                bset    #Status_InAir,status(a2)
                clr.b   object_control(a2)
                move.w  #$100,priority(a2)

HCZMiniSK_VortexReleaseReturn:
                rts
; End of function ReleaseHCZVortexControlledPlayer

; =============== S U B R O U T I N E =======================================

MoveHCZVortexParticleAroundParent:
                movea.l a0,a1
                movea.l a0,a2
                movea.l a3,a0
                bsr.w   ApplyHCZVortexOrbitToSubject
                movea.l a1,a0
                rts
; End of function MoveHCZVortexParticleAroundParent

; =============== S U B R O U T I N E =======================================

CapturePlayersInHCZMinibossVortex:
                clr.l   $42(a0)
                move.w  y_pos(a0),d0
                subi.w  #$20,d0
                lea     (Player_1).w,a2
                cmp.w   y_pos(a2),d0
                bhi.s   HCZMiniSK_VortexCheckP2Capture
                move.w  a2,$42(a0)
                bsr.w   ApplyHCZVortexOrbitToSubject
                tst.b   object_control(a2)
                bne.s   HCZMiniSK_VortexCheckP2Capture
                bsr.w   InitializeHCZVortexPlayerControl

; Compare player two against the value already in D0 after processing player one
HCZMiniSK_VortexCheckP2Capture:
                lea     (Player_2).w,a2
                cmp.w   y_pos(a2),d0
                bhi.s   HCZMiniSK_VortexCaptureReturn
                cmpi.b  #6,routine(a2)
                bhs.s   HCZMiniSK_VortexCaptureReturn
                move.w  a2,$44(a0)
                bsr.w   ApplyHCZVortexOrbitToSubject
                tst.b   object_control(a2)
                bne.s   HCZMiniSK_VortexCaptureReturn
; End of function CapturePlayersInHCZMinibossVortex

; =============== S U B R O U T I N E =======================================

InitializeHCZVortexPlayerControl:
                bset    #Status_InAir,status(a2)
                move.b  #1,object_control(a2)
                move.b  #$F,anim(a2)
                clr.b   spin_dash_flag(a2)
                clr.w   x_vel(a2)
                clr.w   y_vel(a2)
                clr.w   ground_vel(a2)

HCZMiniSK_VortexCaptureReturn:
                rts
; End of function InitializeHCZVortexPlayerControl

; ---------------------------------------------------------------------------
; unused
                dc.w    Player_1
                dc.w    0
                dc.w    Player_2
                dc.w    0
                dc.w    Player_2
                dc.w    Player_2

; =============== S U B R O U T I N E =======================================

ApplyHCZVortexOrbitToSubject:
                move.w  x_pos(a2),d0
                move.w  x_vel(a2),d1
                move.w  #$40,d2
                sub.w   x_pos(a0),d0
                scs     d3
                bcc.s   HCZMiniSK_OrbitChooseXAcceleration
                neg.w   d0

HCZMiniSK_OrbitChooseXAcceleration:
                cmpi.w  #3,d0
                bhi.s   HCZMiniSK_OrbitResetSpeedOutsideRadius
                tst.w   d1
                bpl.s   HCZMiniSK_OrbitSetXSpeedAndDepth
                bra.w   HCZMiniSK_OrbitNegateXAcceleration
; ---------------------------------------------------------------------------

HCZMiniSK_OrbitResetSpeedOutsideRadius:
                cmpi.w  #$70,d0
                bls.s   HCZMiniSK_OrbitChooseSideAcceleration
                moveq   #0,d1

HCZMiniSK_OrbitChooseSideAcceleration:
                tst.b   d3
                bne.s   HCZMiniSK_OrbitSetXSpeedAndDepth

HCZMiniSK_OrbitNegateXAcceleration:
                neg.w   d2

HCZMiniSK_OrbitSetXSpeedAndDepth:
                add.w   d2,d1
                move.w  #$100,priority(a2)
                move.w  d1,x_vel(a2)
                bpl.s   HCZMiniSK_OrbitMoveXAndCheckY
                move.w  #$300,priority(a2)

HCZMiniSK_OrbitMoveXAndCheckY:
                ext.l   d1
                lsl.l   #8,d1
                add.l   d1,x_pos(a2)
                move.l  #$8000,d4
                move.w  y_pos(a2),d5
                sub.w   y_pos(a0),d5
                cmpi.w  #-$10,d5
                blt.s   HCZMiniSK_OrbitApplyHalfPixelYStep
                cmpi.w  #$10,d5
                ble.s   HCZMiniSK_OrbitUpdateReturn
                neg.l   d4

HCZMiniSK_OrbitApplyHalfPixelYStep:
                add.l   d4,y_pos(a2)

HCZMiniSK_OrbitUpdateReturn:
                rts
; End of function ApplyHCZVortexOrbitToSubject

; =============== S U B R O U T I N E =======================================

TriggerHCZBossSplashIfSubmerged:
                btst    #7,$38(a0)
                bne.w   HCZMiniSK_SharedReturn
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.w   HCZMiniSK_SharedReturn
; End of function TriggerHCZBossSplashIfSubmerged

; =============== S U B R O U T I N E =======================================

CreateHCZBossSurfaceSplash:
                bset    #7,$38(a0)
                moveq   #signextendB(sfx_Splash),d0
                jsr     (Play_SFX).l
                clr.w   (Slotted_object_bits).w
                lea     HCZMiniSK_SurfaceSplashChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; End of function CreateHCZBossSurfaceSplash

; =============== S U B R O U T I N E =======================================

SelectHCZBossDiveLaneAndRepeatCount:
                move.b  $3A(a0),d0
                addq.b  #2,$3A(a0)
                andi.w  #$E,d0
                lea     HCZMiniSK_DiveLaneAndRepeatPairs(pc,d0.w),a1
                move.b  (a1)+,d0
                bne.s   HCZMiniSK_DiveLaneChooseSweepDirection
                move.w  #$100,d0

HCZMiniSK_DiveLaneChooseSweepDirection:
                move.w  #$400,d2
                cmpi.w  #$A0,d0
                blo.s   HCZMiniSK_DiveLaneApplyPositionAndCount
                neg.w   d2

HCZMiniSK_DiveLaneApplyPositionAndCount:
                move.w  d2,$40(a0)
                move.w  (Camera_X_pos).w,d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.b  (a1)+,$39(a0)
                rts
; End of function SelectHCZBossDiveLaneAndRepeatCount

; ---------------------------------------------------------------------------
HCZMiniSK_DiveLaneAndRepeatPairs:
                dc.b    $40,   1
                dc.b    0,   1
                dc.b    $40,   0
                dc.b    $40,   1
                dc.b    0,   0
                dc.b    0,   1
                dc.b    $40,   0
                dc.b    0,   0
                even

; =============== S U B R O U T I N E =======================================

UpdateHCZMinibossRocketTwistPose:
                move.b  $40(a0),d2
                add.b   d2,$3C(a0)
                bsr.w   PositionHCZMinibossRocketTwistX
                add.b   d2,$3D(a0)
                bsr.w   PositionHCZMinibossRocketTwistY
                moveq   #0,d0
                move.b  $3D(a0),d0
                lsr.w   #4,d0
                move.b  HCZMiniSK_RocketTwistFrames(pc,d0.w),mapping_frame(a0)
                move.w  #$200,priority(a0)
                cmpi.b  #8,d0
                blo.s   HCZMiniSK_RocketTwistPoseReturn
                move.w  #$280,priority(a0)

HCZMiniSK_RocketTwistPoseReturn:
                rts
; End of function UpdateHCZMinibossRocketTwistPose

; ---------------------------------------------------------------------------
HCZMiniSK_RocketTwistFrames:
                dc.b    1
                dc.b    2
                dc.b    3
                dc.b    4
                dc.b    5
                dc.b    6
                dc.b    7
                dc.b    8
                dc.b    9
                dc.b    $A
                dc.b    $B
                dc.b    $1A
                dc.b    $1A
                dc.b    $1A
                dc.b    $C
                dc.b    $D
                even

; =============== S U B R O U T I N E =======================================

PositionHCZMinibossRocketTwistX:
                moveq   #0,d0
                move.b  $3C(a0),d0
                bsr.w   LookupHCZMinibossRocketTwistOffset
                move.w  x_pos(a2),d0
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                rts
; End of function PositionHCZMinibossRocketTwistX

; =============== S U B R O U T I N E =======================================

LookupHCZMinibossRocketTwistOffset:
                cmpi.b  #$80,d0
                blo.s   HCZMiniSK_RocketTwistLoadFacingOffset
                moveq   #-1,d1
                sub.b   d0,d1
                move.b  d1,d0

HCZMiniSK_RocketTwistLoadFacingOffset:
                lea     (HCZMiniboss_RocketTwistLookup).l,a1
                move.b  (a1,d0.w),d1
                ext.w   d1
                movea.w parent3(a0),a2
                rts
; End of function LookupHCZMinibossRocketTwistOffset

; =============== S U B R O U T I N E =======================================

PositionHCZMinibossRocketTwistY:
                moveq   #0,d0
                move.b  $3D(a0),d0
                bsr.s   LookupHCZMinibossRocketTwistOffset
                move.w  y_pos(a2),d0
                add.w   d1,d0
                move.w  d0,y_pos(a0)
                rts
; End of function PositionHCZMinibossRocketTwistY

; =============== S U B R O U T I N E =======================================

FollowHCZMinibossRocketTipPose:
                movea.w parent3(a0),a2
                moveq   #0,d0
                move.b  $3D(a2),d0
                lsr.w   #3,d0
                andi.w  #$FFFE,d0
                move.w  HCZMiniSK_RocketTipDepthByPhase(pc,d0.w),priority(a0)
                lea     HCZMiniSK_RocketTipOffsetsByPhase(pc,d0.w),a1
                move.b  (a1)+,d1
                ext.w   d1
                btst    #0,render_flags(a2)
                beq.s   HCZMiniSK_RocketTipSetOffsetAndDepth
                neg.w   d1
                bset    #0,render_flags(a0)

HCZMiniSK_RocketTipSetOffsetAndDepth:
                move.b  (a1)+,d2
                ext.w   d2
                move.w  x_pos(a2),d3
                add.w   d1,d3
                move.w  d3,x_pos(a0)
                move.w  y_pos(a2),d3
                add.w   d2,d3
                move.w  d3,y_pos(a0)
                lsr.w   #1,d0
                move.b  HCZMiniSK_RocketTipFramesByPhase(pc,d0.w),mapping_frame(a0)
                rts
; End of function FollowHCZMinibossRocketTipPose

; ---------------------------------------------------------------------------
HCZMiniSK_RocketTipDepthByPhase:
                dc.w    $280
                dc.w    $200
                dc.w    $200
                dc.w    $200
                dc.w    $200
                dc.w    $180
                dc.w    $180
                dc.w    $180
                dc.w    $180
                dc.w    $180
                dc.w    $180
                dc.w    $280
                dc.w    $280
                dc.w    $280
                dc.w    $280
                dc.w    $280
HCZMiniSK_RocketTipOffsetsByPhase:
                dc.b    3,   3
                dc.b    0,   0
                dc.b    6,   6
                dc.b    $C,  $C
                dc.b    $12, $12
                dc.b    $C,  $C
                dc.b    8,   8
                dc.b    0,   0
                dc.b    3,   3
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    -6,  -6
                dc.b    -$A, -$A
                dc.b    0,   0
                dc.b    0,   0
HCZMiniSK_RocketTipFramesByPhase:
                dc.b    $E,  $F
                dc.b    $10, $11
                dc.b    $12, $11
                dc.b    $10,  $F
                dc.b    $E, $1A
                dc.b    $1A, $1A
                dc.b    $E,  $E
                dc.b    $1A, $1A
                even

; =============== S U B R O U T I N E =======================================

HandleHCZMinibossHitFlashOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   HCZMiniSK_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   HCZMiniSK_BeginScoredDefeatWait
                tst.b   $20(a0)
                bne.s   HCZMiniSK_HitChooseFlashRow
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

HCZMiniSK_HitChooseFlashRow:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   HCZMiniSK_HitCopyColorsAndTick
                addi.w  #2*7,d0

; Re-enable collision at the end of the flash only if the mapping frame is zero
HCZMiniSK_HitCopyColorsAndTick:
                lea     HCZMiniSK_HitPaletteDestinations(pc),a1
                lea     HCZMiniSK_HitPaletteColorRows(pc,d0.w),a2
                jsr     (CopyWordData_7).l
                subq.b  #1,$20(a0)
                bne.s   HCZMiniSK_HitUpdateReturn
                bclr    #6,status(a0)
                cmpi.b  #0,mapping_frame(a0)
                bne.s   HCZMiniSK_HitUpdateReturn
                move.b  $25(a0),collision_flags(a0)

HCZMiniSK_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_BeginScoredDefeatWait:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #HCZMiniSK_FreezeWaterAndTryExit,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     (BossDefeated_StopTimer).l
; End of function HandleHCZMinibossHitFlashOrDefeat

; ---------------------------------------------------------------------------
HCZMiniSK_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$0E, Normal_palette_line_2+$12, Normal_palette_line_2+$14
                dc.w    Normal_palette_line_2+$16, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
HCZMiniSK_HitPaletteColorRows:
                dc.w    4,     0,    $C,     8,   $20,  $826,  $624
                dc.w    $AAA,  $AAA,  $888,  $AAA,  $EEE,  $888,  $AAA
