; Owner: objects/bosses/icz/sk
; Responsibility: IceCap miniboss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZMiniboss:
                cmpi.w  #$501,(Apparent_zone_and_act).w
                beq.s   loc_711AA
                lea     word_71142(pc),a1
                tst.b   subtype(a0)
                beq.s   loc_71178
                lea     word_71152(pc),a1

loc_71178:
                jsr     (Check_CameraInRange).l
                move.b  #mus_Miniboss,boss_saved_mus(a0)
                jsr     (Boss_BeginCameraTransition).l
                move.l  #loc_711B0,(a0)
                move.l  #loc_711B6,$34(a0)
                moveq   #PLCID_5F,d0
                jsr     (Load_PLC).l
                lea     Pal_ICZMiniboss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_711AA:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_711B0:
                jmp     (SKEndCamera_TickAndSaveMusic).l
; ---------------------------------------------------------------------------

loc_711B6:
                move.l  #loc_711BE,(a0)

locret_711BC:
                rts
; ---------------------------------------------------------------------------

loc_711BE:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_711D6(pc,d0.w),d1
                jsr     off_711D6(pc,d1.w)
                bsr.w   HandleICZMinibossTwoColorHitOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
off_711D6:
                dc.w    loc_711EC-off_711D6
                dc.w    loc_7122A-off_711D6
                dc.w    loc_71252-off_711D6
                dc.w    loc_7127E-off_711D6
                dc.w    loc_712C4-off_711D6
                dc.w    loc_71300-off_711D6
                dc.w    loc_7127E-off_711D6
                dc.w    loc_7135E-off_711D6
                dc.w    loc_7138A-off_711D6
                dc.w    loc_713AC-off_711D6
                dc.w    loc_7122A-off_711D6
; ---------------------------------------------------------------------------

loc_711EC:
                lea     ObjDat3_71960(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #6,collision_property(a0)
                move.w  #$200,$3E(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #loc_71236,$34(a0)
                lea     ChildObjDat_719AA(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     ChildObjDat_71984(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_7122A:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_71236:
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_71258,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_71252:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_71258:
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_7128A,$34(a0)
                lea     (word_71AE6).l,a1

loc_71272:
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                rts
; ---------------------------------------------------------------------------

loc_7127E:
                jsr     (Run_PalRotationScript).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7128A:
                bset    #2,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_712A8,$34(a0)
                moveq   #signextendB(sfx_TunnelBooster),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_712A8:
                move.b  #8,routine(a0)
                move.w  #$300,y_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_712D6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_712C4:
                jsr     (MoveSprite2).l
                jsr     (Run_PalRotationScript).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_712D6:
                bsr.w   SelectICZMinibossArcRepeatCount

loc_712DA:
                move.b  #$A,routine(a0)
                move.w  #$300,y_vel(a0)
                neg.w   $3E(a0)
                move.w  $3E(a0),x_vel(a0)
                move.w  #$5F,$2E(a0)
                moveq   #signextendB(sfx_BossRotate),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_71300:
                jsr     (Run_PalRotationScript).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_71318
                addi.w  #-$10,y_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_71318:
                move.b  #$C,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_7133A,$34(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                jsr     (Run_PalRotationScript).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7133A:
                subq.b  #1,$39(a0)
                bpl.s   loc_712DA
                move.b  #$E,routine(a0)
                bset    #1,$38(a0)
                move.w  (_unkFAB4).w,d0
                addi.w  #$A0,d0
                cmp.w   x_pos(a0),d0
                scc     $43(a0)
                rts
; ---------------------------------------------------------------------------

loc_7135E:
                btst    #1,$38(a0)
                beq.s   loc_7136C
                jmp     (Run_PalRotationScript).l
; ---------------------------------------------------------------------------

loc_7136C:
                move.b  #$10,routine(a0)
                bclr    #2,$38(a0)
                move.l  #loc_71390,(Palette_rotation_custom).w
                lea     (word_71B52).l,a1
                bra.w   loc_71272
; ---------------------------------------------------------------------------

loc_7138A:
                jmp     (Run_PalRotationScript).l
; ---------------------------------------------------------------------------

loc_71390:
                move.b  #$12,routine(a0)
                move.w  #$222,(Normal_palette_line_2+$14).w
                move.w  #$3F,$2E(a0)
                move.l  #loc_713B2,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_713AC:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_713B2:
                move.b  #$14,routine(a0)
                move.w  #-$100,y_vel(a0)
                clr.w   x_vel(a0)
                move.w  #$17,$2E(a0)
                move.l  #loc_713D2,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_713D2:
                move.b  #4,routine(a0)
                move.w  #$FF,$2E(a0)
                move.l  #loc_71258,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_713E8:
                jsr     (Obj_EndSignControl).l
                movea.w (_unkFAAE).w,a1
                cmpi.l  #SKICZSnowPile_UpdateCameraSnowEmitter,(a1)
                bne.s   loc_71400
                bset    #5,$38(a1)

loc_71400:
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_71416
                jsr     (AllocateObject).l
                bne.s   loc_71416
                move.l  #loc_71420,(a1)

loc_71416:
                lea     ChildObjDat_719B0(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_71420:
                move.l  #loc_71440,(a0)
                lea     (word_719FA).l,a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #Go_Delete_Sprite,(Palette_rotation_custom).w
                rts
; ---------------------------------------------------------------------------

loc_71440:
                jmp     (Run_PalRotationScript).l
; ---------------------------------------------------------------------------

loc_71446:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_71462(pc,d0.w),d1
                jsr     off_71462(pc,d1.w)
                jsr     (Refresh_ChildPosition).l
                moveq   #0,d0
                jmp     (Child_Draw_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------
off_71462:
                dc.w    loc_7146A-off_71462
                dc.w    loc_71478-off_71462
                dc.w    loc_71498-off_71462
                dc.w    locret_714B6-off_71462
; ---------------------------------------------------------------------------

loc_7146A:
                lea     word_7196C(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bra.w   loc_716B2
; ---------------------------------------------------------------------------

loc_71478:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_71486
                rts
; ---------------------------------------------------------------------------

loc_71486:
                move.b  #4,routine(a0)
                move.l  #loc_714AE,$34(a0)
                bra.w   loc_716C8
; ---------------------------------------------------------------------------

loc_71498:
                move.b  x_vel(a0),d0
                add.b   d0,child_dx(a0)
                move.b  x_vel+1(a0),d0
                add.b   d0,child_dy(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_714AE:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

locret_714B6:
                rts
; ---------------------------------------------------------------------------

loc_714B8:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_714CE(pc,d0.w),d1
                jsr     off_714CE(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------
off_714CE:
                dc.w    loc_714E6-off_714CE
                dc.w    loc_714F4-off_714CE
                dc.w    loc_7151E-off_714CE
                dc.w    loc_7155A-off_714CE
                dc.w    loc_7157C-off_714CE
                dc.w    loc_71594-off_714CE
                dc.w    loc_715B4-off_714CE
                dc.w    loc_71600-off_714CE
                dc.w    loc_7155A-off_714CE
                dc.w    loc_7164E-off_714CE
                dc.w    loc_7155A-off_714CE
                dc.w    locret_71688-off_714CE
; ---------------------------------------------------------------------------

loc_714E6:
                lea     ObjDat3_71972(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bra.w   loc_716F4
; ---------------------------------------------------------------------------

loc_714F4:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_71502
                rts
; ---------------------------------------------------------------------------

loc_71502:
                move.b  #4,routine(a0)
                move.w  #-$40,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_7153A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7151E:
                moveq   #1,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_7152A
                neg.w   d0

loc_7152A:
                add.w   d0,x_pos(a0)
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7153A:
                move.b  #6,routine(a0)
                move.w  #$180,priority(a0)
                bsr.w   SetICZMinibossOrbApproachVelocity
                move.w  #$1F,$2E(a0)
                move.l  #loc_71566,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7155A:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_71566:
                move.b  #8,routine(a0)
                move.b  #$8B,collision_flags(a0)
                moveq   #signextendB(sfx_BossRotate),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_7157C:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_7158C
                bra.w   loc_7179E
; ---------------------------------------------------------------------------

loc_7158C:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_71594:
                movea.w parent3(a0),a1
                moveq   #0,d0
                tst.b   $43(a1)
                bne.s   loc_715A2
                moveq   #-$80,d0

loc_715A2:
                cmp.b   $3D(a0),d0
                beq.s   loc_715AC
                bra.w   loc_7179E
; ---------------------------------------------------------------------------

loc_715AC:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_715B4:
                addq.b  #4,$3C(a0)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                moveq   #0,d0
                bsr.w   TiltAndDepthSortICZMinibossOrb
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_715F0
                tst.b   subtype(a0)
                bne.w   locret_711BC
                moveq   #0,d0
                tst.b   $43(a1)
                bne.s   loc_715E8
                moveq   #-$80,d0

loc_715E8:
                cmp.b   $3C(a0),d0
                bne.w   locret_711BC

loc_715F0:
                move.b  #$E,routine(a0)
                bclr    #1,$38(a1)
                bra.w   loc_7186A
; ---------------------------------------------------------------------------

loc_71600:
                move.b  $3C(a0),d0
                cmp.b   $42(a0),d0
                beq.s   loc_71620
                addq.b  #4,$3C(a0)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                moveq   #0,d0
                bra.w   TiltAndDepthSortICZMinibossOrb
; ---------------------------------------------------------------------------

loc_71620:
                move.b  #$10,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_71636,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_71636:
                move.b  #$12,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_71654,$34(a0)
                bra.w   loc_718CA
; ---------------------------------------------------------------------------

loc_7164E:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_71654:
                move.b  #$14,routine(a0)
                moveq   #signextendB(sfx_LevelProjectile),d0
                jsr     (Play_SFX).l
                move.w  #$400,y_vel(a0)
                clr.w   x_vel(a0)
                move.w  #$45,$2E(a0)
                move.l  #loc_7167C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7167C:
                move.b  #2,routine(a0)
                clr.b   collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

locret_71688:
                rts
; ---------------------------------------------------------------------------

loc_7168A:
                lea     word_7197E(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$B,d0
                move.b  d0,mapping_frame(a0)
                moveq   #8,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

loc_716B2:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  RawAni_716C2(pc,d0.w),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
RawAni_716C2:
                dc.b    1,   9,   3,   2,  $A,   4
                even
; ---------------------------------------------------------------------------

loc_716C8:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_716DC(pc,d0.w),x_vel(a0)
                move.w  word_716E8(pc,d0.w),$2E(a0)
                rts
; ---------------------------------------------------------------------------
word_716DC:
                dc.w    -1,  $1FF,     1,    -1,  $1FF,     1
word_716E8:
                dc.w    2,     2,     3,     6,     6,     8
; ---------------------------------------------------------------------------

loc_716F4:
                move.w  (_unkFAB0).w,d0
                addi.w  #$D8,d0
                move.w  d0,y_pos(a0)

loc_71700:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_71730(pc,d0.w),d2
                jsr     (Random_Number).l
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,d2
                move.w  (_unkFAB4).w,x_pos(a0)
                add.w   d2,x_pos(a0)
                swap    d0
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
word_71730:
                dc.w    -$20
                dc.w    $20
                dc.w    $60
                dc.w    $A0
                dc.w    $E0
                dc.w    $120
                dc.w    $160
                dc.w    $1A0

; =============== S U B R O U T I N E =======================================

SetICZMinibossOrbApproachVelocity:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #4,d0
                move.b  d0,$3C(a0)
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                movem.w d0-d1,-(sp)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                moveq   #0,d0
                moveq   #0,d1
                moveq   #0,d2
                moveq   #0,d3
                movem.w (sp)+,d0-d1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  d0,x_pos(a0)
                move.w  d1,y_pos(a0)
                swap    d0
                swap    d1
                swap    d2
                swap    d3
                sub.l   d0,d2
                sub.l   d1,d3
                lsl.l   #3,d2
                lsl.l   #3,d3
                swap    d2
                swap    d3
                move.w  d2,x_vel(a0)
                move.w  d3,y_vel(a0)
                rts
; End of function SetICZMinibossOrbApproachVelocity

; ---------------------------------------------------------------------------

loc_7179E:
                addq.b  #4,$3C(a0)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     (MoveSprite_AtAngleLookup).l
                move.b  $3D(a0),d0
                addq.b  #1,d0
                move.b  d0,$3D(a0)

; =============== S U B R O U T I N E =======================================

TiltAndDepthSortICZMinibossOrb:
                jsr     (GetSineCosine).l
                tst.w   d1
                bpl.s   loc_717C4
                neg.w   d1

loc_717C4:
                move.w  y_pos(a0),d2
                move.w  y_pos(a1),d4
                sub.w   d4,d2
                scs     d3
                bcc.s   loc_717D4
                neg.w   d2

loc_717D4:
                mulu.w  d1,d2
                lsr.l   #8,d2
                cmpi.b  #$40,$3D(a0)
                blo.s   loc_717EA
                cmpi.b  #-$40,$3D(a0)
                bhs.s   loc_717EA
                not.b   d3

loc_717EA:
                tst.b   d3
                beq.s   loc_717F0
                neg.w   d2

loc_717F0:
                add.w   d2,d4
                move.w  d4,y_pos(a0)
                move.b  $3D(a0),d0
                spl     d3
                cmpi.b  #$40,$3C(a0)
                blo.s   loc_7180E
                cmpi.b  #-$40,$3C(a0)
                bhs.s   loc_7180E
                not.b   d3

loc_7180E:
                move.b  #6,mapping_frame(a0)
                cmpi.b  #$20,d0
                blo.s   loc_7183C
                cmpi.b  #$60,d0
                blo.s   loc_7182C
                cmpi.b  #-$60,d0
                blo.s   loc_7183C
                cmpi.b  #-$20,d0
                bhs.s   loc_7183C

loc_7182C:
                move.b  #5,mapping_frame(a0)
                tst.b   d3
                bne.s   loc_7183C
                move.b  #8,mapping_frame(a0)

loc_7183C:
                move.w  #$180,priority(a0)
                tst.b   d3
                bne.s   locret_7184C
                move.w  #$300,priority(a0)

locret_7184C:
                rts
; End of function TiltAndDepthSortICZMinibossOrb

; =============== S U B R O U T I N E =======================================

SelectICZMinibossArcRepeatCount:
                move.b  $3A(a0),d0
                addq.b  #1,$3A(a0)
                andi.w  #7,d0
                move.b  byte_71862(pc,d0.w),$39(a0)
                rts
; End of function SelectICZMinibossArcRepeatCount

; ---------------------------------------------------------------------------
byte_71862:
                dc.b    1,   0,   1,   1,   0,   1,   0,   0
                even
; ---------------------------------------------------------------------------

loc_7186A:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d1
                tst.b   $43(a1)
                bne.s   loc_71880
                addq.w  #8,d1

loc_71880:
                move.b  byte_7189A(pc,d1.w),$42(a0)
                add.w   d0,d0
                move.l  word_718AA(pc,d0.w),x_vel(a0)   ; and y_vel
                tst.b   $43(a1)
                bne.s   locret_71898
                neg.w   x_vel(a0)

locret_71898:
                rts
; ---------------------------------------------------------------------------
byte_7189A:
                dc.b    $60, $5C, $58, $54, $50, $4C, $48, $44
                dc.b    $E0, $DC, $D8, $D4, $D0, $CC, $C8, $C4
                even
word_718AA:
                dc.w    -$300, -$400
                dc.w    -$200, -$400
                dc.w    -$100, -$400
                dc.w    0, -$400
                dc.w    $100, -$400
                dc.w    $200, -$400
                dc.w    $300, -$400
                dc.w    $400, -$400
; ---------------------------------------------------------------------------

loc_718CA:
                move.w  (_unkFAB0).w,d0
                subi.w  #$40,d0
                move.w  d0,y_pos(a0)
                bra.w   loc_71700

; =============== S U B R O U T I N E =======================================

HandleICZMinibossTwoColorHitOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   locret_71924
                tst.b   collision_property(a0)
                beq.s   loc_71926
                tst.b   $20(a0)
                bne.s   loc_718FA
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_718FA:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_7190E
                addi.w  #2*2,d0

loc_7190E:
                bsr.w   CopyICZMinibossTwoColorPalette
                subq.b  #1,$20(a0)
                bne.s   locret_71924
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_71924:
                rts
; ---------------------------------------------------------------------------

loc_71926:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #loc_713E8,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     (BossDefeated_StopTimer).l
; End of function HandleICZMinibossTwoColorHitOrDefeat

; =============== S U B R O U T I N E =======================================

CopyICZMinibossTwoColorPalette:
                lea     word_71954(pc),a1
                lea     word_71958(pc,d0.w),a2
                jmp     (CopyWordData_2).l
; End of function CopyICZMinibossTwoColorPalette

; ---------------------------------------------------------------------------
word_71954:
                dc.w    Normal_palette_line_2+$14, Normal_palette_line_2+$16
word_71958:
                dc.w    $222,   $20
                dc.w    $EEE,  $EEE
ObjDat3_71960:
                dc.l    Map_ICZMiniboss
                dc.w    make_art_tile(ArtTile_ICZMiniboss,1,1)
                dc.w    $280
                dc.b    $18, $18,   0,   6
word_7196C:
                dc.w    $280
                dc.b    $10,  $C,   1,   0
ObjDat3_71972:
                dc.l    Map_ICZMiniboss
                dc.w    make_art_tile(ArtTile_ICZMiniboss,2,0)
                dc.w    $280
                dc.b    $C,  $C,   6,   0
word_7197E:
                dc.w    $180
                dc.b    $C,  $C,  $B,   0
ChildObjDat_71984:
                dc.w    6-1
                dc.l    loc_71446
                dc.b    -$E, -$B
                dc.l    loc_71446
                dc.b    $E, -$B
                dc.l    loc_71446
                dc.b    0, $12
                dc.l    loc_71446
                dc.b    -$E, -$B
                dc.l    loc_71446
                dc.b    $E, -$B
                dc.l    loc_71446
                dc.b    0,  $E
ChildObjDat_719AA:
                dc.w    8-1
                dc.l    loc_714B8
ChildObjDat_719B0:
                dc.w    4-1
                dc.l    loc_7168A
                dc.b    -$C, -$C
                dc.l    loc_7168A
                dc.b    $C, -$C
                dc.l    loc_7168A
                dc.b    -$C,  $C
                dc.l    loc_7168A
                dc.b    $C,  $C
                dc.b    0
                dc.b    3
                dc.b    1
                dc.b    3
                dc.b    2
                dc.b    3
                dc.b    3
                dc.b    3
                dc.b    4
                dc.b    3
                dc.b    5
                dc.b    3
                dc.b    6
                dc.b    3
                dc.b    $F4
                even
Pal_ICZMiniboss:
                binclude "data/Levels/ICZ/Palettes/Miniboss.bin"
                even
