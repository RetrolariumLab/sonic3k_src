; Owner: objects/bosses/ssz/knuckles_boss/sk
; Responsibility: Knuckles final-boss crane actor, linked children, platform interaction and scene motion
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_KnuxFinalBossCrane:
                move.l  #loc_7CA3A,(a0)
                move.w  (Camera_min_X_pos).w,(Camera_max_X_pos).w
                lea     PLC_KnuxFinalBossCrane(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------
PLC_KnuxFinalBossCrane: plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
PLC_KnuxFinalBossCrane_End:
; ---------------------------------------------------------------------------

loc_7CA3A:
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                beq.w   locret_7B448
                move.l  #loc_7CAAA,(a0)
                lea     (ObjDat3_664EE).l,a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #-$80,x_vel(a0)
                jsr     (Swing_Setup1).l
                jsr     (AllocateObject).l
                bne.s   loc_7CA78
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

loc_7CA78:
                lea     (Child1_MakeRoboHead4).l,a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_7D4BC(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     CreateChild1_Normal(pc)
                lea     (ArtKosM_KnuxFinalBossCrane).l,a1
                move.w  #tiles_to_bytes(ArtTile_HPZSSZBossCrane),d2
                jsr     (Queue_Kos_Module).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7CAAA:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                cmpi.w  #$120,x_pos(a0)
                bhs.s   loc_7CACC
                move.l  #loc_7CAD2,(a0)
                clr.w   x_vel(a0)
                bset    #0,(_unkFAB8).w

loc_7CACC:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7CAD2:
                btst    #1,(_unkFAB8).w
                beq.s   loc_7CAE6
                move.l  #loc_7CAE6,(a0)
                move.w  #-$80,x_vel(a0)

loc_7CAE6:
                btst    #2,(_unkFAB8).w
                beq.s   loc_7CAF8
                move.l  #loc_7CAF8,(a0)
                clr.w   x_vel(a0)

loc_7CAF8:
                btst    #3,(_unkFAB8).w
                beq.s   loc_7CB18
                move.l  #loc_7CB28,(a0)
                move.w  #$80,x_vel(a0)
                bset    #0,render_flags(a0)
                bclr    #0,(Player_1+render_flags).w

loc_7CB18:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7CB28:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                cmpi.w  #$120,x_pos(a0)
                blo.s   loc_7CB5E
                move.l  #loc_7CB64,(a0)
                clr.w   x_vel(a0)
                move.w  #60-1,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   loc_7CB5E
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_FinalBoss,subtype(a1)

loc_7CB5E:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7CB64:
                subq.w  #1,$2E(a0)
                bne.s   loc_7CB94
                move.l  #loc_7CBA4,(a0)
                st      (Scroll_lock).w
                jsr     (AllocateObject).l
                bne.s   loc_7CB82
                move.l  #loc_7D11C,(a1)

loc_7CB82:
                jsr     (AllocateObject).l
                bne.s   loc_7CB90
                move.l  #Obj_SSZEndBoss,(a1)

loc_7CB90:
                move.w  a1,(_unkFAA4).w

loc_7CB94:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7CBA4:
                movea.w (_unkFAA4).w,a1
                lea     word_7CC16(pc),a2
                jsr     (Check_InMyRange).l
                beq.s   loc_7CBCE
                move.l  #loc_7CBCE,(a0)
                jsr     (AllocateObject).l
                bne.s   loc_7CBC8
                move.l  #loc_7CC3A,(a1)

loc_7CBC8:
                bset    #5,(_unkFAB8).w

loc_7CBCE:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                movea.w (_unkFAA4).w,a1
                lea     word_7CC1E(pc),a2
                jsr     (Check_InMyRange).l
                beq.s   loc_7CC10
                move.l  #Wait_Draw,(a0)
                move.w  #$80,priority(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_7CC26,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l

loc_7CC10:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_7CC16:
                dc.w    -$20,   $40,     0,   $78
word_7CC1E:
                dc.w    -$20,   $40,     0,   $30
; ---------------------------------------------------------------------------

loc_7CC26:
                lea     ChildObjDat_7D4C4(pc),a2
                jsr     CreateChild6_Simple(pc)
                ori.b   #$30,$38(a0)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_7CC3A:
                move.l  #loc_7CC68,(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.b  #$C0,mapping_frame(a1)
                move.w  #$400,x_vel(a0)
                move.w  #$80,y_vel(a0)
                jsr     (Player_Load_PLC).l

loc_7CC68:
                jsr     (MoveSprite2).l
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_pos(a0),d0
                cmp.w   (_unkFAB6).w,d0
                blo.w   locret_7B448
                move.l  #loc_7CCB0,(a0)
                move.w  #6,$2E(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.b  #$13,y_radius(a0)
                move.b  #$CA,mapping_frame(a1)
                jmp     (Player_Load_PLC).l
; ---------------------------------------------------------------------------

loc_7CCB0:
                subq.w  #1,$2E(a0)
                bne.s   loc_7CCC6
                lea     (Player_1).w,a1
                move.b  #$CB,mapping_frame(a1)
                jsr     (Player_Load_PLC).l

loc_7CCC6:
                jsr     (MoveSprite).l
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.w   locret_7B448
                lea     (Player_1).w,a1
                add.w   d1,y_pos(a1)
                clr.b   $2E(a1)
                jsr     Stop_Object(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_7CCFE:
                lea     (ObjDat3_664FA).l,a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #0,priority(a0)
                move.l  #loc_7CD22,(a0)
                lea     (ChildObjDat_66610).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_7CD22:
                btst    #0,(_unkFAB8).w
                bne.s   loc_7CD36
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7CD36:
                move.l  #loc_7CD42,(a0)
                move.b  child_dy(a0),$3A(a0)

loc_7CD42:
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d0
                subi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                bls.s   loc_7CD76
                move.b  y_vel(a0),d0
                addi.b  #1,d0
                move.b  d0,y_vel(a0)
                move.b  $3A(a0),d1
                add.b   d0,d1
                move.b  d1,child_dy(a0)
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7CD76:
                move.l  #loc_7CD82,(a0)
                bset    #1,(_unkFAB8).w

loc_7CD82:
                move.b  $3A(a0),d0
                ext.w   d0
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d1
                add.w   d0,d1
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d2
                subi.w  #$10,d2
                sub.w   d1,d2
                bpl.s   loc_7CDA4
                moveq   #0,d2

loc_7CDA4:
                move.b  d2,y_vel(a0)
                add.b   d2,d0
                bpl.s   loc_7CDB0
                move.b  #$7F,d0

loc_7CDB0:
                move.b  d0,child_dy(a0)
                move.w  x_pos(a0),d0
                cmpi.w  #8,d0
                bls.s   loc_7CDD2
                move.w  x_pos(a1),d1
                subi.w  #$C,d0
                cmp.w   d0,d1
                blo.s   loc_7CE12
                addi.w  #$18,d0
                cmp.w   d0,d1
                bhs.s   loc_7CE12

loc_7CDD2:
                move.l  #loc_7CE1E,(a0)
                bset    #2,(_unkFAB8).w
                move.b  #2,mapping_frame(a0)
                move.b  #$83,object_control(a1)
                move.b  #$CB,mapping_frame(a1)
                bset    #0,render_flags(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                jsr     (Player_Load_PLC).l
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

loc_7CE12:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7CE1E:
                move.b  y_vel(a0),d0
                subq.b  #1,d0
                bpl.s   loc_7CE34
                move.l  #loc_7CE42,(a0)
                bset    #3,(_unkFAB8).w
                moveq   #0,d0

loc_7CE34:
                move.b  d0,y_vel(a0)
                move.b  $3A(a0),d1
                add.b   d0,d1
                move.b  d1,child_dy(a0)

loc_7CE42:
                jsr     (Refresh_ChildPositionAdjusted).l
                btst    #5,(_unkFAB8).w
                bne.s   loc_7CE66
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),d0
                addi.w  #$16,d0
                move.w  d0,y_pos(a1)

loc_7CE66:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7CE6C:
                lea     ObjDat3_7D45C(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  d0,mapping_frame(a0)
                moveq   #8,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

loc_7CE90:
                lea     ObjDat3_7D468(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_7CF02,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     byte_7CEE2(pc,d0.w),a1
                move.b  (a1)+,d1
                ext.w   d1
                movea.w parent3(a0),a2
                btst    #0,render_flags(a2)
                beq.s   loc_7CEC2

; Bug: should be d1
; Otherwise, Mecha Sonic's pieces will be positioned incorrectly
; when Mecha Sonic is facing the right side
                neg.w   d2
                bset    #0,render_flags(a0)

loc_7CEC2:
                add.w   d1,x_pos(a0)
                move.b  (a1)+,d2
                ext.w   d2
                add.w   d2,y_pos(a0)
                asl.w   #5,d1
                move.w  d1,x_vel(a0)
                asl.w   #4,d2
                move.w  d2,y_vel(a0)
                lsr.w   #1,d0
                move.b  d0,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
byte_7CEE2:
                dc.b    -$14,-$24
                dc.b    -$C,-$28
                dc.b    -$C,-$18
                dc.b    -4,-$28
                dc.b    -4,-$18
                dc.b    4,-$28
                dc.b    4,-$18
                dc.b    $C,-$28
                dc.b    $C,-$18
                dc.b    $14,-$20
                dc.b    $14,-$10
                dc.b    -$14,  -4
                dc.b    -$C,  -8
                dc.b    -4,  -8
                dc.b    4,  -8
                dc.b    $C,  -8
                even
; ---------------------------------------------------------------------------

loc_7CF02:
                tst.b   (_unkFAA2).w
                bne.s   loc_7CF0E
                jmp     (Obj_FlickerMove).l
; ---------------------------------------------------------------------------

loc_7CF0E:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_7CF14:
                move.b  subtype(a0),d0
                subq.b  #2,d0
                bpl.s   loc_7CF4E
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$D0,d0
                move.w  d0,y_pos(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_7CF48
                move.b  #$C,subtype(a1)

loc_7CF48:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_7CF4E:
                move.l  #loc_7CF7C,(a0)
                addi.w  #$30,y_pos(a0)
                moveq   #2,d1
                tst.b   d0
                bne.s   loc_7CF62
                neg.w   d1

loc_7CF62:
                move.w  d1,x_vel(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   locret_7CF7A
                move.b  #$1E,subtype(a1)

locret_7CF7A:
                rts
; ---------------------------------------------------------------------------

loc_7CF7C:
                move.w  x_vel(a0),d0
                move.w  x_pos(a0),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.w  (Camera_X_pos).w,d0
                subi.w  #$10,d0
                cmp.w   d0,d1
                blo.w   loc_7C8F8
                addi.w  #$160,d0
                cmp.w   d0,d1
                bhi.w   loc_7C8F8
                rts
