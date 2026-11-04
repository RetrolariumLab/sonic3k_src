; Owner: objects/zones/cnz/s3
; Responsibility: Carnival Night vacuum tube capture, player transport and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZVacuumTube:
                move.b  subtype(a0),d0
                beq.s   S3CNZVacTube_StartHorizontalField
                add.b   d0,d0
                move.b  d0,$34(a0)
                move.l  #S3CNZVacTube_UpdateVerticalRiders,(a0)
                bra.w   S3CNZVacTube_UpdateVerticalRiders
; ---------------------------------------------------------------------------

S3CNZVacTube_StartHorizontalField:
                move.l  #S3CNZVacTube_UpdateHorizontalField,(a0)

S3CNZVacTube_UpdateHorizontalField:
                lea     (Player_1).w,a1
                bsr.w   ApplyCnzHorizontalVacuumTubeToPlayer
                lea     (Player_2).w,a1
                bsr.w   ApplyCnzHorizontalVacuumTubeToPlayer
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

ApplyCnzHorizontalVacuumTubeToPlayer:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                btst    #0,status(a0)
                bne.s   S3CNZVacTube_CheckFieldAndPickEffect
                neg.w   d0

S3CNZVacTube_CheckFieldAndPickEffect:
                addi.w  #$50,d0
                cmpi.w  #$A0,d0
                bhs.s   S3CNZVacTube_HorizontalFieldReturn
                move.w  y_pos(a1),d1
                addi.w  #$20,d1
                sub.w   y_pos(a0),d1
                bcs.s   S3CNZVacTube_HorizontalFieldReturn
                cmpi.w  #$40,d1
                bhs.s   S3CNZVacTube_HorizontalFieldReturn
                cmpi.b  #4,routine(a1)
                bhs.s   S3CNZVacTube_HorizontalFieldReturn
                tst.b   object_control(a1)
                bne.s   S3CNZVacTube_HorizontalFieldReturn
                subi.w  #$50,d0
                bcc.s   S3CNZVacTube_CalcSignedSuction
                not.w   d0
                move.w  #$1000,ground_vel(a1)
                btst    #0,status(a0)
                bne.s   S3CNZVacTube_ApplyGroundBoost
                neg.w   ground_vel(a1)

S3CNZVacTube_ApplyGroundBoost:
                move.w  ground_vel(a1),x_vel(a1)
                rts
; ---------------------------------------------------------------------------

S3CNZVacTube_CalcSignedSuction:
                add.w   d0,d0
                addi.w  #$60,d0
                btst    #0,status(a0)
                bne.s   S3CNZVacTube_StepHorizontalSuction
                neg.w   d0

; Negate only the low byte before shifting the signed word
S3CNZVacTube_StepHorizontalSuction:
                neg.b   d0
                asr.w   #4,d0
                add.w   d0,x_pos(a1)
                move.w  $36(a0),d0
                bne.s   S3CNZVacTube_TickSharedSoundCounter
                moveq   #signextendB(sfx_TunnelBooster),d0
                jsr     (Play_SFX).l

S3CNZVacTube_TickSharedSoundCounter:
                addq.w  #1,$36(a0)
                andi.w  #$1F,$36(a0)

S3CNZVacTube_HorizontalFieldReturn:
                rts
; End of function ApplyCnzHorizontalVacuumTubeToPlayer

; ---------------------------------------------------------------------------

S3CNZVacTube_UpdateVerticalRiders:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                bsr.w   UpdatePlayerInCnzVerticalVacuumTube
                addq.w  #1,a2
                lea     (Player_2).w,a1
                bsr.w   UpdatePlayerInCnzVerticalVacuumTube
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInCnzVerticalVacuumTube:
                move.b  (a2),d0
                bne.w   S3CNZVacTube_TickAndCarryRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$18,d0
                cmpi.w  #$30,d0
                bhs.s   S3CNZVacTube_VerticalEntryReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$30,d1
                cmpi.w  #$50,d1
                bhs.s   S3CNZVacTube_VerticalEntryReturn
                cmpi.b  #4,routine(a1)
                bhs.s   S3CNZVacTube_VerticalEntryReturn
                tst.b   object_control(a1)
                bne.s   S3CNZVacTube_VerticalEntryReturn
                subi.w  #$50,d1
                neg.w   d1
                cmpi.w  #$40,d1
                blo.s   S3CNZVacTube_ScalePullByCharacter
                move.b  #1,(a2)
                move.b  $34(a0),2(a2)
                move.w  d0,-(sp)
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l
                move.w  (sp)+,d0

S3CNZVacTube_ScalePullByCharacter:
                asr.w   #2,d1
                cmpi.b  #1,character_id(a1)
                beq.s   S3CNZVacTube_PullUpAndTryCentering
                asr.w   #1,d1

S3CNZVacTube_PullUpAndTryCentering:
                sub.w   d1,y_pos(a1)
                moveq   #1,d2
                cmpi.w  #$18,d0
                beq.s   S3CNZVacTube_SetEnteringRiderPose
                bcs.s   S3CNZVacTube_CenterEnteringRider
                neg.w   d2

S3CNZVacTube_CenterEnteringRider:
                add.w   d2,x_pos(a1)

S3CNZVacTube_SetEnteringRiderPose:
                bset    #Status_InAir,status(a1)
                move.b  #$F,anim(a1)
                clr.b   jumping(a1)

S3CNZVacTube_VerticalEntryReturn:
                rts
; ---------------------------------------------------------------------------

S3CNZVacTube_TickAndCarryRider:
                subq.b  #1,d0
                bne.s   S3CNZVacTube_TransportReturn
                subq.b  #1,2(a2)
                beq.s   S3CNZVacTube_ReleaseRiderUpward
                subi.w  #8,y_pos(a1)
                moveq   #1,d2
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                beq.s   S3CNZVacTube_ClearCapturedSpeed
                bcs.s   S3CNZVacTube_CenterCapturedRider
                neg.w   d2

S3CNZVacTube_CenterCapturedRider:
                add.w   d2,x_pos(a1)

S3CNZVacTube_ClearCapturedSpeed:
                move.w  #0,x_vel(a1)
                move.w  #0,ground_vel(a1)
                move.w  #0,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

S3CNZVacTube_ReleaseRiderUpward:
                move.w  #-$800,y_vel(a1)
                move.b  #0,(a2)
                rts
; ---------------------------------------------------------------------------

S3CNZVacTube_TransportReturn:
                rts
; End of function UpdatePlayerInCnzVerticalVacuumTube
