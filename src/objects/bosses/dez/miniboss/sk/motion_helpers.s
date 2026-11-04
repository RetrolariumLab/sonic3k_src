; Owner: objects/bosses/dez/miniboss/sk
; Responsibility: Death Egg miniboss movement, collision, palette, angle and parent-state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

DEZMiniBeam_CheckBothPlayers:
                lea     DEZMini_BeamContactBounds(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                beq.s   DEZMini_BeamCheckPackedP2
                bsr.w   DEZMiniBeam_TryHurtPlayer

DEZMini_BeamCheckPackedP2:
                swap    d0
                tst.w   d0
                beq.s   DEZMini_BeamPlayerCheckReturn
; End of function DEZMiniBeam_CheckBothPlayers

; =============== S U B R O U T I N E =======================================

; Skip players under object control or standing on an object. Preserve the packed player pointers in d0
DEZMiniBeam_TryHurtPlayer:
                movea.w d0,a1
                tst.b   $34(a1)
                bne.s   DEZMini_BeamPlayerCheckReturn
                btst    #Status_OnObj,status(a1)
                bne.s   DEZMini_BeamPlayerCheckReturn
                btst    #Status_Invincible,status_secondary(a1)
                bne.s   DEZMini_BeamPlayerCheckReturn
                move.l  d0,-(sp)
                jsr     HurtCharacter_Directly(pc)
                move.l  (sp)+,d0

DEZMini_BeamPlayerCheckReturn:
                rts
; End of function DEZMiniBeam_TryHurtPlayer

; ---------------------------------------------------------------------------
DEZMini_BeamContactBounds:
                dc.w    -$18,   $30,  -$48,   $90

; =============== S U B R O U T I N E =======================================

; Collision type $86 is suppressed while the parent has status bit 6 set
DEZOrbitHazard_UpdateCollision:
                move.b  #$86,collision_flags(a0)
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                beq.s   DEZMini_OrbitHazardTouchReturn
                clr.b   collision_flags(a0)

DEZMini_OrbitHazardTouchReturn:
                rts
; End of function DEZOrbitHazard_UpdateCollision

; =============== S U B R O U T I N E =======================================

; Use Player 1 side every 32 V-int ticks. Force positive rotation while Player 1 stands on an object
DEZMini_RetargetPlatformSpin:
                btst    #3,(Player_1+status).w
                bne.s   DEZMini_UseBaseStepWithRider
                move.b  (V_int_run_count+3).w,d0
                andi.w  #$1F,d0
                bne.s   DEZMini_OrbitRetargetReturn
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                move.w  $26(a0),d1
                tst.w   d0
                beq.s   DEZMini_StoreTargetOrbitStep
                neg.w   d1

DEZMini_StoreTargetOrbitStep:
                move.w  d1,$3C(a0)

DEZMini_OrbitRetargetReturn:
                rts
; ---------------------------------------------------------------------------

DEZMini_UseBaseStepWithRider:
                move.w  $26(a0),$3C(a0)
                rts
; End of function DEZMini_RetargetPlatformSpin

; =============== S U B R O U T I N E =======================================

; Approach the requested parent spin speed and add the shared step to this platform's phase
DEZMiniPlatform_AccelAndStepAngle:
                movea.w parent3(a0),a1
                moveq   #8,d0
                move.w  $3A(a1),d1
                move.w  $3C(a1),d2
                bmi.s   DEZMini_EaseTowardNegativeStep
                add.w   d0,d1
                cmp.w   d2,d1
                blt.s   DEZMini_AdvancePhaseAndShareStep
                move.w  d2,d1
                bra.w   DEZMini_AdvancePhaseAndShareStep
; ---------------------------------------------------------------------------

DEZMini_EaseTowardNegativeStep:
                neg.w   d0
                add.w   d0,d1
                cmp.w   d2,d1
                bgt.s   DEZMini_AdvancePhaseAndShareStep
                move.w  d2,d1

DEZMini_AdvancePhaseAndShareStep:
                add.w   d1,$3C(a0)
                move.w  d1,$3A(a1)
                rts
; End of function DEZMiniPlatform_AccelAndStepAngle

; ---------------------------------------------------------------------------

; Use the primary platform's phase or its half-turn opposite
DEZMini_SyncPlatformOrbitPhase:
                movea.w parent3(a0),a1
                tst.b   subtype(a0)
                bne.s   DEZPlatforms_SelectOppositeSharedPhase
                move.b  $3C(a0),child_dy(a1)
                bra.w   DEZMini_PlaceFixedOrbitPlatform
; ---------------------------------------------------------------------------

DEZPlatforms_SelectOppositeSharedPhase:
                move.b  child_dy(a1),d0
                addi.b  #$80,d0
                move.b  d0,$3C(a0)

DEZMini_PlaceFixedOrbitPlatform:
                move.w  x_pos(a0),-(sp)
                moveq   #2,d2
                jsr     MoveSprite_CircularSimpleOffset(pc)
                moveq   #$23,d1
                moveq   #8,d2
                moveq   #$15,d3
                move.w  (sp)+,d4

DEZMini_PlatformCheckParentAndSolid:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   DEZMini_PlatformBreakAndRelease
                jsr     (SolidObjectTop).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZMini_PlatformBreakAndRelease:
                jsr     Displace_PlayerOffObject(pc)
                moveq   #0,d0
                jmp     SKChild_StartFlickerAndDraw(pc)
; ---------------------------------------------------------------------------

DEZMini_ResolvePlatformTopSolid:
                moveq   #$23,d1
                moveq   #8,d2
                moveq   #$15,d3
                move.w  x_pos(a0),d4
                bra.s   DEZMini_PlatformCheckParentAndSolid
; ---------------------------------------------------------------------------

DEZMini_PlaceVariableOrbitPlatform:
                move.w  x_pos(a0),-(sp)
                jsr     MoveSprite_Circular(pc)
                moveq   #$23,d1
                moveq   #8,d2
                moveq   #$15,d3
                move.w  (sp)+,d4
                bra.s   DEZMini_PlatformCheckParentAndSolid

; =============== S U B R O U T I N E =======================================

DEZMini_ReversePastArenaXBounds:
                move.w  x_pos(a0),d0
                tst.w   x_vel(a0)
                beq.s   DEZMini_ArenaReversalReturn
                bmi.s   DEZMini_TestLeftOvershoot
                cmp.w   (SceneMaximumXOrEmeraldSelectionTail).w,d0
                bhi.s   DEZMini_ReverseXAtArenaBound
                rts
; ---------------------------------------------------------------------------

DEZMini_TestLeftOvershoot:
                cmp.w   (SceneMinimumXOrEmeraldSelectionTail).w,d0
                bhs.s   DEZMini_ArenaReversalReturn

DEZMini_ReverseXAtArenaBound:
                neg.w   x_vel(a0)

DEZMini_ArenaReversalReturn:
                rts
; End of function DEZMini_ReversePastArenaXBounds

; =============== S U B R O U T I N E =======================================

; Pursue Player 1 at half a pixel per update and stop at either inclusive arena bound
DEZMini_SetPursuitVelWithinBounds:
                move.w  x_pos(a0),d0
                move.w  #-$80,d1
                move.w  (Player_1+x_pos).w,d2
                sub.w   d0,d2
                bls.s   DEZMini_SetPursuitDirection
                neg.w   d1

DEZMini_SetPursuitDirection:
                move.w  d1,x_vel(a0)
                beq.s   DEZMini_PursuitBoundReturn
                bmi.s   DEZMini_CheckLeftPursuitLimit
                cmp.w   (SceneMaximumXOrEmeraldSelectionTail).w,d0
                bhs.s   DEZMini_StopPursuitX
                rts
; ---------------------------------------------------------------------------

DEZMini_CheckLeftPursuitLimit:
                cmp.w   (SceneMinimumXOrEmeraldSelectionTail).w,d0
                bhi.s   DEZMini_PursuitBoundReturn

DEZMini_StopPursuitX:
                clr.w   x_vel(a0)

DEZMini_PursuitBoundReturn:
                rts
; End of function DEZMini_SetPursuitVelWithinBounds

; ---------------------------------------------------------------------------
; unused
                move.w  x_pos(a0),d0
                tst.w   x_vel(a0)
                beq.s   DEZMini_LegacyCheckYDirection
                bmi.s   DEZMini_LegacyCheckLeftLimit
                cmp.w   (SceneMaximumXOrEmeraldSelectionTail).w,d0
                bhs.s   DEZMini_LegacyStopX
                bra.w   DEZMini_LegacyCheckYDirection
; ---------------------------------------------------------------------------

DEZMini_LegacyCheckLeftLimit:
                cmp.w   (SceneMinimumXOrEmeraldSelectionTail).w,d0
                bhi.s   DEZMini_LegacyCheckYDirection

DEZMini_LegacyStopX:
                clr.w   x_vel(a0)

DEZMini_LegacyCheckYDirection:
                move.w  y_pos(a0),d0
                tst.w   y_vel(a0)
                beq.s   DEZMini_LegacyBoundsReturn
                bmi.s   DEZMini_LegacyCheckTopLimit
                cmp.w   (SceneMaximumYOrEmeraldSelectionTail).w,d0
                bhs.s   DEZMini_LegacyStopY
                bra.w   DEZMini_LegacyBoundsReturn
; ---------------------------------------------------------------------------

DEZMini_LegacyCheckTopLimit:
                cmp.w   (SceneMinimumYOrEmeraldSelectionBytes).w,d0
                bhi.s   DEZMini_LegacyBoundsReturn

DEZMini_LegacyStopY:
                clr.w   y_vel(a0)

DEZMini_LegacyBoundsReturn:
                rts

; =============== S U B R O U T I N E =======================================

SeedDEZMinibossRandomFlickerDebris:
                jsr     (Random_Number).l
                move.w  d0,d1
                andi.w  #$C,d1
                move.l  DEZMinibossDebris_InitialVelocityPairs(pc,d1.w),x_vel(a0)  ; and y_vel
                andi.w  #$1F,d0
                btst    #0,d0
                beq.s   DEZMini_DebrisSetXAndRandomFrame
                neg.w   d0
                neg.w   x_vel(a0)
                bset    #0,render_flags(a0)

DEZMini_DebrisSetXAndRandomFrame:
                add.w   d0,x_pos(a0)
                swap    d0
                move.w  d0,d1
                andi.w  #3,d1
                move.b  DEZMinibossDebris_FramesByRandomHighBits(pc,d1.w),mapping_frame(a0)
                andi.w  #$1F,d0
                btst    #0,d0
                beq.s   DEZMinibossDebris_ApplySelectedYJitter
                neg.w   d0

DEZMinibossDebris_ApplySelectedYJitter:
                add.w   d0,y_pos(a0)
                rts
; End of function SeedDEZMinibossRandomFlickerDebris

; ---------------------------------------------------------------------------
DEZMinibossDebris_InitialVelocityPairs:
                dc.w    $300, -$400
                dc.w    $200, -$300
                dc.w    $400, -$500
                dc.w    $300, -$200
DEZMinibossDebris_FramesByRandomHighBits:
                dc.b    $12
                dc.b    $13
                dc.b    $14
                dc.b    $12
                even

; =============== S U B R O U T I N E =======================================

SeedDEZMinibossEightOrbitHazardPhases:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  DEZMini_OrbitHazardInitialPhases(pc,d0.w),$3C(a0)
                rts
; End of function SeedDEZMinibossEightOrbitHazardPhases

; ---------------------------------------------------------------------------
DEZMini_OrbitHazardInitialPhases:
                dc.b    0, $80
                dc.b    $20, $A0
                dc.b    $40, $C0
                dc.b    $60, $E0
                even

; =============== S U B R O U T I N E =======================================

TrackDEZMinibossEyeTowardPlayerOne:
                movea.w parent3(a0),a1
                move.w  y_pos(a1),y_pos(a0)
                move.w  (Player_1+x_pos).w,d0
                move.w  x_pos(a1),d1
                sub.w   d1,d0
                smi     d2
                bpl.s   DEZMini_EyeClampPlayerDistance
                neg.w   d0

DEZMini_EyeClampPlayerDistance:
                cmpi.w  #$A0,d0
                bls.s   DEZMini_EyeChooseTrackingPose
                move.w  #$A0,d0

DEZMini_EyeChooseTrackingPose:
                lsr.w   #3,d0
                andi.w  #$FE,d0
                lea     DEZMini_EyeTrackingRows(pc,d0.w),a2
                move.b  (a2)+,d0
                bclr    #0,render_flags(a0)
                tst.b   d2
                beq.s   DEZMinibossEye_StoreTrackedXAndFrame
                bset    #0,render_flags(a0)
                neg.w   d0

DEZMinibossEye_StoreTrackedXAndFrame:
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.b  (a2)+,mapping_frame(a0)
                rts
; End of function TrackDEZMinibossEyeTowardPlayerOne

; ---------------------------------------------------------------------------
DEZMini_EyeTrackingRows:
                dc.b    0,   2
                dc.b    1,   2
                dc.b    2,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    6,   4
                dc.b    8,   4
                dc.b    9,   4
                dc.b    $A,   5
                dc.b    $B,   5
                dc.b    $C,   5
                even

; =============== S U B R O U T I N E =======================================

; Count a fresh hit on the parent once, at the start of the eye's flash
DEZMiniEye_TickHitFlash:
                tst.b   collision_flags(a0)
                bne.s   DEZMini_EyeRecoveryReturn
                tst.b   $20(a0)
                bne.s   DEZMini_EyeChooseFlashRow
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                movea.w parent3(a0),a1
                addq.b  #1,collision_property(a1)

DEZMini_EyeChooseFlashRow:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   DEZMini_EyeCopyColorsAndTick
                addi.w  #2*4,d0

DEZMini_EyeCopyColorsAndTick:
                bsr.w   CopyDEZMinibossEyeFourColorPalette
                subq.b  #1,$20(a0)
                bne.s   DEZMini_EyeRecoveryReturn
                move.b  $25(a0),collision_flags(a0)

DEZMini_EyeRecoveryReturn:
                rts
; End of function DEZMiniEye_TickHitFlash

; =============== S U B R O U T I N E =======================================

CopyDEZMinibossEyeFourColorPalette:
                lea     DEZMini_EyePaletteDestinations(pc),a1
                lea     DEZMinibossEyeHit_SourceColorGroups(pc,d0.w),a2
                jmp     CopyWordData_4(pc)
; End of function CopyDEZMinibossEyeFourColorPalette

; ---------------------------------------------------------------------------
DEZMini_EyePaletteDestinations:
                dc.w    Normal_palette_line_2+$16, Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
DEZMinibossEyeHit_SourceColorGroups:
                dc.w    $666,  $444,  $222,     0
                dc.w    $888,  $AAA,  $CCC,  $EEE
; ---------------------------------------------------------------------------

DEZMini_FormOneCheckHitCount:
                move.b  collision_property(a0),d0
                cmp.b   $42(a0),d0
                bne.s   DEZMini_FormOneRecordHitOrDefeat
                rts
; ---------------------------------------------------------------------------

DEZMini_FormOneRecordHitOrDefeat:
                move.b  d0,$42(a0)
                bset    #1,$38(a0)
                cmpi.b  #8,d0
                blo.s   DEZMini_FormOneHitUpdateReturn
                move.l  #DEZMinibossTransform_DispatchState,(a0)
                clr.b   routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #DEZMini_SignalForegroundAndSpawnShells,$34(a0)
                bset    #6,status(a0)
                bsr.w   DEZMini_FormOneTryExplosion

DEZMini_FormOneTryExplosion:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   DEZMini_FormOneHitUpdateReturn
                move.b  #$E,subtype(a1)

DEZMini_FormOneHitUpdateReturn:
                rts

; =============== S U B R O U T I N E =======================================

; A changed hit count restarts the palette and platform reaction. Eight hits trigger defeat
DEZMiniForm2_ReactToHitOrDefeat:
                move.b  collision_property(a0),d0
                cmp.b   $42(a0),d0
                bne.s   DEZMini_FormTwoRecordHitAndFlash

DEZMini_FormTwoHitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

DEZMini_FormTwoRecordHitAndFlash:
                move.b  d0,$42(a0)
                cmpi.b  #8,d0
                bhs.s   DEZMini_FormTwoBeginScoredDefeat
                move.w  #$800,$26(a0)
                lea     (DEZMini_FormTwoHitPaletteScript).l,a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #DEZMini_BeginPlatformAlignment,(Palette_rotation_custom).w
                bset    #1,$38(a0)
                bne.s   DEZMini_FormTwoHitUpdateReturn
                lea     DEZMini_BeamControllerChild(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

DEZMini_FormTwoBeginScoredDefeat:
                bset    #7,status(a0)
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #DEZMini_TryPostBossPlayerScene,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     BossDefeated_StopTimer(pc)
; End of function DEZMiniForm2_ReactToHitOrDefeat

; =============== S U B R O U T I N E =======================================

; Cycle through twelve fixed-point poses, force the frame and flips, and load the player's patterns
DEZPostBoss_AdvancePlayerSpin:
                move.w  $3C(a0),d0
                add.w   $1C(a0),d0
                cmpi.w  #$C00,d0
                blo.s   DEZMini_PlayerSpinSetPoseAndLoadArt
                subi.w  #$C00,d0

DEZMini_PlayerSpinSetPoseAndLoadArt:
                move.w  d0,$3C(a0)
                moveq   #0,d0
                move.b  $3C(a0),d0
                lea     (Player_1).w,a1
                move.b  DEZPostBossPlayerSpin_MappingFrames(pc,d0.w),mapping_frame(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  DEZPostBossPlayerSpin_RenderFlipBits(pc,d0.w),d0
                or.b    d0,render_flags(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Player_Load_PLC).l
; End of function DEZPostBoss_AdvancePlayerSpin

; ---------------------------------------------------------------------------
DEZPostBossPlayerSpin_MappingFrames:
                dc.b    $55, $59, $5A, $5B, $5A, $59, $55, $56, $57, $58, $57, $56
DEZPostBossPlayerSpin_RenderFlipBits:
                dc.b    0,   1,   1,   0,   0,   0,   1,   1,   1,   0,   0,   0
                even
