; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace ship and crane child attachments, parent-relative offsets and movement responses
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_6502E:
                lea     ObjDat3_664FA(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_65048,(a0)
                lea     ChildObjDat_66610(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_65048:
                btst    #0,(_unkFAB8).w
                bne.s   loc_6505C
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6505C:
                move.l  #loc_65068,(a0)
                move.b  child_dy(a0),$3A(a0)

loc_65068:
                move.w  (_unkFABA).w,d0
                beq.s   loc_6509A
                movea.w d0,a1
                move.w  y_pos(a1),d0
                subi.w  #$18,d0
                cmp.w   y_pos(a0),d0
                bls.s   loc_650A6
                move.w  y_vel(a0),d0
                addi.w  #$80,d0
                bmi.s   loc_6508C
                move.w  d0,y_vel(a0)

loc_6508C:
                move.b  y_vel(a0),d2
                move.b  $3A(a0),d3
                add.b   d2,d3
                move.b  d3,child_dy(a0)

loc_6509A:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_650A6:
                move.l  #loc_650D4,(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #$14,(Screen_shake_flag).w
                moveq   #signextendB(sfx_BigRumble),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_6661E(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     ChildObjDat_66638(pc),a2
                jsr     (CreateChild6_Simple).l

loc_650D4:
                move.w  y_vel(a0),d2
                subi.w  #$80,d2
                bpl.s   loc_650FA
                move.l  #loc_6510C,(a0)
                moveq   #0,d2
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                movea.w (_unkFABA).w,a2
                bset    #7,art_tile(a2)

loc_650FA:
                move.w  d2,y_vel(a0)
                move.b  y_vel(a0),d2
                move.b  $3A(a0),d3
                add.b   d2,d3
                move.b  d3,child_dy(a0)

loc_6510C:
                jsr     (Refresh_ChildPositionAdjusted).l
                move.w  (_unkFABA).w,d0
                beq.s   loc_65132
                movea.w d0,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),d0
                move.b  (_unkFABD).w,d1
                ext.w   d1
                neg.w   d1
                add.w   d1,d0
                move.w  d0,y_pos(a1)

loc_65132:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_65138:
                lea     word_66506(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_65148,(a0)

loc_65148:
                jsr     (Refresh_ChildPositionAdjusted).l
                move.b  mapping_frame(a1),d0
                addq.b  #1,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6515E:
                lea     word_6650C(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_6516E,(a0)

loc_6516E:
                movea.w parent3(a0),a1
                move.b  y_vel(a1),d0
                lsr.b   #4,d0
                addq.b  #4,d0
                move.b  d0,mapping_frame(a0)
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; End of function loc_6502E
