; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss body and arm actors, collision states, animation and parent-relative motion
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

DEZFinal_InitMasterEmerald:
                lea     DEZFinalMasterEmerald_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                lea     (Collected_emeralds_array).w,a1
                moveq   #3,d0
                moveq   #7-1,d1

DEZFinal_EmeraldCheckSevenStatusBytes:
                cmp.b   (a1)+,d0
                bne.s   DEZFinal_EmeraldChooseFollowMode
                dbf     d1,DEZFinal_EmeraldCheckSevenStatusBytes
                st      $3A(a0)
                lea     DEZMasterEmerald_TwoSlotPalettePrograms(pc),a1
                lea     (Palette_rotation_data).w,a2
                moveq   #bytesToLcnt($10),d0

DEZFinal_EmeraldCopyPaletteSlots:
                move.l  (a1)+,(a2)+
                dbf     d0,DEZFinal_EmeraldCopyPaletteSlots
                clr.w   (a2)

DEZFinal_EmeraldChooseFollowMode:
                tst.b   $2C(a0)
                bne.s   DEZFinal_EmeraldBeginEscapeFollow
                move.l  #DEZFinal_EmeraldCycleWorldPalette,(a0)
                move.w  #$58,$42(a0)
                move.w  #8,$44(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_EmeraldBeginEscapeFollow:
                move.l  #DEZFinal_EmeraldCycleEscapePalette,(a0)
                clr.b   mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_EmeraldCycleWorldPalette:
                tst.b   $3A(a0)
                beq.s   DEZFinal_EmeraldFollowWorld
                jsr     Run_PalRotationScript(pc)

DEZFinal_EmeraldFollowWorld:
                bsr.w   DEZFinalChild_SetPosFromParent
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.w   DEZFinal_DeleteCurrentActor
                tst.b   (_unkFAA9).w
                beq.s   DEZFinal_EmeraldHideUntilSignal
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZFinal_EmeraldHideUntilSignal:
                bclr    #7,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_EmeraldCycleEscapePalette:
                tst.b   $3A(a0)
                beq.s   DEZFinal_EmeraldFollowEscapeParent
                jsr     Run_PalRotationScript(pc)

DEZFinal_EmeraldFollowEscapeParent:
                jsr     Refresh_ChildPosition(pc)
                btst    #4,(_unkFAB8).w
                beq.s   DEZFinal_EmeraldDrawAfterRelease
                move.l  #DEZFinal_EmeraldCycleFallPalette,(a0)

DEZFinal_EmeraldDrawAfterRelease:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZFinal_EmeraldCycleFallPalette:
                tst.b   $3A(a0)
                beq.s   DEZFinal_EmeraldFallAndClamp
                jsr     Run_PalRotationScript(pc)

DEZFinal_EmeraldFallAndClamp:
                jsr     (MoveSprite).l
                cmpi.w  #$CF,y_pos(a0)
                blo.s   DEZFinal_EmeraldDrawAfterFall
                move.l  #DEZFinal_EmeraldCycleAtFinalHeight,(a0)
                move.w  #$CF,y_pos(a0)

DEZFinal_EmeraldDrawAfterFall:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZFinal_EmeraldCycleAtFinalHeight:
                tst.b   $3A(a0)
                beq.s   DEZFinalMasterEmerald_DrawHeldEmerald
                jsr     Run_PalRotationScript(pc)

DEZFinalMasterEmerald_DrawHeldEmerald:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZFinalBeamCharge_Initialize:
                lea     DEZFinalBeamCharge_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #DEZFinal_ChargeEmitAnimateAndFollow,(a0)
                move.w  #$58,$42(a0)
                move.w  #4,$44(a0)
                move.l  #DEZFinalBeamCharge_BeginTimedHold,$34(a0)
                move.b  #$13,$39(a0)
                moveq   #signextendB(sfx_Charging),d0
                jsr     (Play_SFX).l

DEZFinal_ChargeEmitAnimateAndFollow:
                bsr.w   DEZFinal_TryChargeParticleEvery4
                lea     DEZFinal_BeamChargeFlickerAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                bsr.w   DEZFinalChild_SetPosFromParent
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DEZFinalBeamCharge_BeginTimedHold:
                move.l  #DEZFinal_ChargeTickAndTryParticle,(a0)
                move.w  #2*60,$2E(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_ChargeTickAndTryParticle:
                subq.w  #1,$2E(a0)
                bmi.s   DEZFinalBeamActor_BeginFiringAnimation
                cmpi.w  #$28,$2E(a0)
                blo.s   DEZFinal_ChargeChooseFrameFromD0
                bsr.w   DEZFinal_TryChargeParticleEvery4

; Select frame $1A or $1F from bit zero of the current D0
DEZFinal_ChargeChooseFrameFromD0:
                move.b  #$1A,mapping_frame(a0)
                btst    #0,d0
                bne.s   DEZFinal_ChargeFollowAndDraw
                move.b  #$1F,mapping_frame(a0)

DEZFinal_ChargeFollowAndDraw:
                bsr.w   DEZFinalChild_SetPosFromParent
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DEZFinalBeamActor_BeginFiringAnimation:
                move.l  #DEZFinal_BeamAnimateAndPublishFrame,(a0)
                addi.w  #$34,$42(a0)
                addi.w  #4,$44(a0)
                lea     DEZFinal_ActiveBeamAnim(pc),a1
                jsr     Set_Raw_Animation(pc)
                move.l  #DEZFinal_BeamBeginReleaseDelay,$34(a0)
                bclr    #7,render_flags(a0)
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l

DEZFinal_BeamAnimateAndPublishFrame:
                jsr     Animate_RawMultiDelay(pc)
                beq.s   DEZFinal_BeamApplyDamageAndFollow
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                move.w  d0,(Events_bg+$10).w

DEZFinal_BeamApplyDamageAndFollow:
                bsr.w   HurtPlayersInsideDEZFinalBeamActiveFrame
                bsr.w   DEZFinalChild_SetPosFromParent
                jmp     Child_CheckParent(pc)
; ---------------------------------------------------------------------------

DEZFinal_BeamBeginReleaseDelay:
                move.l  #DEZFinal_BeamTickReleaseDelay,(a0)
                move.w  #$5F,$2E(a0)

DEZFinal_BeamTickReleaseDelay:
                subq.w  #1,$2E(a0)
                bmi.s   DEZFinal_BeamReleaseChargeAndDelete
                jmp     Child_CheckParent(pc)
; ---------------------------------------------------------------------------

DEZFinal_BeamReleaseChargeAndDelete:
                movea.w $3A(a0),a1
                bclr    #2,$38(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

DEZFinal_InitRandomChargeParticle:
                lea     DEZFinalChargeParticle_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #DEZFinal_ChargeParticleConverge,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                addi.w  #$64,d2
                move.w  y_pos(a1),d3
                addq.w  #4,d3
                jsr     (Random_Number).l
                andi.w  #$1F,d0
                add.w   d0,d2
                swap    d0
                andi.w  #$7F,d0
                subi.w  #$40,d0
                add.w   d0,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_ChargeParticleConverge:
                lea     DEZFinal_ChargeParticleDeleteAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                subi.w  #$40,x_vel(a0)
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                jsr     (GetSineCosine).l
                add.w   d0,d0
                move.w  d0,y_vel(a0)
                jsr     (MoveSprite2).l
                move.w  x_pos(a1),d0
                addi.w  #$3C,d0
                cmp.w   x_pos(a0),d0
                blo.s   DEZFinal_ChargeParticleDraw
                jsr     (Go_Delete_Sprite).l

DEZFinal_ChargeParticleDraw:
                jmp     (Draw_Sprite).l
