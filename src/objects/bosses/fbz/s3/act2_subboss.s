; Owner: objects/bosses/fbz/s3
; Responsibility: Flying Battery act-two subboss lifecycle, battle state, coordinated actors and resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZ2Subboss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZ2Subboss_Index(pc,d0.w),d1
                jsr     FBZ2Subboss_Index(pc,d1.w)
                bsr.w   FlashAndResetFBZAct2SubbossHitState
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
FBZ2Subboss_Index:
                dc.w    loc_4D57A-FBZ2Subboss_Index
                dc.w    loc_4D5D6-FBZ2Subboss_Index
                dc.w    loc_4D602-FBZ2Subboss_Index
                dc.w    loc_4D644-FBZ2Subboss_Index
                dc.w    loc_4D664-FBZ2Subboss_Index
                dc.w    loc_4D6C8-FBZ2Subboss_Index
; ---------------------------------------------------------------------------

loc_4D57A:
                lea     ObjDat_FBZ2Subboss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$7F,collision_property(a0)
                move.b  #6,$39(a0)
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  #$240,(Camera_target_max_Y_pos).w
                move.w  #2*60,$2E(a0)
                move.l  #loc_4D5EC,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.b  #1,(Boss_flag).w
                moveq   #PLCID_6A,d0
                jsr     (Load_PLC).l
                lea     Pal_FBZ2Subboss(pc),a1
                jsr     PalLoad_Line1(pc)
                lea     ChildObjDat_4DB2E(pc),a2
                jsr     CreateChild3_NormalRepeated(pc)
                lea     ChildObjDat_4DB36(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4D5D6:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                cmpi.w  #$18,d2
                bhs.s   loc_4D5E8
                bsr.w   CreateFBZAct2SubbossSideBarriersOnce

loc_4D5E8:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4D5EC:
                move.b  #4,routine(a0)
                move.w  #$3F,$2E(a0)
                moveq   #signextendB(mus_Miniboss),d0
                jsr     (Play_Music).l

locret_4D600:
                rts
; ---------------------------------------------------------------------------

loc_4D602:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                cmpi.w  #$18,d2
                blo.s   loc_4D618
                subq.w  #1,$2E(a0)
                bmi.s   loc_4D618
                rts
; ---------------------------------------------------------------------------

loc_4D618:
                move.b  #6,routine(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4D64E,$34(a0)

CreateFBZAct2SubbossSideBarriersOnce:
                bset    #7,$38(a0)
                bne.w   locret_4D600
                lea     ChildObjDat_4DB44(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

loc_4D644:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4D64E:
                move.b  #8,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4D67A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D664:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4D668:
                subq.b  #1,$39(a0)
                bmi.s   loc_4D6AC
                bset    #3,$38(a0)
                bclr    #0,$38(a0)

loc_4D67A:
                move.b  #$A,routine(a0)
                bclr    #1,$38(a0)
                clr.w   y_vel(a0)
                lea     ChildObjDat_4DB4C(pc),a2
                jsr     CreateChild1_Normal(pc)

; =============== S U B R O U T I N E =======================================

SetFBZAct2SubbossChaseVelocity:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                move.w  #$100,d1
                tst.w   d0
                bne.s   loc_4D6A6
                neg.w   d1

loc_4D6A6:
                move.w  d1,x_vel(a0)
                rts
; End of function SetFBZAct2SubbossChaseVelocity

; ---------------------------------------------------------------------------

loc_4D6AC:
                move.l  #Wait_Draw,(a0)
                bset    #7,status(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4D726,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D6C8:
                btst    #1,$38(a0)
                bne.s   loc_4D710
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$1F,d0
                bne.s   loc_4D6DC
                bsr.s   SetFBZAct2SubbossChaseVelocity

loc_4D6DC:
                move.w  #$100,d0
                movea.w $44(a0),a1
                move.w  x_pos(a1),d1
                move.w  x_pos(a0),d2
                addi.w  #$20,d1
                cmp.w   d1,d2
                blo.s   loc_4D706
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d1
                subi.w  #$20,d1
                cmp.w   d1,d2
                blo.s   loc_4D70A
                neg.w   d0

loc_4D706:
                move.w  d0,x_vel(a0)

loc_4D70A:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_4D710:
                move.b  #8,routine(a0)
                move.w  #$BF,$2E(a0)
                move.l  #loc_4D668,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D726:
                bset    #4,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4D73C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D73C:
                bset    #2,$38(a0)
                clr.b   (Boss_flag).w
                move.l  #Sprite_OnScreen_Test,(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D74E:
                lea     word_4DB08(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_4D760,(a0)
                bra.w   loc_4DA52
; ---------------------------------------------------------------------------

loc_4D760:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_4D7A0
                btst    #1,subtype(a0)
                bne.s   loc_4D79A
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_4D79A
                move.l  #loc_4D7A8,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_4D7B8,$34(a0)
                move.w  #$100,x_vel(a0)

loc_4D79A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4D7A0:
                move.l  #Sprite_OnScreen_Test,(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D7A8:
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4D7B8:
                move.l  #loc_4D760,(a0)
                movea.w parent3(a0),a1
                bclr    #3,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_4D7CA:
                lea     word_4DB0E(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_4D7E6,(a0)
                addi.w  #$CC,x_pos(a0)
                addi.w  #$7C,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D7E6:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_4D7F8
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4D7F8:
                move.l  #Sprite_OnScreen_Test,(a0)
                move.b  #3,mapping_frame(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4D814:
                lea     ObjDat3_4DB22(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_4D838,(a0)
                addi.w  #$D8,x_pos(a0)
                addi.w  #$74,y_pos(a0)
                move.l  #byte_4DB54,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D838:
                jsr     Animate_RawMultiDelay(pc)
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                beq.s   loc_4D84E
                move.b  #2,mapping_frame(a0)

loc_4D84E:
                btst    #7,status(a1)
                beq.s   loc_4D862
                move.l  #loc_4D868,(a0)
                move.b  #3,mapping_frame(a0)

loc_4D862:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4D868:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                beq.s   loc_4D8A4
                move.l  #loc_4D8AA,(a0)
                subq.w  #4,y_pos(a0)
                move.w  #$200,x_vel(a0)
                move.l  #Map_FBZRobotnikRun,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZRobotnikRun,0,0),art_tile(a0)
                clr.b   mapping_frame(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                bset    #0,render_flags(a0)

loc_4D8A4:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4D8AA:
                lea     byte_4DB79(pc),a1
                jsr     Animate_RawNoSST(pc)
                jsr     (MoveSprite2).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_4D8BE:
                lea     word_4DB14(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_4D8F6,(a0)
                move.w  #$B0,d0
                move.b  subtype(a0),d1
                bne.s   loc_4D8D8
                neg.w   d0

loc_4D8D8:
                add.w   d0,x_pos(a0)
                addi.w  #$60,y_pos(a0)
                movea.w parent3(a0),a1
                moveq   #$44,d0
                tst.b   d1
                beq.s   loc_4D8EE
                moveq   #parent3,d0

loc_4D8EE:
                move.w  (a1,d0.w),$44(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D8F6:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_4D930
                move.w  x_pos(a0),-(sp)
                movea.w $44(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                moveq   #$13,d1
                moveq   #$50,d2
                move.w  #$60,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_4D600
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4D930:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4D936:
                lea     word_4DB1A(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_4D956,(a0)
                move.l  #byte_4DB61,$30(a0)
                move.l  #loc_4D978,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D956:
                jsr     Refresh_ChildPosition(pc)
                jsr     Animate_RawGetFaster(pc)
                tst.w   d2
                bpl.s   loc_4D974
                cmpi.b  #$60,$2F(a0)
                bne.s   loc_4D974
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

loc_4D974:
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_4D978:
                move.l  #loc_4D9A2,(a0)
                move.b  #6,mapping_frame(a0)
                move.l  #byte_4DB66,$30(a0)
                addi.w  #$3C,y_pos(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_4D9DE,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D9A2:
                clr.b   collision_flags(a0)
                cmpi.b  #8,mapping_frame(a0)
                bne.s   loc_4D9B4
                move.b  #$AC,collision_flags(a0)

loc_4D9B4:
                lea     (Player_1).w,a2
                cmpi.b  #4,routine(a2)
                beq.s   loc_4D9CC
                lea     (Player_2).w,a2
                cmpi.b  #4,routine(a2)
                bne.s   loc_4D9D2

loc_4D9CC:
                bset    #0,$38(a0)

loc_4D9D2:
                jsr     Animate_Raw(pc)
                jsr     Obj_Wait(pc)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_4D9DE:
                move.l  #loc_4DA04,$34(a0)
                move.w  #$1F,$2E(a0)
                st      (Screen_shake_flag).w
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_4DA02
                addi.w  #$60,y_pos(a1)

locret_4DA02:
                rts
; ---------------------------------------------------------------------------

loc_4DA04:
                move.l  #byte_4DB72,$30(a0)
                move.l  #loc_4DA30,$34(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                btst    #0,$38(a0)
                bne.s   locret_4DA2E
                movea.w parent3(a0),a1
                bset    #0,$38(a1)

locret_4DA2E:
                rts
; ---------------------------------------------------------------------------

loc_4DA30:
                move.l  #Obj_Wait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_4DA46,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4DA46:
                clr.w   (Screen_shake_flag).w
                movea.w parent3(a0),a1
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

loc_4DA52:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                cmpi.w  #4,d0
                bhs.s   loc_4DA74
                moveq   #$44,d1
                tst.b   d0
                beq.s   loc_4DA6A
                moveq   #parent3,d1

loc_4DA6A:
                move.w  a0,(a1,d1.w)
                bset    #1,render_flags(a0)

loc_4DA74:
                add.w   d0,d0
                lea     word_4DA88(pc,d0.w),a1
                move.w  (a1)+,d0
                add.w   d0,x_pos(a0)
                move.w  (a1)+,d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
word_4DA88:
                dc.w    -$B0,   $18
                dc.w    $B0,   $18
                dc.w    -$B0,   $A8
                dc.w    $B0,   $A8

; =============== S U B R O U T I N E =======================================

FlashAndResetFBZAct2SubbossHitState:
                tst.b   collision_flags(a0)
                bne.s   locret_4DAE8
                tst.b   $20(a0)
                bne.s   loc_4DAB2
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_4DAB2:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_4DAC4
; Bug: this should be 2*3
                addq.w  #2*2,d0

loc_4DAC4:
                lea     word_4DAEA(pc),a1
                lea     word_4DAF0(pc,d0.w),a2
                jsr     CopyWordData_3(pc)
                subq.b  #1,$20(a0)
                bne.s   locret_4DAE8
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)
                move.b  #$7F,collision_property(a0)

locret_4DAE8:
                rts
; End of function FlashAndResetFBZAct2SubbossHitState

; ---------------------------------------------------------------------------
word_4DAEA:
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_4DAF0:
                dc.w    $866,  $644,   $20
                dc.w    $EEE,  $EEE,  $EEE
ObjDat_FBZ2Subboss:
                dc.l    Map_FBZ2Subboss
                dc.w    make_art_tile(ArtTile_FBZ2Subboss,1,0)
                dc.w    $280
                dc.b    $20, $20,   0, $1C
word_4DB08:
                dc.w    $80
                dc.b    8,   8,   1,   0
word_4DB0E:
                dc.w    $280
                dc.b    $C, $14,   2,   0
word_4DB14:
                dc.w    $80
                dc.b    8, $60,   4,   0
word_4DB1A:
                dc.w    make_art_tile(ArtTile_FBZ2Subboss,1,1)
                dc.w    $80
                dc.b    $18,   4,   5,   0
ObjDat3_4DB22:
                dc.l    Map_FBZRobotnikStand
                dc.w    make_art_tile(ArtTile_FBZRobotnikStand,0,1)
                dc.w    $280
                dc.b    $20, $20,   0,   0
ChildObjDat_4DB2E:
                dc.w    4-1
                dc.l    loc_4D74E
                dc.b    0,   0
ChildObjDat_4DB36:
                dc.w    2-1
                dc.l    loc_4D7CA
                dc.b    0,   0
                dc.l    loc_4D814
                dc.b    0,   0
ChildObjDat_4DB44:
                dc.w    2-1
                dc.l    loc_4D8BE
                dc.b    0,   0
ChildObjDat_4DB4C:
                dc.w    1-1
                dc.l    loc_4D936
                dc.b    0,   8
byte_4DB54:
                dc.b    0,   7
                dc.b    1, $17
                dc.b    0,   7
                dc.b    1,  $F
                dc.b    0, $3F
                dc.b    1,   7
                dc.b    $FC
byte_4DB61:
                dc.b    $B, $80
                dc.b    5,  $A
                dc.b    $FC
byte_4DB66:
                dc.b    0,   6,   6,  $A,   7,  $A
                dc.b    $F8, .jump-byte_4DB66

                .jump:
                dc.b    0,   8,  $A, $FC
byte_4DB72:
                dc.b    0,   7
                dc.b    7,  $A
                dc.b    6,  $A
                dc.b    $F4
byte_4DB79:
                dc.b    7,   0,   1,   2,   1, $FC
                even
Pal_FBZ2Subboss:
                binclude "data/Levels/FBZ/Palettes/FBZ2 Subboss.bin"
                even
