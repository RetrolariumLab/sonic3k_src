; Owner: objects/ending/sk
; Responsibility: Ending Sonic, Tails and Knuckles pose actors, attached display elements and private placement offsets
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_5F31C:
                lea     word_60160(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                bclr    #2,render_flags(a0)
                move.l  #loc_5F376,(a0)
                lea     byte_5F36E(pc),a1
                bsr.w   EndingOffsetPoseByMaskedPlayerModePair
                lea     (Pal_SonicTails).l,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($20),d6

loc_5F346:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5F346
                jsr     (AllocateObject).l
                bne.s   locret_5F36C
                move.l  #loc_5FF62,(a1)
                move.w  #Normal_palette+2,$30(a1)
                move.w  #Target_palette+2,$32(a1)
                move.w  #$E,$3A(a1)

locret_5F36C:
                rts
; ---------------------------------------------------------------------------
byte_5F36E:
                dc.b    0, $40
                dc.b    0, $40
                dc.b    -$1C, $2C
                dc.b    -$1C, $2C
                even
; ---------------------------------------------------------------------------

loc_5F376:
                lea     AniRaw_6025C(pc),a1
                jsr     (Animate_RawNoSST).l
                btst    #2,(_unkFAB8).w
                beq.s   loc_5F398
                move.l  #loc_5F39E,(a0)
                lea     AniRaw_60260(pc),a1
                jsr     (Set_Raw_Animation).l

loc_5F398:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5F39E:
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5F3AA:
                lea     word_60168(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                bclr    #2,render_flags(a0)
                move.l  #loc_5F3DA,(a0)
                lea     byte_5F3D2(pc),a1
                bsr.w   EndingOffsetPoseByMaskedPlayerModePair
                lea     ChildObjDat_60204(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
byte_5F3D2:
                dc.b    $24, $2C
                dc.b    $24, $2C
                dc.b    8, $40
                dc.b    $24, $2C
                even
; ---------------------------------------------------------------------------

loc_5F3DA:
                lea     AniRaw_6026B(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5F3EA:
                lea     word_60170(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bclr    #2,render_flags(a0)
                move.l  #loc_5F400,(a0)

loc_5F400:
                lea     AniRaw_6026F(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5F410:
                lea     ObjDat3_60176(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.l  #loc_5F46A,(a0)
                lea     byte_5F462(pc),a1
                bsr.w   EndingOffsetPoseByMaskedPlayerModePair
                lea     (Pal_EndingEyecatchKnuckles).l,a1
                lea     (Target_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d6

loc_5F43A:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5F43A
                jsr     (AllocateObject).l
                bne.s   locret_5F460
                move.l  #loc_5FF62,(a1)
                move.w  #Normal_palette_line_3+2,$30(a1)
                move.w  #Target_palette_line_3+2,$32(a1)
                move.w  #$E,$3A(a1)

locret_5F460:
                rts
; ---------------------------------------------------------------------------
byte_5F462:
                dc.b    -$1C, $2C
                dc.b    -$1C, $2C
                dc.b    $1C, $2C
                dc.b    0, $40
                even
; ---------------------------------------------------------------------------

loc_5F46A:
                lea     (byte_66771).l,a1
                jsr     (Animate_Raw2NoSSTMultiDelay).l
                bsr.w   KnucklesEnding_Load_PLC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5F480:
                move.l  #loc_5F4E4,(a0)
                move.l  #Map_KnuxEndPose,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_KnuxEndPose,0,0),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$108,y_pos(a0)
                move.l  #AniRaw_602CA,$30(a0)
                lea     (Pal_KnuxEndPose).l,a1
                lea     (Normal_palette).w,a2
                moveq   #bytesToLcnt($20),d6

loc_5F4C6:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5F4C6
                tst.b   (_unkFA88).w
                beq.s   locret_5F4E2
                bmi.s   locret_5F4E2
                jsr     (AllocateObject).l
                bne.s   locret_5F4E2
                move.l  #loc_5FBA0,(a1)

locret_5F4E2:
                rts
; ---------------------------------------------------------------------------

loc_5F4E4:
                btst    #3,(_unkFAB8).w
                bne.w   loc_5F204
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5F4FA:
                tst.b   (Graphics_flags).w
                bpl.w   loc_5EC36
                lea     ObjDat3_60130(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.l  #Child_Draw_Sprite,(a0)
                lea     byte_5F520(pc),a1
                bra.w   loc_5FFD4
; ---------------------------------------------------------------------------
byte_5F520:
                dc.b    $48,   8
                dc.b    $34,-$10
                dc.b    $48,-$34
                even
; ---------------------------------------------------------------------------

loc_5F526:
                lea     ObjDat3_6013C(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.l  #Child_Draw_Sprite,(a0)
                lea     byte_5F544(pc),a1
                bra.w   loc_5FFD4
; ---------------------------------------------------------------------------
byte_5F544:
                dc.b    0, $14
                even
; ---------------------------------------------------------------------------

loc_5F546:
                lea     ObjDat3_60148(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.l  #Child_Draw_Sprite,(a0)
                lea     byte_5F564(pc),a1
                bra.w   loc_5FFD4
; ---------------------------------------------------------------------------
byte_5F564:
                dc.b    0, $48
                even
