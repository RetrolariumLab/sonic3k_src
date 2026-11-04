; Owner: objects/bosses/mhz/end_boss/sk
; Responsibility: Mushroom Hill end-boss collision, movement, palette and parent-state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

OffsetMHZWeatherMachineEffectBySubtype:
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     MHZBoss_DiagonalEffectOffsets(pc,d0.w),a1
                move.w  (a1)+,d0
                add.w   d0,x_pos(a0)
                move.w  (a1)+,d0
                add.w   d0,y_pos(a0)
                rts
; End of function OffsetMHZWeatherMachineEffectBySubtype

; ---------------------------------------------------------------------------
MHZBoss_DiagonalEffectOffsets:
                dc.w    -$4D,  -$4E
                dc.w    -$A1,  -$A2
                dc.w    -$F5,  -$F6
                dc.w    -$149, -$14A

; =============== S U B R O U T I N E =======================================

SelectMHZEndBossOverlayLayerBySubtype:
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     MHZBoss_OverlayPriorityFrames(pc,d0.w),a1
                move.w  (a1)+,priority(a0)
                move.b  (a1)+,mapping_frame(a0)
                rts
; End of function SelectMHZEndBossOverlayLayerBySubtype

; ---------------------------------------------------------------------------
MHZBoss_OverlayPriorityFrames:
                dc.w    $300
                dc.b    2
                even
                dc.w    $200
                dc.b    3
                even

; =============== S U B R O U T I N E =======================================

MHZBossOverlay_SyncPosAndXFlip:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                bclr    #0,render_flags(a0)
                btst    #0,render_flags(a1)
                beq.s   MHZBoss_OverlaySyncReturn
                bset    #0,render_flags(a0)

MHZBoss_OverlaySyncReturn:
                rts
; End of function MHZBossOverlay_SyncPosAndXFlip

; =============== S U B R O U T I N E =======================================

; Share hit recovery between the root and collision proxy. After the flash at one HP, begin the escape
MHZBoss_HandlePairedHitsAndEscape:
                movea.w $44(a0),a4
                move.b  collision_property(a0),d0
                tst.b   collision_flags(a0)
                beq.s   MHZBoss_ClampHealthBeforeChase
                tst.b   collision_flags(a4)
                bne.w   MHZBoss_HitUpdateReturn
                subq.b  #1,d0
                move.b  $1C(a4),$1C(a0)

; Keep at least two hits before the final chase is enabled
MHZBoss_ClampHealthBeforeChase:
                btst    #7,$38(a0)
                bne.s   MHZBoss_StorePairedHealthAndFlash
                cmpi.b  #1,d0
                bgt.s   MHZBoss_StorePairedHealthAndFlash
                moveq   #2,d0

MHZBoss_StorePairedHealthAndFlash:
                move.b  d0,collision_property(a0)
                tst.b   $20(a0)
                bne.s   MHZBoss_HitChooseFlashRow
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_flags(a4)
                lea     (Player_1).w,a1
                tst.b   $1C(a0)
                beq.s   MHZBoss_ClearHitPlayerXSpeed
                lea     (Player_2).w,a1

MHZBoss_ClearHitPlayerXSpeed:
                clr.w   x_vel(a1)

MHZBoss_HitChooseFlashRow:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   MHZBoss_HitCopyColorsAndTick
                addi.w  #2*5,d0

MHZBoss_HitCopyColorsAndTick:
                bsr.w   CopyMHZEndBossFiveColorPalette
                subq.b  #1,$20(a0)
                bne.s   MHZBoss_HitUpdateReturn
                bclr    #6,status(a0)
                cmpi.b  #1,collision_property(a0)
                beq.s   MHZBoss_BeginOneHitEscape
                move.b  $25(a0),collision_flags(a0)
                move.b  $25(a4),collision_flags(a4)
                move.b  #-1,collision_property(a4)

MHZBoss_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

MHZBoss_BeginOneHitEscape:
                move.l  #MHZBoss_EscapeToDefeatGate,(a0)
                bclr    #6,$38(a0)
                move.w  #$400,d0
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   MHZBoss_SetEscapeSpeedAndTryWatcher
                move.w  #$500,d0

MHZBoss_SetEscapeSpeedAndTryWatcher:
                move.w  d0,x_vel(a0)
                st      (_unkFAA9).w
                jsr     (AllocateObject).l
                bne.s   MHZBoss_TryEscapeExplosion
                move.l  #MHZBoss_WaitChaseAndTryP2Lock,(a1)

MHZBoss_TryEscapeExplosion:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   MHZBoss_EscapeEffectReturn
                move.b  #$20,subtype(a1)

MHZBoss_EscapeEffectReturn:
                rts
; End of function MHZBoss_HandlePairedHitsAndEscape

; =============== S U B R O U T I N E =======================================

CopyMHZEndBossFiveColorPalette:
                lea     MHZBoss_HitPaletteDestinations(pc),a1
                lea     MHZBoss_HitPaletteColorRows(pc,d0.w),a2
                jmp     (CopyWordData_5).l
; End of function CopyMHZEndBossFiveColorPalette

; ---------------------------------------------------------------------------
MHZBoss_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$14, Normal_palette_line_2+$16, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
MHZBoss_HitPaletteColorRows:
                dc.w    $E42,  $228,     0,  $C40,  $820
                dc.w    $888,  $AAA,  $EEE,  $888,  $AAA
; ---------------------------------------------------------------------------

MHZBoss_WaitCameraAndLoadSpikeArt:
                cmpi.w  #$4010,(Camera_X_pos).w
                blo.w   MHZBoss_SharedReturn
                lea     (ArtKosM_MHZEndBossSpikes).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZEndBossSpikes),d2
                jsr     (Queue_Kos_Module).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

MHZBoss_WaitChaseAndTryP2Lock:
                tst.b   (_unkFAA9).w
                bne.w   MHZBoss_SharedReturn
                move.l  #MHZBoss_ResetPlayerAndWaitGround,(a0)
                jsr     (AllocateObject).l
                bne.s   MHZBoss_ResetPlayerAndWaitGround
                move.l  #SKInput_LockP2IfActive,(a1)

MHZBoss_ResetPlayerAndWaitGround:
                moveq   #0,d0
                lea     (Player_1).w,a1
                bclr    #Status_Facing,status(a1)
                bclr    #Status_Roll,status(a1)
                btst    #Status_InAir,status(a1)
                bne.s   MHZBoss_EscapeGroundGateReturn
                move.l  #MHZBoss_WalkPlayerToEscapeGate,(a0)
                move.w  #$55,(Events_fg_5).w
                st      (Ctrl_1_locked).w

MHZBoss_EscapeGroundGateReturn:
                rts
; ---------------------------------------------------------------------------

MHZBoss_WalkPlayerToEscapeGate:
                move.w  #(button_right_mask<<8)|button_right_mask,(Ctrl_1_logical).w
                lea     (Player_1).w,a1
                cmpi.w  #$4600,x_pos(a1)
                bhs.s   MHZBoss_StopPlayerAndDeleteWatcher
                rts
; ---------------------------------------------------------------------------

MHZBoss_StopPlayerAndDeleteWatcher:
                move.w  #$4600,x_pos(a1)
                jsr     (Stop_Object).l
                clr.w   (Ctrl_1_logical).w
                jmp     (Delete_Current_Sprite).l
; End of function MHZBoss_WalkPlayerToEscapeGate
