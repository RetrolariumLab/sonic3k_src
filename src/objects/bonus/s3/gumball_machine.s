; Owner: objects/bonus/s3
; Responsibility: Gumball bonus machine state, dispensers, item creation and sprite motion
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_GumballMachine:
                lea     ObjDat_GumballMachine(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #S3Gumball_DescendAndCheckActivation,(a0)
                move.w  a0,(SceneControllerObjectAddress).w
                subi.w  #$100,y_pos(a0)
                move.w  y_pos(a0),$3A(a0)
                st      (Disable_death_plane).w
                move.l  (V_int_run_count).w,(RNG_seed).w
                move.w  (Saved_ring_count).w,(Ring_count).w
                move.b  (Saved_extra_life_flags).w,(Extra_life_flags).w
                move.b  #1,(Update_HUD_ring_count).w
                bset    #7,(Player_1+art_tile).w
                bset    #7,(Player_2+art_tile).w
                lea     ((RAM_start+$2000)&$FFFFFF).l,a1
                moveq   #-1,d0
                moveq   #bytesToLcnt($24),d1

S3Gumball_InitBumpersAndPlatformGate:
                move.l  d0,(a1)+
                dbf     d1,S3Gumball_InitBumpersAndPlatformGate
                lea     S3Gumball_MachineChildRecords(pc),a2
                jsr     (CreateChild1_Normal).l

S3Gumball_DescendAndCheckActivation:
                bsr.w   S3GumballMachine_UpdateDescent
                lea     S3Gumball_MachineActivationBounds(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                bne.s   S3Gumball_LatchActivationAndSelectFlip
                swap    d0
                tst.w   d0
                beq.s   S3Gumball_DrawIdleMachine

S3Gumball_LatchActivationAndSelectFlip:
                move.l  #S3Gumball_AnimateActivationAndDescend,(a0)
                move.l  #S3Gumball_SetMechanismActive,$34(a0)
                bset    #1,$38(a0)
                movea.w d0,a1
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                scs     d1
                tst.w   y_vel(a1)
                bmi.s   S3Gumball_StoreMachineFlip
                not.b   d1

S3Gumball_StoreMachineFlip:
                bclr    #0,render_flags(a0)
                tst.b   d1
                beq.s   S3Gumball_RequestMachineTabSoundAndDraw
                bset    #0,render_flags(a0)

S3Gumball_RequestMachineTabSoundAndDraw:
                moveq   #signextendB(sfx_GumballTab),d0
                jsr     (Play_SFX).l

S3Gumball_DrawIdleMachine:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
S3Gumball_MachineActivationBounds:
                dc.w    -$24,   $48,    -8,   $10
; ---------------------------------------------------------------------------

S3Gumball_AnimateActivationAndDescend:
                bsr.w   S3GumballMachine_UpdateDescent
                lea     S3Gumball_MachineActivationAnim(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Gumball_SetMechanismActive:
                move.l  #S3Gumball_DescendUntilMechanismUnlocks,(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

S3Gumball_DescendUntilMechanismUnlocks:
                bsr.w   S3GumballMachine_UpdateDescent
                btst    #1,$38(a0)
                bne.s   S3Gumball_DrawActiveMachine
                move.l  #S3Gumball_DescendAndCheckActivation,(a0)

S3Gumball_DrawActiveMachine:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Gumball_InitPlatformAndFourSprings:
                lea     S3Gumball_RefillablePlatformAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #$100,x_pos(a0)
                move.w  #$310,y_pos(a0)
                lea     S3Gumball_PlatformSpringChildRecords(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #S3Gumball_CollideAndDrawLivePlatform,(a0)

S3Gumball_CollideAndDrawLivePlatform:
                btst    #1,$38(a0)
                bne.s   S3Gumball_SpawnDebrisAndRetirePlatform
                lea     (SolidObjectFull).l,a1
                bsr.w   S3GumballPlatform_CallSolidity
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Gumball_SpawnDebrisAndRetirePlatform:
                clr.b   ((RAM_start+$2022)&$FFFFFF).l
                lea     S3Gumball_PlatformDebrisChildRecords(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

S3Gumball_InitAndCheckSpringP1:
                lea     S3Gumball_FiniteUpSpringFullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #-$1000,$30(a0)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   S3Gumball_StartFallingSpringAndFlagRoot
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                jsr     (SolidObjectFull2_1P).l
                btst    #p1_standing_bit,status(a0)
                beq.s   S3Gumball_CheckSpringP2
                bset    #5,$38(a0)
                jsr     (LaunchPlayerFromUpSpring).l

S3Gumball_CheckSpringP2:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                jsr     (SolidObjectFull2_1P).l
                btst    #p2_standing_bit,status(a0)
                beq.s   S3Gumball_AnimateSpringAndCheckRetire
                jsr     (LaunchPlayerFromUpSpring).l

; Only the P1 launch sets the latch that can retire the platform
S3Gumball_AnimateSpringAndCheckRetire:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                btst    #5,$38(a0)
                beq.s   S3Gumball_DrawPlatformSpring
                cmpi.b  #1,prev_anim(a0)
                bne.s   S3Gumball_DrawPlatformSpring

S3Gumball_StartFallingSpringAndFlagRoot:
                move.l  #MoveChkDel,(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

S3Gumball_DrawPlatformSpring:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Gumball_InitMechanismBody:
                lea     S3Gumball_MechanismBodyAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #S3Gumball_BeginBodyCycleAndTryItem,(a0)

S3Gumball_BeginBodyCycleAndTryItem:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   S3Gumball_FollowRootAndDrawBody
                move.l  #S3Gumball_AnimateBodyCycleAndDraw,(a0)
                move.l  #S3Gumball_ResetBodyAndUnlockRoot,$34(a0)
                lea     S3Gumball_OneSimpleDispensedRewardChild(pc),a2
                jsr     (CreateChild6_Simple).l

S3Gumball_FollowRootAndDrawBody:
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Gumball_AnimateBodyCycleAndDraw:
                lea     S3Gumball_BodyCycleCallbackAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Gumball_ResetBodyAndUnlockRoot:
                move.l  #S3Gumball_BeginBodyCycleAndTryItem,(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                bclr    #3,$38(a1)

S3Gumball_BodyCallbackReturn:
                rts
; ---------------------------------------------------------------------------

S3Gumball_InitWeightedRewardItem:
                lea     S3Gumball_RewardItemAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #S3Gumball_IncreaseItemYSpeedTo200,(a0)
                bsr.w   S3GumballMachine_ChooseDrop

; Reject the candidate above $200 using an unsigned comparison
S3Gumball_IncreaseItemYSpeedTo200:
                move.w  y_vel(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$200,d0
                bhi.s   S3Gumball_MoveItemAndClampToBodyFloor
                move.w  d0,y_vel(a0)

S3Gumball_MoveItemAndClampToBodyFloor:
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                cmp.w   y_pos(a0),d0
                bls.s   S3Gumball_CheckRewardBelowBody
                move.w  d0,y_pos(a0)
                bra.w   S3Gumball_CullOrAnimateRewardItem
; ---------------------------------------------------------------------------

S3Gumball_CheckRewardBelowBody:
                addi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                bhi.s   S3Gumball_CullOrAnimateRewardItem
                jsr     (S3Gumball_TryRewardNearbyPlayer).l
                bne.s   S3Gumball_DeleteRewardItem

S3Gumball_CullOrAnimateRewardItem:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$240,d0
                cmp.w   y_pos(a0),d0
                blo.s   S3Gumball_DeleteRewardItem
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Gumball_DeleteRewardItem:
                jmp     (Delete_Current_Sprite).l
