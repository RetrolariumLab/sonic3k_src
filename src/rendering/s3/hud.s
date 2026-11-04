; Owner: rendering/s3
; Responsibility: One and two player HUD drawing, score, rings, time, lives and numeric glyph output
; Source provenance and ranges: config/reconstruction/source_layout.json
Render_HUD_P1:
                tst.w   (Debug_mode_flag).w
                bne.s   Render_HUD
                rts
; End of function Render_HUD_P1

; =============== S U B R O U T I N E =======================================

Render_HUD:
                cmpi.b  #$13,(Current_zone).w
                blo.s   S3HUD_SelectFullHudFlashFrame
                moveq   #8,d4
                btst    #3,(Level_frame_counter+1).w
                bne.s   S3HUD_AdvanceSignedHudSlideByte
                tst.w   (Ring_count).w
                bne.s   S3HUD_AdvanceSignedHudSlideByte
                addq.w  #2,d4
                bra.s   S3HUD_AdvanceSignedHudSlideByte
; ---------------------------------------------------------------------------

S3HUD_SelectFullHudFlashFrame:
                moveq   #0,d4
                btst    #3,(Level_frame_counter+1).w
                bne.s   S3HUD_AdvanceSignedHudSlideByte
                tst.w   (Ring_count).w
                bne.s   S3HUD_AddMinuteNineFlashFrameOffset
                addq.w  #2,d4

S3HUD_AddMinuteNineFlashFrameOffset:
                cmpi.b  #9,(Timer_minute).w
                bne.s   S3HUD_AdvanceSignedHudSlideByte
                addq.w  #4,d4

S3HUD_AdvanceSignedHudSlideByte:
                move.b  (Level_started_flag).w,d0
                ext.w   d0
                bpl.s   S3HUD_EmitMappingAtSlideX
                addq.w  #8,d0
                move.b  d0,(Level_started_flag).w

S3HUD_EmitMappingAtSlideX:
                addi.w  #$8F,d0
                move.w  #$108,d1
                move.w  #make_art_tile(ArtTile_Ring+$E,0,1),d5
                lea     Map_HUD(pc),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   S3HUD_ReturnWithoutHudMappingPieces
                jmp     (RenderMappingPieces).l
; ---------------------------------------------------------------------------

S3HUD_ReturnWithoutHudMappingPieces:
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
                bne.w   S3HUD_TryDrawCompDebugCoords
                tst.w   (Debug_mode_flag).w
                bne.w   S3HUD_UpdateDebugCoordsAndRings
                tst.b   (Update_HUD_score).w
                beq.s   S3HUD_CheckRingDigitUpdateFlag
                clr.b   (Update_HUD_score).w
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$28),VRAM,WRITE),d0
                move.l  (Score).w,d1
                bsr.w   DrawSixDigitNumber

S3HUD_CheckRingDigitUpdateFlag:
                tst.b   (Update_HUD_ring_count).w
                beq.s   S3HUD_SelectForcedOrRunningTimerUpdate
                bpl.s   S3HUD_UploadChangedRingCountDigits
                bsr.w   HUD_DrawZeroRings

S3HUD_UploadChangedRingCountDigits:
                clr.b   (Update_HUD_ring_count).w
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3E),VRAM,WRITE),d0
                moveq   #0,d1
                move.w  (Ring_count).w,d1
                bsr.w   DrawThreeDigitNumber

S3HUD_SelectForcedOrRunningTimerUpdate:
                tst.b   (Update_HUD_timer).w
                bpl.s   S3HUD_AdvanceEnabledUnpausedHudTimer
                move.b  #1,(Update_HUD_timer).w
                bra.s   S3HUD_UploadMinuteAndSecondDigits
; ---------------------------------------------------------------------------

S3HUD_AdvanceEnabledUnpausedHudTimer:
                beq.s   S3HUD_CheckAndUploadChangedLifeCount
                tst.w   (Game_paused).w
                bne.s   S3HUD_CheckAndUploadChangedLifeCount
                lea     (Timer).w,a1
                cmpi.l  #(9<<16)|(59<<8)|59,(a1)+
                beq.w   UpdateHUD_TimeOver
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   S3HUD_CheckAndUploadChangedLifeCount
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   S3HUD_UploadMinuteAndSecondDigits
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #9,(a1)
                blo.s   S3HUD_UploadMinuteAndSecondDigits
                move.b  #9,(a1)

S3HUD_UploadMinuteAndSecondDigits:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$36),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Timer_minute).w,d1
                bsr.w   DrawSingleDigitNumber
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3A),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Timer_second).w,d1
                bsr.w   DrawTwoDigitNumber

S3HUD_CheckAndUploadChangedLifeCount:
                tst.b   (Update_HUD_life_count).w
                beq.s   S3HUD_ReturnAfterNormalHudUpdate
                clr.b   (Update_HUD_life_count).w
                bsr.w   HUD_Lives

S3HUD_ReturnAfterNormalHudUpdate:
                rts
; ---------------------------------------------------------------------------

UpdateHUD_TimeOver:
                clr.b   (Update_HUD_timer).w
                lea     (Player_1).w,a0
                cmpi.b  #6,routine(a0)
                bhs.s   S3HUD_SetTimeOverFlagAndReturn
                movea.l a0,a2
                bsr.w   Kill_Character

S3HUD_SetTimeOverFlagAndReturn:
                move.b  #1,(Time_over_flag).w
                rts
; ---------------------------------------------------------------------------

S3HUD_UpdateDebugCoordsAndRings:
                bsr.w   HUD_Debug
                tst.b   (Update_HUD_ring_count).w
                beq.s   S3HUD_UploadLagAndSpriteDebugNumbers
                bpl.s   S3HUD_UploadDebugModeChangedRingDigits
                bsr.w   HUD_DrawZeroRings

S3HUD_UploadDebugModeChangedRingDigits:
                clr.b   (Update_HUD_ring_count).w
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3E),VRAM,WRITE),d0
                moveq   #0,d1
                move.w  (Ring_count).w,d1
                bsr.w   DrawThreeDigitNumber

S3HUD_UploadLagAndSpriteDebugNumbers:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$36),VRAM,WRITE),d0
                moveq   #0,d1
                move.w  (Lag_frame_count).w,d1
                bsr.w   DrawSingleDigitNumber
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3A),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Sprites_drawn).w,d1
                bsr.w   DrawTwoDigitNumber
                tst.b   (Update_HUD_life_count).w
                beq.s   S3HUD_AdvanceDebugTimer
                clr.b   (Update_HUD_life_count).w
                bsr.w   HUD_Lives

S3HUD_AdvanceDebugTimer:
                tst.w   (Game_paused).w
                bne.s   S3HUD_ReturnAfterDebugTimerUpdate
                lea     (Timer).w,a1
                cmpi.l  #(9<<16)|(59<<8)|59,(a1)+
                nop
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   S3HUD_ReturnAfterDebugTimerUpdate
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   S3HUD_ReturnAfterDebugTimerUpdate
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #9,(a1)
                blo.s   S3HUD_ReturnAfterDebugTimerUpdate
                move.b  #9,(a1)

S3HUD_ReturnAfterDebugTimerUpdate:
                rts
; ---------------------------------------------------------------------------

S3HUD_TryDrawCompDebugCoords:
                tst.w   (Debug_mode_flag).w
                bne.w   HUD_Debug
                rts
; End of function UpdateHUD

; =============== S U B R O U T I N E =======================================

HUD_DrawZeroRings:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3E),VRAM,WRITE),(VDP_control_port).l
                lea     HUD_Zero_Rings(pc),a2
                move.w  #3-1,d2
                bra.s   S3HUD_BeginInitialOrZeroRingGlyphCopy
; End of function HUD_DrawZeroRings

; =============== S U B R O U T I N E =======================================

HUD_DrawInitial:
                lea     (VDP_data_port).l,a6
                bsr.w   HUD_Lives
                tst.w   (Competition_mode).w
                bne.s   S3HUD_InitHudReturn
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$26),VRAM,WRITE),(VDP_control_port).l
                lea     HUD_Initial_Parts(pc),a2
                move.w  #$F-1,d2

S3HUD_BeginInitialOrZeroRingGlyphCopy:
                lea     ArtUnc_HUDDigits(pc),a1

S3HUD_ReadNextInitialGlyphOrBlankCode:
                move.w  #$10-1,d1
                move.b  (a2)+,d0
                bmi.s   S3HUD_WriteBlankInitialGlyphLongwords
                ext.w   d0
                lsl.w   #5,d0
                lea     (a1,d0.w),a3

S3HUD_CopyInitialGlyphLongwords:
                move.l  (a3)+,(a6)
                dbf     d1,S3HUD_CopyInitialGlyphLongwords

S3HUD_AdvanceInitialGlyphCodeCount:
                dbf     d2,S3HUD_ReadNextInitialGlyphOrBlankCode
                rts
; ---------------------------------------------------------------------------

S3HUD_WriteBlankInitialGlyphLongwords:
                move.l  #0,(a6)
                dbf     d1,S3HUD_WriteBlankInitialGlyphLongwords
                bra.s   S3HUD_AdvanceInitialGlyphCodeCount
; ---------------------------------------------------------------------------

S3HUD_InitHudReturn:
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

S3HUD_RotateAndDecodeNextDebugWordNibble:
                rol.w   #4,d1
                move.w  d1,d2
                andi.w  #$F,d2
                cmpi.w  #$A,d2
                blo.s   S3HUD_CopyDebugGlyphAndSwapWords
                addi.w  #7,d2

S3HUD_CopyDebugGlyphAndSwapWords:
                lsl.w   #5,d2
                lea     (a1,d2.w),a3
                rept    8
                move.l  (a3)+,(a6)
                endm
                swap    d1
                dbf     d6,S3HUD_RotateAndDecodeNextDebugWordNibble
                rts
; End of function HUD_WriteDebugCoordinatePair

; =============== S U B R O U T I N E =======================================

DrawThreeDigitNumber:
                lea     (HUD_DecimalDivisorsFromHundreds).l,a2
                moveq   #3-1,d6
                bra.s   S3HUD_BeginSuppressedDecimalUpload
; End of function DrawThreeDigitNumber

; =============== S U B R O U T I N E =======================================

DrawSixDigitNumber:
                lea     (HUD_DecimalDivisorsFromHundredThousands).l,a2
                moveq   #6-1,d6

S3HUD_BeginSuppressedDecimalUpload:
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

S3HUD_ReadNextDecimalDivisor:
                moveq   #0,d2
                move.l  (a2)+,d3

S3HUD_CountDecimalQuotient:
                sub.l   d3,d1
                bcs.s   S3HUD_RestoreRemainderAndLatch
                addq.w  #1,d2
                bra.s   S3HUD_CountDecimalQuotient
; ---------------------------------------------------------------------------

S3HUD_RestoreRemainderAndLatch:
                add.l   d3,d1
                tst.w   d2
                beq.s   S3HUD_TryUploadDecimalGlyph
                move.w  #1,d4

S3HUD_TryUploadDecimalGlyph:
                tst.w   d4
                beq.s   S3HUD_AdvanceDecimalVramSlot
                lsl.w   #6,d2
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm

; Advance the destination even when the leading glyph is suppressed
S3HUD_AdvanceDecimalVramSlot:
                addi.l  #$40<<16,d0
                dbf     d6,S3HUD_ReadNextDecimalDivisor
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

S3HUD_ReadLegacyCounterDecimalDivisor:
                moveq   #0,d2
                move.l  (a2)+,d3

S3HUD_CountLegacyCounterDecimalQuotient:
                sub.l   d3,d1
                bcs.s   S3HUD_CopyLegacyCounterGlyphSequentially
                addq.w  #1,d2
                bra.s   S3HUD_CountLegacyCounterDecimalQuotient
; ---------------------------------------------------------------------------

S3HUD_CopyLegacyCounterGlyphSequentially:
                add.l   d3,d1
                lsl.w   #6,d2
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm
                dbf     d6,S3HUD_ReadLegacyCounterDecimalDivisor
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
                bra.s   S3HUD_BeginAlwaysDrawnShortDecimalUpload
; End of function DrawSingleDigitNumber

; =============== S U B R O U T I N E =======================================

DrawTwoDigitNumber:
                lea     (HUD_DecimalDivisorsFromTens).l,a2
                moveq   #2-1,d6

S3HUD_BeginAlwaysDrawnShortDecimalUpload:
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

S3HUD_ReadShortDecimalDivisor:
                moveq   #0,d2
                move.l  (a2)+,d3

S3HUD_CountShortDecimalQuotient:
                sub.l   d3,d1
                bcs.s   S3HUD_RestoreShortRemainderAndLatch
                addq.w  #1,d2
                bra.s   S3HUD_CountShortDecimalQuotient
; ---------------------------------------------------------------------------

S3HUD_RestoreShortRemainderAndLatch:
                add.l   d3,d1
                tst.w   d2
                beq.s   S3HUD_CopyShortDecimalGlyphIncludingZero
                move.w  #1,d4

S3HUD_CopyShortDecimalGlyphIncludingZero:
                lsl.w   #6,d2
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm
                addi.l  #$40<<16,d0
                dbf     d6,S3HUD_ReadShortDecimalDivisor
                rts
; End of function DrawTwoDigitNumber

; ---------------------------------------------------------------------------
; unused leftover from Sonic 2
; Hud_TimeRingBonus:
                lea     (HUD_DecimalDivisorsFromThousands).l,a2
                moveq   #4-1,d6
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

S3HUD_ReadLegacyBonusDecimalDivisor:
                moveq   #0,d2
                move.l  (a2)+,d3

S3HUD_CountLegacyBonusDecimalQuotient:
                sub.l   d3,d1
                bcs.s   S3HUD_RestoreBonusRemainderAndLatch
                addq.w  #1,d2
                bra.s   S3HUD_CountLegacyBonusDecimalQuotient
; ---------------------------------------------------------------------------

S3HUD_RestoreBonusRemainderAndLatch:
                add.l   d3,d1
                tst.w   d2
                beq.s   S3HUD_CopyLegacyBonusGlyphOrChooseBlank
                move.w  #1,d4

S3HUD_CopyLegacyBonusGlyphOrChooseBlank:
                tst.w   d4
                beq.s   S3HUD_BeginBlankLegacyBonusGlyph
                lsl.w   #6,d2
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm

S3HUD_AdvanceLegacyBonusDigitCount:
                dbf     d6,S3HUD_ReadLegacyBonusDecimalDivisor
                rts
; ---------------------------------------------------------------------------

S3HUD_BeginBlankLegacyBonusGlyph:
                moveq   #$10-1,d5

S3HUD_WriteBlankLegacyBonusLongwords:
                move.l  #0,(a6)
                dbf     d5,S3HUD_WriteBlankLegacyBonusLongwords
                bra.s   S3HUD_AdvanceLegacyBonusDigitCount

; =============== S U B R O U T I N E =======================================

HUD_Lives:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_PlayerLifeIcon+9),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Life_count).w,d1
                lea     (HUD_DecimalDivisorsFromTens).l,a2
                moveq   #2-1,d6
                moveq   #0,d4
                lea     ArtUnc_LivesDigits(pc),a1

S3HUD_ProgramLifeDigitVramAndReadDivisor:
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                moveq   #0,d2
                move.l  (a2)+,d3

S3HUD_CountLifeDigitQuotient:
                sub.l   d3,d1
                bcs.s   S3HUD_RestoreLifeRemainderAndLatch
                addq.w  #1,d2
                bra.s   S3HUD_CountLifeDigitQuotient
; ---------------------------------------------------------------------------

S3HUD_RestoreLifeRemainderAndLatch:
                add.l   d3,d1
                tst.w   d2
                beq.s   S3HUD_SelectLifeGlyphOrLeadingBlank
                move.w  #1,d4

S3HUD_SelectLifeGlyphOrLeadingBlank:
                tst.w   d4
                beq.s   S3HUD_ForceZeroLifeUnitsOrBlankTens

S3HUD_CopyOneTileLifeGlyph:
                lsl.w   #5,d2
                lea     (a1,d2.w),a3
                rept    8
                move.l  (a3)+,(a6)
                endm

S3HUD_AdvanceLifeVramSlotAndDigitCount:
                addi.l  #$40<<16,d0
                dbf     d6,S3HUD_ProgramLifeDigitVramAndReadDivisor
                rts
; ---------------------------------------------------------------------------

S3HUD_ForceZeroLifeUnitsOrBlankTens:
                tst.w   d6
                beq.s   S3HUD_CopyOneTileLifeGlyph
                moveq   #8-1,d5

S3HUD_WriteBlankLifeTensLongwords:
                move.l  #0,(a6)
                dbf     d5,S3HUD_WriteBlankLifeTensLongwords
                bra.s   S3HUD_AdvanceLifeVramSlotAndDigitCount
; End of function HUD_Lives

; ---------------------------------------------------------------------------
