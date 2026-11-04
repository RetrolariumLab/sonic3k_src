; Owner: game/collision/s3
; Responsibility: Player floor-angle attachment and transitions along right walls, ceilings and left walls
; Source provenance and ranges: config/reconstruction/source_layout.json
Player_AnglePos:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   S3Attach_CheckObjectRider
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

S3Attach_CheckObjectRider:
                move.b  top_solid_bit(a0),d5
                btst    #Status_OnObj,status(a0)
                beq.s   S3Attach_InitAnglesAndRound
                moveq   #0,d0
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                rts
; ---------------------------------------------------------------------------

S3Attach_InitAnglesAndRound:
                moveq   #3,d0
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                move.b  angle(a0),d0
                addi.b  #$20,d0
                bpl.s   S3Attach_AdjustLowerHalfAngle
                move.b  angle(a0),d0
                bpl.s   S3Attach_UpperHalfBias
                subq.b  #1,d0

S3Attach_UpperHalfBias:
                addi.b  #$20,d0
                bra.s   S3Attach_DispatchSurface
; ---------------------------------------------------------------------------

S3Attach_AdjustLowerHalfAngle:
                move.b  angle(a0),d0
                bpl.s   S3Attach_LowerHalfBias
                addq.b  #1,d0

S3Attach_LowerHalfBias:
                addi.b  #$1F,d0

S3Attach_DispatchSurface:
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   Player_WalkVertL
                cmpi.b  #$80,d0
                beq.w   Player_WalkCeiling
                cmpi.b  #$C0,d0
                beq.w   Player_WalkVertR
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  y_radius(a0),d0
                ext.w   d0
                add.w   d0,d2
                move.b  x_radius(a0),d0
                ext.w   d0
                add.w   d0,d3
                lea     (Primary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindFloor
                move.w  d1,-(sp)
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  y_radius(a0),d0
                ext.w   d0
                add.w   d0,d2
                move.b  x_radius(a0),d0
                ext.w   d0
                neg.w   d0
                add.w   d0,d3
                lea     (Secondary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindFloor
                move.w  (sp)+,d0
                bsr.w   Player_Angle
                tst.w   d1
                beq.s   S3AttachFloor_Return
                bpl.s   S3AttachFloor_CheckGap
                cmpi.w  #-$E,d1
                blt.s   S3AttachFloor_Return
                add.w   d1,y_pos(a0)

S3AttachFloor_Return:
                rts
; ---------------------------------------------------------------------------

; The convex flag bypasses the speed-based gap limit
S3AttachFloor_CheckGap:
                tst.b   stick_to_convex(a0)
                bne.s   S3AttachFloor_SnapY
                move.b  x_vel(a0),d0
                bpl.s   S3AttachFloor_ClampGapLimit
                neg.b   d0

; Use the magnitude of the high byte of X speed plus four, capped at 14 pixels
S3AttachFloor_ClampGapLimit:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   S3AttachFloor_CompareGapByte
                move.b  #$E,d0

S3AttachFloor_CompareGapByte:
                cmp.b   d0,d1
                bgt.s   S3AttachFloor_Detach

S3AttachFloor_SnapY:
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3AttachFloor_Detach:
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)
                rts
; End of function Player_AnglePos

; =============== S U B R O U T I N E =======================================

Player_Angle:
                move.w  d0,d3
                move.b  (Secondary_Angle).w,d2
                cmp.w   d0,d1
                ble.s   S3AttachAngle_CheckSample
                move.b  (Primary_Angle).w,d2
                move.w  d1,d3
                move.w  d0,d1

S3AttachAngle_CheckSample:
                btst    #0,d2
                bne.s   S3AttachAngle_RoundCurrent
                move.b  d2,d0
                sub.b   angle(a0),d0
                bpl.s   S3AttachAngle_CheckDelta
                neg.b   d0

; Accept angle changes below $20. Larger changes use the current angle's quadrant
S3AttachAngle_CheckDelta:
                cmpi.b  #$20,d0
                bhs.s   S3AttachAngle_RoundCurrent
                move.b  d2,angle(a0)
                rts
; ---------------------------------------------------------------------------

S3AttachAngle_RoundCurrent:
                move.b  angle(a0),d2
                addi.b  #$20,d2
                andi.b  #$C0,d2
                move.b  d2,angle(a0)
                rts
; End of function Player_Angle

; ---------------------------------------------------------------------------

Player_WalkVertR:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  x_radius(a0),d0
                ext.w   d0
                neg.w   d0
                add.w   d0,d2
                move.b  y_radius(a0),d0
                ext.w   d0
                add.w   d0,d3
                lea     (Primary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindWall
                move.w  d1,-(sp)
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  x_radius(a0),d0
                ext.w   d0
                add.w   d0,d2
                move.b  y_radius(a0),d0
                ext.w   d0
                add.w   d0,d3
                lea     (Secondary_Angle).w,a4
                movea.w #Collision_Scan_Step,a3
                move.w  #0,d6
                bsr.w   FindWall
                move.w  (sp)+,d0
                bsr.w   Player_Angle
                tst.w   d1
                beq.s   S3AttachRight_Return
                bpl.s   S3AttachRight_CheckGap
                cmpi.w  #-$E,d1
                blt.s   S3AttachRight_ArmAngleHold
                tst.b   $41(a0)
                bne.s   S3AttachRight_TickAngleHold
                add.w   d1,x_pos(a0)

S3AttachRight_Return:
                rts
; ---------------------------------------------------------------------------

S3AttachRight_TickAngleHold:
                subq.b  #1,$41(a0)
                move.b  #$C0,angle(a0)
                rts
; ---------------------------------------------------------------------------

; Only zone/act $0000 holds the $C0 wall angle for three updates
S3AttachRight_ArmAngleHold:
                tst.w   (Current_zone_and_act).w
                bne.s   S3AttachRight_Return
                move.b  #$C0,angle(a0)
                move.b  #3,$41(a0)
                rts
; ---------------------------------------------------------------------------

S3AttachRight_CheckGap:
                tst.b   stick_to_convex(a0)
                bne.s   S3AttachRight_SnapX
                move.b  y_vel(a0),d0
                bpl.s   S3AttachRight_ClampGapLimit
                neg.b   d0

S3AttachRight_ClampGapLimit:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   S3AttachRight_CompareGapByte
                move.b  #$E,d0

S3AttachRight_CompareGapByte:
                cmp.b   d0,d1
                bgt.s   S3AttachRight_Detach

S3AttachRight_SnapX:
                add.w   d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3AttachRight_Detach:
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)
                rts
; ---------------------------------------------------------------------------

Player_WalkCeiling:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d2
                eori.w  #$F,d2
                move.b  x_radius(a0),d0
                ext.w   d0
                add.w   d0,d3
                lea     (Primary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$800,d6
                bsr.w   FindFloor
                move.w  d1,-(sp)
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d2
                eori.w  #$F,d2
                move.b  x_radius(a0),d0
                ext.w   d0
                sub.w   d0,d3
                lea     (Secondary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$800,d6
                bsr.w   FindFloor
                move.w  (sp)+,d0
                bsr.w   Player_Angle
                tst.w   d1
                beq.s   S3AttachCeiling_Return
                bpl.s   S3AttachCeiling_CheckGap
                cmpi.w  #-$E,d1
                blt.s   S3AttachCeiling_Return
                sub.w   d1,y_pos(a0)

S3AttachCeiling_Return:
                rts
; ---------------------------------------------------------------------------

S3AttachCeiling_CheckGap:
                tst.b   stick_to_convex(a0)
                bne.s   S3AttachCeiling_SnapY
                move.b  x_vel(a0),d0
                bpl.s   S3AttachCeiling_ClampGapLimit
                neg.b   d0

S3AttachCeiling_ClampGapLimit:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   S3AttachCeiling_CompareGapByte
                move.b  #$E,d0

S3AttachCeiling_CompareGapByte:
                cmp.b   d0,d1
                bgt.s   S3AttachCeiling_Detach

S3AttachCeiling_SnapY:
                sub.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3AttachCeiling_Detach:
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)
                rts
; ---------------------------------------------------------------------------

Player_WalkVertL:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  x_radius(a0),d0
                ext.w   d0
                sub.w   d0,d2
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d3
                eori.w  #$F,d3
                lea     (Primary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$400,d6
                bsr.w   FindWall
                move.w  d1,-(sp)
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                moveq   #0,d0
                move.b  x_radius(a0),d0
                ext.w   d0
                add.w   d0,d2
                move.b  y_radius(a0),d0
                ext.w   d0
                sub.w   d0,d3
                eori.w  #$F,d3
                lea     (Secondary_Angle).w,a4
                movea.w #-Collision_Scan_Step,a3
                move.w  #$400,d6
                bsr.w   FindWall
                move.w  (sp)+,d0
                bsr.w   Player_Angle
                tst.w   d1
                beq.s   S3AttachLeft_Return
                bpl.s   S3AttachLeft_CheckGap
                cmpi.w  #-$E,d1
                blt.s   S3AttachLeft_Return
                sub.w   d1,x_pos(a0)

S3AttachLeft_Return:
                rts
; ---------------------------------------------------------------------------

S3AttachLeft_CheckGap:
                tst.b   stick_to_convex(a0)
                bne.s   S3AttachLeft_SnapX
                move.b  y_vel(a0),d0
                bpl.s   S3AttachLeft_ClampGapLimit
                neg.b   d0

S3AttachLeft_ClampGapLimit:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   S3AttachLeft_CompareGapByte
                move.b  #$E,d0

S3AttachLeft_CompareGapByte:
                cmp.b   d0,d1
                bgt.s   S3AttachLeft_Detach

S3AttachLeft_SnapX:
                sub.w   d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3AttachLeft_Detach:
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)
                rts
