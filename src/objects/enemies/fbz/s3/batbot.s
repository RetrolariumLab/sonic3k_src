; Owner: objects/enemies/fbz/s3
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
                dc.w    loc_57148-Batbot_Index
                dc.w    loc_57158-Batbot_Index
                dc.w    loc_57180-Batbot_Index
; ---------------------------------------------------------------------------

loc_57148:
                lea     ObjDat_Batbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     ChildObjDat_57220(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_57158:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                blo.s   loc_57164
                rts
; ---------------------------------------------------------------------------

loc_57164:
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                move.w  #$200,d0
                tst.w   d0
                bne.s   loc_5717A
                neg.w   d0

loc_5717A:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_57180:
                lea     byte_5722E(pc),a1
                jsr     Animate_RawNoSST(pc)
                lea     (Player_1).w,a1
                move.w  #$200,d0
                moveq   #8,d1
                jsr     Chase_Object(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_5719C:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_571B2(pc,d0.w),d1
                jsr     off_571B2(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_571B2:
                dc.w    loc_571B8-off_571B2
                dc.w    loc_571C0-off_571B2
                dc.w    loc_571DA-off_571B2
; ---------------------------------------------------------------------------

loc_571B8:
                lea     word_57214(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_571C0:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_571CE
                rts
; ---------------------------------------------------------------------------

loc_571CE:
                move.b  #4,routine(a0)
                addq.b  #1,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_571DA:
                lea     byte_57234(pc),a1
                jmp     Animate_RawNoSSTMultiDelay(pc)
; ---------------------------------------------------------------------------

loc_571E2:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_571F8(pc,d0.w),d1
                jsr     off_571F8(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_571F8:
                dc.w    loc_571FE-off_571F8
                dc.w    loc_571C0-off_571F8
                dc.w    locret_57206-off_571F8
; ---------------------------------------------------------------------------

loc_571FE:
                lea     word_5721A(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

locret_57206:
                rts
; ---------------------------------------------------------------------------
ObjDat_Batbot:
                dc.l    Map_Batbot
                dc.w    make_art_tile(ArtTile_Batbot,1,1)
                dc.w    $280
                dc.b    $20,   8,   2,  $D
word_57214:
                dc.w    $200
                dc.b    8,   8,   3,   0
word_5721A:
                dc.w    $200
                dc.b    4,   4,   5,   0
ChildObjDat_57220:
                dc.w    2-1
                dc.l    loc_5719C
                dc.b    0, $10
                dc.l    loc_571E2
                dc.b    0,   3
byte_5722E:
                dc.b    2,   0,   1,   2,   1, $FC
byte_57234:
                dc.b    3, $1D
                dc.b    4,   2
                dc.b    3,   1
                dc.b    4,   2
                dc.b    3,  $E
                dc.b    4,   2
                dc.b    $FC
                even
