; Owner: objects/runtime/s3
; Responsibility: Enemy defeat scoring, controller shake, player collision or proximity, palette transfer and object displacement
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EnemyDefeat_Score:
                bset    #7,status(a0)
                movea.w $44(a0),a1
                moveq   #0,d0
                move.w  (Chain_bonus_counter).w,d0
                addq.w  #2,(Chain_bonus_counter).w
                cmpi.w  #6,d0
                blo.s   S3Runtime_Defeat_SelectCappedOldChainScoreOffset
                moveq   #6,d0

S3Runtime_Defeat_SelectCappedOldChainScoreOffset:
                move.w  d0,$3E(a0)
                move.w  S3Runtime_Defeat_ChainScoreUnitsByByteOffset(pc,d0.w),d0
                cmpi.w  #$20,(Chain_bonus_counter).w
                blo.s   S3Runtime_Defeat_AwardGlobalScoreAndInstallExplosionForLaterDispatch
                move.w  #1000,d0                        ; 10000 points
                move.w  #$A,$3E(a0)

S3Runtime_Defeat_AwardGlobalScoreAndInstallExplosionForLaterDispatch:
                movea.w a1,a3
                jsr     (HUD_AddToScore).l
                move.l  #Obj_Explosion,(a0)
                move.b  #0,routine(a0)
                tst.w   y_vel(a1)
                bmi.s   S3Runtime_Defeat_HandleAlreadyUpwardPlayerVelocity
                move.w  y_pos(a1),d0
                cmp.w   y_pos(a0),d0
                bcc.s   S3Runtime_Defeat_HandleNonnegativePlayerNotAboveObject
                neg.w   y_vel(a1)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Runtime_Defeat_HandleAlreadyUpwardPlayerVelocity:
                addi.w  #$100,y_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Runtime_Defeat_HandleNonnegativePlayerNotAboveObject:
                subi.w  #$100,y_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
S3Runtime_Defeat_ChainScoreUnitsByByteOffset:
                dc.w    10                              ; 100 points
                dc.w    20                              ; 200 points
                dc.w    50                              ; 500 points
                dc.w    100                             ; 1000 points

; =============== S U B R O U T I N E =======================================

Check_LRControllerShake:
                subq.b  #1,$3D(a0)
                bpl.s   S3Runtime_Shake_CompareNonzeroPressedDirectionMasks
                move.b  #5,$3C(a0)
                move.b  #60,$3D(a0)

S3Runtime_Shake_CompareNonzeroPressedDirectionMasks:
                movea.w $3E(a0),a2
                move.w  (a2),d0
                andi.w  #$C,d0
                beq.s   S3Runtime_Shake_ReturnCompletionThroughLowWordAndZeroFlag
                move.w  $3A(a0),d1
                move.w  d0,$3A(a0)
                andi.w  #$C,d1
                eor.w   d1,d0
                beq.s   S3Runtime_Shake_ReturnCompletionThroughLowWordAndZeroFlag
                subq.b  #1,$3C(a0)
                bmi.s   S3Runtime_Shake_ReturnCompletionThroughLowWordAndZeroFlag
                moveq   #0,d0

S3Runtime_Shake_ReturnCompletionThroughLowWordAndZeroFlag:
                rts
; End of function Check_LRControllerShake

; =============== S U B R O U T I N E =======================================

Check_PlayerCollision:
                move.b  collision_property(a0),d0
                beq.s   S3Runtime_Contact_ReturnNoPropertyOrSelectedHandle
                clr.b   collision_property(a0)
                move.w  parent3(a0),d1
                beq.s   S3Runtime_Contact_SelectHandleAfterOptionalParentNotification
                movea.w d1,a1
                bset    #0,$38(a1)

S3Runtime_Contact_SelectHandleAfterOptionalParentNotification:
                andi.w  #3,d0
                add.w   d0,d0
                movea.w S3Runtime_Contact_PlayerHandlesByPropertyLowBits-2(pc,d0.w),a1
                move.w  a1,$44(a0)
                moveq   #1,d1

S3Runtime_Contact_ReturnNoPropertyOrSelectedHandle:
                rts
; End of function Check_PlayerCollision

; ---------------------------------------------------------------------------
S3Runtime_Contact_PlayerHandlesByPropertyLowBits:
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_1

; =============== S U B R O U T I N E =======================================

Check_PlayerInRange:
                moveq   #0,d0
                lea     (Player_2).w,a2
                move.w  x_pos(a2),d1
                move.w  y_pos(a2),d2
                move.w  x_pos(a0),d3
                move.w  y_pos(a0),d4
                add.w   (a1)+,d3
                move.w  d3,d5
                add.w   (a1)+,d5
                add.w   (a1)+,d4
                move.w  d4,d6
                add.w   (a1)+,d6
                bsr.w   StorePlayerPointerIfInsideRect
                swap    d0
                lea     (Player_1).w,a2
                move.w  x_pos(a2),d1
                move.w  y_pos(a2),d2
; End of function Check_PlayerInRange

; =============== S U B R O U T I N E =======================================

StorePlayerPointerIfInsideRect:
                cmp.w   d3,d1
                blo.s   S3Runtime_Rectangle_ReturnWithConditionalLowWordPointerStore
                cmp.w   d5,d1
                bhs.s   S3Runtime_Rectangle_ReturnWithConditionalLowWordPointerStore
                cmp.w   d4,d2
                blo.s   S3Runtime_Rectangle_ReturnWithConditionalLowWordPointerStore
                cmp.w   d6,d2
                bhs.s   S3Runtime_Rectangle_ReturnWithConditionalLowWordPointerStore
                move.w  a2,d0

S3Runtime_Rectangle_ReturnWithConditionalLowWordPointerStore:
                rts
; End of function StorePlayerPointerIfInsideRect

; =============== S U B R O U T I N E =======================================

PalLoad_Line1:
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d0

                .loop:
                move.l  (a1)+,(a2)+
                dbf     d0,.loop
                rts
; End of function PalLoad_Line1

; =============== S U B R O U T I N E =======================================

Displace_PlayerOffObject:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   S3Runtime_Displace_ReturnAfterConditionalStandingRelease
                bclr    #p1_standing_bit,status(a0)
                beq.s   S3Runtime_Displace_ReleaseSecondStandingPlayerWithNativeFlagDifference
                lea     (Player_1).w,a1
; Bug: This should clear Status_OnObj instead of p1_standing_bit
; Thankfully, they both equal 3. Sonic (3) & Knuckles corrects this
                bclr    #p1_standing_bit,status(a1)
                bset    #Status_InAir,status(a1)

S3Runtime_Displace_ReleaseSecondStandingPlayerWithNativeFlagDifference:
                bclr    #p2_standing_bit,status(a0)
                beq.s   S3Runtime_Displace_ReturnAfterConditionalStandingRelease
                lea     (Player_2).w,a1
; Bug: this should clear Status_OnObj instead of p2_standing_bit
; As a result, player 2's Status_RollJump is cleared instead
; Sonic (3) & Knuckles corrects this as well
                bclr    #p2_standing_bit,status(a1)
                bset    #Status_InAir,status(a1)

S3Runtime_Displace_ReturnAfterConditionalStandingRelease:
                rts
; End of function Displace_PlayerOffObject
