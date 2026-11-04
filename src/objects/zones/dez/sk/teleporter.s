; Owner: objects/zones/dez/sk
; Responsibility: Teleporter player capture, path state, transport and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZTeleporter:
                lea     (Player_1).w,a1
                lea     $30(a0),a4
                bsr.s   UpdatePlayerInDezTeleporter
                lea     (Player_2).w,a1
                lea     $3A(a0),a4
                bsr.s   UpdatePlayerInDezTeleporter
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInDezTeleporter:
                moveq   #0,d0
                move.b  (a4),d0
                move.w  SKDEZTeleporter_RiderStateOffsets(pc,d0.w),d0
                jmp     SKDEZTeleporter_RiderStateOffsets(pc,d0.w)
; End of function UpdatePlayerInDezTeleporter

; ---------------------------------------------------------------------------
SKDEZTeleporter_RiderStateOffsets:
                dc.w    SKDEZTeleporter_CheckCaptureX-SKDEZTeleporter_RiderStateOffsets
                dc.w    SKDEZTeleporter_AccelSpinAndTryTransit-SKDEZTeleporter_RiderStateOffsets
                dc.w    SKDEZTeleporter_TrySetGravityAtMidpoint-SKDEZTeleporter_RiderStateOffsets
                dc.w    SKDEZTeleporter_TryRearmAfterDeparture-SKDEZTeleporter_RiderStateOffsets
; ---------------------------------------------------------------------------

SKDEZTeleporter_CheckCaptureX:
                tst.w   (Debug_placement_mode).w
                bne.w   SKDEZTeleporter_CaptureReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addq.w  #3,d0
                btst    #0,status(a0)
                beq.s   SKDEZTeleporter_CheckRiderEligibility
                addi.w  #$A,d0

SKDEZTeleporter_CheckRiderEligibility:
                cmpi.w  #$10,d0
                bhs.w   SKDEZTeleporter_CaptureReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$20,d1
                cmpi.w  #$40,d1
                bhs.w   SKDEZTeleporter_CaptureReturn
                tst.b   object_control(a1)
                bne.w   SKDEZTeleporter_CaptureReturn
                btst    #Status_InAir,status(a1)
                bne.w   SKDEZTeleporter_CaptureReturn
                btst    #0,(_unkFAB8).w
                bne.w   SKDEZTeleporter_CaptureReturn
                movea.w interact(a1),a3
                cmpi.l  #Obj_DEZTeleporter,(a3)
                bne.s   SKDEZTeleporter_CaptureAndUnrollRider
                move.w  a4,d0
                sub.w   a0,d0
                tst.b   (a3,d0.w)
                bne.s   SKDEZTeleporter_CaptureReturn

SKDEZTeleporter_CaptureAndUnrollRider:
                move.w  a0,interact(a1)
                addq.b  #2,(a4)
                move.b  #$83,object_control(a1)
                move.b  #0,anim(a1)
                move.w  #0,ground_vel(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                move.w  x_pos(a0),x_pos(a1)
                bclr    #Status_Roll,status(a1)
                beq.s   SKDEZTeleporter_InitSpinPhase
                move.b  y_radius(a1),d0
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                sub.b   default_y_radius(a1),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKDEZTeleporter_ApplyUnrollY
                neg.w   d0

SKDEZTeleporter_ApplyUnrollY:
                add.w   d0,y_pos(a1)

SKDEZTeleporter_InitSpinPhase:
                clr.b   1(a4)
                clr.w   2(a4)
                btst    #Status_Facing,status(a1)
                beq.s   SKDEZTeleporter_ClearSpinSpeed
                move.b  #6,2(a4)

SKDEZTeleporter_ClearSpinSpeed:
                clr.w   4(a4)

SKDEZTeleporter_CaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKDEZTeleporter_AccelSpinAndTryTransit:
                addq.w  #8,4(a4)
                cmpi.w  #$300,4(a4)
                bne.s   SKDEZTeleporter_StepSpinPhase
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                move.w  d0,6(a4)
                lsr.w   #1,d0
                move.w  d0,8(a4)
                move.w  #$1000,d0
                btst    #1,status(a0)
                bne.s   SKDEZTeleporter_BeginTransit
                neg.w   d0

SKDEZTeleporter_BeginTransit:
                move.w  d0,y_vel(a1)
                addq.b  #2,(a4)
                moveq   #signextendB(sfx_SuperTransform),d0
                jsr     (Play_SFX).l

SKDEZTeleporter_StepSpinPhase:
                move.w  2(a4),d0
                add.w   4(a4),d0
                cmpi.w  #$C00,d0
                blo.s   SKDEZTeleporter_StorePhaseAndSelectPose
                subi.w  #$C00,d0

SKDEZTeleporter_StorePhaseAndSelectPose:
                move.w  d0,2(a4)
                moveq   #0,d0
                move.b  2(a4),d0
                move.b  SKDEZTeleporter_RiderSpinFrames(pc,d0.w),mapping_frame(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  SKDEZTeleporter_RiderSpinFlipBits(pc,d0.w),d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKDEZTeleporter_ApplyFlipAndUploadPose
                ori.b   #2,d0

SKDEZTeleporter_ApplyFlipAndUploadPose:
                or.b    d0,render_flags(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------
SKDEZTeleporter_RiderSpinFrames:
                dc.b    $55, $59, $5A, $5B, $5A, $59, $55, $56, $57, $58, $57, $56
SKDEZTeleporter_RiderSpinFlipBits:
                dc.b    0,   1,   1,   0,   0,   0,   1,   1,   1,   0,   0,   0
                even
; ---------------------------------------------------------------------------

; Only P1 changes global gravity. Record whether gravity already matched for the release correction
SKDEZTeleporter_TrySetGravityAtMidpoint:
                move.w  6(a4),d1
                move.w  8(a4),d2
                cmp.w   d2,d1
                bne.s   SKDEZTeleporter_SetTransitInvuln
                cmpa.w  #Player_1,a1
                bne.s   SKDEZTeleporter_SetTransitInvuln
                move.b  subtype(a0),d0
                rol.b   #1,d0
                andi.b  #1,d0
                cmp.b   (Reverse_gravity_flag).w,d0
                bne.s   SKDEZTeleporter_ApplyTargetGravity
                move.b  #1,1(a4)

SKDEZTeleporter_ApplyTargetGravity:
                move.b  d0,(Reverse_gravity_flag).w

SKDEZTeleporter_SetTransitInvuln:
                move.b  #0,invulnerability_timer(a1)
                cmpi.w  #5,d1
                bcs.s   SKDEZTeleporter_StepTransitOrRelease
                add.w   d2,d2
                subq.w  #5,d2
                cmp.w   d2,d1
                bhs.s   SKDEZTeleporter_StepTransitOrRelease
                move.b  #1,invulnerability_timer(a1)

SKDEZTeleporter_StepTransitOrRelease:
                subq.w  #1,6(a4)
                bmi.s   SKDEZTeleporter_ReleaseAndSelectOffset
                move.l  y_pos(a1),d3
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d3,y_pos(a1)
                bra.w   SKDEZTeleporter_StepSpinPhase
; ---------------------------------------------------------------------------

SKDEZTeleporter_ReleaseAndSelectOffset:
                addq.b  #2,(a4)
                clr.b   object_control(a1)
                move.w  #0,y_vel(a1)
                moveq   #9,d0
                cmpi.b  #1,character_id(a1)
                bne.s   SKDEZTeleporter_SelectNegativeExitOffset
                moveq   #$11,d0

SKDEZTeleporter_SelectNegativeExitOffset:
                tst.b   subtype(a0)
                bpl.s   SKDEZTeleporter_SelectPositiveExitOffset
                neg.w   d0
                btst    #1,status(a0)
                beq.s   SKDEZTeleporter_CheckCommonExitOffset
                moveq   #7,d0
                cmpi.b  #1,character_id(a1)
                bne.s   SKDEZTeleporter_TryOverrideNegativeExit
                subq.w  #8,d0

SKDEZTeleporter_TryOverrideNegativeExit:
                tst.b   1(a4)
                beq.s   SKDEZTeleporter_ApplyReleaseY
                moveq   #$10,d0
                bra.s   SKDEZTeleporter_ApplyReleaseY
; ---------------------------------------------------------------------------

SKDEZTeleporter_SelectPositiveExitOffset:
                btst    #1,status(a0)
                bne.s   SKDEZTeleporter_CheckCommonExitOffset
                moveq   #-7,d0
                cmpi.b  #1,character_id(a1)
                bne.s   SKDEZTeleporter_TryOverridePositiveExit
                addq.w  #8,d0

SKDEZTeleporter_TryOverridePositiveExit:
                tst.b   1(a4)
                beq.s   SKDEZTeleporter_ApplyReleaseY
                moveq   #-$10,d0
                bra.s   SKDEZTeleporter_ApplyReleaseY
; ---------------------------------------------------------------------------

SKDEZTeleporter_CheckCommonExitOffset:
                tst.b   1(a4)
                bne.s   SKDEZTeleporter_ReleaseReturn

SKDEZTeleporter_ApplyReleaseY:
                add.w   d0,y_pos(a1)

SKDEZTeleporter_ReleaseReturn:
                rts
; ---------------------------------------------------------------------------

SKDEZTeleporter_TryRearmAfterDeparture:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                blo.s   SKDEZTeleporter_DepartureReturn
                clr.w   $42(a1)
                clr.b   (a4)

SKDEZTeleporter_DepartureReturn:
                rts
