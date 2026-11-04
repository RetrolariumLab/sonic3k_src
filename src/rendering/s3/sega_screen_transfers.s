; Owner: rendering/s3
; Responsibility: Sega screen VInt transfer, streak fading and private horizontal offset data
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SegaScr_VInt:
                move.w  (_unkF662).w,d0
                beq.w   S3SegaActor_WipeScaleTransferReturn
                clr.w   (_unkF662).w
                move.w  SegaScr_VInt_Index-2(pc,d0.w),d0
                jmp     SegaScr_VInt_Index(pc,d0.w)
; End of function SegaScr_VInt

; ---------------------------------------------------------------------------
SegaScr_VInt_Index:
                dc.w    S3SegaVInt_UploadArtAndPrepRightStreaks-SegaScr_VInt_Index
                dc.w    S3SegaVInt_ClearPlaneAndPrepLeftStreaks-SegaScr_VInt_Index
; ---------------------------------------------------------------------------

S3SegaVInt_UploadArtAndPrepRightStreaks:
                dma68kToVDP $FF0B00,$1100,$2C00,VRAM
                lea     ObjB1_Streak_fade_to_right(pc),a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$950,VRAM,WRITE),d0
                bra.w   S3SegaVInt_InitStreakDraw
; ---------------------------------------------------------------------------

S3SegaVInt_ClearPlaneAndPrepLeftStreaks:
                dmaFillVRAM 0,VRAM_Plane_A_Name_Table,$2000
                lea     ObjB1_Streak_fade_to_left(pc),a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$9A0,VRAM,WRITE),d0
                bra.w   S3SegaVInt_InitStreakDraw
; ---------------------------------------------------------------------------

S3SegaVInt_InitStreakDraw:
                lea     (VDP_data_port).l,a6
                move.l  #$100<<16,d6
                moveq   #8-1,d1
                moveq   #$A-1,d2

S3SegaVInt_BeginStreakRow:
                move.l  d0,4(a6)
                move.w  d1,d3
                movea.l a1,a2

S3SegaVInt_ReadAndExpandStreakMarker:
                move.w  (a2)+,d4
                bclr    #$A,d4
                beq.s   S3SegaVInt_WriteStreakAndAdvance
                bsr.w   SegaScreen_RepeatStreakTileWord

S3SegaVInt_WriteStreakAndAdvance:
                move.w  d4,(a6)
                dbf     d3,S3SegaVInt_ReadAndExpandStreakMarker
                add.l   d6,d0
                dbf     d2,S3SegaVInt_BeginStreakRow
                rts

; =============== S U B R O U T I N E =======================================

SegaScreen_RepeatStreakTileWord:
                moveq   #bytesToWcnt($52),d5

S3SegaVInt_RepeatMarkedStreakWord:
                move.w  d4,(a6)
                dbf     d5,S3SegaVInt_RepeatMarkedStreakWord
                rts
; End of function SegaScreen_RepeatStreakTileWord

; ---------------------------------------------------------------------------
ObjB1_Streak_fade_to_right:
                dc.w    make_art_tile(ArtTile_S2Sega+0,1,1)
                dc.w    make_art_tile(ArtTile_S2Sega+1,1,1)
                dc.w    make_art_tile(ArtTile_S2Sega+2,1,1)
                dc.w    make_art_tile(ArtTile_S2Sega+3,1,1)
                dc.w    make_art_tile(ArtTile_S2Sega+4,1,1)
                dc.w    make_art_tile(ArtTile_S2Sega+5,1,1)
                dc.w    make_art_tile(ArtTile_S2Sega+6,1,1)
                dc.w    make_art_tile(ArtTile_S2Sega+7,1,1)|(1<<$A)
ObjB1_Streak_fade_to_left:
                dc.w    make_art_tile(ArtTile_S2Sega+7,1,1)|(1<<$A)
                dc.w    make_art_tile(ArtTile_S2Sega+6,1,1)
                dc.w    make_art_tile(ArtTile_S2Sega+5,1,1)
                dc.w    make_art_tile(ArtTile_S2Sega+4,1,1)
                dc.w    make_art_tile(ArtTile_S2Sega+3,1,1)
                dc.w    make_art_tile(ArtTile_S2Sega+2,1,1)
                dc.w    make_art_tile(ArtTile_S2Sega+1,1,1)
                dc.w    make_art_tile(ArtTile_S2Sega+0,1,1)
Streak_Horizontal_offsets:
                dc.b    $12
                dc.b    4
                dc.b    4
                dc.b    2
                dc.b    2
                dc.b    2
                dc.b    2
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    4
                dc.b    4
                dc.b    6
                dc.b    $A
                dc.b    8
                dc.b    6
                dc.b    4
                dc.b    4
                dc.b    4
                dc.b    4
                dc.b    6
                dc.b    6
                dc.b    8
                dc.b    8
                dc.b    $A
                dc.b    $A
                dc.b    $C
                dc.b    $E
                dc.b    $10
                dc.b    $16
                dc.b    0
                even
