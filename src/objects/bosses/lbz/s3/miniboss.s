; Owner: objects/bosses/lbz/s3
; Responsibility: Launch Base miniboss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZMiniboss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZMiniboss_Index(pc,d0.w),d1
                jsr     LBZMiniboss_Index(pc,d1.w)
                bsr.w   sub_4F84C
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
LBZMiniboss_Index:
                dc.w    loc_4F496-LBZMiniboss_Index
                dc.w    loc_4F4D8-LBZMiniboss_Index
                dc.w    loc_4F4F8-LBZMiniboss_Index
                dc.w    loc_4F53E-LBZMiniboss_Index
                dc.w    loc_4F55A-LBZMiniboss_Index
                dc.w    loc_4F5B4-LBZMiniboss_Index
; ---------------------------------------------------------------------------

loc_4F496:
                lea     ObjDat_LBZMiniboss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.w  #$10,$2E(a0)
                move.l  #loc_4F4DC,$34(a0)
                lea     Pal_LBZMiniboss(pc),a1
                jsr     PalLoad_Line1(pc)
                lea     ChildObjDat_4F960(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_4F968(pc),a2
                jsr     CreateChild4_LinkListRepeated(pc)
                lea     ChildObjDat_4F96E(pc),a2
                jmp     CreateChild4_LinkListRepeated(pc)
; ---------------------------------------------------------------------------

loc_4F4D8:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4F4DC:
                move.b  #4,routine(a0)
                move.w  #0,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4F502,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F4F8:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4F502:
                move.b  #6,routine(a0)
                bset    #1,$38(a0)
                lea     (byte_4F974).l,a1
                lea     (_unkFA82).w,a2
                moveq   #6-1,d6

loc_4F51A:
                move.b  (a1)+,(a2)+
                dbf     d6,loc_4F51A
                move.l  #_unkFA82,$30(a0)
                move.b  #$10,anim_frame_timer(a0)
                move.l  #loc_4F546,$34(a0)

loc_4F536:
                move.w  #$10,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F53E:
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4F546:
                lea     (_unkFA82).w,a1
                subq.b  #1,(a1)
                cmpi.b  #2,(a1)
                bhi.s   loc_4F536
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F55A:
                lea     (Player_1).w,a1
                moveq   #0,d0
                moveq   #0,d1
                move.w  x_pos(a0),d2
                sub.w   x_pos(a1),d2
                bpl.s   loc_4F570
                neg.w   d2
                addq.w  #2,d0

loc_4F570:
                moveq   #0,d1
                move.w  y_pos(a0),d3
                move.w  y_pos(a1),d4
                subi.w  #$38,d4
                sub.w   d4,d3
                bpl.s   loc_4F586
                neg.w   d3
                addq.w  #2,d1

loc_4F586:
                move.w  word_4F5B0(pc,d0.w),x_vel(a0)
                move.w  word_4F5B0(pc,d1.w),y_vel(a0)
                cmpi.w  #4,d2
                bhi.s   loc_4F59C
                clr.w   x_vel(a0)

loc_4F59C:
                cmpi.w  #4,d3
                bhi.s   loc_4F5A6
                clr.w   y_vel(a0)

loc_4F5A6:
                jsr     (MoveSprite2).l
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------
word_4F5B0:
                dc.w    -$100,  $100
; ---------------------------------------------------------------------------

loc_4F5B4:
                subq.w  #2,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F5BA:
                jmp     (Obj_EndSignControl).l
; ---------------------------------------------------------------------------

loc_4F5C0:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4F5D6(pc,d0.w),d1
                jsr     off_4F5D6(pc,d1.w)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------
off_4F5D6:
                dc.w    loc_4F5DC-off_4F5D6
                dc.w    loc_4F5EE-off_4F5D6
                dc.w    loc_4F60C-off_4F5D6
; ---------------------------------------------------------------------------

loc_4F5DC:
                lea     word_4F954(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #byte_4F97A,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F5EE:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_4F5FC
                rts
; ---------------------------------------------------------------------------

loc_4F5FC:
                move.b  #4,routine(a0)
                move.l  #byte_4F97A,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F60C:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_4F610:
                bset    #2,$38(a0)

loc_4F616:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4F632(pc,d0.w),d1
                jsr     off_4F632(pc,d1.w)
                tst.b   subtype(a0)
                bne.s   loc_4F62E
                jmp     loc_4F8C0(pc)
; ---------------------------------------------------------------------------

loc_4F62E:
                jmp     loc_4F8F6(pc)
; ---------------------------------------------------------------------------
off_4F632:
                dc.w    loc_4F63E-off_4F632
                dc.w    loc_4F678-off_4F632
                dc.w    loc_4F6A2-off_4F632
                dc.w    loc_4F6FC-off_4F632
                dc.w    loc_4F726-off_4F632
                dc.w    loc_4F7A2-off_4F632
; ---------------------------------------------------------------------------

loc_4F63E:
                lea     word_4F95A(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.w  #$100,$2E(a0)
                move.l  #loc_4F68E,$34(a0)
                move.b  #4,$3D(a0)
                move.w  #5,$3E(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   loc_4F674
                move.w  #4,$3E(a0)
                bset    #1,$38(a0)

loc_4F674:
                bra.w   loc_4F7BE
; ---------------------------------------------------------------------------

loc_4F678:
                tst.b   subtype(a0)
                bne.s   loc_4F682
                jsr     Refresh_ChildPositionAdjusted(pc)

loc_4F682:
                move.w  $3E(a0),d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4F68E:
                move.b  #4,routine(a0)
                bsr.w   sub_4F818
                move.l  #loc_4F6CA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F6A2:
                btst    #1,$38(a0)
                beq.s   loc_4F6C0
                move.b  $3D(a0),d0
                add.b   d0,$3C(a0)
                move.w  $3E(a0),d2
                jsr     (MoveSprite_CircularSimple).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4F6C0:
                move.w  $3E(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

loc_4F6CA:
                bsr.w   sub_4F832
                move.l  #loc_4F73A,$34(a0)
                tst.b   subtype(a0)
                beq.s   loc_4F6F4
                move.b  #6,routine(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)
                move.b  $3C(a1),$3C(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F6F4:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F6FC:
                movea.w parent3(a0),a1
                move.b  $3C(a1),$3C(a0)
                move.w  $3E(a0),d2
                jsr     (MoveSprite_CircularSimple).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_4F71E
                rts
; ---------------------------------------------------------------------------

loc_4F71E:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4F726:
                move.b  $3D(a0),d0
                add.b   d0,$3C(a0)
                jsr     Obj_Wait(pc)
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

loc_4F73A:
                bclr    #1,$38(a0)
                neg.b   $3D(a0)
                bsr.w   loc_4F68E
                cmpi.b  #$A,subtype(a0)
                bne.s   loc_4F76A
                move.b  #$A,routine(a0)
                move.w  #$3C,$2E(a0)
                move.l  #loc_4F68E,$34(a0)
                bset    #1,$38(a0)

loc_4F76A:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                moveq   #0,d1
                btst    #2,$38(a0)
                beq.s   loc_4F77E
                addq.w  #8,d1

loc_4F77E:
                tst.b   $3D(a0)
                bpl.s   loc_4F786
                addq.w  #4,d1

loc_4F786:
                movea.l off_4F792(pc,d1.w),a1
                move.b  (a1,d0.w),$3C(a0)
                rts
; ---------------------------------------------------------------------------
off_4F792:
                dc.l    byte_4F800
                dc.l    byte_4F806
                dc.l    byte_4F80C
                dc.l    byte_4F812
; ---------------------------------------------------------------------------

loc_4F7A2:
                move.w  $3E(a0),d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4F7AE:
                jsr     (MoveSprite).l
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4F7BE:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_4F7EE(pc,d0.w),priority(a0)
                lsr.w   #1,d0
                move.b  byte_4F7FA(pc,d0.w),mapping_frame(a0)
                move.b  byte_4F800(pc,d0.w),$3C(a0)
                btst    #2,$38(a0)
                beq.s   loc_4F7E6
                move.b  byte_4F80C(pc,d0.w),$3C(a0)

loc_4F7E6:
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------
word_4F7EE:
                dc.w    $300,  $380,  $300,  $380,  $300,  $280
byte_4F7FA:
                dc.b    7,   8,   7,   8,   7,   6
byte_4F800:
                dc.b    $55,   0, $D5, $AA, $80, $68
byte_4F806:
                dc.b    $2A, $7A, $B0, $DA,   0, $18
byte_4F80C:
                dc.b    $D5, $80, $55, $2A,   0, $F4
byte_4F812:
                dc.b    $AA,   0, $2A, $55, $80, $8C
                even

; =============== S U B R O U T I N E =======================================

sub_4F818:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_4F826(pc,d0.w),$2E(a0)
                rts
; End of function sub_4F818

; ---------------------------------------------------------------------------
word_4F826:
                dc.w    0
                dc.w    $14
                dc.w    9
                dc.w    9
                dc.w    9
                dc.w    5

; =============== S U B R O U T I N E =======================================

sub_4F832:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_4F840(pc,d0.w),$2E(a0)
                rts
; End of function sub_4F832

; ---------------------------------------------------------------------------
word_4F840:
                dc.w    $34
                dc.w    $14
                dc.w    9
                dc.w    9
                dc.w    9
                dc.w    3
; ---------------------------------------------------------------------------

sub_4F84C:
                tst.b   collision_flags(a0)
                bne.s   locret_4F8A2
                tst.b   collision_property(a0)
                beq.s   loc_4F8A4
                cmpi.b  #3,collision_property(a0)
                bne.s   loc_4F866
                bset    #0,$38(a0)

loc_4F866:
                tst.b   $20(a0)
                bne.s   loc_4F886
                move.b  routine(a0),$3A(a0)
                move.b  #$A,routine(a0)
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_4F886:
                jsr     BossFlash(pc)
                subq.b  #1,$20(a0)
                bne.s   locret_4F8A2
                move.b  $3A(a0),routine(a0)
                move.w  #$EEE,(Normal_palette_line_2+$2).w
                move.b  $25(a0),collision_flags(a0)

locret_4F8A2:
                rts
; ---------------------------------------------------------------------------

loc_4F8A4:
                move.l  #Wait_Draw,(a0)
                move.l  #loc_4F5BA,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     BossDefeated_StopTimer(pc)
; ---------------------------------------------------------------------------

loc_4F8C0:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_4F8E0
                btst    #0,$38(a1)
                beq.s   loc_4F8DC
                btst    #2,$38(a0)
                bne.s   loc_4F8E0

loc_4F8DC:
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_4F8E0:
                move.w  $44(a0),d0
                beq.s   loc_4F8EE
                movea.w d0,a1
                bset    #7,status(a1)

loc_4F8EE:
                bsr.w   sub_4F902
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_4F8F6:
                btst    #7,status(a0)
                bne.s   loc_4F8E0
                jmp     Draw_And_Touch_Sprite(pc)

; =============== S U B R O U T I N E =======================================

sub_4F902:
                move.l  #loc_4F7AE,(a0)
                clr.b   collision_flags(a0)
                move.w  #$80,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     word_4F930(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; End of function sub_4F902

; ---------------------------------------------------------------------------
word_4F930:
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
                dc.b    $20, $20,   0,   6
word_4F954:
                dc.w    $200
                dc.b    $20, $20,   3,   0
word_4F95A:
                dc.w    $180
                dc.b    8,   8,   6, $98
ChildObjDat_4F960:
                dc.w    1-1
                dc.l    loc_4F5C0
                dc.b    0,   0
ChildObjDat_4F968:
                dc.w    6-1
                dc.l    loc_4F616
ChildObjDat_4F96E:
                dc.w    6-1
                dc.l    loc_4F610
byte_4F974:
                dc.b    $F,   0,   1,   0,   2, $FC
byte_4F97A:
                dc.b    7,   3,   4,   5
                dc.b    $F8, .jump-byte_4F97A

                .jump:
                dc.b    $3F,   5,   5,   5
                dc.b    $F8, .jump2-.jump

                .jump2:
                dc.b    7,   5,   4,   3,   4, $FC
Pal_LBZMiniboss:
                binclude "data/Levels/LBZ/Palettes/Miniboss.bin"
                even
