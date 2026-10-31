; Owner: objects/terrain/icz/s3
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
                dc.w    loc_57C90-ICZCrushingColumn_Index
                dc.w    loc_57CCC-ICZCrushingColumn_Index
                dc.w    loc_57CDE-ICZCrushingColumn_Index
                dc.w    loc_57CE6-ICZCrushingColumn_Index
                dc.w    loc_57D0C-ICZCrushingColumn_Index
                dc.w    loc_57D14-ICZCrushingColumn_Index
                dc.w    loc_57D5A-ICZCrushingColumn_Index
                dc.w    loc_57D7E-ICZCrushingColumn_Index
                dc.w    loc_57D8E-ICZCrushingColumn_Index
                dc.w    loc_57DA4-ICZCrushingColumn_Index
                dc.w    loc_57DC0-ICZCrushingColumn_Index
                dc.w    loc_57DDC-ICZCrushingColumn_Index
; ---------------------------------------------------------------------------

loc_57C90:
                lea     ObjDat_ICZCrushingColumn(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$70,y_radius(a0)
                move.w  y_pos(a0),$3E(a0)
                move.w  #$1F,$2E(a0)
                cmpi.b  #3,subtype(a0)
                bhs.s   loc_57CC0
                move.b  #$C,mapping_frame(a0)
                lea     ChildObjDat_57E30(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_57CC0:
                move.b  subtype(a0),d0
                add.b   d0,d0
                move.b  d0,routine(a0)

locret_57CCA:
                rts
; ---------------------------------------------------------------------------

loc_57CCC:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   locret_57CCA

loc_57CD6:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_57CDE:
                subq.w  #1,$2E(a0)
                bmi.s   loc_57CD6
                rts
; ---------------------------------------------------------------------------

loc_57CE6:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                cmpi.w  #$28,d2
                blo.w   locret_57CCA
                btst    #0,render_flags(a0)
                beq.s   loc_57D00
                subq.w  #2,d0

loc_57D00:
                tst.w   d0
                beq.s   locret_57CCA

loc_57D04:
                move.b  #$E,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_57D0C:
                subq.w  #1,$2E(a0)
                bmi.s   loc_57D04
                rts
; ---------------------------------------------------------------------------

loc_57D14:
                move.w  y_vel(a0),d0
                addi.w  #-$20,d0
                cmpi.w  #-$400,d0
                ble.s   loc_57D26
                move.w  d0,y_vel(a0)

loc_57D26:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.w   locret_57CCA

loc_57D38:
                add.w   d1,y_pos(a0)
                move.b  #$10,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_57D92,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_57D5A:
                move.w  y_vel(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$400,d0
                bgt.s   loc_57D6C
                move.w  d0,y_vel(a0)

loc_57D6C:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_57D38
                rts
; ---------------------------------------------------------------------------

loc_57D7E:
                addq.w  #8,y_pos(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_57D38
                rts
; ---------------------------------------------------------------------------

loc_57D8E:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_57D92:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  byte_57DA0-1(pc,d0.w),routine(a0)
                rts
; ---------------------------------------------------------------------------
byte_57DA0:
                dc.b    $14, $14, $16, $12
                even
; ---------------------------------------------------------------------------

loc_57DA4:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                cmp.w   $3E(a0),d0
                bls.s   loc_57DB6
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_57DB6:
                move.w  #$5F,$2E(a0)
                bra.w   loc_57CC0
; ---------------------------------------------------------------------------

loc_57DC0:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                cmp.w   $3E(a0),d0
                bhs.s   loc_57DD2
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_57DD2:
                move.w  #$5F,$2E(a0)
                bra.w   loc_57CC0
; ---------------------------------------------------------------------------

loc_57DDC:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                btst    #0,render_flags(a0)
                beq.s   loc_57DEE
                subq.w  #2,d0

loc_57DEE:
                tst.w   d0
                bne.w   locret_57CCA
                move.b  #$12,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_57DFC:
                move.l  #loc_57E0A,(a0)
                lea     word_57E2A(pc),a1
                jsr     SetUp_ObjAttributes3(pc)

loc_57E0A:
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
word_57E2A:
                dc.w    $280
                dc.b    $20, $40,  $D,   0
ChildObjDat_57E30:
                dc.w    1-1
                dc.l    loc_57DFC
                dc.b    0,   0
