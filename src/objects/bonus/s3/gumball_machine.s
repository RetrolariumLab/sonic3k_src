; Owner: objects/bonus/s3
; Responsibility: Gumball bonus machine state, dispensers, item creation and sprite motion
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_GumballMachine:
                lea     ObjDat_GumballMachine(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_43892,(a0)
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

loc_43882:
                move.l  d0,(a1)+
                dbf     d1,loc_43882
                lea     ChildObjDat_43FC4(pc),a2
                jsr     (CreateChild1_Normal).l

loc_43892:
                bsr.w   S3GumballMachine_UpdateDescent
                lea     word_438F0(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                bne.s   loc_438AA
                swap    d0
                tst.w   d0
                beq.s   loc_438EA

loc_438AA:
                move.l  #loc_438F8,(a0)
                move.l  #loc_4390C,$34(a0)
                bset    #1,$38(a0)
                movea.w d0,a1
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                scs     d1
                tst.w   y_vel(a1)
                bmi.s   loc_438D2
                not.b   d1

loc_438D2:
                bclr    #0,render_flags(a0)
                tst.b   d1
                beq.s   loc_438E2
                bset    #0,render_flags(a0)

loc_438E2:
                moveq   #signextendB(sfx_GumballTab),d0
                jsr     (Play_SFX).l

loc_438EA:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_438F0:
                dc.w    -$24,   $48,    -8,   $10
; ---------------------------------------------------------------------------

loc_438F8:
                bsr.w   S3GumballMachine_UpdateDescent
                lea     byte_4401C(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4390C:
                move.l  #loc_4391A,(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_4391A:
                bsr.w   S3GumballMachine_UpdateDescent
                btst    #1,$38(a0)
                bne.s   loc_4392C
                move.l  #loc_43892,(a0)

loc_4392C:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_43932:
                lea     ObjDat3_43F64(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #$100,x_pos(a0)
                move.w  #$310,y_pos(a0)
                lea     word_43FF0(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #loc_43958,(a0)

loc_43958:
                btst    #1,$38(a0)
                bne.s   loc_43970
                lea     (SolidObjectFull).l,a1
                bsr.w   S3GumballPlatform_CallSolidity
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_43970:
                clr.b   ((RAM_start+$2022)&$FFFFFF).l
                lea     ChildObjDat_4400A(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_43986:
                lea     ObjDat3_43F94(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #-$1000,$30(a0)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_43A10
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                jsr     (SolidObjectFull2_1P).l
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_439D6
                bset    #5,$38(a0)
                jsr     (LaunchPlayerFromUpSpring).l

loc_439D6:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                jsr     (SolidObjectFull2_1P).l
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_439F4
                jsr     (LaunchPlayerFromUpSpring).l

loc_439F4:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                btst    #5,$38(a0)
                beq.s   loc_43A20
                cmpi.b  #1,prev_anim(a0)
                bne.s   loc_43A20

loc_43A10:
                move.l  #MoveChkDel,(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

loc_43A20:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_43A26:
                lea     ObjDat3_43F88(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_43A36,(a0)

loc_43A36:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_43A5A
                move.l  #loc_43A66,(a0)
                move.l  #loc_43A7C,$34(a0)
                lea     ChildObjDat_44010(pc),a2
                jsr     (CreateChild6_Simple).l

loc_43A5A:
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_43A66:
                lea     byte_44027(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_43A7C:
                move.l  #loc_43A36,(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                bclr    #3,$38(a1)

locret_43A92:
                rts
; ---------------------------------------------------------------------------

loc_43A94:
                lea     ObjDat3_43FAC(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_43AA8,(a0)
                bsr.w   S3GumballMachine_ChooseDrop

loc_43AA8:
                move.w  y_vel(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$200,d0
                bhi.s   loc_43ABA
                move.w  d0,y_vel(a0)

loc_43ABA:
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                cmp.w   y_pos(a0),d0
                bls.s   loc_43AD6
                move.w  d0,y_pos(a0)
                bra.w   loc_43AE8
; ---------------------------------------------------------------------------

loc_43AD6:
                addi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                bhi.s   loc_43AE8
                jsr     (S3Gumball_TryRewardNearbyPlayer).l
                bne.s   loc_43B02

loc_43AE8:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$240,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_43B02
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_43B02:
                jmp     (Delete_Current_Sprite).l
