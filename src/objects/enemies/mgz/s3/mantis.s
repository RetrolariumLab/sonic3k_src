; Owner: objects/enemies/mgz/s3
; Responsibility: Mantis enemy and projectile states with private child construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Mantis:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Mantis_Index(pc,d0.w),d1
                jsr     Mantis_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Mantis_Index:
                dc.w    loc_56C40-Mantis_Index
                dc.w    loc_56C56-Mantis_Index
                dc.w    loc_56C82-Mantis_Index
                dc.w    loc_56CBC-Mantis_Index
                dc.w    loc_56CE0-Mantis_Index
; ---------------------------------------------------------------------------

loc_56C40:
                lea     ObjDat_Mantis(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$29,y_radius(a0)
                lea     ChildObjDat_56D5A(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_56C56:
                jsr     Find_SonicTails(pc)
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   loc_56C6A
                bset    #0,render_flags(a0)

loc_56C6A:
                cmpi.w  #$40,d2
                blo.s   loc_56C72
                rts
; ---------------------------------------------------------------------------

loc_56C72:
                move.b  #4,routine(a0)
                move.l  #loc_56CA6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56C82:
                lea     byte_56D62(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_56C9E
                bmi.s   locret_56C9E
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.w  word_56CA0(pc,d0.w),d0
                add.w   d0,y_pos(a0)

locret_56C9E:
                rts
; ---------------------------------------------------------------------------
word_56CA0:
                dc.w    0,    -5,  -$13
; ---------------------------------------------------------------------------

loc_56CA6:
                move.b  #6,routine(a0)
                move.w  #-$600,y_vel(a0)
                move.l  #loc_56CCC,$34(a0)

locret_56CBA:
                rts
; ---------------------------------------------------------------------------

loc_56CBC:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_56CBA
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_56CCC:
                move.b  #8,routine(a0)
                clr.w   y_vel(a0)
                move.l  #loc_56D06,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56CE0:
                lea     byte_56D69(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_56CFC
                bmi.s   locret_56CFC
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.w  word_56CFE(pc,d0.w),d0
                add.w   d0,y_pos(a0)

locret_56CFC:
                rts
; ---------------------------------------------------------------------------
word_56CFE:
                dc.w    0,   $12,     6,    -1
; ---------------------------------------------------------------------------

loc_56D06:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_56D0E:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_56D24(pc,d0.w),d1
                jsr     off_56D24(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_56D24:
                dc.w    loc_56D28-off_56D24
                dc.w    loc_56D30-off_56D24
; ---------------------------------------------------------------------------

loc_56D28:
                lea     word_56D54(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_56D30:
                movea.w parent3(a0),a1
                move.b  #5,mapping_frame(a0)
                tst.w   y_vel(a1)
                bmi.s   locret_56D46
                move.b  #4,mapping_frame(a0)

locret_56D46:
                rts
; ---------------------------------------------------------------------------
ObjDat_Mantis:
                dc.l    Map_Mantis
                dc.w    make_art_tile(ArtTile_Mantis,1,0)
                dc.w    $280
                dc.b    $14, $1C,   0, $1A
word_56D54:
                dc.w    $200
                dc.b    4,   4,   5,   0
ChildObjDat_56D5A:
                dc.w    1-1
                dc.l    loc_56D0E
                dc.b    -9, -$B
byte_56D62:
                dc.b    0,   0
                dc.b    1,   2
                dc.b    2,   0
                dc.b    $F4
byte_56D69:
                dc.b    2,   0
                dc.b    1,   2
                dc.b    3,   2
                dc.b    0, $1F
                dc.b    $F4
                even
