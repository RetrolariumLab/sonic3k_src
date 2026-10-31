; Owner: objects/bonus/gumball/sk
; Responsibility: Gumball machine controller, item mechanism and bonus-stage completion state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_GumballMachine:
                lea     ObjDat_GumballMachine(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_60CB8,(a0)
                move.w  a0,(_unkFAA4).w
                subi.w  #$100,y_pos(a0)
                move.w  y_pos(a0),$3A(a0)
                st      (Disable_death_plane).w
                move.l  (V_int_run_count).w,(RNG_seed).w
                move.w  (Saved_ring_count).w,(Ring_count).w
                move.b  (Saved_extra_life_flags).w,(Extra_life_flags).w
                move.b  #1,(Update_HUD_ring_count).w
                bset    #7,(Player_1+art_tile).w
                bset    #7,(Player_2+art_tile).w
                lea     ((RAM_start+$2000)&$FFFFFF).l,a1
                moveq   #-1,d0
                moveq   #bytesToLcnt($24),d1

loc_60CA8:
                move.l  d0,(a1)+
                dbf     d1,loc_60CA8
                lea     ChildObjDat_613F8(pc),a2
                jsr     (CreateChild1_Normal).l

loc_60CB8:
                bsr.w   sub_6126C
                lea     word_60D16(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                bne.s   loc_60CD0
                swap    d0
                tst.w   d0
                beq.s   loc_60D10

loc_60CD0:
                move.l  #loc_60D1E,(a0)
                move.l  #loc_60D32,$34(a0)
                bset    #1,$38(a0)
                movea.w d0,a1
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                scs     d1
                tst.w   y_vel(a1)
                bmi.s   loc_60CF8
                not.b   d1

loc_60CF8:
                bclr    #0,render_flags(a0)
                tst.b   d1
                beq.s   loc_60D08
                bset    #0,render_flags(a0)

loc_60D08:
                moveq   #signextendB(sfx_GumballTab),d0
                jsr     (Play_SFX).l

loc_60D10:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_60D16:
                dc.w    -$24,   $48,    -8,   $10
; ---------------------------------------------------------------------------

loc_60D1E:
                bsr.w   sub_6126C
                lea     byte_61450(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_60D32:
                move.l  #loc_60D40,(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_60D40:
                bsr.w   sub_6126C
                btst    #1,$38(a0)
                bne.s   loc_60D52
                move.l  #loc_60CB8,(a0)

loc_60D52:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_60D58:
                lea     ObjDat3_61398(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #$100,x_pos(a0)
                move.w  #$310,y_pos(a0)
                lea     ChildObjDat_61424(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #loc_60D7E,(a0)

loc_60D7E:
                btst    #1,$38(a0)
                bne.s   loc_60D96
                lea     (SolidObjectFull).l,a1
                bsr.w   sub_61314
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_60D96:
                clr.b   ((RAM_start+$2022)&$FFFFFF).l
                lea     ChildObjDat_6143E(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_60DAC:
                lea     ObjDat3_613C8(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #-$1000,$30(a0)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_60E36
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                jsr     SolidObjectFull2_1P
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_60DFC
                bset    #5,$38(a0)
                jsr     (sub_22F98).l

loc_60DFC:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                jsr     SolidObjectFull2_1P
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_60E1A
                jsr     (sub_22F98).l

loc_60E1A:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                btst    #5,$38(a0)
                beq.s   loc_60E46
                cmpi.b  #1,prev_anim(a0)
                bne.s   loc_60E46

loc_60E36:
                move.l  #MoveChkDel,(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

loc_60E46:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_60E4C:
                lea     ObjDat3_613BC(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_60E5C,(a0)

loc_60E5C:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_60E80
                move.l  #loc_60E8C,(a0)
                move.l  #loc_60EA2,$34(a0)
                lea     ChildObjDat_61444(pc),a2
                jsr     (CreateChild6_Simple).l

loc_60E80:
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_60E8C:
                lea     byte_6145B(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_60EA2:
                move.l  #loc_60E5C,(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                bclr    #3,$38(a1)

locret_60EB8:
                rts
; ---------------------------------------------------------------------------

loc_60EBA:
                lea     ObjDat3_613E0(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_60ECE,(a0)
                bsr.w   sub_612A8

loc_60ECE:
                move.w  y_vel(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$200,d0
                bhi.s   loc_60EE0
                move.w  d0,y_vel(a0)

loc_60EE0:
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                cmp.w   y_pos(a0),d0
                bls.s   loc_60EFC
                move.w  d0,y_pos(a0)
                bra.w   loc_60F0E
; ---------------------------------------------------------------------------

loc_60EFC:
                addi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                bhi.s   loc_60F0E
                jsr     (sub_610E0).l
                bne.s   loc_60F28

loc_60F0E:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$240,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_60F28
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_60F28:
                jmp     (Delete_Current_Sprite).l
