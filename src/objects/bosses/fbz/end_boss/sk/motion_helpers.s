; Owner: objects/bosses/fbz/end_boss/sk
; Responsibility: Flying Battery end-boss motion, collision, flash, angle and private geometry helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Play the spike-ball sound at angle $00 or $80 with at least four wait ticks left
FBZBoss_TryHalfTurnSound:
                cmpi.w  #4,$2E(a0)
                blo.s   FBZBossSK_HalfTurnSoundReturn
                move.b  $3C(a0),d0
                andi.b  #$7F,d0
                bne.s   FBZBossSK_HalfTurnSoundReturn
                moveq   #signextendB(sfx_SpikeBalls),d0
                jsr     (Play_SFX).l

FBZBossSK_HalfTurnSoundReturn:
                rts
; End of function FBZBoss_TryHalfTurnSound

; ---------------------------------------------------------------------------

FBZBossSK_ConnectorInterpolateXY:
                movea.w $44(a0),a1
                movea.w parent3(a0),a2
                move.w  x_pos(a1),d0
                move.b  child_dx(a0),d1
                ext.w   d1
                add.w   d0,d1
                move.w  x_pos(a2),d2
                sub.w   d2,d1
                moveq   #$10,d3
                moveq   #0,d4
                move.b  subtype(a0),d4
                bsr.w   PositionFBZEndBossConnectorAxisByQuarter
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                add.w   d0,d1
                move.w  y_pos(a2),d2
                sub.w   d2,d1
                moveq   #$14,d3
                bsr.w   PositionFBZEndBossConnectorAxisByQuarter
                tst.b   $3C(a2)
                beq.s   FBZBossSK_ConnectorPhaseQueueReturn
                bmi.s   FBZBossSK_ConnectorPhaseQueueReturn
                move.w  FBZBossSK_ConnectorPhaseQueueWords(pc,d4.w),priority(a0)

FBZBossSK_ConnectorPhaseQueueReturn:
                rts
; ---------------------------------------------------------------------------
FBZBossSK_ConnectorPhaseQueueWords:
                dc.w    $180
                dc.w    $100
                dc.w    $80
                dc.w    0

; =============== S U B R O U T I N E =======================================

PositionFBZEndBossConnectorAxisByQuarter:
                move.w  FBZBossSK_ConnectorFractionOffsets(pc,d4.w),d5
                jmp     FBZBossSK_ConnectorFractionOffsets(pc,d5.w)
; End of function PositionFBZEndBossConnectorAxisByQuarter

; ---------------------------------------------------------------------------
FBZBossSK_ConnectorFractionOffsets:
                dc.w    FBZBossSK_ConnectorQuarterDelta-FBZBossSK_ConnectorFractionOffsets
                dc.w    FBZEndBossSK_Connector_HalfSignedDelta-FBZBossSK_ConnectorFractionOffsets
                dc.w    FBZBossSK_ConnectorThreeQuarterDelta-FBZBossSK_ConnectorFractionOffsets
                dc.w    FBZBossSK_ConnectorStoreInterpolatedAxis-FBZBossSK_ConnectorFractionOffsets
; ---------------------------------------------------------------------------

FBZBossSK_ConnectorQuarterDelta:
                asr.w   #2,d1
                bra.w   FBZBossSK_ConnectorStoreInterpolatedAxis
; ---------------------------------------------------------------------------

FBZEndBossSK_Connector_HalfSignedDelta:
                asr.w   #1,d1
                bra.w   FBZBossSK_ConnectorStoreInterpolatedAxis
; ---------------------------------------------------------------------------

FBZBossSK_ConnectorThreeQuarterDelta:
                asr.w   #1,d1
                move.w  d1,d0
                asr.w   #1,d1
                add.w   d0,d1

FBZBossSK_ConnectorStoreInterpolatedAxis:
                add.w   d1,d2
                move.w  d2,(a0,d3.w)
                rts

; =============== S U B R O U T I N E =======================================

InitializeFBZEndBossFlameColumnPart:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  FBZBossSK_FlamePartWaits(pc,d0.w),$2E(a0)
                move.w  FBZBossSK_FlamePartOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                add.w   d0,d0
                move.l  FBZBossSK_FlamePartAnimationPointers(pc,d0.w),$30(a0)
                movea.l FBZBossSK_FlamePartAttributePointers(pc,d0.w),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #4,shield_reaction(a0)
                jmp     (Refresh_ChildPosition).l
; End of function InitializeFBZEndBossFlameColumnPart

; ---------------------------------------------------------------------------
FBZBossSK_FlamePartWaits:
                dc.w    $50
                dc.w    $4D
                dc.w    $4A
                dc.w    $47
                dc.w    $44
                dc.w    $41
                dc.w    $3E
                dc.w    $3B
                dc.w    0
FBZBossSK_FlamePartOffsets:
                dc.b    0,-$68
                dc.b    8,-$5C
                dc.b    -8,-$5C
                dc.b    0,-$4C
                dc.b    0,-$3C
                dc.b    0,-$2C
                dc.b    0,-$1C
                dc.b    0, -$C
                dc.b    0,-$10
FBZBossSK_FlamePartAnimationPointers:
                dc.l    FBZBossSK_FlameAnimation
                dc.l    FBZBossSK_FlameAnimation
                dc.l    FBZBossSK_FlameAnimation
                dc.l    FBZBossSK_FlameExplosionAnimation
                dc.l    FBZBossSK_FlameExplosionAnimation
                dc.l    FBZBossSK_FlameExplosionAnimation
                dc.l    FBZBossSK_FlameExplosionAnimation
                dc.l    FBZBossSK_FlameExplosionAnimation
                dc.l    FBZBossSK_FlameBodyAnimation
FBZBossSK_FlamePartAttributePointers:
                dc.l    FBZBossSK_FlameAttributes
                dc.l    FBZBossSK_FlameAttributes
                dc.l    FBZBossSK_FlameAttributes
                dc.l    FBZBossSK_FlameExplosionAttributes
                dc.l    FBZBossSK_FlameExplosionAttributes
                dc.l    FBZBossSK_FlameExplosionAttributes
                dc.l    FBZBossSK_FlameExplosionAttributes
                dc.l    FBZBossSK_FlameExplosionAttributes
                dc.l    FBZBossSK_FlameBodyAttributes

; =============== S U B R O U T I N E =======================================

CenterFBZEndBossXBetweenSupports:
                movea.w $44(a0),a1
                movea.w parent3(a0),a2
                move.w  x_pos(a1),d0
                move.w  x_pos(a2),d1
                sub.w   d0,d1
                asr.w   #1,d1
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                rts
; End of function CenterFBZEndBossXBetweenSupports

; =============== S U B R O U T I N E =======================================

SetFBZEndBossBodyDepthFromPhase:
                tst.b   $3C(a0)
                beq.s   FBZBossSK_DepthSetPriority
                bmi.s   FBZBossSK_DepthClearPriority
                bset    #7,art_tile(a0)
                move.w  #0,priority(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_DepthClearPriority:
                bclr    #7,art_tile(a0)
                move.w  #$300,priority(a0)
                rts
; ---------------------------------------------------------------------------

FBZBossSK_DepthSetPriority:
                bset    #7,art_tile(a0)
                move.w  #$300,priority(a0)
                rts
; End of function SetFBZEndBossBodyDepthFromPhase

; =============== S U B R O U T I N E =======================================

SetFBZEndBossHingeDepthFromPhase:
                tst.b   $3C(a0)
                beq.s   FBZBossSK_DepthSetPriority
                bmi.s   FBZBossSK_DepthClearPriority
                bset    #7,art_tile(a0)
                move.w  #$200,priority(a0)
                rts
; End of function SetFBZEndBossHingeDepthFromPhase

; =============== S U B R O U T I N E =======================================

HandleFBZEndBossFourColorHitOrDefeat:
                tst.l   (a0)
                beq.s   FBZBossSK_HitUpdateReturn
                tst.b   collision_flags(a0)
                bne.s   FBZBossSK_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   FBZBossSK_BeginScoredDefeatAlignment
                tst.b   $20(a0)
                bne.s   FBZBossSK_HitChooseFlashRow
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

FBZBossSK_HitChooseFlashRow:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   FBZBossSK_HitCopyColorsAndTick
                addq.w  #2*4,d0

FBZBossSK_HitCopyColorsAndTick:
                lea     FBZBossSK_HitPaletteDestinations(pc),a1
                lea     FBZEndBossSK_Hit_TwoFourColorSourceRows(pc,d0.w),a2
                jsr     (CopyWordData_4).l
                subq.b  #1,$20(a0)
                bne.s   FBZBossSK_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

FBZBossSK_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

FBZBossSK_BeginScoredDefeatAlignment:
                move.l  #FBZBossSK_DefeatAlignOrbitToZero,(a0)
                jmp     (BossDefeated_StopTimer).l
; End of function HandleFBZEndBossFourColorHitOrDefeat

; ---------------------------------------------------------------------------
FBZBossSK_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$06, Normal_palette_line_2+$08, Normal_palette_line_2+$12, Normal_palette_line_2+$1C
FBZEndBossSK_Hit_TwoFourColorSourceRows:
                dc.w    $2A,   $26,   $20,  $644
                dc.w    $888,  $AAA,  $EEE,  $AAA
