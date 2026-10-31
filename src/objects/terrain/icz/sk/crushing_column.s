; Owner: objects/terrain/icz/sk
; Responsibility: IceCap crushing column states and private object or child descriptors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZCrushingColumn:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZCrushingColumn_Index(pc,d0.w),d1
                move.w  x_pos(a0),-(sp)
                jsr     ICZCrushingColumn_Index(pc,d1.w)
                moveq   #$2B,d1
                moveq   #$70,d2
                moveq   #$70,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------
ICZCrushingColumn_Index:
                dc.w    loc_8A488-ICZCrushingColumn_Index
                dc.w    loc_8A4C4-ICZCrushingColumn_Index
                dc.w    loc_8A4D6-ICZCrushingColumn_Index
                dc.w    loc_8A4DE-ICZCrushingColumn_Index
                dc.w    loc_8A504-ICZCrushingColumn_Index
                dc.w    loc_8A50C-ICZCrushingColumn_Index
                dc.w    loc_8A51C-ICZCrushingColumn_Index
                dc.w    loc_8A562-ICZCrushingColumn_Index
                dc.w    loc_8A586-ICZCrushingColumn_Index
                dc.w    loc_8A596-ICZCrushingColumn_Index
                dc.w    loc_8A5AC-ICZCrushingColumn_Index
                dc.w    loc_8A5C8-ICZCrushingColumn_Index
                dc.w    loc_8A5E4-ICZCrushingColumn_Index
; ---------------------------------------------------------------------------

loc_8A488:
                lea     ObjDat_ICZCrushingColumn(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$70,y_radius(a0)
                move.w  y_pos(a0),$3E(a0)
                move.w  #$1F,$2E(a0)
                cmpi.b  #3,subtype(a0)
                bhs.s   loc_8A4B8
                move.b  #$C,mapping_frame(a0)
                lea     ChildObjDat_8A638(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_8A4B8:
                move.b  subtype(a0),d0
                add.b   d0,d0
                move.b  d0,routine(a0)

locret_8A4C2:
                rts
; ---------------------------------------------------------------------------

loc_8A4C4:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   locret_8A4C2

loc_8A4CE:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A4D6:
                subq.w  #1,$2E(a0)
                bmi.s   loc_8A4CE
                rts
; ---------------------------------------------------------------------------

loc_8A4DE:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                cmpi.w  #$28,d2
                blo.w   locret_8A4C2
                btst    #0,render_flags(a0)
                beq.s   loc_8A4F8
                subq.w  #2,d0

loc_8A4F8:
                tst.w   d0
                beq.s   locret_8A4C2

loc_8A4FC:
                move.b  #$10,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A504:
                subq.w  #1,$2E(a0)
                bmi.s   loc_8A4FC
                rts
; ---------------------------------------------------------------------------

loc_8A50C:
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   loc_8A516
                rts
; ---------------------------------------------------------------------------

loc_8A516:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_8A51C:
                move.w  y_vel(a0),d0
                addi.w  #-$20,d0
                cmpi.w  #-$400,d0
                ble.s   loc_8A52E
                move.w  d0,y_vel(a0)

loc_8A52E:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.w   locret_8A4C2

loc_8A540:
                add.w   d1,y_pos(a0)
                move.b  #$12,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_8A59A,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_8A562:
                move.w  y_vel(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$400,d0
                bgt.s   loc_8A574
                move.w  d0,y_vel(a0)

loc_8A574:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_8A540
                rts
; ---------------------------------------------------------------------------

loc_8A586:
                addq.w  #8,y_pos(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_8A540
                rts
; ---------------------------------------------------------------------------

loc_8A596:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_8A59A:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  byte_8A5A8-1(pc,d0.w),routine(a0)
                rts
; ---------------------------------------------------------------------------
byte_8A5A8:
                dc.b    $16, $16, $18, $14
                even
; ---------------------------------------------------------------------------

loc_8A5AC:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                cmp.w   $3E(a0),d0
                bls.s   loc_8A5BE
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A5BE:
                move.w  #$5F,$2E(a0)
                bra.w   loc_8A4B8
; ---------------------------------------------------------------------------

loc_8A5C8:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                cmp.w   $3E(a0),d0
                bhs.s   loc_8A5DA
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A5DA:
                move.w  #$5F,$2E(a0)
                bra.w   loc_8A4B8
; ---------------------------------------------------------------------------

loc_8A5E4:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                btst    #0,render_flags(a0)
                beq.s   loc_8A5F6
                subq.w  #2,d0

loc_8A5F6:
                tst.w   d0
                bne.w   locret_8A4C2
                move.b  #$14,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A604:
                move.l  #loc_8A612,(a0)
                lea     word_8A632(pc),a1
                jsr     SetUp_ObjAttributes3(pc)

loc_8A612:
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                addi.w  #$B0,d0
                move.w  d0,y_pos(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
ObjDat_ICZCrushingColumn:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $20, $70,   2,   0
word_8A632:
                dc.w    $280
                dc.b    $20, $40,  $D,   0
ChildObjDat_8A638:
                dc.w    1-1
                dc.l    loc_8A604
                dc.b    0,   0
