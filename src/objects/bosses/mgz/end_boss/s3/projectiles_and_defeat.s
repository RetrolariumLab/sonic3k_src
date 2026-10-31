; Owner: objects/bosses/mgz/end_boss/s3
; Responsibility: Marble Garden end-boss projectiles, detached effects, debris and defeat palette transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_4AA86:
                lea     word_4B3A2(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_4AAA2,(a0)
                bsr.w   sub_4AFE0
                move.l  #loc_4AABC,$34(a0)

loc_4AAA2:
                subq.w  #1,$2E(a0)
                bmi.s   loc_4AABC
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.w   locret_49DD8
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_4AABC:
                move.l  #loc_4AAD4,(a0)
                move.b  #$17,mapping_frame(a0)
                clr.w   $2E(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_4AAD4:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_4AAF6
                move.b  #$16,mapping_frame(a0)
                addq.w  #1,$2E(a0)
                jsr     (MoveSprite2).l
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_4AAF6:
                move.l  #loc_4AB04,(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_4AB04:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_4AB16
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_4AB16:
                move.l  #loc_4AB28,(a0)
                neg.w   x_vel(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_4AB28:
                subq.w  #1,$2E(a0)
                bmi.s   loc_4AB3A
                jsr     (MoveSprite2).l
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_4AB3A:
                move.b  #$17,mapping_frame(a0)
                move.l  #Delete_Current_Sprite,(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_4AB4E:
                lea     word_4B3A8(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_4AB8E,(a0)
                move.b  subtype(a0),d0
                subi.b  #4,d0
                move.b  d0,subtype(a0)
                beq.s   loc_4AB84
                move.w  #$380,priority(a0)
                movea.w parent3(a0),a1
                cmpi.l  #Obj_MGZEndBoss,(a1)
                bne.s   loc_4AB84
                bclr    #7,art_tile(a0)

loc_4AB84:
                lea     ChildObjDat_4B3F6(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_4AB8E:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_4ABB0
                lea     byte_4AF44(pc),a2
                bsr.w   sub_4AF16
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #$14,d0
                jmp     (Child_Draw_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------

loc_4ABB0:
                bset    #5,$38(a0)
                move.l  #Delete_Current_Sprite,(a0)
                rts
; ---------------------------------------------------------------------------

loc_4ABBE:
                lea     word_4B3AE(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_4ABFA,(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                tst.b   subtype(a1)
                beq.s   loc_4ABE4
                move.w  #$300,priority(a0)

loc_4ABE4:
                bclr    #7,art_tile(a0)
                btst    #7,art_tile(a1)
                beq.s   locret_4ABF8
                bset    #7,art_tile(a0)

locret_4ABF8:
                rts
; ---------------------------------------------------------------------------

loc_4ABFA:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_4AC30
                lea     byte_4AF58(pc),a2
                bsr.w   sub_4AF16
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   loc_4AC30
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_49DD8
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_4AC30:
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_4AC36:
                lea     ObjDat3_4B3B6(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_4AC4A,(a0)
                bra.w   loc_4B054
; ---------------------------------------------------------------------------

loc_4AC4A:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------
; unused
                lea     word_4B3C2(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_4AC72,(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                rts
; ---------------------------------------------------------------------------

loc_4AC72:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   loc_4ACA8
                btst    #6,status(a1)
                bne.s   loc_4AC9C
                lea     RawAni_4B584(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4AC9C:
                move.b  #2,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4ACA8:
                move.l  #loc_4ACBA,(a0)
                move.b  #3,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4ACBA:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_4ACC6:
                lea     word_4B396(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                jsr     (Refresh_ChildPositionAdjusted).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                beq.s   loc_4ACEA
                move.w  #$200,priority(a0)

loc_4ACEA:
                lsr.w   #1,d0
                addi.b  #$2E,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$28,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

loc_4ACFC:
                lea     ObjDat3_4B3C8(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_4AD68,(a0)
                move.w  #tiles_to_bytes(ArtTile_MGZEndBossScaled),$3A(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$140,d0
                move.w  d0,x_pos(a0)
                move.w  d0,$30(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$50,d0
                move.w  d0,y_pos(a0)
                move.w  d0,$34(a0)
                move.w  #-$400,x_vel(a0)
                move.b  #4,$40(a0)
                move.l  #ArtScaled_MGZEndBoss,$42(a0)
                move.b  #1,$3E(a0)
                bsr.w   sub_4B2C6
                moveq   #6,d0
                move.w  ground_vel(a0),d1
                beq.s   loc_4AD60
                cmpi.w  #$C,d1
                beq.s   loc_4AD60
                moveq   #$10,d0

loc_4AD60:
                move.w  d0,$2E(a0)
                bra.w   loc_4ADF4
; ---------------------------------------------------------------------------

loc_4AD68:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.w   loc_4AE30
                move.w  x_vel(a0),d0
                add.w   $2E(a0),d0
                cmpi.w  #-$100,d0
                bgt.s   loc_4AD88
                move.w  d0,x_vel(a0)

loc_4AD88:
                move.w  y_vel(a0),d0
                move.w  $3C(a0),d1
                bmi.s   loc_4AD9E
                add.w   d1,d0
                cmpi.w  #$400,d0
                ble.s   loc_4ADA6
                bra.w   loc_4ADAA
; ---------------------------------------------------------------------------

loc_4AD9E:
                add.w   d1,d0
                cmpi.w  #-$400,d0
                blt.s   loc_4ADAA

loc_4ADA6:
                move.w  d0,y_vel(a0)

loc_4ADAA:
                bsr.w   sub_4B30A
                move.w  $30(a0),d2
                move.w  $34(a0),d3
                moveq   #0,d0
                move.b  $40(a0),d0
                addq.w  #4,d0
                move.l  #$100,d4
                divu.w  d0,d4
                sub.w   d4,d2
                sub.w   d4,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   loc_4AE26
                move.b  $40(a0),d0
                add.b   $3E(a0),d0
                andi.b  #$7F,d0
                cmpi.b  #4,d0
                blo.w   loc_4ADF4
                move.b  d0,$40(a0)

loc_4ADF4:
                clr.w   (_unkF740).w
                move.l  a0,-(sp)
                jsr     (Init_ArtScaling).l
                movea.l (sp)+,a0
                move.l  a0,-(sp)
                move.w  art_tile(a0),d0
                jsr     (sub_22C90).l
                movea.l (sp)+,a0
                move.w  (_unkF740).w,d3
                lsl.w   #4,d3
                move.l  #Kos_decomp_buffer,d1
                move.w  $3A(a0),d2
                jsr     (Add_To_DMA_Queue).l

loc_4AE26:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_4AE30:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4AE36:
                subq.w  #1,$2E(a0)
                bpl.s   locret_4AE6A
                moveq   #0,d0
                move.b  $39(a0),d0
                move.w  word_4AE7C(pc,d0.w),$2E(a0)
                lsl.w   #4,d0
                lea     (Pal_MGZFadeCNZ).l,a1
                adda.w  d0,a1
                lea     (Normal_palette_line_4).w,a2
                moveq   #bytesToLcnt($20),d1

loc_4AE58:
                move.l  (a1)+,(a2)+
                dbf     d1,loc_4AE58
                addq.b  #2,$39(a0)
                cmpi.b  #$20,$39(a0)
                bhs.s   loc_4AE6C

locret_4AE6A:
                rts
; ---------------------------------------------------------------------------

loc_4AE6C:
                move.w  #$300,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
word_4AE7C:
                dc.w    $A
                dc.w    $A
                dc.w    $A
                dc.w    $A
                dc.w    $A
                dc.w    $A
                dc.w    $A
                dc.w    $A
                dc.w    $A
                dc.w    $64
                dc.w    5
                dc.w    5
                dc.w    5
                dc.w    5
                dc.w    $14
