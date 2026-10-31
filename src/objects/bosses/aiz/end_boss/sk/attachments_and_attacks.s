; Owner: objects/bosses/aiz/end_boss/sk
; Responsibility: Angel Island end-boss attachment states, attack actors, projectiles and private movement records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_69622:
                jsr     (Refresh_ChildPositionAdjusted).l
                bsr.w   Child_SyncDraw
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_6964E(pc,d0.w),d1
                jsr     off_6964E(pc,d1.w)
                btst    #6,$38(a0)
                bne.w   locret_69366
                bsr.w   sub_69CA4
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_6964E:
                dc.w    loc_6965A-off_6964E
                dc.w    loc_69682-off_6964E
                dc.w    loc_696B4-off_6964E
                dc.w    loc_696CA-off_6964E
                dc.w    loc_696E2-off_6964E
                dc.w    loc_69704-off_6964E
; ---------------------------------------------------------------------------

loc_6965A:
                lea     word_69CE0(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                moveq   #0,d0
                tst.b   subtype(a0)
                beq.s   loc_69678
                move.b  #$2A,mapping_frame(a0)
                move.w  #$280,priority(a0)

loc_69678:
                lea     ChildObjDat_69D26(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_69682:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_69690
                rts
; ---------------------------------------------------------------------------

loc_69690:
                tst.b   subtype(a0)
                bne.s   loc_696AC
                move.b  #4,routine(a0)
                move.w  #4,$2E(a0)
                move.l  #loc_696BA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_696AC:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_696B4:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_696BA:
                move.b  #6,routine(a0)
                move.l  #loc_696DA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_696CA:
                bclr    #6,$38(a0)
                lea     byte_69DBE(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

loc_696DA:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_696E2:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_696F0
                rts
; ---------------------------------------------------------------------------

loc_696F0:
                move.b  #$A,routine(a0)
                bset    #1,$38(a0)
                move.w  angle(a1),angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_69704:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_69712
                rts
; ---------------------------------------------------------------------------

loc_69712:
                move.b  #2,routine(a0)
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_69720:
                move.l  #Obj_FlickerMove,(a0)
                move.b  #1,mapping_frame(a0)
                clr.b   collision_flags(a0)
                moveq   #$C,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

loc_69738:
                bsr.w   Child_SyncDraw
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_69760(pc,d0.w),d1
                jsr     off_69760(pc,d1.w)
                jsr     (Refresh_ChildPositionAdjusted).l
                btst    #6,$38(a0)
                bne.w   locret_69366
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
off_69760:
                dc.w    loc_69768-off_69760
                dc.w    loc_69774-off_69760
                dc.w    loc_697BA-off_69760
                dc.w    loc_6981E-off_69760
; ---------------------------------------------------------------------------

loc_69768:
                lea     word_69CE6(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                rts
; ---------------------------------------------------------------------------

loc_69774:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_69782
                rts
; ---------------------------------------------------------------------------

loc_69782:
                move.b  #4,routine(a0)
                move.b  #1,anim_frame(a0)
                bset    #1,$38(a0)
                move.b  #1,$3A(a0)
                move.l  #loc_697D8,$34(a0)
                move.w  angle(a1),angle(a0)
                clr.w   $2E(a0)
                tst.b   subtype(a1)
                beq.s   locret_697B8
                move.w  #$4F,$2E(a0)

locret_697B8:
                rts
; ---------------------------------------------------------------------------

loc_697BA:
                subq.w  #1,$2E(a0)
                bpl.s   locret_697D6
                move.w  #3,$2E(a0)
                bsr.w   sub_69AD8
                subq.b  #1,anim_frame(a0)
                bpl.s   locret_697D6
                movea.l $34(a0),a1
                jsr     (a1)

locret_697D6:
                rts
; ---------------------------------------------------------------------------

loc_697D8:
                move.b  #6,routine(a0)
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_69802

loc_697E6:
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                move.w  #$5F,$2E(a0)
                move.l  #loc_69824,$34(a0)
                bra.w   loc_69B5E
; ---------------------------------------------------------------------------

loc_69802:
                subq.b  #1,$3A(a0)
                bmi.s   loc_697E6
                move.w  #$2F,$2E(a0)
                bra.w   loc_69B5E
; ---------------------------------------------------------------------------

loc_69812:
                move.b  #2,routine(a0)
                clr.b   $39(a0)
                rts
; ---------------------------------------------------------------------------

loc_6981E:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_69824:
                move.b  #4,routine(a0)
                move.b  #1,anim_frame(a0)
                bclr    #1,$38(a0)
                clr.w   $2E(a0)
                move.l  #loc_69812,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_69844:
                lea     word_69CEC(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_6989E,(a0)
                bset    #4,shield_reaction(a0)
                move.l  #loc_698BC,$34(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a2
                movea.w parent3(a2),a2
                move.w  a2,$44(a0)
                move.w  angle(a1),d0
                move.w  d0,angle(a0)
                move.l  off_6988E(pc,d0.w),$30(a0)
                cmpi.w  #8,d0
                bhs.s   locret_6988C
                bset    #0,render_flags(a0)

locret_6988C:
                rts
; ---------------------------------------------------------------------------
off_6988E:
                dc.l    byte_69DC9
                dc.l    byte_69DF3
                dc.l    byte_69DF3
                dc.l    byte_69DC9
; ---------------------------------------------------------------------------

loc_6989E:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   loc_698C6
                jsr     (Refresh_ChildPosition).l
                jsr     (Animate_Raw).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_698BC:
                lea     ChildObjDat_69D56(pc),a2
                jsr     (CreateChild1_Normal).l

loc_698C6:
                bset    #6,$38(a0)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_698D2:
                lea     word_69CF2(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bset    #4,shield_reaction(a0)
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                move.b  #$C,y_radius(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_69908,(a0)
                move.l  #loc_69946,$34(a0)
                bra.w   loc_69B7A
; ---------------------------------------------------------------------------

loc_69908:
                tst.w   x_vel(a0)
                beq.s   loc_69914
                jsr     (ObjHitFloor_DoRoutine).l

loc_69914:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_69940
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   loc_6993A
                lea     ChildObjDat_69D5E(pc),a2
                jsr     (CreateChild1_Normal).l

loc_6993A:
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_69940:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_69946:
                move.l  #loc_69914,(a0)
                move.l  #byte_69E29,$30(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_6995A:
                lea     word_69CF8(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_6998A,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.l  #byte_69E2F,$30(a0)
                tst.w   x_vel(a0)
                bne.s   locret_69988
                move.l  #byte_69E38,$30(a0)

locret_69988:
                rts
; ---------------------------------------------------------------------------

loc_6998A:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_69996:
                lea     ObjDat_AIZEndBoss2(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_699B0,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_699B0:
                lea     byte_69E41(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_699C0:
                lea     word_69CFE(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_699EA,(a0)
                tst.b   subtype(a0)
                bne.s   loc_699E0
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_699E0:
                move.l  #loc_69A04,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_699EA:
                lea     byte_69E4A(pc),a1
                jsr     (Animate_RawNoSSTMultiDelayFlipX).l
                cmpi.b  #$2B,mapping_frame(a0)
                beq.w   locret_69366
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_69A04:
                move.l  #loc_69A1A,(a0)
                move.w  #$800,y_vel(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_69A1A:
                jsr     (MoveSprite2).l
                lea     byte_69E65(pc),a1
                jsr     (Animate_RawNoSSTMultiDelayFlipX).l
                cmpi.b  #$2B,mapping_frame(a0)
                beq.w   locret_69366
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_69A3A:
                lea     word_69D12(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                addi.b  #$32,d0
                move.b  d0,mapping_frame(a0)
                moveq   #0,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_69A66:
                jsr     (Random_Number).l
                andi.w  #$C,d0
                move.w  angle(a0),d1
                move.w  d0,angle(a0)
                cmp.w   d1,d0
                beq.s   loc_69A66
                lea     word_69AC8(pc,d0.w),a1
                moveq   #0,d2
                move.w  (_unkFA84).w,d2
                add.w   (a1)+,d2
                swap    d2
                sub.l   x_pos(a0),d2
                add.l   d2,d2
                swap    d2
                move.w  d2,x_vel(a0)
                moveq   #0,d3
                move.w  (_unkFA86).w,d3
                add.w   (a1)+,d3
                swap    d3
                sub.l   y_pos(a0),d3
                add.l   d3,d3
                swap    d3
                move.w  d3,y_vel(a0)
                move.w  #$7F,$2E(a0)
                tst.w   d2
                beq.s   locret_69AC6
                bclr    #0,render_flags(a0)
                tst.w   d2
                bmi.s   locret_69AC6
                bset    #0,render_flags(a0)

locret_69AC6:
                rts
; ---------------------------------------------------------------------------
word_69AC8:
                dc.w    $058,   $76
                dc.w    $0A0,   $46
                dc.w    $160,   $46
                dc.w    $1A8,   $76
