; Owner: objects/bonus/gumball/sk
; Responsibility: Gumball machine controller, item mechanism and bonus-stage completion state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_GumballMachine:
                lea     ObjDat_GumballMachine(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKGumball_DescendAndCheckActivation,(a0)
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

SKGumball_InitBumpersAndMachineChildren:
                move.l  d0,(a1)+
                dbf     d1,SKGumball_InitBumpersAndMachineChildren
                lea     SKGumball_MachineChildRecords(pc),a2
                jsr     (CreateChild1_Normal).l

SKGumball_DescendAndCheckActivation:
                bsr.w   SKGumballMachine_UpdateDescent
                lea     SKGumball_MachineActivationBounds(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                bne.s   SKGumball_LatchActivationAndSelectFlip
                swap    d0
                tst.w   d0
                beq.s   SKGumball_DrawIdleMachine

SKGumball_LatchActivationAndSelectFlip:
                move.l  #SKGumball_AnimateActivationAndDraw,(a0)
                move.l  #SKGumball_SetMechanismActive,$34(a0)
                bset    #1,$38(a0)
                movea.w d0,a1
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                scs     d1
                tst.w   y_vel(a1)
                bmi.s   SKGumball_StoreMachineFlip
                not.b   d1

SKGumball_StoreMachineFlip:
                bclr    #0,render_flags(a0)
                tst.b   d1
                beq.s   SKGumball_PlayActivationSound
                bset    #0,render_flags(a0)

SKGumball_PlayActivationSound:
                moveq   #signextendB(sfx_GumballTab),d0
                jsr     (Play_SFX).l

SKGumball_DrawIdleMachine:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
SKGumball_MachineActivationBounds:
                dc.w    -$24,   $48,    -8,   $10
; ---------------------------------------------------------------------------

SKGumball_AnimateActivationAndDraw:
                bsr.w   SKGumballMachine_UpdateDescent
                lea     SKGumball_MachineActivationAnim(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKGumball_SetMechanismActive:
                move.l  #SKGumball_DescendUntilMechanismUnlocks,(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKGumball_DescendUntilMechanismUnlocks:
                bsr.w   SKGumballMachine_UpdateDescent
                btst    #1,$38(a0)
                bne.s   SKGumball_DrawActiveMachine
                move.l  #SKGumball_DescendAndCheckActivation,(a0)

SKGumball_DrawActiveMachine:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKGumball_InitPlatformAndFourSprings:
                lea     SKGumball_PlatformAttributeDescriptor(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #$100,x_pos(a0)
                move.w  #$310,y_pos(a0)
                lea     SKGumball_PlatformSpringChildRecords(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #SKGumball_CollideAndDrawLivePlatform,(a0)

SKGumball_CollideAndDrawLivePlatform:
                btst    #1,$38(a0)
                bne.s   SKGumball_SpawnDebrisAndRetirePlatform
                lea     (SolidObjectFull).l,a1
                bsr.w   SKGumballPlatform_CallSolidity
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKGumball_SpawnDebrisAndRetirePlatform:
                clr.b   ((RAM_start+$2022)&$FFFFFF).l
                lea     SKGumball_PlatformDebrisChildRecord(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SKGumball_InitAndCheckSpringP1:
                lea     SKGumball_PlatformSpringAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #-$1000,$30(a0)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   SKGumball_StartFallingSpringAndFlagRoot
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                jsr     SolidObjectFull2_1P
                btst    #p1_standing_bit,status(a0)
                beq.s   SKGumball_CheckSpringP2
                bset    #5,$38(a0)
                jsr     (LaunchPlayerFromUpSpring).l

SKGumball_CheckSpringP2:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                jsr     SolidObjectFull2_1P
                btst    #p2_standing_bit,status(a0)
                beq.s   SKGumball_AnimateSpringAndCheckRetire
                jsr     (LaunchPlayerFromUpSpring).l

; Only the P1 launch sets the latch that can retire the platform
SKGumball_AnimateSpringAndCheckRetire:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                btst    #5,$38(a0)
                beq.s   SKGumball_DrawPlatformSpring
                cmpi.b  #1,prev_anim(a0)
                bne.s   SKGumball_DrawPlatformSpring

SKGumball_StartFallingSpringAndFlagRoot:
                move.l  #MoveChkDel,(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

SKGumball_DrawPlatformSpring:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKGumball_InitMechanismBody:
                lea     SKGumball_MechanismBodyAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKGumball_BeginBodyCycleAndTryItem,(a0)

SKGumball_BeginBodyCycleAndTryItem:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   SKGumball_FollowRootAndDrawBody
                move.l  #SKGumball_AnimateBodyCycleAndDraw,(a0)
                move.l  #SKGumball_ResetBodyAndUnlockRoot,$34(a0)
                lea     SKGumball_BodyRewardChildRecord(pc),a2
                jsr     (CreateChild6_Simple).l

SKGumball_FollowRootAndDrawBody:
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKGumball_AnimateBodyCycleAndDraw:
                lea     SKGumball_BodyCycleCallbackAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKGumball_ResetBodyAndUnlockRoot:
                move.l  #SKGumball_BeginBodyCycleAndTryItem,(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                bclr    #3,$38(a1)

SKGumball_BodyCallbackReturn:
                rts
; ---------------------------------------------------------------------------

SKGumball_InitWeightedRewardItem:
                lea     SKGumball_RewardItemAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKGumball_IncreaseItemYSpeedTo200,(a0)
                bsr.w   SKGumballMachine_ChooseDrop

; Reject the candidate above $200 using an unsigned comparison
SKGumball_IncreaseItemYSpeedTo200:
                move.w  y_vel(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$200,d0
                bhi.s   SKGumball_MoveItemAndClampToBodyFloor
                move.w  d0,y_vel(a0)

SKGumball_MoveItemAndClampToBodyFloor:
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                cmp.w   y_pos(a0),d0
                bls.s   SKGumball_CheckRewardBelowBody
                move.w  d0,y_pos(a0)
                bra.w   SKGumball_CullOrAnimateRewardItem
; ---------------------------------------------------------------------------

SKGumball_CheckRewardBelowBody:
                addi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                bhi.s   SKGumball_CullOrAnimateRewardItem
                jsr     (SKGumball_TryRewardNearbyPlayer).l
                bne.s   SKGumball_DeleteRewardItem

SKGumball_CullOrAnimateRewardItem:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$240,d0
                cmp.w   y_pos(a0),d0
                blo.s   SKGumball_DeleteRewardItem
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKGumball_DeleteRewardItem:
                jmp     (Delete_Current_Sprite).l
