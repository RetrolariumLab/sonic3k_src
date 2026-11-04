; Owner: game/level/zones/lbz/sk
; Responsibility: Launch Base act-two and Death Egg background deformation, window effects and private geometry
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

LBZ2_Deform:
                move.w  (Camera_Y_pos_copy).w,d0        ; Oh hey, it's more waterline fun, wasn't this just so interesting the first time
                move.w  (Screen_shake_offset).w,d3
                sub.w   d3,d0
                subi.w  #$5F0,d0
                move.w  d0,d1
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d2
                asr.l   #3,d2
                sub.l   d2,d0
                asr.l   #2,d2
                sub.l   d2,d0
                swap    d0
                move.w  d0,d2
                addi.w  #$2C0,d0
                add.w   d3,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w     ; Calculate effective Y position
                sub.w   d1,d2
                move.w  d2,(Events_bg+$10).w            ; Water line equilibrium point
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                tst.w   d2
                beq.w   SKLBZ_NormalPrepareLowerAreaScrollBands  ; Equilibrium skips ahead
                move.l  d0,d1
                move.l  d0,d3
                asr.l   #6,d3
                move.l  d3,d4
                asr.l   #3,d4
                sub.l   d4,d3
                moveq   #$20-1,d4
                cmpi.w  #-$40,d2
                bgt.s   SKLBZ_NormalWaterBandPrepareBackwardFill
                lea     (HScroll_table+$01E).w,a1       ; Above water, no art reloading needed

SKLBZ_NormalWaterBandFillForwardPairs:
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                sub.l   d3,d1
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                sub.l   d3,d1
                dbf     d4,SKLBZ_NormalWaterBandFillForwardPairs
                bra.w   SKLBZ_NormalPrepareLowerAreaScrollBands
; ---------------------------------------------------------------------------

SKLBZ_NormalWaterBandPrepareBackwardFill:
                lea     (HScroll_table+$11E).w,a1       ; Below water

SKLBZ_NormalWaterBandFillBackwardPairs:
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                dbf     d4,SKLBZ_NormalWaterBandFillBackwardPairs
                cmpi.w  #$40,d2
                bge.s   SKLBZ_NormalPrepareLowerAreaScrollBands  ; No art reloading needed if out of range
                lea     (HScroll_table+$09E).w,a1
                lea     (a1),a5
                lea     (LBZ_WaterlineScroll_Data).l,a6
                move.w  d2,d1
                bmi.s   SKLBZ2Water_PrepareUpperRemap
                move.w  d1,d3                           ; Below water
                neg.w   d3
                addi.w  #$40,d3
                lsl.w   #6,d3
                adda.w  d3,a6
                subq.w  #1,d1
                moveq   #0,d3
                lsr.w   #1,d1
                bcc.s   SKLBZ2Water_RemapLowerSecondWord

SKLBZ2Water_RemapLowerFirstWord:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),(a1)+

SKLBZ2Water_RemapLowerSecondWord:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),(a1)+
                dbf     d1,SKLBZ2Water_RemapLowerFirstWord
                bra.s   SKLBZ_NormalPrepareLowerAreaScrollBands
; ---------------------------------------------------------------------------

SKLBZ2Water_PrepareUpperRemap:
                move.w  d1,d3                           ; Above water
                addi.w  #$40,d3
                lsl.w   #6,d3
                adda.w  d3,a6
                neg.w   d1
                subq.w  #1,d1
                moveq   #0,d3
                lsr.w   #1,d1
                bcc.s   SKLBZ2Water_RemapUpperSecondWord

SKLBZ2Water_RemapUpperFirstWord:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),-(a1)

SKLBZ2Water_RemapUpperSecondWord:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),-(a1)
                dbf     d1,SKLBZ2Water_RemapUpperFirstWord

SKLBZ_NormalPrepareLowerAreaScrollBands:
                lea     (HScroll_table+$1E2).w,a1       ; Below the water area moving up (from Knuckles area of course)
                move.l  d0,d1
                asr.l   #1,d1
                move.l  d1,d3
                asr.l   #3,d3
                swap    d1
                move.w  d1,(Camera_X_pos_BG_copy).w     ; Effective X
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                swap    d1
                move.w  d1,(Events_bg+$12).w            ; Art reloading for the bricks in Knuckles' area
                move.w  d1,-(a1)
                swap    d1
                lea     (LBZ2_BGUWDeformRange).l,a5     ; This is an array of counters used for deformation sizes underwater
                sub.l   d3,d1                           ; Likely because the underwater wavy effect necessitates specifying deformation line-by-line
                moveq   #4,d4

SKLBZ2Water_StepUnderwaterSlope:
                sub.l   d3,d1
                swap    d1
                move.w  (a5)+,d5

SKLBZ2Water_FillUnderwaterBand:
                move.w  d1,-(a1)
                move.w  d1,-(a1)
                move.w  d1,-(a1)
                move.w  d1,-(a1)
                dbf     d5,SKLBZ2Water_FillUnderwaterBand
                swap    d1
                dbf     d4,SKLBZ2Water_StepUnderwaterSlope
                moveq   #$40-1,d3
                tst.w   d2
                bmi.s   SKLBZ2Water_PrepareLowerBandTail
                sub.w   d2,d3                           ; Only perform as much addition line-by-line deformation as needed
                bcs.s   SKLBZ_NormalPrepareCloudScrollOffsets

SKLBZ2Water_PrepareLowerBandTail:
                swap    d1
                lsr.w   #1,d3
                bcc.s   SKLBZ2Water_FillLowerTailSecondWord

SKLBZ_NormalFillLowerBandFirstWordOfPair:
                move.w  d1,-(a1)

SKLBZ2Water_FillLowerTailSecondWord:
                move.w  d1,-(a1)
                dbf     d3,SKLBZ_NormalFillLowerBandFirstWordOfPair

SKLBZ_NormalPrepareCloudScrollOffsets:
                lea     (HScroll_table).w,a1            ; With that over with, we can actually do some normal stuff
                lea     (LBZ2_CloudDeformArray).l,a5
                move.l  d0,d1
                asr.l   #6,d1
                move.l  d1,d3
                move.l  (HScroll_table+$1E2).w,d4
                addi.l  #$E00,(HScroll_table+$1E2).w    ; Move clouds
                moveq   #$D-1,d5

SKLBZ_NormalWriteIndexedCloudScrollBand:
                move.w  (a5)+,d6
                add.l   d4,d1
                swap    d1
                move.w  d1,(a1,d6.w)
                swap    d1
                add.l   d3,d1
                dbf     d5,SKLBZ_NormalWriteIndexedCloudScrollBand
                move.l  d0,d1                           ; And now just do the rest of the deformation
                asr.l   #4,d1
                move.l  d1,d3
                asr.l   #1,d3
                lea     (HScroll_table+$01A).w,a1
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                add.l   d3,d1
                swap    d1
                move.w  d1,(a1)+
                tst.w   d2
                bpl.s   SKLBZ2Water_SetFullUpperTailCount  ; If below water, just do the full deformation
                moveq   #$40-1,d4
                add.w   d2,d4
                bmi.s   SKLBZ2Water_CalcVisibleWaveExtent  ; If above water far enough that entire waterline shows, skip ahead
                cmpi.w  #$30,d4
                blo.s   SKLBZ2Water_SplitUpperTailByParity
                subi.w  #$30,d4
                bra.s   SKLBZ2Water_PrepareUpperPlateau
; ---------------------------------------------------------------------------

SKLBZ2Water_SetFullUpperTailCount:
                moveq   #$10-1,d4

SKLBZ2Water_PrepareUpperPlateau:
                moveq   #$18-1,d5

SKLBZ_NormalFillUpperPlateauWordPairs:
                move.w  d1,(a1)+                        ; First $30 pixels have their own deformation
                move.w  d1,(a1)+
                dbf     d5,SKLBZ_NormalFillUpperPlateauWordPairs
                swap    d1
                add.l   d3,d1
                swap    d1

SKLBZ2Water_SplitUpperTailByParity:
                lsr.w   #1,d4                           ; As do the last $10 pixels
                bcc.s   SKLBZ2Water_FillUpperTailSecondWord

SKLBZ_NormalFillUpperBandTailFirstWord:
                move.w  d1,(a1)+

SKLBZ2Water_FillUpperTailSecondWord:
                move.w  d1,(a1)+
                dbf     d4,SKLBZ_NormalFillUpperBandTailFirstWord

SKLBZ2Water_CalcVisibleWaveExtent:
                moveq   #$3F,d0                         ; And yet, there's more, cause we now have the wavy effects to go!
                sub.w   d2,d0
                bmi.s   SKLBZ_ReturnFromNormalActTwoDeformation  ; If high enough, no waviness needed
                addi.w  #$60,d0                         ; Otherwise, keep it up
                cmpi.w  #$E0,d0
                blo.s   SKLBZ2Water_PrepareReverseWave
                move.w  #$E0-1,d0

SKLBZ2Water_PrepareReverseWave:
                lea     (HScroll_table+$1DE).w,a1
                lea     LBZ_WaterWaveArray(pc),a5       ; Water wave array
                move.w  (Level_frame_counter).w,d1
                asr.w   #1,d1
                andi.w  #$7E,d1
                adda.w  d1,a5
                lsr.w   #1,d0
                bcc.s   SKLBZ2Water_AddWaveSecondWord

SKLBZ_NormalAddWaterWaveFirstWordOfPair:
                move.w  -(a5),d3
                add.w   d3,-(a1)

SKLBZ2Water_AddWaveSecondWord:
                move.w  -(a5),d3
                add.w   d3,-(a1)
                dbf     d0,SKLBZ_NormalAddWaterWaveFirstWordOfPair

SKLBZ_ReturnFromNormalActTwoDeformation:
                rts
; End of function LBZ2_Deform

; =============== S U B R O U T I N E =======================================

LBZ2_DeathEggDeform:
                move.w  (Camera_Y_pos_copy).w,d0        ; Oh no, I'm not commenting all of this again
                move.w  (Screen_shake_offset).w,d3
                sub.w   d3,d0
                subi.w  #$5F0,d0
                sub.w   (Events_bg+$02).w,d0
                sub.w   (Events_bg+$06).w,d0
                move.w  d0,d1
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d2
                asr.l   #3,d2
                sub.l   d2,d0
                asr.l   #2,d2
                sub.l   d2,d0
                swap    d0
                move.w  d0,d2
                addi.w  #$2C0,d0
                sub.w   (Events_fg_3).w,d0
                add.w   d3,d0
                bpl.s   SKLBZ2Egg_ApplyBackgroundWrapBias
                moveq   #0,d3
                move.w  d0,d4

SKLBZ2Egg_GrowBackgroundWrapBias:
                addi.w  #$100,d3
                addi.w  #$100,d4
                bmi.s   SKLBZ2Egg_GrowBackgroundWrapBias
                cmp.w   (_unkEEA0).w,d3
                blo.s   SKLBZ2Egg_ApplyBackgroundWrapBias
                move.w  d3,(_unkEEA0).w

SKLBZ2Egg_ApplyBackgroundWrapBias:
                tst.w   (Events_fg_3).w
                bne.s   SKLBZ_DeathEggAddLatchedPageAndWrapBias
                cmpi.w  #$100,d0
                bne.s   SKLBZ_DeathEggAddLatchedPageAndWrapBias
                move.w  d0,(Events_fg_3).w

SKLBZ_DeathEggAddLatchedPageAndWrapBias:
                add.w   (_unkEEA0).w,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                tst.w   (_unkEEA0).w
                beq.s   SKLBZ2Egg_CheckWaterBandLevel

SKLBZ_DeathEggReduceEffectiveYModuloPage:
                cmpi.w  #$100,d0
                blo.s   SKLBZ_DeathEggPublishReducedBackgroundY
                subi.w  #$100,d0
                bra.s   SKLBZ_DeathEggReduceEffectiveYModuloPage
; ---------------------------------------------------------------------------

SKLBZ_DeathEggPublishReducedBackgroundY:
                move.w  d0,(Camera_Y_pos_BG_copy).w

SKLBZ2Egg_CheckWaterBandLevel:
                tst.w   (_unkEE9C).w
                bmi.s   SKLBZ2Egg_DisableWaterBand
                sub.w   d1,d2
                bpl.s   SKLBZ2Egg_PrepareReverseUpperBand

SKLBZ2Egg_DisableWaterBand:
                move.w  #$7FFF,d2

SKLBZ2Egg_PrepareReverseUpperBand:
                move.w  d2,(Events_bg+$10).w
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                move.l  d0,d1
                move.l  d0,d3
                asr.l   #6,d3
                move.l  d3,d4
                asr.l   #3,d4
                sub.l   d4,d3
                moveq   #$20-1,d4
                lea     (HScroll_table+$0AC).w,a1

SKLBZ2Egg_FillUpperBandPairs:
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                dbf     d4,SKLBZ2Egg_FillUpperBandPairs
                cmpi.w  #$40,d2
                bge.s   SKLBZ_DeathEggPrepareLowerFlatBand
                lea     (HScroll_table+$02C).w,a1
                lea     (a1),a5
                lea     (LBZ_WaterlineScroll_Data).l,a6
                move.w  d2,d1
                move.w  d1,d3
                neg.w   d3
                addi.w  #$40,d3
                lsl.w   #6,d3
                adda.w  d3,a6
                subq.w  #1,d1
                moveq   #0,d3
                lsr.w   #1,d1
                bcc.s   SKLBZ2Egg_RemapWaterSecondWord

SKLBZ_DeathEggWaterRemapFirstWordOfPair:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),(a1)+

SKLBZ2Egg_RemapWaterSecondWord:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),(a1)+
                dbf     d1,SKLBZ_DeathEggWaterRemapFirstWordOfPair

SKLBZ_DeathEggPrepareLowerFlatBand:
                lea     (HScroll_table+$0EC).w,a1
                move.l  d0,d1
                asr.l   #1,d1
                move.l  d1,d3
                asr.l   #3,d3
                moveq   #7-1,d4

SKLBZ2Egg_StepLowerBandSlope:
                sub.l   d3,d1
                dbf     d4,SKLBZ2Egg_StepLowerBandSlope
                moveq   #$60-1,d3
                sub.w   d2,d3
                bcs.s   SKLBZ_DeathEggPrepareCloudScrollOffsets
                swap    d1
                lsr.w   #1,d3
                bcc.s   SKLBZ2Egg_FillLowerFlatSecondWord

SKLBZ_DeathEggFillLowerFlatBandFirstWord:
                move.w  d1,-(a1)

SKLBZ2Egg_FillLowerFlatSecondWord:
                move.w  d1,-(a1)
                dbf     d3,SKLBZ_DeathEggFillLowerFlatBandFirstWord

SKLBZ_DeathEggPrepareCloudScrollOffsets:
                lea     (HScroll_table+$00C).w,a1
                lea     (LBZ2_CloudDeformArray).l,a5
                move.l  d0,d1
                asr.l   #6,d1
                move.l  d1,d3
                move.l  (HScroll_table+$1E2).w,d4
                addi.l  #$E00,(HScroll_table+$1E2).w
                moveq   #$D-1,d5

SKLBZ2Egg_WriteCloudScrollBand:
                move.w  (a5)+,d6
                add.l   d4,d1
                swap    d1
                move.w  d1,(a1,d6.w)
                swap    d1
                add.l   d3,d1
                dbf     d5,SKLBZ2Egg_WriteCloudScrollBand
                lea     (HScroll_table+$010).w,a1
                lea     (HScroll_table).w,a5
                moveq   #4-1,d1

SKLBZ2Egg_CopyLeadingCloudScroll:
                move.l  (a1)+,(a5)+
                dbf     d1,SKLBZ2Egg_CopyLeadingCloudScroll
                move.l  d0,d1
                asr.l   #4,d1
                move.l  d1,d3
                asr.l   #1,d3
                lea     (HScroll_table+$026).w,a1
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                add.l   d3,d1
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                add.l   d3,d1
                swap    d1
                move.w  d1,(a1)+
                moveq   #$40-1,d0
                sub.w   d2,d0
                addi.w  #$20,d0
                cmpi.w  #$60,d0
                blo.s   SKLBZ2Egg_PrepareReverseWave
                move.w  #$60-1,d0

SKLBZ2Egg_PrepareReverseWave:
                lea     (HScroll_table+$0EC).w,a1
                lea     LBZ_WaterWaveArray2(pc),a5
                move.w  (Level_frame_counter).w,d1
                asr.w   #1,d1
                andi.w  #$7E,d1
                adda.w  d1,a5
                lsr.w   #1,d0
                bcc.s   SKLBZ2Egg_AddWaveSecondWord

SKLBZ2Egg_AddWaveFirstWord:
                move.w  -(a5),d3
                add.w   d3,-(a1)

SKLBZ2Egg_AddWaveSecondWord:
                move.w  -(a5),d3
                add.w   d3,-(a1)
                dbf     d0,SKLBZ2Egg_AddWaveFirstWord
                rts
; End of function LBZ2_DeathEggDeform

; =============== S U B R O U T I N E =======================================

LBZ2_DeathEggMoveScreen:
                cmpi.b  #6,(Player_1+routine).w
                bhs.w   SKLBZ_ReturnFromDeathEggScreenMotion  ; If dying, don't bother
                tst.b   (Scroll_lock).w
                beq.s   SKLBZ2Egg_TickMotionDelay       ; Skip if flag turned off
                move.w  (Player_1+x_pos).w,d0
                sub.w   (Camera_X_pos).w,d0
                subi.w  #$A0,d0
                bcs.s   SKLBZ_DeathEggUnlockScrollAtCameraLimit
                add.w   d0,(Camera_X_pos).w             ; Move screen along with player in Robotnik ship

SKLBZ_DeathEggUnlockScrollAtCameraLimit:
                cmpi.w  #$4390,(Camera_X_pos).w
                bhs.s   SKLBZ_DeathEggClearScrollLockByte
                cmpi.w  #$668,(Camera_Y_pos).w
                blo.s   SKLBZ2Egg_TickMotionDelay

SKLBZ_DeathEggClearScrollLockByte:
                clr.b   (Scroll_lock).w                 ; Stop movement when screen edge is reached

SKLBZ2Egg_TickMotionDelay:
                tst.w   (Events_bg+$0E).w
                beq.s   SKLBZ2Egg_TryLockCameraMinX
                subq.w  #1,(Events_bg+$0E).w
                bra.w   SKLBZ_ReturnFromDeathEggScreenMotion
; ---------------------------------------------------------------------------

SKLBZ2Egg_TryLockCameraMinX:
                cmpi.w  #$4390,(Camera_X_pos).w
                blo.s   SKLBZ_DeathEggLockVerticalMinimumAtLimit
                move.w  (Camera_max_X_pos).w,d0
                move.w  d0,(Camera_min_X_pos).w

SKLBZ_DeathEggLockVerticalMinimumAtLimit:
                cmpi.w  #$668,(Camera_Y_pos).w
                blo.s   SKLBZ2Egg_IntegratePrimaryMotion
                move.w  (Camera_max_Y_pos).w,d0
                move.w  d0,(Camera_min_Y_pos).w         ; Lock screen when edges are reached

SKLBZ2Egg_IntegratePrimaryMotion:
                lea     (Events_bg+$02).w,a1
                moveq   #0,d1
                move.w  (_unkEEA2).w,d1                 ; Speed of Death Egg movement
                add.l   d1,(a1)
                move.w  (a1),d0
                move.w  d0,d1
                sub.w   8(a1),d0
                move.w  d1,8(a1)
                move.w  #$2200,d1
                tst.b   (Scroll_lock).w
                bne.s   SKLBZ2Egg_IntegrateSecondaryMotion
                move.l  (_unkEE9C).w,d1                 ; Get BG movement speed if edge of screen is reached

SKLBZ2Egg_IntegrateSecondaryMotion:
                add.l   d1,4(a1)
                move.w  4(a1),d1
                move.w  d1,d2
                sub.w   $A(a1),d1
                move.w  d2,$A(a1)
                tst.b   (Scroll_lock).w
                beq.s   SKLBZ2Egg_AdvanceWaterTarget
                movea.w (Events_bg+$00).w,a5            ; If movement is still going
                add.w   d0,$14(a5)                      ; Add Y movement to screen and Robotnik ship
                add.w   d0,(Camera_Y_pos).w

SKLBZ2Egg_AdvanceWaterTarget:
                move.w  (Target_water_level).w,d2
                add.w   d0,d2
                add.w   d1,d2
                cmpi.w  #$F00,d2
                blo.s   SKLBZ2Egg_SetWaterTargetAndDelta
                move.w  #$F80,d2

SKLBZ2Egg_SetWaterTargetAndDelta:
                move.w  d2,(Target_water_level).w
                move.w  d0,(Events_bg+$14).w
                add.w   d1,(Events_bg+$14).w

SKLBZ_ReturnFromDeathEggScreenMotion:
                rts
; End of function LBZ2_DeathEggMoveScreen

; =============== S U B R O U T I N E =======================================

LBZ2_EndFallingAccel:
                tst.w   (_unkEEA2).w
                beq.s   SKLBZ2Egg_AccelerateSecondaryFall
                subi.w  #$100,(_unkEEA2).w
                bra.s   SKLBZ_ReturnFromDeathEggFallAcceleration
; ---------------------------------------------------------------------------

SKLBZ2Egg_AccelerateSecondaryFall:
                cmpi.l  #$FFFE8000,(_unkEE9C).w
                ble.s   SKLBZ_ReturnFromDeathEggFallAcceleration
                subi.l  #$100,(_unkEE9C).w

SKLBZ_ReturnFromDeathEggFallAcceleration:
                rts
; End of function LBZ2_EndFallingAccel
