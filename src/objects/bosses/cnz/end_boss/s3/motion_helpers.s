; Owner: objects/bosses/cnz/end_boss/s3
; Responsibility: Carnival Night end-boss movement, collision, attack and child positioning helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SetCNZBossMagnetDepthFromPhase:
                move.b  $3C(a0),d0
                move.w  #$200,priority(a0)
                addi.b  #$40,d0
                bpl.s   CNZBossMagnet_ReturnAfterDepthSelection
                move.w  #$280,priority(a0)

CNZBossMagnet_ReturnAfterDepthSelection:
                rts
; End of function SetCNZBossMagnetDepthFromPhase

; =============== S U B R O U T I N E =======================================

SelectCNZBossMagnetPhaseFrame:
                cmpi.b  #3,mapping_frame(a0)
                beq.s   CNZBossS3_PhaseFrameReturn
                move.b  $3C(a0),d0
                lea     CNZBossMagnet_PhaseFrameBands(pc),a1
                moveq   #5-1,d6

CNZBossMagnet_FindPhaseFrameBand:
                cmp.b   (a1)+,d0
                blo.s   CNZBossMagnet_ApplyPhaseBandFrame
                addq.w  #1,a1
                dbf     d6,CNZBossMagnet_FindPhaseFrameBand
                rts
; ---------------------------------------------------------------------------

CNZBossMagnet_ApplyPhaseBandFrame:
                move.b  (a1)+,mapping_frame(a0)

CNZBossS3_PhaseFrameReturn:
                rts
; End of function SelectCNZBossMagnetPhaseFrame

; ---------------------------------------------------------------------------
CNZBossMagnet_PhaseFrameBands:
                dc.b    $30,   1
                dc.b    $58,   8
                dc.b    $A8,   2
                dc.b    $D0,   8
                dc.b    $FF,   1
                even

; =============== S U B R O U T I N E =======================================

; Delete when the parent's pulse ends or the parent is defeated
CNZBossSpark_TryDelete:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.s   CNZBossElectricEffect_DeleteForParentEnd
                btst    #7,status(a1)
                bne.s   CNZBossElectricEffect_DeleteForParentEnd
                rts
; ---------------------------------------------------------------------------

CNZBossElectricEffect_DeleteForParentEnd:
                jmp     (Go_Delete_Sprite).l
; End of function CNZBossSpark_TryDelete

; =============== S U B R O U T I N E =======================================

PullBothPlayersWithCNZBossMagnet:
                btst    #2,$38(a0)
                bne.s   CNZEndBoss_ApplyAttractionToBothPlayers
                rts
; ---------------------------------------------------------------------------

CNZEndBoss_ApplyAttractionToBothPlayers:
                lea     (Player_1).w,a1
                bsr.w   DisplacePlayerTowardCNZBossMagnet
                lea     (Player_2).w,a1
; End of function PullBothPlayersWithCNZBossMagnet

; =============== S U B R O U T I N E =======================================

DisplacePlayerTowardCNZBossMagnet:
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                spl     d1
                bpl.s   CNZBossS3_QuantizeMagnetDistance
                neg.w   d0

; Quantize in $40-pixel steps and clamp at $1C0 before indexing the displacement table
CNZBossS3_QuantizeMagnetDistance:
                andi.w  #$FFC0,d0
                cmpi.w  #$1C0,d0
                blo.s   CNZBossS3_LoadSignedMagnetPull
                move.w  #$1C0,d0

CNZBossS3_LoadSignedMagnetPull:
                lsr.w   #4,d0
                move.l  CNZBossS3_MagnetPullByDistance(pc,d0.w),d2
                tst.b   d1
                bne.s   CNZEndBoss_ApplyAttractionXDisplacement
                neg.l   d2

CNZEndBoss_ApplyAttractionXDisplacement:
                add.l   d2,x_pos(a1)
                rts
; End of function DisplacePlayerTowardCNZBossMagnet

; ---------------------------------------------------------------------------
CNZBossS3_MagnetPullByDistance:
                dc.l    $28000
                dc.l    $20000
                dc.l    $1C000
                dc.l    $18000
                dc.l    $14000
                dc.l    $10000
                dc.l    $C000
                dc.l    $8000

; =============== S U B R O U T I N E =======================================

HandleCNZEndBossFourColorHitOrDefeat:
                tst.l   (a0)
                beq.s   CNZEndBoss_ReturnFromHitOrDefeatCheck
                tst.b   collision_flags(a0)
                bne.s   CNZEndBoss_ReturnFromHitOrDefeatCheck
                tst.b   collision_property(a0)
                beq.s   CNZEndBoss_InstallDefeatWait
                tst.b   $20(a0)
                bne.s   CNZEndBoss_SelectHitFlashPalette
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

CNZEndBoss_SelectHitFlashPalette:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   CNZEndBoss_CopyHitFlashAndCountDown
                addq.w  #2*4,d0

CNZEndBoss_CopyHitFlashAndCountDown:
                lea     CNZEndBoss_HitFlashPaletteDestinations(pc),a1
                lea     CNZEndBoss_HitFlashColorSets(pc,d0.w),a2
                jsr     (CopyWordData_4).l
                subq.b  #1,$20(a0)
                bne.s   CNZEndBoss_ReturnFromHitOrDefeatCheck
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

CNZEndBoss_ReturnFromHitOrDefeatCheck:
                rts
; ---------------------------------------------------------------------------

CNZEndBoss_InstallDefeatWait:
                move.l  #Wait_Draw,(a0)
                move.l  #CNZEndBoss_BeginDefeatBreakup,$34(a0)
                jmp     (BossDefeated_StopTimer).l
; End of function HandleCNZEndBossFourColorHitOrDefeat

; ---------------------------------------------------------------------------
CNZEndBoss_HitFlashPaletteDestinations:
                dc.w    Normal_palette_line_2+$12, Normal_palette_line_2+$14, Normal_palette_line_2+$16, Normal_palette_line_2+$1C
CNZEndBoss_HitFlashColorSets:
                dc.w    $60,   $20,   $20,  $640
                dc.w    $888,  $EEE,  $EEE,  $AAA

; =============== S U B R O U T I N E =======================================

BreakCNZBossDroppedCoreWhenParentDefeats:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   CNZBossCore_CheckParentBreakupFlag
                clr.b   collision_flags(a0)

CNZBossCore_CheckParentBreakupFlag:
                btst    #4,$38(a1)
                bne.s   CNZBossCore_SpawnDefeatFragments
                rts
; ---------------------------------------------------------------------------

CNZBossCore_SpawnDefeatFragments:
                move.l  #Delete_Current_Sprite,(a0)
                lea     CNZBossCore_FragmentChildRecords(pc),a2
                jmp     CreateChild1_Normal(pc)
; End of function BreakCNZBossDroppedCoreWhenParentDefeats

; =============== S U B R O U T I N E =======================================

DetachCNZBossMagnetAfterParentDefeat:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   CNZBossMagnet_CheckParentBreakupFlag
                clr.b   collision_flags(a0)

CNZBossMagnet_CheckParentBreakupFlag:
                btst    #4,$38(a1)
                bne.s   CNZBossMagnet_DetachIntoDefeatMotion
                rts
; ---------------------------------------------------------------------------

CNZBossMagnet_DetachIntoDefeatMotion:
                bset    #7,status(a0)
                move.b  #1,mapping_frame(a0)
                clr.b   collision_flags(a0)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                jmp     Set_IndexedVelocity(pc)
; End of function DetachCNZBossMagnetAfterParentDefeat
