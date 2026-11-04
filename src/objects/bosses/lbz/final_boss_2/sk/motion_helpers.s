; Owner: objects/bosses/lbz/final_boss_2/sk
; Responsibility: Launch Base final boss player response, palette, motion and parent or child callback helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Once the parent has high tile priority, set the child's priority and collision and store the caller's continuation as its handler
LBZBoss2Child_LatchPriorityAndColl:
                movea.w parent3(a0),a1
                btst    #7,art_tile(a1)
                beq.s   LBZBoss2SK_PriorityLatchReturn
                bset    #7,art_tile(a0)
                move.l  (sp),(a0)
                move.b  d0,collision_flags(a0)

LBZBoss2SK_PriorityLatchReturn:
                rts
; End of function LBZBoss2Child_LatchPriorityAndColl

; ---------------------------------------------------------------------------
; unused
                movea.w $44(a0),a1
                movea.w parent3(a0),a2
                move.w  x_pos(a1),d0
                moveq   #$10,d2
                btst    #0,render_flags(a2)
                beq.s   LBZBoss2SK_UnusedMidpointFirstOffset
                neg.w   d2

LBZBoss2SK_UnusedMidpointFirstOffset:
                add.w   d2,d0
                move.w  x_pos(a2),d1
                moveq   #$C,d2
                btst    #0,render_flags(a2)
                beq.s   LBZBoss2SK_UnusedStoreActorMidpoint
                neg.w   d2

LBZBoss2SK_UnusedStoreActorMidpoint:
                add.w   d2,d1
                sub.w   d1,d0
                asr.w   #1,d0
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.w  y_pos(a1),d0
                subq.w  #4,d0
                move.w  y_pos(a2),d1
                subq.w  #4,d1
                sub.w   d1,d0
                asr.w   #1,d0
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_ChoosePassHeightAndSpeed:
                jsr     (Random_Number).l
                andi.w  #6,d0
                move.w  d0,$3A(a0)
                move.w  (Camera_X_pos).w,d1
                move.w  #$1A8,d2
                move.w  #-$300,d3
                btst    #0,render_flags(a0)
                beq.s   LBZBoss2SK_ApplyPassStartMotion
                move.w  #-$68,d2
                neg.w   d3

LBZBoss2SK_ApplyPassStartMotion:
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                move.w  d3,x_vel(a0)
                move.w  (Camera_Y_pos).w,d1
                move.w  LBZBoss2SK_PassCameraYOffsets(pc,d0.w),d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                move.w  LBZBoss2SK_PassInitialYSpeeds(pc,d0.w),y_vel(a0)
                move.w  #8,$3C(a0)
                rts
; ---------------------------------------------------------------------------
LBZBoss2SK_PassCameraYOffsets:
                dc.w    $60,   $10,   $A0,   $80
LBZBoss2SK_PassInitialYSpeeds:
                dc.w    0,  $200, -$200,     0
; ---------------------------------------------------------------------------

LBZBoss2SK_ChoosePatrolFacingSpeed:
                move.w  #-$300,d0
                btst    #0,render_flags(a0)
                beq.s   LBZBoss2SK_StorePatrolSpeedAndWait
                neg.w   d0

LBZBoss2SK_StorePatrolSpeedAndWait:
                move.w  d0,x_vel(a0)
                jsr     (Random_Number).l
                andi.w  #$7F,d0
                addi.w  #$C0,d0
                move.w  d0,$2E(a0)
                rts

; =============== S U B R O U T I N E =======================================

LBZBoss2_ReverseAtCameraBounds:
                move.w  (Camera_X_pos).w,d0
                tst.w   x_vel(a0)
                bmi.s   LBZBoss2SK_CheckLeftPatrolBound
                add.w   d2,d0
                cmp.w   x_pos(a0),d0
                bls.s   LBZBoss2SK_ReversePatrolFacingAndSpeed
                bra.w   LBZBoss2SK_PatrolBoundsReturn
; ---------------------------------------------------------------------------

LBZBoss2SK_CheckLeftPatrolBound:
                add.w   d1,d0
                cmp.w   x_pos(a0),d0
                blo.s   LBZBoss2SK_PatrolBoundsReturn

LBZBoss2SK_ReversePatrolFacingAndSpeed:
                bchg    #0,render_flags(a0)
                neg.w   x_vel(a0)

LBZBoss2SK_PatrolBoundsReturn:
                rts
; End of function LBZBoss2_ReverseAtCameraBounds

; =============== S U B R O U T I N E =======================================

HandleLBZFinalBoss2SixColorHitOrDefeat:
                cmpi.b  #8,routine(a0)
                blo.s   LBZBoss2SK_HitUpdateReturn
                tst.b   collision_flags(a0)
                bne.s   LBZBoss2SK_HitUpdateReturn
                move.b  collision_property(a0),d0
                beq.s   LBZBoss2SK_BeginScoredDefeatFade
                tst.b   $20(a0)
                bne.s   LBZBoss2SK_HitChooseFlashRow
                cmpi.b  #$A,routine(a0)
                bne.s   LBZBoss2SK_BeginHitFlashDisableArm
                move.w  #8,$3A(a0)

LBZBoss2SK_BeginHitFlashDisableArm:
                move.b  #$3C,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                movea.w $44(a0),a1
                clr.b   collision_flags(a1)

LBZBoss2SK_HitChooseFlashRow:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   LBZBoss2SK_HitCopyColorsAndTick
                addi.w  #2*6,d0

; Restore collision on both the root and arm when the flash expires
LBZBoss2SK_HitCopyColorsAndTick:
                bsr.w   CopyLBZFinalBoss2SixColorPalette
                subq.b  #1,$20(a0)
                bne.s   LBZBoss2SK_HitUpdateReturn
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)
                movea.w $44(a0),a1
                move.b  #$AD,collision_flags(a1)

LBZBoss2SK_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

LBZBoss2SK_BeginScoredDefeatFade:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #LBZBoss2SK_BeginDefeatRiseAndBreakup,$34(a0)
                jsr     (BossDefeated_StopTimer).l
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   LBZBoss2SK_DefeatCheckPlayerRelease
                move.b  #4,subtype(a1)

; Restore player control only when the stored capture byte is clear
LBZBoss2SK_DefeatCheckPlayerRelease:
                tst.b   $30(a0)
; Bug: this branch is inverted, freeing the player if they're _not_ being held
                bne.s   LBZBoss2SK_DefeatSpawnUnderlay
                jsr     (Restore_PlayerControl).l

LBZBoss2SK_DefeatSpawnUnderlay:
                lea     LBZBoss2SK_DefeatUnderlayChild(pc),a2
                jmp     (CreateChild1_Normal).l
; End of function HandleLBZFinalBoss2SixColorHitOrDefeat

; =============== S U B R O U T I N E =======================================

CopyLBZFinalBoss2SixColorPalette:
                lea     LBZBoss2SK_HitPaletteDestinations(pc),a1
                lea     LBZBoss2SK_HitPaletteColorRows(pc,d0.w),a2
                jmp     (CopyWordData_6).l
; End of function CopyLBZFinalBoss2SixColorPalette

; ---------------------------------------------------------------------------
LBZBoss2SK_HitPaletteDestinations:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$0E, Normal_palette_line_2+$10
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
LBZBoss2SK_HitPaletteColorRows:
                dc.w    8,    $A,     4,  $644,  $422,     0
                dc.w    $888,  $666,  $AAA,  $AAA,  $EEE,  $EEE
