; Owner: objects/zones/cnz/s3
; Responsibility: Carnival Night spiral tube player transport, directional motion and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZSpiralTube:
                lea     (Player_1).w,a1
                lea     $30(a0),a4
                bsr.s   UpdatePlayerInCnzSpiralTube
                lea     (Player_2).w,a1
                lea     $3A(a0),a4
                bsr.s   UpdatePlayerInCnzSpiralTube
                move.b  $30(a0),d0
                add.b   $3A(a0),d0
                beq.s   S3CNZSpiral_CullWhenIdle
                rts
; ---------------------------------------------------------------------------

S3CNZSpiral_CullWhenIdle:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInCnzSpiralTube:
                moveq   #0,d0
                move.b  (a4),d0
                move.w  S3CNZSpiral_RiderStateTable(pc,d0.w),d0
                jmp     S3CNZSpiral_RiderStateTable(pc,d0.w)
; End of function UpdatePlayerInCnzSpiralTube

; ---------------------------------------------------------------------------
S3CNZSpiral_RiderStateTable:
                dc.w    S3CNZSpiral_TryCaptureAtEntrance-S3CNZSpiral_RiderStateTable
                dc.w    S3CNZSpiral_OrbitEntrance-S3CNZSpiral_RiderStateTable
                dc.w    S3CNZSpiral_DescendSpiral-S3CNZSpiral_RiderStateTable
                dc.w    S3CNZSpiral_StepExitSegment-S3CNZSpiral_RiderStateTable
; ---------------------------------------------------------------------------

S3CNZSpiral_TryCaptureAtEntrance:
                tst.w   (Debug_placement_mode).w
                bne.w   S3CNZSpiral_EntranceReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$80,d0
                bhs.s   S3CNZSpiral_EntranceReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$10,d1
                cmpi.w  #$20,d1
                bhs.s   S3CNZSpiral_EntranceReturn
                tst.b   object_control(a1)
                bne.s   S3CNZSpiral_EntranceReturn
                addq.b  #2,(a4)
                move.b  #$81,object_control(a1)
                move.b  #2,anim(a1)
                move.w  #$800,ground_vel(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                clr.b   1(a4)
                moveq   #$30,d1
                cmpi.w  #$40,d0
                bhs.s   S3CNZSpiral_AlignEntrantAndPlayRoll
                neg.w   d1
                move.b  #$80,1(a4)

S3CNZSpiral_AlignEntrantAndPlayRoll:
                add.w   x_pos(a0),d1
                move.w  d1,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l

S3CNZSpiral_EntranceReturn:
                rts
; ---------------------------------------------------------------------------

S3CNZSpiral_OrbitEntrance:
                move.b  1(a4),d0
                addq.b  #8,1(a4)
                jsr     (GetSineCosine).l
                asr.w   #3,d1
                move.w  d1,d0
                asr.w   #1,d1
                add.w   d1,d0
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                moveq   #0,d0
                btst    #0,(Ring_count+1).w
                beq.s   S3CNZSpiral_TryBeginDescent
                move.w  #$80,d0

; Match the incremented orbit phase selected by ring-count parity before descending
S3CNZSpiral_TryBeginDescent:
                cmp.b   1(a4),d0
                bne.s   S3CNZSpiral_OrbitReturn
                addq.b  #2,(a4)
                move.w  #$C0,2(a4)

S3CNZSpiral_OrbitReturn:
                rts
; ---------------------------------------------------------------------------

S3CNZSpiral_DescendSpiral:
                move.b  1(a4),d0
                addi.b  #$C,1(a4)
                jsr     (GetSineCosine).l
                asr.w   #3,d1
                move.w  d1,d0
                asr.w   #1,d1
                add.w   d1,d0
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                addq.w  #2,y_pos(a1)
                subq.w  #1,2(a4)
                bne.s   S3CNZSpiral_DescentReturn
                moveq   #0,d0
                move.w  x_pos(a0),d1
                sub.w   x_pos(a1),d1
                bcc.s   S3CNZSpiral_SelectExitRoute
                moveq   #1,d0

S3CNZSpiral_SelectExitRoute:
                add.b   subtype(a0),d0
                bsr.w   InitializeCnzSpiralExitRoute
                addq.b  #2,(a4)

S3CNZSpiral_DescentReturn:
                rts
; ---------------------------------------------------------------------------

S3CNZSpiral_StepExitSegment:
                subq.b  #1,2(a4)
                bpl.s   S3CNZSpiral_IntegrateExitMotion
                movea.l 6(a4),a2
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)
                move.l  a2,6(a4)
                subq.w  #4,4(a4)
                beq.s   S3CNZSpiral_ReleaseAtFinalWaypoint
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  #$C00,d2
                bra.w   S3CNZSpiral_CalcSegmentVelocity
; ---------------------------------------------------------------------------

S3CNZSpiral_IntegrateExitMotion:
                move.l  x_pos(a1),d2
                move.l  y_pos(a1),d3
                move.w  x_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d2
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d2,x_pos(a1)
                move.l  d3,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

; Clear object control, then still integrate one step with the current velocity
S3CNZSpiral_ReleaseAtFinalWaypoint:
                andi.w  #$FFF,y_pos(a1)
                clr.b   (a4)
                clr.b   object_control(a1)
                clr.b   jumping(a1)
                bra.s   S3CNZSpiral_IntegrateExitMotion

; =============== S U B R O U T I N E =======================================

InitializeCnzSpiralExitRoute:
                andi.w  #$F,d0
                add.w   d0,d0
                lea     (S3CNZSpiral_ExitRouteTable).l,a2
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,4(a4)
                subq.w  #4,4(a4)
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)
                move.l  a2,6(a4)
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  #$C00,d2

S3CNZSpiral_CalcSegmentVelocity:
                moveq   #0,d0
                move.w  d2,d3
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                bge.s   S3CNZSpiral_CalcSignedYDelta
                neg.w   d0
                neg.w   d2

S3CNZSpiral_CalcSignedYDelta:
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                bge.s   S3CNZSpiral_PickDominantAxis
                neg.w   d1
                neg.w   d3

S3CNZSpiral_PickDominantAxis:
                cmp.w   d0,d1
                blo.s   S3CNZSpiral_CalcXDominantSpeed
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                swap    d1
                divs.w  d3,d1
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                beq.s   S3CNZSpiral_StoreYDominantSpeed
                swap    d0
                divs.w  d1,d0

S3CNZSpiral_StoreYDominantSpeed:
                move.w  d0,x_vel(a1)
                move.w  d3,y_vel(a1)
                tst.w   d1
                bpl.s   S3CNZSpiral_StoreYDominantDuration
                neg.w   d1

S3CNZSpiral_StoreYDominantDuration:
                move.w  d1,2(a4)
                rts
; ---------------------------------------------------------------------------

S3CNZSpiral_CalcXDominantSpeed:
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                swap    d0
                divs.w  d2,d0
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                beq.s   S3CNZSpiral_StoreXDominantSpeed
                swap    d1
                divs.w  d0,d1

S3CNZSpiral_StoreXDominantSpeed:
                move.w  d1,y_vel(a1)
                move.w  d2,x_vel(a1)
                tst.w   d0
                bpl.s   S3CNZSpiral_StoreXDominantDuration
                neg.w   d0

S3CNZSpiral_StoreXDominantDuration:
                move.w  d0,2(a4)
                rts
; End of function InitializeCnzSpiralExitRoute

; ---------------------------------------------------------------------------
S3CNZSpiral_ExitRouteTable:
                dc.w    S3CNZSpiral_FirstLeftExit-S3CNZSpiral_ExitRouteTable
                dc.w    S3CNZSpiral_FirstRightExit-S3CNZSpiral_ExitRouteTable
                dc.w    S3CNZSpiral_SecondLeftExit-S3CNZSpiral_ExitRouteTable
                dc.w    S3CNZSpiral_SecondRightExit-S3CNZSpiral_ExitRouteTable
S3CNZSpiral_FirstLeftExit:  dc.w    $C
                dc.w    $1390,  $2D0
                dc.w    $1230,  $2D0
                dc.w    $1230,  $300
S3CNZSpiral_FirstRightExit: dc.w    $C
                dc.w    $13F0,  $2D0
                dc.w    $1560,  $2D0
                dc.w    $1560,  $280
S3CNZSpiral_SecondLeftExit: dc.w    $C
                dc.w    $2090,  $650
                dc.w    $2030,  $650
                dc.w    $2030,  $680
S3CNZSpiral_SecondRightExit:    dc.w    $C
                dc.w    $20F0,  $650
                dc.w    $21E0,  $650
                dc.w    $21E0,  $600
