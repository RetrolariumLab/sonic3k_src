; Owner: objects/bosses/fbz/miniboss/sk
; Responsibility: Flying Battery miniboss motion, collision, hit response and child positioning helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

FBZMini_SolidBodyOrCapsule:
                moveq   #$23,d1
                moveq   #$20,d2
                moveq   #$1C,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function FBZMini_SolidBodyOrCapsule

; =============== S U B R O U T I N E =======================================

SolidifyFBZMinibossTopButton:
                moveq   #$1B,d1
                moveq   #8,d2
                moveq   #$D,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function SolidifyFBZMinibossTopButton

; ---------------------------------------------------------------------------

FBZMiniSK_TrimLoadDelayAndVelocity:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  FBZMiniSK_TrimSeparationDelays(pc,d0.w),$2E(a0)
                add.w   d0,d0
                lea     FBZMiniSK_TrimVelocityFieldPairs(pc,d0.w),a1
                move.w  (a1)+,d1
                move.w  (a1)+,(a0,d1.w)
                rts
; ---------------------------------------------------------------------------
FBZMiniSK_TrimSeparationDelays:
                dc.w    $20
                dc.w    $20
                dc.w    $40
FBZMiniSK_TrimVelocityFieldPairs:
                dc.w    x_vel,  -$40
                dc.w    x_vel,   $40
                dc.w    y_vel,   $40

; =============== S U B R O U T I N E =======================================

SetFBZMinibossLinkDeploymentVelocity:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  FBZMiniSK_LinkDeploymentVelocities-2(pc,d0.w),d0
                move.w  d0,x_vel(a0)
                move.w  d0,y_vel(a0)
                rts
; End of function SetFBZMinibossLinkDeploymentVelocity

; ---------------------------------------------------------------------------
FBZMiniSK_LinkDeploymentVelocities:
                dc.w    -$C0
                dc.w    -$180
                dc.w    -$240
                dc.w    -$300
                dc.w    -$3C0
                dc.w    -$530

; =============== S U B R O U T I N E =======================================

OscillateFBZMinibossArmAngle:
                move.b  $3C(a0),d0
                moveq   #0,d1
                btst    #0,render_flags(a0)
                beq.s   FBZMiniSK_OscillationChooseBound
                addq.w  #2,d1

FBZMiniSK_OscillationChooseBound:
                move.b  $40(a0),d2
                bmi.s   FBZMiniSK_OscillationCheckLowerBound
                move.b  FBZMiniSK_OscillationBoundsByFlip(pc,d1.w),d3
                cmp.b   d3,d0
                bhs.s   FBZMiniSK_OscillationReverseStep
                bra.w   FBZMiniSK_OscillationStoreStepAndAngle
; ---------------------------------------------------------------------------

FBZMiniSK_OscillationCheckLowerBound:
                addq.w  #1,d1
                move.b  FBZMiniSK_OscillationBoundsByFlip(pc,d1.w),d3
                cmp.b   d3,d0
                bhi.s   FBZMiniSK_OscillationStoreStepAndAngle

FBZMiniSK_OscillationReverseStep:
                neg.b   d2

FBZMiniSK_OscillationStoreStepAndAngle:
                move.b  d2,$40(a0)
                add.b   d2,d0
                move.b  d0,$3C(a0)
                rts
; End of function OscillateFBZMinibossArmAngle

; ---------------------------------------------------------------------------
FBZMiniSK_OscillationBoundsByFlip:
                dc.b    $B0
                dc.b    $80
                dc.b    $80
                dc.b    $50
                even

; =============== S U B R O U T I N E =======================================

ExtendFBZMinibossArmToSideAngle:
                btst    #0,render_flags(a0)
                bne.s   FBZMiniSK_SideAngleDecreaseFlipped
                addq.b  #2,$3C(a0)
                moveq   #-$40,d0
                cmp.b   $3C(a0),d0
                bhi.s   FBZMiniSK_SideAnglePendingReturn

FBZMiniSK_SideAngleClampAndReturn:
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_SideAngleDecreaseFlipped:
                subq.b  #2,$3C(a0)
                moveq   #$40,d0
                cmp.b   $3C(a0),d0
                bhs.s   FBZMiniSK_SideAngleClampAndReturn

FBZMiniSK_SideAnglePendingReturn:
                moveq   #0,d0
                rts
; End of function ExtendFBZMinibossArmToSideAngle

; =============== S U B R O U T I N E =======================================

FoldFBZMinibossLinksForBodyStrike:
                move.b  $3C(a0),d0
                moveq   #0,d1
                move.b  subtype(a0),d1
                movea.w parent3(a0),a1
                move.b  $40(a1),d2
                move.b  d2,$40(a0)
                lsr.w   #1,d1
                btst    #0,render_flags(a0)
                bne.s   FBZMiniSK_FoldAdvanceFlippedAngle
                move.b  FBZMiniSK_FoldTargetsUnflipped-1(pc,d1.w),d3
                sub.b   d2,d0
                cmp.b   d3,d0
                bls.s   FBZMiniSK_FoldClampAndSignalHit
                bra.w   FBZMiniSK_FoldStoreAngle
; ---------------------------------------------------------------------------

FBZMiniSK_FoldAdvanceFlippedAngle:
                move.b  FBZMiniSK_FoldTargetsFlipped-1(pc,d1.w),d3
                add.b   d2,d0
                cmp.b   d3,d0
                blo.s   FBZMiniSK_FoldStoreAngle

; When the terminal link reaches its fold target, signal the miniboss to take the self-hit
FBZMiniSK_FoldClampAndSignalHit:
                move.b  d3,d0
                move.b  d4,routine(a0)
                addq.b  #2,$40(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   FBZMiniSK_FoldStoreAngle
                movea.w $44(a0),a1
                movea.w parent3(a1),a1
                bset    #2,$38(a1)
                bset    #6,$3A(a1)

FBZMiniSK_FoldStoreAngle:
                move.b  d0,$3C(a0)
                rts
; End of function FoldFBZMinibossLinksForBodyStrike

; ---------------------------------------------------------------------------
FBZMiniSK_FoldTargetsUnflipped:
                dc.b    $A0, $88, $60, $48, $38
FBZMiniSK_FoldTargetsFlipped:
                dc.b    $60, $78, $90, $B8, $CC
                even

; =============== S U B R O U T I N E =======================================

ReturnFBZMinibossArmToRestAngle:
                btst    #0,render_flags(a0)
                bne.s   FBZMiniSK_RestAngleDecreaseFlipped
                addq.b  #2,$3C(a0)
                moveq   #-$60,d0
                cmp.b   $3C(a0),d0
                bhi.s   FBZMiniSK_RestAnglePendingReturn

FBZMiniSK_RestAngleClampAndReturn:
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_RestAngleDecreaseFlipped:
                subq.b  #2,$3C(a0)
                moveq   #$60,d0
                cmp.b   $3C(a0),d0
                bhs.s   FBZMiniSK_RestAngleClampAndReturn

FBZMiniSK_RestAnglePendingReturn:
                moveq   #0,d0
                rts
; End of function ReturnFBZMinibossArmToRestAngle

; =============== S U B R O U T I N E =======================================

RaiseFBZMinibossArmToVerticalAngle:
                btst    #0,render_flags(a0)
                bne.s   FBZMiniSK_VerticalAngleIncreaseFlipped
                subq.b  #2,$3C(a0)
                moveq   #-$80,d0
                cmp.b   $3C(a0),d0
                blo.s   FBZMiniSK_VerticalAnglePendingReturn

FBZMiniSK_VerticalAngleClampAndReturn:
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_VerticalAngleIncreaseFlipped:
                addq.b  #2,$3C(a0)
                moveq   #-$80,d0
                cmp.b   $3C(a0),d0
                blo.s   FBZMiniSK_VerticalAngleClampAndReturn

FBZMiniSK_VerticalAnglePendingReturn:
                moveq   #0,d0
                rts
; End of function RaiseFBZMinibossArmToVerticalAngle

; ---------------------------------------------------------------------------

FBZMiniSK_HandAimAtSavedTarget:
                move.w  $30(a0),d0
                sub.w   x_pos(a0),d0
                lsl.w   #3,d0
                move.w  d0,x_vel(a0)
                move.w  $32(a0),d0
                sub.w   y_pos(a0),d0
                lsl.w   #3,d0
                move.w  d0,y_vel(a0)
                rts

; =============== S U B R O U T I N E =======================================

; Place the link on the quantized line from the shoulder to the fist
FBZMiniPunch_InterpolateLink:
                movea.w $32(a0),a1
                movea.w $30(a0),a2
                moveq   #0,d2
                move.b  subtype(a0),d2
                lsr.w   #1,d2
                moveq   #0,d0
                move.w  x_pos(a1),d0
                move.w  x_pos(a2),d3
                sub.w   d3,d0
                smi     d1
                bpl.s   FBZMiniSK_PunchScaleLinkX
                neg.w   d0

; Divide the absolute delta by five before multiplying by the link index
FBZMiniSK_PunchScaleLinkX:
                divu.w  #5,d0
                mulu.w  d2,d0
                tst.b   d1
                beq.s   FBZMiniSK_PunchStoreXAndLoadY
                neg.w   d0

FBZMiniSK_PunchStoreXAndLoadY:
                add.w   d0,d3
                move.w  d3,x_pos(a0)
                moveq   #0,d0
                move.w  y_pos(a1),d0
                move.w  y_pos(a2),d3
                sub.w   d3,d0
                smi     d1
                bpl.s   FBZMiniSK_PunchScaleLinkY
                neg.w   d0

; Divide the absolute delta by five before multiplying by the link index
FBZMiniSK_PunchScaleLinkY:
                divu.w  #5,d0
                mulu.w  d2,d0
                tst.b   d1
                beq.s   FBZMiniSK_PunchStoreLinkY
                neg.w   d0

FBZMiniSK_PunchStoreLinkY:
                add.w   d0,d3
                move.w  d3,y_pos(a0)
                rts
; End of function FBZMiniPunch_InterpolateLink

; =============== S U B R O U T I N E =======================================

ProcessFBZMinibossArmSelfHitAndDefeat:
                btst    #6,$3A(a0)
                beq.s   FBZMiniSK_SelfHitUpdateReturn
                tst.b   $20(a0)
                bne.s   FBZMiniSK_SelfHitChooseFlashRow
                subq.b  #1,collision_property(a0)
                beq.s   FBZMiniSK_SelfHitBeginDefeat
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

FBZMiniSK_SelfHitChooseFlashRow:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   FBZMiniSK_SelfHitCopyColorsAndTick
                addq.w  #2*4,d0

FBZMiniSK_SelfHitCopyColorsAndTick:
                lea     FBZMiniSK_SelfHitPaletteDestinations(pc),a1
                lea     FBZMiniSK_SelfHitPaletteColorRows(pc,d0.w),a2
                jsr     (CopyWordData_4).l
                subq.b  #1,$20(a0)
                bne.s   FBZMiniSK_SelfHitUpdateReturn
                bclr    #6,$3A(a0)

FBZMiniSK_SelfHitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_SelfHitBeginDefeat:
                move.l  #FBZMiniSK_DefeatSolidAndTickWait,(a0)
                bset    #7,status(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     (BossDefeated_StopTimer).l
; End of function ProcessFBZMinibossArmSelfHitAndDefeat

; ---------------------------------------------------------------------------
FBZMiniSK_SelfHitPaletteDestinations:
                dc.w    Normal_palette_line_2+$04, Normal_palette_line_2+$08, Normal_palette_line_2+$16, Normal_palette_line_2+$1E
FBZMiniSK_SelfHitPaletteColorRows:
                dc.w    $222,  $644,  $222,   $44
                dc.w    $AAA,  $AAA,  $EEE,  $EEE

; =============== S U B R O U T I N E =======================================

EnterFBZMinibossArmParentDefeatWait:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   FBZMiniSK_ArmBeginDeathWait
                rts
; ---------------------------------------------------------------------------

FBZMiniSK_ArmBeginDeathWait:
                move.l  #FBZMiniSK_DefeatedArmWaitAndDraw,(a0)
                bset    #7,status(a0)
                clr.b   collision_flags(a0)
                rts
; End of function EnterFBZMinibossArmParentDefeatWait
