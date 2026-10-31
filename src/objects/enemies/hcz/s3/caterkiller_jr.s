; Owner: objects/enemies/hcz/s3
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
                dc.w    loc_554E8-CaterKillerJr_Index
                dc.w    loc_55524-CaterKillerJr_Index
                dc.w    loc_55524-CaterKillerJr_Index
                dc.w    loc_55554-CaterKillerJr_Index
                dc.w    loc_55576-CaterKillerJr_Index
; ---------------------------------------------------------------------------

loc_554E8:
                lea     ObjDat_CaterKillerJr(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #-$100,x_vel(a0)
                lea     ChildObjDat_55694(pc),a2
                jsr     CreateChild3_NormalRepeated(pc)

loc_554FE:
                move.b  #4,routine(a0)
                move.b  #3,$39(a0)
                move.w  #$80,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_55524:
                jsr     Swing_UpAndDown_Count(pc)
                bne.s   loc_55534
                jsr     (MoveSprite2).l
                bra.w   loc_5563A
; ---------------------------------------------------------------------------

loc_55534:
                move.b  #6,routine(a0)
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_55554:
                jsr     Swing_UpAndDown(pc)
                tst.w   d3
                beq.s   loc_5556C
                move.b  #8,routine(a0)
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_5556C:
                jsr     (MoveSprite2).l
                bra.w   loc_5563A
; ---------------------------------------------------------------------------

loc_55576:
                jsr     Swing_UpAndDown(pc)
                tst.w   d3
                bne.s   loc_554FE
                jsr     (MoveSprite2).l
                bra.w   loc_5563A
; ---------------------------------------------------------------------------

loc_55588:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5559E(pc,d0.w),d1
                jsr     off_5559E(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_5559E:
                dc.w    loc_555A8-off_5559E
                dc.w    loc_555D4-off_5559E
                dc.w    loc_55524-off_5559E
                dc.w    loc_55554-off_5559E
                dc.w    loc_55576-off_5559E
; ---------------------------------------------------------------------------

loc_555A8:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  off_555C2(pc,d0.w),d1
                lea     off_555C2(pc,d1.w),a1
                lsr.w   #1,d0
                move.b  byte_555CE(pc,d0.w),$2F(a0)
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------
off_555C2:
                dc.w    ObjDat3_5566A-off_555C2
                dc.w    ObjDat3_5566A-off_555C2
                dc.w    ObjDat3_5566A-off_555C2
                dc.w    ObjDat3_55676-off_555C2
                dc.w    ObjDat3_55682-off_555C2
                dc.w    ObjDat3_55682-off_555C2
byte_555CE:
                dc.b    $B, $17, $23, $2F, $37, $3F
                even
; ---------------------------------------------------------------------------

loc_555D4:
                subq.w  #1,$2E(a0)
                bmi.s   loc_555DC
                rts
; ---------------------------------------------------------------------------

loc_555DC:
                move.b  #4,routine(a0)
                moveq   #$40,d1
                moveq   #0,d0
                move.b  subtype(a0),d0
                addq.w  #2,d0
                lsl.w   #2,d0
                sub.w   d0,d1
                move.w  d1,$2E(a0)
                move.l  #loc_55650,$34(a0)
                move.w  #-$100,x_vel(a0)
                bra.w   loc_554FE
; ---------------------------------------------------------------------------

loc_55606:
                lea     word_5568E(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_55628,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                bset    #4,shield_reaction(a0)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_55628:
                jsr     Refresh_ChildPositionAdjusted(pc)
                lea     byte_556A4(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5563A:
                cmpi.l  #loc_55588,(a0)
                bne.s   locret_5564E
                cmpi.b  #6,subtype(a0)
                bhs.s   locret_5564E
                jsr     Obj_Wait(pc)

locret_5564E:
                rts
; ---------------------------------------------------------------------------

loc_55650:
                move.w  #$1A,$2E(a0)
                lea     ChildObjDat_5569C(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------
ObjDat_CaterKillerJr:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,   8,   0, $17
ObjDat3_5566A:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,  $C,   1, $97
ObjDat3_55676:
                dc.l    Map_CaterKillerJr
                dc.w    make_art_tile(ArtTile_CaterkillerJr,1,1)
                dc.w    $280
                dc.b    8,   8,   2, $97
ObjDat3_55682:
                dc.l    Map_MonkeyDude
                dc.w    make_art_tile(ArtTile_MonkeyDude,1,1)
                dc.w    $280
                dc.b    4,   4,   3, $98
word_5568E:
                dc.w    $200
                dc.b    $10, $10,   3,   0
ChildObjDat_55694:
                dc.w    6-1
                dc.l    loc_55588
                dc.b    0,   0
ChildObjDat_5569C:
                dc.w    1-1
                dc.l    loc_55606
                dc.b    0,   0
byte_556A4:
                dc.b    3,   2
                dc.b    3,   2
                dc.b    4,   3
                dc.b    5,   4
                dc.b    $F4
                even
