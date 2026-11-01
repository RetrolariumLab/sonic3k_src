; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss secondary attack and defeat actors, scene callbacks and child state progression
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

loc_80A3A:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_80A5C(pc,d0.w),d1
                jsr     off_80A5C(pc,d1.w)
                tst.b   subtype(a0)
                bne.s   loc_80A56
                bsr.w   PositionDEZFinalChildFromParentWordOffsets
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_80A56:
                bsr.s   PositionDEZFinalAttackXFromParentOffsetOnly
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
off_80A5C:
                dc.w    loc_80A60-off_80A5C
                dc.w    loc_80A98-off_80A5C
; ---------------------------------------------------------------------------

loc_80A60:
                lea     ObjDat3_8129E(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #4,shield_reaction(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                cmpi.b  #2,d0
                bne.s   loc_80A82
                bset    #0,render_flags(a0)

loc_80A82:
                lsl.w   #2,d0
                move.l  off_80A8C(pc,d0.w),$30(a0)
                rts
; ---------------------------------------------------------------------------
off_80A8C:
                dc.l    byte_80AD4
                dc.l    byte_80AEE
                dc.l    byte_80B08
; ---------------------------------------------------------------------------

loc_80A98:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_80ACE
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #4,d0
                move.b  d0,anim_frame(a0)
                movea.l $30(a0),a1
                lea     (a1,d0.w),a1
                move.b  (a1)+,d1
                bmi.s   loc_80AD0
                move.b  d1,mapping_frame(a0)
                move.b  (a1)+,anim_frame_timer(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,$42(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,$44(a0)

locret_80ACE:
                rts
; ---------------------------------------------------------------------------

loc_80AD0:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------
byte_80AD4:
                dc.b    6,   0,   0,   0
                dc.b    7,   1,   0,   4
                dc.b    8,   4,   0,   4
                dc.b    9,   4,   0,   0
                dc.b    $A,   5,   0,   4
                dc.b    $B,   5,   0,   0
                dc.b    $FF, $F4
byte_80AEE:
                dc.b    $C,   0,   0,   0
                dc.b    $D,   1,   4,  -4
                dc.b    $E,   4,   4,  -4
                dc.b    $F,   4,   0,   0
                dc.b    $10,   5,   0,   0
                dc.b    $11,   5,   0,   4
                dc.b    $FF, $F4
byte_80B08:
                dc.b    $C,   0,   0,   0
                dc.b    $D,   1,   4,  -4
                dc.b    $E,   4,   4,  -4
                dc.b    $F,   4,   0,   0
                dc.b    $10,   5,   0,   0
                dc.b    $12,   5,   4,  -4
                dc.b    $FF, $F4
; ---------------------------------------------------------------------------

loc_80B22:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_80B58(pc,d0.w),d1
                jsr     off_80B58(pc,d1.w)
                move.b  $3A(a0),d0
                andi.b  #7,d0
                cmpi.b  #7,d0
                beq.s   loc_80B42
                bra.w   PositionDEZFinalAttackXFromParentOffsetOnly
; ---------------------------------------------------------------------------

loc_80B42:
                lea     (_unkFA82).w,a1
                tst.b   subtype(a0)
                beq.s   loc_80B50
                lea     (_unkFA83).w,a1

loc_80B50:
                st      (a1)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
off_80B58:
                dc.w    loc_80B66-off_80B58
                dc.w    loc_80B90-off_80B58
                dc.w    loc_80C2A-off_80B58
                dc.w    loc_80C58-off_80B58
                dc.w    loc_80C8A-off_80B58
                dc.w    loc_80CA6-off_80B58
                dc.w    loc_80C2A-off_80B58
; ---------------------------------------------------------------------------

loc_80B66:
                move.b  #2,routine(a0)
                move.b  #3,$39(a0)
                lea     ChildObjDat_81316(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  #-$80,d0
                tst.b   subtype(a0)
                beq.s   loc_80B86
                neg.w   d0

loc_80B86:
                move.w  d0,$42(a0)
                move.w  #$E3,y_pos(a0)

loc_80B90:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_80C0E
                move.w  (Player_1+x_pos).w,d0
                move.w  x_pos(a0),d1
                move.b  $3A(a0),d2
                moveq   #0,d3
                lsr.b   #1,d2
                bcc.s   loc_80BB6
                moveq   #-$20,d3
                lsr.b   #1,d2
                bcc.s   loc_80BB6
                moveq   #$20,d3

loc_80BB6:
                add.w   d3,d1
                sub.w   d1,d0
                smi     d1
                bpl.s   loc_80BC0
                neg.w   d0

loc_80BC0:
                cmpi.w  #$80,d0
                bhs.s   locret_80C0C
                cmpi.w  #4,d0
                bls.s   locret_80C0C
                move.w  #-$80,d0
                tst.b   subtype(a0)
                beq.s   loc_80BD8
                neg.w   d0

loc_80BD8:
                move.w  $42(a0),d2
                move.b  $3A(a0),d3
                moveq   #2,d4
                moveq   #2,d5

loc_80BE4:
                lsr.b   #1,d3
                bcc.s   loc_80BEA
                addq.w  #2,d4

loc_80BEA:
                dbf     d5,loc_80BE4
                tst.b   d1
                bne.s   loc_80C00
                addi.w  #$40,d0
                cmp.w   d0,d2
                bge.s   locret_80C0C
                add.w   d4,$42(a0)
                rts
; ---------------------------------------------------------------------------

loc_80C00:
                subi.w  #$40,d0
                cmp.w   d0,d2
                blt.s   locret_80C0C
                sub.w   d4,$42(a0)

locret_80C0C:
                rts
; ---------------------------------------------------------------------------

loc_80C0E:
                move.b  #4,routine(a0)
                move.w  #-$80,y_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_80C34,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_80C2A:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_80C34:
                move.w  #$10,$2E(a0)
                clr.w   y_vel(a0)
                move.l  #loc_80C48,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_80C48:
                move.b  #6,routine(a0)
                move.l  #loc_80C60,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_80C58:
                lea     byte_8133E(pc),a1
                jmp     Animate_RawNoSSTMultiDelay(pc)
; ---------------------------------------------------------------------------

loc_80C60:
                move.b  #8,routine(a0)
                move.w  #$2F,$2E(a0)
                bset    #1,$38(a0)
                move.b  $39(a0),d0
                lsl.w   #2,d0
                andi.w  #$C,d0
                move.w  d0,(Screen_shake_flag).w
                moveq   #signextendB(sfx_ThumpBoss),d0
                jsr     (Play_SFX).l

locret_80C88:
                rts
; ---------------------------------------------------------------------------

loc_80C8A:
                subq.w  #1,$2E(a0)
                bpl.s   locret_80CA4
                move.b  #$A,routine(a0)
                bclr    #1,$38(a0)
                move.l  #loc_80CAE,$34(a0)

locret_80CA4:
                rts
; ---------------------------------------------------------------------------

loc_80CA6:
                lea     byte_81349(pc),a1
                jmp     Animate_RawNoSSTMultiDelay(pc)
; ---------------------------------------------------------------------------

loc_80CAE:
                move.b  #$C,routine(a0)
                move.w  #$80,y_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_80CCA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_80CCA:
                move.b  #2,routine(a0)
                move.w  #$E3,y_pos(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_80CE2:
                lea     ObjDat3_81292(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_80CF8,(a0)
                move.b  #3,collision_property(a0)

loc_80CF8:
                movea.w parent3(a0),a1
                move.b  mapping_frame(a1),mapping_frame(a0)
                btst    #1,$38(a1)
                bne.s   loc_80D18
                jsr     Refresh_ChildPosition(pc)
                bsr.w   ContinueDEZArmSegmentFlashOrSharedDestruction
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_80D18:
                move.l  #loc_80D30,(a0)
                move.b  #$1A,collision_flags(a0)
                bset    #7,art_tile(a0)
                move.w  #$80,priority(a0)

loc_80D30:
                movea.w parent3(a0),a1
                move.b  mapping_frame(a1),mapping_frame(a0)
                btst    #1,$38(a1)
                beq.s   loc_80D50
                jsr     Refresh_ChildPosition(pc)
                bsr.w   RecognizeDEZArmSegmentHitAtImpactFrame
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_80D50:
                move.l  #loc_80CF8,(a0)
                bclr    #7,art_tile(a0)
                move.w  #$280,priority(a0)
                bra.s   loc_80CF8
; ---------------------------------------------------------------------------

loc_80D64:
                jsr     Refresh_ChildPosition(pc)
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_80D72:
                lea     ObjDat3_81286(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_80D9E,(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                subi.w  #$10,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),d0
                subi.w  #$3C,d0
                move.w  d0,y_pos(a0)

loc_80D9E:
                btst    #0,(_unkFAB8).w
                beq.s   loc_80DB8
                move.l  #loc_80DBE,(a0)
                move.w  #$1F,$2E(a0)
                move.w  #-$80,x_vel(a0)

loc_80DB8:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_80DBE:
                subq.w  #1,$2E(a0)
                bmi.s   loc_80DD0
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_80DD0:
                bset    #1,(_unkFAB8).w
                st      (Events_fg_5).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_80DE0:
                lea     ObjDat3_812E0(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_80E02,(a0)
                move.w  #$70,x_pos(a0)
                move.w  #$C0,y_pos(a0)
                bset    #0,render_flags(a0)

loc_80E02:
                lea     byte_81354(pc),a1
                jsr     Animate_RawNoSST(pc)
                move.w  x_pos(a0),d0
                addq.w  #6,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$3D0,d0
                bhs.s   loc_80E20
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_80E20:
                bset    #0,(_unkFAB8).w
                jmp     (Delete_Current_Sprite).l
