; Owner: objects/bosses/lbz/final_boss_2/s3
; Responsibility: Launch Base second final boss attachments, arms, circular motion, attack actors and detached effects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_511CE:
                lea     ObjDat3_51F24(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_511DC,(a0)

loc_511DC:
                jsr     Child_GetPriorityOnce(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_511E8:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_511FC(pc,d0.w),d1
                jsr     off_511FC(pc,d1.w)
                moveq   #$C,d0
                jmp     Child_DrawTouch_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------
off_511FC:
                dc.w    loc_51202-off_511FC
                dc.w    loc_51226-off_511FC
                dc.w    loc_5124E-off_511FC
; ---------------------------------------------------------------------------

loc_51202:
                lea     ObjDat3_51F30(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                movea.w parent3(a0),a1
                move.w  a0,$44(a1)
                move.b  #$14,child_dx(a0)
                move.b  #-6,child_dy(a0)
                lea     ChildObjDat_51FD6(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_51226:
                movea.w parent3(a0),a1
                btst    #7,art_tile(a1)
                beq.s   loc_51244
                bset    #7,art_tile(a0)
                move.b  #4,routine(a0)
                move.b  #$AD,collision_flags(a0)

loc_51244:
                lea     (LBZFinalBoss2_CircleLookup).l,a2
                jmp     MoveSprite_CircularLookup(pc)
; ---------------------------------------------------------------------------

loc_5124E:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.w   locret_50DD2
                btst    #2,$38(a1)
                bne.s   loc_51298
                lea     (Player_1).w,a1
                move.b  $3C(a0),d0
                move.w  y_pos(a0),d1
                sub.w   y_pos(a1),d1
                cmpi.w  #-2,d1
                blt.s   loc_5128C
                cmpi.w  #2,d1
                ble.s   loc_51298
                subq.b  #1,d0
                cmpi.b  #-$30,d0
                blt.s   loc_51298
                bra.w   loc_51294
; ---------------------------------------------------------------------------

loc_5128C:
                addq.b  #1,d0
                cmpi.b  #0,d0
                bgt.s   loc_51298

loc_51294:
                move.b  d0,$3C(a0)

loc_51298:
                jsr     Change_FlipXUseParent(pc)
                lea     (LBZFinalBoss2_CircleLookup).l,a2
                jmp     MoveSprite_CircularLookup(pc)
; ---------------------------------------------------------------------------

loc_512A6:
                lea     word_51F42(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_512D4,(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a2
                move.w  a2,parent3(a0)
                move.w  a1,$44(a0)
                move.w  a1,$44(a0)
                move.b  #$18,child_dx(a0)
                move.b  #-6,child_dy(a0)

loc_512D4:
                jsr     Child_GetPriorityOnce(pc)
                jsr     Change_FlipXUseParent(pc)
                movea.w $44(a0),a1
                move.b  $3C(a1),d0
                addi.b  #$14,d0
                move.b  d0,$3C(a0)
                lea     (LBZ2FinalBoss2_CircleLookup2).l,a2
                jsr     MoveSprite_CircularLookup(pc)
                moveq   #$C,d0
                jmp     Child_DrawTouch_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------

loc_512FC:
                lea     word_51F3C(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                move.l  #loc_51336,(a0)
                move.l  #byte_5205A,$30(a0)
                tst.b   subtype(a0)
                beq.s   loc_51336
                move.b  #8,mapping_frame(a0)
                move.w  #$180,priority(a0)
                move.l  #byte_52062,$30(a0)

loc_51336:
                jsr     Child_GetPriorityOnce(pc)

loc_5133A:
                jsr     Refresh_ChildPositionAdjusted(pc)
                jsr     Animate_Raw(pc)
                movea.w $44(a0),a1
                tst.b   $30(a1)
                beq.s   loc_51368
                move.l  #loc_5136E,(a0)
                move.b  #7,mapping_frame(a0)
                tst.b   subtype(a0)
                beq.s   loc_51368
                move.b  #$B,mapping_frame(a0)
                addq.b  #8,child_dx(a0)

loc_51368:
                moveq   #$C,d0
                jmp     Child_DrawTouch_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------

loc_5136E:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w $44(a0),a1
                tst.b   $30(a1)
                bne.s   loc_5138C
                move.l  #loc_5133A,(a0)
                tst.b   subtype(a0)
                beq.s   loc_5138C
                subq.b  #8,child_dx(a0)

loc_5138C:
                moveq   #$C,d0
                jmp     Child_DrawTouch_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------

loc_51392:
                lea     ObjDat3_51F48(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_513A0,(a0)

loc_513A0:
                jsr     Child_GetPriorityOnce(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_513AC:
                lea     ObjDat3_51F54(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_513BA,(a0)

loc_513BA:
                move.b  #$9A,d0
                bsr.w   LBZBoss2Child_LatchPriorityAndColl
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_513E2
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_50DD2
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_513E2:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_513E8:
                move.l  #loc_513F4,(a0)
                move.b  #$99,collision_flags(a0)

loc_513F4:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_513E2
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

loc_5140A:
                move.l  #loc_5141A,(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)

loc_5141A:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   loc_5145E
                btst    #3,$38(a1)
                bne.w   locret_50DD2
                btst    #6,status(a1)
                bne.w   locret_50DD2
                lea     word_51468(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                beq.s   locret_5145C
                movea.w d0,a1
                tst.b   invulnerability_timer(a1)
                bne.s   locret_5145C
                cmpi.b  #6,routine(a1)
                blo.s   loc_51470

locret_5145C:
                rts
; ---------------------------------------------------------------------------

loc_5145E:
                clr.b   (Player_1+object_control).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
word_51468:
                dc.w    -$18,   $30,  -$18,   $30
; ---------------------------------------------------------------------------

loc_51470:
                move.l  #loc_514B0,(a0)
                movea.w $44(a0),a1
                st      $30(a1)
                move.b  #$1E,routine(a1)
                move.w  #$40,$2E(a1)
                move.l  #loc_50FB0,$34(a1)
                lea     (Player_1).w,a1
                move.b  #$81,object_control(a1)
                move.b  #2,anim(a1)
                moveq   #0,d0
                move.w  d0,x_vel(a1)
                move.w  d0,y_vel(a1)
                move.w  d0,ground_vel(a1)

loc_514B0:
                movea.w $44(a0),a1
                tst.b   $30(a1)
                beq.s   loc_514DA
                btst    #7,status(a1)
                bne.w   loc_513E2
                jsr     Refresh_ChildPositionAdjusted(pc)
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                rts
; ---------------------------------------------------------------------------

loc_514DA:
                move.l  #loc_514E6,(a0)
                move.w  #$40,$2E(a0)

loc_514E6:
                subq.w  #1,$2E(a0)
                bmi.s   loc_514EE
                rts
; ---------------------------------------------------------------------------

loc_514EE:
                move.l  #loc_5141A,(a0)
                rts
; ---------------------------------------------------------------------------

loc_514F6:
                lea     ObjDat3_51F60(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$D,d0
                move.b  d0,mapping_frame(a0)
                moveq   #0,d0
                jsr     Set_IndexedVelocity(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_51524:
                move.l  #loc_5155A,(a0)
                move.w  #$4430,x_pos(a0)
                move.w  #$728,y_pos(a0)
                move.w  #$1010,$3A(a0)
                move.w  #$200,d0
                tst.b   subtype(a0)
                beq.s   loc_51548
                neg.w   d0

loc_51548:
                move.w  d0,x_vel(a0)
                move.w  #$41,$2E(a0)
                move.l  #loc_51576,$34(a0)

loc_5155A:
                subq.b  #1,$39(a0)
                bpl.s   loc_5156C
                move.b  #3,$39(a0)
                jsr     (BossExplosionS3SpawnAtMaskedRandomOffset).l

loc_5156C:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_51576:
                clr.w   x_vel(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$57,$2E(a0)
                move.l  #loc_51590,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_51590:
                lea     Child6_CreateBossExplosion(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   loc_515AC
                move.w  #$4430,x_pos(a1)
                move.w  #$678,y_pos(a1)
                move.b  #$C,subtype(a1)

loc_515AC:
                tst.b   subtype(a0)
                bne.s   loc_515DE
                jsr     (AllocateObject).l
                bne.s   loc_515DE
                move.l  #loc_515E2,(a1)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$D0,d0
                move.w  d0,x_pos(a1)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a1)
                move.w  #5,$3A(a1)

loc_515DE:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

loc_515E2:
                subq.w  #1,$2E(a0)
                bpl.s   locret_51618
                addq.b  #1,$39(a0)
                cmpi.b  #8,$39(a0)
                bne.s   loc_515F8
                st      (Events_fg_5).w

loc_515F8:
                cmpi.b  #$18,$39(a0)
                bcc.s   loc_5161A
                move.w  $3A(a0),$2E(a0)
                addq.w  #1,$3A(a0)
                jsr     (AllocateObject).l
                bne.s   locret_51618
                move.l  #loc_5165C,(a1)

locret_51618:
                rts
; ---------------------------------------------------------------------------

loc_5161A:
                move.l  #loc_51626,(a0)
                move.w  #$17F,$2E(a0)

loc_51626:
                subq.w  #1,$2E(a0)
                bmi.s   loc_5162E
                rts
; ---------------------------------------------------------------------------

loc_5162E:
                bset    #0,(_unkFA88).w
                clr.b   $39(a0)
                clr.w   $2E(a0)
                jsr     (AllocateObject).l
                bne.s   loc_51650
                move.l  #loc_517FE,(a1)
                move.b  #4,subtype(a1)

loc_51650:
                lea     ChildObjDat_52016(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

loc_5165C:
                lea     ObjDat3_51F6C(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #MoveChkDel,(a0)
                jsr     (Random_Number).l
                andi.w  #7,d0
                move.b  RawAni_5169C(pc,d0.w),mapping_frame(a0)
                swap    d0
                andi.w  #$FF,d0
                move.w  (Camera_X_pos).w,d1
                addi.w  #$20,d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
RawAni_5169C:
                dc.b    7,   8,   9,  $A,  $B,   7,   8,   9
                even
