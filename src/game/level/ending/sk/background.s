; Owner: game/level/ending/sk
; Responsibility: Ending background event program, scroll deformation and private sky palette
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Ending_BackgroundInit:
                jsr     SKEnding_BuildInitialCloudBands(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                move.w  #$200,d1
                jsr     (Refresh_PlaneFull).l
                lea     Ending_BGDeformArray1(pc),a4
                lea     (HScroll_table+$004).w,a5
                jmp     (ApplyDeformation).l
; ---------------------------------------------------------------------------

Ending_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     Ending_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

Ending_BackgroundEvent_Index:
                bra.w   loc_5AF4E
; ---------------------------------------------------------------------------
                bra.w   loc_5AF84
; ---------------------------------------------------------------------------
                bra.w   loc_5AFC4
; ---------------------------------------------------------------------------
                bra.w   loc_5AFF0
; ---------------------------------------------------------------------------
                bra.w   loc_5B012
; ---------------------------------------------------------------------------
                bra.w   loc_5B03A
; ---------------------------------------------------------------------------
                bra.w   loc_5B072
; ---------------------------------------------------------------------------

loc_5AF4E:
                tst.w   (Events_fg_5).w
                bne.s   loc_5AF5A
                jsr     SKEnding_BuildInitialCloudBands(pc)
                bra.s   loc_5AF88
; ---------------------------------------------------------------------------

loc_5AF5A:
                clr.w   (Events_fg_5).w
                lea     (Pal_Ending1).l,a1
                lea     (Normal_palette_line_2).w,a5
                moveq   #bytesToLcnt($60),d0

loc_5AF6A:
                move.l  (a1)+,(a5)+
                dbf     d0,loc_5AF6A
                jsr     SKEnding_LoadSkyColorsNowAndTarget(pc)
                move.w  #$220,d0
                move.w  d0,(_unkEE9C).w
                move.w  d0,(Camera_Y_pos_BG_rounded).w
                addq.w  #4,(Events_routine_bg).w

loc_5AF84:
                jsr     SKEnding_BuildExpandingBgBands(pc)

loc_5AF88:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                move.w  #$200,d1
                moveq   #$20,d6
                jsr     (Draw_TileRow).l
                lea     Ending_BGDeformArray1(pc),a4
                tst.w   (Events_routine_bg).w
                beq.s   loc_5AFAA
                lea     Ending_BGDeformArray2(pc),a4

loc_5AFAA:
                lea     (HScroll_table+$004).w,a5
                jsr     (ApplyDeformation).l
                lea     CycleSsz2EmeraldEndingAccentPalette(pc),a1
                tst.w   (Events_routine_bg).w
                beq.s   loc_5AFC2
                lea     CycleSsz2EndingWaterPalette(pc),a1

loc_5AFC2:
                jmp     (a1)
; ---------------------------------------------------------------------------

loc_5AFC4:
                jsr     (AIZ1_Deform).l
                jsr     (Reset_TileOffsetPositionEff).l
                clr.l   (HScroll_table).w
                move.w  d2,(HScroll_table+$006).w
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_5AFF6
; ---------------------------------------------------------------------------

loc_5AFF0:
                jsr     (AIZ1_Deform).l

loc_5AFF6:
                lea     (AIZ1_BGDrawArray).l,a4
                lea     (HScroll_table-$04).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d1
                jsr     (Draw_PlaneVertBottomUpComplex).l
                bpl.s   loc_5B020
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_5B020
; ---------------------------------------------------------------------------

loc_5B012:
                jsr     (AIZ1_Deform).l
                move.w  (Events_bg+$0A).w,d0
                sub.w   d0,(Camera_Y_pos_BG_copy).w

loc_5B020:
                lea     (AIZ1_BGDrawArray).l,a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #2,d5
                jsr     (Draw_BG).l
                jmp     (AIZ1_ApplyDeformWater).l
; ---------------------------------------------------------------------------

loc_5B03A:
                movea.w $1C(a3),a1
                addq.w  #4,a1
                move.b  #$1A,(a1)+
                move.b  #$1B,(a1)+
                move.b  #$1A,(a1)+
                move.b  #$1B,(a1)+
                jsr     SKEnding_BuildExpandingBgBands(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_5B076
; ---------------------------------------------------------------------------

loc_5B072:
                jsr     SKEnding_BuildExpandingBgBands(pc)

loc_5B076:
                move.w  #$200,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.w   loc_5AF88
                move.w  #4,(Events_routine_bg).w
                bpl.w   loc_5AF88

; =============== S U B R O U T I N E =======================================

; Clamp background Y to $120 before entering the shared Sky Sanctuary cloud-band builder
SKEnding_BuildInitialCloudBands:
                move.w  (_unkEE9C).w,d0
                cmpi.w  #$120,d0
                bls.s   loc_5B0A0
                move.w  #$120,d0

loc_5B0A0:
                move.w  d0,(Camera_Y_pos_BG_copy).w
                jmp     loc_58D44(pc)
; End of function SKEnding_BuildInitialCloudBands

; =============== S U B R O U T I N E =======================================

; Use scene X and the slow phase to build the fine-scroll ramp and seven derived layer offsets
SKEnding_BuildExpandingBgBands:
                move.w  (_unkEE9C).w,(Camera_Y_pos_BG_copy).w
                move.w  (_unkEE98).w,d0
                swap    d0
                clr.w   d0
                move.l  d0,d1
                asr.l   #4,d1
                lea     (HScroll_table).w,a1
                add.l   (a1),d1
                addi.l  #$800,(a1)+
                lea     $10(a1),a1
                moveq   #$20-1,d2

loc_5B0CC:
                swap    d0
                move.w  d0,(a1)+
                move.w  d0,(a1)+
                move.w  d0,(a1)+
                move.w  d0,(a1)+
                swap    d0
                add.l   d1,d0
                dbf     d2,loc_5B0CC
                lea     (HScroll_table+$014).w,a1
                move.w  (a1),d0
                move.w  d0,-4(a1)
                move.w  d0,-$C(a1)
                move.w  8(a1),d0
                move.w  d0,-8(a1)
                move.w  $10(a1),d0
                move.w  d0,-2(a1)
                move.w  $18(a1),d0
                move.w  d0,-$E(a1)
                move.w  $20(a1),d0
                move.w  d0,-$A(a1)
                move.w  $28(a1),d0
                move.w  d0,-6(a1)
                rts
; End of function SKEnding_BuildExpandingBgBands

; =============== S U B R O U T I N E =======================================

SKEnding_LoadSkyColorsNowAndTarget:
                lea     (Normal_palette_line_2).w,a6
                bra.s   loc_5B120
; End of function SKEnding_LoadSkyColorsNowAndTarget

; =============== S U B R O U T I N E =======================================

SKEnding_LoadSkyColorsToTarget:
                lea     (Target_palette_line_2).w,a6

loc_5B120:
                lea     (Target_palette_line_2).w,a5
                lea     Pal_5B16E(pc),a1
                moveq   #bytesToLcnt($20),d0

loc_5B12A:
                move.l  (a1),(a5)+
                move.l  (a1)+,(a6)+
                dbf     d0,loc_5B12A
                lea     (Pal_SSZ2+$20).l,a1
                moveq   #bytesToLcnt($20),d0

loc_5B13A:
                move.l  (a1),(a5)+
                move.l  (a1)+,(a6)+
                dbf     d0,loc_5B13A
                rts
; End of function SKEnding_LoadSkyColorsToTarget

; ---------------------------------------------------------------------------
Ending_BGDeformArray1:
                dc.w    $A0
                dc.w    8
                dc.w    8
                dc.w    4
                dc.w    4
                dc.w    8
                dc.w    8
                dc.w    $18
                dc.w    $10
                dc.w    $10
                dc.w    $7FFF
Ending_BGDeformArray2:
                dc.w    $300
                dc.w    $24
                dc.w    4
                dc.w    $14
                dc.w    4
                dc.w    $1C
                dc.w    4
                dc.w    $20
                dc.w    $8080
                dc.w    $7FFF
Pal_5B16E:
                binclude "data/General/Ending/Palettes/Sky.bin"
                even
