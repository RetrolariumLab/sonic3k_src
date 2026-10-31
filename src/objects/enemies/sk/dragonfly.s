; Owner: objects/enemies/sk
; Responsibility: Dragonfly enemy flight, attack states, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Dragonfly:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Dragonfly_Index(pc,d0.w),d1
                jsr     Dragonfly_Index(pc,d1.w)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
Dragonfly_Index:
                dc.w    loc_8DD52-Dragonfly_Index
                dc.w    loc_8DDAA-Dragonfly_Index
                dc.w    loc_8DDE6-Dragonfly_Index
; ---------------------------------------------------------------------------

loc_8DD52:
                lea     ObjDat3_8DF96(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #byte_8DFCE,$30(a0)
                lea     ChildObjDat_8DFAE(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_8DFB6(pc),a2
                jsr     (CreateChild4_LinkListRepeated).l
                move.w  #$200,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)

loc_8DD90:
                move.w  #$200,d0
                move.w  d0,$3A(a0)
                move.w  d0,x_vel(a0)
                move.w  #$20,$3C(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_8DDAA:
                jsr     (Animate_Raw).l
                jsr     (Swing_LeftAndRight).l
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                beq.s   loc_8DDCA
                rts
; ---------------------------------------------------------------------------

loc_8DDCA:
                move.b  #4,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_8DDF8,$34(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_8DDE6:
                jsr     (Swing_LeftAndRight).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_8DDF8:
                move.b  #2,routine(a0)
                bclr    #2,$38(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #byte_8DFC2,$30(a0)
                bchg    #1,$38(a0)
                bne.s   locret_8DE24
                move.l  #byte_8DFCE,$30(a0)

locret_8DE24:
                rts
; ---------------------------------------------------------------------------

loc_8DE26:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_8DE3A(pc,d0.w),d1
                jsr     off_8DE3A(pc,d1.w)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
off_8DE3A:
                dc.w    loc_8DE44-off_8DE3A
                dc.w    loc_8DE74-off_8DE3A
                dc.w    loc_8DE8A-off_8DE3A
                dc.w    loc_8DEB6-off_8DE3A
                dc.w    loc_8DEF4-off_8DE3A
; ---------------------------------------------------------------------------

loc_8DE44:
                lea     word_8DFA8(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bset    #1,render_flags(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                cmpi.b  #$C,d0
                bne.s   loc_8DE66
                move.b  #6,mapping_frame(a0)

loc_8DE66:
                move.w  d0,$2E(a0)
                move.b  #1,child_dx(a0)
                bra.w   loc_8DF68
; ---------------------------------------------------------------------------

loc_8DE74:
                bsr.w   sub_8DF80
                subq.w  #1,$2E(a0)
                bmi.s   loc_8DE80
                rts
; ---------------------------------------------------------------------------

loc_8DE80:
                move.b  #4,routine(a0)
                bra.w   loc_8DD90
; ---------------------------------------------------------------------------

loc_8DE8A:
                bsr.w   sub_8DF80
                jsr     (Swing_LeftAndRight).l
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_8DEA8
                rts
; ---------------------------------------------------------------------------

loc_8DEA8:
                move.b  #6,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_8DEB6:
                jsr     (Swing_LeftAndRight).l
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                move.w  y_pos(a0),d0
                move.b  child_dx(a0),d1
                ext.w   d1
                add.w   d1,d0
                cmp.w   y_pos(a1),d0
                beq.s   loc_8DEDE
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_8DEDE:
                move.w  y_pos(a1),y_pos(a0)
                move.b  #8,routine(a0)
                neg.b   child_dx(a0)
                neg.b   child_dy(a0)
                rts
; ---------------------------------------------------------------------------

loc_8DEF4:
                jsr     (Swing_LeftAndRight).l
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                bmi.s   loc_8DF1A
                add.w   d1,d0
                cmp.w   y_pos(a0),d0
                bls.s   loc_8DF24
                rts
; ---------------------------------------------------------------------------

loc_8DF1A:
                add.w   d1,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_8DF24
                rts
; ---------------------------------------------------------------------------

loc_8DF24:
                move.b  #4,routine(a0)
                move.w  d0,y_pos(a0)
                bchg    #1,render_flags(a0)
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_8DF3C:
                lea     word_8DFA2(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_8DF52,(a0)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8DF52:
                jsr     (Refresh_ChildPosition).l
                lea     byte_8DFBC(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8DF68:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  byte_8DF78(pc,d0.w),child_dy(a0)
                rts
; ---------------------------------------------------------------------------
byte_8DF78:
                dc.b    -$C,  -5,  -5,  -5,  -5,  -5,  -5
                even

; =============== S U B R O U T I N E =======================================

sub_8DF80:
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                add.w   d1,d0
                move.w  d0,y_pos(a0)
                rts
; End of function sub_8DF80

; ---------------------------------------------------------------------------
ObjDat3_8DF96:
                dc.l    Map_Dragonfly
                dc.w    make_art_tile(ArtTile_Dragonfly,1,1)
                dc.w    $280
                dc.b    8,   8,   4, $17
word_8DFA2:
                dc.w    $280
                dc.b    $20,   8,   7,   0
word_8DFA8:
                dc.w    $280
                dc.b    4,   4,   5, $98
ChildObjDat_8DFAE:
                dc.w    1-1
                dc.l    loc_8DF3C
                dc.b    0,   0
ChildObjDat_8DFB6:
                dc.w    7-1
                dc.l    loc_8DE26
byte_8DFBC:
                dc.b    0,   7,   9,   8,   9, $FC
byte_8DFC2:
                dc.b    3,   0,   1,   2,   3,   4
                dc.b    $F8, .jump-byte_8DFC2

                .jump:
                dc.b    $7F,   4,   4, $FC
byte_8DFCE:
                dc.b    3,   4,   3,   2,   1,   0
                dc.b    $F8, .jump-byte_8DFCE

                .jump:
                dc.b    $7F,   0,   0, $FC
                even
Map_Dragonfly:
                include "src/objects/shared/dragonfly/mappings/dragonfly.s"
