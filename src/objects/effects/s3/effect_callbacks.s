; Owner: objects/effects/s3
; Responsibility: Continuous sound playback and callback-driven object palette fade effects with their color-channel helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Play_SFX_Continuous:
                move.b  (V_int_run_count+3).w,d1
                andi.b  #$F,d1
                bne.w   S3Return_AttrSetup
                jmp     (Play_SFX).l
; End of function Play_SFX_Continuous

; ---------------------------------------------------------------------------

; Schedule eight passes at four-update intervals
S3PalEffect_InitWhitePasses:
                move.b  #7,$39(a0)
                move.w  #3,$2E(a0)
                move.l  #S3PalEffect_WaitForWhitePass,(a0)

S3PalEffect_WaitForWhitePass:
                subq.w  #1,$2E(a0)
                bpl.w   S3Return_AttrSetup
                move.w  #3,$2E(a0)
                lea     (Normal_palette).w,a1
                moveq   #$40-1,d0

S3PalEffect_Raise64Colors:
                bsr.w   EffectColorS3RaiseOneColorTowardWhite
                dbf     d0,S3PalEffect_Raise64Colors
                subq.b  #1,$39(a0)
                bmi.w   Go_Delete_Sprite
                rts

; =============== S U B R O U T I N E =======================================

EffectColorS3RaiseOneColorTowardWhite:
                moveq   #$E,d2
                move.b  (a1),d3
                and.b   d2,d3
                cmp.b   d2,d3
                bhs.s   S3PalEffect_ReadGreenAndRed
                addq.b  #2,d3
                move.b  d3,(a1)

S3PalEffect_ReadGreenAndRed:
                addq.w  #1,a1
                move.b  (a1),d3
                move.b  d3,d4
                andi.b  #$E0,d3
                andi.b  #$E,d4
                cmpi.b  #$E0,d3
                bhs.s   S3PalEffect_TryRaiseRed
                addi.b  #$20,d3

S3PalEffect_TryRaiseRed:
                cmp.b   d2,d4
                bhs.s   S3PalEffect_StoreRaisedGreenRed
                addq.b  #2,d4

S3PalEffect_StoreRaisedGreenRed:
                or.b    d3,d4
                move.b  d4,(a1)+
                rts
; End of function EffectColorS3RaiseOneColorTowardWhite

; ---------------------------------------------------------------------------

S3PalEffect_InitTargetPasses:
                move.b  #7,$39(a0)
                move.w  #3,$2E(a0)
                move.l  #S3PalEffect_WaitForTargetPass,(a0)

S3PalEffect_WaitForTargetPass:
                subq.w  #1,$2E(a0)
                bpl.w   S3Return_AttrSetup
                move.w  #3,$2E(a0)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #$40-1,d0

S3PalEffect_Lower64Colors:
                bsr.w   EffectColorS3LowerOneColorTowardTarget
                dbf     d0,S3PalEffect_Lower64Colors
                subq.b  #1,$39(a0)
                bmi.w   Go_Delete_Sprite
                rts

; =============== S U B R O U T I N E =======================================

EffectColorS3LowerOneColorTowardTarget:
                move.b  (a2)+,d2
                andi.b  #$E,d2
                move.b  (a1),d3
                cmp.b   d2,d3
                bls.s   S3PalEffect_ReadTargetGreenRed
                subq.b  #2,d3
                move.b  d3,(a1)

S3PalEffect_ReadTargetGreenRed:
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
                bls.s   S3PalEffect_TryLowerRed
                subi.b  #$20,d4

S3PalEffect_TryLowerRed:
                cmp.b   d3,d5
                bls.s   S3PalEffect_StoreLoweredGreenRed
                subq.b  #2,d5

S3PalEffect_StoreLoweredGreenRed:
                or.b    d4,d5
                move.b  d5,(a1)+
                rts
; End of function EffectColorS3LowerOneColorTowardTarget
