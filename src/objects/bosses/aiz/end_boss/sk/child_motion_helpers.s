; Owner: objects/bosses/aiz/end_boss/sk
; Responsibility: Angel Island end-boss child positioning, synchronized drawing, animation and spawn helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

AdvanceAIZBossAttackAttachmentPose:
                move.w  angle(a0),d0
                moveq   #0,d1
                eori.w  #$C,d0
                beq.s   AIZBossSK_AttackApplyPoseAndAdvance
                cmpi.w  #$C,d0
                beq.s   AIZBossSK_AttackApplyPoseAndAdvance
                addi.w  #$10,d1

AIZBossSK_AttackApplyPoseAndAdvance:
                moveq   #0,d2
                move.b  $39(a0),d2
                add.w   d2,d1
                lea     AIZBossSK_AttackPoseBanks(pc,d1.w),a1
                move.b  (a1)+,child_dx(a0)
                move.b  (a1)+,child_dy(a0)
                move.b  (a1)+,mapping_frame(a0)
                addq.b  #4,d2
                move.b  d2,$39(a0)
                rts
; End of function AdvanceAIZBossAttackAttachmentPose

; ---------------------------------------------------------------------------
; Two banks of four records store signed X/Y offsets and a mapping frame, padded to even size
AIZBossSK_AttackPoseBanks:
                dc.b    -$18,   8,   5
                even
                dc.b    -$18,   8,   5
                even
                dc.b    -$1C,   0,   4
                even
                dc.b    -$1C,   0,   4
                even
                dc.b    -$18,   8,   5
                even
                dc.b    -$10, $10,   6
                even
                dc.b    -$18,   8,   5
                even
                dc.b    -$1C,   0,   4
                even

; =============== S U B R O U T I N E =======================================

Child_SyncDraw:
                movea.w parent3(a0),a1
                btst    #6,$38(a1)
                bne.s   AIZBossSK_AttachmentInheritHide
                bclr    #6,$38(a0)
                bset    #7,art_tile(a0)
                btst    #7,art_tile(a1)
                bne.s   AIZBossSK_AttachmentSyncReturn
                bclr    #7,art_tile(a0)

AIZBossSK_AttachmentSyncReturn:
                rts
; ---------------------------------------------------------------------------

AIZBossSK_AttachmentInheritHide:
                bset    #6,$38(a0)
                rts
; End of function Child_SyncDraw

; ---------------------------------------------------------------------------

AIZBossSK_AttackSpawnChargeByAngle:
                move.w  angle(a0),d0
                lsr.w   #1,d0
                move.w  AIZBossSK_AttackChargeChildOffsets(pc,d0.w),d0
                lea     AIZBossSK_AttackChargeChildOffsets(pc,d0.w),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
AIZBossSK_AttackChargeChildOffsets:
                dc.w    AIZBossSK_ChargeRightChild-AIZBossSK_AttackChargeChildOffsets
                dc.w    AIZEndBossSK_Emitter_CentralNormalRecord-AIZBossSK_AttackChargeChildOffsets
                dc.w    AIZEndBossSK_Emitter_CentralNormalRecord-AIZBossSK_AttackChargeChildOffsets
                dc.w    AIZBossSK_ChargeLeftChild-AIZBossSK_AttackChargeChildOffsets
; ---------------------------------------------------------------------------

AIZBossSK_ShotChooseFlipFromParent:
                movea.w parent3(a0),a1
                move.w  angle(a1),d0
                cmpi.w  #8,d0
                bhs.s   AIZBossSK_ShotLoadAngleAnimAndMotion
                bset    #0,render_flags(a0)

AIZBossSK_ShotLoadAngleAnimAndMotion:
                move.l  AIZBossSK_ShotAnimationByAngle(pc,d0.w),$30(a0)
                lea     AIZBossSK_ShotSpawnOffsetsByAngle(pc,d0.w),a1
                move.w  (a1)+,d1
                add.w   d1,x_pos(a0)
                move.w  (a1)+,d1
                add.w   d1,y_pos(a0)
                lea     AIZBossSK_ShotVelocityByAngle(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
AIZBossSK_ShotAnimationByAngle:
                dc.l    AIZBossSK_ShotOuterAngleAnim
                dc.l    AIZBossSK_ShotInnerAngleAnim
                dc.l    AIZBossSK_ShotInnerAngleAnim
                dc.l    AIZBossSK_ShotOuterAngleAnim
AIZBossSK_ShotSpawnOffsetsByAngle:
                dc.w    $14,   $14
                dc.w    0,   $18
                dc.w    0,   $18
                dc.w    -$14,   $14
AIZBossSK_ShotVelocityByAngle:
                dc.w    $300,  $300
                dc.w    0,  $400
                dc.w    0,  $400
                dc.w    -$300,  $300

; =============== S U B R O U T I N E =======================================

HandleAIZBossHitFlashOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   AIZBossSK_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   AIZBossSK_BeginScoredDefeatWait
                tst.b   $20(a0)
                bne.s   AIZBossSK_HitChooseFlashRow
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

AIZBossSK_HitChooseFlashRow:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   AIZBossSK_HitCopyColorsAndTick
                addi.w  #2*7,d0

; Restore collision only when the flash ends and the mapping frame is zero
AIZBossSK_HitCopyColorsAndTick:
                bsr.w   CopyAIZBossSevenPaletteColors
                subq.b  #1,$20(a0)
                bne.s   AIZBossSK_HitUpdateReturn
                bclr    #6,status(a0)
                cmpi.b  #0,mapping_frame(a0)
                bne.s   AIZBossSK_HitUpdateReturn
                move.b  $25(a0),collision_flags(a0)

AIZBossSK_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

AIZBossSK_BeginScoredDefeatWait:
                move.l  #Wait_FadeToLevelMusic,(a0)
                bclr    #6,$38(a0)
                bset    #7,art_tile(a0)
                move.b  #0,mapping_frame(a0)
                move.l  #AIZBossSK_BeginDefeatDebris,$34(a0)
                jmp     (BossDefeated_StopTimer).l
; End of function HandleAIZBossHitFlashOrDefeat

; =============== S U B R O U T I N E =======================================

CopyAIZBossSevenPaletteColors:
                lea     AIZBossSK_HitPaletteDestinations(pc),a1
                lea     AIZBossSK_HitPaletteColorRows(pc,d0.w),a2
                jmp     (CopyWordData_7).l
; End of function CopyAIZBossSevenPaletteColors

; ---------------------------------------------------------------------------
AIZBossSK_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$0E, Normal_palette_line_2+$12, Normal_palette_line_2+$14
                dc.w    Normal_palette_line_2+$16, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
AIZBossSK_HitPaletteColorRows:
                dc.w    $222,     8,   $4C,     6,   $20,  $A24,  $622
                dc.w    $AAA,  $AAA,  $AAA,  $CCC,  $EEE,  $666,  $888

; =============== S U B R O U T I N E =======================================

ResetAIZBossHitFlashPalette:
                moveq   #0,d0
                bsr.s   CopyAIZBossSevenPaletteColors
                bclr    #6,status(a0)
                clr.b   $20(a0)
                rts
; End of function ResetAIZBossHitFlashPalette

; =============== S U B R O U T I N E =======================================

StartAIZBossAttachmentDelayedBreakaway:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   AIZBossSK_AttachmentDelayBreakaway
                rts
; ---------------------------------------------------------------------------

; After the boss dies, draw for 32 wait calls before breaking away
AIZBossSK_AttachmentDelayBreakaway:
                move.l  #Wait_Draw,(a0)
                bset    #7,status(a0)
                move.b  #1,mapping_frame(a0)
                move.w  #$1F,$2E(a0)
                move.l  #AIZBossSK_AttachmentBeginBreakaway,$34(a0)
                rts
; End of function StartAIZBossAttachmentDelayedBreakaway
