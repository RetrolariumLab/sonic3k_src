; Owner: objects/enemies/sk
; Responsibility: Chainspike enemy, linked spike motion, collision helpers and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Chainspike:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Chainspike_Index(pc,d0.w),d1
                jsr     Chainspike_Index(pc,d1.w)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
Chainspike_Index:
                dc.w    SKChainspike_InitTravelDirection-Chainspike_Index
                dc.w    SKChainspike_CheckAttackAndTickWait-Chainspike_Index
                dc.w    SKChainspike_CheckAttackAndDecel-Chainspike_Index
                dc.w    SKChainspike_AnimateAttack-Chainspike_Index
                dc.w    SKChainspike_WaitForExtensionEnd-Chainspike_Index
                dc.w    SKChainspike_TickCooldownAndResume-Chainspike_Index
; ---------------------------------------------------------------------------

SKChainspike_InitTravelDirection:
                lea     ObjDat_Chainspike(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #-$1200,d0
                move.w  #$180,d1
                btst    #0,render_flags(a0)
                beq.s   SKChainspike_InitTravelAndSpawnChildren
                neg.w   d0
                neg.w   d1

SKChainspike_InitTravelAndSpawnChildren:
                move.w  d0,$3E(a0)
                move.w  d1,$3C(a0)
                move.l  #SKChainspike_BeginTravel,$34(a0)
                lea     SKChainspike_ExtensionAndSideChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKChainspike_CheckAttackAndTickWait:
                jsr     (InterruptChainspikeForNearbyPlayerAttack).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKChainspike_BeginTravel:
                move.b  #4,routine(a0)
                move.w  $3E(a0),x_vel(a0)
                move.w  $3C(a0),$40(a0)
                moveq   #signextendB(sfx_TunnelBooster),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SKChainspike_CheckAttackAndDecel:
                jsr     (InterruptChainspikeForNearbyPlayerAttack).l
                move.w  x_vel(a0),d0
                moveq   #$C,d2
                move.w  $40(a0),d1
                bmi.s   SKChainspike_UpdateAccelAndTestSpeed
                neg.w   d2

SKChainspike_UpdateAccelAndTestSpeed:
                add.w   d2,d1
                move.w  d1,$40(a0)
                add.w   d1,d0
                smi     d2
                tst.w   $3E(a0)
                bpl.s   SKChainspike_TryMoveBeforeSpeedCrossing
                not.b   d2

SKChainspike_TryMoveBeforeSpeedCrossing:
                tst.b   d2
                bne.s   SKChainspike_WaitAndReverseNextTravel
                move.w  d0,x_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

SKChainspike_WaitAndReverseNextTravel:
                move.b  #2,routine(a0)
                move.w  #(2*60)-1,$2E(a0)
                neg.w   $3E(a0)
                neg.w   $3C(a0)
                rts
; ---------------------------------------------------------------------------

SKChainspike_AnimateAttack:
                jmp     (Animate_RawGetFaster).l
; ---------------------------------------------------------------------------

SKChainspike_RequestSpikeExtension:
                move.b  #8,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKChainspike_WaitForExtensionEnd:
                btst    #1,$38(a0)
                bne.s   SKChainspike_ExtensionWaitReturn
                move.b  #$A,routine(a0)
                move.b  #$1F,$39(a0)

SKChainspike_ExtensionWaitReturn:
                rts
; ---------------------------------------------------------------------------

SKChainspike_TickCooldownAndResume:
                subq.b  #1,$39(a0)
                bpl.s   SKChainspike_CooldownReturn
                move.b  $3A(a0),routine(a0)
                move.w  $26(a0),$2E(a0)
                move.l  #SKChainspike_BeginTravel,$34(a0)

SKChainspike_CooldownReturn:
                rts
; ---------------------------------------------------------------------------

SKChainspikeSpike_DispatchSpikeAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKChainspikeSpike_SpikeStateOffsets(pc,d0.w),d1
                jsr     SKChainspikeSpike_SpikeStateOffsets(pc,d1.w)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
SKChainspikeSpike_SpikeStateOffsets:
                dc.w    SKChainspikeSpike_InitSpike-SKChainspikeSpike_SpikeStateOffsets
                dc.w    SKChainspikeSpike_FollowAndCheckSide-SKChainspikeSpike_SpikeStateOffsets
                dc.w    SKChainspikeSpike_MoveSpikeAndCheckBaseY-SKChainspikeSpike_SpikeStateOffsets
; ---------------------------------------------------------------------------

SKChainspikeSpike_InitSpike:
                lea     SKChainspikeSpike_SpikeAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKChainspikeSpike_BeginSlowRetraction,$34(a0)
                tst.b   subtype(a0)
                beq.s   SKChainspikeSpike_SpikeInitReturn
                bset    #1,render_flags(a0)

SKChainspikeSpike_SpikeInitReturn:
                rts
; ---------------------------------------------------------------------------

SKChainspikeSpike_FollowAndCheckSide:
                jsr     (Refresh_ChildPosition).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   SKChainspikeSpike_ExtensionSetupReturn
                btst    #1,render_flags(a1)
                sne     d0
                tst.b   subtype(a0)
                beq.s   SKChainspikeSpike_TryBeginExtension
                not.b   d0

SKChainspikeSpike_TryBeginExtension:
                tst.b   d0
                bne.s   SKChainspikeSpike_ExtensionSetupReturn
                move.b  #4,routine(a0)
                move.b  #$18,collision_flags(a0)
                move.b  #-1,collision_property(a0)
                moveq   #8,d0
                btst    #1,render_flags(a1)
                beq.s   SKChainspikeSpike_InitExtensionTravel
                neg.w   d0

SKChainspikeSpike_InitExtensionTravel:
                move.w  d0,y_vel(a0)
                move.w  y_pos(a0),$3A(a0)
                move.w  #$17,$2E(a0)

SKChainspikeSpike_ExtensionSetupReturn:
                rts
; ---------------------------------------------------------------------------

SKChainspikeSpike_MoveSpikeAndCheckBaseY:
                move.w  y_pos(a0),d0
                add.w   y_vel(a0),d0
                move.w  d0,y_pos(a0)
                bsr.w   SelectChainspikeExtensionFrameByDistance
                cmp.w   $3A(a0),d0
                beq.s   SKChainspikeSpike_RestoreIdleAndAckRoot
                btst    #1,render_flags(a0)
                sne     d0
                tst.w   y_vel(a0)
                bmi.s   SKChainspikeSpike_CheckOutwardContact
                not.b   d0

SKChainspikeSpike_CheckOutwardContact:
                tst.b   d0
                beq.s   SKChainspikeSpike_TickTravelTimer
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   SKChainspikeSpike_BeginSlowRetraction
                tst.b   collision_flags(a0)
                beq.s   SKChainspikeSpike_RearmSpikeContact

SKChainspikeSpike_TickTravelTimer:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKChainspikeSpike_RestoreIdleAndAckRoot:
                move.b  #2,routine(a0)
                move.b  #$98,collision_flags(a0)
                move.b  #2,mapping_frame(a0)
                movea.w $46(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

SKChainspikeSpike_RearmSpikeContact:
                move.b  #$18,collision_flags(a0)

SKChainspikeSpike_BeginSlowRetraction:
                move.w  #$5F,$2E(a0)
                move.w  y_vel(a0),d0
                asr.w   #2,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKChainspikeSide_InitSideCollider:
                move.b  #$98,collision_flags(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.l  #SKChainspikeSide_FollowRootAndQueueTouch,(a0)

SKChainspikeSide_FollowRootAndQueueTouch:
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_AddToTouchList).l

; =============== S U B R O U T I N E =======================================

InterruptChainspikeForNearbyPlayerAttack:
                jsr     (Find_SonicTails).l
                cmpi.w  #$10,d2
                bhs.s   SKChainspike_AttackCheckReturn
                move.b  routine(a0),$3A(a0)
                move.b  #6,routine(a0)
                move.w  $2E(a0),$26(a0)
                move.l  #SKChainspike_AttackAnimation,$30(a0)
                move.l  #SKChainspike_RequestSpikeExtension,$34(a0)
                addq.w  #4,sp

; Starting an attack drops the helper return address, skipping the rest of the root state
SKChainspike_AttackCheckReturn:
                rts
; End of function InterruptChainspikeForNearbyPlayerAttack

; =============== S U B R O U T I N E =======================================

SelectChainspikeExtensionFrameByDistance:
                move.w  $3A(a0),d1
                sub.w   d0,d1
                bpl.s   SKChainspikeSpike_InitFrameThresholdScan
                neg.w   d1

SKChainspikeSpike_InitFrameThresholdScan:
                moveq   #0,d2
                moveq   #$18,d3
                moveq   #4-1,d4

SKChainspikeSpike_ScanDistanceThreshold:
                add.w   d3,d2
                cmp.w   d2,d1
                bls.s   SKChainspikeSpike_ApplyDistanceFrame
                dbf     d4,SKChainspikeSpike_ScanDistanceThreshold
                moveq   #0,d4

SKChainspikeSpike_ApplyDistanceFrame:
                move.b  SKChainspikeSpike_DistanceFrames(pc,d4.w),mapping_frame(a0)
                rts
; End of function SelectChainspikeExtensionFrameByDistance

; ---------------------------------------------------------------------------
SKChainspikeSpike_DistanceFrames:
                dc.b    7,   6,   5,   4,   2
                even
ObjDat_Chainspike:
                dc.l    Map_Chainspike
                dc.w    make_art_tile(ArtTile_Chainspike,1,1)
                dc.w    $280
                dc.b    $18,  $C,   0, $1A
SKChainspikeSpike_SpikeAttributes:
                dc.w    $280
                dc.b    8, $80,   2, $98
SKChainspike_ExtensionAndSideChildren:
                dc.w    4-1
                dc.l    SKChainspikeSpike_DispatchSpikeAndDraw
                dc.b    0, $14
                dc.l    SKChainspikeSpike_DispatchSpikeAndDraw
                dc.b    0,-$14
                dc.l    SKChainspikeSide_InitSideCollider
                dc.b    $14,   0
                dc.l    SKChainspikeSide_InitSideCollider
                dc.b    -$14,   0
SKChainspike_AttackAnimation:
                dc.b    5,   6
                dc.b    0,   3
                dc.b    $FC, $FF
                even
