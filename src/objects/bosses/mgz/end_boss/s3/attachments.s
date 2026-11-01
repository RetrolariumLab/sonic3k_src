; Owner: objects/bosses/mgz/end_boss/s3
; Responsibility: Marble Garden end-boss attached actors, parent synchronization, movement and animation state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_4A5FC:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4A612(pc,d0.w),d1
                jsr     off_4A612(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_4A612:
                dc.w    loc_4A616-off_4A612
                dc.w    loc_4A63C-off_4A612
; ---------------------------------------------------------------------------

loc_4A616:
                lea     word_4B396(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                movea.w parent3(a0),a1
                cmpi.l  #Obj_MGZEndBoss,(a1)
                bne.s   loc_4A632
                bclr    #7,art_tile(a0)

loc_4A632:
                lea     ChildObjDat_4B3EE(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_4A63C:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_4A696
                cmpi.b  #2,subtype(a1)
                beq.s   loc_4A680
                btst    #1,$38(a1)
                beq.s   loc_4A67A
                bset    #1,$38(a0)
                bne.s   loc_4A680
                lea     ChildObjDat_4B416(pc),a2
                btst    #0,render_flags(a0)
                beq.s   loc_4A670
                lea     ChildObjDat_4B41E(pc),a2

loc_4A670:
                jsr     (CreateChild3_NormalRepeated).l
                bra.w   loc_4A680
; ---------------------------------------------------------------------------

loc_4A67A:
                bclr    #1,$38(a0)

loc_4A680:
                lea     byte_4AEBC(pc),a2
                bsr.w   SelectMGZBossAttachmentFrameAndDepthFromParentAngle
                lea     byte_4AEF6(pc),a2
                bsr.w   SelectMGZBossAttachmentOffsetsFromParentAngle
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

loc_4A696:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_4A69C:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4A6B2(pc,d0.w),d1
                jsr     off_4A6B2(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_4A6B2:
                dc.w    loc_4A6C6-off_4A6B2
                dc.w    loc_4A6E2-off_4A6B2
                dc.w    loc_4A716-off_4A6B2
                dc.w    loc_4A7B6-off_4A6B2
                dc.w    loc_4A7DA-off_4A6B2
                dc.w    loc_4A80C-off_4A6B2
                dc.w    loc_4A7DA-off_4A6B2
                dc.w    loc_4A80C-off_4A6B2
                dc.w    loc_4A7DA-off_4A6B2
                dc.w    loc_4A8C2-off_4A6B2
; ---------------------------------------------------------------------------

loc_4A6C6:
                lea     word_4B39C(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #2,routine(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A6E2:
                movea.w $44(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_4A696
                btst    #3,$38(a1)
                bne.s   loc_4A70C
                lea     byte_4AECC(pc),a2
                bsr.w   SelectMGZBossAttachmentFrameAndDepthFromParentAngle

loc_4A6FE:
                lea     byte_4AF06(pc),a2
                bsr.w   SelectMGZBossAttachmentOffsetsFromParentAngle
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

loc_4A70C:
                move.b  #4,routine(a0)
                bra.w   loc_4AF6C
; ---------------------------------------------------------------------------

loc_4A716:
                movea.w $44(a0),a1
                btst    #5,$38(a1)
                bne.w   loc_4A696
                btst    #3,$38(a1)
                beq.s   loc_4A73C
                btst    #1,$38(a1)
                bne.s   loc_4A74E
                jsr     (Animate_RawMultiDelay).l
                bra.s   loc_4A6FE
; ---------------------------------------------------------------------------

loc_4A73C:
                move.b  #6,routine(a0)
                move.l  #loc_4A7C0,$34(a0)
                bra.w   loc_4B01A
; ---------------------------------------------------------------------------

loc_4A74E:
                cmpi.b  #2,subtype(a1)
                beq.s   loc_4A77E
                move.b  #8,routine(a0)
                move.w  #$27,$2E(a0)
                move.l  #loc_4A7EC,$34(a0)
                bsr.w   SetMGZBossIndexedAngleVelocity
                bclr    #5,$38(a0)
                lea     ChildObjDat_4B40E(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_4A77E:
                move.b  #8,routine(a0)
                move.w  #$2F,$2E(a0)
                move.l  #loc_4A854,$34(a0)
                bclr    #2,$38(a0)
                bsr.w   LaunchMGZBossUpperDrillPassAndRecordPlan
                lea     ChildObjDat_4B426(pc),a2
                jsr     (CreateChild1_Normal).l

loc_4A7A6:
                bclr    #5,$38(a0)
                lea     ChildObjDat_4B40E(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_4A7B6:
                jsr     (Animate_RawMultiDelay).l
                bra.w   loc_4A6FE
; ---------------------------------------------------------------------------

loc_4A7C0:
                move.b  #2,routine(a0)
                move.w  #$1F,$2E(a0)
                movea.w $44(a0),a1
                move.l  #loc_4A7EC,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A7DA:
                jsr     (MoveSprite2).l
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4A7EC:
                move.b  #$A,routine(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)
                move.w  #0,$2E(a0)
                move.l  #loc_4A818,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A80C:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4A818:
                move.b  #8,routine(a0)
                movea.w parent3(a0),a1
                bclr    #3,$38(a1)
                neg.w   x_vel(a0)
                move.w  #$27,$2E(a0)
                move.l  #loc_4A83C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A83C:
                move.b  #4,routine(a0)
                movea.w $44(a0),a1
                bset    #5,$38(a0)
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_4A854:
                move.b  #$E,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_4A870,$34(a0)
                bset    #5,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A870:
                move.b  #8,routine(a0)
                move.w  #$2F,$2E(a0)
                move.l  #loc_4A89E,$34(a0)
                bsr.w   LaunchMGZBossLowerDrillPassFromUpperPlan
                lea     ChildObjDat_4B426(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_4A89A
                move.b  #2,subtype(a1)

loc_4A89A:
                bra.w   loc_4A7A6
; ---------------------------------------------------------------------------

loc_4A89E:
                move.b  #$12,routine(a0)
                ori.b   #$24,$38(a0)
                movea.w $44(a0),a1
                bset    #2,$38(a1)
                bclr    #1,$38(a1)
                subi.w  #$80,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A8C2:
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                bne.s   locret_4A8D4
                move.b  #4,routine(a0)

locret_4A8D4:
                rts
; ---------------------------------------------------------------------------

loc_4A8D6:
                lea     word_4B390(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_4A8E8,(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A8E8:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.w   loc_4A696
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_4A902:
                lea     word_4B39C(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                clr.b   collision_flags(a0)
                move.w  #$200,priority(a0)
                move.l  #loc_4A950,(a0)
                movea.w parent3(a0),a1
                move.w  angle(a1),d0
                move.w  byte_4A938(pc,d0.w),child_dx(a0)  ; and child_dy
                lsr.w   #1,d0
                move.b  RawAni_4A948(pc,d0.w),mapping_frame(a0)
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------
byte_4A938:
                dc.b    $C,   0
                dc.b    3,  -7
                dc.b    0,-$10
                dc.b    -3,  -7
                dc.b    -$C,   0
                dc.b    -3,   7
                dc.b    0, $10
                dc.b    $C,   0
RawAni_4A948:
                dc.b    $1C, $15, $2C, $2A, $2D, $2B, $29, $1C
                even
; ---------------------------------------------------------------------------

loc_4A950:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_4A970
                btst    #4,$38(a1)
                bne.s   loc_4A970
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4A970:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_4A976:
                move.l  #loc_4A99C,(a0)
                move.l  #loc_4A9BC,$34(a0)
                movea.w parent3(a0),a1
                move.w  angle(a1),angle(a0)
                move.b  render_flags(a1),render_flags(a0)
                move.w  #4,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A99C:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_4A9B6
                btst    #4,$38(a1)
                bne.s   loc_4A9B6
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4A9B6:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4A9BC:
                move.w  #4,$2E(a0)
                lea     ChildObjDat_4B42E(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_4A9CC:
                lea     word_4B3A2(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_4AA0A,(a0)
                move.w  #$2F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a2
                move.w  a2,$44(a0)
                move.w  angle(a1),angle(a0)
                move.w  subtype(a1),subtype(a0)
                bsr.w   SetMGZBossIndexedAngleVelocity
                bra.w   loc_4B2A0
; ---------------------------------------------------------------------------

loc_4AA0A:
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_4AA26
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                bra.w   loc_4B2A0
; ---------------------------------------------------------------------------

loc_4AA26:
                move.l  #loc_4AA3A,(a0)
                movea.w $44(a0),a1
                move.w  parent3(a1),$44(a0)
                bra.w   loc_4B2A0
; ---------------------------------------------------------------------------

loc_4AA3A:
                movea.w $44(a0),a1
                movea.w parent3(a1),a2
                move.w  y_pos(a1),d0
                move.b  subtype(a2),d1
                cmp.b   subtype(a0),d1
                bne.s   loc_4AA82
                tst.b   d1
                bne.s   loc_4AA6E
                moveq   #$10,d1
                btst    #1,(_unkFA83).w
                bne.s   loc_4AA60
                moveq   #$18,d1

loc_4AA60:
                add.w   d1,d0
                cmp.w   y_pos(a0),d0
                bcs.s   loc_4AA82

loc_4AA68:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_4AA6E:
                moveq   #$14,d1
                btst    #1,(_unkFA8A+1).w
                bne.s   loc_4AA7A
                moveq   #$1C,d1

loc_4AA7A:
                sub.w   d1,d0
                cmp.w   y_pos(a0),d0
                bls.s   loc_4AA68

loc_4AA82:
                bra.w   loc_4B2A0
