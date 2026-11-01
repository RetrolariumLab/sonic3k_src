; Owner: objects/bonus/gumball/sk
; Responsibility: Gumball machine item motion, collision, spawning and state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

GumballSKLaunchFromTriangleAndConsumeBumperCell:
                move.w  #-$300,d0
                move.w  #-$600,y_vel(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,render_flags(a0)
                bne.s   loc_60FB4
                bclr    #Status_Facing,status(a1)
                neg.w   d0

loc_60FB4:
                move.w  d0,x_vel(a1)
                move.w  d0,ground_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #$10,anim(a1)
                clr.b   jumping(a1)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     ((RAM_start+$2000)&$FFFFFF).l,a1
                clr.b   (a1,d0.w)
                move.w  #$F,((RAM_start+$2020)&$FFFFFF).l
                movea.w (_unkFAA4).w,a1
                bset    #0,$38(a1)
                moveq   #signextendB(sfx_Spring),d0
                jsr     (Play_SFX).l
                rts
; End of function GumballSKLaunchFromTriangleAndConsumeBumperCell

; ---------------------------------------------------------------------------

loc_60FFE:
                lea     ObjDat3_6138C(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_61012,(a0)
                bsr.w   GumballSKSelectAttachedDecorationFrameAndOptionalMaskChild

loc_61012:
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6101E:
                lea     ObjDat3_613D4(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_61032,(a0)
                bsr.w   GumballSKOffsetDebrisAndSeedSubtypeDelay

loc_61032:
                subq.b  #1,$2E(a0)
                bpl.s   loc_6103E
                move.l  #MoveChkDel,(a0)

loc_6103E:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_61044:
                addi.w  #$2A0,y_pos(a0)
                move.l  #loc_61050,(a0)

loc_61050:
                subq.w  #1,((RAM_start+$2020)&$FFFFFF).l
                lea     word_610AE(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                bne.s   loc_61076
                swap    d0
                tst.w   d0
                beq.w   locret_60EB8
                lea     (Player_2).w,a1
                jmp     (Delete_Referenced_Sprite).l
; ---------------------------------------------------------------------------

loc_61076:
                move.w  (Saved_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved_apparent_zone_and_act).w,(Apparent_zone_and_act).w
                move.b  (Saved_last_star_post_hit).w,(Last_star_post_hit).w
                move.b  #0,(Special_bonus_entry_flag).w
                move.b  #1,(Restart_level_flag).w
                move.w  (Ring_count).w,(Saved_ring_count).w
                move.b  (Extra_life_flags).w,(Saved_extra_life_flags).w
                move.b  (Player_1+status_secondary).w,d0
                andi.b  #$71,d0
                move.b  d0,(Saved_status_secondary).w
                rts
; ---------------------------------------------------------------------------
word_610AE:
                dc.w    -$100,  $200,  -$10,   $40
; ---------------------------------------------------------------------------

loc_610B6:
                lea     ObjDat3_613EC(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_610C6,(a0)

loc_610C6:
                st      (Spritemask_flag).w
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

GumballSKCheckNearbyPlayersAndDispatchItemReward:
                lea     word_610F0(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.l   d0
                bne.s   loc_610F8
                rts
; ---------------------------------------------------------------------------
word_610F0:
                dc.w    -$18,   $30,  -$18,   $30
; ---------------------------------------------------------------------------

loc_610F8:
                moveq   #0,d1
                moveq   #1,d2
                move.b  subtype(a0),d1

loc_61100:
                add.w   d1,d1
                move.w  off_6110E(pc,d1.w),d1
                jsr     off_6110E(pc,d1.w)
                tst.w   d2

locret_6110C:
                rts
; End of function GumballSKCheckNearbyPlayersAndDispatchItemReward

; ---------------------------------------------------------------------------
off_6110E:
                dc.w    loc_61120-off_6110E
                dc.w    loc_61130-off_6110E
                dc.w    loc_6114E-off_6110E
                dc.w    locret_6114C-off_6110E
                dc.w    loc_6115C-off_6110E
                dc.w    loc_611D6-off_6110E
                dc.w    loc_61200-off_6110E
                dc.w    loc_6122A-off_6110E
                dc.w    loc_61264-off_6110E
; ---------------------------------------------------------------------------

loc_61120:
                addq.b  #1,(Life_count).w
                addq.b  #1,(Update_HUD_life_count).w
                moveq   #signextendB(mus_ExtraLife),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

loc_61130:
                tst.b   ((RAM_start+$2022)&$FFFFFF).l
                bne.s   locret_6110C
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_6110C
                move.l  #loc_60D58,(a1)
                st      ((RAM_start+$2022)&$FFFFFF).l

locret_6114C:
                rts
; ---------------------------------------------------------------------------

loc_6114E:
                addi.w  #20,(Saved_ring_count).w
                moveq   #10,d0
                jmp     (AddRings).l
; ---------------------------------------------------------------------------

loc_6115C:
                move.l  d0,-(sp)
                tst.w   d0
                beq.s   loc_61164
                bsr.s   GumballSKRepelPlayerFromRoundItemWithHighCounterByteJitter

loc_61164:
                move.l  (sp)+,d0
                swap    d0
                tst.w   d0
                beq.s   loc_6116E
                bsr.s   GumballSKRepelPlayerFromRoundItemWithHighCounterByteJitter

loc_6116E:
                clr.b   collision_property(a0)
                moveq   #0,d2
                rts

; =============== S U B R O U T I N E =======================================

GumballSKRepelPlayerFromRoundItemWithHighCounterByteJitter:
                movea.w d0,a1
                move.w  x_pos(a0),d1
                move.w  y_pos(a0),d2
                sub.w   x_pos(a1),d1
                sub.w   y_pos(a1),d2
                jsr     (GetArcTan).l
                move.b  (Level_frame_counter).w,d1
                andi.w  #3,d1
                add.w   d1,d0
                jsr     (GetSineCosine).l
                muls.w  #-$700,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a1)
                muls.w  #-$700,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                clr.b   jumping(a1)
                move.b  #1,anim(a0)
                moveq   #signextendB(sfx_SmallBumpers),d0
                jmp     (Play_SFX).l
; End of function GumballSKRepelPlayerFromRoundItemWithHighCounterByteJitter

; ---------------------------------------------------------------------------

loc_611D6:
                lea     (Player_1).w,a1
                move.l  #Obj_FireShield,(Shield).w
                move.w  a1,(Shield+parent).w
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                moveq   #Status_FireShield,d0
                bsr.w   GumballSKSetLiveShieldTypeAndReplaceSavedTypeBits
                moveq   #signextendB(sfx_FireShield),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

loc_61200:
                lea     (Player_1).w,a1
                move.l  #Obj_BubbleShield,(Shield).w
                move.w  a1,(Shield+parent).w
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                moveq   #Status_BublShield,d0
                bsr.w   GumballSKSetLiveShieldTypeAndReplaceSavedTypeBits
                moveq   #signextendB(sfx_BubbleShield),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

loc_6122A:
                lea     (Player_1).w,a1
                move.l  #Obj_LightningShield,(Shield).w
                move.w  a1,(Shield+parent).w
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                moveq   #Status_LtngShield,d0
                bsr.w   GumballSKSetLiveShieldTypeAndReplaceSavedTypeBits
                moveq   #signextendB(sfx_LightningShield),d0
                jmp     (Play_Music).l

; =============== S U B R O U T I N E =======================================

GumballSKSetLiveShieldTypeAndReplaceSavedTypeBits:
                bset    d0,status_secondary(a1)
                lea     (Saved_status_secondary).w,a2
                andi.b  #$8F,(a2)
                bset    d0,(a2)
                rts
; End of function GumballSKSetLiveShieldTypeAndReplaceSavedTypeBits

; ---------------------------------------------------------------------------

loc_61264:
                bset    #7,(Saved_status_secondary).w
                rts

; =============== S U B R O U T I N E =======================================

GumballSKRecomputeDropTargetFromLeadingEmptyBumperPairsAndDescend:
                bclr    #0,$38(a0)
                beq.s   loc_61294
                lea     ((RAM_start+$2000)&$FFFFFF).l,a1
                moveq   #0,d0
                moveq   #$E-1,d1

loc_6127E:
                tst.w   (a1)+
                bne.s   loc_6128A
                addi.w  #$20,d0
                dbf     d1,loc_6127E

loc_6128A:
                move.w  $3A(a0),d1
                add.w   d0,d1
                move.w  d1,$3C(a0)

loc_61294:
                move.w  $3C(a0),d1
                move.w  y_pos(a0),d2
                cmp.w   d1,d2
                bhs.s   locret_612A6
                addq.w  #4,d2
                move.w  d2,y_pos(a0)

locret_612A6:
                rts
; End of function GumballSKRecomputeDropTargetFromLeadingEmptyBumperPairsAndDescend

; =============== S U B R O U T I N E =======================================

GumballSKSelectWeightedDropAndLimitLifeRollPerMachine:
                jsr     (Random_Number).l
                andi.w  #$F,d0
                bne.s   loc_612C2
                movea.w parent3(a0),a1
                bset    #7,$38(a1)
                beq.s   loc_612C2
                moveq   #3,d0

loc_612C2:
                move.b  byte_612E0(pc,d0.w),d0
                move.b  d0,subtype(a0)
                cmpi.b  #4,d0
                bne.s   loc_612D6
                move.b  #$D7,collision_flags(a0)

loc_612D6:
                lsl.w   #2,d0
                move.l  off_612F0(pc,d0.w),$30(a0)
                rts
; End of function GumballSKSelectWeightedDropAndLimitLifeRollPerMachine

; ---------------------------------------------------------------------------
byte_612E0:
                dc.b    0
                dc.b    3
                dc.b    1
                dc.b    4
                dc.b    2
                dc.b    4
                dc.b    5
                dc.b    4
                dc.b    6
                dc.b    3
                dc.b    7
                dc.b    4
                dc.b    5
                dc.b    6
                dc.b    7
                dc.b    2
                even
off_612F0:
                dc.l    byte_61466
                dc.l    byte_6146A
                dc.l    byte_6146E
                dc.l    byte_61472
                dc.l    byte_61476
                dc.l    byte_6147A
                dc.l    byte_6147E
                dc.l    byte_61482
                dc.l    byte_61486

; =============== S U B R O U T I N E =======================================

GumballSKCallPlatformSolidRoutineWithFixedDimensions:
                moveq   #$4B,d1
                moveq   #$10,d2
                moveq   #$11,d3
                move.w  x_pos(a0),d4
                jmp     (a1)
; End of function GumballSKCallPlatformSolidRoutineWithFixedDimensions

; =============== S U B R O U T I N E =======================================

GumballSKOffsetDebrisAndSeedSubtypeDelay:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  d0,$2E(a0)
                lea     byte_61342(pc,d0.w),a1
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,x_pos(a0)
                moveq   #0,d0
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,y_pos(a0)
                rts
; End of function GumballSKOffsetDebrisAndSeedSubtypeDelay

; ---------------------------------------------------------------------------
byte_61342:
                dc.b    -8,   8
                dc.b    8,   8
                dc.b    -8,  -8
                dc.b    8,  -8
                dc.b    -$18,   8
                dc.b    $18,   8
                dc.b    -$18,  -8
                dc.b    $18,  -8
                dc.b    -$28,   8
                dc.b    $28,   8
                dc.b    -$28,  -8
                dc.b    $28,  -8
                dc.b    -$38,   8
                dc.b    $38,   8
                dc.b    -$38,  -8
                dc.b    $38,  -8
                even

; =============== S U B R O U T I N E =======================================

GumballSKSelectAttachedDecorationFrameAndOptionalMaskChild:
                moveq   #0,d0
                move.b  subtype(a0),d0
                subi.w  #6,d0
                lsr.w   #1,d0
                move.b  RawAni_61388(pc,d0.w),d0
                move.b  d0,mapping_frame(a0)
                cmpi.b  #$16,d0
                bne.w   locret_60EB8
                lea     ChildObjDat_6144A(pc),a2
                jmp     (CreateChild6_Simple).l
; End of function GumballSKSelectAttachedDecorationFrameAndOptionalMaskChild

; ---------------------------------------------------------------------------
RawAni_61388:
                dc.b    0,   1,   0, $16
