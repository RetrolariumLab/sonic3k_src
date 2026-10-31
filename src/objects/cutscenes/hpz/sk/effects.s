; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace transient effects, fragments, timed motion and chain child construction
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_6518A:
                lea     ObjDat3_66512(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_651AC,(a0)
                addi.w  #$30,y_pos(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)

loc_651AC:
                subq.w  #1,$2E(a0)
                bmi.s   loc_651B4
                rts
; ---------------------------------------------------------------------------

loc_651B4:
                move.l  #loc_651E2,(a0)
                jsr     (Random_Number).l
                andi.w  #$3F,d0
                subi.w  #$20,d0
                add.w   d0,x_pos(a0)
                swap    d0
                andi.w  #$3F,d0
                subi.w  #$20,d0
                add.w   d0,y_pos(a0)
                move.l  #loc_651F2,$34(a0)

loc_651E2:
                lea     byte_66843(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_651F2:
                move.l  #loc_6520A,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_6520A:
                lea     byte_6684A(pc),a1
                jsr     (Animate_RawNoSST).l
                subi.w  #$80,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_65226:
                lea     ObjDat3_6651E(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_65276,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                move.w  byte_65262(pc,d0.w),child_dx(a0)  ; and child_dy
                move.w  word_6526C(pc,d0.w),$2E(a0)
                lsr.w   #1,d1
                move.b  RawAni_6525C(pc,d1.w),mapping_frame(a0)
                move.l  #loc_65288,$34(a0)
                rts
; ---------------------------------------------------------------------------
RawAni_6525C:
                dc.b    $1C, $1B, $1A, $19, $18
                even
byte_65262:
                dc.b    4, $2C
                dc.b    -2, $2A
                dc.b    6, $22
                dc.b    -8, $24
                dc.b    -2, $1C
word_6526C:
                dc.w    $20
                dc.w    $30
                dc.w    $40
                dc.w    $50
                dc.w    $60
; ---------------------------------------------------------------------------

loc_65276:
                jsr     (Refresh_ChildPosition).l
                jsr     (Obj_Wait).l
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

loc_65288:
                move.l  #loc_65296,(a0)
                bset    #7,art_tile(a0)
                rts
; ---------------------------------------------------------------------------

loc_65296:
                jsr     (MoveSprite).l
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

loc_652A2:
                move.l  #loc_652FE,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     byte_652DE(pc,d0.w),a1
                move.w  (Camera_X_pos).w,d1
                addi.w  #$140,d1
                move.w  (Camera_Y_pos).w,d2
                addi.w  #$C0,d2
                move.b  (a1)+,d3
                ext.w   d3
                add.w   d3,d1
                move.w  d1,x_pos(a0)
                move.b  (a1)+,d3
                ext.w   d3
                add.w   d3,d2
                move.w  d2,y_pos(a0)
                lsl.w   #2,d0
                move.w  d0,$2E(a0)
                rts
; ---------------------------------------------------------------------------
byte_652DE:
                dc.b    -$10, -$58
                dc.b    -$18, -$30
                dc.b    -8, -$10
                dc.b    -$10, -$70
                dc.b    -$20, -$60
                dc.b    -8, -$38
                dc.b    -$20, -$10
                dc.b    -$20, -$40
                dc.b    -$40, -$58
                dc.b    -$30, -$30
                dc.b    -$40,   -8
                dc.b    -$48, -$38
                dc.b    -$38, -$20
                dc.b    -$60, -$40
                dc.b    -$58, -$20
                dc.b    -$70,   -8
                even
; ---------------------------------------------------------------------------

loc_652FE:
                subq.w  #1,$2E(a0)
                bpl.w   locret_6206C
                lea     (Obj_Explosion).l,a1
                move.l  a1,(a0)
                move.b  #2,routine(a0)
                jsr     (a1)
                bset    #7,art_tile(a0)
                rts
; ---------------------------------------------------------------------------

loc_6531E:
                lea     ObjDat3_6652A(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_65348,(a0)
                move.w  #4*60,$2E(a0)
                lea     ChildObjDat3_6662C(pc),a2
                tst.b   subtype(a0)
                beq.s   loc_65342
                lea     ChildObjDat3_66632(pc),a2

loc_65342:
                jmp     (CreateChild8_TreeListRepeated).l
; ---------------------------------------------------------------------------

loc_65348:
                subq.w  #1,$2E(a0)
                bne.s   loc_65354
                bset    #7,$38(a0)

loc_65354:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
