; Owner: objects/bosses/mgz/end_boss/s3
; Responsibility: Marble Garden end-boss projectiles, detached effects, debris and defeat palette transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

MGZBossS3_InitTrailMotionAndDelay:
                lea     MGZBossS3_TrailAndShotAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MGZBossS3_TrailTickHiddenDelay,(a0)
                bsr.w   MGZBossTrail_InitVelAndDelay
                move.l  #MGZBossS3_TrailBeginOutwardLeg,$34(a0)

MGZBossS3_TrailTickHiddenDelay:
                subq.w  #1,$2E(a0)
                bmi.s   MGZBossS3_TrailBeginOutwardLeg
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.w   MGZArrivalS3_SharedReturn
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

MGZBossS3_TrailBeginOutwardLeg:
                move.l  #MGZBossS3_TrailMoveAndCountOutward,(a0)
                move.b  #$17,mapping_frame(a0)
                clr.w   $2E(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

MGZBossS3_TrailMoveAndCountOutward:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   MGZBossS3_TrailPauseForCarrier
                move.b  #$16,mapping_frame(a0)
                addq.w  #1,$2E(a0)
                jsr     (MoveSprite2).l
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

MGZBossS3_TrailPauseForCarrier:
                move.l  #MGZBossS3_TrailWaitForReturnSignal,(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

MGZBossS3_TrailWaitForReturnSignal:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   MGZBossS3_TrailReverseAndReturn
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

MGZBossS3_TrailReverseAndReturn:
                move.l  #MGZBossS3_TrailMoveAndTickReturn,(a0)
                neg.w   x_vel(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

; Use the number of outward movement updates to time the return leg
MGZBossS3_TrailMoveAndTickReturn:
                subq.w  #1,$2E(a0)
                bmi.s   MGZBossS3_TrailShowEndcapAndDelete
                jsr     (MoveSprite2).l
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

MGZBossS3_TrailShowEndcapAndDelete:
                move.b  #$17,mapping_frame(a0)
                move.l  #Delete_Current_Sprite,(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

MGZBossS3_InitPoseAttachment:
                lea     MGZBossS3_PoseAttachmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MGZBossS3_PoseAttachmentFollowAndDraw,(a0)
                move.b  subtype(a0),d0
                subi.b  #4,d0
                move.b  d0,subtype(a0)
                beq.s   MGZBossS3_PoseAttachmentSpawnHazard
                move.w  #$380,priority(a0)
                movea.w parent3(a0),a1
                cmpi.l  #Obj_MGZEndBoss,(a1)
                bne.s   MGZBossS3_PoseAttachmentSpawnHazard
                bclr    #7,art_tile(a0)

MGZBossS3_PoseAttachmentSpawnHazard:
                lea     MGZBossS3_PoseHazardChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossS3_PoseAttachmentFollowAndDraw:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   MGZBossS3_PoseAttachmentMarkChildDead
                lea     MGZBossS3_PoseAttachmentRecords(pc),a2
                bsr.w   SelectMGZBossPoseChildOffsetsAndFrame
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #$14,d0
                jmp     (Child_Draw_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------

MGZBossS3_PoseAttachmentMarkChildDead:
                bset    #5,$38(a0)
                move.l  #Delete_Current_Sprite,(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_InitPoseHazardAndCacheBoss:
                lea     MGZBossS3_PoseHazardAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #MGZBossS3_PoseHazardFollowAndFlicker,(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                tst.b   subtype(a1)
                beq.s   MGZBossS3_PoseHazardInheritPriority
                move.w  #$300,priority(a0)

MGZBossS3_PoseHazardInheritPriority:
                bclr    #7,art_tile(a0)
                btst    #7,art_tile(a1)
                beq.s   MGZBossS3_PoseHazardInitReturn
                bset    #7,art_tile(a0)

MGZBossS3_PoseHazardInitReturn:
                rts
; ---------------------------------------------------------------------------

MGZBossS3_PoseHazardFollowAndFlicker:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   MGZBossS3_PoseHazardQueueDeletion
                lea     MGZBossS3_PoseHazardRecords(pc),a2
                bsr.w   SelectMGZBossPoseChildOffsetsAndFrame
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   MGZBossS3_PoseHazardQueueDeletion
                btst    #0,(V_int_run_count+3).w
                bne.w   MGZArrivalS3_SharedReturn
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

MGZBossS3_PoseHazardQueueDeletion:
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

MGZBossS3_InitArrivalDebris:
                lea     MGZBossS3_ArrivalDebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MGZBossS3_ArrivalDebrisFallAndCull,(a0)
                bra.w   MGZBossS3_SetArrivalDebrisFrameAndSpeed
; ---------------------------------------------------------------------------

MGZBossS3_ArrivalDebrisFallAndCull:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------
; unused
                lea     MGZBossS3_UnusedVisualAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MGZBossS3_LegacyVisualFollowAndSelect,(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossS3_LegacyVisualFollowAndSelect:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   MGZBossS3_LegacyVisualDrawFinalFrame
                btst    #6,status(a1)
                bne.s   MGZBossS3_LegacyVisualDrawHitFrame
                lea     MGZBossS3_LegacyVisualIdleAnim(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MGZBossS3_LegacyVisualDrawHitFrame:
                move.b  #2,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MGZBossS3_LegacyVisualDrawFinalFrame:
                move.l  #MGZBossS3_LegacyVisualFollowUntilRemoval,(a0)
                move.b  #3,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MGZBossS3_LegacyVisualFollowUntilRemoval:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

MGZBossS3_InitDefeatFragment:
                lea     MGZBossS3_CarrierAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                jsr     (Refresh_ChildPositionAdjusted).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                beq.s   MGZBossS3_DefeatFragmentSetMotion
                move.w  #$200,priority(a0)

MGZBossS3_DefeatFragmentSetMotion:
                lsr.w   #1,d0
                addi.b  #$2E,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$28,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

MGZBossS3_InitScaledFlyby:
                lea     MGZEndBossS3_ScaledFlyby_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MGZBossS3_FlybyCheckCancelAndMoveX,(a0)
                move.w  #tiles_to_bytes(ArtTile_MGZEndBossScaled),$3A(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$140,d0
                move.w  d0,x_pos(a0)
                move.w  d0,$30(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$50,d0
                move.w  d0,y_pos(a0)
                move.w  d0,$34(a0)
                move.w  #-$400,x_vel(a0)
                move.b  #4,$40(a0)
                move.l  #ArtScaled_MGZEndBoss,$42(a0)
                move.b  #1,$3E(a0)
                bsr.w   MGZBossFlyby_SelectPathAndEntry
                moveq   #6,d0
                move.w  ground_vel(a0),d1
                beq.s   MGZBossS3_FlybySetXAcceleration
                cmpi.w  #$C,d1
                beq.s   MGZBossS3_FlybySetXAcceleration
                moveq   #$10,d0

MGZBossS3_FlybySetXAcceleration:
                move.w  d0,$2E(a0)
                bra.w   MGZBossS3_FlybyRebuildArtAndQueueDMA
; ---------------------------------------------------------------------------

MGZBossS3_FlybyCheckCancelAndMoveX:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.w   MGZBossS3_FlybyDeleteWhenCanceled
                move.w  x_vel(a0),d0
                add.w   $2E(a0),d0
                cmpi.w  #-$100,d0
                bgt.s   MGZBossS3_FlybyChooseYAcceleration
                move.w  d0,x_vel(a0)

MGZBossS3_FlybyChooseYAcceleration:
                move.w  y_vel(a0),d0
                move.w  $3C(a0),d1
                bmi.s   MGZBossS3_FlybyApplyNegativeYAccel
                add.w   d1,d0
                cmpi.w  #$400,d0
                ble.s   MGZBossS3_FlybyStoreYSpeed
                bra.w   MGZBossS3_FlybyProjectAndTickScale
; ---------------------------------------------------------------------------

MGZBossS3_FlybyApplyNegativeYAccel:
                add.w   d1,d0
                cmpi.w  #-$400,d0
                blt.s   MGZBossS3_FlybyProjectAndTickScale

MGZBossS3_FlybyStoreYSpeed:
                move.w  d0,y_vel(a0)

; Update the scale only on every fourth V-int tick
MGZBossS3_FlybyProjectAndTickScale:
                bsr.w   IntegrateScaledActorPositionAccumulators
                move.w  $30(a0),d2
                move.w  $34(a0),d3
                moveq   #0,d0
                move.b  $40(a0),d0
                addq.w  #4,d0
                move.l  #$100,d4
                divu.w  d0,d4
                sub.w   d4,d2
                sub.w   d4,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   MGZBossS3_FlybyCullUsingCenterX
                move.b  $40(a0),d0
                add.b   $3E(a0),d0
                andi.b  #$7F,d0
                cmpi.b  #4,d0
                blo.w   MGZBossS3_FlybyRebuildArtAndQueueDMA
                move.b  d0,$40(a0)

MGZBossS3_FlybyRebuildArtAndQueueDMA:
                clr.w   (ScaledArtAllocatedTileCount).w
                move.l  a0,-(sp)
                jsr     (Init_ArtScaling).l
                movea.l (sp)+,a0
                move.l  a0,-(sp)
                move.w  art_tile(a0),d0
                jsr     (TryBuildObjectScaledArt).l
                movea.l (sp)+,a0
                move.w  (ScaledArtAllocatedTileCount).w,d3
                lsl.w   #4,d3
                move.l  #Kos_decomp_buffer,d1
                move.w  $3A(a0),d2
                jsr     (Add_To_DMA_Queue).l

MGZBossS3_FlybyCullUsingCenterX:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

MGZBossS3_FlybyDeleteWhenCanceled:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

MGZBossS3_TickTransitionPalette:
                subq.w  #1,$2E(a0)
                bpl.s   MGZBossS3_TransitionPaletteReturn
                moveq   #0,d0
                move.b  $39(a0),d0
                move.w  MGZBossS3_TransitionPaletteDelays(pc,d0.w),$2E(a0)
                lsl.w   #4,d0
                lea     (Pal_MGZFadeCNZ).l,a1
                adda.w  d0,a1
                lea     (Normal_palette_line_4).w,a2
                moveq   #bytesToLcnt($20),d1

MGZBossS3_CopyTransitionPaletteRow:
                move.l  (a1)+,(a2)+
                dbf     d1,MGZBossS3_CopyTransitionPaletteRow
                addq.b  #2,$39(a0)
                cmpi.b  #$20,$39(a0)
                bhs.s   MGZBossS3_StartCarnivalNightAndDelete

MGZBossS3_TransitionPaletteReturn:
                rts
; ---------------------------------------------------------------------------

MGZBossS3_StartCarnivalNightAndDelete:
                move.w  #$300,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
MGZBossS3_TransitionPaletteDelays:
                dc.w    $A
                dc.w    $A
                dc.w    $A
                dc.w    $A
                dc.w    $A
                dc.w    $A
                dc.w    $A
                dc.w    $A
                dc.w    $A
                dc.w    $64
                dc.w    5
                dc.w    5
                dc.w    5
                dc.w    5
                dc.w    $14
