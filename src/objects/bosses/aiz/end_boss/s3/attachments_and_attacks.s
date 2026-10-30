; Owner: objects/bosses/aiz/end_boss/s3
; Responsibility: Angel Island end-boss attachment states, attack actors, projectiles and private movement records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_47486:
                jsr     (Refresh_ChildPositionAdjusted).l
                bsr.w   Child_SyncDraw
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_474B2(pc,d0.w),d1
                jsr     off_474B2(pc,d1.w)
                btst    #6,$38(a0)
                bne.w   locret_47246
                bsr.w   sub_47AFA
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_474B2:
                dc.w    loc_474BE-off_474B2
                dc.w    loc_474E6-off_474B2
                dc.w    loc_47518-off_474B2
                dc.w    loc_4752E-off_474B2
                dc.w    loc_47546-off_474B2
                dc.w    loc_47568-off_474B2
; ---------------------------------------------------------------------------

loc_474BE:
                lea     word_47B36(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                moveq   #0,d0
                tst.b   subtype(a0)
                beq.s   loc_474DC
                move.b  #$2A,mapping_frame(a0)
                move.w  #$280,priority(a0)

loc_474DC:
                lea     ChildObjDat_47B7C(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_474E6:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_474F4
                rts
; ---------------------------------------------------------------------------

loc_474F4:
                tst.b   subtype(a0)
                bne.s   loc_47510
                move.b  #4,routine(a0)
                move.w  #4,$2E(a0)
                move.l  #loc_4751E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_47510:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_47518:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4751E:
                move.b  #6,routine(a0)
                move.l  #loc_4753E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4752E:
                bclr    #6,$38(a0)
                lea     byte_47C14(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

loc_4753E:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_47546:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_47554
                rts
; ---------------------------------------------------------------------------

loc_47554:
                move.b  #$A,routine(a0)
                bset    #1,$38(a0)
                move.w  angle(a1),angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_47568:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_47576
                rts
; ---------------------------------------------------------------------------

loc_47576:
                move.b  #2,routine(a0)
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_47584:
                move.l  #Obj_FlickerMove,(a0)
                move.b  #1,mapping_frame(a0)
                clr.b   collision_flags(a0)
                moveq   #$C,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

loc_4759C:
                bsr.w   Child_SyncDraw
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_475C4(pc,d0.w),d1
                jsr     off_475C4(pc,d1.w)
                jsr     (Refresh_ChildPositionAdjusted).l
                btst    #6,$38(a0)
                bne.w   locret_47246
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
off_475C4:
                dc.w    loc_475CC-off_475C4
                dc.w    loc_475D8-off_475C4
                dc.w    loc_47618-off_475C4
                dc.w    loc_47664-off_475C4
; ---------------------------------------------------------------------------

loc_475CC:
                lea     word_47B3C(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                rts
; ---------------------------------------------------------------------------

loc_475D8:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_475E6
                rts
; ---------------------------------------------------------------------------

loc_475E6:
                move.b  #4,routine(a0)
                move.b  #1,anim_frame(a0)
                bset    #1,$38(a0)
                move.l  #loc_47636,$34(a0)
                move.w  angle(a1),angle(a0)
                clr.w   $2E(a0)
                tst.b   subtype(a1)
                beq.s   locret_47616
                move.w  #$4F,$2E(a0)

locret_47616:
                rts
; ---------------------------------------------------------------------------

loc_47618:
                subq.w  #1,$2E(a0)
                bpl.s   locret_47634
                move.w  #3,$2E(a0)
                bsr.w   sub_47916
                subq.b  #1,anim_frame(a0)
                bpl.s   locret_47634
                movea.l $34(a0),a1
                jsr     (a1)

locret_47634:
                rts
; ---------------------------------------------------------------------------

loc_47636:
                move.b  #6,routine(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                move.w  #$5F,$2E(a0)
                move.l  #loc_4766A,$34(a0)
                bra.w   loc_4799C
; ---------------------------------------------------------------------------

loc_47658:
                move.b  #2,routine(a0)
                clr.b   $39(a0)
                rts
; ---------------------------------------------------------------------------

loc_47664:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4766A:
                move.b  #4,routine(a0)
                move.b  #1,anim_frame(a0)
                bclr    #1,$38(a0)
                clr.w   $2E(a0)
                move.l  #loc_47658,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4768A:
                lea     word_47B42(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_476E4,(a0)
                bset    #4,shield_reaction(a0)
                move.l  #loc_47702,$34(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a2
                movea.w parent3(a2),a2
                move.w  a2,$44(a0)
                move.w  angle(a1),d0
                move.w  d0,angle(a0)
                move.l  off_476D4(pc,d0.w),$30(a0)
                cmpi.w  #8,d0
                bhs.s   locret_476D2
                bset    #0,render_flags(a0)

locret_476D2:
                rts
; ---------------------------------------------------------------------------
off_476D4:
                dc.l    byte_47C1F
                dc.l    byte_47C49
                dc.l    byte_47C49
                dc.l    byte_47C1F
; ---------------------------------------------------------------------------

loc_476E4:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   loc_4770C
                jsr     (Refresh_ChildPosition).l
                jsr     (Animate_Raw).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_47702:
                lea     ChildObjDat_47BAC(pc),a2
                jsr     (CreateChild1_Normal).l

loc_4770C:
                bset    #6,$38(a0)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_47718:
                lea     word_47B48(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bset    #4,shield_reaction(a0)
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                move.b  #$C,y_radius(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_4774E,(a0)
                move.l  #loc_4778C,$34(a0)
                bra.w   loc_479B8
; ---------------------------------------------------------------------------

loc_4774E:
                tst.w   x_vel(a0)
                beq.s   loc_4775A
                jsr     (ObjHitFloor_DoRoutine).l

loc_4775A:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_47786
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   loc_47780
                lea     ChildObjDat_47BB4(pc),a2
                jsr     (CreateChild1_Normal).l

loc_47780:
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_47786:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4778C:
                move.l  #loc_4775A,(a0)
                move.l  #byte_47C7F,$30(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_477A0:
                lea     word_47B4E(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_477D0,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.l  #byte_47C85,$30(a0)
                tst.w   x_vel(a0)
                bne.s   locret_477CE
                move.l  #byte_47C8E,$30(a0)

locret_477CE:
                rts
; ---------------------------------------------------------------------------

loc_477D0:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_477DC:
                lea     ObjDat_AIZEndBoss2(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_477F6,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_477F6:
                lea     byte_47C97(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_47806:
                lea     word_47B54(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_47830,(a0)
                tst.b   subtype(a0)
                bne.s   loc_47826
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_47826:
                move.l  #loc_4784A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_47830:
                lea     byte_47CA0(pc),a1
                jsr     (Animate_RawNoSSTMultiDelayFlipX).l
                cmpi.b  #$2B,mapping_frame(a0)
                beq.w   locret_47246
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4784A:
                move.l  #loc_47860,(a0)
                move.w  #$800,y_vel(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_47860:
                jsr     (MoveSprite2).l
                lea     byte_47CBB(pc),a1
                jsr     (Animate_RawNoSSTMultiDelayFlipX).l
                cmpi.b  #$2B,mapping_frame(a0)
                beq.w   locret_47246
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_47880:
                lea     word_47B68(pc),a1
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

loc_478AC:
                jsr     (Random_Number).l
                andi.w  #$C,d0
                move.w  angle(a0),d1
                move.w  d0,angle(a0)
                cmp.w   d1,d0
                beq.s   loc_478AC
                lea     word_47906(pc,d0.w),a1
                moveq   #0,d2
                move.w  (a1)+,d2
                swap    d2
                sub.l   x_pos(a0),d2
                add.l   d2,d2
                swap    d2
                move.w  d2,x_vel(a0)
                moveq   #0,d3
                move.w  (a1)+,d3
                swap    d3
                sub.l   y_pos(a0),d3
                add.l   d3,d3
                swap    d3
                move.w  d3,y_vel(a0)
                move.w  #$7F,$2E(a0)
                tst.w   d2
                beq.s   locret_47904
                bclr    #0,render_flags(a0)
                tst.w   d2
                bmi.s   locret_47904
                bset    #0,render_flags(a0)

locret_47904:
                rts
; ---------------------------------------------------------------------------
word_47906:
                dc.w    $48E0+$058, $15A+$76
                dc.w    $48E0+$0A0, $15A+$46
                dc.w    $48E0+$160, $15A+$46
                dc.w    $48E0+$1A8, $15A+$76
