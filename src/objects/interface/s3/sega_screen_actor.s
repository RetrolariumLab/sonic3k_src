; Owner: objects/interface/s3
; Responsibility: Sega-screen Sonic actor and the preceding debug trap dispatch whose empty indexed function list aliases the actor entry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Trap15_FuncDebug:
                movea.l Func_Listing(pc,d6.w),a6
                jsr     (a6)
                nop
                nop
                move    sr,d5
                move.w  (sp),d6
                andi.w  #$1F,d5
                andi.w  #$FFE0,d6
                or.w    d5,d6
                move.w  d6,(sp)
                nop
                nop
                rte
; ---------------------------------------------------------------------------
Func_Listing:
; ---------------------------------------------------------------------------

Obj_SonicOnSegaScr:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SonicOnSegaScr_Index(pc,d0.w),d1
                jmp     SonicOnSegaScr_Index(pc,d1.w)
; ---------------------------------------------------------------------------
SonicOnSegaScr_Index:
                dc.w    SonicOnSegaScr_Init-SonicOnSegaScr_Index
                dc.w    SonicOnSegaScr_RunLeft-SonicOnSegaScr_Index
                dc.w    SonicOnSegaScr_MidWipe-SonicOnSegaScr_Index
                dc.w    SonicOnSegaScr_RunRight-SonicOnSegaScr_Index
                dc.w    SonicOnSegaScr_EndWipe-SonicOnSegaScr_Index
                dc.w    locret_43340-SonicOnSegaScr_Index
; ---------------------------------------------------------------------------

SonicOnSegaScr_Init:
                lea     ObjDat3_434E0(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #0,render_flags(a0)
                move.w  #$1E8,x_pos(a0)
                move.w  #$F0,y_pos(a0)
                move.w  #$B,$2E(a0)
                move.w  #2,(_unkF662).w
                bset    #0,render_flags(a0)
                bset    #0,status(a0)
                lea     (H_scroll_buffer+$138).w,a1
                lea     Streak_Horizontal_offsets(pc),a2
                moveq   #0,d0
                moveq   #35-1,d6

loc_431B8:
                move.b  (a2)+,d0
                add.w   d0,(a1)
                addq.w  #8,a1
                dbf     d6,loc_431B8
                move.w  d7,-(sp)
                moveq   #0,d0
                moveq   #0,d1
                lea     SonicRunningSpriteScaleData(pc),a6
                moveq   #8-1,d7

loc_431CE:
                movea.l (a6)+,a1
                movea.l (a6)+,a2
                move.b  (a6)+,d0
                move.b  (a6)+,d1
                bsr.w   Scale_2x
                dbf     d7,loc_431CE
                move.w  (sp)+,d7
                rts
; ---------------------------------------------------------------------------
SonicRunningSpriteScaleData:
                dc.l    Chunk_table
                dc.l    Chunk_table+$B00
                dc.b    3-1
                dc.b    2-1
                dc.l    Chunk_table+$C0
                dc.l    Chunk_table+$E00
                dc.b    4-1
                dc.b    4-1
                dc.l    Chunk_table+$2C0
                dc.l    Chunk_table+$1600
                dc.b    3-1
                dc.b    2-1
                dc.l    Chunk_table+$380
                dc.l    Chunk_table+$1900
                dc.b    4-1
                dc.b    4-1
                dc.l    Chunk_table+$580
                dc.l    Chunk_table+$2100
                dc.b    3-1
                dc.b    2-1
                dc.l    Chunk_table+$640
                dc.l    Chunk_table+$2400
                dc.b    4-1
                dc.b    4-1
                dc.l    Chunk_table+$840
                dc.l    Chunk_table+$2C00
                dc.b    3-1
                dc.b    2-1
                dc.l    Chunk_table+$900
                dc.l    Chunk_table+$2F00
                dc.b    4-1
                dc.b    4-1
; ---------------------------------------------------------------------------

SonicOnSegaScr_RunLeft:
                subi.w  #$20,x_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   loc_43254
                bsr.w   SonicOnSegaScr_Move_Streaks_Left
                lea     (Ani_SonicOnSegaScr).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_43254:
                addq.b  #2,routine(a0)
                move.w  #$C,$2E(a0)
                move.b  #1,$30(a0)
                move.b  #-1,$31(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SonicOnSegaScr_MidWipe:
                tst.w   $2E(a0)
                beq.s   loc_4327E
                subq.w  #1,$2E(a0)
                bsr.w   SonicOnSegaScr_Move_Streaks_Left

loc_4327E:
                lea     byte_433F4(pc),a1
                bsr.w   SegaS3StepTimedPaletteFrameCopy
                bne.s   loc_4328A
                rts
; ---------------------------------------------------------------------------

loc_4328A:
                addq.b  #2,routine(a0)
                bchg    #0,render_flags(a0)
                move.w  #$B,$2E(a0)
                move.w  #4,(_unkF662).w
                subi.w  #$28,x_pos(a0)
                bchg    #0,render_flags(a0)
                bchg    #0,status(a0)
; Bug: this should be (Target_water_palette-H_scroll_buffer)
                clearRAM H_scroll_buffer,(Target_water_palette-H_scroll_buffer)+4
                lea     (H_scroll_buffer+$13C).w,a1
                lea     Streak_Horizontal_offsets(pc),a2
                moveq   #0,d0
                moveq   #35-1,d6

loc_432CE:
                move.b  (a2)+,d0
                sub.w   d0,(a1)
                addq.w  #8,a1
                dbf     d6,loc_432CE

locret_432D8:
                rts
; ---------------------------------------------------------------------------

SonicOnSegaScr_RunRight:
                subq.w  #1,$2E(a0)
                bmi.s   loc_432FC
                addi.w  #$20,x_pos(a0)
                bsr.w   SonicOnSegaScr_Move_Streaks_Right
                lea     (Ani_SonicOnSegaScr).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_432FC:
                addq.b  #2,routine(a0)
                move.w  #$C,$2E(a0)
                move.b  #1,$30(a0)
                move.b  #-1,$31(a0)
                rts
; ---------------------------------------------------------------------------

SonicOnSegaScr_EndWipe:
                tst.w   $2E(a0)
                beq.s   loc_43322
                subq.w  #1,$2E(a0)
                bsr.w   SonicOnSegaScr_Move_Streaks_Right

loc_43322:
                lea     byte_4346A(pc),a1
                bsr.w   SegaS3StepTimedPaletteFrameCopy
                bne.s   loc_4332E
                rts
; ---------------------------------------------------------------------------

loc_4332E:
                addq.b  #2,routine(a0)
                st      (_unkF660).w
                move.b  #cmd_S2SEGA,d0
                jsr     (Play_SFX).l

locret_43340:
                rts
; ---------------------------------------------------------------------------

ObjB1:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ObjB1_Index(pc,d0.w),d1
                jmp     ObjB1_Index(pc,d1.w)
; ---------------------------------------------------------------------------
ObjB1_Index:
                dc.w    ObjB1_Init-ObjB1_Index
                dc.w    ObjB1_Main-ObjB1_Index
; ---------------------------------------------------------------------------

ObjB1_Init:
                lea     ObjDat3_434EA(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #0,render_flags(a0)
                move.b  #4,mapping_frame(a0)
                move.w  #$174,x_pos(a0)
                move.w  #$D8,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

ObjB1_Main:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

SonicOnSegaScr_Move_Streaks_Left:
                lea     (H_scroll_buffer+$138).w,a1
                move.w  #35-1,d6

loc_43386:
                subi.w  #$20,(a1)
                addq.w  #8,a1
                dbf     d6,loc_43386
                rts
; End of function SonicOnSegaScr_Move_Streaks_Left

; =============== S U B R O U T I N E =======================================

SonicOnSegaScr_Move_Streaks_Right:
                lea     (H_scroll_buffer+$13C).w,a1
                move.w  #35-1,d6

loc_4339A:
                addi.w  #$20,(a1)
                addq.w  #8,a1
                dbf     d6,loc_4339A
                rts
; End of function SonicOnSegaScr_Move_Streaks_Right

; =============== S U B R O U T I N E =======================================

SegaS3StepTimedPaletteFrameCopy:
                subq.b  #1,$30(a0)
                bne.s   loc_433EC
                moveq   #0,d0
                move.b  $31(a0),d0
                addq.b  #1,d0
                cmp.b   1(a1),d0
                bcs.s   loc_433C0
                tst.b   3(a1)
                bne.s   loc_433F0

loc_433C0:
                move.b  d0,$31(a0)
                move.b  (a1),$30(a0)
                lea     6(a1),a2
                moveq   #0,d1
                move.b  2(a1),d1
                move.w  d1,d2
                tst.w   d0
                beq.s   loc_433E2

loc_433D8:
                subq.b  #1,d0
                beq.s   loc_433E0
                add.w   d2,d1
                bra.s   loc_433D8
; ---------------------------------------------------------------------------

loc_433E0:
                adda.w  d1,a2

loc_433E2:
                movea.w 4(a1),a3

loc_433E6:
                move.w  (a2)+,(a3)+
                subq.w  #2,d2
                bne.s   loc_433E6

loc_433EC:
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

loc_433F0:
                moveq   #1,d0
                rts
; End of function SegaS3StepTimedPaletteFrameCopy

; ---------------------------------------------------------------------------
byte_433F4:
                dc.b    4
                dc.b    7
                dc.b    $10
                dc.b    $FF
                dc.w    Normal_palette+$10
                binclude "data/General/S2Menu/Palettes/Sega Screen 2.bin"
byte_4346A:
                dc.b    4
                dc.b    7
                dc.b    $10
                dc.b    $FF
                dc.w    Normal_palette
                binclude "data/General/S2Menu/Palettes/Sega Screen 3.bin"
ObjDat3_434E0:
                dc.l    Map_SonicOnSegaScr
                dc.w    make_art_tile(ArtTile_S2Sega+8,2,1)
                dc.w    $80
                dc.b    $10
                dc.b    0
ObjDat3_434EA:
                dc.l    Map_SonicOnSegaScr
                dc.w    make_art_tile($003,0,0)
                dc.w    $100
                dc.b    8
                dc.b    0
Ani_SonicOnSegaScr:
                include "src/ui/shared/s2menu/animations/sega_sonic.s"
Map_SonicOnSegaScr:
                include "src/ui/shared/s2menu/mappings/sega_sonic.s"
