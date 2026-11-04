; Owner: objects/bonus/pachinko/sk
; Responsibility: Pachinko flipper timing, player contact, launch and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_PachinkoFlipper:
                move.l  #Map_PachinkoFlipper,mappings(a0)
                move.w  #make_art_tile(ArtTile_PachinkoMain+$62,0,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$1C,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.l  #PachinkoFlipper_UpdateSolidAndCapture,(a0)

PachinkoFlipper_UpdateSolidAndCapture:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                lea     (SKBonus_Flipper_SignedSurfaceHeightBytes).l,a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                lea     $36(a0),a3
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d5
                moveq   #p1_standing_bit,d6
                bsr.s   PachinkoFlipper_UpdateRider
                lea     $37(a0),a3
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d5
                moveq   #p2_standing_bit,d6
                bsr.s   PachinkoFlipper_UpdateRider
                tst.b   $38(a0)
                beq.s   PachinkoFlipper_AnimateAndCullVertically
                clr.b   $38(a0)
                lea     $36(a0),a3
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.w   PachinkoFlipper_LaunchRider
                lea     $37(a0),a3
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   PachinkoFlipper_LaunchRider
                move.b  #1,anim(a0)

PachinkoFlipper_AnimateAndCullVertically:
                lea     (Ani_PachinkoFlipper).l,a1
                jsr     (Animate_Sprite).l
                jmp     (PachinkoTriangle_DrawWithinCoarseY).l

; =============== S U B R O U T I N E =======================================

; Capture a standing player in rolling object control and slide along the flipper. A fresh jump requests the shared launch
PachinkoFlipper_UpdateRider:
                tst.w   (Debug_placement_mode).w
                bne.s   PachinkoFlipper_ClearCaptureAndControl
                move.b  (a3),d0
                bne.s   PachinkoFlipper_CheckJumpOrSlide
                btst    d6,status(a0)
                beq.s   PachinkoFlipper_InitialCaptureReturn
                addq.b  #1,(a3)
                move.w  #2<<8,anim(a1)                  ; and prev_anim
                move.b  #1,object_control(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bne.s   PachinkoFlipper_InitialCaptureReturn
                addq.w  #5,y_pos(a1)

PachinkoFlipper_InitialCaptureReturn:
                rts
; ---------------------------------------------------------------------------

PachinkoFlipper_CheckJumpOrSlide:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d5
                bne.s   PachinkoFlipper_QueueLaunchAndSlideNow
                btst    d6,status(a0)
                bne.s   PachinkoFlipper_SelectFacingSlopeAccel

PachinkoFlipper_ClearCaptureAndControl:
                move.b  #0,object_control(a1)
                move.b  #0,(a3)
                rts
; ---------------------------------------------------------------------------

; The flipped slope uses a ones' complement, giving -$19 instead of -$18
PachinkoFlipper_SelectFacingSlopeAccel:
                moveq   #$18,d1
                btst    #0,status(a0)
                beq.s   PachinkoFlipper_ApplySlopeAndSlide
                not.w   d1

PachinkoFlipper_ApplySlopeAndSlide:
                add.w   d1,ground_vel(a1)
                bra.w   PachinkoFlipper_DecaySpeedFromInput
; ---------------------------------------------------------------------------

PachinkoFlipper_QueueLaunchAndSlideNow:
                move.b  #1,$38(a0)
                bra.w   PachinkoFlipper_DecaySpeedFromInput
; End of function PachinkoFlipper_UpdateRider

; =============== S U B R O U T I N E =======================================

; Launch speed depends on the rider's position on the lever. Clear capture and restore routine 2
PachinkoFlipper_LaunchRider:
                bclr    d6,status(a0)
                beq.w   PachinkoFlipper_InitialCaptureReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                btst    #0,status(a0)
                beq.s   PachinkoFlipper_SetLaunchAngleAndPower
                neg.w   d0

PachinkoFlipper_SetLaunchAngleAndPower:
                addi.w  #$20,d0
                move.w  d0,d2
                lsl.w   #5,d2
                addi.w  #$800,d2
                neg.w   d2
                asr.w   #2,d0
                addi.w  #$40,d0
                jsr     (GetSineCosine).l
                muls.w  d2,d0
                muls.w  d2,d1
                asr.l   #8,d0
                asr.l   #8,d1
                move.w  d0,y_vel(a1)
                btst    #0,status(a0)
                beq.s   PachinkoFlipper_LaunchAndReleaseCapture
                neg.w   d1

PachinkoFlipper_LaunchAndReleaseCapture:
                move.w  d1,x_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                move.b  #0,object_control(a1)
                move.b  #0,(a3)
                moveq   #signextendB(sfx_Flipper),d0
                jmp     (Play_SFX).l
; End of function PachinkoFlipper_LaunchRider

; ---------------------------------------------------------------------------

PachinkoFlipper_DecaySpeedFromInput:
                move.l  a0,-(sp)
                movea.l a1,a0
                move.w  ground_vel(a0),d0
                beq.s   PachinkoFlipper_MoveAndCorrectLeftWall
                bmi.s   PachinkoFlipper_DecayNegativeClampCarry
                sub.w   d5,d0
                bcc.s   PachinkoFlipper_StorePositiveDecay
                move.w  #0,d0

PachinkoFlipper_StorePositiveDecay:
                move.w  d0,ground_vel(a0)
                bra.s   PachinkoFlipper_MoveAndCorrectLeftWall
; ---------------------------------------------------------------------------

PachinkoFlipper_DecayNegativeClampCarry:
                add.w   d5,d0
                bcc.s   SKBonus_Flipper_StoreNegativeDecayResult
                move.w  #0,d0

SKBonus_Flipper_StoreNegativeDecayResult:
                move.w  d0,ground_vel(a0)

PachinkoFlipper_MoveAndCorrectLeftWall:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                jsr     (MoveSprite_TestGravity2).l
                jsr     (CheckLeftWallDist).l
                tst.w   d1
                bpl.s   PachinkoFlipper_CorrectRightWall
                sub.w   d1,x_pos(a0)
                move.w  #0,ground_vel(a0)

PachinkoFlipper_CorrectRightWall:
                jsr     (CheckRightWallDist).l
                tst.w   d1
                bpl.s   PachinkoFlipper_RestoreFlipperPointer
                add.w   d1,x_pos(a0)
                move.w  #0,ground_vel(a0)

PachinkoFlipper_RestoreFlipperPointer:
                movea.l (sp)+,a0
                rts
; ---------------------------------------------------------------------------
SKBonus_Flipper_SignedSurfaceHeightBytes:
                dc.b    -4,  -4,  -4,  -4,  -4,  -4,  -4,  -4,  -4,  -5,  -6,  -7,  -8,  -9, -$A, -$B, -$C, -$D, -$E, -$F
                dc.b    -$10,-$11,-$12,-$13,-$14,-$15,-$16,-$17,-$18,-$19,-$1A,-$1B
                even
Ani_PachinkoFlipper:
                include "src/objects/shared/zones/pachinko/animations/flipper.s"
Map_PachinkoFlipper:
                include "src/objects/shared/zones/pachinko/mappings/flipper.s"
