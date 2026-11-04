; Owner: objects/bosses/aiz/end_boss/s3
; Responsibility: Angel Island end-boss attachment states, attack actors, projectiles and private movement records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AIZBossS3_AttachmentFollowAndDispatch:
                jsr     (Refresh_ChildPositionAdjusted).l
                bsr.w   Child_SyncDraw
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZEndBossS3_Attachment_SixStateOffsets(pc,d0.w),d1
                jsr     AIZEndBossS3_Attachment_SixStateOffsets(pc,d1.w)
                btst    #6,$38(a0)
                bne.w   AIZBossS3_SharedReturn
                bsr.w   StartAIZBossAttachmentDelayedBreakaway
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
AIZEndBossS3_Attachment_SixStateOffsets:
                dc.w    AIZBossS3_InitAttachmentBySubtype-AIZEndBossS3_Attachment_SixStateOffsets
                dc.w    AIZBossS3_AttachmentWaitReveal-AIZEndBossS3_Attachment_SixStateOffsets
                dc.w    AIZEndBossS3_Attachment_RunRevealDelay-AIZEndBossS3_Attachment_SixStateOffsets
                dc.w    AIZBossS3_AttachmentAnimateReveal-AIZEndBossS3_Attachment_SixStateOffsets
                dc.w    AIZBossS3_AttachmentWaitAttack-AIZEndBossS3_Attachment_SixStateOffsets
                dc.w    AIZBossS3_AttachmentWaitAttackClear-AIZEndBossS3_Attachment_SixStateOffsets
; ---------------------------------------------------------------------------

AIZBossS3_InitAttachmentBySubtype:
                lea     AIZBossS3_AttachmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                moveq   #0,d0
                tst.b   subtype(a0)
                beq.s   AIZBossS3_AttachmentSpawnAttackPiece
                move.b  #$2A,mapping_frame(a0)
                move.w  #$280,priority(a0)

AIZBossS3_AttachmentSpawnAttackPiece:
                lea     AIZBossS3_AttackPieceChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZBossS3_AttachmentWaitReveal:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   AIZBossS3_AttachmentRouteReveal
                rts
; ---------------------------------------------------------------------------

; Front attachments pause before the reveal pose. Rear attachments go straight to the attack wait
AIZBossS3_AttachmentRouteReveal:
                tst.b   subtype(a0)
                bne.s   AIZBossS3_AttachmentSetAttackWait
                move.b  #4,routine(a0)
                move.w  #4,$2E(a0)
                move.l  #AIZBossS3_AttachmentBeginRevealPose,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_AttachmentSetAttackWait:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

AIZEndBossS3_Attachment_RunRevealDelay:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZBossS3_AttachmentBeginRevealPose:
                move.b  #6,routine(a0)
                move.l  #AIZBossS3_AttachmentFinishReveal,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_AttachmentAnimateReveal:
                bclr    #6,$38(a0)
                lea     AIZBossS3_AttachmentEmergeAnim(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

AIZBossS3_AttachmentFinishReveal:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_AttachmentWaitAttack:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   AIZBossS3_AttachmentLatchAttack
                rts
; ---------------------------------------------------------------------------

AIZBossS3_AttachmentLatchAttack:
                move.b  #$A,routine(a0)
                bset    #1,$38(a0)
                move.w  angle(a1),angle(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_AttachmentWaitAttackClear:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   AIZBossS3_AttachmentResetRevealWait
                rts
; ---------------------------------------------------------------------------

AIZBossS3_AttachmentResetRevealWait:
                move.b  #2,routine(a0)
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_AttachmentBeginBreakaway:
                move.l  #Obj_FlickerMove,(a0)
                move.b  #1,mapping_frame(a0)
                clr.b   collision_flags(a0)
                moveq   #$C,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

AIZBossS3_AttackPieceDispatchAndDraw:
                bsr.w   Child_SyncDraw
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZBossS3_AttackPieceStateOffsets(pc,d0.w),d1
                jsr     AIZBossS3_AttackPieceStateOffsets(pc,d1.w)
                jsr     (Refresh_ChildPositionAdjusted).l
                btst    #6,$38(a0)
                bne.w   AIZBossS3_SharedReturn
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
AIZBossS3_AttackPieceStateOffsets:
                dc.w    AIZBossS3_InitAttackPiece-AIZBossS3_AttackPieceStateOffsets
                dc.w    AIZBossS3_AttackPieceWaitRequest-AIZBossS3_AttackPieceStateOffsets
                dc.w    AIZBossS3_AttackPieceTickPose-AIZBossS3_AttackPieceStateOffsets
                dc.w    AIZBossS3_AttackPieceTickClosingWait-AIZBossS3_AttackPieceStateOffsets
; ---------------------------------------------------------------------------

AIZBossS3_InitAttackPiece:
                lea     AIZBossS3_AttackPieceAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                rts
; ---------------------------------------------------------------------------

AIZBossS3_AttackPieceWaitRequest:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   AIZBossS3_AttackPieceBeginOpening
                rts
; ---------------------------------------------------------------------------

AIZBossS3_AttackPieceBeginOpening:
                move.b  #4,routine(a0)
                move.b  #1,anim_frame(a0)
                bset    #1,$38(a0)
                move.l  #AIZBossS3_AttackPieceBeginFiring,$34(a0)
                move.w  angle(a1),angle(a0)
                clr.w   $2E(a0)
                tst.b   subtype(a1)
                beq.s   AIZBossS3_AttackPieceOpeningReturn
                move.w  #$4F,$2E(a0)

AIZBossS3_AttackPieceOpeningReturn:
                rts
; ---------------------------------------------------------------------------

; Advance the pose on timer underflow and invoke the callback after two steps
AIZBossS3_AttackPieceTickPose:
                subq.w  #1,$2E(a0)
                bpl.s   AIZBossS3_AttackPiecePoseReturn
                move.w  #3,$2E(a0)
                bsr.w   AdvanceAIZBossAttackAttachmentPose
                subq.b  #1,anim_frame(a0)
                bpl.s   AIZBossS3_AttackPiecePoseReturn
                movea.l $34(a0),a1
                jsr     (a1)

AIZBossS3_AttackPiecePoseReturn:
                rts
; ---------------------------------------------------------------------------

AIZBossS3_AttackPieceBeginFiring:
                move.b  #6,routine(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                move.w  #$5F,$2E(a0)
                move.l  #AIZBossS3_AttackPieceBeginClosing,$34(a0)
                bra.w   AIZBossS3_AttackSpawnChargeByAngle
; ---------------------------------------------------------------------------

AIZBossS3_AttackPieceResetPose:
                move.b  #2,routine(a0)
                clr.b   $39(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_AttackPieceTickClosingWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZBossS3_AttackPieceBeginClosing:
                move.b  #4,routine(a0)
                move.b  #1,anim_frame(a0)
                bclr    #1,$38(a0)
                clr.w   $2E(a0)
                move.l  #AIZBossS3_AttackPieceResetPose,$34(a0)
                rts
; ---------------------------------------------------------------------------

; The charge follows its immediate parent and uses the cached boss handle to check whether the boss is alive
AIZBossS3_InitChargeAndCacheBoss:
                lea     AIZBossS3_ChargeAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #AIZBossS3_ChargeFollowAndDraw,(a0)
                bset    #4,shield_reaction(a0)
                move.l  #AIZBossS3_ChargeReleaseShot,$34(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a2
                movea.w parent3(a2),a2
                move.w  a2,$44(a0)
                move.w  angle(a1),d0
                move.w  d0,angle(a0)
                move.l  AIZBossS3_ChargeAnimationByAngle(pc,d0.w),$30(a0)
                cmpi.w  #8,d0
                bhs.s   AIZBossS3_ChargeInitReturn
                bset    #0,render_flags(a0)

AIZBossS3_ChargeInitReturn:
                rts
; ---------------------------------------------------------------------------
AIZBossS3_ChargeAnimationByAngle:
                dc.l    AIZBossS3_ChargeOuterBlinkAnim
                dc.l    AIZBossS3_ChargeInnerBlinkAnim
                dc.l    AIZBossS3_ChargeInnerBlinkAnim
                dc.l    AIZBossS3_ChargeOuterBlinkAnim
; ---------------------------------------------------------------------------

AIZBossS3_ChargeFollowAndDraw:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   AIZBossS3_ChargeHideAndDelete
                jsr     (Refresh_ChildPosition).l
                jsr     (Animate_Raw).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZBossS3_ChargeReleaseShot:
                lea     AIZBossS3_ReleasedShotChild(pc),a2
                jsr     (CreateChild1_Normal).l

AIZBossS3_ChargeHideAndDelete:
                bset    #6,$38(a0)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

AIZBossS3_InitShotMotion:
                lea     AIZBossS3_ShotAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bset    #4,shield_reaction(a0)
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                move.b  #$C,y_radius(a0)
                move.w  #$9F,$2E(a0)
                move.l  #AIZBossS3_ShotCheckFloorIfMovingX,(a0)
                move.l  #AIZBossS3_ShotBeginGroundMotion,$34(a0)
                bra.w   AIZBossS3_ShotChooseFlipFromParent
; ---------------------------------------------------------------------------

AIZBossS3_ShotCheckFloorIfMovingX:
                tst.w   x_vel(a0)
                beq.s   AIZBossS3_ShotMoveAndEmitTrail
                jsr     (ObjHitFloor_DoRoutine).l

AIZBossS3_ShotMoveAndEmitTrail:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   AIZBossS3_ShotDeleteOnExpiry
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   AIZBossS3_ShotTouchDraw
                lea     AIZBossS3_ShotTrailChild(pc),a2
                jsr     (CreateChild1_Normal).l

AIZBossS3_ShotTouchDraw:
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZBossS3_ShotDeleteOnExpiry:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

AIZBossS3_ShotBeginGroundMotion:
                move.l  #AIZBossS3_ShotMoveAndEmitTrail,(a0)
                move.l  #AIZBossS3_ShotGroundAnim,$30(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_InitStationaryShotTrail:
                lea     AIZBossS3_TrailAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #AIZBossS3_TrailAnimateAndDraw,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.l  #AIZBossS3_TrailMovingXAnim,$30(a0)
                tst.w   x_vel(a0)
                bne.s   AIZBossS3_TrailInitReturn
                move.l  #AIZBossS3_TrailZeroXAnim,$30(a0)

AIZBossS3_TrailInitReturn:
                rts
; ---------------------------------------------------------------------------

AIZBossS3_TrailAnimateAndDraw:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZBossS3_InitEmergenceEffect:
                lea     ObjDat_AIZEndBoss2(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #AIZBossS3_AnimateEmergenceEffect,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_AnimateEmergenceEffect:
                lea     AIZBossS3_EmergenceEffectAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZBossS3_InitSplashBySubtype:
                lea     AIZEndBossS3_Splash_PartialArtAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #AIZBossS3_SplashAnimateAndCheckDraw,(a0)
                tst.b   subtype(a0)
                bne.s   AIZBossS3_SplashSelectFallCallback
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_SplashSelectFallCallback:
                move.l  #AIZBossS3_SplashBeginFall,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_SplashAnimateAndCheckDraw:
                lea     AIZBossS3_SplashStartAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelayFlipX).l
                cmpi.b  #$2B,mapping_frame(a0)
                beq.w   AIZBossS3_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZBossS3_SplashBeginFall:
                move.l  #AIZBossS3_SplashFallAndAnimate,(a0)
                move.w  #$800,y_vel(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossS3_SplashFallAndAnimate:
                jsr     (MoveSprite2).l
                lea     AIZBossS3_SplashFallAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelayFlipX).l
                cmpi.b  #$2B,mapping_frame(a0)
                beq.w   AIZBossS3_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZBossS3_InitDebrisBySubtype:
                lea     AIZBossS3_DebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                addi.b  #$32,d0
                move.b  d0,mapping_frame(a0)
                moveq   #0,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Retry if the random index matches the previous destination, then derive the travel speed from the position delta
AIZBossS3_ChooseNewTransitTarget:
                jsr     (Random_Number).l
                andi.w  #$C,d0
                move.w  angle(a0),d1
                move.w  d0,angle(a0)
                cmp.w   d1,d0
                beq.s   AIZBossS3_ChooseNewTransitTarget
                lea     AIZBossS3_TransitTargetPositions(pc,d0.w),a1
                moveq   #0,d2
                move.w  (a1)+,d2
                swap    d2
                sub.l   x_pos(a0),d2
                add.l   d2,d2
                swap    d2
                move.w  d2,x_vel(a0)
                moveq   #0,d3
                move.w  (a1)+,d3
                swap    d3
                sub.l   y_pos(a0),d3
                add.l   d3,d3
                swap    d3
                move.w  d3,y_vel(a0)
                move.w  #$7F,$2E(a0)
                tst.w   d2
                beq.s   AIZBossS3_TransitFacingReturn
                bclr    #0,render_flags(a0)
                tst.w   d2
                bmi.s   AIZBossS3_TransitFacingReturn
                bset    #0,render_flags(a0)

AIZBossS3_TransitFacingReturn:
                rts
; ---------------------------------------------------------------------------
AIZBossS3_TransitTargetPositions:
                dc.w    $48E0+$058, $15A+$76
                dc.w    $48E0+$0A0, $15A+$46
                dc.w    $48E0+$160, $15A+$46
                dc.w    $48E0+$1A8, $15A+$76
