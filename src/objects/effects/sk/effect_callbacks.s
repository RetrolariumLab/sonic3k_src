; Owner: objects/effects/sk
; Responsibility: Continuous sound playback and callback-driven palette fade effects with color-channel helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Play_SFX_Continuous:
                move.b  (V_int_run_count+3).w,d1
                andi.b  #$F,d1
                bne.w   SKReturn_AttrSetup
                jmp     (Play_SFX).l
; End of function Play_SFX_Continuous

; ---------------------------------------------------------------------------

SKPalEffect_InitWhiteAndLockRotation:
                move.b  #7,$39(a0)
                move.l  #SKPalEffect_WaitForWhitePass,(a0)
                st      (Palette_rotation_disable).w

; Reload the cadence from the caller's word at $3A
SKPalEffect_WaitForWhitePass:
                subq.w  #1,$2E(a0)
                bpl.s   SKPalEffect_WhitePassReturn
                move.w  $3A(a0),$2E(a0)
                lea     (Normal_palette).w,a1
                moveq   #$40-1,d0

SKPalEffect_Raise64Colors:
                bsr.w   EffectColorSKRaiseOneColorTowardWhite
                dbf     d0,SKPalEffect_Raise64Colors
                subq.b  #1,$39(a0)
                bmi.s   SKPalEffect_ChooseRestoreOrDelete
                rts
; ---------------------------------------------------------------------------

SKPalEffect_ChooseRestoreOrDelete:
                tst.b   subtype(a0)
                beq.s   SKPalEffect_UnlockRotationAndDelete
                move.l  #SKPalEffect_InitTargetPasses,(a0)
                bset    #5,$38(a0)

SKPalEffect_WhitePassReturn:
                rts
; ---------------------------------------------------------------------------

SKPalEffect_UnlockRotationAndDelete:
                clr.b   (Palette_rotation_disable).w
                jmp     (Go_Delete_Sprite).l

; =============== S U B R O U T I N E =======================================

EffectColorSKRaiseOneColorTowardWhite:
                moveq   #$E,d2
                move.b  (a1),d3
                and.b   d2,d3
                cmp.b   d2,d3
                bhs.s   SKPalEffect_ReadGreenAndRed
                addq.b  #2,d3
                move.b  d3,(a1)

SKPalEffect_ReadGreenAndRed:
                addq.w  #1,a1
                move.b  (a1),d3
                move.b  d3,d4
                andi.b  #$E0,d3
                andi.b  #$E,d4
                cmpi.b  #$E0,d3
                bhs.s   SKPalEffect_TryRaiseRed
                addi.b  #$20,d3

SKPalEffect_TryRaiseRed:
                cmp.b   d2,d4
                bhs.s   SKPalEffect_StoreRaisedGreenRed
                addq.b  #2,d4

SKPalEffect_StoreRaisedGreenRed:
                or.b    d3,d4
                move.b  d4,(a1)+
                rts
; End of function EffectColorSKRaiseOneColorTowardWhite

; ---------------------------------------------------------------------------

; Schedule eight lowering passes at four-update intervals
SKPalEffect_InitTargetPasses:
                move.b  #7,$39(a0)
                move.w  #3,$2E(a0)
                move.l  #SKPalEffect_WaitForTargetPass,(a0)

SKPalEffect_WaitForTargetPass:
                subq.w  #1,$2E(a0)
                bpl.w   SKReturn_AttrSetup
                move.w  #3,$2E(a0)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #$40-1,d0

; Reenable palette rotation after the last pass
SKPalEffect_Lower64Colors:
                bsr.w   EffectColorSKLowerOneColorTowardTarget
                dbf     d0,SKPalEffect_Lower64Colors
                subq.b  #1,$39(a0)
                bpl.w   SKReturn_AttrSetup
                clr.b   (Palette_rotation_disable).w
                jmp     (Go_Delete_Sprite).l

; =============== S U B R O U T I N E =======================================

EffectColorSKLowerOneColorTowardTarget:
                move.b  (a2)+,d2
                andi.b  #$E,d2
                move.b  (a1),d3
                cmp.b   d2,d3
                bls.s   SKPalEffect_CheckTargetGreen
                subq.b  #2,d3
                move.b  d3,(a1)

SKPalEffect_CheckTargetGreen:
                addq.w  #1,a1
                move.b  (a2)+,d2
                move.b  d2,d3
                andi.b  #$E0,d2
                andi.b  #$E,d3
                move.b  (a1),d4
                move.b  d4,d5
                andi.b  #$E0,d4
                andi.b  #$E,d5
                cmp.b   d2,d4
                bls.s   SKPalEffect_TryLowerRed
                subi.b  #$20,d4

SKPalEffect_TryLowerRed:
                cmp.b   d3,d5
                bls.s   SKPalEffect_StoreLoweredGreenRed
                subq.b  #2,d5

SKPalEffect_StoreLoweredGreenRed:
                or.b    d4,d5
                move.b  d5,(a1)+
                rts
; End of function EffectColorSKLowerOneColorTowardTarget

; ---------------------------------------------------------------------------
SKPalEffect_GetLegacyModeResult:                        ; used in S3, unused in S3&K
                move.w  (Player_mode).w,d0
                cmpi.w  #2,d0
                beq.s   SKPalEffect_ReturnLegacy1
                cmpi.w  #7,(Emerald_counts).w
                beq.s   SKPalEffect_ReturnLegacy2
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

SKPalEffect_ReturnLegacy1:
                moveq   #1,d0
                rts
; ---------------------------------------------------------------------------

SKPalEffect_ReturnLegacy2:
                moveq   #2,d0
                rts
