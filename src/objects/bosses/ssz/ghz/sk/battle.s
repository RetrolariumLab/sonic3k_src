; Owner: objects/bosses/ssz/ghz/sk
; Responsibility: Sky Sanctuary Green Hill-style boss controller, ball attack, motion helpers and private object resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSZGHZBoss:
                move.l  #Obj_Wait,(a0)
                move.b  #1,(Boss_flag).w
                move.w  #$1F,$2E(a0)
                move.l  #SSZGHZBoss_InstallBattleDispatcher,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                jsr     (AllocateObject).l
                bne.s   SSZGHZBoss_PositionAndQueueArt
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

SSZGHZBoss_PositionAndQueueArt:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$110,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$40,d0
                move.w  d0,y_pos(a0)
                clr.w   (_unkFA88).w
                moveq   #PLCID_7B,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_SSZGHZMisc).l,a1
                move.w  #tiles_to_bytes(ArtTile_SSZGHZMisc),d2
                jsr     (Queue_Kos_Module).l
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

SSZGHZBoss_SavePaletteAndLoadMiscColors:
                move.l  (a1)+,(a2)+
                dbf     d6,SSZGHZBoss_SavePaletteAndLoadMiscColors
                lea     (Pal_SSZGHZMisc).l,a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

SSZGHZBoss_InstallBattleDispatcher:
                move.l  #SSZGHZBoss_DispatchHandleHitsAndDraw,(a0)

SSZGHZ_SharedReturn:
                rts
; ---------------------------------------------------------------------------

SSZGHZBoss_DispatchHandleHitsAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SSZGHZBoss_StateOffsets(pc,d0.w),d1
                jsr     SSZGHZBoss_StateOffsets(pc,d1.w)
                bsr.w   SSZGHZBoss_HandleHitOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
SSZGHZBoss_StateOffsets:
                dc.w    SSZGHZBoss_InitializeShipAndHead-SSZGHZBoss_StateOffsets
                dc.w    SSZGHZBoss_DescendAndWaitForEntryTimer-SSZGHZBoss_StateOffsets
                dc.w    SSZGHZBoss_MoveToChainDeploymentPoint-SSZGHZBoss_StateOffsets
                dc.w    SSZGHZBoss_WaitForLastChainChildSignal-SSZGHZBoss_StateOffsets
                dc.w    SSZGHZBoss_BobMoveAndWaitForPause-SSZGHZBoss_StateOffsets
                dc.w    SSZGHZ_ConsumeTurnAndReverse-SSZGHZBoss_StateOffsets
; ---------------------------------------------------------------------------

SSZGHZBoss_InitializeShipAndHead:
                lea     ObjDat_SSZGHZBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)
                move.w  #$100,y_vel(a0)
                move.w  #$67,$2E(a0)
                move.l  #SSZGHZ_BobLeftAndSpawnContact,$34(a0)
                lea     (Child1_MakeMechaHead).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SSZGHZBoss_DescendAndWaitForEntryTimer:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SSZGHZ_BobLeftAndSpawnContact:
                move.b  #4,routine(a0)
                move.w  #-$100,x_vel(a0)
                lea     SSZGHZShipContactChild_NormalChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                move.w  #$C0,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

SSZGHZBoss_MoveToChainDeploymentPoint:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                cmp.w   x_pos(a0),d0
                blo.s   SSZGHZBoss_ReturnAfterDeploymentCheck
                move.b  #6,routine(a0)
                bset    #6,$38(a0)
                lea     SSZGHZChainAndBall_TreeChildRecords(pc),a2
                jsr     (CreateChild9_TreeList).l

SSZGHZBoss_ReturnAfterDeploymentCheck:
                rts
; ---------------------------------------------------------------------------

SSZGHZBoss_WaitForLastChainChildSignal:
                btst    #2,$38(a0)
                beq.s   SSZGHZBoss_ReturnFromChainDeploymentWait
                move.b  #8,routine(a0)
                bclr    #6,$38(a0)
                move.w  #-$100,x_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #SSZGHZBoss_PauseAndSuppressContactChild,$34(a0)

SSZGHZBoss_ReturnFromChainDeploymentWait:
                rts
; ---------------------------------------------------------------------------

SSZGHZBoss_BobMoveAndWaitForPause:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SSZGHZBoss_PauseAndSuppressContactChild:
                move.b  #$A,routine(a0)
                bset    #6,$38(a0)
                rts
; ---------------------------------------------------------------------------

SSZGHZ_ConsumeTurnAndReverse:
                bclr    #3,$38(a0)
                beq.s   SSZGHZBoss_ReturnFromSwingTurnWait
                move.b  #8,routine(a0)
                bclr    #6,$38(a0)
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  #$3F,$2E(a0)

SSZGHZBoss_ReturnFromSwingTurnWait:
                rts
; ---------------------------------------------------------------------------

SSZGHZBoss_BeginDefeatDeparture:
                move.l  #SSZGHZBoss_MoveAwayUntilExitTimer,(a0)
                bset    #0,render_flags(a0)
                move.w  #$400,x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SSZGHZBoss_MoveAwayUntilExitTimer:
                subq.w  #1,$2E(a0)
                bmi.s   SSZGHZ_FinishEncounterAndRestorePal
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZGHZ_FinishEncounterAndRestorePal:
                clr.b   (Boss_flag).w
                bset    #4,$38(a0)
                st      (_unkFA89).w
                st      (Events_bg+$00).w
                lea     (Target_palette_line_2).w,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

SSZGHZ_RestorePaletteLoadArtDelete:
                move.l  (a1)+,(a2)+
                dbf     d6,SSZGHZ_RestorePaletteLoadArtDelete
                moveq   #PLCID_32,d0
                jsr     (Load_PLC).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SSZGHZ_AnchorDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SSZGHZChainAnchor_StateOffsets(pc,d0.w),d1
                jsr     SSZGHZChainAnchor_StateOffsets(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
SSZGHZChainAnchor_StateOffsets:
                dc.w    SSZGHZChainAnchor_InitializeDropAndSwing-SSZGHZChainAnchor_StateOffsets
                dc.w    SSZGHZ_DropLinksAndSignalLast-SSZGHZChainAnchor_StateOffsets
                dc.w    SSZGHZ_AnchorWaitDeployment-SSZGHZChainAnchor_StateOffsets
                dc.w    SSZGHZ_AnchorSwingAndCheckTurn-SSZGHZChainAnchor_StateOffsets
; ---------------------------------------------------------------------------

SSZGHZChainAnchor_InitializeDropAndSwing:
                lea     SSZGHZChainAnchor_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #$1A,child_dy(a0)
                move.b  #1,$3A(a0)
                bra.w   SeedSSZGHZChainSegmentDropWaitBySubtype
; ---------------------------------------------------------------------------

; Subtype $A signals the boss when its drop timer expires
SSZGHZ_DropLinksAndSignalLast:
                addq.w  #2,y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   SSZGHZChainChildren_ReturnAfterDropStep
                addq.b  #2,routine(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   SSZGHZChainChildren_ReturnAfterDropStep
                movea.w $44(a0),a1
                bset    #2,$38(a1)

SSZGHZChainChildren_ReturnAfterDropStep:
                rts
; ---------------------------------------------------------------------------

SSZGHZ_AnchorWaitDeployment:
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                beq.s   SSZGHZ_AnchorDeploymentReturn
                move.b  #6,routine(a0)

SSZGHZ_AnchorDeploymentReturn:
                rts
; ---------------------------------------------------------------------------

SSZGHZ_AnchorSwingAndCheckTurn:
                move.b  $3C(a0),d0
                subi.b  #$40,d0
                sls     d1
                cmpi.b  #-$80,d0
                bhs.s   SSZGHZ_AnchorAdvancePhaseAndFollow
                neg.b   $3A(a0)
                movea.w $44(a0),a1
                btst    #0,render_flags(a1)
                beq.s   SSZGHZ_AnchorSignalSelectedTurn
                not.b   d1

SSZGHZ_AnchorSignalSelectedTurn:
                tst.b   d1
                bne.s   SSZGHZ_AnchorAdvancePhaseAndFollow
                bset    #3,$38(a1)

SSZGHZ_AnchorAdvancePhaseAndFollow:
                move.b  $3A(a0),d0
                add.b   d0,$3C(a0)
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

SSZGHZChainLink_DispatchAndDrawOrFlicker:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SSZGHZChainLink_StateOffsets(pc,d0.w),d1
                jsr     SSZGHZChainLink_StateOffsets(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_Draw_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
SSZGHZChainLink_StateOffsets:
                dc.w    SSZGHZ_InitChainLinkDrop-SSZGHZChainLink_StateOffsets
                dc.w    SSZGHZ_DropLinksAndSignalLast-SSZGHZChainLink_StateOffsets
                dc.w    SSZGHZ_ChainLinkSyncPhaseAndOrbit-SSZGHZChainLink_StateOffsets
; ---------------------------------------------------------------------------

SSZGHZ_InitChainLinkDrop:
                bsr.w   SeedSSZGHZChainSegmentDropWaitBySubtype
                move.b  #4,$3A(a0)
                lea     SSZGHZChainLink_Attributes(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

SSZGHZ_ChainLinkSyncPhaseAndOrbit:
                movea.w parent3(a0),a1
                move.b  $3C(a1),$3C(a0)
                move.b  $3A(a0),d2
                jmp     (MoveSprite_CircularSimple).l
; ---------------------------------------------------------------------------

SSZGHZ_BallDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SSZGHZBall_StateOffsets(pc,d0.w),d1
                jsr     SSZGHZBall_StateOffsets(pc,d1.w)
                move.b  #0,mapping_frame(a0)
                btst    #0,(V_int_run_count+3).w
                beq.s   SSZGHZBall_DrawTouchAfterFrameSelection
                move.b  #1,mapping_frame(a0)

SSZGHZBall_DrawTouchAfterFrameSelection:
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
SSZGHZBall_StateOffsets:
                dc.w    SSZGHZ_InitBallDrop-SSZGHZBall_StateOffsets
                dc.w    SSZGHZ_DropLinksAndSignalLast-SSZGHZBall_StateOffsets
                dc.w    SSZGHZ_ChainLinkSyncPhaseAndOrbit-SSZGHZBall_StateOffsets
; ---------------------------------------------------------------------------

SSZGHZ_InitBallDrop:
                bsr.w   SeedSSZGHZChainSegmentDropWaitBySubtype
                move.b  #3,$3A(a0)
                lea     SSZGHZBall_Attributes(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

SSZGHZShipContactChild_Initialize:
                lea     SSZGHZShipContactChild_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SSZGHZ_ShipContactVisibleEvenTick,(a0)

SSZGHZ_ShipContactVisibleEvenTick:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   SSZGHZShipContactChild_DeleteWithParent
                btst    #6,$38(a1)
                bne.w   SSZGHZ_SharedReturn
                btst    #0,(V_int_run_count+3).w
                bne.w   SSZGHZ_SharedReturn
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZGHZShipContactChild_DeleteWithParent:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

; The scored defeat leaves the HUD timer running
SSZGHZBoss_HandleHitOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   SSZGHZBoss_ReturnFromHitOrDefeatCheck
                move.b  collision_property(a0),d0
                beq.s   SSZGHZ_BeginDefeatFadeAndExplosion
                tst.b   $20(a0)
                bne.s   SSZGHZBoss_SelectMisoffsetHitFlashColors
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

SSZGHZBoss_SelectMisoffsetHitFlashColors:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   SSZGHZ_HitCopyColorsAndTick
; Bug: should be 2*3
                addi.w  #2*2,d0

SSZGHZ_HitCopyColorsAndTick:
                bsr.w   CopySSZGHZThreeColorPaletteAtByteOffset
                subq.b  #1,$20(a0)
                bne.s   SSZGHZBoss_ReturnFromHitOrDefeatCheck
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

SSZGHZBoss_ReturnFromHitOrDefeatCheck:
                rts
; ---------------------------------------------------------------------------

SSZGHZ_BeginDefeatFadeAndExplosion:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #SSZGHZBoss_BeginDefeatDeparture,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   SSZGHZBoss_AwardDefeatAndSeedFadeTimer
                move.b  #4,subtype(a1)

SSZGHZBoss_AwardDefeatAndSeedFadeTimer:
                jmp     (BossDefeated).l
; End of function SSZGHZBoss_HandleHitOrDefeat

; =============== S U B R O U T I N E =======================================

CopySSZGHZThreeColorPaletteAtByteOffset:
                lea     SSZGHZBoss_HitFlashPaletteSlotAddresses(pc),a1
                lea     SSZGHZBoss_HitFlashColorWords(pc,d0.w),a2
                jmp     (CopyWordData_3).l
; End of function CopySSZGHZThreeColorPaletteAtByteOffset

; ---------------------------------------------------------------------------
SSZGHZBoss_HitFlashPaletteSlotAddresses:
                dc.w    Normal_palette+$0E, Normal_palette+$1C, Normal_palette+$1E
SSZGHZBoss_HitFlashColorWords:
                dc.w    8,  $866,  $222
                dc.w    $888,  $CCC,  $EEE

; =============== S U B R O U T I N E =======================================

SeedSSZGHZChainSegmentDropWaitBySubtype:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SSZGHZChainChildren_DropTimersBySubtype(pc,d0.w),$2E(a0)
                rts
; End of function SeedSSZGHZChainSegmentDropWaitBySubtype

; ---------------------------------------------------------------------------
SSZGHZChainChildren_DropTimersBySubtype:
                dc.w    $C,   $14,   $1C,   $24,   $2C,   $3C
ObjDat_SSZGHZBoss:
                dc.l    Map_RobotnikShip
                dc.w    make_art_tile(ArtTile_RobotnikShip,0,0)
                dc.w    $200
                dc.b    $1C, $20,  $A,  $F
SSZGHZShipContactChild_PartialAttributes:
                dc.w    $200
                dc.b    8,   4,   6,   0
SSZGHZChainAnchor_Attributes:
                dc.l    Map_SSZGHZMisc
; this is using the incorrect palette line
                dc.w    make_art_tile(ArtTile_SSZGHZMisc,1,0)
                dc.w    $300
                dc.b    8,   8,   2,   0
SSZGHZChainLink_Attributes:
                dc.l    Map_SSZGHZMisc
; this is using the incorrect palette line
                dc.w    make_art_tile(ArtTile_SSZGHZMisc,1,0)
                dc.w    $300
                dc.b    8,   8,   3,   0
SSZGHZBall_Attributes:
                dc.l    Map_SSZGHZMisc
                dc.w    make_art_tile(ArtTile_SSZGHZMisc,1,0)
                dc.w    $280
                dc.b    8,   8,   0, $8F
SSZGHZChainAndBall_TreeChildRecords:
                dc.w    6-1
                dc.l    SSZGHZ_AnchorDispatchAndDraw
                dc.l    SSZGHZChainLink_DispatchAndDrawOrFlicker
                dc.l    SSZGHZChainLink_DispatchAndDrawOrFlicker
                dc.l    SSZGHZChainLink_DispatchAndDrawOrFlicker
                dc.l    SSZGHZChainLink_DispatchAndDrawOrFlicker
                dc.l    SSZGHZ_BallDispatchAndDraw
SSZGHZShipContactChild_NormalChildRecord:
                dc.w    1-1
                dc.l    SSZGHZShipContactChild_Initialize
                dc.b    $1E,   0
