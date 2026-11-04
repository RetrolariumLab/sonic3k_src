; Owner: objects/bosses/mhz/miniboss/sk
; Responsibility: Mushroom Hill miniboss controller, attacks, parent actors and battle progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZMiniboss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MHZMiniboss_Index(pc,d0.w),d1
                jsr     MHZMiniboss_Index(pc,d1.w)
                move.w  (Level_repeat_offset).w,d0
                beq.s   loc_751E2
                sub.w   d0,x_pos(a0)

loc_751E2:
                bsr.w   HandleMHZMinibossFourColorHitOrDefeat
                bsr.w   MHZMini_SetPriorityFromFrame
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
MHZMiniboss_Index:
                dc.w    loc_75220-MHZMiniboss_Index
                dc.w    loc_752D4-MHZMiniboss_Index
                dc.w    loc_7531C-MHZMiniboss_Index
                dc.w    loc_752D4-MHZMiniboss_Index
                dc.w    loc_75392-MHZMiniboss_Index
                dc.w    loc_753B6-MHZMiniboss_Index
                dc.w    loc_753DE-MHZMiniboss_Index
                dc.w    loc_7541A-MHZMiniboss_Index
                dc.w    loc_7544C-MHZMiniboss_Index
                dc.w    loc_754A0-MHZMiniboss_Index
                dc.w    loc_754E0-MHZMiniboss_Index
                dc.w    loc_75532-MHZMiniboss_Index
                dc.w    loc_75564-MHZMiniboss_Index
                dc.w    loc_754A0-MHZMiniboss_Index
                dc.w    loc_755AE-MHZMiniboss_Index
                dc.w    loc_754A0-MHZMiniboss_Index
                dc.w    loc_7560C-MHZMiniboss_Index
                dc.w    loc_7565C-MHZMiniboss_Index
                dc.w    loc_754A0-MHZMiniboss_Index
                dc.w    loc_75694-MHZMiniboss_Index
                dc.w    loc_756C6-MHZMiniboss_Index
                dc.w    loc_756FC-MHZMiniboss_Index
                dc.w    loc_7571C-MHZMiniboss_Index
                dc.w    loc_757A0-MHZMiniboss_Index
; ---------------------------------------------------------------------------

loc_75220:
                lea     ObjDat_MHZMiniboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$110,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$78,d0
                move.w  d0,y_pos(a0)
                move.b  #6,collision_property(a0)
                move.w  a0,(_unkFAA4).w
                move.b  #5,$42(a0)
                move.l  (V_int_run_count).w,(RNG_seed).w
                move.b  #1,(Boss_flag).w
                move.w  #$100,y_vel(a0)
                move.w  #$97,$2E(a0)
                move.l  #loc_752E6,$34(a0)
                move.l  #byte_75EAE,$30(a0)
                move.b  #$18,y_radius(a0)
                lea     ChildObjDat_75E84(pc),a2
                jsr     (CreateChild1_Normal).l
                jsr     (AllocateObject).l
                bne.s   loc_7529E
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

loc_7529E:
                lea     (ArtKosM_MHZMiniboss).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZMiniboss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_MHZMinibossLog).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZMinibossLog),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_MHZMiniboss_Explosion).l,a1
                jsr     (Load_PLC_Raw).l
                lea     Pal_MHZMiniboss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_752D4:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_752E6:
                move.b  #4,routine(a0)
                clr.w   y_vel(a0)
                move.b  x_pos+1(a0),$3A(a0)
                move.w  y_pos(a0),$3C(a0)
                move.b  #3,$39(a0)

loc_75302:
                move.w  #$80,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_7531C:
                jsr     (Animate_RawMultiDelay).l
                jsr     (Swing_UpAndDown_Count).l
                bne.s   loc_75330
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_75330:
                move.b  #6,routine(a0)
                move.w  $3C(a0),y_pos(a0)
                move.w  #$400,x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_75356,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_75356:
                move.b  #8,routine(a0)
                move.b  #5,mapping_frame(a0)
                move.w  #$4F,$2E(a0)
                move.l  #loc_753A4,$34(a0)
                move.w  #$6000,(Camera_target_max_X_pos).w
                move.w  #$6000,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   locret_75390
                move.l  #loc_75E1A,(a1)
                move.w  (Camera_max_X_pos).w,$34(a1)

locret_75390:
                rts
; ---------------------------------------------------------------------------

loc_75392:
                tst.b   render_flags(a0)
                bpl.s   locret_753B4
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_753A4:
                move.b  #$A,routine(a0)
                move.b  #4,mapping_frame(a0)
                addq.w  #2,x_pos(a0)

locret_753B4:
                rts
; ---------------------------------------------------------------------------

loc_753B6:
                move.w  x_vel(a0),d0
                addi.w  #-$20,d0
                move.w  d0,x_vel(a0)
                beq.s   loc_753CA
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_753CA:
                move.b  #$C,routine(a0)
                move.b  $3A(a0),x_pos+1(a0)
                clr.w   x_vel(a0)
                bra.w   loc_75302
; ---------------------------------------------------------------------------

loc_753DE:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                sub.w   (Camera_X_pos).w,d0
                cmpi.w  #$110,d0
                bls.s   loc_753FA
                rts
; ---------------------------------------------------------------------------

loc_753FA:
                move.b  #$E,routine(a0)
                move.l  #byte_75EBB,$30(a0)
                move.l  #loc_75444,$34(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_7541A:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Animate_RawMultiDelay).l
                beq.s   locret_75442
                cmpi.b  #$A,anim_frame(a0)
                bne.s   locret_75442
                subq.b  #1,$42(a0)
                moveq   #signextendB(sfx_ChopTree),d0
                jsr     (Play_SFX).l

locret_75442:
                rts
; ---------------------------------------------------------------------------

loc_75444:
                move.b  #$10,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_7544C:
                jsr     (Swing_UpAndDown).l
                tst.w   d3
                bne.s   loc_7545C
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_7545C:
                move.b  #$12,routine(a0)
                move.w  #$200,y_vel(a0)
                cmpi.b  #1,$42(a0)
                beq.s   loc_75480
                move.w  #$F,$2E(a0)
                move.l  #loc_754AC,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_75480:
                move.w  #7,$2E(a0)
                move.l  #loc_754BE,$34(a0)
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   locret_7549E
                move.l  #loc_754D6,$34(a0)

locret_7549E:
                rts
; ---------------------------------------------------------------------------

loc_754A0:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_754AC:
                move.b  #$E,routine(a0)
                move.l  #loc_75444,$34(a0)
                bra.w   loc_75302
; ---------------------------------------------------------------------------

loc_754BE:
                move.b  #$14,routine(a0)
                move.l  #byte_75ED0,$30(a0)
                move.l  #loc_75508,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_754D6:
                move.b  #$20,routine(a0)
                bra.w   loc_75302
; ---------------------------------------------------------------------------

loc_754E0:
                jsr     (Animate_RawMultiDelay).l
                beq.s   locret_75506
                cmpi.b  #$12,mapping_frame(a0)
                bne.s   loc_754F8
                moveq   #signextendB(sfx_ChopStuck),d0
                jsr     (Play_SFX).l

loc_754F8:
                cmpi.b  #$C,anim_frame(a0)
                bne.s   locret_75506
                subi.w  #$20,x_pos(a0)

locret_75506:
                rts
; ---------------------------------------------------------------------------

loc_75508:
                move.b  #$16,routine(a0)
                bset    #6,$38(a0)
                move.l  #byte_75EF3,$30(a0)
                move.w  #-$400,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_ChopStuck),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_75532:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_7554E
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_75550

locret_7554E:
                rts
; ---------------------------------------------------------------------------

loc_75550:
                move.b  #$18,routine(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$300,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_75564:
                jsr     (MoveSprite).l
                move.w  y_vel(a0),d0
                bmi.s   locret_75576
                cmpi.w  #$100,d0
                bhs.s   loc_75578

locret_75576:
                rts
; ---------------------------------------------------------------------------

loc_75578:
                move.b  #$1A,routine(a0)
                bclr    #6,$38(a0)
                move.w  #$100,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$10,$2E(a0)
                move.l  #loc_755A0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_755A0:
                move.b  #$1C,routine(a0)
                bset    #6,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_755AE:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_755C4
                move.w  y_pos(a0),d0
                cmp.w   $3C(a0),d0
                bhs.s   loc_755C6

locret_755C4:
                rts
; ---------------------------------------------------------------------------

loc_755C6:
                move.b  #$1E,routine(a0)
                move.b  #5,mapping_frame(a0)
                bclr    #6,$38(a0)
                move.w  $3C(a0),y_pos(a0)
                clr.w   y_pos+2(a0)
                clr.w   y_vel(a0)
                move.w  #$400,x_vel(a0)
                move.w  #$2A,$2E(a0)
                move.l  #loc_75330,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #byte_75F0D,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_7560C:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Animate_RawMultiDelay).l
                beq.s   locret_7565A
                cmpi.b  #$A,anim_frame(a0)
                bne.s   locret_7565A
                move.b  #$22,routine(a0)
                move.b  #$F,mapping_frame(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #byte_75F02,$30(a0)
                move.l  #loc_7566E,$34(a0)
                subq.b  #1,$42(a0)
                lea     ChildObjDat_75E9E(pc),a2
                jsr     (CreateChild1_Normal).l

locret_7565A:
                rts
; ---------------------------------------------------------------------------

loc_7565C:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_7566E:
                move.b  #$24,routine(a0)
                move.w  #-$80,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_7568A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7568A:
                move.b  #$26,routine(a0)
                bra.w   loc_75302
; ---------------------------------------------------------------------------

loc_75694:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                btst    #2,$38(a0)
                bne.s   loc_756AA
                rts
; ---------------------------------------------------------------------------

loc_756AA:
                move.b  #$28,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.w  #-$200,y_vel(a0)
                move.l  #byte_75EAE,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_756C6:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$30,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_756E2
                rts
; ---------------------------------------------------------------------------

loc_756E2:
                move.b  #$2A,routine(a0)
                move.w  d0,y_pos(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_75708,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_756FC:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_75708:
                move.b  #$2C,routine(a0)
                move.w  #-$400,x_vel(a0)
                move.w  #$700,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_7571C:
                jsr     (Animate_RawMultiDelay).l
                move.w  y_vel(a0),d0
                addi.w  #-$48,d0
                cmpi.w  #-$700,d0
                blt.s   loc_75734
                move.w  d0,y_vel(a0)

loc_75734:
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$80,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_7574A
                rts
; ---------------------------------------------------------------------------

loc_7574A:
                move.b  #$2E,routine(a0)
                move.b  #5,mapping_frame(a0)
                move.w  (Camera_X_pos_copy).w,d0
                addi.w  #$30,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$5C,d0
                move.w  d0,y_pos(a0)
                move.w  #$400,x_vel(a0)
                move.w  #$400,y_vel(a0)
                move.w  #$37,$2E(a0)
                move.l  #loc_75330,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #byte_75F0D,$30(a0)
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_757A0:
                move.w  y_vel(a0),d0
                addi.w  #-$10,d0
                bmi.s   loc_757AE
                move.w  d0,y_vel(a0)

loc_757AE:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_757BA:
                jmp     (Obj_EndSignControl).l
; ---------------------------------------------------------------------------

loc_757C0:
                move.l  #loc_757D6,(a0)
                bset    #4,shield_reaction(a0)
                lea     word_75E5E(pc),a1
                jmp     (SetUp_ObjAttributes2).l
; ---------------------------------------------------------------------------

loc_757D6:
                bsr.w   MHZMiniPart_SetFramePriorityOffsets
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #6,$38(a1)
                bne.w   loc_7582A
                move.b  (V_int_run_count+3).w,d0
                btst    #0,d0
                bne.w   loc_7582A
                andi.b  #$F,d0
                bne.s   loc_75824
                tst.b   render_flags(a0)
                bpl.s   loc_75824
                jsr     (AllocateObject).l
                bne.s   loc_75824
                move.l  #loc_759FC,(a1)
                move.w  a0,parent3(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)

loc_75824:
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

loc_7582A:
                btst    #7,status(a1)
                bne.s   loc_75834
                rts
; ---------------------------------------------------------------------------

loc_75834:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_7583A:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_7584E(pc,d0.w),d1
                jsr     off_7584E(pc,d1.w)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
off_7584E:
                dc.w    loc_7585A-off_7584E
                dc.w    loc_7589E-off_7584E
                dc.w    loc_7592A-off_7584E
                dc.w    loc_75924-off_7584E
                dc.w    loc_7592A-off_7584E
                dc.w    loc_75986-off_7584E
; ---------------------------------------------------------------------------

loc_7585A:
                lea     word_75E7E(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #6,y_radius(a0)
                move.w  #-$300,y_vel(a0)
                move.l  #byte_75F1C,$30(a0)
                moveq   #0,d0
                lea     (Player_1).w,a1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                beq.s   loc_7589A
                smi     d1
                bpl.s   loc_7588E
                neg.w   d0

loc_7588E:
                swap    d0
                divu.w  #$3800,d0
                tst.b   d1
                beq.s   loc_7589A
                neg.w   d0

loc_7589A:
                move.w  d0,x_vel(a0)

loc_7589E:
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.s   loc_758B8
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_758B8
                bsr.w   MHZMiniThrown_BounceOrStartRecovery

loc_758B8:
                jmp     (Animate_RawMultiDelay).l
; End of function loc_757A0
