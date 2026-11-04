; Owner: game/level/zones/ssz/sk
; Responsibility: Sky Sanctuary spiral-ramp debris state, rumble effects and cloud or ramp sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SSZRampDebris_WaitForEscape:
                tst.w   (SceneAuxiliaryXOrCompetitionTime).w
                bne.s   SSZRampDebris_InitializeRowProgression
                rts
; ---------------------------------------------------------------------------

SSZRampDebris_InitializeRowProgression:
                move.l  #SSZRampDebris_PlayPeriodicRumble,(a0)
                move.w  #$870,$2E(a0)

SSZRampDebris_PlayPeriodicRumble:
                move.w  (Level_frame_counter).w,d0
                andi.w  #$F,d0
                bne.s   SSZRampDebris_WaitBetweenRows
                moveq   #signextendB(sfx_BigRumble),d0
                jsr     (Play_SFX).l

SSZRampDebris_WaitBetweenRows:
                tst.w   $30(a0)
                beq.s   SSZRampDebris_SelectRowGateY
                subq.w  #1,$30(a0)
                bra.w   SSZRampDebris_ReturnFromRowSpawner
; ---------------------------------------------------------------------------

SSZRampDebris_SelectRowGateY:
                move.w  (Player_1+y_pos).w,d0
                cmpi.w  #$4000,d0
                blo.s   SSZRampDebris_CheckRowBounds
                move.w  #$5C0,d0

SSZRampDebris_CheckRowBounds:
                addi.w  #$198,d0
                move.w  $2E(a0),d1
                cmp.w   d1,d0
                bhi.w   SSZRampDebris_ReturnFromRowSpawner
                move.w  d1,d0
                cmpi.w  #$300,d0
                bhs.s   SSZRampDebris_SelectArtAndClearRow
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SSZRampDebris_SelectArtAndClearRow:
                lsl.w   #4,d1
                andi.w  #$F00,d1
                addi.w  #-$2000,d1
                move.w  d1,(SszDebrisClearRowVramRequest).w
                lea     SSZRampDebris_RowTileAndShapeWords(pc),a2
                cmpi.w  #$380,d0
                blo.s   SSZRampDebris_PrepareEightColumnRow
                lea     $80(a2),a2
                cmpi.w  #$800,d0
                blo.s   SSZRampDebris_PrepareEightColumnRow
                lea     $80(a2),a2

SSZRampDebris_PrepareEightColumnRow:
                lea     SSZRampDebris_ColumnStartDelayPattern(pc),a3
                move.w  $32(a0),d4
                addq.w  #3,$32(a0)
                move.w  d0,d1
                andi.w  #$70,d0
                adda.w  d0,a2
                subi.w  #$178,d1
                move.w  #$1A08,d2
                moveq   #8-1,d3
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SSZRampDebris_AdvanceRowAndWait

SSZRampDebris_InitializeNextColumnPiece:
                move.l  #SSZRampPiece_DecodeTileOrMarker,(a1)
                move.w  (a2)+,art_tile(a1)
                move.w  d2,x_pos(a1)
                move.w  d1,y_pos(a1)
                andi.w  #7,d4
                move.b  (a3,d4.w),$2E(a1)
                addq.w  #1,d4
                addi.w  #$10,d2
                jsr     (CreateNewSprite4).l
                dbne    d3,SSZRampDebris_InitializeNextColumnPiece

SSZRampDebris_AdvanceRowAndWait:
                subi.w  #$10,$2E(a0)
                move.w  #7,$30(a0)

SSZRampDebris_ReturnFromRowSpawner:
                rts
; ---------------------------------------------------------------------------

SSZRampPiece_DecodeTileOrMarker:
                move.w  art_tile(a0),d0
                bpl.s   SSZRampPiece_InitializeAttributes
                clr.w   art_tile(a0)
                addq.w  #1,d0
                beq.s   SSZRampPiece_Delete
                move.b  #1,mapping_frame(a0)
                addq.w  #1,d0
                beq.s   SSZRampPiece_InitializeAttributes
                addq.b  #1,mapping_frame(a0)

SSZRampPiece_InitializeAttributes:
                move.l  #SSZRampPiece_DeleteIfNotRendered,(a0)
                move.b  #$84,render_flags(a0)
                move.b  #8,height_pixels(a0)
                move.w  #$180,priority(a0)
                move.l  #Map_SSZSpiralRampPieces,mappings(a0)

SSZRampPiece_DeleteIfNotRendered:
                tst.b   render_flags(a0)
                bmi.s   SSZRampPiece_CountDownBeforeFalling

SSZRampPiece_Delete:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SSZRampPiece_CountDownBeforeFalling:
                tst.b   $2E(a0)
                beq.s   SSZRampPiece_MoveWithGravity
                subq.b  #1,$2E(a0)
                bra.s   SSZRampPiece_Draw
; ---------------------------------------------------------------------------

SSZRampPiece_MoveWithGravity:
                jsr     (MoveSprite).l

SSZRampPiece_Draw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
SSZ1_BGDeformArray:
                dc.w    $1D0
                dc.w    $10
                dc.w    8
                dc.w    $18
                dc.w    $10
                dc.w    $10
                dc.w    8
                dc.w    $28
                dc.w    $10
                dc.w    8
                dc.w    8
                dc.w    $28
                dc.w    8
                dc.w    $20
                dc.w    8
                dc.w    8
                dc.w    8
                dc.w    $10
                dc.w    $18
                dc.w    $20
                dc.w    $40
                dc.w    $20
                dc.w    $18
                dc.w    $10
                dc.w    8
                dc.w    8
                dc.w    8
                dc.w    $20
                dc.w    8
                dc.w    $7FFF
SKSSZ1Geometry_SlopeSolidSpawnRecords:
                dc.w    $A-1
                dc.w    0,  $C38,   $C0,   $A0
                dc.l    SKSSZ1Geometry_SlopeHeights
                dc.w    0,  $E58,  $180,  $180
                dc.l    SKSSZ1Geometry_SlopeHeights
                dc.w    0, $13D8,  $200,  $140
                dc.l    SKSSZ1Geometry_SlopeHeightsAt60
                dc.w    0,  $D78,  $2C0,   $E0
                dc.l    SKSSZ1Geometry_SlopeHeightsAt60
                dc.w    1,  $F18,  $2C0,   $C0
                dc.l    SKSSZ1Geometry_SlopeHeightsAt80
                dc.w    1,  $9D8,  $580,  $140
                dc.l    SKSSZ1Geometry_SlopeHeightsAt60
                dc.w    0,  $E18,  $5C0,  $100
                dc.l    SKSSZ1Geometry_SlopeHeightsAtA0
                dc.w    0,  $F78,  $6C0,  $120
                dc.l    SKSSZ1Geometry_SlopeHeightsAt80
                dc.w    0,  $498,  $540,   $40
                dc.l    SKSSZ1Geometry_SlopeHeights
                dc.w    0,  $618,  $500,   $40
                dc.l    SKSSZ1Geometry_SlopeHeights
; Several solids share this pool, entering at different offsets in the flat lead-in
SKSSZ1Geometry_SlopeHeights:
                dc.b    $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
                dc.b    $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
                dc.b    $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
                dc.b    $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
                dc.b    $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
SKSSZ1Geometry_SlopeHeightsAt60:
                dc.b    $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
                dc.b    $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
SKSSZ1Geometry_SlopeHeightsAt80:
                dc.b    $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
                dc.b    $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
SKSSZ1Geometry_SlopeHeightsAtA0:
                dc.b    $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
                dc.b    $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $22, $22, $22, $22, $22, $22, $22, $22
                dc.b    $23, $23, $23, $23, $23, $23, $24, $24, $24, $24, $24, $25, $25, $25, $26, $26, $26, $27, $27, $27
                dc.b    $28, $28, $29, $29, $2A, $2A, $2B, $2B, $2C, $2C, $2D, $2D, $2E, $2F, $2F, $30, $31, $31, $32, $33
                dc.b    $33, $34, $35, $36, $37, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $40, $41, $42, $43, $44, $45
                dc.b    $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4E, $4F, $50, $51, $52, $53, $53, $53, $54, $55, $55
                dc.b    $56, $56, $57, $58, $58, $59, $59, $5A, $5A, $5A, $5B, $5B, $5C, $5C, $5C, $5D, $5D, $5E, $5E, $5E
                dc.b    $5E, $5F, $5F, $5F, $5F, $60, $60, $60, $60, $60, $60, $61, $61, $61, $61, $61, $61, $61, $61, $61
                dc.b    $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61
                dc.b    $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61
                dc.b    $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61
                dc.b    $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61
                dc.b    $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61, $61
                even
SKSSZ1Geometry_CloudMotionSeeds:
                dc.w    $10,   $30, $FE00,     1
                dc.w    $44,  $100, $9E00,     2
                dc.w    $78,   $B0, $E600,     1
                dc.w    $AC,  $1C0, $B600,     2
                dc.w    $D8,  $140, $CE00,     1
Map_SSZRoamingClouds:
                include "src/objects/shared/zones/ssz/mappings/roaming_clouds.s"
SSZSpiral_CharacterFramesByAngleBand:
                dc.b    $EF, $FA, $F9, $F8, $F7, $F6, $F5, $F4, $F3, $F2, $F1, $F0
SSZSpiral_AngleByWithinTurnPhase:
                dc.b    0,   2,   5,   7,   9,  $B,  $E, $10, $12, $15, $17, $19, $1B, $1E, $20, $22, $25, $27, $29, $2B
                dc.b    $2E, $30, $32, $35, $37, $39, $3B, $3E, $40, $42, $45, $47, $49, $4B, $4E, $50, $52, $55, $57, $59
                dc.b    $5B, $5E, $60, $62, $65, $67, $69, $6B, $6E, $70, $72, $75, $77, $79, $7B, $7E, $80, $82, $85, $87
                dc.b    $89, $8B, $8E, $90, $92, $95, $97, $99, $9B, $9E, $A0, $A2, $A5, $A7, $A9, $AB, $AE, $B0, $B2, $B5
                dc.b    $B7, $B9, $BB, $BE, $C0, $C2, $C5, $C7, $C9, $CB, $CE, $D0, $D2, $D5, $D7, $D9, $DB, $DE, $E0, $E2
                dc.b    $E5, $E7, $E9, $EB, $EE, $F0, $F2, $F5, $F7, $F9, $FB, $FE
SSZSpiral_PhaseYCorrections:
                dc.b    3,   3,   4,   5,   6,   6,   7,   7,   8,   8,   8,   8,   7,   7,   7,   7,   7,   6,   5,   4
                dc.b    3,   3,   3,   2,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  -1,  -1,  -1,  -1,  -2
                dc.b    -2,  -2,  -2,  -2,  -2,  -3,  -3,  -3,  -3,  -2,  -2,  -1,  -1,   0,   0,   2,   3,   4,   5,   6
                dc.b    7,   7,   8,   8,   9,   9,   9,   8,   7,   7,   7,   7,   7,   6,   5,   4,   3,   3,   3,   2
                dc.b    1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  -1,  -1,  -1,  -1,  -2,  -2,  -1,  -1,  -1
                dc.b    -1,  -2,  -2,  -2,  -2,  -1,  -1,   0,   0,   0,   1,   3
                even
SSZRampDebris_RowTileAndShapeWords:
                dc.w    $4000, $4004, $4008, $400C, $480C, $4808, $4804, $4800
                dc.w    $4010, $4014, $4018, $401C, $481C, $4818, $4814, $4810
                dc.w    $4020, $4024, $4028, $402C, $482C, $4828, $4824, $4820
                dc.w    $4020, $4024, $4028, $402C, $482C, $4828, $4824, $4820
                dc.w    $4030, $4034, $4038, $403C, $483C, $4838, $4834, $4830
                dc.w    $4040, $4044, $4048, $404C, $484C, $4848, $4844, $4840
                dc.w    $4020, $4024, $4028, $402C, $482C, $4828, $4824, $4820
                dc.w    $4040, $4044, $4048, $404C, $484C, $4848, $4844, $4840
                dc.w    $4020, $4024, $4028, $402C, $482C, $4828, $4824, $4820
                dc.w    $4040, $4044, $4048, $404C, $484C, $4848, $4844, $4840
                dc.w    $4020, $4024, $4028, $402C, $482C, $4828, $4824, $4820
                dc.w    $4020, $4024, $4028, $402C, $482C, $4828, $4824, $4820
                dc.w    $4030, $4034, $4038, $403C, $483C, $4838, $4834, $4830
                dc.w    $4040, $4044, $4048, $404C, $484C, $4848, $4844, $4840
                dc.w    $4020, $4024, $4028, $402C, $482C, $4828, $4824, $4820
                dc.w    $4040, $4044, $4048, $404C, $484C, $4848, $4844, $4840
                dc.w    $4020, $4024, $4028, $402C, $482C, $4828, $4824, $4820
                dc.w    $4040, $4044, $4048, $404C, $484C, $4848, $4844, $4840
                dc.w    $4020, $4024, $4028, $402C, $482C, $4828, $4824, $4820
                dc.w    $4040, $4044, $4048, $404C, $484C, $4848, $4844, $4840
                dc.w    $4020, $4024, $4028, $402C, $482C, $4828, $4824, $4820
                dc.w    $4040, $4044, $4048, $404C, $484C, $4848, $4844, $4840
                dc.w    $FFFE, $4054, $4058, $405C, $485C, $4858, $4854, $FFFD
                dc.w    $FFFF, $FFFF, $FFFE, $4068, $4868, $FFFD, $FFFF, $FFFF
Map_SSZSpiralRampPieces:
                include "src/objects/shared/zones/ssz/mappings/spiral_ramp_pieces.s"
SSZRampDebris_ColumnStartDelayPattern:
                dc.b    $1C
                dc.b    8
                dc.b    $10
                dc.b    0
                dc.b    4
                dc.b    $14
                dc.b    $18
                dc.b    $C
                even
