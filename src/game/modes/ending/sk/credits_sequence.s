; Owner: game/modes/ending/sk
; Responsibility: Ending credit progression, character-specific pose graphics and scrolling tile transfer helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SKEndingDispatchCreditsInitDelayScrollAndFinish:
                move.w  (_unkFA86).w,d0
                move.w  off_5B19A(pc,d0.w),d0
                jmp     off_5B19A(pc,d0.w)
; End of function SKEndingDispatchCreditsInitDelayScrollAndFinish

; ---------------------------------------------------------------------------
off_5B19A:
                dc.w    loc_5B1A2-off_5B19A
                dc.w    loc_5B1F4-off_5B19A
                dc.w    loc_5B204-off_5B19A
                dc.w    locret_5B2D4-off_5B19A
; ---------------------------------------------------------------------------

loc_5B1A2:
                addq.w  #2,(_unkFA86).w
                clr.b   (_unkFACC).w
                clr.l   (Camera_Y_pos).w
                clr.l   (V_scroll_value).w
                clr.w   (_unkFAAE).w
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_5B1D2
                jsr     (AllocateObject).l
                bne.s   loc_5B1D2
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_CreditsK,subtype(a1)

loc_5B1D2:
                bsr.w   SKCreditsSelectProductRegionCharacterCompletionScrollSpeedDelay
                move.w  #$EEE,(Normal_palette+$2).w
                move.w  #$EE,(Normal_palette_line_2+$2).w
                lea     PLC_SKCredits(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------
PLC_SKCredits:  plrlistheader
                plreq   ArtTile_Ending_CreditsText, ArtNem_CreditsText
PLC_SKCredits_End:
; ---------------------------------------------------------------------------

loc_5B1F4:
                subq.w  #1,(_unkF660).w
                bpl.s   locret_5B202
                addq.w  #2,(_unkFA86).w
                bsr.w   SKCreditsQueueProductCharacterCompletionPoseGraphics

locret_5B202:
                rts
; ---------------------------------------------------------------------------

loc_5B204:
                move.l  (Camera_Y_pos).w,d0
                move.l  d0,d1
                add.l   (_unkFAC8).w,d0
                move.l  d0,(Camera_Y_pos).w
                swap    d0
                swap    d1
                eor.w   d0,d1
                btst    #4,d1
                beq.s   locret_5B282
                lsl.w   #4,d0
                addi.w  #$E00,d0
                move.w  d0,d1
                andi.w  #$F00,d1
                bsr.w   SKCreditsClearFortyColumnsAcrossTwoPlaneRows
                moveq   #0,d2
                tst.w   (SK_alone_flag).w
                beq.s   loc_5B238
                moveq   #8,d2

loc_5B238:
                add.w   (_unkFAAE).w,d2
                movea.l off_5B284(pc,d2.w),a1
                move.w  (_unkFA84).w,d2
                move.w  (a1,d2.w),d2
                lea     (a1,d2.w),a1
                move.w  (a1)+,d2
                cmpi.w  #-8,d2
                beq.s   loc_5B294
                cmpi.w  #-$C,d2
                beq.s   loc_5B29E
                move.w  d2,d3
                andi.w  #$FF00,d0
                andi.w  #$FF00,d3
                cmp.w   d0,d3
                bne.s   locret_5B282
                move.w  #make_art_tile(ArtTile_Ending_CreditsText,0,1),d6
                bclr    #0,d2
                beq.s   loc_5B276
                move.w  #make_art_tile(ArtTile_Ending_CreditsText,1,1),d6

loc_5B276:
                andi.w  #$FFE,d2
                bsr.w   SKCreditsBuildAndUploadVariableWidthTwoRowText
                addq.w  #2,(_unkFA84).w

locret_5B282:
                rts
; ---------------------------------------------------------------------------
off_5B284:
                dc.l    CreditsText_Part1
                dc.l    CreditsText_Part2
                dc.l    CreditsText_Part1_SK
                dc.l    CreditsText_Part2_SK
; ---------------------------------------------------------------------------

loc_5B294:
                addq.w  #4,(_unkFAAE).w
                clr.w   (_unkFA84).w
                rts
; ---------------------------------------------------------------------------

loc_5B29E:
                addq.w  #2,(_unkFA86).w
                clr.l   (Timer).w
                st      (Events_fg_4).w
                st      (_unkFACC).w
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_5B2B8
                rts
; ---------------------------------------------------------------------------

loc_5B2B8:
                tst.b   (_unkFA88).w
                bmi.s   loc_5B2CE
                jsr     (AllocateObject).l
                bne.s   locret_5B2CC
                move.l  #Obj_5EF68,(a1)

locret_5B2CC:
                rts
; ---------------------------------------------------------------------------

loc_5B2CE:
                clr.b   (_unkFAB9).w
                rts
; ---------------------------------------------------------------------------

locret_5B2D4:
                rts

; =============== S U B R O U T I N E =======================================

SKCreditsClearFortyColumnsAcrossTwoPlaneRows:
                move    #$2700,sr
                lea     (VDP_data_port).l,a6
                move.w  d1,d2
                addi.w  #VRAM_Plane_A_Name_Table,d2
                swap    d2
                clr.w   d2
                swap    d2
                lsl.l   #2,d2
                lsr.w   #2,d2
                ori.w   #$4000,d2
                swap    d2
                move.l  #$80<<16,d3
                moveq   #0,d4
                moveq   #2-1,d5

loc_5B300:
                move.l  d2,VDP_control_port-VDP_data_port(a6)
                moveq   #$28-1,d6

loc_5B306:
                move.w  d4,(a6)
                dbf     d6,loc_5B306
                add.l   d3,d2
                dbf     d5,loc_5B300
                move    #$2300,sr

locret_5B316:
                rts
; End of function SKCreditsClearFortyColumnsAcrossTwoPlaneRows

; =============== S U B R O U T I N E =======================================

SKCreditsBuildAndUploadVariableWidthTwoRowText:
                bsr.w   SKCreditsBuildAsciiGlyphLineIntoTwoScratchRows
                move    #$2700,sr
                lea     (VDP_data_port).l,a6
                addi.w  #VRAM_Plane_A_Name_Table,d2
                swap    d2
                clr.w   d2
                swap    d2
                lsl.l   #2,d2
                lsr.w   #2,d2
                ori.w   #$4000,d2
                swap    d2
                move.l  d2,d3
                addi.l  #$80<<16,d3
                lea     (Chunk_table+$7000).l,a1
                move.l  d2,VDP_control_port-VDP_data_port(a6)
                subq.w  #1,d0
                move.w  d0,d1

loc_5B350:
                move.w  (a1)+,(a6)
                dbf     d0,loc_5B350
                lea     (Chunk_table+$7080).l,a1
                move.l  d3,VDP_control_port-VDP_data_port(a6)

loc_5B360:
                move.w  (a1)+,(a6)
                dbf     d1,loc_5B360
                move    #$2300,sr
                rts
; End of function SKCreditsBuildAndUploadVariableWidthTwoRowText

; =============== S U B R O U T I N E =======================================

SKCreditsBuildAsciiGlyphLineIntoTwoScratchRows:
                lea     (Chunk_table+$7000).l,a2
                lea     (Chunk_table+$7080).l,a3
                moveq   #0,d0

loc_5B37A:
                moveq   #0,d1
                move.b  (a1)+,d1
                beq.s   locret_5B316
                cmpi.b  #" ",d1
                beq.w   loc_5B420
                cmpi.b  #"?",d1
                beq.w   loc_5B418
                cmpi.b  #"!",d1
                beq.s   loc_5B410
                cmpi.b  #"&",d1
                beq.s   loc_5B408
                cmpi.b  #")",d1
                beq.s   loc_5B400
                cmpi.b  #"(",d1
                beq.s   loc_5B3F8
                cmpi.b  #".",d1
                beq.s   loc_5B3F0
                cmpi.b  #"I",d1
                beq.s   loc_5B3DC
                addq.w  #2,d0
                subi.b  #"A",d1
                lsl.w   #3,d1
                lea     CreditsText_PlaneMap(pc),a4
                adda.w  d1,a4

loc_5B3C2:
                move.w  (a4)+,d5
                add.w   d6,d5
                move.w  d5,(a2)+
                move.w  (a4)+,d5
                add.w   d6,d5
                move.w  d5,(a2)+
                move.w  (a4)+,d5
                add.w   d6,d5
                move.w  d5,(a3)+
                move.w  (a4)+,d5
                add.w   d6,d5
                move.w  d5,(a3)+
                bra.s   loc_5B37A
; ---------------------------------------------------------------------------

loc_5B3DC:
                addq.w  #1,d0
                lea     CreditsText_PlaneMap.LetterI(pc),a4

loc_5B3E2:
                move.w  (a4)+,d5
                add.w   d6,d5
                move.w  d5,(a2)+
                move.w  (a4)+,d5
                add.w   d6,d5
                move.w  d5,(a3)+
                bra.s   loc_5B37A
; ---------------------------------------------------------------------------

loc_5B3F0:
                addq.w  #1,d0
                lea     CreditsText_PlaneMap.Period(pc),a4
                bra.s   loc_5B3E2
; ---------------------------------------------------------------------------

loc_5B3F8:
                addq.w  #1,d0
                lea     CreditsText_PlaneMap.LeftBracket(pc),a4
                bra.s   loc_5B3E2
; ---------------------------------------------------------------------------

loc_5B400:
                addq.w  #1,d0
                lea     CreditsText_PlaneMap.RightBracket(pc),a4
                bra.s   loc_5B3E2
; ---------------------------------------------------------------------------

loc_5B408:
                addq.w  #2,d0
                lea     CreditsText_PlaneMap.Ampersand(pc),a4
                bra.s   loc_5B3C2
; ---------------------------------------------------------------------------

loc_5B410:
                addq.w  #1,d0
                lea     CreditsText_PlaneMap.Exclamation(pc),a4
                bra.s   loc_5B3E2
; ---------------------------------------------------------------------------

loc_5B418:
                addq.w  #2,d0
                lea     CreditsText_PlaneMap.QuestionMark(pc),a4
                bra.s   loc_5B3C2
; ---------------------------------------------------------------------------

loc_5B420:
                addq.w  #1,d0
                clr.w   (a2)+
                clr.w   (a3)+
                bra.w   loc_5B37A
; End of function SKCreditsBuildAsciiGlyphLineIntoTwoScratchRows

; =============== S U B R O U T I N E =======================================

SKCreditsQueueProductCharacterCompletionPoseGraphics:
                lea     (ArtKosM_ANDKnuckles).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_ANDKnuckles),d2
                jsr     (Queue_Kos_Module).l
                move.w  (Player_mode).w,d0
                moveq   #0,d1
                andi.w  #3,d0
                subq.w  #2,d0
                bmi.s   loc_5B452
                beq.s   loc_5B44E
                addi.w  #$18,d1

loc_5B44E:
                addi.w  #$18,d1

loc_5B452:
                tst.w   (SK_alone_flag).w
                bne.s   loc_5B45C
                addi.w  #$C,d1

loc_5B45C:
                tst.b   (_unkFA88).w
                bmi.s   loc_5B46C
                beq.s   loc_5B468
                addi.w  #4,d1

loc_5B468:
                addi.w  #4,d1

loc_5B46C:
                movea.l off_5B472(pc,d1.w),a2
                jmp     (a2)
; End of function SKCreditsQueueProductCharacterCompletionPoseGraphics

; ---------------------------------------------------------------------------
off_5B472:
                dc.l    loc_5B4C4
                dc.l    loc_5B4C4
                dc.l    loc_5B4C4
                dc.l    SKCreditsQueueSonicThreePoseBannerArt
                dc.l    SKCreditsQueueSonicThreePoseBannerArt
                dc.l    loc_5B4F8
                dc.l    SKCreditsQueueSonicThreePoseBannerArt
                dc.l    SKCreditsQueueSonicThreePoseBannerArt
                dc.l    loc_5B4F8
                dc.l    SKCreditsQueueSonicThreePoseBannerArt
                dc.l    SKCreditsQueueSonicThreePoseBannerArt
                dc.l    loc_5B4F8
                dc.l    loc_5B4C4
                dc.l    loc_5B4BA
                dc.l    loc_5B4BA
                dc.l    SKCreditsQueueSonicThreePoseBannerArt
                dc.l    loc_5B4DE
                dc.l    loc_5B4D4
; ---------------------------------------------------------------------------

loc_5B4BA:
                lea     PLC_CreditsKnuxPose(pc),a1
                jsr     (Load_PLC_Raw).l

loc_5B4C4:
                lea     (ArtKosM_SKPoseBanner).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Logo),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_5B4D4:
                lea     PLC_S3EndingGraphics(pc),a1
                jsr     (Load_PLC_Raw).l

loc_5B4DE:
                lea     PLC_CreditsKnuxPose(pc),a1
                jsr     (Load_PLC_Raw).l

; =============== S U B R O U T I N E =======================================

SKCreditsQueueSonicThreePoseBannerArt:
                lea     (ArtKosM_S3PoseBanner).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Logo),d2
                jmp     (Queue_Kos_Module).l
; End of function SKCreditsQueueSonicThreePoseBannerArt

; ---------------------------------------------------------------------------

loc_5B4F8:
                bsr.s   SKCreditsQueueSonicThreePoseBannerArt
                lea     PLC_S3EndingGraphics(pc),a1
                jmp     (Load_PLC_Raw).l
