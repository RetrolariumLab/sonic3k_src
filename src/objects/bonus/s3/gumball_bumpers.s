; Owner: objects/bonus/s3
; Responsibility: Gumball triangle bumpers, player collision, bounce response and shared bonus resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_GumballTriangleBumper:
                lea     S3Gumball_TriangleBumperFullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #S3Gumball_GateTriangleOnCooldown,(a0)

S3Gumball_GateTriangleOnCooldown:
                tst.w   ((RAM_start+$2020)&$FFFFFF).l
                bpl.s   S3Gumball_DrawTriangleWithoutConsumption
                moveq   #$D,d1
                moveq   #8,d2
                moveq   #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                btst    #$10,d6
                bne.s   S3Gumball_LaunchP1AndDeleteTriangle
                btst    #p1_standing_bit,status(a0)
                beq.s   S3Gumball_CheckTriangleP2Contact

S3Gumball_LaunchP1AndDeleteTriangle:
                lea     (Player_1).w,a1
                bsr.w   S3GumballTriangle_LaunchAndClear
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3Gumball_CheckTriangleP2Contact:
                btst    #$11,d6
                bne.s   S3Gumball_LaunchP2AndDeleteTriangle
                btst    #p2_standing_bit,status(a0)
                beq.s   S3Gumball_DrawTriangleWithoutConsumption

S3Gumball_LaunchP2AndDeleteTriangle:
                lea     (Player_2).w,a1
                bsr.w   S3GumballTriangle_LaunchAndClear
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3Gumball_DrawTriangleWithoutConsumption:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Consume the bumper cell. Notify the machine to descend once both cells in the pair are empty
S3GumballTriangle_LaunchAndClear:
                move.w  #-$300,d0
                move.w  #-$600,y_vel(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,render_flags(a0)
                bne.s   S3Gumball_LaunchAndConsumeTriangleCell
                bclr    #Status_Facing,status(a1)
                neg.w   d0

S3Gumball_LaunchAndConsumeTriangleCell:
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
; End of function S3GumballTriangle_LaunchAndClear

; ---------------------------------------------------------------------------

S3Gumball_InitDecorationAndMaybeMask:
                lea     S3Gumball_DecorationAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #S3Gumball_FollowRootAndDrawDecoration,(a0)
                bsr.w   S3GumballDecor_SelectFrameAndMask

S3Gumball_FollowRootAndDrawDecoration:
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Gumball_InitDebrisAndSetDelay:
                lea     S3Gumball_PlatformDebrisFullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #S3Gumball_TickDelayAndStartDebrisFall,(a0)
                bsr.w   GumballS3OffsetDebrisAndSeedSubtypeDelay

S3Gumball_TickDelayAndStartDebrisFall:
                subq.b  #1,$2E(a0)
                bpl.s   S3Gumball_DrawPlatformDebris
                move.l  #MoveChkDel,(a0)

S3Gumball_DrawPlatformDebris:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Gumball_InitExitMonitor:
                addi.w  #$2A0,y_pos(a0)
                move.l  #S3Gumball_TickCooldownAndCheckExit,(a0)

S3Gumball_TickCooldownAndCheckExit:
                subq.w  #1,((RAM_start+$2020)&$FFFFFF).l
                lea     S3Gumball_ExitMonitorBounds(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                bne.s   S3Gumball_SaveP1AndRequestLevelRestart
                swap    d0
                tst.w   d0
                beq.w   S3Gumball_BodyCallbackReturn
                lea     (Player_2).w,a1
                jmp     (Delete_Referenced_Sprite).l
; ---------------------------------------------------------------------------

S3Gumball_SaveP1AndRequestLevelRestart:
                move.w  (Saved_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved_apparent_zone_and_act).w,(Apparent_zone_and_act).w
                move.b  (Saved_last_star_post_hit).w,(Last_star_post_hit).w
                move.b  #0,(Special_bonus_entry_flag).w
                move.b  #1,(Restart_level_flag).w
                move.w  (Ring_count).w,(Saved_ring_count).w
                move.b  (Extra_life_flags).w,(Saved_extra_life_flags).w
                rts
; ---------------------------------------------------------------------------
S3Gumball_ExitMonitorBounds:
                dc.w    -$100,  $200,  -$10,   $40
; ---------------------------------------------------------------------------

S3Gumball_InitMaskChildFrame23:
                lea     S3Gumball_SpriteMaskAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #S3Gumball_SetMaskFlagAndFollowParent,(a0)

S3Gumball_SetMaskFlagAndFollowParent:
                st      (Spritemask_flag).w
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Check both players, dispatch one subtype effect and return Z when the item should remain
S3Gumball_TryRewardNearbyPlayer:
                lea     S3Gumball_RewardContactBounds(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.l   d0
                beq.s   S3Gumball_RewardDispatchReturn
                moveq   #0,d1
                moveq   #1,d2
                move.b  subtype(a0),d1
                add.w   d1,d1
                move.w  S3Gumball_RewardHandlerOffsets(pc,d1.w),d1
                jsr     S3Gumball_RewardHandlerOffsets(pc,d1.w)
                tst.w   d2

S3Gumball_RewardDispatchReturn:
                rts
; End of function S3Gumball_TryRewardNearbyPlayer

; ---------------------------------------------------------------------------
S3Gumball_RewardHandlerOffsets:
                dc.w    S3Gumball_AwardLifeWithoutCap-S3Gumball_RewardHandlerOffsets
                dc.w    S3Gumball_TryRefillIfPlatformMissing-S3Gumball_RewardHandlerOffsets
                dc.w    S3Gumball_AddSavedAndLiveRings-S3Gumball_RewardHandlerOffsets
                dc.w    S3Gumball_RefillOrNoopRewardReturn-S3Gumball_RewardHandlerOffsets
                dc.w    S3Gumball_RepelLowWordContact-S3Gumball_RewardHandlerOffsets
                dc.w    S3Gumball_GiveFireShieldToP1-S3Gumball_RewardHandlerOffsets
                dc.w    S3Gumball_GiveBubbleShieldToP1-S3Gumball_RewardHandlerOffsets
                dc.w    S3Gumball_GiveLightningShieldToP1-S3Gumball_RewardHandlerOffsets
                dc.w    S3Gumball_SetSavedStatusBit7-S3Gumball_RewardHandlerOffsets
S3Gumball_RewardContactBounds:
                dc.w    -$18,   $30,  -$18,   $30
; ---------------------------------------------------------------------------

S3Gumball_AwardLifeWithoutCap:
                addq.b  #1,(Life_count).w
                addq.b  #1,(Update_HUD_life_count).w
                moveq   #signextendB(mus_ExtraLife),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

S3Gumball_TryRefillIfPlatformMissing:
                tst.b   ((RAM_start+$2022)&$FFFFFF).l
                bne.s   S3Gumball_RewardDispatchReturn
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3Gumball_RewardDispatchReturn
                move.l  #S3Gumball_InitPlatformAndFourSprings,(a1)
                st      ((RAM_start+$2022)&$FFFFFF).l

S3Gumball_RefillOrNoopRewardReturn:
                rts
; ---------------------------------------------------------------------------

; Add 20 to the saved ring count and 10 to the live count
S3Gumball_AddSavedAndLiveRings:
                addi.w  #20,(Saved_ring_count).w
                moveq   #10,d0
                jmp     (AddRings).l
; ---------------------------------------------------------------------------

S3Gumball_RepelLowWordContact:
                move.l  d0,-(sp)
                tst.w   d0
                beq.s   S3Gumball_RepelHighWordContact
                bsr.s   S3GumballRound_RepelPlayer

S3Gumball_RepelHighWordContact:
                move.l  (sp)+,d0
                swap    d0
                tst.w   d0
                beq.s   S3Gumball_ClearRoundItemContacts
                bsr.s   S3GumballRound_RepelPlayer

S3Gumball_ClearRoundItemContacts:
                clr.b   collision_property(a0)
                moveq   #0,d2
                rts

; =============== S U B R O U T I N E =======================================

; Use magnitude $700 and perturb the angle with the high byte of the frame counter
S3GumballRound_RepelPlayer:
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
; End of function S3GumballRound_RepelPlayer

; ---------------------------------------------------------------------------

S3Gumball_GiveFireShieldToP1:
                lea     (Player_1).w,a1
                move.l  #Obj_FireShield,(Shield).w
                move.w  a1,(Shield+parent).w
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                moveq   #Status_FireShield,d0
                bsr.w   S3Gumball_SetLiveAndSavedShield
                moveq   #signextendB(sfx_FireShield),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

S3Gumball_GiveBubbleShieldToP1:
                lea     (Player_1).w,a1
                move.l  #Obj_BubbleShield,(Shield).w
                move.w  a1,(Shield+parent).w
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                moveq   #Status_BublShield,d0
                bsr.w   S3Gumball_SetLiveAndSavedShield
                moveq   #signextendB(sfx_BubbleShield),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

S3Gumball_GiveLightningShieldToP1:
                lea     (Player_1).w,a1
                move.l  #Obj_LightningShield,(Shield).w
                move.w  a1,(Shield+parent).w
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                moveq   #Status_LtngShield,d0
                bsr.w   S3Gumball_SetLiveAndSavedShield
                moveq   #signextendB(sfx_LightningShield),d0
                jmp     (Play_Music).l

; =============== S U B R O U T I N E =======================================

; Set the live shield bit and replace the saved elemental bits used when returning to the main level
S3Gumball_SetLiveAndSavedShield:
                bset    d0,status_secondary(a1)
                lea     (Saved_status_secondary).w,a2
                andi.b  #$8F,(a2)
                bset    d0,(a2)
                rts
; End of function S3Gumball_SetLiveAndSavedShield

; ---------------------------------------------------------------------------

; The weighted item table does not select this reward slot
S3Gumball_SetSavedStatusBit7:
                bset    #7,(Saved_status_secondary).w
                rts

; =============== S U B R O U T I N E =======================================

; When flagged, count leading empty occupancy words to choose the target. Move down four pixels per update
S3GumballMachine_UpdateDescent:
                bclr    #0,$38(a0)
                beq.s   S3Gumball_DescendFourTowardTarget
                lea     ((RAM_start+$2000)&$FFFFFF).l,a1
                moveq   #0,d0
                moveq   #$E-1,d1

S3Gumball_ScanLeadingEmptyBumperPairs:
                tst.w   (a1)+
                bne.s   S3Gumball_SetTargetYFromEmptyPairs
                addi.w  #$20,d0
                dbf     d1,S3Gumball_ScanLeadingEmptyBumperPairs

S3Gumball_SetTargetYFromEmptyPairs:
                move.w  $3A(a0),d1
                add.w   d0,d1
                move.w  d1,$3C(a0)

S3Gumball_DescendFourTowardTarget:
                move.w  $3C(a0),d1
                move.w  y_pos(a0),d2
                cmp.w   d1,d2
                bhs.s   S3Gumball_MachineDescentReturn
                addq.w  #4,d2
                move.w  d2,y_pos(a0)

S3Gumball_MachineDescentReturn:
                rts
; End of function S3GumballMachine_UpdateDescent

; =============== S U B R O U T I N E =======================================

; Use the weighted 16-entry table and honor only the first index-zero life roll for each machine
S3GumballMachine_ChooseDrop:
                jsr     (Random_Number).l
                andi.w  #$F,d0
                bne.s   S3Gumball_SetWeightedRewardAndCollision
                movea.w parent3(a0),a1
                bset    #7,$38(a1)
                beq.s   S3Gumball_SetWeightedRewardAndCollision
                moveq   #3,d0

S3Gumball_SetWeightedRewardAndCollision:
                move.b  S3Gumball_WeightedRewardTypeTable(pc,d0.w),d0
                move.b  d0,subtype(a0)
                cmpi.b  #4,d0
                bne.s   S3Gumball_SelectRewardRawAnim
                move.b  #$D7,collision_flags(a0)

S3Gumball_SelectRewardRawAnim:
                lsl.w   #2,d0
                move.l  S3Gumball_RewardRawAnimPointers(pc,d0.w),$30(a0)
                rts
; End of function S3GumballMachine_ChooseDrop

; ---------------------------------------------------------------------------
S3Gumball_WeightedRewardTypeTable:
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
S3Gumball_RewardRawAnimPointers:
                dc.l    S3Gumball_ExtraLifeRewardAnim
                dc.l    S3Gumball_PlatformRefillAnim
                dc.l    S3Gumball_RingRewardItemOrdinaryRawIdle
                dc.l    S3Gumball_NoopConsumedRewardAnim
                dc.l    S3Gumball_PersistentRoundRewardAnim
                dc.l    S3Gumball_FireShieldRewardAnim
                dc.l    S3Gumball_BubbleShieldRewardAnim
                dc.l    S3Gumball_LightningShieldRewardAnim
                dc.l    S3Gumball_SavedStatusBit7RewardAnim

; =============== S U B R O U T I N E =======================================

; Pass the fixed refill-platform dimensions and current X, then tail-call the supplied worker in a1
S3GumballPlatform_CallSolidity:
                moveq   #$4B,d1
                moveq   #$10,d2
                moveq   #$11,d3
                move.w  x_pos(a0),d4
                jmp     (a1)
; End of function S3GumballPlatform_CallSolidity

; =============== S U B R O U T I N E =======================================

GumballS3OffsetDebrisAndSeedSubtypeDelay:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  d0,$2E(a0)
                lea     S3Gumball_DebrisOffsetPairs(pc,d0.w),a1
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,x_pos(a0)
                moveq   #0,d0
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,y_pos(a0)
                rts
; End of function GumballS3OffsetDebrisAndSeedSubtypeDelay

; ---------------------------------------------------------------------------
S3Gumball_DebrisOffsetPairs:
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
S3GumballDecor_SelectFrameAndMask:
                moveq   #0,d0
                move.b  subtype(a0),d0
                subi.w  #6,d0
                lsr.w   #1,d0
                move.b  S3Gumball_DecorationFramesBySubtype(pc,d0.w),d0
                move.b  d0,mapping_frame(a0)
                cmpi.b  #$16,d0
                bne.w   S3Gumball_BodyCallbackReturn
                lea     S3Gumball_SpriteMaskChildRecord(pc),a2
                jmp     (CreateChild6_Simple).l
; End of function S3GumballDecor_SelectFrameAndMask

; ---------------------------------------------------------------------------
S3Gumball_DecorationFramesBySubtype:
                dc.b    0,   1,   0, $16
S3Gumball_DecorationAttributes:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,0,0)
                dc.w    $200
                dc.b    $10, $20,   0,   0
S3Gumball_RefillablePlatformAttributes:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    $40, $10, $13,   0
S3Gumball_TriangleBumperFullAttributes:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    4, $10, $12,   0
ObjDat_GumballMachine:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    $18, $18,   5,   0
S3Gumball_MechanismBodyAttributes:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    $14, $14,   2,   0
S3Gumball_FiniteUpSpringFullAttributes:
                dc.l    Map_Spring
                dc.w    make_art_tile(ArtTile_SpikesSprings+$10,0,0)
                dc.w    $100
                dc.b    $10, $10,   0,   0
S3Gumball_PlatformDebrisFullAttributes:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    8,   8, $15,   0
S3Gumball_RewardItemAttributes:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,0,1)
                dc.w    $100
                dc.b    8,   8,   8,   0
S3Gumball_SpriteMaskAttributes:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile($000,0,0)
                dc.w    $180
                dc.b    4, $10, $17,   0
S3Gumball_MachineChildRecords:
                dc.w    7-1
                dc.l    S3Gumball_InitPlatformAndFourSprings
                dc.b    0,   0
                dc.l    S3Gumball_InitMechanismBody
                dc.b    0, $24
                dc.l    S3Gumball_InitExitMonitor
                dc.b    0,   0
                dc.l    S3Gumball_InitDecorationAndMaybeMask
                dc.b    -$38,-$2C
                dc.l    S3Gumball_InitDecorationAndMaybeMask
                dc.b    0,-$2C
                dc.l    S3Gumball_InitDecorationAndMaybeMask
                dc.b    $38,-$2C
                dc.l    S3Gumball_InitDecorationAndMaybeMask
                dc.b    0,-$28
S3Gumball_PlatformSpringChildRecords:
                dc.w    4-1
                dc.l    S3Gumball_InitAndCheckSpringP1
                dc.b    -$30,-$18
                dc.l    S3Gumball_InitAndCheckSpringP1
                dc.b    -$10,-$18
                dc.l    S3Gumball_InitAndCheckSpringP1
                dc.b    $10,-$18
                dc.l    S3Gumball_InitAndCheckSpringP1
                dc.b    $30,-$18
S3Gumball_PlatformDebrisChildRecords:
                dc.w    $10-1
                dc.l    S3Gumball_InitDebrisAndSetDelay
S3Gumball_OneSimpleDispensedRewardChild:
                dc.w    1-1
                dc.l    S3Gumball_InitWeightedRewardItem
S3Gumball_SpriteMaskChildRecord:
                dc.w    1-1
                dc.l    S3Gumball_InitMaskChildFrame23
S3Gumball_MachineActivationAnim:
                dc.b    3,   5,   6,   7, $14,   5, $F4
                dc.b    $7F,   5,   5, $FC
S3Gumball_BodyCycleCallbackAnim:
                dc.b    2,   3,   3,   3,   4,  $F,   3,   3,   2,   3, $F4
S3Gumball_ExtraLifeRewardAnim:
                dc.b    $7F,   8,   8, $FC
S3Gumball_PlatformRefillAnim:
                dc.b    $7F,   9,   9, $FC
S3Gumball_RingRewardItemOrdinaryRawIdle:
                dc.b    $7F,  $A,  $A, $FC
S3Gumball_NoopConsumedRewardAnim:
                dc.b    $7F,  $B,  $B, $FC
S3Gumball_PersistentRoundRewardAnim:
                dc.b    $7F,  $C,  $C, $FC
S3Gumball_FireShieldRewardAnim:
                dc.b    $7F,  $D,  $D, $FC
S3Gumball_BubbleShieldRewardAnim:
                dc.b    $7F,  $E,  $E, $FC
S3Gumball_LightningShieldRewardAnim:
                dc.b    $7F,  $F,  $F, $FC
S3Gumball_SavedStatusBit7RewardAnim:
                dc.b    1, $10, $11, $FC
