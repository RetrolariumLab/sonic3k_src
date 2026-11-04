; Owner: objects/interface/continue/sk
; Responsibility: Continue countdown digit transfer, character child selection and private palette or animation records
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Build two two-row digits from the countdown nibbles and transfer them immediately
Continue_DrawCountdownToPlaneA:
                move.b  (_unkFA84).w,d0
                move.b  d0,d1
                andi.w  #$F0,d0
                lsr.w   #3,d0
                andi.w  #$F,d1
                add.w   d1,d1
                move.w  #1,d2
                lea     (RAM_start+$2000).l,a1
                add.w   d2,d0
                move.w  d0,(a1)+
                add.w   d2,d1
                move.w  d1,(a1)+
                addq.w  #1,d0
                move.w  d0,(a1)+
                addq.w  #1,d1
                move.w  d1,(a1)+
                move    #$2700,sr
                lea     (VDP_data_port).l,a6
                move.w  #VRAM_Plane_A_Name_Table+$726,d2
                swap    d2
                clr.w   d2
                swap    d2
                lsl.l   #2,d2
                lsr.w   #2,d2
                ori.w   #$4000,d2
                swap    d2
                move.l  d2,d3
                addi.l  #$80<<16,d3
                lea     (RAM_start+$2000).l,a1
                move.l  d2,VDP_control_port-VDP_data_port(a6)
                move.w  (a1)+,(a6)
                move.w  (a1)+,(a6)
                move.l  d3,VDP_control_port-VDP_data_port(a6)
                move.w  (a1)+,(a6)
                move.w  (a1)+,(a6)
                move    #$2300,sr
                rts
; End of function Continue_DrawCountdownToPlaneA

; =============== S U B R O U T I N E =======================================

; Reserve the first two screen objects and seed up to nine icons in consecutive fixed slots
Continue_InitExtraCountIcons:
                moveq   #0,d0
                move.b  (Continue_count).w,d0
                beq.s   ContinueIcons_UseCount10
                cmpi.b  #$A,d0
                bls.s   ContinueIcons_PrepFixedSlots

ContinueIcons_UseCount10:
                moveq   #$A,d0

ContinueIcons_PrepFixedSlots:
                lea     (Dynamic_object_RAM+(object_size*2)).w,a1
                moveq   #0,d1

ContinueIcons_SeedCountMinusOne:
                subq.b  #1,d0
                beq.w   SKContinueScene_ReturnAfterContinueSave
                move.l  #ContinueIcons_SelectMapAndPalette,(a1)
                move.b  d1,subtype(a1)
                addq.w  #2,d1
                lea     next_object(a1),a1
                bra.s   ContinueIcons_SeedCountMinusOne
; End of function Continue_InitExtraCountIcons

; =============== S U B R O U T I N E =======================================

ContinueIcon_SetCenterOutX:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  ContinueIcons_AlternatingCenterOutXWords(pc,d0.w),x_pos(a0)
                rts
; End of function ContinueIcon_SetCenterOutX

; ---------------------------------------------------------------------------
ContinueIcons_AlternatingCenterOutXWords:
                dc.w    $120
                dc.w    $138
                dc.w    $108
                dc.w    $150
                dc.w    $F0
                dc.w    $168
                dc.w    $D8
                dc.w    $180
                dc.w    $C0

; =============== S U B R O U T I N E =======================================

; Select a two-frame sequence by player mode and try an auxiliary Tails child in Tails-alone mode
ContinueIcon_SelectCharacterFrames:
                move.w  (Player_mode).w,d4
                cmpi.b  #2,d4
                bne.s   ContinueIcons_LoadPairAfterTailsChild
                lea     ContinueTailsIconChild_SimpleSpawnRecord(pc),a2
                jsr     (CreateChild6_Simple).l

ContinueIcons_LoadPairAfterTailsChild:
                lsl.w   #2,d4
                move.l  ContinueIcons_CharacterFramePairPointers(pc,d4.w),$30(a0)
                rts
; End of function ContinueIcon_SelectCharacterFrames

; ---------------------------------------------------------------------------
ContinueTailsIconChild_SimpleSpawnRecord:
                dc.w    1-1
                dc.l    ContinueTailsIconChild_Initialize
ContinueIcons_CharacterFramePairPointers:
                dc.l    ContinueIcons_SonicFramePair
                dc.l    ContinueIcons_SonicFramePair
                dc.l    ContinueIcons_TailsBodyFramePair
                dc.l    ContinueIcons_KnucklesFramePair
aCONTINUE:
                dc.b    "C O N T I N U E",0
                even
ContinueIcons_SonicFramePair:   dc.b    0
                dc.b    1
ContinueIcons_TailsBodyFramePair:   dc.b    2
                dc.b    3
ContinueIcons_KnucklesFramePair:    dc.b    7
                dc.b    8
ContinueExit_SonicKnucklesRawLoop:
                dc.b    2, $21, $22, $23, $24, $FF, $FC
ContinueTailsIconChild_RawAnimation:
                dc.b    8,   4,   5,   6, $FC
ContinueKnuckles_MiscOrdinaryRawWaitLoop:
                dc.b    $B,   2,   2,   4, $FC
ContinueSonicAlone_EscapedRawWaitLoop:
                dc.b    $B, $BD, $BE, $FF, $FC
                even
Pal_ContinueScreen:
                binclude "data/General/Continue/Palettes/Palette.bin"
                even
