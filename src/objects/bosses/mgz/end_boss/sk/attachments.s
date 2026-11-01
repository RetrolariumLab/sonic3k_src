; Owner: objects/bosses/mgz/end_boss/sk
; Responsibility: Marble Garden end-boss attached actors, parent synchronization, movement and animation state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_6C948:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_6C95E(pc,d0.w),d1
                jsr     off_6C95E(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_6C95E:
                dc.w    loc_6C962-off_6C95E
                dc.w    loc_6C988-off_6C95E
; ---------------------------------------------------------------------------

loc_6C962:
                lea     word_6D782(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                movea.w parent3(a0),a1
                cmpi.l  #Obj_MGZEndBoss,(a1)
                bne.s   loc_6C97E
                bclr    #7,art_tile(a0)

loc_6C97E:
                lea     ChildObjDat_6D7DA(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6C988:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_6C9E2
                cmpi.b  #2,subtype(a1)
                beq.s   loc_6C9CC
                btst    #1,$38(a1)
                beq.s   loc_6C9C6
                bset    #1,$38(a0)
                bne.s   loc_6C9CC
                lea     ChildObjDat_6D802(pc),a2
                btst    #0,render_flags(a0)
                beq.s   loc_6C9BC
                lea     ChildObjDat_6D80A(pc),a2

loc_6C9BC:
                jsr     (CreateChild3_NormalRepeated).l
                bra.w   loc_6C9CC
; ---------------------------------------------------------------------------

loc_6C9C6:
                bclr    #1,$38(a0)

loc_6C9CC:
                lea     byte_6D24A(pc),a2
                bsr.w   SelectMGZBossAttachmentFrameAndDepthFromParentAngle
                lea     byte_6D284(pc),a2
                bsr.w   SelectMGZBossAttachmentOffsetsFromParentAngle
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

loc_6C9E2:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_6C9E8:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_6C9FE(pc,d0.w),d1
                jsr     off_6C9FE(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_6C9FE:
                dc.w    loc_6CA12-off_6C9FE
                dc.w    loc_6CA2E-off_6C9FE
                dc.w    loc_6CA62-off_6C9FE
                dc.w    loc_6CB14-off_6C9FE
                dc.w    loc_6CB38-off_6C9FE
                dc.w    loc_6CB6A-off_6C9FE
                dc.w    loc_6CB38-off_6C9FE
                dc.w    loc_6CB6A-off_6C9FE
                dc.w    loc_6CB38-off_6C9FE
                dc.w    loc_6CC32-off_6C9FE
; ---------------------------------------------------------------------------

loc_6CA12:
                lea     word_6D788(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #2,routine(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                rts
; ---------------------------------------------------------------------------

loc_6CA2E:
                movea.w $44(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_6C9E2
                btst    #3,$38(a1)
                bne.s   loc_6CA58
                lea     byte_6D25A(pc),a2
                bsr.w   SelectMGZBossAttachmentFrameAndDepthFromParentAngle

loc_6CA4A:
                lea     byte_6D294(pc),a2
                bsr.w   SelectMGZBossAttachmentOffsetsFromParentAngle
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

loc_6CA58:
                move.b  #4,routine(a0)
                bra.w   loc_6D2FA
; ---------------------------------------------------------------------------

loc_6CA62:
                movea.w $44(a0),a1
                btst    #5,$38(a1)
                bne.w   loc_6C9E2
                btst    #3,$38(a1)
                beq.s   loc_6CA88
                btst    #1,$38(a1)
                bne.s   loc_6CA9A
                jsr     (Animate_RawMultiDelay).l
                bra.s   loc_6CA4A
; ---------------------------------------------------------------------------

loc_6CA88:
                move.b  #6,routine(a0)
                move.l  #loc_6CB1E,$34(a0)
                bra.w   loc_6D3A8
; ---------------------------------------------------------------------------

loc_6CA9A:
                cmpi.b  #2,subtype(a1)
                beq.s   loc_6CACA
                move.b  #8,routine(a0)
                move.w  #$27,$2E(a0)
                move.l  #loc_6CB4A,$34(a0)
                bsr.w   SetMGZBossIndexedAngleVelocity
                bclr    #5,$38(a0)
                lea     ChildObjDat_6D7FA(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6CACA:
                move.b  #8,routine(a0)
                move.w  #$37,$2E(a0)
                move.l  #loc_6CBB2,$34(a0)
                bclr    #2,$38(a0)
                bsr.w   LaunchMGZBossUpperDrillPassAndRecordPlan
                lea     ChildObjDat_6D812(pc),a2
                jsr     (CreateChild1_Normal).l
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_6D83E(pc),a2
                jsr     (CreateChild6_Simple).l

loc_6CB04:
                bclr    #5,$38(a0)
                lea     ChildObjDat_6D7FA(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6CB14:
                jsr     (Animate_RawMultiDelay).l
                bra.w   loc_6CA4A
; ---------------------------------------------------------------------------

loc_6CB1E:
                move.b  #2,routine(a0)
                move.w  #$1F,$2E(a0)
                movea.w $44(a0),a1
                move.l  #loc_6CB4A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6CB38:
                jsr     (MoveSprite2).l
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6CB4A:
                move.b  #$A,routine(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)
                move.w  #0,$2E(a0)
                move.l  #loc_6CB76,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6CB6A:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6CB76:
                move.b  #8,routine(a0)
                movea.w parent3(a0),a1
                bclr    #3,$38(a1)
                neg.w   x_vel(a0)
                move.w  #$27,$2E(a0)
                move.l  #loc_6CB9A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6CB9A:
                move.b  #4,routine(a0)
                movea.w $44(a0),a1
                bset    #5,$38(a0)
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_6CBB2:
                move.b  #$E,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_6CBCE,$34(a0)
                bset    #5,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_6CBCE:
                move.b  #8,routine(a0)
                move.w  #$2F,$2E(a0)
                move.l  #loc_6CC0E,$34(a0)
                bsr.w   LaunchMGZBossLowerDrillPassFromUpperPlan
                lea     ChildObjDat_6D812(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_6CBF8
                move.b  #2,subtype(a1)

loc_6CBF8:
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_6D83E(pc),a2
                jsr     (CreateChild6_Simple).l
                bra.w   loc_6CB04
; ---------------------------------------------------------------------------

loc_6CC0E:
                move.b  #$12,routine(a0)
                ori.b   #$24,$38(a0)
                movea.w $44(a0),a1
                bset    #2,$38(a1)
                bclr    #1,$38(a1)
                subi.w  #$80,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_6CC32:
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                bne.s   locret_6CC44
                move.b  #4,routine(a0)

locret_6CC44:
                rts
; ---------------------------------------------------------------------------

loc_6CC46:
                lea     word_6D77C(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_6CC58,(a0)
                rts
; ---------------------------------------------------------------------------

loc_6CC58:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.w   loc_6C9E2
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_6CC72:
                lea     word_6D788(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                clr.b   collision_flags(a0)
                move.w  #$200,priority(a0)
                move.l  #loc_6CCC0,(a0)
                movea.w parent3(a0),a1
                move.w  angle(a1),d0
                move.w  byte_6CCA8(pc,d0.w),child_dx(a0)  ; and child_dy
                lsr.w   #1,d0
                move.b  RawAni_6CCB8(pc,d0.w),mapping_frame(a0)
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------
byte_6CCA8:
                dc.b    $C,   0
                dc.b    3,  -7
                dc.b    0,-$10
                dc.b    -3,  -7
                dc.b    -$C,   0
                dc.b    -3,   7
                dc.b    0, $10
                dc.b    $C,   0
RawAni_6CCB8:
                dc.b    $1C, $15, $2C, $2A, $2D, $2B, $29, $1C
                even
; ---------------------------------------------------------------------------

loc_6CCC0:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_6CCE0
                btst    #4,$38(a1)
                bne.s   loc_6CCE0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6CCE0:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_6CCE6:
                move.l  #loc_6CD12,(a0)
                move.l  #loc_6CD32,$34(a0)
                movea.w parent3(a0),a1
                move.w  angle(a1),angle(a0)
                move.b  render_flags(a1),render_flags(a0)
                bclr    #7,render_flags(a0)
                move.w  #4,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_6CD12:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_6CD2C
                btst    #4,$38(a1)
                bne.s   loc_6CD2C
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6CD2C:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_6CD32:
                move.w  #4,$2E(a0)
                lea     ChildObjDat_6D81A(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6CD42:
                lea     word_6D794(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_6CD80,(a0)
                move.w  #$2F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a2
                move.w  a2,$44(a0)
                move.w  angle(a1),angle(a0)
                move.w  subtype(a1),subtype(a0)
                bsr.w   SetMGZBossIndexedAngleVelocity
                bra.w   loc_6D6A6
; ---------------------------------------------------------------------------

loc_6CD80:
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_6CD9C
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                bra.w   loc_6D6A6
; ---------------------------------------------------------------------------

loc_6CD9C:
                move.l  #loc_6CDB0,(a0)
                movea.w $44(a0),a1
                move.w  parent3(a1),$44(a0)
                bra.w   loc_6D6A6
; ---------------------------------------------------------------------------

loc_6CDB0:
                movea.w $44(a0),a1
                movea.w parent3(a1),a2
                move.w  y_pos(a1),d0
                move.b  subtype(a2),d1
                cmp.b   subtype(a0),d1
                bne.s   loc_6CDE4
                tst.b   d1
                bne.s   loc_6CDDA
                moveq   #8,d1
                add.w   d1,d0
                cmp.w   y_pos(a0),d0
                blt.s   loc_6CDE4

loc_6CDD4:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_6CDDA:
                moveq   #8,d1
                sub.w   d1,d0
                cmp.w   y_pos(a0),d0
                ble.s   loc_6CDD4

loc_6CDE4:
                bra.w   loc_6D6A6
