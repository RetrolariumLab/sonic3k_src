; Owner: objects/cutscenes/knuckles/s3
; Responsibility: Knuckles Launch Base act-one and act-two cutscene programs, helpers and scene records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_LBZ1:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_LBZ1_Index(pc,d0.w),d1
                jsr     CutsceneKnux_LBZ1_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
CutsceneKnux_LBZ1_Index:
                dc.w    loc_44FE8-CutsceneKnux_LBZ1_Index
                dc.w    loc_45022-CutsceneKnux_LBZ1_Index
                dc.w    loc_449A2-CutsceneKnux_LBZ1_Index
                dc.w    loc_4505E-CutsceneKnux_LBZ1_Index
                dc.w    loc_449A2-CutsceneKnux_LBZ1_Index
                dc.w    loc_44CC4-CutsceneKnux_LBZ1_Index
                dc.w    loc_44CC4-CutsceneKnux_LBZ1_Index
                dc.w    loc_450E8-CutsceneKnux_LBZ1_Index
; ---------------------------------------------------------------------------

loc_44FE8:
                move.w  (Player_1+x_pos).w,d0
                cmp.w   x_pos(a0),d0
                bhs.s   loc_4501C
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.b  #$16,mapping_frame(a0)
                move.w  #$A0,(Camera_min_Y_pos).w
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_45738(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_4501C:
                jmp     (Go_Delete_SpriteSlotted2).l
; ---------------------------------------------------------------------------

loc_45022:
                btst    #3,$38(a0)
                bne.s   loc_4502C
                rts
; ---------------------------------------------------------------------------

loc_4502C:
                move.b  #4,routine(a0)
                bsr.w   SpawnKnucklesCutsceneMusicTransition
                move.w  #60-1,$2E(a0)
                move.l  #loc_45046,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_45046:
                move.b  #6,routine(a0)
                move.l  #byte_4578F,$30(a0)
                move.l  #loc_45064,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4505E:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_45064:
                move.b  #8,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_45096,$34(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_45740(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     (PLC_BossExplosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

loc_45096:
                move.b  #$A,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_450AE,$34(a0)
                bra.w   loc_449E4
; ---------------------------------------------------------------------------

loc_450AE:
                move.b  #$C,routine(a0)
                st      (Screen_shake_flag).w
                move.w  #$5F,$2E(a0)
                move.l  #loc_450D0,$34(a0)
                lea     ChildObjDat_45748(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_450D0:
                move.b  #$E,routine(a0)
                move.l  #byte_4576B,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_450E8:
                tst.b   render_flags(a0)
                bpl.w   loc_450FA
                addq.w  #2,x_pos(a0)
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_450FA:
                clr.b   (_unkFAA9).w
                clr.b   (Player_1+object_control).w
                clr.b   (Player_2+object_control).w
                move.w  #$3B60,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jsr     (CreateChild6_Simple).l
                move.w  #$148,(Camera_target_max_Y_pos).w
                jsr     (Remove_From_TrackingSlot).l
                lea     (Pal_LBZ1).l,a1
                jsr     (PalLoad_Line1).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_45136:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_4516E
                lea     word_45196(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.l   d0
                beq.s   locret_4516C
                tst.w   d0
                beq.s   loc_45162
                movea.w parent3(a0),a2
                bset    #3,$38(a2)
                bsr.w   S3LBZScene_LockPlayerFacingRight

loc_45162:
                swap    d0
                tst.w   d0
                beq.s   locret_4516C
                bsr.w   S3LBZScene_LockPlayerFacingRight

locret_4516C:
                rts
; ---------------------------------------------------------------------------

loc_4516E:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

; Set the scene scratch flag and apply the pose to the selected player if still alive
S3LBZScene_LockPlayerFacingRight:
                st      (_unkFAA9).w
                movea.w d0,a1
                cmpi.b  #6,routine(a1)
                bhs.s   locret_4516C
                move.b  #$81,object_control(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                rts
; End of function S3LBZScene_LockPlayerFacingRight

; ---------------------------------------------------------------------------
word_45196:
                dc.w    -$40,   $80,  -$30,   $60
; ---------------------------------------------------------------------------

loc_4519E:
                lea     ObjDat3_456FA(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_451C2,(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l

loc_451C2:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

loc_451CE:
                move.l  #loc_4520C,(a0)
                move.l  #Obj_NormalExpControl,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     word_451FC(pc,d0.w),a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                move.b  #$A,subtype(a0)
                jmp     (S3BossExpl_LoadSubtypeParams).l
; ---------------------------------------------------------------------------
word_451FC:
                dc.w    $3BC0,  $1A0
                dc.w    $3B80,  $1A0
                dc.w    $3B40,  $1A0
                dc.w    $3B00,  $1A0
; ---------------------------------------------------------------------------

loc_4520C:
                subq.w  #4,y_pos(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

CutsceneKnux_LBZ2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_LBZ2_Index(pc,d0.w),d1
                jsr     CutsceneKnux_LBZ2_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
CutsceneKnux_LBZ2_Index:
                dc.w    loc_45242-CutsceneKnux_LBZ2_Index
                dc.w    loc_45270-CutsceneKnux_LBZ2_Index
                dc.w    loc_4528A-CutsceneKnux_LBZ2_Index
                dc.w    loc_452A4-CutsceneKnux_LBZ2_Index
                dc.w    loc_452C6-CutsceneKnux_LBZ2_Index
                dc.w    loc_4530A-CutsceneKnux_LBZ2_Index
                dc.w    loc_45322-CutsceneKnux_LBZ2_Index
; ---------------------------------------------------------------------------

loc_45242:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bset    #0,render_flags(a0)
                move.b  #$20,mapping_frame(a0)
                bsr.w   SpawnKnucklesCutsceneMusicTransition
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_4574E(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_45270:
                btst    #1,$38(a0)
                bne.s   loc_4527A
                rts
; ---------------------------------------------------------------------------

loc_4527A:
                move.b  #4,routine(a0)
                move.l  #loc_45294,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4528A:
                lea     byte_4579E(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

loc_45294:
                move.b  #6,routine(a0)
                bclr    #0,render_flags(a0)
                bra.w   loc_449E4
; ---------------------------------------------------------------------------

loc_452A4:
                tst.b   (Screen_shake_flag).w
                beq.s   loc_452C0
                move.b  #8,routine(a0)
                move.l  #byte_45766,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)

loc_452C0:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_452C6:
                btst    #3,$38(a0)
                bne.s   loc_452DC
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_452DC:
                move.b  #$A,routine(a0)
                bset    #0,render_flags(a0)
                move.b  #9,mapping_frame(a0)
                move.w  #$200,x_vel(a0)
                move.w  #-$100,y_vel(a0)
                jsr     (AllocateObject).l
                bne.s   locret_45308
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

locret_45308:
                rts
; ---------------------------------------------------------------------------

loc_4530A:
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   loc_45322
                moveq   #signextendB(sfx_Splash),d0
                jsr     (Play_SFX).l
                move.b  #$C,routine(a0)

loc_45322:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jmp     (MoveSprite_LightGravity).l
; ---------------------------------------------------------------------------

loc_45330:
                lea     ObjDat3_45706(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_4536C,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.l  word_4535C(pc,d0.w),$3E(a0)
                lsl.w   #3,d0
                add.w   d0,y_pos(a0)
                move.w  x_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------
word_4535C:
                dc.w    $100,   $10
                dc.w    $C0,    $C
                dc.w    $80,     8
                dc.w    $40,     4
; ---------------------------------------------------------------------------

loc_4536C:
                tst.b   (Screen_shake_flag).w
                beq.s   loc_45384
                move.l  #loc_4538A,(a0)
                move.w  $3E(a0),x_vel(a0)
                move.b  #6,$39(a0)

loc_45384:
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

loc_4538A:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                move.w  x_pos(a0),d0
                move.w  $40(a0),d1
                cmp.w   $3A(a0),d0
                scs     d2
                bcs.s   loc_453A4
                neg.w   d1

loc_453A4:
                add.w   d1,x_vel(a0)
                cmp.b   $3C(a0),d2
                beq.s   loc_453E4
                move.b  d2,$3C(a0)
                cmpi.b  #3,$39(a0)
                bne.s   loc_453CE
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.l  word_45400(pc,d0.w),$3E(a0)
                move.w  $3E(a0),x_vel(a0)

loc_453CE:
                subq.b  #1,$39(a0)
                bne.s   loc_453E4
                move.l  #loc_45410,(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)

loc_453E4:
                jsr     (MoveSprite2).l
                tst.b   subtype(a0)
                bne.s   loc_453FA
                movea.w parent3(a0),a1
                move.w  x_pos(a0),x_pos(a1)

loc_453FA:
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------
word_45400:
                dc.w    $200,   $20
                dc.w    $180,   $18
                dc.w    $100,   $10
                dc.w    $80,     8
; ---------------------------------------------------------------------------

loc_45410:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l
; End of function loc_45410
