; Owner: objects/shared/springs/s3
; Responsibility: Up, horizontal and down spring contact and launch responses for normal and competition players
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Spring_Up:
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   SolidObjectFull2_1P
                btst    #p1_standing_bit,status(a0)
                beq.s   S3Spring_TestNormalUpPlayerTwo
                bsr.s   LaunchPlayerFromUpSpring

S3Spring_TestNormalUpPlayerTwo:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                btst    #p2_standing_bit,status(a0)
                beq.s   S3Spring_AnimateAndCullNormalUp
                bsr.s   LaunchPlayerFromUpSpring

S3Spring_AnimateAndCullNormalUp:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_2PSpring_Up:
                move.w  #$13,d1
                move.w  #8,d2
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   SolidObjectFull2_1P
                btst    #p1_standing_bit,status(a0)
                beq.s   S3Spring_TestCompetitionUpPlayerTwo
                bsr.s   LaunchPlayerFromUpSpring

S3Spring_TestCompetitionUpPlayerTwo:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                btst    #p2_standing_bit,status(a0)
                beq.s   S3Spring_AnimateAndDrawCompetitionUp
                bsr.s   LaunchPlayerFromUpSpring

S3Spring_AnimateAndDrawCompetitionUp:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromUpSpring:
                move.w  #1<<8,anim(a0)                  ; and prev_anim
                addq.w  #8,y_pos(a1)
                move.w  $30(a0),y_vel(a1)
                bset    #1,status(a1)
                bclr    #3,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)
                move.b  subtype(a0),d0
                bpl.s   S3Spring_ConfigureUpLaunchFlip
                move.w  #0,x_vel(a1)

S3Spring_ConfigureUpLaunchFlip:
                btst    #0,d0
                beq.s   S3Spring_ApplyUpPrimaryLayerSelector
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                btst    #1,d0
                bne.s   S3Spring_ApplyUpFlipFacingSign
                move.b  #1,flips_remaining(a1)

S3Spring_ApplyUpFlipFacingSign:
                btst    #0,status(a1)
                beq.s   S3Spring_ApplyUpPrimaryLayerSelector
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

S3Spring_ApplyUpPrimaryLayerSelector:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   S3Spring_ApplyUpSecondaryLayerSelector
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

S3Spring_ApplyUpSecondaryLayerSelector:
                cmpi.b  #8,d0
                bne.s   S3Spring_PlayUpLaunchSound
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

S3Spring_PlayUpLaunchSound:
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerFromUpSpring

; ---------------------------------------------------------------------------

Obj_Spring_Horizontal:
                move.w  #$13,d1
                move.w  #$E,d2
                move.w  #$F,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   SolidObjectFull2_1P
                swap    d6
                andi.w  #1,d6
                beq.s   S3Spring_TestNormalHorizontalPlayerTwo
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   S3Spring_CheckHorizontalP1Side
                eori.b  #1,d1

S3Spring_CheckHorizontalP1Side:
                andi.b  #1,d1
                bne.s   S3Spring_TestNormalHorizontalPlayerTwo
                bsr.w   LaunchPlayerFromHorizontalSpring

S3Spring_TestNormalHorizontalPlayerTwo:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                swap    d6
                andi.w  #2,d6
                beq.s   S3Spring_TickHorizontalBoostAndCull
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   S3Spring_CheckHorizontalP2Side
                eori.b  #1,d1

S3Spring_CheckHorizontalP2Side:
                andi.b  #1,d1
                bne.s   S3Spring_TickHorizontalBoostAndCull
                bsr.w   LaunchPlayerFromHorizontalSpring

S3Spring_TickHorizontalBoostAndCull:
                bsr.w   BoostGroundedPlayersNearHorizontalSpring
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                move.w  $32(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

Obj_2PSpring_Horizontal:
                move.w  #$F,d1
                move.w  #$C,d2
                move.w  #$D,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   SolidObjectFull2_1P
                swap    d6
                andi.w  #1,d6
                beq.s   S3Spring_CheckCompHorizontalP2
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   S3Spring_CheckCompHorizontalP1Side
                eori.b  #1,d1

S3Spring_CheckCompHorizontalP1Side:
                andi.b  #1,d1
                bne.s   S3Spring_CheckCompHorizontalP2
                bsr.s   LaunchPlayerFromSmallHorizontalSpring

S3Spring_CheckCompHorizontalP2:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                swap    d6
                andi.w  #2,d6
                beq.s   S3Spring_AnimateAndDrawCompHorizontal
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   S3Spring_CheckCompHorizontalP2Side
                eori.b  #1,d1

S3Spring_CheckCompHorizontalP2Side:
                andi.b  #1,d1
                bne.s   S3Spring_AnimateAndDrawCompHorizontal
                bsr.s   LaunchPlayerFromSmallHorizontalSpring

S3Spring_AnimateAndDrawCompHorizontal:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromSmallHorizontalSpring:
                move.w  #3<<8,anim(a0)                  ; and prev_anim
                move.w  $30(a0),x_vel(a1)
                addq.w  #4,x_pos(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,status(a0)
                bne.s   S3Spring_JoinSmallHorizontalLaunchTail
                bclr    #Status_Facing,status(a1)
                subi.w  #2*4,x_pos(a1)
                neg.w   x_vel(a1)

S3Spring_JoinSmallHorizontalLaunchTail:
                bra.s   S3Spring_SetHorizontalLockAndGroundVel
; End of function LaunchPlayerFromSmallHorizontalSpring

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromHorizontalSpring:
                move.w  #3<<8,anim(a0)                  ; and prev_anim
                move.w  $30(a0),x_vel(a1)
                addq.w  #8,x_pos(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,status(a0)
                bne.s   S3Spring_SetHorizontalLockAndGroundVel
                bclr    #Status_Facing,status(a1)
                subi.w  #2*8,x_pos(a1)
                neg.w   x_vel(a1)

; Set a $F control lock and copy X velocity to ground velocity
S3Spring_SetHorizontalLockAndGroundVel:
                move.w  #$F,$32(a1)
                move.w  x_vel(a1),ground_vel(a1)
                btst    #Status_Roll,status(a1)
                bne.s   S3Spring_ApplyHorizontalCrossAxisStop
                move.b  #0,anim(a1)

S3Spring_ApplyHorizontalCrossAxisStop:
                move.b  subtype(a0),d0
                bpl.s   S3Spring_ConfigureHorizontalFlip
                move.w  #0,y_vel(a1)

S3Spring_ConfigureHorizontalFlip:
                btst    #0,d0
                beq.s   S3Spring_CheckHorizontalPrimaryLayer
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #1,flips_remaining(a1)
                move.b  #8,flip_speed(a1)
                btst    #1,d0
                bne.s   S3Spring_ApplyHorizontalFlipFacingSign
                move.b  #3,flips_remaining(a1)

S3Spring_ApplyHorizontalFlipFacingSign:
                btst    #Status_Facing,status(a1)
                beq.s   S3Spring_CheckHorizontalPrimaryLayer
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

S3Spring_CheckHorizontalPrimaryLayer:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   S3Spring_CheckHorizontalSecondaryLayer
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

S3Spring_CheckHorizontalSecondaryLayer:
                cmpi.b  #8,d0
                bne.s   S3Spring_ClearHorizontalPushAndPlaySound
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

S3Spring_ClearHorizontalPushAndPlaySound:
                bclr    #p1_pushing_bit,status(a0)
                bclr    #p2_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerFromHorizontalSpring

; =============== S U B R O U T I N E =======================================

BoostGroundedPlayersNearHorizontalSpring:
                cmpi.b  #3,anim(a0)
                beq.w   S3Spring_GroundBoostReturn
                move.w  x_pos(a0),d0
                move.w  d0,d1
                addi.w  #$28,d1
                btst    #0,status(a0)
                beq.s   S3Spring_SetBoostBoundsAndCheckP1
                move.w  d0,d1
                subi.w  #$28,d0

S3Spring_SetBoostBoundsAndCheckP1:
                move.w  y_pos(a0),d2
                move.w  d2,d3
                subi.w  #$18,d2
                addi.w  #$18,d3
                lea     (Player_1).w,a1
                btst    #1,status(a1)
                bne.s   S3Spring_TestGroundBoostPlayerTwo
                move.w  ground_vel(a1),d4
                btst    #0,status(a0)
                beq.s   S3Spring_CheckGroundBoostP1
                neg.w   d4

S3Spring_CheckGroundBoostP1:
                tst.w   d4
                bmi.s   S3Spring_TestGroundBoostPlayerTwo
                move.w  x_pos(a1),d4
                cmp.w   d0,d4
                blo.w   S3Spring_TestGroundBoostPlayerTwo
                cmp.w   d1,d4
                bhs.w   S3Spring_TestGroundBoostPlayerTwo
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blo.w   S3Spring_TestGroundBoostPlayerTwo
                cmp.w   d3,d4
                bhs.w   S3Spring_TestGroundBoostPlayerTwo
                move.w  d0,-(sp)
                bsr.w   LaunchPlayerFromHorizontalSpring
                move.w  (sp)+,d0

S3Spring_TestGroundBoostPlayerTwo:
                lea     (Player_2).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   S3Spring_GroundBoostReturn
                move.w  ground_vel(a1),d4
                btst    #0,status(a0)
                beq.s   S3Spring_CheckGroundBoostP2
                neg.w   d4

S3Spring_CheckGroundBoostP2:
                tst.w   d4
                bmi.s   S3Spring_GroundBoostReturn
                move.w  x_pos(a1),d4
                cmp.w   d0,d4
                blo.w   S3Spring_GroundBoostReturn
                cmp.w   d1,d4
                bhs.w   S3Spring_GroundBoostReturn
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blo.w   S3Spring_GroundBoostReturn
                cmp.w   d3,d4
                bhs.w   S3Spring_GroundBoostReturn
                bsr.w   LaunchPlayerFromHorizontalSpring

S3Spring_GroundBoostReturn:
                rts
; End of function BoostGroundedPlayersNearHorizontalSpring

; ---------------------------------------------------------------------------

Obj_Spring_Down:
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   SolidObjectFull2_1P
                cmpi.w  #-2,d4
                bne.s   S3Spring_TestNormalDownPlayerTwo
                bsr.s   LaunchPlayerFromDownSpring

S3Spring_TestNormalDownPlayerTwo:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                cmpi.w  #-2,d4
                bne.s   S3Spring_AnimateAndCullNormalDown
                bsr.s   LaunchPlayerFromDownSpring

S3Spring_AnimateAndCullNormalDown:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_2PSpring_Down:
                move.w  #$13,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   SolidObjectFull2_1P
                cmpi.w  #-2,d4
                bne.s   S3Spring_TestCompetitionDownPlayerTwo
                subq.w  #4,y_pos(a1)
                bsr.s   S3Spring_SetDownLaunchVelocity

S3Spring_TestCompetitionDownPlayerTwo:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                cmpi.w  #-2,d4
                bne.s   S3Spring_AnimateAndDrawCompetitionDown
                subq.w  #4,y_pos(a1)
                bsr.s   S3Spring_SetDownLaunchVelocity

S3Spring_AnimateAndDrawCompetitionDown:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromDownSpring:
                subq.w  #8,y_pos(a1)

S3Spring_SetDownLaunchVelocity:
                move.w  #1<<8,anim(a0)                  ; and prev_anim
                move.w  $30(a0),y_vel(a1)
                neg.w   y_vel(a1)
                cmpi.w  #$1000,y_vel(a1)
                bne.s   S3Spring_ApplyDownCrossAxisStop
                move.w  #$D00,y_vel(a1)

S3Spring_ApplyDownCrossAxisStop:
                move.b  subtype(a0),d0
                bpl.s   S3Spring_ConfigureDownFlip
                move.w  #0,x_vel(a1)

S3Spring_ConfigureDownFlip:
                btst    #0,d0
                beq.s   S3Spring_ApplyDownPrimaryLayerSelector
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                btst    #1,d0
                bne.s   S3Spring_ApplyDownFlipFacingSign
                move.b  #1,flips_remaining(a1)

S3Spring_ApplyDownFlipFacingSign:
                btst    #Status_Facing,status(a1)
                beq.s   S3Spring_ApplyDownPrimaryLayerSelector
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

S3Spring_ApplyDownPrimaryLayerSelector:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   S3Spring_ApplyDownSecondaryLayerSelector
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

S3Spring_ApplyDownSecondaryLayerSelector:
                cmpi.b  #8,d0
                bne.s   S3Spring_FinishDownAirStateAndSound
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

S3Spring_FinishDownAirStateAndSound:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #2,routine(a1)
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerFromDownSpring
