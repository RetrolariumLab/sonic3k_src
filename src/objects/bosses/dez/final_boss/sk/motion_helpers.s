; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss movement, collision, palette, parent-state and damage helpers with private lookup constants
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

UpdateDEZEscapeShipHitFlashAndDefeatWait:
                tst.b   collision_flags(a0)
                bne.s   DEZFinal_EscapeHitReturn
                move.b  collision_property(a0),d0
                beq.s   DEZFinal_EscapeBeginDefeatWait
                tst.b   $20(a0)
                bne.s   DEZFinal_EscapeHitChooseFlashOffset
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)
                btst    #7,$38(a0)
                beq.s   DEZFinal_EscapeHitChooseFlashOffset
                lea     (Player_1).w,a1
                tst.b   $1C(a0)
                beq.s   DEZFinal_EscapeHitClearPlayerXSpeed
                lea     (Player_2).w,a1

DEZFinal_EscapeHitClearPlayerXSpeed:
                clr.w   x_vel(a1)
                clr.w   ground_vel(a1)

; The parity path skips two colors, while the reader copies three
DEZFinal_EscapeHitChooseFlashOffset:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   DEZFinal_EscapeHitCopyColorsAndTick
; Bug: this should be 2*3
                addi.w  #2*2,d0

DEZFinal_EscapeHitCopyColorsAndTick:
                bsr.w   DEZEscapeShip_CopyPalette3
                subq.b  #1,$20(a0)
                bne.s   DEZFinal_EscapeHitReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)
                cmpi.b  #8,routine(a0)
                blo.s   DEZFinal_EscapeHitReturn
                move.w  #$800,x_vel(a0)

DEZFinal_EscapeHitReturn:
                rts
; ---------------------------------------------------------------------------

DEZFinal_EscapeBeginDefeatWait:
                move.l  #Wait_Draw,(a0)
                move.w  #$2F,$2E(a0)
                move.l  #DEZFinal_SignalFirstEscapeDefeat,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DEZFinal_EscapeAwardDefeatScore
                move.b  #4,subtype(a1)

DEZFinal_EscapeAwardDefeatScore:
                moveq   #100,d0
                jsr     (HUD_AddToScore).l
                rts
; End of function UpdateDEZEscapeShipHitFlashAndDefeatWait

; =============== S U B R O U T I N E =======================================

; d0.w supplies the source byte offset for the three fixed destinations
DEZEscapeShip_CopyPalette3:
                lea     DEZEscapeShipHit_PaletteDestinationWords(pc),a1
                lea     DEZFinal_EscapeHitPaletteColors(pc,d0.w),a2
                jmp     CopyWordData_3(pc)
; End of function DEZEscapeShip_CopyPalette3

; ---------------------------------------------------------------------------
DEZEscapeShipHit_PaletteDestinationWords:
                dc.w    Normal_palette+$0E, Normal_palette+$1C, Normal_palette+$1E
DEZFinal_EscapeHitPaletteColors:
                dc.w    8,  $866,  $222
                dc.w    $888,  $CCC,  $EEE

; =============== S U B R O U T I N E =======================================

DEZEscape_TryFallingDebrisEvery16:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   DEZFinal_EscapeDebrisSpawnReturn
                jsr     (AllocateObject).l
                bne.s   DEZFinal_EscapeDebrisSpawnReturn
                move.l  #DEZFinal_InitEscapeDebris,(a1)

DEZFinal_EscapeDebrisSpawnReturn:
                rts
; End of function DEZEscape_TryFallingDebrisEvery16

; =============== S U B R O U T I N E =======================================

; Advance X using the 16.16 speed accumulator, then set both horizontal limits from the integer result
DEZEscape_AccelAndLockCameraX:
                move.l  (_unkFA84).w,d0
                addi.l  #$1000,d0
                cmpi.l  #$40000,d0
                bhi.s   DEZFinal_MoveAndLockEscapeCamera
                move.l  d0,(_unkFA84).w

DEZFinal_MoveAndLockEscapeCamera:
                move.l  (Camera_X_pos).w,d1
                add.l   d0,d1
                move.l  d1,(Camera_X_pos).w
                swap    d1
                move.w  d1,(Camera_min_X_pos).w
                move.w  d1,(Camera_max_X_pos).w
                rts
; End of function DEZEscape_AccelAndLockCameraX

; =============== S U B R O U T I N E =======================================

; On status bit 7, install the defeat drift and discard the return address to skip the rest of this state
DEZFinalWorld_TryBeginDefeat:
                btst    #7,status(a0)
                beq.s   DEZFinal_WorldDefeatReturn
                move.l  #DEZFinal_MoveDefeatedWorldToExitY,(a0)
                move.w  #$80,x_vel(a0)
                move.w  #$80,y_vel(a0)
                jsr     (AllocateObject).l
                bne.s   DEZFinal_WorldDefeatTryFirstExplosion
                move.l  #SKLevel_InitializeScreenShakeRumbleActor,(a1)

DEZFinal_WorldDefeatTryFirstExplosion:
                bclr    #5,$38(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DEZFinal_WorldDefeatTrySecondExplosion
                move.b  #$16,subtype(a1)

DEZFinal_WorldDefeatTrySecondExplosion:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DEZFinal_LoadShipArtAndAbortUpdate
                move.b  #$16,subtype(a1)

DEZFinal_LoadShipArtAndAbortUpdate:
                lea     PLC_DEZ3_Boss(pc),a1
                jsr     (Load_PLC_Raw).l
                addq.w  #4,sp

DEZFinal_WorldDefeatReturn:
                rts
; End of function DEZFinalWorld_TryBeginDefeat

; ---------------------------------------------------------------------------
PLC_DEZ3_Boss:  plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
PLC_DEZ3_Boss_End:

; =============== S U B R O U T I N E =======================================

HurtPlayersInsideDEZFinalBeamActiveFrame:
                cmpi.b  #$1E,mapping_frame(a0)
                bne.s   DEZFinal_BeamRangeCheckReturn
                lea     DEZFinal_BeamContactBounds(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   DEZFinal_BeamRangeCheckReturn
                tst.w   d0
                beq.s   DEZFinal_BeamCheckPackedP2
                movea.w d0,a1
                tst.b   invulnerability_timer(a1)
                bne.s   DEZFinal_BeamCheckPackedP2
                btst    #Status_Invincible,status_secondary(a1)
                bne.s   DEZFinal_BeamCheckPackedP2
                move.l  d0,-(sp)
                jsr     HurtCharacter_Directly(pc)
                move.l  (sp)+,d0

DEZFinal_BeamCheckPackedP2:
                swap    d0
                tst.w   d0
                beq.s   DEZFinal_BeamRangeCheckReturn
                movea.w d0,a1
                tst.b   invulnerability_timer(a1)
                bne.s   DEZFinal_BeamRangeCheckReturn
                btst    #Status_Invincible,status_secondary(a1)
                bne.s   DEZFinal_BeamRangeCheckReturn
                jsr     HurtCharacter_Directly(pc)

DEZFinal_BeamRangeCheckReturn:
                rts
; End of function HurtPlayersInsideDEZFinalBeamActiveFrame

; ---------------------------------------------------------------------------
DEZFinal_BeamContactBounds:
                dc.w    0,  $120,  -$20,   $40

; =============== S U B R O U T I N E =======================================

DEZFinal_TryChargeParticleEvery4:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   DEZFinal_ChargeParticleSpawnReturn
                lea     DEZFinalChargeParticle_SimpleChildRecord(pc),a2
                jsr     CreateChild6_Simple(pc)

DEZFinal_ChargeParticleSpawnReturn:
                rts
; End of function DEZFinal_TryChargeParticleEvery4

; =============== S U B R O U T I N E =======================================

; Pin both X limits at world X plus $40 and advance actual camera X by one pixel
DEZFinal_LockBoundsAndNudgeCamera:
                move.w  x_pos(a0),d0
                addi.w  #$40,d0
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                addq.w  #1,(Camera_X_pos).w
                rts
; End of function DEZFinal_LockBoundsAndNudgeCamera

; =============== S U B R O U T I N E =======================================

; Add the two signed word offsets to the parent's integer coordinates
DEZFinalChild_SetPosFromParent:
                movea.w parent3(a0),a1
                move.w  $42(a0),d0
                move.w  x_pos(a1),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.w  $44(a0),d0
                move.w  y_pos(a1),d1
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
; End of function DEZFinalChild_SetPosFromParent

; =============== S U B R O U T I N E =======================================

; Pause the fireball countdown while the attack-inhibit bit is set
DEZFinal_TryTimedFireball:
                btst    #2,$38(a0)
                bne.s   DEZFinal_FireballSpawnReturn
                subq.w  #1,$1C(a0)
                bpl.s   DEZFinal_FireballSpawnReturn
                move.w  #$140,$1C(a0)
                jsr     (AllocateObject).l
                bne.s   DEZFinal_FireballSpawnReturn
                move.l  #Obj_DEZ3_Boss_Fireball,(a1)
                move.w  a0,parent3(a1)

DEZFinal_FireballSpawnReturn:
                rts
; End of function DEZFinal_TryTimedFireball

; =============== S U B R O U T I N E =======================================

; Allocate after the current slot and copy its root attachment, position and trajectory offsets
DEZFireball_SpawnFlameSegment:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   DEZFinal_FlameCloneSpawnReturn
                move.l  #DEZFinal_FlameDispatchAndDraw,(a1)
                move.w  parent3(a0),parent3(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  $42(a0),$42(a1)
                move.w  $44(a0),$44(a1)
                move.b  d2,subtype(a1)

DEZFinal_FlameCloneSpawnReturn:
                rts
; End of function DEZFireball_SpawnFlameSegment

; ---------------------------------------------------------------------------

DEZFinal_LockBattleCameraAtThreshold:
                move.w  (Camera_X_pos).w,d0
                move.w  d0,(Camera_min_X_pos).w
                move.w  #$520,d1
                cmp.w   d1,d0
                blo.w   DEZFinalAttackActors_SharedReturn
                bset    #2,(_unkFAB8).w
                move.w  d1,(Camera_min_X_pos).w
                addi.w  #$A0,d1
                move.w  d1,(Camera_max_X_pos).w
                move.w  #$2C0,(Events_bg+$00).w
                addi.w  #$100,x_pos(a0)

DEZFinal_DeleteCurrentActor:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

DEZArmSegment_ContinueFlashOrBreak:
                move.b  collision_property(a0),d0
                beq.s   DEZFinal_ArmBeginDefeatWait
                tst.b   $20(a0)
                beq.s   DEZFinal_ArmFlashReturn
                bsr.w   SetDEZArmSegmentFlashFrameFromParent
                subq.b  #1,$20(a0)
                bne.s   DEZFinal_ArmFlashReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

DEZFinal_ArmFlashReturn:
                rts
; End of function DEZArmSegment_ContinueFlashOrBreak

; =============== S U B R O U T I N E =======================================

RecognizeDEZArmSegmentHitAtImpactFrame:
                cmpi.b  #4,mapping_frame(a0)
                bne.s   DEZArmSegment_ContinueFlashOrBreak
                tst.b   collision_flags(a0)
                bne.s   DEZFinal_ArmHitUpdateReturn
                move.b  collision_property(a0),d0
                beq.s   DEZFinal_ArmBeginDefeatWait
                tst.b   $20(a0)
                bne.s   DEZFinal_ArmTickHitRecovery
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

DEZFinal_ArmTickHitRecovery:
                bsr.w   SetDEZArmSegmentFlashFrameFromParent
                subq.b  #1,$20(a0)
                bne.s   DEZFinal_ArmHitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

DEZFinal_ArmHitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

DEZFinal_ArmBeginDefeatWait:
                move.l  #DEZFinal_SegmentFollowBeforeBreakup,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DEZFinal_ArmSignalDestroyedSegment
                move.b  #6,subtype(a1)

DEZFinal_ArmSignalDestroyedSegment:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                movea.w parent3(a0),a1
                bset    d0,$3A(a1)
                rts
; End of function RecognizeDEZArmSegmentHitAtImpactFrame

; =============== S U B R O U T I N E =======================================

SetDEZArmSegmentFlashFrameFromParent:
                movea.w parent3(a0),a1
                move.b  mapping_frame(a1),d0
                btst    #0,$20(a0)
                beq.s   DEZFinal_ArmSelectFlashFrame
                move.b  d0,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_ArmSelectFlashFrame:
                addi.b  #$13,d0
                move.b  d0,mapping_frame(a0)
                rts
; End of function SetDEZArmSegmentFlashFrameFromParent

; =============== S U B R O U T I N E =======================================

; Bounce the hitter and flash five colors. At zero HP, signal the world controller's defeat
DEZFinalHead_ProcessHitOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   DEZFinal_HeadHitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   DEZFinal_HeadBeginDefeatExplosion
                tst.b   $20(a0)
                bne.s   DEZFinal_HeadHitChooseFlashRow
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                lea     (Player_1).w,a1
                tst.b   $1C(a0)
                beq.s   DEZFinal_HeadSetPlayerBounceSpeed
                lea     (Player_2).w,a1

DEZFinal_HeadSetPlayerBounceSpeed:
                move.w  #$600,d0
                move.w  d0,ground_vel(a1)
                move.w  d0,x_vel(a1)
                move.w  #-$300,y_vel(a1)

DEZFinal_HeadHitChooseFlashRow:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   DEZFinal_HeadHitCopyColorsAndTick
                addi.w  #2*5,d0

DEZFinal_HeadHitCopyColorsAndTick:
                bsr.w   DEZFinalHead_CopyPalette5
                subq.b  #1,$20(a0)
                bne.s   DEZFinal_HeadHitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

DEZFinal_HeadHitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

DEZFinal_HeadBeginDefeatExplosion:
                move.l  #DEZFinal_DefeatedHeadClearBeam,(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   DEZFinal_HeadSignalWorldDefeat
                move.b  #4,subtype(a1)

DEZFinal_HeadSignalWorldDefeat:
                movea.w parent3(a0),a1
                bset    #7,status(a1)
                jmp     (BossDefeated_StopTimer).l
; End of function DEZFinalHead_ProcessHitOrDefeat

; =============== S U B R O U T I N E =======================================

; d0.w selects the source byte offset for the five destinations in palette line 2
DEZFinalHead_CopyPalette5:
                lea     DEZFinalHeadHit_PaletteDestinationWords(pc),a1
                lea     DEZFinal_HeadHitPaletteColorRows(pc,d0.w),a2
                jmp     (CopyWordData_5).l
; End of function DEZFinalHead_CopyPalette5

; ---------------------------------------------------------------------------
DEZFinalHeadHit_PaletteDestinationWords:
                dc.w    Normal_palette_line_2+$14, Normal_palette_line_2+$16, Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
DEZFinal_HeadHitPaletteColorRows:
                dc.w    $888,  $666,  $444,  $222,     0
                dc.w    $EEE,  $EEE,  $CCC,  $AAA,  $888

; =============== S U B R O U T I N E =======================================

; Continue an existing flash while the head is unexposed. Zero HP still enters defeat
DEZFinalHead_TickFlashOrDefeat:
                tst.b   collision_property(a0)
                beq.s   DEZFinal_HeadBeginDefeatExplosion
                tst.b   $20(a0)
                beq.s   DEZFinal_InactiveHeadFlashReturn
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   DEZFinal_InactiveHeadTickFlash
                addi.w  #2*5,d0

DEZFinal_InactiveHeadTickFlash:
                bsr.s   DEZFinalHead_CopyPalette5
                subq.b  #1,$20(a0)
                bne.s   DEZFinal_InactiveHeadFlashReturn
                bclr    #6,status(a0)

DEZFinal_InactiveHeadFlashReturn:
                rts
; End of function DEZFinalHead_TickFlashOrDefeat
