; Owner: objects/enemies/lbz/s3
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
                dc.w    loc_59DCE-Orbinaut_Index
                dc.w    loc_59DE0-Orbinaut_Index
; ---------------------------------------------------------------------------

loc_59DCE:
                lea     ObjDat_Orbinaut(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     ChildObjDat_59E80(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_59DE0:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                bclr    #0,render_flags(a0)
                move.w  #-$80,d1
                tst.w   d0
                beq.s   loc_59DFE
                bset    #0,render_flags(a0)
                neg.w   d1

loc_59DFE:
                move.w  d1,x_vel(a0)
                bsr.w   sub_59E50
                beq.w   locret_59E6C
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_59E10:
                lea     word_59E7A(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_59E2C,(a0)
                move.b  subtype(a0),d0
                lsl.b   #5,d0
                move.b  d0,$3C(a0)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_59E2C:
                movea.w parent3(a0),a1
                bsr.w   sub_59E50
                beq.s   loc_59E46
                moveq   #8,d0
                btst    #0,render_flags(a1)
                beq.s   loc_59E42
                moveq   #-8,d0

loc_59E42:
                add.b   d0,$3C(a0)

loc_59E46:
                moveq   #4,d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Child_DrawTouch_Sprite(pc)

; =============== S U B R O U T I N E =======================================

sub_59E50:
                lea     (Player_1).w,a2
                btst    #Status_InAir,status(a2)
                bne.s   loc_59E68
                tst.w   x_vel(a2)
                bne.s   locret_59E6C
                tst.w   y_vel(a2)
                bne.s   locret_59E6C

loc_59E68:
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

locret_59E6C:
                rts
; End of function sub_59E50

; ---------------------------------------------------------------------------
ObjDat_Orbinaut:
                dc.l    Map_Orbinaut
                dc.w    make_art_tile(ArtTile_Orbinaut,1,0)
                dc.w    $280
                dc.b    8,   8,   0,  $B
word_59E7A:
                dc.w    $280
                dc.b    8,   8,   1, $8B
ChildObjDat_59E80:
                dc.w    4-1
                dc.l    loc_59E10
                dc.b    0, $10
                dc.l    loc_59E10
                dc.b    $10,   0
                dc.l    loc_59E10
                dc.b    0,-$10
                dc.l    loc_59E10
                dc.b    -$10,   0

; unused
                dc.b    0,   5
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,   5
                dc.b    $FC
                even
