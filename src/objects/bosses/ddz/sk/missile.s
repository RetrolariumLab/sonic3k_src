; Owner: objects/bosses/ddz/sk
; Responsibility: Doomsday missile initialization, tracking, player interaction and destruction
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DDZMissile:
                lea     ObjDat_DDZMissile(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     ChildObjDat_83250(pc),a2
                jsr     CreateChild6_Simple(pc)
                tst.b   subtype(a0)
                bne.s   loc_82014
                move.l  #loc_82038,(a0)
                move.w  #-$3FFA,$3C(a0)
                bra.w   QuantizeDDZMissileHeadingToEightDisplaySectors
; ---------------------------------------------------------------------------

loc_82014:
                move.l  #loc_82060,(a0)
                moveq   #0,d0
                move.b  $39(a0),d0
                add.w   d0,d0
                move.w  word_82032(pc,d0.w),d1
                add.w   d1,y_pos(a0)
                lsl.w   #3,d0
                move.w  d0,$2E(a0)
                bra.s   loc_81FDA
; ---------------------------------------------------------------------------
word_82032:
                dc.w    0,    -8,     8
; ---------------------------------------------------------------------------

loc_82038:
                tst.b   render_flags(a0)
                bpl.s   loc_8204C
                move.l  #loc_8204C,(a0)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l

loc_8204C:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                subq.w  #2,x_pos(a0)
                bsr.w   ResolveDDZMissileBossOrPlayerContactAndDisposal
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_82060:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   loc_8209A
                move.l  #loc_8209E,(a0)
                move.b  #$40,$3C(a0)
                bsr.w   QuantizeDDZMissileHeadingToEightDisplaySectors
                move.w  #$200,x_vel(a0)
                move.w  #$B,$2E(a0)
                move.l  #loc_820B6,$34(a0)

loc_8209A:
                bra.w   loc_81FDA
; ---------------------------------------------------------------------------

loc_8209E:
                movea.w parent3(a0),a1
                move.w  y_pos(a1),y_pos(a0)
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_820B6:
                move.l  #loc_820D0,(a0)
                clr.b   routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_820F8,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_820D0:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_820E8(pc,d0.w),d1
                jsr     off_820E8(pc,d1.w)
                bsr.w   ResolveDDZMissileBossOrPlayerContactAndDisposal
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_820E8:
                dc.w    loc_820EE-off_820E8
                dc.w    loc_82122-off_820E8
                dc.w    loc_8213E-off_820E8
; ---------------------------------------------------------------------------

loc_820EE:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_820F8:
                move.b  #2,routine(a0)
                move.w  #$1F,$2E(a0)
                bset    #7,art_tile(a0)
                move.w  #$180,priority(a0)
                moveq   #0,d0
                move.b  $39(a0),d0
                move.b  byte_8211E(pc,d0.w),$40(a0)
                rts
; ---------------------------------------------------------------------------
byte_8211E:
                dc.b    4,   2,  -2
                even
; ---------------------------------------------------------------------------

loc_82122:
                subq.w  #1,$2E(a0)
                bpl.s   loc_8212E
                move.b  #4,routine(a0)

loc_8212E:
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                bsr.w   QuantizeDDZMissileHeadingToEightDisplaySectors
                bra.w   loc_82ABC
; ---------------------------------------------------------------------------

loc_8213E:
                bsr.w   TurnDDZHomingMissileTwoAngleUnitsTowardPlayer
                bsr.w   QuantizeDDZMissileHeadingToEightDisplaySectors
                bra.w   loc_82ABC
; ---------------------------------------------------------------------------

loc_8214A:
                lea     word_831FC(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_8215C,(a0)
                bsr.w   SetDDZMissileFlameFrameAndRearOffsetFromSector

loc_8215C:
                bsr.w   SetDDZMissileFlameFrameAndRearOffsetFromSector

loc_82160:
                jsr     Child_GetPriority(pc)
                move.b  (V_int_run_count+3).w,d3
                andi.b  #7,d3
                bne.s   loc_82176
                lea     ChildObjDat_83256(pc),a2
                jsr     CreateChild6_Simple(pc)

loc_82176:
                btst    #1,d3
                bne.s   loc_82184
                jsr     Refresh_ChildPosition(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_82184:
                bclr    #7,render_flags(a0)
                jmp     Child_CheckParent(pc)
; ---------------------------------------------------------------------------

loc_8218E:
                lea     word_83202(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_821C2,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                move.b  $3C(a1),d0
                jsr     (GetSineCosine).l
                neg.w   d0
                neg.w   d1
                move.w  d0,x_vel(a0)
                move.w  d1,y_vel(a0)

loc_821C2:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                lea     byte_832B4(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jsr     (MoveSprite2).l
                jmp     (Sprite_OnScreen_Test).l
; End of function loc_820D0
