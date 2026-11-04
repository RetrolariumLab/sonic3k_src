; Owner: objects/enemies/mgz/s3
; Responsibility: Spiker enemy state machine, projectile motion and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Spiker:
                jsr     (Obj_WaitOffscreen).l
                moveq   #$A,d0
                bsr.w   ConsumeSpikerSpringRequestAndSaveRoutine
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Spiker_Index(pc,d0.w),d1
                jsr     Spiker_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Spiker_Index:
                dc.w    S3Spiker_InitRootAndChildren-Spiker_Index
                dc.w    S3Spiker_CheckPlayerToRise-Spiker_Index
                dc.w    S3Spiker_StepRise-Spiker_Index
                dc.w    S3Spiker_WaitRaised-Spiker_Index
                dc.w    S3Spiker_StepDescent-Spiker_Index
                dc.w    S3Spiker_AnimateAndTryLaunch-Spiker_Index
; ---------------------------------------------------------------------------

S3Spiker_InitRootAndChildren:
                lea     ObjDat_Spiker(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     S3Spiker_RootChildRecords(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

S3Spiker_CheckPlayerToRise:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                blo.s   SpikerS3_Root_StartEightCallIntegerRise
                rts
; ---------------------------------------------------------------------------

SpikerS3_Root_StartEightCallIntegerRise:
                move.b  #4,routine(a0)
                move.w  #7,$2E(a0)
                rts
; ---------------------------------------------------------------------------

S3Spiker_StepRise:
                subq.w  #1,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   SpikerS3_Root_EnableSideUnitsAfterRise
                rts
; ---------------------------------------------------------------------------

SpikerS3_Root_EnableSideUnitsAfterRise:
                move.b  #6,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

S3Spiker_WaitRaised:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   S3Spiker_BeginDescent
                rts
; ---------------------------------------------------------------------------

S3Spiker_BeginDescent:
                move.b  #8,routine(a0)
                bclr    #2,$38(a0)
                move.w  #7,$2E(a0)
                rts
; ---------------------------------------------------------------------------

S3Spiker_StepDescent:
                addq.w  #1,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   SpikerS3_Root_RearmIdleProximityPoll
                rts
; ---------------------------------------------------------------------------

SpikerS3_Root_RearmIdleProximityPoll:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3Spiker_AnimateAndTryLaunch:
                lea     S3Spiker_SpringAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   S3Spiker_LaunchReturn
                cmpi.b  #4,anim_frame(a0)
                bne.s   S3Spiker_LaunchReturn
                movea.w $44(a0),a1
                move.w  #-$600,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #2,routine(a1)

S3Spiker_LaunchReturn:
                rts
; ---------------------------------------------------------------------------

S3Spiker_RestoreAfterSpring:
                move.b  $3A(a0),routine(a0)
                move.b  #$A,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

S3Spiker_UpdateSideUnit:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3Spiker_SideStateOffsets(pc,d0.w),d1
                jsr     S3Spiker_SideStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
S3Spiker_SideStateOffsets:
                dc.w    S3Spiker_InitSideAndFacing-S3Spiker_SideStateOffsets
                dc.w    S3Spiker_WaitForFireEnable-S3Spiker_SideStateOffsets
                dc.w    S3Spiker_TryFindSideTarget-S3Spiker_SideStateOffsets
                dc.w    S3Spiker_AnimateAndTryFire-S3Spiker_SideStateOffsets
; ---------------------------------------------------------------------------

S3Spiker_InitSideAndFacing:
                lea     SpikerS3_SideUnit_PartialAttributePrefix(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                tst.b   subtype(a0)
                bne.s   S3Spiker_SideInitReturn
                bset    #0,render_flags(a0)

S3Spiker_SideInitReturn:
                rts
; ---------------------------------------------------------------------------

S3Spiker_WaitForFireEnable:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   S3Spiker_StartSideTargetPoll
                rts
; ---------------------------------------------------------------------------

S3Spiker_StartSideTargetPoll:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3Spiker_TryFindSideTarget:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   SpikerS3_SideUnit_ReturnToRootEnableWait
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   S3Spiker_SideTargetReturn
                tst.b   subtype(a0)
                beq.s   S3Spiker_CheckSideTargetDirection
                subq.w  #2,d0

S3Spiker_CheckSideTargetDirection:
                tst.w   d0
                beq.s   S3Spiker_BeginFiring

S3Spiker_SideTargetReturn:
                rts
; ---------------------------------------------------------------------------

S3Spiker_BeginFiring:
                move.b  #6,routine(a0)
                move.l  #S3Spiker_ResumeSideTargetPoll,$34(a0)
                rts
; ---------------------------------------------------------------------------

SpikerS3_SideUnit_ReturnToRootEnableWait:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3Spiker_AnimateAndTryFire:
                lea     S3Spiker_FiringAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   S3Spiker_FireReturn
                cmpi.b  #4,mapping_frame(a0)
                bne.s   S3Spiker_FireReturn
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     S3Spiker_ShotChildRecord(pc),a2
                jsr     CreateChild5_ComplexAdjusted(pc)

S3Spiker_FireReturn:
                rts
; ---------------------------------------------------------------------------

S3Spiker_ResumeSideTargetPoll:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3Spiker_UpdateSpringContact:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3Spiker_SpringStateOffsets(pc,d0.w),d1
                jsr     S3Spiker_SpringStateOffsets(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
S3Spiker_SpringStateOffsets:
                dc.w    S3Spiker_InitSpringAndProbe-S3Spiker_SpringStateOffsets
                dc.w    S3Spiker_ReadSpringContact-S3Spiker_SpringStateOffsets
                dc.w    S3Spiker_WaitToRearmSpring-S3Spiker_SpringStateOffsets
; ---------------------------------------------------------------------------

S3Spiker_InitSpringAndProbe:
                lea     S3Spiker_SpringContactAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)

S3Spiker_ReadSpringContact:
                jsr     Check_PlayerCollision(pc)
                bne.s   S3Spiker_PrimeSpringAndStartWait
                rts
; ---------------------------------------------------------------------------

S3Spiker_PrimeSpringAndStartWait:
                bsr.w   PrimeSpikerSpringContactPlayer
                move.b  #4,routine(a0)
                clr.b   collision_flags(a0)
                move.w  #$10,$2E(a0)
                move.l  #S3Spiker_RearmSpring,$34(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)
                move.b  #1,mapping_frame(a1)
                clr.b   collision_flags(a1)
                move.w  $44(a0),$44(a1)
                rts
; ---------------------------------------------------------------------------

S3Spiker_WaitToRearmSpring:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3Spiker_RearmSpring:
                move.b  #2,routine(a0)
                move.b  #$CA,collision_flags(a0)
                rts

; =============== S U B R O U T I N E =======================================

PrimeSpikerSpringContactPlayer:
                clr.w   y_vel(a1)
                bset    #Status_InAir,status(a1)
                addq.w  #6,y_pos(a1)
                move.b  #2,routine(a1)
                clr.b   jumping(a1)
                bclr    #Status_RollJump,status(a1)
                moveq   #signextendB(sfx_Spring),d0
                jsr     (Play_SFX).l
                rts
; End of function PrimeSpikerSpringContactPlayer

; =============== S U B R O U T I N E =======================================

ConsumeSpikerSpringRequestAndSaveRoutine:
                btst    #3,$38(a0)
                bne.s   S3Spiker_ConsumeSpringRequest
                rts
; ---------------------------------------------------------------------------

S3Spiker_ConsumeSpringRequest:
                bclr    #3,$38(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.b  routine(a0),$3A(a0)
                move.b  d0,routine(a0)
                move.l  #S3Spiker_RestoreAfterSpring,$34(a0)
                rts
; End of function ConsumeSpikerSpringRequestAndSaveRoutine

; ---------------------------------------------------------------------------
ObjDat_Spiker:
                dc.l    Map_Spiker
                dc.w    make_art_tile(ArtTile_Spiker,1,0)
                dc.w    $280
                dc.b    $20, $10,   0,  $A
SpikerS3_SideUnit_PartialAttributePrefix:
                dc.w    $280
                dc.b    $20,   4,   3,   0
S3Spiker_SpringContactAttrs:
                dc.w    $200
                dc.b    $20,   4,   7, $CA
S3Spiker_ShotAttrs:
                dc.l    Map_Spiker
                dc.w    make_art_tile(ArtTile_Spiker,0,0)
                dc.w    $280
                dc.b    4,   4,   5, $98
S3Spiker_RootChildRecords:
                dc.w    3-1
                dc.l    S3Spiker_UpdateSideUnit
                dc.b    -$10,  $C
                dc.l    S3Spiker_UpdateSideUnit
                dc.b    $10,  $C
                dc.l    S3Spiker_UpdateSpringContact
                dc.b    0, -$C
S3Spiker_ShotChildRecord:
                dc.w    1-1
                dc.l    S3CallbackShot_InitDeflectable
                dc.l    S3Spiker_ShotAttrs
                dc.l    S3Spiker_ShotAnim
                dc.l    MoveSlowFall_AnimateRaw
                dc.b    4,   0
                dc.w    $200, -$200
S3Spiker_SpringAnim:
                dc.b    1,   0
                dc.b    2,   1
                dc.b    1,   0
                dc.b    0,   5
                dc.b    $F4
S3Spiker_FiringAnim:
                dc.b    3,   1
                dc.b    3,  $F
                dc.b    4,   7
                dc.b    3, $3F
                dc.b    $F4
S3Spiker_ShotAnim:
                dc.b    1,   5,   6, $FC
                even
