; Owner: objects/enemies/sk
; Responsibility: Mushmeanie enemy movement, interaction and private object resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Mushmeanie:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Mushmeanie_Index(pc,d0.w),d1
                jsr     Mushmeanie_Index(pc,d1.w)
                bsr.w   sub_8DC6E
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
Mushmeanie_Index:
                dc.w    loc_8DB1E-Mushmeanie_Index
                dc.w    loc_8DB3E-Mushmeanie_Index
                dc.w    loc_8DB64-Mushmeanie_Index
                dc.w    loc_8DB94-Mushmeanie_Index
                dc.w    loc_8DBEC-Mushmeanie_Index
; ---------------------------------------------------------------------------

loc_8DB1E:
                lea     ObjDat_Mushmeanie(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #2,$39(a0)
                move.b  #$12,y_radius(a0)
                lea     ChildObjDat_8DCDE(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_8DB3E:
                jsr     (Find_SonicTails).l
                cmpi.w  #$80,d2
                blo.s   loc_8DB4C
                rts
; ---------------------------------------------------------------------------

loc_8DB4C:
                move.b  #4,routine(a0)
                move.l  #byte_8DCE6,$30(a0)
                move.l  #loc_8DB76,$34(a0)

locret_8DB62:
                rts
; ---------------------------------------------------------------------------

loc_8DB64:
                jsr     (Animate_RawMultiDelay).l
                tst.w   d2
                bne.s   loc_8DB70
                rts
; ---------------------------------------------------------------------------

loc_8DB70:
                subq.w  #3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_8DB76:
                move.b  #6,routine(a0)
                move.w  #-$300,y_vel(a0)
                move.l  #loc_8DBD4,$34(a0)
                move.w  #-$100,d4
                jmp     (Set_VelocityXTrackSonic).l
; ---------------------------------------------------------------------------

loc_8DB94:
                jsr     (MoveSprite_LightGravity).l
                tst.w   x_vel(a0)
                bmi.s   loc_8DBAC
                moveq   #8,d3
                jsr     (ObjCheckRightWallDist).l
                bra.w   loc_8DBB4
; ---------------------------------------------------------------------------

loc_8DBAC:
                moveq   #-8,d3
                jsr     (ObjCheckLeftWallDist).l

loc_8DBB4:
                tst.w   d1
                bpl.s   loc_8DBC6
                add.w   d1,x_pos(a0)
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_8DBC6:
                tst.w   y_vel(a0)
                bmi.w   locret_8DB62
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_8DBD4:
                move.b  #8,routine(a0)
                move.l  #byte_8DCED,$30(a0)
                move.l  #loc_8DB76,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8DBEC:
                jsr     (Animate_RawMultiDelay).l
                tst.w   d2
                bne.s   loc_8DBF8
                rts
; ---------------------------------------------------------------------------

loc_8DBF8:
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.w  word_8DC08(pc,d0.w),d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
word_8DC08:
                dc.w    -3,     3,     3,    -3,    -3,    -3
; ---------------------------------------------------------------------------

loc_8DC14:
                lea     word_8DCD6(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_8DC24,(a0)

loc_8DC24:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                btst    #6,status(a1)
                bne.s   loc_8DC42
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8DC42:
                move.l  #loc_8DC62,(a0)
                movea.w $44(a1),a2
                move.w  #$200,d0
                tst.w   x_vel(a2)
                bmi.s   loc_8DC58
                neg.w   d0

loc_8DC58:
                move.w  d0,x_vel(a0)
                move.w  #-$200,y_vel(a0)

loc_8DC62:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l

; =============== S U B R O U T I N E =======================================

sub_8DC6E:
                tst.b   $20(a0)
                beq.s   loc_8DC80
                subq.b  #1,$20(a0)
                bne.s   locret_8DCC2
                move.b  #$D7,collision_flags(a0)

loc_8DC80:
                jsr     (Check_PlayerCollision).l
                beq.s   locret_8DCC2
                jsr     (Check_PlayerAttack).l
                bne.s   loc_8DC9C
                tst.b   invulnerability_timer(a1)
                bne.s   locret_8DCC2
                jmp     (HurtCharacter_Directly).l
; ---------------------------------------------------------------------------

loc_8DC9C:
                subq.b  #1,$39(a0)
                beq.s   loc_8DCC4
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)
                move.b  #$20,$20(a0)
                bset    #6,status(a0)
                neg.w   x_vel(a1)
                neg.w   y_vel(a1)
                neg.w   ground_vel(a1)

locret_8DCC2:
                rts
; ---------------------------------------------------------------------------

loc_8DCC4:
                jmp     (EnemyDefeated).l
; End of function sub_8DC6E

; ---------------------------------------------------------------------------
ObjDat_Mushmeanie:
                dc.l    Map_Mushmeanie
                dc.w    make_art_tile(ArtTile_Mushmeanie,1,0)
                dc.w    $280
                dc.b    8,   8,   1, $D7
word_8DCD6:
                dc.w    make_art_tile(ArtTile_Mushmeanie,2,0)
                dc.w    $200
                dc.b    $C,   8,   0,   0
ChildObjDat_8DCDE:
                dc.w    1-1
                dc.l    loc_8DC14
                dc.b    0,   0
byte_8DCE6:
                dc.b    1,   2
                dc.b    2,   2
                dc.b    3,   0
                dc.b    $F4
byte_8DCED:
                dc.b    3,   2
                dc.b    2,   2
                dc.b    1,   2
                dc.b    2,   2
                dc.b    3,   0
                dc.b    $F4
                even
Map_Mushmeanie:
                include "src/objects/shared/mushmeanie/map_mushmeanie.s"
