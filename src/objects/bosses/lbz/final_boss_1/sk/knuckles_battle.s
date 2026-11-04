; Owner: objects/bosses/lbz/final_boss_1/sk
; Responsibility: Launch Base Knuckles final-boss variant, coordinated actors, motion and collision helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZFinalBossKnux:
                lea     word_72FEA(pc),a1
                jsr     (Check_CameraInRange).l
                move.b  #mus_EndBoss,boss_saved_mus(a0)
                jsr     (Boss_BeginCameraTransition).l
                move.l  #loc_73046,(a0)
                move.l  #loc_7304C,$34(a0)
                clr.b   (_unkFAA2).w
                clr.b   (_unkFAA3).w
                moveq   #PLCID_71,d0
                jsr     (Load_PLC).l

; =============== S U B R O U T I N E =======================================

LBZFinalBoss_QueueShipAndExplosionArt:
                lea     PLC_LBZFinalBoss_Extra(pc),a1
                jmp     (Load_PLC_Raw).l
; End of function LBZFinalBoss_QueueShipAndExplosionArt

; ---------------------------------------------------------------------------
PLC_LBZFinalBoss_Extra: plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_LBZFinalBoss_Extra_End:
; ---------------------------------------------------------------------------

loc_73046:
                jmp     (SKEndCamera_TickAndSaveMusic).l
; ---------------------------------------------------------------------------

loc_7304C:
                move.l  #Obj_LBZFinalBoss1,(a0)
                rts
; ---------------------------------------------------------------------------

loc_73054:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                move.w  (Camera_Y_pos).w,d1
                subi.w  #$50,d1
                cmp.w   d1,d0
                blo.s   loc_73070
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_73070:
                move.w  d1,y_pos(a0)
                bset    #5,$38(a0)
                jsr     (AllocateObject).l
                bne.s   loc_73088
                move.l  #Obj_LBZFinalBoss2,(a1)

loc_73088:
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_7308E:
                lea     ObjDat3_736D8(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_730B0,(a0)
                move.l  #loc_730B0,$34(a0)
                lea     ChildObjDat_737BA(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_730B0:
                jsr     (Refresh_ChildPositionAdjusted).l
                bsr.w   BreakOrSuspendLBZFinalBoss1BodySection
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_730C0:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                bne.s   loc_730EC
                move.l  $34(a0),(a0)
                btst    #5,status(a1)
                beq.s   loc_730EC
                subi.b  #$28,child_dy(a0)
                cmpi.b  #4,subtype(a0)
                bne.s   loc_730EC
                bclr    #5,status(a1)

loc_730EC:
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_730F2:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_730F8:
                move.w  #1,$3C(a0)
                bra.s   loc_7308E
; ---------------------------------------------------------------------------

loc_73100:
                lea     ObjDat3_736E4(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_73128,(a0)
                move.l  #loc_73128,$34(a0)
                move.w  #2,$3C(a0)
                lea     ChildObjDat_737DA(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_73128:
                jsr     (Refresh_ChildPositionAdjusted).l
                bsr.w   BreakOrSuspendLBZFinalBoss1BodySection
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_73138:
                lea     word_736F8(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_73152,(a0)
                move.w  #$60,$2E(a0)
                bsr.w   LBZBoss1Debris_InitFrameAndVel

loc_73152:
                jsr     (MoveSprite).l
                jsr     (TimedSprite_ScreenLock).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_73164:
                move.l  #loc_73174,(a0)
                lea     ObjDat3_7371E(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

loc_73174:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_7318C
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7318C:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_73192:
                lea     ObjDat3_7372A(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_731B0,(a0)
                tst.b   subtype(a0)
                beq.s   locret_731AE
                move.b  #$22,mapping_frame(a0)

locret_731AE:
                rts
; ---------------------------------------------------------------------------

loc_731B0:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                beq.s   loc_731C8
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_731C8:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_731CE:
                lea     word_736FE(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_731F4,(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                tst.b   subtype(a0)
                beq.s   loc_731F4
                move.b  #8,$39(a0)

loc_731F4:
                bsr.w   AdvanceLBZFinalBoss1CannonTurnCycle
                moveq   #4,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
; unused
                movea.w $44(a0),a1
                btst    #6,status(a1)
                bne.s   loc_73212
                move.l  #loc_731F4,(a0)

loc_73212:
                moveq   #4,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_7321A:
                lea     word_73704(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_73232,(a0)
                move.w  #8,$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_73232:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_7326A
                jsr     (Refresh_ChildPositionAdjusted).l
                subq.w  #1,$2E(a0)
                bpl.w   locret_72B02
                move.w  $3A(a0),$2E(a0)
                subq.w  #1,$3A(a0)
                bpl.s   loc_73264
                move.l  #loc_73270,(a0)
                move.w  #$18,$2E(a0)

loc_73264:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7326A:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_73270:
                jsr     (Refresh_ChildPositionAdjusted).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_7328C
                btst    #0,$2F(a0)
                bne.w   locret_72B02
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7328C:
                move.l  #loc_732A8,(a0)
                move.l  #byte_73849,$30(a0)
                move.l  #loc_732BA,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_732A8:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_732BA:
                move.l  #loc_732F6,(a0)
                tst.b   render_flags(a0)
                bpl.s   loc_732CE
                moveq   #signextendB(sfx_Laser),d0
                jsr     (Play_SFX).l

loc_732CE:
                move.b  #$9C,collision_flags(a0)
                move.b  #$11,mapping_frame(a0)
                moveq   #-$2C,d0
                move.w  #-$800,d1
                btst    #0,render_flags(a0)
                beq.s   loc_732EC
                neg.w   d0
                neg.w   d1

loc_732EC:
                add.w   d0,x_pos(a0)
                move.w  d1,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_732F6:
                btst    #0,(V_int_run_count+3).w
                bne.s   loc_73318
                lea     ChildObjDat_737D2(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #byte_73851,$30(a1)
                bsr.w   RandomizeLBZFinalBoss1LaserTrailOffset
                bra.w   loc_7332E
; ---------------------------------------------------------------------------

loc_73318:
                lea     ChildObjDat_737D2(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #byte_73857,$30(a1)
                bsr.w   RandomizeLBZFinalBoss1LaserTrailOffset

loc_7332E:
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

loc_7333A:
                lea     word_7370C(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_73358,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jsr     (Refresh_ChildPositionAdjusted).l

loc_73358:
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_73364:
                lea     word_736F0(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                bset    #4,shield_reaction(a0)
                move.l  #loc_73384,(a0)
                move.l  #byte_73844,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_73384:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Animate_Raw).l
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

loc_73396:
                lea     ObjDat3_73712(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_733CA,(a0)
                move.l  #byte_7385D,$30(a0)
                move.l  #loc_733E2,$34(a0)
                move.b  #-$14,child_dy(a0)
                tst.b   subtype(a0)
                beq.s   locret_733C8
                move.b  #$80,$3C(a0)

locret_733C8:
                rts
; ---------------------------------------------------------------------------

loc_733CA:
                jsr     (Animate_Raw).l
                addq.b  #1,$3C(a0)
                moveq   #3,d2
                jsr     (MoveSprite_CircularSimpleOffset).l
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

loc_733E2:
                move.b  $39(a0),d0
                addq.b  #1,d0
                move.b  d0,$39(a0)
                andi.b  #3,d0
                andi.b  #$FC,render_flags(a0)
                or.b    d0,render_flags(a0)
                rts

; =============== S U B R O U T I N E =======================================

AdvanceLBZFinalBoss1CannonTurnCycle:
                moveq   #0,d0
                move.b  $39(a0),d0
                subq.w  #1,$2E(a0)
                bmi.s   loc_7340E
                add.w   d0,d0
                bra.w   loc_73484
; ---------------------------------------------------------------------------

loc_7340E:
                movea.w $44(a0),a1
                btst    #0,render_flags(a1)
                sne     d2
                beq.s   loc_73426
                subq.b  #1,d0
                bpl.s   loc_73430
                moveq   #$B,d0
                bra.w   loc_73430
; ---------------------------------------------------------------------------

loc_73426:
                addq.b  #1,d0
                cmpi.b  #$C,d0
                blo.s   loc_73430
                moveq   #0,d0

loc_73430:
                move.b  d0,$39(a0)
                lea     byte_734AA(pc),a2
                move.b  (a2,d0.w),d1
                bset    #0,render_flags(a0)
                bclr    #7,d1
                bne.s   loc_73450
                bclr    #0,render_flags(a0)
                not.b   d2

loc_73450:
                bclr    #3,$38(a1)
                cmpi.b  #4,d1
                bne.s   loc_73478
                bset    #3,$38(a1)
                tst.b   d2
                beq.s   loc_73478
                movem.l d0-d1,-(sp)
                lea     ChildObjDat_737C2(pc),a2
                jsr     (CreateChild1_Normal).l
                movem.l (sp)+,d0-d1

loc_73478:
                move.b  d1,mapping_frame(a0)
                add.w   d0,d0
                move.w  word_734B6(pc,d0.w),$2E(a0)

loc_73484:
                lea     byte_734CE(pc,d0.w),a1
                movea.w parent3(a0),a2
                move.b  (a1)+,d1
                ext.w   d1
                move.w  x_pos(a2),d2
                add.w   d1,d2
                move.w  d2,x_pos(a0)
                move.b  (a1)+,d1
                ext.w   d1
                move.w  y_pos(a2),d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                rts
; End of function AdvanceLBZFinalBoss1CannonTurnCycle

; ---------------------------------------------------------------------------
byte_734AA:
                dc.b    3|$80
                dc.b    4|$80
                dc.b    5|$80
                dc.b    6|$80
                dc.b    7|$80
                dc.b    8|$80
                dc.b    7
                dc.b    6
                dc.b    5
                dc.b    4
                dc.b    3
                dc.b    $2D
                even
word_734B6:
                dc.w    7
                dc.w    $5F
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    $5F
                dc.w    7
                dc.w    $27
byte_734CE:
                dc.b    $27,  -8
                dc.b    $24,  -8
                dc.b    $24,  -8
                dc.b    $14,  -8
                dc.b    $C,  -8
                dc.b    0,  -8
                dc.b    -$C,  -8
                dc.b    -$14,  -8
                dc.b    -$24,  -8
                dc.b    -$24,  -8
                dc.b    -$27,  -8

; =============== S U B R O U T I N E =======================================

RandomizeLBZFinalBoss1LaserTrailOffset:
                jsr     (Random_Number).l
                swap    d0
                andi.b  #7,d0
                addi.b  #$18,d0
                move.b  d0,child_dx(a1)
                rts
; End of function RandomizeLBZFinalBoss1LaserTrailOffset

; =============== S U B R O U T I N E =======================================

; A hit freezes and flashes the root and speeds its vertical movement. Request body-section loss at five and one HP
LBZBoss1_HandleHitOrDefeat:
                tst.b   collision_flags(a0)
                bne.w   locret_735B4
                tst.b   collision_property(a0)
                beq.w   loc_735B6
                tst.b   $20(a0)
                bne.s   loc_73584
                move.b  routine(a0),$3A(a0)
                move.b  #6,routine(a0)
                move.b  #$20,$20(a0)
                bset    #6,status(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                move.w  y_vel(a0),d0
                asl.w   #1,d0
                cmpi.w  #-$800,d0
                blt.s   loc_73546
                cmpi.w  #$800,d0
                bgt.s   loc_73546
                move.w  d0,y_vel(a0)

loc_73546:
                cmpi.b  #5,collision_property(a0)
                beq.s   loc_7355C
                cmpi.b  #1,collision_property(a0)
                bne.s   loc_73584
                bset    #3,$38(a0)

loc_7355C:
                move.w  $3C(a0),d0
                bset    d0,$38(a0)
                addq.w  #1,$3C(a0)
                move.b  #8,routine(a0)
                move.b  #$F,$40(a0)
                bset    #5,status(a0)
                lea     ChildObjDat_737F8(pc),a2
                jsr     (CreateChild1_Normal).l

loc_73584:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_73592
                addi.w  #2*2,d0

loc_73592:
                bsr.w   CopyLBZFinalBoss1TwoColorPalette
                subq.b  #1,$20(a0)
                bne.s   locret_735B4
                move.b  $3A(a0),routine(a0)
                move.w  #$EEE,(Normal_palette_line_2+$2).w
                move.b  $25(a0),collision_flags(a0)
                bclr    #6,status(a0)

locret_735B4:
                rts
; ---------------------------------------------------------------------------

loc_735B6:
                jsr     (BossDefeated).l
                move.b  #5,mapping_frame(a0)
                bset    #6,status(a0)
                bset    #7,status(a0)
                clr.b   collision_flags(a0)
                move.w  $3C(a0),d0
                bset    d0,$38(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                move.b  #4,subtype(a1)
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_735FC
                move.l  #loc_72B18,(a0)
                rts
; ---------------------------------------------------------------------------

loc_735FC:
                move.l  #loc_73054,(a0)
                rts
; End of function LBZBoss1_HandleHitOrDefeat

; =============== S U B R O U T I N E =======================================

CopyLBZFinalBoss1TwoColorPalette:
                lea     word_73612(pc),a1
                lea     word_73616(pc,d0.w),a2
                jmp     (CopyWordData_2).l
; End of function CopyLBZFinalBoss1TwoColorPalette

; ---------------------------------------------------------------------------
word_73612:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$1C
word_73616:
                dc.w    $26,   $20
                dc.w    $EEE,  $EEE

; =============== S U B R O U T I N E =======================================

BreakOrSuspendLBZFinalBoss1BodySection:
                movea.w parent3(a0),a1
                move.w  $3C(a0),d0
                btst    d0,$38(a1)
                beq.s   loc_73672
                move.l  #byte_736C2,$3E(a0)
                bset    #7,status(a0)
                lea     (ChildObjDat_7377A).l,a2
                cmpi.w  #2,d0
                bne.s   loc_73654
                move.l  #byte_736C6,$3E(a0)
                lea     (ChildObjDat_73794).l,a2

loc_73654:
                move.w  #$10,$2E(a0)
                move.l  #loc_730F2,(a0)
                jsr     (CreateChild1_Normal).l
                lea     (Child6_CreateBossExplosion).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_73672:
                btst    #6,status(a1)
                beq.s   locret_73680
                move.l  #loc_730C0,(a0)

locret_73680:
                rts
; End of function BreakOrSuspendLBZFinalBoss1BodySection

; =============== S U B R O U T I N E =======================================

; Choose the frame from the parent's selected row and velocity from the fragment subtype
LBZBoss1Debris_InitFrameAndVel:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d1
                movea.w parent3(a0),a1
                movea.l $3E(a1),a1
                move.b  (a1,d1.w),mapping_frame(a0)
                add.w   d0,d0
                lea     word_736AA(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; End of function LBZBoss1Debris_InitFrameAndVel

; ---------------------------------------------------------------------------
word_736AA:
                dc.w    -$100, -$200
                dc.w    $100, -$200
                dc.w    -$200, -$100
                dc.w    $200, -$100
                dc.w    -$300, -$300
                dc.w    $300, -$300
byte_736C2:
                dc.b    $23
                dc.b    $25
                dc.b    $24
                dc.b    $26
byte_736C6:
                dc.b    $27
                dc.b    $29
                dc.b    $28
                dc.b    $2A
                dc.b    $2B
                dc.b    $2C
                even
