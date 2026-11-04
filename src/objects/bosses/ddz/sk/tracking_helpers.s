; Owner: objects/bosses/ddz/sk
; Responsibility: Doomsday missile targeting, angle selection, boss motion, collisions and parent-state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Turn by two angle units on three out of four V-int ticks
DDZMissile_TurnTowardP1:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                beq.s   DDZ_HomingMissileTurnReturn
                movea.l a0,a1
                lea     (Player_1).w,a2
                jsr     GetApproximateObjectBearing(pc)
                moveq   #2,d1
                sub.b   $3C(a0),d0
                bpl.s   DDZ_HomingMissileApplySignedTurn
                neg.w   d1

DDZ_HomingMissileApplySignedTurn:
                add.b   d1,$3C(a0)

DDZ_HomingMissileTurnReturn:
                rts
; End of function DDZMissile_TurnTowardP1

; =============== S U B R O U T I N E =======================================

DDZMissile_SelectEightWayFrame:
                move.b  $3C(a0),d0
                addi.b  #$10,d0
                lsr.b   #5,d0
                move.b  d0,$3D(a0)
                addq.b  #8,d0
                move.b  d0,mapping_frame(a0)

DDZ_MotionHelpersReturn:
                rts
; End of function DDZMissile_SelectEightWayFrame

; ---------------------------------------------------------------------------

DDZ_MissileMoveAtDoubledHeadingSpeed:
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                add.w   d0,d0
                add.w   d1,d1
                move.w  d0,x_vel(a0)
                move.w  d1,y_vel(a0)
                jmp     (MoveSprite2).l

; =============== S U B R O U T I N E =======================================

; Index both the flame frame and the rear offset by the parent missile's display sector
DDZMissileFlame_SetFrameAndOffset:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  $3D(a1),d0
                move.b  #$10,mapping_frame(a0)
                add.b   d0,mapping_frame(a0)
                add.w   d0,d0
                move.w  DDZ_MissileFlameRearOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                rts
; End of function DDZMissileFlame_SetFrameAndOffset

; ---------------------------------------------------------------------------
DDZ_MissileFlameRearOffsets:
                dc.b    0,-$20
                dc.b    -$16,-$16
                dc.b    -$20,   0
                dc.b    -$16, $16
                dc.b    0, $20
                dc.b    $16, $16
                dc.b    $20,   0
                dc.b    $16,-$16
                even

; =============== S U B R O U T I N E =======================================

; Check the vulnerable boss before Player 1. Contact schedules explosion cleanup. A defeated parent also retires the missile
DDZMissile_CheckContactAndRetire:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   DDZMissileContact_ReturnWithoutDisposal
                tst.b   render_flags(a0)
                bpl.s   DDZ_MissileTestSectorContact
                tst.b   subtype(a0)
                beq.s   DDZ_MissileTestSectorContact
                move.w  (_unkFAA4).w,d0
                beq.s   DDZ_MissileTestSectorContact
                movea.w d0,a1
                tst.b   collision_flags(a1)
                bne.s   DDZ_MissileTestSectorContact
                lea     DDZ_MissileBossContactBounds(pc),a2
                jsr     Check_InTheirRange(pc)
                bne.s   DDZ_MissileDamageBossAndFlash

DDZ_MissileTestSectorContact:
                lea     (Player_1).w,a1
                tst.b   invulnerability_timer(a1)
                bne.s   DDZ_MissileCheckLauncherDeath
                moveq   #0,d0
                move.b  $3D(a0),d0
                add.w   d0,d0
                move.w  DDZ_MissilePlayerBoundsBySector(pc,d0.w),d1
                lea     DDZ_MissilePlayerBoundsBySector(pc,d1.w),a2
                jsr     Check_InMyRange(pc)
                bne.s   DDZ_MissileGrantPlayerInvulnerability

DDZ_MissileCheckLauncherDeath:
                move.w  parent3(a0),d0
                beq.s   DDZMissileContact_ReturnWithoutDisposal
                movea.w d0,a1
                btst    #7,status(a1)
                bne.s   DDZ_ProjectileWaitAndTryExplosion

DDZMissileContact_ReturnWithoutDisposal:
                rts
; ---------------------------------------------------------------------------

DDZ_MissileDamageBossAndFlash:
                subq.b  #1,collision_property(a1)
                st      collision_flags(a1)
                bra.w   DDZ_MissileDecrementLauncherCount
; ---------------------------------------------------------------------------

DDZ_MissileGrantPlayerInvulnerability:
                lea     (Player_1).w,a1
                move.b  #90-1,invulnerability_timer(a1)

DDZ_MissileDecrementLauncherCount:
                move.w  parent3(a0),d0
                beq.s   DDZ_ProjectileWaitAndTryExplosion
                movea.w d0,a1
                subq.b  #1,$39(a1)

DDZ_ProjectileWaitAndTryExplosion:
                move.l  #Wait_Draw,(a0)
                move.w  #3,$2E(a0)
                move.l  #SKCull_ReleaseRespawnForStatusDelete,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DDZ_ProjectileMarkDead
                move.b  #6,subtype(a1)

DDZ_ProjectileMarkDead:
                bset    #7,status(a0)
                rts
; End of function DDZMissile_CheckContactAndRetire

; ---------------------------------------------------------------------------
DDZ_MissileBossContactBounds:
                dc.w    0,   $38,  -$2C,   $18
DDZ_MissilePlayerBoundsBySector:
                dc.w    DDZ_MissileVerticalContactBounds-DDZ_MissilePlayerBoundsBySector
                dc.w    DDZ_MissileDiagonalContactBounds-DDZ_MissilePlayerBoundsBySector
                dc.w    DDZ_MissileHorizontalContactBounds-DDZ_MissilePlayerBoundsBySector
                dc.w    DDZ_MissileDiagonalContactBounds-DDZ_MissilePlayerBoundsBySector
                dc.w    DDZ_MissileVerticalContactBounds-DDZ_MissilePlayerBoundsBySector
                dc.w    DDZ_MissileDiagonalContactBounds-DDZ_MissilePlayerBoundsBySector
                dc.w    DDZ_MissileHorizontalContactBounds-DDZ_MissilePlayerBoundsBySector
                dc.w    DDZ_MissileDiagonalContactBounds-DDZ_MissilePlayerBoundsBySector
DDZ_MissileVerticalContactBounds:
                dc.w    -$18,   $30,  -$24,   $48
DDZ_MissileDiagonalContactBounds:
                dc.w    -$1C,   $38,  -$1C,   $38
DDZ_MissileHorizontalContactBounds:
                dc.w    -$24,   $48,  -$18,   $30

; =============== S U B R O U T I N E =======================================

; Retire when the parent dies. A Player 1 hit also sets a short invulnerability timer
DDZTurretShot_CheckContactOrRetire:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   DDZ_TurretShotContactReturn
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   DDZ_TurretShotScheduleDelete
                lea     (Player_1).w,a1
                tst.b   invulnerability_timer(a1)
                bne.s   DDZ_TurretShotContactReturn
                lea     DDZTurretShotContact_PlayerRectangle(pc),a2
                jsr     Check_InMyRange(pc)
                beq.s   DDZ_TurretShotContactReturn
                move.b  #60-1,invulnerability_timer(a1)
                moveq   #signextendB(sfx_Explode),d0
                jsr     (Play_SFX).l

DDZ_TurretShotScheduleDelete:
                jsr     (Go_Delete_Sprite).l

DDZ_TurretShotContactReturn:
                rts
; End of function DDZTurretShot_CheckContactOrRetire

; ---------------------------------------------------------------------------
DDZTurretShotContact_PlayerRectangle:
                dc.w    -$10,   $20,  -$10,   $20

; =============== S U B R O U T I N E =======================================

; On a Player 1 hit, start the invulnerability timer and explode the projectile after slowing flight
DDZHeavyShot_CheckHitAndSlowFlight:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   DDZ_HeavyShotContactReturn
                lea     (Player_1).w,a1
                tst.b   invulnerability_timer(a1)
                lea     DDZ_HeavyShotPlayerContactBounds(pc),a2
                jsr     Check_InMyRange(pc)
                bne.s   DDZ_HeavyShotGrantIFramesAndSlow
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   DDZ_ProjectileWaitAndTryExplosion

DDZ_HeavyShotContactReturn:
                rts
; ---------------------------------------------------------------------------

DDZ_HeavyShotGrantIFramesAndSlow:
                lea     (Player_1).w,a1
                move.b  #90-1,invulnerability_timer(a1)
                bsr.w   DDZFlight_ReduceScrollSpeed
                bra.w   DDZ_ProjectileWaitAndTryExplosion
; End of function DDZHeavyShot_CheckHitAndSlowFlight

; ---------------------------------------------------------------------------
DDZ_HeavyShotPlayerContactBounds:
                dc.w    -$10,   $20,  -$10,   $20

; =============== S U B R O U T I N E =======================================

; Subtract three pixels per update from 16.16 speed, with a signed minimum of one pixel per update
DDZFlight_ReduceScrollSpeed:
                move.l  (_unkFA82).w,d0
                move.l  #$10000,d1
                subi.l  #$30000,d0
                cmp.l   d1,d0
                bge.s   DDZ_FlightStoreReducedScrollSpeed
                move.l  d1,d0

DDZ_FlightStoreReducedScrollSpeed:
                move.l  d0,(_unkFA82).w
                rts
; End of function DDZFlight_ReduceScrollSpeed

; =============== S U B R O U T I N E =======================================

; Apply the child's signed word offsets to the parent's integer coordinates
DDZChild_SetPosFromParent:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                move.w  y_pos(a1),d1
                add.w   $42(a0),d0
                add.w   $44(a0),d1
                move.w  d0,x_pos(a0)
                move.w  d1,$14(a0)
                rts
; End of function DDZChild_SetPosFromParent

; =============== S U B R O U T I N E =======================================

DDZTurretShot_SetVelFromParentAngle:
                movea.w parent3(a0),a1
                move.w  angle(a1),d0
                add.w   d0,d0
                move.l  DDZTurretShot_EightPackedVelocityPairs(pc,d0.w),x_vel(a0)  ; and y_vel
                rts
; End of function DDZTurretShot_SetVelFromParentAngle

; ---------------------------------------------------------------------------
DDZTurretShot_EightPackedVelocityPairs:
                dc.w    0,  $400
                dc.w    $2D4,  $2D4
                dc.w    $400,     0
                dc.w    $2D4, -$2D4
                dc.w    0, -$400
                dc.w    -$2D4, -$2D4
                dc.w    -$400,     0
                dc.w    -$2D4,  $2D4

; =============== S U B R O U T I N E =======================================

PositionDDZTurretWithEightWayMuzzleNudge:
                move.w  angle(a0),d0
                lea     DDZTurret_EightSignedMuzzleNudgePairs(pc,d0.w),a1
                movea.w parent3(a0),a2
                move.b  (a1)+,d1
                ext.w   d1
                move.w  x_pos(a2),d2
                add.w   $42(a0),d2
                add.w   d1,d2
                move.w  d2,x_pos(a0)
                move.b  (a1)+,d1
                ext.w   d1
                move.w  y_pos(a2),d2
                add.w   $44(a0),d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                rts
; End of function PositionDDZTurretWithEightWayMuzzleNudge

; ---------------------------------------------------------------------------
DDZTurret_EightSignedMuzzleNudgePairs:
                dc.b    0,   8
                dc.b    8,   8
                dc.b    8,   0
                dc.b    8,  -8
                dc.b    0,  -8
                dc.b    -8,  -8
                dc.b    -8,   0
                dc.b    -8,   8
                even
; ---------------------------------------------------------------------------

DDZ_Phase1ReceiverCheckHit:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   DDZ_Phase1ReceiverHitReturn
                tst.b   collision_flags(a0)
                beq.s   DDZ_Phase1ReceiverHitReturn
                tst.b   collision_property(a0)
                bmi.s   DDZ_Phase1ReceiverAwardScoreAndFollow
                tst.b   $20(a0)
                bne.s   DDZ_Phase1ReceiverSelectFlashPalette
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_ThumpBoss),d0
                jsr     (Play_SFX).l

DDZ_Phase1ReceiverSelectFlashPalette:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   DDZ_Phase1ReceiverCopyFlashAndTick
                addi.w  #2*$C,d0

DDZ_Phase1ReceiverCopyFlashAndTick:
                bsr.w   DDZBoss_CopyPalette12
                subq.b  #1,$20(a0)
                bne.s   DDZ_Phase1ReceiverHitReturn
                clr.b   collision_flags(a0)

DDZ_Phase1ReceiverHitReturn:
                rts
; ---------------------------------------------------------------------------

DDZ_Phase1ReceiverAwardScoreAndFollow:
                moveq   #100,d0
                jsr     (HUD_AddToScore).l
                bset    #7,status(a0)
                move.l  #DDZ_Phase1TargetFollowUntilDiscard,(a0)
                rts
