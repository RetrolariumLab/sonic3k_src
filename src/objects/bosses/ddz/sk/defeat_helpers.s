; Owner: objects/bosses/ddz/sk
; Responsibility: Doomsday palette transfer, player response, defeat progression, spawning and scene motion helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; d0.w is a source byte offset. Copy to the twelve entries selected in palette line 3
DDZBoss_CopyPalette12:
                lea     DDZ_BossFlashPaletteDestinations(pc),a1
                lea     DDZ_BossFlashPaletteProfiles(pc,d0.w),a2
                moveq   #$C-1,d1

                .loop:
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
                dbf     d1,.loop
                rts
; End of function DDZBoss_CopyPalette12

; ---------------------------------------------------------------------------
DDZ_BossFlashPaletteDestinations:
                dc.w    Normal_palette_line_3+$06, Normal_palette_line_3+$08, Normal_palette_line_3+$0C
                dc.w    Normal_palette_line_3+$0E, Normal_palette_line_3+$10, Normal_palette_line_3+$12
                dc.w    Normal_palette_line_3+$14, Normal_palette_line_3+$16, Normal_palette_line_3+$18
                dc.w    Normal_palette_line_3+$1A, Normal_palette_line_3+$1C, Normal_palette_line_3+$1E
DDZ_BossFlashPaletteProfiles:
                dc.w    $A,     6,  $CAA,  $A88,  $866,  $444,  $E42,  $E00,  $C00,  $600,  $200,     0
                dc.w    $888,  $AAA,  $CCC,  $AAA,  $888,  $666,  $ECC,  $ECA,  $AAA,  $AAA,  $CCC,  $EEE
; ---------------------------------------------------------------------------

DDZ_ChaseCheckSuperHitOrFlash:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   DDZ_ChaseHitReturn
                tst.b   $20(a0)
                bne.s   DDZ_ChaseSelectFlashPalette
                lea     (Player_1).w,a1
                lea     DDZ_ChasePlayerHitBounds(pc),a2
                jsr     Check_InMyRange(pc)
                beq.s   DDZ_ChaseHitReturn
                subq.b  #1,collision_property(a0)
                bmi.s   DDZ_ChaseApplyDefeatState
                move.b  #$20,$20(a0)
                move.b  #90,(Player_1+invulnerability_timer).w
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bsr.w   DDZFlight_ReduceScrollSpeed
                move.w  (DdzFlightControllerOrLowerMotionPlanX).w,d0
                beq.s   DDZ_ChaseSelectFlashPalette
                movea.w d0,a1
                move.w  #-$1000,x_vel(a1)

DDZ_ChaseSelectFlashPalette:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   DDZ_ChaseCopyFlashAndTickCooldown
                addi.w  #2*$C,d0

DDZ_ChaseCopyFlashAndTickCooldown:
                bsr.w   DDZBoss_CopyPalette12
                subq.b  #1,$20(a0)

DDZ_ChaseHitReturn:
                rts
; ---------------------------------------------------------------------------

DDZ_ChaseApplyDefeatState:
                moveq   #100,d0
                jsr     (HUD_AddToScore).l
                move.l  #DDZ_FinalDefeatDispatchAndCarry,(a0)
                clr.b   routine(a0)
                bset    #7,status(a0)
                st      (Ctrl_1_locked).w
                move.w  #$7FFF,(Super_frame_count).w
                move.w  (Camera_Y_pos).w,d0
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_max_Y_pos).w
                move.w  (DdzFlightControllerOrLowerMotionPlanX).w,d0
                beq.s   DDZ_ChaseTrySpawnThreeBurstActor
                movea.w d0,a1
                bclr    #2,$38(a1)
                move.w  #-$400,x_vel(a1)
                clr.w   y_vel(a1)

DDZ_ChaseTrySpawnThreeBurstActor:
                jsr     (AllocateObject).l
                bne.s   DDZ_ChaseHitReturn
                move.l  #DDZ_FinalUpdateThreeBurstSequence,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  a0,parent3(a1)
                rts
; ---------------------------------------------------------------------------
DDZ_ChasePlayerHitBounds:
                dc.w    $20,   $40,   $20,   $40
; ---------------------------------------------------------------------------

DDZ_Phase1UpdateTenBurstSequence:
                bsr.w   DDZChild_SetPosFromParent
                subq.w  #1,$2E(a0)
                bpl.s   DDZ_Phase1RestoreNormalColors
                moveq   #$18,d0
                bsr.w   DDZBoss_CopyPalette12
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l
                move.w  #$1F,$2E(a0)
                moveq   #0,d1
                move.b  $39(a0),d1
                lea     DDZFirstStageBreakup_TenWordOffsetPairs(pc,d1.w),a2
                jsr     (AllocateObject).l
                bne.s   DDZ_Phase1AdvanceBurstAttempt
                move.l  #DDZ_EmitterTryNextExplosionOffset,(a1)
                move.w  a0,parent3(a1)
                move.w  (a2)+,$42(a1)
                move.w  (a2)+,$44(a1)

; Advance the position even when explosion allocation fails
DDZ_Phase1AdvanceBurstAttempt:
                addq.b  #4,d1
                cmpi.b  #$28,d1
                bhs.s   DDZ_Phase1ScheduleBurstActorDelete
                move.b  d1,$39(a0)
                rts
; ---------------------------------------------------------------------------

DDZ_Phase1ScheduleBurstActorDelete:
                jsr     Go_Delete_Sprite(pc)

DDZ_Phase1RestoreNormalColors:
                moveq   #0,d0
                bra.w   DDZBoss_CopyPalette12
; ---------------------------------------------------------------------------
DDZFirstStageBreakup_TenWordOffsetPairs:
                dc.w    $C0,   $38
                dc.w    $78,   $80
                dc.w    $B0,   $78
                dc.w    $58,   $40
                dc.w    $98,   $60
                dc.w    $E0,   $70
                dc.w    $C8,   $40
                dc.w    $70,   $80
                dc.w    $98,   $70
                dc.w    $50,   $40
; ---------------------------------------------------------------------------

DDZ_FinalUpdateThreeBurstSequence:
                bsr.w   DDZChild_SetPosFromParent
                subq.w  #1,$2E(a0)
                bpl.s   DDZ_FinalBurstSequenceReturn
                move.w  #$1F,$2E(a0)
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l
                moveq   #0,d1
                move.b  $39(a0),d1
                lea     DDZFinalBreakup_ThreeWordOffsetPairs(pc,d1.w),a2
                jsr     (AllocateObject).l
                bne.s   DDZ_FinalAdvanceOrFinishBurstAttempts
                move.l  #DDZ_EmitterTryNextExplosionOffset,(a1)
                move.w  a0,parent3(a1)
                move.w  (a2)+,$42(a1)
                move.w  (a2)+,$44(a1)
                st      subtype(a1)

DDZ_FinalAdvanceOrFinishBurstAttempts:
                addq.b  #4,d1
                cmpi.b  #$C,d1
                bhs.w   DDZ_DeleteSceneActor
                move.b  d1,$39(a0)

DDZ_FinalBurstSequenceReturn:
                rts
; ---------------------------------------------------------------------------
DDZFinalBreakup_ThreeWordOffsetPairs:
                dc.w    $50,   $48
                dc.w    $30,   $30
                dc.w    $30,   $68
; ---------------------------------------------------------------------------

DDZ_EmitterTryNextExplosionOffset:
                bsr.w   DDZChild_SetPosFromParent
                moveq   #0,d0
                move.b  $39(a0),d0
                cmpi.b  #$30,d0
                bhs.w   DDZ_DeleteSceneActor
                addq.b  #2,$39(a0)
                lea     DDZ_EmitterExplosionOffsets(pc,d0.w),a2
                jsr     (AllocateObject).l
                bne.s   DDZ_EmitterExplosionAttemptReturn
                move.l  #DDZ_InitDefeatExplosion,(a1)
                move.w  a0,parent3(a1)
                move.w  x_pos(a0),d0
                move.b  (a2)+,d1
                ext.w   d1
                add.w   d1,d0
                move.w  d0,x_pos(a1)
                move.w  y_pos(a0),d0
                move.b  (a2)+,d1
                ext.w   d1
                add.w   d1,d0
                move.w  d0,y_pos(a1)
                asr.w   #4,d1
                move.w  d1,y_vel(a1)
                move.w  #$100,x_vel(a1)
                move.w  #-$100,$3A(a1)

DDZ_EmitterExplosionAttemptReturn:
                rts
; ---------------------------------------------------------------------------
DDZ_EmitterExplosionOffsets:
                dc.b    0,   0
                dc.b    -$10,  -8
                dc.b    0,   8
                dc.b    8,  -8
                dc.b    -$10,   8
                dc.b    0,-$10
                dc.b    -$10,-$18
                dc.b    $10,   8
                dc.b    $10,-$10
                dc.b    -$18,   0
                dc.b    -8,-$20
                dc.b    $18,   0
                dc.b    -8, $10
                dc.b    -$20,-$10
                dc.b    8,-$20
                dc.b    8, $18
                dc.b    -$18,-$20
                dc.b    -$20, $10
                dc.b    $20,-$10
                dc.b    $20, $10
                dc.b    $18,-$28
                dc.b    -$28,  -8
                dc.b    -$10, $20
                dc.b    $28,   0
                even
; ---------------------------------------------------------------------------

DDZ_InitPhase1ExplosionAnchor:
                move.l  #DDZ_Phase1AnchorFollowUntilRelease,(a0)
                move.w  #$90,$42(a0)
                move.w  #$60,$44(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DDZ_Phase1AnchorFollowUntilRelease
                move.b  #$1C,subtype(a1)

DDZ_Phase1AnchorFollowUntilRelease:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                beq.w   DDZChild_SetPosFromParent

DDZ_DeleteSceneActor:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

DDZ_InitFinalAnchorAndTryExplosion:
                move.l  #DDZ_FinalAnchorFollowOffsets,(a0)
                move.w  #$40,$42(a0)
                move.w  #$40,$44(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DDZ_FinalAnchorTrySecondExplosion
                move.b  #$E,subtype(a1)

DDZ_FinalAnchorTrySecondExplosion:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DDZ_FinalAnchorFollowOffsets
                move.b  #$E,subtype(a1)

DDZ_FinalAnchorFollowOffsets:
                bra.w   DDZChild_SetPosFromParent

; =============== S U B R O U T I N E =======================================

; Select the four-shot pattern by Player 1 height relative to the boss
DDZBoss_TryFourShotBurst:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$140,d0
                cmp.w   x_pos(a0),d0
                blo.w   DDZ_MotionHelpersReturn
                subq.w  #1,$2E(a0)
                bpl.w   DDZ_MotionHelpersReturn
                move.w  #$82,$2E(a0)
                move.w  y_pos(a0),d0
                addi.w  #$68,d0
                cmp.w   (Player_1+y_pos).w,d0
                bhs.s   DDZ_SelectUpperPlayerShotPattern
                moveq   #signextendB(sfx_BossProjectile),d0
                jsr     (Play_SFX).l
                lea     DDZ_CurvedHeavyShotChildren(pc),a2
                jmp     CreateChild6_Simple(pc)
; ---------------------------------------------------------------------------

DDZ_SelectUpperPlayerShotPattern:
                lea     DDZ_HorizontalHeavyShotChildren(pc),a2
                jmp     CreateChild6_Simple(pc)
; End of function DDZBoss_TryFourShotBurst

; =============== S U B R O U T I N E =======================================

; Combine held Right with the flight controller speed and reject candidates on or outside the camera-relative limits
DDZBoss_StepXFromFlightInput:
                movea.w (DdzFlightControllerOrLowerMotionPlanX).w,a1
                move.b  x_vel(a1),d1
                ext.w   d1
                neg.w   d1
                asr.w   #1,d1
                btst    #button_right,(Ctrl_1_held).w
                bne.s   DDZ_BossCheckRightHeldStepBound
                move.w  x_pos(a0),d0
                addi.w  #2,d0
                add.w   d1,d0
                move.w  (Camera_max_X_pos).w,d1
                add.w   d2,d1
                cmp.w   d1,d0
                blo.s   DDZ_BossCommitRightHeldStep
                rts
; ---------------------------------------------------------------------------

DDZ_BossCheckRightHeldStepBound:
                move.w  x_pos(a0),d0
                addi.w  #-2,d0
                add.w   d1,d0
                move.w  (Camera_min_X_pos).w,d1
                add.w   d3,d1
                cmp.w   d1,d0
                bls.s   DDZ_BossHorizontalStepReturn

; Swapping the register carries its previous high word into the position fraction
DDZ_BossCommitRightHeldStep:
                swap    d0
                move.l  d0,x_pos(a0)

DDZ_BossHorizontalStepReturn:
                rts
; End of function DDZBoss_StepXFromFlightInput

; ---------------------------------------------------------------------------

DDZ_StageFlashInitFivePasses:
                move.b  #4,$39(a0)
                move.l  #DDZ_StageFlashWaitAndBeginPass,(a0)
                move.w  #3,$3A(a0)

DDZ_StageFlashWaitAndBeginPass:
                subq.w  #1,$2E(a0)
                bpl.w   DDZ_MotionHelpersReturn
                move.w  $3A(a0),$2E(a0)
                lea     (Normal_palette).w,a1
                moveq   #$40-1,d0

DDZ_StageFlashRaiseAllColors:
                jsr     EffectColorSKRaiseOneColorTowardWhite(pc)
                dbf     d0,DDZ_StageFlashRaiseAllColors
                subq.b  #1,$39(a0)
                bmi.s   DDZ_StageFlashBeginPaletteRestore
                rts
; ---------------------------------------------------------------------------

DDZ_StageFlashBeginPaletteRestore:
                move.l  #SKPalEffect_InitTargetPasses,(a0)
                rts

; =============== S U B R O U T I N E =======================================

; Use the high nibble for size and contact bounds and the low nibble for X drift
DDZAsteroid_InitFromSubtype:
                move.b  subtype(a0),d0
                move.w  d0,d1
                andi.w  #$F0,d0
                lsr.w   #1,d0
                lea     DDZ_AsteroidSizeFrameAndRange(pc,d0.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,collision_flags(a0)
                move.l  (a1)+,$30(a0)
                bset    #2,render_flags(a0)
                andi.w  #$F,d1
                add.w   d1,d1
                move.w  DDZ_AsteroidSubtypeXVelocities(pc,d1.w),x_vel(a0)
                rts
; End of function DDZAsteroid_InitFromSubtype

; ---------------------------------------------------------------------------
DDZ_AsteroidSubtypeXVelocities:
                dc.w    -$80,  -$40,     0,   $40,   $80, -$200
DDZ_AsteroidSizeFrameAndRange:
                dc.b    $10, $10, $26,   0
                dc.l    DDZAsteroidSmall_ManualContactRectangle
                dc.b    $18, $18, $27,   0
                dc.l    DDZAsteroidMedium_ManualContactRectangle
                dc.b    $28, $28, $28,   0
                dc.l    DDZAsteroidLarge_ManualContactRectangle
DDZAsteroidSmall_ManualContactRectangle:
                dc.w    -$18,   $30,  -$18,   $30
DDZAsteroidMedium_ManualContactRectangle:
                dc.w    -$20,   $40,  -$20,   $40
DDZAsteroidLarge_ManualContactRectangle:
                dc.w    -$28,   $50,  -$38,   $68
