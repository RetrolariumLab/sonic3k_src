; Owner: objects/bosses/icz/sk
; Responsibility: IceCap end-boss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZEndBoss:
                lea     word_71BBE(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #loc_71C08,(a0)
                move.l  #loc_71C0E,$34(a0)
                lea     word_71BC6(pc),a1
                move.b  #mus_EndBoss,boss_saved_mus(a0)
                jsr     (BeginBossCameraTransitionSaveBoundsAndFadeMusic).l
                moveq   #PLCID_70,d0
                jsr     (Load_PLC).l
                lea     Pal_ICZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_71C08:
                jmp     (loc_85CA4).l
; ---------------------------------------------------------------------------

loc_71C0E:
                move.l  #loc_71C16,(a0)

locret_71C14:
                rts
; ---------------------------------------------------------------------------

loc_71C16:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_71C2E(pc,d0.w),d1
                jsr     off_71C2E(pc,d1.w)
                bsr.w   HandleICZEndBossHitPhaseTransitionOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
off_71C2E:
                dc.w    loc_71C36-off_71C2E
                dc.w    loc_71C78-off_71C2E
                dc.w    loc_71CAA-off_71C2E
                dc.w    loc_71D64-off_71C2E
; ---------------------------------------------------------------------------

loc_71C36:
                lea     ObjDat3_72306(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$CF,$2E(a0)
                move.l  #loc_71C84,$34(a0)
                lea     (ChildObjDat_72336).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_71C6E
                move.b  #9,subtype(a1)

loc_71C6E:
                lea     ChildObjDat_7233E(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_71C78:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_71C84:
                move.w  #$7FFF,$44(a0)
                bsr.w   InitializeICZEndBossVerticalBob
                move.b  #4,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_71CEC,$34(a0)
                move.w  #$BF,$46(a0)
                rts
; ---------------------------------------------------------------------------

loc_71CAA:
                jsr     (Swing_UpAndDown).l
                subq.w  #1,$44(a0)
                bpl.s   loc_71CC6
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  #$17F,$44(a0)

loc_71CC6:
                jsr     (MoveSprite2).l
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   loc_71CE6
                subq.w  #1,$46(a0)
                bpl.s   loc_71CE6
                move.w  #$7F,$46(a0)
                bchg    #2,$38(a0)

loc_71CE6:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_71CEC:
                bset    #2,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_71D02,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_71D02:
                move.w  #$3F,$2E(a0)
                move.w  #-$80,x_vel(a0)
                move.w  #$17F,$44(a0)
                move.l  #loc_71D1E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_71D1E:
                move.l  #loc_71D46,$34(a0)
                moveq   #signextendB(sfx_FrostPuff),d0
                jsr     (Play_SFX).l
                bsr.w   SelectICZEndBossFrostAttackMode
                cmpi.w  #2,$26(a0)
                bne.w   locret_71C14
                lea     ChildObjDat_72352(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_71D46:
                bclr    #1,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_71D1E,$34(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_71D64:
                subq.w  #1,$3C(a0)
                bmi.s   loc_71D78
                addi.l  #$8000,y_pos(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_71D78:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_71D80:
                move.l  #Obj_Wait,(a0)
                bset    #4,$38(a0)
                move.l  #loc_71D9E,$34(a0)
                lea     ChildObjDat_7236C(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_71D9E:
                move.l  #loc_71DE2,(a0)
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                jsr     (AllocateObject).l
                bne.s   loc_71DC6
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$4560,x_pos(a1)
                move.w  #$6A3,y_pos(a1)

loc_71DC6:
                move.w  (_unkFAB4).w,d0
                addi.w  #$130,d0
                move.w  d0,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   locret_71DE0
                move.l  #Obj_IncLevEndXGradual,(a1)

locret_71DE0:
                rts
; ---------------------------------------------------------------------------

loc_71DE2:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (_unkFAA8).w
                bne.w   locret_71C14
                clr.b   (_unkFAA8).w
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                jsr     (Restore_LevelMusic).l
                move.w  (Camera_stored_max_Y_pos).w,(Camera_target_max_Y_pos).w
                move.w  #$47C0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_71E28:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_71E44(pc,d0.w),d1
                jsr     off_71E44(pc,d1.w)
                moveq   #$C,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_71E44:
                dc.w    loc_71E4A-off_71E44
                dc.w    loc_71E54-off_71E44
                dc.w    loc_71E7C-off_71E44
; ---------------------------------------------------------------------------

loc_71E4A:
                lea     word_72312(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

loc_71E54:
                movea.w parent3(a0),a1
                tst.b   $3B(a1)
                bne.s   loc_71E60
                rts
; ---------------------------------------------------------------------------

loc_71E60:
                move.b  #4,routine(a0)
                move.b  #4,mapping_frame(a0)
                move.w  #$E,$2E(a0)
                move.l  #loc_71E82,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_71E7C:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_71E82:
                move.w  #$17,$2E(a0)
                move.w  #6,$26(a0)
                lea     ChildObjDat_7235E(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_71E98:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_71EC4(pc,d0.w),d1
                jsr     off_71EC4(pc,d1.w)
                jsr     (Refresh_ChildPosition).l
                moveq   #0,d0
                movea.w parent3(a0),a1
                tst.b   $3B(a1)
                bne.s   loc_71EBE
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_71EBE:
                jmp     (SKRuntimeChildren_ConvertChildToIndexedVelocityFlickerAndDraw).l
; ---------------------------------------------------------------------------
off_71EC4:
                dc.w    loc_71ECA-off_71EC4
                dc.w    loc_71ED4-off_71EC4
                dc.w    loc_71F10-off_71EC4
; ---------------------------------------------------------------------------

loc_71ECA:
                lea     word_72318(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

loc_71ED4:
                movea.w parent3(a0),a4
                move.b  $3A(a0),d0
                move.b  $38(a4),d1
                move.b  d1,$3A(a0)
                eor.b   d1,d0
                andi.b  #4,d0
                beq.s   locret_71F0E
                moveq   #1,d0
                btst    #2,d1
                bne.s   loc_71EF6
                neg.b   d0

loc_71EF6:
                move.b  d0,$40(a0)
                move.b  #4,routine(a0)
                move.w  #$24,$2E(a0)
                move.l  #loc_71F1E,$34(a0)

locret_71F0E:
                rts
; ---------------------------------------------------------------------------

loc_71F10:
                move.b  $40(a0),d0
                add.b   d0,$43(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_71F1E:
                move.b  #2,routine(a0)
                movea.w parent3(a0),a1
                move.b  $38(a1),$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_71F30:
                move.w  x_pos(a0),-(sp)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_71F74(pc,d0.w),d1
                jsr     off_71F74(pc,d1.w)
                jsr     (Refresh_ChildPosition).l
                moveq   #$23,d1
                moveq   #4,d2
                moveq   #$A,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                moveq   #0,d0
                movea.w parent3(a0),a1
                tst.b   $3B(a1)
                bne.s   loc_71F68
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_71F68:
                jsr     (Displace_PlayerOffObject).l
                jmp     (SKRuntimeChildren_ConvertChildToIndexedVelocityFlickerAndDraw).l
; ---------------------------------------------------------------------------
off_71F74:
                dc.w    loc_71F7A-off_71F74
                dc.w    loc_71F92-off_71F74
                dc.w    loc_71FDA-off_71F74
; ---------------------------------------------------------------------------

loc_71F7A:
                lea     word_7231E(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                movea.w parent3(a0),a1
                lea     ChildObjDat_72364(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_71F92:
                movea.w parent3(a0),a4
                btst    #1,$38(a4)
                beq.s   loc_71FA2
                bsr.w   loc_72006

loc_71FA2:
                move.b  $3A(a0),d0
                move.b  $38(a4),d1
                move.b  d1,$3A(a0)
                eor.b   d1,d0
                andi.b  #4,d0
                beq.s   locret_71FD8
                moveq   #1,d0
                btst    #2,d1
                bne.s   loc_71FC0
                neg.b   d0

loc_71FC0:
                move.b  d0,$40(a0)
                move.b  #4,routine(a0)
                move.w  #$42,$2E(a0)
                move.l  #loc_71F1E,$34(a0)

locret_71FD8:
                rts
; ---------------------------------------------------------------------------

loc_71FDA:
                movea.w parent3(a0),a4
                btst    #1,$38(a4)
                beq.s   loc_71FEA
                bsr.w   loc_72006

loc_71FEA:
                move.b  $40(a0),d0
                add.b   d0,$43(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------
; unused
                move.b  #2,routine(a0)
                move.b  $38(a4),$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_72006:
                move.w  $26(a4),d0
                cmpi.w  #2,d0
                beq.w   locret_71C14
                move.w  d0,$26(a0)
                lea     ChildObjDat_72358(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_72020:
                lea     ObjDat3_72324(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_Wait,(a0)
                move.l  #loc_7203C,$34(a0)
                bra.w   loc_72168
; ---------------------------------------------------------------------------

loc_7203C:
                movea.w parent3(a0),a1
                move.l  #loc_7205E,(a0)
                cmpi.w  #6,$26(a1)
                bne.s   loc_72054
                move.l  #loc_72092,(a0)

loc_72054:
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7205E:
                jsr     (Refresh_ChildPosition).l
                jsr     (Animate_RawMultiDelay).l
                cmpi.b  #4,anim_frame(a0)
                blo.s   loc_72084
                cmpi.b  #8,anim_frame(a0)
                bhi.s   loc_72084
                lea     word_7208A(pc),a1
                jsr     (CapturePlayersInsideIczFreezerZone).l

loc_72084:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
word_7208A:
                dc.w    -$18,   $30,  -$18,   $30
; ---------------------------------------------------------------------------

loc_72092:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Animate_RawMultiDelay).l
                cmpi.b  #4,anim_frame(a0)
                blo.s   loc_720B8
                cmpi.b  #8,anim_frame(a0)
                bhi.s   loc_720B8
                lea     word_720BE(pc),a1
                jsr     (CapturePlayersInsideIczFreezerZone).l

loc_720B8:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
word_720BE:
                dc.w    -$10,   $20,  -$10,   $20
; ---------------------------------------------------------------------------

loc_720C6:
                move.l  #loc_720D4,(a0)
                move.b  #$9B,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_720D4:
                jsr     (Refresh_ChildPosition).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_720EC
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

loc_720EC:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_720F2:
                lea     word_72330(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                jsr     (Refresh_ChildPositionAdjusted).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$16,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$34,d0
                jmp     (Set_IndexedVelocity).l

; =============== S U B R O U T I N E =======================================

InitializeICZEndBossVerticalBob:
                move.w  #$C0,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
; End of function InitializeICZEndBossVerticalBob

; =============== S U B R O U T I N E =======================================

SelectICZEndBossFrostAttackMode:
                bset    #1,$38(a0)
                tst.b   $3B(a0)
                bne.s   loc_72160
                move.b  $3A(a0),d0
                andi.w  #$F,d0
                lea     byte_723D0(pc),a1
                move.b  (a1,d0.w),$27(a0)
                addq.b  #1,d0
                move.b  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_72160:
                move.w  #2,$26(a0)
                rts
; End of function SelectICZEndBossFrostAttackMode

; ---------------------------------------------------------------------------

loc_72168:
                movea.w parent3(a0),a1
                move.w  $26(a1),d0
                moveq   #0,d1
                move.b  subtype(a0),d1
                lea     word_721F4(pc),a2
                move.w  (a2,d0.w),d2
                adda.w  d2,a2
                move.w  (a2,d1.w),child_dx(a0)          ; and child_dy
                lea     word_7222C(pc),a2
                move.w  (a2,d0.w),d2
                adda.w  d2,a2
                move.b  (a2,d1.w),d2
                or.b    d2,render_flags(a0)
                lea     word_721C2(pc),a2
                move.w  (a2,d0.w),d2
                adda.w  d2,a2
                move.w  (a2,d1.w),$2E(a0)
                cmpi.b  #6,d0
                beq.s   loc_721B8
                add.w   d1,d1
                move.l  off_721D8(pc,d1.w),$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_721B8:
                move.l  #byte_7239C,$30(a0)
                rts
; ---------------------------------------------------------------------------
word_721C2:
                dc.w    word_721CA-word_721C2
                dc.w    word_721CC-word_721C2
                dc.w    word_721CA-word_721C2
                dc.w    word_721D0-word_721C2
word_721CA:
                dc.w    $11
word_721CC:
                dc.w    $E
                dc.w    $B
word_721D0:
                dc.w    8
                dc.w    5
                dc.w    2
                dc.w    $FFFF
off_721D8:
                dc.l    byte_7238F
                dc.l    byte_7238F
                dc.l    byte_7238F
                dc.l    byte_7238F
                dc.l    byte_72380
                dc.l    byte_72380
                dc.l    byte_72380
word_721F4:
                dc.w    byte_721FC-word_721F4
                dc.w    byte_7220A-word_721F4
                dc.w    byte_72216-word_721F4
                dc.w    byte_72224-word_721F4
byte_721FC:
                dc.b    -$50, $14
                dc.b    -$40, $14
                dc.b    -$48,   4
                dc.b    -$40,   4
                dc.b    -$34,  $C
                dc.b    -$24,   8
                dc.b    -$1C,   4
byte_7220A:
                dc.b    8, $40
                dc.b    0, $3C
                dc.b    -$10, $40
                dc.b    -8, $3C
                dc.b    -4, $34
                dc.b    -4, $28
byte_72216:
                dc.b    $50, $14
                dc.b    $40, $14
                dc.b    $48,   4
                dc.b    $40,   4
                dc.b    $34,  $C
                dc.b    $24,   8
                dc.b    $1C,   4
byte_72224:
                dc.b    $18,  -4
                dc.b    $14,   0
                dc.b    $10,  -8
                dc.b    8,  -4
                even
word_7222C:
                dc.w    byte_72234-word_7222C
                dc.w    byte_72242-word_7222C
                dc.w    byte_7224E-word_7222C
                dc.w    byte_7223A-word_7222C
byte_72234:
                dc.b    2,   0
                dc.b    2,   0
                dc.b    0,   0
byte_7223A:
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
byte_72242:
                dc.b    1,   0
                dc.b    1,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
byte_7224E:
                dc.b    3,   0
                dc.b    3,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    1,   0
                even

; =============== S U B R O U T I N E =======================================

HandleICZEndBossHitPhaseTransitionOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   locret_722C4
                move.b  collision_property(a0),d0
                beq.s   loc_722C6
                tst.b   $20(a0)
                bne.s   loc_72292
                cmpi.b  #2,d0
                bne.s   loc_72284
                st      $3B(a0)
                move.b  #6,routine(a0)
                move.w  #$7F,$3C(a0)

loc_72284:
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_72292:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_722A6
                addi.w  #2*2,d0

loc_722A6:
                bsr.w   CopyICZEndBossTwoColorPalette
                subq.b  #1,$20(a0)
                bne.s   locret_722C4
                bclr    #6,status(a0)
                cmpi.b  #0,mapping_frame(a0)
                bne.s   locret_722C4
                move.b  $25(a0),collision_flags(a0)

locret_722C4:
                rts
; ---------------------------------------------------------------------------

loc_722C6:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #loc_71D80,$34(a0)
                movea.w (_unkFAAE).w,a1
                cmpi.l  #loc_8B660,(a1)
                bne.s   loc_722E6
                bset    #5,$38(a1)

loc_722E6:
                jmp     (BossDefeated_StopTimer).l
; End of function HandleICZEndBossHitPhaseTransitionOrDefeat

; =============== S U B R O U T I N E =======================================

CopyICZEndBossTwoColorPalette:
                lea     word_722FA(pc),a1
                lea     word_722FE(pc,d0.w),a2
                jmp     (CopyWordData_2).l
; End of function CopyICZEndBossTwoColorPalette

; ---------------------------------------------------------------------------
word_722FA:
                dc.w    Normal_palette_line_2+$14, Normal_palette_line_2+$1C
word_722FE:
                dc.w    $20,  $644
                dc.w    $EEE,  $AAA
ObjDat3_72306:
                dc.l    Map_ICZEndBoss
                dc.w    make_art_tile(ArtTile_ICZEndBoss,1,1)
                dc.w    $280
                dc.b    $24, $24,   0,  $F
word_72312:
                dc.w    $200
                dc.b    $14,   8,   3,   0
word_72318:
                dc.w    $280
                dc.b    8,  $C,   1,   0
word_7231E:
                dc.w    $280
                dc.b    $18, $2C,   2,   0
ObjDat3_72324:
                dc.l    Map_ICZEndBoss
                dc.w    make_art_tile(ArtTile_ICZEndBoss,1,1)
                dc.w    $80
                dc.b    $10, $10,   5,   0
word_72330:
                dc.w    $180
                dc.b    $14, $10,   0,   0
ChildObjDat_72336:
                dc.w    1-1
                dc.l    Obj_RobotnikShip4
                dc.b    0,   0
ChildObjDat_7233E:
                dc.w    3-1
                dc.l    loc_71E28
                dc.b    $18,   7
                dc.l    loc_71E98
                dc.b    0,  $B
                dc.l    loc_71F30
                dc.b    0, $2D
ChildObjDat_72352:
                dc.w    6-1
                dc.l    loc_72020
ChildObjDat_72358:
                dc.w    7-1
                dc.l    loc_72020
ChildObjDat_7235E:
                dc.w    4-1
                dc.l    loc_72020
ChildObjDat_72364:
                dc.w    1-1
                dc.l    loc_720C6
                dc.b    0,   8
ChildObjDat_7236C:
                dc.w    3-1
                dc.l    loc_720F2
                dc.b    -$14,   4
                dc.l    loc_720F2
                dc.b    $C,   4
                dc.l    loc_720F2
                dc.b    0, $1C
byte_72380:
                dc.b    5,   1
                dc.b    5,   1
                dc.b    6,   1
                dc.b    7,   2
                dc.b    8,   3
                dc.b    9,   4
                dc.b    $A,   5
                dc.b    $F4
byte_7238F:
                dc.b    $B,   2
                dc.b    $B,   2
                dc.b    $C,   3
                dc.b    $D,   4
                dc.b    $E,   5
                dc.b    $F,   6
                dc.b    $F4
byte_7239C:
                dc.b    $10,   1
                dc.b    $10,   1
                dc.b    $11,   1
                dc.b    $12,   2
                dc.b    $13,   2
                dc.b    $14,   2
                dc.b    $15,   2
                dc.b    $F4
                dc.b    5,   0,   1, $FC
                even
Pal_ICZEndBoss:
                binclude "data/Levels/ICZ/Palettes/End Boss.bin"
                even
byte_723D0:
                dc.b    0,   2
                dc.b    4,   2
                dc.b    0,   2
                dc.b    4,   2
                dc.b    0,   2
                dc.b    0,   2
                dc.b    4,   2
                dc.b    2,   4
                even
