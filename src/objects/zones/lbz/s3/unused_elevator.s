; Owner: objects/zones/lbz/s3
; Responsibility: Unused Launch Base elevator initialization, movement and player riding
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
S3LBZUnusedLift_SubtypeHalfTravel:
                dc.b    $10, $18, $20, $38, $40, $68
                even
; ---------------------------------------------------------------------------

Obj_LBZUnusedElevator:
                move.l  #Map_LBZUnusedElevator,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  #$30,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  y_pos(a0),$32(a0)
                move.w  #$8000,objoff_16(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #4,d0
                andi.w  #$F,d0
                move.b  S3LBZUnusedLift_SubtypeHalfTravel(pc,d0.w),d0
                lsl.w   #3,d0
                move.w  d0,$38(a0)
                sub.w   d0,y_pos(a0)
                btst    #0,status(a0)
                beq.s   S3LBZUnusedLift_StartElevatorStates
                add.w   d0,d0
                add.w   d0,y_pos(a0)
                move.b  #1,$34(a0)

S3LBZUnusedLift_StartElevatorStates:
                move.l  #S3LBZUnusedLift_UpdateElevatorAndSolid,(a0)

S3LBZUnusedLift_UpdateElevatorAndSolid:
                move.w  $36(a0),d0
                move.w  S3LBZUnusedLift_ElevatorStateTable(pc,d0.w),d1
                jsr     S3LBZUnusedLift_ElevatorStateTable(pc,d1.w)
                tst.b   render_flags(a0)
                bpl.s   S3LBZUnusedLift_DrawElevator
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l

S3LBZUnusedLift_DrawElevator:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
S3LBZUnusedLift_ElevatorStateTable:
                dc.w    S3LBZUnusedLift_TryBeginOutboundTravel-S3LBZUnusedLift_ElevatorStateTable
                dc.w    S3LBZUnusedLift_StepOutboundTravel-S3LBZUnusedLift_ElevatorStateTable
                dc.w    S3LBZUnusedLift_TryBeginReturnTravel-S3LBZUnusedLift_ElevatorStateTable
                dc.w    S3LBZUnusedLift_StepReturnTravel-S3LBZUnusedLift_ElevatorStateTable
; ---------------------------------------------------------------------------

S3LBZUnusedLift_TryBeginOutboundTravel:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                beq.s   S3LBZUnusedLift_OutboundGateReturn
                move.w  #$8000,objoff_16(a0)
                addq.w  #2,$36(a0)

S3LBZUnusedLift_OutboundGateReturn:
                rts
; ---------------------------------------------------------------------------

S3LBZUnusedLift_StepOutboundTravel:
                bsr.w   StepLbzUnusedElevatorMidpointMotion
                tst.w   y_vel(a0)
                bne.s   S3LBZUnusedLift_OutboundStepReturn
                addq.w  #2,$36(a0)
                move.w  d0,y_pos(a0)
                move.w  $38(a0),d0
                sub.w   d0,y_pos(a0)
                btst    #0,status(a0)
                bne.s   S3LBZUnusedLift_OutboundStepReturn
                add.w   d0,d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3LBZUnusedLift_OutboundStepReturn:
                rts
; ---------------------------------------------------------------------------

S3LBZUnusedLift_TryBeginReturnTravel:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                bne.s   S3LBZUnusedLift_ReturnGateReturn
                move.w  #$8000,objoff_16(a0)
                addq.w  #2,$36(a0)

S3LBZUnusedLift_ReturnGateReturn:
                rts
; ---------------------------------------------------------------------------

S3LBZUnusedLift_StepReturnTravel:
                bsr.w   StepLbzUnusedElevatorMidpointMotion
                tst.w   y_vel(a0)
                bne.s   S3LBZUnusedLift_ReturnStepDone
                clr.w   $36(a0)
                move.w  d0,y_pos(a0)
                move.w  $38(a0),d0
                sub.w   d0,y_pos(a0)
                btst    #0,status(a0)
                beq.s   S3LBZUnusedLift_ReturnStepDone
                add.w   d0,d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3LBZUnusedLift_ReturnStepDone:
                rts

; =============== S U B R O U T I N E =======================================

StepLbzUnusedElevatorMidpointMotion:
                move.w  y_pos(a0),d2
                moveq   #8,d1
                tst.b   $34(a0)
                bne.s   S3LBZUnusedLift_StepNegativeTravel
                add.w   d1,y_vel(a0)
                move.w  y_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a0)
                move.w  $32(a0),d0
                cmp.w   y_pos(a0),d0
                bhi.s   S3LBZUnusedLift_MidpointStepReturn
                beq.s   S3LBZUnusedLift_CrossPositiveMidpoint
                sub.w   d0,d2
                neg.w   d2
                add.w   d0,d2
                move.w  d2,y_pos(a0)
                neg.w   $16(a0)
                move.b  #1,$34(a0)
                bra.s   S3LBZUnusedLift_MidpointStepReturn
; ---------------------------------------------------------------------------

; At the exact midpoint, negate the fractional Y word and apply an extra acceleration step
S3LBZUnusedLift_CrossPositiveMidpoint:
                neg.w   $16(a0)
                add.w   d1,y_vel(a0)
                move.b  #1,$34(a0)
                bra.s   S3LBZUnusedLift_MidpointStepReturn
; ---------------------------------------------------------------------------

S3LBZUnusedLift_StepNegativeTravel:
                sub.w   d1,y_vel(a0)
                move.w  y_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a0)
                move.w  $32(a0),d0
                cmp.w   y_pos(a0),d0
                blo.s   S3LBZUnusedLift_MidpointStepReturn
                beq.s   S3LBZUnusedLift_CrossNegativeMidpoint
                sub.w   d0,d2
                neg.w   d2
                add.w   d0,d2
                move.w  d2,y_pos(a0)
                neg.w   $16(a0)
                move.b  #0,$34(a0)
                bra.s   S3LBZUnusedLift_MidpointStepReturn
; ---------------------------------------------------------------------------

; At the exact midpoint, negate the fractional Y word and subtract another acceleration step
S3LBZUnusedLift_CrossNegativeMidpoint:
                neg.w   $16(a0)
                sub.w   d1,y_vel(a0)
                move.b  #0,$34(a0)

S3LBZUnusedLift_MidpointStepReturn:
                rts
; End of function StepLbzUnusedElevatorMidpointMotion

; ---------------------------------------------------------------------------
Map_LBZUnusedElevator:
                include "src/objects/shared/zones/lbz/mappings/unused_elevator.s"
