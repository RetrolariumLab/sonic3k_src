; Owner: objects/ending/sk
; Responsibility: Ending scenery, island-lift and animal child actors with scene-relative drawing or cleanup
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EndingAttachedMasterEmerald_Initialize:
                move.l  #EndScenery_FollowAndDrawMasterEmerald,(a0)
                lea     (SSZMechaMasterEmerald_Attributes).l,a1
                jsr     (SetUp_ObjAttributes).l
                addi.w  #make_art_tile($000,2,0),art_tile(a0)
                move.b  #2,mapping_frame(a0)

EndScenery_FollowAndDrawMasterEmerald:
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

EndingPlaneBlinkDetail_Initialize:
                lea     EndingPlaneBlinkDetail_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #EndScenery_FollowPlaneBlinkDetail,(a0)

EndingChild_MatchParentCoordinateMode:
                movea.w parent3(a0),a1
                btst    #2,render_flags(a1)
                bne.s   EndScenery_ChildCoordModeReturn
                bclr    #2,render_flags(a0)

EndScenery_ChildCoordModeReturn:
                rts
; ---------------------------------------------------------------------------

EndScenery_FollowPlaneBlinkDetail:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   EndingChild_DeleteCurrentActor
                btst    #1,(V_int_run_count+3).w
                bne.w   EndingScene_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndingChild_DeleteCurrentActor:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

EndingPlanePoseOffsetDetail_Initialize:
                lea     EndData_PlaneCyclingDetailPartAttrs(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #EndScenery_UpdatePoseOffsetFromFrame,(a0)
                bra.s   EndingChild_MatchParentCoordinateMode
; ---------------------------------------------------------------------------

EndScenery_UpdatePoseOffsetFromFrame:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                subq.w  #1,d0
                add.w   d0,d0
                move.w  EndScenery_ParentFrameOffsetPairs(pc,d0.w),child_dx(a0)  ; and child_dy
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   EndingChild_DeleteCurrentActor
                move.b  #$16,mapping_frame(a0)
                btst    #1,(V_int_run_count+3).w
                beq.s   EndingPlanePoseOffsetDetail_Draw
                move.b  #$17,mapping_frame(a0)

EndingPlanePoseOffsetDetail_Draw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
EndScenery_ParentFrameOffsetPairs:
                dc.b    -$A,  $C
                dc.b    -9,  $B
                dc.b    -8,   9
                even
; ---------------------------------------------------------------------------

EndingPlaneWideDetail_Initialize:
                lea     EndingPlaneWideDetail_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #EndingPlaneWideDetail_FollowAndDraw,(a0)
                bra.w   EndingChild_MatchParentCoordinateMode
; ---------------------------------------------------------------------------

EndingPlaneWideDetail_FollowAndDraw:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

EndScenery_InitPoseDetailAndPriority:
                lea     EndingPlanePoseDetail_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                movea.w parent3(a0),a1
                bclr    #7,art_tile(a0)
                btst    #7,art_tile(a1)
                beq.s   EndScenery_MatchParentCoordMode
                bset    #7,art_tile(a0)

EndScenery_MatchParentCoordMode:
                btst    #2,render_flags(a1)
                bne.s   EndScenery_SelectPoseOutcomeGroup
                bclr    #2,render_flags(a0)

EndScenery_SelectPoseOutcomeGroup:
                move.l  #EndScenery_FollowParentPoseUntilCleanup,(a0)
                move.w  (Player_mode).w,d0
                cmpi.w  #3,d0
                bne.s   EndScenery_SelectPoseSubtypeColumn
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                bmi.s   EndScenery_SelectPoseSubtypeColumn
                addq.w  #1,d0

EndScenery_SelectPoseSubtypeColumn:
                add.w   d0,d0
                tst.b   subtype(a0)
                beq.s   EndingPlanePoseDetail_ApplySelectedFrame
                addq.b  #1,d0

EndingPlanePoseDetail_ApplySelectedFrame:
                move.b  EndScenery_PoseFramesByOutcomeAndSide(pc,d0.w),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
EndScenery_PoseFramesByOutcomeAndSide:
                dc.b    $C,  $E
                dc.b    $C,  $E
                dc.b    $D,  $F
                dc.b    $13, $14
                dc.b    $13, $15
; ---------------------------------------------------------------------------

EndScenery_FollowParentPoseUntilCleanup:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.w   EndingChild_DeleteCurrentActor
                bsr.w   EndingAttachment_SetOffsetsFromPose
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndingSmallPlaneOutcomeDetail_Initialize:
                lea     EndData_SmallPlaneOutcomeArtAndAttrs(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #EndScenery_FollowSmallPlaneOutcome,(a0)
                bra.w   EndingChild_MatchParentCoordinateMode
; ---------------------------------------------------------------------------

EndScenery_FollowSmallPlaneOutcome:
                jsr     (Child_GetPriority).l
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.w   EndingChild_DeleteCurrentActor
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndingSmallPlaneCyclingDetail_Initialize:
                lea     EndData_PlaneCyclingDetailPartAttrs(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #EndScenery_FollowSmallPlaneCycle,(a0)
                bra.w   EndingChild_MatchParentCoordinateMode
; ---------------------------------------------------------------------------

EndScenery_FollowSmallPlaneCycle:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.w   EndingChild_DeleteCurrentActor
                move.b  #$18,mapping_frame(a0)
                btst    #1,(V_int_run_count+3).w
                beq.s   EndingSmallPlaneCyclingDetail_Draw
                move.b  #$19,mapping_frame(a0)

EndingSmallPlaneCyclingDetail_Draw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndScenery_InitLiftSpriteBySubtype:
                move.l  #Map_IslandLiftGfx,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_IslandLiftGfx,3,1),art_tile(a0)
                move.w  #$300,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  x_pos(a0),$3A(a0)
                move.w  y_pos(a0),$3C(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                subi.b  #$41,d0
                bcc.s   EndScenery_DispatchLiftSubtypeInit
                moveq   #0,d0

EndScenery_DispatchLiftSubtypeInit:
                add.w   d0,d0
                move.w  EndScenery_LiftSubtypeInitOffsets(pc,d0.w),d0
                jmp     EndScenery_LiftSubtypeInitOffsets(pc,d0.w)
; ---------------------------------------------------------------------------
EndScenery_LiftSubtypeInitOffsets:
                dc.w    EndScenery_InitLiftWorldEffectPhase-EndScenery_LiftSubtypeInitOffsets
                dc.w    EndScenery_InitLiftProjectedDetail-EndScenery_LiftSubtypeInitOffsets
                dc.w    EndScenery_InitLiftGroup43Anim-EndScenery_LiftSubtypeInitOffsets
                dc.w    EndScenery_InitLiftGroup44Anim-EndScenery_LiftSubtypeInitOffsets
                dc.w    EndScenery_InitLiftWorldGroupAnim-EndScenery_LiftSubtypeInitOffsets
                dc.w    EndScenery_InitLiftWorldGroupAnim-EndScenery_LiftSubtypeInitOffsets
                dc.w    EndScenery_InitLiftWorldGroupAnim-EndScenery_LiftSubtypeInitOffsets
; ---------------------------------------------------------------------------

EndScenery_InitLiftWorldEffectPhase:
                move.l  #EndScenery_ConvertLiftEffectToScreen,(a0)
                bset    #2,render_flags(a0)
                move.w  (Camera_Y_pos_copy).w,$3A(a0)
                bclr    #7,art_tile(a0)
                rts
; ---------------------------------------------------------------------------

EndScenery_InitLiftProjectedDetail:
                move.l  #EndScenery_AnimateAndProjectLiftDetail,(a0)
                move.b  #4,mapping_frame(a0)
                move.b  $2D(a0),d0
                move.b  d0,$24(a0)
                cmpi.w  #3,(Player_mode).w
                bne.s   EndScenery_ProjectedDetailInitReturn
                bset    #2,render_flags(a0)

EndScenery_ProjectedDetailInitReturn:
                rts
; ---------------------------------------------------------------------------

EndScenery_InitLiftGroup43Anim:
                move.l  #EndScenery_AnimateAndDrawLiftDetail,(a0)
                move.b  #$1A,mapping_frame(a0)
                move.l  #EndingIslandLiftGroup43_RawAnimation,$30(a0)
                tst.b   $2D(a0)
                beq.s   EndScenery_LiftGroup43InitReturn
                move.b  #$18,$24(a0)

EndScenery_LiftGroup43InitReturn:
                rts
; ---------------------------------------------------------------------------

EndScenery_InitLiftGroup44Anim:
                move.l  #EndScenery_AnimateAndDrawLiftDetail,(a0)
                move.b  #$1A,mapping_frame(a0)
                move.l  #EndingIslandLiftGroup44_RawAnimation,$30(a0)
                tst.b   subtype(a0)
                cmpi.b  #8,$2D(a0)
                blo.s   EndScenery_LiftGroup44InitReturn
                move.b  #$10,$24(a0)

EndScenery_LiftGroup44InitReturn:
                rts
; ---------------------------------------------------------------------------

EndScenery_InitLiftWorldGroupAnim:
                bclr    #7,art_tile(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                subi.b  #$45,d0
                lsl.w   #2,d0
                move.l  EndScenery_LiftWorldGroupAnimPointers(pc,d0.w),$30(a0)
                move.l  #EndScenery_AnimateAndDrawLiftDetail,(a0)
                bset    #2,render_flags(a0)
                tst.b   $2D(a0)
                beq.s   EndScenery_LiftWorldGroupInitReturn
                move.b  #$C,$24(a0)

EndScenery_LiftWorldGroupInitReturn:
                rts
; ---------------------------------------------------------------------------
EndScenery_LiftWorldGroupAnimPointers:
                dc.l    EndingIslandLiftGroup45_RawAnimation
                dc.l    EndingIslandLiftGroup46_RawAnimation
                dc.l    EndingIslandLiftGroup47_RawAnimation
; ---------------------------------------------------------------------------

EndScenery_ConvertLiftEffectToScreen:
                move.w  (Camera_Y_pos_copy).w,d0
                sub.w   $3A(a0),d0
                cmpi.w  #$10,d0
                blt.s   EndScenery_AnimateWorldLiftEffect
                move.l  #EndScenery_MoveScreenLiftEffect,(a0)
                bclr    #2,render_flags(a0)
                move.w  #$10,y_vel(a0)
                move.w  x_pos(a0),d0
                sub.w   (Camera_X_pos_copy).w,d0
                addi.w  #$80,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos_copy).w,d0
                addi.w  #$80,d0
                move.w  d0,y_pos(a0)

EndScenery_AnimateWorldLiftEffect:
                bra.w   EndScenery_AnimateAndBlinkLiftEffect
; ---------------------------------------------------------------------------

EndScenery_MoveScreenLiftEffect:
                jsr     (MoveSprite2).l

EndScenery_AnimateAndBlinkLiftEffect:
                lea     EndingIslandLiftWorldEffect_RawAnimation(pc),a1
                jsr     (Animate_RawNoSST).l
                btst    #0,(V_int_run_count+3).w
                bne.w   EndingScene_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndScenery_AnimateAndProjectLiftDetail:
                lea     EndData_LiftProjectedDetailAnim(pc),a1
                jsr     (Animate_RawNoSST).l
                cmpi.w  #3,(Player_mode).w
                beq.s   EndScenery_CheckLiftDetailWindow
                bsr.w   Ending_ProjectActorAndFlagOutside

EndScenery_CheckLiftDetailWindow:
                btst    #3,(SceneSyncFlagsOrMHZState).w
                bne.s   EndingIslandLiftProjectedDetail_Delete
                btst    #6,$38(a0)
                bne.w   EndingScene_SharedReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndingIslandLiftProjectedDetail_Delete:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

EndScenery_AnimateAndDrawLiftDetail:
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; End of function EndScenery_AnimateAndDrawLiftDetail
