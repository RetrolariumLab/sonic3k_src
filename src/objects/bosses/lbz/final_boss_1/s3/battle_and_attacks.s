; Owner: objects/bosses/lbz/final_boss_1/s3
; Responsibility: Launch Base first final boss battle state, attacks and coordinated child actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZFinalBoss1:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZFinalBoss1_Index(pc,d0.w),d1
                jsr     LBZFinalBoss1_Index(pc,d1.w)
                bsr.w   LBZBoss1_HandleHitOrDefeat
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
LBZFinalBoss1_Index:
                dc.w    loc_4F9CE-LBZFinalBoss1_Index
                dc.w    loc_4FA2E-LBZFinalBoss1_Index
                dc.w    loc_4FA46-LBZFinalBoss1_Index
                dc.w    locret_4FAC2-LBZFinalBoss1_Index
                dc.w    loc_4FAC4-LBZFinalBoss1_Index
                dc.w    loc_4FADA-LBZFinalBoss1_Index
; ---------------------------------------------------------------------------

loc_4F9CE:
                lea     ObjDat_LBZFinalBoss1(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #9,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.w  #$7F,$2E(a0)
                move.l  #loc_4FA32,$34(a0)
                moveq   #PLCID_71,d0
                jsr     (Load_PLC).l
                jsr     (AllocateObject).l
                bne.s   loc_4FA0C
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

loc_4FA0C:
                lea     (Child1_MakeRoboHead3).l,a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_503B8(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_5032E(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_503B0(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

loc_4FA2E:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4FA32:
                move.b  #4,routine(a0)
                move.w  #-$100,y_vel(a0)
                lea     Pal_LBZFinalBoss1(pc),a1
                jmp     PalLoad_Line1(pc)
; ---------------------------------------------------------------------------

loc_4FA46:
                move.w  y_pos(a0),d0
                move.w  (Camera_Y_pos).w,d1
                tst.w   y_vel(a0)
                bmi.s   loc_4FA62
                addi.w  #$118,d1
                cmp.w   d1,d0
                bhs.s   loc_4FA70
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_4FA62:
                subi.w  #$B0,d1
                cmp.w   d1,d0
                bls.s   loc_4FA70
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_4FA70:
                cmpi.b  #2,collision_property(a0)
                bls.s   loc_4FA80
                btst    #3,$38(a0)
                beq.s   locret_4FABC

loc_4FA80:
                jsr     (Random_Number).l
                swap    d0
                moveq   #0,d1
                bclr    #0,render_flags(a0)
                btst    #0,d0
                beq.s   loc_4FA9E
                moveq   #2,d1
                bset    #0,render_flags(a0)

loc_4FA9E:
                move.w  word_4FABE(pc,d1.w),d1
                move.w  (Camera_X_pos).w,d2
                add.w   d1,d2
                move.w  d2,x_pos(a0)
                move.w  #$100,d0
                tst.w   y_vel(a0)
                bmi.s   loc_4FAB8
                neg.w   d0

loc_4FAB8:
                move.w  d0,y_vel(a0)

locret_4FABC:
                rts
; ---------------------------------------------------------------------------
word_4FABE:
                dc.w    $110
                dc.w    $30
; ---------------------------------------------------------------------------

locret_4FAC2:
                rts
; ---------------------------------------------------------------------------

loc_4FAC4:
                subq.b  #1,$40(a0)
                bmi.s   loc_4FACC
                rts
; ---------------------------------------------------------------------------

loc_4FACC:
                move.b  #$A,routine(a0)
                move.b  #4,$40(a0)

locret_4FAD8:
                rts
; ---------------------------------------------------------------------------

loc_4FADA:
                addq.w  #8,y_pos(a0)
                subq.b  #1,$40(a0)
                bmi.s   loc_4FAE6
                rts
; ---------------------------------------------------------------------------

loc_4FAE6:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4FAEE:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$140,d1
                cmp.w   d1,d0
                bcc.s   loc_4FB0A
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FB0A:
                bset    #5,$38(a0)
                move.w  (Camera_X_pos).w,d2
                addi.w  #$100,d2
                move.w  d2,x_pos(a0)
                move.w  d1,y_pos(a0)
                bclr    #0,render_flags(a0)
                bclr    #7,art_tile(a0)
                jsr     (AllocateObject).l
                bne.s   loc_4FB46
                move.l  #Obj_LBZFinalBoss2,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)

loc_4FB46:
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_4FB4C:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                move.w  (Camera_Y_pos).w,d1
                subi.w  #$40,d1
                cmp.w   d1,d0
                bcs.s   loc_4FB68
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FB68:
                move.l  #loc_4FB8C,(a0)
                bset    #5,$38(a0)
                bset    #0,render_flags(a0)
                move.w  (Camera_X_pos).w,d2
                addi.w  #$40,d2
                move.w  d2,x_pos(a0)
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_4FB8C:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$40,d1
                cmp.w   d1,d0
                bcc.s   loc_4FBA8
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FBA8:
                move.l  #loc_4FBBE,(a0)
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FBBE:
                move.w  x_pos(a0),d0
                addq.w  #2,d0
                move.w  (Camera_X_pos).w,d1
                addi.w  #$A0,d1
                cmp.w   d1,d0
                bcc.s   loc_4FBDA
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FBDA:
                move.w  d0,x_pos(a0)
                move.l  #loc_4FBF2,(a0)
                lea     ChildObjDat_50326(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FBF2:
                move.w  x_pos(a0),d0
                addq.w  #2,d0
                move.w  (Camera_X_pos).w,d1
                addi.w  #$1C0,d1
                cmp.w   d1,d0
                bcc.s   loc_4FC0E
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FC0E:
                move.l  #loc_4FC26,(a0)
                bset    #6,status(a0)
                bset    #4,$38(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FC26:
                clr.b   (Boss_flag).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4FC30:
                lea     ObjDat3_502C0(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_4FC4E,(a0)
                move.l  #loc_4FC4E,$34(a0)
                lea     ChildObjDat_50382(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

loc_4FC4E:
                jsr     Refresh_ChildPositionAdjusted(pc)
                bsr.w   BreakOrSuspendLBZFinalBoss1BodySection
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_4FC5A:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                bne.s   loc_4FC86
                move.l  $34(a0),(a0)
                btst    #5,status(a1)
                beq.s   loc_4FC86
                subi.b  #$28,child_dy(a0)
                cmpi.b  #4,subtype(a0)
                bne.s   loc_4FC86
                bclr    #5,status(a1)

loc_4FC86:
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_4FC8A:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4FC90:
                move.w  #1,$3C(a0)
                bra.s   loc_4FC30
; ---------------------------------------------------------------------------

loc_4FC98:
                lea     ObjDat3_502CC(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_4FCBC,(a0)
                move.l  #loc_4FCBC,$34(a0)
                move.w  #2,$3C(a0)
                lea     ChildObjDat_503A2(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4FCBC:
                jsr     Refresh_ChildPositionAdjusted(pc)
                bsr.w   BreakOrSuspendLBZFinalBoss1BodySection
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_4FCC8:
                lea     word_502E0(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_4FCE0,(a0)
                move.w  #$60,$2E(a0)
                bsr.w   LBZBoss1Debris_InitFrameAndVel

loc_4FCE0:
                jsr     (MoveSprite).l
                jsr     TimedSprite_ScreenLock(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FCF0:
                move.l  #loc_4FCFE,(a0)
                lea     ObjDat3_50306(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_4FCFE:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_4FD14
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FD14:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4FD1A:
                lea     ObjDat3_50312(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_4FD36,(a0)
                tst.b   subtype(a0)
                beq.s   locret_4FD34
                move.b  #$22,mapping_frame(a0)

locret_4FD34:
                rts
; ---------------------------------------------------------------------------

loc_4FD36:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                beq.s   loc_4FD4C
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FD4C:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4FD52:
                lea     word_502E6(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_4FD76,(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                tst.b   subtype(a0)
                beq.s   loc_4FD76
                move.b  #8,$39(a0)

loc_4FD76:
                bsr.w   AdvanceLBZFinalBoss1CannonTurnCycle
                moveq   #4,d0
                jmp     Child_Draw_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------
; unused
                movea.w $44(a0),a1
                btst    #6,status(a1)
                bne.s   loc_4FD92
                move.l  #loc_4FD76,(a0)

loc_4FD92:
                moveq   #4,d0
                jmp     Child_Draw_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------

loc_4FD98:
                lea     word_502EC(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_4FDAE,(a0)
                move.w  #8,$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_4FDAE:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_4FDE4
                jsr     Refresh_ChildPositionAdjusted(pc)
                subq.w  #1,$2E(a0)
                bpl.w   locret_4FAD8
                move.w  $3A(a0),$2E(a0)
                subq.w  #1,$3A(a0)
                bpl.s   loc_4FDDE
                move.l  #loc_4FDEA,(a0)
                move.w  #$18,$2E(a0)

loc_4FDDE:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FDE4:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4FDEA:
                jsr     Refresh_ChildPositionAdjusted(pc)
                subq.w  #1,$2E(a0)
                bmi.s   loc_4FE04
                btst    #0,$2F(a0)
                bne.w   locret_4FAD8
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FE04:
                move.l  #loc_4FE20,(a0)
                move.l  #byte_503D3,$30(a0)
                move.l  #loc_4FE2E,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FE20:
                jsr     Refresh_ChildPositionAdjusted(pc)
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FE2E:
                move.l  #loc_4FE6A,(a0)
                tst.b   render_flags(a0)
                bpl.s   loc_4FE42
                moveq   #signextendB(sfx_Laser),d0
                jsr     (Play_SFX).l

loc_4FE42:
                move.b  #$9C,collision_flags(a0)
                move.b  #$11,mapping_frame(a0)
                moveq   #-$2C,d0
                move.w  #-$800,d1
                btst    #0,render_flags(a0)
                beq.s   loc_4FE60
                neg.w   d0
                neg.w   d1

loc_4FE60:
                add.w   d0,x_pos(a0)
                move.w  d1,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_4FE6A:
                btst    #0,(V_int_run_count+3).w
                bne.s   loc_4FE8A
                lea     ChildObjDat_5039A(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.l  #byte_503DB,$30(a1)
                bsr.w   RandomizeLBZFinalBoss1LaserTrailOffset
                bra.w   loc_4FE9E
; ---------------------------------------------------------------------------

loc_4FE8A:
                lea     ChildObjDat_5039A(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.l  #byte_503E1,$30(a1)
                bsr.w   RandomizeLBZFinalBoss1LaserTrailOffset

loc_4FE9E:
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

loc_4FEAA:
                lea     word_502F4(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_4FEC4,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jsr     Refresh_ChildPositionAdjusted(pc)

loc_4FEC4:
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4FECE:
                lea     word_502D8(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_4FEE6,(a0)
                move.l  #byte_503CE,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_4FEE6:
                jsr     Refresh_ChildPositionAdjusted(pc)
                jsr     Animate_Raw(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_4FEF2:
                lea     word_502B0(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_4FF02,(a0)
                rts
; ---------------------------------------------------------------------------

loc_4FF02:
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_4FF0A:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4FF1C(pc,d0.w),d1
                jsr     off_4FF1C(pc,d1.w)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
off_4FF1C:
                dc.w    loc_4FF22-off_4FF1C
                dc.w    loc_4FF3A-off_4FF1C
                dc.w    loc_4FF7A-off_4FF1C
; ---------------------------------------------------------------------------

loc_4FF22:
                lea     word_502B8(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.b  #$10,y_radius(a0)
                move.l  #loc_4FF4C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4FF3A:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   locret_4FAD8
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_4FF4C:
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                bcs.s   loc_4FF60
                asr.w   #1,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_4FF60:
                move.b  #4,routine(a0)
                lea     (AIZMiniS3_MissileImpactChildren).l,a2
                jsr     CreateChild1_Normal(pc)
                lea     (Child6_CreateBossExplosion).l,a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4FF7A:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4FF80:
                lea     ObjDat3_502FA(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_4FFB2,(a0)
                move.l  #byte_503E7,$30(a0)
                move.l  #loc_4FFC4,$34(a0)
                move.b  #-$14,child_dy(a0)
                tst.b   subtype(a0)
                beq.s   locret_4FFB0
                move.b  #$80,$3C(a0)

locret_4FFB0:
                rts
; ---------------------------------------------------------------------------

loc_4FFB2:
                jsr     Animate_Raw(pc)
                addq.b  #1,$3C(a0)
                moveq   #3,d2
                jsr     MoveSprite_CircularSimpleOffset(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_4FFC4:
                move.b  $39(a0),d0
                addq.b  #1,d0
                move.b  d0,$39(a0)
                andi.b  #3,d0
                andi.b  #$FC,render_flags(a0)
                or.b    d0,render_flags(a0)
                rts
