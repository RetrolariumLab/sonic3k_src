; Owner: objects/shared/springs/sk
; Responsibility: Diagonal spring collision, launch response, surface profiles and shared spring animation and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_Spring_UpDiag:
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  x_pos(a0),d4
                lea     SKSpring_UpDiagonalHeightSamples(pc),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   CollidePlayerWithHeightProfileSolid
                btst    #p1_standing_bit,status(a0)
                beq.s   SKSpring_TestUpDiagonalPlayerTwo
                bsr.s   LaunchPlayerFromUpDiagonalSpring

SKSpring_TestUpDiagonalPlayerTwo:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   CollidePlayerWithHeightProfileSolid
                btst    #p2_standing_bit,status(a0)
                beq.s   SKSpring_AnimateAndCullUpDiagonal
                bsr.s   LaunchPlayerFromUpDiagonalSpring

SKSpring_AnimateAndCullUpDiagonal:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                move.w  $32(a0),d0
                jmp     (Sprite_OnScreen_Test2).l

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromUpDiagonalSpring:
                btst    #0,status(a0)
                bne.s   SKSpring_TestFlippedUpDiagonalLaunchSide
                move.w  x_pos(a0),d0
                subq.w  #4,d0
                cmp.w   x_pos(a1),d0
                blo.s   SKSpring_SetUpDiagonalVelAndOffset
                rts
; ---------------------------------------------------------------------------

SKSpring_TestFlippedUpDiagonalLaunchSide:
                move.w  x_pos(a0),d0
                addq.w  #4,d0
                cmp.w   x_pos(a1),d0
                bhs.s   SKSpring_SetUpDiagonalVelAndOffset
                rts
; ---------------------------------------------------------------------------

; Use the configured speed for both axes and add six pixels to Y
SKSpring_SetUpDiagonalVelAndOffset:
                move.w  #5<<8,anim(a0)                  ; and prev_anim
                move.w  $30(a0),y_vel(a1)
                move.w  $30(a0),x_vel(a1)
                addq.w  #6,y_pos(a1)
                addq.w  #6,x_pos(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,status(a0)
                bne.s   SKSpring_SetUpDiagonalAirStateAndFlip
                bclr    #Status_Facing,status(a1)
                subi.w  #2*6,x_pos(a1)
                neg.w   x_vel(a1)

SKSpring_SetUpDiagonalAirStateAndFlip:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)
                move.b  subtype(a0),d0
                btst    #0,d0
                beq.s   SKSpring_CheckUpDiagonalPrimaryLayer
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #1,flips_remaining(a1)
                move.b  #8,flip_speed(a1)
                btst    #1,d0
                bne.s   SKSpring_ApplyUpDiagonalFlipFacingSign
                move.b  #3,flips_remaining(a1)

SKSpring_ApplyUpDiagonalFlipFacingSign:
                btst    #Status_Facing,status(a1)
                beq.s   SKSpring_CheckUpDiagonalPrimaryLayer
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

SKSpring_CheckUpDiagonalPrimaryLayer:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   SKSpring_CheckUpDiagonalSecondaryLayer
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

SKSpring_CheckUpDiagonalSecondaryLayer:
                cmpi.b  #8,d0
                bne.s   SKSpring_PlayUpDiagonalLaunchSound
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

SKSpring_PlayUpDiagonalLaunchSound:
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerFromUpDiagonalSpring

; ---------------------------------------------------------------------------

Obj_Spring_DownDiag:
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  x_pos(a0),d4
                lea     SKSpring_DownDiagonalHeightSamples(pc),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   CollidePlayerWithHeightProfileSolid
                cmpi.w  #-2,d4
                bne.s   SKSpring_TestDownDiagonalPlayerTwo
                bsr.s   LaunchPlayerFromDownDiagonalSpring

SKSpring_TestDownDiagonalPlayerTwo:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   CollidePlayerWithHeightProfileSolid
                cmpi.w  #-2,d4
                bne.s   SKSpring_AnimateAndCullDownDiagonal
                bsr.s   LaunchPlayerFromDownDiagonalSpring

SKSpring_AnimateAndCullDownDiagonal:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                move.w  $32(a0),d0
                jmp     (Sprite_OnScreen_Test2).l

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromDownDiagonalSpring:
                move.w  #5<<8,anim(a0)                  ; and prev_anim
                move.w  $30(a0),y_vel(a1)
                neg.w   y_vel(a1)
                move.w  $30(a0),x_vel(a1)
                subq.w  #6,y_pos(a1)
                addq.w  #6,x_pos(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,status(a0)
                bne.s   SKSpring_SetDownDiagonalAirStateAndFlip
                bclr    #Status_Facing,status(a1)
                subi.w  #2*6,x_pos(a1)
                neg.w   x_vel(a1)

SKSpring_SetDownDiagonalAirStateAndFlip:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #2,routine(a1)
                move.b  subtype(a0),d0
                btst    #0,d0
                beq.s   SKSpring_CheckDownDiagonalPrimaryLayer
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #1,flips_remaining(a1)
                move.b  #8,flip_speed(a1)
                btst    #1,d0
                bne.s   SKSpring_ApplyDownDiagonalFlipFacingSign
                move.b  #3,flips_remaining(a1)

SKSpring_ApplyDownDiagonalFlipFacingSign:
                btst    #Status_Facing,status(a1)
                beq.s   SKSpring_CheckDownDiagonalPrimaryLayer
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

SKSpring_CheckDownDiagonalPrimaryLayer:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   SKSpring_CheckDownDiagonalSecondaryLayer
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

SKSpring_CheckDownDiagonalSecondaryLayer:
                cmpi.b  #8,d0
                bne.s   SKSpring_PlayDownDiagonalLaunchSound
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

SKSpring_PlayDownDiagonalLaunchSound:
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerFromDownDiagonalSpring

; ---------------------------------------------------------------------------
SKSpring_UpDiagonalHeightSamples:
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $E
                dc.b    $C
                dc.b    $A
                dc.b    8
                dc.b    6
                dc.b    4
                dc.b    2
                dc.b    0
                dc.b    -2
                dc.b    -4
                dc.b    -4
                dc.b    -4
                dc.b    -4
                dc.b    -4
                dc.b    -4
                dc.b    -4
SKSpring_DownDiagonalHeightSamples:
                dc.b    -$C
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$E
                dc.b    -$C
                dc.b    -$A
                dc.b    -8
                dc.b    -6
                dc.b    -4
                dc.b    -2
                dc.b    0
                dc.b    2
                dc.b    4
                dc.b    4
                dc.b    4
                dc.b    4
                dc.b    4
                dc.b    4
                dc.b    4
                even
Ani_Spring:
                include "src/objects/shared/level_misc/animations/spring.s"
Map_Spring:
                include "src/objects/shared/level_misc/mappings/spring.s"
Map_2PSpring:
                include "src/objects/shared/level_misc/mappings/competition_spring.s"
