; Owner: game/competition/s3
; Responsibility: Competition zone screen setup, background events, per-zone deformation and callback catalogs
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Comp_ScreenInit:
                jsr     Update_CameraPositionP2(pc)
                move.w  (Camera_X_pos_copy).w,d0
                move.w  d0,(Events_fg_0).w
                move.w  d0,(Events_fg_1).w
                move.w  (Camera_X_pos_P2_copy).w,d0
                move.w  d0,(Events_fg_2).w
                move.w  d0,(_unkEEBA).w
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                lsl.w   #4,d0
                lea     Comp_ScreenInitArray-$E0(pc),a1
                adda.w  d0,a1
                move.w  (a1)+,(Screen_X_wrap_value).w
                move.w  (a1)+,(Screen_Y_wrap_value).w
                move.w  (a1)+,(Camera_Y_pos_mask).w
                move.w  (a1)+,(Layout_row_index_mask).w
                move.w  (a1)+,(_unkEEB0).w
                move.w  (a1)+,d0
                move.w  (a1)+,d2
                move.w  (a1)+,d6
                moveq   #0,d1
                move.w  #$8000,d7
                jmp     Refresh_PlaneFull_Competition(pc)
; ---------------------------------------------------------------------------

Comp_ScreenEvent:
                jsr     Update_CameraPositionP2(pc)
                move.w  (Screen_X_wrap_value).w,d2
                addq.w  #1,d2
                move.w  d2,d3
                lsr.w   #1,d2
                lea     (Events_fg_0).w,a1
                move.w  (Camera_X_pos_copy).w,d0
                jsr     Adjust_BGDuringLoop(pc)
                move.w  (Camera_X_pos_P2_copy).w,d0
                jmp     Adjust_BGDuringLoop(pc)
; ---------------------------------------------------------------------------

CGZ_ScreenEvent:
                bsr.s   Comp_ScreenEvent
                move.w  (Screen_Y_wrap_value).w,d2
                addq.w  #1,d2
                move.w  d2,d3
                lsr.w   #1,d2
                lea     (Events_bg+$00).w,a1
                move.w  (Camera_Y_pos_copy).w,d0
                jsr     Adjust_BGDuringLoop(pc)
                move.w  (Camera_Y_pos_P2_copy).w,d0
                jmp     Adjust_BGDuringLoop(pc)
; ---------------------------------------------------------------------------

ALZ_BackgroundInit:
                jsr     ALZ_BackgroundEvent(pc)
                bra.s   Comp_BackgroundInit
; ---------------------------------------------------------------------------

BPZ_BackgroundInit:
                jsr     BPZ_BackgroundEvent(pc)
                bra.s   Comp_BackgroundInit
; ---------------------------------------------------------------------------

DPZ_BackgroundInit:
                jsr     DPZ_BackgroundEvent(pc)
                bra.s   Comp_BackgroundInit
; ---------------------------------------------------------------------------

CGZ_BackgroundInit:
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  d0,(Events_bg+$00).w
                move.w  d0,(Events_bg+$02).w
                move.w  (Camera_Y_pos_P2_copy).w,d0
                move.w  d0,(Events_bg+$04).w
                move.w  d0,(Events_bg+$06).w
                moveq   #0,d0
                move.b  (Competition_total_laps).w,d0
                addq.w  #1,d0
                lsl.w   #8,d0
                subi.w  #$70,d0
                move.l  #$900000,d1
                divu.w  d0,d1
                move.w  d1,(Events_bg+$08).w
                jsr     CGZ_BackgroundEvent(pc)
                bra.s   Comp_BackgroundInit
; ---------------------------------------------------------------------------

EMZ_BackgroundInit:
                jsr     EMZ_BackgroundEvent(pc)

Comp_BackgroundInit:
                move.l  (V_scroll_value_P2).w,(V_scroll_value_P2_copy).w
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                lsl.w   #4,d0
                lea     Comp_ScreenInitArray-$D4(pc),a1
                adda.w  d0,a1
                move.w  (a1)+,d2
                move.w  (a1)+,d6
                moveq   #0,d0
                moveq   #0,d1
                move.w  #$A000,d7
                jmp     Refresh_PlaneFull_Competition(pc)
; ---------------------------------------------------------------------------

ALZ_BackgroundEvent:
                jsr     ALZ_Deformation(pc)
                lea     ALZ_BGDeformArray(pc),a4
                bra.s   loc_3A764
; ---------------------------------------------------------------------------

BPZ_BackgroundEvent:
                jsr     BPZ_Deformation(pc)
                lea     BPZ_BGDeformArray(pc),a4
                bra.s   loc_3A764
; ---------------------------------------------------------------------------

CGZ_BackgroundEvent:
                jsr     CGZ_Deformation(pc)
                lea     CGZ_BGDeformArray(pc),a4
                bra.s   loc_3A764
; ---------------------------------------------------------------------------

EMZ_BackgroundEvent:
                jsr     EMZ_Deformation(pc)
                lea     EMZ_BGDeformArray(pc),a4

loc_3A764:
                lea     (H_scroll_buffer).w,a1
                movea.l a4,a6
                lea     (HScroll_table).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d0
                move.w  (Camera_X_pos_copy).w,d3
                moveq   #$6C-1,d1
                jsr     ApplyDeformation2(pc)
                movea.l a6,a4
                lea     (HScroll_table+$100).w,a5
                move.w  (Camera_Y_pos_P2_BG_copy).w,d0
                subq.w  #4,d0
                move.w  (Camera_X_pos_P2_copy).w,d3
                moveq   #$74-1,d1
                jsr     ApplyDeformation2(pc)
                jmp     Update_VScrollValueP2(pc)
; ---------------------------------------------------------------------------

DPZ_BackgroundEvent:
                jsr     DPZ_Deformation(pc)
                lea     (H_scroll_buffer).w,a1
                move.w  (Camera_X_pos_copy).w,d0
                move.w  (Camera_X_pos_BG_copy).w,d1
                moveq   #$1A,d2
                bsr.s   S3CompFillUniformForegroundBackgroundScrollLines
                move.w  (Camera_X_pos_P2_copy).w,d0
                move.w  (Camera_X_pos_P2_BG_copy).w,d1
                moveq   #$1C,d2
                bsr.s   S3CompFillUniformForegroundBackgroundScrollLines
                jmp     Update_VScrollValueP2(pc)

; =============== S U B R O U T I N E =======================================

S3CompFillUniformForegroundBackgroundScrollLines:
                neg.w   d0
                swap    d0
                neg.w   d1
                move.w  d1,d0

loc_3A7C2:
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                dbf     d2,loc_3A7C2
                rts
; End of function S3CompFillUniformForegroundBackgroundScrollLines

; =============== S U B R O U T I N E =======================================

ALZ_Deformation:
                move.w  (Camera_Y_pos_copy).w,d0
                bsr.s   S3ALZMapCameraYToThreeQuarterBackground
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_Y_pos_P2_copy).w,d0
                bsr.s   S3ALZMapCameraYToThreeQuarterBackground
                move.w  d0,(Camera_Y_pos_P2_BG_copy).w
                addq.w  #3,(Events_bg+$00).w
                addi.l  #$1000,(Events_bg+$02).w
                lea     AIZ2_ALZ_BGDeformDelta(pc),a4
                lea     (HScroll_table).w,a1
                move.w  (Events_fg_1).w,d0
                bsr.s   S3ALZBuildBandParallaxAndAnimatedDeltaScrollTable
                lea     (HScroll_table+$100).w,a1
                move.w  (_unkEEBA).w,d0
                bra.s   S3ALZBuildBandParallaxAndAnimatedDeltaScrollTable
; End of function ALZ_Deformation

; =============== S U B R O U T I N E =======================================

S3ALZMapCameraYToThreeQuarterBackground:
                subi.w  #$148,d0
                swap    d0
                clr.w   d0
                move.l  d0,d1
                asr.l   #2,d1
                sub.l   d1,d0
                swap    d0
                addi.w  #$48,d0
                rts
; End of function S3ALZMapCameraYToThreeQuarterBackground

; =============== S U B R O U T I N E =======================================

S3ALZBuildBandParallaxAndAnimatedDeltaScrollTable:
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,$90(a1)
                asr.l   #3,d0
                lea     $C(a1),a5
                move.l  d0,d1
                asr.l   #2,d1
                move.l  d1,d2
                move.l  (Events_bg+$02).w,d3
                moveq   #5,d4

loc_3A83A:
                add.l   d3,d1
                swap    d1
                move.w  d1,-(a5)
                swap    d1
                add.l   d2,d1
                dbf     d4,loc_3A83A
                movem.w (a5),d1-d6
                move.w  d2,(a5)+
                move.w  d6,(a5)+
                move.w  d1,(a5)+
                move.w  d4,(a5)+
                move.w  d3,(a5)+
                move.w  d5,(a5)
                lea     $C(a1),a5
                move.l  d0,d1
                move.l  d1,d2
                asr.l   #1,d2
                moveq   #2,d3

loc_3A864:
                swap    d1
                move.w  d1,(a5)+
                swap    d1
                add.l   d2,d1
                dbf     d3,loc_3A864
                move.w  (Events_bg+$00).w,d1
                lsr.w   #3,d1
                andi.w  #$3E,d1
                lea     (a4,d1.w),a6
                swap    d0
                moveq   #$3E,d1

loc_3A882:
                move.w  (a6)+,d2
                add.w   d0,d2
                move.w  d2,(a5)+
                dbf     d1,loc_3A882
                rts
; End of function S3ALZBuildBandParallaxAndAnimatedDeltaScrollTable

; =============== S U B R O U T I N E =======================================

BPZ_Deformation:
                move.w  (Camera_Y_pos_copy).w,d0
                bsr.s   S3BPZMapCameraYToHalfSpeedBackground
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_Y_pos_P2_copy).w,d0
                bsr.s   S3BPZMapCameraYToHalfSpeedBackground
                move.w  d0,(Camera_Y_pos_P2_BG_copy).w
                lea     (HScroll_table+$00E).w,a1
                move.w  (Events_fg_1).w,d0
                bsr.s   S3BPZBuildSevenReverseWrittenParallaxBands
                lea     (HScroll_table+$10E).w,a1
                move.w  (_unkEEBA).w,d0
                bsr.s   S3BPZBuildSevenReverseWrittenParallaxBands
; End of function BPZ_Deformation

; =============== S U B R O U T I N E =======================================

S3BPZMapCameraYToHalfSpeedBackground:
                subi.w  #$2C8,d0
                asr.w   #1,d0
                addi.w  #$90,d0
                rts
; End of function S3BPZMapCameraYToHalfSpeedBackground

; =============== S U B R O U T I N E =======================================

S3BPZBuildSevenReverseWrittenParallaxBands:
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d1
                asr.l   #3,d1
                moveq   #6,d2

loc_3A8CE:
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                sub.l   d1,d0
                dbf     d2,loc_3A8CE
                rts
; End of function S3BPZBuildSevenReverseWrittenParallaxBands

; =============== S U B R O U T I N E =======================================

DPZ_Deformation:
                move.w  (Camera_Y_pos_copy).w,d0
                bsr.s   S3DPZMapCameraYToSixteenthSpeedBackground
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_Y_pos_P2_copy).w,d0
                bsr.s   S3DPZMapCameraYToSixteenthSpeedBackground
                addi.w  #$80,d0
                move.w  d0,(Camera_Y_pos_P2_BG_copy).w
                move.w  (Events_fg_1).w,d0
                bsr.s   S3DPZDeriveHalfAndEighthForegroundXOffsets
                move.w  d0,(Camera_X_pos_BG_copy).w
                move.w  d1,(Events_bg+$10).w
                move.w  (_unkEEBA).w,d0
                bsr.s   S3DPZDeriveHalfAndEighthForegroundXOffsets
                move.w  d0,(Camera_X_pos_P2_BG_copy).w
                move.w  d1,(Events_bg+$12).w
                rts
; End of function DPZ_Deformation

; =============== S U B R O U T I N E =======================================

S3DPZMapCameraYToSixteenthSpeedBackground:
                subi.w  #$148,d0
                asr.w   #4,d0
                addq.w  #8,d0
                rts
; End of function S3DPZMapCameraYToSixteenthSpeedBackground

; =============== S U B R O U T I N E =======================================

S3DPZDeriveHalfAndEighthForegroundXOffsets:
                asr.w   #1,d0
                move.w  d0,d1
                asr.w   #2,d1
                rts
; End of function S3DPZDeriveHalfAndEighthForegroundXOffsets

; =============== S U B R O U T I N E =======================================

CGZ_Deformation:
                move.w  (Events_bg+$02).w,d0
                bsr.s   S3CGZScaleNonnegativeLapHeightIntoBackgroundY
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Events_bg+$06).w,d0
                bsr.s   S3CGZScaleNonnegativeLapHeightIntoBackgroundY
                move.w  d0,(Camera_Y_pos_P2_BG_copy).w
                lea     (HScroll_table+$00A).w,a1
                move.w  (Events_fg_1).w,d0
                bsr.s   S3CGZBuildFiveHorizontalParallaxBands
                lea     (HScroll_table+$10A).w,a1
                move.w  (_unkEEBA).w,d0
                bsr.s   S3CGZBuildFiveHorizontalParallaxBands
; End of function CGZ_Deformation

; =============== S U B R O U T I N E =======================================

S3CGZScaleNonnegativeLapHeightIntoBackgroundY:
                bmi.s   loc_3A958
                move.w  (Events_bg+$08).w,d1
                mulu.w  d1,d0
                swap    d0
                rts
; ---------------------------------------------------------------------------

loc_3A958:
                moveq   #0,d0
                rts
; End of function S3CGZScaleNonnegativeLapHeightIntoBackgroundY

; =============== S U B R O U T I N E =======================================

S3CGZBuildFiveHorizontalParallaxBands:
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d1
                asr.l   #2,d1
                moveq   #3,d2

loc_3A968:
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                sub.l   d1,d0
                dbf     d2,loc_3A968
                asr.l   #2,d1
                swap    d1
                addi.w  #$100,d1
                move.w  d1,-(a1)
                rts
; End of function S3CGZBuildFiveHorizontalParallaxBands

; =============== S U B R O U T I N E =======================================

EMZ_Deformation:
                move.w  (Camera_Y_pos_copy).w,d0
                bsr.s   S3EMZMapCameraYToThreeQuarterBackground
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_Y_pos_P2_copy).w,d0
                bsr.s   S3EMZMapCameraYToThreeQuarterBackground
                move.w  d0,(Camera_Y_pos_P2_BG_copy).w
                lea     (HScroll_table).w,a1
                move.w  (Events_fg_1).w,d0
                bsr.s   S3EMZBuildTenLayerParallaxOffsets
                lea     (HScroll_table+$100).w,a1
                move.w  (_unkEEBA).w,d0
                bsr.s   S3EMZBuildTenLayerParallaxOffsets
; End of function EMZ_Deformation

; =============== S U B R O U T I N E =======================================

S3EMZMapCameraYToThreeQuarterBackground:
                subi.w  #$148,d0
                swap    d0
                clr.w   d0
                move.l  d0,d1
                asr.l   #2,d1
                sub.l   d1,d0
                swap    d0
                addi.w  #$48,d0
                rts
; End of function S3EMZMapCameraYToThreeQuarterBackground

; =============== S U B R O U T I N E =======================================

S3EMZBuildTenLayerParallaxOffsets:
                swap    d0
                clr.w   d0
                asr.l   #3,d0
                move.l  d0,d1
                swap    d0
                move.w  d0,$E(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,$C(a1)
                move.w  d0,$10(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,6(a1)
                move.w  d0,$A(a1)
                move.w  d0,$12(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,(a1)
                move.w  d0,4(a1)
                move.w  d0,8(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,2(a1)
                rts
; End of function S3EMZBuildTenLayerParallaxOffsets

; ---------------------------------------------------------------------------
Comp_ScreenInitArray:
                dc.w    $3FF,  $1FF,  $1F0,    $C,  $100,  $100,    $F,   $40
                dc.w    $1FF,  $3FF,  $3F0,   $1C,   $80,  $200,   $1F,   $20
                dc.w    $3FF,  $1FF,  $1F0,    $C,  $100,  $100,    $F,   $40
                dc.w    $3FF,   $FF,   $F0,     4,  $100,  $100,    $F,   $40
                dc.w    $3FF,  $1FF,  $1F0,    $C,  $100,  $100,    $F,   $40
ALZ_BGDeformArray:
                dc.w    $18,     8,     8,     8,     8,     8,   $2E,     6,    $D, $803F, $7FFF
BPZ_BGDeformArray:
                dc.w    $88,   $16,    $A,   $28,   $10,     8, $7FFF
CGZ_BGDeformArray:
                dc.w    $50,     8,   $10,   $10, $7FFF
EMZ_BGDeformArray:
                dc.w    $10,   $10,   $10,   $10,     8,    $C,   $24,   $38,   $20, $7FFF
