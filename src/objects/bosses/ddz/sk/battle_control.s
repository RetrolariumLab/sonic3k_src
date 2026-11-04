; Owner: objects/bosses/ddz/sk
; Responsibility: Doomsday final-boss battle controller, chase stages, damage state, world scrolling and completion progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DDZEndBoss:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DDZEndBoss_Index(pc,d0.w),d1
                jsr     DDZEndBoss_Index(pc,d1.w)
                move.w  x_pos(a0),(Events_bg+$02).w
                move.w  y_pos(a0),(Events_bg+$04).w
                rts
; ---------------------------------------------------------------------------
DDZEndBoss_Index:
                dc.w    loc_8180E-DDZEndBoss_Index
                dc.w    loc_81856-DDZEndBoss_Index
                dc.w    loc_818B4-DDZEndBoss_Index
                dc.w    loc_81914-DDZEndBoss_Index
                dc.w    loc_81958-DDZEndBoss_Index
                dc.w    loc_81A00-DDZEndBoss_Index
                dc.w    loc_81A74-DDZEndBoss_Index
                dc.w    loc_81B26-DDZEndBoss_Index
; ---------------------------------------------------------------------------

loc_8180E:
                move.b  #2,routine(a0)
                bset    #1,(_unkFAB8).w
                move.w  #$200,(Events_bg+$00).w
                move.w  (Camera_X_pos).w,d0
                addi.w  #$140,d0
                move.w  d0,x_pos(a0)
                move.w  #$A0,y_pos(a0)
                move.w  #$8F,$2E(a0)
                jsr     (Swing_Setup1).l
                lea     ChildObjDat_8325C(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     ChildObjDat_83262(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     ChildObjDat_83268(pc),a2
                jmp     CreateChild6_Simple(pc)
; ---------------------------------------------------------------------------

loc_81856:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                subq.w  #1,x_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   locret_818B2
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                move.w  (Camera_min_X_pos).w,d0
                subi.w  #$100,d0
                move.w  d0,(Camera_stored_min_X_pos).w
                jsr     (AllocateObject).l
                bne.s   loc_81890
                move.l  #Obj_DecLevStartXGradual,(a1)

loc_81890:
                jsr     (AllocateObject).l
                bne.s   locret_818B2
                move.l  #loc_81F94,(a1)
                move.w  a0,parent3(a1)
                st      $39(a1)
                move.w  #$D8,$42(a1)
                move.w  #$80,$44(a1)

locret_818B2:
                rts
; ---------------------------------------------------------------------------

loc_818B4:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                move.w  #$160,d2
                move.w  #$130,d3
                bsr.w   DDZBoss_StepXFromFlightInput
                move.w  (_unkFAA4).w,d0
                beq.s   locret_81912
                movea.w d0,a1
                btst    #7,status(a1)
                beq.s   locret_81912
                move.b  #6,routine(a0)
                bset    #7,status(a0)
                move.w  #(5*60)-1,$2E(a0)
                move.l  #-$20,(_unkFA8A).w
                jsr     (AllocateObject).l
                bne.s   locret_81912
                move.l  #loc_82E9A,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  a0,parent3(a1)

locret_81912:
                rts
; ---------------------------------------------------------------------------

loc_81914:
                move.w  #$160,d2
                move.w  #$130,d3
                bsr.w   DDZBoss_StepXFromFlightInput
                subq.w  #1,$2E(a0)
                bpl.s   locret_81956
                move.b  #8,routine(a0)
                move.w  #60-1,$3A(a0)
                move.b  #3,$39(a0)
                move.w  #-$300,x_vel(a0)
                move.w  #$100,y_vel(a0)
                jsr     (AllocateObject).l
                bne.s   locret_81956
                move.l  #loc_83004,(a1)
                move.w  a0,parent3(a1)

locret_81956:
                rts
; ---------------------------------------------------------------------------

loc_81958:
                subq.w  #1,$3A(a0)
                bpl.s   loc_8197C
                move.w  #$59,$3A(a0)
                subq.b  #1,$39(a0)
                bmi.s   loc_8197C
                lea     (Normal_palette_line_3).w,a1
                moveq   #$10-1,d0
                moveq   #$E,d1
                moveq   #-$20,d2

loc_81974:
                jsr     DecColor_Obj(pc)
                dbf     d0,loc_81974

loc_8197C:
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX_Continuous).l
                move.w  #$160,d2
                move.w  #$130,d3
                bsr.w   DDZBoss_StepXFromFlightInput
                jsr     (MoveSprite2).l
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$D0,d0
                cmp.w   y_pos(a0),d0
                bhs.w   locret_82ABA
                move.b  #$A,routine(a0)
                ori.b   #$30,$38(a0)
                move.w  #$1F,$2E(a0)
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   loc_819CE
                move.l  #loc_83108,(a1)

loc_819CE:
                lea     (Pal_DDZ+$20).l,a1
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d6

loc_819DA:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_819DA
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($80),d6

loc_819EA:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_819EA
                lea     (ArtKosM_BossMasterEmerald).l,a1
                move.w  #tiles_to_bytes(ArtTile_BossMasterEmerald),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_81A00:
                subq.w  #1,$2E(a0)
                bpl.w   locret_82ABA
                move.b  #$C,routine(a0)
                bclr    #7,status(a0)
                andi.b  #$CF,$38(a0)
                move.w  (_unkFA8E).w,d0
                beq.s   loc_81A28
                movea.w d0,a1
                andi.b  #$F3,$38(a1)

loc_81A28:
                move.w  #$600,(Events_bg+$00).w
                move.w  (Camera_X_pos).w,d0
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                subi.w  #$80,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                addi.w  #$E0,d0
                move.w  d0,y_pos(a0)
                clr.w   x_vel(a0)
                move.w  #-$200,y_vel(a0)
                lea     ChildObjDat_83274(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     ChildObjDat_83282(pc),a2
                jmp     CreateChild6_Simple(pc)
; ---------------------------------------------------------------------------

loc_81A74:
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$20,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_81A9C
                bset    #7,$38(a0)
                bne.s   loc_81A9C
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                clr.w   y_vel(a0)

loc_81A9C:
                addi.w  #$10,x_vel(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$1C0,d0
                cmp.w   x_pos(a0),d0
                bhi.s   locret_81B24
                move.b  #$E,routine(a0)
                bclr    #4,$38(a0)
                move.l  #$800,(_unkFA8A).w
                bset    #0,(_unkFAB8).w
                move.b  #7,collision_property(a0)
                clr.w   $2E(a0)
                clr.w   x_vel(a0)
                jsr     (Swing_Setup1).l
                move.w  #0,d0
                move.w  d0,(Camera_stored_min_Y_pos).w
                addi.w  #$C0,d0
                move.w  d0,y_pos(a0)
                jsr     (AllocateObject).l
                bne.s   loc_81AFC
                move.l  #Obj_DecLevStartYGradual,(a1)

loc_81AFC:
                move.w  #$120,d0
                move.w  d0,(Camera_stored_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                jsr     (AllocateObject).l
                bne.s   loc_81B16
                move.l  #Obj_IncLevEndYGradual,(a1)

loc_81B16:
                move.w  (_unkFA8E).w,d0
                beq.s   locret_81B24
                movea.w d0,a1
                bset    #2,$38(a1)

locret_81B24:
                rts
; ---------------------------------------------------------------------------

loc_81B26:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                move.w  #$40,d2
                move.w  #$60,d3
                movea.w (_unkFA8E).w,a1
                move.b  x_vel(a1),d1
                bmi.s   loc_81B44
                moveq   #0,d1

loc_81B44:
                ext.w   d1
                neg.w   d1
                asr.w   #1,d1
                btst    #button_right,(Ctrl_1_held).w
                bne.s   loc_81B68
                move.w  x_pos(a0),d0
                addi.w  #2,d0
                add.w   d1,d0
                move.w  (Camera_max_X_pos).w,d1
                add.w   d2,d1
                cmp.w   d1,d0
                blo.s   loc_81B7C
                rts
; ---------------------------------------------------------------------------

loc_81B68:
                move.w  x_pos(a0),d0
                addi.w  #-2,d0
                add.w   d1,d0
                move.w  (Camera_min_X_pos).w,d1
                add.w   d3,d1
                cmp.w   d1,d0
                bls.s   loc_81B82

loc_81B7C:
                swap    d0
                move.l  d0,x_pos(a0)

loc_81B82:
                move.l  x_pos(a0),d0
                addi.l  #$70000,d0
                tst.b   $20(a0)
                beq.s   loc_81B98
                addi.l  #$80000,d0

loc_81B98:
                move.l  (Camera_min_X_pos).w,d1
                addi.l  #$600000,d1
                cmp.l   d1,d0
                blo.s   loc_81BB0
                addi.l  #$1500000,d1
                cmp.l   d1,d0
                blo.s   loc_81BB2

loc_81BB0:
                move.l  d1,d0

loc_81BB2:
                move.l  d0,x_pos(a0)
                bsr.w   DDZBoss_TryFourShotBurst
                bra.w   loc_82DCE
; ---------------------------------------------------------------------------

loc_81BBE:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_81BEA(pc,d0.w),d1
                jsr     off_81BEA(pc,d1.w)
                move.w  (_unkFA90).w,d0
                add.w   d0,x_pos(a0)
                move.w  x_pos(a0),(Events_bg+$02).w
                move.w  y_pos(a0),(Events_bg+$04).w
                rts
; ---------------------------------------------------------------------------
off_81BEA:
                dc.w    loc_81BF2-off_81BEA
                dc.w    loc_81C2C-off_81BEA
                dc.w    loc_81C70-off_81BEA
                dc.w    loc_81CA4-off_81BEA
; ---------------------------------------------------------------------------

loc_81BF2:
                move.w  (Camera_X_pos).w,d0
                addq.w  #1,d0
                move.w  d0,(Camera_X_pos).w
                addi.w  #$40,d0
                cmp.w   x_pos(a0),d0
                blo.s   locret_81C2A
                move.b  #2,routine(a0)
                bset    #4,$38(a0)
                move.w  #$40,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   locret_81C2A
                move.l  #loc_8303E,(a1)
                move.w  a0,parent3(a1)

locret_81C2A:
                rts
; ---------------------------------------------------------------------------

loc_81C2C:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #7,d0
                bne.s   loc_81C3E
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l

loc_81C3E:
                addi.w  #$10,y_vel(a0)
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   locret_81C6E
                move.b  #4,routine(a0)
                jsr     (AllocateObject).l
                bne.s   locret_81C6E
                move.l  #SKPalEffect_InitWhiteAndLockRotation,(a1)
                move.w  a1,$44(a0)
                move.w  #7,$3A(a1)

locret_81C6E:
                rts
; ---------------------------------------------------------------------------

loc_81C70:
                movea.w (_unkFA8E).w,a1
                addq.w  #8,x_pos(a1)
                addi.w  #$10,y_vel(a0)
                jsr     (MoveSprite2).l
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.w   locret_82ABA
                move.b  #6,routine(a0)
                move.w  #$1F,$2E(a0)
                clr.b   (Super_palette_status).w
                rts
; ---------------------------------------------------------------------------

loc_81CA4:
                subq.w  #1,$2E(a0)
                bpl.w   locret_82ABA
                st      (SRAM_mask_interrupts_flag).w
                jsr     (SaveGame).l
                move.w  #$D01,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_81CC6:
                lea     ObjDat3_83226(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_81D0E,(a0)
                move.b  $43(a0),$3C(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                lea     (Collected_emeralds_array).w,a1
                moveq   #3,d0
                moveq   #7-1,d1

loc_81CEC:
                cmp.b   (a1)+,d0
                bne.s   locret_81D0C
                dbf     d1,loc_81CEC
                st      $3A(a0)
                lea     (word_8141E).l,a1
                lea     (Palette_rotation_data).w,a2
                moveq   #bytesToLcnt($10),d0

loc_81D04:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_81D04
                clr.w   (a2)

locret_81D0C:
                rts
; ---------------------------------------------------------------------------

loc_81D0E:
                movea.w parent3(a0),a1
                move.b  mapping_frame(a1),d0
                subi.b  #$3A,d0
                move.b  $3C(a0),d1
                add.b   d0,d1
                move.b  d1,$43(a0)
                jsr     Refresh_ChildPosition(pc)
                tst.b   $3A(a0)
                beq.s   loc_81D32
                jsr     Run_PalRotationScript(pc)

loc_81D32:
                movea.w $44(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_81D44
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_81D44:
                move.l  #loc_81D4A,(a0)

loc_81D4A:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_81D64
                move.w  d0,x_pos(a0)

loc_81D64:
                move.w  (_unkFA90).w,d0
                add.w   d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_81D72:
                lea     ObjDat3_8320E(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_81DCC,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     word_81DB4(pc,d0.w),a1
                move.w  (a1)+,$42(a0)
                move.w  (a1)+,$44(a0)
                move.l  off_81DC0(pc,d0.w),$30(a0)
                lsr.w   #2,d0
                move.b  byte_81DB0(pc,d0.w),mapping_frame(a0)
                tst.w   d0
                bne.w   locret_82ABA
                lea     ChildObjDat_8327A(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------
byte_81DB0:
                dc.b    $3A
                dc.b    5
                dc.b    $3D
                even
word_81DB4:
                dc.w    $64,   $4C
                dc.w    $10,   $20
                dc.w    $1C,   $8C
off_81DC0:
                dc.l    byte_832D0
                dc.l    0
                dc.l    byte_832D9
; ---------------------------------------------------------------------------

loc_81DCC:
                move.l  $30(a0),d0
                beq.s   loc_81DD8
                movea.l d0,a1
                jsr     Animate_RawNoSSTMultiDelay(pc)

loc_81DD8:
                bsr.w   DDZChild_SetPosFromParent
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                beq.s   loc_81E16
                move.l  #loc_81E28,(a0)
                bset    #7,status(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.l  word_81E1C(pc,d0.w),x_vel(a0)   ; and y_vel
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_81E16
                move.b  #4,subtype(a1)

loc_81E16:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_81E1C:
                dc.w    $80, -$200
                dc.w    -$100, -$100
                dc.w    -$200, -$300
; ---------------------------------------------------------------------------

loc_81E28:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                move.w  (_unkFA90).w,d0
                add.w   d0,x_pos(a0)
                jmp     Obj_FlickerMove(pc)
; ---------------------------------------------------------------------------

loc_81E3C:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_81E50(pc,d0.w),d1
                jsr     off_81E50(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_81E50:
                dc.w    loc_81E54-off_81E50
                dc.w    loc_81E72-off_81E50
; ---------------------------------------------------------------------------

loc_81E54:
                lea     ObjDat3_831CC(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  a0,(_unkFAA4).w
                move.w  #$C0,$42(a0)
                move.w  #$4B,$44(a0)
                move.b  #7,collision_property(a0)

loc_81E72:
                bsr.w   DDZChild_SetPosFromParent
                bra.w   loc_82D18
; ---------------------------------------------------------------------------

loc_81E7A:
                bsr.w   DDZChild_SetPosFromParent
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_81E82:
                lea     ObjDat3_831BA(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_81EB8,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     word_81EAC(pc,d0.w),a1
                move.w  (a1)+,$42(a0)
                move.w  (a1)+,$44(a0)
                lsl.w   #2,d0
                move.w  d0,$2E(a0)
                rts
; ---------------------------------------------------------------------------
word_81EAC:
                dc.w    $90,   $60
                dc.w    $B0,   $58
                dc.w    $A8,   $78
; ---------------------------------------------------------------------------

loc_81EB8:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_81EDE
                move.l  #loc_81ECA,(a0)

loc_81ECA:
                subq.w  #1,$2E(a0)
                bpl.s   loc_81EDE
                move.w  #$60,$2E(a0)
                lea     ChildObjDat_8326E(pc),a2
                jsr     CreateChild6_Simple(pc)

loc_81EDE:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   loc_81F0A
                movea.l a0,a1
                lea     (Player_1).w,a2
                jsr     GetApproximateObjectBearing(pc)
                addi.b  #$10,d0
                lsr.b   #4,d0
                andi.w  #$FE,d0
                move.w  d0,angle(a0)
                lsr.w   #1,d0
                addi.b  #$1C,d0
                move.b  d0,mapping_frame(a0)

loc_81F0A:
                bsr.w   PositionDDZTurretWithEightWayMuzzleNudge
                moveq   #0,d0
                jmp     Child_Draw_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------

loc_81F14:
                lea     word_831C6(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_81F26,(a0)
                bsr.w   DDZTurretShot_SetVelFromParentAngle

loc_81F26:
                jsr     (MoveSprite2).l
                jsr     (DDZTurretShot_CheckContactOrRetire).l
                jmp     Sprite_CheckDeleteXY(pc)
; ---------------------------------------------------------------------------

loc_81F36:
                lea     ObjDat3_831D8(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     word_81F5E(pc),a1

loc_81F42:
                move.l  #loc_81F6A,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,$42(a0)
                move.w  (a1)+,$44(a0)
                rts
; ---------------------------------------------------------------------------
word_81F5E:
                dc.w    $10,   $38
                dc.w    $10,   $87
                dc.w    $28,   $60
; ---------------------------------------------------------------------------

loc_81F6A:
                bsr.w   DDZChild_SetPosFromParent
                btst    #1,(V_int_run_count+3).w
                bne.s   loc_81F7A
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_81F7A:
                jmp     Child_CheckParent(pc)
; ---------------------------------------------------------------------------

loc_81F7E:
                lea     ObjDat3_831E4(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     word_81F8C(pc),a1
                bra.s   loc_81F42
; ---------------------------------------------------------------------------
word_81F8C:
                dc.w    -$20,   $24
                dc.w    -$10,   $44
; ---------------------------------------------------------------------------

loc_81F94:
                bsr.w   DDZChild_SetPosFromParent
                tst.b   $39(a0)
                bpl.s   loc_81FDA
                move.w  (Player_1+x_pos).w,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_81FDA
                moveq   #2,d1
                move.b  d1,$39(a0)
                moveq   #0,d2

loc_81FB0:
                jsr     (AllocateObject).l
                bne.s   loc_81FDA
                move.l  #Obj_DDZMissile,(a1)
                move.b  #1,subtype(a1)
                move.w  a0,parent3(a1)
                move.b  d2,$39(a1)
                addq.w  #1,d2
                dbf     d1,loc_81FB0
                moveq   #signextendB(sfx_TubeLauncher),d0
                jsr     (Play_SFX).l

loc_81FDA:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.w   locret_82ABA
                jmp     (Go_Delete_Sprite).l
