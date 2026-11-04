; Owner: objects/bosses/aiz/end_boss/sk
; Responsibility: Angel Island end-boss attachment states, attack actors, projectiles and private movement records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AIZBossSK_AttachmentFollowAndDispatch:
                jsr     (Refresh_ChildPositionAdjusted).l
                bsr.w   Child_SyncDraw
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZEndBossSK_Attachment_SixStateOffsets(pc,d0.w),d1
                jsr     AIZEndBossSK_Attachment_SixStateOffsets(pc,d1.w)
                btst    #6,$38(a0)
                bne.w   AIZBossSK_SharedReturn
                bsr.w   StartAIZBossAttachmentDelayedBreakaway
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
AIZEndBossSK_Attachment_SixStateOffsets:
                dc.w    AIZBossSK_InitAttachmentBySubtype-AIZEndBossSK_Attachment_SixStateOffsets
                dc.w    AIZBossSK_AttachmentWaitReveal-AIZEndBossSK_Attachment_SixStateOffsets
                dc.w    AIZBossSK_AttachmentTickRevealDelay-AIZEndBossSK_Attachment_SixStateOffsets
                dc.w    AIZBossSK_AttachmentAnimateReveal-AIZEndBossSK_Attachment_SixStateOffsets
                dc.w    AIZBossSK_AttachmentWaitAttack-AIZEndBossSK_Attachment_SixStateOffsets
                dc.w    AIZBossSK_AttachmentWaitAttackClear-AIZEndBossSK_Attachment_SixStateOffsets
; ---------------------------------------------------------------------------

AIZBossSK_InitAttachmentBySubtype:
                lea     AIZBossSK_AttachmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                moveq   #0,d0
                tst.b   subtype(a0)
                beq.s   AIZBossSK_AttachmentSpawnAttackPiece
                move.b  #$2A,mapping_frame(a0)
                move.w  #$280,priority(a0)

AIZBossSK_AttachmentSpawnAttackPiece:
                lea     AIZBossSK_AttackPieceChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

AIZBossSK_AttachmentWaitReveal:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   AIZBossSK_AttachmentRouteReveal
                rts
; ---------------------------------------------------------------------------

; Front attachments pause before the reveal pose. Rear attachments go straight to the attack wait
AIZBossSK_AttachmentRouteReveal:
                tst.b   subtype(a0)
                bne.s   AIZBossSK_AttachmentSetAttackWait
                move.b  #4,routine(a0)
                move.w  #4,$2E(a0)
                move.l  #AIZBossSK_AttachmentBeginRevealPose,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_AttachmentSetAttackWait:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_AttachmentTickRevealDelay:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZBossSK_AttachmentBeginRevealPose:
                move.b  #6,routine(a0)
                move.l  #AIZBossSK_AttachmentFinishReveal,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_AttachmentAnimateReveal:
                bclr    #6,$38(a0)
                lea     AIZBossSK_AttachmentEmergeAnim(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

AIZBossSK_AttachmentFinishReveal:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_AttachmentWaitAttack:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   AIZBossSK_AttachmentLatchAttack
                rts
; ---------------------------------------------------------------------------

AIZBossSK_AttachmentLatchAttack:
                move.b  #$A,routine(a0)
                bset    #1,$38(a0)
                move.w  angle(a1),angle(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_AttachmentWaitAttackClear:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   AIZBossSK_AttachmentResetRevealWait
                rts
; ---------------------------------------------------------------------------

AIZBossSK_AttachmentResetRevealWait:
                move.b  #2,routine(a0)
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_AttachmentBeginBreakaway:
                move.l  #Obj_FlickerMove,(a0)
                move.b  #1,mapping_frame(a0)
                clr.b   collision_flags(a0)
                moveq   #$C,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

AIZBossSK_AttackPieceDispatchAndDraw:
                bsr.w   Child_SyncDraw
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZEndBossSK_AttackPart_FourStateOffsets(pc,d0.w),d1
                jsr     AIZEndBossSK_AttackPart_FourStateOffsets(pc,d1.w)
                jsr     (Refresh_ChildPositionAdjusted).l
                btst    #6,$38(a0)
                bne.w   AIZBossSK_SharedReturn
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
AIZEndBossSK_AttackPart_FourStateOffsets:
                dc.w    AIZBossSK_InitAttackPiece-AIZEndBossSK_AttackPart_FourStateOffsets
                dc.w    AIZBossSK_AttackPieceWaitRequest-AIZEndBossSK_AttackPart_FourStateOffsets
                dc.w    AIZBossSK_AttackPieceTickPose-AIZEndBossSK_AttackPart_FourStateOffsets
                dc.w    AIZEndBossSK_AttackPart_RunPostShotWait-AIZEndBossSK_AttackPart_FourStateOffsets
; ---------------------------------------------------------------------------

AIZBossSK_InitAttackPiece:
                lea     AIZBossSK_AttackPieceAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                rts
; ---------------------------------------------------------------------------

AIZBossSK_AttackPieceWaitRequest:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   AIZBossSK_AttackPieceBeginOpening
                rts
; ---------------------------------------------------------------------------

AIZBossSK_AttackPieceBeginOpening:
                move.b  #4,routine(a0)
                move.b  #1,anim_frame(a0)
                bset    #1,$38(a0)
                move.b  #1,$3A(a0)
                move.l  #AIZBossSK_AttackPieceBeginFiring,$34(a0)
                move.w  angle(a1),angle(a0)
                clr.w   $2E(a0)
                tst.b   subtype(a1)
                beq.s   AIZBossSK_AttackPieceOpeningReturn
                move.w  #$4F,$2E(a0)

AIZBossSK_AttackPieceOpeningReturn:
                rts
; ---------------------------------------------------------------------------

; Advance the pose on timer underflow and invoke the callback after two steps
AIZBossSK_AttackPieceTickPose:
                subq.w  #1,$2E(a0)
                bpl.s   AIZBossSK_AttackPiecePoseReturn
                move.w  #3,$2E(a0)
                bsr.w   AdvanceAIZBossAttackAttachmentPose
                subq.b  #1,anim_frame(a0)
                bpl.s   AIZBossSK_AttackPiecePoseReturn
                movea.l $34(a0),a1
                jsr     (a1)

AIZBossSK_AttackPiecePoseReturn:
                rts
; ---------------------------------------------------------------------------

AIZBossSK_AttackPieceBeginFiring:
                move.b  #6,routine(a0)
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   AIZBossSK_AttackPieceFireKnucklesShot

AIZBossSK_AttackPieceFireLastShot:
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                move.w  #$5F,$2E(a0)
                move.l  #AIZBossSK_AttackPieceBeginClosing,$34(a0)
                bra.w   AIZBossSK_AttackSpawnChargeByAngle
; ---------------------------------------------------------------------------

; The first shot waits 48 calls. The second clears the parent request and sets the closing delay
AIZBossSK_AttackPieceFireKnucklesShot:
                subq.b  #1,$3A(a0)
                bmi.s   AIZBossSK_AttackPieceFireLastShot
                move.w  #$2F,$2E(a0)
                bra.w   AIZBossSK_AttackSpawnChargeByAngle
; ---------------------------------------------------------------------------

AIZBossSK_AttackPieceResetPose:
                move.b  #2,routine(a0)
                clr.b   $39(a0)
                rts
; ---------------------------------------------------------------------------

AIZEndBossSK_AttackPart_RunPostShotWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

AIZBossSK_AttackPieceBeginClosing:
                move.b  #4,routine(a0)
                move.b  #1,anim_frame(a0)
                bclr    #1,$38(a0)
                clr.w   $2E(a0)
                move.l  #AIZBossSK_AttackPieceResetPose,$34(a0)
                rts
; ---------------------------------------------------------------------------

; The charge follows its immediate parent and uses the cached boss handle to check whether the boss is alive
AIZBossSK_InitChargeAndCacheBoss:
                lea     AIZBossSK_ChargeAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #AIZBossSK_ChargeFollowAndDraw,(a0)
                bset    #4,shield_reaction(a0)
                move.l  #AIZBossSK_ChargeReleaseShot,$34(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a2
                movea.w parent3(a2),a2
                move.w  a2,$44(a0)
                move.w  angle(a1),d0
                move.w  d0,angle(a0)
                move.l  AIZBossSK_ChargeAnimationByAngle(pc,d0.w),$30(a0)
                cmpi.w  #8,d0
                bhs.s   AIZBossSK_ChargeInitReturn
                bset    #0,render_flags(a0)

AIZBossSK_ChargeInitReturn:
                rts
; ---------------------------------------------------------------------------
AIZBossSK_ChargeAnimationByAngle:
                dc.l    AIZBossSK_ChargeOuterBlinkAnim
                dc.l    AIZBossSK_ChargeInnerBlinkAnim
                dc.l    AIZBossSK_ChargeInnerBlinkAnim
                dc.l    AIZBossSK_ChargeOuterBlinkAnim
; ---------------------------------------------------------------------------

AIZBossSK_ChargeFollowAndDraw:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   AIZBossSK_ChargeHideAndDelete
                jsr     (Refresh_ChildPosition).l
                jsr     (Animate_Raw).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZBossSK_ChargeReleaseShot:
                lea     AIZBossSK_ReleasedShotChild(pc),a2
                jsr     (CreateChild1_Normal).l

AIZBossSK_ChargeHideAndDelete:
                bset    #6,$38(a0)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

AIZBossSK_InitShotMotion:
                lea     AIZBossSK_ShotAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bset    #4,shield_reaction(a0)
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                move.b  #$C,y_radius(a0)
                move.w  #$9F,$2E(a0)
                move.l  #AIZBossSK_ShotCheckFloorIfMovingX,(a0)
                move.l  #AIZBossSK_ShotBeginGroundMotion,$34(a0)
                bra.w   AIZBossSK_ShotChooseFlipFromParent
; ---------------------------------------------------------------------------

AIZBossSK_ShotCheckFloorIfMovingX:
                tst.w   x_vel(a0)
                beq.s   AIZBossSK_ShotMoveAndEmitTrail
                jsr     (ObjHitFloor_DoRoutine).l

AIZBossSK_ShotMoveAndEmitTrail:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   AIZBossSK_ShotDeleteOnExpiry
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   AIZBossSK_ShotTouchDraw
                lea     AIZBossSK_ShotTrailChild(pc),a2
                jsr     (CreateChild1_Normal).l

AIZBossSK_ShotTouchDraw:
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

AIZBossSK_ShotDeleteOnExpiry:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

AIZBossSK_ShotBeginGroundMotion:
                move.l  #AIZBossSK_ShotMoveAndEmitTrail,(a0)
                move.l  #AIZBossSK_ShotGroundAnim,$30(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_InitStationaryShotTrail:
                lea     AIZBossSK_TrailAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #AIZBossSK_TrailAnimateAndDraw,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.l  #AIZBossSK_TrailMovingXAnim,$30(a0)
                tst.w   x_vel(a0)
                bne.s   AIZBossSK_TrailInitReturn
                move.l  #AIZBossSK_TrailZeroXAnim,$30(a0)

AIZBossSK_TrailInitReturn:
                rts
; ---------------------------------------------------------------------------

AIZBossSK_TrailAnimateAndDraw:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZBossSK_InitEmergenceEffect:
                lea     ObjDat_AIZEndBoss2(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #AIZBossSK_AnimateEmergenceEffect,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_AnimateEmergenceEffect:
                lea     AIZBossSK_EmergenceEffectAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZBossSK_InitSplashBySubtype:
                lea     AIZEndBossSK_Splash_PartialArtAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #AIZBossSK_SplashAnimateAndCheckDraw,(a0)
                tst.b   subtype(a0)
                bne.s   AIZBossSK_SplashSelectFallCallback
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_SplashSelectFallCallback:
                move.l  #AIZBossSK_SplashBeginFall,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_SplashAnimateAndCheckDraw:
                lea     AIZBossSK_SplashStartAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelayFlipX).l
                cmpi.b  #$2B,mapping_frame(a0)
                beq.w   AIZBossSK_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZBossSK_SplashBeginFall:
                move.l  #AIZBossSK_SplashFallAndAnimate,(a0)
                move.w  #$800,y_vel(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

AIZBossSK_SplashFallAndAnimate:
                jsr     (MoveSprite2).l
                lea     AIZBossSK_SplashFallAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelayFlipX).l
                cmpi.b  #$2B,mapping_frame(a0)
                beq.w   AIZBossSK_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZBossSK_InitDebrisBySubtype:
                lea     AIZBossSK_DebrisAttributes(pc),a1
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
AIZBossSK_ChooseNewTransitTarget:
                jsr     (Random_Number).l
                andi.w  #$C,d0
                move.w  angle(a0),d1
                move.w  d0,angle(a0)
                cmp.w   d1,d0
                beq.s   AIZBossSK_ChooseNewTransitTarget
                lea     AIZBossSK_TransitTargetOffsets(pc,d0.w),a1
                moveq   #0,d2
                move.w  (SceneCreditIndexOrBossMotionPlanAngle).w,d2
                add.w   (a1)+,d2
                swap    d2
                sub.l   x_pos(a0),d2
                add.l   d2,d2
                swap    d2
                move.w  d2,x_vel(a0)
                moveq   #0,d3
                move.w  (SceneCreditStateOrBossMotionPlanX).w,d3
                add.w   (a1)+,d3
                swap    d3
                sub.l   y_pos(a0),d3
                add.l   d3,d3
                swap    d3
                move.w  d3,y_vel(a0)
                move.w  #$7F,$2E(a0)
                tst.w   d2
                beq.s   AIZBossSK_TransitFacingReturn
                bclr    #0,render_flags(a0)
                tst.w   d2
                bmi.s   AIZBossSK_TransitFacingReturn
                bset    #0,render_flags(a0)

AIZBossSK_TransitFacingReturn:
                rts
; ---------------------------------------------------------------------------
AIZBossSK_TransitTargetOffsets:
                dc.w    $058,   $76
                dc.w    $0A0,   $46
                dc.w    $160,   $46
                dc.w    $1A8,   $76
