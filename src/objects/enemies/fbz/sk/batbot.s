; Owner: objects/enemies/fbz/sk
; Responsibility: Batbot flight and attack controller with private object and child construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Batbot:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Batbot_Index(pc,d0.w),d1
                jsr     Batbot_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Batbot_Index:
                dc.w    loc_89394-Batbot_Index
                dc.w    loc_893A4-Batbot_Index
                dc.w    loc_893CC-Batbot_Index
; ---------------------------------------------------------------------------

loc_89394:
                lea     ObjDat_Batbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     ChildObjDat_8946C(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_893A4:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                blo.s   loc_893B0
                rts
; ---------------------------------------------------------------------------

loc_893B0:
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                move.w  #$200,d0
                tst.w   d0
                bne.s   loc_893C6
                neg.w   d0

loc_893C6:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_893CC:
                lea     byte_8947A(pc),a1
                jsr     Animate_RawNoSST(pc)
                lea     (Player_1).w,a1
                move.w  #$200,d0
                moveq   #8,d1
                jsr     Chase_Object(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_893E8:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_893FE(pc,d0.w),d1
                jsr     off_893FE(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_893FE:
                dc.w    loc_89404-off_893FE
                dc.w    loc_8940C-off_893FE
                dc.w    loc_89426-off_893FE
; ---------------------------------------------------------------------------

loc_89404:
                lea     word_89460(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_8940C:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_8941A
                rts
; ---------------------------------------------------------------------------

loc_8941A:
                move.b  #4,routine(a0)
                addq.b  #1,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_89426:
                lea     byte_89480(pc),a1
                jmp     Animate_RawNoSSTMultiDelay(pc)
; ---------------------------------------------------------------------------

loc_8942E:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_89444(pc,d0.w),d1
                jsr     off_89444(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_89444:
                dc.w    loc_8944A-off_89444
                dc.w    loc_8940C-off_89444
                dc.w    locret_89452-off_89444
; ---------------------------------------------------------------------------

loc_8944A:
                lea     word_89466(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

locret_89452:
                rts
; ---------------------------------------------------------------------------
ObjDat_Batbot:
                dc.l    Map_Batbot
                dc.w    make_art_tile(ArtTile_Batbot,1,1)
                dc.w    $280
                dc.b    $20,   8,   2,  $D
word_89460:
                dc.w    $200
                dc.b    8,   8,   3,   0
word_89466:
                dc.w    $200
                dc.b    4,   4,   5,   0
ChildObjDat_8946C:
                dc.w    2-1
                dc.l    loc_893E8
                dc.b    0, $10
                dc.l    loc_8942E
                dc.b    0,   3
byte_8947A:
                dc.b    2,   0,   1,   2,   1, $FC
byte_89480:
                dc.b    3, $1D
                dc.b    4,   2
                dc.b    3,   1
                dc.b    4,   2
                dc.b    3,  $E
                dc.b    4,   2
                dc.b    $FC
                even
