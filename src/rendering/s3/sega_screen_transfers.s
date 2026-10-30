; Owner: rendering/s3
; Responsibility: Sega screen VInt transfer, streak fading and private horizontal offset data
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SegaScr_VInt:
                move.w  (_unkF662).w,d0
                beq.w   locret_432D8
                clr.w   (_unkF662).w
                move.w  SegaScr_VInt_Index-2(pc,d0.w),d0
                jmp     SegaScr_VInt_Index(pc,d0.w)
; End of function SegaScr_VInt

; ---------------------------------------------------------------------------
SegaScr_VInt_Index:
                dc.w    loc_435C4-SegaScr_VInt_Index
                dc.w    loc_435F6-SegaScr_VInt_Index
; ---------------------------------------------------------------------------

loc_435C4:
                dma68kToVDP $FF0B00,$1100,$2C00,VRAM
                lea     ObjB1_Streak_fade_to_right(pc),a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$950,VRAM,WRITE),d0
                bra.w   loc_43632
; ---------------------------------------------------------------------------

loc_435F6:
                dmaFillVRAM 0,VRAM_Plane_A_Name_Table,$2000
                lea     ObjB1_Streak_fade_to_left(pc),a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$9A0,VRAM,WRITE),d0
                bra.w   loc_43632
; ---------------------------------------------------------------------------

loc_43632:
                lea     (VDP_data_port).l,a6
                move.l  #$100<<16,d6
                moveq   #8-1,d1
                moveq   #$A-1,d2

loc_43642:
                move.l  d0,4(a6)
                move.w  d1,d3
                movea.l a1,a2

loc_4364A:
                move.w  (a2)+,d4
                bclr    #$A,d4
                beq.s   loc_43656
                bsr.w   sub_43664

loc_43656:
                move.w  d4,(a6)
                dbf     d3,loc_4364A
                add.l   d6,d0
                dbf     d2,loc_43642
                rts

; =============== S U B R O U T I N E =======================================

sub_43664:
                moveq   #bytesToWcnt($52),d5

loc_43666:
                move.w  d4,(a6)
                dbf     d5,loc_43666
                rts
; End of function sub_43664

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
