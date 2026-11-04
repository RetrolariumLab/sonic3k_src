; Owner: objects/bosses/mgz/end_boss/sk
; Responsibility: Marble Garden end-boss projectiles, detached effects, debris and defeat palette transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

MGZBossSK_InitTrailMotionAndDelay:
                lea     MGZBossSK_TrailAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MGZBossSK_TrailTickHiddenDelay,(a0)
                bsr.w   MGZBossTrail_InitVelAndDelay
                move.l  #MGZBossSK_TrailBeginOutwardLeg,$34(a0)

MGZBossSK_TrailTickHiddenDelay:
                subq.w  #1,$2E(a0)
                bmi.s   MGZBossSK_TrailBeginOutwardLeg
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.w   MGZArrivalSK_SharedReturn
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

MGZBossSK_TrailBeginOutwardLeg:
                move.l  #MGZBossSK_TrailMoveAndCountOutward,(a0)
                move.b  #$17,mapping_frame(a0)
                clr.w   $2E(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

MGZBossSK_TrailMoveAndCountOutward:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   MGZBossSK_TrailPauseForCarrier
                move.b  #$16,mapping_frame(a0)
                addq.w  #1,$2E(a0)
                jsr     (MoveSprite2).l
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

MGZBossSK_TrailPauseForCarrier:
                move.l  #MGZBossSK_TrailWaitForReturnSignal,(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

MGZBossSK_TrailWaitForReturnSignal:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   MGZBossSK_TrailReverseAndReturn
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

MGZBossSK_TrailReverseAndReturn:
                move.l  #MGZBossSK_TrailMoveAndTickReturn,(a0)
                neg.w   x_vel(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

; Use the number of outward movement updates to time the return leg
MGZBossSK_TrailMoveAndTickReturn:
                subq.w  #1,$2E(a0)
                bmi.s   MGZBossSK_TrailShowEndcapAndDelete
                jsr     (MoveSprite2).l
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

MGZBossSK_TrailShowEndcapAndDelete:
                move.b  #$17,mapping_frame(a0)
                move.l  #Delete_Current_Sprite,(a0)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------

MGZBossSK_InitPoseAttachment:
                lea     MGZBossSK_PoseAttachmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MGZBossSK_PoseAttachmentFollowAndDraw,(a0)
                move.b  subtype(a0),d0
                subi.b  #4,d0
                move.b  d0,subtype(a0)
                beq.s   MGZBossSK_PoseAttachmentSpawnHazard
                move.w  #$380,priority(a0)
                movea.w parent3(a0),a1
                cmpi.l  #Obj_MGZEndBoss,(a1)
                bne.s   MGZBossSK_PoseAttachmentSpawnHazard
                bclr    #7,art_tile(a0)

MGZBossSK_PoseAttachmentSpawnHazard:
                lea     MGZBossSK_PoseHazardChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MGZBossSK_PoseAttachmentFollowAndDraw:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   MGZBossSK_PoseAttachmentMarkChildDead
                lea     MGZBossSK_PoseAttachmentRecords(pc),a2
                bsr.w   SelectMGZBossPoseChildOffsetsAndFrame
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #$14,d0
                jmp     (Child_Draw_Sprite2_FlickerMove).l
; ---------------------------------------------------------------------------

MGZBossSK_PoseAttachmentMarkChildDead:
                bset    #5,$38(a0)
                move.l  #Delete_Current_Sprite,(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_InitPoseHazardAndCacheBoss:
                lea     MGZBossSK_PoseHazardAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #MGZBossSK_PoseHazardFollowAndFlicker,(a0)
                bset    #4,shield_reaction(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                tst.b   subtype(a1)
                beq.s   MGZBossSK_PoseHazardInheritPriority
                move.w  #$300,priority(a0)

MGZBossSK_PoseHazardInheritPriority:
                bclr    #7,art_tile(a0)
                btst    #7,art_tile(a1)
                beq.s   MGZBossSK_PoseHazardInitReturn
                bset    #7,art_tile(a0)

MGZBossSK_PoseHazardInitReturn:
                rts
; ---------------------------------------------------------------------------

MGZBossSK_PoseHazardFollowAndFlicker:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   MGZBossSK_PoseHazardQueueDeletion
                lea     MGZBossSK_PoseHazardRecords(pc),a2
                bsr.w   SelectMGZBossPoseChildOffsetsAndFrame
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   MGZBossSK_PoseHazardQueueDeletion
                btst    #0,(V_int_run_count+3).w
                bne.w   MGZArrivalSK_SharedReturn
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

MGZBossSK_PoseHazardQueueDeletion:
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

MGZBossSK_InitArrivalDebris:
                lea     MGZBossSK_ArrivalDebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MGZBossSK_ArrivalDebrisFallAndCull,(a0)
                bra.w   MGZBossSK_SetArrivalDebrisFrameAndSpeed
; ---------------------------------------------------------------------------

MGZBossSK_ArrivalDebrisFallAndCull:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

MGZBossSK_InitDefeatFragment:
                lea     MGZBossSK_CarrierAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                jsr     (Refresh_ChildPositionAdjusted).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                beq.s   MGZBossSK_DefeatFragmentSetMotion
                move.w  #$200,priority(a0)

MGZBossSK_DefeatFragmentSetMotion:
                lsr.w   #1,d0
                addi.b  #$2E,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$28,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

MGZBossSK_InitScaledFlyby:
                lea     MGZBossSK_ScaledFlybyAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MGZBossSK_FlybyCheckCancelAndMoveX,(a0)
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
                beq.s   MGZBossSK_FlybySetXAcceleration
                cmpi.w  #$C,d1
                beq.s   MGZBossSK_FlybySetXAcceleration
                moveq   #$10,d0

MGZBossSK_FlybySetXAcceleration:
                move.w  d0,$2E(a0)
                bra.w   MGZBossSK_FlybyRebuildArtAndQueueDMA
; ---------------------------------------------------------------------------

MGZBossSK_FlybyCheckCancelAndMoveX:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.w   MGZBossSK_FlybyDeleteWhenCanceled
                move.w  x_vel(a0),d0
                add.w   $2E(a0),d0
                cmpi.w  #-$100,d0
                bgt.s   MGZBossSK_FlybyChooseYAcceleration
                move.w  d0,x_vel(a0)

MGZBossSK_FlybyChooseYAcceleration:
                move.w  y_vel(a0),d0
                move.w  $3C(a0),d1
                bmi.s   MGZBossSK_FlybyApplyNegativeYAccel
                add.w   d1,d0
                cmpi.w  #$400,d0
                ble.s   MGZBossSK_FlybyStoreYSpeed
                bra.w   MGZBossSK_FlybyProjectAndTickScale
; ---------------------------------------------------------------------------

MGZBossSK_FlybyApplyNegativeYAccel:
                add.w   d1,d0
                cmpi.w  #-$400,d0
                blt.s   MGZBossSK_FlybyProjectAndTickScale

MGZBossSK_FlybyStoreYSpeed:
                move.w  d0,y_vel(a0)

; Update the scale only on every fourth V-int tick
MGZBossSK_FlybyProjectAndTickScale:
                jsr     (IntegrateScaledObjectCenter).l
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
                bne.s   MGZBossSK_FlybyCullUsingCenterX
                move.b  $40(a0),d0
                add.b   $3E(a0),d0
                andi.b  #$7F,d0
                cmpi.b  #4,d0
                blo.w   MGZBossSK_FlybyRebuildArtAndQueueDMA
                move.b  d0,$40(a0)

MGZBossSK_FlybyRebuildArtAndQueueDMA:
                jsr     (Perform_Art_Scaling).l

MGZBossSK_FlybyCullUsingCenterX:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

MGZBossSK_FlybyDeleteWhenCanceled:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

MGZBossSK_TickTransitionPalette:
                subq.w  #1,$2E(a0)
                bpl.w   MGZArrivalSK_SharedReturn
                moveq   #0,d0
                move.b  $39(a0),d0
                move.w  MGZBossSK_TransitionPaletteDelays(pc,d0.w),$2E(a0)
                lsl.w   #4,d0
                lea     (Pal_MGZFadeCNZ).l,a1
                adda.w  d0,a1
                lea     (Normal_palette_line_4).w,a2
                moveq   #bytesToLcnt($20),d1

MGZBossSK_CopyTransitionPaletteRow:
                move.l  (a1)+,(a2)+
                dbf     d1,MGZBossSK_CopyTransitionPaletteRow
                addq.b  #2,$39(a0)
                cmpi.b  #$20,$39(a0)
                blo.w   MGZArrivalSK_SharedReturn

MGZBossSK_StartCarnivalNightAndDelete:
                move.w  #$300,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
MGZBossSK_TransitionPaletteDelays:
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
; ---------------------------------------------------------------------------

MGZBossSK_CollapseChooseDebrisBand:
                movea.w parent3(a0),a1
                move.w  (Camera_Y_pos).w,d0
                move.w  d0,d1
                moveq   #$18,d2
                addi.w  #$70,d0
                cmp.w   y_pos(a1),d0
                bge.s   MGZBossSK_CollapseStartDebrisCountdown
                move.w  #$C8,d2
                bset    #2,$38(a0)

MGZBossSK_CollapseStartDebrisCountdown:
                add.w   d2,d1
                move.w  d1,y_pos(a0)
                move.l  #Obj_Wait,(a0)
                move.b  #9,$39(a0)
                move.l  #MGZBossSK_CollapseTryDebrisSpawn,$34(a0)
                rts
; ---------------------------------------------------------------------------

MGZBossSK_CollapseTryDebrisSpawn:
                subq.b  #1,$39(a0)
                bmi.w   MGZBossSK_DeletePassEmitter
                move.w  #3,$2E(a0)
                lea     MGZBossSK_CollapseDebrisChild(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

MGZBossSK_InitRandomCollapseDebris:
                lea     MGZBossSK_ArrivalDebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MGZBossSK_CollapseDebrisFallAndCull,(a0)
                bsr.w   MGZCollapseDebris_RandomizeMotion

MGZBossSK_CollapseDebrisFallAndCull:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l

; =============== S U B R O U T I N E =======================================

; Randomize the frame and signed X velocity. The lower emitter can also give a large upward launch
MGZCollapseDebris_RandomizeMotion:
                jsr     (Random_Number).l
                move.w  d0,d1
                andi.w  #3,d0
                move.b  MGZBossSK_CollapseDebrisRandomFrames(pc,d0.w),mapping_frame(a0)
                andi.w  #$3FF,d1
                btst    #0,d1
                beq.s   MGZBossSK_CollapseDebrisSetXAndCheckY
                neg.w   d1

; Randomize Y speed only in the lower debris band
MGZBossSK_CollapseDebrisSetXAndCheckY:
                move.w  d1,x_vel(a0)
                swap    d0
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   MGZBossSK_CollapseDebrisMotionReturn
                andi.w  #$1FF,d0
                addi.w  #$200,d0
                btst    #0,d0
                beq.s   MGZBossSK_CollapseDebrisStoreYSpeed
                neg.w   d0

MGZBossSK_CollapseDebrisStoreYSpeed:
                move.w  d0,y_vel(a0)

MGZBossSK_CollapseDebrisMotionReturn:
                rts
; End of function MGZCollapseDebris_RandomizeMotion

; ---------------------------------------------------------------------------
MGZBossSK_CollapseDebrisRandomFrames:
                dc.b    0,   1,   2,   0
                even
