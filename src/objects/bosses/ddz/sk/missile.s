; Owner: objects/bosses/ddz/sk
; Responsibility: Doomsday missile initialization, tracking, player interaction and destruction
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DDZMissile:
                lea     ObjDat_DDZMissile(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     DDZMissileRearFlame_SimpleChildRecord(pc),a2
                jsr     CreateChild6_Simple(pc)
                tst.b   subtype(a0)
                bne.s   DDZ_InitHomingMissileVolley
                move.l  #DDZ_StraightMissilePlayDashOnce,(a0)
                move.w  #-$3FFA,$3C(a0)
                bra.w   DDZMissile_SelectEightWayFrame
; ---------------------------------------------------------------------------

DDZ_InitHomingMissileVolley:
                move.l  #DDZ_HomingMissileFollowDuringDelay,(a0)
                moveq   #0,d0
                move.b  $39(a0),d0
                add.w   d0,d0
                move.w  DDZHomingMissile_InitialVolleyYNudges(pc,d0.w),d1
                add.w   d1,y_pos(a0)
                lsl.w   #3,d0
                move.w  d0,$2E(a0)
                bra.s   DDZ_MissileCheckParentAndRetire
; ---------------------------------------------------------------------------
DDZHomingMissile_InitialVolleyYNudges:
                dc.w    0,    -8,     8
; ---------------------------------------------------------------------------

DDZ_StraightMissilePlayDashOnce:
                tst.b   render_flags(a0)
                bpl.s   DDZ_StraightMissileMoveAndCollide
                move.l  #DDZ_StraightMissileMoveAndCollide,(a0)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l

DDZ_StraightMissileMoveAndCollide:
                move.w  (SceneActorOrWorldOffset).w,d0
                sub.w   d0,x_pos(a0)
                subq.w  #2,x_pos(a0)
                bsr.w   DDZMissile_CheckContactAndRetire
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

DDZ_HomingMissileFollowDuringDelay:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   DDZ_HomingMissileCheckHiddenParent
                move.l  #DDZ_HomingMissileMoveAndFollowY,(a0)
                move.b  #$40,$3C(a0)
                bsr.w   DDZMissile_SelectEightWayFrame
                move.w  #$200,x_vel(a0)
                move.w  #$B,$2E(a0)
                move.l  #DDZ_InitHomingMissileMotion,$34(a0)

DDZ_HomingMissileCheckHiddenParent:
                bra.w   DDZ_MissileCheckParentAndRetire
; ---------------------------------------------------------------------------

DDZ_HomingMissileMoveAndFollowY:
                movea.w parent3(a0),a1
                move.w  y_pos(a1),y_pos(a0)
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DDZ_InitHomingMissileMotion:
                move.l  #DDZ_HomingMissileDispatchAndDraw,(a0)
                clr.b   routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #DDZ_HomingMissileStartProgrammedTurn,$34(a0)
                rts
; ---------------------------------------------------------------------------

DDZ_HomingMissileDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DDZHomingMissile_MotionStateOffsets(pc,d0.w),d1
                jsr     DDZHomingMissile_MotionStateOffsets(pc,d1.w)
                bsr.w   DDZMissile_CheckContactAndRetire
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
DDZHomingMissile_MotionStateOffsets:
                dc.w    DDZ_HomingMissileCoastAndWait-DDZHomingMissile_MotionStateOffsets
                dc.w    DDZ_HomingMissileTickTurnTimer-DDZHomingMissile_MotionStateOffsets
                dc.w    DDZ_HomingMissileTurnTowardPlayer-DDZHomingMissile_MotionStateOffsets
; ---------------------------------------------------------------------------

DDZ_HomingMissileCoastAndWait:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

DDZ_HomingMissileStartProgrammedTurn:
                move.b  #2,routine(a0)
                move.w  #$1F,$2E(a0)
                bset    #7,art_tile(a0)
                move.w  #$180,priority(a0)
                moveq   #0,d0
                move.b  $39(a0),d0
                move.b  DDZ_HomingMissileTurnSteps(pc,d0.w),$40(a0)
                rts
; ---------------------------------------------------------------------------
DDZ_HomingMissileTurnSteps:
                dc.b    4,   2,  -2
                even
; ---------------------------------------------------------------------------

DDZ_HomingMissileTickTurnTimer:
                subq.w  #1,$2E(a0)
                bpl.s   DDZ_HomingMissileStepHeading
                move.b  #4,routine(a0)

DDZ_HomingMissileStepHeading:
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                bsr.w   DDZMissile_SelectEightWayFrame
                bra.w   DDZ_MissileMoveAtDoubledHeadingSpeed
; ---------------------------------------------------------------------------

DDZ_HomingMissileTurnTowardPlayer:
                bsr.w   DDZMissile_TurnTowardP1
                bsr.w   DDZMissile_SelectEightWayFrame
                bra.w   DDZ_MissileMoveAtDoubledHeadingSpeed
; ---------------------------------------------------------------------------

DDZ_InitMissileFlame:
                lea     DDZ_MissileFlamePartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DDZ_MissileFlameRefreshFrameAndOffset,(a0)
                bsr.w   DDZMissileFlame_SetFrameAndOffset

DDZ_MissileFlameRefreshFrameAndOffset:
                bsr.w   DDZMissileFlame_SetFrameAndOffset

DDZ_MissileTrailTryPuffEvery8Frames:
                jsr     Child_GetPriority(pc)
                move.b  (V_int_run_count+3).w,d3
                andi.b  #7,d3
                bne.s   DDZ_MissileTrailSelectVisibility
                lea     DDZ_MissileFlamePuffChild(pc),a2
                jsr     CreateChild6_Simple(pc)

DDZ_MissileTrailSelectVisibility:
                btst    #1,d3
                bne.s   DDZ_MissileTrailHideAndCheckParent
                jsr     Refresh_ChildPosition(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DDZ_MissileTrailHideAndCheckParent:
                bclr    #7,render_flags(a0)
                jmp     Child_CheckParent(pc)
; ---------------------------------------------------------------------------

; Set the puff velocity opposite the grandparent projectile's heading
DDZ_InitMissileTrailPuff:
                lea     DDZ_TrailPuffPartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #DDZ_MissilePuffAnimateMoveAndCull,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                move.b  $3C(a1),d0
                jsr     (GetSineCosine).l
                neg.w   d0
                neg.w   d1
                move.w  d0,x_vel(a0)
                move.w  d1,y_vel(a0)

DDZ_MissilePuffAnimateMoveAndCull:
                move.w  (SceneActorOrWorldOffset).w,d0
                sub.w   d0,x_pos(a0)
                lea     DDZ_TrailPuffDeleteAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jsr     (MoveSprite2).l
                jmp     (Sprite_OnScreen_Test).l
; End of function DDZ_HomingMissileDispatchAndDraw
