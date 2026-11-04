; Owner: objects/bosses/hcz/miniboss/sk
; Responsibility: Hydrocity miniboss rocket actors, flight states and attack behavior
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZMiniboss_Rockets:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZMiniboss_Rockets_Index(pc,d0.w),d1
                jsr     HCZMiniboss_Rockets_Index(pc,d1.w)
                moveq   #$20,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
HCZMiniboss_Rockets_Index:
                dc.w    HCZMiniSK_InitRocketAndSpawnTip-HCZMiniboss_Rockets_Index
                dc.w    HCZMiniSK_RocketWaitRequestAndInit-HCZMiniboss_Rockets_Index
                dc.w    HCZMiniSK_RocketTwistAndTickInitial-HCZMiniboss_Rockets_Index
                dc.w    HCZMiniSK_RocketTickStationaryWait-HCZMiniboss_Rockets_Index
                dc.w    HCZMiniSK_RocketTwistAndTickShared-HCZMiniboss_Rockets_Index
                dc.w    HCZMiniSK_RocketFastTwistUntilRelease-HCZMiniboss_Rockets_Index
                dc.w    HCZMiniSK_RocketTwistToReturnAngle-HCZMiniboss_Rockets_Index
; ---------------------------------------------------------------------------

HCZMiniSK_InitRocketAndSpawnTip:
                lea     ObjDat_HCZMiniboss_Rockets(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #6,$38(a0)
                lea     HCZMiniSK_RocketTipChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZMiniSK_RocketWaitRequestAndInit:
                clr.b   collision_flags(a0)
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.w   HCZMiniSK_SharedReturn
                move.b  #4,routine(a0)
                move.b  #1,$40(a0)
                move.w  #$3F,$2E(a0)
                move.l  #HCZMiniSK_RocketBeginSharedTwist,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  HCZMiniSK_RocketInitialPhasePairs(pc,d0.w),$3C(a0)
                cmpi.b  #4,d0
                blo.s   HCZMiniSK_RocketInitPhaseReturn
                bset    #0,render_flags(a0)
                move.b  #6,routine(a0)

HCZMiniSK_RocketInitPhaseReturn:
                rts
; ---------------------------------------------------------------------------
; Each word holds two phase bytes selected by the even subtype
HCZMiniSK_RocketInitialPhasePairs:
                dc.w    0, $8080, $8000,   $80
; ---------------------------------------------------------------------------

HCZMiniSK_RocketTwistAndTickInitial:
                bsr.w   UpdateHCZMinibossRocketTwistPose
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZMiniSK_RocketBeginSharedTwist:
                move.b  #8,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #HCZMiniSK_RocketEnableTwistCollision,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_RocketTickStationaryWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZMiniSK_RocketResumeRequestPoll:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_RocketTwistAndTickShared:
                bsr.w   UpdateHCZMinibossRocketTwistPose
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZMiniSK_RocketEnableTwistCollision:
                move.b  #2,$40(a0)
                move.b  #$8B,collision_flags(a0)
                move.w  #$1F,$2E(a0)
                move.l  #HCZMiniSK_RocketBeginFastTwist,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_RocketBeginFastTwist:
                move.b  #$A,routine(a0)
                move.b  #4,$40(a0)
                move.l  #HCZMiniSK_RocketBeginReturnAlignment,$34(a0)
                bclr    #6,$38(a0)
                moveq   #signextendB(sfx_LevelProjectile),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_RocketArmReturnDelay:
                move.b  #2,$40(a0)
                move.w  #$1F,$2E(a0)
                move.l  #HCZMiniSK_RocketChooseReturnPhase,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_RocketChooseReturnPhase:
                move.b  #6,routine(a0)
                cmpi.b  #4,subtype(a0)
                blo.s   HCZMiniSK_RocketResetStepAndDelay
                move.b  #4,routine(a0)

HCZMiniSK_RocketResetStepAndDelay:
                move.b  #1,$40(a0)
                move.w  #$3F,$2E(a0)
                move.l  #HCZMiniSK_RocketResumeRequestPoll,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_RocketFastTwistUntilRelease:
                bsr.w   UpdateHCZMinibossRocketTwistPose
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.w   HCZMiniSK_SharedReturn

HCZMiniSK_RocketBeginReturnAlignment:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

; Wait for the exact X phase assigned to this subtype before retracting
HCZMiniSK_RocketTwistToReturnAngle:
                bsr.w   UpdateHCZMinibossRocketTwistPose
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  HCZMiniSK_RocketReturnXPhases(pc,d0.w),d1
                cmp.b   $3C(a0),d1
                beq.s   HCZMiniSK_RocketDisableAndRetract
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_RocketDisableAndRetract:
                move.b  #8,routine(a0)
                clr.b   collision_flags(a0)
                move.b  #2,$40(a0)
                move.w  #$1F,$2E(a0)
                move.l  #HCZMiniSK_RocketArmReturnDelay,$34(a0)
                bset    #6,$38(a0)
                rts
; ---------------------------------------------------------------------------
HCZMiniSK_RocketReturnXPhases:
                dc.b    $80,   0, $C0, $40
; ---------------------------------------------------------------------------

HCZMiniSK_InitRocketTip:
                lea     HCZMiniSK_RocketTipAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #HCZMiniSK_RocketTipFollowAndDraw,(a0)
                bset    #4,shield_reaction(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniSK_RocketTipFollowAndDraw:
                bsr.w   FollowHCZMinibossRocketTipPose

; Delete after parent defeat and skip drawing when the parent is inactive or the V-int counter is odd
HCZMiniSK_EngineOrTipCheckDraw:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   HCZMiniSK_EngineOrTipDelete
                btst    #6,$38(a1)
                bne.w   HCZMiniSK_SharedReturn
                btst    #0,(V_int_run_count+3).w
                bne.w   HCZMiniSK_SharedReturn
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniSK_EngineOrTipDelete:
                jmp     (Go_Delete_Sprite).l
