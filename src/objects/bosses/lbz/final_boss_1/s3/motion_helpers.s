; Owner: objects/bosses/lbz/final_boss_1/s3
; Responsibility: Launch Base first final boss motion, collision, hit response and child positioning helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

AdvanceLBZFinalBoss1CannonTurnCycle:
                moveq   #0,d0
                move.b  $39(a0),d0
                subq.w  #1,$2E(a0)
                bmi.s   LBZBoss1S3_CannonTurnFromRootFlip
                add.w   d0,d0
                bra.w   LBZBoss1S3_CannonApplySectionOffset
; ---------------------------------------------------------------------------

LBZBoss1S3_CannonTurnFromRootFlip:
                movea.w $44(a0),a1
                btst    #0,render_flags(a1)
                sne     d2
                beq.s   LBZBoss1S3_CannonStepAndWrapPhase
                subq.b  #1,d0
                bpl.s   LBZBoss1S3_CannonStorePhaseAndDecodeFlip
                moveq   #$B,d0
                bra.w   LBZBoss1S3_CannonStorePhaseAndDecodeFlip
; ---------------------------------------------------------------------------

LBZBoss1S3_CannonStepAndWrapPhase:
                addq.b  #1,d0
                cmpi.b  #$C,d0
                blo.s   LBZBoss1S3_CannonStorePhaseAndDecodeFlip
                moveq   #0,d0

LBZBoss1S3_CannonStorePhaseAndDecodeFlip:
                move.b  d0,$39(a0)
                lea     LBZBoss1S3_CannonFrameFlipBytes(pc),a2
                move.b  (a2,d0.w),d1
                bset    #0,render_flags(a0)
                bclr    #7,d1
                bne.s   LBZBoss1S3_CannonCheckChargeWindow
                bclr    #0,render_flags(a0)
                not.b   d2

; Open the firing window for cannon frame 4. Spawn a charge only when the mode permits
LBZBoss1S3_CannonCheckChargeWindow:
                bclr    #3,$38(a1)
                cmpi.b  #4,d1
                bne.s   LBZBoss1S3_CannonLoadFrameAndWait
                bset    #3,$38(a1)
                tst.b   d2
                beq.s   LBZBoss1S3_CannonLoadFrameAndWait
                movem.l d0-d1,-(sp)
                lea     LBZBoss1S3_CannonChargeChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                movem.l (sp)+,d0-d1

LBZBoss1S3_CannonLoadFrameAndWait:
                move.b  d1,mapping_frame(a0)
                add.w   d0,d0
                move.w  LBZBoss1S3_CannonPhaseWaits(pc,d0.w),$2E(a0)

LBZBoss1S3_CannonApplySectionOffset:
                lea     LBZBoss1S3_CannonPositionOffsets(pc,d0.w),a1
                movea.w parent3(a0),a2
                move.b  (a1)+,d1
                ext.w   d1
                move.w  x_pos(a2),d2
                add.w   d1,d2
                move.w  d2,x_pos(a0)
                move.b  (a1)+,d1
                ext.w   d1
                move.w  y_pos(a2),d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                rts
; End of function AdvanceLBZFinalBoss1CannonTurnCycle

; ---------------------------------------------------------------------------
LBZBoss1S3_CannonFrameFlipBytes:
                dc.b    3|$80
                dc.b    4|$80
                dc.b    5|$80
                dc.b    6|$80
                dc.b    7|$80
                dc.b    8|$80
                dc.b    7
                dc.b    6
                dc.b    5
                dc.b    4
                dc.b    3
                dc.b    $2D
                even
LBZBoss1S3_CannonPhaseWaits:
                dc.w    7
                dc.w    $5F
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    $5F
                dc.w    7
                dc.w    $27
LBZBoss1S3_CannonPositionOffsets:
                dc.b    $27,  -8
                dc.b    $24,  -8
                dc.b    $24,  -8
                dc.b    $14,  -8
                dc.b    $C,  -8
                dc.b    0,  -8
                dc.b    -$C,  -8
                dc.b    -$14,  -8
                dc.b    -$24,  -8
                dc.b    -$24,  -8
                dc.b    -$27,  -8

; =============== S U B R O U T I N E =======================================

RandomizeLBZFinalBoss1LaserTrailOffset:
                jsr     (Random_Number).l
                swap    d0
                andi.b  #7,d0
                addi.b  #$18,d0
                move.b  d0,child_dx(a1)
                rts
; End of function RandomizeLBZFinalBoss1LaserTrailOffset

; =============== S U B R O U T I N E =======================================

; A hit freezes and flashes the root and speeds its vertical movement. Request body-section loss at five and one HP
LBZBoss1_HandleHitOrDefeat:
                tst.b   collision_flags(a0)
                bne.w   LBZBoss1S3_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.w   LBZBoss1S3_BeginScoredDefeatHandoff
                tst.b   $20(a0)
                bne.s   LBZBoss1S3_HitChooseFlashRow
                move.b  routine(a0),$3A(a0)
                move.b  #6,routine(a0)
                move.b  #$20,$20(a0)
                bset    #6,status(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                move.w  y_vel(a0),d0
                asl.w   #1,d0
                cmpi.w  #-$800,d0
                blt.s   LBZBoss1S3_HitCheckSectionThresholds
                cmpi.w  #$800,d0
                bgt.s   LBZBoss1S3_HitCheckSectionThresholds
                move.w  d0,y_vel(a0)

; Drop a section at five and one remaining hit. One remaining hit also sets root bit 3
LBZBoss1S3_HitCheckSectionThresholds:
                cmpi.b  #5,collision_property(a0)
                beq.s   LBZBoss1S3_HitBeginNextSectionDrop
                cmpi.b  #1,collision_property(a0)
                bne.s   LBZBoss1S3_HitChooseFlashRow
                bset    #3,$38(a0)

LBZBoss1S3_HitBeginNextSectionDrop:
                move.w  $3C(a0),d0
                bset    d0,$38(a0)
                addq.w  #1,$3C(a0)
                move.b  #8,routine(a0)
                move.b  #$F,$40(a0)
                bset    #5,status(a0)
                lea     LBZBoss1S3_HitOverlayChildren(pc),a2
                jsr     CreateChild1_Normal(pc)

LBZBoss1S3_HitChooseFlashRow:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   LBZBoss1S3_HitCopyColorsAndTick
                addi.w  #2*2,d0

LBZBoss1S3_HitCopyColorsAndTick:
                bsr.w   CopyLBZFinalBoss1TwoColorPalette
                subq.b  #1,$20(a0)
                bne.s   LBZBoss1S3_HitUpdateReturn
                move.b  $3A(a0),routine(a0)
                move.w  #$EEE,(Normal_palette_line_2+2).w
                move.b  $25(a0),collision_flags(a0)
                bclr    #6,status(a0)

LBZBoss1S3_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss1S3_BeginScoredDefeatHandoff:
                jsr     BossDefeated(pc)
                move.b  #5,mapping_frame(a0)
                bset    #6,status(a0)
                bset    #7,status(a0)
                clr.b   collision_flags(a0)
                move.w  $3C(a0),d0
                bset    d0,$38(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                move.b  #4,subtype(a1)
                tst.b   (BossSceneResetBaseAndRetainedGate+1).w
                bne.s   LBZBoss1S3_BeginAlternateExit
                move.l  #LBZBoss1S3_DescendToHandoffHeight,(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss1S3_BeginAlternateExit:
                move.l  #LBZBoss1S3_AltExitRiseAboveCamera,(a0)
                lea     LBZBoss1S3_AlternateUndersideChild(pc),a2
                jmp     CreateChild1_Normal(pc)
; End of function LBZBoss1_HandleHitOrDefeat

; =============== S U B R O U T I N E =======================================

CopyLBZFinalBoss1TwoColorPalette:
                lea     LBZBoss1S3_HitPaletteDestinations(pc),a1
                lea     LBZBoss1S3_HitPaletteColorRows(pc,d0.w),a2
                jmp     CopyWordData_2(pc)
; End of function CopyLBZFinalBoss1TwoColorPalette

; ---------------------------------------------------------------------------
LBZBoss1S3_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$1C
LBZBoss1S3_HitPaletteColorRows:
                dc.w    $26,   $20
                dc.w    $EEE,  $EEE

; =============== S U B R O U T I N E =======================================

BreakOrSuspendLBZFinalBoss1BodySection:
                movea.w parent3(a0),a1
                move.w  $3C(a0),d0
                btst    d0,$38(a1)
                beq.s   LBZBoss1S3_SectionCheckHitSuspension
                move.l  #LBZBoss1S3_SectionDebrisFourFrames,$3E(a0)
                bset    #7,status(a0)
                lea     (LBZBoss1S3_BreakupFourDebrisChildren).l,a2
                cmpi.w  #2,d0
                bne.s   LBZBoss1S3_BreakSectionAndTryExplosion
                move.l  #LBZBoss1S3_SectionDebrisSixFrames,$3E(a0)
                lea     (LBZBoss1S3_BreakupSixDebrisChildren).l,a2

LBZBoss1S3_BreakSectionAndTryExplosion:
                move.w  #$10,$2E(a0)
                move.l  #LBZBoss1S3_DeleteBrokenSection,(a0)
                jsr     CreateChild1_Normal(pc)
                lea     (Child6_CreateBossExplosion).l,a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

LBZBoss1S3_SectionCheckHitSuspension:
                btst    #6,status(a1)
                beq.s   LBZBoss1S3_SectionUnbrokenReturn
                move.l  #LBZBoss1S3_SectionWaitHitAndAdjust,(a0)

LBZBoss1S3_SectionUnbrokenReturn:
                rts
; End of function BreakOrSuspendLBZFinalBoss1BodySection

; =============== S U B R O U T I N E =======================================

; Choose the frame from the parent's selected row and velocity from the fragment subtype
LBZBoss1Debris_InitFrameAndVel:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d1
                movea.w parent3(a0),a1
                movea.l $3E(a1),a1
                move.b  (a1,d1.w),mapping_frame(a0)
                add.w   d0,d0
                lea     LBZBoss1S3_SectionDebrisVelocities(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; End of function LBZBoss1Debris_InitFrameAndVel

; ---------------------------------------------------------------------------
LBZBoss1S3_SectionDebrisVelocities:
                dc.w    -$100, -$200
                dc.w    $100, -$200
                dc.w    -$200, -$100
                dc.w    $200, -$100
                dc.w    -$300, -$300
                dc.w    $300, -$300
LBZBoss1S3_SectionDebrisFourFrames:
                dc.b    $23
                dc.b    $25
                dc.b    $24
                dc.b    $26
LBZBoss1S3_SectionDebrisSixFrames:
                dc.b    $27
                dc.b    $29
                dc.b    $28
                dc.b    $2A
                dc.b    $2B
                dc.b    $2C
                even
