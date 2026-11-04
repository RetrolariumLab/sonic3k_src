; Owner: game/level/sk
; Responsibility: Water motion lookup values and per-zone palette transfer sequences for horizontal interrupts
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
SKEnv_HCZ2CurrentChunkIds:
                dc.b    $1C, $72, $83, $84, $8B, $91, $9F, $A0, $A5, $A6
SKEnv_ICZ1SkidChunkIds:
                dc.b    $2E, $C6, $33, $C5, $24, $2A, $44, $1F, $27, $2B
SKEnv_ICZChunkSpeedTargets:
                dc.b    $F8, $F8,   8,   8, $F4, $F4, $F4,  $C,  $C,  $C
SKEnvironment_SozGroundSkidChunkIdBytes:
                dc.b    $F, $13, $14, $15, $16, $17, $35, $6C, $6D, $76
                dc.b    $77, $7E, $7F, $85, $8A, $8C, $90
SKEnv_SOZSkidAndRegionPairs:
                dc.b    $F8,   0, $F8,   0, $FA,   1, $FA,   2, $F8,   0, $F8,   0, $F8,   0,   6,   1,   0,   3,   6,   2
                dc.b    8,   0,   8,   0,   8,   0,   8,   0,   8,   0,   0,   3, $F8,   0,   0
                even
; ---------------------------------------------------------------------------
; Water palette transition tables

; These are used by HInt3 to load the water palette only a small bit at a time,
; this is to space out the CRAM writes to push the VDP dots offscreen
;
; Each value is an offset into Water_palette
; From there, 6 bytes, meaning 3 palette entries, are transferred to CRAM
; ---------------------------------------------------------------------------

WaterTransition_AIZ1:   watertransheader
                dc.w    2
                dc.w    $68
                dc.w    $62
                dc.w    $42
                dc.w    $48
                dc.w    $4E
                dc.w    $54
                dc.w    8
                dc.w    $E
                dc.w    $14
                dc.w    $1A
                dc.w    $34
                dc.w    $22
                dc.w    $3A
                dc.w    $2E
                dc.w    $28
WaterTransition_AIZ1_End:

WaterTransition_AIZ2:   watertransheader
                dc.w    $6E
                dc.w    $68
                dc.w    2
                dc.w    $48
                dc.w    $42
                dc.w    $4E
                dc.w    $5A
                dc.w    $54
                dc.w    $62
                dc.w    $74
                dc.w    8
                dc.w    $E
                dc.w    $14
                dc.w    $1A
                dc.w    $34
                dc.w    $22
                dc.w    $3A
                dc.w    $2E
                dc.w    $28
WaterTransition_AIZ2_End:

WaterTransition_CNZ2ICZ2:   watertransheader
                dc.w    $6E
                dc.w    $68
                dc.w    $7A
                dc.w    $74
                dc.w    $62
                dc.w    2
                dc.w    $42
                dc.w    $48
                dc.w    $4E
                dc.w    $5A
                dc.w    8
                dc.w    $E
                dc.w    $14
                dc.w    $1A
                dc.w    $34
                dc.w    $22
                dc.w    $3A
                dc.w    $2E
                dc.w    $28
                dc.w    $54
WaterTransition_CNZ2ICZ2_End:

; Hydrocity Zone doesn't use this?
WaterTransition_HCZLBZ1:    watertransheader
                dc.w    2
                dc.w    $74
                dc.w    $62
                dc.w    $68
                dc.w    $6E
                dc.w    $42
                dc.w    $48
                dc.w    $7A
                dc.w    $5A
                dc.w    $54
                dc.w    8
                dc.w    $E
                dc.w    $14
                dc.w    $1A
                dc.w    $2E
                dc.w    $34
                dc.w    $28
                dc.w    $3A
                dc.w    $22
                dc.w    $4E
WaterTransition_HCZLBZ1_End:

WaterTransition_LBZ2:   watertransheader
                dc.w    2
                dc.w    $6E
                dc.w    $68
                dc.w    $7A
                dc.w    $62
                dc.w    $74
                dc.w    $42
                dc.w    $48
                dc.w    $5A
                dc.w    $54
                dc.w    8
                dc.w    $E
                dc.w    $14
                dc.w    $1A
                dc.w    $2E
                dc.w    $34
                dc.w    $28
                dc.w    $3A
                dc.w    $22
                dc.w    $4E
WaterTransition_LBZ2_End:

; Unknown and unused
WaterTransition_Unk:    watertransheader
                dc.w    2
                dc.w    8
                dc.w    $E
                dc.w    $14
                dc.w    $1A
                dc.w    $42
                dc.w    $48
                dc.w    $4E
                dc.w    $54
                dc.w    $5A
                dc.w    $62
                dc.w    $68
                dc.w    $6E
                dc.w    $74
                dc.w    $7A
                dc.w    $22
                dc.w    $28
                dc.w    $2E
                dc.w    $34
                dc.w    $3A
WaterTransition_Unk_End:

; =============== S U B R O U T I N E =======================================
