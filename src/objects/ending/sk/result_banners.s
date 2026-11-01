; Owner: objects/ending/sk
; Responsibility: Ending logo and result banner actors, placement records and input-controlled return to title
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_5F1AC:
                lea     ObjDat3_60118(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_5F1F6,(a0)
                lea     word_5F1EA(pc),a1
                bsr.w   EndingPlaceBannerBlackenPaletteAndSpawnWhiteFlashRestore
                lea     (Pal_EndingSKLogo).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_5F1D0:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5F1D0
                jsr     (AllocateObject).l
                bne.s   locret_5F1E8
                move.l  #loc_5F4FA,(a1)
                move.w  a0,parent3(a1)

locret_5F1E8:
                rts
; ---------------------------------------------------------------------------
word_5F1EA:
                dc.w    $120,   $B0
                dc.w    $E0,   $B8
                dc.w    $120,   $F0
; ---------------------------------------------------------------------------

loc_5F1F6:
                btst    #3,(_unkFAB8).w
                bne.s   loc_5F204
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5F204:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_5F20A:
                lea     ObjDat3_60124(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_5F1F6,(a0)
                lea     word_5F260(pc),a1
                bsr.w   EndingPlaceBannerBlackenPaletteAndSpawnWhiteFlashRestore
                lea     (Pal_EndingS3KLogo).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_5F22E:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5F22E
                jsr     (AllocateObject).l
                bne.s   loc_5F246
                move.l  #loc_5F526,(a1)
                move.w  a0,parent3(a1)

loc_5F246:
                jsr     (AllocateObject).l
                bne.s   locret_5F25E
                move.l  #loc_5F4FA,(a1)
                move.w  a0,parent3(a1)
                move.b  #2,subtype(a1)

locret_5F25E:
                rts
; ---------------------------------------------------------------------------
word_5F260:
                dc.w    $120,   $B0
                dc.w    $D0,   $B8
                dc.w    $120,   $F0
; ---------------------------------------------------------------------------

loc_5F26C:
                lea     ObjDat3_60154(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_5F1F6,(a0)
                tst.b   subtype(a0)
                beq.s   loc_5F294
                move.l  #loc_5F2EA,(a0)
                move.w  #$4AF,$2E(a0)
                bclr    #2,(_unkFAB8).w

loc_5F294:
                lea     word_5F2E2(pc),a1
                bsr.w   EndingPlaceBannerBlackenPaletteAndSpawnWhiteFlashRestore
                lea     (Pal_EndingS3KLogo).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_5F2A8:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5F2A8
                jsr     (AllocateObject).l
                bne.s   loc_5F2C6
                move.l  #loc_5F4FA,(a1)
                move.w  a0,parent3(a1)
                move.b  #4,subtype(a1)

loc_5F2C6:
                jsr     (AllocateObject).l
                bne.s   loc_5F2D8
                move.l  #loc_5F546,(a1)
                move.w  a0,parent3(a1)

loc_5F2D8:
                lea     ChildObjDat_601F0(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
word_5F2E2:
                dc.w    $120,   $F0
                dc.w    $120,   $F0
; ---------------------------------------------------------------------------

loc_5F2EA:
                cmpi.w  #$40,$2E(a0)
                bne.s   loc_5F2F8
                bset    #2,(_unkFAB8).w

loc_5F2F8:
                btst    #button_start,(Ctrl_1_held).w
                bne.s   loc_5F314
                btst    #button_start,(Ctrl_2_held).w
                bne.s   loc_5F314
                subq.w  #1,$2E(a0)
                bmi.s   loc_5F314
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5F314:
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
