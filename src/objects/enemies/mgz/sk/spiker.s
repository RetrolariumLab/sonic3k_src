; Owner: objects/enemies/mgz/sk
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
                dc.w    SKSpiker_InitRootAndChildren-Spiker_Index
                dc.w    SKSpiker_CheckPlayerToRise-Spiker_Index
                dc.w    SKSpiker_StepRise-Spiker_Index
                dc.w    SKSpiker_WaitRaised-Spiker_Index
                dc.w    SKSpiker_StepDescent-Spiker_Index
                dc.w    SKSpiker_AnimateAndTryLaunch-Spiker_Index
; ---------------------------------------------------------------------------

SKSpiker_InitRootAndChildren:
                lea     ObjDat_Spiker(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     SKSpiker_RootChildRecords(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

SKSpiker_CheckPlayerToRise:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                blo.s   SpikerSK_Root_StartEightCallIntegerRise
                rts
; ---------------------------------------------------------------------------

SpikerSK_Root_StartEightCallIntegerRise:
                move.b  #4,routine(a0)
                move.w  #7,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SKSpiker_StepRise:
                subq.w  #1,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   SpikerSK_Root_EnableSideUnitsAfterRise
                rts
; ---------------------------------------------------------------------------

SpikerSK_Root_EnableSideUnitsAfterRise:
                move.b  #6,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKSpiker_WaitRaised:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   SKSpiker_BeginDescent
                rts
; ---------------------------------------------------------------------------

SKSpiker_BeginDescent:
                move.b  #8,routine(a0)
                bclr    #2,$38(a0)
                move.w  #7,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SKSpiker_StepDescent:
                addq.w  #1,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   SpikerSK_Root_RearmIdleProximityPoll
                rts
; ---------------------------------------------------------------------------

SpikerSK_Root_RearmIdleProximityPoll:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKSpiker_AnimateAndTryLaunch:
                lea     SKSpiker_SpringAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   SKSpiker_LaunchReturn
                cmpi.b  #4,anim_frame(a0)
                bne.s   SKSpiker_LaunchReturn
                movea.w $44(a0),a1
                move.w  #-$600,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #2,routine(a1)

SKSpiker_LaunchReturn:
                rts
; ---------------------------------------------------------------------------

SKSpiker_RestoreAfterSpring:
                move.b  $3A(a0),routine(a0)
                move.b  #$A,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

SKSpiker_UpdateSideUnit:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKSpiker_SideStateOffsets(pc,d0.w),d1
                jsr     SKSpiker_SideStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
SKSpiker_SideStateOffsets:
                dc.w    SKSpiker_InitSideAndFacing-SKSpiker_SideStateOffsets
                dc.w    SKSpiker_WaitForFireEnable-SKSpiker_SideStateOffsets
                dc.w    SKSpiker_TryFindSideTarget-SKSpiker_SideStateOffsets
                dc.w    SKSpiker_AnimateAndTryFire-SKSpiker_SideStateOffsets
; ---------------------------------------------------------------------------

SKSpiker_InitSideAndFacing:
                lea     SpikerSK_SideUnit_PartialAttributePrefix(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                tst.b   subtype(a0)
                bne.s   SKSpiker_SideInitReturn
                bset    #0,render_flags(a0)

SKSpiker_SideInitReturn:
                rts
; ---------------------------------------------------------------------------

SKSpiker_WaitForFireEnable:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   SKSpiker_StartSideTargetPoll
                rts
; ---------------------------------------------------------------------------

SKSpiker_StartSideTargetPoll:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKSpiker_TryFindSideTarget:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   SpikerSK_SideUnit_ReturnToRootEnableWait
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   SKSpiker_SideTargetReturn
                tst.b   subtype(a0)
                beq.s   SKSpiker_CheckSideTargetDirection
                subq.w  #2,d0

SKSpiker_CheckSideTargetDirection:
                tst.w   d0
                beq.s   SKSpiker_BeginFiring

SKSpiker_SideTargetReturn:
                rts
; ---------------------------------------------------------------------------

SKSpiker_BeginFiring:
                move.b  #6,routine(a0)
                move.l  #SKSpiker_ResumeSideTargetPoll,$34(a0)
                rts
; ---------------------------------------------------------------------------

SpikerSK_SideUnit_ReturnToRootEnableWait:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKSpiker_AnimateAndTryFire:
                lea     SKSpiker_FiringAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   SKSpiker_FireReturn
                cmpi.b  #4,mapping_frame(a0)
                bne.s   SKSpiker_FireReturn
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     SKSpiker_ShotChildRecord(pc),a2
                jsr     CreateChild5_ComplexAdjusted(pc)

SKSpiker_FireReturn:
                rts
; ---------------------------------------------------------------------------

SKSpiker_ResumeSideTargetPoll:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKSpiker_UpdateSpringContact:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKSpiker_SpringStateOffsets(pc,d0.w),d1
                jsr     SKSpiker_SpringStateOffsets(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
SKSpiker_SpringStateOffsets:
                dc.w    SKSpiker_InitSpringAndProbe-SKSpiker_SpringStateOffsets
                dc.w    SKSpiker_ReadSpringContact-SKSpiker_SpringStateOffsets
                dc.w    SKSpiker_WaitToRearmSpring-SKSpiker_SpringStateOffsets
; ---------------------------------------------------------------------------

SKSpiker_InitSpringAndProbe:
                lea     SKSpiker_SpringContactAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)

SKSpiker_ReadSpringContact:
                jsr     Check_PlayerCollision(pc)
                bne.s   SKSpiker_PrimeSpringAndStartWait
                rts
; ---------------------------------------------------------------------------

SKSpiker_PrimeSpringAndStartWait:
                bsr.w   PrimeSpikerSpringContactPlayer
                move.b  #4,routine(a0)
                clr.b   collision_flags(a0)
                move.w  #$10,$2E(a0)
                move.l  #SKSpiker_RearmSpring,$34(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)
                move.b  #1,mapping_frame(a1)
                clr.b   collision_flags(a1)
                move.w  $44(a0),$44(a1)
                rts
; ---------------------------------------------------------------------------

SKSpiker_WaitToRearmSpring:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKSpiker_RearmSpring:
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
                bne.s   SKSpiker_ConsumeSpringRequest
                rts
; ---------------------------------------------------------------------------

SKSpiker_ConsumeSpringRequest:
                bclr    #3,$38(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.b  routine(a0),$3A(a0)
                move.b  d0,routine(a0)
                move.l  #SKSpiker_RestoreAfterSpring,$34(a0)
                rts
; End of function ConsumeSpikerSpringRequestAndSaveRoutine

; ---------------------------------------------------------------------------
ObjDat_Spiker:
                dc.l    Map_Spiker
                dc.w    make_art_tile(ArtTile_Spiker,1,0)
                dc.w    $280
                dc.b    $20, $10,   0,  $A
SpikerSK_SideUnit_PartialAttributePrefix:
                dc.w    $280
                dc.b    $20,   4,   3,   0
SKSpiker_SpringContactAttrs:
                dc.w    $200
                dc.b    $20,   4,   7, $CA
SKSpiker_ShotAttrs:
                dc.l    Map_Spiker
                dc.w    make_art_tile(ArtTile_Spiker,0,0)
                dc.w    $280
                dc.b    4,   4,   5, $98
SKSpiker_RootChildRecords:
                dc.w    3-1
                dc.l    SKSpiker_UpdateSideUnit
                dc.b    -$10,  $C
                dc.l    SKSpiker_UpdateSideUnit
                dc.b    $10,  $C
                dc.l    SKSpiker_UpdateSpringContact
                dc.b    0, -$C
SKSpiker_ShotChildRecord:
                dc.w    1-1
                dc.l    SKCallbackShot_InitDeflectable
                dc.l    SKSpiker_ShotAttrs
                dc.l    SKSpiker_ShotAnim
                dc.l    MoveSlowFall_AnimateRaw
                dc.b    4,   0
                dc.w    $200, -$200
SKSpiker_SpringAnim:
                dc.b    1,   0
                dc.b    2,   1
                dc.b    1,   0
                dc.b    0,   5
                dc.b    $F4
SKSpiker_FiringAnim:
                dc.b    3,   1
                dc.b    3,  $F
                dc.b    4,   7
                dc.b    3, $3F
                dc.b    $F4
SKSpiker_ShotAnim:
                dc.b    1,   5,   6, $FC
                even
