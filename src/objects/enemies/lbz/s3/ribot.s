; Owner: objects/enemies/lbz/s3
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
                dc.w    S3Ribot_InitAndSelectLimbs-Ribot_Index
                dc.w    S3Ribot_AlternateActiveLimb-Ribot_Index
; ---------------------------------------------------------------------------

S3Ribot_InitAndSelectLimbs:
                lea     ObjDat_Ribot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bset    #2,$38(a0)
                move.b  subtype(a0),d0
                subq.b  #2,d0
                beq.s   S3Ribot_SpawnHorizontalLimbs
                bpl.s   S3Ribot_SpawnUpperLimb
                move.l  #RibotS3_Root_UniformFrameZeroOneTwoLoop,$30(a0)
                lea     S3Ribot_DownwardLimbChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

S3Ribot_SpawnHorizontalLimbs:
                move.l  #RibotS3_Root_UniformFrameZeroOneTwoLoop,$30(a0)
                lea     RibotS3_Root_TwoLateralNormalLimbRecords(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

S3Ribot_SpawnUpperLimb:
                move.l  #S3Ribot_UpperLimbBodyAnim,$30(a0)
                lea     RibotS3_Root_OneUpperNormalLimbRecord(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

S3Ribot_AlternateActiveLimb:
                bclr    #2,$38(a0)
                beq.s   RibotS3_Root_DecodeBodyUniformLoop
                andi.b  #$FC,$38(a0)
                moveq   #0,d0
                bchg    #3,$38(a0)
                beq.s   S3Ribot_ActivateSelectedLimb
                moveq   #1,d0

S3Ribot_ActivateSelectedLimb:
                bset    d0,$38(a0)

RibotS3_Root_DecodeBodyUniformLoop:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

S3Ribot_UpdateLimbAndDraw:
                moveq   #0,d2
                movea.w parent3(a0),a1
                move.b  subtype(a1),d2
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  RibotS3_Limb_FiveRelativeStateOffsets(pc,d0.w),d1
                jsr     RibotS3_Limb_FiveRelativeStateOffsets(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
RibotS3_Limb_FiveRelativeStateOffsets:
                dc.w    S3Ribot_InitLimbAndSpawnLinks-RibotS3_Limb_FiveRelativeStateOffsets
                dc.w    S3Ribot_DispatchIdleLimb-RibotS3_Limb_FiveRelativeStateOffsets
                dc.w    S3Ribot_DispatchActiveLimb-RibotS3_Limb_FiveRelativeStateOffsets
                dc.w    S3Ribot_DispatchPausedLimb-RibotS3_Limb_FiveRelativeStateOffsets
                dc.w    S3Ribot_DispatchReturningLimb-RibotS3_Limb_FiveRelativeStateOffsets
; ---------------------------------------------------------------------------

S3Ribot_InitLimbAndSpawnLinks:
                lea     S3Ribot_LimbAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.b  #8,y_radius(a0)
                move.b  #-$10,child_dy(a0)
                move.w  x_pos(a0),$3E(a0)
                move.w  y_pos(a0),$40(a0)
                bra.w   S3Ribot_SelectLimbLinkRecord
; ---------------------------------------------------------------------------

S3Ribot_DispatchIdleLimb:
                move.w  S3Ribot_IdleLimbTable(pc,d2.w),d3
                jmp     S3Ribot_IdleLimbTable(pc,d3.w)
; ---------------------------------------------------------------------------
S3Ribot_IdleLimbTable:
                dc.w    S3Ribot_SelectVerticalLimbBit-S3Ribot_IdleLimbTable
                dc.w    S3Ribot_SelectHorizontalLimbSpeed-S3Ribot_IdleLimbTable
                dc.w    S3Ribot_StepLimbOrbit-S3Ribot_IdleLimbTable
; ---------------------------------------------------------------------------

S3Ribot_SelectVerticalLimbBit:
                moveq   #0,d0
                tst.b   subtype(a0)
                bne.s   S3Ribot_TryActivateVerticalLimb
                moveq   #1,d0

S3Ribot_TryActivateVerticalLimb:
                btst    d0,$38(a1)
                bne.s   S3Ribot_BeginVerticalMotion
                rts
; ---------------------------------------------------------------------------

S3Ribot_BeginVerticalMotion:
                move.b  #4,routine(a0)
                move.l  #S3Ribot_TryBounceVerticalLimb,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Ribot_SelectHorizontalLimbSpeed:
                moveq   #0,d0
                move.w  #$400,d1
                tst.b   subtype(a0)
                bne.s   S3Ribot_TryActivateHorizontalLimb
                moveq   #1,d0
                neg.w   d1

S3Ribot_TryActivateHorizontalLimb:
                btst    d0,$38(a1)
                bne.s   S3Ribot_BeginOutwardMotion
                rts
; ---------------------------------------------------------------------------

S3Ribot_BeginOutwardMotion:
                move.b  #4,routine(a0)
                move.w  d1,x_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #S3Ribot_BeginLimbPause,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Ribot_StepLimbOrbit:
                addq.b  #2,$3C(a0)
                moveq   #2,d2
                jmp     MoveSprite_CircularSimpleOffset(pc)
; ---------------------------------------------------------------------------

S3Ribot_DispatchActiveLimb:
                move.w  S3Ribot_ActiveLimbTable(pc,d2.w),d3
                jmp     S3Ribot_ActiveLimbTable(pc,d3.w)
; ---------------------------------------------------------------------------
S3Ribot_ActiveLimbTable:
                dc.w    S3Ribot_TryFallAndCheckFloor-S3Ribot_ActiveLimbTable
                dc.w    S3Ribot_MoveLimbOutward-S3Ribot_ActiveLimbTable
                dc.w    S3Ribot_TryFallAndCheckFloor-S3Ribot_ActiveLimbTable
; ---------------------------------------------------------------------------

S3Ribot_TryFallAndCheckFloor:
                move.w  y_pos(a0),d0
                sub.w   $40(a0),d0
                cmpi.w  #$80,d0
                bhs.s   S3Ribot_BeginLimbPause
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   S3Ribot_LimbMotionReturn
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

S3Ribot_TryBounceVerticalLimb:
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                blo.s   S3Ribot_BeginLimbPause
                asr.w   #2,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3Ribot_BeginLimbPause:
                move.b  #6,routine(a0)
                move.w  #$10,$2E(a0)
                move.l  #S3Ribot_BeginLimbReturn,$34(a0)
                clr.w   y_vel(a0)

S3Ribot_LimbMotionReturn:
                rts
; ---------------------------------------------------------------------------

S3Ribot_MoveLimbOutward:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3Ribot_DispatchPausedLimb:
                move.w  RibotS3_Limb_ThreeAliasedPauseOffsets(pc,d2.w),d3
                jmp     RibotS3_Limb_ThreeAliasedPauseOffsets(pc,d3.w)
; ---------------------------------------------------------------------------
RibotS3_Limb_ThreeAliasedPauseOffsets:
                dc.w    RibotS3_Limb_CountSeventeenCallPause-RibotS3_Limb_ThreeAliasedPauseOffsets
                dc.w    RibotS3_Limb_CountSeventeenCallPause-RibotS3_Limb_ThreeAliasedPauseOffsets
                dc.w    RibotS3_Limb_CountSeventeenCallPause-RibotS3_Limb_ThreeAliasedPauseOffsets
; ---------------------------------------------------------------------------

RibotS3_Limb_CountSeventeenCallPause:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3Ribot_BeginLimbReturn:
                move.b  #8,routine(a0)
                neg.w   x_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #S3Ribot_ResetLimbAndSignalRoot,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Ribot_DispatchReturningLimb:
                move.w  S3Ribot_ReturningLimbTable(pc,d2.w),d3
                jmp     S3Ribot_ReturningLimbTable(pc,d3.w)
; ---------------------------------------------------------------------------
S3Ribot_ReturningLimbTable:
                dc.w    S3Ribot_RaiseLimbTowardAnchor-S3Ribot_ReturningLimbTable
                dc.w    S3Ribot_MoveLimbBack-S3Ribot_ReturningLimbTable
                dc.w    S3Ribot_RaiseLimbTowardAnchor-S3Ribot_ReturningLimbTable
; ---------------------------------------------------------------------------

S3Ribot_RaiseLimbTowardAnchor:
                move.w  y_pos(a0),d0
                subq.w  #2,d0
                cmp.w   $40(a0),d0
                bls.s   S3Ribot_ResetLimbAndSignalRoot
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3Ribot_ResetLimbAndSignalRoot:
                move.b  #2,routine(a0)
                move.w  $3E(a0),x_pos(a0)
                move.w  $40(a0),y_pos(a0)
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                rts
; ---------------------------------------------------------------------------

S3Ribot_MoveLimbBack:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3Ribot_InitLinkAndSaveAnchor:
                lea     S3Ribot_LinkAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #S3Ribot_UpdateLinkPosition,(a0)
                move.w  x_pos(a0),$3E(a0)
                move.w  y_pos(a0),$40(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

S3Ribot_UpdateLinkPosition:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                sub.w   $3E(a0),d2
                sub.w   $40(a0),d3
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  S3Ribot_LinkPositionTable(pc,d0.w),d1
                jsr     S3Ribot_LinkPositionTable(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
S3Ribot_LinkPositionTable:
                dc.w    S3Ribot_PlaceLinkNearLimb-S3Ribot_LinkPositionTable
                dc.w    S3Ribot_PlaceLinkAtHalf-S3Ribot_LinkPositionTable
                dc.w    S3Ribot_PlaceLinkAtQuarter-S3Ribot_LinkPositionTable
; ---------------------------------------------------------------------------

; Subtract an arithmetic quarter of the displacement from the parent position
S3Ribot_PlaceLinkNearLimb:
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

S3Ribot_PlaceLinkAtHalf:
                asr.w   #1,d2
                add.w   $3E(a0),d2
                move.w  d2,x_pos(a0)
                asr.w   #1,d3
                add.w   $40(a0),d3
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3Ribot_PlaceLinkAtQuarter:
                asr.w   #2,d2
                add.w   $3E(a0),d2
                move.w  d2,x_pos(a0)
                asr.w   #2,d3
                add.w   $40(a0),d3
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3Ribot_SelectLimbLinkRecord:
                movea.w parent3(a0),a1
                move.b  subtype(a1),d0
                subq.b  #2,d0
                beq.s   S3Ribot_SelectHorizontalLinkSide
                bpl.s   S3Ribot_SpawnOrbitLinks
                lea     S3Ribot_VerticalLinkChildren(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

S3Ribot_SelectHorizontalLinkSide:
                lea     S3Ribot_RightOffsetLinkChildren(pc),a2
                tst.b   subtype(a0)
                beq.s   S3Ribot_SpawnLimbLinks
                lea     S3Ribot_LeftOffsetLinkChildren(pc),a2

S3Ribot_SpawnLimbLinks:
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

S3Ribot_SpawnOrbitLinks:
                lea     S3Ribot_OrbitLinkChildren(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------
ObjDat_Ribot:
                dc.l    Map_Ribot
                dc.w    make_art_tile(ArtTile_Ribot,1,0)
                dc.w    $280
                dc.b    $10,  $C,   0,  $B
S3Ribot_LimbAttrs:
                dc.w    $200
                dc.b    8,   8,   7, $97
S3Ribot_LinkAttrs:
                dc.w    $200
                dc.b    4,   4,   6,   0
S3Ribot_DownwardLimbChildren:
                dc.w    2-1
                dc.l    S3Ribot_UpdateLimbAndDraw
                dc.b    -$C,  $C
                dc.l    S3Ribot_UpdateLimbAndDraw
                dc.b    $C,  $C
RibotS3_Root_TwoLateralNormalLimbRecords:
                dc.w    2-1
                dc.l    S3Ribot_UpdateLimbAndDraw
                dc.b    -$18,   0
                dc.l    S3Ribot_UpdateLimbAndDraw
                dc.b    $18,   0
RibotS3_Root_OneUpperNormalLimbRecord:
                dc.w    1-1
                dc.l    S3Ribot_UpdateLimbAndDraw
                dc.b    0,-$10
S3Ribot_VerticalLinkChildren:
                dc.w    3-1
                dc.l    S3Ribot_InitLinkAndSaveAnchor
                dc.b    0, -$C
S3Ribot_RightOffsetLinkChildren:
                dc.w    3-1
                dc.l    S3Ribot_InitLinkAndSaveAnchor
                dc.b    $C,   0
S3Ribot_LeftOffsetLinkChildren:
                dc.w    3-1
                dc.l    S3Ribot_InitLinkAndSaveAnchor
                dc.b    -$C,   0
S3Ribot_OrbitLinkChildren:
                dc.w    3-1
                dc.l    S3Ribot_InitLinkAndSaveAnchor
                dc.b    0,   0
RibotS3_Root_UniformFrameZeroOneTwoLoop:
                dc.b    7,   0,   1,   2,   1, $FC
S3Ribot_UpperLimbBodyAnim:
                dc.b    7,   3,   4,   5,   4, $FC
                even
