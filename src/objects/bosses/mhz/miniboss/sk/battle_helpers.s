; Owner: objects/bosses/mhz/miniboss/sk
; Responsibility: Mushroom Hill miniboss collision, projectile and movement helper callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Correct the floor penetration on contact. Bounce once, then schedule the recovery wait on the next contact
MHZMiniThrown_BounceOrStartRecovery:
                bset    #7,$38(a0)
                bne.s   MHZMini_BeginSecondBounceWait
                add.w   d1,y_pos(a0)
                move.w  x_vel(a0),d0
                asr.w   #1,d0
                move.w  d0,x_vel(a0)
                move.w  y_vel(a0),d0
                asr.w   #1,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_BeginSecondBounceWait:
                move.b  #4,routine(a0)
                add.w   d1,y_pos(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MHZMini_BeginRecoveryAndTryChild,$34(a0)
                rts
; End of function MHZMiniThrown_BounceOrStartRecovery

; ---------------------------------------------------------------------------

MHZMini_BeginRecoveryAndTryChild:
                move.b  #6,routine(a0)
                clr.w   x_vel(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MHZMini_HoldBeforeReturn,$34(a0)
                lea     MHZMini_RecoveryChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

MHZMini_MoveAnimateAndWait:
                jsr     (MoveSprite2).l

MHZMini_AnimateAndWait:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

MHZMini_HoldBeforeReturn:
                move.b  #8,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #MHZMini_AimReturnTowardBoss,$34(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_AimReturnTowardBoss:
                move.b  #$A,routine(a0)
                move.w  #$180,priority(a0)
                move.w  #-$300,y_vel(a0)
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.w  x_pos(a1),d0
                subq.w  #6,d0
                sub.w   x_pos(a0),d0
                smi     d1
                bpl.s   MHZMini_DivideReturnXDistance
                neg.w   d0

MHZMini_DivideReturnXDistance:
                swap    d0
                divu.w  #$6100,d0
                tst.b   d1
                beq.s   MHZMini_StoreReturnXSpeed
                neg.w   d0

MHZMini_StoreReturnXSpeed:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

MHZMini_FallAndCheckCatchHeight:
                addi.w  #$10,y_vel(a0)
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                bmi.s   MHZMini_AnimateBeforeCatch
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                addi.w  #-8,d0
                cmp.w   y_pos(a0),d0
                bls.s   MHZMini_SignalReturnAndDelete

MHZMini_AnimateBeforeCatch:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

MHZMini_SignalReturnAndDelete:
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

MHZMini_InitFlickerFollower:
                lea     MHZMini_ArtPriorityBounds(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #MHZMini_FollowerDrawByParity,(a0)

MHZMini_FollowerDrawByParity:
                movea.w parent3(a0),a1
                move.b  (V_int_run_count+3).w,d0
                btst    #0,d0
                bne.w   MHZMini_FollowerCheckParent
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

MHZMini_FollowerCheckParent:
                btst    #7,status(a1)
                bne.s   MHZMini_DeleteFlickerFollower
                rts
; ---------------------------------------------------------------------------

MHZMini_DeleteFlickerFollower:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

MHZMini_InitCameraRelativeMotion:
                lea     (ObjDat3_6646E).l,a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MHZMini_CheckHorizontalDeceleration,(a0)
                bsr.w   MHZMiniParticle_InitMotion
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$AC,d0
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Accept speeds at or below -$100. At or above +$100, skip storing the candidate
MHZMini_CheckHorizontalDeceleration:
                move.w  x_vel(a0),d0
                add.w   $40(a0),d0
                cmpi.w  #-$100,d0
                ble.s   MHZMini_StoreHorizontalCandidate
                cmpi.w  #$100,d0
                bge.s   MHZMini_ChooseCoastYAcceleration
                move.l  #MHZMini_ChooseCoastYAcceleration,(a0)
                bset    #0,$38(a0)

MHZMini_StoreHorizontalCandidate:
                move.w  d0,x_vel(a0)

MHZMini_ChooseCoastYAcceleration:
                move.w  y_vel(a0),d0
                move.w  $3E(a0),d1
                btst    #0,$38(a0)
                beq.s   MHZMini_UpdateVerticalSpeed
                moveq   #-1,d1

MHZMini_UpdateVerticalSpeed:
                sub.w   d1,d0
                cmpi.w  #$80,d0
                blt.s   MHZMinibossLeaf_StoreVerticalCandidate
                move.l  #MHZMini_MoveDrawOrDelete,(a0)

MHZMinibossLeaf_StoreVerticalCandidate:
                move.w  d0,y_vel(a0)

MHZMini_MoveDrawOrDelete:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bpl.s   MHZMinibossLeaf_DeleteCurrentImmediately
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MHZMinibossLeaf_DeleteCurrentImmediately:
                jmp     (Delete_Current_Sprite).l
; End of function MHZMini_FallAndCheckCatchHeight
