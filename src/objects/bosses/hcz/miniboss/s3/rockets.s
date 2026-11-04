; Owner: objects/bosses/hcz/miniboss/s3
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
                dc.w    HCZMiniS3_InitRocketAndSpawnTip-HCZMiniboss_Rockets_Index
                dc.w    HCZMiniS3_RocketWaitRequestAndInit-HCZMiniboss_Rockets_Index
                dc.w    HCZMiniS3_RocketTwistAndTickInitial-HCZMiniboss_Rockets_Index
                dc.w    HCZMiniS3_RocketTickStationaryWait-HCZMiniboss_Rockets_Index
                dc.w    HCZMiniS3_RocketTwistAndTickShared-HCZMiniboss_Rockets_Index
                dc.w    HCZMiniS3_RocketFastTwistUntilRelease-HCZMiniboss_Rockets_Index
                dc.w    HCZMiniS3_RocketTwistToReturnAngle-HCZMiniboss_Rockets_Index
; ---------------------------------------------------------------------------

HCZMiniS3_InitRocketAndSpawnTip:
                lea     ObjDat_HCZMiniboss_Rockets(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #6,$38(a0)
                lea     HCZMiniS3_RocketTipChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HCZMiniS3_RocketWaitRequestAndInit:
                clr.b   collision_flags(a0)
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.w   HCZMiniS3_SharedReturn
                move.b  #4,routine(a0)
                move.b  #1,$40(a0)
                move.w  #$3F,$2E(a0)
                move.l  #HCZMiniS3_RocketBeginSharedTwist,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  HCZMiniS3_RocketInitialPhasePairs(pc,d0.w),$3C(a0)
                cmpi.b  #4,d0
                blo.s   HCZMiniS3_RocketInitPhaseReturn
                bset    #0,render_flags(a0)
                move.b  #6,routine(a0)

HCZMiniS3_RocketInitPhaseReturn:
                rts
; ---------------------------------------------------------------------------
; Each word holds two phase bytes selected by the even subtype
HCZMiniS3_RocketInitialPhasePairs:
                dc.w    0, $8080, $8000,   $80
; ---------------------------------------------------------------------------

HCZMiniS3_RocketTwistAndTickInitial:
                bsr.w   UpdateHCZMinibossRocketTwistPose
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZMiniS3_RocketBeginSharedTwist:
                move.b  #8,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #HCZMiniS3_RocketEnableTwistCollision,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_RocketTickStationaryWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZMiniS3_RocketResumeRequestPoll:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_RocketTwistAndTickShared:
                bsr.w   UpdateHCZMinibossRocketTwistPose
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

HCZMiniS3_RocketEnableTwistCollision:
                move.b  #2,$40(a0)
                move.b  #$8B,collision_flags(a0)
                move.w  #$1F,$2E(a0)
                move.l  #HCZMiniS3_RocketBeginFastTwist,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_RocketBeginFastTwist:
                move.b  #$A,routine(a0)
                move.b  #4,$40(a0)
                move.l  #HCZMiniS3_RocketBeginReturnAlignment,$34(a0)
                bclr    #6,$38(a0)
                moveq   #signextendB(sfx_LevelProjectile),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_RocketArmReturnDelay:
                move.b  #2,$40(a0)
                move.w  #$1F,$2E(a0)
                move.l  #HCZMiniS3_RocketChooseReturnPhase,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_RocketChooseReturnPhase:
                move.b  #6,routine(a0)
                cmpi.b  #4,subtype(a0)
                blo.s   HCZMiniS3_RocketResetStepAndDelay
                move.b  #4,routine(a0)

HCZMiniS3_RocketResetStepAndDelay:
                move.b  #1,$40(a0)
                move.w  #$3F,$2E(a0)
                move.l  #HCZMiniS3_RocketResumeRequestPoll,$34(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_RocketFastTwistUntilRelease:
                bsr.w   UpdateHCZMinibossRocketTwistPose
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.w   HCZMiniS3_SharedReturn

HCZMiniS3_RocketBeginReturnAlignment:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

; Wait for the exact X phase assigned to this subtype before retracting
HCZMiniS3_RocketTwistToReturnAngle:
                bsr.w   UpdateHCZMinibossRocketTwistPose
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  HCZMiniS3_RocketReturnXPhases(pc,d0.w),d1
                cmp.b   $3C(a0),d1
                beq.s   HCZMiniS3_RocketDisableAndRetract
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_RocketDisableAndRetract:
                move.b  #8,routine(a0)
                clr.b   collision_flags(a0)
                move.b  #2,$40(a0)
                move.w  #$1F,$2E(a0)
                move.l  #HCZMiniS3_RocketArmReturnDelay,$34(a0)
                bset    #6,$38(a0)
                rts
; ---------------------------------------------------------------------------
HCZMiniS3_RocketReturnXPhases:
                dc.b    $80,   0, $C0, $40
; ---------------------------------------------------------------------------

HCZMiniS3_InitRocketTip:
                lea     HCZMiniS3_RocketTipAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #HCZMiniS3_RocketTipFollowAndDraw,(a0)
                rts
; ---------------------------------------------------------------------------

HCZMiniS3_RocketTipFollowAndDraw:
                bsr.w   FollowHCZMinibossRocketTipPose

; Delete after parent defeat and skip drawing when the parent is inactive or the V-int counter is odd
HCZMiniS3_EngineOrTipCheckDraw:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   HCZMiniS3_EngineOrTipDelete
                btst    #6,$38(a1)
                bne.w   HCZMiniS3_SharedReturn
                btst    #0,(V_int_run_count+3).w
                bne.w   HCZMiniS3_SharedReturn
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

HCZMiniS3_EngineOrTipDelete:
                jmp     (Go_Delete_Sprite).l
