; Owner: game/special_stage/sk
; Responsibility: Special stage sprite projection, normal and departing sphere display and product-specific sprite output
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
SKSS_QuarterTurnGridScanTable:
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
                lea     SKSS_QuarterTurnGridScanTable(pc,d0.w),a5
                moveq   #0,d1
                move.b  (Special_stage_X_pos).w,d1
                move.w  (Special_stage_X_pos).w,d0
                addi.w  #$100,d0
                move.w  (Special_stage_Y_pos).w,d2
                andi.w  #$100,d2
                add.w   d2,d0
                btst    #6,(Special_stage_angle).w
                bne.s   SKSS_FoldProjectionPhase
                move.b  (Special_stage_Y_pos).w,d1
                move.w  (Special_stage_Y_pos).w,d0
                move.w  (Special_stage_X_pos).w,d2
                andi.w  #$100,d2
                add.w   d2,d0

SKSS_FoldProjectionPhase:
                tst.b   (Special_stage_angle).w
                bmi.s   SKSS_StorePhaseAndSetTurningView
                neg.w   d0
                addi.w  #$1F,d0
                move.w  d0,d2
                andi.w  #$E0,d2
                beq.s   SKSS_StorePhaseAndSetTurningView
                addq.b  #1,d1

SKSS_StorePhaseAndSetTurningView:
                andi.w  #$1E0,d0
                lsr.w   #5,d0
                move.w  d0,(Special_stage_anim_frame).w
                move.b  d0,(Special_stage_palette_frame).w
                move.b  (Special_stage_angle).w,d0
                andi.w  #$38,d0
                beq.s   SKSS_SelectNormalOrFlyawayEmitter
                lsr.w   #3,d0
                addi.w  #$F,d0
                move.w  d0,(Special_stage_anim_frame).w

SKSS_SelectNormalOrFlyawayEmitter:
                lea     (Draw_SSSprite_Normal).l,a0
                tst.w   (Special_stage_clear_timer).w
                beq.s   SKSS_InitRowScanAndSpriteBudget
                lea     (Draw_SSSprite_FlyAway).l,a0

SKSS_InitRowScanAndSpriteBudget:
                btst    #6,(Special_stage_angle).w
                bne.w   SKSS_InitColumnScanAndBudget
                move.w  2(a5),d5
                add.w   d1,d5
                and.w   $A(a5),d5
                move.w  (Special_stage_anim_frame).w,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (RAM_start).l,a1
                movea.l (a1,d0.w),a1
                lea     (SStage_layout_buffer+$100).w,a2
                lea     (SStage_extra_sprites).w,a4
                lea     (Sprite_table).w,a6
                moveq   #$50-1,d7
                moveq   #0,d6
                move.b  (Sprites_drawn).w,d6
                sub.b   d6,d7
                lsl.w   #3,d6
                adda.w  d6,a6
                moveq   #$10-1,d2

SKSStage_BeginRowMajorGridColumnSequence:
                move.w  (a5),d4
                moveq   #0,d0
                move.b  (Special_stage_X_pos).w,d0
                add.w   d0,d4
                and.w   6(a5),d4
                moveq   #$F-1,d3

SKSS_FilterRowCellAndDistance:
                move.w  d5,d0
                lsl.w   #5,d0
                or.b    d4,d0
                move.b  (a2,d0.w),d0
                beq.s   SKSS_StepRowPerspectiveAndGrid
                move.w  (a1),d1
                andi.w  #$7C,d1
                beq.s   SKSS_StepRowPerspectiveAndGrid
                lsr.w   #2,d1
                subq.w  #6,d1
                cmpi.w  #$10,d1
                bhs.s   SKSS_StepRowPerspectiveAndGrid
                add.w   d1,d1
                andi.w  #$FF,d0
                lsl.w   #3,d0
                movea.l (a4,d0.w),a3
                move.w  4(a4,d0.w),d6
                cmpi.w  #$54,(a1)
                blo.s   SKSS_ApplyRowFrameControl
                andi.w  #$7FFF,d6

; A carry from doubling the frame word forces distance index zero
SKSS_ApplyRowFrameControl:
                move.w  6(a4,d0.w),d0
                add.w   d0,d0
                bcc.s   SKSS_EmitNonemptyRowMap
                moveq   #0,d1

SKSS_EmitNonemptyRowMap:
                add.w   d0,d1
                adda.w  (a3,d1.w),a3
                move.w  (a3)+,d1
                subq.w  #1,d1
                bmi.s   SKSS_StepRowPerspectiveAndGrid
                jsr     (a0)
                tst.w   d7
                bmi.s   SKSS_RowScanReturn

SKSS_StepRowPerspectiveAndGrid:
                addq.w  #6,a1
                add.w   4(a5),d4
                and.w   6(a5),d4
                dbf     d3,SKSS_FilterRowCellAndDistance
                add.w   8(a5),d5
                and.w   $A(a5),d5
                dbf     d2,SKSStage_BeginRowMajorGridColumnSequence

SKSS_RowScanReturn:
                rts
; ---------------------------------------------------------------------------

SKSS_InitColumnScanAndBudget:
                move.w  2(a5),d5
                add.w   d1,d5
                and.w   $A(a5),d5
                move.w  (Special_stage_anim_frame).w,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (RAM_start).l,a1
                movea.l (a1,d0.w),a1
                lea     (SStage_layout_buffer+$100).w,a2
                lea     (SStage_extra_sprites).w,a4
                lea     (Sprite_table).w,a6
                moveq   #$50-1,d7
                moveq   #0,d6
                move.b  (Sprites_drawn).w,d6
                sub.b   d6,d7
                lsl.w   #3,d6
                adda.w  d6,a6
                moveq   #$10-1,d2

SKSS_BeginYInnerColumn:
                move.w  (a5),d4
                moveq   #0,d0
                move.b  (Special_stage_Y_pos).w,d0
                add.w   d0,d4
                and.w   6(a5),d4
                moveq   #$F-1,d3

SKSS_FilterColumnCellAndDistance:
                move.w  d4,d0
                lsl.w   #5,d0
                or.b    d5,d0
                move.b  (a2,d0.w),d0
                beq.s   SKSS_StepColumnPerspectiveAndGrid
                move.w  (a1),d1
                andi.w  #$7C,d1
                beq.s   SKSS_StepColumnPerspectiveAndGrid
                lsr.w   #2,d1
                subq.w  #6,d1
                cmpi.w  #$10,d1
                bhs.s   SKSS_StepColumnPerspectiveAndGrid
                add.w   d1,d1
                andi.w  #$FF,d0
                lsl.w   #3,d0
                movea.l (a4,d0.w),a3
                move.w  4(a4,d0.w),d6
                cmpi.w  #$54,(a1)
                blo.s   SKSS_ApplyColumnFrameControl
                andi.w  #$7FFF,d6

; A carry from doubling the frame word forces distance index zero
SKSS_ApplyColumnFrameControl:
                move.w  6(a4,d0.w),d0
                add.w   d0,d0
                bcc.s   SKSS_EmitNonemptyColumnMap
                moveq   #0,d1

SKSS_EmitNonemptyColumnMap:
                add.w   d0,d1
                adda.w  (a3,d1.w),a3
                move.w  (a3)+,d1
                subq.w  #1,d1
                bmi.s   SKSS_StepColumnPerspectiveAndGrid
                jsr     (a0)
                tst.w   d7
                bmi.s   SKSS_ColumnScanReturn

SKSS_StepColumnPerspectiveAndGrid:
                addq.w  #6,a1
                add.w   4(a5),d4
                and.w   6(a5),d4
                dbf     d3,SKSS_FilterColumnCellAndDistance
                add.w   8(a5),d5
                and.w   $A(a5),d5
                dbf     d2,SKSS_BeginYInnerColumn

SKSS_ColumnScanReturn:
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
                blo.s   SKSS_StoreFlyawayPieceX
                move.w  #1,d0

SKSS_StoreFlyawayPieceX:
                move.w  (sp)+,d1
                move.w  d0,(a6)+
                subq.w  #1,d7
                dbmi    d1,Draw_SSSprite_FlyAway
                rts

; =============== S U B R O U T I N E =======================================

SStage_UpdateClearSequence:
                move.b  (Special_stage_clear_routine).w,d1
                beq.w   SKSS_ClearUpdateReturn
                subq.b  #1,d1
                bne.w   SKSS_WaitForArtAndTickReveal
                cmpi.w  #$100,(Special_stage_clear_timer).w
                bhs.s   SKSS_AdvanceClearAndPrepGridWipe
                addq.w  #2,(Special_stage_clear_timer).w
                cmpi.w  #2,(Special_stage_clear_timer).w
                bne.s   SKSS_AccelerateFlyawayTimer
                moveq   #signextendB(sfx_AllSpheres),d0
                jsr     (Play_Music).l

SKSS_AccelerateFlyawayTimer:
                cmpi.w  #$40,(Special_stage_clear_timer).w
                blo.s   SKSS_FlyawayTimerReturn
                addq.w  #1,(Special_stage_clear_timer).w
                cmpi.w  #$80,(Special_stage_clear_timer).w
                blo.s   SKSS_FlyawayTimerReturn
                addq.w  #1,(Special_stage_clear_timer).w

SKSS_FlyawayTimerReturn:
                rts
; ---------------------------------------------------------------------------

SKSS_AdvanceClearAndPrepGridWipe:
                addq.b  #1,(Special_stage_clear_routine).w
                lea     (SStage_layout_buffer+$100).w,a1
                move.w  #bytesToLcnt($400),d0

SKSS_WipeGridAndPlaceEmerald:
                move.l  #0,(a1)+
                dbf     d0,SKSS_WipeGridAndPlaceEmerald
                move.b  (Special_stage_angle).w,d0
                jsr     (GetSineCosine).l
                move.w  (Special_stage_X_pos).w,d2
                move.w  (Special_stage_Y_pos).w,d3
                asl.w   #3,d0
                asl.w   #3,d1
                sub.w   d0,d2
                sub.w   d1,d3
                lea     (SStage_layout_buffer+$100).w,a1
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
                move.b  #$B,(a1,d1.w)
                tst.b   (SK_special_stage_flag).w
                beq.s   SKSS_StoreEmeraldAndSelectPalette
                move.b  #$D,(a1,d1.w)

SKSS_StoreEmeraldAndSelectPalette:
                move.w  d1,(Special_stage_interact).w
                move.w  #$800,(Special_stage_velocity).w
                move.b  #120,(Special_stage_emerald_timer).w
                moveq   #0,d0
                move.b  (Current_special_stage).w,d0
                tst.b   (Blue_spheres_stage_flag).w
                beq.s   SKSS_CopyPaletteAndChooseEmeraldArt
                move.b  (Blue_spheres_current_stage+2).w,d0

SKSS_CopyPaletteAndChooseEmeraldArt:
                andi.w  #7,d0
                lea     (Pal_SStage_Emeralds).l,a1
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                lea     (Normal_palette_line_4+$4).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                lea     (ArtKosM_SStageChaosEmerald).l,a1
                tst.b   (SK_special_stage_flag).w
                beq.s   SKSS_QueueEmeraldArtAtRingTiles
                lea     (ArtKosM_SStageSuperEmerald).l,a1

SKSS_QueueEmeraldArtAtRingTiles:
                move.w  #tiles_to_bytes(ArtTile_SStage_Emerald),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

SKSS_WaitForArtAndTickReveal:
                subq.b  #1,d1
                bne.s   SKSS_CheckAlignedEmeraldContact
                tst.b   (Kos_modules_left).w
                bne.s   SKSS_EmeraldRevealWaitReturn
                move.w  #0,(Special_stage_clear_timer).w
                subq.b  #1,(Special_stage_emerald_timer).w
                bne.s   SKSS_EmeraldRevealWaitReturn
                addq.b  #1,(Special_stage_clear_routine).w
                moveq   #signextendB(mus_Emerald),d0
                jsr     (Play_Music).l

SKSS_EmeraldRevealWaitReturn:
                rts
; ---------------------------------------------------------------------------

SKSS_CheckAlignedEmeraldContact:
                subq.b  #1,d1
                bne.w   SKSS_ClearUpdateReturn
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
                bne.s   SKSS_ClearUpdateReturn
                move.w  (Special_stage_X_pos).w,d0
                or.w    (Special_stage_Y_pos).w,d0
                andi.w  #$E0,d0
                bne.s   SKSS_ClearUpdateReturn
                tst.b   (Blue_spheres_stage_flag).w
                bne.s   SKSS_SelectStageOrBlueSphereResults
                lea     (Chaos_emerald_count).w,a2
                move.b  (SK_special_stage_flag).w,d2
                beq.s   SKSS_CountEmeraldAndMarkCollected
                lea     (Super_emerald_count).w,a2

SKSS_CountEmeraldAndMarkCollected:
                cmpi.b  #7,(a2)
                bhs.s   SKSS_SelectStageOrBlueSphereResults
                addq.b  #1,(a2)
                lea     (Collected_emeralds_array).w,a1
                moveq   #0,d0
                move.b  (Current_special_stage).w,d0
                bset    #0,(a1,d0.w)

SKSS_SelectStageOrBlueSphereResults:
                addq.b  #1,(Special_stage_clear_routine).w
                move.b  #1,(Special_stage_fade_timer).w
                move.b  #GameMode_SpecialStageResults,(Game_mode).w
                tst.b   (Blue_spheres_stage_flag).w
                beq.s   SKSS_RestoreZoneAfterStageClear
                move.b  #GameMode_BlueSpheresResults,(Game_mode).w

SKSS_RestoreZoneAfterStageClear:
                tst.b   (Special_bonus_entry_flag).w
                beq.s   SKSS_PlayClearGoalSound
                move.w  (Saved2_zone_and_act).w,(Current_zone_and_act).w
                ori.b   #$80,(Last_star_post_hit).w

SKSS_PlayClearGoalSound:
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

SKSS_ClearUpdateReturn:
                rts
; End of function SStage_UpdateClearSequence
