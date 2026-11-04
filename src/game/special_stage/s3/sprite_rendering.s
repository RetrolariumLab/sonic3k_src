; Owner: game/special_stage/s3
; Responsibility: Special stage sprite projection, normal and departing sphere display and product-specific sprite output
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
S3SS_QuarterTurnGridScanTable:
                dc.w    $18
                dc.w    6
                dc.w    1
                dc.w    $1F
                dc.w    $FFFF
                dc.w    $1F
                dc.w    0
                dc.w    0
                dc.w    8
                dc.w    6
                dc.w    $FFFF
                dc.w    $1F
                dc.w    $FFFF
                dc.w    $1F
                dc.w    0
                dc.w    0
                dc.w    8
                dc.w    $1A
                dc.w    $FFFF
                dc.w    $1F
                dc.w    1
                dc.w    $1F
                dc.w    0
                dc.w    0
                dc.w    $18
                dc.w    $1A
                dc.w    1
                dc.w    $1F
                dc.w    1
                dc.w    $1F
                dc.w    0
                dc.w    0

; =============== S U B R O U T I N E =======================================

Draw_SSSprites:
                move.b  (Special_stage_angle).w,d0
                andi.w  #$C0,d0
                lsr.w   #2,d0
                lea     S3SS_QuarterTurnGridScanTable(pc,d0.w),a5
                moveq   #0,d1
                move.b  (Special_stage_X_pos).w,d1
                move.w  (Special_stage_X_pos).w,d0
                addi.w  #$100,d0
                move.w  (Special_stage_Y_pos).w,d2
                andi.w  #$100,d2
                add.w   d2,d0
                btst    #6,(Special_stage_angle).w
                bne.s   S3SS_FoldProjectionPhase
                move.b  (Special_stage_Y_pos).w,d1
                move.w  (Special_stage_Y_pos).w,d0
                move.w  (Special_stage_X_pos).w,d2
                andi.w  #$100,d2
                add.w   d2,d0

S3SS_FoldProjectionPhase:
                tst.b   (Special_stage_angle).w
                bmi.s   S3SS_StorePhaseAndSetTurningGlobe
                neg.w   d0
                addi.w  #$1F,d0
                move.w  d0,d2
                andi.w  #$E0,d2
                beq.s   S3SS_StorePhaseAndSetTurningGlobe
                addq.b  #1,d1

; The turn overrides the globe frame and leaves the straight palette phase in place
S3SS_StorePhaseAndSetTurningGlobe:
                andi.w  #$1E0,d0
                lsr.w   #5,d0
                move.w  d0,(Special_stage_anim_frame).w
                move.b  d0,(Special_stage_palette_frame).w
                move.b  (Special_stage_angle).w,d0
                andi.w  #$38,d0
                beq.s   S3SS_SelectNormalOrFlyawayEmitter
                lsr.w   #3,d0
                addi.w  #$F,d0
                move.w  d0,(Special_stage_anim_frame).w

S3SS_SelectNormalOrFlyawayEmitter:
                lea     (Draw_SSSprite_Normal).l,a0
                tst.w   (Special_stage_clear_timer).w
                beq.s   S3SS_InitRowScanAndSpriteBudget
                lea     (Draw_SSSprite_FlyAway).l,a0

S3SS_InitRowScanAndSpriteBudget:
                btst    #6,(Special_stage_angle).w
                bne.w   S3SS_InitColumnScanAndBudget
                move.w  2(a5),d5
                add.w   d1,d5
                and.w   $A(a5),d5
                move.w  (Special_stage_anim_frame).w,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (SStage_PerspectiveMapPtrs).l,a1
                movea.l (a1,d0.w),a1
                lea     (Level_layout_header).w,a2
                lea     (SStage_extra_sprites).w,a4
                lea     (Sprite_table).w,a6
                moveq   #$50-1,d7
                moveq   #0,d6
                move.b  (Sprites_drawn).w,d6
                sub.b   d6,d7
                lsl.w   #3,d6
                adda.w  d6,a6
                moveq   #$10-1,d2

S3SS_BeginXInnerRow:
                move.w  (a5),d4
                moveq   #0,d0
                move.b  (Special_stage_X_pos).w,d0
                add.w   d0,d4
                and.w   6(a5),d4
                moveq   #$F-1,d3

S3SS_FilterRowCellAndDistance:
                move.w  d5,d0
                lsl.w   #5,d0
                or.b    d4,d0
                move.b  (a2,d0.w),d0
                beq.s   S3SS_StepRowPerspectiveAndGrid
                move.w  (a1),d1
                andi.w  #$7C,d1
                beq.s   S3SS_StepRowPerspectiveAndGrid
                lsr.w   #2,d1
                subq.w  #6,d1
                cmpi.w  #$10,d1
                bhs.s   S3SS_StepRowPerspectiveAndGrid
                add.w   d1,d1
                andi.w  #$FF,d0
                lsl.w   #3,d0
                movea.l (a4,d0.w),a3
                move.w  4(a4,d0.w),d6
                cmpi.w  #$54,(a1)
                blo.s   S3SS_ApplyRowFrameControl
                andi.w  #$7FFF,d6

S3SS_ApplyRowFrameControl:
                move.w  6(a4,d0.w),d0
                add.w   d0,d0
                bcc.s   S3SS_EmitRowMapBeforeBudgetCheck
                moveq   #0,d1

S3SS_EmitRowMapBeforeBudgetCheck:
                add.w   d0,d1
                adda.w  (a3,d1.w),a3
                move.w  (a3)+,d1
                subq.w  #1,d1
                bmi.s   S3SS_StepRowPerspectiveAndGrid
                jsr     (a0)
                tst.w   d7
                bmi.s   S3SS_RowScanReturn

S3SS_StepRowPerspectiveAndGrid:
                addq.w  #6,a1
                add.w   4(a5),d4
                and.w   6(a5),d4
                dbf     d3,S3SS_FilterRowCellAndDistance
                add.w   8(a5),d5
                and.w   $A(a5),d5
                dbf     d2,S3SS_BeginXInnerRow

S3SS_RowScanReturn:
                rts
; ---------------------------------------------------------------------------

S3SS_InitColumnScanAndBudget:
                move.w  2(a5),d5
                add.w   d1,d5
                and.w   $A(a5),d5
                move.w  (Special_stage_anim_frame).w,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (SStage_PerspectiveMapPtrs).l,a1
                movea.l (a1,d0.w),a1
                lea     (Level_layout_header).w,a2
                lea     (SStage_extra_sprites).w,a4
                lea     (Sprite_table).w,a6
                moveq   #80-1,d7
                moveq   #0,d6
                move.b  (Sprites_drawn).w,d6
                sub.b   d6,d7
                lsl.w   #3,d6
                adda.w  d6,a6
                moveq   #$10-1,d2

S3SS_BeginYInnerColumn:
                move.w  (a5),d4
                moveq   #0,d0
                move.b  (Special_stage_Y_pos).w,d0
                add.w   d0,d4
                and.w   6(a5),d4
                moveq   #$F-1,d3

S3SS_FilterColumnCellAndDistance:
                move.w  d4,d0
                lsl.w   #5,d0
                or.b    d5,d0
                move.b  (a2,d0.w),d0
                beq.s   S3SS_StepColumnPerspectiveAndGrid
                move.w  (a1),d1
                andi.w  #$7C,d1
                beq.s   S3SS_StepColumnPerspectiveAndGrid
                lsr.w   #2,d1
                subq.w  #6,d1
                cmpi.w  #$10,d1
                bhs.s   S3SS_StepColumnPerspectiveAndGrid
                add.w   d1,d1
                andi.w  #$FF,d0
                lsl.w   #3,d0
                movea.l (a4,d0.w),a3
                move.w  4(a4,d0.w),d6
                cmpi.w  #$54,(a1)
                blo.s   S3SS_ApplyColumnFrameControl
                andi.w  #$7FFF,d6

S3SS_ApplyColumnFrameControl:
                move.w  6(a4,d0.w),d0
                add.w   d0,d0
                bcc.s   S3SS_EmitColumnMapBeforeBudgetCheck
                moveq   #0,d1

S3SS_EmitColumnMapBeforeBudgetCheck:
                add.w   d0,d1
                adda.w  (a3,d1.w),a3
                move.w  (a3)+,d1
                subq.w  #1,d1
                bmi.s   S3SS_StepColumnPerspectiveAndGrid
                jsr     (a0)
                tst.w   d7
                bmi.s   S3SS_ColumnScanReturn

S3SS_StepColumnPerspectiveAndGrid:
                addq.w  #6,a1
                add.w   4(a5),d4
                and.w   6(a5),d4
                dbf     d3,S3SS_FilterColumnCellAndDistance
                add.w   8(a5),d5
                and.w   $A(a5),d5
                dbf     d2,S3SS_BeginYInnerColumn

; Leave the published sprite count unchanged at this return
S3SS_ColumnScanReturn:
                rts
; End of function Draw_SSSprites

; ---------------------------------------------------------------------------

Draw_SSSprite_Normal:
                move.b  (a3)+,d0
                ext.w   d0
                add.w   4(a1),d0
                move.w  d0,(a6)+
                move.b  (a3)+,(a6)+
                addq.w  #1,a6
                move.w  (a3)+,d0
                add.w   d6,d0
                move.w  d0,(a6)+
                move.w  (a3)+,d0
                add.w   2(a1),d0
                move.w  d0,(a6)+
                subq.w  #1,d7
                dbmi    d1,Draw_SSSprite_Normal
                rts
; ---------------------------------------------------------------------------

Draw_SSSprite_FlyAway:
                move.b  (a3)+,d0
                ext.w   d0
                add.w   4(a1),d0
                sub.w   (Special_stage_clear_timer).w,d0
                move.w  d0,(a6)+
                move.b  (a3)+,(a6)+
                addq.w  #1,a6
                move.w  (a3)+,d0
                add.w   d6,d0
                move.w  d0,(a6)+
                move.w  (a3)+,d0
                add.w   2(a1),d0
                move.w  d1,-(sp)
                subi.w  #$120,d0
                move.w  (Special_stage_clear_timer).w,d1
                addi.w  #$100,d1
                muls.w  d1,d0
                asr.l   #8,d0
                addi.w  #$120,d0
                cmpi.w  #$1D0,d0
                blo.s   S3SS_StoreFlyawayPieceX
                move.w  #1,d0

S3SS_StoreFlyawayPieceX:
                move.w  (sp)+,d1
                move.w  d0,(a6)+
                subq.w  #1,d7
                dbmi    d1,Draw_SSSprite_FlyAway
                rts

; =============== S U B R O U T I N E =======================================

SStage_UpdateClearSequence:
                move.b  (Special_stage_clear_routine).w,d1
                beq.w   S3SS_ClearUpdateReturn
                subq.b  #1,d1
                bne.w   S3SS_WaitForArtAndTickReveal
                cmpi.w  #$100,(Special_stage_clear_timer).w
                bhs.s   S3SS_AdvanceClearAndPrepEmerald
                addq.w  #2,(Special_stage_clear_timer).w
                cmpi.w  #2,(Special_stage_clear_timer).w
                bne.s   S3SS_AccelerateFlyawayTimer
                moveq   #signextendB(sfx_AllSpheres),d0
                jsr     (Play_Music).l

S3SS_AccelerateFlyawayTimer:
                cmpi.w  #$40,(Special_stage_clear_timer).w
                blo.s   S3SS_FlyawayTimerReturn
                addq.w  #1,(Special_stage_clear_timer).w
                cmpi.w  #$80,(Special_stage_clear_timer).w
                blo.s   S3SS_FlyawayTimerReturn
                addq.w  #1,(Special_stage_clear_timer).w

S3SS_FlyawayTimerReturn:
                rts
; ---------------------------------------------------------------------------

S3SS_AdvanceClearAndPrepEmerald:
                addq.b  #1,(Special_stage_clear_routine).w
                lea     (Level_layout_header).w,a1
                move.w  #bytesToLcnt($400),d0

S3SS_WipeGridBeforeEmerald:
                move.l  #0,(a1)+
                dbf     d0,S3SS_WipeGridBeforeEmerald
                move.b  (Special_stage_angle).w,d0
                jsr     (GetSineCosine).l
                move.w  (Special_stage_X_pos).w,d2
                move.w  (Special_stage_Y_pos).w,d3
                asl.w   #3,d0
                asl.w   #3,d1
                sub.w   d0,d2
                sub.w   d1,d3
                lea     (Level_layout_header).w,a1
                move.w  d2,d0
                addi.w  #$80,d0
                lsr.w   #8,d0
                andi.w  #$1F,d0
                move.w  d3,d1
                addi.w  #$80,d1
                lsr.w   #8,d1
                andi.w  #$1F,d1
                lsl.w   #5,d1
                or.b    d0,d1
                move.b  #$A,(a1,d1.w)
                move.w  d1,(Special_stage_interact).w
                move.w  #$800,(Special_stage_velocity).w
                move.b  #120,(Special_stage_emerald_timer).w
                moveq   #0,d0
                move.b  (Current_special_stage).w,d0
                lea     (Pal_SStage_Emeralds).l,a1
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                lea     (Normal_palette_line_4+$4).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                lea     (ArtKosM_SStageChaosEmerald).l,a1
                move.w  #tiles_to_bytes(ArtTile_SStage_Emerald),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

S3SS_WaitForArtAndTickReveal:
                subq.b  #1,d1
                bne.s   S3SS_CheckAlignedEmeraldContact
                tst.b   (Kos_modules_left).w
                bne.s   S3SS_EmeraldRevealWaitReturn
                move.w  #0,(Special_stage_clear_timer).w
                subq.b  #1,(Special_stage_emerald_timer).w
                bne.s   S3SS_EmeraldRevealWaitReturn
                addq.b  #1,(Special_stage_clear_routine).w
                moveq   #signextendB(mus_Emerald),d0
                jsr     (Play_Music).l

S3SS_EmeraldRevealWaitReturn:
                rts
; ---------------------------------------------------------------------------

S3SS_CheckAlignedEmeraldContact:
                subq.b  #1,d1
                bne.s   S3SS_ClearUpdateReturn
                move.w  (Special_stage_X_pos).w,d0
                addi.w  #$80,d0
                lsr.w   #8,d0
                andi.w  #$1F,d0
                move.w  (Special_stage_Y_pos).w,d1
                addi.w  #$80,d1
                lsr.w   #8,d1
                andi.w  #$1F,d1
                lsl.w   #5,d1
                or.b    d0,d1
                cmp.w   (Special_stage_interact).w,d1
                bne.s   S3SS_ClearUpdateReturn
                move.w  (Special_stage_X_pos).w,d0
                or.w    (Special_stage_Y_pos).w,d0
                andi.w  #$E0,d0
                bne.s   S3SS_ClearUpdateReturn
                cmpi.w  #7,(Chaos_emerald_count).w
                bhs.s   S3SS_StartClearFadeAndResults
                addq.w  #1,(Chaos_emerald_count).w
                lea     (Collected_emeralds_array).w,a1
                moveq   #0,d0
                move.b  (Current_special_stage).w,d0
                move.b  #1,(a1,d0.w)

S3SS_StartClearFadeAndResults:
                addq.b  #1,(Special_stage_clear_routine).w
                move.b  #1,(Special_stage_fade_timer).w
                move.b  #GameMode_SpecialStageResults,(Game_mode).w
                tst.b   (Special_bonus_entry_flag).w
                beq.s   S3SS_PlayClearGoalSound
                move.w  (Saved2_zone_and_act).w,(Current_zone_and_act).w
                ori.b   #$80,(Last_star_post_hit).w

S3SS_PlayClearGoalSound:
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

S3SS_ClearUpdateReturn:
                rts
; End of function SStage_UpdateClearSequence
