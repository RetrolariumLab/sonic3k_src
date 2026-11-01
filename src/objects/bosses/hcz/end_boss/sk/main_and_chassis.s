; Owner: objects/bosses/hcz/end_boss/sk
; Responsibility: Hydrocity end-boss battle control, defeat sequence, chassis states and coordinated child actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZEndBoss:
                lea     word_6AE96(pc),a1
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   loc_6AEC6
                lea     word_6AEA6(pc),a1

loc_6AEC6:
                jsr     (Check_CameraInRange).l
                move.b  #mus_EndBoss,boss_saved_mus(a0)
                jsr     (BeginBossCameraTransitionSaveBoundsAndFadeMusic).l
                move.l  #loc_6AEFE,(a0)
                move.l  #loc_6AF04,$34(a0)
                moveq   #PLCID_6C,d0
                jsr     (Load_PLC).l
                move.w  #0,(Normal_palette+$1E).w
                lea     Pal_HCZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_6AEFE:
                jmp     (loc_85CA4).l
; ---------------------------------------------------------------------------

loc_6AF04:
                move.l  #loc_6AF0C,(a0)

locret_6AF0A:
                rts
; ---------------------------------------------------------------------------

loc_6AF0C:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_6AF24(pc,d0.w),d1
                jsr     off_6AF24(pc,d1.w)
                bsr.w   HandleHCZEndBossThreeColorHitFlashOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
off_6AF24:
                dc.w    loc_6AF32-off_6AF24
                dc.w    loc_6AF74-off_6AF24
                dc.w    loc_6AFB6-off_6AF24
                dc.w    loc_6AF74-off_6AF24
                dc.w    loc_6AF74-off_6AF24
                dc.w    loc_6AFB6-off_6AF24
                dc.w    loc_6B064-off_6AF24
; ---------------------------------------------------------------------------

loc_6AF32:
                lea     ObjDat_HCZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$EF,$2E(a0)
                move.l  #loc_6AF80,$34(a0)
                lea     (ChildObjDat_6BDEC).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_6AF6A
                move.b  #5,subtype(a1)

loc_6AF6A:
                lea     ChildObjDat_6BD8A(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6AF74:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6AF80:
                move.b  #4,routine(a0)
                move.w  y_pos(a0),$3A(a0)
                move.w  #-$100,$44(a0)
                move.w  #$9F,$30(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_6AFC8,$34(a0)
                lea     (PLC_Explosion).l,a1
                jsr     (Load_PLC_Raw).l
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

loc_6AFB6:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6AFC8:
                bset    #3,$38(a0)
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_6AFF2
                move.b  #6,routine(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_6B008,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6AFF2:
                move.b  #$A,routine(a0)
                move.w  #$1FF,$2E(a0)
                move.l  #loc_6B03A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B008:
                move.w  #-$100,y_vel(a0)
                move.w  #$4F,$2E(a0)
                move.l  #loc_6B01E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B01E:
                move.b  #$A,routine(a0)
                move.w  #$FF,$2E(a0)
                move.w  $3A(a0),y_pos(a0)
                move.l  #loc_6B03A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B03A:
                move.b  #$C,routine(a0)
                bclr    #3,$38(a0)
                move.w  $44(a0),x_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #loc_6B08E,$34(a0)
                move.b  #8,$39(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

loc_6B064:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                subq.w  #1,$30(a0)
                bpl.s   locret_6B08C
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  #$13F,$30(a0)

locret_6B08C:
                rts
; ---------------------------------------------------------------------------

loc_6B08E:
                move.w  #$5F,$2E(a0)
                subq.b  #1,$39(a0)
                bmi.s   loc_6B0A2
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B0A2:
                move.w  x_vel(a0),$44(a0)
                clr.w   x_vel(a0)
                bra.w   loc_6AFC8
; ---------------------------------------------------------------------------

loc_6B0B0:
                move.l  #loc_6B0CC,(a0)
                bset    #4,$38(a0)
                move.l  #loc_6B0E8,$34(a0)
                moveq   #$C,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

loc_6B0CC:
                jsr     (MoveSprite).l
                jsr     (Obj_Wait).l
                btst    #0,(V_int_run_count+3).w
                beq.w   locret_6AF0A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6B0E8:
                move.l  #loc_6B154,(a0)
                bclr    #7,render_flags(a0)
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                move.w  (_unkFAB4).w,d0
                addi.w  #$180,d0
                move.w  d0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jsr     (CreateChild6_Simple).l
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_6B138
                jsr     (AllocateObject).l
                bne.s   locret_6B136
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$4250,x_pos(a1)
                move.w  #$7E0,y_pos(a1)

locret_6B136:
                rts
; ---------------------------------------------------------------------------

loc_6B138:
                jsr     (AllocateObject).l
                bne.s   locret_6B152
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$4760,x_pos(a1)
                move.w  #$360,y_pos(a1)

locret_6B152:
                rts
; ---------------------------------------------------------------------------

loc_6B154:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (_unkFAA8).w
                bne.w   locret_6AF0A
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                st      (Ctrl_1_locked).w
                st      (Ctrl_2_locked).w
                move.b  #$80,(Player_1+object_control).w
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                jsr     (Restore_LevelMusic).l
                jsr     (AllocateObject).l
                bne.s   loc_6B19C
                move.l  #loc_6B7BC,(a1)

loc_6B19C:
                move.w  #0,(Camera_min_Y_pos).w
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_6B1A8:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_6B1C4(pc,d0.w),d1
                jsr     off_6B1C4(pc,d1.w)
                jsr     (Refresh_ChildPosition).l
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------
off_6B1C4:
                dc.w    loc_6B1CE-off_6B1C4
                dc.w    loc_6B1D8-off_6B1C4
                dc.w    loc_6B204-off_6B1C4
                dc.w    loc_6B22A-off_6B1C4
                dc.w    loc_6B25C-off_6B1C4
; ---------------------------------------------------------------------------

loc_6B1CE:
                lea     word_6BD32(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

loc_6B1D8:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_6B1E6
                rts
; ---------------------------------------------------------------------------

loc_6B1E6:
                move.b  #4,routine(a0)
                move.b  #$A6,collision_flags(a0)
                move.l  #byte_6BDF4,$30(a0)
                move.l  #loc_6B212,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B204:
                moveq   #signextendB(sfx_FanBig),d0
                jsr     (Play_SFX_Continuous).l
                jmp     (Animate_RawGetFaster).l
; ---------------------------------------------------------------------------

loc_6B212:
                move.b  #6,routine(a0)
                move.l  #byte_6BDFB,$30(a0)
                lea     ChildObjDat_6BDBA(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6B22A:
                jsr     (Animate_Raw).l
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_6B244
                moveq   #signextendB(sfx_FanBig),d0
                jmp     (Play_SFX_Continuous).l
; ---------------------------------------------------------------------------

loc_6B244:
                move.b  #8,routine(a0)
                move.l  #byte_6BE01,$30(a0)
                move.l  #loc_6B262,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B25C:
                jmp     (Animate_RawGetSlower).l
; ---------------------------------------------------------------------------

loc_6B262:
                move.b  #2,routine(a0)
                clr.b   collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B26E:
                move.w  x_pos(a0),-(sp)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_6B29E(pc,d0.w),d1
                jsr     off_6B29E(pc,d1.w)
                move.w  #$1F,d1
                move.w  #$C,d2
                move.w  #$C,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectTop).l
                bsr.w   StartHCZBossColumnDescentAfterRootDeath
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_6B29E:
                dc.w    loc_6B2AA-off_6B29E
                dc.w    loc_6B2F2-off_6B29E
                dc.w    loc_6B31E-off_6B29E
                dc.w    loc_6B336-off_6B29E
                dc.w    loc_6B31E-off_6B29E
                dc.w    loc_6B394-off_6B29E
; ---------------------------------------------------------------------------

loc_6B2AA:
                lea     word_6BD3E(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.w  (Water_level).w,d0
                subq.w  #8,d0
                move.w  d0,y_pos(a0)
                move.w  d0,$3A(a0)
                move.l  #byte_6BE0C,$30(a0)
                move.l  #loc_6B2F8,$34(a0)
                lea     ChildObjDat_6BDCA(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_6BDE6(pc),a2
                jsr     (CreateChild6_Simple).l
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B2F2:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_6B2F8:
                move.b  #4,routine(a0)
                move.l  #byte_6BE15,$30(a0)
                move.w  #-$100,y_vel(a0)
                move.l  #loc_6B32E,$34(a0)
                lea     ChildObjDat_6BDC2(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6B31E:
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                bra.w   UpdateHCZBossColumnHeightAndCheckCallback
; ---------------------------------------------------------------------------

loc_6B32E:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B336:
                jsr     (Animate_Raw).l
                movea.w $44(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_6B34A
                rts
; ---------------------------------------------------------------------------

loc_6B34A:
                move.b  #8,routine(a0)
                bset    #3,$38(a0)
                move.w  #$80,y_vel(a0)
                move.l  #loc_6B37A,$34(a0)
                move.w  #$80,x_vel(a0)
                tst.w   x_vel(a1)
                bpl.s   locret_6B374
                neg.w   x_vel(a0)

locret_6B374:
                rts
; ---------------------------------------------------------------------------
; unused
                bra.w   UpdateHCZBossColumnHeightAndCheckCallback
; ---------------------------------------------------------------------------

loc_6B37A:
                move.l  #loc_6B394,(a0)
                move.w  #$F,$2E(a0)
                clr.w   x_vel(a0)
                move.l  #loc_6B3BC,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6B394:
                move.w  #$1F,d1
                move.w  #$C,d2
                move.w  #$C,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6B3BC:
                jsr     (Displace_PlayerOffObject).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_6B3C8:
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                bsr.w   UpdateHCZBossColumnHeightAndCheckCallback
                jmp     (Draw_Sprite).l
