; Owner: objects/cutscenes/sk
; Responsibility: Lava Reef Knuckles encounter, boulder interaction and scene progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_LRZ2:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_LRZ2_Index(pc,d0.w),d1
                jsr     CutsceneKnux_LRZ2_Index(pc,d1.w)
                bsr.w   SKScene_LoadKnuxArtToSceneTiles
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
CutsceneKnux_LRZ2_Index:
                dc.w    LRZ2Scene_InitKnucklesAtBoulder-CutsceneKnux_LRZ2_Index
                dc.w    LRZ2Scene_StartReactionOnCameraCue-CutsceneKnux_LRZ2_Index
                dc.w    LRZ2Scene_AnimateHighFrameReaction-CutsceneKnux_LRZ2_Index
                dc.w    LRZ2Scene_AnimateFinalReaction-CutsceneKnux_LRZ2_Index
                dc.w    LRZ2Scene_FinalActorReturn-CutsceneKnux_LRZ2_Index
; ---------------------------------------------------------------------------

LRZ2Scene_InitKnucklesAtBoulder:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bset    #0,render_flags(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$56,mapping_frame(a0)
                move.w  #$3A38,x_pos(a0)
                move.w  #$EC,y_pos(a0)
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

LRZ2Scene_StartReactionOnCameraCue:
                btst    #1,(SceneSyncFlagsOrMHZState).w
                beq.w   SKAIZScene_SharedSceneReturn
                move.b  #4,routine(a0)
                move.b  #$DE,mapping_frame(a0)
                move.l  #LRZ2Scene_SignalBoulderAndSetFinalAnim,$34(a0)

LRZ2Scene_AnimateHighFrameReaction:
                lea     SKSceneAnim_LRZSignalReaction(pc),a1
                jmp     (Animate_Raw2NoSSTMultiDelay).l
; ---------------------------------------------------------------------------

LRZ2Scene_SignalBoulderAndSetFinalAnim:
                move.b  #6,routine(a0)
                bset    #2,(SceneSyncFlagsOrMHZState).w
                move.l  #LRZ2Scene_SelectFinalIdle,$34(a0)
                lea     SKSceneAnim_LRZPostSignalReaction(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

LRZ2Scene_AnimateFinalReaction:
                lea     SKSceneAnim_LRZPostSignalReaction(pc),a1
                jmp     (Animate_Raw2NoSSTMultiDelay).l
; ---------------------------------------------------------------------------

LRZ2Scene_SelectFinalIdle:
                move.b  #8,routine(a0)

LRZ2Scene_FinalActorReturn:
                rts
; ---------------------------------------------------------------------------

Obj_LRZ2CutsceneKnuckles:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                move.l  #LRZ2Scene_CheckPrimarySceneTrigger,(a0)
                jsr     (AllocateObject).l
                bne.s   LRZ2Scene_CheckPrimarySceneTrigger
                move.l  #SKInput_LockP2IfActive,(a1)

LRZ2Scene_CheckPrimarySceneTrigger:
                lea     (Player_1).w,a1
                lea     LRZ2Scene_PrimaryTriggerBounds(pc),a2
                jsr     (Check_InMyRange).l
                beq.w   SKAIZScene_SharedSceneReturn
                move.l  #LRZ2Scene_LockP1AtX39B0,(a0)
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                jsr     (AllocateObject).l
                bne.s   LRZ2Scene_TryMusicAndBoulderActors
                move.l  #Obj_CutsceneKnuckles,(a1)
                move.b  #$24,subtype(a1)

LRZ2Scene_TryMusicAndBoulderActors:
                bsr.w   CutsceneSpawnKnucklesMusicFadeTransition
                jsr     (AllocateObject).l
                bne.s   LRZ2Scene_QueueBoulderArt
                move.l  #LRZ2Scene_InitSelfParentedBoulder,(a1)

LRZ2Scene_QueueBoulderArt:
                lea     (ArtKosM_LRZKnuxBoulder).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZKnuxBoulder),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------
LRZ2Scene_PrimaryTriggerBounds:
                dc.w    -$10,   $10, -$240,  $240
; ---------------------------------------------------------------------------

LRZ2Scene_LockP1AtX39B0:
                lea     (Player_1).w,a1
                cmpi.w  #$39B0,x_pos(a1)
                blo.s   LRZ2Scene_PrimaryPositionReturn
                move.l  #LRZ2Scene_WaitGroundedAndUnlockCamera,(a0)
                st      (Ctrl_1_locked).w
                jsr     (Stop_Object).l
                clr.w   (Ctrl_1_logical).w

LRZ2Scene_PrimaryPositionReturn:
                rts
; ---------------------------------------------------------------------------

LRZ2Scene_WaitGroundedAndUnlockCamera:
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.w   SKAIZScene_SharedSceneReturn
                move.l  #LRZ2Scene_PanUpToY90,(a0)
                bset    #0,(SceneSyncFlagsOrMHZState).w
                move.w  #0,(Camera_min_X_pos).w
                st      (Scroll_lock).w
                clr.b   (Ctrl_1_locked).w
                move.b  #$81,object_control(a1)
                move.b  #7,anim(a1)
                rts
; ---------------------------------------------------------------------------

LRZ2Scene_PanUpToY90:
                move.w  (Camera_Y_pos).w,d0
                subq.w  #2,d0
                move.w  d0,(Camera_Y_pos).w
                cmpi.w  #$90,d0
                bhi.w   SKAIZScene_SharedSceneReturn
                move.l  #LRZ2Scene_StartNextZoneAtY4C0,(a0)
                bset    #1,(SceneSyncFlagsOrMHZState).w
                rts
; ---------------------------------------------------------------------------

LRZ2Scene_StartNextZoneAtY4C0:
                cmpi.w  #$4C0,(Player_1+y_pos).w
                blo.w   SKAIZScene_SharedSceneReturn
                st      (Act3_flag).w
                move.w  (Ring_count).w,(Act3_ring_count).w
                move.l  (Timer).w,(Act3_timer).w
                move.b  (Player_1+status_secondary).w,(Saved2_status_secondary).w
                move.w  #$1600,d0
                jmp     (StartNewLevel).l
; ---------------------------------------------------------------------------

LRZ2Scene_InitSelfParentedBoulder:
                lea     SKLrzCutscene_BoulderAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #LRZ2Scene_WaitForBoulderStartSignal,(a0)
                move.w  #$3A08,x_pos(a0)
                move.w  #$E2,y_pos(a0)
                move.b  #$1F,y_radius(a0)
                move.w  a0,$46(a0)
                rts
; ---------------------------------------------------------------------------

LRZ2Scene_WaitForBoulderStartSignal:
                btst    #2,(SceneSyncFlagsOrMHZState).w
                beq.s   LRZ2Scene_DrawWaitingBoulder
                move.l  #LRZ2Scene_RollAndCheckFloorGap,(a0)
                move.w  #-$200,x_vel(a0)

LRZ2Scene_DrawWaitingBoulder:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LRZ2Scene_RollAndCheckFloorGap:
                moveq   #signextendB(sfx_PushBlock),d0
                jsr     (Play_SFX_Continuous).l
                bsr.w   LRZRollingSceneCycleOwnerRenderFlips
                bsr.w   LRZRollingScene_OrbitBothPlayers
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   LRZ2Scene_DrawRollingBoulder
                move.l  #LRZ2Scene_MoveAirBoulderAndCheckBounce,(a0)

LRZ2Scene_DrawRollingBoulder:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LRZ2Scene_MoveAirBoulderAndCheckBounce:
                moveq   #signextendB(sfx_PushBlock),d0
                jsr     (Play_SFX_Continuous).l
                bsr.w   LRZRollingSceneCycleOwnerRenderFlips
                bsr.w   LRZRollingScene_OrbitBothPlayers
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.s   LRZ2Scene_DrawAirborneBoulder
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   LRZ2Scene_DrawAirborneBoulder
                move.w  #-$100,y_vel(a0)
                move.w  #$14,(Screen_shake_flag).w
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l

LRZ2Scene_DrawAirborneBoulder:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
LRZ2Scene_HPZCameraBoundsAndSplit:
                dc.w    $180,  $480,  $FE0, $11E0
                dc.w    $380,  $380, $10E0, $10E0
