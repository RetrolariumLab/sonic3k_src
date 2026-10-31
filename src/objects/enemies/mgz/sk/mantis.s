; Owner: objects/enemies/mgz/sk
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
                dc.w    loc_88E82-Mantis_Index
                dc.w    loc_88E98-Mantis_Index
                dc.w    loc_88EC4-Mantis_Index
                dc.w    loc_88EFE-Mantis_Index
                dc.w    loc_88F22-Mantis_Index
; ---------------------------------------------------------------------------

loc_88E82:
                lea     ObjDat_Mantis(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$29,y_radius(a0)
                lea     ChildObjDat_88F9C(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_88E98:
                jsr     Find_SonicTails(pc)
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   loc_88EAC
                bset    #0,render_flags(a0)

loc_88EAC:
                cmpi.w  #$40,d2
                blo.s   loc_88EB4
                rts
; ---------------------------------------------------------------------------

loc_88EB4:
                move.b  #4,routine(a0)
                move.l  #loc_88EE8,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_88EC4:
                lea     byte_88FA4(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_88EE0
                bmi.s   locret_88EE0
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.w  word_88EE2(pc,d0.w),d0
                add.w   d0,y_pos(a0)

locret_88EE0:
                rts
; ---------------------------------------------------------------------------
word_88EE2:
                dc.w    0,    -5,  -$13
; ---------------------------------------------------------------------------

loc_88EE8:
                move.b  #6,routine(a0)
                move.w  #-$600,y_vel(a0)
                move.l  #loc_88F0E,$34(a0)

locret_88EFC:
                rts
; ---------------------------------------------------------------------------

loc_88EFE:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_88EFC
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_88F0E:
                move.b  #8,routine(a0)
                clr.w   y_vel(a0)
                move.l  #loc_88F48,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_88F22:
                lea     byte_88FAB(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_88F3E
                bmi.s   locret_88F3E
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.w  word_88F40(pc,d0.w),d0
                add.w   d0,y_pos(a0)

locret_88F3E:
                rts
; ---------------------------------------------------------------------------
word_88F40:
                dc.w    0,   $12,     6,    -1
; ---------------------------------------------------------------------------

loc_88F48:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_88F50:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_88F66(pc,d0.w),d1
                jsr     off_88F66(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_88F66:
                dc.w    loc_88F6A-off_88F66
                dc.w    loc_88F72-off_88F66
; ---------------------------------------------------------------------------

loc_88F6A:
                lea     word_88F96(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_88F72:
                movea.w parent3(a0),a1
                move.b  #5,mapping_frame(a0)
                tst.w   y_vel(a1)
                bmi.s   locret_88F88
                move.b  #4,mapping_frame(a0)

locret_88F88:
                rts
; ---------------------------------------------------------------------------
ObjDat_Mantis:
                dc.l    Map_Mantis
                dc.w    make_art_tile(ArtTile_Mantis,1,0)
                dc.w    $280
                dc.b    $14, $1C,   0, $1A
word_88F96:
                dc.w    $200
                dc.b    4,   4,   5,   0
ChildObjDat_88F9C:
                dc.w    1-1
                dc.l    loc_88F50
                dc.b    -9, -$B
byte_88FA4:
                dc.b    0,   0
                dc.b    1,   2
                dc.b    2,   0
                dc.b    $F4
byte_88FAB:
                dc.b    2,   0
                dc.b    1,   2
                dc.b    3,   2
                dc.b    0, $1F
                dc.b    $F4
                even
