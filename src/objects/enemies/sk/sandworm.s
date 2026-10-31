; Owner: objects/enemies/sk
; Responsibility: Sandworm enemy, segment movement, collision and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Sandworm:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Sandworm_Index(pc,d0.w),d1
                jsr     Sandworm_Index(pc,d1.w)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
Sandworm_Index:
                dc.w    loc_8EA88-Sandworm_Index
                dc.w    loc_8EACC-Sandworm_Index
                dc.w    loc_8EB2E-Sandworm_Index
                dc.w    loc_8EACC-Sandworm_Index
; ---------------------------------------------------------------------------

loc_8EA88:
                lea     ObjDat_Sandworm(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #7,$38(a0)
                move.l  #byte_8ED8C,$30(a0)
                lea     ChildObjDat_8ED66(pc),a2
                jsr     (CreateChild6_Simple).l

loc_8EAAA:
                move.w  #$7F,$2E(a0)
                move.l  #loc_8EAD2,$34(a0)
                btst    #7,$38(a0)
                beq.w   locret_8EBE0
                lea     ChildObjDat_8ED6C(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_8EACC:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_8EAD2:
                move.b  #4,routine(a0)
                move.b  #$8B,collision_flags(a0)
                btst    #7,$38(a0)
                beq.s   loc_8EAEC
                move.b  #$B,collision_flags(a0)

loc_8EAEC:
                move.w  y_pos(a0),$3A(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #-$60,d0
                move.w  #-$200,d1
                btst    #0,render_flags(a0)
                beq.s   loc_8EB0A
                neg.w   d0
                neg.w   d1

loc_8EB0A:
                add.w   d0,x_pos(a0)
                move.w  d1,x_vel(a0)
                btst    #7,$38(a0)
                beq.w   locret_8EBE0
                moveq   #signextendB(sfx_Splash2),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_8ED74(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_8EB2E:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite_LightGravity).l
                move.w  $3A(a0),d0
                cmp.w   y_pos(a0),d0
                bhi.w   locret_8EBE0
                move.b  #6,routine(a0)
                clr.b   collision_flags(a0)
                move.w  d0,y_pos(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_8EB7E,$34(a0)
                btst    #7,$38(a0)
                beq.w   locret_8EBE0
                moveq   #signextendB(sfx_Splash2),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_8ED74(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_8EB7E:
                move.b  #2,routine(a0)
                bchg    #0,render_flags(a0)
                bra.w   loc_8EAAA
; ---------------------------------------------------------------------------

loc_8EB8E:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_8EBA4(pc,d0.w),d1
                jsr     off_8EBA4(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_8EBA4:
                dc.w    loc_8EBAC-off_8EBA4
                dc.w    loc_8EACC-off_8EBA4
                dc.w    loc_8EB2E-off_8EBA4
                dc.w    loc_8EACC-off_8EBA4
; ---------------------------------------------------------------------------

loc_8EBAC:
                lea     word_8ED60(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #byte_8ED90,$30(a0)
                jsr     (Change_FlipXUseParent).l
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                addq.w  #6,d0
                subq.w  #1,d0
                move.w  d0,$2E(a0)
                move.l  #loc_8EAAA,$34(a0)

locret_8EBE0:
                rts
; ---------------------------------------------------------------------------

loc_8EBE2:
                lea     word_8ED50(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_8EC1C,(a0)
                move.l  #loc_8EC22,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                move.w  d0,d1
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                bne.s   loc_8EC12
                neg.w   d0

loc_8EC12:
                add.w   d0,x_pos(a0)
                subq.w  #1,d1
                move.w  d1,$2E(a0)

loc_8EC1C:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_8EC22:
                move.l  #loc_8EC46,(a0)
                move.l  #byte_8ED88,$30(a0)
                move.w  #-$80,y_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_8EC5E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8EC46:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8EC5E:
                move.w  #$40,y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8EC74:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_8EC88(pc,d0.w),d1
                jsr     off_8EC88(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_8EC88:
                dc.w    loc_8EC92-off_8EC88
                dc.w    loc_8ECB0-off_8EC88
                dc.w    loc_8ECDA-off_8EC88
                dc.w    loc_8ED02-off_8EC88
                dc.w    loc_8ED3E-off_8EC88
; ---------------------------------------------------------------------------

loc_8EC92:
                lea     word_8ED58(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)
                move.l  #loc_8ECB6,$34(a0)

loc_8ECB0:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_8ECB6:
                move.b  #4,routine(a0)
                move.l  #byte_8ED94,$30(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_8ECEC,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8ECDA:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_8ECEC:
                move.b  #6,routine(a0)
                move.w  #$17,$2E(a0)
                move.l  #loc_8ED1E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8ED02:
                moveq   #8,d0
                btst    #0,$2F(a0)
                bne.s   loc_8ED0E
                neg.w   d0

loc_8ED0E:
                add.w   d0,y_pos(a0)
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_8ED1E:
                move.b  #8,routine(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                move.l  #byte_8ED98,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8ED3E:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------
ObjDat_Sandworm:
                dc.l    Map_Sandworm
                dc.w    make_art_tile(ArtTile_Sandworm,1,0)
                dc.w    $280
                dc.b    8,  $C,   0,   0
word_8ED50:
                dc.w    make_art_tile(ArtTile_Sandworm,2,0)
                dc.w    $200
                dc.b    8,   4,   3,   0
word_8ED58:
                dc.w    make_art_tile(ArtTile_Sandworm,2,0)
                dc.w    $200
                dc.b    4, $10,   5,   0
word_8ED60:
                dc.w    $280
                dc.b    8,   8,   1,   0
ChildObjDat_8ED66:
                dc.w    5-1
                dc.l    loc_8EB8E
ChildObjDat_8ED6C:
                dc.w    8-1
                dc.l    loc_8EBE2
                dc.b    0,  -8
ChildObjDat_8ED74:
                dc.w    3-1
                dc.l    loc_8EC74
                dc.b    0,   4
                dc.l    loc_8EC74
                dc.b    -4,   4
                dc.l    loc_8EC74
                dc.b    4,   4
byte_8ED88:
                dc.b    1,   3,   4, $FC
byte_8ED8C:
                dc.b    9,   0,   2, $FC
byte_8ED90:
                dc.b    $7E,   1,   1, $FC
byte_8ED94:
                dc.b    1,   5,   6, $FC
byte_8ED98:
                dc.b    7,   3
                dc.b    7,   3
                dc.b    8,   5
                dc.b    $F4
                even
