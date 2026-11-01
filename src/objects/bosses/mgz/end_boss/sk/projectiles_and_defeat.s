; Owner: objects/bosses/mgz/end_boss/sk
; Responsibility: Marble Garden end-boss projectiles, detached effects, debris and defeat palette transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_6CDE8:
                lea     word_6D78E(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_6CE04,(a0)
                bsr.w   InitializeMGZBossStaggeredTrailVelocityAndDelay
                move.l  #loc_6CE1E,$34(a0)

loc_6CE04:
                subq.w  #1,$2E(a0)
                bmi.s   loc_6CE1E
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.w   locret_6BF96
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_6CE1E:
                move.l  #loc_6CE36,(a0)
                move.b  #$17,mapping_frame(a0)
                clr.w   $2E(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_6CE36:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_6CE58
                move.b  #$16,mapping_frame(a0)
                addq.w  #1,$2E(a0)
                jsr     (MoveSprite2).l
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_6CE58:
                move.l  #loc_6CE66,(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_6CE66:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_6CE78
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_6CE78:
                move.l  #loc_6CE8A,(a0)
                neg.w   x_vel(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_6CE8A:
                subq.w  #1,$2E(a0)
                bmi.s   loc_6CE9C
                jsr     (MoveSprite2).l
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_6CE9C:
                move.b  #$17,mapping_frame(a0)
                move.l  #Delete_Current_Sprite,(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

loc_6CEB0:
                lea     word_6D79A(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_6CEF0,(a0)
                move.b  subtype(a0),d0
                subi.b  #4,d0
                move.b  d0,subtype(a0)
                beq.s   loc_6CEE6
                move.w  #$380,priority(a0)
                movea.w parent3(a0),a1
                cmpi.l  #Obj_MGZEndBoss,(a1)
                bne.s   loc_6CEE6
                bclr    #7,art_tile(a0)

loc_6CEE6:
                lea     ChildObjDat_6D7E2(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6CEF0:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_6CF12
                lea     byte_6D2D2(pc),a2
                bsr.w   SelectMGZBossPoseChildOffsetsAndFrame
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #$14,d0
                jmp     (Child_Draw_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------

loc_6CF12:
                bset    #5,$38(a0)
                move.l  #Delete_Current_Sprite,(a0)
                rts
; ---------------------------------------------------------------------------

loc_6CF20:
                lea     word_6D7A0(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_6CF62,(a0)
                bset    #4,shield_reaction(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                tst.b   subtype(a1)
                beq.s   loc_6CF4C
                move.w  #$300,priority(a0)

loc_6CF4C:
                bclr    #7,art_tile(a0)
                btst    #7,art_tile(a1)
                beq.s   locret_6CF60
                bset    #7,art_tile(a0)

locret_6CF60:
                rts
; ---------------------------------------------------------------------------

loc_6CF62:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_6CF98
                lea     byte_6D2E6(pc),a2
                bsr.w   SelectMGZBossPoseChildOffsetsAndFrame
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   loc_6CF98
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_6BF96
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_6CF98:
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_6CF9E:
                lea     ObjDat3_6D7A8(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_6CFB2,(a0)
                bra.w   loc_6D3E2
; ---------------------------------------------------------------------------

loc_6CFB2:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

loc_6CFBE:
                lea     word_6D782(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                jsr     (Refresh_ChildPositionAdjusted).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                beq.s   loc_6CFE2
                move.w  #$200,priority(a0)

loc_6CFE2:
                lsr.w   #1,d0
                addi.b  #$2E,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$28,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

loc_6CFF4:
                lea     ObjDat3_6D7B4(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_6D060,(a0)
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
                bsr.w   SelectMGZBossScaledFlybyAndNextEntryPattern
                moveq   #6,d0
                move.w  ground_vel(a0),d1
                beq.s   loc_6D058
                cmpi.w  #$C,d1
                beq.s   loc_6D058
                moveq   #$10,d0

loc_6D058:
                move.w  d0,$2E(a0)
                bra.w   loc_6D0EE
; ---------------------------------------------------------------------------

loc_6D060:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.w   loc_6D0FE
                move.w  x_vel(a0),d0
                add.w   $2E(a0),d0
                cmpi.w  #-$100,d0
                bgt.s   loc_6D080
                move.w  d0,x_vel(a0)

loc_6D080:
                move.w  y_vel(a0),d0
                move.w  $3C(a0),d1
                bmi.s   loc_6D096
                add.w   d1,d0
                cmpi.w  #$400,d0
                ble.s   loc_6D09E
                bra.w   loc_6D0A2
; ---------------------------------------------------------------------------

loc_6D096:
                add.w   d1,d0
                cmpi.w  #-$400,d0
                blt.s   loc_6D0A2

loc_6D09E:
                move.w  d0,y_vel(a0)

loc_6D0A2:
                jsr     (IntegrateScaledObjectCenter).l
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
                bne.s   loc_6D0F4
                move.b  $40(a0),d0
                add.b   $3E(a0),d0
                andi.b  #$7F,d0
                cmpi.b  #4,d0
                blo.w   loc_6D0EE
                move.b  d0,$40(a0)

loc_6D0EE:
                jsr     (Perform_Art_Scaling).l

loc_6D0F4:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_6D0FE:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_6D104:
                subq.w  #1,$2E(a0)
                bpl.w   locret_6BF96
                moveq   #0,d0
                move.b  $39(a0),d0
                move.w  word_6D14C(pc,d0.w),$2E(a0)
                lsl.w   #4,d0
                lea     (Pal_MGZFadeCNZ).l,a1
                adda.w  d0,a1
                lea     (Normal_palette_line_4).w,a2
                moveq   #bytesToLcnt($20),d1

loc_6D128:
                move.l  (a1)+,(a2)+
                dbf     d1,loc_6D128
                addq.b  #2,$39(a0)
                cmpi.b  #$20,$39(a0)
                blo.w   locret_6BF96

loc_6D13C:
                move.w  #$300,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
word_6D14C:
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
; ---------------------------------------------------------------------------

loc_6D16A:
                movea.w parent3(a0),a1
                move.w  (Camera_Y_pos).w,d0
                move.w  d0,d1
                moveq   #$18,d2
                addi.w  #$70,d0
                cmp.w   y_pos(a1),d0
                bge.s   loc_6D18A
                move.w  #$C8,d2
                bset    #2,$38(a0)

loc_6D18A:
                add.w   d2,d1
                move.w  d1,y_pos(a0)
                move.l  #Obj_Wait,(a0)
                move.b  #9,$39(a0)
                move.l  #loc_6D1A6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6D1A6:
                subq.b  #1,$39(a0)
                bmi.w   loc_6CD2C
                move.w  #3,$2E(a0)
                lea     ChildObjDat_6D844(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_6D1BE:
                lea     ObjDat3_6D7A8(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_6D1D2,(a0)
                bsr.w   RandomizeMGZBossCollapseDebrisFrameAndVelocity

loc_6D1D2:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l

; =============== S U B R O U T I N E =======================================

RandomizeMGZBossCollapseDebrisFrameAndVelocity:
                jsr     (Random_Number).l
                move.w  d0,d1
                andi.w  #3,d0
                move.b  RawAni_6D224(pc,d0.w),mapping_frame(a0)
                andi.w  #$3FF,d1
                btst    #0,d1
                beq.s   loc_6D1FC
                neg.w   d1

loc_6D1FC:
                move.w  d1,x_vel(a0)
                swap    d0
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   locret_6D222
                andi.w  #$1FF,d0
                addi.w  #$200,d0
                btst    #0,d0
                beq.s   loc_6D21E
                neg.w   d0

loc_6D21E:
                move.w  d0,y_vel(a0)

locret_6D222:
                rts
; End of function RandomizeMGZBossCollapseDebrisFrameAndVelocity

; ---------------------------------------------------------------------------
RawAni_6D224:
                dc.b    0,   1,   2,   0
                even
