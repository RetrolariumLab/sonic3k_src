; Owner: objects/enemies/hcz/sk
; Responsibility: Caterkiller Junior controller, following segments and child construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CaterKillerJr:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CaterKillerJr_Index(pc,d0.w),d1
                jsr     CaterKillerJr_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
CaterKillerJr_Index:
                dc.w    loc_876EC-CaterKillerJr_Index
                dc.w    loc_87728-CaterKillerJr_Index
                dc.w    loc_87728-CaterKillerJr_Index
                dc.w    loc_87758-CaterKillerJr_Index
                dc.w    loc_8777A-CaterKillerJr_Index
; ---------------------------------------------------------------------------

loc_876EC:
                lea     ObjDat_CaterKillerJr(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #-$100,x_vel(a0)
                lea     ChildObjDat_87898(pc),a2
                jsr     CreateChild3_NormalRepeated(pc)

loc_87702:
                move.b  #4,routine(a0)
                move.b  #3,$39(a0)
                move.w  #$80,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_87728:
                jsr     Swing_UpAndDown_Count(pc)
                bne.s   loc_87738
                jsr     (MoveSprite2).l
                bra.w   loc_8783E
; ---------------------------------------------------------------------------

loc_87738:
                move.b  #6,routine(a0)
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_87758:
                jsr     Swing_UpAndDown(pc)
                tst.w   d3
                beq.s   loc_87770
                move.b  #8,routine(a0)
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_87770:
                jsr     (MoveSprite2).l
                bra.w   loc_8783E
; ---------------------------------------------------------------------------

loc_8777A:
                jsr     Swing_UpAndDown(pc)
                tst.w   d3
                bne.s   loc_87702
                jsr     (MoveSprite2).l
                bra.w   loc_8783E
; ---------------------------------------------------------------------------

loc_8778C:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_877A2(pc,d0.w),d1
                jsr     off_877A2(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_877A2:
                dc.w    loc_877AC-off_877A2
                dc.w    loc_877D8-off_877A2
                dc.w    loc_87728-off_877A2
                dc.w    loc_87758-off_877A2
                dc.w    loc_8777A-off_877A2
; ---------------------------------------------------------------------------

loc_877AC:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  off_877C6(pc,d0.w),d1
                lea     off_877C6(pc,d1.w),a1
                lsr.w   #1,d0
                move.b  byte_877D2(pc,d0.w),$2F(a0)
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------
off_877C6:
                dc.w    ObjDat3_8786E-off_877C6
                dc.w    ObjDat3_8786E-off_877C6
                dc.w    ObjDat3_8786E-off_877C6
                dc.w    ObjDat3_8787A-off_877C6
                dc.w    ObjDat3_87886-off_877C6
                dc.w    ObjDat3_87886-off_877C6
byte_877D2:
                dc.b    $B, $17, $23, $2F, $37, $3F
                even
; ---------------------------------------------------------------------------

loc_877D8:
                subq.w  #1,$2E(a0)
                bmi.s   loc_877E0
                rts
; ---------------------------------------------------------------------------

loc_877E0:
                move.b  #4,routine(a0)
                moveq   #$40,d1
                moveq   #0,d0
                move.b  subtype(a0),d0
                addq.w  #2,d0
                lsl.w   #2,d0
                sub.w   d0,d1
                move.w  d1,$2E(a0)
                move.l  #loc_87854,$34(a0)
                move.w  #-$100,x_vel(a0)
                bra.w   loc_87702
; ---------------------------------------------------------------------------

loc_8780A:
                lea     word_87892(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_8782C,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                bset    #4,shield_reaction(a0)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8782C:
                jsr     Refresh_ChildPositionAdjusted(pc)
                lea     byte_878A8(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8783E:
                cmpi.l  #loc_8778C,(a0)
                bne.s   locret_87852
                cmpi.b  #6,subtype(a0)
                bhs.s   locret_87852
                jsr     Obj_Wait(pc)

locret_87852:
                rts
; ---------------------------------------------------------------------------

loc_87854:
                move.w  #$1A,$2E(a0)
                lea     ChildObjDat_878A0(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------
ObjDat_CaterKillerJr:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,   8,   0, $17
ObjDat3_8786E:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,  $C,   1, $97
ObjDat3_8787A:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,   8,   2, $97
ObjDat3_87886:
                dc.l    Map_MonkeyDude
                dc.w    make_art_tile(ArtTile_MonkeyDude,1,1)
                dc.w    $280
                dc.b    4,   4,   3, $98
word_87892:
                dc.w    $200
                dc.b    $10, $10,   3,   0
ChildObjDat_87898:
                dc.w    6-1
                dc.l    loc_8778C
                dc.b    0,   0
ChildObjDat_878A0:
                dc.w    1-1
                dc.l    loc_8780A
                dc.b    0,   0
byte_878A8:
                dc.b    3,   2
                dc.b    3,   2
                dc.b    4,   3
                dc.b    5,   4
                dc.b    $F4
                even
