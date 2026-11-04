; Owner: objects/level_end/s3
; Responsibility: Egg capsule state machine, release children, ending poses and freed-animal movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_EggCapsule:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  EggCapsule_Index(pc,d0.w),d1
                move.w  x_pos(a0),-(sp)
                jsr     EggCapsule_Index(pc,d1.w)
                moveq   #$2B,d1
                moveq   #$18,d2
                moveq   #$18,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                jmp     S3Capsule_CoarseCullOrDraw(pc)
; ---------------------------------------------------------------------------
EggCapsule_Index:
                dc.w    S3EggCapsule_InitAndChooseChildren-EggCapsule_Index
                dc.w    S3EggCapsule_TryOpenFromGroundButton-EggCapsule_Index
                dc.w    S3EggCapsule_WaitForGroundResults-EggCapsule_Index
                dc.w    S3EggCapsule_TryGroundP2EndPose-EggCapsule_Index
                dc.w    S3EggCapsule_CheckFloatXBounds-EggCapsule_Index
                dc.w    S3EggCapsule_TryP1ResultsAndSwing-EggCapsule_Index
                dc.w    S3EggCapsule_TryP2PoseAndSwing-EggCapsule_Index
                dc.w    S3EggCapsule_TryCarryResultsAndSwing-EggCapsule_Index
; ---------------------------------------------------------------------------

S3EggCapsule_InitAndChooseChildren:
                lea     ObjDat_EggCapsule(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                btst    #1,render_flags(a0)
                bne.s   S3EggCapsule_InitFloatingAtCamera
                lea     S3Capsule_GroundButtonChildList(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

S3EggCapsule_InitFloatingAtCamera:
                move.b  #8,routine(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                move.w  d0,x_pos(a0)
                move.w  d0,$3E(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$40,d0
                move.w  d0,y_pos(a0)
                move.w  #1,$3A(a0)
                jsr     (Swing_Setup1).l
                lea     S3Capsule_InvertedButtonChildList(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     S3Capsule_TwoAnimatedFollowerChildList(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

S3EggCapsule_TryOpenFromGroundButton:
                btst    #1,$38(a0)
                beq.s   S3EggCapsule_OpenReturn
                move.b  #4,routine(a0)

; =============== S U B R O U T I N E =======================================

; Set the opened state, conditionally lock Player 2 input and request fragments, animals and an explosion
S3Capsule_OpenAndSpawnEffects:
                cmpi.b  #2,(Current_zone).w
                beq.s   S3EggCapsule_SpawnOpenChildren
                st      (Ctrl_2_locked).w

; Write subtype 8 through a1 immediately after requesting the explosion
S3EggCapsule_SpawnOpenChildren:
                move.b  #1,mapping_frame(a0)
                move.w  #$40,$2E(a0)
                lea     S3Capsule_FiveReleasedFragmentChildList(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     S3Capsule_NineAnimalRequests(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                move.b  #8,subtype(a1)

S3EggCapsule_OpenReturn:
                rts
; End of function S3Capsule_OpenAndSpawnEffects

; ---------------------------------------------------------------------------

S3EggCapsule_WaitForGroundResults:
                move.b  #6,d0
                bra.w   S3Capsule_TryResultsOnLanding
; ---------------------------------------------------------------------------

S3EggCapsule_TryGroundP2EndPose:
                bra.w   Check_TailsEndPose
; ---------------------------------------------------------------------------

S3EggCapsule_CheckFloatXBounds:
                move.w  (Camera_X_pos).w,d0
                move.w  $3A(a0),d1
                bmi.s   S3EggCapsule_CheckFloatLeftBound
                addi.w  #$110,d0
                cmp.w   x_pos(a0),d0
                blo.s   S3EggCapsule_ReverseFloatXStep
                bra.w   S3EggCapsule_StepFloatXAndPickY
; ---------------------------------------------------------------------------

S3EggCapsule_CheckFloatLeftBound:
                addi.w  #$30,d0
                cmp.w   x_pos(a0),d0
                blo.s   S3EggCapsule_StepFloatXAndPickY

S3EggCapsule_ReverseFloatXStep:
                neg.w   d1

S3EggCapsule_StepFloatXAndPickY:
                move.w  d1,$3A(a0)
                add.w   d1,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$40,d0
                cmpi.b  #2,(Current_zone).w
                bne.s   S3EggCapsule_PickFloatYDrift
                subi.w  #$20,d0

; Drift a quarter pixel per update. At the target Y, take the upward step
S3EggCapsule_PickFloatYDrift:
                move.l  #$4000,d1
                cmp.w   y_pos(a0),d0
                bhi.s   S3EggCapsule_DriftAndCheckOpenLatch
                neg.l   d1

S3EggCapsule_DriftAndCheckOpenLatch:
                add.l   d1,y_pos(a0)
                btst    #1,$38(a0)
                beq.s   S3EggCapsule_SwingAndMoveFloat
                move.b  #$A,routine(a0)
                cmpi.b  #2,(Current_zone).w
                bne.s   S3EggCapsule_OpenFloating
                move.b  #$E,routine(a0)

; Save the current a1 word before calling the shared opening routine
S3EggCapsule_OpenFloating:
                move.w  a1,$44(a0)
                bsr.w   S3Capsule_OpenAndSpawnEffects

S3EggCapsule_SwingAndMoveFloat:
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3EggCapsule_TryP1ResultsAndSwing:
                move.b  #$C,d0
                bsr.w   S3Capsule_TryResultsOnLanding
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3EggCapsule_TryP2PoseAndSwing:
                bsr.w   Check_TailsEndPose
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3EggCapsule_TryCarryResultsAndSwing:
                move.b  #$C,d0
                bsr.w   S3Capsule_TryAirborneResults
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3EggCapsule_InitGroundButton:
                move.l  #S3EggCapsule_CheckGroundButtonPress,(a0)
                lea     S3Capsule_SharedButtonPartialAttributes(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

S3EggCapsule_CheckGroundButtonPress:
                bsr.w   CapsuleS3ResolveGroundButtonSolid
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   S3EggCapsule_DrawGroundButton
                move.l  #S3EggCapsule_DrawPressedGroundButton,(a0)
                addq.w  #8,y_pos(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

S3EggCapsule_DrawGroundButton:
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

S3EggCapsule_DrawPressedGroundButton:
                bsr.w   CapsuleS3ResolveGroundButtonSolid
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

S3EggCapsule_InitInvertedPlunger:
                move.l  #S3EggCapsule_CheckInvertedPlungerPress,(a0)
                bset    #1,render_flags(a0)
                lea     S3Capsule_SharedButtonPartialAttributes(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

S3EggCapsule_CheckInvertedPlungerPress:
                jsr     Refresh_ChildPosition(pc)
                moveq   #6,d2
                bsr.w   S3EggCapsule_ResolveButtonSolid
                lea     S3EggCapsule_PlungerPlayerRect(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   S3EggCapsule_DrawInvertedPlunger
                tst.w   d0
                beq.s   S3EggCapsule_TryPackedP2PlungerHit
                movea.w d0,a1
                tst.w   y_vel(a1)
                bpl.s   S3EggCapsule_TryPackedP2PlungerHit
                cmpi.b  #2,anim(a1)
                beq.s   S3EggCapsule_LatchPlungerAndShift
                cmpi.b  #1,character_id(a1)
                beq.s   S3EggCapsule_LatchPlungerAndShift

; Swap the packed handles and test Y velocity through the upper handle directly
S3EggCapsule_TryPackedP2PlungerHit:
                swap    d0
                movea.w d0,a1
                tst.w   y_vel(a1)
                bpl.s   S3EggCapsule_DrawInvertedPlunger

S3EggCapsule_LatchPlungerAndShift:
                move.l  #S3EggCapsule_UpdatePressedPlunger,(a0)
                subq.b  #8,child_dy(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

S3EggCapsule_DrawInvertedPlunger:
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------
S3EggCapsule_PlungerPlayerRect:
                dc.w    -$1A,   $34,  -$1C,   $38
; ---------------------------------------------------------------------------

S3EggCapsule_UpdatePressedPlunger:
                jsr     Refresh_ChildPosition(pc)
                moveq   #5,d2
                bsr.w   S3EggCapsule_ResolveButtonSolid
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

S3EggCapsule_InitFragmentArt:
                lea     S3Capsule_ReleasedFragmentFullAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                cmpi.w  #$400,(Current_zone_and_act).w
                bne.s   S3EggCapsule_StartFragmentFlicker
                move.w  #make_art_tile(ArtTile_EggCapsule-$46,0,0),art_tile(a0)

S3EggCapsule_StartFragmentFlicker:
                move.l  #Obj_FlickerMove,(a0)
                bsr.w   CapsuleS3SelectFragmentFrameFromSubtype
                moveq   #4,d0
                jsr     Set_IndexedVelocity(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3EggCapsule_InitAnimatedFollower:
                lea     S3Capsule_AnimatedFollowerAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #S3EggCapsule_AnimateFollower,(a0)

S3EggCapsule_AnimateFollower:
                jsr     Refresh_ChildPosition(pc)
                lea     S3Capsule_AnimatedFollowerRawLoop(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

S3EggCapsule_InitFreedAnimal:
                lea     S3Capsule_FreedAnimalPartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #S3EggCapsule_WaitForGroundAnimal,(a0)
                move.b  #8,y_radius(a0)
                bsr.w   S3CapsuleAnimal_InitRelease
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3EggCapsule_WaitForGroundAnimal:
                subq.w  #1,$2E(a0)
                bpl.s   S3EggCapsule_DrawWaitingGroundAnimal
                move.l  #S3EggCapsule_MoveAndBounceAnimal,(a0)
                move.w  #$80,priority(a0)

S3EggCapsule_DrawWaitingGroundAnimal:
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

S3EggCapsule_MoveAndBounceAnimal:
                jsr     MoveSprite_LightGravity(pc)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   S3EggCapsule_PickAnimalFrame
                add.w   d1,y_pos(a0)
                move.w  $3E(a0),y_vel(a0)
                jsr     Find_SonicTails(pc)
                move.w  #-$200,d1
                tst.b   (_unkFAA8).w
                beq.s   S3EggCapsule_SetAnimalBounceXVel
                tst.w   d0
                beq.s   S3EggCapsule_SetAnimalBounceXVel
                neg.w   d1

S3EggCapsule_SetAnimalBounceXVel:
                move.w  d1,x_vel(a0)
                bsr.w   S3CapsuleAnimal_SetFacingFromXVel

; V-int count bit 3 set selects frame 0. Clear selects frame 1
S3EggCapsule_PickAnimalFrame:
                moveq   #0,d0
                btst    #3,(V_int_run_count+3).w
                bne.s   S3EggCapsule_StoreAndDrawAnimalFrame
                moveq   #1,d0

S3EggCapsule_StoreAndDrawAnimalFrame:
                move.b  d0,mapping_frame(a0)
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

S3EggCapsule_WaitWithFloatingParent:
                jsr     Refresh_ChildPosition(pc)
                subq.w  #1,$2E(a0)
                bpl.s   S3EggCapsule_DrawWaitingFloatAnimal
                move.l  #S3EggCapsule_ChaseP1OrLeaveLeft,(a0)
                move.w  #$80,priority(a0)

S3EggCapsule_DrawWaitingFloatAnimal:
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

S3EggCapsule_ChaseP1OrLeaveLeft:
                lea     (Player_1).w,a1
                move.w  #$300,d0
                move.w  #$100,d1
                moveq   #$10,d2
                move.w  #0,d3
                move.w  #-$30,d4
                sub.b   subtype(a0),d4
                bsr.w   S3CapsuleAnimal_SteerTowardP1
                jsr     (MoveSprite2).l
                bsr.w   S3CapsuleAnimal_SetFacingFromXVel
                tst.b   (_unkFAA8).w
                bne.s   S3EggCapsule_DrawAnimalAfterChase
                move.l  #S3EggCapsule_MoveDepartingAnimalLeft,(a0)
                bset    #0,render_flags(a0)

S3EggCapsule_DrawAnimalAfterChase:
                bra.s   S3EggCapsule_PickAnimalFrame
; ---------------------------------------------------------------------------

; Subtract two pixels from the integer X position without integrating velocity
S3EggCapsule_MoveDepartingAnimalLeft:
                subq.w  #2,x_pos(a0)
                bra.s   S3EggCapsule_PickAnimalFrame

; =============== S U B R O U T I N E =======================================

; After the opening delay, check Player 1 landing, freeze the ending pose and attempt the results actor once
S3Capsule_TryResultsOnLanding:
                subq.w  #1,$2E(a0)
                bpl.s   S3EggCapsule_P1ResultsReturn
                lea     (Player_1).w,a1
                btst    #7,status(a1)
                bne.s   S3EggCapsule_P1ResultsReturn
                btst    #Status_InAir,status(a1)
                bne.s   S3EggCapsule_P1ResultsReturn
                cmpi.b  #6,routine(a1)
                bhs.s   S3EggCapsule_P1ResultsReturn
                move.b  d0,routine(a0)
                bsr.w   Set_PlayerEndingPose
                jsr     (AllocateObject).l
                bne.s   S3EggCapsule_P1ResultsReturn
                move.l  #Obj_LevelResults,(a1)

S3EggCapsule_P1ResultsReturn:
                rts
; End of function S3Capsule_TryResultsOnLanding

; =============== S U B R O U T I N E =======================================

Check_TailsEndPose:
                tst.b   (_unkFAA8).w
                beq.w   S3EggCapsule_OpenReturn
                cmpi.b  #3,(Current_zone).w
                bne.s   S3EggCapsule_TryLatchP2EndPose
                lea     (Player_1).w,a1
                bsr.w   Set_PlayerEndingPose

S3EggCapsule_TryLatchP2EndPose:
                btst    #7,$38(a0)
                bne.w   S3EggCapsule_OpenReturn
                lea     (Player_2).w,a1
                btst    #7,status(a1)
                bne.w   S3EggCapsule_OpenReturn
                btst    #Status_InAir,status(a1)
                bne.w   S3EggCapsule_OpenReturn
                cmpi.b  #6,routine(a1)
                bhs.w   S3EggCapsule_OpenReturn
                bset    #7,$38(a0)
                clr.b   (Ctrl_2_locked).w
                jmp     Set_PlayerEndingPose(pc)
; End of function Check_TailsEndPose

; =============== S U B R O U T I N E =======================================

; After the wait, visible live Player 1 Tails or a carried Player 1 can start results before the grounded ending pose
S3Capsule_TryAirborneResults:
                subq.w  #1,$2E(a0)
                bpl.s   S3EggCapsule_CarryResultsReturn
                lea     (Player_1).w,a1
                cmpi.b  #6,routine(a1)
                bhs.s   S3EggCapsule_CarryResultsReturn
                tst.b   render_flags(a1)
                bpl.s   S3EggCapsule_CarryResultsReturn
                cmpi.b  #1,$38(a1)
                beq.s   S3EggCapsule_StartCarryResultsAndDrift
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3EggCapsule_CarryResultsReturn

S3EggCapsule_StartCarryResultsAndDrift:
                move.w  #-$100,x_vel(a0)
                move.b  d0,routine(a0)
                jsr     (AllocateObject).l
                bne.s   S3EggCapsule_CarryResultsReturnOne
                move.l  #Obj_LevelResults,(a1)

S3EggCapsule_CarryResultsReturnOne:
                moveq   #1,d0

S3EggCapsule_CarryResultsReturn:
                rts
; End of function S3Capsule_TryAirborneResults

; =============== S U B R O U T I N E =======================================

Set_PlayerEndingPose:
                move.b  #$81,object_control(a1)
                move.b  #$13,anim(a1)
                clr.b   spin_dash_flag(a1)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                bclr    #5,status(a0)
                bclr    #Status_Push,status(a1)
                rts
; End of function Set_PlayerEndingPose

; =============== S U B R O U T I N E =======================================

; Aim at Player 1 plus the supplied offsets. Retain the asymmetric retry for out-of-range negative Y velocity
S3CapsuleAnimal_SteerTowardP1:
                move.w  d2,d5
                move.w  x_pos(a1),d6
                add.w   d3,d6
                cmp.w   x_pos(a0),d6
                bhs.s   S3EggCapsule_CheckChaseXVel
                neg.w   d2

; Negate d0 for the lower bound only after the upper check passes
S3EggCapsule_CheckChaseXVel:
                move.w  x_vel(a0),d6
                add.w   d2,d6
                cmp.w   d0,d6
                bgt.s   S3EggCapsule_PickChaseYAccel
                neg.w   d0
                cmp.w   d0,d6
                blt.s   S3EggCapsule_PickChaseYAccel
                move.w  d6,x_vel(a0)

; A retry starts here with d5 and d1 as left by the prior attempt
S3EggCapsule_PickChaseYAccel:
                move.w  y_pos(a1),d6
                add.w   d4,d6
                cmp.w   y_pos(a0),d6
                bhs.s   S3EggCapsule_CheckChaseYVel
                neg.w   d5

; An upper overflow returns. A lower overflow retries target-side selection
S3EggCapsule_CheckChaseYVel:
                move.w  y_vel(a0),d6
                add.w   d5,d6
                cmp.w   d1,d6
                bgt.s   S3EggCapsule_ChaseYVelReturn
                neg.w   d1
                cmp.w   d1,d6
                blt.s   S3EggCapsule_PickChaseYAccel
                move.w  d6,y_vel(a0)

S3EggCapsule_ChaseYVelReturn:
                rts
; End of function S3CapsuleAnimal_SteerTowardP1

; ---------------------------------------------------------------------------
; unused
                moveq   #$2B,d1
                moveq   #$18,d2
                moveq   #$18,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l

; =============== S U B R O U T I N E =======================================

CapsuleS3ResolveGroundButtonSolid:
                moveq   #8,d2

; This entry takes the upper extent from d2
S3EggCapsule_ResolveButtonSolid:
                moveq   #$1B,d1
                moveq   #9,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function CapsuleS3ResolveGroundButtonSolid

; =============== S U B R O U T I N E =======================================

CapsuleS3SelectFragmentFrameFromSubtype:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  S3EggCapsule_FragmentFrameSelectorBytes(pc,d0.w),mapping_frame(a0)
                rts
; End of function CapsuleS3SelectFragmentFrameFromSubtype

; ---------------------------------------------------------------------------
S3EggCapsule_FragmentFrameSelectorBytes:
                dc.b    2,   3,  $A,   4,  $B
                even

; =============== S U B R O U T I N E =======================================

; Set species, bounce, delay and escape direction. Inverted capsules use attachment followed by homing
S3CapsuleAnimal_InitRelease:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                andi.w  #6,d0
                lea     S3EggCapsule_AnimalBounceYVel(pc),a1
                move.w  (a1,d0.w),d2
                move.w  d2,y_vel(a0)
                move.w  d2,$3E(a0)
                movea.w parent3(a0),a1
                btst    #1,render_flags(a1)
                beq.s   S3EggCapsule_PickAnimalArtIndex
                move.l  #S3EggCapsule_WaitWithFloatingParent,(a0)
                addq.b  #8,child_dy(a0)
                clr.w   y_vel(a0)

S3EggCapsule_PickAnimalArtIndex:
                andi.w  #2,d0
                move.w  d0,d2
                cmpi.w  #$400,(Current_zone_and_act).w
                bne.s   S3EggCapsule_LoadAnimalArtAndDelay
                addq.w  #4,d2

S3EggCapsule_LoadAnimalArtAndDelay:
                move.w  S3EggCapsule_AnimalArtTiles(pc,d2.w),art_tile(a0)
                moveq   #0,d2
                move.b  (Current_zone).w,d2
                add.w   d2,d2
                lea     (S3Animal_ZoneSpeciesPairs).l,a1
                adda.w  d2,a1
                lsr.w   #1,d0
                move.b  (a1,d0.w),d0
                lsl.w   #3,d0
                lea     (S3Animal_DefaultSpeciesRecords).l,a2
                move.l  4(a2,d0.w),mappings(a0)
                lsl.w   #2,d1
                move.w  d1,$2E(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a0),d0
                move.w  #$200,d1
                cmp.w   x_pos(a1),d0
                bhs.s   S3EggCapsule_SetInitialAnimalXVel
                neg.w   d1

S3EggCapsule_SetInitialAnimalXVel:
                move.w  d1,x_vel(a0)
                bsr.w   S3CapsuleAnimal_SetFacingFromXVel
                rts
; End of function S3CapsuleAnimal_InitRelease

; ---------------------------------------------------------------------------
S3EggCapsule_AnimalBounceYVel:
                dc.w    -$380, -$300, -$280, -$200
S3EggCapsule_AnimalArtTiles:
                dc.w    make_art_tile(ArtTile_Animals1,0,1)
                dc.w    make_art_tile(ArtTile_Animals2,0,1)
                dc.w    make_art_tile(ArtTile_FBZAnimals1,0,1)
                dc.w    make_art_tile(ArtTile_FBZAnimals2,0,1)

; =============== S U B R O U T I N E =======================================

S3CapsuleAnimal_SetFacingFromXVel:
                bclr    #0,render_flags(a0)
                tst.w   x_vel(a0)
                bpl.s   S3EggCapsule_AnimalFacingReturn
                bset    #0,render_flags(a0)

S3EggCapsule_AnimalFacingReturn:
                rts
; End of function S3CapsuleAnimal_SetFacingFromXVel
