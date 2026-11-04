; Owner: objects/zones/lrz/sk
; Responsibility: Dash elevator activation, motion, player riding and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZDashElevator:
                move.l  #Map_LRZDashElevator,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZMisc,0,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  y_pos(a0),$46(a0)
                moveq   #0,d1
                move.b  subtype(a0),d0
                bpl.s   SKLRZDashLift_InitTravelAndEndpoint
                moveq   #$20,d1
                move.w  d1,$30(a0)

; The original facing bit chooses the starting end and is then cleared
SKLRZDashLift_InitTravelAndEndpoint:
                andi.w  #$7F,d0
                lsl.w   #3,d0
                move.w  d0,$34(a0)
                bclr    #0,status(a0)
                beq.s   SKLRZDashLift_InitDriveState
                move.w  d0,$30(a0)
                sub.w   d1,$30(a0)
                sub.w   d0,$46(a0)

SKLRZDashLift_InitDriveState:
                move.l  #SKLRZDashLift_SumDriveAndMove,(a0)

SKLRZDashLift_SumDriveAndMove:
                moveq   #0,d5
                lea     $2E(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.w   AccumulatePlayerDriveForLrzDashElevator
                addq.w  #1,a2
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   AccumulatePlayerDriveForLrzDashElevator
                move.l  $30(a0),d0
                swap    d5
                asr.l   #3,d5
                add.l   d5,d0
                bpl.s   SKLRZDashLift_ClampUpperTravel
                moveq   #0,d0
                moveq   #0,d5

SKLRZDashLift_ClampUpperTravel:
                move.l  $34(a0),d1
                cmp.l   d1,d0
                blo.s   SKLRZDashLift_ApplyTravelAndAnimate
                move.l  d1,d0
                moveq   #0,d5

SKLRZDashLift_ApplyTravelAndAnimate:
                move.l  d0,$30(a0)
                swap    d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                bne.s   SKLRZDashLift_CheckSolidAndDraw
                tst.l   d5
                beq.s   SKLRZDashLift_CheckSolidAndDraw
                bpl.s   SKLRZDashLift_StepFrameBackward
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   SKLRZDashLift_TryPlayMovingSound
                move.b  #0,mapping_frame(a0)
                bra.s   SKLRZDashLift_TryPlayMovingSound
; ---------------------------------------------------------------------------

SKLRZDashLift_StepFrameBackward:
                subq.b  #1,mapping_frame(a0)
                bcc.s   SKLRZDashLift_TryPlayMovingSound
                move.b  #2,mapping_frame(a0)

SKLRZDashLift_TryPlayMovingSound:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   SKLRZDashLift_CheckSolidAndDraw
                moveq   #signextendB(sfx_ConveyorPlatform),d0
                jsr     (Play_SFX).l

SKLRZDashLift_CheckSolidAndDraw:
                move.w  #$2B,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

AccumulatePlayerDriveForLrzDashElevator:
                tst.b   (a2)
                bne.s   SKLRZDashLift_CheckDriverState
                btst    d6,status(a0)
                beq.s   SKLRZDashLift_DriveCaptureReturn
                cmpi.b  #9,anim(a1)
                bne.s   SKLRZDashLift_DriveCaptureReturn
                move.w  x_pos(a0),x_pos(a1)
                move.b  #1,(a2)

SKLRZDashLift_DriveCaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKLRZDashLift_CheckDriverState:
                btst    #Status_InAir,status(a1)
                bne.s   SKLRZDashLift_ReleaseDriverAndStopX
                cmpi.b  #2,anim(a1)
                beq.s   SKLRZDashLift_CenterDriverAndApplyDrag
                cmpi.b  #9,anim(a1)
                beq.s   SKLRZDashLift_CenterDriverAndApplyDrag

SKLRZDashLift_ReleaseDriverAndStopX:
                move.w  #0,x_vel(a1)
                move.b  #0,(a2)
                rts
; ---------------------------------------------------------------------------

SKLRZDashLift_CenterDriverAndApplyDrag:
                move.w  x_pos(a0),x_pos(a1)
                move.w  ground_vel(a1),d0
                beq.s   SKLRZDashLift_CalcSignedDrive
                bpl.s   SKLRZDashLift_DampPositiveGroundSpeed
                addi.w  #$40,d0
                bcc.s   SKLRZDashLift_StoreDampedGroundSpeed
                moveq   #0,d0
                bra.s   SKLRZDashLift_StoreDampedGroundSpeed
; ---------------------------------------------------------------------------

SKLRZDashLift_DampPositiveGroundSpeed:
                subi.w  #$40,d0
                bcc.s   SKLRZDashLift_StoreDampedGroundSpeed
                moveq   #0,d0

SKLRZDashLift_StoreDampedGroundSpeed:
                move.w  d0,ground_vel(a1)

; Add the spin dash counter to 8 as a byte, then apply the rider's facing sign
SKLRZDashLift_CalcSignedDrive:
                moveq   #8,d0
                add.b   spin_dash_counter(a1),d0
                btst    #Status_Facing,status(a1)
                bne.s   SKLRZDashLift_AccumulateDrive
                neg.w   d0

SKLRZDashLift_AccumulateDrive:
                add.w   d0,d5
                rts
; End of function AccumulatePlayerDriveForLrzDashElevator

; ---------------------------------------------------------------------------
Map_LRZDashElevator:
                include "src/objects/shared/zones/lrz/mappings/dash_elevator.s"
