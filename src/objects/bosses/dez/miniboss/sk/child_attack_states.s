; Owner: objects/bosses/dez/miniboss/sk
; Responsibility: Death Egg miniboss child attack, timed motion, collision and defeat callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

DEZMiniPlatform_RestoreIdleBySide:
                move.l  #loc_7E566,(a0)
                tst.b   subtype(a0)
                beq.s   locret_7E6E6
                move.l  #loc_7E54C,(a0)

locret_7E6E6:
                rts
; ---------------------------------------------------------------------------

loc_7E6E8:
                bsr.w   DEZMiniPlatform_AccelAndStepAngle
                move.b  $3A(a0),d0
                addq.b  #1,d0
                cmpi.b  #$60,d0
                bhs.s   loc_7E700
                move.b  d0,$3A(a0)
                bra.w   loc_7EC52
; ---------------------------------------------------------------------------

loc_7E700:
                move.l  #loc_7E710,(a0)
                move.w  #$3F,$2E(a0)
                bra.w   loc_7EC52
; ---------------------------------------------------------------------------

loc_7E710:
                subq.w  #1,$2E(a0)
                bpl.s   loc_7E71C
                move.l  #loc_7E724,(a0)

loc_7E71C:
                bsr.w   DEZMiniPlatform_AccelAndStepAngle
                bra.w   loc_7EC52
; ---------------------------------------------------------------------------

loc_7E724:
                bsr.w   DEZMiniPlatform_AccelAndStepAngle
                move.b  $3A(a0),d0
                subq.b  #1,d0
                cmpi.b  #$40,d0
                bhi.s   loc_7E742
                bsr.s   DEZMiniPlatform_RestoreIdleBySide
                movea.w parent3(a0),a1
                bclr    #7,$38(a1)
                moveq   #$40,d0

loc_7E742:
                move.b  d0,$3A(a0)
                bra.w   loc_7EC52
; End of function DEZMiniPlatform_RestoreIdleBySide

; ---------------------------------------------------------------------------

loc_7E74A:
                lea     word_7EF76(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_7E758,(a0)

loc_7E758:
                lea     byte_7EFEC(pc),a1
                jsr     Animate_RawNoSST(pc)
                jsr     Refresh_ChildPosition(pc)
                jmp     Child_DrawTouch_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_7E768:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_7E77C(pc,d0.w),d1
                jsr     off_7E77C(pc,d1.w)
                moveq   #$14,d0
                jmp     Child_Draw_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------
off_7E77C:
                dc.w    loc_7E786-off_7E77C
                dc.w    loc_7E79C-off_7E77C
                dc.w    loc_7E7B4-off_7E77C
                dc.w    loc_7E7D6-off_7E77C
                dc.w    loc_7E800-off_7E77C
; ---------------------------------------------------------------------------

loc_7E786:
                lea     word_7EF52(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.b  #-1,collision_property(a0)
                movea.w parent3(a0),a1
                move.w  d0,$44(a1)

loc_7E79C:
                bsr.w   TrackDEZMinibossEyeTowardPlayerOne
                movea.w parent3(a0),a1
                cmpi.l  #loc_7DE6E,(a1)
                beq.s   loc_7E7AE
                rts
; ---------------------------------------------------------------------------

loc_7E7AE:
                move.b  #4,routine(a0)

loc_7E7B4:
                bsr.w   TrackDEZMinibossEyeTowardPlayerOne
                bsr.w   DEZMiniEye_TickHitFlash
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                bne.s   loc_7E7CE
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

loc_7E7CE:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_7E7D6:
                bsr.w   TrackDEZMinibossEyeTowardPlayerOne
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                beq.s   loc_7E7E8
                rts
; ---------------------------------------------------------------------------

loc_7E7E8:
                move.b  #8,routine(a0)
                move.b  #-1,collision_property(a0)
                move.b  #$17,collision_flags(a0)
                clr.b   anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_7E800:
                bsr.w   TrackDEZMinibossEyeTowardPlayerOne
                bsr.w   DEZMiniEye_TickHitFlash
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

loc_7E80E:
                lea     word_7EF58(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_7E820,(a0)
                bsr.w   SeedDEZMinibossEightOrbitHazardPhases

loc_7E820:
                bsr.w   DEZOrbitHazard_UpdateCollision
                addq.b  #4,$3C(a0)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_7E89C
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                move.w  $3A(a1),d1
                muls.w  d1,d0
                swap    d0
                move.w  d0,d1
                add.w   x_pos(a1),d0
                move.w  d0,x_pos(a0)
                addi.w  #$20,d1
                cmpi.w  #$40,d1
                scs     d5
                move.b  $3C(a1),d0
                ext.w   d0
                add.w   y_pos(a1),d0
                move.w  d0,y_pos(a0)
                move.b  $3C(a0),d0
                bpl.s   loc_7E870
                not.b   d0

loc_7E870:
                lsr.w   #2,d0
                andi.w  #$1C,d0
                lea     byte_7E8C2(pc,d0.w),a2
                move.b  (a2)+,mapping_frame(a0)
                bclr    #7,art_tile(a0)
                move.b  (a2)+,d1
                or.b    d1,art_tile(a0)
                move.w  (a2)+,priority(a0)
                tst.b   d5
                beq.s   loc_7E898
                tst.b   d1
                beq.w   locret_7DE44

loc_7E898:
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7E89C:
                bclr    #1,$38(a1)
                move.l  #loc_7E8E2,(a0)
                move.b  #$15,mapping_frame(a0)
                bset    #7,art_tile(a0)
                move.w  #$180,priority(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
byte_7E8C2:
                dc.b    $15, $80
                dc.w    $180
                dc.b    $15, $80
                dc.w    $180
                dc.b    $15, $80
                dc.w    $180
                dc.b    $16, $80
                dc.w    $180
                dc.b    $16,   0
                dc.w    $300
                dc.b    $17,   0
                dc.w    $300
                dc.b    $17,   0
                dc.w    $300
                dc.b    $17,   0
                dc.w    $300
; ---------------------------------------------------------------------------

loc_7E8E2:
                bsr.w   DEZOrbitHazard_UpdateCollision
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bpl.s   loc_7E8F6
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7E8F6:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   loc_7E908
                move.b  #6,subtype(a1)

loc_7E908:
                lea     ChildObjDat_7EF9C(pc),a2
                jsr     CreateChild6_Simple(pc)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_7E916:
                lea     word_7EF5E(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_7E972,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     byte_7E942(pc,d0.w),a1
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,d1
                or.b    d1,render_flags(a0)
                add.w   d0,d0
                move.l  word_7E952(pc,d0.w),x_vel(a0)   ; and y_vel
                rts
; ---------------------------------------------------------------------------
byte_7E942:
                dc.b    $19,   2
                dc.b    $18,   3
                dc.b    $1A,   1
                dc.b    $18,   1
                dc.b    $19,   0
                dc.b    $18,   0
                dc.b    $1A,   0
                dc.b    $18,   2
word_7E952:
                dc.w    0,  $200
                dc.w    $16A,  $16A
                dc.w    $200,     0
                dc.w    $16A, -$16A
                dc.w    0, -$200
                dc.w    -$16A, -$16A
                dc.w    -$200,     0
                dc.w    -$16A,  $16A
; ---------------------------------------------------------------------------

loc_7E972:
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouchXY).l
; ---------------------------------------------------------------------------

loc_7E97E:
                lea     word_7EF7C(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_7E98C,(a0)

loc_7E98C:
                jsr     Refresh_ChildPosition(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_7E9D0
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_7DE44
                move.b  child_dy(a0),d0
                addq.b  #1,d0
                move.b  d0,child_dy(a0)
                cmpi.b  #$24,d0
                blo.s   loc_7E9CA
                move.l  #loc_7E9D4,(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_7E9FC,$34(a0)

loc_7E9CA:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7E9D0:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7E9D4:
                jsr     Refresh_ChildPosition(pc)
                jsr     Obj_Wait(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_7E9F8
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_7DE44
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7E9F8:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7E9FC:
                move.l  #loc_7EA12,(a0)
                move.b  #$1B,mapping_frame(a0)
                clr.b   $39(a0)
                subq.b  #4,child_dy(a0)
                rts
; ---------------------------------------------------------------------------

loc_7EA12:
                move.b  mapping_frame(a0),d0
                addq.b  #1,d0
                move.b  d0,mapping_frame(a0)
                cmpi.b  #$22,d0
                blo.s   loc_7EA30
                move.l  #loc_7EA3C,(a0)
                lea     ChildObjDat_7EFCC(pc),a2
                jsr     CreateChild6_Simple(pc)

loc_7EA30:
                addq.b  #8,child_dy(a0)
                jsr     Refresh_ChildPosition(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7EA3C:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_7EA66
                jsr     Refresh_ChildPosition(pc)
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$1F,d0
                bne.s   loc_7EA5E
                moveq   #signextendB(sfx_BossPanic),d0
                jsr     (Play_SFX).l

loc_7EA5E:
                bsr.w   DEZMiniBeam_CheckBothPlayers
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7EA66:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_7EA6C:
                lea     word_7EF82(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_7EA9A,(a0)
                move.w  (_unkFAB0).w,d0
                addi.w  #$B0,d0
                move.w  d0,y_pos(a0)
                moveq   #-$10,d0
                tst.b   subtype(a0)
                beq.s   loc_7EA96
                neg.w   d0
                bset    #0,render_flags(a0)

loc_7EA96:
                move.w  d0,$3A(a0)

loc_7EA9A:
                lea     byte_7EFF4(pc),a1
                jsr     Animate_RawNoSST(pc)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                add.w   $3A(a0),d0
                move.w  d0,x_pos(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_7EAB6:
                lea     word_7EF64(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bsr.w   SeedDEZMinibossRandomFlickerDebris
                move.l  #loc_7EAC8,(a0)

loc_7EAC8:
                jmp     Obj_FlickerMove(pc)
; ---------------------------------------------------------------------------

loc_7EACC:
                lea     word_7EF6A(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_7EAFC,(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #-$200,d0
                tst.b   subtype(a0)
                beq.s   loc_7EAF2
                bset    #0,render_flags(a0)
                neg.w   d0

loc_7EAF2:
                move.w  d0,x_vel(a0)
                move.w  #$3F,$2E(a0)

loc_7EAFC:
                subq.w  #1,$2E(a0)
                bpl.s   loc_7EB08
                move.l  #Obj_FlickerMove,(a0)

loc_7EB08:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7EB0E:
                lea     word_7EF88(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$23,d0
                move.b  d0,mapping_frame(a0)
                moveq   #8,d0
                jmp     (Set_IndexedVelocity).l
