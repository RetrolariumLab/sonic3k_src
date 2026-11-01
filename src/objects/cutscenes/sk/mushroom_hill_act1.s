; Owner: objects/cutscenes/sk
; Responsibility: Mushroom Hill first-act Knuckles encounter, switch actor and attached scene objects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_MHZ1:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_MHZ1_Index(pc,d0.w),d1
                jsr     CutsceneKnux_MHZ1_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
CutsceneKnux_MHZ1_Index:
                dc.w    loc_62B68-CutsceneKnux_MHZ1_Index
                dc.w    loc_62BB2-CutsceneKnux_MHZ1_Index
                dc.w    loc_62BC0-CutsceneKnux_MHZ1_Index
                dc.w    loc_62BE4-CutsceneKnux_MHZ1_Index
                dc.w    loc_62BF4-CutsceneKnux_MHZ1_Index
                dc.w    loc_62C42-CutsceneKnux_MHZ1_Index
                dc.w    loc_62C42-CutsceneKnux_MHZ1_Index
                dc.w    loc_62C90-CutsceneKnux_MHZ1_Index
; ---------------------------------------------------------------------------

loc_62B68:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bclr    #7,art_tile(a0)
                move.w  #(2*60)-1,$2E(a0)
                move.l  #byte_6669F,$30(a0)
                move.w  #$2B0,x_pos(a0)
                move.w  #$66C,y_pos(a0)
                move.w  #$200,x_vel(a0)
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_62BA2:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_62BA2
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_62BB2:
                subq.w  #1,$2E(a0)
                bpl.s   locret_62BBE
                move.b  #4,routine(a0)

locret_62BBE:
                rts
; ---------------------------------------------------------------------------

loc_62BC0:
                cmpi.w  #$360,x_pos(a0)
                bhs.s   loc_62BD4
                jsr     (Animate_Raw).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_62BD4:
                move.b  #6,routine(a0)
                lea     ChildObjDat_665B0(pc),a2
                jsr     (CreateChild6_Simple).l

loc_62BE4:
                btst    #3,$38(a0)
                bne.s   loc_62BEE
                rts
; ---------------------------------------------------------------------------

loc_62BEE:
                move.b  #8,routine(a0)

loc_62BF4:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                subi.w  #$28,d0
                cmp.w   x_pos(a0),d0
                bls.s   loc_62C14
                rts
; ---------------------------------------------------------------------------

loc_62C14:
                move.w  d0,x_pos(a0)
                move.b  #$A,routine(a0)
                move.b  #$17,y_radius(a0)
                move.w  #$100,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                move.l  #loc_62C5A,$34(a0)
                lea     byte_666AF(pc),a1
                jsr     (Set_Raw_Animation).l

loc_62C42:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite).l
                jsr     (ObjHitFloor_DoRoutine).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_62C5A:
                move.b  #$C,routine(a0)
                move.b  #$13,y_radius(a0)
                move.w  #-$300,y_vel(a0)
                move.l  #loc_62C76,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_62C76:
                move.b  #$E,routine(a0)
                move.w  #$200,x_vel(a0)
                clr.w   y_vel(a0)
                lea     byte_6669F(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_62C90:
                tst.b   render_flags(a0)
                bpl.w   loc_62422
                jsr     (Animate_Raw).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

Obj_MHZ1CutsceneKnuckles:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                tst.b   (Last_star_post_hit).w
                bne.w   CutsceneKnux_Delete
                tst.w   (SK_alone_flag).w
                bne.w   CutsceneKnux_Delete
                lea     (Player_1).w,a1
                moveq   #0,d0
                move.b  (_unkFAB8).w,d0
                move.w  MHZ1CutsceneKnuckles_Index(pc,d0.w),d0
                jmp     MHZ1CutsceneKnuckles_Index(pc,d0.w)
; ---------------------------------------------------------------------------
MHZ1CutsceneKnuckles_Index:
                dc.w    loc_62CDE-MHZ1CutsceneKnuckles_Index
                dc.w    loc_62CF8-MHZ1CutsceneKnuckles_Index
                dc.w    loc_62D2C-MHZ1CutsceneKnuckles_Index
                dc.w    loc_62D42-MHZ1CutsceneKnuckles_Index
                dc.w    loc_62D5A-MHZ1CutsceneKnuckles_Index
                dc.w    locret_62D6E-MHZ1CutsceneKnuckles_Index
                dc.w    loc_62D70-MHZ1CutsceneKnuckles_Index
; ---------------------------------------------------------------------------

loc_62CDE:
                move.b  #2,(_unkFAB8).w
                tst.l   (Player_2).w
                beq.s   loc_62CF8
                jsr     (AllocateObject).l
                bne.s   loc_62CF8
                move.l  #loc_62DAC,(a1)

loc_62CF8:
                move.w  #$389,d0
                cmp.w   x_pos(a1),d0
                bls.s   loc_62D04
                rts
; ---------------------------------------------------------------------------

loc_62D04:
                move.w  d0,x_pos(a1)
                move.b  #4,(_unkFAB8).w
                bclr    #0,render_flags(a1)
                bclr    #0,status(a1)
                st      (Ctrl_1_locked).w
                clr.w   (Ctrl_1_logical).w
                jsr     (Stop_Object).l
                bra.w   CutsceneSpawnKnucklesMusicFadeTransition
; ---------------------------------------------------------------------------

loc_62D2C:
                btst    #Status_InAir,status(a1)
                beq.s   loc_62D36
                rts
; ---------------------------------------------------------------------------

loc_62D36:
                move.b  #6,(_unkFAB8).w
                move.w  #$20,$2E(a0)

loc_62D42:
                subq.w  #1,$2E(a0)
                bmi.s   loc_62D4A
                rts
; ---------------------------------------------------------------------------

loc_62D4A:
                move.b  #8,(_unkFAB8).w
                st      (Scroll_lock).w
                move.w  #(button_down_mask<<8)|button_down_mask,(Ctrl_1_logical).w

loc_62D5A:
                addq.w  #2,(Camera_Y_pos).w
                cmpi.w  #$5B0,(Camera_Y_pos).w
                bhs.s   loc_62D68
                rts
; ---------------------------------------------------------------------------

loc_62D68:
                move.b  #$A,(_unkFAB8).w

locret_62D6E:
                rts
; ---------------------------------------------------------------------------

loc_62D70:
                clr.b   (_unkFAB8).w
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w
                clr.b   (Scroll_lock).w
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                move.b  #5,(Player_2+anim).w
                move.b  #1,(Last_star_post_hit).w
                move.w  #$190,(Saved_X_pos).w
                move.w  #$56C,(Saved_Y_pos).w
                jsr     (Save_Level_Data).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_62DAC:
                lea     (Player_2).w,a1
                cmpi.b  #4,(_unkFAB8).w
                bhs.s   loc_62DC4
                move.w  #$371,d0
                cmp.w   x_pos(a1),d0
                bls.s   loc_62DC4
                rts
; ---------------------------------------------------------------------------

loc_62DC4:
                move.w  d0,x_pos(a0)
                move.l  #loc_62DDC,(a0)
                st      (Ctrl_2_locked).w
                clr.w   (Ctrl_2_logical).w
                jsr     (Stop_Object).l

loc_62DDC:
                lea     (Player_2).w,a1
                move.b  (_unkFAB8).w,d0
                beq.s   loc_62E1A
                cmpi.b  #4,(_unkFAB8).w
                blo.s   loc_62E04
                move.w  #$371,d0
                cmp.w   x_pos(a1),d0
                bhi.s   locret_62E18
                move.b  #8,anim(a1)
                jmp     (Stop_Object).l
; ---------------------------------------------------------------------------

loc_62E04:
                tst.b   render_flags(a1)
                bmi.s   locret_62E18
                move.l  #loc_62DAC,(a0)
                clr.b   (Ctrl_2_locked).w
                clr.w   (Ctrl_2_logical).w

locret_62E18:
                rts
; ---------------------------------------------------------------------------

loc_62E1A:
                clr.b   (Ctrl_2_locked).w
                clr.w   (Ctrl_2_logical).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_MHZ1CutsceneButton:
                lea     ObjDat_MHZ1CutsceneButton(pc),a1
                jsr     (SetUp_ObjAttributes).l
                lea     ChildObjDat_665B6(pc),a2
                jsr     (CreateChild6_Simple).l
                move.l  #loc_62F0A,(a0)
                tst.b   (Last_star_post_hit).w
                bne.s   loc_62E56
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_62E56
                move.l  #loc_62E5C,(a0)

loc_62E56:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_62E5C:
                cmpi.b  #$A,(_unkFAB8).w
                bhs.s   loc_62E6A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_62E6A:
                move.l  #loc_62E92,(a0)
                lea     (ArtKosM_MHZKnuxPeer).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZKnuxPeer),d2
                jsr     (Queue_Kos_Module).l
                lea     ChildObjDat_665AA(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_62E92
                move.b  #$1C,subtype(a1)

loc_62E92:
                move.w  (_unkFAA4).w,d0
                beq.s   loc_62ECA
                movea.w d0,a1
                lea     word_65C48(pc),a2
                jsr     (Check_InMyRange).l
                beq.s   loc_62ECA
                move.l  #loc_62ED0,(a0)
                move.w  #1,$2E(a0)
                move.b  #1,mapping_frame(a0)
                bset    #1,$38(a0)
                st      (_unkFAA9).w
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

loc_62ECA:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_62ED0:
                bclr    #1,$38(a0)
                subq.w  #1,$2E(a0)
                bpl.s   loc_62EF6
                move.l  #Wait_Draw,(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_62EFC,$34(a0)
                move.b  #0,mapping_frame(a0)

loc_62EF6:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_62EFC:
                move.b  #$C,(_unkFAB8).w
                move.l  #loc_62F0A,(a0)
                rts
; ---------------------------------------------------------------------------

loc_62F0A:
                bsr.w   CutsceneKnucklesSolidThinWrapper
                move.b  status(a0),d1
                andi.b  #standing_mask,d1
                beq.s   loc_62F46
                move.l  #loc_62F4C,(a0)
                move.b  #1,mapping_frame(a0)
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l
                btst    #2,$38(a0)
                bne.s   loc_62F46
                bset    #1,$38(a0)
                not.b   (_unkFAA9).w
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

loc_62F46:
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

loc_62F4C:
                bclr    #1,$38(a0)
                bsr.w   CutsceneKnucklesSolidThinWrapper
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_62F6C
                move.l  #loc_62F0A,(a0)
                move.b  #0,mapping_frame(a0)

loc_62F6C:
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

loc_62F72:
                lea     ObjDat3_6643E(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_62FA2,(a0)
                move.w  #$374,x_pos(a0)
                move.w  #$66C,y_pos(a0)
                move.w  #$200,x_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_62FB4,$34(a0)

loc_62FA2:
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_62FB4:
                move.l  #loc_62FCA,(a0)
                move.l  #loc_62FDA,$34(a0)
                bset    #7,art_tile(a0)
                rts
; ---------------------------------------------------------------------------

loc_62FCA:
                lea     byte_666E1(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_62FDA:
                move.l  #loc_62FA2,(a0)
                move.w  #-$400,x_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_62FFC,$34(a0)
                bclr    #7,art_tile(a0)
                rts
; ---------------------------------------------------------------------------

loc_62FFC:
                movea.w parent3(a0),a1
                bset    #3,$38(a1)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_6300C:
                lea     ObjDat3_66462(pc),a1
                jsr     (SetUp_ObjAttributes).l
                movea.w parent3(a0),a1
                move.w  a0,$44(a1)
                move.l  #loc_6303C,(a0)
                move.w  #$390,x_pos(a0)
                move.w  #$620,y_pos(a0)
                tst.b   (_unkFAA9).w
                beq.s   loc_6303C
                addi.w  #$40,y_pos(a0)

loc_6303C:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_63078
                jsr     (CutsceneKnucklesSolidTallWrapper).l
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                tst.b   (_unkFAA9).w
                beq.s   loc_6306E
                tst.w   d0
                bne.s   loc_6306E
                cmpi.w  #$40,d2
                bhs.s   loc_6306E
                cmpi.w  #$60,d3
                blo.s   loc_63074

loc_6306E:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_63074:
                clr.b   (_unkFAA9).w

loc_63078:
                move.l  #loc_630A6,(a0)
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                move.w  #$100,d0
                tst.b   (_unkFAA9).w
                bne.s   loc_63094
                neg.w   d0

loc_63094:
                move.w  d0,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_630BE,$34(a0)

loc_630A6:
                jsr     (MoveSprite2).l
                jsr     (CutsceneKnucklesSolidTallWrapper).l
                jsr     (Obj_Wait).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_630BE:
                move.l  #loc_6303C,(a0)
                movea.w parent3(a0),a1
                bclr    #2,$38(a1)
                rts
; ---------------------------------------------------------------------------
word_630D0:
                dc.w    $648,  $848
                dc.w    $2D0,  $4D0
                dc.w    $748,  $748
word_630DC:
                dc.w    $3D0,  $3D0
