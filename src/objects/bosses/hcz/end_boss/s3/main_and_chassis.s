; Owner: objects/bosses/hcz/end_boss/s3
; Responsibility: Hydrocity end-boss battle control, defeat sequence, chassis states and coordinated child actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZEndBoss:
                move.w  #$4050,(Camera_max_X_pos).w
                lea     word_48D26(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #loc_48D2E,(a0)
                move.b  #1,(Boss_flag).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #2*60,$2E(a0)
                move.b  #mus_EndBoss,$26(a0)
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  #$738,(Camera_target_max_Y_pos).w
                move.w  #$4000,$1C(a0)
                move.l  #loc_48D34,$34(a0)
                rts
; ---------------------------------------------------------------------------
word_48D26:
                dc.w    $400,  $880, $3E80, $4090
; ---------------------------------------------------------------------------

loc_48D2E:
                jmp     (loc_541C8).l
; ---------------------------------------------------------------------------

loc_48D34:
                move.l  #loc_48D3C,(a0)

locret_48D3A:
                rts
; ---------------------------------------------------------------------------

loc_48D3C:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_48D54(pc,d0.w),d1
                jsr     off_48D54(pc,d1.w)
                bsr.w   sub_49A06
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
off_48D54:
                dc.w    loc_48D62-off_48D54
                dc.w    loc_48DBC-off_48D54
                dc.w    loc_48DFE-off_48D54
                dc.w    loc_48DBC-off_48D54
                dc.w    loc_48DBC-off_48D54
                dc.w    loc_48DFE-off_48D54
                dc.w    loc_48EAA-off_48D54
; ---------------------------------------------------------------------------

loc_48D62:
                lea     ObjDat_HCZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$EF,$2E(a0)
                move.l  #loc_48DC8,$34(a0)
                moveq   #PLCID_6C,d0
                jsr     (Load_PLC).l
                move.w  #0,(Normal_palette+$1E).w
                lea     Pal_HCZEndBoss(pc),a1
                jsr     (PalLoad_Line1).l
                lea     (ChildObjDat_49C2E).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_48DB2
                move.b  #5,subtype(a1)

loc_48DB2:
                lea     ChildObjDat_49BCC(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_48DBC:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_48DC8:
                move.b  #4,routine(a0)
                move.w  y_pos(a0),$3A(a0)
                move.w  #-$100,$44(a0)
                move.w  #$9F,$30(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_48E10,$34(a0)
                lea     (PLC_Explosion).l,a1
                jsr     (Load_PLC_Raw).l
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

loc_48DFE:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_48E10:
                bset    #3,$38(a0)
                tst.b   (_unkFA80+1).w
                bne.s   loc_48E38
                move.b  #6,routine(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_48E4E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_48E38:
                move.b  #$A,routine(a0)
                move.w  #$1FF,$2E(a0)
                move.l  #loc_48E80,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_48E4E:
                move.w  #-$100,y_vel(a0)
                move.w  #$4F,$2E(a0)
                move.l  #loc_48E64,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_48E64:
                move.b  #$A,routine(a0)
                move.w  #$FF,$2E(a0)
                move.w  $3A(a0),y_pos(a0)
                move.l  #loc_48E80,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_48E80:
                move.b  #$C,routine(a0)
                bclr    #3,$38(a0)
                move.w  $44(a0),x_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #loc_48ED4,$34(a0)
                move.b  #8,$39(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

loc_48EAA:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                subq.w  #1,$30(a0)
                bpl.s   locret_48ED2
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  #$13F,$30(a0)

locret_48ED2:
                rts
; ---------------------------------------------------------------------------

loc_48ED4:
                move.w  #$5F,$2E(a0)
                subq.b  #1,$39(a0)
                bmi.s   loc_48EE8
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_48EE8:
                move.w  x_vel(a0),$44(a0)
                clr.w   x_vel(a0)
                bra.w   loc_48E10
; ---------------------------------------------------------------------------

loc_48EF6:
                move.l  #loc_48F20,(a0)
                bset    #4,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_48F3C,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                moveq   #$C,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

loc_48F20:
                jsr     (MoveSprite).l
                jsr     (Obj_Wait).l
                btst    #0,(V_int_run_count+3).w
                beq.w   locret_48D3A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_48F3C:
                move.l  #loc_48F68,(a0)
                bclr    #7,render_flags(a0)
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                jsr     (Restore_LevelMusic).l
                move.w  #$4230,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_48F68:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (_unkFAA8).w
                bne.w   locret_48D3A
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                st      (Ctrl_1_locked).w
                st      (Ctrl_2_locked).w
                move.b  #$80,(Player_1+object_control).w
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                lea     ChildObjDat_49C36(pc),a2
                jsr     (CreateChild6_Simple).l
                move.w  #0,(Camera_min_Y_pos).w
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_48FB2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_48FCE(pc,d0.w),d1
                jsr     off_48FCE(pc,d1.w)
                jsr     (Refresh_ChildPosition).l
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------
off_48FCE:
                dc.w    loc_48FD8-off_48FCE
                dc.w    loc_48FE2-off_48FCE
                dc.w    loc_4900E-off_48FCE
                dc.w    loc_49034-off_48FCE
                dc.w    loc_49066-off_48FCE
; ---------------------------------------------------------------------------

loc_48FD8:
                lea     word_49B74(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

loc_48FE2:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_48FF0
                rts
; ---------------------------------------------------------------------------

loc_48FF0:
                move.b  #4,routine(a0)
                move.b  #$A6,collision_flags(a0)
                move.l  #byte_49C3C,$30(a0)
                move.l  #loc_4901C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4900E:
                moveq   #signextendB(sfx_FanBig),d0
                jsr     (Play_SFX_Continuous).l
                jmp     (Animate_RawGetFaster).l
; ---------------------------------------------------------------------------

loc_4901C:
                move.b  #6,routine(a0)
                move.l  #byte_49C43,$30(a0)
                lea     ChildObjDat_49BFC(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_49034:
                jsr     (Animate_Raw).l
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_4904E
                moveq   #signextendB(sfx_FanBig),d0
                jmp     (Play_SFX_Continuous).l
; ---------------------------------------------------------------------------

loc_4904E:
                move.b  #8,routine(a0)
                move.l  #byte_49C49,$30(a0)
                move.l  #loc_4906C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_49066:
                jmp     (Animate_RawGetSlower).l
; ---------------------------------------------------------------------------

loc_4906C:
                move.b  #2,routine(a0)
                clr.b   collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_49078:
                move.w  x_pos(a0),-(sp)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_490A8(pc,d0.w),d1
                jsr     off_490A8(pc,d1.w)
                move.w  #$1F,d1
                move.w  #$C,d2
                move.w  #$C,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectTop).l
                bsr.w   sub_49A84
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_490A8:
                dc.w    loc_490B4-off_490A8
                dc.w    loc_490FC-off_490A8
                dc.w    loc_49128-off_490A8
                dc.w    loc_49140-off_490A8
                dc.w    loc_49128-off_490A8
                dc.w    loc_4919E-off_490A8
; ---------------------------------------------------------------------------

loc_490B4:
                lea     word_49B80(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.w  (Water_level).w,d0
                subq.w  #8,d0
                move.w  d0,y_pos(a0)
                move.w  d0,$3A(a0)
                move.l  #byte_49C54,$30(a0)
                move.l  #loc_49102,$34(a0)
                lea     ChildObjDat_49C0C(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_49C28(pc),a2
                jsr     (CreateChild6_Simple).l
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                rts
; ---------------------------------------------------------------------------

loc_490FC:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_49102:
                move.b  #4,routine(a0)
                move.l  #byte_49C5D,$30(a0)
                move.w  #-$100,y_vel(a0)
                move.l  #loc_49138,$34(a0)
                lea     ChildObjDat_49C04(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_49128:
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                bra.w   sub_49ACC
; ---------------------------------------------------------------------------

loc_49138:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_49140:
                jsr     (Animate_Raw).l
                movea.w $44(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_49154
                rts
; ---------------------------------------------------------------------------

loc_49154:
                move.b  #8,routine(a0)
                bset    #3,$38(a0)
                move.w  #$80,y_vel(a0)
                move.l  #loc_49184,$34(a0)
                move.w  #$80,x_vel(a0)
                tst.w   x_vel(a1)
                bpl.s   locret_4917E
                neg.w   x_vel(a0)

locret_4917E:
                rts
; ---------------------------------------------------------------------------
; unused
                bra.w   sub_49ACC
; ---------------------------------------------------------------------------

loc_49184:
                move.l  #loc_4919E,(a0)
                move.w  #$F,$2E(a0)
                clr.w   x_vel(a0)
                move.l  #loc_491C6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4919E:
                move.w  #$1F,d1
                move.w  #$C,d2
                move.w  #$C,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_491C6:
                jsr     (Displace_PlayerOffObject).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_491D2:
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                bsr.w   sub_49ACC
                jmp     (Draw_Sprite).l
