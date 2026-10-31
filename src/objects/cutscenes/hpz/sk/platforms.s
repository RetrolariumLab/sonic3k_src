; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace scene platforms, collisions, displacement and timed display callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_655B2:
                lea     ObjDat3_6653C(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_655CE,(a0)
                move.w  #$17F0,x_pos(a0)
                move.w  #$660,y_pos(a0)

loc_655CE:
                moveq   #$1B,d1
                moveq   #$20,d2
                moveq   #$20,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                tst.b   (_unkFAA2).w
                beq.s   loc_655F4
                lea     ChildObjDat_6664A(pc),a2
                jsr     (CreateChild6_Simple).l
                jsr     (Go_Delete_Sprite).l

loc_655F4:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
; unused
                dc.w    -$18,   $30,  -$20,   $40
; ---------------------------------------------------------------------------

loc_65602:
                lea     word_66548(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_6561C,(a0)
                bset    #7,render_flags(a0)
                bra.w   loc_662C0
; ---------------------------------------------------------------------------

loc_6561C:
                tst.b   render_flags(a0)
                bpl.s   loc_6562E
                jsr     (MoveSprite_LightGravity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6562E:
                jsr     (Displace_PlayerOffObject).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_6563A:
                lea     ObjDat3_6654E(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_65662,(a0)
                move.w  #$63,$2E(a0)
                tst.b   subtype(a0)
                beq.w   locret_6206C
                move.l  #Wait_Draw,(a0)
                bra.w   loc_65692
; ---------------------------------------------------------------------------

loc_65662:
                subq.w  #1,$2E(a0)
                bmi.s   loc_65678
                lea     byte_66875(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_65678:
                move.l  #Wait_Draw,(a0)
                clr.b   mapping_frame(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_65692,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_65692:
                move.b  #5,mapping_frame(a0)
                move.w  #$B,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
