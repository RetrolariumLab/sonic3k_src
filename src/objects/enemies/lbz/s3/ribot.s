; Owner: objects/enemies/lbz/s3
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
                dc.w    loc_59A90-Ribot_Index
                dc.w    loc_59AD8-Ribot_Index
; ---------------------------------------------------------------------------

loc_59A90:
                lea     ObjDat_Ribot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bset    #2,$38(a0)
                move.b  subtype(a0),d0
                subq.b  #2,d0
                beq.s   loc_59AB8
                bpl.s   loc_59AC8
                move.l  #byte_59DA6,$30(a0)
                lea     ChildObjDat_59D62(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_59AB8:
                move.l  #byte_59DA6,$30(a0)
                lea     ChildObjDat_59D70(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_59AC8:
                move.l  #byte_59DAC,$30(a0)
                lea     ChildObjDat_59D7E(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_59AD8:
                bclr    #2,$38(a0)
                beq.s   loc_59AF6
                andi.b  #$FC,$38(a0)
                moveq   #0,d0
                bchg    #3,$38(a0)
                beq.s   loc_59AF2
                moveq   #1,d0

loc_59AF2:
                bset    d0,$38(a0)

loc_59AF6:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_59AFA:
                moveq   #0,d2
                movea.w parent3(a0),a1
                move.b  subtype(a1),d2
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_59B16(pc,d0.w),d1
                jsr     off_59B16(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
off_59B16:
                dc.w    loc_59B20-off_59B16
                dc.w    loc_59B44-off_59B16
                dc.w    loc_59BB0-off_59B16
                dc.w    loc_59C16-off_59B16
                dc.w    loc_59C42-off_59B16
; ---------------------------------------------------------------------------

loc_59B20:
                lea     word_59D56(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.b  #8,y_radius(a0)
                move.b  #-$10,child_dy(a0)
                move.w  x_pos(a0),$3E(a0)
                move.w  y_pos(a0),$40(a0)
                bra.w   loc_59D1A
; ---------------------------------------------------------------------------

loc_59B44:
                move.w  off_59B4C(pc,d2.w),d3
                jmp     off_59B4C(pc,d3.w)
; ---------------------------------------------------------------------------
off_59B4C:
                dc.w    loc_59B52-off_59B4C
                dc.w    loc_59B74-off_59B4C
                dc.w    loc_59BA6-off_59B4C
; ---------------------------------------------------------------------------

loc_59B52:
                moveq   #0,d0
                tst.b   subtype(a0)
                bne.s   loc_59B5C
                moveq   #1,d0

loc_59B5C:
                btst    d0,$38(a1)
                bne.s   loc_59B64
                rts
; ---------------------------------------------------------------------------

loc_59B64:
                move.b  #4,routine(a0)
                move.l  #loc_59BDE,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_59B74:
                moveq   #0,d0
                move.w  #$400,d1
                tst.b   subtype(a0)
                bne.s   loc_59B84
                moveq   #1,d0
                neg.w   d1

loc_59B84:
                btst    d0,$38(a1)
                bne.s   loc_59B8C
                rts
; ---------------------------------------------------------------------------

loc_59B8C:
                move.b  #4,routine(a0)
                move.w  d1,x_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_59BF2,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_59BA6:
                addq.b  #2,$3C(a0)
                moveq   #2,d2
                jmp     MoveSprite_CircularSimpleOffset(pc)
; ---------------------------------------------------------------------------

loc_59BB0:
                move.w  off_59BB8(pc,d2.w),d3
                jmp     off_59BB8(pc,d3.w)
; ---------------------------------------------------------------------------
off_59BB8:
                dc.w    loc_59BBE-off_59BB8
                dc.w    loc_59C0C-off_59BB8
                dc.w    loc_59BBE-off_59BB8
; ---------------------------------------------------------------------------

loc_59BBE:
                move.w  y_pos(a0),d0
                sub.w   $40(a0),d0
                cmpi.w  #$80,d0
                bhs.s   loc_59BF2
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   locret_59C0A
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_59BDE:
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                blo.s   loc_59BF2
                asr.w   #2,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_59BF2:
                move.b  #6,routine(a0)
                move.w  #$10,$2E(a0)
                move.l  #loc_59C28,$34(a0)
                clr.w   y_vel(a0)

locret_59C0A:
                rts
; ---------------------------------------------------------------------------

loc_59C0C:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_59C16:
                move.w  off_59C1E(pc,d2.w),d3
                jmp     off_59C1E(pc,d3.w)
; ---------------------------------------------------------------------------
off_59C1E:
                dc.w    loc_59C24-off_59C1E
                dc.w    loc_59C24-off_59C1E
                dc.w    loc_59C24-off_59C1E
; ---------------------------------------------------------------------------

loc_59C24:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_59C28:
                move.b  #8,routine(a0)
                neg.w   x_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_59C62,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_59C42:
                move.w  off_59C4A(pc,d2.w),d3
                jmp     off_59C4A(pc,d3.w)
; ---------------------------------------------------------------------------
off_59C4A:
                dc.w    loc_59C50-off_59C4A
                dc.w    loc_59C80-off_59C4A
                dc.w    loc_59C50-off_59C4A
; ---------------------------------------------------------------------------

loc_59C50:
                move.w  y_pos(a0),d0
                subq.w  #2,d0
                cmp.w   $40(a0),d0
                bls.s   loc_59C62
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_59C62:
                move.b  #2,routine(a0)
                move.w  $3E(a0),x_pos(a0)
                move.w  $40(a0),y_pos(a0)
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_59C80:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_59C8A:
                lea     word_59D5C(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_59CA8,(a0)
                move.w  x_pos(a0),$3E(a0)
                move.w  y_pos(a0),$40(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_59CA8:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                sub.w   $3E(a0),d2
                sub.w   $40(a0),d3
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  off_59CCE(pc,d0.w),d1
                jsr     off_59CCE(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_59CCE:
                dc.w    loc_59CD4-off_59CCE
                dc.w    loc_59CEE-off_59CCE
                dc.w    loc_59D04-off_59CCE
; ---------------------------------------------------------------------------

loc_59CD4:
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

loc_59CEE:
                asr.w   #1,d2
                add.w   $3E(a0),d2
                move.w  d2,x_pos(a0)
                asr.w   #1,d3
                add.w   $40(a0),d3
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_59D04:
                asr.w   #2,d2
                add.w   $3E(a0),d2
                move.w  d2,x_pos(a0)
                asr.w   #2,d3
                add.w   $40(a0),d3
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_59D1A:
                movea.w parent3(a0),a1
                move.b  subtype(a1),d0
                subq.b  #2,d0
                beq.s   loc_59D30
                bpl.s   loc_59D42
                lea     ChildObjDat_59D86(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

loc_59D30:
                lea     ChildObjDat_59D8E(pc),a2
                tst.b   subtype(a0)
                beq.s   loc_59D3E
                lea     ChildObjDat_59D96(pc),a2

loc_59D3E:
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

loc_59D42:
                lea     ChildObjDat_59D9E(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------
ObjDat_Ribot:
                dc.l    Map_Ribot
                dc.w    make_art_tile(ArtTile_Ribot,1,0)
                dc.w    $280
                dc.b    $10,  $C,   0,  $B
word_59D56:
                dc.w    $200
                dc.b    8,   8,   7, $97
word_59D5C:
                dc.w    $200
                dc.b    4,   4,   6,   0
ChildObjDat_59D62:
                dc.w    2-1
                dc.l    loc_59AFA
                dc.b    -$C,  $C
                dc.l    loc_59AFA
                dc.b    $C,  $C
ChildObjDat_59D70:
                dc.w    2-1
                dc.l    loc_59AFA
                dc.b    -$18,   0
                dc.l    loc_59AFA
                dc.b    $18,   0
ChildObjDat_59D7E:
                dc.w    1-1
                dc.l    loc_59AFA
                dc.b    0,-$10
ChildObjDat_59D86:
                dc.w    3-1
                dc.l    loc_59C8A
                dc.b    0, -$C
ChildObjDat_59D8E:
                dc.w    3-1
                dc.l    loc_59C8A
                dc.b    $C,   0
ChildObjDat_59D96:
                dc.w    3-1
                dc.l    loc_59C8A
                dc.b    -$C,   0
ChildObjDat_59D9E:
                dc.w    3-1
                dc.l    loc_59C8A
                dc.b    0,   0
byte_59DA6:
                dc.b    7,   0,   1,   2,   1, $FC
byte_59DAC:
                dc.b    7,   3,   4,   5,   4, $FC
                even
