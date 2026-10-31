; Owner: objects/enemies/lbz/sk
; Responsibility: Ribot enemy and spawned actors with private movement and construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Ribot:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Ribot_Index(pc,d0.w),d1
                jsr     Ribot_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Ribot_Index:
                dc.w    loc_8C2FE-Ribot_Index
                dc.w    loc_8C34E-Ribot_Index
; ---------------------------------------------------------------------------

loc_8C2FE:
                lea     ObjDat_Ribot(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #2,$38(a0)
                move.b  subtype(a0),d0
                subq.b  #2,d0
                beq.s   loc_8C32A
                bpl.s   loc_8C33C
                move.l  #byte_8C626,$30(a0)
                lea     ChildObjDat_8C5E2(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_8C32A:
                move.l  #byte_8C626,$30(a0)
                lea     ChildObjDat_8C5F0(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_8C33C:
                move.l  #byte_8C62C,$30(a0)
                lea     ChildObjDat_8C5FE(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_8C34E:
                bclr    #2,$38(a0)
                beq.s   loc_8C36C
                andi.b  #$FC,$38(a0)
                moveq   #0,d0
                bchg    #3,$38(a0)
                beq.s   loc_8C368
                moveq   #1,d0

loc_8C368:
                bset    d0,$38(a0)

loc_8C36C:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_8C370:
                moveq   #0,d2
                movea.w parent3(a0),a1
                move.b  subtype(a1),d2
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_8C38C(pc,d0.w),d1
                jsr     off_8C38C(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
off_8C38C:
                dc.w    loc_8C396-off_8C38C
                dc.w    loc_8C3BC-off_8C38C
                dc.w    loc_8C428-off_8C38C
                dc.w    loc_8C48E-off_8C38C
                dc.w    loc_8C4BA-off_8C38C
; ---------------------------------------------------------------------------

loc_8C396:
                lea     word_8C5D6(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #8,y_radius(a0)
                move.b  #-$10,child_dy(a0)
                move.w  x_pos(a0),$3E(a0)
                move.w  y_pos(a0),$40(a0)
                bra.w   loc_8C594
; ---------------------------------------------------------------------------

loc_8C3BC:
                move.w  off_8C3C4(pc,d2.w),d3
                jmp     off_8C3C4(pc,d3.w)
; ---------------------------------------------------------------------------
off_8C3C4:
                dc.w    loc_8C3CA-off_8C3C4
                dc.w    loc_8C3EC-off_8C3C4
                dc.w    loc_8C41E-off_8C3C4
; ---------------------------------------------------------------------------

loc_8C3CA:
                moveq   #0,d0
                tst.b   subtype(a0)
                bne.s   loc_8C3D4
                moveq   #1,d0

loc_8C3D4:
                btst    d0,$38(a1)
                bne.s   loc_8C3DC
                rts
; ---------------------------------------------------------------------------

loc_8C3DC:
                move.b  #4,routine(a0)
                move.l  #loc_8C456,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8C3EC:
                moveq   #0,d0
                move.w  #$400,d1
                tst.b   subtype(a0)
                bne.s   loc_8C3FC
                moveq   #1,d0
                neg.w   d1

loc_8C3FC:
                btst    d0,$38(a1)
                bne.s   loc_8C404
                rts
; ---------------------------------------------------------------------------

loc_8C404:
                move.b  #4,routine(a0)
                move.w  d1,x_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_8C46A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8C41E:
                addq.b  #2,$3C(a0)
                moveq   #2,d2
                jmp     MoveSprite_CircularSimpleOffset(pc)
; ---------------------------------------------------------------------------

loc_8C428:
                move.w  off_8C430(pc,d2.w),d3
                jmp     off_8C430(pc,d3.w)
; ---------------------------------------------------------------------------
off_8C430:
                dc.w    loc_8C436-off_8C430
                dc.w    loc_8C484-off_8C430
                dc.w    loc_8C436-off_8C430
; ---------------------------------------------------------------------------

loc_8C436:
                move.w  y_pos(a0),d0
                sub.w   $40(a0),d0
                cmpi.w  #$80,d0
                bhs.s   loc_8C46A
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   locret_8C482
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_8C456:
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                blo.s   loc_8C46A
                asr.w   #2,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_8C46A:
                move.b  #6,routine(a0)
                move.w  #$10,$2E(a0)
                move.l  #loc_8C4A0,$34(a0)
                clr.w   y_vel(a0)

locret_8C482:
                rts
; ---------------------------------------------------------------------------

loc_8C484:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_8C48E:
                move.w  off_8C496(pc,d2.w),d3
                jmp     off_8C496(pc,d3.w)
; ---------------------------------------------------------------------------
off_8C496:
                dc.w    loc_8C49C-off_8C496
                dc.w    loc_8C49C-off_8C496
                dc.w    loc_8C49C-off_8C496
; ---------------------------------------------------------------------------

loc_8C49C:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_8C4A0:
                move.b  #8,routine(a0)
                neg.w   x_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_8C4DA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8C4BA:
                move.w  off_8C4C2(pc,d2.w),d3
                jmp     off_8C4C2(pc,d3.w)
; ---------------------------------------------------------------------------
off_8C4C2:
                dc.w    loc_8C4C8-off_8C4C2
                dc.w    loc_8C4F8-off_8C4C2
                dc.w    loc_8C4C8-off_8C4C2
; ---------------------------------------------------------------------------

loc_8C4C8:
                move.w  y_pos(a0),d0
                subq.w  #2,d0
                cmp.w   $40(a0),d0
                bls.s   loc_8C4DA
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_8C4DA:
                move.b  #2,routine(a0)
                move.w  $3E(a0),x_pos(a0)
                move.w  $40(a0),y_pos(a0)
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_8C4F8:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_8C502:
                lea     word_8C5DC(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_8C522,(a0)
                move.w  x_pos(a0),$3E(a0)
                move.w  y_pos(a0),$40(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_8C522:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                sub.w   $3E(a0),d2
                sub.w   $40(a0),d3
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  off_8C548(pc,d0.w),d1
                jsr     off_8C548(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_8C548:
                dc.w    loc_8C54E-off_8C548
                dc.w    loc_8C568-off_8C548
                dc.w    loc_8C57E-off_8C548
; ---------------------------------------------------------------------------

loc_8C54E:
                asr.w   #2,d2
                neg.w   d2
                add.w   x_pos(a1),d2
                move.w  d2,x_pos(a0)
                asr.w   #2,d3
                neg.w   d3
                add.w   y_pos(a1),d3
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_8C568:
                asr.w   #1,d2
                add.w   $3E(a0),d2
                move.w  d2,x_pos(a0)
                asr.w   #1,d3
                add.w   $40(a0),d3
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_8C57E:
                asr.w   #2,d2
                add.w   $3E(a0),d2
                move.w  d2,x_pos(a0)
                asr.w   #2,d3
                add.w   $40(a0),d3
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_8C594:
                movea.w parent3(a0),a1
                move.b  subtype(a1),d0
                subq.b  #2,d0
                beq.s   loc_8C5AC
                bpl.s   loc_8C5C0
                lea     ChildObjDat_8C606(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_8C5AC:
                lea     ChildObjDat_8C60E(pc),a2
                tst.b   subtype(a0)
                beq.s   loc_8C5BA
                lea     ChildObjDat_8C616(pc),a2

loc_8C5BA:
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_8C5C0:
                lea     ChildObjDat_8C61E(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------
ObjDat_Ribot:
                dc.l    Map_Ribot
                dc.w    make_art_tile(ArtTile_Ribot,1,0)
                dc.w    $280
                dc.b    $10,  $C,   0,  $B
word_8C5D6:
                dc.w    $200
                dc.b    8,   8,   7, $97
word_8C5DC:
                dc.w    $200
                dc.b    4,   4,   6,   0
ChildObjDat_8C5E2:
                dc.w    2-1
                dc.l    loc_8C370
                dc.b    -$C,  $C
                dc.l    loc_8C370
                dc.b    $C,  $C
ChildObjDat_8C5F0:
                dc.w    2-1
                dc.l    loc_8C370
                dc.b    -$18,   0
                dc.l    loc_8C370
                dc.b    $18,   0
ChildObjDat_8C5FE:
                dc.w    1-1
                dc.l    loc_8C370
                dc.b    0,-$10
ChildObjDat_8C606:
                dc.w    3-1
                dc.l    loc_8C502
                dc.b    0, -$C
ChildObjDat_8C60E:
                dc.w    3-1
                dc.l    loc_8C502
                dc.b    $C,   0
ChildObjDat_8C616:
                dc.w    3-1
                dc.l    loc_8C502
                dc.b    -$C,   0
ChildObjDat_8C61E:
                dc.w    3-1
                dc.l    loc_8C502
                dc.b    0,   0
byte_8C626:
                dc.b    7,   0,   1,   2,   1, $FC
byte_8C62C:
                dc.b    7,   3,   4,   5,   4, $FC
                even
