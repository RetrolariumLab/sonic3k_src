; Owner: objects/zones/lrz/sk
; Responsibility: Lava Reef rock crusher mechanism, player collision, fragments, movement helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZRockCrusher:
                lea     SKLRZCrusher_FirstCameraGate(pc),a1
                tst.b   subtype(a0)
                beq.s   SKLRZCrusher_CheckCameraAndSaveBounds
                lea     SKLRZCrusher_SecondCameraGate(pc),a1

SKLRZCrusher_CheckCameraAndSaveBounds:
                jsr     (Check_CameraInRange).l
                move.l  #SKLRZCrusher_DispatchRootAndDraw,(a0)
                move.w  (Camera_min_Y_pos).w,(Camera_stored_min_Y_pos).w
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  (Camera_min_X_pos).w,(Camera_stored_min_X_pos).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  (a1),$1C(a0)
                move.w  (a1)+,(Camera_max_X_pos).w
                move.w  (a1)+,(Camera_target_max_Y_pos).w
                lea     ObjDat_LRZRockCrusher(pc),a1
                jsr     (SetUp_ObjAttributes).l
                clr.b   routine(a0)
                move.b  #-1,collision_property(a0)
                move.b  #$40,y_radius(a0)
                tst.b   subtype(a0)
                beq.s   SKLRZCrusher_TrySpawnSpriteMask
                bset    #7,art_tile(a0)

SKLRZCrusher_TrySpawnSpriteMask:
                lea     SKLRZCrusher_SpriteMaskChild(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   SKLRZCrusher_LoadArtAndSpawnMechanism
                move.b  #$8B,subtype(a1)
                tst.b   subtype(a0)
                bne.s   SKLRZCrusher_PlaceSecondEncounterMask
                move.w  #$F40,x_pos(a1)
                move.w  #$760,y_pos(a1)
                bra.w   SKLRZCrusher_LoadArtAndSpawnMechanism
; ---------------------------------------------------------------------------

SKLRZCrusher_PlaceSecondEncounterMask:
                move.w  #$540,x_pos(a1)
                move.w  #$860,y_pos(a1)

SKLRZCrusher_LoadArtAndSpawnMechanism:
                lea     (ArtKosM_LRZRockCrusher).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZRockCrusher),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_BossExplosion).l,a1
                jsr     (Load_PLC_Raw).l
                lea     Pal_LRZRockCrusher(pc),a1
                jsr     (PalLoad_Line1).l
                lea     SKLRZCrusher_MechanismChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
SKLRZCrusher_FirstCameraGate:
                dc.w    $5E0,  $740,  $DC0,  $EC0,  $EA0,  $6A0
SKLRZCrusher_SecondCameraGate:
                dc.w    $680,  $880,  $400,  $780,  $4A0,  $790
; ---------------------------------------------------------------------------

SKLRZCrusher_DispatchRootAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKLRZCrusher_RootStateOffsets(pc,d0.w),d1
                jsr     SKLRZCrusher_RootStateOffsets(pc,d1.w)
                jsr     (UpdateLrzCrusherHitFlash).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
SKLRZCrusher_RootStateOffsets:
                dc.w    SKLRZCrusher_TryLockCameraY-SKLRZCrusher_RootStateOffsets
                dc.w    SKLRZCrusher_RumbleAndSelectJitter-SKLRZCrusher_RootStateOffsets
                dc.w    SKLRZCrusher_TickDropDelay-SKLRZCrusher_RootStateOffsets
                dc.w    SKLRZCrusher_FallAndCheckDropDepth-SKLRZCrusher_RootStateOffsets
                dc.w    SKLRZCrusher_TrySignalDefeat-SKLRZCrusher_RootStateOffsets
; ---------------------------------------------------------------------------

SKLRZCrusher_TryLockCameraY:
                btst    #0,$27(a0)
                bne.s   SKLRZCrusher_TryLockCameraX
                move.w  (Camera_target_max_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                bne.s   SKLRZCrusher_TryLockCameraX
                move.w  d0,(Camera_min_Y_pos).w
                bset    #0,$27(a0)

SKLRZCrusher_TryLockCameraX:
                btst    #1,$27(a0)
                bne.s   SKLRZCrusher_TryBeginShakeAndRelay
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                move.w  $1C(a0),d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   SKLRZCrusher_TryBeginShakeAndRelay
                bset    #1,$27(a0)

SKLRZCrusher_TryBeginShakeAndRelay:
                move.b  $27(a0),d0
                andi.b  #3,d0
                cmpi.b  #3,d0
                bne.s   SKLRZCrusher_WaitReturn
                move.b  #2,routine(a0)
                clr.b   $27(a0)
                clr.w   $1C(a0)
                clr.b   $26(a0)
                bset    #2,$38(a0)
                jsr     (AllocateObject).l
                bne.s   SKLRZCrusher_WaitReturn
                move.l  #SKLRZCrusher_InitSceneRelay,(a1)
                move.b  subtype(a0),subtype(a1)
                move.w  a0,parent3(a1)

SKLRZCrusher_WaitReturn:
                rts
; ---------------------------------------------------------------------------

SKLRZCrusher_RumbleAndSelectJitter:
                moveq   #signextendB(sfx_BigRumble),d0
                jsr     (Play_SFX_Continuous).l
                moveq   #1,d0
                bchg    #0,$38(a0)
                beq.s   SKLRZCrusher_JitterAndCheckExit
                neg.w   d0

SKLRZCrusher_JitterAndCheckExit:
                add.w   d0,y_pos(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKLRZCrusher_StopPartsAndArmDrop
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   SKLRZCrusher_AbortOffscreen
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmpi.w  #$200,d0
                bls.w   SKLRZCrusher_WaitReturn

SKLRZCrusher_AbortOffscreen:
                clr.b   (Screen_shake_flag).w
                bra.w   SKLRZCrusher_RestoreLevelArtAndDelete
; ---------------------------------------------------------------------------

SKLRZCrusher_StopPartsAndArmDrop:
                move.b  #4,routine(a0)
                ori.b   #$28,$38(a0)
                move.w  #$27,$2E(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SKLRZCrusher_DropDepths(pc,d0.w),$3A(a0)
                move.w  (Camera_stored_max_Y_pos).w,(Camera_target_max_Y_pos).w
                lea     Child7_ChangeLevSize(pc),a2
                jmp     (CreateChild7_Normal2).l
; ---------------------------------------------------------------------------
SKLRZCrusher_DropDepths:
                dc.w    $850
                dc.w    $950
; ---------------------------------------------------------------------------

SKLRZCrusher_TickDropDelay:
                subq.w  #1,$2E(a0)
                bpl.s   SKLRZCrusher_DropDelayReturn
                move.b  #6,routine(a0)

SKLRZCrusher_DropDelayReturn:
                rts
; ---------------------------------------------------------------------------

SKLRZCrusher_FallAndCheckDropDepth:
                jsr     (MoveSprite).l
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                bhs.s   SKLRZCrusher_BeginDescentAndExplosion
                rts
; ---------------------------------------------------------------------------

SKLRZCrusher_BeginDescentAndExplosion:
                move.b  #8,routine(a0)
                move.w  #$40,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #SKLRZCrusher_BeginPostDescentWait,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                rts
; ---------------------------------------------------------------------------

; Notify the mechanism parts at timer $40 while the root continues descending
SKLRZCrusher_TrySignalDefeat:
                cmpi.w  #$40,$2E(a0)
                bne.s   SKLRZCrusher_DescendAndTickWait
                bset    #7,status(a0)

SKLRZCrusher_DescendAndTickWait:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKLRZCrusher_BeginPostDescentWait:
                move.l  #Obj_Wait,(a0)
                move.w  #$BF,$2E(a0)
                move.l  #SKLRZCrusher_RestoreLevelArtAndDelete,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKLRZCrusher_RestoreLevelArtAndDelete:
                lea     (ArtKosM_FirewormSegments).l,a1
                move.w  #tiles_to_bytes(ArtTile_FirewormSegments),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_Iwamodoki).l,a1
                move.w  #tiles_to_bytes(ArtTile_Iwamodoki),d2
                jsr     (Queue_Kos_Module).l
                lea     (Pal_LRZ1).l,a1
                jsr     (PalLoad_Line1).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SKLRZCrusher_DispatchMechanismPart:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKLRZCrusher_PartStateOffsets(pc,d0.w),d1
                jsr     SKLRZCrusher_PartStateOffsets(pc,d1.w)
                cmpi.b  #8,subtype(a0)
                blo.s   SKLRZCrusher_DrawOrBreakAwayPart
                move.b  #-1,collision_property(a0)
                bsr.w   UpdateLrzCrusherHitFlash

SKLRZCrusher_DrawOrBreakAwayPart:
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
SKLRZCrusher_PartStateOffsets:
                dc.w    SKLRZCrusher_InitMechanismPart-SKLRZCrusher_PartStateOffsets
                dc.w    SKLRZCrusher_WaitForParentActivation-SKLRZCrusher_PartStateOffsets
                dc.w    SKLRZCrusher_TickRestOrFollowParent-SKLRZCrusher_PartStateOffsets
                dc.w    SKLRZCrusher_MovePartAndTickPulse-SKLRZCrusher_PartStateOffsets
                dc.w    SKLRZCrusher_FollowParentAfterStop-SKLRZCrusher_PartStateOffsets
; ---------------------------------------------------------------------------

SKLRZCrusher_InitMechanismPart:
                lea     SKLRZCrusher_PartAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  subtype(a0),d0
                cmpi.b  #8,d0
                blo.s   SKLRZCrusher_InitPartDelay
                move.b  #2,mapping_frame(a0)
                move.b  #$12,collision_flags(a0)

SKLRZCrusher_InitPartDelay:
                andi.b  #4,d0
                move.b  d0,$2E(a0)

SKLRZCrusher_WaitForParentActivation:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.w   SKLRZCrusher_WaitReturn
                move.b  #4,routine(a0)

SKLRZCrusher_TickRestOrFollowParent:
                subq.b  #1,$2E(a0)
                bmi.s   SKLRZCrusher_BeginPartPulse
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   SKLRZCrusher_FollowParentAtRest
                move.b  #8,routine(a0)

SKLRZCrusher_FollowParentAtRest:
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

SKLRZCrusher_BeginPartPulse:
                move.b  #6,routine(a0)
                move.b  #2,$39(a0)
                clr.b   $40(a0)

SKLRZCrusher_MovePartAndTickPulse:
                move.b  $40(a0),d0
                add.b   d0,$43(a0)
                subq.b  #1,$2E(a0)
                bpl.s   SKLRZCrusher_FollowParentAfterPulse
                subq.b  #1,$39(a0)
                bmi.s   SKLRZCrusher_ResetPartRestDelay
                move.b  subtype(a0),d3
                andi.w  #8,d3
                bne.s   SKLRZCrusher_SelectPulseBankAndPhase
                btst    #2,$38(a0)
                beq.s   SKLRZCrusher_SelectPulseBankAndPhase
                bchg    #1,$38(a0)
                bne.s   SKLRZCrusher_SelectPulseBankAndPhase
                lea     SKLRZCrusher_DebrisChildren(pc),a2
                jsr     (CreateChild3_NormalRepeated).l

SKLRZCrusher_SelectPulseBankAndPhase:
                lsr.w   #1,d3
                moveq   #0,d1
                bchg    #2,$38(a0)
                beq.s   SKLRZCrusher_LoadPulseDelayAndStep
                moveq   #2,d1

SKLRZCrusher_LoadPulseDelayAndStep:
                add.w   d1,d3
                lea     SKLRZCrusher_PartPulsePairs(pc,d3.w),a1
                move.b  (a1)+,$2E(a0)
                move.b  (a1)+,$40(a0)

SKLRZCrusher_FollowParentAfterPulse:
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

SKLRZCrusher_ResetPartRestDelay:
                move.b  #4,routine(a0)
                move.b  subtype(a0),d0
                andi.b  #8,d0
                lsr.b   #1,d0
                addq.b  #4,d0
                move.b  d0,$2E(a0)
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------
SKLRZCrusher_PartPulsePairs:
                dc.b    1,   8
                dc.b    3,  -4
                dc.b    3,  -4
                dc.b    7,   2
                even
; ---------------------------------------------------------------------------

SKLRZCrusher_FollowParentAfterStop:
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

SKLRZCrusher_InitDebris:
                lea     SKLRZCrusher_DebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKLRZSpikeBall_UpdateVisibleDebris,(a0)
                bset    #7,render_flags(a0)
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                move.w  #$200,d1
                tst.b   subtype(a0)
                beq.s   SKLRZCrusher_StoreRandomDebrisSpeed
                neg.w   d0
                neg.w   d1

SKLRZCrusher_StoreRandomDebrisSpeed:
                add.w   d1,d0
                move.w  d0,x_vel(a0)
                swap    d0
                andi.w  #$1FF,d0
                move.w  #$300,d1
                add.w   d1,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKLRZCrusher_InitSceneRelay:
                move.l  #SKLRZCrusher_TickRelayAndSelectScene,(a0)
                move.w  #(3*60)-1,$2E(a0)
                st      (Screen_shake_flag).w

SKLRZCrusher_TickRelayAndSelectScene:
                subq.w  #1,$2E(a0)
                bpl.w   SKLRZCrusher_WaitReturn
                tst.b   subtype(a0)
                bne.s   SKLRZCrusher_SignalSecondSceneAndBridge
                st      (Events_bg+$0C).w
                clr.b   (Screen_shake_flag).w
                jsr     (AllocateObject).l
                bne.s   SKLRZCrusher_TrySecondBridge
                move.l  #Obj_LRZCollapsingBridge,(a1)
                move.b  #1,$32(a1)
                move.w  #$F00,x_pos(a1)
                move.w  #$760,y_pos(a1)

; Attempt the second bridge even if allocating the first failed
SKLRZCrusher_TrySecondBridge:
                jsr     (AllocateObject).l
                bne.s   SKLRZCrusher_DeleteSceneRelay
                move.l  #Obj_LRZCollapsingBridge,(a1)
                move.b  #1,$32(a1)
                move.w  #$F80,x_pos(a1)
                move.w  #$760,y_pos(a1)

SKLRZCrusher_DeleteSceneRelay:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKLRZCrusher_SignalSecondSceneAndBridge:
                st      (Events_bg+$0D).w
                jsr     (AllocateObject).l
                bne.s   SKLRZCrusher_RestoreCameraAndDeleteRelay
                move.l  #Obj_LRZCollapsingBridge,(a1)
                move.b  #1,$32(a1)
                move.w  #$540,x_pos(a1)
                move.w  #$860,y_pos(a1)

SKLRZCrusher_RestoreCameraAndDeleteRelay:
                move.w  (Camera_stored_max_Y_pos).w,(Camera_target_max_Y_pos).w
                lea     Child7_ChangeLevSize(pc),a2
                jsr     (CreateChild7_Normal2).l
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

UpdateLrzCrusherHitFlash:
                tst.b   collision_flags(a0)
                bne.s   SKLRZCrusher_HitFlashReturn
                tst.b   $20(a0)
                bne.s   SKLRZCrusher_SelectFlashColors
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                move.b  #-1,collision_property(a0)

SKLRZCrusher_SelectFlashColors:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   SKLRZCrusher_WriteFlashAndTick
                addi.w  #2*3,d0

SKLRZCrusher_WriteFlashAndTick:
                bsr.w   WriteLrzCrusherHitPalette
                subq.b  #1,$20(a0)
                bne.s   SKLRZCrusher_HitFlashReturn
                move.b  $25(a0),collision_flags(a0)

SKLRZCrusher_HitFlashReturn:
                rts
; End of function UpdateLrzCrusherHitFlash

; =============== S U B R O U T I N E =======================================

WriteLrzCrusherHitPalette:
                lea     SKLRZCrusher_FlashPaletteDestinations(pc),a1
                lea     SKLRZCrusher_FlashColorBanks(pc,d0.w),a2
                jmp     (CopyWordData_3).l
; End of function WriteLrzCrusherHitPalette

; ---------------------------------------------------------------------------
SKLRZCrusher_FlashPaletteDestinations:
                dc.w    Normal_palette_line_2+$16, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
SKLRZCrusher_FlashColorBanks:
                dc.w    $20,  $866,  $644
                dc.w    $EEE,  $AAA,  $CCC
ObjDat_LRZRockCrusher:
                dc.l    Map_LRZRockCrusher
                dc.w    make_art_tile(ArtTile_LRZRockCrusher,1,0)
                dc.w    $180
                dc.b    $80, $40,   0, $10
SKLRZCrusher_PartAttributes:
                dc.w    $200
                dc.b    $C, $14,   1, $8B
SKLRZCrusher_DebrisAttributes:
                dc.l    Map_LRZRockDebris
                dc.w    make_art_tile($0D3,2,1)
                dc.w    0
                dc.b    4,   4,   0,   0
SKLRZCrusher_MechanismChildren:
                dc.w    8-1
                dc.l    SKLRZCrusher_DispatchMechanismPart
                dc.b    -$1C, $1C
                dc.l    SKLRZCrusher_DispatchMechanismPart
                dc.b    $1C, $1C
                dc.l    SKLRZCrusher_DispatchMechanismPart
                dc.b    -$24, $1C
                dc.l    SKLRZCrusher_DispatchMechanismPart
                dc.b    $24, $1C
                dc.l    SKLRZCrusher_DispatchMechanismPart
                dc.b    -$1C,-$24
                dc.l    SKLRZCrusher_DispatchMechanismPart
                dc.b    $1C,-$24
                dc.l    SKLRZCrusher_DispatchMechanismPart
                dc.b    -$24,-$24
                dc.l    SKLRZCrusher_DispatchMechanismPart
                dc.b    $24,-$24
SKLRZCrusher_DebrisChildren:
                dc.w    2-1
                dc.l    SKLRZCrusher_InitDebris
                dc.b    0,  $C
Child7_ChangeLevSize:
                dc.w    4-1
                dc.l    Obj_DecLevStartYGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndYGradual
                dc.b    0,   0
                dc.l    Obj_DecLevStartXGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndXGradual
                dc.b    0,   0
SKLRZCrusher_SpriteMaskChild:
                dc.w    1-1
                dc.l    Obj_SpriteMask
Pal_LRZRockCrusher:
                binclude "data/Levels/LRZ/Palettes/Rock Crusher.bin"
                even
