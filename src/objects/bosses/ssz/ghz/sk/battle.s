; Owner: objects/bosses/ssz/ghz/sk
; Responsibility: Sky Sanctuary Green Hill-style boss controller, ball attack, motion helpers and private object resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSZGHZBoss:
                move.l  #Obj_Wait,(a0)
                move.b  #1,(Boss_flag).w
                move.w  #$1F,$2E(a0)
                move.l  #loc_7A294,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                jsr     (AllocateObject).l
                bne.s   loc_7A244
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

loc_7A244:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$110,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$40,d0
                move.w  d0,y_pos(a0)
                clr.w   (_unkFA88).w
                moveq   #PLCID_7B,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_SSZGHZMisc).l,a1
                move.w  #tiles_to_bytes(ArtTile_SSZGHZMisc),d2
                jsr     (Queue_Kos_Module).l
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_7A282:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_7A282
                lea     (Pal_SSZGHZMisc).l,a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_7A294:
                move.l  #loc_7A29C,(a0)

locret_7A29A:
                rts
; ---------------------------------------------------------------------------

loc_7A29C:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_7A2B4(pc,d0.w),d1
                jsr     off_7A2B4(pc,d1.w)
                bsr.w   HandleSSZGHZBossHitOrDefeatWithMisoffsetPalette
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
off_7A2B4:
                dc.w    loc_7A2C0-off_7A2B4
                dc.w    loc_7A2F0-off_7A2B4
                dc.w    loc_7A32C-off_7A2B4
                dc.w    loc_7A35E-off_7A2B4
                dc.w    loc_7A388-off_7A2B4
                dc.w    loc_7A3A8-off_7A2B4
; ---------------------------------------------------------------------------

loc_7A2C0:
                lea     ObjDat_SSZGHZBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                move.w  #$100,y_vel(a0)
                move.w  #$67,$2E(a0)
                move.l  #loc_7A2FC,$34(a0)
                lea     (Child1_MakeMechaHead).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_7A2F0:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7A2FC:
                move.b  #4,routine(a0)
                move.w  #-$100,x_vel(a0)
                lea     ChildObjDat_7A69E(pc),a2
                jsr     (CreateChild1_Normal).l
                move.w  #$C0,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_7A32C:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                cmp.w   x_pos(a0),d0
                blo.s   locret_7A35C
                move.b  #6,routine(a0)
                bset    #6,$38(a0)
                lea     ChildObjDat_7A684(pc),a2
                jsr     (CreateChild9_TreeList).l

locret_7A35C:
                rts
; ---------------------------------------------------------------------------

loc_7A35E:
                btst    #2,$38(a0)
                beq.s   locret_7A386
                move.b  #8,routine(a0)
                bclr    #6,$38(a0)
                move.w  #-$100,x_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_7A39A,$34(a0)

locret_7A386:
                rts
; ---------------------------------------------------------------------------

loc_7A388:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7A39A:
                move.b  #$A,routine(a0)
                bset    #6,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_7A3A8:
                bclr    #3,$38(a0)
                beq.s   locret_7A3CC
                move.b  #8,routine(a0)
                bclr    #6,$38(a0)
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  #$3F,$2E(a0)

locret_7A3CC:
                rts
; ---------------------------------------------------------------------------

loc_7A3CE:
                move.l  #loc_7A3E6,(a0)
                bset    #0,render_flags(a0)
                move.w  #$400,x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_7A3E6:
                subq.w  #1,$2E(a0)
                bmi.s   loc_7A3F8
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7A3F8:
                clr.b   (Boss_flag).w
                bset    #4,$38(a0)
                st      (_unkFA89).w
                st      (Events_bg+$00).w
                lea     (Target_palette_line_2).w,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_7A414:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_7A414
                moveq   #PLCID_32,d0
                jsr     (Load_PLC).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_7A428:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_7A43E(pc,d0.w),d1
                jsr     off_7A43E(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_7A43E:
                dc.w    loc_7A446-off_7A43E
                dc.w    loc_7A460-off_7A43E
                dc.w    loc_7A482-off_7A43E
                dc.w    loc_7A496-off_7A43E
; ---------------------------------------------------------------------------

loc_7A446:
                lea     ObjDat3_7A660(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #$1A,child_dy(a0)
                move.b  #1,$3A(a0)
                bra.w   SeedSSZGHZChainSegmentDropWaitBySubtype
; ---------------------------------------------------------------------------

loc_7A460:
                addq.w  #2,y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   locret_7A480
                addq.b  #2,routine(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   locret_7A480
                movea.w $44(a0),a1
                bset    #2,$38(a1)

locret_7A480:
                rts
; ---------------------------------------------------------------------------

loc_7A482:
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                beq.s   locret_7A494
                move.b  #6,routine(a0)

locret_7A494:
                rts
; ---------------------------------------------------------------------------

loc_7A496:
                move.b  $3C(a0),d0
                subi.b  #$40,d0
                sls     d1
                cmpi.b  #-$80,d0
                bhs.s   loc_7A4C2
                neg.b   $3A(a0)
                movea.w $44(a0),a1
                btst    #0,render_flags(a1)
                beq.s   loc_7A4B8
                not.b   d1

loc_7A4B8:
                tst.b   d1
                bne.s   loc_7A4C2
                bset    #3,$38(a1)

loc_7A4C2:
                move.b  $3A(a0),d0
                add.b   d0,$3C(a0)
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

loc_7A4D0:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_7A4E6(pc,d0.w),d1
                jsr     off_7A4E6(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_7A4E6:
                dc.w    loc_7A4EC-off_7A4E6
                dc.w    loc_7A460-off_7A4E6
                dc.w    loc_7A500-off_7A4E6
; ---------------------------------------------------------------------------

loc_7A4EC:
                bsr.w   SeedSSZGHZChainSegmentDropWaitBySubtype
                move.b  #4,$3A(a0)
                lea     ObjDat3_7A66C(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

loc_7A500:
                movea.w parent3(a0),a1
                move.b  $3C(a1),$3C(a0)
                move.b  $3A(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

loc_7A514:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_7A53E(pc,d0.w),d1
                jsr     off_7A53E(pc,d1.w)
                move.b  #0,mapping_frame(a0)
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_7A536
                move.b  #1,mapping_frame(a0)

loc_7A536:
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_7A53E:
                dc.w    loc_7A544-off_7A53E
                dc.w    loc_7A460-off_7A53E
                dc.w    loc_7A500-off_7A53E
; ---------------------------------------------------------------------------

loc_7A544:
                bsr.w   SeedSSZGHZChainSegmentDropWaitBySubtype
                move.b  #3,$3A(a0)
                lea     ObjDat3_7A678(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

loc_7A558:
                lea     word_7A65A(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_7A568,(a0)

loc_7A568:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_7A59A
                btst    #6,$38(a1)
                bne.w   locret_7A29A
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_7A29A
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7A59A:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

HandleSSZGHZBossHitOrDefeatWithMisoffsetPalette:
                tst.b   collision_flags(a0)
                bne.s   locret_7A5EA
                move.b  collision_property(a0),d0
                beq.s   loc_7A5EC
                tst.b   $20(a0)
                bne.s   loc_7A5C6
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

loc_7A5C6:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_7A5D4
; Bug: should be 2*3
                addi.w  #2*2,d0

loc_7A5D4:
                bsr.w   CopySSZGHZThreeColorPaletteAtByteOffset
                subq.b  #1,$20(a0)
                bne.s   locret_7A5EA
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_7A5EA:
                rts
; ---------------------------------------------------------------------------

loc_7A5EC:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #loc_7A3CE,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_7A60E
                move.b  #4,subtype(a1)

loc_7A60E:
                jmp     (BossDefeated).l
; End of function HandleSSZGHZBossHitOrDefeatWithMisoffsetPalette

; =============== S U B R O U T I N E =======================================

CopySSZGHZThreeColorPaletteAtByteOffset:
                lea     word_7A622(pc),a1
                lea     word_7A628(pc,d0.w),a2
                jmp     (CopyWordData_3).l
; End of function CopySSZGHZThreeColorPaletteAtByteOffset

; ---------------------------------------------------------------------------
word_7A622:
                dc.w    Normal_palette+$0E, Normal_palette+$1C, Normal_palette+$1E
word_7A628:
                dc.w    8,  $866,  $222
                dc.w    $888,  $CCC,  $EEE

; =============== S U B R O U T I N E =======================================

SeedSSZGHZChainSegmentDropWaitBySubtype:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_7A642(pc,d0.w),$2E(a0)
                rts
; End of function SeedSSZGHZChainSegmentDropWaitBySubtype

; ---------------------------------------------------------------------------
word_7A642:
                dc.w    $C,   $14,   $1C,   $24,   $2C,   $3C
ObjDat_SSZGHZBoss:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $200
                dc.b    $1C, $20,  $A,  $F
word_7A65A:
                dc.w    $200
                dc.b    8,   4,   6,   0
ObjDat3_7A660:
                dc.l    Map_SSZGHZMisc
; this is using the incorrect palette line
                dc.w    make_art_tile(ArtTile_SSZGHZMisc,1,0)
                dc.w    $300
                dc.b    8,   8,   2,   0
ObjDat3_7A66C:
                dc.l    Map_SSZGHZMisc
; this is using the incorrect palette line
                dc.w    make_art_tile(ArtTile_SSZGHZMisc,1,0)
                dc.w    $300
                dc.b    8,   8,   3,   0
ObjDat3_7A678:
                dc.l    Map_SSZGHZMisc
                dc.w    make_art_tile(ArtTile_SSZGHZMisc,1,0)
                dc.w    $280
                dc.b    8,   8,   0, $8F
ChildObjDat_7A684:
                dc.w    6-1
                dc.l    loc_7A428
                dc.l    loc_7A4D0
                dc.l    loc_7A4D0
                dc.l    loc_7A4D0
                dc.l    loc_7A4D0
                dc.l    loc_7A514
ChildObjDat_7A69E:
                dc.w    1-1
                dc.l    loc_7A558
                dc.b    $1E,   0
