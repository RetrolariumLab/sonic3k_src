; Owner: objects/interface/sk
; Responsibility: Special-stage results text, emerald display, tally elements and product-specific emerald projection effects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SKSSResults_ReleasePaletteOnPriorArrival:
                move.w  -$3A(a0),d0
                cmp.w   -4(a0),d0
                bne.s   SKSSResults_PriorArrivalWaitReturn
                clr.b   (_unkFAC1).w
                moveq   #signextendB(sfx_Perfect),d0
                jsr     (Play_SFX).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSSResults_PriorArrivalWaitReturn:
                rts
; ---------------------------------------------------------------------------

SKSSResults_SetLockOnKnuxTextArt:
                tst.w   (SK_alone_flag).w
                bne.s   SKSSResults_ApplyNameOffsetAndMove
                tst.b   (SK_special_stage_flag).w
                beq.s   SKSSResults_ApplyNameOffsetAndMove
                cmpi.w  #3,(Player_mode).w
                bne.s   SKSSResults_ApplyNameOffsetAndMove
                move.w  #make_art_tile($000,1,0),art_tile(a0)

SKSSResults_ApplyNameOffsetAndMove:
                jsr     SKSpecialResults_SelectNamePose(pc)
                add.w   d0,x_pos(a0)
                add.w   d0,$46(a0)
                bra.s   SKSSResults_InstallAndRunWidgetMove
; ---------------------------------------------------------------------------

SKSSResults_SetSpecialTextFrame:
                tst.w   (SK_alone_flag).w
                bne.s   SKSSResults_InstallAndRunWidgetMove
                tst.b   (SK_special_stage_flag).w
                beq.s   SKSSResults_InstallAndRunWidgetMove
                addi.b  #$1A,mapping_frame(a0)
                cmpi.w  #3,(Player_mode).w
                bne.s   SKSSResults_InstallAndRunWidgetMove
                addq.b  #5,mapping_frame(a0)
                bra.s   SKSSResults_InstallAndRunWidgetMove
; ---------------------------------------------------------------------------

SKSSResults_ApplyOppositeNameOffset:
                jsr     SKSpecialResults_SelectNamePose(pc)
                sub.w   d0,x_pos(a0)
                sub.w   d0,$46(a0)

SKSSResults_InstallAndRunWidgetMove:
                move.l  #SKSSResults_MoveElementAndDraw,(a0)

SKSSResults_MoveElementAndDraw:
                jsr     LevelResults_MoveElement(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSSResults_MoveAndReadRingBonus:
                jsr     LevelResults_MoveElement(pc)
                move.w  (Ring_bonus_countdown).w,d0
                bra.s   SKSSResults_WriteSevenDigitsAndSetArt
; ---------------------------------------------------------------------------

SKSSResults_MoveAndReadPerfectBonus:
                jsr     LevelResults_MoveElement(pc)
                move.w  (Time_bonus_countdown).w,d0

SKSSResults_WriteSevenDigitsAndSetArt:
                jsr     LevResults_DisplayScore(pc)
                move.w  (_unkEF68).w,art_tile(a0)       ; this is not here in Sonic 3. _unkEF68 is always set to $98. What does this do?!?!?!
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSSResults_Keep50RingContinueLabel:
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.w   SKSSResults_DeleteIneligibleWidget
                tst.w   (SK_alone_flag).w
                bne.s   SKSSResults_InstallAndRunWidgetMove
                tst.b   (SK_special_stage_flag).w
                beq.s   SKSSResults_InstallAndRunWidgetMove
                addi.b  #$1A,mapping_frame(a0)
                cmpi.w  #3,(Player_mode).w
                bne.s   SKSSResults_InstallAndRunWidgetMove
                addq.b  #5,mapping_frame(a0)
                bra.s   SKSSResults_InstallAndRunWidgetMove
; ---------------------------------------------------------------------------

SKSSResults_BlinkCollectedEmerald:
                lea     (Collected_emeralds_array).w,a1
                moveq   #0,d0
                move.b  width_pixels(a0),d0
                cmpi.b  #1,(a1,d0.w)
                bne.w   SKSSResults_DeleteIneligibleWidget
                tst.w   (Emerald_flicker_flag).w
                beq.s   SKSSResults_EmeraldBlinkReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSSResults_EmeraldBlinkReturn:
                rts
; ---------------------------------------------------------------------------

SKSSResults_KeepFailureWithOrdinaryArt:
                tst.w   (Special_stage_spheres_left).w
                beq.w   SKSSResults_DeleteIneligibleWidget
                jsr     SpecialResults_SetOrdinaryEmeraldArt(pc)
                bra.w   SKSSResults_MoveElementAndDraw
; ---------------------------------------------------------------------------

SKSSResults_ShiftSuccessNameForFullSet:
                tst.w   (Special_stage_spheres_left).w
                bne.w   SKSSResults_DeleteIneligibleWidget
                jsr     SpecialResults_SelectEmeraldCountPtr(pc)
                cmpi.b  #7,(a1)
                blo.s   SKSSResults_SetNameFrameAndWrappedArt
                subi.w  #$10,x_pos(a0)
                subi.w  #$10,$46(a0)

SKSSResults_SetNameFrameAndWrappedArt:
                jsr     SKSpecialResults_SelectNamePose(pc)
                add.w   d0,x_pos(a0)
                add.w   d0,$46(a0)
                add.b   d1,mapping_frame(a0)
                move.w  #-$87,art_tile(a0)
                tst.w   (SK_alone_flag).w
                bne.w   SKSSResults_InstallAndRunWidgetMove
                tst.b   (SK_special_stage_flag).w
                beq.w   SKSSResults_InstallAndRunWidgetMove
                cmpi.w  #3,(Player_mode).w
                bne.w   SKSSResults_InstallAndRunWidgetMove
                addi.w  #palette_line_1,art_tile(a0)
                bra.w   SKSSResults_InstallAndRunWidgetMove
; ---------------------------------------------------------------------------

SKSSResults_PrepCompanionTextForFullSet:
                tst.w   (Special_stage_spheres_left).w
                bne.w   SKSSResults_DeleteIneligibleWidget
                jsr     SpecialResults_SetOrdinaryEmeraldArt(pc)
                jsr     SKSpecialResults_SelectNamePose(pc)
                sub.w   d0,x_pos(a0)
                sub.w   d0,$46(a0)
                jsr     SpecialResults_SelectEmeraldCountPtr(pc)
                cmpi.b  #7,(a1)
                blo.w   SKSSResults_InstallAndRunWidgetMove
                subi.w  #$10,x_pos(a0)
                subi.w  #$10,$46(a0)
                bra.w   SKSSResults_InstallAndRunWidgetMove
; ---------------------------------------------------------------------------

SKSSResults_SelectChaosOrSuperText:
                tst.w   (Special_stage_spheres_left).w
                bne.w   SKSSResults_DeleteIneligibleWidget
                jsr     SpecialResults_SetOrdinaryEmeraldArt(pc)
                tst.w   (SK_alone_flag).w
                bne.s   SKSSResults_ShiftTextForSevenChaos
                tst.b   (SK_special_stage_flag).w
                bne.s   SKSSResults_SetFrame30AndCheckAllSuper

SKSSResults_ShiftTextForSevenChaos:
                cmpi.b  #7,(Chaos_emerald_count).w
                blo.w   SKSSResults_InstallAndRunWidgetMove
                bra.s   SKSSResults_ShiftMessageLeftEight
; ---------------------------------------------------------------------------

SKSSResults_SetFrame30AndCheckAllSuper:
                move.b  #$30,mapping_frame(a0)
                cmpi.b  #7,(Super_emerald_count).w
                blo.w   SKSSResults_InstallAndRunWidgetMove

SKSSResults_ShiftMessageLeftEight:
                subq.w  #8,x_pos(a0)
                subq.w  #8,$46(a0)
                bra.w   SKSSResults_InstallAndRunWidgetMove
; ---------------------------------------------------------------------------

SKSSResults_KeepExtraTextForFullSet:
                tst.w   (Special_stage_spheres_left).w
                bne.w   SKSSResults_DeleteIneligibleWidget
                jsr     SpecialResults_SetOrdinaryEmeraldArt(pc)
                jsr     SpecialResults_SelectEmeraldCountPtr(pc)
                cmpi.b  #7,(a1)
                blo.w   SKSSResults_DeleteIneligibleWidget
                jsr     SKSpecialResults_SelectNamePose(pc)
                sub.w   d0,x_pos(a0)
                sub.w   d0,$46(a0)
                bra.w   SKSSResults_InstallAndRunWidgetMove
; ---------------------------------------------------------------------------

SKSSResults_KeepSuffixForSelectedSet:
                tst.w   (Special_stage_spheres_left).w
                bne.w   SKSSResults_DeleteIneligibleWidget
                jsr     SpecialResults_SetOrdinaryEmeraldArt(pc)
                jsr     SpecialResults_SelectEmeraldCountPtr(pc)
                cmpi.b  #7,(a1)
                blo.w   SKSSResults_DeleteIneligibleWidget
                bra.w   SKSSResults_MoveElementAndDraw
; ---------------------------------------------------------------------------

SKSSResults_InitContinueMapAndFrame:
                move.l  #Map_Results,mappings(a0)
                move.w  #$17C,x_pos(a0)
                move.w  #$14C,y_pos(a0)
                move.w  (Player_mode).w,d0
                subq.w  #1,d0
                bcc.s   SKSSResults_BlinkContinueIndicator
                moveq   #0,d0

SKSSResults_BlinkContinueIndicator:
                addi.w  #$29,d0
                move.b  d0,mapping_frame(a0)
                btst    #3,(Level_frame_counter+1).w
                beq.s   SKSSResults_ContinueBlinkReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSSResults_ContinueBlinkReturn:
                rts
; ---------------------------------------------------------------------------

SKSSResults_TickMessageExitDelay:
                tst.w   $2E(a0)
                beq.s   SKSSResults_DeleteHiddenWidgetAndSignal
                subq.w  #1,$2E(a0)
                bra.s   SKSSResults_DrawExitingWidget
; ---------------------------------------------------------------------------

SKSSResults_DeleteHiddenWidgetAndSignal:
                tst.b   render_flags(a0)
                bmi.s   SKSSResults_MoveVisibleExitRight32
                movea.w parent2(a0),a1
                subq.w  #1,$30(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSSResults_MoveVisibleExitRight32:
                addi.w  #$20,x_pos(a0)

SKSSResults_DrawExitingWidget:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSSResults_TickContinueExitDelay:
                tst.w   $2E(a0)
                beq.s   SKSSResults_DeleteContinueAtX1CC
                subq.w  #1,$2E(a0)
                bra.s   SKSSResults_DrawContinueExitBlink
; ---------------------------------------------------------------------------

SKSSResults_DeleteContinueAtX1CC:
                cmpi.w  #$1CC,x_pos(a0)
                blo.s   SKSSResults_StepContinueRight32
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSSResults_StepContinueRight32:
                addi.w  #$20,x_pos(a0)

SKSSResults_DrawContinueExitBlink:
                btst    #3,(Level_frame_counter+1).w
                beq.s   SKSSResults_ContinueExitBlinkReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSSResults_ContinueExitBlinkReturn:
                rts
; ---------------------------------------------------------------------------

SKSSResults_DeleteIneligibleWidget:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

; Return the region and character-dependent text X offset and mapping frame
SKSpecialResults_SelectNamePose:
                moveq   #0,d0
                moveq   #0,d1
                cmpi.w  #1,(Player_mode).w
                bls.s   .return
                moveq   #-$18,d0
                moveq   #3,d1
                cmpi.w  #3,(Player_mode).w
                beq.s   .return
                moveq   #0,d0
                moveq   #1,d1
                tst.b   (Graphics_flags).w
                bpl.s   .return
                moveq   #4,d0
                moveq   #2,d1

                .return:
                rts
; End of function SKSpecialResults_SelectNamePose

; =============== S U B R O U T I N E =======================================

SpecialResults_SelectEmeraldCountPtr:
                lea     (Chaos_emerald_count).w,a1
                tst.w   (SK_alone_flag).w
                bne.s   .return
                tst.b   (SK_special_stage_flag).w
                beq.s   .return
                addq.w  #1,a1

                .return:
                rts
; End of function SpecialResults_SelectEmeraldCountPtr

; =============== S U B R O U T I N E =======================================

; Use tile 0, palette 3 and low priority. Retain the existing art for lock-on Super stages
SpecialResults_SetOrdinaryEmeraldArt:
                tst.w   (SK_alone_flag).w
                bne.s   SKSSResults_SetOrdinaryTextArt
                tst.b   (SK_special_stage_flag).w
                bne.s   SKSSResults_TextArtUpdateReturn

SKSSResults_SetOrdinaryTextArt:
                move.w  #make_art_tile($000,3,0),art_tile(a0)

SKSSResults_TextArtUpdateReturn:
                rts
; End of function SpecialResults_SetOrdinaryEmeraldArt

; ---------------------------------------------------------------------------

SKSSResults_InitOpposedProjectionPair:
                move.l  #SKSSResults_GetProjectionTrigAndSign,(a0)
                move.b  #$44,render_flags(a0)
                move.w  #make_art_tile(ArtTile_Shield,0,1),art_tile(a0)
                move.l  #Map_Invincibility,mappings(a0)
                moveq   #0,d0
                move.b  (Current_special_stage_2).w,d0
                add.w   d0,d0
                lea     SKSSResults_ProjectionCenterXThenY(pc),a1
                move.w  (a1,d0.w),d1
                addi.w  #$A0,d1
                move.w  d1,x_pos(a0)
                move.w  $10(a1,d0.w),y_pos(a0)
                move.w  #2,mainspr_childsprites(a0)
                move.w  #-$2000,$32(a0)
                tst.w   $36(a0)
                beq.s   SKSSResults_GetProjectionTrigAndSign
                move.w  #$1640,x_pos(a0)
                move.w  #$340,y_pos(a0)
                clr.w   $32(a0)

SKSSResults_GetProjectionTrigAndSign:
                move.w  $2E(a0),d0
                jsr     (GetSineCosine).l
                move.w  $32(a0),d2
                tst.w   d1
                smi     d3
                bpl.s   SKSSResults_ScaleCosineAndRestoreSign
                neg.w   d1

SKSSResults_ScaleCosineAndRestoreSign:
                mulu.w  d2,d1
                swap    d1
                tst.b   d3
                beq.s   SKSSResults_GetSineSignAndMagnitude
                neg.w   d1

SKSSResults_GetSineSignAndMagnitude:
                tst.w   d0
                smi     d3
                bpl.s   SKSSResults_ScaleSineAndRestoreSign
                neg.w   d0

SKSSResults_ScaleSineAndRestoreSign:
                mulu.w  d2,d0
                swap    d0
                tst.b   d3
                beq.s   SKSSResults_AdvanceProjectionFrame0To8
                neg.w   d0

SKSSResults_AdvanceProjectionFrame0To8:
                move.w  $30(a0),d2
                addq.w  #1,d2
                cmpi.w  #8,d2
                bls.s   SKSSResults_ProjectPairAndUpdateRadius
                moveq   #0,d2

SKSSResults_ProjectPairAndUpdateRadius:
                move.w  d2,$30(a0)
                lea     sub2_x_pos(a0),a1
                move.w  x_pos(a0),d3
                add.w   d1,d3
                move.w  d3,(a1)+
                move.w  y_pos(a0),d3
                add.w   d0,d3
                move.w  d3,(a1)+
                move.w  d2,(a1)+
                neg.w   d1
                add.w   x_pos(a0),d1
                move.w  d1,(a1)+
                neg.w   d0
                add.w   y_pos(a0),d0
                move.w  d0,(a1)+
                move.w  d2,(a1)+
                addq.w  #2,$2E(a0)
                tst.w   $36(a0)
                bne.s   SKSSResults_GrowRadiusUntilCarry
                subi.w  #$100,$32(a0)
                bcs.s   SKSSResults_SignalProjectionAndDelete
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSSResults_SignalProjectionAndDelete:
                movea.w $34(a0),a1
                st      $31(a1)
                clr.b   (_unkFAC0).w
                bra.s   SKSSResults_DeleteFinishedProjection
; ---------------------------------------------------------------------------

SKSSResults_GrowRadiusUntilCarry:
                addi.w  #$100,$32(a0)
                bcs.s   SKSSResults_DeleteFinishedProjection
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSSResults_DeleteFinishedProjection:
                jmp     (Delete_Current_Sprite).l
; End of function SKSSResults_InitOpposedProjectionPair
