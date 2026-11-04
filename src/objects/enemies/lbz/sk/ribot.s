; Owner: objects/enemies/lbz/sk
; Responsibility: Ribot enemy and spawned actors with private movement and construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Ribot:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Ribot_Index(pc,d0.w),d1
                jsr     Ribot_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Ribot_Index:
                dc.w    SKRibot_InitAndSelectLimbs-Ribot_Index
                dc.w    SKRibot_AlternateActiveLimb-Ribot_Index
; ---------------------------------------------------------------------------

SKRibot_InitAndSelectLimbs:
                lea     ObjDat_Ribot(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #2,$38(a0)
                move.b  subtype(a0),d0
                subq.b  #2,d0
                beq.s   SKRibot_SpawnHorizontalLimbs
                bpl.s   SKRibot_SpawnUpperLimb
                move.l  #RibotSK_Root_UniformFrameZeroOneTwoLoop,$30(a0)
                lea     SKRibot_DownwardLimbChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKRibot_SpawnHorizontalLimbs:
                move.l  #RibotSK_Root_UniformFrameZeroOneTwoLoop,$30(a0)
                lea     RibotSK_Root_TwoLateralNormalLimbRecords(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKRibot_SpawnUpperLimb:
                move.l  #SKRibot_UpperLimbBodyAnim,$30(a0)
                lea     RibotSK_Root_OneUpperNormalLimbRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKRibot_AlternateActiveLimb:
                bclr    #2,$38(a0)
                beq.s   RibotSK_Root_DecodeBodyUniformLoop
                andi.b  #$FC,$38(a0)
                moveq   #0,d0
                bchg    #3,$38(a0)
                beq.s   SKRibot_ActivateSelectedLimb
                moveq   #1,d0

SKRibot_ActivateSelectedLimb:
                bset    d0,$38(a0)

RibotSK_Root_DecodeBodyUniformLoop:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

SKRibot_UpdateLimbAndDraw:
                moveq   #0,d2
                movea.w parent3(a0),a1
                move.b  subtype(a1),d2
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  RibotSK_Limb_FiveRelativeStateOffsets(pc,d0.w),d1
                jsr     RibotSK_Limb_FiveRelativeStateOffsets(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
RibotSK_Limb_FiveRelativeStateOffsets:
                dc.w    SKRibot_InitLimbAndSpawnLinks-RibotSK_Limb_FiveRelativeStateOffsets
                dc.w    SKRibot_DispatchIdleLimb-RibotSK_Limb_FiveRelativeStateOffsets
                dc.w    SKRibot_DispatchActiveLimb-RibotSK_Limb_FiveRelativeStateOffsets
                dc.w    SKRibot_DispatchPausedLimb-RibotSK_Limb_FiveRelativeStateOffsets
                dc.w    SKRibot_DispatchReturningLimb-RibotSK_Limb_FiveRelativeStateOffsets
; ---------------------------------------------------------------------------

SKRibot_InitLimbAndSpawnLinks:
                lea     SKRibot_LimbAttrs(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #8,y_radius(a0)
                move.b  #-$10,child_dy(a0)
                move.w  x_pos(a0),$3E(a0)
                move.w  y_pos(a0),$40(a0)
                bra.w   SKRibot_SelectLimbLinkRecord
; ---------------------------------------------------------------------------

SKRibot_DispatchIdleLimb:
                move.w  SKRibot_IdleLimbTable(pc,d2.w),d3
                jmp     SKRibot_IdleLimbTable(pc,d3.w)
; ---------------------------------------------------------------------------
SKRibot_IdleLimbTable:
                dc.w    SKRibot_SelectVerticalLimbBit-SKRibot_IdleLimbTable
                dc.w    SKRibot_SelectHorizontalLimbSpeed-SKRibot_IdleLimbTable
                dc.w    SKRibot_StepLimbOrbit-SKRibot_IdleLimbTable
; ---------------------------------------------------------------------------

SKRibot_SelectVerticalLimbBit:
                moveq   #0,d0
                tst.b   subtype(a0)
                bne.s   SKRibot_TryActivateVerticalLimb
                moveq   #1,d0

SKRibot_TryActivateVerticalLimb:
                btst    d0,$38(a1)
                bne.s   SKRibot_BeginVerticalMotion
                rts
; ---------------------------------------------------------------------------

SKRibot_BeginVerticalMotion:
                move.b  #4,routine(a0)
                move.l  #SKRibot_TryBounceVerticalLimb,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKRibot_SelectHorizontalLimbSpeed:
                moveq   #0,d0
                move.w  #$400,d1
                tst.b   subtype(a0)
                bne.s   SKRibot_TryActivateHorizontalLimb
                moveq   #1,d0
                neg.w   d1

SKRibot_TryActivateHorizontalLimb:
                btst    d0,$38(a1)
                bne.s   SKRibot_BeginOutwardMotion
                rts
; ---------------------------------------------------------------------------

SKRibot_BeginOutwardMotion:
                move.b  #4,routine(a0)
                move.w  d1,x_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #SKRibot_BeginLimbPause,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKRibot_StepLimbOrbit:
                addq.b  #2,$3C(a0)
                moveq   #2,d2
                jmp     MoveSprite_CircularSimpleOffset(pc)
; ---------------------------------------------------------------------------

SKRibot_DispatchActiveLimb:
                move.w  SKRibot_ActiveLimbTable(pc,d2.w),d3
                jmp     SKRibot_ActiveLimbTable(pc,d3.w)
; ---------------------------------------------------------------------------
SKRibot_ActiveLimbTable:
                dc.w    SKRibot_TryFallAndCheckFloor-SKRibot_ActiveLimbTable
                dc.w    SKRibot_MoveLimbOutward-SKRibot_ActiveLimbTable
                dc.w    SKRibot_TryFallAndCheckFloor-SKRibot_ActiveLimbTable
; ---------------------------------------------------------------------------

SKRibot_TryFallAndCheckFloor:
                move.w  y_pos(a0),d0
                sub.w   $40(a0),d0
                cmpi.w  #$80,d0
                bhs.s   SKRibot_BeginLimbPause
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   SKRibot_LimbMotionReturn
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

SKRibot_TryBounceVerticalLimb:
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                blo.s   SKRibot_BeginLimbPause
                asr.w   #2,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKRibot_BeginLimbPause:
                move.b  #6,routine(a0)
                move.w  #$10,$2E(a0)
                move.l  #SKRibot_BeginLimbReturn,$34(a0)
                clr.w   y_vel(a0)

SKRibot_LimbMotionReturn:
                rts
; ---------------------------------------------------------------------------

SKRibot_MoveLimbOutward:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKRibot_DispatchPausedLimb:
                move.w  RibotSK_Limb_ThreeAliasedPauseOffsets(pc,d2.w),d3
                jmp     RibotSK_Limb_ThreeAliasedPauseOffsets(pc,d3.w)
; ---------------------------------------------------------------------------
RibotSK_Limb_ThreeAliasedPauseOffsets:
                dc.w    RibotSK_Limb_CountSeventeenCallPause-RibotSK_Limb_ThreeAliasedPauseOffsets
                dc.w    RibotSK_Limb_CountSeventeenCallPause-RibotSK_Limb_ThreeAliasedPauseOffsets
                dc.w    RibotSK_Limb_CountSeventeenCallPause-RibotSK_Limb_ThreeAliasedPauseOffsets
; ---------------------------------------------------------------------------

RibotSK_Limb_CountSeventeenCallPause:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKRibot_BeginLimbReturn:
                move.b  #8,routine(a0)
                neg.w   x_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #SKRibot_ResetLimbAndSignalRoot,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKRibot_DispatchReturningLimb:
                move.w  SKRibot_ReturningLimbTable(pc,d2.w),d3
                jmp     SKRibot_ReturningLimbTable(pc,d3.w)
; ---------------------------------------------------------------------------
SKRibot_ReturningLimbTable:
                dc.w    SKRibot_RaiseLimbTowardAnchor-SKRibot_ReturningLimbTable
                dc.w    SKRibot_MoveLimbBack-SKRibot_ReturningLimbTable
                dc.w    SKRibot_RaiseLimbTowardAnchor-SKRibot_ReturningLimbTable
; ---------------------------------------------------------------------------

SKRibot_RaiseLimbTowardAnchor:
                move.w  y_pos(a0),d0
                subq.w  #2,d0
                cmp.w   $40(a0),d0
                bls.s   SKRibot_ResetLimbAndSignalRoot
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKRibot_ResetLimbAndSignalRoot:
                move.b  #2,routine(a0)
                move.w  $3E(a0),x_pos(a0)
                move.w  $40(a0),y_pos(a0)
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                rts
; ---------------------------------------------------------------------------

SKRibot_MoveLimbBack:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKRibot_InitLinkAndSaveAnchor:
                lea     SKRibot_LinkAttrs(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKRibot_UpdateLinkPosition,(a0)
                move.w  x_pos(a0),$3E(a0)
                move.w  y_pos(a0),$40(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

SKRibot_UpdateLinkPosition:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                sub.w   $3E(a0),d2
                sub.w   $40(a0),d3
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SKRibot_LinkPositionTable(pc,d0.w),d1
                jsr     SKRibot_LinkPositionTable(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
SKRibot_LinkPositionTable:
                dc.w    SKRibot_PlaceLinkNearLimb-SKRibot_LinkPositionTable
                dc.w    SKRibot_PlaceLinkAtHalf-SKRibot_LinkPositionTable
                dc.w    SKRibot_PlaceLinkAtQuarter-SKRibot_LinkPositionTable
; ---------------------------------------------------------------------------

; Subtract an arithmetic quarter of the displacement from the parent position
SKRibot_PlaceLinkNearLimb:
                asr.w   #2,d2
                neg.w   d2
                add.w   x_pos(a1),d2
                move.w  d2,x_pos(a0)
                asr.w   #2,d3
                neg.w   d3
                add.w   y_pos(a1),d3
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKRibot_PlaceLinkAtHalf:
                asr.w   #1,d2
                add.w   $3E(a0),d2
                move.w  d2,x_pos(a0)
                asr.w   #1,d3
                add.w   $40(a0),d3
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKRibot_PlaceLinkAtQuarter:
                asr.w   #2,d2
                add.w   $3E(a0),d2
                move.w  d2,x_pos(a0)
                asr.w   #2,d3
                add.w   $40(a0),d3
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKRibot_SelectLimbLinkRecord:
                movea.w parent3(a0),a1
                move.b  subtype(a1),d0
                subq.b  #2,d0
                beq.s   SKRibot_SelectHorizontalLinkSide
                bpl.s   SKRibot_SpawnOrbitLinks
                lea     SKRibot_VerticalLinkChildren(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

SKRibot_SelectHorizontalLinkSide:
                lea     SKRibot_RightOffsetLinkChildren(pc),a2
                tst.b   subtype(a0)
                beq.s   SKRibot_SpawnLimbLinks
                lea     SKRibot_LeftOffsetLinkChildren(pc),a2

SKRibot_SpawnLimbLinks:
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

SKRibot_SpawnOrbitLinks:
                lea     SKRibot_OrbitLinkChildren(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------
ObjDat_Ribot:
                dc.l    Map_Ribot
                dc.w    make_art_tile(ArtTile_Ribot,1,0)
                dc.w    $280
                dc.b    $10,  $C,   0,  $B
SKRibot_LimbAttrs:
                dc.w    $200
                dc.b    8,   8,   7, $97
SKRibot_LinkAttrs:
                dc.w    $200
                dc.b    4,   4,   6,   0
SKRibot_DownwardLimbChildren:
                dc.w    2-1
                dc.l    SKRibot_UpdateLimbAndDraw
                dc.b    -$C,  $C
                dc.l    SKRibot_UpdateLimbAndDraw
                dc.b    $C,  $C
RibotSK_Root_TwoLateralNormalLimbRecords:
                dc.w    2-1
                dc.l    SKRibot_UpdateLimbAndDraw
                dc.b    -$18,   0
                dc.l    SKRibot_UpdateLimbAndDraw
                dc.b    $18,   0
RibotSK_Root_OneUpperNormalLimbRecord:
                dc.w    1-1
                dc.l    SKRibot_UpdateLimbAndDraw
                dc.b    0,-$10
SKRibot_VerticalLinkChildren:
                dc.w    3-1
                dc.l    SKRibot_InitLinkAndSaveAnchor
                dc.b    0, -$C
SKRibot_RightOffsetLinkChildren:
                dc.w    3-1
                dc.l    SKRibot_InitLinkAndSaveAnchor
                dc.b    $C,   0
SKRibot_LeftOffsetLinkChildren:
                dc.w    3-1
                dc.l    SKRibot_InitLinkAndSaveAnchor
                dc.b    -$C,   0
SKRibot_OrbitLinkChildren:
                dc.w    3-1
                dc.l    SKRibot_InitLinkAndSaveAnchor
                dc.b    0,   0
RibotSK_Root_UniformFrameZeroOneTwoLoop:
                dc.b    7,   0,   1,   2,   1, $FC
SKRibot_UpperLimbBodyAnim:
                dc.b    7,   3,   4,   5,   4, $FC
                even
