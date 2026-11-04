; Owner: objects/bosses/dez/end_boss/sk
; Responsibility: Death Egg end-boss movement, collision, palette, angle and parent-state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Apply normal or reverse gravity before integrating vertical position
DEZCapsule_MoveWithGravity:
                move.w  x_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a0)
                move.w  y_vel(a0),d0
                moveq   #$38,d1
                tst.b   (Reverse_gravity_flag).w
                beq.s   DEZBoss_ApplyCapsuleGravity
                neg.w   d1

DEZBoss_ApplyCapsuleGravity:
                add.w   d1,d0
                move.w  d0,y_vel(a0)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a0)
                rts
; End of function DEZCapsule_MoveWithGravity

; =============== S U B R O U T I N E =======================================

DEZCapsule_DropIfGravityReversed:
                tst.b   $3A(a0)
                sne     d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   DEZBoss_DropCapsuleOnGravityChange
                not.b   d0

DEZBoss_DropCapsuleOnGravityChange:
                tst.b   d0
                beq.s   DEZBoss_RestingGravityReturn
                move.b  #4,routine(a0)
                move.b  #$C6,collision_flags(a0)
                clr.b   $39(a0)
                move.w  x_vel(a0),d0
                beq.s   DEZBoss_ClearDropYSpeed
                move.w  d0,$3C(a0)
                clr.w   x_vel(a0)

DEZBoss_ClearDropYSpeed:
                clr.w   y_vel(a0)

DEZBoss_RestingGravityReturn:
                rts
; End of function DEZCapsule_DropIfGravityReversed

; =============== S U B R O U T I N E =======================================

; A grounded rolling player launches the capsule. An airborne rolling player bounces and destroys it
DEZCapsule_CheckRestingContact:
                jsr     Check_PlayerCollision(pc)
                beq.w   DEZBoss_RestContactReturn
                cmpi.b  #2,anim(a1)
                beq.s   DEZBoss_RestContactBreakOrLaunch
                tst.b   invulnerability_timer(a1)
                bne.w   DEZBoss_RestContactReturn
                btst    #Status_InAir,status_secondary(a1)
                bne.w   DEZBoss_RestContactReturn
                jmp     HurtCharacter_Directly(pc)
; ---------------------------------------------------------------------------

DEZBoss_RestContactBreakOrLaunch:
                btst    #Status_InAir,status(a1)
                beq.s   DEZBoss_InitPlayerLaunchedCapsule
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bsr.w   DEZCapsule_ExplodeThenDelete
                adda.w  #8,sp
                rts
; ---------------------------------------------------------------------------

DEZBoss_InitPlayerLaunchedCapsule:
                move.b  #6,routine(a0)
                move.b  #$C6,collision_flags(a0)
                move.w  #7,child_dx(a0)
                move.b  #8,$39(a0)
                move.w  #$200,d4
                tst.w   x_vel(a1)
                bpl.s   DEZBoss_StoreLaunchXAndGetMagnitude
                neg.w   d4

DEZBoss_StoreLaunchXAndGetMagnitude:
                move.w  d4,x_vel(a0)
                move.w  ground_vel(a1),d4
                bpl.s   DEZBoss_ClampLaunchYMagnitude
                neg.w   d4

; Use an unsigned minimum of $500 before applying the vertical flip
DEZBoss_ClampLaunchYMagnitude:
                cmpi.w  #$500,d4
                bhs.s   DEZBoss_ApplyLaunchYFlip
                move.w  #$500,d4

DEZBoss_ApplyLaunchYFlip:
                btst    #1,render_flags(a0)
                beq.s   DEZBoss_StoreLaunchYAndAbortTail
                neg.w   d4

DEZBoss_StoreLaunchYAndAbortTail:
                move.w  d4,y_vel(a0)
                addq.w  #4,sp

DEZBoss_RestContactReturn:
                rts
; End of function DEZCapsule_CheckRestingContact

; =============== S U B R O U T I N E =======================================

HandleRollingDEZCapsulePlayerContact:
                jsr     Check_PlayerCollision(pc)
                beq.w   DEZBoss_RollContactReturn
                cmpi.b  #2,anim(a1)
                bne.s   DEZBoss_RollContactHurtIfVulnerable
                btst    #Status_InAir,status(a1)
                beq.s   DEZBoss_CheckApproachingGroundRoll

DEZBoss_RollContactHurtIfVulnerable:
                tst.b   invulnerability_timer(a1)
                bne.w   DEZBoss_RollContactReturn
                btst    #Status_InAir,status_secondary(a1)
                bne.w   DEZBoss_RollContactReturn
                jmp     HurtCharacter_Directly(pc)
; ---------------------------------------------------------------------------

DEZBoss_CheckApproachingGroundRoll:
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                smi     d1
                move.w  x_vel(a1),d2
                bmi.s   DEZBoss_ReflectPlayerXAndGroundSpeed
                not.b   d1

DEZBoss_ReflectPlayerXAndGroundSpeed:
                tst.b   d1
                beq.s   DEZBoss_RollContactReturn
                neg.w   d2
                move.w  d2,x_vel(a1)
                neg.w   ground_vel(a1)

DEZBoss_RollContactReturn:
                rts
; End of function HandleRollingDEZCapsulePlayerContact

; =============== S U B R O U T I N E =======================================

; Consume the initial contact reports without resolving them. A later attack can destroy the capsule if orientation matches
DEZCapsule_CheckFallingContact:
                jsr     Check_PlayerCollision(pc)
                beq.s   DEZBoss_FallContactReturn
                tst.b   $39(a0)
                beq.s   DEZBoss_FallContactCheckAttack
                subq.b  #1,$39(a0)
                rts
; ---------------------------------------------------------------------------

DEZBoss_FallContactCheckAttack:
                cmpi.b  #2,anim(a1)
                beq.s   DEZBoss_FallContactCheckAttackSide
                cmpi.b  #9,anim(a1)
                beq.s   DEZBoss_FallContactCheckAttackSide

DEZBoss_FallContactHurtIfVulnerable:
                tst.b   $34(a1)
                bne.s   DEZBoss_FallContactReturn
                btst    #Status_Invincible,status_secondary(a1)
                bne.s   DEZBoss_FallContactReturn
                jmp     HurtCharacter_Directly(pc)
; ---------------------------------------------------------------------------

DEZBoss_FallContactCheckAttackSide:
                jsr     (Find_OtherObject).l
                cmpi.w  #$10,d2
                bhs.s   DEZBoss_FallContactHurtIfVulnerable
                btst    #1,render_flags(a0)
                sne     d2
                tst.w   d1
                bne.s   DEZBoss_FallContactReflectAndBreak
                not.b   d2

DEZBoss_FallContactReflectAndBreak:
                tst.b   d2
                bne.s   DEZBoss_FallContactHurtIfVulnerable
                neg.w   x_vel(a1)
                neg.w   y_vel(a1)
                neg.w   ground_vel(a1)
                bsr.w   DEZCapsule_ExplodeThenDelete
                adda.w  #8,sp

DEZBoss_FallContactReturn:
                rts
; End of function DEZCapsule_CheckFallingContact

; =============== S U B R O U T I N E =======================================

ReverseDEZEndBossAtInclusiveWorldXBounds:
                move.w  x_pos(a0),d0
                tst.w   x_vel(a0)
                bmi.s   DEZBoss_CheckLeftArenaLimit
                cmpi.w  #$3598,d0
                bhs.s   DEZBoss_ReverseXAtArenaLimit
                rts
; ---------------------------------------------------------------------------

DEZBoss_CheckLeftArenaLimit:
                cmpi.w  #$3488,d0
                bhi.s   DEZBoss_ArenaLimitReturn

DEZBoss_ReverseXAtArenaLimit:
                neg.w   x_vel(a0)

DEZBoss_ArenaLimitReturn:
                rts
; End of function ReverseDEZEndBossAtInclusiveWorldXBounds

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromDEZBossBumperContact:
                jsr     Check_PlayerCollision(pc)
                beq.s   DEZBoss_BumperContactReturn
                move.b  $3C(a0),d0
                move.b  (V_int_run_count+3).w,d1
                andi.b  #3,d1
                subq.b  #2,d1
                add.w   d1,d0
                jsr     (GetSineCosine).l
                lsl.w   #3,d0
                lsl.w   #3,d1
                move.w  d0,x_vel(a1)
                move.w  d1,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                clr.b   jumping(a1)
                move.b  #1,anim(a0)
                moveq   #signextendB(sfx_Bumper),d0
                jsr     (Play_SFX).l

DEZBoss_BumperContactReturn:
                rts
; End of function LaunchPlayerFromDEZBossBumperContact

; =============== S U B R O U T I N E =======================================

SelectDEZBossBumperFrameAndFlipFromAngle:
                moveq   #0,d0
                move.b  $3C(a0),d0
                bclr    #7,d0
                sne     d2
                moveq   #4,d3
                lea     DEZBoss_BumperAngleThresholds(pc),a1
                btst    #6,d0
                beq.s   DEZBoss_FindBumperAngleFrame
                moveq   #$A,d3
                addq.w  #8,a1

DEZBoss_FindBumperAngleFrame:
                cmp.b   (a1)+,d0
                blo.s   DEZBoss_StoreBumperFrameAndGetFlips
                addq.w  #1,d3
                bra.s   DEZBoss_FindBumperAngleFrame
; ---------------------------------------------------------------------------

DEZBoss_StoreBumperFrameAndGetFlips:
                move.b  d3,mapping_frame(a0)
                move.b  render_flags(a0),d0
                andi.b  #$FC,d0
                tst.b   d2
                beq.s   DEZBoss_StoreBumperRenderFlags
                ori.b   #3,d0

DEZBoss_StoreBumperRenderFlags:
                move.b  d0,render_flags(a0)
                rts
; End of function SelectDEZBossBumperFrameAndFlipFromAngle

; ---------------------------------------------------------------------------
DEZBoss_BumperAngleThresholds:
                dc.b    5, $10, $1B, $26, $31, $3C, $40
                even
                dc.b    $45, $50, $5B, $66, $71, $7C, $80
                even

; =============== S U B R O U T I N E =======================================

; Choose one of three frame and velocity pairs by subtype and mirror Y velocity with the fragment's Y flip
DEZCapsuleDebris_InitFrameAndVel:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d0
                addi.b  #$1F,d0
                move.b  d0,mapping_frame(a0)
                add.w   d1,d1
                move.l  DEZBoss_FragmentVelocityPairs(pc,d1.w),x_vel(a0)  ; and y_vel
                btst    #1,render_flags(a0)
                beq.s   DEZBoss_FragmentSeedReturn
                neg.w   y_vel(a0)

DEZBoss_FragmentSeedReturn:
                rts
; End of function DEZCapsuleDebris_InitFrameAndVel

; ---------------------------------------------------------------------------
DEZBoss_FragmentVelocityPairs:
                dc.w    -$16A, -$16A
                dc.w    0, -$200
                dc.w    $16A, -$16A

; =============== S U B R O U T I N E =======================================

; On contact with a vulnerable boss, shatter the capsule and skip its remaining update. Travel direction and flip decide whether to latch a hit
DEZCapsule_CheckBossHitAndShatter:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                bne.s   DEZBoss_ReturnedHitCheckReturn
                lea     DEZBoss_ReturnedCapsuleHitBounds(pc),a2
                jsr     Check_InMyRange(pc)
                beq.s   DEZBoss_ReturnedHitCheckReturn
                btst    #1,render_flags(a0)
                sne     d0
                tst.w   y_vel(a0)
                bpl.s   DEZBoss_CheckReturnHitDirection
                not.b   d0

DEZBoss_CheckReturnHitDirection:
                tst.b   d0
                beq.s   DEZBoss_ShatterCapsuleAndAbortDraw
                st      $42(a1)
                bset    #6,status(a1)

DEZBoss_ShatterCapsuleAndAbortDraw:
                bsr.w   DEZCapsule_ExplodeThenSpawnDebris
                addq.w  #4,sp

DEZBoss_ReturnedHitCheckReturn:
                rts
; End of function DEZCapsule_CheckBossHitAndShatter

; ---------------------------------------------------------------------------
DEZBoss_ReturnedCapsuleHitBounds:
                dc.w    -$28,   $50,  -$28,   $50

; =============== S U B R O U T I N E =======================================

ConsumeDEZEndBossReturnedCapsuleHitLatch:
                tst.b   $42(a0)
                beq.s   DEZBoss_HitUpdateReturn
                tst.b   $20(a0)
                bne.s   DEZBoss_HitChooseFlashRow
                subq.b  #1,collision_property(a0)
                beq.s   DEZBoss_BeginDefeatAndResetGravity
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

DEZBoss_HitChooseFlashRow:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   DEZBoss_HitCopyColorsAndTick
                addi.w  #2*6,d0

DEZBoss_HitCopyColorsAndTick:
                bsr.w   CopyDEZEndBossSixColorPalette
                subq.b  #1,$20(a0)
                bne.s   DEZBoss_HitUpdateReturn
                bclr    #6,status(a0)
                clr.b   $42(a0)

DEZBoss_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

DEZBoss_BeginDefeatAndResetGravity:
                move.l  #Wait_NewDelay,(a0)
                bset    #7,status(a0)
                bset    #0,(SceneSyncFlagsOrMHZState).w
                move.l  #DEZBoss_BeginDefeatFall,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                jsr     (AllocateObject).l
                bne.s   DEZBoss_StopTimerAndAwardScore
                move.l  #DEZBoss_HoldNormalGravity,(a1)

DEZBoss_StopTimerAndAwardScore:
                jmp     BossDefeated_StopTimer(pc)
; End of function ConsumeDEZEndBossReturnedCapsuleHitLatch

; =============== S U B R O U T I N E =======================================

CopyDEZEndBossSixColorPalette:
                lea     DEZBoss_HitPaletteDestinations(pc),a1
                lea     DEZBoss_HitPaletteColorRows(pc,d0.w),a2
                jmp     CopyWordData_6(pc)
; End of function CopyDEZEndBossSixColorPalette

; ---------------------------------------------------------------------------
DEZBoss_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$06, Normal_palette_line_2+$08, Normal_palette_line_2+$16
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
DEZBoss_HitPaletteColorRows:
                dc.w    $2A,     6,  $A48,  $644,  $422,     0
                dc.w    $888,  $AAA,  $888,  $AAA,  $CCC,  $EEE
; ---------------------------------------------------------------------------

DEZBoss_HoldNormalGravity:
                clr.b   (Reverse_gravity_flag).w
                rts
