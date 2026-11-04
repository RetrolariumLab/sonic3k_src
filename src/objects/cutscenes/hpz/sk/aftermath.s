; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace encounter aftermath, ship theft sequence and scripted player guidance through the scene
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_648E2:
                tst.b   (_unkFAAC).w
                bne.s   loc_648FA
                rts
; ---------------------------------------------------------------------------

loc_648EA:
                move.b  #$42,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_648F2:
                subq.w  #1,$2E(a0)
                bmi.s   loc_64964
                rts
; ---------------------------------------------------------------------------

loc_648FA:
                move.b  #$44,routine(a0)
                move.w  #$10,$2E(a0)
                clr.b   (Scroll_lock).w
                move.w  #$5C0,d0
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  d0,(Camera_stored_max_Y_pos).w
                moveq   #signextendB(sfx_BigRumble),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   loc_6492C
                move.l  #Obj_IncLevEndYGradual,(a1)

loc_6492C:
                bsr.w   loc_64930

loc_64930:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   locret_64950
                move.b  #$14,subtype(a1)
                move.w  #$1880,x_pos(a1)
                move.w  #$3D0,y_pos(a1)

locret_64950:
                rts
; ---------------------------------------------------------------------------

loc_64952:
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_6498A
                rts
; ---------------------------------------------------------------------------

loc_64964:
                move.b  #$46,routine(a0)
                move.b  #2,mapping_frame(a0)
                st      (Events_fg_4).w
                move.w  #$14,(Screen_shake_flag).w
                lea     ChildObjDat_6663E(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_64984:
                jmp     (Animate_Raw2MultiDelay).l
; ---------------------------------------------------------------------------

loc_6498A:
                add.w   d1,y_pos(a0)
                move.b  #$48,routine(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.l  #loc_649B4,$34(a0)
                lea     byte_6680A(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_649AE:
                jmp     (Animate_Raw2MultiDelay).l
; ---------------------------------------------------------------------------

loc_649B4:
                move.b  #$4A,routine(a0)
                move.l  #loc_649DE,$34(a0)
                lea     byte_6684F(pc),a1
                jsr     (Set_Raw_Animation).l
                lea     ChildObjDat_66644(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_649D6:
                subq.w  #1,$2E(a0)
                bmi.s   loc_64A1C
                rts
; ---------------------------------------------------------------------------

loc_649DE:
                move.b  #$4C,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$56,mapping_frame(a0)
                move.w  #7,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_64A00:
                jsr     (Animate_RawCheckResult).l
                subi.w  #$C,x_vel(a0)
                jsr     (MoveSprite2).l
                cmpi.w  #$1810,x_pos(a0)
                bls.s   loc_64A3C
                rts
; ---------------------------------------------------------------------------

loc_64A1C:
                move.b  #$4E,routine(a0)
                bset    #0,render_flags(a0)
                clr.w   x_vel(a0)
                lea     byte_6682F(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64A36:
                jmp     (Animate_Raw2MultiDelay).l
; ---------------------------------------------------------------------------

loc_64A3C:
                move.b  #$50,routine(a0)
                bclr    #0,render_flags(a0)
                move.w  #2,$44(a0)
                move.l  #Map_HPZKnucklesGrab,mappings(a0)
                move.b  #$E,mapping_frame(a0)
                move.l  #loc_64A8E,$34(a0)
                lea     byte_668AF(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64A6E:
                jsr     (Animate_Raw2MultiDelay).l
                beq.s   locret_64A8C
                cmpi.b  #6,anim_frame(a0)
                bne.w   locret_64A8C
                st      (_unkFAA2).w
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l

locret_64A8C:
                rts
; ---------------------------------------------------------------------------

loc_64A8E:
                move.b  #$52,routine(a0)
                bset    #0,render_flags(a0)
                move.l  #loc_64AE2,$34(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$56,mapping_frame(a0)
                lea     byte_66885(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64AC0:
                jsr     (Animate_RawCheckResult).l
                subi.w  #$C,x_vel(a0)
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                subi.w  #$40,d0
                cmp.w   x_pos(a0),d0
                bhs.s   loc_64B22
                rts
; ---------------------------------------------------------------------------

loc_64AE2:
                move.b  #$54,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #7,mapping_frame(a0)
                clr.w   x_vel(a0)
                lea     byte_6682F(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64B10:
                jsr     (Animate_RawMultiDelay).l
                btst    #6,(_unkFAB8).w
                bne.w   loc_64B80
                rts
; ---------------------------------------------------------------------------

loc_64B22:
                move.b  #$56,routine(a0)
                move.w  #4,$44(a0)
                move.l  #Map_SSZKnucklesTired,mappings(a0)
                clr.b   mapping_frame(a0)
                bclr    #0,render_flags(a0)
                move.w  #$161C,x_pos(a0)
                move.w  #$62C,y_pos(a0)
                move.w  #$1520,(Camera_stored_min_X_pos).w
                jsr     (AllocateObject).l
                bne.s   loc_64B60
                move.l  #Obj_DecLevStartXGradual,(a1)

loc_64B60:
                lea     byte_6671F(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64B6A:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                cmpi.w  #$15C0,x_pos(a0)
                bls.s   loc_64BC6
                rts
; ---------------------------------------------------------------------------

loc_64B80:
                move.b  #$58,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$9A,mapping_frame(a0)
                move.w  #-$1E0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                lea     byte_667C1(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64BB8:
                btst    #7,(_unkFAB8).w
                bne.s   loc_64C00
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_64BC6:
                move.b  #$5A,routine(a0)
                move.w  #$15C0,x_pos(a0)
                move.w  #$600,y_pos(a0)
                move.w  #4,$44(a0)
                move.l  #Map_SSZKnucklesTired,mappings(a0)
                clr.b   mapping_frame(a0)
                bclr    #0,render_flags(a0)
                lea     byte_6671F(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64BFA:
                jmp     (Animate_RawCheckResult).l
; ---------------------------------------------------------------------------

loc_64C00:
                move.b  #$5C,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$9A,mapping_frame(a0)
                lea     byte_667C1(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64C24:
                lea     ObjDat3_664E2(pc),a1
                jsr     (SetUp_ObjAttributes).l
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.w   CutsceneKnux_Delete
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                bclr    #0,render_flags(a0)
                btst    #0,render_flags(a1)
                beq.s   loc_64C5C
                bset    #0,render_flags(a0)

loc_64C5C:
                lea     byte_6683A(pc),a1
                jsr     (Animate_RawNoSST).l
                bsr.w   HPZKnucklesDustQueueDPLCWhenFrameChanges
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_64C70:
                lea     (Player_1).w,a1
                cmpi.w  #$14D0,x_pos(a1)
                blo.s   locret_64CA4
                move.l  #loc_64CA6,(a0)
                jsr     (Stop_Object).l
                st      (Ctrl_1_locked).w
                clr.w   (Ctrl_1_logical).w
                jsr     (AllocateObject).l
                bne.s   loc_64C9E
                move.l  #SKRuntime_SecondaryInput_BeginLogicalClearActorIfCodeExists,(a1)

loc_64C9E:
                move.w  #$300,(Camera_target_max_Y_pos).w

locret_64CA4:
                rts
; ---------------------------------------------------------------------------

loc_64CA6:
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.w   locret_6206C
                move.w  #(button_right_mask<<8)|button_right_mask,(Ctrl_1_logical).w
                cmpi.w  #$15A8,x_pos(a1)
                blo.w   locret_6206C
                move.l  #loc_64D1A,(a0)
                st      (Scroll_lock).w
                jsr     (AllocateObject).l
                bne.s   loc_64CE2
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

loc_64CE2:
                lea     (Player_1).w,a1
                clr.b   (Ctrl_1_locked).w
                move.b  #$83,object_control(a1)
                move.b  #$C4,mapping_frame(a1)
                cmpi.b  #1,character_id(a1)
                bne.s   loc_64D04
                move.b  #$B0,mapping_frame(a1)

loc_64D04:
                move.b  #7,anim(a1)
                clr.w   (Ctrl_1_logical).w
                jsr     (Stop_Object).l
                jmp     (Player_Load_PLC).l
; ---------------------------------------------------------------------------

loc_64D1A:
                move.w  (Camera_X_pos).w,d0
                addq.w  #2,d0
                move.w  d0,(Camera_X_pos).w
                cmpi.w  #$1580,d0
                blo.s   locret_64D36
                move.l  #loc_64D38,(a0)
                bset    #0,(_unkFAB8).w

locret_64D36:
                rts
; ---------------------------------------------------------------------------

loc_64D38:
                btst    #1,(_unkFAB8).w
                beq.s   locret_64D5A
                move.l  #loc_64D5C,(a0)
                lea     (Player_1).w,a1
                move.b  #0,object_control(a1)
                st      (Ctrl_1_locked).w
                move.w  #(button_right_mask<<8)|button_right_mask,(Ctrl_1_logical).w

locret_64D5A:
                rts
; ---------------------------------------------------------------------------

loc_64D5C:
                lea     (Player_1).w,a1
                move.w  x_vel(a1),d0
                cmpi.w  #$300,d0
                bls.s   loc_64D6E
                move.w  #$300,d0

loc_64D6E:
                move.w  d0,x_vel(a1)
                move.w  d0,ground_vel(a1)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,(Camera_X_pos).w
                move.w  #$17D0,d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   locret_64DA8
                move.l  #loc_64DAA,(a0)
                move.w  d0,(Camera_X_pos).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                move.w  (Camera_max_Y_pos).w,(Camera_min_Y_pos).w
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w

locret_64DA8:
                rts
; ---------------------------------------------------------------------------

loc_64DAA:
                btst    #5,(_unkFAB8).w
                beq.s   locret_64DCA
                move.l  #loc_64DCC,(a0)
                st      (Ctrl_1_locked).w
                jsr     (AllocateObject).l
                bne.s   locret_64DCA
                move.l  #SKRuntime_SecondaryInput_BeginLogicalClearActorIfCodeExists,(a1)

locret_64DCA:
                rts
; ---------------------------------------------------------------------------

loc_64DCC:
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   locret_64DDE
                move.l  #loc_64DE0,(a0)

locret_64DDE:
                rts
; ---------------------------------------------------------------------------

loc_64DE0:
                lea     (Player_1).w,a1
                move.w  #(button_right_mask<<8)|button_right_mask,d0
                move.w  x_pos(a1),d1
                subi.w  #$1892,d1
                bcs.s   loc_64DF6
                move.w  #(button_left_mask<<8)|button_left_mask,d0

loc_64DF6:
                move.w  d0,(Ctrl_1_logical).w
                tst.w   d1
                bpl.s   loc_64E00
                neg.w   d1

loc_64E00:
                cmpi.w  #4,d1
                bhi.w   locret_6206C
                move.l  #loc_64E28,(a0)
                move.w  #$3F,$2E(a0)
                st      (_unkFAAC).w
                clr.w   (Ctrl_1_logical).w
                jsr     (Stop_Object).l
                jmp     (Player_Load_PLC).l
; ---------------------------------------------------------------------------

loc_64E28:
                subq.w  #1,$2E(a0)
                bpl.s   locret_64E44
                move.l  #loc_64E46,(a0)
                lea     (Player_1).w,a1
                bset    #0,render_flags(a1)
                bset    #Status_Facing,status(a1)

locret_64E44:
                rts
; ---------------------------------------------------------------------------

loc_64E46:
                lea     (Player_1).w,a1
                cmpi.w  #$580,y_pos(a1)
                blo.s   locret_64E6A
                btst    #Status_InAir,status(a1)
                bne.s   locret_64E6A
                move.l  #loc_64E6C,(a0)
                clr.b   (Ctrl_1_locked).w
                move.w  #$5C0,(Camera_min_Y_pos).w

locret_64E6A:
                rts
; ---------------------------------------------------------------------------

loc_64E6C:
                lea     (Player_1).w,a1
                cmpi.w  #$1660,x_pos(a1)
                bhs.w   locret_6206C
                move.l  #locret_64E86,(a0)
                clr.b   (Ctrl_2_locked).w
                rts
; ---------------------------------------------------------------------------

locret_64E86:
                rts
