; Owner: objects/enemies/lbz/sk
; Responsibility: Orbinaut orbiting enemy, orb children and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Orbinaut:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Orbinaut_Index(pc,d0.w),d1
                jsr     Orbinaut_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Orbinaut_Index:
                dc.w    loc_8C64E-Orbinaut_Index
                dc.w    loc_8C662-Orbinaut_Index
; ---------------------------------------------------------------------------

loc_8C64E:
                lea     ObjDat_Orbinaut(pc),a1
                jsr     (SetUp_ObjAttributes).l
                lea     ChildObjDat_8C704(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_8C662:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                bclr    #0,render_flags(a0)
                move.w  #-$80,d1
                tst.w   d0
                beq.s   loc_8C680
                bset    #0,render_flags(a0)
                neg.w   d1

loc_8C680:
                move.w  d1,x_vel(a0)
                bsr.w   TestPrimaryPlayerGroundMotionForOrbinaut
                beq.w   locret_8C6F0
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_8C692:
                lea     word_8C6FE(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_8C6B0,(a0)
                move.b  subtype(a0),d0
                lsl.b   #5,d0
                move.b  d0,$3C(a0)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_8C6B0:
                movea.w parent3(a0),a1
                bsr.w   TestPrimaryPlayerGroundMotionForOrbinaut
                beq.s   loc_8C6CA
                moveq   #8,d0
                btst    #0,render_flags(a1)
                beq.s   loc_8C6C6
                moveq   #-8,d0

loc_8C6C6:
                add.b   d0,$3C(a0)

loc_8C6CA:
                moveq   #4,d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Child_DrawTouch_Sprite(pc)

; =============== S U B R O U T I N E =======================================

TestPrimaryPlayerGroundMotionForOrbinaut:
                lea     (Player_1).w,a2
                btst    #Status_InAir,status(a2)
                bne.s   loc_8C6EC
                tst.w   x_vel(a2)
                bne.s   locret_8C6F0
                tst.w   y_vel(a2)
                bne.s   locret_8C6F0

loc_8C6EC:
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

locret_8C6F0:
                rts
; End of function TestPrimaryPlayerGroundMotionForOrbinaut

; ---------------------------------------------------------------------------
ObjDat_Orbinaut:
                dc.l    Map_Orbinaut
                dc.w    make_art_tile(ArtTile_Orbinaut,1,0)
                dc.w    $280
                dc.b    8,   8,   0,  $B
word_8C6FE:
                dc.w    $280
                dc.b    8,   8,   1, $8B
ChildObjDat_8C704:
                dc.w    4-1
                dc.l    loc_8C692
                dc.b    0, $10
                dc.l    loc_8C692
                dc.b    $10,   0
                dc.l    loc_8C692
                dc.b    0,-$10
                dc.l    loc_8C692
                dc.b    -$10,   0
                dc.b    0,   5
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,   5
                dc.b    $FC
                even
