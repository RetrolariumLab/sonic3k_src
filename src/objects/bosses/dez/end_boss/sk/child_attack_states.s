; Owner: objects/bosses/dez/end_boss/sk
; Responsibility: Death Egg end-boss child attacks, destruction effects, attached actors and battle callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_7F4B8:
                move.l  #loc_7F4EE,$34(a0)

loc_7F4C0:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_7F4D4
                move.b  #6,subtype(a1)

loc_7F4D4:
                move.l  #Wait_Draw,(a0)
                movea.w parent3(a0),a1
                subq.b  #1,$39(a1)
                move.w  #7,$2E(a0)
                jmp     (Draw_Sprite).l
; End of function sub_7F4B8

; ---------------------------------------------------------------------------

loc_7F4EE:
                lea     ChildObjDat_7FCB4(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7F4FA:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_7F51E(pc,d0.w),d1
                jsr     off_7F51E(pc,d1.w)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   sub_7F4AC
                bsr.w   sub_7FB4E
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
off_7F51E:
                dc.w    loc_7F528-off_7F51E
                dc.w    loc_7F538-off_7F51E
                dc.w    loc_7F568-off_7F51E
                dc.w    loc_7F5D2-off_7F51E
                dc.w    loc_7F5FC-off_7F51E
; ---------------------------------------------------------------------------

loc_7F528:
                bsr.w   sub_7F900
                bsr.w   sub_7F8CA
                subq.w  #1,$2E(a0)
                bmi.s   loc_7F55A
                rts
; ---------------------------------------------------------------------------

loc_7F538:
                jsr     (MoveSprite2).l
                bsr.w   sub_7F9A8
                bsr.w   sub_7FA60
                lea     byte_7FCDE(pc),a1
                jsr     Animate_RawNoSST(pc)
                bsr.w   sub_7F8CA
                subq.w  #1,$2E(a0)
                bpl.w   locret_7F0D8

loc_7F55A:
                move.b  #8,routine(a0)
                move.w  #$1F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_7F568:
                jsr     (sub_7F8A0).l

loc_7F56E:
                bsr.w   sub_7F9F8
                tst.w   y_vel(a0)
                bpl.s   loc_7F5A0
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   locret_7F5D0
                sub.w   d1,y_pos(a0)
                st      $3A(a0)
                btst    #1,render_flags(a0)
                bne.s   loc_7F5BA

loc_7F592:
                move.b  #0,routine(a0)
                move.b  #$C6,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_7F5A0:
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   locret_7F5D0
                add.w   d1,y_pos(a0)
                clr.b   $3A(a0)
                btst    #1,render_flags(a0)
                bne.s   loc_7F592

loc_7F5BA:
                move.b  #2,routine(a0)
                move.b  #$C6,collision_flags(a0)
                move.w  $3C(a0),x_vel(a0)
                clr.w   y_vel(a0)

locret_7F5D0:
                rts
; ---------------------------------------------------------------------------

loc_7F5D2:
                subq.w  #1,child_dx(a0)
                bne.s   loc_7F5DE
                bchg    #1,render_flags(a0)

loc_7F5DE:
                jsr     (sub_7F8A0).l
                bsr.w   sub_7FA60
                move.w  #$80,d0
                tst.w   x_vel(a0)
                bpl.s   loc_7F5F4
                neg.w   d0

loc_7F5F4:
                move.w  d0,$3C(a0)
                bra.w   loc_7F56E
; ---------------------------------------------------------------------------

loc_7F5FC:
                subq.w  #1,$2E(a0)
                bpl.s   locret_7F608
                bsr.w   sub_7F4B8
                addq.w  #4,sp

locret_7F608:
                rts
; ---------------------------------------------------------------------------

loc_7F60A:
                lea     word_7FC68(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_7F62E,(a0)
                jsr     Refresh_ChildPositionAdjusted(pc)
                bsr.w   sub_7FB1A
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                move.w  a1,parent3(a0)
                rts
; ---------------------------------------------------------------------------

loc_7F62E:
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_7F644
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

loc_7F644:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_7F64A:
                lea     word_7FC56(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_7F66C,(a0)
                move.l  #byte_7FCEF,$30(a0)
                lea     ChildObjDat_7FCAE(pc),a2
                jsr     CreateChild6_Simple(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7F66C:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_7F684
                jsr     Refresh_ChildPosition(pc)
                jsr     Animate_RawMultiDelay(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7F684:
                move.l  #loc_7F690,(a0)
                move.w  #$10,$2E(a0)

loc_7F690:
                subq.w  #1,$2E(a0)
                bmi.s   loc_7F6AE
                bchg    #2,$38(a0)
                bne.s   loc_7F6A2
                addq.b  #1,child_dy(a0)

loc_7F6A2:
                jsr     Refresh_ChildPosition(pc)
                jsr     Animate_RawMultiDelay(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7F6AE:
                move.l  #loc_7F6BA,(a0)
                move.w  #7,$2E(a0)

loc_7F6BA:
                subq.w  #1,$2E(a0)
                bmi.s   loc_7F6CC
                jsr     Refresh_ChildPosition(pc)
                jsr     Animate_RawMultiDelay(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7F6CC:
                move.l  #loc_7F6D2,(a0)

loc_7F6D2:
                bchg    #2,$38(a0)
                bne.s   loc_7F6DE
                subq.b  #1,child_dy(a0)

loc_7F6DE:
                jsr     Refresh_ChildPosition(pc)
                jsr     Animate_RawMultiDelay(pc)
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_7F6F6
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7F6F6:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7F6FA:
                lea     word_7FC5C(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_7F708,(a0)

loc_7F708:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7F71C:
                lea     ObjDat3_7FC74(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_70068,(a0)
                move.l  #loc_7F74C,$34(a0)
                move.l  #byte_7FCE2,$30(a0)
                move.w  #$3610,x_pos(a0)
                move.w  #$324,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7F74C:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                sub.w   d1,d0
                bmi.s   loc_7F76A
                cmpi.w  #$40,d0
                bhs.s   loc_7F76A
                addi.w  #$40,d1
                move.w  d1,x_pos(a0)

loc_7F76A:
                lea     (byte_70419).l,a1
                jsr     (Animate_RawNoSST).l
                jsr     (MoveSprite2).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_7F782:
                lea     ObjDat3_7FC80(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_7F79C,(a0)
                move.w  #$3600,x_pos(a0)
                move.w  #$32C,y_pos(a0)

loc_7F79C:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                beq.s   loc_7F7C8
                move.l  #Sprite_OnScreen_Test,(a0)
                move.b  #$15,mapping_frame(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_7F7C8
                move.b  #6,subtype(a1)

loc_7F7C8:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7F7CE:
                lea     word_7FC6E(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #Obj_FlickerMove,(a0)
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                addi.b  #$22,d0
                move.b  d0,mapping_frame(a0)
                moveq   #8,d0
                jsr     Set_IndexedVelocity(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7F7F6:
                move.l  #loc_7F81E,(a0)
                addi.w  #$38,y_pos(a0)
                move.w  #$1010,$3A(a0)
                moveq   #2,d0
                moveq   #4,d1
                tst.b   subtype(a0)
                beq.s   loc_7F816
                neg.w   d0
                moveq   #2,d1

loc_7F816:
                move.w  d0,x_vel(a0)
                move.b  d1,$39(a0)

loc_7F81E:
                subq.b  #1,$39(a0)
                bpl.s   loc_7F830
                move.b  #3,$39(a0)
                jsr     (sub_83E84).l

loc_7F830:
                move.w  x_vel(a0),d0
                move.w  x_pos(a0),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                tst.w   d0
                bmi.s   loc_7F84C
                move.w  #$35D0,d2
                cmp.w   d2,d1
                bhs.s   loc_7F854
                rts
; ---------------------------------------------------------------------------

loc_7F84C:
                move.w  #$3450,d2
                cmp.w   d2,d1
                bhi.s   locret_7F870

loc_7F854:
                move.w  d2,x_pos(a0)
                move.l  #loc_7F872,(a0)
                move.w  #-2,y_vel(a0)
                tst.b   subtype(a0)
                bne.s   locret_7F870
                bset    #1,(_unkFAB8).w

locret_7F870:
                rts
; ---------------------------------------------------------------------------

loc_7F872:
                subq.b  #1,$39(a0)
                bpl.s   loc_7F884
                move.b  #3,$39(a0)
                jsr     (sub_83E84).l

loc_7F884:
                move.w  y_vel(a0),d0
                move.w  y_pos(a0),d1
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                cmpi.w  #$240,d1
                bhs.w   locret_7F0D8
                jmp     (Delete_Current_Sprite).l
