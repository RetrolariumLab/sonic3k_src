; Owner: objects/bosses/icz/s3
; Responsibility: IceCap end-boss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZEndBoss:
                lea     word_4ED28(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #loc_4ED30,(a0)
                move.b  #1,(Boss_flag).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #2*60,$2E(a0)
                move.b  #mus_EndBoss,$26(a0)
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  #$5F8,(Camera_target_max_Y_pos).w
                move.w  #$4390,$1C(a0)
                move.w  #$4390,(Camera_max_X_pos).w
                move.l  #loc_4ED34,$34(a0)
                moveq   #PLCID_70,d0
                jsr     (Load_PLC).l
                lea     Pal_ICZEndBoss(pc),a1
                jmp     PalLoad_Line1(pc)
; ---------------------------------------------------------------------------
word_4ED28:
                dc.w    0,  $6C0, $4340, $4390
; ---------------------------------------------------------------------------

loc_4ED30:
                jmp     loc_541C8(pc)
; ---------------------------------------------------------------------------

loc_4ED34:
                move.l  #loc_4ED3C,(a0)

locret_4ED3A:
                rts
; ---------------------------------------------------------------------------

loc_4ED3C:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4ED52(pc,d0.w),d1
                jsr     off_4ED52(pc,d1.w)
                bsr.w   sub_4F2F4
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
off_4ED52:
                dc.w    loc_4ED5A-off_4ED52
                dc.w    loc_4ED96-off_4ED52
                dc.w    loc_4EDC0-off_4ED52
                dc.w    loc_4EE5A-off_4ED52
; ---------------------------------------------------------------------------

loc_4ED5A:
                lea     ObjDat3_4F39A(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #8,collision_property(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$CF,$2E(a0)
                move.l  #loc_4EDA0,$34(a0)
                lea     (ChildObjDat_4F3CA).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   loc_4ED8E
                move.b  #9,subtype(a1)

loc_4ED8E:
                lea     ChildObjDat_4F3D2(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4ED96:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4EDA0:
                move.w  #$7FFF,$44(a0)
                bsr.w   sub_4F1B8
                move.b  #4,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4EDE4,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4EDC0:
                jsr     Swing_UpAndDown(pc)
                subq.w  #1,$44(a0)
                bpl.s   loc_4EDDA
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  #$17F,$44(a0)

loc_4EDDA:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4EDE4:
                bset    #2,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4EDFA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4EDFA:
                move.w  #$3F,$2E(a0)
                move.w  #-$80,x_vel(a0)
                move.w  #$17F,$44(a0)
                move.l  #loc_4EE16,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4EE16:
                move.l  #loc_4EE3C,$34(a0)
                moveq   #signextendB(sfx_FrostPuff),d0
                jsr     (Play_SFX).l
                bsr.w   sub_4F1D2
                cmpi.w  #2,$26(a0)
                bne.w   locret_4ED3A
                lea     ChildObjDat_4F3E6(pc),a2
                jmp     CreateChild6_Simple(pc)
; ---------------------------------------------------------------------------

loc_4EE3C:
                bclr    #1,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4EE16,$34(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_4EE5A:
                subq.w  #1,$3C(a0)
                bmi.s   loc_4EE6C
                addi.l  #$8000,y_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4EE6C:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4EE74:
                move.l  #Obj_Wait,(a0)
                bclr    #7,render_flags(a0)
                bset    #4,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_4EEA4,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                lea     ChildObjDat_4F400(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4EEA4:
                move.l  #loc_4EECE,(a0)
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                jsr     (Restore_LevelMusic).l
                move.w  #$4390+$130,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   locret_4EECC
                move.l  #Obj_IncLevEndXGradual,(a1)

locret_4EECC:
                rts
; ---------------------------------------------------------------------------

loc_4EECE:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (_unkFAA8).w
                bne.w   locret_4ED3A
                clr.b   (_unkFAA8).w
                jsr     Restore_PlayerControl(pc)
                lea     (Player_2).w,a1
                jsr     Restore_PlayerControl2(pc)
                move.w  (Camera_stored_max_Y_pos).w,(Camera_target_max_Y_pos).w
                move.w  #$47C0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_4EF0A:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4EF22(pc,d0.w),d1
                jsr     off_4EF22(pc,d1.w)
                moveq   #$C,d0
                jmp     Child_Draw_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------
off_4EF22:
                dc.w    loc_4EF28-off_4EF22
                dc.w    loc_4EF30-off_4EF22
                dc.w    loc_4EF58-off_4EF22
; ---------------------------------------------------------------------------

loc_4EF28:
                lea     word_4F3A6(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_4EF30:
                movea.w parent3(a0),a1
                tst.b   $3B(a1)
                bne.s   loc_4EF3C
                rts
; ---------------------------------------------------------------------------

loc_4EF3C:
                move.b  #4,routine(a0)
                move.b  #4,mapping_frame(a0)
                move.w  #$E,$2E(a0)
                move.l  #loc_4EF5C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4EF58:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4EF5C:
                move.w  #$17,$2E(a0)
                move.w  #6,$26(a0)
                lea     ChildObjDat_4F3F2(pc),a2
                jmp     CreateChild6_Simple(pc)
; ---------------------------------------------------------------------------

loc_4EF70:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4EF96(pc,d0.w),d1
                jsr     off_4EF96(pc,d1.w)
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                movea.w parent3(a0),a1
                tst.b   $3B(a1)
                bne.w   loc_5312A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_4EF96:
                dc.w    loc_4EFA0-off_4EF96
                dc.w    loc_4EFA8-off_4EF96
                dc.w    loc_4EFCC-off_4EF96
                dc.w    loc_4EFDC-off_4EF96
                dc.w    loc_4F000-off_4EF96
; ---------------------------------------------------------------------------

loc_4EFA0:
                lea     word_4F3AC(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_4EFA8:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_4EFB6
                rts
; ---------------------------------------------------------------------------

loc_4EFB6:
                move.b  #4,routine(a0)
                move.w  #$24,$2E(a0)
                move.l  #loc_4EFD4,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4EFCC:
                addq.b  #1,$43(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4EFD4:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4EFDC:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   loc_4EFEA
                rts
; ---------------------------------------------------------------------------

loc_4EFEA:
                move.b  #8,routine(a0)
                move.w  #$24,$2E(a0)
                move.l  #loc_4F008,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F000:
                subq.b  #1,$43(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4F008:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F010:
                move.w  x_pos(a0),-(sp)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4F04E(pc,d0.w),d1
                jsr     off_4F04E(pc,d1.w)
                jsr     Refresh_ChildPosition(pc)
                moveq   #$23,d1
                moveq   #4,d2
                moveq   #$A,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                moveq   #0,d0
                movea.w parent3(a0),a1
                tst.b   $3B(a1)
                bne.s   loc_4F046
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4F046:
                jsr     Displace_PlayerOffObject(pc)
                jmp     loc_5312A(pc)
; ---------------------------------------------------------------------------
off_4F04E:
                dc.w    loc_4F058-off_4F04E
                dc.w    loc_4F068-off_4F04E
                dc.w    loc_4EFCC-off_4F04E
                dc.w    loc_4F08C-off_4F04E
                dc.w    loc_4F000-off_4F04E
; ---------------------------------------------------------------------------

loc_4F058:
                lea     word_4F3B2(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                lea     ChildObjDat_4F3F8(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4F068:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_4F076
                rts
; ---------------------------------------------------------------------------

loc_4F076:
                move.b  #4,routine(a0)
                move.w  #$42,$2E(a0)
                move.l  #loc_4EFD4,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F08C:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   loc_4F0B8
                btst    #1,$38(a1)
                beq.s   locret_4F0B6
                move.w  $26(a1),d0
                cmpi.w  #2,d0
                beq.s   locret_4F0B6
                move.w  d0,$26(a0)
                lea     ChildObjDat_4F3EC(pc),a2
                jsr     CreateChild6_Simple(pc)

locret_4F0B6:
                rts
; ---------------------------------------------------------------------------

loc_4F0B8:
                move.b  #8,routine(a0)
                move.w  #$42,$2E(a0)
                move.l  #loc_4F008,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F0CE:
                lea     ObjDat3_4F3B8(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #Obj_Wait,(a0)
                move.l  #loc_4F0E8,$34(a0)
                bra.w   loc_4F200
; ---------------------------------------------------------------------------

loc_4F0E8:
                movea.w parent3(a0),a1
                move.l  #loc_4F10A,(a0)
                cmpi.w  #6,$26(a1)
                bne.s   loc_4F100
                move.l  #loc_4F138,(a0)

loc_4F100:
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F10A:
                jsr     Refresh_ChildPosition(pc)
                jsr     Animate_RawMultiDelay(pc)
                cmpi.b  #4,anim_frame(a0)
                blo.s   loc_4F12C
                cmpi.b  #8,anim_frame(a0)
                bhi.s   loc_4F12C
                lea     word_4F130(pc),a1
                jsr     (sub_5819C).l

loc_4F12C:
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
word_4F130:
                dc.w    -$18,   $30,  -$18,   $30
; ---------------------------------------------------------------------------

loc_4F138:
                jsr     Refresh_ChildPositionAdjusted(pc)
                jsr     Animate_RawMultiDelay(pc)
                cmpi.b  #4,anim_frame(a0)
                blo.s   loc_4F15A
                cmpi.b  #8,anim_frame(a0)
                bhi.s   loc_4F15A
                lea     word_4F15E(pc),a1
                jsr     (sub_5819C).l

loc_4F15A:
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
word_4F15E:
                dc.w    -$10,   $20,  -$10,   $20
; ---------------------------------------------------------------------------

loc_4F166:
                move.l  #loc_4F174,(a0)
                move.b  #$9B,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F174:
                jsr     Refresh_ChildPosition(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_4F18A
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

loc_4F18A:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4F190:
                lea     word_4F3C4(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$16,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$34,d0
                jmp     Set_IndexedVelocity(pc)

; =============== S U B R O U T I N E =======================================

sub_4F1B8:
                move.w  #$C0,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
; End of function sub_4F1B8

; =============== S U B R O U T I N E =======================================

sub_4F1D2:
                bset    #1,$38(a0)
                tst.b   $3B(a0)
                bne.s   loc_4F1F8
                move.b  $3A(a0),d0
                andi.w  #$F,d0
                lea     byte_4F464(pc),a1
                move.b  (a1,d0.w),$27(a0)
                addq.b  #1,d0
                move.b  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F1F8:
                move.w  #2,$26(a0)
                rts
; End of function sub_4F1D2

; ---------------------------------------------------------------------------

loc_4F200:
                movea.w parent3(a0),a1
                move.w  $26(a1),d0
                moveq   #0,d1
                move.b  subtype(a0),d1
                lea     word_4F28C(pc),a2
                move.w  (a2,d0.w),d2
                adda.w  d2,a2
                move.w  (a2,d1.w),child_dx(a0)          ; and child_dy
                lea     word_4F2C4(pc),a2
                move.w  (a2,d0.w),d2
                adda.w  d2,a2
                move.b  (a2,d1.w),d2
                or.b    d2,render_flags(a0)
                lea     word_4F25A(pc),a2
                move.w  (a2,d0.w),d2
                adda.w  d2,a2
                move.w  (a2,d1.w),$2E(a0)
                cmpi.b  #6,d0
                beq.s   loc_4F250
                add.w   d1,d1
                move.l  off_4F270(pc,d1.w),$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F250:
                move.l  #byte_4F430,$30(a0)
                rts
; ---------------------------------------------------------------------------
word_4F25A:
                dc.w    word_4F262-word_4F25A
                dc.w    word_4F264-word_4F25A
                dc.w    word_4F262-word_4F25A
                dc.w    word_4F268-word_4F25A
word_4F262:
                dc.w    $11
word_4F264:
                dc.w    $E
                dc.w    $B
word_4F268:
                dc.w    8
                dc.w    5
                dc.w    2
                dc.w    $FFFF
off_4F270:
                dc.l    byte_4F423
                dc.l    byte_4F423
                dc.l    byte_4F423
                dc.l    byte_4F423
                dc.l    byte_4F414
                dc.l    byte_4F414
                dc.l    byte_4F414
word_4F28C:
                dc.w    byte_4F294-word_4F28C
                dc.w    byte_4F2A2-word_4F28C
                dc.w    byte_4F2AE-word_4F28C
                dc.w    byte_4F2BC-word_4F28C
byte_4F294:
                dc.b    -$50, $14
                dc.b    -$40, $14
                dc.b    -$48,   4
                dc.b    -$40,   4
                dc.b    -$34,  $C
                dc.b    -$24,   8
                dc.b    -$1C,   4
byte_4F2A2:
                dc.b    8, $40
                dc.b    0, $3C
                dc.b    -$10, $40
                dc.b    -8, $3C
                dc.b    -4, $34
                dc.b    -4, $28
byte_4F2AE:
                dc.b    $50, $14
                dc.b    $40, $14
                dc.b    $48,   4
                dc.b    $40,   4
                dc.b    $34,  $C
                dc.b    $24,   8
                dc.b    $1C,   4
byte_4F2BC:
                dc.b    $18,  -4
                dc.b    $14,   0
                dc.b    $10,  -8
                dc.b    8,  -4
                even
word_4F2C4:
                dc.w    byte_4F2CC-word_4F2C4
                dc.w    byte_4F2DA-word_4F2C4
                dc.w    byte_4F2E6-word_4F2C4
                dc.w    byte_4F2D2-word_4F2C4
byte_4F2CC:
                dc.b    2,   0
                dc.b    2,   0
                dc.b    0,   0
byte_4F2D2:
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
byte_4F2DA:
                dc.b    1,   0
                dc.b    1,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
byte_4F2E6:
                dc.b    3,   0
                dc.b    3,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    1,   0
                even

; =============== S U B R O U T I N E =======================================

sub_4F2F4:
                tst.b   collision_flags(a0)
                bne.s   locret_4F35C
                move.b  collision_property(a0),d0
                beq.s   loc_4F35E
                tst.b   $20(a0)
                bne.s   loc_4F32A
                cmpi.b  #2,d0
                bne.s   loc_4F31C
                st      $3B(a0)
                move.b  #6,routine(a0)
                move.w  #$7F,$3C(a0)

loc_4F31C:
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_4F32A:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_4F33E
                addi.w  #2*2,d0

loc_4F33E:
                bsr.w   sub_4F382
                subq.b  #1,$20(a0)
                bne.s   locret_4F35C
                bclr    #6,status(a0)
                cmpi.b  #0,mapping_frame(a0)
                bne.s   locret_4F35C
                move.b  $25(a0),collision_flags(a0)

locret_4F35C:
                rts
; ---------------------------------------------------------------------------

loc_4F35E:
                move.l  #Wait_Draw,(a0)
                move.l  #loc_4EE74,$34(a0)
                movea.w (_unkFAAE).w,a1
                cmpi.l  #loc_58DF8,(a1)
                bne.s   loc_4F37E
                bset    #5,$38(a1)

loc_4F37E:
                jmp     BossDefeated_StopTimer(pc)
; End of function sub_4F2F4

; =============== S U B R O U T I N E =======================================

sub_4F382:
                lea     word_4F38E(pc),a1
                lea     word_4F392(pc,d0.w),a2
                jmp     CopyWordData_2(pc)
; End of function sub_4F382

; ---------------------------------------------------------------------------
word_4F38E:
                dc.w    Normal_palette_line_2+$14, Normal_palette_line_2+$1C
word_4F392:
                dc.w    $20,  $644
                dc.w    $EEE,  $AAA
ObjDat3_4F39A:
                dc.l    Map_ICZEndBoss
                dc.w    make_art_tile(ArtTile_ICZEndBoss,1,1)
                dc.w    $280
                dc.b    $24, $24,   0,  $F
word_4F3A6:
                dc.w    $200
                dc.b    $14,   8,   3,   0
word_4F3AC:
                dc.w    $280
                dc.b    8,  $C,   1,   0
word_4F3B2:
                dc.w    $280
                dc.b    $18, $2C,   2,   0
ObjDat3_4F3B8:
                dc.l    Map_ICZEndBoss
                dc.w    make_art_tile(ArtTile_ICZEndBoss,1,1)
                dc.w    $80
                dc.b    $10, $10,   5,   0
word_4F3C4:
                dc.w    $180
                dc.b    $14, $10,   0,   0
ChildObjDat_4F3CA:
                dc.w    1-1
                dc.l    Obj_RobotnikShip4
                dc.b    0,   0
ChildObjDat_4F3D2:
                dc.w    3-1
                dc.l    loc_4EF0A
                dc.b    $18,   7
                dc.l    loc_4EF70
                dc.b    0,  $B
                dc.l    loc_4F010
                dc.b    0, $2D
ChildObjDat_4F3E6:
                dc.w    6-1
                dc.l    loc_4F0CE
ChildObjDat_4F3EC:
                dc.w    7-1
                dc.l    loc_4F0CE
ChildObjDat_4F3F2:
                dc.w    4-1
                dc.l    loc_4F0CE
ChildObjDat_4F3F8:
                dc.w    1-1
                dc.l    loc_4F166
                dc.b    0,   8
ChildObjDat_4F400:
                dc.w    3-1
                dc.l    loc_4F190
                dc.b    -$14,   4
                dc.l    loc_4F190
                dc.b    $C,   4
                dc.l    loc_4F190
                dc.b    0, $1C
byte_4F414:
                dc.b    5,   1
                dc.b    5,   1
                dc.b    6,   1
                dc.b    7,   2
                dc.b    8,   3
                dc.b    9,   4
                dc.b    $A,   5
                dc.b    $F4
byte_4F423:
                dc.b    $B,   2
                dc.b    $B,   2
                dc.b    $C,   3
                dc.b    $D,   4
                dc.b    $E,   5
                dc.b    $F,   6
                dc.b    $F4
byte_4F430:
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
byte_4F464:
                dc.b    0,   2
                dc.b    4,   2
                dc.b    0,   2
                dc.b    4,   2
                dc.b    0,   2
                dc.b    0,   2
                dc.b    4,   2
                dc.b    2,   4
                even
