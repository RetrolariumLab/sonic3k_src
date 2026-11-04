; Owner: rendering/sk
; Responsibility: One and two player HUD drawing, score, rings, time, lives and numeric glyph output
; Source provenance and ranges: config/reconstruction/source_layout.json
Render_HUD_P1:
                tst.w   (Debug_mode_flag).w
                bne.s   Render_HUD
                rts
; End of function Render_HUD_P1

; =============== S U B R O U T I N E =======================================

Render_HUD:
                cmpi.b  #$16,(Current_zone).w
                bhs.s   SKHUD_SelectFullHudFlashFrame
                cmpi.b  #$13,(Current_zone).w
                blo.s   SKHUD_SelectFullHudFlashFrame
                moveq   #8,d4
                btst    #3,(Level_frame_counter+1).w
                bne.s   SKHUD_AdvanceSignedHudSlideByte
                tst.w   (Ring_count).w
                bne.s   SKHUD_AdvanceSignedHudSlideByte
                addq.w  #2,d4
                bra.s   SKHUD_AdvanceSignedHudSlideByte
; ---------------------------------------------------------------------------

SKHUD_SelectFullHudFlashFrame:
                moveq   #0,d4
                btst    #3,(Level_frame_counter+1).w
                bne.s   SKHUD_AdvanceSignedHudSlideByte
                tst.w   (Ring_count).w
                bne.s   SKHUD_AddMinuteNineFlashFrameOffset
                addq.w  #2,d4

SKHUD_AddMinuteNineFlashFrameOffset:
                cmpi.b  #9,(Timer_minute).w
                bne.s   SKHUD_AdvanceSignedHudSlideByte
                addq.w  #4,d4

SKHUD_AdvanceSignedHudSlideByte:
                move.b  (Level_started_flag).w,d0
                ext.w   d0
                bpl.s   SKHUD_EmitMappingAtSlideX
                addq.w  #8,d0
                move.b  d0,(Level_started_flag).w

SKHUD_EmitMappingAtSlideX:
                addi.w  #$8F,d0
                move.w  #$108,d1
                move.w  #make_art_tile(ArtTile_Ring+$E,0,1),d5
                lea     Map_HUD(pc),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   SKHUD_ReturnWithoutHudMappingPieces
                jmp     (RenderMappingPieces).l
; ---------------------------------------------------------------------------

SKHUD_ReturnWithoutHudMappingPieces:
                rts
; End of function Render_HUD

; =============== S U B R O U T I N E =======================================

Render_HUD_P2:
                rts
; End of function Render_HUD_P2

; ---------------------------------------------------------------------------
Map_HUD:
                include "src/objects/shared/hud_icon/mappings/hud.s"

; =============== S U B R O U T I N E =======================================

HUD_AddToScore:
                move.b  #1,(Update_HUD_score).w
                lea     (Score).w,a3
                add.l   d0,(a3)                         ; Add to score
                move.l  #999999,d1                      ; 9999990 maximum points
                cmp.l   (a3),d1
                bhi.s   .jump
                move.l  d1,(a3)

                .jump:
                move.l  (a3),d0
                cmp.l   (Next_extra_life_score).w,d0    ; If score is greater than next 50000 point increment
                blo.s   .end
                addi.l  #5000,(Next_extra_life_score).w
                addq.b  #1,(Life_count).w               ; Give an additional extra life
                addq.b  #1,(Update_HUD_life_count).w
                move.w  #mus_ExtraLife,d0               ; Play the 1up song
                jmp     (Play_Music).l

                .end:
                rts
; End of function HUD_AddToScore

; =============== S U B R O U T I N E =======================================

UpdateHUD:
                nop
                lea     (VDP_data_port).l,a6
                tst.w   (Competition_mode).w
                bne.w   SKHUD_TryDrawCompDebugCoords
                tst.w   (Debug_placement_mode).w
                bne.w   SKHUD_UpdateDebugCoordsAndRings
                tst.b   (Update_HUD_score).w
                beq.s   SKHUD_CheckRingDigitUpdateFlag
                clr.b   (Update_HUD_score).w
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$28),VRAM,WRITE),d0
                move.l  (Score).w,d1
                bsr.w   DrawSixDigitNumber

SKHUD_CheckRingDigitUpdateFlag:
                tst.b   (Update_HUD_ring_count).w
                beq.s   SKHUD_SelectForcedOrRunningTimerUpdate
                bpl.s   SKHUD_UploadChangedRingCountDigits
                bsr.w   HUD_DrawZeroRings

SKHUD_UploadChangedRingCountDigits:
                clr.b   (Update_HUD_ring_count).w
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3E),VRAM,WRITE),d0
                moveq   #0,d1
                move.w  (Ring_count).w,d1
                bsr.w   DrawThreeDigitNumber

SKHUD_SelectForcedOrRunningTimerUpdate:
                tst.b   (Update_HUD_timer).w
                bpl.s   SKHUD_AdvanceEnabledUnpausedHudTimer
                move.b  #1,(Update_HUD_timer).w
                bra.s   SKHUD_UploadMinuteAndSecondDigits
; ---------------------------------------------------------------------------

SKHUD_AdvanceEnabledUnpausedHudTimer:
                beq.s   SKHUD_CheckAndUploadChangedLifeCount
                tst.w   (Game_paused).w
                bne.s   SKHUD_CheckAndUploadChangedLifeCount
                lea     (Timer).w,a1
                cmpi.l  #(9<<16)|(59<<8)|59,(a1)+
                beq.w   UpdateHUD_TimeOver
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   SKHUD_CheckAndUploadChangedLifeCount
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   SKHUD_UploadMinuteAndSecondDigits
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #9,(a1)
                blo.s   SKHUD_UploadMinuteAndSecondDigits
                move.b  #9,(a1)

SKHUD_UploadMinuteAndSecondDigits:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$36),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Timer_minute).w,d1
                bsr.w   DrawSingleDigitNumber
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3A),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Timer_second).w,d1
                bsr.w   DrawTwoDigitNumber

SKHUD_CheckAndUploadChangedLifeCount:
                tst.b   (Update_HUD_life_count).w
                beq.s   SKHUD_ReturnAfterNormalHudUpdate
                clr.b   (Update_HUD_life_count).w
                bsr.w   HUD_Lives

SKHUD_ReturnAfterNormalHudUpdate:
                rts
; ---------------------------------------------------------------------------

UpdateHUD_TimeOver:
                clr.b   (Update_HUD_timer).w
                lea     (Player_1).w,a0
                cmpi.b  #6,routine(a0)
                bhs.s   SKHUD_SetTimeOverFlagAndReturn
                cmpi.b  #$15,(Current_zone).w
                beq.s   SKHUD_SetTimeOverFlagAndReturn
                movea.l a0,a2
                bsr.w   Kill_Character

SKHUD_SetTimeOverFlagAndReturn:
                move.b  #1,(Time_over_flag).w
                rts
; ---------------------------------------------------------------------------

SKHUD_UpdateDebugCoordsAndRings:
                bsr.w   HUD_Debug
                tst.b   (Update_HUD_ring_count).w
                beq.s   SKHUD_UploadLagAndSpriteDebugNumbers
                bpl.s   SKHUD_UploadDebugModeChangedRingDigits
                bsr.w   HUD_DrawZeroRings

SKHUD_UploadDebugModeChangedRingDigits:
                clr.b   (Update_HUD_ring_count).w
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3E),VRAM,WRITE),d0
                moveq   #0,d1
                move.w  (Ring_count).w,d1
                bsr.w   DrawThreeDigitNumber

SKHUD_UploadLagAndSpriteDebugNumbers:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$36),VRAM,WRITE),d0
                moveq   #0,d1
                move.w  (Lag_frame_count).w,d1
                bsr.w   DrawSingleDigitNumber
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3A),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Sprites_drawn).w,d1
                bsr.w   DrawTwoDigitNumber
                tst.b   (Update_HUD_life_count).w
                beq.s   SKHUD_AdvanceDebugTimer
                clr.b   (Update_HUD_life_count).w
                bsr.w   HUD_Lives

SKHUD_AdvanceDebugTimer:
                tst.w   (Game_paused).w
                bne.s   SKHUD_ReturnAfterDebugTimerUpdate
                lea     (Timer).w,a1
                cmpi.l  #(9<<16)|(59<<8)|59,(a1)+
                nop
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   SKHUD_ReturnAfterDebugTimerUpdate
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   SKHUD_ReturnAfterDebugTimerUpdate
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #9,(a1)
                blo.s   SKHUD_ReturnAfterDebugTimerUpdate
                move.b  #9,(a1)

SKHUD_ReturnAfterDebugTimerUpdate:
                rts
; ---------------------------------------------------------------------------

SKHUD_TryDrawCompDebugCoords:
                tst.w   (Debug_mode_flag).w
                bne.w   HUD_Debug
                rts
; End of function UpdateHUD

; =============== S U B R O U T I N E =======================================

HUD_DrawZeroRings:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3E),VRAM,WRITE),(VDP_control_port).l
                lea     HUD_Zero_Rings(pc),a2
                move.w  #3-1,d2
                bra.s   SKHUD_BeginInitialOrZeroRingGlyphCopy
; End of function HUD_DrawZeroRings

; =============== S U B R O U T I N E =======================================

HUD_DrawInitial:
                lea     (VDP_data_port).l,a6
                bsr.w   HUD_Lives
                tst.w   (Competition_mode).w
                bne.s   SKHUD_InitHudReturn
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$26),VRAM,WRITE),(VDP_control_port).l
                lea     HUD_Initial_Parts(pc),a2
                move.w  #$F-1,d2

SKHUD_BeginInitialOrZeroRingGlyphCopy:
                lea     ArtUnc_HUDDigits(pc),a1

SKHUD_ReadNextInitialGlyphOrBlankCode:
                move.w  #$10-1,d1
                move.b  (a2)+,d0
                bmi.s   SKHUD_WriteBlankInitialGlyphLongwords
                ext.w   d0
                lsl.w   #5,d0
                lea     (a1,d0.w),a3

SKHUD_CopyInitialGlyphLongwords:
                move.l  (a3)+,(a6)
                dbf     d1,SKHUD_CopyInitialGlyphLongwords

SKHUD_AdvanceInitialGlyphCodeCount:
                dbf     d2,SKHUD_ReadNextInitialGlyphOrBlankCode
                rts
; ---------------------------------------------------------------------------

SKHUD_WriteBlankInitialGlyphLongwords:
                move.l  #0,(a6)
                dbf     d1,SKHUD_WriteBlankInitialGlyphLongwords
                bra.s   SKHUD_AdvanceInitialGlyphCodeCount
; ---------------------------------------------------------------------------

SKHUD_InitHudReturn:
                rts
; End of function HUD_DrawInitial

; ---------------------------------------------------------------------------
                charset ' ',$FF
                charset '0',0
                charset '1',2
                charset '2',4
                charset '3',6
                charset '4',8
                charset '5',$A
                charset '6',$C
                charset '7',$E
                charset '8',$10
                charset '9',$12
                charset ':',$14
                charset 'E',$16

HUD_Initial_Parts:
                dc.b    "E      0"
                dc.b    "0:00"
HUD_Zero_Rings:
                dc.b    "  0"                           ; (zero rings)

                charset
                even

; =============== S U B R O U T I N E =======================================

HUD_Debug:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$26),VRAM,WRITE),(VDP_control_port).l
                move.w  (Camera_X_pos).w,d1
                swap    d1
                move.w  (Player_1+x_pos).w,d1
                bsr.s   HUD_WriteDebugCoordinatePair
                move.w  (Camera_Y_pos).w,d1
                swap    d1
                move.w  (Player_1+y_pos).w,d1
; End of function HUD_Debug

; =============== S U B R O U T I N E =======================================

HUD_WriteDebugCoordinatePair:
                moveq   #8-1,d6
                lea     (ArtUnc_DebugDigits).l,a1

SKHUD_RotateAndDecodeNextDebugWordNibble:
                rol.w   #4,d1
                move.w  d1,d2
                andi.w  #$F,d2
                cmpi.w  #$A,d2
                blo.s   SKHUD_CopyDebugGlyphAndSwapWords
                addi.w  #7,d2

SKHUD_CopyDebugGlyphAndSwapWords:
                lsl.w   #5,d2
                lea     (a1,d2.w),a3
                rept    8
                move.l  (a3)+,(a6)
                endm
                swap    d1
                dbf     d6,SKHUD_RotateAndDecodeNextDebugWordNibble
                rts
; End of function HUD_WriteDebugCoordinatePair

; ---------------------------------------------------------------------------
; unused
                lea     (Level_layout_header).w,a1
                move.w  (Player_1+x_pos).w,d3
                move.w  (Player_1+y_pos).w,d2
                move.w  d2,d0
                lsr.w   #5,d0
                and.w   (Layout_row_index_mask).w,d0
                move.w  8(a1,d0.w),d0
                move.w  d3,d1
                lsr.w   #3,d1
                move.w  d1,d4
                lsr.w   #4,d1
                add.w   d1,d0
                moveq   #-1,d1
                clr.w   d1
                movea.w d0,a1
                move.b  (a1),d1
                rts

; =============== S U B R O U T I N E =======================================

DrawThreeDigitNumber:
                lea     (HUD_DecimalDivisorsFromHundreds).l,a2
                moveq   #3-1,d6
                bra.s   SKHUD_BeginSuppressedDecimalUpload
; End of function DrawThreeDigitNumber

; =============== S U B R O U T I N E =======================================

DrawSixDigitNumber:
                lea     (HUD_DecimalDivisorsFromHundredThousands).l,a2
                moveq   #6-1,d6

SKHUD_BeginSuppressedDecimalUpload:
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

SKHUD_ReadNextDecimalDivisor:
                moveq   #0,d2
                move.l  (a2)+,d3

SKHUD_CountDecimalQuotient:
                sub.l   d3,d1
                bcs.s   SKHUD_RestoreRemainderAndLatch
                addq.w  #1,d2
                bra.s   SKHUD_CountDecimalQuotient
; ---------------------------------------------------------------------------

SKHUD_RestoreRemainderAndLatch:
                add.l   d3,d1
                tst.w   d2
                beq.s   SKHUD_TryUploadDecimalGlyph
                move.w  #1,d4

SKHUD_TryUploadDecimalGlyph:
                tst.w   d4
                beq.s   SKHUD_AdvanceDecimalVramSlot
                lsl.w   #6,d2
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm

; Advance the destination even when the leading glyph is suppressed
SKHUD_AdvanceDecimalVramSlot:
                addi.l  #$40<<16,d0
                dbf     d6,SKHUD_ReadNextDecimalDivisor
                rts
; End of function DrawSixDigitNumber

; ---------------------------------------------------------------------------
; unused leftover from Sonic 2
; ContScrCounter:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$40),VRAM,WRITE),(VDP_control_port).l
                lea     (VDP_data_port).l,a6
                lea     (HUD_DecimalDivisorsFromTens).l,a2
                moveq   #2-1,d6
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

SKHUD_ReadLegacyCounterDecimalDivisor:
                moveq   #0,d2
                move.l  (a2)+,d3

SKHUD_CountLegacyCounterDecimalQuotient:
                sub.l   d3,d1
                bcs.s   SKHUD_CopyLegacyCounterGlyphSequentially
                addq.w  #1,d2
                bra.s   SKHUD_CountLegacyCounterDecimalQuotient
; ---------------------------------------------------------------------------

SKHUD_CopyLegacyCounterGlyphSequentially:
                add.l   d3,d1
                lsl.w   #6,d2
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm
                dbf     d6,SKHUD_ReadLegacyCounterDecimalDivisor
                rts
; ---------------------------------------------------------------------------
HUD_DecimalDivisorsFromHundredThousands:    dc.l    100000
                dc.l    10000
HUD_DecimalDivisorsFromThousands:   dc.l    1000
HUD_DecimalDivisorsFromHundreds:    dc.l    100
HUD_DecimalDivisorsFromTens:        dc.l    10
HUD_DecimalDivisorsFromOnes:        dc.l    1

; =============== S U B R O U T I N E =======================================

DrawSingleDigitNumber:
                lea     (HUD_DecimalDivisorsFromOnes).l,a2
                moveq   #1-1,d6
                bra.s   SKHUD_BeginAlwaysDrawnShortDecimalUpload
; End of function DrawSingleDigitNumber

; =============== S U B R O U T I N E =======================================

DrawTwoDigitNumber:
                lea     (HUD_DecimalDivisorsFromTens).l,a2
                moveq   #2-1,d6

SKHUD_BeginAlwaysDrawnShortDecimalUpload:
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

SKHUD_ReadShortDecimalDivisor:
                moveq   #0,d2
                move.l  (a2)+,d3

SKHUD_CountShortDecimalQuotient:
                sub.l   d3,d1
                bcs.s   SKHUD_RestoreShortRemainderAndLatch
                addq.w  #1,d2
                bra.s   SKHUD_CountShortDecimalQuotient
; ---------------------------------------------------------------------------

SKHUD_RestoreShortRemainderAndLatch:
                add.l   d3,d1
                tst.w   d2
                beq.s   SKHUD_CopyShortDecimalGlyphIncludingZero
                move.w  #1,d4

SKHUD_CopyShortDecimalGlyphIncludingZero:
                lsl.w   #6,d2
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm
                addi.l  #$40<<16,d0
                dbf     d6,SKHUD_ReadShortDecimalDivisor
                rts
; End of function DrawTwoDigitNumber

; ---------------------------------------------------------------------------
; unused leftover from Sonic 2
; Hud_TimeRingBonus:
                lea     (HUD_DecimalDivisorsFromThousands).l,a2
                moveq   #4-1,d6
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

SKHUD_ReadLegacyBonusDecimalDivisor:
                moveq   #0,d2
                move.l  (a2)+,d3

SKHUD_CountLegacyBonusDecimalQuotient:
                sub.l   d3,d1
                bcs.s   SKHUD_RestoreBonusRemainderAndLatch
                addq.w  #1,d2
                bra.s   SKHUD_CountLegacyBonusDecimalQuotient
; ---------------------------------------------------------------------------

SKHUD_RestoreBonusRemainderAndLatch:
                add.l   d3,d1
                tst.w   d2
                beq.s   SKHUD_CopyLegacyBonusGlyphOrChooseBlank
                move.w  #1,d4

SKHUD_CopyLegacyBonusGlyphOrChooseBlank:
                tst.w   d4
                beq.s   SKHUD_BeginBlankLegacyBonusGlyph
                lsl.w   #6,d2
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm

SKHUD_AdvanceLegacyBonusDigitCount:
                dbf     d6,SKHUD_ReadLegacyBonusDecimalDivisor
                rts
; ---------------------------------------------------------------------------

SKHUD_BeginBlankLegacyBonusGlyph:
                moveq   #$10-1,d5

SKHUD_WriteBlankLegacyBonusLongwords:
                move.l  #0,(a6)
                dbf     d5,SKHUD_WriteBlankLegacyBonusLongwords
                bra.s   SKHUD_AdvanceLegacyBonusDigitCount

; =============== S U B R O U T I N E =======================================

HUD_Lives:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_PlayerLifeIcon+9),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Life_count).w,d1
                lea     (HUD_DecimalDivisorsFromTens).l,a2
                moveq   #2-1,d6
                moveq   #0,d4
                lea     ArtUnc_LivesDigits(pc),a1

SKHUD_ProgramLifeDigitVramAndReadDivisor:
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                moveq   #0,d2
                move.l  (a2)+,d3

SKHUD_CountLifeDigitQuotient:
                sub.l   d3,d1
                bcs.s   SKHUD_RestoreLifeRemainderAndLatch
                addq.w  #1,d2
                bra.s   SKHUD_CountLifeDigitQuotient
; ---------------------------------------------------------------------------

SKHUD_RestoreLifeRemainderAndLatch:
                add.l   d3,d1
                tst.w   d2
                beq.s   SKHUD_SelectLifeGlyphOrLeadingBlank
                move.w  #1,d4

SKHUD_SelectLifeGlyphOrLeadingBlank:
                tst.w   d4
                beq.s   SKHUD_ForceZeroLifeUnitsOrBlankTens

SKHUD_CopyOneTileLifeGlyph:
                lsl.w   #5,d2
                lea     (a1,d2.w),a3
                rept    8
                move.l  (a3)+,(a6)
                endm

SKHUD_AdvanceLifeVramSlotAndDigitCount:
                addi.l  #$40<<16,d0
                dbf     d6,SKHUD_ProgramLifeDigitVramAndReadDivisor
                rts
; ---------------------------------------------------------------------------

SKHUD_ForceZeroLifeUnitsOrBlankTens:
                tst.w   d6
                beq.s   SKHUD_CopyOneTileLifeGlyph
                moveq   #8-1,d5

SKHUD_WriteBlankLifeTensLongwords:
                move.l  #0,(a6)
                dbf     d5,SKHUD_WriteBlankLifeTensLongwords
                bra.s   SKHUD_AdvanceLifeVramSlotAndDigitCount
; End of function HUD_Lives

; ---------------------------------------------------------------------------
