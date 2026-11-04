; Owner: objects/bonus/gumball/sk
; Responsibility: Gumball machine item motion, collision, spawning and state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Consume the bumper cell. Notify the machine to descend once both cells in the pair are empty
SKGumballTriangle_LaunchAndClear:
                move.w  #-$300,d0
                move.w  #-$600,y_vel(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,render_flags(a0)
                bne.s   SKGumball_LaunchAndConsumeTriangleCell
                bclr    #Status_Facing,status(a1)
                neg.w   d0

SKGumball_LaunchAndConsumeTriangleCell:
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
                movea.w (SceneControllerObjectAddress).w,a1
                bset    #0,$38(a1)
                moveq   #signextendB(sfx_Spring),d0
                jsr     (Play_SFX).l
                rts
; End of function SKGumballTriangle_LaunchAndClear

; ---------------------------------------------------------------------------

SKGumball_InitAttachedDecoration:
                lea     SKGumball_DecorationAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKGumball_FollowDecorationParentAndDraw,(a0)
                bsr.w   SKGumballDecor_SelectFrameAndMask

SKGumball_FollowDecorationParentAndDraw:
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKGumball_InitDebrisAndSetDelay:
                lea     SKGumball_PlatformDebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKGumball_TickDelayAndStartDebrisFall,(a0)
                bsr.w   GumballSKOffsetDebrisAndSeedSubtypeDelay

SKGumball_TickDelayAndStartDebrisFall:
                subq.b  #1,$2E(a0)
                bpl.s   SKGumball_DrawPlatformDebris
                move.l  #MoveChkDel,(a0)

SKGumball_DrawPlatformDebris:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKGumball_InitExitMonitor:
                addi.w  #$2A0,y_pos(a0)
                move.l  #SKGumball_TickCooldownAndCheckExit,(a0)

SKGumball_TickCooldownAndCheckExit:
                subq.w  #1,((RAM_start+$2020)&$FFFFFF).l
                lea     SKGumball_ExitMonitorRectangleWords(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                bne.s   SKGumball_RestoreLevelAndSaveP1
                swap    d0
                tst.w   d0
                beq.w   SKGumball_BodyCallbackReturn
                lea     (Player_2).w,a1
                jmp     (Delete_Referenced_Sprite).l
; ---------------------------------------------------------------------------

SKGumball_RestoreLevelAndSaveP1:
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
SKGumball_ExitMonitorRectangleWords:
                dc.w    -$100,  $200,  -$10,   $40
; ---------------------------------------------------------------------------

SKGumball_InitializeDecorationMaskActor:
                lea     SKGumball_SpriteMaskAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKGumball_SetMaskFlagAndFollowParent,(a0)

SKGumball_SetMaskFlagAndFollowParent:
                st      (Spritemask_flag).w
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Check both players, dispatch one subtype effect and return Z when the item should remain
SKGumball_TryRewardNearbyPlayer:
                lea     SKGumball_ItemCollectionRectangleWords(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.l   d0
                bne.s   SKGumball_InitRewardDispatch
                rts
; ---------------------------------------------------------------------------
SKGumball_ItemCollectionRectangleWords:
                dc.w    -$18,   $30,  -$18,   $30
; ---------------------------------------------------------------------------

SKGumball_InitRewardDispatch:
                moveq   #0,d1
                moveq   #1,d2
                move.b  subtype(a0),d1

SKGumball_DispatchRewardType:
                add.w   d1,d1
                move.w  SKGumball_RewardHandlerOffsets(pc,d1.w),d1
                jsr     SKGumball_RewardHandlerOffsets(pc,d1.w)
                tst.w   d2

SKGumball_RewardDispatchReturn:
                rts
; End of function SKGumball_TryRewardNearbyPlayer

; ---------------------------------------------------------------------------
SKGumball_RewardHandlerOffsets:
                dc.w    SKGumball_AwardLifeAndPlayMusic-SKGumball_RewardHandlerOffsets
                dc.w    SKGumball_TryRefillIfPlatformMissing-SKGumball_RewardHandlerOffsets
                dc.w    SKGumball_AddSavedAndLiveRings-SKGumball_RewardHandlerOffsets
                dc.w    SKGumball_RefillOrNoopRewardReturn-SKGumball_RewardHandlerOffsets
                dc.w    SKGumball_RepelLowWordContact-SKGumball_RewardHandlerOffsets
                dc.w    SKGumball_GiveFireShieldToP1-SKGumball_RewardHandlerOffsets
                dc.w    SKGumball_GiveBubbleShieldToP1-SKGumball_RewardHandlerOffsets
                dc.w    SKGumball_GiveLightningShieldToP1-SKGumball_RewardHandlerOffsets
                dc.w    SKGumball_SetSavedStatusBit7-SKGumball_RewardHandlerOffsets
; ---------------------------------------------------------------------------

SKGumball_AwardLifeAndPlayMusic:
                addq.b  #1,(Life_count).w
                addq.b  #1,(Update_HUD_life_count).w
                moveq   #signextendB(mus_ExtraLife),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

SKGumball_TryRefillIfPlatformMissing:
                tst.b   ((RAM_start+$2022)&$FFFFFF).l
                bne.s   SKGumball_RewardDispatchReturn
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKGumball_RewardDispatchReturn
                move.l  #SKGumball_InitPlatformAndFourSprings,(a1)
                st      ((RAM_start+$2022)&$FFFFFF).l

SKGumball_RefillOrNoopRewardReturn:
                rts
; ---------------------------------------------------------------------------

; Add 20 to the saved ring count and 10 to the live count
SKGumball_AddSavedAndLiveRings:
                addi.w  #20,(Saved_ring_count).w
                moveq   #10,d0
                jmp     (AddRings).l
; ---------------------------------------------------------------------------

SKGumball_RepelLowWordContact:
                move.l  d0,-(sp)
                tst.w   d0
                beq.s   SKGumball_RepelHighWordContact
                bsr.s   SKGumballRound_RepelPlayer

SKGumball_RepelHighWordContact:
                move.l  (sp)+,d0
                swap    d0
                tst.w   d0
                beq.s   SKGumball_ClearRoundItemContacts
                bsr.s   SKGumballRound_RepelPlayer

SKGumball_ClearRoundItemContacts:
                clr.b   collision_property(a0)
                moveq   #0,d2
                rts

; =============== S U B R O U T I N E =======================================

; Use magnitude $700 and perturb the angle with the high byte of the frame counter
SKGumballRound_RepelPlayer:
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
; End of function SKGumballRound_RepelPlayer

; ---------------------------------------------------------------------------

SKGumball_GiveFireShieldToP1:
                lea     (Player_1).w,a1
                move.l  #Obj_FireShield,(Shield).w
                move.w  a1,(Shield+parent).w
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                moveq   #Status_FireShield,d0
                bsr.w   SKGumball_SetLiveAndSavedShield
                moveq   #signextendB(sfx_FireShield),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

SKGumball_GiveBubbleShieldToP1:
                lea     (Player_1).w,a1
                move.l  #Obj_BubbleShield,(Shield).w
                move.w  a1,(Shield+parent).w
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                moveq   #Status_BublShield,d0
                bsr.w   SKGumball_SetLiveAndSavedShield
                moveq   #signextendB(sfx_BubbleShield),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

SKGumball_GiveLightningShieldToP1:
                lea     (Player_1).w,a1
                move.l  #Obj_LightningShield,(Shield).w
                move.w  a1,(Shield+parent).w
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                moveq   #Status_LtngShield,d0
                bsr.w   SKGumball_SetLiveAndSavedShield
                moveq   #signextendB(sfx_LightningShield),d0
                jmp     (Play_Music).l

; =============== S U B R O U T I N E =======================================

; Set the live shield bit and replace the saved elemental bits used when returning to the main level
SKGumball_SetLiveAndSavedShield:
                bset    d0,status_secondary(a1)
                lea     (Saved_status_secondary).w,a2
                andi.b  #$8F,(a2)
                bset    d0,(a2)
                rts
; End of function SKGumball_SetLiveAndSavedShield

; ---------------------------------------------------------------------------

SKGumball_SetSavedStatusBit7:
                bset    #7,(Saved_status_secondary).w
                rts

; =============== S U B R O U T I N E =======================================

; When flagged, count leading empty occupancy words to choose the target. Move down four pixels per update
SKGumballMachine_UpdateDescent:
                bclr    #0,$38(a0)
                beq.s   SKGumball_DescendFourTowardTarget
                lea     ((RAM_start+$2000)&$FFFFFF).l,a1
                moveq   #0,d0
                moveq   #$E-1,d1

SKGumball_ScanLeadingEmptyBumperPairs:
                tst.w   (a1)+
                bne.s   SKGumball_SetTargetYFromEmptyPairs
                addi.w  #$20,d0
                dbf     d1,SKGumball_ScanLeadingEmptyBumperPairs

SKGumball_SetTargetYFromEmptyPairs:
                move.w  $3A(a0),d1
                add.w   d0,d1
                move.w  d1,$3C(a0)

SKGumball_DescendFourTowardTarget:
                move.w  $3C(a0),d1
                move.w  y_pos(a0),d2
                cmp.w   d1,d2
                bhs.s   SKGumball_MachineDescentReturn
                addq.w  #4,d2
                move.w  d2,y_pos(a0)

SKGumball_MachineDescentReturn:
                rts
; End of function SKGumballMachine_UpdateDescent

; =============== S U B R O U T I N E =======================================

; Use the weighted 16-entry table and honor only the first index-zero life roll for each machine
SKGumballMachine_ChooseDrop:
                jsr     (Random_Number).l
                andi.w  #$F,d0
                bne.s   SKGumball_SetWeightedRewardAndCollision
                movea.w parent3(a0),a1
                bset    #7,$38(a1)
                beq.s   SKGumball_SetWeightedRewardAndCollision
                moveq   #3,d0

SKGumball_SetWeightedRewardAndCollision:
                move.b  SKGumball_SixteenWeightedRewardTypeBytes(pc,d0.w),d0
                move.b  d0,subtype(a0)
                cmpi.b  #4,d0
                bne.s   SKGumball_SelectRewardRawAnim
                move.b  #$D7,collision_flags(a0)

SKGumball_SelectRewardRawAnim:
                lsl.w   #2,d0
                move.l  SKGumball_RewardRawAnimPointers(pc,d0.w),$30(a0)
                rts
; End of function SKGumballMachine_ChooseDrop

; ---------------------------------------------------------------------------
SKGumball_SixteenWeightedRewardTypeBytes:
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
SKGumball_RewardRawAnimPointers:
                dc.l    SKGumball_LifeRewardSingleDelayRawStream
                dc.l    SKGumball_PlatformRefillAnim
                dc.l    SKGumball_RingRewardSingleDelayRawStream
                dc.l    SKGumball_NoopRewardSingleDelayRawStream
                dc.l    SKGumball_PersistentRoundRewardAnim
                dc.l    SKGumball_FireShieldRewardAnim
                dc.l    SKGumball_BubbleShieldRewardAnim
                dc.l    SKGumball_LightningShieldRewardAnim
                dc.l    SKGumball_SavedStatusBit7RewardAnim

; =============== S U B R O U T I N E =======================================

; Pass the fixed refill-platform dimensions and current X, then tail-call the supplied worker in a1
SKGumballPlatform_CallSolidity:
                moveq   #$4B,d1
                moveq   #$10,d2
                moveq   #$11,d3
                move.w  x_pos(a0),d4
                jmp     (a1)
; End of function SKGumballPlatform_CallSolidity

; =============== S U B R O U T I N E =======================================

GumballSKOffsetDebrisAndSeedSubtypeDelay:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  d0,$2E(a0)
                lea     SKGumball_DebrisOffsetPairs(pc,d0.w),a1
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
SKGumball_DebrisOffsetPairs:
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

; Subtype selects one of four decoration frames and can spawn the central mask sprite
SKGumballDecor_SelectFrameAndMask:
                moveq   #0,d0
                move.b  subtype(a0),d0
                subi.w  #6,d0
                lsr.w   #1,d0
                move.b  SKGumball_DecorationFramesBySubtype(pc,d0.w),d0
                move.b  d0,mapping_frame(a0)
                cmpi.b  #$16,d0
                bne.w   SKGumball_BodyCallbackReturn
                lea     SKGumball_SpriteMaskChildRecord(pc),a2
                jmp     (CreateChild6_Simple).l
; End of function SKGumballDecor_SelectFrameAndMask

; ---------------------------------------------------------------------------
SKGumball_DecorationFramesBySubtype:
                dc.b    0,   1,   0, $16
