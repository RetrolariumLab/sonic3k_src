; Owner: objects/zones/cnz/s3
; Responsibility: Carnival Night cork floor and button controls for water-level cutscenes
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZWaterLevelCorkFloor:
                jsr     (Obj_WaitOffscreen).l
                move.l  #S3CNZWater_CheckCorkBroken,(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3CNZWater_CheckCorkBroken
                move.l  #Obj_CorkFloor,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  #1,subtype(a1)
                move.w  a1,$44(a0)

S3CNZWater_CheckCorkBroken:
                movea.w $44(a0),a1
                cmpi.l  #S3Cork_MoveFragmentAndApplyGravity,(a1)
                beq.s   S3CNZWater_RaiseTargetOnce
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

S3CNZWater_RaiseTargetOnce:
                tst.b   (ZoneEventLatchOrBossReleaseSignal).w
                bne.s   S3CNZWater_DeleteCorkTrigger
                st      (ZoneEventLatchOrBossReleaseSignal).w
                move.w  #$958,(Target_water_level).w

S3CNZWater_DeleteCorkTrigger:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_CNZWaterLevelButton:
                lea     ObjDat_CutsceneButton(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #S3CNZWater_UpdateWaterButton,(a0)
                addq.w  #4,y_pos(a0)
                lea     PLC_CutsceneButton(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

S3CNZWater_UpdateWaterButton:
                move.w  #$1B,d1
                move.w  #4,d2
                move.w  #5,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.b  #0,mapping_frame(a0)
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   S3CNZWater_DrawWaterButton
                move.b  #1,mapping_frame(a0)
                tst.b   (ZoneButtonRequestOrBridgeReleaseSignal).w
                beq.s   S3CNZWater_DrawWaterButton
                clr.b   (ZoneButtonRequestOrBridgeReleaseSignal).w
                move.w  #$A58,(Target_water_level).w
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   S3CNZWater_DrawWaterButton
                move.l  #S3CNZScene_TickFlashAndSelectBank,(a1)
                st      subtype(a1)

S3CNZWater_DrawWaterButton:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

SpawnKnucklesCutsceneMusicTransition:
                jsr     (AllocateObject).l
                bne.s   S3CNZWater_MusicSpawnReturn
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Knuckles,subtype(a1)

S3CNZWater_MusicSpawnReturn:
                rts
; End of function SpawnKnucklesCutsceneMusicTransition

; ---------------------------------------------------------------------------
ObjSlot_CutsceneKnux:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_CutsceneKnux,1,1)
                dc.w    $2E,     0
                dc.l    Map_CutsceneKnux
                dc.w    $180
                dc.b    $1C, $18, $16,   0
ObjDat_CutsceneButton:
                dc.l    Map_Button
                dc.w    make_art_tile(ArtTile_GrayButton,0,1)
                dc.w    $100
                dc.b    $10,   8,   0,   0
S3KnuxScene_LBZBombAttrs:
                dc.l    Map_LBZKnuxBomb
                dc.w    make_art_tile(ArtTile_LBZKnuxBomb,1,1)
                dc.w    $80
                dc.b    8,   8,   0,   0
S3KnuxScene_LBZPillarAttrs:
                dc.l    Map_LBZKnuxPillar
                dc.w    make_art_tile(ArtTile_Explosion,2,0)
                dc.w    $280
                dc.b    $10, $10,   0,   0
ObjDat_LBZKnuxPillar:
                dc.l    Map_LBZKnuxPillar
                dc.w    make_art_tile(ArtTile_Explosion,2,0)
                dc.w    $280
                dc.b    $10, $80,   1,   0
S3KnuxScene_AIZCorkAttrs:
                dc.l    Map_AIZCorkFloor
                dc.w    make_art_tile($001,2,0)
                dc.w    $180
                dc.b    $10, $18,   0,   0
S3KnuxScene_AIZ2BarrierChild:
                dc.w    1-1
                dc.l    S3AIZScene_ResolveAct2SolidChild
S3KnuxScene_CNZTallBarrierChild:
                dc.w    1-1
                dc.l    S3CNZScene_ResolveInvisibleSolidChild
                dc.b    -$20,-$6C
S3KnuxScene_LBZCaptureChild:
                dc.w    1-1
                dc.l    S3LBZScene_CheckPlayersAndSignalP1
                dc.b    -$40,   0
S3KnuxScene_LBZBombChild:
                dc.w    1-1
                dc.l    S3LBZScene_InitBombAndPlaySound
                dc.b    -8,-$10
S3KnuxScene_LBZRisingExplosions:
                dc.w    4-1
                dc.l    S3LBZScene_InitExplosionColumn
S3KnuxScene_LBZWobblingPillars:
                dc.w    4-1
                dc.l    S3LBZScene_InitPillarMotionAndRestX
                dc.b    2, $24
S3KnuxScene_AIZ1CorkChild:
                dc.w    1-1
                dc.l    S3AIZScene_InitCorkAndCheckParent
                dc.b    0, $18
DPLCPtr_CutsceneKnux:
                dc.l    ArtUnc_CutsceneKnux
                dc.l    DPLC_CutsceneKnux
S3KnuxScene_LBZIdleAnim:
                dc.b    7,   1,   2,   3, $FC
S3KnuxScene_RunAnim:
                dc.b    5,  $A,  $B,  $C,  $D,  $E,  $F, $10, $11, $FC
S3KnuxScene_AIZDashAnim:
                dc.b    1, $12, $13, $14, $15, $FC
S3KnuxScene_JumpAnim:
                dc.b    1,   8,   4,   8,   5,   8,   6,   8,   7, $FC
S3KnuxScene_ChuckleStartAnim:
                dc.b    7, $1C, $1C, $1D
                dc.b    $F8, S3KnuxScene_ChuckleLoopAnim-S3KnuxScene_ChuckleStartAnim
S3KnuxScene_ChuckleLoopAnim:
                dc.b    7, $1E, $1F, $FC
S3KnuxScene_LBZBombThrowAnim:
                dc.b    $16,   7
                dc.b    $16,   7
                dc.b    $17,   7
                dc.b    $18,   7
                dc.b    $19, $13
                dc.b    $1A,   7
                dc.b    $1B,   0
                dc.b    $F4
S3KnuxScene_LBZSecondSceneAnim:
                dc.b    $20,   5
                dc.b    $21,   5
                dc.b    $22, $14
                dc.b    $23,   3
                dc.b    $24,  $F
                dc.b    $21,   5
                dc.b    $20,   5
                dc.b    $F4
                even
Pal_CutsceneKnux:
                binclude "data/General/Sprites/Knuckles/Cutscene/Pal.bin"
                even
Pal_CNZFlash:
                binclude "data/Levels/CNZ/Palettes/Flash.bin"
                even
