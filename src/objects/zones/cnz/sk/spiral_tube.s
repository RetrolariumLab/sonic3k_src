; Owner: objects/zones/cnz/sk
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
                beq.s   SKCNZSpiral_CullWhenIdle
                rts
; ---------------------------------------------------------------------------

SKCNZSpiral_CullWhenIdle:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInCnzSpiralTube:
                moveq   #0,d0
                move.b  (a4),d0
                move.w  SKCNZSpiral_RiderStateTable(pc,d0.w),d0
                jmp     SKCNZSpiral_RiderStateTable(pc,d0.w)
; End of function UpdatePlayerInCnzSpiralTube

; ---------------------------------------------------------------------------
SKCNZSpiral_RiderStateTable:
                dc.w    SKCNZSpiral_TryCaptureAtEntrance-SKCNZSpiral_RiderStateTable
                dc.w    SKCNZSpiral_OrbitEntrance-SKCNZSpiral_RiderStateTable
                dc.w    SKCNZSpiral_DescendSpiral-SKCNZSpiral_RiderStateTable
                dc.w    SKCNZSpiral_StepExitSegment-SKCNZSpiral_RiderStateTable
; ---------------------------------------------------------------------------

SKCNZSpiral_TryCaptureAtEntrance:
                tst.w   (Debug_placement_mode).w
                bne.w   SKCNZSpiral_EntranceReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$80,d0
                bhs.s   SKCNZSpiral_EntranceReturn
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$10,d1
                cmpi.w  #$20,d1
                bhs.s   SKCNZSpiral_EntranceReturn
                tst.b   object_control(a1)
                bne.s   SKCNZSpiral_EntranceReturn
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
                bhs.s   SKCNZSpiral_AlignEntrantAndPlayRoll
                neg.w   d1
                move.b  #$80,1(a4)

SKCNZSpiral_AlignEntrantAndPlayRoll:
                add.w   x_pos(a0),d1
                move.w  d1,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l

SKCNZSpiral_EntranceReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZSpiral_OrbitEntrance:
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
                beq.s   SKCNZSpiral_TryBeginDescent
                move.w  #$80,d0

; Match the incremented orbit phase selected by ring-count parity before descending
SKCNZSpiral_TryBeginDescent:
                cmp.b   1(a4),d0
                bne.s   SKCNZSpiral_OrbitReturn
                addq.b  #2,(a4)
                move.w  #$C0,2(a4)

SKCNZSpiral_OrbitReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZSpiral_DescendSpiral:
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
                bne.s   SKCNZSpiral_DescentReturn
                moveq   #0,d0
                move.w  x_pos(a0),d1
                sub.w   x_pos(a1),d1
                bcc.s   SKCNZSpiral_SelectExitRoute
                moveq   #1,d0

SKCNZSpiral_SelectExitRoute:
                add.b   subtype(a0),d0
                bsr.w   InitializeCnzSpiralExitRoute
                addq.b  #2,(a4)

SKCNZSpiral_DescentReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZSpiral_StepExitSegment:
                subq.b  #1,2(a4)
                bpl.s   SKCNZSpiral_IntegrateExitMotion
                movea.l 6(a4),a2
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)
                move.l  a2,6(a4)
                subq.w  #4,4(a4)
                beq.s   SKCNZSpiral_ReleaseAtFinalWaypoint
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  #$C00,d2
                bra.w   SKCNZSpiral_CalcSegmentVelocity
; ---------------------------------------------------------------------------

SKCNZSpiral_IntegrateExitMotion:
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
SKCNZSpiral_ReleaseAtFinalWaypoint:
                andi.w  #$FFF,y_pos(a1)
                clr.b   (a4)
                clr.b   object_control(a1)
                clr.b   jumping(a1)
                bra.s   SKCNZSpiral_IntegrateExitMotion

; =============== S U B R O U T I N E =======================================

InitializeCnzSpiralExitRoute:
                andi.w  #$F,d0
                add.w   d0,d0
                lea     (SKCNZSpiral_ExitRouteTable).l,a2
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

SKCNZSpiral_CalcSegmentVelocity:
                moveq   #0,d0
                move.w  d2,d3
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                bge.s   SKCNZSpiral_CalcSignedYDelta
                neg.w   d0
                neg.w   d2

SKCNZSpiral_CalcSignedYDelta:
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                bge.s   SKCNZSpiral_PickDominantAxis
                neg.w   d1
                neg.w   d3

SKCNZSpiral_PickDominantAxis:
                cmp.w   d0,d1
                blo.s   SKCNZSpiral_CalcXDominantSpeed
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                swap    d1
                divs.w  d3,d1
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                beq.s   SKCNZSpiral_StoreYDominantSpeed
                swap    d0
                divs.w  d1,d0

SKCNZSpiral_StoreYDominantSpeed:
                move.w  d0,x_vel(a1)
                move.w  d3,y_vel(a1)
                tst.w   d1
                bpl.s   SKCNZSpiral_StoreYDominantDuration
                neg.w   d1

SKCNZSpiral_StoreYDominantDuration:
                move.w  d1,2(a4)
                rts
; ---------------------------------------------------------------------------

SKCNZSpiral_CalcXDominantSpeed:
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                swap    d0
                divs.w  d2,d0
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                beq.s   SKCNZSpiral_StoreXDominantSpeed
                swap    d1
                divs.w  d0,d1

SKCNZSpiral_StoreXDominantSpeed:
                move.w  d1,y_vel(a1)
                move.w  d2,x_vel(a1)
                tst.w   d0
                bpl.s   SKCNZSpiral_StoreXDominantDuration
                neg.w   d0

SKCNZSpiral_StoreXDominantDuration:
                move.w  d0,2(a4)
                rts
; End of function InitializeCnzSpiralExitRoute

; ---------------------------------------------------------------------------
SKCNZSpiral_ExitRouteTable:
                dc.w    SKCNZSpiral_FirstLeftExit-SKCNZSpiral_ExitRouteTable
                dc.w    SKCNZSpiral_FirstRightExit-SKCNZSpiral_ExitRouteTable
                dc.w    SKCNZSpiral_SecondLeftExit-SKCNZSpiral_ExitRouteTable
                dc.w    SKCNZSpiral_SecondRightExit-SKCNZSpiral_ExitRouteTable
SKCNZSpiral_FirstLeftExit:  dc.w    $C
                dc.w    $1390,  $2D0
                dc.w    $1230,  $2D0
                dc.w    $1230,  $300
SKCNZSpiral_FirstRightExit: dc.w    $C
                dc.w    $13F0,  $2D0
                dc.w    $1560,  $2D0
                dc.w    $1560,  $280
SKCNZSpiral_SecondLeftExit: dc.w    $C
                dc.w    $2090,  $650
                dc.w    $2030,  $650
                dc.w    $2030,  $680
SKCNZSpiral_SecondRightExit:    dc.w    $C
                dc.w    $20F0,  $650
                dc.w    $21E0,  $650
                dc.w    $21E0,  $600
