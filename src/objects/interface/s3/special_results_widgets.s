; Owner: objects/interface/s3
; Responsibility: Special-stage results text, emerald display, tally elements and product-specific emerald projection effects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

S3SSResults_MoveElementAndDraw:
                jsr     LevelResults_MoveElement(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SSResults_MoveAndReadRingBonus:
                jsr     LevelResults_MoveElement(pc)
                move.w  (Ring_bonus_countdown).w,d0
                bra.s   S3SSResults_WriteSevenDigitsAndDraw
; ---------------------------------------------------------------------------

S3SSResults_MoveAndReadPerfectBonus:
                jsr     LevelResults_MoveElement(pc)
                move.w  (Time_bonus_countdown).w,d0

S3SSResults_WriteSevenDigitsAndDraw:
                jsr     LevResults_DisplayScore(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SSResults_Keep50RingContinueLabel:
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.w   S3SSResults_DeleteIneligibleWidget
                jsr     LevelResults_MoveElement(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SSResults_BlinkCollectedEmerald:
                lea     (Collected_emeralds_array).w,a1
                moveq   #0,d0
                move.b  width_pixels(a0),d0
                tst.b   (a1,d0.w)
                beq.w   S3SSResults_DeleteIneligibleWidget
                btst    #0,(Level_frame_counter+1).w
                beq.s   S3SSResults_EmeraldBlinkReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SSResults_EmeraldBlinkReturn:
                rts
; ---------------------------------------------------------------------------

S3SSResults_KeepFailureWithSpheresLeft:
                tst.w   (Special_stage_spheres_left).w
                beq.w   S3SSResults_DeleteIneligibleWidget
                bra.s   S3SSResults_MoveElementAndDraw
; ---------------------------------------------------------------------------

S3SSResults_PrepSuccessNameAndFullShift:
                tst.w   (Special_stage_spheres_left).w
                bne.w   S3SSResults_DeleteIneligibleWidget
                jsr     S3SpecialResults_SelectNamePose(pc)
                add.w   d0,x_pos(a0)
                add.w   d0,$46(a0)
                add.b   d1,mapping_frame(a0)
                cmpi.b  #7,(Chaos_emerald_count+1).w
                blo.s   S3SSResults_InstallNameMovement
                subi.w  #$10,x_pos(a0)
                subi.w  #$10,$46(a0)

S3SSResults_InstallNameMovement:
                lea     (S3SSResults_MoveElementAndDraw).l,a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

S3SSResults_PrepOppositeNameOffsetText:
                tst.w   (Special_stage_spheres_left).w
                bne.w   S3SSResults_DeleteIneligibleWidget
                jsr     S3SpecialResults_SelectNamePose(pc)
                sub.w   d0,x_pos(a0)
                sub.w   d0,$46(a0)
                cmpi.b  #7,(Chaos_emerald_count+1).w
                blo.s   S3SSResults_InstallCompanionTextMove
                subi.w  #$10,x_pos(a0)
                subi.w  #$10,$46(a0)

S3SSResults_InstallCompanionTextMove:
                lea     (S3SSResults_MoveElementAndDraw).l,a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

S3SSResults_PrepEmeraldTextAndFullShift:
                tst.w   (Special_stage_spheres_left).w
                bne.w   S3SSResults_DeleteIneligibleWidget
                cmpi.b  #7,(Chaos_emerald_count+1).w
                blo.s   S3SSResults_InstallShiftedTextMove
                subq.w  #8,x_pos(a0)
                subq.w  #8,$46(a0)

S3SSResults_InstallShiftedTextMove:
                lea     (S3SSResults_MoveElementAndDraw).l,a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

S3SSResults_KeepExtraTextForFullSet:
                tst.w   (Special_stage_spheres_left).w
                bne.w   S3SSResults_DeleteIneligibleWidget
                cmpi.b  #7,(Chaos_emerald_count+1).w
                blo.w   S3SSResults_DeleteIneligibleWidget
                jsr     S3SpecialResults_SelectNamePose(pc)
                sub.w   d0,x_pos(a0)
                sub.w   d0,$46(a0)
                lea     (S3SSResults_MoveElementAndDraw).l,a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

S3SSResults_KeepSuffixAfterClear:
                tst.w   (Special_stage_spheres_left).w
                bne.w   S3SSResults_DeleteIneligibleWidget
                cmpi.b  #7,(Chaos_emerald_count+1).w
                blo.s   S3SSResults_DeleteIneligibleWidget
                bra.w   S3SSResults_MoveElementAndDraw
; ---------------------------------------------------------------------------

S3SSResults_InitContinueMapAndFrame:
                move.l  #Map_Results,mappings(a0)
                move.w  #$17C,x_pos(a0)
                move.w  #$14C,y_pos(a0)
                move.w  (Player_mode).w,d0
                subq.w  #1,d0
                bcc.s   S3SSResults_BlinkContinueIndicator
                moveq   #0,d0

S3SSResults_BlinkContinueIndicator:
                addi.w  #$29,d0
                move.b  d0,mapping_frame(a0)
                btst    #3,(Level_frame_counter+1).w
                beq.s   S3SSResults_ContinueBlinkReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SSResults_ContinueBlinkReturn:
                rts
; ---------------------------------------------------------------------------

S3SSResults_TickWidgetExitDelay:
                tst.w   $2E(a0)
                beq.s   S3SSResults_DeleteHiddenWidgetAndSignal
                subq.w  #1,$2E(a0)
                bra.s   S3SSResults_DrawExitingWidget
; ---------------------------------------------------------------------------

S3SSResults_DeleteHiddenWidgetAndSignal:
                tst.b   render_flags(a0)
                bmi.s   S3SSResults_MoveVisibleExitRight32
                movea.w parent2(a0),a1
                subq.w  #1,$30(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3SSResults_MoveVisibleExitRight32:
                addi.w  #$20,x_pos(a0)

S3SSResults_DrawExitingWidget:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SSResults_DeleteIneligibleWidget:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

; Return the region and character-dependent text X offset and mapping frame
S3SpecialResults_SelectNamePose:
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
; End of function S3SpecialResults_SelectNamePose
