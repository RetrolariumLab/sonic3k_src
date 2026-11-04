; Owner: game/collision/sk
; Responsibility: Player floor-angle attachment and transitions along right walls, ceilings and left walls
; Source provenance and ranges: config/reconstruction/source_layout.json
Player_AnglePos:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   SKAttach_CheckObjectRider
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

SKAttach_CheckObjectRider:
                move.b  top_solid_bit(a0),d5
                btst    #Status_OnObj,status(a0)
                beq.s   SKAttach_InitAnglesAndRound
                moveq   #0,d0
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                rts
; ---------------------------------------------------------------------------

SKAttach_InitAnglesAndRound:
                moveq   #3,d0
                move.b  d0,(Primary_Angle).w
                move.b  d0,(Secondary_Angle).w
                move.b  angle(a0),d0
                addi.b  #$20,d0
                bpl.s   SKAttach_AdjustLowerHalfAngle
                move.b  angle(a0),d0
                bpl.s   SKAttach_UpperHalfBias
                subq.b  #1,d0

SKAttach_UpperHalfBias:
                addi.b  #$20,d0
                bra.s   SKAttach_DispatchSurface
; ---------------------------------------------------------------------------

SKAttach_AdjustLowerHalfAngle:
                move.b  angle(a0),d0
                bpl.s   SKAttach_LowerHalfBias
                addq.b  #1,d0

SKAttach_LowerHalfBias:
                addi.b  #$1F,d0

SKAttach_DispatchSurface:
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
                beq.s   SKAttachFloor_Return
                bpl.s   SKAttachFloor_CheckGap
                cmpi.w  #-$E,d1
                blt.s   SKAttachFloor_Return
                add.w   d1,y_pos(a0)

SKAttachFloor_Return:
                rts
; ---------------------------------------------------------------------------

; The convex flag bypasses the speed-based gap limit
SKAttachFloor_CheckGap:
                tst.b   stick_to_convex(a0)
                bne.s   SKAttachFloor_SnapY
                move.b  x_vel(a0),d0
                bpl.s   SKAttachFloor_ClampGapLimit
                neg.b   d0

; Use the magnitude of the high byte of X speed plus four, capped at 14 pixels
SKAttachFloor_ClampGapLimit:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   SKAttachFloor_CompareGapByte
                move.b  #$E,d0

SKAttachFloor_CompareGapByte:
                cmp.b   d0,d1
                bgt.s   SKAttachFloor_Detach

SKAttachFloor_SnapY:
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKAttachFloor_Detach:
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
                ble.s   SKAttachAngle_CheckSample
                move.b  (Primary_Angle).w,d2
                move.w  d1,d3
                move.w  d0,d1

SKAttachAngle_CheckSample:
                btst    #0,d2
                bne.s   SKAttachAngle_RoundCurrent
                move.b  d2,d0
                sub.b   angle(a0),d0
                bpl.s   SKAttachAngle_CheckDelta
                neg.b   d0

; Accept angle changes below $20. Larger changes use the current angle's quadrant
SKAttachAngle_CheckDelta:
                cmpi.b  #$20,d0
                bhs.s   SKAttachAngle_RoundCurrent
                move.b  d2,angle(a0)
                rts
; ---------------------------------------------------------------------------

SKAttachAngle_RoundCurrent:
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
                beq.s   SKCollision_ReturnRightWallAttachment
                bpl.s   SKAttachRight_CheckGap
                cmpi.w  #-$E,d1
                blt.s   SKAttachRight_ArmAngleHold
                tst.b   $41(a0)
                bne.s   SKAttachRight_TickAngleHold
                add.w   d1,x_pos(a0)

SKCollision_ReturnRightWallAttachment:
                rts
; ---------------------------------------------------------------------------

SKAttachRight_TickAngleHold:
                subq.b  #1,$41(a0)
                move.b  #$C0,angle(a0)
                rts
; ---------------------------------------------------------------------------

; Only zone/act $0000 holds the $C0 wall angle for three updates
SKAttachRight_ArmAngleHold:
                tst.w   (Current_zone_and_act).w
                bne.s   SKCollision_ReturnRightWallAttachment
                move.b  #$C0,angle(a0)
                move.b  #3,$41(a0)
                rts
; ---------------------------------------------------------------------------

SKAttachRight_CheckGap:
                tst.b   stick_to_convex(a0)
                bne.s   SKAttachRight_SnapX
                move.b  y_vel(a0),d0
                bpl.s   SKAttachRight_ClampGapLimit
                neg.b   d0

SKAttachRight_ClampGapLimit:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   SKCollision_CompareRightWallGapLowByte
                move.b  #$E,d0

SKCollision_CompareRightWallGapLowByte:
                cmp.b   d0,d1
                bgt.s   SKAttachRight_Detach

SKAttachRight_SnapX:
                add.w   d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKAttachRight_Detach:
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
                beq.s   SKCollision_ReturnCeilingAttachment
                bpl.s   SKAttachCeiling_CheckGap
                cmpi.w  #-$E,d1
                blt.s   SKCollision_ReturnCeilingAttachment
                sub.w   d1,y_pos(a0)

SKCollision_ReturnCeilingAttachment:
                rts
; ---------------------------------------------------------------------------

SKAttachCeiling_CheckGap:
                tst.b   stick_to_convex(a0)
                bne.s   SKAttachCeiling_SnapY
                move.b  x_vel(a0),d0
                bpl.s   SKCollision_ClampCeilingGapAllowanceByte
                neg.b   d0

SKCollision_ClampCeilingGapAllowanceByte:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   SKCollision_CompareCeilingGapLowByte
                move.b  #$E,d0

SKCollision_CompareCeilingGapLowByte:
                cmp.b   d0,d1
                bgt.s   SKAttachCeiling_Detach

SKAttachCeiling_SnapY:
                sub.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKAttachCeiling_Detach:
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
                beq.s   SKCollision_ReturnLeftWallAttachment
                bpl.s   SKAttachLeft_CheckGap
                cmpi.w  #-$E,d1
                blt.s   SKCollision_ReturnLeftWallAttachment
                sub.w   d1,x_pos(a0)

SKCollision_ReturnLeftWallAttachment:
                rts
; ---------------------------------------------------------------------------

SKAttachLeft_CheckGap:
                tst.b   stick_to_convex(a0)
                bne.s   SKAttachLeft_SnapX
                move.b  y_vel(a0),d0
                bpl.s   SKAttachLeft_ClampGapLimit
                neg.b   d0

SKAttachLeft_ClampGapLimit:
                addq.b  #4,d0
                cmpi.b  #$E,d0
                blo.s   SKCollision_CompareLeftWallGapLowByte
                move.b  #$E,d0

SKCollision_CompareLeftWallGapLowByte:
                cmp.b   d0,d1
                bgt.s   SKAttachLeft_Detach

SKAttachLeft_SnapX:
                sub.w   d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKAttachLeft_Detach:
                bset    #Status_InAir,status(a0)
                bclr    #Status_Push,status(a0)
                move.b  #1,prev_anim(a0)
                rts
