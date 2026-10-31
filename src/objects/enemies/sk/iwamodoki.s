; Owner: objects/enemies/sk
; Responsibility: Iwamodoki enemy movement, player interaction and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Iwamodoki:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Iwamodoki_Index(pc,d0.w),d1
                jsr     Iwamodoki_Index(pc,d1.w)
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_8FB2A
                btst    #7,status(a0)
                bne.s   loc_8FB36
                moveq   #$17,d1
                moveq   #$C,d2
                moveq   #$B,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8FB2A:
                jsr     (Displace_PlayerOffObject).l
                jmp     (loc_85088).l
; ---------------------------------------------------------------------------

loc_8FB36:
                jmp     (Displace_PlayerOffObject).l
; ---------------------------------------------------------------------------
Iwamodoki_Index:
                dc.w    loc_8FB42-Iwamodoki_Index
                dc.w    loc_8FB4C-Iwamodoki_Index
                dc.w    loc_8FB70-Iwamodoki_Index
; ---------------------------------------------------------------------------

loc_8FB42:
                lea     ObjDat_Iwamodoki(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

loc_8FB4C:
                jsr     (Find_SonicTails).l
                cmpi.w  #$40,d2
                bhs.s   locret_8FB6E
                move.b  #4,routine(a0)
                move.l  #byte_8FC30,$30(a0)
                move.l  #loc_8FB76,$34(a0)

locret_8FB6E:
                rts
; ---------------------------------------------------------------------------

loc_8FB70:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_8FB76:
; Bug: When Iwamodoki explodes, 100 points is never actually given out
                move.l  #Obj_Explosion,(a0)
                bset    #7,status(a0)
                clr.b   routine(a0)
                lea     ChildObjDat_8FBD6(pc),a2
                jmp     (CreateChild2_Complex).l
; ---------------------------------------------------------------------------

loc_8FB90:
                movea.l $3E(a0),a1
                jsr     (SetUp_ObjAttributes3).l
                bset    #3,shield_reaction(a0)
                move.l  #loc_86D5E,(a0)
                move.b  subtype(a0),d0
                lsr.b   #2,d0
                addq.b  #6,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Sprite_CheckDeleteTouchXY).l
; ---------------------------------------------------------------------------

loc_8FBB8:
                jsr     (MoveSprite).l
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------
ObjDat_Iwamodoki:
                dc.l    Map_Iwamodoki
                dc.w    make_art_tile(ArtTile_Iwamodoki,0,0)
                dc.w    $280
                dc.b    $C,  $C,   0,   0
word_8FBD0:
                dc.w    $280
                dc.b    8,   4,   0, $98
ChildObjDat_8FBD6:
                dc.w    4-1
                dc.l    loc_8FB90
                dc.l    word_8FBD0
                dc.l    byte_8FC8B
                dc.l    loc_8FBB8
                dc.b    -4,   4
                dc.w    -$400, -$200
                dc.l    loc_8FB90
                dc.l    word_8FBD0
                dc.l    byte_8FC8B
                dc.l    loc_8FBB8
                dc.b    4,   4
                dc.w    $400, -$200
                dc.l    loc_8FB90
                dc.l    word_8FBD0
                dc.l    byte_8FC87
                dc.l    loc_8FBB8
                dc.b    -8,  -8
                dc.w    -$200, -$400
                dc.l    loc_8FB90
                dc.l    word_8FBD0
                dc.l    byte_8FC87
                dc.l    loc_8FBB8
                dc.b    8,  -8
                dc.w    $200, -$400
byte_8FC30:
                dc.b    0,   7
                dc.b    1,   7
                dc.b    2,   7
                dc.b    3, $2F
                dc.b    4,   5
                dc.b    3,   5
                dc.b    4,   4
                dc.b    3,   4
                dc.b    4,   3
                dc.b    3,   3
                dc.b    4,   2
                dc.b    3,   2
                dc.b    4,   1
                dc.b    3,   1
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    5, $1F
                dc.b    $F4
byte_8FC87:
                dc.b    0,   6,   8, $FC
byte_8FC8B:
                dc.b    0,   7,   9, $FC
                even
Map_Iwamodoki:
                include "src/objects/shared/iwamodoki/mappings/iwamodoki.s"
