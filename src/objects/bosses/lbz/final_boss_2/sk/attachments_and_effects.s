; Owner: objects/bosses/lbz/final_boss_2/sk
; Responsibility: Launch Base final boss attached actors, orbiting parts, capture children and defeat effects with private placement records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_749AE:
                lea     ObjDat3_750C2(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_749BE,(a0)

loc_749BE:
                jsr     (Child_GetPriorityOnce).l
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_749D0:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_749E6(pc,d0.w),d1
                jsr     off_749E6(pc,d1.w)
                moveq   #$C,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_749E6:
                dc.w    loc_749EC-off_749E6
                dc.w    loc_74A14-off_749E6
                dc.w    loc_74A3E-off_749E6
; ---------------------------------------------------------------------------

loc_749EC:
                lea     ObjDat3_750CE(pc),a1
                jsr     (SetUp_ObjAttributes).l
                movea.w parent3(a0),a1
                move.w  a0,$44(a1)
                move.b  #$14,child_dx(a0)
                move.b  #-6,child_dy(a0)
                lea     ChildObjDat_75144(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_74A14:
                movea.w parent3(a0),a1
                btst    #7,art_tile(a1)
                beq.s   loc_74A32
                bset    #7,art_tile(a0)
                move.b  #4,routine(a0)
                move.b  #$AD,collision_flags(a0)

loc_74A32:
                lea     (LBZFinalBoss2_CircleLookup).l,a2
                jmp     (MoveSprite_CircularLookup).l
; ---------------------------------------------------------------------------

loc_74A3E:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.w   locret_74374
                btst    #2,$38(a1)
                bne.s   loc_74A88
                lea     (Player_1).w,a1
                move.b  $3C(a0),d0
                move.w  y_pos(a0),d1
                sub.w   y_pos(a1),d1
                cmpi.w  #-2,d1
                blt.s   loc_74A7C
                cmpi.w  #2,d1
                ble.s   loc_74A88
                subq.b  #1,d0
                cmpi.b  #-$30,d0
                blt.s   loc_74A88
                bra.w   loc_74A84
; ---------------------------------------------------------------------------

loc_74A7C:
                addq.b  #1,d0
                cmpi.b  #0,d0
                bgt.s   loc_74A88

loc_74A84:
                move.b  d0,$3C(a0)

loc_74A88:
                jsr     (Change_FlipXUseParent).l
                lea     (LBZFinalBoss2_CircleLookup).l,a2
                jmp     (MoveSprite_CircularLookup).l
; ---------------------------------------------------------------------------

loc_74A9A:
                lea     word_750E0(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_74ACA,(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a2
                move.w  a2,parent3(a0)
                move.w  a1,$44(a0)
                move.w  a1,$44(a0)
                move.b  #$18,child_dx(a0)
                move.b  #-6,child_dy(a0)

loc_74ACA:
                jsr     (Child_GetPriorityOnce).l
                jsr     (Change_FlipXUseParent).l
                movea.w $44(a0),a1
                move.b  $3C(a1),d0
                addi.b  #$14,d0
                move.b  d0,$3C(a0)
                lea     (LBZ2FinalBoss2_CircleLookup2).l,a2
                jsr     (MoveSprite_CircularLookup).l
                moveq   #$C,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_74AFA:
                lea     word_750DA(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                move.l  #loc_74B36,(a0)
                move.l  #byte_75194,$30(a0)
                tst.b   subtype(a0)
                beq.s   loc_74B36
                move.b  #8,mapping_frame(a0)
                move.w  #$180,priority(a0)
                move.l  #byte_7519C,$30(a0)

loc_74B36:
                jsr     (Child_GetPriorityOnce).l

loc_74B3C:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Animate_Raw).l
                movea.w $44(a0),a1
                tst.b   $30(a1)
                beq.s   loc_74B6E
                move.l  #loc_74B76,(a0)
                move.b  #7,mapping_frame(a0)
                tst.b   subtype(a0)
                beq.s   loc_74B6E
                move.b  #$B,mapping_frame(a0)
                addq.b  #8,child_dx(a0)

loc_74B6E:
                moveq   #$C,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_74B76:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w $44(a0),a1
                tst.b   $30(a1)
                bne.s   loc_74B96
                move.l  #loc_74B3C,(a0)
                tst.b   subtype(a0)
                beq.s   loc_74B96
                subq.b  #8,child_dx(a0)

loc_74B96:
                moveq   #$C,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_74B9E:
                lea     ObjDat3_750E6(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_74BAE,(a0)

loc_74BAE:
                jsr     (Child_GetPriorityOnce).l
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_74BC0:
                lea     ObjDat3_750F2(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_74BD0,(a0)

loc_74BD0:
                move.b  #$9A,d0
                bsr.w   LBZBoss2Child_LatchPriorityAndColl
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_74BFA
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_74374
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_74BFA:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_74C00:
                move.l  #loc_74C0C,(a0)
                move.b  #$9C,collision_flags(a0)

loc_74C0C:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_74BFA
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

loc_74C24:
                move.l  #loc_74C34,(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)

loc_74C34:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   loc_74C7A
                btst    #3,$38(a1)
                bne.w   locret_74374
                btst    #6,status(a1)
                bne.w   locret_74374
                lea     word_74C84(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                beq.s   locret_74C78
                movea.w d0,a1
                tst.b   invulnerability_timer(a1)
                bne.s   locret_74C78
                cmpi.b  #6,routine(a1)
                blo.s   loc_74C8C

locret_74C78:
                rts
; ---------------------------------------------------------------------------

loc_74C7A:
                clr.b   (Player_1+object_control).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
word_74C84:
                dc.w    -$10,   $20,  -$10,   $20
; ---------------------------------------------------------------------------

loc_74C8C:
                move.l  #loc_74CCC,(a0)
                movea.w $44(a0),a1
                st      $30(a1)
                move.b  #$1E,routine(a1)
                move.w  #$40,$2E(a1)
                move.l  #loc_74562,$34(a1)
                lea     (Player_1).w,a1
                move.b  #$81,object_control(a1)
                move.b  #2,anim(a1)
                moveq   #0,d0
                move.w  d0,x_vel(a1)
                move.w  d0,y_vel(a1)
                move.w  d0,ground_vel(a1)

loc_74CCC:
                movea.w $44(a0),a1
                tst.b   $30(a1)
                beq.s   loc_74CF8
                btst    #7,status(a1)
                bne.w   loc_74BFA
                jsr     (Refresh_ChildPositionAdjusted).l
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                rts
; ---------------------------------------------------------------------------

loc_74CF8:
                move.l  #loc_74D04,(a0)
                move.w  #$40,$2E(a0)

loc_74D04:
                subq.w  #1,$2E(a0)
                bmi.s   loc_74D0C
                rts
; ---------------------------------------------------------------------------

loc_74D0C:
                move.l  #loc_74C34,(a0)
                rts
; ---------------------------------------------------------------------------

loc_74D14:
                lea     ObjDat3_750FE(pc),a1
                jsr     (SetUp_ObjAttributes).l
                jsr     (Refresh_ChildPositionAdjusted).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$D,d0
                move.b  d0,mapping_frame(a0)
                moveq   #0,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_74D48:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_74D5C(pc,d0.w),d1
                jsr     off_74D5C(pc,d1.w)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
off_74D5C:
                dc.w    loc_74D62-off_74D5C
                dc.w    loc_74D7C-off_74D5C
                dc.w    loc_74DEA-off_74D5C
; ---------------------------------------------------------------------------

loc_74D62:
                lea     ObjDat3_7510A(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #$10,y_radius(a0)
                move.l  #loc_74D90,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_74D7C:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   locret_74374
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_74D90:
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                blo.s   loc_74DA4
                asr.w   #1,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_74DA4:
                move.l  #loc_74DEA,(a0)
                move.b  #$7F,$39(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)
                lea     (AIZMiniSK_MissileImpactChildren).l,a2
                jsr     (CreateChild1_Normal).l
                move.w  #$1000,d0
                move.w  d0,(Camera_stored_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  #$6000,(Camera_stored_max_X_pos).w
                move.w  #0,(Camera_stored_min_Y_pos).w
                lea     (Child1_Act2LevelSize).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_74DEA:
                bclr    #7,render_flags(a0)
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.w   locret_74374
                subq.b  #1,$39(a0)
                bmi.s   loc_74E0C
                lea     ChildObjDat_7518E(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_74E0C:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_74E12:
                lea     ObjDat3_75116(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_74E24,(a0)
                rts
; ---------------------------------------------------------------------------

loc_74E24:
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_74E30:
                jsr     (Random_Number).l
                andi.w  #$3C,d0
                lea     word_74E7C(pc,d0.w),a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                move.l  #Obj_Wait,(a0)
                move.w  #$60,$2E(a0)
                move.l  #loc_74E70,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   locret_74E6E
                move.b  #4,subtype(a1)

locret_74E6E:
                rts
; ---------------------------------------------------------------------------

loc_74E70:
                bset    #5,$38(a0)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
word_74E7C:
                dc.w    $4310,  $3ED
                dc.w    $4330,  $3F0
                dc.w    $4350,  $3F0
                dc.w    $4370,  $3F0
                dc.w    $4390,  $3F0
                dc.w    $43B0,  $3F0
                dc.w    $43D0,  $3F0
                dc.w    $43F0,  $3F0
                dc.w    $4410,  $3F0
                dc.w    $4430,  $3ED
                dc.w    $4450,  $3E5
                dc.w    $4470,  $3D6
                dc.w    $4490,  $3B8
                dc.w    $44B0,  $3A2
                dc.w    $44D0,  $395
                dc.w    $44F0,  $390
