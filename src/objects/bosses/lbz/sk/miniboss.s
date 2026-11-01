; Owner: objects/bosses/lbz/sk
; Responsibility: Launch Base miniboss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZMiniboss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZMiniboss_Index(pc,d0.w),d1
                jsr     LBZMiniboss_Index(pc,d1.w)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
LBZMiniboss_Index:
                dc.w    loc_72400-LBZMiniboss_Index
                dc.w    loc_72452-LBZMiniboss_Index
                dc.w    loc_72474-LBZMiniboss_Index
                dc.w    loc_724BC-LBZMiniboss_Index
                dc.w    loc_724E2-LBZMiniboss_Index
                dc.w    loc_72558-LBZMiniboss_Index
; ---------------------------------------------------------------------------

loc_72400:
                lea     ObjDat_LBZMiniboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #6,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.w  x_pos(a0),$3C(a0)
                move.w  #$10,$2E(a0)
                move.l  #loc_72458,$34(a0)
                lea     Pal_LBZMiniboss(pc),a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_7296E(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_72976(pc),a2
                jsr     (CreateChild4_LinkListRepeated).l
                lea     ChildObjDat_7297C(pc),a2
                jmp     (CreateChild4_LinkListRepeated).l
; ---------------------------------------------------------------------------

loc_72452:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_72458:
                move.b  #4,routine(a0)
                move.w  #0,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_72480,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_72474:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_72480:
                move.b  #6,routine(a0)
                bset    #1,$38(a0)
                lea     (byte_72982).l,a1
                lea     (_unkFA82).w,a2
                moveq   #6-1,d6

loc_72498:
                move.b  (a1)+,(a2)+
                dbf     d6,loc_72498
                move.l  #_unkFA82,$30(a0)
                move.b  #$10,anim_frame_timer(a0)
                move.l  #loc_724C8,$34(a0)

loc_724B4:
                move.w  #$10,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_724BC:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_724C8:
                lea     (_unkFA82).w,a1
                subq.b  #1,(a1)
                cmpi.b  #2,(a1)
                bhi.s   loc_724B4
                move.b  #8,routine(a0)
                move.b  #6,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_724E2:
                lea     (Player_1).w,a1
                moveq   #0,d0
                moveq   #0,d1
                move.w  x_pos(a0),d2
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   loc_72502
                moveq   #$20,d4
                tst.b   subtype(a0)
                beq.s   loc_72500
                neg.w   d4

loc_72500:
                add.w   d4,d2

loc_72502:
                sub.w   x_pos(a1),d2
                bpl.s   loc_7250C
                neg.w   d2
                addq.w  #2,d0

loc_7250C:
                moveq   #0,d1
                move.w  y_pos(a0),d3
                move.w  y_pos(a1),d4
                subi.w  #$38,d4
                sub.w   d4,d3
                bpl.s   loc_72522
                neg.w   d3
                addq.w  #2,d1

loc_72522:
                move.w  word_72554(pc,d0.w),x_vel(a0)
                move.w  word_72554(pc,d1.w),y_vel(a0)
                cmpi.w  #4,d2
                bhi.s   loc_72538
                clr.w   x_vel(a0)

loc_72538:
                cmpi.w  #4,d3
                bhi.s   loc_72542
                clr.w   y_vel(a0)

loc_72542:
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                jmp     (loc_72840).l
; ---------------------------------------------------------------------------
word_72554:
                dc.w    -$100,  $100
; ---------------------------------------------------------------------------

loc_72558:
                subq.w  #2,y_pos(a0)
                jmp     (loc_72840).l
; ---------------------------------------------------------------------------

loc_72562:
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_72584
                jsr     (AllocateObject).l
                bne.s   loc_72578
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

loc_72578:
                move.w  $3C(a0),x_pos(a0)
                jmp     (Obj_EndSignControl).l
; ---------------------------------------------------------------------------

loc_72584:
                movea.w parent3(a0),a1
                move.b  subtype(a0),d0
                bset    d0,$38(a1)
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_72596:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_725B0(pc,d0.w),d1
                jsr     off_725B0(pc,d1.w)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
off_725B0:
                dc.w    loc_725B6-off_725B0
                dc.w    loc_725CA-off_725B0
                dc.w    loc_725E8-off_725B0
; ---------------------------------------------------------------------------

loc_725B6:
                lea     word_72962(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #byte_72988,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_725CA:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_725D8
                rts
; ---------------------------------------------------------------------------

loc_725D8:
                move.b  #4,routine(a0)
                move.l  #byte_72988,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_725E8:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_725EE:
                bset    #2,$38(a0)

loc_725F4:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_72610(pc,d0.w),d1
                jsr     off_72610(pc,d1.w)
                tst.b   subtype(a0)
                bne.s   loc_7260C
                jmp     loc_728C8(pc)
; ---------------------------------------------------------------------------

loc_7260C:
                jmp     loc_72902(pc)
; ---------------------------------------------------------------------------
off_72610:
                dc.w    loc_7261C-off_72610
                dc.w    loc_72658-off_72610
                dc.w    loc_72688-off_72610
                dc.w    loc_726E4-off_72610
                dc.w    loc_7270E-off_72610
                dc.w    loc_7278E-off_72610
; ---------------------------------------------------------------------------

loc_7261C:
                lea     word_72968(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.w  #$100,$2E(a0)
                move.l  #loc_72674,$34(a0)
                move.b  #4,$3D(a0)
                move.w  #5,$3E(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   loc_72654
                move.w  #4,$3E(a0)
                bset    #1,$38(a0)

loc_72654:
                bra.w   loc_727B0
; ---------------------------------------------------------------------------

loc_72658:
                tst.b   subtype(a0)
                bne.s   loc_72664
                jsr     (Refresh_ChildPositionAdjusted).l

loc_72664:
                move.w  $3E(a0),d2
                jsr     (MoveSprite_CircularSimple).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_72674:
                move.b  #4,routine(a0)
                bsr.w   SetLBZMinibossArmActivationDelay
                move.l  #loc_726B2,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_72688:
                btst    #1,$38(a0)
                beq.s   loc_726A8
                move.b  $3D(a0),d0
                add.b   d0,$3C(a0)
                move.w  $3E(a0),d2
                jsr     (MoveSprite_CircularSimple).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_726A8:
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

loc_726B2:
                bsr.w   SetLBZMinibossArmRotationDelay
                move.l  #loc_72726,$34(a0)
                tst.b   subtype(a0)
                beq.s   loc_726DC
                move.b  #6,routine(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)
                move.b  $3C(a1),$3C(a0)
                rts
; ---------------------------------------------------------------------------

loc_726DC:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_726E4:
                movea.w parent3(a0),a1
                move.b  $3C(a1),$3C(a0)
                move.w  $3E(a0),d2
                jsr     (MoveSprite_CircularSimple).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_72706
                rts
; ---------------------------------------------------------------------------

loc_72706:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_7270E:
                move.b  $3D(a0),d0
                add.b   d0,$3C(a0)
                jsr     (Obj_Wait).l
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

loc_72726:
                bclr    #1,$38(a0)
                neg.b   $3D(a0)
                bsr.w   loc_72674
                cmpi.b  #$A,subtype(a0)
                bne.s   loc_72756
                move.b  #$A,routine(a0)
                move.w  #$3C,$2E(a0)
                move.l  #loc_72674,$34(a0)
                bset    #1,$38(a0)

loc_72756:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                moveq   #0,d1
                btst    #2,$38(a0)
                beq.s   loc_7276A
                addq.w  #8,d1

loc_7276A:
                tst.b   $3D(a0)
                bpl.s   loc_72772
                addq.w  #4,d1

loc_72772:
                movea.l off_7277E(pc,d1.w),a1
                move.b  (a1,d0.w),$3C(a0)
                rts
; ---------------------------------------------------------------------------
off_7277E:
                dc.l    byte_727F4
                dc.l    byte_727FA
                dc.l    byte_72800
                dc.l    byte_72806
; ---------------------------------------------------------------------------

loc_7278E:
                move.w  $3E(a0),d2
                jsr     (MoveSprite_CircularSimple).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7279E:
                jsr     (MoveSprite).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_727B0:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_727E2(pc,d0.w),priority(a0)
                lsr.w   #1,d0
                move.b  byte_727EE(pc,d0.w),mapping_frame(a0)
                move.b  byte_727F4(pc,d0.w),$3C(a0)
                btst    #2,$38(a0)
                beq.s   loc_727D8
                move.b  byte_72800(pc,d0.w),$3C(a0)

loc_727D8:
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------
word_727E2:
                dc.w    $300,  $380,  $300,  $380,  $300,  $280
byte_727EE:
                dc.b    7,   8,   7,   8,   7,   6
byte_727F4:
                dc.b    $55,   0, $D5, $AA, $80, $68
byte_727FA:
                dc.b    $2A, $7A, $B0, $DA,   0, $18
byte_72800:
                dc.b    $D5, $80, $55, $2A,   0, $F4
byte_72806:
                dc.b    $AA,   0, $2A, $55, $80, $8C
                even

; =============== S U B R O U T I N E =======================================

SetLBZMinibossArmActivationDelay:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_7281A(pc,d0.w),$2E(a0)
                rts
; End of function SetLBZMinibossArmActivationDelay

; ---------------------------------------------------------------------------
word_7281A:
                dc.w    0
                dc.w    $14
                dc.w    9
                dc.w    9
                dc.w    9
                dc.w    5

; =============== S U B R O U T I N E =======================================

SetLBZMinibossArmRotationDelay:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_72834(pc,d0.w),$2E(a0)
                rts
; End of function SetLBZMinibossArmRotationDelay

; ---------------------------------------------------------------------------
word_72834:
                dc.w    $34
                dc.w    $14
                dc.w    9
                dc.w    9
                dc.w    9
                dc.w    3
; ---------------------------------------------------------------------------

loc_72840:
                tst.b   collision_flags(a0)
                bne.s   locret_72898
                tst.b   collision_property(a0)
                beq.s   loc_7289A
                cmpi.b  #3,collision_property(a0)
                bne.s   loc_7285A
                bset    #0,$38(a0)

loc_7285A:
                tst.b   $20(a0)
                bne.s   loc_7287A
                move.b  routine(a0),$3A(a0)
                move.b  #$A,routine(a0)
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_7287A:
                jsr     (BossFlash).l
                subq.b  #1,$20(a0)
                bne.s   locret_72898
                move.b  $3A(a0),routine(a0)
                move.w  #$EEE,(Normal_palette_line_2+$2).w
                move.b  $25(a0),collision_flags(a0)

locret_72898:
                rts
; ---------------------------------------------------------------------------

loc_7289A:
                move.l  #Wait_NewDelay,(a0)
                move.l  #loc_72562,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_728C2
                jmp     (BossDefeated_StopTimer).l
; ---------------------------------------------------------------------------

loc_728C2:
                jmp     (BossDefeated).l
; ---------------------------------------------------------------------------

loc_728C8:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_728EA
                btst    #0,$38(a1)
                beq.s   loc_728E4
                btst    #2,$38(a0)
                bne.s   loc_728EA

loc_728E4:
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_728EA:
                move.w  $44(a0),d0
                beq.s   loc_728F8
                movea.w d0,a1
                bset    #7,status(a1)

loc_728F8:
                bsr.w   DetachLBZMinibossArmSegmentWithGravity
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_72902:
                btst    #7,status(a0)
                bne.s   loc_728EA
                jmp     (Draw_And_Touch_Sprite).l

; =============== S U B R O U T I N E =======================================

DetachLBZMinibossArmSegmentWithGravity:
                move.l  #loc_7279E,(a0)
                clr.b   collision_flags(a0)
                move.w  #$80,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     word_7293E(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; End of function DetachLBZMinibossArmSegmentWithGravity

; ---------------------------------------------------------------------------
word_7293E:
                dc.w    $100, -$100
                dc.w    -$200, -$200
                dc.w    $300, -$200
                dc.w    $200, -$100
                dc.w    -$100, -$200
                dc.w    -$80, -$100
ObjDat_LBZMiniboss:
                dc.l    Map_LBZMiniboss
                dc.w    make_art_tile(ArtTile_LBZMiniboss,1,1)
                dc.w    $280
                dc.b    $20, $20,   0,   0
word_72962:
                dc.w    $200
                dc.b    $20, $20,   3,   0
word_72968:
                dc.w    $180
                dc.b    8,   8,   6, $98
ChildObjDat_7296E:
                dc.w    1-1
                dc.l    loc_72596
                dc.b    0,   0
ChildObjDat_72976:
                dc.w    6-1
                dc.l    loc_725F4
ChildObjDat_7297C:
                dc.w    6-1
                dc.l    loc_725EE
byte_72982:
                dc.b    $F,   0,   1,   0,   2, $FC
byte_72988:
                dc.b    7,   3,   4,   5
                dc.b    $F8, .jump-byte_72988

                .jump:
                dc.b    $3F,   5,   5,   5
                dc.b    $F8, .jump2-.jump

                .jump2:
                dc.b    7,   5,   4,   3,   4, $FC
Pal_LBZMiniboss:
                binclude "data/Levels/LBZ/Palettes/Miniboss.bin"
                even
