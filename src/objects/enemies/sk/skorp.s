; Owner: objects/enemies/sk
; Responsibility: Skorp enemy attack states, linked children, helper callbacks and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Skorp:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Skorp_Index(pc,d0.w),d1
                jsr     Skorp_Index(pc,d1.w)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
Skorp_Index:
                dc.w    loc_8E670-Skorp_Index
                dc.w    loc_8E6B8-Skorp_Index
                dc.w    loc_8E732-Skorp_Index
; ---------------------------------------------------------------------------

loc_8E670:
                lea     ObjDat_Skorp(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #$B,y_radius(a0)
                move.l  #loc_8E706,$34(a0)
                move.w  #-$80,d0
                btst    #0,render_flags(a0)
                beq.s   loc_8E696
                neg.w   d0

loc_8E696:
                move.w  d0,x_vel(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                subq.w  #1,d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                addq.w  #1,d0
                move.w  d0,$3A(a0)
                lea     ChildObjDat_8EA5A(pc),a2
                jmp     (CreateChild4_LinkListRepeated).l
; ---------------------------------------------------------------------------

loc_8E6B8:
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                btst    #0,render_flags(a0)
                sne     d4
                tst.w   d0
                beq.s   loc_8E6D0
                not.b   d4

loc_8E6D0:
                tst.b   d4
                bne.s   loc_8E6E6
                cmpi.w  #$20,d2
                blo.s   loc_8E6E6
                cmpi.w  #$80,d2
                bhs.s   loc_8E6E6
                cmpi.w  #$28,d3
                blo.s   loc_8E718

loc_8E6E6:
                lea     byte_8EA60(pc),a1
                jsr     (Animate_RawNoSST).l
                jsr     (MoveSprite2).l
                jsr     (ObjHitFloor2_DoRoutine).l
                bne.w   locret_8E716
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_8E706:
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  $3A(a0),$2E(a0)

locret_8E716:
                rts
; ---------------------------------------------------------------------------

loc_8E718:
                move.b  #4,routine(a0)
                bset    #1,$38(a0)
                move.w  x_pos(a1),$3E(a0)
                move.w  y_pos(a1),$40(a0)
                rts
; ---------------------------------------------------------------------------

loc_8E732:
                btst    #1,$38(a0)
                beq.s   loc_8E73C
                rts
; ---------------------------------------------------------------------------

loc_8E73C:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_8E744:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_8E778(pc,d0.w),d1
                jsr     off_8E778(pc,d1.w)
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   loc_8E772
                cmpi.b  #$A,subtype(a0)
                bne.s   loc_8E76C
                jsr     (Add_SpriteToCollisionResponseList).l

loc_8E76C:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8E772:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
off_8E778:
                dc.w    loc_8E78C-off_8E778
                dc.w    loc_8E7D4-off_8E778
                dc.w    loc_8E828-off_8E778
                dc.w    loc_8E868-off_8E778
                dc.w    loc_8E88C-off_8E778
                dc.w    loc_8E8C4-off_8E778
                dc.w    loc_8E8BE-off_8E778
                dc.w    loc_8E8BE-off_8E778
                dc.w    loc_8E918-off_8E778
                dc.w    loc_8E958-off_8E778
; ---------------------------------------------------------------------------

loc_8E78C:
                lea     word_8EA54(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                movea.w parent3(a0),a1
                move.b  subtype(a0),d0
                bne.s   loc_8E7B2
                move.b  #8,child_dx(a0)
                move.b  #-$10,child_dy(a0)
                move.w  parent3(a0),$44(a1)

loc_8E7B2:
                move.w  $44(a1),$44(a0)
                cmpi.b  #$A,d0
                bne.s   loc_8E7D0
                move.b  #4,mapping_frame(a0)
                move.w  #$100,priority(a0)
                move.b  #$87,collision_flags(a0)

loc_8E7D0:
                bsr.w   InitializeSkorpTailLinkRestAngle

loc_8E7D4:
                jsr     (Change_FlipXUseParent).l
                tst.b   subtype(a0)
                beq.s   loc_8E7F8
                movea.w $44(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_8E80E
                bsr.w   OscillateSkorpTailLinkRestAngle
                moveq   #5,d2
                jmp     (MoveSprite_CircularSimpleCheckFlip).l
; ---------------------------------------------------------------------------

loc_8E7F8:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                sub.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_8E80E:
                move.b  #4,routine(a0)
                move.l  #loc_8E87C,$34(a0)
                movea.w $44(a0),a1
                andi.b  #$F3,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_8E828:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  byte_8E862(pc,d0.w),d1
                move.b  $3C(a0),d2
                subq.b  #8,d2
                cmp.b   d1,d2
                bhi.s   loc_8E856
                move.b  #6,routine(a0)
                move.b  d1,d2
                cmpi.b  #5,d0
                bne.s   loc_8E856
                movea.w $44(a0),a1
                bset    #3,$38(a1)

loc_8E856:
                move.b  d2,$3C(a0)
                moveq   #5,d2
                jmp     (MoveSprite_CircularSimpleCheckFlip).l
; ---------------------------------------------------------------------------
byte_8E862:
                dc.b    0, $68, $58, $48, $38, $38
                even
; ---------------------------------------------------------------------------

loc_8E868:
                movea.w $44(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_8E876
                rts
; ---------------------------------------------------------------------------

loc_8E876:
                movea.l $34(a0),a1
                jmp     (a1)
; ---------------------------------------------------------------------------

loc_8E87C:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_8E884:
                move.b  #$10,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_8E88C:
                move.b  $3C(a0),d0
                addi.b  #$10,d0
                bpl.s   loc_8E8B2
                move.b  #$C,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_8E8CA,$34(a0)
                bsr.w   SkorpTailLink_AimLungeAtSnapshot
                move.b  #$80,d0

loc_8E8B2:
                move.b  d0,$3C(a0)
                moveq   #5,d2
                jmp     (MoveSprite_CircularSimpleCheckFlip).l
; ---------------------------------------------------------------------------

loc_8E8BE:
                jsr     (MoveSprite2).l

loc_8E8C4:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_8E8CA:
                move.b  #$A,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_8E8E0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8E8E0:
                move.b  #$E,routine(a0)
                neg.w   x_vel(a0)
                neg.w   y_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_8E8FE,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8E8FE:
                move.b  #4,routine(a0)
                move.l  #loc_8E884,$34(a0)
                movea.w $44(a0),a1
                bclr    #3,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_8E918:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  byte_8E952(pc,d0.w),d1
                move.b  $3C(a0),d2
                addq.b  #8,d2
                cmp.b   d1,d2
                blo.s   loc_8E946
                move.b  #$12,routine(a0)
                move.b  d1,d2
                cmpi.b  #5,d0
                bne.s   loc_8E946
                movea.w $44(a0),a1
                bset    #2,$38(a1)

loc_8E946:
                move.b  d2,$3C(a0)
                moveq   #5,d2
                jmp     (MoveSprite_CircularSimpleCheckFlip).l
; ---------------------------------------------------------------------------
byte_8E952:
                dc.b    0, $90, $A0, $B0, $B8, $C0
                even
; ---------------------------------------------------------------------------

loc_8E958:
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_8E966
                rts
; ---------------------------------------------------------------------------

loc_8E966:
                move.b  #2,routine(a0)
                movea.w $44(a0),a1
                bclr    #1,$38(a1)
                clr.b   $3B(a0)
                bclr    #0,$38(a0)
                rts

; =============== S U B R O U T I N E =======================================

InitializeSkorpTailLinkRestAngle:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  byte_8E992(pc,d0.w),$3C(a0)
                rts
; End of function InitializeSkorpTailLinkRestAngle

; ---------------------------------------------------------------------------
byte_8E992:
                dc.b    0, $90, $A0, $B0, $B8, $C0
                even
; ---------------------------------------------------------------------------
; unused
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  d0,$2E(a0)
                rts

; =============== S U B R O U T I N E =======================================

; Use the root's saved player position and scale the launch by link index
SkorpTailLink_AimLungeAtSnapshot:
                movea.w $44(a0),a1
                move.w  $3E(a1),d0
                sub.w   x_pos(a0),d0
                smi     d2
                bpl.s   loc_8E9B6
                neg.w   d0

loc_8E9B6:
                move.w  $40(a1),d1
                sub.w   y_pos(a0),d1
                smi     d3
                bpl.s   loc_8E9C4
                neg.w   d1

loc_8E9C4:
                moveq   #0,d4
                move.b  subtype(a0),d4
                move.w  off_8E9D2(pc,d4.w),d4
                jmp     off_8E9D2(pc,d4.w)
; End of function SkorpTailLink_AimLungeAtSnapshot

; ---------------------------------------------------------------------------
off_8E9D2:
                dc.w    loc_8E9DE-off_8E9D2
                dc.w    loc_8E9DE-off_8E9D2
                dc.w    loc_8E9E6-off_8E9D2
                dc.w    loc_8E9EE-off_8E9D2
                dc.w    loc_8E9F6-off_8E9D2
                dc.w    loc_8EA02-off_8E9D2
; ---------------------------------------------------------------------------

loc_8E9DE:
                move.w  #$3333,d4
                bra.w   loc_8E9FA
; ---------------------------------------------------------------------------

loc_8E9E6:
                move.w  #$6666,d4
                bra.w   loc_8E9FA
; ---------------------------------------------------------------------------

loc_8E9EE:
                move.w  #$9999,d4
                bra.w   loc_8E9FA
; ---------------------------------------------------------------------------

loc_8E9F6:
                move.w  #$CCCC,d4

loc_8E9FA:
                mulu.w  d4,d0
                swap    d0
                mulu.w  d4,d1
                swap    d1

loc_8EA02:
                asl.w   #4,d0
                tst.b   d2
                beq.s   loc_8EA0A
                neg.w   d0

loc_8EA0A:
                move.w  d0,x_vel(a0)
                asl.w   #4,d1
                tst.b   d3
                beq.s   loc_8EA16
                neg.w   d1

loc_8EA16:
                move.w  d1,y_vel(a0)
                rts

; =============== S U B R O U T I N E =======================================

OscillateSkorpTailLinkRestAngle:
                subq.b  #1,$3B(a0)
                bpl.s   loc_8EA2E
                move.b  #$10,$3B(a0)
                bchg    #0,$38(a0)

loc_8EA2E:
                btst    #0,$3B(a0)
                bne.s   locret_8EA46
                moveq   #1,d0
                btst    #0,$38(a0)
                bne.s   loc_8EA42
                neg.w   d0

loc_8EA42:
                add.b   d0,$3C(a0)

locret_8EA46:
                rts
; End of function OscillateSkorpTailLinkRestAngle

; ---------------------------------------------------------------------------
ObjDat_Skorp:
                dc.l    Map_Skorp
                dc.w    make_art_tile(ArtTile_Skorp,1,0)
                dc.w    $180
                dc.b    $10, $14,   0,   6
word_8EA54:
                dc.w    $180
                dc.b    $10, $14,   3,   0
ChildObjDat_8EA5A:
                dc.w    6-1
                dc.l    loc_8E744
byte_8EA60:
                dc.b    9,   1,   0,   1,   2, $FC
                even
